**free
      //%METADATA                                                      *
      // %TEXT Program to Build Stored Procedure file - IALongNam      *
      //%EMETADATA                                                     *
//--------------------------------------------------------------------------------------- //
//Created By   : Programmers.io @ 2022                                                    //
//Creation Date: 2022/08/02                                                               //
//Developer    : Pranav Joshi                                                             //
//Description  : This program captures long name of stored procedure into AILNGNMDTL file //
//               by parsing sql statements available in source files and mapping with     //
//               sysroutine table to check object existance. It also writes references to //
//               the stored procedure in IASRCINTPF file.                                 //
//Procedure Log:                                                                          //
//--------------------------------------------------------------------------------------- //
//Procedure Name                 |  Procedure Description                                 //
//--------------------------------------------------------------------------------------- //
//build_sql_statement            | Create Sql statement based on the parameters passed.   //
//GetStoredProcedureDetail       | Read available sources and pass it further for parsing //
//                               | to get procedure name and other details.               //
//ParseString                    | Parse string to get the stored procedure name.         //
//Get_Library_and_procedure_Name | Check if stored procedure is qualified with library    //
//                               | name and extract library and store procedure name.     //
//Check_Stored_procedure         | Check if Stored procedure name extracted does have an  //
//                               | an object.                                             //
//Insert_Long_Name               | Insert record into AILNGNMDTL file.                    //
//GetStoredProcedureReferences   | Get object details referring stored procedure.         //
//WriteIaSrcIntPfDetails         | Write references into IASRCINTPF file.                 //
//GetLongLameForDdlTableViewIndex| Fetch the long name of DDL tables Indexes and views.   //
//--------------------------------------------------------------------------------------- //
//Modification Log:                                                                       //
//--------------------------------------------------------------------------------------- //
//Date    | Developer |Case and Description                                               //
//--------|-----------|------------------------------------------------------------------ //
//00/00/00|           |                                                                   //
//22/09/19| Santhosh  |EXCPLOG issue len or start pos - GetStoredProcedureReferences      //
//23/02/08| Praveen Si|Using "Routine Name" instead of "Specific Name" as the             //
//        |           |"specific name" contains specifc name of the stored procedure      //
//        |           |provided with SPECIFIC keyword (MOD:0001)                          //
//09/03/23| Pranav    |Recompile to accommodate IAQRPGSRC file changes, where three new   //
//        |           | fields are added to the file.                                     //
//02/11/23|Abhijit    | Need to change the usage filed to literal value (MOD:0002)        //
//        |Charhate   | instead of decimal.(Task#312)                                     //
//15/11/23|Akshay     | Refresh Metadata : AILNGNMDTL file populating was populating      //
//        | Sopori    | duplicate entries. (MOD:0003) (Task#372)                          //
//23/11/23|Arun       | Refresh Metadata : IASRCINTPF file is getting duplicate entries   //
//        |Chacko     | (MOD:0004) (Task#399)                                             //
//23/12/06|Anchal     | Added the logic to fetch the long name for the DDL tables, Indexes//
//        |           | and views.                                                        //
//        |           | added GetLongLameForDdlTableViewIndex procedure for the same.     //
//        |           | (MOD:0005) (Task#494)                                             //
//29/04/24|Sribalaji  | "SourceRrnAndMemberDetail" cursor is closed in                    //
//        |           | "GetLongLameForDdlTableViewIndex()" procedure instead of          //
//        |           | "GetSqlLngNm" cursor  (MOD:0006)                                  //
//06/06/24|Saumya     | Rename program AIEXCTIMR to IAEXCTIMR [Task #262] (Tag 0007)      //
//07/06/24|Sribalaji  | Rename program AILNGNMDTR to IALNGNMDTR [Task #256] (Tag 0008)    //
//02/07/24|Vamsi      | Rename the file AILNGNMDTL to IALNGNMDTL [Task #246] (Tag 0009)   //
//02/07/24|Sribalaji  | Remove the hardcoded #IADTA lib from all sources [Task #754]      //
//        |           | (Tag 0010)                                                        //
//04/07/24|Akhil K.   | Renamed AIERRBND, AICERRLOG, AIDERRLOG and AISQLDIAGNOSTIC with   //
//        |           | IA* [Task #261] (Tag 0011)                                        //
// 16/08/24|Sabarish   | IFS Member Parsing Feature [Task #833] (Tag 0012)                 //
//--------------------------------------------------------------------------------------- //
 ctl-opt CopyRight('Copyright @ Programmers.io © 2022 ');
 ctl-opt Option(*NoDebugIo:*SrcStmt:*NoUnRef);
 ctl-opt dftactgrp(*no);
 ctl-opt bndDir('IABNDDIR' : 'IAERRBND');                                                //0011

//Entry Parmeter.
 dcl-pi IALNGNMDTR extpgm('IALNGNMDTR');                                                 //0008
    in_repository char(10) options(*noPass) ;
 end-pi;

