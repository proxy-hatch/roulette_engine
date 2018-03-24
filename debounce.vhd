LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
 
LIBRARY WORK;
USE WORK.ALL;


entity debounce is
	port(key : in std_logic;
		CLOCK_50 : in std_logic;
		debounced_key : out std_logic);
end debounce;

architecture behavioural of debounce is
signal flipflops : std_logic_vector(1 downto 0);
signal counter_in : std_logic;  -- SCLR
signal counter_out: unsigned(19 downto 0) := (others => '0'); -- note 20 bits
begin	
	-- notes: how debounce works 
	-- receive different input clock_slow in this and next rising edge for the 
	-- first time, shows up in the output, and disable for the next cycle
	-- output doesn't change when the same input is received
	-- enables again when input in flipflops(0) and flipflops(1) is different
	debounce: process(key, CLOCK_50)
	begin
		if rising_edge(CLOCK_50) then
			flipflops(0) <= key;
			flipflops(1) <= flipflops(0);
			counter_in <= flipflops(0) xor flipflops(1);
			
			if (counter_in='1') then			-- reset counter because input is changing
				counter_out <= (others => '0'); 
			elsif(counter_out(19) = '0') then
				counter_out <= counter_out + 1;
			else 								-- stable input time is met
				debounced_key <= flipflops(1);
			end if;
		end if;
	end process debounce;
end;