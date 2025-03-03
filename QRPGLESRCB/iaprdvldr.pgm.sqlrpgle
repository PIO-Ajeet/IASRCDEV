**free
      //%METADATA                                                      *
      // %TEXT Validation program for IA Product                       *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------- //
//Created By    : Programmers.io @ 2023                                                 //
//Created Date  : 2023/12/19                                                            //
//Developer     : Abhijith Ravindran                                                    //
//Description   : Validation program for IA Product metadata build.                     //
//Procedure Log : The input parameters are as below:                                    //
//                inRepoName      - Repository name                                     //
//                inProcessType   - 'INIT' or 'REFRESH' or 'DELETE'                     //
//                inMessageId     - It is an out parameter that gives error message ID  //
//                inActionFlag    - 'S' (scheduled job) or 'R'                          //
//                                                                                      //
//------------------------------------------------------------------------------------- //
//Procedure Name           | Procedure Description                                      //
//-------------------------|----------------------------------------------------------- //
//No Procedure             |                                                            //
//------------------------------------------------------------------------------------- //
//                                                                                      //
//Modification Log:                                                                     //
//------------------------------------------------------------------------------------- //
//Date    | Mod_ID | Developer  | Case and Description                                  //
//--------|--------|------------|------------------------------------------------------ //
//010324  | 0001   | Akhil K.   | Add new validation to check the job scheduled entry.  //
//        |        |            | Task #520.                                            //
//170124  | 0002   | Arshaa     | Task# 533:                                            //
//        |        |            | Add more validations to be done when attempting to    //
//        |        |            | delete a repo.                                        //
//        |        |            | 1. Check if Repo is being used/Meta Data Build or     //
//        |        |            |    Refresh is in progress.                            //
//        |        |            | 2. Check if Repo Meta Data Build/Refresh is scheduled //
//        |        |            |    in the scheduler.                                  //
//030724  | 0003   | Sribalaji  | Remove the hardcoded #IADTA lib from all sources      //
//        |        |            | [Task# 754]                                           //
//050724  | 0004   | Akhil K.   | Renamed AIERRBND, AICERRLOG and AIDERRLOG with IA*    //
//090524  | 0005   | Vishwas    | Task# 652:                                            //
//        |        |            | Add validation to consider new Schedular changes for  //
//        |        |            | repository operation.                                 //
//        |        |            | 1. While submitting the job check in schedular if     //
//        |        |            |    INIT/REFRESH job is scheduled for the same date,   //
//        |        |            |    then do not allow a new job submission             //
//------------------------------------------------------------------------------------- //
ctl-opt copyright('Programmers.io © 2023 | Santosh | Changed Jun 2023');
ctl-opt option(*nodebugio:*srcstmt:*nounref);
ctl-opt BndDir('IABNDDIR' : 'IAERRBND');                                                 //0004

//------------------------------------------------------------------------------------- //
//Main Entry Parameter
//------------------------------------------------------------------------------------- //
dcl-pr IAPRDVLDR extpgm('IAPRDVLDR');
   inRepoName    char(10);
   inProcessType char(10);
   inMessageId   char(10);
   inActionFlag  char(1) options(*omit);                                                 //0001
end-pr;

dcl-pi IAPRDVLDR;
   inRepoName    char(10);
   inProcessType char(10);
   inMessageId   char(10);
   inActionFlag  char(1) options(*omit);                                                 //0001
end-pi;

//------------------------------------------------------------------------------------- //
//Standalone Variable Definitions
//------------------------------------------------------------------------------------- //
dcl-s wkXRef        char(10)   inz;
dcl-s wkCommand     char(1000) inz;
dcl-s uwError       char(1)    inz;
dcl-s wkBuilt       char(1)    inz;
dcl-s wkSqlStmt     char(500)  inz;
dcl-s wkLibNam      char(10)   inz;
dcl-s wkRepoNam     char(10)   inz;
dcl-s wk_MessageId  char(10)   inz;
dcl-s Message_Type  char(15)   inz;
dcl-s wk_Message    char(200)  inz;
dcl-s AlreadyExists char(1)    inz;                                                      //0001
dcl-s ActionFlag    char(1)    inz;                                                      //0001
dcl-s wk_SchTime    char(8)    inz;                                                      //0005
dcl-s wk_SchDate    char(8)    inz;                                                      //0005
dcl-s wk_TimDiff    Zoned(5)   inz;                                                      //0005

