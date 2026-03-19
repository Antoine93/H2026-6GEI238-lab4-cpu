# proc - Processeur (top-level)

## Description
Top-level du processeur simple 9 bits. Instancie et interconnecte tous les composants.

## Ports

| Port | Direction | Type | Description |
|------|-----------|------|-------------|
| `clk` | in | std_logic | Horloge |
| `resetn` | in | std_logic | Reset actif bas |
| `run` | in | std_logic | Démarrer instruction |
| `din` | in | std_logic_vector(8 downto 0) | Données/instruction entrantes |
| `bus_out` | out | std_logic_vector(8 downto 0) | Observation du bus |
| `done` | out | std_logic | Instruction terminée |

## Composants instanciés

| Instance | Composant | Quantité |
|----------|-----------|----------|
| ir_reg | regn | 1 |
| r0_reg à r7_reg | regn | 8 |
| a_reg | regn | 1 |
| g_reg | regn | 1 |
| alu_inst | alu | 1 |
| mux_inst | mux_bus | 1 |
| fsm_inst | fsm | 1 |

**Total: 14 instances**

## Simulation
```powershell
cd scripts && .\sim_all.ps1
```
