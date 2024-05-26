`include "defines.sv"

module controller ( input   logic [31:0]    instr,
                    controlsgs_if           controls);

    logic [6:0] op;
    assign op = instr[6:0];

    always_comb
        case (op)
            `OP_LUI: begin
                controls.alu_op =       1'bx;
                controls.alu_srca =     `EXE_ALUSRCA_ZERO;
                controls.alu_srcb =     `EXE_ALUSRCB_IMM;
                controls.mem_d_wdsrc =  2'bxx;
                controls.mem_d_we =     1'b0;
                controls.dataout_src =  `EXE_DATAOUTSRC_ALUY;
                controls.regwe =        1'b1;
                controls.branch =       1'b0;
                controls.jalr =         1'b0;
                controls.jump =         1'b0;
            end

            `OP_AUIPC: begin
                controls.alu_op =       1'bx;
                controls.alu_srca =     `EXE_ALUSRCA_PC;
                controls.alu_srcb =     `EXE_ALUSRCB_IMM;
                controls.mem_d_wdsrc =  2'bxx;
                controls.mem_d_we =     1'b0;
                controls.dataout_src =  `EXE_DATAOUTSRC_ALUY;
                controls.regwe =        1'b1;
                controls.branch =       1'b0;
                controls.jalr =         1'b0;
                controls.jump =         1'b0;
            end

            `OP_JAL: begin
                controls.alu_op =       1'bx;
                controls.alu_srca =     2'bxx;
                controls.alu_srcb =     2'bxx;
                controls.mem_d_wdsrc =  2'bxx;
                controls.mem_d_we =     1'b0;
                controls.dataout_src =  `EXE_DATAOUTSRC_PC4;
                controls.regwe =        1'b1;
                controls.branch =       1'b0;
                controls.jalr =         1'b0;
                controls.jump =         1'b1;
            end

            `OP_JALR: begin
                controls.alu_op =       1'bx;
                controls.alu_srca =     2'bxx;
                controls.alu_srcb =     2'bxx;
                controls.mem_d_wdsrc =  2'bxx;
                controls.mem_d_we =     1'b0;
                controls.dataout_src =  `EXE_DATAOUTSRC_PC4;
                controls.regwe =        1'b1;
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
                controls.regwe =        1'b0;
                controls.branch =       1'b1;
                controls.jalr =         1'b0;
                controls.jump =         1'b0;

                controls.alu_op =       1'bx;
            end

            `OP_LOAD: begin
                controls.alu_op =       1'bx;
                controls.alu_srca =     `EXE_ALUSRCA_RRD1;
                controls.alu_srcb =     `EXE_ALUSRCB_IMM;
                controls.mem_d_wdsrc =  2'bxx;
                controls.mem_d_we =     1'b0;
                controls.regwe =        1'b1;
                controls.branch =       1'b0;
                controls.jalr =         1'b0;
                controls.jump =         1'b0;

                controls.dataout_src =  3'bxxx;
            end

            `OP_STORE: begin
                controls.alu_op =       1'bx;
                controls.alu_srca =     `EXE_ALUSRCA_RRD1;
                controls.alu_srcb =     `EXE_ALUSRCB_IMM;
                controls.mem_d_we =     1'b1;
                controls.dataout_src =  3'bxxx;
                controls.regwe =        1'b0;
                controls.branch =       1'b0;
                controls.jalr =         1'b0;
                controls.jump =         1'b0;

                controls.mem_d_wdsrc =  2'bxx;
            end
            `OP_OP_IMM: begin
                controls.alu_srca =     `EXE_ALUSRCA_RRD1;
                controls.alu_srcb =     `EXE_ALUSRCB_IMM;
                controls.mem_d_wdsrc =  2'bxx;
                controls.mem_d_we =     1'b0;
                controls.dataout_src =  `EXE_DATAOUTSRC_ALUY;
                controls.regwe =        1'b1;
                controls.branch =       1'b0;
                controls.jalr =         1'b0;
                controls.jump =         1'b0;

                controls.alu_op =       1'bx;
            end
            `OP_R_TYPE: begin
                controls.alu_srca =     `EXE_ALUSRCA_RRD1;
                controls.alu_srcb =     `EXE_ALUSRCB_RRD2;
                controls.mem_d_wdsrc =  2'bxx;
                controls.mem_d_we =     1'b0;
                controls.dataout_src =  `EXE_DATAOUTSRC_ALUY;
                controls.regwe =        1'b1;
                controls.branch =       1'b0;
                controls.jalr =         1'b0;
                controls.jump =         1'b0;

                controls.alu_op =       1'bx;
            end

            `OP_ILLEGAL_H: begin // illegal
                controls.alu_op =       1'bx;
                controls.alu_srca =     `EXE_ALUSRCA_RRD1;
                controls.alu_srcb =     `EXE_ALUSRCB_RRD2;
                controls.mem_d_wdsrc =  2'bxx;
                controls.mem_d_we =     1'b0;
                controls.dataout_src =  `EXE_DATAOUTSRC_ALUY;
                controls.regwe =        1'b0;
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
                controls.regwe =        1'b0;
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
                controls.regwe =        1'b0;
                controls.branch =       1'b0;
                controls.jalr =         1'b0;
                controls.jump =         1'b0;
            end
        endcase
endmodule
