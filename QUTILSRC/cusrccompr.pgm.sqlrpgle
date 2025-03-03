**free
      //%METADATA                                                      *
      // %TEXT CU Module,SrvPgm,Pgm,Cmd compilation                    *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------ //
//CREATED BY : Programmers.io @ 2022                                                   //
//CREATE DATE: 2022/02/04                                                              //
//DEVELOPER  : Yogesh Chandra, Ashwani Kumar                                           //
//DESCRIPTION: Compilation utility based on main control file.                         //
//                                                                                     //
//PROCEDURE LOG:                                                                       //
//------------------------------------------------------------------------------------ //
//Procedure Name           | Procedure Description                                     //
//-------------------------|---------------------------------------------------------- //
//@pr_ComplMod             | Compile Modules - '*MODULE'.                              //
//@pr_ComplSrv             | Compile service programs - '*SRVPGM'.                     //
//GetDependObj             | Get dependable objects.                                   //
//@pr_ComplPgm             | Compile program - '*PGM'.                                 //
//@pr_ExpSource            | Expire Source.                                            //
//ExecuteCmd               | Execute Command - 'QCMDEXC'.                              //
//@pr_CrtCmdObj            | Create Command Object.                                    //
//@pr_DltSplFle            | Delete generated spool file.                              //
//@pr_ChgObjOwn            | Change object owner.                                      //
//@pr_GrtObjAut            | Grant object authority.                                   //
//------------------------------------------------------------------------------------ //
//                                                                                     //
//MODIFICATION LOG:                                                                    //
//------------------------------------------------------------------------------------ //
//Date    | Mod_ID | Developer  | Case and Description                                 //
//--------|--------|------------|----------------------------------------------------- //
//        |        |            |                                                      //
//------------------------------------------------------------------------------------ //

//h-spec
ctl-opt CopyRight('Copyright @ Programmers.io @ 2022');
ctl-opt Option(*NoDebugIo:*SrcStmt:*NoUnRef)
        DftActGrp(*No)
        ActGrp(*Caller);

//Main program prototypes
dcl-pi MainPgm    extpgm('CUSRCCOMPR');
end-pi;

dcl-pr ExecuteCmd extpgm('QCMDEXC');
   *n  char(250)    options(*varsize) const ;
   *n  packed(15:5) const ;
end-pr ;

dcl-pr WritePgmD  extpgm('CUWRTPGMD');
end-pr;

//Data structure declaration.
dcl-ds CompilePrmDs ExtName('CUCTRLPF')
end-ds;

//Data Area structure.
dcl-ds AICTLDTA  len(200) Dtaara('AICTLDTA');
   dcl-subf g_SrcLib    char(10) pos(01);
   dcl-subf g_DtaLib    char(10) pos(11);
   dcl-subf g_ObjLib    char(10) pos(21);
   dcl-subf g_DbgView   char(10) pos(61);
   dcl-subf g_ExpInDays char(02) pos(99);
   dcl-subf g_TgtRls    char(10) pos(101);
end-ds;

//Standalone variables.
dcl-s Command       varchar(250);
dcl-s Length        packed(15:5);
dcl-s w_DbgView     char(20);
dcl-s ObjLib        char(10);

//Constant declaration
dcl-c c_Slash       Const('/');
dcl-c c_space       Const(' ');
dcl-c ClsBrcs       Const(')');
dcl-c OpnBrcs       Const('(');
dcl-c c_DbgView     Const(' DBGVIEW');
dcl-c SQL_ALL_OK    Const('00000');
//-------------------------------------------------------------------------------------//
//Mainline programming                                                                 //
//-------------------------------------------------------------------------------------//
//Set processing options to be used for SQL Statements in program.
Exec Sql
  Set Option Commit    = *None,
             Naming    = *Sys,
             UsrPrf    = *User,
             DynUsrPrf = *User,
             CloSqlCsr = *EndMod;
*inLR = *On;

//Read and lock DTAARA.
in AICTLDTA;
w_DbgView = c_DbgView + OpnBrcs + %Trim(g_DbgView) + ClsBrcs;

