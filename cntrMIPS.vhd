library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cntrMIPS is
			port (
					clk 				: in std_logic;
					reset 			: in 	std_logic;
					Op 				: in std_logic_vector(5 downto 0);
					OpALU 			: out std_logic_vector(1 downto 0);
					OrigBALU 		: out std_logic_vector(1 downto 0);
					OrigPC 			: out std_logic_vector(1 downto 0);
					OrigAALU 		: out std_logic;
					EscreveReg		: out std_logic;
					RegDst 			: out std_logic;
					MemparaReg		: out std_logic_vector(1 downto 0);
					EscrevePC		: out std_logic;
					EscrevePCCond	: out std_logic;
					IouD				: out std_logic;
					EscreveMem		: out std_logic;
					EscreveIR		: out std_logic;
					state				: out std_logic_vector(4 downto 0));
end cntrMIPS;

architecture arch_cntrMIPS of cntrMIPS is
	
	type estado is (Fetch0,Fetch1,Decode,ExecR,ExecAddi0,ExecAddi1,fimR,ExecOri0,ExecOri1,fimOri,fimAddi,ExecLw0,ExecLw1,ExecSw0,ExecSw1,fimLw0,fimLw1,fimLw3,fimSw);
	signal EP : estado;		-- estado presente
	signal PE : estado;		-- proximo estado
	signal contador : std_logic_vector(3 downto 0) := "0000";
	
