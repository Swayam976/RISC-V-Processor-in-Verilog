`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/28/2026 08:56:42 AM
// Design Name: 
// Module Name: pc_add
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


module pc_add(
    input [31:0]pc_in1, input[31:0] pc_in2, output reg [31:0] pc_new
    );
    
    always @(*)
        pc_new = pc_in1 + pc_in2;
endmodule
