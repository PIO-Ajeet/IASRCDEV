**free
      //%METADATA                                                      *
      // %TEXT IA - DDStoDDL Archive Program                           *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------- //
//Created By  : Programmers.io @ 2024                                                   //
//Created Date: 2024/11/21                                                              //
//Developer   : Piyush Kumar                                                            //
//Description : This program Archive the DDS to DDL Header and Conversion Details File  //
//                                                                                      //
//                       Input Parameters:                                              //
//              inReqId          -  Request Id                                          //
//              inRepo           -  Repo Name                                           //
//             inDDSObjNam      -  DDS Object Name                                     //
//             inDDSLibrary     -  DDS Object Library                                  //
//              inDDSObjAttr     -  DDS Object Attribute                                //
//              inDDLMbrNam      -  DDL Member Name                                     //
//              inDDLMbrLib      -  DDL Member Library                                  //
//              inDDLObjNam      -  DDL Object Name                                     //
//              inDDLObjLib      -  DDL Object Library                                  //
//              inDDLLngNam      -  DDL Long Name                                       //
//              inReplaceDDL     -  Replace DDL                                         //
//              inIncludeDepFile -  Include Dependent Files                             //
//              inIncludeDepPgm  -  Include Dependent Programs                          //
//              inIncludeAudCols -  Include Audit Columns                               //
//              inIncludeIdCol   -  Include Identity Column                             //
//              inCopyData       -  Copy Data                                           //
//              inRequestedUser  -  Requested User                                      //
//              inEnvLibrary     -  Environment Library                                 //
//                                                                                      //
//                       Ouput Parameters:                                              //
//              outStatus        -  Output Status                                       //
//              outMessage       -  Output Message                                      //
//                                                                                      //
//------------------------------------------------------------------------------------- //
//Procedure Log:                                                                        //
//------------------------------------------------------------------------------------- //
//Procedure Name                    | Procedure Description                             //
//----------------------------------|---------------------------------------------------//
//CheckExistingConversionRequest    | Check the existing Conversion Request             //
//ArchiveHeaderFile                 | Archive the Header file to Header History File    //
//                                  | Details                                           //
//ArchiveConversionFile             | Archive the Coversion File to History Conversion  //
//                                  | Details File                                      //
//DeleteExistingMbrObjs             | Delete the existing members and objects from DDL  //
//                                  | Library                                           //
//UpdateFileDownloadRequest         | Update the File Download Request File             //
//FetchCursorCnvSrcAndCmplObjs      | To fetch converted source & compiled object detail//
//RunCmd                            | To execute the command                            //
//------------------------------------------------------------------------------------- //
//                                                                                      //
//Modification Log:                                                                     //
//------------------------------------------------------------------------------------- //
//Date-DMY| ModID  | Developer  | Case and Description                                  //
//--------|--------|------------|------------------------------------------------------ //
//26/11/24| 0001   |Karthick S  |Task#1067 - Added new field to capture the format level//
//        |        |            |identifier and restructuring sql query for easy        //
//        |        |            |maintainence.                                          //
//26/11/24| 0002   |Piyush Kumar|Task#1072 - Adding new fields DDS file type, member    //
//        |        |            |name and record format name.                           //
//------------------------------------------------------------------------------------- //
Ctl-Opt CopyRight('Copyright @ Programmers.io © 2024');
Ctl-Opt Option(*NoDebugIo:*SrcStmt:*NoUnRef);
Ctl-Opt BndDir('IAERRBND');
Ctl-Opt ActGrp(*Caller);

//------------------------------------------------------------------------------------- //
//Standalone Variables                                                                  //
//------------------------------------------------------------------------------------- //
Dcl-S uwError                Char(1)        Inz;
Dcl-S uwMsgVars              Char(80)       Inz;
Dcl-S uwMsgDesc              Char(1000)     Inz;

Dcl-S uwCmd                  Varchar(1000)  Inz;
Dcl-S uwSqlStmt              Varchar(1024)  Inz;
Dcl-S uwFailRsn              VarChar(255)   Inz;

Dcl-S uiSrcObjIdx            Uns(5)         Inz;
Dcl-S SrcObjRowsFetched      Uns(5)         Inz;
Dcl-S noOfRows               Uns(5)         Inz;

