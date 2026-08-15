library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Slow_Clk is
    Port (
        Clk_in  : in  STD_LOGIC;
        Clk_out : out STD_LOGIC
    );
end Slow_Clk;

architecture Behavioral of Slow_Clk is
    signal count : unsigned(25 downto 0) := (others => '0');  -- 26-bit counter

begin

   process (Clk_in)
   begin
       if rising_edge(Clk_in) then
           count <= count + 1;
       end if;
   end process;

   -- Use bit 25 as output (toggles every ~33.5 million ticks = ~0.67s period)
   Clk_out <= count(25);  -- ~1.49 Hz square wave

end Behavioral;