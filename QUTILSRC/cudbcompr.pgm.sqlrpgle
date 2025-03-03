**free
      //%METADATA                                                      *
      // %TEXT CU Database and device file compilation utility         *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------ //
//CREATED BY :   Programmers.io @ 2022                                                 //
//CREATE DATE:   2022/01/28                                                            //
//DEVELOPER  :   Ashwani Kumar                                                         //
//DESCRIPTION:   Compilation utility based on main control file.                       //
//                                                                                     //
//PROCEDURE LOG:                                                                       //
//------------------------------------------------------------------------------------ //
//Procedure Name           | Procedure Description                                     //
//-------------------------|---------------------------------------------------------- //
//@pr_CmplRefPF            | Compile Reference File - REF.                             //
//@pr_CmplPFSQL            | Compile source type 'PFSQL'.                              //
//@pr_CmplPFre             | Compile source type 'PF'.                                 //
//@pr_CmplLFre             | Compile source type 'LF'.                                 //
//@pr_CmplDSPF             | Compile source type 'DSPF'.                               //
//@pr_CmplPRTF             | Compile source type 'PRTF'.                               //
//@pr_CrtDupObj            | Create duplicate object for 'MSGF'/'JOBQ'/'JOBD'/         //
//                         |        'OUTQ'/'DTAARA'/'BNDDIR'.                          //
//@pr_CpyFilesWithData     | Copy files With Data.                                     //
//@pr_DltSplFle            | Delete Spool File.                                        //
//@pr_ChgObjOwn            | Change Object Owner.                                      //
//------------------------------------------------------------------------------------ //
//                                                                                     //
//MODIFICATION LOG:                                                                    //
//------------------------------------------------------------------------------------ //
//Date    | Mod_ID | Developer  | Case and Description                                 //
//--------|--------|------------|----------------------------------------------------- //
//        |        |            |                                                      //
//------------------------------------------------------------------------------------ //
//h-spec
ctl-opt Copyright('Programmers.io @ 2022 | Ashwani Kumar');
ctl-opt Option(*NoDebugIo:*SrcStmt:*NoUnRef)
        DftActGrp(*No)
        ActGrp(*Caller);

//Main program prototypes
dcl-pi MainPgm  extpgm('CUDBCOMPR');
end-pi;

//Data Area structure.
dcl-ds AICTLDTA  len(200) Dtaara('AICTLDTA');
   dcl-subf g_TgtRls    char(10) pos(101);
   dcl-subf g_Devlpr    char(01) pos(111);
end-ds;

//Communication data structure
dcl-ds g_C01Ds extname('CUCTRLPF') prefix(C01_:2);
end-ds;
dcl-ds g_C02Ds extname('CUCTRLPF') prefix(C02_:2);
end-ds;
dcl-ds g_C03Ds extname('CUCTRLPF') prefix(C03_:2);
end-ds;
dcl-ds g_C04Ds extname('CUCTRLPF') prefix(C04_:2);
end-ds;
dcl-ds g_C05Ds extname('CUCTRLPF') prefix(C05_:2);
end-ds;
dcl-ds g_C06Ds extname('CUCTRLPF') prefix(C06_:2);
end-ds;
dcl-ds g_C07Ds extname('CUCTRLPF') prefix(C07_:2);
end-ds;

//Constants
dcl-c SQL_ALL_OK        '00000';
dcl-c SQL_NO_MORE_RCD   '02000';
dcl-c Quote             x'7D';
//-------------------------------------------------------------------------------------//
//Mainline Programming                                                                 //
//-------------------------------------------------------------------------------------//

//Set processing options to be used for SQL Statements in program.
Exec Sql
  Set Option Commit    = *None,
             Naming    = *Sys,
             UsrPrf    = *User,
             DynUsrPrf = *User,
             CloSqlCsr = *EndMod;
*inLR = *On;
in AICTLDTA;

//Compile Reference File - REF.
@pr_CmplRefPF();
//Compile source type 'PFSQL'.
@pr_CmplPFSQL();
//Compile source type 'PF'.
@pr_CmplPF();
//Compile source type 'LF'.
@pr_CmplLF();
//Compile source type 'DSPF'.
@pr_CmplDSPF();
//Compile source type 'PRTF'.
@pr_CmplPRTF();
//Copy Files with Data.
@pr_CpyFilesWithData();
//Create duplicate object for 'MSGF'/'JOBQ'/'JOBD'/'OUTQ'/'DTAARA'/'BNDDIR'.
@pr_CrtDupObj();

