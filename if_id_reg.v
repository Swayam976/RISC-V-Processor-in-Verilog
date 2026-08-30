`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/29/2026 06:54:45 PM
// Design Name: 
// Module Name: if_id_reg
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


module if_id_reg(
    input clk, input reset, input stall, input flush, input [31:0] instr_in, input [31:0] pcplus4_in, output reg [31:0] instr_out, output reg [31:0] pcplus4_out 
    );
    
    always @ (posedge clk)
        if (reset | flush) begin
            pcplus4_out <= 32'd0;
            instr_out <= 32'd0;
        end
        
        else if (stall) begin 
            instr_out <= instr_out;
            pcplus4_out <= pcplus4_out;
        end
        
        else begin 
            instr_out <= instr_in;
            pcplus4_out <= pcplus4_in;
        end
endmodule
