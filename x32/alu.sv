module alu ( 
    input logic [31:0] operandA, //Operand A
    input logic [31:0] operandB, //Operand B
    input logic [11:0] immediate, //constant
    input logic [3:0] op_code, //specifies ALU op

    output logic [31:0] alu_result,
    output logic zero //indicates if result was zero
)


//Register to Register Instructions
localparam ADD = 5'b00000; //add A and B

localparam SUB = 5'b00001; //subtract B from A

localparam SLL = 5'b00010; //shift A to left by lower 5 bits of B

localparam SLT = 5'b00011; //1 if A less than B, else 0

localparam SLTU = 5'b00100; //1 if A less than B (unsigned), else 0

localparam XOR = 5'b00101; //bitwise op between A and B

localparam SRL = 5'b00110; //shift A to right by lower 5 bits of B

localparam SRA = 5'b00111; //shift A to right by lower 5 bits. Preserves sign by replicating on left

localparam OR = 5'b01000; //bitwise OR between A and B 

localparam AND = 5'b01001; //AND bitwise 

//Immediate Operations
localparam ADDI = 5'b01010; //add A to sign-extended immediate value 

localparam SLLI = 5'b01011; //shift A to left by lower 5 bits of immediate

localparam SLTI = 5'b01100; //1 if A less than sign-extended immediate, else 0

localparam SLTUI = 5'b01101; //1 if A less than sign-extended immmediate (unsigned), else 0

localparam XORI = 5'b01110; //bitwise XOR between A, sign-extended immediate

localparam SRLI = 5'b01111; //shift A to right by lower 5 bits of immediate value 

localparam SRAI = 5'b10000; //shift A to right by lower 5 bits of immediate value, preserves sign bit

localparam ORI = 5'b10001; //bitwise OR between A and sign-extended immediate value 

localparam ANDI = 5'b10010; //bitwise AND between A and sign-extended immediate value


//Immediate Instructions

//sign-extend immediate to 32 bits
logic [31:0] immediate_extended;
assign immediate_extened = {{20{immediate[11]}}, immediate}


always_comb begin
    case (op_code) //perform OP CODE operation
            // R-Type Operations
            ADD:  result = operand_a + operand_b;
            SUB:  result = operand_a - operand_b;
            SLL:  result = operand_a << operand_b[4:0];
            SLT:  result = ($signed(operand_a) < $signed(operand_b)) ? 32'd1 : 32'd0;
            SLTU: result = (operand_a < operand_b) ? 32'd1 : 32'd0; //unsigned
            XOR:  result = operand_a ^ operand_b;
            SRL:  result = operand_a >> operand_b[4:0];
            SRA:  result = $signed(operand_a) >>> operand_b[4:0];
            OR:   result = operand_a | operand_b;
            AND:  result = operand_a & operand_b;

            // I-Type Operations
            ADDI: result = operand_a + immediate_extended;
            SLLI: result = operand_a << immediate_extended[4:0];
            SLTI: result = ($signed(operand_a) < $signed(immediate_extended)) ? 32'd1 : 32'd0;
            SLTUI:result = (operand_a < immediate_extended) ? 32'd1 : 32'd0; //unsigned
            XORI: result = operand_a ^ immediate_extended;
            SRLI: result = operand_a >> immediate_extended[4:0];
            SRAI: result = $signed(operand_a) >>> immediate_extended[4:0];
            ORI:  result = operand_a | immediate_extended;
            ANDI: result = operand_a & immediate_extended;

            default: result = 32'd0
    endcase
    //$display("Time: %0t, ALU Operation: %b, Operand A: %h, Operand B: %h, Immediate: %h, Result: %h", $time, op_code, operand_a, operand_b, immediate, result);

end

assign zero = (result == 32'd0) //set boolean zero

endmodule