//Calling program prototype.
 dcl-pr IAEXCTIMR extpgm('IAEXCTIMR');                                                   //0007
     *n Char(10) Const;
     *n Char(10);
     *n Char(10);
     *n Char(10) Const;
     *n Char(10);
     *n Char(10);
     *n Char(10);
     *n Char(100) Const;                                                                 //0012
     *n Char(10) Const;
     *n Timestamp;
     *n Char(6) Const;
 end-pr;

//Standalone variables
 dcl-s wkLibraryName char(10) Inz ;
 dcl-s wkSourcePfName char(10) Inz ;
 dcl-s wkMemberName char(10) Inz ;
 dcl-s wkSourceStm char(100) Inz ;
 dcl-s wkSourceRrn packed(6) Inz ;
 dcl-s wkSlashDotPos packed(3) Inz ;
 dcl-s WkOpenBracketPos packed(3) Inz ;
 dcl-s wkEndPosition packed(3) Inz ;
 dcl-s wkStrlength packed(3) Inz ;
 dcl-s wkProcedureName char(128) Inz ;
 dcl-s wkProcedureText char(139) Inz ;
 dcl-s wkProcdurePos packed(3) Inz ;
 dcl-s wkBlankPos packed(3) Inz ;
 dcl-s wkStartPos packed(3) Inz ;
 dcl-s wkCommentPos packed(3) Inz ;
 dcl-s wkProcedureLibraryName char(10) Inz ;
 dcl-s wkProcedureFoundInSysTable char(1) Inz ;
 dcl-s ReferencedObjectFound char(1) Inz ;
 dcl-s ServicepgmObjectFound char(1) Inz ;                                               //0001
 dcl-s ReferenceObjType char(10) Inz ;                                                   //0001
 dcl-s uppgm_name char(10)     inz;
 dcl-s uplib_name char(10)     inz;
 dcl-s upsrc_name char(10)     inz;
 dcl-s uptimestamp Timestamp;
 // dcl-s wkReferencedObject char(20) Inz;                                               //0001
 dcl-s wkReferencedObject char(80) Inz;
 dcl-s wkRefSysNamObj char(80) Inz;
 dcl-s wkmlseu2 char(10) Inz;
 dcl-s wkmlseu char(10) Inz;
 dcl-s wkRefObjFromPos zoned(4) Inz;
 dcl-s wkRefObjToPos zoned(4) Inz;
 dcl-s wkuwSrcDta char(4046) Inz;
 dcl-s wkSqlText1 char(500) Inz ;
 dcl-s wkSqlText2 char(500) Inz ;
 dcl-s Ddl_Member_Libr char(10) inz;                                                     //0005
 dcl-s Ddl_Member_Srcf char(10) inz;                                                     //0005
 dcl-s DdL_Member_Name char(10) inz;                                                     //0005
 dcl-s RowsFetched     uns(5);                                                           //0005
 dcl-s noOfRows        uns(5);                                                           //0005
 dcl-s uwindx          uns(5);                                                           //0005
//Indicator type variable.
 dcl-s wkIsLeave ind Inz ;
 dcl-s wkProcedureFound ind Inz ;
 dcl-s rowFound        ind          inz('0');                                            //0005
 dcl-s Data_Found_IAOBJMAP ind inz('0');                                                 //0005

 dcl-c w_lo                 'abcdefghijklmnopqrstuvwxyz';
 dcl-c w_Up                 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
 dcl-c TRUE            '1';                                                              //0005
 dcl-c FALSE           '0';                                                              //0005

//Copy directories declaration
/copy 'QCPYSRC/iaderrlog.rpgleinc'

//Data Structure Defination.
dcl-ds dsRpgMember extname('IAQRPGSRC')  qualified;
end-ds;

dcl-ds iaMetaInfo dtaara len(62);                                                        //0003
   runMode char(7) pos(1);                                                               //0003
end-ds;                                                                                  //0003
dcl-ds DdlDetailArr qualified dim(500);                                                  //0005
   Table_Long_Name  Char(128) inz;                                                       //0005
   Long_Name_Schema Char(128) inz;                                                       //0005
   Table_Name  char(10) inz;                                                             //0005
   Table_Schma char(10) inz;                                                             //0005
End-ds;                                                                                  //0005
dcl-ds dsDDLPF qualified ;                                                               //0005
   Table_Long_Name  Char(128) inz;                                                       //0005
   Long_Name_Schema Char(128) inz;                                                       //0005
   Table_Name  char(10) inz;                                                             //0005
   Table_Schma char(10) inz;                                                             //0005
End-ds;                                                                                  //0005

