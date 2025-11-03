library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity InstMem is
 port(
  adress : in std_logic_vector(7 downto 0);
  instMem_out : out std_logic_vector(15 downto 0)
 );
end entity;

architecture behavior of InstMem is

 type memory is array(0 to 255) of std_logic_vector(15 downto 0);
 signal mem : memory := (others => (others => '0'));

begin

 mem(0) <= x"9100";
 mem(1) <= x"0310";
 mem(2) <= x"C201";
 mem(3) <= x"5104";
 mem(4) <= x"5203";
 mem(5) <= x"2332";
 mem(6) <= x"D221";
 mem(7) <= x"4004";
 mem(8) <= x"8301";
 mem(9) <= x"CF0A";
  
 instMem_out <= mem(con_integer(adress));
  
end architecture;
