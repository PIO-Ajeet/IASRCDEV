**free
      //%METADATA                                                      *
      // %TEXT IA - DDStoDDL Program For DDL Source Creation           *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------- //
//Created By  : Programmers.io @ 2024                                                   //
//Created Date: 2024/02/29                                                              //
//Developer   : Programmers.io                                                          //
//Description : This program generate DDL source for the input DDS object and           //
//              return parameter outStatus has below values:                            //
//              'E' = Error                                                             //
//              'S' = Successfull                                                       //
//                                                                                      //
//                       Input Parameters:                                              //
//              inReqId          -  Request Id                                          //
//              inRepo           -  Repo Name                                           //
//             inDDSObjNam      -  DDS Object Name                                     //
//             inDDSLibrary     -  DDS Object Library                                  //
//              inDDSObjType     -  DDS Object Type                                     //
//              inDDSFileType    -  DDS File Type                                       //
//              inDDSMbrName     -  DDS Member Name                                     //
//              inDDSRcdFmt      -  DDS Record Format                                   //
//              inDDLSrcAtr      -  DDL Source Member Attribute                         //
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
//Procedure Name                | Procedure Description                                 //
//------------------------------|-------------------------------------------------------//
//GetKeysList                   | To check & get Primary Keys/normal keys, if defined   //
//GenerateDDStoDDLforPF         | Generate DDL source for Physical File                 //
//GenerateDDStoDDLforLF         | Generate DDL source for Logical File                  //
//LoadHeaderPart                | To load the header details of DDL source              //
//LoadDDLSourceMapDetails       | To load DDL source mappings                           //
//BuiltDDLSourceMapDetails      | To Prepare and Load DDL Source Data                   //
//GetFileFieldsForDDLSource     | To get File Fields for DDL Source                     //
//FetchRecordCursorDDLFldSrc    | To fetch DDL Fields source                            //
//LoadDDLSrcDtaArray            | To Load DDL source Array                              //
//ClearDDLSrcEntry              | Clear the DDL Source Entry in IADDLSRCP               //
//WriteDDLMember                | Write the complete DDL Source Data to DDL Member      //
//WriteDDLSourc                 | Write DDL Sources for converted DDS Source.           //
//GetLogicalFileInfo            | To get necessary information from DDS Logical File    //
//GetLogicalFileDetails         | To get all the details of DDS Logical File            //
//FetchLogicalFileRecFormat     | To fetch record formats of Logical File               //
//ChkFieldMatchesWithPF         | Check Fields are Matches with Physical file           //
//GetFieldAttributes            | Get attributes like DataType, AllowNull and Defaults  //
//CreateEntriesForCompilation   | To write dependent file details in IADDSDDLDP         //
//GetNextFileIndexSequence      | Get Next File Index Sequence                          //
//GetJoinPhysicalFile           | To get physical file details that are used to create  //
//                              | join LF                                               //
//FetchRecordCursorPhysicalFi...| Fetch Physical Files that are used to create          //
//leDetails                     | Join Logical File                                     //
//GetJoinType                   | Get type of join logical file                         //
//LoadSelectOmitCondition       | Load the Select/Omit Condition                        //
//FetchSelectOmitCondition      | To fetch the select/omit condition of file            //
//CheckPfLfFileFieldOrder       | Check if PF and LF files has fields defined           //
//                              | in the same order                                     //
//GetPhysicalFileTableName      | Get the Converted Physical File Table Name            //
//GetDDSSrcInfo                 | Get DDS Source Member Information                     //
//GenerateDDStoDDLforMultiFile  | Generate DDL for Multi Record Format & Multi          //
//                              | Member file                                           //
//FetchCursorMultiFile          | To fetch all multi record format or multi member file //
//GenerateDDStoDDLforMultiMbr   | To generate DDL for LF member which depend more than  //
//                              | one member of PF file                                 //
//FetchCursorMultiMbr           | To fetch dependent member details                     //
//AddSrcMember                  | Add Source Member                                     //
//RunCmd                        | To execute the command                                //
//------------------------------------------------------------------------------------- //
//Modification Log:                                                                     //
//------------------------------------------------------------------------------------- //
//Date-DMY| Mod_ID | Developer  | Case and Description                                  //
//--------|--------|------------|------------------------------------------------------ //
//17/09/24| 0001   |Dada Bachute|Task-950 DDStoDDL Phase2 : Getting Diagnostic Message  //
//        |        |            |when view the DDL Source in Green Scren.               //
//17/09/24| 0002   |Piyush Kumar|Task#943 - Adding record format for View               //
//19/09/24| 0003   |Shomi Biswas|Task#955 - Semicolon is missing for index query        //
//19/09/24| 0004   |Dada Bachute|Task#954 - Handle the Renaming statement for DDL source//
//25/09/24| 0005   |Shomi Biswas|Task#937 - Convert Join Logical DDS File to DDL        //
//26/09/24| 0006   |Jeeva       |Task#964 - Handle the Descending keyword for keys.     //
//        |        |            |           Increase the field length of fields         //
//        |        |            |           wkKeyFieldName, wkPrimaryKeyList and        //
//        |        |            |           wkKeyList.                                  //
//26/09/24| 0007   |Piyush Kumar|Task#965 - When Keyed LF have Fewer Field from PF      //
//        |        |            |then create View for selected field and index on key.  //
//        |        |            |Task#955 changes reverted.                             //
//26/09/24| 0008   |K Abhishek A|Task#969 - Reformat the DDL to make it more readable   //
//30/09/24| 0009   |Shomi Biswas|Task#973 - Restructing variables length to align       //
//        |        |            |actual possible length in IADDSDDLSC Pgm               //
//03/10/24| 0010   |Piyush Kumar|Task#967 - Select/Omit logic preparing and adding in   //
//        |        |            |           where clause.                               //
//09/10/24| 0011   |Piyush Kumar|Task#1005 - Rename Table Query should be inserted when //
//        |        |            |Long Name different from DDL Object Name               //
//23/10/24| 0012   |Piyush Kumar|Task#1032 - Keep a space between table name and the    //
//        |        |            |bracket while creating index or view.                  //
//23/10/24| 0013   |Piyush Kumar|Task#1033 - In select/omit cond numeric fields should  //
//        |        |            |be compared with numeric values instead of char value. //
//        |        |            |-Fixed Decimal issue from select/omit field.           //
//23/10/24| 0014   |Piyush Kumar|Task#1034 - Removing the not for omit and using reverse//
//        |        |            |operator.                                              //
//23/10/24| 0015   |Piyush Kumar|Task#1042 - In select/omit optimise the opening and    //
//        |        |            |closing bracket.                                       //
//24/10/24| 0016   |Piyush Kumar|Task#1029 - DDL source should not include TEXT block   //
//        |        |            |in case none of the fields has Text description.       //
//        |        |            |- Increasing the internal and external field as its    //
//        |        |            |having additional alias name when join file            //
//        |        |            |- Label on Table/Index/View should be in DDL source    //
//        |        |            |when objetc text is not blank                          //
//25/10/24| 0017   |Piyush Kumar|Task#1039 - Adding DDS File Field Function to DDL File //
//        |        |            |where mapped function picked from IAFILEDTL file.      //
//        |        |            |- Map DDS Field Key to SQL Function.                   //
//16/10/24| 0018   |Jeeva       |Task#1017- Logical file DDL converison fix - when PF   //
//        |        |            |           and LF has same no of fields but the order  //
//        |        |            |           of fields in LF is different from PF.       //
//        |        |Karthick S  |Task#1017- Added validation for Record format length   //
//        |        |            |           between Physical and logical file.          //
//29/10/24| 0019   |Piyush Kumar|Task#1020 - When Physical file have different DDL      //
//        |        |            |object name then dependent file should be depend on    //
//        |        |            |the DDL object name not on DDS object name.            //
//06/11/24| 0020   |Piyush Kumar|Task#1056 - Changed the field name and texent DDL      //
//        |        |            |- File Keyed will be set as 'Y' for both PF/LF         //
//08/11/24| 0021   |Pranav Joshi|Changed SQL query where it may fetch multiple records  //
//        |        |            |in single variable. This will unnecessarily generate   //
//        |        |            |the warnings and job log, and initialized variable to  //
//        |        |            |avoid any future issues.                               //
//12/11/24| 0022   |Sasikumar R |Task#1053 - The DDL object text should be taken from   //
//        |        |            |DDS object text.                                       //
//        |        |            |- In the Header description will be DDS Member text    //
//03/12/24| 0023   |Piyush Kumar|Task#1072 - Multi Record Format and Multi Member File  //
//        |        |            |Implementation.                                        //
//        |        |            |- Changed the existing procedure to select file        //
//        |        |            |information based on record format and member  name.   //
//        |        |            |Added New Procedure : -                                //
//        |        |            |1.GenerateDDStoDDLforMultiFile                         //
//        |        |            |2.FetchCursorMultiFile                                 //
//        |        |            |3.GenerateDDStoDDLforMultiMbr                          //
//        |        |            |4.FetchCursorMultiMbr                                  //
//03/01/25| 0024   |Shubhra D   |Task#1092 - CONCAT and SST key not working for Join LF //
//        |        |            |- Changed the existing procedure to execute            //
//        |        |            |  chekFieldFunc for Join LF                            //
//06/11/24| 0025   |Piyush Kumar|Task#1021 - Code commenting as DDS Source information  //
//        |        |            |already populated in IADDSDDLRT program                //
//03/01/25| 0026   |Shubhra     |Task#1098 - Issue with logical having more than 1      //
//        |        | Dubey      |function on same field                                 //
//        |        |            |- Clearing udFieldFunc for the index already processed //
//        |        |            |  so that it is not again picked in the lookup when    //
//        |        |            |  having function on same field                        //
//------------------------------------------------------------------------------------- //
//------------------------------------------------------------------------------------- //
Ctl-Opt CopyRight('Copyright @ Programmers.io © 2024');
Ctl-Opt Option(*NoDebugIo:*SrcStmt:*NoUnRef);
Ctl-Opt BndDir('IABNDDIR' : 'IAERRBND');
Ctl-Opt ActGrp(*Caller);

//------------------------------------------------------------------------------------- //
//Standalone Variables                                                                  //
//------------------------------------------------------------------------------------- //
Dcl-S wkDDSTODDL             Char(10)       Inz('DDSTODDL');
Dcl-S wkSpace                Char(1)        Inz(' ');
Dcl-S wkObjType              Char(10)       Inz('*FILE');
Dcl-S wkObjAtr               Char(10)       Inz(' ');
Dcl-S wkRecordFormat         Char(10)       Inz('');
Dcl-S wkKeyFieldName         Char(15)       Inz;                                         //0006
Dcl-S wkSourceMapping        Char(80000)    Inz;                                         //0009
Dcl-S wkSourceMap            Char(276)      Inz;                                         //0009
Dcl-S wkAllFieldSelect       Char(1)        Inz('N');
Dcl-S wkDiffFieldNames       Char(1)        Inz('N');
Dcl-S wkIsMultiFormat        Char(1)        Inz('N');
Dcl-S wkIsPrimaryKey         Char(1)        Inz('N');
Dcl-S WkIncludeIdCol         Char(1)        Inz('N');
Dcl-S wkPhysicalFile         Char(10)       Inz;
Dcl-S wkPhysicalFileLib      Char(10)       Inz;
Dcl-S wkPhysicalFileMbr      Char(10)       Inz;                                         //0023
Dcl-S wkLogicalFileRecFormat Char(10)       Inz;
Dcl-S wkInternalFldName      Char(100)      Inz;                                         //0017
Dcl-S wkExternalFldName      Char(100)      Inz;                                         //0017
Dcl-S wkFldName              Char(100)      Inz;                                         //0017
Dcl-S wkLibraryName          Char(10)       Inz;
Dcl-S wkMemberName           Char(10)       Inz;
Dcl-S wkIndexName            Char(20)       Inz;
Dcl-S wkUnqFlg               Char(1)        Inz('N');
Dcl-S wkFileKeyed            Char(1)        Inz('N');                                    //0020
Dcl-S wkKeyIdxNm             Char(10)       Inz;
Dcl-S wkSqlStmt              Char(200)      Inz;
Dcl-S wkMainFileEntry        Char(1)        Inz('1');
Dcl-S wkDependentFileEntry   Char(1)        Inz('2');
Dcl-S wkMsgDesc              Char(1000)     Inz;
Dcl-S wkMsgVars              Char(80)       Inz;
Dcl-S wkJoinFlg              Char(1)        Inz('N');                                    //0005
Dcl-S wkJoinType             Char(1)        Inz;                                         //0005
Dcl-S wkJoinVal              Char(20)       Inz;                                         //0005
Dcl-S wkJoinHldFile          Char(10)       Inz;                                         //0005
Dcl-S wkAPIVariable          Char(32767)    Inz;                                         //0005
Dcl-S wkRtnFileName          Char(20)       Inz;                                         //0005
Dcl-S wkPgmNamLib            Char(20)       Inz;                                         //0005
Dcl-S wkKeyFieldSeq          Char(1)        Inz;                                         //0006
Dcl-S wkKeyDesc              Char(4)        Inz('Desc');                                 //0006
Dcl-S WkDDSObjNam            Char(10)       Inz;                                         //0018
Dcl-S WkDDSLibrary           Char(10)       Inz;                                         //0018
Dcl-S WkDDSObjType           Char(10)       Inz;                                         //0018
Dcl-S wkTableName            Char(10)       Inz;                                         //0019
Dcl-S wkFrmTableName         Char(10)       Inz;                                         //0019
Dcl-S wkToTableName          Char(10)       Inz;                                         //0019
Dcl-S wkMbrName              Char(10)       Inz;                                         //0023
Dcl-S wkRcdFmt               Char(10)       Inz;                                         //0023
Dcl-S wkError                Char(1)        Inz;                                         //0023
Dcl-S wkMbrNotFound          Char(1)        Inz;                                         //0023

Dcl-S wkPrimaryKeyList       Varchar(80000) Inz;                                         //0009
Dcl-S wkKeyList              Varchar(80000) Inz;                                         //0009
Dcl-S wkInternalFldList      Varchar(200)   Inz;
Dcl-S wkInternalFldArr       Varchar(100)   Dim(8000);                                   //0017
Dcl-S wkExternalFldArr       Varchar(100)   Dim(8000);                                   //0017
Dcl-S wkJoinFiles            Varchar(80000) Inz;                                         //0009
Dcl-S wkSourceMappingjf      Varchar(80000) Inz;                                         //0009
Dcl-S wkSourceMappingBk      Varchar(80000) Inz;                                         //0009
Dcl-S wkSourceMappingSv      Varchar(80000) Inz;                                         //0009
Dcl-S wkDDSSrcTxt            Varchar(100)   Inz;                                         //0022
Dcl-S wkDDSObjTxt            Varchar(100)   Inz;                                         //0022
Dcl-S wkCommand              Varchar(1000)  Inz;                                         //0023

Dcl-S wkYears                Packed(4:0)    Inz;
Dcl-S WkFieldsCount          Packed(3:0)    Inz;
Dcl-S wkPrimaryKeyIdx        Packed(3:0)    Inz;
Dcl-S wkKeyCount             Packed(3:0)    Inz;
Dcl-S wkKeyIdx               Packed(3:0)    Inz;
Dcl-S wkPos                  Packed(3:0)    Inz;                                         //0017
Dcl-S wkFieldIdx             Packed(3:0)    Inz;                                         //0018
Dcl-S wkNoOfMbrAcessLF       Packed(3:0)    Inz;                                         //0023

Dcl-S RowsFetched            Uns(5)         Inz;
Dcl-S noOfRows               Uns(5)         Inz;
Dcl-S ddlSrcDtaIdx           Uns(5)         Inz;
Dcl-S ddlFldSrcIdx           Uns(5)         Inz;
Dcl-S ddlColHdgIdx           Uns(5)         Inz;
Dcl-S ddlColTxtIdx           Uns(5)         Inz;
Dcl-S logicalFldIdx          Uns(5)         Inz;
Dcl-S multiFormatIdx         Uns(5)         Inz;
Dcl-S writeIdx               Uns(5)         Inz;
Dcl-S physicalFileFieldCount Uns(5)         Inz;
Dcl-S logicalFileFieldCount  Uns(5)         Inz;
Dcl-S RecordFormatCount      Uns(5)         Inz;
Dcl-S wkPhysicalFileIdx      Uns(5)         Inz;                                         //0005
Dcl-S wkJoinFileCount        Uns(5)         Inz;                                         //0005
Dcl-S wkSlOmRecordCount      Uns(5)         Inz;                                         //0010
Dcl-S wkNoOfSlOmRules        Uns(5)         Inz;                                         //0010
Dcl-S wkNoOfSlOmValues       Uns(5)         Inz;                                         //0010
Dcl-S wkNoOfSlOmLine         Uns(5)         Inz;                                         //0010
Dcl-S wkSlOmIdx              Uns(5)         Inz;                                         //0010
Dcl-S wkSlOmStart            Uns(5)         Inz;                                         //0010
Dcl-S wkSlOmEnd              Uns(5)         Inz;                                         //0010
Dcl-S wkNoOfFunc             Uns(5)         Inz;                                         //0017
Dcl-S uiMultiFileIdx         Uns(5)         Inz;                                         //0023
Dcl-S uiMultiMbrIdx          Uns(5)         Inz;                                         //0023
Dcl-S uwNoOfObj              Uns(5)         Inz;                                         //0023
Dcl-S ObjectFetched          Uns(5)         Inz;                                         //0023

Dcl-S rcdFound               Ind            Inz;
Dcl-S rowFound               Ind            Inz('0');
Dcl-S colTxtFound            Ind            Inz;                                         //0016
Dcl-S lblTxtFound            Ind            Inz;                                         //0016

Dcl-S wkCreationDate         Date           Inz;

//------------------------------------------------------------------------------------- //
//Constant Variables                                                                    //
//------------------------------------------------------------------------------------- //
Dcl-C True            '1';
Dcl-C False           '0';
Dcl-C Squote          '''';
Dcl-C DSquote         '''''';                                                            //0022
Dcl-C QSquote         '''''''''';                                                        //0022
Dcl-C Upper           'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
Dcl-C Lower           'abcdefghijklmnopqrstuvwxyz';
Dcl-C System          '*LCL';                                                            //0005
Dcl-C Format          '*EXT';                                                            //0005
Dcl-C Override        '0';                                                               //0005

//------------------------------------------------------------------------------------- //
//Array Declarations                                                                    //
//------------------------------------------------------------------------------------- //
Dcl-S wkDDLSrcDta         Char(92) DIM(9999) Inz;

//------------------------------------------------------------------------------------- //
//Datastructure Definitions                                                             //
//------------------------------------------------------------------------------------- //
//Datastructure array to hold the DDL fields info
Dcl-Ds udDDLFldSrc Qualified Dim(9999);
   usFieldNameInternal Char(10);
   usFieldNameExternal Char(10);
   usFieldNameAlias    Char(80);
   usFieldDataType     Char(10);
   usFieldLength       Packed(8);
   usFieldDecPos       Packed(2);
   usNumberOfDigits    Packed(2);
   usCCSID             Packed(5);
   usGraphicFldLength  Packed(5);
   usRecordFormat      Char(10);
   usColumnText        Char(50);
   usColumnHeading1    Char(20);
   usColumnHeading2    Char(20);
   usColumnHeading3    Char(20);
   usDefaultValue      Char(30);
   usAllowNull         Char(1);
   usVariableLength    Char(1);
   usJoinRef           Packed(2);                                                        //0005
   usRcdFmtLen         Packed(5);                                                        //0018
End-Ds;

//Data Structure for physical file field                                                //0018
Dcl-Ds udPfFieldSrc Likeds(udDDLFldSrc) Dim(9999);                                       //0018

