module hazard(
    input [4:0] rs_E,rt_E,rs_D,rt_D,writereg_M,writereg_W,writereg_E,//mem�׶Σ�д�Ĵ����ļĴ�����
    input regwrite_W,regwrite_M,memtoreg_E,memtoreg_M,regwrite_E,branch_D, //writeback�׶�
    output [1:0] forward_AE,forward_BE,
    output forward_AD,forward_BD,
    output stall_F,stall_D,flush_E
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

assign forward_AD = ((rs_D != 0) && (rs_D == writereg_M) && regwrite_M);//writeregд�Ĵ����ļĴ�����
assign forward_BD = ((rt_D != 0) && (rt_D == writereg_M) && regwrite_M);//regwriteд�Ĵ���ʹ���ź�

wire branch_stall; //�����жϵ��Ƿ�Ϊ֮ǰָ��Ҫд�ļĴ������ǵĻ����������ַ��ǰ�ƽ����ж�
assign branch_stall = branch_D && regwrite_E && (writereg_E == rs_D || writereg_E == rt_D) || branch_D && memtoreg_M && (writereg_M == rs_D || writereg_M == rt_D);

// �����ź�����
assign stall_F = stall || branch_stall;
assign stall_D = stall || branch_stall;
assign flush_E = stall || branch_stall;
endmodule