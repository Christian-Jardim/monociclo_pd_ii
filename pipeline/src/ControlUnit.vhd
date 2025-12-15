library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ControlUnit is
 port(
  op_code : in std_logic_vector(3 downto 0);
  ula_control : out std_logic_vector(1 downto 0);
  reg_src, ula_src, mem_write, mem_to_reg, reg_write, branch_e, branch_ne, jump : out std_logic
 );
end entity;

architecture behavior of ControlUnit is

begin

 process(op_code)
 begin
 
  -- DECODIFICACOES 
  
  -- LDI / ADDI (tratados iguais na ULA)
  if op_code = "1001" or op_code = "1010" then 
   reg_src <= '1';
   ula_src <= '1';
   ula_control <= "00";
   mem_write <= '0';
   mem_to_reg <= '0';
   reg_write <= '1'; 
   branch_e <= '0'; 
   branch_ne <= '0'; 
   jump <= '0';
    
  elsif op_code = "1011" then -- subi
   reg_src <= '1';
   ula_src <= '1';
   ula_control <= "10";
   mem_write <= '0';
   mem_to_reg <= '0';
   reg_write <= '1';
   branch_e <= '0';
   branch_ne <= '0';
   jump <= '0';
   
  elsif op_code = "1100" then -- muli
   reg_src <= '1';
   ula_src <= '1';
   ula_control <= "11";
   mem_write <= '0';
   mem_to_reg <= '0';
   reg_write <= '1';
   branch_e <= '0';
   branch_ne <= '0';
   jump <= '0';
    
  elsif op_code = "0100" then -- beq
   reg_src <= '0';
   ula_src <= '0';
   ula_control <= "10";
   mem_write <= '0';
   mem_to_reg <= '0';
   reg_write <= '0';
   branch_e <= '1';
   branch_ne <= '0';
   jump <= '0';
   
  elsif op_code = "0101" then -- bne
   reg_src <= '0';
   ula_src <= '0';
   ula_control <= "10";
   mem_write <= '0';
   mem_to_reg <= '0';
   reg_write <= '0';
   branch_e <= '0';
   branch_ne <= '1';
   jump <= '0';
   
  elsif op_code = "0110" then -- jmp
   reg_src <= '0';
   ula_src <= '0';
   ula_control <= "00";
   mem_write <= '0';
   mem_to_reg <= '0';
   reg_write <= '0';
   branch_e <= '0';
   branch_ne <= '0';
   jump <= '1';
   
  elsif op_code = "0111" then -- sw
   reg_src <= '1';
   ula_src <= '1';
   ula_control <= "00";
   mem_write <= '1';
   mem_to_reg <= '0';
   reg_write <= '0';
   branch_e <= '0';
   branch_ne <= '0';
   jump <= '0';
   
  elsif op_code = "1000" then -- lw
   reg_src <= '1';
   ula_src <= '1';
   ula_control <= "00";
   mem_write <= '0';
   mem_to_reg <= '1';
   reg_write <= '1';
   branch_e <= '0';
   branch_ne <= '0';
   jump <= '0';
   
  elsif op_code = "0001" then -- add
   reg_src <= '0';
   ula_src <= '0';
   ula_control <= "01";
   mem_write <= '0';
   mem_to_reg <= '0';
   reg_write <= '1';
   branch_e <= '0';
   branch_ne <= '0';
   jump <= '0';
   
  elsif op_code = "0010" then -- sub
   reg_src <= '0';
   ula_src <= '0';
   ula_control <= "10";
   mem_write <= '0';
   mem_to_reg <= '0';
   reg_write <= '1';
   branch_e <= '0';
   branch_ne <= '0';
   jump <= '0';
   
  elsif op_code = "0011" then -- mul
   reg_src <= '0';
   ula_src <= '0';
   ula_control <= "11";
   mem_write <= '0';
   mem_to_reg <= '0';
   reg_write <= '1';
   branch_e <= '0';
   branch_ne <= '0';
   jump <= '0';
   
  else 
   -- estado seguro
   reg_src <= '0';
   ula_src <= '0';
   ula_control <= "00";
   mem_write <= '0';
   mem_to_reg <= '0';
   reg_write <= '0';
   branch_e <= '0';
   branch_ne <= '0';
   jump <= '0';
  end if;
  
 end process;
 
end architecture;
