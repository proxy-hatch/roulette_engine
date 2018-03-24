LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY WORK;
USE WORK.ALL;

--------------------------------------------------------------
--
-- Lucky you !!  We are giving you this code.  There is nothing
-- here you need to add or write.  
--
-- This block simulates a spinning wheel.  It consists of 
-- counter that is always counting.  The output is the value of 
-- the count (it will be sampled outside of the block when the
-- user hits the slow_clock switch).  In a real roulette wheel,
-- the wheel is arranged in the following pattern:
--
-- 0-32-15-19-4-21-2-25-17-34-6-27-13-36-11-30-8-23-10-5-24-16-
-- -33-1-20-14-31-9-22-18-29-7-28-12-35-3-26
--
-- In our implementation, we count in numeric order to make the
-- implementation simpler.  Since we count many many times before the
-- user samples, this has the same effect.  If you wanted, you
-- could modify this block so it counts in the above order, 
-- but it wouldn't really change the play of the game.
--
---------------------------------------------------------------

ENTITY spinwheel IS
	PORT(
		fast_clock : IN  STD_LOGIC;  -- This will be a 27 Mhz Clock
		resetb : IN  STD_LOGIC;      -- asynchronous reset
		spin_result  : OUT UNSIGNED(5 downto 0));  -- current value of the wheel
END;

ARCHITECTURE behavioral OF spinwheel IS

    --  We will use an integer to represent the count internally.  Of course we will
    --  need to cast it to an unsigned value before sending it outside the block.

	SIGNAL	wheel_internal : INTEGER;
	
BEGIN
	-- The wheel is always spinning
	PROCESS( fast_clock, resetb )
	BEGIN

                -- Asynchronous reset, follows pattern 3 in Slide Set 3

		IF resetb='0' THEN
			wheel_internal <= 0;

                -- If not reset, check for a rising clock edge

		ELSIF RISING_EDGE(fast_clock) THEN
			IF wheel_internal = 36 THEN
				wheel_internal <= 0;
			ELSE
				wheel_internal <= wheel_internal + 1;
			END IF;
		END IF;
	END PROCESS;

	spin_result <= to_unsigned(wheel_internal, spin_result'length);
END;
