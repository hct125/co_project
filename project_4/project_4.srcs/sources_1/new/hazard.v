module hazard(
    input [4:0] rs_E,rt_E,rs_D,rt_D,writereg_M,writereg_W,writereg_E,//mem阶段，写寄存器的寄存器号
    input regwrite_W,regwrite_M,memtoreg_E,memtoreg_M,regwrite_E,branch_D, //writeback阶段
    output [1:0] forward_AE,forward_BE,
    output forward_AD,forward_BD,
    output stall_F,stall_D,flush_E
    );

assign forward_AE = (rs_E != 5'b0) ? 
                  ((rs_E == writereg_M && regwrite_M) ? 2'b10 :  // MEM前推
                   (rs_E == writereg_W && regwrite_W) ? 2'b01 :  // WB前推
                   2'b00) : 
                  2'b00;

assign forward_BE = (rt_E != 5'b0) ? 
                  ((rt_E == writereg_M && regwrite_M) ? 2'b10 :  // MEM前推
                   (rt_E == writereg_W && regwrite_W) ? 2'b01 :  // WB前推
                   2'b00) : 
                  2'b00;

wire stall = ((rs_D == writereg_E) || (rt_D == writereg_E)) && memtoreg_E;

assign forward_AD = ((rs_D != 0) && (rs_D == writereg_M) && regwrite_M);//writereg写寄存器的寄存器号
assign forward_BD = ((rt_D != 0) && (rt_D == writereg_M) && regwrite_M);//regwrite写寄存器使能信号

wire branch_stall; //拿来判断的是否为之前指令要写的寄存器，是的话计算出来地址再前推进行判断
assign branch_stall = branch_D && regwrite_E && (writereg_E == rs_D || writereg_E == rt_D) || branch_D && memtoreg_M && (writereg_M == rs_D || writereg_M == rt_D);

// 控制信号生成
assign stall_F = stall || branch_stall;
assign stall_D = stall || branch_stall;
assign flush_E = stall || branch_stall;
endmodule