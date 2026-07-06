module instruction_counter (input clk, reset, ir_load, 
input [15:0] ir_in, 
output reg [15:0] ir_out);

always @(posedge clk) begin
    if(reset) begin
        ir_out <= 16'h0000;
    end
    else begin
        if(ir_load) begin
            ir_out <= ir_in;
        end
    end
end
endmodule