dcl-s wkLibSeq      packed(4:0) inz;

dcl-s wkLibDiff     ind        inz(*off);

//------------------------------------------------------------------------------------- //
//Data Structure Definitions
//------------------------------------------------------------------------------------- //


//------------------------------------------------------------------------------------- //
//Constant Definitions
//------------------------------------------------------------------------------------- //
dcl-c wk_lo 'abcdefghijklmnopqrstuvwxyz';
dcl-c wk_up 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
dcl-c quote '''';

//------------------------------------------------------------------------------------- //
//Copy Book Definitions
//------------------------------------------------------------------------------------- //
/copy 'QCPYSRC/iaderrlog.rpgleinc'
/copy 'QCPYSRC/iamsgsflf.rpgleinc'
/copy 'QMODSRC/iasrv01pr.rpgleinc'

//------------------------------------------------------------------------------------- //
//Main Logic
//------------------------------------------------------------------------------------- //
//Process according to the action flag parameter

   eval-corr uDpsds = wkuDpsds;
   wkXRef = inRepoName;

   //If the call is from frontend it will have 4 parameters, if not only 3 and by       //0001
   //default, it will be normal submit job ('R').                                       //0001
   if %parms < 4;                                                                        //0001
      ActionFlag = 'R';                                                                  //0001
   else;                                                                                 //0001
      ActionFlag = inActionFlag;                                                         //0001
   endif;                                                                                //0001
   exSr validateRepoDtls;

   *inlr = *on;
   return;

// -------------------------------------------------------------------------------------//
//validateRepoDtls                                                                     //
// -------------------------------------------------------------------------------------//
begSr validateRepoDtls;

   //Check if the repository exists
   clear wkCommand;
   wkCommand = 'CHKOBJ (' + %trim(wkXref) + ') OBJTYPE(*LIB)';
   runCommand(wkCommand:uwError);
   if uwError <> ' ';
      inMessageId = 'MSG0141';
      messageData = wkXref;
      exsr SendMessageToProgramQ;
      leaveSr;
   endif;

   //Check if the repository is locked
   exec sql
      select XMDBuilt into :wkBuilt
     // from #iadta/IaInpLib                                                             //0003
       from IaInpLib                                                                     //0003
      where Xref_Name = :wkXref limit 1;

   if wkBuilt = 'L';
      If inProcessType = 'DELETE';                                                       //0002
         inMessageId = 'MSG0157';                                                        //0002
      Else;                                                                              //0002
         inMessageId = 'MSG0052';
      EndIf;                                                                             //0002
      MessageData = wkXref;
      exsr SendMessageToProgramQ;
      leaveSr;
   elseif wkBuilt = 'S';
      If inProcessType = 'DELETE';                                                       //0002
         inMessageId = 'MSG0158';                                                        //0002
      Else;                                                                              //0002
         inMessageId = 'MSG0144';
      EndIf;                                                                             //0002
      messageData = wkXref;
      exsr SendMessageToProgramQ;
      leaveSr;
   elseif wkBuilt = 'P';
      If inProcessType = 'DELETE';                                                       //0002
         inMessageId = 'MSG0159';                                                        //0002
      Else;                                                                              //0002
         inMessageId = 'MSG0145';
      EndIf;                                                                             //0002
      messageData = wkXref;
      exsr SendMessageToProgramQ;
      leaveSr;
   endif;

   //Check schedule
   if actionFlag = 'S' Or                                                                //0001
      inProcessType = 'DELETE';                                                          //0002
      exec sql                                                                           //0001
         select 'Y' into :AlreadyExists                                                  //0001
         from   qsys2.Scheduled_Job_Info                                                 //0001
         where  scdJobName = :wkXref limit 1;                                            //0001

      If AlreadyExists = 'Y';                                                            //0001
         If inProcessType = 'DELETE';                                                    //0002
            inMessageId = 'MSG0160';                                                     //0001
         Else;                                                                           //0002
            inMessageId = 'MSG0154';                                                     //0001
         EndIf;                                                                          //0002
         MessageData = wkXref;                                                           //0001
         exsr SendMessageToProgramQ;                                                     //0001
         leaveSr;                                                                        //0001
      Endif;                                                                             //0001
   endif;                                                                                //0001

   //Check Run
   if actionFlag = 'R'  ;                                                                //0005
                                                                                         //0005
      Clear wk_SchTime  ;                                                                //0005
                                                                                         //0005
      Exec Sql                                                                           //0005
           Select IAPRTIME, IAPRDATE                                                     //0005
             Into :wk_SchTime ,:Wk_SchDate                                               //0005
             From IAJOBSCDEP                                                             //0005
            Where IAREPONM   =:inRepoName                                                //0005
              And IAPRDATE   = CHAR(Current_Date)                                        //0005
            limit 1;                                                                     //0005
                                                                                         //0005
      IF wk_SchTime > %Char(%Time()) ;                                                   //0005
         inMessageId = 'MSG0223';                                                        //0005
         MessageData = wk_SchDate +  wk_SchTime;                                         //0005
         exsr SendMessageToProgramQ;                                                     //0005
         leaveSr;                                                                        //0005
      Endif;                                                                             //0005
                                                                                         //0005
   endif;                                                                                //0005

   if inProcessType = 'REFRESH';

      if wkBuilt = *blanks;
         inMessageId = 'MSG0146';
         MessageData = wkXref;
         exsr SendMessageToProgramQ;
         leaveSr;
      endIf;

      exSr checkLibraryListDiff;
      if wkLibDiff;
         inMessageId = 'MSG0147';
         MessageData = wkXref;
         exsr SendMessageToProgramQ;
         leaveSr;
      endIf;

   endIf;

endSr;

// -------------------------------------------------------------------------------------//
//CheckLibraryList;                                                                    //
// -------------------------------------------------------------------------------------//
begSr checkLibraryListDiff;

   reset wkLibDiff;
   wkLibNam  = ' ';
   wkRepoNam  = ' ';
   wkLibSeq  = 0;

   wkSqlStmt =
      ' (Select XRefNam , XLibNam, XLibSeq from IaInpLib  '                 +
      '     where XrefNam = "' + wkXref + '"'                              +
      '  Except'                                                            +
      '  Select MRefNam , MLibNam, MLibSeq from ' + wkXref + '/IaRefLibP ' +
      '     where MRefNam = "' + wkXref + '")'                             +
      '  Union'                                                             +
      ' (Select MRefNam , MLibNam, MLibSeq from ' + wkXref + '/IaRefLibP ' +
      '     where MRefNam = "' + wkXref + '"'                              +
      '  Except'                                                            +
      '  Select XRefNam , XLibNam, XLibSeq from IaInpLib '                  +
      '     where XrefNam = "' + wkXref + '")'   ;

   wkSqlStmt = %xlate('"' : '''' : wkSqlStmt);

   exec sql
      prepare sqlStmt from :wkSqlStmt;

   exec sql
      declare c1 Cursor For sqlStmt;

   exec sql
      open c1;

   exec sql
      fetch c1
      into  :wkRepoNam, :wkLibNam, :wkLibSeq;

   //Cursor Blanks meaning no difference found in library list
   if wkLibNam <> ' ' ;
      wkLibDiff = *on;
   endif;

   exec sql close c1;

endSr;

// ------------------------------------------------------------------------------------ //
//SendMessageToProgramQ :- Send message to programQ                                    //
// ------------------------------------------------------------------------------------ //
begSr sendMessageToProgramQ;

   MessageLen = %len(%trim(messageData));
   callp  SendMessage(inMessageId:
                      MessageFile:
                      MessageData:
                      MessageLen:
                      MessageType:
                      CallStack:
                      CallStackC:
                      MessageKey:
                      MessageErr);
   MessageData = '';

endSr;

//*pssr which handles any run time exception to prevent message wait/halt
/copy 'QCPYSRC/iacerrlog.rpgleinc'
