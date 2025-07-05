library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.core_pkg.all;  -- Assuming core_pkg contains necessary types and constants

entity pc is
  port (
    clk      : in  std_logic;   -- clock
    reset_n  : in  std_logic;   -- active-low reset
    pc_next  : in  core_pc_t;   -- next PC value (core_pc_t type from core_pkg)
    pc_cur   : out core_pc_t    -- current PC value (core_pc_t type from core_pkg)
  );
end entity pc;

architecture rtl of pc is
  signal pc_reg : core_pc_t := (others => '0');  -- Initialize to zero
begin

  process(clk, reset_n)
  begin
    if reset_n = '0' then
      pc_reg <= (others => '0');  -- Reset to zero on reset
    elsif rising_edge(clk) then
      pc_reg <= pc_next;  -- Update PC value on rising edge of the clock
    end if;
  end process;

  pc_cur <= pc_reg;  -- Assign the current PC value to the output

end architecture rtl;
