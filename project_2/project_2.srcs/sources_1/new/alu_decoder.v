module alu_decoder(
    input  [5:0] funct,
    input  [1:0] aluop,
    output [2:0] alucontrol
);
    reg [2:0] alucontrol;
    always @(*) begin
        case(aluop)
            2'b00: alucontrol = 3'b000;  // �ӷ���LW/SW/ADDI��
            2'b01: alucontrol = 3'b001;  // ������BEQ��
            2'b11: begin                 // I-type�߼�/�Ƚ�ָ��
                case(funct)
                    6'b000000: alucontrol = 3'b010;  // ANDI����λ�룩
                    6'b000001: alucontrol = 3'b011;  // ORI����λ��
                    6'b001010: alucontrol = 3'b101;  // SLTI���з��űȽϣ�
                    default:   alucontrol = 3'b000;   // Ĭ��
                endcase
            end
            default: case(funct)        // R-typeָ��
                6'b100000: alucontrol = 3'b000; // ADD���޷��żӷ���
                6'b100001: alucontrol = 3'b000; // ADDU���޷��żӷ���
                6'b100010: alucontrol = 3'b001; // SUB��������
                6'b100011: alucontrol = 3'b001; // SUBU��������
                6'b100100: alucontrol = 3'b010; // AND����λ�룩
                6'b100101: alucontrol = 3'b011; // OR����λ��
                6'b101010: alucontrol = 3'b101; // SLT���з��űȽϣ�
                default:   alucontrol = 3'b000; // Ĭ��
            endcase
        endcase
    end
endmodule