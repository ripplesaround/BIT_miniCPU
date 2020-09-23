`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/09 19:25:58
// Design Name: 
// Module Name: mux
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


module mux1_2#(parameter width = 32)(
    input [width-1:0] a,
    input [width-1:0] b,
    input control,
    
    output reg [width-1:0] r
    );

    always @*
    begin
        case(control)
            1'b0: r=a;
            1'b1: r=b;
        endcase
    end
endmodule

// module mux1_2_E#(parameter width = 32)(
//     input [width-1:0] a,
//     input [width-1:0] b,
//     input control,
//     input enable,
    
//     output reg [width-1:0] r
//     );

//     always @* begin
//     if(enable) begin
//         case(control)
//             1'b0: r=a;
//             1'b1: r=b;
//         endcase
//     end
//     end
// endmodule

module mux2_4#(parameter width = 32)(
    input [width-1:0] a,
    input [width-1:0] b,
    input [width-1:0] c,
    input [width-1:0] d,
    input control_0,
    input control_1,
    
    output reg [width-1:0] r
    );

    always @*
    begin
        case({control_1, control_0})
            2'b00: r=a;
            2'b01: r=b;
            2'b10: r=c;
            2'b11: r=d;
        endcase
    end
endmodule