//End of Program!
Return;
//-------------------------------------------------------------------------------------//
//Compile Reference File - REF.                                                        //
//-------------------------------------------------------------------------------------//
Dcl-Proc  @pr_CmplRefPF;
   Dcl-PI @pr_CmplRefPF;
   End-PI @pr_CmplRefPF;

   //Declaring local variables.
   Dcl-S l_ClCmd  char(500);

   //Declare cursor C01.
   Exec Sql
     Declare C01 cursor for
        Select *
        From   CUCTRLPF
        Where  CUSRCMBR = 'FLDREFPF'
          and  CUSRCTYP = 'PF'
        for read only;

   //Open cursor C01.
   Exec Sql
     Open C01;

   //Fetch first row of cursor C01.
   Exec Sql
     Fetch C01 into :g_C01Ds;

   //Do until all rows of cursor C01 are processed.
   DoW SQLSTATE = SQL_ALL_OK;

       l_CLCmd = 'CRTPF FILE(' + %trim(C01_OBJLIB) + '/' + %trim(C01_SRCMBR) +
                 ') SRCFILE(' + %trim(C01_SRCLIB) + '/' + %trim(C01_SRCFLE) +
                 ') SRCMBR(' + %trim(C01_SRCMBR) + ')';

       //Call QCMDEXC.
       Exec Sql
            CALL QSYS2.QCMDEXC(:l_ClCmd);

       //Check and log Error.
       If SQLSTATE <> SQL_ALL_OK;
          //Log Error
       EndIf;

       //Delete generated spool file.
       @pr_DltSplFle(C01_SRCMBR);

       //Change object owner.
       @pr_ChgObjOwn(C01_OBJLIB:C01_SRCMBR:C01_OBJTYP);

       //Fetch next row of cursor C01.
       Exec Sql
         Fetch C01 into :g_C01Ds;

   EndDo;

   //Close cursor C01.
   Exec Sql
     Close  C01;

End-Proc  @pr_CmplRefPF;
//-------------------------------------------------------------------------------------//
//Compile source type 'PFSQL'.                                                         //
//-------------------------------------------------------------------------------------//
Dcl-Proc  @pr_CmplPFSQL;
   Dcl-PI @pr_CmplPFSQL;
   End-PI @pr_CmplPFSQL;

   //Declaring local variables.
   Dcl-S l_ClCmd  char(500);

   //Declare cursor C02.
   Exec Sql
     Declare C02 cursor for
        Select *
        From   CUCTRLPF
        Where  CUSRCTYP = 'PFSQL'
        for read only;

   //Open cursor C02.
   Exec Sql
     Open C02;

   //Fetch first row of cursor C02.
   Exec Sql
     Fetch C02 into :g_C02Ds;

   //Do until all rows of cursor C02 are processed.
   DoW SQLSTATE = SQL_ALL_OK;

       //Prepare CL Command.
       l_CLCmd = 'RUNSQLSTM SRCFILE(' + %trim(C02_SRCLIB) + '/' + %trim(C02_SRCFLE) +
                 ') SRCMBR(' + %trim(C02_SRCMBR) + ') COMMIT(*NONE) DFTRDBCOL(' +
                 %trim(C02_OBJLIB) + ')';

       //Call QCMDEXC.
       Exec Sql
            CALL QSYS2.QCMDEXC(:l_ClCmd);

       //Check and log Error.
       If SQLSTATE <> SQL_ALL_OK;
          //Log Error
       EndIf;

       //Delete generated spool file.
       @pr_DltSplFle(C02_SRCMBR);

       //Change object owner.
       @pr_ChgObjOwn(C02_OBJLIB:C02_SRCMBR:C02_OBJTYP);

       //Fetch next row of cursor C02.
       Exec Sql
         Fetch C02 into :g_C02Ds;

   EndDo;

   //Close cursor C02.
   Exec Sql
     Close C02;

