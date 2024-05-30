`include "defines.sv"
`include "controlsgs.sv"


module datamemory_stage(    // Inputs
                            input   logic [`REG_BUS]        alu_y, rrd2, pc_4,
                            input   controlsgs_t            controlsgs,
                            // Interconnects to Data Memory
                            input   logic [`MEM_DATA_BUS]   mem_rd,
                            output  logic                   mem_we,
                            output  logic [`MEM_ADDR_BUS]   mem_a,
                            output  logic [`MEM_DATA_BUS]   mem_wd,
                            output  logic [`MEM_WMASK_BUS]  mem_wmask,
                            // Output
                            output  logic [`REG_BUS]        dataout);

    logic [15:0]    rd16;
    logic [7:0]     rd8;


    // Outputs to Data Memory
    assign mem_a =          alu_y[31:0];
    assign mem_we =         controlsgs.mem_d_we;
    write_mask_generator    wmg(.wdsrc(controlsgs.mem_d_wdsrc), .wa(alu_y),
                                .wmask(mem_wmask));
    assign mem_wd =         rrd2;

    // Output Selection of Data Memory
    mux2 #(16)  muxrd16(.d0(mem_rd[15:0]), .d1(mem_rd[31:16]), .s(alu_y[1]),
                        .y(rd16));
    mux4 #(8)   muxrd8 (.d0(mem_rd[7:0]), .d1(mem_rd[15:8]),
                        .d2(mem_rd[23:16]), .d3(mem_rd[31:24]),
                        .s(alu_y[1:0]),
                        .y(rd8));

    always_comb
        case (controlsgs.dataout_src)
            `EXE_DATAOUTSRC_ALUY:   dataout = alu_y;
            `EXE_DATAOUTSRC_PC4:    dataout = pc_4;
            `EXE_DATAOUTSRC_RD32:   dataout = mem_rd;
            `EXE_DATAOUTSRC_RDS16:  dataout = {{16{rd16[15]}}, rd16};
            `EXE_DATAOUTSRC_RDZ16:  dataout = {{16{1'b0}}, rd16};
            `EXE_DATAOUTSRC_RDS8:   dataout = {{24{rd8[7]}}, rd8};
            `EXE_DATAOUTSRC_RDZ8:   dataout = {{24{1'b0}}, rd8};
            default:                dataout = alu_y;
        endcase
endmodule
