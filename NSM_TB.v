`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.11.2023 23:05:46
// Design Name: 
// Module Name: NSM_TB
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


module NSM_tb;

    // Declare the module instance
    NSM uut (
        .CLK(CLK),
        .RESET(RESET),
        .BTNR(BTNR),
        .BTND(BTND),
        .BTNL(BTNL),
        .BTNU(BTNU),
        .NSM_state(NSM_state)
    );

    // Declare the test inputs
    reg CLK;
    reg RESET;
    reg BTNR;
    reg BTND;
    reg BTNL;
    reg BTNU;

    // Declare the output
    wire [1:0] NSM_state;

    // Clock generation
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

    // Stimulus
    initial begin
        RESET = 1; // Initial reset
        #10 RESET = 0; // Release reset after 10 time units

        // Test case 1: Press UP button
        #15;
        BTNU = 1;
        #20 BTNU = 0;

        // Test case 2: Press DOWN button
        #15;
        BTND = 1;
        #20 BTND = 0;

        // Add more test cases as needed
        
        // End simulation
        #50 $finish;
    end

endmodule

