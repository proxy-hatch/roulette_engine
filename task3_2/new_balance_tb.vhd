LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

LIBRARY WORK;
USE WORK.ALL;

--------------------------------------------------------------
--
--  This is a testbench you can use to test the new_balance subblock in Modelsim.
--  The testbench repeatedly applies test vectors and checks the output to
--  make sure they match the expected values.  You can use this without
--  modification (unless you want to add more test vectors, which is not a
--  bad idea).  However, please be sure you understand it before trying to
--  use it in Modelsim.
--
---------------------------------------------------------------

ENTITY new_balance_tb IS
  -- no inputs or outputs
END new_balance_tb;

-- The architecture part decribes the behaviour of the test bench

ARCHITECTURE behavioural OF new_balance_tb IS

   -- We will use an array of records to hold a list of test vectors and expected outputs.
   -- This simplifies adding more tests; we just have to add another line in the array.
   -- Each element of the array is a record that corresponds to one test vector.
   
   -- Define the record that describes one test vector
   
   TYPE test_case_record IS RECORD
       money : unsigned(11 downto 0);
       value1 : unsigned(2 downto 0);
       value2 : unsigned(2 downto 0);
       value3 : unsigned(2 downto 0);
       bet1_wins : std_logic;
       bet2_wins : std_logic;
       bet3_wins : std_logic;
       expected_new_money : unsigned(11 downto 0);
   END RECORD;

   -- Define a type that is an array of the record.

   TYPE test_case_array_type IS ARRAY (0 to 8) OF test_case_record;
     
   -- Define the array itself.  We will initialize it, one line per test vector.
   -- If we want to add more tests, or change the tests, we can do it here.
   -- Note that each line of the array is one record, and the 8 numbers in each
   -- line correspond to the 8 entries in the record.  Seven of these entries 
   -- represent inputs to apply, and one represents the expected output.
    
   signal test_case_array : test_case_array_type := (
        (to_unsigned(16,12), "000", "000", "000", '1', '1', '1',  to_unsigned(16,12)),
        (to_unsigned(64,12), "000", "000", "000", '0', '0', '0',  to_unsigned(64,12)),
        (to_unsigned(16,12), "010", "010", "010", '0', '0', '0',  to_unsigned(10,12)),
        (to_unsigned(32,12), "011", "001", "010", '1', '0', '0',  to_unsigned(134,12)),
        (to_unsigned(32,12), "011", "001", "010", '0', '1', '0',  to_unsigned(28,12)),
        (to_unsigned(32,12), "011", "001", "100", '0', '0', '1',  to_unsigned(36,12)),                      
        (to_unsigned(94,12), "110", "011", "100", '1', '1', '0',  to_unsigned(303,12)),  
        (to_unsigned(56,12), "011", "001", "100", '1', '0', '1',  to_unsigned(168,12)),  
        (to_unsigned(12,12), "011", "111", "101", '0', '1', '1',  to_unsigned(26,12))   
             );             

  -- Define the new_balance subblock, which is the component we are testing

  COMPONENT new_balance IS
      PORT(money : in unsigned(11 downto 0);
          value1 : in unsigned(2 downto 0);
          value2 : in unsigned(2 downto 0);
          value3 : in unsigned(2 downto 0);
          bet1_wins : in std_logic;
          bet2_wins : in std_logic;
          bet3_wins : in std_logic;
          new_money : out unsigned(11 downto 0));
   END COMPONENT;

   -- local signals we will use in the testbench 

   SIGNAL money : unsigned(11 downto 0) := x"000"; 
   SIGNAL value1 : unsigned(2 downto 0) := "000";
   SIGNAL value2 : unsigned(2 downto 0) := "000";
   SIGNAL value3 : unsigned(2 downto 0) := "000";
   SIGNAL bet1_wins : std_logic := '0';
   SIGNAL bet2_wins : std_logic := '0';
   SIGNAL bet3_wins : std_logic := '0';
   SIGNAL new_money : unsigned(11 downto 0); 

begin

   -- instantiate the design-under-test

   dut : new_balance PORT MAP(
          money => money,
          value1 => value1,
          value2 => value2,
          value3 => value3,
          bet1_wins => bet1_wins,
          bet2_wins => bet2_wins,
          bet3_wins => bet3_wins,
          new_money => new_money);


   -- Code to drive inputs and check outputs.  This is written by one process.
   -- Note there is nothing in the sensitivity list here; this means the process is
   -- executed at time 0.  It would also be restarted immediately after the process
   -- finishes, however, in this case, the process will never finish (because there is
   -- a wait statement at the end of the process).

   process
   begin   
       
      -- starting values for simulation.  Not really necessary, since we initialize
      -- them above anyway

      money <= x"000"; 
      value1 <= "000";
      value2 <= "000";
      value3 <= "000";
      bet1_wins <= '0';
      bet2_wins <= '0';
      bet3_wins <= '0';
    
      -- Loop through each element in our test case array.  Each element represents
      -- one test case (along with expected outputs).
      
      for i in test_case_array'low to test_case_array'high loop
        
        -- Print information about the testcase to the transcript window (make sure when
        -- you run this, your transcript window is large enough to see what is happening)
        
        report "-------------------------------------------";
        report "Test case " & integer'image(i) & ":" &
                 " money=" & integer'image(to_integer(test_case_array(i).money)) &
                 " value1=" & integer'image(to_integer(test_case_array(i).value1)) & 
                 " value2=" & integer'image(to_integer(test_case_array(i).value2)) & 
                 " value3=" & integer'image(to_integer(test_case_array(i).value3)) & 
                 " bet1_wins=" & std_logic'image(test_case_array(i).bet1_wins) & 
                 " bet2_wins=" & std_logic'image(test_case_array(i).bet2_wins) & 
                 " bet3_wins=" & std_logic'image(test_case_array(i).bet3_wins);

        -- assign the values to the inputs of the DUT (design under test)

        money <= test_case_array(i).money; 
        value1 <= test_case_array(i).value1;
        value2 <= test_case_array(i).value2;
        value3 <= test_case_array(i).value3;
        bet1_wins <= test_case_array(i).bet1_wins;
        bet2_wins <= test_case_array(i).bet2_wins;
        bet3_wins <= test_case_array(i).bet3_wins;              

        -- wait for some time, to give the DUT circuit time to respond (1ns is arbitrary)                

        wait for 1 ns;
        
        -- now print the results along with the expected results
        
        report "Expected result= " &  
                    integer'image(to_integer(test_case_array(i).expected_new_money)) &
               "  Actual result= " &  
                    integer'image(to_integer(new_money));

        -- This assert statement causes a fatal error if there is a mismatch
                                                                    
        assert (test_case_array(i).expected_new_money = new_money )
            report "MISMATCH.  THERE IS A PROBLEM IN YOUR DESIGN THAT YOU NEED TO FIX"
            severity failure;
      end loop;
                                           
      report "================== ALL TESTS PASSED =============================";
                                                                              
      wait; --- we are done.  Wait for ever
    end process;
end behavioural;