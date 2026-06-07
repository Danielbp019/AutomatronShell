# Configurar tamaño de ventana estándar al iniciar
if ($Host.Name -eq "ConsoleHost") {
    $WindowSize = $Host.UI.RawUI.WindowSize
    $WindowSize.Width = 100
    $WindowSize.Height = 30
    $Host.UI.RawUI.WindowSize = $WindowSize
    
    $BufferSize = $Host.UI.RawUI.BufferSize
    $BufferSize.Width = 100
    $Host.UI.RawUI.BufferSize = $BufferSize
}

do {
    Clear-Host

    Write-Host "==============================="
    Write-Host " Automatron Shell - Herramientas personales "
    Write-Host "==============================="
    Write-Host ""
    Write-Host "1 - Configurar opciones de seguridad de npm"
    Write-Host "2 - Instalar programas (Winget)"
    Write-Host "3 - Limpiar logs del visor de eventos"
    Write-Host "4 - Configurar Windows (DNS, nombre del equipo)"
    Write-Host "5 - Salir"
    Write-Host ""

    $option = Read-Host "Selecciona una opcion"

    switch ($option) {

        "1" {
            & "$PSScriptRoot\data\secure-npm.ps1"
        }

        "2" {
            & "$PSScriptRoot\data\install-apps.ps1"
        }

        "3" {
            & "$PSScriptRoot\data\clear-logs.ps1"
        }

        "4" {
            & "$PSScriptRoot\data\windows-config.ps1"
        }

        "5" {
            exit
        }

        default {
            Write-Host "Opcion invalida" -ForegroundColor Red
            Start-Sleep -Seconds 2
        }
    }
} while ($true)
