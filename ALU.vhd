library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
	generic (WIZE : natural := 32);
    Port ( operation : in  STD_LOGIC_VECTOR (3 downto 0);
           A 		: in  STD_LOGIC_VECTOR (WIZE - 1 downto 0);
           B		: in  STD_LOGIC_VECTOR (WIZE - 1 downto 0);
           Z		: out  STD_LOGIC_VECTOR (WIZE - 1 downto 0);
           vai	 	: out  STD_LOGIC;
			  ovfl 	: out  STD_LOGIC;
			  zero 	: out  STD_LOGIC);
end ALU;

architecture arch_ALU of ALU is
	signal a32 : std_logic_vector(WIZE - 1 downto 0);
	signal a33 : std_logic_vector(WIZE downto 0);
	signal d : integer;
	signal b32 : bit_vector(WIZE - 1 downto 0);
begin
	proc_ula: process (A,B,operation,a32,b32,a33,d) 
	begin  
		-- Identificação da saida zero:
		a32 <= std_logic_vector(unsigned(A) - unsigned(B));
		if (a32 = X"00000000")then zero <= '1';
		else zero <= '0';
		end if;
		case operation is            
			when  "0000" => 
				a32 <= A and B; 
				vai <= '0';
				ovfl<= '0';
			when  "0001" => 
				a32 <= A or B;
				vai <= '0';
				ovfl<= '0';
			when  "0010" => 
				a33 <= std_logic_vector(('0' & unsigned(A)) + ('0' & unsigned(B))); -- add com overflow
				vai <= a33(32); -- indicação de vai-um no último bit da ULA
				a32 <= a33(31 downto 0);
					-- Identificação do overflow:
					if (A(31) = B(31)) then
						if (A(31) /= a32(31)) then ovfl <= '1'; -- nesse caso houve overflow
						else ovfl <= '0'; -- nesse caso não houve
						end if;
					else	
						if (a33(32) = '1') then ovfl <= '1'; -- nesse caso houve overflow
						else ovfl <= '0'; -- nesse caso não houve
						end if;
					end if;
			when  "0011" => 
				a33 <= std_logic_vector(('0' & unsigned(A)) + ('0' & unsigned(B))); -- add sem overflow
				vai <= a33(32); 
				a32 <= a33(31 downto 0);
				ovfl<= '0';
			when  "0100" => 
				a33 <= std_logic_vector(('0' & unsigned(A)) - ('0' & unsigned(B))); -- sub com overflow
				vai <= a33(32);  -- indicação de vai-um no último bit da ULA
				a32 <= a33(31 downto 0);
				-- Identificação do overflow:
					if (A(31) = B(31)) then
						if (A(31) /= a32(31)) then ovfl <= '1'; -- nesse caso houve overflow
						else ovfl <= '0'; -- nesse caso não houve
						end if;
					else	
						if (a33(32) = '1') then ovfl <= '1'; -- nesse caso houve overflow
						else ovfl <= '0'; -- nesse caso não houve
						end if;
					end if;
			when  "0101" => 
				a33 <= std_logic_vector(('0' & unsigned(A)) - ('0' & unsigned(B))); -- sub sem overflow
				vai <= a33(32);  -- indicação de vai-um no último bit da ULA
				a32 <= a33(31 downto 0);
				ovfl<= '0';
			when  "0110" =>
				a32 <= X"00000000";
				if (A < B) then a32 <= X"00000001";  -- caso A < B
				end if; 
			when  "0111" => 
				a32 <= A nand B;   
				vai <= '0';
				ovfl<= '0';
			when  "1000" => 
				a32 <= A nor B;
				vai <= '0';
				ovfl<= '0';
			when  "1001" => 
				a32 <= A xor B;
				vai <= '0';
				ovfl<= '0';
			when  "1010" => 
				d <= to_integer(unsigned(B));
				b32 <= to_bitvector(A);
				a32 <= to_stdlogicvector(b32 sll d);
				vai <= '0';
				ovfl<= '0';
			when  "1011" =>
				d <= to_integer(unsigned(B));
				b32 <= to_bitvector(A);
				a32 <= to_stdlogicvector(b32 srl d);
				vai <= '0';
				ovfl<= '0';
			when  "1100" => 
				d <= to_integer(unsigned(A));
				b32 <= to_bitvector(B);
				a32 <= to_stdlogicvector(b32 sra d);
				vai <= '0';
				ovfl<= '0';
			when others  => a32 <= (others => '0');     
		end case;
		-- Atribuindo o resultado da operação na saída:
		Z <= a32;
	end process;
end arch_ALU;