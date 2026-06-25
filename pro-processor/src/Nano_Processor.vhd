library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Nano_Processor is
    Port ( 
        Clk            : in  STD_LOGIC;                           -- Main input clock
        Reset          : in  STD_LOGIC;                           -- Reset signal
        Zero_Flag      : out STD_LOGIC;                           -- ALU Zero flag
        Overflow_Flag  : out STD_LOGIC;                           -- ALU Overflow flag
        Jump_Flag      : out STD_LOGIC;                           -- Jump signal from decoder
        ALU_Output, 
        R7_Out         : out STD_LOGIC_VECTOR(3 downto 0);        -- ALU result & Reg_7 output
        Current_Address : out STD_LOGIC_VECTOR(2 downto 0);       -- Current PC
        Next_Address    : out STD_LOGIC_VECTOR(2 downto 0)        -- Next PC
    );
end Nano_Processor;

architecture Behavioral of Nano_Processor is

    -- ============= Components ==============

    -- Clock Divider: Slows down clock for human observation
    component Slow_Clk is
        Port (
            Clk_in  : in  STD_LOGIC;
            Clk_out : out STD_LOGIC
        );
    end component;

    -- PC Increment Unit: Handles PC updates and jumps
    component PC_Increment_Unit is
        Port (
            Clk        : in  STD_LOGIC;
            Reset      : in  STD_LOGIC;
            JumpAddr   : in  STD_LOGIC_VECTOR(2 downto 0);
            Jump_Flag  : in  STD_LOGIC;
            MemorySel  : out STD_LOGIC_VECTOR(2 downto 0);
            Next_Add    : out STD_LOGIC_VECTOR(2 downto 0)
        );
    end component;

    -- Program ROM: Instruction memory (8 x 12-bit instructions)
    component Program_ROM is
        Port (
            Address     : in  STD_LOGIC_VECTOR(2 downto 0);
            Instruction : out STD_LOGIC_VECTOR(11 downto 0)
        );
    end component;

    -- Instruction Decoder: Converts 12-bit instruction to control signals
    component Instruction_Decoder is
        Port (
            Instruction : in  STD_LOGIC_VECTOR(11 downto 0);
            Zero_Flag   : in  STD_LOGIC;
            RegSelA     : out STD_LOGIC_VECTOR(2 downto 0);
            RegSelB     : out STD_LOGIC_VECTOR(2 downto 0);
            Reg_Enb     : out STD_LOGIC_VECTOR(2 downto 0);
            Immediate   : out STD_LOGIC_VECTOR(3 downto 0);
            Load_Sel    : out STD_LOGIC;
            AddSub      : out STD_LOGIC;
            JumpAddr    : out STD_LOGIC_VECTOR(2 downto 0);
            Jump_Flag   : out STD_LOGIC
        );
    end component;

    -- Register Bank: 8 general-purpose 4-bit registers
    component Reg_Bank is
        Port (
            Clk        : in  STD_LOGIC;
            Reset      : in  STD_LOGIC;
            Reg_Select : in  STD_LOGIC_VECTOR(2 downto 0);
            Data_In    : in  STD_LOGIC_VECTOR(3 downto 0);
            R0, R1, R2, R3, 
            R4, R5, R6, R7 : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

    -- MUX: Selects between ALU result and immediate value
    component Mux_2_Way_4_bit is
        Port (
            A      : in  STD_LOGIC_VECTOR(3 downto 0);
            B      : in  STD_LOGIC_VECTOR(3 downto 0);
            Sel    : in  STD_LOGIC;
            Output : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

    -- ALU: Performs addition/subtraction using two registers
    component Arithmetic_Unit is
        Port (
            RegSelA   : in  STD_LOGIC_VECTOR(2 downto 0);
            RegSelB   : in  STD_LOGIC_VECTOR(2 downto 0);
            R0, R1, R2, R3, 
            R4, R5, R6, R7 : in  STD_LOGIC_VECTOR(3 downto 0);
            Cin       : in  STD_LOGIC;
            Sum       : out STD_LOGIC_VECTOR(3 downto 0);
            Overflow  : out STD_LOGIC;
            Zero      : out STD_LOGIC
        );
    end component;

    -- ========== Internal Signals ==========
    signal Internal_Clk            : std_logic;
    signal PC_out, Next_Add_internal : std_logic_vector(2 downto 0);
    signal Instruction             : std_logic_vector(11 downto 0);
    signal RegSelA, RegSelB        : std_logic_vector(2 downto 0);
    signal Immediate               : std_logic_vector(3 downto 0);
    signal AddSub, LoadSel         : std_logic;
    signal Reg_Enb, JumpAddress    : std_logic_vector(2 downto 0);
    signal R0, R1, R2, R3          : std_logic_vector(3 downto 0);
    signal R4, R5, R6, R7          : std_logic_vector(3 downto 0);
    signal ALU_Out, DataIn         : std_logic_vector(3 downto 0);
    signal Zero, Overflow, Jumpflag : std_logic;

-- ============= Architecture Begin =============

begin

    -- Clock Divider Instantiation
    CLOCK : Slow_Clk 
        port map (
            Clk_in  => Clk,
            Clk_out => Internal_Clk
        );

    -- Program Counter Instantiation
    PC_Inc : PC_Increment_Unit 
        port map (
            Clk        => Internal_Clk,
            Reset      => Reset,
            JumpAddr   => JumpAddress,
            Jump_Flag  => Jumpflag,
            MemorySel  => PC_out,
            Next_Add    => Next_Add_internal
        );

    -- ROM Instantiation
    ROM : Program_ROM 
        port map (
            Address     => PC_out,
            Instruction => Instruction
        );

    -- Instruction Decoder Instantiation
    IDecoder : Instruction_Decoder 
        port map (
            Instruction => Instruction,
            Zero_Flag   => Zero,
            RegSelA     => RegSelA,
            RegSelB     => RegSelB,
            Reg_Enb     => Reg_Enb,
            Immediate   => Immediate,
            Load_Sel    => LoadSel,
            AddSub      => AddSub,
            JumpAddr    => JumpAddress,
            Jump_Flag   => Jumpflag
        );

    -- Register Bank Instantiation
    RegBank : Reg_Bank 
        port map (
            Clk        => Internal_Clk,
            Reset      => Reset,
            Reg_Select => Reg_Enb,
            Data_In    => DataIn,
            R0 => R0, R1 => R1, R2 => R2, R3 => R3,
            R4 => R4, R5 => R5, R6 => R6, R7 => R7
        );

    -- Data Mux Instantiation (ALU vs Immediate)
    DataMux : Mux_2_Way_4_bit 
        port map (
            A      => Immediate,
            B      => ALU_Out,
            Sel    => LoadSel,
            Output => DataIn
        );

    -- ALU Instantiation
    ALU : Arithmetic_Unit 
        port map (
            RegSelA => RegSelA,
            RegSelB => RegSelB,
            R0 => R0, R1 => R1, R2 => R2, R3 => R3,
            R4 => R4, R5 => R5, R6 => R6, R7 => R7,
            Cin      => AddSub,
            Sum      => ALU_Out,
            Zero     => Zero,
            Overflow => Overflow
        );

    -- Output Mappings
    Zero_Flag      <= Zero;
    Overflow_Flag  <= Overflow;
    Jump_Flag      <= Jumpflag;

   R7_Out <= R7;

    ALU_Output     <= ALU_Out;
    Current_Address <= PC_out;
    Next_Address    <= Next_Add_internal;

end Behavioral;
