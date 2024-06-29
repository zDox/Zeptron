module top_tb #(parameter mem_content_path="tests/my.hex",
                parameter signature_path)();

    logic clk, reset;


    top #(mem_content_path) dut (.clk(clk), .reset(reset));

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
endmodule
