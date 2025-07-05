-- alu.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.core_pkg.all;

entity core_alu is
  port(
    A      : in  core_data_t;
    B      : in  core_data_t;
    ALUOp  : in  core_alu_op_t;
    Result : out core_data_t;
    Zero   : out std_logic
  );
end entity core_alu;

architecture rtl of core_alu is
  signal sA, sB : signed(CORE_DATA_WIDTH-1 downto 0);
  signal sR     : signed(CORE_DATA_WIDTH-1 downto 0);
begin
  sA <= signed(A);
  sB <= signed(B);

  process(sA, sB, ALUOp)
  begin
    case ALUOp is
      when CORE_ALU_ADD =>
        sR <= sA + sB;
      when CORE_ALU_SUB =>
        sR <= sA - sB;
      when CORE_ALU_AND =>
        sR <= sA and sB;
      when CORE_ALU_OR  =>
        sR <= sA or sB;
      when CORE_ALU_XOR =>
        sR <= sA xor sB;
      when CORE_ALU_SLT =>
        if sA < sB then
          sR <= to_signed(1, CORE_DATA_WIDTH);
        else
          sR <= to_signed(0, CORE_DATA_WIDTH);
        end if;
      when others =>
        sR <= (others => '0');
    end case;

    Result <= std_logic_vector(sR);
    if sR = to_signed(0, CORE_DATA_WIDTH) then
      Zero <= '1';
    else
      Zero <= '0';
    end if;
  end process;
end architecture rtl;