End-Proc  @pr_CmplPFSQL;
//-------------------------------------------------------------------------------------//
//Compile source type 'PF'.                                                            //
//-------------------------------------------------------------------------------------//
Dcl-Proc  @pr_CmplPF;
   Dcl-PI @pr_CmplPF;
   End-PI @pr_CmplPF;

   //Declaring local variables.
   Dcl-S l_ClCmd  char(500);

   //Declare cursor C03.
   Exec Sql
     Declare C03 cursor for
        Select *
        From   CUCTRLPF
        Where  CUSRCTYP = 'PF'
          and  CUSRCMBR <> 'FLDREFPF'
        for read only;

   //Open cursor C03.
   Exec Sql
     Open C03;

   //Fetch first row of cursor C03.
   Exec Sql
     Fetch C03 into :g_C03Ds;

   //Do until all rows of cursor C03 are processed.
   DoW SQLSTATE = SQL_ALL_OK;

       l_CLCmd = 'CRTPF FILE(' + %trim(C03_OBJLIB) + '/' + %trim(C03_SRCMBR) +
                 ') SRCFILE(' + %trim(C03_SRCLIB) + '/' + %trim(C03_SRCFLE) +
                 ') SRCMBR(' + %trim(C03_SRCMBR) + ')';

       //Call QCMDEXC.
       Exec Sql
            CALL QSYS2.QCMDEXC(:l_ClCmd);

       //Check and log Error.
       If SQLSTATE <> SQL_ALL_OK;
          //Log Error
       EndIf;

       //Delete generated spool file.
       @pr_DltSplFle(C03_SRCMBR);

       //Change object owner.
       @pr_ChgObjOwn(C03_OBJLIB:C03_SRCMBR:C03_OBJTYP);

       //Fetch next row of cursor C03.
       Exec Sql
         Fetch C03 into :g_C03Ds;

   EndDo;

   //Close cursor C03.
   Exec Sql
     Close C03;

End-Proc  @pr_CmplPF;
//-------------------------------------------------------------------------------------//
//Compile source type 'LF'.                                                            //
//-------------------------------------------------------------------------------------//
Dcl-Proc  @pr_CmplLF;
   Dcl-PI @pr_CmplLF;
   End-PI @pr_CmplLF;

   //Declaring local variables.
   Dcl-S l_ClCmd  char(500);

   //Declare cursor C04.
   Exec Sql
     Declare C04 cursor for
        Select *
        From   CUCTRLPF
        Where  CUSRCTYP = 'LF'
        for read only;

   //Open cursor C04.
   Exec Sql
     Open C04;

   //Fetch first row of cursor C04.
   Exec Sql
     Fetch C04 into :g_C04Ds;

   //Do until all rows of cursor C04 are processed.
   DoW SQLSTATE = SQL_ALL_OK;

       l_CLCmd = 'CRTLF FILE(' + %trim(C04_OBJLIB) + '/' + %trim(C04_SRCMBR) +
                 ') SRCFILE(' + %trim(C04_SRCLIB) + '/' + %trim(C04_SRCFLE) +
                 ') SRCMBR(' + %trim(C04_SRCMBR) + ')';

       //Call QCMDEXC.
       Exec Sql
            CALL QSYS2.QCMDEXC(:l_ClCmd);

       //Check and log Error.
       If SQLSTATE <> SQL_ALL_OK;
          //Log Error
       EndIf;

       //Delete generated spool file.
       @pr_DltSplFle(C04_SRCMBR);

       //Change object owner.
       @pr_ChgObjOwn(C04_OBJLIB:C04_SRCMBR:C04_OBJTYP);

       //Fetch next row of cursor C04.
       Exec Sql
         Fetch C04 into :g_C04Ds;

   EndDo;

   //Close cursor C04.
   Exec Sql
     Close C04;

End-Proc  @pr_CmplLF;
//-------------------------------------------------------------------------------------//
//Compile source type 'DSPF'.                                                          //
//-------------------------------------------------------------------------------------//
Dcl-Proc  @pr_CmplDSPF;
   Dcl-PI @pr_CmplDSPF;
   End-PI @pr_CmplDSPF;

   //Declaring local variables.
   Dcl-S l_ClCmd  char(500);

   //Declare cursor C05.
   Exec Sql
     Declare C05 cursor for
        Select *
        From   CUCTRLPF
        Where  CUSRCTYP = 'DSPF'
        for read only;

   //Open cursor C05.
   Exec Sql
     Open C05;

   //Fetch first row of cursor C05.
   Exec Sql
     Fetch C05 into :g_C05Ds;

   //Do until all rows of cursor C05 are processed.
   DoW SQLSTATE = SQL_ALL_OK;

       //Prepare Cl Command.
       l_CLCmd = 'CRTDSPF FILE(' + %trim(C05_OBJLIB) + '/' + %trim(C05_SRCMBR) +
                 ') SRCFILE(' + %trim(C05_SRCLIB) + '/' + %trim(C05_SRCFLE) +
                 ') SRCMBR(' + %trim(C05_SRCMBR) + ') RSTDSP(*YES)';

       if C05_GENSCT <> *Blanks;
           l_CLCmd = %trim(l_CLCmd) + %trim(C05_GENSCT);
       endif;

       //Call QCMDEXC.
       Exec Sql
            CALL QSYS2.QCMDEXC(:l_ClCmd);

       //Check and log Error.
       If SQLSTATE <> SQL_ALL_OK;
          //Log Error
       EndIf;

       //Delete generated spool file.
       @pr_DltSplFle(C05_SRCMBR);

       //Change object owner.
       @pr_ChgObjOwn(C05_OBJLIB:C05_SRCMBR:C05_OBJTYP);

       //Fetch next row of cursor C05.
       Exec Sql
         Fetch C05 into :g_C05Ds;

   EndDo;

   //Close cursor C05.
   Exec Sql
     Close C05;

