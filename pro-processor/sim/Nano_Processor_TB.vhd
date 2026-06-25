library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Nano_Processor_TB is
end Nano_Processor_TB;

architecture Behavioral of Nano_Processor_TB is

    -- Component under test
    component Nano_Processor
        Port ( 
            Clk            : in  STD_LOGIC;
            Reset          : in  STD_LOGIC;
            Zero_Flag      : out  STD_LOGIC;
            Overflow_Flag  : out  STD_LOGIC;
            Jump_Flag      : out  STD_LOGIC;
            ALU_Output, 
            R7_Out         : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

    -- Signals to connect to UUT
    signal Clk           : STD_LOGIC := '0';
    signal Reset         : STD_LOGIC := '1';
    signal Zero_Flag     : STD_LOGIC := '0';
    signal Overflow_Flag : STD_LOGIC := '0';
    signal Jump_Flag     : STD_LOGIC := '0';
    signal ALU_Output, R7_Out : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');

begin

    -- Instantiate UUT
    UUT: Nano_Processor port map (
        Clk => Clk,
        Reset => Reset,
        Zero_Flag => Zero_Flag,
        Overflow_Flag => Overflow_Flag,
        Jump_Flag => Jump_Flag,
        R7_Out => R7_Out,
        ALU_Output => ALU_Output
    );

    -- Clock process: 100 MHz (10 ns period)
    Clock_Process : process
    begin
        loop
            Clk <= '1';
            wait for 10 ns;
            Clk <= '0';
            wait for 10 ns;
        end loop;
    end process;

    -- Reset and simulation control process
    Stim_Proc: process
    begin
        -- Hold reset active for proper initialization
        Reset <= '1';
        wait for 50 ns;
        Reset <= '0';

        -- Allow processor to run
        wait for 500 ns;

        -- End simulation
        wait;
    end process;

end Behavioral;
