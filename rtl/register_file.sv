module register_file(input logic        clk,
                     input logic        we3,
                     input logic[4:0]   ra1, ra2, wa3,
                     input logic[31:0]  wd3,
                     output logic[31:0] rd1, rd2);
    logic [31:0] rf [31];

    always_ff@(posedge clk)
        if (we3) rf[wa3] <= wd3;

    // Read operation
    assign rd1 = (ra1 == 0) ? 32'b0 : rf[ra1];
    assign rd2 = (ra2 == 0) ? 32'b0 : rf[ra2];
endmodule