End-Proc  @pr_CmplDSPF;
//-------------------------------------------------------------------------------------//
//Compile source type 'PRTF'.                                                          //
//-------------------------------------------------------------------------------------//
Dcl-Proc  @pr_CmplPRTF;
   Dcl-PI @pr_CmplPRTF;
   End-PI @pr_CmplPRTF;

   //Declaring local variables.
   Dcl-S l_ClCmd  char(500);

   //Declare cursor C06.
   Exec Sql
     Declare C06 cursor for
        Select *
        From   CUCTRLPF
        Where  CUSRCTYP = 'PRTF'
        for read only;

   //Open cursor C06.
   Exec Sql
     Open C06;

   //Fetch first row of cursor C06.
   Exec Sql
     Fetch C06 into :g_C06Ds;

   //Do until all rows of cursor C06 are processed.
   DoW SQLSTATE = SQL_ALL_OK;

       l_CLCmd = 'CRTPRTF FILE(' + %trim(C06_OBJLIB) + '/' + %trim(C06_SRCMBR) +
                 ') SRCFILE(' + %trim(C06_SRCLIB) + '/' + %trim(C06_SRCFLE) +
                 ') SRCMBR(' + %trim(C06_SRCMBR) + ')';

       if C06_GENSCT <> *Blanks;
           l_CLCmd = %trim(l_CLCmd) + %trim(C06_GENSCT);
       endif;


       //Call QCMDEXC.
       Exec Sql
            CALL QSYS2.QCMDEXC(:l_ClCmd);

       //Check and log Error.
       If SQLSTATE <> SQL_ALL_OK;
          //Log Error
       EndIf;

       //Delete generated spool file.
       @pr_DltSplFle(C06_SRCMBR);

       //Change object owner.
       @pr_ChgObjOwn(C06_OBJLIB:C06_SRCMBR:C06_OBJTYP);

       //Fetch next row of cursor C06.
       Exec Sql
         Fetch C06 into :g_C06Ds;

   EndDo;

   //Close cursor C06, if open.
   Exec Sql
     Close C06;

End-Proc  @pr_CmplPRTF;
//-------------------------------------------------------------------------------------//
//Copy Files with Data.                                                                //
//-------------------------------------------------------------------------------------//
Dcl-Proc  @pr_CpyFilesWithData;
   Dcl-PI @pr_CpyFilesWithData;
   End-PI @pr_CpyFilesWithData;

   //Declaring local variables.
   Dcl-S l_ClCmd   char(500)  inz;
   Dcl-S l_ArrFile char(010)  dim(04);
   Dcl-S l_File    char(010)  inz;
   Dcl-S l_Lib     char(010)  inz;
   Dcl-S l_OldLib  char(010)  inz;
   Dcl-S l_Idx     zoned(2:0) inz;
   Dcl-S l_ToElem  zoned(2:0) inz;

   //Fill local array with file names that needs to be copied with data.
   l_ArrFile(1) = 'IAEMAILPF' ;
   l_ArrFile(2) = 'IADUPOBJ'  ;
   l_ArrFile(3) = 'AIAUTCTLP' ;
   l_ArrFile(4) = 'IAINPLIB'  ;

   If g_Devlpr  = 'Y';
      l_ToElem  = 4;
   Else;
      l_ToElem  = 2;
   EndIf;

   For l_Idx    = 1 to l_ToElem;
       l_File   = l_ArrFile(l_Idx);

       //Find object library form main control file.
       Exec Sql
         Select CUOBJLIB
           into :l_Lib
           From CUCTRLPF
          Where CUOBJNAM = trim(:l_File);

       l_OldLib = %trim(l_Lib)          + 'OLD';
       l_ClCmd  = 'CPYF FROMFILE('      + %trim(l_OldLib)
                + '/'                   + %trim(l_File)
                +') TOFILE('            + %trim(l_Lib)
                + '/'                   + %trim(l_File)
                + ') MBROPT(*REPLACE)';

       //Call QCMDEXC.
       Exec Sql
            CALL QSYS2.QCMDEXC(:l_ClCmd);

       //Check and log Error.
       If SQLSTATE <> SQL_ALL_OK;
          //Log Error
       EndIf;
   EndFor;

