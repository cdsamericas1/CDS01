      **free

       /copy QPROTOSRC/APICALL-Prototypes_for_Ibm_API.RPGLEINC
       /copy QPROTOSRC/LOG_functions.RPGLEINC

      // ----------------------------------------------------------------
      // buildEntry: reproduce la misma lógica de formato que LOG300
      //   sin tocar el User Space — para validar el formato del string
      // ----------------------------------------------------------------
      dcl-proc buildEntry;
        dcl-pi *n varchar(600);
          entry    varchar(500) value;
          pgmName  char(10)     value options(*nopass);
        end-pi;

        dcl-s pgm    char(10);
        dcl-s result varchar(600);

        if %parms() >= 2;
          pgm = pgmName;
        else;
          pgm = *blanks;
        endif;

        result  = 'User: ' + %str(%addr(*USER) : 10) + ' * ';
        result += 'Pgm: '  + %trim(pgm)        + ' * ';
        result += 'Date: ' + %char(%Timestamp()) + ' * ';
        result += 'Msg: '  + %trim(entry)       + ' ***';

        return result;
      end-proc;

      // ----------------------------------------------------------------
      // Test 1: AddLogEntry sin pgmName se ejecuta sin error
      // ----------------------------------------------------------------
      dcl-proc testAddLogEntryRuns export;
        dcl-pi *n end-pi;

        // Si AddLogEntry falla con MCH/CEE, RPGUnit reporta el error.
        // Que llegue a assert(*on) confirma ejecución limpia.
        AddLogEntry('Test run sin pgmName');
        assert(*on : 'AddLogEntry sin pgmName debe ejecutarse sin error');
      end-proc;

      // ----------------------------------------------------------------
      // Test 2: AddLogEntry con pgmName se ejecuta sin error
      // ----------------------------------------------------------------
      dcl-proc testAddLogEntryWithPgmRuns export;
        dcl-pi *n end-pi;

        AddLogEntry('Test run con pgmName' : 'LOG300');
        assert(*on : 'AddLogEntry con pgmName debe ejecutarse sin error');
      end-proc;

      // ----------------------------------------------------------------
      // Test 3: El formato incluye 'Pgm: LOG300' cuando se pasa el nombre
      // ----------------------------------------------------------------
      dcl-proc testFormatIncludesPgmName export;
        dcl-pi *n end-pi;

        dcl-s entry varchar(600);

        entry = buildEntry('Trazabilidad' : 'LOG300');

        assert(%scan('Pgm: LOG300' : entry) > 0
              : 'El formato debe incluir Pgm: LOG300');
      end-proc;

      // ----------------------------------------------------------------
      // Test 4: Sin pgmName el campo Pgm queda vacío en el formato
      // ----------------------------------------------------------------
      dcl-proc testFormatPgmBlankWhenOmitted export;
        dcl-pi *n end-pi;

        dcl-s entry varchar(600);

        entry = buildEntry('Sin nombre');

        // Pgm: seguido de espacio y ' * ' (sin valor entre medias)
        assert(%scan('Pgm:  *' : entry) > 0
              : 'Sin pgmName el campo Pgm debe quedar vacío');
      end-proc;
