library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux_8_Way_4_bit is
    Port (
        R0, R1, R2, R3, R4, R5, R6, R7 : in STD_LOGIC_VECTOR(3 downto 0);
        RegSel    : in  STD_LOGIC_VECTOR(2 downto 0);
        Data_Out  : out STD_LOGIC_VECTOR(3 downto 0)
    );
end Mux_8_Way_4_bit;

architecture Behavioral of Mux_8_Way_4_bit is

    -- Component declaration for the 3-to-8 decoder
    component Decoder_3_to_8
        Port (
            I : in  STD_LOGIC_VECTOR(2 downto 0);
            Y : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

    -- Internal signal to hold the decoder output
    signal internal_decoder_out : STD_LOGIC_VECTOR(7 downto 0);

begin

    -- Instantiate the decoder
    Decoder_Internal: Decoder_3_to_8
        port map (
            I => RegSel,
            Y => internal_decoder_out
        );

    -- Multiplexer logic based on one-hot decoder output
    Data_Out <= R0 when internal_decoder_out(0) = '1' else
                R1 when internal_decoder_out(1) = '1' else
                R2 when internal_decoder_out(2) = '1' else
                R3 when internal_decoder_out(3) = '1' else
                R4 when internal_decoder_out(4) = '1' else
                R5 when internal_decoder_out(5) = '1' else
                R6 when internal_decoder_out(6) = '1' else
                R7;

end Behavioral;