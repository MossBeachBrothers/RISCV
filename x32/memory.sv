``timescale 1ns / 1ps

module memory (
    input logic clk, 
    input logic reset,
    input logic [31:0] mem_address, //address to store alu_result
    input logic [2:0] store_operation,
    input logic [31:0] reg_data,
    input logic [31:0] instruction_address, //address from program counter

    input logic mem_read_enable,
    input logic mem_write_enable,
    input logic reg_read_enable,


    output logic [31:0] instruction, //output to control unit
    output logic [31:0] mem_read_data //data read from memory

);


    //memory to store program instructions
    logic [31:0] instruction_memory_array [0:255]; //256 words of 32 bits

    //store data processor manipulates during program execution
    logic [31:0] data_memory_array [0:767];


    //memory address range 0 to 192
    localparam DATA_MEMORY_START = 3'd000;
    localparam DATA_MEMORY_END  = 3'd192;

    //types of store operations
    localparam STORE_BYTE = 3'b000; //store byte
    localparam STORE_HALF_WORD = 3'b001;  //store half word
    localparam STORE_WORD = 3'b010; //store word


    //assign output values
    assign mem_read_data = (mem_read_enable && (DATA_MEMORY_START <= mem_address < DATA_MEMORY_END)) ?
            data_memory_array[mem_address >> 2] : 31'b0;

    assign instruction = instruction_memory_array[instruction_address >> 2];

    //memory operations every clock or reset

    always @(posedge clk or posedge reset) begin
    
        if (reset) begin
            //set instruction memory to all zero
            integer i;
            for (i = 0; i < 256; i = i+1) begin
                instruction_memory_array[i] = 32'h00000000;
             end
             
            //set data memory to all zero 
            for (i=0; i < 768; i = i + 1) begin
                data_memory_array[i] = 32'h00000000;
             end

             //set default memory locations
             data_memory_array[5] = 32'hFFFFFFE0;


             //Custom Memory Locations


            //
        end else if (mem_write_enable && (mem_address !=0)) begin
            //store data from register into memory
            if (reg_read_enable) begin
                case (store_operation)
                    STORE_BYTE: data_memory_array[mem_address >> 2] = reg_data[7:0]; //8 bit
                    STORE_HALF_WORD: data_memory_array[mem_address >> 2] = reg_data[15:0]; //16 bit
                    STORE_WORD: data_memory_array[mem_address >> 2] = reg_data; //32 bit
                endcase
             end
         end
    end

endmodule 