//Compile source types to generate '*MODULE'.
@pr_ComplMod();
//Compile source types to generate '*SRVPGM'.
@pr_ComplSrv();
//Compile source types to generate '*SRVPGM', once again.
@pr_ComplSrv();
//Compile source types to generate '*PGM'.
@pr_ComplPgm();
//Change expiration date of 'PF-DTA'.
//if g_ExpInDays <> *Blanks;
//   @pr_ExpSource();
//endif;
//Create *CMD object.
@pr_CrtCmdObj();
//Grant object authority.
@pr_GrtObjAut();

return;
//-------------------------------------------------------------------------------------//
//Create module                                                                        //
//-------------------------------------------------------------------------------------//
dcl-proc @pr_ComplMod;
dcl-pi   @pr_ComplMod;
end-pi   @pr_ComplMod;

//Local constant declaration.
dcl-c CompileCmd const('CRTSQLRPGI ' );
dcl-c ObjName    const('OBJ(');
dcl-c SrcFile    const(' SRCFILE(');
dcl-c ObjTyp     const(' OBJTYPE(*MODULE)');

//Local stanalone declaration.
dcl-s l_Error    ind;

//Declare cursor 'CurMod'.
exec sql
  declare CurMod Cursor for
   select *
     from CUCTRLPF
    where CUOBJTYP = '*MODULE';

//Open cursor 'CurMod'.
exec sql
  open CurMod;

//Fetch first row of cursor 'CurMod'.
exec sql
  Fetch CurMod into :CompilePrmDs;

dow SQLCODE <> 100;
   l_Error = *Off;
   //Prepare Cl Command.
   Command = CompileCmd +
             ObjName + %trim(CUOBJLIB) + C_Slash +
             %Trim(CUOBJNAM) + ClsBrcs +
             SrcFile + %Trim(CUSRCLIB) +
             C_Slash + %Trim(CUSRCFLE) + ClsBrcs +
             ObjTyp  + w_DbgView ;

   if g_TgtRls <> *Blanks;
      Command = %trim(Command) + ' TGTRLS(' + %trim(g_TgtRls) + ')';
   endif;

   monitor;
      ExecuteCmd(Command:%len(%trimr(Command))) ;
   on-error;
      l_Error = *on;
      //On error update main control file sucess field as 'N'.
      exec Sql
        update CUCTRLPF
           set CUSUCESS = 'N'
         where CUOBJNAM = :CUOBJNAM
           and CUOBJTYP = :CUOBJTYP;

      //Delete generated spool file.
      @pr_DltSplFle(CUOBJNAM);
      //Delete generated spool file, twice for '*MODULE'.
      @pr_DltSplFle(CUOBJNAM);
      //Delete generated spool file, thrice for '*MODULE'.
      @pr_DltSplFle(CUOBJNAM);
   endmon;
   //On success update main control file sucess field as 'Y'.
   if not l_Error;
      exec Sql
        update CUCTRLPF
           set CUSUCESS = 'Y'
         where CUOBJNAM = :CUOBJNAM
           and CUOBJTYP = :CUOBJTYP;

      //Delete generated spool file.
      @pr_DltSplFle(CUOBJNAM);
      //Delete generated spool file, twice for '*MODULE'.
      @pr_DltSplFle(CUOBJNAM);
      //Delete generated spool file, thrice for '*MODULE'.
      @pr_DltSplFle(CUOBJNAM);
      //Change object owner.
      @pr_ChgObjOwn(CUOBJLIB:CUOBJNAM:CUOBJTYP);

   endif;

   //Fetch next row of cursor 'CurMod'.
   exec sql
     fetch from CurMod into :CompilePrmDs;
enddo;
//Close cursor 'CurMod'.
exec sql
  close CurMod;

end-proc @pr_ComplMod;
//-------------------------------------------------------------------------------------//
//Create Service program                                                               //
//-------------------------------------------------------------------------------------//
dcl-proc @pr_ComplSrv;
dcl-pi   @pr_ComplSrv;
end-pi   @pr_ComplSrv;

