library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity ellyptic_add_tb is
end;

architecture bench of ellyptic_add_tb is
  constant DataWidth : integer := 8;
  component ellyptic_add
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
  end component;

  signal i_rst_l: std_logic;
  signal i_clk: std_logic;
  signal i_px: std_logic_vector(DataWidth downto 0);
  signal i_py: std_logic_vector(DataWidth downto 0);
  signal i_qx: std_logic_vector(DataWidth downto 0);
  signal i_qy: std_logic_vector(DataWidth downto 0);
  signal o_rx: std_logic_vector(DataWidth downto 0);
  signal o_ry: std_logic_vector(DataWidth downto 0) ;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  -- Insert values for generic parameters !!
  uut: ellyptic_add generic map ( DataWidth => DataWidth )
                       port map ( i_rst_l   => i_rst_l,
                                  i_clk     => i_clk,
                                  i_px      => i_px,
                                  i_py      => i_py,
                                  i_qx      => i_qx,
                                  i_qy      => i_qy,
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
	i_px <= std_logic_vector(to_signed(1, DataWidth+1));
	i_py <= std_logic_vector(to_signed(2, DataWidth+1));
	i_qx <= std_logic_vector(to_signed(3, DataWidth+1));
	i_qy <= std_logic_vector(to_signed(4, DataWidth+1));
	wait for 1000 ns;
	assert o_rx=std_logic_vector(to_signed(-3, DataWidth+1)) report "error x" severity error;
	assert o_ry=std_logic_vector(to_signed(2, DataWidth+1)) report "error y" severity error;
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