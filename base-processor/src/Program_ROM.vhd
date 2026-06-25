library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Program_ROM is
    Port (
        Address : in std_logic_vector(2 downto 0);
        Instruction : out std_logic_vector(11 downto 0)
    );
end Program_ROM;

architecture Behavioral of Program_ROM is
    type ROM_Array is array (0 to 7) of std_logic_vector(11 downto 0);
    
    constant ROM_Data : ROM_Array := (
               "100010000001", -- MOVI R1, 1        ; R1 = 1
               "100100000010", -- MOVI R2, 2        ; R2 = 2 (for jump)
               "001110010000", -- ADD  R7, R1       ; R7 += R1 (R7 = 1)
               "000010010000", -- ADD  R1, R1       ; R1 += 1 (R1 = 2, using R1 + R1 = 2)
               "010100000000", -- NEG  R2           ; R2 = -2
               "000100010000", -- ADD  R2, R1       ; R2 += R1 ? loop control: -2 + 2 ? 0, 
               "110100000010", -- JZR  R2           ; if R2 == 0, jump to address 2 (line 3)
               "101110000110"  -- MOV  R7,6         ; Finally Show R7 = 6
    );
begin
    Instruction <= ROM_Data(to_integer(unsigned(Address)));
end Behavioral;