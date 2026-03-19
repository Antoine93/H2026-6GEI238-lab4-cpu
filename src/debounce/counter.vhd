--------------------------------------------------------
--
--------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity counter is
	generic (
		n : integer := 2
	);
	port (
		clk    : in std_logic;
		rst    : in std_logic;
		enable : in std_logic;
		count_out : out std_logic_vector(n-1 downto 0)
	);
end counter;

architecture rtl of counter is
	signal cnt, nxt : std_logic_vector(n-1 downto 0);  -- cnt=valeur actuelle, nxt=prochaine valeur
begin
	-- ÉTAPE 1: Registre de stockage (bascule D vectorielle)
	COUNT: entity work.vDFF
		generic map (
			n => n
		)
		port map (
			clk => clk,
			D   => nxt,   -- Entrée : valeur calculée
			Q   => cnt    -- Sortie : valeur mémorisée
		);

	-- ÉTAPE 2: Logique combinatoire du compteur
	process(rst, enable, cnt)
	begin
		if rst = '1' then
			nxt <= (others => '0');  -- Reset prioritaire → compteur à zéro
		elsif enable = '1' then
			nxt <= cnt + 1;          -- Incrémentation si activé
		else
			nxt <= cnt;              -- Maintien de la valeur sinon
		end if;
	end process;

	-- ÉTAPE 3: Sortie du compteur
	count_out <= cnt;
end rtl;
