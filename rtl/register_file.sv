module register_file(input logic        clk, reset,
                     input logic        we3,
                     input logic[4:0]   ra1, ra2, wa3,
                     input logic[31:0]  wd3,
                     output logic[31:0] rd1, rd2);
    logic [31:0] rf [32];

    always_ff@(posedge clk)
        if (we3) rf[wa3] <= wd3;

    // Read operation
    always_comb begin
        if (ra1 == 0)
            rd1 = '0;
        else if (ra1 == wa3 && we3)
            rd1 = wd3;
        else
            rd1 = rf[ra1];

        if (ra2 == 0)
            rd2 = '0;
        else if (ra2 == wa3 && we3)
            rd2 = wd3;
        else
            rd2 = rf[ra2];
    end
endmodule
