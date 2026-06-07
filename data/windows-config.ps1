# windows-config.ps1
# Configuracion de red (DNS) y nombre del equipo

if ($Host.Name -eq "ConsoleHost") {
    $WindowSize = $Host.UI.RawUI.WindowSize
    $WindowSize.Width = 100
    $WindowSize.Height = 30
    $Host.UI.RawUI.WindowSize = $WindowSize
    $BufferSize = $Host.UI.RawUI.BufferSize
    $BufferSize.Width = 100
    $Host.UI.RawUI.BufferSize = $BufferSize
}

function Show-Menu {
    Clear-Host
    Write-Host ""
    Write-Host "==============================="
    Write-Host " Configuracion de Windows "
    Write-Host "==============================="
    Write-Host ""
    Write-Host "1 - Cambiar DNS (Google)"
    Write-Host "2 - Cambiar DNS (Cloudflare)"
    Write-Host "3 - Restaurar DNS automatico"
    Write-Host "4 - Cambiar nombre del equipo"
    Write-Host "5 - Volver al menu principal"
    Write-Host ""
}

function Get-ActiveAdapter {
    try {
        $adapter = Get-NetAdapter | Where-Object { $_.Status -eq "Up" -and $_.Virtual -ne $true } | Select-Object -First 1
        return $adapter
    }
    catch {
        return $null
    }
}

function Set-DNSGoogle {
    Write-Host ""
    Write-Host "Configurando DNS de Google..." -ForegroundColor Cyan

    $adapter = Get-ActiveAdapter
    if (-not $adapter) {
        Write-Host "No se detecto un adaptador de red activo." -ForegroundColor Red
        return
    }

    try {
        Set-DnsClientServerAddress -InterfaceIndex $adapter.InterfaceIndex -ServerAddresses @(
            "8.8.8.8",
            "8.8.4.4",
            "2001:4860:4860::8888",
            "2001:4860:4860::8844"
        ) -ErrorAction Stop
        Write-Host "DNS actualizados correctamente a Google." -ForegroundColor Green
    }
    catch {
        Write-Host "Error al configurar DNS:" -ForegroundColor Red
        Write-Host " $_" -ForegroundColor Red
    }
}

function Set-DNSCloudflare {
    Write-Host ""
    Write-Host "Configurando DNS de Cloudflare..." -ForegroundColor Cyan

    $adapter = Get-ActiveAdapter
    if (-not $adapter) {
        Write-Host "No se detecto un adaptador de red activo." -ForegroundColor Red
        return
    }

    try {
        Set-DnsClientServerAddress -InterfaceIndex $adapter.InterfaceIndex -ServerAddresses @(
            "1.1.1.1",
            "1.0.0.1",
            "2606:4700:4700::1111",
            "2606:4700:4700::1001"
        ) -ErrorAction Stop
        Write-Host "DNS actualizados correctamente a Cloudflare." -ForegroundColor Green
    }
    catch {
        Write-Host "Error al configurar DNS:" -ForegroundColor Red
        Write-Host " $_" -ForegroundColor Red
    }
}

function Reset-DNS {
    Write-Host ""
    Write-Host "Restaurando DNS automatico (DHCP)..." -ForegroundColor Cyan

    $adapter = Get-ActiveAdapter
    if (-not $adapter) {
        Write-Host "No se detecto un adaptador de red activo." -ForegroundColor Red
        return
    }

    try {
        Set-DnsClientServerAddress -InterfaceIndex $adapter.InterfaceIndex -ResetServerAddresses -ErrorAction Stop
        Write-Host "DNS restaurados a DHCP correctamente." -ForegroundColor Green
    }
    catch {
        Write-Host "Error al restaurar DNS:" -ForegroundColor Red
        Write-Host " $_" -ForegroundColor Red
    }
}

