$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = Split-Path -Parent $ScriptDir

function Test-UvInstalled {
    return $null -ne (Get-Command uv -ErrorAction SilentlyContinue)
}

function Install-UvIfNeeded {
    if (Test-UvInstalled) {
        return
    }

    Write-Host "uv no esta instalado. Instalando..."
    Invoke-RestMethod https://astral.sh/uv/install.ps1 | Invoke-Expression

    $userLocalBin = Join-Path $HOME ".local\bin"
    $userCargoBin = Join-Path $HOME ".cargo\bin"

    foreach ($pathEntry in @($userLocalBin, $userCargoBin)) {
        if ((Test-Path $pathEntry) -and -not (($env:PATH -split ';') -contains $pathEntry)) {
            $env:PATH = "$pathEntry;$env:PATH"
        }
    }

    if (-not (Test-UvInstalled)) {
        throw "uv se instalo, pero no quedo disponible en PATH para esta sesion. Abre una nueva terminal y vuelve a ejecutar este script."
    }
}

Install-UvIfNeeded

Set-Location $ProjectRoot

if (-not (Test-Path "pyproject.toml")) {
    Write-Host "No se encontro pyproject.toml. Inicializando proyecto con uv..."
    uv init --name aprendizaje-maquinas-trabajo-final
}

Write-Host "Sincronizando dependencias del proyecto..."
uv sync

Write-Host "Ejecutando descarga/preparacion de datos..."
uv run python main.py

Write-Host "Proceso completado."