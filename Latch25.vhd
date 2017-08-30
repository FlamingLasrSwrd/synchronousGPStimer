----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:12:54 10/05/2012 
-- Design Name: 
-- Module Name:    Latch25 - Behavioral 
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

entity Latch25 is
    Port ( data_in : in  STD_LOGIC_VECTOR (24 downto 0);
           data_out : out  STD_LOGIC_VECTOR (24 downto 0);
           enable : in  STD_LOGIC);
end Latch25;

architecture Behavioral of Latch25 is
begin
	process(data_in, enable)
	begin
		if(enable="1" and enable'event) then --output at rising edge of enable
			data_out <= data_in;
		end if;
	end process;
end Behavioral;

