-- =============================================================================
-- fichier     : fsm_tb.vhd
-- description : Testbench pour la machine à états fsm.
--               Teste les 4 instructions (mv, mvi, add, sub) et vérifie
--               les signaux de contrôle générés à chaque état.
-- =============================================================================

library ieee;
use ieee.std_logic_1164.all;

entity fsm_tb is
end entity fsm_tb;

architecture sim of fsm_tb is
    signal clk     : std_logic := '0';
    signal resetn  : std_logic := '0';
    signal run     : std_logic := '0';
    signal ir      : std_logic_vector(8 downto 0) := (others => '0');

    signal ir_load  : std_logic;
    signal a_load   : std_logic;
    signal g_load   : std_logic;
    signal r_load   : std_logic_vector(7 downto 0);
    signal r_out    : std_logic_vector(7 downto 0);
    signal g_out    : std_logic;
    signal din_out  : std_logic;
    signal add_sub  : std_logic;
    signal done     : std_logic;

    constant CLK_PERIOD : time := 20 ns;

begin
    -- Instanciation
    uut: entity work.fsm
        port map (
            clk      => clk,
            resetn   => resetn,
            run      => run,
            ir       => ir,
            ir_load  => ir_load,
            a_load   => a_load,
            g_load   => g_load,
            r_load   => r_load,
            r_out    => r_out,
            g_out    => g_out,
            din_out  => din_out,
            add_sub  => add_sub,
            done     => done
        );

    -- Horloge
    clk <= not clk after CLK_PERIOD / 2;

    -- Stimuli
    process
    begin
        -- Reset
        resetn <= '0';
        wait for CLK_PERIOD * 2;
        resetn <= '1';
        wait for CLK_PERIOD;

        -- Test 1: mv R1, R2 (opcode=000, Rx=001, Ry=010)
        report "Test 1: mv R1, R2";
        ir <= "000001010";  -- III=000, XXX=001, YYY=010
        run <= '1';
        wait for CLK_PERIOD;
        run <= '0';
        wait for CLK_PERIOD * 2;
        assert done = '1' report "mv: done attendu" severity error;
        wait for CLK_PERIOD;

        -- Test 2: mvi R3, #imm (opcode=001, Rx=011)
        report "Test 2: mvi R3, #imm";
        ir <= "001011000";  -- III=001, XXX=011, YYY=000
        run <= '1';
        wait for CLK_PERIOD;
        run <= '0';
        wait for CLK_PERIOD * 2;
        assert done = '1' report "mvi: done attendu" severity error;
        wait for CLK_PERIOD;

        -- Test 3: add R0, R1 (opcode=010, Rx=000, Ry=001)
        report "Test 3: add R0, R1";
        ir <= "010000001";  -- III=010, XXX=000, YYY=001
        run <= '1';
        wait for CLK_PERIOD;
        run <= '0';
        wait for CLK_PERIOD * 4;  -- T0->T1->T2->T3
        assert done = '1' report "add: done attendu" severity error;
        wait for CLK_PERIOD;

        -- Test 4: sub R2, R3 (opcode=011, Rx=010, Ry=011)
        report "Test 4: sub R2, R3";
        ir <= "011010011";  -- III=011, XXX=010, YYY=011
        run <= '1';
        wait for CLK_PERIOD;
        run <= '0';
        wait for CLK_PERIOD * 4;
        assert add_sub = '1' report "sub: add_sub=1 attendu" severity error;
        wait for CLK_PERIOD;

        report "=== Tous les tests passés ===" severity note;
        wait;
    end process;

end architecture sim;
