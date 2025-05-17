module hazard(
    input [4:0] rs_E,rt_E,rs_D,rt_D,writereg_M,writereg_W,writereg_E,//mem�׶Σ�д�Ĵ����ļĴ�����
    input regwrite_W,regwrite_M,memtoreg_E,memtoreg_M,regwrite_E,branch_D, //writeback�׶�
    output [1:0] forward_AE,forward_BE,
    output forward_AD,forward_BD,
    output stallF,stallD,flushE
    );

assign forward_AE = (rs_E != 5'b0) ? 
                  ((rs_E == writereg_M && regwrite_M) ? 2'b10 :  // MEMǰ��
                   (rs_E == writereg_W && regwrite_W) ? 2'b01 :  // WBǰ��
                   2'b00) : 
                  2'b00;

assign forward_BE = (rt_E != 5'b0) ? 
                  ((rt_E == writereg_M && regwrite_M) ? 2'b10 :  // MEMǰ��
                   (rt_E == writereg_W && regwrite_W) ? 2'b01 :  // WBǰ��
                   2'b00) : 
                  2'b00;

wire stall = ((rs_D == writereg_E) || (rt_D == writereg_E)) && memtoreg_E;

// �����ź�����
assign stallF = stall;
assign stallD = stall;
assign flushE = stall;
endmodule