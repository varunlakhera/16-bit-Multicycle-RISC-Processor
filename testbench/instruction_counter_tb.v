`timescale 1ns/1ps
`include "instruction_counter.v"

module instruction_counter_tb;
    reg clk;
    reg reset;
    reg ir_load;
    reg [15:0] ir_in;
    wire [15:0] ir_out;
  
    instruction_counter dut (
        .clk(clk),
        .reset(reset),
        .ir_load(ir_load),
        .ir_in(ir_in),
        .ir_out(ir_out)
    );

  
    always #5 clk = ~clk;

    task check;
        input [15:0] expected;
        begin
            if (ir_out !== expected)
                $display("FAIL @ %0t : Expected IR=%h, Got IR=%h",
                         $time, expected, ir_out);
            else
                $display("PASS @ %0t : IR=%h",
                         $time, ir_out);
        end
    endtask

    initial begin
        $dumpfile("instruction_counter.vcd");
        $dumpvars(0, instruction_counter_tb);

        clk = 0;
        reset = 0;
        ir_load = 0;
        ir_in = 16'h0000;
      
        reset = 1;
        @(posedge clk);
        #1;
        check(16'h0000);

        reset = 0;
        ir_load = 1;
        ir_in = 16'h1234;

        @(posedge clk);
        #1;
        check(16'h1234);

        ir_in = 16'hABCD;

        @(posedge clk);
        #1;
        check(16'hABCD);

        ir_load = 0;
        ir_in = 16'hFFFF;

        @(posedge clk);
        #1;

        check(16'hABCD);

        ir_load = 1;
        ir_in = 16'h5555;

        @(posedge clk);
        #1;
        check(16'h5555);

        $display("Simulation Finished");
        $finish;

    end

endmodule
