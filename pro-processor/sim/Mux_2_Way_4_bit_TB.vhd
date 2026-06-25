library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux_2_Way_4_bit_TB is
end Mux_2_Way_4_bit_TB;

architecture Behavioral of Mux_2_Way_4_bit_TB is

    -- Component declaration
    component Mux_2_Way_4_bit
        Port (
            A      : in  STD_LOGIC_VECTOR(3 downto 0);
            B      : in  STD_LOGIC_VECTOR(3 downto 0);
            Sel    : in  STD_LOGIC;
            Output : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

    -- Testbench signals
    signal A_tb, B_tb, Output_tb : STD_LOGIC_VECTOR(3 downto 0);
    signal Sel_tb : STD_LOGIC;

begin

    -- Instantiate the Unit Under Test (UUT)
    UUT: Mux_2_Way_4_bit
        port map (
            A      => A_tb,
            B      => B_tb,
            Sel    => Sel_tb,
            Output => Output_tb
        );

    -- Stimulus process
    process
    begin
        -- Test 1: A = "0001", B = "1110", Sel = 0 => Output = B
        A_tb <= "0001";
        B_tb <= "1110";
        Sel_tb <= '0';
        wait for 100 ns;

        -- Test 2: A = "0001", B = "1110", Sel = 1 => Output = A
        Sel_tb <= '1';
        wait for 100 ns;

        -- Test 3: A = "1010", B = "0101", Sel = 1 => Output = A
        A_tb <= "1010";
        B_tb <= "0101";
        Sel_tb <= '1';
        wait for 100 ns;

        -- Test 4: A = "1010", B = "0101", Sel = 0 => Output = B
        Sel_tb <= '0';
        wait for 100 ns;

        -- Test 5: A = "1111", B = "0000", Sel = 1 => Output = A
        A_tb <= "1111";
        B_tb <= "0000";
        Sel_tb <= '1';
        wait for 100 ns;

        -- Finish simulation
        wait;
    end process;

end Behavioral;
