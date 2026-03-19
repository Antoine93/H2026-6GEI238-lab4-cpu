# regn - Registre générique n bits

## Description
Registre parallèle avec chargement synchrone. Stocke n bits sur front montant d'horloge quand `load = '1'`.

## Ports

| Port | Direction | Type | Description |
|------|-----------|------|-------------|
| `d` | in | std_logic_vector(n-1 downto 0) | Données entrantes |
| `load` | in | std_logic | Activer chargement |
| `clk` | in | std_logic | Horloge |
| `resetn` | in | std_logic | Reset actif bas |
| `q` | out | std_logic_vector(n-1 downto 0) | Données stockées |

## Generic
- `n` : Largeur du registre (défaut: 9)

## Utilisation dans proc
- IR (registre instruction)
- R0-R7 (registres généraux)
- A (opérande ALU)
- G (résultat ALU)

## Simulation
```powershell
cd scripts && .\sim.ps1 regn
```
