----------------------------------------------------------------------------------
-- Company: E-ntel
-- Engineer: Pabasara H H J
-- 
-- Create Date: 05/14/2025 11:35:07 AM
-- Design Name: Top Level Computer
-- Module Name: E_ntel_Computer - Behavioral
-- Project Name: E-ntel Nanoprocessor
-- Target Devices: BASYS 3
-- Tool Versions: 
-- Description: 
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


entity E_ntel_Computer is
    Port (
        Clk    : in  STD_LOGIC;
        Reset  : in  STD_LOGIC;
        Zero   : out  STD_LOGIC;
        OverFlow  : out  STD_LOGIC;
        Jump  : out  STD_LOGIC;
 

        AN     : out STD_LOGIC_VECTOR(3 downto 0);  -- Anodes
        SEG    : out STD_LOGIC_VECTOR(6 downto 0)   -- Segments
    );
end E_ntel_Computer;

architecture Behavioral of E_ntel_Computer is

    -- Components
    component NanoProcessor is
        Port (
            Clk           : in  STD_LOGIC;
            Reset         : in  STD_LOGIC;
            Zero_Flag     : out STD_LOGIC;
            Overflow_Flag : out STD_LOGIC;
            Jump_Flag     : out STD_LOGIC;
            Neg_Flag      : out STD_LOGIC;
            R0_Out, R1_Out, R2_Out, R3_Out,
            R4_Out, R5_Out, R6_Out, R7_Out : out STD_LOGIC_VECTOR(3 downto 0);
            ALU_Output : out STD_LOGIC_VECTOR(3 downto 0);
            Current_Address : out STD_LOGIC_VECTOR(2 downto 0);
            Next_Address : out STD_LOGIC_VECTOR(2 downto 0)
        );
    end component;

 

    component Display is
        Port (
            clk    : in STD_LOGIC;
            digit0 : in STD_LOGIC_VECTOR(3 downto 0);
            digit2 : in STD_LOGIC_VECTOR(2 downto 0);
            digit3 : in STD_LOGIC_VECTOR(2 downto 0);
            neg_flag : in STD_LOGIC;
            an     : out STD_LOGIC_VECTOR(3 downto 0);
            seg    : out STD_LOGIC_VECTOR(6 downto 0)
        );
    end component;

    -- Signals
    signal Neg_Flag_internal : STD_LOGIC;
    signal Zero_internal, OverFlow_internal, Jump_internal : STD_LOGIC; -- for flags, unused here
    signal ALU_Output_internal  : STD_LOGIC_VECTOR(3 downto 0);
    signal Current_Address_internal, Next_Address_internal  : STD_LOGIC_VECTOR(2 downto 0);
    

begin

    -- Instantiate NanoProcessor
    NP: NanoProcessor
        port map (
            Clk => Clk,
            Reset => Reset,
            Zero_Flag => Zero_internal,
            Overflow_Flag => OverFlow_internal,
            Jump_Flag => Jump_internal,
            Neg_Flag => Neg_Flag_internal,
            ALU_Output => ALU_Output_internal,
            Current_Address => Current_Address_internal,
            Next_Address => Next_Address_internal
             
        );

  
    -- Instantiate AllSevenSegments
    Display_1: Display
        port map (
            clk => Clk,
            digit0 => ALU_Output_internal,
          
           
            digit2 => Current_Address_internal,
            
           
            digit3 => Next_Address_internal,
            neg_flag =>Neg_Flag_internal,
            an => AN,
            seg => SEG
        );
  
      Zero <= Zero_internal;
      OverFlow <= OverFlow_internal;
      Jump <= Jump_internal;


end Behavioral;