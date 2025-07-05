library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.core_pkg.all;  -- Assuming core_pkg contains necessary types and constants

entity mem_wb_reg is
  port(
    clk             : in  std_logic;
    reset_n         : in  std_logic;
    ctrl_wb_in      : in  core_ctrl_wb_t;  -- core_ctrl_wb_t defined in core_pkg
    read_data_in    : in  core_data_t;     -- core_data_t defined in core_pkg
    alu_result_in   : in  core_data_t;     -- core_data_t defined in core_pkg
    write_reg_in    : in  core_reg_addr_t; -- core_reg_addr_t defined in core_pkg
    ctrl_wb_out     : out core_ctrl_wb_t;  -- core_ctrl_wb_t defined in core_pkg
    read_data_out   : out core_data_t;     -- core_data_t defined in core_pkg
    alu_result_out  : out core_data_t;     -- core_data_t defined in core_pkg
    write_reg_out   : out core_reg_addr_t  -- core_reg_addr_t defined in core_pkg
  );
end entity mem_wb_reg;

architecture rtl of mem_wb_reg is
begin
  process(clk, reset_n)
  begin
    if reset_n = '0' then
      ctrl_wb_out    <= (others => '0');  -- Reset output to '0'
      read_data_out  <= (others => '0');  -- Reset output to '0'
      alu_result_out <= (others => '0');  -- Reset output to '0'
      write_reg_out  <= (others => '0');  -- Reset output to '0'
    elsif rising_edge(clk) then
      ctrl_wb_out    <= ctrl_wb_in;       -- Pass input to output on rising edge
      read_data_out  <= read_data_in;     -- Pass input to output on rising edge
      alu_result_out <= alu_result_in;    -- Pass input to output on rising edge
      write_reg_out  <= write_reg_in;     -- Pass input to output on rising edge
    end if;
  end process;
end architecture rtl;
