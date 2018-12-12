----------------------------------------------------------------------------------
-- Company: 		STU
-- Engineer: 		micle / azhao
-- 
-- Create Date:    10:57:30 11/14/2018 
-- Design Name: 
-- Module Name:    ram_display - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description:
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

entity scroll_number is
    Port ( clk : in  STD_LOGIC;
			  din : in STD_LOGIC_VECTOR(2 downto 0);
           rst : in  STD_LOGIC:='0';
			  sel : out  STD_LOGIC_VECTOR(5 downto 0);
           seg : out  STD_LOGIC_VECTOR (7 downto 0));
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
           seg : out  STD_LOGIC_VECTOR (7 downto 0));
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
signal sel_copy :STD_LOGIC_VECTOR (5 downto 0);


signal seg1:STD_LOGIC_VECTOR (7 downto 0);
signal seg2:STD_LOGIC_VECTOR (7 downto 0);
signal seg3:STD_LOGIC_VECTOR (7 downto 0);
signal seg4:STD_LOGIC_VECTOR (7 downto 0);
signal seg5:STD_LOGIC_VECTOR (7 downto 0);
signal seg6:STD_LOGIC_VECTOR (7 downto 0);
signal r_copy:STD_LOGIC_VECTOR(5 downto 0):="011111";

begin

C1:clk_ts port map(clk,clk_s);
C2:clk_tms port map(clk,clk_ms);

F1:dff port map(clk_s,rst,din,temp_out1);
F2:dff port map(clk_s,rst,temp_out1,temp_out2);
F3:dff port map(clk_s,rst,temp_out2,temp_out3);
F4:dff port map(clk_s,rst,temp_out3,temp_out4);
F5:dff port map(clk_s,rst,temp_out4,temp_out5);
F6:dff port map(clk_s,rst,temp_out5,temp_out6);

T1:translater port map(temp_out1,seg1);
T2:translater port map(temp_out2,seg2);
T3:translater port map(temp_out3,seg3);
T4:translater port map(temp_out4,seg4);
T5:translater port map(temp_out5,seg5);
T6:translater port map(temp_out6,seg6);

process(clk_s)
begin
	if(clk_s'event and clk_s='1') then
		counter<=counter+"001";
		if(counter="110") then
			counter<="000";
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
	sel_copy<="011111" when "000",
		     "101111" when "001",
			  "110111" when "010",
			  "111011" when "011",
			  "111101" when "100",
			  "111110" when "101",
			  "111111" when others;
			  
with sel_copy select
	seg<=seg1 when "011111",
		  seg2 when "101111",
		  seg3 when "110111",
		  seg4 when "111011",
		  seg5 when "111101",
		  seg6 when "111110",
		  "11111111" when others;
		  
sel<=sel_copy;

end Behavioral;

