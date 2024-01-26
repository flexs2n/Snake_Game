`timescale 1ns / 1ps


// 640x480

module VGA_wrapper(
    input CLK,
    input RESET,
    input [1:0] MSM_state,
    input [11:0] COLOUR_IN,
    input [11:0] COLOUR_FONT,
    output [11:0] COLOUR_OUT,
    output HS,
    output VS,
    output [9:0] X,
    output [8:0] Y
    );
    
    // initiate variables, regs and wires
    reg [11:0] COLOUR;
    wire [8:0] Y;
    wire [9:0] X;
    wire FRAME;
    wire [2:0] COUNT8;
    reg [15:0] FrameCount;
    // instantiate a 1 second counter
    generic_counter # (.COUNTER_WIDTH(27), .COUNTER_MAX(99999999)) 
    CLK1 (
        .CLK(CLK),
        .RESET(1'b0),
        .ENABLE(MSM_state == 2'b10),
        .TRIG_OUT(CLK1OUT),
        .COUNT(COUNT)
    );   
    generic_counter # (.COUNTER_WIDTH(3), .COUNTER_MAX(8))
    CLK8 (
        .CLK(CLK),
        .RESET(1'b0),
        .ENABLE(CLK1OUT),
        .TRIG_OUT(CLK8OUT),
        .COUNT(COUNT8)
    );  
    // pass COLOUR to the VGA interface, COLOUR_OUT is then passed to the VGA port
    VGA_interface interface (
               .CLK(CLK),
               .COLOUR_IN(COLOUR),
               .ADDRH(X),
               .ADDRV(Y),
               .COLOUR_OUT(COLOUR_OUT),
               .HS(HS),
               .VS(VS),
               .FRAME(FRAME)
       );



    always@(posedge CLK) begin
        if(Y == 479) 
            FrameCount <= FrameCount + 1;
    end 
    always@(posedge CLK) begin
        // IDLE
        if (MSM_state == 2'b00)
            COLOUR <= COLOUR_FONT;
        // PLAY
        else if (MSM_state == 2'b01) begin
            COLOUR <= COLOUR_IN;
        end
        // WIN
        else if (MSM_state == 2'b10) begin
            if (Y[8:0] > 240) begin
                if (X[9:0] > 320)
                    COLOUR <= FrameCount[15:8] + Y[8:0] + X[9:0] - 240 - 320;
                else
                    COLOUR <= FrameCount[15:8] + Y[8:0] - X[9:0] - 240 + 320;
            end
            else begin
                if (X[9:0] > 320)
                    COLOUR <= FrameCount[15:8] - Y[8:0] + X[9:0] + 240 - 320;
                else
                    COLOUR <= FrameCount[15:8] - Y[8:0] - X[9:0] + 240 + 320;
            end
        end
        else
            COLOUR <= 12'hFF0;
    end
endmodule
