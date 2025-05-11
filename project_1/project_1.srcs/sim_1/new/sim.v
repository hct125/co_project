
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/07 20:31:01
// Design Name: 
// Module Name: sim
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


`timescale 1ns / 1ps

module sim();
    // �����źŶ���
    reg clk;          // ʱ���ź�
    reg reset;        // ��λ�ź�
    reg [7:0] num1;   // ����num1�����Բ��뿪��sw0-sw7��
    reg [2:0] op;     // �����루����sw15-sw14��
    
    // ����źŶ���
    wire [7:0] ans;   // �����λѡ�ź�
    wire [6:0] seg;   // ����ܶ�ѡ�ź�

    // ʵ��������ģ��
    top u_top(
        .clk(clk),
        .reset(reset),
        .num1(num1),
        .op(op),
        .ans(ans),
        .seg(seg)
    );

    // ����10ns����ʱ��
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // ÿ5ns��ת������10ns
    end

    // ���ɸ�λ�ź�
    initial begin
        reset = 1;   // ��ʼ��λ��Ч
        #20;         // 20ns���ͷŸ�λ
        reset = 0;
    end

    // �������뼤��
    initial begin
        // ��ʼ������
        num1 = 8'h00;
        op = 3'b000;
        
        // �ȴ���λ���
        #30;

        // ------------- ��������1���޷��żӷ� (op=000) -------------
        num1 = 8'h01;  // B = 00000001 (��չ��Ϊ32'h00000001)
        op = 3'b000;   // A=32'h00000001, B=32'h00000001, ���ӦΪ32'h00000002
        #20;          // �ȴ�����ʱ������
        $display("Test1: op=000 (Add) | ans=%b, seg=%b | Expected: ans=11111110 (LSB digit), seg=0000010 (Hex 2)", ans, seg);

        // ------------- ��������2������ (op=001) -------------
        num1 = 8'h03;  // B=32'h00000003
        op = 3'b001;   // A=1 - B=3 �� 32'hFFFFFFFE (�����ʾ-2)
        #20;
        $display("Test2: op=001 (Sub) | ans=%b, seg=%b | Expected: ans=11111110 (LSB digit), seg=1111110 (Hex E)", ans, seg);

        // ------------- ��������3����λ�� (op=010) -------------
        num1 = 8'h0F;  // B=32'h0000000F
        op = 3'b010;   // A=1 & B=0xF �� 32'h00000001
        #20;
        $display("Test3: op=010 (AND) | ans=%b, seg=%b | Expected: ans=11111110, seg=1001111 (Hex 1)", ans, seg);

        // ------------- ��������4����λ�� (op=011) -------------
        num1 = 8'hF0;  // B=32'h000000F0
        op = 3'b011;   // A=1 | B=0xF0 �� 32'h000000F1
        #20;
        $display("Test4: op=011 (OR)  | ans=%b, seg=%b | Expected: ans=11111110, seg=0000100 (Hex 1)", ans, seg);

        // ------------- ��������5����λȡ�� (op=100) -------------
        op = 3'b100;   // ~A=32'hFFFFFFFE
        #20;
        $display("Test5: op=100 (NOT) | ans=%b, seg=%b | Expected: ans=11111110, seg=1111110 (Hex E)", ans, seg);

        // ------------- ��������6���з���SLT (op=101) -------------
        num1 = 8'hFF;  // B=32'h000000FF���з�����-1��
        op = 3'b101;   // A=1 < B=-1 �� 0
        #20;
        $display("Test6: op=101 (SLT) | ans=%b, seg=%b | Expected: ans=11111110, seg=0000001 (Hex 0)", ans, seg);

        // ��������
        #100 $finish;
    end

    // ���ɲ����ļ�������Vivado�鿴��
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, sim);
    end

endmodule