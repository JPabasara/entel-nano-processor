----------------------------------------------------------------------------------
-- Company: E-ntel
-- Engineer: Pabasara H H J
-- 
-- Create Date: 05/12/2025 03:166:25 PM
-- Design Name: PC Increment Unit
-- Module Name: PC_Increment_Unit - Behavioral
-- Project Name: E-ntel Nanoprocessor
-- Target Devices: BASYS 3
-- Tool Versions: 
-- Description: Connects ProgramCounter, RCA_3, and Mux_2_Way_3_Bit to increment PC
--              or jump to an address based on Jump_Flag
-- 
-- Dependencies: RCA_3, Mux_2_Way_3_Bit, ProgramCounter
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PC_Increment_Unit is
    Port ( 
        Clk        : in STD_LOGIC;
        Reset      : in STD_LOGIC;
        JumpAddr   : in STD_LOGIC_VECTOR (2 downto 0);
        Jump_Flag  : in STD_LOGIC;
        MemorySel  : out STD_LOGIC_VECTOR (2 downto 0);
        Nex_Add    : out STD_LOGIC_VECTOR (2 downto 0)
    );
end PC_Increment_Unit;

architecture Behavioral of PC_Increment_Unit is

    -- Component declarations
    component RCA_3
        Port (
            A    : in  STD_LOGIC_VECTOR(2 downto 0);
            B    : in  STD_LOGIC_VECTOR(2 downto 0);
            Sum  : out STD_LOGIC_VECTOR(2 downto 0);
            Cout : out STD_LOGIC
        );
    end component;

    component Mux_2_Way_3_Bit
        Port (
            A      : in  STD_LOGIC_VECTOR(2 downto 0);
            B      : in  STD_LOGIC_VECTOR(2 downto 0);
            Sel    : in  STD_LOGIC;
            Output : out STD_LOGIC_VECTOR(2 downto 0)
        );
    end component;

    component ProgramCounter
        Port (
            Clk    : in STD_LOGIC;
            Reset  : in STD_LOGIC;
            PC_in  : in STD_LOGIC_VECTOR(2 downto 0);
            PC_out : out STD_LOGIC_VECTOR(2 downto 0)
        );
    end component;

    -- Internal signals
    signal PC_out_internal     : STD_LOGIC_VECTOR(2 downto 0);
    signal PC_plus_1  : STD_LOGIC_VECTOR(2 downto 0);
    signal Next_PC    : STD_LOGIC_VECTOR(2 downto 0);

begin

    -- Instantiate Program Counter
    PC : ProgramCounter
        port map (
            Clk    => Clk,
            Reset  => Reset,
            PC_in  => Next_PC,
            PC_out => PC_out_internal
        );

    -- 3-bit RCA adds 1 to current PC
    ADDER : RCA_3
        port map (
            A    => PC_out_internal,
            B    => "001",-- Hardwired to increment by 1 at each step
            Sum  => PC_plus_1,
            Cout => open  -- Overflow is not needed, so we leave it unconnected
        );

    -- MUX selects between JumpAddr and PC+1
    MUX : Mux_2_Way_3_Bit
        port map (
            A      => JumpAddr,
            B      => PC_plus_1,
            Sel    => Jump_Flag,
            Output => Next_PC
        );

    -- Output PC value to Memory
    MemorySel <= PC_out_internal;
    Nex_Add  <= Next_PC;

end Behavioral;
