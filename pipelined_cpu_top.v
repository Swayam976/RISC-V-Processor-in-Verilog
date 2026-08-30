`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/30/2026 10:21:36 AM
// Design Name: 
// Module Name: pipelined_cpu_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module pipelined_cpu_top(
    input clk, input reset
    );
    
    reg  [31:0] a, b, write_data, ex_mem_fwd_value;
    wire [31:0] instr, pc_new, pc_out, pcplus4,  pcplus4_reg, instr_reg, redirect_target, imm, rs1_data, rs2_data, rs1_data_reg, rs2_data_reg, imm_reg, pcplus4_id_ex_reg, alu_res, ex_mem_alu_res, ex_mem_rs2, ex_mem_imm, ex_mem_pcplus4, read_data, mem_wb_data, mem_wb_alu_res, mem_wb_imm, mem_wb_pcplus4; 
    wire [6:0] opcode, funct7;
    wire [4:0] rd, rs1, rs2, rs1_reg, rs2_reg, rd_reg, ex_mem_mem_rd, mem_wb_rd;
    wire [3:0] ctrl, ctrl_reg;
    wire [2:0] funct3, wb_sel, funct3_reg, wb_sel_reg, ex_mem_funct3, ex_mem_wb_sel, mem_wb_wb_sel;
    wire [1:0] forward_a, forward_b;
    wire stall, flush, alu_src, mem_read, mem_write, reg_write, branch, jump, jalr, alu_src_reg, branch_reg, jump_reg, jalr_reg, mem_read_reg, mem_write_reg, reg_write_reg, zero, redirect_is_jalr, ex_mem_mem_read, ex_mem_mem_write, ex_mem_reg_write, mem_wb_reg_write;
    
    
    // FETCH STAGE
    assign pc_new = flush ? redirect_target : (stall ? pc_out : pcplus4);
    if_id_reg pipe_if_id_reg(.clk(clk), .reset(reset), .stall(stall), .flush(flush), .instr_in(instr), .pcplus4_in(pcplus4), .instr_out(instr_reg), .pcplus4_out(pcplus4_reg));
    pc_add pipe_pc_add(.pc_in1(pc_out), .pc_in2(32'd4), .pc_new(pcplus4));
    pc_reg pipe_pc_reg(.clk(clk), .reset(reset), .pc_next(pc_new), .pc_out(pc_out));
    instr_mem pipe_instr_mem(.addr(pc_out), .instr(instr));
    
    
    //DECODE STAGE
    decoder pipe_decoder(.instr(instr_reg), .opcode(opcode), .rd(rd), .rs1(rs1), .rs2(rs2), .funct3(funct3), .funct7(funct7), .imm(imm));
    control_unit pipe_control_logic (.opcode(opcode), .funct3(funct3), .funct7(funct7), .ctrl(ctrl), .alu_src(alu_src), .mem_read(mem_read), .mem_write(mem_write), .wb_sel(wb_sel), .reg_write(reg_write), .branch(branch), .jump(jump), .jalr(jalr));
    register pipe_register(.clk(clk), .rs1_addr(rs1), .rs2_addr(rs2), .rd_addr(mem_wb_rd), .write_data(write_data), .write_en(mem_wb_reg_write), .rs1_data(rs1_data), .rs2_data(rs2_data));
    id_ex_reg pipe_id_ex_reg (.clk(clk), .reset(reset), .flush(flush), .stall(stall), .rs1_in(rs1), .rs2_in(rs2), .rs1_out(rs1_reg), .rs2_out(rs2_reg),
    .rs1_data_in(rs1_data), .rs2_data_in(rs2_data), .imm_in(imm), .rd_in(rd), .pcplus4_in(pcplus4_reg), .funct3_in(funct3),
    .ctrl_in(ctrl), .alu_src_in(alu_src), .branch_in(branch), .jump_in(jump), .jalr_in(jalr), .mem_read_in(mem_read), .mem_write_in(mem_write), .reg_write_in(reg_write), .wb_sel_in(wb_sel),
    .rs1_data_out(rs1_data_reg), .rs2_data_out(rs2_data_reg), .imm_out(imm_reg), .rd_out(rd_reg), .pcplus4_out(pcplus4_id_ex_reg), .funct3_out(funct3_reg),
    .ctrl_out(ctrl_reg), .alu_src_out(alu_src_reg), .branch_out(branch_reg), .jump_out(jump_reg), .jalr_out(jalr_reg), .mem_read_out(mem_read_reg), .mem_write_out(mem_write_reg), .reg_write_out(reg_write_reg), .wb_sel_out(wb_sel_reg));
    load_hazard_ctrl pipe_load_hazard_ctrl(.is_ex_mem_read(mem_read_reg), .id_ex_rd(rd_reg), .rs1_id(rs1), .rs2_id(rs2), .stall(stall));
    
    
    //EXECUTE STAGE
    always @ (*) begin
        case (forward_a)
            2'b00: a = rs1_data_reg;
            2'b10: a = ex_mem_fwd_value;
            2'b01: a = write_data;
            2'b11: a = 32'd0;
        endcase 
        case (forward_b)
            2'b00: b = rs2_data_reg;
            2'b10: b = ex_mem_fwd_value;
            2'b01: b = write_data;
            2'b11: b = 32'd0;
        endcase
    end
    
    always @ (*) begin
        case (ex_mem_wb_sel)
            3'b000: ex_mem_fwd_value = ex_mem_alu_res;                          // R-type/I-type/loads(addr)
            3'b010: ex_mem_fwd_value = ex_mem_pcplus4;                          // JAL/JALR return address
            3'b011: ex_mem_fwd_value = ex_mem_imm;                              // LUI
            3'b100: ex_mem_fwd_value = ex_mem_pcplus4 - 32'd4 + ex_mem_imm;     // AUIPC
            default: ex_mem_fwd_value = ex_mem_alu_res;
        endcase
    end
    
    assign redirect_target = ~ redirect_is_jalr ? (pcplus4_id_ex_reg - 32'd4 + imm_reg) : alu_res;
    ALU pipe_alu(.a(a), .b(alu_src_reg ? imm_reg : b), .ctrl(ctrl_reg), .result(alu_res), .zero(zero));
    forward_unit pipe_forward_unit(.id_ex_rs1_rd(rs1_reg), .id_ex_rs2_rd(rs2_reg), .ex_mem_rd(ex_mem_mem_rd), .ex_mem_write(ex_mem_reg_write), .mem_wb_rd(mem_wb_rd), .mem_wb_write(mem_wb_reg_write), .forward_a(forward_a), .forward_b(forward_b));
    flush_logic pipe_flush_logic(.branch_in(branch_reg), .jump_in(jump_reg),  .jalr_in(jalr_reg), .funct3_in(funct3_reg), .zero(zero), .alu_lt(alu_res[0]), .flush(flush), .redirect_is_jalr(redirect_is_jalr));
    ex_mem_reg pipe_ex_mem_reg(.clk(clk), .reset(reset), .alu_result_in(alu_res), .rs2_data_in(b), .imm_in(imm_reg), .pcplus4_in(pcplus4_id_ex_reg), .rd_in(rd_reg), .funct3_in(funct3_reg), .mem_read_in(mem_read_reg), .mem_write_in(mem_write_reg), .reg_write_in(reg_write_reg), .wb_in(wb_sel_reg),
    .alu_result_out(ex_mem_alu_res), .rs2_data_out(ex_mem_rs2), .imm_out(ex_mem_imm), .pcplus4_out(ex_mem_pcplus4), .rd_out(ex_mem_mem_rd), .funct3_out(ex_mem_funct3), .mem_read_out(ex_mem_mem_read), .mem_write_out(ex_mem_mem_write), .reg_write_out(ex_mem_reg_write), .wb_out(ex_mem_wb_sel));
    
    
    //MEMORY STAGE
    data_mem pipe_data_mem(.clk(clk), .addr(ex_mem_alu_res), .mem_write(ex_mem_mem_write), .funct3(ex_mem_funct3), .mem_read(ex_mem_mem_read), .write_data(ex_mem_rs2), .read_data(read_data));
    mem_wb_reg pipe_mem_wb_reg(.clk(clk), .reset(reset), .mem_data_in(read_data), .alu_result_in(ex_mem_alu_res), .imm_in(ex_mem_imm), .pcplus4_in(ex_mem_pcplus4), .rd_in(ex_mem_mem_rd), .reg_write_in(ex_mem_reg_write), .wb_in(ex_mem_wb_sel), 
    .mem_data_out(mem_wb_data), .alu_result_out(mem_wb_alu_res), .imm_out(mem_wb_imm), .pcplus4_out(mem_wb_pcplus4), .rd_out(mem_wb_rd), .reg_write_out(mem_wb_reg_write), .wb_out(mem_wb_wb_sel));


    //WRITEBACK STAGE
    always @ (*) begin
        case (mem_wb_wb_sel)
            3'b000: write_data = mem_wb_alu_res;  
            3'b001: write_data = mem_wb_data;   
            3'b010: write_data = mem_wb_pcplus4;       
            3'b011: write_data = mem_wb_imm;         
            3'b100: write_data = mem_wb_pcplus4 - 32'd4 + mem_wb_imm;      
            default: write_data = 32'h00000000;
        endcase
    end
endmodule
