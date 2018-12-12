----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:20:54 11/14/2018 
-- Design Name: 
-- Module Name:    dff - Behavioral 
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

entity dff is
    Port ( CLK : in  STD_LOGIC;
			  R : in  STD_LOGIC;
           D : in  STD_LOGIC_VECTOR(2 downto 0);
           Q : out  STD_LOGIC_VECTOR(2 downto 0));
end dff;

architecture Behavioral of dff is

begin
process(CLK)
begin
	if(R='1') then
		Q<="000";
	elsif(CLK'event and CLK='1') then
		Q<=D;
	end if;
	
end process;
end Behavioral;

