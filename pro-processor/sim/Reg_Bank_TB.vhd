library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Reg_Bank_TB is
end Reg_Bank_TB;

architecture Behavioral of Reg_Bank_TB is

    -- Component Declaration
    component Reg_Bank
        Port (
            Clk        : in STD_LOGIC;
            Reset      : in STD_LOGIC;
            Reg_Select : in STD_LOGIC_VECTOR (2 downto 0);
            Data_In    : in STD_LOGIC_VECTOR (3 downto 0);
            R0         : out STD_LOGIC_VECTOR (3 downto 0);
            R1         : out STD_LOGIC_VECTOR (3 downto 0);
            R2         : out STD_LOGIC_VECTOR (3 downto 0);
            R3         : out STD_LOGIC_VECTOR (3 downto 0);
            R4         : out STD_LOGIC_VECTOR (3 downto 0);
            R5         : out STD_LOGIC_VECTOR (3 downto 0);
            R6         : out STD_LOGIC_VECTOR (3 downto 0);
            R7         : out STD_LOGIC_VECTOR (3 downto 0)
        );
    end component;

    -- Signals
    signal Clk        : STD_LOGIC := '0';
    signal Reset      : STD_LOGIC := '0';
    signal Reg_Select : STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
    signal Data_In    : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
    signal R0, R1, R2, R3, R4, R5, R6, R7 : STD_LOGIC_VECTOR (3 downto 0);

    constant CLK_PERIOD : time := 100 ns;

begin

    -- Clock generation
    Clk_process : process
    begin
        Clk <= '0';
        wait for CLK_PERIOD/2;
        Clk <= '1';
        wait for CLK_PERIOD/2;
    end process;

    -- UUT instantiation
    UUT: Reg_Bank
        port map (
            Clk => Clk,
            Reset => Reset,
            Reg_Select => Reg_Select,
            Data_In => Data_In,
            R0 => R0,
            R1 => R1,
            R2 => R2,
            R3 => R3,
            R4 => R4,
            R5 => R5,
            R6 => R6,
            R7 => R7
        );

    -- Stimulus process
    stim_proc: process
    begin
        -- Test 1: Reset all
        Reset <= '1';
        wait for CLK_PERIOD;
        Reset <= '0';
        wait for CLK_PERIOD;

        -- Test 2: Write 0101 to Register 1
        Reg_Select <= "001"; Data_In <= "0101";
        wait for CLK_PERIOD;

        -- Test 3: Write 1010 to Register 2
        Reg_Select <= "010"; Data_In <= "1010";
        wait for CLK_PERIOD;

        -- Test 4: Write 1111 to Register 3
        Reg_Select <= "011"; Data_In <= "1111";
        wait for CLK_PERIOD;

        -- Test 5: Write 0001 to Register 4
        Reg_Select <= "100"; Data_In <= "0001";
        wait for CLK_PERIOD;

        -- Test 6: Write 0010 to Register 5
        Reg_Select <= "101"; Data_In <= "0010";
        wait for CLK_PERIOD;

        -- Test 7: Write 0011 to Register 6
        Reg_Select <= "110"; Data_In <= "0011";
        wait for CLK_PERIOD;

        -- Test 8: Write 0100 to Register 7
        Reg_Select <= "111"; Data_In <= "0100";
        wait for CLK_PERIOD;

        -- Test 9: Attempt to write to R0 (should not change)
        Reg_Select <= "000"; Data_In <= "1111";
        wait for CLK_PERIOD;

        -- Test 10: Reset again
        Reset <= '1';
        wait for CLK_PERIOD;
        Reset <= '0';
        wait for CLK_PERIOD;

        -- End simulation
        wait;
    end process;

end Behavioral;
