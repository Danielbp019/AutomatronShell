Clear-Host

Write-Host "==============================="
Write-Host " Herramientas personales "
Write-Host "==============================="
Write-Host ""
Write-Host "1 - Configurar opciones de seguridad de npm"
Write-Host "2 - Instalar programas (Winget)"
Write-Host "3 - Salir"
Write-Host ""

$option = Read-Host "Selecciona una opcion"

switch ($option) {

    "1" {
        & "$PSScriptRoot\secure-npm.ps1"
    }

    "2" {
        & "$PSScriptRoot\install-apps.ps1"
    }

    "3" {
        exit
    }

    default {
        Write-Host "Opcion invalida" -ForegroundColor Red
        pause
    }
}
