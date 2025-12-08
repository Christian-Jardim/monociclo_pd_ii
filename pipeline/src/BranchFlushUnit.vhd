library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BranchFlushUnit is
    port(
        id_ex_branch_eq  : in std_logic; 
        id_ex_branch_ne  : in std_logic; 
        id_ex_jump       : in std_logic;
        
        ula_zero         : in std_logic; 
        
        if_id_flush      : out std_logic;
        id_ex_flush      : out std_logic
    );
end entity;

architecture behavior of BranchFlushUnit is
    signal branch_taken : std_logic;
begin
    
    branch_taken <= '1' when ((id_ex_branch_eq = '1' and ula_zero = '1') or
                              (id_ex_branch_ne = '1' and ula_zero = '0')) else '0';
    
    process(branch_taken, id_ex_jump)
    begin
        if (branch_taken = '1' or id_ex_jump = '1') then
            
            if_id_flush <= '1';  
            id_ex_flush <= '1'; 
        else
            if_id_flush <= '0';
            id_ex_flush <= '0';
        end if;
    end process;
    
end architecture;