//---------------------------------------------------------------------
//Mainline Programming
//---------------------------------------------------------------------
 exec sql
  set option commit    = *none,
             naming    = *sys,
             usrprf    = *user,
             dynusrprf = *user,
             closqlcsr = *endmod;

 Eval-corr uDpsds = wkuDpsds;

 uptimeStamp = %Timestamp();
 CallP IAEXCTIMR('IALNGNMDTR' :udpsds.ProcNme : udpsds.Lib : '*PGM' :                    //0008
                  upsrc_name : uppgm_name : uplib_name : ' ' :
                  //0012 uptimeStamp : 'INSERT');
                  ' ' : uptimeStamp : 'INSERT');                                         //0012

 In iAMetaInfo;                                                                          //0003
 if runmode = 'REFRESH';                                                                 //0003
    //Clear the data for modified sources from IALNGNMDTL file                          //0009
    clearRefreshData();                                                                  //0003
 endif;                                                                                  //0003

 //Parse DDL/DDS sources to get the stored procedure details.
 build_sql_statement('iaqddssrc':'wsrcdta') ;
 GetStoredProcedureDetail() ;

 //Parse CL sources to get the stored procedure details.
 build_sql_statement('iaqclsrc' :'ysrcdta') ;
 GetStoredProcedureDetail() ;

 //Parse RPG sources to get the stored procedure details.
 build_sql_statement('iaqrpgsrc':'xsrcdta') ;
 GetStoredProcedureDetail() ;

 //Parse Cobol sources to get the stored procedure details.
 build_sql_statement('iaqcblsrc':'zsrcdta') ;
 GetStoredProcedureDetail() ;

 //Update references for the stored procedure.
 GetStoredProcedureReferences();

 //Get the long name for the PFSQL, View, Index.                                        //0005
 GetLongLameForDdlTableViewIndex();                                                      //0005

 upTimeStamp = %Timestamp();
 CallP IAEXCTIMR('IALNGNMDTR' :udpsds.ProcNme : udpsds.Lib : '*PGM' :                    //0008
                  upsrc_name : uppgm_name : uplib_name : ' ' :
                  //0012 uptimeStamp : 'UPDATE');
                  ' ': uptimeStamp : 'UPDATE');                                          //0012

 *inlr = *on ;

/copy 'QCPYSRC/iacerrlog.rpgleinc'

//---------------------------------------------------------------------
// Retrieve Stored procedure from sources.
//---------------------------------------------------------------------
 dcl-proc GetStoredProcedureDetail ;

  exec sql prepare stmt1 from :wksqltext1 ;
  exec sql declare SourceRrnAndMemberDetail cursor for Stmt1 ;

  exec sql open SourceRrnAndMemberDetail ;
  if sqlCode = CSR_OPN_COD;
     exec sql close SourceRrnAndMemberDetail ;
     exec sql open  SourceRrnAndMemberDetail ;
  endif;

  if sqlCode < successCode;
     uDpsds.wkQuery_Name = 'Open_SourceRrnAndMemberDetail_Record' ;
     IaSqlDiagnostic(uDpsds);                                                            //0011
     return ;
  endif;

  exec sql fetch from SourceRrnAndMemberDetail
   into :wkLibraryName, :wkSourcePfName, :wkMemberName, :wkSourceRrn;
  if sqlCode < successCode;
     uDpsds.wkQuery_Name = 'Fetch1_SourceRrnAndMemberDetail_Record' ;
     IaSqlDiagnostic(uDpsds);                                                            //0011
     return ;
  endif;

  exec sql prepare stmt2 from :wksqltext2 ;
  exec sql declare fetchSourceLine cursor for Stmt2 ;
  dow sqlcode = *zeros ;
     exec sql open fetchSourceLine using :wkLibraryName, :wkSourcePfName,
                                         :wkMemberName, :wkSourceRrn ;
     if sqlCode = CSR_OPN_COD;
        exec sql close fetchSourceLine ;
        exec sql open  fetchSourceLine ;
     endif;

     if sqlCode < successCode;
        uDpsds.wkQuery_Name = 'Open_fetchSourceLine_Record' ;
        IaSqlDiagnostic(uDpsds);                                                         //0011
        return ;
     endif;

     //Initialize variables before proceeding.
     Clear wkProcedureText ;
     Clear wkProcedureName ;
     wkProcedureFound = *off ;
     wkIsLeave = *off ;

     exec sql fetch from fetchSourceLine into :wkSourceStm ;
     if sqlCode < successCode;
        uDpsds.wkQuery_Name = 'Fetch1_fetchSourceLine_Record' ;
        IaSqlDiagnostic(uDpsds);                                                         //0011
        return ;
     endif;

     dow sqlcode = *zeros ;
        Monitor ;
           ParseString() ;
        On-Error ;
           leave ;
        Endmon ;
        if wkIsLeave ;
           leave ;
        endif ;
        exec sql fetch next from fetchSourceLine into :wkSourceStm ;
        if sqlCode < successCode;
           uDpsds.wkQuery_Name = 'Fetch2_fetchSourceLine_Record' ;
           IaSqlDiagnostic(uDpsds);                                                      //0011
           leave ;
        endif;
     enddo ;
     exec sql close fetchSourceLine ;

     exec sql fetch next from SourceRrnAndMemberDetail
      into :wkLibraryName, :wkSourcePfName, :wkMemberName, :wkSourceRrn ;
     if sqlCode < successCode;
        uDpsds.wkQuery_Name = 'Fetch2_SourceRrnAndMemberDetail_Record' ;
        IaSqlDiagnostic(uDpsds);                                                         //0011
        leave ;
     endif;
  enddo ;
  exec sql close SourceRrnAndMemberDetail ;
 end-proc;

