library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Base_Entel_Processor is
    Port (
        Clk    : in  STD_LOGIC;
        Reset  : in  STD_LOGIC;
        Zero   : out  STD_LOGIC;
        OverFlow  : out  STD_LOGIC;
        Jump   : out STD_LOGIC;
        Value_Out  : out STD_LOGIC_VECTOR(3 downto 0);
        AN     : out STD_LOGIC_VECTOR(3 downto 0);  -- Anode
        SEG    : out STD_LOGIC_VECTOR(6 downto 0)   -- Segments
    );
end Base_Entel_Processor;

architecture Behavioral of Base_Entel_Processor is

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
           MemorySel  : out STD_LOGIC_VECTOR(2 downto 0)
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
   
   component Mux_2_Way_4_bit is
       Port (
           A      : in  STD_LOGIC_VECTOR(3 downto 0);
           B      : in  STD_LOGIC_VECTOR(3 downto 0);
           Sel    : in  STD_LOGIC;
           Output : out STD_LOGIC_VECTOR(3 downto 0)
       );
   end component;

   component LUT_16_7 is
       Port ( 
            address : in STD_LOGIC_VECTOR (3 downto 0);
            data : out STD_LOGIC_VECTOR (6 downto 0)
        );
   end component;
   
-- ========== Internal Signals ==========
        signal Internal_Clk            : std_logic;
        signal PC_out                  : std_logic_vector(2 downto 0);
        signal Instruction             : std_logic_vector(11 downto 0);
        signal RegSelA, RegSelB        : std_logic_vector(2 downto 0);
        signal Immediate               : std_logic_vector(3 downto 0);
        signal AddSub, LoadSel         : std_logic;
        signal Reg_Enb, JumpAddress    : std_logic_vector(2 downto 0);
        signal R0, R1, R2, R3          : std_logic_vector(3 downto 0);
        signal R4, R5, R6, R7         : std_logic_vector(3 downto 0);
        signal ALU_Out, DataIn         : std_logic_vector(3 downto 0);
        signal OverFlow_internal, 
        Zero_internal, Jump_internal   : STD_LOGIC; -- for flags, unused here


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
                Jump_Flag  => Jump_internal,
                MemorySel  => PC_out
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
                Zero_Flag   => Zero_internal,
                RegSelA     => RegSelA,
                RegSelB     => RegSelB,
                Reg_Enb     => Reg_Enb,
                Immediate   => Immediate,
                Load_Sel    => LoadSel,
                AddSub      => AddSub,
                JumpAddr    => JumpAddress,
                Jump_Flag   => Jump_internal
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
    -- ALU Instantiation
        ALU : Arithmetic_Unit 
           port map (
               RegSelA => RegSelA,
               RegSelB => RegSelB,
               R0 => R0, R1 => R1, R2 => R2, R3 => R3,
               R4 => R4, R5 => R5, R6 => R6, R7 => R7,
               Cin      => AddSub,
               Sum      => ALU_Out,
               Zero     => Zero_internal,
               Overflow => OverFlow_internal
           );
                      
    -- Instantiate Mux_8_Way_4_Bit
        DataMux: Mux_2_Way_4_bit
            port map (
                A      => Immediate,
                B      => ALU_Out,
                Sel    => LoadSel,
                Output => DataIn
            );
    
    -- Instantiate AllSevenSegments
        Display: LUT_16_7
            Port map (
                address => R7,
                data => SEG
            );
    
      Zero <= Zero_internal;
      Jump <= Jump_internal;
      OverFlow <= OverFlow_internal;
      Value_Out <= R7;
      AN <= "1110";

end Behavioral;