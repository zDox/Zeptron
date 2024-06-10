`include "controlsgs.sv"


module decode_stage(    // Inputs from General
                        input   logic                   clk, reset,
                        // Inputs from IF
                        input   logic [31:0]            instr,
                        // Inputs from WB
                        input   logic                   regwe,
                        input   logic [`REG_ADDR_BUS]   regwa,
                        input   logic [`REG_BUS]        regwd,
                        // Ouputs to EX
                        output  logic [`REG_BUS]        rrd1, rrd2,
                        output  logic [`REG_BUS]        imm,
                        output  controlsgs_t            controlsgs);
    logic   [`REG_ADDR_BUS]     rs1, rs2, rd;

    // Determine rs1, rs2 and rd
    assign rs1 = instr[19:15];
    assign rs2 = instr[24:20];
    assign rd  = instr[11:7];

    controller controller(  .op(instr[6:0]),
                            .funct3(instr[14:12]),
                            .funct7(instr[31:25]),
                            .controlsgs(controlsgs));

    register_file       reg_file(   .clk(clk), .reset(reset),
                                    .ra1(rs1), .ra2(rs2),
                                    .wa3(regwa), .wd3(regwd), .we3(regwe),
                                    .rd1(rrd1), .rd2(rrd2));

    immediate_generator ig (        .instr(instr), .immg_op(controlsgs.immg_op),
                                    .imm(imm));
endmodule

