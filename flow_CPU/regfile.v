`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/09 19:51:34
// Design Name: 
// Module Name: regfile
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


module regfile(
    input clk,
    input rst,
    input we,
    input not_move,
    input [4:0] raddr1,
    input [4:0] raddr2,
    input [4:0] waddr,
    input [31:0] wdata,

    // 数据相关的修改
    input [31:0] wdata_i_E,
    input [4:0] waddr_i_E,
    input wreg_i_E,
    input [31:0] wdata_i_M,
    input [4:0] waddr_i_M,
    input wreg_i_M,
    // input [31:0] wdata_i_W,
    input [4:0] waddr_i_W,
    // input wreg_i_M,

    output reg [31:0] rdata1,
    output reg [31:0] rdata2,
    output reg rdata1_zero,
    output reg rdata2_zero );
    //少一个准许读的信号 readenable

    reg [31:0] array_reg[31:0];
    integer var;
    always@(posedge clk,posedge rst) begin
        if(rst) begin   //复位
            var = 0;
            while(var<32) begin
                array_reg[var] = 0;
                var = var + 1;
            end
        end
        else if((we) && (~not_move)) begin
            if(waddr!=0)        //不能写入零号
                array_reg[waddr] <= wdata; 
        end
    end
    
    always @ (*) begin
        if ((raddr1 == waddr_i_E) && (we)) begin
            rdata1 <= wdata_i_E;
        end
        else if ((raddr1 == waddr) && (we)) begin
            rdata1 <= wdata;
        end
        else if ((raddr1 == waddr_i_W) && (we)) begin
            rdata1 <= wdata;
        end
        else if ((raddr1 == waddr_i_M) && (we)) begin
            rdata1 <= wdata_i_M;
        end
        else begin
            rdata1 <= array_reg[raddr1];
        end
    end

    always @ (*) begin
        if ((raddr2 == waddr_i_E) && (we)) begin
            rdata2 <= wdata_i_E;
        end
        else if ((raddr2 == waddr) && (we)) begin
            rdata2 <= wdata;
        end
         else if ((raddr2 == waddr_i_W) && (we)) begin
            rdata2 <= wdata;
        end
        else if ((raddr2 == waddr_i_M) && (we)) begin
            rdata2 <= wdata_i_M;
        end
        else begin
            rdata2 <= array_reg[raddr2];
        end
    end

    always @ (*) begin
        if (rdata1 == 32'b00000000) begin
            rdata1_zero <= 1;
        end
        else begin
            rdata1_zero <= 0;
        end
    end
     always @ (*) begin
        if (rdata2 == 32'b00000000) begin
            rdata2_zero <= 1;
        end
        else begin
            rdata2_zero <= 0;
        end
    end
    // assign rdata1 = array_reg[raddr1];
    // assign rdata2 = array_reg[raddr2];
endmodule
