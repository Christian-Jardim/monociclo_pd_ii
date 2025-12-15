library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity MuxMemReg is
 port(
  mem_to_reg : in std_logic;
   
  ula_out, data : in std_logic_vector(15 downto 0);
  mux_out : out std_logic_vector(15 downto 0)
 );
end entity;

architecture behavior of MuxMemReg is
begin
 
 mux_out <= data when mem_to_reg = '1' else ula_out;

end architecture;