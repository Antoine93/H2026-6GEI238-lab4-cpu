# dec3to8 - Décodeur 3 vers 8

## Description
Décodeur binaire 3 bits vers 8 bits one-hot. Convertit un numéro de registre (0-7) en signal de sélection.

## Ports

| Port | Direction | Type | Description |
|------|-----------|------|-------------|
| `w` | in | std_logic_vector(2 downto 0) | Entrée binaire (0-7) |
| `en` | in | std_logic | Enable |
| `y` | out | std_logic_vector(7 downto 0) | Sortie one-hot |

## Table de vérité

| w | y (si en='1') |
|---|---------------|
| 000 | 00000001 |
| 001 | 00000010 |
| 010 | 00000100 |
| ... | ... |
| 111 | 10000000 |

## Utilisation dans proc
Décode les champs XXX et YYY de l'instruction pour sélectionner les registres.

## Simulation
```powershell
cd scripts && .\sim.ps1 dec3to8
```
