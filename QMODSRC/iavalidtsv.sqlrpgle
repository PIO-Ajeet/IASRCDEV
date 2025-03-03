**Free
      //%METADATA                                                      *
      // %TEXT IA Service Program for Repo Maintenance from UI         *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------- //
//Created By    : Programmers.io @ 2024                                                 //
//Created Date  : 2024/01/19                                                            //
//Developer     : Naresh Somepalli                                                      //
//Description   : Service Program for Repository validations.                           //
//------------------------------------------------------------------------------------- //
//Procedure Name                   | Procedure Description                              //
//------------------------------------------------------------------------------------- //
// isRepositoryExists              | This procedure will validate whether the repository//
//                                 | exists in the system and in IAINPLIB file.         //
// isRepositoryInUse               | This procedure will determine whether the repo     //
//                                 | is in Use (Locked,Submitted or In Progress) state. //
// isRepositoryNameValid           | This procedure will checks the valid characters in //
//                                 | repository name.                                   //
// isAppLibraryExists              | This procedure will check whether application      //
//                                 | library is exists in the system or not.            //
// checkLibraryListDiffForRefresh  | This procedure will compare library list set       //
//                                 | during INIT process and compare the list during    //
//                                 | REFRESH. It will return error if any diff found.   //
// lockRepository                  | This procedure is used to lock the repository.     //
// unlockRepository                | This procedure is used to unlock the repository.   //
// rtvJobLogMessage                | This procedure will fetch the latest message from  //
//                                 | the joglog and return to out_message.              //
// deallocateRepoObjects           | This procedure will deallocate the objects that    //
//                                 | are present in the repository.                     //
// isrepositoryScheduled           | This procedure checks if repo is sceduled or not   //
// isrepositoryProcessing          | This procedure checks if repo is in processing     //
//                                 |  state or not.                                     //
// setRepositoryStatus             | This procedure will set the repository status as   //
//                                 | per the supplied parameter.                        //
//------------------------------------------------------------------------------------- //
// Modification Log:                                                                    //
//------------------------------------------------------------------------------------- //
// Date    | Mod_ID |Task# | Developer  | Case and Description                          //
//---------|--------|------|----------------------------------------------------------- //
// 19/01/24|        | 542  | Naresh S   | Initial Creation.                             //
// 04/07/24| 0001   | 261  | Jeeva      | Rename Bnddir AIERRBND to IAERRBND.           //
//         |        |      |            | (Mod: 0001) [Task#261]                        //
//------------------------------------------------------------------------------------- //

ctl-opt copyright('Copyright @ Programmers.io 2024 ') ;
ctl-opt option(*noDebugIo: *srcStmt: *noUnRef) expropts(*RESDECPOS) debug;
ctl-opt nomain;
ctl-opt bndDir('IABNDDIR': 'IAERRBND');                                                  //0001

//------------------------------------------------------------------------------------- //
//Copy Book Definitions                                                                 //
//------------------------------------------------------------------------------------- //
/copy 'QMODSRC/iasrv01pr.rpgleinc'
/copy 'QMODSRC/iavalidtpr.rpgleinc'

//------------------------------------------------------------------------------------- //
//Standalone Variable Definitions                                                       //
//------------------------------------------------------------------------------------- //
dcl-s Command     varchar(1000) inz;
dcl-s uwError     char(1)       inz;

