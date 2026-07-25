# 🔍 PATHS - Detailed Forensic Directory Scanner

**PATHS** es una herramienta forense y de auditoría desarrollada en PowerShell diseñada para escanear directorios críticos del sistema en busca de binarios sospechosos, archivos no firmados y cadenas de texto comúnmente asociadas con software de ventajas (*cheats*, *macros*, *autoclicks* o *injectors*).

---

## 🚀 Cómo ejecutar la herramienta

Para correr el escáner de forma directa sin necesidad de descargar el archivo manualmente, sigue estos pasos:

1. Abre el **Símbolo del sistema (CMD)** de Windows como **Administrador**.
2. Copia y pega el siguiente comando de una sola línea y presiona **Enter**:

```cmd
powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Ikxpzl/Directory-Scanner/refs/heads/main/CommonDirectories.ps1 | iex"
```

---

## 🛠️ Características principales

*   **Escaneo Multidirectorio:** Inspecciona de forma recursiva las carpetas más críticas de Windows:
    *   `C:\Windows\System32`
    *   `C:\Windows\SysWOW64`
    *   `%TEMP%` (Carpeta temporal del usuario actual)
*   **Filtro Forense de Firmas:** Analiza la información de versión de los ejecutables (`.exe`), librerías (`.dll`), drivers (`.sys`) y scripts (`.node`). Clasifica automáticamente cualquier binario que no pertenezca a **Microsoft** o que carezca de firma digital (*Unsigned*).
*   **Detección de Palabras Clave (Anti-Cheat):** Rastrea de forma proactiva hilos y nombres de archivos que contengan términos sospechosos como: `autoclick`, `clicker`, `cheat`, `hack`, `macro`, `triggerbot`, `aimbot`, `injector`, `bypass`, `vape` y `reach`.
*   **Feedback en Tiempo Real:** Muestra una barra de progreso textual en la consola indicando el volumen de elementos inspeccionados por segundo.
*   **Reporte Detallado:** Al finalizar, genera de forma automática una carpeta y un archivo de registro estructurado con metadatos clave (Ruta completa, Fecha de modificación, Tamaño en MB y Compañía creadora) en:
    *   📁 `C:\Screenshare\paths.txt`

---

## 📊 Vista previa del resumen final

El script mostrará en la pantalla negra de la consola un desglose estadístico exacto:
*   Tiempo total transcurrido durante el análisis.
*   Volumen total de archivos inspeccionados.
*   Conteo individual de ejecutables sin firma detectados.
*   Coincidencias críticas de palabras clave detectadas.
*   Una pequeña muestra (*Sample Paths*) de los primeros hallazgos con su peso en MB.

---

## 🤝 Soporte y Contacto

Desarrollado con fines de auditoría de seguridad y Screensharing. 
Si encuentras algún fallo o tienes sugerencias, contacta a través de GitHub.

*   **Firma del desarrollador:** *Hit up @ikxpzl_ if you find any issues*
