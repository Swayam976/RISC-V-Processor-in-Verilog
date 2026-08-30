`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/29/2026 11:06:20 AM
// Design Name: 
// Module Name: state_reg
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


module state_reg(
    input clk, input reset, input [6:0] opcode, output reg [2:0]state
    );
    
    localparam  FETCH = 3'b000, DECODE = 3'b001, EXECUTE = 3'b010, MEMORY = 3'b011, WRITEBACK = 3'b100;
    reg [2:0] next_state;
    
    always @(*) begin
        case(state)
            FETCH :     next_state = DECODE;
            DECODE :    next_state = EXECUTE;
            EXECUTE :   begin 
                        if ((opcode == 7'b0000011) | (opcode == 7'b0100011))
                            next_state = MEMORY;
                        else if (opcode == 7'b1100011)
                            next_state = FETCH;
                        else 
                            next_state = WRITEBACK;
                        end
            MEMORY :    begin
                        if (opcode == 7'b0000011)
                            next_state = WRITEBACK;
                        else
                            next_state = FETCH;
                        end
            WRITEBACK : next_state = FETCH;
            default :   next_state = FETCH;
        endcase
    end
    
    always @ (posedge clk) begin
        if(reset)
            state <= FETCH;
            
        else state <= next_state; 
    end        
endmodule
