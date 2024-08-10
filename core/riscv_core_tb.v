module tb_riscv_core;
    reg clk;
    reg reset;

    riscv_core uut (
        .clk(clk),
        .reset(reset)
    );

    initial begin
        $dumpfile("riscv_core_tb.vcd");
        $dumpvars(0, tb_riscv_core);
        clk = 0;
        reset = 1;
        #5 reset = 0;

        // Wait for the core to go through the states
        #500 $finish;
    end

    always #5 clk = ~clk;

    // Monitor the state and PC
    initial begin
        $monitor("Time: %0t | PC: %h | State: %b | Instruction: %h", $time, uut.pc, uut.current_state, uut.ifu_inst.instruction);
    end
endmodule
