`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/07 20:05:21
// Design Name: 
// Module Name: alu
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


module alu(
    input [7:0] num1,
    input [2:0] op,
    output reg [31:0] result
    );
    wire [31:0] num_ex={24'b0,num1};
    wire [31:0] num2=32'h01;
    
    always @(*) begin
        case(op)
            3'b000:  result = num_ex + num2;            // 无符号加法
            3'b001:  result = num_ex - num2;            // 减法
            3'b010:  result = num_ex & num2;            // 按位与
            3'b011:  result = num_ex | num2;            // 按位或
            3'b100:  result = ~num_ex;               // 按位取反num1
            3'b101:  result = ($signed(num_ex) < $signed(num2)) ? 32'd1 : 32'd0; // 有符号SLT
            default: result = 32'd0;            // 未使用操作码默认输出0
        endcase
    end
endmodule
