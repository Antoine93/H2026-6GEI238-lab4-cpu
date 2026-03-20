------------------------------------------------------------------------
-- Bascule D vectorielle (D-type Flip Flop)
-- Composant de base réutilisable pour registres et compteurs
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity vDFF is
   generic (
		n: integer := 1  -- Largeur paramétrable (défaut: 1 bit)
	);
   port (
		clk: in std_logic;                          -- Horloge
      	D: in std_logic_vector( n-1 downto 0 );     -- Entrée données
      	Q: out std_logic_vector( n-1 downto 0 )     -- Sortie mémorisée
	);
end vDFF;

architecture rtl of vDFF is
begin
  -- ÉTAPE UNIQUE: Mémorisation sur front montant
  -- Q prend la valeur de D à chaque rising_edge(clk)
  process(clk) begin
    if rising_edge(clk) then
      Q <= D;  -- Transfert synchrone D → Q
    end if;
  end process;
end rtl;
