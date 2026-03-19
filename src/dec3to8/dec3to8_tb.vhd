-- =============================================================================
-- fichier     : dec3to8_tb.vhd
-- description : testbench pour dec3to8
-- =============================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dec3to8_tb is
end entity dec3to8_tb;

architecture test of dec3to8_tb is

    -- signaux de test
    signal w  : std_logic_vector(2 downto 0) := "000";
    signal en : std_logic := '0';
    signal y  : std_logic_vector(7 downto 0);

    -- fonction helper pour vérifier one-hot
    function expected_output(input : std_logic_vector(2 downto 0))
        return std_logic_vector is
        variable result : std_logic_vector(7 downto 0) := "00000000";
    begin
        result(to_integer(unsigned(input))) := '1';
        return result;
    end function;

begin

    -- instanciation du composant à tester
    uut: entity work.dec3to8
        port map (
            w  => w,
            en => en,
            y  => y
        );

    -- processus de test
    stim_process: process
    begin
        -- test 1 : enable = 0 (toutes les entrées doivent donner 0)
        en <= '0';
        for i in 0 to 7 loop
            w <= std_logic_vector(to_unsigned(i, 3));
            wait for 10 ns;
            assert y = "00000000"
                report "ERREUR: en=0 devrait donner y=00000000"
                severity error;
        end loop;

        -- test 2 : enable = 1 (tester toutes les combinaisons)
        en <= '1';
        wait for 10 ns;

        -- w = 000 -> y = 00000001
        w <= "000";
        wait for 10 ns;
        assert y = "00000001"
            report "ERREUR: w=000 devrait donner y=00000001"
            severity error;

        -- w = 001 -> y = 00000010
        w <= "001";
        wait for 10 ns;
        assert y = "00000010"
            report "ERREUR: w=001 devrait donner y=00000010"
            severity error;

        -- w = 010 -> y = 00000100
        w <= "010";
        wait for 10 ns;
        assert y = "00000100"
            report "ERREUR: w=010 devrait donner y=00000100"
            severity error;

        -- w = 011 -> y = 00001000
        w <= "011";
        wait for 10 ns;
        assert y = "00001000"
            report "ERREUR: w=011 devrait donner y=00001000"
            severity error;

        -- w = 100 -> y = 00010000
        w <= "100";
        wait for 10 ns;
        assert y = "00010000"
            report "ERREUR: w=100 devrait donner y=00010000"
            severity error;

        -- w = 101 -> y = 00100000
        w <= "101";
        wait for 10 ns;
        assert y = "00100000"
            report "ERREUR: w=101 devrait donner y=00100000"
            severity error;

        -- w = 110 -> y = 01000000
        w <= "110";
        wait for 10 ns;
        assert y = "01000000"
            report "ERREUR: w=110 devrait donner y=01000000"
            severity error;

        -- w = 111 -> y = 10000000
        w <= "111";
        wait for 10 ns;
        assert y = "10000000"
            report "ERREUR: w=111 devrait donner y=10000000"
            severity error;

        -- test 3 : désactiver enable en cours de route
        en <= '0';
        wait for 10 ns;
        assert y = "00000000"
            report "ERREUR: en=0 devrait réinitialiser y"
            severity error;

        -- fin
        report "=== TOUS LES TESTS PASSES ===" severity note;
        wait;
    end process;

end architecture test;
