library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ForwardingMux is
    port(
        forward_sel : in std_logic_vector(1 downto 0);
        
        data_id_ex   : in std_logic_vector(15 downto 0);
        data_ex_mem  : in std_logic_vector(15 downto 0);
        data_mem_wb  : in std_logic_vector(15 downto 0);

        data_out     : out std_logic_vector(15 downto 0)
    );
end entity;

architecture behavior of ForwardingMux is
begin
    
    with forward_sel select
        data_out <= data_id_ex   when "00",   -- Sem forwarding
                    data_ex_mem  when "01",   -- Forward do EX/MEM
                    data_mem_wb  when "10",   -- Forward do MEM/WB
                    data_id_ex   when others; -- Fallback
    
end architecture;
