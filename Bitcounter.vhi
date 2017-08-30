
-- VHDL Instantiation Created from source file Bitcounter.vhd -- 19:36:27 12/03/2012
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT Bitcounter
	PORT(
		clk : IN std_logic;
		rs : IN std_logic;          
		bit_out : OUT std_logic_vector(24 downto 0)
		);
	END COMPONENT;

	Inst_Bitcounter: Bitcounter PORT MAP(
		clk => ,
		rs => ,
		bit_out => 
	);


