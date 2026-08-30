`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/29/2026 12:02:30 PM
// Design Name: 
// Module Name: pc_ctrl
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


module pc_ctrl(
    input clk, input reset, input [2:0] state, input branch_taken, input [31:0] pcplus4, input [31:0] branch_tar, input [31:0]jalr_tar, input jump, input jalr, 
    output reg [31:0] pc_out
    );
    
    localparam  FETCH = 3'b000, DECODE = 3'b001, EXECUTE = 3'b010, MEMORY = 3'b011, WRITEBACK = 3'b100;
    
    always @ (posedge clk)
        if(reset)
            pc_out <= 32'd0;
            
        else if (state == FETCH)
            pc_out <= pcplus4;
            
        else if (state == EXECUTE) begin 
            if (branch_taken | jump) begin
                if (jalr) 
                    pc_out <= jalr_tar;
                else 
                    pc_out <= branch_tar;
            end
        end
            
endmodule
