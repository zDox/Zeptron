`include "defines.sv"
`include "controlsgs.sv"


module riscv (  input   logic                       clk, reset,
                input   logic [`INSTR_BUS]          mem_i_rd,
                input   logic [`MEM_DATA_BUS]       mem_d_rd,
                output  logic                       mem_d_we,
                output  logic [`MEM_WMASK_BUS]      mem_d_wmask,
                output  logic [`MEM_ADDR_BUS]       mem_d_a,
                output  logic [`MEM_DATA_BUS]       mem_d_wd,
                output  logic [`INSTR_ADDR_BUS]     mem_i_ra);

    // Instruction Fetch Stage declerations
    logic [`INSTR_BUS]      f_instr, f_pc, f_pc4;

    // Instruction Decode Stage declerations
    logic [`INSTR_BUS]      d_instr, d_pc, d_pc4;
    controlsgs_t            d_controlsgs;

    // Execute Stage declerations
    logic [`INSTR_BUS]      e_instr, e_pc;
    controlsgs_t            e_controlsgs;
    logic [`INSTR_BUS]      e_alu_y, e_rrd2, e_pc4;
    logic                   e_b_taken;
    logic [`REG_ADDR_BUS]   e_rd, e_rs1, e_rs2;

    // Data Memory Stage declerations
    logic [31:0]            m_alu_y, m_dataout, m_rrd2, m_pc4;
    controlsgs_t            m_controlsgs;
    logic [`REG_ADDR_BUS]   m_rd;

    // Writeback Stage declerations
    controlsgs_t            w_controlsgs;
    logic                   w_regwe;
    logic [31:0]            w_dataout;
    logic [`REG_ADDR_BUS]   w_rd;

    // Hazard declerations
    logic                   forward_rrd1, forward_rrd2;
    logic                   flush_if_id, flush_id_ex, flush_ex_dm, flush_dm_wb;
    logic                   stall_f, stall_if_id, stall_id_ex, stall_ex_dm, stall_dm_wb;

    hazard_unit hz (    // From EX
                        .e_b_taken(e_b_taken), .e_alu_srcb(e_controlsgs.alu_srcb),
                        .e_rs1(e_rs1), .e_rs2(e_rs2),
                        // From DM
                        .m_reg_we(m_controlsgs.reg_we),
                        .m_rd(m_rd),
                        // From WB
                        .w_reg_we(w_controlsgs.reg_we),
                        .w_rd(w_rd),
                        // Outputs
                        .forward_rrd1(forward_rrd1), .forward_rrd2(forward_rrd2),
                        .flush_if_id(flush_if_id), . flush_id_ex(flush_id_ex),
                        .flush_ex_dm(flush_ex_dm), . flush_dm_wb(flush_dm_wb),
                        .stall_f(stall_f), .stall_if_id(stall_if_id), .stall_id_ex(stall_id_ex),
                        .stall_ex_dm(stall_ex_dm), .stall_dm_wb(stall_dm_wb));


    // Instruction Fetch Stage
    fetch_stage stage1(         // Inputs
                                .clk(clk), .reset(reset),
                                .e_b_taken(e_b_taken),
                                .e_alu_y(e_alu_y),
                                // Interconnects to Instruction Memory
                                .mem_i_rd(mem_i_rd), .mem_i_ra(mem_i_ra),
                                // Outputs
                                .instr(f_instr), .pc(f_pc), .pc4(f_pc4));

    if_id_register reg_stage1(  // Inputs
                                .clk(clk), .reset(reset),
                                .clear(flush_if_id), .enable(~stall_if_id),
                                .f_instr(f_instr), .f_pc(f_pc), .f_pc4(f_pc4),
                                // Outputs
                                .d_instr(d_instr), .d_pc(d_pc), .d_pc4(d_pc4));


    // Instruction Decode Stage
    decode_stage stage2(        .instr(d_instr), .controlsgs(d_controlsgs));
    id_ex_register reg_stage2(  // Inputs
                                .clk(clk), .reset(reset),
                                .clear(flush_id_ex), .enable(~stall_id_ex),
                                .d_instr(d_instr), .d_pc(d_pc), .d_pc4(d_pc4),
                                .d_controlsgs(d_controlsgs),
                                // Outputs
                                .e_instr(e_instr), .e_pc(e_pc), .e_pc4(e_pc4),
                                .e_controlsgs(e_controlsgs));


    // Execute Stage
    execution_stage stage3(     .clk(clk), .reset(reset),
                                // Inputs from Hazard Unit
                                .forward_rrd1(forward_rrd1), .forward_rrd2(forward_rrd2),
                                // Inputs from Stage Register IF/ID
                                .instr(e_instr), .pc(e_pc), .controlsgs(e_controlsgs),
                                // Inputs from Stage Register EX/WB
                                .regwe(w_regwe), .regwa(w_rd), .regwd(w_dataout),
                                // Outputs to Hazard funit
                                .rs1(e_rs1), .rs2(e_rs2),
                                // Outputs to Stage IF
                                .b_taken(e_b_taken),
                                // Outputs to IF and DM
                                .alu_y(e_alu_y),
                                // Outputs to Stage Register EX/DM
                                .rrd2(e_rrd2), .rd(e_rd));

    ex_dm_register reg_stage3(  // Inputs
                                .clk(clk), .reset(reset),
                                .clear(flush_ex_dm), .enable(~stall_ex_dm),
                                .e_controlsgs(e_controlsgs),
                                .e_alu_y(e_alu_y), .e_rrd2(e_rrd2), .e_pc4(e_pc4),
                                .e_rd(e_rd),
                                // Outputs
                                .m_controlsgs(m_controlsgs),
                                .m_alu_y(m_alu_y), .m_rrd2(m_rrd2), .m_pc4(m_pc4),
                                .m_rd(m_rd));


    // Data Memory Stage
    datamemory_stage stage4(    // Inputs
                                .controlsgs(m_controlsgs), .alu_y(m_alu_y),
                                .rrd2(m_rrd2), .pc4(m_pc4),
                                // Interconnects to Data Memory
                                .mem_rd(mem_d_rd), .mem_we(mem_d_we), .mem_a(mem_d_a),
                                .mem_wd(mem_d_wd), .mem_wmask(mem_d_wmask),
                                // Output
                                .dataout(m_dataout));

    dm_wb_register reg_stage4(  .clk(clk), .reset(reset),
                                .clear(flush_dm_wb), .enable(~stall_dm_wb),
                                // Inputs
                                .m_controlsgs(m_controlsgs),
                                .m_dataout(m_dataout),
                                .m_rd(m_rd),
                                // Outputs
                                .w_controlsgs(w_controlsgs),
                                .w_dataout(w_dataout),
                                .w_rd(w_rd));

    writeback_stage stage5(     .controlsgs(w_controlsgs),
                                .regwe(w_regwe));
endmodule
