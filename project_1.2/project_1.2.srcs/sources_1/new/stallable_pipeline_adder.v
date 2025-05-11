`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/11 17:07:44
// Design Name: 
// Module Name: stallable_pipeline_adder
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


module stallable_pipeline_adder(
    input [7:0] num1,
    input [7:0] num2,
    input cin,
    input clk,
    input reset,    // 流水线刷新
    input stall,    // 流水线暂停
    output reg cout4, // 最终进位
    output reg [7:0] sum_out
);

    reg [1:0] stage1_sum;
    reg stage1_valid;
    reg [3:0] stage2_sum;
    reg stage2_valid;
    reg [5:0] stage3_sum;
    reg stage3_valid;
    reg [7:0] stage4_sum;
    reg stage4_valid;

    // 进位信号
    reg cout1, cout2, cout3;

    // Stage 1: 处理低2位 [1:0]
    always @(posedge clk) begin
        if (reset) begin
            stage1_valid <= 1'b0;
            stage1_sum <= 2'b0;
        end else if (!stall) begin
            stage1_valid <= 1'b1;
            {cout1, stage1_sum} <= {1'b0, num1[1:0]} + {1'b0, num2[1:0]} + cin;
        end
    end

    // Stage 2: 处理[3:2]位
    always @(posedge clk) begin
        if (reset) begin
            stage2_valid <= 1'b0;
            stage2_sum <= 4'b0;
        end else if (!stall) begin
            stage2_valid <= stage1_valid;
            if (stage1_valid) begin
                {cout2, stage2_sum[3:2]} <= {1'b0, num1[3:2]} + {1'b0, num2[3:2]} + cout1;
                stage2_sum[1:0] <= stage1_sum;
            end
        end
    end

    // Stage 3: 处理[5:4]位（带刷新）
    always @(posedge clk) begin
        if (reset) begin
            stage3_valid <= 1'b0;
            stage3_sum <= 6'b0;
        end else if (!stall) begin
            stage3_valid <= stage2_valid;
            if (stage2_valid) begin
                {cout3, stage3_sum[5:4]} <= {1'b0, num1[5:4]} + {1'b0, num2[5:4]} + cout2;
                stage3_sum[3:0] <= stage2_sum;
            end
        end
    end

    // Stage 4: 处理[7:6]位并输出
    always @(posedge clk) begin
        if (reset) begin
            stage4_valid <= 1'b0;
            sum_out <= 8'b0;
            cout4 <= 1'b0;
        end else if (!stall) begin
            stage4_valid <= stage3_valid;
            if (stage3_valid) begin
                {cout4, sum_out[7:6]} <= {1'b0, num1[7:6]} + {1'b0, num2[7:6]} + cout3;
                sum_out[5:0] <= stage3_sum;
            end
        end
    end

endmodule
