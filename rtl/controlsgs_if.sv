interface controlsgs_if;
    logic   alu_op;
    logic [2:0] dataout_src;
    logic [1:0] alu_srca, mem_d_wdsrc;
    logic       alu_srcb, mem_d_we, reg_we;
    logic       branch, jalr, jump;
endinterface
