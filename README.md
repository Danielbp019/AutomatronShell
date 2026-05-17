# Automaton Shell - Automatizar reinstalación

Script de PowerShell para aplicar configuraciones de seguridad recomendadas en `npm` y usar Winget con ajustes personales mediante un menú simple en consola.

# Cómo ejecutar

El programa principal es:

```powershell
menu.ps1
```

Ejecutar desde PowerShell:

```powershell
powershell -ExecutionPolicy Bypass -File .\menu.ps1
```

El menú permite:

```text
1 - Configurar opciones de seguridad de npm
2 - Instalar programas (Winget)
3 - Salir
```

# Estructura del proyecto

```text
scripts/
│
├── menu.ps1
├── secure-npm.ps1
├── install-apps.ps1
└── apps.txt
```

# Funcionalidades

## secure-npm.ps1

Aplica configuraciones de seguridad recomendadas en `npm`.

El script:

- Crea `~/.npmrc` si no existe
- Reemplaza configuraciones existentes
- Evita líneas duplicadas
- Conserva configuraciones no relacionadas
- Agrega opciones faltantes automáticamente

## Configuraciones aplicadas en npm

El script configura las siguientes opciones:

```ini
save-exact=true
ignore-scripts=true
min-release-age=7
```

## Objetivo

Este menú busca simplificar tareas comunes de configuración y endurecimiento del entorno Windows y `npm`, reduciendo riesgos relacionados con:

- Dependencias maliciosas
- Versiones cambiantes inesperadas
- Ejecución automática de scripts durante instalación
- Publicación prematura de paquetes potencialmente inseguros
- Configuración manual repetitiva después de formatear Windows

## install-apps.ps1

Instala automáticamente programas mediante `winget` usando una lista personalizada definida en `apps.txt`. Se puede editar la lista, simplemente poniendo el ID del programa que maneja winget.

Ejemplo:

```text
7zip.7zip
AIMP.AIMP
OpenJS.NodeJS.LTS
flux.flux
Microsoft.VisualStudioCode
GitHub.GitHubDesktop
```

Cada línea representa el identificador oficial del paquete en `winget`.

## Objetivo

Este menú busca automatizar la instalación de mis programas cuando formatee mi PC.

# Requisitos

- Windows 10 o superior
- PowerShell
- `winget` instalado y disponible en PATH
- Permisos normales de usuario (algunas instalaciones pueden requerir administrador)

# Notas

- Los scripts individuales esperan una tecla antes de cerrarse para poder revisar el resultado.
- El menú principal se cierra inmediatamente al seleccionar `Salir`.
- Las aplicaciones instaladas se pueden modificar simplemente editando `apps.txt`.
