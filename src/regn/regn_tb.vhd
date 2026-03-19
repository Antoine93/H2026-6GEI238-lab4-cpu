-- =============================================================================
-- fichier     : regn_tb.vhd
-- description : testbench pour regn
-- =============================================================================

library ieee;
use ieee.std_logic_1164.all;

entity regn_tb is
end entity regn_tb;

architecture test of regn_tb is

    -- constantes
    constant CLK_PERIOD : time := 20 ns;
    constant N_BITS     : integer := 9;

    -- signaux de test
    signal d      : std_logic_vector(N_BITS-1 downto 0) := (others => '0');
    signal load   : std_logic := '0';
    signal clk    : std_logic := '0';
    signal resetn : std_logic := '0';
    signal q      : std_logic_vector(N_BITS-1 downto 0);

    -- flag de fin de simulation
    signal sim_done : boolean := false;

begin

    -- instanciation du composant à tester
    uut: entity work.regn
        generic map (n => N_BITS)
        port map (
            d      => d,
            load   => load,
            clk    => clk,
            resetn => resetn,
            q      => q
        );

    -- génération de l'horloge
    clk_process: process
    begin
        while not sim_done loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    -- processus de test
    stim_process: process
    begin
        -- test 1 : reset
        resetn <= '0';
        wait for CLK_PERIOD * 2;
        assert q = "000000000"
            report "ERREUR: reset ne fonctionne pas" severity error;

        -- test 2 : sortir du reset, load = 0 (pas de chargement)
        resetn <= '1';
        d <= "000000101";  -- 5
        load <= '0';
        wait for CLK_PERIOD * 2;
        assert q = "000000000"
            report "ERREUR: chargement sans load=1" severity error;

        -- test 3 : load = 1 (chargement de 5)
        load <= '1';
        wait for CLK_PERIOD;
        load <= '0';
        wait for CLK_PERIOD;
        assert q = "000000101"
            report "ERREUR: valeur 5 non chargée" severity error;

        -- test 4 : changer d sans load (q doit rester à 5)
        d <= "111111111";  -- 511
        wait for CLK_PERIOD * 2;
        assert q = "000000101"
            report "ERREUR: q a changé sans load" severity error;

        -- test 5 : charger nouvelle valeur
        load <= '1';
        wait for CLK_PERIOD;
        load <= '0';
        wait for CLK_PERIOD;
        assert q = "111111111"
            report "ERREUR: valeur 511 non chargée" severity error;

        -- test 6 : reset asynchrone
        resetn <= '0';
        wait for 5 ns;  -- pas besoin d'attendre le clock
        assert q = "000000000"
            report "ERREUR: reset asynchrone ne fonctionne pas" severity error;

        -- fin
        report "=== TOUS LES TESTS PASSES ===" severity note;
        sim_done <= true;
        wait;
    end process;

end architecture test;
