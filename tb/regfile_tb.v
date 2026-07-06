`timescale 1ns/1ps
`include "register_file.v"

module regfile_tb();

reg clk, reset, reg_write;
reg [2:0] Ra_addr, Rb_addr, write_addr;
reg [15:0] write_data;
wire [15:0] out_a, out_b;

register_file uut(clk, reset, reg_write, Ra_addr, Rb_addr, write_addr, write_data, out_a, out_b);

always #5 clk = ~clk;

initial begin
    $dumpfile("regfile_tb.vcd");
    $dumpvars(0,regfile_tb);

    clk = 0; reset = 1; reg_write = 0; 
    Ra_addr = 0; Rb_addr = 0; write_addr = 0;
    write_data = 16'hABCD;

    #10 reset = 0;
    #10;

    uut.R[0] = 16'h1234;
    uut.R[1] = 16'h2345;
    uut.R[2] = 16'h3456;
    uut.R[3] = 16'h4567;
    uut.R[4] = 16'h5678;
    uut.R[5] = 16'h6789;
    uut.R[6] = 16'h789A;
    uut.R[7] = 16'h89AB;

    #10;
    Ra_addr = 3'd4; Rb_addr = 3'd7;
    reg_write = 1;
    write_addr = 3'd5;
    $display("Combinational Read : RA = %0h, RB = %0h", out_a, out_b);

    #10;
    $display("Sequential Write   : R[%0d] = %0h", write_addr, uut.R[write_addr]);

    #20;
    $finish;
end
endmodule
