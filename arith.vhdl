library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity arithmetics is
  port (
    i_rst_l : in std_logic;
    i_clk   : in std_logic;
    i_a     : in std_logic_vector(4 downto 0);
    i_b     : in std_logic_vector(4 downto 0);
	o_result: out std_logic_vector(4 downto 0)
    );
end arithmetics;
architecture behave of arithmetics is
  begin
	  p_SUM : process (i_clk, i_rst_l)
	  begin
		if i_rst_l = '0' then             -- asynchronous reset (active low)
		  o_result <= (others => '0');
		elsif rising_edge(i_clk) then
		  o_result <= std_logic_vector(signed(i_a) + signed(i_b));
		end if;
	  end process p_SUM;
  end behave;