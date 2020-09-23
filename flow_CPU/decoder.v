`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/09 16:39:29
// Design Name: 
// Module Name: decoder
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


module decoder(
    input [31:0] inst,
    input clk,
    input zero,
    input signal,

    output IM_R,
    output M3_0,
    output M3_1,
    output M4_0,
    // output M4_1,
    output [5:0]ALUC,  //只有加和减法，留一位做拓展保险
    output [4:0]shamt,
    output M2,
    output M5,
    output M6,
    output RF_W,
    output M1,
    output DM_CS,
    output DM_R,
    output DM_W,
    output sign_ext     //
);
    
    wire [5:0] func=inst[5:0];  
    wire [5:0] op=inst[31:26];

    
    wire no_nop = |inst;
    wire r_type=~|op;
    wire addiu,add,lw,sw,beq,j_i,lui,slti,ori,xori,andi,and_basic,or_basic,nor_basic,xor_basic;
    wire nor_basic,sub,subu,sll,srl,sra,movn,movz,sllv,srlv;

    assign add=r_type &func[5]&~func[4]&~func[3]&~func[2]&~func[1]&~func[0];   
    // 可能还要完善符号位和溢出检测
    assign addi = ~op[5]&~op[4]&op[3]&~op[2]&~op[1]&~op[0];    //001001
    assign addiu= ~op[5]&~op[4]&op[3]&~op[2]&~op[1]&op[0];    //001001
    assign lui=~op[5]&~op[4]&op[3]&op[2]&op[1]&op[0]; //001111
    assign lw=op[5]&~op[4]&~op[3]&~op[2]&op[1]&op[0];
    assign sw=op[5]&~op[4]&op[3]&~op[2]&op[1]&op[0];
    assign beq=~op[5]&~op[4]&~op[3]&op[2]&~op[1]&~op[0];
    assign j_i=~op[5]&~op[4]&~op[3]&~op[2]&op[1]&~op[0]; 

    assign slt = r_type &func[5]&~func[4]&func[3]&~func[2]&func[1]&~func[0];
    assign sltu = r_type &func[5]&~func[4]&func[3]&~func[2]&func[1]&func[0];
    assign slti = ~op[5]&~op[4]&op[3]&~op[2]&op[1]&~op[0]; 
    assign sltiu = ~op[5]&~op[4]&op[3]&~op[2]&op[1]&op[0]; 

    //添加的指令集
    assign ori = ~op[5]&~op[4]&op[3]&op[2]&~op[1]&op[0]; 
    assign xori = ~op[5]&~op[4]&op[3]&op[2]&op[1]&~op[0];
    assign andi = ~op[5]&~op[4]&op[3]&op[2]&~op[1]&~op[0]; 
    assign and_basic = r_type &func[5]&~func[4]&~func[3]&func[2]&~func[1]&~func[0];         //00000 100100
    assign or_basic = r_type &func[5]&~func[4]&~func[3]&func[2]&~func[1]&func[0];         //00000 100101
    assign xor_basic = r_type &func[5]&~func[4]&~func[3]&func[2]&func[1]&~func[0];          //000000 100110
    assign nor_basic = r_type &func[5]&~func[4]&~func[3]&func[2]&func[1]&func[0];
    assign subu=r_type &func[5]&~func[4]&~func[3]&~func[2]&func[1]&func[0];
    assign sub =r_type &func[5]&~func[4]&~func[3]&~func[2]&func[1]&~func[0];
    
    // 移位指令
    assign sll = r_type &~func[5]&~func[4]&~func[3]&~func[2]&~func[1]&~func[0] & no_nop;
    assign srl = r_type &~func[5]&~func[4]&~func[3]&~func[2]&func[1]&~func[0] ;   
    assign sra = r_type &~func[5]&~func[4]&~func[3]&~func[2]&func[1]&func[0] ;   
    
    //转移指令
    assign movn = r_type &~func[5]&~func[4]&func[3]&~func[2]&func[1]&func[0];
    assign movz = r_type &~func[5]&~func[4]&func[3]&~func[2]&func[1]&~func[0];
    

    //未检测
    assign sllv = r_type &~func[5]&~func[4]&~func[3]&func[2]&~func[1]&~func[0] ;   
    assign srlv = r_type &~func[5]&~func[4]&~func[3]&func[2]&func[1]&~func[0] ;   
    assign srav = r_type &~func[5]&~func[4]&~func[3]&func[2]&func[1]&func[0] ; 

    
    assign shamt = inst[10:6];

    assign IM_R=1;
    
    assign RF_W=addiu|lw|lui|add|slti | ori | xori | andi | and_basic | or_basic | xor_basic | subu | nor_basic|sll|srl|sllv|srlv|movn|movz|sra|addi|sub|slt|sltu|sltiu;   //需要写回regfile

    assign DM_CS=lw|sw;
    assign DM_R=lw;
    assign DM_W=sw;

    //addu addiu op为0
    assign ALUC[5] = 1'b0;
    assign ALUC[4] = 1'b0;
    assign ALUC[3] = sll|srl| movn |movz| sra |srav;
    assign ALUC[2] = ori | xori  | xor_basic| or_basic | nor_basic |movn | movz|sub|srav|slt|slti;         
    assign ALUC[1] = add | xori  | xor_basic| andi | and_basic |movz |sra|sub|srav| addi|slt|slti;        
    assign ALUC[0] = beq | slti | andi | and_basic | subu | nor_basic |srl|sub|srav|slt |sltu|sltiu;

    // 决定是否跳转 
    assign M1=addiu|add|lw|sw|beq|lui|slti|ori|andi|xori|and_basic|or_basic|xor_basic|subu|nor_basic|sll|srl|movn|movz|sra|addi|sub|sllv|srlv|srav|slt|sltu|sltiu;
    //是否应该做调整 初始值不是零
    
    assign M3_0=lui| slti |slt|sltu|sltiu;     //10 lw 01 lui 00 add,addiu,ori 11 slti
    assign M3_1=lw | slti |slt|sltu|sltiu;      //00 就是直接读取alu的数据
    
    //assign M4_0=addiu;    //01
    //assign M4_1=lw|sw;  //10
    assign M4_0=lw|sw|addiu | slti | ori | xori | andi |addi|sltiu;  // beq add 走0
    assign M2= beq & zero;   // 
    //和立即数有关
    assign M6 = lui|addiu|lw | slti | ori | xori | andi | addi|sltiu;

    // 是否改为由alu直接送出signal信号
    assign M5 = signal;

    //addi
    assign sign_ext= lw | sw |slti | addi|sltiu;

endmodule



// module decoder_3_8(
// 	input [2:0] in, 
// 	output [7:0] out
// 	);
// 	assign out = 	(in == 3'b000) ? 8'b00000001 : 
// 					(in == 3'b001) ? 8'b00000010 :
// 					(in == 3'b010) ? 8'b00000100 :
// 					(in == 3'b011) ? 8'b00001000 :
// 					(in == 3'b100) ? 8'b00010000 :
// 					(in == 3'b101) ? 8'b00100000 :
// 					(in == 3'b110) ? 8'b01000000 :
// 									 8'b10000000 ;
// endmodule

// module decoder_6_64(
// 	input [5:0] in, 
// 	output [63:0] out
// 	);
// 	wire [7:0] subout;
// 	decoder_3_8  decoder0(
// 		.in (in[2:0]),
// 		.out (subout)
// 		);
// 	assign out = 	(in[5:3] == 3'b000) ? {56'b0,subout} : 
// 					(in[5:3] == 3'b001) ? {48'b0,subout,8'b0} :
// 					(in[5:3] == 3'b010) ? {40'b0,subout,16'b0}:
// 					(in[5:3] == 3'b011) ? {32'b0,subout,24'b0} :
// 					(in[5:3] == 3'b100) ? {24'b0,subout,32'b0} :
// 					(in[5:3] == 3'b101) ? {16'b0,subout,40'b0} :
// 					(in[5:3] == 3'b110) ? {8'b0,subout,48'b0} :
// 									 	  {subout,56'b0};
// endmodule

// module decoder_5_32(
// 	input [4:0] in, 
// 	output [31:0] out
// 	);
// 	wire [7:0] subout;
// 	decoder_3_8  decoder0(
// 		.in (in[2:0]),
// 		.out (subout)
// 		);
// 	assign out = 	(in[4:3] == 2'b00) ? {24'b0,subout}: 
// 					(in[4:3] == 2'b01) ? {16'b0,subout,8'b0} :
// 					(in[4:3] == 2'b10) ? {8'b0,subout,16'b0}:
// 										 {subout,24'b0};
// endmodule