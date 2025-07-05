library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package core_pkg is

  --============== Global Widths ==============
  constant CORE_INSTR_WIDTH      : integer := 24;   -- instruction bus width
  constant CORE_DATA_WIDTH       : integer := 32;   -- data bus width
  constant CORE_PC_WIDTH         : integer := 32;   -- program counter width
  constant CORE_REG_ADDR_WIDTH   : integer := 5;    -- register file address width
  constant CORE_REG_COUNT        : integer := 2**CORE_REG_ADDR_WIDTH;
  constant CORE_IMM_WIDTH        : integer := 10;   -- immediate field width
  constant CORE_JUMP_ADDR_WIDTH  : integer := 20;   -- jump address field width
  constant CORE_OPCODE_WIDTH     : integer := 4;    -- primary opcode width

  --============== Memory Depths ==============
  constant CORE_IMEM_DEPTH       : integer := 1024; -- number of instructions
  constant CORE_DMEM_DEPTH       : integer := 1024; -- number of data words

  --============== PC Increment ==============
  constant CORE_PC_INCREMENT     : integer := 1;    -- word-addressed PC
  
  subtype core_instr_t     is std_logic_vector(CORE_INSTR_WIDTH-1    downto 0);
  subtype core_data_t      is std_logic_vector(CORE_DATA_WIDTH-1     downto 0);
  subtype core_pc_t        is std_logic_vector(CORE_PC_WIDTH-1       downto 0);
  subtype core_reg_addr_t  is std_logic_vector(CORE_REG_ADDR_WIDTH-1 downto 0);
  subtype core_imm_t       is std_logic_vector(CORE_IMM_WIDTH-1      downto 0);
  subtype core_jump_addr_t is std_logic_vector(CORE_JUMP_ADDR_WIDTH-1 downto 0);

  --============== ALU Operation Codes ========
  type core_alu_op_t is (
    CORE_ALU_ADD,   -- addition
    CORE_ALU_SUB,   -- subtraction
    CORE_ALU_AND,   -- bitwise AND
    CORE_ALU_OR,    -- bitwise OR
    CORE_ALU_XOR,   -- bitwise XOR
    CORE_ALU_SLT,   -- set-on-less-than
    CORE_ALU_NOP    -- no operation
  );

  --============== Extend Operation ===========
  type core_ext_op_t is (
    CORE_EXT_SIGN,  -- sign-extend
    CORE_EXT_ZERO   -- zero-extend
  );

  --============== Control Signals Bundle =====
  type core_ctrl_ex_t is record
    RegDst   : std_logic;       -- choose Rd vs Rt for write register
    ALUSrc   : std_logic;       -- choose register vs immediate for ALU src
    ALUOp    : core_alu_op_t;   -- ALU operation code
  end record;

  type core_ctrl_mem_t is record
    MemRead  : std_logic;
    MemWrite : std_logic;
    Branch   : std_logic;
    Jump     : std_logic;
  end record;

  type core_ctrl_wb_t is record
    MemtoReg : std_logic;
    RegWrite : std_logic;
  end record;

end package core_pkg;