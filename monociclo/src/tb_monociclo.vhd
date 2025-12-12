library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity tb_monociclo is
end entity;

architecture behavior of tb_monociclo is
 signal tb_clock : std_logic:= '0';
 signal tb_reset : std_logic:= '1';
begin

 sim_monociclo : entity work.top_SinglecycleProcessor
 port map(
  clock => tb_clock,
  reset => tb_reset
 );

 tb_reset <= '0' after 15 ps;
 tb_clock <= not tb_clock after 10 ps;
end architecture;
