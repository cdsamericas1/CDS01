      *   %XREF XREFTYPE(*OBJ)   OBJ(SAMLOG) OBJTYPE(*USRSPC)   USAGE(*UPD)

     h nomain

      /copy APICALL-Prototypes_for_Ibm_API
      /copy LOG_functions
     d init            pr

     d pos             s             10i 0 based(p1)
     d data            s            600    based(p2)
     d usrspc          s             20
     d inz             s               n
     d User            s             10    inz(*USER)

     p AddLogEntry     b                   export
     d AddLogEntry     pi
     d  entry                       500    value
     d  pgmName                      10    value options(*nopass)

     d  data2          s            500    varying
     d  wPgmName       s             10    inz(*blanks)
      /free
        if not inz;
          init();
        endif;
        if %parms() >= 2;
          wPgmName = pgmName;
        endif;
        p2 = p1 + pos;
        data2 = 'User: ' +user + ' * ';
        if wPgmName <> *blanks;
          data2 += 'Pgm: ' + %trim(wPgmName) + ' * ';
        endif;
        data2 += 'Date: '  + %char(%Timestamp()) + ' * ' ;
        data2 += 'Msg: '  + %trim(entry) + ' ***' ;
        data = data2;
        pos += %len(data2);
      /end-free

     p AddLogEntry     e

     p init            b
     d init            pi

      /free
        usrspc = 'SAMLOG    *LIBL';
        inz = *on;
        rtvusrspcptr(usrspc:p1);
      /end-free

     p init            e
