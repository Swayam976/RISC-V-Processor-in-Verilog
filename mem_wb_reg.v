`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/29/2026 11:00:50 PM
// Design Name: 
// Module Name: mem_wb_reg
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


module mem_wb_reg(
    input clk, input reset, input [31:0] mem_data_in, input [31:0] alu_result_in, input [31:0] imm_in, input [31:0] pcplus4_in, input [4:0] rd_in, input reg_write_in, input [2:0] wb_in, 
    output reg [31:0] mem_data_out, output reg [31:0] alu_result_out, output reg [31:0] imm_out, output reg [31:0] pcplus4_out, output reg [4:0] rd_out, output reg reg_write_out, output reg [2:0] wb_out 
    );
    
    always @ (posedge clk)
        if (reset) begin
            alu_result_out <= 32'd0;
            mem_data_out <= 32'd0;
            imm_out <= 32'd0;
            pcplus4_out <= 32'd0;
            rd_out <= 5'd0;
            reg_write_out <= 1'b0;
            wb_out <= 3'd0;
        end
        
        else begin
            alu_result_out <= alu_result_in;
            mem_data_out <= mem_data_in;
            imm_out <= imm_in;
            pcplus4_out <= pcplus4_in;
            rd_out <= rd_in;
            reg_write_out <= reg_write_in;
            wb_out <= wb_in;
        end
endmodule
