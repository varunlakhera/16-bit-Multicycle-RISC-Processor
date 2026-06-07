`timescale 1ns / 1ps
`include "cpu_top.v"

module tb_memory;
    reg clk;
    reg reset;

    cpu_top uut (.clk(clk), .reset(reset));

    always #5 clk = ~clk;

    initial begin
        clk = 0; reset = 1;
        $dumpfile("mem_wave.vcd"); $dumpvars(0, tb_memory);

        // PROGRAM 2: Testing Load/Store Memory
        // 0. LHI R1, 0xAA   (R1 = 0xAA00)
        // 1. LLI R2, 0xBB   (R2 = 0x00BB)
        // 2. ADD R3, R1, R2 (R3 = 0xAABB)
        // 3. SW  R3, R0, 10 (Store R3 into Memory Address 10)
        // 4. LW  R4, R0, 10 (Load Memory Address 10 into R4)
        uut.memory_inst.mem[0] = 16'h82AA; 
        uut.memory_inst.mem[1] = 16'h94BB; 
        uut.memory_inst.mem[2] = 16'h0298; 
        uut.memory_inst.mem[3] = 16'hB60A; 
        uut.memory_inst.mem[4] = 16'hA80A; 
        
        #20; reset = 0;
        #350; 

        $display("========================================");
        $display("         MEMORY TEST RESULTS            ");
        $display("R4 Expected: aabb (Hex), Got: %h", uut.datapath_inst.reg_file_inst.R[4]);
        
        if (uut.datapath_inst.reg_file_inst.R[4] == 16'haabb)
            $display(" -> [SUCCESS] LHI, LLI, SW, AND LW ARE WORKING PERFECTLY.");
        else
            $display(" -> [FAILED]  MEMORY LOAD/STORE HAS A BUG.");
        $display("========================================\n");
        $finish;
    end
endmodule
