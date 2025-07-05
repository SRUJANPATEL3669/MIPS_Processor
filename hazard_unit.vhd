-- core_hazard_unit.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.core_pkg.all;

entity core_hazard_unit is
  port(
    ID_EX_MemRead  : in  std_logic;
    ID_EX_Rt       : in  core_reg_addr_t;
    IF_ID_Rs       : in  core_reg_addr_t;
    IF_ID_Rt       : in  core_reg_addr_t;
    Stall          : out std_logic;
    PCWrite        : out std_logic;
    IF_ID_Write    : out std_logic;
    ID_EX_Flush    : out std_logic
  );
end entity core_hazard_unit;

architecture rtl of core_hazard_unit is
  signal load_use : std_logic;
begin
  load_use <= '1' when (ID_EX_MemRead = '1' and
                        (ID_EX_Rt = IF_ID_Rs or ID_EX_Rt = IF_ID_Rt))
              else '0';

  Stall       <= load_use;
  PCWrite     <= not load_use;
  IF_ID_Write <= not load_use;
  ID_EX_Flush <= load_use;
end architecture rtl;
