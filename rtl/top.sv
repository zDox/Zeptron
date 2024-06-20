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

    dual_port_mem dual_mem(
                .clk(clk),
                // Data Memory
                .we2(mem_d_we),
                .w2mask(mem_d_wmask),
                .a2(mem_d_a),
                .wd2(mem_d_wd),
                .rd2(mem_d_rd),
                // Instruciton Memory
                .a1(pc),
                .rd1(instr)
    );
endmodule
