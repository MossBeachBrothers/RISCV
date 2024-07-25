module control_unit (
    input logic [31:0] instruction,

    output logic [4:0] alu_op, 
    output logic [4:0] reg_read_address1,
    output logic [4:0] reg_read_address2,
    output logic [4:0] reg_write_address,
    output logic [11:0] immediate,
    output logic [2:0] load_operation,
    output logic [2:0] store_operation,
    output logic mem_read_enable,
    output logic mem_write_enable,
    output logic reg_read_enable, 
    output logic reg_write_enable,
    output logic jump,
);


    localparam R_TYPE = 7'b0110011;
    local I_TYPE = 7'b0010011;
    localparam LOAD = 7'b0000011;
    localparam STORE = 7'b0100011;


    localparam JAL =  7'b1101111: //Jump and Link
    localparam JALR = 7'b1100111 //Jump and Link Register



     //R-Type Operations
    localparam ADD_SUB  = 3'b000; // Add or Subtract
    localparam SLL  = 3'b001; // Logical Shift Left
    localparam SLT  = 3'b010; // Set Less Than
    localparam SLTU = 3'b011; // Set Less Than Unsigned
    localparam XOR  = 3'b100; // XOR bitwise
    localparam SR   = 3'b101; // Shift Right (Logical/Arithmetic)
    localparam OR   = 3'b110; // OR bitwise
    localparam AND  = 3'b111; // AND bitwise

    //I-Type Operations
    localparam ADDI  = 3'b000; // ADD
    localparam SLLI  = 3'b001; // Logical Shift Left
    localparam SLTI  = 3'b010; // Set less than (signed)
    localparam SLTUI = 3'b011; // Set less than (unsigned)
    localparam XORI  = 3'b100; // XOR bitwise
    localparam SRI  = 3'b101; // Shift Right (Logical/Arithmetic)
    localparam ORI   = 3'b110; // OR bitwise
    localparam ANDI  = 3'b111; // AND bitwise


    always_comb begin
        //undefined values
        immediate = 12'bxxxxxxxxxxxx;
        alu_op = 5'bxxxxx;
        load_operation = 3'bxxx;
        store_operation = 3'bxxx;

        mem_read_enable = 0;
        mem_write_enable = 0;
        reg_read_enable = 0;
        reg_write_enable = 0;

        //Jump Link, Jump Link Register
        jump = 0;
        is_jal = 0; //jump to specified address and saves address of next instruction in register
        is_jalr = 0; //jump to address by calculating immediate value in register, saves address
        imm_j = 32'b0;

        //source registers
        reg_read_address1 = instruction[19:15]; //source reg 1
        reg_read_address2 = 5'bxxxxxx; //source reg 2
        //destinations
        reg_write_addr = instruction[11:7];

        if (instruction != 32'b0) begin
            case (instruction[6:0])
                        R_TYPE: begin
                            //get data from register 2
                            reg_read_address2 = instruction[24:20]

                            //set reg read/write
                            reg_read_enable = 1;
                            reg_write_enable = 1;
                            //set alu op
                            case (instruction[14:12])
                                ADD_OR_SUB: alu_op = (instruction[30] ? 5'b00001: 5'b00000); //add or subtract
                                SLL: alu_op = 5'b00010;
                                SLT: alu_op = 5'b00011; 
                                SLTU: alu_op = 5'b00100;
                                XOR: alu_op = 5'b00101;
                                SR: alu_op = (instruction[30] ? 5'b00111 : 5'b00110); //preserve sign SRA / SRL 
                                OR: alu_op = 5'b01000;
                                AND : alu_op = 5'b01001; 
                            endcase
                        end
                        I_TYPE: begin
                            //get immediate value
                            immediate = instruction[31:20];
                            //set reg read/write
                            reg_read_enable = 1;
                            reg_write_enable = 1;
                            //set alu op
                            case (instruction[14:12])
                                ADDI: alu_op = 5'b01010;
                                SLLI: alu_op = 5'b01011;
                                SLTI: alu_op = 5'b01100;
                                SLTUI: alu_op = 5'b01101;
                                XORI: alu_op = 5'b01110;
                                SRI: begin end
                                ORI: alu_op = 5'b10001;
                                ANDI: alu_op = 5'b10010;
                            
                            endcase
                        end
                        //read data from memory into register
                        LOAD: begin 
                            //set memory read
                            mem_read_enable = 1;
                            //set reg write
                            reg_write_enable = 1;
                            //get immediate value
                            immediate = instruction[31:20];
                            //load_operation
                            load_operation = instruction[14:12]
                            alu_op = 5'b01010 //Add code to add immediate to reg address


                        end
                        //write data from register to memory
                        STORE: begin
                            //immediate used to compute memory addres to store
                            immediate = {instruction[31:25], instruction[11:7]};
                            
                            //type of store operation, byte, halfword, word
                            store_operation = instruction[14:12]
                            //source register whos value will be written to memory
                            reg_read_address2 = instruction[24:20];
                            
                            //set reg read, mem write
                            reg_read_enable = 1;
                            mem_write_enable = 1;
                            alu_op = 5'b01010; //Add code to add immediate to reg address
                        end
                        JAL: begin
                        end
                        JALR: begin
                        end
            endcase


        end


endmodule
