**free
      //%METADATA                                                      *
      // %TEXT Library list management program for IATOOL              *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------ //
//CREATED BY :   Programmers.io @ 2020                                                 //
//CREATE DATE:   2020/01/01                                                            //
//DEVELOPER  :   Kaushal kumar                                                         //
//DESCRIPTION:   Program to add Library during Meta-data build                         //
//                                                                                     //
//PROCEDURE LOG:                                                                       //
//------------------------------------------------------------------------------------ //
//Procedure Name           | Procedure Description                                     //
//-------------------------|---------------------------------------------------------- //
//No Procedure             |                                                           //
//------------------------------------------------------------------------------------ //
//                                                                                     //
//------------------------------------------------------------------------------------ //
//Modification Log                                                                     //
//------------------------------------------------------------------------------------ //
//  Date     Developer   Case And Description                                          //
//  YY/MM/DD ----------  ------------------------------------------------------------- //
//                                                                                     //
//  22/08/11 SUNNY JHA   Fixed following errors :                                      //
//                       1.Stop adding invalid libraries                               //
//                       2.In case of blank sequence no., Validation to be done        //
//                         correctly.                                                  //
//                       3.In case of blank sequence no. inputted, correct the         //
//                         sequence.                                                   //
//                       4.Stop clearing program messages, When not required.          //
//                       5.Fix Error reading of each reco When not required.           //
//                       6.Fix Duplicate lib check process.                            //
//                       7.Clear Error subfile variables during clear subfile          //
//                         operation                                                   //
//                       8.Validate operation of 250                                   //
//                       9.In case of no change in lib list clear the program          //
//                         message                                                     //
//                       10.In case of no lib list inputted display error messsage     //
//                                                                                     //
//  22/08/31 SUNNY JHA   Getting Description of the Repository.                        //
//  22/10/28 DILIP M     Cursor repositioning issue fix.                               //
//  22/10/31 AJ01        Created user get changed when edit the library list.          //
//  23/05/04 KARANM 0001 Duplicate records issue in IAINPLIB file fixed                //
//  14/09/23 Abhijith    Metadata build process changes to update status for           //
//                       'S', 'P' along with 'L' & 'C' (Mod: 0002)                     //
//  02/07/24 Sribalaji   Remove the hardcoded #IADTA lib from all sources (Mod: 0003)  //
//                       [Task# 754]                                                   //
//  04/07/24 Akhil K.    Rename AIERRBND, copybooks starting with AI* and procedure    //
//                       AISQLDIAGNOSTIC with IA*  (Mod: 0004) [Task# 261]             //
//  14/10/24 Sasikumar R Added logic for IFS member parsing. [Task# 833] (Mod: 0005)   //
//  15/10/24 Vivek       Rearranging Seq for repo and ifs path                         //
//           Sharma      [Task# 833] (Mod: 0006)                                       //
//------------------------------------------------------------------------------------ //
ctl-opt copyright('Copyright @ Programmers.io © 2022');
ctl-opt option(*NoDebugIO : *SrcStmt : *noUnRef);
ctl-opt bndDir('IABNDDIR' : 'IAERRBND');                                                 //0004

//Files Declaration
//dcl-f IaAddLibFm Workstn Sfile(sfl01 : Rrn) Indds(IndArr) Infds(Infds);                //0005
dcl-f IaAddLibFm Workstn Indds(IndArr) Infds(Infds) Sfile(sfl01:Rrn)                     //0005
                                                    Sfile(sfl02:Rrn2);                   //0005

//Prototye Declaration
dcl-pi IAADDLIBR extpgm('IAADDLIBR');
   p_xref char(10) options(*NoPass);
   p_Type char(3)  options(*NoPass);                                                     //0005
end-pi;

/copy 'QCPYSRC/iamsgsflf.rpgleinc'
/copy 'QMODSRC/iasrv01pr.rpgleinc'
/copy 'QCPYSRC/iaderrlog.rpgleinc'

//File information Data structure
dcl-ds Infds;
   PressedKey char(1) pos(369);
end-ds;

//Indicator array
dcl-ds IndArr;
   Exit      ind pos(03);
   Refresh   ind pos(05);
   SwitchOpt ind pos(07);                                                                //0005
   Cancel    ind pos(12);
   SflNxtChg ind pos(30);
   SflDsp    ind pos(31);
   SflDspctl ind pos(32);
   SflClr    ind pos(33);
   SflEnd    ind pos(34);
   Ind_LibPC ind pos(35);
   Ind_IFSPC ind pos(36);
end-ds;
//Record Array
dcl-ds Record qualified dim(251);                                //SJ01
   seqno   packed(4:0) inz(*Zeros);
   Library char(10) inz(*Blanks);
end-ds;

dcl-s I               packed(4:0) inz;
dcl-s J               packed(4:0) inz;
dcl-s Rrn             packed(4:0) inz;
dcl-s Rrn2            packed(4:0) inz;                           //0005
dcl-s w_count         packed(4:0) inz;
dcl-s w_count1        packed(4:0) inz;
dcl-s w2_SeqNo        packed(4:0) inz;
dcl-s w2_SeqNo2       packed(4:0) inz;                           //0005
dcl-s w_SeqNo         packed(4:0) inz;
dcl-s lst_seq         packed(4:0) inz;
dcl-s w_count_BeforeImage packed(4:0) inz;                       //SJ01
dcl-s w_count_AfterImage  packed(4:0) inz;                       //SJ01
dcl-s w2_LibName      char(10)    inz;
dcl-s w2_IfsDirNm     char(100)   inz;                           //0005
dcl-s w_desc          char(30)    inz;
dcl-s w_LibName       char(10)    inz;
dcl-s w_Library       char(10)    inz;
dcl-s uwaction        char(20)    inz;
dcl-s uwactdtl        char(50)    inz;
dcl-s ProgramQ        char(10)    inz('IAADDLIBR');
dcl-s command         char(1000)  inz;
dcl-s uwerror         char(01)    inz;
dcl-s Ind_ChgliblFlag ind         inz;
dcl-s Ind_ChgIFSFlag  ind         inz;                           //0005
dcl-s Ind_ErrorFlag   ind         inz;
dcl-s Ind_Upd         ind         inz;                           //SJ01
dcl-s Ind_Nolib       ind         inz;                           //SJ01
dcl-s Ind_NoChgLibList ind         inz;                          //SJ01
dcl-s H_ERRFLAG       ind         inz;
dcl-s Ind_Refresh     ind         inz;
dcl-s Ind_ChangeRec   ind         inz;
dcl-s Ind_LastOneLib  ind         inz;
dcl-s Ind_UpdRecord   ind         inz;
dcl-s sav_lib         char(10)    inz;
dcl-s libExistInFile  char(1)     inz;
dcl-s seqExistInFile  char(1)     inz;
dcl-s savLastLib      char(10)    inz;
dcl-s sav_msgId       char(7)     inz('       ');
dcl-s sav_msgDta      char(80)    inz;
dcl-s sav_seq         packed(4)   inz;
dcl-s sav_errRrn      packed(4)   inz;
dcl-s Arr_Library_Repo  char(10)    inz dim(9999);
dcl-s Arr_Library_Scrn  char(10)    inz dim(9999);
dcl-s W_Arr_Library_Scrn  char(10)    inz dim(9999);            //SJ01
dcl-s w_CrtUser       char(10)    inz;                          //AJ01
dcl-s InsertInpLib    char(1)     inz;                          //0001
dcl-s w_Lock          ind         inz;                          //0002
dcl-s w_Built         char(1)     inz;                          //0002
dcl-s w_repositoryStatus char(1)  inz;                          //0002
dcl-s Ind_NoIfsD          ind         inz          ;            //0005
dcl-s Arr_IFSPath_Repo    char(100)   inz dim(9999);            //0005
dcl-s Arr_IFSPath_Scrn    char(100)   inz dim(9999);            //0005
dcl-s RecordIFS           char(100)   inz dim(9999);            //0005
dcl-s w_SEQNUM            char(1)     inz;                      //0006
dcl-ds InpRecord qualified dim(502);                            //0006
   seqno   packed(4:0) inz(*Zeros);                             //0006
   LibName char(10)  inz(*Blanks);                              //0006
   DirName char(100) inz(*Blanks);                              //0006
