library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entity for 4-bit Adder/Subtractor (signed)
entity Add_Sub_Unit is
    Port (
        A        : in  STD_LOGIC_VECTOR(3 downto 0);  -- Operand A
        B        : in  STD_LOGIC_VECTOR(3 downto 0);  -- Operand B
        Cin      : in  STD_LOGIC;                     -- Control: 0 = Add, 1 = Subtract
        Sum      : out STD_LOGIC_VECTOR(3 downto 0);  -- Result
        Overflow : out STD_LOGIC;                     -- Signed overflow flag
        Zero     : out STD_LOGIC                      -- Zero flag
    );
end Add_Sub_Unit;

architecture Behavioral of Add_Sub_Unit is

    -- Component declaration for 4-bit ripple carry adder
    component RCA_4
        Port (
            A    : in  STD_LOGIC_VECTOR(3 downto 0);
            B    : in  STD_LOGIC_VECTOR(3 downto 0);
            Cin  : in  STD_LOGIC;
            Sum  : out STD_LOGIC_VECTOR(3 downto 0);
            Cout : out STD_LOGIC
        );
    end component;

    -- Internal signals
    signal A_xor     : STD_LOGIC_VECTOR(3 downto 0);  -- A XOR Cin
    signal S_temp    : STD_LOGIC_VECTOR(3 downto 0);  -- Temporary sum
    signal Cout      : STD_LOGIC;                     -- Carry-out from RCA
    signal Zero_temp : STD_LOGIC;                     -- Temp signal for zero detection

begin

    -- Compute A XOR Cin for subtraction (2's complement logic)
    A_xor(0) <= A(0) XOR Cin;
    A_xor(1) <= A(1) XOR Cin;
    A_xor(2) <= A(2) XOR Cin;
    A_xor(3) <= A(3) XOR Cin;

    -- Instantiate 4-bit RCA to compute B + A or B + ~A + 1
    RCA: RCA_4
        port map (
            A    => B,
            B    => A_xor,
            Cin  => Cin,
            Sum  => S_temp,
            Cout => Cout
        );

    -- Drive final sum output
    Sum <= S_temp;

    -- Signed overflow detection: checks MSB behavior
    Overflow <= ((not B(3)) and (not A_xor(3)) and S_temp(3)) or
                (B(3) and A_xor(3) and (not S_temp(3)));

    -- Zero detection: check if all bits of result are 0
    Zero_temp <= S_temp(0) or S_temp(1) or S_temp(2) or S_temp(3);
    Zero <= not Zero_temp;

end Behavioral;