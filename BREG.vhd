library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity BREG is
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
end BREG;

architecture arch_BREG of BREG is
	signal sinal0,sinal1,sinal2,sinal3,sinal4,sinal5,sinal6,sinal7,sinal8,sinal9,sinal10 : std_logic_vector(WSIZE - 1 downto 0):= X"00000000";
	signal sinal11,sinal12,sinal13,sinal14,sinal15,sinal16,sinal17,sinal18,sinal19,sinal20,sinal21 : std_logic_vector(WSIZE - 1 downto 0):= X"00000000";
	signal sinal22,sinal23,sinal24,sinal25,sinal26,sinal27,sinal28,sinal29,sinal30,sinal31 : std_logic_vector(WSIZE - 1 downto 0):= X"00000000";
begin
		BancoDeRegistradores: process (clk,EscreveReg)
		begin
			if (rising_edge(clk)) then 
				if (EscreveReg = '1') then
					case wadd is
						when "00000" => sinal0 <= X"00000000";
						when "00001" => sinal1 <= wdata;
						when "00010" => sinal2 <= wdata;
						when "00011" => sinal3 <= wdata;
						when "00100" => sinal4 <= wdata;
						when "00101" => sinal5 <= wdata;
						when "00110" => sinal6 <= wdata;
						when "00111" => sinal7 <= wdata;
						when "01000" => sinal8 <= wdata;
						when "01001" => sinal9 <= wdata;
						when "01010" => sinal10 <= wdata;
						when "01011" => sinal11 <= wdata;
						when "01100" => sinal12 <= wdata;
						when "01101" => sinal13 <= wdata;
						when "01110" => sinal14 <= wdata;
						when "01111" => sinal15 <= wdata;
						when "10000" => sinal16 <= wdata;
						when "10001" => sinal17 <= wdata;
						when "10010" => sinal18 <= wdata;
						when "10011" => sinal19 <= wdata;
						when "10100" => sinal20 <= wdata;
						when "10101" => sinal21 <= wdata;
						when "10110" => sinal22 <= wdata;
						when "10111" => sinal23 <= wdata;
						when "11000" => sinal24 <= wdata;
						when "11001" => sinal25 <= wdata;
						when "11010" => sinal26 <= wdata;
						when "11011" => sinal27 <= wdata;
						when "11100" => sinal28 <= wdata;
						when "11101" => sinal29 <= wdata;
						when "11110" => sinal30 <= wdata;
						when "11111" => sinal31 <= wdata;
						when others  => sinal0 <= (others => '0');
					end case;
				end if;
         end if;
			case radd1 is
				when "00000" => r1 <= sinal0;
				when "00001" => r1 <= sinal1;
				when "00010" => r1 <= sinal2;
				when "00011" => r1 <= sinal3;
				when "00100" => r1 <= sinal4;
				when "00101" => r1 <= sinal5;
				when "00110" => r1 <= sinal6;
				when "00111" => r1 <= sinal7;
				when "01000" => r1 <= sinal8;
				when "01001" => r1 <= sinal9;
				when "01010" => r1 <= sinal10;
				when "01011" => r1 <= sinal11;
				when "01100" => r1 <= sinal12;
				when "01101" => r1 <= sinal13;
				when "01110" => r1 <= sinal14;
				when "01111" => r1 <= sinal15;
				when "10000" => r1 <= sinal16;
				when "10001" => r1 <= sinal17;
				when "10010" => r1 <= sinal18;
				when "10011" => r1 <= sinal19;
				when "10100" => r1 <= sinal20;
				when "10101" => r1 <= sinal21;
				when "10110" => r1 <= sinal22;
				when "10111" => r1 <= sinal23;
				when "11000" => r1 <= sinal24;
				when "11001" => r1 <= sinal25;
				when "11010" => r1 <= sinal26;
				when "11011" => r1 <= sinal27;
				when "11100" => r1 <= sinal28;
				when "11101" => r1 <= sinal29;
				when "11110" => r1 <= sinal30;
				when "11111" => r1 <= sinal31;
				when others  => r1 <= (others => '0');
			end case;
			case radd2 is
				when "00000" => r2 <= sinal0;
				when "00001" => r2 <= sinal1;
				when "00010" => r2 <= sinal2;
				when "00011" => r2 <= sinal3;
				when "00100" => r2 <= sinal4;
				when "00101" => r2 <= sinal5;
				when "00110" => r2 <= sinal6;
				when "00111" => r2 <= sinal7;
				when "01000" => r2 <= sinal8;
				when "01001" => r2 <= sinal9;
				when "01010" => r2 <= sinal10;
				when "01011" => r2 <= sinal11;
				when "01100" => r2 <= sinal12;
				when "01101" => r2 <= sinal13;
				when "01110" => r2 <= sinal14;
				when "01111" => r2 <= sinal15;
				when "10000" => r2 <= sinal16;
				when "10001" => r2 <= sinal17;
				when "10010" => r2 <= sinal18;
				when "10011" => r2 <= sinal19;
				when "10100" => r2 <= sinal20;
				when "10101" => r2 <= sinal21;
				when "10110" => r2 <= sinal22;
				when "10111" => r2 <= sinal23;
				when "11000" => r2 <= sinal24;
				when "11001" => r2 <= sinal25;
				when "11010" => r2 <= sinal26;
				when "11011" => r2 <= sinal27;
				when "11100" => r2 <= sinal28;
				when "11101" => r2 <= sinal29;
				when "11110" => r2 <= sinal30;
				when "11111" => r2 <= sinal31;
				when others  => r2 <= (others => '0');
			end case;
		end process;
end arch_BREG;