library ieee;                  
use ieee.std_logic_1164.all;   
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all; 

entity top_SinglecycleProcessor is
    port(
            clock  : in std_logic;
            reset  : in std_logic;
            pc_out : out std_logic_vector(7 downto 0);
            );
end entity;

architecture behavior of top_SinglecycleProcessor is 

    component ControlUnit is
     port(
      op_code      : in std_logic_vector(3 downto 0);
      ula_control : out std_logic_vector(1 downto 0);
      reg_src, ula_src, mem_write, mem_to_reg, reg_write, branch_e, branch_ne, jump : out std_logic
     );
    end component;
    
    component pc is
     port(
      clock    : in std_logic;
      reset    : in std_logic;
      pc_next  : in std_logic_vector(7 downto 0);
      pc_out   : out std_logic_vector(7 downto 0)
     );
    end component;

    component PC_Adder is
     port(
      current_pc : in std_logic_vector(7 downto 0);
      new_pc     : out std_logic_vector(7 downto 0)
     );
    end component;

    component InstMem is
     port(
      adress       : in std_logic_vector(7 downto 0); 
      instMem_out : out std_logic_vector(15 downto 0)
     );
    end component;

    component RegBank is
     port(
      clock, reset, reg_write : in std_logic;
      reg_a, reg_b, reg_dest : in std_logic_vector(3 downto 0);
      data : in std_logic_vector(15 downto 0);
      a_out, b_out : out std_logic_vector(15 downto 0)
     );
    end component;

    component ULA is
     port(
      entry_a, entry_b : in std_logic_vector(15 downto 0);
      ula_control      : in std_logic_vector(1 downto 0); 
      ula_out          : out std_logic_vector(15 downto 0);
      zero_ula         : out std_logic
     );
    end component;

    component DataMem is
     port(
      clock        : in std_logic;
      mem_write    : in std_logic;
      adress       : in std_logic_vector(15 downto 0); 
      data         : in std_logic_vector(15 downto 0); 
      dataMem_out : out std_logic_vector(15 downto 0)
     );
    end component;
    
    component MuxRegSrc is
     port(
      reg_src : in std_logic;
      rd, rs : in std_logic_vector(3 downto 0); 
      mux_out : out std_logic_vector(3 downto 0)
     );
    end component;

    component MuxULASrc is
     port(
      ula_src : in std_logic;
      rt, imm : in std_logic_vector(15 downto 0); 
      mux_out : out std_logic_vector(15 downto 0)
     );
    end component;

    component MuxMemReg is
     port(
      mem_to_reg : in std_logic;
      ula_out, data : in std_logic_vector(15 downto 0);
      mux_out : out std_logic_vector(15 downto 0)
     );
    end component;
    
    
    -- pc
    signal s_pc_atual      : std_logic_vector(7 downto 0);
    signal s_pc_mais_1     : std_logic_vector(7 downto 0);
    signal s_pc_next       : std_logic_vector(7 downto 0); -- Faltava declarar
    signal s_instruction   : std_logic_vector(15 downto 0);

    -- control
    signal s_ula_control   : std_logic_vector(1 downto 0);
    signal s_reg_write, s_mem_write, s_mem_to_reg : std_logic;
    signal s_ula_src, s_reg_src, s_jump, s_branch_e, s_branch_ne : std_logic;

    -- banco de registradores
    signal s_data_reg_a    : std_logic_vector(15 downto 0); 
    signal s_data_reg_b    : std_logic_vector(15 downto 0); 
    signal s_data_to_write : std_logic_vector(15 downto 0); 
    signal s_dest_addr     : std_logic_vector(3 downto 0);  

    -- ULA
    signal s_ula_entry_b   : std_logic_vector(15 downto 0); 
    signal s_ula_result    : std_logic_vector(15 downto 0); 
    signal s_ula_zero      : std_logic;                     

    -- memória de dados
    signal s_mem_data_read : std_logic_vector(15 downto 0); 

    -- aux
    signal s_imediato_ext  : std_logic_vector(15 downto 0);
    signal s_branch_check  : std_logic; 

begin

    pc_out <= s_pc_atual; 

    -- extensão de sinal
    s_imediato_ext <= x"000" & s_instruction(3 downto 0);

    -- decisão do branch
    s_branch_check <= '1' when (s_branch_e = '1' and s_ula_zero = '1') or 
                               (s_branch_ne = '1' and s_ula_zero = '0') else '0';

    -- mux do próximo PC
    process(s_pc_mais_1, s_branch_check, s_imediato_ext, s_jump, s_instruction)
    begin
        if s_jump = '1' then
            -- JUMP
            s_pc_next <= s_instruction(7 downto 0); 
        elsif s_branch_check = '1' then
            -- BRANCH: PC + 1 + Imediato
            s_pc_next <= s_pc_mais_1 + s_imediato_ext(7 downto 0);
        else
            s_pc_next <= s_pc_mais_1;
        end if;
    end process;

    inst_pc: pc
        port map(
            clock    => clock, 
            reset    => reset,
            pc_next  => s_pc_next,
            pc_out   => s_pc_atual
        );

    inst_PC_Adder: PC_Adder
        port map(
            current_pc => s_pc_atual,
            new_pc     => s_pc_mais_1
        );

    inst_InstMem: InstMem
        port map(
            adress      => s_pc_atual,
            instMem_out => s_instruction
        );

    inst_ControlUnit: ControlUnit
        port map(
            op_code     => s_instruction(15 downto 12), 
            ula_control => s_ula_control,
            reg_src     => s_reg_src,
            ula_src     => s_ula_src,
            mem_write   => s_mem_write,
            mem_to_reg  => s_mem_to_reg,
            reg_write   => s_reg_write,
            branch_e    => s_branch_e,
            branch_ne   => s_branch_ne,
            jump        => s_jump
        );

    inst_MuxRegSrc: MuxRegSrc
        port map(
            reg_src => s_reg_src,
            rs => s_instruction(7 downto 4), 
            rd => s_instruction(3 downto 0), 
            mux_out => s_dest_addr
        );

    inst_RegBank: RegBank
        port map(
            clock     => clock,
            reset     => reset,
            reg_write => s_reg_write,
            
            reg_a     => s_instruction(11 downto 8), 
            reg_b     => s_instruction(7 downto 4),  
            reg_dest  => s_dest_addr,                
            
            data      => s_data_to_write,            
            
            a_out     => s_data_reg_a,
            b_out     => s_data_reg_b
        );

    inst_MuxULASrc: MuxULASrc
        port map(
            ula_src => s_ula_src,
            rt      => s_data_reg_b,   
            imm     => s_imediato_ext, 
            mux_out => s_ula_entry_b
        );

    inst_ULA: ULA
        port map(
            entry_a     => s_data_reg_a,
            entry_b     => s_ula_entry_b, 
            ula_control => s_ula_control,
            ula_out     => s_ula_result,
            zero_ula    => s_ula_zero
        );

    inst_DataMem: DataMem
        port map(
            clock       => clock,
            mem_write   => s_mem_write,
            adress      => s_ula_result, 
            data        => s_data_reg_b, 
            dataMem_out => s_mem_data_read
        );

    inst_MuxMemReg: MuxMemReg
        port map(
            mem_to_reg => s_mem_to_reg,
            ula_out    => s_ula_result,    
            data       => s_mem_data_read, 
            mux_out    => s_data_to_write
        );
          
end behavior;
