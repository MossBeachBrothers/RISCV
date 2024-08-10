module PC (
    input clk,
    input reset,
    input pc_write_enable,
    input [31:0] pc_next,
    output reg [31:0] pc
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        pc <= 32'b0;
    end else if (pc_write_enable) begin
        pc <= pc_next;
    end
end

endmodule
