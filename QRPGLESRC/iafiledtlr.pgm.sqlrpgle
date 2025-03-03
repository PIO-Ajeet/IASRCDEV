**Free
      //%METADATA                                                      *
      // %TEXT Add file detail                                         *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------- //
//Created By  :  Programmers.io @ 2020                                                  //
//Created Date:  2020/01/01                                                             //
//Developer   :  Kaushal Kumar                                                          //
//Description :                                                                         //
//                                                                                      //
//PROCEDURE LOG:                                                                        //
//------------------------------------------------------------------------------------- //
//Procedure Name           | Procedure Description                                      //
//-------------------------|----------------------------------------------------------- //
//No Procedure             |                                                            //
//------------------------------------------------------------------------------------- //
//                                                                                      //
//MODIFICATION LOG:                                                                     //
//------------------------------------------------------------------------------------- //
//Date    | Mod_ID | Developer  | Case and Description                                  //
//--------|--------|------------|------------------------------------------------------ //
//14/11/23| 0001   | BPAL       | Refresh builtmetadata process changes. TASK#365       //
//14/11/23| 0002   | Akshay S.  | IAFILEDTL not correctly getting populated. #411       //
//30/11/23| 0003   | Akhil K.   | In REFRESH, records in IAFILEDTL are inserted for only//
//        |        |            | *file type objects in IAREFOBJF.                      //
//06/06/24| 0004   | Saumya     | Rename AIEXCTIMR to IAEXCTIMR [Task #262]             //
//04/07/24| 0005   | Akhil K.   | Renamed AIERRBND, AICERRLOG, AIDERRLOG and            //
//        |        |            | AISQLDIAGNOSTIC with IA*                              //
//20/06/24| 0006   | Yogesh     | Added logic to show correct and all possible data     //
//        |        |     Chandra| types in file field details page.      [Task #335]    //
//16/08/24| 0007   | Sabarish   | IFS Member Parsing Feature [Task #833]                //
//------------------------------------------------------------------------------------- //
ctl-opt copyright('Copyright @ Programmers.io © 2022 ');
ctl-opt option(*NoDebugIO : *SrcStmt : *noUnRef);
ctl-opt bndDir('IAERRBND');                                                              //0005

//------------------------------------------------------------------------------------- //
//Variable Declaration
//------------------------------------------------------------------------------------- //
dcl-s FirstIteraton char(1)      inz;
dcl-s W_Library     char(10)     inz;
dcl-s W_FileName    char(10)     inz;
dcl-s W_KeyField    char(10)     inz;
dcl-s W_ObjType     char(10)     inz;
dcl-s uppgm_name    char(10)     inz;
dcl-s uplib_name    char(10)     inz;
dcl-s upsrc_name    char(10)     inz;
dcl-s Wk_CsrName    char(30)     inz('MAIN');

dcl-s W_RecCount    packed(10:0) inz;
dcl-s W_KeyCount    packed(3:0)  inz;
dcl-s KeySeq        packed(3:0)  inz;

dcl-s RowsFetched     uns(5);
dcl-s noOfRows        uns(5);
dcl-s noOfRows1       uns(5);
dcl-s uwindx          uns(5);
dcl-s uwindx1         uns(5);
dcl-s RowsFetched1    uns(5);

dcl-s rowFound        ind          inz('0');

dcl-s uptimestamp     Timestamp;

dcl-s wkSqlText1       char(500) Inz ;                                                   //0001
dcl-s wkSqlText2       char(500) Inz ;                                                   //0001

//------------------------------------------------------------------------------------- //
//Datastructure Declaration
//------------------------------------------------------------------------------------- //
dcl-ds IaFileDtlDs1 qualified dim(999);
   DsLibName     char(10)     inz;
   DsFileName    char(10)     inz;
end-ds;

dcl-ds IaFileDtlDs3 qualified dim(999);
   DsKeyCount    packed(3:0)  inz;
   DsKeyField    char(10)     inz;
   DsKeySeq      packed(3:0)  inz;
end-ds;

//Data structure declaration                                                            //0001
dcl-ds iaMetaInfo dtaara len(62);                                                        //0001
   runMode char(7) pos(1);                                                               //0001
end-ds;                                                                                  //0001

//------------------------------------------------------------------------------------- //
//Constant Declaration
//------------------------------------------------------------------------------------- //
dcl-c TRUE            '1';
dcl-c FALSE           '0';

