module if_id_register(  input   logic           clk, reset,
                        input   logic           enable,
                        input   logic[31:0]     f_instr, f_pc,
                        output  logic[31:0]     d_instr, d_pc);


    always_ff @(posedge clk or posedge reset)
        if (reset) begin
	    d_instr <= 1'b0;
            d_pc<= 1'b0;
	end
	else if (enable) begin
            d_instr <= f_instr;
	    d_pc <= f_pc;
	end
	
endmodule
