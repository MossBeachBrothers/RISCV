//set timescale for simulation
`timescale 1ns/1ps

module Risc_16_bit(
    input clk
);

//Define wires
wire jump; //if processor should execute conditional jump
wire bne //Branch Not Equal - determine if two registers or values are not equal
wire beq //Branch Equal - determine if two registers or values are equal

wire mem_read,mem_write //if processor should read/write from memory
wire alu_src; //determines source of ALU
wire reg_dst; //destination for register writes
wire mem_to_reg; //specifies if data from memory should be written back to register
wire reg_write; //enables/disables register writes

wire[1:0] alu_op; //2 bit wire to specify operation by ALU
wire[3:0] op_code; //4 bit wire representing op code of instruction

