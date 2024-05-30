`include "defines.sv"


module imem(input   logic [`INSTR_ADDR_BUS]     a,
            output  logic [`INSTR_BUS]    rd);
    logic [`INSTR_BUS]    RAM[63];

    initial
        $readmemh("tests/imem.hex", RAM);

    assign rd =  RAM[a];
endmodule
