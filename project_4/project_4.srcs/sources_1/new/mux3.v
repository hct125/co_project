`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/17 14:38:04
// Design Name: 
// Module Name: mux3
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


module mux3 #(parameter WIDTH = 32)
             (input [1:0] s,
              input [WIDTH-1:0] a, b, c,
              output [WIDTH-1:0] y);
    
    assign y = (s == 2'b00) ? a : 
               (s == 2'b01) ? b :
               (s == 2'b10) ? c :
               {WIDTH{1'bx}};
endmodule
