`include "defines.sv"


module hazard_unit (
                    input   logic                       d_alu_srcb,
                    input   logic [`INSTR_BUS]          d_instr,
                    // Inputs from Execution Stage
                    input   logic                       e_b_taken,
                    input   logic [`INSTR_BUS]          e_instr,
                    // Inputs from Data Memory Stage
                    input   logic [`INSTR_BUS]          m_instr,
                    input   logic                       m_reg_we,
                    input   logic [`DATAOUT_SRC_BUS]    m_dataout_src,
                    // Inputs from Writeback Stage
                    input   logic [`INSTR_BUS]          w_instr,
                    input   logic                       w_reg_we,
                    // Outputs
                    output  logic [`FORWARDSRC_BUS]     forward_rrd1, forward_rrd2,

                    output  logic                       flush_if_id, flush_id_ex,
                    output  logic                       flush_ex_dm, flush_dm_wb,

                    output  logic                       stall_f, stall_if_id,
                    output  logic                       stall_id_ex, stall_ex_dm, stall_dm_wb);
    logic  stall;

    assign {stall_f, stall_if_id } = {2{stall}};


    logic   [`REG_ADDR_BUS]     d_rs1, d_rs2, d_rd,
                                e_rs1, e_rs2, e_rd,
                                m_rs1, m_rs2, m_rd,
                                w_rs1, w_rs2, w_rd;

    // Determine rs1, rs2 and rd
    assign d_rs1 = d_instr[19:15];
    assign d_rs2 = d_instr[24:20];
    assign d_rd  = d_instr[11:7];
    assign e_rs1 = e_instr[19:15];
    assign e_rs2 = e_instr[24:20];
    assign e_rd  = e_instr[11:7];
    assign m_rs1 = m_instr[19:15];
    assign m_rs2 = m_instr[24:20];
    assign m_rd  = m_instr[11:7];
    assign w_rs1 = w_instr[19:15];
    assign w_rs2 = w_instr[24:20];
    assign w_rd  = w_instr[11:7];

    // Data Hazards
    // Stall in case of lw before a R-Type
    assign stall = (d_rs1 == m_rd || (~d_alu_srcb && (d_rs2 == m_rd)))
                    && (m_dataout_src[2] || m_dataout_src[1]) && m_reg_we;

    assign {stall_id_ex, stall_ex_dm, stall_dm_wb } = '0;

    // Control Hazards
    assign flush_if_id = e_b_taken;
    assign flush_id_ex = e_b_taken || stall;
    assign flush_ex_dm = 1'b0;
    assign flush_dm_wb = 1'b0;



    // forwarding
    always_comb begin
        // Forwarding in case of rrd1
        if (((e_rs1 != 0) && (w_rd == e_rs1)) && w_reg_we)
            forward_rrd1 =  `EXE_FORWARDSRC_RRD1_WB;
        else if ((e_rs1 != 0) && (m_rd==e_rs1) && m_reg_we)
            forward_rrd1 =  `EXE_FORWARDSRC_RRD1_DM;
        else
            forward_rrd1 =  `EXE_FORWARDSRC_RRD1_NO;

        // Forwarding in case of rrd2
        if ((e_rs2 != 0) && (w_rd==e_rs2) && w_reg_we)
            forward_rrd2 =  `EXE_FORWARDSRC_RRD2_WB;
        else if ((e_rs2 != 0) && (m_rd==e_rs2) && m_reg_we)
            forward_rrd2 =  `EXE_FORWARDSRC_RRD2_DM;
        else
            forward_rrd2 =  `EXE_FORWARDSRC_RRD2_NO;
    end

endmodule
