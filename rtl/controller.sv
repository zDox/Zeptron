`include "defines.sv"
`include "controlsgs.sv"

module controller (
    input   logic [6:0] op,
    input   logic [2:0] funct3,
    input   logic [6:0] funct7,
    output  controlsgs_t controlsgs
);

    always_comb
        case (op)
            `OP_LUI: controlsgs = {
                alu_op:             `EXE_ADD_OP,
                alu_srca:           `EXE_ALUSRCA_ZERO,
                alu_srcb:           `EXE_ALUSRCB_IMM,
                mem_d_wdsrc:        2'bxx,
                mem_d_we:           1'b0,
                dataout_src:        `EXE_DATAOUTSRC_ALUY,
                reg_we:             1'b1,
                immg_op:            `IMMG_OP_U,
                bj_op:              `EXE_BJOP_NOOP
            };

            `OP_AUIPC: controlsgs = {
                alu_op:             `EXE_ADD_OP,
                alu_srca:           `EXE_ALUSRCA_PC,
                alu_srcb:           `EXE_ALUSRCB_IMM,
                mem_d_wdsrc:        2'bxx,
                mem_d_we:           1'b0,
                dataout_src:        `EXE_DATAOUTSRC_ALUY,
                reg_we:             1'b1,
                immg_op:            `IMMG_OP_U,
                bj_op:              `EXE_BJOP_NOOP
            };

            `OP_JAL: controlsgs = {
                alu_op:             `EXE_ADD_OP,
                alu_srca:           `EXE_ALUSRCA_PC,
                alu_srcb:           `EXE_ALUSRCB_IMM,
                mem_d_wdsrc:        2'bxx,
                mem_d_we:           1'b0,
                dataout_src:        `EXE_DATAOUTSRC_PC4,
                reg_we:             1'b1,
                immg_op:            `IMMG_OP_J,
                bj_op:              `EXE_BJOP_JUMP
            };

            `OP_JALR: controlsgs = {
                alu_op:             `EXE_ADD_OP,
                alu_srca:           `EXE_ALUSRCA_RRD1,
                alu_srcb:           `EXE_ALUSRCB_IMM,
                mem_d_wdsrc:        2'bxx,
                mem_d_we:           1'b0,
                dataout_src:        `EXE_DATAOUTSRC_PC4,
                reg_we:             1'b1,
                immg_op:            `IMMG_OP_J,
                bj_op:              `EXE_BJOP_JUMP
            };

            `OP_BRANCH: begin
                controlsgs = {
                    alu_op:             `EXE_ADD_OP,
                    alu_srca:           `EXE_ALUSRCA_PC,
                    alu_srcb:           `EXE_ALUSRCB_IMM,
                    mem_d_wdsrc:        2'bxx,
                    mem_d_we:           1'b0,
                    dataout_src:        3'bxxx,
                    reg_we:             1'b0,
                    immg_op:            `IMMG_OP_B,
                    bj_op:              `EXE_BJOP_NOOP
                };

                case (funct3)
                    `FUNCT3_BEQ:    controlsgs.bj_op = `EXE_BJOP_BEQ;
                    `FUNCT3_BNE:    controlsgs.bj_op = `EXE_BJOP_BNE;
                    `FUNCT3_BLT:    controlsgs.bj_op = `EXE_BJOP_BLT;
                    `FUNCT3_BGE:    controlsgs.bj_op = `EXE_BJOP_BGE;
                    `FUNCT3_BLTU:   controlsgs.bj_op = `EXE_BJOP_BLTU;
                    `FUNCT3_BGEU:   controlsgs.bj_op = `EXE_BJOP_BGEU;
                    default:        controlsgs.bj_op = `EXE_BJOP_NOOP;
                endcase
            end

            `OP_LOAD: begin
                controlsgs = {
                    alu_op:             `EXE_ADD_OP,
                    alu_srca:           `EXE_ALUSRCA_RRD1,
                    alu_srcb:           `EXE_ALUSRCB_IMM,
                    mem_d_wdsrc:        2'bxx,
                    mem_d_we:           1'b0,
                    dataout_src:        3'bxxx,
                    reg_we:             1'b1,
                    immg_op:            `IMMG_OP_I,
                    bj_op:              `EXE_BJOP_NOOP
                };

                case (funct3)
                    `FUNCT3_LB:     controlsgs.dataout_src = `EXE_DATAOUTSRC_RDS8;
                    `FUNCT3_LH:     controlsgs.dataout_src = `EXE_DATAOUTSRC_RDS16;
                    `FUNCT3_LW:     controlsgs.dataout_src = `EXE_DATAOUTSRC_RD32;
                    `FUNCT3_LBU:    controlsgs.dataout_src = `EXE_DATAOUTSRC_RDZ8;
                    `FUNCT3_LHU:    controlsgs.dataout_src = `EXE_DATAOUTSRC_RDZ16;
                    default:        controlsgs.dataout_src = 3'bxxx;
                endcase
            end

            `OP_STORE: begin
                controlsgs = {
                    alu_op:             `EXE_ADD_OP,
                    alu_srca:           `EXE_ALUSRCA_RRD1,
                    alu_srcb:           `EXE_ALUSRCB_IMM,
                    mem_d_wdsrc:        2'bxx,
                    mem_d_we:           1'b1,
                    dataout_src:        3'bxxx,
                    reg_we:             1'b0,
                    immg_op:            `IMMG_OP_S,
                    bj_op:              `EXE_BJOP_NOOP
                };

                case (funct3)
                    `FUNCT3_SB:     controlsgs.mem_d_wdsrc = `EXE_MEMWDSRC_B;
                    `FUNCT3_SH:     controlsgs.mem_d_wdsrc = `EXE_MEMWDSRC_H;
                    `FUNCT3_SW:     controlsgs.mem_d_wdsrc = `EXE_MEMWDSRC_W;
                    default:        controlsgs.mem_d_wdsrc = 2'bxx;
                endcase
            end

            `OP_OP_IMM: begin
                controlsgs = {
                    alu_op:             `EXE_ADD_OP,
                    alu_srca:           `EXE_ALUSRCA_RRD1,
                    alu_srcb:           `EXE_ALUSRCB_IMM,
                    mem_d_wdsrc:        2'bxx,
                    mem_d_we:           1'b0,
                    dataout_src:        `EXE_DATAOUTSRC_ALUY,
                    reg_we:             1'b1,
                    immg_op:            `IMMG_OP_I,
                    bj_op:              `EXE_BJOP_NOOP
                };

                case (funct3)
                    `FUNCT3_ADDI:       controlsgs.alu_op = `EXE_ADD_OP;
                    `FUNCT3_SLTI:       controlsgs.alu_op = `EXE_SLT_OP;
                    `FUNCT3_SLTIU:      controlsgs.alu_op = `EXE_SLTU_OP;
                    `FUNCT3_XORI:       controlsgs.alu_op = `EXE_XOR_OP;
                    `FUNCT3_ORI:        controlsgs.alu_op = `EXE_OR_OP;
                    `FUNCT3_ANDI:       controlsgs.alu_op = `EXE_AND_OP;
                    `FUNCT3_SLLI:       controlsgs.alu_op = `EXE_SLL_OP;
                    `FUNCT3_SRLI_SRAI:  controlsgs.alu_op = (funct7 == `FUNCT7_SRLI) ? `EXE_SRL_OP :
                                                                                        `EXE_SRA_OP;
                    default:            controlsgs.alu_op = 4'bxxxx;
                endcase
            end

            `OP_R_TYPE: begin
                controlsgs = {
                    alu_op:             `EXE_ADD_OP,
                    alu_srca:           `EXE_ALUSRCA_RRD1,
                    alu_srcb:           `EXE_ALUSRCB_RRD2,
                    mem_d_wdsrc:        2'bxx,
                    mem_d_we:           1'b0,
                    dataout_src:        `EXE_DATAOUTSRC_ALUY,
                    reg_we:             1'b1,
                    immg_op:            `IMMG_OP_R,
                    bj_op:              `EXE_BJOP_NOOP
                };

                case (funct3)
                    `FUNCT3_ADD_SUB:    controlsgs.alu_op = (funct7 == `FUNCT7_ADD) ?   `EXE_ADD_OP:
                                                                                        `EXE_SUB_OP;
                    `FUNCT3_SLT:        controlsgs.alu_op = `EXE_SLT_OP;
                    `FUNCT3_SLTU:       controlsgs.alu_op = `EXE_SLTU_OP;
                    `FUNCT3_XOR:        controlsgs.alu_op = `EXE_XOR_OP;
                    `FUNCT3_OR:         controlsgs.alu_op = `EXE_OR_OP;
                    `FUNCT3_AND:        controlsgs.alu_op = `EXE_AND_OP;
                    `FUNCT3_SLL:        controlsgs.alu_op = `EXE_SLL_OP;
                    `FUNCT3_SRL_SRA:    controlsgs.alu_op = (funct7 == `FUNCT7_SRL) ?   `EXE_SRL_OP:
                                                                                        `EXE_SRA_OP;
                    default:            controlsgs.alu_op = 4'bxxxx;
                endcase
            end

            `OP_ILLEGAL_H, `OP_ILLEGAL_L : controlsgs = {
                alu_op:             1'bx,
                alu_srca:           `EXE_ALUSRCA_RRD1,
                alu_srcb:           `EXE_ALUSRCB_RRD2,
                mem_d_wdsrc:        2'bxx,
                mem_d_we:           1'b0,
                dataout_src:        `EXE_DATAOUTSRC_ALUY,
                reg_we:             1'b0,
                immg_op:            4'bxxxx,
                bj_op:              `EXE_BJOP_NOOP
            };
        endcase
endmodule
