`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.11.2023 11:09:44
// Design Name: 
// Module Name: score_counter
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


module score_counter(
    input CLK,
    input RESET,
    input TARGET_REACHED,
    output [1:0] STROBE,
    output reg [7:0] SCORE
    );
    generic_counter # (
        .COUNTER_WIDTH(17),
        .COUNTER_MAX(99999)
        )
        Bit17Counter (
        .CLK(CLK),
        .RESET(1'b0),
        .ENABLE(1'b1),
        .TRIG_OUT(TriggOut),
        .COUNT(COUNT1)
    );   
    
    generic_counter # (
        .COUNTER_WIDTH(2),
        .COUNTER_MAX(3)
        )
        CLK1 (
        .CLK(CLK),
        .RESET(1'b0),
        .ENABLE(TriggOut),
        .TRIG_OUT(CLK1OUT),
        .COUNT(STROBE)
    );   
    
    always @ (posedge CLK) begin
        if (RESET)
            SCORE <= 0;
        else if (TARGET_REACHED)
            SCORE <= SCORE + 1;
    end
endmodule
