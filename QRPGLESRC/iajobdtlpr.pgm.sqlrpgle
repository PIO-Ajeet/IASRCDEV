**FREE
      //%METADATA                                                      *
      // %TEXT IA Active job details                                   *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------- //
//Created By    : Programmers.io @ 2024                                                 //
//Created Date  : 2024/11/14                                                            //
//Developer     : Kaushal kumar                                                         //
//Description   : Show IA jobs status when requested from the IAMENU screen based on    //
//                IABCKCNFG file.                                                       //
//Procedure Log :                                                                       //
//------------------------------------------------------------------------------------- //
//Procedure Name           | Procedure Description                                      //
//-------------------------|----------------------------------------------------------- //
//------------------------------------------------------------------------------------- //
//Modification Log:                                                                     //
//------------------------------------------------------------------------------------- //
//Date    | Mod_ID | Task# | Developer  | Case and Description                          //
//--------|--------|-------|------------|-----------------------------------------------//
//------------------------------------------------------------------------------------- //
ctl-opt copyright('Copyright @Programmers.io 2024');
ctl-opt option(*nodebugio:*srcstmt:*nounref);
ctl-opt DftActGrp(*no);

//Files Declaration
dcl-f IaJobdtlFm Workstn Sfile(sfl01:uWRrn) Indds(IndArr);

//Standalone Variable Declaration
dcl-s uWCnfJobCnt    Packed(3:0) Inz(0) ;
dcl-s uWRrn          Packed(4:0) ;
dcl-s uWSqlStmt      VarChar(2000);

