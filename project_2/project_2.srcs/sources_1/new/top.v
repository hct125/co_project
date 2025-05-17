module top(
    input hclk,
    input rst,    
    output [6:0] seg,
    output [7:0] ans,
    output [9:0] led

);
    reg clk_1;    
    wire [7:0] pc;
    wire [31:0] inst;
    wire inst_ce;
    wire [2:0] alucontrol;
    wire memtoreg, memwrite, regwrite, alusrc, regdst, jump, branch;
    reg [26:0] count;
    always@(posedge hclk)
    begin
        if(count == 26'd49999999) begin
            count <= 0;
            clk_1 <= ~clk_1;
            end
        else
            count <= count+1;
    end
    pc pc_(clk_1, rst, pc, inst_ce);
    rom inst_rom (clk_1,inst_ce,pc[7:2],inst);
    controller ctrl(inst[31:26],inst[5:0],memtoreg, memwrite, regwrite, alusrc, regdst, jump, branch, alucontrol);

    assign led = {alucontrol, branch, jump, regwrite, regdst, alusrc, memwrite, memtoreg};
    display dis(hclk,rst,inst,seg,ans);


endmodule