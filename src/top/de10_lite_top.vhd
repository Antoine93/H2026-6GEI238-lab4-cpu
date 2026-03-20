-- =============================================================================
-- fichier     : de10_lite_top.vhd
-- description : Top-level pour la carte DE10-Lite.
--               Meme approche que lab 3 : debounce direct comme horloge.
-- =============================================================================

library ieee;
use ieee.std_logic_1164.all;

entity de10_lite_top is
    port (
        CLOCK_50 : in  std_logic;
        KEY      : in  std_logic_vector(1 downto 0);
        SW       : in  std_logic_vector(9 downto 0);
        LEDR     : out std_logic_vector(9 downto 0)
    );
end entity de10_lite_top;

architecture structural of de10_lite_top is

    -- Signaux debounces
    signal clk_debounced    : std_logic;
    signal resetn_debounced : std_logic;

    -- Signaux du processeur
    signal proc_bus  : std_logic_vector(8 downto 0);
    signal proc_done : std_logic;

begin

    -- =========================================================================
    -- Debounce pour KEY[0] (horloge manuelle du processeur)
    -- =========================================================================
    debounce_clk: entity work.debounce
        port map (
            clk       => CLOCK_50,
            button    => KEY(0),
            debounced => clk_debounced
        );

    -- =========================================================================
    -- Debounce pour KEY[1] (reset du processeur)
    -- =========================================================================
    debounce_rst: entity work.debounce
        port map (
            clk       => CLOCK_50,
            button    => KEY(1),
            debounced => resetn_debounced
        );

    -- =========================================================================
    -- Processeur
    -- Le debounce sort '1' quand bouton appuye, '0' sinon
    -- Lab 3: rst actif haut (rst='1' = reset)
    -- Lab 4: resetn actif bas (resetn='0' = reset)
    -- Donc: NOT resetn_debounced pour inverser la logique
    -- =========================================================================
    cpu: entity work.proc
        port map (
            clk     => clk_debounced,
            resetn  => not resetn_debounced,
            run     => SW(9),
            din     => SW(8 downto 0),
            bus_out => proc_bus,
            done    => proc_done
        );

    -- =========================================================================
    -- Connexion aux LEDs
    -- =========================================================================
    LEDR(8 downto 0) <= proc_bus;
    LEDR(9)          <= proc_done;

end architecture structural;
