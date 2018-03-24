-- THIS ENTITY ONLY SUPPORTS 12 bit hex input
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY hex2dec IS PORT(
	hex_value : in unsigned(11 downto 0);
	ones : out unsigned(3 downto 0);
	tens : out unsigned(3 downto 0);
	hundreds : out unsigned(3 downto 0);
	thousands : out unsigned(3 downto 0)
	);
END entity hex2dec;

ARCHITECTURE behavioural OF hex2dec IS
begin
	process(hex_value)
	-- we choose integer because we are not concerned with the # of bits during our arithmetic operations
	variable t1000, t100, t10, t1 : integer;
	variable DEC_Sum : integer;
	variable DEC_Remain : integer;
	begin
		t1000 := 0;
		t100 := 0;
		t10 := 0;
		t1 := 0;
		
		-- sum in decimal
		DEC_Sum := to_integer(hex_value(3 downto 0));
		DEC_Sum := DEC_Sum + (to_integer(hex_value(7 downto 4)) * 16);
		DEC_Sum := DEC_Sum + (to_integer(hex_value(11 downto 8)) * 256);
		
		-- Since shift_right/left() only support arithmetic shift, its easier to just /1000
		-- https://www.nandland.com/vhdl/examples/example-shifts.html
		t1000 := DEC_Sum/1000;
		t100 := (DEC_Sum - (t1000*1000))/100;
		t10 := (DEC_Sum - (t1000*1000) - (t100*100))/10;
		t1 := DEC_Sum - (t1000*1000) - (t100*100) - (t10*10);

		-- output
		thousands <= to_unsigned(t1000, 4);
		hundreds <= to_unsigned(t100, 4);
		tens <= to_unsigned(t10, 4);
		ones <= to_unsigned(t1, 4);
	end process;
end architecture behavioural;
