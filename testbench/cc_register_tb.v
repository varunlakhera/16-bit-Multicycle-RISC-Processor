`timescale 1ns/1ps
`include "cc_register.v"

module cc_register_tb;
    reg clk;
    reg reset;
    reg carry_out;
    reg cc_update;
    reg [15:0] alu_result;
    wire carry_flag;
    wire zero_flag;

    cc_register dut (
        .clk(clk),
        .reset(reset),
        .carry_out(carry_out),
        .cc_update(cc_update),
        .alu_result(alu_result),
        .carry_flag(carry_flag),
        .zero_flag(zero_flag)
    );

    always #5 clk = ~clk;

    task check;
        input expected_carry;
        input expected_zero;
        begin
            if (carry_flag !== expected_carry ||
                zero_flag  !== expected_zero)
            begin
                $display("FAIL @ %0t : Expected Carry=%b Zero=%b, Got Carry=%b Zero=%b",
                         $time,
                         expected_carry,
                         expected_zero,
                         carry_flag,
                         zero_flag);
            end
            else begin
                $display("PASS @ %0t : Carry=%b Zero=%b",
                         $time,
                         carry_flag,
                         zero_flag);
            end
        end
    endtask

    initial begin

        $dumpfile("cc_register.vcd");
        $dumpvars(0, cc_register_tb);

        clk = 0;
        reset = 0;
        carry_out = 0;
        cc_update = 0;
        alu_result = 0;

        reset = 1;
        @(posedge clk);
        #1;
        check(0,0);

        reset = 0;
        cc_update = 1;
        carry_out = 1;
        alu_result = 16'h0000;

        @(posedge clk);
        #1;
        check(1,1);

        carry_out = 0;
        alu_result = 16'h1234;

        @(posedge clk);
        #1;
        check(0,0);


        cc_update = 0;
        carry_out = 1;
        alu_result = 16'h0000;

        @(posedge clk);
        #1;


        check(0,0);
        cc_update = 1;

        @(posedge clk);
        #1;
        check(1,1);

        $display("Simulation Finished");
        $finish;
    end

endmodule
