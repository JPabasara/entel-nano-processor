library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entity for 2-to-4 decoder with enable input
entity Decoder_2_to_4 is
    Port (
        I  : in  STD_LOGIC_VECTOR(1 downto 0); -- Input select lines
        EN : in  STD_LOGIC;                    -- Enable signal
        Y  : out STD_LOGIC_VECTOR(3 downto 0)  -- Decoder outputs
    );
end Decoder_2_to_4;

architecture Behavioral of Decoder_2_to_4 is

    signal I0_bar : STD_LOGIC;
    signal I1_bar : STD_LOGIC;

begin

    -- Invert input bits
    I0_bar <= NOT I(0);
    I1_bar <= NOT I(1);

    -- Output logic with enable control
    Y(0) <= EN AND I1_bar AND I0_bar;  -- 00
    Y(1) <= EN AND I1_bar AND I(0);    -- 01
    Y(2) <= EN AND I(1) AND I0_bar;    -- 10
    Y(3) <= EN AND I(1) AND I(0);      -- 11

end Behavioral;