
-- VHDL Instantiation Created from source file spi_slave.vhd -- 16:14:04 11/14/2012
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT spi_slave
	PORT(
		sclk : IN std_logic;
		ss_n : IN std_logic;
		mosi : IN std_logic;
		rx_req : IN std_logic;
		st_load_en : IN std_logic;
		st_load_trdy : IN std_logic;
		st_load_rrdy : IN std_logic;
		st_load_roe : IN std_logic;
		tx_load_en : IN std_logic;
		tx_load_data : IN std_logic_vector(24 downto 0);          
		trdy : OUT std_logic;
		rrdy : OUT std_logic;
		roe : OUT std_logic;
		rx_data : OUT std_logic_vector(24 downto 0);
		busy : OUT std_logic;
		miso : OUT std_logic
		);
	END COMPONENT;

	Inst_spi_slave: spi_slave PORT MAP(
		sclk => ,
		ss_n => ,
		mosi => ,
		rx_req => ,
		st_load_en => ,
		st_load_trdy => ,
		st_load_rrdy => ,
		st_load_roe => ,
		tx_load_en => ,
		tx_load_data => ,
		trdy => ,
		rrdy => ,
		roe => ,
		rx_data => ,
		busy => ,
		miso => 
	);


