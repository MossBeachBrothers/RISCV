module riscv_processor (
    input logic clk, 
    input logic btn_reset, //reset button

    //display data
    output logic [15:0] leds,
    output logic [6:0] seg, //7 segment displays
    output logic [3:0] an, //4 bit segment output
)


logic clk_slow;
logic reset;


logic [31:0] instruction;
logic[31:0] reg_read_data1, reg_read_data2; //data read from register
logic[31:0] mem_read_data //data read from memory


logic[11:0] immediate; //constant 
logic[4:0] reg_read_address1, reg_read_address2, reg_write_address; //register addreses
logic[2:0] load_operation;
logic[2:0] store_operation;
logic[4:0] alu_op

logic[31:0] alu_result; 

logic[31:0] program_counter //current Program Counter
logic[31:0] jump_address
logic jump; 
logic is_jal, is_jalr; //signals for JAl, JALR




//Control Signals
logic mem_read_enable, mem_write_enable;
logic reg_read_enable, reg_write_enable;



//Clock and Reset
debounce debounce_inst (
    .clk(clk),
    .btn(btn_reset),
    .btn_clean(result)
);

//Slow Clock





//Instruction Fetchs
program_counter pc_inst (
    //input
    .clk(clk),
    .reset(reset),
    .jump(jump), //if jump, load data from jump_address
    .jump_address(alu_result),

    //output
    .pc(program_counter) //address of next pc instruction
)

memory memory_inst (
    //input 
    .clk(clk),
    .reset(reset),
    .mem_address(alu_result),
    .store_operation(store_operation),
    .mem_read_enable(mem_read_enable),
    .mem_write_enable(mem_write_enable),
    .reg_read_enable(reg_read_enable),
    .reg_data(reg_read_data2),
    .instruction_address(program_counter) //next address from pc

    //output
    .instruction(instruction), //32 bit instruction
    .mem_read_data(mem_read_data) //data read from mem
)

//Instruction Decode

control_unit control_unit_inst (
    //input
    .instruction(instruction),

    //output

    //op codes
    .alu_op(alu_op),
    .immediate(immediate),
    .load_operation(load_operation),
    .store_operation(store_operation),
    .jump(jump),
    .is_jal(is_jal),
    .is_jalr(is_jalr),
    
    //address
    .reg_read_address1(reg_read_address1),
    .reg_read_address2(reg_read_address2),
    .reg_write_address(reg_write_address),

    //control signal 
    .mem_read_enable(mem_read_enable),
    .mem_write_enable(mem_write_enable),
    .reg_read_enable(reg_read_enable),
    .reg_write_enable(reg_write_enable),
    .imm_j(imm_j) //immediate jump address J-Type
)

//Execute
register_file register_file_inst (
    //input
    .clk(clk),
    .reset(reset),

    //addresses
    .reg_read_address1(reg_read_address1),
    .reg_read_address2(reg_read_address2),
    .reg_write_address(reg_write_address),
    .reg_write_data(alu_result), //write data from alu result
    .mem_read_data(mem_read_data), //get data from memory

    //control signals
    .mem_read_enable(mem_read_enable),
    .reg_read_enable(reg_read_enable),
    .reg_write_enable(reg_write_enable),

    //output

    //data
    .reg_read_data1(reg_read_data1),
    .reg_read_data2(reg_read_data2), 
)


alu alu_inst (
    .operandA(reg_read_data1), //Operand A
    .operandB(reg_read_data2), //Operand B
    .immediate(immediate), //constant
    .op_code(alu_op),

    //output
    .result(alu_result),
    .zero() //indicates whether result is 0
)

//alu_result ---> program_counter as jump address if jump
//alu_result ---> memory 
//Memory

//Determine Jumping
always_comb begin
    if (is_jal) begin
        jump_address = program_counter + imm_j; //JAL
    end else if (is_jalr) begin
        jump_address = reg_read_data1 + immediate; //JALR
    end else begin
        jump_address = 32'b0 //set default
    end
end

//Clock
always_ff @(posedge clk_slow or posedge reset) begin
    if (reset) begin
        $display("Resetting at time: %0t", $time);
    end else begin
        $display("Instruction : %h", instruction);
    end
end


//Display to LEDs
// LED assignments
assign leds[0] = alu_op[0]; // Least significant bit of ALU operation
assign leds[1] = alu_op[1];
assign leds[2] = alu_op[2];
assign leds[3] = alu_op[3];
assign leds[4] = alu_op[4];
assign leds[5] = mem_read_enable;
assign leds[6] = mem_write_enable;
assign leds[7] = reg_write_enable;
assign leds[8] = instruction[30]; //function 7 toggle
assign leds[9]  = instruction[14];  //function3 [2]
assign leds[10]  = instruction[13];  //function3 [1]
assign leds[11] = instruction[12];  //function3 [0]
assign leds[12] = (instruction[6:0] == 7'b0110011 ) ? 1 : 0; // Register-Type
assign leds[13] = (instruction[6:0] == 7'b0010011 ) ? 1 : 0; // Immediate-Type
assign leds[14] = (instruction[6:0] == 7'b0000011 ) ? 1 : 0; // Loading
assign leds[15] = (instruction[6:0] == 7'b0100011 ) ? 1 : 0; // Storing

endmodule