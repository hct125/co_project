module controller(
    input [31:0] inst,
    output memtoreg,
    output memwrite,
    output pcsrc,
    output alusrc,
    output regdst,
    output regwrite,
    output jump,
    output branch,
    output [2:0] alucontrol
    );
    
    wire[1:0] aluop;
    main_decoder main_decoder(inst[31:26],aluop,memtoreg,,memwrite,pcsrc,alusrc,regwrite,jump,branch);
    alu_decoder alu_decoder(inst[5:0],aluop,alucontrol);
    
endmodule