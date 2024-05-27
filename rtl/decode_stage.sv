module decode_stage(    input   logic [31:0]    instr,
                        controlsgs_if           controlsgs_io);
    controller controller(  .op(instr[6:0]),
                            .funct3(instr[14:12]),
                            .funct7(instr[31:25]),
                            .controls(controlsgs_io));
endmodule
