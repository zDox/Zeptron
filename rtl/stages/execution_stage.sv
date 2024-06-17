`include "defines.sv"
`include "controlsgs.sv"

module execution_stage( // Inputs from Hazard Unit
                        input   logic [`FORWARDSRC_BUS] forward_rrd1, forward_rrd2,
                        // Inputs from ID
                        input   logic [`INSTR_BUS]      pc,
                        input   controlsgs_t            controlsgs,
                        input   logic [`REG_BUS]        rrd1, rrd2, imm,
                        // Inputs from WB
                        input   logic [`REG_BUS]        m_regwd, w_regwd,
                        // Outputs to IF
                        output  logic                   b_taken,
                        // Output to IF and DM
                        output  logic [`REG_BUS]        rrd1_fwd, rrd2_fwd,
                        output  logic [`MEM_DATA_BUS]   alu_y);

    logic [`REG_BUS]        srca, srcb;



    // Forwarding Mux
    always_comb begin
        case (forward_rrd1)
            `EXE_FORWARDSRC_RRD1_NO:    rrd1_fwd = rrd1;
            `EXE_FORWARDSRC_RRD1_DM:    rrd1_fwd = m_regwd;
            `EXE_FORWARDSRC_RRD1_WB:    rrd1_fwd = w_regwd;
            default:                    rrd1_fwd = rrd1;
        endcase

        case (forward_rrd2)
            `EXE_FORWARDSRC_RRD2_NO:    rrd2_fwd = rrd2;
            `EXE_FORWARDSRC_RRD2_DM:    rrd2_fwd = m_regwd;
            `EXE_FORWARDSRC_RRD2_WB:    rrd2_fwd = w_regwd;
            default:                    rrd2_fwd = rrd2;
        endcase
    end


    // ALU


    mux4                mux_srca(   .d0(rrd1_fwd), .d1({32{1'b0}}), .d2(pc),
                                    .s(controlsgs.alu_srca),
                                    .y(srca));
    mux2                mux_srcb(   .d0(rrd2_fwd), .d1(imm),
                                    .s(controlsgs.alu_srcb),
                                    .y(srcb));
    alu                 alu(        .a(srca), .b(srcb), .op(controlsgs.alu_op),
                                    .y(alu_y));

    jump_control        jc(         .bj_op(controlsgs.bj_op),
                                    .srca(srca), .srcb(srcb),
                                    .b_taken(b_taken));

endmodule