function Set-ComputerName {
    Write-Host ""
    Write-Host "Nombre actual del equipo: " -NoNewline
    Write-Host "$env:COMPUTERNAME" -ForegroundColor Cyan
    Write-Host ""

    $newName = Read-Host "Ingresa el nuevo nombre"

    if ([string]::IsNullOrWhiteSpace($newName)) {
        Write-Host "El nombre no puede estar vacio." -ForegroundColor Red
        return
    }

    if ($newName -match '[<>:"/\\|?*]') {
        Write-Host "El nombre contiene caracteres no validos: < > : `" / \\ | ? *" -ForegroundColor Red
        return
    }

    if ($newName.Length -gt 15) {
        Write-Host "El nombre no puede tener mas de 15 caracteres." -ForegroundColor Red
        return
    }

    try {
        Rename-Computer -NewName $newName -Force -ErrorAction Stop
        Write-Host ""
        Write-Host "Nombre cambiado a: " -NoNewline
        Write-Host "$newName" -ForegroundColor Green
        Write-Host ""
        Write-Host "EL EQUIPO SE REINICIARA PARA APLICAR LOS CAMBIOS." -ForegroundColor Yellow
        Write-Host ""
        Write-Host "Presiona cualquier tecla para reiniciar ahora..."
        [void][System.Console]::ReadKey($true)
        Write-Host ""
        Write-Host "Reiniciando en 10 segundos..." -ForegroundColor Cyan
        Start-Sleep -Seconds 10
        Restart-Computer -Force
    }
    catch {
        Write-Host "Error al cambiar el nombre del equipo:" -ForegroundColor Red
        Write-Host " $_" -ForegroundColor Red
    }
}

$elevated = $false
$isAdmin = [Security.Principal.WindowsPrincipal]::new(
    [Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

do {
    Show-Menu
    $option = Read-Host "Selecciona una opcion"

    switch ($option) {

        "1" {
            Clear-Host
            Write-Host ""
            Write-Host "==============================="
            Write-Host " DNS de Google "
            Write-Host "==============================="
            Write-Host ""

            if (-not $isAdmin) {
                Write-Host "Se requieren permisos de administrador." -ForegroundColor Yellow
                Write-Host "Volviendo al menu..." -ForegroundColor Yellow
                Start-Sleep -Seconds 2
            }
            else {
                Set-DNSGoogle
            }

            Write-Host ""
            Write-Host "Presiona cualquier tecla para volver al menu..."
            [void][System.Console]::ReadKey($true)
        }

        "2" {
            Clear-Host
            Write-Host ""
            Write-Host "==============================="
            Write-Host " DNS de Cloudflare "
            Write-Host "==============================="
            Write-Host ""

            if (-not $isAdmin) {
                Write-Host "Se requieren permisos de administrador." -ForegroundColor Yellow
                Write-Host "Volviendo al menu..." -ForegroundColor Yellow
                Start-Sleep -Seconds 2
            }
            else {
                Set-DNSCloudflare
            }

            Write-Host ""
            Write-Host "Presiona cualquier tecla para volver al menu..."
            [void][System.Console]::ReadKey($true)
        }

        "3" {
            Clear-Host
            Write-Host ""
            Write-Host "==============================="
            Write-Host " Restaurar DNS "
            Write-Host "==============================="
            Write-Host ""

            if (-not $isAdmin) {
                Write-Host "Se requieren permisos de administrador." -ForegroundColor Yellow
                Write-Host "Volviendo al menu..." -ForegroundColor Yellow
                Start-Sleep -Seconds 2
            }
            else {
                Reset-DNS
            }

            Write-Host ""
            Write-Host "Presiona cualquier tecla para volver al menu..."
            [void][System.Console]::ReadKey($true)
        }

        "4" {
            Clear-Host
            Write-Host ""
            Write-Host "==============================="
            Write-Host " Cambiar nombre del equipo "
            Write-Host "==============================="
            Write-Host ""

            if (-not $isAdmin) {
                Write-Host "Se requieren permisos de administrador." -ForegroundColor Yellow
                Write-Host "Volviendo al menu..." -ForegroundColor Yellow
                Start-Sleep -Seconds 2
            }
            else {
                Set-ComputerName
            }

            if ($isAdmin) {
                Write-Host ""
                Write-Host "Presiona cualquier tecla para volver al menu..."
                [void][System.Console]::ReadKey($true)
            }
        }

        "5" {
            return
        }

        default {
            Write-Host "Opcion invalida" -ForegroundColor Red
            Start-Sleep -Seconds 2
        }
    }
} while ($true)
