-- =============================================================================
-- fichier     : regn.vhd
-- description : registre générique de n bits avec chargement synchrone
-- auteur      : Antoine Larouche Tremblay
-- date        : 2026-03-18
-- =============================================================================

library ieee;
use ieee.std_logic_1164.all;

entity regn is
    generic (
        n : integer := 9
    );
    port (
        d      : in  std_logic_vector(n-1 downto 0);
        load   : in  std_logic;
        clk    : in  std_logic;
        resetn : in  std_logic;
        q      : out std_logic_vector(n-1 downto 0)
    );
end entity regn;

architecture behavior of regn is
begin
    process(clk, resetn)
    begin
        if resetn = '0' then
            q <= (others => '0');
        elsif rising_edge(clk) then
            if load = '1' then
                q <= d;
            end if;
        end if;
    end process;
end architecture behavior;
