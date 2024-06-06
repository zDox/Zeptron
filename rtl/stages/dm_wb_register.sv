`include "defines.sv"
`include "controlsgs.sv"


module dm_wb_register(  input   logic           clk, reset, clear, enable,
                        input   controlsgs_t    m_controlsgs,
                        input   [`REG_BUS]      m_dataout,
                        input   [`REG_ADDR_BUS] m_rd,

                        output  [`REG_BUS]      w_dataout,
                        output  [`REG_ADDR_BUS] w_rd,
                        output  controlsgs_t    w_controlsgs);
    typedef struct packed {
        logic   [`REG_BUS]      dataout;
        logic   [`REG_ADDR_BUS] rd;
        controlsgs_t            controlsgs;
    } bundle_t;

    bundle_t w_bundle;

    always_ff @(posedge clk or posedge reset)
        if (reset)
            w_bundle <= '0;
        else if (clear)
            w_bundle <= '0;
        else if (enable)
            w_bundle <= { m_dataout, m_rd, m_controlsgs};

    assign {w_dataout, w_rd, w_controlsgs} = w_bundle;
endmodule