//------------------------------------------------------------------------------------- //
//Prototype Declaration
//------------------------------------------------------------------------------------- //
dcl-pr IAEXCTIMR extpgm('IAEXCTIMR');                                                    //0004
   *n Char(10) Const;
   *n Char(10);
   *n Char(10);
   *n Char(10) Const;
   *n Char(10);
   *n Char(10);
   *n Char(10);
   *n Char(100) Const;                                                                   //0007
   *n Char(10) Const;
   *n Timestamp;
   *n Char(6) Const;
end-pr;

//------------------------------------------------------------------------------------- //
//Entry Parameter
//------------------------------------------------------------------------------------- //
dcl-pi IAFILEDTLR extpgm('IAFILEDTLR');
   P1Library char(10);
end-pi;

//------------------------------------------------------------------------------------- //
//Copybook Declaration
//------------------------------------------------------------------------------------- //
/copy 'QCPYSRC/iaderrlog.rpgleinc'
//------------------------------------------------------------------------------------- //
//Set options
//------------------------------------------------------------------------------------- //
exec sql
  set option commit = *none,
             naming = *sys,
             usrprf = *user,
             dynusrprf = *user,
             closqlcsr = *endmod;

//Retrieve value from Data Area                                                         //0001
in IaMetaInfo;                                                                           //0001

//------------------------------------------------------------------------------------- //
//Cursor Declarations
//------------------------------------------------------------------------------------- //
if runmode = 'REFRESH';                                                                  //0002
                                                                                         //0002
   wksqltext1 =  'select DISTINCT DBLIBNAME, DBFILENM   ' +                              //0002
                 'from IAFILEDTL join iarefobjf t2   ' +                                 //0002
                 'on  DBFILENM   = t2.IaObjName and '     +                              //0002
                 '    DBLIBNAME  = t2.IaObjlib      ';                                   //0002
                                                                                         //0002
   wksqltext2 =  ' select APNKYF, APKEYF, APKEYN       ' +                               //0002
                 '   from IDSPFDKEYS join iarefobjf t2 ' +                               //0002
                 ' on apfile =  t2.IaObjName and ' +                                     //0002
                 '    aplib  =  t2.IaObjlib      ' +                                     //0002
                 ' where APLIB = ? and ' +                                               //0002
                 ' APFILE = ? '          ;                                               //0002
else;                                                                                    //0001
                                                                                         //0001
   wksqltext1 =  'select DISTINCT DBLIBNAME, DBFILENM   ' +                              //0001
                 'from IAFILEDTL                        ';                               //0001
                                                                                         //0001
   wksqltext2 =  ' select APNKYF, APKEYF, APKEYN       ' +                               //0001
                 '   from IDSPFDKEYS                   ' +                               //0001
                 ' where APLIB = ? and ' +                                               //0002
                 ' APFILE = ? '          ;                                               //0002
                                                                                         //0001
endif;                                                                                   //0001
                                                                                         //0001
//------------------------------------------------------------------------------------- //
//Main Logic
//------------------------------------------------------------------------------------- //

Eval-corr uDpsds = wkuDpsds;

//Insert process start time
uptimeStamp = %Timestamp();
CallP IAEXCTIMR('BLDMTADTA ':udpsds.ProcNme : udpsds.Lib : '*PGM' :                      //0004
 //upsrc_name : uppgm_name : uplib_name : ' ' : uptimeStamp : 'INSERT');                 //0007
   upsrc_name : uppgm_name : uplib_name : ' ' : ' ' : uptimeStamp : 'INSERT');           //0007

if runMode = 'REFRESH';                                                                  //0001
   exsr Updinfo;                                                                         //0001