//Local constant declaration.
dcl-c  c_CrtsrvPgm  const('CRTSRVPGM SRVPGM');
dcl-c  c_Module     const('MODULE');
dcl-c  c_SrcFile    const('SRCFILE');
dcl-c  c_SrcMBr     const('SRCMBR');
dcl-c  c_BndSrvPgm  const('BNDSRVPGM');
dcl-c  c_BndDir     const('BNDDIR');
dcl-c  c_Option     const(' OPTION(*DUPPROC *DUPVAR) ');

//Local standalone declaration.
dcl-s  l_Error      ind;
dcl-s  w_CUOBJNAM   char(010);
dcl-s  ModuleList   char(100);
dcl-s  SrvList      char(100);
dcl-s  w_ObjTyp     char(010);
dcl-s  w_SrvPgm     char(100);
dcl-s  w_Module     char(100);
dcl-s  w_SrcFile    char(100);
dcl-s  w_SrcMbr     char(100);
dcl-s  w_BndSrvPgm  char(100);
dcl-s  w_SRVOBJLIB  char(010);

//Declare cursor 'cur_GetSrvPgm'.
exec sql
  declare cur_GetSrvPgm Cursor for
   select CUOBJNAM
     from CUCTRLPF
    where CUOBJTYP = '*SRVPGM';

//Open cursor 'cur_GetSrvPgm'.
exec sql
  open Cur_GetSrvPgm;

//Fetch first row cursor 'cur_GetSrvPgm'.
exec sql
  fetch cur_GetSrvPgm into :w_cuObjNam;

dow SQLCODE   <> 100;
    w_ObjTyp   = '*MODULE';
    ModuleList = GetDependObj(w_CUOBJNAM:w_ObjTyp);

    w_ObjTyp   = '*SRVPGM';
    SrvList    = GetDependObj(w_CUOBJNAM:w_ObjTyp);

    exec sql
      select CUOBJLIB into :w_SrvObjLib
        from CUCTRLPF
       where CUOBJNAM = :w_CUOBJNAM
         and CUOBJTYP = :w_ObjTyp;

    //Prepare Cl Command.
    w_SrvPgm    = c_CrtSrvPgm + OpnBrcs + %Trim(w_SrvObjLib) +
                  c_Slash     + %Trim(w_CUOBJNAM) + ClsBrcs;
    w_Module    = c_Module  + OpnBrcs + %Trim(ModuleList) + ClsBrcs;
    w_SrcFile   = c_SrcFile + OpnBrcs + '*libl/QMODSRC'   + ClsBrcs;
    w_SrcMbr    = c_srcMbr  + OpnBrcs +
                  %Trim(%ScanRpl('SV':'BN':w_CUOBJNAM))   + ClsBrcs;
    w_BndSrvPgm = c_BndSrvPgm + OpnBrcs + %trim(SrvList)  + ClsBrcs;
    Command     = %Trim(w_SrvPgm)    + C_Space +
                  %Trim(w_Module)    + C_Space +
                  %Trim(w_SrcFile)   + C_Space +
                  %Trim(w_SrcMbr)    + C_Space +
                  %Trim(w_BndSrvPgm) + C_Space +
                  %Trim(c_Option);

    if g_TgtRls <> *Blanks;
       Command  = %trim(Command) + ' TGTRLS(' + %trim(g_TgtRls) + ')';
    endif;

    l_Error     = *off;

    monitor;
       ExecuteCmd(Command:%len(%trimr(Command))) ;
    on-error;
       l_Error  = *on;
       exec sql
         update CUCTRLPF
            set CUSUCESS = 'N'
          where CUOBJNAM = :w_CUOBJNAM
            and CUOBJTYP = :w_OBJTYP;

       //Delete generated spool file for '*SRVPGM'.
       @pr_DltSplFle(CUOBJNAM);
       //Delete generated spool file, twice for '*SRVPGM'.
       @pr_DltSplFle(CUOBJNAM);
       //Delete generated spool file, thrice for '*SRVPGM'.
       @pr_DltSplFle(CUOBJNAM);

    endmon;

    if not l_Error;
       exec sql
         update CUCTRLPF
            set CUSUCESS = 'Y'
          where CUOBJNAM = :w_CUOBJNAM
            and CUOBJTYP = :w_OBJTYP;

       //Delete generated spool file for '*SRVPGM'.
       @pr_DltSplFle(CUOBJNAM);
       //Delete generated spool file, twice for '*SRVPGM'.
       @pr_DltSplFle(CUOBJNAM);
       //Delete generated spool file, thrice for '*SRVPGM'.
       @pr_DltSplFle(CUOBJNAM);

       //Change object owner.
       @pr_ChgObjOwn(CUOBJLIB:CUOBJNAM:CUOBJTYP);

    endif;

    //Fetch next row cursor 'cur_GetSrvPgm'.
    exec sql
      fetch cur_GetSrvPgm into :w_CuObjNam;
