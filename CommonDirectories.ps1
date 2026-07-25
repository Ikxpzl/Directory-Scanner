# Limpiar consola y configurar codificación
Clear-Host
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Asegurar que existe la ruta de salida para el reporte
$outputDir = "C:\Screenshare"
if (-not (Test-Path $outputDir)) { New-Item -Path $outputDir -ItemType Directory -Force | Out-Null }
$outputPath = "$outputDir\paths.txt"
$reportLines = @()

# Dibujar el logo de PATHS en la consola
Write-Host " ______   ______  ______  __  __   ______ " -ForegroundColor Cyan
Write-Host "/\  __ \ /\  __ \/\__  _\/\ \_\ \ /\  ___\ " -ForegroundColor Cyan
Write-Host "\ \  __< \ \  __ \/_/\ \/\ \  __  \\ \___  \ " -ForegroundColor Cyan
Write-Host " \ \_\ \_\\ \_\ \_\ \ \_\ \ \_\ \_\ \_____\ " -ForegroundColor Cyan
Write-Host "  \/_/ /_/ \/_/\/_/  \/_/  \/_/\/_/ \/_____/ " -ForegroundColor Cyan
Write-Host "`n Made with love`n" -ForegroundColor Magenta

Write-Host "Scanning for non-Microsoft files & suspicious strings..." -ForegroundColor Gray
Write-Host "Output: $outputPath`n" -ForegroundColor Yellow

# Configurar rutas a escanear
$scanTargets = @(
    @{ Path = "C:\Windows\System32"; Name = "C:\Windows\System32" }
    @{ Path = "C:\Windows\SysWOW64"; Name = "C:\Windows\SysWOW64" }
    @{ Path = $env:TEMP; Name = "C:\Users\" + $env:USERNAME + "\AppData\Local\Temp" }
)

# Diccionario de cadenas sospechosas (Cheats / Autoclicks)
$cheatKeywords = @("autoclick", "clicker", "cheat", "hack", "macro", "triggerbot", "aimbot", "injector")

$totalFilesChecked = 0
$nonMicrosoftFound = 0
$startTime = Get-Date

# Recorrer cada directorio objetivo
foreach ($target in $scanTargets) {
    if (-not (Test-Path $target.Path)) { continue }
    
    Write-Host "Scanning: $($target.Name)" -ForegroundColor Cyan
    
    # Buscar ejecutables, librerías, drivers y componentes binarios comunes
    $files = Get-ChildItem -Path $target.Path -Include *.exe, *.dll, *.sys, *.node -Recurse -File -ErrorAction SilentlyContinue
    
    $dirCheckedCount = 0
    $dirFoundCount = 0
    
    foreach ($file in $files) {
        $totalFilesChecked++
        $dirCheckedCount++
        
        # Mostrar progreso dinámico cada 500 archivos inspeccionados
        if ($dirCheckedCount % 500 -eq 0) {
            Write-Host "  Checked: $dirCheckedCount" -ForegroundColor Gray
        }
        
        $isSuspicious = $false
        
        # 1. Filtro Forense: Comprobar la firma o compañía del archivo
        $versionInfo = Get-ItemProperty -Path $file.FullName -ErrorAction SilentlyContinue | Select-Object -ExpandProperty VersionInfo -ErrorAction SilentlyContinue
        if ($null -ne $versionInfo -and $null -ne $versionInfo.CompanyName) {
            if ($versionInfo.CompanyName -notmatch "Microsoft") {
                $isSuspicious = $true
            }
        } else {
            # Si no tiene firma/compañía (común en malware/cheats caseros) se marca como sospechoso
            $isSuspicious = $true
        }
        
        # 2. Filtro Forense: Buscar cadenas básicas de cheats en el nombre del archivo
        foreach ($kw in $cheatKeywords) {
            if ($file.Name -like "*$kw*") {
                $isSuspicious = $true
                break
            }
        }
        
        # Si cumple los criterios, se indexa en el reporte
        if ($isSuspicious) {
            $dirFoundCount++
            $nonMicrosoftFound++
            $reportLines += $file.FullName
        }
    }
    
    Write-Host "  Found: $dirFoundCount files" -ForegroundColor Green
}

# Escribir el reporte final en el disco duro
$reportLines | Out-File -FilePath $outputPath -Encoding utf8 -Force

# Estadísticas finales en pantalla
$endTime = Get-Date
$duration = New-TimeSpan -Start $startTime -End $endTime
$elapsedMinutes = [math]::Round($duration.TotalMinutes, 1)

Write-Host "`nScan Complete c:" -ForegroundColor Green
Write-Host "  Time: $elapsedMinutes minutes" -ForegroundColor Gray
Write-Host "  Files checked: $totalFilesChecked" -ForegroundColor Gray
Write-Host "  Non-Microsoft files found: $nonMicrosoftFound" -ForegroundColor Red
Write-Host "  Output: $outputPath" -ForegroundColor Yellow

# Mostrar una pequeña muestra de rutas detectadas (Sample Paths) tal como en tu imagen
Write-Header "Sample paths:"
$samples = $reportLines | Select-Object -First 5
foreach ($s in $samples) {
    if ($null -ne $s) {
        $fInfo = Get-Item $s
        $sizeMb = [math]::Round(($fInfo.Length / 1MB), 2)
        Write-Host "  $s " -NoNewline -ForegroundColor Gray
        Write-Host "($sizeKb MB)" -ForegroundColor Green
    }
}

Write-Host "`nHit up @praiselily if you find any issues" -ForegroundColor Cyan
