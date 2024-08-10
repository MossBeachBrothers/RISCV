module riscv_core (
    input clk,
    input reset
);

// State enumeration
parameter WAIT = 3'b000;
parameter FETCH = 3'b001;
parameter DECODE = 3'b010;
parameter EXECUTE = 3'b011;
parameter READ_MEMORY = 3'b100;
parameter WRITE_MEMORY = 3'b101;
parameter READ_REGISTER = 3'b110;
parameter WRITE_REGISTER = 3'b111;

reg [2:0] current_state, next_state;
reg [3:0] wait_count;

// Internal signals
wire [31:0] pc, next_pc, instruction, immediate, alu_result, read_data, write_data;
wire [3:0] alu_control;
wire zero_flag;
wire [4:0] rd, rs1, rs2;

// Control signals decoded from the instruction (as wires)
wire is_r_type;
wire is_i_type;
wire is_load;
wire is_store;
wire is_branch;
wire is_jump;

// Internal control signals for state machine (as regs)
reg ctrl_instruction_mem_read_enable;
reg ctrl_decode_enable;
reg ctrl_alu_op_enable;
reg ctrl_mem_read_enable;
reg ctrl_mem_write_enable;
reg ctrl_reg_write_enable;
reg ctrl_pc_update_enable;
reg ctrl_branch_enable;
reg ctrl_jump_enable;

// Status signals (declared as wire)
wire stat_instruction_fetched, stat_instruction_decoded, stat_reg_write_done, stat_mem_read_done, stat_mem_write_done, stat_execution_done;

// Instantiate the Program Counter
PC pc_inst (
    .clk(clk),
    .reset(reset),
    .pc_write_enable(ctrl_pc_update_enable),
    .pc_next(next_pc),
    .pc(pc)
);

// Instantiate the Instruction Fetch Unit
IFU ifu_inst (
    .clk(clk),
    .reset(reset),
    .ctr_mem_read_enable(ctrl_instruction_mem_read_enable),
    .pc(pc),
    .instruction(instruction),
    .stat_instruction_fetched(stat_instruction_fetched)
);

// Instantiate the Instruction Decode Unit
IDU idu_inst (
    .clk(clk),
    .reset(reset),
    .ctrl_decode_enable(ctrl_decode_enable),
    .instruction(instruction),
    .stat_instruction_decoded(stat_instruction_decoded),
    .rd(rd),
    .rs1(rs1),
    .rs2(rs2),
    .immediate(immediate),
    .is_r_type(is_r_type),
    .is_i_type(is_i_type),
    .is_load(is_load),
    .is_store(is_store),
    .is_branch(is_branch),
    .is_jump(is_jump),
    .alu_control(alu_control)
);

// Instantiate the Register File
RF rf_inst (
    .clk(clk),
    .ctrl_reg_write_enable(ctrl_reg_write_enable),
    .read_reg1(rs1),
    .read_reg2(rs2),
    .write_reg(rd),
    .write_data(write_data),
    .read_data1(read_data),
    .read_data2(immediate),
    .stat_reg_write_done(stat_reg_write_done)
);

// Instantiate the ALU
ALU alu_inst (
    .clk(clk),
    .reset(reset),
    .operand1(read_data),
    .ctrl_alu_op_enable(ctrl_alu_op_enable),
    .operand2(ctrl_alu_op_enable ? immediate : read_data),
    .alu_control(alu_control),
    .result(alu_result),
    .stat_execution_done(stat_execution_done),
    .zero_flag(zero_flag)
);

// Instantiate the Memory Access Unit
MAU mau_inst (
    .clk(clk),
    .ctrl_mem_read(ctrl_mem_read_enable),
    .ctrl_mem_write(ctrl_mem_write_enable),
    .address(alu_result),
    .write_data(read_data),
    .read_data(write_data),
    .stat_mem_read_done(stat_mem_read_done),
    .stat_mem_write_done(stat_mem_write_done)
);

