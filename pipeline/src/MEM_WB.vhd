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

 signal mem_to_reg_s, reg_write_s : std_logic;
 signal mem_out_s, ula_out_s : std_logic_vector(15 downto 0);
 signal rd_s : std_logic_vector(3 downto 0);

begin

 process(clock, reset)
 begin
  if reset = '1' then
   mem_to_reg_s <= '0';
   reg_write_s <= '0';
   mem_out_s <= (others => '0');
   ula_out_s <= (others => '0');
   rd_s <= (others => '0');
  elsif rising_edge(clock) then
   mem_to_reg_s <= mem_to_reg;
   reg_write_s <= reg_write;
   mem_out_s <= mem_out;
   ula_out_s <= ula_out;
   rd_s <= rd;
  end if;
 end process;
 
   mem_to_reg_out <= mem_to_reg_s;
   reg_write_out <= reg_write_s;
   mem_out_out <= mem_out_s;
   ula_out_out <= ula_out_s;
   rd_out <= rd_s; 
 
end architecture;
