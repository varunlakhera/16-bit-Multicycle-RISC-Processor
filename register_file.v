// ----2 combinational reads and 1 sequential write----

module register_file (input clk, reset, reg_write, 
input [2:0] Ra_addr, Rb_addr, write_addr, 
input [15:0] write_data, 
output [15:0] out_a, out_b);

reg [15:0] R [0:7];
integer i;

assign out_a = R[Ra_addr];
assign out_b = R[Rb_addr];

always @(posedge clk) begin
    if(reset) begin
        for(i = 0; i < 8; i = i + 1) begin
            R[i] <= 16'b0;
        end
    end else if(reg_write) begin
        R[write_addr] <= write_data;
    end
end

endmodule