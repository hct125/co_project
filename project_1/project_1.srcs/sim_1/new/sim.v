
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
    // 输入信号定义
    reg clk;          // 时钟信号
    reg reset;        // 复位信号
    reg [7:0] num1;   // 输入num1（来自拨码开关sw0-sw7）
    reg [2:0] op;     // 操作码（来自sw15-sw14）
    
    // 输出信号定义
    wire [7:0] ans;   // 数码管位选信号
    wire [6:0] seg;   // 数码管段选信号

    // 实例化顶层模块
    top u_top(
        .clk(clk),
        .reset(reset),
        .num1(num1),
        .op(op),
        .ans(ans),
        .seg(seg)
    );

    // 生成10ns周期时钟
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 每5ns翻转，周期10ns
    end

    // 生成复位信号
    initial begin
        reset = 1;   // 初始复位有效
        #20;         // 20ns后释放复位
        reset = 0;
    end

    // 生成输入激励
    initial begin
        // 初始化输入
        num1 = 8'h00;
        op = 3'b000;
        
        // 等待复位完成
        #30;

        // ------------- 测试用例1：无符号加法 (op=000) -------------
        num1 = 8'h01;  // B = 00000001 (扩展后为32'h00000001)
        op = 3'b000;   // A=32'h00000001, B=32'h00000001, 结果应为32'h00000002
        #20;          // 等待两个时钟周期
        $display("Test1: op=000 (Add) | ans=%b, seg=%b | Expected: ans=11111110 (LSB digit), seg=0000010 (Hex 2)", ans, seg);

        // ------------- 测试用例2：减法 (op=001) -------------
        num1 = 8'h03;  // B=32'h00000003
        op = 3'b001;   // A=1 - B=3 → 32'hFFFFFFFE (补码表示-2)
        #20;
        $display("Test2: op=001 (Sub) | ans=%b, seg=%b | Expected: ans=11111110 (LSB digit), seg=1111110 (Hex E)", ans, seg);

        // ------------- 测试用例3：按位与 (op=010) -------------
        num1 = 8'h0F;  // B=32'h0000000F
        op = 3'b010;   // A=1 & B=0xF → 32'h00000001
        #20;
        $display("Test3: op=010 (AND) | ans=%b, seg=%b | Expected: ans=11111110, seg=1001111 (Hex 1)", ans, seg);

        // ------------- 测试用例4：按位或 (op=011) -------------
        num1 = 8'hF0;  // B=32'h000000F0
        op = 3'b011;   // A=1 | B=0xF0 → 32'h000000F1
        #20;
        $display("Test4: op=011 (OR)  | ans=%b, seg=%b | Expected: ans=11111110, seg=0000100 (Hex 1)", ans, seg);

        // ------------- 测试用例5：按位取反 (op=100) -------------
        op = 3'b100;   // ~A=32'hFFFFFFFE
        #20;
        $display("Test5: op=100 (NOT) | ans=%b, seg=%b | Expected: ans=11111110, seg=1111110 (Hex E)", ans, seg);

        // ------------- 测试用例6：有符号SLT (op=101) -------------
        num1 = 8'hFF;  // B=32'h000000FF（有符号数-1）
        op = 3'b101;   // A=1 < B=-1 → 0
        #20;
        $display("Test6: op=101 (SLT) | ans=%b, seg=%b | Expected: ans=11111110, seg=0000001 (Hex 0)", ans, seg);

        // 结束仿真
        #100 $finish;
    end

    // 生成波形文件（用于Vivado查看）
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, sim);
    end

endmodule