**FREE
      //%METADATA                                                      *
      // %TEXT iA Object exclusion for INIT                            *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------- //
//Created By    : Programmers.io @ 2021                                                 //
//Created Date  : 2023/01/24                                                            //
//Developer     : Himanshu Gahtori                                                      //
//Description   : INIT process:Remove excluded objects from tables capturing object     //
//              : entries.                                                              //
//Procedure Log :                                                                       //
//------------------------------------------------------------------------------------- //
//Procedure Name           | Procedure Description                                      //
//-------------------------|----------------------------------------------------------- //
//                         |                                                            //
//------------------------------------------------------------------------------------- //
//Modification Log:                                                                     //
//------------------------------------------------------------------------------------- //
//Date    | Developer  | Case and Description                                           //
//--------|------------|--------------------------------------------------------------- //
//06/06/24| Saumya     | Rename AIEXCTIMR to IAEXCTIMR [Task #262] (Tag 0001)           //
//04/10/23| Khushi W   | Rename AIEXCOBJS to IAEXCOBJS [Task #252] (Mod:0002)           //
//04/07/24| Akhil K.   | Rename AIERRBND, AICERRLOG, AIDERRLOG and AISQLDIAGNOSTIC with //
//        |            | IA* [Task #261] (Mod:0003)                                     //
// 16/08/24| Sabarish   | IFS Member Parsing Upgrade (Mod: 0004)                         //
//------------------------------------------------------------------------------------- //
ctl-opt copyright('Programmers.io Â© 2024');
ctl-opt option(*noDebugIo: *srcStmt: *noUnRef) expropts(*RESDECPOS);
ctl-opt bndDir('IAERRBND');                                                              //0003

//------------------------------------------------------------------------------------- //
//File declarations
//------------------------------------------------------------------------------------- //
//Exclusion file to capture the Excludeded objects
dcl-f IAEXCOBJS Disk Usage(*Input);                                                      //0002

//------------------------------------------------------------------------------------- //
//Variable declarations
//------------------------------------------------------------------------------------- //
dcl-s upPgm_Name        char(10)    inz;
dcl-s upLib_Name        char(10)    inz;
dcl-s upSrc_Name        char(10)    inz;
dcl-s Wk_WildCard       Char(10);

dcl-s wk_Position       Zoned(2);

dcl-s upTimeStamp       Timestamp;

