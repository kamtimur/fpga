library IEEE;
use IEEE.STD_Logic_1164.all, IEEE.Numeric_STD.all;
entity inverse is
generic (DataWidth: natural);
port(
	i_clk: 	in 	std_logic;
	i_rst: 	in 	std_logic;
	i_n:   	in 	std_logic_vector(DataWidth-1 downto 0);
	i_p:   	in 	std_logic_vector(DataWidth-1 downto 0);
	o_res:  out std_logic_vector(DataWidth-1 downto 0)
	);
end entity inverse;
architecture behave of inverse is
	component gcd
	generic(DataWidth : natural);
	port (
		i_clk: 	in 	std_logic;
		i_rst: 	in 	std_logic;
		i_a:   	in 	std_logic_vector(DataWidth-1 downto 0);
		i_b:   	in 	std_logic_vector(DataWidth-1 downto 0);
		o_x:  	out std_logic_vector(DataWidth-1 downto 0);
		o_y:  	out std_logic_vector(DataWidth-1 downto 0);
		o_gcd:  out std_logic_vector(DataWidth-1 downto 0)
	);
	end component;
	signal o_x_gcd : std_logic_vector(DataWidth-1 downto 0);
	signal o_y_gcd : std_logic_vector(DataWidth-1 downto 0);
	signal o_gcd_res: std_logic_vector(DataWidth-1 downto 0);
begin
	gcd_component: gcd
	generic map (DataWidth => DataWidth)
	port map ( 
		i_clk     => i_clk,
		i_rst 	  => i_rst,
		i_a       => i_n,
		i_b       => i_p,
		o_x       => o_x_gcd,
		o_y       => o_y_gcd,
		o_gcd     => o_gcd_res
		);
	main: process (i_clk, i_rst)
		variable tmp1:signed(DataWidth-1 downto 0);
		variable tmp2:signed(DataWidth-1 downto 0);
		variable sum:signed(DataWidth-1 downto 0);
		begin
			if i_rst = '0' then             
				o_res 		<= (others => '0');
			elsif rising_edge(i_clk) then
				if (o_gcd_res /= (DataWidth-1 downto 0 => '0')) and (o_x_gcd /= (DataWidth-1 downto 0 => '0')) and (o_y_gcd /= (DataWidth-1 downto 0 => '0')) then
					tmp1 := resize((signed(o_x_gcd) * signed(i_n)),DataWidth);
					tmp2 := resize((signed(o_y_gcd) * signed(i_p)),DataWidth);
					sum  := (tmp1+tmp2) mod signed(i_p);
					assert o_gcd_res=std_logic_vector(sum) report "gcd error" severity error;
					o_res <= std_logic_vector(signed(o_x_gcd) mod signed(i_p));
				end if;
			end if;
		end process main;
end architecture behave;