//------------------------------------------------------------------------------------- //
//Constant Definitions                                                                  //
//------------------------------------------------------------------------------------- //
dcl-c SqlAllOk  '00000';
dcl-c Quote '''' ;

//------------------------------------------------------------------------------------- //
//Mainline Programming                                                                  //
//------------------------------------------------------------------------------------- //
Exec Sql
  Set option commit    = *none,
             naming    = *sys,
             usrprf    = *user,
             dynusrprf = *user,
             closqlcsr = *endmod,
             srtseq    = *langidshr;

//------------------------------------------------------------------------------------- //
//isRepositoryExists - Return status as 'E' if repo does not exists else 'S' for exists.//
//------------------------------------------------------------------------------------- //
dcl-proc isRepositoryExists export ;

   dcl-pi isRepositoryExists ;
      upXref        varchar(10) const options(*trim) ;
      upAction      char(1) const ;
      upStatus      char(1) ;
      upMessageId   char(7) ;
   end-pi ;

   dcl-s uwCount     packed(12:0) inz;

   clear upStatus ;
   clear upMessageId ;
   Exec Sql
      select count(*) into :uwCount
      from IaInpLib
      where Xref_Name = :upXref;

   if uwCount <> *Zeros  ;
      upStatus  = 'S' ;                 //Repo name already exists in the system
      upMessageId = 'MSG0003' ;
      return ;
   endif ;

   clear command ;
   clear uwError ;
   command = 'CHKOBJ OBJ(QSYS/'+ upXref + ') OBJTYPE(*LIB)' ;
   runcommand(Command:UwError) ;

   if Uwerror = *Blank ;
      upStatus  = 'S' ;                 //Repo Library already exists in the system
      upMessageId = 'MSG0004' ;
      return ;
   endif ;

   upStatus = 'E' ;
   upMessageId = 'MSG0141' ;
   return ;

end-proc isRepositoryExists ;

//------------------------------------------------------------------------------------- //
//isRepositoryInUse - Return status 'E' and send appropriate message if                 //
//                    repository is either Locked or Submitted state or InProgress      //
//                    state else returns blanks.                                        //
//------------------------------------------------------------------------------------- //
dcl-proc isRepositoryInUse export ;

   dcl-pi isRepositoryInUse ;
      upXref      varchar(10) const options(*trim) ;
      upStatus    char(1) ;
      upMessageId char(7) ;
   end-pi;

   dcl-s uwBuilt   char(1) inz ;

   upStatus = 'E' ;         //Clear error at the last in case no error found.
   Clear upMessageId ;
   Clear Command;

   Command = 'CHKOBJ (' + %trim(upXref) + ') OBJTYPE(*LIB)';
   RunCommand(Command:Uwerror);
   if Uwerror <> *Blank ;
      upMessageId = 'MSG0141';
      return ;
   endif;

   Exec Sql
     select XmdBuilt into :uwBuilt
     from IaInpLib
     where Xref_Name = :upXref
     limit 1;

   if SqlState <> SqlAllOk ;
      upMessageId = 'MSG0141';
      return ;
   endif;

   //If Repository is Locked ('L') or Metadta build Scheduled ('S') or
   //Metadata build process is in Progress('P')
   //then return 'E' and send appropriate message.
   select ;
     when uwBuilt = 'L' ;
        upMessageId = 'MSG0052';
     when uwBuilt = 'S' ;
        upMessageId = 'MSG0144';
     when uwBuilt = 'P' ;
        upMessageId = 'MSG0145' ;
     other ;
        upStatus = *Blanks ;
   endsl;
   return ;
end-proc isRepositoryInUse ;

//------------------------------------------------------------------------------------- //
//isRepositoryNameValid -Return status as 'E' if name is not valid else return blank.   //
//------------------------------------------------------------------------------------- //
dcl-proc isRepositoryNameValid export ;

   dcl-pi isRepositoryNameValid ;
      upXref      varchar(10) const options(*trim) ;
      upStatus    char(1)  ;
      upMessageId char(7) ;
   end-pi;

   dcl-c AllowedRepoName    'ABCDEFGHIJKLMNOPQRSTUVWXYZ+
                             abcdefghijklmnopqrstuvwxyz+
                             0123456789@#$_';

   clear upStatus ;
   clear upMessageId ;

   if %check(AllowedRepoName:upXref) > 0;
      upStatus    = 'E' ;
      upMessageId = 'MSG0140';
   endif ;
   return ;
end-proc isRepositoryNameValid ;

//------------------------------------------------------------------------------------- //
//isAppLibraryExists -Return status as 'E' and send appropriate message                 //
//                    else return status as blank.                                      //
//------------------------------------------------------------------------------------- //
dcl-proc isAppLibraryExists export ;

   dcl-pi isAppLibraryExists;
      upAppLibrary  varchar(10) const options(*trim) ;
      upStatus      char(1) ;
      upMessageId   char(7) ;
   end-pi;

   dcl-s uwCount     packed(12:0) inz;

   clear upStatus ;
   clear upMessageId ;

   Exec Sql
     select count(*) into :uwCount
     from IaInpLib
     where Xref_Name = :upAppLibrary;

   if uwCount >= 1 ;
      upStatus  = 'E' ;
      upMessageId = 'MSG0111' ;
      return ;
   endif ;

   clear command;
   command = 'CHKOBJ OBJ(QSYS/' + upAppLibrary + ') OBJTYPE(*LIB)' ;
   runcommand(Command:Uwerror);

   if uwError <> *Blank ;
      upStatus    = 'E' ;
      upMessageId = 'MSG0072' ;
   endif ;
   return ;
End-Proc isAppLibraryExists ;

//------------------------------------------------------------------------------------- //
//checkLibraryListDiffForRefresh- Return status 'E' if found difference else blanks.    //
//------------------------------------------------------------------------------------- //
dcl-proc checkLibraryListDiffForRefresh export ;

   dcl-pi checkLibraryListDiffForRefresh ;
      upXref      varchar(10) const options(*trim) ;
      upStatus    char(1) ;
      upMessageId char(7) ;
   end-pi;

   dcl-s wkSqlStmt   char(500)   inz ;
   dcl-s wkLibNam    char(10)    inz ;
   dcl-s wkRepoNam   char(10)    inz ;
   dcl-s wkLibSeq    packed(4:0) inz ;

   Clear upStatus ;
   Clear upMessageId ;

   wkSqlStmt =
   ' (Select XRefNam , XLibNam, XLibSeq from IaInpLib  '                 +
   '     where XrefNam = "' + upXref + '"'                               +
   '  Except'                                                            +
   '  Select MRefNam , MLibNam, MLibSeq from ' + upXref + '/IaRefLibP '  +
   '     where MRefNam = "' + upXref + '")'                              +
   '  Union'                                                             +
   ' (Select MRefNam , MLibNam, MLibSeq from ' + upXref + '/IaRefLibP '  +
   '     where MRefNam = "' + upXref + '"'                               +
   '  Except'                                                            +
   '  Select XRefNam , XLibNam, XLibSeq from IaInpLib '                  +
   '     where XrefNam = "' + upXref + '")'   ;

   wkSqlStmt = %xlate('"' : '''' : wkSqlStmt);

   Exec Sql
      Prepare sqlStmt from :wkSqlStmt;

   Exec Sql
      Declare LibLstDiff cursor for sqlStmt;

   Exec Sql
      open LibLstDiff ;
   //Cursor already opened.
   if sqlCode = -502 ;
      exec sql close LibLstDiff ;
      exec sql open  LibLstDiff ;
   endif;

   Exec Sql
      Fetch LibLstDiff
          into :wkRepoNam,
               :wkLibNam,
               :wkLibSeq;

   Exec Sql
      Close LibLstDiff ;

   //Cursor Blanks meaning no difference found in library list
   if wkLibNam <> *Blanks ;
      upStatus  = 'E' ;
      upMessageId = 'MSG0147' ;
   endif ;
   return ;

