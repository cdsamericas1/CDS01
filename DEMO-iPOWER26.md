# Demo iPOWER26 · DevOps en IBM i con Bob

Todo corre en la red local y se graba en video. En la charla se proyecta el video y se narra en vivo.

Flujo: **Entender → Modernizar → Probar → Versionar → Integrar → Aprobar**

---

## Fase A · Preparación (una sola vez)

### A1 · IBM i (7.5)

1. Servidor SSH activo y con arranque automático:
   ```
   STRTCPSVR SERVER(*SSHD)
   CHGTCPSVR SVRSPCVAL(*SSHD) AUTOSTART(*YES)
   ```
2. Usuario dedicado para el pipeline (sin *ALLOBJ, sin contraseña):
   ```
   CRTUSRPRF USRPRF(CIBUILD) PASSWORD(*NONE) USRCLS(*PGMR) HOMEDIR('/home/CIBUILD') TEXT('Pipeline iPOWER26')
   ```
   En ACS Run SQL Scripts:
   ```sql
   CALL QSYS2.SET_PASE_SHELL_INFO('CIBUILD', '/QOpenSys/pkgs/bin/bash');
   ```
3. Herramientas open source (como usuario con autoridad, desde SSH o ACS):
   ```
   /QOpenSys/pkgs/bin/yum install bob rsync git
   ```
4. RPGUnit instalado (biblioteca `RPGUNIT`).
5. Biblioteca `SAMCO` creada y con autoridad para CIBUILD. Se llama SAMCO porque
   `POPULATE_SAMCO_TABLES.sql` inserta en `SAMCO.<tabla>`.

### A2 · Mac (runner y llaves)

1. Generar la llave y copiarla al IBM i:
   ```
   ssh-keygen -t ed25519 -C "runner-ipower26"
   ```
   Pegar `~/.ssh/id_ed25519.pub` en `/home/CIBUILD/.ssh/authorized_keys` del IBM i
   (permisos: `.ssh` 700, `authorized_keys` 600, home sin escritura de grupo).
2. Probar una vez a mano (acepta la huella del host):
   ```
   ssh CIBUILD@<ip-del-ibmi> "echo OK"
   ```
3. Primer build manual, para validar antes de automatizar:
   ```
   rsync -az --rsync-path=/QOpenSys/pkgs/bin/rsync ./SAMCO/ CIBUILD@<ip>:/home/CIBUILD/builds/samco/
   ssh CIBUILD@<ip> "cd /home/CIBUILD/builds/samco && export lib1=SAMCO && /QOpenSys/pkgs/bin/makei build"
   ```
4. Cargar los datos de ejemplo: ejecutar `SAMCO/POPULATE_SAMCO_TABLES.sql` en ACS Run SQL Scripts.

### A3 · GitHub

1. Crear un repositorio privado vacío, por ejemplo `samco-devops-demo`.
2. En esta carpeta (terminal de Bob):
   ```
   git init -b main
   git add .
   git commit -m "Línea base: aplicación SAMCO original"
   git remote add origin git@github.com:<tu-usuario>/samco-devops-demo.git
   git push -u origin main
   ```
3. Variables del repositorio (Settings → Secrets and variables → Actions → Variables):
   `IBMI_HOST` = IP del IBM i · `IBMI_USER` = CIBUILD · `IBMI_LIB` = SAMCO
4. Opcional, muy visual en el video: proteger `main` (Settings → Branches) exigiendo
   pull request y que el check del pipeline pase.

### A4 · Runner self-hosted en la Mac

Settings → Actions → Runners → **New self-hosted runner** → macOS · ARM64.
Ejecutar los comandos que muestra GitHub (`./config.sh ...` y luego `./run.sh`).
Durante la grabación, `./run.sh` debe estar corriendo.

### A5 · Ensayo completo

Ejecutar el workflow a mano (Actions → *SAMCO · build y pruebas en IBM i* → Run workflow)
y confirmar que queda en verde antes de grabar.

