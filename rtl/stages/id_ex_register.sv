`include "controlsgs.sv"


module id_ex_register(  input   logic           clk, reset, enable,
                        input   logic [31:0]    d_instr, d_pc, d_pc4,
                        input   controlsgs_t    d_controlsgs,
                        output  logic [31:0]    e_instr, e_pc, e_pc4,
                        output  controlsgs_t    e_controlsgs);
    logic [80:0] d_bundle, e_bundle;

    assign d_bundle = {d_instr, d_pc, d_pc4, d_controlsgs};

    always_ff @(posedge clk or posedge reset)
        if (reset) begin
            e_bundle <= 81'b0;
        end
        else if (enable) begin
            e_bundle <= d_bundle;
        end

    assign {e_instr, e_pc, e_pc4, e_controlsgs} = e_bundle;
endmodule
