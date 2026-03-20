# top - Modules top-level DE10-Lite

## Description
Modules d'intégration finale pour la carte DE10-Lite. Connectent le processeur aux périphériques physiques.

## Fichiers

| Fichier | Partie | Description |
|---------|--------|-------------|
| `de10_lite_top.vhd` | Partie 3 | CPU avec entrée manuelle (SW) |
| `de10_lite_top_part4.vhd` | Partie 4 | CPU avec mémoire ROM |

## de10_lite_top (Partie 3)

### Connexions
| Périphérique | Signal | Fonction |
|--------------|--------|----------|
| KEY[0] | Clock processeur | Via debounce |
| KEY[1] | Reset (actif bas) | Via debounce |
| SW[8:0] | DIN (instruction/données) | Direct |
| SW[9] | RUN | Direct |
| LEDR[8:0] | Bus processeur | Observation |
| LEDR[9] | Done | Fin instruction |

## de10_lite_top_part4 (Partie 4)

### Connexions
| Périphérique | Signal | Fonction |
|--------------|--------|----------|
| KEY[0] | MClock | Horloge mémoire/compteur |
| KEY[1] | PClock | Horloge processeur |
| SW[0] | Reset (actif haut) | Reset asynchrone |
| SW[9] | RUN | Active compteur + processeur |
| LEDR[8:0] | Bus processeur | Observation |
| LEDR[9] | Done | Fin instruction |

### Architecture
```
MClock ──┬──> Compteur 5 bits ──> ROM 32x9 ──> DIN
         └──> ROM clock                         │
                                                v
PClock ──────────────────────────────────> Processeur ──> LEDR
```

### Dépendance
Nécessite `inst_mem.vhd` (ROM générée via IP Catalog avec fichier `inst_mem.mif`).
