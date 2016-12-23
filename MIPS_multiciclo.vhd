library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

----------------------------------------------------------
-- Essa e a entidade principal do projeto, onde vamos
-- implementar os modulos ja feitos, utilizando "port map"
----------------------------------------------------------

entity MIPS_multiciclo is
	port (
			botao		: in	std_logic; 
			clk		: in	std_logic;
			saidaPC	: out	std_logic_vector(31 downto 0); 
			saidaRDM	: out	std_logic_vector(31 downto 0); 
			saidaRI	: out	std_logic_vector(31 downto 0); 
			saidaALU	: out	std_logic_vector(31 downto 0)); 
end MIPS_multiciclo;

architecture archMIPS_multiciclo of MIPS_multiciclo is
	
	component RAM is
	port(
			address	: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			clock		: IN STD_LOGIC  := '1';
			data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			wren		: IN STD_LOGIC ;
			q			: OUT STD_LOGIC_VECTOR (31 DOWNTO 0));
	end component;
	
	component BREG is
	generic (WSIZE : natural := 32);
	port (
			clk			: in std_logic;
			EscreveReg	: in std_logic;
			radd1 		: in std_logic_vector(4 downto 0);
			radd2 		: in std_logic_vector(4 downto 0);
			wadd			: in std_logic_vector(4 downto 0);
			wdata			: in std_logic_vector(WSIZE - 1 downto 0);
			r1				: out std_logic_vector(WSIZE - 1 downto 0);
			r2				: out std_logic_vector(WSIZE - 1 downto 0));
	end component;
	
	component ALU is
	generic (WIZE : natural := 32);
    Port ( operation : in  STD_LOGIC_VECTOR (3 downto 0);
           A 		: in  STD_LOGIC_VECTOR (WIZE - 1 downto 0);
           B		: in  STD_LOGIC_VECTOR (WIZE - 1 downto 0);
           Z		: out  STD_LOGIC_VECTOR (WIZE - 1 downto 0);
           vai	 	: out  STD_LOGIC;
			  ovfl 	: out  STD_LOGIC;
			  zero 	: out  STD_LOGIC);
	end component;
	
	component cntrMIPS is
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
	end component;
	
	-- sinais de controle do mips multiciclo:
 	signal OpALU,OrigBALU,OrigPC,MemparaReg: std_logic_vector(1 downto 0);
 	signal EscreveMem,EscreveRI,EscreveReg,EscrevePC,EscrevePCCond,OrigAALU,RegDst,IouD : std_logic;
	
	-- Campos para decodificacao da instrucao
	signal Opcode, funct : std_logic_vector (5 downto 0) := "000000";
	signal rs, rt, rd, shamt, state: std_logic_vector (4 downto 0);
	signal imm : std_logic_vector (15 downto 0);
	signal offset : std_logic_vector (25 downto 0);
	
	-- sinais da ALU
 	signal vai, ovfl, zero : std_logic;
 	signal Z, sALU , operando1, operando2, opA, opB : std_logic_vector(31 downto 0):= X"00000000";
	signal aux : std_logic_vector(31 downto 0):= X"00000001";
	
	-- Sinal de saida do controle da ALU
 	signal operacao : std_logic_vector (3 downto 0);
	
	-- sinal necessario para a escrita no registrador PC:
 	signal cntrPC, rst: std_logic := '0';
 	signal inPC1, outPC1 : std_logic_vector(31 downto 0):= X"00000000";
	
 	signal  instrucao : std_logic_vector(31 downto 0);
 	-- sinais necessarios para o banco de registradores:
 	signal wdata, r1, r2 : std_logic_vector(31 downto 0):= X"00000000";
 	signal wadd : std_logic_vector(4 downto 0);
 	-- sinais usados no deslocamento do immediato:
 	signal sinal32bits,out32bits,aux2,aux3,saidaRAM, sRDM : std_logic_vector(31 downto 0);
 	-- Sinal que armazena o endereco do jump
 	signal addressJump, out2 : std_logic_vector(31 downto 0);
	signal out28bits : std_logic_vector(27 downto 0);
	-- Sinal de endereco da memoria
	signal address, addressReturn, addressJal : std_logic_vector(7 downto 0) := "00000000";
	signal b32 : bit_vector(31 downto 0);
	
