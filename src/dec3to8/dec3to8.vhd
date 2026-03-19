-- =============================================================================
-- fichier     : dec3to8.vhd
-- description : décodeur 3 bits vers 8 bits avec enable
-- =============================================================================

library ieee;
use ieee.std_logic_1164.all;

entity dec3to8 is
    port (
        w  : in  std_logic_vector(2 downto 0);
        en : in  std_logic;
        y  : out std_logic_vector(7 downto 0)
    );
end entity dec3to8;

architecture behavior of dec3to8 is
begin
    process(w, en)
    begin
        if en = '0' then
            y <= "00000000";
        else
            case w is
                when "000" => y <= "00000001";
                when "001" => y <= "00000010";
                when "010" => y <= "00000100";
                when "011" => y <= "00001000";
                when "100" => y <= "00010000";
                when "101" => y <= "00100000";
                when "110" => y <= "01000000";
                when "111" => y <= "10000000";
                when others => y <= "00000000";
            end case;
        end if;
    end process;
end architecture behavior;
