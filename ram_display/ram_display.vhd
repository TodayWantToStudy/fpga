----------------------------------------------------------------------------------
-- Company: 		STU
-- Engineer: 		micle / azhao
-- 
-- Create Date:    20:22:31 12/08/2018 
-- Design Name: 
-- Module Name:    ram_display - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--		at the begining, the data in ram is all 5.
-- 	data from ram will scroll on 7-segment. 
-- 	when the key1 is pressed, the data of counter will be in the ram.
--    when the rst button is pressed, the counter will be reset.
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

entity ram_display is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
			  key1: in  STD_LOGIC;
           sel : out  STD_LOGIC_VECTOR (5 downto 0);
           seg : out  STD_LOGIC_VECTOR (7 downto 0));
end ram_display;

architecture Behavioral of ram_display is
component scroll_number is
    Port ( clk : in  STD_LOGIC;
			  din : in STD_LOGIC_VECTOR(2 downto 0);
           rst : in  STD_LOGIC;
			  sel : out  STD_LOGIC_VECTOR(5 downto 0);
           seg : out  STD_LOGIC_VECTOR (7 downto 0));
end component;
component clk_ts is
    Port ( sys_clk : in  STD_LOGIC;
           clk_out : out  STD_LOGIC);
end component;
COMPONENT ip_ram
  PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
  );
END COMPONENT;

signal clk_s:std_logic;
signal en_write:std_logic_vector(0 downto 0);
signal counter_s,ram_dout:std_logic_vector(2 downto 0);
begin
en_write<=CONV_STD_LOGIC_VECTOR(CONV_UNSIGNED(NOT(key1),1),1);

CLKDV1: clk_ts port map(clk,clk_s);
SCROLL: scroll_number port map(clk,ram_dout,rst,sel,seg);

RAM1 : ip_ram
  PORT MAP (
    clka => clk,
    wea => en_write,
    addra => counter_s,
    dina => counter_s,
    douta => ram_dout
  );
process(clk_s,rst)
begin
	if(rst='0') then
		counter_s<="000";
	elsif(clk_s'event and clk_s='1') then
		counter_s <= counter_s + "001";
		if(counter_s="110") then
			counter_s<="000";
		end if;
	end if;
end process;

end Behavioral;

