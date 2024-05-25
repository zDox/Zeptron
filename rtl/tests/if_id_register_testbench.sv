module if_id_register_testbench;

    logic clk, reset, enable;
    logic [31:0] f_instr, f_pc, d_instr, d_pc;
	

	
	
    if_id_register dut(.clk(clk), .reset(reset), .enable(enable),
			.f_instr(f_instr), .f_pc(f_pc), 
			.d_instr(d_instr), .d_pc(d_pc));
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
            f_instr = 8'ha1;
            f_pc = 8'h49; #5;
    end
endmodule
