`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/09 20:30:58
// Design Name: 
// Module Name: dmem
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


module dmem(
    input clk,
    input rst,
    input CS,
    input DM_W,
    input DM_R,
    input [31:0] addr,
    input [31:0] wdata,

    output [31:0] rdata
    );

    reg [31:0] RAM [2047:0];
    assign rdata = (CS & DM_R) ? RAM[addr[31:2]]:32'h0;

    always @(posedge clk) begin
        if(CS & DM_W)
            RAM[addr[31:2]] <= wdata; 
    end
endmodule