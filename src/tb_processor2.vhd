library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity tb_processor2 is
end entity;

architecture behavior of tb_processor2 is

    component top_SinglecycleProcessor is
        port(
            clock       : in std_logic;
            reset       : in std_logic;
            debug_reg_a : out std_logic_vector(15 downto 0);
            debug_reg_b : out std_logic_vector(15 downto 0);
            debug_pc    : out std_logic_vector(7 downto 0)
        );
    end component;

    signal clock_sg : std_logic:= '0';
    signal reset_sg : std_logic:= '1';

    signal reg_a_sg : std_logic_vector(15 downto 0);
    signal reg_b_sg : std_logic_vector(15 downto 0);
    signal pc_sg    : std_logic_vector(7 downto 0);
        
begin
                      
    mymicroprocessador_0: top_SinglecycleProcessor
        port map (
            clock       => clock_sg,
            reset       => reset_sg,
            debug_reg_a => reg_a_sg,
            debug_reg_b => reg_b_sg,
            debug_pc    => pc_sg
        );
                      
    -- (Período = 10 ps)
    clock_sg <= not clock_sg after 5 ps;

    process
    begin
        wait for 5 ps; -- 1 ciclo completo
          reset_sg <= '0';
        
        wait;
    end process;

end architecture behavior;