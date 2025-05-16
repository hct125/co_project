
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


module datapath(
	input wire clk,rst,
	output memtoreg, pcsrc, alusrc, regdst, regwrite, jump,branch,
	output [2:0] alucontrol,
	output overflow,zero,
    output wire[31:0] pc,
    input wire[31:0] instr,
    output wire[31:0] aluout,writedata,
    input wire[31:0] readdata
    );
    
    wire [31:0] srcA,srcB,wd3_result;
    wire [5:0] rs,rt,rd,write_reg;
    wire [15:0] offset;
    assign offset=instr[15:0];
    assign rs = instr[25:21];
    assign rt = instr[20:16];
    assign rd = instr[15:11];
        
    mux2 regdst_(
    .s(regdst),
    .a(rd),
    .b(rt),
    .y(write_reg)
    );
    
    regfile regfile(
        .clk(clk),
        .we3(regwrite),
        .ra1(rs),
        .ra2(rt),
        .wa3(write_reg),
        .wd3(wd3_result),
        .rd1(srcA),
        .rd2(writedata)
    );
    
    wire [31:0] extend_offset,pc_branch;
    signext signext(
    .a(offset),
    .y(extend_offset)
    );
    
    mux2 alusrc_(
    .s(alusrc),
    .a(extend_offset),
    .b(writedata),
    .y(srcB)
    );
    
    alu alu(
    .num1(srcA),
    .num2(srcB),
    .op(alucontrol),
    .result(aluout),
    .zero(zero)
    );
    
    assign pcsrc = zero && branch;
    
    mux2 memtoreg_(
    .s(memtoreg),
    .a(readdata),
    .b(aluout),
    .y(wd3_result)
    );
    
    pc pc_plus(
    .clk(clk),
    .rst(rst),
    .pc(pc)
    );
    
    sl2 sl2(
    .a(extend_offset),
    .y(pc_branch)
    );
    
    adder pc_branch_add(
    .a(pc),
    .b(pc_branch),
    .y(pc_branch)
    );
    
    mux2 pcsrc_(
    .s(pcsrc),
    .a(pc_branch),
    .b(pc),
    .y(pc)
    );
    
    
    
endmodule
