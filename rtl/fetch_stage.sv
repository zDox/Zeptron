module fetch_stage(     input   logic           clk, reset,
                        input   logic           e_b_taken,
                        input   logic[31:0]     e_pc_imm, e_pc_4, mem_i_rd,
                        output  logic[31:0]     mem_i_ra, f_instr);
    logic[31:0]     nextpc;

    // Mux to switch nextpc between pc + imm and pc+4
    assign nextpc = e_b_taken ? e_pc_imm : e_pc_4;

    pc   pc(    .clk(clk), .reset(reset),
                .a(nextpc), .y(mem_i_ra));
    assign f_instr = mem_i_rd;
endmodule
