`include "controlsgs.sv"
`include "defines.sv"


module id_ex_register(  input   logic               clk, reset, clear, enable,
                        input   logic [`INSTR_BUS]  d_instr, d_pc, d_pc4,
                        input   logic [`REG_BUS]    d_rrd1, d_rrd2, d_imm,
                        input   controlsgs_t        d_controlsgs,
                        output  logic [`INSTR_BUS]  e_instr, e_pc, e_pc4,
                        output  logic [`REG_BUS]    e_rrd1, e_rrd2, e_imm,
                        output  controlsgs_t        e_controlsgs);
    typedef struct packed {
        logic   [`INSTR_BUS]    instr, pc, pc_4;
        logic   [`REG_BUS]      rrd1, rrd2, imm;
        controlsgs_t            controlsgs;
    } bundle_t;

    bundle_t    e_bundle;

    always_ff @(posedge clk or posedge reset)
        if (reset)
            e_bundle <= '0;
        else if (clear)
            e_bundle <= '0;
        else if (enable)
            e_bundle <= {d_instr, d_pc, d_pc4, d_controlsgs, d_rrd1, d_rrd2, d_imm};

    assign {e_instr, e_pc, e_pc4, e_controlsgs, e_rrd1, e_rrd2, e_imm} = e_bundle;
endmodule
