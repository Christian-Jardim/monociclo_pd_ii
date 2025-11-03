library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity DataMem is
 port(
  clock, mem_write : in std_logic;
  adress, data : in std_logic_vector(15 downto 0);
  dataMem_out : out std_logic_vector(15 downto 0)
 );
end entity;

architecture behavior of DataMem is

 type memory is array (0 to 255) of std_logic_vector(15 downto 0);
 signal mem : memory := (others => (others => '0'));
 signal readed_data : std_logic_vector(15 downto 0);

begin

 mem(0) <= x"0004"; 
 
 process(clock, mem_write)
 begin
 
  if rising_edge(clock) then
   if mem_write = '1' then
    mem(conv_integer(adress)) <= data;
   end if;
   readed_data <= mem(conv_integer(adress));
  end if;

 end process;

 dataMem_out <= readed_data;

end architecture;
