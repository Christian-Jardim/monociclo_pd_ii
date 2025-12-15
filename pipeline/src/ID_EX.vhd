library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ID_EX is
 port(
  clock, reset : in std_logic;
  reg_src, ula_src, mem_write, mem_to_reg, reg_write, branch_e, branch_ne, jump : in std_logic;
  ula_control : in std_logic_vector(1 downto 0); 
  pc : in std_logic_vector(7 downto 0);
  a, b, imm_ext : in std_logic_vector(15 downto 0);
  rs, rt, rd : in std_logic_vector(3 downto 0);
    
  reg_src_out, ula_src_out, mem_write_out, mem_to_reg_out, reg_write_out, branch_e_out, branch_ne_out, jump_out : out std_logic;
  ula_control_out : out std_logic_vector(1 downto 0); 
  pc_out : out std_logic_vector(7 downto 0);
  a_out, b_out, imm_ext_out : out std_logic_vector(15 downto 0);
  rs_out, rt_out, rd_out : out std_logic_vector(3 downto 0)
  
 );
end entity;

architecture behavior of ID_EX is

begin

 process(clock, reset)
 begin
  if reset = '1' then
   reg_src_out <= '0';
   ula_src_out <= '0';
   mem_write_out <= '0';
   mem_to_reg_out <= '0';
   reg_write_out <= '0';
   branch_e_out <= '0';
   branch_ne_out <= '0';
   jump_out <= '0';
   ula_control_out <= (others => '0');
   a_out <= (others => '0');
   b_out <= (others => '0');
   imm_ext_out <= (others => '0');
   pc_out <= (others => '0');
   rs_out <= (others => '0');
   rt_out <= (others => '0');
   rd_out <= (others => '0');
  elsif rising_edge(clock) then
   reg_src_out <= reg_src;
   ula_src_out <= ula_src;
   mem_write_out <= mem_write;
   mem_to_reg_out <= mem_to_reg;
   reg_write_out <= reg_write;
   branch_e_out <= branch_e;
   branch_ne_out <= branch_ne;
   jump_out <= jump;
   ula_control_out  <= ula_control;
   a_out <= a;
   b_out <= b;
   imm_ext_out <= imm_ext;
   pc_out <= pc;
   rs_out <= rs;
   rt_out <= rt;
   rd_out <= rd;
  end if;
 end process;
 
end architecture;
