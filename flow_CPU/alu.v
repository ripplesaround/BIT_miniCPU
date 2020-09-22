`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/09 20:16:41
// Design Name: 
// Module Name: alu
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


module alu(
    input [31:0] a,
    input [31:0] b,
    input [4:0] shamt,
    input [3:0] aluc,   //和之前的一样
    // input RF_W_in,  //movn指令

    // output reg RF_W_out,
    output [31:0] r,
    output zero, //beq
    output signal ,//
    output not_move //
    );
    reg [31:0] r_1;
    reg not_move_1;
    always@* begin
        case(aluc)
        4'b0000: r_1 = a+b;
        4'b0010: r_1 = a+b;  //add 还要加溢出判断
        4'b0001: r_1 = a-b;  //beq stli
        4'b0100: r_1 = a|b;  //ori
        4'b0110: r_1 = a^b;  //xori
        4'b0011: r_1 = a&b;  //andi
        4'b0101: r_1 = ~(a|b);   //nor
        4'b1000: r_1 = b<<shamt;
        default:;
        endcase
    end
    
    always @ (*) begin
        if (aluc == 4'b1110) begin
            if(b == 32'b00000000) begin
                // RF_W_out <= RF_W_in;
                not_move_1 = 1'b0;
                r_1 = a;
            end
            else begin
                // RF_W_out <= 1'b0;
                not_move_1 = 1'b1;
                r_1 = 32'h7;
            end
        end
        else if (aluc == 4'b1100) begin
            if(b == 32'b00000000) begin
                // RF_W_out <= RF_W_in;
                not_move_1 = 1'b1;
                // r_1 = a;
            end
            else begin
                // RF_W_out <= 1'b0;
                not_move_1 = 1'b0;
                r_1 = a;
            end
        end
        else begin
            not_move_1 = 1'b0;
        end
    end

    assign r = r_1;
    assign not_move = not_move_1;
    assign zero = r ? 1'b0:1'b1;
    assign signal = (r[31]==1'b0) ? 1'b0:1'b1;
endmodule
