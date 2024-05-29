`ifndef DEFINES_SV
`define DEFINES_SV
//==================  Instruction opcode
`define OP_LUI          7'b0110111
`define OP_AUIPC        7'b0010111
`define OP_JAL          7'b1101111
`define OP_JALR         7'b1100111
`define OP_BRANCH       7'b1100011
`define OP_LOAD         7'b0000011
`define OP_STORE        7'b0100011
`define OP_OP_IMM       7'b0010011
`define OP_R_TYPE       7'b0110011
`define OP_ILLEGAL_H    7'b1111111
`define OP_ILLEGAL_L    7'b0000000

//================== Instruction funct3
// JALR
`define FUNCT3_JALR 3'b000
// BRANCH
`define FUNCT3_BEQ  3'b000
`define FUNCT3_BNE  3'b001
`define FUNCT3_BLT  3'b100
`define FUNCT3_BGE  3'b101
`define FUNCT3_BLTU 3'b110
`define FUNCT3_BGEU 3'b111
// LOAD
`define FUNCT3_LB   3'b000
`define FUNCT3_LH   3'b001
`define FUNCT3_LW   3'b010
`define FUNCT3_LBU  3'b100
`define FUNCT3_LHU  3'b101
// STORE
`define FUNCT3_SB   3'b000
`define FUNCT3_SH   3'b001
`define FUNCT3_SW   3'b010
// OP-IMM
`define FUNCT3_ADDI      3'b000
`define FUNCT3_SLTI      3'b010
`define FUNCT3_SLTIU     3'b011
`define FUNCT3_XORI      3'b100
`define FUNCT3_ORI       3'b110
`define FUNCT3_ANDI      3'b111
`define FUNCT3_SLLI      3'b001
`define FUNCT3_SRLI_SRAI 3'b101
// OP
`define FUNCT3_ADD_SUB 3'b000
`define FUNCT3_SLL     3'b001
`define FUNCT3_SLT     3'b010
`define FUNCT3_SLTU    3'b011
`define FUNCT3_XOR     3'b100
`define FUNCT3_SRL_SRA 3'b101
`define FUNCT3_OR      3'b110
`define FUNCT3_AND     3'b111
// MISC-MEM
`define FUNCT3_FENCE  3'b000
`define FUNCT3_FENCEI 3'b001

//================== Instruction funct7 in RISC-V ==================
`define FUNCT7_SLLI 7'b0000000
// SRLI_SRAI
`define FUNCT7_SRLI 7'b0000000
`define FUNCT7_SRAI 7'b0100000
// ADD_SUB
`define FUNCT7_ADD  7'b0000000
`define FUNCT7_SUB  7'b0100000
`define FUNCT7_SLL  7'b0000000
`define FUNCT7_SLT  7'b0000000
`define FUNCT7_SLTU 7'b0000000
`define FUNCT7_XOR  7'b0000000
// SRL_SRA
`define FUNCT7_SRL 7'b0000000
`define FUNCT7_SRA 7'b0100000
`define FUNCT7_OR  7'b0000000
`define FUNCT7_AND 7'b0000000

//================== AluSrcA ==================
`define EXE_ALUSRCA_RRD1    2'b00
`define EXE_ALUSRCA_ZERO    2'b01
`define EXE_ALUSRCA_PC      2'b10

//================== AluSrcB ==================
`define EXE_ALUSRCB_RRD2    1'b0
`define EXE_ALUSRCB_IMM     1'b1

//================== AluOp ==================
`define EXE_ADD_OP  0
`define EXE_SUB_OP  1
`define EXE_XOR_OP  2
`define EXE_OR_OP   3
`define EXE_AND_OP  4

`define EXE_SLL_OP  5
`define EXE_SRL_OP  6
`define EXE_SRA_OP  7
`define EXE_SLT_OP  8
`define EXE_SLTU_OP 9

//================= Jump_Branch Control
`define EXE_BJOP_NOOP   0
`define EXE_BJOP_JUMP   1
`define EXE_BJOP_BEQ    2
`define EXE_BJOP_BNE    3
`define EXE_BJOP_BLT    4
`define EXE_BJOP_BGE    5
`define EXE_BJOP_BLTU   6
`define EXE_BJOP_BGEU   7

//================= Immediate Generator Op
`define IMMG_OP_R   0
`define IMMG_OP_I   1
`define IMMG_OP_S   2
`define IMMG_OP_B   3
`define IMMG_OP_U   4
`define IMMG_OP_J   5

//==================    Data Memory Write Source Multiplexer
`define EXE_MEMWDSRC_B  2'b01
`define EXE_MEMWDSRC_H  2'b01
`define EXE_MEMWDSRC_W  2'b10


//==================    Data Memory dataout Multiplexer
`define EXE_DATAOUTSRC_ALUY     3'b000
`define EXE_DATAOUTSRC_PC4      3'b001
`define EXE_DATAOUTSRC_RD32     3'b010
`define EXE_DATAOUTSRC_RDS16    3'b011
`define EXE_DATAOUTSRC_RDZ16    3'b100
`define EXE_DATAOUTSRC_RDS8     3'b101
`define EXE_DATAOUTSRC_RDZ8     3'b110

//==================  Hardware Properties ==================

// Instruction Memory
`define INSTR_ADDR_BUS 31:0
`define INSTR_BUS 31:0

// Register File
`define REG_ADDR_BUS 4:0
`define REG_BUS 31:0

// Memory
`define MEM_ADDR_BUS 31:0
`define MEM_DATA_BUS 31:0
`define MEM_WMASK_BUS 7:0

// Control Signal
`define ALU_OP_BUS 3:0
`define ALU_SRCA_SEL 1:0
`define IMMG_OP_BUS 2:0
`define BJ_OP_BUS 2:0
`define DATAOUT_SRC_BUS 2:0
`define MEM_D_WDSRC_BUS 2:0

`endif
