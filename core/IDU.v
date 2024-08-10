module IDU (
    input clk,
    input reset,
    input ctrl_decode_enable,
    input [31:0] instruction,
    output reg stat_instruction_decoded,
    output reg [4:0] rd,
    output reg [4:0] rs1,
    output reg [4:0] rs2,
    output reg [31:0] immediate,
    output reg is_r_type,
    output reg is_i_type,
    output reg is_load,
    output reg is_store,
    output reg is_branch,
    output reg is_jump,
    output reg [3:0] alu_control
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        stat_instruction_decoded <= 1'b0;
    end else if (ctrl_decode_enable) begin
        // Example decoding logic
        rs1 <= instruction[19:15];
        rs2 <= instruction[24:20];
        rd <= instruction[11:7];
        immediate <= instruction[31:20];
        is_r_type <= (instruction[6:0] == 7'b0110011);
        is_i_type <= (instruction[6:0] == 7'b0010011);
        is_load <= (instruction[6:0] == 7'b0000011);
        is_store <= (instruction[6:0] == 7'b0100011);
        is_branch <= (instruction[6:0] == 7'b1100011);
        is_jump <= (instruction[6:0] == 7'b1101111);
        alu_control <= 4'b0010; // Example control
        stat_instruction_decoded <= 1'b1;
        $display("Time: %0t | IDU: Decoded Instruction -> rd: %h, rs1: %h, rs2: %h, immediate: %h", $time, rd, rs1, rs2, immediate);
    end else begin
        stat_instruction_decoded <= 1'b0;
    end
end

endmodule
