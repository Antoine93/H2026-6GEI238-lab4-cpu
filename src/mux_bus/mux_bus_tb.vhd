-- =============================================================================
-- fichier     : mux_bus_tb.vhd
-- description : testbench pour mux_bus
-- =============================================================================

library ieee;
use ieee.std_logic_1164.all;

entity mux_bus_tb is
end entity mux_bus_tb;

architecture test of mux_bus_tb is

    -- registres (valeurs distinctes pour identifier la source)
    signal r0, r1, r2, r3 : std_logic_vector(8 downto 0);
    signal r4, r5, r6, r7 : std_logic_vector(8 downto 0);
    signal g              : std_logic_vector(8 downto 0);
    signal din            : std_logic_vector(8 downto 0);

    -- signaux de sélection
    signal r_out   : std_logic_vector(7 downto 0) := "00000000";
    signal g_out   : std_logic := '0';
    signal din_out : std_logic := '0';

    -- sortie
    signal bus_out : std_logic_vector(8 downto 0);

begin

    uut: entity work.mux_bus
        port map (
            r0 => r0, r1 => r1, r2 => r2, r3 => r3,
            r4 => r4, r5 => r5, r6 => r6, r7 => r7,
            g => g, din => din,
            r_out => r_out, g_out => g_out, din_out => din_out,
            bus_out => bus_out
        );

    stim_process: process
    begin
        -- initialiser avec des valeurs distinctes
        r0  <= "000000000";  -- 0
        r1  <= "000000001";  -- 1
        r2  <= "000000010";  -- 2
        r3  <= "000000011";  -- 3
        r4  <= "000000100";  -- 4
        r5  <= "000000101";  -- 5
        r6  <= "000000110";  -- 6
        r7  <= "000000111";  -- 7
        g   <= "100000000";  -- 256 (G)
        din <= "111111111";  -- 511 (DIN)

        -- test : aucune sélection
        r_out <= "00000000"; g_out <= '0'; din_out <= '0';
        wait for 10 ns;
        assert bus_out = "000000000"
            report "ERREUR: aucune sélection devrait donner 0" severity error;

        -- test : R0
        r_out <= "00000001";
        wait for 10 ns;
        assert bus_out = "000000000"
            report "ERREUR: R0 != 0" severity error;

        -- test : R1
        r_out <= "00000010";
        wait for 10 ns;
        assert bus_out = "000000001"
            report "ERREUR: R1 != 1" severity error;

        -- test : R2
        r_out <= "00000100";
        wait for 10 ns;
        assert bus_out = "000000010"
            report "ERREUR: R2 != 2" severity error;

        -- test : R3
        r_out <= "00001000";
        wait for 10 ns;
        assert bus_out = "000000011"
            report "ERREUR: R3 != 3" severity error;

        -- test : R4
        r_out <= "00010000";
        wait for 10 ns;
        assert bus_out = "000000100"
            report "ERREUR: R4 != 4" severity error;

        -- test : R5
        r_out <= "00100000";
        wait for 10 ns;
        assert bus_out = "000000101"
            report "ERREUR: R5 != 5" severity error;

        -- test : R6
        r_out <= "01000000";
        wait for 10 ns;
        assert bus_out = "000000110"
            report "ERREUR: R6 != 6" severity error;

        -- test : R7
        r_out <= "10000000";
        wait for 10 ns;
        assert bus_out = "000000111"
            report "ERREUR: R7 != 7" severity error;

        -- test : G
        r_out <= "00000000"; g_out <= '1';
        wait for 10 ns;
        assert bus_out = "100000000"
            report "ERREUR: G != 256" severity error;

        -- test : DIN
        g_out <= '0'; din_out <= '1';
        wait for 10 ns;
        assert bus_out = "111111111"
            report "ERREUR: DIN != 511" severity error;

        -- test : priorité (R0 > G si les deux actifs)
        r_out <= "00000001"; g_out <= '1'; din_out <= '0';
        wait for 10 ns;
        assert bus_out = "000000000"
            report "ERREUR: priorité R0 > G" severity error;

        -- fin
        report "=== TOUS LES TESTS PASSES ===" severity note;
        wait;
    end process;

end architecture test;
