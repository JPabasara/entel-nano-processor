library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Display is
    Port ( clk : in STD_LOGIC;
           digit0 : in STD_LOGIC_VECTOR (3 downto 0);
           digit2 : in STD_LOGIC_VECTOR (2 downto 0);
           digit3 : in STD_LOGIC_VECTOR (2 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0));
end Display;

architecture Behavioral of Display is
 -- Component declaration for the LUT
   component LUT_16_7 is
       Port ( 
           address : in STD_LOGIC_VECTOR (3 downto 0);
           data : out STD_LOGIC_VECTOR (6 downto 0)
       );
   end component;
   
 -- constants    
   constant REFRESH_RATE : integer := 1000; -- 1kHz refresh rate
   constant CLK_FREQ : integer := 100000000; -- 100MHz clock (adjust according to your clock)
   constant COUNTER_MAX : integer := CLK_FREQ / REFRESH_RATE / 4;
 
 -- signals
   signal refresh_counter : integer range 0 to COUNTER_MAX-1 := 0;
   signal digit_value : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
   signal digit_select : integer range 0 to 3 := 0;
   signal newdigit0, newdigit1, newdigit2, newdigit3 : STD_LOGIC_VECTOR(3 downto 0);
   signal seg_internal : STD_LOGIC_VECTOR(6 downto 0);

begin
    
    newdigit0 <= STD_LOGIC_VECTOR(unsigned(not digit0)+1) when digit0(3) = '1' else digit0;
    newdigit2 <= "0" & digit2;
    newdigit3 <= "0" & digit3;
  
  -- Process for digit selection and refresh
    process(clk)
    begin
        if rising_edge(clk) then
            -- Refresh counter
            if refresh_counter = COUNTER_MAX-1 then
                refresh_counter <= 0;
                
                -- Move to next digit
                if digit_select = 3 then
                    digit_select <= 0;
                else
                    digit_select <= digit_select + 1;
                end if;
            else
                refresh_counter <= refresh_counter + 1;
            end if;
        end if;
    end process;
    
  -- Digit selection
    with digit_select select digit_value <=
        newdigit0 when 0,
        newdigit1 when 1,
        newdigit2 when 2,
        newdigit3 when 3;
        
  -- Instantiate the LUT for seven-segment decoding
        LUT : LUT_16_7
        port map (
            address => digit_value,
            data => seg_internal
        );
    
  -- Anode driver
    an <= "1110" when digit_select = 0 else
          "1101" when digit_select = 1 else
          "1011" when digit_select = 2 else
          "0111" when digit_select = 3 else
          "1111";
    
  -- Cathode driver
    seg <= "0111111" when (digit_select = 1 and digit0(3) = '1') else 
           "1111111" when (digit_select = 1 and digit0(3) = '0') else
           seg_internal;
    
end Behavioral;
