`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/27/2026 11:50:37 PM
// Design Name: 
// Module Name: register
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


module register(
    input clk, input [4:0]rs1_addr, input [4:0]rs2_addr, input [4:0]rd_addr, input [31:0]write_data, input write_en, output reg [31:0]rs1_data, output reg [31:0]rs2_data
    );
    
    reg [31:0] reg_arr [0:31];
    always @ (*) begin
        if (rs1_addr == 0)
            rs1_data = 32'h00000000;
        else if (write_en && (rs1_addr == rd_addr))
            rs1_data = write_data;
        else
            rs1_data = reg_arr[rs1_addr]; 
        
        if (rs2_addr == 0)
            rs2_data = 32'h00000000;
        else if (write_en && (rs2_addr == rd_addr))
            rs2_data = write_data;
        else
            rs2_data = reg_arr[rs2_addr];
    end
    
    always @ (posedge clk) begin
        if(write_en & (rd_addr != 0))
            reg_arr[rd_addr] <= write_data;
    end
endmodule
