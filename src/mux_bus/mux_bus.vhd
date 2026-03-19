-- =============================================================================
-- fichier     : mux_bus.vhd
-- description : multiplexeur 10 vers 1 pour le bus du processeur
-- =============================================================================

library ieee;
use ieee.std_logic_1164.all;

entity mux_bus is
    port (
        -- entrées des registres
        r0, r1, r2, r3 : in std_logic_vector(8 downto 0);
        r4, r5, r6, r7 : in std_logic_vector(8 downto 0);
        -- entrée du résultat ALU
        g              : in std_logic_vector(8 downto 0);
        -- entrée externe
        din            : in std_logic_vector(8 downto 0);
        -- signaux de sélection
        r_out          : in std_logic_vector(7 downto 0);
        g_out          : in std_logic;
        din_out        : in std_logic;
        -- sortie
        bus_out        : out std_logic_vector(8 downto 0)
    );
end entity mux_bus;

architecture behavior of mux_bus is
begin
    process(r0, r1, r2, r3, r4, r5, r6, r7, g, din, r_out, g_out, din_out)
    begin
        if r_out(0) = '1' then
            bus_out <= r0;
        elsif r_out(1) = '1' then
            bus_out <= r1;
        elsif r_out(2) = '1' then
            bus_out <= r2;
        elsif r_out(3) = '1' then
            bus_out <= r3;
        elsif r_out(4) = '1' then
            bus_out <= r4;
        elsif r_out(5) = '1' then
            bus_out <= r5;
        elsif r_out(6) = '1' then
            bus_out <= r6;
        elsif r_out(7) = '1' then
            bus_out <= r7;
        elsif g_out = '1' then
            bus_out <= g;
        elsif din_out = '1' then
            bus_out <= din;
        else
            bus_out <= (others => '0');
        end if;
    end process;
end architecture behavior;
