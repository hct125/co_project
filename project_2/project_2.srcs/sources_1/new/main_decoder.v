module main_decoder(
    input  [5:0] op,
    output [1:0] aluop,
    output memtoreg, memwrite, pcsrc, alusrc, regdst, regwrite, jump, branch

);
    reg [10:0] controls;
    assign {memtoreg, memwrite, pcsrc, alusrc, regdst, regwrite, jump, branch, aluop} = controls;

    always @(*) begin
        case(op)
            6'b000000: controls = 11'b1_0_0_0_1_1_0_0_10; // R-type (aluop=2'b10)
            6'b100011: controls = 11'b0_1_0_1_0_1_0_0_00;  // LW (aluop=2'b00���ӷ�)
            6'b101011: controls = 11'b0_0_0_1_0_0_0_0_00;  // SW (aluop=2'b00���ӷ�)
            6'b000100: controls = 11'b0_0_1_0_0_0_0_1_01;  // BEQ (aluop=2'b01������)
            6'b001000: controls = 11'b0_0_0_1_0_1_0_0_00;  // ADDI (aluop=2'b00���ӷ�)
            6'b001100: controls = 11'b0_0_0_1_0_1_0_0_11;  // ANDI (aluop=2'b11����λ��)
            6'b001101: controls = 11'b0_0_0_1_0_1_0_0_11;  // ORI (aluop=2'b11����λ��)
            6'b001010: controls = 11'b0_0_0_1_0_1_0_0_11;  // SLTI (aluop=2'b11��SLT)
            6'b000010: controls = 11'b0_0_0_0_0_0_1_0_00;  // J (aluop�޹�)
            default:   controls = 11'b0_0_0_0_0_0_0_0_00;  // Ĭ��
        endcase
    end
endmodule