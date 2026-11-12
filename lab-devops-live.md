# Lab en Vivo · DevOps en IBM i con Bob
**iPower26 · Bogotá · 18 de noviembre de 2026**

> **Duración:** 15 minutos  
> **Nivel:** Mixto (principiantes a expertos en IBM i)  
> **Requisitos:** VS Code + IBM Bob + acceso a IBM i + repo clonado

---

## El escenario

El equipo de auditoría solicitó una mejora al sistema de log de SAMCO:

> *"El log actual registra usuario, timestamp y mensaje. Necesitamos también saber **qué programa** generó cada entrada. Sin eso, no podemos cumplir el requerimiento de trazabilidad."*

Hoy vas a hacer ese cambio — en vivo, con Bob, pasando por Git y el pipeline completo.

---

## El programa: `LOG300.RPGLE`

El módulo que vamos a modificar es [`SAMCO/QRPGLESRC/LOG300.RPGLE`](SAMCO/QRPGLESRC/LOG300.RPGLE).

Es el corazón del sistema de auditoría de SAMCO: cada vez que un programa necesita dejar evidencia de lo que hizo, llama a `AddLogEntry`.

**Hoy solo registra:**
```
User: OSVALDO * Date: 2026-11-18-14.23.01.000000 * Msg: Orden creada ***
```

**Después del lab registrará:**
```
User: OSVALDO * Pgm: ORD200 * Date: 2026-11-18-14.23.01.000000 * Msg: Orden creada ***
```

---

## Paso 1 · Entender el código (2 min)

Abre el archivo en VS Code y copia este prompt en Bob:

```
@SAMCO/QRPGLESRC/LOG300.RPGLE

Explica qué hace este programa, qué información guarda en el log
y cómo funciona el User Space. Escríbelo para alguien que recién
llega al equipo.
```

**Qué esperar de Bob:**
- Explicación del User Space como estructura de memoria compartida
- Descripción de `AddLogEntry`: recibe un mensaje, añade usuario y timestamp
- Identificación del gap: no hay campo para el nombre del programa

---

## Paso 2 · Pedir la mejora (3 min)

Con el archivo todavía abierto, copia este prompt:

```
@SAMCO/QRPGLESRC/LOG300.RPGLE

El equipo de auditoría necesita que el log incluya el nombre del
programa que llama a AddLogEntry. Modifica el parámetro de entrada
y la lógica interna para incluir ese dato entre el usuario y el
timestamp. Mantén la compatibilidad: el parámetro del programa
debe ser opcional con default *blanks.
```

**Qué esperar de Bob:**
- Modificación del `dcl-pi` para agregar el segundo parámetro `pgmName`
- Actualización de la línea de construcción del log para incluir `'Pgm: ' + pgmName`
- Sugerencia de valor por defecto para mantener compatibilidad

**Tu trabajo:** revisar el diff línea a línea antes de aceptar. La IA propone, el desarrollador decide.

---

## Paso 3 · Pedir las pruebas (2 min)

```
@SAMCO/QRPGLESRC/LOG300.RPGLE

Genera pruebas RPGUnit para la nueva versión de AddLogEntry:
un caso con nombre de programa, un caso con nombre vacío
y un caso donde el mensaje tiene la longitud máxima.
```

Ya existe una base en [`SAMCO/qtestsrc/log300.test.rpgle`](SAMCO/qtestsrc/log300.test.rpgle) — Bob puede expandirla.

---

## Paso 4 · Versionar (2 min)

```bash
# Crear una rama para el cambio
git switch -c feat/log-add-pgmname

# Agregar los archivos modificados
git add SAMCO/QRPGLESRC/LOG300.RPGLE
git add SAMCO/qtestsrc/log300.test.rpgle

# Commit con mensaje descriptivo
git commit -m "feat(log300): add program name parameter to AddLogEntry

El auditor requiere trazabilidad del programa de origen en cada
entrada del log. Se agrega parámetro pgmName opcional (default
*blanks) para compatibilidad con llamadas existentes."

# Push de la rama
git push -u origin feat/log-add-pgmname
```

**Mensaje clave para la audiencia:**
> *"Producción nunca se toca directo. Cada cambio vive en su propia rama hasta que pasa por el pipeline y una aprobación."*

---

## Paso 5 · El pipeline (3 min)

Abre GitHub: [github.com/cdsamericas1/CDS01](https://github.com/cdsamericas1/CDS01)

Ve a **Actions** → verás el workflow `SAMCO · build y pruebas en IBM i` ejecutándose.

Muestra los 3 pasos en pantalla:

| Paso | Qué hace |
|------|----------|
| ✅ Copiar fuentes al IFS | `rsync` sube el repo al IBM i via SSH |
| ✅ Compilar con makei | `makei build` compila solo lo que cambió |
| ✅ Pruebas RPGUnit | `RUCALLTST` ejecuta las 3 pruebas de LOG300 |

---

## Paso 6 · Aprobar con evidencia (1 min)

Crea el Pull Request en GitHub. Muestra lo que ve el auditor:

| Pregunta del auditor | Respuesta en el PR |
|---------------------|-------------------|
| ¿Quién hizo el cambio? | `cdsamericas1` · commit `feat(log300)...` |
| ¿Qué cambió exactamente? | Diff línea a línea en el PR |
| ¿Cuándo? | Fecha y hora del commit |
| ¿Se probó? | 3/3 pruebas RPGUnit en verde |
| ¿Quién lo aprobó? | El revisor que hace merge |

> *"Esto es lo que tiene que mostrarle al auditor. Sin correos, sin PDFs de aprobación manual."*

---

## Cierre (30 seg)

- El cambio tardó **15 minutos** de idea a Pull Request con evidencia completa
- El pipeline compiló y probó automáticamente — sin que nadie recordara los parámetros
- El diff es la documentación — queda en el repo para siempre

---

## Prompts de respaldo (si algo falla en vivo)

Si Bob no responde como esperado, aquí están los prompts alternativos:

**Para entender:**
```
¿Qué es un User Space en IBM i y cómo lo usa LOG300 para guardar entradas de log?
```

**Para modernizar:**
```
Muéstrame cómo agregar un segundo parámetro opcional a un procedimiento RPG
que ya está en producción sin romper el código que lo llama hoy.
```

**Para pruebas:**
```
Escribe una prueba RPGUnit que verifique que AddLogEntry no lanza excepción
cuando se llama con un mensaje de texto normal.
```

---

## Video de respaldo

Si el pipeline falla en vivo, muestra la captura de pantalla guardada en [`assets/`](assets/) o reproduce el video de ensayo.

> ☑️ **Antes de subir al escenario:** prueba el pipeline completo al menos 2 veces. El ensayo es obligatorio.

---

*Lab diseñado para iPower26 · CDS Americas · nov 2026*
