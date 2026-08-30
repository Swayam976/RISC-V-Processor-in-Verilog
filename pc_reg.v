`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/28/2026 08:55:05 AM
// Design Name: 
// Module Name: pc_reg
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


module pc_reg(
    input clk, input reset, input [31:0]pc_next, output reg [31:0]pc_out 
    );
    
    always @ (posedge clk) begin
        if (reset)
            pc_out <= 0;
        else
            pc_out <= pc_next;
    end
endmodule
