
library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity ellyptic_mult_tb is
end;

architecture bench of ellyptic_mult_tb is
  constant DataWidth : integer := 257;
  component ellyptic_mult
  generic(DataWidth : natural);
    port (
	i_rst_l : in 	std_logic;
	i_clk   : in 	std_logic;
  	i_p		: in 	std_logic_vector(DataWidth-1 downto 0);
  	i_a		: in 	std_logic_vector(DataWidth-1 downto 0);
  	i_b		: in 	std_logic_vector(DataWidth-1 downto 0);
    i_x  	: in 	std_logic_vector(DataWidth-1 downto 0);
  	i_y  	: in 	std_logic_vector(DataWidth-1 downto 0);
  	i_n		: in 	std_logic_vector(DataWidth-1 downto 0);
  	o_rx	: out 	std_logic_vector(DataWidth-1 downto 0);
  	o_ry	: out 	std_logic_vector(DataWidth-1 downto 0)
      );
  end component;

  signal i_rst_l: std_logic;
  signal i_clk: std_logic;
  signal i_p: std_logic_vector(DataWidth-1 downto 0);
  signal i_a: std_logic_vector(DataWidth-1 downto 0);
  signal i_b: std_logic_vector(DataWidth-1 downto 0);
  signal i_x: std_logic_vector(DataWidth-1 downto 0);
  signal i_y: std_logic_vector(DataWidth-1 downto 0);
  signal i_n: std_logic_vector(DataWidth-1 downto 0);
  signal o_rx: std_logic_vector(DataWidth-1 downto 0);
  signal o_ry: std_logic_vector(DataWidth-1 downto 0) ;

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
	i_x <= "00111100110111110011001100111111011111001110111001011101110101100010101011010000001100010100101011100111010000111000010110000011100000010100110111111110011011011001011011100111000101000110110010101100111110010100000010101101100010110111110000001011110011000";
	i_y <= "00100100000111010110110100111011100100110101000111100010001100101010111011010010011111011111111000000111000010001000010001010100011111101000101111011010001001000101001101000010101010100000110011001110001000111110100001000111111111011000100001101010010111000";
	-- i_n <= "01001000001101100101000010110110100000101001110101100111010000111000101010000111000001100111011001101100101111100001011001001011001100100110000000011000010001001000101000010001101001010001000111010111001001100101100000110001100001110010001111111111101110110";
	i_n  <= (2 downto 0 => '1', others => '0');
	i_a  <= (others => '0');
	i_b  <= (2 downto 0 => '1', others => '0');
	i_p  <= "01111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111011111111111111111111110000101111";
	while o_rx = (DataWidth-1 downto 0 => '0') loop
		wait for clock_period;
	end loop;
	-- wait for clock_period*100000000;
	assert o_rx = "00101110010111101111100000110010001101110010111011011010011101010101000111001100011110011011001011111001011101010011110100000111000111101010000011001101101111110000000110011000011100011100111001110100100101011110111011110110111001010110001001111100110111100" report "error x" severity error;
	assert o_ry = "00110101011101011110010100100000010111010001001010101100101100000101000110001011110001101011011011000011000011010010101001101101110101000000100111101000010111000000100111111110111100111101101011010010100001000001001100010100000001000011100100110010011011010" report "error y" severity error;
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

  