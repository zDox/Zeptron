module top(input logic clk, reset);
    logic [31:0]    fpc, finstr, memwriteaddress, memwritedata,
                    memreaddata;
    logic           m_memwe;

    riscv riscv(.clk(clk), .reset(reset),
                .finstr(finstr),
                .memreaddata(memreaddata),
                .m_memwe(m_memwe),
                .memwriteaddress(memwriteaddress),
                .memwritedata(memwritedata),
                .fpc(fpc));

    imem imem(  .clk(clk), .a(fpc), .rd(finstr));
    dmem dmem(  .clk(clk), .we(m_memwe), .a(memwriteaddress[31:2]),
                .wd(memwritedata), .rd(memreaddata));
endmodule
