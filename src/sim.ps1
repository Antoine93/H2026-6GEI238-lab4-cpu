# sim.ps1 - Simulation GHDL + GTKWave
# Usage: .\sim.ps1 <dossier>
# Exemple: .\sim.ps1 regn

param(
    [Parameter(Mandatory=$true)]
    [string]$Entity
)

$EntityPath = "$Entity/$Entity.vhd"
$TbPath = "$Entity/${Entity}_tb.vhd"
$VcdFile = "$Entity/${Entity}_tb.vcd"

Write-Host "=== Simulation de $Entity ===" -ForegroundColor Cyan

# Vérifier que les fichiers existent
if (-not (Test-Path $EntityPath)) {
    Write-Host "ERREUR: $EntityPath introuvable" -ForegroundColor Red
    exit 1
}
if (-not (Test-Path $TbPath)) {
    Write-Host "ERREUR: $TbPath introuvable" -ForegroundColor Red
    exit 1
}

# Analyser
Write-Host "Analyse de $Entity.vhd..." -ForegroundColor Yellow
ghdl -a --std=08 $EntityPath
if ($LASTEXITCODE -ne 0) { exit 1 }

Write-Host "Analyse de ${Entity}_tb.vhd..." -ForegroundColor Yellow
ghdl -a --std=08 $TbPath
if ($LASTEXITCODE -ne 0) { exit 1 }

# Élaborer
Write-Host "Élaboration..." -ForegroundColor Yellow
ghdl -e --std=08 "${Entity}_tb"
if ($LASTEXITCODE -ne 0) { exit 1 }

# Exécuter
Write-Host "Exécution (génération VCD)..." -ForegroundColor Yellow
ghdl -r --std=08 "${Entity}_tb" --vcd=$VcdFile --stop-time=500ns
if ($LASTEXITCODE -ne 0) { exit 1 }

# Ouvrir GTKWave
Write-Host "Ouverture de GTKWave..." -ForegroundColor Green
gtkwave $VcdFile
