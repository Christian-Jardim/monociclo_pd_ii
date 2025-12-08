library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity HazardDetectionUnit is
    port(
     id_ex_mem_to_reg : in std_logic;                    
     id_ex_rd         : in std_logic_vector(3 downto 0);
        
     if_id_rs         : in std_logic_vector(3 downto 0);
     if_id_rt         : in std_logic_vector(3 downto 0); 
        
     pc_write_en      : out std_logic;                   
     if_id_write_en   : out std_logic;                   
     stall            : out std_logic                    
    );
end entity;

architecture behavior of HazardDetectionUnit is
begin
    
    process(id_ex_mem_to_reg, id_ex_rd, if_id_rs, if_id_rt)
    begin
        
        if (id_ex_mem_to_reg = '1' and id_ex_rd /= "0000" and
            (if_id_rs = id_ex_rd or if_id_rt = id_ex_rd)) then
            stall <= '1';
            pc_write_en <= '0';     
            if_id_write_en <= '0';  
        else
            stall <= '0';
            pc_write_en <= '1';     
            if_id_write_en <= '1';  
        end if;
    end process;
    
end architecture;
