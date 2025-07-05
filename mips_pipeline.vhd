library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.core_pkg.all;  -- Use the core package containing shared types and constants

entity mips_pipeline is
  port (
    clk     : in  std_logic;
    reset_n : in  std_logic;

    -- New output port: exposes the internal pc_cur for your TB
    pc_out  : out core_pc_t;
    -- wb_out  : out core_data_t     debug: write-back data
    test_rd : out core_data_t
  );
end entity mips_pipeline;

architecture rtl of mips_pipeline is

  ------------------------------------------------------------------
  -- 1) FETCH stage signals
  ------------------------------------------------------------------
  signal pc_cur, pc_next, pc_plus1   : core_pc_t;
  signal branch_target, jump_target  : core_pc_t;
  signal instr_if                    : core_instr_t;
  signal PCSrc, Jump                 : std_logic;

  -- IF/ID pipeline registers
  signal pc_id       : core_pc_t;
  signal instr_id    : core_instr_t;
  signal IFID_Write  : std_logic;
  signal IFID_Flush  : std_logic;

  ------------------------------------------------------------------
  -- 2) DECODE stage signals
  ------------------------------------------------------------------
  signal opcode       : std_logic_vector(core_OPCODE_WIDTH-1 downto 0);
  signal rs, rt, rd   : core_reg_addr_t;
  signal rd1, rd2     : core_data_t;
  signal imm_ext      : core_data_t;
  signal ctrl_ex      : core_ctrl_ex_t;
  signal ctrl_mem     : core_ctrl_mem_t;
  signal ctrl_wb      : core_ctrl_wb_t;
  signal IDEX_Flush   : std_logic;

  -- ID/EX pipeline registers
  signal pc_idex                    : core_pc_t;
  signal rd1_idex, rd2_idex         : core_data_t;
  signal imm_idex                   : core_data_t;
  signal rs_idex, rt_idex, rd_idex  : core_reg_addr_t;
  signal ctrl_ex_idex               : core_ctrl_ex_t;
  signal ctrl_mem_idex              : core_ctrl_mem_t;
  signal ctrl_wb_idex               : core_ctrl_wb_t;

  ------------------------------------------------------------------
  -- 3) EXECUTE stage signals
  ------------------------------------------------------------------
  signal ForwardA, ForwardB         : std_logic_vector(1 downto 0);
  signal alu_in1, alu_in2           : core_data_t;
  signal alu_src2                   : core_data_t;
  signal alu_result                 : core_data_t;
  signal EXMEM_Zero                 : std_logic;
  signal write_reg_mux              : core_reg_addr_t;

  -- EX/MEM pipeline registers
  signal ctrl_mem_exmem             : core_ctrl_mem_t;
  signal ctrl_wb_exmem              : core_ctrl_wb_t;
  signal alu_result_exmem           : core_data_t;
  signal write_data_exmem           : core_data_t;
  signal zero_exmem                 : std_logic;
  signal EXMEM_WriteReg             : core_reg_addr_t;

  ------------------------------------------------------------------
  -- 4) MEMORY stage signals
  ------------------------------------------------------------------
  signal mem_read_data              : core_data_t;

  -- MEM/WB pipeline registers
  signal ctrl_wb_memwb              : core_ctrl_wb_t;
  signal read_data_memwb            : core_data_t;
  signal alu_res_memwb              : core_data_t;
  signal MEMWB_WriteReg             : core_reg_addr_t;

  ------------------------------------------------------------------
  -- 5) WRITE-BACK stage signals
  ------------------------------------------------------------------
  signal wb_data                    : core_data_t;

