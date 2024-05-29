`include "defines.sv"
`include "controlsgs.sv"




module ex_dm_register(  input   logic                   clk, reset, enable,
                        input   logic [`REG_BUS]        e_alu_y, e_rrd2, e_pc_4,
                        input   logic [`REG_ADDR_BUS]   e_rd,
                        input   controlsgs_t            e_controlsgs,

                        output  logic [`REG_BUS]        m_alu_y, m_rrd2, m_pc_4,
                        output  logic [`REG_ADDR_BUS]   m_rd,
                        output  controlsgs_t            m_controlsgs);

    always_ff @(posedge clk or posedge reset)
        if (reset)
            { m_alu_y, m_rrd2, m_pc_4, m_rd, m_controlsgs} <= '0;
        else if (enable)
            { m_alu_y, m_rrd2, m_pc_4, m_rd, m_controlsgs} <= {
                e_alu_y, e_rrd2,e_pc_4,e_rd, e_controlsgs};
endmodule
