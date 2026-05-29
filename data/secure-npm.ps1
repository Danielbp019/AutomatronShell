# secure-npm.ps1
# Configura opciones de seguridad en ~/.npmrc
# - Reemplaza claves existentes
# - Agrega claves faltantes
# - Evita líneas duplicadas
# - Conserva configuraciones existentes

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

$npmrc = Join-Path $HOME ".npmrc"

Write-Host "================================"
Write-Host " Configuracion de seguridad npm "
Write-Host " Archivo: $npmrc"
Write-Host "================================"
Write-Host ""

# Configuración deseada
$config = @{
    "save-exact"     = "true"
    "ignore-scripts" = "true"
    "min-release-age" = "7"
}

# Crear archivo si no existe
if (-not (Test-Path $npmrc)) {
    New-Item -Path $npmrc -ItemType File -Force | Out-Null
    Write-Host "Archivo .npmrc creado." -ForegroundColor Green
}

# Leer contenido existente
$lines = Get-Content $npmrc -ErrorAction SilentlyContinue

# Diccionario para controlar claves procesadas
$processed = @{}

# Lista final de líneas
$newLines = New-Object System.Collections.Generic.List[string]

foreach ($line in $lines) {

    $trimmed = $line.Trim()

    # Detectar líneas tipo clave=valor
    if ($trimmed -match '^\s*([^#;][^=]*)=(.*)$') {

        $key = $matches[1].Trim()

        # Si la clave pertenece a la configuración deseada
        if ($config.ContainsKey($key)) {

            # Evitar duplicados
            if (-not $processed.ContainsKey($key)) {

                $newValue = "$key=$($config[$key])"

                $newLines.Add($newValue)

                if ($trimmed -eq $newValue) {
                    Write-Host "Ya estaba correcto: $newValue" -ForegroundColor Yellow
                }
                else {
                    Write-Host "Actualizado: $trimmed  ->  $newValue" -ForegroundColor Cyan
                }

                $processed[$key] = $true
            }

            # Saltar línea original
            continue
        }
    }

    # Mantener líneas no relacionadas
    $newLines.Add($line)
}

# Agregar claves faltantes
foreach ($key in $config.Keys) {

    if (-not $processed.ContainsKey($key)) {

        $newValue = "$key=$($config[$key])"

        $newLines.Add($newValue)

        Write-Host "Agregado: $newValue" -ForegroundColor Green
    }
}

# Guardar archivo actualizado
$newLines | Set-Content $npmrc -Encoding UTF8

Write-Host ""
Write-Host "================================"
Write-Host " Configuracion aplicada correctamente " -ForegroundColor Green
Write-Host "================================"

Write-Host ""
Write-Host "Contenido final del .npmrc:"
Write-Host "--------------------------------"

Get-Content $npmrc | ForEach-Object {
    Write-Host $_
}

Write-Host "--------------------------------"
Write-Host ""
Write-Host "Presiona cualquier tecla para volver al menu..."

# Esperar tecla
[void][System.Console]::ReadKey($true)
