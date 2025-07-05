-- core_ex_mem_reg.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.core_pkg.all;

entity core_ex_mem_reg is
  port(
    clk             : in  std_logic;
    reset_n         : in  std_logic;
    ctrl_mem_in     : in  core_ctrl_mem_t;
    ctrl_wb_in      : in  core_ctrl_wb_t;
    alu_result_in   : in  core_data_t;
    write_data_in   : in  core_data_t;
    zero_in         : in  std_logic;
    write_reg_in    : in  core_reg_addr_t;
    ctrl_mem_out    : out core_ctrl_mem_t;
    ctrl_wb_out     : out core_ctrl_wb_t;
    alu_result_out  : out core_data_t;
    write_data_out  : out core_data_t;
    zero_out        : out std_logic;
    write_reg_out   : out core_reg_addr_t
  );
end entity core_ex_mem_reg;

architecture rtl of core_ex_mem_reg is
  signal reg_ctrl_mem  : core_ctrl_mem_t;
  signal reg_ctrl_wb   : core_ctrl_wb_t;
  signal reg_alu_res   : core_data_t;
  signal reg_write_dat : core_data_t;
  signal reg_zero      : std_logic;
  signal reg_wr        : core_reg_addr_t;
begin
  process(clk, reset_n)
  begin
    if reset_n = '0' then
      reg_ctrl_mem  <= (MemRead => '0', MemWrite => '0', Branch => '0', Jump => '0');
      reg_ctrl_wb   <= (MemtoReg => '0', RegWrite => '0');
      reg_alu_res   <= (others => '0');
      reg_write_dat <= (others => '0');
      reg_zero      <= '0';
      reg_wr        <= (others => '0');
    elsif rising_edge(clk) then
      reg_ctrl_mem  <= ctrl_mem_in;
      reg_ctrl_wb   <= ctrl_wb_in;
      reg_alu_res   <= alu_result_in;
      reg_write_dat <= write_data_in;
      reg_zero      <= zero_in;
      reg_wr        <= write_reg_in;
    end if;
  end process;

  ctrl_mem_out    <= reg_ctrl_mem;
  ctrl_wb_out     <= reg_ctrl_wb;
  alu_result_out  <= reg_alu_res;
  write_data_out  <= reg_write_dat;
  zero_out        <= reg_zero;
  write_reg_out   <= reg_wr;
end architecture rtl;
