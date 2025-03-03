**free
      //%METADATA                                                      *
      // %TEXT Build meta data                                         *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------ //
//Created By    : Programmers.io @ 2020                                                //
//Creation Date : 2020/01/01                                                           //
//Developer     : Ajeet                                                         //
//Description   : Program to Build meta data                                           //
//                                                                                     //
//PROCEDURE LOG:                                                                       //
//------------------------------------------------------------------------------------ //
//Procedure Name           | Procedure Description                                     //
//-------------------------|---------------------------------------------------------- //
//No Procedure             |                                                           //
//------------------------------------------------------------------------------------ //
//MODIFICATION LOG:                                                                    //
//------------------------------------------------------------------------------------ //
//Date    | Developer  | Case and Description                                          //
//--------|-------- ---|-------------------------------------------------------------- //
//22/09/14| Shobhit    | Adding the call of program procedure reference program        //
//22/10/13| Bhoomish   | Adding the call of program making view used by java           //
//22/12/01| Stephen    | To Create & Drop Index, modified the logic to call            //
//        |            | "IACRTINDXR" instead of "IAINDEXR".                           //
//23/01/27| Manesh K   | Replace IAMENUR with BLDMTADTA                                //
//23/02/08| Ajeet K    | Removed call to:              Mod: 0001                       //
//        |            | 1. IACRTINDXR(S1_Xref :'AiMbrPrser');                         //
//        |            | 2. IACRTINDXR(S1_Xref :'DltOvrrFil');                         //
//23/02/24| KaranM     | Call IAUPDRFLIB program to update the refrenced               //
//        |            | object library in IAALLREFPF file. (Tag: 0002)                //
//23/03/06| Vipul P    | Modified the source for submit job command (Mod: 0003)        //
//14/09/23| Abhijith   | Metadata build process changes to update status for           //
//        |            | 'S', 'P' along with 'L' & 'C' (Mod: 0004)                     //
//04/10/23| Abhijith   | Metadata build process changes to write job details when      //
//        |            | scheduled. (Mod: 0005)                                        //
//23/11/02| Abhijit    | Need to change the usage filed to literal value               //
//23/11/02| Abhijit    | instead of decimal. Remove the call of program                //
//        | Charhate   | IAUPDRFLIB (Task#312)  (MOD:0006)                             //
//25/10/23| Abhijith   | Metadata refresh process changes (Mod: 0007 - Task#299)       //
//        | Ravindran  |                                                               //
//06/11/23| Manasa S   | IAMETAINFO data area update for refresh                       //
//        |            | (Task#338).(Mod: 0008)                                        //
//10/11/23| Venkatesh  | Metadata refresh should not be allowed when Repository        //
//        |   Battula  |    Library list is changed.   [Task#: 357]  [Mod id: 0009]    //
//15/11/23| Akshay     | Status not getting updated if library list changed after      //
//        |  Sopori    | submitting the refresh metadata. [Task#: 357]  [Mod id: 0010] //
//23/11/23| Naresh S   |Modified logic to submit BLDMTADTA job with correct parameters //
//        |            |incase BLDMTADTA called Interactively.(Task #393)[Mod id: 0011]//
//29/11/23| Akshay     |Refresh : Added call to IAREFDLTR to delete the records on the //
//        |  Sopori    |basis of status 'D' in IAREFOBJF. (Task #361)[Mod id: 0012]    //
//29/11/23| Sabarish   |Add Capability to Log time in Refresh Process[Mod id: 0013]    //
//        |            |(Task #424)                                                    //
//04/12/23| Saikiran   |Changes to populate Audit Report file [Mod id: 0014]           //
//        |            |(Task #425)                                                    //
//13/12/23| Kunal P.   |Changes related to Refresh Process task. [Mod id: 0015]        //
//        |            |(Task #438)                                                    //
//18/12/23| Akhil K.   |IAREFDLTR will be called only if any member or object is there //
//        |            |with status 'D' in IAREFOBJF and to get if there are any object//
//        |            |or member to be refresed from IAINIT (Task #463) [Mod id: 0016]//
//02/01/24| Yogita K.  |INIT/REFRESH process is revised whenever a new IA version is   //
//        |            |published. [Task #502] [Mod id: 0017]                          //
//03/01/24| Venkatesh  |Added call to IAPURRFAUD to purge refresh audit data           //
//        |   Battula  |[Task #506] [Mod id: 0018]                                     //
//18/01/24| Venkatesh  |Added call to IAUPREFLIB to update referenced object library   //
//        |   Battula  |   in IAALLREFPF.  [Task #523] [Mod id: 0019]                  //
//19/02/24| HIMANSHUGA |Moved call to IAPURRFAUD and IAUPREFLIB before marking job     //
//        |            |completion and BM process completion, [Task 584] Mod id:0020]  //
//19/02/24| Santosh    |Refresh process is writing records in file IAREFAUDF which was //
//        |  Kumar     |processed in last refresh run.[Task #587] [Mod id: 0021]       //
//06/03/24| HIMANSHUGA |Moved IAUPREFLIB call after IAALLREFPF is populated and before //
//        |            |IAVARTRKR process.[Task #601 Mod id:0022]                      //
//20/02/24| HIMANSHUGA |Program IAREFDLTR now accepts parameters and also runs for INIT//
//        |            |process [Task:535 Mod:0023]                                    //
//26/02/24| HIMANSHUGA |Call to IAREFDLTR to be placed at the end of the BM process.   //
//        |            |Placed call to IADLTFNLRF [Task:457 Mod:0024]                  //
//31/05/24| Vamsi      |Implement call of IAREPOHLTR at the end of the Build MetaData  //
//        | Krishna2   |process [Task#15] [Mod#id: 0025]                               //
//05/10/23| Anubhavi   |Replaced program name AIPURGREF to IAPURGREF:(Mod: 0026)       //
//        |            | [Task#268]                                                    //
//13/10/23| Rituraj    |Changed file name AIEXCTIME to IAEXCTIME [Task #248] (Mod:0027)//
//05/10/23|Satyabrat S | Rename AIPROCDTLV program and view name to IAPROCDTLV.        //
//        |            | [Task #265] [Tag 0028]                                        //
//05/10/23|Khushi W    | Rename program AIMBRPRSER to IAMBRPRSER (Mod: 0029) [Task#263]//
//05/10/23|Vipul P.    | Rename program AIBNDDREFR to IABNDDREFR (Mod: 0030) [Task#271]//
//07/06/24|Sribalaji   | Rename program AILNGNMDTR to IALNGNMDTR (Mod: 0031) [Task#256]//
//02/07/24|Sribalaji   | Remove the hardcoded #IADTA lib from all sources (Mod: 0032)  //
//        |            | [Task# 754]                                                   //
//02/07/24|Akhil K.    | Rename program AIPROCREFR to IAPROCREFR (Mod: 0033) [Task#272]//
//03/07/24|Yogesh Chan.| Rename program AILICKEYP  to IALICKEYP  (Mod: 0034) [Task#245]//
//03/07/24|Akhil K.    | Rename Bnddir AIERRBND, copybooks AICERRLOG and AIDERRLOG, and//
//        |            | procedures AISQLDIAGNOSTIC and AIPSSRERRORLOG with IA*        //
//        |            | (Mod: 0035) [Task#261]                                        //
//08/01/25|Pranav      | Task:1065 & 949 Added call for program IACPYBDTLR to update   //
//        |            | copy book missing details after Parsing. Tag: 0036            //
//22/10/24|Shobhit     | Task:1037 Change the PF/LF parsing functionality to           //
//        |            | add keyword and keyword value in IADSPFFDP table (#0037)      //
//12/08/24|Sabarish    | IFS Member Parsing (Mod: 0038) [Task#833]                     //
//------------------------------------------------------------------------------------ //
ctl-opt copyright('Copyright @ Programmers.io © 2022');
ctl-opt option(*NoDebugIO : *SrcStmt : *noUnRef);
ctl-opt bndDir('IABNDDIR' : 'IAERRBND');                                                 //0035

