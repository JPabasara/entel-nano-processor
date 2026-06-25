library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Reg_Zero is
    Port ( 
        -- Clock input
        Clk : in STD_LOGIC;
        
        -- 4-bit zero output (always outputs "0000")
        Q : out STD_LOGIC_VECTOR (3 downto 0)
    );
end Reg_Zero;

architecture Behavioral of Reg_Zero is
begin

    -- Clocked process that maintains zero output
    process (Clk)
    begin
        -- On every rising clock edge
        if rising_edge(Clk) then
            -- Output constant zero value (4-bit vector)
            Q <= (others => '0');
        end if;
    end process;

end Behavioral;