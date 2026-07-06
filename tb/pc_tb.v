`timescale 1ns/1ps
`include "pc_counter.v"
module pc_tb();

reg clk,reset, pc_write;
reg [15:0] pc_in;
wire [15:0] pc_out;

pc_counter uut(clk, reset, pc_write, pc_in, pc_out);

always #5 clk = ~clk;

initial begin

    $dumpfile("pc_tb.vcd");
    $dumpvars(0,pc_tb);
    clk = 0; reset = 1; pc_write = 0; pc_in = 0;

    #10;
    $display("reset : %b, pc_write : %b, pc_in : %0d, pc_out : %0d",reset, pc_write, pc_in, pc_out);
    #10;
    pc_write = 1;
    pc_in = 16'd88;
    #10;
    $display("reset : %b, pc_write : %b, pc_in : %0d, pc_out : %0d",reset, pc_write, pc_in, pc_out);
    
    #10;
    reset = 0;
    #10;
    $display("reset : %b, pc_write : %b, pc_in : %0d, pc_out : %0d",reset, pc_write, pc_in, pc_out);
    
    #10;
    pc_write = 0;
    pc_in = 16'd211;
    #10;
    $display("reset : %b, pc_write : %b, pc_in : %0d, pc_out : %0d",reset, pc_write, pc_in, pc_out);

    #20;
    $finish;
end
endmodule
