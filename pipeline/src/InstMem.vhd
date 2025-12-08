library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity InstMem is -- ROM (Memória de Instruções)
 port(
  adress : in std_logic_vector(7 downto 0);
  instMem_out : out std_logic_vector(15 downto 0)
 );
end entity;

architecture behavior of InstMem is

 type memory is array(0 to 255) of std_logic_vector(15 downto 0);
 
 signal mem : memory := (
   --Opcode: 1000 / Rs: 0000 / Rt: 0001 / Imm: 0101 = [LDI R1, 5]
  0 => x"8015",
   --Opcode: 1001 / Rs: 0001 / Rt: 0001 / Imm: 0010 = [ADDI R1, 2]
  1 => x"9112",
   --Opcode: 0111 / Rs: 0000 / Rt: 0001 / Imm: 1111 = [SW R1, 15]
  2 => x"701F",
   --Opcode: 0110 / Rs: 0000 / Rt: 0000 / Endereço: 0001 = [JMP 1]
  3 => x"6001",
  
  others => (others => '0')
 );

begin
  
 instMem_out <= mem(conv_integer(adress));
  
end architecture;
