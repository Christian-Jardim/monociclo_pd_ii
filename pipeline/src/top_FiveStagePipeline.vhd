library ieee;                  
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity top_FiveStagePipeline is
    port(
        clock  : in std_logic;     
        reset  : in std_logic;
        pc_out : out std_logic_vector(7 downto 0)
    );
end entity;


architecture behavior of top_FiveStagePipeline is 

    -- =================================================================================
    -- 1. DECLARAÇÃO DOS COMPONENTES
    -- =================================================================================
    
    component pc is
     port(
      clock    : in std_logic;
      reset    : in std_logic;
      pc_next  : in std_logic_vector(7 downto 0);
      pc_out   : out std_logic_vector(7 downto 0)
     );
    end component;

    component InstMem is
     port(
      adress       : in std_logic_vector(7 downto 0); 
      instMem_out : out std_logic_vector(15 downto 0)
     );
    end component;
    
    component ControlUnit is
     port(
      op_code      : in std_logic_vector(3 downto 0);
      ula_control  : out std_logic_vector(1 downto 0);
      reg_src, ula_src, mem_write, mem_to_reg, reg_write, branch_e, branch_ne, jump : out std_logic
     );
    end component;
    
    component MuxRegSrc is
     port(
      reg_src : in std_logic;
      rs, rd : in std_logic_vector(3 downto 0);
      mux_out : out std_logic_vector(3 downto 0)
     );
    end component;

    component RegBank is
     port(
      clock     : in std_logic;
      reset     : in std_logic;
      reg_write : in std_logic;
      reg_a     : in std_logic_vector(3 downto 0);
      reg_b     : in std_logic_vector(3 downto 0);
      reg_dest  : in std_logic_vector(3 downto 0);
      data      : in std_logic_vector(15 downto 0);
      a_out     : out std_logic_vector(15 downto 0);
      b_out     : out std_logic_vector(15 downto 0)
     );
    end component;

    component MuxULASrc is
     port(
      ula_src : in std_logic;
      rs      : in std_logic_vector(15 downto 0);
      imm     : in std_logic_vector(15 downto 0);
      mux_out : out std_logic_vector(15 downto 0)
     );
    end component;

    component ULA is
     port(
      entry_a, entry_b : in std_logic_vector(15 downto 0);
      ula_control : in std_logic_vector(1 downto 0);
      ula_out     : out std_logic_vector(15 downto 0);
      zero_ula    : out std_logic
     );
    end component;

    component DataMem is
     port(
      clock      : in std_logic;
      mem_write  : in std_logic;
      adress     : in std_logic_vector(15 downto 0);
      data       : in std_logic_vector(15 downto 0);
      dataMem_out : out std_logic_vector(15 downto 0)
     );
    end component;

    component MuxMemReg is
     port(
      mem_to_reg : in std_logic;
      ula_out    : in std_logic_vector(15 downto 0);
      data       : in std_logic_vector(15 downto 0);
      mux_out    : out std_logic_vector(15 downto 0)
     );
    end component;

    -- REGISTRADORES DE PIPELINE
    component IF_ID is
     port(
      clock, reset : in std_logic;
      pc : in std_logic_vector(7 downto 0);
      inst : in std_logic_vector(15 downto 0);
      pc_out : out std_logic_vector(7 downto 0);
      inst_out : out std_logic_vector(15 downto 0)
     );
    end component;
    
    component ID_EX is
     port(
      clock, reset : in std_logic;
      ula_control : in std_logic_vector(1 downto 0);
      reg_src, ula_src, mem_write, mem_to_reg, reg_write, branch_e, branch_ne, jump : in std_logic;
      pc : in std_logic_vector(7 downto 0);
      a, b, imm_ext : in std_logic_vector(15 downto 0);
      rs, rt, rd : in std_logic_vector(3 downto 0);
      
      ula_control_out : out std_logic_vector(1 downto 0);
      reg_src_out, ula_src_out, mem_write_out, mem_to_reg_out, reg_write_out, branch_e_out, branch_ne_out, jump_out : out std_logic;
      pc_out : out std_logic_vector(7 downto 0);
      a_out, b_out, imm_ext_out : out std_logic_vector(15 downto 0);
      rs_out, rt_out, rd_out : out std_logic_vector(3 downto 0)
     );
    end component;
    
    component EX_MEM is
     port(
      clock, reset : in std_logic;
      mem_write, mem_to_reg, reg_write, branch_e, branch_ne, jump : in std_logic;
      ula_out, b : in std_logic_vector(15 downto 0);
      rt, rd : in std_logic_vector(3 downto 0);
      
      mem_write_out, mem_to_reg_out, reg_write_out, branch_e_out, branch_ne_out, jump_out : out std_logic;
      ula_out_out, b_out : out std_logic_vector(15 downto 0);
      rt_out, rd_out : out std_logic_vector(3 downto 0)
     );
    end component;
    
    component MEM_WB is
     port(
      clock, reset : in std_logic;
      mem_to_reg, reg_write : in std_logic;
      mem_out, ula_out : in std_logic_vector(15 downto 0);
      rd : in std_logic_vector(3 downto 0);
      
      mem_to_reg_out, reg_write_out : out std_logic;
      mem_out_out, ula_out_out : out std_logic_vector(15 downto 0);
      rd_out : out std_logic_vector(3 downto 0)
     );
    end component;
    
    -- HAZARDS

	component BranchFlushUnit is
     port(
        id_ex_branch_eq : in std_logic;
        id_ex_branch_ne : in std_logic;
        id_ex_jump      : in std_logic;
        ula_zero        : in std_logic;
        if_id_flush     : out std_logic;
        id_ex_flush     : out std_logic
     );
	end component;

	component PCLogic is
     port(
		pc_plus_one     : in std_logic_vector(7 downto 0);
        branch_target : in std_logic_vector(7 downto 0);
        jump_target   : in std_logic_vector(7 downto 0);
        branch_taken  : in std_logic;
        jump_taken    : in std_logic;
        pc_next       : out std_logic_vector(7 downto 0)
     );
	end component;
    
    component ForwardingUnit is
     port(
      id_ex_rs      : in std_logic_vector(3 downto 0);
      id_ex_rt      : in std_logic_vector(3 downto 0);
      id_ex_ula_src : in std_logic;
      ex_mem_reg_write : in std_logic;
      ex_mem_rd     : in std_logic_vector(3 downto 0);
      mem_wb_reg_write : in std_logic;
      mem_wb_rd     : in std_logic_vector(3 downto 0);
      forward_a     : out std_logic_vector(1 downto 0);
      forward_b     : out std_logic_vector(1 downto 0)
     );
	end component;

	component ForwardingMux is
     port(
      forward_sel : in std_logic_vector(1 downto 0);
      data_id_ex  : in std_logic_vector(15 downto 0);
      data_ex_mem : in std_logic_vector(15 downto 0);
      data_mem_wb : in std_logic_vector(15 downto 0);
      data_out    : out std_logic_vector(15 downto 0)
     );
	end component;


    -- =================================================================================
    -- 2. DECLARAÇÃO DOS SINAIS DE PIPELINE, DADOS E CONTROLE
    -- =================================================================================
    
    -- PC/IF
    signal s_pc_atual      : std_logic_vector(7 downto 0);
    signal s_pc_mais_1     : std_logic_vector(7 downto 0);
    signal s_pc_next       : std_logic_vector(7 downto 0);
    signal s_instruction_fetch : std_logic_vector(15 downto 0);     
    
    -- Controles (ID)
    signal s_ula_control : std_logic_vector(1 downto 0);
    signal s_reg_src, s_ula_src, s_mem_write, s_mem_to_reg, s_reg_write, s_branch_e, s_branch_ne, s_jump : std_logic;
    
    -- Dados (ID)
    signal s_imediato_ext  : std_logic_vector(15 downto 0);
    signal s_data_reg_a    : std_logic_vector(15 downto 0);
    signal s_data_reg_b    : std_logic_vector(15 downto 0); 
    
    -- REGISTRADOR IF/ID
    signal s_pc_ifid      : std_logic_vector(7 downto 0);
    signal s_inst_ifid    : std_logic_vector(15 downto 0);
    
    -- REGISTRADOR ID/EX
    signal s_ula_control_idex : std_logic_vector(1 downto 0);
    signal s_reg_src_idex, s_ula_src_idex, s_mem_write_idex, s_mem_to_reg_idex, s_reg_write_idex, s_branch_e_idex, s_branch_ne_idex, s_jump_idex : std_logic;
    signal s_pc_idex : std_logic_vector(7 downto 0);
    signal s_a_idex, s_b_idex, s_imm_ext_idex : std_logic_vector(15 downto 0);
    signal s_rs_idex, s_rt_idex, s_rd_idex : std_logic_vector(3 downto 0); 
    
    -- EX/ULA
    signal s_ula_entry_a, s_ula_entry_b : std_logic_vector(15 downto 0); 
    signal s_ula_result    : std_logic_vector(15 downto 0); 
    signal s_ula_zero      : std_logic;
    
    -- REGISTRADOR EX/MEM
    signal s_mem_write_exmem, s_mem_to_reg_exmem, s_reg_write_exmem, s_branch_e_exmem, s_branch_ne_exmem, s_jump_exmem : std_logic;
    signal s_ula_out_exmem, s_data_for_mem_exmem : std_logic_vector(15 downto 0);
    signal s_rt_exmem, s_rd_exmem : std_logic_vector(3 downto 0); 
    
    -- MEM/WB
    signal s_mem_data_read : std_logic_vector(15 downto 0);
    
    -- REGISTRADOR MEM/WB
    signal s_mem_to_reg_memwb, s_reg_write_memwb : std_logic;
    signal s_mem_out_memwb, s_ula_out_memwb : std_logic_vector(15 downto 0);
    signal s_rd_memwb : std_logic_vector(3 downto 0);
    
    -- WB
    signal s_data_to_write : std_logic_vector(15 downto 0);
    signal s_dest_addr     : std_logic_vector(3 downto 0);

    -- HAZARDS
    signal s_id_ex_flush, s_if_id_flush, s_branch_taken : std_logic;
	signal s_jump_target, s_branch_target : std_logic_vector(7 downto 0);
    
    signal s_forward_a, s_forward_b : std_logic_vector(1 downto 0);
    signal s_ula_entry_b_final      : std_logic_vector(15 downto 0);
    signal s_forward_data_mem : std_logic_vector(1 downto 0);
	signal s_data_for_mem_forwarded : std_logic_vector(15 downto 0);

