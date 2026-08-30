`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/29/2026 11:55:37 PM
// Design Name: 
// Module Name: forward_unit
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


module forward_unit(
    input [4:0] id_ex_rs1_rd, input [4:0] id_ex_rs2_rd, input [4:0] ex_mem_rd, input ex_mem_write, input [4:0] mem_wb_rd, input mem_wb_write, output reg [1:0]forward_a, output reg [1:0]forward_b
    );
    
    always @ (*) begin
        if (ex_mem_write && (ex_mem_rd != 0) && (ex_mem_rd == id_ex_rs1_rd))
            forward_a = 2'b10;
        else if (mem_wb_write && (mem_wb_rd != 0) && (mem_wb_rd == id_ex_rs1_rd))
            forward_a = 2'b01;
        else
            forward_a = 2'b00;
        
        if (ex_mem_write && (ex_mem_rd != 0) && (ex_mem_rd == id_ex_rs2_rd))
            forward_b = 2'b10;
        else if (mem_wb_write && (mem_wb_rd != 0) && (mem_wb_rd == id_ex_rs2_rd))
            forward_b = 2'b01;
        else
            forward_b = 2'b00;
    end       
endmodule
