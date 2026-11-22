# Cómo obtener el instalador .exe de Pixel Launcher (Windows)

El `.exe` no se puede generar con un simple doble clic: hay que compilar el proyecto (C++ con Qt 6). La forma más fácil es dejar que **GitHub Actions** lo compile gratis en la nube y descargar el resultado.

## Opción A: compilar con GitHub Actions (recomendada)

### 1. Prepara tu repositorio

1. Crea una cuenta en <https://github.com> si no tienes una.
2. Crea un repositorio **vacío y público** llamado `PixelLauncher` (sin README ni licencia). Público porque así los minutos de compilación son gratis e ilimitados.
3. Instala [Git para Windows](https://git-scm.com/download/win) y abre **Git Bash** dentro de la carpeta del proyecto (la que sale al descomprimir el zip).

### 2. Apunta los enlaces a tu cuenta

```sh
scripts/set-repo.sh TU_USUARIO PixelLauncher
git commit -am "chore: point repository links at my account"
```

### 3. Sube el código

```sh
git remote add origin https://github.com/TU_USUARIO/PixelLauncher.git
git push -u origin main
```

Si Git pide iniciar sesión, usa tu usuario y un [token de acceso personal](https://github.com/settings/tokens) como contraseña.

### 4. Compila

1. En tu repositorio, abre la pestaña **Actions**. Al subir el código, el workflow **Build** arranca solo (compila en modo *Debug*).
2. Para una versión final, entra en **Actions → Build → Run workflow**, elige `build-type: Release` y pulsa **Run workflow**.
3. Espera entre 30 y 90 minutos. Si un job falla, abre su registro y mira el error.

### 5. Descarga el instalador

Al terminar, baja a la sección **Artifacts** de la ejecución y descarga:

| Artifact | Para qué sirve |
| --- | --- |
| `PixelLauncher-Windows-MSVC-Setup-<versión>-<tipo>` | Contiene `PixelLauncher-Setup.exe`, el instalador. Es el recomendado para PCs normales (x64). |
| `PixelLauncher-Windows-MSVC-Portable-<versión>-<tipo>` | Versión portable, sin instalar. |
| `PixelLauncher-Windows-MinGW-w64-Setup-...` | Alternativa si la versión MSVC da problemas. |
| `PixelLauncher-Windows-MSVC-arm64-Setup-...` | Solo para PCs Windows con procesador ARM. |

Descomprime el zip descargado y ejecuta `PixelLauncher-Setup.exe`.

> **Aviso de SmartScreen:** como el instalador no está firmado digitalmente, Windows mostrará "Windows protegió su PC". Pulsa **Más información → Ejecutar de todas formas**. Firmarlo requiere un certificado de pago.

## Opción B: compilar en tu propio PC

Solo si ya tienes experiencia con C++:

1. Instala [Visual Studio 2022](https://visualstudio.microsoft.com/) con la carga de trabajo *Desarrollo para el escritorio con C++*, [CMake](https://cmake.org/download/), [Qt 6](https://www.qt.io/download-qt-installer) (MSVC 2022 64-bit) y [NSIS](https://nsis.sourceforge.io/Download) (para el instalador).
2. Sigue las [instrucciones de compilación de Prism Launcher](https://prismlauncher.org/wiki/development/build-instructions/), que son las mismas que para este proyecto.
3. Desde una consola "x64 Native Tools Command Prompt for VS 2022":

```bat
cmake --preset windows_msvc
cmake --build --preset windows_msvc --config Release
```

(Los nombres exactos de los presets están en `CMakePresets.json`.)

## Antes de publicarlo a otras personas

- **Claves de API:** el proyecto trae claves de Microsoft (login) y CurseForge de Prism/Freesm. Para distribuir tu propia versión debes registrar las tuyas (ver `CMakeLists.txt`, sección *API Keys*). El ID de Ely.by `pixellauncher` tampoco está registrado: si quieres login con Ely.by, regístralo en <https://account.ely.by/dev>.
- **Logo:** los iconos siguen siendo los de Freesm. Reemplaza los archivos de `program_info/` y regenera los demás formatos con `program_info/genicons.sh`.
- **Enlaces de comunidad:** los enlaces a noticias, Discord, Telegram y Reddit (en `CMakeLists.txt`) siguen apuntando a Freesm. Cámbialos por los tuyos o déjalos si no te molestan.
- **Licencia:** el proyecto es GPL-3.0. Si distribuyes el `.exe`, debes ofrecer también el código fuente y mantener los avisos de copyright.
