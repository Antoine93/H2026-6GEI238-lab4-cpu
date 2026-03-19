# alu - Unité arithmétique et logique

## Description
Additionneur/soustracteur 9 bits. Effectue A + B ou A - B selon le signal `sub`.

## Ports

| Port | Direction | Type | Description |
|------|-----------|------|-------------|
| `a` | in | std_logic_vector(8 downto 0) | Opérande A |
| `b` | in | std_logic_vector(8 downto 0) | Opérande B |
| `sub` | in | std_logic | 0=addition, 1=soustraction |
| `result` | out | std_logic_vector(8 downto 0) | Résultat |

## Opérations

| sub | Opération |
|-----|-----------|
| 0 | result = a + b |
| 1 | result = a - b |

## Utilisation dans proc
- Entrée A : registre A
- Entrée B : bus (contenu de Ry)
- Sortie : vers registre G

## Simulation
```powershell
cd scripts && .\sim.ps1 alu
```
