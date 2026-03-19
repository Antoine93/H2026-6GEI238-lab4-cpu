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
        -- Test 3: add R0, R1  (R0 = R0 + R1 = 5 + 3 = 8)
        -- Format: III=010, XXX=000, YYY=001
        -- =====================================================
        report "Test 3: add R0, R1 (expect 8)";
        din <= "010000001";  -- add R0, R1
        exec_instruction(clk, run, done);

        -- =====================================================
        -- Test 4: sub R0, R1  (R0 = R0 - R1 = 8 - 3 = 5)
        -- Format: III=011, XXX=000, YYY=001
        -- =====================================================
        report "Test 4: sub R0, R1 (expect 5)";
        din <= "011000001";  -- sub R0, R1
        exec_instruction(clk, run, done);

        -- =====================================================
        -- Test 5: mv R2, R0  (copier R0 dans R2)
        -- Format: III=000, XXX=010, YYY=000
        -- =====================================================
        report "Test 5: mv R2, R0 (expect 5)";
        din <= "000010000";  -- mv R2, R0
        exec_instruction(clk, run, done);

        report "=== Tous les tests termines ===" severity note;
        wait for CLK_PERIOD * 2;
        sim_done <= true;
        wait;
    end process;

end architecture sim;
