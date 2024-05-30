`include "defines.sv"


module alu(input    logic [31:0]    a, b,
           input    logic [3:0]     op,
           output   logic [31:0]    y);
    always_comb
        case (op)
            `EXE_ADD_OP:    y = a + b;
            `EXE_SUB_OP:    y = a - b;
            `EXE_XOR_OP:    y = a ^ b;
            `EXE_OR_OP:     y = a | b;
            `EXE_AND_OP:    y = a & b;
            `EXE_SLL_OP:    y = a << b[24:20];
            `EXE_SRL_OP:    y = a >> b[24:20];
            `EXE_SRA_OP:    y = a >>> b[24:20];
            `EXE_SLT_OP:    y = $signed(a) < $signed(b);
            `EXE_SLTU_OP:   y = $unsigned(a) < $unsigned(b);
            default:        y = {32{1'bx}};
        endcase
endmodule
