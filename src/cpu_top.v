`include "controller.v"
`include "datapath.v"
`include "memory.v"

module cpu_top (input clk, reset);

wire [3:0] opcode;
wire carry_flag, zero_flag, zero_out; // flags n shi

wire pc_write, ir_load, alu_a_sel, alu_b_sel, alu_reg_load, reg_write;
wire sign_ext_mode, cc_update, mem_reg_load, mem_addr_src;
wire mem_read, mem_write;
wire [2:0] wb_src, alu_op;
wire [1:0] pc_src, reg_write_sel;

wire [15:0] memory_addr, memory_rdata, memory_wdata;

controller controller_inst (
    .clk(clk),
    .reset(reset),
    .opcode(opcode),
    .carry_flag(carry_flag),
    .zero_flag(zero_flag),
    .zero_out(zero_out),
    .pc_write(pc_write),
    .ir_load(ir_load),
    .alu_a_sel(alu_a_sel),
    .alu_b_sel(alu_b_sel),
    .alu_reg_load(alu_reg_load),
    .reg_write(reg_write),
    .sign_ext_mode(sign_ext_mode),
    .cc_update(cc_update),
    .mem_reg_load(mem_reg_load),
    .mem_addr_src(mem_addr_src),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .wb_src(wb_src),
    .alu_op(alu_op),
    .pc_src(pc_src),
    .reg_write_sel(reg_write_sel)
);

datapath datapath_inst(
    .clk(clk),
    .reset(reset),
    .pc_write(pc_write),
    .ir_load(ir_load),
    .alu_a_sel(alu_a_sel),
    .alu_b_sel(alu_b_sel),
    .alu_reg_load(alu_reg_load),
    .reg_write(reg_write),
    .sign_ext_mode(sign_ext_mode),
    .cc_update(cc_update),
    .mem_reg_load(mem_reg_load),
    .mem_addr_src(mem_addr_src),
    .wb_src(wb_src),
    .memory_rdata(memory_rdata),
    .pc_src(pc_src),
    .reg_write_sel(reg_write_sel),
    .alu_op(alu_op),
    .opcode(opcode),
    .memory_addr(memory_addr),
    .memory_wdata(memory_wdata),
    .carry_flag(carry_flag),
    .zero_flag(zero_flag),
    .zero_out(zero_out)
);

memory memory_inst(
    .clk(clk),
    .mem_write(mem_write),
    .mem_read(mem_read),
    .addr(memory_addr),
    .write_data(memory_wdata),
    .read_data(memory_rdata)
);

endmodule