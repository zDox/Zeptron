`include "controlsgs.sv"


module writeback_stage (    input   controlsgs_t    controlsgs,
                            output  logic           regwe);
    assign regwe = controlsgs.reg_we;
endmodule
