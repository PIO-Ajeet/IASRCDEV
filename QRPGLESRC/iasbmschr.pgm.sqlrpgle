**free
      //%METADATA                                                      *
      // %TEXT Remove deleted source/object data from iA files         *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------- //
//Created By    : Programmers.io @ 2023                                                 //
//Created Date  : 2023/12/05                                                            //
//Developer     : Santosh Kumar                                                         //
//Description   : Refresh program for front end application                             //
//Procedure Log : The input and output parameters are as below:                         //
//                in_RepoName       : Repository name                                   //
//                in_ProcessType    : 'INIT' or 'REFRESH'                               //
//                in_ActionFlag     : 'S' (scheduled job) or 'R' (run)                  //
//                in_ActFlagDb      : 'ADD' , 'UPD' or 'DEL' Scheduled entries          //
//                in_JobQueue       : Job queue                                         //
//                in_ProcessDate    : The date on which job runs  MM/DD/YY              //
//                in_ProcessTime    : The time on which job runs  HH:MM:SS (*HMS)       //
//                in_Frequency      : Frequency of the scheduled job (Eg: weekly, daily)//
//                in_ScheduleDay    : The days job is scheduled                         //
//                in_RelativeDay    : Relative day                                      //
//                in_UserId         : The user ID                                       //
//                in_EnvLib         : The Library List for the Job                      //
//                out_Status        : 'E' (error) or 'S' (Successful)                   //
//                out_Message       : The error or successful message                   //
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
//17/12/23| 0001   | Abhijith R | Remove vaidations and change submit parameters        //
//09/01/24| 0002   | Akhil K    | New parameter added to IAPRDVLDR and to get specific  //
//        |        |            | error message from joblog. [Task #521]                //
//22/02/24| 0003   | Manasa S   | Record scheduler entry details for both INIT or Ref   //
//        |        |            | process in new file.[Task #592]                       //
//04/07/24| 0004   | Vamsi      | Rename Bnddir AIERRBND, copybooks AICERRLOG/AIDERRLOG //
//        |        |            | and procedures AISQLDIAGNOSTIC and AIPSSRERRORLOG     //
//        |        |            | with IA*  [Task#261]                                  //
//25/07/24| 0005   | Sasikumar R| To add the input parameter in_EnvLib  to set the      //
//        |        |            | library list.                                         //
//29/07/24| 0006   |Kaushal kum.| Remove the hardcoded library [Task#824]               //
//14/02/24| 0007   | Akhil K    | 1. Get the known error message descriptions from the  //
//        |        |            |    MSGF (IAMSGF).                                     //
//        |        |            | 2. Add delay time only when the difference between    //
//        |        |            |    job-time and current time is less than or equal to //
//        |        |            |    buffer time.                                       //
//        |        |            | 3. The buffer time and delay time values are in       //
//        |        |            |    IABCKCNFG with corresponding key-names.            //
//        |        |            | [Task #574]                                           //
//------------------------------------------------------------------------------------- //
ctl-opt copyright('Programmers.io © 2023 | Santosh | Changed Jun 2023');
ctl-opt option(*nodebugio:*srcstmt:*nounref);
ctl-opt dftactgrp(*no);

//------------------------------------------------------------------------------------- //
//Main Entry Parameter
//------------------------------------------------------------------------------------- //
dcl-pr IASBMSCHR extpgm('IASBMSCHR');
   in_RepoName    char(10);
   in_ProcessType char(10);
   in_ActionFlag  char(1);
   in_ActFlagDb   char(3);                                                               //0003
   in_JobQueue    char(10);
   in_ProcessDate char(10);
   in_ProcessTime char(8);
   in_Frequency   char(8);
   in_ScheduleDay char(35);
   in_RelativeDay char(25);
   in_UserId      char(10);
   in_EnvLib      char(10);                                                              //0005
   out_Status     char(1);
   out_Message    char(200);
end-pr;

dcl-pi IASBMSCHR;
   in_RepoName    char(10);
   in_ProcessType char(10);
   in_ActionFlag  char(1);
   in_ActFlagDb   char(3);                                                               //0003
   in_JobQueue    char(10);
   in_ProcessDate char(10);
   in_ProcessTime char(8);
   in_Frequency   char(8);
   in_ScheduleDay char(35);
   in_RelativeDay char(25);
   in_UserId      char(10);
   in_EnvLib      char(10);
   out_Status     char(1);
   out_Message    char(200);