End-Proc checkLibraryListDiffForRefresh ;

//------------------------------------------------------------------------------------- //
// lockRepository -Return 'E' if lock is unsuccessfull                                  //
//------------------------------------------------------------------------------------- //
dcl-proc lockRepository export ;

   dcl-pi lockRepository ;
      upXref      varchar(10) const options(*trim) ;
      upUiUser    varchar(10) const options(*trim) ;
      upStatus    char(1) ;
      upMessageId char(7) ;
   end-pi ;

   dcl-c uwPgmName 'IAMNTREPOR' ;
   dcl-s uwExist   char(1) inz ;

   clear upStatus ;
   clear upMessageId ;

   uwExist = 'N';

   Exec Sql
     select 'Y' into :uwExist
     from IaInpLib
     where Xref_Name = :upXref
      and (XmdBuilt = ' ' or XmdBuilt = 'C')
     limit 1;

   if uwExist ='Y' ;
      Exec Sql
         update IaInpLib
         set XmdBuilt = 'L',
             ChgPgm = :uwPgmName,
             ChgUser = :upUiUser
         where Xref_Name = :upXref;
   endif ;
   return ;
end-proc lockRepository ;

//------------------------------------------------------------------------------------- //
// unlockRepository- Return 'E' if successfully updated else return 'N'                 //
//------------------------------------------------------------------------------------- //
dcl-proc unlockRepository export ;

   dcl-pi unlockRepository ;
      upXref      varchar(10) const options(*trim) ;
      upUiUser    varchar(10) const options(*trim) ;
      upStatus    char(1) ;
      upMessageId char(7) ;
   end-pi ;

   dcl-c uwPgmName 'IAMNTREPOR' ;
   dcl-s uwExist   char(1) inz  ;

   clear upStatus ;
   clear upMessageId ;

   uwExist = 'N';

   Exec Sql
     select 'Y' into :uwExist
     from IaInpLib
     where Xref_Name = :upXref
       and XmdBuilt = 'L'
     limit 1;

   if uwExist ='Y' ;
      Exec Sql
        update IaInpLib
        set XmdBuilt = ' ',
            ChgPgm = :uwPgmName,
            ChgUser = :upUiUser
        where Xref_Name = :upXref;
   endif;

