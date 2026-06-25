library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PC_Increment_Unit_TB is
end PC_Increment_Unit_TB;

architecture Behavioral of PC_Increment_Unit_TB is

    -- Component Declaration
    component PC_Increment_Unit
        Port (
            Clk        : in STD_LOGIC;
            Reset      : in STD_LOGIC;
            JumpAddr   : in STD_LOGIC_VECTOR (2 downto 0);
            Jump_Flag  : in STD_LOGIC;
            MemorySel  : out STD_LOGIC_VECTOR (2 downto 0);
            Next_Add   : out STD_LOGIC_VECTOR(2 downto 0)
        );
    end component;

    -- Signals
    signal Clk        : STD_LOGIC := '0';
    signal Reset      : STD_LOGIC := '0';
    signal JumpAddr   : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
    signal Jump_Flag  : STD_LOGIC := '0';
    signal MemorySel  : STD_LOGIC_VECTOR(2 downto 0);
    signal Next_Add   : STD_LOGIC_VECTOR(2 downto 0);

    -- Clock period
    constant CLK_PERIOD : time := 200 ns;

begin

    -- Instantiate Unit Under Test (UUT)
    UUT: PC_Increment_Unit
        Port map (
            Clk        => Clk,
            Reset      => Reset,
            JumpAddr   => JumpAddr,
            Jump_Flag  => Jump_Flag,
            MemorySel  => MemorySel,
            Next_Add   => Next_Add
        );

    -- Clock generation
    Clk_Process : process
    begin
        while true loop
            Clk <= '0';
            wait for CLK_PERIOD / 2;
            Clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    -- Stimulus process
    Stim_Proc: process
    begin
        -- Test Case 01: Apply reset
        Reset <= '1';
        wait for CLK_PERIOD;
        Reset <= '0';

        -- Test Case 02: PC should increment to 001
        wait for CLK_PERIOD;

        -- Test Case 03: PC should increment to 010
        wait for CLK_PERIOD;

        -- Test Case 04: Jump to 101
        JumpAddr <= "101";
        Jump_Flag <= '1';
        wait for CLK_PERIOD;

        -- Test Case 05: PC should increment to 110
        Jump_Flag <= '0';
        wait for CLK_PERIOD;

        -- Test Case 06: Jump to 011
        JumpAddr <= "011";
        Jump_Flag <= '1';
        wait for CLK_PERIOD;

        -- Test Case 07: Apply reset again
        Jump_Flag <= '0';
        Reset <= '1';
        wait for CLK_PERIOD;
        Reset <= '0';

        -- Test Case 08: PC should increment to 001
        wait for CLK_PERIOD;

        -- Test Case 09: PC should increment to 010
        wait for CLK_PERIOD;

        -- Test Case 10: PC should increment to 011
        wait for CLK_PERIOD;

        wait;  -- Stop simulation
    end process;

end Behavioral;
