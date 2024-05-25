`include "defines.sv"

module main_controller (    input   logic [31:0]    instr,
                            controlsgs_if      controls);
    /*  Layout of controls[16:0] from top to bottom and from left to right
    *   alu_op[3:0] dataout_src[2:0] alu_srca[1:0] mem_d_wdsrc[1:0]
    *   alu_srcb, mem_d_we, d_reg_we;
    *   branch, jalr, jump;
    */

    logic [6:0] op;
    assign op = instr[6:0];

    always_comb
        case (op)
            `OP_LUI:
                controls.alu_op = 3'b000;
            `OP_AUIPC:
                controls = 5'b10100;
            `OP_JAL:
                controls = 5'b10100;
            `OP_JALR:
                controls = 5'b10100;
            `OP_BRANCH:
                controls = 5'b10100;
            `OP_LOAD:
                controls = 5'b10100;
            `OP_STORE:
                controls = 5'b10100;
            `OP_OP_IMM:
                controls = 5'b10100;
            `OP_R_TYPE:
                controls = 5'b10100;

            `OP_ILLEGAL_H: // illegal
                controls = {17{1'bx}};
            7'b0000000: // illegal
                controls = {17{1'bx}};
            default: // Not implimented
                controls = {17{1'bx}};
        endcase
endmodule
