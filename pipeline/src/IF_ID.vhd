library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity IF_ID is
 port(
  clock, reset : in std_logic;
  pc : in std_logic_vector(7 downto 0);
  inst : in std_logic_vector(15 downto 0);
  inst_out : out std_logic_vector(15 downto 0);
  pc_out : out std_logic_vector(7 downto 0)
 );
end entity;

architecture behavior of IF_ID is

begin

 process(clock, reset)
 begin
  if reset = '1' then
   pc_out <= (others => '0');
   inst_out <= (others => '0');
  elsif rising_edge(clock) then
   pc_out <= pc;
   inst_out <= inst;
  end if;
 end process;
 
end architecture;
