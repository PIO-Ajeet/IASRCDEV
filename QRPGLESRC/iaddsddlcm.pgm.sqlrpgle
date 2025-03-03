**free
      //%METADATA                                                      *
      // %TEXT IA - DDStoDDL Compilation Programs                      *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------- //
//Created By  : Programmers.io @ 2024                                                   //
//Created Date: 2024/04/24                                                              //
//Developer   : Programmers.io                                                          //
//Description : This program compiles the files and programs                            //
//              and return parameter outStatus has below values:                        //
//              'E' = Error                                                             //
//              'S' = Successfull                                                       //
//              'W' = Warning                                                           //
//                                                                                      //
//                       Input Parameters:                                              //
//              inReqId          -  Request Id                                          //
//              inRepo           -  Repo Name                                           //
//              inDDSObjNam      -  DDS Object Name                                     //
//              inDDSLibrary     -  DDS Object Library                                  //
//              inDDSObjAttr     -  DDS Object Attribute                                //
//              inDDSMbrName     -  DDS Member Name                                     //
//              inDDSRcdFmt      -  DDS Record Format                                   //
//              inDDSObjType     -  DDS Object Type                                     //
//              inDDLMbrNam      -  DDL Member Name                                     //
//              inDDLMbrLib      -  DDL Member Library                                  //
//              inDDLObjNam      -  DDL Object Name                                     //
//              inDDLObjLib      -  DDL Object Library                                  //
//              inCompilationObj -  Compilation Object (P-Program F-FIle)               //
//              inRequestedUser  -  Requested User                                      //
//                                                                                      //
//                       Ouput Parameters:                                              //
//              outStatus        -  Output Status                                       //
//              outMessage       -  Output Message                                      //
//                                                                                      //
//------------------------------------------------------------------------------------- //
//Procedure Log:                                                                        //
//------------------------------------------------------------------------------------- //
//Procedure Name                | Procedure Description                                 //
//------------------------------|-------------------------------------------------------//
//CompileObjects                |Compile the objects                                    //
//processDDLFile                |Process DDL File                                       //
//processModuleObjs             |Process *Module Objects                                //
//processSrvPgmObjs             |Process *SrvPgm Objects                                //
//processPgmObjs                |Process *PGM Objects                                   //
//CompilePgmObjects             |Compile the Program Objects                            //
//AddModule                     |Add Module Programs to compilation if it requires      //
//AddSrvPgm                     |Add Service Programs to compilation if it requires     //
//AddBndDir                     |Add Binding Directories to compilation if it requires  //
//FetchRecordCursorLibL         |Fetch library list of repo from cursor                 //
//FetchRecordCursorModObjList   |To Fetch *Module Objects from IADDSDDLPP File          //
//FetchRecordCursorSrvPgmObjList|To Fetch *SrvPgm Objects from IADDSDDLPP File          //
//FetchRecordCursorPgmObjList   |To Fetch *Pgm Objects from IADDSDDLPP File             //
//FetchRecordCursorModule       |To fetch bound Module Programs                         //
//FetchRecordCursorSrvPgm       |To fetch bound Service Programs                        //
//FetchRecordCursorBndDir       |To fetch bound Binding Directories                     //
//CompileDDL                    |To compile created DDL members of PFs and LFs          //
//GetExportSourceDetails        |To get Export Source details of Service Program        //
//GetObjectText                 |To get Object Text                                     //
//ExecuteCommand                |To execute compile commands and return errors if any   //
//UpdateCompilationStatus       |To update compile status of respective objects         //
//GetDdlRcdIdentifier           |To get DDL object Record Format Identifier             //
//--------------------------------------------------------------------------------------//
//Modification Log:                                                                     //
//------------------------------------------------------------------------------------- //
//Date-DMY| Mod-ID | Developer  | Case and Description                                  //
//--------|--------|------------|------------------------------------------------------ //
//19/09/24| 0001   |K Abhishek A| Task#952 - Use Source Attribute instead of Program    //
//        |        |            | Attribute to compile the program.                     //
//24/09/24| 0002   |Dada Bachute|Task - #958 Handle the error message for the Same      //
//        |        |            |Library list setup more than once during compilation.  //
//04/10/24| 0003   |Piyush Kumar|Task#999 - Handle the Module compliation when module   //
//        |        |            |source information is blank or invalid.                //
//06/11/24| 0004   |Manav T.    |Task#1057- DDStoDDL - Error Message Return to SP       //
//        |        |            |uwDDLFail is set to on when there is error in          //
//        |        |            |CompileDDL so that it should throw correct error.      //
//13/11/24| 0005   |Piyush Kumar|Task#1055 - Changing field name from iACmplMsg to      //
//        |        |            |iAErrMsg for iADdsDdlDP File.                          //
//        |        |            |- DDL Object & Library should not updated.             //
//27/11/24| 0006   |Piyush Kumar|Task#1072 - Adding Multi Record Format and Multi Member//
//        |        |            |functionality.                                         //
//14/11/24| 0007   |S Karthick  |Task#1067 - Logic for Update the DDL File Identifier   //
//        |        |            |            into IADDSDDLDP file.                      //
//------------------------------------------------------------------------------------- //
Ctl-Opt CopyRight('Copyright @ Programmers.io © 2024');
Ctl-Opt Option(*NoDebugIo:*SrcStmt:*NoUnRef);
Ctl-Opt BndDir('IAERRBND');
Ctl-Opt ActGrp(*Caller);

//------------------------------------------------------------------------------------- //
//Standalone Variables                                                                  //
//------------------------------------------------------------------------------------- //
Dcl-S uwRowsFetched        Uns(5)          Inz;
Dcl-S uwRows               Uns(5)          Inz;

Dcl-S uwPgmName            Char(10)        Inz;
Dcl-S uwObject             Char(10)        Inz;
Dcl-s uwObjType            Char(10)        Inz;
Dcl-S uwLogicalFile        Char(10)        Inz;
Dcl-S uwMsgDesc            Char(1000)      Inz;
Dcl-S uwMsgVars            Char(80)        Inz;
Dcl-S uwStatus             Like(OutStatus)    ;
Dcl-S uwCmd                Like(uwCommand)    ;
Dcl-s uwOutStsBk           Like(OutStatus)    ;
Dcl-S uwOutMsgBk           Like(OutMessage)   ;
Dcl-S uwDDLObjLb           Char(10)        Inz;
Dcl-S uwDDLObjNm           Char(10)        Inz;
Dcl-S uwDDLObjAt           Char(10)        Inz;
Dcl-S uwDDLObjTy           Char(10)        Inz;
Dcl-S uwDDLObjTx           Char(50)        Inz;
Dcl-S uwDdlRcdId           Char(13)        Inz;                                          //0007

Dcl-S wkDdlSrcLb           Char(10)        Inz;
Dcl-S wkDdlSrcMb           Char(10)        Inz;
Dcl-S wkDdlObjLb           Char(10)        Inz;
Dcl-S wkDdlObjNm           Char(10)        Inz;
Dcl-S wkObjectText         Char(50)        Inz;

Dcl-S uwRowFound           Ind             Inz;
Dcl-S uwLFDependents       Ind             Inz(*Off);
Dcl-S uwDDLFail            Ind             Inz(*Off);