enddo;
//Close cursor 'cur_GetSrvPgm'.
exec sql
  close cur_GetSrvPgm;

end-proc @pr_ComplSrv;
//-------------------------------------------------------------------------------------//
//Get dependable object                                                                //
//-------------------------------------------------------------------------------------//
dcl-proc GetDependObj;
dcl-pi *n char(100);
  w_ObjName  char(10);
  w_ObjType  char(10);
end-pi;

//Local constant declaration.
dcl-c c_ModLib  Const(' *LIBL/');

//Local standalone variables.
dcl-s c_SrvPgm  char(010) inz('*SRVPGM');
dcl-s w_ObjList char(100);
dcl-s w_stmt    char(500);
dcl-s w_ModName char(010);

w_Stmt = 'select distinct MOD_NAME from CUPGMINF +
           where PGM_NAME = ? +
             and PGM_TYP = ? and MOD_TYP = ?';

exec sql
  prepare stmt from :w_stmt;

exec sql
  declare cur_ObjList Cursor for Stmt;

exec sql
  open cur_ObjList using :w_ObjName,:c_SrvPgm,:w_ObjType;

exec sql
  fetch cur_ObjList into :w_ModName;

dow SQLCODE <> 100;
  w_ObjList = %Trim(w_ObjList)+c_ModLib+%Trim(w_ModName);
Exec sql
  Fetch cur_ObjList into :w_ModName;
EndDo;
Exec sql
  Close cur_ObjList;
return   w_ObjList;

end-proc;
//-------------------------------------------------------------------------------------//
//Create program object                                                                //
//-------------------------------------------------------------------------------------//
dcl-proc @pr_ComplPgm;
dcl-pi   @pr_ComplPgm;
end-pi   @pr_ComplPgm;

dcl-c  c_CrtCllePgm      const('CRTBNDCL PGM');
dcl-c  c_CrtRPGLEPgm     Const('CRTBNDRPG PGM');
dcl-c  c_CrtSQLRPGLEPgm  Const('CRTSQLRPGI OBJ');
dcl-c  c_Module          Const('MODULE');
dcl-c  c_SrcFile         Const('SRCFILE');
dcl-c  c_SrcMBr          Const('SRCMBR');
dcl-c  c_Option          Const(' OPTION(*DUPPROC *DUPVAR) ');
dcl-c  c_ObjType         Const(' OBJTYPE(*PGM)');

dcl-s  l_Error           ind;
dcl-s  w_CrtPgm          char(010);
dcl-s  w_CUOBJNAM        char(010);
dcl-s  ModuleList        char(100);
dcl-s  SrvList           char(100);
dcl-s  w_ObjTyp          char(010);
dcl-s  w_SrvPgm          char(100);
dcl-s  w_Module          char(100);
dcl-s  w_SrcFile         char(100);
dcl-s  w_SrcMbr          char(100);
dcl-s  w_BndSrvPgm       char(100);
dcl-s  w_BndDir          char(100);
dcl-s  w_PgmObjLib       char(010);

exec sql
  declare cur_GetPgm cursor for
   select *
     from CUCTRLPF
    where CUOBJTYP = '*PGM';

exec sql
  open cur_GetPgm;

clear CompilePrmDs;

exec sql
  fetch cur_GetPgm into :CompilePrmDs;

