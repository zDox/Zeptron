module if_id_register(  input   logic           clk, reset,
                        input   logic           flush, enable,
                        input   logic[31:0]     f_instr,
                        output  logic[31:0]     d_instr);
    always @(posedge reset)
        if  (reset)
            d_instr = 0;

    always @(posedge clk)
        if (flush)
            d_instr = 0;
        else if (enable)
            d_instr = f_instr;
endmodule

