`include "defines.sv"
`include "controlsgs.sv"

module execution_stage(// Inputs from General
                        input   logic                   clk, reset,
                        // Inputs from Hazard Unit
                        input   logic                   forward_rrd1, forward_rrd2,
                        // Inputs from ID
                        input   logic [`INSTR_BUS]      instr, pc,
                        input   controlsgs_t            controlsgs,
                        // Inputs from WB
                        input   logic                   regwe,
                        input   logic [`REG_ADDR_BUS]   regwa,
                        input   logic [`REG_BUS]        regwd,
                        // Outputs to Hazard Unit
                        output  logic [`REG_ADDR_BUS]   rs1, rs2,
                        // Outputs to IF
                        output  logic                   b_taken,
                        // Output to IF and DM
                        output  logic [`MEM_DATA_BUS]   alu_y,
                        // Outputs to DM
                        output  logic [`MEM_DATA_BUS]   rrd2,
                        output  logic [`REG_ADDR_BUS]   rd);
    logic [`REG_BUS]        rrd1, imm, rrd1_fwd, rrd2_fwd;
    logic [`REG_BUS]        srca, srcb;

    // Determine rs1, rs2 and rd
    assign rs1 = instr[19:15];
    assign rs2 = instr[24:20];
    assign rd  = instr[11:7];

    register_file       reg_file(   .clk(clk), .reset(reset),
                                    .ra1(rs1), .ra2(rs2),
                                    .wa3(regwa), .wd3(regwd), .we3(regwe),
                                    .rd1(rrd1), .rd2(rrd2));
    immediate_generator ig (        .instr(instr), .immg_op(controlsgs.immg_op),
                                    .imm(imm));


    // ALU
    assign rrd1_fwd = forward_rrd1 ? regwd : rrd1;
    assign rrd2_fwd = forward_rrd2 ? regwd : rrd2;

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
