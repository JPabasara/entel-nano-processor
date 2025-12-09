----------------------------------------------------------------------------------
-- Company: CSE UOM
-- Engineer: 230451M
-- 
-- Create Date: 03/18/2025 11:46:31 PM
-- Design Name: Lab 6
-- Module Name: Slow_Clk - Behavioral
-- Project Name: Counter
-- Target Devices: Basys 3
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Slow_Clk is
    Port ( Clk_in : in STD_LOGIC;
           Clk_out : out STD_LOGIC);
end Slow_Clk;

architecture Behavioral of Slow_Clk is

SIGNAL count : integer :=1;
SIGNAL Clk_status : STD_LOGIC :='0';

begin
    process (Clk_in) begin
    if (rising_edge(Clk_in)) then
        count <= count +1 ;
        if (count = 100000000) then
            Clk_status <= NOT (Clk_status);
            Clk_out <= Clk_status ;
            count <= 1;
        end if;
    end if;
    end process;
end Behavioral;
