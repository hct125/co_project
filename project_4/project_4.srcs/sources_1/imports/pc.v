
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/14 20:03:29
// Design Name: 
// Module Name: pc
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


module pc(
    input clk,
    input rst,
    output reg [31:0] pc
    );
    
    wire [31:0] pc_next;
    adder pc_adder(
        .a(pc),
        .b(32'h4),
        .y(pc_next));
    
    always@(posedge clk ,posedge rst) 
    begin
        if (rst) begin
            pc <= -4;
        end
        else begin 
            pc <= pc_next;
        end
    end
    
endmodule
