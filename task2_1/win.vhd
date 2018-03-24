LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
 
LIBRARY WORK;
USE WORK.ALL;

--------------------------------------------------------------
--
--  This is a skeleton you can use for the win subblock.  This block determines
--  whether each of the 3 bets is a winner.  As described in the lab
--  handout, the first bet is a "straight-up" bet, teh second bet is 
--  a colour bet, and the third bet is a "dozen" bet.
--
--  This should be a purely combinational block.  There is no clock.
--  Remember the rules associated with Pattern 1 in the lectures.
--
---------------------------------------------------------------

ENTITY win IS
	PORT(spin_result_latched : in unsigned(5 downto 0);  -- result of the spin (the winning number)
             bet1_value : in unsigned(5 downto 0); -- value for bet 1
             bet2_colour : in std_logic;  -- colour for bet 2
             bet3_dozen : in unsigned(1 downto 0);  -- dozen for bet 3
             bet1_wins : out std_logic;  -- whether bet 1 is a winner
             bet2_wins : out std_logic;  -- whether bet 2 is a winner
             bet3_wins : out std_logic); -- whether bet 3 is a winner
END win;


ARCHITECTURE behavioural OF win IS
	signal spin_result_latched_color: std_logic; -- '0' black, '1' red
	
BEGIN
--  Some notes:
	-- For numbers in the range [1,10]  or [19,28], odd numbers are red 
	-- For numbers in the range [11,18] or [29,36], the odd numbers are black 
	
	comb_process: process(all)
	
	begin
		----------
		-- BET1  |
		---------
		if spin_result_latched = bet1_value then
			bet1_wins <= '1';
		else 
			bet1_wins <= '0';
		end if;
			
		----------
		-- BET2  |
		---------
		if( (spin_result_latched >= 1 and spin_result_latched <= 10) or
			(spin_result_latched >= 19 and spin_result_latched <= 28) ) then
			
			if spin_result_latched(0) = '1' then
				spin_result_latched_color <= '1'; -- odd numbers are red 
			else
				spin_result_latched_color <= '0';
			end if;
			
		elsif((spin_result_latched >= 11 and spin_result_latched <= 18) or
			(spin_result_latched >= 29 and spin_result_latched <= 36) ) then
			
			if spin_result_latched(0) = '1' then
				spin_result_latched_color <= '0'; -- odd numbers are black 
			else
				spin_result_latched_color <= '1';
			end if;
		end if;
					
		if spin_result_latched = 0 then
			bet2_wins <= '0';
		else
			if (spin_result_latched_color = bet2_colour) then
				bet2_wins <= '1';
			else
				bet2_wins <= '0';
			end if;
		end if;
		
	----------
	-- BET3  |
	---------
	if spin_result_latched = 0 or bet3_dozen = "11" then
		bet3_wins <= '0';
	elsif spin_result_latched >= 25 then
		if bet3_dozen = "10" then
			bet3_wins <= '1';
		else bet3_wins <= '0';
		end if;
	elsif spin_result_latched >= 13 then
		if bet3_dozen = "01" then
			bet3_wins <= '1';
		else bet3_wins <= '0';
		end if;
	else
		if bet3_dozen = "00" then
			bet3_wins <= '1';
		else bet3_wins <= '0';
		end if;
	end if;

	end process comb_process;
	
END;
