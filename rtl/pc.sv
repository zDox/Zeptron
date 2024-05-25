module pc (     input   logic       clk, reset, enable,
                input   logic[31:0] a,
                output  logic[31:0] y);
    always @(posedge clk)
        if (enable)
            y <= a;
endmodule
