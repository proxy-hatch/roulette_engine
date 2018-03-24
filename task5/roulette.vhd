LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
 
LIBRARY WORK;
USE WORK.ALL;

----------------------------------------------------------------------
--
--  This is the top level template for Lab 2.  Use the schematic on Page 4
--  of the lab handout to guide you in creating this structural description.
--  The combinational blocks have already been designed in previous tasks,
--  and the spinwheel block is given to you.  Your task is to combine these
--  blocks, as well as add the various registers shown on the schemetic, and
--  wire them up properly.  The result will be a roulette game you can play
--  on your DE2.
--
-----------------------------------------------------------------------

ENTITY roulette IS
	PORT(   CLOCK_50 : IN STD_LOGIC; -- the fast clock for spinning wheel
		KEY : IN STD_LOGIC_VECTOR(3 downto 0);  -- includes slow_clock and reset
		SW : IN STD_LOGIC_VECTOR(17 downto 0);
		LEDG : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);  -- ledg
		HEX7 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 7
		HEX6 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 6
		-- HEX5 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 5
		-- HEX4 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 4
		HEX3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 3
		HEX2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 2
		HEX1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 1
		HEX0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)   -- digit 0
	);
END roulette;


ARCHITECTURE structural OF roulette IS
 --- Your code goes here
signal resetb, slow_clock, bet2_colour, bet1_wins, bet2_wins, bet3_wins : std_logic;
signal spin_result, spin_result_latched, bet1_value : unsigned(5 downto 0);
signal bet3_dozen : unsigned(1 downto 0);
signal money, new_money : unsigned(11 downto 0);
-- challenge
signal money_DEC_1, money_DEC_10, money_DEC_100, money_DEC_1000 : unsigned(3 downto 0);
signal spin_result_DEC_1, spin_result_DEC_10 : unsigned(3 downto 0);

signal bet1_amount, bet2_amount, bet3_amount : unsigned(2 downto 0);
begin
	DEBOUNCE_RESETB : entity work.debounce port map (key => key(1), CLOCK_50 => CLOCK_50, debounced_key => resetb);
	DEBOUNCE_SLOW_CLOCK : entity work.debounce port map (key => key(0), CLOCK_50 => CLOCK_50, debounced_key => slow_clock);
	
	SPINWHEEL : entity work.spinwheel port map (fast_clock => CLOCK_50, resetb => resetb, spin_result => spin_result);
	WIN : entity work.win port map (spin_result_latched, bet1_value, bet2_colour, bet3_dozen, bet1_wins, bet2_wins, bet3_wins);

	-- -- Spin Result HEX Displays
	-- HEX_DISP6 : entity work.digit7seg port map (digit => spin_result_latched(3 downto 0), seg7 => HEX6);
	-- HEX_DISP7 : entity work.digit7seg port map (digit => "00" & spin_result_latched(5 downto 4), seg7 => HEX7);

	-- -- Money HEX Displays
	-- HEX_DISP0 : entity work.digit7seg port map (digit => new_money(3 downto 0), seg7 => HEX0);
	-- HEX_DISP1 : entity work.digit7seg port map (digit => new_money(7 downto 4), seg7 => HEX1);
	-- HEX_DISP2 : entity work.digit7seg port map (digit => new_money(11 downto 8), seg7 => HEX2);
	-- -- turn off HEX3
	-- HEX_DISP3 : entity work.digit7seg port map (digit => "0000", seg7 => HEX3);
	
	-- Spin Result DEC Displays
	DEC_SPINWHEEL : entity work.hex2dec port map (hex_value => "000000" & spin_result_latched, ones => spin_result_DEC_1, tens => spin_result_DEC_10, hundreds => open, thousands => open);	-- open means we dont care
	DEC_HEX_DISP6 : entity work.digit7seg port map (digit => spin_result_DEC_1, seg7 => HEX6);
	DEC_HEX_DISP7 : entity work.digit7seg port map (digit => spin_result_DEC_10, seg7 => HEX7);
	
	-- Money DEC Display
	DEC_NEW_BALANCE : entity work.hex2dec port map (hex_value => new_money, ones => money_DEC_1, tens => money_DEC_10, hundreds => money_DEC_100, thousands => money_DEC_1000);
	DEC_HEX_DISP0 : entity work.digit7seg port map (digit => money_DEC_1, seg7 => HEX0);
	DEC_HEX_DISP1 : entity work.digit7seg port map (digit => money_DEC_10, seg7 => HEX1);
	DEC_HEX_DISP2 : entity work.digit7seg port map (digit => money_DEC_100, seg7 => HEX2);
	DEC_HEX_DISP3 : entity work.digit7seg port map (digit => money_DEC_1000, seg7 => HEX3);

	-- balance update
	NEW_BALANCE : entity work.new_balance port map (money, bet1_amount, bet2_amount, bet3_amount, bet1_wins, bet2_wins, bet3_wins, new_money);
	
	-- LEDs
	LEDG(0) <= bet1_wins;
	LEDG(1) <= bet2_wins;
	LEDG(2) <= bet3_wins;
	
	REGISTERS : process(resetb, slow_clock)
	begin
		if resetb = '0' then		-- reg10 is loaded with $32, all other regs cleared
			spin_result_latched <= (others => '0');
			bet1_value <= (others => '0');
			bet2_colour <= '0';
			bet3_dozen <= (others => '0');
			bet1_amount <= (others => '0');
			bet2_amount <= (others => '0');
			bet3_amount <= (others => '0');
			money <= to_unsigned(32, 12);
		elsif rising_edge(slow_clock) then
			spin_result_latched <= spin_result;
			bet1_value <= unsigned(sw(8 downto 3));
			bet2_colour <= sw(12);
			bet3_dozen <= unsigned(sw(17 downto 16));
			(bet1_amount) <= unsigned(sw(2 downto 0));
			(bet2_amount) <= unsigned(sw(11 downto 9));
			(bet3_amount) <= unsigned(sw(15 downto 13));
			money <= new_money;
		end if;
	end process REGISTERS;
END;