dow SQLCODE   <> 100;
    w_ObjTyp   = '*MODULE';
    ModuleList = GetDependObj(w_CUOBJNAM:w_ObjTyp);

    w_ObjTyp   = '*SRVPGM';
    SrvList    = GetDependObj(w_CUOBJNAM:w_ObjTyp);

    //Prepare CL Command
    clear Command;
    select;
    when CUSRCTYP = 'CLLE';
       Command =  c_CrtCllePgm + OpnBrcs + %trim(CuObjLib) + c_Slash+
                  %trim(CUOBJNAM) + ClsBrcs +
                  c_Space +
                  c_SrcFile + OpnBrcs + %trim(CUSRCLIB) + c_Slash +
                  %trim(CUSRCFLE) + ClsBrcs+
                  c_Space +
                  c_SrcMBr +OpnBrcs + %trim(CUSRCMBR) + ClsBrcs +
                  c_Space + w_DbgView ;

       if g_TgtRls <> *Blanks;
          Command  = %trim(Command) + ' TGTRLS(' + %trim(g_TgtRls) + ')';
       endif;

    when CUSRCTYP = 'RPGLE';
       Command =  c_CrtRPGLEPgm +
                  OpnBrcs+%Trim(CuObjLib) + c_Slash +
                  %trim(CUOBJNAM) + ClsBrcs +
                  c_Space+
                  c_SrcFile + OpnBrcs + %trim(CUSRCLIB) + c_Slash +
                  %trim(CUSRCFLE) + ClsBrcs +
                  c_Space +
                  c_SrcMBr + OpnBrcs + %trim(CUSRCMBR) + ClsBrcs +
                  c_Space + w_DbgView ;

       if g_TgtRls <> *Blanks;
          Command  = %trim(Command) + ' TGTRLS(' + %trim(g_TgtRls) + ')';
       endif;

    when CUSRCTYP = 'SQLRPGLE';
       Command =  c_CrtSQLRPGLEPgm +
                  OpnBrcs+%Trim(CuObjLib) + C_Slash +
                  %trim(CUOBJNAM) + ClsBrcs +
                  c_Space +
                  c_SrcFile +OpnBrcs + %trim(CUSRCLIB)+C_Slash+
                  %trim(CUSRCFLE) + ClsBrcs+
                  c_Space +
                  c_SrcMBr + OPnBrcs + %trim(CUSRCMBR) + ClsBrcs+
                  c_Space + c_ObjType +
                  c_Space + w_DbgView ;

       if g_TgtRls <> *Blanks;
          Command  = %trim(Command) + ' TGTRLS(' + %trim(g_TgtRls) + ')';
       endif;

    endsl;
    l_Error = *off;
    monitor;
       ExecuteCmd(Command:%len(%trimr(Command))) ;
    on-error;
       l_Error = *on;
       exec sql
         update CUCTRLPF
            set CUSUCESS = 'N'
          where CUOBJNAM = :CUOBJNAM
            and CUOBJTYP = :CUOBJTYP;
       //Delete generated spool file for '*PGM'.
       @pr_DltSplFle(CUOBJNAM);
       //Delete generated spool file, twice for '*PGM'.
       @pr_DltSplFle(CUOBJNAM);
       //Delete generated spool file, thrice for '*PGM'.
       @pr_DltSplFle(CUOBJNAM);
    endmon;

    if not l_Error;
       exec sql
         update CUCTRLPF
            set CUSUCESS = 'Y'
          where CUOBJNAM = :CUOBJNAM
            and CUOBJTYP = :CUOBJTYP;

       //Delete generated spool file for '*PGM'.
       @pr_DltSplFle(CUOBJNAM);
       //Delete generated spool file, twice for '*PGM'.
       @pr_DltSplFle(CUOBJNAM);
       //Delete generated spool file, thrice for '*PGM'.
       @pr_DltSplFle(CUOBJNAM);
       //Change object owner.
       @pr_ChgObjOwn(CUOBJLIB:CUOBJNAM:CUOBJTYP);

    endif;

    exec Sql
      fetch Cur_GetPgm into :CompilePrmDs;
enddo;

exec sql
  close cur_GetPgm;

