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

## Parties du laboratoire

| Partie | Description | Fichiers clés |
|--------|-------------|---------------|
| 1 | Processeur simple | `src/proc/proc.vhd` |
| 2 | Testbench | `src/proc/proc_tb.vhd` |
| 3 | Interface DE10-Lite + debounce | `src/top/de10_lite_top.vhd` |
| 4 | Intégration mémoire ROM | `src/top/de10_lite_top_part4.vhd` |

## Structure du projet

```
src/
├── alu/         # Additionneur/soustracteur
├── debounce/    # Anti-rebond (counter, vDFF)
├── dec3to8/     # Décodeur 3 vers 8 (one-hot)
├── fsm/         # Machine à états (contrôleur)
├── mux_bus/     # Multiplexeur 10:1 pour bus
├── proc/        # Processeur complet
├── regn/        # Registre générique n bits
└── top/         # Top-levels DE10-Lite (Parties 3 et 4)

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
Niveau 0: regn, dec3to8, alu, vDFF
Niveau 1: mux_bus, fsm, counter
Niveau 2: proc, debounce
Niveau 3: de10_lite_top (Partie 3)
Niveau 4: de10_lite_top_part4 (Partie 4, nécessite inst_mem)
```

## Connexions DE10-Lite

### Partie 3 (entrée manuelle)
| Périphérique | Fonction |
|--------------|----------|
| KEY[0] | Horloge processeur |
| KEY[1] | Reset (actif bas) |
| SW[8:0] | DIN (instruction) |
| SW[9] | RUN |
| LEDR[8:0] | Bus |
| LEDR[9] | Done |

### Partie 4 (avec ROM)
| Périphérique | Fonction |
|--------------|----------|
| KEY[0] | MClock (mémoire) |
| KEY[1] | PClock (processeur) |
| SW[0] | Reset |
| SW[9] | RUN |
| LEDR[8:0] | Bus |
| LEDR[9] | Done |
