library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RCA_4 is
    Port (
        A     : in  STD_LOGIC_VECTOR(3 downto 0);
        B     : in  STD_LOGIC_VECTOR(3 downto 0);
        Cin   : in  STD_LOGIC;
        Sum   : out STD_LOGIC_VECTOR(3 downto 0);
        Cout  : out STD_LOGIC
    );
end RCA_4;

architecture Behavioral of RCA_4 is

    component FA
        Port (
            A      : in  STD_LOGIC;
            B      : in  STD_LOGIC;
            C_in   : in  STD_LOGIC;
            S      : out STD_LOGIC;
            C_out  : out STD_LOGIC
        );
    end component;

    signal C0, C1, C2, C3 : STD_LOGIC;

begin

    FA_0 : FA
        port map (
            A     => A(0),
            B     => B(0),
            C_in  => Cin,
            S     => Sum(0),
            C_out => C0
        );

    FA_1 : FA
        port map (
            A     => A(1),
            B     => B(1),
            C_in  => C0,
            S     => Sum(1),
            C_out => C1
        );

    FA_2 : FA
        port map (
            A     => A(2),
            B     => B(2),
            C_in  => C1,
            S     => Sum(2),
            C_out => C2
        );

    FA_3 : FA
        port map (
            A     => A(3),
            B     => B(3),
            C_in  => C2,
            S     => Sum(3),
            C_out => Cout
        );

end Behavioral;
