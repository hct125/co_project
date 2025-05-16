module alu_decoder(
    input  [5:0] funct,
    input  [1:0] aluop,
    output [2:0] alucontrol
);
    reg [2:0] alucontrol;
    always @(*) begin
        case(aluop)
            2'b00: alucontrol = 3'b010;  // 加法（LW/SW/ADDI）
            2'b01: alucontrol = 3'b110;  // 减法（BEQ）
            2'b10: case(funct)        // R-type指令
                6'b100000: alucontrol = 3'b010; // ADD（无符号加法）
                6'b100010: alucontrol = 3'b110; // SUB（减法）
                6'b100100: alucontrol = 3'b000; // AND（按位与）
                6'b100101: alucontrol = 3'b001; // OR（按位或）
                6'b101010: alucontrol = 3'b111; // SLT（有符号比较）
                default:   alucontrol = 3'b011; // 默认
            endcase
            default: alucontrol = 3'b011;
        endcase
    end
endmodule