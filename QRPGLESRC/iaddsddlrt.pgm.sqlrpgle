**free
      //%METADATA                                                      *
      // %TEXT IA - DDStoDDL Retrieve Dependent Files/Pgms             *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------- //
//Created By  : Programmers.io @ 2024                                                   //
//Created Date: 2024/04/16                                                              //
//Developer   : Programmers.io                                                          //
//Description : This program will retrieve all dependent files/programs of DDS object   //
//              and return parameter outStatus has below values:                        //
//              'E' = Error                                                             //
//              'S' = Successfull                                                       //
//                                                                                      //
//                       Input Parameters:                                              //
//              inReqId          -  Request Id                                          //
//              inRepo           -  Repo Name                                           //
//              inDDSObjNam      -  DDS Object Name                                     //
//              inDDSLibrary     -  DDS Object Library                                  //
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
//RetrieveAllPFObj                  | Retrieve all the PF data objects                  //
//RetrieveAllLFObj                  | Retrieve all the LF data Objects                  //
//RetrieveInputObj                  | Retrieve Input Object                             //
//RetrieveDependentFileList         | To process dependent files of DDS object          //
//DDLSourceCreation                 | DDL Source Creation                               //
//CopyDataDDStoDDL                  | To Copy Data from PF to corresponding DDL         //
//FetchCursorFileField              | To fetch the file field details                   //
//RetrieveDependentPgms             | To process dependent programs                     //
//RtvSrcDetails                     | To get source details from IAOBJMAP               //
//RtvStandaloneProgramInfo          | To get the Standalone Program Information         //
//RtvModuleInfo                     | To get the Module Information                     //
//CopyDependentPgmsToDDLLib         | To copy dependent program source to DDL Library   //
//FetchCursorDependentFiles         | To fetch Dependent Files                          //
//FetchCursorDependentPrograms      | To fetch Dependent Programs                       //
//FetchCursorAllPfObjects           | To fetch all the PF data objects                  //
//FetchCursorAllObjects             | To fetch all the data objects                     //
//ClearModuleVariables              | To clear the variables used to get module info    //
//ClearWriteVariables               | To Clear variables used in Write procedure        //
//RunCmd                            | To execute the command                            //
//isSqlFile                         | To check Object is Table, Index or View           //
//WriteiADdsDdlDP                   | Write Record Into IADDSDDLDP                      //
//WriteDDSDepPgmFile                | To populate IADDSDDLPP file                       //
//ProcessMultiRcdFmtAndMultiMbrFile | Process Multi Record Format/Multi Member File     //
//addMbrsForSlectedRcdFmt           | Add members for selected record format            //
//FetchCursorRecordFormat           | To fetch all record format information of file    //
//FetchCursorFileMember             | To Fetch all member information of file           //
//SetEnvForCompilation              | To fetch Repo libraries and set environment for   //
//                                  | compilation                                       //
//FetchRecordCursorLibl             | Fetch library list of repo from cursor            //
//parentPFObjCreated                | Check if for given LFs all parent PFs are created //
//RetrieveLFParentPF                | Fetch Parent PFs for given LFs                    //
//chkValidFileForConv               | Check valid file for conversion or not            //
//GenerateFileName                  | Generate the file name of Multi Record format or  //
//                                  | Multi Member File                                 //
//chkFileFldForAllRcdFmt            | Check file field is same for all record format in //
//                                  | case of MRF                                       //
//------------------------------------------------------------------------------------- //
//                                                                                      //
//Modification Log:                                                                     //
//------------------------------------------------------------------------------------- //
//Date-DMY| ModID  | Developer  | Case and Description                                  //
//--------|--------|------------|------------------------------------------------------ //
//19/09/24| 0001   |Piyush Kumar|Task#953 - Existing Table Drop in the DDL Object Lib   //
//19/09/24| 0002   |K Abhishek A|Task#952 - To populate Object Attribute and Source     //
//        |        |            |Attribute correctly in IADDSDDLPP.                     //
//24/09/24| 0003   |Dada Bachute|Task#958 - Handle the error message for the Same       //
//        |        |            |Library list setup more than once during compilation.  //
//08/10/24| 0004   |Piyush Kumar|Task#1005 - Drop existing table should be on DDL Object//
//        |        |            |and removed wkDDLLngNam field which is not used.       //
//        |        |            |Drop Index and View when single file requested.        //
//15/10/24| 0005   |Piyush Kumar|Task#1015 - When *SAME Passed for DDL Src,Obj,Lng Name //
//        |        |            |1.DDL Src name should be populated with DDS Object Name//
//        |        |            |2.DDL Obj name should be populated with DDS Object Name//
//        |        |            |3.DDL Lng name should be blank                         //
//        |        |            |DDL long name should be blankk for Bulk File Conversion//
//21/10/24| 0006   |K Abhishek A|Task#1038 - Added the functionality to copy PF data to //
//        |        |            |its corresponding DDL file.                            //
//25/10/24| 0007   |Manav T.    |Task#1041- DDS to DDL:Join LF validation while         //
//        |        |            |conversion as dependnet file.                          //
//        |        |Piyush Kumar|Task#1055 - MultiMember, Multi Record Format source    //
//        |        |            |should not be added in DDL Source Library.             //
//        |        |            |- Changing field name from iACmplMsg to iAErrMsg for   //
//        |        |            |iADdsDdlDP & iADdsDdlDH File.                          //
//28/10/24| 0008   |Piyush Kumar|Task#1016 - Archeive Process when same request comes.  //
//        |        |            |- Archieve the old record from IADDSDDLHP File to      //
//        |        |            |  IADDSDDLAP File                                      //
//        |        |            |- Remove the old sources and objects from DDL Lib.     //
//        |        |            |- Remove the old records from IADDSDDLDP & IADDSDDLPP. //
//        |        |            |- Restructure library list setup during compilation.   //
//        |        |            |- Commenting as we moved changed to new pgm IADSSDDLAP.//
//29/10/24| 0009   |Piyush Kumar|Task#1020 - When Physical file have different DDL      //
//        |        |            |object name then dependent file should be depend on    //
//        |        |            |the DDL object name not on DDS object name.            //
//06/11/24| 0010   |Piyush Kumar|Task#1056 - Changed the field name and text            //
//06/11/24| 0011   |Manav T.    |Task#1057- DDStoDDL - Error Message Return to SP       //
//07/11/24| 0012   |Kaushal     |Task#1038 - Query changes with proper selection of     //
//        |        |kumar       |fields.                                                //
//07/11/24| 0013   |Sasikumar R |Task#1053 - The DDL Source Text should be from DDS     //
//        |        |            |Source Text.                                           //
//03/12/24| 0014   |Piyush Kumar|Task#1072 - Multi Record Format and Multi Member File  //
//        |        |            |Added New Procedure:                                   //
//        |        |            |1.FetchCursorFileField - Get File Field Details        //
//        |        |            |2.ProcessMultiRcdFmtAndMultiMbrFile - Adding MRF/MMF   //
//        |        |            |3.addRcdFmtAllMbr - Create record for MRF/MMF          //
//        |        |            |4.FetchCursorRecordFormat - Retrive Record Format info //
//        |        |            |5.FetchCursorFileMember - Retrive Member Details       //
//        |        |            |6.GenerateFileName - Generate name for MRF/MMF         //
//        |        |            |7.chkFileFldForAllRcdFmt - Comparing Field of MRF File //
//20/11/24| 0015   |Piyush Kumar|Task#1021 - DDL member name should be same as DDS      //
//        |        |            |member name when *SAME passed as input in DDL member   //
//        |        |            |- For the DDS dependent files DDL member name will be  //
//        |        |            |same as DDS member name                                //
//        |        |            |- For the Bulk case DDL member name will be same DDS   //
//        |        |            |member name                                            //
//        |        |            |- Populated DDS source information in IADDSDDLDP file  //
//------------------------------------------------------------------------------------- //
Ctl-Opt CopyRight('Copyright @ Programmers.io © 2024');
Ctl-Opt Option(*NoDebugIo:*SrcStmt:*NoUnRef);
Ctl-Opt BndDir('IABNDDIR' : 'IAERRBND');
Ctl-Opt ActGrp(*Caller);

//------------------------------------------------------------------------------------- //
//Standalone Variables                                                                  //
//------------------------------------------------------------------------------------- //
Dcl-S wkError                Char(1)        Inz;
Dcl-S wkBlanks               Char(1)        Inz;
Dcl-S wkErrorInfo            Char(1070)     Inz;
Dcl-S wkMsgDesc              Char(1000)     Inz;
Dcl-S wkMsgVars              Char(80)       Inz;
Dcl-S wkCommand              Varchar(1000)  Inz;
Dcl-S wKConvSts              Char(1)        Inz('C');

Dcl-S wkDDSObjNam            Char(10)       Inz;
Dcl-S wkDDSObjLib            Char(10)       Inz;
Dcl-S wkDDSObjType           Char(10)       Inz;
Dcl-S wkDDSObjAttr           Char(10)       Inz;
Dcl-S wkObjDepNam            Char(10)       Inz;
Dcl-S wkObjDepLib            Char(10)       Inz;
Dcl-S wkObjDepType           Char(10)       Inz;
Dcl-S wkObjDepAttr           Char(10)       Inz;
Dcl-S wkObjSrcFile           Char(10)       Inz;
Dcl-S wkObjSrcLib            Char(10)       Inz;
Dcl-S wkObjSrcMem            Char(10)       Inz;
Dcl-S wkObjSrcAttr           Char(10)       Inz;
Dcl-S wkObjAttr              Char(10)       Inz;
Dcl-S wkObjType              Char(10)       Inz('*FILE');
Dcl-S wkDependentFile        Char(10)       Inz;
Dcl-S wkDependentLib         Char(10)       Inz;
Dcl-S wkDependentAttr        Char(10)       Inz;
Dcl-S wkDependentType        Char(10)       Inz;
Dcl-S wkDependentText        Char(50)       Inz;
Dcl-S wkDependentObjName     Char(10)       Inz;
Dcl-S wkDependentObjLibrary  Char(10)       Inz;
Dcl-S wkDependentObjType     Char(10)       Inz;
Dcl-S wkDependentObjAttr     Char(10)       Inz;
Dcl-S wkProgramName          Char(10)       Inz;
Dcl-S wkProgramLibrary       Char(10)       Inz;
Dcl-S wkProgramType          Char(10)       Inz;
Dcl-S wkProgramAttr          Char(10)       Inz;
Dcl-S wkModuleName           Char(10)       Inz;
Dcl-S wkModuleLibrary        Char(10)       Inz;
Dcl-S wkModuleType           Char(10)       Inz;
Dcl-S wkSourceFile           Char(10)       Inz;
Dcl-S wkSourceLibrary        Char(10)       Inz;
Dcl-S wkSourceMember         Char(10)       Inz;
Dcl-S wkModuleAttribute      Char(10)       Inz;
Dcl-S wkModuleProgramName    Char(10)       Inz;
Dcl-S wkModuleProgramLibrary Char(10)       Inz;
Dcl-S wkModuleProgramType    Char(10)       Inz;
Dcl-S wkModuleProgramAttr    Char(10)       Inz;
Dcl-S wkDDLSrcNm             Char(10)       Inz;
Dcl-S wkDDLObjNm             Char(10)       Inz;
Dcl-S wkDDLLngNm             Char(128)      Inz;
Dcl-S wkDDLMbrNm             Char(10)       Inz;
Dcl-S wkDepObjNm             Char(10)       Inz;
Dcl-S wkDepObjAttr           Char(10)       Inz;
Dcl-S wkDDLMemberLibrary     Char(10)       Inz;
Dcl-S wkCompilationObj       Char(1)        Inz;
Dcl-S wkSrcType              Char(10)       Inz;
Dcl-S wKSrcObjType           Char(1)        Inz;
Dcl-S wkIncludeAudCols       Char(1)        Inz;                                         //0006
Dcl-S wkFileCnvSts           Char(1)        Inz('P');                                    //0007
Dcl-S wkFileCnvMsg           Char(80)       Inz;                                         //0007
Dcl-S wkFileName             Char(10)       Inz;                                         //0007
Dcl-S wkBasedPF              Char(10)       Inz;                                         //0009
Dcl-S wkObjLib               Char(10)       Inz;                                         //0014
Dcl-S wkObjName              Char(10)       Inz;                                         //0014
Dcl-S wkFileType             Char(3)        Inz;                                         //0014
Dcl-S wkMbrName              Char(10)       Inz;                                         //0014
Dcl-S wkRcdFmt               Char(10)       Inz;                                         //0014
Dcl-S wkFmtLvlID             Char(13)       Inz;                                         //0014
Dcl-S wkJoinFile             Char(13)       Inz;                                         //0014
Dcl-S wkSrcAtr               Char(10)       Inz;                                         //0014

Dcl-S uiDependentFilesIdx    Uns(5)         Inz;
Dcl-S uiDependentPgmsIdx     Uns(5)         Inz;
Dcl-S uiSelPfObjIdx          Uns(5)         Inz;
Dcl-S uiSelObjIdx            Uns(5)         Inz;
Dcl-S uiFileObjIdx           Uns(5)         Inz;
Dcl-S uiRcdFmtIdx            Uns(5)         Inz;                                         //0014
Dcl-S uiFileMbrIdx           Uns(5)         Inz;                                         //0014
Dcl-s uiFldIdx               Uns(5)         Inz;                                         //0014

