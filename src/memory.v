// ----sequential write and combinational read----

module memory (input clk, mem_write, mem_read, 
input [15:0] addr,
input [15:0] write_data, 
output [15:0] read_data);

reg [15:0] mem [65535:0];

always@(posedge clk) begin
    if(mem_write) begin
        mem[addr] <= write_data;
    end
end

assign read_data = mem_read? mem[addr] : 16'h0000;

endmodule