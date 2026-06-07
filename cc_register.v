module cc_register (input clk, reset, carry_out, cc_update, 
input [15:0] alu_result, 
output reg carry_flag, zero_flag);

always @(posedge clk) begin
    if(reset) begin
        carry_flag <= 0;
        zero_flag <= 0;
    end
    else if(cc_update) begin
           carry_flag <= carry_out;
           zero_flag <= (alu_result == 16'b0);
        end
end

endmodule