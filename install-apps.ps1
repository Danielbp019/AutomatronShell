# install-apps.ps1

Write-Host ""
Write-Host "==============================="
Write-Host " Instalacion de programas "
Write-Host "==============================="
Write-Host ""

# Verificar si winget existe
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {

    Write-Host "winget no esta disponible." -ForegroundColor Red
    Write-Host "Intentando registrar App Installer..." -ForegroundColor Cyan
    Write-Host ""

    try {

        Add-AppxPackage `
            -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe `
            -RegisterByFamilyName

        Write-Host "Registro completado." -ForegroundColor Green
        Write-Host ""

        # Refrescar PATH
        $env:Path = [System.Environment]::GetEnvironmentVariable(
            "Path",
            "Machine"
        ) + ";" + [System.Environment]::GetEnvironmentVariable(
            "Path",
            "User"
        )
    }
    catch {

        Write-Host "No fue posible registrar winget." -ForegroundColor Red
        Write-Host ""
        Write-Host "Instala App Installer manualmente:"
        Write-Host "https://aka.ms/GetWinget"
        Write-Host ""

        Write-Host "Presiona cualquier tecla para cerrar..."
        [void][System.Console]::ReadKey($true)

        exit
    }

    # Verificar nuevamente
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {

        Write-Host "winget sigue sin estar disponible." -ForegroundColor Red
        Write-Host ""

        Write-Host "Instala App Installer manualmente:"
        Write-Host "https://aka.ms/GetWinget"
        Write-Host ""

        Write-Host "Presiona cualquier tecla para cerrar..."
        [void][System.Console]::ReadKey($true)

        exit
    }
}

$appsFile = Join-Path $PSScriptRoot "apps.txt"

if (-not (Test-Path $appsFile)) {

    Write-Host "No se encontro apps.txt" -ForegroundColor Red
    Write-Host ""

    Write-Host "Presiona cualquier tecla para cerrar..."
    [void][System.Console]::ReadKey($true)

    exit
}

$apps = Get-Content $appsFile

foreach ($app in $apps) {

    if ([string]::IsNullOrWhiteSpace($app)) {
        continue
    }

    Write-Host ""

    # Verificar si ya esta instalado
    $installed = winget list --id $app -e

    if ($installed -match $app) {

        Write-Host "Ya instalado: $app" -ForegroundColor Yellow
        continue
    }

    Write-Host "Instalando: $app" -ForegroundColor Cyan

    winget install --id $app -e --silent `
        --accept-package-agreements `
        --accept-source-agreements
}

Write-Host ""
Write-Host "--------------------------------"
Write-Host ""
Write-Host "Proceso terminado." -ForegroundColor Green
Write-Host ""
Write-Host "Presiona cualquier tecla para cerrar..."

# Esperar tecla
[void][System.Console]::ReadKey($true)
