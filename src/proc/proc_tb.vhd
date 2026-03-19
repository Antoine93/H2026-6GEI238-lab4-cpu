-- =============================================================================
-- fichier     : proc_tb.vhd
-- description : Testbench pour le processeur complet.
--               Exécute une séquence d'instructions et vérifie les résultats.
-- =============================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity proc_tb is
end entity proc_tb;

architecture sim of proc_tb is
    signal clk     : std_logic := '0';
    signal resetn  : std_logic := '0';
    signal run     : std_logic := '0';
    signal din     : std_logic_vector(8 downto 0) := (others => '0');
    signal bus_out : std_logic_vector(8 downto 0);
    signal done    : std_logic;

    constant CLK_PERIOD : time := 20 ns;

    -- Procédure pour exécuter une instruction
    procedure exec_instruction(
        signal p_clk  : in  std_logic;
        signal p_run  : out std_logic;
        signal p_done : in  std_logic
    ) is
    begin
        p_run <= '1';
        wait until rising_edge(p_clk);
        p_run <= '0';
        wait until p_done = '1';
        wait until rising_edge(p_clk);
    end procedure;

    -- flag de fin de simulation
    signal sim_done : boolean := false;

begin
    -- Instanciation du processeur
    uut: entity work.proc
        port map (
            clk     => clk,
            resetn  => resetn,
            run     => run,
            din     => din,
            bus_out => bus_out,
            done    => done
        );

    -- Génération de l'horloge (s'arrête quand sim_done = true)
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

    -- Stimuli
    process
    begin
        -- Reset
        resetn <= '0';
        wait for CLK_PERIOD * 2;
        resetn <= '1';
        wait for CLK_PERIOD;

        -- =====================================================
        -- Test 1: mvi R0, #5  (charger 5 dans R0)
        -- Format: III=001, XXX=000, YYY=000
        -- Note: La donnée doit être sur din AVANT T1 (c'est en T1 que R0 ← DIN)
        -- =====================================================
        report "Test 1: mvi R0, #5";
        din <= "001000000";  -- instruction mvi R0
        run <= '1';
        wait until rising_edge(clk);  -- T0: IR ← instruction
        run <= '0';
        din <= "000000101";  -- donnée = 5 (AVANT T1!)
        wait until done = '1';
        wait until rising_edge(clk);

        -- =====================================================
        -- Test 2: mvi R1, #3  (charger 3 dans R1)
        -- Note: La donnée doit être sur din AVANT T1 (c'est en T1 que R1 ← DIN)
        -- =====================================================
        report "Test 2: mvi R1, #3";
        din <= "001001000";  -- instruction mvi R1
        run <= '1';
        wait until rising_edge(clk);  -- T0: IR ← instruction
        run <= '0';
        din <= "000000011";  -- donnée = 3 (AVANT T1!)
        wait until done = '1';
        wait until rising_edge(clk);

        -- =====================================================
        -- Test 3 : mv R1, R0  (copier R0 dans R1, R1 = 5)
        -- Format : III=000, XXX=001, YYY=000
        -- =====================================================
        report "Test 3: mv R1, R0 (R1 devrait devenir 5)";
        din <= "000001000";  -- mv R1, R0
        exec_instruction(clk, run, done);

        -- =====================================================
        -- Test 4 : add R0, R1  (R0 = R0 + R1 = 5 + 5 = 10)
        -- Format : III=010, XXX=000, YYY=001
        -- =====================================================
        report "Test 4: add R0, R1 (attendu 10 = 0x00A)";
        din <= "010000001";  -- add R0, R1
        exec_instruction(clk, run, done);

        -- =====================================================
        -- Test 5 : sub R0, R0  (R0 = R0 - R0 = 0)
        -- Format : III=011, XXX=000, YYY=000
        -- =====================================================
        report "Test 5: sub R0, R0 (attendu 0)";
        din <= "011000000";  -- sub R0, R0
        exec_instruction(clk, run, done);

        -- =====================================================
        -- Test 6 : Utiliser le registre R5
        -- mvi R5, #25
        -- =====================================================
        report "Test 6: mvi R5, #25";
        din <= "001101000";  -- mvi R5 (III=001, XXX=101)
        run <= '1';
        wait until rising_edge(clk);
        run <= '0';
        din <= "000011001";  -- donnee = 25
        wait until done = '1';
        wait until rising_edge(clk);

        -- =====================================================
        -- Test 7 : Utiliser le registre R7
        -- mvi R7, #50
        -- =====================================================
        report "Test 7: mvi R7, #50";
        din <= "001111000";  -- mvi R7 (III=001, XXX=111)
        run <= '1';
        wait until rising_edge(clk);
        run <= '0';
        din <= "000110010";  -- donnee = 50
        wait until done = '1';
        wait until rising_edge(clk);

        -- =====================================================
        -- Test 8 : mv R6, R7 (copier R7 dans R6)
        -- R6 devrait devenir 50
        -- =====================================================
        report "Test 8: mv R6, R7 (attendu 50)";
        din <= "000110111";  -- mv R6, R7 (III=000, XXX=110, YYY=111)
        exec_instruction(clk, run, done);

        -- =====================================================
        -- Test 9 : add R5, R7 (25 + 50 = 75)
        -- =====================================================
        report "Test 9: add R5, R7 (attendu 75 = 0x04B)";
        din <= "010101111";  -- add R5, R7 (III=010, XXX=101, YYY=111)
        exec_instruction(clk, run, done);

        -- =====================================================
        -- Test 10 : sub R7, R5 (50 - 75 = -25)
        -- Resultat negatif en complement a 2
        -- -25 = 0x1E7 (9 bits) = "111100111"
        -- =====================================================
        report "Test 10: sub R7, R5 (attendu -25 = 0x1E7)";
        din <= "011111101";  -- sub R7, R5 (III=011, XXX=111, YYY=101)
        exec_instruction(clk, run, done);

        -- =====================================================
        -- Test 11 : add R0, R0 (doubler R0)
        -- R0 = 0 apres Test 5, donc 0 + 0 = 0
        -- =====================================================
        report "Test 11: add R0, R0 (attendu 0)";
        din <= "010000000";  -- add R0, R0 (III=010, XXX=000, YYY=000)
        exec_instruction(clk, run, done);

        -- =====================================================
        -- Test 12 : Charger valeur max (255) dans R2
        -- mvi R2, #255
        -- =====================================================
        report "Test 12: mvi R2, #255 (valeur max positive)";
        din <= "001010000";  -- mvi R2 (III=001, XXX=010)
        run <= '1';
        wait until rising_edge(clk);
        run <= '0';
        din <= "011111111";  -- donnee = 255 = 0xFF
        wait until done = '1';
        wait until rising_edge(clk);

        -- =====================================================
        -- Test 13 : mvi R3, #1
        -- =====================================================
        report "Test 13: mvi R3, #1";
        din <= "001011000";  -- mvi R3 (III=001, XXX=011)
        run <= '1';
        wait until rising_edge(clk);
        run <= '0';
        din <= "000000001";  -- donnee = 1
        wait until done = '1';
        wait until rising_edge(clk);

        -- =====================================================
        -- Test 14 : add R2, R3 (255 + 1 = 256)
        -- Test debordement : 256 en 9 bits = 0x100 = "100000000"
        -- =====================================================
        report "Test 14: add R2, R3 (255 + 1 = 256, debordement)";
        din <= "010010011";  -- add R2, R3 (III=010, XXX=010, YYY=011)
        exec_instruction(clk, run, done);

        -- =====================================================
        -- Test 15 : Reinitialisation au milieu d'une operation
        -- Verifier que tout revient a zero
        -- =====================================================
        report "Test 15: Test de reinitialisation (reset)";
        din <= "001000000";  -- mvi R0
        run <= '1';
        wait until rising_edge(clk);
        run <= '0';
        din <= "001111111";  -- donnee = 127
        wait until rising_edge(clk);
        -- Reset avant la fin de l'instruction
        resetn <= '0';
        wait for CLK_PERIOD * 2;
        resetn <= '1';
        wait for CLK_PERIOD;
        report "Reinitialisation terminee - FSM devrait etre en T0";

        report "=== Tous les tests termines ===" severity note;
        wait for CLK_PERIOD * 2;
        sim_done <= true;
        wait;
    end process;

end architecture sim;
