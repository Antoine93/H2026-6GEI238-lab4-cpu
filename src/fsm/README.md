# fsm - Machine à états finis

## Description
Contrôleur du processeur. Génère les signaux de contrôle pour exécuter les instructions mv, mvi, add, sub.

## États

| État | Description |
|------|-------------|
| T0 | Chargement instruction (IR ← DIN) |
| T1 | Décodage + exécution (mv/mvi terminent ici) |
| T2 | Calcul ALU (G ← A ± Ry) |
| T3 | Écriture résultat (Rx ← G) |

## Ports d'entrée

| Port | Description |
|------|-------------|
| `clk` | Horloge |
| `resetn` | Reset actif bas |
| `run` | Démarrer exécution |
| `ir` | Instruction courante (9 bits) |

## Signaux de contrôle (sorties)

| Signal | Description |
|--------|-------------|
| `ir_load` | Charger IR |
| `a_load` | Charger A |
| `g_load` | Charger G |
| `r_load` | Charger registre Rx (one-hot) |
| `r_out` | Sélection source bus (one-hot) |
| `g_out` | G vers bus |
| `din_out` | DIN vers bus |
| `add_sub` | 0=add, 1=sub |
| `done` | Instruction terminée |

## Cycles par instruction

| Instruction | Cycles |
|-------------|--------|
| mv, mvi | 2 (T0→T1) |
| add, sub | 4 (T0→T1→T2→T3) |

## Simulation
```powershell
cd scripts && .\sim.ps1 fsm
```