end-pi;

//------------------------------------------------------------------------------------- //
//Prototype Declaration
//------------------------------------------------------------------------------------- //
dcl-pr validateRepoDetails Extpgm('IAPRDVLDR');
  *n char(10);
  *n char(10);
  *n char(7);
  *n char(1);                                                                            //0002
end-pr;

dcl-pr runcommand;
   *n char(1000) options(*varsize) const;
   *n char(1);
end-pr;

dcl-pr qcmdexc extpgm('QCMDEXC');
   *n char(500)     options(*varsize) const;
   *n packed(15:5)  const;
   *n char(3)       options(*nopass) const;
end-pr;

//------------------------------------------------------------------------------------- //
//Standalone Variable Definitions
//------------------------------------------------------------------------------------- //
dcl-s s1_xRef             char(10)    inz;
dcl-s wk_CurrentDate      char(10)    inz;
dcl-s wk_LibNam           char(10)    inz;
dcl-s Current_User        char(10)    inz;
dcl-s wk_ErrorFlag        char(1)     inz;
dcl-s wk_BuiltFg          char(1)     inz;
dcl-s wk_Command          char(1000)  inz;
dcl-s wk_CallStatement    char(200)   inz;
dcl-s ProgramQ            char(10)    inz('IASBMSCHR');
dcl-s wk_JobNumber        char(30)    inz;
dcl-s wk_BldMode          char(7)     inz;
dcl-s wk_Jobq             char(10)    inz;
dcl-s uwError             char(1)     inz;
dcl-s wk_RepositoryStatus char(1)     inz;
dcl-s wk_ScheduleDayStr   char(35)    inz;
dcl-s wk_ScheduleDateStr  char(10)    inz;
dcl-s wk_ScheduleTimeStr  char(10)    inz;
dcl-s wk_RelativeDayStr   char(25)    inz;
dcl-s wk_Message          char(200)   inz;
dcl-s wk_MessageId        char(10)    inz;
dcl-s Message_Type        char(15)    inz;
dcl-s repData             char(500)   inz;                                               //0007
dcl-s w_keyval            char(30)    inz;                                               //0007
dcl-s KEYNAME_1           char(30)    inz('SUBMIT')     ;                                //0007
dcl-s KEYNAME_B           char(30)    inz('BUFFER_TIME');                                //0007
dcl-s KEYNAME_D           char(30)    inz('DELAY_TIME') ;                                //0007

dcl-s wk_JobDate          zoned(6:0)  inz;
dcl-s wk_JobTime          zoned(6:0)  inz;
dcl-s cur_date            zoned(6:0)  inz;                                               //0007
dcl-s cur_time            zoned(6:0)  inz;                                               //0007
dcl-s BUFFER_TIME         zoned(6:0)  inz;                                               //0007
dcl-s DELAY_TIME          zoned(6:0)  inz;                                               //0007
dcl-s i                   zoned(2:0)  inz;

dcl-s wk_HoldTime         time        inz;

//------------------------------------------------------------------------------------- //
//Data Structure Definitions
//------------------------------------------------------------------------------------- //
dcl-ds wk_SchdDay;
   wk_ScheduleDy char(35);
   wk_ScheduleDay char(5) dim(7) pos(1);
end-ds;

dcl-ds wk_RelDay;
   wk_RelativeDy char(25);
   wk_RelativeDay char(5) dim(5) pos(1);
end-ds;

dcl-ds deleteReposDs qualified inz;
   wk_Xref char(10);
   wk_Built char(1);
   wk_User char(10);
   wk_Desc char(30);
end-ds;

dcl-ds IAJOBDAREA dtaara('*LIBL/IAJOBDAREA') len(50);
  jobLvl char(5) pos(1);
  jobSvrty char(5) pos(11);
  jobText char(7) pos(21);
end-ds;

dcl-ds IaMetaInfo dtaara len(62);
   up_Mode char(7) pos(1);
end-ds;

dcl-ds msgF;                                                                             //0007
   msgFile    char(10) Inz('IAMSGF');                                                    //0007
   msgFileLib char(10) Inz('#IADTA');                                                    //0007
end-ds;                                                                                  //0007

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

