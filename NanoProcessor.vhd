----------------------------------------------------------------------------------
-- Company: E-ntel
-- Engineer: Pabasara H H J
-- 
-- Create Date: 05/13/2025 05:26:29 PM
-- Design Name: NanoProcessor
-- Module Name: NanoProcessor - Behavioral
-- Project Name: E-ntel Nanoprocessor
-- Target Devices: BASYS 3
-- Tool Versions: 
-- Description: Top-level architecture for a simplified nanoprocessor.
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity NanoProcessor is
    Port ( 
        Clk            : in  STD_LOGIC;
        Reset          : in  STD_LOGIC;
        Zero_Flag      : out STD_LOGIC;
        Overflow_Flag  : out STD_LOGIC;
        Jump_Flag      : out STD_LOGIC;
        Neg_Flag       : out STD_LOGIC;
        R0_Out, R1_Out, R2_Out, R3_Out, 
        R4_Out, R5_Out, R6_Out, R7_Out : out STD_LOGIC_VECTOR(3 downto 0);
        ALU_Output : out STD_LOGIC_VECTOR(3 downto 0);
        Current_Address : out STD_LOGIC_VECTOR(2 downto 0);
        Next_Address : out STD_LOGIC_VECTOR(2 downto 0)
    );
end NanoProcessor;

architecture Behavioral of NanoProcessor is

    --Slow clock used to slow down the internal clock of BASYS 3
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
            Nex_Add    : out STD_LOGIC_VECTOR (2 downto 0)
        );
    end component;

    -- Program ROM: Stores and provides instructions
    component ProgramROM is
        Port (
            Address     : in  STD_LOGIC_VECTOR(2 downto 0);
            Instruction : out STD_LOGIC_VECTOR(11 downto 0)
        );
    end component;

    -- Instruction Decoder: Decodes 12-bit instructions
    component Instruction_Decoder_1 is
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

    -- Register Bank: Holds 8 general-purpose 4-bit registers
    component RegisterBank is
        Port (
            Clk        : in  STD_LOGIC;
            Reset      : in  STD_LOGIC;
            Reg_Select : in  STD_LOGIC_VECTOR(2 downto 0);
            Data_In    : in  STD_LOGIC_VECTOR(3 downto 0);
            R0, R1, R2, R3, 
            R4, R5, R6, R7 : out STD_LOGIC_VECTOR(3 downto 0)
            
        );
    end component;

    -- 2-Way 4-Bit Mux: Chooses between immediate and AU result
    component Mux_2_Way_4_Bit is
        Port (
            A      : in  STD_LOGIC_VECTOR(3 downto 0);
            B      : in  STD_LOGIC_VECTOR(3 downto 0);
            Sel    : in  STD_LOGIC;
            Output : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

    -- Arithmetic Unit: Performs addition/subtraction
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
    
    -- Internal signals
        signal Internal_Clk : std_logic;
        signal PC_out,Next_Add_internal : std_logic_vector(2 downto 0);
        signal Instruction : std_logic_vector(11 downto 0);
        signal RegSelA, RegSelB : std_logic_vector(2 downto 0);
        signal Immediate : std_logic_vector(3 downto 0);
        signal AddSub,LoadSel : std_logic;
        signal R0, R1, R2, R3, R4, R5, R6, R7 : std_logic_vector(3 downto 0);
        signal ALU_Out, DataIn : std_logic_vector(3 downto 0);
        signal Reg_Enb, JumpAddress : std_logic_vector(2 downto 0);
        signal Zero, Overflow, Jumpflag : std_logic;
        
begin

    --Slow Clock
    CLOCK : Slow_Clk port map (
        Clk_in => Clk,
        Clk_out => Internal_Clk
     );
        
    -- Program Counter
    PC_Inc: PC_Increment_Unit port map (
        Clk => Internal_Clk,
        Reset => Reset,
        MemorySel => PC_out,
        Nex_Add => Next_Add_internal,
        JumpAddr => JumpAddress ,
        Jump_Flag => Jumpflag
    );
    
    -- Program ROM
    ROM: ProgramROM port map (
        Address => PC_out,
        Instruction => Instruction
    );
    
    -- Instruction Decoder
    IDecoder: Instruction_Decoder_1 port map (
        Instruction => Instruction,
        Zero_Flag => Zero,
        Jump_Flag => Jumpflag,
        RegSelA => RegSelA,
        RegSelB => RegSelB,
        Reg_Enb => Reg_Enb,
        Immediate => Immediate,
        JumpAddr => JumpAddress,
        AddSub => AddSub,
        Load_Sel => LoadSel

    );
    
    -- Register Bank
    RegBank: RegisterBank port map (
        Clk => Internal_Clk,
        Reset => Reset,
        Reg_Select => Reg_Enb,
        Data_In => DataIn,
        R0 => R0,
        R1 => R1,
        R2 => R2,
        R3 => R3,
        R4 => R4,
        R5 => R5,
        R6 => R6,
        R7 => R7
    );
    -- Data Input Mux (ALU result or immediate value)
    DataMux: Mux_2_Way_4_Bit port map (
        A => Immediate ,
        B => ALU_Out,
        Sel => LoadSel,
        Output => DataIn
    );
    
    -- ALU (Add/Sub Unit)
    ALU: Arithmetic_Unit port map (
        RegSelA => RegSelA,
        RegSelB => RegSelB,
        R0 => R0,
        R1 => R1,
        R2 => R2,
        R3 => R3,
        R4 => R4,
        R5 => R5,
        R6 => R6,
        R7 => R7,
        Cin => AddSub,
        Sum => ALU_Out,
        Zero => Zero,
        Overflow => Overflow
    );
    
    -- Output connections
    
    -- Map Internal Flags Output Flags
    Zero_Flag <= Zero;
    Overflow_Flag <= Overflow;
    Jump_Flag <= Jumpflag;
    -- Map internal register values to output ports
    R0_Out <= R0;
    R1_Out <= R1;
    R2_Out <= R2;
    R3_Out <= R3;
    R4_Out <= R4;
    R5_Out <= R5;
    R6_Out <= R6;
    R7_Out <= R7;
    ALU_Output <= ALU_Out;
    Current_Address <= PC_out;
    Next_Address <= Next_Add_internal;
    Neg_Flag <= AddSub;
    
end Behavioral;
