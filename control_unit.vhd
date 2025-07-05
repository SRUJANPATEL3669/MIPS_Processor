-- core_control_unit.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.core_pkg.all;

entity core_control_unit is
  port (
    opcode    : in  std_logic_vector(CORE_OPCODE_WIDTH-1 downto 0);
    ctrl_ex   : out core_ctrl_ex_t;
    ctrl_mem  : out core_ctrl_mem_t;
    ctrl_wb   : out core_ctrl_wb_t
  );
end entity core_control_unit;

architecture rtl of core_control_unit is
begin
  process(opcode)
  begin
    -- defaults (NOP)
    ctrl_ex.RegDst   <= '0';
    ctrl_ex.ALUSrc   <= '0';
    ctrl_ex.ALUOp    <= CORE_ALU_ADD;
    ctrl_mem.MemRead  <= '0';
    ctrl_mem.MemWrite <= '0';
    ctrl_mem.Branch   <= '0';
    ctrl_mem.Jump     <= '0';
    ctrl_wb.MemtoReg  <= '0';
    ctrl_wb.RegWrite  <= '0';

    case opcode is
      -- R-type ALU ops (write ALU result to Rd)
      when "0000" =>  -- add
        ctrl_ex.RegDst   <= '1';
        ctrl_ex.ALUSrc   <= '0';
        ctrl_ex.ALUOp    <= CORE_ALU_ADD;
        ctrl_wb.RegWrite <= '1';
      when "0001" =>  -- sub
        ctrl_ex.RegDst   <= '1';
        ctrl_ex.ALUSrc   <= '0';
        ctrl_ex.ALUOp    <= CORE_ALU_SUB;
        ctrl_wb.RegWrite <= '1';
      when "0010" =>  -- and
        ctrl_ex.RegDst   <= '1';
        ctrl_ex.ALUSrc   <= '0';
        ctrl_ex.ALUOp    <= CORE_ALU_AND;
        ctrl_wb.RegWrite <= '1';
      when "0011" =>  -- or
        ctrl_ex.RegDst   <= '1';
        ctrl_ex.ALUSrc   <= '0';
        ctrl_ex.ALUOp    <= CORE_ALU_OR;
        ctrl_wb.RegWrite <= '1';
      when "0100" =>  -- xor
        ctrl_ex.RegDst   <= '1';
        ctrl_ex.ALUSrc   <= '0';
        ctrl_ex.ALUOp    <= CORE_ALU_XOR;
        ctrl_wb.RegWrite <= '1';
      when "0101" =>  -- slt
        ctrl_ex.RegDst   <= '1';
        ctrl_ex.ALUSrc   <= '0';
        ctrl_ex.ALUOp    <= CORE_ALU_SLT;
        ctrl_wb.RegWrite <= '1';

      -- I-type ALU immediates
      when "0110" =>  -- addi
        ctrl_ex.RegDst   <= '0';
        ctrl_ex.ALUSrc   <= '1';
        ctrl_ex.ALUOp    <= CORE_ALU_ADD;
        ctrl_wb.RegWrite <= '1';
      when "0111" =>  -- andi
        ctrl_ex.RegDst   <= '0';
        ctrl_ex.ALUSrc   <= '1';
        ctrl_ex.ALUOp    <= CORE_ALU_AND;
        ctrl_wb.RegWrite <= '1';
      when "1000" =>  -- ori
        ctrl_ex.RegDst   <= '0';
        ctrl_ex.ALUSrc   <= '1';
        ctrl_ex.ALUOp    <= CORE_ALU_OR;
        ctrl_wb.RegWrite <= '1';
      when "1001" =>  -- xori
        ctrl_ex.RegDst   <= '0';
        ctrl_ex.ALUSrc   <= '1';
        ctrl_ex.ALUOp    <= CORE_ALU_XOR;
        ctrl_wb.RegWrite <= '1';
      when "1010" =>  -- slti
        ctrl_ex.RegDst   <= '0';
        ctrl_ex.ALUSrc   <= '1';
        ctrl_ex.ALUOp    <= CORE_ALU_SLT;
        ctrl_wb.RegWrite <= '1';

      -- loads/stores
      when "1011" =>  -- lw
        ctrl_ex.RegDst   <= '0';
        ctrl_ex.ALUSrc   <= '1';
        ctrl_ex.ALUOp    <= CORE_ALU_ADD;  -- address calc
        ctrl_mem.MemRead  <= '1';
        ctrl_wb.MemtoReg  <= '1';
        ctrl_wb.RegWrite  <= '1';
      when "1100" =>  -- sw
        ctrl_ex.RegDst   <= '0';
        ctrl_ex.ALUSrc   <= '1';
        ctrl_ex.ALUOp    <= CORE_ALU_ADD;  -- address calc
        ctrl_mem.MemWrite <= '1';

      -- branches
      when "1101" =>  -- beq
        ctrl_ex.RegDst   <= '0';
        ctrl_ex.ALUSrc   <= '0';
        ctrl_ex.ALUOp    <= CORE_ALU_SUB;  -- compare
        ctrl_mem.Branch   <= '1';
      when "1110" =>  -- bne
        ctrl_ex.RegDst   <= '0';
        ctrl_ex.ALUSrc   <= '0';
        ctrl_ex.ALUOp    <= CORE_ALU_SUB;  -- compare
        ctrl_mem.Branch   <= '1';

      -- jump
      when "1111" =>  -- j
        ctrl_mem.Jump     <= '1';

      when others =>
        null;
    end case;
  end process;
end architecture rtl;
