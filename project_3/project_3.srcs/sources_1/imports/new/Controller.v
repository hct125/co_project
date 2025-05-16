module controller(
    input [5:0] op,
    input [5:0] funct,
    output zero,
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
    main_decoder main_decoder(op,aluop,memtoreg,,memwrite,pcsrc,alusrc,regwrite,jump,branch);
    alu_decoder alu_decoder(funct,aluop,alucontrol);
    
endmodule