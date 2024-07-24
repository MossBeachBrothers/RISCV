module control_unit (
    input logic [31:0] instruction,

    output logic [4:0] alu_op, 
    output logic [4:0] reg_read_address1,
    output logic [4:0] reg_read_address2,
    output logic [4:0] reg_write_address,
    output logic [11:0] immediate,
    output logic [2:0] load_operation,
    output logic [2:0] store_operation,
    output logic mem_read_enable,
    output logic mem_write_enable,
    output logic reg_read_enable, 
    output logic reg_write_enable,
    output logic jump,
);


    localparam R_TYPE = 7'b0110011;
    local I_TYPE = 7'b0010011;
    localparam LOAD = 7