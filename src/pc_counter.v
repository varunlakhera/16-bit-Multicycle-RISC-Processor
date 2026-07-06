module pc_counter (input clk, reset, pc_write, 
input [15:0] pc_in, 
output reg [15:0] pc_out);

always @(posedge clk) begin
    if(reset) begin
        pc_out <= 16'h0000;
    end
    else begin
        if(pc_write) begin
            pc_out <= pc_in;
        end
        else begin
            pc_out <= pc_out;
        end
    end
end
endmodule 