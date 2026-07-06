
`timescale 1ns / 1ps
`include"cc_register.v"
module cc_tb();

reg clk, reset, carry_out, cc_update;
reg [15:0] alu_result;
wire carry_flag, zero_flag;

cc_register uut(clk, reset, carry_out, cc_update, alu_result, carry_flag, zero_flag);

always #5 clk = ~clk;

initial begin

    $dumpfile("cc_register_tb.vcd");
    $dumpvars(0,cc_tb);
    clk = 0; reset = 1; carry_out = 0; cc_update = 0;
    alu_result = 16'd10;

    #10;
    $display("reset = %b, cc_update = %b, result = %0d, carry_out = %b, carry_flag = %b, zero_flag = %b", reset, cc_update, alu_result, carry_out, carry_flag, zero_flag);

    #10;
    reset = 0;
    alu_result = 16'b0;
    carry_out = 1;
    #10;
    $display("reset = %b, cc_update = %b, result = %0d, carry_out = %b, carry_flag = %b, zero_flag = %b", reset, cc_update, alu_result, carry_out, carry_flag, zero_flag);

    #10;
    cc_update = 1;
    carry_out = 0;
    #10;
    $display("reset = %b, cc_update = %b, result = %0d, carry_out = %b, carry_flag = %b, zero_flag = %b", reset, cc_update, alu_result, carry_out, carry_flag, zero_flag);

    #10;
    alu_result = 16'd5;
    carry_out = 1;
    #10;
    $display("reset = %b, result = %0d, carry_out = %b, carry_flag = %b, zero_flag = %b", reset, alu_result, carry_out, carry_flag, zero_flag);

end
endmodule