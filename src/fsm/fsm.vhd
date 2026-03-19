-- =============================================================================
-- fichier     : fsm.vhd
-- description : Machine à états finis du processeur simple.
--               Génère les signaux de contrôle pour exécuter les instructions
--               mv, mvi, add et sub sur 4 états (T0, T1, T2, T3).
-- =============================================================================

library ieee;
use ieee.std_logic_1164.all;

entity fsm is
    port (
        clk     : in  std_logic;
        resetn  : in  std_logic;
        run     : in  std_logic;
        ir      : in  std_logic_vector(8 downto 0);

        -- Signaux de contrôle
        ir_load  : out std_logic;
        a_load   : out std_logic;
        g_load   : out std_logic;
        r_load   : out std_logic_vector(7 downto 0);
        r_out    : out std_logic_vector(7 downto 0);
        g_out    : out std_logic;
        din_out  : out std_logic;
        add_sub  : out std_logic;
        done     : out std_logic
    );
end entity fsm;

architecture behavioral of fsm is
    -- Définition des états
    type state_type is (t0, t1, t2, t3);
    signal state, next_state : state_type;

    -- Codes d'opération (champ III)
    constant OP_MV  : std_logic_vector(2 downto 0) := "000";
    constant OP_MVI : std_logic_vector(2 downto 0) := "001";
    constant OP_ADD : std_logic_vector(2 downto 0) := "010";
    constant OP_SUB : std_logic_vector(2 downto 0) := "011";

    -- Extraction des champs de l'instruction
    alias opcode : std_logic_vector(2 downto 0) is ir(8 downto 6);
    alias rx     : std_logic_vector(2 downto 0) is ir(5 downto 3);
    alias ry     : std_logic_vector(2 downto 0) is ir(2 downto 0);

    -- Fonction de décodage one-hot
    function decode(sel : std_logic_vector(2 downto 0)) return std_logic_vector is
        variable result : std_logic_vector(7 downto 0);
    begin
        result := (others => '0');
        case sel is
            when "000" => result := "00000001";
            when "001" => result := "00000010";
            when "010" => result := "00000100";
            when "011" => result := "00001000";
            when "100" => result := "00010000";
            when "101" => result := "00100000";
            when "110" => result := "01000000";
            when "111" => result := "10000000";
            when others => result := "00000000";
        end case;
        return result;
    end function;

begin
    -- Registre d'état (séquentiel)
    process(clk, resetn)
    begin
        if resetn = '0' then
            state <= t0;
        elsif rising_edge(clk) then
            state <= next_state;
        end if;
    end process;

    -- Logique de transition et sorties (combinatoire)
    process(state, run, opcode, rx, ry)
    begin
        -- Valeurs par défaut (tout inactif)
        next_state <= state;
        ir_load  <= '0';
        a_load   <= '0';
        g_load   <= '0';
        r_load   <= (others => '0');
        r_out    <= (others => '0');
        g_out    <= '0';
        din_out  <= '0';
        add_sub  <= '0';
        done     <= '0';

        case state is
            when t0 =>
                if run = '1' then
                    -- Charger l'instruction: IR <- DIN
                    ir_load <= '1';
                    din_out <= '1';
                    next_state <= t1;
                end if;

            when t1 =>
                case opcode is
                    when OP_MV =>
                        -- mv Rx, Ry: Rx <- Ry (terminé en T1)
                        r_out  <= decode(ry);  -- Source = Ry
                        r_load <= decode(rx);  -- Dest = Rx
                        done <= '1';
                        next_state <= t0;

                    when OP_MVI =>
                        -- mvi Rx, #D: Rx <- DIN (terminé en T1)
                        din_out <= '1';
                        r_load  <= decode(rx);
                        done <= '1';
                        next_state <= t0;

                    when OP_ADD | OP_SUB =>
                        -- add/sub: A <- Rx (continuer vers T2)
                        r_out  <= decode(rx);
                        a_load <= '1';
                        next_state <= t2;

                    when others =>
                        next_state <= t0;
                end case;

            when t2 =>
                -- G <- A +/- Ry
                r_out   <= decode(ry);
                g_load  <= '1';
                if opcode = OP_SUB then
                    add_sub <= '1';
                end if;
                next_state <= t3;

            when t3 =>
                -- Rx <- G
                g_out  <= '1';
                r_load <= decode(rx);
                done   <= '1';
                next_state <= t0;

        end case;
    end process;

end architecture behavioral;