else;                                                                                    //0001

   //Populate the file IAFILEDTL from an outfile IDSPFFD
   exec sql
      insert into IAFILEDTL(DBFILENM, DBLIBNAME, DBRCDF, DBFLDNMI, DBFLDNMX,
                           DBFLDNMA,
                           DBDATATYPE, DBFLDLEN, DBDECPOS, DBREFFILE,
                           DBREFLIB,  DBREFRFMT, DBREFFLD, DBSSTSTR, DBSSTLEN)
        select WHFILE, WHLIB, WHNAME,
             Case when (SUBSTR(WHFLDI,1,3)='*IN') THEN ' ' ELSE WHFLDI END WHFLDI,
             Case when (SUBSTR(WHFLDE,1,3)='*IN') THEN ' ' ELSE WHFLDE END WHFLDE,
             Case when (SUBSTR(WHFLDI,1,3)='*IN' AND SUBSTR(WHFLDE,1,3)='*IN')
                                          THEN ' ' ELSE WHALIS END WHALIS,
    //0006   Case when WHFLDD = 0 THEN 'CHAR'
    //0006        when WHFLDD > 0 THEN 'DEC'
    //0006        else ' '
             Case When  WHFLDT = 'P' Then 'PACKED'                                       //0006
                  When  WHFLDT = 'S' Then 'ZONED'                                        //0006
                  When  WHFLDT = 'B' Then 'INTEGER'                                      //0006
                  When  WHFLDT = 'F' Then 'FLOAT'                                        //0006
                  When  WHFLDT = 'A' Then 'CHAR'                                         //0006
                  When  WHFLDT = 'L' Then 'DATE'                                         //0006
                  When  WHFLDT = 'T' Then 'TIME'                                         //0006
                  When  WHFLDT = 'Z' Then 'TIMESTAMP'                                    //0006
                  When  WHFLDD = 0   Then 'CHAR'                                         //0006
                  When  WHFLDD > 0   Then 'DEC'                                          //0006
                  end,
             Case when WHFLDD = 0 THEN WHFLDB
                  when WHFLDD > 0 THEN WHFLDD
                  end,
                  WHFLDP, WHRFIL, WHRLIB, WHRFMT, WHRFLD, WHMAPS,
                  WHMAPL
             from IDSPFFD;
endif;                                                                                   //0001

if sqlCode < successCode;
   uDpsds.wkQuery_Name = 'Insert_1_IAFILEDTL';
   IaSqlDiagnostic(uDpsds);                                                              //0005
endif;

exec sql prepare stmt1 from :wksqltext1 ;                                                //0001
exec sql declare IAFILEDTLR_C1 cursor for Stmt1 ;                                        //0001

//Open cursor
exec sql open IAFILEDTLR_C1;
if sqlCode = CSR_OPN_COD;
   exec sql close IAFILEDTLR_C1;
   exec sql open  IAFILEDTLR_C1;
endif;

if sqlCode < successCode;
   uDpsds.wkQuery_Name = 'Open_Cursor_IAFILEDTLR_C1';
   IaSqlDiagnostic(uDpsds);                                                              //0005
endif;

if sqlCode = successCode;

   //Get the number of elements
   noOfRows = %elem(IaFileDtlDs1);

   Wk_CsrName = 'MAIN';
   //Fetch records from Command_Object cursor
   rowFound = fetchRecordFileDtlCursor();

   dow rowFound;

      for uwindx = 1 to RowsFetched;
         Clear W_Library;
         Clear W_FileName;
         W_Library = IaFileDtlDs1(uwindx).DsLibName ;
         W_FileName = IaFileDtlDs1(uwindx).DsFileName;

         exsr @GetAndUpdateRecordCount;
         exsr @GetAndUpdateKeysDetails;
         exsr @GetAndupdateObjectType;
      endfor;

      Wk_CsrName = 'MAIN';

      //if fetched rows are less than the array elements then come out of the loop.
      if RowsFetched < noOfRows ;
         leave ;
      endif ;

      //Fetch records from Command_Object cursor
      rowFound = fetchRecordFileDtlCursor();
   enddo;

   exec sql close IAFILEDTLR_C1;
endif;

//Update process end time
UPTimeStamp = %Timestamp();
CallP IAEXCTIMR('BLDMTADTA' :udpsds.ProcNme : udpsds.Lib : '*PGM' :                      //0004
//upsrc_name : uppgm_name : uplib_name : ' ' : uptimeStamp : 'UPDATE');                  //0007
  upsrc_name : uppgm_name : uplib_name : ' ' : ' ' : uptimeStamp : 'UPDATE');            //0007

*inlr = *on;

/copy 'QCPYSRC/iacerrlog.rpgleinc'

//------------------------------------------------------------------------------------- //
//@GetAndUpdateRecordCount
//------------------------------------------------------------------------------------- //
begsr @GetAndUpdateRecordCount;

   W_RecCount = 0;
   exec sql
     select Coalesce(sum(MBNRCD),0)
       into :W_RecCount
       from IDSPFDMBR
      where MBLIB = trim(:W_Library)
        and MBFILE = trim(:W_Filename);

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Select_Sum_MBNRCD_IDSPFDMBR';
      IaSqlDiagnostic(uDpsds);                                                           //0005
   endif;

   if sqlCode = successCode;
      exec sql
        update IAFILEDTL
           set DBRCDCNT = char(:W_RecCount)
         where DBLIBNAME = trim(:W_Library)
           and DBFILENM = trim(:W_Filename);

      if sqlCode < successCode;
         uDpsds.wkQuery_Name = 'Update_1_IAFILEDTL';
         IaSqlDiagnostic(uDpsds);                                                        //0005
      endif;

   endif;

