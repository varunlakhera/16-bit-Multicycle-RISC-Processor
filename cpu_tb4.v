`timescale 1ns / 1ps
`include "cpu_top.v"

module tb_control;
    reg clk;
    reg reset;

    cpu_top uut (.clk(clk), .reset(reset));

    always #5 clk = ~clk;

    initial begin
        clk = 0; reset = 1;
        $dumpfile("control_wave.vcd"); $dumpvars(0, tb_control);

        // PROGRAM 3: Testing Branching (BEQ)
        // 0. ADI R1, R0, 5  (R1 = 5)
        // 1. ADI R2, R0, 5  (R2 = 5)
        // 2. BEQ R1, R2, 1  (If R1==R2, branch over the next instruction)
        // 3. ADI R3, R0, 50 (This should be SKIPPED!)
        // 4. ADI R3, R0, 1  (R3 = 1. This should be EXECUTED)
        uut.memory_inst.mem[0] = 16'h1045; 
        uut.memory_inst.mem[1] = 16'h1085; 
        uut.memory_inst.mem[2] = 16'hC281; 
        uut.memory_inst.mem[3] = 16'h10F2; 
        uut.memory_inst.mem[4] = 16'h10C1; 
        
        #20; reset = 0;
        #350; 

        $display("========================================");
        $display("        BRANCHING TEST RESULTS          ");
        $display("R3 Expected: 1, Got: %d", uut.datapath_inst.reg_file_inst.R[3]);
        
        if (uut.datapath_inst.reg_file_inst.R[3] == 1)
            $display(" -> [SUCCESS] BEQ (BRANCH) IS WORKING PERFECTLY.");
        else if (uut.datapath_inst.reg_file_inst.R[3] == 50)
            $display(" -> [FAILED]  BRANCH DID NOT HAPPEN. PC LOGIC HAS A BUG.");
        else
            $display(" -> [FAILED]  UNKNOWN BEHAVIOR.");
        $display("========================================\n");
        $finish;
    end
endmodule
