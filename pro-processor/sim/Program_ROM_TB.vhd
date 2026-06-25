library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Program_ROM_TB is
end Program_ROM_TB;

architecture Behavioral of Program_ROM_TB is

    -- Component Declaration
    component Program_ROM
        Port (
            Address     : in  std_logic_vector(2 downto 0);
            Instruction : out std_logic_vector(11 downto 0)
        );
    end component;

    -- Signal Declarations
    signal Address     : std_logic_vector(2 downto 0) := (others => '0');
    signal Instruction : std_logic_vector(11 downto 0);

begin

    -- Instantiate UUT
    UUT: Program_ROM
        port map (
            Address     => Address,
            Instruction => Instruction
        );

    -- Test Process
    stim_proc: process
    begin
        -- Loop through all 8 addresses (0 to 7)
        for i in 0 to 7 loop
            Address <= std_logic_vector(to_unsigned(i, 3));
            wait for 100 ns;
        end loop;

        wait;
    end process;

end Behavioral;
