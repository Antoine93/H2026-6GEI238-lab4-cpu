-- =============================================================================
-- fichier     : de10_lite_top_part4.vhd
-- description : Top-level pour la partie 4 - CPU avec memoire ROM
--               Integre : Compteur + ROM + Processeur
--               MClock (KEY0) : horloge memoire/compteur
--               PClock (KEY1) : horloge processeur
-- =============================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity de10_lite_top_part4 is
    port (
        CLOCK_50 : in  std_logic;
        KEY      : in  std_logic_vector(1 downto 0);
        SW       : in  std_logic_vector(9 downto 0);
        LEDR     : out std_logic_vector(9 downto 0)
    );
end entity de10_lite_top_part4;

architecture structural of de10_lite_top_part4 is

    -- Signaux debounces
    signal mclock_debounced : std_logic;  -- Horloge memoire/compteur
    signal pclock_debounced : std_logic;  -- Horloge processeur

    -- Signaux du compteur (avec reset synchrone via registre)
    signal counter_reg : std_logic_vector(4 downto 0) := "00000";
    signal counter_next : std_logic_vector(4 downto 0);

    -- Signaux de la ROM
    signal rom_data : std_logic_vector(8 downto 0);

    -- Signaux du processeur
    signal proc_bus  : std_logic_vector(8 downto 0);
    signal proc_done : std_logic;
    signal resetn    : std_logic;
    signal run       : std_logic;

begin

    -- =========================================================================
    -- Configuration des entrees
    -- SW(9) = RUN
    -- SW(0) = Reset (actif haut)
    -- =========================================================================
    run    <= SW(9);
    resetn <= not SW(0);  -- Processeur a reset actif bas

    -- =========================================================================
    -- Debounce pour KEY[0] (MClock - horloge memoire/compteur)
    -- =========================================================================
    debounce_mclock: entity work.debounce
        port map (
            clk       => CLOCK_50,
            button    => KEY(0),
            debounced => mclock_debounced
        );

    -- =========================================================================
    -- Debounce pour KEY[1] (PClock - horloge processeur)
    -- =========================================================================
    debounce_pclock: entity work.debounce
        port map (
            clk       => CLOCK_50,
            button    => KEY(1),
            debounced => pclock_debounced
        );

    -- =========================================================================
    -- Compteur 5 bits pour adresser la ROM (32 mots)
    -- Reset ASYNCHRONE avec SW(0)
    -- Incremente sur MClock quand RUN est actif
    -- =========================================================================
    process(mclock_debounced, SW(0))
    begin
        if SW(0) = '1' then
            -- Reset asynchrone : compteur a 0 immediatement
            counter_reg <= "00000";
        elsif rising_edge(mclock_debounced) then
            if run = '1' then
                counter_reg <= counter_next;
            end if;
        end if;
    end process;

    -- Incrementeur
    counter_next <= std_logic_vector(unsigned(counter_reg) + 1);

    -- =========================================================================
    -- ROM 32x9 bits (generee par IP Catalog)
    -- Contient les instructions du processeur
    -- =========================================================================
    instruction_memory: entity work.inst_mem
        port map (
            address => counter_reg,
            clock   => mclock_debounced,
            q       => rom_data
        );

    -- =========================================================================
    -- Processeur
    -- DIN provient de la ROM
    -- =========================================================================
    cpu: entity work.proc
        port map (
            clk     => pclock_debounced,
            resetn  => resetn,
            run     => run,
            din     => rom_data,
            bus_out => proc_bus,
            done    => proc_done
        );

    -- =========================================================================
    -- Connexion aux LEDs
    -- LEDR(8:0) = Bus du processeur
    -- LEDR(9)   = Done
    -- =========================================================================
    LEDR(8 downto 0) <= proc_bus;
    LEDR(9)          <= proc_done;

end architecture structural;
