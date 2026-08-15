library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity E_ntel_Processor_Pro is
    Port (
        Clk    : in  STD_LOGIC;
        Reset  : in  STD_LOGIC;
        Zero   : out  STD_LOGIC;
        OverFlow  : out  STD_LOGIC;
        Jump  : out  STD_LOGIC;
        SW     : in  STD_LOGIC;  -- Switch for Reg7 or ALU Output
        Value_Out : out STD_LOGIC_VECTOR(3 downto 0);
        AN     : out STD_LOGIC_VECTOR(3 downto 0);  -- Anodes
        SEG    : out STD_LOGIC_VECTOR(6 downto 0)   -- Segments
    );
end E_ntel_Processor_Pro;

architecture Behavioral of E_ntel_Processor_Pro is

  -- Components
  
    component Nano_Processor is
        Port (
            Clk           : in  STD_LOGIC;
            Reset         : in  STD_LOGIC;
            Zero_Flag     : out STD_LOGIC;
            Overflow_Flag : out STD_LOGIC;
            Jump_Flag     : out STD_LOGIC;
            ALU_Output, R7_Out : out STD_LOGIC_VECTOR(3 downto 0);
            Current_Address : out STD_LOGIC_VECTOR(2 downto 0);
            Next_Address : out STD_LOGIC_VECTOR(2 downto 0)
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

    component Display is
        Port (
            clk    : in STD_LOGIC;
            digit0 : in STD_LOGIC_VECTOR(3 downto 0);
            digit2 : in STD_LOGIC_VECTOR(2 downto 0);
            digit3 : in STD_LOGIC_VECTOR(2 downto 0);
            an     : out STD_LOGIC_VECTOR(3 downto 0);
            seg    : out STD_LOGIC_VECTOR(6 downto 0)
        );
    end component;

    -- Signals
    signal Zero_internal, OverFlow_internal, Jump_internal : STD_LOGIC; -- for flags
    signal ALU_Output_internal, R7_internal, Selected_Output  : STD_LOGIC_VECTOR(3 downto 0);
    signal Current_Address_internal, Next_Address_internal  : STD_LOGIC_VECTOR(2 downto 0);
    

begin

  -- Instantiate NanoProcessor
    Processor: Nano_Processor
        port map (
            Clk => Clk,
            Reset => Reset,
            Zero_Flag => Zero_internal,
            Overflow_Flag => OverFlow_internal,
            Jump_Flag => Jump_internal,
            R7_Out => R7_internal,
            ALU_Output => ALU_Output_internal,
            Current_Address => Current_Address_internal,
            Next_Address => Next_Address_internal
             
        );

  -- Instantiate Mux_8_Way_4_Bit
    Mux_output: Mux_2_Way_4_bit
        port map (
            A => ALU_Output_internal,
            B => R7_internal,
            Sel => SW,
            Output => Selected_Output
        );

  -- Instantiate AllSevenSegments
    Display_4: Display
        port map (
            clk => Clk,
            digit0 => Selected_Output,
            digit2(2 downto 0) => Current_Address_internal,
            digit3(2 downto 0) => Next_Address_internal,
            an => AN,
            seg => SEG
        );
  
   -- Flag Outputs
    Zero     <= Zero_internal;
    OverFlow <= OverFlow_internal;
    Jump     <= Jump_internal;
    Value_Out <= Selected_Output;
    
end Behavioral;