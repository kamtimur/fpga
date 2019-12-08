library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity ellyptic_add_tb is
end;

architecture bench of ellyptic_add_tb is
  constant DataWidth : integer := 257;
  component ellyptic_add
  generic(DataWidth : integer);
    port (
		i_rst_l : in std_logic;
		i_clk   : in std_logic;
		i_p		: in std_logic_vector	(DataWidth-1 downto 0);
		i_a		: in std_logic_vector	(DataWidth-1 downto 0);
		i_b		: in std_logic_vector	(DataWidth-1 downto 0);
		i_px    : in std_logic_vector	(DataWidth-1 downto 0);
		i_py    : in std_logic_vector	(DataWidth-1 downto 0);
		i_qx    : in std_logic_vector	(DataWidth-1 downto 0);
		i_qy    : in std_logic_vector	(DataWidth-1 downto 0);
		o_rx	: out std_logic_vector	(DataWidth-1 downto 0);
		o_ry	: out std_logic_vector	(DataWidth-1 downto 0)
      );
  end component;

  signal i_rst_l: std_logic;
  signal i_clk: std_logic;
  signal i_p: std_logic_vector	(DataWidth-1 downto 0);
  signal i_a: std_logic_vector	(DataWidth-1 downto 0);
  signal i_b: std_logic_vector	(DataWidth-1 downto 0);
  signal i_px: std_logic_vector	(DataWidth-1 downto 0);
  signal i_py: std_logic_vector	(DataWidth-1 downto 0);
  signal i_qx: std_logic_vector	(DataWidth-1 downto 0);
  signal i_qy: std_logic_vector	(DataWidth-1 downto 0);
  signal o_rx: std_logic_vector	(DataWidth-1 downto 0);
  signal o_ry: std_logic_vector	(DataWidth-1 downto 0) ;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  -- Insert values for generic parameters !!
  uut: ellyptic_add generic map ( DataWidth =>  DataWidth)
                       port map ( i_rst_l   => i_rst_l,
                                  i_clk     => i_clk,
                                  i_p       => i_p,
                                  i_a       => i_a,
                                  i_b       => i_b,
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
	i_px <= "00111100110111110011001100111111011111001110111001011101110101100010101011010000001100010100101011100111010000111000010110000011100000010100110111111110011011011001011011100111000101000110110010101100111110010100000010101101100010110111110000001011110011000";
	i_py <= "00100100000111010110110100111011100100110101000111100010001100101010111011010010011111011111111000000111000010001000010001010100011111101000101111011010001001000101001101000010101010100000110011001110001000111110100001000111111111011000100001101010010111000";
	i_qx <= "00111100110111110011001100111111011111001110111001011101110101100010101011010000001100010100101011100111010000111000010110000011100000010100110111111110011011011001011011100111000101000110110010101100111110010100000010101101100010110111110000001011110011000";
	i_qy <= "00100100000111010110110100111011100100110101000111100010001100101010111011010010011111011111111000000111000010001000010001010100011111101000101111011010001001000101001101000010101010100000110011001110001000111110100001000111111111011000100001101010010111000";
	i_a  <= (others => '0');
	i_b  <= (2 downto 0 => '1', others => '0');
	i_p  <= "01111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111011111111111111111111110000101111";
	wait for clock_period*1000;
	assert o_rx = "01100011000000100011111111001010001000001111011010111110101101101001100000100010101000000011011101001010111000000011111001101100001011100011101111000111001001011100011001110111100111100101001111010101110101100000010011011100101011100011100001001111011100101" report "error x" severity error;
	assert o_ry = "00001101011100001011010001111111010100110001111011100001100111001101000111100010110000100000110010100011001101100111010101110111011110111111101100011001001100101001100100110011011010000111000010010001101100100001100011010100101010000110011111110010100101010" report "error y" severity error;
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
 
  