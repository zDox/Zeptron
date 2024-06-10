`include "defines.sv"
`include "controlsgs.sv"

module execution_stage( // Inputs from Hazard Unit
                        input   logic                   forward_rrd1, forward_rrd2,
                        // Inputs from ID
                        input   logic [`INSTR_BUS]      instr, pc,
                        input   controlsgs_t            controlsgs,
                        input   logic [`REG_BUS]        rrd1, rrd2, imm,
                        // Inputs from WB
                        input   logic [`REG_BUS]        w_regwd, m_regwd,
                        // Outputs to IF
                        output  logic                   b_taken,
                        // Output to IF and DM
                        output  logic [`MEM_DATA_BUS]   alu_y,
                        // Outputs to DM
                        output  logic [`REG_ADDR_BUS]   rd);

    logic [`REG_BUS]        rrd1_fwd, rrd2_fwd;
    logic [`REG_BUS]        srca, srcb;




    // ALU
    assign rrd1_fwd = forward_rrd1 ? w_regwd : rrd1;
    assign rrd2_fwd = forward_rrd2 ? w_regwd : rrd2;

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