//Datastructure for the record format details of logical file
Dcl-Ds udLogicalFileRecFormat Qualified Dim(999);
   usPhysicalFile      Char(10);
   usPhysicalFileLib   Char(10);
   usLogicalFileFormat Char(10);
   usKeyCount          Packed(3:0);
End-Ds;

//Datastructure for physical file details which are used to create Join Logical files   //0005
Dcl-Ds udPhysicalFileDetails Qualified Dim(999);                                         //0005
   usJoinFrmNum        Packed(3:0);                                                      //0005
   usJoinFrmFile       Char(10);                                                         //0005
   usJoinToNum         Packed(3:0);                                                      //0005
   usJoinToFile        Char(10);                                                         //0005
   usJoinFrmField      Char(10);                                                         //0005
   usJoinToField       Char(10);                                                         //0005
   usJoinFrmLib        Char(10);                                                         //0019
   usJoinToLib         Char(10);                                                         //0019
End-Ds;                                                                                  //0005

//Datastructure for capturing errors in API                                             //0005
Dcl-Ds udApiErrC Qualified Inz;                                                          //0005
   usBytProv           Int(10:0) Inz(%size(udApiErrC));                                  //0005
   usBytAvail          Int(10:0);                                                        //0005
   usMsgId             Char(7);                                                          //0005
   usReserved          Char(1);                                                          //0005
   usMsgData           Char(3000);                                                       //0005
End-Ds;                                                                                  //0005
                                                                                         //0005
Dcl-Ds udSrvPgmInfEr Likeds(udApiErrC)  Inz;                                             //0005

//Datastructure for select/omit condition of file                                       //0010
Dcl-Ds udSelectOmitCondition Qualified Dim(999);                                         //0010
   usSlOmField          Char(15);                                                        //0010
   usNoOfSlOmRules      Packed(4:0);                                                     //0010
   usSlOmRule           Char(1);                                                         //0010
   usSlOmComp           Char(2);                                                         //0010
   usNoOfSlOmValues     Packed(3:0);                                                     //0010
   usSlOmValue          Char(32);                                                        //0010
   usSlOmJrefValues     Packed(3:0);                                                     //0010
   usSlOmValueLength    Packed(3:0);                                                     //0013
   usSlOmJrefParmNo     Packed(3:0);                                                     //0013
End-Ds;                                                                                  //0010

//Datastructure for file field function key and key value                               //0017
Dcl-Ds udFieldFunc Qualified Dim(999);                                                   //0017
   usFldNm  Char(10);                                                                    //0017
   usKeyNm  Char(10);                                                                    //0017
   usKeyVal VarChar(100);                                                                //0017
   usFldENm Char(10);                                                                    //0026
End-Ds;                                                                                  //0017

//Data Structure to get the source info from iaObjMap for the object                    //0022
Dcl-Ds udObjMapDs Qualified Inz;                                                         //0022
   usMbrLib   Char(10);                                                                  //0022
   usMbrSrcf  Char(10);                                                                  //0022
   usMbrNam   Char(10);                                                                  //0022
   usMbrTyp   Char(10);                                                                  //0022
End-Ds;                                                                                  //0022

//Data Structure to get the created file for Multi Record Format/Multi Member File      //0023
Dcl-Ds udMultiFileDs Qualified Dim(99);                                                  //0023
   usObjName  Char(10);                                                                  //0023
End-Ds;                                                                                  //0023

//Data Structure to get the physical member details acessed by logical file             //0023
Dcl-Ds udMultiMbrDs Qualified Dim(99);                                                   //0023
   usPFLib    Char(10);                                                                  //0023
   usPFObj    Char(10);                                                                  //0023
   usPFMbr    Char(10);                                                                  //0023
End-Ds;                                                                                  //0023

//------------------------------------------------------------------------------------- //
//Prototype Definitions                                                                 //
//------------------------------------------------------------------------------------- //
Dcl-Pr iAGetMsg extpgm('IAGETMSG');
   *n Char(01)     Options(*NoPass) Const;
   *n Char(07)     Options(*NoPass) Const;
   *n Char(1000)   Options(*NoPass)      ;
   *n Char(80)     Options(*NoPass) Const;
End-pr;

Dcl-pr IBMAPIRtvFileDesc Extpgm('QDBRTVFD');                                             //0005
   *n Char(32767) Options(*Varsize);                                                     //0005
   *n Int(10)      Const;                                                                //0005
   *n Char(20);                                                                          //0005
   *n Char(8)      Const;                                                                //0005
   *n Char(20)     Const;                                                                //0005
   *n Char(10)     Const;                                                                //0005
   *n Char(1)      Const;                                                                //0005
   *n Char(10)     Const;                                                                //0005
   *n Char(10)     Const;                                                                //0005
   *n Likeds(udApiErrC) options(*varsize);                                               //0005
End-pr;                                                                                  //0005

Dcl-Pr iAOvrCl ExtPgm('IAOVRCL');                                                        //0023
   *n Char(10) Const;                                                                    //0023
   *n Char(10) Const;                                                                    //0023
   *n Char(10) Const;                                                                    //0023
End-Pr;                                                                                  //0023

//------------------------------------------------------------------------------------- //
//Copybook definitions                                                                  //
//------------------------------------------------------------------------------------- //
/copy 'QCPYSRC/iaderrlog.rpgleinc'

//------------------------------------------------------------------------------------- //
//Entry Parameter Declarations
//------------------------------------------------------------------------------------- //
Dcl-Pr IADDSDDLSC ExtPgm('IADDSDDLSC');
   inReqId           Char(18);
   inRepo            Char(10);
   inDDSObjNam       Char(10);
   inDDSLibrary      Char(10);
   inDDSObjType      Char(10);
   inDDSFileType     Char(3);                                                            //0023
   inDDSMbrName      Char(10);                                                           //0023
   inDDSRcdFmt       Char(10);                                                           //0023
   inDDLSrcAtr       Char(10);                                                           //0023
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

Dcl-Pi IADDSDDLSC;
   inReqId           Char(18);
   inRepo            Char(10);
   inDDSObjNam       Char(10);
   inDDSLibrary      Char(10);
   inDDSObjType      Char(10);
   inDDSFileType     Char(3);                                                            //0023
   inDDSMbrName      Char(10);                                                           //0023
   inDDSRcdFmt       Char(10);                                                           //0023
   inDDLSrcAtr       Char(10);                                                           //0023
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
End-Pi;

//------------------------------------------------------------------------------------- //
//Set options                                                                           //
//------------------------------------------------------------------------------------- //
Exec Sql
   Set Option Commit    = *None,
              Naming    = *Sys,
              UsrPrf    = *User,
              DynUsrPrf = *User,
              CloSqlCsr = *Endmod;

//------------------------------------------------------------------------------------- //
//Mainline Programming                                                                  //
//------------------------------------------------------------------------------------- //
Eval-corr uDpsds = wkuDpsds;

//Initializing outStatus as 'S' and outMessage as 'Successful'.
outStatus   = 'S';
wkMsgVars   = %trim(inDDLMbrLib);

//DDL creation completed
iAGetMsg('1':'MSG0185':wkMsgDesc:wkMsgVars);
outMessage = %trim(wkMsgDesc);

//------------------------------------------------------------------------------------- //
//Cursor Declarations                                                                   //
//------------------------------------------------------------------------------------- //
//Fetch the File Fields source data from IDSPFFD for DDL Source
Exec Sql
   Declare CursorDDLFldSrc Cursor For
    Select whfldi,
           whflde,
           whalis,
           whfldt,
           whfldb,
           whfldp,
           whfldd,
           whcsid,
           whfldg,
           whname,
           whftxt,
           whchd1,
           whchd2,
           whchd3,
           whdft,
           whnull,
           whvarl,                                                                       //0005
           whjref,                                                                       //0018
           whrlen                                                                        //0018
      From iDspFFd
     Where whfile = :WkDDSObjNam                                                         //0018
       And whlib  = :WkDDSLibrary                                                        //0018
       And whftyp = :WkDDSObjType                                                        //0018
       And whname = :wkRcdFmt                                                            //0023
      With Ur;

//Fetch the details of each record format in case of multi-format logical file
Exec Sql
   Declare CursorLogicalFileRecFormat Cursor For
    Select apbof, apbol, apbolf, apnkyf
      From iDspFdKeys
     Where aplib  = :inDDSLibrary
       And apfile = :inDDSObjNam
      With Ur;

//Fetch the details of physical files which are used to create join Logical File        //0005
Exec Sql                                                                                 //0005
   Declare CursorPhysicalFileDetails Cursor For                                          //0005
    Select jnjfrm, jnjfnm, jnjto, jnjtnm,                                                //0019
           jnjfd1, jnjfd2, jnjflb, jnjtlb                                                //0019
      From idspfdjoin                                                                    //0005
     Where jnlib  = :inDDSLibrary                                                        //0005
       And jnfile = :inDDSObjNam                                                         //0005
       And jnftyp = :inDDSObjType                                                        //0005
       And jnjfrm > 0                                                                    //0005
      With Ur;                                                                           //0005

//Fetch the select and omit details of logical file                                     //0010
Exec Sql                                                                                 //0010
   Declare CursorSelectOmitCondition Cursor For                                          //0010
    Select sofld,  sonrul, sorule, socomp, sonval,                                       //0013
           sovalu, sofjvl, sovall, sopjvl                                                //0013
      From iDspFdSlom                                                                    //0010
     Where solib  = :inDDSLibrary                                                        //0010
       And sofile = :inDDSObjNam                                                         //0010
       And sorfmt = :inDDSRcdFmt                                                         //0023
       And sofld  <> ' '                                                                 //0010
       And sorule <> ' '                                                                 //0010
       For Read Only                                                                     //0010
      With Ur;                                                                           //0010

//Fetch the file field function detail from IAFILEDTL file                              //0017
Exec Sql                                                                                 //0017
   Declare CursorFldFuncDtl Cursor For                                                   //0017
    Select dbfldnmi, dbkwdname, dbkwdvalue , DBFLDNMX                                    //0026
      From iAFileDtl                                                                     //0017
     Where dblibname = :inDDSLibrary                                                     //0017
       And dbfilenm  = :inDDSObjNam                                                      //0017
       And dbkwdname <> ' ';                                                             //0017

//Fetch the Multi Record Format File or Multi Member File Details                       //0023
Exec Sql                                                                                 //0023
   Declare CursorMultiFile Cursor For                                                    //0023
    Select iADdlObjNm                                                                    //0023
      From iADdsDdlDP                                                                    //0023
     Where iAReqId    = :inReqId                                                         //0023
       And iARepoNm   = :inRepo                                                          //0023
       And iADdsObjLb = :inDDSLibrary                                                    //0023
       And iADdsObjNm = :inDDSObjNam                                                     //0023
       And iADdsMbrNm <> ' '                                                             //0023
       And iAConvSts  = 'S';                                                             //0023

//Fetch the Member Accessed by Logical File for Multi Member File                       //0023
Exec Sql                                                                                 //0023
   Declare CursorMultiMbr Cursor For                                                     //0023
    Select MBBOL, MBBOF, MBBOM                                                           //0023
      From iDspFdMbr                                                                     //0023
     Where MBLib  = :inDDSLibrary                                                        //0023
       And MBFile = :inDDSObjNam                                                         //0023
       And MBName = :inDDSMbrName                                                        //0023
       And MBBOLF = :inDDSRcdFmt;                                                        //0023

//------------------------------------------------------------------------------------- //
//Main Processing                                                                       //
//------------------------------------------------------------------------------------- //

//If the input Username blank then get the Username from program status Data Structure
If inRequestedUser = *Blanks;
   inRequestedUser = uDpsds.User;
EndIf;

//Check if meta data built or not for the input file & return with an error, if not
Exec Sql
   Select whnfld Into :WkFieldsCount
     From iDspFfd
    Where whlib  = :inDDSLibrary
      And whfile = :inDDSObjNam                                                          //0023
      And whname = :inDDSRcdFmt;                                                         //0023

If sqlcode = No_Data_Found;
   outStatus  = 'E';
   wkMsgVars  = %Trim(inDDSObjNam);
   //Metadata not found for specified DDS file. Please rebuild metadata.
   iAGetMsg('1':'MSG0193':wkMsgDesc:wkMsgVars);
   outMessage = %Trim(wkMsgDesc);
   Return;
EndIf;

//Get DDS Source Member Information                                                     //0022
GetDDSSrcInfo();                                                                         //0022

//Check for keys list,if defined
GetKeysList();

//Add Source Member                                                                     //0023
If not AddSrcMember();                                                                   //0023
   Return;                                                                               //0023
EndIf;                                                                                   //0023

//Override file to the DDL member                                                       //0023
iAOvrCl('QDDLSRC' : inDDLMbrLib : inDDLMbrNam);                                          //0023

//Load Header details for DDL source
LoadHeaderPart();

Select;
   //Generate DDL source for Multi Record Format File and Multi Member File             //0023
   When inDDSMbrName = *Blanks and                                                       //0023
        (inDDSFileType = 'MRF' Or                                                        //0023
        inDDSFileType = 'MMF');                                                          //0023
      GenerateDDStoDDLforMultiFile();                                                    //0023

   //Generate DDL source for Physical File and creating object entries for compilation
   //into IADDSDDLDP
   When inDDSObjType = 'P';
      GenerateDDStoDDLforPF();
      //If any error in DDL conversion of PF, return
      If outStatus = 'E';
         Return;
      EndIf;

   //Generate DDL source for Logical File and creating object entries for compilation
   //into IADDSDDLDP
   When inDDSObjType = 'L';
      GetLogicalFileDetails();                                                           //0023
      If outStatus  = 'E';
         Return;
      EndIf;

      //Multi Member File Process                                                       //0023
      //When Logical File Member access more than one member of Physical file           //0023
      If wkNoOfMbrAcessLF > 1 and inDDSFileType = 'MMF';                                 //0023
         GenerateDDStoDDLforMultiMbr();                                                  //0023
      Else;                                                                              //0023
         GenerateDDStoDDLforLF();
         //If any error in DDL conversion of LF, return
         If outStatus  = 'E';
            Return;
         EndIf;
      EndIf;                                                                             //0023

   Other;

EndSl;

//Updtae record in IADDSDDLDP                                                           //0023
CreateEntriesForCompilation();                                                           //0023

//Delete Override file of DDL member                                                    //0023
Clear wkCommand;                                                                         //0023
wkCommand = 'DLTOVR FILE(*ALL) LVL(*JOB)';                                               //0023
RunCmd();

*InLr = *On;
Return;

//------------------------------------------------------------------------------------- //
//GetKeysList : To check & get Primary Keys/normal keys, if defined                     //
//------------------------------------------------------------------------------------- //
Dcl-Proc GetKeysList;

   Clear wkKeyCount ;                                                                    //0021
   wkIsPrimaryKey = 'N' ;                                                                //0021

   //Check for Primary Keys/normal keys
   Exec Sql
      Select apnkyf, apuniq Into :wkKeyCount, :wkIsPrimaryKey
        From iDspFdKeys
       Where aplib  = :inDDSLibrary
         And apfile = :inDDSObjNam limit 1;                                              //0021

   If wkKeyCount > 0;
      For wkKeyIdx = 1 To wkKeyCount;
         Exec Sql
            Select apkeyf,apkseq Into :wkKeyFieldName, :wkKeyFieldSeq                    //0006
              From iDspFdKeys
             Where aplib  = :inDDSLibrary
               And apfile = :inDDSObjNam
               And (APFTYP = 'P'                                                         //0023
                Or (APFTYP = 'L'                                                         //0023
               And APBOLF = :inDDSRcdFmt))                                               //0023
               And apkeyn = :wkKeyIdx;

         //Add descending key sequence in key fieldname                                 //0006
         If wkKeyFieldSeq  = 'D';                                                        //0006
            wkKeyFieldName = %Trim(wkKeyFieldName) + ' ' + wkKeyDesc;                    //0006
         EndIf;                                                                          //0006

         If wkKeyIdx = wkKeyCount;
            wkKeyList = wkKeyList + %Trim(wkKeyFieldName);
         Else;
            wkKeyList = wkKeyList + %Trim(wkKeyFieldName) + ',';
         EndIf;
      Endfor;
   EndIf;

   If wkIsPrimaryKey = 'Y';
      wkPrimaryKeyList = wkKeyList;
      Clear wkKeyList;
   EndIf;

End-Proc;

//------------------------------------------------------------------------------------- //
//GenerateDDStoDDLforPF : Generate DDL source for Physical File                         //
//------------------------------------------------------------------------------------- //
Dcl-Proc GenerateDDStoDDLforPF;

   //Create Table
   LoadDDLSourceMapDetails('CRTTBL');

   //Load fields of Physical for DDL source
   LoadDDLSourceMapDetails('FIELDS');
   If outStatus  = 'E';
      Return;
   EndIf;

   //If the audit column flag is 'Y', then add audit columns
   If inIncludeAudCols = 'Y' ;
      LoadDDLSourceMapDetails('AUDCRTBY');
      LoadDDLSourceMapDetails('AUDCRTTIMS');
      LoadDDLSourceMapDetails('AUDUPDBY');
      LoadDDLSourceMapDetails('AUDUPDTIMS');
   EndIf;

   LoadDDLSourceMapDetails('BLANKS');

   //Load Record Format
   LoadDDLSourceMapDetails('RCDFMTCMNT');
   LoadDDLSourceMapDetails('RCDFMT');
   LoadDDLSourceMapDetails('BLANKS');

   //Rename Table to System Name
   If inDDLLngNam <> *Blanks And inDDLObjNam <> inDDLLngNam;                             //0011
      LoadDDLSourceMapDetails('RNMTBLCMNT');
      LoadDDLSourceMapDetails('RNMTBL');
      LoadDDLSourceMapDetails('BLANKS');
   EndIf;

   //Load Object/Label Description
   If lblTxtFound;                                                                       //0016
      LoadDDLSourceMapDetails('ADDLBLCMNT');
      LoadDDLSourceMapDetails('ADDLBL');
      LoadDDLSourceMapDetails('BLANKS');
   EndIf;                                                                                //0016

   //Load Column/Label heading for fields
   LoadDDLSourceMapDetails('COLHDGCMNT');
   LoadDDLSourceMapDetails('COLLBL');

   //If the identity column flag is 'Y', then add identity column headings
   If inIncludeIdCol = 'Y';
      LoadDDLSourceMapDetails('FILEIDH');
   Endif;

   LoadDDLSourceMapDetails('COLHDG');

   //If the audit column flag is 'Y', then add audit column headings
   If inIncludeAudCols = 'Y' ;
      LoadDDLSourceMapDetails('AUDCRTBYH');
      LoadDDLSourceMapDetails('AUDCRTTIMH');
      LoadDDLSourceMapDetails('AUDUPDBYH');
      LoadDDLSourceMapDetails('AUDUPDTIMH');
   EndIf;

   LoadDDLSourceMapDetails('BLANKS');

   If colTxtFound;                                                                       //0016
      //Load Column/Label Text for fields
      LoadDDLSourceMapDetails('COLTXTCMNT');
      LoadDDLSourceMapDetails('COLLBL');

      //If the identity column flag is 'Y', then add identity column text
      If inIncludeIdCol = 'Y';
        LoadDDLSourceMapDetails('FILEIDT');
      Endif;

      LoadDDLSourceMapDetails('COLTXT');

      //If the audit column flag is 'Y', then add audit column Text
      If inIncludeAudCols = 'Y' ;
         LoadDDLSourceMapDetails('AUDCRTBYT');
         LoadDDLSourceMapDetails('AUDCRTTIMT');
         LoadDDLSourceMapDetails('AUDUPDBYT');
         LoadDDLSourceMapDetails('AUDUPDTIMT');
      EndIf;

      LoadDDLSourceMapDetails('BLANKS');
   EndIf;                                                                                //0016

   //Load Index, if defined
   Select;
     //Create UNIQUE Index
     When wkIsPrimaryKey = 'Y';
        LoadDDLSourceMapDetails('CRTIDXCMNT');
        LoadDDLSourceMapDetails('CRTUNIQIDX');
        LoadDDLSourceMapDetails('BLANKS');
        LoadDDLSourceMapDetails('RCDFMTCMNT');                                           //0007
        LoadDDLSourceMapDetails('RCDFMT');                                               //0007
        LoadDDLSourceMapDetails('BLANKS');                                               //0007
        If lblTxtFound;                                                                  //0016
           LoadDDLSourceMapDetails('LBLIDXCMNT');                                        //0007
           LoadDDLSourceMapDetails('LBLIDX');                                            //0007
           LoadDDLSourceMapDetails('BLANKS');                                            //0007
        EndIf;                                                                           //0016

     //Create Index
     When wkKeyCount > 0 and wkIsPrimaryKey = 'N';
        LoadDDLSourceMapDetails('CRTIDXCMNT');
        LoadDDLSourceMapDetails('CRTIDX');
        LoadDDLSourceMapDetails('BLANKS');
        LoadDDLSourceMapDetails('RCDFMTCMNT');                                           //0007
        LoadDDLSourceMapDetails('RCDFMT');                                               //0007
        LoadDDLSourceMapDetails('BLANKS');                                               //0007
        If lblTxtFound;                                                                  //0016
           LoadDDLSourceMapDetails('LBLIDXCMNT');                                        //0007
           LoadDDLSourceMapDetails('LBLIDX');                                            //0007
           LoadDDLSourceMapDetails('BLANKS');                                            //0007
        EndIf;                                                                           //0016

     Other;
   EndSl;

   //Clear the DDL Source Entry in IADDLSRCP
   ClearDDLSrcEntry();

   //Write the generated source to DDL member
   WriteDDLMember();

