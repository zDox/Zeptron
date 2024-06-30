`include "defines.sv"


// Instruction Memory is assigned to port 1
// Data Memory is assigned to port 2

module dual_port_mem #( parameter mem_content_path,
                        parameter signature_path = "tests/my.sig")
                    (   input   logic                   clk, we2,
                        input   logic [`MEM_WMASK_BUS]  w2mask,
                        input   logic [`MEM_ADDR_BUS]   a2,
                        input   logic [`MEM_DATA_BUS]   wd2,
                        input   logic [`INSTR_ADDR_BUS] a1,
                        output  logic [`INSTR_BUS]      rd1,
                        output  logic [`MEM_DATA_BUS]   rd2);
    logic [31:0] RAM [524288];

    // Init
    initial
        $readmemh(mem_content_path, RAM);

    // asynchronous read from Memory
    assign rd2 = RAM[a2[31:2]]; // word aligned
    assign rd1 =  RAM[a1>>2];

    always_ff @(posedge clk)
        if (we2) begin
            if (w2mask[0]) RAM[a2[31:2]][7:0]   <= wd2[7:0];
            if (w2mask[1]) RAM[a2[31:2]][15:8]  <= wd2[15:8];
            if (w2mask[2]) RAM[a2[31:2]][23:16] <= wd2[23:16];
            if (w2mask[3]) RAM[a2[31:2]][31:24] <= wd2[31:24];
        end


    // test utils
    logic [`MEM_DATA_BUS]   begin_sign, end_sign;
    logic                   exit;


    // Task to dump memory content to a file
    function dump_memory_to_file(input int begin_sig, input int end_sig);

        integer i, file;
        file = $fopen(signature_path, "w");
        $display("Begin Signature: %h", begin_sig);
        $display("End Signature: %h", end_sig);
        if (file == 0) begin
            $display("Error: Could not open file %s for writing.", signature_path);
            $finish;
        end
        for (i = begin_sign; i < end_sig; i= i+4) begin
            $fwrite(file, "%h\n", RAM[i/4]);
        end
        $fclose(file);
        $display("Memory content dumped to %s", signature_path);
        $stop();
    endfunction


    always_ff @(posedge clk) begin
        if (we2)
            case (a2)
                'h100:  begin_sign <= wd2;
                'h104:  end_sign <= wd2;
                'h108:  exit <= 1;
            endcase
        if (exit == 1) dump_memory_to_file(begin_sign, end_sign);
    end
endmodule
