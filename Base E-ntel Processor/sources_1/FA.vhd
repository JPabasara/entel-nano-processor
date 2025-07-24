library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entity declaration for Full Adder
entity FA is
    Port ( 
        A     : in  STD_LOGIC;   -- Input bit A
        B     : in  STD_LOGIC;   -- Input bit B
        C_in  : in  STD_LOGIC;   -- Carry-in input
        S     : out STD_LOGIC;   -- Sum output
        C_out : out STD_LOGIC    -- Carry-out output
    );
end FA;

-- Architecture implementing Full Adder using two Half Adders
architecture Behavioral of FA is

    -- Half Adder component declaration
    component HA
        port (
            A : in  STD_LOGIC;
            B : in  STD_LOGIC;
            S : out STD_LOGIC;
            C : out STD_LOGIC
        );
    end component;

    -- Internal signals to connect HA outputs
    SIGNAL HA0_S, HA0_C : STD_LOGIC;
    SIGNAL HA1_S, HA1_C : STD_LOGIC;

begin

    -- First Half Adder: adds A and B
    HA_0 : HA
        port map (
            A => A,
            B => B,
            S => HA0_S,
            C => HA0_C
        );

    -- Second Half Adder: adds result of first HA and C_in
    HA_1 : HA
        port map (
            A => HA0_S,
            B => C_in,
            S => HA1_S,
            C => HA1_C
        );

    -- Final outputs
    S     <= HA1_S;                   -- Final sum output
    C_out <= HA0_C OR HA1_C;         -- Final carry-out (OR of both HAs)

end Behavioral;