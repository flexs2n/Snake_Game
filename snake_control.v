`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.11.2023 10:52:38
// Design Name: 
// Module Name: snake_control
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


module snake_control(
    input CLK,
    input RESET,
    input [1:0] MSM_state,
    input [1:0] NSM_state,
    input [9:0] X,
    input [8:0] Y,
    input [7:0] RTA_X,
    input [6:0] RTA_Y,
    output reg [11:0] COLOUR,
    output reg TARGET_REACHED
    );
    
    parameter MaxX = 8'd159;
    parameter MaxY = 8'd119;
    parameter initSnakeLength = 5'd5;
    parameter maxSnakeLength = 5'd25;
    reg [4:0] SnakeLength = initSnakeLength;
    integer i;
    wire [1:0] DIRECTION = NSM_state;
    wire MOVEMENT;
    reg [7:0] SnakeState_X [0: maxSnakeLength - 1];
    reg [6:0] SnakeState_Y [0: maxSnakeLength - 1];
    reg [7:0] TargetX;
    reg [6:0] TargetY;
    generic_counter # (.COUNTER_WIDTH(23), .COUNTER_MAX(6249999)) 
       CLK (
        .CLK(CLK),
        .RESET(1'b0),
        .ENABLE(1'b1),
        .TRIG_OUT(MOVEMENT)
    );  
    
    genvar PixNo;
    generate
        for (PixNo = 0; PixNo < maxSnakeLength - 1; PixNo = PixNo + 1)
        begin: PixShift
            always @(posedge CLK) begin
                if (PixNo <= SnakeLength) begin
                    if (RESET) begin
                        SnakeState_X[PixNo + 1] <= 80;
                        SnakeState_Y[PixNo + 1] <= 100;
                    end
                    else if (MOVEMENT) begin
                        SnakeState_X[PixNo + 1] <= SnakeState_X[PixNo];
                        SnakeState_Y[PixNo + 1] <= SnakeState_Y[PixNo];
                    end 
                end
            end
        end
    endgenerate
    
    always @ (posedge CLK) begin
        if (RESET || MSM_state == 2'b00) begin
            SnakeState_X[0] <= 80;
            SnakeState_Y[0] <= 100;
            SnakeLength <= initSnakeLength;
            TargetX <= (RTA_X*160)/256;
            TargetY <= (RTA_Y*120)/128;
        end
        else if (MOVEMENT && MSM_state == 2'b01) begin
            case (DIRECTION)
                // RIGHT
                2'b00: begin
                    if (SnakeState_X[0] >= MaxX)
                        SnakeState_X[0] <= 0;
                    else
                        SnakeState_X[0] <= SnakeState_X[0] + 1;
                end
                // DOWN
                2'b01: begin
                    if (SnakeState_Y[0] >= MaxY)
                        SnakeState_Y[0] <= 0;
                    else
                        SnakeState_Y[0] <= SnakeState_Y[0] + 1;
                end
                // LEFT
                2'b10: begin
                    if (SnakeState_X[0] <= 0)
                        SnakeState_X[0] <= MaxX;
                    else
                        SnakeState_X[0] <= SnakeState_X[0] - 1;
                end
                // UP
                2'b11: begin
                    if (SnakeState_Y[0] <= 0)
                        SnakeState_Y[0] <= MaxY;
                    else
                        SnakeState_Y[0] <= SnakeState_Y[0] - 1;
                end
            endcase
        end 
        COLOUR = 12'h0F0; // cyan background
        if (X >= TargetX*4 && X < TargetX*4 + 4
         && Y >= TargetY*4 && Y < TargetY*4 + 4)
            COLOUR = 12'h00F; // red target
        for (i = 0; i < maxSnakeLength; i = i + 1) begin
            if (X >= SnakeState_X[i]*4 && X < SnakeState_X[i]*4 + 4
             && Y >= SnakeState_Y[i]*4 && Y < SnakeState_Y[i]*4 + 4
             && i < SnakeLength)
                COLOUR = 12'hF0F; // yellow snake
        end
        if (SnakeState_X[0] == TargetX && SnakeState_Y[0] == TargetY && MOVEMENT)begin
            SnakeLength <= SnakeLength + 1;
            TARGET_REACHED <= 1;
            TargetX <= (RTA_X*160)/256;
            TargetY <= (RTA_Y*120)/128;
        end
        else begin
            TARGET_REACHED <= 0;
        end
    end
endmodule
