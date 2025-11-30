library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity PC_Adder is
 port(
  current_pc : in std_logic_vector(7 downto 0);
  new_pc : out std_logic_vector(7 downto 0)
 );
end entity;

architecture behavior of PC_Adder is
begin
 new_pc <= current_pc + 1;
end architecture;