endsr;
//------------------------------------------------------------------------------------- //
//@GetandUpdateKeysDetails
//------------------------------------------------------------------------------------- //
begsr @GetandUpdateKeysDetails;

   exec sql prepare stmt2 from :wksqltext2;                                              //0001
   exec sql declare IAFILEDTLR_C3 cursor for Stmt2;                                      //0001

   //Open cursor
   exec sql open IAFILEDTLR_C3 using :W_library,:w_fileName;                             //0002
   if sqlCode = CSR_OPN_COD;
      exec sql close IAFILEDTLR_C3;
      exec sql open  IAFILEDTLR_C3 using :W_library,:w_fileName;                         //0002
   endif;

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Open_Cursor_IAFILEDTLR_C3';
      IaSqlDiagnostic(uDpsds);                                                           //0005
   endif;

   if sqlCode = successCode;
      FirstIteraton = 'Y';
      KeySeq = 0;
      Clear W_KeyCount;
      Clear W_KeyField;

      //Get the number of elements
      noOfRows1 = %elem(IaFileDtlDs3);
      Wk_CsrName  = '@GetandUpdateKeysDetails';

      //Fetch records from Command_Object cursor
      rowFound = fetchRecordFileDtlCursor();

      dow rowFound;

         for uwindx1 = 1 to RowsFetched1;
            W_KeyCount =  IaFileDtlDs3(uwindx1).DsKeyCount ;
            W_KeyField =  IaFileDtlDs3(uwindx1).DsKeyField;
            KeySeq  =     IaFileDtlDs3(uwindx1).DsKeySeq ;

            exec sql
               update IAFILEDTL
                 set DBKEYFLD   = char(:KeySeq),
                     DBNOKEYFLD = char(:W_KeyCount)
               where DBLIBNAME = trim(:W_Library)
                 and DBFILENM = trim(:W_Filename)
                 and DBFLDNMI = trim(:W_KeyField);

            if sqlCode < successCode;
               uDpsds.wkQuery_Name = 'Update_3_IAFILEDTL';
               IaSqlDiagnostic(uDpsds);                                                  //0005
            endif;

         endfor;

         Wk_CsrName = '@GetandUpdateKeysDetails';

         //if fetched rows are less than the array elements then come out of the loop.
         if RowsFetched1 < noOfRows1 ;
            leave ;
         endif ;

         //Fetch records from Command_Object cursor
         rowFound = fetchRecordFileDtlCursor();
      enddo;

      exec sql close IAFILEDTLR_C3;
   endif;

endsr;
//------------------------------------------------------------------------------------- //
//@GetAndupdateObjectType
//------------------------------------------------------------------------------------- //
begsr @GetAndupdateObjectType;

   exec sql
     select ATFATR
       into :W_ObjType
       from IDSPFDBASA
      where ATLIB = trim(:W_Library)
        and ATFILE = trim(:W_Filename) limit 1;

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Select_ATFATR_IDSPFDBASA';
      IaSqlDiagnostic(uDpsds);                                                           //0005
   endif;

   if sqlCode = successCode;

      exec sql
        update IAFILEDTL
           set DBFILETYPE = trim(:W_ObjType)
         where DBLIBNAME = trim(:W_Library)
           and DBFILENM = trim(:W_Filename);

      if sqlCode < successCode;
         uDpsds.wkQuery_Name = 'Update_4_IAFILEDTL';
         IaSqlDiagnostic(uDpsds);                                                        //0005
      endif;

   endif;

