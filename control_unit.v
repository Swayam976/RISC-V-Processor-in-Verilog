`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/28/2026 11:00:18 AM
// Design Name: 
// Module Name: control_unit
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


module control_unit(
    input [6:0] opcode, input [2:0] funct3, input [6:0] funct7, 
    output reg [3:0] ctrl, output reg alu_src, output reg mem_read, output reg mem_write, 
    output reg [2:0] wb_sel, output reg reg_write, output reg branch, output reg jump, output reg jalr
    );
    
    always @ (*) begin
        mem_read = 0; 
        mem_write = 0; 
        wb_sel = 3'b000;
        branch = 0;
        reg_write = 1;
        jump = 0;
        jalr = 0;
        
        if ((opcode == 7'b0110011) | (opcode == 7'b0010011)) begin
            case (funct3)
                3'b000: ctrl = opcode[5] ? ((funct7 == 7'b0000000) ? 4'b0000 : ((funct7 == 7'b0100000)? 4'b0001 : 4'b1111)) : 4'b0000;
                3'b111: ctrl = 4'b0010;
                3'b110: ctrl = 4'b0011;
                3'b100: ctrl = 4'b0100;
                3'b001: ctrl = 4'b0101;
                3'b101: ctrl = opcode[5] ? ((funct7 == 7'b0000000) ? 4'b0110 : ((funct7 == 7'b0100000)? 4'b0111 : 4'b1111)) : ((funct7[5] == 1'b0) ? 4'b0110 : ((funct7[5] == 1'b1) ? 4'b0111 : 4'b1111));
                3'b010: ctrl = 4'b1000;
                3'b011: ctrl = 4'b1001;
                default: ctrl = 4'b1111;
            endcase
            alu_src = opcode[5] ? 1'b0 : 1'b1;
        end
        
        else if ((opcode == 7'b0000011) | (opcode == 7'b0100011)) begin
            mem_read = opcode[5] ? 1'b0 : 1'b1;
            mem_write = opcode[5] ? 1'b1 : 1'b0;
            wb_sel = 3'b001;
            reg_write = opcode[5] ? 1'b0 : 1'b1;
            alu_src = 1;
            ctrl = 4'b0000;
        end
           
        else if (opcode == 7'b1100011) begin
            branch = 1;
            reg_write = 0;
            alu_src = 0;
            if (funct3[2] == 0)
                ctrl = 4'b0001;
            else if (funct3[1] == 0)
                ctrl = 4'b1000;
            else
                ctrl = 4'b1001;
        end
        
        else if ((opcode == 7'b1100111) | (opcode == 7'b1101111)) begin
            reg_write = 1;
            alu_src = 1;
            jump = 1;
            jalr = opcode[3] ? 1'b0 : 1'b1;
            wb_sel = 3'b010;
            ctrl = 4'b0000;
        end

        else if ((opcode == 7'b0110111) | (opcode == 7'b0010111)) begin
            reg_write = 1;
            wb_sel = opcode[5] ? 3'b011 : 3'b100;
            alu_src = 1;
            ctrl = 4'b0000;
        end
        
        else begin ctrl = 4'b1111; alu_src = 0; reg_write = 0; end
    end
endmodule
