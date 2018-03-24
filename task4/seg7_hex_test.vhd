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

ENTITY seg7_hex_test IS
	PORT(
          SW : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);  
          HEX0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END;


ARCHITECTURE behavioral OF seg7_hex_test IS
BEGIN
	digit7seg_block: ENTITY work.digit7seg PORT MAP(digit => SW, seg7 => HEX0);

END;
