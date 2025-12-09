----------------------------------------------------------------------------------
-- Company: E-ntel
-- Engineer: Pabasara H H J
-- 
-- Create Date: 05/12/2025 12:06:34 AM
-- Design Name: 3 to 8 decoderwith no enable
-- Module Name: Decoder_3_to_8_No_Enb - Behavioral
-- Project Name: E-ntel Nanoprocessor
-- Target Devices: BASYS 3
-- Tool Versions: 
-- Description: This decoder has no enable input
--  This is build using 2 2 to 4 decoders
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

entity Decoder_3_to_8_No_Enb is
    Port (
        I : in STD_LOGIC_VECTOR (2 downto 0); -- I(2) = MSB
        Y : out STD_LOGIC_VECTOR (7 downto 0)
    );
end Decoder_3_to_8_No_Enb;

architecture Behavioral of Decoder_3_to_8_No_Enb is

    -- Component declaration of the existing 2-to-4 decoder with EN
    component Decoder_2_to_4
        Port (
            I : in STD_LOGIC_VECTOR (1 downto 0);
            EN : in STD_LOGIC;
            Y : out STD_LOGIC_VECTOR (3 downto 0)
        );
    end component;

    -- Internal signals for connecting the two decoders
    signal Y_lower : STD_LOGIC_VECTOR(3 downto 0);
    signal Y_upper : STD_LOGIC_VECTOR(3 downto 0);
    signal I2_bar  : STD_LOGIC;

begin

    -- Invert MSB to enable lower decoder when A2 = 0
    I2_bar <= NOT I(2);

    -- Lower half decoder: A2 = 0 ? enable this
    Decoder_Low: Decoder_2_to_4
        port map (
            I => I(1 downto 0),
            EN => I2_bar,
            Y => Y_lower
        );

    -- Upper half decoder: A2 = 1 ? enable this
    Decoder_High: Decoder_2_to_4
        port map (
            I => I(1 downto 0),
            EN => I(2),
            Y => Y_upper
        );

    -- Combine outputs
    Y(3 downto 0) <= Y_lower;
    Y(7 downto 4) <= Y_upper;

end Behavioral;
