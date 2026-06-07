`timescale 1ns / 1ps
`include "cpu_top.v"

module tb_alu;
    reg clk;
    reg reset;

    cpu_top uut (.clk(clk), .reset(reset));

    always #5 clk = ~clk;

    initial begin
        clk = 0; reset = 1;
        $dumpfile("alu_wave.vcd"); $dumpvars(0, tb_alu);

        // PROGRAM 1: Testing ALU (ADD, SUB, MUL)
        // 0. ADI R1, R0, 15  (R1 = 15)
        // 1. ADI R2, R0, 10  (R2 = 10)
        // 2. ADD R3, R1, R2  (R3 = 15 + 10 = 25)
        // 3. SUB R4, R1, R2  (R4 = 15 - 10 = 5)
        // 4. MUL R5, R1, R2  (R5 = 15 * 10 = 150)
        uut.memory_inst.mem[0] = 16'h104F; 
        uut.memory_inst.mem[1] = 16'h108A; 
        uut.memory_inst.mem[2] = 16'h0298; 
        uut.memory_inst.mem[3] = 16'h22A0; 
        uut.memory_inst.mem[4] = 16'h32A8; 
        
        #20; reset = 0;
        #350; // Wait for execution

        $display("========================================");
        $display("          ALU TEST RESULTS              ");
        $display("R3 (ADD) Expected: 25,  Got: %d", uut.datapath_inst.reg_file_inst.R[3]);
        $display("R4 (SUB) Expected: 5,   Got: %d", uut.datapath_inst.reg_file_inst.R[4]);
        $display("R5 (MUL) Expected: 150, Got: %d", uut.datapath_inst.reg_file_inst.R[5]);
        
        if (uut.datapath_inst.reg_file_inst.R[3] == 25 && 
            uut.datapath_inst.reg_file_inst.R[4] == 5 && 
            uut.datapath_inst.reg_file_inst.R[5] == 150)
            $display(" -> [SUCCESS] ALU IS WORKING PERFECTLY.");
        else
            $display(" -> [FAILED]  ALU HAS A BUG.");
        $display("========================================\n");
        $finish;
    end
endmodule
