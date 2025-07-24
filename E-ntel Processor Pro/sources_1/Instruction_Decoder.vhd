library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Instruction_Decoder is
    Port ( Instruction : in STD_LOGIC_VECTOR (11 downto 0);
           Zero_Flag : in STD_LOGIC;
           RegSelA : out STD_LOGIC_VECTOR (2 downto 0);
           RegSelB : out STD_LOGIC_VECTOR (2 downto 0);
           Reg_Enb : out STD_LOGIC_VECTOR (2 downto 0);
           Immediate : out STD_LOGIC_VECTOR (3 downto 0);
           Load_Sel : out STD_LOGIC;
           AddSub : out STD_LOGIC;
           JumpAddr : out STD_LOGIC_VECTOR (2 downto 0);
           Jump_Flag : out STD_LOGIC);
end Instruction_Decoder;

architecture Behavioral of Instruction_Decoder is
    signal jump_detect_internal : std_logic;
    signal Reg_Enb_internal : std_logic_vector (2 downto 0);

begin
    -- Register selections
    RegSelA <= Instruction(9 downto 7);
    RegSelB <= Instruction(6 downto 4);
    
    --Load Select 0 for AddSub Select ; 1 for Immediate Select
    --0 for ADD & NEG instructions
    --1 for MOVI & JUMP instructions
    --This can be simply derived by 1st bit of the OpCode Instruction(11) 
    Load_Sel <= Instruction(11);
    
    -- Immediate value (for MOVI)
    Immediate <= Instruction(3 downto 0);
    
    -- Jump address (for JZR)
    JumpAddr <= Instruction(2 downto 0);
    
    -- Internal check for jump
    jump_detect_internal <= Instruction(11) NAND Instruction(10);
    
    -- Register Enable for write signal
    -- Only Enable Registers if not JUMP Instruction
    -- For Jump instruction Enable Reg_0 (Read only Register)
    -- But it won't activate since it has no enable input
    Reg_Enb_internal(2) <= jump_detect_internal AND Instruction(9);
    Reg_Enb_internal(1) <= jump_detect_internal AND Instruction(8);
    Reg_Enb_internal(0) <= jump_detect_internal AND Instruction(7);
    
    -- Connect Reg_Enb_internal to Reg_Enb Output
    Reg_Enb <= Reg_Enb_internal;
    
    -- Adder or Subtraction Select
    -- Except NEG instruction; for evry other instruction we activate Adder
    -- For NEG instruction we activate Subtractor
    AddSub <=  jump_detect_internal AND Instruction(10);
    
    --Jump Flag
    --Jump if both jump_detect_internal and adder Zero_Flag from Adder is active
    Jump_Flag <= (NOT jump_detect_internal) AND Zero_Flag;


end Behavioral;