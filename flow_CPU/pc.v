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
    input [31:0] rs,
    input control_jr,

    output reg [31:0] inst_out
    // 实现复位功能
    );

    //这一块还需要再仔细看看，为什么加入rst后就会有一个周期的凉凉
    // always@(posedge pc_clk,posedge rst)
    always@(posedge pc_clk)
    begin
        if(rst)
            inst_out <= 32'b0;
        else if(~control_jump)begin
            inst_out <= jump; 
        end
        else if(control_jr)begin
            inst_out <= rs;
        end
        else
            inst_out <= inst_in; 
    end
endmodule
