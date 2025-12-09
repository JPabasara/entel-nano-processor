----------------------------------------------------------------------------------
-- Company: E-ntel
-- Engineer: Pabasara H H J
-- 
-- Create Date: 05/12/2025 11:56:42 AM
-- Design Name: 8 way 4 bit Multiplexer
-- Module Name: Mux_8_Way_4_Bit - Behavioral
-- Project Name: E-ntel Nanoprocessor
-- Target Devices: BASYS 3
-- Tool Versions: 
-- Description: Each data line consists of 4 bit buses
-- All together there are 8 4 bit busses
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

entity Mux_8_Way_4_Bit is
    Port (
        R0, R1, R2, R3, R4, R5, R6, R7 : in STD_LOGIC_VECTOR(3 downto 0);
        RegSel    : in STD_LOGIC_VECTOR(2 downto 0);
        Data_Out  : out STD_LOGIC_VECTOR(3 downto 0)
    );
end Mux_8_Way_4_Bit;

architecture Behavioral of Mux_8_Way_4_Bit is

    -- Component declaration for the 3-to-8 decoder
    component Decoder_3_to_8_No_Enb
        Port (
            I : in STD_LOGIC_VECTOR (2 downto 0);
            Y : out STD_LOGIC_VECTOR (7 downto 0)
        );
    end component;

    -- Internal signal to hold the output of the decoder
    signal internal_decoder_out : STD_LOGIC_VECTOR(7 downto 0);

begin

    -- Instantiate the decoder
    Decoder_Internal: Decoder_3_to_8_No_Enb
        port map (
            I => RegSel,
            Y => internal_decoder_out
        );

    -- Multiplexer logic using the decoder's 1-hot output
Data_Out <=
        (R0 and (3 downto 0 => internal_decoder_out(0))) or
        (R1 and (3 downto 0 => internal_decoder_out(1))) or
        (R2 and (3 downto 0 => internal_decoder_out(2))) or
        (R3 and (3 downto 0 => internal_decoder_out(3))) or
        (R4 and (3 downto 0 => internal_decoder_out(4))) or
        (R5 and (3 downto 0 => internal_decoder_out(5))) or
        (R6 and (3 downto 0 => internal_decoder_out(6))) or
        (R7 and (3 downto 0 => internal_decoder_out(7)));


end Behavioral;
