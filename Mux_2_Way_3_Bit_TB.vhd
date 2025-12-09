----------------------------------------------------------------------------------
-- Company: E-ntel
-- Engineer: Pabasara H H J
-- 
-- Create Date: 05/12/2025 02:32:17 PM
-- Design Name: 2 Way 3 Bit Multiplexer
-- Module Name: Mux_2_Way_3_Bit - Behavioral
-- Project Name: E-ntel Nanoprocessor
-- Target Devices: BASYS 3
-- Tool Versions: 
-- Description: Selects between two 3-bit inputs using logic gates
-- 
-- Dependencies: None
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux_2_Way_3_Bit is
    Port (
        A      : in  STD_LOGIC_VECTOR(2 downto 0);
        B      : in  STD_LOGIC_VECTOR(2 downto 0);
        Sel    : in  STD_LOGIC;
        Output : out STD_LOGIC_VECTOR(2 downto 0)
    );
end Mux_2_Way_3_Bit;

architecture Behavioral of Mux_2_Way_3_Bit is
    signal SEL_A : STD_LOGIC_VECTOR(2 downto 0);
    signal SEL_B : STD_LOGIC_VECTOR(2 downto 0);
    signal NOT_SEL : STD_LOGIC;
begin
    NOT_SEL <= NOT Sel;

    SEL_A(0) <= A(0) AND Sel;
    SEL_A(1) <= A(1) AND Sel;
    SEL_A(2) <= A(2) AND Sel;

    SEL_B(0) <= B(0) AND NOT_SEL;
    SEL_B(1) <= B(1) AND NOT_SEL;
    SEL_B(2) <= B(2) AND NOT_SEL;

    Output(0) <= SEL_A(0) OR SEL_B(0);
    Output(1) <= SEL_A(1) OR SEL_B(1);
    Output(2) <= SEL_A(2) OR SEL_B(2);

end Behavioral;
