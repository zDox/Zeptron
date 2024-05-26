module dmem(input   logic           clk, we,
            input   logic [1:0]     wdsrc,
            input   logic [31:0]    a, wd,
            output  logic [31:0]    rd);
    logic [31:0] RAM [63];

    assign rd = RAM[a[31:2]]; // word aligned

    always_ff @(posedge clk)
        if (we) RAM[a[31:2]] <= wd;
endmodule
