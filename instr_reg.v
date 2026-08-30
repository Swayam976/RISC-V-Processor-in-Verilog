`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/29/2026 11:30:42 AM
// Design Name: 
// Module Name: instr_reg
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


module instr_reg(
    input clk, input reset, input [31:0] instr_in, input [2:0] state, output reg [31:0] instr_out
    );
    
    localparam  FETCH = 3'b000, DECODE = 3'b001, EXECUTE = 3'b010, MEMORY = 3'b011, WRITEBACK = 3'b100;
    
    always @ (posedge clk)
        if(reset)
            instr_out <= 32'd0;
        else if (state == FETCH)
            instr_out <= instr_in;
endmodule
