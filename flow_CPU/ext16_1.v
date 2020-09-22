`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/09 20:37:45
// Design Name: 
// Module Name: ext16_1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: 反向拓展
// 
//////////////////////////////////////////////////////////////////////////////////


module ext16_1#(parameter DEPTH=16)(
    input [DEPTH-1:0] a,
    output reg [31:0] b
    );
    always@(a)
        begin 
            b[31:0] = 32'h00000000;
            b[31:DEPTH] = a[DEPTH-1:0];
        end
endmodule
