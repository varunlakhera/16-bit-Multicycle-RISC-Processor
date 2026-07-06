`timescale 1ns/1ps
`include "cpu_top.v"

module cpu_tb();

reg clk, reset;

cpu_top uut(clk, reset);

always #5 clk = ~clk;

initial begin
    $dumpfile("cpu_tb.vcd");
    $dumpvars(0,cpu_tb);

    clk = 0; reset = 1;
    
    #10;
    
    $readmemh("program.hex", uut.memory_inst.mem);
    
    #20;
    reset = 0;

    #5000; // waiting for the program to finish

    $display("FINAL REGISTER VALUES : ");
    $display("R0 = %5d (HEX:%4h)", uut.datapath_inst.reg_file_inst.R[0], uut.datapath_inst.reg_file_inst.R[0]);
    $display("R1 = %5d (HEX:%4h)", uut.datapath_inst.reg_file_inst.R[1], uut.datapath_inst.reg_file_inst.R[1]);
    $display("R2 = %5d (HEX:%4h)", uut.datapath_inst.reg_file_inst.R[2], uut.datapath_inst.reg_file_inst.R[2]);
    $display("R3 = %5d (HEX:%4h)", uut.datapath_inst.reg_file_inst.R[3], uut.datapath_inst.reg_file_inst.R[3]);
    $display("R4 = %5d (HEX:%4h)", uut.datapath_inst.reg_file_inst.R[4], uut.datapath_inst.reg_file_inst.R[4]);
    $display("R5 = %5d (HEX:%4h)", uut.datapath_inst.reg_file_inst.R[5], uut.datapath_inst.reg_file_inst.R[5]);
    $display("R6 = %5d (HEX:%4h)", uut.datapath_inst.reg_file_inst.R[6], uut.datapath_inst.reg_file_inst.R[6]);
    $display("R7 = %5d (HEX:%4h)", uut.datapath_inst.reg_file_inst.R[7], uut.datapath_inst.reg_file_inst.R[7]);
    $display("ENDING");
    
    $finish;
end
endmodule