end-proc @pr_ComplPgm;
//-------------------------------------------------------------------------------------//
//Expire Source                                                                        //
//-------------------------------------------------------------------------------------//
dcl-proc  @pr_ExpSource;
   dcl-pi @pr_ExpSource;
   end-pi @pr_ExpSource;

   //Declaring local constants.
   dcl-c c_ChgPf   Const('CHGPF FILE');
   dcl-c c_ExpDate const('EXPDATE');

   //Declaring local variables.
   dcl-s w_Date    Date;
   dcl-s w_ExpDate char(10);
   dcl-s w_ObjLib  char(10);
   dcl-s w_ObjNam  char(10);

   //w_Date  = %date()+ %days(%int(g_ExpInDays));
   w_Date    = %date();
   w_ExpDate = %char(w_Date:*MDY0);

   exec sql
     declare cur_ExpDate cursor for
      select CUOBJLIB, CUOBJNAM
        from CUCTRLPF
       where (CUSRCTYP = 'PF'
          or CUSRCTYP = 'PFSQL')
         and CUOBJTYP = '*FILE';

   exec sql
     open cur_ExpDate;

   exec sql
     fetch cur_ExpDate into :w_ObjLib, :w_ObjNam;

   dow SQLCODE <> 100;
       Command = c_ChgPf + OpnBrcs + %trim(w_ObjLib) +
                 c_Slash + %trim(w_ObjNam) +
                 ClsBrcs + c_space +
                 c_ExpDate + OpnBrcs + %char(w_ExpDate) + ClsBrcs;
       Monitor;
          ExecuteCmd(Command:%len(%trimr(Command))) ;
       On-Error;
       EndMon;
       Exec Sql
         fetch cur_ExpDate into :w_ObjLib, :w_ObjNam;
   enddo;
   exec sql
      close cur_ExpDate;

end-proc @pr_ExpSource;
//-------------------------------------------------------------------------------------//
//Create *CMD object.                                                                  //
//-------------------------------------------------------------------------------------//
Dcl-Proc  @pr_CrtCmdObj;
   Dcl-PI @pr_CrtCmdObj;
   End-PI @pr_CrtCmdObj;

   //Declaring local variables.
   Dcl-S l_ClCmd  char(500);
   Dcl-S l_Tool   char(010) inz('AIPROD');
   Dcl-S l_ObjTyp char(010) inz('*CMD');

   l_CLCmd = 'CRTCMD CMD('                + %trim(g_ObjLib) +
             '/'                          + %trim(l_Tool)   +
             ') PGM('                     + %trim(g_ObjLib) +
             '/IADRVCL) SRCFILE('         + %trim(g_SrcLib) +
             '/QCLPSRC) SRCMBR('          + 'IATOOL'        +
             ')';

   //Call QCMDEXC.
   Exec Sql
        CALL QSYS2.QCMDEXC(:l_ClCmd);

   //Check and log Error.
   If SQLSTATE <> SQL_ALL_OK;
      //Log Error
   EndIf;

   //Delete generated spool file.
   @pr_DltSplFle('IATOOL');
   //Change object owner.
   @pr_ChgObjOwn(g_ObjLib:l_Tool:l_ObjTyp);

End-Proc  @pr_CrtCmdObj;
//-------------------------------------------------------------------------------------//
//Grant object authority.                                                              //
//-------------------------------------------------------------------------------------//
Dcl-Proc  @pr_GrtObjAut;
   Dcl-PI @pr_GrtObjAut;
   End-PI @pr_GrtObjAut;

   //Declaring local variables.
   Dcl-S l_ClCmd  char(500)  inz;
   Dcl-S l_ArrLib char(010)  dim(02);
   Dcl-S l_Lib    char(010)  inz;
   Dcl-S l_Idx    zoned(2:0) inz;

   //Fill local array with library names.
   l_ArrLib(1) = g_DtaLib;
   l_ArrLib(2) = g_ObjLib;

   For l_Idx   = 1 to %elem(l_ArrLib);
       l_Lib   = %trim(l_ArrLib(l_Idx));
       l_ClCmd = 'GRTOBJAUT OBJ(' + %trim(l_Lib)
               + '/*ALL) OBJTYPE(*ALL) USER(*PUBLIC) AUT(*ALL)';

       //Call QCMDEXC.
       Exec Sql
            CALL QSYS2.QCMDEXC(:l_ClCmd);

       //Check and log Error.
       If SQLSTATE <> SQL_ALL_OK;
          //Log Error
       EndIf;
   EndFor;

End-Proc  @pr_GrtObjAut;
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
