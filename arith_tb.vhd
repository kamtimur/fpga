

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity arithmetics_tb is
end;

architecture bench of arithmetics_tb is

  component arithmetics
    port (
      i_rst_l : in std_logic;
      i_clk   : in std_logic;
      i_a     : in std_logic_vector(4 downto 0);
      i_b     : in std_logic_vector(4 downto 0);
  	o_result: out std_logic_vector(4 downto 0)
      );
  end component;

  signal i_rst_l: std_logic;
  signal i_clk: std_logic;
  signal i_a: std_logic_vector(4 downto 0);
  signal i_b: std_logic_vector(4 downto 0);
  signal o_result: std_logic_vector(4 downto 0) ;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: arithmetics port map ( i_rst_l  => i_rst_l,
                              i_clk    => i_clk,
                              i_a      => i_a,
                              i_b      => i_b,
                              o_result => o_result );

  stimulus: process
  begin
  
    -- Put initialisation code here

    i_rst_l <= '0';
    wait for 5 ns;
    i_rst_l <= '1';
    wait for 5 ns;

    -- Put test bench stimulus code here
	i_a <= std_logic_vector(to_unsigned(12, 5));
	i_b <= std_logic_vector(to_unsigned(7, 5));
	wait for clock_period;
	assert o_result=std_logic_vector(to_unsigned(21, 5)) report "error" severity error;
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
  
-- Configuration Declaration

-- configuration cfg_arithmetics_tb of arithmetics_tb is
  -- for bench
    -- for uut: arithmetics
    -- end for;
  -- end for;
-- end cfg_arithmetics_tb;

-- configuration cfg_arithmetics_tb_behave of arithmetics_tb is
  -- for bench
    -- for uut: arithmetics
      -- use entity work.arithmetics(behave);
    -- end for;
  -- end for;
-- end cfg_arithmetics_tb_behave;

  