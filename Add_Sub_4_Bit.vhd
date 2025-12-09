----------------------------------------------------------------------------------
-- Company: E-ntel
-- Engineer: Pabasara H H J
-- 
-- Create Date: 05/12/2025 12:21:13 PM
-- Design Name: Adder and Subtractor
-- Module Name: Add_Sub_4_Bit - Behavioral
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

entity Add_Sub_4_Bit is
    Port (
        A        : in  STD_LOGIC_VECTOR(3 downto 0);
        B        : in  STD_LOGIC_VECTOR(3 downto 0);
        Cin      : in  STD_LOGIC;  -- 0 = Add (B+A), 1 = Sub (B-A)
        Sum      : out STD_LOGIC_VECTOR(3 downto 0);
        Overflow : out STD_LOGIC;
        Zero     : out STD_LOGIC
    );
end Add_Sub_4_Bit;

architecture Behavioral of Add_Sub_4_Bit is

    component RCA_4
        Port (
            A    : in  STD_LOGIC_VECTOR(3 downto 0);
            B    : in  STD_LOGIC_VECTOR(3 downto 0);
            Cin  : in  STD_LOGIC;
            Sum  : out STD_LOGIC_VECTOR(3 downto 0);
            Cout : out STD_LOGIC
        );
    end component;

    -- Internal signals
    signal A_xor : STD_LOGIC_VECTOR(3 downto 0);
    signal S_temp : STD_LOGIC_VECTOR(3 downto 0);
    signal Cout   : STD_LOGIC;

    -- Zero flag logic signals
    signal Zero_temp : STD_LOGIC;

begin

    -- XOR each bit of A with Cin
    A_xor(0) <= A(0) XOR Cin;
    A_xor(1) <= A(1) XOR Cin;
    A_xor(2) <= A(2) XOR Cin;
    A_xor(3) <= A(3) XOR Cin;

    -- Instantiate the 4-bit RCA
    RCA: RCA_4
        port map (
            A    => B,
            B    => A_xor,
            Cin  => Cin,
            Sum  => S_temp,
            Cout => Cout
        );

    -- Output sum
    Sum <= S_temp;

    -- Overflow directly from Cout (simple unsigned overflow)
    Overflow <= Cout;

    -- Zero flag using logic gates
    Zero_temp <= S_temp(0) or S_temp(1) or S_temp(2) or S_temp(3);
    Zero <= not Zero_temp; -- Inverted ouput 1 for Zero flag

end Behavioral;
