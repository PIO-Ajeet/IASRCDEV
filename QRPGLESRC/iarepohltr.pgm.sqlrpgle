**free
      //%METADATA                                                      *
      // %TEXT IA - DDStoDDL Program For 'DDL Source Creation'         *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------- //
//Created By  : Programmers.io @ 2024                                                   //
//Created Date: 2024/05/31                                                              //
//Developer   : Programmers.io                                                          //
//Description : This program generate the repo's health report                          //
//                                                                                      //
//------------------------------------------------------------------------------------- //
//Procedure Log:                                                                        //
//------------------------------------------------------------------------------------- //
//Procedure Name                | Procedure Description                                 //
//------------------------------|-------------------------------------------------------//
//FetchRecordCursorSourceMember |To fetch source members                                //
//                              |                                                       //
//------------------------------------------------------------------------------------- //
//Modification Log:                                                                     //
//------------------------------------------------------------------------------------- //
//Date-DMY| Mod_ID | Developer  | Case and Description                                  //
//--------|--------|------------|------------------------------------------------------ //
//xx/xx/xx|  0001  |xxxx xxxx   |                                                       //
//04/07/24|  0001  | Vamsi      | Rename Bnddir AIERRBND, copybooks AICERRLOG/AIDERRLOG //
//        |        |            | and procedures AISQLDIAGNOSTIC and AIPSSRERRORLOG     //
//        |        |            | with IA*  [Task#261]                                  //
//16/09/24|  0002  | Gopi Thorat| Rename IACPYBDTL file fields wherever used due to     //
//        |        |            | table changes. [Task#940]                             //
//------------------------------------------------------------------------------------- //
Ctl-Opt CopyRight('Copyright @ Programmers.io © 2024');
Ctl-Opt Option(*NoDebugIo:*SrcStmt:*NoUnRef);
Ctl-Opt BndDir('IABNDDIR' : 'IAERRBND');                                                 //0001

//------------------------------------------------------------------------------------- //
//Standalone Variables
//------------------------------------------------------------------------------------- //
Dcl-S wkSqlText              Char(1000)     Inz;
Dcl-S wkSourceFile           Char(10)       Inz;
Dcl-S wkSourceLibrary        Char(10)       Inz;
Dcl-S wkMemberName           Char(10)       Inz;
Dcl-S wkMemberType           Char(10)       Inz;
Dcl-S wkMemberDesc           Char(50)       Inz;
Dcl-S wkRefreshFlag          Char(10)       Inz;
Dcl-S wkSourceMbrUsed        Char(1)        Inz('N');

Dcl-S wkSrcMbrCount          Packed(4:0)    Inz;

Dcl-S noOfRows               Uns(5)         Inz;
Dcl-S udSourceMemberIdx      Uns(5)         Inz;
Dcl-S RowsFetched            Uns(5)         Inz;

Dcl-S rowFound               Ind            Inz('0');

//------------------------------------------------------------------------------------- //
//Constant Variables
//------------------------------------------------------------------------------------- //
Dcl-C TRUE            '1';
Dcl-C FALSE           '0';

//------------------------------------------------------------------------------------- //
//Datastructure Definitions
//------------------------------------------------------------------------------------- //
//Datastructure for the Source Member details
Dcl-Ds udSourceMember Qualified Dim(999);
   usSourceFile      Char(10);
   usSourceLibrary   Char(10);
   usMemberName      Char(10);
   usMemberType      Char(10);
   usMemberDesc      Char(50);
   usRefreshFlag     Char(1);
End-Ds;

//Datastructure for IAMETAINFO data area
Dcl-Ds IaMetaInfo DtaAra Len(62);
   usMode Char(7) Pos(1);
End-Ds;

//------------------------------------------------------------------------------------- //
//Copybook definitions
//------------------------------------------------------------------------------------- //
/copy 'QCPYSRC/iaderrlog.rpgleinc'

