`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/29/2026 02:51:36 PM
// Design Name: 
// Module Name: multi_cpu_top
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


module multi_cpu_top(
    input clk, input reset
    );
    
    reg [31:0] write_data;
    wire [31:0] pcplus4, branch_tar, pc_out, pc_reg_out, alu_result, alu_res_reg, imm, instr, instr_out, rs1_data, rs2_data, rs1_data_reg, rs2_data_reg, read_data, mdr_out;
    wire [6:0] opcode, funct7;
    wire [4:0] rs1, rs2, rd;
    wire [3:0] ctrl;
    wire [2:0] state, wb_sel, funct3;
    wire mem_write, mem_read, alu_src, reg_write,branch_taken, branch, jump, jalr, zero;
    
    assign branch_taken = (branch & (funct3[0] ? ~(funct3[2] ? alu_result[0] : zero) : (funct3[2] ? alu_result[0] : zero)));
    
    always @ (*) begin
        case (wb_sel)
            3'b000: write_data = alu_res_reg;  
            3'b001: write_data = mdr_out;   
            3'b010: write_data = pc_reg_out + 32'd4;       
            3'b011: write_data = imm;         
            3'b100: write_data = branch_tar;        
            default: write_data = 32'h00000000;
        endcase
    end
    
    instr_mem instr_mem_multi(.addr(pc_out), .instr(instr));
    instr_reg instr_reg_multi (.clk(clk), .reset(reset), .instr_in(instr), .state(state), .instr_out (instr_out));
    decoder dec_multi (.instr(instr_out), .opcode(opcode), .rd(rd), .rs1(rs1), .rs2(rs2), .funct3(funct3), .funct7(funct7), .imm(imm));
    register register_multi (.clk(clk), .rs1_addr(rs1), .rs2_addr(rs2), .rd_addr(rd), .write_data(write_data), .write_en(reg_write), .rs1_data(rs1_data), .rs2_data(rs2_data));
    ab_reg ab_reg_multi (.clk(clk), .reset(reset), .a(rs1_data), .b(rs2_data), .state(state), .a_reg(rs1_data_reg), .b_reg(rs2_data_reg));
    ALU alu_multi (.a(rs1_data_reg), .b(alu_src ? imm : rs2_data_reg), .ctrl(ctrl), .result(alu_result), .zero(zero));
    reg_control_logic cu_multi (.opcode(opcode), .funct3(funct3), .funct7(funct7), .state(state), .ctrl(ctrl), .alu_src(alu_src), .mem_read(mem_read), .mem_write(mem_write), .wb_sel(wb_sel), .reg_write(reg_write), .branch(branch), .jump(jump), .jalr(jalr));
    alu_reg alu_reg_multi (.clk(clk), .reset(reset), .state(state), .alu_res_in(alu_result), .alu_res_out(alu_res_reg));
    pc_ctrl pc_multi(.clk(clk), .reset(reset), .state(state), .branch_taken(branch_taken), .pcplus4(pcplus4), .branch_tar(branch_tar), .jalr_tar(alu_result), .jump(jump), .jalr(jalr),  .pc_out(pc_out));
    pc_add pc_add1 (.pc_in1(pc_out), .pc_in2(32'd4), .pc_new(pcplus4));
    pc_add pc_add2 (.pc_in1(pc_reg_out), .pc_in2(imm), .pc_new(branch_tar));
    data_mem data_multi (.clk(clk), .addr(alu_res_reg), .mem_write(mem_write), .funct3(funct3), .mem_read(mem_read), .write_data(rs2_data_reg), .read_data(read_data));
    mdr mdr_multi (.clk(clk), .reset(reset), .mem_data_in(read_data), .state(state), .mdr_out(mdr_out));
    state_reg state_reg_multi(.clk(clk), .reset(reset), .opcode(opcode), .state(state));
    pc_snapshot_reg pc_snapshot_multi (.clk(clk), .reset(reset), .pc_in(pc_out), .state(state), .pc_reg_out(pc_reg_out));
endmodule
