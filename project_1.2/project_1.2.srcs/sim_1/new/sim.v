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

    // 实例化被测模块
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

    // 生成10ns时钟周期
    initial clk = 0;
    always #5 clk = ~clk;

    integer cycle_count = 0;

    // 周期计数器
    always @(posedge clk) begin
        if (reset)
            cycle_count <= 0;
        else
            cycle_count <= cycle_count + 1;
    end

initial begin
    // 初始化输入
    num1 = 0;
    num2 = 0;
    cin = 0;
    reset = 1;
    stall = 0;

    // 释放复位
    #20 reset = 0;

    // 测试用例1：基本加法测试
    @(posedge clk);
    num1 <= 8'h12;
    num2 <= 8'h34;
    cin <= 0;

    // 测试用例2：全加进位测试
    @(posedge clk);
    num1 <= 8'hFF;
    num2 <= 8'h01;
    cin <= 0;

    // 持续输入不同值观察流水线
    repeat(20) begin
        @(posedge clk);         
        num1 <= cycle_count;     // num1,num2等于当前周期数,sum每周+2'b10
        num2 <= cycle_count;
        cin <= 0;
    end

    $finish;
end

    // 控制流水线暂停和刷新
    initial begin
        #20; // 等待复位完成

        // 第10周期后暂停流水线2周期
        wait(cycle_count == 10);
        stall <= 1;
        repeat(2) @(posedge clk);
        stall <= 0;
        $display("流水线暂停");

        // 第15周期时流水线刷新
        wait(cycle_count == 15);
        reset <= 1;
        @(posedge clk);
        reset <= 0;
        $display("流水线刷新");
    end

    // 监控关键信号
    initial begin
        $monitor("Cycle=%2d: sum=%b cout=%b (stall=%b, reset=%b)",
                 cycle_count, sum_out, cout4, stall, reset);
    end

endmodule
