library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity MuxRegSrc is
 port(
  reg_src : in std_logic;
  rd,  rs : in std_logic_vector(15 downto 0);
  mux_out : out std_logic_vector(15 downto 0)
 );
end entity;

architecture behavior of MuxRegDest is
begin

 mux_out <= rd when reg_src = '0' else
		   rs;

end architecture;
