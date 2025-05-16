
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/16 22:30:07
// Design Name: 
// Module Name: datepath
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
//clk,rst,memtoreg,pcsrc,alusrc,regdst,regwrite,jump,
//alucontrol,overflow,zero,pc,instr,aluout,writedata,readdata
//////////////////////////////////////////////////////////////////////////////////


module datepath(
	input wire clk,rst,
	output memtoreg, pcsrc, alusrc, regdst, regwrite, jump,
	output [2:0] alucontrol,
	output overflow,zero,
    output wire[31:0] pc,
    input wire[31:0] instr,
    output wire[31:0] aluout,writedata,
    input wire[31:0] readdata
    );
    
    wire [31:0] srcA,srcB;
    regfile regfile(
        .clk(clk),
        .we3(we3),
        .ra1(instr[25:21]),
        .ra2(ra2),
        .wa3(instr[20:13]),
        .wd3(readdata),
        .rd1(srcA),
        .rd2(rd2)
    );
    
    wire [15:0] extend_offset;
    signext signext(
    .a(instr[15:0]),
    .y(extend_offset)
    );
    
    mux2(
    .s(alusrc),
    .a(extend_offset),
    .b(rd2),
    .y(srcB)
    );
    
    alu alu(
    .num1(srcA),
    .num2(srcB),
    .op(alucontrol),
    .result(aluout)
    );
    
    pc pc_plus(
    .clk(clk),
    .rst(rst),
    .pc(pc)
    );
    
    
    
endmodule
