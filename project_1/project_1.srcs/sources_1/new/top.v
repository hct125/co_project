`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/07 20:05:21
// Design Name: 
// Module Name: top
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


module top(    
    input clk,
    input reset,
    input [7:0] num1,    
    input [2:0] op,    
    output [7:0] ans,
    output [6:0] seg
    );
    
    wire [31:0] result;
    
        // ALU实例化
    alu u_alu(
        .num1(num1),
        .op(op),
        .result(result)
    );

    // 显示模块实例化（已提供）
    display u_display(
        .clk(clk),
        .reset(reset),
        .s(result),
        .seg(seg),
        .ans(ans)
    );
    
endmodule
