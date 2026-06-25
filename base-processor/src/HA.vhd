library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entity declaration for Half Adder
entity HA is
    Port ( 
        A : in  STD_LOGIC;   -- Input bit A
        B : in  STD_LOGIC;   -- Input bit B
        S : out STD_LOGIC;   -- Sum output
        C : out STD_LOGIC    -- Carry output
    );
end HA;

-- Architecture implementing Half Adder logic
architecture Behavioral of HA is
begin

    -- XOR gate for sum
    S <= A XOR B;

    -- AND gate for carry
    C <= A AND B;

end Behavioral;