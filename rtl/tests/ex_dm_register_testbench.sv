module ex_dm_register_testbench;

    logic clk, reset, enable;
    logic [31:0] e_alu_y, m_alu_y;
    controlsgs_if   e_controls();
    controlsgs_if   m_controls();

    ex_dm_register dut( .clk(clk), .reset(reset), .enable(enable),
                        .e_alu_y(e_alu_y), .e_controlsgs_io(e_controls),
                        .m_alu_y(m_alu_y), .m_controlsgs_io(m_controls));
//reset initialization
initial begin
    reset = 1'b1;
    #20 reset = 1'b0;
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
            e_controls.mem_d_we = 1'b1;
    end
endmodule