//------------------------------------------------------------------------------------- //
//Main Logic
//------------------------------------------------------------------------------------- //
   //Process according to the action flag parameter
   eval-corr uDpsds = wkuDpsds;
   s1_xRef = in_RepoName;
   wk_ScheduleDy = in_ScheduleDay;
   wk_RelativeDy = in_RelativeDay;

   //To setup the environment.
   addLibraries();

   clear out_Status;
   clear out_Message;
   //To validate the existence of job queue and the status of the Repo.
   validateParameters();

   if out_Status = *blanks;
      select;
         when in_ActionFlag = 'R';
            submitMetadataBuildJob();

         when in_ActionFlag = 'S';
            scheduleMetadataBuildJob();
      endSl;
   endIf;

   *inlr = *on;
   return;

//------------------------------------------------------------------------------------- //
//validateParams - Validate Parameters
//------------------------------------------------------------------------------------- //
dcl-proc validateParameters;

   clear wk_Command;
   wk_Command = 'CHKOBJ OBJ(' + %trim(in_JobQueue) + ') OBJTYPE(*JOBQ)';

   runCommand(wk_command : wk_ErrorFlag);
   if wk_ErrorFlag <> *blanks;
      wk_MessageId= 'MSG0164';                                                           //0002
      //Retrieve the message description from MSGF                                      //0007
      exsr RetrieveMessageFrmMsgF;                                                       //0007
      out_Status  = 'E';
      out_Message = MessageDesc.message2;                                                //0007
   else;
      validateRepoDetails(in_RepoName:in_ProcessType:wkMessageId:in_ActionFlag);         //0002

      if wkMessageId <> *blanks;
         out_Status  = 'E';
         wk_MessageId = wkMessageId;
         //Retrieve the message description from MSGF                                   //0007
         exsr RetrieveMessageFrmMsgF;                                                    //0007
         out_Message = MessageDesc.message2;                                             //0007
      endIf;
   endif;

   //---------------------------------------------------------------------------------- //
   //RetrieveMessageFrmMsgF:- Retrieve message from message-file                        //
   //---------------------------------------------------------------------------------- //
   begsr RetrieveMessageFrmMsgF;                                                         //0007
     repData = s1_xRef;                                                                  //0007
     RtvMessage(MessageDesc:%len(MessageDesc):'RTVM0100':                                //0007
                wk_MessageId:msgF:repData:%len(%trim(repData)):                          //0007
                '*YES':'*NO':MessageErr);                                                //0007
     clear repData;                                                                      //0007
   endsr;                                                                                //0007

end-proc;

