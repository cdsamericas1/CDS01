# 🎬 Guión Demo en Vivo — DevOps en IBM i con Bob
**iPower26 · Bogotá · 18 de noviembre de 2026 · 15 minutos**

---

## ⚙️ Checklist antes de subir al escenario

- [ ] Runner de GitHub Actions corriendo en tu Mac (`cd ~/actions-runner && ./run.sh`)
- [ ] VS Code abierto con el repo `bob-rpg-ibm-i-main`
- [ ] IBM Bob activo en VS Code
- [ ] Browser abierto en https://github.com/cdsamericas1/CDS01/actions
- [ ] Archivo `SAMCO/QRPGLESRC/LOG300.RPGLE` abierto en VS Code
- [ ] Fuente del editor a 20pt o más
- [ ] Tema claro en VS Code (más visible en proyector)
- [ ] Hotspot propio listo (no depender del WiFi del evento)

---

## 🎯 El escenario (memorizar)

> *"El equipo de auditoría pidió una mejora al log de SAMCO. Hoy el log registra usuario, timestamp y mensaje. Necesitan también saber **qué programa** generó cada entrada. Vamos a hacer ese cambio — en vivo, con Bob, Git y el pipeline."*

---

## 🎤 Guión paso a paso

---

### [0:00 – 0:30] Contexto

**Dices:**
> *"Acabo de mostrarles cómo llega hoy un cambio a producción en IBM i — con correos, respaldos manuales y el orden que solo una persona recuerda. Ahora vamos a hacer ese mismo cambio, pero con DevOps y con Bob."*

---

### [0:30 – 1:00] Presentas el escenario

**Dices:**
> *"El equipo de auditoría pidió una mejora al log de SAMCO. Hoy el log registra usuario, timestamp y mensaje. Necesitan también saber qué programa generó cada entrada. Vamos a hacer ese cambio — en vivo."*

---

### [1:00 – 3:00] Paso 1 · Entender el código con Bob

**Haces:** Abres `SAMCO/QRPGLESRC/LOG300.RPGLE` en VS Code

**Escribes en Bob (copia exacta):**
```
@SAMCO/QRPGLESRC/LOG300.RPGLE

Explica qué hace este programa, qué información guarda en el log
y cómo funciona el User Space. Escríbelo para alguien que recién
llega al equipo.
```

**Dices mientras Bob responde:**
> *"Fíjense — Bob leyó el programa y lo está explicando en lenguaje natural. No necesité leer las 44 líneas. Esto es lo que hace Bob por el desarrollador nuevo que llega al equipo."*

---

### [3:00 – 6:00] Paso 2 · Pedir la mejora a Bob

**Escribes en Bob (copia exacta):**
```
@SAMCO/QRPGLESRC/LOG300.RPGLE

El equipo de auditoría necesita que el log incluya el nombre del
programa que llama a AddLogEntry. Modifica el parámetro de entrada
y la lógica interna para incluir ese dato entre el usuario y el
timestamp. El parámetro debe ser opcional con default *blanks.
```

**Dices mientras Bob propone el código:**
> *"Bob propone el cambio. Ahora mi trabajo es revisar el diff — la IA propone, el desarrollador decide. No acepto ciegamente."*

**Haces:** Revisas el diff en pantalla, aceptas el cambio

---

### [6:00 – 8:00] Paso 3 · Crear la rama y hacer commit

**Haces:** En la terminal de VS Code ejecutas:

```bash
git switch -c feat/log-add-pgmname
git add SAMCO/QRPGLESRC/LOG300.RPGLE
git commit -m "feat(log300): add program name parameter to AddLogEntry"
git push -u origin feat/log-add-pgmname
```

**Dices mientras ejecutas:**
> *"Una rama por cambio. Producción nunca se toca directo. Este es el primer paso de la trazabilidad — quién hizo el cambio, qué cambió, cuándo."*

---

### [8:00 – 11:00] Paso 4 · El pipeline se activa solo

**Haces:** Cambias al browser → https://github.com/cdsamericas1/CDS01/actions

**Dices:**
> *"Acabo de hacer push. GitHub Actions detectó el cambio automáticamente y ya está compilando en mi IBM i. Sin que yo recuerde ningún parámetro, sin correos."*

**Muestras los pasos corriendo en verde:**
- ✅ Obtener el código
- ✅ Copiar fuentes al IFS
- ✅ Compilar con makei
- ✅ Verificar objetos

---

### [11:00 – 13:00] Paso 5 · Abrir el Pull Request

**Haces:** En GitHub creas el PR de `feat/log-add-pgmname` → `main`

**Dices:**
> *"Aquí está lo que le muestro al auditor cuando me pregunte: quién hizo el cambio, qué cambió línea a línea, cuándo, y si el pipeline pasó. Todo en un solo lugar. Sin correos, sin PDFs."*

**Señalas en pantalla:**
- El diff del archivo
- El resultado del pipeline en verde
- El autor y la fecha

---

### [13:00 – 15:00] Cierre

**Dices:**
> *"Ese cambio tardó 15 minutos — de la solicitud del auditor al Pull Request con evidencia completa. El pipeline compiló y verificó automáticamente. Eso es DevOps en IBM i."*

> *"Lo difícil no fue técnico. El código RPG, el IBM i, Git — todo funcionó junto. Lo que cambió fue el proceso."*

---

## 🚨 Planes de contingencia

| Si falla... | Haces... |
|-------------|---------|
| Bob no responde | Muestras la respuesta ya guardada en `lab-devops-live.md` |
| El pipeline falla | Muestras el run #9 que ya está en verde como ejemplo |
| SSH al IBM i cae | Dices: *"En producción esto corre en un servidor dedicado"* y muestras el resultado previo |
| Git push falla | Verificas en tu terminal: `ps aux \| grep run.sh` |
| VS Code se congela | Tienes el browser con el repo ya abierto como respaldo |

---

## 📋 Prompts de respaldo (si Bob no responde como esperado)

**Para entender el programa:**
```
¿Qué es un User Space en IBM i y cómo lo usa LOG300 para guardar entradas de log?
```

**Para pedir la mejora:**
```
Muéstrame cómo agregar un segundo parámetro opcional a un procedimiento RPG
que ya está en producción sin romper el código que lo llama hoy.
```

**Para explicar el commit:**
```
¿Cuál es la diferencia entre hacer el cambio directo en main versus
crear una rama feature y hacer un Pull Request?
```

---

## 🔑 Datos del repo y sistema

| Dato | Valor |
|------|-------|
| Repositorio | https://github.com/cdsamericas1/CDS01 |
| Rama principal | `main` |
| Rama de la demo | `feat/log-add-pgmname` |
| IBM i | `10.0.0.2` |
| Usuario IBM i | `oswaldo` |
| Biblioteca | `OSWLABBOB` |
| Runner | `~/actions-runner/run.sh` (Mac local) |

---

## ⏱️ Resumen de tiempos

| Min | Actividad |
|-----|-----------|
| 0:00 | Contexto y escenario |
| 1:00 | Bob explica LOG300 |
| 3:00 | Bob propone el cambio |
| 6:00 | git commit + push |
| 8:00 | Pipeline en GitHub Actions |
| 11:00 | Pull Request con evidencia |
| 13:00 | Cierre |
| 15:00 | ⏹️ Fin |

---

*Guión preparado para iPower26 · CDS Americas · noviembre 2026*
