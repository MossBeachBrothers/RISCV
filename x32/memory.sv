`timscale 1ns / 1ps

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
    logic [31:0] instruction_memory_array [0:255];

    //store data processor manipulates during program execution
    logic [31:0] data_memory_array [0:767];


    