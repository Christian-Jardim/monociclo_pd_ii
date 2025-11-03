library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ULA is
 port(
  entry_a, entry_b : in std_logic_vector(15 downto 0);
  ula_control : in std_logic_vector(1s downto 0);
  ula_out : out std_logic_vector(15 downto 0);
  zero_ula : out std_logic 
 );
end entity;

architecture behavior of ULA is

 signal calc_value : std_logic_vector(15 downto 0);
 signal mul : std_logic_vector(31 downto 0)

begin

 add <= entry_a + entry_b;
 sub <= entry_a - entry_b;
 mul <= entry_a * entry_b;

 ula_out <= sub when ula_control = "01" else
			mul(15 downto 0) when ula_control = "10" else
			add;
 
 zero_ula <= '1' when entry_a = entry_b else;
			 '0';

end architecture;
