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
   --Opcode: 1001 / rt: 0000 / rd: 0001 / Imm: 0101 = [LDI R1, 5]
  0 => x"9015",
   --Opcode: 1000 / rt: 0000 / rd: 0010 / Imm: 0000 = [LW R2, MEM[0]]
  1 => x"8020",
   --Opcode: 1100 / rt: 0001 / rd: 0001 / Imm: 0010 = [MULI R1, R1, 2]
  2 => x"C112",
   --Opcode: 0100 / rt: 0001 / rt: 0010 / Imm: 0010 = [BEQ R1, R2, 2]
  3 => x"4122",
   --Opcode: 0111 / rt: 0000 / rs: 0001 / Imm: 0001 = [SW R1, 1]
  4 => x"7011",
   --Opcode: 0101 / rt: 0000 / rs: 0001 / Imm: 0111 = [BNE R3, R4, 7]
  5 => x"5347",
   --Opcode: 0001 / rt: 0001 / rs: 0010 / rd: 0011 = [ADD R3, R1, R2]
  6 => x"1123",
   --Opcode: 1010 / rt: 0000 / rd: 0100 / Imm: 1010 = [ADDI R4, 10]
  7 => x"A04A",
   --Opcode: 1011 / rt: 0000 / rd: 0011 / Imm: 0101 = [SUBI R3, 5]
  8 => x"B335",
   --Opcode: 0010 / rt: 0011 / rt: 0101 / rd: 0101 = [SUB R5, R3, R4]
  9 => x"2345",
   --Opcode: 0011 / rs: 0101 / rt: 0001 / rd: 0110 = [MUL R6, R5, R1]
  10 => x"3516",
   --Opcode: 0110 / Endereço: 0100 = [JMP 4]
  11 => x"6004",
   --Opcode: 0010 / rt: 0010 / rs: 0100 / rd: 0001 = [SUB R1, R2, R4]
  12 => x"2241",
  
  others => (others => '0')
 );

begin
  
 instMem_out <= mem(conv_integer(adress));
  
end architecture;
