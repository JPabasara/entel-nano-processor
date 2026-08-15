library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Slow_Clk_TB is
end Slow_Clk_TB;

architecture sim of Slow_Clk_TB is

    -- Component Declaration for the UUT
    component Slow_Clk
        Port (
            Clk_in  : in  STD_LOGIC;
            Clk_out : out STD_LOGIC
        );
    end component;

    -- Testbench signals
    signal TB_Clk_in  : STD_LOGIC := '0';
    signal TB_Clk_out : STD_LOGIC;

    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    UUT: Slow_Clk
        port map (
            Clk_in  => TB_Clk_in,
            Clk_out => TB_Clk_out
        );

    -- Generate 100 MHz clock
    clk_gen : process
    begin
        while now < 2 us loop  -- Shortened for simulation speed
            TB_Clk_in <= '0';
            wait for CLK_PERIOD / 2;
            TB_Clk_in <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

end sim;
