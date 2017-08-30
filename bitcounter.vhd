-------------------------------------------------------------------------------
-- Elijah K. Dunn
-- University of Kansas Physics Dept.
-- Create Date:    17:39:59 10/31/2012 
-- Module Name:    bitcounter - Behavioral 
-- Project Name: 
-- Description: 
--
-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY Bitcounter IS
	GENERIC (
		b_width 	: INTEGER := 25);
	PORT (
		clk		: IN  STD_LOGIC;
      rs			: IN  STD_LOGIC; --asynchronous active high reset
      bit_out	: OUT  STD_LOGIC_VECTOR (b_width-1 DOWNTO 0));
END Bitcounter;

ARCHITECTURE Behavioral OF Bitcounter IS
	SIGNAL PreQ: STD_LOGIC_VECTOR (b_width-1 DOWNTO 0);

BEGIN
	PROCESS (clk, rs)
	BEGIN
		IF (rs = '1') THEN
			PreQ <= (OTHERS => '0');
		ELSIF (rising_edge(clk)) THEN
			PreQ <= PreQ + 1;
		END IF;
	END PROCESS;
	bit_out <= PreQ;
END Behavioral;
