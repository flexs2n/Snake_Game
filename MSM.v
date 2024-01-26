`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.11.2023 10:20:02
// Design Name: 
// Module Name: MSM
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


module MSM(
    input CLK,
    input RESET,
    input [7:0] SCORE,
    input BTNR,
    input BTND,
    input BTNL,
    input BTNU,
    output [1:0] MSM_state
    );
    
    reg [1:0] Curr_state = 2'b00;
    reg [1:0] Next_state = 2'b00;
    always @ (posedge CLK) begin
        if (RESET)
            Next_state = 2'b00;
            
        else begin
            case(Curr_state)
                // IDLE
                2'b00: begin
                    if (BTNR || BTND || BTNL || BTNU)
                        Next_state <= 2'b01;
                    else
                        Next_state <= Curr_state;
                end
                // PLAY
                2'b01: begin
                    if (SCORE >= 4'd10)
                        Next_state <= 2'b10;
                    else
                        Next_state <= Curr_state;
                end
                // WIN
                2'b10: begin
                    if (RESET)
                        Next_state <= 2'b00;
                    else
                        Next_state <= Curr_state;
                end
                2'b11: begin
                    Next_state <= 2'b00;
                end
            endcase
        end
        Curr_state <= Next_state;
    end
    
    assign MSM_state = Curr_state;
endmodule