// State Machine Logic
always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= WAIT;
        wait_count <= 4'b0;

        // Reset all control signals
        ctrl_instruction_mem_read_enable <= 1'b0;
        ctrl_decode_enable <= 1'b0;
        ctrl_alu_op_enable <= 1'b0;
        ctrl_mem_read_enable <= 1'b0;
        ctrl_mem_write_enable <= 1'b0;
        ctrl_reg_write_enable <= 1'b0;
        ctrl_pc_update_enable <= 1'b0;
        ctrl_branch_enable <= 1'b0;
        ctrl_jump_enable <= 1'b0;
    end else begin
        current_state <= next_state;
    end

    // Display current state information
    $display("Time: %0t | State: %b | PC: %h | Instruction: %h", $time, current_state, pc, instruction);
end

// Next State Logic and Control Signal Assertion
always @(posedge clk) begin
    // Default de-assertion of internal control signals
    ctrl_instruction_mem_read_enable <= 1'b0;
    ctrl_decode_enable <= 1'b0;
    ctrl_alu_op_enable <= 1'b0;
    ctrl_mem_read_enable <= 1'b0;
    ctrl_mem_write_enable <= 1'b0;
    ctrl_reg_write_enable <= 1'b0;
    ctrl_pc_update_enable <= 1'b0;
    ctrl_branch_enable <= 1'b0;
    ctrl_jump_enable <= 1'b0;

    case (current_state)
        WAIT: begin
            if (wait_count < 2) begin  // Stay in WAIT state for 2 cycles
                wait_count <= wait_count + 1;
                next_state <= WAIT;
            end else begin
                next_state <= FETCH;
                wait_count <= 4'b0;
            end
        end
        FETCH: begin
            ctrl_instruction_mem_read_enable <= 1'b1;
            if (stat_instruction_fetched) begin
                next_state <= DECODE;
            end else begin
                next_state <= FETCH; // Remain in FETCH if not done
            end
        end
        DECODE: begin
            ctrl_decode_enable <= 1'b1;
            if (stat_instruction_decoded) begin
                next_state <= READ_REGISTER;
            end else begin
                next_state <= DECODE; // Remain in DECODE if not done
            end
        end
        READ_REGISTER: begin
            next_state <= EXECUTE;
        end
        EXECUTE: begin
            if (is_r_type || is_i_type) begin
                ctrl_alu_op_enable <= 1'b1;
                if (stat_execution_done) begin
                    ctrl_alu_op_enable <= 1'b0;
                    next_state <= WRITE_REGISTER;
                end else begin
                    next_state <= EXECUTE; // Remain in EXECUTE if not done
                end
            end else if (is_branch) begin
                ctrl_branch_enable <= 1'b1;
                next_state <= WAIT; 
            end else if (is_jump) begin
                ctrl_jump_enable <= 1'b1;
                next_state <= WRITE_REGISTER;
            end else begin
                next_state <= EXECUTE; // Remain in EXECUTE if not done
            end
        end
        READ_MEMORY: begin
            ctrl_mem_read_enable <= 1'b1;
            if (stat_mem_read_done) begin
                next_state <= WRITE_REGISTER;
            end else begin
                next_state <= READ_MEMORY; // Remain in READ_MEMORY if not done
            end
        end
        WRITE_MEMORY: begin
            ctrl_mem_write_enable <= 1'b1;
            if (stat_mem_write_done) begin
                next_state <= WAIT;
            end else begin
                next_state <= WRITE_MEMORY; // Remain in WRITE_MEMORY if not done
            end
        end
        WRITE_REGISTER: begin
            ctrl_reg_write_enable <= 1'b1;
            if (stat_reg_write_done) begin
                next_state <= WAIT;
            end else begin
                next_state <= WRITE_REGISTER; // Remain in WRITE_REGISTER if not done
            end
        end
    endcase
end

endmodule