endsr;
//------------------------------------------------------------------------------------- //
// Updinfo subroutine : Delete entries from iaallrefpf for refresh & Inserting back.
//------------------------------------------------------------------------------------- //
begsr updinfo;                                                                           //0001
                                                                                         //0001
  //Delete existing entries from iaallrefpf                                             //0001
  exec sql                                                                               //0001
    delete                                                                               //0001
      from iAFileDtl where exists (                                                      //0001
    select 1                                                                             //0001
      from iARefObjF T1                                                                  //0001
     where iafiledtl.dblibname = t1.iaobjlib                                             //0001
       and iafiledtl.dbfilenm = t1.iaobjname );                                          //0001
                                                                                         //0001
  if sqlCode < successCode;                                                              //0001
     uDpsds.wkQuery_Name = 'Delete_iafiledtl';                                           //0001
     IaSqlDiagnostic(uDpsds);                                                            //0001 0005
  endif;                                                                                 //0001
                                                                                         //0001
  //Populate the file IAFILEDTL from an outfile IDSPFFD                                 //0001
  exec sql                                                                               //0001
    insert into IAFILEDTL(DBFILENM, DBLIBNAME, DBRCDF, DBFLDNMI, DBFLDNMX,               //0001
                         DBFLDNMA,                                                       //0001
                         DBDATATYPE, DBFLDLEN, DBDECPOS, DBREFFILE,                      //0001
                         DBREFLIB,  DBREFRFMT, DBREFFLD, DBSSTSTR, DBSSTLEN)             //0001
       select WHFILE, WHLIB, WHNAME,                                                     //0001
          Case when (SUBSTR(WHFLDI,1,3)='*IN') THEN ' ' ELSE WHFLDI END WHFLDI,          //0001
          Case when (SUBSTR(WHFLDE,1,3)='*IN') THEN ' ' ELSE WHFLDE END WHFLDE,          //0001
          Case when (SUBSTR(WHFLDI,1,3)='*IN' AND SUBSTR(WHFLDE,1,3)='*IN')              //0001
                                               THEN ' ' ELSE WHALIS END WHALIS,          //0001
          Case when WHFLDD = 0 THEN 'CHAR'                                               //0001
               when WHFLDD > 0 THEN 'DEC'                                                //0001
               else ' '                                                                  //0001
               end,                                                                      //0001
          Case when WHFLDD = 0 THEN WHFLDB                                               //0001
               when WHFLDD > 0 THEN WHFLDD                                               //0001
               end,                                                                      //0001
               WHFLDP, WHRFIL, WHRLIB, WHRFMT, WHRFLD, WHMAPS,                           //0001
               WHMAPL                                                                    //0001
          from IDSPFFD join IAREFOBJF t2                                                 //0001
            on whfile = t2.IaObjName                                                     //0001
           and whlib  = t2.IaObjlib                                                      //0001
           and t2.IaObjType = '*FILE'                                                    //0003
           and t2.status in('M','A') ;                                                   //0001
                                                                                         //0001
  if sqlCode < successCode;                                                              //0001
     uDpsds.wkQuery_Name = 'Insert2_iafiledtl';                                          //0001
     IaSqlDiagnostic(uDpsds);                                                            //0001 0005
  endif;                                                                                 //0001
                                                                                         //0001
endsr;                                                                                   //0001

//------------------------------------------------------------------------------------- //
//Procedure fetchRecordFileDtlCursor: fetch the file details in array
//------------------------------------------------------------------------------------- //
dcl-proc fetchRecordFileDtlCursor;

  dcl-pi fetchRecordFileDtlCursor ind end-pi ;

  dcl-s  rcdFound ind inz('0');
  dcl-s  wkRowNum like(RowsFetched) ;


  select;
    when Wk_CsrName = 'MAIN';

       RowsFetched = *zeros;
       clear IaFileDtlDs1;

       exec sql
          fetch IAFILEDTLR_C1 for :noOfRows rows into :IaFileDtlDs1;

       if sqlcode = successCode;
          exec sql get diagnostics
              :wkRowNum = ROW_COUNT;
              RowsFetched  = wkRowNum ;
       endif;

       if RowsFetched > 0;
          rcdFound = TRUE;
       elseif sqlcode < successCode ;
          rcdFound = FALSE;
       endif;

    when Wk_CsrName = '@GetandUpdateKeysDetails';

       RowsFetched1 = *zeros;
       clear IaFileDtlDs3;

       exec sql
          fetch IAFILEDTLR_C3 for :noOfRows1 rows into :IaFileDtlDs3;
       if sqlcode = successCode;
          exec sql get diagnostics
              :wkRowNum = ROW_COUNT;
              RowsFetched1 = wkRowNum ;
       endif;

       if RowsFetched1 > 0;
          rcdFound = TRUE;
       elseif sqlcode < successCode ;
          rcdFound = FALSE;
       endif;

  endsl;

  return rcdFound;

end-proc;