dcl-pi BLDMTADTA extpgm('BLDMTADTA');
   S1_Xref char(10);
   Bld_Mode char(7);                                                                     //0007
   Call_dtl char(10);                                                                    //0008
end-pi;

dcl-pr GetJobType Extpgm('IARTVJOBA');                                                   //0003
   *n char(1);                                                                           //0003
end-pr;                                                                                  //0003

dcl-pr  CPY2FNLREF Extpgm('CPY2FNLREF');
  *n char(10);
end-pr;

dcl-pr  IAPURGREF Extpgm('IAPURGREF');                                                   //0026
  *n char(10);
end-pr;

dcl-pr ModuleToModule extpgm('IAMODTMOD');
end-pr;

dcl-pr CrtBndRef extpgm('IABNDDREFR');                                                   //0030
   uref char(10);                                                                        //0015
end-pr;                                                                                  //0015

dcl-pr Iaprocrefr extpgm('IAPROCREFR');                                                  //0033
end-pr;

dcl-pr IaProdDtlV extpgm('IAPROCDTLV');                                                  //0028
end-pr;

dcl-pr IAEXCTIMR extpgm('IAEXCTIMR');                                                    //0027
    *n Char(10) Const;
    *n Char(10);
    *n Char(10);
    *n Char(10) Const;
    *n Char(10);
    *n Char(10);
    *n Char(10);
    *n Char(100) Const;                                                                  //0038
    *n Char(10) Const;
    *n Timestamp;
    *n Char(6) Const;
