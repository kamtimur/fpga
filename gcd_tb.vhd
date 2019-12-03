

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity GCD_tb is
end;

architecture bench of GCD_tb is
  constant DataWidth : integer := 24;
  component GCD
  generic (DataWidth: natural);
  port(
  	i_clk: 	in 	std_logic;
  	i_rst: 	in 	std_logic;
  	i_a:   	in 	std_logic_vector(DataWidth-1 downto 0);
  	i_b:   	in 	std_logic_vector(DataWidth-1 downto 0);
  	o_x:  	out std_logic_vector(DataWidth-1 downto 0);
  	o_y:  	out std_logic_vector(DataWidth-1 downto 0);
  	o_gcd:  out std_logic_vector(DataWidth-1 downto 0)
  	);
  end component;

  signal i_clk: std_logic;
  signal i_rst: std_logic;
  signal i_a: std_logic_vector(DataWidth-1 downto 0);
  signal i_b: std_logic_vector(DataWidth-1 downto 0);
  signal o_x: std_logic_vector(DataWidth-1 downto 0);
  signal o_y: std_logic_vector(DataWidth-1 downto 0);
  signal o_gcd: std_logic_vector(DataWidth-1 downto 0) ;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  -- Insert values for generic parameters !!
  uut: GCD generic map ( DataWidth =>  DataWidth)
              port map ( i_clk     => i_clk,
                         i_rst     => i_rst,
                         i_a       => i_a,
                         i_b       => i_b,
                         o_x       => o_x,
                         o_y       => o_y,
                         o_gcd     => o_gcd );

  stimulus: process
  begin
  
    -- Put initialisation code here

    i_rst <= '0';
    wait for 5 ns;
    i_rst <= '1';
    wait for 5 ns;

    -- Put test bench stimulus code here
	i_a <= std_logic_vector(to_signed(180, DataWidth));
	i_b <= std_logic_vector(to_signed(150, DataWidth));
	wait for clock_period*100;
	assert o_x = std_logic_vector(to_signed(1, DataWidth)) report "error x" severity error;
	assert o_y = std_logic_vector(to_signed(-1, DataWidth)) report "error y" severity error;
    assert o_gcd = std_logic_vector(to_signed(30, DataWidth)) report "error gcd" severity error;

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

  