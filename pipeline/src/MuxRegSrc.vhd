library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity MuxRegSrc is
 port(
  reg_src : in std_logic;
  rs,  rd : in std_logic_vector(3 downto 0);
  mux_out : out std_logic_vector(3 downto 0)
 );
end entity;

architecture behavior of MuxRegSrc is
begin

 mux_out <= rs when reg_src = '1' else rd;

end architecture;
