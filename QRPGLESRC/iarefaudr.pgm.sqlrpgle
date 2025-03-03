**free
      //%METADATA                                                      *
      // %TEXT Program to populate Audit Report file                   *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------- //
//Created By     : Programmers.io @ 2023                                                //
//Creation Date  : 2023/11/30                                                           //
//Developer      : Saikiran Parupalli                                                   //
//Description    : Populate the Audit Report file IAREFAUDF                             //
//                 During REFRESH Process :                                             //
//                  1. This program will read IAREFOBJF file to get the details of the  //
//                     modified/added/deleted members/objects written during refresh    //
//                     process and populate the Audit report file IAREFAUDF             //
//                  2. The Audit Number from the Data Area IAMETAINFO will be           //
//                     incremented                                                      //
//                                                                                      //
//                 During INIT Process:                                                 //
//                  1. The Audit Number from Data Area IAMETAINFO will be reset to      //
//                     00000                                                            //
//                                                                                      //
//Procedure Log:                                                                        //
//------------------------------------------------------------------------------------- //
//Procedure Name           | Procedure Description                                      //
//-------------------------|----------------------------------------------------------- //
//No Procedure             |                                                            //
//------------------------------------------------------------------------------------- //
//                                                                                      //
//Modification Log:                                                                     //
//------------------------------------------------------------------------------------- //
//Date    | Developer  | Case and Description                                           //
//--------|------------|--------------------------------------------------------------- //
//13/12/23| Himanshu   | Replace usage of IDSPFDMBRL with IAMEMBER table -TAG:0001      //
//        | Gahtori    | Task#:442                                                      //
//5/2/2024| Mahima     | Task# : 554 In case if we delete object in refresh library     //
//        |            | name coming as blanks TAG: 0002                                //
// 7/2/2024| Vamsi      | Task# : 248 Rename the file AIEXCTIME to IAEXCTIME . Tag#0003  //
//05/07/24| Akhil K.   | Task# : 261 Renamed AIERRBND, AICERRLOG, AIDERRLOG and AISQLDIA//
//        |            | GNOSTIC with IA* Tag#0004                                      //
//19/09/24| Manav T.   | Task# : 949 Audit file is written for copybook members not in  //
//        |            | repo library list. TAG#0005                                    //
//04/07/24| Piyush     | Task#:761 Refresh Audit Report is not capturing creation       //
//        |            | time for source member TAG: 0006                               //
//------------------------------------------------------------------------------------- //
ctl-opt copyright('Programmers.io Â© 2023');
ctl-opt option(*NoDebugIO : *SrcStmt : *noUnRef);
ctl-opt bndDir('IAERRBND');                                                              //0004

//------------------------------------------------------------------------------------- //
//Variable Declaration
//------------------------------------------------------------------------------------- //
dcl-s wkDuration     Char(40)  Inz;
dcl-s wkAuditNum     Char(12)  Inz;
dcl-s wkSqlText      Char(500) Inz;
dcl-s wkRefreshFound Ind       Inz;
dcl-s wkStartTime    Timestamp;
dcl-s wkEndTime      Timestamp;
dcl-s wkCrtDate      Zoned(6)  Inz;
dcl-s wkCrtTime      Zoned(6)  Inz;
dcl-s wkChgDate      Zoned(6)  Inz;
dcl-s wkChgTime      Zoned(6)  Inz;
dcl-s wkRecExists    Char(1)   Inz;

//------------------------------------------------------------------------------------- //
//Constant Declaration
//------------------------------------------------------------------------------------- //
dcl-c ucProcessInit          'INIT';
dcl-c ucProcessRefresh       'REFRESH';
dcl-c ucCaseWhen             'WHEN IAOBJNAME <> '' '' AND IAOBJLIB <> '' ''';

//------------------------------------------------------------------------------------- //
//Data Structure Declaration
//------------------------------------------------------------------------------------- //
dcl-ds objDetailsDs;
   usObjectName Char(10);
   usObjectLib  Char(10);
   usObjectTyp  Char(10);
   usObjectAttr Char(10);
   usSourcePf   Char(10);
   usMemberType Char(10);
   usCreateDate Char(6);
   usCreateTime Char(6);
   usChangeDate Char(6);
   usChangeTime Char(6);
   usStatus     Char(1);
end-ds;

//Get Process Type (REFRESH or INIT) from IAMETAINFO Dataarea.
dcl-ds iaMetaInfo dtaara len(62);
   wProTyp   char(7)  pos(1);
   wAuditNum zoned(5) pos(51);
