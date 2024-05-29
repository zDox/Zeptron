`include "defines.sv"
`include "controlsgs.sv"


module ex_dm_register(  input   logic                   clk, reset, enable,
                        input   logic [`REG_BUS]        e_alu_y, e_rrd2, e_pc_4,
                        input   logic [`REG_ADDR_BUS]   e_rd,
                        input   controlsgs_t            e_controlsgs,

                        output  logic [`REG_BUS]        m_alu_y, m_rrd2, m_pc_4,
                        output  logic [`REG_ADDR_BUS]   m_rd,
                        output  controlsgs_t            m_controlsgs);

    struct packed {
        logic   [`REG_BUS]      alu_y, rrd2, pc_4;
        logic   [`REG_ADDR_BUS] rd;
        controlsgs_t            controlsgs;
    } m_bundle;
    

    always_ff @(posedge clk or posedge reset)
        if (reset)
            m_bundle <= '0;
        else if (enable)
            m_bundle <= { e_alu_y, e_rrd2,e_pc_4,e_rd, e_controlsgs};
    assign { m_alu_y, m_rrd2,m_pc_4,m_rd, m_controlsgs} = m_bundle;
endmodule
