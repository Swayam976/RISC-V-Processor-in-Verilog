`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/28/2026 08:05:02 AM
// Design Name: 
// Module Name: instr_mem
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


module instr_mem(
    input [31:0]addr, output reg [31:0]instr
    );
    
    reg [31:0] instr_reg [255:0];
    
    initial begin
        $readmemh("program.hex", instr_reg);
    end
    
    always @ (*) begin
        instr = instr_reg[addr[31:2]];
    end
endmodule