End-Proc;

//------------------------------------------------------------------------------------- //
//GenerateDDStoDDLforLF : Generate DDL source for Logical File                          //
//------------------------------------------------------------------------------------- //
Dcl-Proc GenerateDDStoDDLforLF;

   //Create Index or Create View
   Select;
      When wkIsPrimaryKey = 'Y' and wkAllFieldSelect = 'Y';                              //0007
         LoadDDLSourceMapDetails('CRTUNIQIDX');
         LoadDDLSourceMapDetails('SELECTOMIT');                                          //0010
         LoadDDLSourceMapDetails('BLANKS');
         LoadDDLSourceMapDetails('RCDFMTCMNT');
         LoadDDLSourceMapDetails('RCDFMT');
         LoadDDLSourceMapDetails('BLANKS');
      When wkIsPrimaryKey = 'Y' and wkAllFieldSelect = 'N';                              //0007
         LoadDDLSourceMapDetails('CRTVIEW');                                             //0007
         LoadDDLSourceMapDetails('SELECTOMIT');                                          //0010
         LoadDDLSourceMapDetails('BLANKS');                                              //0007
         LoadDDLSourceMapDetails('RCDFMTCMNT');                                          //0007
         LoadDDLSourceMapDetails('RCDFMT');                                              //0007
         LoadDDLSourceMapDetails('BLANKS');                                              //0007
         If inDDLLngNam <> *Blanks And inDDLObjNam <> inDDLLngNam;                       //0011
            LoadDDLSourceMapDetails('RNMTBLCMNT');                                       //0011
            LoadDDLSourceMapDetails('RNMTBL');                                           //0011
            LoadDDLSourceMapDetails('BLANKS');                                           //0011
            //Skip rename unique index when rename table already happened               //0011
            Clear inDDLLngNam;                                                           //0011
         EndIf;                                                                          //0011
         If lblTxtFound;                                                                 //0016
            LoadDDLSourceMapDetails('LBLVWCMNT');                                        //0007
            LoadDDLSourceMapDetails('LBLVIEW');                                          //0007
            LoadDDLSourceMapDetails('BLANKS');                                           //0007
         EndIf;
         LoadDDLSourceMapDetails('CRTIDXCMNT');                                          //0010
         LoadDDLSourceMapDetails('CRTUNIQIDX');                                          //0007
         LoadDDLSourceMapDetails('BLANKS');                                              //0007
         LoadDDLSourceMapDetails('RCDFMTCMNT');                                          //0007
         LoadDDLSourceMapDetails('RCDFMT');                                              //0007
         LoadDDLSourceMapDetails('BLANKS');                                              //0007
      When wkKeyCount > 0 and wkIsPrimaryKey <> 'Y' and wkAllFieldSelect = 'Y';          //0007
         LoadDDLSourceMapDetails('CRTIDX');
         LoadDDLSourceMapDetails('SELECTOMIT');                                          //0010
         LoadDDLSourceMapDetails('BLANKS');
         LoadDDLSourceMapDetails('RCDFMTCMNT');
         LoadDDLSourceMapDetails('RCDFMT');
         LoadDDLSourceMapDetails('BLANKS');
      When wkKeyCount > 0 and wkIsPrimaryKey <> 'Y' and wkAllFieldSelect = 'N';          //0007
         LoadDDLSourceMapDetails('CRTVIEW');                                             //0007
         LoadDDLSourceMapDetails('SELECTOMIT');                                          //0010
         LoadDDLSourceMapDetails('BLANKS');                                              //0007
         LoadDDLSourceMapDetails('RCDFMTCMNT');                                          //0007
         LoadDDLSourceMapDetails('RCDFMT');                                              //0007
         LoadDDLSourceMapDetails('BLANKS');                                              //0007
         If inDDLLngNam <> *Blanks And inDDLObjNam <> inDDLLngNam;                       //0011
            LoadDDLSourceMapDetails('RNMTBLCMNT');                                       //0011
            LoadDDLSourceMapDetails('RNMTBL');                                           //0011
            LoadDDLSourceMapDetails('BLANKS');                                           //0011
            //Skip rename index when rename table already happened                      //0011
            Clear inDDLLngNam;                                                           //0011
         EndIf;                                                                          //0011
         If lblTxtFound;                                                                 //0016
            LoadDDLSourceMapDetails('LBLVWCMNT');                                        //0007
            LoadDDLSourceMapDetails('LBLVIEW');                                          //0007
            LoadDDLSourceMapDetails('BLANKS');                                           //0007
         EndIf;                                                                          //0016
         LoadDDLSourceMapDetails('CRTIDXCMNT');                                          //0010
         LoadDDLSourceMapDetails('CRTIDX');                                              //0007
         LoadDDLSourceMapDetails('BLANKS');                                              //0007
         LoadDDLSourceMapDetails('RCDFMTCMNT');                                          //0007
         LoadDDLSourceMapDetails('RCDFMT');                                              //0007
         LoadDDLSourceMapDetails('BLANKS');                                              //0007
      Other;
         LoadDDLSourceMapDetails('CRTVIEW');
         LoadDDLSourceMapDetails('SELECTOMIT');                                          //0010
         LoadDDLSourceMapDetails('BLANKS');                                              //0002
         LoadDDLSourceMapDetails('RCDFMTCMNT');                                          //0002
         LoadDDLSourceMapDetails('RCDFMT');                                              //0002
         LoadDDLSourceMapDetails('BLANKS');
   EndSl;

   //Rename Index/View to System Name
   If inDDLLngNam <> *Blanks And inDDLObjNam <> inDDLLngNam;                             //0011
      Select;
         When wkIsPrimaryKey = 'Y' or wkKeyCount > 0;
              LoadDDLSourceMapDetails('RNMIDXCMNT');
              LoadDDLSourceMapDetails('RNMIDX');
         Other;
              LoadDDLSourceMapDetails('RNMTBLCMNT');
              LoadDDLSourceMapDetails('RNMTBL');
      EndSl;

      LoadDDLSourceMapDetails('BLANKS');
   EndIf;

   //Load Object/Label Description
   If lblTxtFound;                                                                       //0016
      Select;
         When wkIsPrimaryKey = 'Y' or wkKeyCount > 0;
              LoadDDLSourceMapDetails('LBLIDXCMNT');
              LoadDDLSourceMapDetails('LBLIDX');
         Other;
              LoadDDLSourceMapDetails('LBLVWCMNT');
              LoadDDLSourceMapDetails('LBLVIEW');
      EndSl;

      LoadDDLSourceMapDetails('BLANKS');
   EndIf;                                                                                //0016

   //Clear the DDL Source Entry in IADDLSRCP
   ClearDDLSrcEntry();

   //Write the generated source to DDL member
   WriteDDLMember();

End-Proc;

//------------------------------------------------------------------------------------- //
//LoadHeaderPart : To load the header details of DDL source                             //
//------------------------------------------------------------------------------------- //
Dcl-Proc LoadHeaderPart;

   LoadDDLSourceMapDetails('HEADER');
   LoadDDLSourceMapDetails('HDRDDSMBR');                                                 //0025
   LoadDDLSourceMapDetails('HDRMBR');
   LoadDDLSourceMapDetails('HDRDESP');
   LoadDDLSourceMapDetails('HDRUSER');
   LoadDDLSourceMapDetails('HDRDATE');
   LoadDDLSourceMapDetails('HEADER');

End-Proc;

//------------------------------------------------------------------------------------- //
//LoadDDLSourceMapDetails : To load DDL source mappings                                 //
//------------------------------------------------------------------------------------- //
Dcl-Proc LoadDDLSourceMapDetails;

   Dcl-Pi *n;
      inSrcMapKeyword   Char(10) Value;
   End-Pi;

   Clear  wkSourceMapping;
   Clear  wkSourceMap;                                                                   //0010

   Exec Sql
      Select Src_Mapping
        Into :wkSourceMap                                                                //0009
        From iaSrcMap
       Where SrcMbr_Type = :wkDDSTODDL
         And KeyField_1  = :inSrcMapKeyword;

   If SqlCode < successCode;
      uDpsds.wkQuery_Name = 'Select_' + inSrcMapKeyword ;
      IaSqlDiagnostic(uDpsds);
   Else;                                                                                 //0009
      wkSourceMapping = wkSourceMap  ;                                                   //0009
   EndIf;

   BuiltDDLSourceMapDetails(inSrcMapKeyword);

End-Proc;

