-- core_data_mem.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.core_pkg.all;

entity core_data_mem is
  port (
    clk   : in  std_logic;        -- system clock
    addr  : in  core_pc_t;         -- word-addressed data address
    we    : in  std_logic;         -- write enable
    din   : in  core_data_t;       -- data to write
    dout  : out core_data_t        -- data read
  );
end entity core_data_mem;

architecture rtl of core_data_mem is
  -- depth taken from package; each entry is CORE_DATA_WIDTH bits
  type mem_t is array(0 to CORE_DMEM_DEPTH-1) of core_data_t;
  signal DM : mem_t := (others => (others => '0'));

  -- infer Block RAM in Vivado
  attribute ram_style : string;
  attribute ram_style of DM : signal is "block";
begin

  -- synchronous read/write on rising edge
  process(clk)
  begin
    if rising_edge(clk) then
      if we = '1' then
        DM(to_integer(unsigned(addr))) <= din;
      end if;
      dout <= DM(to_integer(unsigned(addr)));
    end if;
  end process;

end architecture rtl;