Dcl-S rowFound               Ind            Inz;

//------------------------------------------------------------------------------------- //
//Constant Variables                                                                    //
//------------------------------------------------------------------------------------- //
Dcl-C TRUE            '1';
Dcl-C FALSE           '0';
Dcl-C SQUOTE          '''';
Dcl-C FEATURE         'DDS_TO_DDL_CONVERSION';

//------------------------------------------------------------------------------------- //
//Array Declarations                                                                    //
//------------------------------------------------------------------------------------- //

//------------------------------------------------------------------------------------- //
//Datastructure Definitions                                                             //
//------------------------------------------------------------------------------------- //

//Data Structure of IADDSDDLHP File
Dcl-Ds udHdrDs ExtName('IADDSDDLHP') Qualified End-Ds;

//Datastructure for the existing sources snd objects information
Dcl-Ds udSrcObj Qualified Dim(99);
   usSrcMbr   Char(10);
   usObjName  Char(10);
   usObjType  Char(10);
   usObjAtr   Char(10);
   usObjIdx   Char(10);
End-Ds;

//------------------------------------------------------------------------------------- //
//Prototype Definitions                                                                 //
//------------------------------------------------------------------------------------- //

Dcl-Pr iAGetMsg extpgm('IAGETMSG');
  *n Char(01)     Options(*NoPass) Const;
  *n Char(07)     Options(*NoPass) Const;
  *n Char(1000)   Options(*NoPass)      ;
  *n Char(80)     Options(*NoPass) Const;
End-pr;

//------------------------------------------------------------------------------------- //
//Copybook definitions                                                                  //
//------------------------------------------------------------------------------------- //
/copy 'QCPYSRC/iaderrlog.rpgleinc'

//------------------------------------------------------------------------------------- //
//Entry Parameter Declarations
//------------------------------------------------------------------------------------- //
Dcl-Pr IADDSDDLAP ExtPgm('IADDSDDLAP');
   inReqId           Char(18);
   inRepo            Char(10);
   inDDSObjNam       Char(10);
   inDDSLibrary      Char(10);
   inDDSObjAttr      Char(10);
   inDDLMbrNam       Char(10);
   inDDLMbrLib       Char(10);
   inDDLObjNam       Char(10);
   inDDLObjLib       Char(10);
   inDDLLngNam       Char(128);
   inReplaceDDL      Char(1);
   inIncludeDepFile  Char(1);
   inIncludeDepPgm   Char(1);
   inIncludeAudCols  Char(1);
   inIncludeIdCol    Char(1);
   inCopyData        Char(1);
   inRequestedUser   Char(10);
   inEnvLibrary      Char(10);
   outStatus         Char(1);
   outMessage        Char(80);
End-Pr;

Dcl-Pi iADdsDdlAP;
   inReqId           Char(18);
   inRepo            Char(10);
   inDDSObjNam       Char(10);
   inDDSLibrary      Char(10);
   inDDSObjAttr      Char(10);
   inDDLMbrNam       Char(10);
   inDDLMbrLib       Char(10);
   inDDLObjNam       Char(10);
   inDDLObjLib       Char(10);
   inDDLLngNam       Char(128);
   inReplaceDDL      Char(1);
   inIncludeDepFile  Char(1);
   inIncludeDepPgm   Char(1);
   inIncludeAudCols  Char(1);
   inIncludeIdCol    Char(1);
   inCopyData        Char(1);
   inRequestedUser   Char(10);
   inEnvLibrary      Char(10);
   outStatus         Char(1);
   outMessage        Char(80);
End-Pi;

//------------------------------------------------------------------------------------- //
//Mainline Programming                                                                  //
//------------------------------------------------------------------------------------- //
Exec Sql
   Set Option Commit    = *None,
              Naming    = *Sys,
              UsrPrf    = *User,
              DynUsrPrf = *User,
              CloSqlCsr = *Endmod;

Eval-corr uDpsds = wkuDpsds;

//Initializing outStatus as 'S' and outMessage as Blanks
outStatus   = 'S';
outMessage  = *Blanks;

//DDL Archive Process Completed
iAGetMsg('1':'MSG0220':uwMsgDesc:' ');
outMessage  = %trim(uwMsgDesc);

//------------------------------------------------------------------------------------- //
//Cursor Declarations                                                                   //
//------------------------------------------------------------------------------------- //

//Cursor for Converted DDL/Pgm Sources and Compiled DDL/Pgm Objects of old request id
Exec Sql
   Declare CursorCnvSrcAndCmplObjs Cursor For
    Select iADdlSrcMb, iADdlObjNm,
           iADdlObjTy, iADdlObjAt, iAKeyIdxNm
      From iADdsDdlDP
     Where iAReqID = :udHdrDs.iAReqID;

//------------------------------------------------------------------------------------- //
//Main Processing                                                                       //
//------------------------------------------------------------------------------------- //

//Check the existing Conversion Request
CheckExistingConversionRequest();

//Insert current conversion request in IADDSDDLHP file
Exec Sql
   Insert Into IADDSDDLHP (iAReqId,           iARepoNm,
                           iADdsObjLb,        iADdsObjNm,
                           iADdsObjAt,        iADdlMbrLb,
                           iADdlMbrNm,        iADdlObjLb,
                           iADdlObjNm,        iADdlLngNm,
                           iAReplace,         iAIncDepPg,
                           iAIncDepFl,        iAIncAudCo,
                           iAIncIdnCo,        iACopyData,
                           iAConvSts,         iACrtPgm,
                           iACrtUser)
                   Values (:inReqId,          :inRepo,
                           :inDDSLibrary,     :inDDSObjNam,
                           :inDDSObjAttr,     :inDDLMbrLib,
                           :inDDLMbrNam,      :inDDLObjLib,
                           :inDDLObjNam,      :inDDLLngNam,
                           :inReplaceDDL,     :inIncludeDepPgm,
                           :inIncludeDepFile, :inIncludeAudCols,
                           :inIncludeIdCol,   :inCopyData,
                           'P',               'IADDSDDLRT',
                           :inRequestedUser);

If sqlCode < successCode;
   udPsds.wkQuery_Name = 'Insert_IADDSDDLHP';
   IaSqlDiagnostic(udPsds);
EndIf;

*InLr = *On;

Return;

//------------------------------------------------------------------------------------- //
//CheckExistingConversionRequest : Check the existing Conversion Request                //
//------------------------------------------------------------------------------------- //
Dcl-Proc CheckExistingConversionRequest;

   //Check same onversion reuquest already requested in IADDSDDLHP File
   Exec Sql
      Select * Into :udHdrDs
        From iADdsDdlHP
       Where iARepoNm    = :inRepo
         And iADdsObjLb  = :inDDSLibrary
         And iADdsObjNm  = :inDDSObjNam
         And iADdsObjAt  = :inDDSObjAttr
         And (iADdlMbrLb = :inDDLMbrLib
          Or iADdlObjLb  = :inDDLObjLib);

   If sqlCode = successCode;

      //Archieve the same conversion request from IADDSDDLHP to IADDSDDLHH File
      ArchiveHeaderFile();

      //Archieve the same conversion request from IADDSDDLDP to IADDSDDLDH File
      ArchiveConversionFile();

      //Delete the existing members and objects from DDL Library
      DeleteExistingMbrObjs();

      //Update Request Status as 'N' and Failue Reason in File Download Request
      UpdateFileDownloadRequest();

   EndIf;


End-Proc;

//------------------------------------------------------------------------------------- //
//ArchiveHeaderFile : Archive the Header file to Header History File Details            //
//------------------------------------------------------------------------------------- //
Dcl-Proc ArchiveHeaderFile;

   Exec Sql
      Insert Into IADDSDDLHH (iAReqId,             iARepoNm,
                              iADdsObjLb,          iADdsObjNm,
                              iADdsObjAt,          iADdlMbrLb,
                              iADdlMbrNm,          iADdlObjLb,
                              iADdlObjNm,          iADdlLngNm,
                              iAReplace,           iAIncDepPg,
                              iAIncDepFl,          iAIncAudCo,
                              iAIncIdnCo,          iACopyData,
                              iAConvSts,           iARplReqId,
                              iARplUser,           iACrtPgm,
                              iACrtUser,           iACrtTime,
                              iAUpdPgm,            iAUpdUser,
                              iAUpdTime)
                      Values (:udHdrDs.iAReqId,    :udHdrDs.iARepoNm,
                              :udHdrDs.iADdsObjLb, :udHdrDs.iADdsObjNm,
                              :udHdrDs.iADdsObjAt, :udHdrDs.iADdlMbrLb,
                              :udHdrDs.iADdlMbrNm, :udHdrDs.iADdlObjLb,
                              :udHdrDs.iADdlObjNm, :udHdrDs.iADdlLngNm,
                              :udHdrDs.iAReplace,  :udHdrDs.iAIncDepPg,
                              :udHdrDs.iAIncDepFl, :udHdrDs.iAIncAudCo,
                              :udHdrDs.iAIncIdnCo, :udHdrDs.iACopyData,
                              :udHdrDs.iAConvSts,  :inReqId,
                              :inRequestedUser,    :udHdrDs.iACrtPgm,
                              :udHdrDs.iACrtUser,  :udHdrDs.iACrtTime,
                              :udHdrDs.iAUpdPgm,   :udHdrDs.iAUpdUser,
                              :udHdrDs.iAUpdTime);

   If sqlCode < successCode;
      udPsDs.wkQuery_Name = 'Insert_IADDSDDLHH';
      IaSqlDiagnostic(udPsDs);
   EndIf;

End-Proc;

//------------------------------------------------------------------------------------- //
//ArchiveConversionFile : Archive the Coversion File to History Conversion Details File //
//------------------------------------------------------------------------------------- //
Dcl-Proc ArchiveConversionFile;

   uwSqlStmt =                                                                           //0001
     'Insert Into IADDSDDLDH (iAReqId,   ' +                                             //0001
                             'iARepoNm,  ' +                                             //0001
                             'iADdsFlTyp,' +                                             //0002
                             'iADdsObjLb,' +                                             //0001
                             'iADdsObjNm,' +                                             //0001
                             'iADdsObjTy,' +                                             //0001
                             'iADdsObjAt,' +                                             //0001
                             'iADdsMbrNm,' +                                             //0002
                             'iADdsRcdFm,' +                                             //0002
                             'iADdsFmtID,' +                                             //0001
                             'iABasedPF, ' +                                             //0001
                             'iADdsSrcLb,' +                                             //0001
                             'iADdsSrcFl,' +                                             //0001
                             'iADdsSrcMb,' +                                             //0001
                             'iADdsSrcAt,' +                                             //0001
                             'iADdlSrcLb,' +                                             //0001
                             'iADdlSrcFl,' +                                             //0001
                             'iADdlSrcMb,' +                                             //0001
                             'iADdlSrcAt,' +                                             //0001
                             'iADdlObjLb,' +                                             //0001
                             'iADdlObjNm,' +                                             //0001
                             'iADdlObjTy,' +                                             //0001
                             'iADdlObjAt,' +                                             //0001
                             'iADdlFmtID,' +                                             //0001
                             'iADdlLngNm,' +                                             //0001
                             'iAUnqFlg,  ' +                                             //0001
                             'iAKeyFlg,  ' +                                             //0001
                             'iAKeyIdxNm,' +                                             //0001
                             'iAConvSts, ' +                                             //0001
                             'iAErrMsg,  ' +                                             //0001
                             'iARplReqId,' +                                             //0001
                             'iARplUser, ' +                                             //0001
                             'iACrtPgm,  ' +                                             //0001
                             'iACrtUser, ' +                                             //0001
                             'iACrtTime, ' +                                             //0001
                             'iAUpdPgm,  ' +                                             //0001
                             'iAUpdUser, ' +                                             //0001
                             'iAUpdTime) ' +                                             //0001
                    '(Select  iAReqId,   ' +                                             //0001
                             'iARepoNm,  ' +                                             //0001
                             'iADdsFlTyp,' +                                             //0002
                             'iADdsObjLb,' +                                             //0001
                             'iADdsObjNm,' +                                             //0001
                             'iADdsObjTy,' +                                             //0001
                             'iADdsObjAt,' +                                             //0001
                             'iADdsMbrNm,' +                                             //0002
                             'iADdsRcdFm,' +                                             //0002
                             'iADdsFmtID,' +                                             //0001
                             'iABasedPF, ' +                                             //0001
                             'iADdsSrcLb,' +                                             //0001
                             'iADdsSrcFl,' +                                             //0001
                             'iADdsSrcMb,' +                                             //0001
                             'iADdsSrcAt,' +                                             //0001
                             'iADdlSrcLb,' +                                             //0001
                             'iADdlSrcFl,' +                                             //0001
                             'iADdlSrcMb,' +                                             //0001
                             'iADdlSrcAt,' +                                             //0001
                             'iADdlObjLb,' +                                             //0001
                             'iADdlObjNm,' +                                             //0001
                             'iADdlObjTy,' +                                             //0001
                             'iADdlObjAt,' +                                             //0001
                             'iADdlFmtID,' +                                             //0001
                             'iADdlLngNm,' +                                             //0001
                             'iAUnqFlg,  ' +                                             //0001
                             'iAKeyFlg,  ' +                                             //0001
                             'iAKeyIdxNm,' +                                             //0001
                             'iAConvSts, ' +                                             //0001
                             'iAErrMsg,  ' +                                             //0001
                              SQUOTE + inReqId + SQUOTE + ',  ' +                        //0001
                              SQUOTE + inRequestedUser + SQUOTE + ',  ' +                //0001
                             'iACrtPgm,  ' +                                             //0001
                             'iACrtUser, ' +                                             //0001
                             'iACrtTime, ' +                                             //0001
                             'iAUpdPgm,  ' +                                             //0001
                             'iAUpdUser, ' +                                             //0001
                             'iAUpdTime  ' +                                             //0001
                       ' From iADdsDdlDP ' +                                             //0001
                       'Where iAReqId  =' + %Char(udHdrDs.iAReqId) + ')';                //0001

 //uwSqlStmt =                                                                           //0001
 //  'Insert Into IADDSDDLDH (iAReqId,    iARepoNm,  ' +                                 //0001
 //                          'iADdsObjLb, iADdsObjNm,' +                                 //0001
 //                          'iADdsObjAt, iADdsObjTy,' +                                 //0001
 //                          'iABasedPF,  iADdsSrcLb,' +                                 //0001
 //                          'iADdsSrcFl, iADdsSrcMb,' +                                 //0001
 //                          'iADdsSrcAt, iADdlSrcLb,' +                                 //0001
 //                          'iADdlSrcFl, iADdlSrcMb,' +                                 //0001
 //                          'iADdlSrcAt, iADdlObjLb,' +                                 //0001
 //                          'iADdlObjNm, iADdlObjAt,' +                                 //0001
 //                          'iADdlObjTy, iADdlLngNm,' +                                 //0001
 //                          'iAUnqFlg,   iAKeyFlg,  ' +                                 //0001
 //                          'iAKeyIdxNm, iAConvSts, ' +                                 //0001
 //                          'iAErrMsg,   iARplReqId,' +                                 //0001
 //                          'iARplUser,  iACrtPgm,  ' +                                 //0001
 //                          'iACrtUser,  iACrtTime, ' +                                 //0001
 //                          'iAUpdPgm,   iAUpdUser, ' +                                 //0001
 //                          'iAUpdTime)             ' +                                 //0001
 //                 '(Select  iAReqId,    iARepoNm,  ' +                                 //0001
 //                          'iADdsObjLb, iADdsObjNm,' +                                 //0001
 //                          'iADdsObjAt, iADdsObjTy,' +                                 //0001
 //                          'iABasedPF,  iADdsSrcLb,' +                                 //0001
 //                          'iADdsSrcFl, iADdsSrcMb,' +                                 //0001
 //                          'iADdsSrcAt, iADdlSrcLb,' +                                 //0001
 //                          'iADdlSrcFl, iADdlSrcMb,' +                                 //0001
 //                          'iADdlSrcAt, iADdlObjLb,' +                                 //0001
 //                          'iADdlObjNm, iADdlObjAt,' +                                 //0001
 //                          'iADdlObjTy, iADdlLngNm,' +                                 //0001
 //                          'iAUnqFlg,   iAKeyFlg,  ' +                                 //0001
 //                          'iAKeyIdxNm, iAConvSts, ' +                                 //0001
 //                          'iAErrMsg,              ' +                                 //0001
 //                           SQUOTE + inReqId + SQUOTE + ',  ' +                        //0001
 //                           SQUOTE + inRequestedUser + SQUOTE + ',  ' +                //0001
 //                          'iACrtPgm,   iACrtUser, ' +                                 //0001
 //                          'iACrtTime,  iAUpdPgm,  ' +                                 //0001
 //                          'iAUpdUser,  iAUpdTime  ' +                                 //0001
 //                    ' From iADdsDdlDP ' +                                             //0001
 //                    'Where iAReqId  =' + %Char(udHdrDs.iAReqId) + ')';                //0001

   Exec Sql Execute Immediate :uwSqlStmt;

   If sqlCode < successCode;
      udPsDs.wkQuery_Name = 'Insert_IADDSDDLDH';
      IaSqlDiagnostic(udPsDs);
   EndIf;

End-Proc;

//------------------------------------------------------------------------------------- //
//DeleteExistingMbrObjs : Delete the existing members and objects from DDL Library      //
//------------------------------------------------------------------------------------- //
Dcl-Proc DeleteExistingMbrObjs;

   //Open cursor CursorCnvSrcAndCmplObjs
   Exec Sql Open CursorCnvSrcAndCmplObjs;
   If sqlCode = CSR_OPN_COD;
      Exec Sql Close CursorCnvSrcAndCmplObjs;
      Exec Sql Open  CursorCnvSrcAndCmplObjs;
   EndIf;

   If sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Open_CursorCnvSrcAndCmplObjs';
      IaSqlDiagnostic(uDpsds);
   EndIf;

   //Get the number of elements
   noOfRows = %elem(udSrcObj);

   //Fetch records from CursorCnvSrcAndCmplObjs
   rowFound = FetchCursorCnvSrcAndCmplObjs();

   DoW rowFound;
      For uiSrcObjIdx = 1 To SrcObjRowsFetched;
         //Remove Source Member
         If udSrcObj(uiSrcObjIdx).usSrcMbr <> *Blanks;
            Clear uwCmd;
            uwCmd = 'RMVM FILE(' +
                    %Trim(udHdrDs.iADdlMbrLb) + '/' +
                    'QDDLSRC) MBR(' +
                    %Trim(udSrcObj(uiSrcObjIdx).usSrcMbr) + ')';
            RunCmd();
         EndIf;
         //Delete Objects
         If udSrcObj(uiSrcObjIdx).usObjName <> *Blanks;
            If udSrcObj(uiSrcObjIdx).usObjType = '*FILE';
               Select;
                  When udSrcObj(uiSrcObjIdx).usObjAtr = 'PF';
                     //Drop the existing Table, Index and Views
                     uwSqlStmt = 'Drop Table If Exists ' +
                                 %Trim(udHdrDs.iADdlObjLb) + '.' +
                                 %Trim(udSrcObj(uiSrcObjIdx).usObjName);
                     Exec Sql Execute Immediate :uwSqlStmt;
                  When udSrcObj(uiSrcObjIdx).usObjAtr = 'LF';
                     //Drop the existing Index
                     uwSqlStmt = 'Drop Index If Exists ' +
                                 %Trim(udHdrDs.iADdlObjLb) + '.' +
                                 %Trim(udSrcObj(uiSrcObjIdx).usObjName);
                     Exec Sql Execute Immediate :uwSqlStmt;
                     //Drop the existing View
                     uwSqlStmt = 'Drop View If Exists ' +
                                 %Trim(udHdrDs.iADdlObjLb) + '.' +
                                 %Trim(udSrcObj(uiSrcObjIdx).usObjName);
                     Exec Sql Execute Immediate :uwSqlStmt;
                  Other;
               EndSl;
               //Drop the additional index created for PF/LF
               If udSrcObj(uiSrcObjIdx).usObjIdx <> *Blanks;
                  uwSqlStmt = 'Drop Index If Exists ' +
                              %Trim(udHdrDs.iADdlObjLb) + '.' +
                              %Trim(udSrcObj(uiSrcObjIdx).usObjIdx);
                  Exec Sql Execute Immediate :uwSqlStmt;
               EndIf;
            Else;
               Clear uwCmd;
               //Delete the object
               uwCmd = 'DLTOBJ OBJ(' +
                       %Trim(udHdrDs.iADdlObjLb) + '/' +
                       %Trim(udSrcObj(uiSrcObjIdx).usObjName) +
                       ') OBJTYPE(' +
                       %Trim(udSrcObj(uiSrcObjIdx).usObjType) + ')';
               RunCmd();
            EndIf;
         EndIf;
      EndFor;

      //If fetched rows are less than the array elements then come out of the loop.
      If SrcObjRowsFetched < noOfRows ;
         Leave ;
      EndIf ;

      //Fetched next set of rows.
      rowFound = FetchCursorCnvSrcAndCmplObjs();

   EndDo;

   //Close Cursor CursorCnvSrcAndCmplObjs
   Exec Sql Close CursorCnvSrcAndCmplObjs;

   //Delete existing same conversion request from IADDSDDLHP File
   Exec Sql
      Delete From IADDSDDLHP
       Where iAReqId  = :udHdrDs.iAReqId;

   //Delete existing same conversion request from IADDSDDLDP File
   Exec Sql
      Delete From IADDSDDLDP
       Where iAReqId  = :udHdrDs.iAReqId;

End-Proc;

//------------------------------------------------------------------------------------- //
//UpdateFileDownloadRequest : Update the File Download Request File                     //
//------------------------------------------------------------------------------------- //
Dcl-Proc UpdateFileDownloadRequest;

   uwMsgVars = inRequestedUser + %Trim(inReqId);

   //Get the Failure Reason Message
   iAGetMsg('1':'MSG0210':uwMsgDesc:uwMsgVars);
   uwFailRsn  = %Trim(uwMsgDesc);

   Exec Sql
      Update iAFDwnReq
         Set iAReqSts  = 'N',
             iAFailRsn = :uwFailRsn
       Where iAReqID   = :udHdrDs.iAReqId
         And iAFeatr   = :FEATURE;

   If sqlCode < successCode;
      udPsDs.wkQuery_Name = 'Update_IAFDWNREQ';
      IaSqlDiagnostic(udPsDs);
   EndIf;

End-Proc;

//------------------------------------------------------------------------------------- //
//FetchCursorCnvSrcAndCmplObjs : To fetch converted source & compiled object detail     //
//------------------------------------------------------------------------------------- //
Dcl-Proc FetchCursorCnvSrcAndCmplObjs;

   Dcl-Pi FetchCursorCnvSrcAndCmplObjs Ind End-Pi ;

   Dcl-S  rcdFound Ind Inz('0');
   Dcl-S  uwRowNum Uns(5);

   SrcObjRowsFetched = *Zeros;
   Clear udSrcObj;

   Exec Sql
      Fetch CursorCnvSrcAndCmplObjs For :noOfRows Rows Into :udSrcObj;

   If sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Fetch_CursorCnvSrcAndCmplObjs';
      IaSqlDiagnostic(uDpsds);
   EndIf;

   If sqlcode = successCode;
      Exec Sql Get Diagnostics
         :uwRowNum = ROW_COUNT;
         SrcObjRowsFetched = uwRowNum ;
   EndIf;

   If SrcObjRowsFetched > 0;
      rcdFound = TRUE;
   ElseIf sqlcode < successCode ;
      rcdFound = FALSE;
   EndIf;

   Return rcdFound;

End-Proc;

//------------------------------------------------------------------------------------- //
//RunCmd : To execute the command                                                       //
//------------------------------------------------------------------------------------- //
Dcl-Proc RunCmd;

   Dcl-Pr RunCommand ExtPgm('QCMDEXC');
      Command    Char(1000) Options(*VarSize) Const;
      Commandlen Packed(15:5) Const;
   End-Pr;

   Clear uwError;
   Monitor;
      RunCommand(uwCmd:%Len(%TrimR(uwCmd)));
   On-Error;
      uwError = 'Y';
   EndMon;

End-Proc;

