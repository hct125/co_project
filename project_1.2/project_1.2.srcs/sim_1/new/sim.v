`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/11 18:08:07
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


module tb_stallable_pipeline_adder();

    reg [7:0] num1;
    reg [7:0] num2;
    reg cin;
    reg clk;
    reg reset;
    reg stall;
    wire cout4;
    wire [7:0] sum_out;

    // ʵ��������ģ��
    stallable_pipeline_adder uut (
        .num1(num1),
        .num2(num2),
        .cin(cin),
        .clk(clk),
        .reset(reset),
        .stall(stall),
        .cout4(cout4),
        .sum_out(sum_out)
    );

    // ����10nsʱ������
    initial clk = 0;
    always #5 clk = ~clk;

    integer cycle_count = 0;

    // ���ڼ�����
    always @(posedge clk) begin
        if (reset)
            cycle_count <= 0;
        else
            cycle_count <= cycle_count + 1;
    end

initial begin
    // ��ʼ������
    num1 = 0;
    num2 = 0;
    cin = 0;
    reset = 1;
    stall = 0;

    // �ͷŸ�λ
    #20 reset = 0;

    // ��������1�������ӷ�����
    @(posedge clk);
    num1 <= 8'h12;
    num2 <= 8'h34;
    cin <= 0;

    // ��������2��ȫ�ӽ�λ����
    @(posedge clk);
    num1 <= 8'hFF;
    num2 <= 8'h01;
    cin <= 0;

    // �������벻ֵͬ�۲���ˮ��
    repeat(20) begin
        @(posedge clk);         
        num1 <= cycle_count;     // num1,num2���ڵ�ǰ������,sumÿ��+2'b10
        num2 <= cycle_count;
        cin <= 0;
    end

    $finish;
end

    // ������ˮ����ͣ��ˢ��
    initial begin
        #20; // �ȴ���λ���

        // ��10���ں���ͣ��ˮ��2����
        wait(cycle_count == 10);
        stall <= 1;
        repeat(2) @(posedge clk);
        stall <= 0;
        $display("��ˮ����ͣ");

        // ��15����ʱ��ˮ��ˢ��
        wait(cycle_count == 15);
        reset <= 1;
        @(posedge clk);
        reset <= 0;
        $display("��ˮ��ˢ��");
    end

    // ��عؼ��ź�
    initial begin
        $monitor("Cycle=%2d: sum=%b cout=%b (stall=%b, reset=%b)",
                 cycle_count, sum_out, cout4, stall, reset);
    end

endmodule
