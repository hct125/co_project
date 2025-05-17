module alu_decoder(
    input  [5:0] funct,
    input  [1:0] aluop,
    output [2:0] alucontrol
);
    reg [2:0] alucontrol;
    always @(*) begin
        case(aluop)
            2'b00: alucontrol = 3'b010;  // �ӷ���LW/SW/ADDI��
            2'b01: alucontrol = 3'b110;  // ������BEQ��
            2'b10: case(funct)        // R-typeָ��
                6'b100000: alucontrol = 3'b010; // ADD���޷��żӷ���
                6'b100010: alucontrol = 3'b110; // SUB��������
                6'b100100: alucontrol = 3'b000; // AND����λ�룩
                6'b100101: alucontrol = 3'b001; // OR����λ��
                6'b101010: alucontrol = 3'b111; // SLT���з��űȽϣ�
                default:   alucontrol = 3'b011; // Ĭ��
            endcase
            default: alucontrol = 3'b011;
        endcase
    end
endmodule