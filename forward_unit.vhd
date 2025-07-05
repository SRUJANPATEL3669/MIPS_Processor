-- core_forward_unit.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.core_pkg.all;

entity core_forward_unit is
  port(
    EX_MEM_RegWrite : in  std_logic;
    EX_MEM_WriteReg : in  core_reg_addr_t;
    MEM_WB_RegWrite : in  std_logic;
    MEM_WB_WriteReg : in  core_reg_addr_t;
    ID_EX_Rs        : in  core_reg_addr_t;
    ID_EX_Rt        : in  core_reg_addr_t;
    ForwardA        : out std_logic_vector(1 downto 0);
    ForwardB        : out std_logic_vector(1 downto 0)
  );
end entity core_forward_unit;

architecture rtl of core_forward_unit is
begin
  process(EX_MEM_RegWrite, EX_MEM_WriteReg,
          MEM_WB_RegWrite, MEM_WB_WriteReg,
          ID_EX_Rs, ID_EX_Rt)
  begin
    -- default: no forwarding
    ForwardA <= "00";
    ForwardB <= "00";

    -- EX/MEM hazard
    if (EX_MEM_RegWrite = '1') and (EX_MEM_WriteReg /= "00000") then
      if EX_MEM_WriteReg = ID_EX_Rs then
        ForwardA <= "10";
      end if;
      if EX_MEM_WriteReg = ID_EX_Rt then
        ForwardB <= "10";
      end if;
    end if;

    -- MEM/WB hazard
    if (MEM_WB_RegWrite = '1') and (MEM_WB_WriteReg /= "00000") then
      if (MEM_WB_WriteReg = ID_EX_Rs) and not
         ((EX_MEM_RegWrite = '1') and (EX_MEM_WriteReg = ID_EX_Rs)) then
        ForwardA <= "01";
      end if;
      if (MEM_WB_WriteReg = ID_EX_Rt) and not
         ((EX_MEM_RegWrite = '1') and (EX_MEM_WriteReg = ID_EX_Rt)) then
        ForwardB <= "01";
      end if;
    end if;
  end process;
end architecture rtl;
