`timescale 1ns/1ps
`include "memory.v"

module memory_tb();

reg clk, write, read;
reg [15:0] addr;
reg [15:0] w_data;
wire [15:0] r_data;

memory uut(clk, write, read, addr, w_data, r_data);

always #5 clk = ~clk;

initial begin
    $dumpfile("memory_tb.vcd");
    $dumpvars(0, memory_tb);

    clk = 0; write = 0; read = 0; addr = 0;
    uut.mem[10] = 16'hAAAA;
    uut.mem[12] = 16'hBBBB;

    #10;
    write = 1;
    addr = 16'd11;
    w_data = 16'hABAB;
    
    #10;
    write = 0;
    $display("mem[11] = %0h", uut.mem[11]);

    #10;
    read = 1;
    addr = 16'd10;
    #5;
    $display("read_data = %0h", r_data);
    addr = 16'd11;
    #5;
    $display("read_data = %0h", r_data);
    #5;
    addr = 16'd12;
    #5;
    $display("read_data = %0h", r_data);

    #20;
    $finish;
end
endmodule
