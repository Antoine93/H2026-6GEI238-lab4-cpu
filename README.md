# Processeur Simple 9 bits

Laboratoire 4 - 6GEI238 Conception de systèmes numériques (UQAC, Hiver 2026)

## Architecture

Processeur simple supportant 4 instructions sur des mots de 9 bits.

### Instructions

| Opcode | Instruction | Description |
|--------|-------------|-------------|
| 000 | `mv Rx, Ry` | Rx ← Ry |
| 001 | `mvi Rx, #D` | Rx ← donnée immédiate |
| 010 | `add Rx, Ry` | Rx ← Rx + Ry |
| 011 | `sub Rx, Ry` | Rx ← Rx - Ry |

### Format instruction

```
IIIXXXYYY (9 bits)
III = opcode (3 bits)
XXX = registre destination (3 bits)
YYY = registre source (3 bits)
```

## Structure du projet

```
src/
├── regn/        # Registre générique n bits
├── dec3to8/     # Décodeur 3 vers 8 (one-hot)
├── alu/         # Additionneur/soustracteur
├── mux_bus/     # Multiplexeur 10:1 pour bus
├── fsm/         # Machine à états (contrôleur)
└── proc/        # Top-level (processeur complet)

scripts/
├── sim.ps1      # Simulation d'un composant isolé
└── sim_all.ps1  # Simulation du processeur complet
```

## Utilisation

### Simuler un composant

```powershell
cd scripts
.\sim.ps1 regn      # ou: alu, fsm, mux_bus, dec3to8
```

### Simuler le processeur complet

```powershell
cd scripts
.\sim_all.ps1
```

## Outils

- **GHDL** : Compilation et simulation VHDL
- **GTKWave** : Visualisation des chronogrammes
- **Quartus Prime** : Synthèse pour DE10-Lite

## Hiérarchie des dépendances

```
Niveau 0: regn, dec3to8, alu
Niveau 1: mux_bus, fsm
Niveau 2: proc (top-level)
```