//------------------------------------------------------------------------------------- //
//Entry Parameter Declarations
//------------------------------------------------------------------------------------- //
Dcl-Pr iaRepoHltR ExtPgm('IAREPOHLTR');
   inRepo            Char(10);
End-Pr;

Dcl-Pi iaRepoHltR;
   inRepo            Char(10);
End-Pi;

//------------------------------------------------------------------------------------- //
//Set Options
//------------------------------------------------------------------------------------- //
Exec Sql
   Set Option Commit    = *None,
              Naming    = *Sys,
              UsrPrf    = *User,
              DynUsrPrf = *User,
              CloSqlCsr = *Endmod;

//------------------------------------------------------------------------------------- //
//Mainline Programming
//------------------------------------------------------------------------------------- //
Eval-corr uDpsds = wkuDpsds;

In IaMetaInfo;

//If Process is 'INIT'
If usMode = 'INIT';
   wkSqlText =
      ' Select Source_File, Source_Library, Member_Name, Member_Type,' +
      ' Mbr_Description, Refresh_Flag From iAMember ';

//If Process is 'REFRESH'
ElseIf usMode = 'REFRESH';
   wkSqlText =
      ' Select Source_File, Source_Library, Member_Name, Member_Type,' +
      ' Mbr_Description, Refresh_Flag From iAMember '                  +
      ' Where Refresh_Flag In (''A'' ,''M'')';

EndIf;

//------------------------------------------------------------------------------------- //
//Cursor Declarations
//------------------------------------------------------------------------------------- //
//Declare cursor to select source members
Exec Sql Prepare Memstmt From :wkSqlText ;

Exec Sql Declare CursorSourceMember Cursor For Memstmt;

//------------------------------------------------------------------------------------- //
//Main Processing
//------------------------------------------------------------------------------------- //

//Check for Source Member used or not
ExSr CheckSourceMemberUsedOrNot;

*Inlr = *On;
Return;

//------------------------------------------------------------------------------------- //
//CheckSourceMemberUsedOrNot : To confirm whether source member is used or not
//------------------------------------------------------------------------------------- //
BegSr CheckSourceMemberUsedOrNot;

  //Open the cusror
  Exec Sql Open CursorSourceMember;

  If SqlCode = CSR_OPN_COD;
     Exec Sql Close CursorSourceMember;
     Exec Sql Open  CursorSourceMember;
  EndIf;

  If sqlCode < successCode;
     uDpsds.wkQuery_Name = 'open_CursorSourceMember';
     IaSqlDiagnostic(uDpsds);                                                            //0001
  EndIf;

  //Get the number of elements
  noOfRows = %elem(udSourceMember);

  //Fetch records from CursorSourceMember
  rowFound = FetchRecordCursorSourceMember();

  Dow rowFound;

     For udSourceMemberIdx = 1 To RowsFetched;

        wkSourceFile    = udSourceMember(udSourceMemberIdx).usSourceFile;
        wkSourceLibrary = udSourceMember(udSourceMemberIdx).usSourceLibrary;
        wkMemberName    = udSourceMember(udSourceMemberIdx).usMemberName;
        wkMemberType    = udSourceMember(udSourceMemberIdx).usMemberType;
        wkMemberDesc    = udSourceMember(udSourceMemberIdx).usMemberDesc;
        wkRefreshFlag   = udSourceMember(udSourceMemberIdx).usRefreshFlag;

        WkSrcMbrCount = 0;

        //Check if source member is compiled/object created in IAOBJMAP
        Exec Sql
          Select Count(*) Into :WkSrcMbrCount
            From iAObjMap
           Where IaMbrLib  = :wkSourceLibrary
             And IaMbrSrcF = :wkSourceFile
             And IaMbrNam  = :wkMemberName ;

        //If source member is not compiled/object created, then check if used as CopyBook
        If WkSrcMbrCount = 0;
           Exec Sql
             Select Count(*) Into :WkSrcMbrCount
               From IaCpybDtl
              Where iACpyLib   = :wkSourceLibrary                                        //0002
                And iACpySrcPf = :wkSourceFile                                           //0002
                And iACpyMbr   = :wkMemberName ;                                         //0002
        EndIf;

        //If source member not used at all, then capture in IAGENAUDTP file
        If WkSrcMbrCount = 0;

           Select;
              When usMode = 'INIT';

                 exsr insertIntoAuditFile;

              When usMode = 'REFRESH';

                 If wkRefreshFlag = 'A';
                    exsr insertIntoAuditFile;
                 ElseIf wkRefreshFlag = 'M';
                    exsr updateAuditFile;
                 EndIf;

           EndSl;

        EndIf;

     EndFor;

     //if fetched rows are less than the array elements then come out of the loop.
     If RowsFetched < noOfRows ;
        Leave ;
     EndIf ;

     //Fetch records from CursorSourceMember
     rowFound = FetchRecordCursorSourceMember();

  EndDo;

  //Close cursor
  Exec Sql Close CursorSourceMember;

