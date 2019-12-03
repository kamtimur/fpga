library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real.all;
entity ellyptic_mult is
generic(DataWidth : natural);
  port (
    i_rst_l : in 	std_logic;
    i_clk   : in 	std_logic;
	i_p		: in 	std_logic_vector(DataWidth-1 downto 0);
	i_a		: in 	std_logic_vector(DataWidth-1 downto 0);
	i_b		: in 	std_logic_vector(DataWidth-1 downto 0);
    i_x    	: in 	std_logic_vector(DataWidth-1 downto 0);
	i_y    	: in 	std_logic_vector(DataWidth-1 downto 0);
	i_n		: in 	std_logic_vector(DataWidth-1 downto 0);
	o_rx	: out 	std_logic_vector(DataWidth-1 downto 0);
	o_ry	: out 	std_logic_vector(DataWidth-1 downto 0)
    );
end ellyptic_mult;
architecture behave of ellyptic_mult is
	component ellyptic_add
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
	end component;
	signal i_rst_adder:std_logic;
	signal i_px_adder: std_logic_vector(DataWidth-1 downto 0);
	signal i_py_adder: std_logic_vector(DataWidth-1 downto 0);
	signal o_rx_adder: std_logic_vector(DataWidth-1 downto 0);
	signal o_ry_adder: std_logic_vector(DataWidth-1 downto 0);
	signal current_rx: std_logic_vector(DataWidth-1 downto 0);
	signal current_ry: std_logic_vector(DataWidth-1 downto 0);
	begin
		add: ellyptic_add
		generic map (DataWidth =>  DataWidth)
		port map ( 
			i_rst_l   => i_rst_adder,
			i_clk     => i_clk,
			i_p       => i_p,
			i_a       => i_a,
			i_b       => i_b,
			i_px      => i_px_adder,
			i_py      => i_py_adder,
			i_qx      => i_x,
			i_qy      => i_y,
			o_rx      => o_rx_adder,
			o_ry      => o_ry_adder);
		p_MULT : process (i_clk, i_rst_l)
			variable iteration: integer;
			variable iteration_complete: integer;
			variable iteration_num: integer;
			begin
				if i_rst_l = '0' then             
					o_rx <= (others => '0');
					o_ry <= (others => '0');
					iteration:=0;
					iteration_complete:=0;
					current_rx 	<= std_logic_vector(to_signed(0, DataWidth+1));
					current_ry 	<= std_logic_vector(to_signed(0, DataWidth+1));
					i_rst_adder <= '0';
				elsif rising_edge(i_clk) then
					iteration_num := to_integer((signed(i_n) - 1));
					if (o_rx_adder/=std_logic_vector(to_signed(0, DataWidth+1))) and (o_ry_adder/=std_logic_vector(to_signed(0, DataWidth+1))) then	
						if iteration > 0 then
							current_rx <= o_rx_adder;
							current_ry <= o_ry_adder;
							iteration_complete := iteration_complete+1;
						end if;
						if iteration_complete = iteration_num then
							o_rx <= o_rx_adder;
							o_ry <= o_ry_adder;
						end if;
					i_rst_adder <= '0';
					end if;
					if (o_rx_adder=std_logic_vector(to_signed(0, DataWidth+1))) and (o_ry_adder=std_logic_vector(to_signed(0, DataWidth+1))) and (iteration = iteration_complete) and (iteration_complete < iteration_num)then	
						i_rst_adder <= '1';
						if iteration_complete=0 then
							i_px_adder <= i_x;
							i_py_adder <= i_y;
						end if;
						if iteration_complete>0 then
							i_px_adder <= current_rx;
							i_py_adder <= current_ry;
						end if;
						if iteration = iteration_complete then
							iteration := iteration+1;
						end if;
					end if;
				end if;
			end process p_MULT;
	end behave;