//------------------------------------------------------------------------------------- //
//Constant Variable declarations
//------------------------------------------------------------------------------------- //
dcl-c File              Const('*FILE');
dcl-c Yes               Const('Y');
dcl-c Quote             Const('''');
dcl-c Space             Const(' ');

//------------------------------------------------------------------------------------- //
//Prototype declarations
//------------------------------------------------------------------------------------- //
dcl-pr IAEXCTIMR Extpgm('IAEXCTIMR');                                                    //0001
   *n Char(10) Const;
   *n Char(10);
   *n Char(10);
   *n Char(10) Const;
   *n Char(10);
   *n Char(10);
   *n Char(10);
   *n Char(100) Const;                                                                   //0004
   *n Char(10) Const;
   *n Timestamp;
   *n Char(6) Const;
end-pr;

//------------------------------------------------------------------------------------- //
//CopyBook declarations
//------------------------------------------------------------------------------------- //
/copy 'QCPYSRC/iaderrlog.rpgleinc'

//------------------------------------------------------------------------------------- //
//Entry Parameter
//------------------------------------------------------------------------------------- //
dcl-Pi IAEXCOBJR  Extpgm('IAEXCOBJR');
   upxref char(10);
end-Pi;

//------------------------------------------------------------------------------------- //
//Set SQL options
//------------------------------------------------------------------------------------- //
exec sql
   Set option Commit    =  *None,
              Naming    =  *Sys,
              UsrPrf    =  *User,
              DynUsrPrf =  *User,
              CloSqlCsr =  *EndMod;

//------------------------------------------------------------------------------------- //
//Main Logic
//------------------------------------------------------------------------------------- //
eval-Corr uDpsds = wkuDpsds;

//To capture the process start time
upTimeStamp = %Timestamp();

callP IAEXCTIMR('IAINIT' :udpsds.ProcNme : udpsds.Lib : '*PGM' :                         //0001
                upsrc_name : uppgm_name : uplib_name : ' ' :
                //uptimeStamp : 'INSERT');                                               //0004
                ' ' : uptimeStamp : 'INSERT');                                           //0004

//Get the Excluded object details from Exclusion control file.
setll *Start IAEXCOBJS;                                                                  //0002
read iAExcObjs;                                                                          //0002
dow not %eof(iAExcObjs);                                                                 //0002

   wk_Position  =  *Zero;
   wk_WildCard  =  *Blanks;

   //If it is wildcard, get the position of "*"
   wk_Position  =  %scan('*' : Iaoobjnam);

   if wk_Position > 1;
      wk_WildCard  =  %subst(iAOObjNam : 1 : wk_Position-1);
   endif;

   //Delete the excluded object from all the related files.
   deleteExcludedObjects();

   read iAExcObjs;                                                                       //0002

enddo;

//Capture process end time
upTimeStamp = %Timestamp();
callP IAEXCTIMR('IAINIT' :udpsds.ProcNme : udpsds.Lib : '*PGM' :                         //0001
                upsrc_name : uppgm_name : uplib_name : ' ' :
                //uptimeStamp : 'UPDATE');                                               //0004
                ' ' : uptimeStamp : 'UPDATE');                                           //0004

*inlr = *on;
return;

/copy 'QCPYSRC/iacerrlog.rpgleinc'

//------------------------------------------------------------------------------------- //
//Procedure : DeleteExcludedObjects
//Delete the entries of excluded objects from relevent tables
//------------------------------------------------------------------------------------- //
dcl-proc deleteExcludedObjects;

  dcl-s sqlStmt char(1000) inz;

  //For *File object types.
  if Iaoobjtyp  =  FILE or Iaoobjtyp  =  *Blanks;

     //Delete entry from file IDSPFDBASA.
     sqlStmt =  'Delete from IDSPFDBASA Where';
     if wk_WildCard  <> *Blanks;
        sqlStmt =  %trim(sqlStmt) + Space + 'Substr(ATFILE,1,'              +
                   %char(wk_Position) + ') = ' + Quote + %trim(Wk_WildCard) +
                   Quote;
     else;
        sqlStmt =  %trim(sqlStmt) + Space + 'ATFILE='+ Quote + %trim(iAOObjNam)
                   + Quote;
     endif;

     //If Lib provided
     if iAOObjLib <> *Blanks;
        sqlStmt =  %trim(sqlStmt) + Space + 'And ATLIB='  +  Quote  +
                   %trim(IAOOBJLIB) + Quote;
     endif;

     exec sql execute immediate :sqlStmt;

     if SqlCode < SuccessCode;
        uDpsds.wkQuery_Name = 'Delete_IDSPFDBASA';
        IaSqlDiagnostic(uDpsds);                                                         //0003
     endif;

     //Delete entry from file IDSPFDKEYS.
     sqlStmt =  'Delete from IDSPFDKEYS Where';

     if wk_WildCard <> *Blanks;
        sqlStmt =  %trim(sqlStmt) + Space + 'Substr(APFILE,1,'              +
                   %char(wk_Position) + ') = ' + Quote + %trim(wk_WildCard) +
                   Quote;
     else;
        sqlStmt =  %trim(sqlStmt) + Space + 'APFILE='+ Quote + %trim(iAOObjNam)
                   + Quote;
     endif;
     //If Lib provided
     if iAOObjLib <> *Blanks;
        sqlStmt =  %trim(sqlStmt) + Space + 'And APLIB = '  +  Quote  +
                   %Trim(iAOObjLib) + Quote;
     endif;

     exec sql execute immediate :sqlStmt;

     if SqlCode < SuccessCode;
        uDpsds.wkQuery_Name = 'Delete_IDSPFDKEYS';
        IaSqlDiagnostic(uDpsds);                                                         //0003
     endif;

     //Delete entry from file IDSPFDSLOM.
     sqlStmt =  'Delete from IDSPFDSLOM Where';

     if wk_WildCard  <> *Blanks;
        sqlStmt =  %trim(sqlStmt) + Space + 'Substr(SOFILE,1,'              +
                   %char(wk_Position) + ') = ' + Quote + %Trim(wk_WildCard) +
                   Quote;
     else;
        sqlStmt =  %trim(sqlStmt) + Space + 'SOFILE = '+ Quote + %trim(iAOObjNam)
                   + Quote;
     endif;
     //If Lib provided
     if iAOObjLib <> *Blanks;
        sqlStmt =  %trim(sqlStmt) + Space + 'And SOLIB = '  +  Quote  +
                   %trim(iAOObjLib) + Quote;
     endif;

     exec sql execute immediate :sqlStmt;

     if SqlCode < SuccessCode;
        uDpsds.wkQuery_Name = 'Delete_IDSPFDSLOM';
        IaSqlDiagnostic(uDpsds);                                                         //0003
     endif;

     //Delete entry from file IDSPFDSEQ.
     sqlStmt =  'Delete from IDSPFDSEQ Where';

     if wk_WildCard  <> *Blanks;
        sqlStmt =  %trim(sqlStmt) + Space + 'Substr(SQFILE,1,'              +
                   %char(wk_Position) + ') = ' + Quote + %trim(wk_WildCard) +
                   Quote;
     else;
        sqlStmt =  %trim(sqlStmt) + Space + 'SQFILE='+ Quote + %Trim(iAOObjNam)
                   + Quote;
     endif;
     //If Lib provided
     if iAOObjLib <> *Blanks;
        sqlStmt =  %trim(sqlStmt) + Space + 'And SQLIB='  +  Quote  +
                   %trim(iAOObjLib) + Quote;
     endif;

     exec sql execute immediate :sqlStmt;

     if SqlCode < SuccessCode;
        uDpsds.wkQuery_Name = 'Delete_IDSPFDSEQ';
        IaSqlDiagnostic(uDpsds);                                                         //0003
     endif;

     //Delete entry from file IDSPFDRFMT.
     sqlStmt =  'Delete from IDSPFDRFMT Where';

     if wk_WildCard <> *Blanks;
        sqlStmt =  %trim(sqlStmt) + Space + 'Substr(RFFILE,1,'              +
                   %char(wk_Position) + ') = ' + Quote + %trim(wk_WildCard) +
                   Quote;
     else;
        sqlStmt =  %trim(Sqlstmt) + Space + 'RFFILE = '+ Quote + %Trim(iAOObjNam)
                   + Quote;
     endif;
     //If Lib provided
     if iAOObjLib <> *Blanks;
        sqlStmt =  %trim(sqlStmt) + Space + 'And RFLIB = '  +  Quote  +
                   %trim(iAOObjLib) + Quote;
     endif;

     exec sql execute immediate :sqlStmt;

     if SqlCode < SuccessCode;
        uDpsds.wkQuery_Name = 'Delete_IDSPFDRFMT';
        IaSqlDiagnostic(uDpsds);                                                         //0003
     endif;

     //Delete entry from file IDSPFDMBR.
     sqlStmt =  'Delete from IDSPFDMBR Where';

     if wk_WildCard <> *Blanks;
        sqlStmt =  %trim(sqlStmt) + Space + 'Substr(MBFILE,1,'              +
                   %char(wk_Position) + ') = ' + Quote + %Trim(wk_WildCard) +
                   Quote;
     else;
        sqlStmt =  %trim(sqlStmt) + Space + 'MBFILE = '+ Quote + %Trim(iAOObjNam)
                   + Quote;
     endif;
     //If Lib provided
     if iAOObjLib <> *Blanks;
        sqlStmt =  %trim(sqlStmt) + Space + 'And MBLIB = '  +  Quote  +
                   %trim(iAOObjLib) + Quote;
     endif;

     exec sql execute immediate :sqlStmt;

     if SqlCode < SuccessCode;
        uDpsds.wkQuery_Name = 'Delete_IDSPFDMBR';
        IaSqlDiagnostic(uDpsds);                                                         //0003
     endif;

     //Delete entry from file IDSPFDJOIN.
     sqlStmt =  'Delete from IDSPFDJOIN Where';

     if wk_WildCard <> *Blanks;
        sqlStmt =  %trim(sqlStmt) + Space + 'Substr(JNFILE,1,'              +
                   %char(wk_Position) + ') = ' + Quote + %Trim(wk_WildCard) +
                   Quote;
     else;
        sqlStmt =  %trim(sqlStmt) + Space + 'JNFILE = '+ Quote + %Trim(iAOObjNam)
                   + Quote;
     endif;
     //If Lib provided
     if iAOObjLib <> *Blanks;
        sqlStmt =  %trim(sqlStmt) + Space + 'And JNLIB = '  +  Quote  +
                   %trim(iAOObjLib) + Quote;
     endif;

     exec sql execute immediate :sqlStmt;

     if SqlCode < SuccessCode;
        uDpsds.wkQuery_Name = 'Delete_IDSPFDJOIN';
        IaSqlDiagnostic(uDpsds);                                                         //0003
     endif;

     //Delete entry from file IDSPFDTRG.
     sqlStmt =  'Delete from IDSPFDTRG Where';

     if wk_WildCard <> *Blanks;
        sqlStmt =  %trim(sqlStmt) + Space + 'Substr(TRFILE,1,'              +
                   %char(wk_Position) + ') = ' + Quote + %Trim(wk_WildCard) +
                   Quote;
     else;
        sqlStmt =  %Trim(sqlStmt) + Space + 'TRFILE = '+ Quote + %Trim(iAOObjNam)
                   + Quote;
     endif;
     //If Lib provided
     if iAOObjLib <> *Blanks;
        sqlStmt =  %trim(sqlStmt) + Space + 'And TRLIB = '  +  Quote  +
                   %trim(iAOObjLib) + Quote;
     endif;

     exec sql execute immediate :sqlStmt;

     if SqlCode < SuccessCode;
        uDpsds.wkQuery_Name = 'Delete_IDSPFDTRG';
        IaSqlDiagnostic(uDpsds);                                                         //0003
     endif;

     //Delete entry from file IDSPFDCST.
     sqlStmt =  'Delete from IDSPFDCST Where';

     if wk_WildCard <> *Blanks;
        sqlStmt =  %trim(sqlStmt) + Space + 'Substr(CSFILE,1,'              +
                   %char(wk_Position) + ') = ' + Quote + %trim(wk_WildCard) +
                   Quote;
     else;
        sqlStmt =  %trim(sqlStmt) + Space + 'CSFILE = '+ Quote + %trim(iAOObjNam)
                   + Quote;
     endif;
     //If Lib provided
     if iAOObjLib <> *Blanks;
        sqlStmt =  %trim(sqlStmt) + Space + 'And CSLIB = '  +  Quote  +
                   %trim(iAOObjLib) + Quote;
     endif;

     exec sql execute immediate :sqlStmt;

     if SqlCode < SuccessCode;
        uDpsds.wkQuery_Name = 'Delete_IDSPFDCST';
        IaSqlDiagnostic(uDpsds);                                                         //0003
     endif;

     //Delete entry from file IADSPDBR.
     sqlStmt =  'Delete from IADSPDBR Where';

     if wk_WildCard <> *Blanks;
        sqlStmt =  %trim(sqlStmt) + Space + 'Substr(WHRFI,1,'               +
                   %char(wk_Position) + ') = ' + Quote + %trim(wk_WildCard) +
                   Quote;
     else;
        sqlStmt =  %trim(sqlstmt) + Space + 'WHRFI = '+ Quote + %trim(iAOObjNam)
                   + Quote;
     endif;
     //If Lib provided
     if iAOObjLib <> *Blanks;
        sqlStmt =  %trim(sqlStmt) + Space + 'And WHRLI = '  +  Quote  +
                   %trim(iAOObjLib) + Quote;
     endif;

     exec sql execute immediate :sqlStmt;

     if SqlCode < SuccessCode;
        uDpsds.wkQuery_Name = 'Delete_IADSPDBR';
        IaSqlDiagnostic(uDpsds);                                                         //0003
     endif;

     //Delete entry from file IDSPFFD.
     sqlStmt =  'Delete from IDSPFFD Where';

     if wk_WildCard <> *Blanks;
        sqlStmt =  %trim(sqlStmt) + Space + 'Substr(WHFILE,1,'              +
                   %char(wk_Position) + ') = ' + Quote + %trim(wk_WildCard) +
                   Quote;
     else;
        sqlStmt =  %trim(sqlStmt) + Space + 'WHFILE = '+ Quote + %Trim(iAOObjNam)
                   + Quote;
     endif;
     //If Lib provided
     if iAOObjLib <> *Blanks;
        sqlStmt =  %trim(sqlStmt) + Space + 'And WHLIB = '  +  Quote  +
                   %trim(iAOObjLib) + Quote;
     endif;

     exec sql execute immediate :sqlStmt;

     if SqlCode < SuccessCode;
        uDpsds.wkQuery_Name = 'Delete_IDSPFFD';
        IaSqlDiagnostic(uDpsds);                                                         //0003
     endif;

  endif;

  //Object exclusion for other object type e.g *PGM,*SRVPGM,*MODULE etc.
  //Delete entry from file IAOBJREFPF.
  sqlStmt =  'Delete from IAOBJREFPF Where';
  if wk_WildCard <>  *Blanks;
     sqlStmt =  %trim(sqlStmt) + Space + 'Substr(WHFNAM,1,'              +
                %char(wk_Position) + ') = ' + Quote + %trim(wk_WildCard) +
                Quote;
  else;
     sqlStmt =  %trim(sqlStmt) + Space + 'WHFNAM = '+ Quote + %Trim(iAOObjNam)
                + Quote;
  endif;
  //Lib = both *LIBL and LIBNAME, If IAOOBJLIB = ' ' then do not check lib
  if iAOObjLib <> *Blanks;
     sqlStmt =  %trim(sqlStmt) + Space + 'And (WHLNAM =' + Quote +
                %trim(iAOObjLib) + Quote  +  Space  +  'Or WHLNAM =' + Quote +
                '*LIBL' +  Quote + ')';
  endif;
  //If TYPE provided
  if iAOObjTyp <> *Blanks;
     sqlStmt =  %trim(sqlStmt) + Space + 'And WHOTYP =' + Quote +
                %trim(iAOObjTyp) + Quote;
  endif;

  exec sql execute immediate :sqlStmt;

  if SqlCode < SuccessCode;
     uDpsds.wkQuery_Name = 'Delete_IAOBJREFPF';
     IaSqlDiagnostic(uDpsds);                                                            //0003
  endif;

  //Delete entry from file IDSPPGMREF.
  sqlStmt =  'Delete from IDSPPGMREF Where';
  if wk_WildCard <> *Blanks;
     sqlStmt =  %trim(sqlStmt) + Space + 'Substr(WHFNAM,1,'  +
                %char(wk_Position) + ') = ' + Quote + %trim(wk_WildCard) +
                Quote;
  else;
     sqlStmt =  %trim(sqlStmt) + Space + 'WHFNAM = '+ Quote + %Trim(iAOObjNam)
                + Quote;
  endif;
  //Lib= both *LIBL and LIBNAME
  if iAOObjLib <> *Blanks;
     sqlStmt =  %trim(sqlStmt) + Space + 'And (WHLNAM =' + Quote +
                %trim(iAOObjLib) + Quote  +  Space  +  'Or WHLNAM =' + Quote +
                '*LIBL' +  Quote + ')';
  endif;
  //If TYPE provided
  if iAOObjTyp <> *Blanks;
     sqlStmt =  %trim(sqlStmt) + Space + 'And WHOTYP =' + Quote +
                %trim(iAOObjTyp) + Quote;
  endif;

  exec sql execute immediate :sqlStmt;

  if SqlCode < SuccessCode;
     uDpsds.wkQuery_Name = 'Delete_IDSPPGMREF';
     IaSqlDiagnostic(uDpsds);                                                            //0003
  endif;

  //Delete entry from file IDSPSQLREF.
  sqlStmt =  'Delete from IDSPSQLREF Where';
  if wk_WildCard <> *Blanks;
     sqlStmt =  %trim(sqlStmt) + Space + 'Substr(WHFNAM,1,' +
                %char(wk_Position) + ') = ' + Quote + %trim(wk_WildCard) +
                Quote;
  else;
     sqlStmt =  %trim(sqlStmt) + Space + 'WHFNAM = '+ Quote + %Trim(iAOObjNam)
                + Quote;
  endif;
  //Lib= both *LIBL and LIBNAME
  if iAOObjLib <> *Blanks;
     sqlStmt =  %trim(sqlStmt) + Space + 'And (WHLNAM =' + Quote +
                %trim(iAOObjLib) + Quote  +  Space  +  'Or WHLNAM =' + Quote +
                '*LIBL' +  Quote + ')';
  endif;
  //If TYPE provided
  if iAOObjTyp <> *Blanks;
     sqlStmt =  %trim(sqlStmt) + Space + 'And WHOTYP =' + Quote +
                %trim(iAOObjTyp) + Quote;
  endif;

  exec sql execute immediate :sqlStmt;

  if SqlCode < SuccessCode;
     uDpsds.wkQuery_Name = 'Delete_IDSPSQLREF';
     IaSqlDiagnostic(uDpsds);                                                            //0003
  endif;

  //Delete entry from file IDSPSRVREF.
  sqlStmt =  'Delete from IDSPSRVREF Where';
  if wk_WildCard <> *Blanks;
     sqlStmt =  %trim(sqlStmt) + Space + 'Substr(WHFNAM,1,'  +
                %char(wk_Position) + ') = ' + Quote + %trim(wk_WildCard) +
                Quote;
  else;
     sqlStmt =  %trim(sqlStmt) + Space + 'WHFNAM = '+ Quote + %trim(iAOObjNam)
                + Quote;
  endif;
  //Lib= both *LIBL and LIBNAME
  if iAOObjLib <> *Blanks;
     sqlStmt =  %trim(sqlStmt) + Space + 'And (WHLNAM =' + Quote +
                %trim(iAOObjLib) + Quote  +  Space  +  'Or WHLNAM =' + Quote +
                '*LIBL' +  Quote + ')';
  endif;
  //If TYPE provided
  if iAOObjTyp <> *Blanks;
     sqlStmt =  %trim(sqlStmt) + Space + 'And WHOTYP =' + Quote +
                %Trim(iAOObjTyp) + Quote;
  endif;

  exec sql execute immediate :sqlStmt;

  if SqlCode < SuccessCode;
     uDpsds.wkQuery_Name = 'Delete_IDSPSRVREF';
     IaSqlDiagnostic(uDpsds);                                                            //0003
  endif;

  //Delete entry from file IDSPMODREF.
  sqlStmt =  'Delete from IDSPMODREF Where';
  if wk_WildCard <> *Blanks;
     sqlStmt =  %trim(sqlStmt) + Space + 'Substr(WHFNAM,1,'  +
                %char(wk_Position) + ') = ' + Quote + %trim(wk_WildCard) +
                Quote;
  else;
     sqlStmt =  %trim(sqlStmt) + Space + 'WHFNAM = '+ Quote + %Trim(iAOObjNam)
                + Quote;
  endif;
  //Lib= both *LIBL and LIBNAME
  if iAOObjLib <> *Blanks;
     sqlStmt =  %trim(sqlStmt) + Space + 'And (WHLNAM =' + Quote +
                %trim(iAOObjLib) + Quote  +  Space  +  'Or WHLNAM =' + Quote +
                '*LIBL' +  Quote + ')';
  endif;
  //If TYPE provided
  if iAOObjTyp <> *Blanks;
     sqlStmt =  %Trim(sqlStmt) + Space + 'And WHOTYP =' + Quote +
                %Trim(iAOObjTyp) + Quote;
  endif;

  exec sql execute immediate :sqlStmt;

  if SqlCode < SuccessCode;
     uDpsds.wkQuery_Name = 'Delete_IDSPMODREF';
     IaSqlDiagnostic(uDpsds);                                                            //0003
  endif;

  //Delete entry from file IDSPQRYREF.
  sqlStmt =  'Delete from IDSPQRYREF Where';
  if wk_WildCard <> *Blanks;
     sqlStmt =  %trim(sqlStmt) + Space + 'Substr(WHFNAM,1,'  +
                %char(wk_Position) + ') = ' + Quote + %trim(wk_WildCard) +
                Quote;
  else;
     sqlStmt =  %trim(sqlStmt) + Space + 'WHFNAM = '+ Quote + %trim(iAOObjNam)
                + Quote;
  endif;
  //Lib= both *LIBL and LIBNAME
  if iAOObjLib <> *Blanks;
     sqlStmt =  %trim(sqlStmt) + Space + 'And (WHLNAM =' + Quote +
                %trim(iAOObjLib) + Quote  +  Space  +  'Or WHLNAM =' + Quote +
                '*LIBL' +  Quote + ')';
  endif;
  //If TYPE provided
  if iAOObjTyp <> *Blanks;
     sqlStmt =  %trim(sqlStmt) + Space + 'And WHOTYP =' + Quote +
                %trim(iAOObjTyp) + Quote;
  endif;

  exec sql execute immediate :sqlStmt;

  if SqlCode < SuccessCode;
     uDpsds.wkQuery_Name = 'Delete_IDSPQRYREF';
     IaSqlDiagnostic(uDpsds);                                                            //0003
  endif;

  //Delete entry from file IDSPOBJD.
  sqlStmt =  'Delete from IDSPOBJD Where';
  if wk_WildCard <> *Blanks;
     sqlStmt =  %trim(sqlStmt) + Space + 'Substr(ODOBNM,1,' +
                %char(wk_Position) + ') = ' + Quote + %trim(wk_WildCard) +
                Quote;
  else;
     sqlStmt =  %trim(sqlStmt) + Space + 'ODOBNM = '+ Quote + %Trim(iAOObjNam)
                + Quote;
  endif;
  //If LIB provided
  if iAOObjLib <> *Blanks;
     sqlStmt =  %trim(sqlStmt) + Space + 'And ODLBNM =' + Quote +
                %trim(iAOObjLib) + Quote ;
  endif;
  //If TYPE provided
  if iAOObjTyp <> *Blanks;
     sqlStmt =  %trim(sqlStmt) + Space + 'And ODOBTP =' + Quote +
                %trim(iAOObjTyp) + Quote;
  endif;

  exec sql execute immediate :sqlStmt;

  if SqlCode < SuccessCode;
     uDpsds.wkQuery_Name = 'Delete_IDSPOBJD';
     IaSqlDiagnostic(uDpsds);                                                            //0003
  endif;

end-proc;