//---------------------------------------------------------------------
// Extract Library and Procedure Name.
//---------------------------------------------------------------------
 dcl-proc ParseString ;
  //Remove leading spaces for further checks.
  //wkSourceStm = %triml(%upper(wkSourceStm)) ;
  wkSourceStm = %triml(%xlate(w_lo:w_Up:wkSourceStm));
  //Check for comments if any.
  wkCommentPos = %scan('--':wkSourceStm:1) ;
  if wkCommentPos > 1 ;
     wkSourceStm = %subst(wkSourceStm:1:wkCommentPos-1) ;
  endif ;
  //Get String Length.
  wkStrlength = %len(%trim(wkSourceStm)) ;
  //verify if PROCEDURE specified.
  wkProcdurePos = %Scan('PROCEDURE ':wkSourceStm) ;
  If wkProcdurePos > 0 and
     not wkProcedureFound ;
     //Get procedure name,also verify whether it is qualified by library name.
     wkBlankPos = %Scan(' ':wkSourceStm:wkProcdurePos) + 1 ;
     if wkBlankPos > 0 ;
        //Get the non blank position to start parsing.
        wkStartPos = %Check(' ':wkSourceStm:wkBlankPos) ;
        //get the end position of string if text is there.
        if wkStartPos > 0 ;
           wkBlankPos = %Scan(' ':wkSourceStm:wkStartPos) ;
        endif ;
        If wkBlankPos > 0 and wkStartPos > 0 ;
           WkOpenBracketPos = %Scan('(':wkSourceStm:wkStartPos) ;
           If WkOpenBracketPos > 0 ;
              wkEndPosition = WkOpenBracketPos ;
           else ;
              wkEndPosition = wkBlankPos ;
           endif ;
           exsr Sr_GetProcedureText ;
        endif ;
     endif ;
     wkProcedureFound = *on ;
  else ;
     //Get procedure name if continued to second line.
     if wkProcedureFound = *on ;
        wkStartPos = %Check(' ':wkSourceStm:1) ;
        wkBlankPos = %Scan(' ':wkSourceStm:1) ;
        If wkStartPos > 0 ;
           WkOpenBracketPos = %Scan('(':wkSourceStm:wkStartPos) ;
        endif ;
        If WkOpenBracketPos > 0 ;
           wkEndPosition = WkOpenBracketPos ;
        else ;
           wkEndPosition = wkBlankPos ;
        endif ;
        exsr Sr_GetProcedureText ;
     endif ;
  endif ;
//---------------------------------------------------------------------
// Get procedure text.
//---------------------------------------------------------------------
 Begsr Sr_GetProcedureText ;
  if wkStartPos > 0 and
     wkEndPosition-wkStartPos >= 1 and
     wkStartPos < wkStrlength ;
     if wkProcedureFound ;
        wkProcedureText = %trim(wkProcedureText) +
                          %Subst(wkSourceStm:wkStartPos:wkEndPosition-wkStartPos) ;
     else ;
        wkProcedureText = %Subst(wkSourceStm:wkStartPos:wkEndPosition-wkStartPos) ;
     endif ;
  endif ;
  //Get procedure name.
  If wkProcedureText <> *Blanks ;
     Get_Library_and_procedure_Name();
     Check_Stored_procedure() ;
     if wkProcedureFoundInSysTable = 'Y' ;
        Insert_Long_Name() ;
        wkIsLeave = *on ;
     endif ;
  endif ;
 Endsr ;
 end-proc ;
//---------------------------------------------------------------------
// Build SQL Statement to be used in cursor.
//---------------------------------------------------------------------
 dcl-proc build_sql_statement ;
  dcl-pi *n ;
   upfilename char(10) value ;
   upfilterfield1 char(30) value ;
  end-pi ;
  Clear wksqltext1 ;

  if runmode = 'REFRESH';                                                                //0003

     wksqltext1 = 'select distinct a.library_name, a.sourcepf_name, ' +                  //0003
                  'a.member_name, a.source_rrn from ' + %trim(upfilename) +              //0003
                  ' a join iarefobjf ref on' +                                           //0003
                  ' a.library_name = ref.member_library and' +                           //0003
                  ' a.sourcepf_name = ref.iasrcpf and' +                                 //0003
                  ' a.member_name = ref.iamemname' +                                     //0003
                  ' where upper(a.' + %trim(upfilterfield1) +                            //0003
                  ') like ''CREATE%'' and exists (select * from ' + %trim(upfilename) +  //0003
                  ' where member_name = a.member_name and ' +                            //0003
                  'upper(' + %trim(upfilterfield1) + ') like ''%PROCEDURE%'')' ;         //0003
  else;                                                                                  //0003

     wksqltext1 = 'select distinct a.library_name, a.sourcepf_name, ' +
                  'a.member_name, a.source_rrn from ' + %trim(upfilename) +
                  ' a where upper(a.' + %trim(upfilterfield1) +
                  ') like ''CREATE%'' and exists (select * from ' + %trim(upfilename) +
                  ' where member_name = a.member_name and ' +
                  'upper(' + %trim(upfilterfield1) + ') like ''%PROCEDURE%'')' ;

  endif;                                                                                 //0003

  Clear wksqltext2 ;
  wksqltext2 = 'select ' + %trim(upfilterfield1) + ' from ' +
               %trim(upfilename) +
              ' where library_name  = ? and ' +
              'sourcepf_name = ? and ' +
              'member_name   = ? and ' +
              'source_rrn >= ? and ' +
              'substr(trim(' + %trim(upfilterfield1) + '),1,2) <> ''--'' ' ;

 end-proc ;
