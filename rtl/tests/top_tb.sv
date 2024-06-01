module top_tb();

    logic clk, reset;


    top dut(.clk(clk), .reset(reset));

    initial
        begin
            reset <= 1; #2 reset <= 0; #2;
    end

    //clock generation
    initial begin
        clk = 1'b0;
        forever #1 clk = ~clk;
    end

    // check results
    always @(negedge clk)
        begin
        end
endmodule