end-ds;                                                         //0006

dcl-c EnterKey   const(x'F1');
dcl-c w_Quote    const('''');

//-------------------------------------------------------------------------------------//
//Mainline Programming                                                                 //
//-------------------------------------------------------------------------------------//
exec sql
  set option Naming    = *Sys,
             Commit    = *None,
             UsrPrf    = *User,
             DynUsrPrf = *User,
             CloSqlCsr = *EndMod;

Eval-corr uDpsds = wkuDpsds;

//Fetching Description of the Repository                                               //SJ02
exec sql                                                                                //SJ02
   Select DESCRIPTION into :w_Desc                                                      //SJ02
  // from #iadta/IaInpLib                                                         //0003//SJ02
    from IaInpLib                                                                       //0003
   Where XREF_NAME = :P_XREF limit 1;                                                   //AJ02

If %PARMS  =  2    And                                                                  //0005
   p_Type  = 'IFS' ;                                                                    //0005
   Exsr Sr_AddIFSDirectory ;                                                            //0005
Endif;                                                                                  //0005

If %PARMS  =  1    Or                                                                   //0005
   p_Type  = 'LIB' ;                                                                    //0005
//Program Processing :
exsr Sfl_Clear;
exsr Sfl_Load;
exsr Sfl_Display;

Endif;                                                                                  //0005
*inlr = *on;

/copy 'QCPYSRC/iacerrlog.rpgleinc'
//------------------------------------------------------------------------------------ //
//Subfile Clear :-                                                                     //
//------------------------------------------------------------------------------------ //
BegSr Sfl_Clear;

   If Ind_Upd = *Off;                                            //SJ01
     exsr RemoveMessageFromProgramQ;
   EndIf;                                                        //SJ01
   Rrn = 0;
   Clear H_ERR;                                                  //SJ01
   SflClr = *on;
   write SflCtl01;
   SflClr = *off;

EndSr;

//------------------------------------------------------------------------------------ //
//Subfile Load :-                                                                      //
//------------------------------------------------------------------------------------ //
BegSr Sfl_Load;

   I = 0;
   lst_seq = -1;
   exec sql
     declare LoadCsr cursor for
       select Library_SeqNo, Library_Name                                                //0005
     //select SeqNo, Library_Name                                                        //0005
      // from   #IADTA/iainplib                                                          //0003
        from IaInpLib                                                                    //0003
       where  Xref_Name =trim(:p_xref)
       And    Library_Name <> ' '                                                        //0005
       order by Library_SeqNo;                                                           //0005
     //order by SeqNo;                                                                   //0005

   exec sql open LoadCsr;
   if sqlCode = CSR_OPN_COD;
      exec sql close LoadCsr;
      exec sql open  LoadCsr;
   endif;

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Open_LoadCsr';
      IaSqlDiagnostic(uDpsds);                                                           //0004
   endif;

   if sqlCode = successCode;
      exec sql fetch next from LoadCsr Into :w2_SeqNo,
                                            :w2_LibName;
      if sqlCode < successCode;
         uDpsds.wkQuery_Name = 'Fetch_1_LoadCsr';
         IaSqlDiagnostic(uDpsds);                                                        //0004
      endif;

      // Write 1st Record as Blank
      if Rrn = 0;
         Rrn       = 1;
         S1SeqNo   = 0;
         S1LibName = *blanks;

         write Sfl01;
      endif;

      if w2_LibName <> *blanks;
         dow sqlCode = successCode;
            clear H_SeqNo;
            clear H_LibName;

            S1SeqNo    = w2_SeqNo;
            S1LibName  = %trim(w2_LibName);

            H_SeqNo    = S1SeqNo;
            H_LibName  = %trim(S1LibName);
            lst_seq    = S1SeqNo;

            Rrn     += 1;
            Arr_Library_Repo(RRN) = %trim(S1LibName);
            W_Count = RRN ;

            if Rrn > 9999;
               leave;
            endif;

            write Sfl01;

            exec sql fetch next from LoadCsr Into :w2_SeqNo, :w2_LibName;
            if sqlCode < successCode;
               uDpsds.wkQuery_Name = 'Fetch_2_LoadCsr';
               IaSqlDiagnostic(uDpsds);                                                  //0004
               leave;
            endif;
         enddo;

         Exec sql close LoadCsr;
         clear w2_LibName;

      endif;

      // Write remaining blank records upto 250
      for I = Rrn to 250;
         S1SeqNo   += 10;
         S1LibName  = *Blanks;

         H_SeqNo    = S1SeqNo;
         H_LibName  = *Blanks;
         Rrn += 1;

         write Sfl01;
      endfor;

   endif;

EndSr;

//------------------------------------------------------------------------------------ //
//Subfile_Load_Arr :-                                                                  //
//------------------------------------------------------------------------------------ //
BegSr Sfl_Load_Arr;

   I = 0;
   lst_seq = -1;
   w_repositoryStatus = *blanks;

   exec sql                                                                             //AJ01
     Select CRT_BYUSER, IS_MD_BUILT into :w_CrtUser, :w_Built                           //0002
      // from #IADTA/iainplib Where Xref_Name = trim(:p_Xref)                     //0003//AJ01
       from IaInpLib Where Xref_Name = trim(:p_Xref)                                    //0003
       limit 1;                                                                         //AJ01
   if sqlCode = successCode;                                                            //AJ01
      uDpsds.JobUser = w_CrtUser;                                                       //AJ01
   Endif;                                                                               //AJ01

   if w_Built <> *blanks;                                                               //0002
      w_repositoryStatus = 'L';                                                         //0002
   endif;                                                                               //0002

   if w_Built = 'P';                                                                    //0002
      w_Lock = *on;                                                                     //0002
      Ind_errorFlag = *On;                                                              //0002
      Ind_NoChgLibList = *On;                                                           //0002
   endif;                                                                               //0002

   if w_Built <> 'P';                                                                   //0002
                                                                                        //0002
   exec sql
   //  Delete from #IADTA/iainplib Where Xref_Name = trim(:p_Xref);                     //0003
     Delete from IaInpLib Where Xref_Name     = trim(:p_Xref) and                       //0003 0005
                                LIBRARY_NAME <> '  '          ;                         //0005
   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Delete_IAINPLIB';
      IaSqlDiagnostic(uDpsds);                                                           //0004
   endif;

   w_count_BeforeImage =                                   //SJ01
          %LookUp ( ' ': Arr_Library_Repo :2)  - 1;        //SJ01
   w_count_AfterImage =                                    //SJ01
          %LookUp ( ' ': W_Arr_Library_Scrn:2) - 1;        //SJ01
   Ind_NoChgLibList = *On;                                 //SJ01
   J = 1;                                                  //SJ01
   for i = 1 to 250;
      // Write 1st Record as Blank
      if Rrn = 0;
         Rrn       = 1;
         S1SeqNo   = 0;
         S1LibName = *blanks;
         Clear Arr_Library_Repo;

         write Sfl01;
      endif;

      if Record(i).Library <> *blanks;
         clear H_SeqNo;
         clear H_LibName;

         //SJ01 S1SeqNo    = Record(i).SeqNo;
         S1SeqNo    = J*10;                                      //SJ01
         S1LibName  = %trim(Record(i).Library );

         //SJ01 H_SeqNo    = Record(i).SeqNo;
         H_SeqNo    = S1SeqNo;                                   //SJ01
         H_LibName  = %trim(Record(i).Library );
         lst_seq    = S1SeqNo;

         J +=1;                                                  //SJ01
         Rrn      += 1;
         W_Count = RRN ;
         Arr_Library_Repo(RRN) = %trim(Record(i).Library );

         InsertInpLib = 'Y';                                                   //0001
         Dow InsertInpLib = 'Y';                                               //0001
                                                                                        //0002
         exsr CheckRepositoryProcessed;                                                 //0002
         if w_Lock = *on;                                                               //0002
            Ind_errorFlag = *On;                                                        //0002
            Ind_NoChgLibList = *On;                                                     //0002
            leave;                                                                      //0002
         endIf;                                                                         //0002
         for S1Seqno = 10 by 10 to 2500;                                                //0006
            Clear w_SEQNUM ;                                                            //0006
            Exec Sql                                                                    //0006
              Select 'Y' INTO :w_SEQNUM                                                 //0006
              From   IaInpLib                                                           //0006
              where  XREF_NAME = :P_XREF and                                            //0006
                 LIBRARY_SEQNO = :S1SeqNo;                                              //0006
            if SQLCODE = 100;
               leave;
            endif;
         endfor;
                                                                                        //0002
         exec sql
            insert into
              // #IADTA/iainplib (Xref_Name,                                            //0003
                      IaInpLib (Xref_Name,                                              //0003
                                Library_SeqNo,                                          //0005
                             // SeqNo,                                                  //0005
                                Library_Name,
                                Is_Md_Built,                                            //0002
                                Crt_ByUser,
                                Crt_ByPgm,
                                DESCRIPTION)
                        Values (trim(:p_Xref),
                                trim(:S1SeqNo),
                                trim(:S1LibName),
                                :w_repositoryStatus,                                    //0002
                                trim(:uDpsds.JobUser),
                                trim(:uDpsds.SrcMbr),
                                trim(:w_desc));

         if sqlCode < successCode;
            uDpsds.wkQuery_Name = 'Insert_IAINPLIB';
            IaSqlDiagnostic(uDpsds);                                                     //0004
            Clear Command;                                                     //0001
            command = 'DLYJOB DLY(1)';                                         //0001
            Runcommand(Command:Uwerror);                                       //0001
         Else;                                                                 //0001
            InsertInpLib = 'N';                                                //0001
         endif;
         Enddo;                                                                //0001

         if Rrn > 9999;
            leave;
         endif;

         write Sfl01;

      endif;

      If W_Arr_Library_Scrn(1) = *Blanks and                                                  //SJ01
         w_count_BeforeImage =  w_count_AfterImage;                                           //SJ01
         If %trim(W_Arr_Library_Scrn(i+1))<> %trim(Record(i).Library);                        //SJ01
            Ind_NoChgLibList = *Off;                                                          //SJ01
         EndIf;                                                                               //SJ01
      Else;                                                                                   //SJ01
           Ind_NoChgLibList = *Off;                                                           //SJ01
      EndIf;                                                                                  //SJ01
   endFor;                                                                                 //SJ01

      // Write remaining blank records upto 250
   for I = Rrn to 250;
      S1SeqNo   += 10;
      H_SeqNo   = S1SeqNo;
      S1LibName = *blanks;
      Rrn += 1;
      write Sfl01;
   endfor;

   EndIf;                                                       //0002

   //Clear Program Messages if no change in lib list            //SJ01
   If Ind_NoChgLibList = *On or w_Lock;                         //0002
     exsr RemoveMessageFromProgramQ;                            //SJ01
   EndIf;                                                       //SJ01

   if w_Lock;                                                                           //0002
      WkMessageID = 'MSG0145';                                                          //0002
      MessageData = p_Xref;                                                             //0002
      exsr SendMessageToProgramQ;                                                       //0002
   endif;                                                                               //0002
   exsr Sr_UpdateSequence;
                                                                                        //0002
EndSr;
//------------------------------------------------------------------------------------- //
//Load the data from IFS to file
//------------------------------------------------------------------------------------- //
BegSr Sfl_Load_IFS;

      I = 0;
      lst_seq = -1;
      w_repositoryStatus = *blanks;

      Exec sql
           Select CRT_BYUSER,  IS_MD_BUILT
           Into  :w_CrtUser , :w_Built
           From   IaInpLib
           Where  Xref_Name = trim(:p_Xref)
           Limit 1;

      If sqlCode = successCode;
         uDpsds.JobUser = w_CrtUser;
      Endif;

      If w_Built <> *blanks;
         w_repositoryStatus = 'L';
      Endif;

      If w_Built = 'P';
         w_Lock = *on;
         Ind_errorFlag = *On;
         Ind_NoChgLibList = *On;
      Endif;

      If w_Built <> 'P';
         Exec sql
              Delete from IaInpLib
              Where  Xref_Name      = trim(:p_Xref)
              And    IFS_Location  <> '  '        ;

         If sqlCode   < successCode  ;
            uDpsds.wkQuery_Name = 'Delete_IFS_IAINPLIB';
            IaSqlDiagnostic(uDpsds)  ;
         Endif;

         For i = 1 to 250;
            // Write 1st Record as Blank
            If Rrn2      = *Zeros ;
               Rrn2      =  1     ;
               S1DirName = *Blanks;
                       J =  1     ;
               Write Sfl02;
            Endif;

            If RecordIFS(i)  <> *blanks;
               clear S1SeqNo;

               S1SeqNo    = J*10;
               S1DirName  = %trim(RecordIFS(i)) ;

                J        += 1   ;
               Rrn2      += 1   ;
               W_Count    = RRN2;

               Arr_IFSPath_Repo(RRN2) = %trim(RecordIFS(i));

               InsertInpLib = 'Y';
               Dow InsertInpLib = 'Y';

                   Exsr CheckRepositoryProcessed;
                   If w_Lock           = *On ;
                      Ind_errorFlag    = *On ;
                      Ind_NoChgLibList = *On ;
                      Leave;
                   EndIf;
                   for S1Seqno = 10 by 10 to 2500;
                      Clear w_SEQNUM ;                                                     //0006
                      Exec Sql                                                             //0006
                        Select 'Y' INTO :w_SEQNUM                                          //0006
                        From   IaInpLib                                                    //0006
                        where  XREF_NAME = :P_XREF and                                     //0006
                           LIBRARY_SEQNO = :S1SeqNo;                                       //0006
                      if SQLCODE = 100;
                         leave;
                      endif;
                   endfor;

                   Exec Sql
                        Insert into
                        IaInpLib    ( Xref_Name         ,
                                      IFS_Location      ,
                                   // IFS_SeqNo         ,
                                      Library_Seqno     ,
                                      Is_Md_Built       ,
                                      Crt_ByUser        ,
                                      Crt_ByPgm         ,
                                      Description       )
                        Values (trim(:p_Xref   )        ,
                                trim(:S1DirName)        ,
                                trim(:S1SeqNo  )        ,
                                     :w_repositoryStatus,
                                trim(:uDpsds.JobUser)   ,
                                trim(:uDpsds.SrcMbr )   ,
                                trim(:w_desc))          ;

                   If sqlCode   < successCode    ;
                      uDpsds.wkQuery_Name = 'Insert_IFS_IAINPLIB' ;
                      IaSqlDiagnostic(uDpsds)    ;
                      Clear Command              ;
                      command   = 'DLYJOB DLY(1)';
                      Runcommand(Command:Uwerror);
                   Else;
                      InsertInpLib   =   'N'     ;
                   Endif;
               Enddo;

               If Rrn2 > 9999 ;
                  leave;
               Endif;

               Write Sfl02;

            EndIf;

         EndFor;

         // Write remaining blank records upto 250
         For I = Rrn2 to 250     ;
             H_SeqNo    = S1SeqNo;
             S1DirName  = *Blanks;
             Rrn2      += 1      ;
             Write Sfl02 ;
         Endfor;

      EndIf;

      //Clear Program Messages if no change in lib list
      If Ind_NoChgLibList = *On or w_Lock;
        exsr RemoveMessageFromProgramQ;
      EndIf;

      If w_Lock;
         WkMessageID = 'MSG0145'   ;
         MessageData =  p_Xref     ;
         exsr SendMessageToProgramQ;
      Endif;
      exsr Sr_UpdateSequence;

EndSr;
//------------------------------------------------------------------------------------- //
//CheckRepositoryProcessed;
//------------------------------------------------------------------------------------- //
begsr CheckRepositoryProcessed;                                                          //0002

   w_Lock = *off;                                                                        //0002
   w_Built = *blanks;                                                                    //0002

   exec sql                                                                              //0002
      select XMDBuilt into :w_Built                                                      //0002
     // from #iadta/IaInpLib                                                       //0003//0002
      from IaInpLib                                                                      //0003
      where Xref_Name = :p_Xref limit 1;                                                 //0002
                                                                                         //0002
   if w_Built = 'P';
      w_Lock = *on;                                                                      //0002
      Ind_errorFlag = *On;                                                               //0002
   endif;                                                                                //0002

endsr;                                                                                   //0002

//------------------------------------------------------------------------------------ //
//Subfile Display :                                                                    //
//------------------------------------------------------------------------------------ //
BegSr Sfl_Display;

   c1RepoName = p_xref;

   dow Exit = *off;

      SflDsp    = *on;
      SflDspCtl = *on;
      SflEnd    = *on;

      //Handle empty subfile
      if Rrn < 1;
         SflDsp = *off;
      endif;

      //Handle cursor position
    //if CsrRrn > 0;                                                 //MD01
      If CsrRrn > 0 and Ind_errorFlag = *On;                         //MD01
         DspRec = CsrRrn;
      else;
         DspRec = 1;
      endif;

      write Footer;
      write MsgSflCtl;
      exfmt SflCtl01;
      Ind_ErrorFlag = *off;                                        //MD01
      Ind_ChangeRec = *off;                                        //MD01
      Ind_ChgliblFlag = *off;                                      //MD01

      exsr RemoveMessageFromProgramQ;

      select;
      when Exit = *on or Cancel = *on;
         exsr EndPgm;

      when Refresh = *on;

         Refresh   = *off;
         SflNxtChg = *off;
         Ind_LibPC = *off;
         Ind_Refresh = *on;

         exsr Sfl_Clear;
         exsr Sfl_Load;

      when SwitchOpt = *On;                                                                //0005
           Exsr Sr_AddIFSDirectory ;                                                       //0005

      when PressedKey = EnterKey;
         clear PressedKey;

         Ind_UpdRecord = *Off;
         exsr Get_Edit_Library_list;

         if (Ind_ErrorFlag = *off and Ind_ChgliblFlag = *off);

            exsr RemoveMessageFromProgramQ;
            exsr EndPgm;

         endif;

      endsl;

      if (Ind_ErrorFlag = *off and Ind_ChgliblFlag = *off) and
         Ind_ChangeRec = *off;
         exsr RemoveMessageFromProgramQ;
         if Ind_Refresh = *off;
            exsr EndPgm;
         endif;
         Ind_Refresh = *off;
      endif;

      Clear Ind_Upd;                                        //SJ01
      if (Ind_ErrorFlag = *off and Ind_ChgliblFlag = *on);
         Ind_ChgliblFlag = *off;
         Ind_LibPC = *off;
         Ind_Upd = *On;                                      //SJ01
         exsr UpdateRecord;
         exsr Sfl_Clear;
         exsr Sfl_Load_Arr;
      endif;

   enddo;

EndSr;

//------------------------------------------------------------------------------------ //0005
//sr_AddIFSDirectory                                                                   //
//------------------------------------------------------------------------------------ //
BegSr Sr_AddIFSDirectory ;

      Exsr Sfl2_Clear    ;
      Exsr Sfl2_Load     ;
      Exsr Sfl2_Display  ;

EndSr ;
//------------------------------------------------------------------------------------ //
//Subfile Clear :-                                                                     //
//------------------------------------------------------------------------------------ //
BegSr Sfl2_Clear;

      If Ind_Upd = *Off;
         exsr RemoveMessageFromProgramQ;
      EndIf;

      Clear    H_ERR   ;
      Rrn2   = *Zeros  ;
      SflClr = *On     ;
      Write    SflCtl02;
      SflClr = *Off    ;

EndSr;

//------------------------------------------------------------------------------------ //
//Subfile Load :-                                                                      //
//------------------------------------------------------------------------------------ //
BegSr Sfl2_Load;

        I     =  0;
      lst_seq = -1;
      exec sql
           Declare LoadIFSDtl cursor for
         //Select IFS_SeqNo , IFS_Location                                               //0005
           Select Library_SeqNo , IFS_Location                                           //0005
           From   IaInpLib
           Where  Xref_Name    =  trim(:p_xref)
           And    IFS_Location <> ' '
         //Order  by IFS_SeqNo ;                                                         //0005
           Order  by Library_SeqNo ;                                                     //0005

      exec sql open LoadIFSDtl ;
      if sqlCode = CSR_OPN_COD;
         exec sql close LoadIFSDtl ;
         exec sql open  LoadIFSDtl ;
      endif;

      if sqlCode < successCode;
         uDpsds.wkQuery_Name = 'Open_LoadIFSDtl';
         IaSqlDiagnostic(uDpsds);
      endif;

      if sqlCode = successCode;
         exec sql Fetch next from LoadIFSDtl
                  Into :w2_SeqNo2  ,
                       :w2_IfsDirNm;

         if sqlCode < successCode;
            uDpsds.wkQuery_Name = 'Fetch_1_LoadIFSDtl';
            IaSqlDiagnostic(uDpsds);
         endif;

         // Write 1st Record as Blank
         If Rrn2 = 0;
            Rrn2      = 1      ;
            S1DirName = *blanks;
            Write       Sfl02  ;
         Endif;

         If w2_IfsDirNm <> *blanks;
            Dow sqlCode = successCode;
                clear H_SeqNo;

                S1DirName  = %trim(w2_IfsDirNm);

                H_SeqNo    = w2_SeqNo2 ;
                H_DirName  = %trim(S1DirName) ;
                lst_seq    = w2_SeqNo2 ;

                Rrn2      += 1    ;
                Arr_IFSPath_Repo(Rrn2) = %trim(S1DirName);
                W_Count    = Rrn2 ;

                If Rrn2 > 9999 ;
                   leave;
                Endif;

                Write Sfl02 ;

                Exec sql Fetch next from LoadIFSDtl
                         Into :w2_SeqNo2  ,
                              :w2_IfsDirNm;

                If sqlCode < successCode;
                   uDpsds.wkQuery_Name = 'Fetch_2_LoadIFSDtl';
                   IaSqlDiagnostic(uDpsds);
                   leave;
                Endif;
            Enddo;

            Exec sql close LoadIFSDtl ;
            clear w2_IfsDirNm ;

         Endif;

         // Write remaining blank records upto 250
         For I = Rrn2 to 250  ;
             S1DirName  = *Blanks;
             H_SeqNo   += 10  ;
             Rrn2      += 1   ;

             Write Sfl02;
         Endfor;

      Endif;

EndSr;

//------------------------------------------------------------------------------------ //
//Subfile Display :                                                                    //
//------------------------------------------------------------------------------------ //
BegSr Sfl2_Display;

      c1RepoName = p_xref;

      Dow Exit = *off;

          SflDsp    = *on;
          SflDspCtl = *on;
          SflEnd    = *on;

          // Handle empty subfile
          If Rrn2   <  1   ;
             SflDsp = *Off ;
          Endif;

          // Handle cursor position
          If CsrRrn        >  0   And
             Ind_errorFlag = *On  ;
             DspRec        =  CsrRrn;
          Else;
             DspRec   = 1 ;
          Endif;

          Write Footer2   ;
          Write MsgSflCtl ;
          Exfmt SflCtl02  ;

          Ind_ErrorFlag   = *Off ;
          Ind_ChangeRec   = *Off ;
          Ind_ChgIFSFlag  = *Off ;

          exsr RemoveMessageFromProgramQ;

         Select;
            When Exit   = *On  Or
                 Cancel = *On  ;
                 exsr   EndPgm ;
                 Cancel = *Off ;

            When Refresh     = *On ;

                 Refresh     = *Off;
                 SflNxtChg   = *Off;
                 Ind_IFSPC   = *Off;
                 Ind_Refresh = *On ;

                 Exsr   Sfl2_Clear ;
                 Exsr   Sfl2_Load  ;

            When SwitchOpt   = *On ;

                 exsr Sfl_Clear    ;
                 exsr Sfl_Load     ;
                 exsr Sfl_Display  ;

            When PressedKey = EnterKey;
                 clear PressedKey;

                 Ind_UpdRecord  =  *Off ;
                 exsr Get_Edit_IFS_list ;

                 If (Ind_ErrorFlag   = *Off  And
                     Ind_ChgIFSFlag  = *Off );
                     exsr RemoveMessageFromProgramQ ;
                     exsr EndPgm ;
                 Endif;

                 Clear Ind_Upd;
                 If (Ind_ErrorFlag  = *Off And
                    Ind_ChgIFSFlag  = *On) ;

                    Ind_ChgIFSFlag  = *Off;
                    Ind_IFSPC       = *Off;
                    Ind_Upd         = *On;

                    exsr UpdateIFSRecord ;
                    exsr Sfl2_Clear      ;
                    exsr Sfl_Load_IFS    ;
                 Endif;
         Endsl;

      Enddo ;

EndSr;
                                                                                        //0005
//------------------------------------------------------------------------------------ //
//Get_Edit_IFS_list                                                                    //
//------------------------------------------------------------------------------------ //
BegSr Get_Edit_IFS_list ;

      Readc Sfl02;

      If Rrn2 = *zero  ;
         Exsr   EndPgm ;
      Endif;

      Dow not %Eof();
          SflNxtChg      =  *On  ;
          Ind_ChangeRec  =  *On  ;
          Exsr Get_ChangeIFSDir  ;

          Update  Sfl02 ;

          If Ind_errorFlag = *On ;
             Leave ;
          EndIf;
          Readc   Sfl02 ;
      Enddo;

      //Check Duplicates
      If Ind_errorFlag = *Off;
         ExSr Check_Duplicate_IFS_Path;
      EndIf;

      If Ind_errorFlag = *On;
         SflNxtChg = *On;
      Else;
         SflNxtChg = *off;
      EndIf;
EndSr;

//------------------------------------------------------------------------------------ //
//Get_Changed IFS Path                                                                 //
//------------------------------------------------------------------------------------ //
BegSr Get_ChangeIFSDir;

      exsr Indicatorsoff;

      Ind_ChgIFSFlag  = *on;

      If S1DirName <> *Blanks   ;

         w_count   = *Zero ;
         Exec sql
              Select count(*)
              Into  :w_Count
              From   TABLE(QSYS2.IFS_OBJECT_STATISTICS
                     (Trim(:S1DirName),'YES','*ALLSTMF'));

         If w_count       = *Zero        ;

            Ind_ErrorFlag = *On          ;
            Ind_IFSPC     = *On          ;
            WkMessageID   = 'MSG0203'    ;
            MessageData   =  S1DirName   ;
            exsr SendMessageToProgramQ   ;
         EndIf;
      EndIf;

EndSr;
//------------------------------------------------------------------------------------ //
//Get_Edit_Library_list                                                                //
//------------------------------------------------------------------------------------ //
BegSr Get_Edit_Library_list;

   readc Sfl01;

   if Rrn = *zero;
      exsr EndPgm;
   endif;

   clear Arr_Library_Scrn;
   dow not %eof();
      SflNxtChg = *on;
      w_LibName = %trim(S1LibName);

      If H_Err = 1;                                              //SJ01
         Clear H_Err;                                            //SJ01
      EndIf;                                                     //SJ01

      Ind_ChangeRec = *on;
      exsr Get_ChangeLibrary;


      update Sfl01;
      lst_seq = S1SeqNo;                                        //SJ01
      readc Sfl01;

   enddo;

   Ind_errorFlag = *Off;
   //SJ01 for i = 1 to 250;
   for i = 1 to 251;                                            //SJ01
      chain i SFL01;
      //SJ01 If %Found And H_ErrFlag = *On;
      If %Found And H_Err = 1;                  //SJ01
         Ind_errorFlag = *On;
         SflNxtChg = *on;                       //SJ01
         Ind_LibPC = *on;                       //SJ01
         update Sfl01;                          //SJ01
         Leave;                                 //SJ01
      EndIf;

   EndFor;
   //Check Duplicates                                                                  //SJ01
   If Ind_errorFlag = *Off;                                                             //SJ01
      ExSr Check_Duplicate_Lib2;                                                        //SJ01
   EndIf;                                                                               //SJ01
   If Ind_errorFlag = *On;
      SflNxtChg = *On;
   Else;
      SflNxtChg = *off;
   EndIf;

EndSr;

//------------------------------------------------------------------------------------ //
//sr_filterAndValidate                                                                 //
//------------------------------------------------------------------------------------ //
BegSr sr_filterAndValidate;
EndSr;


//------------------------------------------------------------------------------------ //
//Get_ChangeLibrary                                                                    //
//------------------------------------------------------------------------------------ //
BegSr Get_ChangeLibrary;

   exsr Indicatorsoff;

   Ind_ChgliblFlag = *on;

   Select;
   when (S1SeqNo <> H_SeqNo) and (w_LibName <> *blanks) and
       RRN>1 and(S1SeqNo = *zero);
      S1SeqNo = H_SeqNo;
      //SJ01 exsr Check_Duplicate_Lib;                         //SJ01
      exsr Check_Library_In_System;                     //SJ01
      exsr Check_Library_From_Repository;               //SJ01
   When (S1SeqNo <> H_SeqNo) and (w_LibName = H_LibName) and
      (S1SeqNo <> *zero)   and (w_LibName <> *blanks);
      W_Count -= 1;
      Ind_UpdRecord = *On;
      // Exsr UpdateRecord;
   when (S1SeqNo = H_SeqNo) and (w_LibName <> H_LibName) and
        (w_LibName <> *blanks) and RRN > 1;
      // SJ01 exsr Check_Duplicate_Lib;
      exsr Check_Library_In_System;
      Exsr Check_Library_From_Repository;
      // Exsr UpdateRecord;
   when (w_LibName = *blanks and S1SeqNo = H_SeqNo);
      W_Count -= 2;
      Ind_UpdRecord = *On;
      // Exsr UpdateRecord;
   Other;

      if w_LibName <> *blanks and S1SeqNo <> *zero and S1SeqNo <> H_SeqNo;
         // SJ01 exsr Check_Duplicate_Lib;
         exsr Check_Library_In_System;
         exsr Check_Library_From_Repository;
      endIf;

      If S1SeqNo = *Zeros and Ind_ErrorFlag = *off and  w_LibName = *blanks;
         //SJ01 S1SeqNo = lst_seq + 10;
         S1SeqNo = H_SeqNo;                                                                 //SJ01
      Endif;
      if w_LibName <> *blanks and S1SeqNo = *zero;
         //SJ01 exsr Check_Duplicate_Lib;
         exsr Check_Library_In_System;
         exsr Check_Library_From_Repository;
      endIf;
   EndSl;

   H_ErrFlag = Ind_ErrorFlag ;
   If H_ErrFlag = *On;                                  //SJ01
      H_Err = 1;                                        //SJ01
      Ind_LibPC = *on;                                  //SJ01
   EndIf;                                               //SJ01
EndSr;
//------------------------------------------------------------------------------------ //
//UpdateRecord :-                                                                      //
//------------------------------------------------------------------------------------ //
BegSr UpdateRecord;

   if Ind_ErrorFlag = *on;
      leavesr;
   endif;

   J = 0;
   clear Record;
   //SJ01 for i = 1 to 250;
   for i = 1 to 251;                                            //SJ01
      chain i SFL01;                                            //SJ01
      If %Found ;
         If S1LibName <> *Blanks ;
            J = J +1;
            Record(j).SeqNo = S1SEQNO;
            Record(j).Library = S1LIBNAME;
         EndIf;
      EndIf;
   EndFor;

   If W_Count > 0;
      //SJ01 Sorta %Subarr(Record(*).SeqNo : 1 : W_Count);
      Sorta %Subarr(Record(*).SeqNo : 1 : J);              //SJ01
   Else;
      Sorta %Subarr(Record(*).SeqNo : 1 : j);
   EndIf;

   if (Record(1).Library = *blanks);
      //SJ01 for i = 1 to 249;
      for i = 1 to 250;                                          //SJ01
         Record(i).Library = Record(i+1).Library;
         Record(i).SeqNo =  Record(i+1).SeqNo;
      endfor;
   else;
     J = 0;
     //SJ01 for i = 1 to 250;
     for i = 1 to 251;                                          //SJ01
        J = J + 1;

        If (Record(i).Library <> *Blanks );
           Record(J).SeqNo = 10 * j ;
        EndIf;

     endFor;

   endif;
   WkMessageID = 'MSG0069';
   MessageData = *blanks;
   exsr SendMessageToProgramQ;

EndSr;
//------------------------------------------------------------------------------------ //
//Update IFS Record :-                                                                 //
//------------------------------------------------------------------------------------ //
BegSr UpdateIFSRecord;

      J = 0;
      Clear RecordIFS ;
      For i = 1 to 251;
          Chain i SFL02;
          If %Found ;
             If S1DirName  <> *Blanks ;
                J = J +1 ;
                RecordIFS(J) = S1DirName ;
             EndIf;
         EndIf;
      EndFor;

      WkMessageID = 'MSG0205';
      MessageData = *blanks;
      exsr SendMessageToProgramQ;

EndSr;
//------------------------------------------------------------------------------------ //SJ01
//Check_Duplicate_Lib2                                                                 //SJ01
//------------------------------------------------------------------------------------ //SJ01
BegSr Check_Duplicate_Lib2;                                                             //SJ01
   Clear W_Arr_Library_Scrn;                                                            //SJ01
   Ind_Nolib = *On;                                                                     //SJ01
   //SJ01 for i = 1 to 250;                                                             //SJ01
   for i = 1 to 251;                                             //SJ01                 //SJ01
      chain i SFL01;                                                                    //SJ01
      If %Found ;                                                                       //SJ01
         If S1LibName <> *Blanks ;                                                      //SJ01
            Ind_Nolib = *Off;                                                           //SJ01
            If  %LookUp ( %trim(S1LibName) : W_Arr_Library_Scrn ) > 0;                  //SJ01
               Ind_errorFlag = *On;                                                     //SJ01
               Ind_LibPC = *on;                                                         //SJ01
               update Sfl01;                                                            //SJ01
               WkMessageID = 'MSG0071';                                                 //SJ01
               MessageData = %trim(S1LibName);                                          //SJ01
               exsr SendMessageToProgramQ;                                              //SJ01
               leave;                                                                   //SJ01
            Else;                                                                       //SJ01
               W_Arr_Library_Scrn(i) = %trim(S1LibName);                                //SJ01
            EndIf;                                                                      //SJ01
         EndIf;                                                                         //SJ01
      EndIf;                                                                            //SJ01
   EndFor;                                                                              //SJ01
//In case of No lib input, display error                                               //SJ01
   If Ind_nolib = *On;                                                                  //SJ01
      Ind_errorFlag = *On;                                                              //SJ01
      update Sfl01;                                                                     //SJ01
      WkMessageID = 'MSG0070';                                                          //SJ01
      MessageData = %trim(S1LibName);                                                   //SJ01
      exsr SendMessageToProgramQ;                                                       //SJ01
   EndIf;                                                                               //SJ01
EndSr;                                                                                  //SJ01
//------------------------------------------------------------------------------------ //0005
//Check_Duplicate_IFS Path.                                                            //
//------------------------------------------------------------------------------------ //
BegSr Check_Duplicate_IFS_Path;                                                         //

      Clear Arr_IFSPath_Scrn;
      Ind_NoIfsD = *On      ;

      For i = 1 to 251;
          Chain i SFL02;
          If %Found ;
             If S1DirName <> *Blanks ;
                If (%LookUp (S1DirName : Arr_IFSPath_Scrn) > 0) ;

                    Ind_ErrorFlag = *On       ;
                    Ind_IFSPC     = *On       ;
                    WkMessageID   = 'MSG0204' ;
                    MessageData   = S1DirName ;
                    Exsr SendMessageToProgramQ;
                    Update   SFL02            ;
                    Leavesr;
                Else;
                    Arr_IFSPath_Scrn(Rrn2) = S1DirName ;
                Endif;
             Ind_NoIfsD = *Off ;
             Endif;
          Endif;
      EndFor;

   w_count   = *Zero ;
   Exec sql
        Select count(*)
        Into  :w_Count
        From   IaInpLib
        Where  XREF_NAME = :P_XREF
        And    XLIBNAM  <> ' '    ;

//In case of No IFS Dir input, display error
   If Ind_NoIfsD    = *On       And
      w_count       = *Zeros    ;

      Ind_ErrorFlag = *On       ;
      Ind_IFSPC     = *On       ;
      WkMessageID   = 'MSG0206' ;
      MessageData   = S1DirName ;
      Exsr SendMessageToProgramQ;
      Update   Sfl02;
      Leavesr;
   EndIf;
EndSr;
//------------------------------------------------------------------------------------ //
//Check_Duplicate_Lib                                                                  //
//------------------------------------------------------------------------------------ //
BegSr Check_Duplicate_Lib;

   if Ind_ErrorFlag = *on;
      leavesr;
   endif;

   if ( ( %LookUp ( W_libName : Arr_Library_Repo ) > 0 ) Or
        ( %LookUp ( W_libName : Arr_Library_Scrn ) > 0 )
      ) And W_LibName <> *Blanks ;

      Ind_ErrorFlag = *on;
      Ind_LibPC = *on;
      WkMessageID = 'MSG0071';
      MessageData = w_LibName;
      exsr SendMessageToProgramQ;
      leavesr;
   Else;
      Arr_Library_Scrn(RRN) = W_LibName ;
   endif;

EndSr;

//------------------------------------------------------------------------------------ //
//Check_Library_In_System : Check library exists in AS400                              //
//------------------------------------------------------------------------------------ //
BegSr Check_Library_In_System;

   if Ind_ErrorFlag = *on;
      leavesr;
   endif;

   if w_LibName <> *blanks;
      clear command;
      command = 'CHKOBJ OBJ(QSYS/'+%trim(w_LibName)+') OBJTYPE(*LIB)';
      RunCommand(Command:Uwerror);

      if Uwerror = 'Y';
         Ind_ErrorFlag = *on;
         Ind_LibPC = *on;
         WkMessageID = 'MSG0072';
         MessageData = w_LibName;
         exsr SendMessageToProgramQ;
      endif;

   endif;

EndSr;

//------------------------------------------------------------------------------------ //
//Check_Library_From_Repository :- Library exists in another repository                //
//------------------------------------------------------------------------------------ //
BegSr Check_Library_From_Repository;

   if Ind_ErrorFlag = *on;
      leavesr;
   endif;

   exec sql
     select count(1)
       into :w_Count1
     //  from #IADTA/IaInpLib                                                           //0003
       from IaInpLib                                                                    //0003
      where Xref_Name = :w_LibName;

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'select_Count_3_IAINPLIB';
      IaSqlDiagnostic(uDpsds);                                                           //0004
   endif;

   if w_Count1 > 0;
      Ind_ErrorFlag = *on;
      Ind_LibPC = *on;
      WkMessageID = 'MSG0111';
      MessageData = w_LibName;
      if sav_msgId = *blanks and sav_msgDta = *blanks;
         sav_msgId  = WkMessageID;
         sav_msgDta = MessageData;
         sav_errRrn = rrn;
      endIf;
      exsr SendMessageToProgramQ;
      leavesr;
   endif;

EndSr;

//------------------------------------------------------------------------------------ //
//Indicatorsoff :- clear error flag and remove msg from programQ                       //
//------------------------------------------------------------------------------------ //
BegSr Indicatorsoff;

   Ind_LibPC = *off;
   Ind_IFSPC = *off;
   Ind_ErrorFlag = *off;
   //SJ01 exsr RemoveMessageFromProgramQ;

EndSr;

//------------------------------------------------------------------------------------ //0006
//Check for Library Record :-                                                          //0006
//------------------------------------------------------------------------------------ //0006
BegSr Sr_UpdateSequence;                                                                //0006
                                                                                        //0006
   Clear w_SEQNUM;                                                                      //0006
   Exec Sql                                                                             //0006
      Select 'Y' Into :w_SEQNUM From IAINPLIB                                           //0006
      where XREF_NAME = :P_XREF                                                         //0006
      fetch first row only;
   if w_Seqnum = 'Y' and SQLCODE = 0;                                                   //0006
      Exec Sql                                                                          //0006
         Declare LibCsr Cursor for                                                      //0006
         Select Library_Seqno, Library_Name,IFS_Location From IAINPLIB                  //0006
         where XREF_NAME = :P_XREF order by Library_seqno;                              //0006
      Exec Sql Open LibCsr;                                                             //0006
      Exec Sql Fetch from Libcsr for 502 Rows Into :INPRecord;                          //0006
      w_count = SqlErrD(3);                                                             //0006
      Exec Sql Close LibCsr;                                                            //0006
      if w_count > *zeros;
         Exec Sql Delete from Iainplib where XREF_NAME = :P_XREF;
         for I =1 to w_count;                                                              //0006
            S1seqno   = I * 10;                                                            //0006
            S1LibName = InpRecord(I).LibName;
            S1DirName = InpRecord(I).DirName;
            exec sql                                                                       //0006
               insert into                                                                 //0006
                         IaInpLib (Xref_Name,                                              //0006
                                   Library_Name,
                                   Library_SeqNo,                                          //0006
                                   IFS_Location,
                                   Is_Md_Built,                                            //0006
                                   Crt_ByUser,                                             //0006
                                   Crt_ByPgm,                                              //0006
                                   DESCRIPTION)                                            //0006
                           Values (trim(:p_Xref),                                          //0006
                                   trim(:S1LibName),
                                   trim(:S1SeqNo),                                         //0006
                                   trim(:S1DirName),
                                   :w_repositoryStatus,                                    //0006
                                   trim(:uDpsds.JobUser),                                  //0006
                                   trim(:uDpsds.SrcMbr),                                   //0006
                                   trim(:w_desc));                                         //0006
         endfor;                                                                           //0006
      endif;
                                                                                        //0006
   endif;                                                                               //0006
                                                                                        //0006
EndSr;                                                                                  //0006
//------------------------------------------------------------------------------------ //
//SendMessageToProgramQ :- Send message to programQ                                    //
//------------------------------------------------------------------------------------ //
BegSr SendMessageToProgramQ;

   MessageLen = %len(%trim(MessageData));
   callp  SendMessage(WkMessageID:
                      MessageFile:
                      MessageData:
                      MessageLen:
                      MessageType:
                      CallStack:
                      CallStackC:
                      MessageKey:
                      MessageErr);
   WkMessageID   = '';
   MessageData = '';

EndSr;

//------------------------------------------------------------------------------------ //
//RemoveMessageFromProgramQ :- Remove message from ProgramQ                            //
//------------------------------------------------------------------------------------ //
BegSr RemoveMessageFromProgramQ;

   callp  RemoveMessage(CallStack:
                        CallStackC:
                        RMessageKey:
                        RemoveCode:
                        MessageErr);

EndSr;

//------------------------------------------------------------------------------------ //
//RemoveMessageFromProgramQ :- Remove message from ProgramQ                            //
//------------------------------------------------------------------------------------ //
BegSr Endpgm;

   *inlr = *on;
   return;

EndSr;
