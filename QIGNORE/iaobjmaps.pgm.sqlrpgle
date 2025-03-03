**free
//------------------------------------------------------------------------------------ //
//CREATED BY :   Programmers.io @ 2020                                                 //
//CREATE DATE:   2020/01/01                                                            //
//DEVELOPER  :   Kaushal kumar                                                         //
//DESCRIPTION:   Program for Object to Object Mapping                                  //
//                                                                                     //
//PROCEDURE LOG:                                                                       //
//------------------------------------------------------------------------------------ //
//Procedure Name           | Procedure Description                                     //
//-------------------------|---------------------------------------------------------- //
//RunCmd
//------------------------------------------------------------------------------------ //
//                                                                                     //
//MODIFICATION LOG:                                                                    //
//------------------------------------------------------------------------------------ //
//Date    | Mod_ID | Developer  | Case and Description                                 //
//--------|--------|------------|----------------------------------------------------- //
//        |        |            |                                                      //
//------------------------------------------------------------------------------------ //
ctl-opt copyright('Programmers.io © 2020 | Shomi | Changed March 2020');
ctl-opt option(*nodebugio:*srcstmt:*nounref);
ctl-opt dftactgrp(*no);

dcl-pi IAOBJMAPS extpgm('IAOBJMAPS');
   Repstory char(10);
end-pi;

dcl-s command          varchar(1000) inz;
dcl-s uwerror          char(1)       inz;
dcl-s ObjectLibraryp   char(10)      inz;
dcl-s ObjectNamep      char(10)      inz;
dcl-s ObjectTypep      char(08)      inz;
dcl-s ObjectAttributep char(10)      inz;
dcl-s AttobjLib        char(10)      inz;
dcl-s AttobjName       char(10)      inz;
dcl-s AttobjType       char(10)      inz;
dcl-s AttobjAttr       char(10)      inz;
dcl-s DSPPGMLIB        char(10)      inz;

dcl-c SQL_ALL_OK       '00000';

exec sql
     set option commit = *none,
                naming = *sys,
                usrprf = *user,
                dynusrprf = *user,
                closqlcsr = *endmod;

if Repstory <> *blanks;
   exsr Init;
   exsr MainLogic;
endif;

*inlr = *on;
return;

