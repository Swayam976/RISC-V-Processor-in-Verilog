`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/29/2026 12:57:54 PM
// Design Name: 
// Module Name: pc_snapshot_reg
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


module pc_snapshot_reg(
    input clk, input reset, input [31:0] pc_in, input [2:0] state, output reg [31:0] pc_reg_out
    );
    
    localparam  FETCH = 3'b000, DECODE = 3'b001, EXECUTE = 3'b010, MEMORY = 3'b011, WRITEBACK = 3'b100;
    
    always @ (posedge clk)
        if (reset)
            pc_reg_out <= 32'd0;
        else if (state == FETCH)
            pc_reg_out <= pc_in;
endmodule
