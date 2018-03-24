LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
 
LIBRARY WORK;
USE WORK.ALL;

--------------------------------------------------------------
--
-- Skeleton file for new_balance subblock.  This block is purely
-- combinational (think Pattern 1 in the slides) and calculates the
-- new balance after adding winning bets and subtracting losing bets.
--
---------------------------------------------------------------


ENTITY new_balance IS
  PORT(money : in unsigned(11 downto 0);  -- Current balance before this spin
       value1 : in unsigned(2 downto 0);  -- Value of bet 1
       value2 : in unsigned(2 downto 0);  -- Value of bet 2
       value3 : in unsigned(2 downto 0);  -- Value of bet 3
       bet1_wins : in std_logic;  -- True if bet 1 is a winner
       bet2_wins : in std_logic;  -- True if bet 2 is a winner
       bet3_wins : in std_logic;  -- True if bet 3 is a winner
       new_money : out unsigned(11 downto 0));  -- balance after adding winning
                                                -- bets and subtracting losing bets
END new_balance;


ARCHITECTURE behavioural OF new_balance IS
BEGIN
	-- Note: 
	-- you can perform arithmetic operations or access the individual wires for UNSIGNED type

	comb_process: process(all)
	variable balance: unsigned(11 downto 0); -- default value cannot be signal
	begin
		balance := money;
		
		if not((value1 = 0) and (value2 = 0) and (value3 = 0)) then
		
			if bet1_wins = '1' then
				balance := balance + to_unsigned(35, balance'length - value1'length) * value1;
			else
				balance := balance - ((balance'length-1 downto value1'length => '0') & value1);
			end if;

			if bet2_wins = '1' then
				balance := balance + ((balance'length-1 downto value2'length => '0') & value2);
			else
				balance := balance - ((balance'length-1 downto value2'length => '0') & value2);
			end if;

			if bet3_wins = '1' then
				balance := balance + to_unsigned(2, balance'length - value1'length) * value3;
			else
				balance := balance - ((balance'length-1 downto value3'length => '0') & value3);
			end if;
			
		end if;
		
		new_money <= balance; 	-- Note:  assignments to signals only happen 
							-- 		  at the end of a process
		-- new_money <= money;
		
	end process comb_process;
	
END;
