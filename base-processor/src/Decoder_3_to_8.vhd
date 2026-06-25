library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Decoder_3_to_8 is
    Port (
        I : in  STD_LOGIC_VECTOR(2 downto 0); -- I(2) = MSB
        Y : out STD_LOGIC_VECTOR(7 downto 0)
    );
end Decoder_3_to_8;

architecture Behavioral of Decoder_3_to_8 is

    -- Component declaration of 2-to-4 decoder with enable
    component Decoder_2_to_4
        Port (
            I  : in  STD_LOGIC_VECTOR(1 downto 0);
            EN : in  STD_LOGIC;
            Y  : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

    -- Internal signals for connecting the two 2-to-4 decoders
    signal Y_lower : STD_LOGIC_VECTOR(3 downto 0);
    signal Y_upper : STD_LOGIC_VECTOR(3 downto 0);
    signal I2_bar  : STD_LOGIC;

begin

    -- Invert MSB to use as enable for lower decoder
    I2_bar <= NOT I(2);

    -- Lower decoder: active when I(2) = 0
    Decoder_Low: Decoder_2_to_4
        port map (
            I  => I(1 downto 0),
            EN => I2_bar,
            Y  => Y_lower
        );

    -- Upper decoder: active when I(2) = 1
    Decoder_High: Decoder_2_to_4
        port map (
            I  => I(1 downto 0),
            EN => I(2),
            Y  => Y_upper
        );

    -- Combine both 4-bit outputs into the final 8-bit output
    Y(3 downto 0) <= Y_lower;
    Y(7 downto 4) <= Y_upper;

end Behavioral;