//------------------------------------------------------------------------------------- //
//BuiltDDLSourceMapDetails : To Prepare and Load DDL Source Data                        //
//------------------------------------------------------------------------------------- //
Dcl-Proc BuiltDDLSourceMapDetails;

   Dcl-Pi *n;
      inSrcMapKeyword   Char(10) Value;
   End-Pi;

   Dcl-S WkProgrammers  VarChar(50) Inz('Programmers.io@');
   Dcl-S wkYesDDLSrcDta Char(1)     Inz('Y');
   Dcl-S FldIndex       Uns(5)      Inz;                                                 //0008
   Dcl-s wkKeyLen       Uns(5)      Inz;                                                 //0008
   Dcl-s wkKeyPos       Uns(5)      Inz(1);                                              //0008
   Dcl-s wkStrPos       Uns(5)      Inz(1);                                              //0008
   Dcl-s wkColonPos     Uns(5)      Inz;                                                 //0022
   Dcl-s wkLabelPos     Uns(5)      Inz;                                                 //0022

   Select;
      When inSrcMapKeyword = 'HEADER';
           wkSourceMapping = %TrimR(wkSourceMapping) ;

      When inSrcMapKeyword = 'HDRDDSMBR';                                                //0025
           %Subst(wkSourceMapping:23:10) = %Trim(udObjMapDs.usMbrNam);                   //0025

      When inSrcMapKeyword = 'HDRMBR';
           %Subst(wkSourceMapping:23:10) = %Trim(inDDLMbrNam);

      When inSrcMapKeyword = 'HDRDESP';
           %Subst(wkSourceMapping:23:%Len(%Trim(wkDDSSrcTxt))) = wkDDSSrcTxt;            //0022

      When inSrcMapKeyword = 'HDRUSER';
           wkYears =  %subdt(%Date():*YEARS);
              %Subst(wkSourceMapping:40:10) = %Trim(%Char(wkYears));

      When inSrcMapKeyword = 'HDRDATE';
           wkCreationDate  = %Date();
           %Subst(wkSourceMapping:23:10) = %ScanRpl('-':'/':%Char(wkCreationDate));

      When inSrcMapKeyword = 'CRTTBL';
           If inDDLLngNam <> *Blanks And inDDLObjNam <> inDDLLngNam;                     //0011
              wkSourceMapping =
              %ScanRpl('&VAR1': %Trim(inDDLLngNam):wkSourceMapping);
           Else;                                                                         //0011
              wkSourceMapping =
              %ScanRpl('&VAR1': %Trim(inDDLObjNam):wkSourceMapping);
           EndIf;

      When inSrcMapKeyword = 'CRTIDX'
        Or inSrcMapKeyword = 'CRTUNIQIDX' ;
           Select;
              When inDDSObjType = 'P' or                                                 //0007
                   (inDDSObjType = 'L' and wkAllFieldSelect = 'N');                      //0007
                 wkIndexName = %Trim(%Subst(inDDLObjNam:1:4)) + 'IDX';
                 GetNextFileIndexSequence();
                 wkFileKeyed = 'Y';                                                      //0020
                 wkKeyIdxNm = wkIndexName;
                 //Drop Index if already exists (Since causing issue during compilation)//0011
                 wkSqlStmt = 'Drop Index If Exists ' + %Trim(inDDLObjLib)+ '/'+          //0011
                             %Trim(wkIndexName);                                         //0011
                 Exec Sql Execute Immediate :wkSqlStmt;                                  //0011
              When inDDSObjType = 'L';
                 wkIndexName = %Trim(inDDLObjNam);
              Other;
           EndSl;

           Select;
              When inDDSObjType = 'L';
                If inDDLLngNam <> *Blanks And inDDLObjNam <> inDDLLngNam;                //0011
                   wkSourceMapping =
                   %ScanRpl('&VAR1': %Trim(inDDLLngNam):wkSourceMapping);
                Else;                                                                    //0007
                    wkSourceMapping =
                    %ScanRpl('&VAR1': %Trim(wkIndexName):wkSourceMapping);
                EndIf;
                wkSourceMapping = %ScanRpl('&VAR2': %Trim(wkPhysicalFile):wkSourceMapping);
              When inDDSObjType = 'P';
                   wkSourceMapping =
                   %ScanRpl('&VAR1' : %Trim(wkIndexName) : wkSourceMapping);
                   wkSourceMapping =
                   %ScanRpl('&VAR2' : %Trim(inDDLObjNam) : wkSourceMapping);
              Other;
           EndSl;
           wkSourceMapping = %TrimR(wkSourceMapping) + ' (' ;                            //0012
           If inSrcMapKeyword = 'CRTUNIQIDX' ;
              wkUnqFlg = 'Y';
              wkSourceMapping = %TrimR(wkSourceMapping) + wkPrimaryKeyList + ')';
           ElseIf inSrcMapKeyword = 'CRTIDX';
              wkSourceMapping = %TrimR(WkSourceMapping) + wkKeyList + ')';
           EndIf;

      When inSrcMapKeyword = 'CRTVIEW';
           If inDDLLngNam <> *Blanks And inDDLObjNam <> inDDLLngNam;                     //0011
              wkSourceMapping =
                 %ScanRpl('&VAR1': %Trim(inDDLLngNam):wkSourceMapping);
           Else;                                                                         //0011
              WkSourceMapping =
                 %ScanRpl('&VAR1': %Trim(inDDLObjNam):wkSourceMapping);
           EndIf;

           If wkAllFieldSelect = 'Y';
              wkSourceMapping = %TrimR(wkSourceMapping) + ' AS';
              LoadDDLSrcDtaArray();
              Clear wkSourceMapping;
              wkSourceMapping = 'SELECT * FROM ' + %Trim(wkPhysicalFile);                //0002
              LoadDDLSrcDtaArray();
           EndIf;

           If wkAllFieldSelect = 'N';
              Select;
                 When wkDiffFieldNames = 'N';
                      wkSourceMapping = %TrimR(wkSourceMapping) + ' AS SELECT' ;
                      LoadDDLSrcDtaArray();
                      Clear wkSourceMapping;
                      For FldIndex = 1 to logicalFileFieldCount;                         //0008
                          wkSourceMapping = %Trim(wkInternalFldArr(FldIndex));           //0008
                          LoadDDLSrcDtaArray();
                      EndFor;                                                            //0008
                      Clear wkSourceMapping;
                      If wkJoinFlg = 'N' ;                                               //0005
                         wkSourceMapping = 'FROM ' + %Trim(wkPhysicalFile);              //0002
                         LoadDDLSrcDtaArray();                                           //0008
                      Else;                                                              //0005
                         wkSourceMappingjf = 'FROM ' + %Trim(wkJoinFiles)   ;            //0008
                         Exsr LoadJoinDDLSrcDta;                                         //0008
                         clear wkSourceMappingjf;                                        //0008
                      Endif;                                                             //0005

                 When wkDiffFieldNames = 'Y';
                      wkSourceMapping = %TrimR(wkSourceMapping) + ' (' ;                 //0012
                      LoadDDLSrcDtaArray();
                      Clear WkSourceMapping;
                      For FldIndex = 1 to logicalFileFieldCount;                         //0008
                          wkSourceMapping = %Trim(wkExternalFldArr(FldIndex));           //0008
                          LoadDDLSrcDtaArray();
                      EndFor;                                                            //0008
                      Clear wkSourceMapping;
                      wkSourceMapping = ')' + ' AS SELECT' ;
                      LoadDDLSrcDtaArray();
                      Clear WkSourceMapping;
                      For FldIndex = 1 to logicalFileFieldCount;                         //0008
                          wkSourceMapping = %Trim(wkInternalFldArr(FldIndex));           //0008
                          LoadDDLSrcDtaArray();
                      EndFor;                                                            //0008
                      Clear WkSourceMapping;
                      If wkJoinFlg = 'N' ;                                               //0005
                         wkSourceMapping = 'FROM ' + %Trim(wkPhysicalFile);              //0002
                         LoadDDLSrcDtaArray();                                           //0008
                      Else;                                                              //0005
                         wkSourceMappingjf = 'FROM ' + %Trim(wkJoinFiles)   ;            //0008
                         Exsr LoadJoinDDLSrcDta;                                         //0008
                         Clear wkSourceMappingjf;                                        //0008
                      Endif;                                                             //0005

                 Other;
              EndSl;
           EndIf;
           wkYesDDLSrcDta = 'N';

      When inSrcMapKeyword = 'FIELDS';
           GetFileFieldsForDDLSource('FIELDS');
           wkYesDDLSrcDta = 'N';

      When inSrcMapKeyword = 'AUDCRTBY'
        Or inSrcMapKeyword = 'AUDCRTTIMS'
        Or inSrcMapKeyword = 'AUDUPDBY'
        Or inSrcMapKeyword = 'AUDUPDTIMS';
           If inSrcMapKeyword = 'AUDUPDTIMS';
                 wkSourceMapping = %trimr(wkSourceMapping) + ')';
           Else;
                 wkSourceMapping = %trimr(wkSourceMapping) + ',';
           EndIf;

      When inSrcMapKeyword = 'FILEIDH'
        Or inSrcMapKeyword = 'FILEIDT'    ;
           wkSourceMapping = %trimr(wkSourceMapping) + ',';

      When inSrcMapKeyword = 'AUDCRTBYH'
        Or inSrcMapKeyword = 'AUDCRTTIMH'
        Or inSrcMapKeyword = 'AUDUPDBYH'
        Or inSrcMapKeyword = 'AUDUPDTIMH';
           If inSrcMapKeyword = 'AUDUPDTIMH';
                 wkSourceMapping = %trimr(wkSourceMapping) + ');';
           Else;
                 wkSourceMapping = %trimr(wkSourceMapping) + ',';
           EndIf;

      When inSrcMapKeyword = 'AUDCRTBYT'
        Or inSrcMapKeyword = 'AUDCRTTIMT'
        Or inSrcMapKeyword = 'AUDUPDBYT'
        Or inSrcMapKeyword = 'AUDUPDTIMT';
           If inSrcMapKeyword = 'AUDUPDTIMT';
                 wkSourceMapping = %trimr(wkSourceMapping) + ');';
           Else;
                 wkSourceMapping = %trimr(wkSourceMapping) + ',';
           EndIf;

      When inSrcMapKeyword = 'RCDFMT';
           wkSourceMapping = %TrimR(wkSourceMapping) + wkSpace +
                             %Trim(wkRecordFormat) + ';';

      When inSrcMapKeyword = 'RNMTBL'
        Or inSrcMapKeyword = 'RNMIDX' ;
           wkSourceMapping =
               %ScanRpl('&VAR1': %Trim(inDDLLngNam):wkSourceMapping);
           wkSourceMapping =
               %ScanRpl('&VAR2': %Trim(inDDLObjNam):wkSourceMapping);

      When inSrcMapKeyword = 'ADDLBL'
        Or inSrcMapKeyword = 'LBLIDX'
        Or inSrcMapKeyword = 'LBLVIEW';
           If wkKeyIdxNm <> *Blanks;                                                     //0007
              wkSourceMapping =                                                          //0007
                   %ScanRpl('&VAR1': %Trim(wkKeyIdxNm):wkSourceMapping);                 //0007
           Else;                                                                         //0007
              wkSourceMapping =
                   %ScanRpl('&VAR1': %Trim(inDDLObjNam):wkSourceMapping);
           EndIf;                                                                        //0007
           wkSourceMapping =
                %ScanRpl('&VAR2': %Trim(wkDDSObjTxt):wkSourceMapping);                   //0022

           //If Object text contains more single quotes and exceeds                     //0022
           //the maximum length then split the TABLE LABEL in 1st line                  //0022
           //and the object text in 2nd line.                                           //0022
           If %Len(%Trim(wkDDSObjTxt)) >  50;                                            //0022
              wkLabelPos = %scan(' IS ':wkSourceMapping);                                //0022
              ddlSrcDtaIdx = ddlSrcDtaIdx + 1;                                           //0022
              wkDDLSrcDta(ddlSrcDtaIdx) = %subst(wkSourceMapping:1:                      //0022
                (wkLabelPos + 2));                                                       //0022
              wkColonPos = %scanr(';'  :wkSourceMapping);                                //0022
              ddlSrcDtaIdx = ddlSrcDtaIdx + 1;                                           //0022
              wkDDLSrcDta(ddlSrcDtaIdx) = %subst(wkSourceMapping:                        //0022
                (wkLabelPos + 4):(wkColonPos + 1));                                      //0022
              wkYesDDLSrcDta = 'N';                                                      //0022
           EndIf;                                                                        //0022

      When inSrcMapKeyword = 'COLLBL' ;
           wkSourceMapping =
                %ScanRpl('&VAR1': %Trim(inDDLObjNam):wkSourceMapping);

      When inSrcMapKeyword = 'COLHDG';
           wkSourceMappingSv = wkSourceMapping;
           For ddlColHdgIdx = 1 To ddlFldSrcIdx;
             Clear wkSourceMapping;
             wkSourceMapping = wkSourceMappingSv;
             wkSourceMapping =
                %ScanRpl('&VAR1':
                         (udDDLFldSrc(ddlColHdgIdx).usFieldNameInternal):
                         wkSourceMapping) ;
             wkSourceMapping =
                %ScanRpl('&VAR2':
                         (SQUOTE+SQUOTE+udDDLFldSrc(ddlColHdgIdx).usColumnHeading1):
                         wkSourceMapping) ;

             If udDDLFldSrc(ddlColHdgIdx).usColumnHeading2 <> *Blanks;
                wkSourceMapping =
                   %ScanRpl('&VAR3':
                           (udDDLFldSrc(ddlColHdgIdx).usColumnHeading2):
                           wkSourceMapping) ;
             Else;
                wkSourceMapping = %ScanRpl('&VAR3':'':wkSourceMapping);
             EndIf;

             If udDDLFldSrc(ddlColHdgIdx).usColumnHeading3 <> *Blanks;
             wkSourceMapping =
                %ScanRpl('&VAR4':
                         (udDDLFldSrc(ddlColHdgIdx).usColumnHeading3):
                         wkSourceMapping) ;
             Else;
                wkSourceMapping = %scanrpl('&VAR4':'':wkSourceMapping);
             EndIf;

             wkSourceMapping = %TrimR(wkSourceMapping) + SQUOTE + SQUOTE;

             If ddlColHdgIdx = ddlFldSrcIdx And inIncludeAudCols <> 'Y';
                wkSourceMapping = %TrimR(wkSourceMapping) + ');';
             Else;
                wkSourceMapping = %TrimR(wkSourceMapping) + ',';
             EndIf;

             LoadDDLSrcDtaArray();
           EndFor;
           wkYesDDLSrcDta = 'N';

      When inSrcMapKeyword = 'COLTXT';
           wkSourceMappingSv = wkSourceMapping;
           For ddlColTxtIdx = 1 To ddlFldSrcIdx;
             Clear wkSourceMapping;
             wkSourceMapping = wkSourceMappingSv;
             wkSourceMapping =
                %ScanRpl('&VAR1':
                         (udDDLFldSrc(ddlColTxtIdx).usFieldNameInternal):
                         wkSourceMapping) ;
             wkSourceMapping =
                %ScanRpl('&VAR2':
                        (SQUOTE+ SQUOTE + %Trim(udDDLFldSrc(ddlColTxtIdx).usColumnText)):
                         wkSourceMapping) ;

             wkSourceMapping = %TrimR(wkSourceMapping) + SQUOTE + SQUOTE;

             If ddlColTxtIdx = ddlFldSrcIdx And inIncludeAudCols <> 'Y';
                wkSourceMapping = %TrimR(wkSourceMapping) + ');';
             Else;
                wkSourceMapping = %TrimR(wkSourceMapping) + ',';
             EndIf;

             LoadDDLSrcDtaArray();
           EndFor;
           wkYesDDLSrcDta = 'N';

      When inSrcMapKeyword = 'PRIKEY' ;
           If wkIsPrimaryKey = 'Y';
              wkSourceMapping = %TrimR(wkSourceMapping)  + '(' +
                                %Trim(wkPrimaryKeyList) + '))';
           Else;
              wkYesDDLSrcDta = 'N';
           EndIf;

      When inSrcMapKeyword = 'SELECTOMIT';                                               //0010
           LoadSelectOmitCondition();                                                    //0010
           wkYesDDLSrcDta = 'N';                                                         //0010

      When inSrcMapKeyword = 'BLANKS' ;
           //Do Nothing.Just to maintain wkYesDDLSrcDta as 'Y'

      When inSrcMapKeyword = 'RCDFMTCMNT';
           //Do Nothing.Just to maintain wkYesDDLSrcDta as 'Y'

      When inSrcMapKeyword = 'RNMTBLCMNT';
           //Do Nothing.Just to maintain wkYesDDLSrcDta as 'Y'

      When inSrcMapKeyword = 'ADDLBLCMNT';
           //Do Nothing.Just to maintain wkYesDDLSrcDta as 'Y'

      When inSrcMapKeyword = 'COLHDGCMNT';
           //Do Nothing.Just to maintain wkYesDDLSrcDta as 'Y'

      When inSrcMapKeyword = 'COLTXTCMNT';
           //Do Nothing.Just to maintain wkYesDDLSrcDta as 'Y'

      When inSrcMapKeyword = 'RNMIDXCMNT';
           //Do Nothing.Just to maintain wkYesDDLSrcDta as 'Y'

      When inSrcMapKeyword = 'LBLIDXCMNT';
           //Do Nothing.Just to maintain wkYesDDLSrcDta as 'Y'

      When inSrcMapKeyword = 'LBLVWCMNT';
           //Do Nothing.Just to maintain wkYesDDLSrcDta as 'Y'

      When inSrcMapKeyword = 'CRTIDXCMNT';
           //Do Nothing.Just to maintain wkYesDDLSrcDta as 'Y'

      Other;
         wkYesDDLSrcDta = 'N';
   EndSl;

   If outStatus  = 'E';
      Return;
   EndIf;

   If wkYesDDLSrcDta = 'Y';
      LoadDDLSrcDtaArray();
   EndIf;

   //LoadJoinDDLSrcDta : Subroutine to spilt the Join part to format it in DDL source   //0008
   BegSr LoadJoinDDLSrcDta;                                                              //0008
      wkkeylen = %len(%trim(wkJoinVal));                                                 //0008
      wkKeyPos = 1;                                                                      //0008
      wkStrPos = 1;                                                                      //0008
      DoW wkStrPos < %len(wkSourceMappingjf);                                            //0008
         wkkeypos = %scan(%trim(wkJoinVal) :wkSourceMappingjf :wkStrPos);                //0008
         If wkkeypos >0;                                                                 //0008
            wkSourceMapping = %subst(wkSourceMappingjf :wkStrPos                         //0008
                                     :wkkeypos + wkKeyLen - wkStrPos);                   //0008
            wkSourceMapping = %trim(wkSourceMapping);                                    //0008
            LoadDDLSrcDtaArray();                                                        //0008
            wkStrPos = wkkeypos + wkKeyLen;                                              //0008
         Else;                                                                           //0008
            wkSourceMapping = %subst(wkSourceMappingjf :wkStrPos);                       //0008
            wkSourceMapping = %trim(wkSourceMapping);                                    //0008
            LoadDDLSrcDtaArray();                                                        //0008
            Leave;                                                                       //0008
         EndIf;                                                                          //0008
      EndDo;                                                                             //0008
   EndSr;                                                                                //0008

End-Proc;

//------------------------------------------------------------------------------------- //
//GetFileFieldsForDDLSource : To get File Fields for DDL Source                         //
//------------------------------------------------------------------------------------- //
Dcl-Proc GetFileFieldsForDDLSource;
   Dcl-Pi *n;
      inSrcMapKeyword   Char(10) Value;
   End-Pi;

   WkDDSObjNam  =  inDDSObjNam;                                                          //0018
   WkDDSLibrary =  inDDSLibrary;                                                         //0018
   WkDDSObjType =  inDDSObjType;                                                         //0018
   wkRcdFmt     =  inDDSRcdFmt;                                                          //0023

   //Open cursor
   Exec Sql Open CursorDDLFldSrc;
   If sqlCode = CSR_OPN_COD;
      Exec Sql Close CursorDDLFldSrc;
      Exec Sql Open  CursorDDLFldSrc;
   EndIf;

   If sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Open_CursorDDLFldSrc';
      IaSqlDiagnostic(uDpsds);
   EndIf;

   //Get the number of elements
   noOfRows = %elem(wkDDLSrcDta);

   //Fetch records from CursorDDLFldSrc
   rowFound = FetchRecordCursorDDLFldSrc();

   If rowFound and WkIncludeIdCol = 'N';
      If inIncludeIdCol = 'Y';
         wkSourceMapping = %Trim(inDDSObjNam) + '_iD' + wkSpace +
                           'For Column File_Id' +
                           wkSpace + 'Int Generated By Default As Identity,';
         LoadDDLSrcDtaArray();
         Clear wkSourceMapping;
         WkIncludeIdCol = 'Y';
      EndIf;
   EndIf;

   Dow rowFound;

      For ddlFldSrcIdx = 1 To RowsFetched;
         Select;
            When inSrcMapKeyword = 'FIELDS';

               If udDDLFldSrc(ddlFldSrcIdx).usFieldNameAlias <> *Blanks;
                  wkSourceMapping = %TrimR(udDDLFldSrc(ddlFldSrcIdx).usFieldNameAlias) +
                                    ' FOR COLUMN ' +
                                    udDDLFldSrc(ddlFldSrcIdx).usFieldNameInternal;
                  LoadDDLSrcDtaArray();
                  Clear wkSourceMapping;
               Else;
                  wkSourceMapping = udDDLFldSrc(ddlFldSrcIdx).usFieldNameInternal;
               EndIf;

               GetFieldAttributes();
         Endsl;

         If udDDLFldSrc(ddlFldSrcIdx).usColumnText <> *Blanks;                           //0016
            colTxtFound = *On;                                                           //0016
         EndIf;                                                                          //0016

         LoadDDLSrcDtaArray();
    EndFor;

    //Correcting the index, to get the exact number of fields,
    ddlFldSrcIdx = ddlFldSrcIdx - 1;

    //Storing Record Format name for DDL Source
    wkRecordFormat = udDDLFldSrc(ddlFldSrcIdx).usRecordFormat ;

    //if fetched rows are less than the array elements then come out of the loop.
    If RowsFetched < noOfRows ;
       Leave ;
    EndIf ;

    //Fetch records from CursorDDLFldSrc cursor
    rowFound = FetchRecordCursorDDLFldSrc();

   Enddo;

   //Close cursor
   Exec Sql Close CursorDDLFldSrc;

End-Proc;

//------------------------------------------------------------------------------------- //
//FetchRecordCursorDDLFldSrc: To fetch DDL Fields source                                //
//------------------------------------------------------------------------------------- //
Dcl-Proc FetchRecordCursorDDLFldSrc;

   Dcl-Pi FetchRecordCursorDDLFldSrc Ind End-Pi ;

   Dcl-S  rcdFound Ind Inz('0');
   Dcl-S  wkRowNum Like(RowsFetched) ;

   RowsFetched = *zeros;
   Clear udDDLFldSrc;

   Exec Sql
      Fetch CursorDDLFldSrc For :noOfRows Rows Into :udDDLFldSrc;

   If sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Fetch_CursorDDLFldSrc';
      IaSqlDiagnostic(uDpsds);
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

//------------------------------------------------------------------------------------- //
//LoadDDLSrcDtaArray : To Load DDL source Array                                         //
//------------------------------------------------------------------------------------- //
Dcl-Proc LoadDDLSrcDtaArray;

   //Local Variable                                                                     //0010
   Dcl-S wkSrcMapLen   uns(5) inz;                                                       //0010
   Dcl-S wkSplitLen    uns(5) inz;                                                       //0010

   wkSourceMappingBk = wkSourceMapping;

   wkSrcMapLen = %Len(%Trim(wkSourceMappingBk));                                         //0010
   //If source line is crossing maximum length(92), break the line                      //0010
   DoW wkSrcMapLen > 92;                                                                 //0010
      wkSplitLen = 92;                                                                   //0010
      If %subst(wkSourceMappingBk :92:1) <> ' ' and                                      //0010
         %subst(wkSourceMappingBk :92:1) <> ')' and                                      //0010
         %subst(wkSourceMappingBk :92:1) <> ',';                                         //0010
         wkSplitLen = %scanr(' ' :%subst(wkSourceMappingBk:1:92));                       //0010
      EndIf;                                                                             //0010

      wkSourceMapping = %Subst(wkSourceMappingBk:1:wkSplitLen);                          //0010
      ddlSrcDtaIdx = ddlSrcDtaIdx + 1;                                                   //0010
      wkDDLSrcDta(ddlSrcDtaIdx) = wkSourceMapping ;                                      //0010

      wkSourceMappingBk  = %Subst(wkSourceMappingBk:wkSplitLen+1);                       //0010
      wkSrcMapLen = %Len(%Trim(wkSourceMappingBk));                                      //0010
   EndDo;                                                                                //0010

   ddlSrcDtaIdx = ddlSrcDtaIdx + 1;                                                      //0010
   wkDDLSrcDta(ddlSrcDtaIdx) = wkSourceMappingBk;                                        //0010

End-Proc;

//------------------------------------------------------------------------------------- //
//ClearDDLSrcEntry : Clear the DDL Source Entry in IADDLSRCP                            //
//------------------------------------------------------------------------------------- //
Dcl-Proc ClearDDLSrcEntry;

   Exec Sql
      Delete From IADDLSRCP
       Where WLIBNAM = :inDDLMbrLib
         And WSRCNAM = 'QDDLSRC'
         And WMBRNAM = :inDDLMbrNam
         And WMBRTYP = :inDDLSrcAtr;                                                     //0023

   If sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Delete_IADDLSRCP';
      IaSqlDiagnostic(uDpsds);
   EndIf;

End-Proc;

//------------------------------------------------------------------------------------- //
//WriteDDLMember : Write the complete DDL Source Data to DDL Member                     //
//------------------------------------------------------------------------------------- //
Dcl-Proc WriteDDLMember;

   //Local Variables
   Dcl-S writeDDLSrc Char(92) Inz;
   Dcl-S wkSrcRrn Packed(6:0) Inz;
   Dcl-S wkSrcSeq Packed(6:2) Inz;

   Clear wkSqlStmt;
   Clear wkSrcRrn;
   Clear wkSrcSeq;

   For writeIdx = 1 To ddlSrcDtaIdx;
       writeDDLSrc = wkDDLSrcDta(writeIdx);

       //Skip the transalate as where condition is case sensitive                       //0010
       If writeIdx < wkSlOmStart or writeIdx > wkSlOmEnd;                                //0010
          writeDDLSrc = %Xlate(UPPER:LOWER:writeDDLSrc);
       EndIf;                                                                            //0010

       wkSrcRrn += 1;                                                                    //0001
       wkSrcSeq += 1;                                                                    //0001
       wkSqlStmt = 'Insert Into ' + %Trim(inDDLMbrLib) + '/QDDLSRC' +                    //0001
                   '(srcseq, srcdta)'   +                                                //0001
                   ' values(' + %Trim(%char(wkSrcSeq)) + ',' +                           //0001
                   SQUOTE + writeDDLSrc + SQUOTE + ')';                                  //0001

       Exec Sql Execute Immediate :wkSqlStmt;
       If sqlCode < successCode;
          uDpsds.wkQuery_Name = 'Insert_DDLSrcMbr';
          IaSqlDiagnostic(uDpsds);
       EndIf;

       //Write DDL Source Entry in IADDLSRCP file
       WriteDDLSource(writeDDLSrc :wkSrcRrn :wkSrcSeq);

   EndFor;

End-Proc;

//------------------------------------------------------------------------------------- //
//WriteDDLSource : Write DDL Sources for converted DDS file.                            //
//------------------------------------------------------------------------------------- //
Dcl-Proc WriteDDLSource;
   Dcl-Pi *N;
      inDDLSrcData Char(92);
      inSrcRrn Packed(6:0);
      inSrcSeq Packed(6:2);
   End-Pi;

   Dcl-S wkSqlStmt VarChar(1200) Inz;

   Clear wkSqlStmt;

   wkSqlStmt = 'Insert Into IADDLSRCP (wLibNam, wSrcNam, wMbrNam,' +
               'wMbrTyp, wSrcRrn, wSrcSeq, wSrcDat, wSrcDta, wCrtUser)' +
               'values(' + SQUOTE + inDDLMbrLib + SQUOTE + ', ' +
                       '''QDDLSRC''' + ', ' +
                       SQUOTE + inDDLMbrNam + SQUOTE + ', ' +
                       SQUOTE + inDDLSrcAtr + SQUOTE + ', ' +                            //0023
                       %Editc(inSrcRrn:'M') + ', ' +
                       %Editc(inSrcSeq:'M') + ', ' +
                       %Editc(0:'X') + ', ' +
                       SQUOTE + inDDLSrcData + SQUOTE + ',' +
                       SQUOTE + inRequestedUser + SQUOTE + ')';

   Exec Sql Execute Immediate :wkSqlStmt;

   If sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Insert_IADDLSRCP';
      IaSqlDiagnostic(uDpsds);
   EndIf;

End-Proc;

