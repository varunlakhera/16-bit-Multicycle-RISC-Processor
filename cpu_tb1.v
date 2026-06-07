`timescale 1ns / 1ps
`include "cpu_top.v"

module tb_cpu_top;

    // Inputs
    reg clk;
    reg reset;

    // Instantiate the CPU
    cpu_top uut (
        .clk(clk), 
        .reset(reset)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;

        $dumpfile("cpu_waveform.vcd"); 
        $dumpvars(0, tb_cpu_top);      

        // ==============================================================
        // TEST PROGRAM:
        // We will execute 3 instructions. 
        // 1. ADI R1, R0, 5   (R1 = R0 + 5)
        // 2. ADI R2, R0, 10  (R2 = R0 + 10)
        // 3. ADD R3, R1, R2  (R3 = 5 + 10 = 15)
        // If the CPU is working perfectly, Register 3 must equal 15 at the end.
        // ==============================================================
        
        // Machine code derived directly from your datapath decoding logic:
        uut.memory_inst.mem[0]  = 16'h1045;  // ADI: Op=0001, Ra=R0, Write=R1, Imm=05
        uut.memory_inst.mem[1]  = 16'h108A;  // ADI: Op=0001, Ra=R0, Write=R2, Imm=10
        uut.memory_inst.mem[2]  = 16'h0298;  // ADD: Op=0000, Ra=R1, Rb=R2, Rc=R3
        uut.memory_inst.mem[3]  = 16'h0000;  // NOP / Halt space
        uut.memory_inst.mem[4]  = 16'h0000;

        // Apply reset for 20ns
        #20;
        reset = 0;

        // Give the multi-cycle CPU enough time to process 3 instructions
        // (Around 15-20 clock cycles)
        #300; 

        // Print what actually happened
        $display("\n========================================");
        $display("          SIMULATION COMPLETE           ");
        $display("========================================");
        $display("Final Register States:");
        $display("R1 = %d", uut.datapath_inst.reg_file_inst.R[1]);
        $display("R2 = %d", uut.datapath_inst.reg_file_inst.R[2]);
        $display("R3 = %d", uut.datapath_inst.reg_file_inst.R[3]);
        $display("----------------------------------------");
        
        // ==============================================================
        // THE AUTOMATIC CHECKER
        // ==============================================================
        if (uut.datapath_inst.reg_file_inst.R[3] === 16'd15) begin
            $display(" [SUCCESS] All Correct! Your CPU successfully added 5 + 10 = 15.");
        end else begin
            $display(" [FAILED]  Bug detected! Expected R3 = 15, but got %d", uut.datapath_inst.reg_file_inst.R[3]);
        end
        $display("========================================\n");
        
        $finish;
    end
      
endmodule
