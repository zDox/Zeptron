`include "controlsgs.sv"


module decode_stage_tb;

    logic [31:0] instr;

    controlsgs_t  controlsgs;

    decode_stage dut(.instr(instr), .controlsgs(controlsgs));


   // Define the memory array to hold the instructions
    logic [31:0] instruction_memory [1023]; // Adjust size as needed

    // Task to read instructions from file
    initial begin
        // Open the file and read instructions into memory
        $readmemh("tests/decode_stage_test.hex", instruction_memory);

        // Apply instructions to DUT
        for (int i = 0; i < 1024; i++) begin
            instr = instruction_memory[i];
            #1; // Wait for 10 time units (adjust as needed)
        end

    end

    // Monitor signals (optional)
    initial begin
        $monitor("At time %0t, instr = %h, control = %p", $time, instr, controlsgs);
    end

endmodule
