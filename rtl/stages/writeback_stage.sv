`include "controlsgs.sv"


module writeback_stage (    input   controlsgs_t    controlsgs,
                            output  logic           regwrite);
    assign regwrite = controlsgs.reg_we;
endmodule
