library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Arithmetic_Unit is
    Port (
        -- Selection signals for registers
        RegSelA   : in  STD_LOGIC_VECTOR(2 downto 0);
        RegSelB   : in  STD_LOGIC_VECTOR(2 downto 0);
        
        -- 8 register inputs (each 4 bits wide)
        R0, R1, R2, R3, R4, R5, R6, R7 : in STD_LOGIC_VECTOR(3 downto 0);

        -- Carry in signal (0: Add, 1: Subtract)
        Cin       : in  STD_LOGIC;

        -- Outputs
        Sum       : out STD_LOGIC_VECTOR(3 downto 0);
        Overflow  : out STD_LOGIC;
        Zero      : out STD_LOGIC
    );
end Arithmetic_Unit;

architecture Behavioral of Arithmetic_Unit is

    -- Component Declarations
    component Mux_8_Way_4_bit
        Port (
            R0, R1, R2, R3, R4, R5, R6, R7 : in STD_LOGIC_VECTOR(3 downto 0);
            RegSel    : in STD_LOGIC_VECTOR(2 downto 0);
            Data_Out  : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

    component Add_Sub_Unit
        Port (
            A        : in  STD_LOGIC_VECTOR(3 downto 0);
            B        : in  STD_LOGIC_VECTOR(3 downto 0);
            Cin      : in  STD_LOGIC;
            Sum      : out STD_LOGIC_VECTOR(3 downto 0);
            Overflow : out STD_LOGIC;
            Zero     : out STD_LOGIC
        );
    end component;

    -- Intermediate signals for mux outputs
    signal A_mux_out : STD_LOGIC_VECTOR(3 downto 0);
    signal B_mux_out : STD_LOGIC_VECTOR(3 downto 0);

begin

    -- Instantiate Mux for A input
    MuxA: Mux_8_Way_4_bit
        port map (
            R0 => R0, R1 => R1, R2 => R2, R3 => R3,
            R4 => R4, R5 => R5, R6 => R6, R7 => R7,
            RegSel => RegSelA,
            Data_Out => A_mux_out
        );

    -- Instantiate Mux for B input
    MuxB: Mux_8_Way_4_bit
        port map (
            R0 => R0, R1 => R1, R2 => R2, R3 => R3,
            R4 => R4, R5 => R5, R6 => R6, R7 => R7,
            RegSel => RegSelB,
            Data_Out => B_mux_out
        );

    -- Instantiate the Adder/Subtractor
    Adder_Subtractor: Add_Sub_Unit
        port map (
            A        => A_mux_out,
            B        => B_mux_out,
            Cin      => Cin,
            Sum      => Sum,
            Overflow => Overflow,
            Zero     => Zero
        );

end Behavioral;