---

## Fase B · Guion de grabación (6 clips)

Consejos: pantalla a 1920×1080, fuente del editor 20 pt o más, tema claro, ocultar la IP
del IBM i, cortar las esperas en la edición. Grabar con Cmd+Shift+5 en la Mac.
Duración objetivo del video final: 8 a 10 minutos.

### Clip 1 · Entender (Bob, modo Ask)
```
@SAMCO/QRPGSRC/COU200.RPG

Explica qué hace este programa: qué archivos usa, cómo funciona el flujo entre
paneles (variables PANEL, STEP01 y STEP02) y qué regla de negocio aplica.
Escríbelo como documentación para alguien que recién llega al equipo y guárdalo
en SAMCO/docs/COU200.md.
```
Mostrar: la explicación y el archivo `docs/COU200.md` creado.

### Clip 2 · Modernizar (Bob, modo Code)
```
Convierte @SAMCO/QRPGSRC/COU200.RPG de RPG III a RPG IV totalmente libre (**free)
y guárdalo como SAMCO/QRPGLESRC/COU200.PGM.RPGLE.
Requisitos:
- Mismo comportamiento y mismos archivos (COU200D y COUNTRY); no cambies el DSPF.
- Reemplaza GOTO/TAG por un bucle DOW y usa nombres claros para cada paso.
- Mantén los indicadores que usa el DSPF, pero documenta qué hace cada uno.
- Mueve la regla de COU200 de SAMCO/QRPGSRC/Rules.mk a SAMCO/QRPGLESRC/Rules.mk
  y elimina el fuente viejo: Git conserva el historial.
```
Mostrar: el diff lado a lado y aceptar el cambio.
Frase para la narración: «No hace falta COU200_OLD: Git guarda la versión anterior».

### Clip 3 · Probar (Bob, modo Code)
```
@SAMCO/QRPGLESRC/COU300.RPGLE

Crea pruebas RPGUnit en SAMCO/qtestsrc/cou300.test.rpgle para GetCountryName,
GetCountryIso3 y ExistCountry. Usa los datos de SAMCO/POPULATE_SAMCO_TABLES.sql:
FR debe devolver France y FRA; un código inexistente como XX debe devolver *OFF
en ExistCountry. Un procedimiento de prueba por caso, usando aEqual y assert.
```
Mostrar: el archivo de prueba generado.

### Clip 4 · Versionar (Bob, modo Agent)
```
Crea una rama llamada feat/cou200-free, agrega todos los cambios, escribe un
mensaje de commit que describa la modernización y la nueva prueba, y haz push.
```
Mostrar: los comandos git que Bob propone y aprueba, y el mensaje de commit generado.

### Clip 5 · Integrar (GitHub)
Abrir el pull request (o pedírselo a Bob en el clip 6) y mostrar en la pestaña
Actions los tres pasos en verde: copiar al IFS, makei build y pruebas RPGUnit.

### Clip 6 · Aprobar (Bob + GitHub)
```
/review
```
Comparar `feat/cou200-free` contra `main` y mostrar los hallazgos. Luego:
```
Abre un pull request de feat/cou200-free hacia main con un resumen de los cambios.
```
Mostrar el PR con el autor, el diff, el check del pipeline en verde y la aprobación.
Cierre de la narración: «Esto es lo que pide el auditor».

---

## Pendientes a verificar durante el ensayo
- Que `makei` tome la biblioteca desde la variable `lib1` (en `iproj.json` figura `&lib1`).
- Que `FCOUNTRY` sea el programa de servicio que exporta las funciones de COU300.
- Los parámetros de `RUCRTRPG` según tu versión de RPGUnit (`SRCSTMF`, `INCDIR`, `BNDSRVPGM`).
- No abrir en pantalla archivos con marca de terceros (SAMMNU, mensajes, encabezado de vat300).
