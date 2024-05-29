`include "controlsgs.sv"


module ex_dm_register_tb;

    logic clk, reset, enable;
    logic [31:0] e_alu_y, m_alu_y;
    controlsgs_t   e_controls;
    controlsgs_t   m_controls;

    ex_dm_register dut( .clk(clk), .reset(reset), .enable(enable),
                        .e_alu_y(e_alu_y), .e_controlsgs(e_controls),
                        .m_alu_y(m_alu_y), .m_controlsgs(m_controls));
//reset initialization
initial begin
    reset = 1'b1;
    #1 reset = 1'b0;
end

//clock generation
initial begin
    clk = 1'b0;
    forever #1 clk = ~clk;
end
    initial
        begin
        enable = 1;
            e_alu_y = 8'ha1;
            e_controls = '{default: '1, alu_op: 3'b101};
    end
endmodule
