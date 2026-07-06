module controller (input clk, reset, input [3:0] opcode, 
input carry_flag, zero_flag, zero_out,
output reg pc_write, ir_load, alu_a_sel, alu_b_sel, alu_reg_load, reg_write, sign_ext_mode, 
cc_update, mem_reg_load, mem_addr_src, mem_read, mem_write,
output reg [2:0] wb_src, alu_op,
output reg [1:0] pc_src, reg_write_sel
);

localparam FETCH = 3'd0, DECODE  = 3'd1, EXECUTE = 3'd2, MEM_ACCESS = 3'd3, WRITEBACK = 3'd4;

localparam ADD = 4'b0000, SUB = 4'b0010, MUL = 4'b0011, 
ADI = 4'b0001, AND = 4'b0100, ORA = 4'b0101, IMP = 4'b0110, 
LHI = 4'b1000, LLI = 4'b1001, LW = 4'b1010, SW = 4'b1011, 
BEQ = 4'b1100, JAL = 4'b1101, JLR = 4'b1111, J = 4'b1110;

reg [2:0] state, next;

always @(posedge clk) begin
    if(reset) begin
        state <= FETCH;
    end
    else begin
        state <= next;
    end
end

always @(*) begin
    case(state) 
        FETCH : next = DECODE;
        DECODE : next = EXECUTE;
        EXECUTE : next = ((opcode == LW) || (opcode == SW))? MEM_ACCESS : WRITEBACK;
        MEM_ACCESS : next = WRITEBACK;
        WRITEBACK : next = FETCH;
        default : next = FETCH;
    endcase
end

always @(*) begin
    // default values for control signals
    pc_write = 0; ir_load = 0; alu_a_sel = 0; alu_b_sel = 0; alu_reg_load = 0; 
    reg_write = 0; sign_ext_mode = 0;cc_update = 0; mem_reg_load = 0; mem_addr_src = 0; mem_read = 0; mem_write = 0;
    wb_src = 3'b000; pc_src = 2'b00; reg_write_sel = 2'b00; alu_op = 3'b000;
    case(state) 
        FETCH : begin
            pc_write = 1; ir_load = 1; mem_read = 1; mem_addr_src = 0; pc_src = 2'd0; 
        end
        DECODE : begin
        end
        EXECUTE : begin
            case(opcode) 
                ADD, SUB, MUL, AND, ORA, IMP : begin
                    alu_a_sel = 1; alu_b_sel = 1; alu_reg_load = 1; cc_update = 1;
                    case(opcode) 
                        ADD : alu_op = 3'd0;
                        SUB : alu_op = 3'd1;
                        MUL : alu_op = 3'd2;
                        AND : alu_op = 3'd3;
                        ORA : alu_op = 3'd4;
                        IMP : alu_op = 3'd5;
                    endcase
                end
                ADI : begin
                    alu_a_sel = 1; alu_b_sel = 0; alu_reg_load = 1;
                    sign_ext_mode = 1; alu_op = 3'd0; cc_update = 1;
                end
                LW, SW : begin
                    alu_a_sel = 0; alu_b_sel = 0; alu_reg_load = 1; 
                    sign_ext_mode = 1; alu_op = 3'd0; 
                end
                BEQ : begin
                    alu_a_sel = 1; alu_b_sel = 1; alu_op = 3'b001;
                    if(zero_out) begin
                        pc_src = 2'd1;
                        pc_write = 1;
                        sign_ext_mode = 1;
                    end
                end
                JAL : begin
                    pc_write = 1; pc_src = 2'b01; sign_ext_mode = 0;
                    reg_write = 1; reg_write_sel = 2'b00; wb_src = 3'b10;
                end
                JLR : begin
                    pc_write = 1; pc_src = 2'b10; 
                    reg_write = 1; reg_write_sel = 2'b00; wb_src = 3'b10;
                end
                J : begin
                    pc_src = 2'b01; sign_ext_mode = 0; pc_write = 1;
                end
            endcase
        end
        MEM_ACCESS : begin
            mem_addr_src = 1;
            case(opcode) 
                LW : begin
                    mem_read = 1; mem_reg_load = 1;
                end
                SW : begin
                    mem_write = 1;
                end
            endcase
        end
        WRITEBACK : begin
            case(opcode) 
                ADD, SUB, MUL, AND, ORA, IMP : begin
                    reg_write = 1;
                    wb_src = 3'b000;
                    reg_write_sel = 2'b10;
                end
                ADI : begin
                    reg_write = 1;
                    wb_src = 3'b000;
                    reg_write_sel = 2'b1;
                end
                LHI : begin
                    reg_write = 1;
                    wb_src = 3'b100;
                    reg_write_sel = 2'b0;
                end
                LLI : begin
                    reg_write = 1;
                    wb_src = 3'b011;
                    reg_write_sel = 2'b0;
                end
                LW : begin
                    reg_write = 1;
                    wb_src = 3'b001;
                    reg_write_sel = 2'b0;
                end
            endcase
        end
    endcase
end


endmodule