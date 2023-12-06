module top_2 (
    input clk,
    input rst, 
    input [31:0] instr_in
);
    wire [31:0] pc,pc_4,pc_next,alu_result,dmem,wb,instr,RD1,RD2,alu_A,alu_B,imm_out;
    wire [3:0] alu_control;
    wire [1:0] WBsel,mem_write;
    wire [2:0] reg_write;
    wire  pc_sel,brUn,immSel,Asel,Bsel,eq,lt;
    pc pc_instance(
        .pc_next(pc_next),
        .clk(clk),
        .pc(pc),
        .rst(rst)
    );
    pc_adder pc_adder_4(
        .pc1(pc),
        .pc2(32'd4),
        .pc_out(pc_4)
    );
    instructionmem instructionmem_instance(
        .address(pc),
        .instr_in(instr_in),
        .RD(instr)
    );
    mux mux_pc(
        .a(pc_4),
        .b(alu_result),
        .s(pc_sel),
        .c(pc_next)
    );
    controler  controler_instance(
        .opcode(instr[6:0]),
        .funct3(instr[14:12]),
        .funct7(instr[30]),
        .eq(eq),
        .lt(lt),
        .pc_sel(pc_sel),
        .mem_write(mem_write),
        .brUn(brUn),
        .alu_control(alu_control),
        .immSel(immSel),
        .Asel(Asel),
        .Bsel(Bsel),
        .WBsel(WBsel),
        .reg_write(reg_write)
    );
    registerfile registerfile_instance(
        .clk(clk),
        .rst(rst),
        .A1(instr[19:15]),
        .A2(instr[24:20]),
        .A3(instr[11:7]),
        .WD3(wb),
        .WE3(reg_write),
        .RD1(RD1),
        .RD2(RD2)
    );
    branchComp branchComp_instance(
        .A(RD1),
        .B(RD2),
        .brUn(brUn),
        .eq(eq),
        .lt(lt)
    );
    immgen immgen_instance(
        .in(instr),
        .immSel(immSel),
        .imm_out(imm_out)
    );
    mux mux_pc_alu(
        .a(RD1),
        .b(pc),
        .s(Asel),
        .c(alu_A)
    );
    mux mux_imm_alu(
        .a(RD2),
        .b(imm_out),
        .s(Bsel),
        .c(alu_B)
    );
    alu  alu_instance(
        .A(alu_A),
        .B(alu_B),
        .alu_control(alu_control),
        .alu_result(alu_result)

    );
    data_mem data_mem_instance(
        .clk(clk),
        .rst(rst),
        .A(alu_result),
        .WD(RD2),
        .RWE(mem_write),
        .RD(dmem)
        // .sup_bit(load_control)
    );
    mux4 mux4_instance(
        .dmem(dmem),
        .alu(alu_result),
        .pc_4(pc_4),
        .WBsel(WBsel),
        .wb(wb)
    );
endmodule