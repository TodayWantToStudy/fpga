----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:50:47 11/07/2018 
-- Design Name: 
-- Module Name:    translater - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity translater is
    Port ( num : in  STD_LOGIC_VECTOR (3 downto 0);
           seg : out  STD_LOGIC_VECTOR (7 downto 0));
end translater;

architecture Behavioral of translater is

begin
with num select
	seg<="11000000" when "0000" ,
		   "11111001" when "0001" ,
		   "10100100" when "0010" ,
		   "10110000" when "0011" ,
		   "10011001" when "0100" ,
	 	   "10010010" when "0101" ,
		   "10000010" when "0110" ,
		   "11111000" when "0111" ,
		   "10000000" when "1000" ,
		   "10010000" when "1001" ,
		   "11111111" when others ;
	
end Behavioral;

