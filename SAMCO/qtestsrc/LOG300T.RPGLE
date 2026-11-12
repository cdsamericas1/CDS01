**free
// ============================================================
// Pruebas RPGUnit para el módulo LOG300 (AddLogEntry)
// Lab DevOps en Vivo · iPower26 · Bogotá · Nov 2026
// ============================================================
ctl-opt nomain;

/include QPROTOSRC,LOG_functions
/include RPGUNIT/QINCLUDE,ASSERT

// -------------------------------------------------------
// Test 1: AddLogEntry no falla con un mensaje normal
// -------------------------------------------------------
dcl-proc test_addLogEntry_normal export;
  dcl-pi *n end-pi;

  dcl-s resultado ind;

  monitor;
    AddLogEntry('Prueba de log normal desde RPGUnit');
    resultado = *on;
  on-error;
    resultado = *off;
  endmon;

  assert(resultado : 'AddLogEntry falló con un mensaje normal');
end-proc;

// -------------------------------------------------------
// Test 2: AddLogEntry acepta mensaje vacío sin fallar
// -------------------------------------------------------
dcl-proc test_addLogEntry_empty export;
  dcl-pi *n end-pi;

  dcl-s resultado ind;

  monitor;
    AddLogEntry('');
    resultado = *on;
  on-error;
    resultado = *off;
  endmon;

  assert(resultado : 'AddLogEntry falló con mensaje vacío');
end-proc;

// -------------------------------------------------------
// Test 3: AddLogEntry acepta mensaje de 500 caracteres
// -------------------------------------------------------
dcl-proc test_addLogEntry_maxLen export;
  dcl-pi *n end-pi;

  dcl-s msgLargo char(500) inz(*blanks);
  dcl-s resultado ind;

  msgLargo = %subst('X' : 1 : 1);

  monitor;
    AddLogEntry(msgLargo);
    resultado = *on;
  on-error;
    resultado = *off;
  endmon;

  assert(resultado : 'AddLogEntry falló con mensaje de longitud máxima');
end-proc;

// -------------------------------------------------------
// Test 4: AddLogEntry acepta pgmName con nombre de programa
// -------------------------------------------------------
dcl-proc test_addLogEntry_conPgmName export;
  dcl-pi *n end-pi;

  dcl-s resultado ind;

  monitor;
    AddLogEntry('Orden creada' : 'ORD200');
    resultado = *on;
  on-error;
    resultado = *off;
  endmon;

  assert(resultado : 'AddLogEntry falló al pasar nombre de programa');
end-proc;

// -------------------------------------------------------
// Test 5: AddLogEntry funciona sin pasar pgmName (compatibilidad)
// -------------------------------------------------------
dcl-proc test_addLogEntry_sinPgmName export;
  dcl-pi *n end-pi;

  dcl-s resultado ind;

  monitor;
    AddLogEntry('Llamada sin pgmName');
    resultado = *on;
  on-error;
    resultado = *off;
  endmon;

  assert(resultado : 'AddLogEntry falló cuando pgmName es omitido');
end-proc;

// -------------------------------------------------------
// Test 6: AddLogEntry acepta pgmName vacío sin fallar
// -------------------------------------------------------
dcl-proc test_addLogEntry_pgmNameVacio export;
  dcl-pi *n end-pi;

  dcl-s resultado ind;

  monitor;
    AddLogEntry('Mensaje con programa vacío' : '');
    resultado = *on;
  on-error;
    resultado = *off;
  endmon;

  assert(resultado : 'AddLogEntry falló con pgmName vacío');
end-proc;
