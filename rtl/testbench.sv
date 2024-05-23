module testbench();

    logic   clk, reset;

    logic [31:0]    writedata, dataadr;
    logic           memwrite;

    top dut(.clk(clk), .reset(reset), .writedata(writedata),
            .dataadr(dataadr), .memwrite(memwrite));

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
            if (memwrite) begin
            end
        end
endmodule