end-ds;

//------------------------------------------------------------------------------------- //
//Copybook Declaration
//------------------------------------------------------------------------------------- //
/copy 'QCPYSRC/iaderrlog.rpgleinc'

//------------------------------------------------------------------------------------- //
//Entry Parameters
//------------------------------------------------------------------------------------- //
dcl-pi MainPgm   extpgm('IAREFAUDR');
   upProcessName Char(10) Const;
   upProgramName Char(10) Const;
end-pi;

//------------------------------------------------------------------------------------- //
//Mainline Logic
//------------------------------------------------------------------------------------- //
exec sql
  set option Commit    = *None,
             Naming    = *Sys,
             UsrPrf    = *User,
             DynUsrPrf = *User,
             CloSqlCsr = *EndMod;

Eval-corr uDpsds = wkuDpsds;

//Read the Dataarea IAMETAINFO to get the process type and audit number
in *lock iaMetaInfo;
//wkRefreshFound will be on when there is record found in IAREFOBJF file
wkRefreshFound = *Off;

//Get the Start Time, End Time and Duration from IAEXCTIME file                         //0005
exec sql                                                                                 //0005
  select aistarttim, aiendtim, aiduration                                                //0005
    into :wkStartTime,:wkEndTime, :wkDuration                                            //0005
    from iaexctime                                                                       //0005
   where aiprocess = :wProTyp                                                            //0005
     and aipronme  = :upProcessName                                                      //0005
     and aipgm     = :upProgramName;                                                     //0005

//If the Process Type is INIT,
//Reset the audit number in Data area
select;
when wProTyp = ucProcessInit;
   clear wAuditNum;
   out iaMetaInfo;
   wAuditNum = wAuditNum + 1;                                                            //0005
   wkAuditNum = %trim(wProTyp) + %EditC(wAuditNum:'X');                                  //0005

when wProTyp = ucProcessRefresh;
   wAuditNum = wAuditNum + 1;
   wkAuditNum = wProTyp + %EditC(wAuditNum:'X');
   //Get the Start Time, End Time and Duration from IAEXCTIME file                      //0003
// exec sql                                                                              //0005
//   select aistarttim, aiendtim, aiduration                                             //0005
//     into :wkStartTime,:wkEndTime, :wkDuration                                         //0005
//     from iaexctime                                                              //0003//0005
//    where aiprocess = :ucProcessRefresh                                                //0005
//      and aipronme  = :upProcessName                                                   //0005
//      and aipgm     = :upProgramName;                                                  //0005

   //Declare the Cursors to fetch the Member/Object details
   exsr declareSqlCursors;
   //Process and populate the Object details
   exsr processObjectDetails;
   //Process and populate the Member details
   exsr processMemberDetails;
   //Process and populate the deleted Member/Object details
   exsr processDeletedDetails;

   //Update Dataarea only when there are any modified/added/deleted
   //members/objects found during refresh process
   if wkRefreshFound = *On;
      out iaMetaInfo;
   endif;

endsl;

//Process and populate the Copy Book Member details                                     //0005
exsr processCopyBookMemberDetails;                                                       //0005

*inlr = *on;

//------------------------------------------------------------------------------------- //
//SR declareSqlCursors subroutine
//------------------------------------------------------------------------------------- //
begsr declareSqlCursors;

   //Get the Object Details from IAREFOBJF and IDSPOBJD files
   //Using IAOBJECT table instead of IAREFOBJF and IDSPOBJD                             //0001
   exec Sql                                                                              //0001
     declare getObjDetails cursor for                                                    //0001
       select Iaobjnam, Ialibnam , Iaobjtyp, Iaobjatr, ' ', ' ',                         //0006
              Iaocdat, Iaoctim, Iachgdat, Iachgtim, Iarefresh                            //0001
         from iAObject                                                                   //0001
        where Iarefresh in ('A','M');                                                    //0001
   //Get the Member Details from IAREFOBJF and IDSPFDMBRL File                          //0001
   //Replaced IDSPFDMBRL with IAMEMBER table                                            //0001
   exec Sql                                                                              //0001
     declare getMemDetails cursor for                                                    //0001
       select Iambrnam, Iasrclib, Iasrcpfnam, Iambrtype,                                 //0001
              Iacdat, IacTime, Iachgd, Iachgt, Iarefflg                                  //0006
         from iAMember                                                                   //0006
        where Iarefflg in ('A','M');                                                     //0001

   //Get the Deleted Object/Member Details from IAREFOBJF file
   wkSqlText = 'select Case ' + ucCaseWhen + ' then iaobjname ' +
               '       else iamemname end, ' +
               '       case ' + ucCaseWhen + ' then IAOBJLIB  ' +                        //0002
               '       else iamemlib end, ' +
               '       iaobjtype, iaobjattr, iasrcpf, iamemtype, iastatus ' +
               '  from iarefobjf ' +
               ' where iastatus = ''D''';

   exec sql prepare stmt from :wkSqlText;

   exec sql declare getDeletedDetails cursor for Stmt;

