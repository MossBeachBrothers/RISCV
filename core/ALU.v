module ALU (
    input clk,
    input reset,
    input ctrl_alu_op_enable,  // Control signal to start ALU operation
    input [31:0] operand1,
    input [31:0] operand2,
    input [3:0] alu_control,    // ALU control signals
    output reg [31:0] result,   // ALU result
    output reg stat_execution_done, // Status signal to indicate ALU operation completion
    output reg zero_flag        // Zero flag for branch decisions
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        stat_execution_done <= 1'b0;
        result <= 32'b0;
        zero_flag <= 1'b0;
    end else if (ctrl_alu_op_enable) begin
        case (alu_control)
            4'b0000: result <= operand1 + operand2;  // ADD operation
            4'b0001: result <= operand1 - operand2;  // SUB operation
            4'b0010: result <= operand1 & operand2;  // AND operation
            4'b0011: result <= operand1 | operand2;  // OR operation
            // Add more ALU operations as needed
            default: result <= 32'b0;
        endcase

        zero_flag <= (result == 32'b0);  // Set zero flag if result is zero
        stat_execution_done <= 1'b1;     // Indicate ALU operation done

        $display("ALU Operation: Operand1=%h | Operand2=%h | Result=%h | ZeroFlag=%b", operand1, operand2, result, zero_flag);
    end
end

endmodule
