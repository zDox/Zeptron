`include "defines.sv"


// Instruction Memory is assigned to port 1
// Data Memory is assigned to port 2

module dual_port_mem(   input   logic                   clk, we2,
                        input   logic [`MEM_WMASK_BUS]  w2mask,
                        input   logic [`MEM_ADDR_BUS]   a2,
                        input   logic [`MEM_DATA_BUS]   wd2,
                        input   logic [`INSTR_ADDR_BUS] a1,
                        output  logic [`INSTR_BUS]      rd1,
                        output  logic [`MEM_DATA_BUS]   rd2);
    logic [31:0] RAM [2**8];

    // Init
    initial
        $readmemh("tests/my.hex", RAM);

    // asynchronous read from Memory
    assign rd2 = RAM[a2[31:2]]; // word aligned
    assign rd1 =  RAM[a1>>2];

    always_ff @(posedge clk)
        if (we2) begin
            if (w2mask[0]) RAM[a2[31:2]][7:0]   <= wd2[7:0];
            if (w2mask[1]) RAM[a2[31:2]][15:8]  <= wd2[15:8];
            if (w2mask[2]) RAM[a2[31:2]][23:16] <= wd2[23:16];
            if (w2mask[3]) RAM[a2[31:2]][31:24] <= wd2[31:24];
        end
endmodule
