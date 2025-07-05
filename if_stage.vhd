-- core_if_stage.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.core_pkg.all;

entity core_if_stage is
  port(
    pc_cur         : in  core_pc_t;          -- current PC
    branch_target  : in  core_pc_t;          -- from EX/MEM branch adder
    jump_target    : in  core_pc_t;          -- from ID jump concatenation
    PCSrc          : in  std_logic;         -- branch-taken signal
    Jump           : in  std_logic;         -- jump signal
    pc_plus1       : out core_pc_t;          -- PC + 1 (to IF/ID)
    pc_next        : out core_pc_t           -- next PC (to PC reg)
  );
end entity core_if_stage;

architecture rtl of core_if_stage is
  signal pc_inc : core_pc_t;
begin

  -- Compute PC + PC_INCREMENT
  pc_inc <= std_logic_vector(
              unsigned(pc_cur) + to_unsigned(core_PC_INCREMENT, core_PC_WIDTH)
            );

  -- Expose PC+1 for IF/ID register
  pc_plus1 <= pc_inc;

  -- Select next PC:
  -- priority: Jump ? Branch ? Sequential
  process(pc_inc, branch_target, jump_target, PCSrc, Jump)
  begin
    if Jump = '1' then
      pc_next <= jump_target;
    elsif PCSrc = '1' then
      pc_next <= branch_target;
    else
      pc_next <= pc_inc;
    end if;
  end process;

end architecture rtl;
