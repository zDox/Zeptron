interface controlsgs_if;
    // ALU Control
    logic [3:0] alu_op;
    logic [1:0] alu_srca;
    logic       alu_srcb;
    logic [2:0] immg_op;
    // Data Memory Control
    logic [1:0] mem_d_wdsrc;
    logic       mem_d_we;
    logic [2:0] dataout_src;
    // Register File Control
    logic       reg_we;
    // Control Flow Control
    logic       branch, jalr, jump;
endinterface
