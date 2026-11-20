# Lab DevOps en Vivo · iPower26 · Bogotá · Nov 2026

## Resumen
Demo en vivo de un flujo DevOps completo en IBM i:
requerimiento del auditor → código → pruebas automatizadas → pipeline CI/CD → PR con evidencia.

---

## Estado del lab antes de la demo

| Componente | Estado |
|---|---|
| Rama Git | `feat/log-add-pgmname` desde commit `360034e` |
| `LOG300.RPGLE` | Sin `pgmName` — punto de partida |
| `qtestsrc/` | Sin tests |
| IBM i `LOG300.MODULE` | Compilado sin `pgmName` |
| IBM i `LOG300T.*` | No existe |
| Runner self-hosted | Activo en Mac |

---

## Guión paso a paso

### Prompt 1 — El requerimiento
```
"El auditor de SAMCO necesita que el log registre el programa
de origen en cada entrada"
```
Bob explica el cambio necesario y pide confirmación.

---

### Prompt 2 — Modificar LOG300.RPGLE
```
"si"
```
Bob agrega `pgmName` como parámetro opcional a `AddLogEntry`.

Cambios en `SAMCO/QRPGLESRC/LOG300.RPGLE`:
- Nueva línea: `d pgmName  10  value options(*nopass)`
- Variable local `wPgmName`
- Lógica `if %parms() >= 2`
- Log incluye `Pgm: ORD200 *` cuando se pasa el nombre

---

### Prompt 3 — Actualizar el prototipo
```
"si"
```
Bob actualiza `SAMCO/QPROTOSRC/LOG_functions.RPGLEINC`
con la nueva firma para que todos los compiladores la conozcan.

---

### Prompt 4 — Crear pruebas RPGUnit
```
"crea la suite de pruebas con rpgunit"
```
Bob crea 6 archivos:

| Archivo | Propósito |
|---|---|
| `qtestsrc/LOG300T.RPGLE` | 6 pruebas + setUp |
| `qtestsrc/Rules.mk` | makei sabe qué compilar |
| `qtestsrc/LOG300T.ILESRVPGM` | Enlace con LOG y RPGUnit |
| `qtestsrc/.ibmi.json` | CCSID 37, RPGUNIT en liblist |
| `SAMCO/Rules.mk` | qtestsrc agregado a SUBDIRS |
| `SAMCO/iproj.json` | RPGUNIT en preUsrlibl |

**6 casos de prueba:**
1. `test_addLogEntry_normal` — mensaje normal
2. `test_addLogEntry_empty` — mensaje vacío
3. `test_addLogEntry_maxLen` — 500 caracteres
4. `test_addLogEntry_conPgmName` — con pgmName ← **nueva feature**
5. `test_addLogEntry_sinPgmName` — sin pgmName (compatibilidad)
6. `test_addLogEntry_pgmNameVacio` — pgmName vacío

---

### Prompt 5 — Actualizar el pipeline
```
"si"
```
Bob modifica `.github/workflows/build.yml`:
- `rsync --checksum` + `rm+cp` para evitar caché IFS
- Paso 3: `RPGUNIT/RUCALLTST` en lugar de verificación manual

---

### Prompt 6 — Commit y push
```
"si"
```
Bob hace:
```bash
git add .
git commit -m "feat(log300): AddLogEntry pgmName + RPGUnit 6 pruebas"
git push origin feat/log-add-pgmname
```

---

### Paso final — Abrir PR en GitHub
URL: https://github.com/cdsamericas1/CDS01/compare/main...feat/log-add-pgmname

Pipeline se dispara automáticamente:
1. Copiar fuentes al IFS
2. `makei build` → compila LOG300 + LOG300T
3. `RUCALLTST` → 6/6 pruebas verdes

Resultado: `CPDA0FF: Success. 6 test cases, 6 assertions, 0 failure, 0 error.`

PR → **All checks passed** → **Merge**

---

## Comandos de reset

```bash
# En Bob: "haz el reset"
# O manualmente:
cd ~/Downloads/rpg-roadshow/bob-rpg-ibm-i-main
git checkout main
git branch -D feat/log-add-pgmname
git checkout -b feat/log-add-pgmname   # desde 360034e
git push origin feat/log-add-pgmname --force
```

IBM i (via QSH):
```
system "DLTMOD MODULE(OSWLABBOB/LOG300T)"
system "DLTSRVPGM SRVPGM(OSWLABBOB/LOG300T)"
system "DLTUSRSPC USRSPC(OSWLABBOB/SAMLOG)"
system "RMVM FILE(OSWLABBOB/EVFEVENT) MBR(LOG300T)"
```

---

## Lecciones aprendidas (resumen)

| # | Problema | Solución |
|---|---|---|
| 1 | IFS guarda inodo viejo al hacer rsync | `rm + cp` del fuente antes de compilar |
| 2 | `/include` con CCSID 273 falla | Prototipos `DCL-PR` inline, sin `/include` |
| 3 | evfevent antiguo enmascara errores | `RMVM FILE(LIB/EVFEVENT) MBR(X)` |
| 4 | `*JOBRUN` no funciona vía `system()` PASE | `"tgtCcsid": "37"` en `.ibmi.json` |
| 5 | `RPGUNIT.SRVPGM` no existe en v6 | `RUTESTCASE` + `RUMEMMGR` |
| 6 | SAMLOG no inicializado → MCH3601 | `setUp` con `QUSCRTUS *YES` + `samlogPos = 7` |

---

## Infraestructura

- **IBM i**: `10.0.0.2`, usuario `oswaldo`, SSH key `~/.ssh/ibmi_actions`
- **Librería**: `OSWLABBOB`
- **IFS build dir**: `/home/OSWALDO/builds/samco`
- **RPGUnit**: v6.0.11.r en librería `RPGUNIT`
- **Runner**: `~/actions-runner` (self-hosted, Mac)
- **Repo**: `https://github.com/cdsamericas1/CDS01`
