library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.core_pkg.all;  -- Assuming core_pkg contains necessary types and constants

entity inst_mem is
  port (
    clk   : in  std_logic;        -- System clock
    addr  : in  core_pc_t;         -- Word-addressed PC (core_pc_t defined in core_pkg)
    instr : out core_instr_t       -- Fetched instruction (core_instr_t defined in core_pkg)
  );
end entity inst_mem;

architecture rtl of inst_mem is

  -- Define memory type: array of core_instr_t (24 bits)
  type mem_t is array(0 to core_IMEM_DEPTH-1) of core_instr_t;

  -- Memory Initialization (24-bit instructions)
  signal IM : mem_t := (
    0 => x"200805",  -- addi $t0, $zero, 5
    1 => x"200903",  -- addi $t1, $zero, 3
    2 => x"010950",  -- add  $t2, $t0, $t1
    3 => x"012858",  -- sub  $t3, $t1, $t0
    4 => x"8D0C00",  -- lw   $t4, 0($t0)
    5 => x"AD0B04",  -- sw   $t3, 4($t0)
    6 => x"1109FC",  -- beq  $t0, $t1, back (offset = -4)
    7 => x"080002",  -- j    to word address 2
    others => (others => '0')
  );

  -- Optional: Force Vivado to infer Block RAM
  attribute ram_style : string;
  attribute ram_style of IM : signal is "block";

begin

  -- Synchronous read: fetch instruction at rising edge
  process(clk)
  begin
    if rising_edge(clk) then
      instr <= IM(to_integer(unsigned(addr)));
    end if;
  end process;

end architecture rtl;
