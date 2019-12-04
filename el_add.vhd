library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real.all;
entity ellyptic_add is
generic(DataWidth : natural);
  port (
    i_rst_l : in 	std_logic;
    i_clk   : in 	std_logic;
	i_p		: in 	std_logic_vector(DataWidth-1 downto 0);
	i_a		: in 	std_logic_vector(DataWidth-1 downto 0);
	i_b		: in 	std_logic_vector(DataWidth-1 downto 0);
    i_px    : in 	std_logic_vector(DataWidth-1 downto 0);
	i_py    : in 	std_logic_vector(DataWidth-1 downto 0);
    i_qx    : in 	std_logic_vector(DataWidth-1 downto 0);
	i_qy    : in 	std_logic_vector(DataWidth-1 downto 0);
	o_rx	: out 	std_logic_vector(DataWidth-1 downto 0);
	o_ry	: out 	std_logic_vector(DataWidth-1 downto 0)
    );
end ellyptic_add;
architecture behave of ellyptic_add is
	component inverse
	generic(DataWidth : natural);
	port (
		i_clk: 	in 	std_logic;
		i_rst: 	in 	std_logic;
		i_n:   	in 	std_logic_vector(DataWidth-1 downto 0);
		i_p:   	in 	std_logic_vector(DataWidth-1 downto 0);
		o_res: 	out std_logic_vector(DataWidth-1 downto 0)
		);
	end component;
	signal i_rst_inv: 	std_logic;
	signal i_n_inv : std_logic_vector(DataWidth-1 downto 0);
	signal i_p_inv : std_logic_vector(DataWidth-1 downto 0);
	signal o_res_inv: std_logic_vector(DataWidth-1 downto 0);
	begin
	inverse_component: inverse
	generic map (DataWidth => DataWidth)
	port map ( 
		i_clk     => i_clk,
		i_rst 	  => i_rst_inv,
		i_n       => i_n_inv,
		i_p       => i_p_inv,
		o_res     => o_res_inv
		);
	p_SUM : process (i_clk, i_rst_l)
		variable alpha : signed(DataWidth-1 downto 0);
		variable tmp_rx: std_logic_vector(DataWidth-1 downto 0);
		variable tmp_ry: std_logic_vector(DataWidth-1 downto 0);
		variable tmp_inverse: signed(DataWidth-1 downto 0) := (DataWidth-1 downto 0 => '0');
		begin
			if i_rst_l = '0' then             
				o_rx <= (others => '0');
				o_ry <= (others => '0');
				i_rst_inv <= '0';
			elsif rising_edge(i_clk) then
				if (o_res_inv=(DataWidth-1 downto 0 => '0')) and tmp_inverse=(DataWidth-1 downto 0 => '0') then
					if signed(i_px) = signed(i_qx) then
						tmp_inverse := resize(2*signed(i_py), DataWidth);
					else
						tmp_inverse := resize(signed(i_px)-signed(i_qx), DataWidth);
					end if;	
					i_rst_inv <= '1';					
					i_n_inv <= std_logic_vector(tmp_inverse);
					i_p_inv <= i_p;
				end if;
				if (o_res_inv/=(DataWidth-1 downto 0 => '0')) then
					if signed(i_px) = signed(i_qx) then
						alpha := resize(((3*signed(i_px)*signed(i_px) + signed(i_a)) mod signed(i_p))*signed(o_res_inv), DataWidth);
					else
						alpha := resize(((signed(i_py)-signed(i_qy)) mod signed(i_p))*signed(o_res_inv), DataWidth);
					end if;	
					tmp_rx:= std_logic_vector(resize(signed((signed(alpha)*signed(alpha)-signed(i_px)-signed(i_qx)) mod signed(i_p)),tmp_rx'length));
					tmp_ry:= std_logic_vector(resize(signed((-(signed(i_py)+(signed(alpha)*(signed(tmp_rx)-signed(i_px)))))  mod signed(i_p)),tmp_ry'length));
					o_rx  <= tmp_rx;
					o_ry  <= tmp_ry;
				end if;
			end if;
	end process p_SUM;
end behave;