//---------------------------------------------------------------------
// Extract Library and Procedure Name.
//---------------------------------------------------------------------
 dcl-proc Get_Library_and_procedure_Name ;
  //Extract library name if applicable.
  wkSlashDotPos = %Scan('/':wkProcedureText:1) ;
  If wkSlashDotPos = 0 ;
     wkSlashDotPos = %Scan('.':wkProcedureText:1) ;
  endif ;
  wkEndPosition = %Scan(' ':wkProcedureText:1) ;
  If wkSlashDotPos > 0 ;
     wkProcedureLibraryName = %Subst(wkProcedureText:1:wkSlashDotPos-1) ;
     if wkSlashDotPos > 0 and
        wkEndPosition-wkSlashDotPos >= 1 and
        wkSlashDotPos < wkStrlength ;
        wkProcedureName = %Subst(wkProcedureText:wkSlashDotPos+1:wkEndPosition-wkSlashDotPos) ;
     endif ;
  else ;
     if wkBlankPos > 1 ;
        wkProcedureName = %Subst(wkProcedureText:1:wkBlankPos-1) ;
     endif ;
  endif ;
 end-proc ;
//---------------------------------------------------------------------
// Check for Stored Procedure.
//---------------------------------------------------------------------
 dcl-proc Check_Stored_procedure ;

    //Using "Routine Name" instead of "Specific Name" as the "specific name"               //0001
    //contains specifc name of the stored procedure provided with SPECIFIC keyword.        //0001
    wkProcedureFoundInSysTable = 'N' ;
    exec sql select 'Y' into :wkProcedureFoundInSysTable
           // from qsys2.sysroutine  join #iadta.iainplib                                  //0010
              from qsys2.sysroutine  join iainplib                                         //0010
             on specific_Schema = library_name
             where upper(Routine_Name) = :wkProcedureName and                              //0001
                 xref_name = :in_repository limit 1;                                       //AJ01
 end-proc ;
//---------------------------------------------------------------------
// Insert data into long name file.
//---------------------------------------------------------------------
 dcl-proc Insert_Long_Name ;
  Exec Sql
    insert into IALNGNMDTL                                                              //0009
    (
      aisrcmbr,
      aisrclib,
      aisrcfil,
      aispclib,
      aispcnam,
      airtnlib,
      airtnnam,
      airtntyp,
      airtnbdy,
      aiextlib,
      aiextnam,
      ailang,
      determin
    )
    select :wkMemberName                   as source_member,
           :wkLibraryName                  as source_library,
           :wkSourcePfName                 as source_file,
           SubStr(Specific_Schema,1,15)    as specific_lib ,
           SubStr(Specific_Name,1,100)     as specific_name ,
           SubStr(Routine_Schema,1,15)     as routine_schema,
           SubStr(Routine_Name,1,100)      as routine_name,
           Coalesce(Routine_Type, ' ')     as routine_type,
           Coalesce(Routine_Body, ' ')     as routine_body,
           SubString(External_Name ,
                     1 ,
                    (Locate('/',External_name) -1 ) )      as external_lib,
           SubString (External_Name,
                     (Locate('/',External_Name) + 1),
                     (Length(External_Name) - Length(Substring(External_Name,
                                                               1,
                      (locate('/', external_name) - 1))))) as external_name,
           Coalesce(External_Language, ' ')        as ext_lang,
           Coalesce(Is_Deterministic , ' ')        as is_deterministic
           from QSYS2.sysroutine
         //join #iadta.iainplib                                                            //0010
           join IaInpLib                                                                   //0010
         // on  specific_Schema = #IADTA.iainplib.LIBRARY_NAME                             //0010
            on  specific_Schema = iainplib.LIBRARY_NAME                                    //0010
           where XREF_NAME = :in_repository and
                 Routine_Name = :wkProcedureName ;                                         //0001
 end-proc ;
