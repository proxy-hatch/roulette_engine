LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

LIBRARY WORK;
USE WORK.ALL;

-----------------------------------------------------
--
--  This block will contain a decoder to decode a 4-bit number
--  to a 7-bit vector suitable to drive a HEX dispaly
--
--  It is a purely combinational block (think Pattern 1) and
--  is similar to a block you designed in Lab 1.
--
--------------------------------------------------------

ENTITY spinwheel_test IS
	GENERIC(REGISTER6: INTEGER := 6);
	PORT(
		  CLOCK_50: IN STD_LOGIC;
          SW : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);  
          HEX0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END;


ARCHITECTURE behavioral OF seg7_hex_test IS
	signal spin_result: std_logic_vector(5 downto 0);
	signal spin_result_latched: std_logic_vector(5 downto 0);
BEGIN
	spinwheel_block: ENTITY work.spinwheel PORT MAP(fast_clock => CLOCK_50, resetb => KEY(3), spin_result);
	register6_block: ENTITY work.registerN GENERIC MAP (N => REGISTER6) PORT MAP(D => SW, seg7 => HEX0);

END;


ENTITY spinwheel IS
	PORT(
		fast_clock : IN  STD_LOGIC;  -- This will be a 27 Mhz Clock
		resetb : IN  STD_LOGIC;      -- asynchronous reset
		spin_result  : OUT UNSIGNED(5 downto 0));  -- current value of the wheel
END;


ENTITY seg7_hex_test IS
	GENERIC(REGISTER6: INTEGER := 6);
	PORT(
          SW : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);  
          HEX0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END;