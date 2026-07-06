// ----mode =1 ---> 6 bit extend else 9 bit extend----

module sign_extend (input [8:0] imm_in, input mode, output [15:0] imm_out);
wire [15:0] extend_six;
wire [15:0] extend_nine;

assign extend_six = {{10{imm_in[5]}}, imm_in[5:0]};
assign extend_nine = {{7{imm_in[8]}}, imm_in[8:0]};

assign imm_out = mode? extend_six : extend_nine;
endmodule