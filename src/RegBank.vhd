library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity RegBank is
 port(
  clock, reset, reg_write : in std_logic;
  reg_a, reg_b, reg_dest : in std_logic_vector(3 downto 0);--4?
  data : in std_logic_vector(15 downto 0);
  a_out, b_out : out std_logic_vector(15 downto 0)--4?
 );
end entity;

architecture behavior of RegBank is

 type registersBank is array (0 to 15) of std_logic_vector(15 downto 0);
 signal regBank : registersBank;
 signal readed_a, readed_b : std_logic_vector(15 downto 0);

begin

 process(clock, reset, reg_write)
 begin
 
  if reset = '1' then
   regBank <= (others => (others => '0'));
  elsif rising_edge(clock) then   
    if reg_write = '1' then
     --regBank(reg_dest) <= data;
     regBank(conv_integer(reg_dest)) <= data;
    -- end if;
    --readed_a <= reg_a;
    --readed_b <= reg_b;
   end if;
  end if;
  
 end process;
 
 --a_out  <= readed_a;
 --b_out  <= readed_b;
 readed_a <= regBank(conv_integer(reg_a));
 readed_b <= regBank(conv_integer(reg_b));
 
end architecture;