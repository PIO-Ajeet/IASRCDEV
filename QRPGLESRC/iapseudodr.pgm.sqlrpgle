**free
      //%METADATA                                                      *
      // %TEXT IA PseudoCode generation Initial Driver program         *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------- //
//Created By  : Programmers.io @ 2024                                                   //
//Created Date: 24/01/2024                                                              //
//Developer   : Programmers.io                                                          //
//Description : Initial Driver Program to Generate Pseudocode                           //
//                                                                                      //
//Procedure Log:                                                                        //
//------------------------------------------------------------------------------------- //
//Procedure Name              | Procedure Description                                   //
//----------------------------|---------------------------------------------------------//
//ValidParameters             | Validate the input parameter and write error            //
//ProcessPseudoCodeGeneration | Call the Pseudocode generation process based on type    //
//GenerateDocForAllMembers    | Sequential generation of Pseudo Code  for all the       //
//                            | Members received in Bulk request.                       //
//                            |                                                         //
//------------------------------------------------------------------------------------- //
//                                                                                      //
//Modification Log:                                                                     //
//------------------------------------------------------------------------------------- //
//Date-DMY| Mod_ID | Developer  | Case and Description                                  //
//--------|--------|------------|------------------------------------------------------ //
//16-05-24| 0001   | Manav T.   | Task#617 - Implement Logic for Bulk Pseudocode        //
//        |        |            |            Generation                                 //
//        |        |            |                                                       //
//31/05/24| 0002   | Santosh    | Task#638 - Added program call IAPSRPG3PR              //
//        |        |            |            for RPG3 Pseudocode Generation             //
//30-05-24| 0003   | Freeda     | Task#694 - Introduced logic of  multithreading for    //
//        |        |            |            handling bulk document generation          //
//04/07/24| 0004   | Vamsi      | Rename Bnddir AIERRBND, copybooks AICERRLOG/AIDERRLOG //
//        |        |            | and procedures AISQLDIAGNOSTIC and AIPSSRERRORLOG     //
//        |        |            | with IA*  [Task#261]                                  //
//08/10/24| 0005   | HIMANSHUGA | Added parm to determine if commented text will be     //
//        |        |            | added in pseudo code text: Task-689                   //
//10/12/24| 0006   | Sribalaji  | On requesting bulk pseudo code from front end,        //
//        |        |            | associated job is not submitting.                     //
//        |        |            | Passing the parameter 'minRRN' and 'MaxRRN' within    //
//        |        |            | Quote as charecter to 'IAPSEUDOMR'  [Task #1081]      //
//07/01/25| 0007   | HIMANSHUGA | Added parm to determine if declaration specs will be  //
//        |        |            | added in pseudo code : Task-1099                      //

//------------------------------------------------------------------------------------- //
Ctl-Opt CopyRight('Copyright @ Programmers.io © 2024');
Ctl-Opt Option(*NoDebugIo:*SrcStmt:*NoUnRef);
Ctl-Opt BndDir('IAERRBND' : 'IABNDDIR');                                                 //0004

//------------------------------------------------------------------------------------- //
//Variable Definitions
//------------------------------------------------------------------------------------- //
Dcl-s  wkRtnSts        Char(1)      Inz;
Dcl-s  wkPurgeParm     Char(10)     Inz;
Dcl-s  wkRtnMsg        Char(100)    Inz;
Dcl-s  ThreadsRequested Char(30);                                                        //0003
Dcl-s  Jobq            Char(15);                                                         //0003
Dcl-s  wk_Command      Char(1000)   Inz;                                                 //0003
Dcl-s  wk_ErrorFlag    Char(1)      Inz;                                                 //0003
Dcl-s  uwError         Char(1)      Inz;                                                 //0003
Dcl-s  jobname         Char(20);                                                         //0003

Dcl-s  ValidInd        Ind          Inz(*Off);
Dcl-s  BulkDownloadRequest Ind      Inz(*Off);                                           //0001

Dcl-s  IoParmPointer   Pointer      Inz(*Null);

