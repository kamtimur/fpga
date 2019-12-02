library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity ellyptic_mult_tb is
end;

architecture bench of ellyptic_mult_tb is
  constant DataWidth : integer := 8;
  component ellyptic_mult
  generic(DataWidth : integer);
    port (
	i_rst_l : in std_logic;
	i_clk   : in std_logic;
  	i_p		: in std_logic_vector(DataWidth downto 0);
  	i_a		: in std_logic_vector(DataWidth downto 0);
  	i_b		: in std_logic_vector(DataWidth downto 0);
	i_x    : in std_logic_vector(DataWidth downto 0);
  	i_y    : in std_logic_vector(DataWidth downto 0);
  	i_n		: in std_logic_vector(DataWidth downto 0);
  	o_rx	: out std_logic_vector(DataWidth downto 0);
  	o_ry	: out std_logic_vector(DataWidth downto 0)
      );
  end component;

  signal i_rst_l: std_logic;
  signal i_clk: std_logic;
  signal i_p: std_logic_vector(DataWidth downto 0);
  signal i_a: std_logic_vector(DataWidth downto 0);
  signal i_b: std_logic_vector(DataWidth downto 0);
  signal i_x: std_logic_vector(DataWidth downto 0);
  signal i_y: std_logic_vector(DataWidth downto 0);
  signal i_n: std_logic_vector(DataWidth downto 0);
  signal o_rx: std_logic_vector(DataWidth downto 0);
  signal o_ry: std_logic_vector(DataWidth downto 0) ;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  -- Insert values for generic parameters !!
  uut: ellyptic_mult generic map ( DataWidth => DataWidth )
                        port map ( i_rst_l   => i_rst_l,
                                   i_clk     => i_clk,
                                   i_p       => i_p,
                                   i_a       => i_a,
                                   i_b       => i_b,
                                   i_x       => i_x,
                                   i_y       => i_y,
                                   i_n       => i_n,
                                   o_rx      => o_rx,
                                   o_ry      => o_ry );

  stimulus: process
  begin
  
    -- Put initialisation code here

    i_rst_l <= '0';
    wait for 5 ns;
    i_rst_l <= '1';
    wait for 5 ns;

    -- Put test bench stimulus code here
	i_x <= std_logic_vector(to_signed(3, DataWidth+1));
	i_y <= std_logic_vector(to_signed(6, DataWidth+1));
	i_n <= std_logic_vector(to_signed(2, DataWidth+1));
	i_a  <= std_logic_vector(to_signed(2, DataWidth+1));
	i_b  <= std_logic_vector(to_signed(3, DataWidth+1));
	i_p  <= std_logic_vector(to_signed(97, DataWidth+1));
	wait for clock_period*100;
	assert o_rx = std_logic_vector(to_signed(80, DataWidth+1)) report "error x" severity error;
	assert o_ry = std_logic_vector(to_signed(10, DataWidth+1)) report "error y" severity error;
    stop_the_clock <= true;
    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      i_clk <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

end;

  