Dcl-S DepFilesFetched        Uns(5)         Inz;
Dcl-S DepPgmsRowsFetched     Uns(5)         Inz;
Dcl-S OtherModRowsFetched    Uns(5)         Inz;
Dcl-S ModRefPgmsRowsFetched  Uns(5)         Inz;
Dcl-S SelectedPfObjFetched   Uns(5)         Inz;
Dcl-S SelectedObjFetched     Uns(5)         Inz;
Dcl-S FileObjRowsFetched     Uns(5)         Inz;
Dcl-S RecordFormatFetched    Uns(5)         Inz;                                         //0014
Dcl-S FileMemberFetched      Uns(5)         Inz;                                         //0014
Dcl-S FileFieldFetched       Uns(5)         Inz;                                         //0014

Dcl-S noOfRows               Uns(5)         Inz;
Dcl-S wkDependentFilesCount  Uns(5)         Inz;
Dcl-S wkStandalonePgmCount   Uns(5)         Inz;
Dcl-S wkDependentPgmCount    Uns(5)         Inz;
Dcl-S wkDependentFileCount   Uns(5)         Inz;
Dcl-S wkTotalRecords         Uns(5)         Inz;                                         //0011
Dcl-S wkRcdFrmtCount         Uns(5)         Inz;                                         //0007
Dcl-S noOfRcdFmt             Uns(5)         Inz;                                         //0014
Dcl-S noOfMbr                Uns(5)         Inz;                                         //0014
Dcl-s noOfFld                Uns(5)         Inz;                                         //0014

Dcl-S rcdFound               Ind            Inz;
Dcl-S rowFound               Ind            Inz;
Dcl-S uwRowFound             Ind            Inz;                                         //0003
Dcl-S parFileCmpErr          Ind            Inz(*Off);                                   //0007
Dcl-S uwMRFUnionFlg          Ind            Inz(*Off);                                   //0014
Dcl-S uwMMFUnionFlg          Ind            Inz(*Off);                                   //0014

Dcl-S wkOutStatus            Char(1)        Inz;
Dcl-S wkOutMessage           Char(80)       Inz;

Dcl-S uwRowsFetched          Uns(5)         Inz;                                         //0003
Dcl-S uwRows                 Uns(5)         Inz;                                         //0003

