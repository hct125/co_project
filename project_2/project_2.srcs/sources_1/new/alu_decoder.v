module alu_decoder(
    input  [5:0] funct,
    input  [1:0] aluop,
    output [2:0] alucontrol
);
    reg [2:0] alucontrol;
    always @(*) begin
        case(aluop)
            2'b00: alucontrol = 3'b000;  // 加法（LW/SW/ADDI）
            2'b01: alucontrol = 3'b001;  // 减法（BEQ）
            2'b11: begin                 // I-type逻辑/比较指令
                case(funct)
                    6'b000000: alucontrol = 3'b010;  // ANDI（按位与）
                    6'b000001: alucontrol = 3'b011;  // ORI（按位或）
                    6'b001010: alucontrol = 3'b101;  // SLTI（有符号比较）
                    default:   alucontrol = 3'b000;   // 默认
                endcase
            end
            default: case(funct)        // R-type指令
                6'b100000: alucontrol = 3'b000; // ADD（无符号加法）
                6'b100001: alucontrol = 3'b000; // ADDU（无符号加法）
                6'b100010: alucontrol = 3'b001; // SUB（减法）
                6'b100011: alucontrol = 3'b001; // SUBU（减法）
                6'b100100: alucontrol = 3'b010; // AND（按位与）
                6'b100101: alucontrol = 3'b011; // OR（按位或）
                6'b101010: alucontrol = 3'b101; // SLT（有符号比较）
                default:   alucontrol = 3'b000; // 默认
            endcase
        endcase
    end
endmodule