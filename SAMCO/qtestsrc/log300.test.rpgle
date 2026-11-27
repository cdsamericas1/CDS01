      **free

       /copy QPROTOSRC/LOG_functions.RPGLEINC

      // ----------------------------------------------------------------
      // Helpers
      // ----------------------------------------------------------------
      dcl-s lastEntry    varchar(600);

      dcl-pr getLastEntry varchar(600) extproc('getLastEntry');
      end-pr;

      // ----------------------------------------------------------------
      // Test 1: Entry sin pgmName contiene 'Msg:'
      // ----------------------------------------------------------------
      dcl-proc testEntryContainsMsg export;
        dcl-pi *n end-pi;

        AddLogEntry('Hola mundo');
        lastEntry = getLastEntry();

        assert(%scan('Msg: Hola mundo' : lastEntry) > 0
              : 'La entrada debe contener Msg: Hola mundo');
      end-proc;

      // ----------------------------------------------------------------
      // Test 2: Entry con pgmName incluye el nombre del programa
      // ----------------------------------------------------------------
      dcl-proc testPgmNameIsRecorded export;
        dcl-pi *n end-pi;

        AddLogEntry('Prueba trazabilidad' : 'LOG300');
        lastEntry = getLastEntry();

        assert(%scan('Pgm: LOG300' : lastEntry) > 0
              : 'La entrada debe contener Pgm: LOG300');
      end-proc;

      // ----------------------------------------------------------------
      // Test 3: Entry sin pgmName deja Pgm en blancos (campo vacío)
      // ----------------------------------------------------------------
      dcl-proc testNoPgmNameIsBlank export;
        dcl-pi *n end-pi;

        AddLogEntry('Sin programa');
        lastEntry = getLastEntry();

        // Pgm: aparece pero sin valor (Pgm:  * )
        assert(%scan('Pgm:  *' : lastEntry) > 0
              : 'Sin pgmName la entrada debe tener Pgm vacío');
      end-proc;

      // ----------------------------------------------------------------
      // Test 4: Entry siempre contiene 'User:' y 'Date:'
      // ----------------------------------------------------------------
      dcl-proc testEntryContainsUserAndDate export;
        dcl-pi *n end-pi;

        AddLogEntry('Check campos' : 'TESTER');
        lastEntry = getLastEntry();

        assert(%scan('User: ' : lastEntry) > 0
              : 'La entrada debe contener User:');
        assert(%scan('Date: ' : lastEntry) > 0
              : 'La entrada debe contener Date:');
      end-proc;

      // ----------------------------------------------------------------
      // getLastEntry: lee la última entrada registrada en el User Space
      // ----------------------------------------------------------------
      dcl-proc getLastEntry;
        dcl-pi *n varchar(600) end-pi;

        dcl-s usrspc   char(20)   inz('SAMLOG    *LIBL');
        dcl-s ptr      pointer;
        dcl-s pos      int(10)    based(ptr);
        dcl-s data     char(600)  based(bptr);
        dcl-s bptr     pointer;
        dcl-s result   varchar(600);

        rtvusrspcptr(usrspc : ptr);
        bptr = ptr + pos - 600;
        result = %trimr(%subst(data : 1 : 600));
        return result;
      end-proc;
