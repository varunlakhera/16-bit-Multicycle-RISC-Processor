`timescale 1ns/1ps
`include "instruction_counter.v"

module instruction_tb();

reg clk, reset, ir_load;
reg [15:0] ir_in;
wire [15:0] ir_out;

instruction_counter uut(clk, reset, ir_load, ir_in, ir_out);

always #5 clk = ~clk;

initial begin

    $dumpfile("instruction_tb.vcd");
    $dumpvars(0,instruction_tb);
    clk = 0; reset = 1;
    ir_load = 0;

    #10;
    reset = 0; ir_load = 1;
    ir_in = 16'hABCD;
    #10;
    $display("INSTRUCTION = %h",ir_out);

    #20;
    $finish;
end
endmodule