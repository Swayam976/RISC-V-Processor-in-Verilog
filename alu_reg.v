`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/29/2026 11:49:48 AM
// Design Name: 
// Module Name: alu_reg
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


module alu_reg(
    input clk, input reset, input [2:0] state, input [31:0] alu_res_in, output reg [31:0] alu_res_out
    );
    
    localparam  FETCH = 3'b000, DECODE = 3'b001, EXECUTE = 3'b010, MEMORY = 3'b011, WRITEBACK = 3'b100;

    always @ (posedge clk)
        if (reset)
            alu_res_out <= 32'd0;
        else if (state == EXECUTE)
            alu_res_out <= alu_res_in;
endmodule
