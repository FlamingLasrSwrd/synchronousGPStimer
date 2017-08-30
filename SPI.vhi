
-- VHDL Instantiation Created from source file SPI.vhd -- 19:37:47 12/03/2012
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT SPI
	PORT(
		tx_en : IN std_logic;
		tx_data : IN std_logic_vector(24 downto 0);
		mosi : IN std_logic;
		ss : IN std_logic;          
		rx_en : OUT std_logic;
		rx_data : OUT std_logic_vector(24 downto 0);
		miso : OUT std_logic;
		int : OUT std_logic;
		busy : OUT std_logic
		);
	END COMPONENT;

	Inst_SPI: SPI PORT MAP(
		tx_en => ,
		tx_data => ,
		rx_en => ,
		rx_data => ,
		miso => ,
		mosi => ,
		ss => ,
		int => ,
		busy => 
	);