//Constant Variables.
dcl-c CSR_OPN_COD   const(-502);
dcl-c successCode   const(00000);
dcl-c SQL_ALL_OK    '00000';
dcl-C Quote         '''';

//Data Structure Declaration
dcl-ds UdJobInfoDs Qualified;
   UsJobName   Char(10);
   UsJobUser   Char(10);
   UsJobNumber Packed(6);
   UsJobType   Char(3);
   UsJobStatus Char(4);
   UsSubsystem Char(10);
   UsTimestmt  timestamp;
end-ds;

//Indicator array
dcl-ds IndArr;
   Exit      ind pos(03);
   Refresh   ind pos(05);
   Cancel    ind pos(12);
   SflNxtChg ind pos(30);
   SflDsp    ind pos(31);
   SflDspctl ind pos(32);
   SflClr    ind pos(33);
   SflEnd    ind pos(34);
end-ds;

//------------------------------------------------------------------------------------ //
//  Main Line (Begin)                                                                  //
//------------------------------------------------------------------------------------ //
exec sql
  set option commit = *none,
             naming = *sys,
             usrprf = *user,
             dynusrprf = *user,
             closqlcsr = *endmod;

exsr Sfl_Clear;
exsr Sfl_Load;
exsr Sfl_Display;

*inlr = *on;

//------------------------------------------------------------------------------------ //
//SR Sfl_Clear: Clear the subfile                                                      //
//------------------------------------------------------------------------------------ //
BegSr Sfl_Clear;

  uWRrn = 0;
  sflclr = *on;
  write SflCtl01;
  SflClr = *off;

Endsr;

//------------------------------------------------------------------------------------ //
//SR Sfl_Load: Load the subfile                                                       //
//------------------------------------------------------------------------------------ //
BegSr Sfl_Load;

  //Get the Active job details
  Exsr Sr_Get_Active_Job_Info;
  if uWCnfJobCnt > *Zero;
    //Get the InActive job details
    Exsr Sr_Get_OutQ_Job_Info;
  Endif;

  uWSqlStmt = *Blanks;
  If C1PosTo <> *Blanks;
     uWSqlStmt = 'Select *from Qtemp/WkJobInfo ' +
                 ' Where wkJobName >= ' + Quote + %trim(C1PosTo) + Quote +
                 ' order by WKJOBNAME, WkTimeStmt Desc';
  else;
     uWSqlStmt = 'Select *from Qtemp/WkJobInfo +
                  order by WKJOBNAME, WkTimeStmt Desc';
  Endif;

  //Cursor Declaration
  Exec Sql prepare JobInfoStmt from :uWSqlStmt;

  Exec sql declare JobInfoCur cursor for JobInfoStmt;

  //Open cursor
  if sqlCode = CSR_OPN_COD;
     exec sql close JobInfoCur;
     exec sql open  JobInfoCur;
  else;
     exec sql open JobInfoCur ;
  endif;

  Exec sql fetch Next from JobInfoCur Into :UdJobInfoDs;

  Dow SqlCode = 0;
     //Load the Parameter Data Structure
     S1JobNm  = UdJobInfoDs.UsJobName;
     S1JobUsr = UdJobInfoDs.UsJobUser;
     S1Job#   = UdJobInfoDs.UsJobNumber;
     S1JobTyp = UdJobInfoDs.UsJobType;
     S1JobSts = UdJobInfoDs.UsJobStatus;
     S1SubSy  = UdJobInfoDs.UsSubsystem;

     IF S1SubSy = *Blanks;
        S1Status = '*Inactive';
        S1SubSy  = 'N/A';
     Else;
        S1Status = '*Active';
     Endif;

     S1LstDate= %Char(%date(UdJobInfoDs.UsTimestmt));
     uWRrn +=1 ;

     //if rrn value 9999 then come out of the loop
     If uWRrn >= 9999;
        Leave;
     Endif;

     Write Sfl01;

     Exec sql fetch Next from JobInfoCur Into :UdJobInfoDs;

  enddo;

  //Closing the cursor
  exec sql close JobInfoCur;

Endsr;

//------------------------------------------------------------------------------------ //
//Subfile Display :                                                                    //
//------------------------------------------------------------------------------------ //
BegSr Sfl_Display;

    dow Exit = *off;

     SflDsp    = *on;
     SflDspCtl = *on;
     SflEnd    = *on;

     //Handle empty subfile
     if uWRrn < 1;
        SflDsp = *off;
     endif;

     Write SflFtr01;
     Exfmt SflCtl01;

     Select;
      when Exit = *on or Cancel = *on;
         exsr EndPgm;

      when Refresh = *on;
        Refresh   = *off;
        SflNxtChg = *off;
        clear C1Posto;
        exsr Sfl_Clear;
        exsr Sfl_Load;
      when C1Posto <> *blanks;
        exsr Sfl_Clear;
        exsr Sfl_Load;
      Other;
        exsr Sfl_Clear;
        exsr Sfl_Load;
      endsl;
    Enddo;

Endsr;

//------------------------------------------------------------------------------------ //
//SR Sr_CreateTable: Create a temporary table                                          //
//------------------------------------------------------------------------------------ //
BegSr Sr_CreateTable;

  exec sql drop table Qtemp/WkJobInfo;

  exec Sql Create table Qtemp/WkJobInfo (
    wkJobName   char(10),    wkJobUser   char(10),
    wkJobNumber Decimal(6),  wkJobType   char(10),
    wkJobStatus Char(4),     wkSubsystem Char(10),
    wkTimestmt  timestamp );

Endsr;

//------------------------------------------------------------------------------------ //
//SR Sr_Get_Active_Job_Info: Get active job details                                    //
//------------------------------------------------------------------------------------ //
BegSr Sr_Get_Active_Job_Info;

  exsr Sr_CreateTable;

  exec sql
    Select count(*) into :uWCnfJobCnt
      From table(QSYS2/ACTIVE_JOB_INFO())
     Where JOB_NAME_SHORT in (Select Trim(Key_name2)
      From iabckcnfg
     Where Key_name1 = 'AIJOBLIST');

  uWSqlStmt = *Blanks;

  If uWCnfJobCnt > 0 and SqlCode = successCode;

     uWSqlStmt = 'Insert into Qtemp/WkJobInfo (wkJobName, wkJobUser, +
                  wkJobNumber, wkJobType, wkJobStatus, wkSubsystem, wkTimestmt) +
                  Select JOB_NAME_SHORT, JOB_USER, JOB_NUMBER, JOB_TYPE, +
                  JOB_STATUS, ifnull(SUBSYSTEM, ' + Quote + ' ' + Quote + '), +
                  JOB_ENTERED_SYSTEM_TIME                             +
                  From table(QSYS2/ACTIVE_JOB_INFO(DETAILED_INFO => ' +
                  Quote + 'ALL' + Quote + ')) +
                  Where JOB_NAME_SHORT in (Select Trim(Key_name2)     +
                  From iabckcnfg Where Key_name1 = '                  +
                  Quote + 'AIJOBLIST' + Quote + ')';

  else;

     uWSqlStmt = 'Insert into Qtemp/WkJobInfo (wkJobName, wkJobUser, +
                  wkJobNumber, wkJobType, wkJobStatus, wkSubsystem, wkTimestmt) +
                  select substr(JOB_NAME, LOCATE_IN_STRING(JOB_NAME, ' +
                  Quote + '/' + Quote + ', -1)+1) as job, +
                  substr(job_name, +
                  LOCATE_IN_STRING(JOB_NAME, ' + Quote + '/' + Quote + ' , 1) +1 , +
                  LOCATE_IN_STRING(JOB_NAME, ' + Quote + '/' + Quote + ' ,-1) -1 - +
                  LOCATE_IN_STRING(JOB_NAME, ' + Quote + '/' + Quote +
                  ' , 1)) as Job_user, +
                  substr(job_name,1,LOCATE_IN_STRING(JOB_NAME, ' +
                  Quote + '/' + Quote + ', 1)-1) as job_number, JOB_TYPE, JOB_STATUS,  +
                  ifnull(JOB_SUBSYSTEM, ' + Quote + ' ' + Quote + ' ),    JOB_END_TIME +
                  FROM table(job_info(job_status_filter=> ' + Quote + '*OUTQ' + Quote  +
                  ', JOB_USER_FILTER => ' + Quote + '*ALL' + Quote +
                  ')) a WHERE substr(JOB_NAME, LOCATE_IN_STRING(JOB_NAME, ' +
                  Quote + '/' + Quote + ' , -1)+1) In (Select Trim(Key_name2) +
                  From iAbckCnfg Where Key_name1 = ' +
                  Quote + 'AIJOBLIST' + Quote + ' )';
  Endif;

  exec Sql prepare wkJobInfoStmt from :uWSqlStmt;
  exec Sql Execute wkJobInfoStmt;

  //Get the inactive job count
  Clear uWCnfJobCnt;
  exec sql
    Select count(*) Into :uWCnfJobCnt
      From iabckcnfg
     Where Key_name1 = 'AIJOBLIST'
       and trim(Key_name2) not in (
    Select DISTINCT Trim(wkJobName)
       From qtemp/WkJobInfo );

Endsr;

//------------------------------------------------------------------------------------ //
//SR Sr_Get_OutQ_Job_Info: Get inactive job details                                    //
//------------------------------------------------------------------------------------ //
Begsr Sr_Get_OutQ_Job_Info;

  uWSqlStmt = *Blanks;
  uWSqlStmt = 'Insert into Qtemp/WkJobInfo (wkJobName, wkJobUser, +
               wkJobNumber, wkJobType, wkJobStatus, wkSubsystem, wkTimestmt) +
               select substr(JOB_NAME, LOCATE_IN_STRING(JOB_NAME, ' +
               Quote + '/' + Quote + ', -1)+1) as job, +
               substr(job_name, +
               LOCATE_IN_STRING(JOB_NAME, ' + Quote + '/' + Quote + ' , 1) +1 , +
               LOCATE_IN_STRING(JOB_NAME, ' + Quote + '/' + Quote + ' ,-1) -1 - +
               LOCATE_IN_STRING(JOB_NAME, ' + Quote + '/' + Quote +
               ' , 1)) as Job_user, +
               substr(job_name,1,LOCATE_IN_STRING(JOB_NAME, ' +
               Quote + '/' + Quote + ', 1)-1) as job_number, JOB_TYPE, JOB_STATUS,  +
               ifnull(JOB_SUBSYSTEM, ' + Quote + ' ' + Quote + ' ),    JOB_END_TIME +
               FROM table(job_info(job_status_filter=> ' + Quote + '*OUTQ' + Quote  +
               ', JOB_USER_FILTER => ' + Quote + '*ALL' + Quote +
               ')) a WHERE substr(JOB_NAME, LOCATE_IN_STRING(JOB_NAME, ' +
               Quote + '/' + Quote + ' , -1)+1) In (Select Trim(Key_name2) +
               From iAbckCnfg Where Key_name1 = ' +
               Quote + 'AIJOBLIST' + Quote + ' and Trim(Key_name2) not in +
               (select trim(wkjobname) from Qtemp/WkJobInfo ))';

  exec Sql prepare wkJobInfoStmt2 from :uWSqlStmt;

  exec Sql Execute wkJobInfoStmt2;

  //Delete all OUTQ record instead of recent OUTQ record
  Exec Sql
    Delete from Qtemp/WkJobInfo a
     where a.WKTIMESTMT < (select max(b.WKTIMESTMT)
      from Qtemp/WkJobInfo b
     where a.WKJOBNAME = b.WKJOBNAME
       and a.WKJOBSTATUS = 'OUTQ'
       and a.WKJOBSTATUS = b.WKJOBSTATUS)
       and a.WKJOBSTATUS = 'OUTQ';
Endsr;

//------------------------------------------------------------------------------------ //
//End Program                                                                          //
//------------------------------------------------------------------------------------ //
BegSr Endpgm;

   *inlr = *on;
   return;

Endsr;
