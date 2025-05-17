`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/17 13:19:39
// Design Name: 
// Module Name: flopenr
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


module flopenr #(parameter WIDTH = 32)
                (input clk,
                 input rst,
                 input en,
                 input [WIDTH-1:0] d,
                 output reg [WIDTH-1:0] q);
    
always @(posedge clk, posedge rst) begin
    if (rst) begin
        q <= 0;
    end else if (en) begin
        q <= d;
    end
end
    
endmodule
