module register_file (
    input logic clk,
    input logic reset,
    input logic [4:0] reg_read_address1, //source addr 1
    input logic [4:0] reg_read_address2, //source addr 2
    input logic [4:0] reg_write_address, //desination address
    input logic [31:0] reg_write_data, //data to write to register (from ALU)
    input logic [2:0] load_operation, //3 bits for LB, LH, LW, LBU, LHU

    input logic reg_read_enable,
    input logic reg_write_enable, 
    input logic mem_read_enable, 

    input logic [31:0] mem_read_data, //data from memory address to be written
    
    output logic [31:0] reg_read_data1,
    output logic [31:0] reg_read_data2,
)


//To start, define an array of 32 registers, each 32 bits wide
logic [31:0] registers [0:31];

//Load Operations
localparam LB = 3'b000; //loads Byte, sign extends to 32
localparam LH = 3'b001; //loads Halfword (2 byte), sign extends to 32
localparam LW = 3'b010; //loads Word, 32 bits from memory into register
//unsigned
localparam LBU = 3'b100; //load Byte and zero extends to 32 
localparam LHU = 3'b101; //loads Halfword (2 byte) and zero extends to 32


//assign output values
assign reg_read_data1 = reg_read_address1 ? registers[reg_read_address1] : 32'b0;
assign reg_read_data2 = reg_read_address2 ? registers[reg_read_address2] : 32'b0;


always @(posedge clk or posedge reset) begin
    if (reset) begin 
        //if reset is high, set all reg to 0
        integer i;
        for (i =0; i<32; i=i+1) begin 
            registers[i] = 32'h00000000;
        end

        registers[1] = 32'h00000002;  // rs1
        registers[2] = 32'h00000007;  // rs2
        registers[4] = 32'h00000010;  // rs4
        registers[5] = 32'hFFFFFFF0;  // rs5
        registers[7] = 32'h00000014;  // rs7




    end else if (reg_write_enable && (reg_write_address !=0)) begin
    //if enable is high and write address isnt zero, write operation will perform
    //depending on load operation, set different data
        if (mem_read_enable) begin

            case(load_operation)
            LB : registers[reg_write_address] = {{24{mem_read_data[7]}}, mem_read_data[7:0]}; // load byte and sign extend to 32
            LH : registers[reg_write_address] = {{16{mem_read_data[15]}}, mem_read_data[15:0]}; //load halfword and sign extend to 32
            LW : registers[reg_write_address] = mem_read_data; //load 32 bit word
            LBU : registers[reg_write_address] = {24'b0, mem_read_data[7:0]} //load byte and zero extend to 32
            LHU: registers[reg_write_address] = {16'b0, mem_read_data[15:0]} //load halfword and zero extend to 32
            endcase

        end else begin 
            //Normal write operation
            registers[reg_write_address] = reg_write_data;
        
        end

         
    
    end

end 


endmodule 





