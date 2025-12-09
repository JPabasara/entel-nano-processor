----------------------------------------------------------------------------------
-- Company: E-ntel
-- Engineer: Pabasara H H J
-- 
-- Create Date: 05/12/2025 02:57:51 PM
-- Design Name: 3 Bit Program Counter
-- Module Name: ProgramCounter - Behavioral
-- Project Name: E-ntel Nanoprocessor
-- Target Devices: BASYS 3
-- Tool Versions: 
-- Description: Program Counter keeps track of current instruction memory address
--              and next instruction memory address
--              Reset button will rest to 0 memory address
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ProgramCounter is
    Port (
        Clk : in std_logic;
        Reset : in std_logic;
        PC_in : in std_logic_vector(2 downto 0);
        PC_out : out std_logic_vector(2 downto 0)
    );
end ProgramCounter;

architecture Behavioral of ProgramCounter is
begin
    process(Clk, Reset)
    begin
        if Reset = '1' then
            PC_out <= "000";
        elsif rising_edge(Clk) then
            PC_out <= PC_in;
        end if;
    end process;
    
end Behavioral;