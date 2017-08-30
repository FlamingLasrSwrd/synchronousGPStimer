-------------------------------------------------------------------------------
-- Created By: Elijah K Dunn
-- University of Kansas Physics Dept
-- Create Date:    21:13:17 10/05/2012 
-- Design Name:	Timer Module
-- Project Name:	SATRA
-- Target Devices: CoolRunner II CPLDs; Digilent Nexys 3 FPGA
-- Description: 
--		VHDL implementation of a timing module for a two channel SATRA antenna 
--		system. The output from a trigger channel is converted to iTime (time 
--		until rising edge) using a bit counter. The input clock signal determines
--		resolution. One clock pulse = one bit of a 25-bit number. The bit counter
--		is reset by a one pulse per second output from a GPS module.
--		MSB of SPI output indicates channel A ('1') or channel B ('0') data.
-- Assumptions: 
-- Revision: V.02
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


	
ENTITY Timer IS
	PORT (
		gpsrs : IN  STD_LOGIC; --1 pps active high reset input from GPS module
		clk 	: IN STD_LOGIC; --clock for counter
		triga : IN  STD_LOGIC; --trigger signal channel A
		trigb : IN  STD_LOGIC; --trigger signal channel B
--SPI interface with interrupt
		sclk 	: IN STD_LOGIC; --serial clock from master		
		mosi 	: IN STD_LOGIC; --master out slave in
		miso 	: OUT STD_LOGIC; --master in slave out
		ss 	: IN STD_LOGIC; --active low slave select
		int 	: OUT STD_LOGIC := '1' --active low data ready signal to master
		);
END Timer;

ARCHITECTURE Structural OF Timer IS

	CONSTANT cpol: STD_LOGIC := '0';
	CONSTANT cpha: STD_LOGIC := '0';
	CONSTANT b_width: INTEGER := 25;
	CONSTANT a_bit_a: STD_LOGIC := '1';
	CONSTANT a_bit_b : STD_LOGIC := '0';
	SIGNAL zero	: STD_LOGIC_VECTOR (b_width DOWNTO 0) := (OTHERS => '0');
	SIGNAL tx_buf	: STD_LOGIC_VECTOR(b_width DOWNTO 0);

	SIGNAL global	: STD_LOGIC_VECTOR (b_width-1 DOWNTO 0);
	COMPONENT Bitcounter IS
		GENERIC (
			b_width 	: INTEGER := 25);
		PORT ( 
			clk		: IN  STD_LOGIC;
			rs			: IN  STD_LOGIC;
			bit_out	: OUT  STD_LOGIC_VECTOR (b_width-1 DOWNTO 0));
	END COMPONENT;

	SIGNAL tx_data	: STD_LOGIC_VECTOR (b_width DOWNTO 0);
	SIGNAL tx_en 	: STD_LOGIC;
	SIGNAL rx_en 	: STD_LOGIC;
	SIGNAL rx_data : STD_LOGIC_VECTOR (b_width downto 0);
	SIGNAL busy 	: STD_LOGIC;
	COMPONENT SPI is
		GENERIC (
			cpol		: STD_LOGIC := '0';
			cpha		: STD_LOGIC := '0';
			b_width	: INTEGER := 25);
		Port ( 
			tx_en 	: in  STD_LOGIC;
			tx_data 	: in  STD_LOGIC_VECTOR (b_width downto 0);
			rx_en 	: out  STD_LOGIC;
			rx_data 	: out  STD_LOGIC_VECTOR (b_width downto 0);
			busy		: out STD_LOGIC;
			miso 		: out  STD_LOGIC;
			mosi 		: in  STD_LOGIC;
			ss 		: in  STD_LOGIC;
			sclk		: IN STD_LOGIC;
			int 		: out  STD_LOGIC);
	END COMPONENT;

	SIGNAL tx_data_a	: STD_LOGIC_VECTOR (b_width DOWNTO 0);
	SIGNAL tx_data_b	: STD_LOGIC_VECTOR (b_width DOWNTO 0);
	SIGNAL rs_a			: STD_LOGIC;
	SIGNAL rs_b			: STD_LOGIC;
	COMPONENT iTime is
	GENERIC (
		b_width	: INTEGER := 25;
		a_bit		: STD_LOGIC := '1');
	Port ( 
		trig 	: in STD_LOGIC;
		clk	: IN STD_LOGIC;
		rs		: IN STD_LOGIC;
      d 		: in STD_LOGIC_VECTOR (b_width-1 downto 0);
		q		: out STD_LOGIC_VECTOR (b_width downto 0));
	END COMPONENT;

BEGIN
	zero <= (OTHERS => '0');
	
	I_Bitcounter: Bitcounter
		GENERIC MAP(
		b_width => b_width)
		PORT MAP(
		clk => clk,
		rs => gpsrs,
		bit_out => global);

	I_iTime_A: iTime
		GENERIC MAP(
		b_width => b_width,
		a_bit => a_bit_a)
		PORT MAP(
		trig => trigA,
		clk => clk,
		rs => rs_a,
		d => global,
		q => tx_data_a);

	I_iTime_B: iTime
		GENERIC MAP(
		b_width => b_width,
		a_bit => a_bit_b)
		PORT MAP(
		trig => trigB,
		clk => clk,
		rs => rs_b,
		d => global,
		q => tx_data_b);
	
	I_SPI: SPI 
		GENERIC MAP (
		cpol	=> cpol,
		cpha	=> cpha,
		b_width	=> b_width)
		PORT MAP(
		tx_en => tx_en,
		tx_data => tx_data,
		rx_en => rx_en,
		rx_data => rx_data,
		busy => busy,
		miso => miso,
		mosi => mosi,
		ss => ss,
		sclk => sclk,
		int => int);

--Buffer type process to ensure data is sent without overrun
	BUFF: PROCESS(busy, tx_data_a, tx_data_b, zero)
	BEGIN
		IF busy = '0' THEN --not transmitting data
			IF tx_data_a /= zero THEN --if data from channel A waiting to send
				tx_data <= tx_data_a; --load to SPI
				tx_en <= '1'; --trigger send on SPI
				rs_a <= '1'; --reset channel A latch
			ELSIF tx_data_b /= zero THEN --channel B waiting and not channel A
				tx_data <= tx_data_b;
				tx_en <= '1';
				rs_b <= '1'; --reset channel B latch
			ELSE
				rs_a <= '0'; --reset rs_a
				rs_b <= '0'; --reset rs_b
			END IF;
		ELSE --either channel sent data
			tx_en <= '0'; --reset tx enable
		END IF;
	END PROCESS;
END Structural;
