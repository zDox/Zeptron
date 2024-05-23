module flopr  #(parameter int WIDTH=8)
               (input   logic               clk, reset,
                input   logic [WIDTH-1:0]   d,
                output  logic [WIDTH-1:0]   q);

    always_ff @(posedge clk, reset)
        q <= reset ? 0 : d;
endmodule
