`include "controlsgs.sv"


module id_ex_register(  input   logic           clk, reset, enable,
                        input   logic [31:0]    d_instr, d_pc, d_pc4,
                        input   controlsgs_t    d_controlsgs,
                        output  logic [31:0]    e_instr, e_pc, e_pc4,
                        output  controlsgs_t    e_controlsgs);
    typedef struct packed {
        logic   [`INSTR_BUS]    instr, pc, pc_4;
        controlsgs_t            controlsgs;
    } bundle_t;

    bundle_t    e_bundle;

    always_ff @(posedge clk or posedge reset)
        if (reset)
            e_bundle <= '0;
        else if (enable)
            e_bundle <= {d_instr, d_pc, d_pc4, d_controlsgs};

    assign {e_instr, e_pc, e_pc4, e_controlsgs} = e_bundle;
endmodule
