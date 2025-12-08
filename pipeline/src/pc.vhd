library ieee;
use ieee.std_logic_1164.all;

entity pc is
 port(
  clock   : in std_logic;
  reset   : in std_logic;
  write_en : in std_logic;
  pc_next : in std_logic_vector(7 downto 0);
  pc_out  : out std_logic_vector(7 downto 0)
 );
end entity;

architecture behavior of pc is

signal pc_s : std_logic_vector(7 downto 0);

begin

process(clock, reset)
 begin
  if reset = '1' then
   pc_s <= (others => '0');
  
  elsif (rising_edge(clock) and write_en = '1') then
    pc_s <= pc_next;
  end if;
end process;

 pc_out <= pc_s;

end architecture;
