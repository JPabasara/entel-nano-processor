----------------------------------------------------------------------------------
-- Company: E-ntel
-- Engineer: Pabasara H H J
-- 
-- Create Date: 05/12/2025 02:46:14 PM
-- Design Name: 3 Bit Ripple Carry Adder
-- Module Name: RCA_3 - Behavioral
-- Project Name: E-ntel Nanoprocessor
-- Target Devices: BASYS 3
-- Tool Versions: 
-- Description: 3-bit Ripple Carry Adder using Full Adders, Cin = 0, Cout = Overflow
-- 
-- Dependencies: FA.vhd (Full Adder component)
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RCA_3 is
    Port (
        A      : in  STD_LOGIC_VECTOR(2 downto 0);
        B      : in  STD_LOGIC_VECTOR(2 downto 0);
        Sum    : out STD_LOGIC_VECTOR(2 downto 0);
        Cout   : out STD_LOGIC  -- Overflow
    );
end RCA_3;

architecture Behavioral of RCA_3 is

    component FA
        Port (
            A      : in  STD_LOGIC;
            B      : in  STD_LOGIC;
            C_in   : in  STD_LOGIC;
            S      : out STD_LOGIC;
            C_out  : out STD_LOGIC
        );
    end component;

    signal C0, C1 : STD_LOGIC;

begin

    FA_0 : FA
        port map (
            A     => A(0),
            B     => B(0),
            C_in  => '0', --Hardwired to Zero since we aim to Add only
            S     => Sum(0),
            C_out => C0
        );

    FA_1 : FA
        port map (
            A     => A(1),
            B     => B(1),
            C_in  => C0,
            S     => Sum(1),
            C_out => C1
        );

    FA_2 : FA
        port map (
            A     => A(2),
            B     => B(2),
            C_in  => C1,
            S     => Sum(2),
            C_out => Cout
        );

end Behavioral;
