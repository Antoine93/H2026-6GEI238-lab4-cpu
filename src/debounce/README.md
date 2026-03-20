# debounce - Anti-rebond pour boutons

## Description
Circuit anti-rebond pour stabiliser les entrées des boutons mécaniques (KEY) du DE10-Lite. Utilise un compteur 20 bits (~21ms à 50MHz).

## Fichiers

| Fichier | Description |
|---------|-------------|
| `debounce.vhd` | Module principal anti-rebond |
| `counter.vhd` | Compteur générique n bits |
| `vDFF.vhd` | Bascule D vectorielle |

## Ports (debounce)

| Port | Direction | Type | Description |
|------|-----------|------|-------------|
| `clk` | in | std_logic | Horloge 50MHz |
| `button` | in | std_logic | Entrée bouton (actif bas) |
| `debounced` | out | std_logic | Sortie stabilisée |

## Fonctionnement
1. Bouton pressé (button='0') : `debounced` passe à '1'
2. Compteur démarre et compte jusqu'à 2^20 cycles
3. Bouton relâché (button='1') après délai : `debounced` repasse à '0'

## Utilisation dans le projet
- **Partie 3** : Stabilise KEY[0] (Clock) et KEY[1] (Reset) pour le processeur
- **Partie 4** : Stabilise MClock et PClock

## Note
Ne pas utiliser en simulation (testbench) - le debounce est destiné uniquement au matériel.
