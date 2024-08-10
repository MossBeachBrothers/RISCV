module RF (
    input clk,
    input ctrl_reg_write_enable,
    input [4:0] read_reg1,
    input [4:0] read_reg2,
    input [4:0] write_reg,
    input [31:0] write_data,
    output reg [31:0] read_data1,
    output reg [31:0] read_data2,
    output reg stat_reg_write_done
);

reg [31:0] registers [0:31];

always @(posedge clk) begin
    read_data1 <= registers[read_reg1];
    read_data2 <= registers[read_reg2];
    
    if (ctrl_reg_write_enable) begin
        registers[write_reg] <= write_data;
        stat_reg_write_done <= 1'b1;
        $display("Time: %0t | RF: Write Data %h to Register %h", $time, write_data, write_reg);
    end else begin
        stat_reg_write_done <= 1'b0;
    end
end

endmodule
