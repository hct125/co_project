
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/16 22:30:07
// Design Name: 
// Module Name: datepath
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
//clk,rst,memtoreg,pcsrc,alusrc,regdst,regwrite,jump,
//alucontrol,overflow,zero,pc,instr,aluout,writedata,readdata
//////////////////////////////////////////////////////////////////////////////////


module datapath(
	input wire clk,rst,
	output memtoreg_D,memwrite_D, pcsrc_M, alusrc_D, regdst_D, regwrite_D, jump,branch_D,
	output [2:0] alucontrol_D,
	output overflow,zero_E,
    output wire[31:0] pc_F,
    input wire[31:0] instr_D,
    output wire[31:0] aluout_E,writedata_E,
    input wire[31:0] readdata_M
    );
    
    wire [31:0] pc_4,pc_b,pc_next,srcA,srcB,wd3_result_W,extend_offset,pc_branch,branch_offset,pc_jump,jump_offset;
    wire [4:0] rs,rt,rd,writereg;
    wire [15:0] offset;
    assign offset=instr_D[15:0];
    assign rs = instr_D[25:21];
    assign rt = instr_D[20:16];
    assign rd = instr_D[15:11];
    
    
    //fetch 

    
    // IF/ID寄存器
    wire [31:0]pc_4_F,pc_4_D,instr_F;
    wire [63:0]F2D_in,F2D_out;
    assign F2D_in={pc_4_F,instr_F};
    assign {pc_4_D,instr_D} =F2D_out;
    
    //decode

    wire [146:0] D2E_in;       // D->E寄存器输入
    wire [146:0] D2E_out;      // D->E寄存器输出
    
    // 控制信号
    wire regwrite_E, memtoreg_E, memwrite_E,branch_E,alusrc_E, regdst_E;
    wire [2:0] alucontrol_E;
    
    // 数据信号
    wire [31:0] rd1_D, rd2_D, ext_off_D;
    wire [31:0] srcA_E, ext_off_E,pc_4_E;
    wire [4:0] rt_E,rd_E;
    
    assign D2E_in = {
        regwrite_D,    // 1
        memtoreg_D,    // 1
        memwrite_D,    // 1
        branch_D,      // 1
        alucontrol_D,  // 3
        alusrc_D,      // 1
        regdst_D,      // 1
        rd1_D,         // 32
        rd2_D,         // 32
        instr [20:11],  //10
        ext_off_D,    // 32
        pc_4_D       // 32
    }; // 147
    
    assign {
        regwrite_E,     // 1
        memtoreg_E,     // 1
        memwrite_E,     // 1        
        branch_E,       // 1        
        alucontrol_E,   // 3
        alusrc_E,       // 1
        regdst_E,       // 1
        srcA_E,          // 32
        writedata_E,          // 32
        rt_E,          //32
        rd_E,           //32
        ext_off_E,     // 32        
        pc_4_E         // 32
    } = D2E_out; //147
    
    // execute
    wire [105:0] E2M_in;       // E->M寄存器输入
    wire [105:0] E2M_out;      // E->M寄存器输出
    
    wire [4:0] writereg_E,writereg_M;
    wire [31:0] pc_branch_E,aluout_M,writedata_M,pc_branch_M;
    wire regwrite_M,memtoreg_M,memwrite_M,branch_M,zero_M;
    
    assign E2M_in = {
        regwrite_E,     // 1
        memtoreg_E,     // 1
        memwrite_E,     // 1
        branch_E,       // 1
        zero_E,        //1
        aluout_E,   // 32
        writedata_E,   //32
        writereg_E,    // 5
        pc_branch_E     // 32
    }; //106
    
    assign {
        regwrite_M,     // 1
        memtoreg_M,     // 1
        memwrite_M,     // 1
        branch_M,       // 1
        zero_M,           //1
        aluout_M,   // 32
        writedata_M,   //32
        writereg_M,    // 5
        pc_branch_M     // 32
    } = E2M_out; // Total 106 bits
    
    // Memory阶段
    wire [70:0] M2W_in;        // M->W寄存器输入
    wire [70:0] M2W_out;       // M->W寄存器输出
    wire regwrite_W,memtoreg_W;
    wire [31:0] readdata_W,alu_result_W;
    wire [4:0] writereg_W;
    
    assign M2W_in = {
        regwrite_M,     // 1
        memtoreg_M,     // 1
        readdata_M,     // 32
        aluout_M,   // 32
        writereg_M     // 5
    }; // Total 71 bits
    
    assign {
        regwrite_W,     // 1
        memtoreg_W,     // 1
        readdata_W,     // 32
        aluout_W,   // 32
        writereg_W     // 5
    } = M2W_out; // Total 71 bits
    
    //Writeback
    wire [31:0] wd3_W;         // 写回数据
    

    //fetch阶段
    flopr pc_next_(
    .clk(clk),.rst(rst),
    .d(pc_next),
    .q(pc_F)
    );
    //decode
        flopenrc #(64) F2D_reg(
        .clk(clk), .rst(rst),
        .en(~stall_F), 
        .clear(flush_F),
        .d(F2D_in),
        .q(F2D_out)
    );
    
    flopenrc #(147) D2E_reg(
        .clk(clk), .rst(rst),
        .en(~stall_D),
        .clear(flush_D),
        .d(D2E_in),
        .q(D2E_out)
    );
    
    flopenrc #(106) E2M_reg(
        .clk(clk), .rst(rst),
        .en(1'b1),  // 通常不需要暂停
        .clear(flush_E),
        .d(E2M_in),
        .q(E2M_out)
    );
    
    flopenrc #(71) M2W_reg(
        .clk(clk), .rst(rst),
        .en(1'b1),  // 通常不需要暂停
        .clear(1'b0),
        .d(M2W_in),
        .q(M2W_out)
    );

    
        
    mux2 regdst_(       //寄存器堆写数据地址选择，wa3
    .s(regdst_E),
    .a(rd_E),
    .b(rt_E),
    .y(writereg_E)
    );
    
    regfile regfile(    //寄存器堆
        .clk(clk),
        .we3(regwrite_D),
        .ra1(rs),
        .ra2(rt),
        .wa3(writereg_W),
        .wd3(wd3_result_W),
        .rd1(rd1_D),
        .rd2(rd2_D)
    );
    
    
    signext signext(    //有符号拓展
    .a(offset),
    .y(ext_off_D)
    );
    
    mux2 alusrc_(       //alusrcB端口数据选择
    .s(alusrc_E),
    .a(ext_off_E),
    .b(writedata_E),
    .y(srcB)
    );
    
    alu alu(          //alu
    .num1(srcA),
    .num2(srcB),
    .op(alucontrol_E),
    .result(aluout_E),
    .zero(zero_E)
    );
    
    assign pcsrc_M = zero_M & branch_M;     //分支跳转指令pcsrc
    
    mux2 memtoreg_(         //寄存器堆写数据选择，wd3
    .s(memtoreg_W),
    .a(readdata_W),
    .b(aluout_W),
    .y(wd3_result_W)
    );
    
    adder pc_plus(       //pc+4
    .a(pc_F),
    .b(32'h4),
    .y(pc_4_F)
    );
    
    sl2 pc_branch_sl2(        //分支跳转偏移量左移
    .a(ext_off_E),
    .y(branch_offset)
    );
    
    sl2 pc_jump_sl2(          //jump偏移量左移
    .a(instr_D),
    .y(jump_offset)
    );
    
    assign pc_jump = {pc_4[31:28],jump_offset[27:0]};    //jump地址计算
    
    adder pc_branch_add(     //分支跳转地址计算
    .a(pc_4),
    .b(branch_offset),
    .y(pc_branch_E)
    );
    
    mux2 pcsrc_(           //分支跳转判断
    .s(pcsrc_M),
    .a(pc_branch_M),
    .b(pc_4_F),
    .y(pc_b)
    );
    
    mux2 jump_(          //jump判断
    .s(jump),
    .a(pc_jump),
    .b(pc_b),
    .y(pc_next)
    );
    
    pc pc_(             //pc_next赋值给pc
    .clk(clk),
    .rst(rst),
    .pc_next(pc_next),
    .pc(pc)
    );
    
endmodule
