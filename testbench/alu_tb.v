`timescale 1ns / 1ps

`include "alu.v"

module alu_tb;
    reg [2:0] alu_op;
    reg [15:0] a;
    reg [15:0] b;
    wire [15:0] result;
    wire carry;
    wire zero;
  
    alu uut (
        .alu_op(alu_op), 
        .a(a), 
        .b(b), 
        .result(result), 
        .carry(carry), 
        .zero(zero)
    );

    initial begin
        $dumpfile("alu.vcd");
        $dumpvars(0, alu_tb);


        a = 16'h000A;
        b = 16'h0005;
        alu_op = 3'd0;

        $monitor("Time=%0t | OP=%0d | A=%h | B=%h | Result=%h | Carry=%b | Zero=%b", 
                 $time, alu_op, a, b, result, carry, zero);

        #10 alu_op = 3'd0; 
        
        #10 alu_op = 3'd1; 

        #10 alu_op = 3'd2; 
        
        #10 alu_op = 3'd3; 
        
        #10 alu_op = 3'd4; 
        
        #10 alu_op = 3'd5; 

        #10 a = 16'h0005; b = 16'h0005; alu_op = 3'd1; 

        #10 $finish;
    end
endmodule
