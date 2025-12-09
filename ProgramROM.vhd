----------------------------------------------------------------------------------
-- Company: E-ntel
-- Engineer: Pabasara H H J
-- 
-- Create Date: 05/13/2025 12:06:17 AM
-- Design Name: Program ROM
-- Module Name: ProgramROM - Behavioral
-- Project Name: E-ntel Nanoprocessor
-- Target Devices: BASYS 3
-- Tool Versions: 
-- Description: This contains 12 bit wide 8 memory slots to store the Program Instruction
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
use IEEE.NUMERIC_STD.ALL;

entity ProgramROM is
    Port (
        Address : in std_logic_vector(2 downto 0);
        Instruction : out std_logic_vector(11 downto 0)
    );
end ProgramROM;

architecture Behavioral of ProgramROM is
    type ROM_Array is array (0 to 7) of std_logic_vector(11 downto 0);
    
    -- Program to calculate sum of integers from 1 to 3 (result in R7)
    constant ROM_Data : ROM_Array := (
        "100010000001", -- MOVI R1, 1
        "100100000010", -- MOVI R2, 2
        "100110000011", -- MOVI R3, 3
        "000010100000", -- ADD R1, R2
        "000010110000", -- ADD R1, R3
        "010100000000", -- NEG R2
        "110110000010", -- JZR R3, 2 
        "111100000001"  -- JZR R5, 1
    );
begin
    Instruction <= ROM_Data(to_integer(unsigned(Address)));
end Behavioral;
