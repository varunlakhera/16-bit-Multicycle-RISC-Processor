`timescale 1ns / 1ps

`include "alu.v"

module alu_tb;

    // Inputs
    reg [2:0] alu_op;
    reg [15:0] a;
    reg [15:0] b;

    // Outputs
    wire [15:0] result;
    wire carry;
    wire zero;

    // Instantiate the Unit Under Test (UUT)
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


        // Initialize Inputs
        a = 16'h000A; // Decimal 10
        b = 16'h0005; // Decimal 5
        alu_op = 3'd0;

        // Monitor changes
        $monitor("Time=%0t | OP=%0d | A=%h | B=%h | Result=%h | Carry=%b | Zero=%b", 
                 $time, alu_op, a, b, result, carry, zero);

        // Test ADD
        #10 alu_op = 3'd0; 
        
        // Test SUB
        #10 alu_op = 3'd1; 
        
        // Test MUL (Note: your module only multiplies lower 4 bits [cite: 102])
        #10 alu_op = 3'd2; 
        
        // Test AND
        #10 alu_op = 3'd3; 
        
        // Test ORA
        #10 alu_op = 3'd4; 
        
        // Test IMP
        #10 alu_op = 3'd5; 

        // Test Zero Flag
        #10 a = 16'h0005; b = 16'h0005; alu_op = 3'd1; // SUB 5 - 5 should trigger zero flag

        #10 $finish;
    end
endmodule