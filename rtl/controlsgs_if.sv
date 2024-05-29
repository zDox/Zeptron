`include "defines.sv"


interface controlsgs_if;
    // ALU Control
    logic [`ALU_OP_BUS]         alu_op;
    logic [`ALU_SRCA_SEL]       alu_srca;
    logic                       alu_srcb;
    logic [`IMMG_OP_BUS]        immg_op;
    // Data Memory Control
    logic [`MEM_D_WDSRC_BUS]    mem_d_wdsrc;
    logic                       mem_d_we;
    logic [`DATAOUT_SRC_BUS]    dataout_src;
    // Register File Control
    logic                       reg_we;
    // Control Flow Control
    logic [`BJ_OP_BUS]          bj_op; // branch and jump operator

    task static set_default();
    begin
        alu_op       = '0;
        alu_srca     = '0;
        alu_srcb     = 0;
        immg_op      = '0;
        mem_d_wdsrc  = '0;
        mem_d_we     = 0;
        dataout_src  = '0;
        reg_we       = 0;
        bj_op        = '0;
    end
    endtask
endinterface
