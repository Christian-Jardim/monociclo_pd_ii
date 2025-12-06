library ieee;
use ieee.std_logic_1164.all;

entity pc is
 port(
  clock   : in std_logic;
  reset   : in std_logic;
  pc_next : in std_logic_vector(7 downto 0);
  pc_out  : out std_logic_vector(7 downto 0)
 );
end entity;

architecture behavior of pc is
begin

process(clock, reset)
 begin
  if reset = '1' then
   pc_out <= (others => '0');
  
  elsif rising_edge(clock) then
    pc_out <= pc_next;
  end if;
end process;

end architecture;