end-pr;

dcl-pr PROCSSPRFX extpgm('PROCSSPRFX');
end-pr;

dcl-pr IALNGNMDTR extpgm('IALNGNMDTR');                                                  //0031
  uwxref      char(10);
end-pr;

Dcl-Pr IACRTINDXR  extpgm('IACRTINDXR');                                                 //ST01
  *n Char(10) Const;                                                                     //ST01
  *n Char(10) Const;                                                                     //ST01
end-pr;                                                                                  //ST01
                                                                                         //ST01
dcl-pr IAUPDRFLIB extpgm('IAUPDRFLIB');                                                  //0002
  *n char(10);                                                                           //0002
end-pr;                                                                                  //0002
                                                                                         //0002
dcl-Pr IAREFDLTR  extpgm('IAREFDLTR');                                                   //0023
   *N  Char(7) Const;                                                                    //0023
   *N  Char(1) Const;                                                                    //0023
end-pr;                                                                                  //0023

Dcl-pr IAREFAUDR  extpgm('IAREFAUDR');                                                   //0014
  *n Char(10) Const;                                                                     //0014
  *n Char(10) Const;                                                                     //0014
end-pr;                                                                                  //0014

dcl-pr IAPURRFAUD  extpgm('IAPURRFAUD');                                                 //0018
  *n Char(10) Const;                                                                     //0018
end-pr;                                                                                  //0018

dcl-pr IAUPREFLIB  extpgm('IAUPREFLIB');                                                 //0019
  *n Char(10) Const;                                                                     //0019
end-pr;                                                                                  //0019
//remove references from IAALLREFPF for deleted sources/objects                         //0024
dcl-pr IADLTFNLRF extpgm('IADLTFNLRF');                                                  //0024
   *N Char(10) Const;                                                                    //0024
end-pr;                                                                                  //0024

dcl-pr IAREPOHLTR  extpgm('IAREPOHLTR');                                                 //0025
  *n Char(10) Const;                                                                     //0025
end-pr;                                                                                  //0025

//Update missing Lib/SrcPf Details for the copybook.                                    //0036
dcl-pr IACPYBDTLR extpgm('IACPYBDTLR');                                                  //0036
  *n char(10);                                                                           //0036
end-pr;                                                                                  //0036

/copy 'QCPYSRC/iamenur.rpgleinc'
/copy 'QMODSRC/iasrv01pr.rpgleinc'
/copy 'QCPYSRC/iaderrlog.rpgleinc'

dcl-ds IAJOBDAREA dtaara('*LIBL/IAJOBDAREA') len(50) ;                                   //0003
  JOBLVL char(5) pos(1);                                                                 //0003
  JOBSVRTY char(5) pos(11);                                                              //0003
  JOBTEXT char(7) pos(21);                                                               //0003
end-ds ;                                                                                 //0003

dcl-ds VariableDs qualified inz;
   w_MbrName char(10);
end-ds;

dcl-ds DeleteReposDs qualified inz;
   W_Xref char(10);
end-ds;

dcl-ds P_FldDs;
   I_S1Opt      ind Pos(1) inz;
   ReverseImage char(1) inz(X'21');
end-ds;

dcl-ds SflRecDtlDs qualified inz;
   W_Xref char(10);
   W_User char(10);
   W_Desc char(30);
end-ds;

dcl-ds IAMETAINFO dtaara len(62);                                                        //0007
 run_Mode char(7) pos(1);                                                                //0007
 up_timeStamp char(26) pos(8);                                                           //0007
 upend_timeStamp char(25) pos(35);                                                       //0007
end-ds;                                                                                  //0007
                                                                                         //0007
