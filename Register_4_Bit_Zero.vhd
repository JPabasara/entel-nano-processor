----------------------------------------------------------------------------------
-- Company: E-ntel
-- Engineer: Pabasara H H J
-- 
-- Create Date: 05/12/2025 10:07:53 AM
-- Design Name: Register_0 
-- Module Name: Register_4_Bit_Zero - Behavioral
-- Project Name: E-ntel Nanoprocessor
-- Target Devices: BASYS 3
-- Tool Versions: 
-- Description: All 4 bits are hardcoded to zero. Therefore Read only Register
--              No Enable signal or Data Input or Reset
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


entity Register_4_Bit_Zero is
    Port ( Clk : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (3 downto 0));
end Register_4_Bit_Zero;

architecture Behavioral of Register_4_Bit_Zero is
begin

    process (Clk)
    begin
        if rising_edge(Clk) then   -- Synchronized with Clk input
            Q <= (others => '0');  -- Assign all bits of vector Q to Zero
        end if;
    end process;

end Behavioral;