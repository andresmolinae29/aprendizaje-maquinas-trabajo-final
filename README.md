# aprendizaje-maquinas-trabajo-final

Proyecto de aprendizaje de maquinas en Python con entorno reproducible usando `uv`, notebooks de Jupyter y un script de arranque para preparar el entorno y descargar los datos.

## Requisitos

- Python 3.10 o superior
- Git
- Bash o PowerShell

En Windows puedes usar `scripts/bootstrap.ps1` desde PowerShell. Si prefieres Bash, puedes seguir usando `scripts/bootstrap.sh` desde Git Bash o WSL.

## Arranque rapido

El proyecto incluye un script que:

- instala `uv` si no existe
- inicializa el proyecto solo si faltara `pyproject.toml`
- sincroniza dependencias desde `pyproject.toml` y `uv.lock`
- ejecuta `main.py` para preparar o descargar los datos

Ejecuta:

```bash
bash scripts/bootstrap.sh
```

En Windows, la opcion nativa es:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\bootstrap.ps1
```

Si `main.py` necesita credenciales de Kaggle, sigue el prompt en terminal.

## Flujo manual con uv

Si prefieres hacerlo paso a paso:

```bash
uv sync
uv run python main.py
```

`uv sync` crea o actualiza `.venv` usando lo declarado en `pyproject.toml` y fijado en `uv.lock`.

## Como agregar dependencias

Para agregar una dependencia normal al proyecto:

```bash
uv add pandas
```

Para agregar una dependencia de desarrollo:

```bash
uv add --dev pytest
```

Para agregar paquetes de PyTorch desde el indice CUDA usado por este proyecto:

```bash
uv add torch torchvision --index https://download.pytorch.org/whl/cu130
```

Despues de agregar dependencias, sincroniza el entorno si hace falta:

```bash
uv sync
```

## Como seleccionar el entorno correcto en cada notebook

1. Abre el notebook en VS Code.
2. Haz clic en el selector de kernel en la esquina superior derecha.
3. Elige `Python (aprendizaje-maquinas-trabajo-final)`.
4. Si no aparece, ejecuta primero el comando de `ipykernel install` indicado arriba.
5. Verifica en una celda que el kernel usa el entorno del proyecto:

```python
import sys
print(sys.executable)
```

La ruta debe apuntar al `.venv` de este repositorio.

## Estructura minima del flujo

- `main.py`: punto de entrada para preparar o descargar datos
- `src/`: logica de soporte
- `notebooks/`: notebooks del proyecto
- `data/`: datos descargados o preparados localmente