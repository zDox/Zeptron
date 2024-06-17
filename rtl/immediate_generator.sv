`include "defines.sv"


module  immediate_generator(    input   logic[`INSTR_BUS]       instr,
                                input   logic[`IMMG_OP_BUS]      immg_op,
                                output  logic[`REG_BUS]         imm);
    always_comb
        case (immg_op)
            `IMMG_OP_I: imm = { {21{instr[31]}}, instr[30:25], instr[24:21], instr[20]};
            `IMMG_OP_S: imm = { {21{instr[31]}}, instr[30:25], instr[11:8], instr[7]};
            `IMMG_OP_B: imm = { {20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
            `IMMG_OP_U: imm = { instr[31], instr[30:20], instr[19:12], {12{1'b0}}};
            `IMMG_OP_J: imm = { {12{instr[31]}}, instr[19:12], instr[20], instr[30:25],
                                instr[24:21], 1'b0};
            default: imm = { 32{1'bx}};
        endcase
endmodule
