-- =============================================================================
-- fichier     : alu_tb.vhd
-- description : testbench pour alu
-- =============================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_tb is
end entity alu_tb;

architecture test of alu_tb is

    signal a      : std_logic_vector(8 downto 0) := (others => '0');
    signal b      : std_logic_vector(8 downto 0) := (others => '0');
    signal sub    : std_logic := '0';
    signal result : std_logic_vector(8 downto 0);

begin

    uut: entity work.alu
        port map (
            a      => a,
            b      => b,
            sub    => sub,
            result => result
        );

    stim_process: process
    begin
        -- =====================================================================
        -- TESTS ADDITION (sub = '0')
        -- =====================================================================
        sub <= '0';

        -- test 1 : 0 + 0 = 0
        a <= "000000000";  -- 0
        b <= "000000000";  -- 0
        wait for 10 ns;
        assert result = "000000000"
            report "ERREUR: 0 + 0 != 0" severity error;

        -- test 2 : 5 + 3 = 8
        a <= "000000101";  -- 5
        b <= "000000011";  -- 3
        wait for 10 ns;
        assert result = "000001000"
            report "ERREUR: 5 + 3 != 8" severity error;

        -- test 3 : 100 + 50 = 150
        a <= "001100100";  -- 100
        b <= "000110010";  -- 50
        wait for 10 ns;
        assert result = "010010110"
            report "ERREUR: 100 + 50 != 150" severity error;

        -- test 4 : 255 + 1 = 256
        a <= "011111111";  -- 255
        b <= "000000001";  -- 1
        wait for 10 ns;
        assert result = "100000000"
            report "ERREUR: 255 + 1 != 256" severity error;

        -- test 5 : valeurs max (overflow attendu, wrapping)
        a <= "111111111";  -- 511
        b <= "000000001";  -- 1
        wait for 10 ns;
        assert result = "000000000"
            report "ERREUR: 511 + 1 != 0 (overflow)" severity error;

        -- =====================================================================
        -- TESTS SOUSTRACTION (sub = '1')
        -- =====================================================================
        sub <= '1';

        -- test 6 : 10 - 3 = 7
        a <= "000001010";  -- 10
        b <= "000000011";  -- 3
        wait for 10 ns;
        assert result = "000000111"
            report "ERREUR: 10 - 3 != 7" severity error;

        -- test 7 : 100 - 50 = 50
        a <= "001100100";  -- 100
        b <= "000110010";  -- 50
        wait for 10 ns;
        assert result = "000110010"
            report "ERREUR: 100 - 50 != 50" severity error;

        -- test 8 : 5 - 5 = 0
        a <= "000000101";  -- 5
        b <= "000000101";  -- 5
        wait for 10 ns;
        assert result = "000000000"
            report "ERREUR: 5 - 5 != 0" severity error;

        -- test 9 : 0 - 1 = 511 (underflow, wrapping)
        a <= "000000000";  -- 0
        b <= "000000001";  -- 1
        wait for 10 ns;
        assert result = "111111111"
            report "ERREUR: 0 - 1 != 511 (underflow)" severity error;

        -- test 10 : 256 - 128 = 128
        a <= "100000000";  -- 256
        b <= "010000000";  -- 128
        wait for 10 ns;
        assert result = "010000000"
            report "ERREUR: 256 - 128 != 128" severity error;

        -- =====================================================================
        -- TEST CHANGEMENT DYNAMIQUE DE sub
        -- =====================================================================

        -- test 11 : même opérandes, changer sub
        a <= "000001010";  -- 10
        b <= "000000011";  -- 3

        sub <= '0';
        wait for 10 ns;
        assert result = "000001101"
            report "ERREUR: 10 + 3 != 13" severity error;

        sub <= '1';
        wait for 10 ns;
        assert result = "000000111"
            report "ERREUR: 10 - 3 != 7" severity error;

        -- fin
        report "=== TOUS LES TESTS PASSES ===" severity note;
        wait;
    end process;

end architecture test;
