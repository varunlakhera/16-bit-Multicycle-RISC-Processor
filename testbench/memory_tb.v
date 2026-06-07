`timescale 1ns / 1ps
`include "memory.v"

module tb_memory_auto;

    reg clk;
    reg mem_write;
    reg mem_read;
    reg [15:0] addr;
    reg [15:0] write_data;

    wire [15:0] read_data;

    integer i;
    integer errors;
    memory uut (
        .clk(clk),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .addr(addr),
        .write_data(write_data),
        .read_data(read_data)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("memory_test.vcd");
        $dumpvars(0, tb_memory_auto);
      
        clk = 0; mem_write = 0; mem_read = 0; addr = 0; write_data = 0; errors = 0;
        #15; 

        mem_write = 1;
        mem_read = 0;
        for (i = 0; i < 16; i = i + 1) begin
            addr = i;
            write_data = (i + 1) * 16'h0111; 
            #10; 
        end
        mem_write = 0; 

        mem_read = 1;
        for (i = 0; i < 16; i = i + 1) begin
            addr = i;
            #10; 

            if (read_data !== (i + 1) * 16'h0111) begin
                $display("[ERROR] at Address %0d: Expected %h, Got %h", i, ((i + 1) * 16'h0111), read_data);
                errors = errors + 1;
            end
        end
        mem_read = 0;

        addr = 16'd5;
        write_data = 16'hBEEF; 
        mem_write = 0; 
        #10;

        mem_read = 1;
        #10;
        if (read_data === 16'hBEEF) begin
            $display("[ERROR] Memory overwrite occurred while mem_write was 0!");
            errors = errors + 1;
        end else if (read_data !== (6 * 16'h0111)) begin
            $display("[ERROR] Memory at Address 5 got corrupted!");
            errors = errors + 1;
        end

        $display("\n===============================================");
        if (errors == 0)
            $display("---> MEMORY: YEAH THIS IS CORRECT! (0 errors)");
        else
            $display("---> MEMORY: FAILED with %0d errors.", errors);
        $display("===============================================\n");

        $finish;
    end
endmodule
