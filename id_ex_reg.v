`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/29/2026 07:31:03 PM
// Design Name: 
// Module Name: id_ex_reg
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


module id_ex_reg( input clk, input reset, input flush, input stall, input [4:0] rs1_in, input [4:0] rs2_in, output reg [4:0] rs1_out, output reg [4:0] rs2_out,
    input [31:0] rs1_data_in, input [31:0] rs2_data_in, input [31:0] imm_in, input [4:0] rd_in, input [31:0] pcplus4_in, input [2:0] funct3_in,
    input [3:0] ctrl_in, input alu_src_in, input branch_in, input jump_in, input jalr_in, input mem_read_in, input mem_write_in, input reg_write_in, input [2:0] wb_sel_in,
    output reg [31:0] rs1_data_out, output reg [31:0] rs2_data_out, output reg [31:0] imm_out, output reg [4:0] rd_out, output reg [31:0] pcplus4_out, output reg [2:0] funct3_out,
    output reg [3:0] ctrl_out, output reg alu_src_out, output reg branch_out, output reg jump_out, output reg jalr_out, output reg mem_read_out, output reg mem_write_out, output reg reg_write_out, output reg [2:0] wb_sel_out  
);

    always @ (posedge clk)
        if(reset | flush | stall) begin
            rs1_out <= 32'd0;
            rs2_out <= 32'd0;
            rs1_data_out <= 32'd0;
            rs2_data_out <= 32'd0;
            imm_out <= 32'd0;
            pcplus4_out <= 32'd0;
            rd_out <= 5'd0;
            ctrl_out <= 4'd0;
            funct3_out <= 3'd0;
            wb_sel_out <= 3'd0;
            alu_src_out <= 1'd0;
            branch_out <= 1'd0;
            jump_out <= 1'd0;
            jalr_out <= 1'd0;
            mem_read_out <= 1'd0;
            mem_write_out <= 1'd0;
            reg_write_out <= 1'd0;
        end
        
        else begin
            rs1_out <= rs1_in;
            rs2_out <=  rs2_in;
            rs1_data_out <= rs1_data_in;
            rs2_data_out <=  rs2_data_in;
            imm_out <= imm_in;
            pcplus4_out <= pcplus4_in;
            rd_out <= rd_in;
            ctrl_out <= ctrl_in;
            funct3_out <= funct3_in;
            wb_sel_out <= wb_sel_in;
            alu_src_out <= alu_src_in;
            branch_out <= branch_in;
            jump_out <= jump_in;
            jalr_out <= jalr_in;
            mem_read_out <= mem_read_in;
            mem_write_out <= mem_write_in;
            reg_write_out <= reg_write_in;
        end
endmodule
