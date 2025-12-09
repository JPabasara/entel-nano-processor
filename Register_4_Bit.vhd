----------------------------------------------------------------------------------
-- Company: E-ntel
-- Engineer: Pabasara H H J
-- 
-- Create Date: 05/12/2025 12:24:09 AM
-- Design Name: General Purpose Register
-- Module Name: Decoder_3_to_8_No_Enb - Behavioral
-- Project Name: E-ntel Nanoprocessor
-- Target Devices: BASYS 3
-- Tool Versions: 
-- Description: 
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

entity Register_4_Bit is
    Port (
        D     : in STD_LOGIC_VECTOR (3 downto 0);
        En    : in STD_LOGIC;
        Clk   : in STD_LOGIC;
        Reset : in STD_LOGIC;
        Q     : out STD_LOGIC_VECTOR (3 downto 0)
    );
end Register_4_Bit;

architecture Behavioral of Register_4_Bit is
begin

    process (Clk)
    begin
        if rising_edge(Clk) then
            if Reset = '1' then
                Q <= (others => '0'); -- Reset all bits to 0
            elsif En = '1' then       -- Enable is active high
                Q <= D;
            end if;
        end if;
    end process;

end Behavioral;

