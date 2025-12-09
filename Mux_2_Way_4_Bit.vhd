----------------------------------------------------------------------------------
-- Company: E-ntel
-- Engineer: Pabasara H H J
-- 
-- Create Date: 05/12/2025 02:12:36 PM
-- Design Name: 2 Way 4 Bit Multiplexer
-- Module Name: Mux_2_Way_4_Bit - Behavioral
-- Project Name: E-ntel Nanoprocessor
-- Target Devices: BASYS 3
-- Tool Versions: 
-- Description: Used To Select between Immediate value or Sum from AU
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

entity Mux_2_Way_4_Bit is
    Port (
        A      : in  STD_LOGIC_VECTOR(3 downto 0);
        B      : in  STD_LOGIC_VECTOR(3 downto 0);
        Sel    : in  STD_LOGIC;
        Output : out STD_LOGIC_VECTOR(3 downto 0)
    );
end Mux_2_Way_4_Bit;

architecture Behavioral of Mux_2_Way_4_Bit is
    signal Sel_A : STD_LOGIC_VECTOR(3 downto 0);
    signal Sel_B : STD_LOGIC_VECTOR(3 downto 0);
    signal Not_Sel : STD_LOGIC;
begin
    Not_Sel <= not Sel;

    Sel_A(0) <= A(0) and Sel;
    Sel_A(1) <= A(1) and Sel;
    Sel_A(2) <= A(2) and Sel;
    Sel_A(3) <= A(3) and Sel;

    Sel_B(0) <= B(0) and Not_Sel;
    Sel_B(1) <= B(1) and Not_Sel;
    Sel_B(2) <= B(2) and Not_Sel;
    Sel_B(3) <= B(3) and Not_Sel;

    Output(0) <= Sel_A(0) or Sel_B(0);
    Output(1) <= Sel_A(1) or Sel_B(1);
    Output(2) <= Sel_A(2) or Sel_B(2);
    Output(3) <= Sel_A(3) or Sel_B(3);
    
end Behavioral;
