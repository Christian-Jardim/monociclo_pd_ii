library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity IF_ID is
 port(
  clock, reset, write_en : in std_logic;
  pc : in std_logic_vector(7 downto 0);
  inst : in std_logic_vector(15 downto 0);
  inst_out : out std_logic_vector(15 downto 0);
  pc_out : out std_logic_vector(7 downto 0)
 );
end entity;

architecture behavior of IF_ID is

 signal inst_s : std_logic_vector(15 downto 0) := (others => '0');
 signal pc_s : std_logic_vector(7 downto 0) := (others => '0');

begin

 process(clock, reset)
 begin
  if reset = '1' then
   pc_s <= (others => '0');
   inst_s <= (others => '0');
  elsif (rising_edge(clock) and write_en = '1') then
   pc_s <= pc;
   inst_s <= inst;
  end if;
 end process;
 
 pc_out <= pc_s;
 inst_out <= inst_s;
 
end architecture;
