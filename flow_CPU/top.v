`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/10 00:11:40
// Design Name: 
// Module Name: top
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


module top(
    input clk_in,
    input reset, //

    output clk  //
    // output [31:0]pc,
    // output [31:0]inst,
    // output [31:0]addr,
    // output [31:0]rdata,
    // output [31:0]wdata,
    // output IM_R,
    // output DM_CS,
    // output DM_R,
    // output DM_W,
    // output [31:0]alu_r     
    );
    // reg clk;
    wire [31:0]pc;
    wire [31:0]inst;
    wire [31:0]addr;
    wire [31:0]rdata;
    wire [31:0]wdata;
    wire IM_R;
    wire DM_CS;
    wire DM_R;
    wire DM_W;
    wire [31:0]alu_r;

    assign clk = clk_in;
    
    flow_cpu fcpu(clk_in,inst,reset,rdata,pc,addr,wdata,IM_R,DM_CS,DM_R,DM_W,alu_r);
                
    // imem imemory(pc, IM_R, inst);
    inst_ram inst_memory(
        .a(pc[12:2]),
        .clk(clk_in),
        .spo(inst)
        );
    
    // dmem scdmem(clk_in,reset,DM_CS,DM_W,DM_R,addr,wdata,rdata);
    data_sram_0 data_memory(
        .a(addr[12:2]),
        .clk(clk_in),
        .d(wdata),
        .dpra(addr[12:2]),
        .we( DM_W | DM_R ),

        .dpo(rdata)
    );


endmodule
