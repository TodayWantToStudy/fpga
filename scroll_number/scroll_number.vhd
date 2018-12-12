----------------------------------------------------------------------------------
-- Company: 		STU
-- Engineer: 		micle / azhao
-- 
-- Create Date:    10:57:30 11/14/2018 
-- Design Name: 
-- Module Name:    scroll_number - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--		the numbers will scroll on 7-segment LCD screen
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

entity scroll_number is
    Port ( clk : in  STD_LOGIC;
           b : out  STD_LOGIC:='1';
			  s : out  STD_LOGIC_VECTOR(5 downto 0);
           sel : out  STD_LOGIC_VECTOR (7 downto 0));
end scroll_number;

architecture Behavioral of scroll_number is

component clk_ts is
    Port ( sys_clk : in  STD_LOGIC;
           clk_out : out  STD_LOGIC);
end component;
component clk_tms is
    Port ( sys_clk : in  STD_LOGIC;
           clk_out : out  STD_LOGIC);
end component;
component dff is
    Port ( CLK : in  STD_LOGIC;
			  R : in  STD_LOGIC;
           D : in  STD_LOGIC_VECTOR(2 downto 0);
           Q : out  STD_LOGIC_VECTOR(2 downto 0));
end component;
component translater is
    Port ( num : in  STD_LOGIC_VECTOR (2 downto 0);
           ssel : out  STD_LOGIC_VECTOR (7 downto 0));
end component;

signal counter:std_logic_vector(2 downto 0):="000";
signal scan_ms:std_logic_vector(2 downto 0):="000";
signal clk_s:std_logic;
signal clk_ms:std_logic;
signal temp_out1:std_logic_vector(2 downto 0):="000";
signal temp_out2:std_logic_vector(2 downto 0):="000";
signal temp_out3:std_logic_vector(2 downto 0):="000";
signal temp_out4:std_logic_vector(2 downto 0):="000";
signal temp_out5:std_logic_vector(2 downto 0):="000";
signal temp_out6:std_logic_vector(2 downto 0):="000";
signal s_copy :STD_LOGIC_VECTOR (5 downto 0);


signal sel1:STD_LOGIC_VECTOR (7 downto 0);
signal sel2:STD_LOGIC_VECTOR (7 downto 0);
signal sel3:STD_LOGIC_VECTOR (7 downto 0);
signal sel4:STD_LOGIC_VECTOR (7 downto 0);
signal sel5:STD_LOGIC_VECTOR (7 downto 0);
signal sel6:STD_LOGIC_VECTOR (7 downto 0);
signal r_copy:STD_LOGIC_VECTOR(5 downto 0):="011111";
signal r:STD_LOGIC_VECTOR(5 downto 0);

begin

C1:clk_ts port map(clk,clk_s);
C2:clk_tms port map(clk,clk_ms);

F1:dff port map(clk_s,r(5),counter,temp_out1);
F2:dff port map(clk_s,r(4),temp_out1,temp_out2);
F3:dff port map(clk_s,r(3),temp_out2,temp_out3);
F4:dff port map(clk_s,r(2),temp_out3,temp_out4);
F5:dff port map(clk_s,r(1),temp_out4,temp_out5);
F6:dff port map(clk_s,r(0),temp_out5,temp_out6);

T1:translater port map(temp_out1,sel1);
T2:translater port map(temp_out2,sel2);
T3:translater port map(temp_out3,sel3);
T4:translater port map(temp_out4,sel4);
T5:translater port map(temp_out5,sel5);
T6:translater port map(temp_out6,sel6);

process(clk_s)
begin
	if(clk_s'event and clk_s='1') then
		b<='1';
		r<= to_stdlogicvector( to_bitvector(r_copy) SRL conv_integer(counter) ) ;
		counter<=counter+"001";
		if(counter="110") then
			counter<="000";
			--b<='0';
		end if;
	end if;
	
end process;

process(clk_ms)
begin
	if(clk_ms'event and clk_ms='1') then
		scan_ms<=scan_ms+"001";
	end if;
	if(scan_ms="111") then
		scan_ms<="000";
	end if;
end process;

with scan_ms select		--scan 6 svgs by 100hz
	s_copy<="011111" when "000",
		     "101111" when "001",
			  "110111" when "010",
			  "111011" when "011",
			  "111101" when "100",
			  "111110" when "101",
			  "111111" when others;
			  
with s_copy select
	sel<=sel1 when "011111",
		  sel2 when "101111",
		  sel3 when "110111",
		  sel4 when "111011",
		  sel5 when "111101",
		  sel6 when "111110",
		  "11111111" when others;
s<=s_copy;

end Behavioral;

