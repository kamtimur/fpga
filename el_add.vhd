library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real.all;
entity ellyptic_add is
generic(DataWidth : integer);
  port (
    i_rst_l : in std_logic;
    i_clk   : in std_logic;
    i_px    : in std_logic_vector(DataWidth downto 0);
	i_py    : in std_logic_vector(DataWidth downto 0);
    i_qx    : in std_logic_vector(DataWidth downto 0);
	i_qy    : in std_logic_vector(DataWidth downto 0);
	o_rx	: out std_logic_vector(DataWidth downto 0);
	o_ry	: out std_logic_vector(DataWidth downto 0)
    );
end ellyptic_add;
architecture behave of ellyptic_add is
  begin
	  p_SUM : process (i_clk, i_rst_l)
	  variable alpha : std_logic_vector(DataWidth downto 0);
	  variable tmp_rx: std_logic_vector(DataWidth downto 0);
	  variable tmp_ry: std_logic_vector(DataWidth downto 0);
	  begin
		if i_rst_l = '0' then             
			o_rx <= (others => '0');
			o_ry <= (others => '0');
		elsif rising_edge(i_clk) then
			alpha := std_logic_vector(resize(signed((signed(i_py) - signed(i_qy))/(signed(i_px)-signed(i_qx))),alpha'length));
			tmp_rx:= std_logic_vector(resize(signed(signed(alpha)*signed(alpha)-signed(i_px)-signed(i_qx)),tmp_rx'length));
			tmp_ry:= std_logic_vector(resize(signed(-(signed(i_py)+(signed(alpha)*(signed(tmp_rx)-signed(i_px))))),tmp_ry'length));
			o_rx  <= tmp_rx;
			o_ry  <= tmp_ry;
		end if;
	  end process p_SUM;
  end behave;