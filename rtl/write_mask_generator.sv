`include "defines.sv"


module write_mask_generator (   input   logic [`MEM_D_WDSRC_BUS]  wdsrc,
                                input   logic [`MEM_ADDR_BUS]   wa,
                                output  logic [`MEM_WMASK_BUS]  wmask);
    always_comb
        case(wdsrc)
            `EXE_MEMWDSRC_B:
                case (wa[1:0])
                    2'b00:      wmask = 4'b0001;
                    2'b01:      wmask = 4'b0010;
                    2'b10:      wmask = 4'b0100;
                    2'b11:      wmask = 4'b1000;
                    default:    wmask = 4'b0000;
                endcase
            `EXE_MEMWDSRC_H:    wmask = wa[0] ? 4'b0000 : (wa[1] ? 4'b1100 : 4'b0011);
            `EXE_MEMWDSRC_W:    wmask = 4'b1111;
            default:            wmask = 4'b0000;
        endcase
endmodule
