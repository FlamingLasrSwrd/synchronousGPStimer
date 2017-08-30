----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:13:17 10/05/2012 
-- Design Name: 
-- Module Name:    timer - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Assumptions: 
--		The events occur for less than one second.
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_logic_unsigned.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity timer is
    port ( gps_reset : in  STD_LOGIC;
           trig_A : in  STD_LOGIC;
           trig_B : in  STD_LOGIC;
           clock20 : in  STD_LOGIC;
           iTime_A : out  STD_LOGIC_VECTOR (24 downto 0);
           iTime_B : out  STD_LOGIC_VECTOR (24 downto 0);
           TDC_A : out  STD_LOGIC_VECTOR (24 downto 0);
           TDC_B : out  STD_LOGIC_VECTOR (24 downto 0));
end timer;

architecture Behavioral of timer is
	signal global, iTimeA, iTimeB : STD_LOGIC_VECTOR (24 downto 0);
	constant bit_1s : STD_LOGIC_VECTOR (24 downto 0):= "1001100010010110100000000"; --50MHz
	component bitcounter
		port ( clk : in  STD_LOGIC;
			reset : in  STD_LOGIC;
         bitout : out  STD_LOGIC_VECTOR (24 downto 0));
	end component;
	
begin
	gps_time: bitcounter port map (clock20, gps_reset, global);
	
	LatchA: process (trig_A)
	begin
		if (trig_A = '1') then --rising edge
			iTime_A <= global;
			iTimeA <= global; --temp for TDC comparison and calculation
		end if;
		if (trig_A = '0') then --falling edge
			if (global < glob_A) then	--if the GPS has reset the global clock during detection
			TDC_A <= (bit_1s - iTimeA + global);
			end if;
			TDC_A <= (global-iTimeA);
		end if;
	end process;
	
	LatchB: process (trig_B) --Same process as LatchA
	begin
		if (trig_B = '1') then
			iTime_B <= global;
			iTimeB <= global;
		end if;
		if (trig_B = '0') then
			if (global < glob_B) then
			TDC_B <= (bit_1s - iTimeB + global);
			end if;
			TDC_B <= (global-iTimeB);
		end if;
	end process;
end Behavioral;
