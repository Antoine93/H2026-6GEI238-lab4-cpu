# mux_bus - Multiplexeur de bus

## Description
Multiplexeur 10 vers 1 pour le bus partagé. Sélectionne une source parmi R0-R7, G ou DIN.

## Ports

| Port | Direction | Type | Description |
|------|-----------|------|-------------|
| `r0` à `r7` | in | std_logic_vector(8 downto 0) | Registres R0-R7 |
| `g` | in | std_logic_vector(8 downto 0) | Résultat ALU |
| `din` | in | std_logic_vector(8 downto 0) | Entrée externe |
| `r_out` | in | std_logic_vector(7 downto 0) | Sélection registre (one-hot) |
| `g_out` | in | std_logic | Sélection G |
| `din_out` | in | std_logic | Sélection DIN |
| `bus_out` | out | std_logic_vector(8 downto 0) | Sortie bus |

## Priorité
```
if r_out(i) = '1' then bus_out <= ri     -- R0-R7 (priorité haute)
elsif g_out = '1' then bus_out <= g
elsif din_out = '1' then bus_out <= din  -- DIN (priorité basse)
```

## Simulation
```powershell
cd scripts && .\sim.ps1 mux_bus
```