EndSr;

//------------------------------------------------------------------------------------- //
//insertIntoAuditFile : To capture member details which are not used
//------------------------------------------------------------------------------------- //
BegSr insertIntoAuditFile;

  Exec Sql
     Insert Into iAGenAudtP (UniqueCode,
                             iADesText ,
                             iAMbrLib  ,
                             iAMbrSrcPf,
                             iAMbrName ,
                             iAMbrType ,
                             iAMbrObjd ,
                             CrtUser   ,
                             CrtPgm    )
                     values ('UnusedSrc',
                             'Neither Object found, nor a copybook',
                             :wkSourceLibrary,
                             :wkSourceFile,
                             :wkMemberName,
                             :wkMemberType,
                             :wkMemberDesc,
                             :uDpsds.User ,
                             'IAREPOHLTR' );

  If SqlCode < SuccessCode;
     uDpsds.wkQuery_Name = 'Insert_Iagenaudtp';
     IaSqlDiagnostic(uDpsds);                                                            //0001
  EndIf;

EndSr;

//------------------------------------------------------------------------------------- //
//updateAuditFile : To update the change details
//------------------------------------------------------------------------------------- //
BegSr updateAuditFile;

  Exec Sql
     Update iAGenAudtP set ChgUser = :uDpsds.User, ChgPgm = 'IAREPOHLTR'
        Where UniqueCode = 'UnusedSrc'
          And iAMbrLib   = :wkSourceLibrary
          And iAMbrSrcPf = :wkSourceFile
          And iAMbrName  = :wkMemberName
          And iAMbrType  = :wkMemberType ;

  If SqlCode < SuccessCode;
     uDpsds.wkQuery_Name = 'Update_Iagenaudtp';
     IaSqlDiagnostic(uDpsds);                                                            //0001
  EndIf;

EndSr;

//------------------------------------------------------------------------------------- //
//Procedure FetchRecordCursorSourceMember : To fetch Source Members
//------------------------------------------------------------------------------------- //
Dcl-Proc FetchRecordCursorSourceMember;

  Dcl-Pi FetchRecordCursorSourceMember Ind End-Pi ;

  Dcl-S  rcdFound Ind Inz('0');
  Dcl-S  wkRowNum Like(RowsFetched) ;

  RowsFetched = *zeros;
  Clear udSourceMember;

  Exec Sql
    Fetch CursorSourceMember For :noOfRows Rows Into :udSourceMember;

  If sqlCode < successCode;
     uDpsds.wkQuery_Name = 'Fetch_CursorSourceMember';
     IaSqlDiagnostic(uDpsds);                                                            //0001
  EndIf;

  If sqlcode = successCode;
     Exec Sql Get Diagnostics
         :wkRowNum = ROW_COUNT;
         RowsFetched  = wkRowNum ;
  EndIf;

  If RowsFetched > 0;
     rcdFound = TRUE;
  ElseIf sqlcode < successCode ;
     rcdFound = FALSE;
  EndIf;

  Return rcdFound;

End-Proc;

