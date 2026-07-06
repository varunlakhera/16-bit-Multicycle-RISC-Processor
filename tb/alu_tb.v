`timescale 1ns/1ps
`include"alu.v"

module alu_tb();

reg [2:0] alu_op;
reg [15:0] a, b;
wire [15:0] result; 
wire carry, zero;

alu uut(alu_op, a, b, result, carry, zero);

localparam ADD = 3'd0, SUB = 3'd1, MUL = 3'd2, AND = 3'd3, ORA = 3'd4, IMP = 3'd5;


initial begin
    $dumpfile("alu_tb.vcd");
    $dumpvars(0,alu_tb);

    alu_op = 0; a = 0; b = 0;

    #10;
    alu_op = ADD;
    a = 16'd23; b = 16'd45;
    
    #10;
    
    $display("ADD, a = %0d, b = %0d, result = %0d, carry = %b, zero = %b", a, b, result, carry, zero);
    #10;
    alu_op = SUB;
    a = 16'd51; b = 16'd22;
    
    #10;
    $display("SUB, a = %0d, b = %0d, result = %0d, carry = %b, zero = %b", a, b, result, carry, zero);
    #10;
    alu_op = MUL;
    a = 16'd12; b = 16'd11;
    
    #10;
    $display("MUL, a = %0d, b = %0d, result = %0d, carry = %b, zero = %b", a, b, result, carry, zero);
    #10;
    alu_op = AND;
    a = 16'b0101_0101_0111_1101; b = 16'b1111_1010_0011_0001;
    
    #10;
    $display("AND, a = %b, b = %b, result = %b, carry = %b, zero = %b", a, b, result, carry, zero);
    #10;
    alu_op = ORA;
    a = 16'b0101_0101_0111_1101; b = 16'b1111_1010_0011_0001;
    
    #10;
    $display("ORA, a = %b, b = %b, result = %b, carry = %b, zero = %b", a, b, result, carry, zero);
    #10;
    alu_op = IMP;
    a = 16'b0101_0101_0111_1101; b = 16'b1111_1010_0011_0001;
    
    #10;
    $display("IMP, a = %b, b = %b, result = %b, carry = %b, zero = %b", a, b, result, carry, zero);
    #10;
    alu_op = SUB;
    a = 16'd21; b = 16'd21;
    
    #10;
    $display("SUB, a = %0d, b = %0d, result = %0d, carry = %b, zero = %b", a, b, result, carry, zero);
    #10;
    alu_op = MUL;
    a = 16'd0; b = 16'd15;

    #10;
    $display("MUL, a = %0d, b = %0d, result = %0d, carry = %b, zero = %b", a, b, result, carry, zero);


    #20
    $finish;
end
endmodule