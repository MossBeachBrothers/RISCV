//specify time and unit scale of design
`timescale 1ns/1ps

//1 nanosecond per picosecond

module program_counter (
    input wire clk,
    input wire reset,
    input wire [31:0] jump_address,
    input wire jump, 

    output reg [31:0] pc
);

    initial currentPC = 32'h0

    always @(posedge clk or posedge reset)
    begin
        if (reset) begin
            pc <= 32'h0; //if reset, set to zero
        end else if (jump || is_jal || is_jalr) begin
            pc <= jump_address; //if jump, set pc to jump address
        
        end else begin
            pc <= pc + 4; //if neither, move 4 bytes to next instruction
        end

    end
endmodule 


