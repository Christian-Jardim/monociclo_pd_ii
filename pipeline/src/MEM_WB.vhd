library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity MEM_WB is
 port(
  clock, reset : in std_logic;
  mem_to_reg, reg_write : in std_logic;
  mem_out, ula_out : in std_logic_vector(15 downto 0);
  rd : in std_logic_vector(3 downto 0);
  
  mem_to_reg_out, reg_write_out : out std_logic;
  mem_out_out, ula_out_out : out std_logic_vector(15 downto 0);
  rd_out : out std_logic_vector(3 downto 0)
 );
end entity;

architecture behavior of MEM_WB is

begin

 process(clock, reset)
 begin
  if reset = '1' then
   mem_to_reg_out <= '0';
   reg_write_out <= '0';
   mem_out_out <= (others => '0');
   ula_out_out <= (others => '0');
   rd_out <= (others => '0');
  elsif rising_edge(clock) then
   mem_to_reg_out <= mem_to_reg;
   reg_write_out <= reg_write;
   mem_out_out <= mem_out;
   ula_out_out <= ula_out;
   rd_out <= rd;
  end if;
 end process;
 
end architecture;
