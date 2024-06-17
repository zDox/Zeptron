`include "defines.sv"


module dmem(input   logic                   clk, we,
            input   logic [`MEM_WMASK_BUS]  wmask,
            input   logic [`MEM_ADDR_BUS]   a,
            input   logic [`MEM_DATA_BUS]   wd,
            output  logic [`MEM_DATA_BUS]   rd);
    logic [31:0] RAM [2**8];

    // asynchronous read from Memory
    assign rd = RAM[a[31:2]]; // word aligned

    always_ff @(posedge clk)
        if (we) begin
            if (wmask[0]) RAM[a[31:2]][7:0] <= wd[7:0];
            if (wmask[1]) RAM[a[31:2]][15:8] <= wd[15:8];
            if (wmask[2]) RAM[a[31:2]][23:16] <= wd[23:16];
            if (wmask[3]) RAM[a[31:2]][31:24] <= wd[31:24];
        end
endmodule
