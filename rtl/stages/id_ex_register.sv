module id_ex_register(  input   logic           clk, reset, enable,
                        input   logic [31:0]    d_instr, d_pc,
                        input   logic [16:0]    d_controls,
                        output  logic [31:0]    e_instr, e_pc,
                        output  logic [16:0]    e_controls);
    logic [80:0] d_bundle, e_bundle;

    assign d_bundle = {d_instr, d_pc, d_controls};

    always_ff @(posedge clk or posedge reset)
        if (reset) begin
            e_bundle <= 81'b0;
        end
        else if (enable) begin
            e_bundle <= d_bundle;
        end

    assign {e_instr, e_pc, e_controls} = e_bundle;
endmodule
