----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:30:38 12/03/2012 
-- Design Name: 
-- Module Name:    iTime - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--		Synchronized time to rising edge latch with reset.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity iTime is
	GENERIC (
		b_width	: INTEGER := 25;
		a_bit		: STD_LOGIC := '1');	--MSB address associated with channel
	Port ( 
		trig 	: in STD_LOGIC;	--synchronous trigger
		rs		: IN STD_LOGIC:='0';	--asynchronous reset
		clk	: IN STD_LOGIC;	--synchronous clock
      d 		: in STD_LOGIC_VECTOR (b_width-1 downto 0); -- bit counter
		q		: out STD_LOGIC_VECTOR (b_width downto 0)); --time to rising edge
end iTime;

architecture Behavioral of iTime is

BEGIN
	PROCESS(rs, clk)
	BEGIN
		IF rs = '1' THEN
			q <= (OTHERS => '0');
		ELSIF rising_edge(clk) THEN
			IF trig = '1' THEN
				q <= a_bit & d;
			END IF;
		END IF;
	END PROCESS;
END Behavioral;

