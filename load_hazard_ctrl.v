`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/29/2026 11:31:56 PM
// Design Name: 
// Module Name: load_hazard_ctrl
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


module load_hazard_ctrl(
    input is_ex_mem_read, input [4:0] id_ex_rd, input [4:0] rs1_id, input [4:0] rs2_id, output stall
    );
    
    assign stall = is_ex_mem_read & (id_ex_rd != 0) & ((id_ex_rd == rs1_id) | (id_ex_rd == rs2_id));
endmodule