begin

	pc_out <= s_pc_atual;   

    -- =================================================================================
    -- 3. INSTANCIAÇÕES E CONEXÕES DOS ESTÁGIOS
    -- =================================================================================

    -- ESTÁGIO 1: IF (Instruction Fetch)

    inst_pc: pc
        port map(
            clock    => clock, 
            reset    => reset,
            pc_next  => s_pc_next,
            pc_out   => s_pc_atual
        );
        
    s_pc_mais_1 <= s_pc_atual + 1;
        
    inst_InstMem: InstMem
        port map(
            adress      => s_pc_atual,
            instMem_out => s_instruction_fetch
        );

    -- REGISTRADOR IF/ID
    inst_IF_ID: IF_ID
        port map(
            clock    => clock,
            reset    => reset or s_if_id_flush,
            pc       => s_pc_mais_1,
            inst     => s_instruction_fetch,
            pc_out   => s_pc_ifid,
            inst_out => s_inst_ifid
        );

    -- ESTÁGIO 2: ID (Instruction Decode)

    inst_ControlUnit: ControlUnit
        port map(
            op_code     => s_inst_ifid(15 downto 12),
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
            rs      => s_inst_ifid(7 downto 4),
            rd      => s_inst_ifid(3 downto 0),
            mux_out => s_dest_addr
        );

    inst_RegBank: RegBank
        port map(
            clock     => clock,
            reset     => reset,
            reg_write => s_reg_write_memwb,
            reg_a     => s_inst_ifid(11 downto 8),
            reg_b     => s_inst_ifid(7 downto 4),
            reg_dest  => s_rd_memwb,
            data      => s_data_to_write,
            a_out     => s_data_reg_a,
            b_out     => s_data_reg_b
        );
        
    s_imediato_ext <= x"000" & s_inst_ifid(3 downto 0); 
        
    -- REGISTRADOR ID/EX
    inst_ID_EX: ID_EX
        port map(
            clock => clock,
            reset => reset, 
            
            -- Controles (entrada)
            ula_control => s_ula_control,
            reg_src    => s_reg_src,
            ula_src    => s_ula_src,
            mem_write  => s_mem_write,
            mem_to_reg => s_mem_to_reg, 
            reg_write  => s_reg_write,
            branch_e => s_branch_e,
            branch_ne  => s_branch_ne,
            jump       => s_jump,
            
            -- Dados (entrada)
            a          => s_data_reg_a,
            b          => s_data_reg_b,
            pc         => s_pc_ifid,
            imm_ext    => s_imediato_ext,
            rt         => s_inst_ifid(11 downto 8),
            rs         => s_inst_ifid(7 downto 4),
            rd         => s_dest_addr,
            
            -- Saídas (para EX)
            ula_control_out => s_ula_control_idex,
            reg_src_out    => s_reg_src_idex,
            ula_src_out    => s_ula_src_idex,
            mem_write_out  => s_mem_write_idex, 
            mem_to_reg_out => s_mem_to_reg_idex,
            reg_write_out  => s_reg_write_idex,
            branch_e_out   => s_branch_e_idex, 
            branch_ne_out  => s_branch_ne_idex,
            jump_out       => s_jump_idex,
            a_out          => s_a_idex, 
            b_out          => s_b_idex,
            pc_out         => s_pc_idex,
            imm_ext_out => s_imm_ext_idex,
            rs_out         => s_rs_idex, 
            rt_out         => s_rt_idex,
            rd_out         => s_rd_idex
        );

    -- ESTÁGIO 3: EX (Execute)

    inst_MuxULASrc: MuxULASrc
        port map(
            ula_src => s_ula_src_idex,
            rs      => s_b_idex,   
            imm     => s_imm_ext_idex, 
            mux_out => s_ula_entry_b
        );
        
    inst_ForwardingUnit: ForwardingUnit
		port map(
         id_ex_rs      => s_rs_idex,
         id_ex_rt      => s_rt_idex,
         id_ex_ula_src => s_ula_src_idex,
           
         ex_mem_reg_write => s_reg_write_exmem,
         ex_mem_rd     => s_rd_exmem,
            
         mem_wb_reg_write => s_reg_write_memwb,
         mem_wb_rd     => s_rd_memwb,
            
         forward_a     => s_forward_a,
         forward_b     => s_forward_b
        );
    
    inst_ForwardingMux_A: ForwardingMux
        port map(
            forward_sel => s_forward_a,
            data_id_ex  => s_a_idex,           
            data_ex_mem => s_ula_out_exmem,    
            data_mem_wb => s_data_to_write,    
            data_out    => s_ula_entry_a       
        );
     
    inst_ForwardingMux_B: ForwardingMux
		port map(
         forward_sel => s_forward_b,
         data_id_ex  => s_ula_entry_b,      
         data_ex_mem => s_ula_out_exmem,    
         data_mem_wb => s_data_to_write,    
         data_out    => s_ula_entry_b_final 
        );
        
    inst_ULA: ULA
        port map(
            entry_a     => s_ula_entry_a,
            entry_b     => s_ula_entry_b_final,
            ula_control => s_ula_control_idex,
            ula_out     => s_ula_result,
            zero_ula    => s_ula_zero
        );
        
    inst_BranchFlushUnit: BranchFlushUnit
        port map(
            id_ex_branch_eq => s_branch_e_idex,
            id_ex_branch_ne => s_branch_ne_idex,
            id_ex_jump      => s_jump_idex,
            ula_zero        => s_ula_zero,
            if_id_flush     => s_if_id_flush,
            id_ex_flush     => s_id_ex_flush
        );
        
    -- Sinais auxiliares para PCLogic
    s_branch_taken <= '1' when ((s_branch_e_idex = '1' and s_ula_zero = '1') or
                               (s_branch_ne_idex = '1' and s_ula_zero = '0')) else '0';
    
    s_branch_target <= s_pc_idex + s_imm_ext_idex(7 downto 0);
    
    s_jump_target <= s_imm_ext_idex(7 downto 0);
                                      
    inst_PCLogic: PCLogic
        port map(
			pc_plus_one   => s_pc_mais_1,
            branch_target => s_branch_target,
            jump_target   => s_jump_target,
            branch_taken  => s_branch_taken,
            jump_taken    => s_jump_idex,
            pc_next       => s_pc_next
        );
        
    -- REGISTRADOR EX/MEM
    inst_EX_MEM: EX_MEM
        port map(
            clock      => clock,
            reset      => reset,
            -- Controles (entrada)
            mem_write  => s_mem_write_idex,
            mem_to_reg => s_mem_to_reg_idex,
            reg_write  => s_reg_write_idex, 
            branch_e   => s_branch_e_idex,
            branch_ne  => s_branch_ne_idex,
            jump       => s_jump_idex,
            -- Dados (entrada)
            ula_out    => s_ula_result,
            b          => s_b_idex,
	        rt		   => s_rt_idex,
            rd         => s_rd_idex,
            -- Saídas (para MEM)
            mem_write_out  => s_mem_write_exmem,
            mem_to_reg_out => s_mem_to_reg_exmem,
            reg_write_out  => s_reg_write_exmem, 
            branch_e_out   => s_branch_e_exmem,
            branch_ne_out  => s_branch_ne_exmem,
            jump_out       => s_jump_exmem,
            ula_out_out    => s_ula_out_exmem,
            b_out          => s_data_for_mem_exmem,
            rt_out	   => s_rt_exmem,
            rd_out         => s_rd_exmem
        );

    -- ESTÁGIO 4: MEM (Memory)
    
    s_forward_data_mem <= "01" when (s_reg_write_exmem = '1' and s_rd_exmem /= "0000" and s_rd_exmem = s_rt_exmem) else -- Prioridade 1: EX/MEM -> MEM
                      "10" when (s_reg_write_memwb = '1' and s_rd_memwb /= "0000" and s_rd_memwb = s_rt_exmem) else -- Prioridade 2: MEM/WB -> MEM
                      "00";
    
    with s_forward_data_mem select
    s_data_for_mem_forwarded <= s_data_for_mem_exmem when "00",     -- 00: Valor original de EX/MEM
                                s_ula_out_exmem when "01",          -- 01: EX/MEM (Resultado ULA - WriteBack mais rápido)
                                s_data_to_write when "10",    -- 10: MEM/WB (Resultado Final)
                                (others => '0') when others;

    inst_DataMem: DataMem
        port map(
            clock       => clock,
            mem_write   => s_mem_write_exmem,
            adress      => s_ula_out_exmem,
            data        => s_data_for_mem_forwarded,
            dataMem_out => s_mem_data_read
        );
        
    -- REGISTRADOR MEM/WB
    inst_MEM_WB: MEM_WB
        port map(
            clock      => clock,
            reset      => reset,
            -- Controles (entrada)
            mem_to_reg => s_mem_to_reg_exmem,
            reg_write  => s_reg_write_exmem,
            -- Dados (entrada)
            mem_out    => s_mem_data_read,
            ula_out    => s_ula_out_exmem,
            rd         => s_rd_exmem,
            -- Saídas (para WB)
            mem_to_reg_out => s_mem_to_reg_memwb,
            reg_write_out  => s_reg_write_memwb,
            mem_out_out    => s_mem_out_memwb,
            ula_out_out    => s_ula_out_memwb,
            rd_out         => s_rd_memwb
        );

    -- ESTÁGIO 5: WB (Write Back)

    inst_MuxMemReg: MuxMemReg
        port map(
            mem_to_reg => s_mem_to_reg_memwb,
            ula_out    => s_ula_out_memwb,
            data       => s_mem_out_memwb,
            mux_out    => s_data_to_write
        );
          
     
end architecture;
