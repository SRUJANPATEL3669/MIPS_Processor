library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.core_pkg.all;  -- Use the core package containing shared types and constants

entity tb_mips_pipeline is
end entity tb_mips_pipeline;

architecture behavior of tb_mips_pipeline is

  -- Signals for clock, reset, and outputs from the DUT (Device Under Test)
  signal clk     : std_logic := '0';
  signal reset_n : std_logic := '0';
  signal pc_out  : core_pc_t;
  signal test_rd : core_data_t;

  -- Constants
  constant clk_period : time := 10 ns;

begin

  -- Instantiate the MIPS pipeline (DUT)
  uut: entity work.mips_pipeline
    port map (
      clk     => clk,
      reset_n => reset_n,
      pc_out  => pc_out,
      test_rd => test_rd
    );

  -- Clock Generation: 50 MHz clock (10ns period)
  clk_process: process
  begin
    clk <= '0';
    wait for clk_period / 2;
    clk <= '1';
    wait for clk_period / 2;
  end process;

  -- Stimulus Generation
  stimulus_process: process
  begin
    -- Initial reset (active-low)
    reset_n <= '0';
    wait for 20 ns;
    reset_n <= '1';

    -- Wait for some time to observe pipeline behavior
    wait for 500 ns;

    -- End simulation
    assert false report "Simulation completed!" severity failure;
  end process;

end architecture behavior;
