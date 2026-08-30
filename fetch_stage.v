`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/28/2026 09:13:40 AM
// Design Name: 
// Module Name: fetch_stage
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


module fetch_stage(
    input clk, input reset, input pc_src, input [31:0]imm, input [31:0]jalr_tar, input jalr, 
    output [31:0]instr, output [31:0] pc_new, output [31:0] pc_br_out
    );
    
    wire [31:0]pc_out, pc_br;
    
    pc_add pca1(.pc_in1(pc_out), .pc_in2(32'h00000004), .pc_new(pc_new));
    pc_add pca2(.pc_in1(pc_out), .pc_in2(imm), .pc_new(pc_br));
    pc_reg pcr(.clk(clk), .reset(reset), .pc_next(pc_src ? (jalr ? jalr_tar : pc_br) : pc_new), .pc_out(pc_out));
    instr_mem insmem(.addr(pc_out), .instr(instr));
    
    assign pc_br_out = pc_br;
endmodule
