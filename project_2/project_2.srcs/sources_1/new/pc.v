
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
    output reg [7:0] pc,
    output reg inst_ce
    );
    
    wire [7:0] pc_next;
    pc_adder pc_adder(
        .pc(pc),
        .pc_add(8'h4),
        .pc_next(pc_next));
    
    always@(posedge clk ,posedge rst) 
    begin
        if (rst) begin
            pc <= -4;
            inst_ce <= 0;
        end
        else begin 
            pc <= pc_next;
            inst_ce <= 1;
        end
    end
    
endmodule
