`include "defines".sv


module  immediate_generator(    input   logic[`INSTR_BUS]       instr,
                                input   logic[`IMMG_OP_BUS]      immg_op,
                                output  logic[`REG_BUS]         imm);
    always_comb
        case (immgop)
            `IMMG_OP_R:
            `IMMG_OP_I:
            `IMMG_OP_S:
            `IMMG_OP_B:
            `IMMG_OP_U:
            `IMMG_OP_J:
endmodule
