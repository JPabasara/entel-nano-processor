library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux_2_Way_4_bit is
    Port (
        A      : in  STD_LOGIC_VECTOR(3 downto 0);  -- Input A (4-bit)
        B      : in  STD_LOGIC_VECTOR(3 downto 0);  -- Input B (4-bit)
        Sel    : in  STD_LOGIC;                      -- Select signal: when '1' select A, when '0' select B
        Output : out STD_LOGIC_VECTOR(3 downto 0)   -- Output (4-bit) reflecting selected input
    );
end Mux_2_Way_4_bit;

architecture Behavioral of Mux_2_Way_4_bit is
    -- Internal signals to hold gated inputs based on select line
    signal Sel_A   : STD_LOGIC_VECTOR(3 downto 0);
    signal Sel_B   : STD_LOGIC_VECTOR(3 downto 0);
    signal Not_Sel : STD_LOGIC;
begin
    -- Invert the select signal
    Not_Sel <= not Sel;

    -- Gate A inputs with Sel signal
    Sel_A(0) <= A(0) and Sel;
    Sel_A(1) <= A(1) and Sel;
    Sel_A(2) <= A(2) and Sel;
    Sel_A(3) <= A(3) and Sel;

    -- Gate B inputs with inverted Sel signal
    Sel_B(0) <= B(0) and Not_Sel;
    Sel_B(1) <= B(1) and Not_Sel;
    Sel_B(2) <= B(2) and Not_Sel;
    Sel_B(3) <= B(3) and Not_Sel;

    -- Combine gated inputs to produce output
    Output(0) <= Sel_A(0) or Sel_B(0);
    Output(1) <= Sel_A(1) or Sel_B(1);
    Output(2) <= Sel_A(2) or Sel_B(2);
    Output(3) <= Sel_A(3) or Sel_B(3);

end Behavioral;