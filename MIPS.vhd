library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

----------------------------------------------------------
-- Essa e a entidade principal do projeto, onde vamos
-- implementar os modulos ja feitos, utilizando "port map"
----------------------------------------------------------

entity MIPS is
	port (
			botao		: in	std_logic; -- botao para ativar o clock da fpga
			clk		: in	std_logic;
			HEX0 : out  STD_LOGIC_VECTOR (6 downto 0);
		   HEX1 : out  STD_LOGIC_VECTOR (6 downto 0);
		   HEX2 : out  STD_LOGIC_VECTOR (6 downto 0);
		   HEX3 : out  STD_LOGIC_VECTOR (6 downto 0);
		   HEX4 : out  STD_LOGIC_VECTOR (6 downto 0);
		   HEX5 : out  STD_LOGIC_VECTOR (6 downto 0);
			HEX6 : out  STD_LOGIC_VECTOR (6 downto 0);
		   HEX7 : out  STD_LOGIC_VECTOR (6 downto 0));
end MIPS;

architecture archMIPS of MIPS is
	
begin

end archMIPS;