
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
    wire [5:0] rs,rt,rd;
    wire offset;
    assign offset=instr[15:0];
    assign rs = instr[25:21];
    assign rt = instr[20:16];
    assign rd = instr[15:11];
    
    regfile regfile(
        .clk(clk),
        .we3(regwrite),
        .ra1(rs),
        .ra2(rt),
        .wa3(rt),
        .wd3(readdata),
        .rd1(srcA),
        .rd2(writedata)
    );
    
    wire [15:0] extend_offset;
    signext signext(
    .a(offset),
    .y(extend_offset)
    );
    
    mux2(
    .s(alusrc),
    .a(extend_offset),
    .b(writedata),
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
