library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity MuxRegSrc is
 port(
  ula_src : in std_logic;
  rt,  imm : in std_logic_vector(15 downto 0);
  ula_out : out std_logic_vector(15 downto 0)
 );
end entity;

architecture bevavior of MuxRegDest is
begin

ula_out <= rt when reg_src = '0' else
		   imm;

end architecture;
