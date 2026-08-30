`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/29/2026 10:34:40 PM
// Design Name: 
// Module Name: ex_mem_reg
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



module ex_mem_reg(
    input clk, input reset, input [31:0] alu_result_in, input [31:0] rs2_data_in, input [31:0] imm_in, input [31:0] pcplus4_in, input [4:0] rd_in, input [2:0] funct3_in, input mem_read_in, input mem_write_in, input reg_write_in, input [2:0] wb_in,
    output reg [31:0] alu_result_out, output reg [31:0] rs2_data_out, output reg [31:0] imm_out, output reg [31:0] pcplus4_out, output reg [4:0] rd_out, output reg [2:0] funct3_out, output reg mem_read_out, output reg mem_write_out, output reg reg_write_out, output reg [2:0] wb_out 
    );
    
    always @ (posedge clk)
        if (reset) begin
            alu_result_out <= 32'd0;
            rs2_data_out <= 32'd0;
            imm_out <= 32'd0;
            pcplus4_out <= 32'd0;
            rd_out <= 5'd0;
            funct3_out <= 3'd0;
            mem_read_out <= 1'b0;
            mem_write_out <= 1'b0;
            reg_write_out <= 1'b0;
            wb_out <= 3'd0;
        end
        
        else begin
            alu_result_out <= alu_result_in;
            rs2_data_out <= rs2_data_in;
            imm_out <= imm_in;
            pcplus4_out <= pcplus4_in;
            rd_out <= rd_in;
            funct3_out <= funct3_in;
            mem_read_out <= mem_read_in;
            mem_write_out <= mem_write_in;
            reg_write_out <= reg_write_in;
            wb_out <= wb_in;
        end
endmodule