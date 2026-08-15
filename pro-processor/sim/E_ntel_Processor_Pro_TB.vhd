library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity E_ntel_Processor_Pro_TB is
end E_ntel_Processor_Pro_TB;

architecture Behavioral of E_ntel_Processor_Pro_TB is

    -- Component Declaration
    component E_ntel_Processor_Pro
        Port (
            Clk      : in  STD_LOGIC;
            Reset    : in  STD_LOGIC;
            Zero     : out STD_LOGIC;
            OverFlow : out STD_LOGIC;
            Jump     : out STD_LOGIC;
            SW       : in  STD_LOGIC;
            Value_Out : out STD_LOGIC_VECTOR(3 downto 0);
            AN       : out STD_LOGIC_VECTOR(3 downto 0);
            SEG      : out STD_LOGIC_VECTOR(6 downto 0)
        );
    end component;

    -- Signals for Testbench
    signal Clk_tb      : STD_LOGIC := '0';
    signal Reset_tb    : STD_LOGIC := '0';
    signal Zero_tb     : STD_LOGIC;
    signal OverFlow_tb : STD_LOGIC;
    signal Jump_tb     : STD_LOGIC;
    signal SW_tb       : STD_LOGIC;
    signal Value_tb       : STD_LOGIC_VECTOR(3 downto 0);
    signal AN_tb       : STD_LOGIC_VECTOR(3 downto 0);
    signal SEG_tb      : STD_LOGIC_VECTOR(6 downto 0);

begin

    -- Instantiate Unit Under Test (UUT)
    UUT: E_ntel_Processor_Pro
        port map (
            Clk      => Clk_tb,
            Reset    => Reset_tb,
            Zero     => Zero_tb,
            OverFlow => OverFlow_tb,
            Jump     => Jump_tb,
            SW       => SW_tb,
            Value_Out => Value_tb,
            AN       => AN_tb,
            SEG      => SEG_tb
        );

    -- Clock Process: 10 ns period (100 MHz)
    clk_process : process
    begin
        while true loop
            Clk_tb <= '1';
            wait for 10 ns;
            Clk_tb <= '0';
            wait for 10 ns;
        end loop;
    end process;

    -- Stimulus Process
    stim_proc: process
    begin
    
        SW_tb <= '0';
        
        -- Initial Reset
        Reset_tb <= '1';
        wait for  20 ns;
        Reset_tb <= '0';

        -- Test Mux select = 0 (ALU Output)
        
        wait for 100 ns;

        -- Test Mux select = 1 (R7 Output)
        SW_tb <= '1';
        wait for 100 ns;

        -- Toggle back to ALU
        SW_tb <= '0';
        wait for 100 ns;

        -- Simulation end (or continue with more tests)
        wait;
    end process;

end Behavioral;