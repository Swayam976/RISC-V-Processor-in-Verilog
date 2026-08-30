`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/28/2026 11:37:44 AM
// Design Name: 
// Module Name: cpu_top
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


module cpu_top(
    input clk, input reset
    );
    
    wire [31:0] instr, imm, alu_result, rs1_data, rs2_data, read_data, pc_new, pc_br;
    wire [6:0] opcode, funct7;
    wire [4:0] rs1, rs2, rd;
    wire [3:0] alu_ctrl;
    wire [2:0] funct3, wb_sel;
    wire zero, alu_src, mem_read, mem_write, reg_write, pc_src, branch, jump, jalr;
    reg [31:0] write_data;
    
    assign pc_src = (branch & (funct3[0] ? ~(funct3[2] ? alu_result[0] : zero) : (funct3[2] ? alu_result[0] : zero))) | jump;
    
    fetch_stage fs(.clk(clk), .reset(reset), .pc_src(pc_src), .imm(imm), .instr(instr), .jalr(jalr), .jalr_tar(alu_result), .pc_new(pc_new), .pc_br_out(pc_br));
    
    decoder dec (.instr(instr), .opcode(opcode), .rd(rd), .rs1(rs1), .rs2(rs2), .funct3(funct3), .funct7(funct7), .imm(imm));
    
    control_unit cu(.opcode(opcode), .funct3(funct3), .funct7(funct7), .ctrl(alu_ctrl), .alu_src(alu_src), .mem_read(mem_read), .mem_write(mem_write), .wb_sel(wb_sel), .reg_write(reg_write), .branch(branch), .jump(jump), .jalr(jalr));
    
    always @ (*) begin
        case (wb_sel)
            3'b000: write_data = alu_result;  
            3'b001: write_data = read_data;   
            3'b010: write_data = pc_new;       
            3'b011: write_data = imm;         
            3'b100: write_data = pc_br;        
            default: write_data = 32'h00000000;
        endcase
    end
    
    register mem(.clk(clk), .rs1_addr(rs1), .rs2_addr(rs2), .rd_addr(rd), .write_data(write_data), .write_en(reg_write), .rs1_data(rs1_data), .rs2_data(rs2_data));
    
    ALU comp(.a(rs1_data), .b(alu_src ? imm : rs2_data), .ctrl(alu_ctrl), .result(alu_result), .zero(zero));
    
    data_mem dmem(.clk(clk), .addr(alu_result), .funct3(funct3), .mem_read(mem_read), .mem_write(mem_write), .write_data(rs2_data), .read_data(read_data));
endmodule