//------------------------------------------------------------------------------------- //
//submitMetadataBuildJob - Submit Metadata Build Job
//------------------------------------------------------------------------------------- //
dcl-proc submitMetadataBuildJob;

   wk_Jobq = in_JobQueue;
   wk_Jobdate = %dec(%date(in_ProcessDate : *MDY) : *MDY);
   wk_Jobtime = %dec(%time(in_ProcessTime : *HMS) : *HMS);

   cur_date   = %dec(%date():*MDY);                                                      //0007
   cur_time   = %dec(%time():*HMS);                                                      //0007
   //If the submit date is current date                                                 //0007
   if wk_Jobdate = cur_date;                                                             //0007
      //Get buffer time and delay time from IABCKCNFG                                   //0007
      exsr Get_Time_Configurations;                                                      //0007
      //If the time difference is less than or equal to buffer time, add delay time     //0007
      if %diff(%time(wk_Jobtime:*HMS):%time(cur_time:*HMS):*minutes)                     //0007
         <= BUFFER_TIME;                                                                 //0007
          wk_HoldTime = %time(wk_JobTime) + %minutes(DELAY_TIME);                        //0007
      else;                                                                              //0007
          wk_HoldTime = %time(wk_JobTime);                                               //0007
      endif;                                                                             //0007
   endif;                                                                                //0007
   wk_Jobtime = %dec(%char(wk_HoldTime :*HMS0) : 6 : 0);

   //To build the call statement in the submit job command
   callMetadataBuildStmnt();

   clear wk_Command;
   wk_Command = 'SBMJOB CMD(' + %trim(wk_CallStatement) + ')';

   //Read Data Area for the Job configuration.
   in IAJOBDAREA ;
   wk_Command = %trim(wk_Command) +
               ' JOB(' + %Trim(s1_xRef) + ')' +
               ' JOBQ(' + %trim(wk_Jobq) + ') USER(IAUSER)' +
               ' LOG('+ JobLvl + ' ' + JobSvrty + ' ' + jobText + ')'+
               ' SCDDATE(' + %editc(wk_JobDate : 'X') + ')' +
               ' SCDTIME(' + %editc(wk_JobTime : 'X') + ')';

   runCommand(wk_command : wk_ErrorFlag);

   //If no error fetch the Successful message
   if wk_ErrorFlag = *blanks;
      updateRepositoryStatus(s1_xRef:'S');
      wk_MessageId = 'CPC1221';
      Message_Type = 'COMPLETION';
      wk_Message = rtvJobLogMessage();
      out_Status  = 'S';
      out_Message = %trim(wk_Message);
   else;
      //In case of error fetch the error message from the joblog.
      wk_MessageId = ' ';                                                                //0002
      Message_Type  = 'DIAGNOSTIC';
      wk_Message = rtvJobLogMessage();
      out_Status  = 'E';
      out_Message = %trim(wk_Message);
   endIf;

   //-----------------------------------------------------------------------------------//
   //To get buffer time and delay time from IABCKCNFG                                   //
   //-----------------------------------------------------------------------------------//
   begsr Get_Time_Configurations;                                                        //0007
                                                                                         //0007
     exec sql                                                                            //0007
       select IAKEYVAL1 into :w_keyval                                                   //0007
         from IABCKCNFG                                                                  //0007
        where IAKEYNAME1 = :KEYNAME_1                                                    //0007
          and IAKEYNAME2 = :KEYNAME_B;                                                   //0007
                                                                                         //0007
     if sqlCode < successCode;                                                           //0007
        Eval-corr uDpsds = wkuDpsds;                                                     //0007
        uDpsds.wkQuery_Name = 'Select1_IABCKCNFG';                                       //0007
     endif;                                                                              //0007
                                                                                         //0007
     if w_keyval <> *blanks and                                                          //0007
        %check('0123456789.':%trim(w_keyval)) = 0;                                       //0007
        BUFFER_TIME = %dec(%trim(w_keyval):6:0);                                         //0007
     endif;                                                                              //0007
                                                                                         //0007
     clear w_keyval;                                                                     //0007
     exec sql                                                                            //0007
       select IAKEYVAL1 into :w_keyval                                                   //0007
         from IABCKCNFG                                                                  //0007
        where IAKEYNAME1 = :KEYNAME_1                                                    //0007
          and IAKEYNAME2 = :KEYNAME_D;                                                   //0007
                                                                                         //0007
     if sqlCode < successCode;                                                           //0007
        Eval-corr uDpsds = wkuDpsds;                                                     //0007
        uDpsds.wkQuery_Name = 'Select2_IABCKCNFG';                                       //0007
     endif;                                                                              //0007
                                                                                         //0007
     if w_keyval <> *blanks and                                                          //0007
        %check('0123456789.':%trim(w_keyval)) = 0;                                       //0007
        DELAY_TIME = %dec(%trim(w_keyval):6:0);                                          //0007
     endif;                                                                              //0007

   endsr;                                                                                //0007

end-proc;

