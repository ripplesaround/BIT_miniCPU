`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/09 21:11:43
// Design Name: 
// Module Name: flow_cpu
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


module flow_cpu(
    input clk,
    input [31:0] inst_F,
    input reset,
    input [31:0] mr_data_M,

    output [31:0] pc_outF,
    output [31:0] maddr,
    output [31:0] mwdata,
    output IM_R,
    output DM_CS_M,
    output DM_R_M,
    output DM_W_M,
    output [31:0]alu_r
    );

    wire RF_W_D, RF_W_E_alu_in, RF_W_E, RF_W_M, RF_W_W;
    wire M1_D,M1_E,M1_M,M2_D,M2_E,M2_M;
    wire sign_ext,zero,signal;
    wire M3_0_D, M3_0_E, M3_0_M, M3_0_W ;
    wire M3_1_D, M3_1_E, M3_1_M, M3_1_W ;
    wire M4_0_D, M4_0_E;
    wire M5_D, M5_E, M5_M, M5_W;
    wire M6_D, M6_E;
    wire [3:0] ALUC_D,ALUC_E;
    wire [31:0] mux1_out_F, mux2_out_E,mux2_out_M,mux2_out_F;
    wire [31:0] mux4_out_E, mux5_out_W, alu_out_E,alu_out_M,alu_out_W;
    wire [31:0] mux3_out_W;
    wire [31:0] inst_D, inst_E;
    wire [31:0] rf_rdata1_D,rf_rdata1_E;
    wire [31:0] rf_rdata2_D,rf_rdata2_E,rf_rdata2_M;
    wire [31:0] ext16_out_D, ext16_out_E, ext18_out_D, ext18_out_E, ext18_out_M;
    wire [31:0] ext16_1_out_D, ext16_1_out_E, ext16_1_out_M, ext16_1_out_W;
    wire [31:0] npc_out_D, npc_out_F, npc_out_E, npc_out_M;
    wire [31:0] join_out_F,join_out_D,join_out_E,join_out_M;
    wire [31:0] pc_outD;
    wire [4:0] mux6_out_E,mux6_out_M,mux6_out_W;
    wire [4:0] shamt_D,shamt_E;
    wire DM_CS_D, DM_CS_E, DM_CS_M;
    wire DM_R_D, DM_R_E, DM_R_M;
    wire DM_W_D, DM_W_E, DM_W_M;
    wire rdata1_zero_D,rdata1_zero_E;
    wire rdata2_zero_D,rdata2_zero_E;
    wire not_move_E,not_move_M,not_move_W;


    assign alu_r = alu_out_E;
    
    // 实际上是memory模块
    assign maddr = alu_out_M;
    assign mwdata= rf_rdata2_M;

    
    // F to D
    flopr #(32)F1D(clk,reset,npc_out_F,npc_out_D);
    flopr #(32)F2D(clk,reset,inst_F,inst_D);
    // flopr #(32)F3D(clk,reset,join_out_F,join_out_D);
     flopr #(32)F3D(clk,reset,pc_outF,pc_outD);


    // D to E
    flopr #(32)D1E(clk,reset,npc_out_D,npc_out_E);
    flopr #(32)D2E(clk,reset,rf_rdata1_D,rf_rdata1_E);
    flopr #(32)D3E(clk,reset,rf_rdata2_D,rf_rdata2_E);
    flopr #(32)D4E(clk,reset,inst_D,inst_E);
    flopr #(1) D5E(clk,reset,M6_D,M6_E);
    flopr #(32)D6E(clk,reset,ext16_1_out_D, ext16_1_out_E);
    flopr #(32)D7E(clk,reset,ext16_out_D, ext16_out_E);
    flopr #(32)D8E(clk,reset,ext18_out_D,ext18_out_E);
    flopr #(1) D9E(clk,reset,M3_0_D,M3_0_E);
    flopr #(1) D10E(clk,reset,M3_1_D,M3_1_E);
    flopr #(1) D11E(clk,reset,M5_D,M5_E);
    flopr #(1) D12E(clk,reset,M4_0_D,M4_0_E);
    flopr #(4) D13E(clk,reset,ALUC_D,ALUC_E);
    flopr #(1) D14E(clk,reset,RF_W_D,RF_W_E);
    flopr #(1) D15E(clk,reset,DM_CS_D,DM_CS_E);
    flopr #(1) D16E(clk,reset,DM_W_D,DM_W_E);
    flopr #(1) D17E(clk,reset,DM_R_D,DM_R_E);
    flopr #(1) D18E(clk,reset,M2_D,M2_E);
    flopr #(1) D19E(clk,reset,M1_D,M1_E);
    flopr #(32)D20E(clk,reset,join_out_D,join_out_E);
    flopr #(5) D21E(clk,reset,shamt_D,shamt_E);
    flopr #(1) D22E(clk,reset,rdata1_zero_D,rdata1_zero_E);
    flopr #(1) D23E(clk,reset,rdata2_zero_D,rdata2_zero_E);
    // flopr_r #(1) D24E(clk,reset,not_move_E);

    // E to M
    flopr #(32)E1M(clk,reset, alu_out_E, alu_out_M);
    flopr #(5) E2M(clk,reset, mux6_out_E, mux6_out_M);
    flopr #(1) E3M(clk,reset,M3_1_E,M3_1_M);
    flopr #(1) E4M(clk,reset,M3_0_E,M3_0_M);
    flopr #(1) E5M(clk,reset,M5_E, M5_M);
    flopr #(1) E6M(clk,reset,RF_W_E,RF_W_M);
    flopr #(1) E7M(clk,reset,DM_CS_E,DM_CS_M);
    flopr #(1) E8M(clk,reset,DM_W_E,DM_W_M);
    flopr #(1) E9M(clk,reset,DM_R_E,DM_R_M);
    flopr #(32)E10M(clk,reset,rf_rdata2_E,rf_rdata2_M);
    flopr #(32)E11M(clk,reset,ext16_1_out_E, ext16_1_out_M);
    flopr #(32)E12M(clk,reset,mux2_out_E, mux2_out_M);
    flopr #(1) E13M(clk,reset,M1_E,M1_M);
    flopr #(32)E14M(clk,reset,join_out_E,join_out_M);
    flopr #(32)E15M(clk,reset,npc_out_E,npc_out_M);
    flopr #(1) E16M(clk,reset,M2_E, M2_M);
    flopr #(32)E17M(clk,reset,ext18_out_E,ext18_out_M);
    flopr #(1) E18M(clk,reset,not_move_E,not_move_M);

    // M to W
    flopr #(5) M1W(clk,reset, mux6_out_M, mux6_out_W);
    flopr #(32)M2W(clk,reset, alu_out_M, alu_out_W);
    flopr #(1) M3W(clk,reset,M3_1_M,M3_1_W);
    flopr #(1) M4W(clk,reset,M3_0_M,M3_0_W);
    flopr #(1) M5W(clk,reset,M5_M, M5_W);
    flopr #(1) M6W(clk,reset,RF_W_M,RF_W_W);
    flopr #(32)M7W(clk,reset, mr_data_M, mr_data_W);
    flopr #(32)M8W(clk,reset,ext16_1_out_M, ext16_1_out_W);
    flopr #(1) M9W(clk,reset,not_move_M, not_move_W);

    // alu_out_E,mux6_out_E, RF_W_E, mr_data_M, mux6_out_M, RF_W_M,   
    decoder cpu_decoder(inst_D,clk,zero,signal,           IM_R,M3_0_D,M3_1_D,M4_0_D, ALUC_D, shamt_D ,M2_D, M5_D, M6_D , RF_W_D, M1_D, DM_CS_D, DM_R_D, DM_W_D, sign_ext);
    //sign_ext 只在decode一个周期内使用，所以并不需要传递

    pc cpu_pc(clk,reset,mux2_out_F,join_out_D,M1_D,pc_outF);

    npc cpu_npc(pc_outF,npc_out_F);
    jump cpu_jump(inst_D[25:0],pc_outD[31:28],join_out_D); //jump指令

    // problem: ALU的第二个周期就执行了，应该在第三个周期
    // ans：只是再第一个周期会存在这种状况，在后续的周期应该就正常了dvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
    alu cpu_alu(rf_rdata1_E,mux4_out_E,shamt_E,ALUC_E, alu_out_E,zero,signal,not_move_E);
    
    // Decoder阶段进行符号位拓展
    ext16 cpu_ext16(inst_D[15:0],sign_ext,ext16_out_D);
    ext18 cpu_ext18(inst_D[15:0],ext18_out_D);
    ext16_1 cpu_ext16_1(inst_D[15:0],ext16_1_out_D);

    
    regfile cpu_regfile(clk,reset,RF_W_W,not_move_W, inst_D[25:21],inst_D[20:16],mux6_out_W,mux3_out_W,       alu_out_E,mux6_out_E, RF_W_E, alu_out_M, mux6_out_M, RF_W_M, mux6_out_W,        rf_rdata1_D,rf_rdata2_D,  rdata1_zero_D,rdata2_zero_D);
    //注意输出的地址

    // 跳转指令用
    // 跳转和分支指令的判断应该分开
    mux1_2 mux1(join_out_M,mux2_out_F,M1_M,mux1_out_F);

    // 放在取指阶段，判断完之后再送memory阶段
    mux1_2 mux2(npc_out_F, (ext18_out_M + npc_out_M + 4),M2_M,mux2_out_F);
    //branch

    // Writeback阶段
    mux2_4 mux3(alu_out_W, ext16_1_out_W, mr_data_W , mux5_out_W, M3_0_W, M3_1_W, mux3_out_W);

    // Exectue阶段
    mux1_2 mux4(rf_rdata2_E, ext16_out_E, M4_0_E, mux4_out_E);    //虽然是3但实际上变成了2个，因为无符号拓展和符号拓展合并了

    mux1_2 mux5(32'h00000000,32'h00000001,M5_W, mux5_out_W);

    // wire [4:0]mux6_out = M6 ? inst_D[20:16]:inst_D[15:11];
    mux1_2 #(5) mux6(inst_E[15:11],inst_E[20:16], M6_E, mux6_out_E);

    // mux1_2 mux7(32'h00000000,32'h00000001,M5_W, mux7_out_W);

endmodule
