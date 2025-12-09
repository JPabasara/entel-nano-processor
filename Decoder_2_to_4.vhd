----------------------------------------------------------------------------------
-- Company: E-ntel
-- Engineer: Pabasara H H J
-- 
-- Create Date: 05/12/2025 12:02:26 AM
-- Design Name: 2 to 4 Decoder with Enable
-- Module Name: Decoder_2_to_4 - Behavioral
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


entity Decoder_2_to_4 is
    Port ( I : in STD_LOGIC_VECTOR (1 downto 0);
           EN : in STD_LOGIC;
           Y : out STD_LOGIC_VECTOR (3 downto 0));
end Decoder_2_to_4;

architecture Behavioral of Decoder_2_to_4 is
signal I0_bar : std_logic;
signal I1_bar : std_logic;

begin

I0_bar <= NOT I(0);
I1_bar <= NOT I(1);
Y(0) <= EN AND I1_bar AND I0_bar;
Y(1) <= EN AND I1_bar AND I(0);
Y(2) <= EN AND I(1) AND I0_bar;
Y(3) <= EN AND I(1) AND I(0);

end Behavioral;
