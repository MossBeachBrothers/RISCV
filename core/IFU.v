module IFU (
    input wire clk,
    input wire reset,
    input wire ctr_mem_read_enable,
    input wire [31:0] pc,  // Program counter input
    output reg [31:0] instruction,  // 32-bit instruction output
    output reg stat_instruction_fetched
);
    // Instruction memory or fetching logic here

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            instruction <= 32'b0;
            stat_instruction_fetched <= 1'b0;
        end else if (ctr_mem_read_enable) begin
            // Example: Fetch instruction from memory based on the PC
            // instruction <= memory[pc];
            stat_instruction_fetched <= 1'b1;
        end
    end
endmodule
