`include "defines.sv"


module if_id_register(  input   logic           clk, reset,
                        input   logic           enable,
                        input   logic[31:0]     f_instr, f_pc, f_pc4,
                        output  logic[31:0]     d_instr, d_pc, d_pc4);
    typedef struct packed {
        logic   [`INSTR_BUS]    instr, pc, pc_4;
    } bundle_t;

    bundle_t    d_bundle;

    always_ff @(posedge clk or posedge reset)
        if (reset)
            d_bundle <= '0;
        else if (enable)
            d_bundle <= { f_instr, f_pc, f_pc4};
    assign { d_instr, d_pc, d_pc4} = d_bundle;
endmodule
