`timescale 1ns / 1ps
`include "register_file.v"

module tb_register_file;
    reg clk, reset, reg_write;
    reg [2:0] Ra_addr, Rb_addr, write_addr;
    reg [15:0] write_data;
    wire [15:0] out_a, out_b;

    integer i, errors;

    register_file uut (
        .clk(clk), 
        .reset(reset), 
        .reg_write(reg_write), 
        .Ra_addr(Ra_addr), 
        .Rb_addr(Rb_addr), 
        .write_addr(write_addr), 
        .write_data(write_data), 
        .out_a(out_a), 
        .out_b(out_b)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("register_file_test.vcd");
        $dumpvars(0, tb_register_file);

        clk = 0; reset = 1; reg_write = 0; 
        Ra_addr = 0; Rb_addr = 0; write_addr = 0; write_data = 0;
        errors = 0;

        #15 reset = 0;

        reg_write = 1;
        for (i = 0; i < 8; i = i + 1) begin
            write_addr = i[2:0];
            write_data = (i + 1) * 16'h0111; 
            #10; 
        end
        reg_write = 0; 

        for (i = 0; i < 8; i = i + 1) begin
            Ra_addr = i[2:0];
          Rb_addr = 7 - i[2:0]; 
            #10; 

            if (out_a !== (Ra_addr + 1) * 16'h0111) begin
                $display("[ERROR] Reg %0d read mismatch on Port A. Got %h", Ra_addr, out_a);
                errors = errors + 1;
            end
            if (out_b !== (Rb_addr + 1) * 16'h0111) begin
                $display("[ERROR] Reg %0d read mismatch on Port B. Got %h", Rb_addr, out_b);
                errors = errors + 1;
            end
        end

        $display("\n===============================================");
        if (errors == 0) $display("---> REGISTER FILE: YEAH THIS IS CORRECT! (0 errors)");
        else $display("---> REGISTER FILE: FAILED with %0d errors.", errors);
        $display("===============================================\n");
        $finish;
    end
endmodule