end-proc unlockRepository ;

//------------------------------------------------------------------------------------- //
//rtvJobLogMessage. send message to Program Queue: Procedure to retrieve                //
//latest log message from JOB.                                                          //
//------------------------------------------------------------------------------------- //
dcl-proc rtvJobLogMessage Export;
   dcl-pi rtvJobLogMessage varchar(80) ;
      upMsgId      char(7)  const ;
      upMsgType    varchar(15) const options(*trim);
      upJobUser    varchar(10) const options(*trim);
      upJobNumber  zoned(6:0)  const ;
      upJobName    varchar(10) const options(*trim) ;
   end-pi;

   //local variable declaration
   dcl-s uwSqlString varchar(1000) ;
   dcl-s uwJobMessage char(80) ;

   //Prepare sql string to retrieve last completion message from joblog
   UwSqlString = 'select cast(message_text as varchar(80)) log_message +
              from table(qsys2.joblog_info({q}{jobnumber}/{jobuser}/{jobname}{q})) +
              where message_type = {q}{messagetype}{q} +
              and message_id = {q}{w_messageId}{q} +
              order by ordinal_position desc +
              fetch first rows only' ;

   UwSqlString = %scanrpl('{q}' :QUOTE :uwSqlString);
   UwSqlString = %scanrpl('{jobnumber}' :%editc(upJobNumber :'X') :uwSqlString);
   UwSqlString = %scanrpl('{jobuser}' :upJobUser :uwSqlString);
   UwSqlString = %scanrpl('{jobname}' :upJobName :uwSqlString);
   UwSqlString = %scanrpl('{messagetype}' :upMsgType :uwSqlString);
   UwSqlString = %scanrpl('{w_messageId}' :upMsgId :uwSqlString);

   Exec Sql
      declare JobLogInfoCsr scroll cursor for joblog ;

   Exec Sql
      prepare joblog from :uwSqlString ;

   Exec Sql
      open JobLogInfoCsr  ;
   //Cursor already opened.
   if sqlCode = -502 ;
      exec sql close JobLogInfoCsr ;
      exec sql open  JobLogInfoCsr ;
   endif;

   Exec Sql
      fetch next from JobLogInfoCsr  into :uwJobMessage ;

   Exec Sql
       close JobLogInfoCsr  ;

   return uwJobMessage ;
