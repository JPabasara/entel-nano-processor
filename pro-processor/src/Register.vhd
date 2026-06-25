library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Reg is
    Port (
        D     : in STD_LOGIC_VECTOR (3 downto 0);
        En    : in STD_LOGIC;
        Clk   : in STD_LOGIC;
        Reset : in STD_LOGIC;
        Q     : out STD_LOGIC_VECTOR (3 downto 0)
    );
end Reg;

architecture Behavioral of Reg is
begin

    process (Clk)
    begin
        if rising_edge(Clk) then
            if Reset = '1' then
                Q <= (others => '0'); -- Reset all bits to 0
            elsif En = '1' then       -- Enable is active high
                Q <= D;
            end if;
        end if;
    end process;

end Behavioral;