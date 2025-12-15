library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity EX_MEM is
 port(
  clock, reset : in std_logic;
  mem_write, mem_to_reg, reg_write, branch_e, branch_ne, jump : in std_logic;
  ula_out, b : in std_logic_vector(15 downto 0);
  rt, rd : in std_logic_vector(3 downto 0);
  
  mem_write_out, mem_to_reg_out, reg_write_out, branch_e_out, branch_ne_out, jump_out : out std_logic;
  ula_out_out, b_out : out std_logic_vector(15 downto 0);
  rt_out, rd_out : out std_logic_vector(3 downto 0)
 );
end entity;

architecture behavior of EX_MEM is

begin

 process(clock, reset)
 begin
  if reset = '1' then
   mem_write_out <= '0';
   mem_to_reg_out <= '0';
   reg_write_out <= '0';
   branch_e_out <= '0';
   branch_ne_out <= '0';
   jump_out <= '0';
   ula_out_out <= (others => '0');
   b_out  <= (others => '0');
   rt_out <= (others => '0');
   rd_out <= (others => '0');
  elsif rising_edge(clock) then
   mem_write_out <= mem_write;
   mem_to_reg_out <= mem_to_reg;
   reg_write_out <= reg_write;
   branch_e_out <= branch_e;
   branch_ne_out <= branch_ne;
   jump_out <= jump;
   ula_out_out <= ula_out;
   b_out  <= b;
   rt_out <= rt;
   rd_out <= rd;
  end if;
 end process;

end architecture;
