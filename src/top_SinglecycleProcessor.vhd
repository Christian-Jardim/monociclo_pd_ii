library ieee;                 
use ieee.std_logic_1164.all;  
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all; 

entity top_SinglecycleProcessor is
	port(
			clock		: in std_logic;		
			reset  : in std_logic;
			);
end entity;

architecture behavior of top_SinglecycleProcessor is -- faltam mais componentes, sinais e portas

 component ControlUnit is
  port(
   op_code : in std_logic_vector(3 downto 0);
   ula_control : out std_logic_vector(1 downto 0);
   reg_write, branch_e, branch_ne, jump : out std_logic
  );
 end component;
 
 component ULA is
  port(
   entry_a, entry_b : in std_logic_vector(15 downto 0);
   zero_ula : out std_logic 
  );
 end component;
 

------------------------------- Sinais (fios)
 -- PC e mem rom
 signal pc_sg : std_logic_vector(7 downto 0);
 signal instruction_sg : std_logic_vector(15 downto 0);
 
 -- control unit
 signal reg_write_sg, mem_write_sg, mem_to_reg_sg : std_logic;
 signal ula_src_sg, reg_src_sg, jump_sg, beq_sg, bne_sg : std_logic;
 signal ula_control_sg : std_logic_vector(1 downto 0);
 
 -- reg bank
 signal data_reg_a_sg, data_reg_b_sg : std_logic_vector(15 downto 0);
 signal data_to_reg_sg : std_logic_vector(15 downto 0);
 signal dest_address_reg_sg : std_logic_vector(3 downto 0);
 
 -- ULA
 signal ula_entry_b_sg : std_logic_vector(15 downto 0);
 signal ula_result_sg : std_logic_vector(15 downto 0);
 signal ula_flag_zero_sg : std_logic;

begin


--------------------------------- instancias          
          
 UC: ControlUnit
  port map(
   op_code => instruction(15 downto 12), -- 4 bits mais significativos do opcode
   
   reg_write => reg_write_sg,
   mem_write => mem_write_sg,
   ula_src => ula_src_sg,
   ula_control => ula_control_sg,
 );
  
 RB: RegBank
  port map(
   clock => clock_sg,
   reset => reset_sg,
   reg_write => reg_write_sg,
   
   reg_a => instruction(11 downto 8),
   reg_b => instruction(7 downto 4),
   reg_dest => dest_address_reg_sg, --MuxRegDest
   
   data => data_to_reg_sg, -- MuxMemReg
   
   a_out => data_reg_a_sg,
   b_out => data_reg_b_sg
 );
          
end behavior;