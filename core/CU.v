module CU (
    input  [6:0] opcode,  // opcode part of the instruction
    output reg is_r_type,
    output reg is_i_type,
    output reg is_load,
    output reg is_store,
    output reg is_branch,
    output reg is_jump
);

// Combinational logic to determine the instruction type based on the opcode
always @(*) begin
    // Default to false for all instruction types
    is_r_type = 1'b0;
    is_i_type = 1'b0;
    is_load = 1'b0;
    is_store = 1'b0;
    is_branch = 1'b0;
    is_jump = 1'b0;

    case (opcode)
        7'b0110011: is_r_type = 1'b1;  // R-type instructions
        7'b0010011: is_i_type = 1'b1;  // I-type ALU instructions
        7'b0000011: is_load = 1'b1;    // Load instructions (e.g., LW)
        7'b0100011: is_store = 1'b1;   // Store instructions (e.g., SW)
        7'b1100011: is_branch = 1'b1;  // Branch instructions (e.g., BEQ)
        7'b1101111: is_jump = 1'b1;    // Jump instructions (e.g., JAL)
        // Add more cases for different opcodes as needed
        default: ; // Default case does nothing
    endcase
end

endmodule
