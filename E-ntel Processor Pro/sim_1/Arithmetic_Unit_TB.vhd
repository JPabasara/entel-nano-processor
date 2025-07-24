library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Arithmetic_Unit_TB is
end Arithmetic_Unit_TB;

architecture Behavioral of Arithmetic_Unit_TB is

    -- Component declaration
    component Arithmetic_Unit
        Port (
            RegSelA   : in  STD_LOGIC_VECTOR(2 downto 0);
            RegSelB   : in  STD_LOGIC_VECTOR(2 downto 0);
            R0, R1, R2, R3, R4, R5, R6, R7 : in STD_LOGIC_VECTOR(3 downto 0);
            Cin       : in  STD_LOGIC;
            Sum       : out STD_LOGIC_VECTOR(3 downto 0);
            Overflow  : out STD_LOGIC;
            Zero      : out STD_LOGIC
        );
    end component;

    -- Signal declarations
    signal RegSelA, RegSelB : STD_LOGIC_VECTOR(2 downto 0);
    signal R0 : STD_LOGIC_VECTOR(3 downto 0) := "0000";  -- R0 is always 0
    signal R1, R2, R3, R4, R5, R6, R7 : STD_LOGIC_VECTOR(3 downto 0);
    signal Cin       : STD_LOGIC;
    signal Sum       : STD_LOGIC_VECTOR(3 downto 0);
    signal Overflow  : STD_LOGIC;
    signal Zero      : STD_LOGIC;

begin

    -- Instantiate UUT
    UUT: Arithmetic_Unit
        port map (
            RegSelA  => RegSelA,
            RegSelB  => RegSelB,
            R0 => R0, R1 => R1, R2 => R2, R3 => R3,
            R4 => R4, R5 => R5, R6 => R6, R7 => R7,
            Cin      => Cin,
            Sum      => Sum,
            Overflow => Overflow,
            Zero     => Zero
        );

    -- Test process
    stimulus: process
    begin
         -- Initialize all
       RegSelA <= "000";
       RegSelB <= "000";
       R0 <= "0000";
       R1 <= "0000";
       R2 <= "0000";
       R3 <= "0000";
       R4 <= "0000";
       R5 <= "0000";
       R6 <= "0000";
       R7 <= "0000";
       Cin <= '0';
   
       --wait for 10 ns;
        -- Initialize registers (2's complement representation)
        R0 <= "0000";  -- Hardcoded to 0
        R1 <= "0010";  -- +2
        R2 <= "0011";  -- +3
        R3 <= "0100";  -- +4
        R4 <= "1011";  -- -5
        R5 <= "1100";  -- -4
        R6 <= "1111";  -- -1
        R7 <= "0111";  -- +7

        --wait for 100 ns;

        -- TEST CASES
        -- Format: RegSelA, RegSelB, Cin

        -- 1. -4 + 3 = -1
        RegSelA <= "010";  -- R2 = +3
        RegSelB <= "101";  -- R5 = -4
        Cin     <= '0';
        wait for 100 ns;

        -- 2. -2 + -7 = -9 (overflow)
        R6 <= "1110";  -- -2
        R5 <= "1001";  -- -7
        RegSelA <= "110";  -- R6 = -2
        RegSelB <= "101";  -- R5 = -7
        Cin     <= '0';
        wait for 100 ns;

        -- 3. 7 + 7 = 14 (overflow)
        RegSelA <= "111";  -- R7 = +7
        RegSelB <= "111";  -- R7 = +7
        Cin     <= '0';
        wait for 100 ns;

        -- 4. -1 + 1 = 0
        R6 <= "1111";  -- -1
        R1 <= "0001";  -- +1
        RegSelA <= "110";  -- R6 = -1
        RegSelB <= "001";  -- R1 = +1
        Cin     <= '0';
        wait for 100 ns;

        -- 5. 3 - 4 = -1 (B-A)
        RegSelA <= "011";  -- R3 = +4
        RegSelB <= "010";  -- R2 = +3
        Cin     <= '1';    -- Subtraction
        wait for 100 ns;

        -- 6. -4 - 4 = -8
        RegSelA <= "100";  -- R4 = -5 (change it below)
        R4 <= "1100";      -- -4
        R3 <= "0100";      -- +4
        RegSelB <= "011";  -- R3 = +4
        Cin     <= '1';
        wait for 100 ns;

        -- 7. -8 + 1 = -7
        R4 <= "1000";      -- -8
        R1 <= "0001";      -- +1
        RegSelA <= "100";  -- R4 = -8
        RegSelB <= "001";  -- R1 = +1
        Cin     <= '0';
        wait for 100 ns;

        -- 8. 7 - 0 = 7
        RegSelA <= "000";  -- R0 = 0
        RegSelB <= "111";  -- R7 = +7
        Cin     <= '1';
        wait for 100 ns;

        -- 9. -3 - (-5) = 2
        R4 <= "1011";      -- -5
        R5 <= "1101";      -- -3
        RegSelA <= "100";  -- R4 = -5
        RegSelB <= "101";  -- R5 = -3
        Cin     <= '1';
        wait for 100 ns;

        -- 10. -6 - (+2) = -8 (overflow)
        R1 <= "0010";      -- +2
        R5 <= "1010";      -- -6
        RegSelA <= "001";  -- R1 = +2
        RegSelB <= "101";  -- R5 = -6
        Cin     <= '1';
        wait for 100 ns;

        wait;
    end process;

end Behavioral;
