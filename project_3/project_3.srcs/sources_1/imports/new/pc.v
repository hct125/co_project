
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
    input pc_next,
    output reg [31:0] pc
    );
    
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
