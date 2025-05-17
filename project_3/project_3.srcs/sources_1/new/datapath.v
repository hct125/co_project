
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
    
    wire [31:0] pc_4,pc_b,pc_next,srcA,srcB,wd3_result,extend_offset,pc_branch,branch_offset,pc_jump,jump_offset;
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
    
    assign pcsrc = zero & branch;
    
    mux2 memtoreg_(
    .s(memtoreg),
    .a(readdata),
    .b(aluout),
    .y(wd3_result)
    );
    
    adder pc_plus(
    .a(pc),
    .b(32'h4),
    .y(pc_4)
    );
    
    sl2 pc_branch_sl2(
    .a(extend_offset),
    .y(branch_offset)
    );
    
    sl2 pc_jump_sl2(
    .a(instr),
    .y(jump_offset)
    );
    
    assign pc_jump = {pc_4[31:28],jump_offset[27:0]}; 
    
    adder pc_branch_add(
    .a(pc_4),
    .b(branch_offset),
    .y(pc_branch)
    );
    
    mux2 pcsrc_(
    .s(pcsrc),
    .a(pc_branch),
    .b(pc_4),
    .y(pc_b)
    );
    
    mux2 jump_(
    .s(jump),
    .a(pc_jump),
    .b(pc_b),
    .y(pc_next)
    );
    
    pc pc_(             //pc_next¸³Öµ¸øpc
    .clk(clk),
    .rst(rst),
    .pc_next(pc_next),
    .pc(pc)
    );
    
endmodule