dcl-s w_Xref    char(10)     inz;
dcl-s isvalid   char(01)     inz;
dcl-s mdname    char(10)     inz;
dcl-s w_MbrName char(10)     inz;
dcl-s command   char(1000)   inz;
dcl-s w_UWERROR char(1)      inz;
dcl-s Wsexist   char(1)      inz('N') ;
dcl-s w_Count   packed(12:0) inz;
dcl-s uppgm_name      char(10)     inz;
dcl-s uplib_name      char(10)     inz;
dcl-s upsrc_name      char(10)     inz;
dcl-s uptimestamp     Timestamp;
dcl-s w_JobType       char(1)      inz;                                                  //0003
dcl-s S1_Mode         char(7)      inz('INIT');                                          //0007
dcl-s mode            char(7)      inz;                                                  //0011
dcl-c quote '''';                                                                        //0003
dcl-s w_jobNumber char(30) inz;                                                          //0004
dcl-s wbuilt char(1) inz(*blanks);                                                       //0007
dcl-s w_jobQueue char(10) inz;                                                           //0004
dcl-s wUnmatch char(1) inz(' ');                                                         //0008
dcl-s w_XrefNam char(10) inz(' ');                                                       //0008
dcl-s w_LibNam char(10) inz(' ');                                                        //0008
dcl-s RFSDeleteExist char(1) inz(' ');                                                   //0016
dcl-s wRefresh       char(1) inz(' ');                                                   //0016
dcl-s wVersion       char(6) inz(' ');                                                   //0016
dcl-s wVerno         char(6) inz(' ');                                                   //0016

exec sql
  set option commit = *none,
             naming = *sys,
             usrprf = *user,
             dynusrprf = *user,
             closqlcsr = *endmod,
             srtseq = *langidshr;

If Bld_Mode = 'INIT';                                                                    //0013
  Exec Sql Delete From IAEXCTIME;                                                        //0027
Else;                                                                                    //0013
  Exec Sql Delete IAEXCTIME where AIPROCESS = :Bld_Mode;                                 //0013 0027
EndIf;                                                                                   //0027

Eval-corr uDpsds = wkuDpsds;

uptimeStamp = %Timestamp();
CallP IAEXCTIMR('BLDMTADTA' :udpsds.ProcNme : udpsds.Lib : '*PGM' :                      //0027
upsrc_name :
//uppgm_name : uplib_name : ' ' : uptimeStamp : 'INSERT');                               //0038
uppgm_name : uplib_name : ' ' : ' ' : uptimeStamp : 'INSERT');                           //0038

//Execute the below check if REFRESH can be Processed.                                  //0007
in *lock IAMETAINFO;                                                                     //0007

exSr getRepositoryStatus;                                                                //0007
if Bld_Mode = 'REFRESH' and wBuilt = *blanks;                                            //0007
   out IAMETAINFO;                                                                       //0007
   udpsds.EXCPTTYP       = 'RFS';                                                        //0007
   udpsds.EXCPTNBR       = 'ERR';                                                        //0007
   udpsds.RTVEXCPTDT     = 'Repository metadata needs to be built ' +                    //0007
                             'first before submitting refresh.';                         //0007
   IaPssrErrorLog(uDpsds);                                                               //0007 0035
   *inLr = *on;                                                                          //0007
   return;                                                                               //0007
endIf;

//Check if REFRESH can be processed.                                                    //0008
if Bld_Mode = 'REFRESH';                                                                 //0008
   exSr CheckLibraryList;                                                                //0008
   if wUnmatch = 'Y';                                                                    //0008
      out IAMETAINFO;                                                                    //0008
      udpsds.EXCPTTYP       = 'RFS';                                                     //0008
      udpsds.EXCPTNBR       = 'ERR';                                                     //0008
      udpsds.RTVEXCPTDT     = 'Repository libraries modified since last ' +              //0008
                               'build.Please rebuild metadata before refresh.';          //0008
      IaPssrErrorLog(uDpsds);                                                            //0008 0035

      // Update status as 'C' since refresh cancelled
      exec sql                                                                           //0010
     //  update #iadta/IaInpLib                                                    //0032//0010
         update IaInpLib                                                                 //0032
            set XMDBuilt = 'C'                                                           //0010
          where Xref_Name = :S1_Xref                                                     //0010
          and   XMDBuilt  <> '';                                                         //0010

      *inLr = *on;                                                                       //0008
      return;                                                                            //0008
   endif;                                                                                //0008
endIf;                                                                                   //0008

up_timeStamp = %Char(uptimeStamp);                                                       //0007
run_Mode = Bld_Mode;                                                                     //0008
out IAMETAINFO;                                                                          //0007
                                                                                         //0007
mdname = 'BLDMTADTA';

GetJobType(w_JobType);                                                                   //0003

if w_JobType = '1';                                                                      //0003

   //Read Data Area for the Job configuration.                                          //0003
   In IAJOBDAREA ;                                                                       //0003

   If Bld_Mode = 'REFRESH';                                                              //0011
      mode = Bld_Mode;                                                                   //0011
   Else ;                                                                                //0011
      mode = S1_Mode;                                                                    //0011
   EndIf ;                                                                               //0011

   Command = 'SBMJOB CMD(CALL PGM(BLDMTADTA) PARM('+Quote +                              //0011
              %Trim(S1_Xref) + Quote + ' ' + Quote +                                     //0011
              %trim(mode) + Quote + ' ' + Quote + %Trim(udpsds.ProcNme) +                //0011
              Quote + '))' +                                                             //0011
             ' JOB( ' + %Trim(S1_XREF) + ')' +                                           //0011
             ' LOG('+JOBLVL+' '+JOBSVRTY +' '+JOBTEXT+')' ;                              //0011

   RunCommand(command : w_UWERROR);                                                      //0003
   Return;                                                                               //0003
endif;                                                                                   //0003

exec sql
//update #iadta/IaInpLib                                                                 //0032
  update IaInpLib                                                                        //0032
     set XMDBuilt = 'P'                                                                  //0004
   where Xref_Name = :S1_Xref;
                                                                                         //0007
//If Mode is 'INIT', only then backup store in IaRefLibP file                           //0007
// if Bld_Mode = S1_Mode;                                                                //0007 0009
//   exec sql Delete From IaRefLibP;                                                     //0007 0009
                                                                                         //0007 0009
//   exec sql Insert Into IaRefLibP                                                      //0007 0009
//        Select Xref_Name, Library_Name, Library_SeqNo, Crt_ByUser, Crt_TimeStam        //0007 0009
//          From #iadta/IaInpLib                                                         //0007 0009
//        where Xref_Name = :S1_Xref;                                                    //0007 0009
// endif;                                                                                //0007 0009

if sqlCode < successCode;
   uDpsds.wkQuery_Name = 'Update_XMD_IAINPLIB';
   IaSqlDiagnostic(uDpsds);                                                              //0035
endif;

w_jobNumber = %editc(UDPSDS.JOBNMBR:'X') + '/' + %trim(UDPSDS.JOBUSER) + '/' +           //0004
              %trim(UDPSDS.JOBNME);                                                      //0004
exec sql                                                                                 //0004
  update IaJobDtl                                                                        //0004
     set Job_Status = 'P'                                                                //0004
   where cross_Repository = :S1_Xref                                                     //0004
   and   Job_Name = trim(:w_jobNumber);                                                  //0004
                                                                                         //0004
if sqlCode = NO_DATA_FOUND;                                                              //0005
   exSr insertJobDetails;                                                                //0005
elseif sqlCode < successCode;                                                            //0005
   uDpsds.wkQuery_Name = 'Update_STS_IAJOBDTL';                                          //0004
   IaSqlDiagnostic(uDpsds);                                                              //0004 0035
endif;                                                                                   //0004

IaMenurVld(mdname:isvalid);

w_Xref    = S1_Xref;
w_MbrName = 'IDSPFDMBRL';

exsr Get_Build_MetaData;
//if no lock on repo                                                                    //0020
if Wsexist = 'N' ;                                                                       //0020
   //To update referenced object library in IAALLREFPF                                  //0020
   //IAUPREFLIB(S1_Xref);                                                          //0022//0020
   //R = delete excluded obj's entries from IAALLREFPF during INIT process              //0023
   if Bld_Mode = 'INIT';                                                                 //0020
      IAREFDLTR(Bld_Mode : 'R');                                                         //0023
   else;                                                                                 //0024
      //Remove the references for deleted source/objs                                   //0024
      IADLTFNLRF(S1_Xref);                                                               //0024
      //remove deleted/excluded object's entries from iA outfiles/files.                //0024
      exsr proceessRefreshDelete;                                                        //0024
      //Purge refresh audit data from IAREFAUDF                                         //0024
      IAPURRFAUD(S1_Xref);                                                               //0024
   endif;                                                                                //0023
endif;                                                                                   //0020

exec sql
//update #iadta/IaInpLib                                                                 //0032
  update IaInpLib                                                                        //0032
     set XMDBuilt  = 'C',
         XVersion  = (select                                                             //0017
                        case when(Xversion = ' '                                         //0017
                          or Xversion <> Aiverno)                                        //0017
                        then Aiverno                                                     //0017
                        else Xversion                                                    //0017
                         end                                                             //0017
   //                   from #IADTA/ailickeyp)                                     //0032//0017
   //                   from ailickeyp)                                            //0032//0034
                        from ialickeyp)                                                  //0034
   where Xref_Name = :S1_Xref;

if sqlCode < successCode;
   uDpsds.wkQuery_Name = 'Update_XMD_2_IAINPLIB';
   IaSqlDiagnostic(uDpsds);                                                              //0035
endif;
                                                                                         //0004
exec sql                                                                                 //0004
  update IaJobDtl                                                                        //0004
     set Job_Status = 'C'                                                                //0004
   where cross_Repository = :S1_Xref                                                     //0004
   and   Job_Name = trim(:w_jobNumber);                                                  //0004

if sqlCode < successCode;                                                                //0004
   uDpsds.wkQuery_Name = 'Update_STS01_IAJOBDTL';                                        //0004
   IaSqlDiagnostic(uDpsds);                                                              //0004 0035
endif;                                                                                   //0004

UPTimeStamp = %Timestamp();
CallP IAEXCTIMR('BLDMTADTA' :udpsds.ProcNme : udpsds.Lib : '*PGM' :                      //0027
              //upsrc_name : uppgm_name : uplib_name : ' ' :                             //0038
                upsrc_name : uppgm_name : uplib_name : ' ' : ' ' :                       //0038
                uptimeStamp : 'UPDATE');

if wsexist <> 'Y' ;                                                                      //0021
   //To Populate the Audit Report file IAREFAUDF
   IAREFAUDR(udpsds.ProcNme:udpsds.ProcNme);                                             //0014
endif;                                                                                   //0021

exsr Get_RmvLible;

*inlr = *on;

/copy 'QCPYSRC/iacerrlog.rpgleinc'
//------------------------------------------------------------------------------------ //
//Get_Build_MetaData :                                                                 //
//------------------------------------------------------------------------------------ //
begsr Get_Build_MetaData;

   Wsexist = 'N' ;

   exec sql
     select 'Y' into :wsexist
     from OBJECT_LOCK_INFO
     where OSCHEMA = :S1_Xref
     AND SYSTEM_OBJECT_NAME <> 'IAEXCTIME'                                               //0027
     fetch first row only ;

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Select_Object_Lock_Info';
      IaSqlDiagnostic(uDpsds);                                                           //0035
   endif;

   if wsexist <> 'Y' ;

      //----------------------------------------------------------------------------- //
      //Initialize application                                               Step : 1 //
      //----------------------------------------------------------------------------- //
      //IaInit(S1_Xref:' ' :' ');
      IaInit(S1_Xref:' ' :' ':wRefresh);                                                  //0016

      //wRefresh will have 'Y' if any member or object is added or modified              //0016
      if run_mode = 'INIT' or wRefresh = 'Y';                                             //0016
         //----------------------------------------------------------------------------- //
         //Initialize application                                               Step : 1 //
         //----------------------------------------------------------------------------- //
         //Create Index IASRC0001 on IASRCPF, IAMBR0001 on IDSPFDMBRL, IARPG0001 on
         //IAQRPGSRC, IACL00001 on IAQCLSRC, IADDS0001 on IAQDDSSRC, IACPGM001 on
         //IACPGMREF, IAPGM0001 on IAPGMREF
         IACRTINDXR(S1_Xref :'Iainit');                                                   //ST01

         //----------------------------------------------------------------------------- //0037
         //Update file detail info in FILEDTL                                            //0037
         //----------------------------------------------------------------------------- //0037
         IAFILEDTLR(S1_Xref:' ');                                                         //0037

         //----------------------------------------------------------------------------- //
         //Build RPG Data                                                       Step : 2 //
         //----------------------------------------------------------------------------- //

         IaMbrPrser(S1_Xref:' ');                                                        //0029

         //----------------------------------------------------------------------------- //
         //Update missing library and source file of copybook                            //
         //----------------------------------------------------------------------------- //
         IACPYBDTLR(S1_Xref);                                                            //0036

         IALNGNMDTR( S1_Xref ) ;                                                         //0031

         //----------------------------------------------------------------------------- //
         //Build CL Data                                                        Step : 3 //
         //Build DDS Data                                                       Step : 4 //
         //----------------------------------------------------------------------------- //
         //Create Index IACL00001 on IAQCLSRCCL
         //Create Index IADDS0001 on IAQDDSSRCL

         //----------------------------------------------------------------------------- //
         //Get Delete Override file                                             Step : 5 //
         //----------------------------------------------------------------------------- //

         exsr Get_DeleteOverride;

         //----------------------------------------------------------------------------- //
         //Parse CL Program                                                     Step : 6 //
         //----------------------------------------------------------------------------- //

         //Write all object references into Final references table
         CPY2FNLREF(S1_Xref);

         //Write Module to Module, Pgm to Module, Srvpgm to Module into Final table
         ModuleToModule();

         //Write Binding Directory References.                                           //0015
         CrtBndRef(S1_Xref);                                                              //0015

         //Write all System object references into History table.
         IAPURGREF(S1_Xref);                                                             //0026

         //To update referenced object library in IAALLREFPF                            //0022
         IAUPREFLIB(S1_Xref);                                                            //0022

         //----------------------------------------------------------------------------- //
         //Update file detail info in FILEDTL                                   Step : 9 //
         //----------------------------------------------------------------------------- //
         //0037 IAFILEDTLR(S1_Xref:' ');

         PROCSSPRFX();
         //Create Index IAFILE001 on IAFILEDTL
         //Create Index IAFILE002 on IAFILEDTL
         //Create Index IAFILE003 on IAFILEDTL
         //Create Index IAFILE004 on IAFILEDTL
         IACRTINDXR(S1_Xref :'IAFILEDTLR');                                               //ST01

         //----------------------------------------------------------------------------- //
         //Build Procedure To Procedure Reference                                        //
         //----------------------------------------------------------------------------- //

         monitor;
            IAPROCREFR();                                                                //0033
         on-error;
         endmon;

         //----------------------------------------------------------------------------- //
         //Create View of Procedure Reference for object Context Matrix Java             //
         //----------------------------------------------------------------------------- //

         IaProdDtlV();                                                                   //0028

         //----------------------------------------------------------------------------- //
         //Build IAVARTRK                                                       Step :12 //
         //----------------------------------------------------------------------------- //
         IACRTINDXR(S1_Xref :'IAVARTRKR');                                                //ST01
                                                                                          //ST01
         IAVARTRKR(S1_Xref:' ');

         //----------------------------------------------------------------------------- //
         //Build Repository Health Report                                                //
         //----------------------------------------------------------------------------- //
         IAREPOHLTR(S1_Xref);                                                            //0025

         //----------------------------------------------------------------------------- //
         //Drop all indexed created earlier                                     Step :13 //
         //----------------------------------------------------------------------------- //
         IACRTINDXR(S1_Xref :' ');                                                        //ST01

      endif;                                                                              //0016

      //----------------------------------------------------------------------------- // //0016
      //Delete records from iA files where status is 'D' in IAREFOBJF        Step :14 // //0016
      //----------------------------------------------------------------------------- // //0016

      //----------------------------------------------------------------------------- //
      //Remove repository from library list                                  Step :13 //
      //----------------------------------------------------------------------------- //
      w_Xref = S1_Xref;
      //----------------------------------------------------------------------------- // //0009
      //Save Processed library list                                                   // //0009
      //----------------------------------------------------------------------------- // //0009
      Exsr SaveLibraryList;                                                               //0009
   endif;

endsr;
//----------------------------------------------------------------------------- //       //0009
//Save the processed repository library list                                    //       //0009
//----------------------------------------------------------------------------- //       //0009
begsr SaveLibraryList;                                                                    //0009
   //If Mode is 'INIT', only then backup store in IaRefLibP file                         //0009
   if Bld_Mode = S1_Mode;                                                                 //0009
      exec sql Delete From IaRefLibP;                                                     //0009
                                                                                          //0009
      exec sql Insert Into IaRefLibP                                                      //0009
         Select Xref_Name, Library_Name, Library_SeqNo, Crt_ByUser, Crt_TimeStam          //0009
       // From #iadta/IaInpLib                                                      //0032//0009
          From IaInpLib                                                                   //0032
         where Xref_Name = :S1_Xref;                                                      //0009
   endif;                                                                                 //0009
endsr;                                                                                    //0009
//----------------------------------------------------------------------------- //
//Delete all override                                                           //
//----------------------------------------------------------------------------- //
begsr Get_DeleteOverride;

   monitor;
      Command = 'DLTOVR FILE(*ALL) LVL(*JOB)';
      RunCommand(Command:w_UWERROR);
   on-error;
   endmon;

endsr;
//----------------------------------------------------------------------------- //
//Remove repository from library list                                           //
//----------------------------------------------------------------------------- //
begsr Get_RmvLible;

   monitor;
      command = 'RMVLIBLE LIB('+ %trim(w_Xref) + ')';
      RunCommand(Command:w_UWERROR);
   on-error;
   endmon;

endsr;
//----------------------------------------------------------------------------- //      //0007
//Get repository status                                                         //      //0007
//----------------------------------------------------------------------------- //      //0007
begsr getRepositoryStatus;                                                               //0007
                                                                                         //0007
   exec sql                                                                              //0007
      select XMDBuilt into :wbuilt                                                       //0007
   // from #iadta/IaInpLib                                                         //0032//0007
      from IaInpLib                                                                      //0032
      where Xref_Name = :S1_Xref limit 1;                                                //0007
                                                                                         //0007
   if sqlCode < successCode;                                                             //0007
      uDpsds.wkQuery_Name = 'Select_Repository_Status';                                  //0007
      IaSqlDiagnostic(uDpsds);                                                           //0007 0035
   endif;                                                                                //0007
                                                                                         //0007
endsr;                                                                                   //0007
//------------------------------------------------------------------------------------- //
//insertJobDetails;
//------------------------------------------------------------------------------------- //
begsr insertJobDetails;                                                                  //0005
                                                                                         //0005
   exSr getJobQueue;                                                                     //0005
                                                                                         //0005
   exec sql                                                                              //0005
     insert into iajobdtl (iAXrefNam,                                                    //0005
                           iAJobName,                                                    //0005
                           iAJobQueu,                                                    //0005
                           iAJobDate,                                                    //0005
                           iAJobTime,                                                    //0005
                           iAJobSts,                                                     //0005
                           iABldMode,                                                    //0008
                           iACaller,                                                     //0008
                           CrtUser,                                                      //0005
                           CrtPgm)                                                       //0005
                   Values (trim(:S1_Xref),                                               //0005
                           trim(:w_jobNumber),                                           //0005
                           :w_jobQueue,                                                  //0005
                           :uDpsds.DtePgmRun,                                            //0005
                           :uDpsds.TmePgmRun,                                            //0005
                           'P',                                                          //0005
                           trim(:Bld_Mode),                                              //0008
                           trim(:Call_dtl),                                              //0008
                           trim(:uDpsds.JobUser),                                        //0005
                           trim(:uDpsds.SrcMbr));                                        //0005
                                                                                         //0005
   if sqlCode < successCode;                                                             //0005
      uDpsds.wkQuery_Name = 'Insert_IAJOBDTL';                                           //0005
      IaSqlDiagnostic(uDpsds);                                                           //0005 0035
   endif;                                                                                //0005
                                                                                         //0005
endsr;                                                                                   //0005
//------------------------------------------------------------------------------------- //0005
//getJobQueue of the scheduled job                                                      //0005
//------------------------------------------------------------------------------------- //0005
begSr getJobQueue;                                                                       //0005
                                                                                         //0005
   reset w_jobQueue;                                                                     //0005
                                                                                         //0005
   //Get job queue                                                                      //0005
   exec sql                                                                              //0005
      with jobQueueDtl as                                                                //0005
        (Select job_name, job_queue_name                                                 //0005
         from   table(qsys2.job_info(                                                    //0005
                         job_status_filter => '*ACTIVE',                                 //0005
                         job_user_filter => trim(:uDpsds.JobUser))))                     //0005
      select job_queue_name into :w_jobQueue                                             //0005
      from   jobQueueDtl                                                                 //0005
      where  job_name = :w_jobNumber;                                                    //0005
                                                                                         //0005
   //Check schedule                                                                     //0005
   if sqlCode < successCode;                                                             //0005
      uDpsds.wkQuery_Name = 'Select_Job_Queue_Metadata';                                 //0005
      IaSqlDiagnostic(uDpsds);                                                           //0005 0035
   endif;                                                                                //0005
                                                                                         //0005
endSr;                                                                                   //0005
//--------------------------------------------------------------------------------------//0008
//CheckLibraryList;                                                                     //0008
//--------------------------------------------------------------------------------------//0008
begsr CheckLibraryList;                                                                  //0008
   wUnmatch  = 'N';                                                                      //0008
   w_xRefnam = ' ';                                                                      //0008
   w_LibNam  = ' ';                                                                      //0008
                                                                                         //0008
   exec sql declare CheckLibL cursor for                                                 //0008
     (Select XRefNam , XLibNam, XLibSeq from IaInpLib  where XrefNam = :S1_xRef          //0008
      Except                                                                             //0008
      Select MRefNam , MLibNam, MLibSeq from IaRefLibP where MRefNam = :S1_xRef)         //0008
      Union                                                                              //0008
     (Select MRefNam , MLibNam, MLibSeq from IaRefLibP where MRefNam = :S1_xRef          //0008
      Except                                                                             //0008
      Select XRefNam , XLibNam, XLibSeq from IaInpLib  where XrefNam = :S1_xRef);        //0008
                                                                                         //0008
   exec sql open CheckLibL;                                                              //0008
   exec sql fetch CheckLibL into :w_xRefnam,:w_LibNam;                                   //0008
                                                                                         //0008
   //Cursor Blanks meaning no difference found in library list                          //0008
   if w_LibNam <> ' ' ;                                                                  //0008
      wUnmatch = 'Y';                                                                    //0008
   endif;                                                                                //0008
                                                                                         //0008
   exec sql close CheckLibL;                                                             //0008
                                                                                         //0008
endsr;                                                                                   //0008
//---------------------------------------------------------------------------------*    //0024
//Delete records from iA files where status is 'D' in IAREFOBJF        Step :14         //0024
//---------------------------------------------------------------------------------*    //0024
begsr proceessRefreshDelete;                                                             //0024
   exec sql                                                                              //0024
     Select 'Y' into :RFSDeleteExist                                                     //0024
     From iARefObjF                                                                      //0024
     Where iAStatus = 'D'                                                                //0024
     Limit 1;                                                                            //0024
                                                                                         //0024
   if RFSDeleteExist = 'Y';                                                              //0024
      IAREFDLTR(Bld_Mode : ' ' );                                                        //0024
   endif;                                                                                //0024
endsr;                                                                                   //0024