End-Proc rtvJobLogMessage ;
//------------------------------------------------------------------------------------- //
//deallocateRepoObjects - Deallocate the objects if any on Repo                         //
//------------------------------------------------------------------------------------- //
dcl-proc deallocateRepoObjects export ;

   dcl-pi deallocateRepoObjects ;
      upXref         varchar(10) const options(*trim) ;
      upStatus       char(1) ;
      upMessageId    char(7) ;
   end-pi;

   dcl-s uwobjName   varchar(10)  inz ;
   dcl-s uwCount     packed(12:0) inz ;
   dcl-s uwCountRS   packed(12:0) inz ;

   clear upStatus ;
   clear upMessageId ;

   Exec Sql
     Select count(*) into :uwCount
     from object_lock_info
     where oSchema = :upXref;

   Exec Sql
     declare DeallocateObj cursor for
       select distinct Sys_Oname
       from object_lock_info
       where oSchema = :upXref;

   Exec Sql
     open DeallocateObj ;
   //Cursor already opened?
   if sqlCode = -502 ;
      exec sql close DeallocateObj ;
      exec sql open  DeallocateObj ;
   endif;

   Exec Sql
   fetch next from DeallocateObj
       into :uwObjName;

   uwCountRs = 0 ;

   //Deallocate object one by one.
   dow sqlCode = *zero and uwCountRs < uwCount ;
      Command = 'DLCOBJ OBJ(('+ %trim(upXref) + '/' +
                  %trim(uwObjName) +
                  ' *FILE *SHRRD))' ;
      RunCommand(Command:Uwerror);

      uwCountRs = uwCountRs + 1 ;
      Exec Sql
         fetch next from DeallocateObj
         into :uwObjName;
   enddo ;

   Exec Sql
     close DeallocateObj ;

   clear uwCount ;

   Exec Sql
      select count(*) into :uwcount
       from object_lock_info
       where oSchema = :upXref
         and lock_type = 'MEMBER';

   if uwCount <> *Zero;
      upStatus = 'E' ;
      upMessageId = 'MSG0052';
   endif ;
   return ;

End-Proc deallocateRepoObjects ;

//------------------------------------------------------------------------------------- //
//isRepositoryScheduled - Return 'Y' if scheduled else return 'N'                       //
//------------------------------------------------------------------------------------- //
dcl-proc isRepositoryScheduled export  ;

   dcl-pi isRepositoryScheduled  char(1);
      upXref  varchar(10) const options(*trim) ;
   end-pi;

   dcl-s uwSchedule char(1) inz('N') ;

   Exec Sql
     select 'Y' into :uwSchedule
      from iainplib
      where xref_name = :upXref
        and XmdBuilt = 'S'
      limit 1;

   return uwSchedule ;
end-proc isRepositoryScheduled ;

//-------------------------------------------------------------------------------------- //
//isRepositoryProcessing-Return 'Y' if it is in Processing else return 'N'               //
//-------------------------------------------------------------------------------------- //
dcl-proc isRepositoryProcessing  export ;

   dcl-pi isRepositoryProcessing  char(1);
      upXref  varchar(10) const options(*trim) ;
   end-pi;

   dcl-s uwProcess  char(1) inz('N') ;

   Exec Sql
     select 'Y' into :uwProcess
       from iainplib
       where xref_name = :upXref
         and xmdbuilt = 'P'
       limit 1;

   return uwProcess ;
end-proc isRepositoryProcessing ;

//------------------------------------------------------------------------------------- //
//setRepositoryStatus- Return 'Y' if it is successfully update the status else return N //
//------------------------------------------------------------------------------------- //
dcl-proc setRepositoryStatus export ;

   dcl-pi setRepositoryStatus  char(1);
      upXref        varchar(10) const options(*trim) ;
      upXrefStatus  char(1)  const ;
   end-pi;

   dcl-c Success 'Y' ;
   dcl-c Fail    'N' ;

   Exec Sql
     update iainplib
       set XmdBuilt = :upXrefStatus
       where xrefnam = :upXref;

   if SqlCode = *zero ;
      return Success;
   else ;
      return Fail ;
   endif ;

end-proc setRepositoryStatus ;
