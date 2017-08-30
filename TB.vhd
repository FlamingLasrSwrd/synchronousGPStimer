--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   04:46:59 10/31/2012
-- Design Name:   
-- Module Name:   /home/edunn/timer/TB.vhd
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
 
ENTITY TB IS
END TB;
 
ARCHITECTURE behavior OF TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT timer
    PORT(
         gps_reset : IN  std_logic;
         trig_A : IN  std_logic;
         trig_B : IN  std_logic;
         clock100 : IN  std_logic;
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
   signal clock100 : std_logic := '0';

 	--Outputs
   signal iTime_A : std_logic_vector(24 downto 0);
   signal iTime_B : std_logic_vector(24 downto 0);
   signal TDC_A : std_logic_vector(24 downto 0);
   signal TDC_B : std_logic_vector(24 downto 0);

   -- Clock period definitions
   constant clock100_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: timer PORT MAP (
          gps_reset => gps_reset,
          trig_A => trig_A,
          trig_B => trig_B,
          clock100 => clock100,
          iTime_A => iTime_A,
          iTime_B => iTime_B,
          TDC_A => TDC_A,
          TDC_B => TDC_B
        );

   -- Clock process definitions
   clock100_process :process
   begin
		clock100 <= '0';
		wait for clock100_period/2;
		clock100 <= '1';
		wait for clock100_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clock100_period*10;

      -- insert stimulus here 
		wait for 1 us;
		trig_A <= '1';
		wait for 5 us;
		trig_A <= '0';
		wait for 10 us;
		trig_B <= '1';
		wait for 1 us;
		trig_B <= '0';
		gps_reset <= '1';
      wait;
		
   end process;

END;