endsr;

//------------------------------------------------------------------------------------- //
//SR processObjectDetails subroutine
//------------------------------------------------------------------------------------- //
begsr processObjectDetails;

   exec sql open getObjDetails;

   if sqlCode = CSR_OPN_COD;
      exec sql close getObjDetails;
      exec sql open  getObjDetails;
   endif;

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Open_Cursor_getObjDetails' ;
      IaSqlDiagnostic(uDpsds);                                                           //0004
   endif;

   exec sql fetch getObjDetails into :objDetailsDs;

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Fetch_Cursor_getObjDetails' ;
      IaSqlDiagnostic(uDpsds);                                                           //0004
   endif;

   dow sqlcode  = successCode;
      wkCrtDate = %Dec(usCreateDate:6:0);
      wkCrtTime = %Dec(usCreateTime:6:0);
      wkChgDate = %Dec(usChangeDate:6:0);
      wkChgTime = %Dec(usChangeTime:6:0);

      //Write in the Audit Report file IAREFAUDF
      exsr writeAuditReport;
      //Clear the necessary variables
      exsr clearVarsSr;

      exec sql fetch getObjDetails into :objDetailsDs;

      if sqlCode < successCode;
         uDpsds.wkQuery_Name = 'Fetch_Cursor_getObjDetails' ;
         IaSqlDiagnostic(uDpsds);                                                        //0004
      endif;

   enddo;

   exec sql close getObjDetails;

endsr;

//------------------------------------------------------------------------------------- //
//SR processMemberDetails subroutine
//------------------------------------------------------------------------------------- //
begsr processMemberDetails;

   exec sql open getMemDetails;

   if sqlCode = CSR_OPN_COD;
      exec sql close getMemDetails;
      exec sql open  getMemDetails;
   endif;

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Open_Cursor_getMemDetails' ;
      IaSqlDiagnostic(uDpsds);                                                           //0004
   endif;

   exec sql fetch getMemDetails into :usObjectName, :usObjectLib,
                                     :usSourcePf  , :usMemberType,
                                     :usCreateDate, :usCreateTime,                       //0006
                                     :usChangeDate, :usChangeTime,                       //0006
                                     :usStatus;                                          //0006

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Fetch_Cursor_getMemDetails' ;
      IaSqlDiagnostic(uDpsds);                                                           //0004
   endif;

   dow sqlcode = successCode;
      //Convert the date from YMD format to MDY format
      wkCrtDate = %Dec(%char(%date(usCreateDate:*ymd0):*mdy0):6:0);
      wkChgDate = %Dec(%char(%date(usChangeDate:*ymd0):*mdy0):6:0);
      wkCrtTime = %Dec(usCreateTime:6:0);                                                //0006
      wkChgTime = %Dec(usChangeTime:6:0);

      //Write in the Audit Report file IAREFAUDF
      exsr writeAuditReport;
      //Clear the necessary variables
      exsr clearVarsSr;

      exec sql fetch getMemDetails into :usObjectName, :usObjectLib,
                                        :usSourcePf  , :usMemberType,
                                        :usCreateDate, :usCreateTime,                    //0006
                                        :usChangeDate, :usChangeTime,                    //0006
                                        :usStatus;                                       //0006

      if sqlCode < successCode;
         uDpsds.wkQuery_Name = 'Fetch_Cursor_getMemDetails' ;
         IaSqlDiagnostic(uDpsds);                                                        //0004
      endif;

   enddo;

   exec sql close getMemDetails;

endsr;

