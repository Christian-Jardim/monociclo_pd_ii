library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ForwardingUnit is
    port(
     id_ex_rs     : in std_logic_vector(3 downto 0);
     id_ex_rt     : in std_logic_vector(3 downto 0);
     id_ex_ula_src: in std_logic;                   
        
     ex_mem_reg_write : in std_logic;               
     ex_mem_rd        : in std_logic_vector(3 downto 0);
        
     mem_wb_reg_write : in std_logic;                
     mem_wb_rd        : in std_logic_vector(3 downto 0); 
        
     forward_a : out std_logic_vector(1 downto 0);   
     forward_b : out std_logic_vector(1 downto 0)    
    );
end entity;

architecture behavior of ForwardingUnit is
    
    function has_dependency(reg_a, reg_b : std_logic_vector(3 downto 0)) return boolean is
    begin
        return (reg_a = reg_b) and (reg_a /= "0000");
    end function;
    
begin
    
    process(id_ex_rs, ex_mem_reg_write, ex_mem_rd, mem_wb_reg_write, mem_wb_rd)
    begin
       
        if (ex_mem_reg_write = '1' and has_dependency(id_ex_rs, ex_mem_rd)) then
            forward_a <= "01";
        
        elsif (mem_wb_reg_write = '1' and has_dependency(id_ex_rs, mem_wb_rd)) then
            forward_a <= "10";
        else
            forward_a <= "00";
        end if;
    end process;
    
    process(id_ex_rt, id_ex_ula_src, ex_mem_reg_write, ex_mem_rd, mem_wb_reg_write, mem_wb_rd)
    begin
        
        if id_ex_ula_src = '0' then
            if (ex_mem_reg_write = '1' and has_dependency(id_ex_rt, ex_mem_rd)) then
                forward_b <= "01";
            elsif (mem_wb_reg_write = '1' and has_dependency(id_ex_rt, mem_wb_rd)) then
                forward_b <= "10";
            else
                forward_b <= "00";
            end if;
        else
            forward_b <= "00";
        end if;
    end process;
    
end architecture;
