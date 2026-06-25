library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RCA_3 is
    Port (
        A      : in  STD_LOGIC_VECTOR(2 downto 0);  -- 3-bit input A
        B      : in  STD_LOGIC_VECTOR(2 downto 0);  -- 3-bit input B
        Sum    : out STD_LOGIC_VECTOR(2 downto 0);  -- 3-bit sum output
        Cout   : out STD_LOGIC                       -- Carry out (overflow)
    );
end RCA_3;

architecture Behavioral of RCA_3 is

    -- Full Adder component declaration for reuse
    component FA
        Port (
            A      : in  STD_LOGIC;    -- Single bit input A
            B      : in  STD_LOGIC;    -- Single bit input B
            C_in   : in  STD_LOGIC;    -- Carry input
            S      : out STD_LOGIC;    -- Sum output
            C_out  : out STD_LOGIC     -- Carry output
        );
    end component;

    -- Internal carry signals between full adders
    signal C0, C1 : STD_LOGIC;

begin

    -- First full adder: least significant bit addition with carry-in hardwired to '0'
    FA_0 : FA
        port map (
            A     => A(0),
            B     => B(0),
            C_in  => '0',    -- No carry-in for LSB adder
            S     => Sum(0),
            C_out => C0      -- Carry out to next stage
        );

    -- Second full adder: middle bit addition, carry-in from previous adder
    FA_1 : FA
        port map (
            A     => A(1),
            B     => B(1),
            C_in  => C0,
            S     => Sum(1),
            C_out => C1      -- Carry out to next stage
        );

    -- Third full adder: most significant bit addition, carry-out is overall overflow
    FA_2 : FA
        port map (
            A     => A(2),
            B     => B(2),
            C_in  => C1,
            S     => Sum(2),
            C_out => Cout    -- Final carry out (overflow)
        );

end Behavioral;