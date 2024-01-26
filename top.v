`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.10.2023 11:21:12
// Design Name: 
// Module Name: top
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


module top(
    input CLK,
    input RESET,
    input BTNR,
    input BTND,
    input BTNL,
    input BTNU,
    // decoder inits
    output [3:0] SEG_SELECT,
    output [7:0] HEX_OUT,
    // VGA inits
    output [11:0] COLOUR_OUT,
    output HS,
    output VS
    );
    
    
    reg [1:0] Curr_state = 2'b00;
    reg [1:0] Next_state = 2'b00;
    wire [7:0] SCORE;
    wire [3:0] BIN_NO;
    wire [1:0] MSM_state;
    wire [1:0] NSM_state;
    wire [7:0] RTA_X;
    wire [6:0] RTA_Y;
    wire [1:0] STROBE;
    wire [14:0] RTA;
    wire [9:0] X;
    wire [8:0] Y;
    wire [11:0] COLOUR;
    wire [11:0] COLOUR_FONT;

    
    MSM sm1 (
        .CLK(CLK),
        .RESET(RESET),
        .SCORE(SCORE),
        .BTNR(BTNR),
        .BTND(BTND),
        .BTNL(BTNL),
        .BTNU(BTNU),
        .MSM_state(MSM_state)
    );
    NSM sm2 (
        .CLK(CLK),
        .RESET(RESET),
        .BTNR(BTNR),
        .BTND(BTND),
        .BTNL(BTNL),
        .BTNU(BTNU),
        .NSM_state(NSM_state)
    );
    snake_control sm3 (
        .CLK(CLK),
        .RESET(RESET),
        .MSM_state(MSM_state),
        .NSM_state(NSM_state),
        .X(X),
        .Y(Y),
        .RTA_X(RTA_X),
        .RTA_Y(RTA_Y),
        .COLOUR(COLOUR),
        .TARGET_REACHED(TARGET_REACHED)
    );
    target_gen tg (
        .CLK(CLK),
        .RESET(RESET),
        .TARGET_REACHED(TARGET_REACHED),
        .RTA_X(RTA_X),
        .RTA_Y(RTA_Y)
    );
    VGA_wrapper VGA (
        .CLK(CLK),
        .RESET(RESET),
        .MSM_state(MSM_state),
        .COLOUR_IN(COLOUR),
        .COLOUR_FONT(COLOUR_FONT),
        .COLOUR_OUT(COLOUR_OUT),
        .HS(HS),
        .VS(VS),
        .X(X),
        .Y(Y)
    );

    score_counter sc (
        .CLK(CLK),
        .RESET(RESET),
        .TARGET_REACHED(TARGET_REACHED),
        .STROBE(STROBE),
        .SCORE(SCORE)
    );
    decoder_2 decode (
        .SEG_SELECT_IN(2'b00),
        .BIN_IN(SCORE),
        .DOT_IN(1'b0),
        .SEG_SELECT_OUT(SEG_SELECT),
        .HEX_OUT(HEX_OUT)
    );

endmodule
