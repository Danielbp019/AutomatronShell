# clear-logs.ps1
# Limpia los logs del visor de eventos de Windows
# - Application -> eventos de aplicaciones
# - System -> eventos del sistema

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
Write-Host "   Limpieza de Event Logs      "
Write-Host "==============================="
Write-Host ""

# Verificar permisos de administrador
$isAdmin = [Security.Principal.WindowsPrincipal]::new(
    [Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {

    try {
        Write-Host "No tienes permisos de administrador. Elevando privilegios..." -ForegroundColor Yellow
        Start-Process powershell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Wait -ErrorAction Stop
    }
    catch {
        Write-Host "Elevacion cancelada. Volviendo al menu..." -ForegroundColor Yellow
        Start-Sleep -Milliseconds 800
    }

    # Restaurar foco a la ventana del menú
    if (-not ([System.Management.Automation.PSTypeName]'WinFocus').Type) {
        Add-Type @"
    using System;
    using System.Runtime.InteropServices;
    public class WinFocus {
    [DllImport("user32.dll")]
    public static extern bool SetForegroundWindow(IntPtr hWnd);
}
"@
    }
    $null = [WinFocus]::SetForegroundWindow((Get-Process -Id $pid).MainWindowHandle)

    return
}

# Lista de logs a limpiar
$logs = @("Application", "System")
$ok = 0
$fail = 0

foreach ($log in $logs) {

    Write-Host "Limpiando: $log ..." -NoNewline

    try {
        wevtutil cl $log *>$null
        Write-Host " OK" -ForegroundColor Green
        $ok++
    }
    catch {
        Write-Host " ERROR" -ForegroundColor Red
        Write-Host "  $_" -ForegroundColor Red
        $fail++
    }
}

Write-Host ""
Write-Host "==============================="
Write-Host " Resumen"
Write-Host "------------------------------"

if ($fail -eq 0) {
    Write-Host " Limpiados correctamente: $ok" -ForegroundColor Green
}
else {
    Write-Host " Limpiados correctamente: $ok" -ForegroundColor Green
    Write-Host " Fallaron:                $fail" -ForegroundColor Red
}

Write-Host "==============================="
Write-Host ""
Write-Host "Presiona cualquier tecla para volver al menu..."

[void][System.Console]::ReadKey($true)
