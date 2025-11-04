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

 signal ucs : std_logic_vector(1 downto 0);
 signal rss, uss, mws, mrs, rws, bes, bnes, js : std_logic;

begin

 process(op_code)
 begin
 
  -- DECODIFICAÇÕES. quanto menos especificas (menores), mais abaixo devem ficar
  if op_code = "1000" then -- beq
   rss <= '0';
   uss <= '1';
   ucs <= "00";
   mws <= '1';
   mrs <= '0';
   rws <= '0';
   bes <= '0';
   bnes <= '0';
   js <= '0';
   
  elsif op_code = "1001" then -- bne
   rss <= '0';
   uss <= '1';
   ucs <= "00";
   mws <= '0';
   mrs <= '0';
   rws <= '1';
   bes <= '0';
   bnes <= '0';
   js <= '0';
   
  elsif op_code = "1100" then -- ldi (igual multi)
   rss <= '1';
   uss <= '1';
   ucs <= "00";
   mws <= '0';
   mrs <= '1';
   rws <= '1';
   bes <= '0';
   bnes <= '0';
   js <= '0';
   
  elsif op_code = "1101" then -- addi
   rss <= '1';
   uss <= '1';
   ucs <= "00";
   mws <= '0';
   mrs <= '1';
   rws <= '1';
   bes <= '0';
   bnes <= '0';
   js <= '0';
   
  elsif op_code = "1110" then -- subi
   rss <= '1';
   uss <= '1';
   ucs <= "01";
   mws <= '0';
   mrs <= '1';
   rws <= '1';
   bes <= '0';
   bnes <= '0';
   js <= '0';
   
  elsif op_code = "1100" then -- muli (igual ldi)
   rss <= '1';
   uss <= '1';
   ucs <= "10";
   mws <= '0';
   mrs <= '1';
   rws <= '1';
   bes <= '0';
   bnes <= '0';
   js <= '0';
   
   
   elsif op_code(2 downto 0) = "100" then -- sw
   rss <= '0';
   uss <= '0';
   ucs <= "00";
   mws <= '0';
   mrs <= '0';
   rws <= '0';
   bes <= '0';
   bnes <= '0';
   js <= '1';
   
  elsif op_code(2 downto 0) = "101" then -- lw
   rss <= '1';
   uss <= '0';
   ucs <= "00";
   mws <= '0';
   mrs <= '1';
   rws <= '0';
   bes <= '1';
   bnes <= '0';
   js <= '0';
   
  elsif op_code(2 downto 0) = "110" then -- j
   rss <= '1';
   uss <= '0';
   ucs <= "00";
   mws <= '0';
   mrs <= '0';
   rws <= '0';
   bes <= '0';
   bnes <= '0';
   js <= '1';
   
   
   -- os dois bits menos significativos do opcode -> ula control (seletor)
   --if op_code(1 downto 0) = "00" then -- add
  elsif op_code(1 downto 0) = "01" then -- add
   rss <= '1';
   uss <= '0';
   ucs <= "01";
   mws <= '0';
   mrs <= '1';
   rws <= '1';
   bes <= '0';
   bnes <= '0';
   js <= '0';
   
  --elsif op_code(1 downto 0) = "01" then -- sub
  elsif op_code(1 downto 0) = "10" then -- sub
   rss <= '1';
   uss <= '0';
   ucs <= "10";
   mws <= '0';
   mrs <= '1';
   rws <= '1';
   bes <= '0';
   bnes <= '0';
   js <= '0';
   
  --elsif op_code(1 downto 0) = "10" then -- mul
  elsif op_code(1 downto 0) = "11" then -- mul
   rss <= '1';
   uss <= '0';
   ucs <= "11";
   mws <= '0';
   mrs <= '1';
   rws <= '1';
   bes <= '0';
   bnes <= '0';
   js <= '0';
  end if;
  
 end process;
 
 reg_src <= rss;
 ula_src <= uss;
 ula_control <= ucs;
 mem_write <= mws;
 mem_to_reg <= mrs;
 reg_write <= rws;
 jump <= js;
 branch_e <= bes;
 branch_ne <= bnes;

end architecture;