//------------------------------------------------------------------------------------- //
//GetLogicalFileDetails : To get all the details of DDS Logical File                    //
//------------------------------------------------------------------------------------- //
Dcl-Proc GetLogicalFileDetails;

   //Get Record Format Name and Field Count of Logical File
   Exec Sql
      Select whname, whnfld Into :wkRecordFormat, :logicalFileFieldCount                 //0018
        From iDspFFd                                                                     //0018
       Where whlib  = :inDDSLibrary                                                      //0023
         And whfile = :inDDSObjNam                                                       //0023
         And whname = :inDDSRcdFmt                                                       //0023
         And whftyp = 'L';

   //Get Physical File Details of Logical File                                          //0007
   Exec Sql                                                                              //0023
      Select MBBOL, MBBOF, MBBOM, MBJOIN, MBNSCM                                         //0023
        Into :wkPhysicalFileLib,:wkPhysicalFile,:wkPhysicalFileMbr,                      //0023
             :wkJoinFlg, :wkNoOfMbrAcessLF                                               //0023
        From iDspFdMbr                                                                   //0023
       Where MBLib  = :inDDSLibrary                                                      //0023
         And MBFile = :inDDSObjNam                                                       //0023
         And MBName = :inDDSMbrName                                                      //0023
         And MBBOLF = :inDDSRcdFmt                                                       //0023
       Fetch First Row Only;                                                             //0023

   If wkJoinFlg  = 'Y';                                                                  //0005
      //Get Join Type                                                                   //0005
      wkJoinType = GetJoinType();                                                        //0005
      If wkJoinType = 'I';                                                               //0005
         wkJoinVal = 'Inner Join';                                                       //0005
      Else;                                                                              //0005
         wkJoinVal = 'Left Outer Join';                                                  //0005
      Endif;                                                                             //0005
      //Get Physical File Details which are used to create join LF                      //0005
      GetJoinPhysicalFile();                                                             //0005
      wkAllFieldSelect = 'N' ;                                                           //0005
   Else;                                                                                 //0005
      //Get Physical File Record Format Name                                            //0023
      Exec Sql                                                                           //0023
         Select rfname                                                                   //0023
           Into :wkRcdFmt                                                                //0023
           From iDspFdRFmt                                                               //0023
          Where rflib  = :wkPhysicalFileLib                                              //0023
            And rffile = :wkPhysicalFile;                                                //0023

      //Get number of fields in Physical File.                                          //0005
      Exec Sql                                                                           //0005
         Select whnfld Into :physicalFileFieldCount From iDspFFd                         //0005
          Where whfile = :wkPhysicalFile                                                 //0005
            And whlib  = :wkPhysicalFileLib                                              //0005
            And whname = :wkRcdFmt                                                       //0023
            And whftyp = 'P';                                                            //0005

   Endif;                                                                                //0005

   //If all fields are not selected,
   //then check for different field names and prepare the fields list.
   //Check Fields are matching with Phyical file fields.                                //0018
   If ChkFieldMatchesWithPF() = 'N';                                                     //0018
      //Load the DDS file field function details                                        //0017
      LoadFileFldFuncDtl();                                                              //0017

      For logicalFldIdx = 1 To RowsFetched;
         If wkJoinFlg = 'N' ;                                                            //0005
            wkInternalFldName =                                                          //0005
            udDDLFldSrc(logicalFldIdx).usFieldNameInternal;                              //0005
            //If field is having function                                               //0017
            If wkNoOfFunc > 0;                                                           //0017
               ExSr chekFieldFunc;                                                       //0017
            EndIf;                                                                       //0017
            wkExternalFldName =                                                          //0005
            udDDLFldSrc(logicalFldIdx).usFieldNameExternal;                              //0005
         Else;                                                                           //0005
            //If field is having function                                               //0024
            wkInternalFldName =  'Q' +                                                   //0026
            %char(udDDLFldSrc(logicalFldIdx).usJoinRef) + '.' +                          //0026
            udDDLFldSrc(logicalFldIdx).usFieldNameInternal;                              //0026
            If wkNoOfFunc > 0;                                                           //0024
               ExSr chekFieldFunc;                                                       //0024
               wkInternalFldName =  %Scanrpl('(':'(Q' +                                  //0024
                %char(udDDLFldSrc(logicalFldIdx).usJoinRef) + '.'                        //0024
                :wkInternalFldName);                                                     //0024
               wkInternalFldName =  %Scanrpl('||':'||Q' +                                //0024
                %char(udDDLFldSrc(logicalFldIdx).usJoinRef) + '.'                        //0024
                :wkInternalFldName);                                                     //0024
            EndIf;                                                                       //0024
            wkExternalFldName =                                                          //0007
            udDDLFldSrc(logicalFldIdx).usFieldNameExternal;                              //0007
         Endif;                                                                          //0005

         If logicalFldIdx = logicalFileFieldCount;
            wkInternalFldArr(logicalFldIdx) = %Trim(wkInternalFldName);                  //0008
            wkExternalFldArr(logicalFldIdx) = %Trim(wkExternalFldName);                  //0008
         Else;
            wkInternalFldArr(logicalFldIdx) = %Trim(wkInternalFldName) + ',' ;           //0008
            wkExternalFldArr(logicalFldIdx) = %Trim(wkExternalFldName) + ',' ;           //0008
         EndIf;

         If wkInternalFldName <> wkExternalFldName ;
            wkDiffFieldNames = 'Y';
         EndIf;
      EndFor;

   EndIf;

   //Get the Converted Physical File Table Name                                         //0019
   wkPhysicalFile = GetPhysicalFileTableName(wkPhysicalFileLib                           //0019
                                             :wkPhysicalFile);                           //0019

   BegSr chekFieldFunc;                                                                  //0017
      //Lookup field in file field function data structure                              //0017
      wkPos = %LookUp(%Trim(udDDLFldSrc(logicalFldIdx).usFieldNameExternal) :            //0026
                                                 udFieldFunc(*).usFldENm);               //0026
      //Get the field function Data from file field function data structure             //0017
      If wkPos > 0;                                                                      //0017
         //Map DDS Field Key to SQL Function.                                           //0017
         Select;                                                                         //0017
            When udFieldFunc(wkPos).usKeyNm = 'SST';                                     //0017
               udFieldFunc(wkPos).usKeyNm = 'SUBSTRING';                                 //0017
               wkFldName = %Trim(udFieldFunc(wkPos).usKeyNm) +                           //0017
                           %Trim(udFieldFunc(wkPos).usKeyVal);                           //0017
            When udFieldFunc(wkPos).usKeyNm = 'CONCAT';                                  //0017
               udFieldFunc(wkPos).usKeyNm = '||';                                        //0017
               wkFldName = %Trim(udFieldFunc(wkPos).usKeyVal);                           //0017
               wkFldName = %Scanrpl(',':udFieldFunc(wkPos).usKeyNm:wkFldName);           //0017
               wkFldName = %Scanrpl(' ':'':wkFldName);                                   //0017
            Other;                                                                       //0017
         EndSl;                                                                          //0017

         wkInternalFldName = wkFldName;                                                  //0017
         wkNoOfFunc = wkNoOfFunc - 1;                                                    //0017
      EndIf;                                                                             //0017

   EndSr;                                                                                //0017

End-Proc;

//------------------------------------------------------------------------------------- //0017
//LoadFileFldFuncDtl : To load the file field function details                          //0017
//------------------------------------------------------------------------------------- //0017
Dcl-Proc LoadFileFldFuncDtl;                                                             //0017

   Dcl-S  wkRowNum Like(RowsFetched) ;                                                   //0017

   //Open CursorFldFuncDtl cursor                                                       //0017
   Exec Sql Open CursorFldFuncDtl;                                                       //0017
   If sqlCode = CSR_OPN_COD;                                                             //0017
      Exec Sql Close CursorFldFuncDtl;                                                   //0017
      Exec Sql Open  CursorFldFuncDtl;                                                   //0017
   EndIf;                                                                                //0017

   If sqlCode < successCode;                                                             //0017
      uDpsds.wkQuery_Name = 'Open_CursorFldFuncDtl';                                     //0017
      IaSqlDiagnostic(uDpsds);                                                           //0017
   EndIf;                                                                                //0017

   wkNoOfFunc = *Zeros;                                                                  //0017
   Clear udFieldFunc;                                                                    //0017

   //Get the number of elements                                                         //0017
   noOfRows = %elem(udFieldFunc);                                                        //0017

   Exec Sql                                                                              //0017
      Fetch CursorFldFuncDtl For :noOfRows Rows Into :udFieldFunc;                       //0017

   If sqlCode < successCode;                                                             //0017
      uDpsds.wkQuery_Name = 'Fetch_CursorFldFuncDtl';                                    //0017
      IaSqlDiagnostic(uDpsds);                                                           //0017
   EndIf;                                                                                //0017

   If sqlcode = successCode;                                                             //0017
      Exec Sql Get Diagnostics                                                           //0017
         :wkRowNum = ROW_COUNT;                                                          //0017
         wkNoOfFunc = wkRowNum ;                                                         //0017
   EndIf;                                                                                //0017

   //Close cursor                                                                       //0017
   Exec Sql Close CursorFldFuncDtl;                                                      //0017

End-Proc;                                                                                //0017

//------------------------------------------------------------------------------------- //
//ChkFieldMatchesWithPF : Check Field Matches with Physical file                        //
//------------------------------------------------------------------------------------- //
Dcl-Proc ChkFieldMatchesWithPF;                                                          //0018

   Dcl-pi *n Char(1);
     uWFldMtcFlg Char(1) options(*nopass);
   End-pi;

   //Check for number of fields selected.All Fields selected or not.
   //when logical file is a non join logical file                                       //0005
   If physicalFileFieldCount = logicalFileFieldCount and                                 //0023
      wkJoinFlg <> 'Y' and                                                               //0023
      inDDSFileType <> 'MRF' and                                                         //0023
      inDDSFileType <> 'MMF';                                                            //0023

      wkAllFieldSelect = 'Y';

      //To get the Physical file field details                                          //0018
      WkDDSObjNam  = wkPhysicalFile ;                                                    //0018
      WkDDSLibrary = wkPhysicalFileLib;                                                  //0018
      WkDDSObjType = 'P';                                                                //0018
                                                                                         //0018
      //Open Cursor                                                                     //0018
      Exec Sql Open CursorDDLFldSrc;                                                     //0018
      If sqlCode = CSR_OPN_COD;                                                          //0018
         Exec Sql Close CursorDDLFldSrc;                                                 //0018
         Exec Sql Open  CursorDDLFldSrc;                                                 //0018
      EndIf;                                                                             //0018
                                                                                         //0018
      If sqlCode < successCode;                                                          //0018
         uDpsds.wkQuery_Name = 'Open_CursorDDLFldSrc';                                   //0018
         IaSqlDiagnostic(uDpsds);                                                        //0018
      EndIf;                                                                             //0018

       //Get the number of elements                                                     //0018
      noOfRows = %elem(wkDDLSrcDta);                                                     //0018
                                                                                         //0018
      rowFound = FetchRecordCursorDDLFldSrc();                                           //0018
                                                                                         //0018
      If rowFound;                                                                       //0018
         udPfFieldSrc = udDDLFldSrc;                                                     //0018
         Clear udDDLFldSrc;                                                              //0018
      EndIf;                                                                             //0018
                                                                                         //0018
      //Close Cursor                                                                    //0018
      Exec Sql Close CursorDDLFldSrc;                                                    //0018

   EndIf;                                                                                //0018

   //To get the Logical file field details                                              //0018
   WkDDSObjNam  =  inDDSObjNam;                                                          //0018
   WkDDSLibrary =  inDDSLibrary;                                                         //0018
   WkDDSObjType =  inDDSObjType;                                                         //0018
   wkRcdFmt     =  inDDSRcdFmt;                                                          //0023
                                                                                         //0018
   //open cursor                                                                        //0018
   Exec Sql Open CursorDDLFldSrc;                                                        //0018
   If sqlCode = CSR_OPN_COD;                                                             //0018
      Exec Sql Close CursorDDLFldSrc;                                                    //0018
      Exec Sql Open  CursorDDLFldSrc;                                                    //0018
   EndIf;                                                                                //0018
                                                                                         //0018
   If sqlCode < successCode;                                                             //0018
      uDpsds.wkQuery_Name = 'Open_CursorDDLFldSrc';                                      //0018
      IaSqlDiagnostic(uDpsds);                                                           //0018
   EndIf;                                                                                //0018

   //Get the number of elements                                                         //0018
   noOfRows = %elem(wkDDLSrcDta);                                                        //0018
                                                                                         //0018
   rowFound = FetchRecordCursorDDLFldSrc();                                              //0018
                                                                                         //0018
   //To check if the Physical File and Logical File fields are in the same              //0018
   //order, If it's not in same order set the 'wkAllFieldSelect' as N.                  //0018
   If rowfound and wkAllFieldSelect = 'Y';                                               //0018
      CheckPfLfFileFieldOrder();                                                         //0018
   EndIf;                                                                                //0018

   //Close Cursor                                                                       //0018
   Exec Sql Close CursorDDLFldSrc;                                                       //0018

   Return wkAllFieldSelect;                                                              //0018

