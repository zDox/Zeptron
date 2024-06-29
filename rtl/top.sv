`include "defines.sv"


interface mem_d_bus_if();
    logic [`MEM_DATA_BUS]   mem_wd, mem_rd;
    logic [`MEM_ADDR_BUS]   mem_a;
    logic [`MEM_WMASK_BUS]  mem_wmask;
    logic                   mem_we;
endinterface;

module top #(parameter mem_content_path) (input logic clk, reset);

    logic [`MEM_DATA_BUS]   instr;
    logic [`MEM_ADDR_BUS]   pc;

    // RiscV
    mem_d_bus_if    rv_bus();
    mem_d_bus_if    mem_bus();
    mem_d_bus_if    tu_bus();

    riscv riscv(.clk(clk), .reset(reset),
                .mem_i_rd(instr),
                .mem_d_rd(rv_bus.mem_rd),
                .mem_d_we(rv_bus.mem_we),
                .mem_d_wmask(rv_bus.mem_wmask),
                .mem_d_a(rv_bus.mem_a),
                .mem_d_wd(rv_bus.mem_wd),
                .mem_i_ra(pc));

    dual_port_mem # (mem_content_path) dual_mem(
                .clk(clk),
                // Data Memory
                .we2(mem_bus.mem_we),
                .w2mask(mem_bus.mem_wmask),
                .a2(mem_bus.mem_a),
                .wd2(mem_bus.mem_wd),
                .rd2(mem_bus.mem_rd),
                // Instruciton Memory
                .a1(pc),
                .rd1(instr)
    );

    test_utils  test_utils( .clk(clk), .reset(reset),
                            .we(tu_bus.mem_we), .wmask(tu_bus.mem_wmask),
                            .a(tu_bus.mem_a), .wd(tu_bus.mem_wd), .rd(tu_bus.mem_rd));


    // Memory Address Switcher
    always_comb
        if (rv_bus.mem_a < 'h112 && rv_bus.mem_a >= 'h100) begin
            tu_bus.mem_wd = rv_bus.mem_wd;
            tu_bus.mem_a = rv_bus.mem_a;
            tu_bus.mem_wmask = rv_bus.mem_wmask;
            tu_bus.mem_we = rv_bus.mem_we;
            rv_bus.mem_rd = tu_bus.mem_rd;
        end
        else begin
            mem_bus.mem_wd = rv_bus.mem_wd;
            mem_bus.mem_a = rv_bus.mem_a;
            mem_bus.mem_wmask = rv_bus.mem_wmask;
            mem_bus.mem_we = rv_bus.mem_we;
            rv_bus.mem_rd = mem_bus.mem_rd;
        end
endmodule
