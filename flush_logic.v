`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/30/2026 09:58:58 AM
// Design Name: 
// Module Name: flush_logic
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


module flush_logic(
    input branch_in, input jump_in,  input jalr_in, input [2:0] funct3_in, input zero, input alu_lt, output flush, output redirect_is_jalr
    );
    
    wire branch_taken;
    assign branch_taken = branch_in & (funct3_in[0] ? ~(funct3_in[2] ? alu_lt : zero) : (funct3_in[2] ? alu_lt : zero));
    assign flush = branch_taken | jump_in;
    assign redirect_is_jalr = jalr_in;
endmodule