begin
	process (Opcode,OpALU,OrigBALU,OrigPC,OrigAALU,EscreveReg,RegDst,MemparaReg,EscrevePC,EscrevePCCond,IouD,EscreveMem,EscreveRI,state)
	begin
	-- Seleciona o endereco de leitura da memoria
		if (IouD = '0') then
			out2 <= OutPC1;
		else
			out2 <= sALU;
		end if;
	-- Configura o endereco de acesso a memoria RAM
		if (IouD = '0') then
			if (Opcode = "101011" and state = "00000") then
				address <= OutPC1(7 downto 0);
			elsif (Opcode = "000100" and state = "10001") then			-- beq
				address <= out32bits(7 downto 0);
			elsif (Opcode = "000101" and zero = '0') then			-- bne
				address <= out32bits(7 downto 0);
			elsif (Opcode = "000011" and state = "11001") then 	-- jal
				address <= OutPC1(7 downto 0);
			elsif (Opcode = "000010" and state = "11001") then 	-- j
				address <= OutPC1(7 downto 0);
			elsif (funct = "001000") then									-- jr
				address <= addressReturn;
			else
				address <= out2(7 downto 0);
			end if;
 		elsif (IouD = '1') then
			address <= ('1' & sALU(8 downto 2));
 		end if;
		-- controle da ALU
		if (OpALU = "00") then 		-- add
			operacao <= "0010";
		elsif(OpALU = "01") then   -- ori
			operacao <= "0001";
		elsif (OpALU = "10") then
			if(funct = "100000")then			-- add
				operacao <= "0010";
			elsif(funct = "100100")then		-- and
				operacao <= "0000";
			elsif(funct = "100111")then 		-- nor
				operacao <= "1000";
			elsif(funct = "100101")then 		-- or
				operacao <= "0001";
			elsif(funct = "101010")then 		-- slt
				operacao <= "0110";
			elsif(funct = "100010")then 		-- sub
				operacao <= "0100";
			elsif(funct = "000000")then 		-- sll
				operacao <= "1010";
			elsif(funct = "000010")then 		-- srl
				operacao <= "1011";
			elsif(funct = "000011")then 		-- sra
				operacao <= "1100";
			elsif(funct = "100110")then 		-- xor
				operacao <= "1001";
			elsif(funct = "001000")then 		-- jr
				operacao <= "0010";
			end if;
		end if;
	end process;
	process(escreveRI,clk,saidaRAM,EscrevePC,EscrevePCCond)
	begin
		if (falling_edge(clk)) then
			if (EscreveRI = '1') then
				instrucao <= saidaRAM;
			end if;
			cntrPC <= ((zero and EscrevePCCond) or (EscrevePC));
			if (cntrPC = '1') then
				if (state = "00000") then
					outPC1 <= inPC1;
				elsif (state = "10001") then
					outPC1 <= inPC1;
				end if;
			elsif (state = "11000") then		-- para o caso de jal ou j
					outPC1 <= inPC1;
			elsif (funct = "001000") then
				outPC1(7 downto 0) <= addressReturn;
				outPC1(31 downto 8) <= "000000000000000000000000";
			elsif (state = "10001" and Opcode = "000100") then
				outPC1 <= inPC1;
			end if;
		else
				sRDM <= saidaRAM;
		end if;
	end process;
	saidaRI <= instrucao;
	saidaRDM <= sRDM;
	saidaPC <= outPC1;
	-- Decodificacao:	
 	Opcode <= instrucao(31 downto 26);