End-Proc  @pr_CpyFilesWithData;
//-------------------------------------------------------------------------------------//
//Create duplicate object for MSGF/JOBD/JOBQ/OUTQ/DTAARA/BNDDIR                        //
//-------------------------------------------------------------------------------------//
Dcl-Proc  @pr_CrtDupObj;
   Dcl-PI @pr_CrtDupObj;
   End-PI @pr_CrtDupObj;

   //Declaring local variables.
   Dcl-S l_ClCmd  char(500)        inz;
   Dcl-S l_OldLib like(C07_OBJLIB) inz;

   //Declare cursor C07.
   Exec Sql
     Declare C07 cursor for
        Select *
        From   CUCTRLPF
        Where  CUOBJTYP = '*MSGF'
           or  CUOBJTYP = '*JOBD'
           or  CUOBJTYP = '*JOBQ'
           or  CUOBJTYP = '*OUTQ'
           or  CUOBJTYP = '*DTAARA'
           or  CUOBJTYP = '*BNDDIR'
        for read only;

   //Open cursor C07.
   Exec Sql
     Open C07;

   //Fetch first row of cursor C07.
   Exec Sql
     Fetch C07 into :g_C07Ds;

   //Do until all rows of cursor C07 are processed.
   DoW SQLSTATE = SQL_ALL_OK;

       l_OldLib = %trim(C07_OBJLIB)  + 'OLD';
       l_CLCmd  = 'CRTDUPOBJ OBJ('   + %trim(C07_OBJNAM)
                + ') FROMLIB('       + %trim(l_OldLib)
                + ') OBJTYPE('       + %trim(C07_OBJTYP)
                + ') TOLIB('         + %trim(C07_OBJLIB)
                + ')';

       //Call QCMDEXC.
       Exec Sql
            CALL QSYS2.QCMDEXC(:l_ClCmd);

       //Check and log Error.
       If SQLSTATE <> SQL_ALL_OK;
          //Log Error
       EndIf;

       //Change object owner.
       @pr_ChgObjOwn(C07_OBJLIB:C07_OBJNAM:C07_OBJTYP);

       //Fetch next row of cursor C07.
       Exec Sql
         Fetch C07 into :g_C07Ds;

   EndDo;

   //Close cursor C07, if open.
   Exec Sql
     Close C07;

End-Proc  @pr_CrtDupObj;
//-------------------------------------------------------------------------------------//
//Change object owner.                                                                 //
//-------------------------------------------------------------------------------------//
Dcl-Proc  @pr_ChgObjOwn;
   Dcl-PI @pr_ChgObjOwn;
      Dcl-Parm in_ObjLib char(10) const;
      Dcl-Parm in_ObjNam char(10) const;
      Dcl-Parm in_ObjTyp char(08) const;
   End-PI @pr_ChgObjOwn;

   //Declaring local variables.
   Dcl-S l_ClCmd  char(500);

   l_CLCmd = 'CHGOBJOWN OBJ(' + %trim(in_ObjLib) + '/' + %trim(in_ObjNam) +
             ') OBJTYPE(' + %trim(in_ObjTyp) + ') NEWOWN(QPGMR)';

   //Call QCMDEXC.
   Exec Sql
        CALL QSYS2.QCMDEXC(:l_ClCmd);

   //Check and log Error.
   If SQLSTATE <> SQL_ALL_OK;
      //Log Error
   EndIf;

End-Proc  @pr_ChgObjOwn;
//-------------------------------------------------------------------------------------//
//Delete spool file.                                                                   //
//-------------------------------------------------------------------------------------//
Dcl-Proc  @pr_DltSplFle;
   Dcl-PI @pr_DltSplFle;
      Dcl-Parm in_SplFleNam char(10) const;
   End-PI @pr_DltSplFle;

   //Declaring local variables.
   Dcl-S l_ClCmd  char(500);

   l_CLCmd = 'DLTSPLF FILE(' + %trim(in_SplFleNam) + ') SPLNBR(*LAST)';

   //Call QCMDEXC.
   Exec Sql
        CALL QSYS2.QCMDEXC(:l_ClCmd);

   //Check and log Error.
   If SQLSTATE <> SQL_ALL_OK;
      //Log Error
   EndIf;

End-Proc  @pr_DltSplFle;
