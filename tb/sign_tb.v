`timescale 1ns/1ps
`include "sign_extend.v"

module sign_tb();

reg mode;
reg [8:0] imm_in;
wire [15:0] imm_out;

sign_extend uut(imm_in, mode, imm_out);

initial begin
    $dumpfile("sign_tb.vcd");
    $dumpvars(0,sign_tb);

    mode = 0;
    imm_in = 9'b101010101;
    #1;
    $display("mode = %b, imm_in = %b, imm_out = %b", mode, imm_in, imm_out);

    #10;
    mode  = 1;
    imm_in = 6'b110101;
    #1;
    $display("mode = %b, imm_in = %b, imm_out = %b", mode, imm_in, imm_out);

    #20;
    $finish;
end
endmodule    