controle : cntrMIPS port map(clk,rst,Opcode,OpALU,OrigBALU,OrigPC,OrigAALU,EscreveReg,RegDst,MemparaReg,EscrevePC,EscrevePCCond,IouD,EscreveMem,EscreveRI,state);
	rd <= instrucao (15 downto 11);
	shamt <= instrucao (10 downto 6);
	funct <= instrucao (5 downto 0);
	-- obtendo os campos da  Instrucao Beq
	imm <= instrucao (15 downto 0);
	-- obtendo os campos da Instrucao tipo J = j
	offset <= instrucao (25 downto 0);
	rst <= '1';
	out28bits(27 downto 2) <= offset;
	out28bits(1 downto 0) <= "00";
	addressJump <=(outPC1(31 downto 28) & out28bits);
	-- E necessario para decidir qual vai ser o endereco do operando 1
	-- para as operacoes sll e srl
	process(funct,clk) begin
		if (Opcode = "000000" or Opcode = "001101")then
			if (funct = "000000" or funct = "000010") then
				rs <= instrucao (20 downto 16);
				rt <= instrucao (25 downto 21);
			else
				rs <= instrucao (25 downto 21);
				rt <= instrucao (20 downto 16);
			end if;
		else
			rs <= instrucao (25 downto 21);
			rt <= instrucao (20 downto 16);
		end if;
	end process;	
	-- por meio desse mux, pode decidir qual sera o endereco de escrita:
	process (RegDst,rt,rd,Opcode,funct)
	begin
		if (RegDst = '0') then
			if (Opcode = "000011" and state = "11000") then 			-- para o caso de jal
				wadd <= "11111";
			else
				wadd <= rt;
			end if;
		else
			wadd <= rd;
		end if;
	end process;
 	-- por meio desse mux, pode decidir qual sera o dado de escrita no banco de registradores
	process (MemparaReg,sALU,sRDM)
	begin
		if (MemparaReg = "00") then
			wdata <= sALU;
		elsif (MemparaReg = "01") then
			wdata <= sRDM;
		end if;
	end process;
	process(Opcode,clk) begin
	if (Opcode = "000011") then 			-- para o caso de jal
			if (state = "00001") then
				addressReturn <= inPC1(7 downto 0);
			end if;
	end if;
	end process;
	-- Acesso ao banco de registradores:
 	acessaBREG: BREG port map (clk,EscreveReg,rs,rt,wadd,wdata,r1,r2);
	-- Calculando (extende - sinal (Imm[15:0])):
	process(imm,clk, r1,r2)
	begin
		if (imm(15) = '1') then
			sinal32bits(31 downto 16) <= "1111111111111111";
			sinal32bits(15 downto 0) <= imm;
		else
			sinal32bits(31 downto 16) <= "0000000000000000";
			sinal32bits(15 downto 0) <= imm;
		end if;
		-- Registradores A e B : necessario para a funcao sll e srl
		if (falling_edge(clk)) then
			if (EscreveReg = '1') then
				opA <= r1;
				opB <= r2;
			end if;
		end if;
	end process;
	process(sinal32bits,clk) begin
		if (sinal32bits(0) = '1') then		-- quando o imediato é impar
			if (sinal32bits(31) = '1') then
				aux2 <= not(sinal32bits);
				aux3 <= std_logic_vector(unsigned(aux2)+ 1);
				out32bits <= std_logic_vector(unsigned(aux3)- unsigned(aux2));
			else
				out32bits <= std_logic_vector(unsigned(sinal32bits)+ 1);
			end if;
		else											-- quando for par
			if (sinal32bits(31) = '1') then 		-- se o salto for para frente
			aux2 <= not(sinal32bits);
			b32 <= to_bitvector(aux2);
			out32bits  <= to_stdlogicvector(b32 sll 1);
			else					-- se o salto for para tras
				b32 <= to_bitvector(sinal32bits);
				out32bits  <= to_stdlogicvector(b32 sll 1);
			end if;
		end if;
	end process;	
	-- Acesso ao banco de registradores:
 	acessa: BREG port map (clk,EscreveReg,rs,rt,wadd,wdata,r1,r2);
	-- Escolhendo 0 operando 1:
	process(OrigAALU,funct,opA,clk) begin
		if (OrigAALU = '0') then
			if (Opcode = "000011" or Opcode = "000010") then
				operando1(31 downto 1)<= outPC1(31 downto 1);
				operando1(0) <= '0';
			else
				operando1 <= outPC1;
			end if;
		else
			operando1 <= r1;
		end if;
	end process;
	-- Escolhendo o operando 2:
	process(OrigBALU,clk,funct) begin
		if (OrigBALU = "00") then
			if(funct = "000000")then 			-- operando 2 para o caso da operacao sll
				operando2(4 downto 0) <= shamt;
				operando2(31 downto 5)<= "000000000000000000000000000";
			elsif(funct = "000010")then 		-- operando 2 para o caso da operacao srl
				operando2(4 downto 0) <= shamt;
				operando2(31 downto 5)<= "000000000000000000000000000";
			else
				operando2 <= r2;
			end if;
		elsif(OrigBALU = "01") then
			operando2 <= aux;
		elsif(OrigBALU = "10") then
			operando2 <= sinal32bits;
		end if;
		-- Registradores A e B : necessario para a funcao sll e srl
		if (falling_edge(clk)) then
			if (EscreveReg = '1') then
				opA <= r1;
				opB <= r2;
			end if;
		end if;
	end process;
	-- operacao da ALU
	ULA: ALU port map(operacao,operando1,operando2,Z,vai,ovfl,zero);
	process(clk, Z)
	begin
		if (falling_edge(clk)) then
			sALU <= Z;
		end if;
	end process;
	saidaALU <= sALU;
	-- Esse mux vai decidir qual vai ser o endereco da proxima instrucao:
	process (OrigPC,Z,sALU,sinal32bits,Opcode,clk)
	begin
		if (OrigPC = "00") then
		 if(Opcode = "000100" or Opcode = "000101") then	-- beq ou bne
			inPC1 <= out32bits;
		 else
			inPC1 <= Z;
		 end if;
		elsif (OrigPC = "01") then
			inPC1 <= sALU;
		elsif(OrigPC = "10") then
			inPC1(25 downto 0) <= offset;
			inPC1(31 downto 26) <= "000000";
		end if;
	end process;
	memoria: RAM port map (address,clk,r2,EscreveMem,saidaRAM);
end archMIPS_multiciclo;