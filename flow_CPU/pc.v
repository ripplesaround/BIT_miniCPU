`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/09 19:29:33
// Design Name: 
// Module Name: pc
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


module pc(
    input pc_clk,
    input rst,
    input [31:0] inst_in,
    input [31:0] jump,
    input control_jump,

    output reg [31:0] inst_out
    // 实现复位功能
    );

    always@(posedge pc_clk,posedge rst)
    // always@(posedge pc_clk)
    begin
        if(rst)
            inst_out <= 32'b0;
        else if(~control_jump)
            inst_out <= jump; 
        else
            inst_out <= inst_in; 
    end
endmodule
