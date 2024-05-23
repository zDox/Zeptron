module riscv (  input   logic       clk, reset,
                input   logic[31:0] finstr,
                input   logic[31:0] memreaddata,
                output  logic       m_memwe,
                output  logic[31:0] memwriteaddress, memwritedata,
                output  logic[31:0] fpc);


    fetch_stage stage1( e_b_taken(e_b_taken), e_pc_imm(e_pc_imm), 
                        e_pc_4(e_pc_4));
    if_id_register reg_stage1();

    decode_stage stage2();
    id_ex_register reg_stage2();

    execute_stage stage3();
    ex_dm_register reg_stage3();

    datamemory_stage stage4();
    dm_wb_register reg_stage4();

    writeback_stage stage5();
endmodule
