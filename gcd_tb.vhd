

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity GCD_tb is
end;

architecture bench of GCD_tb is
  constant DataWidth : integer := 257;
  component GCD
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
  end component;

  signal i_clk: std_logic;
  signal i_rst: std_logic;
  signal i_a: std_logic_vector(DataWidth-1 downto 0);
  signal i_b: std_logic_vector(DataWidth-1 downto 0);
  signal o_x: std_logic_vector(DataWidth*2-1 downto 0);
  signal o_y: std_logic_vector(DataWidth*2-1 downto 0);
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

  -- 65341020041517633956166170261014086368942546761318486551877808671514674964848 
	i_b <= "01001000001110101101101001110111001001101010001111000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
  -- 115792089237316195423570985008687907853269984665640564039457584007908834671663
	i_a <= "01111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111011111111111111111111110000101111";
  wait for clock_period*100;
  assert signed(o_gcd) > 0 report "gcd <=0" severity error;
  assert o_gcd =std_logic_vector(resize((signed(o_x)*signed(i_a) + signed(o_y)*signed(i_b)),o_gcd'length))  report "error gcd" severity error;

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

  