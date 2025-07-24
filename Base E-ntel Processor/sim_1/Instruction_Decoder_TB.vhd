library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Instruction_Decoder_TB is
end Instruction_Decoder_TB;

architecture Behavioral of Instruction_Decoder_TB is

    -- Component Declaration
    component Instruction_Decoder
        Port ( Instruction : in STD_LOGIC_VECTOR (11 downto 0);
               Zero_Flag : in STD_LOGIC;
               RegSelA : out STD_LOGIC_VECTOR (2 downto 0);
               RegSelB : out STD_LOGIC_VECTOR (2 downto 0);
               Reg_Enb : out STD_LOGIC_VECTOR (2 downto 0);
               Immediate : out STD_LOGIC_VECTOR (3 downto 0);
               Load_Sel : out STD_LOGIC;
               AddSub : out STD_LOGIC;
               JumpAddr : out STD_LOGIC_VECTOR (2 downto 0);
               Jump_Flag : out STD_LOGIC);
    end component;

    -- Signals for UUT
    signal Instruction : STD_LOGIC_VECTOR(11 downto 0);
    signal Zero_Flag : STD_LOGIC := '0';
    signal RegSelA, RegSelB, Reg_Enb : STD_LOGIC_VECTOR(2 downto 0);
    signal Immediate : STD_LOGIC_VECTOR(3 downto 0);
    signal Load_Sel, AddSub, Jump_Flag : STD_LOGIC;
    signal JumpAddr : STD_LOGIC_VECTOR(2 downto 0);

begin

    -- Instantiate the Unit Under Test (UUT)
    UUT: Instruction_Decoder
        port map (
            Instruction => Instruction,
            Zero_Flag => Zero_Flag,
            RegSelA => RegSelA,
            RegSelB => RegSelB,
            Reg_Enb => Reg_Enb,
            Immediate => Immediate,
            Load_Sel => Load_Sel,
            AddSub => AddSub,
            JumpAddr => JumpAddr,
            Jump_Flag => Jump_Flag
        );

    -- Test process
    stim_proc: process
    begin

        -- Test Case 1: MOVI R3, 9 ? 10_011_000_1001 = "100110001001"
        Instruction <= "100110001001";
        wait for 100 ns;

        -- Test Case 2: MOVI R7, 15 (-1 in two's compliment) ? 10_111_000_1111 = "101110001111"
        Instruction <= "101110001111";
        wait for 100 ns;

        -- Test Case 3: ADD R1, R2 ? 00_001_010_0000 = "000010100000"
        Instruction <= "000010100000";
        wait for 100 ns;

        -- Test Case 4: ADD R5, R6 ? 00_101_110_0000 = "001011100000"
        Instruction <= "001011100000";
        wait for 100 ns;

        -- Test Case 5: NEG R4 ? 01_100_000_0000 = "011000000000"
        Instruction <= "011000000000";
        wait for 100 ns;

        -- Test Case 6: NEG R0 ? 01_000_000_0000 = "010000000000"
        Instruction <= "010000000000";
        wait for 100 ns;

        -- Test Case 7: JZR R2, 4 ? 11_010_000_0100 = "110100000100"
        Instruction <= "110100000100";
        Zero_Flag <= '1';
        wait for 100 ns;

        -- Test Case 8: JZR R1, 7 ? 11_001_000_0111 = "110010000111"
        Instruction <= "110010000111";
        Zero_Flag <= '0';
        wait for 100 ns;

        -- Test Case 9: MOVI R0, 1 ? 10_000_000_0001 = "100000000001"
        Instruction <= "100000000001";
        wait for 100 ns;

        -- Test Case 10: ADD R3, R1 ? 00_011_001_0000 = "000110010000"
        Instruction <= "000110010000";
        wait for 100 ns;

        wait;
    end process;

end Behavioral;
