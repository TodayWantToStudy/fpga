----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:07:10 11/14/2018 
-- Design Name: 
-- Module Name:    clk_t_s - Behavioral 
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

entity clk_ts is
    Port ( sys_clk : in  STD_LOGIC;
           clk_out : out  STD_LOGIC);
end clk_ts;

architecture Behavioral of clk_ts is

begin
 process (sys_clk)
  variable s1 :integer:=0;
  variable s2 :integer:=0;
   begin
	
	if(sys_clk'event and sys_clk = '1') then
		s1:=s1+1;
		if(s1>50000) then
			s2:=s2+1;
			if(s2 > 500 and  s2 < 1000) then
				clk_out <= '0';
			elsif (s2 > 1000 ) then
				clk_out <= '1';
				s2 :=0;
			end if;
			s1 :=0;
		end if;	
	end if;

 end process;

end Behavioral;