//---------------------------------------------------------------------- //
//MainLogic :
//---------------------------------------------------------------------- //
begsr MainLogic;

   clear ObjectLibraryp;
   clear ObjectNamep;
   clear ObjectTypep;
   clear ObjectAttributep;

   exec sql
    declare PGMDTL cursor for
     select B.ODLBNM,
            B.ODOBNM,
            B.ODOBTP,
            B.ODOBAT
       from IDSPOBJD B
      where B.ODOBTP = '*PGM'
        and B.ODOBAT in ('RPGLE', 'CLLE');

   exec sql open PGMDTL;
   if SQLSTATE = SQL_ALL_OK;
      exec sql fetch from PGMDTL into :ObjectLibraryp,
                                      :ObjectNamep,
                                      :ObjectTypep,
                                      :ObjectAttributep;
      dow SQLSTATE = SQL_ALL_OK;
         exec sql
           delete from #IAOBJ/iaflatfile;

         exec sql
           delete from #IAOBJ/iaflat;

         exec sql
           delete from QTEMP/OBJDESC;

         clear command;

         command = 'DSPPGM PGM('+%trim(ObjectLibraryp) + '/' +
                    %trim(ObjectNamep) + ') +
                    OUTPUT(*PRINT) +
                    DETAIL(*MODULE)';
         runcmd();

         clear command;
         command = 'CPYSPLF FILE(QPDPGM) +
                            TOFILE(#IAOBJ/IAFLATFILE) +
                            SPLNBR(*LAST) +
                            CRTDATE(*ONLY)';
         runcmd();

         exec sql
           select substr(IAFLATFILE,17,10)
             into :DSPPGMLIB
             from #IAOBJ/iaflatfile
            where rrn(iaflatfile) = 9;

         clear AttobjLib;
         clear AttobjName;
         clear AttobjType;
         clear AttobjAttr;

         //Checking which modules are attached to a program
         if DSPPGMLIB  <> 'QTEMP';
            AttobjType  = '*MODULE';

            exec sql
             declare MODDTL cursor for
              select substr(iaflatfile,2,10) ,
                     substr(iaflatfile,17,10),
                     substr(iaflatfile,32,10)
                from #IAOBJ/iaflatfile
               where rrn(iaflatfile) >= 9
                 and substr(iaflatfile,17,10) <> ' ';

            exec sql open MODDTL;
            if SQLSTATE = SQL_ALL_OK;
               exec sql fetch from MODDTL into :AttobjName,
                                                :AttobjLib,
                                                :AttobjAttr;
               dow SQLSTATE = SQL_ALL_OK;
                  exsr InsertDDL1;
                  exec sql fetch from MODDTL into :AttobjName,
                                                   :AttobjLib,
                                                   :AttobjAttr;
               enddo;
               exec sql close MODDTL;
            endif;
         endif;
         clear command;
         command = 'DSPPGM PGM('+%trim(ObjectLibraryp) + '/' +
                                 %trim(ObjectNamep) + ') +
                    OUTPUT(*PRINT) +
                    DETAIL(*SRVPGM)';
         runcmd();
         clear DSPPGMLIB;
         clear command;
         command = 'CPYSPLF FILE(QPDPGM) +
                    TOFILE(#IAOBJ/IAFLAT) +
                    SPLNBR(*LAST) +
                    CRTDATE(*ONLY)';
         runcmd();

         exec sql
           select substr(IAFLATFILE,17,10)
             into :DSPPGMLIB
             from #IAOBJ/iaflat
            where rrn(iaflat) = 10;
         if SQLSTATE <> SQL_ALL_OK;
            //log error
         endif;

         clear AttobjLib;
         clear AttobjName;
         clear AttobjType;
         clear AttobjAttr;

         //Checking Which service programs are attached with the program
         if DSPPGMLIB  <> 'QSYS';
            AttobjType  = '*SRVPGM';

            exec sql
             declare SRVDTL cursor for
              select substr(iaflatfile,2,10),
                     substr(iaflatfile,17,10)
                from #IAOBJ/iaflat
               where rrn(iaflat) >= 10
                 and substr(iaflatfile,17,10)
                 not in(' ', 'QSYS');

            exec sql open SRVDTL;
            if SQLSTATE = SQL_ALL_OK;
               exec sql fetch from SRVDTL into :AttobjName,
                                               :AttobjLib;
               dow SQLSTATE = SQL_ALL_OK;
                  clear command;
                  command = 'DSPOBJD OBJ('+%trim(AttobjLib)+ '/' +
                                           %trim(AttobjName) + ') +
                             OBJTYPE(*SRVPGM) +
                             OUTPUT(*OUTFILE) +
                             OUTFILE(QTEMP/OBJDESC)';
                  runcmd();
                  exec sql
                    select ODOBAT
                      into :Attobjattr
                      from objdesc
                     fetch first row only;
                  if SQLSTATE <> SQL_ALL_OK;
                     //log error
                  endif;

                  exsr InsertDDL1;
                  exec sql fetch from SRVDTL into :AttobjName, :AttobjLib;

               enddo;
               exec sql close SRVDTL;
            endif;
         endif;

         clear ObjectLibraryp;
         clear ObjectNamep;
         clear ObjectTypep;
         clear ObjectAttributep;
         exec sql fetch next from PGMDTL into :ObjectLibraryp,
                                              :ObjectNamep,
                                              :ObjectTypep,
                                              :ObjectAttributep;
      enddo;
      exec sql close PGMDTL;
   endif;

endsr;

begsr Init;

   exec sql
     delete from IAOBJMAP;
   if SQLSTATE = SQL_ALL_OK;
      //log error
   endif;

endsr;

begsr InsertDDL1;

   exec sql
     insert into IAOBJMAP (PMOBJLIB,
                           PMOBJNAME,
                           PMOBJTYPE,
                           PMOBJATTR,
                           PAOBJLIB,
                           PAOBJNAME,
                           PAOBJTYPE,
                           PAOBJATTR)
       values(:ObjectLibraryp,
              :ObjectNamep,
              :ObjectTypep,
              :ObjectAttributep,
              :AttobjLib,
              :AttobjName,
              :AttobjType,
              :AttobjAttr);
     if SQLSTATE = SQL_ALL_OK;
      //log error
     endif;

endsr;

//---------------------------------------------------------------------- //
//RunCmd :
//---------------------------------------------------------------------- //
dcl-proc runcmd;

   dcl-pr runcommand extpgm('QCMDEXC');
      command char(1000) options(*varsize) const;
      commandlen packed(15:5) const;
   end-pr;

   clear uwerror;
   monitor;
      runcommand(Command:%len(%trimr(command)));
   on-error;
      uwerror = 'Y';
   endmon;

end-proc;