begin
  ------------------------------------------------------------------
  -- DRIVE THE NEW OUTPUT
  ------------------------------------------------------------------
  pc_out <= pc_cur;
  test_rd <= wb_data;
  -- wb_out <= wb_data; (debug output for write-back data)
  
  ------------------------------------------------------------------
  -- 1) FETCH
  ------------------------------------------------------------------
  pc_inst: entity work.pc
    port map(
      clk      => clk,
      reset_n  => reset_n,
      pc_next  => pc_next,
      pc_cur   => pc_cur
    );

  if_stage_inst: entity work.core_if_stage
    port map(
      pc_cur        => pc_cur,
      branch_target => branch_target,
      jump_target   => jump_target,
      PCSrc         => PCSrc,
      Jump          => Jump,
      pc_plus1      => pc_plus1,
      pc_next       => pc_next
    );

  inst_mem_inst: entity work.inst_mem
    port map(
      clk   => clk,
      addr  => pc_cur,
      instr => instr_if
    );

  if_id_reg_inst: entity work.core_if_id_reg
    port map(
      clk          => clk,
      reset_n      => reset_n,
      write_en     => IFID_Write,
      flush        => IFID_Flush,
      pc_plus1_in  => pc_plus1,
      instr_in     => instr_if,
      pc_plus1_out => pc_id,
      instr_out    => instr_id
    );

  ------------------------------------------------------------------
  -- 2) DECODE
  ------------------------------------------------------------------
  opcode <= instr_id(23 downto 20);
  rs     <= instr_id(19 downto 15);
  rt     <= instr_id(14 downto 10);
  rd     <= instr_id(9  downto 5);

  control_unit_inst: entity work.core_control_unit
    port map(
      opcode   => opcode,
      ctrl_ex  => ctrl_ex,
      ctrl_mem => ctrl_mem,
      ctrl_wb  => ctrl_wb
    );

  register_file_inst: entity work.register_file
    port map(
      clk => clk,
      we  => ctrl_wb_memwb.RegWrite,
      ra1 => rs,
      ra2 => rt,
      wa  => MEMWB_WriteReg,
      wd  => wb_data,
      rd1 => rd1,
      rd2 => rd2
    );

  sign_ext_inst: entity work.sign_ext
    port map(
      ext_op  => core_EXT_SIGN,            -- choose per-instruction
      imm_in  => instr_id(9 downto 0),
      imm_out => imm_ext
    );

  hazard_unit_inst: entity work.core_hazard_unit
    port map(
      ID_EX_MemRead => ctrl_mem_idex.MemRead,
      ID_EX_Rt      => rt_idex,
      IF_ID_Rs      => rs,
      IF_ID_Rt      => rt,
      Stall         => open,
      PCWrite       => open,
      IF_ID_Write   => IFID_Write,
      ID_EX_Flush   => IDEX_Flush
    );

  ------------------------------------------------------------------
  -- 3) ID/EX PIPELINE REGISTER
  ------------------------------------------------------------------
  id_ex_reg_inst: entity work.core_id_ex_reg
    port map(
      clk           => clk,
      reset_n       => reset_n,
      flush         => IDEX_Flush,
      ctrl_ex_in    => ctrl_ex,
      ctrl_mem_in   => ctrl_mem,
      ctrl_wb_in    => ctrl_wb,
      pc_plus1_in   => pc_id,
      rd1_in        => rd1,
      rd2_in        => rd2,
      imm_in        => imm_ext,
      rs_in         => rs,
      rt_in         => rt,
      rd_in         => rd,
      ctrl_ex_out   => ctrl_ex_idex,
      ctrl_mem_out  => ctrl_mem_idex,
      ctrl_wb_out   => ctrl_wb_idex,
      pc_plus1_out  => pc_idex,
      rd1_out       => rd1_idex,
      rd2_out       => rd2_idex,
      imm_out       => imm_idex,
      rs_out        => rs_idex,
      rt_out        => rt_idex,
      rd_out        => rd_idex
    );

  ------------------------------------------------------------------
  -- 4) EXECUTE (Forwarding + ALU)
  ------------------------------------------------------------------
  forward_unit_inst: entity work.core_forward_unit
    port map(
      EX_MEM_RegWrite => ctrl_wb_exmem.RegWrite,
      EX_MEM_WriteReg => EXMEM_WriteReg,
      MEM_WB_RegWrite => ctrl_wb_memwb.RegWrite,
      MEM_WB_WriteReg => MEMWB_WriteReg,
      ID_EX_Rs        => rs_idex,
      ID_EX_Rt        => rt_idex,
      ForwardA        => ForwardA,
      ForwardB        => ForwardB
    );

  alu_in1 <=
       rd1_idex                when ForwardA = "00" else
       wb_data                 when ForwardA = "01" else
       alu_result_exmem        when ForwardA = "10" else
       rd1_idex;

  alu_in2 <=
       rd2_idex                when ForwardB = "00" else
       wb_data                 when ForwardB = "01" else
       alu_result_exmem        when ForwardB = "10" else
       rd2_idex;

  alu_src2 <= imm_idex when ctrl_ex_idex.ALUSrc = '1' else alu_in2;

  alu_inst: entity work.core_alu
    port map(
      A      => alu_in1,
      B      => alu_src2,
      ALUOp  => ctrl_ex_idex.ALUOp,
      Result => alu_result,
      Zero   => EXMEM_Zero
    );

  write_reg_mux <= rd_idex when ctrl_ex_idex.RegDst = '1' else rt_idex;

  ex_mem_reg_inst: entity work.core_ex_mem_reg
    port map(
      clk             => clk,
      reset_n         => reset_n,
      ctrl_mem_in     => ctrl_mem_idex,
      ctrl_wb_in      => ctrl_wb_idex,
      alu_result_in   => alu_result,
      write_data_in   => alu_in2,
      zero_in         => EXMEM_Zero,
      write_reg_in    => write_reg_mux,
      ctrl_mem_out    => ctrl_mem_exmem,
      ctrl_wb_out     => ctrl_wb_exmem,
      alu_result_out  => alu_result_exmem,
      write_data_out  => write_data_exmem,
      zero_out        => zero_exmem,
      write_reg_out   => EXMEM_WriteReg
    );

  ------------------------------------------------------------------
  -- 5) MEMORY
  ------------------------------------------------------------------
  data_mem_inst: entity work.core_data_mem
    port map(
      clk  => clk,
      addr => alu_result_exmem,
      we   => ctrl_mem_exmem.MemWrite,
      din  => write_data_exmem,
      dout => mem_read_data
    );

  ------------------------------------------------------------------
  -- 6) MEM/WB REGISTER
  ------------------------------------------------------------------
  mem_wb_reg_inst: entity work.mem_wb_reg
    port map(
      clk            => clk,
      reset_n        => reset_n,
      ctrl_wb_in     => ctrl_wb_exmem,
      read_data_in   => mem_read_data,
      alu_result_in  => alu_result_exmem,
      write_reg_in   => EXMEM_WriteReg,
      ctrl_wb_out    => ctrl_wb_memwb,
      read_data_out  => read_data_memwb,
      alu_result_out => alu_res_memwb,
      write_reg_out  => MEMWB_WriteReg
    );

  ------------------------------------------------------------------
  -- 7) WRITE BACK
  ------------------------------------------------------------------
  wb_data <= read_data_memwb when ctrl_wb_memwb.MemtoReg = '1'
             else alu_res_memwb;

  ------------------------------------------------------------------
  -- 8) BRANCH & JUMP LOGIC
  ------------------------------------------------------------------
  branch_target <= std_logic_vector(
                     unsigned(pc_idex) + unsigned(imm_idex)
                   );

  PCSrc <= ctrl_mem_exmem.Branch and zero_exmem;
  -- Jump target would come from a jump_logic unit, if you have one

end architecture rtl;
