-------------------------------------------------------------------------------
-- Elijah K Dunn
-- University of Kansas Physics Dept
-- Create Date:    18:38:17 11/13/2012 
-- Module Name:    fpga_timer - Behavioral 
-- Project Name:
-- Target Devices: Digilent Nexys 3 FPGA eval board
-- Description: 
--		Implementation of the timer module on the Nexys 3 FPGA board for testing 
--		purposes. Output of time data using SPI slave interface and interrupt 
--		signal.
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY fpga_timer IS
	PORT(
--SPI INterface with INterrupt
		sclk : IN STD_LOGIC; --serial clock from master		
		mosi : IN STD_LOGIC; --master OUT slave IN
		miso : OUT STD_LOGIC; --master IN slave OUT
		ss : IN STD_LOGIC; --active low slave select
		int : OUT STD_LOGIC; --active low data ready signal to master

--Logic INterface
		gpsrs : IN STD_LOGIC; --gps 1 pps active high for resettINg the counter
		clk : IN STD_LOGIC; --external clock
		trigA : IN STD_LOGIC; --trigger from channel A
		trigB : IN STD_LOGIC --trigger from channel B
	);
END fpga_timer;

ARCHITECTURE Structural OF fpga_timer IS
	CONSTANT cpol_c : STD_LOGIC := '0'; --clock polarity
	CONSTANT cpha_c : STD_LOGIC := '0'; --clock phase	
	
	COMPONENT timer
		GENERIC (
			cpol : IN STD_LOGIC := '0';
			cpha : IN STD_LOGIC := '0'
		);
		PORT(
			gpsrs : IN  STD_LOGIC;
			clk : IN STD_LOGIC;
			triga : IN  STD_LOGIC;
			trigb : IN  STD_LOGIC;
			sclk : IN STD_LOGIC;
			mosi : IN STD_LOGIC;
			miso : OUT STD_LOGIC;
			ss : IN STD_LOGIC;
			int : OUT STD_LOGIC
		);
	END COMPONENT;
	
--Xilinx IP clock converter from 100 MHz to 20MHz 
	COMPONENT clkgen
		PORT (
			CLK_100 : IN     STD_LOGIC; --100MHz IN
			CLK_20 : OUT    STD_LOGIC --20MHz OUT
		); 
	END COMPONENT;
	
	SIGNAL clk20 : STD_LOGIC;

BEGIN
	i_clkgen_IP : clkgen 
		PORT MAP (
			CLK_100 => clk,
			CLK_20 => clk20
		);
	i_timer_h: Timer 
		GENERIC MAP ( cpol => cpol_c, cpha => cpha_c)
		PORT MAP (
		gpsrs => gpsrs,
		clk => clk20,
		triga => triga,
		trigb => trigb,
		sclk => sclk,
		mosi => mosi,
		miso => miso,
		ss => ss,
		int => int
	);

END Structural;

