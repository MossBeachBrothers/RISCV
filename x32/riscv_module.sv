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
logic jump;

//Control Signals
logic mem_read_enable, mem_write_enable;
logic reg_read_enable, reg_write_enable;



//Clock and Reset
debounce debounce_inst (
    .clk(clk),
    .btn(btn_reset),
    .btn_clean(result)
);

//Clock?





//Instruction Fetch
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
    .jump(jump)
    
    //address
    .reg_read_address1(reg_read_address1),
    .reg_read_address2(reg_read_address2),
    .reg_write_address(reg_write_address),

    //control signal 
    .mem_read_enable(mem_read_enable),
    .mem_write_enable(mem_write_enable),
    .reg_read_enable(reg_read_enable),
    .reg_write_enable(reg_write_enable),
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


//Write Back


//Display to LEDs


endmodule