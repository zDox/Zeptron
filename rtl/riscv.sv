`include "defines.sv"


module riscv (  input   logic                   clk, reset,
                input   logic [`INSTR_BUS]      mem_i_rd,
                input   logic [`MEM_DATA_BUS]   mem_d_rd,
                output  logic                   mem_d_we,
                output  logic [`MEM_BE_BUS]     mem_d_wdbe,
                output  logic [`MEM_ADDR_BUS]   mem_d_wa,
                output  logic [`MEM_DATA_BUS]   mem_d_wd,
                output  logic [`INSTR_ADDR_BUS] mem_i_ra);

    // Instruction Fetch Stage declerations
    logic [31:0]    f_instr, f_pc;

    // Instruction Decode Stage declerations
    logic [31:0]    d_instr, d_pc;
    controlsgs_if   d_controls();

    // Execute Stage declerations
    logic [31:0]    e_instr, e_pc;
    controlsgs_if   e_controls();
    logic [31:0]    e_alu_y, e_rdd2, e_pc_4;
    logic           e_b_taken;

    // Data Memory Stage declerations
    logic [31:0]    m_alu_y, m_rdd2, m_pc_4;
    controlsgs_if   m_controls();
    logic           m_rd;

    // Writeback Stage declerations
    controlsgs_if   w_controls();
    logic           w_regwrite;


    // Instruction Fetch Stage
    fetch_stage stage1(         // Inputs
                                .clk(clk), .reset(reset),
                                .e_b_taken(e_b_taken),
                                .e_alu_y(e_alu_y), .e_pc_4(e_pc_4),
                                // Interconnects to Instruction Memory
                                .mem_i_rd(mem_i_rd), .mem_i_ra(mem_i_ra),
                                // Outputs
                                .instr(f_instr), .pc(f_pc));

    if_id_register reg_stage1(  // Inputs
                                .clk(clk), .reset(reset),
                                .f_instr(f_instr), .f_pc(f_pc),
                                // Outputs
                                .d_instr(d_instr), .d_pc(d_pc));


    // Instruction Decode Stage
    decode_stage stage2(        .instr(d_instr), .controls(d_controls));
    id_ex_register reg_stage2(  // Inputs
                                .clk(clk), .reset(reset),
                                .d_instr(d_instr), .d_pc(d_pc),
                                .d_controls(d_controls),
                                // Outputs
                                .e_instr(e_instr), .e_pc(e_pc),
                                .e_controls(e_controls));


    // Execute Stage
    execute_stage stage3(       // Inputs from Stage Register IF/ID
                                .instr(e_instr), .pc(e_pc), .controls(e_controls),
                                // Inputs from Stage Register EX/WB
                                .regwe(w_regwe), .regwa(w_rd), .regwd(w_dataout),
                                // Outputs to Stage Register EX/DM
                                .rdd2(e_rdd2), .rd(e_rd),
                                // Outputs to Stage IF
                                .pc_4(e_pc_4), .b_taken(e_b_taken),
                                // Outputs to IF and DM
                                .alu_y(e_alu_y));

    ex_dm_register reg_stage3(  // Inputs
                                .clk(clk), .reset(reset),
                                .e_alu_y(e_alu_y), .e_rrd2(e_rdd2), .e_pc_4(e_pc_4),
                                .e_rd(e_rd),
                                // Outputs
                                .m_alu_y(m_alu_y), .m_rdd2(m_rdd2), .m_pc_4(m_pc_4),
                                .m_rd(m_rd));


    // Data Memory Stage
    datamemory_stage stage4(    // Inputs
                                .controls(m_controls), .alu_y(m_alu_y),
                                .rdd2(m_rdd2), .pc_4(m_pc_4),
                                // Interconnects to Data Memory
                                .mem_rd(mem_d_rd), .mem_we(mem_d_we), .mem_wa(mem_d_wa),
                                .mem_wd(mem_d_wd), .mem_d_wdbe(mem_d_wdbe),
                                // Output
                                .dataout(m_dataout));
    dm_wb_register reg_stage4(  // Inputs
                                .m_controls(m_controls),
                                .m_dataout(m_dataout),
                                .m_rd(m_rd),
                                // Outputs
                                .w_controls(w_controls),
                                .w_dataout(w_dataout),
                                .w_rd(w_rd));

    writeback_stage stage5(     .w_controls(w_controls),
                                .w_regwrite(w_regwrite));
endmodule
