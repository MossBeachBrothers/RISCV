module MAU (
    input clk,
    input ctrl_mem_read,
    input ctrl_mem_write,
    input [31:0] address,
    input [31:0] write_data,
    output reg [31:0] read_data,
    output reg stat_mem_read_done,
    output reg stat_mem_write_done
);

reg [31:0] memory [0:255]; // Example memory array

always @(posedge clk) begin
    if (ctrl_mem_read) begin
        read_data <= memory[address[7:0]];
        stat_mem_read_done <= 1'b1;
        $display("Time: %0t | MAU: Read Data %h from Address %h", $time, read_data, address);
    end else begin
        stat_mem_read_done <= 1'b0;
    end

    if (ctrl_mem_write) begin
        memory[address[7:0]] <= write_data;
        stat_mem_write_done <= 1'b1;
        $display("Time: %0t | MAU: Write Data %h to Address %h", $time, write_data, address);
    end else begin
        stat_mem_write_done <= 1'b0;
    end
end

endmodule
