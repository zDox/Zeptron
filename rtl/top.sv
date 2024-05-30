`include "defines.sv"


module top(input logic clk, reset);
    logic [`MEM_DATA_BUS]   instr, mem_d_wd, mem_d_rd;
    logic [`MEM_ADDR_BUS]   mem_d_a, pc;
    logic [`MEM_WMASK_BUS]  mem_d_wmask;
    logic                   mem_d_we;

    riscv riscv(.clk(clk), .reset(reset),
                .mem_i_rd(instr),
                .mem_d_rd(mem_d_rd),
                .mem_d_we(mem_d_we),
                .mem_d_wmask(mem_d_wmask),
                .mem_d_a(mem_d_a),
                .mem_d_wd(mem_d_wd),
                .mem_i_ra(pc));

    imem imem(  .a(pc), .rd(instr));
    dmem dmem(  .clk(clk),
                .a(mem_d_a),
                .wmask(mem_d_wmask),
                .we(mem_d_we),
                .wd(mem_d_wd), .rd(mem_d_rd));
endmodule