//------------------------------------------------------------------------------------- //
//scheduleMetadataBuildJob - Schedule Metadata Build Job
//------------------------------------------------------------------------------------- //
dcl-proc scheduleMetadataBuildJob;

   //local variable declaration                                                         //0003
   dcl-s sql_str       varchar(1000) inz;                                                //0003
   dcl-s wk_SeqNum     Packed(3:0) inz;                                                  //0003
   dcl-s wk_RemLen     Packed(2:0) inz;                                                  //0003
   dcl-s wk_SeqLen     Packed(2:0) inz;                                                  //0003
   dcl-s wk_SeqChar    Char(3) inz;                                                      //0003
   dcl-s wk_SchJobNm   Char(10)inz;                                                      //0003
                                                                                         //0003
   //Fetch Scheduled Job Name from the file.                                            //0003
   Exec Sql                                                                              //0003
      Select IaschJobNm into :wk_SchJobNm from IaJobScdEp                                //0003
         where IaProcTyp = :in_ProcessType  and                                          //0003
         IaRepoNm = :in_RepoName;                                                        //0003
                                                                                         //0003
   Select;                                                                               //0003
                                                                                         //0003
      //When entry exists and ADD action is sent, throw an error.                       //0003
      When in_ActFlagDb = 'ADD' and SqlCod = Successcode;                                //0003
            out_Status  = 'E';                                                           //0003
            out_Message = 'Job scheduler entry already exists';                          //0003
            Return;                                                                      //0003
                                                                                         //0003
      //When entry does not exists and DEL or UPD action is sent.                       //0003
      When in_ActFlagDb <> 'ADD' and SqlCod = NO_DATA_FOUND;                             //0003
            out_Status  = 'E';                                                           //0003
            out_Message = 'The Job schedule entry not found';                            //0003
            Return;                                                                      //0003
   endSl;                                                                                //0003
                                                                                         //0003
   //For ADD action - Generate unique job name.                                         //0003
   Select;                                                                               //0003
      When in_ActFlagDb = 'ADD';                                                         //0003
         wk_SchJobNm  = %trim(%subst(in_RepoName: 1 :7)) +                               //0003
                        %Subst(in_ProcessType : 1 : 3);                                  //0003
                                                                                         //0003
         //Generate SQL to fetch Last used sequence number in Job Name                  //0003
         sql_str = 'Select COALESCE(MAX( Ltrim(REGEXP_REPLACE' +                         //0003
                   '(RIGHT(trim(IASCHJOBNM),3),' +                                       //0003
                    Quote + '[A-z]' + Quote + ', ' + Quote +                             //0003
                    '0' + quote + '))), ' + Quote + ' ' + Quote +                        //0003
                   ') '+ 'from IaJobScdEp where ' +                                      //0003
                   'IaProcTyp = ' + Quote + %Trim(in_ProcessType) +                      //0003
                    Quote + ' and IaSchJobNm like '+ Quote + '%' +                       //0003
                    %Trim(%Subst(wk_SchJobNm : 1: 7)) + '%' + Quote;                     //0003
                                                                                         //0003
         exec sql prepare GetJobSeq_Stmt from :sql_str;                                  //0003
         exec sql declare GetJobSeqNum cursor for GetJobSeq_Stmt;                        //0003
         exec sql open GetJobSeqNum;                                                     //0003
         if sqlCode = CSR_OPN_COD;                                                       //0003
           exec sql close GetJobSeqNum;                                                  //0003
           exec sql open  GetJobSeqNum;                                                  //0003
         endif;                                                                          //0003
                                                                                         //0003
         exec sql fetch next from GetJobSeqNum into :wk_SeqChar;                         //0003
                                                                                         //0003
         //Calculate next sequence in job name.                                         //0003
         If wk_SeqChar <> '  ';                                                          //0003
            wk_RemLen    = 10 - %Len(%Trim(wk_SchJobNm));                                //0003
            wk_SeqNum    = %Dec(wk_SeqChar :3 :0) + 1;                                   //0003
            Clear wk_SeqChar;                                                            //0003
            wk_SeqChar   = %Editc( wk_SeqNum : 'Z');                                     //0003
            wk_SeqLen    = %Len(%Trim(wk_SeqChar));                                      //0003
                                                                                         //0003
            Select;                                                                      //0003
               //Generate job name RepoName + Process type (INI or REF)                 //0003
               when wk_RemLen >= wk_SeqLen;                                              //0003
                  wk_SchJobNm = %Trim(wk_SchJobNm) + %Trim(wk_SeqChar);                  //0003
               //Generate job name RepoName + Process type + seqnum   )                 //0003
               when wk_RemLen <  wk_SeqLen;                                              //0003
                wk_SchJobNm = %Subst(wk_SchJobNm : 1: 10 - wk_SeqLen) +                  //0003
                              %Trim(wk_SeqChar);                                         //0003
            Endsl;                                                                       //0003
         endif;                                                                          //0003
         exec sql close GetJobSeqNum;                                                    //0003
                                                                                         //0003
   endSl;                                                                                //0003
                                                                                         //0003
   //Build command for the Job scheduler entry
   clear wk_Command;
   Select;                                                                               //0003
      When in_ActFlagDb = 'DEL';                                                         //0003
          wk_Command = 'RMVJOBSCDE JOB(' + %trim(wk_SchJobNm) + ') '  ;                  //0003
                                                                                         //0003
      Other;                                                                             //0003
         wk_jobq = in_jobQueue;                                                          //0002
         //Prepare call statement to be used in SBMJOB or ADDJOBSCDE command
         callMetadataBuildStmnt();
                                                                                         //0003
         If in_ActFlagDb = 'ADD';                                                        //0003
                                                                                         //0003
            //wk_Command = 'ADDJOBSCDE JOB(' + %trim(s1_xRef) + ') '  +                  //0003
            wk_Command = 'ADDJOBSCDE JOB(' + %trim(wk_SchJobNm) + ') '  +                //0003
            'CMD(' + %trim(wk_CallStatement) + ')' + ' FRQ(' + %trim(in_Frequency) + ')';
                                                                                         //0003
         elseif in_ActFlagDb = 'UPD';                                                    //0003
                                                                                         //0003
            wk_Command = 'CHGJOBSCDE JOB(' + %trim(wk_SchJobNm) + ') '  +                //0003
            'CMD(' + %trim(wk_CallStatement) + ')' + ' FRQ(' + %trim(in_Frequency) + ')';//0003
         endif;                                                                          //0003

         //Save the entry if it is a one-time submission
         if (%trim(in_Frequency) = '*ONCE');
            wk_Command = %trim(wk_Command) + ' SAVE(*YES)';
         endIf;

         //Set the Scheduled date for the job if not one of the below listed values
         if (in_ProcessDate = '*CURRENT' or
            in_ProcessDate = '*NONE' or
            in_ProcessDate = '*MONTHSTR' or
            in_ProcessDate = '*MONTHEND' or
            in_ProcessDate = '*MONTHSTR');
            wk_ScheduleDateStr = %trim(in_ProcessDate);
         else;
            wk_JobDate = %dec(%date(in_ProcessDate : *MDY) : *MDY);
            wk_ScheduleDateStr = %editc(wk_JobDate : 'X');
         endIf;

         //if schedule date is entered
         if (wk_ScheduleDateStr <> *blanks);
            wk_Command = %trim(wk_Command) + ' SCDDATE(' + %trim(wk_ScheduleDateStr) + ')';
         endIf;

         //Set the Scheduled days for the job if not one of the below listed values
         if %trim(%Xlate(wk_lo : wk_up : wk_ScheduleDay(1))) = '*NONE' or
            %trim(%Xlate(wk_lo : wk_up : wk_ScheduleDay(1))) = '*ALL';
               wk_ScheduleDayStr = wk_ScheduleDay(1);
         else;
            i = 1;
            dow i <= %Elem(wk_ScheduleDay);
               if %trim(%xlate(wk_lo : wk_up : wk_ScheduleDay(i))) <> *blanks;
                  wk_ScheduleDayStr = %trim(wk_ScheduleDayStr) + ' ' +  wk_ScheduleDay(i);
               endIf;
               i += 1;
            endDo;
         endIf;

         //if schedule days are entered
         if (%trim(wk_ScheduleDayStr) <> *blanks);
            wk_Command  = %trim(wk_Command) + ' SCDDAY(' + %trim(wk_ScheduleDayStr) + ')';
         endIf;

         //Set the Scheduled time for the job if not one of the below listed values
         if (in_ProcessTime = '*CURRENT');
            wk_ScheduleTimeStr = %trim(in_ProcessTime);
         else;
            wk_JobTime = %dec(%time(in_processTime :*HMS) :*HMS);
            wk_ScheduleTimeStr = %editc(wk_JobTime : 'X');
         endIf;

         //if schedule time is entered
         if (wk_ScheduleTimeStr <> *blanks);
           wk_Command = %trim(wk_Command) + ' SCDTIME(' + %trim(wk_ScheduleTimeStr) + ')';
         endIf;

         //Set the Relative days for the job if not one of the below listed values
         if %trim(%Xlate(wk_lo : wk_up : wk_RelativeDay(1))) = '*LAST';
            wk_RelativeDayStr = wk_RelativeDay(1);
         else;
            i = 1;
            dow i <= %Elem(wk_RelativeDay);
               if %trim(%xlate(wk_lo : wk_up : wk_RelativeDay(i))) <> *blanks;
                   wk_RelativeDayStr = %trim(wk_RelativeDayStr) + ' ' +  wk_RelativeDay(i);
               endIf;
               i += 1;
            endDo;
         endIf;

         //if Relative days are entered
         if (%trim(wk_RelativeDayStr) <> *blanks);
            wk_Command = %trim(wk_Command) +
            ' RELDAYMON(' + %trim(wk_RelativeDayStr) + ')';
         endIf;

         //Job queue.
         wk_Command = %trim(wk_Command) + ' JOBQ(' + %trim(wk_Jobq) + ')' ;

         //Submit Job from the IAUSER user profile.
         wk_Command = %trim(wk_Command) + ' USER(IAUSER)' ;
                                                                                         //0003
   endsl;                                                                                //0003

   runCommand(wk_command : wk_ErrorFlag);

   //If the submission is successful, retrive Successful message
   if wk_ErrorFlag = *blanks;
      //In case of error ADD and UPD there can be multiple message id
      //therefore fetch the last success message sent from the system.
      Select;                                                                            //0003
      When in_ActFlagDb = 'ADD';                                                         //0003
       //wk_MessageId = 'CPC1238';
      When in_ActFlagDb = 'UPD';                                                         //0003
       //wk_MessageId = 'CPC1290';                                                       //0003
      When in_ActFlagDb = 'DEL';                                                         //0003
         wk_MessageId = 'CPC1239';                                                       //0003
      endsl;                                                                             //0003
      Message_Type = 'COMPLETION';
      wk_Message = rtvJobLogMessage();
      out_Status  = 'S';
      out_Message = %trim(wk_Message);
      //ADD/UPD/DEL the entry from the file IaJobScdEp as per the action.
      exSr Sr_DbAction;                                                                  //0003
   else;
      //In case of error fetch the error message from the joblog.
      wk_MessageId = ' ';                                                                //0002
      Message_Type  = 'DIAGNOSTIC';
      wk_Message = rtvJobLogMessage();
      out_Status  = 'E';
      out_Message = %trim(wk_Message);
   endIf;

   begSr Sr_DbAction;                                                                    //0003
      Select;                                                                            //0003
         //Delete Job schedule entry                                                    //0003
         when in_ActFlagDb = 'DEL';                                                      //0003
            exec sql                                                                     //0003
               Delete from IaJobScdEp where IaRepoNm = :in_RepoName                      //0003
               and IaProcTyp = :in_ProcessType;                                          //0003
                                                                                         //0003
         //Add Job schedule entry                                                       //0003
         when in_ActFlagDb = 'ADD';                                                      //0003
            exec sql                                                                     //0003
               Insert into IaJobScdEp(IaRepoNm,                                          //0003
                                      IaProcTyp,                                         //0003
                                      IaSchJobNm,                                        //0003
                                      IaJobQNm,                                          //0003
                                      IaPrDate,                                          //0003
                                      IaPrTime,                                          //0003
                                      IaFreq,                                            //0003
                                      IaSchDay,                                          //0003
                                      IaRtvDay,                                          //0003
                                      IaUsrId)                                           //0003
                              Values(:in_RepoName,                                       //0003
                                     :in_ProcessType,                                    //0003
                                     :wk_SchJobNm,                                       //0003
                                     :in_JobQueue,                                       //0003
                                     :in_ProcessDate,                                    //0003
                                     :in_ProcessTime,                                    //0003
                                     :in_Frequency,                                      //0003
                                     :in_ScheduleDay,                                    //0003
                                     :in_RelativeDay,                                    //0003
                                     :in_UserId);                                        //0003
         //Update Job schedule entry                                                    //0003
         when in_ActFlagDb = 'UPD';                                                      //0003
            exec sql                                                                     //0003
               Update IaJobScdEp set IaJobQNm = :in_JobQueue,                            //0003
                                     IaPrDate = :in_ProcessDate,                         //0003
                                     IaPrTime = :in_ProcessTime,                         //0003
                                     IaFreq   = :in_Frequency,                           //0003
                                     IaSchDay = :in_ScheduleDay,                         //0003
                                     IaRtvDay = :in_RelativeDay,                         //0003
                                     IaUsrId  = :in_UserId                               //0003
                  where  IaRepoNm = :in_RepoName and                                     //0003
                  IaProcTyp = :in_ProcessType and                                        //0003
                  IaSchJobNm = :wk_SchJobNm ;                                            //0003
      endsl;                                                                             //0003
   endSr;                                                                                //0003
