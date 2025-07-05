-- core_id_ex_reg.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.core_pkg.all;

entity core_id_ex_reg is
  port(
    clk           : in  std_logic;
    reset_n       : in  std_logic;
    flush         : in  std_logic;
    ctrl_ex_in    : in  core_ctrl_ex_t;
    ctrl_mem_in   : in  core_ctrl_mem_t;
    ctrl_wb_in    : in  core_ctrl_wb_t;
    pc_plus1_in   : in  core_pc_t;
    rd1_in        : in  core_data_t;
    rd2_in        : in  core_data_t;
    imm_in        : in  core_data_t;
    rs_in         : in  core_reg_addr_t;
    rt_in         : in  core_reg_addr_t;
    rd_in         : in  core_reg_addr_t;
    ctrl_ex_out   : out core_ctrl_ex_t;
    ctrl_mem_out  : out core_ctrl_mem_t;
    ctrl_wb_out   : out core_ctrl_wb_t;
    pc_plus1_out  : out core_pc_t;
    rd1_out       : out core_data_t;
    rd2_out       : out core_data_t;
    imm_out       : out core_data_t;
    rs_out        : out core_reg_addr_t;
    rt_out        : out core_reg_addr_t;
    rd_out        : out core_reg_addr_t
  );
end entity core_id_ex_reg;

architecture rtl of core_id_ex_reg is
  signal reg_ctrl_ex   : core_ctrl_ex_t;
  signal reg_ctrl_mem  : core_ctrl_mem_t;
  signal reg_ctrl_wb   : core_ctrl_wb_t;
  signal reg_pc_plus1  : core_pc_t;
  signal reg_rd1       : core_data_t;
  signal reg_rd2       : core_data_t;
  signal reg_imm       : core_data_t;
  signal reg_rs        : core_reg_addr_t;
  signal reg_rt        : core_reg_addr_t;
  signal reg_rd        : core_reg_addr_t;
begin
  process(clk, reset_n)
  begin
    if reset_n = '0' then
      reg_ctrl_ex  <= (RegDst => '0', ALUSrc => '0', ALUOp => core_ALU_NOP);
      reg_ctrl_mem <= (MemRead => '0', MemWrite => '0', Branch => '0', Jump => '0');
      reg_ctrl_wb  <= (MemtoReg => '0', RegWrite => '0');
      reg_pc_plus1 <= (others => '0');
      reg_rd1      <= (others => '0');
      reg_rd2      <= (others => '0');
      reg_imm      <= (others => '0');
      reg_rs       <= (others => '0');
      reg_rt       <= (others => '0');
      reg_rd       <= (others => '0');
    elsif rising_edge(clk) then
      if flush = '1' then
        reg_ctrl_ex  <= (RegDst => '0', ALUSrc => '0', ALUOp => core_ALU_NOP);
        reg_ctrl_mem <= (MemRead => '0', MemWrite => '0', Branch => '0', Jump => '0');
        reg_ctrl_wb  <= (MemtoReg => '0', RegWrite => '0');
      else
        reg_ctrl_ex  <= ctrl_ex_in;
        reg_ctrl_mem <= ctrl_mem_in;
        reg_ctrl_wb  <= ctrl_wb_in;
      end if;
      reg_pc_plus1 <= pc_plus1_in;
      reg_rd1      <= rd1_in;
      reg_rd2      <= rd2_in;
      reg_imm      <= imm_in;
      reg_rs       <= rs_in;
      reg_rt       <= rt_in;
      reg_rd       <= rd_in;
    end if;
  end process;

  ctrl_ex_out  <= reg_ctrl_ex;
  ctrl_mem_out <= reg_ctrl_mem;
  ctrl_wb_out  <= reg_ctrl_wb;
  pc_plus1_out <= reg_pc_plus1;
  rd1_out      <= reg_rd1;
  rd2_out      <= reg_rd2;
  imm_out      <= reg_imm;
  rs_out       <= reg_rs;
  rt_out       <= reg_rt;
  rd_out       <= reg_rd;
end architecture rtl;
