///// make sure to keep a program.hex  in the same folder!!!!/////
/// run it directly  in icarus and gtkwave ////


`timescale 1ns / 1ps
`include "cpu_top.v"

module tb_general;
    reg clk;
    reg reset;

    cpu_top uut (
        .clk(clk), 
        .reset(reset)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("cpu_general_wave.vcd"); 
        $dumpvars(0, tb_general);      

        clk = 0;
        reset = 1;

        $readmemh("program.hex", uut.memory_inst.mem);

        #20;
        reset = 0;


        #2000; 

        $display("\n=======================================================");
        $display("              PROGRAM EXECUTION FINISHED               ");
        $display("=======================================================");
        $display("Final Register File State:");
        $display("R0 = %5d  (Hex: %4h)", uut.datapath_inst.reg_file_inst.R[0], uut.datapath_inst.reg_file_inst.R[0]);
        $display("R1 = %5d  (Hex: %4h)", uut.datapath_inst.reg_file_inst.R[1], uut.datapath_inst.reg_file_inst.R[1]);
        $display("R2 = %5d  (Hex: %4h)", uut.datapath_inst.reg_file_inst.R[2], uut.datapath_inst.reg_file_inst.R[2]);
        $display("R3 = %5d  (Hex: %4h)", uut.datapath_inst.reg_file_inst.R[3], uut.datapath_inst.reg_file_inst.R[3]);
        $display("R4 = %5d  (Hex: %4h)", uut.datapath_inst.reg_file_inst.R[4], uut.datapath_inst.reg_file_inst.R[4]);
        $display("R5 = %5d  (Hex: %4h)", uut.datapath_inst.reg_file_inst.R[5], uut.datapath_inst.reg_file_inst.R[5]);
        $display("R6 = %5d  (Hex: %4h)", uut.datapath_inst.reg_file_inst.R[6], uut.datapath_inst.reg_file_inst.R[6]);
        $display("R7 = %5d  (Hex: %4h)", uut.datapath_inst.reg_file_inst.R[7], uut.datapath_inst.reg_file_inst.R[7]);
        $display("=======================================================\n");
        
        $finish;
    end
      
endmodule
