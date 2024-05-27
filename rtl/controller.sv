`include "defines.sv"

module controller ( input   logic [6:0]     op,
                    input   logic [2:0] funct3,
                    input   logic [6:0] funct7,
                    controlsgs_if           controls);


    always_comb
        case (op)
            `OP_LUI: begin
                controls.alu_op =       `EXE_ADD_OP;
                controls.alu_srca =     `EXE_ALUSRCA_ZERO;
                controls.alu_srcb =     `EXE_ALUSRCB_IMM;
                controls.mem_d_wdsrc =  2'bxx;
                controls.mem_d_we =     1'b0;
                controls.dataout_src =  `EXE_DATAOUTSRC_ALUY;
                controls.reg_we =        1'b1;
                controls.immg_op =      `IMMG_OP_U;
                controls.branch =       1'b0;
                controls.jalr =         1'b0;
                controls.jump =         1'b0;
            end

            `OP_AUIPC: begin
                controls.alu_op =       `EXE_ADD_OP;
                controls.alu_srca =     `EXE_ALUSRCA_PC;
                controls.alu_srcb =     `EXE_ALUSRCB_IMM;
                controls.mem_d_wdsrc =  2'bxx;
                controls.mem_d_we =     1'b0;
                controls.dataout_src =  `EXE_DATAOUTSRC_ALUY;
                controls.reg_we =        1'b1;
                controls.immg_op =      `IMMG_OP_U;
                controls.branch =       1'b0;
                controls.jalr =         1'b0;
                controls.jump =         1'b0;
            end

            `OP_JAL: begin
                controls.alu_op =       `EXE_ADD_OP;
                controls.alu_srca =     2'bxx;
                controls.alu_srcb =     2'bxx;
                controls.mem_d_wdsrc =  2'bxx;
                controls.mem_d_we =     1'b0;
                controls.dataout_src =  `EXE_DATAOUTSRC_PC4;
                controls.reg_we =        1'b1;
                controls.immg_op =      `IMMG_OP_J;
                controls.branch =       1'b0;
                controls.jalr =         1'b0;
                controls.jump =         1'b1;
            end

            `OP_JALR: begin
                controls.alu_op =       `EXE_ADD_OP;
                controls.alu_srca =     2'bxx;
                controls.alu_srcb =     2'bxx;
                controls.mem_d_wdsrc =  2'bxx;
                controls.mem_d_we =     1'b0;
                controls.dataout_src =  `EXE_DATAOUTSRC_PC4;
                controls.reg_we =        1'b1;
                controls.immg_op =      `IMMG_OP_J;
                controls.branch =       1'b0;
                controls.jalr =         1'b1;
                controls.jump =         1'b1;
            end

            `OP_BRANCH: begin
                controls.alu_srca =     `EXE_ALUSRCA_RRD1;
                controls.alu_srcb =     `EXE_ALUSRCB_RRD2;
                controls.mem_d_wdsrc =  2'bxx;
                controls.mem_d_we =     1'b0;
                controls.dataout_src =  3'bxxx;
                controls.reg_we =        1'b0;
                controls.immg_op =      `IMMG_OP_B;
                controls.branch =       1'b1;
                controls.jalr =         1'b0;
                controls.jump =         1'b0;

                case (funct3)
                    `FUNCT3_BEQ:    controls.alu_op =   `EXE_BEQ_OP;
                    `FUNCT3_BNE:    controls.alu_op =   `EXE_BNE_OP;
                    `FUNCT3_BLT:    controls.alu_op =   `EXE_BLT_OP;
                    `FUNCT3_BGE:    controls.alu_op =   `EXE_BGE_OP;
                    `FUNCT3_BLTU:   controls.alu_op =   `EXE_BLTU_OP;
                    `FUNCT3_BGEU:   controls.alu_op =   `EXE_BGEU_OP;
                    default :       controls.alu_op =   4'bxxxx;
                endcase
            end

            `OP_LOAD: begin
                controls.alu_op =       `EXE_ADD_OP;
                controls.alu_srca =     `EXE_ALUSRCA_RRD1;
                controls.alu_srcb =     `EXE_ALUSRCB_IMM;
                controls.mem_d_wdsrc =  2'bxx;
                controls.mem_d_we =     1'b0;
                controls.reg_we =        1'b1;
                controls.immg_op =      `IMMG_OP_I;
                controls.branch =       1'b0;
                controls.jalr =         1'b0;
                controls.jump =         1'b0;

                case (funct3)
                    `FUNCT3_LB:     controls.dataout_src =  `EXE_DATAOUTSRC_RDS8;
                    `FUNCT3_LH:     controls.dataout_src =  `EXE_DATAOUTSRC_RDS16;
                    `FUNCT3_LW:     controls.dataout_src =  `EXE_DATAOUTSRC_RD32;
                    `FUNCT3_LBU:    controls.dataout_src =  `EXE_DATAOUTSRC_RDZ8;
                    `FUNCT3_LHU:    controls.dataout_src =  `EXE_DATAOUTSRC_RDZ16;
                    default :       controls.dataout_src =   3'bxxx;
                endcase
            end

            `OP_STORE: begin
                controls.alu_op =       `EXE_ADD_OP;
                controls.alu_srca =     `EXE_ALUSRCA_RRD1;
                controls.alu_srcb =     `EXE_ALUSRCB_IMM;
                controls.mem_d_we =     1'b1;
                controls.dataout_src =  3'bxxx;
                controls.reg_we =        1'b0;
                controls.immg_op =      `IMMG_OP_S;
                controls.branch =       1'b0;
                controls.jalr =         1'b0;
                controls.jump =         1'b0;

                case (funct3)
                    `FUNCT3_SB:     controls.mem_d_wdsrc =  `EXE_MEMWDSRC_B;
                    `FUNCT3_SH:     controls.mem_d_wdsrc =  `EXE_MEMWDSRC_H;
                    `FUNCT3_SW:     controls.mem_d_wdsrc =  `EXE_MEMWDSRC_W;
                    default :       controls.mem_d_wdsrc =   2'bxx;
                endcase
            end
            `OP_OP_IMM: begin
                controls.alu_srca =     `EXE_ALUSRCA_RRD1;
                controls.alu_srcb =     `EXE_ALUSRCB_IMM;
                controls.mem_d_wdsrc =  2'bxx;
                controls.mem_d_we =     1'b0;
                controls.dataout_src =  `EXE_DATAOUTSRC_ALUY;
                controls.reg_we =        1'b1;
                controls.immg_op =      `IMMG_OP_I;
                controls.branch =       1'b0;
                controls.jalr =         1'b0;
                controls.jump =         1'b0;

                case (funct3)
                    `FUNCT3_ADDI:       controls.alu_op =   `EXE_ADD_OP;
                    `FUNCT3_SLTI:       controls.alu_op =   `EXE_SLT_OP;
                    `FUNCT3_SLTIU:      controls.alu_op =   `EXE_SLTU_OP;
                    `FUNCT3_XORI:       controls.alu_op =   `EXE_XOR_OP;
                    `FUNCT3_ORI:        controls.alu_op =   `EXE_OR_OP;
                    `FUNCT3_ANDI:       controls.alu_op =   `EXE_AND_OP;
                    `FUNCT3_SLLI:       controls.alu_op =   `EXE_SLL_OP;
                    `FUNCT3_SRLI_SRAI:  begin
                        if (funct7 == `FUNCT7_SRLI)
                            controls.alu_op = `EXE_SRL_OP;
                        else
                            controls.alu_op = `EXE_SRA_OP;
                    end
                    default:            controls.alu_op =   4'bxxxx;
                endcase
            end
            `OP_R_TYPE: begin
                controls.alu_srca =     `EXE_ALUSRCA_RRD1;
                controls.alu_srcb =     `EXE_ALUSRCB_RRD2;
                controls.mem_d_wdsrc =  2'bxx;
                controls.mem_d_we =     1'b0;
                controls.dataout_src =  `EXE_DATAOUTSRC_ALUY;
                controls.reg_we =        1'b1;
                controls.immg_op =      `IMMG_OP_R;
                controls.branch =       1'b0;
                controls.jalr =         1'b0;
                controls.jump =         1'b0;

                case (funct3)
                    `FUNCT3_ADD_SUB:    begin
                        if (funct7 == `FUNCT7_ADD)
                            controls.alu_op = `EXE_ADD_OP;
                        else
                            controls.alu_op = `EXE_SUB_OP;
                    end
                    `FUNCT3_SLT:        controls.alu_op =   `EXE_SLT_OP;
                    `FUNCT3_SLTU:       controls.alu_op =   `EXE_SLTU_OP;
                    `FUNCT3_XOR:        controls.alu_op =   `EXE_XOR_OP;
                    `FUNCT3_OR:         controls.alu_op =   `EXE_OR_OP;
                    `FUNCT3_AND:        controls.alu_op =   `EXE_AND_OP;
                    `FUNCT3_SLL:        controls.alu_op =   `EXE_SLL_OP;
                    `FUNCT3_SRL_SRA:  begin
                        if (funct7 == `FUNCT7_SRL)
                            controls.alu_op = `EXE_SRL_OP;
                        else
                            controls.alu_op = `EXE_SRA_OP;
                    end
                    default:            controls.alu_op =   4'bxxxx;
                endcase
            end

            `OP_ILLEGAL_H: begin // illegal
                controls.alu_op =       1'bx;
                controls.alu_srca =     `EXE_ALUSRCA_RRD1;
                controls.alu_srcb =     `EXE_ALUSRCB_RRD2;
                controls.mem_d_wdsrc =  2'bxx;
                controls.mem_d_we =     1'b0;
                controls.dataout_src =  `EXE_DATAOUTSRC_ALUY;
                controls.reg_we =        1'b0;
                controls.immg_op =      4'bxxxx;
                controls.branch =       1'b0;
                controls.jalr =         1'b0;
                controls.jump =         1'b0;
            end

            `OP_ILLEGAL_L: begin // illegal
                controls.alu_op =       1'bx;
                controls.alu_srca =     `EXE_ALUSRCA_RRD1;
                controls.alu_srcb =     `EXE_ALUSRCB_RRD2;
                controls.mem_d_wdsrc =  2'bxx;
                controls.mem_d_we =     1'b0;
                controls.dataout_src =  `EXE_DATAOUTSRC_ALUY;
                controls.reg_we =        1'b0;
                controls.immg_op =      4'bxxxx;
                controls.branch =       1'b0;
                controls.jalr =         1'b0;
                controls.jump =         1'b0;
            end

            default: begin // Not implimented
                controls.alu_op =       1'bx;
                controls.alu_srca =     `EXE_ALUSRCA_RRD1;
                controls.alu_srcb =     `EXE_ALUSRCB_RRD2;
                controls.mem_d_wdsrc =  2'bxx;
                controls.mem_d_we =     1'b0;
                controls.dataout_src =  `EXE_DATAOUTSRC_ALUY;
                controls.reg_we =        1'b0;
                controls.immg_op =      4'bxxxx;
                controls.branch =       1'b0;
                controls.jalr =         1'b0;
                controls.jump =         1'b0;
            end
        endcase
endmodule
