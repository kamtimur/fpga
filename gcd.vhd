library IEEE;
use IEEE.STD_Logic_1164.all, IEEE.Numeric_STD.all;
entity gcd is
generic (DataWidth: natural);
port(
	i_clk: 	in 	std_logic;
	i_rst: 	in 	std_logic;
	i_a:   	in 	std_logic_vector(DataWidth-1 downto 0);
	i_b:   	in 	std_logic_vector(DataWidth-1 downto 0);
	o_x:  	out std_logic_vector(DataWidth*2-1 downto 0);
	o_y:  	out std_logic_vector(DataWidth*2-1 downto 0);
	o_gcd:  out std_logic_vector(DataWidth-1 downto 0)
	);
end entity gcd;
architecture behave of gcd is
begin
	substract_test: process (i_clk, i_rst)
		variable s: 		std_logic_vector(DataWidth*2-1 downto 0):=(others => '0');
		variable old_s: 	std_logic_vector(DataWidth*2-1 downto 0):=(0 => '1', others => '0');
		variable t: 		std_logic_vector(DataWidth*2-1 downto 0):=(0 => '1', others => '0');
		variable old_t: 	std_logic_vector(DataWidth*2-1 downto 0):=(others => '0');
		variable r: 		std_logic_vector(DataWidth*2-1 downto 0):=(others => '0');
		variable old_r: 	std_logic_vector(DataWidth*2-1 downto 0):=(others => '0');
		variable quotient: std_logic_vector(DataWidth-1 downto 0):=(others => '0');
		variable tmp: 	std_logic_vector(DataWidth*2-1 downto 0):=(others => '0');
		variable old_r_s:signed(DataWidth*2-1 downto 0);
		variable done: boolean := false;
		begin
			if i_rst = '0' then             
				o_x <= (others => '0');
				o_y <= (others => '0');
				o_gcd <= (others => '0');
				r:=(r'range => '0');
				old_r:=(old_r'range => '0');
				done:=false;
			elsif rising_edge(i_clk) then
				if (r=(r'range => '0')) and (old_r=(old_r'range => '0')) and (done/=true) and (i_a>(i_a'range => '0')) and (i_b>(i_b'range => '0')) then
					old_r(i_a'range) := i_a;
					old_r(old_r'high downto i_a'length) := (others => '0');
					r(i_b'range) := i_b;
					r(r'high downto i_b'length) := (others => '0');
				end if;
				if r/=(r'range => '0') and (done/=true) then
					old_r_s	:= signed(old_r);
					quotient:= std_logic_vector(resize((old_r_s /signed(r)),quotient'length));
					tmp :=  old_r;
					old_r := r;
					r := std_logic_vector(signed(tmp) - resize((signed(quotient) * signed(r)),r'length));
					tmp :=  old_s;
					old_s := s;
					s := std_logic_vector(signed(tmp) - resize((signed(quotient) * signed(s)),s'length));
					tmp :=  old_t;
					old_t := t;
					t := std_logic_vector(signed(tmp) - resize((signed(quotient) * signed(t)),t'length));
				else
					done:=true;
					o_gcd <= std_logic_vector(resize(signed(old_r), o_gcd'length));
					o_x <= old_s;
					o_y <= old_t;
				end if;
			end if;
		end process substract_test;
end architecture behave;