//------------------------------------------------------------------------------------
//SubProcedure GetStoredProcedureReferences  : Get store procedure reference object &
//                                            write into iasrcintpf file.
//------------------------------------------------------------------------------------
 dcl-proc GetStoredProcedureReferences ;

 Clear wksqltext1 ;                                                                      //0004
                                                                                         //0004
 if runmode = 'REFRESH';                                                                 //0004
    wksqltext1 = 'select * from iaqrpgsrc A where exists (select * from ' +              //0004
                 'iarefobjf ref where a.library_name = ref.member_library and ' +        //0004
                 'a.sourcepf_name = ref.iasrcpf and a.member_name = ' +                  //0004
                 'ref.iamemname) and upper(a.xsrcdta) like ''%CALL %''';                 //0004
 else;                                                                                   //0004
    wksqltext1 = 'select * from iaqrpgsrc where upper(xsrcdta) ' +                       //0004
                 'like ''%CALL %''';                                                     //0004
 endif;                                                                                  //0004
                                                                                         //0004
 exec sql prepare stmt3 from :wksqltext1 ;                                               //0004
 exec sql declare rpgrecord cursor for stmt3 ;                                           //0004

 exec sql
   open rpgrecord;

 if sqlCode = CSR_OPN_COD;
    exec sql close rpgrecord;
    exec sql open  rpgrecord;
 endif;
 if sqlCode < successCode;
    uDpsds.wkQuery_Name = 'Open_CSR_rpgrecord' ;
    IaSqlDiagnostic(uDpsds);                                                             //0011
 endif;

 if sqlCode = successCode;

    exec sql fetch rpgrecord into :dsrpgmember;

    if sqlCode < successCode;
       uDpsds.wkQuery_Name = 'Fetch1_CSR_rpgrecord' ;
       IaSqlDiagnostic(uDpsds);                                                          //0011
    endif;

    dow sqlCode = successCode;
       clear     wkrefobjfrompos;
       clear     wkrefobjtopos  ;
       clear     wkReferencedObject;
       clear     wkRefSysNamObj;
       clear     wkuwsrcdta ;
       clear     ReferencedObjectFound ;
       monitor;
        //wkuwsrcdta = %upper(dsrpgmember.xsrcdta);
        wkuwsrcdta = %xlate(w_lo:w_Up:dsrpgmember.xsrcdta);
        wkrefobjfrompos  =  %scan('CALL' : wkuwsrcdta : 1) ;
        if wkrefobjfrompos > *zeros;
           wkrefobjtopos  = %scan('(' : wkuwsrcdta : wkrefobjfrompos + 5);
           if wkrefobjtopos > 0 and (wkrefobjtopos - (wkrefobjfrompos+5)) > 0;
              wkReferencedObject  = %trim(%subst(wkuwsrcdta: (wkrefobjfrompos + 5) :
                                          wkrefobjtopos - (wkrefobjfrompos+5)));
              exec sql
                select 'Y'
                  into :ReferencedObjectFound
                  from IALNGNMDTL                                                        //0009
                 where upper(airtnnam) = trim(:wkReferencedObject) limit 1 ;                 //AJ01
              if ReferencedObjectFound = 'Y' ;
                 WriteIaSrcIntPfDetails();
              endif;
           endif;
        endif;
       on-error;
       endmon;
       exec sql fetch rpgrecord into :dsrpgmember;
       if sqlCode < successCode;
          uDpsds.wkQuery_Name = 'Fetch2_CSR_rpgrecord' ;
          IaSqlDiagnostic(uDpsds);                                                       //0011
       endif;
    enddo;
 endif;
 exec sql
  close rpgrecord;

