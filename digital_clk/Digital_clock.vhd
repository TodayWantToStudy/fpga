----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:42:40 11/05/2018 
-- Design Name: 
-- Module Name:    mux - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--		A normal digital clock base on FPGA
--		from left to right, it will be hour, minute and second.
--	
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity digital_clk is
    Port ( clk : in  STD_LOGIC;
			  b : out  STD_LOGIC:='1';
           sel : out  STD_LOGIC_VECTOR(5 downto 0);
           seg : out  STD_LOGIC_VECTOR (7 downto 0));
end digital_clk;

architecture Behavioral of digital_clk is
component clk_s 
    Port ( sys_clk : in  STD_LOGIC;
           clk_1 : out  STD_LOGIC);
end component;

component clk_ms is
    Port ( sys_clk : in  STD_LOGIC;
           clk_1 : out  STD_LOGIC);
end component;
  
component translater 
    Port ( num : in  STD_LOGIC_VECTOR (3 downto 0);
           seg : out  STD_LOGIC_VECTOR (7 downto 0));
end component;

signal clkms:std_logic;
signal clks:std_logic;
signal scan_ms:std_logic_vector(2 downto 0):="000";
signal sel_copy :STD_LOGIC_VECTOR (5 downto 0):="111111";

signal second0 :STD_LOGIC_VECTOR(3 downto 0):="0000";
signal second1 :STD_LOGIC_VECTOR(3 downto 0):="0101";
signal minute0 :STD_LOGIC_VECTOR(3 downto 0):="1001";
signal minute1 :STD_LOGIC_VECTOR(3 downto 0):="0101";
signal hour0 :STD_LOGIC_VECTOR(3 downto 0):="0011";
signal hour1 :STD_LOGIC_VECTOR(3 downto 0):="0010";

signal ss0:STD_LOGIC_VECTOR (7 downto 0);
signal ss1:STD_LOGIC_VECTOR (7 downto 0);
signal sm0:STD_LOGIC_VECTOR (7 downto 0);
signal sm1:STD_LOGIC_VECTOR (7 downto 0);
signal sh0:STD_LOGIC_VECTOR (7 downto 0);
signal sh1:STD_LOGIC_VECTOR (7 downto 0);

begin
C0:clk_ms port map(clk,clkms);
C1:clk_s port map(clk,clks);
S0:translater port map(second0,ss0);
S1:translater port map(second1,ss1);
M0:translater port map(minute0,sm0);
M1:translater port map(minute1,sm1);
H0:translater port map(hour0,sh0);
H1:translater port map(hour1,sh1);

process(clkms)
begin
	if(clkms'event and clkms='1') then
		scan_ms<=scan_ms+"001";
	end if;
	if(scan_ms="111") then
		scan_ms<="000";
	end if;
end process;

process(clks)
begin
	if(clks'event and clks = '1') then
		second0<=second0 + "0001";
		b<='1';
		if(second0>="1001") then --I DON'T KNOW WHY, BY LOGIC,SECOND0 SHOULD LARGER THAN "1001"; 
			b<='0';
			second0<="0000";
			second1<=second1+"0001";
			if(second1>="0101") then
				second1<="0000";
				minute0<=minute0+"0001";
				if(minute0>="1001") then
					minute0<="0000";
					minute1<=minute1+"0001";
					if(minute1>="0101") then
						minute1<="0000";
						hour0<=hour0+"0001";
						if(hour1="0010") then
							if(hour0>="0011") then
								hour0<="0000";
								hour1<="0000";
							end if;
						elsif(hour0>="1001") then
							hour0<="0000";
							hour1<=hour1+"0001";
						end if;
					end if;
				end if;
			end if;
		end if;
	end if;	
	
end process;

with scan_ms select		--scan 6 svgs by 100hz
	sel_copy<="011111" when "000",
		     "101111" when "001",
			  "110111" when "010",
			  "111011" when "011",
			  "111101" when "100",
			  "111110" when "101",
			  "111111" when others;
--			  
with sel_copy select		--ouput signal depends on which svg is working.
	seg<=ss0 when "111110",
		  ss1 when "111101",
		  sm0 when "111011",
		  sm1 when "110111",
		  sh0 when "101111",
		  sh1 when "011111",
		  --"11100011" when "110111",
		  "11000000" when others;

sel<=sel_copy;--connect the signal to output

end Behavioral;

