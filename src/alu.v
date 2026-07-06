module alu (input [2:0] alu_op, 
input [15:0] a, b, 
output reg [15:0] result, 
output reg carry, 
output zero);

localparam ADD = 3'd0, SUB = 3'd1, MUL = 3'd2, AND = 3'd3, ORA = 3'd4, IMP = 3'd5;

always @(*) begin
    carry = 0;
    case(alu_op)
        ADD : {carry, result} = a + b;
        SUB : {carry, result} = a - b;
        MUL : result = a[3:0] * b[3:0];  
        AND : result = a & b;   
        ORA : result = a | b;
        IMP : result = ~a|b; 
        default : result = 16'b0;
    endcase
end

assign zero = (result == 16'b0);

endmodule
