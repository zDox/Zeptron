`include "defines.sv"
`include "controlsgs.sv"


module ex_dm_register(  input   logic                   clk, reset, clear, enable,
                        input   logic [`REG_BUS]        e_alu_y, e_rrd2, e_pc4,
                        input   logic [`INSTR_BUS]      e_instr,
                        input   controlsgs_t            e_controlsgs,

                        output  logic [`REG_BUS]        m_alu_y, m_rrd2, m_pc4,
                        output  logic [`INSTR_BUS]      m_instr,
                        output  controlsgs_t            m_controlsgs);

    typedef struct packed {
        logic   [`REG_BUS]      alu_y, rrd2, pc4;
        logic   [`INSTR_BUS]    instr;
        controlsgs_t            controlsgs;
    } bundle_t;

    bundle_t    m_bundle;

    always_ff @(posedge clk or posedge reset)
        if (reset)
            m_bundle <= '0;
        else if (clear)
            m_bundle <= '0;
        else if (enable)
            m_bundle <= { e_alu_y, e_rrd2, e_pc4, e_instr, e_controlsgs};
    assign { m_alu_y, m_rrd2, m_pc4, m_instr, m_controlsgs} = m_bundle;
endmodule