//------------------------------------------------------------------------------------- //
//Constant Variables                                                                    //
//------------------------------------------------------------------------------------- //
Dcl-C TRUE            '1';
Dcl-C FALSE           '0';
Dcl-C Squote          '''';
Dcl-C DSquote         '''''';                                                            //0013

//------------------------------------------------------------------------------------- //
//Array Declarations                                                                    //
//------------------------------------------------------------------------------------- //
Dcl-S CnvCmpErrArray         Uns(5)         dim(2)     Inz;                              //0011

//------------------------------------------------------------------------------------- //
//Datastructure Definitions                                                             //
//------------------------------------------------------------------------------------- //

//Datastructure for all the PF data objects selected from IAOBJECT File
Dcl-Ds udAllPfObjs Qualified Dim(99);                                                    //0014
   usObjectName Char(10);
End-Ds;

//Datastructure for all the data objects selected from IADDSDDLDP File
Dcl-Ds udAllObjs Qualified Dim(99);                                                      //0014
   usObjLib  Char(10);
   usObjName Char(10);
   usObjAttr Char(10);
   usFileTyp Char(3);                                                                    //0014
   usMbrName Char(10);                                                                   //0014
   usRcdFmt  Char(10);                                                                   //0014
   usSrcNam  Char(10);
   usObjNam  Char(10);
   usObjLngN Char(128);
   usBasedPF Char(10);
   usSrcAtr  Char(10);                                                                   //0014
End-Ds;

//Datastructure for the Dependent Files
Dcl-Ds udDependentFiles Qualified Dim(99);                                               //0014
   usDependentFile     Char(10);
   usDependentLibrary  Char(10);
End-Ds;

//Datastructure for the Dependent Programs
Dcl-Ds udDependentPrograms Qualified Dim(99);                                            //0014
   usDependentObjName    Char(10);
   usDependentObjLibrary Char(10);
   usDependentObjType    Char(10);
   usDependentObjAttr    Char(10);
End-Ds;

//Data Structure to hold repo libraries                                                 //0003
Dcl-Ds udLibDs  Dim(9) Qualified;                                                        //0014
   usLib        Char(10);                                                                //0003
End-Ds;                                                                                  //0003

//Data Structure to hold File Fields                                                    //0006
Dcl-Ds udFileField Dim(99) Qualified;                                                    //0014
   usFldInt      Char(10);                                                               //0014
   usRcdFmtL     Packed(5:0);                                                            //0014
   usFldByte     Packed(5:0);                                                            //0014
   usFldDigit    Packed(2:0);                                                            //0014
   usFldPos      Packed(2:0);                                                            //0014
End-Ds;                                                                                  //0006

//Data Structure to hold File Fields                                                    //0014
Dcl-Ds udMRFField LikeDs(udFileField) Dim(99);                                           //0014

//Data Structure to get the record format information from IDSPFDRFMT file              //0014
Dcl-Ds udRcdFmtDs Dim(9) Qualified;                                                      //0014
   usRcdFmt     Char(10);                                                                //0014
   usFmtLvlID   Char(13);                                                                //0014
End-Ds;                                                                                  //0014

//Data Structure to get the file member information from IDSPFDMBR file                 //0014
Dcl-Ds udFileMbrDs Dim(19) Qualified;                                                    //0014
   usMbrName    Char(10);                                                                //0014
   usJoinFlg    Char(1);                                                                 //0014
   usNoOfMbr    Packed(5:0);                                                             //0014
End-Ds;                                                                                  //0014

//Data Structure to get the source info from iaObjMap for the object                    //0013
Dcl-Ds udObjMapDs Qualified Inz;                                                         //0013
   usMbrLib   Char(10);                                                                  //0013
   usMbrSrcf  Char(10);                                                                  //0013
   usMbrNam   Char(10);                                                                  //0013
   usMbrTyp   Char(10);                                                                  //0013
End-Ds;                                                                                  //0013

//------------------------------------------------------------------------------------- //
//Prototype Definitions                                                                 //
//------------------------------------------------------------------------------------- //
Dcl-Pr IADDSDDLSC ExtPgm('IADDSDDLSC');
   inReqId           Char(18);
   inRepo            Char(10);
   inDDSObjNam       Char(10);
   inDDSLibrary      Char(10);
   inDDSObjAttr      Char(10);
   inDDSFileType     Char(3);                                                            //0014
   inDDSMbrName      Char(10);                                                           //0014
   inDDSRcdFmt       Char(10);                                                           //0014
   inDDLSrcMbrTyp    Char(10);                                                           //0014
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
   inRequestedUser   Char(10);
   inEnvLibrary      Char(10);
   outStatus         Char(1);
   outMessage        Char(80);
End-Pr;

Dcl-Pr iaDdsDdlCM ExtPgm('IADDSDDLCM');
   inReqId           Char(18);
   inRepo            Char(10);
   inDDSObjNam       Char(10);
   inDDSLibrary      Char(10);
   inDDSObjAttr      Char(10);
   inDDSObjType      Char(10);
   inDDSMbrName      Char(10);                                                           //0014
   inDDSRcdFmt       Char(10);                                                           //0014
   inDDLMbrNam       Char(10);                                                           //0014
   inDDLMbrLib       Char(10);
   inDDLObjNam       Char(10);                                                           //0014
   inDDLObjLib       Char(10);
   inCompilationObj  Char(1);
   inRequestedUser   Char(10);
   outStatus         Char(1);
   outMessage        Char(80);
End-Pr;

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
Dcl-Pr IADDSDDLRT ExtPgm('IADDSDDLRT');
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
   inCopyData        Char(1);                                                            //0006
   inRequestedUser   Char(10);
   inEnvLibrary      Char(10);
   outStatus         Char(1);
   outMessage        Char(80);
End-Pr;

Dcl-Pi iADdsDdlRT;
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
   inCopyData        Char(1);                                                            //0006
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
wkMsgVars   = %Trim(inDDLMbrLib);

//DDL creation completed
iAGetMsg('1':'MSG0185':wkMsgDesc:wkMsgVars);
outMessage  = %trim(wkMsgDesc);

//------------------------------------------------------------------------------------- //
//Cursor Declarations                                                                   //
//------------------------------------------------------------------------------------- //
//Fetch all the PF objects from IAOBJECT File
Exec Sql
   Declare CursorAllPFObjects Cursor For
    Select A.iAObjNam                                                                    //0014
      From iAObject A                                                                    //0014
     Where A.iALibNam = :inDDSLibrary                                                    //0014
       and A.iAObjTyp = '*FILE'                                                          //0014
       and A.iAObjAtr = 'PF'                                                             //0014
       and not Exists                                                                    //0014
           (Select * From iASrcPf                                                        //0014
             Where xLibNam = :inDDSLibrary                                               //0014
               and xSrcPF  = A.iAObjNam);                                                //0014

//Fetch all the objects from IADDSDDLDP File based on Request Id
Exec Sql
   Declare CursorAllObjects Cursor For
    Select iADdsObjLb, iADdsObjNm, iADdsObjAt,
           iADdsFlTyp, iADdsMbrNm, iADdsRcdFm,                                           //0014
           iADdlSrcMb, iADdlObjNm, iADdlLngNm,
           iABasedPF,  iADdlSrcAt                                                        //0014
      From iADdsDdlDP
     Where iAReqId  = :inReqId
       and iARepoNm = :inRepo
       and iAConvSts <> 'E'                                                              //0007
           Order By iACrtTime;

//Fetch the Dependent Files from IADSPDBR file
Exec Sql
   Declare CursorDependentFiles Cursor For
    Select Whrefi, Whreli
      From iADspDbr
     Where Whrfi  = :wkDDSObjNam
       And Whrli  = :inDDSLibrary
       And Whrtyp = :wkDDSObjType
      With Ur;

//Fetch the Dependent Programs from IAALLREFPF file
Exec Sql
   Declare CursorDependentPrograms Cursor For
    Select Object_Name, Library_Name, Object_Type, Object_Attr
      From iAAllRefPf
     Where iArObjNam = :wkDDSObjNam
       And iArObjLib = :wkDDSObjLib
       And iArObjTyp = '*FILE'
       And iAoObjTyp In ('*PGM','*MODULE','*SRVPGM')
      With Ur;

//Fetch libraries list for Repo from IAINPLIB to set environment for object
//compilation
Exec Sql                                                                                 //0003
   Declare CursorLibL Cursor For                                                         //0003
    Select XLIBNAM From IAINPLIB                                                         //0003
     Where XREFNAM = :inRepo                                                             //0003
     Order By XLIBSEQ Desc;                                                              //0003

//Fetch field details of a file
Exec Sql                                                                                 //0006
   Declare CursorFileField Cursor For                                                    //0006
    Select whfldi, whrlen, whfldb, whfldd, whfldp                                        //0014
      From iDspFFd                                                                       //0014
     Where whfile = :wkObjName                                                           //0014
       And whlib  = :wkObjLib                                                            //0014
       And whname = :wkRcdFmt;                                                           //0014

//Fetch the Record Format Information                                                   //0014
Exec Sql                                                                                 //0014
   Declare CursorRecordFormat Cursor For                                                 //0014
    Select RFName, RFID                                                                  //0014
      From IDspFdRFmt                                                                    //0014
     Where RFLib  = :wkObjLib                                                            //0014
       And RFFile = :wkObjName;                                                          //0014

//Fetch the File Member Information                                                     //0014
Exec Sql                                                                                 //0014
   Declare CursorFileMember Cursor For                                                   //0014
    Select MBName, MBJoin, MBNoMb                                                        //0014
      From IDspFDMbr                                                                     //0014
     Where MBLib  = :wkObjLib                                                            //0014
       And MBFile = :wkObjName                                                           //0014
       And (MBBOLF = :wkRcdFmt                                                           //0014
        Or MBBOLF = ' ');                                                                //0014

//------------------------------------------------------------------------------------- //
//Main Processing                                                                       //
//------------------------------------------------------------------------------------- //

//If the input Username blank then get the Username from program status Data Structure
If inRequestedUser = *Blanks;
   inRequestedUser = uDpsds.User;
EndIf;

//When Object name as *ALL
If inDDSObjNam = '*ALL';
   RetrieveAllPFObj();
Else;
   //When Object Name Passed
   RetrieveInputObj();
EndIf;

//Process Dependent Files
If inIncludeDepFile = 'Y';
   RetrieveAllLFObj();
EndIf;

//DDL Source Creation and Retrieve Dependent Program Files
DDLSourceCreation();

//Compile Dependent Programs of DDS object
If inIncludeDepPgm = 'Y';
   //To get application libraries in Repo and set those as library list                 //0008
   SetEnvForCompilation();                                                               //0008

   wkCompilationObj = 'P';
   wkObjType        = '*PGM';
   Clear wkMbrName;                                                                      //0014
   Clear wkRcdFmt;                                                                       //0014
   //Call IADDSDDLCM to Compile the Programs
   IADDSDDLCM(inReqId         : inRepo       : inDDSObjNam      :
              inDDSLibrary    : inDDSObjAttr : wkObjType        :
              wkMbrName       : wkRcdFmt     : inDDLMbrNam      :                        //0014
              inDDLMbrLib     : inDDLObjNam  : inDDLObjLib      :                        //0014
              wkCompilationObj:                                                          //0014
              inRequestedUser : wkOutStatus  : wkOutMessage);

EndIf;

*InLr = *On;
Return;

//------------------------------------------------------------------------------------- //
//RetrieveAllPFObj : Retrieve all the PF data objects                                   //
//------------------------------------------------------------------------------------- //
Dcl-Proc RetrieveAllPFObj;

   //Open cursor
   Exec Sql Open CursorAllPfObjects;
   If sqlCode = CSR_OPN_COD;
      Exec Sql Close CursorAllPfObjects;
      Exec Sql Open  CursorAllPfObjects;
   EndIf;

   If sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Open_CursorAllPfObjects';
      IaSqlDiagnostic(uDpsds);
   EndIf;

   //Get the number of elements
   noOfRows = %elem(udAllPfObjs);

   //Fetch records from CursorAllPfObjects
   rowFound = FetchCursorAllPfObjects();

   DoW rowFound;                                                                         //0014
      For uiSelPfObjIdx = 1 To SelectedPfObjFetched;

         wkDDSObjNam  = udAllPfObjs(uiSelPfObjIdx).usObjectName;
         wkObjAttr    = 'PF';
         wkSrcType    = 'PFSQL';
         wkDDLMbrNm   = wkDDSObjNam;                                                     //0007
         wkDDLObjNm   = wkDDSObjNam;                                                     //0007
         wkDDLLngNm   = *Blanks;                                                         //0007
         wkFileCnvSts = 'P';                                                             //0007
         wkFileCnvMsg = *Blanks;                                                         //0007

         //Check valid file for conversion or not                                       //0007
         If not chkValidFileForConv(inDDSLibrary : wkDDSObjNam);                         //0014
            wkSrcType    = *Blanks;                                                      //0007
            wkFileCnvSts = 'E';                                                          //0007
            wkFileCnvMsg = outMessage;                                                   //0007
            //Write Record into iADdsDdlDP                                              //0007
            WriteiADdsDdlDP();                                                           //0007
            Iter;                                                                        //0007
         EndIf;                                                                          //0007

         //Get DDS Source Information                                                   //0013
         GetDDSSrcInfo(inDDSLibrary : wkDDSObjNam : wkObjAttr);                          //0013

         //DDL Member name should be same as DDS Member Name for all the files in       //0015
         //case of bulk conversion and dependnet file in case of not bulk               //0015
         If udObjMapDs.usMbrNam <> *Blanks;                                              //0015
            wkDDLMbrNm = udObjMapDs.usMbrNam;                                            //0015
         EndIf;                                                                          //0015

         //Process Multi Record Format and Multi Member File                            //0014
         If ProcessMultiRcdFmtAndMultiMbrFile(inDDSLibrary : wkDDSObjNam : wkObjAttr);   //0014
            Iter;                                                                        //0014
         EndIf;

         //Write Record into iADdsDdlDP                                                 //0007
         WriteiADdsDdlDP();                                                              //0007

      EndFor;

      //If fetched rows are less than the array elements then come out of the loop.     //0014
      If SelectedPfObjFetched < noOfRows;                                                //0014
         Leave ;                                                                         //0014
      EndIf ;                                                                            //0014

      //Fetched next set of rows.                                                       //0014
      rowFound = FetchCursorAllPfObjects();                                              //0014

   EndDo;                                                                                //0014

   //Close cursor
   Exec Sql Close CursorAllPfObjects;

End-Proc;

//------------------------------------------------------------------------------------- //
//RetrieveAllLFObj : Retrieve all the LF data objects                                   //
//------------------------------------------------------------------------------------- //
Dcl-Proc RetrieveAllLFObj;

   //Open cursor
   Exec Sql Open CursorAllObjects;
   If sqlCode = CSR_OPN_COD;
      Exec Sql Close CursorAllObjects;
      Exec Sql Open  CursorAllObjects;
   EndIf;

   If sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Open_CursorAllObjects';
      IaSqlDiagnostic(uDpsds);
   EndIf;

   //Get the number of elements
   noOfRows = %elem(udAllObjs);

   //Fetch records from CursorAllObjects
   rowFound = FetchCursorAllObjects();

   DoW rowFound;                                                                         //0014
      For uiSelObjIdx = 1 To SelectedObjFetched;

         wkDDSObjNam  = udAllObjs(uiSelObjIdx).usObjName;
         wkObjAttr    = udAllObjs(uiSelObjIdx).usObjAttr;
         wkFileType   = udAllObjs(uiSelObjIdx).usFileTyp;                                //0014
         wkMbrName    = udAllObjs(uiSelObjIdx).usMbrName;                                //0014
         wkDDSObjType = 'P';

         //No need to process Physical file members                                     //0014
         If wkFileType = 'MMF' and wkMbrName <> *Blanks;                                 //0014
            Iter;                                                                        //0014
         EndIf;                                                                          //0014

         //LF based on DDL Table                                                        //0009
         wkBasedPf = wkDDSObjNam;                                                        //0009

         //Process Dependent Files
         RetrieveDependentFileList();

      EndFor;

      //If fetched rows are less than the array elements then come out of the loop.     //0014
      If SelectedObjFetched < noOfRows;                                                  //0014
         Leave ;                                                                         //0014
      EndIf ;                                                                            //0014

      //Fetched next set of rows.                                                       //0014
      rowFound = FetchCursorAllObjects();                                                //0014

   EndDo;                                                                                //0014

   //Close cursor
   Exec Sql Close CursorAllObjects;

End-Proc;

//------------------------------------------------------------------------------------- //
//RetrieveInputObj : Retrieve Input Object                                              //
//------------------------------------------------------------------------------------- //
Dcl-Proc RetrieveInputObj;

   If inDDSObjAttr = 'PF';
      wkObjAttr = 'PF';
      wkSrcType = 'PFSQL';
   ElseIf inDDSObjAttr = 'LF';
      wkObjAttr = 'LF';
      wkSrcType = 'LFSQL';
   EndIf;

   wkDDSObjType = %Subst(inDDSObjAttr:1:1);
   wkDDSObjNam  = inDDSObjNam;

   wkDDLLngNm = inDDLLngNam;                                                             //0007
   wkDDLMbrNm = inDDLMbrNam;                                                             //0007
   wkDDLObjNm = inDDLObjNam;                                                             //0007

   //Check valid file for conversion or not                                             //0007
   If not chkValidFileForConv(inDDSLibrary : wkDDSObjNam);                               //0014
      wkSrcType  = *Blanks;                                                              //0007
      wKConvSts  = 'E';                                                                  //0007
      wkFileCnvSts = 'E';                                                                //0007
      wkFileCnvMsg = outMessage;                                                         //0007
      //Write Record into iADdsDdlDP                                                    //0007
      WriteiADdsDdlDP();                                                                 //0007
      Return;                                                                            //0007
   EndIf;                                                                                //0007

   //Process Multi Record Format and Multi Member File                                  //0014
   If ProcessMultiRcdFmtAndMultiMbrFile(inDDSLibrary : wkDDSObjNam : wkObjAttr);         //0014
      Return;                                                                            //0014
   EndIf;                                                                                //0014

   //Write Record into iADdsDdlDP                                                       //0007
   WriteiADdsDdlDP();                                                                    //0007

End-Proc;

//------------------------------------------------------------------------------------- //
//RetrieveDependentFileList : To process dependent files of DDS object                  //
//------------------------------------------------------------------------------------- //
Dcl-Proc RetrieveDependentFileList;

   //DDL source type will be always LFSQL for dependent file
   wkSrcType = 'LFSQL';

   //Get number of dependent files
   Exec Sql
      Select Whno Into :wkDependentFilesCount From iADspDbr
       Where Whrfi  = :wkDDSObjNam
         And Whrli  = :inDDSLibrary
         And Whrtyp = :wkDDSObjType;

   //If dependent files exist,then call DDL creation program to create DDL for those files
   If wkDependentFilesCount > 0;

      //Open cursor
      Exec Sql Open CursorDependentFiles;
      If sqlCode = CSR_OPN_COD;
         Exec Sql Close CursorDependentFiles;
         Exec Sql Open  CursorDependentFiles;
      EndIf;

      If sqlCode < successCode;
         uDpsds.wkQuery_Name = 'Open_CursorDependentFiles';
         IaSqlDiagnostic(uDpsds);
      EndIf;

      //Get the number of elements
      noOfRows = %elem(udDependentFiles);

      //Fetch records from CursorDependentFiles
      rowFound = FetchCursorDependentFiles();

      DoW rowFound;                                                                      //0014
         For uiDependentFilesIdx = 1 To DepFilesFetched;

            wkDependentLib  = udDependentFiles(uiDependentFilesIdx).usDependentLibrary;
            wkDependentFile = udDependentFiles(uiDependentFilesIdx).usDependentFile;
            wkDependentType = '*FILE';
            wkDependentAttr = 'LF';
            wkDDLMbrNm = wkDependentFile;                                                //0007
            wkDDLObjNm = wkDependentFile;                                                //0007
            wkDDLLngNm = *Blanks;                                                        //0007
            wkFileCnvSts = 'P';                                                          //0007
            wkFileCnvMsg = *Blanks;                                                      //0007
            wkSrcType = 'LFSQL';                                                         //0007

            //Check valid file for conversion or not                                    //0007
            If not chkValidFileForConv(wkDependentLib : wkDependentFile);                //0014
               wkSrcType    = *Blanks;                                                   //0007
               wkFileCnvSts = 'E';                                                       //0007
               wkFileCnvMsg = outMessage;                                                //0007
               //Write Record into iADdsDdlDP                                           //0007
               WriteiADdsDdlDP();                                                        //0007
               Iter;                                                                     //0007
            EndIf;                                                                       //0007

            outStatus  = *Blanks;
            outMessage = *Blanks;

            //Get DDS Source Member Information                                         //0013
            GetDDSSrcInfo(wkDependentLib : wkDependentFile : wkDependentAttr);           //0013

            //DDL Member name should be same as DDS Member Name for all the files in    //0015
            //case of bulk conversion and dependnet file in case of not bulk            //0015
            If udObjMapDs.usMbrNam <> *Blanks;                                           //0015
               wkDDLMbrNm = udObjMapDs.usMbrNam;                                         //0015
            EndIf;                                                                       //0015

            //Process Multi Record Format and Multi Member File                         //0014
            If processMultiRcdFmtAndMultiMbrFile(wkDependentLib                          //0014
                                                 :wkDependentFile                        //0014
                                                 :wkDependentAttr);                      //0014
               Iter;                                                                     //0014
            EndIf;                                                                       //0014

            //Write Record into iADdsDdlDP                                              //0007
            WriteiADdsDdlDP();                                                           //0007

         EndFor;

         //If fetched rows are less than the array elements then come out of the loop.  //0014
         If DepFilesFetched < noOfRows;                                                  //0014
            Leave ;                                                                      //0014
         EndIf ;                                                                         //0014

         //Fetched next set of rows.                                                    //0014
         rowFound = FetchCursorDependentFiles();                                         //0014

      EndDo;                                                                             //0014

      //Close cursor
      Exec Sql Close CursorDependentFiles;

   EndIf;

End-Proc;

//------------------------------------------------------------------------------------- //
//DDLSourceCreation : DDL Source Creation                                               //
//------------------------------------------------------------------------------------- //
Dcl-Proc DDLSourceCreation;

   //To set DDL object library at the first position                                      //0008
   wkCommand = 'ADDLIBLE LIB(' + %trim(inDDLObjLib) + ') POSITION(*FIRST)';                //0008
   RunCmd();                                                                               //0008
   Clear wkCommand;                                                                        //0008

   //Open cursor
   Exec Sql Open CursorAllObjects;
   If sqlCode = CSR_OPN_COD;
      Exec Sql Close CursorAllObjects;
      Exec Sql Open  CursorAllObjects;
   EndIf;

   If sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Open_CursorAllObjects';
      IaSqlDiagnostic(uDpsds);
   EndIf;

   //Get the number of elements
   noOfRows = %elem(udAllObjs);

   //Fetch records from CursorAllObjects
   rowFound = FetchCursorAllObjects();

   DoW rowFound;                                                                         //0014
      For uiSelObjIdx = 1 To SelectedObjFetched;

         wkTotalRecords += 1;                                                            //0011
         wkDDSObjLib  = udAllObjs(uiSelObjIdx).usObjLib ;
         wkDDSObjNam  = udAllObjs(uiSelObjIdx).usObjName;
         wkObjAttr    = udAllObjs(uiSelObjIdx).usObjAttr;
         wkFileType   = udAllObjs(uiSelObjIdx).usFileTyp;                                //0014
         wkMbrName    = udAllObjs(uiSelObjIdx).usMbrName;                                //0014
         wkRcdFmt     = udAllObjs(uiSelObjIdx).usRcdFmt ;                                //0014
         wkDDLSrcNm   = udAllObjs(uiSelObjIdx).usSrcNam ;
         wkDDLObjNm   = udAllObjs(uiSelObjIdx).usObjNam ;
         wkDDLLngNm   = udAllObjs(uiSelObjIdx).usObjLngN;
         wkDepObjNm   = udAllObjs(uiSelObjIdx).usBasedPF;
         wkSrcAtr     = udAllObjs(uiSelObjIdx).usSrcAtr;                                 //0014

         //Dependent Object Name and Attribute for IADDSDDLPP File
         If wkObjAttr = 'PF';
            wkDDSObjType = 'P';
            wkDepObjNm   = wkDDSObjNam;
            wkDepObjAttr = 'PF';
         ElseIf wkObjAttr = 'LF';
            wkDDSObjType = 'L';
            wkDepObjAttr = 'PF';
            If wkDepObjNm = ' ';
               wkDepObjNm = wkDDSObjNam;
               wkDepObjAttr = wkObjAttr;
            EndIf;
         EndIf;

         //Call IADDSDDLSC to generate DDL for the Selected PF/LF
         IADDSDDLSC(inReqId         : inRepo           : wkDDSObjNam      :
                    wkDDSObjLib     : wkDDSObjType     : wkFileType       :              //0014
                    wkMbrName       : wkRcdFmt         : wkSrcAtr         :              //0014
                    wkDDLSrcNm      :                                                    //0014
                    inDDLMbrLib     : wkDDLObjNm       : inDDLObjLib      :
                    wkDDLLngNm      : inReplaceDDL     : inIncludeDepFile :
                    inIncludeDepPgm : inIncludeAudCols : inIncludeIdCol   :
                    inRequestedUser : inEnvLibrary     : outStatus        :
                    outMessage);

         //Update Source Conversion Status for IADDSDDLDP File
         Exec Sql
            Update IADDSDDLDP
               Set iAConvSts  = :outStatus,
                   iAErrMsg   = :outMessage                                              //0007
             Where iAReqId    = :inReqId
               And iARepoNm   = :inRepo
               And iADdsObjLb = :wkDDSObjLib
               And iADdsObjNm = :wkDDSObjNam
               And iADdsObjAt = :wkObjAttr                                               //0014
               And iADdsMbrNm = :wkMbrName                                               //0014
               And iADdsRcdFm = :wkRcdFmt                                                //0014
               And iADdlSrcMb = :wkDDLSrcNm                                              //0014
               And iADdlObjNm = :wkDDLObjNm;                                             //0014

         //Compile Object Type is File
         wkCompilationObj = 'F';

         If outStatus = 'S';
            //Call IADDSDDLCM to Compile the Selected PF/LF
            IADDSDDLCM(inReqId         : inRepo       : wkDDSObjNam      :
                       wkDDSObjLib     : wkObjAttr    : wkObjType        :
                       wkMbrName       : wkRcdFmt     : wkDDLSrcNm       :               //0014
                       inDDLMbrLib     : wkDDLObjNm   : inDDLObjLib      :               //0014
                       wkCompilationObj:                                                 //0014
                       inRequestedUser : outStatus    : outMessage);

            If outStatus = 'S';
               //To retrieve dependent programs of DDS object
               If inIncludeDepPgm = 'Y';
                  RetrieveDependentPgms();
               EndIf;
               //To copy PF data to corresponding DDL file                              //0006
               If inCopyData = 'Y' and                                                   //0006
                  wkObjAttr  = 'PF';                                                     //0006
                  wkIncludeAudCols = inIncludeAudCols;                                   //0006
                  CopyDataDDStoDDL();                                                    //0006
               EndIf;                                                                    //0006
            Else;
               //Error During File Object Creation
               CnvCmpErrArray(2) += 1;                                                   //0011
            EndIf;
         Else;
            //Error During File Source Converting from DDS to DDL                       //0007
            //DDL member conversion failed.                                             //0011
            CnvCmpErrArray(1) += 1;                                                      //0011
         EndIf;

      EndFor;

      //If fetched rows are less than the array elements then come out of the loop.     //0014
      If SelectedObjFetched < noOfRows;                                                  //0014
         Leave ;                                                                         //0014
      EndIf ;                                                                            //0014

      //Fetched next set of rows.                                                       //0014
      rowFound = FetchCursorAllObjects();                                                //0014

   EndDo;                                                                                //0014

   //Close CursorAllObjects
   Exec Sql Close CursorAllObjects;

   //Generic Error Message for Outmessage
   If %xfoot(CnvCmpErrArray) <> 0;                                                       //0011
      outStatus  = 'E';
      wKConvSts  = 'E';
      Select;                                                                            //0011
      //Error During All Source Member Conversion.
      //DDL member conversion failed.
      When CnvCmpErrArray(1) = wkTotalRecords;                                           //0011
         iAGetMsg('1':'MSG0205':wkMsgDesc:' ');                                          //0011
         outMessage = %Trim(wkMsgDesc);                                                  //0011
      //Error During Compiling All Sources to DDL Library.
      //DDL member compilation failed.
      When CnvCmpErrArray(2) = wkTotalRecords;                                           //0011
         iAGetMsg('1':'MSG0189':wkMsgDesc:' ');                                          //0011
         outMessage = %Trim(wkMsgDesc);                                                  //0011
      //Error During Conversion/Compilation of Sources.
      //DDL member conversion/compilation processed partially.
      When CnvCmpErrArray(1) > 0 and CnvCmpErrArray(2) > 0;                              //0011
         iAGetMsg('1':'MSG0206':wkMsgDesc:' ');                                          //0011
         outStatus  = 'S';                                                               //0011
         outMessage = %Trim(wkMsgDesc);                                                  //0011
      //No Error During Source Conversion but some while Compiling to DDL Library.
      //DDL member compilation processed partially.
      When CnvCmpErrArray(1) = 0 and CnvCmpErrArray(2) > 0;                              //0011
         iAGetMsg('1':'MSG0212':wkMsgDesc:' ');                                          //0011
         outStatus  = 'S';                                                               //0011
         outMessage = %Trim(wkMsgDesc);                                                  //0011
      //Error During Copying Some Source but No Compilation Error to DDL Library.
      //DDL member conversion processed partially.
      When CnvCmpErrArray(1) > 0 and CnvCmpErrArray(2) = 0;                              //0011
         iAGetMsg('1':'MSG0213':wkMsgDesc:' ');                                          //0011
         outStatus  = 'S';                                                               //0011
         outMessage = %Trim(wkMsgDesc);                                                  //0011
      EndSl;                                                                             //0011
   EndIf;

   //Update Source Conversion Status in IADDSDDLHP
   Exec Sql
      Update IADDSDDLHP
         Set iAConvSts  = :wKConvSts,
             iAUpdPgm   = 'IADDSDDLRT',
             iAUpdUser  = :inRequestedUser
       Where iAReqId    = :inReqId
         And iARepoNm   = :inRepo;

End-Proc;

//------------------------------------------------------------------------------------- //0006
//CopyDataDDStoDDL : To copy PF data to DDL file                                        //0006
//------------------------------------------------------------------------------------- //0006
Dcl-Proc CopyDataDDStoDDL;                                                               //0006

   //Local Data Structure                                                               //0006
   Dcl-s wkDDSFile       varchar(21)      inz;                                           //0006
   Dcl-s wkDDLFile       varchar(21)      inz;                                           //0006
   Dcl-s wkHoldFields    varchar(32740)   inz;                                           //0006
   Dcl-s wkSqlQry        varchar(32740)   inz;                                           //0006
                                                                                   //0014//0006
   //Get the fields of DDS File                                                         //0014
   wkObjLib  = wkDDSObjLib;                                                              //0014
   wkObjName = wkDDSObjNam;                                                              //0014

   //Fetch records from CursorFileField                                                 //0014
   rowFound = FetchCursorFileField();                                                    //0014

   If rowFound;                                                                          //0014
      //Get PF fields as comma separated values                                         //0006
      For uiFldIdx = 1 to FileFieldFetched;                                              //0014
         If uiFldIdx <> FileFieldFetched;                                                //0014
            wkHoldFields = wkHoldFields + %trim(udfilefield(uiFldIdx).usFldInt) + ', ' ; //0014
         else;                                                                           //0006
            wkHoldFields = wkHoldFields + %trim(udfilefield(uiFldIdx).usFldInt);         //0014
         EndIf;                                                                          //0006
      EndFor;                                                                            //0006
                                                                                         //0006
      wkDDSFile = %trim(wkDDSObjLib) + '/' + %trim(wkDDSObjNam);                         //0006
      wkDDLFile = %trim(inDDLObjLib) + '/' + %trim(wkDDLObjNm);                          //0006
                                                                                         //0006
      //Copy the data from Alias of DDS member for Multi Member File                    //0014
      If wkFileType = 'MMF';                                                             //0014
         wkSqlQry = 'Drop Alias If Exists Qtemp.' + %Trim(wkMbrName);                    //0014
         Exec Sql Execute Immediate :wkSqlQry;                                           //0014
         wkSqlQry = 'Create Alias Qtemp.' + %Trim(wkMbrName) +' For ' +                  //0014
                     %Trim(wkDDSFile) + '(' + %Trim(wkMbrName) + ')';                    //0014
         Exec Sql Execute Immediate :wkSqlQry;                                           //0014
         wkDDSFile = 'Qtemp.' + %trim(wkMbrName);                                        //0014
      EndIf;                                                                             //0014

      //Copy the data from DDS to DDL                                                   //0006
      wkSqlQry  = 'Insert into ' + %trim(wkDDLFile) +                                    //0006
                  ' (' + %Trim(wkHoldFields) + ')' +                                     //0006
                  ' (Select ' + %trim(wkHoldFields) + ' from ' +                         //0012
                    %trim(wkDDSFile) + ')' ;                                             //0012
                                                                                         //0006
      Exec Sql Execute immediate :wkSqlQry;                                              //0006
                                                                                         //0006
      //Update Created By field if Audit Column is included in DDL generation           //0006
      If wkIncludeAudCols  = 'Y';                                                        //0006
         reset wksqlqry;                                                                 //0006
         wkSqlQry = 'Update ' + %trim(wkDDLFile) +                                       //0006
                    ' Set CRTUSER = ' + Squote + %trim(inRequestedUser) + Squote;        //0006
                                                                                         //0006
         Exec Sql Execute Immediate :wkSqlQry;                                           //0006
      EndIf;                                                                             //0006
                                                                                         //0006
   EndIf;                                                                                //0014

End-Proc;                                                                                //0006

//------------------------------------------------------------------------------------- //0014
//FetchCursorFileField : To fetch the file field details                                //0014
//------------------------------------------------------------------------------------- //0014
Dcl-Proc FetchCursorFileField;                                                           //0014

   Dcl-Pi *N Ind End-Pi ;                                                                //0014

   Dcl-S  rcdFound Ind Inz('0');                                                         //0014
   Dcl-S  wkRowNum Uns(5);                                                               //0014

   //Open cursor                                                                        //0014
   Exec Sql Open CursorFileField;                                                        //0014
   If sqlCode = CSR_OPN_COD;                                                             //0014
      Exec Sql Close CursorFileField;                                                    //0014
      Exec Sql Open  CursorFileField;                                                    //0014
   Endif;                                                                                //0014

   If sqlCode < successCode;                                                             //0014
      uDpsds.wkQuery_Name = 'Open_CursorFileField';                                      //0014
      IaSqlDiagnostic(uDpsds);                                                           //0014
   EndIf;                                                                                //0014

   //Get the number of elements                                                         //0014
   noOfFld = %elem(udFileField);                                                         //0014

   FileFieldFetched = *Zeros;                                                            //0014
   Clear udFileField;                                                                    //0014

   Exec Sql                                                                              //0014
      Fetch CursorFileField For :noOfFld Rows Into :udFileField;                         //0014

   If sqlCode < successCode;                                                             //0014
      uDpsds.wkQuery_Name = 'Fetch_CursorFileField';                                     //0014
      IaSqlDiagnostic(uDpsds);                                                           //0014
   EndIf;                                                                                //0014

   If sqlcode = successCode;                                                             //0014
      Exec Sql Get Diagnostics                                                           //0014
         :wkRowNum = ROW_COUNT;                                                          //0014
         FileFieldFetched = wkRowNum ;                                                   //0014
   EndIf;                                                                                //0014

   If FileFieldFetched > 0;                                                              //0014
      rcdFound = TRUE;                                                                   //0014
   ElseIf sqlcode < successCode ;                                                        //0014
      rcdFound = FALSE;                                                                  //0014
   EndIf;                                                                                //0014

   //Close the Cursor                                                                   //0014
   Exec Sql Close CursorFileField;                                                       //0014

   Return rcdFound;                                                                      //0014

End-Proc;                                                                                //0014

//------------------------------------------------------------------------------------- //
//RetrieveDependentPgms : To process dependent programs                                 //
//------------------------------------------------------------------------------------- //
Dcl-Proc RetrieveDependentPgms;

   //Open cursor
   Exec Sql Open CursorDependentPrograms;
   If sqlCode = CSR_OPN_COD;
      Exec Sql Close CursorDependentPrograms;
      Exec Sql Open  CursorDependentPrograms;
   EndIf;

   If sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Open_CursorDependentPrograms';
      IaSqlDiagnostic(uDpsds);
   EndIf;

   //Get the number of elements
   noOfRows = %elem(udDependentPrograms);

   //Fetch records from CursorDependentPrograms
   rowFound = FetchCursorDependentPrograms();

   DoW rowFound;                                                                         //0014
      For uiDependentPgmsIdx = 1 To DepPgmsRowsFetched;
        Clear wkStandalonePgmCount;
        wkDependentObjName    = udDependentPrograms(uiDependentPgmsIdx).usDependentObjName;
        wkDependentObjLibrary = udDependentPrograms(uiDependentPgmsIdx).usDependentObjLibrary;
        wkDependentObjType    = udDependentPrograms(uiDependentPgmsIdx).usDependentObjType;
        wkDependentObjAttr    = udDependentPrograms(uiDependentPgmsIdx).usDependentObjAttr;

        //To Clear the Write variables
        ClearWriteVariables();

        //To Clear the Module related variables
        ClearModuleVariables();

        Select;
           When wkDependentObjType = '*PGM';
              If wkDependentObjAttr = 'RPG'
                or wkDependentObjAttr = 'RPG36'
                or wkDependentObjAttr = 'RPG38'
                or wkDependentObjAttr = 'CLP';
                 //Retrieve source details
                 RtvSrcDetails();

              Else;
                 //Check for Standalone Program count.
                 Exec Sql
                    Select count(*) Into :wkStandalonePgmCount From iAPgmInf
                     Where Pgmtyp = '*PGM'
                       And Pgm    = :wkDependentObjName
                       And PgmLib = :wkDependentObjLibrary
                       And ModLib = 'QTEMP'
                       And MOdTyp = '*MODULE';

                 If wkStandalonePgmCount = 1;
                    RtvStandaloneProgramInfo();
                 Else;
                    wkObjDepNam  = wkDependentObjName;
                    wkObjDepLib  = wkDependentObjLibrary;
                    wkObjDepType = wkDependentObjType;
                    wkObjDepAttr = wkDependentObjAttr;

                    //Add the details to IADDSDDLPP file for dependent program
                    WriteDDSDepPgmFile();
                 EndIf;
              EndIf;

           When wkDependentObjType = '*MODULE';
              RtvModuleInfo();

           Other;
              wkObjDepNam  = wkDependentObjName;
              wkObjDepLib  = wkDependentObjLibrary;
              wkObjDepType = wkDependentObjType;
              wkObjDepAttr = wkDependentObjAttr;

              //Add the details to IADDSDDLPP file for dependent program
              WriteDDSDepPgmFile();
        EndSl;

      EndFor;

      //If fetched rows are less than the array elements then come out of the loop.     //0014
      If DepPgmsRowsFetched < noOfRows;                                                  //0014
         Leave ;                                                                         //0014
      EndIf ;                                                                            //0014

      //Fetched next set of rows.                                                       //0014
      rowFound = FetchCursorDependentPrograms();                                         //0014

   EndDo;                                                                                //0014

   //Close cursor
   Exec Sql Close CursorDependentPrograms;

End-Proc;

//------------------------------------------------------------------------------------- //
//RtvSrcDetails : To get source details from IAOBJMAP                                   //
//------------------------------------------------------------------------------------- //
Dcl-Proc RtvSrcDetails;

   //To get program information
   Exec Sql
      Select Member_Libr, Member_Srcf, Member_Name, Member_Type Into
             :wkSourceLibrary, :wkSourceFile, :wkSourceMember,:wkModuleAttribute
        From IaObjMap
       Where Object_Libr = :wkDependentObjLibrary
         And Object_Name = :wkDependentObjName
         And Object_Type = :wkDependentObjType
         And Object_Attr = :wkDependentObjAttr ;

   If sqlCode = successCode;                                                             //0002
      wkObjSrcFile = wkSourceFile;                                                       //0002
      wkObjSrcLib  = wkSourceLibrary;                                                    //0002
      wkObjSrcMem  = wkSourceMember;                                                     //0002
      wkObjSrcAttr = wkModuleAttribute;                                                  //0002
      //Copying the program source to QDDLSRC
      CopyDependentPgmsToDDLLib();
   EndIf;                                                                                //0002

   wkObjDepNam  = wkDependentObjName;
   wkObjDepLib  = wkDependentObjLibrary;
   wkObjDepType = wkDependentObjType;
   wkObjDepAttr = wkDependentObjAttr;

   //Add the details to IADDSDDLPP file for dependent program
   WriteDDSDepPgmFile();

End-Proc;

//------------------------------------------------------------------------------------- //
//RtvStandaloneProgramInfo : To get the Standalone Program Information                  //
//------------------------------------------------------------------------------------- //
Dcl-Proc RtvStandaloneProgramInfo;

   //To get program information
   Exec Sql
      Select Pgm_Name, Pgm_Lib, Pgm_Typ, Mod_Name, Mod_Lib, Mod_Typ, Src_File, Src_Lib,
             Src_Mbr, Mod_Attrib Into
             :wkProgramName, :wkProgramLibrary, :wkProgramType, :wkModuleName,
             :wkModuleLibrary, :wkModuleType, :wkSourceFile, :wkSourceLibrary,
             :wkSourceMember,:wkModuleAttribute
        From IaPgmInf
       Where Pgmtyp = '*PGM'
         And Pgm    = :wkDependentObjName
         And ModTyp = '*MODULE'
         And Modlib = 'QTEMP';

   wkObjDepNam  = wkProgramName;
   wkObjDepLib  = wkProgramLibrary;
   wkObjDepType = wkProgramType;
   wkObjDepAttr = wkDependentObjAttr;                                                    //0002
   wkObjSrcFile = wkSourceFile;
   wkObjSrcLib  = wkSourceLibrary;
   wkObjSrcMem  = wkSourceMember;

   //Get Attribute from IAMEMBER file
   Exec Sql
      Select iAMbrType into :wkObjSrcAttr from iAMember
       Where iASrcPFNam = :wkObjSrcFile
         And iASrcLib   = :wkObjSrcLib
         And iAMbrNam   = :wkObjSrcMem;

   If wkObjSrcAttr = *Blanks;                                                            //0002
      Clear wkObjSrcFile;                                                                //0002
      Clear wkObjSrcLib;                                                                 //0002
      Clear wkObjSrcMem;                                                                 //0002
   Else;                                                                                 //0002
      //Copying the program source to QDDLSRC                                           //0002
      CopyDependentPgmsToDDLLib();                                                       //0002
   EndIf;                                                                                //0002

   //Add the details to IADDSDDLPP file for Dependent Programs
   WriteDDSDepPgmFile();

End-Proc;

//------------------------------------------------------------------------------------- //
//RtvModuleInfo : To get the Module Information                                         //
//------------------------------------------------------------------------------------- //
Dcl-Proc RtvModuleInfo;

   //To get Module Source details
   Exec Sql
      Select Src_File, Src_Lib, Src_Mbr, Mod_Attrib Into
             :wkSourceFile,:wkSourceLibrary,:wkSourceMember,:wkModuleAttribute
        From IaPgmInf
       Where Mod_Typ  = :wkDependentObjType
         And Mod_name = :wkDependentObjName
         And Modlib   = :wkDependentObjLibrary;

   wkObjDepNam  = wkDependentObjName;
   wkObjDepLib  = wkDependentObjLibrary;
   wkObjDepType = wkDependentObjType;
   wkObjDepAttr = wkDependentObjAttr;
   wkObjSrcFile = wkSourceFile;
   wkObjSrcLib  = wkSourceLibrary;
   wkObjSrcMem  = wkSourceMember;

   //Get Attribute from IAMEMBER file                                                   //0002
   Exec Sql                                                                              //0002
      Select iAMbrType into :wkObjSrcAttr from iAMember                                  //0002
       Where iASrcPFNam = :wkObjSrcFile                                                  //0002
         And iASrcLib   = :wkObjSrcLib                                                   //0002
         And iAMbrNam   = :wkObjSrcMem;                                                  //0002

   If wkObjSrcAttr = *Blanks;                                                            //0002
      Clear wkObjSrcFile;                                                                //0002
      Clear wkObjSrcLib;                                                                 //0002
      Clear wkObjSrcMem;                                                                 //0002
   Else;                                                                                 //0002
      //Copying the Module source to QDDLSRC                                            //0002
      CopyDependentPgmsToDDLLib();                                                       //0002
   EndIf;                                                                                //0002

   //Add the details to IADDSDDLPP file for dependent programs
   WriteDDSDepPgmFile();

End-Proc;

//------------------------------------------------------------------------------------- //
//CopyDependentPgmsToDDLLib : To copy dependent program source to DDL Library           //
//------------------------------------------------------------------------------------- //
Dcl-Proc CopyDependentPgmsToDDLLib;

   //Return with out any action if any of source details are missing
   If wkSourceLibrary = *Blanks or wkSourceFile = *Blanks or wkSourceMember = *Blanks;
      Return;
   EndIf;

   //Format DDL Member Library
   If inDDLMbrLib <> *Blanks;
      wkDDLMemberLibrary = inDDLMbrLib;
   Else;
      wkDDLMemberLibrary = inDDSLibrary;
   EndIf;

   //Copy Command
   Clear wkCommand;
   wkCommand = 'CPYSRCF FROMFILE(' + %Trim(wkSourceLibrary) + '/' + %Trim(wkSourceFile) +
               ') TOFILE(' + %Trim(wkDDLMemberLibrary) + '/QDDLSRC)' +
               ' FROMMBR(' + %Trim(wkSourceMember) + ')';
   RunCmd();
   If wkError = 'Y';
      outStatus  = 'E';
      wKConvSts  = 'E';
      wkMsgVars  = %Trim(wkSourceMember);
      //Error while copying source to DDL library.
      iAGetMsg('1':'MSG0195':wkMsgDesc:wkMsgVars);
      outMessage = %Trim(wkMsgDesc);
   EndIf;

End-Proc;

//------------------------------------------------------------------------------------- //
//FetchCursorDependentFiles: To fetch Dependent Files                                   //
//------------------------------------------------------------------------------------- //
Dcl-Proc FetchCursorDependentFiles;

   Dcl-Pi FetchCursorDependentFiles Ind End-Pi ;

   Dcl-S  rcdFound Ind Inz('0');
   Dcl-S  wkRowNum Uns(5);

   DepFilesFetched = *Zeros;
   Clear udDependentFiles;

   Exec Sql
      Fetch CursorDependentFiles For :noOfRows Rows Into :udDependentFiles;

   If sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Fetch_CursorDependentFiles';
      IaSqlDiagnostic(uDpsds);
   EndIf;

   If sqlcode = successCode;
      Exec Sql Get Diagnostics
         :wkRowNum = ROW_COUNT;
         DepFilesFetched = wkRowNum ;
   EndIf;

   If DepFilesFetched > 0;
      rcdFound = TRUE;
   ElseIf sqlcode < successCode ;
      rcdFound = FALSE;
   EndIf;

   Return rcdFound;

End-Proc;

//------------------------------------------------------------------------------------- //
//FetchCursorDependentPrograms: To fetch Dependent Programs                             //
//------------------------------------------------------------------------------------- //
Dcl-Proc FetchCursorDependentPrograms;

   Dcl-Pi FetchCursorDependentPrograms Ind End-Pi ;

   Dcl-S  rcdFound Ind Inz('0');
   Dcl-S  wkRowNum Uns(5);

   DepPgmsRowsFetched = *zeros;
   Clear udDependentPrograms;

   Exec Sql
      Fetch CursorDependentPrograms For :noOfRows Rows Into :udDependentPrograms;

   If sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Fetch_CursorDependentPrograms';
      IaSqlDiagnostic(uDpsds);
   EndIf;

   If sqlcode = successCode;
      Exec Sql Get Diagnostics
         :wkRowNum = ROW_COUNT;
         DepPgmsRowsFetched  = wkRowNum ;
   EndIf;

   If DepPgmsRowsFetched > 0;
      rcdFound = TRUE;
   ElseIf sqlcode < successCode ;
      rcdFound = FALSE;
   EndIf;

   Return rcdFound;

End-Proc;

//------------------------------------------------------------------------------------- //
//FetchCursorAllPfObjects : To fetch all the PF data objects                            //
//------------------------------------------------------------------------------------- //
Dcl-Proc FetchCursorAllPfObjects;

   Dcl-Pi FetchCursorAllPfObjects Ind End-Pi ;

   Dcl-S  rcdFound Ind Inz('0');
   Dcl-S  wkRowNum Uns(5);

   SelectedPfObjFetched = *zeros;
   Clear udAllPfObjs;

   Exec Sql
      Fetch CursorAllPfObjects For :noOfRows Rows Into :udAllPfObjs;

   If sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Fetch_CursorAllPfObjects';
      IaSqlDiagnostic(uDpsds);
   EndIf;

   If sqlcode = successCode;
      Exec Sql Get Diagnostics
         :wkRowNum = ROW_COUNT;
         SelectedPfObjFetched = wkRowNum ;
   EndIf;

   If SelectedPfObjFetched > 0;
      rcdFound = TRUE;
   ElseIf sqlcode < successCode ;
      rcdFound = FALSE;
   EndIf;

   Return rcdFound;

End-Proc;

//------------------------------------------------------------------------------------- //
//FetchCursorAllObjects : To fetch all the data objects                                 //
//------------------------------------------------------------------------------------- //
Dcl-Proc FetchCursorAllObjects;

   Dcl-Pi FetchCursorAllObjects Ind End-Pi ;

   Dcl-S  rcdFound Ind Inz('0');
   Dcl-S  wkRowNum Uns(5);

   SelectedObjFetched = *zeros;
   Clear udAllObjs;

   Exec Sql
      Fetch CursorAllObjects For :noOfRows Rows Into :udAllObjs;

   If sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Fetch_CursorAllObjects';
      IaSqlDiagnostic(uDpsds);
   EndIf;

   If sqlcode = successCode;
      Exec Sql Get Diagnostics
         :wkRowNum = ROW_COUNT;
         SelectedObjFetched = wkRowNum ;
   EndIf;

   If SelectedObjFetched > 0;
      rcdFound = TRUE;
   ElseIf sqlcode < successCode ;
      rcdFound = FALSE;
   EndIf;

   Return rcdFound;

End-Proc;

//------------------------------------------------------------------------------------- //
//ClearModuleVariables : To clear the variables used to get module information          //
//------------------------------------------------------------------------------------- //
Dcl-Proc ClearModuleVariables;

   Clear wkProgramName;
   Clear wkProgramLibrary;
   Clear wkProgramType;
   Clear wkModuleName;
   Clear wkModuleLibrary;
   Clear wkModuleType;
   Clear wkSourceFile;
   Clear wkSourceLibrary;
   Clear wkSourceMember;
   Clear wkModuleAttribute;

End-Proc;
//------------------------------------------------------------------------------------- //
//ClearWriteVariables : To clear the Write variables                                    //
//------------------------------------------------------------------------------------- //
Dcl-Proc ClearWriteVariables;

   Clear wkObjDepNam;
   Clear wkObjDepLib;
   Clear wkObjDepType;
   Clear wkObjDepAttr;
   Clear wkObjSrcFile;
   Clear wkObjSrcLib;
   Clear wkObjSrcMem;
   Clear wkObjSrcAttr;

End-Proc;

//------------------------------------------------------------------------------------- //
//RunCmd : To execute the command                                                       //
//------------------------------------------------------------------------------------- //
Dcl-Proc RunCmd;

   Dcl-Pr RunCommand ExtPgm('QCMDEXC');
      Command    Char(1000) Options(*VarSize) Const;
      Commandlen Packed(15:5) Const;
   End-Pr;

   Clear wkError;
   Monitor;
      RunCommand(wkCommand:%Len(%TrimR(wkCommand)));
        On-Error;
           wkError = 'Y';
        EndMon;

End-Proc;

//------------------------------------------------------------------------------------- //
//isSqlFile : To check Object is Table, Index or View                                   //
//------------------------------------------------------------------------------------- //
Dcl-Proc isSqlFile;
   Dcl-Pi *N Ind;
      pLibName  Char(10);
      pObjName  Char(10);
   End-Pi;

   Exec Sql
      Select ATSQLT into :wKSrcObjType From IDSPFDBASA
       WHERE ATFILE = :pObjName
         and ATLIB = :pLibName
       Fetch First Row Only;

   Select;                                                                               //0014
      When wKSrcObjType = 'T';                                                           //0014
         //File Type is Table                                                           //0014
         wkFileType = 'TBL';                                                             //0014
         Return *On;                                                                     //0014
      When wKSrcObjType = 'V';                                                           //0014
         //File Type is View                                                            //0014
         wkFileType = 'VWE';                                                             //0014
         Return *On;                                                                     //0014
      When wKSrcObjType = 'I';                                                           //0014
         //File Type is Index                                                           //0014
         wkFileType = 'IDX';                                                             //0014
         Return *On;                                                                     //0014
      Other;                                                                             //0014
         Return *Off;                                                                    //0014
   EndSl;                                                                                //0014

End-Proc;

//------------------------------------------------------------------------------------- //
//WriteiADdsDdlDP : Write Record Into IADDSDDLDP                                        //
//------------------------------------------------------------------------------------- //
Dcl-Proc WriteiADdsDdlDP;

   If wkDependentFile = *Blanks;
      Exec Sql
         Insert into IADDSDDLDP (iAReqId   ,
                                 iARepoNm  ,
                                 iADdsFlTyp,                                             //0014
                                 iADdsObjLb,
                                 iADdsObjNm,
                                 iADdsObjAt,
                                 iADdsObjTy,
                                 iADdsMbrNm,                                             //0014
                                 iADdsRcdFm,                                             //0014
                                 iADdsFmtID,                                             //0014
                                 iADdsSrcLb,                                             //0015
                                 iADdsSrcFl,                                             //0015
                                 iADdsSrcMb,                                             //0015
                                 iADdsSrcAt,                                             //0015
                                 iADdlSrcLb,
                                 iADdlSrcFl,
                                 iADdlSrcMb,
                                 iADdlSrcAt,
                                 iADdlObjLb,
                                 iADdlObjNm,
                                 iADdlLngNm,
                                 iAConvSts ,
                                 iAErrMsg  ,                                             //0007
                                 iACrtPgm  ,
                                 iACrtUser )
                         VALUES (:inReqId     ,
                                 :inRepo      ,
                                 :wkFileType  ,                                          //0014
                                 :inDDSLibrary,
                                 :wkDDSObjNam ,
                                 :wkObjAttr   ,
                                 '*FILE'      ,
                                 :wkMbrName   ,                                          //0014
                                 :wkRcdFmt    ,                                          //0014
                                 :wkFmtLvlID  ,                                          //0014
                                 :udObjMapDs.usMbrLib,                                   //0015
                                 :udObjMapDs.usMbrSrcf,                                  //0015
                                 :udObjMapDs.usMbrNam,                                   //0015
                                 :udObjMapDs.usMbrTyp,                                   //0015
                                 :inDDLMbrLib ,
                                 'QDDLSRC'    ,
                                 :wkDDLMbrNm  ,
                                 :wkSrcType   ,
                                 :inDDLObjLib ,
                                 :wkDDLObjNm  ,
                                 :wkDDLLngNm  ,
                                 :wkFileCnvSts,                                          //0007
                                 :wkFileCnvMsg,                                          //0007
                                 'IADDSDDLRT' ,
                                 :inRequestedUser);

      If SqlCode < successCode;
         uDpsds.wkQuery_Name = 'Insert_IADDSDDLDP';
         IaSqlDiagnostic(uDpsds);
      EndIf;
   Else;
      //Get record count to confirm if dependent object already written or not
      Exec Sql
         Select Count(*) Into :wkDependentFileCount From iADdsDdlDP
          Where iAReqId    = :inReqId
            And iARepoNm   = :inRepo
            And iADdsObjLb = :wkDependentLib
            And iADdsObjNm = :wkDependentFile
            And iADdsObjAt = :wkDependentAttr
            And iADdsObjTy = '*FILE'                                                     //0014
            And iADdsMbrNm = :wkMbrName                                                  //0014
            And iADdsRcdFm = :wkRcdFmt;                                                  //0014

      //If dependent file record does not exists, then write a new one
      If wkDependentFileCount = 0;
         Exec Sql
            Insert into IADDSDDLDP (iAReqId   ,
                                    iARepoNm  ,
                                    iADdsFlTyp,                                          //0014
                                    iADdsObjLb,
                                    iADdsObjNm,
                                    iADdsObjAt,
                                    iADdsObjTy,
                                    iADdsMbrNm,                                          //0014
                                    iADdsRcdFm,                                          //0014
                                    iADdsFmtID,                                          //0014
                                    iABasedPF ,
                                    iADdsSrcLb,                                          //0015
                                    iADdsSrcFl,                                          //0015
                                    iADdsSrcMb,                                          //0015
                                    iADdsSrcAt,                                          //0015
                                    iADdlSrcLb,
                                    iADdlSrcFl,
                                    iADdlSrcMb,
                                    iADdlSrcAt,
                                    iADdlObjLb,
                                    iADdlObjNm,
                                    iADdlLngNm,
                                    iAConvSts ,
                                    iAErrMsg  ,                                          //0007
                                    iACrtPgm  ,
                                    iACrtUser )
                            VALUES (:inReqId        ,
                                    :inRepo         ,
                                    :wkFileType     ,                                    //0014
                                    :wkDependentLib ,
                                    :wkDependentFile,
                                    :wkDependentAttr,
                                    '*FILE'         ,
                                    :wkMbrName      ,                                    //0014
                                    :wkRcdFmt       ,                                    //0014
                                    :wkFmtLvlID     ,                                    //0014
                                    :wkBasedPf      ,                                    //0009
                                    :udObjMapDs.usMbrLib,                                //0015
                                    :udObjMapDs.usMbrSrcf,                               //0015
                                    :udObjMapDs.usMbrNam,                                //0015
                                    :udObjMapDs.usMbrTyp,                                //0015
                                    :inDDLMbrLib    ,
                                    'QDDLSRC'       ,
                                    :wkDDLMbrNm     ,                                    //0014
                                    :wkSrcType      ,
                                    :inDDLObjLib    ,
                                    :wkDDLObjNm     ,                                    //0014
                                    :wkDDLLngNm     ,
                                    :wkFileCnvSts   ,                                    //0007
                                    :wkFileCnvMsg   ,                                    //0007
                                    'IADDSDDLRT'    ,
                                    :inRequestedUser);

         If SqlCode < successCode;
            uDpsds.wkQuery_Name = 'Insert_IADDSDDLDP';
            IaSqlDiagnostic(uDpsds);
         EndIf;
      Else;
         Exec Sql
            Update iADdsDdlDP
               Set iABasedPF  = ' '
             Where iAReqId    = :inReqId
               And iARepoNm   = :inRepo
               And iADdsObjLb = :wkDependentLib
               And iADdsObjNm = :wkDependentFile
               And iADdsObjAt = :wkDependentAttr
               And iADdsObjTy = '*FILE';

         If SqlCode < successCode;
            uDpsds.wkQuery_Name = 'Update_IADDSDDLDP';
            IaSqlDiagnostic(uDpsds);
         EndIf;
      EndIf;
   EndIf;

End-Proc;

//------------------------------------------------------------------------------------- //
//WriteDDSDepPgmFile : To populate IADDSDDLPP file                                      //
//------------------------------------------------------------------------------------- //
Dcl-Proc WriteDDSDepPgmFile;

   //Get record count to confirm if dependent object already written or not
   Exec Sql
      Select Count(*) Into :wkDependentPgmCount From iADdsDdlPP
       Where iAReqId    = :inReqId
         And iAPgmObjLb = :wkObjDepLib
         And iAPgmObjNm = :wkObjDepNam
         And iAPgmObjAt = :wkObjDepAttr
         And iAPgmObjTy = :wkObjDepType
         And iAPgmSrcLb = :wkObjSrcLib
         And iAPgmSrcFl = :wkObjSrcFile
         And iAPgmSrcMb = :wkObjSrcMem
         And iAPgmSrcAt = :wkObjSrcAttr
         And iADepObjNm = :wkDepObjNm
         And iADepObjAt = :wkDepObjAttr;

   //If dependent object record does not exists, then write a new one
   If wkDependentPgmCount = 0;
      Exec Sql
         Insert into iADdsDdlPP (iAReqId,    iAPgmObjLb, iAPgmObjNm, iAPgmObjAt,
                                 iAPgmObjTy, iAPgmSrcLb, iAPgmSrcFl, iAPgmSrcMb,
                                 iAPgmSrcAt, iADepObjNm, iADepObjAt, iAPgmChgF,
                                 iACrtPgm,   iACrtUser)
                         Values (:inReqId,      :wkObjDepLib, :wkObjDepNam,  :wkObjDepAttr,
                                 :wkObjDepType, :wkObjSrcLib, :wkObjSrcFile, :wkObjSrcMem,
                                 :wkObjSrcAttr, :wkDepObjNm,  :wkDepObjAttr, 'N',
                                 'IADDSDDLRT',  :inRequestedUser);

      If SqlCode < successCode;
         uDpsds.wkQuery_Name = 'Insert_IADDSDDLPP';
         IaSqlDiagnostic(uDpsds);
      EndIf;
   EndIf;

End-Proc;

//------------------------------------------------------------------------------------- //0014
//ProcessMultiRcdFmtAndMultiMbrFile : Process Multi Record Format/Multi Member File     //0014
//------------------------------------------------------------------------------------- //0014
Dcl-Proc ProcessMultiRcdFmtAndMultiMbrFile;                                              //0014

   Dcl-Pi *N Ind;                                                                        //0014
      pObjLib  Char(10);                                                                 //0014
      pObjName Char(10);                                                                 //0014
      pObjAttr Char(10);                                                                 //0014
   End-Pi;                                                                               //0014

   //LOcal Variables                                                                    //0014
   Dcl-S  uwDDLMbrNm   Char(10)   Inz;                                                   //0014
   Dcl-S  uwDDLObjNm   Char(10)   Inz;                                                   //0014
   Dcl-S  uwRcdFound   Ind        Inz('0');                                              //0014

   uwMRFUnionFlg = *Off;                                                                 //0014
   uwMMFUnionFlg = *Off;                                                                 //0014

   //Store Current DDL Source and Object Name as it will change for                     //0014
   //Multi Record Format and Multi Member File Type                                     //0014
   uwDDLMbrNm = wkDDLMbrNm;                                                              //0014
   uwDDLObjNm = wkDDLObjNm;                                                              //0014

   //File Type is either PF/LF                                                          //0014
   wkFileType = pObjAttr;                                                                //0014

   //DDS Object Information                                                             //0014
   wkObjLib  = pObjLib;                                                                  //0014
   wkObjName = pObjName;                                                                 //0014

   //Open cursor                                                                        //0014
   Exec Sql Open CursorRecordFormat;                                                     //0014
   If sqlCode = CSR_OPN_COD;                                                             //0014
      Exec Sql Close CursorRecordFormat;                                                 //0014
      Exec Sql Open  CursorRecordFormat;                                                 //0014
   EndIf;                                                                                //0014

   If sqlCode < successCode;                                                             //0014
      uDpsds.wkQuery_Name = 'Open_CursorRecordFormat';                                   //0014
      IaSqlDiagnostic(uDpsds);                                                           //0014
   EndIf;                                                                                //0014

   //Get the number of elements                                                         //0014
   noOfRcdFmt = %elem(udRcdFmtDs);                                                       //0014

   //Fetch records from CursorRecordFormat                                              //0014
   rowFound = FetchCursorRecordFormat();                                                 //0014

   //File is Multi Record Format when no of record format fetched more than one         //0014
   If RecordFormatFetched > 1;                                                           //0014
      wkFileType = 'MRF';                                                                //0014
      uwMRFUnionFlg = *On;                                                               //0014
   EndIf;                                                                                //0014

   DoW rowFound;                                                                         //0014

      For uiRcdFmtIdx = 1 To RecordFormatFetched;                                        //0014

         wkRcdFmt   = udRcdFmtDs(uiRcdFmtIdx).usRcdFmt;                                  //0014
         wkFmtLvlID = udRcdFmtDs(uiRcdFmtIdx).usFmtLvlID;                                //0014
         If uwMRFUnionFlg;                                                               //0014

            //Fetch records from CursorFileField                                        //0014
            uwRcdFound = FetchCursorFileField();                                         //0014
            //Flag for Union of all record format file creation                         //0014
            //If all record format field is not in same sequence/data type/length then  //0014
            //no need to create union of all record format                              //0014
            If wkMbrName <> *Blanks and not chkFileFldForAllRcdFmt();                    //0014
               uwMRFUnionFlg = *Off;                                                     //0014
            EndIf;                                                                       //0014

            Clear udMRFField;
            //Store Last Record Format Field Details
            udMRFField = udFileField;

         EndIf;                                                                          //0014

         Clear wkMbrName;                                                                //0014
         //Add members for selected record format                                       //0014
         addMbrsForSlectedRcdFmt(pObjLib                                                 //0014
                                 :pObjName                                               //0014
                                 :pObjAttr);                                             //0014
      EndFor;                                                                            //0014

      //If fetched rows are less than the array elements then come out of the loop.     //0014
      If RecordFormatFetched < noOfRcdFmt;                                               //0014
         Leave;                                                                          //0014
      EndIf;                                                                             //0014

      //Fetched next set of rows.                                                       //0014
      rowFound = FetchCursorRecordFormat();                                              //0014

   EndDo;                                                                                //0014

   //Close Cursor CursorRecordFormat                                                    //0014
   Exec Sql Close CursorRecordFormat;                                                    //0014

   //If all record format field is not in same structure than skip union of all record  //0014
   //format file creation for Multi Record Format File                                  //0014
   If wkFileType = 'MRF' and not uwMRFUnionFlg;                                          //0014
      Return *On;                                                                        //0014
   EndIf;                                                                                //0014

   //If LF having one member which depends more than one member of PF then no need to   //0014
   //create another file which will be union of all members of LF members               //0014
   If wkFileType = 'MMF' and not uwMMFUnionFlg;                                          //0014
      Return *On;                                                                        //0014
   EndIf;                                                                                //0014

   //Preapre Final File for Multi Record Format/Multi Member File which will be Union   //0014
   //of its record format/member                                                        //0014
   If wkFileType = 'MRF' or wkFileType = 'MMF';                                          //0014
      wkSrcType  = 'LFSQL';                                                              //0014
      wkMbrName  = *Blanks;                                                              //0014
      wkRcdFmt   = udRcdFmtDs(1).usRcdFmt;                                               //0014
      wkFmtLvlID = udRcdFmtDs(1).usFmtLvlID;                                             //0014
      wkDDLMbrNm = uwDDLMbrNm;                                                           //0014
      wkDDLObjNm = uwDDLObjNm;                                                           //0014
      //Write Record into iADdsDdlDP                                                    //0014
      WriteiADdsDdlDP();                                                                 //0014
      Return *On;                                                                        //0014
   EndIf;                                                                                //0014

   Return *Off;                                                                          //0014

End-Proc;                                                                                //0014

//------------------------------------------------------------------------------------- //0014
//addMbrsForSlectedRcdFmt : Add members for selected record format                      //0014
//------------------------------------------------------------------------------------- //0014
Dcl-Proc addMbrsForSlectedRcdFmt;                                                        //0014

   Dcl-Pi *N;                                                                            //0014
      upObjLib    Char(10);                                                              //0014
      upObjName   Char(10);                                                              //0014
      upObjAttr   Char(10);                                                              //0014
   End-Pi;                                                                               //0014

   //Open cursor                                                                        //0014
   Exec Sql Open CursorFileMember;                                                       //0014
   If sqlCode = CSR_OPN_COD;                                                             //0014
      Exec Sql Close CursorFileMember;                                                   //0014
      Exec Sql Open  CursorFileMember;                                                   //0014
   EndIf;                                                                                //0014

   If sqlCode < successCode;                                                             //0014
      uDpsds.wkQuery_Name = 'Open_CursorFileMember';                                     //0014
      IaSqlDiagnostic(uDpsds);                                                           //0014
   EndIf;                                                                                //0014

   //Get the number of elements                                                         //0014
   noOfMbr = %elem(udFileMbrDs);                                                         //0014

   //Fetch records from CursorFileMember                                                //0014
   rowFound = FetchCursorFileMember();                                                   //0014

   //Join Logical File depends on more than one member                                  //0014
   If udFileMbrDs(1).usJoinFlg = 'Y';                                                    //0014
      wkFileType = 'JLF';                                                                //0014
      uwMMFUnionFlg = *Off;                                                              //0014
      wkMbrName = udFileMbrDs(1).usMbrName;                                              //0014
      //Close Cursor CursorFileMember                                                   //0014
      Exec Sql Close CursorFileMember;                                                   //0014
      Return;
   EndIf;                                                                                //0014

   //File Type is Multi Member File                                                     //0014
   If FileMemberFetched > 1;                                                             //0014
      wkFileType = 'MMF';                                                                //0014
      uwMMFUnionFlg = *On;                                                               //0014
   EndIf;                                                                                //0014

   DoW rowFound;                                                                         //0014
      For uiFileMbrIdx = 1 To FileMemberFetched;                                         //0014
         If wkMbrName = udFileMbrDs(uiFileMbrIdx).usMbrName;                             //0014
            Iter;                                                                        //0014
         EndIf;                                                                          //0014
         //Member Name of File                                                          //0014
         wkMbrName  = udFileMbrDs(uiFileMbrIdx).usMbrName;                               //0014

         //DDL Source Name and Object Name for Multi Record Format                      //0014
         //and Multi Member File                                                        //0014
         Select;                                                                         //0014
            When wkFileType = 'MRF';                                                     //0014
               wkDDLMbrNm = GenerateFileName(wkRcdFmt : wkFileType);                     //0014
               wkDDLObjNm = wkDDLMbrNm;                                                  //0014
            When wkFileType = 'MMF' and                                                  //0014
               udFileMbrDs(1).usNoOfMbr = 1;                                             //0014
               uwMMFUnionFlg = *Off;                                                     //0014
            When wkFileType = 'MMF';                                                     //0014
               wkDDLMbrNm = GenerateFileName(wkMbrName : wkFileType);                    //0014
               wkDDLObjNm = wkDDLMbrNm;                                                  //0014
            Other;                                                                       //0014
         EndSl;                                                                          //0014

         If wkFileType = 'MRF' or wkFileType = 'MMF';                                    //0014
            //Write Record into iADdsDdlDP                                              //0014
            WriteiADdsDdlDP();                                                           //0014
         EndIf;                                                                          //0014

      EndFor;                                                                            //0014

      //If fetched rows are less than the array elements then come out of the loop.     //0014
      If FileMemberFetched < noOfMbr;                                                    //0014
         Leave;                                                                          //0014
      EndIf ;                                                                            //0014

      //Fetched next set of rows.                                                       //0014
      rowFound = FetchCursorFileMember();                                                //0014

   EndDo;                                                                                //0014

   //Close Cursor CursorFileMember                                                      //0014
   Exec Sql Close CursorFileMember;                                                      //0014

End-Proc;                                                                                //0014

//------------------------------------------------------------------------------------- //0014
//FetchCursorRecordFormat : To fetch all record format information of file              //0014
//------------------------------------------------------------------------------------- //0014
Dcl-Proc FetchCursorRecordFormat;                                                        //0014

   Dcl-Pi FetchCursorRecordFormat Ind End-Pi ;                                           //0014

   Dcl-S  rcdFound Ind Inz('0');                                                         //0014
   Dcl-S  wkRowNum Uns(5);                                                               //0014

   RecordFormatFetched = *Zeros;                                                         //0014
   Clear udRcdFmtDs;                                                                     //0014

   Exec Sql                                                                              //0014
      Fetch CursorRecordFormat For :noOfRcdFmt Rows Into :udRcdFmtDs;                    //0014

   If sqlCode < successCode;                                                             //0014
      uDpsds.wkQuery_Name = 'Fetch_CursorRecordFormat';                                  //0014
      IaSqlDiagnostic(uDpsds);                                                           //0014
   EndIf;                                                                                //0014

   If sqlcode = successCode;                                                             //0014
      Exec Sql Get Diagnostics                                                           //0014
         :wkRowNum = ROW_COUNT;                                                          //0014
         RecordFormatFetched = wkRowNum ;                                                //0014
   EndIf;                                                                                //0014

   If RecordFormatFetched > 0;                                                           //0014
      rcdFound = TRUE;                                                                   //0014
   ElseIf sqlcode < successCode ;                                                        //0014
      rcdFound = FALSE;                                                                  //0014
   EndIf;                                                                                //0014

   Return rcdFound;                                                                      //0014

End-Proc;                                                                                //0014

//------------------------------------------------------------------------------------- //0014
//FetchCursorFileMember : To Fetch all member information of file                       //0014
//------------------------------------------------------------------------------------- //0014
Dcl-Proc FetchCursorFileMember;                                                          //0014

   Dcl-Pi FetchCursorFileMember Ind End-Pi ;                                             //0014

   Dcl-S  rcdFound Ind Inz('0');                                                         //0014
   Dcl-S  wkRowNum Uns(5);                                                               //0014

   FileMemberFetched = *Zeros;                                                           //0014
   Clear udFileMbrDs;                                                                    //0014

   Exec Sql                                                                              //0014
      Fetch CursorFileMember For :noOfMbr Rows Into :udFileMbrDs ;                       //0014

   If sqlCode < successCode;                                                             //0014
      uDpsds.wkQuery_Name = 'Fetch_CursorFileMember';                                    //0014
      IaSqlDiagnostic(uDpsds);                                                           //0014
   EndIf;                                                                                //0014

   If sqlcode = successCode;                                                             //0014
      Exec Sql Get Diagnostics                                                           //0014
         :wkRowNum = ROW_COUNT;                                                          //0014
         FileMemberFetched = wkRowNum ;                                                  //0014
   EndIf;                                                                                //0014

   If FileMemberFetched > 0;                                                             //0014
      rcdFound = TRUE;                                                                   //0014
   ElseIf sqlcode < successCode ;                                                        //0014
      rcdFound = FALSE;                                                                  //0014
   EndIf;                                                                                //0014

   Return rcdFound;                                                                      //0014

End-Proc;                                                                                //0014

//------------------------------------------------------------------------------------- //
//GetDDSSrcInfo : Get DDS Source Member Information                                     //
//------------------------------------------------------------------------------------- //
Dcl-Proc GetDDSSrcInfo;                                                                  //0013

   Dcl-Pi *N;                                                                            //0013
     pObjLib  Char(10);                                                                  //0013
     pObjName Char(10);                                                                  //0013
     pObjAttr Char(10);                                                                  //0013
   End-Pi;                                                                               //0013

   //Get the Source Details from IAOBJMAP                                               //0013
   Clear udObjMapDs;                                                                     //0013
   Exec Sql                                                                              //0013
      Select iAMbrLib, iAMbrSrcf, iAMbrNam, iaMbrTyp                                     //0013
        into :udObjMapDs                                                                 //0013
        from iAObjMap                                                                    //0013
      Where iAObjLib = :pObjLib                                                          //0013
        And iAObjNam = :pObjName                                                         //0013
        And iAObjTyp = '*FILE'                                                           //0013
        And iAObjAtr = :pObjAttr;                                                        //0013

End-Proc;                                                                                //0013

//------------------------------------------------------------------------------------- //
//SetEnvForCompilation : To fetch Repo libraries and set environment for compilation    //
//------------------------------------------------------------------------------------- //
  Dcl-Proc SetEnvForCompilation;                                                         //0003

   Dcl-S uwLibIdx    Uns(5);                                                             //0003

   //To set DDL object library at the first position we need to remove first            //0008
   wkCommand = 'RMVLIBLE LIB(' + %trim(inDDLObjLib) + ')';                               //0008
   RunCmd();                                                                             //0008
   Clear wkCommand;                                                                      //0008

   //Open Cursor                                                                        //0003
   Exec Sql Open CursorLibL;                                                             //0003
   If SqlCode = CSR_OPN_COD;                                                             //0003
      Exec Sql Close CursorLibL;                                                         //0003
      Exec Sql Open  CursorLibL;                                                         //0003
   EndIf;                                                                                //0003

   If SqlCode < SuccessCode;                                                             //0003
      uDpsds.wkQuery_Name = 'Open_CursorLibL';                                           //0003
      IaSqlDiagnostic(uDpsds);                                                           //0003
   EndIf;                                                                                //0003

   //Get the number of elements                                                         //0003
   uwRows = %elem(udLibDs);                                                              //0003

   //Fetch records from CursorLibL                                                      //0003
   uwRowFound = FetchRecordCursorLibL();                                                 //0003

   DoW uwRowFound;                                                                       //0014
      For uwLibIdx = 1 To uwRowsFetched;                                                 //0003
         //Add repo libraries to the library list                                       //0003
         wkCommand = 'ADDLIBLE LIB(' + %trim(udLibDs(uwLibIdx).usLib) + ')';             //0003
         RunCmd();                                                                       //0003
      EndFor;                                                                            //0003

      //If fetched rows are less than the array elements then come out of the loop.     //0014
      If uwRowsFetched < uwRows;                                                         //0014
         Leave ;                                                                         //0014
      EndIf ;                                                                            //0014

      //Fetched next set of rows.                                                       //0014
      uwRowFound = FetchRecordCursorLibL();                                              //0014

   EndDo;                                                                                //0014

   //Close Cursor CursorLibL
   Exec Sql Close CursorLibL;                                                            //0003

   //To set DDL object library at the first position                                    //0008
   wkCommand = 'ADDLIBLE LIB(' + %trim(inDDLObjLib) + ') POSITION(*FIRST)';              //0008
   RunCmd();                                                                             //0003
   Clear wkCommand;                                                                      //0003

End-Proc;                                                                                //0003

//------------------------------------------------------------------------------------- //
//FetchRecordCursorLibl : Fetch library list of repo from cursor                        //
//------------------------------------------------------------------------------------- //
Dcl-Proc FetchRecordCursorLibL;                                                          //0003

   Dcl-Pi FetchRecordCursorLibL Ind;                                                     //0003
   End-Pi;                                                                               //0003

   Dcl-S uwRcdFound  Ind  Inz;                                                           //0003

   //Fetch number of rows from IAINPLIB that the array DS can hold                      //0003
   Exec Sql                                                                              //0003
      Fetch CursorLibL For :uwRows Rows Into                                             //0003
              :udLibDs;                                                                  //0003

   If SqlCode < SuccessCode;                                                             //0003
      uDpsds.wkQuery_Name = 'Fetch_LibraryList';                                         //0003
      IaSqlDiagnostic(uDpsds);                                                           //0003
   EndIf;                                                                                //0003

   //If the fetch is succesful, get how many rows are fetched                           //0003
   If Sqlcode = SuccessCode;                                                             //0003
      Exec Sql Get Diagnostics                                                           //0003
           :uwRowsFetched = ROW_COUNT;                                                   //0003
   Else;                                                                                 //0003
      uwRowsFetched = 0;                                                                 //0003
   EndIf;                                                                                //0003

   //If atleast one row is fetched                                                      //0003
   If uwRowsFetched > 0;                                                                 //0003
      uwRcdFound = TRUE;                                                                 //0003
   //If zero rows are fetched                                                           //0003
   Else;                                                                                 //0003
      uwRcdFound = FALSE;                                                                //0003
   EndIf;                                                                                //0003
                                                                                         //0003
   Return uwRcdFound;

End-Proc;                                                                                //0003

//------------------------------------------------------------------------------------- //0014
//parentPFObjCreated : To check if for given LFs all parent PFs are created             //0014
//------------------------------------------------------------------------------------- //0014
Dcl-Proc parentPFObjCreated;                                                             //0014
   Dcl-Pi parentPFObjCreated Ind;                                                        //0014
   End-Pi;                                                                               //0014
                                                                                         //0014
   Exec Sql                                                                              //0014
      Select A.Whrfi                                                                     //0014
        Into :wkMsgVars                                                                  //0014
        From iADspDbr A                                                                  //0014
       Where A.whrefi = :wkFileName                                                      //0014
         And A.Whreli = :inDDSLibrary                                                    //0014
         And not exists                                                                  //0014
      (Select * from iADdsDdlDP                                                          //0014
       Where iARepoNm   = :inRepo                                                        //0014
         And iADdsObjNm = A.Whrfi                                                        //0014
         And iADdsObjLb = A.Whrli                                                        //0014
         And iADdlObjLb = :inDDLObjLib)                                                  //0014
       Fetch First Rows Only;                                                            //0014
                                                                                         //0014
   If SqlCode = SuccessCode;                                                             //0014
      Return *Off;                                                                       //0014
   EndIf;                                                                                //0014
                                                                                         //0014
   Return *On;                                                                           //0014
                                                                                         //0014
End-Proc;                                                                                //0014

//------------------------------------------------------------------------------------- //0007
//chkValidFileForConv : Check valid file for conversion or not                          //0007
//------------------------------------------------------------------------------------- //0007
Dcl-Proc chkValidFileForConv;                                                            //0014
   Dcl-Pi *N Ind;
      pLibNam Char(10);
      pObjNam Char(10);
   End-Pi;

   Clear wkRcdFrmtCount;
   Clear wkJoinFile;
   Clear wkRcdFmt;                                                                       //0014
   Clear wkFmtLvlID;                                                                     //0014
   Clear wkMbrName;                                                                      //0014

   //Verify DDL File
   If isSqlFile(pLibNam : pObjNam);
      outStatus  = 'E';
      //This is DDL File
      iAGetMsg('1':'MSG0203':wkMsgDesc:' ');
      outMessage = %Trim(wkMsgDesc);
      Return *Off;
   EndIf;

   //File name to get Parent Physical File Name of Logical File
   wkFileName = pObjNam;

   //Verify the parent physical file of Multi Record Format File and Join Logical       //0014
   //file created in DDL Object Library                                                 //0014
   If wkSrcType = 'LFSQL' and not parentPFObjCreated();                                  //0014
      //Get the number of record format and join file flag                              //0014
      Exec Sql                                                                           //0014
         Select mbNoFm, mbjoin Into :wkRcdFrmtCount, :wkJoinFile                         //0014
           From iDspFdMbr                                                                //0014
          Where mbLib  = :pLibNam                                                        //0014
            And mbFile = :pObjNam                                                        //0014
          Fetch First Row Only;                                                          //0014

      Select;                                                                            //0014
      When wkJoinFile ='Y';                                                              //0014
         //File Type is Join Logical File                                               //0014
         wkFileType = 'JLF';                                                             //0014
         outStatus = 'E';
         outMessage = %Trim(wkMsgDesc);
         //DDL must be created for joined PF before creating DDL for Join LF.
         iAGetMsg('1':'MSG0216':wkMsgDesc:wkMsgVars);
         outMessage = %Trim(wkMsgDesc);
         Return *Off;

      When wkRcdFrmtCount > 1;                                                           //0014
         //File Type is Multi Record Format File                                        //0014
         wkFileType = 'MRF';                                                             //0014
         outStatus  = 'E';                                                               //0014
         //DDL must be created for PF before creating DDL for Multi Record Format.      //0014
         iAGetMsg('1':'MSG0221':wkMsgDesc:wkMsgVars);                                    //0014
         outMessage = %Trim(wkMsgDesc);                                                  //0014
         Return *Off;                                                                    //0014

      Other;
         //File Type is Logical File                                                    //0014
         wkFileType = 'LF';                                                              //0014
         outStatus = 'E';                                                                //0014
         outMessage = %Trim(wkMsgDesc);                                                  //0014
         //DDL must be created for PF before creating DDL for LF.                       //0014
         iAGetMsg('1':'MSG0222':wkMsgDesc:wkMsgVars);                                    //0014
         outMessage = %Trim(wkMsgDesc);                                                  //0014
         Return *Off;                                                                    //0014

      EndSl;
   EndIf;

   Return *On;

End-Proc;                                                                                //0007

//------------------------------------------------------------------------------------- //0014
//GenerateFileName : Generate the file name of Multi Record format/Multi Member File    //0014
//------------------------------------------------------------------------------------- //0014
Dcl-Proc GenerateFileName;                                                               //0014

   Dcl-Pi *N Char(10);                                                                   //0014
      upFileName Char(10);                                                               //0014
      upFileType Char(3);                                                                //0014
   End-Pi;                                                                               //0014

   //Local variables                                                                    //0014
   Dcl-S  uwFileName Char(10) Inz;                                                       //0014
   Dcl-S  uwName     Char(10) Inz;                                                       //0014
   Dcl-S  uwLastName Char(10) Inz;                                                       //0014
   Dcl-S  uwNextSeq  Packed(2:0) Inz(1);                                                 //0014
   Dcl-S  uwFileLen  Packed(2:0) Inz(0);                                                 //0014

   uwFileLen = %Len(%Trim(upFileName));                                                  //0014
   If uwFileLen > 7;                                                                     //0014
      uwFileName = %SubSt(upFileName : 1 : 7);                                           //0014
      uwFileLen = 8;                                                                     //0014
   Else;                                                                                 //0014
      uwFileName = upFileName;                                                           //0014
      uwFileLen += 1;                                                                    //0014
   EndIf;                                                                                //0014

   //Adding Suffix 'V' for Multi record Format and 'M' for Multi Member File            //0014
   If upFileType = 'MRF';                                                                //0014
      uwFileName = %Trim(uwFileName) + 'V';                                              //0014
   ElseIf upFileType = 'MMF';                                                            //0014
      uwFileName = %Trim(uwFileName) + 'M';                                              //0014
   EndIf;                                                                                //0014

   uwName = %Trim(uwFileName) + '%';                                                     //0014

   Exec Sql                                                                              //0014
      Select iADdlObjNm into : uwLastName                                                //0014
        From iADdsDdlDP                                                                  //0014
       Where iADdlObjLb = :inDDLObjLib                                                   //0014
         And iADdlObjNm Like Trim(:uwName)                                               //0014
             Order by iADdlObjNm Desc                                                    //0014
             Fetch First Row Only;                                                       //0014

   If SqlCode = successCode;                                                             //0014
      Monitor;                                                                           //0014
         uwNextSeq = %Int(%Trim(%SubSt(uwLastName : uwFileLen + 1))) + 1;                //0014
      On-Error;                                                                          //0014
      EndMon;                                                                            //0014
   EndIf;                                                                                //0014

   uwFileName = %Trim(uwFileName) + %Editc(uwNextSeq : 'X');                             //0014

   Return uwFileName;                                                                    //0014

End-Proc;                                                                                //0014

//------------------------------------------------------------------------------------- //0014
//chkFileFldForAllRcdFmt : Check file field is same for all record format in case of MRF//0014
//------------------------------------------------------------------------------------- //0014
Dcl-Proc chkFileFldForAllRcdFmt;                                                         //0014
   Dcl-Pi *N Ind;                                                                        //0014
   End-Pi;                                                                               //0014

   //Field attribute checking with first record format field                            //0014
   For uiFldIdx = 1 to FileFieldFetched;                                                 //0014
      If udMRFField(uiFldIdx).usRcdFmtL  <> udFileField(uiFldIdx).usRcdFmtL  Or          //0014
         udMRFField(uiFldIdx).usFldByte  <> udFileField(uiFldIdx).usFldByte  Or          //0014
         udMRFField(uiFldIdx).usFldDigit <> udFileField(uiFldIdx).usFldDigit Or          //0014
         udMRFField(uiFldIdx).usFldPos   <> udFileField(uiFldIdx).usFldPos;              //0014
         Return *Off;                                                                    //0014
      EndIf;                                                                             //0014
   EndFor;                                                                               //0014

   Return *On;                                                                           //0014

End-Proc;                                                                                //0014