Dcl-S wkSrvPgmInfo         Char(5444)      Inz;
Dcl-S wkErrorInfo          Char(1070)      Inz;
Dcl-S wkExportSourceFile   Char(10)        Inz;
Dcl-S wkExportSourceLib    Char(10)        Inz;
Dcl-S wkExportSourceMem    Char(10)        Inz;
//------------------------------------------------------------------------------------- //
//Constant Variables                                                                    //
//------------------------------------------------------------------------------------- //
Dcl-C TRUE            '1';
Dcl-C FALSE           '0';
Dcl-C QUOTES         '''';

//------------------------------------------------------------------------------------- //
//Array Declarations                                                                    //
//------------------------------------------------------------------------------------- //

//------------------------------------------------------------------------------------- //
//Datastructure Definitions                                                             //
//------------------------------------------------------------------------------------- //

//Data Structure to hold repo libraries
Dcl-Ds udLibDs  Dim(99) Qualified;
   usLib        Char(10);
End-Ds;

//Data Structure array to hold dependent objects list
Dcl-Ds udDepObjList;
   usObjPgmLb   Char(10);
   usObjPgmNm   Char(10);
   usObjPgmAt   Char(10);
   usObjPgmTy   Char(10);
   usObjSrcLb   Char(10);
   usObjSrcFl   Char(10);
   usObjSrcMb   Char(10);
   usObjSrcAt   Char(10);
End-Ds;

//Data Structure to hold previos file details
Dcl-Ds udprvDepObjList Qualified;
   data LikeDs(udDepObjList);
End-Ds;

//Data Structure to hold bound *MODULE
Dcl-Ds udModuleDs Dim(99) Qualified;
   usName       Char(10);
   usLib        Char(10);
   usPEP        Char(1);
End-Ds;

//Data Structure to hold bound *SRVPGM
Dcl-Ds udSrvPgmDs Dim(99) Qualified;
   usName       Char(10);
   usLib        Char(10);
End-Ds;

//Data Structure to hold bound *BNDDIR
Dcl-Ds udBndDirDs Dim(99) Qualified;
   usName       Char(10);
   usLib        Char(10);
End-Ds;

//Data Structure for error during QUSROBJD
Dcl-Ds ApiErrDS Qualified;
   BytesProv Int(10)   Pos(1) Inz(%size(ApiErrDS));
   BytesRtn  Int(10)   Pos(5) Inz(0);
   ErrMsgId  Char(7)   Pos(9);
   MsgRplVal Char(112) Pos(17);
End-Ds;

//Data Structure for QUSROBJD
Dcl-Ds qUsrObjDS Qualified Inz;
   ObjectName      Char(10) Pos(9);
   ObjectLibrary   Char(10) Pos(19);
   ObjectType      Char(10) Pos(29);
   ReturnLib       Char(10) Pos(39);
   ExtendedAttr    Char(10) Pos(91);
   CreateDateTime  Char(13) Pos(65);
   ChangeDateTime  Char(13) Pos(78);
   TextDescription Char(50) Pos(101);
   SourceFile      Char(10) Pos(151);
   SourceLibrary   Char(10) Pos(161);
   SourceMember    Char(10) Pos(171);
   SaveDateTime    Char(13) Pos(194);
   RestoreDateTime Char(13) Pos(207);
   CreatedByUser   Char(10) Pos(220);
   LastUsedDate    Char(7)  Pos(461);
   NumDaysUsed     Int(10)  Pos(469);
   ObjectSize      Int(10)  Pos(473);
   MultiplySize    Int(10)  Pos(477);
End-Ds;

//------------------------------------------------------------------------------------- //
//Prototype Definitions                                                                 //
//------------------------------------------------------------------------------------- //
Dcl-Pr RunCmd ExtPgm('QCMDEXC');
   *n Char(1000)   Options(*VarSize) Const;
   *n Packed(15:5)                   Const;
End-Pr;

Dcl-Pr iAGetMsg Extpgm('IAGETMSG');
   *n Char(01)     Options(*NoPass) Const;
   *n Char(07)     Options(*NoPass) Const;
   *n Char(1000)   Options(*NoPass)      ;
   *n Char(80)     Options(*NoPass) Const;
End-Pr;

Dcl-Pr GetSrvPgmInf Extpgm('QBNRSPGM');
   *n  Char(5444) Options(*VarSize);
   *n  Int(10)    Const;
   *n  Char(8)    Const;
   *n  Char(20)   Const;
   *n  Char(1070) Options(*VarSize);
End-Pr;

Dcl-Pr qUsrObjd extpgm('QUSROBJD');
   *n Char(472) Options(*VarSize);
   *n Int(10)   Const;
   *n Char(8)   Const;
   *n Char(20)  Const;
   *n Char(10)  Const;
   *n Like(ApiErrDS);
End-Pr;

//------------------------------------------------------------------------------------- //
//Copybook definitions                                                                  //
//------------------------------------------------------------------------------------- //
/copy 'QCPYSRC/iaderrlog.rpgleinc'

//------------------------------------------------------------------------------------- //
//Entry Parameter Declarations
//------------------------------------------------------------------------------------- //
Dcl-Pr IADDSDDLCM ExtPgm('IADDSDDLCM');
   inReqId           Char(18);
   inRepo            Char(10);
   inDDSObjNam       Char(10);
   inDDSLibrary      Char(10);
   inDDSObjAttr      Char(10);
   inDDSObjType      Char(10);
   inDDSMbrName      Char(10);                                                           //0006
   inDDSRcdFmt       Char(10);                                                           //0006
   inDDLMbrNam       Char(10);                                                           //0006
   inDDLMbrLib       Char(10);
   inDDLObjNam       Char(10);                                                           //0006
   inDDLObjLib       Char(10);
   inCompilationObj  Char(1);
   inRequestedUser   Char(10);
   outStatus         Char(1);
   outMessage        Char(80);
End-Pr;

Dcl-Pi iADdsDdlCM;
   inReqId           Char(18);
   inRepo            Char(10);
   inDDSObjNam       Char(10);
   inDDSLibrary      Char(10);
   inDDSObjAttr      Char(10);
   inDDSObjType      Char(10);
   inDDSMbrName      Char(10);                                                           //0006
   inDDSRcdFmt       Char(10);                                                           //0006
   inDDLMbrNam       Char(10);                                                           //0006
   inDDLMbrLib       Char(10);
   inDDLObjNam       Char(10);                                                           //0006
   inDDLObjLib       Char(10);
   inCompilationObj  Char(1);
   inRequestedUser   Char(10);
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

Eval-Corr uDpsds = wkuDpsds;

//------------------------------------------------------------------------------------- //
//Cursor Declarations                                                                   //
//------------------------------------------------------------------------------------- //
//Fetch *Module objects from IADDSDDLPP File
Exec Sql
   Declare CursorModObjList Cursor For
    Select iAPgmObjLb,
           iAPgmObjNm,
           iAPgmObjAt,
           iAPgmObjTy,
           iAPgmSrcLb,
           iAPgmSrcFl,
           iAPgmSrcMb,
           iAPgmSrcAt
      From iADdsDdlPP
     Where iAReqId    = :inReqId
       And iAPgmObjTy = '*MODULE'
       For Update of iACmplSts, iACmplMsg,
           iAUpdPgm, iAUpdUser;

//Fetch *SrvPgm objects from IADDSDDLPP File
Exec Sql
   Declare CursorSrvPgmObjList Cursor For
    Select iAPgmObjLb,
           iAPgmObjNm,
           iAPgmObjAt,
           iAPgmObjTy,
           iAPgmSrcLb,
           iAPgmSrcFl,
           iAPgmSrcMb,
           iAPgmSrcAt
      From iADdsDdlPP
     Where iAReqId    = :inReqId
       And iAPgmObjTy = '*SRVPGM'
       For Update of iACmplSts, iACmplMsg,
           iAUpdPgm, iAUpdUser;

//Fetch *Pgm objects from IADDSDDLPP File
Exec Sql
   Declare CursorPgmObjList Cursor For
    Select iAPgmObjLb,
           iAPgmObjNm,
           iAPgmObjAt,
           iAPgmObjTy,
           iAPgmSrcLb,
           iAPgmSrcFl,
           iAPgmSrcMb,
           iAPgmSrcAt
      From iADdsDdlPP
     Where iAReqId    = :inReqId
       And iAPgmObjTy = '*PGM'
       For Update of iACmplSts, iACmplMsg,
           iAUpdPgm, iAUpdUser;

//To fetch bound module programs to a *Pgm/*Srvpgm objects
Exec Sql
   Declare CursorModule Cursor For
    Select MOD, MODLIB, PEP
      From IAPGMINF
     Where Pgm    = :usObjPgmNm
       And PgmLib = :usObjPgmLb
       And PgmTyp = :usObjPgmTy
       And ModTyp = '*MODULE'
      With Ur;

//To fetch bound service programs to a *Pgm/*Module/*Srvpgm objects
Exec Sql
   Declare CursorSrvPgm Cursor For
    Select MOD, MODLIB
      from IAPGMINF
     Where PGM    = :usObjPgmNm
       And PgmLib = :usObjPgmLb
       And PGMTYP = :usObjPgmTy
       And MODTYP = '*SRVPGM';

//To fetch bound binding directory to *Pgm/*Module/*Srvpgm objects
Exec Sql
   Declare CursorBndDir Cursor For
    Select IAROBJNAM, IAROBJLIB
      From IAALLREFPF
     Where IAOOBJNAM = :usObjPgmNm
       And IAOOBJTYP <> '*BNDDIR'
       And IAROBJTYP = '*BNDDIR';

//------------------------------------------------------------------------------------- //
//Main Processing                                                                       //
//------------------------------------------------------------------------------------- //
//Compile the Objects
CompileObjects();

//If the input Username blank then get the Username from program status Data Structure
If inRequestedUser = *Blanks;
  inRequestedUser = uDpsds.User;
EndIf;

//If any one object compilation is failed
If uwStatus = 'W';
   outStatus  = 'W';
   If uwDDLFail = *On;
      //DDL member compilation failed.
      iAGetMsg('1':'MSG0189':uwMsgDesc:' ');
   Else;
      //One or more dependents program failed to compile. Please check IADDSDDLPP.
      iAGetMsg('1':'MSG0186':uwMsgDesc:' ');
   EndIf;
   outMessage = %trim(uwMsgDesc);
Else;
   outStatus  = 'S';
   uwMsgVars  = %trim(inDDLMbrLib);
   //DDL (and its dependent source/objects) creation completed
   iAGetMsg('1':'MSG0185':uwMsgDesc:uwMsgVars);
   outMessage = %trim(uwMsgDesc);
EndIf;

*InLr = *On;

//--------------------------------------------------------------------------------------//
//CompileObjects : Compile the objects                                                  //
//--------------------------------------------------------------------------------------//
Dcl-Proc CompileObjects;

   //If Compilation Object is File
   If inCompilationObj = 'F';
      //Process DDL File
      processDDLFile();
   //If Compilation Object is Program
   ElseIf inCompilationObj = 'P';
      //Process *Module Objects
      processModuleObjs();
      //Process *SRVPGM Objects
      processSrvPgmObjs();
      //Process *PGM Objects
      processPgmObjs();
   EndIf;

End-Proc;

// --------------------------------------------------------------------------------------//
//processDDLFile : Process DDL File                                                     //
// --------------------------------------------------------------------------------------//
Dcl-Proc processDDLFile;

   Exec Sql
      Select iADdlSrcLb, iADdlSrcMb, iADdlObjLb, iADdlObjNm
        into :wkDdlSrcLb, :wkDdlSrcMb, :wkDdlObjLb, :wkDdlObjNm
        From iADdsDdlDP
       Where iAReqId    = :inReqId
         and iADdsObjLb = :inDDSLibrary
         and iADdsObjNm = :inDDSObjNam
       //and iADdsObjAt = :inDDSObjAttr;                                                 //0006
         and iADdsObjAt = :inDDSObjAttr                                                  //0006
         and iADdsMbrNm = :inDDSMbrName                                                  //0006
         and iADdsRcdFm = :inDDSRcdFmt                                                   //0006
         and iADdlSrcMb = :inDDLMbrNam                                                   //0006
         and iADdlObjNm = :inDDLObjNam;                                                  //0006

   If SqlCode = SuccessCode;
      //PFSQL/LFSQL DDL member Compilation
      CompileDDL(wkDdlSrcMb);
   Else;
      uwStatus = 'W';
      uwDDLFail = *On;
      outStatus  = 'E';
      iAGetMsg('1':'MSG0209':uwMsgDesc:' ');
      outMessage = %Trim(uwMsgDesc);
   EndIf;

   //Update compilation status in IADDSDDLPP file for PFSQL/LFSQL DDL Source
   UpdateCompilationStatus();

End-Proc;

// --------------------------------------------------------------------------------------//
//processModuleObjs : Process *Module Objects                                           //
// --------------------------------------------------------------------------------------//
Dcl-Proc processModuleObjs;

   //Open Cursor for *Module
   Exec Sql Open CursorModObjList;
   If SqlCode = CSR_OPN_COD;
      Exec Sql Close CursorModObjList;
      Exec Sql Open  CursorModObjList;
   EndIf;

   If SqlCode < SuccessCode;
      uDpsds.wkQuery_Name = 'Open_CursorModObjList';
      IaSqlDiagnostic(uDpsds);
   EndIf;

   //Fetch records from CursorModObjList
   uwRowFound = FetchRecordCursorModObjList();

   DoW uwRowFound;
      //Compile the *Module Objects
      CompilePgmObjects();

      //Fetch next row
      uwRowFound = FetchRecordCursorModObjList();
   EndDo;

   //Close Cursor for *Module
   Exec Sql Close CursorModObjList;

End-Proc;

// --------------------------------------------------------------------------------------//
//processSrvPgmObjs : Process *SrvPgm Objects                                           //
// --------------------------------------------------------------------------------------//
Dcl-Proc processSrvPgmObjs;

   //Open Cursor for *SrvPgm
   Exec Sql Open CursorSrvPgmObjList;
   If SqlCode = CSR_OPN_COD;
      Exec Sql Close CursorSrvPgmObjList;
      Exec Sql Open  CursorSrvPgmObjList;
   EndIf;

   If SqlCode < SuccessCode;
      uDpsds.wkQuery_Name = 'Open_CursorSrvPgmObjList';
      IaSqlDiagnostic(uDpsds);
   EndIf;

   //Fetch records from CursorSrvPgmObjList;
   uwRowFound = FetchRecordCursorSrvPgmObjList();

   DoW uwRowFound;
      //Compile the *SrvPgm Objects
      CompilePgmObjects();

      //Fetch next row
      uwRowFound = FetchRecordCursorSrvPgmObjList();
   EndDo;

   //Close Cursor for *SrvPgm
   Exec Sql Close CursorSrvPgmObjList;

End-Proc;

// --------------------------------------------------------------------------------------//
//processPgmObjs : Process *PGM Objects                                                 //
// --------------------------------------------------------------------------------------//
Dcl-Proc processPgmObjs;

   //Open Cursor for *Pgm
   Exec Sql Open CursorPgmObjList;
   If SqlCode = CSR_OPN_COD;
      Exec Sql Close CursorPgmObjList;
      Exec Sql Open  CursorPgmObjList;
   EndIf;

   If SqlCode < SuccessCode;
      uDpsds.wkQuery_Name = 'Open_CursorPgmObjList';
      IaSqlDiagnostic(uDpsds);
   EndIf;

   //Fetch records from CursorPgmObjList;
   uwRowFound = FetchRecordCursorPgmObjList();

   DoW uwRowFound;
      //Compile the *Pgm Objects
      CompilePgmObjects();

      //Fetch next row
      uwRowFound = FetchRecordCursorPgmObjList();
   EndDo;

   //Close Cursor for *Pgm
   Exec Sql Close CursorPgmObjList;

End-Proc;

// --------------------------------------------------------------------------------------//
//CompilePgmObjects : Compile the Program Objects                                       //
// --------------------------------------------------------------------------------------//
Dcl-Proc CompilePgmObjects;

   Dcl-S uwName      Char(10);
   Dcl-S uwLib       Char(10);
   Dcl-S uwPEPMod    Char(10);
   Dcl-S uwPEPLib    Char(10);
   Dcl-S uwModLib    Char(10);
   Dcl-S uwInd       Ind     ;

   //Clear Command
   Clear uwCommand;

   Select;
      When usObjPgmTy = '*MODULE';
         ExSr CompileModule;
      When usObjPgmTy = '*SRVPGM';
         //Prepare CRTPGM/CRTSRVPGM/ADDBNDDIRE command
         ExSr PrepareCommand;

         //If CRTSRVPGM command are to be executed with all the modules
         //from IADDSDDLPP file make sure to check if any module or service
         //programs or binding directories are bound to the original program.
         //If so, add those too in command preparation.
         uwCommand = AddModule(usObjPgmNm:uwCommand:usObjPgmTy);
         uwCommand = AddSrvPgm(usObjPgmNm:uwCommand);
         uwCommand = AddBndDir(usObjPgmNm:uwCommand);

         //Get Export Source details for Service Program
         GetExportSourceDetails();

         //Add binder source details to service program
         If wkExportSourceMem <> *Blanks;
            uwCommand = %trim(uwCommand)          + ' SRCFILE('  +
                        %trim(wkExportSourceLib)  + '/'          +
                        %trim(wkExportSourceFile) + ') SRCMBR('  +
                        %trim(wkExportSourceMem)  + ')';
         Else;
            uwCommand = %trim(uwCommand) + ' EXPORT(*ALL)';
         EndIf;

         //Get Object Text
         GetObjectText();

         If wkObjectText <> *Blanks;
            uwCommand = %trim(uwCommand) + ' TEXT(' + QUOTES +
                        %trim(wkObjectText) + QUOTES + ')';
         EndIf;

         uwCommand = %trim(uwCommand) + ' REPLACE(*YES)';

         //To execute the prepared command
         //If command is executed successfully
         If ExecuteCommand(uwCommand);
            outStatus  = 'S';
            outMessage = *Blanks;
         //Command failed
         Else;
            outStatus  = 'E';
            uwMsgVars  = %Subst(%trim(uwCommand):1:
                                %scan(' ':%trim(uwCommand))-1);
            //Command failed
            iAGetMsg('1':'MSG0187':uwMsgDesc:uwMsgVars);
            outMessage = %trim(uwMsgDesc);
            uwStatus   = 'W';
         EndIf;

      When usObjPgmTy = '*PGM' and usObjSrcMb <> *Blanks;
         ExSr CompileProgram;

      When usObjPgmTy = '*PGM' and usObjSrcMb = *Blanks;
         //Prepare CRTPGM/CRTSRVPGM/ADDBNDDIRE command
         ExSr PrepareCommand;

         //If CRTPGM command are to be executed with all the modules
         //from IADDSDDLPP file make sure to check if any module or service
         //programs or binding directories are bound to the original program.
         //If so, add those too in command preparation.
         uwCommand = AddModule(usObjPgmNm:uwCommand:usObjPgmTy);
         uwCommand = AddSrvPgm(usObjPgmNm:uwCommand);
         uwCommand = AddBndDir(usObjPgmNm:uwCommand);

         //Get Object Text
         GetObjectText();

         If wkObjectText <> *Blanks;
            uwCommand = %trim(uwCommand) + ' TEXT(' + QUOTES +
                        %trim(wkObjectText) + QUOTES + ')';
         EndIf;

         uwCommand = %trim(uwCommand) + ' REPLACE(*YES)';

         //To execute the prepared command
         //If command is executed successfully
         If ExecuteCommand(uwCommand);
            outStatus  = 'S';
            outMessage = *Blanks;
         //Command failed
         Else;
            outStatus  = 'E';
            uwMsgVars  = %Subst(%trim(uwCommand):1:
                                %scan(' ':%trim(uwCommand))-1);
            //Command failed
            iAGetMsg('1':'MSG0187':uwMsgDesc:uwMsgVars);
            outMessage = %trim(uwMsgDesc);
            uwStatus   = 'W';
         EndIf;

      Other;

   EndSl;

   //Update current row with compilation status in IADDSDDLPP file
   If inCompilationObj = 'P';
      UpdateCompilationStatus();
   EndIf;

   //----------------------------------------------------------------------------------//
   //PrepareCommand : To prepare CRTPGM/CRTSRVPGM/ADDBNDDIRE by adding modules         //
   //----------------------------------------------------------------------------------//
   BegSr PrepareCommand;

      Clear uwCommand;

      Select;
         //CRTPGM command
         When usObjPgmTy = '*PGM';
            uwCommand = 'CRTPGM PGM(' +
                        %trim(inDDLObjLib) + '/' +
                        %trim(usObjPgmNm)   + ') ' ;

         //CRTSRVPGM command
         When usObjPgmTy = '*SRVPGM';
            uwCommand = 'CRTSRVPGM SRVPGM(' +
                        %trim(inDDLObjLib) + '/' +
                        %trim(usObjPgmNm)   + ') ';

         //CRTBNDDIR and ADDBNDDIRE commands
         When usObjPgmTy = '*BNDDIR';
            uwCommand = 'ADDBNDDIRE BNDDIR(' +
                        %trim(inDDLObjLib) + '/' +
                        %trim(usObjPgmNm)   + ')' +
                        'OBJ(';
         EndSl;

   EndSr;

   //---------------------------------------------------------------------------------//
   //CompileModule : To compile dependent modules                                     //
   //                outStatus = 'S' - Compilation Successful                         //
   //                outStatus = 'E' - Error in Compilation                           //
   //                uwStatus  = 'W' - Warning to the user in case of Error           //
   //---------------------------------------------------------------------------------//
   BegSr CompileModule;

      Clear uwCmd;

      Select;
         //CLLE module
         When usObjSrcAt = 'CLLE';                                                       //0001
            uwCmd = 'CRTCLMOD MODULE(' + %trim(inDDLObjLib) +
                    '/' + %trim(usObjPgmNm) + ') SRCFILE('  +
                    %trim(inDDLMbrLib) + '/QDDLSRC' + ') SRCMBR(' +
                    %trim(usObjSrcMb) + ')';

         //RPGLE module
         When usObjSrcAt = 'RPGLE';                                                      //0001
            uwCmd = 'CRTRPGMOD MODULE(' + %trim(inDDLObjLib) +
                    '/' + %trim(usObjPgmNm) + ') SRCFILE('  +
                    %trim(inDDLMbrLib) + '/QDDLSRC' + ') SRCMBR(' +
                    %trim(usObjSrcMb) + ')';
            //Add binding directory if any
            uwCmd = AddBndDir(usObjPgmNm:uwCmd);

         //SQLRPGLE module
         When usObjSrcAt = 'SQLRPGLE';                                                   //0001
            uwCmd = 'CRTSQLRPGI OBJ(' + %trim(inDDLObjLib) +
                    '/' + %trim(usObjPgmNm) + ') SRCFILE('  +
                    %trim(inDDLMbrLib) + '/QDDLSRC' + ') SRCMBR(' +
                    %trim(usObjSrcMb) + ') OBJTYPE(*MODULE)';
            //Add binding directory if any
            uwCmd = AddBndDir(usObjPgmNm:uwCmd);

         Other;                                                                          //0003
            outStatus  = 'E';                                                            //0003
            //Invalid Source Attribute Or Source is Missing.                            //0003
            iAGetMsg('1':'MSG0208':uwMsgDesc:' ');                                       //0003
            outMessage = %trim(uwMsgDesc);                                               //0003
            uwStatus   = 'W';                                                            //0003
            LeaveSr;                                                                     //0003

      EndSl;

      //To replace if the object already exists
      uwCmd = %trim(uwCmd) + ' REPLACE(*YES)';
      //If module compilation command is successful
      If ExecuteCommand(uwCmd);
         outStatus  = 'S';
         outMessage = *Blanks;
      //If such command fails
      Else;
         outStatus  = 'E';
         uwMsgVars  = %Subst(%trim(uwCmd):1:
                             %scan(' ':%trim(uwCmd))-1);
         //Command failed
         iAGetMsg('1':'MSG0187':uwMsgDesc:uwMsgVars);
         outMessage = %trim(uwMsgDesc);
         uwStatus   = 'W';
      EndIf;

   EndSr;

   //---------------------------------------------------------------------------------//
   //CompileProgram : To compile standalone programs                                  //
   //                 outStatus = 'S' - Compilation Successful                        //
   //                 outStatus = 'E' - Error in Compilation                          //
   //                 uwStatus  = 'W' - Warning to the user in case of Error          //
   //---------------------------------------------------------------------------------//
   BegSr CompileProgram;

      Clear uwCmd;

      Select;
         //Non ILE CL program
         When usObjSrcAt = 'CLP';                                                        //0001
            uwCmd = 'CRTCLPGM PGM(' + %trim(inDDLObjLib) +
                    '/' + %trim(usObjPgmNm) + ') SRCFILE('+
                    %trim(inDDLMbrLib) + '/QDDLSRC) SRCMBR(' +
                    %trim(usObjPgmNm) + ')';

         //ILE CL program
         When usObjSrcAt = 'CLLE';                                                       //0001
            uwCmd = 'CRTBNDCL PGM(' + %trim(inDDLObjLib) +
                    '/' + %trim(usObjPgmNm) + ') SRCFILE('+
                    %trim(inDDLMbrLib) + '/QDDLSRC) SRCMBR(' +
                    %trim(usObjPgmNm) + ')';

         //Non ILE RPG program
         When usObjSrcAt = 'RPG';                                                        //0001
            uwCmd = 'CRTRPGPGM PGM(' + %trim(inDDLObjLib) +
                    '/' + %trim(usObjPgmNm) + ') SRCFILE('+
                    %trim(inDDLMbrLib) + '/QDDLSRC) SRCMBR(' +
                    %trim(usObjPgmNm) + ')';

         //ILE RPG program
         When usObjSrcAt = 'RPGLE';                                                      //0001
            uwCmd = 'CRTBNDRPG PGM(' + %trim(inDDLObjLib) +
                    '/' + %trim(usObjPgmNm) + ') SRCFILE('+
                    %trim(inDDLMbrLib) + '/QDDLSRC) SRCMBR(' +
                    %trim(usObjPgmNm) + ')';

         //Non ILE SQLRPG program
         When usObjSrcAt = 'SQLRPG';                                                     //0001
            uwCmd = 'CRTSQLRPG PGM(' + %trim(inDDLObjLib) +
                    '/' + %trim(usObjPgmNm) + ') SRCFILE('+
                    %trim(inDDLMbrLib) + '/QDDLSRC) SRCMBR(' +
                    %trim(usObjPgmNm) + ')';

         //ILE SQLRPG program
         When usObjSrcAt = 'SQLRPGLE';                                                   //0001
            uwCmd = 'CRTSQLRPGI OBJ(' + %trim(inDDLObjLib) +
                    '/' + %trim(usObjPgmNm) + ') SRCFILE('  +
                    %trim(inDDLMbrLib) + '/QDDLSRC' + ') SRCMBR(' +
                    %trim(usObjSrcMb) + ') OBJTYPE(*PGM)';
            //Add binding directory if any
            uwCmd = AddBndDir(usObjPgmNm:uwCmd);

         Other;
            outStatus  = 'E';
            //Invalid Source Attribute Or Source is Missing.                            //0003
            iAGetMsg('1':'MSG0208':uwMsgDesc:' ');
            outMessage = %trim(uwMsgDesc);
            uwStatus   = 'W';
            LeaveSr;

      EndSl;

      //To replace if the object already exists
      uwCmd = %trim(uwCmd) + ' REPLACE(*YES)';

      //If stand alone program compilation is successful
      If ExecuteCommand(uwCmd);
         outStatus  = 'S';
         outMessage = *Blanks;
      //If such command fails
      Else;
         outStatus  = 'E';
         uwMsgVars  = %Subst(%trim(uwCmd):1:
                             %scan(' ':%trim(uwCmd))-1);
         //Command failed
         iAGetMsg('1':'MSG0187':uwMsgDesc:uwMsgVars);
         outMessage = %trim(uwMsgDesc);
         uwStatus   = 'W';
      EndIf;

   EndSr;

End-Proc;

//------------------------------------------------------------------------------------//
//AddModule : Add Module Programs to compilation if it requires                       //
//------------------------------------------------------------------------------------//
Dcl-Proc AddModule;
   Dcl-Pi AddModule VarChar(1000);
      inObject  Char(10);
      inCommand VarChar(1000);
      inObjTyp  Char(10);
   End-Pi;

   Dcl-S uwChkCmd    Like(uwCommand);
   Dcl-S uwPEPCmd    Like(uwCommand);
   Dcl-S uwIdx       Uns(5);
   Dcl-S uwPEPMod    Char(10) Inz;
   Dcl-S uwPEPLib    Char(10) Inz;

   //Open cursor
   Exec Sql Open CursorModule;
   If SqlCode = CSR_OPN_COD;
      Exec Sql Close CursorModule;
      Exec Sql Open  CursorModule;
   EndIf;

   If SqlCode < SuccessCode;
      uDpsds.wkQuery_Name = 'Open_CursorModule';
      IaSqlDiagnostic(uDpsds);
   EndIf;

   //Get the number of elements
   uwRows = %elem(udModuleDs);

   //Fetch records from CursorModule
   uwRowFound = FetchRecordCursorModule();

   //If atleast one row is found
   If uwRowFound;
      inCommand = %trim(inCommand) + ' MODULE(';
      For uwIdx = 1 To uwRowsFetched;

         uwChkCmd = 'CHKOBJ OBJ(' + %trim(inDDLObjLib) + '/'
                    + %trim(udModuleDs(uwIdx).usName)
                    + ') OBJTYPE(*MODULE)';
         //If the service program is in DDL object library, refer from there
         If ExecuteCommand(uwChkCmd);
            inCommand = %trim(inCommand) + '(' + %trim(inDDLObjLib) +
                        '/' + %trim(udModuleDs(uwIdx).usName) + ')';
         //Else refer from production library
         Else;
            inCommand = %trim(inCommand) + '(' +
                        %trim(udModuleDs(uwIdx).usLib) +
                        '/' + %trim(udModuleDs(uwIdx).usName) + ')';
         EndIf;

         //If Module is Program Entry Procedure Module
         If udModuleDs(uwIdx).usPEP = 'Y';
            //If the service program is in DDL object library, refer from there
            If ExecuteCommand(uwChkCmd);
               uwPEPCmd = %trim(uwPEPCmd) +
                          %trim(inDDLObjLib) +
                           '/' + %trim(udModuleDs(uwIdx).usName) + ')';
            //Else refer from production library
            Else;
               uwPEPCmd = %trim(uwPEPCmd) +
                           %trim(udModuleDs(uwIdx).usLib) +
                           '/' + %trim(udModuleDs(uwIdx).usName) + ')';
            EndIf;
         EndIf;

      EndFor;

      inCommand = %trim(inCommand) + ')';

      //Add PEP Entry
      If uwPEPCmd <> *Blanks and inObjTyp = '*PGM';
        inCommand = %trim(inCommand) + ' ENTMOD(' +  %trim(uwPEPCmd);
      EndIf;

   EndIf;

   //Close CursorModule
   Exec Sql Close CursorModule;

   Return inCommand;

End-Proc;

//------------------------------------------------------------------------------------//
//AddSrvPgm : Add Service Programs to compilation if it requires                      //
//------------------------------------------------------------------------------------//
Dcl-Proc AddSrvPgm;
   Dcl-Pi AddSrvPgm VarChar(1000);
      inObject  Char(10);
      inCommand VarChar(1000);
   End-Pi;

   Dcl-S uwChkCmd    Like(uwCommand);
   Dcl-S uwIdx       Uns(5);

   //Assign input parameter to host variable before opening the cursor
   uwObject = inObject;
   //Open cursor
   Exec Sql Open CursorSrvPgm;
   If SqlCode = CSR_OPN_COD;
      Exec Sql Close CursorSrvPgm;
      Exec Sql Open  CursorSrvPgm;
   EndIf;

   If SqlCode < SuccessCode;
      uDpsds.wkQuery_Name = 'Open_CursorSrvPgm';
      IaSqlDiagnostic(uDpsds);
   EndIf;

   //Get the number of elements
   uwRows = %elem(udSrvPgmDs);

   //Fetch records from CursorSrvPgm
   uwRowFound = FetchRecordCursorSrvPgm();

   //If atleast one row is found
   If uwRowFound;
      inCommand = %trim(inCommand) + ' BNDSRVPGM(';
      For uwIdx = 1 To uwRowsFetched;

         uwChkCmd = 'CHKOBJ OBJ(' + %trim(inDDLObjLib) + '/'
                    + %trim(udSrvPgmDs(uwIdx).usName)
                    + ') OBJTYPE(*SRVPGM)';
         //If the service program is in DDL object library, refer from there
         If ExecuteCommand(uwChkCmd);
            inCommand = %trim(inCommand) + '(' + %trim(inDDLObjLib) +
                        '/' + %trim(udSrvPgmDs(uwIdx).usName) + ')';
         //Else refer from production library
         Else;
            inCommand = %trim(inCommand) + '(' +
                        %trim(udSrvPgmDs(uwIdx).usLib) +
                        '/' + %trim(udSrvPgmDs(uwIdx).usName) + ')';
         EndIf;
      EndFor;
      inCommand = %trim(inCommand) + ')';
   EndIf;

   //Close CursorSrvPgm
   Exec Sql Close CursorSrvPgm;

   Return inCommand;

End-Proc;

//------------------------------------------------------------------------------------//
//AddBndDir : Add Binding Directories to compilation if it requires                   //
//------------------------------------------------------------------------------------//
Dcl-Proc AddBndDir;
   Dcl-Pi AddBndDir VarChar(1000);
      inObject  Char(10);
      inCommand VarChar(1000);
   End-Pi;

   Dcl-S uwChkCmd    Like(uwCommand);
   Dcl-S uwIdx       Uns(5);

   //Assign input parameter to host variable before opening the cursor
   uwObject = inObject;
   //Open cursor
   Exec Sql Open CursorBndDir;
   If SqlCode = CSR_OPN_COD;
      Exec Sql Close CursorBndDir;
      Exec Sql Open  CursorBndDir;
   EndIf;

   If SqlCode < SuccessCode;
      uDpsds.wkQuery_Name = 'Open_CursorBndDir';
      IaSqlDiagnostic(uDpsds);
   EndIf;

   //Get the number of elements
   uwRows = %elem(udBndDirDs);

   //Fetch records from CursorBndDir
   uwRowFound = FetchRecordCursorBndDir();

   //If atleast one row is found
   If uwRowFound;
      //If it is SQLRPGLE, the binding directories are bound in compile options
      If usObjSrcAt = 'SQLRPGLE';                                                        //0001
         inCommand = %trim(inCommand) + ' COMPILEOPT('+ '''';
         //If it is *PGM type, DFTACTGRP(*NO) is must before adding BNDDIRs
         If usObjPgmTy = '*PGM';
            inCommand = %trim(inCommand) + 'DFTACTGRP(*NO)';
         EndIf;
      EndIf;

      inCommand = %trim(inCommand) + ' BNDDIR(';
      For uwIdx = 1 To uwRowsFetched;

         uwChkCmd = 'CHKOBJ OBJ(' + %trim(inDDLObjLib) + '/'
                    + %trim(udBndDirDs(uwIdx).usName)
                    + ') OBJTYPE(*BNDDIR)';
         //If the binding directory is in DDL object library, refer from there
         If ExecuteCommand(uwChkCmd);
            inCommand = %trim(inCommand) + '(' + %trim(inDDLObjLib) +
                        '/' + %trim(udBndDirDs(uwIdx).usName) + ')';
         //Else refer it from production library
         Else;
            inCommand = %trim(inCommand) + '(' +
                        %trim(udBndDirDs(uwIdx).usLib) +
                        '/' + %trim(udBndDirDs(uwIdx).usName) + ')';
         EndIf;

      EndFor;
      inCommand = %trim(inCommand) + ')';

      If usObjSrcAt = 'SQLRPGLE';                                                        //0001
         inCommand = %trim(inCommand) + '''' + ')';
      EndIf;
   EndIf;

   //Close CursorBndDir
   Exec Sql Close CursorBndDir;

   Return inCommand;

End-Proc;

//-------------------------------------------------------------------------------------//
//FetchRecordCursorLibl : Fetch library list of repo from cursor                       //
//-------------------------------------------------------------------------------------//
Dcl-Proc FetchRecordCursorLibL;

   Dcl-Pi FetchRecordCursorLibL Ind;
   End-Pi;

   Dcl-S uwRcdFound  Ind  Inz;

   //Fetch number of rows from IAINPLIB that the array DS can hold
   Exec Sql
      Fetch CursorLibL For :uwRows Rows Into
              :udLibDs;

   If SqlCode < SuccessCode;
         uDpsds.wkQuery_Name = 'Fetch_LibraryList';
         IaSqlDiagnostic(uDpsds);
   EndIf;

   //If the fetch is succesful, get how many rows are fetched
   If Sqlcode = SuccessCode;
      Exec Sql Get Diagnostics
           :uwRowsFetched = ROW_COUNT;
   Else;
      uwRowsFetched = 0;
   EndIf;

   //If atleast one row is fetched
   If uwRowsFetched > 0;
      uwRcdFound = TRUE;
   //If zero rows are fetched
   Else;
      uwRcdFound = FALSE;
   EndIf;

   Return uwRcdFound;

End-Proc;

//-------------------------------------------------------------------------------------//
//FetchRecordCursorModObjList : To Fetch *Module Objects from IADDSDDLPP File          //
//-------------------------------------------------------------------------------------//
Dcl-Proc FetchRecordCursorModObjList;

   Dcl-Pi *N Ind;
   End-Pi;

   Dcl-S uwRcdFound  ind  inz;

   //Fetch dependent objects one by one
   Exec Sql
      Fetch CursorModObjList into :udDepObjList;

   If SqlCode < SuccessCode;
         uDpsds.wkQuery_Name = 'Fetch_ModObjList';
         IaSqlDiagnostic(uDpsds);
   EndIf;

   //If the fetch was successful
   If SqlCode = SuccessCode;
      uwRcdFound = TRUE;
   //If there are no more records to fetch
   Else;
      uwRcdFound = FALSE;
   EndIf;

   Return uwRcdFound;

End-Proc;

//-------------------------------------------------------------------------------------//
//FetchRecordCursorSrvPgmObjList : To Fetch *SrvPgm Objects from IADDSDDLPP File       //
//-------------------------------------------------------------------------------------//
Dcl-Proc FetchRecordCursorSrvPgmObjList;

   Dcl-Pi *N Ind;
   End-Pi;

   Dcl-S uwRcdFound  ind  inz;

   //Fetch dependent objects one by one
   Exec Sql
      Fetch CursorSrvPgmObjList into :udDepObjList;

   If SqlCode < SuccessCode;
         uDpsds.wkQuery_Name = 'Fetch_SrvPgmObjList';
         IaSqlDiagnostic(uDpsds);
   EndIf;

   //If the fetch was successful
   If SqlCode = SuccessCode;
      uwRcdFound = TRUE;
   //If there are no more records to fetch
   Else;
      uwRcdFound = FALSE;
   EndIf;

   Return uwRcdFound;

End-Proc;

//-------------------------------------------------------------------------------------//
//FetchRecordCursorPgmObjList : To Fetch *Pgm Objects from IADDSDDLPP File             //
//-------------------------------------------------------------------------------------//
Dcl-Proc FetchRecordCursorPgmObjList;

   Dcl-Pi *N Ind;
   End-Pi;

   Dcl-S uwRcdFound  ind  inz;

   //Fetch dependent objects one by one
   Exec Sql
      Fetch CursorPgmObjList into :udDepObjList;

   If SqlCode < SuccessCode;
         uDpsds.wkQuery_Name = 'Fetch_PgmObjList';
         IaSqlDiagnostic(uDpsds);
   EndIf;

   //If the fetch was successful
   If SqlCode = SuccessCode;
      uwRcdFound = TRUE;
   //If there are no more records to fetch
   Else;
      uwRcdFound = FALSE;
   EndIf;

   Return uwRcdFound;

End-Proc;

//-------------------------------------------------------------------------------------//
//FetchRecordCursorModule : To fetch bound Module Programs                             //
//-------------------------------------------------------------------------------------//
Dcl-Proc FetchRecordCursorModule;

   Dcl-Pi FetchRecordCursorModule Ind;
   End-Pi;

   Dcl-S uwRcdFound  Ind  Inz;

   //Fetch number of rows from IAPGMINF that the array DS can hold
   Exec Sql
      Fetch CursorModule For :uwRows Rows Into
              :udModuleDs;

   If SqlCode < SuccessCode;
      uDpsds.wkQuery_Name = 'Fetch_ModulePgm';
      IaSqlDiagnostic(uDpsds);
   EndIf;

   //If the fetch is succesful, get how many rows are fetched
   If Sqlcode = SuccessCode;
      Exec Sql Get Diagnostics
           :uwRowsFetched = ROW_COUNT;
   Else;
      uwRowsFetched = 0;
   EndIf;

   //If atleast one row is fetched
   If uwRowsFetched > 0;
      uwRcdFound = TRUE;
   //If zero rows are fetched
   Else;
      uwRcdFound = FALSE;
   EndIf;

   Return uwRcdFound;

End-Proc;

//-------------------------------------------------------------------------------------//
//FetchRecordCursorSrvPgm : To fetch bound Service Programs                            //
//-------------------------------------------------------------------------------------//
Dcl-Proc FetchRecordCursorSrvPgm;

   Dcl-Pi FetchRecordCursorSrvPgm Ind;
   End-Pi;

   Dcl-S uwRcdFound  Ind  Inz;

   //Fetch number of rows from IAPGMINF that the array DS can hold
   Exec Sql
      Fetch CursorSrvPgm For :uwRows Rows Into
              :udSrvPgmDs;

   If SqlCode < SuccessCode;
      uDpsds.wkQuery_Name = 'Fetch_BndSrvPgm';
      IaSqlDiagnostic(uDpsds);
   EndIf;

   //If the fetch is succesful, get how many rows are fetched
   If Sqlcode = SuccessCode;
      Exec Sql Get Diagnostics
           :uwRowsFetched = ROW_COUNT;
   Else;
      uwRowsFetched = 0;
   EndIf;

   //If atleast one row is fetched
   If uwRowsFetched > 0;
      uwRcdFound = TRUE;
   //If zero rows are fetched
   Else;
      uwRcdFound = FALSE;
   EndIf;

   Return uwRcdFound;

End-Proc;

//-------------------------------------------------------------------------------------//
//FetchRecordCursorBndDir : To fetch bound Service Programs                            //
//-------------------------------------------------------------------------------------//
Dcl-Proc FetchRecordCursorBndDir;

   Dcl-Pi FetchRecordCursorBndDir Ind;
   End-Pi;

   Dcl-S uwRcdFound  Ind  Inz;

   //Fetch number of rows from IAALLREFPF that the array DS can hold
   Exec Sql
      Fetch CursorBndDir For :uwRows Rows Into
              :udBndDirDs;

   If SqlCode < SuccessCode;
      uDpsds.wkQuery_Name = 'Fetch_BndBndDir';
      IaSqlDiagnostic(uDpsds);
   EndIf;

   //If the fetch is succesful, get how many rows are fetched
   If Sqlcode = SuccessCode;
      Exec Sql Get Diagnostics
         :uwRowsFetched = ROW_COUNT;
   Else;
      uwRowsFetched = 0;
   EndIf;

   //If atleast one row is fetched
   If uwRowsFetched > 0;
      uwRcdFound = TRUE;
   //If zero rows are fetched
   Else;
      uwRcdFound = FALSE;
   EndIf;

   Return uwRcdFound;

End-Proc;

//------------------------------------------------------------------------------------//
//CompileDDL : To compile created DDL members of PFs and LFs                          //
//            outStatus = 'S' - Compilation Successful                                //
//            outStatus = 'E' - Error in Compilation                                  //
//            uwStatus  = 'W' - Warning to the user in case of Error                  //
//------------------------------------------------------------------------------------//
Dcl-Proc CompileDDL;

   Dcl-Pi CompileDDL;
      inMember Char(10);
   End-Pi;

   Clear uwDDLObjLb;
   Clear uwDDLObjNm;
   Clear uwDDLObjTy;
   Clear uwDDLObjAt;

   //Prepare RUNSQLSTM command to compile DDL member
   uwCommand = 'RUNSQLSTM SRCFILE('       +
               %trim(wkDdlSrcLb) + '/'   +
               'QDDLSRC) SRCMBR('         +
               %trim(inMember) + ') '     +
               'COMMIT(*NONE) MARGINS(92)'+
               ' DFTRDBCOL('              +
               %trim(wkDdlObjLb) + ')'   ;

   //If RUNSQLSTM command is successful
   If ExecuteCommand(uwCommand);
      outStatus  = 'S';
      outMessage = *Blanks;
      uwDDLObjLb = wkDdlObjLb;
      uwDDLObjNm = wkDdlObjNm;
      uwDDLObjTy = '*FILE';

      //Retrive Object Attribute when new DDL object created
      Clear qUsrObjDS;
      CallP qUsrObjd(qUsrObjDS
                     :%Len(qUsrObjDS)
                     :'OBJD0200'
                     :uwDDLObjNm + uwDDLObjLb
                     :uwDDLObjTy
                     :ApiErrDS);

      uwDDLObjAt = qUsrObjDS.ExtendedAttr;

      Clear uwDdlRcdid;                                                                  //0007
      //Get DDL Record format Identifier                                                //0007
      uwDdlRcdId = GetDdlRcdIdentifier(wkDdlObjNm:wkDdlObjLb);                           //0007

   //If the command fails
   Else;
      outStatus  = 'E';
      //DDL member compilation failed
      iAGetMsg('1':'MSG0189':uwMsgDesc:' ');
      outMessage = %trim(uwMsgDesc);
      uwStatus   = 'W';
      uwDDLFail = *On;                                                                   //0004
   EndIf;

End-Proc;

// ------------------------------------------------------------------------------------- //
//GetExportSourceDetails : To get Export Source details of Service Program              //
// ------------------------------------------------------------------------------------- //
Dcl-Proc GetExportSourceDetails;

   Clear wkExportSourceFile;
   Clear wkExportSourceLib;
   Clear wkExportSourceMem;

   GetSrvPgmInf (wkSrvPgmInfo : 5444 : 'SPGI0100' :
                 usObjPgmNm + usObjPgmLb : wkErrorInfo );

   wkExportSourceFile = %SubSt(wkSrvPgmInfo : 62 : 10);
   wkExportSourceLib  = %SubSt(wkSrvPgmInfo : 72 : 10);
   wkExportSourceMem  = %SubSt(wkSrvPgmInfo : 82 : 10);

End-Proc;

// ------------------------------------------------------------------------------------- //
//GetObjectText : To get Object Text                                                    //
// ------------------------------------------------------------------------------------- //
Dcl-Proc GetObjectText;

   Clear wkObjectText;

   Exec Sql
      Select iATxtDes into :wkObjectText
        From iAObject
       Where iALibNam = :usObjPgmLb
         And iAObjNam = :usObjPgmNm
         And iAObjTyp = :usObjPgmTy;

End-Proc;

//------------------------------------------------------------------------------------//
//ExecuteCommand : To execute compile commands and return errors if any               //
//------------------------------------------------------------------------------------//
Dcl-Proc ExecuteCommand;
   Dcl-Pi ExecuteCommand Ind;
      inCommand Char(1000) Options(*varsize) Const;
   End-Pi;

   Monitor;
      //Run CL command
      RunCmd(inCommand : %len(%trim(inCommand)));
   On-Error;
      //In case the command fails
      Return *Off;
   EndMon;

   Return *On;

End-Proc;

//--------------------------------------------------------------------------------------//
//UpdateCompilationStatus : To update compile status of respective objects              //
//--------------------------------------------------------------------------------------//
Dcl-Proc UpdateCompilationStatus;

   //Update current row with compilation status in IADDSDDLDP File
   If inCompilationObj = 'F';
      Exec Sql
         Update IADDSDDLDP
            Set iADdlObjAt   = :uwDDLObjAt,                                              //0005
                iADdlObjTy   = :uwDDLObjTy,
                iADdlFmtID   = :uwDdlRcdId,                                              //0007
                iAConvSts    = :outStatus,
                iAErrMsg     = :outMessage,                                              //0005
                iAUpdPgm     = 'IADDSDDLCM',
                iAUpdUser    = :inRequestedUser
          Where iAReqId    = :inReqId
            and iADdsObjLb = :inDDSLibrary
            and iADdsObjNm = :inDDSObjNam
            and iADdsObjAt = :inDDSObjAttr                                               //0006
            and iADdsMbrNm = :inDDSMbrName                                               //0006
            and iADdsRcdFm = :inDDSRcdFmt                                                //0006
            and iADdlSrcMb = :inDDLMbrNam                                                //0006
            and iADdlObjNm = :inDDLObjNam;                                               //0006

      If SqlCode < SuccessCode;
         uDpsds.wkQuery_Name = 'Update_IADDSDDLDP';
         IaSqlDiagnostic(uDpsds);
      EndIf;
   //Update current row with compilation status in IADDSDDLPP File
   ElseIf inCompilationObj = 'P';
      Select;
         When usObjPgmTy = '*MODULE';
            Exec Sql
               Update IADDSDDLPP
                  Set iACmplSts = :outStatus,
                      iACmplMsg = :outMessage,
                      iAUpdPgm  = 'IADDSDDLCM',
                      iAUpdUser = :inRequestedUser
                Where Current Of CursorModObjList;
         When usObjPgmTy = '*SRVPGM';
            Exec Sql
               Update IADDSDDLPP
                  Set iACmplSts = :outStatus,
                      iACmplMsg = :outMessage,
                      iAUpdPgm  = 'IADDSDDLCM',
                      iAUpdUser = :inRequestedUser
                Where Current Of CursorSrvPgmObjList;
         When usObjPgmTy = '*PGM';
            Exec Sql
               Update IADDSDDLPP
                  Set iACmplSts = :outStatus,
                      iACmplMsg = :outMessage,
                      iAUpdPgm  = 'IADDSDDLCM',
                      iAUpdUser = :inRequestedUser
                Where Current Of CursorPgmObjList;
         Other;
     EndSl;

     If SqlCode < SuccessCode;
        uDpsds.wkQuery_Name = 'Update_IADDSDDLPP';
        IaSqlDiagnostic(uDpsds);
     EndIf;
   EndIf;

End-Proc;
// ------------------------------------------------------------------------------------- //
//GetDdlRcdIdentifier : To get DDL object Record Format Identifier                      //
// ------------------------------------------------------------------------------------- //
Dcl-Proc GetDdlRcdIdentifier;                                                            //0007

   Dcl-Pi GetDdlRcdIdentifier Char(13);                                                  //0007
      upDdlObjName  Char(10);                                                            //0007
      upDdlObjLib   Char(10);                                                            //0007
   End-Pi;                                                                               //0007

   Dcl-S uwDdlRcdIdent Char(13) Inz;                                                     //0007

   uwCommand = 'DSPFD FILE(' + %Trim(upDdlObjLib) +                                      //0007
               '/' + %Trim(upDdlObjName)          +                                      //0007
               ') TYPE(*RCDFMT) OUTPUT(*OUTFILE) '+                                      //0007
               'OUTFILE(QTEMP/QAFDRFMT) '        +                                       //0007
               'OUTMBR(*FIRST *REPLACE)';                                                //0007

   If not ExecuteCommand(uwCommand);                                                     //0007
      uwDdlRcdIdent= ' ';                                                                //0007
   Else;                                                                                 //0007
      Exec sql                                                                           //0007
        Select Rfid into :uwDdlRcdIdent                                                  //0007
          From Qtemp/QAFDRFMT                                                            //0007
         fetch first row only ;                                                          //0007

      If Sqlcode <> SuccessCode;                                                         //0007
         uDpsds.wkQuery_Name = 'Fetch_DdlRcdIdentifier';                                 //0007
         IaSqlDiagnostic(uDpsds);                                                        //0007
         uwDdlRcdIdent= ' ';                                                             //0007
      EndIf;                                                                             //0007
   EndIf;                                                                                //0007

   Return uwDdlRcdIdent;                                                                 //0007

End-Proc;                                                                                //0007
