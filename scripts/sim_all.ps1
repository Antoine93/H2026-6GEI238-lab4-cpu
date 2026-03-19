# =============================================================================
# fichier     : sim_all.ps1
# description : Compile tous les composants du processeur et lance la simulation
# usage       : .\sim_all.ps1
# =============================================================================

$SrcDir = "../src"

Write-Host "=== Compilation de tous les composants ===" -ForegroundColor Cyan

# Niveau 0 (sans dépendances)
Write-Host "Niveau 0: regn, dec3to8, alu" -ForegroundColor Yellow
ghdl -a --std=08 "$SrcDir/regn/regn.vhd"
if ($LASTEXITCODE -ne 0) { exit 1 }
ghdl -a --std=08 "$SrcDir/dec3to8/dec3to8.vhd"
if ($LASTEXITCODE -ne 0) { exit 1 }
ghdl -a --std=08 "$SrcDir/alu/alu.vhd"
if ($LASTEXITCODE -ne 0) { exit 1 }

# Niveau 1 (dépend de niveau 0)
Write-Host "Niveau 1: mux_bus, fsm" -ForegroundColor Yellow
ghdl -a --std=08 "$SrcDir/mux_bus/mux_bus.vhd"
if ($LASTEXITCODE -ne 0) { exit 1 }
ghdl -a --std=08 "$SrcDir/fsm/fsm.vhd"
if ($LASTEXITCODE -ne 0) { exit 1 }

# Niveau 2 (top-level)
Write-Host "Niveau 2: proc" -ForegroundColor Yellow
ghdl -a --std=08 "$SrcDir/proc/proc.vhd"
if ($LASTEXITCODE -ne 0) { exit 1 }
ghdl -a --std=08 "$SrcDir/proc/proc_tb.vhd"
if ($LASTEXITCODE -ne 0) { exit 1 }

# Élaboration
Write-Host "Élaboration..." -ForegroundColor Yellow
ghdl -e --std=08 proc_tb
if ($LASTEXITCODE -ne 0) { exit 1 }

# Exécution
Write-Host "Exécution (génération VCD)..." -ForegroundColor Yellow
ghdl -r --std=08 proc_tb --vcd="$SrcDir/proc/proc_tb.vcd" --stop-time=2000ns
if ($LASTEXITCODE -ne 0) { exit 1 }

# Ouverture GTKWave
$blueViolet = "$([char]27)[38;2;138;43;226m"
$reset = "$([char]27)[0m"
Write-Host "${blueViolet}Ouverture de GTKWave...${reset}"
gtkwave "$SrcDir/proc/proc_tb.vcd"
