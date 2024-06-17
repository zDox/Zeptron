`include "defines.sv"


module imem(input   logic [`INSTR_ADDR_BUS]     a,
            output  logic [`INSTR_BUS]    rd);
    logic [`INSTR_BUS]    RAM[2**10];

    initial
        $readmemh("tests/my.hex", RAM);

    assign rd =  RAM[a>>2];
endmodule
