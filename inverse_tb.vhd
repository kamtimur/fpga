
library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity inverse_tb is
end;

architecture bench of inverse_tb is
  constant DataWidth : integer := 24;
  component inverse
  generic (DataWidth: natural);
  port(
  	i_clk: 	in 	std_logic;
  	i_rst: 	in 	std_logic;
  	i_n:   	in 	std_logic_vector(DataWidth-1 downto 0);
  	i_p:   	in 	std_logic_vector(DataWidth-1 downto 0);
  	o_res:  out std_logic_vector(DataWidth-1 downto 0)
  	);
  end component;

  signal i_clk: std_logic;
  signal i_rst: std_logic;
  signal i_n: std_logic_vector(DataWidth-1 downto 0);
  signal i_p: std_logic_vector(DataWidth-1 downto 0);
  signal o_res: std_logic_vector(DataWidth-1 downto 0) ;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  -- Insert values for generic parameters !!
  uut: inverse generic map ( DataWidth =>  DataWidth)
                  port map ( i_clk     => i_clk,
                             i_rst     => i_rst,
                             i_n       => i_n,
                             i_p       => i_p,
                             o_res     => o_res );

  stimulus: process
  begin
  
    -- Put initialisation code here

    i_rst <= '0';
    wait for 5 ns;
    i_rst <= '1';
    wait for 5 ns;

    -- Put test bench stimulus code here
	i_n <= std_logic_vector(to_signed(26, DataWidth));
	i_p <= std_logic_vector(to_signed(3, DataWidth));
	wait for clock_period*100;
	assert o_res = std_logic_vector(to_signed(2, DataWidth)) report "error" severity error;
	
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
  