--------------------------------------------------------
--
--------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity debounce is
	port (
		clk       : in std_logic;
		button    : in std_logic;
		debounced : out std_logic
	);
end debounce;

architecture rtl of debounce is
	signal count         : std_logic_vector(19 downto 0);  -- Compteur 20 bits (~20ms à 50MHz)
	signal done          : std_logic;      -- Indique fin du délai anti-rebond
	signal debounced_reg : std_logic;      -- État stable du bouton
	signal count_reset   : std_logic;
	signal count_enable  : std_logic;
begin
	-- ÉTAPE 1: Compteur de temporisation (2^20 cycles ≈ 21ms à 50MHz)
	COUNTER: entity work.counter
		generic map (
			n => 20
		)
		port map (
			clk       => clk,
			rst       => count_reset,
			enable    => count_enable,
			count_out => count
		);

	-- ÉTAPE 2: Contrôle du compteur
	count_reset  <= done;           -- Reset quand délai atteint
	count_enable <= debounced_reg;  -- Compte seulement si bouton détecté

	-- ÉTAPE 3: Détection d'appui avec anti-rebond
	-- Bouton actif bas (KEY sur DE10-Lite)
	process(clk)
	begin
		if rising_edge(clk) then
			if done = '1' and button = '1' then
				debounced_reg <= '0';  -- Relâchement confirmé après délai
			elsif button = '0' then
				debounced_reg <= '1';  -- Appui détecté (actif bas)
			end if;
		end if;
	end process;

	-- ÉTAPE 4: Détection de fin de comptage (tous les bits à 1)
	done <= '1' when count = "11111111111111111111" else '0';
	debounced <= not debounced_reg;  -- Inverse pour KEY actif bas
end rtl;
