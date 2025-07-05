library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.core_pkg.all;  -- Assuming core_pkg contains necessary types and constants

entity sign_ext is
  port (
    ext_op  : in  core_ext_op_t;   -- Extension operation (EXT_SIGN or EXT_ZERO)
    imm_in  : in  core_imm_t;      -- 10-bit immediate (from core_pkg)
    imm_out : out core_data_t      -- 32-bit extended immediate
  );
end entity sign_ext;

architecture rtl of sign_ext is
begin
  process(ext_op, imm_in)
  begin
    case ext_op is
      when core_EXT_SIGN =>
        -- Replicate the sign bit for the upper bits (sign extension)
        imm_out <= (core_DATA_WIDTH-1 downto core_IMM_WIDTH => imm_in(core_IMM_WIDTH-1))
                   & imm_in;
      when core_EXT_ZERO =>
        -- Fill the upper bits with zeros (zero extension)
        imm_out <= (core_DATA_WIDTH-1 downto core_IMM_WIDTH => '0')
                   & imm_in;
      when others =>
        -- Default to zero if the extension type is invalid
        imm_out <= (others => '0');
    end case;
  end process;
end architecture rtl;