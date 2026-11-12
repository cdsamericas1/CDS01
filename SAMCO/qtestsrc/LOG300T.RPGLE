**free
// ============================================================
// Pruebas RPGUnit para el modulo LOG300 (AddLogEntry)
// Lab DevOps en Vivo · iPower26 · Bogota · Nov 2026
// ============================================================
ctl-opt nomain;

// --- Prototipo de la funcion a probar ---
dcl-pr AddLogEntry extproc('ADDLOGENTRY');
  entry    char(500) value;
  pgmName  char(10)  value options(*nopass);
end-pr;

// --- Prototipo de assert (RPGUnit extproc publico) ---
dcl-pr assert extproc('assert') opdesc;
  condition  ind const;
  msgIfFalse varchar(16384) options(*varsize : *nopass) const;
end-pr;

// --- APIs para inicializar SAMLOG ---
dcl-pr crtusrspc extpgm('QUSCRTUS');
  usrspc    char(20);
  spc_attr  char(10) const;
  spc_size  int(10)  const;
  spc_init  char(1)  const;
  spc_aut   char(10) const;
  spc_text  char(50) const;
  spc_replace char(10) const;
  errcod    char(256);
end-pr;
dcl-pr rtvusrspcptr extpgm('QUSPTRUS');
  usrspc  char(20) const;
  ptr     pointer;
end-pr;

dcl-ds errDs;
  errBytProv  int(10) inz(256);
  errBytAvail int(10) inz(0);
  errMsgId    char(7);
  errReserv   char(1);
  errMsgDta   char(240);
end-ds;

dcl-ds samlogDs based(pSamlog);
  samlogPos int(10);
end-ds;

// setUp: se ejecuta antes de cada prueba
dcl-proc setUp export;
  dcl-pi *n end-pi;
  dcl-s  usrspc char(20) inz('SAMLOG    OSWLABBOB ');
  errBytAvail = 0;
  crtusrspc(usrspc : 'LOG       ' : 65536 : x'00'
             : '*ALL      ' : 'RPGUnit test log space            '
             : '*YES      ' : errDs);
  rtvusrspcptr(usrspc : pSamlog);
  samlogPos = 7;
end-proc;

// Test 1: mensaje normal
dcl-proc test_addLogEntry_normal export;
  dcl-pi *n end-pi;
  dcl-s resultado ind;
  monitor;
    AddLogEntry('Prueba de log normal desde RPGUnit');
    resultado = *on;
  on-error;
    resultado = *off;
  endmon;
  assert(resultado : 'AddLogEntry fallo con un mensaje normal');
end-proc;

// Test 2: mensaje vacio
dcl-proc test_addLogEntry_empty export;
  dcl-pi *n end-pi;
  dcl-s resultado ind;
  monitor;
    AddLogEntry('');
    resultado = *on;
  on-error;
    resultado = *off;
  endmon;
  assert(resultado : 'AddLogEntry fallo con mensaje vacio');
end-proc;

// Test 3: mensaje de 500 caracteres
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
  assert(resultado : 'AddLogEntry fallo con mensaje de longitud maxima');
end-proc;

// Test 4: con pgmName
dcl-proc test_addLogEntry_conPgmName export;
  dcl-pi *n end-pi;
  dcl-s resultado ind;
  monitor;
    AddLogEntry('Orden creada' : 'ORD200');
    resultado = *on;
  on-error;
    resultado = *off;
  endmon;
  assert(resultado : 'AddLogEntry fallo al pasar nombre de programa');
end-proc;

// Test 5: sin pgmName (compatibilidad)
dcl-proc test_addLogEntry_sinPgmName export;
  dcl-pi *n end-pi;
  dcl-s resultado ind;
  monitor;
    AddLogEntry('Llamada sin pgmName');
    resultado = *on;
  on-error;
    resultado = *off;
  endmon;
  assert(resultado : 'AddLogEntry fallo cuando pgmName es omitido');
end-proc;

// Test 6: pgmName vacio
dcl-proc test_addLogEntry_pgmNameVacio export;
  dcl-pi *n end-pi;
  dcl-s resultado ind;
  monitor;
    AddLogEntry('Mensaje con programa vacio' : '');
    resultado = *on;
  on-error;
    resultado = *off;
  endmon;
  assert(resultado : 'AddLogEntry fallo con pgmName vacio');
end-proc;
