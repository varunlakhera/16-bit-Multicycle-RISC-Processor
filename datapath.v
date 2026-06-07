`include "pc_counter.v"
`include "instruction_counter.v"
`include "alu.v"
`include "register_file.v"
`include "sign_extend.v"
`include "cc_register.v"


module datapath (input clk, reset,
input pc_write, ir_load, alu_a_sel, alu_b_sel, alu_reg_load, reg_write, sign_ext_mode, cc_update, mem_reg_load, mem_addr_src,
input [2:0] wb_src, 
input [15:0] memory_rdata,
input [1:0] pc_src, reg_write_sel, 
input [2:0] alu_op,
output [3:0] opcode,
output [15:0] memory_addr, memory_wdata,
output carry_flag, zero_flag, zero_out
);

reg [15:0] pc_in_src; //
wire [15:0] out_a, out_b, alu_result; //
wire [2:0] Ra_addr, Rb_addr; // 
wire [8:0] immediate_in; //
wire carry_out; //
wire [15:0] pc_out, ir_in, ir_out;

reg [15:0] write_data; //
reg [2:0] write_addr; // destination ergister address
reg [15:0] memory_reg; // memory register for load store
reg [15:0] alu_reg; // alu register for result
wire [15:0] alu_src_a, alu_src_b; //
wire [15:0] sign_ext_out; //

assign opcode = ir_out[15:12];
assign Ra_addr = ir_out[11:9];
assign Rb_addr = ir_out[8:6];   
assign immediate_in = ir_out[8:0];

assign alu_src_a = alu_a_sel ? out_a : out_b; // alu a mux
assign alu_src_b = alu_b_sel ? out_b : sign_ext_out; // alu b mux

assign memory_addr = mem_addr_src ? alu_reg : pc_out; // memory address from alu result
assign memory_wdata = out_a; // memory write data from register file

assign ir_in = memory_rdata; // instruction from memory

always @(posedge clk) begin
    if(reset) begin
        memory_reg <= 16'b0;
    end
    else if(mem_reg_load) begin
        memory_reg <= memory_rdata;
    end
end

always @(posedge clk) begin
    if(reset) begin
        alu_reg <= 16'b0;
    end
    else if(alu_reg_load) begin
        alu_reg <= alu_result;
    end
end

//writeback mux
always @(*) begin
    case(wb_src) 
        0 : write_data = alu_reg;
        1 : write_data = memory_reg;
        2 : write_data = pc_out - 16'b1;
        3 : write_data = {8'b0, immediate_in[7:0]};
        4 : write_data = {immediate_in[7:0], 8'b0};
        default : write_data = 16'bx;
    endcase
end

// pc_source mux
always @(*) begin 
    case(pc_src) 
        0 : pc_in_src = pc_out + 16'b1;
        1 : pc_in_src = pc_out + (sign_ext_out << 1) - 16'b1;
        2 : pc_in_src = out_b;
        default : pc_in_src = 16'bx;
    endcase
end

// write select mux for register file
always @(*) begin
    case(reg_write_sel) 
        0 : write_addr = ir_out[11:9];
        1 : write_addr = ir_out[8:6];
        2 : write_addr = ir_out[5:3];
        default : write_addr = 3'bx;
    endcase
end

pc_counter pc_inst (
    .clk(clk), // input
    .reset(reset), // input
    .pc_write(pc_write), // from cntroller
    .pc_in(pc_in_src), // pc mux
    .pc_out(pc_out) // to memory
);

instruction_counter ir_inst (
    .clk(clk), // input
    .reset(reset), // input
    .ir_load(ir_load), // input
    .ir_in(ir_in), // input from memory
    .ir_out(ir_out)  // to differnt shi
);

alu alu_inst (
    .alu_op(alu_op), // from controller
    .a(alu_src_a), // alu a mux
    .b(alu_src_b), // alu b mux
    .result(alu_result),//  stored  in alu_reg
    .carry(carry_out),  //for cc 
    .zero(zero_out)  // i think this is redundant 
);

register_file reg_file_inst (
    .clk(clk), // input
    .reset(reset), // input
    .reg_write(reg_write), // input
    .Ra_addr(Ra_addr), //from instruction
    .Rb_addr(Rb_addr), //from instruction
    .write_addr(write_addr), // from reg_write_sel
    .write_data(write_data), // from writeback_source mux
    .out_a(out_a), 
    .out_b(out_b)
);

sign_extend sign_ext_inst (
    .imm_in(immediate_in), // from instruction
    .mode(sign_ext_mode), // frm controller
    .imm_out(sign_ext_out)
);

cc_register cc_reg_inst (
    .clk(clk), // input     
    .reset(reset), // input 
    .carry_out(carry_out), // from alu
    .cc_update(cc_update), // from controller
    .alu_result(alu_result), // need to check if works or  needs to be changed with alu_reg
    .carry_flag(carry_flag), // to controller
    .zero_flag(zero_flag) // tp controller
);

endmodule