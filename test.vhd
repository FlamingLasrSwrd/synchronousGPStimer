--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:46:35 10/31/2012
-- Design Name:   
-- Module Name:   /home/edunn/timer/Test.vhd
-- Project Name:  timer
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: timer
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY Test IS
END Test;
 
ARCHITECTURE behavior OF Test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT timer
    PORT(
         gps_reset : IN  std_logic;
         trig_A : IN  std_logic;
         trig_B : IN  std_logic;
         clock20 : IN  std_logic;
         iTime_A : OUT  std_logic_vector(24 downto 0);
         iTime_B : OUT  std_logic_vector(24 downto 0);
         TDC_A : OUT  std_logic_vector(24 downto 0);
         TDC_B : OUT  std_logic_vector(24 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal gps_reset : std_logic := '0';
   signal trig_A : std_logic := '0';
   signal trig_B : std_logic := '0';
   signal clock20 : std_logic := '0';

 	--Outputs
   signal iTime_A : std_logic_vector(24 downto 0);
   signal iTime_B : std_logic_vector(24 downto 0);
   signal TDC_A : std_logic_vector(24 downto 0);
   signal TDC_B : std_logic_vector(24 downto 0);

   -- Clock period definitions
   constant clock20_period : time := 50 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: timer PORT MAP (
          gps_reset => gps_reset,
          trig_A => trig_A,
          trig_B => trig_B,
          clock20 => clock20,
          iTime_A => iTime_A,
          iTime_B => iTime_B,
          TDC_A => TDC_A,
          TDC_B => TDC_B
        );

   -- Clock process definitions
   clock20_process :process
   begin
		clock20 <= '0';
		wait for clock20_period/2;
		clock20 <= '1';
		wait for clock20_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clock20_period*10;
		--total wait time = 600ns

      -- insert stimulus here 

		--gps 1s signal
		gps_reset <= '1';
		wait for 10 ns;
		gps_reset <= '0';
		
		wait for 500 ns;
		trig_A <= '1'; --iTime_A = 0b10110
		wait for 1 us;
		trig_B <= '1'; --iTime_B = 0b101010
		wait for 20 us;
		trig_B <= '0'; --TDC_B = 0b110010000
		wait for 200 us;
		trig_A <= '0'; --TDC_A = 0b1000101000100
		wait for 10 us;
		trig_B <= '1'; --iTimeB = 0b1001000100010
		wait for 14 us;
		trig_B <= '0'; --TDC_B = 0b100011000
		wait for 10 us;
		gps_reset <= '1';
		wait for 10 ns;
		gps_reset <= '0';
		

      wait;
   end process;

END;
