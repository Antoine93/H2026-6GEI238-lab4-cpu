-- =============================================================================
-- fichier     : proc.vhd
-- description : Top-level du processeur simple 9 bits.
--               Instancie et interconnecte tous les composants :
--               8 registres (R0-R7), registres A/G/IR, FSM, ALU et MUX.
-- =============================================================================

library ieee;
use ieee.std_logic_1164.all;

entity proc is
    port (
        clk    : in  std_logic;
        resetn : in  std_logic;
        run    : in  std_logic;
        din    : in  std_logic_vector(8 downto 0);
        bus_out: out std_logic_vector(8 downto 0);
        done   : out std_logic
    );
end entity proc;

architecture structural of proc is

    -- Signaux internes du bus
    signal bus_wires : std_logic_vector(8 downto 0);

    -- Sorties des registres
    signal r0_out, r1_out, r2_out, r3_out : std_logic_vector(8 downto 0);
    signal r4_out, r5_out, r6_out, r7_out : std_logic_vector(8 downto 0);
    signal a_out, g_out_data, ir_out      : std_logic_vector(8 downto 0);

    -- Sortie ALU
    signal alu_result : std_logic_vector(8 downto 0);

    -- Signaux de contrôle (depuis FSM)
    signal ir_load  : std_logic;
    signal a_load   : std_logic;
    signal g_load   : std_logic;
    signal r_load   : std_logic_vector(7 downto 0);
    signal r_out    : std_logic_vector(7 downto 0);
    signal g_out    : std_logic;
    signal din_out  : std_logic;
    signal add_sub  : std_logic;

begin

    -- Registre d'instruction IR
    ir_reg: entity work.regn
        generic map (n => 9)
        port map (
            d      => bus_wires,
            load   => ir_load,
            clk    => clk,
            resetn => resetn,
            q      => ir_out
        );

    -- Registres généraux R0-R7
    r0_reg: entity work.regn
        generic map (n => 9)
        port map (d => bus_wires, load => r_load(0), clk => clk, resetn => resetn, q => r0_out);

    r1_reg: entity work.regn
        generic map (n => 9)
        port map (d => bus_wires, load => r_load(1), clk => clk, resetn => resetn, q => r1_out);

    r2_reg: entity work.regn
        generic map (n => 9)
        port map (d => bus_wires, load => r_load(2), clk => clk, resetn => resetn, q => r2_out);

    r3_reg: entity work.regn
        generic map (n => 9)
        port map (d => bus_wires, load => r_load(3), clk => clk, resetn => resetn, q => r3_out);

    r4_reg: entity work.regn
        generic map (n => 9)
        port map (d => bus_wires, load => r_load(4), clk => clk, resetn => resetn, q => r4_out);

    r5_reg: entity work.regn
        generic map (n => 9)
        port map (d => bus_wires, load => r_load(5), clk => clk, resetn => resetn, q => r5_out);

    r6_reg: entity work.regn
        generic map (n => 9)
        port map (d => bus_wires, load => r_load(6), clk => clk, resetn => resetn, q => r6_out);

    r7_reg: entity work.regn
        generic map (n => 9)
        port map (d => bus_wires, load => r_load(7), clk => clk, resetn => resetn, q => r7_out);

    -- Registre A (opérande gauche ALU)
    a_reg: entity work.regn
        generic map (n => 9)
        port map (
            d      => bus_wires,
            load   => a_load,
            clk    => clk,
            resetn => resetn,
            q      => a_out
        );

    -- Registre G (résultat ALU)
    g_reg: entity work.regn
        generic map (n => 9)
        port map (
            d      => alu_result,
            load   => g_load,
            clk    => clk,
            resetn => resetn,
            q      => g_out_data
        );

    -- ALU (additionneur/soustracteur)
    alu_inst: entity work.alu
        port map (
            a      => a_out,
            b      => bus_wires,
            sub    => add_sub,
            result => alu_result
        );

    -- Multiplexeur de bus
    mux_inst: entity work.mux_bus
        port map (
            r0      => r0_out,
            r1      => r1_out,
            r2      => r2_out,
            r3      => r3_out,
            r4      => r4_out,
            r5      => r5_out,
            r6      => r6_out,
            r7      => r7_out,
            g       => g_out_data,
            din     => din,
            r_out   => r_out,
            g_out   => g_out,
            din_out => din_out,
            bus_out => bus_wires
        );

    -- Machine à états (contrôleur)
    fsm_inst: entity work.fsm
        port map (
            clk     => clk,
            resetn  => resetn,
            run     => run,
            ir      => ir_out,
            ir_load => ir_load,
            a_load  => a_load,
            g_load  => g_load,
            r_load  => r_load,
            r_out   => r_out,
            g_out   => g_out,
            din_out => din_out,
            add_sub => add_sub,
            done    => done
        );

    -- Sortie du bus pour observation
    bus_out <= bus_wires;

end architecture structural;
