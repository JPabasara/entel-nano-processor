----------------------------------------------------------------------------------
-- Company: E-ntel
-- Engineer: Pabasara H H J
-- 
-- Create Date: 05/12/2025 10:25:12 AM
-- Design Name: Register Bank
-- Module Name: RegisterBank - Behavioral
-- Project Name: E-ntel Nanoprocessor
-- Target Devices: BASYS 3
-- Tool Versions: 
-- Description: Register Bank contains 8 Registers (7 General purpose + 1 Special Purpose - ROM)
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

entity RegisterBank is
    Port ( 
        Clk       : in STD_LOGIC;
        Reset     : in STD_LOGIC;
        Reg_Select : in STD_LOGIC_VECTOR (2 downto 0); -- 3-bit selector
        Data_In   : in STD_LOGIC_VECTOR (3 downto 0);
        R0        : out STD_LOGIC_VECTOR (3 downto 0);
        R1        : out STD_LOGIC_VECTOR (3 downto 0);
        R2        : out STD_LOGIC_VECTOR (3 downto 0);
        R3        : out STD_LOGIC_VECTOR (3 downto 0);
        R4        : out STD_LOGIC_VECTOR (3 downto 0);
        R5        : out STD_LOGIC_VECTOR (3 downto 0);
        R6        : out STD_LOGIC_VECTOR (3 downto 0);
        R7        : out STD_LOGIC_VECTOR (3 downto 0)
    );
end RegisterBank;

architecture Behavioral of RegisterBank is

    -- 4-bit register with no input (outputs 0)
    component Register_4_Bit_Zero
        Port (
            Clk : in STD_LOGIC;
            Q : out STD_LOGIC_VECTOR (3 downto 0)
        );
    end component;

    -- 4-bit register with enable and reset
    component Register_4_Bit
        Port (
            D     : in STD_LOGIC_VECTOR (3 downto 0);
            En    : in STD_LOGIC;
            Clk   : in STD_LOGIC;
            Reset : in STD_LOGIC;
            Q     : out STD_LOGIC_VECTOR (3 downto 0)
        );
    end component;

    -- 3-to-8 decoder component
    component Decoder_3_to_8_No_Enb
        Port (
            I : in STD_LOGIC_VECTOR (2 downto 0);
            Y : out STD_LOGIC_VECTOR (7 downto 0)
        );
    end component;

    -- Signal to hold the decoder output (individual write enables)
    signal decoder_out : STD_LOGIC_VECTOR (7 downto 0);

begin

    -- Instantiate 3-to-8 decoder
    Decoder: Decoder_3_to_8_No_Enb
        port map (
            I => Reg_Select,
            Y => decoder_out
        );

    -- Register 0 is hardwired to zero
    Register_0: Register_4_Bit_Zero
        port map (
            Clk => Clk,
            Q => R0
        );

    -- Remaining registers use decoder output as enable
    Register_1: Register_4_Bit
        port map (
            D => Data_In,
            En => decoder_out(1),
            Clk => Clk,
            Reset => Reset,
            Q => R1
        );

    Register_2: Register_4_Bit
        port map (
            D => Data_In,
            En => decoder_out(2),
            Clk => Clk,
            Reset => Reset,
            Q => R2
        );

    Register_3: Register_4_Bit
        port map (
            D => Data_In,
            En => decoder_out(3),
            Clk => Clk,
            Reset => Reset,
            Q => R3
        );

    Register_4: Register_4_Bit
        port map (
            D => Data_In,
            En => decoder_out(4),
            Clk => Clk,
            Reset => Reset,
            Q => R4
        );

    Register_5: Register_4_Bit
        port map (
            D => Data_In,
            En => decoder_out(5),
            Clk => Clk,
            Reset => Reset,
            Q => R5
        );

    Register_6: Register_4_Bit
        port map (
            D => Data_In,
            En => decoder_out(6),
            Clk => Clk,
            Reset => Reset,
            Q => R6
        );

    Register_7: Register_4_Bit
        port map (
            D => Data_In,
            En => decoder_out(7),
            Clk => Clk,
            Reset => Reset,
            Q => R7
        );

end Behavioral;