End-Proc;                                                                                //0018
//------------------------------------------------------------------------------------- //
//GetFieldAttributes : Get attributes like DataType, AllowNull and Default value        //
//------------------------------------------------------------------------------------- //
Dcl-Proc GetFieldAttributes;

   Dcl-S wkDDSDataType      Char(1)        Inz;
   Dcl-S wkDDLDataType      Char(25)       Inz;
   Dcl-S wkCCSID            Char(15)       Inz;
   Dcl-S wkDefaultValue     Char(30)       Inz;
   Dcl-S wkAllowNull        Char(8)        Inz('        ');
   Dcl-S wkFldLength        Char(5)        Inz;

   wkDDSDataType = %Trim(udDDLFldSrc(ddlFldSrcIdx).usFieldDataType);

   If udDDLFldSrc(ddlFldSrcIdx).usAllowNull = 'N';
      wkAllowNull = 'NOT NULL';
   EndIf;

   Select;
     //For DDS Data Type S (ZONED)
     When wkDDSDataType = 'S';
          wkDDLDataType = 'NUMERIC(' +
                        %Trim(%Char(udDDLFldSrc(ddlFldSrcIdx).usFieldLength)) + ',' +
                        %Trim(%Char(udDDLFldSrc(ddlFldSrcIdx).usFieldDecPos))+ ')' ;

          If udDDLFldSrc(ddlFldSrcIdx).usDefaultValue <> *Blanks;
             wkDefaultValue = %Trim(%Char(udDDLFldSrc(ddlFldSrcIdx).usDefaultValue));
          Else;
             wkDefaultValue = '0';
          EndIf;

     //For DDS Data Type P (PACKED)
     When wkDDSDataType = 'P';
          wkDDLDataType = 'DECIMAL(' +
                        %Trim(%Char(udDDLFldSrc(ddlFldSrcIdx).usNumberOfDigits)) + ',' +
                        %Trim(%Char(udDDLFldSrc(ddlFldSrcIdx).usFieldDecPos)) + ')' ;

          If udDDLFldSrc(ddlFldSrcIdx).usDefaultValue <> *Blanks;
             wkDefaultValue = %Trim(%Char(udDDLFldSrc(ddlFldSrcIdx).usDefaultValue));
          Else;
             wkDefaultValue = '0';
          EndIf;

     //For DDS Data Type A (CHARACTER)
     When wkDDSDataType = 'A';
          If %Trim(udDDLFldSrc(ddlFldSrcIdx).usVariableLength) = 'Y';
             wkDDLDataType = 'VARCHAR(' +
                          %Trim(%Char(udDDLFldSrc(ddlFldSrcIdx).usFieldLength)) + ')' ;
          Else;
             wkDDLDataType = 'CHAR(' +
                          %Trim(%Char(udDDLFldSrc(ddlFldSrcIdx).usFieldLength)) + ')' ;
          EndIf;

          If udDDLFldSrc(ddlFldSrcIdx).usDefaultValue <> *Blanks;
             wkDefaultValue = %Trim(%Char(udDDLFldSrc(ddlFldSrcIdx).usDefaultValue));
             //Replacing single quote with double quotes for default values
             wkDefaultValue = %Scanrpl('''':'''''':wkDefaultValue);
          Else;
             wkDefaultValue = SQUOTE + SQUOTE + ' ' + SQUOTE + SQUOTE ;
          EndIf;

     //For DDS Data Type L (DATE)
     When wkDDSDataType = 'L';
          wkDDLDataType = 'DATE' ;

          If udDDLFldSrc(ddlFldSrcIdx).usDefaultValue <> *Blanks;
             wkDefaultValue = %Trim(%Char(udDDLFldSrc(ddlFldSrcIdx).usDefaultValue));
             //Replacing single quote with double quotes for default values
             wkDefaultValue = %Scanrpl('''':'''''':wkDefaultValue);
          Else;
             wkDefaultValue = 'CURRENT_DATE';
          EndIf;

     //For DDS Data Type T (TIME)
     When wkDDSDataType = 'T';
          wkDDLDataType = 'TIME' ;

          If udDDLFldSrc(ddlFldSrcIdx).usDefaultValue <> *Blanks;
             wkDefaultValue = %Trim(%Char(udDDLFldSrc(ddlFldSrcIdx).usDefaultValue));
             //Replacing single quote with double quotes for default values
             wkDefaultValue = %Scanrpl('''':'''''':wkDefaultValue);
          Else;
             wkDefaultValue = 'CURRENT_TIME' ;
          EndIf;

     //For DDS Data Type Z (TIMESTAMP)
     When wkDDSDataType = 'Z';
          wkDDLDataType = 'TIMESTAMP';

          If udDDLFldSrc(ddlFldSrcIdx).usDefaultValue <> *Blanks;
             wkDefaultValue = %Trim(%Char(udDDLFldSrc(ddlFldSrcIdx).usDefaultValue));
             //Replacing single quote with double quotes for default values
             wkDefaultValue = %Scanrpl('''':'''''':wkDefaultValue);
          Else;
             wkDefaultValue = 'CURRENT_TIMESTAMP' ;
          EndIf;

     //For DDS Data Type G (GRAPHIC)
     When wkDDSDataType = 'G';
          wkDDLDataType = 'GRAPHIC(' +
                       %Trim(%char(udDDLFldSrc(ddlFldSrcIdx).usGraphicFldLength)) + ')' +
                       wkSpace + 'CCSID 835';

          If udDDLFldSrc(ddlFldSrcIdx).usDefaultValue <> *Blanks;
              wkDefaultValue = %Trim(%Char(udDDLFldSrc(ddlFldSrcIdx).usDefaultValue));
          Else;
              wkDefaultValue = 'G' + SQUOTE + SQUOTE + SQUOTE + SQUOTE ;
          EndIf;

     //For DDS Data Type B(BINARY) Or F(FLOAT) Or H(HEXADECIMAL)
     When wkDDSDataType = 'B'
       Or wkDDSDataType = 'F'
       Or wkDDSDataType = 'H';

       If wkDDSDataType = 'B'
       Or wkDDSDataType = 'F';
          wkFldLength = %Trim(%Char(udDDLFldSrc(ddlFldSrcIdx).usNumberOfDigits));
       ElseIf wkDDSDataType = 'H';
          wkFldLength = %Trim(%Char(udDDLFldSrc(ddlFldSrcIdx).usFieldLength));
       EndIf;

          Exec Sql
             Select Trim(Src_Mapping)
               Into :wkDDLDataType
               From iaSrcMap
              Where SrcMbr_Type = :wkDDSTODDL
                And KeyField_1 = 'DATATYPE'
                And KeyField_2 = :wkDDSDataType
                And KeyField_3 = :wkFldLength;

          If SqlCode < successCode;
             uDpsds.wkQuery_Name = 'Select iASrcMap DataType';
             IaSqlDiagnostic(uDpsds);
          EndIf;

          If wkDDSDataType = 'H';
             wkDDLDataType = %Trim(wkDDLDataType) + wkSpace + 'FOR BIT DATA';
          EndIf;

          If udDDLFldSrc(ddlFldSrcIdx).usDefaultValue <> *Blanks;
              wkDefaultValue = %Trim(%Char(udDDLFldSrc(ddlFldSrcIdx).usDefaultValue));
              //Replacing single quote with double quotes for default values
              wkDefaultValue = %Scanrpl('''':'''''':wkDefaultValue);
          Else;
              Select;
                When wkDDSDataType = 'B'
                  Or wkDDSDataType = 'F';
                    wkDefaultValue = '0';
                When wkDDSDataType = 'H';
                    wkDefaultValue = SQUOTE + SQUOTE + ' ' + SQUOTE + SQUOTE ;
                Other;
              EndSl;
          EndIf;

     //For DDS Data Type J(ONLY) Or E(EITHER) Or O(OPEN)
     When wkDDSDataType = 'J'
       Or wkDDSDataType = 'E'
       Or wkDDSDataType = 'O';
          wkDDLDataType = 'CHAR(' +
                          %Trim(%Char(udDDLFldSrc(ddlFldSrcIdx).usFieldLength)) + ')' +
                          wkSpace + 'CCSID 937';

          If udDDLFldSrc(ddlFldSrcIdx).usDefaultValue <> *Blanks;
             wkDefaultValue = %Trim(%Char(udDDLFldSrc(ddlFldSrcIdx).usDefaultValue));
          Else;
             wkDefaultValue = SQUOTE + SQUOTE + ' ' + SQUOTE + SQUOTE ;
          EndIf;

     //For DDS Data Type 5(BINARY CHAR)
     When wkDDSDataType = '5';
        wkDDLDataType = 'BINARY(' +
                        %Trim(%Char(udDDLFldSrc(ddlFldSrcIdx).usFieldLength)) + ')' ;

        If udDDLFldSrc(ddlFldSrcIdx).usDefaultValue <> *Blanks;
           wkDefaultValue = %Trim(%Char(udDDLFldSrc(ddlFldSrcIdx).usDefaultValue));
           //Replacing single quote with double quotes for default values
           wkDefaultValue = %Scanrpl('''':'''''':wkDefaultValue);
        Else;
           wkDefaultValue = 'BINARY(' +SQUOTE+SQUOTE+SQUOTE+SQUOTE+ ')';
        EndIf;

     Other;
   EndSl;

   //Handling default null value
   If wkDefaultValue = '*NULL';
      wkDefaultValue = 'NULL';
   EndIf;

   //If no Audit Columns and the field is last field
   //then end with close bracket. Otherwise, end with comma.
   If ddlFldSrcIdx = RowsFetched
      And inIncludeAudCols <> 'Y';
      %Subst(wkSourceMapping:12) =  wkDDLDataType + wkSpace +
                                    wkAllowNull   + wkSpace + 'WITH DEFAULT' +
                                    wkSpace + %Trim(wkDefaultValue) + ')' ;
   Else;
      %Subst(wkSourceMapping:12) =  wkDDLDataType + WkSpace +
                                    wkAllowNull   + WkSpace + 'WITH DEFAULT' +
                                    wkSpace + %Trim(wkDefaultValue) + ',' ;
   EndIf;

End-Proc;

//------------------------------------------------------------------------------------- //0005
//GetJoinPhysicalFile : To get physical file details that are used to create join LF    //0005
//------------------------------------------------------------------------------------- //0005
Dcl-Proc GetJoinPhysicalFile;                                                            //0005
                                                                                         //0005
   //Open cursor                                                                        //0005
   Exec Sql Open CursorPhysicalFileDetails;                                              //0005
   If sqlCode = CSR_OPN_COD;                                                             //0005
      Exec Sql Close CursorPhysicalFileDetails ;                                         //0005
      Exec Sql Open  CursorPhysicalFileDetails ;                                         //0005
   EndIf;                                                                                //0005
                                                                                         //0005
   If sqlCode < successCode;                                                             //0005
      uDpsds.wkQuery_Name = 'Open_CursorPhysicalFileDetails';                            //0005
      IaSqlDiagnostic(uDpsds);                                                           //0005
   EndIf;                                                                                //0005
                                                                                         //0005
   rowFound = FetchRecordCursorPhysicalFileDetails();                                    //0005
   wkJoinFiles = *blanks;                                                                //0005
   If rowFound ;                                                                         //0005
      For wkPhysicalFileIdx = 1 To RowsFetched;                                          //0005
          wkToTableName = GetPhysicalFileTableName(                                      //0019
             udPhysicalFileDetails(wkPhysicalFileIdx).usJoinToLib :                      //0019
             udPhysicalFileDetails(wkPhysicalFileIdx).usJoinToFile);                     //0019
          //Preparing Join statement                                                    //0005
          If wkJoinFiles = *blanks;                                                      //0005
             wkFrmTableName = GetPhysicalFileTableName(                                  //0019
                udPhysicalFileDetails(wkPhysicalFileIdx).usJoinFrmLib :                  //0019
                udPhysicalFileDetails(wkPhysicalFileIdx).usJoinFrmFile);                 //0019
             wkJoinFiles =                                                               //0005
             %trim(wkFrmTableName) +                                                     //0019
             ' AS ' +                                                                    //0005
             'Q' + %char(udPhysicalFileDetails(wkPhysicalFileIdx).usJoinFrmNum)          //0005
             + ' ' + %trim(wkJoinVal) + ' ' +                                            //0005
             %trim(wkToTableName)                                                        //0019
             + ' AS ' +                                                                  //0005
             'Q' + %char(udPhysicalFileDetails(wkPhysicalFileIdx).usJoinToNum) +         //0005
             ' ON (' + 'Q' +                                                             //0005
             %char(udPhysicalFileDetails(wkPhysicalFileIdx).usJoinFrmNum) + '.' +        //0005
             %trim(udPhysicalFileDetails(wkPhysicalFileIdx).usJoinFrmField)              //0005
             + ' = ' +                                                                   //0005
             'Q' + %char(udPhysicalFileDetails(wkPhysicalFileIdx).usJoinToNum) +         //0005
             '.' +                                                                       //0005
             %trim(udPhysicalFileDetails(wkPhysicalFileIdx).usJoinToField)       ;       //0005
          Else;                                                                          //0005
             If wkJoinHldFile <>                                                         //0005
                %trim(wkToTableName);                                                    //0019
                wkJoinFiles     =  %trim(wkJoinFiles) + ')'+ ' ' +                       //0005
                %trim(wkJoinVal) + ' ' +                                                 //0005
                %trim(wkToTableName)                                                     //0019
                + ' AS ' + 'Q' +                                                         //0005
                %char(udPhysicalFileDetails(wkPhysicalFileIdx).usJoinToNum) +            //0005
                ' ON (' + 'Q' +                                                          //0005
                %char(udPhysicalFileDetails(wkPhysicalFileIdx).usJoinFrmNum)             //0005
                 + '.' +                                                                 //0005
                %trim(udPhysicalFileDetails(wkPhysicalFileIdx).usJoinFrmField)           //0005
                + ' = ' + 'Q' +                                                          //0005
                %char(udPhysicalFileDetails(wkPhysicalFileIdx).usJoinToNum)              //0005
                +'.' +                                                                   //0005
                %trim(udPhysicalFileDetails(wkPhysicalFileIdx).usJoinToField) ;          //0005
             Else;                                                                       //0005
             //Preparing Join statement when more than one field is used to join        //0005
                If udPhysicalFileDetails(wkPhysicalFileIdx).usJoinFrmField <> *Blanks;   //0007
                   wkJoinFiles     =  %trim(wkJoinFiles) +  ' And ' + 'Q' +              //0005
                   %char(udPhysicalFileDetails(wkPhysicalFileIdx).usJoinFrmNum)          //0005
                    + '.' +                                                              //0005
                   %trim(udPhysicalFileDetails(wkPhysicalFileIdx).usJoinFrmField)        //0005
                   + ' = ' + 'Q' +                                                       //0005
                   %char(udPhysicalFileDetails(wkPhysicalFileIdx).usJoinToNum)           //0005
                   +'.' +                                                                //0005
                   %trim(udPhysicalFileDetails(wkPhysicalFileIdx).usJoinToField) ;       //0005
                Endif;                                                                   //0007
             Endif;                                                                      //0005
          Endif;                                                                         //0005
          wkJoinHldFile =                                                                //0005
          %trim(wkToTableName);                                                          //0019
      EndFor;                                                                            //0005
      wkJoinFiles  = %trim(wkJoinFiles) + ')';                                           //0005
   Endif;                                                                                //0005
                                                                                         //0005
   //Close cursor                                                                       //0005
   Exec Sql Close CursorPhysicalFileDetails ;                                            //0005
                                                                                         //0005
End-Proc;                                                                                //0005
                                                                                         //0005
//------------------------------------------------------------------------------------- //0005
//FetchRecordCursorPhysicalFileDetails : Fetch Physical Files that are used to create   //0005
//                                       Join Logical File                              //0005
//------------------------------------------------------------------------------------- //0005
Dcl-Proc FetchRecordCursorPhysicalFileDetails ;                                          //0005
                                                                                         //0005
   Dcl-Pi FetchRecordCursorPhysicalFileDetails  Ind End-Pi;                              //0005
                                                                                         //0005
   Dcl-S  rcdFound Ind Inz('0');                                                         //0005
   Dcl-S  wkRowNum Like(RowsFetched) ;                                                   //0005
                                                                                         //0005
   RowsFetched = *zeros;                                                                 //0005
   Clear udPhysicalFileDetails ;                                                         //0005
                                                                                         //0005
   //Get the number of elements                                                         //0005
   wkJoinFileCount = %elem(udPhysicalFileDetails);                                       //0005
                                                                                         //0005
   Exec Sql                                                                              //0005
      Fetch CursorPhysicalFileDetails For :wkJoinFileCount Rows Into                     //0005
              :udPhysicalFileDetails;                                                    //0005
                                                                                         //0005
   If sqlCode < successCode;                                                             //0005
      uDpsds.wkQuery_Name = 'Fetch_PhysicalFileDetails';                                 //0005
      IaSqlDiagnostic(uDpsds);                                                           //0005
   EndIf;                                                                                //0005
                                                                                         //0005
   If sqlcode = successCode;                                                             //0005
      Exec Sql Get Diagnostics                                                           //0005
         :wkRowNum = ROW_COUNT;                                                          //0005
         RowsFetched  = wkRowNum ;                                                       //0005
   EndIf;                                                                                //0005
                                                                                         //0005
   If RowsFetched > 0;                                                                   //0005
      rcdFound = TRUE;                                                                   //0005
   ElseIf sqlcode < successCode ;                                                        //0005
      rcdFound = FALSE;                                                                  //0005
   EndIf;                                                                                //0005
                                                                                         //0005
   Return rcdFound;                                                                      //0005
                                                                                         //0005
End-Proc;                                                                                //0005
                                                                                         //0005
//------------------------------------------------------------------------------------- //0005
//GetJoinType : Get type of join logical file                                           //0005
//------------------------------------------------------------------------------------- //0005
Dcl-Proc GetJoinType;                                                                    //0005
   Dcl-Pi GetJoinType char(1) End-Pi;                                                    //0005
                                                                                         //0005
   Dcl-S  rtnJoinTyp char(1) Inz;                                                        //0005
                                                                                         //0005
   wkPgmNamLib = inDDSObjNam + inDDSLibrary ;                                            //0005
   IBMAPIRtvFileDesc(wkAPIVariable:                                                      //0005
                     %Size(wkAPIVariable):                                               //0005
                     wkRtnFileName:                                                      //0005
                     'FILD0100':                                                         //0005
                     wkPgmNamLib:                                                        //0005
                     '*FIRST':                                                           //0005
                     Override:                                                           //0005
                     System:                                                             //0005
                     Format:                                                             //0005
                     udSrvPgmInfEr);                                                     //0005
   rtnJoinTyp  = %subst(wkAPIVariable:432:1);                                            //0005
                                                                                         //0005
   Return rtnJoinTyp;                                                                    //0005
                                                                                         //0005
End-Proc;                                                                                //0005

//------------------------------------------------------------------------------------- //
//CreateEntriesForCompilation : To write entries into IADDSDDLDP                        //
//------------------------------------------------------------------------------------- //
Dcl-Proc CreateEntriesForCompilation;
   Dcl-Pi *n;
   End-Pi;

   //Stand-alone variable declaration
   Dcl-S uwMbrLb       Char(10);
   Dcl-S uwMbrScf      Char(10);
   Dcl-S uwMbrNm       Char(10);
   Dcl-S uwMbrTp       Char(10);
   Dcl-S uwObjType     Char(2) ;
   Dcl-S uwExists      Char(1) ;

   Select;
      When inDDSObjType = 'P';
         uwObjType = 'PF';
      When inDDSObjType = 'L';
         uwObjType = 'LF';
   EndSl;

   Exec Sql
      Update IADDSDDLDP Set iAUnqFlg   = :wkUnqFlg    ,                                  //0025
                            iAKeyFlg   = :wkFileKeyed ,                                  //0020
                            iAKeyIdxNm = :wkKeyIdxNm  ,
                            iAConvSts  = 'S'          ,
                            iAUpdPgm   = 'IADDSDDLSC' ,
                            iAUpdUser  = :inRequestedUser
                      Where iAReqId    = :inReqId
                        And iARepoNm   = :inRepo
                        And iADdsObjLb = :inDDSLibrary
                        And iADdsObjNm = :inDDSObjNam
                        And iADdsObjTy = '*FILE'
                        And iADdsObjAt = :uwObjType                                      //0023
                        And iADdsMbrNm = :inDDSMbrName                                   //0023
                        And iADdsRcdFm = :inDDSRcdFmt;                                   //0023

   If SqlCode < successCode;
      uDpsds.wkQuery_Name = 'Update_IADDSDDLDP';
      IaSqlDiagnostic(uDpsds);
   EndIf;

End-Proc;

//------------------------------------------------------------------------------------- //
//GetNextFileIndexSequence : Get Next File Index Sequence                               //
//------------------------------------------------------------------------------------- //
Dcl-Proc GetNextFileIndexSequence;
   Dcl-Pi *N;
   End-Pi;

   Dcl-S lSrchIdxName Char(10) Inz;
   Dcl-S lLastIdxName Char(10) Inz;
   Dcl-S lNextIdxSeq  Packed(3:0) Inz(1);
   Dcl-S lFileIdxLen  Packed(2:0) Inz(0);

   lFileIdxLen  = %Len(%Trim(wkIndexName));
   lSrchIdxName = %Trim(wkIndexName) + '%';

   Exec Sql
      Select iAKeyIdxNm into : lLastIdxName
        From iADdsDdlDP
       Where iADdlObjLb = :inDDLObjLib
         And iAKeyIdxNm <> ' '
         And iAKeyIdxNm Like Trim(:lSrchIdxName)
             Order by iAKeyIdxNm Desc
             Fetch First Row Only;

   If SqlCode = successCode;
      Monitor;
         lNextIdxSeq = %Int(%Trim(%SubSt(lLastIdxName : lFileIdxLen + 1))) + 1;
      On-Error;
      EndMon;
   EndIf;

   wkIndexName = %Trim(wkIndexName) + %Editc(lNextIdxSeq : 'X');

End-Proc;

//------------------------------------------------------------------------------------- //
//LoadSelectOmitCondition : Load the Select/Omit Condition                              //
//------------------------------------------------------------------------------------- //
Dcl-Proc LoadSelectOmitCondition;                                                        //0010
                                                                                         //0010
   //Local Variables                                                                    //0010
   Dcl-S wkSlOmRule   Char(1)       Inz;                                                 //0010
   Dcl-S wkSlOmSel    Char(1)       Inz;                                                 //0010
   Dcl-S wkSlOmSelNxt Char(1)       Inz;                                                 //0015

   Dcl-S wkOperator   VarChar(2)    Inz;                                                 //0010
   Dcl-S wkCondition  VarChar(1024) Inz;                                                 //0010
   Dcl-S wkSlOmStr    VarChar(1024) Inz;                                                 //0010
   Dcl-S wkSlOmFldVal VarChar(1024) Inz;                                                 //0013
   Dcl-S wkSlOmDec    VarChar(1024) Inz;                                                 //0013

   Dcl-S wkOmitSelCnt Packed(4:0)   Inz;                                                 //0015
   Dcl-S wkExistIdx   Packed(4:0)   Inz;                                                 //0015
   Dcl-S wkLen        Packed(3:0)   Inz;                                                 //0013
   Dcl-S wkDecLen     Packed(3:0)   Inz;                                                 //0013

   Dcl-S wkRowFound   Ind           Inz('0');                                            //0010
   Dcl-S wkSlOmNext   Ind           Inz(*Off);                                           //0015
   Dcl-S wkSlOmAdnl   Ind           Inz(*Off);                                           //0015
                                                                                         //0010
   Clear wkCondition;                                                                    //0010
   Clear wkSlOmStr;                                                                      //0010
   Clear wkSlOmStart;                                                                    //0010
   Clear wkSlOmEnd;                                                                      //0010
   Clear wkSourceMapping;                                                                //0010
                                                                                         //0010
   //Open LoadSelectOmitCondition Cursor                                                //0010
   Exec Sql Open CursorSelectOmitCondition;                                              //0010
   If sqlCode = CSR_OPN_COD;                                                             //0010
      Exec Sql Close CursorSelectOmitCondition;                                          //0010
      Exec Sql Open  CursorSelectOmitCondition;                                          //0010
   EndIf;                                                                                //0010
                                                                                         //0010
   If sqlCode < successCode;                                                             //0010
      uDpsds.wkQuery_Name = 'Open_SelectOmitCondition';                                  //0010
      IaSqlDiagnostic(uDpsds);                                                           //0010
   EndIf;                                                                                //0010
                                                                                         //0010
   wkRowFound = FetchSelectOmitCondition();                                              //0010
                                                                                         //0010
   wkSlOmIdx = 1;                                                                        //0010
   wkSlOmRule = udSelectOmitCondition(1).usSlOmRule;                                     //0010
                                                                                         //0010
   If wkRowFound;                                                                        //0010
      For wkNoOfSlOmRules = 1 To wkNoOfSlOmLine;                                         //0010
         If wkJoinFlg = 'Y';                                                             //0010
          udSelectOmitCondition(wkNoOfSlOmRules).usSlOmField =                           //0010
             'q' + %Char(udSelectOmitCondition(wkNoOfSlOmRules).usSlOmJrefValues) +      //0010
             '.' + udSelectOmitCondition(wkNoOfSlOmRules).usSlOmField;                   //0010
         EndIf;                                                                          //0010
         //Convert field name to lower case                                             //0010
         udSelectOmitCondition(wkNoOfSlOmRules).usSlOmField = %Xlate(UPPER:LOWER         //0010
                                  :udSelectOmitCondition(wkNoOfSlOmRules).usSlOmField);  //0010
      EndFor;                                                                            //0010
                                                                                         //0010
      wkSlOmStart = ddlSrcDtaIdx + 1;                                                    //0010
                                                                                         //0010
      //Process all the number of select/omit rules                                     //0010
      For wkNoOfSlOmRules = 1 To udSelectOmitCondition(1).usNoOfSlOmRules - 1;           //0010
         //If no Fields are there for select Omit in case of Multi Record Format        //0023
         If udSelectOmitCondition(wkNoOfSlOmRules).usSlOmField = *Blanks;                //0023
            Leave;                                                                       //0023
         EndIf;                                                                          //0023

         Clear wkCondition;                                                              //0010
         wkSlOmNext = *Off;                                                              //0015
         wkSlOmSel = udSelectOmitCondition(wkSlOmIdx).usSlOmRule;                        //0013
         If udSelectOmitCondition(wkSlOmIdx).usSlOmComp = 'VA';                          //0010
            ExSr fieldMap;                                                               //0013
            wkCondition = %Trim(udSelectOmitCondition(wkSlOmIdx).usSlOmField);           //0013
            If wkSlOmSel = 'O' or (wkSlOmRule = 'O' and wkSlOmSel = 'A');                //0014
               wkCondition = wkCondition + ' not';                                       //0014
            EndIf;                                                                       //0014
            wkCondition = wkCondition + ' in(' + wkSlOmFldVal;                           //0013
            wkSlOmIdx += 1;                                                              //0010
            For wkNoOfSlOmValues = 2 To                                                  //0010
                udSelectOmitCondition(wkSlOmIdx-1).usNoOfSlOmValues;                     //0013
                ExSr fieldMap;                                                           //0013
                wkCondition = wkCondition + ', ' + wkSlOmFldVal;                         //0013
                wkSlOmIdx += 1;                                                          //0010
            EndFor;                                                                      //0010
            wkCondition += ')';                                                          //0010
         Else;                                                                           //0010
            ExSr mapComparison;                                                          //0010
            ExSr fieldMap;                                                               //0014
            wkCondition = %Trim(udSelectOmitCondition(wkSlOmIdx).usSlOmField) + ' ' +    //0010
                         wkOperator + ' ' + wkSlOmFldVal;                                //0013
            wkSlOmIdx += 1;                                                              //0010
         EndIf;                                                                          //0010
         wkSlOmSelNxt = udSelectOmitCondition(wkSlOmIdx).usSlOmRule;                     //0015
         ExSr chkNextSlOmExist;                                                          //0015
         ExSr mapSlOm;                                                                   //0010
      EndFor;                                                                            //0010
                                                                                         //0010
      wkSlOmEnd = ddlSrcDtaIdx;                                                          //0010
                                                                                         //0010
   EndIf;                                                                                //0010
                                                                                         //0010
   //Close cursor                                                                       //0010
   Exec Sql Close CursorSelectOmitCondition;                                             //0010
                                                                                         //0010
   //---------------------------------------------------------------------------------- //0013
   //Map Select/Omit field                                                              //0013
   //---------------------------------------------------------------------------------- //0013
   BegSr fieldMap;                                                                       //0013

      Clear wkSlOmFldVal;                                                                //0013
      Clear wkSlOmDec;                                                                   //0013

      wkLen = udSelectOmitCondition(wkSlOmIdx).usSlOmValueLength;                        //0013
      wkDecLen = udSelectOmitCondition(wkSlOmIdx).usSlOmJrefParmNo;                      //0013

      Select;                                                                            //0013
         When %Subst(udSelectOmitCondition(wkSlOmIdx).usSlOmValue:1:1) = '+';            //0013
            If wkDecLen = 0;                                                             //0013
               wkSlOmFldVal =                                                            //0013
                  %Trim(%Subst(udSelectOmitCondition(wkSlOmIdx).usSlOmValue:2));         //0013
            Else;                                                                        //0013
               wkSlOmFldVal =                                                            //0013
                  %Trim(%Subst(udSelectOmitCondition(wkSlOmIdx).usSlOmValue:2:           //0013
                  wkLen-1-wkDecLen));                                                    //0013
               wkSlomDec =                                                               //0013
                  %TrimR(%Subst(udSelectOmitCondition(wkSlOmIdx).usSlOmValue:            //0013
                           wkLen+1-wkDecLen:wkDecLen):'0');                              //0013
               If wkSlOmDec <> *Blanks;                                                  //0013
                  wkSlOmFldVal = wkSlOmFldVal + '.' + wkSlOmDec;                         //0013
               EndIf;                                                                    //0013
            EndIf;                                                                       //0013
         When %Subst(udSelectOmitCondition(wkSlOmIdx).usSlOmValue:1:1) = SQUOTE;         //0013
            wkSlOmFldVal = SQUOTE +                                                      //0013
              %Trim(udSelectOmitCondition(wkSlOmIdx).usSlOmValue) + SQUOTE;              //0013
         When %Subst(udSelectOmitCondition(wkSlOmIdx).usSlOmValue:1:1) = '-';            //0013
            If wkDecLen = 0;                                                             //0013
               wkSlOmFldVal =                                                            //0013
                  %Trim(udSelectOmitCondition(wkSlOmIdx).usSlOmValue);                   //0013
            Else;                                                                        //0013
               wkSlOmFldVal =                                                            //0013
                   %Trim(%Subst(udSelectOmitCondition(wkSlOmIdx).usSlOmValue:1:          //0013
                   wkLen-wkDecLen));                                                     //0013
               wkSlomDec =                                                               //0013
                  %TrimR(%Subst(udSelectOmitCondition(wkSlOmIdx).usSlOmValue:            //0013
                  wkLen+1-wkDecLen:wkDecLen):'0');                                       //0013
               If wkSlOmDec <> *Blanks;                                                  //0013
                  wkSlOmFldVal = wkSlOmFldVal + '.' + wkSlOmDec;                         //0013
               EndIf;                                                                    //0013
            EndIf;                                                                       //0013
         Other;                                                                          //0013
            wkSlomFldVal =                                                               //0013
               %Trim(udSelectOmitCondition(wkNoOfSlOmRules).usSlOmValue);                //0013
                                                                                         //0013
      EndSl;                                                                             //0013

   EndSr;                                                                                //0013

   //---------------------------------------------------------------------------------- //0010
   //Map Comparison Codes to Relational Operator                                        //0010
   //---------------------------------------------------------------------------------- //0010
   BegSr mapComparison;                                                                  //0010
                                                                                         //0010
      Select;                                                                            //0010
         When udSelectOmitCondition(wkSlOmIdx).usSlOmComp = 'EQ';                        //0010
            wkOperator = '=';                                                            //0010
            If wkSlOmSel = 'O' or (wkSlOmRule = 'O' and wkSlOmSel = 'A');                //0014
               wkOperator = '<>';                                                        //0014
            EndIf;                                                                       //0014
         When udSelectOmitCondition(wkSlOmIdx).usSlOmComp = 'NE';                        //0010
            wkOperator = '<>';                                                           //0010
            If wkSlOmSel = 'O' or (wkSlOmRule = 'O' and wkSlOmSel = 'A');                //0014
               wkOperator = '=';                                                         //0014
            EndIf;                                                                       //0014
         When udSelectOmitCondition(wkSlOmIdx).usSlOmComp = 'LT';                        //0010
            wkOperator = '<';                                                            //0010
            If wkSlOmSel = 'O' or (wkSlOmRule = 'O' and wkSlOmSel = 'A');                //0014
               wkOperator = '>=';                                                        //0014
            EndIf;                                                                       //0014
         When udSelectOmitCondition(wkSlOmIdx).usSlOmComp = 'NL';                        //0010
            wkOperator = '>=';                                                           //0010
            If wkSlOmSel = 'O' or (wkSlOmRule = 'O' and wkSlOmSel = 'A');                //0014
               wkOperator = '<';                                                         //0014
            EndIf;                                                                       //0014
         When udSelectOmitCondition(wkSlOmIdx).usSlOmComp = 'GT';                        //0010
            wkOperator = '>';                                                            //0010
            If wkSlOmSel = 'O' or (wkSlOmRule = 'O' and wkSlOmSel = 'A');                //0014
               wkOperator = '<=';                                                        //0014
            EndIf;                                                                       //0014
         When udSelectOmitCondition(wkSlOmIdx).usSlOmComp = 'NG';                        //0010
            wkOperator = '<=';                                                           //0010
            If wkSlOmSel = 'O' or (wkSlOmRule = 'O' and wkSlOmSel = 'A');                //0014
               wkOperator = '>';                                                         //0014
            EndIf;                                                                       //0014
         When udSelectOmitCondition(wkSlOmIdx).usSlOmComp = 'LE';                        //0010
            wkOperator = '<=';                                                           //0010
            If wkSlOmSel = 'O' or (wkSlOmRule = 'O' and wkSlOmSel = 'A');                //0014
               wkOperator = '>';                                                         //0014
            EndIf;                                                                       //0014
         When udSelectOmitCondition(wkSlOmIdx).usSlOmComp = 'GE';                        //0010
            wkOperator = '>=';                                                           //0010
            If wkSlOmSel = 'O' or (wkSlOmRule = 'O' and wkSlOmSel = 'A');                //0014
               wkOperator = '<';                                                         //0014
            EndIf;                                                                       //0014
         Other;                                                                          //0010
      EndSl;                                                                             //0010
                                                                                         //0010
   EndSr;                                                                                //0010
                                                                                         //0010
   //---------------------------------------------------------------------------------- //0010
   //Map Select/Omit                                                                    //0010
   //---------------------------------------------------------------------------------- //0010
   BegSr mapSlOm;                                                                        //0010

      Clear wkSlOmStr;                                                                   //0015
      If wkSlOmRule = 'O';                                                               //0015
         Select;                                                                         //0015
            When wkNoOfSlOmRules = 1;                                                    //0015
               wkSlOmStr = 'where ';                                                     //0015
               If wkSlOmSelNxt = 'A' and wkSlOmNext;                                     //0015
                  wkSlOmAdnl = *On;
                  wkSlOmStr = wkSlOmStr + '(';                                           //0015
               EndIf;                                                                    //0015
               wkSlOmStr = wkSlOmStr + wkCondition;                                      //0015
            When wkSlOmSel = 'O';                                                        //0015
               wkSlOmStr = '  and ';                                                     //0015
               If wkSlOmSelNxt = 'A';                                                    //0015
                  wkSlOmAdnl = *On;
                  wkSlOmStr = wkSlOmStr + '(';                                           //0015
               EndIf;                                                                    //0015
               wkSlOmStr = wkSlOmStr + wkCondition;                                      //0015
            When wkSlOmSel = 'S';                                                        //0015
               wkSlOmStr = '  and ';
               If wkSlOmSelNxt <> ' ';
                  wkSlOmStr = wkSlOmStr + '(';                                           //0015
                  wkOmitSelCnt += 1;                                                     //0015
               EndIf;
               If wkSlOmSelNxt = 'A' and wkSlOmNext;                                     //0015
                  wkSlOmAdnl = *On;
                  wkSlOmStr = wkSlOmStr + '(';                                           //0015
               EndIf;                                                                    //0015
               wkSlOmStr = wkSlOmStr + wkCondition;                                      //0015
               wkSlOmRule = 'S';                                                         //0015
            When wkSlOmSel = 'A';                                                        //0015
               wkSlOmStr = '   or ' + wkCondition;                                       //0015
               If wkSlOmSelNxt <> 'A' and wkSlOmAdnl;                                    //0015
                  wkSlOmAdnl = *Off;
                  wkSlOmStr = wkSlOmStr + ')';                                           //0015
               EndIf;                                                                    //0015
            Other;                                                                       //0015
         EndSl;                                                                          //0015
      ElseIf wkSlOmRule = 'S';                                                           //0015
         Select;                                                                         //0015
            When wkNoOfSlOmRules = 1;                                                    //0015
               wkSlOmStr = 'where ';                                                     //0015
               If wkSlOmSelNxt = 'A' and wkSlOmNext;                                     //0015
                  wkSlOmAdnl = *On;
                  wkSlOmStr = wkSlOmStr + '(';                                           //0015
               EndIf;                                                                    //0015
               wkSlOmStr = wkSlOmStr + wkCondition;                                      //0015
            When wkSlOmSel = 'O';                                                        //0015
               wkSlOmStr = '   or ';                                                     //0015
               If wkSlOmSelNxt = 'A';                                                    //0015
                  wkSlOmAdnl = *On;
                  wkSlOmStr = wkSlOmStr + '(';                                           //0015
               EndIf;                                                                    //0015
               wkSlOmStr += wkCondition;                                                 //0015
               wkSlOmRule = 'O';                                                         //0015
            When wkSlOmSel = 'S';                                                        //0015
               wkSlOmStr = '   or ';                                                     //0015
               If wkSlOmSelNxt = 'A';                                                    //0015
                  wkSlOmAdnl = *On;
                  wkSlOmStr = wkSlOmStr + '(';                                           //0015
               EndIf;                                                                    //0015
               wkSlOmStr += wkCondition;                                                 //0015
            When wkSlOmSel = 'A';                                                        //0015
               wkSlOmStr = '  and ' + wkCondition;                                       //0015
               If wkSlOmSelNxt <> 'A' and  wkSlOmAdnl;                                   //0015
                  wkSlOmAdnl = *Off;
                  wkSlOmStr = wkSlOmStr + ')';                                           //0015
               EndIf;                                                                    //0015
            Other;                                                                       //0015
         EndSl;                                                                          //0015
      EndIf;                                                                             //0015

      If wkOmitSelCnt > 0 and wkSlOmSelNxt = ' ';                                        //0015
         DoW wkOmitSelCnt > 0;                                                           //0015
            wkSlOmStr = wkSlOmStr + ')';                                                 //0015
            wkOmitSelCnt -= 1;                                                           //0015
         EndDo;                                                                          //0015
      EndIf;                                                                             //0015
      ExSr LoadSelectOmitDtaArray;                                                       //0015
                                                                                         //0010
   EndSr;                                                                                //0010
                                                                                         //0010
   //---------------------------------------------------------------------------------- //0015
   //Load Select Omit Condition to data array                                           //0015
   //---------------------------------------------------------------------------------- //0015
   BegSr chkNextSlOmExist;                                                               //0015

      For wkExistIdx = wkSlOmIdx + 1 to wkNoOfSlOmLine;                                  //0015
         If udSelectOmitCondition(wkExistIdx).usSlOmRule = 'O' or                        //0015
            udSelectOmitCondition(wkExistIdx).usSlOmRule = 'S';                          //0015
            wkSlOmNext = *On;                                                            //0015
            Leave;                                                                       //0015
         EndIf;                                                                          //0015
      EndFor;                                                                            //0015

   EndSr;                                                                                //0015

   //---------------------------------------------------------------------------------- //0010
   //Load Select Omit Condition to data array                                           //0010
   //---------------------------------------------------------------------------------- //0010
   BegSr LoadSelectOmitDtaArray;                                                         //0010
                                                                                         //0010
      wkSourceMapping = wkSlOmStr;                                                       //0010
      LoadDDLSrcDtaArray();                                                              //0010
      Clear wkSlOmStr;                                                                   //0010
      Clear wkSourceMapping;                                                             //0010
                                                                                         //0010
   EndSr;                                                                                //0010
                                                                                         //0010
End-Proc;                                                                                //0010
                                                                                         //0010
//------------------------------------------------------------------------------------- //0010
//FetchSelectOmitCondition : To fetch the select/omit condition of file                 //0010
//------------------------------------------------------------------------------------- //0010
Dcl-Proc FetchSelectOmitCondition;                                                       //0010
                                                                                         //0010
   Dcl-Pi FetchSelectOmitCondition Ind End-Pi;                                           //0010
                                                                                         //0010
   Dcl-S  rcdFound Ind Inz('0');                                                         //0010
   Dcl-S  wkRowNum Like(RowsFetched) ;                                                   //0010
                                                                                         //0010
   RowsFetched = *Zeros;                                                                 //0010
   Clear udSelectOmitCondition;                                                          //0010
                                                                                         //0010
   //Get the number of elements                                                         //0010
   wkSlOmRecordCount = %elem(udSelectOmitCondition);                                     //0010
                                                                                         //0010
   Exec Sql                                                                              //0010
      Fetch CursorSelectOmitCondition For :wkSlOmRecordCount Rows Into                   //0010
              :udSelectOmitCondition;                                                    //0010
                                                                                         //0010
   If sqlCode < successCode;                                                             //0010
      uDpsds.wkQuery_Name = 'Fetch_SelectOmitCondition';                                 //0010
      IaSqlDiagnostic(uDpsds);                                                           //0010
   EndIf;                                                                                //0010
                                                                                         //0010
   If sqlcode = successCode;                                                             //0010
      Exec Sql Get Diagnostics                                                           //0010
         :wkRowNum = ROW_COUNT;                                                          //0010
         wkNoOfSlOmLine = wkRowNum ;                                                     //0010
   EndIf;                                                                                //0010
                                                                                         //0010
   If wkNoOfSlOmLine > 0;                                                                //0010
      rcdFound = TRUE;                                                                   //0010
   ElseIf sqlcode < successCode ;                                                        //0010
      rcdFound = FALSE;                                                                  //0010
   EndIf;                                                                                //0010
                                                                                         //0010
   Return rcdFound;                                                                      //0010
                                                                                         //0010
End-Proc;                                                                                //0010

//------------------------------------------------------------------------------------- //0018
//CheckPfLfFileFieldOrder - Check if PF and LF files has fields defined                 //0018
//                          in the same order                                           //0018
//------------------------------------------------------------------------------------- //0018
Dcl-Proc CheckPfLfFileFieldOrder;                                                        //0018
                                                                                         //0018
   Dcl-Pi CheckPfLfFileFieldOrder  End-Pi;                                               //0018
                                                                                         //0018
   wkFieldIdx =  1;                                                                      //0018
   If udPfFieldSrc(wkFieldIdx).usRcdFmtLen =                                             //0018
      udDDLFldSrc(wkFieldIdx).usRcdFmtLen;                                               //0018
      For wkFieldIdx = 1 to physicalFileFieldCount;                                      //0018
         If udPfFieldSrc(wkFieldIdx).usFieldNameInternal <>                              //0018
            udDDLFldSrc(wkFieldIdx).usFieldNameInternal;                                 //0018
            wkAllFieldSelect = 'N';                                                      //0018
            Leave;                                                                       //0018
         EndIf;                                                                          //0018
      EndFor;                                                                            //0018
   Else;                                                                                 //0018
      wkAllFieldSelect = 'N';                                                            //0018
   Endif;                                                                                //0018
                                                                                         //0018
   Return;                                                                               //0018
                                                                                         //0018
End-Proc;                                                                                //0018
                                                                                         //0018
//------------------------------------------------------------------------------------- //0019
//GetPhysicalFileTableName : Get the Converted Physical File Table Name                 //0019
//------------------------------------------------------------------------------------- //0019
Dcl-Proc GetPhysicalFileTableName;                                                       //0019
   Dcl-Pi *N Char(10);
      pFileLib  Char(10);
      pFileName Char(10);
   End-Pi;

   //Local Variable                                                                     //0023
   Dcl-S  uwPfMbrName Char(10) Inz;                                                      //0023

   //Get Physical File Member Name Linked to Logical File                               //0023
   Exec Sql                                                                              //0023
      Select MBBOM Into :uwPfMbrName                                                     //0023
        From iDspFdMbr                                                                   //0023
       Where MBBOL  = :pFileLib                                                          //0023
         And MBBOF  = :pFileName                                                         //0023
         And MBLib  = :inDDSLibrary                                                      //0023
         And MBFile = :inDDSObjNam                                                       //0023
         And MBName = :inDDSMbrName                                                      //0023
         And (MBBOLF = :inDDSRcdFmt                                                      //0023
          Or MBBOLF = ' ')                                                               //0023
       Fetch First Row Only;                                                             //0023

   Exec Sql
      Select iADdlObjNm into :wkTableName
        From iADdsDdlDP
       Where iADdsObjLb = :pFileLib
         And iADdsObjNm = :pFileName
         And iADdsMbrNm = :uwPfMbrName                                                   //0023
         And iADdsSrcAt = 'PF'
         And iADdlObjLb = :inDDLObjLib
         And iAConvSts  = 'S'
             Order by iACrtTime Desc
             Fetch First Row Only;

   If SqlCode = successCode and wkTableName <> *Blanks;
      Return wkTableName;
   Else;
      Return pFileName;
   EndIf;

End-Proc;                                                                                //0019

//------------------------------------------------------------------------------------- //
//GetDDSSrcInfo : Get DDS Source Member Information                                     //
//------------------------------------------------------------------------------------- //
Dcl-Proc GetDDSSrcInfo;                                                                  //0022

   Clear udObjMapDs;

   //Get the Source Details from IAOBJMAP
   Exec Sql
      Select iAMbrLib, iAMbrSrcf, iAMbrNam, iaMbrTyp
        into :udObjMapDs
        from iAObjMap
       Where iAObjLib = :inDDSLibrary
         And iAObjNam = :inDDSObjNam
         And iAObjTyp = :wkObjType
         And iAObjAtr in ('PF' , 'LF');

   //Get the Member Description from IAMEMBER
   Exec Sql
      Select iAMbrDsc into :wkDDSSrcTxt
        from iAMember
       Where iASrcLib   = :udObjMapDs.usMbrLib
         And iASrcPfNam = :udObjMapDs.usMbrSrcf
         And iAMbrNam   = :udObjMapDs.usMbrNam
         And iAMbrType  = :udObjMapDs.usMbrTyp;

   Exec Sql Values(Replace(:wkDDSSrcTxt,:SQuote,:DSQuote))
      Into :wkDDSSrcTxt;

   Exec Sql
      Select iATxtDes into :wkDDSObjTxt
        From iAObject
       Where iALibNam = :inDDSLibrary
         and iAObjNam = :inDDSObjNam
         and iAObjTyp = :wkObjType
         and iAObjAtr in ('PF','LF');

   Exec Sql Values(Replace(:wkDDSObjTxt,:SQuote,:QSquote))
      Into :wkDDSObjTxt;

   If wkDDSObjTxt <> *Blanks;
      lblTxtFound = *On;
   EndIf;

End-Proc;                                                                                //0022

//------------------------------------------------------------------------------------- //0023
//GenerateDDStoDDLforMultiFile :Generate DDL for Multi Record Format & Multi Member File//0023
//------------------------------------------------------------------------------------- //0023
Dcl-Proc GenerateDDStoDDLforMultiFile;                                                   //0023

   //Local Variable                                                                     //0023
   Dcl-S  uwUnionFlg Ind Inz(*Off);                                                      //0023

   Clear wkSourceMapping;                                                                //0023
   If inDDLLngNam <> *Blanks And inDDLObjNam <> inDDLLngNam;                             //0023
      wkSourceMapping = 'CREATE OR REPLACE VIEW ' + %Trim(inDDLLngNam) + ' AS';          //0023
   Else;                                                                                 //0023
      wkSourceMapping = 'CREATE OR REPLACE VIEW ' + %Trim(inDDLObjNam) + ' AS';          //0023
   EndIf;                                                                                //0023
   LoadDDLSrcDtaArray();                                                                 //0023
   Clear wkSourceMapping;                                                                //0023

   //Open cursor                                                                        //0023
   Exec Sql Open CursorMultiFile;                                                        //0023
   If sqlCode = CSR_OPN_COD;                                                             //0023
      Exec Sql Close CursorMultiFile;                                                    //0023
      Exec Sql Open  CursorMultiFile;                                                    //0023
   EndIf;                                                                                //0023

   If sqlCode < successCode;                                                             //0023
      uDpsds.wkQuery_Name = 'Open_CursorMultiFile';                                      //0023
      IaSqlDiagnostic(uDpsds);                                                           //0023
   EndIf;                                                                                //0023

   //Get the number of elements                                                         //0023
   uwNoOfObj = %elem(udMultiFileDs);                                                     //0023

   //Fetch records from CursorMultiFile                                                 //0023
   rowFound = FetchCursorMultiFile();                                                    //0023

   DoW rowFound;                                                                         //0023
      For uiMultiFileIdx = 1 To ObjectFetched;                                           //0023
         If uiMultiFileIdx > 1 or uwUnionFlg;                                            //0023
            Clear wkSourceMapping;                                                       //0023
            uwUnionFlg = *On;                                                            //0023
            wkSourceMapping = %TrimR(wkSourceMapping) + 'UNION';                         //0023
            LoadDDLSrcDtaArray();                                                        //0023
            Clear wkSourceMapping;                                                       //0023
         EndIf;                                                                          //0023
         wkSourceMapping = 'SELECT * FROM ' +                                            //0023
                           %Trim(udMultiFileDs(uiMultiFileIdx).usObjName);               //0023
         LoadDDLSrcDtaArray();                                                           //0023
      EndFor;                                                                            //0023

      //If fetched rows are less than the array elements then come out of the loop.     //0023
      If ObjectFetched < uwNoOfObj;                                                      //0023
         Leave ;                                                                         //0023
      EndIf ;                                                                            //0023

      //Fetched next set of rows.                                                       //0023
      rowFound = FetchCursorMultiFile();                                                 //0023

   EndDo;                                                                                //0023

   wkRecordFormat = inDDSRcdFmt;                                                         //0023
   LoadDDLSourceMapDetails('BLANKS');                                                    //0023
   LoadDDLSourceMapDetails('RCDFMTCMNT');                                                //0023
   LoadDDLSourceMapDetails('RCDFMT');                                                    //0023
   LoadDDLSourceMapDetails('BLANKS');                                                    //0023
   If inDDLLngNam <> *Blanks And inDDLObjNam <> inDDLLngNam;                             //0023
      LoadDDLSourceMapDetails('RNMTBLCMNT');                                             //0023
      LoadDDLSourceMapDetails('RNMTBL');                                                 //0023
      LoadDDLSourceMapDetails('BLANKS');                                                 //0023
      //Skip rename index when rename table already happened                            //0023
      Clear inDDLLngNam;                                                                 //0023
   EndIf;                                                                                //0023
   If lblTxtFound;                                                                       //0023
      LoadDDLSourceMapDetails('LBLVWCMNT');                                              //0023
      LoadDDLSourceMapDetails('LBLVIEW');                                                //0023
      LoadDDLSourceMapDetails('BLANKS');                                                 //0023
   EndIf;                                                                                //0023

   //Close Cursor CursorMultiFile                                                       //0023
   Exec Sql Close CursorMultiFile;                                                       //0023

   //Write the generated source to DDL member                                           //0023
   WriteDDLMember();                                                                     //0023

End-Proc;                                                                                //0023

//------------------------------------------------------------------------------------- //0023
//FetchCursorMultiFile : To fetch all multi record format or multi member file created  //0023
//------------------------------------------------------------------------------------- //0023
Dcl-Proc FetchCursorMultiFile;                                                           //0023

   Dcl-Pi *N Ind End-Pi ;                                                                //0023

   Dcl-S  rcdFound Ind Inz('0');                                                         //0023
   Dcl-S  wkRowNum Uns(5);                                                               //0023

   ObjectFetched = *Zeros;                                                               //0023
   Clear udMultiFileDs;                                                                  //0023

   Exec Sql                                                                              //0023
      Fetch CursorMultiFile For :uwNoOfObj Rows Into :udMultiFileDs;                     //0023

   If sqlCode < successCode;                                                             //0023
      uDpsds.wkQuery_Name = 'Fetch_CursorMultiFile';                                     //0023
      IaSqlDiagnostic(uDpsds);                                                           //0023
   EndIf;                                                                                //0023

   If sqlcode = successCode;                                                             //0023
      Exec Sql Get Diagnostics                                                           //0023
         :wkRowNum = ROW_COUNT;                                                          //0023
         ObjectFetched = wkRowNum ;                                                      //0023
   EndIf;                                                                                //0023

   If ObjectFetched > 0;                                                                 //0023
      rcdFound = TRUE;                                                                   //0023
   ElseIf sqlcode < successCode ;                                                        //0023
      rcdFound = FALSE;                                                                  //0023
   EndIf;                                                                                //0023

   Return rcdFound;                                                                      //0023

End-Proc;                                                                                //0023

//------------------------------------------------------------------------------------- //0023
//GenerateDDStoDDLforMultiMbr : To generate DDL for LF member which depend more than    //0023
//                              one member of PF file                                   //0023
//------------------------------------------------------------------------------------- //0023
Dcl-Proc GenerateDDStoDDLforMultiMbr;                                                    //0023

   //Local Variable                                                                     //0023
   Dcl-S  uwUnionFlg Ind      Inz(*Off);                                                 //0023
   Dcl-S  uwLib      Char(10) Inz;                                                       //0023
   Dcl-S  uwObj      Char(10) Inz;                                                       //0023
   Dcl-S  uwMbr      Char(10) Inz;                                                       //0023
   Dcl-S  wkIndex    Uns(5)   Inz;                                                       //0023

   Clear wkSourceMapping;                                                                //0023
   If inDDLLngNam <> *Blanks And inDDLObjNam <> inDDLLngNam;                             //0023
      wkSourceMapping = 'CREATE OR REPLACE VIEW ' + %Trim(inDDLLngNam) + ' AS';          //0023
   Else;                                                                                 //0023
      wkSourceMapping = 'CREATE OR REPLACE VIEW ' + %Trim(inDDLObjNam) + ' AS';          //0023
   EndIf;                                                                                //0023
   LoadDDLSrcDtaArray();                                                                 //0023
   Clear wkSourceMapping;                                                                //0023

   //Open cursor                                                                        //0023
   Exec Sql Open CursorMultiMbr;                                                         //0023
   If sqlCode = CSR_OPN_COD;                                                             //0023
      Exec Sql Close CursorMultiMbr;                                                     //0023
      Exec Sql Open  CursorMultiMbr;                                                     //0023
   EndIf;                                                                                //0023

   If sqlCode < successCode;                                                             //0023
      uDpsds.wkQuery_Name = 'Open_CursorMultiMbr';                                       //0023
      IaSqlDiagnostic(uDpsds);                                                           //0023
   EndIf;                                                                                //0023

   //Get the number of elements                                                         //0023
   uwNoOfObj = %elem(udMultiMbrDs);                                                      //0023

   //Fetch records from CursorMultiMbr                                                  //0023
   rowFound = FetchCursorMultiMbr();                                                     //0023

   DoW rowFound;                                                                         //0023
      For uiMultiMbrIdx = 1 To ObjectFetched;                                            //0023
         If uiMultiMbrIdx > 1 or uwUnionFlg;                                             //0023
            Clear wkSourceMapping;                                                       //0023
            uwUnionFlg = *On;                                                            //0023
            wkSourceMapping = %TrimR(wkSourceMapping) + 'UNION';                         //0023
            LoadDDLSrcDtaArray();                                                        //0023
            Clear wkSourceMapping;                                                       //0023
         EndIf;                                                                          //0023

         uwLib = udMultiMbrDs(uiMultiMbrIdx).usPFLib;                                    //0023
         uwObj = udMultiMbrDs(uiMultiMbrIdx).usPFObj;                                    //0023
         uwMbr = udMultiMbrDs(uiMultiMbrIdx).usPFMbr;                                    //0023

         Exec Sql                                                                        //0023
            Select iADdlObjNm into :wkTableName                                          //0023
              From iADdsDdlDP                                                            //0023
             Where iADdsObjLb = :uwLib                                                   //0023
               And iADdsObjNm = :uwObj                                                   //0023
               And iADdsMbrNm = :uwMbr                                                   //0023
               And iADdsSrcAt = 'PF'                                                     //0023
               And iADdlObjLb = :inDDLObjLib                                             //0023
               And iAConvSts  = 'S'                                                      //0023
             Fetch First Row Only;                                                       //0023

         If wkAllFieldSelect = 'Y';                                                      //0023
            wkSourceMapping = 'SELECT * FROM ' + %Trim(wkTableName);                     //0023
            LoadDDLSrcDtaArray();                                                        //0023
            Clear wkSourceMapping;                                                       //0023
         EndIf;                                                                          //0023

         If wkAllFieldSelect = 'N';                                                      //0023
            wkSourceMapping = 'SELECT' ;                                                 //0023
            LoadDDLSrcDtaArray();                                                        //0023
            Clear wkSourceMapping;                                                       //0023
            For wkIndex = 1 to logicalFileFieldCount;                                    //0023
                wkSourceMapping = %Trim(wkInternalFldArr(wkIndex));                      //0023
                LoadDDLSrcDtaArray();                                                    //0023
            EndFor;                                                                      //0023
            Clear wkSourceMapping;                                                       //0023
            wkSourceMapping = 'FROM ' + %Trim(wkTableName);                              //0023
            LoadDDLSrcDtaArray();                                                        //0023
            Clear wkSourceMapping;                                                       //0023
         EndIf;                                                                          //0023

         LoadDDLSourceMapDetails('SELECTOMIT');                                          //0023
         LoadDDLSourceMapDetails('BLANKS');                                              //0023
         Clear wkSourceMapping;                                                          //0023

      EndFor;                                                                            //0023

      //If fetched rows are less than the array elements then come out of the loop.     //0023
      If ObjectFetched < uwNoOfObj;                                                      //0023
         Leave ;                                                                         //0023
      EndIf ;                                                                            //0023

      //Fetched next set of rows.                                                       //0023
      rowFound = FetchCursorMultiMbr();                                                  //0023

   EndDo;                                                                                //0023

   //Close Cursor CursorMultiMbr                                                        //0023
   Exec Sql Close CursorMultiMbr;                                                        //0023

   LoadDDLSourceMapDetails('RCDFMTCMNT');                                                //0023
   LoadDDLSourceMapDetails('RCDFMT');                                                    //0023
   LoadDDLSourceMapDetails('BLANKS');                                                    //0023
   If inDDLLngNam <> *Blanks And inDDLObjNam <> inDDLLngNam;                             //0023
      LoadDDLSourceMapDetails('RNMTBLCMNT');                                             //0023
      LoadDDLSourceMapDetails('RNMTBL');                                                 //0023
      LoadDDLSourceMapDetails('BLANKS');                                                 //0023
      //Skip rename index when rename table already happened                            //0023
      Clear inDDLLngNam;                                                                 //0023
   EndIf;                                                                                //0023
   If lblTxtFound;                                                                       //0023
      LoadDDLSourceMapDetails('LBLVWCMNT');                                              //0023
      LoadDDLSourceMapDetails('LBLVIEW');                                                //0023
      LoadDDLSourceMapDetails('BLANKS');                                                 //0023
   EndIf;                                                                                //0023

   Select;                                                                               //0023
      When wkIsPrimaryKey = 'Y';                                                         //0023
         LoadDDLSourceMapDetails('CRTIDXCMNT');                                          //0023
         LoadDDLSourceMapDetails('CRTUNIQIDX');                                          //0023
         LoadDDLSourceMapDetails('BLANKS');                                              //0023
         LoadDDLSourceMapDetails('RCDFMTCMNT');                                          //0023
         LoadDDLSourceMapDetails('RCDFMT');                                              //0023
         LoadDDLSourceMapDetails('BLANKS');                                              //0023
         If lblTxtFound;                                                                 //0023
            LoadDDLSourceMapDetails('LBLIDXCMNT');                                       //0023
            LoadDDLSourceMapDetails('LBLIDX');                                           //0023
            LoadDDLSourceMapDetails('BLANKS');                                           //0023
         EndIf;                                                                          //0023
      When wkKeyCount > 0 and wkIsPrimaryKey <> 'Y';                                     //0023
         LoadDDLSourceMapDetails('CRTIDXCMNT');                                          //0023
         LoadDDLSourceMapDetails('CRTIDX');                                              //0023
         LoadDDLSourceMapDetails('BLANKS');                                              //0023
         LoadDDLSourceMapDetails('RCDFMTCMNT');                                          //0023
         LoadDDLSourceMapDetails('RCDFMT');                                              //0023
         LoadDDLSourceMapDetails('BLANKS');                                              //0023
         If lblTxtFound;                                                                 //0023
            LoadDDLSourceMapDetails('LBLIDXCMNT');                                       //0023
            LoadDDLSourceMapDetails('LBLIDX');                                           //0023
            LoadDDLSourceMapDetails('BLANKS');                                           //0023
         EndIf;                                                                          //0023
      Other;                                                                             //0023
   EndSl;                                                                                //0023

   //Write the generated source to DDL member                                           //0023
   WriteDDLMember();                                                                     //0023

End-Proc;                                                                                //0023

//------------------------------------------------------------------------------------- //0023
//FetchCursorMultiMbr : To fetch dependent member details                               //0023
//------------------------------------------------------------------------------------- //0023
Dcl-Proc FetchCursorMultiMbr;                                                            //0023

   Dcl-Pi *N Ind End-Pi ;                                                                //0023

   Dcl-S  rcdFound Ind Inz('0');                                                         //0023
   Dcl-S  wkRowNum Uns(5);                                                               //0023

   ObjectFetched = *Zeros;                                                               //0023
   Clear udMultiMbrDs;                                                                   //0023

   Exec Sql                                                                              //0023
      Fetch CursorMultiMbr For :uwNoOfObj Rows Into :udMultiMbrDs;                       //0023

   If sqlCode < successCode;                                                             //0023
      uDpsds.wkQuery_Name = 'Fetch_CursorMultiMbr';                                      //0023
      IaSqlDiagnostic(uDpsds);                                                           //0023
   EndIf;                                                                                //0023

   If sqlcode = successCode;                                                             //0023
      Exec Sql Get Diagnostics                                                           //0023
         :wkRowNum = ROW_COUNT;                                                          //0023
         ObjectFetched = wkRowNum ;                                                      //0023
   EndIf;                                                                                //0023

   If ObjectFetched > 0;                                                                 //0023
      rcdFound = TRUE;                                                                   //0023
   ElseIf sqlcode < successCode ;                                                        //0023
      rcdFound = FALSE;                                                                  //0023
   EndIf;                                                                                //0023

   Return rcdFound;                                                                      //0023

End-Proc;                                                                                //0023

//------------------------------------------------------------------------------------- //
//AddSrcMember : Add Source Member                                                      //
//------------------------------------------------------------------------------------- //
Dcl-Proc AddSrcMember;                                                                   //0023
   Dcl-Pi *N Ind;
   End-Pi;

   //Clear the member. If member not found, add a new member.
   Clear wkCommand;
   wkCommand = 'CLRPFM FILE(' + %Trim(inDDLMbrLib) + '/QDDLSRC)' +
                  ' MBR(' + %Trim(inDDLMbrNam) + ')';
   RunCmd();
   If wkMbrNotFound = 'Y';
      Clear wkMbrNotFound;
      //Adding a new member
      Clear wkCommand;
      wkCommand = 'ADDPFM FILE(' + %Trim(inDDLMbrLib) + '/QDDLSRC)' +
                  ' MBR(' + %Trim(inDDLMbrNam) + ')' +
                  ' SRCTYPE(' + %Trim(inDDLSrcAtr) + ')' +
                  ' TEXT('+ Squote +  %Trim(wkDDSSrcTxt) + Squote + ')';
      RunCmd();
      If wkError = 'Y' or wkMbrNotFound = 'Y';
         outStatus  = 'E';
         wkMsgVars  = %Trim(inDDLMbrLib);
         //Error while adding member in DDL source library.
         iAGetMsg('1':'MSG0204':wkMsgDesc:wkMsgVars);
         outMessage = %Trim(wkMsgDesc);
         Return *Off;
      EndIf;
   EndIf;

   Return *On;

End-Proc;                                                                                //0023

//------------------------------------------------------------------------------------- //
//RunCmd : To execute the command                                                       //
//------------------------------------------------------------------------------------- //
Dcl-Proc RunCmd;                                                                         //0023

   Dcl-Pr RunCommand ExtPgm('QCMDEXC');
      Command    Char(1000) Options(*VarSize) Const;
      Commandlen Packed(15:5) Const;
   End-Pr;

   Clear wkError;
   Monitor;
      RunCommand(wkCommand:%Len(%TrimR(wkCommand)));
        On-Excp 'CPF3141';
           wkMbrNotFound = 'Y';
        On-Error;
           wkError = 'Y';
        EndMon;

End-Proc;                                                                                //0023

