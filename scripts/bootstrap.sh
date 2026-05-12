#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

install_uv() {
  if command -v uv >/dev/null 2>&1; then
    return
  fi

  echo "uv no esta instalado. Instalando..."

  if command -v curl >/dev/null 2>&1; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
  elif command -v powershell.exe >/dev/null 2>&1; then
    powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "irm https://astral.sh/uv/install.ps1 | iex"
  else
    echo "No se encontro curl ni powershell.exe para instalar uv automaticamente."
    echo "Instalalo manualmente desde https://docs.astral.sh/uv/getting-started/installation/"
    exit 1
  fi

  export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

  if ! command -v uv >/dev/null 2>&1; then
    echo "uv se instalo, pero no quedo disponible en PATH para esta sesion."
    echo "Abre una nueva terminal y vuelve a ejecutar este script."
    exit 1
  fi
}

install_uv

cd "$PROJECT_ROOT"

if [ ! -f "pyproject.toml" ]; then
  echo "No se encontro pyproject.toml. Inicializando proyecto con uv..."
  uv init --name aprendizaje-maquinas-trabajo-final
fi

echo "Sincronizando dependencias del proyecto..."
uv sync

echo "Ejecutando descarga/preparacion de datos..."
uv run python main.py

echo "Proceso completado."