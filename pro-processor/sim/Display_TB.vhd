library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Display_TB is
end Display_TB;

architecture Behavioral of Display_TB is

    -- Component Declaration
    component Display
        Port (
            clk : in STD_LOGIC;
            digit0 : in STD_LOGIC_VECTOR(3 downto 0);
            digit2 : in STD_LOGIC_VECTOR(2 downto 0);
            digit3 : in STD_LOGIC_VECTOR(2 downto 0);
            an : out STD_LOGIC_VECTOR(3 downto 0);
            seg : out STD_LOGIC_VECTOR(6 downto 0)
        );
    end component;

    -- Signals for test
    signal clk_tb     : std_logic := '0';
    signal digit0_tb  : std_logic_vector(3 downto 0);
    signal digit2_tb  : std_logic_vector(2 downto 0) := (others => '0');
    signal digit3_tb  : std_logic_vector(2 downto 0) := (others => '0');
    signal an_tb      : std_logic_vector(3 downto 0);
    signal seg_tb     : std_logic_vector(6 downto 0);

    -- Clock period constant
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the UUT
    UUT: Display
        port map (
            clk     => clk_tb,
            digit0  => digit0_tb,
            digit2  => digit2_tb,
            digit3  => digit3_tb,
            an      => an_tb,
            seg     => seg_tb
        );

    -- Clock generation
    clk_process : process
    begin
        while true loop
            clk_tb <= '0';
            wait for clk_period / 2;
            clk_tb <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Case 1
        digit0_tb <= "1101"; -- -3 in 2's complement
        digit2_tb <= "110";
        digit3_tb <= "001"; 
        
        wait for 200 ns;

        -- Case 2
        digit0_tb <= "0111"; 
        digit2_tb <= "010";
        digit3_tb <= "011"; 
        
        wait for 200 ns;
        
        -- Case 3
        digit0_tb <= "0011"; 
        digit2_tb <= "111";
        digit3_tb <= "111"; 
        wait;

    
        wait;
    end process;

end Behavioral;