end-proc;

//------------------------------------------------------------------------------------- //
//callMetadataBuildStmnt - Call statement for the metadata build statement
//------------------------------------------------------------------------------------- //
dcl-proc callMetadataBuildStmnt;

   clear wk_CallStatement;
   // wk_CallStatement = 'CALL PGM(#IAOBJ/IAMETASCHD) PARM('+ quote +                    //0006
   wk_CallStatement = 'CALL PGM(IAMETASCHD) PARM('+ quote +                              //0006
                        %trim(s1_xRef) + quote + ' ' + quote +
                        %trim(in_processType) + quote + ' ' + quote +
                        %Trim(udpsds.ProcNme) + quote + ')';

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure to Update Repository Status
//------------------------------------------------------------------------------------- //
dcl-proc updateRepositoryStatus;

   dcl-pi updateRepositoryStatus;
      RepositoryName varchar(10) value;
      RepositoryStatus varchar(1) value;
   end-pi;

   exec sql
     // update #iadta/IaInpLib                                                           //0006
     update IaInpLib                                                                     //0006
     set    xmdBuilt = :RepositoryStatus
     where  xRefNam = :RepositoryName;

   if sqlCode < successCode;
      Eval-corr uDpsds = wkuDpsds;
      uDpsds.wkQuery_Name = 'Update1_IaInpLib';
   endif;

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure to retrieve job log message
//------------------------------------------------------------------------------------- //
dcl-proc rtvJobLogMessage;
   dcl-pi rtvJobLogMessage varchar(200) end-pi;

   //local variable declaration
   dcl-s sql_string    varchar(1000) inz;
   dcl-s job_message   char(200)     inz;

   //Prepare sql string to retrieve last completion message from joblog
   sql_string = 'select cast(message_text as varchar(200)) log_message +
             from table(qsys2.joblog_info({q}{jobnumber}/QUSER/{jobname}{q})) +
             where message_type =  {q}{messagetype}{q} ';
   if wk_MessageId <> *blanks;                                                           //0002
      sql_string = sql_string + 'and message_id = {q}{wkMessageid}{q} ';                 //0002
   endif;                                                                                //0002
   sql_string = sql_string +
                'order by ordinal_position desc fetch first rows only';

   sql_string = %scanrpl('{q}' :quote :sql_string);
   sql_string = %scanrpl('{jobnumber}' :%editc(uDpsds.JobNmbr :'X') :sql_string);
   sql_string = %scanrpl('{jobname}' :%trim(uDpsds.JobNme) :sql_string);
   sql_string = %scanrpl('{messagetype}' :Message_Type :sql_string);
   sql_string = %scanrpl('{wkMessageid}' :wk_MessageId :sql_string);

   exec sql
     declare c_job_log_info scroll cursor for joblog;

   exec sql
     prepare joblog from :sql_string;

   exec sql
     open c_job_log_info;
   if sqlCode = CSR_OPN_COD;
      exec sql close c_job_log_info;
      exec sql open  c_job_log_info;
   endif;

   if sqlCode < successCode;
      Eval-corr uDpsds = wkuDpsds;
      uDpsds.wkQuery_Name ='Open_c_job_log_info';
   endif;

   exec sql
     fetch next from c_job_log_info into :job_message;
   if sqlCode < successCode;
      Eval-corr uDpsds = wkuDpsds;
      uDpsds.wkQuery_Name ='Fetch_c_job_log_info';
   endif;
   exec sql
     close c_job_log_info;

   return job_message;
