`include "defines.sv"


module ex_dm_register(  input   logic                   clk, reset, enable,
                        input   logic [`REG_BUS]        e_alu_y, e_rrd2, e_pc_4,
                        input   logic [`REG_ADDR_BUS]   e_rd,
                        controlsgs_if                   e_controlsgs_io,

                        output  logic [`REG_BUS]        m_alu_y, m_rrd2, m_pc_4,
                        output  logic [`REG_ADDR_BUS]   m_rd,
                        controlsgs_if                   m_controlsgs_io);

    logic [100:0] e_bundle, m_bundle;

    assign e_bundle = {e_alu_y, e_rrd2, e_pc_4, e_rd, e_controlsgs_io};

    always_ff @(posedge clk or posedge reset)
        if (reset) begin
            m_alu_y       <= '0;
            m_rrd2        <= '0;
            m_pc_4        <= '0;
            m_rd          <= '0;
            m_controlsgs_io.set_default();
        end
        else if (enable) begin
            m_bundle <= e_bundle;
        end

    assign {m_alu_y, m_rrd2, m_pc_4, m_rd, m_controlsgs_io} = m_bundle;

endmodule
