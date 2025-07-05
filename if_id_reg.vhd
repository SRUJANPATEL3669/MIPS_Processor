-- core_if_id_reg.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.core_pkg.all;

entity core_if_id_reg is
  port(
    clk          : in  std_logic;
    reset_n      : in  std_logic;
    write_en     : in  std_logic;
    flush        : in  std_logic;
    pc_plus1_in  : in  core_pc_t;
    instr_in     : in  core_instr_t;
    pc_plus1_out : out core_pc_t;
    instr_out    : out core_instr_t
  );
end entity core_if_id_reg;

architecture rtl of core_if_id_reg is
  signal pc_reg    : core_pc_t := (others => '0');
  signal instr_reg : core_instr_t := (others => '0');
begin
  process(clk, reset_n)
  begin
    if reset_n = '0' then
      pc_reg    <= (others => '0');
      instr_reg <= (others => '0');
    elsif rising_edge(clk) then
      if write_en = '1' then
        if flush = '1' then
          pc_reg    <= (others => '0');
          instr_reg <= (others => '0');
        else
          pc_reg    <= pc_plus1_in;
          instr_reg <= instr_in;
        end if;
      end if;
    end if;
  end process;

  pc_plus1_out <= pc_reg;
  instr_out    <= instr_reg;
end architecture rtl;
