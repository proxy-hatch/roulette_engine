LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

LIBRARY WORK;
USE WORK.ALL;

--------------------------------------------------------------
--
--  This is a testbench you can use to test the win subblock in Modelsim.
--  The testbench repeatedly applies test vectors and checks the output to
--  make sure they match the expected values.  You can use this without
--  modification (unless you want to add more test vectors, which is not a
--  bad idea).  However, please be sure you understand it before trying to
--  use it in Modelsim.
--
---------------------------------------------------------------

ENTITY win_tb IS
  -- no inputs or outputs
END win_tb;

-- The architecture part decribes the behaviour of the test bench

ARCHITECTURE behavioural OF win_tb IS

   -- We will use an array of records to hold a list of test vectors and expected outputs.
   -- This simplifies adding more tests; we just have to add another line in the array.
   -- Each element of the array is a record that corresponds to one test vector.
   
   -- Define the record that describes one test vector
   
   TYPE test_case_record IS RECORD
      spin_result_latched : unsigned(5 downto 0); 
      bet1_value : unsigned(5 downto 0); 
      bet2_colour : std_logic;                
      bet3_dozen : unsigned(1 downto 0);
      expected_bet1_wins : std_logic;
      expected_bet2_wins : std_logic;
      expected_bet3_wins : std_logic;
   END RECORD;

   -- Define a type that is an array of the record.

   TYPE test_case_array_type IS ARRAY (0 to 8) OF test_case_record;
     
   -- Define the array itself.  We will initialize it, one line per test vector.
   -- If we want to add more tests, or change the tests, we can do it here.
   -- Note that each line of the array is one record, and the 7 numbers in each
   -- line correspond to the 7 entries in the record.  Four of these entries 
   -- represent inputs to apply, and three represent the expected outputs.
    
   signal test_case_array : test_case_array_type := (
             ("010011", "010010", '0', "00",   '0', '0', '0'),
             ("010011", "010011", '0', "00",   '1', '0', '0'),
             ("010011", "010010", '1', "00",   '0', '1', '0'),
             ("010011", "010010", '0', "01",   '0', '0', '1'),
             ("100000", "100000", '1', "00",   '1', '1', '0'),
             ("100000", "100001", '1', "10",   '0', '1', '1'),             
             ("100000", "100000", '1', "10",   '1', '1', '1'),                           
             ("000000", "000000", '1', "00",   '1', '0', '0'),   
             ("000000", "000001", '0', "00",   '0', '0', '0')
             );             

  -- Define the win subblock, which is the component we are testing

  COMPONENT win IS
	  PORT(spin_result_latched : in unsigned(5 downto 0);
             bet1_value : in unsigned(5 downto 0);
             bet2_colour : in std_logic;
             bet3_dozen : in unsigned(1 downto 0);
             bet1_wins : out std_logic;
             bet2_wins : out std_logic;
             bet3_wins : out std_logic);
   END COMPONENT;

   -- local signals we will use in the testbench 

   SIGNAL spin_result_latched : unsigned(5 downto 0) := "000000";
   SIGNAL bet1_value : unsigned(5 downto 0) := "000000";
   SIGNAL bet2_colour : std_logic := '0';
   SIGNAL bet3_dozen : unsigned(1 downto 0) := "00";
   SIGNAL bet1_wins : std_logic;
   SIGNAL bet2_wins : std_logic;
   SIGNAL bet3_wins : std_logic;

begin

   -- instantiate the design-under-test

   dut : win PORT MAP(
            spin_result_latched => spin_result_latched,
            bet1_value => bet1_value,
            bet2_colour => bet2_colour,
            bet3_dozen => bet3_dozen,
            bet1_wins => bet1_wins,
            bet2_wins => bet2_wins,
            bet3_wins => bet3_wins);

   -- Code to drive inputs and check outputs.  This is written by one process.
   -- Note there is nothing in the sensitivity list here; this means the process is
   -- executed at time 0.  It would also be restarted immediately after the process
   -- finishes, however, in this case, the process will never finish (because there is
   -- a wait statement at the end of the process).

   process
   begin   
       
      -- starting values for simulation.  Not really necessary, since we initialize
      -- them above anyway

      spin_result_latched <= to_unsigned(0, spin_result_latched'length);
      bet1_value <= to_unsigned(0, bet1_value'length);
      bet2_colour <= '0';
      bet3_dozen <= to_unsigned(0, bet3_dozen'length);

      -- Loop through each element in our test case array.  Each element represents
      -- one test case (along with expected outputs).
      
      for i in test_case_array'low to test_case_array'high loop
        
        -- Print information about the testcase to the transcript window (make sure when
        -- you run this, your transcript window is large enough to see what is happening)
        
        report "-------------------------------------------";
        report "Test case " & integer'image(i) & ":" &
                 " spin_result=" & integer'image(to_integer(test_case_array(i).spin_result_latched)) & 
                 " bet1_value=" & integer'image(to_integer(test_case_array(i).bet1_value)) &
                 " bet2_colour=" & std_logic'image(test_case_array(i).bet2_colour) &
                 " bet3_dozen=" & integer'image(to_integer(test_case_array(i).bet3_dozen));

        -- assign the values to the inputs of the DUT (design under test)
        
        spin_result_latched <= test_case_array(i).spin_result_latched;
        bet1_value <= test_case_array(i).bet1_value;
        bet2_colour <= test_case_array(i).bet2_colour;
        bet3_dozen <= test_case_array(i).bet3_dozen;                 

        -- wait for some time, to give the DUT circuit time to respond (1ns is arbitrary)                

        wait for 1 ns;
        
        -- now print the results along with the expected results
      
        report "Expected result: bet1_wins=" & std_logic'image(test_case_array(i).expected_bet1_wins) &
                              "  bet2_wins=" & std_logic'image(test_case_array(i).expected_bet2_wins) &
                              "  bet3_wins=" & std_logic'image(test_case_array(i).expected_bet3_wins);
        report "Observed result: bet1_wins=" & std_logic'image(bet1_wins) &
                              "  bet2_wins=" & std_logic'image(bet2_wins) &
                              "  bet3_wins=" & std_logic'image(bet3_wins);

        -- This assert statement causes a fatal error if there is a mismatch
                                                                    
        assert (bet1_wins = test_case_array(i).expected_bet1_wins AND
                bet2_wins = test_case_array(i).expected_bet2_wins AND
                bet3_wins = test_case_array(i).expected_bet3_wins)
            report "MISMATCH.  THERE IS A PROBLEM IN YOUR DESIGN THAT YOU NEED TO FIX"
            severity failure;
      end loop;
                                           
      report "================== ALL TESTS PASSED =============================";
                                                                              
      wait; --- we are done.  Wait for ever
    end process;
end behavioural;