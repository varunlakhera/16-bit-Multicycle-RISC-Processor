`timescale 1ns / 1ps
`include "sign_extend.v"

module tb_sign_extend;
    reg [8:0] imm_in;
    reg mode;
    wire [15:0] imm_out;

    integer errors;

    sign_extend uut (
        .imm_in(imm_in), 
        .mode(mode), 
        .imm_out(imm_out)
    );

    initial begin
        $dumpfile("sign_extend_test.vcd");
        $dumpvars(0, tb_sign_extend);
        
        errors = 0;

        mode = 1; 
        
        imm_in = 9'b000_010101; 
        #10;
        if (imm_out !== 16'h0015) begin
            $display("[ERROR] 6-bit positive extend failed. Got %h", imm_out);
            errors = errors + 1;
        end


        imm_in = 9'b000_111111; 
        #10;
        if (imm_out !== 16'hFFFF) begin
            $display("[ERROR] 6-bit negative extend failed. Got %h", imm_out);
            errors = errors + 1;
        end

        mode = 0;

        imm_in = 9'b0_1010_1010;
        #10;
        if (imm_out !== 16'h00AA) begin
            $display("[ERROR] 9-bit positive extend failed. Got %h", imm_out);
            errors = errors + 1;
        end

        imm_in = 9'b1_0000_0000;
        #10;
        if (imm_out !== 16'hFF00) begin
            $display("[ERROR] 9-bit negative extend failed. Got %h", imm_out);
            errors = errors + 1;
        end

        $display("\n===============================================");
        if (errors == 0) $display("---> SIGN EXTEND: YEAH THIS IS CORRECT! (0 errors)");
        else $display("---> SIGN EXTEND: FAILED with %0d errors.", errors);
        $display("===============================================\n");
        $finish;
    end
endmodule
