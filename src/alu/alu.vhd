-- =============================================================================
-- fichier     : alu.vhd
-- description : unité arithmétique (addition/soustraction 9 bits)
-- =============================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
    port (
        a      : in  std_logic_vector(8 downto 0);
        b      : in  std_logic_vector(8 downto 0);
        sub    : in  std_logic;
        result : out std_logic_vector(8 downto 0)
    );
end entity alu;

architecture behavior of alu is
begin
    process(a, b, sub)
    begin
        if sub = '0' then
            result <= std_logic_vector(unsigned(a) + unsigned(b));
        else
            result <= std_logic_vector(unsigned(a) - unsigned(b));
        end if;
    end process;
end architecture behavior;
