----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:19:27 10/05/2012 
-- Design Name: 
-- Module Name:    Sync_Count_25 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Sync_Count_25 is
    Port ( reset : in  STD_LOGIC;
           clock : in  STD_LOGIC;
           Q : out  STD_LOGIC_VECTOR (24 downto 0));
end Sync_Count_25;

architecture Behavioral of Sync_Count_25 is
	signal Pre_Q: std_logic_vector(24 downto 0);
begin
	process(clock, count, reset)
	begin
		if reset = '1' then
			Pre_Q <= Pre_Q - Pre_Q;
			elsif (clock='1' and clock'event) then --increment at rising edge of clock
				Pre_Q <= Pre_Q + 1;
		end if;
	end process;
	
	Q <= Pre_Q;
end Behavioral;

