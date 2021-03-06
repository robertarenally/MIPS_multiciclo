LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY MIPS_multiciclo_TB IS
END MIPS_multiciclo_TB;

ARCHITECTURE behavior OF MIPS_multiciclo_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
	component MIPS_multiciclo is
	port (
			botao		: in	std_logic; -- botao para ativar o clock da fpga
			clk		: in	std_logic;
			saidaPC	: out	std_logic_vector(31 downto 0); 
			saidaRDM	: out	std_logic_vector(31 downto 0); 
			saidaRI	: out	std_logic_vector(31 downto 0);  
			saidaALU	: out	std_logic_vector(31 downto 0)); 
	end component;

   --Inputs
   signal clk : std_logic;
	signal botao : std_logic;

 	--Outputs
   signal saidaPC,saidaRDM,saidaRI,saidaALU : std_logic_vector(31 downto 0);
	
	-- Clock period:
   constant clk_period : time := 100 ps;
	
	-- Variavel que serve de condicao de parada do clock:
	signal ENDSIM : boolean := false;
	
BEGIN
	
	-- Instantiate the Unit Under Test (UUT)
   uut: MIPS_multiciclo PORT MAP (
          botao => botao,
          clk => clk,
			 saidaPC => saidaPC,
			 saidaRDM => saidaRDM,
          saidaRI => saidaRI,
			 saidaALU => saidaALU
        );
	-- processo de estimulo do clock
	clk_process :process
   begin
		if (ENDSIM=false) then 
			clk <= '0';
			wait for clk_period;
			clk <= '1';
			wait for clk_period;
		else
			wait;
		end if;
   end process;
	
	 -- Stimulus process
   stim_proc: process
   begin		
		botao <= '1'; wait for clk_period;
		wait;
	end process;
END;