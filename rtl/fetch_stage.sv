module fetch_stage(     // Stage Inputs
                        input   logic           clk, reset,
                        input   logic           e_b_taken,
                        input   logic[31:0]     e_pc_imm, e_pc_4,
                        // Instruction Memory Interconnects
                        input   logic[31:0]     mem_i_rd,
                        output  logic[31:0]     mem_i_ra,
                        // Stage Outputs
                        output  logic [31:0]    instr, pc);
    logic[31:0]     nextpc;

    // Mux to switch nextpc between pc + imm and pc+4
    assign nextpc = e_b_taken ? e_pc_imm : e_pc_4;

    pc   pc_reg(    .clk(clk), .reset(reset), .enable(1),
                    .a(nextpc), .y(mem_i_ra));
    assign instr = mem_i_rd;
    assign pc =     mem_i_ra;
endmodule