end-proc;

// ------------------------------------------------------------------------------------ //
//RunCommand:                                                                          //
// ------------------------------------------------------------------------------------ //
dcl-proc runCommand;

   dcl-pi *N;
      command char(1000) options(*varsize) const;
      uwError char(1);
   end-pi;

   clear uwerror;
   monitor;
      qcmdexc(%trim(Command) :%len(%trim(Command)));
   on-error;
      uwError = 'Y';
   endmon;

end-proc;

// ------------------------------------------------------------------------------------ //
//Set Library list for the current job.                                                //
// ------------------------------------------------------------------------------------ //
dcl-proc addLibraries;

   in_EnvLib  = %xlate(wk_lo:wk_Up:in_EnvLib );                                          //0005
   monitor;                                                                              //0005
      If %Trim(in_EnvLib)  = '#IAOBJ';                                                   //0005
         wk_Command = 'CHGLIBL LIBL(#IAOBJ #IADTA QTEMP QGPL)';                          //0005
      Else;                                                                              //0005
         wk_Command = 'CHGLIBL LIBL(IAEMGDEV IAOBJDEV IADTADEV QTEMP QGPL)';             //0005
      Endif;                                                                             //0005
      runCommand(wk_Command:Uwerror);
   on-error;
      uwerror = 'Y';
   endmon;
end-proc;
