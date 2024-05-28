`include "defines.sv"


module jump_control(    input   logic [`BJ_OP_BUS]   bj_op,
                        input   logic [`REG_BUS]     srca, srcb,
                        output  logic   b_taken);
    always_comb
        case (bj_op)
            `EXE_BJOP_NOOP:     b_taken = 1'b0;
            `EXE_BJOP_JUMP:     b_taken = 1'b1;
            `EXE_BJOP_BEQ:      b_taken = srca == srcb;
            `EXE_BJOP_BNE:      b_taken = srca != srcb;
            `EXE_BJOP_BLT:      b_taken = $signed(srca) < $signed(srcb);
            `EXE_BJOP_BGE:      b_taken = $signed(srca) >= $signed(srcb);
            `EXE_BJOP_BLTU:     b_taken = $unsigned(srca) < $unsigned(srcb);
            `EXE_BJOP_BGEU:     b_taken = $unsigned(srca) >= $unsigned(srcb);
            default:            b_taken = 1'bx;
        endcase
endmodule
