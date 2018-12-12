----------------------------------------------------------------------------------
-- Company: 		STU
-- Engineer: 		micle / azhao
-- 
-- Create Date:    16:12:28 12/09/2018 
-- Design Name: 
-- Module Name:    fifo_display - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--		key1 : control the write enable of FIFO
--		key2 : control the read enable of FIFO
--		LED0 : stand for empty state of FIFO
--		LED1 : stand for almost full state of FIFO
--		LED2 : stand for full state of FIFO
--		the FIFO runs on 1Hz clock ,width is 3 bits, depth is 16.
--    at first, the write enable and read enable will be both 0; 
--		the data from the output of FIFO will be displayed on 7-segment
--
-- Dependencies: 
--		A strong heart
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

entity fifo_display is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           key : in  STD_LOGIC_VECTOR(3 downto 0);
           led : out  STD_LOGIC_VECTOR(3 downto 0);
           sel : out  STD_LOGIC_VECTOR (5 downto 0);
           seg : out  STD_LOGIC_VECTOR (7 downto 0));
end fifo_display;

architecture Behavioral of fifo_display is
COMPONENT ip_fifo
  PORT (
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    din : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    wr_en : IN STD_LOGIC;
    rd_en : IN STD_LOGIC;
    dout : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    full : OUT STD_LOGIC;
    almost_full : OUT STD_LOGIC;
    empty : OUT STD_LOGIC
  );
END COMPONENT;
component scroll_number is
    Port ( clk : in  STD_LOGIC;
			  din : in STD_LOGIC_VECTOR(2 downto 0);
           rst : in  STD_LOGIC:='0';
			  sel : out  STD_LOGIC_VECTOR(5 downto 0);
           seg : out  STD_LOGIC_VECTOR (7 downto 0));
end component;
component clk_ts is
    Port ( sys_clk : in  STD_LOGIC;
           clk_out : out  STD_LOGIC);
end component;
signal clk_s:std_logic;
signal blink:std_logic:='1';
signal reset,wr_en,rd_en,full,almost_full,empty:std_logic;
signal counter_s,din,dout:std_logic_vector(2 downto 0):="000";
begin
C_s:clk_ts port map(clk,clk_s);
SCROLL : scroll_number port map(clk,dout,rst,sel,seg); 
process(clk_s)
begin
	if(clk_s'event and clk_s='1') then
		counter_s<=counter_s+"001";
		blink<=not(blink);
		if(counter_s="110") then
			counter_s<="000";
		end if;
	end if;
end process;

din <= counter_s;
reset <= not(rst);
wr_en <= not(key(0));
rd_en <= not(key(1));
led <= blink & full & almost_full & empty;

FIFO1 : ip_fifo
  PORT MAP (
    clk => clk_s,
    rst => reset,
    din => din,
    wr_en => wr_en,
    rd_en => rd_en,
    dout => dout,
    full => full,
    almost_full => almost_full,
    empty => empty
  );
  
end Behavioral;

