module decode_stage(    input   logic [31:0]    instr,
                        output  logic [16:0]    controls);
    logic [3:0]     d_alu_op;
    logic [2:0]     d_dataout_src;
    logic [1:0]     d_alu_srca, d_mem_d_wdsrc;
    logic           d_alu_srcb, d_mem_d_we, d_reg_we;
    logic           d_branch, d_jalr, d_jump;

    assign d_controls = {   d_alu_op, d_dataout_src, d_alu_srca, d_mem_d_wdsrc,
                            d_alu_srcb, d_mem_d_we, d_reg_we,
                            d_branch, d_jalr, d_jump };

    assign main_controls = {    d_dataout_src, d_alu_srca, d_mem_d_wdsrc,
                                d_alu_srcb, d_mem_d_we, d_reg_we,
                                d_branch, d_jalr, d_jump };

    main_controller main_controller(.instr(instr), .controls(main_controls));

    alu_controller  alu_controller(.funct3(instr[5:0]), .funct7(instr[5:0]),
                                    .alu_op(alu_op));
endmodule
