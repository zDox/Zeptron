`include "defines.sv"


module hazard_unit (// Inputs from Execution Stage
                    input   logic                   e_b_taken, e_alu_srcb,
                    input   logic [`REG_ADDR_BUS]   e_rs1, e_rs2,
                    // Inputs from Data Memory Stage
                    input   logic                   m_reg_we,
                    input   logic [`REG_ADDR_BUS]   m_rd,
                    // Inputs from Writeback Stage
                    input   logic                   w_reg_we,
                    input   logic [`REG_ADDR_BUS]   w_rd,
                    // Outputs
                    output  logic                   forward_rrd1, forward_rrd2,

                    output  logic                   flush_if_id, flush_id_ex,
                    output  logic                   flush_ex_dm, flush_dm_wb,

                    output  logic                   stall_f, stall_if_id,
                    output  logic                   stall_id_ex, stall_ex_dm, stall_dm_wb);
    logic  stall;

    assign {stall_f, stall_if_id, stall_id_ex, stall_ex_dm } = {4{stall}};

    // Control Hazards
    assign flush_if_id = e_b_taken;
    assign flush_id_ex = e_b_taken;
    assign flush_ex_dm = 1'b0;
    assign flush_dm_wb = 1'b0;

    // Data Hazards
    assign stall = (e_rs1 == m_rd | (~e_alu_srcb & e_rs2 == m_rd)) & m_reg_we;
    assign stall_dm_wb = 1'b0;

    assign forward_rrd1 = (e_rs1 == w_rd) & w_reg_we;
    assign forward_rrd2 = (e_rs2 == w_rd) & w_reg_we;
endmodule
