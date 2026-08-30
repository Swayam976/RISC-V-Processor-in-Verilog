`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/28/2026 10:40:30 AM
// Design Name: 

// Module Name: decoder
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


module decoder(
    input [31:0] instr, output reg [6:0] opcode, output reg [4:0] rd, output reg [4:0] rs1, output reg [4:0] rs2, output reg [2:0] funct3, output reg [6:0] funct7, output reg [31:0] imm
    );
    
    always @(*) begin
        opcode = instr[6:0];
        rd = instr[11:7];
        funct3 = instr[14:12];
        rs1 = instr[19:15];
        rs2 = instr[24:20];
        funct7 = instr[31:25];
        if((opcode == 7'b0010011) | (opcode == 7'b1100111) | (opcode == 7'b0000011))
            imm = {{20{instr[31]}}, instr[31:20]};
        
        else if (opcode == 7'b0100011)
            imm = {{20{instr[31]}}, instr[31:25], instr[11:7]};
        
        else if (opcode == 7'b1100011)
            imm = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8],{1'b0}};
            
        else if (opcode == 7'b1101111)
            imm = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21],{1'b0}};
        
        else if((opcode == 7'b0010111) | (opcode == 7'b0110111))
            imm = {instr[31:12], {12'b0}};
        
        else imm = 32'h00000000;
    end
endmodule