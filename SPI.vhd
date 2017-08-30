----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:14:12 12/03/2012 
-- Design Name: 
-- Module Name:    SPI - Behavioral 
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

entity SPI is
	GENERIC (
		cpol		: STD_LOGIC := '0';	--spi clock polarity mode
		cpha		: STD_LOGIC := '0';	--spi clock phase mode
		b_width	: INTEGER := 25		--data width in bits; MSB reserved for channel select
	);
	Port ( 
		tx_en 	: in  STD_LOGIC;										--transmit enable
		tx_data 	: in  STD_LOGIC_VECTOR (b_width downto 0);	--transmit data
      rx_en 	: out  STD_LOGIC := '0';							--receive request
      rx_data 	: out  STD_LOGIC_VECTOR (b_width downto 0);	--receive data
		rrdy		: OUT STD_LOGIC := '0';			--received data present on rx_data line
		busy		: OUT STD_LOGIC := '0';			--transmission status
      miso 		: out  STD_LOGIC;					--master in slave out
      mosi 		: in  STD_LOGIC;					--master out slave in
      ss 		: in  STD_LOGIC;					--active low slave select
		sclk		: IN STD_LOGIC;					--master clock
      int 		: out  STD_LOGIC := '1');		--active low interrupt (slave transmit ready)
end SPI;

architecture Behavioral of SPI is
	SIGNAL clk		: STD_LOGIC; --write only rising edge clock signal
	SIGNAL rx_buf	: STD_LOGIC_VECTOR(b_width downto 0);

BEGIN
	busy <= NOT(ss);

	--adjust clock so writes are on rising edge and reads on falling edge
	mode <= cpol XOR cpha;  --'1' for modes that write on rising edge
	WITH mode SELECT
		clk <= sclk WHEN '1',
			NOT sclk WHEN OTHERS;

	--receive data
	PROCESS
		
	END PROCESS;
	
	--Fulfill request for received data
	PROCESS(rx_en, ss)
		IF(ss = '1' AND rx_en = 1) THEN
			rx_data <= rx_buf;
			rrdy <= '0'; --received data cleared
		END IF;
	END PROCESS;
	
	--transmit data
	PROCESS(tx_en, ss, clk)
		IF tx_en = '1' THEN
			int <= '0';			--flag master ready to transmit
			FOR i IN 0 TO d_width LOOP
				IF ss = '0' AND rising_edge(clk) THEN
				miso <= tx_data(d_width-i);
				END IF;
			END LOOP;
		END IF;
	END PROCESS;

end Behavioral;