end-proc;
//------------------------------------------------------------------------------------
//SubProcedure writeIaSrcIntPfdetails : Write details into writeiaSrcIntPf details.
//------------------------------------------------------------------------------------
dcl-proc  WriteIaSrcIntPfDetails;
     clear wkmlseu2;
     clear wkmlseu;

     exec sql
       select specific_name
         into :wkRefSysNamObj
         from IALNGNMDTL                                                                 //0009
         where upper(aispclib) = trim(:dsrpgmember.xlibnam)
           And upper(aispcnam) = trim(:wkReferencedObject) limit 1;                  //AJ01

     if sqlCode = NO_DATA_FOUND;                                                     //0001
        exec sql                                                                     //0001
          select specific_name                                                       //0001
            into :wkRefSysNamObj                                                     //0001
            from IALNGNMDTL                                                   //0009 //0001
           where upper(aispclib) = trim(:dsrpgmember.xlibnam)                        //0001
             And upper(AIRTNNAM) = trim(:wkReferencedObject) limit 1 ;               //0001

        if sqlCode = NO_DATA_FOUND;
           exec sql
             select specific_name
               into :wkRefSysNamObj
               from IALNGNMDTL                                                           //0009
               where upper(aispclib) = trim(:dsrpgmember.xlibnam)
               And upper(aiextnam) = trim(:wkReferencedObject) limit 1 ;              //AJ01
           If sqlCode = NO_DATA_FOUND;
             Return;
           EndIf;
        endif;

     endif;                                                                          //0001

     // Populate referenced object type for service pgm from IDSPSRVREF              //0001
     // instead of hardcode                                                          //0001
     ServicepgmObjectFound = *Blanks;                                                //0001
     exec sql                                                                        //0001
       select 'Y'                                                                    //0001
         into :ServicepgmObjectFound                                                 //0001
         from IDSPSRVREF                                                             //0001
        where upper(whpnam) = trim(:wkRefSysNamObj) limit 1 ;                        //0001
     if ServicepgmObjectFound = 'Y' ;                                                //0001
        ReferenceObjType = '*SRVPGM';                                                //0001
     else;                                                                           //0001
        ReferenceObjType = '*PGM'  ;                                                 //0001
     endif;                                                                          //0001

     exec sql
         select mlseu2, mlseu
           into :wkmlseu2, :wkmlseu
           from idspfdmbrl
          where mlname = trim(:dsrpgmember.xmbrnam) limit 1;                         //AJ01

     exec sql
        insert into iasrcintpf (iambrlib,
                                iambrnam,
                                iambrtyp,
                                iambrsrc,
                                iarefobj,
                                iarefotyp,
                                iarefolib,
                                iarefousg,
                                iarfileusg)
                       values  (trim(:dsrpgmember.xlibnam),
                                trim(:dsrpgmember.xmbrnam),
                                trim(:wkmlseu2),
                                trim(:dsrpgmember.xsrcnam),
                                trim(:wkRefSysNamObj),
                                :ReferenceObjType,                                       //0001
                                trim(:dsrpgmember.xlibnam),
                                'I'    ,                                                 //0002
                                trim(:wkmlseu) );
end-proc;

//------------------------------------------------------------------------------------- //
//SubProcedure clearRefreshData: Clear records for modified members from IALNGNMDTL     //0009
//                               file during Refresh Metadata
//------------------------------------------------------------------------------------- //
dcl-proc clearRefreshData;                                                               //0003

   exec sql                                                                              //0003
      delete from iaLngNmDtl where exists (                                     //0009   //0003
              select 1                                                                   //0003
                from iaRefObjf ref                                                       //0003
               where iastatus = 'M'                                                      //0003
                 and source_library = ref.member_library                                 //0003
                 and source_file = ref.iasrcpf                                           //0003
                 and source_member = ref.iamemname);                                     //0003
                                                                                         //0003
  if sqlCode < successCode;                                                              //0003
     uDpsds.wkQuery_Name = 'Delete_IALNGNMDTL_1';                                //0009  //0003
     IaSqlDiagnostic(uDpsds);                                                            //0003 0011
     return ;                                                                            //0003
  endif;                                                                                 //0003
                                                                                         //0003
end-proc;                                                                                //0003

//------------------------------------------------------------------------------------- //
//SubProcedure GetLongLameForDdlTableViewIndex : Insert the long name for DDL table,
//                                               View and Index in IALNGNMDTL           //0009
//------------------------------------------------------------------------------------- //
dcl-proc GetLongLameForDdlTableViewIndex;                                                //0005
   //Declare a cursor to fetch the record for the object those are available in         //0005
   //repo library.                                                                      //0005
   Exec Sql                                                                              //0005
      Declare GetSqlLngNm cursor for                                                     //0005
     Select Table_Name,                                                                  //0005
            Table_Schema,                                                                //0005
            System_Table_Name,                                                           //0005
            System_Table_Schema                                                          //0005
        FROM qsys2.systables                                                             //0005
        where  System_Table_Schema in (                                                  //0005
            // select Library_Name from #iadta.iainplib                            //0010//0005
               select Library_Name from iainplib                                         //0010
               where Xref_Name = trim(:in_repository));                                  //0005
                                                                                         //0005
   Exec Sql Open GetSqlLngNm ;                                                           //0005
   if sqlCode = CSR_OPN_COD;                                                             //0005
      Exec Sql Close GetSqlLngNm ;                                                       //0005
      Exec Sql Open  GetSqlLngNm ;                                                       //0005
   Endif;                                                                                //0005
                                                                                         //0005
   if sqlCode < successCode;                                                             //0005
      uDpsds.wkQuery_Name = 'Open_GetSqlLngNm';                                          //0005
      IaSqlDiagnostic(uDpsds);                                                           //0005 0011
      return ;                                                                           //0005
   endif;                                                                                //0005
   if sqlCode = successCode;                                                             //0005
      noOfRows = %elem(DdlDetailArr);                                                    //0005
      rowFound = fetchRecordDsGetSqlLngNm();                                             //0005
      dow rowFound;                                                                      //0005
         for uwindx = 1 to RowsFetched;                                                  //0005
            dsDdlPf = DdlDetailArr(uwindx);                                              //0005
            //Proceed only if Long name and Short name of table is not same.
            If %trim(dsDdlPf.Table_Name) <> %trim(dsDdlPf.Table_Long_Name);              //0005

               Ddl_Member_Libr = *Blank;                                                 //0005
               Ddl_Member_Srcf = *Blank;                                                 //0005
               DdL_Member_Name = *Blank;                                                 //0005

               //If table short name and library not blank.
               If dsDdlPf.Table_Name <> *Blank and                                       //0005
                  dsDdlPf.Table_Schma <> *Blank ;                                        //0005
                  Exec sql                                                               //0005
                    select Member_Libr,                                                  //0005
                           Member_Srcf,                                                  //0005
                           Member_Name                                                   //0005
                    Into  :Ddl_Member_Libr,                                              //0005
                          :Ddl_Member_Srcf,                                              //0005
                          :DdL_Member_Name                                               //0005
                    From  IaObjMap                                                       //0005
                    where Object_Libr = :dsDdlPf.Table_Schma                             //0005
                    and   Object_Name = :dsDdlPf.Table_Name;                             //0005

                  if sqlCode < successCode;                                              //0005
                     uDpsds.wkQuery_Name = 'Fetch_From_IAOBJMAP';                        //0005
                     IaSqlDiagnostic(uDpsds);                                            //0005 0011
                  endif;                                                                 //0005

                  //Write Data irrespective of Source details found or not.             //0005
                  Exsr Write_Data_iALngNmDtl;                                  //0009    //0005
               Endif;                                                                    //0005
            Endif;                                                                       //0005
         endfor;                                                                         //0005
         if RowsFetched < noOfRows ;                                                     //0005
            leave ;                                                                      //0005
         endif ;                                                                         //0005
                                                                                         //0005
         rowFound = fetchRecordDsGetSqlLngNm();                                          //0005
      Enddo;                                                                             //0005
   // exec sql close SourceRrnAndMemberDetail ;                                   //0006d//0005
      exec sql close GetSqlLngNm;                                                        //0006
   Endif;                                                                                //0005

