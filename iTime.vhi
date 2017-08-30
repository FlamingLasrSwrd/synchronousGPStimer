
-- VHDL Instantiation Created from source file iTime.vhd -- 19:34:15 12/03/2012
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT iTime
	PORT(
		trig : IN std_logic;
		bit_in : IN std_logic_vector(25 downto 0);          
		bit_out : OUT std_logic_vector(25 downto 0);
		bit_en : OUT std_logic
		);
	END COMPONENT;

	Inst_iTime: iTime PORT MAP(
		trig => ,
		bit_in => ,
		bit_out => ,
		bit_en => 
	);


