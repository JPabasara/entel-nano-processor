library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Program_Counter is
    Port (
        Clk    : in  std_logic;                      -- Clock signal
        Reset  : in  std_logic;                      -- Asynchronous reset, active high
        PC_in  : in  std_logic_vector(2 downto 0);  -- Input program counter value
        PC_out : out std_logic_vector(2 downto 0)   -- Current program counter output
    );
end Program_Counter;

architecture Behavioral of Program_Counter is
begin
    process(Clk, Reset)
    begin
        -- Asynchronous reset: reset PC to zero immediately when Reset='1'
        if Reset = '1' then
            PC_out <= "000";
            
        -- On rising edge of clock, update PC_out with PC_in
        elsif rising_edge(Clk) then
            PC_out <= PC_in;
        end if;
    end process;

end Behavioral;