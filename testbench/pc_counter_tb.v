`timescale 1ns / 1ps
`include "pc_counter.v"

module tb_pc_counter;
    reg clk, reset, pc_write;
    reg [15:0] pc_in;
    wire [15:0] pc_out;

    integer errors;

    pc_counter uut (
        .clk(clk), 
        .reset(reset), 
        .pc_write(pc_write), 
        .pc_in(pc_in), 
        .pc_out(pc_out)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("pc_counter_test.vcd");
        $dumpvars(0, tb_pc_counter);

        clk = 0; errors = 0;
        
        reset = 1; pc_write = 1; pc_in = 16'hAAAA;
        #15;
        if (pc_out !== 16'h0000) begin
            $display("[ERROR] PC did not reset to 0. Got %h", pc_out);
            errors = errors + 1;
        end
        reset = 0;

        pc_in = 16'h0008; pc_write = 1;
        #10;
        if (pc_out !== 16'h0008) begin
            $display("[ERROR] PC did not write properly. Got %h", pc_out);
            errors = errors + 1;
        end

        pc_in = 16'h0010; pc_write = 0;
        #10;
        if (pc_out !== 16'h0008) begin
            $display("[ERROR] PC did not hold its value when pc_write=0. Got %h", pc_out);
            errors = errors + 1;
        end

        $display("\n===============================================");
        if (errors == 0) $display("---> PC COUNTER: YEAH THIS IS CORRECT! (0 errors)");
        else $display("---> PC COUNTER: FAILED with %0d errors.", errors);
        $display("===============================================\n");
        $finish;
    end
endmodule
