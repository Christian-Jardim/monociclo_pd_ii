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

 signal reg_src_s, ula_src_s, mem_write_s, mem_to_reg_s, reg_write_s, branch_e_s, branch_ne_s, jump_s : std_logic;
 signal ula_control_s : std_logic_vector(1 downto 0);
 signal pc_s : std_logic_vector(7 downto 0);
 signal a_s, b_s, imm_ext_s : std_logic_vector(15 downto 0);
 signal rs_s, rt_s, rd_s : std_logic_vector(3 downto 0);

begin

 process(clock, reset)
 begin
  if reset = '1' then
   reg_src_s <= '0';
   ula_src_s <= '0';
   mem_write_s <= '0';
   mem_to_reg_s <= '0';
   reg_write_s <= '0';
   branch_e_s <= '0';
   branch_ne_s <= '0';
   jump_s <= '0';
   ula_control_s <= (others => '0');
   a_s <= (others => '0');
   b_s <= (others => '0');
   imm_ext_s <= (others => '0');
   pc_s <= (others => '0');
   rs_s <= (others => '0');
   rt_s <= (others => '0');
   rd_s <= (others => '0');
  elsif rising_edge(clock) then
   reg_src_s <= reg_src;
   ula_src_s <= ula_src;
   mem_write_s <= mem_write;
   mem_to_reg_s <= mem_to_reg;
   reg_write_s <= reg_write;
   branch_e_s <= branch_e;
   branch_ne_s <= branch_ne;
   jump_s <= jump;
   ula_control_s  <= ula_control;
   a_s <= a;
   b_s <= b;
   imm_ext_s <= imm_ext;
   pc_s <= pc;
   rs_s <= rs;
   rt_s <= rt;
   rd_s <= rd;
  end if;
 end process;
 
 reg_src_out <= reg_src_s;
 ula_src_out <= ula_src_s;
 mem_write_out <= mem_write_s;
 mem_to_reg_out <= mem_to_reg_s;
 reg_write_out <= reg_write_s;
 branch_e_out <= branch_e_s;
 branch_ne_out <= branch_ne_s;
 jump_out <= jump_s;
 ula_control_out  <= ula_control_s;
 a_out <= a_s;
 b_out <= b_s;
 imm_ext_out <= imm_ext_s;
 pc_out <= pc_s;
 rs_out <= rs_s;
 rt_out <= rt_s;
 rd_out <= rd_s;
 
end architecture;
