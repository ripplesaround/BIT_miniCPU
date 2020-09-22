`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/09 19:34:43
// Design Name: 
// Module Name: imem
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


module imem(
    input [31:0] a,
    input IM_R,

    output [31:0] rd
    );
    reg [31:0] RAM[2047:0];

    initial
    begin
        $readmemh("C:/Users/-Ripples/Desktop/imem.txt",RAM);
    end
    // assign rd = (IM_R) ? RAM[a[31:2]]:32'bx;
    assign rd = (IM_R) ? RAM[a[31:2]]:32'bx;
endmodule