//------------------------------------------------------------------------------------- //
//SR processDeletedDetails subroutine
//------------------------------------------------------------------------------------- //
begsr processDeletedDetails;

   exec sql open getDeletedDetails;

   if sqlCode = CSR_OPN_COD;
      exec sql close getDeletedDetails;
      exec sql open  getDeletedDetails;
   endif;

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Open_Cursor_getDeletedDetails' ;
      IaSqlDiagnostic(uDpsds);                                                           //0004
   endif;

   exec sql fetch getDeletedDetails into :usObjectName, :usObjectLib,
                                         :usObjectTyp , :usObjectAttr,
                                         :usSourcePf  , :usMemberType,
                                         :usStatus;

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Fetch_Cursor_getDeletedDetails' ;
      IaSqlDiagnostic(uDpsds);                                                           //0004
   endif;

   dow sqlcode = successCode;
      //Write in the Audit Report file IAREFAUDF
      exsr writeAuditReport;
      //Clear the necessary variables
      exsr clearVarsSr;

      exec sql fetch getDeletedDetails into :usObjectName, :usObjectLib,
                                            :usObjectTyp , :usObjectAttr,
                                            :usSourcePf  , :usMemberType,
                                            :usStatus;

      if sqlCode < successCode;
         uDpsds.wkQuery_Name = 'Fetch_Cursor_getDeletedDetails' ;
         IaSqlDiagnostic(uDpsds);                                                        //0004
      endif;

   enddo;

   exec sql close getDeletedDetails;

endsr;

//------------------------------------------------------------------------------------- //0005
//SR processCopyBookMemberDetails subroutine
//------------------------------------------------------------------------------------- //0005
begsr processCopyBookMemberDetails;

   //Get the Copy Book Member Details from IDSPFDMBRL File
   //Replaced IDSPFDMBRL with IAMEMBER table
   exec Sql
     declare getCBMemDetails sensitive cursor for
       select Iacpymbr, Iacpylib, Iacpysrcpf, Iaaudit
         from iACpyBDtl
        where Iaaudit = 'Y';

   exec sql open getCBMemDetails;

   if sqlCode = CSR_OPN_COD;
      exec sql close getCBMemDetails;
      exec sql open  getCBMemDetails;
   endif;

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Open_Cursor_getCBMemDetails' ;
      IaSqlDiagnostic(uDpsds);
   endif;

   exec sql fetch getCBMemDetails into :usObjectName, :usObjectLib,
                                     :usSourcePf, :usStatus;

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Fetch_Cursor_getCBMemDetails' ;
      IaSqlDiagnostic(uDpsds);
   endif;

   dow sqlcode = successCode;

      wkRecExists = ' ';

      exec sql
        select 'Y' into :wkRecExists
         from iarefaudf
         where getCBMemD = :wkAuditNum and
         iAMbrObjNm = :usObjectName and
         iAMbrObjLb = :usObjectLib and
         iASrcPf = :usSourcePf;

      if wkRecExists = ' ';
         //Write in the Audit Report file IAREFAUDF
         exsr writeAuditReport;
      endif;
      //Clear the necessary variables
      exsr clearVarsSr;

      exec sql fetch getCBMemDetails into :usObjectName, :usObjectLib,
                                        :usSourcePf, :usStatus;

      if sqlCode < successCode;
         uDpsds.wkQuery_Name = 'Fetch_Cursor_getMemDetails' ;
         IaSqlDiagnostic(uDpsds);
      endif;

   enddo;

   exec sql close getCBMemDetails;

endsr;
                                                                                         //0005
//------------------------------------------------------------------------------------- //
//SR writeAuditReport subroutine
//------------------------------------------------------------------------------------- //
begsr writeAuditReport;

   wkRefreshFound = *On;
   exec sql
     insert into iarefaudf (iAAuditNo , iAMbrObjNm, iAMbrObjLb,
                            iAObjType , iAObjAttr , iASrcPf   ,
                            iAMbrType , iAMbObCrtD, iAMbObCrtT,
                            iAMbObChgD, iAMbObChgT, iAStatus  ,
                            iAStartTim, iAEndTime,  iADuration)
     values(:wkAuditNum,   :usObjectName, :usObjectLib ,
            :usObjectTyp , :usObjectAttr, :usSourcePf  ,
            :usMemberType, :wkCrtDate ,   :wkCrtTime ,
            :wkChgDate ,   :wkChgTime ,   :usStatus    ,
            :wkStartTime , :wkEndTime ,   :wkDuration);

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Insert_IAREFAUDF';
      IaSqlDiagnostic(uDpsds);                                                           //0004
   endif;

endsr;

//------------------------------------------------------------------------------------- //
//SR clearVarsSr subroutine
//------------------------------------------------------------------------------------- //
begsr clearVarsSr;

   clear objDetailsDs;
   clear wkCrtDate;
   clear wkChgDate;
   clear wkCrtTime;
   clear wkChgTime;

endsr;
