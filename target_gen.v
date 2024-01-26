`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.11.2023 11:07:57
// Design Name: 
// Module Name: target_gen
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


module target_gen(
    input CLK,
    input RESET,
    input TARGET_REACHED,
    output reg [7:0] RTA_X,
    output reg [6:0] RTA_Y
    );

    initial begin
        RTA_X <= 80;
        RTA_Y <= 60;
    end
    always @ (posedge CLK)begin
        if (RESET) begin
            RTA_X <= 80;
            RTA_Y <= 60;
        end
        else begin
            RTA_X[0] <= ~(RTA_X[3]^RTA_X[5]^RTA_X[4]^RTA_X[7]);
            RTA_X[1] <= RTA_X[0];
            RTA_X[2] <= RTA_X[1];
            RTA_X[3] <= RTA_X[2];
            RTA_X[4] <= RTA_X[3];
            RTA_X[5] <= RTA_X[4];
            RTA_X[6] <= RTA_X[5];
            
            RTA_Y[0] <= ~(RTA_Y[6]^RTA_Y[5]);
            RTA_Y[1] <= RTA_Y[0];
            RTA_Y[2] <= RTA_Y[1];
            RTA_Y[3] <= RTA_Y[2];
            RTA_Y[4] <= RTA_Y[3];
            RTA_Y[5] <= RTA_Y[4];
            RTA_Y[6] <= RTA_Y[5];
        end
    end
    
    endmodule
