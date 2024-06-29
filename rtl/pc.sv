module pc (     input   logic       clk, reset, enable,
                input   logic[31:0] a,
                output  logic[31:0] y);
    always @(posedge clk, posedge reset)
        if (reset)
            y <= 'h200;
        else if (enable)
            y <= a;
endmodule
