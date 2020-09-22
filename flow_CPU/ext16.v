`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/09 20:09:51
// Design Name: 
// Module Name: ext16
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


module ext16#(parameter depth = 16)(
    input [depth-1:0] a,
    input sign_ext,
    
    output reg [31:0] b
    );

    always@(a or sign_ext)
    begin
        if(sign_ext == 1 && a[depth - 1] == 1)
        begin
            b[31:0] = 32'hffffffff;
            b[depth-1:0] = a[depth-1:0];
        end
        else
        begin
            b[31:0] = 32'h00000000;
            b[depth-1:0] = a[depth-1:0];
        end
    end
endmodule
