library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PCLogic is
    port(
        pc_plus_one     : in std_logic_vector(7 downto 0);
        branch_target   : in std_logic_vector(7 downto 0);
        jump_target     : in std_logic_vector(7 downto 0);
        
        branch_taken    : in std_logic;
        jump_taken      : in std_logic;
        
        pc_next         : out std_logic_vector(7 downto 0)
    );
end entity;

architecture behavior of PCLogic is

	signal s_pc_next : std_logic_vector(7 downto 0);

begin
    
    process(pc_plus_one, branch_target, jump_target, branch_taken, jump_taken)
    begin
        if jump_taken = '1' then
            s_pc_next <= jump_target;
        elsif branch_taken = '1' then
            s_pc_next <= branch_target;
        else
            s_pc_next <= pc_plus_one;
        end if;
    end process;
    
    pc_next <= s_pc_next;
    
end architecture;
