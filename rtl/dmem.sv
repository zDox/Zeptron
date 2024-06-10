`include "defines.sv"


module dmem(input   logic           clk, we,
            input   logic [`MEM_WMASK_BUS]     wmask,
            input   logic [`MEM_ADDR_BUS]    a,
            input   logic [`MEM_DATA_BUS]    wd,
            output  logic [`MEM_DATA_BUS]    rd);
    logic [31:0] RAM [2**16];

    assign rd = RAM[a[31:2]]; // word aligned

    always_ff @(posedge clk)
        if (we) RAM[a[31:2]] <= wd;
endmodule
