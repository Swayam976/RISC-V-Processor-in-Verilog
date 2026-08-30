`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/29/2026 11:43:49 AM
// Design Name: 
// Module Name: ab_reg
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


module ab_reg(
    input clk, input reset, input [31:0] a, input [31:0] b, input [2:0] state, output reg [31:0] a_reg, output reg [31:0] b_reg
    );
    
    localparam  FETCH = 3'b000, DECODE = 3'b001, EXECUTE = 3'b010, MEMORY = 3'b011, WRITEBACK = 3'b100;
    
    always @ (posedge clk)
        if (reset) begin
            a_reg <= 32'd0;
            b_reg <= 32'd0;
        end
        else if (state == DECODE) begin
            a_reg <= a;
            b_reg <= b;
        end
endmodule