begin

	sincrono : process (clk, Op) begin
		if (reset = '0') then  --força a começar o controle a comecar do estado ST0;
			EP <= Fetch0;
		elsif (rising_edge(clk)) then
			EP <= PE;
		end if;
	end process sincrono;
	
	combinacional : process(EP, Op) begin
		case EP is
			when Fetch0 =>			-- Busca: da Instrucao
				OpALU 			<= "00";
				OrigBALU 		<= "01";
				OrigPC 			<= "00";
				OrigAALU 		<= '0'; 
				EscreveReg 		<= '0';
				RegDst 			<= '0'; 
				MemparaReg 		<= "11";
				EscrevePC 		<= '1'; 
				EscrevePCCond 	<= '0';
				IouD 				<= '0'; 
				EscreveMem 		<= '0';
				EscreveIR 		<= '0';
				state <= "00000";
				PE 				<=	Fetch1;
			when Fetch1 =>			-- Busca: da Instrucao
				OpALU 			<= "00";
				OrigBALU 		<= "01";
				OrigPC 			<= "00";
				OrigAALU 		<= '0'; 
				EscreveReg 		<= '0';
				RegDst 			<= '0'; 
				MemparaReg 		<= "11";
				EscrevePC 		<= '1'; 
				EscrevePCCond 	<= '0';
				IouD 				<= '0'; 
				EscreveMem 		<= '0';
				EscreveIR 		<= '1';
				state <= "00000";
				PE 				<=	Decode;
			when Decode => 	 -- Decodificacao e leitura dos resgistradores rs e rt
				OpALU 			<= "00";
				OrigBALU 		<= "00";
				OrigPC 			<= "11";
				OrigAALU 		<= '1';
				EscreveReg 		<= '0';
				RegDst 			<= '0';
				MemparaReg 		<= "11";
				EscrevePC 		<= '0';
				EscrevePCCond	<= '0';
				IouD 				<= '0';
				EscreveMem 		<= '0';
				EscreveIR 		<= '0';
				state <= "00001";
				if (Op = "000000") then       -- Instrução tipo R
					PE <=	ExecR;
				elsif (Op = "001000") then    -- addi
					PE <= ExecAddi0;
				elsif (Op = "001101") then 	-- ori
					PE <= ExecOri0;
				elsif (Op = "100011") then		-- lw
					PE <= ExecLw0;
				end if;
			when ExecR => 	 						-- Execução da instrucao tipo R
				OpALU 			<= "10";
				OrigBALU 		<= "00";
				OrigPC 			<= "11";
				OrigAALU 		<= '1';
				EscreveReg 		<= '0';
				RegDst 			<= '1';
				MemparaReg 		<= "11";
				EscrevePC 		<= '0';
				EscrevePCCond	<= '0';
				IouD 				<= '0';
				EscreveMem 		<= '0';
				EscreveIR 		<= '0';
				state <= "00010";
				PE 				<=	FimR;
			when FimR =>							-- Fim da execução da instrução tipo R
				OpALU 			<= "10";
				OrigBALU 		<= "00";
				OrigPC 			<= "11";
				OrigAALU 		<= '1';
				EscreveReg 		<= '1';
				RegDst 			<= '1';
				MemparaReg 		<= "00";
				EscrevePC 		<= '0';
				EscrevePCCond	<= '0';
				IouD 				<= '0';
				EscreveMem 		<= '0';
				EscreveIR 		<= '0';
				state <= "00011";
				PE 				<=	Fetch0;
			when ExecAddi0 =>							-- Execução da instrução: addi
				OpALU 			<= "00";
				OrigBALU 		<= "10";
				OrigPC 			<= "11";
				OrigAALU 		<= '1';
				EscreveReg 		<= '0';
				RegDst 			<= '0';
				MemparaReg 		<= "11";
				EscrevePC 		<= '0';
				EscrevePCCond	<= '0';
				IouD 				<= '0';
				EscreveMem 		<= '0';
				EscreveIR 		<= '0';
				state <= "00100";
				PE 				<=	ExecAddi1;
			when ExecAddi1 =>							-- Execução da instrução: addi
				OpALU 			<= "00";
				OrigBALU 		<= "10";
				OrigPC 			<= "11";
				OrigAALU 		<= '1';
				EscreveReg 		<= '0';
				RegDst 			<= '0';
				MemparaReg 		<= "11";
				EscrevePC 		<= '0';
				EscrevePCCond	<= '0';
				IouD 				<= '0';
				EscreveMem 		<= '0';
				EscreveIR 		<= '0';
				state <= "00100";
				PE 				<=	FimAddi;
			when FimAddi =>							-- Fim da execução da instrução: addi
				OpALU 			<= "11";
				OrigBALU 		<= "10";
				OrigPC 			<= "11";
				OrigAALU 		<= '1';
				EscreveReg 		<= '1';
				RegDst 			<= '0';
				MemparaReg 		<= "00";
				EscrevePC 		<= '0';
				EscrevePCCond	<= '0';
				IouD 				<= '0';
				EscreveMem 		<= '0';
				EscreveIR 		<= '0';
				state <= "00101";
				PE 				<=	Fetch0;
			when ExecOri0 =>						-- execução da instrução: ori
				OpALU 			<= "01";
				OrigBALU 		<= "10";
				OrigPC 			<= "11";
				OrigAALU 		<= '1';
				EscreveReg 		<= '1';
				RegDst 			<= '0';
				MemparaReg 		<= "00";
				EscrevePC 		<= '0';
				EscrevePCCond	<= '0';
				IouD 				<= '0';
				EscreveMem 		<= '0';
				EscreveIR 		<= '0';
				state <= "00110";
				PE 				<=	ExecOri1;
			when ExecOri1 =>						-- execução da instrução: ori
				OpALU 			<= "01";
				OrigBALU 		<= "10";
				OrigPC 			<= "11";
				OrigAALU 		<= '1';
				EscreveReg 		<= '1';
				RegDst 			<= '0';
				MemparaReg 		<= "00";
				EscrevePC 		<= '0';
				EscrevePCCond	<= '0';
				IouD 				<= '0';
				EscreveMem 		<= '0';
				EscreveIR 		<= '0';
				state <= "00111";
				PE 				<=	FimOri;
			when fimOri =>								-- conclusao da instrucao ori
				OpALU 			<= "11";
				OrigBALU 		<= "11";
				OrigPC 			<= "11";
				OrigAALU 		<= '1';
				EscreveReg 		<= '1';
				RegDst 			<= '0';
				MemparaReg 		<= "00";
				EscrevePC 		<= '0';
				EscrevePCCond	<= '0';
				IouD 				<= '0';
				EscreveMem 		<= '0';
				EscreveIR 		<= '0';
				state	 <= "01000";
				PE <= Fetch0;
			when ExecLw0 =>						-- execução da instrução load word 
				OpALU 			<= "00";
				OrigBALU 		<= "10";
				OrigPC 			<= "11";
				OrigAALU 		<= '1';
				EscreveReg 		<= '0';
				RegDst 			<= '0';
				MemparaReg 		<= "11";
				EscrevePC 		<= '0';
				EscrevePCCond	<= '0';
				IouD 				<= '1';
				EscreveMem 		<= '0';
				EscreveIR 		<= '0';
				state	 <= "01001";
				PE <= ExecLw1;
			when ExecLw1 =>						-- execução da instrução load word 
				OpALU 			<= "00";
				OrigBALU 		<= "10";
				OrigPC 			<= "11";
				OrigAALU 		<= '1';
				EscreveReg 		<= '0';
				RegDst 			<= '0';
				MemparaReg 		<= "11";
				EscrevePC 		<= '0';
				EscrevePCCond	<= '0';
				IouD 				<= '1';
				EscreveMem 		<= '0';
				EscreveIR 		<= '0';
				state	 <= "01010";
				PE <= fimLw0;
			when fimLw0 =>						-- fim da execução da instrução load word 
				OpALU 			<= "00";
				OrigBALU 		<= "01";
				OrigPC 			<= "00";
				OrigAALU 		<= '0'; 
				EscreveReg 		<= '0';
				RegDst 			<= '0'; 
				MemparaReg 		<= "11";
				EscrevePC 		<= '1'; 
				EscrevePCCond 	<= '0';
				IouD 				<= '0'; 
				EscreveMem 		<= '0';
				EscreveIR 		<= '0';
				state	 <= "01011";
				PE <= fimLw1;
			when fimLw1 =>						-- fim da execução da instrução load word 
				OpALU 			<= "00";
				OrigBALU 		<= "01";
				OrigPC 			<= "00";
				OrigAALU 		<= '0'; 
				EscreveReg 		<= '0';
				RegDst 			<= '0'; 
				MemparaReg 		<= "11";
				EscrevePC 		<= '1'; 
				EscrevePCCond 	<= '0';
				IouD 				<= '0'; 
				EscreveMem 		<= '0';
				EscreveIR 		<= '0';
				EscreveIR 		<= '0';
				state	 <= "01100";
				PE <= fimLw3;
			when fimLw3 =>						-- fim da execução da instrução load word 
				OpALU 			<= "00";
				OrigBALU 		<= "10";
				OrigPC 			<= "11";
				OrigAALU 		<= '1';
				EscreveReg 		<= '1';
				RegDst 			<= '0';
				MemparaReg 		<= "01";
				EscrevePC 		<= '0';
				EscrevePCCond	<= '0';
				IouD 				<= '0';
				EscreveMem 		<= '0';
				EscreveIR 		<= '0';
				state	 <= "01101";
				PE <= Fetch0;
			when others =>
				PE 				<= Fetch0;
		end case;
	end process combinacional;
end arch_cntrMIPS;