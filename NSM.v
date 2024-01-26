`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.11.2023 10:20:02
// Design Name: 
// Module Name: NSM
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


module NSM(
    input CLK,
    input RESET,
    input BTNR,
    input BTND,
    input BTNL,
    input BTNU,
    output [1:0] NSM_state
    );
    
    reg [1:0] Curr_state = 2'b00;
    reg [1:0] Next_state = 2'b00;
    
    always @ (posedge CLK) begin
        if (RESET)
            Next_state = 2'b00;
            
        else begin
            case(Curr_state)
                // RIGHT
                2'b00: begin
                    if (BTNU)
                        Next_state <= 2'b11;
                    else if (BTND)
                        Next_state <= 2'b01;
                    else
                        Next_state <= Curr_state;
                end
                // DOWN
                2'b01: begin
                    if (BTNR)
                        Next_state <= 2'b00;
                    else if (BTNL)
                        Next_state <= 2'b10;
                    else
                        Next_state <= Curr_state;
                end
                // LEFT
                2'b10: begin
                    if (BTNU)
                        Next_state <= 2'b11;
                    else if (BTND)
                        Next_state <= 2'b01;
                    else
                        Next_state <= Curr_state;
                end
                // UP
                2'b11: begin
                    if (BTNR)
                        Next_state <= 2'b00;
                    else if (BTNL)
                        Next_state <= 2'b10;
                    else
                        Next_state <= Curr_state;
                end
            endcase
        end
        Curr_state <= Next_state;
    end
    
    assign NSM_state = Curr_state;
endmodule