//---------------------------------------------------------------------
//Subroutine: Write_Data_iALngNmDtl.                                                    //0009
//            Write the data in IALNGNMDTL file.                                 //0009 //0005
//---------------------------------------------------------------------
   Begsr Write_Data_iALngNmDtl;                                                   //0009 //0005
      Exec Sql                                                                           //0005
         insert into iALngNmDtl                                                   //0009 //0005
         (                                                                               //0005
           aisrcmbr,                                                                     //0005
           aisrclib,                                                                     //0005
           aisrcfil,                                                                     //0005
           aispclib,                                                                     //0005
           aispcnam,                                                                     //0005
           airtnlib,                                                                     //0005
           airtnnam,                                                                     //0005
           airtntyp,                                                                     //0005
           airtnbdy,                                                                     //0005
           aiextlib,                                                                     //0005
           aiextnam,                                                                     //0005
           ailang,                                                                       //0005
           determin                                                                      //0005
           )                                                                             //0005
         values                                                                          //0005
           (                                                                             //0005
           :DdL_Member_Name,                                                             //0005
           :Ddl_Member_Libr,                                                             //0005
           :Ddl_Member_Srcf,                                                             //0005
           Trim(:dsDdlPf.Long_Name_Schema),                                              //0005
           Trim(:dsDdlPf.Table_Long_Name) ,                                              //0005
           ' ',                                                                          //0005
           ' ',                                                                          //0005
           'DDL',                                                                        //0005
           'SQL',                                                                        //0005
           :dsDdlPf.Table_Schma,                                                         //0005
           :dsDdlPf.Table_Name,                                                          //0005
           ' ',                                                                          //0005
           ' ');                                                                         //0005
   Endsr;                                                                                //0005
end-proc;                                                                                //0005
                                                                                         //0005
//---------------------------------------------------------------------
//SubProcedure fetchRecordDsGetSqlLngNm :
//Read the record in block and store in an array.
//---------------------------------------------------------------------
dcl-proc fetchRecordDsGetSqlLngNm ;                                                      //0005
   dcl-pi fetchRecordDsGetSqlLngNm  ind end-pi ;                                         //0005
   dcl-s  rcdFound ind inz('0');                                                         //0005
   dcl-s  wkRowNum like(RowsFetched) ;                                                   //0005
   RowsFetched = *zeros;                                                                 //0005
   clear DdlDetailArr ;                                                                  //0005
   exec sql                                                                              //0005
     fetch  GetSqlLngNm for :noOfRows rows into :DdlDetailArr ;                          //0005
                                                                                         //0005
   if sqlcode = successCode;                                                             //0005
      exec sql get diagnostics                                                           //0005
          :wkRowNum = Row_Count;                                                         //0005
           RowsFetched  = wkRowNum ;                                                     //0005
   endif;                                                                                //0005
   if RowsFetched > 0;                                                                   //0005
      rcdFound = TRUE;                                                                   //0005
   elseif sqlcode < successCode ;                                                        //0005
      rcdFound = FALSE;                                                                  //0005
   endif;                                                                                //0005
   return rcdFound;                                                                      //0005
end-proc;                                                                                //0005
