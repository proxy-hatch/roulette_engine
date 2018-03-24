-- Filename:
-- Author 1: 
-- Author 1 Student #: 
-- Author 2: 
-- Author 2 Student #:
-- Group Number: 40
-- Lab Section: Lab04
-- Lab: 
-- Task Completed: 1, 2, 3, Challenge 
-- Date: January, 12, 2018 
------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity slowclock is
generic(
	delay : integer := 25000000
);
port(
	CLOCK_50: in std_logic;
	ledg : out std_logic_vector(7 downto 0);
	debounce_clk: out std_logic
);
end slowclock;

architecture behavioral of slowclock is
	--signal sample: std_logic_vector(24 downto 0) := "1011111010111100001000000";
	--variable flag: std_logic := '0';
	signal sample_pulse: std_logic;
	type statetype is (falling, rising) ;
	signal current_state, next_state: statetype := rising;

	signal counter_led: std_logic_vector(6 downto 0) := "0000000";
begin
clock_divider: process(CLOCK_50, current_state)
variable count: integer := 0;
begin
	if(rising_edge (CLOCK_50)) then
		if(count < delay) then
			count := count + 1;
			sample_pulse <= '0';
		else
			count := 0;
			sample_pulse <= '1';
		end if;	
		current_state <= next_state;
	end if;	
end process clock_divider;

sampling_process: process(CLOCK_50)	
begin
	--wait until (sample_pulse'event and sample_pulse='1');
		
			--sample(9 downto 1) <= sample(8 downto 0);
			--sample(0) <= input;
		case current_state is
			when rising => 
				if (sample_pulse = '1') then
					ledg(0) <= '1';
					ledg(1) <= '0';
					ledg(2) <= '0';
					ledg(3) <= '0';
					next_state <= falling;
				else
					ledg(0) <= '0';
					ledg(1) <= '1';
					ledg(2) <= '0';
					ledg(3) <= '0';
					next_state <= rising;
				end if;

			when falling =>
				if (sample_pulse = '1') then
					ledg(0) <= '0';
					ledg(1) <= '0';
					ledg(2) <= '1';
					ledg(3) <= '0';
					next_state <= rising;
				else
					ledg(0) <= '0';
					ledg(1) <= '0';
					ledg(2) <= '0';
					ledg(3) <= '1';
					next_state <= falling;
				end if;
		end case;
		
		--end if;
	--end if;
end process sampling_process;

clk_process: process(CLOCK_50)
begin
	case current_state is
	when rising =>
		debounce_clk <= '0';
	when falling =>
		debounce_clk <= '1';
	end case;
end process clk_process;
	
	
-- debounce_process: process(CLOCK_50)
-- begin
	-- case current_state is
	-- when rising =>
		-- debounce_clk <= '0';
		-- ledg(0) <= '1';
		-- ledg(1) <= '0';
	-- when falling =>
		-- debounce_clk <= '1';
		-- ledg(0) <= '0';
		-- ledg(1) <= '1';
	-- end case;
-- end process debounce_process;

end behavioral;