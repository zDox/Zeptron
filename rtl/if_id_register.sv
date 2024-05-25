module if_id_register(  input   logic           clk, reset,
                        input   logic           enable,
                        input   logic[31:0]     f_instr, f_pc,
                        output  logic[31:0]     d_instr, d_pc);
    logic [63:0] f_bundle, d_bundle;

    assign f_bundle = {f_instr, f_pc};

    always_ff @(posedge clk or posedge reset)
        if (reset) begin
            d_bundle <= 64'b0;
        end
        else if (enable) begin
            d_bundle <= f_bundle;
        end

    assign {d_instr, d_pc} = d_bundle;
endmodule
