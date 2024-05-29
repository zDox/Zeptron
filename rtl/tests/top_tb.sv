module top_tb();

    logic clk, reset;


    top dut(.clk(clk), .reset(reset));

    initial
        begin
            reset <= 5; #20 reset <= 0; #5;
    end

    // generate clock to sequence tests
    always
        begin
            clk <= 1; #5; clk <= 0; #5;
        end

    // check results
    always @(negedge clk)
        begin
        end
endmodule
