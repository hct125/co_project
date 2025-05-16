
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
    input wire [31:0] num1,num2,
    input wire [2:0] op,
    output reg [31:0] result
    );
    
    always @(*) begin
        case(op)
            3'b010:  result = num1 + num2;            // �޷��żӷ�
            3'b110:  result = num1 - num2;            // ����
            3'b000:  result = num1 & num2;            // ��λ��
            3'b001:  result = num1 | num2;            // ��λ��
            3'b111:  result = ($signed(num1) < $signed(num2)) ? 32'd1 : 32'd0; // �з���SLT
            default: result = 32'd0;            // δʹ�ò�����Ĭ�����0
        endcase
    end
endmodule