Dcl-S NbrOfRows       Int(5)            Inz(%Elem(IaFDwnDtlPDS));                        //0001
Dcl-S wkRowNums       Int(5);                                                            //0001
Dcl-S IaFDwnDtlPIdx   Int(5);                                                            //0001
Dcl-s numThreadsRequested  Int(10);                                                      //0003
Dcl-s totalRecords    Int(5);                                                            //0003
Dcl-s membersPerJob   Int(5);                                                            //0003
Dcl-s extraMembers    Int(5);                                                            //0003
Dcl-s jobNumber       Int(5);                                                            //0003
Dcl-s limit           Int(5);                                                            //0003
Dcl-s offset          Int(5);                                                            //0003
Dcl-s minRRN          Packed(10:0);                                                      //0003
Dcl-s maxRRN          Packed(10:0);                                                      //0003

//------------------------------------------------------------------------------------- //
//Constant Definitions
//------------------------------------------------------------------------------------- //
Dcl-c  Quote      '''';
Dcl-c  Error      '0';
Dcl-c  Success    '1';

//------------------------------------------------------------------------------------- //
//Data Structure Definition
//------------------------------------------------------------------------------------- //
//Data Structure to write Pseudocode
Dcl-Ds OutParmWritePseudocodeDS  Qualified;
   dsReqId      Char(18);
   dsSrcLib     Char(10);
   dsSrcPf      Char(10);
   dsSrcMbr     Char(10);
   dssrcType    Char(10);
   dsSrcRrn     Packed(6:0);
   dsSrcSeq     Packed(6:2);
   dsSrcLtyp    Char(5);
   dsSrcSpec    Char(1);
   dsSrcLnct    Char(1);
   dsPseudocode Char(4046);
End-Ds;

//Data Structure to write Header information
Dcl-Ds OutParmHeaderDS Qualified ;
   dsReqId   Char(18);
   dsSrcLib  Char(10);
   dsSrcPf   Char(10);
   dsSrcMbr  Char(10);
   dssrcType Char(10);
End-Ds;

Dcl-Ds IaFDwnDtlPDS Qualified Dim(100);                                                  //0001
   wkSrcLibrary     Char(10)              Inz;                                           //0001
   wkSrcFile        Char(10)              Inz;                                           //0001
   wkMbrName        Char(10)              Inz;                                           //0001
   wkMbrType        Char(10)              Inz;                                           //0001
End-Ds;                                                                                  //0001

Dcl-Ds IaJobDArea Dtaara('*LIBL/IAJOBDAREA') Len(50);                                    //0003
   JobLvl           Char(5) Pos(1);                                                      //0003
   JobSvrty         Char(5) Pos(11);                                                     //0003
   JobText          Char(7) Pos(21);                                                     //0003
End-Ds;                                                                                  //0003

//------------------------------------------------------------------------------------- //
//Entry Parameter
//------------------------------------------------------------------------------------- //
Dcl-Pi IAPSEUDODR;
   inRequestID   Char(18);
   inRepoName    Char(10);
   inLibName     Char(10);
   inSrcPfName   Char(10);
   inMbrName     Char(10);
   inMbrType     Char(10);
   inIncludeText Char(1);                                                                //0005
   inIncludeDeclSpecs Char(1);                                                           //0007
End-Pi;

//------------------------------------------------------------------------------------- //
//Prototype Definitions
//------------------------------------------------------------------------------------- //
Dcl-Pr IAPSEUDOPR Extpgm('IAPSEUDOPR');
   *n           Char(18);
   *n           Char(10);
   *n           Char(10);
   *n           Char(10);
   *n           Char(10);
   *n           Char(1)  Options(*Nopass);                                               //0005
   *n           Char(1)  Options(*Nopass);                                               //0007
End-Pr;

Dcl-Pr IAPSEUDOCL Extpgm('IAPSEUDOCL');
   *n           Char(18);
   *n           Char(10);
   *n           Char(10);
   *n           Char(10);
   *n           Char(10);
End-Pr;

Dcl-Pr IAPCODPUR  Extpgm('IAPCODPUR');
   *n           Char(10);
End-Pr;

Dcl-Pr qcmdexc    Extpgm('QCMDEXC');                                                     //0003
   *n char(500)     options(*varsize) const;                                             //0003
   *n packed(15:5)  const;                                                               //0003
End-Pr;                                                                                  //0003

Dcl-Pr IAPSRPG3PR Extpgm('IAPSRPG3PR');                                                  //0002
   *n           Char(18);                                                                //0002
   *n           Char(10);                                                                //0002
   *n           Char(10);                                                                //0002
   *n           Char(10);                                                                //0002
   *n           Char(10);                                                                //0002
   *n           Char(1)  Options(*Nopass);                                               //0005
   *n           Char(1)  Options(*Nopass);                                               //0007
End-Pr;                                                                                  //0002
//------------------------------------------------------------------------------------- //
//Copybook definitions
//------------------------------------------------------------------------------------- //
/copy 'QCPYSRC/iaderrlog.rpgleinc'
/copy 'QMODSRC/iapcod01pr.rpgleinc'

//------------------------------------------------------------------------------------- //
//Set options
//------------------------------------------------------------------------------------- //
Exec Sql
   Set Option Commit    = *None,
              Naming    = *Sys,
              Usrprf    = *User,
              Dynusrprf = *User,
              Closqlcsr = *Endmod;

//------------------------------------------------------------------------------------- //
//Main Logic
//------------------------------------------------------------------------------------- //
Eval-Corr uDpsds = wkuDpsds;

//Validate the Pseudocode generation parameter details and write error
//If no error proceed to process the RPG or CL pseudocode generation
If ValidParameters();

   If BulkDownloadRequest;                                                               //0001
                                                                                         //0001
      Exec Sql                                                                           //0003
        Select Key_Value1, Key_Value2                                                    //0003
          into :threadsRequested, :Jobq                                                  //0003
          from iABckCnfg                                                                 //0003
         where Key_Name1 = 'PSEUDOCODE' and                                              //0003
               Key_Name2 = 'MULTITHREADING'                                              //0003
         limit 1;                                                                        //0003
                                                                                         //0003
      If Sqlcode = Successcode ;                                                         //0003
         Exec Sql                                                                        //0003
           Select Count(1)                                                               //0003
             into :totalRecords                                                          //0003
             from IaFDwnDtlP                                                             //0003
            where iareqid = :inRequestID;                                                //0003
                                                                                         //0003
         numThreadsRequested = %int(threadsRequested);                                   //0003
         membersPerJob = %Div( totalRecords : numThreadsRequested ) ;                    //0003
         extraMembers = %Rem( totalRecords : numThreadsRequested ) ;                     //0003
                                                                                         //0003
         for jobNumber = 1 to numThreadsRequested ;                                      //0003
            //Calculate limits and offsets                                              //0003
            limit = membersPerJob ;                                                      //0003
            offset = membersPerJob * (jobNumber - 1) ;                                   //0003
                                                                                         //0003
            //Last job will have remaining members                                      //0003
            if extraMembers > 0 and jobNumber = numThreadsRequested;                     //0003
               limit = membersPerJob + extraMembers;                                     //0003
            endif;                                                                       //0003
                                                                                         //0003
            If limit > 0 ;                                                               //0003
               Exec Sql                                                                  //0003
                 With minMaxRrn as (                                                     //0003
                   Select Rrn(a) as rrn                                                  //0003
                     from iafdwndtlp a                                                   //0003
                    where request_id = :inRequestID                                      //0003
                          limit :limit offset :offset )                                  //0003
                 Select Max(rrn), Min(rrn)                                               //0003
                   into :maxRRN, :minRRN                                                 //0003
                   from minMaxRrn;                                                       //0003
                                                                                         //0003
               clear wk_Command;                                                         //0003
               in IAJOBDAREA ;                                                           //0003
               Jobname = 'IAPSUDOT' + %Char(Jobnumber) ;                                 //0003
                                                                                         //0003
               //In V7RxMx there is no TYPE option so, send all param as Char            //0006
               //Within Quotes.                                                          //0006
               wk_Command = 'SBMJOB CMD(Call PGM(IAPSEUDOMR) PARM(' + Quote +            //0003
                            %trim(inRequestID) + Quote + ' ' + Quote +                   //0003
                            %Trim(inReponame)  + Quote + ' ' + Quote +                   //0006
                            %char(minRRN) +  Quote  + ' ' +  Quote   +                   //0006
                            %char(maxRRN) +  Quote  + ' ' +  Quote   +                   //0006
                            inIncludeText +  Quote  + ' ' +  Quote   +                   //0007
                            inIncludeDeclSpecs +  Quote  + ')) JOB(' +                   //0007
                            %Trim(Jobname) + ')' + ' LOG(' + %trim(Joblvl) +             //0003
                            ' ' + %Char(JobSvrty) + ' ' + %Trim(JobText) +               //0003
                            ')' ;                                                        //0003
               If Jobq <> ' ' ;                                                          //0003
                  wk_Command = %trim(wk_Command) + ' JOBQ(' + %Trim(Jobq) + ')' ;        //0003
               EndIf ;                                                                   //0003
                                                                                         //0003
               monitor;                                                                  //0003
                  qcmdexc(%trim(wk_command) : %len(%trim(wk_command)));                  //0003
               on-error;                                                                 //0003
                  wk_ErrorFlag = 'Y';                                                    //0003
               endmon;                                                                   //0003
                                                                                         //0003
            EndIf ;                                                                      //0003
         Endfor;                                                                         //0003
                                                                                         //0003
      Else ;                                                                             //0003
         //Process Bulk Pseudocode generation.                                          //0001
         GenerateDocForAllMembers() ;                                                    //0001
      EndIf ;                                                                            //0003
                                                                                         //0001
   Else;                                                                                 //0001
      //Process Pseudocode generation                                                   //0001
      ProcessPseudoCodeGeneration() ;                                                    //0001
                                                                                         //0001
   Endif;                                                                                //0001

   //Purge the old records in Pseudocode file (Purge days Config in IABCKCNFG)
   IaPcodPur(wkPurgeParm);

EndIf;

*Inlr = *On;
Return;

/copy 'QCPYSRC/iacerrlog.rpgleinc'

//------------------------------------------------------------------------------------- //
//ValidParameters - Validate the input parameter and write error
//------------------------------------------------------------------------------------- //
Dcl-Proc ValidParameters;

   Dcl-Pi ValidParameters ind End-Pi ;

   //CopyBook Declaration
/copy 'QCPYSRC/iaprderlog.rpgleinc'

   BulkDownloadRequest = *off ;                                                          //0001
   //If its a bulk download request                                                     //0001
   If inLibName = *Blanks                                                                //0001
      and inMbrName = *Blanks                                                            //0001
      and inMbrType = *Blanks;                                                           //0001
      ValidInd = *On;                                                                    //0001
      BulkDownloadRequest = *On;                                                         //0001
   Endif;                                                                                //0001
                                                                                         //0001
   //If object details are received, validate and fetch member details
   If inSrcPfName = *Blanks;

      Exec Sql
        Select Member_Libr,
               Member_Srcf,
               Member_Name,
               Member_Type
          Into :inlibName, :insrcPfName,
               :inmbrName, :inmbrType
          From Iaobjmap
         Where Object_libr = :inLibName
           And Object_Name = :inMbrName
           And Object_Type = :inMbrType;

      If SqlCode < SuccessCode;
         uDpsds.wkQuery_Name = 'Select_From_Iaobjmap';
         IaSqlDiagnostic(uDpsds);                                                        //0004
      EndIf;

      If SqlCode <> SuccessCode;
         wkRtnSts = Error;
         wkRtnMsg = 'Member details not found for object in file Iaobjmap';
      Else;
        wkRtnSts = Success;
      EndIf;

   EndIf;

   //Check if the record exist in source files for pseudocode generation
   Select;
      When inMbrType = 'RPG' Or inMbrType = 'RPGLE'
           or inMbrType = 'SQLRPG' Or inMbrType = 'SQLRPGLE';
         Exec sql
           Select '1' Into :Validind
             From IaQrpgsrc
            Where Library_Name   = :inLibName
              And Sourcepf_Name  = :inSrcPfName
              And Member_Name    = :inMbrName
              And Member_Type    = :inMbrType
                  Limit 1;

      When inMbrType = 'CLLE' Or inMbrType = 'CLP'
           Or inMbrType = 'CL';
         Exec sql
           Select '1' Into :Validind
             From IaQclsrc
            Where Library_Name   = :inLibName
              And Sourcepf_Name  = :inSrcPfName
              And Member_Name    = :inMbrName
              And Member_Type    = :inMbrType
                  Limit 1;
   Endsl;

   If SqlCode < SuccessCode;
      uDpsds.wkQuery_Name = 'Open_IARPGSRC_IACLSRC_ValidParmdtl';
      IaSqlDiagnostic(uDpsds);                                                           //0004
   EndIf;

   //If parm details are found in Iaqrpgsrc or Iaqclsrc
   //Else, set the error message
   If ValidInd = *On;
      wkRtnSts = Success;
   Else;
      wkRtnSts = Error;
      wkRtnMsg = 'Source does not exist for member';
   EndIf;

   //If error, write the error detail in pseudocode file
   If wkRtnSts = Error;

      //Get the values
      Clear OutParmWritePseudocodeDs;

      OutParmWritePseudocodeDs.dsReqId   = inRequestID;
      OutParmWritePseudocodeDs.dsSrcLib  = inLibName;
      OutParmWritePseudocodeDs.dsSrcPf   = inSrcPfName;
      OutParmWritePseudocodeDs.dsSrcMbr  = inMbrName;
      OutParmWritePseudocodeDs.dssrcType = inMbrType;

      Eval-Corr OutParmHeaderDs  = OutParmWritePseudocodeDs;

      //Write the heading for the Pseudocode
      IOParmPointer =  %Addr(OutParmHeaderDs);
      WriteHeader(IOParmPointer);

      //Write a blank line
      OutParmWritePseudocodeDs.dsPseudocode  = *Blanks;
      IOParmPointer  = %Addr(OutParmWritePseudocodeDs);
      WritePseudoCode(IOParmPointer);

      //Write error details
      OutParmWritePseudocodeDs.dsPseudocode  = wkRtnMsg;
      IOParmPointer  = %Addr(OutParmWritePseudocodeDs);
      WritePseudoCode(IOParmPointer);

      //Update the request status in IAFDWNDTLP - export file                           //0001
      IARequestStatusUpdate(inRequestID:inLibName:inSrcPfName                            //0001
                                                  :inMbrName:inMbrType);                 //0001
   EndIf;

   return ValidInd;

/copy 'QCPYSRC/iaprcerlog.rpgleinc'

End-Proc ValidParameters;

//------------------------------------------------------------------------------------- //
//ProcessPseudoCodeGeneration : Call the Pseudocode generation process based on type
//------------------------------------------------------------------------------------- //
Dcl-Proc ProcessPseudoCodeGeneration;

   //CopyBook Declaration
/copy 'QCPYSRC/iaprderlog.rpgleinc'

   //Call the program for parsing & writing the details in IASRCDOC
   //depending on member type.
   Select;
      When inMbrType = 'RPGLE' Or inMbrType = 'SQLRPGLE';                                //0002
         IAPSEUDOPR(inRequestID:inLibName:inSrcPfName:inMbrName:inMbrType :              //0005
                    inIncludeText : inIncludeDeclSpecs);                                 //0007

      When inMbrType = 'RPG' Or inMbrType = 'SQLRPG';                                    //0002
         IAPSRPG3PR(inRequestID:inLibName:inSrcPfName:inMbrName:inMbrType :              //0005
                    inIncludeText : inIncludeDeclSpecs);                                 //0007

      When inMbrType = 'CLLE' Or inMbrType = 'CLP' Or inMbrType = 'CL';
         IAPSEUDOCL(inRequestID:InLibName:inSrcPfName:inMbrName:inMbrType);
   EndSl;

/copy 'QCPYSRC/iaprcerlog.rpgleinc'

End-Proc ProcessPseudoCodeGeneration;

//------------------------------------------------------------------------------------- //
//SubProcedure GenerateDocForAllMembers : Get Member Details from IAFDWNDTLP
//------------------------------------------------------------------------------------- //
dcl-proc GenerateDocForAllMembers ;                                                      //0001
                                                                                         //0001
   //CopyBook Declaration                                                               //0001
/copy 'QCPYSRC/iaprderlog.rpgleinc'
                                                                                         //0001
   //Declare a cursor to fetch the record for the object those are available in         //0001
   //repo library.                                                                      //0001
   Exec Sql                                                                              //0001
     Declare GetMemberDetail cursor for                                                  //0001
     Select ialibname,                                                                   //0001
            iasrcfile,                                                                   //0001
            iamemname,                                                                   //0001
            iamemtype                                                                    //0001
        FROM iafdwndtlp                                                                  //0001
        where  iareqid = :inRequestID;                                                   //0001
                                                                                         //0001
   //Open cursor                                                                        //0001
   Exec Sql Open GetMemberDetail;                                                        //0001
   if sqlCode = CSR_OPN_COD;                                                             //0001
      Exec Sql Close GetMemberDetail;                                                    //0001
      Exec Sql Open  GetMemberDetail;                                                    //0001
   Endif;                                                                                //0001
                                                                                         //0001
   if sqlCode < successCode;                                                             //0001
      uDpsds.wkQuery_Name = 'Open_GetMemberDetail';                                      //0001
      IaSqlDiagnostic(uDpsds);                                                 //0004    //0001
      return ;                                                                           //0001
   endif;                                                                                //0001
                                                                                         //0001
   Dow sqlCode = successCode;                                                            //0001
                                                                                         //0001
      clear IaFDwnDtlPDS;                                                                //0001
                                                                                         //0001
      exec sql                                                                           //0001
        Fetch GetMemberDetail For :NbrOfRows Rows Into :IaFDwnDtlPDS;                    //0001
                                                                                         //0001
      if sqlCode < successCode;                                                          //0001
         uDpsds.wkQuery_Name = 'Fetch1_From_IAFDWNDRLP';                                 //0001
         IaSqlDiagnostic(uDpsds);                                              //0004    //0001
      ElseIf Sqlcode = 100;                                                              //0001
         Leave;                                                                          //0001
      EndIf;                                                                             //0001
                                                                                         //0001
      wkRowNums = 0;                                                                     //0001
      Exec Sql Get Diagnostics                                                           //0001
        :wkRowNums = Row_Count;                                                          //0001
                                                                                         //0001
      //Process the data                                                                //0001
      For IaFDwnDtlPIdx = 1 to wkRowNums by 1 ;                                          //0001
                                                                                         //0001
        inLibName    = IaFDwnDtlPDS(IaFDwnDtlPIdx).wkSrcLibrary;                         //0001
        inSrcPfName  = IaFDwnDtlPDS(IaFDwnDtlPIdx).wkSrcFile;                            //0001
        inMbrName    = IaFDwnDtlPDS(IaFDwnDtlPIdx).wkMbrName;                            //0001
        inMbrType    = IaFDwnDtlPDS(IaFDwnDtlPIdx).wkMbrType;                            //0001
                                                                                         //0001
        //Process Pseudocode generation                                                 //0001
        ProcessPseudoCodeGeneration() ;                                                  //0001
                                                                                         //0001
      EndFor;                                                                            //0001
                                                                                         //0001
      If wkRowNums < NbrOfRows;                                                          //0001
        Leave;                                                                           //0001
      EndIf;                                                                             //0001
                                                                                         //0001
   Enddo;                                                                                //0001
                                                                                         //0001
   //Close cursor                                                                       //0001
   exec sql close GetMemberDetail;                                                       //0001
                                                                                         //0001
/copy 'QCPYSRC/iaprcerlog.rpgleinc'
                                                                                         //0001
End-Proc GenerateDocForAllMembers ;                                                      //0001
