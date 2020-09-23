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
    input [5:0] aluc,   //和之前的一样
    // input RF_W_in,  //movn指令
    input [31:0] current_pc,    //这条指令的pc

    // output reg RF_W_out,
    output [31:0] r,
    output zero, //beq
    output signal ,//
    output not_move, //
    output overflow //
    );
    reg [31:0] r_1;
    reg overflow_1;
    reg not_move_1;
    reg have_singal;
    // always@* begin
    //     case(aluc)
    //     4'b0000: r_1 = a+b;
    //     4'b0010: r_1 = a+b;  //add 还要加溢出判断
    //     4'b0001: r_1 = a-b;  //beq stli
    //     4'b0100: r_1 = a|b;  //ori
    //     4'b0110: r_1 = a^b;  //xori
    //     4'b0011: r_1 = a&b;  //andi
    //     4'b0101: r_1 = ~(a|b);   //nor
    //     4'b1000: r_1 = b<<shamt;
    //     default:;
    //     endcase
    // end
    
    always @ (*) begin
        if (aluc == 6'b000000) begin
            // addu addiu
            r_1 = a+b;
            not_move_1 = 1'b0;
            overflow_1 = 1'b0;
            have_singal = 1'b0;
        end
        else if (aluc == 6'b000010) begin
            //add addi
            r_1 <= $signed(a)+$signed(b);
            not_move_1 <= 1'b0;
            if ( (a[31]&b[31]&~r_1[31]) | (~a[31]&~b[31]&r_1[31]) ) begin
                overflow_1 <= 1'b1;
                r_1 <= 32'h0;
            end
            have_singal <= 1'b1;
        end
        else if (aluc == 6'b000001) begin
            //subu
            r_1 = a-b;
            not_move_1 = 1'b0;
            overflow_1 = 1'b0;
            have_singal = 1'b0;
        end
        else if (aluc == 6'b000111) begin
            //sub
            r_1 <= $signed(a) - $signed(b);
            not_move_1 <= 1'b0;
            if ( (a[31]&b[31]&~r_1[31]) | (~a[31]&~b[31]&r_1[31]) ) begin
                overflow_1 <= 1'b1;
                r_1 <= 32'h0;
            end
            have_singal <= 1'b1;
        end
        else if (aluc == 6'b000100) begin
            //or ori
            r_1 = a|b;
            not_move_1 = 1'b0;
            overflow_1 = 1'b0;
            have_singal = 1'b0;
        end
        else if (aluc == 6'b000110) begin
            r_1 = a^b;
            not_move_1 = 1'b0;
            overflow_1 = 1'b0;
            have_singal = 1'b0;
        end
        else if (aluc == 6'b000011) begin
            r_1 = a&b;
            not_move_1 = 1'b0;
            overflow_1 = 1'b0;
            have_singal = 1'b0;
        end
        else if (aluc == 6'b000101) begin
            r_1 = ~(a|b); 
            not_move_1 = 1'b0;
            overflow_1 = 1'b0;
            have_singal = 1'b0;
        end

        else if (aluc == 6'b001000) begin
            // sll
            r_1 = b<<shamt[4:0];
            not_move_1 = 1'b0;
            overflow_1 = 1'b0;
            have_singal = 1'b0;
        end
        else if (aluc == 6'b001001) begin
            // srl
            r_1 = b>>shamt[4:0];
            not_move_1 = 1'b0;
            overflow_1 = 1'b0;
            have_singal = 1'b0;
        end
        else if (aluc == 6'b001010) begin
            // sra
            r_1 = ($signed(b)) >>> shamt[4:0];
            not_move_1 = 1'b0;
            overflow_1 = 1'b0;
            have_singal = 1'b0;
        end
        else if (aluc == 6'b001011) begin
            // sllv
            r_1 = b << a[4:0];
            not_move_1 = 1'b0;
            overflow_1 = 1'b0;
            have_singal = 1'b0;
        end
        else if (aluc == 6'b001101) begin
            // srlv
            r_1 = b >> a[4:0];
            not_move_1 = 1'b0;
            overflow_1 = 1'b0;
            have_singal = 1'b0;
        end
        else if (aluc == 6'b001111) begin
            // srav
            r_1 = ($signed(b)) >> a[4:0];
            not_move_1 = 1'b0;
            overflow_1 = 1'b0;
            have_singal = 1'b0;
        end
        
        else if (aluc == 6'b001110) begin
            //movz
            if(b == 32'b00000000) begin
                // RF_W_out <= RF_W_in;
                not_move_1 = 1'b0;
                overflow_1 = 1'b0;
                r_1 = a;
            end
            else begin
                // RF_W_out <= 1'b0;
                not_move_1 = 1'b1;
                overflow_1 = 1'b0;
                r_1 = 32'h7;
            end
            have_singal = 1'b0;
        end
        else if (aluc == 6'b001100) begin
            //movn
            if(b == 32'b00000000) begin
                // RF_W_out <= RF_W_in;
                not_move_1 = 1'b1;
                overflow_1 = 1'b0;
                // r_1 = a;
            end
            else begin
                // RF_W_out <= 1'b0;
                not_move_1 = 1'b0;
                overflow_1 = 1'b0;
                r_1 = a;
            end
            have_singal = 1'b0;
        end
        
        else if (aluc == 6'b010000) begin
            //jal jalr
            r_1 = current_pc + 32'd8;
            not_move_1 = 1'b0;
            overflow_1 = 1'b0;
            have_singal = 1'b0;
        end

        // else if (aluc == 6'b010001) begin
        //     //jalr
        //     r_1 = 32'h0;
        //     not_move_1 = 1'b0;
        //     overflow_1 = 1'b0;
        //     have_singal = 1'b0;
        // end

        else begin
            not_move_1 = 1'b0;
            r_1 = 32'h0;
            overflow_1 = 1'b0;
            have_singal = 1'b0;
        end
    end

    assign r = r_1;
    assign overflow = overflow_1;
    assign not_move = not_move_1;
    assign zero = r ? 1'b0:1'b1;
    assign signal = (((have_singal)&r[31]==1'b0)| (~have_singal&$unsigned(r)>0)) ? 1'b0:1'b1;  //结果符号
endmodule
