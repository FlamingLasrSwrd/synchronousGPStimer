--------------------------------------------------------------------------------
--
--   FileName:         spi_slave.vhd
--   Dependencies:     none
--   Design Software:  Quartus II 32-bit Version 11.1 Build 173 SJ Full Version
--
--   HDL CODE IS PROVIDED "AS IS."  DIGI-KEY EXPRESSLY DISCLAIMS ANY
--   WARRANTY OF ANY KIND, WHETHER EXPRESS OR IMPLIED, INCLUDING BUT NOT
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
--   PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL DIGI-KEY
--   BE LIABLE FOR ANY INCIDENTAL, SPECIAL, INDIRECT OR CONSEQUENTIAL
--   DAMAGES, LOST PROFITS OR LOST DATA, HARM TO YOUR EQUIPMENT, COST OF
--   PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR SERVICES, ANY CLAIMS
--   BY THIRD PARTIES (INCLUDING BUT NOT LIMITED TO ANY DEFENSE THEREOF),
--   ANY CLAIMS FOR INDEMNITY OR CONTRIBUTION, OR OTHER SIMILAR COSTS.
--
--   Version History
--   Version 1.0 7/5/2012 Scott Larson
--     Initial Public Release
--
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY spi_slave IS
  GENERIC(
    cpol    : STD_LOGIC := '0';  --spi clock polarity mode
    cpha    : STD_LOGIC := '0';  --spi clock phase mode
    d_width : INTEGER := 8);     --data width in bits
  PORT(
		sclk         	: 	IN     STD_LOGIC;  --spi clk from master
		ss_n         	: 	IN     STD_LOGIC;  --active low slave select
		mosi         	: 	IN     STD_LOGIC;  --master out, slave in
		tx_load_en   	: 	IN     STD_LOGIC;  --asynchronous transmit buffer load enable
		tx_load_data 	: 	IN     STD_LOGIC_VECTOR(d_width-1 DOWNTO 0);  --asynchronous tx data to load
		rx_data      	: 	OUT    STD_LOGIC_VECTOR(d_width-1 DOWNTO 0) := (OTHERS => '0');  --receive register output to logic
		rrdy				:	OUT 	STD_LOGIC;	--'1' when received data but not requested
		busy         	: 	OUT    STD_LOGIC := '0';  --busy signal to logic ('1' during transaction)
		miso         	:	OUT    STD_LOGIC := 'Z'); --master in, slave out
END spi_slave;

ARCHITECTURE logic OF spi_slave IS
  SIGNAL mode    	: STD_LOGIC;  --groups modes by clock polarity relation to data
  SIGNAL clk     	: STD_LOGIC;  --clock
  SIGNAL bit_cnt 	: STD_LOGIC_VECTOR(d_width-1 DOWNTO 0);  --'1' for active transaction bit
  SIGNAL rx_buf  	: STD_LOGIC_VECTOR(d_width-1 DOWNTO 0) := (OTHERS => '0');  --receiver buffer
  SIGNAL tx_buf  	: STD_LOGIC_VECTOR(d_width-1 DOWNTO 0) := (OTHERS => '0');  --transmit buffer
BEGIN
	busy <= NOT ss_n;  --high during transactions

  --adjust clock so writes are on rising edge and reads on falling edge
	mode <= cpol XOR cpha;  --'1' for modes that write on rising edge
	WITH mode SELECT
		clk <= sclk WHEN '1',
			NOT sclk WHEN OTHERS;

  --keep track of miso/mosi bit counts for data alignmnet
	PROCESS(ss_n, clk)
	BEGIN
		IF(ss_n = '0') THEN											--this slave is selected
      IF(rising_edge(clk)) THEN                         	--new bit on miso/mosi
        bit_cnt <= '0' & bit_cnt(d_width-1 DOWNTO 1);   	--shift active bit indicator
		END IF;
		ELSE                                                         --this slave is not selected
			bit_cnt <= (conv_integer(NOT cpha) => '1', OTHERS => '0'); --reset miso/mosi bit count
		END IF;
	END PROCESS;

--Receive data from master over mosi; read bit when ss_n and clk are low; MSB bit first;
	Receive: PROCESS(ss_n, clk)
	BEGIN
		IF (ss_n = '0' AND falling_edge(clk)) THEN --mosi bit set
			rx_buf(d_width-1-i) <= mosi;
		END IF;
		IF  THEN
			rx_data <= rx_buf;
			rrdy <='1';
		END IF;
	 END

    --transmit registers
    IF(ss_n = '1' AND tx_load_en = '1') THEN  --load transmit register from user logic
      tx_buf <= tx_load_data;
    ELSIF(rd_add = '0' AND bit_cnt(7 DOWNTO 0) = "00000000" AND bit_cnt(d_width+8) = '0' AND rising_edge(clk)) THEN
      tx_buf(d_width-1 DOWNTO 0) <= tx_buf(d_width-2 DOWNTO 0) & tx_buf(d_width-1);  --shift through tx data
    END IF;

    --miso output register
    IF(ss_n = '1') THEN                            --no transaction occuring
      miso <= 'Z';
    ELSIF(rd_add = '1' AND rising_edge(clk)) THEN  --write status register to master
      CASE bit_cnt(10 DOWNTO 8) IS
        WHEN "001" => miso <= trdy;
        WHEN "010" => miso <= rrdy;
        WHEN "100" => miso <= roe;
        WHEN OTHERS => NULL;
      END CASE;
    ELSIF(rd_add = '0' AND bit_cnt(7 DOWNTO 0) = "00000000" AND bit_cnt(d_width+8) = '0' AND rising_edge(clk)) THEN
      miso <= tx_buf(d_width-1);                  --send transmit register data to master
    END IF;
    
  END PROCESS;
END logic;
