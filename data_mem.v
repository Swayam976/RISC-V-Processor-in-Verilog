`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/28/2026 02:01:36 PM
// Design Name: 
// Module Name: data_mem
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


module data_mem(
    input clk, input [31:0] addr, input mem_write, input [2:0]funct3, input mem_read, input [31:0] write_data, output reg [31:0] read_data
    );
    
    reg [31:0]memory[255:0];
    reg [7:0]byte_sel;
    reg [15:0] half_sel;
    always @ (*) begin
        if (mem_read) begin
            if (funct3 == 3'b010)
                read_data = memory[addr[31:2]];
            else if ((funct3 == 3'b000) | (funct3 == 3'b100)) begin
                byte_sel = memory[addr[31:2]][addr[1:0] * 8 +: 8];
                read_data = ~funct3[2] ? {{24{byte_sel[7]}}, byte_sel} : {{24{1'b0}}, byte_sel};
            end
            else if ((funct3 == 3'b001) | (funct3 == 3'b101)) begin
                half_sel = memory[addr[31:2]][addr[1] * 16 +: 16];
                read_data = ~funct3[2] ? {{16{half_sel[15]}}, half_sel} : {{16{1'b0}}, half_sel};
            end
            else read_data = 32'h00000000;
        end    
        else read_data = 32'h00000000;
    end
    
    always @(posedge clk) begin
        if (mem_write) begin
            if (funct3 == 3'b010) 
                memory[addr[31:2]] <= write_data;
            else if ((funct3 == 3'b000)) 
                memory[addr[31:2]][addr[1:0] * 8 +: 8] <= write_data[7:0];
            else if ((funct3 == 3'b001)) 
                memory[addr[31:2]][addr[1] * 16 +: 16] <= write_data[15:0]; 
        end                         
    end
endmodule
