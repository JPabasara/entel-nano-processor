library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entity for 4-bit Ripple Carry Adder
entity RCA_4 is
    Port (
        A     : in  STD_LOGIC_VECTOR(3 downto 0);  -- 4-bit input A
        B     : in  STD_LOGIC_VECTOR(3 downto 0);  -- 4-bit input B
        Cin   : in  STD_LOGIC;                     -- Carry-in input
        Sum   : out STD_LOGIC_VECTOR(3 downto 0);  -- 4-bit sum output
        Cout  : out STD_LOGIC                      -- Carry-out output
    );
end RCA_4;

-- Architecture using chained Full Adders
architecture Behavioral of RCA_4 is

    -- Full Adder component declaration
    component FA
        Port (
            A      : in  STD_LOGIC;
            B      : in  STD_LOGIC;
            C_in   : in  STD_LOGIC;
            S      : out STD_LOGIC;
            C_out  : out STD_LOGIC
        );
    end component;

    -- Internal carry signals between stages
    signal C0, C1, C2, C3 : STD_LOGIC;

begin

    -- First full adder (LSB)
    FA_0 : FA
        port map (
            A     => A(0),
            B     => B(0),
            C_in  => Cin,
            S     => Sum(0),
            C_out => C0
        );

    -- Second full adder
    FA_1 : FA
        port map (
            A     => A(1),
            B     => B(1),
            C_in  => C0,
            S     => Sum(1),
            C_out => C1
        );

    -- Third full adder
    FA_2 : FA
        port map (
            A     => A(2),
            B     => B(2),
            C_in  => C1,
            S     => Sum(2),
            C_out => C2
        );

    -- Fourth full adder (MSB)
    FA_3 : FA
        port map (
            A     => A(3),
            B     => B(3),
            C_in  => C2,
            S     => Sum(3),
            C_out => Cout
        );

end Behavioral;