library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.core_pkg.all;  -- Assuming core_pkg contains necessary types and constants

entity register_file is
  port (
    clk   : in  std_logic;      -- system clock
    we    : in  std_logic;      -- write-enable (RegWrite)
    ra1   : in  core_reg_addr_t; -- read address port 1
    ra2   : in  core_reg_addr_t; -- read address port 2
    wa    : in  core_reg_addr_t; -- write address
    wd    : in  core_data_t;     -- write data
    rd1   : out core_data_t;    -- read data port 1
    rd2   : out core_data_t     -- read data port 2
  );
end entity register_file;

architecture rtl of register_file is
  -- Array of REG_COUNT registers, each DATA_WIDTH bits
  type regfile_t is array (0 to core_REG_COUNT-1) of core_data_t;
  signal regs : regfile_t := (others => (others => '0'));

  -- Constant zero address (assuming reg_addr_t is a 5-bit address)
  constant ZERO_ADDR : core_reg_addr_t := (others => '0');
begin

  -- Synchronous write-back on rising edge of the clock
  process(clk)
  begin
    if rising_edge(clk) then
      if we = '1' and wa /= ZERO_ADDR then
        regs(to_integer(unsigned(wa))) <= wd;  -- Write data to register
      end if;
    end if;
  end process;

  -- Asynchronous reads (return zero for zero address)
  rd1 <= (others => '0') when ra1 = ZERO_ADDR else regs(to_integer(unsigned(ra1)));
  rd2 <= (others => '0') when ra2 = ZERO_ADDR else regs(to_integer(unsigned(ra2)));

end architecture rtl;
