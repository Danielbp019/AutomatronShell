# AutomatronShell — Guía para Agentes

## Descripción del proyecto

Scripts de PowerShell para automatizar configuraciones post-formateo en Windows 10/11. Todo comienza desde `menu.ps1`.

## Cómo ejecutar

```powershell
powershell -ExecutionPolicy Bypass -File .\menu.ps1
```

## Estructura del proyecto

```
AutomatronShell/
├── menu.ps1            ← Punto de entrada único
├── README.md           ← Manual de uso del proyecto
├── AGENTS.md           ← Esta guía
└── data/
    ├── secure-npm.ps1  ← Seguridad npm
    ├── install-apps.ps1 ← Instalar programas con winget
    ├── clear-logs.ps1  ← Limpiar Event Viewer
    ├── bootstrap.ps1   ← Descarga y ejecuta desde GitHub
    └── apps.txt        ← Lista de IDs winget
```

## Flujo de trabajo

1. Todo comienza en `menu.ps1`
2. El usuario selecciona una opción → se ejecuta el script en `data/`
3. Al terminar, el script espera una tecla y regresa a `menu.ps1`

Para agregar una nueva funcionalidad:
- Crear el script en `data/` (ej: `data/mi-script.ps1`)
- Agregar la opción en el `switch` de `menu.ps1`
- Documentar en `README.md`

## Convenciones de código

### Tamaño de ventana
Siempre al inicio del script:
```powershell
if ($Host.Name -eq "ConsoleHost") {
    $WindowSize = $Host.UI.RawUI.WindowSize
    $WindowSize.Width = 100
    $WindowSize.Height = 30
    $Host.UI.RawUI.WindowSize = $WindowSize
    $BufferSize = $Host.UI.RawUI.BufferSize
    $BufferSize.Width = 100
    $Host.UI.RawUI.BufferSize = $BufferSize
}
```

### Colores (progreso y estado)
- `Green` → operación exitosa, completada, agregado nuevo
- `Yellow` → advertencia, ya existente, elevación de permisos
- `Cyan` → acción en progreso, instalando, actualizando
- `Red` → error, opción inválida, fallo

### Encabezados
```powershell
Write-Host ""
Write-Host "==============================="
Write-Host " Titulo descriptivo "
Write-Host "==============================="
Write-Host ""
```

### Pausa para ver resultados
Siempre al final del script, antes de volver a `menu.ps1`:
```powershell
Write-Host ""
Write-Host "Presiona cualquier tecla para volver al menu..."
[void][System.Console]::ReadKey($true)
```

### Manejo de errores
- Usar `try/catch` para operaciones que pueden fallar
- Mostrar errores con `-ForegroundColor Red`
- Usar `-ErrorAction SilentlyContinue` en comprobaciones previas
- Si no se puede continuar, mostrar mensaje claro y regresar al menú

### Documentación
- Cada vez que se modifique o agregue algo al proyecto, actualizar `README.md`
- El README es el manual de uso del proyecto
- Los scripts deben incluir comentarios describiendo qué hacen
