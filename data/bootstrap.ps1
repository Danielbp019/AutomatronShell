# bootstrap.ps1
# Descarga AutomatronShell desde GitHub, lo ejecuta y se limpia solo

if ($Host.Name -eq "ConsoleHost") {
    $WindowSize = $Host.UI.RawUI.WindowSize
    $WindowSize.Width = 100
    $WindowSize.Height = 30
    $Host.UI.RawUI.WindowSize = $WindowSize
    $BufferSize = $Host.UI.RawUI.BufferSize
    $BufferSize.Width = 100
    $Host.UI.RawUI.BufferSize = $BufferSize
}

Clear-Host

Write-Host ""
Write-Host "==============================="
Write-Host " AutomatronShell - Bootstrap   "
Write-Host "==============================="
Write-Host ""
Write-Host "Descargando AutomatronShell desde GitHub..." -ForegroundColor Cyan
Write-Host ""

$repoUrl = "https://github.com/Danielbp019/AutomatronShell/archive/refs/heads/main.zip"
$zipPath = Join-Path $env:TEMP "automatron.zip"
$extractPath = Join-Path $env:TEMP "automatron-shell"

try {
    Write-Host "Descargando ZIP..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri $repoUrl -OutFile $zipPath -ErrorAction Stop

    Write-Host "Extrayendo archivos..." -ForegroundColor Cyan
    if (Test-Path $extractPath) {
        Remove-Item -Path $extractPath -Recurse -Force
    }
    Expand-Archive -Path $zipPath -DestinationPath $extractPath -Force

    $menuPath = Join-Path $extractPath "AutomatronShell-main\menu.ps1"

    if (-not (Test-Path $menuPath)) {
        Write-Host "Error: No se encontro menu.ps1 en el ZIP." -ForegroundColor Red
        Write-Host "Presiona cualquier tecla para salir..."
        [void][System.Console]::ReadKey($true)
        exit
    }

    Write-Host ""
    Write-Host "Descarga completada. Iniciando menu..." -ForegroundColor Green
    Write-Host ""

    & $menuPath
}
catch {
    Write-Host ""
    Write-Host "Error durante la descarga o ejecucion:" -ForegroundColor Red
    Write-Host " $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "Presiona cualquier tecla para salir..."
    [void][System.Console]::ReadKey($true)
}
finally {
    Write-Host ""
    Write-Host "Limpiando archivos temporales..." -ForegroundColor Yellow

    if (Test-Path $zipPath) {
        Remove-Item -Path $zipPath -Force
    }
    if (Test-Path $extractPath) {
        Remove-Item -Path $extractPath -Recurse -Force
    }

    Start-Sleep -Milliseconds 500
}
