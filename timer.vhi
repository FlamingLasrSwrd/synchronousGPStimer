
-- VHDL Instantiation Created from source file timer.vhd -- 00:22:22 11/14/2012
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT timer
	PORT(
		gpsrs : IN std_logic;
		clk : IN std_logic;
		trigA : IN std_logic;
		trigB : IN std_logic;
		SCLK : IN std_logic;
		MOSI : IN std_logic;
		SS : IN std_logic;          
		MISO : OUT std_logic;
		int : OUT std_logic
		);
	END COMPONENT;

	Inst_timer: timer PORT MAP(
		gpsrs => ,
		clk => ,
		trigA => ,
		trigB => ,
		SCLK => ,
		MOSI => ,
		MISO => ,
		SS => ,
		int => 
	);


