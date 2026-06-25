library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux_2_Way_3_bit is
    Port (
        A      : in  STD_LOGIC_VECTOR(2 downto 0);  -- Input A
        B      : in  STD_LOGIC_VECTOR(2 downto 0);  -- Input B
        Sel    : in  STD_LOGIC;                      -- Select signal
        Output : out STD_LOGIC_VECTOR(2 downto 0)   -- Multiplexer output
    );
end Mux_2_Way_3_bit;

architecture Behavioral of Mux_2_Way_3_bit is
    -- Internal signals for selected inputs after gating with select lines
    signal SEL_A   : STD_LOGIC_VECTOR(2 downto 0);
    signal SEL_B   : STD_LOGIC_VECTOR(2 downto 0);
    signal NOT_SEL : STD_LOGIC;
begin
    -- Invert select signal for gating input B
    NOT_SEL <= NOT Sel;

    -- Gate input A bits with Sel (passes when Sel='1')
    SEL_A(0) <= A(0) AND Sel;
    SEL_A(1) <= A(1) AND Sel;
    SEL_A(2) <= A(2) AND Sel;

    -- Gate input B bits with NOT Sel (passes when Sel='0')
    SEL_B(0) <= B(0) AND NOT_SEL;
    SEL_B(1) <= B(1) AND NOT_SEL;
    SEL_B(2) <= B(2) AND NOT_SEL;

    -- Combine gated signals to produce output bits
    Output(0) <= SEL_A(0) OR SEL_B(0);
    Output(1) <= SEL_A(1) OR SEL_B(1);
    Output(2) <= SEL_A(2) OR SEL_B(2);

end Behavioral;
