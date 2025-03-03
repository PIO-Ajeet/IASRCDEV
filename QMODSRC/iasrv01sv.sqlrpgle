**free
      //%METADATA                                                      *
      // %TEXT 01 Service Program Module                               *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------ //
//CREATED BY :   Programmers.io @ 2020                                                 //
//CREATE DATE:   2020/01/01                                                            //
//DEVELOPER  :   Kaushal kumar                                                         //
//DESCRIPTION:   Service Program Module - 1                                            //
//                                                                                     //
//PROCEDURE LOG:                                                                       //
//------------------------------------------------------------------------------------ //
//Procedure Name           | Procedure Description                                     //
//-------------------------|---------------------------------------------------------- //
//IAPsr3Fac                |                                                           //
//IAPsr3Con                |                                                           //
//IAPsrFxFx                |                                                           //
//GetFileObjSourceInfo     |                                                           //
//IsVariableOrConst        |                                                           //
//GetObjectSourceInfo      |                                                           //
//IaBreakSrcString         |                                                           //
//CallCLbif                |                                                           //
//IaPsrCLchg               |                                                           //
//IaPsrCLSbr               |                                                           //
//IaPsrSUBR                |                                                           //
//GetNumericValue          |                                                           //
//IaPsrCALLP               |                                                           //
//IaDivOP                  |                                                           //
//IaPsrSBDfx               |                                                           //
//Split_Component_3        |                                                           //
//Split_Component_2        |                                                           //
//IaPsrSQL                 |                                                           //
//IaPsrCPYB                |                                                           //
//IaLookupOP               |                                                           //
//IaPsrVARfx               |                                                           //
//IaPsrVARfr               |                                                           //
//IaPsrARRfx               |                                                           //
//IaPsrARRfr               |                                                           //
//IaPsrOPCfx3              |                                                           //
//IaPsrOPCfx               |                                                           //
//IaPsrDEFfx3              |                                                           //
//IaPsrDEFfx               |                                                           //
//IaPsrIsPCC               |                                                           //
//IaPsrIsPCV               |                                                           //
//IaPsrExtr                |                                                           //
//RmvBrackets              |                                                           //
//FindCbr                  |                                                           //
//IaPrCrtObj               |                                                           //
//RunCommand               |                                                           //
//IaPQuote                 |                                                           //
//GetSeqNumber             |                                                           //
//GetDataType              |                                                           //
//GetSCpos                 |                                                           //
//GetOPpos                 |                                                           //
//GetCBpos                 |                                                           //
//InQuote                  |                                                           //
//CalDataLengthRPGLE       |                                                           //
//IaVarRelUpdLog           |                                                           //
//GetWordsInArray          |                                                           //
//ScanKeyWord              |                                                           //
//ProcessScan4             |                                                           //
//ProcessScanR             |                                                           //
//IaVarRelLog              |                                                           //
//IRepHstLog               |                                                           //
//IPsrHstLog               |                                                           //
//IaBreakWord              |                                                           //
//IaUpdatePgmRef           |                                                           //
//IASRCREFW                |To save records to IASRCINTPF                              //
//IAParsePrtfSrc           |To save records to IASRCINTPF                              //
//------------------------------------------------------------------------------------ //
//                                                                                     //
//MODIFICATION LOG:                                                                    //
//------------------------------------------------------------------------------------ //
//Date    | Mod_ID | Developer  | Case and Description                                 //
//--------|--------|------------|----------------------------------------------------- //
//22/01/04| BA01   | BHOOMISH   | TO PARSE SQL QUERY TO FIMD MODE OF FILE USED IN QRY  //
//22/01/19| AK04   | ASHWANI    | TO SOLVE '*' PRESENT IN WHERE CLAUSE.                //
//22/01/19| VM03   | VINAY      | TO REMOVE ALIASES FROM FIELDS.                       //
//22/01/25| AK05   | ASHWANI    | ADDING JOIN FILE PARSING.                            //
//22/01/27| SK15   | SUMIT      | ADDING CASE WHEN PARSING FOR GROUP BY/ORDER BY       //
//22/01/27| VM04   | VINAY      | REMOVE ALIAS AND ADD CONST TO CONSTANT VARIABLES     //
//22/02/10| SB01   | SRIRAM B   | TO RETRIEVE ACTUAL DATA TYPES FOR SQLTYPE VARIABLES  //
//22/03/16| MT01   | Mahima     | Sql Comment Removal Proc insertion                   //
//22/03/16| MT11   | Mahima     | To remove extra bracket during SQL Parsing(IN Clause)//
//22/03/16| MT12   | Mahima     | SQL Insert Query Fix - For Non Qualified library     //
//22/03/08| SB02   | SRIRAM B   | TO FIX THE LIMIT KEYWORD NOT BEING OMITTED ISSUES    //
//22/03/08| SB03   | SRIRAM B   | TO FIX THE UCASE KEYWORD NOT BEING OMITTED ISSUES    //
//22/03/09| AK06   | ASHWANI    | ADDING 'ON' CLAUSE PARSING                           //
//22/03/24| SK02   | SANTHOSH   | FIXING STOREFINALVAR PROC                            //
//22/03/23| MT13   | Mahima     | Removing Alias in Order By and Group By              //
//22/03/23| MT14   | Mahima     | Where clause subquery issue                          //
//22/03/24| SJ01   | SUDHANSHU  | UPDATE QUERY NOT GIVING PROPER DATA                  //
//22/04/13| HJ01   | HIMANSHU J | Handle Null Value in SQL query while                 //
//        |        |            | using Aggregate functions                            //
//22/04/08| BA11   | BHOOMISH   | INFINITE LOOP ISSUE                                  //
//22/04/22| YK01   | Yashwant   | Bug Fix - Number of rows 0 not valid                 //
//22/04/22| NG01   | Nikhil     | Bug Fix - Rcvr value too small to hold the result    //
//22/05/09| SK04   | Santhosh   | Adding Dcl-s relations to IAVARREL                   //
//22/05/17| SK05   | Santhosh   | Fix const value not correctly populated in IAPGMVARS //
//21/05/10| YK04   | Yashwant   | Added Global/Local var type value colmn in IAPGMVARS //
//22/05/12| VM06   | Vinay      | Fixes related to CHGVAR command in CL                //
//22/06/15| TK01   | Tushar K   | Adding Dcl-ds relation to IAVARREL.                  //
//22/06/10| PJ01   | Pranav     | Parse DDS(PF/LF) source to extract fields and store  //
//        |        |            | in IAVARREL file.                                    //
//22/06/08| HJ02   | HIMANSHU J | Modified constant parsing logic.                     //
//22/07/15| HJ03   | HIMANSHU J | I Spec Parsing                                       //
//22/07/15| YK10   | Yashwant   | Modified for DS issues                               //
//22/07/15| RK15   | Rahul K    | WHENxx opcode included in fix format                 //
//22/06/24| MT02   | Mahima     | Array Declarations Tracking in VWU                   //
//22/07/20| PJ02   | Pranav     | Fixed issue where SDS and UDS data structure were not//
//        |        |            | getting parse in fix format.                         //
//22/08/25| SJ02   | Sunny J    | Fixed issue where constants are                      //
//        |        |            | getting parsed having quotes or deci                 //
//        |        |            | -mal values                                          //
//22/08/29| Br01   | Bpal       | Fixed the sql parsing issue when destination file not//
//        |        |            | found in the libl.                                   //
//22/08/30| BS01   | Sudha B    | 1. Fixed issue where part of constant value is parsed//
//        |        |            | 2. Fixed issue for identifying data type when program//
//        |        |            |    name and status of program status data structure  //
//        |        |            |    are parsed with *proc and *status definitions     //
//22/08/31| MT03   | Mahima     | Fixes for Range or Subscript error                   //
//22/09/01| BS02   | Sudha B    | Fixed log issue while parsing complex sql            //
//        |        |            | statements with more than 500 length                 //
//22/09/06|        | Santhosh   | Bug fix - Rcvr too small to hold the result          //
//        |        |            | Proc name - GetIntoArray                             //
//22/09/13| BS03   | Sudha B    | Fixed log issue 'array length not eqaul'             //
//22/09/16|        | Manav T    | CHGVAR issue in CL - $splitvalue changed             //
//22/09/19| SB04   | Sriram B   | Stndardizing the program                             //
//22/09/19| BS04   | Sudha B    | Stndardizing the program                             //
//22/10/07|        | Santhosh   | EXCPLOG - Incorrect stmt are paseed to ProcessCase   //
//22/09/19| BS05   | Sudha B    | Fixed issue - parsed constant value is in more than //
//        |        |            | one line then IAVARTRK has 0 from and to varids.     //
//22/09/19| BS06   | Sudha B    | Fixed issue - parsed constant values in dcl-c are    //
//        |        |            | wrong in IAPGMVARS file                              //
//22/10/06| SB05   | Sriram B   | Removed all the Monitor - On Error Blocks used       //
//22/10/13|        | Manav T    | Removed all unused procedures :-                     //
//        |        |            | GETSCPOS_1                                           //
//        |        |            | IAPSREXTR                                            //
//        |        |            | IAPSRZADD                                            //
//        |        |            | IAPSRCPFX                                            //
//        |        |            | IAPSRSUBSTFX                                         //
//        |        |            | SPLIT_COMPONENT                                      //
//        |        |            | IAPSRSBFX                                            //
//        |        |            | IAPSRSBDFX                                           //
//        |        |            | IADIVOP                                              //
//        |        |            | IAPSRDVFX                                            //
//        |        |            | IAPSRDVFR                                            //
//        |        |            | IAPSRFCALL                                           //
//22/10/20| YK11   | Yashwant   | Insert Query parser optimization                     //
//22/10/21| AJ01   | Anchal     | Bug fix for the I Sepc parsed                        //
//22/11/09| SS01   | Sushant S  | Bug fix for Data structure parsing                   //
//22/12/06| SS02   | Sushant S  | Bug fix to correct changes done for %Elem changes    //
//23/01/20| OJ01   | Ojasva     | Relace %trim and in-line SQL trim with options(*trim)//
//23/01/20| OJ01   | Ojasva     | Relace %trim and in-line SQL trim with options(*trim)//
//23/01/23| AK41   | Ashwani Kr | Issues coming in file IAPGMVARS, IAVARREL            //
//23/01/23| SH01   | Karan Messi| Copy Book missing value population                   //
//27/01/23| 0001   |Pranav Joshi| Changed parameter type for IaPsrVARfr.               //
//07/02/23| 0002   |Pranav Joshi| Changed queries selection criterion based on the     //
//        |        |            | indexes available.                                   //
//23/01/19| 0003   | Manesh  K  | Introduced Data struture for D-Spec parsing          //
//23/02/07| 0004   | Vivek sha  | introducing D specs in IaPsrVARfx                    //
//23/03/13| 0005   | Sarvesh B  | Comment the IAUPDATEPGMREF procedure for IAPGMREF    //
//        |        |            | and IACPGMREF updation.                              //
//23/03/17| 0006   | Yogesh J   | Modified The IABREAKWORD Sub Procedure For Insert    //
//        |        |            | The Words By Array In IAPGMREF And IACPGMREF File    //
//21/04/23| 0007   | Arshaa     | In IAPSRVARFR/IAPSRVARFX removed initial DS checks   //
//        |        |            | as IAVARREL for DSs are now being populated from     //
//        |        |            | IAPSRDSFR/IAPSRDSFX.                                 //
//23/03/15| 0008   | Sarvesh B  | Commenting the IAUPDATEPGMREF procedure call from    //
//        |        |            | each calling procedure.                              //
//04/03/23| 0009   | Sarvesh B  | Comment the IPSRHSTLOG procedure .                   //
//13/04/23| 0010   | Vishwas K. | Added logic to fix issue with DS and variable name   //
//23/03/16| 0011   |Pratik      | PLIST values need to be inserted into IAPGMVARS      //
//        |        |Atodaria    | so updating IAPGMVARS form CP_Wrtvardtl for PROC-VAR //
//        |        |            | needs to be commented out                            //
//23/04/04| 0012   |Prateek J   | New Procedure IAPSROSPEC for parsing O specs using   //
//23/03/27| 0013   |Rishab K    | Implement printer file parsing                       //
//17/05/23| 0014   | Sujatha &  | Added a new procedure iaParseDSPFSrc to parse the    //
//        |        |Freeda& Arun| display file sources                                 //
//23/07/05| 0015   |Rajesh G    | Fixed - SQL 'ORDER BY' parser issue in GRPBYSR       //
//23/07/12| 0016   |Alok Kumar  | Fixed issue for comma saparated fields               //
//23/08/10| 0017   |Khushi W.   | References of DSPF &PF should be captured in         //
//        |        |            | IAALLREFPF file.                                     //
//23/07/12| 0018   |Alok Kumar  | "INTO" Keyword Issue, Passing INTO keyword           //
//        |        |            | Prefixed and Suffixed by space                       //
//23/08/18| 0019   |Alok Kumar  | Added Functionality to parse select query in         //
//        |        |            | Declare cursor Statement TASK#:113                   //
//23/08/11| 0020   |Alok Kumar  | Added logic not to apply String based operation      //
//        |        |            | If the Insert Field is Numeric                       //
//23/08/11| 0021   |Alok Kumar  | Fix to parse the selected file fields where INTO     //
//        |        |            | is part of file field. Task#:152                     //
//31/07/23| 0022   |Sarthak &   | Called object name is also not being populated, this //
//        |        |   Tanisha  | should also be fixed.                                //
//        |        |            | Sequence number should be populated correctly        //
//        |        |            | Only DS subfield name should be coming. Task#:127,#96//
//        |        |            |                                                      //
//23/08/11| 0023   |Alok Kumar  | Merged 2 Elseif Conditions as both have same         //
//        |        |            | Operations. Task#:154                                //
//23/08/21| 0024   |Himanshu    | Parse the Factor 2 value in case of Like keyword     //
//        |        |Gehlot      | used at Variable declaration in IaPsrVARfr Procedure.//
//        |        |            | Task#:94                                            .//
//23/08/24| 0025   |Alok Kumar  | Added Functionality to GetFileFields Procedure       //
//        |        |            | to extract fields which are not in bracket but       //
//        |        |            | part of some select expression like FIELD1||FIELD2   //
//        |        |            | here 2 fields are being used but these are not       //
//        |        |            | being written to IAVARREL File                       //
//        |        |            | Also added feature to fetch the fields from          //
//        |        |            | arithmetic operation like FIELD1 + FIELD2, Task:130  //
//09/09/23| 0026   |Akshay      | Fixed issue with the parsing of CRTDUPOBJ command    //
//        |        |Sopori      | in IAPRCRTOBJ procedure.Task -118                    //
//23/09/06| 0027   |Alok Kumar  | Procedure GetFileFields writing incorrect field      //
//        |        |            | relation in IAVARREL file Task#:201                  //
//11/09/23| 0028   |Akshay      | Fixed looping issue while parsing SQL statements.    //
//        |        |Sopori      |                                                      //
//23/08/02| 0029   |Vishwas K.  | Fixed - Parameter parsing issue for Op-code ADDDUR   //
//        |        |            | Task#157                                             //
//23/09/07| 0030   |HIMANSHUGA  | GIT#-203:IAALLREFPF and IASRCINTPF not populated for //
//        |        |            | TRUNCATE TABLE SQL statement                         //
//28/09/23| 0031   |G Jayasimha | Fixed looping issue while parsing HTML Statements.   //
//04/10/23| 0032   |Alok Kumar  | Rewrite Subroutine Extfldsr in procedure             //
//        |        |            | Getfilefields [Task 198]                             //
//05/10/23| 0033   |Alok Kumar  | Refine the Where clause searching logic in           //
//        |        |            | WhereHavingProc procedure [Task 175]                 //
//05/10/23| 0034   |Sriram B    | Commented Out Temp2Vararr Sorting & related code     //
//        |        |            | logics from StoreFinalVar Sub-Proc to fix the wrong  //
//        |        |            | field mapping issue during SQL_INTO clause parsing   //
//        |        |            | Task #158                                            //
//25/08/23| 0035   |Alok Kumar  | Correction in case statement parsing in update       //
//        |        |            | query. Task#:163                                     //
//23/08/24| 0036   |Himanshu    | Task#:177-Constant value in SQL statement is not     //
//        |        |Gahtori     | populating correctly in IAVARREL file.               //
//23/04/28| 0037   |Ruchika N   | Develop Process_generic_opcode_parsing Sub Procedure //
//        |        |            | and parse the opcode in IAVARREL file with variable. //
//        |        |            | (Task#28)                                            //
//15/09/23| 0038   |Alok Kumar  | Select Query case statement fix Task:221             //
//16/10/23| 0039   |Alok Kumar  | Correction in case statement Keyword replacing       //
//        |        |            | process. Task#:288                                   //
//27/09/23| 0040   |Himanshu    | Fixed the Truncate issue for Extname Keyword         //
//        |        |Gehlot      | used at DS declaration Task: #135                    //
//23/09/07| 0041   |Satyabrat   | In fixed format, for any field if the datatype is    //
//        | Task#82|Sabat       | blanks and the decimal position is also blanks, the  //
//        |        |            | procedure GETDATATYPE returns blanks in place of     //
//        |        |            | CHAR.                                                //
//02/11/23| 0042   |Abhijit     | Need to change the usage filed to literal value      //
//        |        |Charhate    | instead of decimal.(Task#312)                        //
//14/12/23| 0043   |Anchal Jain | Do not write in IASRCINTPF file in case referenced   //
//        |        |            | object usage could not be retrieved or blanks.       //
//08/01/24| 0044   |Akhil Kallur| Complete parsing of keyword and writing the referred //
//        |        |            | file in IASRCINTPF and correct parsing if the keyword//
//        |        |            | is extended to more than one line. [Task #504]       //
//04/01/24| 0045   | Naresh S   | Fixed the parsing issue of %char BIF used in DSPLY   //
//        |        |            | and RETURN keywords in Free Format. [Task #499]      //
//23/09/05| 0046   |Alok Kumar  | Add the conditions before calling procedures to parse//
//        |        |            | the Where, Having, Order by and Group by clauses     //
//        |        |            | Task:195                                             //
//26/09/23| 0047   |Alok Kumar  | Performance Improvement of GetFileFields procedure - //
//        |        |            | Array index usage Task#:230                          //
//23/04/24| 0048   |Sriram B    | Add fix to avoid length or start position is out of  //
//        |        |            | range error in Normalsr & all the CheckComma         //
//        |        |            | Subroutines.                                         //
//24/04/23| 0049   |Sangeetha   | Bug1:Added Fix to 'Reciever value too small to hold  //
//        |        |Das         | the result' in subr Normalsr under PROCESSUPDATESQL  //
//        |        |            | procedure.Additionally fixed the similar issue for   //
//        |        |            | multiple other fields to avoid issues in future.     //
//        |        |            | Bug2:Added Fix to 'Range of subscript value or char  //
//        |        |            | string error' under WHEREHAVINGPROC procedure.       //
//24/04/24| 0050   |Sumer Parmar| fixed the issue - length or start position is out of //
//        |        |            | range for string operation in Process_generic_opcode_//
//        |        |            | parsing Sub-Proc.                                    //
//26/04/24| 0051   |Pranav Joshi| Fixed looping issue where SQL opcode not found.      //
//11/10/23| 0052   |Alok Kumar  | Duplicate Record in IAVARREL issue in Select Query   //
//        |        |            | Task #284                                            //
//26/10/23| 0053   |Alok Kumar  | Fix to skip parameters in sql function Task:269      //
//02/07/24| 0054   |Sribalaji   | Remove the hardcoded #IADTA lib from all sources     //
//        |        |            | Task #754                                            //
//05/10/23| 0055   |Alok Kumar  | Correction in case statement parsing in insert       //
//        |        |            | query. Task#:249                                     //
//17/09/24| 0056   |Gopi Thorat | Rename IACPYBDTL file fields wherever used due to    //
//        |        |and         | table changes. [Task#940]                            //
//        |        |K Abhishek A| Changes made to capture multiple references from the //
//        |        |            | library list of application library list,            //
//05/11/24| 0057   |Sribalaji   | Task #1052 Enhanced Logic to handle numeric fieldso  //
//        |        |            |            when they can have junk data and stop     //
//        |        |            |            adding decimal data error to joblog       //
//22/10/24| 0058   |Shobhit     | Task:1037 Change the PF/LF parsing functionality to  //
//        |        |            | add keyword and keyword value in IADSPFFDP table     //
//05/11/24| 0059   |K Abhishek A| Task #1064 Simplified Copybook parsing               //
//09/01/25| 0060   |Khushi      | Task 332: Handled REF/REFFLD logic to correct the    //
//        |        |Wadhwa      | data populated in reference object field in case of  //
//        |        |            | IASRCINTPF file                                      //
//22/01/25| 0061   |Vamsi       | IAPGMFILES is restructured.So,updated in all         //
//        |        |Krishna2    | dependent procedures. (Task#63)                      //
//08/16/24| 0062   |Vishwas &   | Included the logic for parsing IFS member.           //
//        |        |Sasikumar R | Task# 833
//23/08/23| 0063   |Abhijit C   | Remove the logic to populate IAPGMFILES for CL cmds  //
//        |        |            | not using the files in READ, WRITE, UPDATE or delete //
//        |        |            | [task#176]                                           //
//------------------------------------------------------------------------------------ //

ctl-opt copyright('Programmers.io Â© 2020 | Ashish | Changed April 2021');
ctl-opt option(*noDebugIo: *srcStmt: *noUnRef) expropts(*RESDECPOS) debug;
ctl-opt nomain;
ctl-opt bndDir('IABNDDIR');

/define GetObjectSourceInfo
/define GetFileObjSourceInfo
/define ProcessCreateSQLOpcode
/copy 'QMODSRC/iasrv01pr.rpgleinc'
/copy 'QMODSRC/iasrv02pr.rpgleinc'
/copy 'QMODSRC/iasrv03pr.rpgleinc'
/copy 'QMODSRC/iagetkwdpr.rpgleinc'
/copy 'QCPYSRC/rpgivds.rpgleinc'
/copy 'QCPYSRC/rpgiiids.rpgleinc'

dcl-ds  PSDS extname('IAPSDSF') PSDS qualified;
end-ds;

dcl-pr qcmdexc extpgm('QCMDEXC');
   *n char(500)     options(*varsize) const;
   *n packed(15:5)  const;
   *n char(3)       options(*nopass) const;
end-pr;

dcl-ds UwSrcDtl ;                                                                        //0062
       in_srclib   Char(10) ;                                                            //0062
       in_srcspf   Char(10) ;                                                            //0062
       in_srcmbr   Char(10) ;                                                            //0062
       in_ifsloc   Char(100);                                                            //0062
       in_srcType  Char(10) ;                                                            //0062
       in_srcStat  Char(1)  ;                                                            //0062
end-ds;                                                                                  //0062
dcl-pr ProcessCase  char(500) ;
//OJ01 in_string char(500);                                                              //OJ01
   in_string char(500) const options(*trim);                                             //OJ01
end-pr ;

dcl-c CSR_OPN_COD   const(-502);                                                         //0013
dcl-c upper         'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
dcl-c lower         'abcdefghijklmnopqrstuvwxyz';
dcl-c SQL_ALL_OK    '00000';
//dcl-c DIGITS        '0123456789';                                                       //0029
dcl-c DIGITS        '0123456789.-+';                                                      //0029
dcl-c DIGITS1       '0123456789.';
dcl-s arr_index      packed(4:0);
dcl-s temp_count     packed(4:0);
Dcl-s VarArr         Char(120) Dim(999);
dcl-s keywordarr     char(50)  dim(12) ctdata perrcd(1);
dcl-s aggregatearr   char(50)  dim(5)  ctdata perrcd(1);
dcl-s KEYWRDARRAY    char(50)  dim(13) ctdata perrcd(1);
dcl-s KEYWRDARRAY1   char(50)  dim(09) ctdata perrcd(1);
dcl-s KEYWRDARRAY2   char(50)  dim(05) ctdata perrcd(1);
dcl-s filterarr      char(2)   dim(15) ctdata perrcd(1);
dcl-s SQLDatTypArr   char(18)  dim(40) ctdata perrcd(2);
dcl-s clopcodearr    char(20)  dim(31) ctdata perrcd(1);
dcl-s KEYWORDARRAY3 char(10) Dim(10) ctdata perrcd(1);
Dcl-c cwDigits       '0123456789';                                                        //0057

//Array to store special workds ti skip in CL that starts with operator
dcl-s clspclkeywd char(10) Dim(2) ctdata perrcd(1);
dcl-s RelOprAry     char(2)  Dim(10) ctdata perrcd(1);
dcl-s keywordExcArr varchar(10) dim(50) ctdata perrcd(1);                                //0013
dcl-s WKConstInd     Ind       Inz('0');
dcl-s W_IAVSEQNUM packed(2:0)  Inz;
dcl-s W_POSS3     Packed(3:0)  Inz;
dcl-s W_POSS4     Packed(2:0)  Inz;
dcl-c W_AlphaNum 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ<>123456789';
dcl-s DSPFKWARRAY   char(10) Dim(24) ctdata perrcd(1);                                   //0014
dcl-s DSPFRFARRAY   char(10) Dim(2)  ctdata perrcd(1);                                   //0014
dcl-s urFileFieldKeyWord char(10) Dim(10) ctdata perrcd(1);                              //0058

Dcl-ds Temp1VarArr Dim(250) Qualified Inz;
   VarName Char(120);
End-ds;

Dcl-ds Temp2VarArr Dim(250) Qualified Inz;
  VarName Char(120);
End-ds;

Dcl-ds IAPGMREFDS Dim(250) Qualified Inz;                                                //0006
  v_SrcPf char(10);                                                                      //0006
  v_Libname  char(10);                                                                   //0006
  v_MbrName char(10);                                                                    //0006
  v_IfsLoc  char(100);                                                                   //0062
  v_rrn packed(6:0);                                                                     //0006
  v_SrcWrd Char(120);                                                                    //0006
End-ds;                                                                                  //0006

Dcl-ds FileRefValDs Qualified Inz;                                                       //0017
  refLib         Char(10)  Inz(' ') ;                                                    //0017
  refObj         Char(10)  Inz(' ') ;                                                    //0017
End-ds;                                                                                  //0017

exec sql
  set option commit = *none,
             naming = *sys,
             usrprf = *user,
             dynusrprf = *user,
             closqlcsr = *endmod,
             srtseq = *langidshr;

//------------------------------------------------------------------------------------ //
//IaBreakWord:                                                                         //
//------------------------------------------------------------------------------------ //
dcl-proc IaBreakWord export;

   dcl-pi IaBreakWord;
//OJ01in_library      char(10)    value;
//OJ01in_sourcepf     char(10)    value;
//OJ01in_member       char(10)    value;
      in_library      char(10)    value options(*trim);                                  //OJ01
      in_sourcepf     char(10)    value options(*trim);                                  //OJ01
      in_member       char(10)    value options(*trim);                                  //OJ01
      in_ifsloc       char(100)   value options(*trim);                                  //0062
      in_rrn          packed(6:0) value;
      in_sourcestring char(120)   value;
      in_srcflag      char(1)     value;
   end-pi;

   dcl-s br_array         char(120)    dim(4999);
   dcl-s return_statement char(120);
   dcl-s br_index         packed(4:0);
   dcl-s br_asteriskpos   packed(4:0)  inz;
   dcl-s br_startPos      packed(10:0) inz(1);
   dcl-s br_foundPos      packed(10:0) Inz;
   dcl-s br_increment     packed(10:0) Inz;
   dcl-s br_loop          packed(5:0);
   dcl-s blankPos         packed(4:0);                                                    //YK05
   dcl-s nonBlankPos      packed(10:0);                                                   //YK05
   dcl-s NbrOfRows        packed(5:0) ;                                                   //0006

   dcl-c br_pads         '?+~-/=<>():;,''"';
   dcl-c br_blk          '                ';

   br_foundpos  = 0;
   br_startpos  = 1;
   br_index     = 1;
   br_increment = 1;

   in_sourcestring = %xlate(lower:upper:in_sourcestring);
   in_sourcestring = %xlate(br_pads:br_blk:in_sourcestring);
   clear br_array;

   if in_sourcestring = *blanks;
      return;
   endif;

 //dou br_foundPos = %len(%trim(in_sourcestring)) + 1 or                                  //YK05
 //    %len(%trim(in_sourcestring)) = 0;                                                  //YK05

 //   br_foundpos = %scan(' ':%trim(in_sourcestring):br_startPos);                        //YK05
 //   if br_foundpos > 0;                                                                 //YK05
 //      dow %subst(%trim(in_sourcestring) :br_foundpos+1 :1) = ' ';                      //YK05
 //         in_sourcestring = %replace('' :%trim(in_sourcestring) :br_foundpos+1:1);      //YK05
 //      enddo;                                                                           //YK05
 //   endif;                                                                              //YK05

 //   if br_foundPos = 0;                                                                 //YK05
 //      br_foundPos = %len(%trim(in_sourcestring)) + 1;                                  //YK05
 //   endif;                                                                              //YK05

 //   if br_startPos > *zeros and br_foundPos > br_startPos                               //YK05
 //      and br_index <= %elem(br_array);                                                 //YK05
 //      br_array(br_index) = %subst(%trim(in_sourcestring):br_startPos                   //YK05
 //                                     :br_foundPos - br_startPos);                      //YK05
 //   endif;                                                                              //YK05

 //   clear br_asteriskpos;                                                               //YK05
 //   br_asteriskpos = %scan('*':%trim(br_array(br_index)):1);                            //YK05
 //   dow br_asteriskpos > *zeros                                                         //YK05
 //       and %len(%trim(br_array(br_index))) > br_asteriskpos                            //YK05
 //       and %subst(%trim(br_array(br_index)) :br_asteriskpos+1 :1) <> '*'               //YK05
 //       and br_index < %elem(br_array);                                                 //YK05
 //      br_array(br_index+1) = %subst(%trim(br_array(br_index)) :br_asteriskpos+1        //YK05
 //                                    :%len(%trim(br_array(br_index)))-br_asteriskpos);  //YK05
 //      if br_asteriskpos > 1;                                                           //YK05
 //         br_array(br_index) = %subst(%trim(br_array(br_index)) :1 :br_asteriskpos-1);  //YK05
 //      endif;                                                                           //YK05
 //      br_index+=1;                                                                     //YK05
 //   enddo;                                                                              //YK05

 //   br_index += 1;                                                                      //YK05
 //   br_startPos = br_foundPos + br_increment;                                           //YK05

 //enddo;                                                                                 //YK05

   blankPos = 1;                                                                          //YK05
   nonBlankPos = %check(' ': in_sourcestring: blankPos);                                  //YK05
   for br_index=1 to %elem(br_array);                                                     //YK05
      if nonBlankPos = 0;                                                                 //YK05
         leave;                                                                           //YK05
      endIf;                                                                              //YK05
      blankPos = %scan(' ': in_sourcestring: nonBlankPos);                                //YK05
      if blankPos - nonBlankPos > 0;                                                      //YK05
         if %subst(in_sourcestring: nonBlankPos: 1) <> '*';                               //YK05
            br_array(br_index) = %subst(in_sourcestring:                                  //YK05
                                        nonBlankPos: blankPos-nonBlankPos);               //YK05
         endIf;                                                                           //YK05
         nonBlankPos = %check(' ': in_sourcestring: blankPos);                            //YK05
      else;                                                                               //YK05
         clear nonBlankPos;                                                               //YK05
      endIf;                                                                              //YK05
   endFor;                                                                                //YK05

   select;
      when in_srcflag = 'R';
         clear IAPGMREFDS;                                                                //YJ01
         for br_loop = 1 to %elem(br_array);                                              //YK05

            if br_array(br_loop) = *blanks;                                               //YK05
               leave;                                                                     //YK05
            endIf;                                                                        //YK05

            return_statement = br_array(br_loop);

            IAPGMREFDS(br_loop).v_Srcpf   = in_sourcepf;                                    //0006
            IAPGMREFDS(br_loop).v_Libname = in_library;                                     //0006
            IAPGMREFDS(br_loop).v_MbrName = in_member;                                      //0006
            IAPGMREFDS(br_loop).v_ifsloc  = in_ifsloc;                                      //0062
            IAPGMREFDS(br_loop).v_rrn     = in_rrn;                                         //0006
            IAPGMREFDS(br_loop).v_SrcWrd  = %trim(return_statement);                        //0006

         endfor;

         NbrOfRows = br_loop - 1;                                                        //0006

         if NbrOfRows > 0;                                                               //0006

            Exec sql                                                                     //0006
               insert into IAPGMREF (SRC_PF_NAME, LIBRARY_NAME,                          //0006
                       //            MEMBER_NAME, SOURCE_RRN,                    //0062  //0006
                                     MEMBER_NAME, IFS_LOCATION, SOURCE_RRN,              //0062
                                     SOURCE_WORD) :NbrOfRows Rows                        //0006
                  values(:IAPGMREFDS);                                                   //0006

            if SQLSTATE <> SQl_ALL_OK;                                                   //0006
               //log error
            endif;                                                                       //0006

         endif;

      when in_srcflag = 'C';

         clear IAPGMREFDS;                                                               //0006
         NbrOfRows = *zero;                                                              //0006

         for br_loop = 1 to %elem(br_Array);                                             //YK05

            if br_array(br_loop) = *blanks;                                              //YK05
               leave;                                                                    //YK05
            endIf;                                                                       //YK05

            return_statement = br_Array(br_loop);

            IAPGMREFDS(br_loop).v_Srcpf   = in_sourcepf;                                 //0006
            IAPGMREFDS(br_loop).v_Libname = in_library;                                  //0006
            IAPGMREFDS(br_loop).v_MbrName = in_member;                                   //0006
            IAPGMREFDS(br_loop).v_Ifsloc  = in_IfsLoc;                                   //0062
            IAPGMREFDS(br_loop).v_rrn     = in_rrn;                                      //0006
            IAPGMREFDS(br_loop).v_SrcWrd  = %trim(return_statement);                     //0006

         endfor;

         NbrOfRows = br_loop - 1;                                                        //0006

         if NbrOfRows > 0;                                                               //0006

            Exec sql                                                                     //0006
               insert into IACPGMREF (SRC_PF_NAME, LIBRARY_NAME,                         //0006
                    //                MEMBER_NAME, SOURCE_RRN,                    //0062 //0006
                                      MEMBER_NAME, IFS_LOCATION, SOURCE_RRN,             //0062
                                      SOURCE_WORD ) :NbrOfRows Rows                      //0006
                 values(:IAPGMREFDS);                                                    //0006

            if SQLSTATE <> SQl_ALL_OK;                                                   //0006
               //log error
            endif;                                                                       //0006

         endif;

   endsl;

   return;
end-proc;

//------------------------------------------------------------------------------------ //
//IRepHstLog:                                                                          //
//------------------------------------------------------------------------------------ //
dcl-proc IRepHstLog export;

   dcl-pi IRepHstLog;
      in_repo        char(10) const options(*trim);                                      //OJ01
      in_repoact     char(20) const options(*trim);                                      //OJ01
      in_actdtl      char(50) const options(*trim);                                      //OJ01
   end-pi;

   exec sql
      insert into IAREPOLOG (rlrepnm,
                             rlrepact,
                             rlactdtl)
        values(:in_repo,                                                                 //OJ01
               :in_repoact,                                                              //OJ01
               :in_actdtl);                                                              //OJ01

   if SQLSTATE <> SQL_ALL_OK;
      //log error
   endif;

   return;
end-proc;

//------------------------------------------------------------------------------------ //
//IaVarRelLog:                                                                         //
//------------------------------------------------------------------------------------ //
dcl-proc IaVarRelLog export;

   dcl-pi IaVarRelLog;
      in_RESRCLIB     char(10);
      in_RESRCFLN     char(10);
      in_REPGMNM      char(10);
      in_REIFSLOC     char(100);                                                        //0062
      in_RESEQ        packed(6:0);
      in_RERRN        packed(6:0);
      in_REROUTINE    char(80);
      in_RERELTYP     char(10);
      in_RERELNUM     char(10);
      in_REOPC        char(10);
      in_RERESULT     char(50);
      in_REBIF        char(10);
      in_REFACT1      char(80);
      in_RECOMP       char(10);
      in_REFACT2      char(80);
      in_RECONTIN     char(10);
      in_RERESIND     char(06);
      in_RECAT1       char(1);
      in_RECAT2       char(1);
      in_RECAT3       char(1);
      in_RECAT4       char(1);
      in_RECAT5       char(1);
      in_RECAT6       char(1);
      in_REUTIL       char(10);
      in_RENUM1       packed(5:0);
      in_RENUM2       packed(5:0);
      in_RENUM3       packed(5:0);
      in_RENUM4       packed(5:0);
      in_RENUM5       packed(5:0);
      in_RENUM6       packed(5:0);
      in_RENUM7       packed(5:0);
      in_RENUM8       packed(5:0);
      in_RENUM9       packed(5:0);
      in_REEXC        char(1);
      in_REINC        char(1);
   end-pi;

   exec sql
   // insert into IAVARREL (RESRCLIB, RESRCFLN, REPGMNM, RESEQ, RERRN,                  //0062
      insert into IAVARREL (RESRCLIB, RESRCFLN, REPGMNM, REIFSLOC, RESEQ, RERRN,        //0062
                           REROUTINE, RERELTYP, RERELNUM, REOPC, RERESULT,
                           REBIF, REFACT1, RECOMP, REFACT2, RECONTIN, RERESIND,
                           RECAT1, RECAT2, RECAT3, RECAT4, RECAT5, RECAT6,
                           REUTIL, RENUM1, RENUM2, RENUM3, RENUM4, RENUM5,
                           RENUM6, RENUM7, RENUM8, RENUM9, REEXC, REINC)
    // values(:in_RESRCLIB, :in_RESRCFLN, :in_REPGMNM, :in_RESEQ,   :in_RERRN,                //0062
       values(:in_RESRCLIB, :in_RESRCFLN, :in_REPGMNM, :in_REIFSLOC,:in_RESEQ,                //0062
              :in_RERRN,                                                                      //0062
              :in_REROUTINE, :in_RERELTYP, :in_RERELNUM, :in_REOPC,
              :in_RERESULT, :in_REBIF, :in_REFACT1, :in_RECOMP, :in_REFACT2,
              :in_RECONTIN, :in_RERESIND, :in_RECAT1, :in_RECAT2, :in_RECAT3,
              :in_RECAT4, :in_RECAT5, :in_RECAT6, :in_REUTIL, :in_RENUM1,
              :in_RENUM2, :in_RENUM3, :in_RENUM4, :in_RENUM5, :in_RENUM6,
              :in_RENUM7, :in_RENUM8, :in_RENUM9, :in_REEXC, :in_REINC);

   if SQLSTATE <> SQL_ALL_OK;
      //log error
   endif;
end-proc;

//------------------------------------------------------------------------------------ //
//ProcessScanR                                                                         //
//------------------------------------------------------------------------------------ //
dcl-proc ProcessScanR export;

   Dcl-Pi ProcessScanR packed(5:0);
      SearchArgument VarChar(100)   const;
      SearchString   VarChar(10000) const;
      StartPos       Packed(5:0)    Options(*NoPass) Const;
      Length         Packed(5:0)    Options(*NoPass) Const;
   End-Pi;

   Dcl-S W_SearchString     VarChar(5000) inz;
   Dcl-S W_ErrorMessage     Char(200)     inz;
   Dcl-S W_InfiniteLoop     Char(1)       inz('1');
   Dcl-S W_StartPos         Packed(4:0)   inz;
   Dcl-S W_Length           Packed(4:0)   inz;
   Dcl-S W_LastOccurancePos Packed(4:0)   inz;
   Dcl-S W_PositionSaved    Packed(4:0)   inz;

   if SearchString = *blanks;                                                 //KM
      W_LastOccurancePos = *zeros;                                            //KM
      return W_LastOccurancePos;                                              //KM
   endif;                                                                     //KM

   W_SearchString = SearchString;
   select;
      when %Parms = 2;
         W_StartPos = 1;
         W_Length = %len(W_SearchString);
      when %Parms = 3;
         W_StartPos = StartPos;
         W_Length = %len(W_SearchString);
      when %Parms = 4;
         W_Length = Length;
         W_StartPos = StartPos;
         if (W_StartPos + W_Length - 1) > *zeros
            and %len(%trim(W_SearchString)) >= W_StartPos + W_Length - 1;
            W_SearchString = %Subst(W_SearchString: 1:
                                        W_StartPos + W_Length - 1);
         endif;
   endSl;

   dow %len(W_SearchString) >= w_startpos;
      W_PositionSaved = %Scan(SearchArgument :W_SearchString :W_StartPos);

      If W_PositionSaved = 0;
         Leave;
      EndIf;

      W_LastOccurancePos = W_PositionSaved;
      W_StartPos = W_PositionSaved + %len(SearchArgument);
   endDO;

   return W_LastOccurancePos;
End-Proc ProcessScanR;

//------------------------------------------------------------------------------------ //
//ProcessScan4:                                                                        //
//------------------------------------------------------------------------------------ //
Dcl-Proc ProcessScan4 Export;

   Dcl-Pi ProcessScan4 Packed(5);
      SearchArgument VarChar(50)    const;
      SearchString   VarChar(10000) const;
      StartPos       Packed(5)      const;
      Length         Packed(5)      const;
   End-Pi;

   Dcl-S W_SearchString     VarChar(10000) inz;
   Dcl-S W_Occurance        Packed(5)      inz;

   if SearchString <> *blanks and startpos > 0 and length > 0 and
      length < %len(SearchString)-startpos;
      W_SearchString = %Subst(SearchString:StartPos:Length);

      W_Occurance = %Scan(SearchArgument:W_SearchString:1);
      if W_Occurance > 0;
         W_Occurance = W_Occurance + StartPos - 1;
      endif;
   endif;

   Return W_Occurance;
End-Proc ProcessScan4;

//------------------------------------------------------------------------------------ //
//ScanKeyWord                                                                          //
//------------------------------------------------------------------------------------ //
dcl-proc ScanKeyWord export;

   dcl-pi *n varchar(5000);
      keyword char(12) const;
      w_ClStatement char(5000) const;
   end-pi;

   dcl-s w_Keyword char(12)   inz;
   dcl-s w_Result  char(5000) inz;
   dcl-s w_StrPos  zoned(4:0) inz;
   dcl-s w_EndPos  zoned(4:0) inz;
   dcl-s w_Strpos1 zoned(4:0) inz;

   if w_Keyword = *blanks and w_ClStatement = *blanks;                       //KM
      w_result = *blanks;                                                    //KM
      return w_result;                                                       //KM
   endif;                                                                    //KM

   w_Keyword = Keyword;
   w_StrPos  = %scan(%trimr(w_Keyword):w_ClStatement:1);
   if w_StrPos > *zeros;
      w_StrPos  = w_StrPos + %len(%trimr(w_keyword));
      w_StrPos1 = w_StrPos;

      dow w_Strpos1 > *zeros;
         if w_Endpos > *zeros;
            w_StrPos1 = w_EndPos + 1;
         endif;

         w_EndPos = %scan(')' : w_ClStatement : w_StrPos1);
         if w_EndPos > 0;
            w_StrPos1 = %scan('(' : w_ClStatement: w_StrPos1);
            if w_StrPos1 > w_EndPos;
               w_StrPos1=0;
            endif;
         else;
            w_EndPos = %len(w_Clstatement);
            leave;
         endif;
      enddo;

      if w_StrPos > *zeros and w_EndPos > w_StrPos;
         w_result = %subst(w_Clstatement:w_StrPos:w_EndPos-w_StrPos);
      endif;
   endif;

   return %trim(w_result:' ''''" ');                                                      //0040
end-proc;

//------------------------------------------------------------------------------------ //
//GetWordsInArray : Break the cl statement in words and return the array.              //
//------------------------------------------------------------------------------------ //
dcl-proc GetWordsInArray export;

   dcl-pi *n;
      w_ClStatement char(5000) const;
      w_WordsArray  char(120)  dim(100);
   end-pi;

   dcl-s w_ClStm  char(5000);
   dcl-s w_strPos zoned(4:0) inz(1);
   dcl-s w_EndPos zoned(4:0) inz(1);
   dcl-s w_index  zoned(3:0) inz;

   if w_ClStatement = *blanks;                                                 //KM
      return;                                                                  //KM
   endif;                                                                      //KM

   w_clstm = %xlate('()' :'  ' :w_ClStatement);
   dow w_EndPos > *zeros and w_StrPos > *zeros;
      w_StrPos = %check(' ' :w_Clstm :W_EndPos);
      if w_StrPos > *zeros;
         w_EndPos = %scan(' ' :w_ClStm :W_StrPos);
         if w_EndPos > *zeros and w_EndPos > w_StrPos;
            w_Index += 1;
            if w_Index <= %elem(w_WordsArray);
               w_WordsArray(w_Index) = %subst(w_ClStm :w_StrPos:
                                                 w_EndPos - w_StrPos);
            endif;
         endif;
      endif;
   enddo;

end-proc;

//------------------------------------------------------------------------------------ //
//IaVarRelUpdLog:                                                                      //
//------------------------------------------------------------------------------------ //
dcl-proc IaVarRelUpdLog export;

   dcl-pi IaVarRelUpdLog;
      in_RESRCLIB  char(10);
      in_RESRCFLN  char(10);
      in_REPGMNM   char(10);
      in_REIFSLOC  char(100);                                                            //0062
      in_RESEQ     packed(6:0);
      in_RERRN     packed(6:0);
      in_REROUTINE char(80);
      in_RERELTYP  char(10);
      in_RERELNUM  char(10);
      in_REOPC     char(10);
      in_RERESULT  char(50);
      in_REBIF     char(10);
      in_REFACT1   char(80);
      in_RECOMP    char(10);
      in_REFACT2   char(80);
      in_RECONTIN  char(10);
      in_RERESIND  char(06);
      in_RECAT1    char(1);
      in_RECAT2    char(1);
      in_RECAT3    char(1);
      in_RECAT4    char(1);
      in_RECAT5    char(1);
      in_RECAT6    char(1);
      in_REUTIL    char(10);
      in_RENUM1    packed(5:0);
      in_RENUM2    packed(5:0);
      in_RENUM3    packed(5:0);
      in_RENUM4    packed(5:0);
      in_RENUM5    packed(5:0);
      in_RENUM6    packed(5:0);
      in_RENUM7    packed(5:0);
      in_RENUM8    packed(5:0);
      in_RENUM9    packed(5:0);
      in_REEXC     char(1);
      in_REINC     char(1);
   end-pi;

   dcl-s in_count packed(5:0)  inz;
   dcl-s recFound char(1)      inz;

   exec sql
      select 'Y' as flag
        into :recFound
        from IAVARREL
      where   RESRCLIB = :in_RESRCLIB
        and   RESRCFLN = :in_RESRCFLN
        and   REPGMNM  = :in_REPGMNM
    //  And   REIFSLOC = :in_REIFSLOC                                                    //0062
        and   RESEQ    = :in_reseq
        and   RERRN    = :in_rerrn
      fetch first row only;

   if SQLSTATE <> SQL_ALL_OK;
      //log error
   endif;

   if recFound = 'Y';
      exec sql
         update IAVARREL
           set REFACT1  = :in_REFACT1,
               REFACT2  = :in_REFACT2,
               RECONTIN = :in_RECONTIN
         where   RESRCLIB = :in_RESRCLIB
           and   RESRCFLN = :in_RESRCFLN
           and   REPGMNM  = :in_REPGMNM
      //   And   REIFSLOC = :in_REIFSLOC                                                //0062
           and   RESEQ    = :in_reseq
           and   RERRN    = :in_rerrn;

      if SQLSTATE <> SQL_ALL_OK;
         //log error
      endif;
   endif;

end-proc;

//------------------------------------------------------------------------------------ //
//CalDataLengthRPGLE:                                                                  //
//------------------------------------------------------------------------------------ //
dcl-proc CalDataLengthRPGLE export;

   dcl-pi CalDataLengthRPGLE;
      in_Data_Typ char(10);
      in_IAV_DATF char(05);
      in_String   char(243);
      in_Decimal  char(10);
      in_Length   char(10);
      in_Pos      packed(5:0);
      in_Pos1     packed(5:0);
   end-pi;

   if in_Data_Typ <> 'D' or in_Data_Typ <> 'T' or
      in_Data_Typ <> 'Z ' or in_Data_Typ <> '*' or
      in_Data_Typ <> 'N';

      if in_Length <> *blanks;
         in_Length = %trim(in_length);
      endif;

   endif;

   select;
      when in_Data_Typ = 'A';
         in_Data_Typ = 'Char';
      when in_Data_Typ = 'B';
         in_Data_Typ = 'Binary';
      when in_Data_Typ = 'D';
         in_Data_Typ = 'Date';
         if %scan('DATFMT':in_string) > 0;
            in_pos  = %scan('DATFMT':in_string) + 6;
            in_pos  = %scan('(':in_string:in_pos);
            if in_pos > 0;
               in_pos1 = %scan(')':in_string:in_pos);
            endif;
            if (in_pos1 - in_pos) > 1;
               in_IAV_DATF = %subst(in_string:in_pos+1:in_pos1 - in_pos -1);
            endif;
         else;
            in_IAV_DATF = *Blanks;
         endif;
         in_Length = '10';
      when in_Data_Typ = 'F';
         in_Data_Typ = 'Float';
      when in_Data_Typ = 'G';
         in_Data_Typ = 'Graphic';
      when in_Data_Typ = 'I';
         in_Data_Typ = 'Sign INT';
      when in_Data_Typ = 'N';
         in_Data_Typ = 'Indicator';
         in_Length = '1';
      when in_Data_Typ = 'P';
         in_Data_Typ = 'Packed';
      when in_Data_Typ = 'S';
         in_Data_Typ = 'Zoned';
      when in_Data_Typ = 'T';
         in_Data_Typ = 'Time';
         in_Length = '8';
      when in_Data_Typ = 'U';
         in_Data_Typ = 'Unsign INT';
      when in_Data_Typ = 'Z';
         in_Data_Typ = 'Timestamp';
         in_Length = '26';
      when in_Data_Typ = '*';
         in_Data_Typ = 'Pointer';
         in_Length = '0';
      when in_Data_Typ = *blanks and in_Decimal = *blanks;
         in_Data_Typ = 'Char';
      when in_Data_Typ = *blanks and in_Decimal <> *blanks;
         in_Data_Typ = 'Decimal';
   endsl;

end-proc;

//------------------------------------------------------------------------------------ //
//InQuote:                                                                             //
//------------------------------------------------------------------------------------ //
dcl-proc InQuote export;

   dcl-pi InQuote;
      iq_string   char(5000);
      iq_position packed(6:0);
      iq_InQuote  char(1);
   end-pi;

   dcl-s i_qpos    packed(6:0) inz;
   dcl-s i_counter packed(6:0) inz;

   i_qpos = %scan('"' :iq_string);
   dow i_qpos > 0 and i_qpos < iq_position;
      i_counter += 1;
      i_qpos = %scan('"' :iq_string :i_qpos+1);
   enddo;

   i_qpos = %scan('"""' :iq_string:1);
   dow i_qpos > 0 and i_qpos < iq_position;
      i_counter -= 3;
      i_qpos = %scan('"""' :iq_string:i_qpos + 1);
   enddo;

   if i_counter = 0 or %rem(i_counter:2) = 0;
      iq_InQuote = 'N';
   else;
      iq_InQuote = 'Y';
   endif;

   return;

end-proc;

//------------------------------------------------------------------------------------ //
//GetCBpos:                                                                            //
//------------------------------------------------------------------------------------ //
dcl-proc GetCBpos export;

   dcl-pi GetCBpos packed(4:0);
      in_String char(5000);
      in_OBpos  packed(4:0);
   end-pi;

   dcl-s Counter  packed(4:0) inz;
   dcl-s Length   packed(4:0) inz;
   dcl-s Brackets packed(4:0) inz;

   If In_String = *Blanks;                                                              //VP01
      clear Counter;                                                                    //VP01
      return Counter;                                                                   //VP01
   EndIf;                                                                               //VP01

   Length = %len(%trim(in_String));
   for Counter = in_OBPos + 1 to Length;
      select;
        when %subst(in_String: Counter:1) = '(';
           Brackets += 1;
        when %subst(in_String: Counter:1) = ')' and Brackets = 0;
           leave;
        when %subst(in_String: Counter:1) = ')';
           Brackets -= 1;
      endsl;
   endfor;

   return Counter;
end-proc;

//------------------------------------------------------------------------------------ //
//GetOPpos:                                                                            //
//------------------------------------------------------------------------------------ //
dcl-proc GetOPpos export;

   dcl-pi GetOPpos packed(4:0);
      String char(5000);
      OBpos  packed(4:0);
   end-pi;

   dcl-s Counter  packed(4:0) inz;
   dcl-s Length   packed(4:0) inz;
   dcl-s Brackets packed(4:0) inz;
   dcl-s OPpos    packed(4:0) inz;

   If String = *Blanks;                                                                 //VP01
      clear OPpos;                                                                      //VP01
      return OPpos;                                                                     //VP01
   EndIf;                                                                               //VP01

   Length = %len(%trim(String));
   for Counter = OBpos + 1 to Length;
      select;
      when %subst(String:Counter:1) = '(';
         Brackets += 1;
      when %subst(String:Counter:1) = ')';
         Brackets -= 1;
      when (%subst(String:Counter:1) = '+' or
            %subst(String:Counter:1) = '-' or
            %subst(String:Counter:1) = '*' or
            %subst(String:Counter:1) = '/') and Brackets = 0;
         OPpos = Counter;
         leave;
      endsl;
   endfor;

   return OPpos;
end-proc;

//------------------------------------------------------------------------------------ //
//GetSCpos:                                                                            //
//------------------------------------------------------------------------------------ //
dcl-proc GetSCpos export;

   dcl-pi GetSCpos packed(4:0);
      String char(5000);
      OBpos  packed(4:0);
   end-pi;

   dcl-s Counter  packed(4:0) inz;
   dcl-s Length   packed(4:0) inz;
   dcl-s Brackets packed(4:0) inz;
   dcl-s SCpos    packed(4:0) inz;

   If String = *Blanks;                                                                 //VP01
      clear SCpos;                                                                      //VP01
      return SCpos;                                                                     //VP01
   EndIf;                                                                               //VP01

   Length = %len(%trim(String));
   for Counter = OBpos + 1 to Length;
      select;
         when %subst(String:Counter:1) = '(';
            Brackets += 1;
         when %subst(String:Counter:1) = ')';
            Brackets -= 1;
         when %subst(String:Counter:1) = ':' and Brackets = 0;
            SCpos = Counter;
            leave;
      endsl;
   endfor;

   return SCpos;
end-proc;

//------------------------------------------------------------------------------------ //
//GetDataType:                                                                         //
//------------------------------------------------------------------------------------ //
dcl-proc GetDataType export;

   dcl-pi GetDataType char(10);
      In_datatype char(1) const;
      In_decpos   char(2) const;
      In_length   char(7) const;
   end-pi;

   dcl-s DataType char(10) inz;

   If In_datatype = *Blanks;                                                            //VP01
      clear DataType;                                                                   //VP01
   EndIf;                                                                               //VP01

   select;
      when In_datatype = 'A';
         DataType = 'CHAR';
      when In_datatype = 'B';
         DataType = 'BIN';
      when In_datatype = 'D';
         DataType = 'DATE';
      when In_datatype = 'F';
         DataType = 'FLOAT';
      when In_datatype = 'G';
         DataType = 'GRAPH';
      when In_datatype = 'I';
         DataType = 'SIGNINT';
      when In_datatype = 'N';
         DataType = 'IND';
      when In_datatype = 'P';
         DataType = 'PACKED';
      when In_datatype = 'S';
         DataType = 'ZONED';
      when In_datatype = 'T';
         DataType = 'TIME';
      when In_datatype = 'U';
         DataType = 'UNSIGNINT';
      when In_datatype = 'Z';
         DataType = 'TMST';
      when In_datatype = '*';
         DataType = 'POINTER';
      when In_datatype = 'O';
         DataType = 'OBJECT';
      when In_datatype = ' ';
         select;
            when In_decpos = *blanks and In_length = *blanks;
               DataType = ' ';
            when In_decpos = '  ';
               DataType = 'CHAR';
            other;
               DataType = 'PACKED';
         endsl;
      other;
         DataType = 'UNDEF';
   endsl;

   return DataType;
end-proc;

//------------------------------------------------------------------------------------ //
//GetSeqNumber:                                                                        //
//------------------------------------------------------------------------------------ //
dcl-proc GetSeqNumber export;

   dcl-pi GetSeqNumber packed(5);
      LibraryName   char(10)  const;
      SourceFile    char(10)  const;
      MemberName    char(10)  const;
      IfsLocation   char(100) const;                                                    //0062
      PrPiFlag      char(2)   const;
      ProcedureName char(128) const;
      ParameterName char(128) options(*NoPass) const;
   end-pi;

   dcl-s sequence packed(5) inz;

   select;
   // when %parms = 5;                                                                  //0062
      when %parms = 6;                                                                  //0062
         exec sql
            select PPRSEQ
              into :Sequence
              from IaPrcParm
            where   PLIBNAM  = :LibraryName
              and   PSRCPF   = :SourceFile
              and   PMBRNAM  = :MemberName
              and   PIFSLOC  = :IfsLocation                                             //0062
              and PPRPIFLG = :PrPiFlag
              and PPRNAM   = :ProcedureName
            fetch first row only;

         if SQLSTATE <> SQL_ALL_OK;
            //log error
         endif;

         if SQLCODE = 100;
            exec sql
               select Coalesce(max(PPRSEQ),0)
                  into :Sequence
                  from IaPrcParm
               where   PLIBNAM  = :LibraryName
                 and   PSRCPF   = :SourceFile
                 and   PMBRNAM  = :MemberName
                 and   PIFSLOC  = :IfsLocation                                           //0062
                 and PPRPIFLG = :PrPiFlag
               fetch first row only;

            if SQLSTATE <> SQL_ALL_OK;
               //log error
            endif;

            select;
               when SQLCODE = 0;
                  Sequence += 1;
               when SQLCODE = 100;
                  Sequence = 1;
               when SQLCODE = -305;
                  Sequence = 1;
            endsl;
         endif;

  //  when %Parms = 6;                                                                   //0062
      when %Parms = 7;                                                                   //0062
         exec sql
            select PPRSEQ
               into :Sequence
               from IaPrcParm
            where   PLIBNAM  = :LibraryName
              and   PSRCPF   = :SourceFile
              and   PMBRNAM  = :MemberName
              and   PIFSLOC  = :IfsLocation                                              //0062
              and PPRPIFLG = :PrPiFlag
              and PPRNAM   = :ProcedureName
            fetch first row only;

         if SQLSTATE <> SQL_ALL_OK;
            //log error
         endif;

         select;
            when SQLCODE = 100;
               Sequence = 1;
            when SQLCODE = 0 Or SQLCODE = -811;
               exec sql
                  select Coalesce(max(PPRMSEQ),0)
                     into :Sequence
                     from IaPrcParm
                  where   PLIBNAM  = :LibraryName
                    and   PSRCPF   = :SourceFile
                    and   PMBRNAM  = :MemberName
                    and   PIFSLOC  = :IfsLocation                                        //0062
                    and PPRPIFLG = :PrPiFlag
                    and PPRNAM   = :ProcedureName
                  fetch first row only;

               if SQLSTATE <> SQL_ALL_OK;
                  //log error
               endif;

               select;
                  when SQLCODE = 0;
                     Sequence += 1;
                  when SQLCODE = 100;
                     Sequence = 1;
                  when SQLCODE = -305;
                     Sequence = 1;
               endsl;
         endsl;
   endsl;

   return Sequence;
end-proc;

//------------------------------------------------------------------------------------ //
//IaPQuote:                                                                            //
//------------------------------------------------------------------------------------ //
dcl-proc IaPQuote export;

   dcl-pi IaPQuote;
      in_string  char(5000);
      in_Postion packed(5:0);
      in_flag    char(1);
   end-pi;

   dcl-s arrayquotesign packed(5:0) inz dim(50);
   dcl-s tempArray      packed(5:0) dim(50) ascend inz;
   dcl-s QuotePos       packed(5:0) inz;
   dcl-s frompos        packed(5:0) inz;
   dcl-s length         packed(5:0) inz;
   dcl-s i              int(5)      inz;
   dcl-s j              int(5)      inz;
   dcl-s index          int(5)      inz;
   dcl-s itr            int(5)      inz;
   dcl-s loop           int(5)      inz;

   If in_string = *Blanks;                                                              //VP01
      return;                                                                           //VP01
   EndIf;                                                                               //VP01

   length  = %len(%trim(In_string));
   In_flag = 'N';
   QuotePos = %scan('"' : In_string);
   i = 0;
   frompos = 1;
   dow QuotePos > 0 and i < %elem(arrayquotesign);
      i+=1;
      arrayquotesign(i) = QuotePos;
      fromPos = QuotePos + 1;
      if Frompos > length;
         leave;
      else;
         QuotePos = %scan('"' : In_string:fromPos);
      endif;
   enddo;

   clear tempArray;
   sorta arrayquotesign;
   tempArray = arrayquotesign;
   clear arrayquotesign;
   clear itr;
   index = 0;
   loop = %Lookupgt(*Zeros:tempArray);                                                  //SS01
   If loop <> *Zeros;
    for itr = Loop to %elem(arrayquotesign);
      if tempArray(itr) <> *zero;
         index += 1;
         arrayquotesign(index) = tempArray(itr);
      endif;
    endfor;
   Endif;

   j = 1;
   dow j <> i+1;
      if arrayquotesign(j)> in_Postion;
         if %rem(j:2) <> 0;
            In_flag = 'N';
            leave;
         else;
            In_flag = 'Y';
            leave;
         endif;
      endif;
      j += 1;
   enddo;

   return;
end-proc;

//------------------------------------------------------------------------------------ //
//RunCommand:                                                                          //
//------------------------------------------------------------------------------------ //
dcl-proc RunCommand export;

   dcl-pi *N;
      Command char(1000) options(*varsize) const;
      uwerror char(1);
   end-pi;

   clear uwerror;
   monitor;
      qcmdexc(%trim(Command) :%len(%trim(Command)));
   on-error;
      uwerror = 'Y';
   endmon;

end-proc;

//------------------------------------------------------------------------------------ //
//IaPrCrtObj:                                                                         //
//------------------------------------------------------------------------------------ //
dcl-proc IaPrCrtObj export;

   dcl-pi *n;
      in_ParmPointer pointer;
   end-pi;

   dcl-ds w_ParmDS qualified based(in_ParmPointer);
      w_String     char(5000);
      w_Error      char(10);
      w_Repository char(10);
      w_SrcLib     char(10);
      w_SrcPf      char(10);
      w_SrcMbr     char(10);
      w_RRNStr     packed(6:0);
      w_RRNEnd     packed(6:0);
   end-ds;

   dcl-ds w_IAPGMFILES extName('IAPGMFILES') qualified inz end-ds;

   dcl-s w_ClStatement char(5000) inz;
   dcl-s w_WordsArray  char(120)  inz    dim(100);
   dcl-s w_FileName    char(100)  inz;
   dcl-s w_count       zoned(4:0) inz(1);
   dcl-s w_FlagFromLib zoned(4:0) inz(1);
   dcl-s w_FlagToLib   zoned(4:0) inz;
   dcl-s w_FlagEnd     zoned(4:0) inz;

   clear w_IAPGMFILES;
   w_ClStatement          = w_ParmDS.w_String;
   w_IAPGMFILES.IAMBRNAME = w_ParmDS.w_SrcMbr;                                           //0061
   w_IAPGMFILES.IASRCFILE = w_ParmDS.w_SrcPf;                                            //0061
   w_IAPGMFILES.IALIBNAM  = w_ParmDS.w_SrcLib;                                           //0061

   GetWordsInArray(w_ClStatement : w_WordsArray);
   w_Count = w_Count + 2;

   If %scan('OBJTYPE(*FILE)': w_ClStatement) > 0;                                        //0026

      w_IAPGMFILES.IAACTFILE = ScanKeyWord(' OBJ(':w_ClStatement);                       //0061
      if w_IAPGMFILES.IAACTFILE = *blanks;                                               //0061
         w_IAPGMFILES.IAACTFILE = w_WordsArray(w_Count);                                 //0061
      endif;

      w_FileName = w_IAPGMFILES.IAACTFILE;                                               //0061
      if %scan('/':w_FileName) > 0
         and %len(w_Filename) - %scan('/':w_FileName) > 0;
         w_IAPGMFILES.IAACTFILE = %subst(w_FileName:                                     //0061
                                 %scan('/':w_FileName)+1:
                                 %len(w_Filename) -
                                 %scan('/':w_Filename));
      endif;

    //exec sql                                                                           //0063
    //   insert into IAPGMFILES (IALIBNAM,                                         //0063//0061
    //                           IASRCFILE,                                        //0063//0061
    //                           IAMBRNAME,                                        //0063//0061
    //                           IAACTFILE,                                        //0063//0061
    //                           IAACTRCDNM)                                       //0063//0061
    //      values(trim(:w_IAPGMFILES.IALIBNAM),                                   //0063//0061
    //             trim(:w_IAPGMFILES.IASRCFILE),                                  //0063//0061
    //             trim(:w_IAPGMFILES.IAMBRNAME),                                  //0063//0061
    //             trim(:w_IAPGMFILES.IAACTFILE),                                  //0063//0061
    //             trim(:w_IAPGMFILES.IAACTRCDNM));                                //0063//0061

    //if SQLSTATE <> SQL_ALL_OK;                                                   //0063
    //   //log error                                                              //0063
    //endif;                                                                       //0063

      w_IAPGMFILES.IAACTFILE = *blanks;                                                  //0061
      w_IAPGMFILES.IAACTFILE = ScanKeyWord(' NEWOBJ(':w_ClStatement);                    //0061

      If w_IAPGMFILES.IAACTFILE <> *Blanks;                                              //0061

         w_FileName = w_IAPGMFILES.IAACTFILE;                                            //0061
         If %scan('(':w_FileName) > 0 and %len(w_Filename) > 1                           //0026
            and (%len(w_Filename)- 1) > %scan('(':w_FileName);                           //0026
                w_IAPGMFILES.IAACTFILE = %subst(w_FileName:                              //0061
                                        %scan('(':w_FileName)+ 1:                        //0026
                                        (%len(w_Filename) - 1) -                         //0026
                                        %scan('(':w_Filename));                          //0026
         EndIf;                                                                          //0026
                                                                                         //0026
       //exec sql                                                                  //0063//0026
       //      insert into IAPGMFILES (IALIBNAM,                                   //0063//0061
       //                              IASRCFILE,                                  //0063//0061
       //                              IAMBRNAME,                                  //0063//0061
       //                              IAACTFILE,                                  //0063//0061
       //                              IAACTRCDNM)                                 //0063//0061
       //         values(trim(:w_IAPGMFILES.IALIBNAM),                             //0063//0061
       //                trim(:w_IAPGMFILES.IASRCFILE),                            //0063//0061
       //                trim(:w_IAPGMFILES.IAMBRNAME),                            //0063//0061
       //                trim(:w_IAPGMFILES.IAACTFILE),                            //0063//0061
       //                trim(:w_IAPGMFILES.IAACTRCDNM));                          //0063//0061
                                                                                         //0026
       //If SQLSTATE <> SQL_ALL_OK;                                                //0063//0026
       //   //log error                                                           //0063
       //EndIf;                                                                    //0063//0026
      EndIf;                                                                             //0026
                                                                                         //0026
      if w_FlagFromLib = 1;
         w_FlagFromLib = 0;
         w_FlagToLib = 1;
      endif;

   EndIf;                                                                                //0026

   return;
end-proc;

//------------------------------------------------------------------------------------ //
//FindCbr:                                                                             //
//------------------------------------------------------------------------------------ //
dcl-proc FindCbr export;

   dcl-pi FindCbr;
      br_pos    packed(6:0);
      br_string char(5000);
   end-pi;

   dcl-s br_InQuote char(1)     inz;
   dcl-s bracket    packed(6:0) inz;
   dcl-s br_spos    packed(6:0) inz;
   dcl-s br_epos    packed(6:0) inz;

   if br_string = *blanks;                                                     //PS02
      return;                                                                  //PS02
   endif;                                                                      //PS02

   bracket += 1;
   dow bracket > *zeros;
      br_spos = %scan('(' :br_string :br_pos+1);
      if br_spos > *zeros;
         InQuote(br_string :br_spos :br_InQuote);
         dow br_InQuote = 'Y';
            br_spos = %scan('(' :br_string :br_spos+1);
            if br_spos > 0;
               InQuote(br_string :br_spos :br_InQuote);
            else;
               br_InQuote = 'N';
            endif;
         enddo;
      endif;

      br_epos = %scan(')' :br_string :br_pos+1);
      if br_epos > *zeros;
         InQuote(br_string :br_epos :br_InQuote);
         dow br_InQuote = 'Y';
            br_epos = %scan(')' :br_string :br_epos+1);
            if br_epos > *zeros;
               InQuote(br_string :br_epos :br_InQuote);
            else;
               br_InQuote = 'N';
            endif;
         enddo;
      endif;

      if br_epos > *zeros;

        select;
           when br_spos > *zeros and br_spos < br_epos;
              bracket+=1;
              br_pos = %scan('(': br_string: br_pos+1);
              if br_pos > *zeros;
                 InQuote(br_string :br_pos :br_InQuote);
                 dow br_InQuote = 'Y';
                    br_pos = %scan('(': br_string: br_pos+1);
                    if br_pos > *zeros;
                       InQuote(br_string :br_pos :br_InQuote);
                    else;
                       br_InQuote = 'N';
                    endif;
                 enddo;
              endif;

           when br_epos > *zeros;
              bracket-=1;
              br_pos = %scan(')': br_string: br_pos+1);
              if br_pos > *zeros;
                 InQuote(br_string :br_pos :br_InQuote);
                 dow br_InQuote = 'Y';
                    br_pos = %scan(')': br_string: br_pos+1);
                    if br_pos > *zeros;
                       InQuote(br_string :br_pos :br_InQuote);
                    else;
                       br_InQuote = 'N';
                    endif;
                 enddo;
              endif;
        endsl;

      //Case when there is no closing bracket for given opening bracket
      elseif bracket <> *zeros;

         if %len(br_string) > %len(%trim(br_string));
            br_pos = %len(%trim(br_string)) + 1;
         else;
            br_pos = %len(br_string);
         endif;
         leave;
      endif;
   enddo;

   return;
end-proc;

//------------------------------------------------------------------------------------ //
//RmvBrackets:                                                                         //
//------------------------------------------------------------------------------------ //
dcl-proc RmvBrackets export;

   dcl-pi RmvBrackets varchar(5000);
      rmv_string varchar(5000) value options(*trim);
   end-pi;

   dcl-s r_string  char(5000)  inz;
   dcl-s r_bracket packed(4:0) inz;
   dcl-s r_Spos    packed(6:0) inz;
   dcl-s r_length  packed(6:0) inz;

   r_length = %len(%trim(rmv_string));
   dow %scan('(' : rmv_string : 1) = 1;
      r_string = %trim(rmv_string);
      r_spos = 1;
      FindCbr(r_spos :r_string);
      if r_spos <> r_length;
         leave;
      else;
         if r_length > 2;
          //rmv_string = %subst(%trim(rmv_string):2:r_length-2);                         //OJ01
          rmv_string = %subst(rmv_string:2:r_length-2);                                  //OJ01
         endif;
         r_length -= 2;
      endif;
   enddo;

   //return %trim(rmv_string);                                                           //OJ01
   return rmv_string;                                                                    //OJ01
end-proc;

//------------------------------------------------------------------------------------ //
//IaPsrIsPCV:                                                                          //
//------------------------------------------------------------------------------------ //
dcl-proc IaPsrIsPCV export;
   dcl-pi IaPsrIsPCV;
      in_string char(5000);
      in_type   char(10);
      in_error  char(10);
      in_xref   char(10);
   // in_srclib char(10);                                                                //0062
   // in_srcspf char(10);                                                                //0062
   // in_srcmbr char(10);                                                                //0062
      in_uWSrcDtl likeds(uWSrcDtl);                                                      //0062
      in_rrns   packed(6:0);
      in_rrne   packed(6:0);
   end-pi;

   dcl-s I_Data_Typ char(10)    inz;
   dcl-s I_String   char(243)   inz;
   dcl-s I_xref     char(10)    inz;
   dcl-s I_srclib   char(10)    inz;
   dcl-s I_srcspf   char(10)    inz;
   dcl-s I_srcmbr   char(10)    inz;
   dcl-s I_IfsLoc   char(100)   inz;                                                     //0062
   dcl-s I_Pwrdobjv char(10)    inz;
   dcl-s I_Objvref  char(10)    inz;
   dcl-s I_attr     char(10)    inz;
   dcl-s I_mody     char(10)    inz;
   dcl-s I_sts      char(10)    inz;
   dcl-s I_varname  char(128)   inz;
   dcl-s I_varnam   char(80)    inz;
   dcl-s ID_Keynam  char(20)    inz;
   dcl-s ID_Keyval  char(40)    inz;
   dcl-s ID_Type    char(10)    inz;
   dcl-s opc_name   char(10)    inz;                                                     //YK10
   dcl-s I_rrns     packed(6:0) inz;
   dcl-s I_rrne     packed(6:0) inz;
   dcl-s I_seq      packed(6:0) inz;
   dcl-s ID_VARlen  packed(8:0) inz;
   dcl-s ID_VARdec  packed(2:0) inz;
   dcl-s w_dsflag      char(1) inz('N');                                                 //TK01
   dcl-s ds_position   packed(2:0) inz;                                                  //TK01
   dcl-ds iavarrelDS extname('IAVARREL') prefix(lk_) inz;                                //TK01
   end-ds;                                                                               //TK01

   uwsrcdtl = In_uwsrcdtl;                                                               //0062

   I_string   = in_string;
   I_xref     = in_xref;
   I_srclib   = in_srclib;
   I_srcspf   = in_srcspf;
   I_srcmbr   = in_srcmbr;
   I_IfsLoc   = in_IfsLoc;                                                               //0062
   I_rrns     = in_rrns;
   I_rrne     = in_rrne;
   if i_String <> *blanks;
      I_Varname  = %trim(%subst(I_STRING:53:6));
      I_Varnam   = %trim(%subst(I_STRING:53:6));
   endif;
   I_pwrdobjv = 'S_VAR';
   ID_Type    = 'PG';
   I_attr     = 'LIKE';

   select;                                                                               //YK10
   when %Scan(' DS ':I_string:18) = 18;                                                  //TK01
      I_Varname  = %trim(%subst(I_STRING:7:6));                                          //YK10
      w_dsflag = 'Y';                                                                    //YK10
   when %Scan(' ':I_string:43) = 43;                                                     //YK10
      exec sql                                                                           //YK10
        SELECT opcode_name                                                               //YK10
        INTO :opc_name                                                                   //YK10
        FROM IAVARREL                                                                    //YK10
        WHERE   LIBRARY_NAME = :I_srclib                                                 //YK10
          and   SRC_PF_NAME  = :I_srcspf                                                 //YK10
          and   MEMBER_NAME  = :I_srcmbr                                                 //YK10
          and   IFS_LOCATION = :I_ifsloc                                                 //YK10 0062
          and SOURCE_RRN   < :I_rrns                                                     //YK10
        ORDER BY SOURCE_RRN desc                                                         //YK10
        limit 1;                                                                         //YK10
      if opc_name = 'DCL-DS';                                                            //YK10
         w_dsflag = 'Y';                                                                 //YK10
         I_Varname  = %trim(%subst(I_STRING:53:6));                                      //TK01
      endIf;                                                                             //YK10
   endSl;

   ID_Keynam = 'LIKE';
   ID_Keyval = %trim(%subst(I_STRING:21:10));

   exec sql
     insert into IAPGMVARS (IAVMBR,
                            IAVSFILE,
                            IAVLIB,
                            IAVIFSLOC,                                                   //0062
                            IAVVAR,
                            IAVDTYP,
                            IAVLEN,
                            IAVDEC,
                            IAVTYP,
                            IAVKWDNM,
                            IAVKWVAL)
       values(:I_srcmbr,
              :I_srcspf,
              :I_srclib,
              :I_IfsLoc,                                                                 //0062
              :I_varnam,
              :I_Data_Typ,
              :ID_Varlen,
              :ID_vardec ,
              :ID_Type,
              :ID_Keynam,
              :ID_Keyval);

   if SQLSTATE <> SQL_ALL_OK;
      //log error
   endif;

      //Insert record in IAVAREREL file                                                 //TK01
   if w_dsflag = 'Y';                                                                    //TK01
      lk_REOPC    = 'DCL-DS';                                                            //TK01
      w_dsflag = 'N';                                                                    //TK01
   else;                                                                                 //TK01
      lk_reopc   = 'DCLVAR';                                                             //TK01
   endif;                                                                                //TK01
   IaVarRelLog(in_srclib:                                                                //TK01
               in_srcspf:                                                                //TK01
               in_srcmbr:                                                                //TK01
               in_IfsLoc:                                                                //0062
               lk_reseq:                                                                 //TK01
               in_rrne:                                                                  //TK01
               lk_reroutine:                                                             //TK01
               lk_rereltyp:                                                              //TK01
               lk_rerelnum:                                                              //TK01
               lk_reopc:                                                                 //TK01
               lk_reresult:                                                              //TK01
               lk_rebif:                                                                 //TK01
               I_varname:                                                                //TK01
               lk_recomp:                                                                //TK01
               lk_refact2:                                                               //TK01
               lk_recontin:                                                              //TK01
               lk_reresind:                                                              //TK01
               lk_recat1:                                                                //TK01
               lk_recat2:                                                                //TK01
               lk_recat3:                                                                //TK01
               lk_recat4:                                                                //TK01
               lk_recat5:                                                                //TK01
               lk_recat6:                                                                //TK01
               lk_reutil:                                                                //TK01
               lk_renum1:                                                                //TK01
               lk_renum2:                                                                //TK01
               lk_renum3:                                                                //TK01
               lk_renum4:                                                                //TK01
               lk_renum5:                                                                //TK01
               lk_renum6:                                                                //TK01
               lk_renum7:                                                                //TK01
               lk_renum8:                                                                //TK01
               lk_renum9:                                                                //TK01
               lk_reexc:                                                                 //TK01
               lk_reinc);                                                                //TK01

   return;
end-proc;

//------------------------------------------------------------------------------------ //
//IaPsrIsPCC:                                                                          //
//------------------------------------------------------------------------------------ //
dcl-proc IaPsrIsPCC export;
   dcl-pi IaPsrIsPCC;
      in_string char(5000);
      in_type   char(10);
      in_error  char(10);
      in_xref   char(10);
   // in_srclib char(10);                                                                //0062
   // in_srcspf char(10);                                                                //0062
   // in_srcmbr char(10);                                                                //0062
      in_uWSrcDtl likeds(uWSrcDtl);                                                      //0062
      in_rrns   packed(6:0);
      in_rrne   packed(6:0);
   end-pi;

   dcl-s I_Data_Typ char(10)    inz;
   dcl-s I_String   char(243)   inz;
   dcl-s I_xref     char(10)    inz;
   dcl-s I_srclib   char(10)    inz;
   dcl-s I_srcspf   char(10)    inz;
   dcl-s I_srcmbr   char(10)    inz;
   dcl-s I_IfsLoc   char(100)   inz;                                                     //0062
   dcl-s I_Pwrdobjv char(10)    inz;
   dcl-s I_Objvref  char(10)    inz;
   dcl-s I_attr     char(10)    inz;
   dcl-s I_mody     char(10)    inz;
   dcl-s I_sts      char(10)    inz;
   dcl-s I_varname  char(128)   inz;
 //dcl-s I_varnam   char(80)    inz;                                                      //YK05
   dcl-s ID_Keynam  char(20)    inz;
   dcl-s ID_Keyval  char(40)    inz;
   dcl-s ID_Type    char(10)    inz;
   dcl-s I_rrns     packed(6:0) inz;
   dcl-s I_rrne     packed(6:0) inz;
   dcl-s I_seq      packed(6:0) inz;
   dcl-s ID_VARlen  packed(8:0) inz;
   dcl-s ID_VARdec  packed(2:0) inz;

   uwsrcdtl = In_uwsrcdtl;                                                               //0062

   I_string   = in_string;
   I_xref     = in_xref;
   I_srclib   = in_srclib;
   I_srcspf   = in_srcspf;
   I_srcmbr   = in_srcmbr;
   I_IfsLoc   = in_IfsLoc;                                                               //0062
   I_rrns     = in_rrns;
   I_rrne     = in_rrne;
   if i_String <> *blanks;
      I_Varname  = %trim(%subst(I_STRING:53:6));
   // I_Varnam   = %trim(%subst(I_STRING:53:6));                                         //YK05
   endif;
   I_pwrdobjv = 'C_VAR';
   I_attr     = 'Const';
   ID_Type    = 'Const';


   ID_Keynam = 'Const';
   ID_Keyval = %trim(%subst(I_STRING:21:22));

   exec sql
     insert into IAPGMVARS (IAVMBR,
                            IAVSFILE,
                            IAVLIB,
                            IAVIFSLOC,                                                   //0062
                            IAVVAR,
                            IAVDTYP,
                            IAVLEN,
                            IAVDEC,
                            IAVTYP,
                            IAVKWDNM,
                            IAVKWVAL)
       values(:I_srcmbr,
              :I_srcspf,
              :I_srclib,
              :I_IfsLoc,                                                                  //0062
        //    :I_varnam,                                                                  //YK05
              :I_varname,                                                                 //YK05
              :I_Data_Typ,
              :ID_Varlen,
              :ID_vardec ,
              :ID_Type,
              :ID_Keynam,
              :ID_Keyval);

   if SQLSTATE <> SQL_ALL_OK;
      //log error
   endif;

   return;
end-proc;

//------------------------------------------------------------------------------------ //
//IaPsrDEFfx:                                                                          //
//------------------------------------------------------------------------------------ //
dcl-proc IaPsrDEFfx Export;
   dcl-pi IaPsrDEFfx;
      in_string char(5000);
      in_type   char(10);
      in_error  char(10);
      in_xref   char(10);
   // in_srclib char(10);                                                                //0062
   // in_srcspf char(10);                                                                //0062
   // in_srcmbr char(10);                                                                //0062
      in_uWSrcDtl likeds(uWSrcDtl);                                                      //0062
      in_rrns   packed(6:0);
      in_rrne   packed(6:0);
   end-pi;

   dcl-s O_Data_Typ char(10)    inz;
   dcl-s O_String   char(243)   inz;
   dcl-s O_xref     char(10)    inz;
   dcl-s O_srclib   char(10)    inz;
   dcl-s O_srcspf   char(10)    inz;
   dcl-s O_srcmbr   char(10)    inz;
   dcl-s O_IfsLoc   char(100)   inz;                                                     //0062
   dcl-s O_Pwrdobjv char(10)    inz;
   dcl-s O_Objvref  char(10)    inz;
   dcl-s O_attr     char(10)    inz;
   dcl-s O_mody     char(10)    inz;
   dcl-s O_sts      char(10)    inz;
   dcl-s O_varname  char(128)   inz;
   dcl-s O_varnam   char(80)    inz;
   dcl-s OD_Keynam  char(20)    inz;
   dcl-s OD_Keyval  char(40)    inz;
   dcl-s OD_Type    char(10)    inz;
   dcl-s O_rrns     packed(6:0) inz;
   dcl-s O_rrne     packed(6:0) inz;
   dcl-s O_seq      packed(6:0) inz;
   dcl-s OD_VARlen  packed(8:0) inz;
   dcl-s OD_VARdec  packed(2:0) inz;

   uwsrcdtl = In_uwsrcdtl;                                                               //0062

   O_string   = in_string;
   O_xref     = in_xref;
   O_srclib   = in_srclib;
   O_srcspf   = in_srcspf;
   O_srcmbr   = in_srcmbr;
   O_IfsLoc   = in_IfsLoc;                                                               //0062
   O_rrns     = in_rrns;
   O_rrne     = in_rrne;
   if o_String <> *blanks;
      O_Varname  = %trim(%subst(O_STRING:50:14));
      O_Varnam   = %trim(%subst(O_STRING:50:14));
   endif;
   O_pwrdobjv = 'S_VAR';
   OD_Type    = 'PG';
   O_attr     = 'LIKE';
   O_sts      = *blanks;
   O_objvref  = *blanks;
   O_seq      = 0;


   OD_Keynam = 'LIKE';
   OD_Keyval = %trim(%subst(O_STRING:36:14));

   exec sql
     insert into IAPGMVARS (IAVMBR,
                            IAVSFILE,
                            IAVLIB,
                            IAVIFSLOC,                                                   //0062
                            IAVVAR,
                            IAVDTYP,
                            IAVLEN,
                            IAVDEC,
                            IAVTYP,
                            IAVKWDNM,
                            IAVKWVAL)
       values(:O_srcmbr,
              :O_srcspf,
              :O_srclib,
              :O_IfsLoc,                                                                 //0062
              :O_varnam,
              :O_Data_Typ,
              :OD_Varlen,
              :OD_vardec,
              :OD_Type,
              :OD_Keynam,
              :OD_Keyval);

   if SQLSTATE <> SQL_ALL_OK;
      //log error
   endif;

   return;
end-proc;

//------------------------------------------------------------------------------------ //
//IaPsrDEFfx3:                                                                         //
//------------------------------------------------------------------------------------ //
dcl-proc IaPsrDEFfx3 Export;
   dcl-pi IaPsrDEFfx3;
      in_string char(5000);
      in_type   char(10);
      in_error  char(10);
      in_xref   char(10);
   // in_srclib char(10);                                                                //0062
   // in_srcspf char(10);                                                                //0062
   // in_srcmbr char(10);                                                                //0062
      in_uWSrcDtl likeds(uWSrcDtl);                                                      //0062
      in_rrns   packed(6:0);
      in_rrne   packed(6:0);
   end-pi;

   dcl-s O_Data_Typ char(10)    inz;
   dcl-s O_String   char(243)   inz;
   dcl-s O_xref     char(10)    inz;
   dcl-s O_srclib   char(10)    inz;
   dcl-s O_srcspf   char(10)    inz;
   dcl-s O_srcmbr   char(10)    inz;
   dcl-s O_IfsLoc   char(100)   inz;                                                     //0062
   dcl-s O_Pwrdobjv char(10)    inz;
   dcl-s O_Objvref  char(10)    inz;
   dcl-s O_attr     char(10)    inz;
   dcl-s O_mody     char(10)    inz;
   dcl-s O_sts      char(10)    inz;
   dcl-s O_varname  char(128)   inz;
   dcl-s O_varnam   char(80)    inz;
   dcl-s OD_Keynam  char(20)    inz;
   dcl-s OD_Keyval  char(40)    inz;
   dcl-s OD_Type    char(10)    inz;
   dcl-s O_rrns     packed(6:0) inz;
   dcl-s O_rrne     packed(6:0) inz;
   dcl-s O_seq      packed(6:0) inz;
   dcl-s OD_VARlen  packed(8:0) inz;
   dcl-s OD_VARdec  packed(2:0) inz;

   uwsrcdtl = In_uwsrcdtl;                                                               //0062

   O_string   = in_string;
   O_xref     = in_xref;
   O_srclib   = in_srclib;
   O_srcspf   = in_srcspf;
   O_srcmbr   = in_srcmbr;
   O_IfsLoc   = in_IfsLoc;                                                               //0062
   O_rrns     = in_rrns;
   O_rrne     = in_rrne;
   if o_String <> *blanks;
      O_Varname  = %trim(%subst(O_STRING:43:6));
      O_Varnam   = %trim(%subst(O_STRING:43:6));
   endif;
   O_pwrdobjv = 'S_VAR';
   OD_Type    = 'PG';
   O_attr     = 'LIKE';
   O_sts      = *blanks;
   O_objvref  = *blanks;


   OD_Keynam = 'LIKE';
   OD_Keyval = %trim(%subst(O_STRING:33:10));

   exec sql
     insert into IAPGMVARS (IAVMBR,
                            IAVSFILE,
                            IAVLIB,
                            IAVIFSLOC,                                                   //0062
                            IAVVAR,
                            IAVDTYP,
                            IAVLEN,
                            IAVDEC,
                            IAVTYP,
                            IAVKWDNM,
                            IAVKWVAL)
       values(:O_srcmbr,
              :O_srcspf,
              :O_srclib,
              :O_IfsLoc,                                                                 //0062
              :O_varnam,
              :O_Data_Typ,
              :OD_Varlen,
              :OD_vardec,
              :OD_Type,
              :OD_Keynam,
              :OD_Keyval);

   if SQLSTATE <> SQL_ALL_OK;
      //log error
   endif;

   return;
end-proc;

//------------------------------------------------------------------------------------ //
//IaPsrOPCfx:                                                                          //
//------------------------------------------------------------------------------------ //
dcl-proc IaPsrOPCfx export;
   dcl-pi IaPsrOPCfx;
      in_string char(5000);
      in_type   char(10);
      in_error  char(10);
      in_xref   char(10);
   // in_srclib char(10);                                                                //0062
   // in_srcspf char(10);                                                                //0062
   // in_srcmbr char(10);                                                                //0062
      in_uWSrcDtl likeds(uWSrcDtl);                                                      //0062
      in_rrns   packed(6:0);
      in_rrne   packed(6:0);
   end-pi;

   dcl-s O_Length   char(10)    inz;
   dcl-s O_Varlen   char(10)    inz;
   dcl-s O_DECPOS   char(10)    inz;
   dcl-s O_Data_Typ char(10)    inz;
   dcl-s O_String   char(243)   inz;
   dcl-s O_xref     char(10)    inz;
   dcl-s O_srclib   char(10)    inz;
   dcl-s O_srcspf   char(10)    inz;
   dcl-s O_srcmbr   char(10)    inz;
   dcl-s O_IfsLoc   char(100)   inz;                                                     //0062
   dcl-s O_Pwrdobjv char(10)    inz;
   dcl-s O_Objvref  char(10)    inz;
   dcl-s O_attr     char(10)    inz;
   dcl-s O_mody     char(10)    inz;
   dcl-s O_sts      char(10)    inz;
   dcl-s O_varname  char(128)   inz;
   dcl-s O_varnam   char(80)    inz;
   dcl-s OD_Keynam  char(20)    inz;
   dcl-s OD_Keyval  char(40)    inz;
   dcl-s OD_Type    char(10)    inz;
   dcl-s O_rrns     packed(6:0) inz;
   dcl-s O_rrne     packed(6:0) inz;
   dcl-s O_seq      packed(6:0) inz;
   dcl-s OD_VARlen  packed(8:0) inz;
   dcl-s OD_VARdec  packed(2:0) inz;

   uwsrcdtl = In_uwsrcdtl;                                                               //0062

   O_string  =  in_string;
   O_xref    =  in_xref;
   O_srclib  =  in_srclib;
   O_srcspf  =  in_srcspf;
   O_srcmbr  =  in_srcmbr;
   O_IfsLoc   = in_IfsLoc;                                                               //0062
   O_rrns    =  in_rrns;
   O_rrne    =  in_rrne;

   exsr Opcd_calculatefx;

   O_pwrdobjv  = 'S_VAR';
   OD_Type     = 'PG';
   O_attr      = O_Data_Typ;
   O_mody      = O_Length;
   O_sts       = *blanks;
   O_objvref   = *blanks;


   if O_Varlen <> *blanks ;
      if %check(DIGITS1 :%trim(O_Varlen)) = 0 ;
         OD_Varlen  =  %dec(O_Varlen:8:0);
      endif;
   endif;

   if O_DECPOS <> *blanks;
      if %check(DIGITS1 :%trim(O_DECPOS)) = 0;
         OD_Vardec  = %dec(O_DECPOS:2:0);
      endif;
   endif;

   OD_Keynam = *blanks;
   OD_Keyval = *blanks;

   exec sql
     insert into IAPGMVARS (IAVMBR,
                            IAVSFILE,
                            IAVLIB,
                            IAVIFSLOC,                                                   //0062
                            IAVVAR,
                            IAVDTYP,
                            IAVLEN,
                            IAVDEC,
                            IAVTYP)
       values(:O_srcmbr,
              :O_srcspf,
              :O_srclib,
              :O_IfsLoc,                                                                 //0062
              :O_varnam,
              :O_Data_Typ,
              :OD_Varlen,
              :OD_vardec,
              :OD_Type);

   if SQLSTATE <> SQL_ALL_OK;
      //log error
   endif;

   return;

   begsr Opcd_calculatefx;

      O_Varlen  = %subst(O_STRING:64:5);
      O_DECPOS  = %subst(O_STRING:69:2);
      O_Varname  = %trim(%subst(O_STRING:50:14));
      O_Varnam   = %trim(%subst(O_STRING:50:14));

      if %subst(O_STRING:64:7) <> *blanks;
         if %subst(O_STRING:69:2) = *blanks;
            O_Data_Typ  = 'CHAR';
         else;
            O_Data_Typ  = 'DECIMAL';
         endif;

         if %subst(O_STRING:64:5) <> *blanks And
            %subst(O_STRING:69:2) = *blanks;
            O_Length = %trim(%subst(O_STRING:64:5));
         endif;

         if %subst(O_STRING:64:5) <> *blanks and
            %subst(O_STRING:69:2) <> *blanks;
            O_Length = %trim(%subst(O_STRING:64:5)) +
            ',' + %trim(%subst(O_STRING:69:2));
         endif;
      endif;
   endsr;
end-proc;

//------------------------------------------------------------------------------------ //
//IaPsrOPCfx3:                                                                         //
//------------------------------------------------------------------------------------ //
dcl-proc IaPsrOPCfx3 export;
   dcl-pi IaPsrOPCfx3;
      in_string char(5000);
      in_type   char(10);
      in_error  char(10);
      in_xref   char(10);
   // in_srclib char(10);                                                                //0062
   // in_srcspf char(10);                                                                //0062
   // in_srcmbr char(10);                                                                //0062
      in_uWSrcDtl likeds(uWSrcDtl);                                                      //0062
      in_rrns   packed(6:0);
      in_rrne   packed(6:0);
   end-pi;

   dcl-s O_Length   char(10)    inz;
   dcl-s O_Varlen   char(10)    inz;
   dcl-s O_DECPOS   char(10)    inz;
   dcl-s O_Data_Typ char(10)    inz;
   dcl-s O_String   char(243)   inz;
   dcl-s O_xref     char(10)    inz;
   dcl-s O_srclib   char(10)    inz;
   dcl-s O_srcspf   char(10)    inz;
   dcl-s O_srcmbr   char(10)    inz;
   dcl-s O_IfsLoc   char(100)   inz;                                                     //0062
   dcl-s O_Pwrdobjv char(10)    inz;
   dcl-s O_Objvref  char(10)    inz;
   dcl-s O_attr     char(10)    inz;
   dcl-s O_mody     char(10)    inz;
   dcl-s O_sts      char(10)    inz;
   dcl-s O_varname  char(128)   inz;
   dcl-s O_varnam   char(80)    inz;
   dcl-s OD_Keynam  char(20)    inz;
   dcl-s OD_Keyval  char(40)    inz;
   dcl-s OD_Type    char(10)    inz;
   dcl-s O_seq      packed(6:0) inz;
   dcl-s O_rrns     packed(6:0) inz;
   dcl-s O_rrne     packed(6:0) inz;
   dcl-s OD_VARlen  packed(8:0) inz;
   dcl-s OD_VARdec  packed(2:0) inz;

   uwsrcdtl = In_uwsrcdtl;                                                               //0062

   O_string  =  in_string;
   O_xref    =  in_xref;
   O_srclib  =  in_srclib;
   O_srcspf  =  in_srcspf;
   O_srcmbr  =  in_srcmbr;
   O_IfsLoc   = in_IfsLoc;                                                               //0062
   O_rrns    =  in_rrns;
   O_rrne    =  in_rrne;

   exsr Opcd_calculatefx3;

   O_pwrdobjv  = 'S_VAR';
   OD_Type     = 'PG';
   O_attr      = O_Data_Typ;
   O_mody      = O_Length;
   O_sts       = *blanks;
   O_objvref   = *blanks;

   if O_Varlen <> *blanks ;
      if %check(DIGITS1 :%trim(O_Varlen)) = 0;
         OD_Varlen  =  %dec(O_Varlen:8:0);
      endif;
   endif;

   if O_DECPOS <> *blanks ;
      if %check(DIGITS1 :%trim(O_DECPOS)) = 0;
         OD_Vardec  = %dec(O_DECPOS:2:0);
      endif;
   endif;

   OD_Keynam = *blanks;
   OD_Keyval = *blanks;

   exec sql
     insert into IAPGMVARS (IAVMBR,
                            IAVSFILE,
                            IAVLIB,
                            IAVIFSLOC,                                                   //0062
                            IAVVAR,
                            IAVDTYP,
                            IAVLEN,
                            IAVDEC,
                            IAVTYP)
       values(:O_srcmbr,
              :O_srcspf,
              :O_srclib,
              :O_IfsLoc,                                                                 //0062
              :O_varnam,
              :O_Data_Typ,
              :OD_Varlen,
              :OD_vardec,
              :OD_Type);

   if SQLSTATE <> SQL_ALL_OK;
      //log error
   endif;

   return;

   begsr Opcd_calculatefx3;

      O_Varlen  = %subst(O_STRING:49:3);
      O_DECPOS  = %subst(O_STRING:52:1);
      O_Varname  = %trim(%subst(O_STRING:43:6));
      O_Varnam   = %trim(%subst(O_STRING:43:6));

      if %subst(O_STRING:49:4) <> *blanks;
         if %subst(O_STRING:52:1) = *blanks;
            O_Data_Typ  = 'CHAR';
         else;
            O_Data_Typ  = 'DECIMAL';
         endif;

         if %subst(O_STRING:49:3) <> *blanks and
            %subst(O_STRING:52:1) = *blanks;
            O_Length = %trim(%subst(O_STRING:49:3));
         endif;

         if %subst(O_STRING:49:3) <> *blanks and
            %subst(O_STRING:52:1) <> *blanks;
            O_Length = %trim(%subst(O_STRING:49:3)) +
                       ',' + %trim(%subst(O_STRING:52:1));
         endif;
      endif;

   endsr;
end-proc;

//------------------------------------------------------------------------------------ //
//IaPsrARRfr:                                                                          //
//------------------------------------------------------------------------------------ //
dcl-proc IaPsrARRfr export;
   dcl-pi IaPsrARRfr;
      in_string char(5000);
      in_type   char(10);
      in_error  char(10);
      in_xref   char(10);
   // in_srclib char(10);                                                                //0062
   // in_srcspf char(10);                                                                //0062
   // in_srcmbr char(10);                                                                //0062
      in_uWSrcDtl likeds(uWSrcDtl);                                                      //0062
      in_rrns   packed(6:0);
      in_rrne   packed(6:0);
   end-pi;

   dcl-s ar_PRMLEN   char(10)     inz;
   dcl-s ar_DECPOS   char(10)     inz;
   dcl-s ar_Type     char(10)     inz;
   dcl-s ar_Length   char(10)     inz;
   dcl-s ar_Data_Typ char(10)     inz;
   dcl-s ar_String   char(243)    inz;
   dcl-s w_IAV_TYP   char(10)     inz;
   dcl-s w_IAVKWDNM  char(20)     inz;
   dcl-s w_IAVKWVAL  char(40)     inz;
   dcl-s w_IAV_DATF  char(05)     inz;
   dcl-s ar_IAV_DIM  char(20)     inz;
   dcl-s ar_xref     char(10)     inz;
   dcl-s ar_srclib   char(10)     inz;
   dcl-s ar_srcspf   char(10)     inz;
   dcl-s ar_srcmbr   char(10)     inz;
   dcl-s ar_IfsLoc   char(100)    inz;                                                   //0062
   dcl-s ar_Pwrdobjv char(10)     inz;
   dcl-s ar_Objvref  char(10)     inz;
   dcl-s ar_attr     char(10)     inz;
   dcl-s ar_mody     char(10)     inz;
   dcl-s ar_sts      char(10)     inz;
   dcl-s ar_ArrName  char(128)    inz;
   dcl-s w_IAVVAR    char(80)     inz;
   dcl-s w_IAVDTYP   char(10)     inz;
   dcl-s ar_seq      packed(6:0)  inz;
   dcl-s w_IAV_DIM   packed(8:0)  inz;
   dcl-s ar_Pos      packed(5:0)  inz;
   dcl-s ar_Pos1     packed(5:0)  inz;
   dcl-s ar_Posdim   packed(5:0)  inz;
   dcl-s ar_Position packed(5:0)  inz;
   dcl-s ar_rrns     packed(6:0)  inz;
   dcl-s ar_rrne     packed(6:0)  inz;
   dcl-s w_IAVLEN    packed(8:0)  inz;
   dcl-s w_IAVDEC    packed(2:0)  inz;

   dcl-ds iavarrelDS extname('IAVARREL') prefix(w_) Inz;                                 //MT02
   end-ds;                                                                               //MT02

   uwsrcdtl = In_uwsrcdtl;                                                               //0062

   ar_string  =  in_string;
   ar_xref    =  in_xref;
   ar_srclib  =  in_srclib;
   ar_srcspf  =  in_srcspf;
   ar_srcmbr  =  in_srcmbr;
   ar_IfsLoc  =  in_IfsLoc;                                                                //0062
   ar_rrns    =  in_rrns;
   ar_rrne    =  in_rrne;

   if ar_rrne  = 0;
      ar_rrne  = ar_rrns;
   endif;

   if ar_String <> '';
      if %scan('DIM':ar_String) > 0;
         if %scan('CTDATA':ar_String) > 0;                                                 //MT04
            ar_Type = 'CT_ARR_VAR';
         endif;
         if %scan('FROMFILE':ar_String) > 0;                                               //MT04
            ar_Type = 'PT_ARR_VAR';
         endif;
         if %scan('CTDATA':ar_String) = 0 and                                              //MT04
            %scan('FROMFILE':ar_String) = 0;                                               //MT04
            ar_Type = 'RT_ARR_VAR';
         endif;
         ar_pwrdobjv  = Ar_Type;
         w_IAV_TYP    = %subst(Ar_Type:1:5);
         ar_Pos =  %scan('DCL-S':ar_string);
         ar_Pos = ar_Pos + 6;
         ar_Pos = %check(' ':ar_string:ar_Pos);
         if ar_Pos > 0;                                                                    //MT04
            ar_Pos1 = %scan(' ':ar_string:ar_Pos);
         endif;                                                                            //MT04
         if ar_Pos1 > ar_Pos;
            ar_Position = ar_Pos1 - ar_Pos;
         endif;
         If ar_pos > 0 and ar_Position > 0;                                                //SB04
            ar_Arrname = %subst(ar_string:ar_Pos:ar_Position);
         Endif;                                                                            //SB04
         w_IAVVAR = %trim(ar_Arrname);                                                     //SB04
         ar_posdim = ar_Pos1;
         if ar_posdim > 0 and %scan('LIKE':ar_string:ar_posdim) = 0;                       //MT04
            exsr Callengthdtatype;
            ar_attr      = Ar_Data_Typ;
            w_IAVDTYP    = Ar_Data_Typ;
            ar_mody      = ar_Length;
            if %scan(':':ar_Length) = 0;
               if %trim(ar_Length) <> *blanks;
                  if %check(DIGITS1 :%trim(ar_Length)) = 0;
                     w_IAVLEN = %dec(ar_Length:8:0);
                  endif;
               endif;
            else;
               if %scan(':':ar_Length) > 0;
                  ar_DECPOS = %trim(%subst(ar_Length:%scan(':':ar_Length) +1));
                  if %trim(ar_DECPOS) <> *blanks;
                     if %check(DIGITS1 :%trim(ar_DECPOS)) = 0;
                        w_IAVDEC  = %dec(ar_DECPOS:2:0);
                     endif;
                  endif;
                  if %scan(':':ar_Length) > 1;
                     ar_Prmlen = %trim(%subst(ar_Length:1:%scan(':':ar_Length) -1));       //SB04
                  endif;
               endif;
               if %trim(ar_prmlen) <> *blanks;
                  if %check(DIGITS1 :%trim(ar_prmlen)) = 0;
                     w_IAVLEN = %dec(ar_prmlen:8:0);
                  endif;
               endif;
            endif;
            w_IAVKWDNM = *blanks;
            w_IAVKWVAL = *blanks;
         else;
            ar_attr   = 'LIKE';
            ar_pos    = %scan('LIKE':ar_string) + 4;
            if ar_pos > 0;
               ar_pos    = %scan('(':ar_string:ar_pos);
            endif;

            If ar_pos > 0;                                                                 //MT04
               ar_pos1   = %scan(')':ar_string:ar_pos);
            endif;                                                                         //MT04
            w_IAVKWDNM = ar_attr;
            If (ar_pos1 - ar_pos) > 1;                                                     //SB04
               w_IAVKWVAL = %subst(ar_string:ar_pos + 1:ar_pos1-ar_pos -1);
            Endif;                                                                         //SB04
            ar_mody   =  '0';
         endif;
         ar_sts       = *blanks;
         ar_seq       = 0;
         ar_objvref   = *blanks;
         If ar_posdim > 0;                                                                 //MT04
            ar_pos = %scan('DIM':ar_string:ar_posdim);
         endif;                                                                            //MT04
         If ar_pos > 0;                                                                    //MT04
            ar_pos = %scan('(':ar_string:ar_pos);
         endif;                                                                            //MT04
         If ar_pos > 0;                                                                    //MT04
            ar_pos1= %scan(')':ar_string:ar_pos);
         endif;                                                                            //MT04

         If (ar_pos1 - ar_pos) > 1;                                                        //SB04
            ar_IAV_DIM  = %trim(%subst(ar_string:ar_pos+1:ar_pos1-ar_pos -1));
         Endif;                                                                            //SB04
         if %scan(':':ar_IAV_DIM) > 0;
            ar_pos1 = %scan(':':ar_IAV_DIM);
            ar_IAV_DIM = %trim(%subst(ar_IAV_DIM:ar_pos1+1));
         endif;
         if %trim(ar_IAV_DIM) <> *blanks;
            if %check(DIGITS1 :%trim(ar_IAV_DIM)) = 0;
               w_IAV_DIM = %dec(ar_IAV_DIM:8:0);
            endif;
         endif;
         exec sql
           insert into IAPGMVARS (IAVMBR,
                                  IAVSFILE,
                                  IAVLIB,
                                  IAVIFSLOC,                                             //0062
                                  IAVVAR,
                                  IAVDTYP,
                                  IAVLEN,
                                  IAVDEC,
                                  IAVTYP,
                                  IAVKWDNM,
                                  IAVKWVAL,
                                  IAVDIM,
                                  IAVDATF)
             values(:ar_srcmbr,
                    :ar_srcspf,
                    :ar_srclib,
                    :ar_IfsLoc,                                                          //0062
                    :w_IAVVAR,
                    :w_IAVDTYP,
                    :w_IAVLEN,
                    :w_IAVDEC,
                    :w_IAV_TYP,
                    :w_IAVKWDNM,
                    :w_IAVKWVAL,
                    :w_IAV_DIM,
                    :w_IAV_DATF);

         if SQLSTATE <> SQL_ALL_OK;
            //log error
         endif;
      endif;
   endif;

   Exsr insertIavarrellog;                                                               //MT02
   return;

   Begsr insertIavarrellog;                                                              //MT02
      // Insert the variables into IAVARREL File                                         //MT02
      W_RESRCLIB = ar_srclib;                                                            //MT02
      W_RESRCFLN = ar_srcspf;                                                            //MT02
      W_REPGMNM  = ar_srcmbr;                                                            //MT02
      W_REIFSLOC = ar_IfsLoc;                                                            //0062
      W_RESEQ    = 1;                                                                    //MT02
      W_RERRN    = ar_rrns;                                                              //MT02
      W_REOPC    = 'DCLVAR';                                                             //MT02
      W_REFACT1  = w_IAVVAR;                                                             //MT02
      W_RENUM1 = 0;                                                                      //MT02
      W_RENUM2 = 0;                                                                      //MT02
      W_RENUM3 = 0;                                                                      //MT02
      W_RENUM4 = 0;                                                                      //MT02
      W_RENUM5 = 0;                                                                      //MT02
      W_RENUM6 = 0;                                                                      //MT02
      W_RENUM7 = 0;                                                                      //MT02
      W_RENUM8 = 0;                                                                      //MT02
      W_RENUM9 = 0;                                                                      //MT02

      IaVarRelLog(                                                                       //MT02
    // W_RESRCLIB  :W_RESRCFLN   :W_REPGMNM     :W_RESEQ       :W_RERRN                  //0062
       W_RESRCLIB  :W_RESRCFLN   :W_REPGMNM     :W_REIFSLOC   :W_RESEQ  :W_RERRN         //0062
      :W_REROUTINE :W_RERELTYP  :W_RERELNUM     :W_REOPC        :W_RERESULT              //MT02
      :W_REBIF     :W_REFACT1    :W_RECOMP      :W_REFACT2     :W_RECONTIN               //MT02
      :W_RERESIND  :W_RECAT1     :W_RECAT2      :W_RECAT3       :W_RECAT4                //MT02
      :W_RECAT5    :W_RECAT6    :W_REUTIL       :W_RENUM1       :W_RENUM2                //MT02
      :W_RENUM3    :W_RENUM4    :W_RENUM5       :W_RENUM6       :W_RENUM7                //MT02
      :W_RENUM8    :W_RENUM9    :W_REEXC        :W_REINC  );                             //MT02

      if SQLSTATE <> SQL_ALL_OK;                                                         //MT02
         //log error                                                                    //MT02
      endif;                                                                             //MT02
   Endsr;                                                                                //MT02

   begsr CallengthdtaType;
      ar_Pos = %check(' ':ar_string:ar_Pos1);
      if %subst(ar_string:ar_pos:3) <> 'POI' and
         %subst(ar_string:ar_pos:3) <> 'IND' and
         %subst(ar_string:ar_pos:3) <> 'TIM' and
         %subst(ar_string:ar_pos:3) <> 'DAT';
         ar_Pos1 = %scan('(':ar_string:ar_Pos);
         if ar_Pos1 > ar_Pos;
            ar_Position = ar_Pos1 - ar_Pos;
         endif;
         If ar_Position > 0;                                                               //SB04
            ar_Data_Typ = %subst(ar_string:ar_Pos:ar_Position);
         Endif;                                                                            //SB04
      else;
         ar_Data_Typ  = %subst(ar_string:ar_pos:3);
         if ar_Data_Typ  = 'TIM';
            if %scan('TIMESTAMP':ar_string) > 0;
               ar_Data_Typ = 'TIMESTAMP';
            else;
               ar_Data_Typ = 'TIME';
            endif;
         endif;
      endif;

      if %subst(ar_string:ar_pos:3) <> 'POI' and
         %subst(ar_string:ar_pos:3) <> 'IND' and
         %subst(ar_string:ar_pos:3) <> 'TIM' and
         %subst(ar_string:ar_pos:3) <> 'DAT';
         if ar_Pos1 > 0;                                                                   //MT04
            ar_Pos  = %scan(')':ar_string:ar_Pos1);
         endif;                                                                            //MT04
         if ar_Pos > (ar_Pos1 + 1);
            ar_Position = ar_Pos - ar_Pos1-1;
         endif;
         If ar_Position > 0;                                                               //SB04
            ar_Length = %subst(ar_string:ar_Pos1+1:ar_Position);
         Endif;                                                                            //SB04
      endif;

      select;
      when ar_Data_Typ = 'DAT';
         ar_Data_Typ = 'DATE';
         ar_pos = %scan('DATE':ar_string:ar_pos) + 4;
         if ar_pos > 0;
            ar_pos = %check(' ':ar_string:ar_pos);
         endif;
         if ar_pos > 0 and %subst(ar_string:ar_pos:1) <> '(';
            w_IAV_DATF  = *blanks;
         else;
            if ar_pos > 0;                                                                 //MT04
               ar_pos1 = %scan(')':ar_string:ar_pos);
            Endif;                                                                         //MT04

            If (ar_pos1 - ar_pos) > 1;                                                     //SB04
               w_IAV_DATF = %subst(ar_string:ar_pos+1:ar_pos1-ar_pos-1);
            Endif;                                                                         //SB04
         endif;
         ar_Length = '10';

      when ar_Data_Typ = 'IND';
         ar_Data_Typ = 'INDICATOR';
         ar_Length = '1';
      when ar_Data_Typ = 'TIMESTAMP';
         ar_Length = '26';
      when ar_Data_Typ = 'TIME';
         ar_Length = '8';
      when ar_Data_Typ = 'POI';
         ar_Data_Typ = 'POINTER';
         ar_Length = '0';
      endsl;

   endsr;

end-proc;

//------------------------------------------------------------------------------------ //
//IaPsrARRfx:                                                                          //
//------------------------------------------------------------------------------------ //
dcl-proc IaPsrARRfx export;
   dcl-pi IaPsrARRfx;
      in_string char(5000);
      in_type   char(10);
      in_error  char(10);
      in_xref   char(10);
   // in_srclib char(10);                                                                //0062
   // in_srcspf char(10);                                                                //0062
   // in_srcmbr char(10);                                                                //0062
      in_uWSrcDtl likeds(uWSrcDtl);                                                      //0062
      in_rrns   packed(6:0);
      in_rrne   packed(6:0);
      in_lname  char(30);
      in_lword  char(30);
   end-pi;

   dcl-s ar_Decimal  char(10)    inz;
   dcl-s ar_word     char(128)   inz;
   dcl-s ar_lname    char(30)    inz;
   dcl-s ar_Type     char(10)    inz;
   dcl-s ar_Length   char(10)    inz;
   dcl-s ar_Data_Typ char(10)    inz;
   dcl-s ar_String   char(243)   inz;
   dcl-s w_IAV_TYP   char(10)    inz;
   dcl-s w_IAVKWDNM  char(20)    inz;
   dcl-s w_IAVKWVAL  char(40)    inz;
   dcl-s w_IAV_DATF  char(05)    inz;
   dcl-s ar_IAV_DIM  char(20)    inz;
   dcl-s ar_xref     char(10)    inz;
   dcl-s ar_srclib   char(10)    inz;
   dcl-s ar_srcspf   char(10)    inz;
   dcl-s ar_srcmbr   char(10)    inz;
   dcl-s ar_IfsLoc   char(100)   inz;                                                    //0062
   dcl-s ar_Pwrdobjv char(10)    inz;
   dcl-s ar_Objvref  char(10)    inz;
   dcl-s ar_attr     char(10)    inz;
   dcl-s ar_mody     char(10)    inz;
   dcl-s ar_sts      char(10)    inz;
   dcl-s ar_ArrName  char(128)   inz;
   dcl-s w_IAVVAR    char(80)    inz;
   dcl-s w_IAVDTYP   char(10)    inz;
   dcl-s w_IAV_DIM   packed(8:0) inz;
   dcl-s ar_Pos      packed(5:0) inz;
   dcl-s ar_Pos1     packed(5:0) inz;
   dcl-s ar_Posdim   packed(5:0) inz;
   dcl-s ar_Position packed(5:0) inz;
   dcl-s ar_rrns     packed(6:0) inz;
   dcl-s ar_rrne     packed(6:0) inz;
   dcl-s ar_seq      packed(6:0) inz;
   dcl-s w_IAVLEN    packed(8:0) inz;
   dcl-s w_IAVDEC    packed(2:0) inz;

   dcl-ds iavarrelDS extname('IAVARREL') prefix(w_) Inz;                                 //MT02
   end-ds;                                                                               //MT02

   If In_String=*Blanks ;              //RB
     Return;                           //RB
   EndIf;                              //RB

   uwsrcdtl = In_uwsrcdtl;                                                               //0062

   ar_string  =  in_string;
   //Move the source string into RPGIVDS                                                 //0003
   Clear DspecV4 ;                                                                       //0003
   If %subst(ar_string:6:1) = 'D';                                                       //0003
      DspecV4    =  in_string;                                                           //0003
   endif ;                                                                               //0003
   ar_xref    =  in_xref;
   ar_srclib  =  in_srclib;
   ar_srcspf  =  in_srcspf;
   ar_srcmbr  =  in_srcmbr;
   ar_IfsLoc  =  in_IfsLoc;                                                              //0062
   ar_rrns    =  in_rrns;
   ar_rrne    =  in_rrne;
   ar_lname   =  in_lname;
   if ar_rrne   = 0;
      ar_rrne   = ar_rrns;
   endif;

   if Dspecv4.Specification = 'D' and                                                        //0003
      Dspecv4.star <> '*' and                                                                //0003
      %trim(Dspecv4.declarationtype) = 'S';                                                  //0003
      if ar_lname =  *blanks;
         ar_arrname = %trim(Dspecv4.name);                                                   //0003
         w_IAVVAR   = %trim(Dspecv4.name);                                                   //0003
      else;
         ar_arrname = %trim(ar_lname) +
                      %trim(Dspecv4.name);                                                   //0003
         w_IAVVAR   = %trim(ar_lname) +
                      %trim(Dspecv4.name);                                                   //0003
      endif;

      if DspecV4 <> '' ;                                                                     //0003
         if %scan('DIM':%trim(Dspecv4.Keyword)) > 0;                                         //0003
            if %scan('CTDATA':%trim(Dspecv4.Keyword)) > 0;                                   //0003
               ar_Type = 'CT_ARR_VAR';
            endif;
            if %scan('FROMFILE':%trim(Dspecv4.Keyword)) > 0;                                 //0003
               ar_Type = 'PT_ARR_VAR';
            endif;
            if %scan('CTDATA':%trim(Dspecv4.Keyword)) = 0 and                                //0003
               %scan('FROMFILE':%trim(Dspecv4.Keyword)) = 0 ;                                //0003
               ar_Type = 'RT_ARR_VAR';
            endif;
            ar_pwrdobjv  = Ar_Type;
            w_IAV_TYP    = %subst(Ar_Type:1:5);
            if %scan('LIKE':%trim(Dspecv4.Keyword))= 0;                                      //0003
               AR_Data_Typ = %trim(Dspecv4.internaldatatype);                                //0003
               AR_Length = %trim(Dspecv4.Tolength);                                          //0003
               AR_Decimal = %trim(Dspecv4.Decimalposition);                                  //0003
               CalDataLengthRPGLE(ar_Data_Typ
                                :w_IAV_DATF
                                :ar_String
                                :ar_Decimal
                                :ar_Length
                                :ar_Pos
                                :ar_Pos1);
               ar_attr      = Ar_Data_Typ;
               w_IAVDTYP    = Ar_Data_Typ;
               if %trim(ar_Length) <> *blanks;
                  if %check(DIGITS1 :%trim(ar_Length)) = 0;
                     w_IAVLEN = %dec(ar_Length:8:0);
                  endif;
               endif;
               if ar_Decimal<> *blanks ;
                  if %check(DIGITS1 :%trim(ar_Decimal)) = 0;
                     w_IAVDEC = %dec(ar_Decimal:2:0);
                  endif;
               endif;
               If ar_Length <> *blanks ;                                    //RB
                 If ar_Decimal <> *blanks;                                  //RB
                   ar_Length = %trim(ar_length) + ',' + %trim(ar_Decimal);  //RB
                 Else ;                                                     //RB
                   ar_Length = %trim(ar_length);                            //RB
                 Endif;                                                     //RB
               Endif;                                                       //RB
               ar_mody    = ar_Length;
               w_IAVKWDNM = *blanks;
               w_IAVKWVAL = *blanks;
            else;
               ar_attr    = 'LIKE';
               ar_pos     = %scan('LIKE':Dspecv4.Keyword) + 4;                               //0003
               if ar_pos > 0;
                  ar_pos     = %scan('(':Dspecv4.Keyword:ar_pos);                            //0003
               endif;
               If ar_pos > 0;                                                                //MT04
                  ar_pos1    = %scan(')':Dspecv4.Keyword:ar_pos);                            //0003
               endif;                                                                        //MT04
               w_IAVKWDNM = ar_attr;
               If ar_pos1-ar_pos > 1;                                                        //SB04
                  w_IAVKWVAL = %subst(Dspecv4.Keyword :ar_pos + 1                            //0003
                               :ar_pos1-ar_pos -1);                                          //0003
               Endif;                                                                        //SB04
               ar_mody    = '0';
            endif;
            ar_sts = *blanks;
            ar_seq = 0;
            if ar_lname =  *blanks;
               ar_objvref = *blanks;
               ar_word    = ar_arrname;
            else;
               ar_objvref = ar_arrname;
               ar_word    = in_lword;
            endif;
            ar_pos  = %scan('DIM':Dspecv4.Keyword);                                         //0003
            If ar_pos > 0;                                                                  //MT04
               ar_pos  = %scan('(':Dspecv4.Keyword:ar_pos);                                 //0003
            endif;                                                                          //MT04
            If ar_pos > 0;                                                                  //MT04
               ar_pos1 = %scan(')':Dspecv4.Keyword:ar_pos);                                 //0003
            endif;                                                                          //MT04
            If ar_pos1-ar_pos > 1;                                                          //SB04
               ar_IAV_DIM  = %trim(%subst(Dspecv4.Keyword :ar_pos+1                         //0003
                             :ar_pos1-ar_pos -1));                                          //0003
            EndIf;                                                                          //SB04

            if %trim(ar_IAV_DIM) <> *blanks;
               if %check(DIGITS1 :%trim(ar_IAV_DIM)) = 0;
                  w_IAV_DIM = %dec(ar_IAV_DIM:8:0);
               endif;
            endif;
            exsr InsertDDL;
         endif;
      endif;
   endif;

   if %subst(ar_string:6:1) = 'E' and
      %subst(ar_string:7:1) <>'*' and
      %subst(ar_string:27:6) <> *blanks and
      %subst(ar_string:36:4) <> *blanks;
      ar_IAV_DIM  = %trim(%subst(ar_string:36:4));
      if %trim(ar_IAV_DIM) <> *blanks;
         if %check(DIGITS1 :%trim(ar_IAV_DIM)) = 0;
            w_IAV_DIM   = %dec(ar_IAV_DIM:8:0);
         endif;
      endif;
      ar_arrname = %subst(ar_string:27:6);
      w_IAVVAR   = %trim(%subst(ar_string:27:6));
      AR_Data_Typ = %subst(ar_string:43:1);
      AR_Length = %subst(ar_string:40:3);
      AR_Decimal = %subst(ar_string:44:1);
      exsr CALDataLengthRPG;
      if %subst(ar_string:11:8) = *blanks and
         %subst(ar_string:33:3) = *blanks;
         ar_Type = 'RT_AR_VAR';
      endif;
      if %subst(ar_string:11:8) <> *blanks and
         %subst(ar_string:33:3) = *blanks;
         ar_Type = 'PT_AR_VAR';
      endif;
      if %subst(ar_string:11:8) = *blanks and
         %subst(ar_string:33:3) <> *blanks;
         ar_Type = 'CT_AR_VAR';
      endif;
      ar_pwrdobjv  = Ar_Type;
      ar_attr      = Ar_Data_Typ;
      w_IAVDTYP    = Ar_Data_Typ;
      ar_mody      = ar_Length;
      ar_sts       = *blanks;
      ar_seq       = 0;
      ar_objvref   = *blanks;
      exsr InsertDDL;
   endif;
   Exsr insertIavarrellog;                                                               //MT02
   return;

   Begsr insertIavarrellog;                                                              //MT02
      // Insert the variables into IAVARREL File                                         //MT02
      W_RESRCLIB = ar_srclib;                                                            //MT02
      W_RESRCFLN = ar_srcspf;                                                            //MT02
      W_REPGMNM  = ar_srcmbr;                                                            //MT02
      W_REIFSLOC = ar_IfsLoc;                                                            //0062
      W_RESEQ    = 1;                                                                    //MT02
      W_RERRN    = ar_rrns;                                                              //MT02
      W_REOPC    = 'DCLVAR';                                                             //MT02
      W_REFACT1  = w_IAVVAR;                                                             //MT02
      W_RENUM1 = 0;                                                                      //MT02
      W_RENUM2 = 0;                                                                      //MT02
      W_RENUM3 = 0;                                                                      //MT02
      W_RENUM4 = 0;                                                                      //MT02
      W_RENUM5 = 0;                                                                      //MT02
      W_RENUM6 = 0;                                                                      //MT02
      W_RENUM7 = 0;                                                                      //MT02
      W_RENUM8 = 0;                                                                      //MT02
      W_RENUM9 = 0;                                                                      //MT02
                                                                                         //MT02
      IaVarRelLog(                                                                       //MT02
    // W_RESRCLIB  :W_RESRCFLN   :W_REPGMNM     :W_RESEQ       :W_RERRN                  //MT02
       W_RESRCLIB  :W_RESRCFLN   :W_REPGMNM     :W_REIFSLOC   :W_RESEQ  :W_RERRN         //0062
      :W_REROUTINE :W_RERELTYP  :W_RERELNUM     :W_REOPC        :W_RERESULT              //MT02
      :W_REBIF     :W_REFACT1    :W_RECOMP      :W_REFACT2     :W_RECONTIN               //MT02
      :W_RERESIND  :W_RECAT1     :W_RECAT2      :W_RECAT3       :W_RECAT4                //MT02
      :W_RECAT5    :W_RECAT6    :W_REUTIL       :W_RENUM1       :W_RENUM2                //MT02
      :W_RENUM3    :W_RENUM4    :W_RENUM5       :W_RENUM6       :W_RENUM7                //MT02
      :W_RENUM8    :W_RENUM9    :W_REEXC        :W_REINC  );                             //MT02
                                                                                         //MT02
      if SQLSTATE <> SQL_ALL_OK;                                                         //MT02
         //log error                                                                    //MT02
      endif;                                                                             //MT02
   Endsr;                                                                                //MT02

   begsr CALDataLengthRPG;
      if ar_Data_Typ = *blanks;
         if %subst(ar_string:40:3) <> *blanks;
            if  %subst(ar_string:44:1) = *blanks;
               ar_Data_Typ = 'CHAR';
            else;
               ar_Data_Typ = 'DECIMAL';
            endif;
         endif;
      endif;

      if %subst(ar_string:40:3) <> *blanks And
         %subst(ar_string:44:1) = *blanks;
         ar_Length = %subst(ar_string:40:3);
      endif;

      select;
      when ar_Data_Typ = 'P';
         ar_Data_Typ = 'Packed';
      when ar_Data_Typ = 'B';
         ar_Data_Typ = 'Binary';
      when ar_Data_Typ = 'L';
         ar_Data_Typ = 'Left -/+';
      when ar_Data_Typ = 'R';
         ar_Data_Typ = 'Right -/+';
      endsl;
   endsr;

   begsr insertDDL;
      exec sql
        insert into IAPGMVARS (IAVMBR,
                               IAVSFILE,
                               IAVLIB,
                               IAVIFSLOC,                                                //0062
                               IAVVAR,
                               IAVDTYP,
                               IAVLEN,
                               IAVDEC,
                               IAVTYP,
                               IAVKWDNM,
                               IAVKWVAL,
                               IAVDIM,
                               IAVDATF)
          values(:ar_srcmbr,
                 :ar_srcspf,
                 :ar_srclib,
                 :ar_IfsLoc,                                                             //0062
                 :w_IAVVAR,
                 :w_IAVDTYP,
                 :w_IAVLEN,
                 :w_IAVDEC,
                 :w_IAV_TYP,
                 :w_IAVKWDNM,
                 :w_IAVKWVAL,
                 :w_IAV_DIM,
                 :w_IAV_DATF);

      if SQLSTATE <> SQL_ALL_OK;
         //log error
      endif;
   endsr;
end-proc;

//------------------------------------------------------------------------------------ //
//IaPsrVARfr:                                                                          //
//------------------------------------------------------------------------------------ //
dcl-proc IaPsrVARfr export;
   dcl-pi IaPsrVARfr;
      in_string char(5000) value ;                                                       //0001
      in_type   char(10);
      in_error  char(10);
      in_xref   char(10);
   // in_srclib char(10);                                                                //0062
   // in_srcspf char(10);                                                                //0062
   // in_srcmbr char(10);                                                                //0062
      in_uWSrcDtl likeds(uWSrcDtl);                                                      //0062
      in_rrns   packed(6:0);
      in_rrne   packed(6:0);
      in_prc    ind;
   end-pi;

   dcl-s vr_Length     char(10)    inz;
   dcl-s w_IAV_TYP     char(10)    inz;
   dcl-s w_IAV_DATF    char(05)    inz;
   dcl-s w_IAVKWDNM    char(20)    inz;
   dcl-s w_IAVKWVAL    char(50)    inz;
   dcl-s w_IAV_KEYWRD  char(80)    inz;
   dcl-s vr_Data_Typ   char(18)    inz;
   dcl-s vr_PRMLEN     char(10)    inz;
   dcl-s vr_DECPOS     char(10)    inz;
   dcl-s vr_Decimal    char(10)    inz;
   dcl-s vr_String     char(243)   inz;
   dcl-s vr_String1    char(243)   inz;
   dcl-c Enter_Hex                 'X"F1"';
   dcl-s iq_String     char(5000)   inz;
   dcl-s vr_keyword    char(243)   inz;
   dcl-s vr_Type       char(10)    inz;
   dcl-s vr_xref       char(10)    inz;
   dcl-s vr_srclib     char(10)    inz;
   dcl-s vr_srcspf     char(10)    inz;
   dcl-s vr_srcmbr     char(10)    inz;
   dcl-s vr_IfsLoc     char(100)   inz;                                                  //0062
   dcl-s vr_Pwrdobjv   char(10)    inz;
   dcl-s vr_Objvref    char(10)    inz;
   dcl-s vr_attr       char(10)    inz;
   dcl-s vr_mody       char(10)    inz;
   dcl-s vr_sts        char(10)    inz;
   dcl-s vr_VarName    char(128)   inz;
   dcl-s vr_word       char(128)   inz;
   dcl-s vr_lname      char(30)    inz;
   dcl-s w_IAVVAR      char(80)    inz;
   dcl-s w_IAVDTYP     char(10)    inz;
   dcl-s opc_name      char(10)    inz;
   dcl-s vr_Pos        packed(5:0) inz(1);
   dcl-s W_POSS        packed(5:0) inz(1);
   dcl-s W_POSS2       packed(5:0) inz(1);
   dcl-s vr_Pos1       packed(5:0) inz(1);
   dcl-s vr_Pos2       packed(5:0) inz(1);
   dcl-s vr_Pos3       packed(5:0) inz(1);
   dcl-s vr_Pos4       packed(2:0) inz;
   dcl-s vr_Position   packed(5:0) inz(1);
   dcl-s l_position    packed(6:0) inz;
   dcl-s vr_rrns       packed(6:0) inz;
   dcl-s vr_rrne       packed(6:0) inz;
   dcl-s vr_seq        packed(6:0) inz;
   dcl-s w_IAVLEN      packed(8:0) inz;
   dcl-s w_IAVDEC      packed(2:0) inz;
   dcl-s w_inquote     char(1) inz;
   dcl-s w_dsflag      char(1) inz('N');
   dcl-s w_ds1Flag     char(1) inz('N');
   dcl-s ds_position   packed(2:0) inz;
   dcl-s ds_count      packed(2:0) inz;

   dcl-s w_IAVKWVAL1   char(50)     inz;
   dcl-ds iavarrelDS extname('IAVARREL') prefix(w_) Inz;

   end-ds;

   if in_string = *blanks;                                                     //KM
      return;                                                                  //KM
   else;                                                                       //AK41
      in_String = %trim(in_String);                                            //AK41
   endif;                                                                      //KM

   uwsrcdtl = In_uwsrcdtl ;                                                              //0062
   vr_string  =  in_string;
   vr_xref    =  in_xref;
   vr_srclib  =  in_srclib;
   vr_srcspf  =  in_srcspf;
   vr_srcmbr  =  in_srcmbr;
   vr_IfsLoc = in_IfsLoc;                                                                //0062
   vr_rrns    =  in_rrns;
   vr_rrne    =  in_rrne;



   if %Scan('DCL-S':vr_string) > 0;

      vr_Pos =  %scan('DCL-S':vr_string);
      vr_Pos = vr_Pos + 6;
      vr_Pos = %check(' ':vr_string:vr_Pos);
      vr_Pos1 = %scan(' ':vr_string:vr_Pos);
      If vr_Pos1 > vr_Pos;
         vr_Position = vr_Pos1 - vr_Pos;
      Endif;

      If vr_Pos > 0 and vr_Position > 0;
         vr_varname = %Subst(vr_string:vr_Pos:vr_Position);
         // w_IAVVAR = %trim(vr_varname);                                       //0010
         if %scan(';':vr_varname) > 0;                                          //AK41
            vr_varname = %subst(vr_varname:1:%len(%trim(vr_varname)) - 1);      //AK41
         endif;                                                                 //AK41
         w_IAVVAR = %trim(vr_varname);                                          //0010
      Endif;
      If w_ds1Flag <> 'Y' and vr_Pos1 > 0;
         If %Scan('LIKE':vr_string:vr_pos1) = 0;
            exsr Callengthdtatype;
            vr_attr      = vr_Data_Typ;
            w_IAVDTYP    = vr_Data_Typ;
            vr_mody      = vr_Length;
            If %scan(':':vr_Length) = 0 ;
               if %trim(vr_length) <> *blanks;
                  if %check(DIGITS1 :%trim(vr_length)) = 0;
                     w_IAVLEN = %dec(vr_Length:8:0);
                  endif;
               endif;
            else;
              If %scan(':':vr_Length) <> 1;
                 vr_Prmlen = %trim(%subst(vr_Length:1:%scan(':':vr_Length) -1));
                 if %trim(vr_prmlen) <> *blanks;
                    if %check(DIGITS1 :%trim(vr_prmlen)) = 0;
                       w_IAVLEN = %dec(vr_prmlen:8:0);
                    endif;
                 endif;
              Endif;
            Endif;

            If %scan(':':vr_Length) > 0;
               vr_DECPOS = %trim(%subst(vr_Length:%scan(':':vr_Length) +1));
               if %trim(vr_DECPOS) <>  *blanks;
                  if %check(DIGITS1 :%trim(vr_DECPOS)) = 0;
                     w_IAVDEC  = %dec(vr_DECPOS:2:0);
                  endif;
               endif;
            Endif;

            if in_prc = *on;
               w_IAV_TYP    = 'PG_LO';
            else;
               w_IAV_TYP    = 'PG_GL';
            endIf;

            If %len(%trim(vr_keyword))  =  1;
               w_IAVKWDNM = *Blanks;
               w_IAVKWVAL = *Blanks;
            else;

               If %scan(';':vr_keyword) > 0;
                  W_IAV_KEYWRD =
                  %trim(%replace(' ':vr_keyword:%scan(';':vr_keyword):1));
               Else;
                  W_IAV_KEYWRD = vr_keyword;
               Endif;

               If %Scan('VARYING':vr_string) = 0 and
                  %Scan('EXPORT':vr_string) = 0  and
                  %Scan('IMPORT':vr_string) = 0;
                  vr_pos = %check(' ':vr_keyword);
                  If vr_pos > 0 and %scan('(' :vr_keyword:vr_pos) > 0;
                     vr_pos1 = %scan('(' :vr_keyword:vr_pos);
                     If (vr_pos1 - vr_pos) > 0;
                        w_IAVKWDNM =
                        %trim(%subst(vr_keyword:vr_pos:vr_pos1 - vr_pos));
                        vr_pos = vr_pos1;
                        vr_pos1 = %scan(')' :vr_keyword:vr_pos);
                        If (vr_pos1 - vr_pos) > 1;
                           w_IAVKWVAL =
                           %trim(%subst(vr_keyword:vr_pos+1:vr_pos1 - vr_pos-1));
                        Endif;
                     Endif;
                  endif;
               else;
                  If %Scan('VARYING':vr_string) > 0;
                     w_IAVKWDNM = 'VARYING';
                  endif;
                  If %Scan('EXPORT':vr_string) > 0;
                     w_IAVKWDNM = 'EXPORT';
                  endif;
                  If %Scan('IMPORT':vr_string) > 0;
                     w_IAVKWDNM = 'IMPORT';
                  endif;
                  w_IAVKWVAL = *blanks;
               Endif;
            Endif;
         else;
            vr_pos = %Scan('LIKE':vr_string:vr_pos1) +4;
            If vr_pos > 4;
               vr_keyword = %trim(%subst(vr_string:vr_pos - 4));
               If %scan(';':vr_keyword) > 0;
                  W_IAV_KEYWRD =
                    %trim(%replace(' ':vr_keyword:%scan(';':vr_keyword):1));
               Else;
                  W_IAV_KEYWRD = vr_keyword;
               Endif;
            Endif;
            vr_pos = %Scan('(':vr_string:vr_pos);
            vr_pos1 = %Scan(')':vr_string:vr_pos);
            w_IAVKWDNM = 'LIKE';
            If (vr_pos1 - vr_pos -1) > 1;
               w_IAVKWVAL = %Subst(vr_string:vr_pos + 1:vr_pos1-vr_pos -1);
            Endif;
            vr_mody = '0';
            vr_attr = 'LIKE';
            if in_prc = *on;
               w_IAV_TYP    = 'PG_LO';
            else;
               w_IAV_TYP    = 'PG_GL';
            endIf;

         endif;
      EndIf;
      vr_pwrdobjv  = 'S_VAR';
      vr_sts       = *blanks;
      vr_seq       = 0;
      vr_objvref   = *blanks;
      exsr InsertDDL;

   Endif;
   If %Scan('DCL-C':vr_string) > 0;
      vr_attr   = 'CONST';
      w_IAV_TYP = 'CONST';
      vr_mody   = *blanks;
      vr_pwrdobjv  = 'C_VAR';
      vr_sts       = *blanks;
      vr_seq       = 0;
      vr_objvref   = *blanks;

      vr_pos = %scan('DCL-C': %trim(vr_string)) + 5;
      vr_pos = %check(' ':%trim(vr_string): vr_pos);
      vr_pos1 = %scan(' ' : %trim(vr_string): vr_pos);
      If vr_pos > 0 and vr_pos1 > vr_pos;
         vr_varname = %subst(%trim(vr_string) : vr_pos : vr_pos1 - vr_pos);
      Endif;
      w_IAVVAR = vr_varname;
      w_IAVKWDNM = 'CONST';
      If vr_pos1 > 0;
         l_position  = %scan('(' : vr_string : vr_pos1);
      Endif;

      iq_String = %trim(vr_string);
      InQuote(iq_String : l_position : w_inquote);

      If w_inquote = 'N' and vr_pos1 > 0 and
         %scan('CONST' : vr_string: vr_pos1) > 0;
        vr_pos = %Scan('CONST(':vr_String:vr_pos1) + 6;
        vr_pos = %check(' ': vr_string : vr_pos);
        If vr_pos > 0 and %subst(vr_string : vr_pos: 1)  = '"';
          vr_pos += 1;
        endif;
        l_position = %checkR('; )' : vr_string : %len(%trim(vr_string)));
        if l_position > 0 and %Scan('"':vr_String:vr_pos) > 0;
           l_position = l_position - 1;
        Endif;

        If %len(%trim(vr_string)) - l_position - 1 > 0;
           l_position = %len(%trim(vr_string)) - l_position - 1;
        Else;
           l_position = 0;
        Endif;

        If vr_pos > 0 and %Scan('X"':vr_String:vr_pos) > 0;
           w_IAVKWVAL = %subst(%trim(vr_string) : vr_pos : 5);
        Else;
           If vr_pos > 0
              and ((%len(%trim(vr_string)) - vr_pos) - l_position) > 0;
              w_IAVKWVAL = %subst(%trim(vr_string) : vr_pos :
                     %len(%trim(vr_string)) - vr_pos - l_position);
           Endif;
        EndIf;
        exsr insertDDL;
      Else;
        vr_pos = %check(' ': %trim(vr_string) : vr_pos1);
        If vr_pos > 0;
           If %Subst(%trim(Vr_String):Vr_Pos:1) = '"';
              Vr_Pos += 1;
           EndIf;
        Endif;

        vr_pos1 = %checkR(' ;' : %trim(vr_string) : %len(%trim(vr_string)));
        If vr_pos1 > 0 and %Subst(%trim(Vr_String):Vr_Pos1:1) = '"';
           Vr_pos1 -= 1;
        EndIf;

        If %len(%trim(vr_string)) - vr_pos1 - 1 > 0;
           l_position = %len(%trim(vr_string)) - vr_pos1 - 1;
        Else;
           l_position = 0;
        Endif;

        Reset WKConstInd;
        Reset W_IAVSEQNUM;
        vr_string1 = %subst(vr_string : vr_pos);
        Dow Not WKConstInd;
           W_POSS = %SCAN('-   ':%trim(vr_string1): 1);
           If %Scan('X"':vr_String1) > 0;
              W_IAVKWVAL = %subst(vr_string1 : 1 : 5);
              vr_string1 = *Blanks;

           ElseIf (W_POSS > 1 and W_POSS > 50 and
              %subst(%trim(vr_string1) : 51 : 1) <> ' ');
              W_POSS4 = %checkR(W_AlphaNum : vr_string1 : 50);
              If W_POSS4 > 1;
                 W_IAVKWVAL = %subst(%trim(vr_string1) : 1 :
                                (W_POSS4-1));
              Endif;
           ElseIf W_POSS > 1;
              W_IAVKWVAL = %subst(%trim(vr_string1) : 1 :
                                (W_POSS-1));
           Else;
              W_POSS3 = %CheckR(' ;' : %trim(vr_string1));
              If W_POSS3 > 1;
                 W_IAVKWVAL = %subst(%trim(vr_string1) : 1 :
                            (W_POSS3 - 1));
              Endif;
              vr_string1 = *Blanks;
           EndIf;

           If vr_string1 = *Blanks;
              W_IAVSEQNUM += 1;
              WKConstInd = *On;
           Else;
              If W_POSS > 50 and %subst(%trim(vr_string1) : 51 : 1) <> ' ';
                 vr_string1 = %subst(%trim(vr_string1) :
                              W_Poss4 + 1 : (W_POSS - 50)) +
                              %subst(%trim(vr_string1) : W_Poss);
              ElseIf W_POSS > 50;
                 vr_string1 = %subst(%trim(vr_string1) : 51 : (W_POSS - 50)) +
                              %subst(%trim(vr_string1) : W_POSS + 1);
              Else;
                 vr_string1 = %subst(%trim(vr_string1) : W_POSS + 1);
              Endif;
              W_IAVSEQNUM += 1;
              vr_pos = 1;
           Endif;
           If W_IAVSEQNUM > 1;
              W_IAVVAR = *Blanks;
           EndIf;
           exsr insertDDL;
        Enddo;
        if W_IAVSEQNUM > 1;
           W_IAVVAR = VR_VARNAME;
        endif;
     Endif;
   Endif;

   Exsr insertIavarrellog;

   return;

   begsr CallengthdtaType;

      vr_Pos = %check(' ':vr_string:vr_Pos1);
      If vr_Pos > *zeros and %subst(vr_string:vr_pos:3) <> 'POI' and
         %subst(vr_string:vr_pos:3) <> 'IND' and
         %subst(vr_string:vr_pos:3) <> 'TIM' and
         %subst(vr_string:vr_pos:3) <> 'DAT' and
         %scan('(':vr_string:vr_Pos) <> 0;

         vr_Pos1 = %scan('(':vr_string:vr_Pos);
         If vr_Pos1 > vr_Pos;
            vr_Position = vr_Pos1 - vr_Pos;
         Endif;
         If vr_Pos > 0 and vr_Position > 0;
            vr_Data_Typ = %Subst(vr_string:vr_Pos:vr_Position);
         Endif;
         if vr_Data_Typ = 'SQLTYPE';
            vr_Pos2 = %scan(':':vr_string:vr_Pos1+1);
            If vr_Pos2 = 0;
               vr_Pos2 = %scan(')':vr_string:vr_Pos1+1);
               exsr GetEqvalentDtaTyp;
               vr_Pos2 = %scan('(':vr_Data_Typ);
               vr_Pos3 = %scan(')':vr_Data_Typ);
               If vr_Pos2 > 0 and vr_Pos3 > vr_Pos2;
                  vr_Pos4 = vr_Pos3 - vr_Pos2;
                  If vr_Pos4 > 1;
                     vr_Length = %Subst(vr_Data_Typ:vr_Pos2+1:vr_Pos4-1);
                  Endif;
                  If vr_Pos2 > 2;
                     vr_Pos4 = vr_Pos2 - 2;
                     vr_Data_Typ = %Subst(vr_Data_Typ:2:vr_Pos4);
                  Endif;
               Endif;
            else;
               exsr GetEqvalentDtaTyp;
               vr_Data_Typ = %triml(vr_Data_Typ);
            endif;
            vr_Pos2 = %scan(';':vr_string );
            If vr_Pos2 > vr_Pos;
               vr_Pos3 = vr_Pos2 - vr_Pos;
            Endif;
            If vr_Pos > 0 and vr_Pos3 > 0;
               vr_keyword = %Subst(vr_string:vr_Pos:vr_Pos3);
            Endif;
         endif;
      else;
         If vr_pos > 0;
            vr_Data_Typ  = %subst(vr_string:vr_pos:3);
         Endif;
         If vr_Data_Typ  = 'TIM';
            If %Scan('TIMESTAMP':vr_string) > 0;
               vr_Data_Typ = 'TIMESTAMP';
            else;
               vr_Data_Typ = 'TIME';
            endif;
         endif;
      Endif;

      If vr_pos > *zeros and vr_Pos1 > 0 and
         %subst(vr_string:vr_pos:3) <> 'POI' and
         %subst(vr_string:vr_pos:3) <> 'IND' and
         %subst(vr_string:vr_pos:3) <> 'TIM' and
         %subst(vr_string:vr_pos:3) <> 'DAT' and
         %scan(')':vr_string:vr_Pos1) <> 0;
         vr_Pos  = %scan(')':vr_string:vr_Pos1);
         If vr_keyword = *Blanks;
            If vr_Pos > 0 and vr_Pos > vr_Pos1+1;
               vr_Position = vr_Pos - vr_Pos1-1;
            Endif;
            If vr_Position > 0;
               vr_Length = %Subst(vr_string:vr_Pos1+1:vr_Position);
            Endif;
            vr_pos1 = %scan(';':vr_string );
            If (vr_pos1-vr_pos) > 0;
               vr_keyword = %trim(%Subst(vr_string:vr_Pos+1:vr_pos1-vr_pos));
            Endif;
         else;
            If vr_Length = *Blanks and vr_Pos1 > 0;
               vr_Pos2 = %scan(':':vr_string:vr_Pos1);
               If vr_Pos > vr_Pos2;
                  vr_Position = vr_Pos - vr_Pos2;
               Endif;
               If vr_Position > 1;
                  vr_Length = %Subst(vr_string:vr_Pos2+1:vr_Position-1);
               Endif;
            endif;
         endif;
      endif;

      Select;
      When vr_Data_Typ = 'DAT';
         vr_Data_Typ = 'DATE';
         vr_pos = %scan('DATE':vr_string:vr_pos) + 4;
         vr_pos1 = %check(' ':vr_string:vr_pos);

         If vr_pos1 > 0 and %subst(vr_string:vr_pos1:1) <> '(';
            vr_pos =  vr_pos1;
            vr_pos1 = %scan(';':vr_string );
            If vr_pos1 > vr_pos;
               vr_keyword = %trim(%Subst(vr_string:vr_Pos:vr_pos1-vr_pos));
            else;
               vr_keyword = ';';
            endif;
            w_IAV_DATF  = *blanks;
         else;
            vr_pos = vr_pos1;
            vr_pos1 = %scan(')':vr_string:vr_pos);
            If (vr_pos1 - vr_pos) > 1;
               w_IAV_DATF = %subst(vr_string:vr_pos+1:vr_pos1-vr_pos-1);
            Endif;
            vr_pos =  vr_pos1;
            vr_pos1 = %scan(';':vr_string );
            If vr_pos1 > vr_pos;
               vr_keyword = %trim(%Subst(vr_string:vr_Pos+1:vr_pos1-vr_pos));
            Endif;
         endif;
         vr_Length = '10';
      When vr_Data_Typ = 'IND';
         vr_pos = %scan('IND':vr_string:vr_pos ) + 2;
         vr_pos1 = %scan(';':vr_string );
         If vr_pos1 > vr_pos;
            vr_keyword = %trim(%Subst(vr_string:vr_Pos+1:vr_pos1-vr_pos));
         Endif;
         vr_Data_Typ = 'INDICATOR';
         vr_Length = '1';
      When vr_Data_Typ = 'TIMESTAMP';
         vr_pos = %scan('TIMESTAMP':vr_string:vr_pos ) + 8;
         vr_pos1 = %scan(';':vr_string );
         If vr_pos1 > vr_pos;
            vr_keyword = %trim(%Subst(vr_string:vr_Pos+1:vr_pos1-vr_pos));
         Endif;
         vr_Length = '26';
      When vr_Data_Typ = 'TIME';
         vr_pos = %scan('TIME':vr_string:vr_pos ) + 3;
         vr_pos1 = %scan(';':vr_string );
         If vr_pos1 > vr_pos;
            vr_keyword = %trim(%Subst(vr_string:vr_Pos+1:vr_pos1-vr_pos));
         Endif;
         vr_Length = '8';
      When vr_Data_Typ = 'POI';
         vr_Data_Typ = 'POINTER';
         vr_pos = %scan('POINTER':vr_string:vr_pos ) + 6;
         vr_pos1 = %scan(';':vr_string );
         If vr_pos1 > vr_pos;
            vr_keyword = %trim(%Subst(vr_string:vr_Pos+1:vr_pos1-vr_pos));
         Endif;
         vr_Length = '0';
      EndSl;

   endsr;

   begsr GetEqvalentDtaTyp;

      If  vr_Pos2 > vr_Pos1;
         vr_Pos3 = vr_Pos2 - vr_Pos1;
      Endif;
      If vr_Pos3 > 1;
         vr_Data_Typ = %Subst(vr_string:vr_Pos1+1:vr_Pos3-1);
      Endif;
      If vr_Data_Typ <> *Blanks;
         vr_Pos4 = %Lookup(vr_Data_Typ:SQLDatTypArr);
         vr_Data_Typ = SQLDatTypArr(vr_Pos4 + 1);
      Endif;

   endsr;

   begsr insertDDL;

      exec sql
        insert into IAPGMVARS (IAVMBR,
                               IAVSFILE,
                               IAVLIB,
                               IAVIFSLOC,                                                //0062
                               IAVVAR,
                               IAVDTYP,
                               IAVLEN,
                               IAVDEC,
                               IAVTYP,
                               IAVDATF,
                               IAVKWDNM,
                               IAVKWVAL,
                               IAVKEYWRD)
          values(:vr_srcmbr,
                 :vr_srcspf,
                 :vr_srclib,
                 :vr_IfsLoc,                                                             //0062
                 :w_IAVVAR,
                 :w_IAVDTYP,
                 :w_IAVLEN,
                 :w_IAVDEC,
                 :w_IAV_TYP,
                 :w_IAV_DATF,
                 :w_IAVKWDNM,
                 :w_IAVKWVAL,
                 :W_IAV_KEYWRD);

      if SQLSTATE <> SQL_ALL_OK;
         //log error
      endif;

   endsr;

   Begsr insertIavarrellog;
      // Insert the variables into IAVARREL File
      W_RESRCLIB = vr_srclib;
      W_RESRCFLN = vr_srcspf;
      W_REPGMNM  = vr_srcmbr;
      W_REIFSLOC = vr_IfsLoc;                                                            //0062
      W_RESEQ    = 1;
      W_RERRN    = vr_rrns;
      if w_dsflag = 'Y' or w_ds1flag = 'Y';
         W_REOPC    = 'DCL-DS';
         w_dsflag = 'N';
      else;
      W_REOPC    = 'DCLVAR';
      endif;
      W_REFACT1  = w_IAVVAR;
      W_REFACT2  = w_IAVKWVAL;                                                           //0024
      W_RENUM1 = 0;
      W_RENUM2 = 0;
      W_RENUM3 = 0;
      W_RENUM4 = 0;
      W_RENUM5 = 0;
      W_RENUM6 = 0;
      W_RENUM7 = 0;
      W_RENUM8 = 0;
      W_RENUM9 = 0;

      IaVarRelLog(
  //   W_RESRCLIB  :W_RESRCFLN   :W_REPGMNM     :W_RESEQ       :W_RERRN                  //0062
       W_RESRCLIB  :W_RESRCFLN   :W_REPGMNM     :W_REIFSLOC   :W_RESEQ  :W_RERRN         //0062
      :W_REROUTINE :W_RERELTYP  :W_RERELNUM     :W_REOPC        :W_RERESULT
      :W_REBIF     :W_REFACT1    :W_RECOMP      :W_REFACT2     :W_RECONTIN
      :W_RERESIND  :W_RECAT1     :W_RECAT2      :W_RECAT3       :W_RECAT4
      :W_RECAT5    :W_RECAT6    :W_REUTIL       :W_RENUM1       :W_RENUM2
      :W_RENUM3    :W_RENUM4    :W_RENUM5       :W_RENUM6       :W_RENUM7
      :W_RENUM8    :W_RENUM9    :W_REEXC        :W_REINC  );

      if SQLSTATE <> SQL_ALL_OK;
         //log error
      endif;
   Endsr;
end-proc;

//------------------------------------------------------------------------------------ //
//IaPsrVARfx:                                                                          //
//------------------------------------------------------------------------------------ //
dcl-proc IaPsrVARfx export;
   dcl-pi IaPsrVARfx;
      in_string  char(5000);
      in_type    Char(10);
      in_error   Char(10);
      in_xref    Char(10);
   // in_srclib char(10);                                                                //0062
   // in_srcspf char(10);                                                                //0062
   // in_srcmbr char(10);                                                                //0062
      in_uWSrcDtl likeds(uWSrcDtl);                                                      //0062
      in_rrns    Packed(6:0);
      in_rrne    Packed(6:0);
      in_lname   Char(30);
      in_lword   Char(30);
      in_prc     ind;
   end-pi;

   dcl-s vr_Length     char(10)    inz;
   dcl-s w_IAV_TYP     char(10)    inz;
   dcl-s w_IAV_DATF    char(05)    inz;
   dcl-s w_IAVKWDNM    char(20)    inz;
   dcl-s w_IAVKWVAL    char(40)    inz;
   dcl-s w_IAV_KEYWRD  char(80)    inz;
   dcl-s vr_Data_Typ   char(18)    inz;
   dcl-s vr_PRMLEN     char(10)    inz;
   dcl-s vr_DECPOS     char(10)    inz;
   dcl-s vr_Decimal    char(10)    inz;
   dcl-s vr_String     char(243)   inz;
   dcl-s vr_Fstring    char(5000)  inz;
   dcl-s vr_keyword    char(243)   inz;
   dcl-s vr_Type       char(10)    inz;
   dcl-s vr_xref       char(10)    inz;
   dcl-s vr_srclib     char(10)    inz;
   dcl-s vr_srcspf     char(10)    inz;
   dcl-s vr_srcmbr     char(10)    inz;
   dcl-s vr_IfsLoc     char(100)   inz;                                                  //0062
   dcl-s vr_Pwrdobjv   char(10)    inz;
   dcl-s vr_Objvref    char(10)    inz;
   dcl-s vr_attr       char(10)    inz;
   dcl-s vr_mody       char(10)    inz;
   dcl-s vr_sts        char(10)    inz;
   dcl-s vr_VarName    char(128)   inz;
   dcl-s vr_word       char(128)   inz;
   dcl-s vr_lname      char(30)    inz;
   dcl-s w_IAVVAR      char(80)    inz;
   dcl-s w_IAVDTYP     char(10)    inz;
   dcl-s opc_name      char(10)    inz;
   dcl-s vr_DInvCln    char(1)     inz('"');
   dcl-s vr_Pos        packed(5:0) inz(1);
   dcl-s vr_Spos       packed(6:0) inz(1);
   dcl-s vr_Pos1       packed(5:0) inz(1);
   dcl-s vr_Pos2       packed(5:0) inz(1);
   dcl-s vr_Pos3       packed(5:0) inz(1);
   dcl-s vr_Pos4       packed(2:0) inz;
   dcl-s vr_Position   packed(5:0) inz(1);
   dcl-s vr_rrns       packed(6:0) inz;
   dcl-s vr_rrne       packed(6:0) inz;
   dcl-s vr_seq        packed(6:0) inz;
   dcl-s w_IAVLEN      packed(8:0) inz;
   dcl-s w_IAVDEC      packed(2:0) inz;
   dcl-s w_dsflag      char(1) inz('N');
   dcl-s ds_position   packed(2:0) inz;
   dcl-s w_IAVOFLD     char(10)    inz;

   DCL-DS iavarrelDS extname('IAVARREL') prefix(W_) inz;

   End-ds;

   dcl-ds lDspecV4    likeds(DspecV4) inz;                                               //0004

   vr_string = in_string;
   Clear lDspecV4 ;                                                                      //0004
   If %Subst(vr_string:6:1) = 'D' ;                                                      //0004
      lDspecV4  = vr_string;                                                             //0004
   endif ;                                                                               //0004
   uwsrcdtl = In_uwsrcdtl ;                                                              //0062
   vr_xref = in_xref;
   vr_srclib = in_srclib;
   vr_srcspf = in_srcspf;
   vr_srcmbr = in_srcmbr;
   vr_IfsLoc = in_IfsLoc;                                                                //0062
   vr_rrns = in_rrns;
   vr_rrne = in_rrne;
   vr_lname = in_lname;


   If %Subst(vr_string:6:1) = 'I' And %Subst(vr_string:7:1) <> '*' AND
      %Subst(vr_string : 41 : 1) <> ' ';
      If (in_type = 'RPG') or
         (in_type = 'SQLRPG') ;
         vr_varname = %Trim(%Subst(vr_string:53:14));
      Else;
         vr_varname = %Trim(%Subst(vr_string:49:14));
      Endif;

      w_IAVVAR = vr_varname;
      vr_pwrdobjv  = 'I_VAR';
      vr_sts = *blanks;
      vr_seq = 0;
      vr_objvref = *blanks;
      vr_word = vr_varname;

      if %Subst(vr_string : 42 : 5) <> *blanks and                                       //PJ03
         %check('1234567890 ':%Subst(vr_string : 42 : 5)) = 0  and                       //PJ03
         %Subst(vr_string : 37 : 5) <> *blanks and                                       //PJ03
         %check('1234567890 ':%Subst(vr_string : 37 : 5)) = 0 ;                          //PJ03
      Monitor;
         vr_Length = %Char(%Dec(%Subst(vr_string : 42 : 5) : 5 : 0)
                     - %Dec(%Subst(vr_string : 37 : 5) : 5 :0) + 1);
         w_IAVLEN = %Dec(vr_Length : 5 : 0);
      On-error;
         w_iavlen = *zeros;
      Endmon;
      else ;                                                                             //PJ03
         w_iavlen = *zeros;                                                              //PJ03
      endif ;                                                                            //PJ03

      If %Subst(vr_string : 48 : 1) = ' ';
         vr_attr = 'Char';
         w_IAVDTYP = vr_attr;
         vr_mody = vr_Length;
      Else;
         vr_attr = 'Decimal';
         w_IAVDTYP = vr_attr;
         vr_Decimal = %Subst(vr_string : 47 : 2);
         if %check('1234567890 ':vr_Decimal) = 0 ;                                       //PJ03
            w_IAVDEC = %Dec(vr_Decimal : 2 : 0);
         endif ;                                                                         //PJ03
         vr_mody = %Trim(vr_Length) + ',' + %Trim(vr_Decimal);
      EndIf;
      if in_prc = *on;
         w_IAV_TYP  = 'PG_LO';
      else;
         w_IAV_TYP  = 'PG_GL';
      endIf;

      exec sql
        insert into IAPGMVARS (IAVMBR,
                               IAVSFILE,
                               IAVLIB,
                               IAVIFSLOC,                                                //0062
                               IAVVAR,
                               IAVRRN,
                               IAVDTYP,
                               IAVLEN,
                               IAVDEC,
                               IAVTYP,
                               IAVDATF,
                               IAVKWDNM,
                               IAVKWVAL,
                               IAVKEYWRD)
          values(:vr_srcmbr,
                 :vr_srcspf,
                 :vr_srclib,
                 :vr_IfsLoc,                                                             //0062
                 :w_IAVVAR,
                 :vr_rrns,
                 :w_IAVDTYP,
                 :w_IAVLEN,
                 :w_IAVDEC,
                 :w_IAV_TYP,
                 :w_IAV_DATF,
                 :w_IAVKWDNM,
                 :w_IAVKWVAL,
                 :W_IAV_KEYWRD);
   EndIf;

   If %Subst(vr_string:6:1) = 'I' And %Subst(vr_string:7:1) <> '*' And
      %Subst(vr_string : 41 : 1) = ' ';
      If (in_type = 'RPG') or
         (in_type = 'SQLRPG') ;
         vr_varname = %Trim(%Subst(vr_string:53:14));
      Else;
         vr_varname = %Trim(%Subst(vr_string:49:14));
      Endif;
      If OPC_NAME = 'DCLVAR    '  and
         vr_varname = ' ';
         Return;
      Endif;

      w_IAVVAR = vr_varname;
      vr_pwrdobjv  = 'I_VAR';
      vr_mody = '0';
      vr_sts = *blanks;
      vr_seq = 0;
      vr_attr = *blanks;
      w_IAVOFLD = %Trim(%Subst(vr_string : 21 : 10));
      if in_prc = *on;
         w_IAV_TYP  = 'PG_LO';
      else;
         w_IAV_TYP  = 'PG_GL';
      endIf;

      exec sql
        insert into IAPGMVARS (IAVMBR,
                               IAVSFILE,
                               IAVLIB,
                               IAVIFSLOC,                                                //0062
                               IAVVAR,
                               IAVRRN,
                               IAVOFLD,
                               IAVDTYP,
                               IAVLEN,
                               IAVDEC,
                               IAVTYP,
                               IAVDATF,
                               IAVKWDNM,
                               IAVKWVAL,
                               IAVKEYWRD)
          values(:vr_srcmbr,
                 :vr_srcspf,
                 :vr_srclib,
                 :vr_IfsLoc,                                                             //0062
                 :w_IAVVAR,
                 :vr_rrns,
                 :w_IAVOFLD,
                 :w_IAVDTYP,
                 :w_IAVLEN,
                 :w_IAVDEC,
                 :w_IAV_TYP,
                 :w_IAV_DATF,
                 :w_IAVKWDNM,
                 :w_IAVKWVAL,
                 :W_IAV_KEYWRD);

   EndIf;

   If lDspecV4.specification = 'D' And                                                   //0004
      lDspecV4.star <> '*' And                                                           //0004
      %trim(lDspecV4.declarationType) = 'S';                                             //0004
      If vr_lname =  *Blanks;
         vr_varname = %Trim(lDspecV4.name);                                              //0004
         w_IAVVAR = vr_varname;
      Else;
         vr_varname = %trim(vr_lname) + %Trim(lDspecV4.name);                            //0004
         w_IAVVAR = vr_varname;
      Endif;

      vr_pwrdobjv  = 'S_VAR';
      W_IAV_KEYWRD = %trim(lDspecV4.keyword);                                            //0004

      If %Scan('LIKE':lDspecV4.keyword) = 0;                                             //0004
         vr_Data_Typ = lDspecV4.internalDataType ;                                       //0004
         If vr_Data_Typ = *Blanks and %Subst(lDspecV4.keyword:1:7) = 'SQLTYPE';          //0004
            vr_Pos2 = %scan(':':lDspecV4.keyword:9);                                     //0004
            vr_Pos3 = %scan(')':lDspecV4.keyword:9);                                     //0004
            If vr_Pos2 = 0 and (vr_Pos3 - 9) > *zeros;                                   //0004
               vr_Pos3 = vr_Pos3 - 9 ;                                                   //0004
               exsr GetEqvalentDtaTyp;

               vr_Pos2 = %scan('(':vr_Data_Typ);
               vr_Pos3 = %scan(')':vr_Data_Typ);

               If vr_Pos2 > 0 and vr_Pos3 > 0 and vr_Pos3 > vr_Pos2;
                  vr_Pos4 = vr_Pos3 - vr_Pos2;
               Endif;

               If vr_Pos4 > 1 and
                  %len(vr_Data_Typ) >= vr_Pos4-1 ;                                       //PJ03
                  vr_Length = %trim(%Subst(vr_Data_Typ:vr_Pos2+1:vr_Pos4-1));
               Endif;

               If vr_Pos2 - 2 >= 0;
                  vr_Pos4 = vr_Pos2 - 2;
               Endif;

               If vr_Pos4 > 0 and
                  %len(vr_Data_Typ) > vr_Pos4 ;                                          //PJ03
                  vr_Data_Typ = %Subst(vr_Data_Typ:2:vr_Pos4);
               Endif;
            else;
               If (vr_Pos3 - (vr_Pos2+1)) > 0;
                  vr_Length = %Subst(lDspecV4.keyword                                    //0004
                              :vr_Pos2+1:(vr_Pos3 - (vr_Pos2+1)));                       //0004
               Endif;
               vr_Length = %trim(vr_Length);
               if vr_Pos2 > 9 ;                                                          //0004
                  vr_Pos3 = vr_Pos2 - 9 ;                                                //0004
               endif;
               exsr GetEqvalentDtaTyp;
               vr_Data_Typ = %triml(vr_Data_Typ);
            endif;
         Endif;
         If vr_Length = *Blanks;
            vr_Length = %trim(lDspecV4.toLength);                                        //0004
         Endif;
         vr_Decimal = %trim(lDspecV4.decimalPosition);                                   //0004
         CalDataLengthRPGLE(vr_Data_Typ:
                            w_IAV_DATF:
                            vr_String:
                            vr_Decimal:
                            vr_Length:
                            vr_Pos:
                            vr_Pos1);
         if in_prc = *on;
            w_IAV_TYP  = 'PG_LO';
         else;
            w_IAV_TYP  = 'PG_GL';
         endIf;

         vr_attr      = vr_Data_Typ;
         w_IAVDTYP    = vr_Data_Typ;
         if %trim(vr_Length) <> *blanks;
            if %check(DIGITS1 :%trim(vr_Length)) = 0;
               w_IAVLEN = %dec(vr_Length:8:0);
            endif;
         endif;
         If vr_Decimal <> *Blanks;
            if %check(DIGITS1 :%trim(vr_Decimal)) = 0;
               w_IAVDEC = %dec(vr_Decimal:2:0);
            endif;
         Endif;
         if vr_Length <> *blanks and vr_Decimal <> *blanks;
            vr_Length = %trim(vr_length) + ',' + %trim(vr_Decimal);
         endif;
         if vr_Length <> *blanks and vr_Decimal = *blanks;
            vr_Length = %trim(vr_length);
         endif;
         vr_mody      = vr_Length;
         If lDspecV4.keyword =  *blanks;                                                 //0004
            w_IAVKWDNM = *Blanks;
            w_IAVKWVAL = *Blanks;
         else;
            If %scan('VARYING':lDspecV4.keyword) = 0 and                                 //0004
               %scan('EXPORT':lDspecV4.keyword) = 0  and                                 //0004
               %Scan('IMPORT':lDspecV4.keyword) = 0 ;                                    //0004
               vr_pos = %check(' ':lDspecV4.keyword);                                    //0004
               If vr_pos > 0;
                  If %scan('(' : lDspecV4.keyword :vr_pos) > 0;                          //0004
                     vr_pos1 = %scan('(' :lDspecV4.keyword:vr_pos);                      //0004
                     If vr_pos> 0 and (vr_pos1 - vr_pos) > 0;
                        w_IAVKWDNM = %trim(%subst(lDspecV4.keyword                       //0004
                                  :vr_pos:vr_pos1 - vr_pos));
                     Endif;
                     vr_pos = vr_pos1;
                     vr_pos1 = %scan(')' : lDspecV4.keyword :vr_pos);                    //0004
                     If vr_pos1 > 0 and (vr_pos1 - (vr_pos-1)) > 0;                      //PJ03
                        w_IAVKWVAL = %trim(%subst(lDspecV4.keyword                       //0004
                                   :vr_pos+1:vr_pos1 - vr_pos-1));
                     Endif;
                  endif;
               Endif;
            else;
               If %Scan('VARYING':lDspecV4.keyword ) > 0;
                  w_IAVKWDNM = 'VARYING';
               endif;
               If %Scan('EXPORT':lDspecV4.keyword ) > 0;                                 //0004
                  w_IAVKWDNM = 'EXPORT';
               endif;
               If %Scan('IMPORT':lDspecV4.keyword ) > 0;                                 //0004
                  w_IAVKWDNM = 'IMPORT';
               endif;
               w_IAVKWVAL = *blanks;
         Endif;
      Endif;
   else;
      if in_prc = *on;
         w_IAV_TYP  = 'PG_LO';
      else;
         w_IAV_TYP  = 'PG_GL';
      endIf;

      vr_pos = %Scan('LIKE':lDspecV4.keyword ) + 4;                                      //0004
      if vr_pos > 0 and %len(lDspecV4.keyword) >= vr_pos ;                               //0004
         vr_pos = %Scan('(':lDspecV4.keyword:vr_pos);                                    //0004
      endif ;                                                                            //PJ03
      if vr_pos > 0 and %len(lDspecV4.keyword) >= vr_pos ;                               //0004
         vr_pos1 = %Scan(')': lDspecV4.keyword :vr_pos);                                 //0004
         w_IAVKWDNM = 'LIKE';
         If (vr_pos1 - vr_pos -1) > 1;
            w_IAVKWVAL = %Subst(lDspecV4.keyword:vr_pos + 1:vr_pos1-vr_pos -1);          //0004
         Endif;
         vr_attr = 'LIKE';
         vr_mody = '0';
      endif ;                                                                            //PJ03
   endif;
   vr_sts = *blanks;
   vr_seq = 0;
   If vr_lname =  *Blanks;
     vr_objvref = *blanks;
     vr_word = vr_varname;
   Else;
     vr_objvref = vr_varname;
     vr_word = in_lword;
   Endif;
      exsr insertDDL;
   Endif;

   If lDspecV4.specification = 'D' And                                                   //0004
      lDspecV4.star <> '*' And                                                           //0004
      %trim(lDspecV4.declarationType) = 'C';                                             //0004
      If vr_lname =  *Blanks;
         vr_varname = %Trim(lDspecV4.name);                                              //0004
         w_IAVVAR = vr_varname;
      Else;
         vr_varname = %trim(vr_lname) + %Trim(lDspecV4.name);                            //0004
         w_IAVVAR = vr_varname;
      Endif;

      vr_pwrdobjv  = 'C_VAR';
      vr_attr   = 'CONST';
      w_IAV_TYP = 'CONST';
      vr_mody   = *Blanks;
      vr_sts    = *blanks;
      vr_seq    = 0;
      If vr_lname =  *Blanks;
         vr_objvref   = *blanks;
         vr_word      = vr_varname;
      Else;
         vr_objvref = vr_varname;
         vr_word    = in_lword;
      Endif;

      w_IAVKWDNM = 'CONST';

      If vr_pos1 = 0;
         vr_pos1 = 1;
      endif;

      If %len(lDspecV4.keyword) >= vr_pos1 and                                           //0004
         %Scan('(':vr_string:vr_pos1) > 0;
         If %Scan('CONST':lDspecV4.keyword) > 0;                                         //0004
            vr_pos = %Scan('CONST':lDspecV4.keyword) + 5;                                //0004
            if vr_pos > 0 and %len(lDspecV4.keyword) >= vr_pos ;                         //0004
               vr_pos = %Scan('(':lDspecV4.keyword:vr_pos);                              //0004
            Endif;
            vr_Spos = vr_pos;
            vr_Fstring = lDspecV4.keyword ;                                              //0004
            FindCbr(vr_Spos:vr_Fstring);
            if vr_pos > 0 and %len(lDspecV4.keyword) >= vr_pos ;                         //0004
               vr_pos1 = %Scan(')':lDspecV4.keyword:vr_pos);                             //0004
            endif;                                                                       //PJ03
            If vr_Spos-vr_pos-3 > 0;
               w_IAVKWVAL  = %subst(vr_Fstring:vr_pos + 2:vr_Spos-vr_pos-3);
            Endif;
         endif;
      else;
         vr_pos = %scan(vr_DInvCln:lDspecV4.keyword);                                    //0004
         vr_pos1 = %scan(vr_DInvCln:lDspecV4.keyword:(vr_pos+1));                        //0004
         If vr_pos1-vr_pos-1 > 0;
            w_IAVKWVAL = %trim(%subst(lDspecV4.keyword                                   //0004
                         :(vr_pos+1):(vr_pos1-vr_pos-1)));                               //0004
         Endif;
      endif;

      exsr insertDDL;
   Endif;

   Exsr insertIavarrellog;
   return;

   begsr GetEqvalentDtaTyp;

      If vr_Pos3 > 0 and %len(lDspecV4.keyword) >= vr_Pos3 + 8 ;                         //0004
         vr_Data_Typ = %Subst(lDspecV4.keyword:9:(vr_Pos3));                             //0004
      Endif;
      If vr_Data_Typ <> *Blanks;
         vr_Pos4 = %Lookup(vr_Data_Typ:SQLDatTypArr);
         vr_Data_Typ = SQLDatTypArr(vr_Pos4 + 1);
      Endif;

   endsr;

   begsr insertDDL;

      exec sql
        insert into IAPGMVARS (IAVMBR,
                               IAVSFILE,
                               IAVLIB,
                               IAVIFSLOC,                                                //0062
                               IAVVAR,
                               IAVDTYP,
                               IAVLEN,
                               IAVDEC,
                               IAVTYP,
                               IAVDATF,
                               IAVKWDNM,
                               IAVKWVAL,
                               IAVKEYWRD)
          values(:vr_srcmbr,
                 :vr_srcspf,
                 :vr_srclib,
                 :vr_IfsLoc,                                                             //0062
                 :w_IAVVAR,
                 :w_IAVDTYP,
                 :w_IAVLEN,
                 :w_IAVDEC,
                 :w_IAV_TYP,
                 :w_IAV_DATF,
                 :w_IAVKWDNM,
                 :w_IAVKWVAL,
                 :W_IAV_KEYWRD);

      if SQLSTATE <> SQL_ALL_OK;
         //log error
      endif;

   endsr;
   Begsr insertIavarrellog;
      // Insert the variables into IAVARREL File
      W_RESRCLIB = vr_srclib;
      W_RESRCFLN = vr_srcspf;
      W_REPGMNM  = vr_srcmbr;
      W_REIFSLOC = vr_IfsLoc;                                                            //0062
      W_RESEQ    = 1;
      W_RERRN    = vr_rrns;
      if w_dsflag = 'Y';
         W_REOPC    = 'DCL-DS';
         w_dsflag = 'N';
      else;
      W_REOPC    = 'DCLVAR';
      endif;
      If W_REOPC = 'DCLVAR' and
          w_IAVVAR = ' ';
          return;
      Endif;
      W_REFACT1  = w_IAVVAR;
      W_RENUM1 = 0;
      W_RENUM2 = 0;
      W_RENUM3 = 0;
      W_RENUM4 = 0;
      W_RENUM5 = 0;
      W_RENUM6 = 0;
      W_RENUM7 = 0;
      W_RENUM8 = 0;
      W_RENUM9 = 0;

      IaVarRelLog(
      // W_RESRCLIB  :W_RESRCFLN   :W_REPGMNM     :W_RESEQ       :W_RERRN                //0062
       W_RESRCLIB  :W_RESRCFLN   :W_REPGMNM     :W_REIFSLOC   :W_RESEQ  :W_RERRN         //0062
      :W_REROUTINE :W_RERELTYP  :W_RERELNUM     :W_REOPC        :W_RERESULT
      :W_REBIF     :W_REFACT1    :W_RECOMP      :W_REFACT2     :W_RECONTIN
      :W_RERESIND  :W_RECAT1     :W_RECAT2      :W_RECAT3       :W_RECAT4
      :W_RECAT5    :W_RECAT6    :W_REUTIL       :W_RENUM1       :W_RENUM2
      :W_RENUM3    :W_RENUM4    :W_RENUM5       :W_RENUM6       :W_RENUM7
      :W_RENUM8    :W_RENUM9    :W_REEXC        :W_REINC  );

      if SQLSTATE <> SQL_ALL_OK;
         //log error
      endif;
   Endsr;
end-proc;

//------------------------------------------------------------------------------------ //
//IaLookupOP:                                                                          //
//------------------------------------------------------------------------------------ //
dcl-proc IaLookupOP export;
   dcl-pi IaLookupOP;
     in_string char(5000);
     in_type   char(10);
     in_error  char(10);
     in_xref   char(10);
  // in_srclib char(10);                                                                 //0062
  // in_srcspf char(10);                                                                 //0062
  // in_srcmbr char(10);                                                                 //0062
     in_uWSrcDtl likeds(uWSrcDtl);                                                       //0062
     in_rrn    packed(6:0);
     in_seq    packed(6:0);
   end-pi;

   dcl-ds lk_IAVARRELDS  extname('IAVARREL') prefix(lk_) inz;
   end-ds;

   in_string = %xlate(LOWER: UPPER: in_string);
   uwsrcdtl = In_uwsrcdtl ;                                                              //0062

   if %trim(%subst(in_string:26:6)) = 'LOOKUP';
      lk_reopc    = %trim(%subst(in_string:26:6) );
      lk_refact1  = %trim(%subst(in_string:12:14));
      lk_refact2  = %trim(%subst(in_string:36:14));
      lk_reresult = %trim(%subst(in_string:50:6));
   endif;

   if %trim(%subst(in_string:28:5)) = 'LOKUP';
      lk_reopc    = %trim(%subst(in_string:28:5));
      lk_refact1  = %trim(%subst(in_string:18:10));
      lk_refact2  = %trim(%subst(in_string:33:10));
      lk_reresult = %trim(%subst(in_string:43:10));
   endif;

   //Factor 1 Processing
   lk_refact1 = IsVariableOrConst(lk_refact1);

   //Factor 2 Processing
   lk_refact2 = IsVariableOrConst(lk_refact2);
   lk_reseq = in_seq + 1;

   IaVarRelLog(in_srclib:
               in_srcspf:
               in_srcmbr:
               in_ifsloc:                                                                //0062
               lk_reseq:
               in_rrn:
               lk_reroutine:
               lk_rereltyp:
               lk_rerelnum:
               lk_reopc:
               lk_reresult:
               lk_rebif:
               lk_refact1:
               lk_recomp:
               lk_refact2:
               lk_recontin:
               lk_reresind:
               lk_recat1:
               lk_recat2:
               lk_recat3:
               lk_recat4:
               lk_recat5:
               lk_recat6:
               lk_reutil:
               lk_renum1:
               lk_renum2:
               lk_renum3:
               lk_renum4:
               lk_renum5:
               lk_renum6:
               lk_renum7:
               lk_renum8:
               lk_renum9:
               lk_reexc:
               lk_reinc);

   return;
end-proc;

//------------------------------------------------------------------------------------ //
//IaPsrCPYB:                                                                           //
//------------------------------------------------------------------------------------ //
dcl-proc IaPsrCPYB Export;
   dcl-pi IaPsrCPYB;
      in_string char(5000);
      in_ptype  char(10);
      in_perror char(10);
      in_xref   char(10);
   // in_srclib char(10);                                                                //0062
   // in_srcspf char(10);                                                                //0062
   // in_srcmbr char(10);                                                                //0062
      in_uWSrcDtl likeds(uWSrcDtl);                                                      //0062
      in_rrns   packed(6:0);
      in_rrne   packed(6:0);
   end-pi;

   dcl-ds CB_DataDs1 extname('IACPYBDTL') qualified inz end-ds;

   dcl-ds CB_DataDs2 qualified dim(999);                                                 //0056
      iACpyLib    char(10);                                                              //0056
      iACpySrcPf  char(10);                                                              //0056
   end-ds;                                                                               //0056

   dcl-s CB_WrdObjective char(10)    inz;
   dcl-s CB_Word_Name    char(128)   inz;
   dcl-s CB_SourceStr    char(120)   inz;
   dcl-s CB_xref         char(10)    inz;
   dcl-s CB_srclib       char(10)    inz;
   dcl-s CB_srcpf        char(10)    inz;
   dcl-s CB_srcmbr       char(10)    inz;
   dcl-s CB_IfsLoc       char(100)   inz;                                                //0062
   dcl-s CB_OBJVREF      char(10)    inz;
   dcl-s CB_Attr         char(10)    inz;
   dcl-s CB_Mody         char(10)    inz;
   dcl-s CB_STS          char(10)    inz;
   dcl-s CB_SrcDataStm   char(120)   inz;
   dcl-s CB_string       char(5000)  inz;
   dcl-s CB_Count        packed(4:0) inz;
   dcl-s CB_Scrrn        packed(6:0) inz;
   dcl-s CB_Seq          packed(6:0) inz;
   dcl-s CB_Pos          uns(5)      inz;
   dcl-s CB_Pos1         uns(5)      inz;
   dcl-s CB_Error        ind         inz;
   dcl-s arrIndex        uns(5)      inz;                                                //0056
   dcl-s noOfRows        uns(5)      inz;                                                //0056
   dcl-s wkCpyLib        Char(10)    inz;                                                //0056
   dcl-s wkCpySrcpf      Char(10)    inz;                                                //0056

   dcl-c CB_Quote   '''';

   If in_string = *Blanks;                                                              //VP01
      return;                                                                           //VP01
   EndIf;                                                                               //VP01

   uwsrcdtl = In_uwsrcdtl;                                                              //0062
   CB_string = In_string;
   CB_xref   = In_xref;
   CB_srclib = In_srclib;
   CB_srcpf  = In_srcspf;
   CB_srcmbr = In_srcmbr;
   CB_IfsLoc = In_IfsLoc;                                                               //0062
   CB_scrrn = In_rrns;
   CB_Error  = *off;

   exsr CB_ProcessStr;

   if CB_Error = *off;
      in_perror = 'C';
   endif;

   return;

   begsr CB_ProcessStr;

      CB_SrcDataStm = CB_string;
      CB_SourceStr = CB_string;
      CB_SourceStr = %scanrpl('"':'':CB_SourceStr);
      CB_SourceStr = %scanrpl(CB_Quote:'':CB_SourceStr);
      clear CB_DataDs1;
      exsr CB_ProcessCopyStr;

   endsr;

   begsr CB_ProcessCopyStr;
       clear CB_Pos;
       clear CB_Pos1;

       //Get position of '/COPY'
       CB_Pos = %scan('/COPY':CB_SourceStr);

       //If '/COPY' is not found, search '/INCLUDE'
       if CB_Pos = *zeros;
          CB_Pos = %scan('/INCLUDE':CB_SourceStr);
       endif;
       CB_Pos1 = %scan(' ':CB_SourceStr:(CB_Pos+1));

       //Compiler directive name
       If CB_Pos1 > CB_Pos;
          CB_DataDs1.iACpyDir  = %subst(CB_SourceStr:(CB_pos+1):(CB_pos1 - CB_pos));     //0056
          CB_Word_Name = %subst(CB_SourceStr:(CB_Pos+1):(CB_Pos1 - CB_pos));
       Endif;
       CB_WrdObjective = 'RSVWRD';
       if CB_pos1 > 0;
          CB_SourceStr = %trim(%subst(CB_SourceStr:CB_pos1));
       endif;

       //Check position of '/'
       CB_Pos = %scan('/':CB_SourceStr);
       if CB_Pos = 1;
          //IFS copybook
          exsr CB_ProcessDir;
       else;
          //IFS or library/sourcefile copybook
          exsr CB_ProcessCPYB;
       endif;
   endsr;

   begsr CB_ProcessDir;
      //search for next '/'
      CB_Pos1 = %scan('/':CB_SourceStr:(CB_Pos+1));
      if CB_Pos1 > (CB_Pos+1);
         CB_Word_Name = %subst(CB_SourceStr:(CB_Pos+1):CB_Pos1-(CB_Pos+1));
         CB_WrdObjective = 'CPYBDIR';
         //search for next '/',if found get next dir name
         CB_Pos = %scan('/':CB_SourceStr:(CB_Pos1+1));
         exsr CB_Process2ndDir;
      else;
         //If second '/' not found, insert File name
         exsr CB_WrtFileName;
      endif;
   endsr;

   begsr CB_Process2ndDir;

      //Get names of all the directories
      CB_Pos = %scan('/':CB_SourceStr:(CB_Pos1+1));
      dow CB_Pos > *zero;
         If CB_Pos > (CB_Pos1 + 1);
            CB_Word_Name = %subst(CB_SourceStr:(CB_Pos1+1):(CB_Pos - (CB_Pos1+1)));
         Endif;
         CB_WrdObjective = 'CPYBDIR';
         CB_Pos1 = CB_Pos;
         CB_Pos = %scan('/':CB_SourceStr:(CB_Pos1+1));
      enddo;

      //If '/' is not found, insert file name
      exsr CB_WrtFileName;
   endsr;

   begsr CB_WrtFileName;

      if CB_Pos > *zero;
         CB_Pos += 1;
      else;
         CB_Pos = CB_Pos1 + 1;
      endif;

      CB_Pos1 = %scan(' ':CB_SourceStr:(CB_Pos+1));
      If CB_Pos > 0 and CB_Pos1 > CB_Pos;
         CB_Word_Name = %subst(CB_SourceStr:CB_Pos:(CB_Pos1-CB_Pos));
      Endif;                                                                                 //SB04
    //CB_DataDs1.CBCPYBFNM = CB_Word_Name;                                                   //0056
      CB_WrdObjective = 'CPYBM';

      //Get the entire path
      If (CB_Pos - 1) > 0 and (CB_Pos1 - (CB_Pos-1)) > 0;                                    //SB04
         CB_SourceStr = %scanrpl(%subst(CB_SourceStr:(CB_Pos-1):
                               (CB_Pos1 - (CB_Pos-1))):'':CB_SourceStr);
         CB_DataDs1.IACPYIFS = CB_SourceStr;                                                 //0062
         if %scan('.':CB_Word_Name) > *zeros;                                                //0062
            CB_DataDs1.IACPYMBR = %subst(CB_Word_Name:1:                                     //0062
                          (%scan('.':CB_Word_Name) - 1));                                    //0062
         else;
            CB_DataDs1.IACPYMBR = %trim(CB_Word_Name);
         endif;                                                                              //0062
      Endif;                                                                                 //SB04
    //CB_DataDs1.CBCPYBDIR = CB_SourceStr;                                                   //0056
      exsr CB_WrtCopyBDTL;

   endsr;

   begsr CB_ProcessCPYB;

      select;
      when CB_Pos > 1;
         CB_Word_Name = %subst(CB_SourceStr:1:(CB_Pos-1));

        //If 2nd '/' is found then it is IFS file
         CB_Pos1 = %scan('/':CB_SourceStr:(CB_Pos+1));
         if CB_Pos1 > (CB_Pos+1);
            //1st directory
            CB_Word_Name = %subst(CB_SourceStr:1:(CB_Pos-1));
            CB_WrdObjective = 'CPYBDIR';

            //Remaining directories
            dow CB_Pos1 > *zero;
               If (CB_Pos1 - (CB_Pos + 1)) > 0;                                              //SB04
                  CB_Word_Name = %subst(CB_SourceStr:(CB_Pos+1):
                                     (CB_Pos1 - (CB_Pos+1)));
               Endif;                                                                        //SB04
               CB_WrdObjective = 'CPYBDIR';
               CB_Pos = CB_Pos1;
               CB_Pos1 = %scan('/':CB_SourceStr:(CB_Pos+1));
            enddo;
            exsr CB_WrtFileName;

         else;
            //If 2nd '/' is not found, it is "Lib/srcpf,mbr
            CB_Word_Name = %subst(CB_SourceStr:1:(CB_Pos-1));
            CB_DataDs1.iACpyLib  = CB_Word_Name;                                         //0056
            CB_WrdObjective = 'CPYBLIB';

            //Get the sourcepf name
            exsr CB_ProcessSrcMbr;
         endif;

      when CB_Pos = *zero;
         //If 1st '/' is not found, it is either
         //"SRCPF,member" or "Member"
         exsr CB_ProcessSrcMbr;
      endsl;
   endsr;

   begsr CB_ProcessSrcMbr;

      //Check if ',' is present
      CB_Pos1 = %scan(',':CB_SourceStr:CB_Pos+1);
      if CB_Pos = *zero;
         CB_Pos = 1;
      else;
         CB_Pos += 1;
      endif;

      //If ',' found
      if CB_Pos1 > *zeros;
         If CB_Pos1 > CB_Pos;
            CB_Word_Name = %subst(CB_SourceStr:CB_Pos:(CB_Pos1 - CB_Pos));
         Endif;
       //CB_DataDs1.CBCPYBSRCF = CB_Word_Name;                                           //0056
         CB_DataDs1.iACpySrcPf = CB_Word_Name;                                           //0056
         CB_WrdObjective = 'CPYBSRCF';
         exsr CB_ProcessMbr;
                                                                                             //SH01
         wkCpyLib   = CB_DataDs1.iACpyLib;                                               //0056
         wkCpySrcPf = CB_DataDs1.iACpySrcPf;                                             //0056

                                                                                             //SH01
         exsr CB_WrtCopyBDTL;


      else;
         exsr CB_ProcessMbr;

         wkCpyLib   = CB_DataDs1.iACpyLib;                                               //0056
         wkCpySrcPf = CB_DataDs1.iACpySrcPf;                                             //0056
                                                                                             //SH01
                                                                                             //SH01
         exsr CB_WrtCopyBDTL;

      endif;

   endsr;

   begsr CB_ProcessMbr;

      //Get Member name
      CB_Pos = %scan(' ':CB_SourceStr:(CB_Pos+1));
      If CB_Pos > CB_Pos1;
         CB_Word_Name = %subst(CB_SourceStr:(CB_Pos1+1):(CB_Pos-CB_Pos1));
      Endif;
      CB_DataDs1.iACpyMbr   = CB_Word_Name;                                              //0056
      CB_WrdObjective = 'CPYBM';

   endsr;

   begsr CB_WrtCopyBDTL;

      CB_DataDs1.iAMbrSrcPf = CB_srcpf;                                                  //0056
      CB_DataDs1.iAMbrLib  =  CB_srclib;                                                 //0056
      CB_DataDs1.iAMbrName =  CB_srcmbr;                                                 //0056
      CB_DataDs1.iAMbrRrn  =  CB_ScRrn;                                                  //0056
      //CB_DataDs1.IACRTBYUSR = 'USER JOB';                                              //0056
      //CB_DataDs1.IAUPDBYUSR = 'USER JOB';                                              //0056
      //CB_DataDs1.CBCPYBCNT = 1;                                                        //0056

      //Get number of times the copybook is repeated
      //exsr CB_GetCount;                                                                //0056

      //if CB_Count = *zeros;                                                            //0056
         //Get Member type deatils                                                       //0056
         exec sql                                                                        //0056
           Select IAMBRTYPE  Into:CB_DataDs1.iAMbrType                                   //0056
           From IAMEMBER                                                                 //0056
           Where IASRCLIB   = :CB_DataDs1.iAMbrLib   and                                 //0056
                 IASRCPFNAM = :CB_DataDs1.iAMbrSrcPf and                                 //0056
                 IAMBRNAM   = :CB_DataDs1.iAMbrName ;                                    //0056
         if SQLSTATE <> SQL_ALL_OK;                                                      //0056
           // log error                                                                  //0056
         endif;                                                                          //0056
         //Set audit flag in case Copy Book library not found.                          //0056
         Clear CB_DataDs1.iAAudit ;                                                      //0056
                                                                                         //0056
         exec sql                                                                        //0056
           insert into IACPYBDTL (IACPYDIR  ,                                            //0056
                                  IAMBRSRCPF,                                            //0056
                                  IAMBRLIB,                                              //0056
                                  IAMBRIFS,                                              //0062
                                  IAMBRNAME,                                             //0056
                                  IAMBRTYPE,                                             //0056
                                  IAMBRRRN,                                              //0056
                                  IACPYIFS,                                              //0062
                                  IACPYLIB ,                                             //0056
                                  IACPYSRCPF,                                            //0056
                                  IACPYMBR  ,                                            //0056
                                  IAAUDIT   ,                                            //0056
                                  IACRTBYUSR,                                            //0056
                                  IACRTBYTIM)                                            //0056
             values(:CB_DataDs1.IACPYDIR  ,                                              //0056
                    :CB_DataDs1.IAMBRSRCPF,                                              //0056
                    :CB_DataDs1.IAMBRLIB  ,                                              //0056
                    :CB_DataDs1.IAMBRIFS ,                                               //0062
                    :CB_DataDs1.IAMBRNAME ,                                              //0056
                    :CB_DataDs1.IAMBRTYPE ,                                              //0056
                    :CB_DataDs1.IAMBRRRN  ,                                              //0056
                    :CB_DataDs1.IACPYIFS  ,                                              //0062
                    :CB_DataDs1.IACPYLIB  ,                                              //0056
                    :CB_DataDs1.IACPYSRCPF,                                              //0056
                    :CB_DataDs1.IACPYMBR  ,                                              //0056
                    :CB_DataDs1.iAAudit   ,                                              //0056
                    current_user          ,                                              //0056
                    Current_TimeStamp)    ;                                              //0056

         if SQLSTATE <> SQL_ALL_OK;
            //log error
         endif;
     //else;                                                                             //0056
     //   exec sql                                                                       //0056
     //     update IACPYBDTL                                                             //0056
     //        set CBCPYBCNT = CBCPYBCNT + 1                                             //0056
     //      where CBDIRNAME  = :CB_DataDs1.CBDIRNAME                                    //0056
     //        and CBMEMSRCPF = :CB_DataDs1.CBMEMSRCPF                                   //0056
     //        and CBMEMLIB   = :CB_DataDs1.CBMEMLIB                                     //0056
     //        and CBMEMNAME  = :CB_DataDs1.CBMEMNAME                                    //0056
     //        and CBMEMRRN   = :CB_DataDs1.CBMEMRRN                                     //0056
     //        and CBCPYBLIB  = :CB_DataDs1.CBCPYBLIB                                    //0056
     //        and CBCPYBSRCF = :CB_DataDs1.CBCPYBSRCF                                   //0056
     //        and CBCPYMBRNM = :CB_DataDs1.CBCPYMBRNM                                   //0056
     //        and CBCPYBDIR  = :CB_DataDs1.CBCPYBDIR                                    //0056
     //        and CBCPYBFNM  = :CB_DataDs1.CBCPYBFNM;                                   //0056
     //   if SQLSTATE <> SQL_ALL_OK;                                                     //0056
             //log error
     //   endif;                                                                         //0056
     //endif;                                                                            //0056

      if SQLSTATE <> SQL_ALL_OK;
         CB_Error = *on;
      endif;

   endsr;


   begsr CB_GetCount;
      CB_Count = *zeros;

      exec sql
        select count(1)
         into :CB_Count
         from IACPYBDTL
        where IACPYDIR   = :CB_DataDs1.iACpyDir                                          //0056
          and IAMBRSRCPF = :CB_DataDs1.iAMbrSrcPf                                        //0056
          and IAMBRLIB   = :CB_DataDs1.iAMbrLib                                          //0056
          and IAMBRIFS   = :CB_DataDs1.iAMbrIfs                                          //0062
          and IAMBRNAME  = :CB_DataDs1.iAMbrName                                         //0056
          and IACPYIFS   = :CB_DataDs1.iACpyIfs                                          //0062
          and IACPYLIB   = :CB_DataDs1.iACpyLib                                          //0056
          and IACPYSRCPF = :CB_DataDs1.iACpySrcPf                                        //0056
          and IACPYMBR   = :CB_DataDs1.iACpyMbr   ;                                      //0056

      if SQLSTATE <> SQL_ALL_OK;
         //log error
      endif;

      if SQLSTATE = SQL_ALL_OK and CB_Count <> *zeros;
       //CB_DataDS1.CBCPYBCNT = CB_Count;                                                //0056
      endif;
   endsr;
end-proc;

//------------------------------------------------------------------------------------ //
//IaPsrSQL:                                                                            //
//------------------------------------------------------------------------------------ //
dcl-proc IaPsrSQL export;
   dcl-pi IaPsrSQL;
      in_string char(5000);
      in_ptype  char(10);
      in_perror char(10);
      in_xref   char(10);
   // in_srclib char(10);                                                                 //0062
   // in_srcpf  char(10);                                                                 //0062
   // in_srcmbr char(10);                                                                 //0062
      in_UwSrcDtl Likeds(UwSrcDtl);                                                       //0062
      in_rrns   packed(6:0);
      in_rrne   packed(6:0);                                                              //BA01
      in_srctyp char(10)     options(*nopass);
   end-pi;

   dcl-ds w_infods qualified inz;
      namtyp char(8);
      tblnam char(128);
      libnam char(128);
      clnnam char(128);
   end-ds;
   dcl-s in_str     char(5000)  inz;
   dcl-s in_srcpf   char(10)    inz;                                                      //0062
   dcl-s sq_word    char(128)   inz;
   dcl-s sq_Stmt    char(3000)  inz;
   dcl-s sq_qteflag char(1)     inz('N');
   dcl-s sq_objv    char(10)    inz;
   dcl-s sq_objvref char(10)    inz;
   dcl-s sq_attr    char(10)    inz;
   dcl-s sq_mody    char(10)    inz;
   dcl-s sq_sts     char(10)    inz;                                                      //BA01
   dcl-s w_usg_typ  char(17);                                                             //BA01
   dcl-s w_sql_typ  char(32);
   dcl-s wObjectMode char(10)   inz;
   dcl-s sq_pos     packed(5:0) inz;
   dcl-s sq_qtepos  packed(5:0) inz;
   dcl-s sq_index   packed(4:0) inz;
   dcl-s sq_qtes    packed(5)   inz dim(9999);
   dcl-s sq_seq     packed(6:0) inz;

   dcl-c sq_quote     '''';
   dcl-c sq_dquote    '"';
   dcl-c sq_replace   ':"';

   If in_string = *Blanks;                                                                //VP01
      return;                                                                             //VP01
   EndIf;                                                                                 //VP01

   uwsrcdtl  = In_uwsrcdtl;                                                               //0062
   //in_srcpf  = in_srcspf  ;                                                             //0062
   //Remove EXEC SQL From Work String
   clear sq_pos;
   sq_pos = %scan('EXEC SQL':in_string:1);
   if sq_pos > 0;
      in_string = %replace('': in_string: sq_Pos: 8);
   endif;

   //Remove END EXCE From Work String
   clear sq_pos;
   sq_pos = %scan('END-EXEC': in_string: 1);
   if sq_Pos > 0;
      in_string = %replace('': in_string: sq_Pos: 8);
   endif;

   //Remove SemiColon From Work String
   clear sq_pos;
   sq_pos = %scan(';': in_string: 1);
   if sq_Pos > 0;
      in_string = %replace('': in_string: sq_pos: 1);
   endif;

   //Change '*INTO' to '* INTO ' in Work String
   clear sq_pos;                                                                         //0018
   sq_pos = %scan('*INTO': in_string: 1);                                                //0018
   if sq_Pos > 1;                                                                        //0018
      in_string =%subst(in_string:1:sq_Pos-1)+ '* INTO'+                                 //0018
                 %subst(in_string:sq_Pos+5);                                             //0018
   endif;                                                                                //0018
                                                                                         //0018
   //Change 'INTO:' to 'INTO :' in Work String
   clear sq_pos;                                                                         //0018
   sq_pos = %scan('INTO:': in_string: 1);                                                //0018
   if sq_Pos > 1;                                                                        //0018
      in_string =%subst(in_string:1:sq_Pos-1)+ 'INTO :'+                                 //0018
                 %subst(in_string:sq_Pos+5);                                             //0018
   endif;                                                                                //0018

   //Handle Blank values ' ' in query
   in_string = %xlate(sq_quote: sq_dquote: in_string);
   sq_pos = 1;
   sq_qtepos = %scan(sq_dquote: in_string: sq_pos);


   //Holding the string value in another variable
   in_str = in_string;

   dow sq_qtepos > 0 and sq_index < %elem(sq_qtes);
      if sq_qteflag = 'N';
         sq_qteflag = 'Y';
         sq_index += 1;
         sq_qtes(sq_index) = sq_qtepos;
         in_string= %replace(sq_replace: in_string: sq_qtes(sq_index): 1);
         sq_qtepos += 1;
      else;
         sq_qteflag = 'N';
      endif;

      sq_pos = sq_qtepos + 1;
      if sq_pos < %len(in_string);
         sq_qtepos = %scan(sq_dquote:in_string:sq_pos);
      else;
         sq_qtepos = 0;
      endif;
   enddo;

   //Get Table Info Using Below QRY
   sq_Stmt= 'select coalesce(NAME_TYPE, '' '') AS NAME_TYPE, +
                    coalesce(NAME, '' '' ) AS NAME, +
                    coalesce(SCHEMA, '' '' ) AS SCHEMA, +
                    coalesce(COLUMN_NAME, '' '') AS COLUMN_NAME, +
                    coalesce(USAGE_TYPE, '' '') AS USAGE_TYPE, +
                    coalesce(SQL_STATEMENT_TYPE,'' '') AS SQL_STATEMENT_TYPE  +
               from table(QSYS2.PARSE_STATEMENT(''' + %trim(in_string) + ''')) As A';

   exec sql prepare S_Info from :sq_Stmt;
   if SQLSTATE = SQL_ALL_OK;
      exec sql declare Psr_Info cursor for S_Info;
      if SQLSTATE = SQL_ALL_OK;
         exec sql open Psr_Info;
         if SQLSTATE = SQL_ALL_OK;
            exec sql fetch Psr_Info into :W_InfoDs ,
                                         :w_usg_typ ,:w_sql_typ;                          //BA01
            dow SQLSTATE = SQL_ALL_OK;
               select;
               when W_InfoDs.NamTyp = 'TABLE';
                  sq_Word = W_InfoDs.TblNam;
                  sq_objv = 'TABLE';
                  if w_usg_typ = 'TARGET TABLE';                                          //BA01
                     if w_sql_typ = 'INSERT';                                             //BA01
                        wObjectMode ='O' ;                                                //0042
                     elseif w_sql_typ = 'UPDATE' or                                       //BA01
                             w_sql_typ = 'DELETE' Or                                      //0030
                             w_sql_typ = 'TRUNCATE';                                      //0030
                        wObjectMode ='U' ;                                                //0042
                     endif;                                                               //BA01
                  else;                                                                   //BA01
                     wObjectMode ='I';                                                    //0042
                  endif;                                                                  //BA01
                                                                                          //BA01
                  If wObjectMode <> *Blank;                                               //0043
                     IASRCREFW(in_srclib                                                  //BA01
                               :in_srcmbr                                                 //BA01
                               :in_srctyp                                                 //BA01
                               :in_srcpf                                                  //BA01
                     //        :in_ifsloc                                                 //0062
                               :W_InfoDs.TblNam                                           //BA01
                               :'*FILE'                                                   //BA01
                               :W_InfoDs.libnam                                           //BA01
                               :wObjectMode                                               //BA01
                               :'SQL');                                                   //BA01
                  Endif;                                                                  //0043
                  sq_objvref = 'SQL-TABLE';
               when W_InfoDs.NamTyp = 'COLUMN';
                  sq_Word = W_InfoDs.ClnNam;
                  sq_objv = 'COLUMN';
                  sq_objvref = 'SQL-COLUMN';
               endsl;
               exec sql fetch Psr_Info into :W_InfoDs,                                    //BA01
                                         :w_usg_typ ,:w_sql_typ;                          //BA01
            enddo;
            exec sql Close Psr_Info;
         endif;
      endif;
   endif;

   //Get Reserve Word Info Using Below QRY
   exec sql
    declare word cursor for
     select distinct source_word
     from iapgmref
     where   library_name = :in_srclib                                                  //OJ01
       and   src_pf_name  = :in_srcspf                                                  //OJ01
       and   member_name  = :in_srcmbr                                                  //OJ01 0062
       and   ifs_location = :in_ifsloc                                                  //0062
       and source_rrn between char(:in_rrns) and char(:in_rrne)
       and source_word in (select reserve_word
                              from psqlrsvwrd);

   exec sql open word;
   if SQLSTATE = SQL_ALL_OK;
      exec sql fetch word into :sq_word;
      dow SQLSTATE = SQL_ALL_OK;
         sq_objv = 'RSV-WORD';
         sq_objvref = 'SQL-RSV';
         exec sql fetch word into :sq_word;
      enddo;
      exec sql close word;
   endif;

   //* ---------------- Get Variables relation from SQL QRY -------- *//
   SqlParser( in_Str    :
              in_xref   :                                                                //YK02
          //  in_srclib :                                                                //0062
          //  in_srcpf  :                                                                //0062
          //  in_srcmbr :                                                                //0062
              in_UwSrcDtl:                                                               //0062
              in_rrns   :
              in_rrne );

   in_perror = 'C';
   return;
end-proc;

//------------------------------------------------------------------------------------ //
//Split_Component_2:                                                                   //
//------------------------------------------------------------------------------------ //
dcl-proc Split_Component_2 export;
   dcl-pi Split_Component_2;
      sc_string char(80);
      sc_array  char(80) dim(15);
      sc_index  packed(4:0);
   end-pi;

   dcl-s string    char(5000)  inz;
   dcl-s s_bracket packed(4:0) inz;
   dcl-s s_pos     packed(6:0) inz;
   dcl-s s_Spos    packed(6:0) inz;
   dcl-s s_Epos    packed(6:0) inz;
   dcl-s s_start   packed(6:0) inz;
   dcl-s old_plus  packed(6:0) inz(1);
   dcl-s j         packed(4:0) inz;

   sc_index = 1;
   s_pos    = %scan('+' :sc_string  :1);
   s_start  = 1;
   dow s_pos > 0;
      s_bracket = 0;

      if s_pos > s_start;
         s_Spos = ProcessScan4('(' :sc_string :s_start :s_pos-s_start);
         if s_Spos > 0 and s_pos > s_start;
            s_Epos = ProcessScan4(')' :sc_string :s_start :s_pos-s_start);
         endif;

         dow s_Spos > 0 or s_Epos > 0;
            select;
            when s_Spos > 0; // and s_Spos < s_Epos;                                      //AS01
               s_bracket += 1;
               s_start    = s_Spos + 1;
               if s_start > 0 and s_pos > s_start;
                  s_Spos = ProcessScan4('(' :sc_string :s_start :s_pos-s_start);
               endif;
            when s_Epos > 0;
               s_bracket -= 1;
               s_start = s_Epos + 1;
               if s_start > 0 and s_pos > s_start;
                  s_Epos = ProcessScan4(')' :sc_string :s_start :s_pos-s_start);
               endif;
            endsl;
         enddo;
      endif;

      if s_bracket = 0 and s_pos > old_plus
          and sc_index <= %elem(sc_array);
         sc_array(sc_index) = %subst(sc_string :old_plus :s_pos -old_plus);
         old_plus = s_pos + 1;
         sc_index += 1;
      else;
      if s_bracket > 0 and s_spos > 1;
            for j = 1 to s_bracket;
               s_spos = ProcessScanR('(' :sc_string :1 :s_spos-1);
            endfor;
         endif;
         string = sc_string;
         s_start  = s_Spos;
         s_pos  = s_Spos;
      endif;
      s_pos = %scan('+' :sc_string  :s_pos+1);
   enddo;

   if sc_index = 1;
      sc_array(1) = sc_string;
      sc_index = 2;
   elseif sc_index > 1 and sc_index <= %elem(sc_array);
      sc_array(sc_index) = %subst(sc_string  :old_plus);
      sc_index += 1;
   endif;

   return;
end-proc;

//------------------------------------------------------------------------------------ //
//Split_Component_3:                                                                   //
//------------------------------------------------------------------------------------ //
dcl-proc Split_Component_3 export;
   dcl-pi Split_Component_3;
      sc_string char(80);
      sc_array  char(80) dim(15);
      sc_index  packed(4:0);
   end-pi;

   dcl-s string    char(5000)  inz;
   dcl-s s_bracket packed(4:0) inz;
   dcl-s s_pos     packed(6:0) inz;
   dcl-s s_Sposbk  packed(6:0) inz;
   dcl-s s_Sposbk1 packed(6:0) inz;
   dcl-s s_Spos    packed(6:0) inz;
   dcl-s s_Epos    packed(6:0) inz;
   dcl-s s_start   packed(6:0) inz;
   dcl-s old_plus  packed(6:0) inz(1);
   dcl-s j         packed(4:0) inz;

   sc_index = 1;
   s_pos    = %scan('+' :sc_string  :1);
   s_start  = 1;
    dow s_pos <> 0;
      s_bracket  = 0;

      if s_pos > s_start;
        s_Spos = ProcessScan4('(': sc_string: s_start: s_pos-s_start);
        if s_pos > s_start;
           s_Epos = ProcessScan4(')': sc_string: s_start: s_pos-s_start);
        endif;

        dow s_Spos > 0 or s_Epos > 0;
           select;
           when s_Spos > 0 and s_Spos < s_Epos;
              s_bracket += 1;
              s_start    = s_Spos + 1;
              if s_pos > s_start;
                 s_Spos = ProcessScan4('(': sc_string: s_start: s_pos-s_start);
              endif;
           when s_Epos > 0;
              s_bracket -= 1;
              s_start    = s_Epos + 1;
              if s_pos > s_start;
                 s_Epos = ProcessScan4(')': sc_string: s_start: s_pos-s_start);
              endif;
           endsl;
        enddo;
      endif;

      if s_bracket = 0 and old_plus > 0 and s_pos > old_plus
         and sc_index <= %elem(sc_array);
         sc_array(sc_index) = %subst(sc_string  :old_plus :s_pos -old_plus);
         old_plus =  s_pos + 1;
         sc_index += 1;
      else;
         if s_bracket > 0 and s_spos > 1;
            for j = 1 to s_bracket;
               s_spos = ProcessScanR('(': sc_String: 1: s_spos-1);
            endfor;
         endif;
         string = sc_string;
         FindCbr(s_Spos :string);
         s_start = s_Spos;
         s_pos = s_Spos;
      endif;
      s_pos = %scan('+' :sc_string  :s_pos+1);
   enddo;

  //means array has no element
   if sc_index = 1;
      sc_array(1) = sc_string;
      sc_index = 2;
   elseif sc_index > 1 and sc_index <= %elem(sc_array);
      sc_array(sc_index) = %subst(sc_string  :old_plus);
      sc_index += 1;
   endif;

   return;
end-proc;

//------------------------------------------------------------------------------------ //
//IaPsrCALLP:                                                                          //
//------------------------------------------------------------------------------------ //
dcl-proc IaPsrCALLP export;
   dcl-pi IaPsrCALLP;
      In_string char(5000);
      In_type   char(10);
      In_error  char(10);
      In_xref   char(10);
   // in_srclib char(10);                                                                //0062
   // in_srcspf char(10);                                                                //0062
   // in_srcmbr char(10);                                                                //0062
      in_uWSrcDtl likeds(uWSrcDtl);                                                      //0062
      In_rrns   packed(6:0);
      In_rrne   packed(6:0);
   end-pi;

   dcl-s CP_WordNM         char(128)    inz;
   dcl-s CP_WrdObjective   char(10)     inz;
   dcl-s CP_var            char(14)     inz;
   dcl-s CP_dtype          char(10)     inz;
   dcl-s CP_Opcode         char(10)     inz;
   dcl-s CP_PlistNM        char(14)     inz;
   dcl-s CP_PlistRpg       char(10)     inz;
   dcl-s CP_ParmNM         char(14)     inz;
   dcl-s CP_TempPlist      char(21)     inz;
   dcl-s CP_Source         char(120)    inz;
   dcl-s CP_string         char(5000)   inz;
   dcl-s CP_PRMSTR         char(128)    inz;
   dcl-s CP_xref           char(10)     inz;
   dcl-s CP_srclib         char(10)     inz;
   dcl-s CP_srcpf          char(10)     inz;
   dcl-s CP_srcmbr         char(10)     inz;
   dcl-s CP_IfsLoc         char(100)    inz;                                             //0062
   dcl-s CP_OBJVREF        char(10)     inz;
   dcl-s CP_Attr           char(10)     inz;
   dcl-s CP_Mody           char(10)     inz;
   dcl-s CP_STS            char(10)     inz;
   dcl-s CP_CLProcnm       char(128)    inz;
   dcl-s CP_From_Obj       char(10)     inz;
   dcl-s CP_Called_Obj     char(14)     inz;
   dcl-s CP_Call_Type      char(4)      inz;
   dcl-s CP_Category       char(2)      inz;
   dcl-s CP_Parm_Type      char(10)     inz;
   dcl-s CP_PrcName        char(128)    inz;
   dcl-s CP_PrcNameFrmFile char(128)    inz;
   dcl-s CP_WrdObj         char(10)     inz;
   dcl-s CP_CLProcnmTemp   char(128)    inz;
   dcl-s CP_callingProc    char(128)    inz;
   dcl-s w_string          char(5000)   inz;
   dcl-s w_array           char(80)     inz dim(50);
   dcl-s recFound          char(1)      inz;
   dcl-s i                 packed(4:0)  inz;
   dcl-s CP_Scrrn          packed(6:0)  inz;
   dcl-s CP_Fact2StrPos    packed(6:0)  inz;
   dcl-s CP_Fact2Len       packed(6:0)  inz;
   dcl-s CP_ExtFact2Pos    packed(6:0)  inz;
   dcl-s CP_ExtFact2len    packed(6:0)  inz;
   dcl-s CP_ResultStrPos   packed(6:0)  inz;
   dcl-s CP_ResultLen      packed(6:0)  inz;
   dcl-s CP_ParmlenPos     packed(6:0)  inz;
   dcl-s CP_Parmlenlen     packed(6:0)  inz;
   dcl-s CP_ParmDecPos     packed(6:0)  inz;
   dcl-s CP_Parmdeclen     packed(6:0)  inz;
   dcl-s CP_Pos            packed(6:0)  inz;
   dcl-s CP_Pos1           packed(6:0)  inz;
   dcl-s CP_Pos2           packed(6:0)  inz;
   dcl-s CP_RRN            packed(6:0)  inz;
   dcl-s CP_len            packed(8)    inz;
   dcl-s CP_dpos           packed(2)    inz;
   dcl-s CP_ParmCount      packed(4)    inz;
   dcl-s CP_ParmLen        packed(8)    inz;
   dcl-s CP_ParmDec        packed(2)    inz;
   dcl-s CP_Seq            packed(6:0)  inz;
   dcl-s CP_ID             packed(10:0) inz;
   dcl-s w_index           packed(4:0)  inz;
   dcl-s w_count           packed(4:0)  inz;
   dcl-s CP_Call_Seq#      packed(7)    inz;
   dcl-s CP_PGMRRN         packed(6:0)  inz;
   dcl-s w_Rpg3Flg         ind          inz(*off);
   dcl-s w_Rpg4Flg         ind          inz(*off);
   dcl-s CP_Error          ind          inz;

   dcl-c CP_Quotes   const('"');

   If In_string = *Blanks;                                                              //VP01
      return;                                                                           //VP01
   EndIf;                                                                               //VP01

   uwsrcdtl = In_uwsrcdtl;                                                              //0062

   CP_string = In_string;
   CP_xref   = In_xref;
   CP_srclib = In_srclib;
   CP_srcpf  = In_srcspf;
   CP_srcmbr = In_srcmbr;
   CP_IfsLoc = in_IfsLoc;                                                                //0062
   CP_scrrn  = In_rrns;
   CP_Error  = *off;
   CP_Pos    = %scan('CALL':CP_String);

   exsr CP_ProcessStR;
   exsr CP_ProcessFreeStr;

   if CP_Error = *off;
      In_error = 'C';
   endif;

   return;

   begsr CP_ProcessStr;
      CP_Pos    = %scan('CALL':CP_String);
      select;
      when CP_Pos = 28;
         CP_Fact2StrPos  = 33;
         CP_Fact2Len     = 10;
         CP_ResultStrPos = 43;
         CP_ResultLen    = 6;
         CP_ParmlenPos   = 49;
         CP_Parmlenlen   = 3;
         CP_ParmDecPos   = 52;
         CP_Parmdeclen   = 1;
         CP_Opcode       = %trim(%subst(cp_string:cp_pos:5));
         w_Rpg3Flg       = *on;
      when CP_Pos = 26;
         CP_Fact2StrPos  = 36;
         CP_Fact2Len     = 14;
         CP_ExtFact2Pos  = 36;
         CP_ExtFact2len  = 45;
         CP_ResultStrPos = 50;
         CP_ResultLen    = 14;
         CP_ParmlenPos   = 64;
         CP_Parmlenlen   = 5;
         CP_ParmDecPos   = 69;
         CP_Parmdeclen   = 2;
         CP_Opcode       = %trim(%subst(cp_string:cp_pos:10));
         w_Rpg4Flg       = *on;
      endsl;
      exsr CP_ProcessFixStr;
   endsr;

   begsr CP_ProcessFixStr;
      if (CP_Opcode = 'CALL ' and w_Rpg3Flg = *on)       or
         ((CP_Opcode = 'CALL ' or CP_Opcode = 'CALL(E)') and w_Rpg4Flg = *on);
         w_Rpg3Flg = *off;
         w_Rpg4Flg = *off;
         if CP_Fact2StrPos > 0 and CP_Fact2Len > 0;
            CP_Called_Obj = %trim(%subst(CP_String:CP_Fact2StrPos:CP_Fact2Len));
         endif;

         CP_Pos1 = %scan(CP_Quotes:CP_Called_Obj:1);

         if CP_Pos1 > 0;
            CP_Pos2 = %scan(CP_Quotes:CP_Called_Obj:CP_Pos1+1);
            If CP_Pos2-2 > 0;
               CP_Called_Obj = %trim(%subst(CP_Called_Obj:CP_Pos1+1:CP_Pos2-2));
            Endif;
         else;
            CP_Pos1 = %scan(' ':CP_Called_Obj);
            If CP_Pos1-1 > 0;
               CP_Called_Obj = %subst(CP_Called_Obj:1:CP_Pos1-1);
            Endif;
         endif;

         CP_WordNM     = CP_Called_Obj;
         CP_Call_Type    = 'PGM';
         clear CP_CLProcNm;
         CP_WrdObjective = 'CALL-PGM';

         if CP_ResultStrPos > 0 and CP_ResultLen > 0;
            Cp_PlistNM  = %subst(CP_String:CP_ResultStrPos:CP_ResultLen);
         endif;

         CP_PlistRpg = Cp_PlistNM;
         exsr CP_WrtPgmDtl;

         if CP_PlistNM <> *blanks and %scan(' PARM ':CP_String) = 0;
            exsr CP_ProcessPlist;
         else;
            clear CP_Plistnm;
            exsr CP_ProcessParm;
         endif;
      elseif ((CP_Opcode <> 'CALL ' and CP_Opcode <> 'CALL(E)') and w_Rpg4Flg = *on);
         w_Rpg4Flg = *off;
         if CP_ExtFact2Pos > 0 and CP_ExtFact2Len > 0;
            CP_CLProcNm = %trim(%subst(CP_String:CP_ExtFact2Pos:CP_ExtFact2Len));
         endif;
         CP_Pos1 = %scan('(' :CP_CLProcNm :1);

         if CP_Pos1-1 > 0;
             CP_CLProcNm = %trim(%subst(CP_CLProcNm:1:CP_Pos1-1));
         else;
            CP_CLProcNm = %trim(CP_CLProcNm);
         endif;

         CP_Call_Type    = 'PROC';
         CP_WrdObjective = 'CALL-PROC';
         exsr CP_ProcessCALLPStr;
      endif;
   endsr;

   begsr CP_ProcessPlist;
      if CP_Pos = 26;
         CP_TempPlist = '%' + Cp_PlistNM + 'PLIST%';
      else;
         CP_TempPlist = '%' + Cp_PlistRpg + 'PLIST%';
      endif;

      exec sql
        select XSRCRRN
          into :CP_rrn
        from IAQRPGSRC
        where   Library_Name  = :CP_srclib
          and   SourcePf_Name = :CP_srcpf
          and   Member_Name   = :CP_srcmbr
          And   IFS_Location  = :CP_IfsLoc                                               //0062
          and Upper(SOURCE_DATA) like :CP_TempPlist
        fetch first 1 rows only;

      if SQLSTATE <> SQL_ALL_OK;
         //log error
      endif;

      exec sql
       declare C_getSourceData Cursor for
        select Upper(source_data)
        from IAQRPGSRC
        where   Library_Name  = :CP_srclib
          and   SourcePf_Name = :CP_srcpf
          and   Member_Name   = :CP_srcmbr
          and   IFS_Location  = :CP_IfsLoc                                               //0062
          and Source_RRn    > :CP_Rrn;

      exec sql open C_getSourceData;
      if SQLSTATE = SQL_ALL_OK;
         exec sql fetch From C_getSourceData Into :CP_Source;
         dow SQLSTATE = SQL_ALL_OK and %scan('PARM':CP_Source) > 0;
            clear CP_Parm_Type;
            clear CP_ParmLen;
            clear CP_ParmDec;
            if CP_ResultStrPos > 0 and CP_ResultLen > 0;
               CP_ParmNM  = %trim(%subst(CP_Source:CP_ResultStrPos:CP_ResultLen));
            endif;

            if CP_ParmlenPos > 0 and CP_Parmlenlen > 0;
               CP_ParmLen = GetNumericValue(%subst(CP_Source :CP_ParmlenPos:CP_Parmlenlen));
            endif;

            if CP_ParmDecPos > 0 and CP_Parmdeclen > 0;
               CP_Parmdec = GetNumericValue(%subst(CP_Source:CP_ParmDecPos:CP_Parmdeclen));
            endif;

            if CP_ParmDecPos > 0 and CP_Parmdeclen > 0
               and %subst(CP_Source: CP_ParmDecPos: CP_Parmdeclen) <> *blanks;
               CP_Parm_Type = 'Packed';
            else;
               CP_Parm_Type = 'Char';
            endif;

            if CP_ParmDecPos > 0 and CP_Parmdeclen > 0
               and %subst(CP_Source: CP_ParmDecPos: CP_Parmdeclen) <> *blanks;
            // exsr CP_WrtVardtl;                                                        //0011
            else;
               exec sql
                 select IAV_DTYP,
                        IAV_LEN,
                        IAV_DEC
                   into :CP_Parm_Type,
                        :CP_ParmLen,
                        :CP_ParmDec
                 from IAPGMVARS
                 where   IAV_LIB   = :CP_srclib                                          //0002
                   and   IAV_SFILE = :CP_srcpf                                           //0002
                   and   IAV_MBR   = :CP_srcmbr                                          //0002
                   and   IAV_IFSLOC= :CP_IfsLoc                                          //0002 0062
                   and IAV_VAR   = :CP_ParmNm                                            //0002
                 fetch first 1 rows only;

               if SQLSTATE <> SQL_ALL_OK;
                 //log error
               endif;
            endif;
            exsr CP_WrtParmDtl;
            clear CP_ParmNm;
            exec sql fetch next from C_getSourceData  into :CP_Source;
         enddo;
         exec sql close C_getSourceData;
      endif;
   endsr;

   begsr CP_WrtParmDtl;

      if CP_PrcNameFrmFile <> *blanks;
         CP_CLProcnm =  CP_PrcNameFrmFile;
      endif;

      exec sql
        insert Into IACALLPARM (CPMEMSRCPF,
                                CPMEMLIB,
                                CPMEMNAME,
                                CPIFSLOC ,                                                //0062
                                CPMEMRRN,
                                CPCLDOBJ,
                                CPCALTYP,
                                CPCALLSQ,
                                CPPLISTNM,
                                CPPARMNAME)
          //                    CPAPMTYP,                                                 //0022
          //                    CPPARMLEN,                                                //0022
          //                    CPPARMDEC)                                                //0022
          values(:CP_srcpf,
                 :CP_srclib,
                 :CP_srcmbr,
                 :CP_IfsLoc,                                                              //0062
                 :CP_scrrn,
                 :CP_Called_Obj,
                 :CP_Opcode,
                 :CP_Call_Seq#,
                 :CP_PlistNM,
                 :CP_ParmNM) with nc;                                                     //0022
        //       :CP_Parm_Type,                                                           //0022
        //       :CP_ParmLen,                                                             //0022
        //       :CP_ParmDec)  with nc;                                                   //0022

      if sqlstate <> SQL_ALL_OK;
        //log error
      endif;
   endsr;

   begsr CP_WrtPgmDtl;
      clear CP_Call_Seq#;
      exec sql
        select COUNT(CPCLDOBJ)
          into :CP_CALL_SEQ#
        from IAPGMCALLS
        where   CPMEMSRCPF = :CP_srcpf
          and   CPMEMLIB   = :CP_srclib
          and   CPMEMNAME  = :CP_srcmbr
          and   CPIFSLOC   = :CP_IfsLoc                                                   //0062
          and CPCLDPRC   = :CP_CLProcnm
          and CPCLDOBJ   = :CP_Called_Obj;

      if SQLSTATE = SQL_ALL_OK;
         CP_CALL_SEQ# = CP_CALL_SEQ# + 1;
      endif;

      if CP_PrcNameFrmFile <> *blanks;
         CP_CLProcnm =  CP_PrcNameFrmFile;
      endif;

      exec sql
        insert into IAPGMCALLS (CPMEMSRCPF,
                                CPMEMLIB,
                                CPMEMNAME,
                                CPIFSLOC ,                                                //0062
                                CPMEMRRN,
                                CPCLDOBJ,
                                CPFRMPRC,
                                CPCLDPRC,
                                CPCALLSQ,
                                CPFRMTYP,
                                CPCLDTYP,
                                CPCALLCT)
          values(:CP_srcpf,
                 :CP_srclib,
                 :CP_srcmbr,
                 :CP_IfsLoc,                                                              //0062
                 :CP_scrrn,
                 :CP_Called_Obj,
                 :CP_CallingProc,
                 :CP_CLProcnm,
                 :CP_CALL_SEQ#,
                 :CP_Call_Type,
                 :CP_Opcode,
                 :CP_CATEGORY);

      if SQLSTATE <> SQL_ALL_OK;
        //log error
      endif;
   endsr;

   begsr CP_ProcessCALLPStr;
      clear CP_CALLED_OBJ;
      CP_WordNM = CP_CLProcnm;
      CP_WrdObjective = 'CALL-PROC';
      exsr CP_GetProcName;
      exsr CP_WrtPgmDtl;
      exsr GetProcParmDtl;
   endsr;


   begsr CP_ProcessPARM;
      CP_Pos1     = %scan(' @ ':CP_String);

      dow CP_Pos1 > 0 and %scan('PARM':CP_String) > 0;
         CP_Pos2 = %scan(' @ ':CP_String:CP_Pos1+2);
         if CP_Pos2 > 0 and CP_Pos2-CP_Pos1-2 > 0;
            CP_Prmstr = %subst(CP_String:CP_Pos1+2:CP_Pos2-CP_Pos1-2);
         else;
            CP_Prmstr = %subst(CP_String:CP_Pos1+2);
         endif;

         if CP_ResultStrPos > 0 and CP_ResultLen > 0;
            CP_ParmNM = %trim(%subst(CP_Prmstr:CP_ResultStrPos:CP_ResultLen));
         endif;

         if CP_ParmlenPos > 0 and %subst(CP_Prmstr:CP_ParmlenPos) = *blanks;
            exec sql
              select IAV_DTYP, IAV_LEN, IAV_DEC
                into :CP_Parm_Type,
                     :CP_ParmLen,
                     :CP_ParmDec
              from IAPGMVARS
              where   IAV_LIB   = :CP_srclib                                             //0002
                and   IAV_SFILE = :CP_srcpf                                              //0002
                and   IAV_MBR   = :CP_srcmbr                                             //0002
                and   IAV_IFSLOC= :CP_IfsLoc                                             //0002 0062
                and IAV_VAR   = :CP_ParmNm                                               //0002
              fetch first 1 rows only;

            if SQLSTATE <> SQL_ALL_OK;
              //log error
            endif;
         else;
            if CP_ParmlenPos > 0 and CP_Parmlenlen > 0;
               CP_ParmLen = GetNumericValue(%subst(CP_Prmstr:CP_ParmlenPos
                                                :CP_Parmlenlen));
            endif;

            if CP_ParmDecPos > 0 and CP_Parmdeclen > 0;
               CP_ParmDec = GetNumericValue(%subst(CP_Prmstr:CP_ParmDecPos
                                                :CP_Parmdeclen));
            endif;

            if CP_ParmDecPos > 0 and CP_Parmdeclen > 0
               and %subst(CP_Prmstr:CP_ParmDecPos :CP_Parmdeclen) = *blanks;
               CP_Parm_Type = 'CHAR';
            else;
               CP_Parm_Type = 'PACKED';
            endif;
          //  exsr CP_Wrtvardtl;                                                         //0011
         endif;

         exsr CP_WrtParmDtl;
         CP_Pos1 = %scan(' @ ':CP_String:CP_Pos1+2);
         clear CP_Prmstr;
         clear CP_ParmNM;
         clear CP_Parm_Type;
         clear CP_ParmLen;
         clear CP_ParmDec;
      enddo;
   endsr;

 //begsr CP_WrtVarDtl;                                                                   //0011
 //   exec sql                                                                           //0011
 //     insert into IAPGMVARS (IAVMBR,                                                   //0011
 //                            IAVSFILE,                                                 //0011
 //                            IAVLIB,                                                   //0011
 //                            IAVVAR,                                                   //0011
 //                            IAVTYP,                                                   //0011
 //                            IAVOFLD,                                                  //0011
 //                            IAVFILE,                                                  //0011
 //                            IAVPRCNM,                                                 //0011
 //                            IAVDTYP,                                                  //0011
 //                            IAVLEN,                                                   //0011
 //                            IAVDEC)                                                   //0011
 //       values(:CP_srcmbr,                                                             //0011
 //              :CP_srcpf,                                                              //0011
 //              :CP_srclib,                                                             //0011
 //              :CP_ParmNM,                                                             //0011
 //              'PROC-VAR',                                                             //0011
 //              ' ',                                                                    //0011
 //              ' ',                                                                    //0011
 //              :CP_CLProcNm,                                                           //0011
 //              :CP_Parm_Type,                                                          //0011
 //              :CP_ParmLen,                                                            //0011
 //              :CP_ParmDec) with NC;                                                   //0011
 //                                                                                      //0011
 //   if SQLSTATE <> SQL_ALL_OK;                                                         //0011
        //log error
 //   endif;                                                                             //0011
 //endsr;                                                                                //0011

   begsr CP_ProcessFreeStr;
      if %scan(';':Cp_String) > 0;
         CP_Pos = %scan('CALLP':CP_String);
         if CP_Pos > 0;
            CP_Fact2StrPos  = %scan(' ':CP_String:CP_Pos);
            if CP_Fact2StrPos > CP_Pos;
               CP_WordNM = %trim(%subst(CP_String:CP_Pos:CP_Fact2StrPos - CP_Pos ));
            endif;
            CP_OpCode       = CP_WordNM;
            CP_WrdObjective = 'OPCODE';
            CP_Fact2StrPos += 1;
            if CP_Fact2StrPos > 0
               and %scan('(':CP_String:CP_Fact2StrPos) > CP_Fact2StrPos;
               CP_CLProcnm = %subst(CP_String:CP_Fact2StrPos:
                    (%scan('(':CP_String:CP_Fact2StrPos) - CP_Fact2StrPos));
            endif;
            exsr CP_ProcessCALLPStr;
         endif;
      endif;
   endsr;

   begsr CP_GetProcName;
      exec sql
        select PSRCRRN
          into :CP_PGMRRN
        from IAPGMREF
        where   PLIBNAM  = :CP_srclib
          and   PSRCPFNM = :CP_srcpf
          and   PMBRNAM  = :CP_srcmbr
          and   PIFSLOC  = :CP_IfsLoc                                                    //0062
          and PSRCWRD  = Trim(:CP_CLProcnm)
        fetch first row only;

      if SQLSTATE <> SQL_ALL_OK;
         //log error
      endif;

      exec sql
       declare PgmRefCur_2 cursor for
        select PSRCWRD, PWRDOBJV
        from IAPGMREF
        where   PLIBNAM  = :CP_srclib
          and   PSRCPFNM = :CP_srcpf
          and   PMBRNAM  = :CP_srcmbr
          and   PIFSLOC  = :CP_IfsLoc                                                    //0062
          and CMDID    > :CP_id;

      exec sql open PgmRefCur_2;
      if SQLSTATE = SQL_ALL_OK;
         exec sql fetch from PgmRefCur_2 into :CP_PrcName, :CP_WrdObj;
         dow SQLSTATE = SQL_ALL_OK;
            if (CP_WrdObj = 'EX-PGM') or (CP_WrdObj = 'EX-PROC');
               CP_PrcNameFrmFile = CP_PrcName;
               leave;
            endif;

            if CP_PrcName <> 'EXTPGM' and CP_PrcName <> 'EXTPROC' and
               %trim(CP_PrcName) <> %trim(CP_CLProcnm) and
               CP_PrcName <> 'DCL' and CP_PrcName <> 'PR';
               leave;
            endif;

            exec sql fetch next from PgmRefCur_2 into :CP_PrcName, :CP_WrdObj;
         enddo;
         exec sql close PgmRefCur_2;
      endif;
   endsr;

   begsr GetProcParmDtl;
      clear w_string;
      clear w_array;
      clear w_index;
      clear w_count;
      clear i;

      exec sql
        select 'Y' as flag
          into :recFound
        from IAPRCPARM
        where PPRPIFLG = 'PI'
          and   PLIBNAM  = trim(:CP_srclib)
          and   PSRCPF   = trim(:CP_srcpf)
          and   PMBRNAM  = trim(:CP_srcmbr)
          and   PIFSLOC  = trim(:CP_IfsLoc)                                              //0062
          and PPRNAM   = trim(:CP_CLProcnm)
        fetch  first row only;

      if SQLSTATE <> SQL_ALL_OK;
        //log error
      endif;

      if recFound  = 'Y';
         CP_pos1 = %scan('(' :cp_string);
         CP_Pos2 = CP_Pos1;
         FindCbr(CP_Pos2 :cp_string);
         if cp_pos2-cp_pos1-1 > 0 ;
            w_string = %subst(cp_string :cp_pos1+1 :cp_pos2-cp_pos1-1);
         endif;
         clear w_array;
         clear w_index;
         cp_pos1 = 1;

         cp_pos2 = %scan(':' :w_string :1);
         dou cp_pos2 = 0;
            w_index += 1;
            if cp_pos1 > 0 and cp_pos2 > cp_pos1;
               w_array(w_index) = %subst(w_string :cp_pos1 :cp_pos2-cp_pos1);
            endif;                                                                         //BS04
            cp_pos1 = cp_pos2+1;
            cp_pos2 = %scan(':' :w_string :cp_pos2+1);
         enddo;

         w_index += 1;
         if cp_pos1 > 0 and w_index < %elem(w_array);
            w_array(w_index) = %subst(w_string :cp_pos1);
         endif;

         for i = 1 to w_index;
            CP_var = %trim(w_array(i));
         // exec sql                                                                      //0022
         //  declare VarDtlCr cursor for                                                  //0022
         //    select IAVDTYP, IAVLEN, IAVDEC                                             //0022
         //    from IAPGMVARS                                                             //0022
         //    where IAV_LIB   = :CP_srclib                                               //0022
         //      and IAV_SFILE = :CP_srcpf                                                //0022
         //      and IAV_MBR   = :CP_srcmbr                                               //0022
         //      and IAV_VAR   = Trim(:CP_var)                                            //0022
         //    UNION                                                                      //0022
         //    select DSOBJV, DSLENGTH, 0                                                 //0022
         //    from IAPGMDS                                                               //0022
         //    where DSSRCLIB = :CP_srclib                                                //0022
         //      and DSSRCFLN = :CP_srcpf                                                 //0022
         //      and DSPGMNM  = :CP_srcmbr                                                //0022
         //      and DSNAME   = Trim(:CP_var)                                             //0022
         //    UNION                                                                      //0022
         //    select DSFLTYP, DSFLSIZ, DSFLDEC                                           //0022
         //    from IAPGMDS                                                               //0022
         //    where DSSRCLIB = :CP_srclib                                                //0022
         //      and DSSRCFLN = :CP_srcpf                                                 //0022
         //      and DSPGMNM  = :CP_srcmbr                                                //0022
         //      and DSFLDNM  = Trim(:CP_var)                                             //0022
         //    UNION                                                                      //0022
         //    select EPRMDTYP, EPRMLEN, EPRMDPOS                                         //0022
         //    from IAENTPRM                                                              //0022
         //    where ELIBNAME  = :CP_srclib                                               //0022
         //      and ESRCPFNM  = :CP_srcpf                                                //0022
         //      and EMBRNAM   = :CP_srcmbr                                               //0022
         //      and EPRMNAM   = Trim(:CP_var)                                            //0022
         //    UNION                                                                      //0022
         //    select PPRMDTA, PPRMLEN, PPRMDEC                                           //0022
         //    from IAPRCPARM                                                             //0022
         //    where PLIBNAM = :CP_srclib                                                 //0022
         //      and PSRCPF  = :CP_srcpf                                                  //0022
         //      and PMBRNAM = :CP_srcmbr                                                 //0022
         //      and PPRMNAM = Trim(:CP_var)                                              //0022
         //    UNION                                                                      //0022
         //    select DBDATATYPE, DBFLDLEN, DBDECPOS                                      //0022
         //    from IAFILEDTL                                                             //0022
         //    where DBLIBNAME = :CP_srclib                                               //0022
         //      and DBSRCPFNM = :CP_srcpf                                                //0022
         //      and DBMBRNAM  = :CP_srcmbr                                               //0022
         //      and DBFLDNMI  = Trim(:CP_var);                                           //0022
         // exec sql open VarDtlCr;                                                       //0022

         // if SQLSTATE = SQL_ALL_OK;                                                     //0022
         //    exec sql fetch from VarDtlCr into :CP_dtype, :CP_len, :CP_dpos;            //0022
         //    if SQLSTATE = SQL_ALL_OK;                                                  //0022
         //       CP_From_Obj  = CP_CLProcnm;                                             //0022
                  CP_Called_Obj  = %Trim(CP_CLProcnm:' ');                                //0022

         //       CP_ParmNM    = %trim(w_array(i));                                       //0022
                  CP_Pos = %scan('.':CP_Var);                                             //0022
                  if CP_Pos > 0;                                                          //0022
                    CP_ParmNM  = %subst(CP_Var : CP_Pos+1 : %Len(CP_Var)-CP_Pos);         //0022
                  else;                                                                   //0022
                     CP_ParmNM    = %trim(w_array(i));                                    //0022
                  endif;                                                                  //0022
         //       CP_ParmLen   = cp_len;                                                  //0022
         //       CP_ParmDec   = cp_dpos;                                                 //0022
         //       CP_Parm_Type = cp_dtype;                                                //0022
                  CP_PlistNM   = *blanks;
                  CP_Call_Seq# = i;                                                       //0022
                  exsr CP_WrtParmDtl;
         //    endif;                                                                     //0022
         //    exec sql close VarDtlCr;                                                   //0022
         // endif;                                                                        //0022
         endfor;
      else;
         CP_pos1 = %scan(%trim(CP_CLProcnm) :cp_string);
         If CP_pos1 > 0;
            CP_pos1 = %scan('(' :cp_string: CP_POS1);
         Endif;

         if cp_pos1 > *zero;
            CP_Pos2 = CP_Pos1;
            FindCbr(CP_Pos2 :cp_string);
            if cp_pos2-cp_pos1-1 > 0;
               w_string = %subst(cp_string :cp_pos1+1 :cp_pos2-cp_pos1-1);
            endif;
            clear w_array;
            clear w_index;
            cp_pos1 = 1;
            cp_pos2 = %scan(':' :w_string :1);

            dou cp_pos2 = 0;
               w_index += 1;
               If cp_pos1 > 0 and cp_pos2 > cp_pos1
                  and w_index < %elem(w_array);
                  w_array(w_index) = %subst(w_string :cp_pos1 :cp_pos2-cp_pos1);
               Endif;
               cp_pos1 = cp_pos2+1;
               cp_pos2 = %scan(':' :w_string :cp_pos2+1);
            enddo;

            w_index += 1;
            if cp_pos1 > 0 and w_index < %elem(w_array);
               w_array(w_index) = %subst(w_string :cp_pos1);
            endif;

            for i = 1 to w_index;
               CP_var = %trim(w_array(i));
         //    exec sql                                                                   //0022
         //     declare VarDtlCr1 cursor for                                              //0022
         //       select IAVDTYP, IAVLEN, IAVDEC                                          //0022
         //       from IAPGMVARS                                                          //0022
         //       where IAV_LIB   = :CP_srclib                                            //0022
         //         and IAV_SFILE = :CP_srcpf                                             //0022
         //         and IAV_MBR   = :CP_srcmbr                                            //0022
         //         and IAV_VAR   = Trim(:CP_var)                                         //0022
         //       UNION                                                                   //0022
         //       select DSOBJV, DSLENGTH, 0                                              //0022
         //       from IAPGMDS                                                            //0022
         //       where DSSRCLIB = :CP_srclib                                             //0022
         //         and DSSRCFLN = :CP_srcpf                                              //0022
         //         and DSPGMNM  = :CP_srcmbr                                             //0022
         //         and DSNAME   = Trim(:CP_var)                                          //0022
         //       UNION                                                                   //0022
         //       select DSFLTYP, DSFLSIZ, DSFLDEC                                        //0022
         //       from IAPGMDS                                                            //0022
         //       where DSSRCLIB = :CP_srclib                                             //0022
         //         and DSSRCFLN = :CP_srcpf                                              //0022
         //         and DSPGMNM  = :CP_srcmbr                                             //0022
         //         and DSFLDNM  = Trim(:CP_var)                                          //0022
         //       UNION                                                                   //0022
         //       select EPRMDTYP, EPRMLEN, EPRMDPOS                                      //0022
         //       from IAENTPRM                                                           //0022
         //       where ELIBNAME = :CP_srclib                                             //0022
         //         and ESRCPFNM = :CP_srcpf                                              //0022
         //         and EMBRNAM  = :CP_srcmbr                                             //0022
         //         and EPRMNAM  = Trim(:CP_var)                                          //0022
         //       UNION                                                                   //0022
         //       select PPRMDTA, PPRMLEN, PPRMDEC                                        //0022
         //       from IAPRCPARM                                                          //0022
         //       where PLIBNAM = :CP_srclib                                              //0022
         //         and PSRCPF  = :CP_srcpf                                               //0022
         //         and PMBRNAM = :CP_srcmbr                                              //0022
         //         and PPRMNAM = Trim(:CP_var)                                           //0022
         //       UNION                                                                   //0022
         //       select DBDATATYPE, DBFLDLEN, DBDECPOS                                   //0022
         //       from IAFILEDTL                                                          //0022
         //       where DBLIBNAME = :CP_srclib                                            //0022
         //         and DBSRCPFNM = :CP_srcpf                                             //0022
         //         and DBMBRNAM  = :CP_srcmbr                                            //0022
         //         and DBFLDNMI  = Trim(:CP_var);                                        //0022
         //    exec sql open VarDtlCr1;                                                   //0022
         //                                                                               //0022
         //    if SQLSTATE = SQL_ALL_OK;                                                  //0022
         //       exec sql fetch from VarDtlCr1 into :CP_dtype, :CP_len, :CP_dpos;        //0022
         //       if SQLSTATE = SQL_ALL_OK;                                               //0022
         //          CP_From_Obj  = CP_CLProcnm;                                          //0022
                     CP_Called_Obj  = %Trim(CP_CLProcnm:' ');                             //0022
         //          CP_ParmNM    = %trim(w_array(i));                                    //0022

                     CP_Pos = %scan('.':CP_Var);                                          //0022
                     if CP_Pos > 0;                                                       //0022
                       CP_ParmNM  = %subst(CP_Var : CP_Pos+1 : %Len(CP_Var)-CP_Pos);      //0022
                     else;                                                                //0022
                        CP_ParmNM    = %trim(w_array(i));                                 //0022
                     endif;                                                               //0022

            //       CP_ParmLen   = cp_len;                                               //0022
            //       CP_ParmDec   = cp_dpos;                                              //0022
            //       CP_Parm_Type = cp_dtype;                                             //0022
                     CP_PlistNM   = *blanks;
                     CP_Call_Seq# = i;                                                    //0022
                     exsr CP_WrtParmDtl;
            //    endif;                                                                  //0022
            //    exec sql close VarDtlCr1;                                               //0022
            // endif;                                                                     //0022
            endfor;
         endif;
      endif;
   endsr;
end-proc;

//------------------------------------------------------------------------------------ //
//GetNumericValue:                                                                     //
//------------------------------------------------------------------------------------ //
dcl-proc GetNumericValue export;
   dcl-pi GetNumericValue packed(6);
      in_string_value varchar(6) const options(*trim);
   end-pi;

   dcl-s output_value packed(6) inz;

   if %len(in_string_value) > *zeros;
      //if %check(DIGITS1: %trim(in_string_value)) = *zeros;                             //OJ01
      if %check(DIGITS1: in_string_value) = *zeros;                                      //OJ01
         output_value = %dec(in_string_value: 6: 0);
      endif;
   endif;

   return output_value;
end-proc;

//------------------------------------------------------------------------------------ //
//IaPsrSUBR:                                                                           //
//------------------------------------------------------------------------------------ //
dcl-proc IaPsrSUBR export;
   dcl-pi IaPsrSUBR;
      in_string   char(5000);
      in_ptype    char(10);
      in_perror   char(10);
      in_xref     char(10);
   // in_srclib char(10);                                                                //0062
   // in_srcspf char(10);                                                                //0062
   // in_srcmbr char(10);                                                                //0062
      in_uWSrcDtl likeds(uWSrcDtl);                                                      //0062
      in_rrns     packed(6:0);
      in_rrne     packed(6:0);
      in_sbrnam   CHAR(20);
   end-pi;

   dcl-ds SR_DataDs1 extname('IASUBRDTL') qualified inz;
   end-ds;

   dcl-s SR_Word_Name    char(128)   inz;
   dcl-s SR_WrdObjective char(10)    inz;
   dcl-s SR_string       char(5000)  inz;
   dcl-s SR_xref         char(10)    inz;
   dcl-s SR_srclib       char(10)    inz;
   dcl-s SR_srcpf        char(10)    inz;
   dcl-s SR_srcmbr       char(10)    inz;
   dcl-s SR_IfsLoc       char(100)   inz;                                                //0062
   dcl-s SR_OBJVREF      char(10)    inz;
   dcl-s SR_Attr         char(10)    inz;
   dcl-s SR_Mody         char(10)    inz;
   dcl-s SR_STS          char(10)    inz;
   dcl-s SR_FreFixflg    char(1)     inz('N');
   dcl-s sR_sbrnam       char(20)    inz;
   dcl-s SR_Scrrn        packed(6:0) inz;
   dcl-s SR_Scrrne       packed(6:0) inz;
   dcl-s SR_Seq          packed(6:0) inz;
   dcl-s SR_Count        packed(4:0) inz;
   dcl-s SR_Pos          uns(5)      inz;
   dcl-s SR_Pos1         uns(5)      inz;
   dcl-s SR_Error        ind         inz;

   uwsrcdtl = In_uwsrcdtl;                                                               //0062
   SR_string = %xlate(LOWER: UPPER: In_string);
   SR_xref   = In_xref;
   SR_srclib = In_srclib;
   SR_srcpf  = In_srcspf;
   SR_srcmbr = In_srcmbr;
   SR_IfsLoc = In_IfsLoc;                                                                //0062
   SR_scrrn  = In_rrns;

   if In_rrne <> *zeros;
      Sr_sCRRNE= In_rrne;
   else;
      Sr_sCRRNE= In_rrns;
   endif;

   sr_sbrnam = %trim(In_sbrnam);
   SR_Error  = *off;
   Sr_DataDs1.SRDIRNAME= 'SUBROUTINE';

   //Procedure to find out where data is free or fixed
   reset SR_FreFixFlg;
   if %scan(';':SR_String) = %len(%trimr(SR_String));
      Sr_FreFixflg = 'Y';
   endif;

   //Parse any type of subroutine opcode and also check whether free or fixed
   exsr Sr_ProcessSubrStR;

   //If there is no error occured while parsing the subroutines
   if Sr_Error = *off;
      //If parsing success full write details in IASUBRDTL file
      exsr Sr_wrtSubrDtl;

      //If the record logged in IASUBRDTL file success fully
      if SR_Error = *off;
         //If all goes well return to previous pgm with 'C' = completed flag
         in_perror = 'C';
      endif;
   endif;

   return;

   begsr SR_ProcessSubrStr;
      reset SR_Pos;
      reset SR_Pos1;

      //Get the position of ';' if the frefixflg = 'Y'
      if Sr_FreFixFlg = 'Y';
         SR_Pos1 = %len(%trimr(SR_String));
      else;
         reset Sr_pos1;
      endif;

      //Get position of 'EXSR' for free format
      if Sr_FreFixFlg = 'Y';
         SR_Pos = %scan('EXSR':SR_String);
         if SR_pos > 0;
            //Process parsing for EXSR opcode
            exsr SR_ProcessExsrStr;
            leavesr;
         endif;
      else;
         //If EXSR for Fixed FOrmat get the position
         select;
         when %subst(SR_string:26:4) = 'EXSR';
            Sr_Pos = 26;
            //Process parsing for EXSR opcode
            exsr SR_ProcessExsrStr;
            leavesr;
         when %subst(Sr_string:28:4)  = 'EXSR';
            Sr_Pos = 28;
            //Process parsing for EXSR opcode
            exsr SR_ProcessExsrStr;
            leavesr;
         endsl;
      endif;

      //If BEGSR for Free FOrmat get the position
      SR_Pos = %scan('BEGSR':SR_String);
      if Sr_FreFixflg = 'Y';
         if SR_Pos>0;
            //Process parsing for BEGSR opcode
            exsr SR_ProcessBegsrStr;
            leavesr;
         endif;
      else;
         //If BEGSR for Fixed FOrmat get the position
         SR_Pos = %scan('BEGSR':SR_String);
         if Sr_Pos>0;
            //Process parsing for BEGSR opcode
            exsr SR_ProcessBegsrStr;
            leavesr;
         endif;
      endif;

      //If CASXX is at 26 or 28 position process and fixed format
      if (%subst(SR_String:26:3) = 'CAS' or
        %subst(SR_String:28:3) = 'CAS')  and Sr_FreFixflg = 'N';
         //Process parsing for CASXX
         exsr SR_ProcessCASSRstr;
         leavesr;
      endif;

      //If EndSR for Free FOrmat get the position
      SR_Pos = %scan('ENDSR':SR_String);
      if Sr_FreFixflg = 'Y';
         if SR_Pos>0;
            //Process parsing for ENDSR
            exsr SR_ProcessEndSrStr;
            leavesr;
         endif;
      else;
         //If EndSR for Free FOrmat
         if (%subst(SR_String:26:5) = 'ENDSR' Or
           %subst(SR_String:28:5) = 'ENDSR');
            //Process parsing for ENDSR
            exsr SR_ProcessEndSrStr;
            leavesr;
         endif;
      endif;
   endsr;

   begsr Sr_ProcessExsrStr;
      //If free format
      if Sr_FreFixFlg = 'Y';
         if Sr_pos1 > SR_Pos+5;
            Sr_Word_Name = %trim(%subst(SR_String:(Sr_Pos+5):((Sr_pos1)-(SR_Pos+5))));
         endif;
         if Sr_Pos > 1;
            Sr_DataDs1.SrFactor1 = %trim(%subst(Sr_String:1:(Sr_Pos-1)));
         endif;

         if Sr_DataDS1.SrFactor1 <> *blanks;
            Sr_error = *on;
            leavesr;
         endif;
         Sr_DataDs1.SrFactor2 = %trim(Sr_word_name);
      else;
         //If fixed format
         if %len(Sr_String) > (Sr_Pos+5);
            Sr_Word_Name = %trim(%subst(SR_String:(Sr_Pos+5):(%len(Sr_String)-(Sr_Pos+5))));
         endif;
         if Sr_Pos > 7;
            Sr_DataDs1.SrFactor1 = %trim(%subst(Sr_String:7:(Sr_Pos-7)));
         endif;
         Sr_DataDs1.SrFactor2 = %trim(Sr_word_name);
      endif;

      if Sr_Pos > 0;
         Sr_DataDs1.SrOpcode = %trim(%subst(Sr_String:Sr_Pos:4));
      endif;
      Sr_DataDS1.SrSbrName = %trim(Sr_word_name);
      Sr_DataDS1.SRCALLDFM = %trim(SR_sbrnam);

      //If Exsr is in between BEGSR and ENDSR
      if Sr_DataDS1.SRCALLDFM <> *blanks;
         Sr_DataDS1.SRCALLDTO = %trim(Sr_word_name);
      endif;

      //Get the sequence if record is already updated do not process further
      exec sql
        select COALESCE((PWRDSEQ),0) AS SEQ
          into :SR_SEQ
        from IAPGMREF
        where   PLIBNAM  = :SR_SRCLIB
          and   PSRCPFNM = :SR_SRCPF
          and   PMBRNAM  = :SR_SRCMBR
          and   PIFSLOC  = :SR_IFSLOC                                                    //0062
          and PSRCRRN >= :SR_SCRRN
          and PSRCRRN <= :SR_SCRRNE
          and PSRCWRD  = trim(:SR_WORD_NAME)
        fetch first 1 rows only;

      if SQLSTATE <> SQL_ALL_OK;
         //log error
      endif;

      if SR_SEQ = 0;
         //If record not updated, get the max sequence for the EXSR subroutine name
         exec sql
           select coalesce(max(PWRDSEQ),0) as SEQ
             into :SR_SEQ
           from IAPGMREF
           where   PLIBNAM  = :SR_SRCLIB
             and   PSRCPFNM = :SR_SRCPF
             and   PMBRNAM  = :SR_SRCMBR
             And   PIFSLOC  = :SR_IFSLOC                                                 //0062
             and PSRCWRD  = trim(:SR_WORD_NAME)
           fetch first row only;

         if SQLSTATE <> SQL_ALL_OK;
            //log error
         endif;
            //If Subroutine name under EXSR found first time
         if Sr_Seq = 0;
            SR_WrdObjective = 'SR-CAL';
            SR_SEQ += 1;
         else;
            //If Subroutine name under EXSR already has sequence but not found
            //in between BEGSR and ENDSR
            if Sr_sbrnam <> *blanks;
               Sr_Seq += 1;
            endif;
            SR_WrdObjective = 'SR-CAL';
         endif;
         //update the corrsponding details in IAPGMREF file in below proc               //0008
      endif;
   endsr;

   begsr Sr_ProcessBEgsrStr;
         //If Free format
      select;
      when Sr_FreFixflg = 'Y';
         if Sr_pos1 > Sr_Pos+6;
            Sr_Word_Name = %trim(%subst(SR_String:(Sr_Pos+6):((Sr_pos1)-(Sr_Pos+6))));
         endif;
         if Sr_Pos > 1;
            Sr_DataDs1.SrFactor1 = %trim(%subst(Sr_String:1:(Sr_Pos-1)));
         endif;

         if Sr_DataDS1.SrFactor1 <> *blanks;
            Sr_error = *on;
            leavesr;
         endif;
         Sr_DataDs1.SrFactor2 = %trim(Sr_word_name);
      when %subst(Sr_String:28:5) = 'BEGSR';
         //If Fixed format RPG3
         if Sr_Pos > 18;
            Sr_Word_Name = %trim(%subst(SR_String: 18 :(Sr_Pos-18)));
            Sr_DataDs1.SrFactor1 = %trim(%subst(Sr_String:18:(Sr_Pos-18)));
         endif;
         clear Sr_DataDs1.SrFactor2;
      when %subst(Sr_String:26:5) = 'BEGSR';
         //If Fixed format RPG3
         if Sr_Pos > 12;
            Sr_Word_Name = %trim(%subst(SR_String: 12 :(Sr_Pos-12)));
            Sr_DataDs1.SrFactor1 = %trim(%subst(Sr_String:12:(Sr_Pos-12)));
         endif;
         clear Sr_DataDs1.SrFactor2;
      endsl;

      if Sr_Pos > 0;
         Sr_DataDs1.SrOpcode  = %trim(%subst(Sr_String:Sr_Pos:5));
      endif;
      Sr_DataDS1.SrSbrName = %trim(Sr_word_name);

      select;
      when Sr_word_name = '*INZSR';
         SR_WrdObjective = 'INZSR';
      when Sr_word_name = '*PSSR';
         SR_WrdObjective = 'PSSR';
      other;
         SR_WrdObjective = 'SR-NAM';
      endsl;

      SR_SEQ = 0;
      //update the corrsponding details in IAPGMREF file in below proc                    //0008
   endsr;

   begsr Sr_ProcessCassrStr;
      select;
      //If CAS found at 28 position in string
      when %subst(Sr_string:28:3) = 'CAS';
         if %len(Sr_String) > 43;
            Sr_Word_Name = %trim(%subst(SR_String:(43):(%len(Sr_String)-(43))));
         endif;
         Sr_Word_Name = %trim(%subst(Sr_String:43:6));
         Sr_DataDs1.SrFactor1 = %trim(%subst(Sr_String:18:10));
         Sr_DataDs1.SrOpcode  = %trim(%Subst(Sr_string:28:5));
         Sr_DataDs1.SrFactor2 = %trim(%subst(Sr_String:33:10));

      //If CAS found at 26 position in string
      when %subst(Sr_string:26:3) = 'CAS';
         if %len(Sr_String) > 50;
            Sr_Word_Name = %trim(%subst(SR_String:(50):(%len(Sr_String)-(50))));
         endif;
         Sr_Word_Name = %trim(%subst(Sr_String:50:14));
         Sr_DataDs1.SrFactor1 = %trim(%subst(Sr_String:12:14));
         Sr_DataDs1.SrOpcode  = %trim(%subst(Sr_String:26:5));
         Sr_DataDs1.SrFactor2 = %trim(%subst(Sr_String:36:14));
      endsl;

      Sr_DataDS1.SrSbrName = %trim(Sr_word_name);
      Sr_DataDS1.SRResult  = %trim(Sr_word_name);
      Sr_DataDS1.SRCALLDFM = %trim(Sr_sbrnam);

      //If CAS found in between BEGSR and ENDSR
      if Sr_DataDS1.SRCALLDFM <> *blanks;
         Sr_DataDS1.SRCALLDTO = %trim(Sr_word_name);
      endif;

      //Get the sequence if record is already updated do not process further
      exec sql
        select coalesce(PWRDSEQ,0) AS SEQ
          into :SR_SEQ
        from IAPGMREF
        where   PLIBNAM  = :SR_SRCLIB
          and   PSRCPFNM = :SR_SRCPF
          and   PMBRNAM  = :SR_SRCMBR
          and   PIFSLOC  = :SR_IFSLOC                                                    //0062
          and PSRCRRN >= :SR_SCRRN
          and PSRCRRN <= :SR_SCRRNE
          and PSRCWRD  = trim(:SR_WORD_NAME)
        fetch first row only;

      if SQLSTATE <> SQL_ALL_OK;
         //log error
      endif;

      if SR_SEQ = 0;
         //If record not updated, get the max sequence for the EXSR subroutine name
         exec sql
           Select COALESCE(Max(PWRDSEQ),0)
             into :SR_SEQ
           from IAPGMREF
           where   PLIBNAM  = :SR_SRCLIB
             and   PSRCPFNM = :SR_SRCPF
             and   PMBRNAM  = :SR_SRCMBR
             and   PIFSLOC  = :SR_IFSLOC                                                 //0062
             and PSRCWRD  = trim(:SR_WORD_NAME)
           fetch first row only;

         if SQLSTATE <> SQL_ALL_OK;
            //log error
         endif;

         //If Subroutine name under EXSR found first time
         if Sr_Seq = 0;
            SR_WrdObjective = 'SR-CAL';
            SR_SEQ += 1;
         else;
            //If Subroutine name under EXSR already has sequence but not found
            //in between BEGSR and ENDSR
            if Sr_sbrnam <> *blanks;
               Sr_Seq += 1;
            endif;
            SR_WrdObjective = 'SR-CAL';
         endif;

         //update the corrsponding details in IAPGMREF file in below proc
      endif;
   endsr;

   begsr Sr_ProcessEndSrStr;
      //If Free format
      if Sr_FreFixFlg = 'N';
         select;
         when %Subst(Sr_string:28:5) = 'ENDSR';
            if %len(Sr_String) > 43;
               Sr_Word_Name = %trim(%subst(SR_String:(43):(%len(Sr_String)-(43))));
            endif;
            Sr_word_name = %trim(%subst(SR_String:28:5));
            Sr_DataDs1.SrFactor1 = %trim(%subst(Sr_String:18:10));
            Sr_DataDs1.SrOpcode  = %trim(%Subst(Sr_string:28:5));
            Sr_DataDs1.SrFactor2 = %trim(%subst(Sr_String:33:10));
         when %Subst(Sr_string:26:5) = 'ENDSR';
            if %len(Sr_String) > 50;
               Sr_Word_Name = %trim(%subst(SR_String:(50):(%len(Sr_String)-(50))));
            endif;
            Sr_word_name = %trim(%subst(SR_String:26:5));
            Sr_DataDs1.SrFactor1 = %trim(%subst(Sr_String:12:14));
            Sr_DataDs1.SrOpcode  = %trim(%subst(Sr_String:26:5));
            Sr_DataDs1.SrFactor2 = %trim(%subst(Sr_String:36:14));
         endsl;
      else;
         //If Free format
         if Sr_Pos1 > Sr_Pos+5;
            Sr_Word_Name = %trim(%subst(SR_String:(Sr_Pos+6):((Sr_pos1)-(SR_Pos+6))));
         endif;

         if Sr_Pos > 0 and (Sr_word_name = *blanks or Sr_Pos1 = Sr_Pos+5);
            Sr_Word_Name = %trim(%subst(SR_String:(Sr_Pos):5));
         endif;

         if Sr_Pos > 1;
            Sr_DataDs1.SrFactor1 = %trim(%subst(Sr_String:1:(Sr_Pos-1)));
         endif;
         if Sr_DataDS1.SrFactor1 <> *blanks;
            Sr_error = *on;
            leavesr;
         endif;
      endif;

      SR_WrdObjective   = 'SR-END';
      //update the corrsponding details in IAPGMREF file in below proc

      select;
      when Sr_Pos1 = Sr_Pos+5;
         clear Sr_Word_name;
      when %trim(sr_word_name) = 'ENDSR';
         clear Sr_Word_name;
      endsl;

      if Sr_Pos > 0;
         Sr_DataDs1.SrOpcode = %trim(%subst(Sr_String:(Sr_Pos):5));
      endif;
      Sr_DataDs1.SrFactor2 = %trim(Sr_word_name);
      Sr_DataDS1.SrSbrName = %trim(Sr_word_name);
      Sr_DataDS1.SrSbrName = Sr_DataDs1.SrFactor1;
   endsr;


   begsr Sr_WrtSUBRDTL;
      SR_DataDs1.SRMEMSRCPF = SR_srcpf;
      SR_DataDs1.SRMEMLIB  =  SR_srclib;
      SR_DataDs1.SRMEMNAME =  SR_srcmbr;
      SR_DataDs1.SRIFSLOC  =  SR_IfsLoc;                                                 //0062
      SR_DataDs1.SRMEMRRN  =  SR_ScRrn;
      SR_DataDs1.SRCRTJOBID = 'USER JOB';
      SR_DataDs1.SRCHGJOBID = 'USER JOB';
      SR_DataDs1.SRCOUNT = 1;

      //Get number of times the subroutine is repeated
      exsr SR_GetCount;

      if Sr_Count = *zeros;
         exec sql
           insert into IASUBRDTL (SRDIRNAME,
                                  SRMEMSRCPF,
                                  SRMEMLIB,
                                  SRMEMNAME,
                                  SRIFSLOC ,                                             //0062
                                  SRMEMRRN,
                                  SROPCODE,
                                  SRSBRNAME,
                                  SRFACTOR1,
                                  SRFACTOR2,
                                  SRRESULT,
                                  SRCALLDFM,
                                  SRCALLDTO,
                                  SRCOUNT,
                                  SRCRTJOBID,
                                  SRCRTONTS,
                                  SRCHGJOBID)
             Values(:SR_DataDs1.SRDIRNAME,
                    :SR_DataDs1.SRMEMSRCPF,
                    :SR_DataDs1.SRMEMLIB,
                    :SR_DataDs1.SRMEMNAME,
                    :SR_DataDs1.SRIFSLOC ,                                               //0062
                    :SR_DataDs1.SRMEMRRN,
                    :SR_DataDs1.SROPCODE,
                    :SR_DataDs1.SRSBRNAME,
                    :SR_DataDs1.SRFACTOR1,
                    :SR_DataDs1.SRFACTOR2,
                    :SR_DataDS1.SRRESULT,
                    :SR_DataDs1.SRCALLDFM,
                    :SR_DataDs1.SRCALLDTO,
                    :SR_DataDs1.SRCOUNT,
                    :SR_DataDs1.SRCRTJOBID,
                    :SR_DataDs1.SRCRTONTS,
                    :SR_DataDs1.SRCHGJOBID);

         if SQLSTATE <> SQL_ALL_OK;
            //log error
         endif;
      else;
         exec sql
           update IASUBRDTL
             set SRCOUNT    = SRCOUNT + 1,
                 SRMEMRRN   = :SR_DataDs1.SRMEMRRN
           where SRDIRNAME  = :SR_DataDs1.SRDIRNAME
             and   SRMEMSRCPF = :SR_DataDs1.SRMEMSRCPF
             and   SRMEMLIB   = :SR_DataDs1.SRMEMLIB
             and   SRMEMNAME  = :SR_DataDs1.SRMEMNAME
             and   SRIFSLOC   = :SR_DataDs1.SRIFSLOC                                     //0062
             and SROPCODE   = :SR_DataDs1.SROPCODE
             and SRSBRNAME  = :SR_DataDs1.SRSBRNAME
             and SRFACTOR1  = :SR_DataDs1.SRFACTOR1
             and SRFACTOR2  = :SR_DataDs1.SRFACTOR2
             and SRCALLDFM  = :SR_DataDs1.SRCALLDFM
             and SRCALLDTO  = :SR_DataDs1.SRCALLDTO;

         if SQLSTATE <> SQL_ALL_OK;
            //log error
         endif;
      endif;

      if SQLSTATE <> SQL_ALL_OK;
         SR_Error = *On;
      endif;

      clear SR_DataDS1;
   endsr;

   begsr SR_GetCount;
      SR_Count = *Zeros;

      exec sql
        select Count(1)
          into :SR_Count
        from IASUBRDTL
        where SRDIRNAME  = :SR_DataDs1.SRDIRNAME
          and   SRMEMSRCPF = :SR_DataDs1.SRMEMSRCPF
          and   SRMEMLIB   = :SR_DataDs1.SRMEMLIB
          and   SRMEMNAME  = :SR_DataDs1.SRMEMNAME
          And   SRIFSLOC   = :SR_DataDs1.SRIFSLOC                                        //0062
          and SROPCODE   = :SR_DataDs1.SROPCODE
          and SRSBRNAME  = :SR_DataDs1.SRSBRNAME
          and SRFACTOR1  = :SR_DataDs1.SRFACTOR1
          and SRFACTOR2  = :SR_DataDs1.SRFACTOR2
          and SRCALLDFM  = :SR_DataDs1.SRCALLDFM
          and SRCALLDTO  = :SR_DataDs1.SRCALLDTO;

      if SQLSTATE <> SQL_ALL_OK;
         //log error
      endif;

      if SQLSTATE = SQL_ALL_OK and SR_Count <> *zeros;
         SR_DataDS1.SRCOUNT   = Sr_Count;
      endif;

      if %trim(SR_DataDS1.SROpcode) = 'ENDSR';
         SR_count = 0;
         SR_DataDS1.SRCOUNT   = 1;
      endif;
   endsr;
end-proc;

//------------------------------------------------------------------------------------ //
//IaPsrCLSbr:                                                                          //
//------------------------------------------------------------------------------------ //
dcl-proc IaPsrCLSbr export;
   dcl-pi IaPsrCLSbr;
      in_ParmPointer pointer;
   end-pi;

   dcl-ds w_ParmDS qualified based(in_ParmPointer);
      w_String     char(5000);
      w_Error      char(10);
      w_Repository char(10);
      w_SrcLib     char(10);
      w_SrcPf      char(10);
      w_SrcMbr     char(10);
      w_IfsLoc     char(100);                                                            //0062
      w_RRNStr     packed(6:0);
      w_RRNEnd     packed(6:0);
      w_sbrnam     char(20);
   end-ds;

   dcl-ds SR_IASUBRDTL extname('IASUBRDTL') qualified inz;
   end-ds;

   dcl-s SR_Word_Name       char(128)      inz;
   dcl-s SR_WrdObjective    char(10)       inz;
   dcl-s SR_xref            char(10)       inz;
   dcl-s SR_srclib          char(10)       inz;
   dcl-s SR_srcpf           char(10)       inz;
   dcl-s SR_srcmbr          char(10)       inz;
   dcl-s SR_IfsLoc          char(100)      inz;                                          //0062
   dcl-s sr_sbrnam          char(20)       inz;
   dcl-s SR_string          char(5000)     inz;
   dcl-s SR_OBJVREF         char(10)       inz;
   dcl-s SR_Attr            char(10)       inz;
   dcl-s SR_Mody            char(10)       inz;
   dcl-s SR_STS             char(10)       inz;
   dcl-s SR_StPos           packed(6:0)    inz;
   dcl-s SR_Scrrn           packed(6:0)    inz;
   dcl-s SR_Scrrne          packed(6:0)    inz;
   dcl-s SR_Seq             packed(6:0)    inz;
   dcl-s Sr_CallSubr_Pos    packed(6:0)    inz;
   dcl-s Sr_CallSubr_length packed(6:0)    inz;
   dcl-s Sr_CallSubr_Start  packed(6:0)    inz;
   dcl-s Sr_CallSubr_End    packed(6:0)    inz;
   dcl-s SR_Count           packed(4:0)    inz;
   dcl-s SR_Error           ind            inz;

   Sr_String = w_ParmDS.w_String;
   Sr_xref   = w_ParmDS.w_Repository;
   Sr_Srclib = w_ParmDS.w_SrcLib;
   Sr_Srcpf  = w_ParmDS.w_SrcPf;
   Sr_Srcmbr = w_ParmDS.w_SrcMbr;
   SR_IfsLoc = w_ParmDS.w_IfsLoc;                                                        //0062
   SR_scrrn  = w_ParmDS.w_RRNStr;

   if w_ParmDS.w_RRNStr <> *zeros;
      SR_Scrrne = w_ParmDS.w_RRNEnd;
   else;
      Sr_sCRRNE = w_ParmDS.w_RRNStr;
   endif;

   Sr_sbrnam = w_ParmDS.w_sbrnam;
   SR_Error  = *off;

   clear SR_IASUBRDTL;
   Sr_IASUBRDTL.SRDIRNAME  = 'SUBROUTINE';
   SR_IASUBRDTL.SRMEMNAME  = w_ParmDS.w_SrcMbr;
   SR_IASUBRDTL.SRMEMSRCPF = w_ParmDS.w_SrcPf;
   SR_IASUBRDTL.SRMEMLIB   = w_ParmDS.w_SrcLib;
   SR_IASUBRDTL.SRMEMRRN   = w_ParmDS.w_RRNStr;
   SR_StPos = %scan('SUBR ':Sr_string);

   //SUBR statement parser logic
   if %scan('SUBR ':Sr_string) > 0;
      if SR_StPos <= 2;
         SR_Word_Name = ScanKeyWord(' SUBR(':Sr_String);

         If SR_Word_Name = ' ';
            SR_Word_Name = ScanKeyWord(' SUBR ':Sr_String);
         EndIf;

         Sr_IASUBRDTL.SROPCODE  = 'SUBR';
         Sr_IASUBRDTL.SRSBRNAME = SR_Word_Name;
         Sr_IASUBRDTL.SRFACTOR1 = *blanks;
         Sr_IASUBRDTL.SRFACTOR2 = *blanks;
         Sr_IASUBRDTL.SRRESULT  = ScanKeyWord(' RTNVAL(':Sr_String);
         SR_WrdObjective        = 'SR-NAM';
         SR_Seq = 0;

         //update the corrsponding details in IAPGMREF file in below proc

         //If parsing successfull, then write into IASUBRDTL file.
         exsr Sr_wrtSubrDtl;

         //If all goes well return to previous pgm with 'C' = completed flag
         if SR_Error = *off;
            W_parmDs.w_error = 'C';
         endif;
      endif;
   endif;

   //CALLSUBR statement parser logic
   if %scan('CALLSUBR ':Sr_string) > 0;
      if SR_StPos > 2;
         SR_Word_Name = ScanKeyWord(' SUBR(':Sr_String);
         if SR_Word_Name = ' ';
            Sr_CallSubr_Pos = %scan('CALLSUBR':Sr_String) ;
            sr_CallSubr_Length = Sr_CallSubr_Pos + %len('CALLSUBR');

            if sr_CallSubr_Length > 0 and %len(Sr_String) > sr_CallSubr_Length;
               dow %subst(Sr_String :sr_CallSubr_Length :1) = ' ';
                  sr_CallSubr_Length += 1;
               enddo;

               sr_CallSubr_Start = sr_CallSubr_Length;
               if sr_CallSubr_Start > 0;
                  sr_CallSubr_End = %scan(' ' :sr_string :sr_CallSubr_Start);
                  if sr_CallSubr_End-sr_CallSubr_Start+1 > 0;
                     SR_Word_Name = %subst(sr_string :sr_CallSubr_Start
                                        :sr_CallSubr_End-sr_CallSubr_Start+1);
                  endif;
               endif;
            endif;
         endif;

         Sr_IASUBRDTL.SROPCODE  = 'CALLSUBR';
         Sr_IASUBRDTL.SRSBRNAME = SR_Word_Name;
         Sr_IASUBRDTL.SRFACTOR1 = *blanks;
         Sr_IASUBRDTL.SRFACTOR2 = *blanks;
         Sr_IASUBRDTL.SRRESULT  = ScanKeyWord(' RTNVAL(':Sr_String);
         SR_WrdObjective        = 'SR-CALL';
         Sr_IASUBRDTL.SRCALLDFM = %trim(Sr_sbrnam);

         if Sr_IASUBRDTL.SRCALLDFM <> *blanks;
            Sr_IASUBRDTL.SRCALLDTO = %trim(Sr_word_name);
         endif;

         //Get the sequence if record is already updated do not process further
         exec sql
           select COALESCE((PWRDSEQ),0) AS SEQ
             into :SR_SEQ
           from IACPGMREF
           where   PLIBNAM   = :SR_SRCLIB
             and   PSRCPFNM  = :SR_SRCPF
             and   PMBRNAM   = :SR_SRCMBR
             and   PIFSLOC   = :SR_IFSLOC                                                //0062
             and (PSRCRRN >= :SR_SCRRN and PSRCRRN <= :SR_SCRRNE)
             and PSRCWRD   = trim(:SR_WORD_NAME)
           fetch first row only;

         if SQLSTATE <> SQL_ALL_OK;
            //log error
         endif;

         if SR_SEQ = 0;
            //If record not updated, get the max seq for the CALLSUBR name
            exec sql
              select COALESCE(Max(PWRDSEQ),0)
                into :SR_SEQ
              from IACPGMREF
              where   PLIBNAM   = :SR_SRCLIB
                and   PSRCPFNM  = :SR_SRCPF
                and   PMBRNAM   = :SR_SRCMBR
                and   PIFSLOC   = :SR_IFSLOC                                             //0062
                and PSRCWRD = trim(:SR_WORD_NAME)
              fetch first row only;

            if SQLSTATE <> SQL_ALL_OK;
               //log error
            endif;

            //If Subroutine name under EXSR found first time
            if Sr_Seq = 0;
               Sr_Seq += 1;
            else;
               //If Subroutine name under EXSR already has sequence but not found
               //in between BEGSR and ENDSR
               if Sr_sbrnam <> *blanks;
                  Sr_Seq += 1;
               endif;
            endif;
         endif;

         //update the corrsponding details in IAPGMREF file in below proc

         //If parsing successfull, then write into IASUBRDTL file.
         exsr Sr_wrtSubrDtl;

         //If all goes well return to previous pgm with 'C' = completed flag
         if SR_Error = *off;
            W_parmDs.w_error = 'C';
         endif;
      endif;
   endif;

   //RTNSUBR statement parser logic
   if %scan('RTNSUBR ':Sr_string) > 0;
      if SR_StPos > 2;
         SR_Word_Name = ScanKeyWord(' SUBR(':Sr_String);
         Sr_IASUBRDTL.SROPCODE  = 'RTNSUBR';
         Sr_IASUBRDTL.SRSBRNAME = SR_Word_Name;
         Sr_IASUBRDTL.SRFACTOR1 = *blanks;
         Sr_IASUBRDTL.SRFACTOR2 = *blanks;
         Sr_IASUBRDTL.SRRESULT  = ScanKeyWord(' RTNVAL(':Sr_String);
         SR_WrdObjective        = 'SR-RTNVAL';
         SR_Seq = 0;

         //pass result value for ENDSUBR & RTNSUBR ...
         SR_Word_Name = Sr_IASUBRDTL.SRRESULT;

         //update the corrsponding details in IAPGMREF file in below proc

         //Clear the value after writing into IACPGMREF file..
         SR_Word_Name = ' ';

         //If parsing successfull, then write into IASUBRDTL file.
         exsr Sr_wrtSubrDtl;

         //If all goes well return to previous pgm with 'C' = completed flag
         if SR_Error = *off;
            W_parmDs.w_error = 'C';
         endif;
      endif;
   endif;

   //ENDSUBR statement parser logic
   if %scan('ENDSUBR ':Sr_string) > 0;
      if SR_StPos > 2;
         SR_Word_Name = ScanKeyWord(' SUBR(':Sr_String);
         Sr_IASUBRDTL.SROPCODE  = 'ENDSUBR';
         Sr_IASUBRDTL.SRSBRNAME = SR_Word_Name;
         Sr_IASUBRDTL.SRFACTOR1 = *blanks;
         Sr_IASUBRDTL.SRFACTOR2 = *blanks;
         Sr_IASUBRDTL.SRRESULT  = ScanKeyWord(' RTNVAL(':Sr_String);
         SR_WrdObjective        = 'SR-END';
         SR_Seq = 0;

         //pass result value for ENDSUBR & RTNSUBR ...
         SR_Word_Name = Sr_IASUBRDTL.SRRESULT;

         //update the corrsponding details in IAPGMREF file in below proc

         //Clear the value after writing into IACPGMREF file..
         SR_Word_Name = ' ';

         //If parsing successfull, then write into IASUBRDTL file.
         exsr Sr_wrtSubrDtl;

         //If all goes well return to previous pgm with 'C' = completed flag
         if SR_Error = *off;
            W_parmDs.w_error = 'C';
         endif;
      endif;
   endif;

   return;


   begsr Sr_WrtSUBRDTL;
      SR_IASUBRDTL.SRMEMSRCPF = Sr_srcpf;
      SR_IASUBRDTL.SRMEMLIB   = Sr_srclib;
      SR_IASUBRDTL.SRMEMNAME  = Sr_srcmbr;
      SR_IASUBRDTL.SRIFSLOC   = SR_IfsLoc;                                               //0062
      SR_IASUBRDTL.SRMEMRRN   = Sr_ScRrn;
      SR_IASUBRDTL.SRCRTJOBID = 'USER JOB';
      SR_IASUBRDTL.SRCHGJOBID = 'USER JOB';
      SR_IASUBRDTL.SRCOUNT    = 1;

      exsr SR_GetCount;

      if Sr_Count = *zeros;
         exec sql
           Insert into IASUBRDTL (SRDIRNAME ,
                                  SRMEMSRCPF,
                                  SRMEMLIB  ,
                                  SRMEMNAME ,
                                  SRIFSLOC  ,                                            //0062
                                  SRMEMRRN  ,
                                  SROPCODE  ,
                                  SRSBRNAME ,
                                  SRFACTOR1 ,
                                  SRFACTOR2 ,
                                  SRRESULT  ,
                                  SRCALLDFM ,
                                  SRCALLDTO ,
                                  SRCOUNT   ,
                                  SRCRTJOBID,
                                  SRCRTONTS ,
                                  SRCHGJOBID)
             values(:SR_IASUBRDTL.SRDIRNAME ,
                    :SR_IASUBRDTL.SRMEMSRCPF,
                    :SR_IASUBRDTL.SRMEMLIB  ,
                    :SR_IASUBRDTL.SRMEMNAME ,
                    :SR_IASUBRDTL.SRIFSLOC  ,                                            //0062
                    :SR_IASUBRDTL.SRMEMRRN  ,
                    :SR_IASUBRDTL.SROPCODE  ,
                    :SR_IASUBRDTL.SRSBRNAME ,
                    :SR_IASUBRDTL.SRFACTOR1 ,
                    :SR_IASUBRDTL.SRFACTOR2 ,
                    :SR_IASUBRDTL.SRRESULT  ,
                    :SR_IASUBRDTL.SRCALLDFM ,
                    :SR_IASUBRDTL.SRCALLDTO ,
                    :SR_IASUBRDTL.SRCOUNT   ,
                    :SR_IASUBRDTL.SRCRTJOBID,
                    :SR_IASUBRDTL.SRCRTONTS ,
                    :SR_IASUBRDTL.SRCHGJOBID);

         if SQLSTATE <> SQL_ALL_OK;
            //log error
         endif;
      else;
         exec sql
           update IASUBRDTL
             set SRCOUNT = SRCOUNT + 1,
                 SRMEMRRN   = :SR_IASUBRDTL.SRMEMRRN
           where SRDIRNAME  = :SR_IASUBRDTL.SRDIRNAME
             and   SRMEMSRCPF = :SR_IASUBRDTL.SRMEMSRCPF
             and   SRMEMLIB   = :SR_IASUBRDTL.SRMEMLIB
             and   SRMEMNAME  = :SR_IASUBRDTL.SRMEMNAME
             and   SRIFSLOC   = :SR_IASUBRDTL.SRIFSLOC                                   //0062
             and SROPCODE   = :SR_IASUBRDTL.SROPCODE
             and SRSBRNAME  = :SR_IASUBRDTL.SRSBRNAME
             and SRFACTOR1  = :SR_IASUBRDTL.SRFACTOR1
             and SRFACTOR2  = :SR_IASUBRDTL.SRFACTOR2
             and SRCALLDFM  = :SR_IASUBRDTL.SRCALLDFM
             and SRCALLDTO  = :SR_IASUBRDTL.SRCALLDTO;

          if SQLSTATE <> SQL_ALL_OK;
            //log error
         endif;
      endif;

      if SQLSTATE <> SQL_ALL_OK;
         SR_Error = *on;
      endif;

      clear SR_IASUBRDTL;
   endsr;

   begsr SR_GetCount;
      SR_Count = *zeros;

      exec sql
        select count(1)
          into :SR_Count
        from IASUBRDTL
        where SRDIRNAME  = :SR_IASUBRDTL.SRDIRNAME
          and   SRMEMSRCPF = :SR_IASUBRDTL.SRMEMSRCPF
          and   SRMEMLIB   = :SR_IASUBRDTL.SRMEMLIB
          and   SRMEMNAME  = :SR_IASUBRDTL.SRMEMNAME
          and   SRIFSLOC   = :SR_IASUBRDTL.SRIFSLOC                                      //0062
          and SROPCODE   = :SR_IASUBRDTL.SROPCODE
          and SRSBRNAME  = :SR_IASUBRDTL.SRSBRNAME
          and SRFACTOR1  = :SR_IASUBRDTL.SRFACTOR1
          and SRFACTOR2  = :SR_IASUBRDTL.SRFACTOR2
          and SRCALLDFM  = :SR_IASUBRDTL.SRCALLDFM
          and SRCALLDTO  = :SR_IASUBRDTL.SRCALLDTO;

      if SQLSTATE <> SQL_ALL_OK;
         //log error
      endif;

      if SQLSTATE = SQL_ALL_OK and SR_Count <> *zeros;
         SR_IASUBRDTL.SRCOUNT   = Sr_Count;
      endif;

      if %trim(SR_IASUBRDTL.SROpcode) = 'ENDSUBR' or
        %trim(SR_IASUBRDTL.SROpcode) = 'RTNSUBR';
         SR_count = 0;
         SR_IASUBRDTL.SRCOUNT = 1;
      endif;
   endsr;
end-proc;

//------------------------------------------------------------------------------------ //
//IaPsrCLchg:                                                                          //
//------------------------------------------------------------------------------------ //
dcl-proc IaPsrCLchg export;
   dcl-pi IaPsrCLchg;
      in_ParmPointer pointer;
   end-pi;

   dcl-ds Ch_IAVARRELDS extname('IAVARREL') prefix(Ch_) inz;
   end-ds;

   dcl-s Ch_Word_Val  char(5000)  inz;
   dcl-s Ch_Word_Res  char(5000)  inz;
   dcl-s w_WordsArray char(120)   inz dim(999);
   dcl-s Ch_Str_name  char(128)   inz;
   dcl-s Ch_Opcode    char(20)    inz;
   dcl-s w_BIF        char(50)    inz;
   dcl-s w_BIFstr     char(50)    inz;
   dcl-s w_BIFf1      char(50)    inz;
   dcl-s w_BIFf2      char(50)    inz;
   dcl-s in_string    char(5000)  inz;
   dcl-s in_stringSv  char(5000)  inz;
   dcl-s in_xref      char(10)    inz;
   dcl-s in_srclib    char(10)    inz;
   dcl-s in_srcpf     char(10)    inz;
   dcl-s in_srcmbr    char(10)    inz;
   dcl-s in_IfsLoc    char(100)   inz;                                                   //0062
   dcl-s in_sbrnam    char(20)    inz;
   dcl-s W_cnt        packed(6:0) inz;
   dcl-s w_Index      packed(6:0) inz;
   dcl-s w_CATPos     packed(6:0) inz;
   dcl-s w_CATPtem    packed(6:0) inz;
   dcl-s Str_frm_pos  packed(6:0) inz;
   dcl-s Prv_frm_pos  packed(6:0) inz;
   dcl-s W_CATADD     packed(6:0) inz;
   dcl-s w_VARpos     packed(6:0) inz;
   dcl-s w_VARposSv   packed(6:0) inz;
   dcl-s w_CATCtem    packed(6:0) inz;
   dcl-s w_CATBtem    packed(6:0) inz;
   dcl-s w_CATTtem    packed(6:0) inz;
   dcl-s w_CATAtem    packed(6:0) inz;
   dcl-s w_CATMtem    packed(6:0) inz;
   dcl-s w_Blnk_Pos   packed(6:0) inz;
   dcl-s W_VALPOS     packed(6:0) inz;
   dcl-s in_Scrrn     packed(6:0) inz;
   dcl-s in_Scrrne    packed(6:0) inz;
   dcl-s in_Error     ind         inz;
   dcl-s DELIMITER    char(1)     inz(',');                                                  //vm06
   dcl-s Count    packed(4:0) inz;                                                           //vm06
   dcl-s q_array      packed(4:0) inz dim(999);
   dcl-s skip_val     char(1)     inz('N');
   dcl-s Count1   packed(4:0) inz;
   dcl-s ind      packed(4:0) inz;
   dcl-s qind     packed(4:0) inz;
   dcl-s splkwd_pos  packed(4:0) inz;
   dcl-s opcode_pos  packed(4:0) inz;
   dcl-s next_rd  packed(4:0) inz;

   dcl-c Ch_Quote     '''';
   dcl-c Ch_Quote1    '"';

   dcl-ds w_ParmDS qualified based(in_ParmPointer);
      w_String     char(5000);
      w_Error      char(10);
      w_Repository char(10);
      w_SrcLib     char(10);
      w_SrcPf      char(10);
      w_SrcMbr     char(10);
      w_IfsLoc     char(100);                                                            //0062
      w_RRNStr     packed(6:0);
      w_RRNEnd     packed(6:0);
      w_sbrnam     char(20);
   end-ds;

   in_String = w_ParmDS.w_String;
   in_xref   = w_ParmDS.w_Repository;
   in_Srclib = w_ParmDS.w_SrcLib;
   in_Srcpf  = w_ParmDS.w_SrcPf;
   in_Srcmbr = w_ParmDS.w_SrcMbr;
   in_IfsLoc = w_ParmDS.w_IfsLoc;                                                        //0062
   in_scrrn  = w_ParmDS.w_RRNStr;

   if w_ParmDS.w_RRNStr <> *zeros;
      in_Scrrne = w_ParmDS.w_RRNEnd;
   else;
      in_sCRRNE = w_ParmDS.w_RRNStr;
   endif;

   in_sbrnam = w_ParmDS.w_sbrnam;
   in_Error  = *off;
   clear Ch_IAVARRELDS;
   Ch_Opcode = 'CHGVAR';
   Ch_RESEQ  = 1;

   exec sql
     values Upper(:in_String) inTo :in_String;

   in_String   = %trim(in_String);
   In_StringSv = in_String ;

   exec sql
        set :In_String = Replace(:In_String, 'CHGVAR', '');

   In_String = %trim(In_String);

   select;
   //When VAR is present, then VALUE is mandatory
   when %scan('VAR(' :in_String:1) > 0;
      //Compute Ch_Word_Res..
      w_VARpos   = %scan('VAR(' :in_String:1) + 3;
      w_VARposSv = w_VARpos;
      FindCbr(w_VARpos:in_String);
      if w_VARpos > w_VARposSv + 1;
         Ch_Word_Res = %subst(in_String:w_VARposSv+1:w_VARpos-w_VARposSv-1);
      endif;
      Ch_Word_Res = RmvBrackets(Ch_Word_Res);

      //Compute Ch_Word_Val..
      w_VARpos   = %scan('VALUE(' :in_String:1) + 5;
      w_VARposSv = w_VARpos;
      FindCbr(w_VARpos:in_String);
      if w_VARpos > w_VARposSv + 1;
         Ch_Word_Val = %subst(in_String:w_VARposSv+1:w_VARpos-w_VARposSv-1);
      endif;
      Ch_Word_Val = RmvBrackets(Ch_Word_Val);

   //VAR is not present and VALUE is present
   when %scan('VAR(' :in_String:1) = 0 and %scan('VALUE(' :in_String:1) > 0;
      select;
      when %scan('(' :in_String:1) = 1;
         //Find its closing bracket
         //Compute Ch_Word_Res
         w_VARpos = 1;
         FindCbr(w_VARpos:in_String);
         if w_VARpos > 2;
            Ch_Word_Res  = %subst(in_String: 2 : w_VARpos-2);
            Ch_Word_Res = RmvBrackets(Ch_Word_Res);
         endif;
      when %scan('%' :in_String:1) = 1;
         //Call respective proc for BIF
         //Compute Ch_Word_Res
         w_VALpos = %scan('VALUE(' :in_String:1);
         if w_VALpos > 1;
            Ch_Word_Res  = %subst(in_String: 1 :w_VALpos-1);
         endif;
      when %scan('&' :in_String:1) = 1;
         //directly move the variable into result field
         //Compute Ch_Word_Res
         w_VALpos = %scan('VALUE(' :in_String:1);
         if w_VALpos > 1;
            Ch_Word_Res  = %subst(in_String: 1 :w_VALpos-1);
         endif;
      endsl;

      //Compute Ch_Word_Val
      w_VARpos   = %scan('VALUE(' :in_String:1) + 5;
      w_VARposSv = w_VARpos;
      FindCbr(w_VARpos:in_String);
      if w_VARpos > w_VARposSv + 1;
         Ch_Word_Val = %subst(in_String:w_VARposSv+1:w_VARpos-w_VARposSv-1);
         Ch_Word_Val = RmvBrackets(Ch_Word_Val);
      endif;

   //Both VAR & VALUE are not there
   when %scan('VAR(' :in_String:1) = 0 and %scan('VALUE(' :in_String:1) = 0;
      //Compute Ch_Word_Res
      select;
      when %scan('(' :in_String:1) = 1;
         //Find its closing bracket
         //store the ending position
         //Compute Ch_Word_Res
         w_VARpos = 1;
         FindCbr(w_VARpos:in_String);
         if w_VARpos > 2;
            Ch_Word_Res = %subst(in_String: 2 :w_VARpos -2);
            Ch_Word_Res = RmvBrackets(Ch_Word_Res);
         endif;

        //Compute Ch_Word_Val..
         Ch_Word_Val = %subst(in_String:w_VARpos+1);
         Ch_Word_Val = RmvBrackets(Ch_Word_Val);
      when %scan('%' :in_String:1) = 1;
         //Call respective proc for BIF..
         //store the ending position.
         //Compute Ch_Word_Res
         w_VARpos = %scan('(' :in_String:1) + 1;
         FindCbr(w_VARpos:in_String);
         Ch_Word_Res  = %subst(in_String: 1 :w_VARpos);

         //Compute Ch_Word_Val
         Ch_Word_Val  = %subst(in_String:w_VARpos+1);
         Ch_Word_Val = RmvBrackets(Ch_Word_Val);
      when %scan('&' :in_String:1) = 1;
         //directly move the variable into result field.
         //store the ending position
         //Compute Ch_Word_Res
         w_VARpos = 1;
         w_blnk_pos = %scan(' ' :in_String:2);
         if w_blnk_pos > 0;
           Ch_Word_Res  = %subst(in_String: 1 :w_blnk_pos);
         endif;

         //Compute Ch_Word_Val
         Ch_Word_Val  = %subst(in_String:w_blnk_pos +1 );
         Ch_Word_Val = RmvBrackets(Ch_Word_Val);
      endsl;
   endsl;

   //Process BIF in Ch_Word_Res
   if %scan('%' :Ch_Word_Res: 1) > 0;
      Ch_Str_name = Ch_Word_Res;
      CallCLbif(Ch_Str_name:w_BIF:w_BIFstr:w_BIFf1:w_BIFf2);
      Ch_Word_Res = w_BIFstr;
      ch_REBIF = w_BIF;
   endif;

   //Split the value field into Array of words based on *CAT ect.
   exsr $SplitValue;

   //Read the Array of words..and process them
   exsr $Process;

   *inlr = *on;
   return;

   //Subroutines
   begsr $Process;
      clear Ch_Str_name;
      w_cnt = 1;
      dow w_cnt <= w_Index;
         Ch_Str_name = w_WordsArray(W_Cnt);
         clear w_BIF;
         clear w_BIFstr;
         clear w_BIFf1;
         clear w_BIFf2;
         clear ch_REBIF;
         select;
         when %scan( '%' : Ch_Str_name) > 0;
            //populate REBIF field with the BIF name
            CallCLbif(Ch_Str_name:w_BIF:w_BIFstr:w_BIFf1:w_BIFf2);
            Ch_Str_name = w_BIFstr;
            ch_REBIF = w_BIF;
            Ch_REFACT2 = w_BIFf1 ;
         when %scan( Ch_Quote :Ch_Str_name ) > 0;
            Ch_Str_name =  'Const(' + %trim(Ch_Str_name) + ')';
         when %scan( Ch_Quote1:Ch_Str_name) > 0;
            Ch_Str_name =  'Const(' + %trim(Ch_Str_name) + ')';
         when %check('0123456789.':%trim(Ch_Str_name)) = 0;                                 //vm06
            Ch_Str_name =  'Const(' + %trim(Ch_Str_name) + ')';
         endsl;

         //Write into IAVARREL file
         if w_cnt = w_Index;
            Ch_RECONTIN = ' ';
         else;
            Ch_RECONTIN = 'AND';
         endif;
         Ch_Word_Val = %trim(Ch_Str_name);
         exsr Ch_wrtIAVARLOG;
         Ch_RESEQ = Ch_RESEQ + 1;
         w_cnt = w_cnt + 1;
         if w_cnt > 1;
            Ch_Opcode   = ' ';
            Ch_Word_Res = ' ';
         endif;
      enddo;
   endsr;

   begsr $SplitValue;
      clear w_WordsArray;
      clear w_Index;
      clear w_CATPos;
      clear w_CATPtem;
      clear w_CATCtem;
      clear w_CATBtem;
      clear w_CATTtem;
      clear w_CATPtem;
      clear w_CATAtem;
      clear w_CATMtem;
     //Array to hold double quotation start(odd index) and end(even index)
      clear q_array;

     //Logic to populate double quotation start(odd index) and end(even index)
      qind = 0;
      ind = 0;
      for ind = 1 to %len(%trimr(Ch_Word_Val));
         splkwd_pos = %Scan('"':Ch_Word_Val:ind);
         if splkwd_pos > 0 and splkwd_pos < 99
            and qind < %elem(q_array);
            qind+=1;
            q_array(qind) = splkwd_pos;
            ind = splkwd_pos+1;
         else;
            leave;
         endif;
      endfor;

     //Logic to replace clopcodearr elements in Ch_Word_Val with "," and
     //skip clspclkeywd and literals in Ch_Word_Val
      clear count ;                                                                         //vm06
       For Count = 1 to %Elem(clopcodearr);                                                 //vm06
           opcode_pos = %Scan(%trimr(clopcodearr(count)): Ch_Word_Val);
           Dow opcode_pos >  0;
             //skip for clopcodearr if present in between quotes
             skip_val = 'N';
             for ind = 1 by 2 to qind;
                 if q_array(ind) < opcode_pos and
                    q_array(ind+1) > opcode_pos;
                    skip_val = 'Y';
                    next_rd = q_array(ind+1) + 1;
                    leave;
                 endif;
             endfor;
             if skip_val = 'N';
             //skip for clspclkeywd present in Ch_Word_Val
                for Count1= 1 to %Elem(clspclkeywd);
                    splkwd_pos = %Scan(%trimr(clspclkeywd(count1)):
                                 Ch_Word_Val:opcode_pos);
                    if splkwd_pos > 0 and splkwd_pos = opcode_pos;
                       skip_val = 'Y';
                       next_rd = opcode_pos +
                                  %len(%trimr(clspclkeywd(Count1)))- 1;
                       leave;
                    endif;
                endfor;
             endif;
             if skip_val = 'N';
                Ch_Word_Val  = %Replace(',' :Ch_Word_Val:opcode_pos:
                       %len(%trimr(clopcodearr(Count))));
             //Since we are replacing so positions of quotes will also change in Ch_Word_Val
                for ind = 1 to qind;
                 //we are adjusting changed position in q_array
                    if opcode_pos < q_array(ind);
                       q_array(ind) = q_array(ind) -
                                       %len(%trimr(clopcodearr(Count)))+ 1;
                    endif;
                endfor;
                opcode_pos = %Scan(%trimr(clopcodearr(count)):
                                 Ch_Word_Val);
             else;
                opcode_pos = %Scan(%trimr(clopcodearr(count)):
                                 Ch_Word_Val:next_rd);
             endif;
          Enddo ;                                                                           //vm06
       Endfor;                                                                              //vm06

      w_WordsArray = GetDelimiterValue(Ch_Word_Val: Delimiter) ;                            //vm06
                                                                                            //vm06
       For Count = 1 to %Elem(w_WordsArray) ;                                               //vm06
         If w_WordsArray(count) = *blanks ;                                                 //vm06
             Leave ;                                                                        //vm06
          Else ;                                                                            //vm06
            w_Index  =  count ;                                                             //vm06
         Endif ;                                                                            //vm06
        Endfor;                                                                             //vm06

   endsr;

   begsr Ch_wrtIAVARLOG;
      Ch_RESRCLIB = in_Srclib;
      Ch_RESRCFLN = in_Srcpf;
      Ch_REPGMNM  = in_Srcmbr;
      Ch_REIFSLOC = in_IfsLoc;                                                           //0062
      Ch_RERRN    = in_scrrn;
      Ch_REOPC    = Ch_Opcode;
      Ch_RERESULT = Ch_Word_Res;
      Ch_REFACT1  = Ch_Word_Val;

    //IaVarRelLog(Ch_RESRCLIB : Ch_RESRCFLN: Ch_REPGMNM : Ch_RESEQ  : Ch_RERRN   :       //0062
      IaVarRelLog(Ch_RESRCLIB : Ch_RESRCFLN: Ch_REPGMNM : Ch_REIFSLOC: Ch_RESEQ  :       //0062
                  Ch_RERRN    :                                                          //0062
                  Ch_REROUTINE: Ch_RERELTYP: Ch_RERELNUM: Ch_REOPC  : Ch_RERESULT:
                  Ch_REBIF    : Ch_REFACT1 : Ch_RECOMP  : Ch_REFACT2: Ch_RECONTIN:
                  Ch_RERESIND : Ch_RECAT1  : Ch_RECAT2  : Ch_RECAT3 : Ch_RECAT4  :
                  Ch_RECAT5   : Ch_RECAT6  : Ch_REUTIL  : Ch_RENUM1 : Ch_RENUM2  :
                  Ch_RENUM3   : Ch_RENUM4  : Ch_RENUM5  : Ch_RENUM6 : Ch_RENUM7  :
                  Ch_RENUM8   : Ch_RENUM9  : Ch_REEXC   : Ch_REINC);
   endsr;
end-proc;

//------------------------------------------------------------------------------------ //
//CallCLbif:                                                                           //
//------------------------------------------------------------------------------------ //
dcl-proc CallCLbif export;
   dcl-pi CallCLbif;
      c_str_Name char(128);
      c_BIF      char(50);
      c_BIFstr   char(50);
      c_BIFf1    char(50);
      c_BIFf2    char(50);
   end-pi;

   dcl-s C_st_pos      packed(6:0) inz;
   dcl-s C_st_pos_blnk packed(6:0) inz;
   dcl-s C_st_pos_end  packed(6:0) inz;

   If C_Str_name = *Blanks;                                                             //VP01
      Return;                                                                           //VP01
   EndIf;                                                                               //VP01

   select;
   when %scan('%ADDRESS(' : %trim(C_Str_name):1) > 0     or
        %scan('%ADDRESS ' : %trim(C_Str_name):1) > 0     or
        %scan('%ADDR('    : %trim(C_Str_name):1) > 0     or
        %scan('%ADDR '    : %trim(C_Str_name):1) > 0;

      C_st_pos      = %scan('%ADDRESS(' : %trim(C_Str_name):1);
      if C_st_pos > 0 and %len(%trim(C_Str_name)) >= 10;
         c_BIF = '%ADDRESS';
         C_st_pos_blnk = %scan(' ' : %trim(C_Str_name):10);

         if C_st_pos_blnk = 0;
            C_st_pos_blnk = %scan(')' : %trim(C_Str_name):10);
         endif;

         if C_st_pos_blnk > 10;
            c_BIFstr = %subst( %trim(C_Str_name):10:C_st_pos_blnk - 10);
         endif;

         return;
      endif;

      C_st_pos      = %scan('%ADDR(' : %trim(C_Str_name):1);
      if C_st_pos > 0 and %len(%trim(C_Str_name)) >= 7;
         c_BIF = '%ADDR';
         C_st_pos_blnk = %scan(' ' : %trim(C_Str_name):7);

         if C_st_pos_blnk = 0;
            C_st_pos_blnk = %scan(')' : %trim(C_Str_name):7);
         endif;

         if C_st_pos_blnk > 7;
            c_BIFstr = %subst( %trim(C_Str_name):7:C_st_pos_blnk - 7);
         endif;
         return;
      endif;

   //If %BINARY or %BIN - BIF found
   when %scan('%BINARY(' : %trim(C_Str_name):1) > 0
        or %scan('%BIN('    : %trim(C_Str_name):1) > 0;
      C_st_pos = %scan('%BINARY(' : %trim(C_Str_name):1);
      if C_st_pos > 0 and %len(%trim(C_Str_name)) >= 9;
         c_BIF = '%BINARY';
         C_st_pos_blnk = %scan(' ' : %trim(C_Str_name):9);

         if C_st_pos_blnk = 0;
            C_st_pos_blnk = %scan(')' : %trim(C_Str_name):9);
         endif;

         if C_st_pos_blnk > 9;
            c_BIFstr = %subst( %trim(C_Str_name):9:C_st_pos_blnk - 9);
         endif;
         return;
      endif;

      C_st_pos      = %scan('%BIN(' : %trim(C_Str_name):1);
      if C_st_pos > 0 and %len(%trim(C_Str_name)) >= 6;
         c_BIF = '%BIN';
         C_st_pos_blnk = %scan(' ' : %trim(C_Str_name):6);

         if C_st_pos_blnk = 0;
            C_st_pos_blnk = %scan(')' : %trim(C_Str_name):6);
         endif;

         if C_st_pos_blnk > 6;
            c_BIFstr = %subst( %trim(C_Str_name):6:C_st_pos_blnk - 6);
         endif;
         return;
      endif;

   //If %CHAR - BIF found
   when %scan('%CHAR(' : %trim(C_Str_name):1) > 0;
      C_st_pos = %scan('%CHAR(' : %trim(C_Str_name):1);
      if C_st_pos > 0;
         c_BIF = '%CHAR';
         C_st_pos_blnk = %scan(' ' : %trim(C_Str_name):7);

         if C_st_pos_blnk = 0;
            C_st_pos_blnk = %scan(')' : %trim(C_Str_name):7);
         endif;

         if C_st_pos_blnk > 7;
            c_BIFstr = %subst( %trim(C_Str_name):7:C_st_pos_blnk - 7);
         endif;
         return;
      endif;

   //if %CHECK - BIF found
   when %scan('%CHECK(' : %trim(C_Str_name)) > 0;
      C_st_pos = %scan('%CHECK(' : %trim(C_Str_name));
      if C_st_pos > 0;
         c_BIF = '%CHECK';
         C_st_pos_blnk = %scan(' ' : %trim(C_Str_name):8);

         if C_st_pos_blnk = 0;
            C_st_pos_blnk = %scan(')' : %trim(C_Str_name):8);
         endif;

         if C_st_pos_blnk > 8;
            c_BIFstr = %subst( %trim(C_Str_name):8:C_st_pos_blnk - 8);
         endif;
         //Second parameter
         C_st_pos_end = %scan(')' : %trim(C_Str_name) :C_st_pos_blnk + 1);

         if C_st_pos_end > 0 and (C_st_pos_end - 1) > C_st_pos_blnk;
            c_BIFf1 = %subst( %trim(C_Str_name):C_st_pos_blnk + 1
                                   :(C_st_pos_end - 1) - C_st_pos_blnk );
         endif;
         return;
      endif;

   //if %CHECKR - BIF found
   when %scan('%CHECKR(' : %trim(C_Str_name)) > 0;
      C_st_pos = %scan('%CHECKR(' : %trim(C_Str_name));
      if C_st_pos > 0;
         c_BIF = '%CHECKR';
         C_st_pos_blnk = %scan(' ' : %trim(C_Str_name):9);

         if C_st_pos_blnk = 0;
            C_st_pos_blnk = %scan(')' : %trim(C_Str_name):9);
         endif;

         if C_st_pos_blnk > 9;
            c_BIFstr = %subst( %trim(C_Str_name):9:C_st_pos_blnk - 9);
         endif;
         //Second parameter
         C_st_pos_end = %scan(')' : %trim(C_Str_name) :C_st_pos_blnk + 1);

         if C_st_pos_end > 0 and (C_st_pos_end - 1) > C_st_pos_blnk;
            c_BIFf1 = %subst( %trim(C_Str_name):C_st_pos_blnk + 1
                            :(C_st_pos_end - 1) - C_st_pos_blnk );
         endif;

         return;
      endif;

   //if %DEC - BIF found
   when %scan('%DEC(' : %trim(C_Str_name):1) > 0;
      C_st_pos = %scan('%DEC(' : %trim(C_Str_name):1);
      if C_st_pos > 0;
         c_BIF = '%DEC';
         C_st_pos_blnk = %scan(' ' : %trim(C_Str_name):6);

         if C_st_pos_blnk = 0;
            C_st_pos_blnk = %scan(')' : %trim(C_Str_name):6);
         endif;

         if C_st_pos_blnk > 6;
            c_BIFstr = %subst( %trim(C_Str_name):6:C_st_pos_blnk - 6);
         endif;
         return;
      endif;

   //if %INT - BIF found
   when %scan('%INT(' : %trim(C_Str_name):1) > 0;
      C_st_pos      = %scan('%INT(' : %trim(C_Str_name):1);

      if C_st_pos > 0;
         c_BIF = '%INT';
         C_st_pos_blnk = %scan(' ' : %trim(C_Str_name):6);

         if C_st_pos_blnk = 0;
            C_st_pos_blnk = %scan(')' : %trim(C_Str_name):6);
         endif;

         if C_st_pos_blnk > 6;
            c_BIFstr = %subst( %trim(C_Str_name):6:C_st_pos_blnk - 6);
         endif;
         return;
      endif;

   //if %LEN - BIF found
   when %scan('%LEN(' : %trim(C_Str_name):1) > 0;
      C_st_pos = %scan('%LEN(' : %trim(C_Str_name):1);

      if C_st_pos > 0;
         c_BIF = '%LEN';
         C_st_pos_blnk = %scan(' ' : %trim(C_Str_name):6);

         if C_st_pos_blnk = 0;
            C_st_pos_blnk = %scan(')' : %trim(C_Str_name):6);
         endif;

         if C_st_pos_blnk > 6;
            c_BIFstr = %subst( %trim(C_Str_name):6:C_st_pos_blnk - 6);
         endif;
         return;
      endif;

   //if %LOWER - BIF found
   when %scan('%LOWER(' : %trim(C_Str_name):1) > 0;
      C_st_pos = %scan('%LOWER(' : %trim(C_Str_name):1);
      if C_st_pos > 0;
         c_BIF = '%LOWER';
         C_st_pos_blnk = %scan(' ' : %trim(C_Str_name):8);

         if C_st_pos_blnk = 0;
            C_st_pos_blnk = %scan(')' : %trim(C_Str_name):8);
         endif;

         if C_st_pos_blnk > 8;
            c_BIFstr = %subst( %trim(C_Str_name):8:C_st_pos_blnk - 8);
         endif;
         return;
      endif;

   //if %OFFSET - BIF found
   when %scan('%OFFSET(' : %trim(C_Str_name):1) > 0;
      C_st_pos = %scan('%OFFSET(' : %trim(C_Str_name):1);
      if C_st_pos > 0;
         c_BIF = '%OFFSET';
         C_st_pos_blnk = %scan(' ' : %trim(C_Str_name):9);

         if C_st_pos_blnk = 0;
            C_st_pos_blnk = %scan(')' : %trim(C_Str_name):9);
         endif;

         if C_st_pos_blnk > 9;
            c_BIFstr = %subst( %trim(C_Str_name):9:C_st_pos_blnk - 9);
         endif;
         return;
      endif;

   //if %OFS - BIF found
   when %scan('%OFS(' : %trim(C_Str_name):1) > 0;
      C_st_pos = %scan('%OFS(' : %trim(C_Str_name):1);
      if C_st_pos > 0;
         c_BIF = '%OFS';
         C_st_pos_blnk = %scan(' ' : %trim(C_Str_name):6);

         if C_st_pos_blnk = 0;
            C_st_pos_blnk = %scan(')' : %trim(C_Str_name):6);
         endif;

         if C_st_pos_blnk > 6;
            c_BIFstr = %subst( %trim(C_Str_name):6:C_st_pos_blnk - 6);
         endif;
         return;
      endif;

   //if %PARMS - BIF found
   when %scan('%PARMS(' : %trim(C_Str_name):1) > 0;
      C_st_pos = %scan('%PARMS(' : %trim(C_Str_name):1);

      if C_st_pos > 0;
         c_BIF = '%PARMS';
         C_st_pos_blnk = %scan(' ' : %trim(C_Str_name):8);

         if C_st_pos_blnk = 0;
            C_st_pos_blnk = %scan(')' : %trim(C_Str_name):8);
         endif;

         if C_st_pos_blnk > 8;
            c_BIFstr = %subst( %trim(C_Str_name):8:C_st_pos_blnk - 8);
         endif;
         return;
      endif;

   //if %SCAN - BIF found
   when %scan('%SCAN(' : %trim(C_Str_name):1) > 0;
      C_st_pos = %scan('%SCAN(' : %trim(C_Str_name):1);
      if C_st_pos > 0;
         c_BIF = '%SCAN';
         C_st_pos_blnk = %scan(' ' : %trim(C_Str_name):7);

         if C_st_pos_blnk = 0;
            C_st_pos_blnk = %scan(')' : %trim(C_Str_name):7);
         endif;

         if C_st_pos_blnk > 7;
            c_BIFstr = %subst( %trim(C_Str_name):7:C_st_pos_blnk - 7);
         endif;
         //Get second argument...
         C_st_pos_end = %scan(')' : %trim(C_Str_name) :C_st_pos_blnk + 1);

       //if C_st_pos_end > 0;
         If C_st_pos_end > 0 and (C_st_pos_end - 1) > C_st_pos_blnk;                    //VP01
            c_BIFf1 = %subst( %trim(C_Str_name):C_st_pos_blnk + 1
                            :(C_st_pos_end - 1) - C_st_pos_blnk );
         endif;
         return;
      endif;

   //if %SIZE - BIF found
   when %scan('%SIZE(' : %trim(C_Str_name):1) > 0;
      C_st_pos      = %scan('%SIZE(' : %trim(C_Str_name):1);
      if C_st_pos > 0;
         c_BIF = '%SIZE';
         C_st_pos_blnk = %scan(' ' : %trim(C_Str_name):7);

         if C_st_pos_blnk = 0;
            C_st_pos_blnk = %scan(')' : %trim(C_Str_name):7);
         endif;

         if C_st_pos_blnk > 7;
            c_BIFstr = %subst( %trim(C_Str_name):7:C_st_pos_blnk - 7);
         endif;
         return;
      endif;

   //if %SUBSTRING or %SST - BIF found
   when %scan('%SUBSTRING(' : %trim(C_Str_name):1) > 0     or
        %scan('%SUBSTRING'  : %trim(C_Str_name):1) > 0     or
        %scan('%SST('       : %trim(C_Str_name):1) > 0     or
        %scan('%SST'        : %trim(C_Str_name):1) > 0;
      C_st_pos = %scan('%SUBSTRING(' : %trim(C_Str_name):1);
      if C_st_pos > 0;
         c_BIF = '%SUBSTRING';
         C_st_pos_blnk = %scan(' ' : %trim(C_Str_name):12);
         if C_st_pos_blnk > 12;
            c_BIFstr = %subst( %trim(C_Str_name):12:C_st_pos_blnk - 12);
         endif;
         return;
      endif;

      C_st_pos = %scan('%SUBSTRING' : %trim(C_Str_name):1);
      if C_st_pos > 0;
         c_BIF = '%SUBSTRING';
         C_st_pos_blnk = %scan(' ' : %trim(C_Str_name):11);
         if C_st_pos_blnk > 11;
            c_BIFstr = %subst( %trim(C_Str_name):11:C_st_pos_blnk - 11);
         endif;
         return;
      endif;

      C_st_pos = %scan('%SST(' : %trim(C_Str_name):1);
      if C_st_pos > 0;
         c_BIF = '%SST';
         C_st_pos_blnk = %scan(' ' : %trim(C_Str_name):6);
         if C_st_pos_blnk > 6;
            c_BIFstr = %subst( %trim(C_Str_name):6:C_st_pos_blnk - 6);
         endif;
         return;
      endif;

      C_st_pos = %scan('%SST' : %trim(C_Str_name):1);
      if C_st_pos > 0;
         c_BIF = '%SST';
         C_st_pos_blnk = %scan(' ' : %trim(C_Str_name):5);
         if C_st_pos_blnk > 5;
            c_BIFstr = %subst( %trim(C_Str_name):5:C_st_pos_blnk - 5);
         endif;
         return;
      endif;

   //if %SWITCH - BIF found
   when %scan('%SWITCH(' : %trim(C_Str_name):1) > 0;
      C_st_pos      = %scan('%SWITCH(' : %trim(C_Str_name):1);
      if C_st_pos > 0;
         c_BIF = '%SWITCH';
         C_st_pos_blnk = %scan(' ' : %trim(C_Str_name):9);
         if C_st_pos_blnk = 0;
            C_st_pos_blnk = %scan(')' : %trim(C_Str_name):9);
         endif;

         if C_st_pos_blnk > 9;
            c_BIFstr = %subst( %trim(C_Str_name):9:C_st_pos_blnk - 9);
         endif;
         return;
      endif;

   //if %TRIM - BIF found
   when %scan('%TRIM(' : %trim(C_Str_name):1) > 0;
      C_st_pos      = %scan('%TRIM(' : %trim(C_Str_name):1);
      if C_st_pos > 0;
         c_BIF = '%TRIM';
         C_st_pos_blnk = %scan(' ' : %trim(C_Str_name):7);
         if C_st_pos_blnk = 0;
            C_st_pos_blnk = %scan(')' : %trim(C_Str_name):7);
         endif;

         if C_st_pos_blnk > 7;
            c_BIFstr = %subst( %trim(C_Str_name):7:C_st_pos_blnk - 7);
         endif;
         return;
      endif;

   //if %TRIML - BIF found
   when %scan('%TRIML(' : %trim(C_Str_name):1) > 0;
      C_st_pos = %scan('%TRIML(' : %trim(C_Str_name):1);
      if C_st_pos > 0;
         c_BIF = '%TRIML';
         C_st_pos_blnk = %scan(' ' : %trim(C_Str_name):8);
         if C_st_pos_blnk = 0;
            C_st_pos_blnk = %scan(')' : %trim(C_Str_name):8);
         endif;

         if C_st_pos_blnk > 8;
            c_BIFstr = %subst( %trim(C_Str_name):8:C_st_pos_blnk - 8);
         endif;
         return;
      endif;

   //if %TRIMR - BIF found
   when %scan('%TRIMR(' : %trim(C_Str_name):1) > 0;
      C_st_pos = %scan('%TRIMR(' : %trim(C_Str_name):1);
      if C_st_pos > 0;
         c_BIF = '%TRIMR';
         C_st_pos_blnk = %scan(' ' : %trim(C_Str_name):8);
         if C_st_pos_blnk = 0;
            C_st_pos_blnk = %scan(')' : %trim(C_Str_name):8);
         endif;

         if C_st_pos_blnk > 8;
            c_BIFstr = %subst( %trim(C_Str_name):8:C_st_pos_blnk - 8);
         endif;
         return;
      endif;

   //if %UNIT - BIF found
   when %scan('%UNIT(' : %trim(C_Str_name):1) > 0;
      C_st_pos = %scan('%UNIT(' : %trim(C_Str_name):1);
      if C_st_pos > 0;
         c_BIF = '%UNIT';
         C_st_pos_blnk = %scan(' ' : %trim(C_Str_name):7);
         if C_st_pos_blnk = 0;
            C_st_pos_blnk = %scan(')' : %trim(C_Str_name):7);
         endif;

         if C_st_pos_blnk > 7;
            c_BIFstr = %subst( %trim(C_Str_name):7:C_st_pos_blnk - 7);
         endif;
         return;
      endif;

   //if %UNS - BIF found
   when %scan('%UNS(' : %trim(C_Str_name):1) > 0;
      C_st_pos = %scan('%UNS(' : %trim(C_Str_name):1);
      if C_st_pos > 0;
         c_BIF = '%UNS';
         C_st_pos_blnk = %scan(' ' : %trim(C_Str_name):6);
         if C_st_pos_blnk = 0;
            C_st_pos_blnk = %scan(')' : %trim(C_Str_name):6);
         endif;

         if C_st_pos_blnk > 6;
            c_BIFstr = %subst( %trim(C_Str_name):6:C_st_pos_blnk - 6);
         endif;
         return;
      endif;

   //if %UPPER - BIF found
   when %scan('%UPPER(' : %trim(C_Str_name):1) > 0;
      C_st_pos      = %scan('%UPPER(' : %trim(C_Str_name):1);
      if C_st_pos > 0;
         c_BIF = '%UPPER';
         C_st_pos_blnk = %scan(' ' : %trim(C_Str_name):8);
         if C_st_pos_blnk = 0;
            C_st_pos_blnk = %scan(')' : %trim(C_Str_name):8);
         endif;

         if C_st_pos_blnk > 8;
            c_BIFstr = %subst( %trim(C_Str_name):8:C_st_pos_blnk - 8);
         endif;
         return;
      endif;

   endsl;
   return;
end-proc;

//------------------------------------------------------------------------------------ //
//IaBreakSrcString:                                                                    //
//------------------------------------------------------------------------------------ //
dcl-proc IaBreakSrcString export;
   dcl-pi IaBreakSrcString;
      in_sourcestring char(9999);
      in_array        char(120) dim(4999);
      in_index        packed(4:0);
   end-pi;

   dcl-s br_asteriskpos  packed(4:0);
   dcl-s br_startPos     packed(10:0)      inz(1);
   dcl-s br_foundPos     packed(10:0);
   dcl-s br_increment    packed(10:0);

   dcl-c br_pads         '?+~-/=<>():;,''"';
   dcl-c br_blk          '                ';
   dcl-c up              'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
   dcl-c lo              'abcdefghijklmnopqrstuvwxyz';

   If in_sourcestring = *Blanks;                                                        //VP01
      Return;                                                                           //VP01
   EndIf;                                                                               //VP01

   br_foundpos = 0;
   br_startpos = 1;
   in_sourcestring = %xlate(lo:up:in_sourcestring);
   in_sourcestring = %xlate(br_pads:br_blk:in_sourcestring);
   Clear in_array;
   in_index = 1;
   br_increment = %len(' ');

   dou br_foundPos = %len(%trim(in_sourcestring)) + 1 or
                     %len(%trim(in_sourcestring)) = 0;
      br_foundpos = %scan(' ':%trim(in_sourcestring):br_startPos);

      if br_foundpos > 0;
         dow %subst(%trim(in_sourcestring):br_foundpos+1:1) = ' ';
            in_sourcestring = %replace('':%trim(in_sourcestring):br_foundpos+1:1);
         enddo;
      Endif;

      if br_foundPos = 0;
         br_foundPos = %len(%trim(in_sourcestring)) + 1;
      endif;

      if br_startPos > 0 and br_foundPos > br_startPos
         and in_index <= %elem(in_array);
        in_array(in_index) = %subst(%trim(in_sourcestring):br_startPos:
                           br_foundPos - br_startPos);

        clear br_asteriskpos;
        br_asteriskpos = %scan('*':%trim(in_array(in_index)):1);

        dow br_asteriskpos > 1 and
                %len(%trim(in_array(in_index))) > br_asteriskpos and
                %subst(%trim(in_array(in_index)):br_asteriskpos+1: 1) <> '*';
          if in_index+1 <= %elem(in_array);
            in_array(in_index+1) = %subst(%trim(in_array(in_index)):br_asteriskpos+1:
                                      %len(%trim(in_array(in_index)))-br_asteriskpos);
          else;
            leave;
          endif;
          in_array(in_index) = %subst(%trim(in_array(in_index)):1:br_asteriskpos-1);
          in_index+=1;
          If in_index <= %elem(in_array);
            br_asteriskpos = %scan('*':%trim(in_array(in_index)):1);                      //BS04
          Else;
            leave;
          Endif;
        Enddo;
      Else;
        leave;
      Endif;

      in_index += 1;
      br_startPos = br_foundPos + br_increment;
   enddo;
   return;
end-proc;

//------------------------------------------------------------------------------------ //
//GetObjectSourceInfo:                                                                 //
//------------------------------------------------------------------------------------ //
dcl-proc GetObjectSourceInfo export;
   dcl-pi GetObjectSourceInfo likeds(object_info_t) dim(99);
      module_name char(10) const;
   end-pi;

   dcl-ds object_details likeds(object_info_t) dim(99) inz;

   //capture erros while reading user space
   dcl-ds errors;
      error_bytes_pointer int(10) inz(%size(errors));
      error_bytes_attributes int(10) inz;
      error_message_id char(7);
      error_reserve_alpha char(1);
      error_message char(240);
   end-ds;

   //Header data information
   dcl-s header_pointer pointer;
   dcl-ds header based(header_pointer);
      header_filler1 char(103);
      header_status char(1);
      header_filler2 char(12);
      header_size_offset int(10);
      header_size int(10);
      header_list_size_offset int(10);
      header_list_size int(10);
      header_list_size_record_count int(10);
      header_single_size_record int(10);
   end-ds;

   //Capture data from user space for ILE programs and service programs
   dcl-s record_pointer pointer;
   dcl-ds program_info based(record_pointer);
      program_name char(10);
      program_library char(10);
      program_module char(10);
      program_module_library char(10);
      program_source_file char(10);
      program_source_library char(10);
      program_source_member char(10);
      program_source_attribute char(10);
      program_creation_date char(13);
      program_source_creation_date char(13);
   end-ds;

   dcl-ds object_info inz;
      object_info_string char(20);
         object_name char(10) overlay(object_info_string);
         object_user char(10) overlay(object_info_string :*next);
   end-dS;

   dcl-ds user_space_info inz;
      user_space_info_string char(20);
         user_space_name char(10) overlay(user_space_info_string);
         user_space_library char(10) overlay(user_space_info_string :*next);
   end-dS;

   dcl-s element packed(3 :0) inz;
   dcl-s header_record int(10);
   dcl-c default_user_space 'OBJNAME';
   dcl-c default_user_space_library 'QTEMP';
   dcl-c default_user '*ALLUSR';
   dcl-c format_PGM 'PGML0100';
   dcl-c format_SRVPGM 'SPGL0100';

   user_space_name    = default_user_space;
   user_space_library = default_user_space_library;
   object_name = module_name;
   object_user = default_user;

   //Initialy dump the module information in user space
   createUserSpace(%trimr(user_space_info)
                   :'USRSPC'
                   :1024*1024
                   :x'00'
                   :'*ALL'
                   :'List of program modules'
                   :'*YES'
                   :errors);

   if not(error_bytes_attributes > 0);
      retriveUserSpace(%trimr(user_space_info):header_pointer);
   endif;

   //Gather ILE programs information to user space
   listILEPrograms(%trimr(user_space_info)
                   :format_PGM
                   :%trimr(object_info_string)
                   :errors);

   //write modules information in to data structure
   if not(error_bytes_attributes > 0);
      record_pointer = header_pointer + header_list_size_offset;
      for header_record = 1 to header_list_size_record_count;
         if program_name = module_name;
            element += 1;
            eval-corr object_details(element) = program_info;
         endif;
         record_pointer = record_pointer + header_single_size_record;
      endfor;
   endif;


   //Gather service programs information to user space
   listServicePrograms(%trimr(user_space_info)
                       :format_SRVPGM
                       :%trimr(object_info_string)
                       :errors);

   //write service programs information in to data structure
   if not(error_bytes_attributes > 0);
      record_pointer = header_pointer + header_list_size_offset;
      for header_record = 1 to header_list_size_record_count;
         if program_name = module_name;
            element += 1;
            eval-corr object_details(element) = program_info;
         endif;
         record_pointer = record_pointer + header_single_size_record;
      endfor;
   endif;

   return object_details;
end-proc;

//------------------------------------------------------------------------------------ //
//IsVariableOrConst: To check Whether parameter is having constant or variable as      //
//                   a Value.                                                          //
//------------------------------------------------------------------------------------ //
dcl-proc IsVariableOrConst export;
   dcl-pi *n varchar(80);
      inFactor char(80) const;
   end-pi;

   dcl-s outFactor char(80) inz(*Blanks);

   //If input factor value is *Blanks return
   If inFactor = *BLANKS;
     return %trim(outFactor);
   EndIf;

   Select;
      //Values in Quotes consider it as Character constant
      //when %scan('"' :%trim(inFactor)) =  1;                                            //0029
      when %scan('"' :%trim(inFactor))  <> *Zeros;                                        //0029
         outFactor = 'CONST(' + %trim(inFactor) + ')' ;

      //For *Blanks , *On, *Off and variable start with *
      When %scan('*':%trim(inFactor):1) = 1;
         outFactor = 'Const(' + %trim(inFactor) + ')';

      //For Alphanumeric Values consider as variable
      When %check(DIGITS :%trim(inFactor)) <> 0;
         outFactor = %trim(inFactor);

      //For Numeric Values consider Numeric constant
      When %check( DIGITS :%trim(inFactor)) = 0;
         outFactor = 'CONST(' + %trim(inFactor) + ')';

      Other;
         outFactor = inFactor;
   EndSl;

   return %trim(outFactor);
end-proc;

//------------------------------------------------------------------------------------ //
//GetFileObjSourceInfo: Execute Qusrobjd API, included in copy is DS to extract values.//
//                      If format not passed, default OBJD0200.                        //
//------------------------------------------------------------------------------------ //
dcl-proc GetFileObjSourceInfo export;
   dcl-pi *n char(480);
      p_ObjQual   char(20) const;
      p_ObjTyp    char(10) const;
      p_ApiFormat char(8)  const options(*nopass);
   end-pi;

   dcl-s LocalApiFormat char(8);

   dcl-pr Qusrobjd extpgm('QUSROBJD');  //object description
      *n char(472) options(*varsize);   //receiver
      *n int(10)   const;               //receiver length
      *n char(8)   const;               //api format
      *n char(20)  const;               //object and lib
      *n char(10)  const;               //object type
      *n like(ApiErrDS);
   end-pr;

   if %parms = %parmnum(p_ApiFormat);
      LocalApiFormat = p_ApiFormat;
   else;
      LocalApiFormat = 'OBJD0200';
   endif;

   callp QUSROBJD(QusrobjDS      :
                  %len(QusrobjDS):
                  LocalApiFormat :
                  p_ObjQual      :
                  p_ObjTyp       :
                  ApiErrDS);

   return QUSROBJDS;
End-Proc;

//------------------------------------------------------------------------------------ //
//IASrcRefW                                                                            //
//                                                                                     //
//------------------------------------------------------------------------------------ //

dcl-proc Iasrcrefw;                                                                       //BA01
                                                                                          //BA01
    dcl-pi  Iasrcrefw;                                                                    //BA01
        in_mbrlib     char(10) const options(*trim);                                      //OJ01
        in_mbrnam     char(10) const options(*trim);                                      //OJ01
        in_mbrtyp     char(10) const options(*trim);                                      //OJ01
        in_mbrsrc     char(50) const options(*trim);                                      //OJ01
     // in_IfsLoc     char(100)const options(*trim);                                      //0062
        in_refobj     char(11) const options(*trim);                                      //OJ01
        in_refotyp    char(11) const options(*trim);                                      //OJ01
        in_refolib    char(11) const options(*trim);                                      //OJ01
        in_refousg    char(17) const options(*trim);                                      //OJ01
        in_iarfileusg char(32) const options(*trim);                                      //OJ01
    end-pi;                                                                               //OJ01
                                                                                          //BA01
     exec sql                                                                             //BA01
        insert into iasrcintpf (iambrlib,                                                 --BA01
                                iambrnam,                                                 --BA01
                                iambrtyp,                                                 --BA01
                                iambrsrc,                                                 --BA01
                                iamifslc,                                                 --0062
                                iarefobj,                                                 --BA01
                                iarefotyp,                                                --BA01
                                iarefolib,                                                --BA01
                                iarefousg,                                                --BA01
                                iarfileusg)                                               --BA01
                       VALUES  (:in_mbrlib,                                              //OJ01
                                :in_mbrnam,                                              //OJ01
                                :in_mbrtyp,                                              //OJ01
                                :in_mbrsrc,                                              //OJ01
                                :in_IfsLoc,                                              //0062
                                :in_refobj,                                              //OJ01
                                :in_refotyp,                                             //OJ01
                                :in_refolib,                                             //OJ01
                                :in_refousg,                                             //OJ01
                                :in_iarfileusg);                                         //OJ01
   end-proc;                                                                              //BA01
//------------------------------------------------------------------------------------ //
//IAPsr3Fac                                                                            //
//                                                                                     //
//------------------------------------------------------------------------------------ //
dcl-proc IAPsr3Fac export;                                                                 //VM01
   dcl-pi IAPsr3Fac;                                                                       //VM01
      in_string char(5000);                                                                //VM01
      in_type   char(10);                                                                  //VM01
      in_error  char(10);                                                                  //VM01
      in_xref   char(10);                                                                  //VM01
   // in_srclib char(10);                                                             0062 //VM01
   // in_srcspf char(10);                                                             0062 //VM01
   // in_srcmbr char(10);                                                             0062 //VM01
      in_uWSrcDtl likeds(uWSrcDtl);                                                        //0062
      in_RRN    packed(6:0);                                                               //VM01
      in_RRN_e  packed(6:0);                                                               //VM01
   end-pi;                                                                                 //VM01
                                                                                           //VM01
   dcl-ds IAVARRELDs extname('IAVARREL') prefix(In_) inz;                                  //VM01
   end-ds;                                                                                 //VM01
                                                                                           //VM01
   dcl-s In_factor1 char(50)    inz;                                                       //VM01
   dcl-s In_factor2 char(50)    inz;                                                       //VM01
   dcl-s In_seq     packed(6:0) inz;                                                       //VM01
   dcl-s In_Bif     char(10)    inz;                                                       //VM01
   dcl-s Za_type    char(10)    inz;                                                       //VM01
   dcl-s Za_length  packed(4:0) inz;                                                       //VM01
   dcl-s Za_pos     packed(4:0) inz;                                                       //VM01
 //dcl-s Za_field   char(500)   inz;                                                //YK06 //VM01
 //dcl-s Za_field1  char(500)   inz;                                                //YK06 //VM01
   dcl-s Za_field2  char(500)   inz;                                                       //VM01
                                                                                           //VM01
      uwsrcdtl = in_Uwsrcdtl;                                                              //0062
      ZA_length   = %len(%trimr(in_string));                                               //VM01
   // Za_Field    = %subst(in_string:12:14 );                                       //YK06 //VM01
   // Za_Field1   = %subst(in_string:36:14 );                                       //YK06 //VM01
      Za_field2   =  %subst(in_string:50:14);                                              //VM01
      In_factor1  = %subst(in_string:12:14 );                                              //YK06
      In_factor2  = %subst(in_string:36:14 );                                              //YK06
      ZA_Type     = %subst(in_string:26:10);                                               //VM01
   // ZA_pos      = %scan(':':%trim(ZA_field1));                                    //YK06 //VM01
      ZA_pos      = %scan(':':%trim(In_factor2));                                          //YK06
                                                                                           //VM01
      If ZA_pos > 1 ;                                                                      //VM01
      // ZA_field1   = %subst(ZA_field1:1:ZA_pos-1);                                //YK06 //VM01
         In_factor2   = %subst(In_factor2:1:ZA_pos-1);                                     //YK06
      Endif ;                                                                              //VM01
                                                                                           //VM01
      ZA_pos  = %scan(':':ZA_field2);                                                      //VM01
                                                                                           //VM01
      If ZA_pos > 1 ;                                                                      //VM01
         ZA_field2 = %subst(ZA_field2:1:ZA_pos-1);                                         //VM01
      Endif ;                                                                              //VM01
                                                                                           //VM01
      In_RERESULT = Za_field2;                                                             //VM01
      In_REOPC    = Za_type;                                                               //VM01
                                                                                           //VM01
    //If za_field  =  *blanks;                                                      //YK06 //VM01
      If In_factor1 = *blanks;                                                             //YK06
         In_REFACT1 = *blanks;                                                             //VM01
      Else ;                                                                               //VM01
    //   In_REFACT1  =  Za_Field;                                                   //YK06 //VM01
         In_REFACT1  =  In_factor1;                                                 //YK06 //VM01
         In_REFACT1 = isVariableOrConst(In_REFACT1);                                       //VM01
      Endif ;                                                                              //VM01
                                                                                           //VM01
    //If za_field1 =  *blanks ;                                                     //YK06 //VM01
      If In_factor2 = *blanks;                                                             //YK06
         In_REFACT2 = *blanks ;                                                            //VM01
      Else ;                                                                               //VM01
    //   In_REFACT2  =  Za_Field1 ;                                                 //YK06 //VM01
         In_REFACT2  =  In_factor2;                                                 //YK06 //VM01
         In_REFACT2 = isVariableOrConst(In_REFACT2);                                       //VM01
      Endif ;                                                                              //VM01
                                                                                           //VM01
      Exsr varref;                                                                         //VM01
                                                                                           //VM01
 Return;                                                                                   //VM01
//------------------------------------------------------------------------------------ // //VM01
 Begsr varref;                                                                             //VM01
    in_RESRCLIB = in_srclib;                                                               //VM01
    in_RESRCFLN = in_srcspf;                                                               //VM01
    in_REPGMNM  = in_srcmbr;                                                               //VM01
    in_REIFSLOC = in_IfsLoc;                                                               //0062
                                                                                           //VM01
    If in_seq = 0;                                                                         //VM01
       in_RESEQ = 1;                                                                       //VM01
       in_seq = in_reseq;                                                                  //VM01
    Else;                                                                                  //VM01
       in_reseq = in_reseq+1;                                                              //VM01
       in_seq = in_reseq;                                                                  //VM01
    Endif;                                                                                 //VM01
                                                                                           //VM01
    in_RERRN  = In_rrn;                                                                    //VM01
    in_RENUM1 = 0;                                                                         //VM01
    in_RENUM2 = 0;                                                                         //VM01
    in_RENUM3 = 0;                                                                         //VM01
    in_RENUM4 = 0;                                                                         //VM01
    in_RENUM5 = 0;                                                                         //VM01
    in_RENUM6 = 0;                                                                         //VM01
    in_RENUM7 = 0;                                                                         //VM01
    in_RENUM8 = 0;                                                                         //VM01
    in_RENUM9 = 0;                                                                         //VM01
                                                                                           //VM01
    IAVARRELLOG(in_RESRCLIB:                                                               //VM01
                in_RESRCFLN:                                                               //VM01
                in_REPGMNM:                                                                //VM01
                in_REIFSLOC:                                                               //0062
                in_RESEQ:                                                                  //VM01
                in_RERRN:                                                                  //VM01
                in_REROUTINE:                                                              //VM01
                in_RERELTYP:                                                               //VM01
                in_RERELNUM:                                                               //VM01
                in_REOPC:                                                                  //VM01
                in_RERESULT:                                                               //VM01
                in_bif:                                                                    //VM01
                in_REFACT1:                                                                //VM01
                in_RECOMP:                                                                 //VM01
                in_REFACT2:                                                                //VM01
                in_RECONTIN:                                                               //VM01
                in_RERESIND:                                                               //VM01
                in_RECAT1:                                                                 //VM01
                in_RECAT2:                                                                 //VM01
                in_RECAT3:                                                                 //VM01
                in_RECAT4:                                                                 //VM01
                in_RECAT5:                                                                 //VM01
                in_RECAT6:                                                                 //VM01
                in_REUTIL:                                                                 //VM01
                in_RENUM1:                                                                 //VM01
                in_RENUM2:                                                                 //VM01
                in_RENUM3:                                                                 //VM01
                in_RENUM4:                                                                 //VM01
                in_RENUM5:                                                                 //VM01
                in_RENUM6:                                                                 //VM01
                in_RENUM7:                                                                 //VM01
                in_RENUM8:                                                                 //VM01
                in_RENUM9:                                                                 //VM01
                in_REEXC:                                                                  //VM01
                in_REINC);                                                                 //VM01
 Endsr;                                                                                    //VM01
End-proc;                                                                                  //VM01
                                                                                           //VM01
//------------------------------------------------------------------------------------ // //VM01
//IAPsrFxFx                                                                            // //VM01
//                                                                                     // //VM01
//------------------------------------------------------------------------------------ // //VM01
Dcl-proc IAPsrFxFx export;                                                                 //VM01
   Dcl-pi IAPsrFxFx;                                                                       //VM01
      in_string    char(5000);                                                             //VM01
      in_type      char(10);                                                               //VM01
      in_error     char(10);                                                               //VM01
      in_xref      char(10);                                                               //VM01
   // in_srclib char(10);                                                             0062 //VM01
   // in_srcspf char(10);                                                             0062 //VM01
   // in_srcmbr char(10);                                                             0062 //VM01
      in_uWSrcDtl likeds(uWSrcDtl);                                                        //0062
      in_rrn_s     packed(6:0);                                                            //VM01
      in_rrn_e     packed(6:0);                                                            //VM01
      in_ErrLogFlg char(1);                                                                //VM05
   End-pi;                                                                                 //VM01
                                                                                           //VM01
   Dcl-s In_seq       packed(6:0) inz;                                                     //VM01
   Dcl-s In_Bif       char(10)    inz;                                                     //VM01
   Dcl-s io_opcode    char(10)    inz;                                                     //VM01
   Dcl-s io_factor1   char(80)    inz;                                                     //VM01
   Dcl-s io_factor1k  char(5000)  inz;                                                     //VM01
   Dcl-s io_factor2   char(80)    inz;                                                     //VM01
   Dcl-s io_result    char(50)    inz;                                                     //VM01
   Dcl-s io_seqn      packed(6:0) inz;                                                     //VM01
   Dcl-s io_rerrn     packed(6:0) inz;                                                     //VM01
   Dcl-s io_indicator char(6)     inz;                                                     //VM01
   Dcl-s i            packed(4:0) inz;                                                     //VM01
   Dcl-s j            packed(4:0) inz;                                                     //VM01
   Dcl-s m            packed(4:0) inz;                                                     //VM01
   Dcl-s k            packed(4:0) inz;                                                     //VM01
   Dcl-s String       char(5000)  inz;                                                     //VM01
   Dcl-s arr          char(80)    inz dim(15);                                             //VM01
   Dcl-s W_SrcFile    char(10)    inz;                                                     //VM01
                                                                                           //VM01
   Dcl-ds IAVARRELDs extname('IAVARREL') prefix(In_) inz;                                  //VM01
   End-ds;                                                                                 //VM01
                                                                                           //VM01
      //KD01 io_opcode    = %subst(in_string : 28 : 5);
      //KD01 io_factor1   = %subst(in_string : 18 : 10);
      //KD01 io_factor2   = %subst(in_string : 33 : 10);                                   //VM01
      //kd01 io_result    = %subst(in_string : 43 : 6);                                   //VM01
      //KD01 io_indicator = %subst(in_string : 54 :  6);                                   //VM01
      //KD01 in_RERESULT = iO_RESULT;                                                      //VM01
      //KD01 in_REOPC    = IO_OPCODE;                                                      //VM01
      In_ReOpc     = %subst(in_string : 28 : 5);                                           //KD01
      In_ReFact1   = %subst(in_string : 18 : 10);                                          //KD01
      In_ReFact2   = %subst(in_string : 33 : 10);                                          //KD01
      In_ReResult  = %subst(in_string : 43 : 6);                                           //KD01
      In_ReResind  = %subst(in_string : 54 :  6);                                          //KD01
                                                                                           //VM01
      //KD01 If io_factor1=  *blanks;                                                      //VM01
      //KD01   In_REFACT1 = *blanks;                                                       //VM01
      //KD01 Else ;                                                                        //VM01
      //KD01   In_REFACT1  =  io_factor1;                                                  //VM01
      If In_ReFact1 <> *blanks;                                                            //KD01
        In_REFACT1 = isVariableOrConst(In_REFACT1);                                        //VM01
      Endif ;                                                                              //VM01
                                                                                           //VM01
      //KD01 If io_factor2=  *blanks;                                                      //VM01
      //KD01   In_REFACT2 = *blanks;                                                       //VM01
      //KD01 Else ;                                                                        //VM01
      //KD01   If %scan(':':%trim(io_factor2):1) <> 0 ;                                    //vm05
      //KD01     Io_factor2 = %subst(%trim(io_factor2):1:                                  //vm05
      //KD01                  (%scan(':':%trim(io_factor2):1)-1));                          //vm05
      If In_ReFact2 <> *blanks;                                                            //KD01
        If %scan(':':%trim(In_ReFact2):1) > 1;                                             //KD01
           In_ReFact2 = %subst(%trim(In_ReFact2):1:                                        //KD01
                              (%scan(':':%trim(In_ReFact2):1)-1));                         //KD01
        Endif ;                                                                            //vm05
      //KD01  In_REFACT2  =  io_factor2;                                                   //VM01
        In_REFACT2 = isVariableOrConst(In_REFACT2);                                        //VM01
      Endif ;                                                                              //VM01
                                                                                           //VM01
      Exsr varref        ;                                                                 //VM01
   Return;                                                                                 //VM01
                                                                                           //VM01
   Begsr varref;                                                                           //VM01
      in_RESRCLIB = in_srclib;                                                             //VM01
      in_RESRCFLN = in_srcspf;                                                             //VM01
      in_REPGMNM  = in_srcmbr;                                                             //VM01
      in_REIFSLOC = in_IfsLoc;                                                             //0062
                                                                                           //VM01
      if in_seq = 0;                                                                       //VM01
        in_RESEQ = 1;                                                                      //VM01
        in_seq = in_reseq;                                                                 //VM01
      else;                                                                                //VM01
        in_reseq = in_reseq+1;                                                             //VM01
        in_seq = in_reseq;                                                                 //VM01
      endif;                                                                               //VM01
                                                                                           //VM01
      in_RERRN  = In_rrn_s;                                                                //VM01
      in_RENUM1 = 0;                                                                       //VM01
      in_RENUM2 = 0;                                                                       //VM01
      in_RENUM3 = 0;                                                                       //VM01
      in_RENUM4 = 0;                                                                       //VM01
      in_RENUM5 = 0;                                                                       //VM01
      in_RENUM6 = 0;                                                                       //VM01
      in_RENUM7 = 0;                                                                       //VM01
      in_RENUM8 = 0;                                                                       //VM01
      in_RENUM9 = 0;                                                                       //VM01
                                                                                           //VM01
      IAVARRELLOG(in_RESRCLIB:                                                             //VM01
                  in_RESRCFLN:                                                             //VM01
                  in_REPGMNM:                                                              //VM01
                  in_REIFSLOC:                                                             //0062
                  in_RESEQ:                                                                //VM01
                  in_RERRN:                                                                //VM01
                  in_REROUTINE:                                                            //VM01
                  in_RERELTYP:                                                             //VM01
                  in_RERELNUM:                                                             //VM01
                  in_REOPC:                                                                //VM01
                  in_RERESULT:                                                             //VM01
                  in_rebif:                                                                //VM01
                  in_REFACT1:                                                              //VM01
                  in_RECOMP:                                                               //VM01
                  in_REFACT2:                                                              //VM01
                  in_RECONTIN:                                                             //VM01
               //KD01   io_indicator:                                                      //VM01
                  In_ReResind:                                                             //KD01
                  in_RECAT1:                                                               //VM01
                  in_RECAT2:                                                               //VM01
                  in_RECAT3:                                                               //VM01
                  in_RECAT4:                                                               //VM01
                  in_RECAT5:                                                               //VM01
                  in_RECAT6:                                                               //VM01
                  in_REUTIL:                                                               //VM01
                  in_RENUM1:                                                               //VM01
                  in_RENUM2:                                                               //VM01
                  in_RENUM3:                                                               //VM01
                  in_RENUM4:                                                               //VM01
                  in_RENUM5:                                                               //VM01
                  in_RENUM6:                                                               //VM01
                  in_RENUM7:                                                               //VM01
                  in_RENUM8:                                                               //VM01
                  in_RENUM9:                                                               //VM01
                  in_REEXC:                                                                //VM01
                  in_REINC);                                                               //VM01
   Endsr;                                                                                  //VM01
End-proc;                                                                                  //VM01
                                                                                           //VM01
//------------------------------------------------------------------------------------ //  //VM01
//IAPsr3Con                                                                            //  //VM01
//                                                                                     //  //VM01
//------------------------------------------------------------------------------------ //  //VM01
Dcl-proc IAPsr3Con export;                                                                  //VM01
   Dcl-pi IAPsr3Con;                                                                        //VM01
      in_string char(5000);                                                                 //VM01
      in_type   char(10);                                                                   //VM01
      in_error  char(10);                                                                   //VM01
      in_xref   char(10);                                                                   //VM01
   // in_srclib char(10);                                                             0062 //VM01
   // in_srcspf char(10);                                                             0062 //VM01
   // in_srcmbr char(10);                                                             0062 //VM01
      in_uWSrcDtl likeds(uWSrcDtl);                                                        //0062
      in_RRN    packed(6:0);                                                                //VM01
      in_RRN_e  packed(6:0);                                                                //VM01
   End-pi;                                                                                  //VM01
                                                                                            //VM01
   Dcl-ds IAVARRELDs extname('IAVARREL') prefix(In_) inz;                                   //VM01
   End-ds;                                                                                  //VM01
                                                                                            //VM01
   Dcl-s In_factor1 char(50)    inz;                                                        //VM01
   Dcl-s In_factor2 char(50)    inz;                                                        //VM01
   Dcl-s In_seq     packed(6:0) inz;                                                        //VM01
   Dcl-s In_Bif     char(10)    inz;                                                        //VM01
   Dcl-s IA_type    char(10)    inz;                                                        //VM01
   Dcl-s IA_length  packed(4:0) inz;                                                        //VM01
   Dcl-s IA_pos     packed(4:0) inz;                                                        //VM01
   Dcl-s IA_field   char(500)   inz;                                                        //VM01
   Dcl-s IA_field1  char(500)   inz;                                                        //VM01
   Dcl-s IA_field2  char(500)   inz;                                                        //VM01
   Dcl-s IA_String char(5000)   inz ;                                                       //VM01
   Dcl-s in_ErrLogFlg char(1)   inz;                                                        //VM01
                                                                                            //VM01
      IA_Type     = %subst(in_string:26:10);                                                //VM01
      If IA_Type  = 'IFEQ' or IA_Type  = 'IFGT' or                                          //VM01
         IA_Type  = 'IFLT' or IA_Type  = 'IFNE' or                                          //VM01
         IA_Type  = 'IFLE' or IA_Type  = 'IFGE' or                                          //RK15
         IA_Type  = 'WHENEQ' or IA_Type  = 'WHENGT' or                                      //RK15
         IA_Type  = 'WHENLT' or IA_Type  = 'WHENNE' or                                      //RK15
         IA_Type  = 'WHENLE' or IA_Type  = 'WHENGE';                                        //RK15
                                                                                            //VM01
        IA_Field1 = %subst(in_string:12:10 ) +                                              //VM01
                       %subst(in_string:36:10 );                                            //VM01
      Else;                                                                                 //VM01
        IA_Field1   = %subst(in_string:36:45 );                                             //VM01
      EndIf;                                                                                //VM01
                                                                                            //VM01
      IA_String= IA_Field1;                                                                 //VM01
      IAPSRCFIX(Ia_string:                                                                  //VM01
                Ia_type:                                                                    //VM01
                in_error:                                                                   //VM01
                in_xref:                                                                    //VM01
            //  in_srclib:                                                                  //VM01
            //  in_srcspf:                                                                  //VM01
            //  in_srcmbr:                                                                  //VM01
                in_uWSrcDtl:                                                                //0062
                in_RRN  :                                                                   //VM01
               in_RRN_e  :                                                                  //VM01
               in_ErrLogFlg);                                                               //VM01
                                                                                            //VM01
       Exec sql                                                                             //VM01
         Update IAVARREL set REOPC  = :IA_Type                                              //VM01
          where RESEQ = 1                                                                   //VM01
            and RERRN = :in_rrn                                                             //VM01
            and   RESRCLIB = :in_srclib                                                     //VM01
            and   RESRCFLN = :in_srcspf                                                     //VM01
            and   REPGMNM  = :in_srcmbr                                                     //VM01
            and   REIFSLOC = :in_ifsloc;                                              //0062//VM01
       If SQLSTATE <> SQL_ALL_OK;                                                           //VM01
            // log error                                                                    //VM01
       endif;                                                                               //VM01
                                                                                            //VM01
  Return;                                                                                   //VM01
End-proc;                                                                                   //VM01

//------------------------------------------------------------------------------------ //
//SqlParser : Will parse all Sql queries in SQLRPGLE Program                           //
//------------------------------------------------------------------------------------ //
Dcl-Proc SqlParser export;                                                               //YG1117
   Dcl-Pi *n;                                                                            //YG1117
      in_Str      char(5000);
      in_xRef     char(10);                                                              //YK02
  //  in_srclib   char(10)      options(*nopass);                                        //0062
  //  in_srcpf    char(10)      options(*nopass);                                        //0062
  //  in_srcmbr   char(10)      options(*nopass);                                        //0062
      in_uWSrcDtl likeds(uWSrcDtl) options(*nopass);                                     //0062
      in_rrns     packed(6:0)   options(*nopass);
      in_rrne     packed(6:0)   options(*nopass);
   End-Pi;                                                                               //YG1117

   Dcl-s in_srcpf    char(10)    ;                                                       //0062
   in_Str = squeezeString(in_Str);
   uwSrcDtl = in_uwSrcDtl;                                                               //0062
   in_srcpf  = in_srcspf  ;                                                              //0062

   Select;
   When %SubSt(in_Str : 1 : 6) = 'SELECT'                                                //0019
        or %SubSt(in_Str : 1 : 7) = 'DECLARE';                                           //0019
      ProcessSelectSQL( in_Str    :
                        // in_srclib :                                                   //0062
                        // in_srcpf  :                                                   //0062
                        // in_srcmbr :                                                   //0062
                        in_uwSrcDtl:
                        in_rrns   :
                        in_rrne );

   When %SubSt(in_Str : 1 : 6) = 'INSERT';
      ProcessInsertSQL( in_Str    :
                     // in_srclib :                                                      //0062
                     // in_srcpf  :                                                      //0062
                     // in_srcmbr :                                                      //0062
                        in_uWSrcDtl:                                                     //0062
                        in_rrns   :
                        in_rrne );

   When %SubSt(in_Str : 1 : 6) = 'UPDATE';
      ProcessUpdateSql( in_Str    :
                     // in_srclib :                                                      //0062
                     // in_srcpf  :                                                      //0062
                     // in_srcmbr :                                                      //0062
                        in_uWSrcDtl:                                                     //0062
                        in_rrns   :
                        in_rrne );

   When %SubSt(in_Str : 1 : 6) = 'DELETE';
      ProcessDeleteSql( in_Str    :
                     // in_srclib :                                                      //0062
                     // in_srcpf  :                                                      //0062
                     // in_srcmbr :                                                      //0062
                        in_uWSrcDtl:                                                     //0062
                        in_rrns   :
                        in_rrne );

   When %SubSt(in_Str : 1 : 6) = 'CREATE';                                               //YK02
      ProcessCreateSql( in_Str    :                                                      //YK02
                        in_xRef   :                                                      //YK02
                        // in_srclib :                                                      //YK02
                        // in_srcpf  :                                                      //YK02
                        // in_srcmbr :                                                      //YK02
                        in_uwSrcDtl);                                                    //0062
   EndSl;
                                                                                         //YG1117
End-Proc;                                                                                //YG1108

//---------------------------------------------------------                              //YG1117
// Parse SQL statement in SQLRPGLE Program                                               //YG1117
//---------------------------------------------------------                              //YG1117
Dcl-Proc GetDelimiterValue export;                                                       //YG1117
   Dcl-Pi *n CHAR(1000) dim(50);                                                         //YG1117
      in_data      char(5000) const;                                                     //YG1117
      in_Delimiter char(1) const;                                                        //YG1117
   End-Pi;                                                                               //YG1117

   dcl-s Result_Arry      char(1000) dim(4999);                                          //SB03
   dcl-s startPos         int(10);
   dcl-s foundPos         int(10)  Inz;
   dcl-s increment        int(10)  inz(1);
   dcl-s index            int(10)  Inz;

   if in_data <> *blanks;
      increment = %len(%trim(in_delimiter));
      startPos = 1;
      index    = 1;
      dou foundPos = %len(in_data) + 1;
         foundPos = %scan(%trim(in_delimiter):in_data:startPos);
         if foundPos = 0;
            foundPos = %len(in_data) + 1;
         endif;

         if startPos > 0 and foundPos > startPos
            and index <= %elem(Result_Arry);
            Result_Arry(index) = %trim(%subst(in_data:startPos:foundPos - startPos));       //KM
         else;
           leave;
         endif;

         index += 1;
         startPos = foundPos + increment;
      enddo;
   endif;

   return Result_Arry;

End-Proc;                                                                                //YG1108

//------------------------------------------------------------------------------------ //
//ProcessINSERTSql                                                                     //
//------------------------------------------------------------------------------------ //
Dcl-proc ProcessINSERTSql Export;
   Dcl-pi ProcessINSERTSql;
      in_Str                 char(5000);
  //  in_srclib              char(10)    options(*nopass);                                //0062
  //  in_srcpf               char(10)    options(*nopass);                                //0062
  //  in_srcmbr              char(10)    options(*nopass);                                //0062
      in_UwSrcDtl Likeds(UwSrcDtl);                                                       //0062
      in_rrns                packed(6:0) options(*nopass);
      in_rrne                packed(6:0) options(*nopass);
   End-pi;

   Dcl-ds File_Value_Ds Qualified Dim(50);                                               //PJ
      File_Val_Arr           Char(120)   dim(999);                                       //PJ
   End-ds;                                                                               //PJ

   dcl-s option              char(10);
   dcl-s mthd                char(1);
   dcl-s DELIMITER           char(1)     inz(',');
   dcl-s File_FieldList      char(1000)  inz;
   dcl-s File_Fld_arr        char(120)   dim(999);
   dcl-s File_Value_arr      char(120)   dim(999);
   dcl-s Temp_File_Value_arr char(120)   dim(999);                                       //ap
   dcl-s Temp_case_Value_arr char(120)   dim(999);                                       //sk
   dcl-s Value_FieldList     char(1000)  inz;
   dcl-s Value_FieldList1    char(1000)  dim(999);                                       //sk
   dcl-s Values_arr          char(120)   dim(999);
   dcl-s Temp_In_Str         char(3000)  inz;                                            //AP
   dcl-s Temp1_In_Str        char(3000)  inz;                                            //AP
   dcl-s IntoLibName         char(10)    inz;                                            //AP
   dcl-s IntofileName        char(21)    inz;                                            //AP
   dcl-s Ds_Name             char(120)   inz;                                            //AP
   dcl-s sq_REROUTIN         char(80)    inz;
   dcl-s sq_RERELTYP         char(10)    inz;
   dcl-s sq_RERELNUM         char(10)    inz;
   dcl-s sq_REOPC            char(10)    inz('SQLEXC');
   dcl-s sq_REBIF            char(10)    inz;
   dcl-s sq_REFACT1          char(80)    inz;
   dcl-s sq_RECOMP           char(10)    inz;
   dcl-s sq_REFACT2          char(80)    inz;
   dcl-s sq_RECONTIN         char(10)    inz;
   dcl-s sq_RERESIND         char(06)    inz;
   dcl-s sq_RECAT1           char(1)     inz;
   dcl-s sq_RECAT2           char(1)     inz;
   dcl-s sq_RECAT3           char(1)     inz;
   dcl-s sql_stmt            char(3000)  inz;
   dcl-s sq_RECAT5           char(1)     inz;
   dcl-s sq_RECAT6           char(1)     inz;
   dcl-s sq_REUTIL           char(10)    inz;
   dcl-s sq_RECAT4           char(1)     inz;
   dcl-s sq_REEXC            char(1)     inz;
   dcl-s sq_REINC            char(1)     inz;
   dcl-s flag                char(1)     inz('N');
   dcl-s string              char(500);                                                  //MT01
   dcl-s tmpstr              char(120);                                                  //MT01
   dcl-s opn_bktpos          packed(4:0) inz;                                             //PJ
   dcl-s exact_rrn           packed(6:0);                                                //MT01
   dcl-s opn_bkt             packed(4:0) dim(50) inz;                                     //PJ
   dcl-s cls_bkt             packed(4:0) dim(50) inz;                                     //PJ
   dcl-s comma               packed(4:0) dim(50) inz;                                     //PJ
   dcl-s tempcomma           packed(4:0) dim(50) ascend inz;                              //SS01
   dcl-s opn_flg             packed(1:0) inz;                                             //PJ
   dcl-s Clo_bkt_Position    packed(4:0) inz;
   dcl-s File_Position       packed(4:0) inz;
   dcl-s In_Position         packed(4:0) inz;
   dcl-s i                   packed(4:0) inz;
   dcl-s Val_OpnbktPos       packed(4:0) inz;
   dcl-s Val_varLength       packed(4:0) inz;
   dcl-s Val_SelectPos       packed(4:0) inz;                                             //AP
   dcl-s Val_Into_Pos        packed(4:0) inz;                                             //AP
   dcl-s Val_From_Pos        packed(4:0) inz;                                             //AP
   dcl-s Space_Pos           packed(4:0) inz;                                             //AP
   dcl-s Pos_Slash1          packed(4:0) inz;                                             //AP
   dcl-s RowCount1           packed(4:0) inz;                                             //AP
   dcl-s l                   packed(4:0) inz(1);                                          //AP
   dcl-s posopnbrk           packed(4:0) inz;                                             //sk
   dcl-s posclsbrk           packed(4:0) inz;                                             //sk
   dcl-s posclsbrk1          packed(4:0) inz;                                             //sk
   dcl-s posopnbrk1          packed(4:0) inz;                                             //sk
   dcl-s temp_count          packed(4:0) inz;                                             //AP
   dcl-s LEN_IN_STR          packed(5:0) inz;                                             //AP
   dcl-s Cls_Bkt1            packed(5:0) inz;
   dcl-s Cls_Bkt2            packed(5:0) inz;
   dcl-s sq_pos              packed(5:0) inz;
   dcl-s sq_RENUM1           packed(5:0) inz;
   dcl-s sq_RENUM2           packed(5:0) inz;
   dcl-s sq_RENUM3           packed(5:0) inz;
   dcl-s sq_RENUM4           packed(5:0) inz;
   dcl-s sq_RENUM5           packed(5:0) inz;
   dcl-s sq_RENUM6           packed(5:0) inz;
   dcl-s sq_RENUM7           packed(5:0) inz;
   dcl-s sq_RENUM8           packed(5:0) inz;
   dcl-s sq_RENUM9           packed(5:0) inz;
   dcl-s pos_commas          packed(5:0) inz;
   dcl-s j                   Zoned(4:0)  inz(1);                                          //PJ
   dcl-s K                   Zoned(4:0)  inz(1);                                          //PJ
   dcl-s m                   Zoned(4:0)  inz(1);                                          //PJ
   dcl-s n                   Zoned(4:0)  inz(1);                                          //PJ
   dcl-s temp_index          Zoned(4:0)  inz(1);                                          //sk
   dcl-s temp_indexf         Zoned(4:0)  inz(1);                                          //sk
   dcl-s index_case          Zoned(4:0)  inz(1);                                          //sk

   Dcl-s ndx             int(5)        inz;
   Dcl-s rdx             int(5)        inz;
   Dcl-s Pos             int(5)        inz;
   Dcl-s CaptureFlg      char(1)      inz;
   Dcl-s tr_Brackets     packed(4:0)  inz;
   Dcl-s tr_length       packed(4:0)  inz;
   Dcl-s string4         char(5000) ;
   Dcl-s string5         char(5000) ;
   Dcl-s string3         char(5000) ;
   Dcl-s CASESTRING      char(500) ;                                                      //sk06
   Dcl-s CASESTRING1     char(500) ;                                                      //sk06
   Dcl-s sub1            char(5000) ;
   Dcl-s fileFieldsInStr char(1);                                                        //YK11
   dcl-s fileNameStr     char(200)    inz;                                               //YK11
   dcl-s libName         char(10)     inz;                                               //YK11
   dcl-s fileExists      char(1)      inz;                                               //YK11
   dcl-s fieldsName      char(10) dim(999) inz;                                          //YK11
   dcl-s fileName     varChar(128)    inz;                                               //YK11
   dcl-s bracketPos      packed(4)    inz;                                               //YK11
   dcl-s spacePos        packed(4)    inz;                                               //YK11
   dcl-s fldCount        packed(4)    inz;                                               //YK11
   Dcl-s tr_Counter      packed(4:0)  inz;
   dcl-s poscomma        packed(4:0);
   Dcl-s In_postion      packed(4:0)  inz;
   Dcl-s OBpos           packed(4:0)  inz;
   dcl-s loop           int(5)      inz;                                               //SS01

   dcl-s Pos1           zoned(4:0);                                                      //0055
   dcl-s source         char(120);                                                       //0055
   dcl-s casepos        zoned(4:0);                                                      //0055
   dcl-s OpCode         char(50);                                                        //0055
   dcl-s in_srcpf       char(10)     inz;                                                //0062
   dcl-s tmpId          Zoned(9:0)   inz;                                                //0062
   dcl-s tmpRRN         packed(6:0)  inz;                                                //0062

   dcl-c sq_quote     '''';                                                              //MT01
   dcl-c sq_dquote    '"';                                                                //KM

   dcl-ds FieldNameDs DIM(999) Qualified;                         //AP Changed dim(10)->dim(999)
      FieldName char(250);                                                               //MT12
   end-ds;

   dcl-ds File_Value_arr1 DIM(999) Qualified;                                            //AP
      DSName char(120);                                                                  //AP
   end-ds;                                                                               //AP

   dcl-ds FileFldList DIM(999) Qualified;                                                //AP
      FieldName char(10);                                                                //AP
   end-ds;                                                                               //AP

   UwSrcDtl    = in_UwSrcDtl ;                                                           //0062
   in_srcpf    = in_srcspf   ;                                                           //0062

   In_Position = %Scan('INTO': In_Str );

        clear fileFieldsInStr;                                                           //YK11
        bracketPos = %Scan( '(' : In_Str : In_Position + 6);                             //YK11
        spacePos = %Scan( ' ' : In_Str : In_Position + 6);                               //YK11

        // Check if File fields are present in insert statement or not                   //YK11
        If bracketPos > 0 and spacePos > 0;                                              //YK11
           // If got bracket after file name                                             //YK11
           If bracketPos < spacePos;                                                     //YK11
              File_Position = %Scan( '(' : In_Str : In_Position + 6);                    //YK11
              fileFieldsInStr = 'Y';                                                     //YK11

           // If got space before bracket then                                           //YK11
           // check if non space position is bracket or not                              //YK11
           ElseIf %check(' ': In_Str: spacePos) = bracketPos;                            //YK11
              File_Position = %Scan( '(' : In_Str : In_Position + 6);                    //YK11
              fileFieldsInStr = 'Y';                                                     //YK11
           Else;                                                                         //YK11
              File_Position = %Scan( ' ' : In_Str : In_Position + 6);                    //YK11
           EndIf;                                                                        //YK11
        Else;                                                                            //YK11
           File_Position = %Scan( ' ' : In_Str : In_Position + 6);                       //YK11
        EndIf;                                                                           //YK11

        // Get file and library name if found                                            //YK11
        if File_Position > 0 and File_Position > In_Position+5;                          //YK11
           fileNameStr = %subst( In_Str: In_Position+5:                                  //YK11
                                  File_Position -(In_Position+5) );                      //YK11
           getFileName(fileNameStr: fileName: libName);                                  //YK11
        endIf;                                                                           //YK11

        if %scan('/': In_Str) = File_position-1
           Or %scan('/': In_Str) = File_position+1;
          File_position = %Scan( ' ' : In_Str : File_Position + 3);
        endif;

        if %scan('.': In_Str) = File_position-1
           Or %scan('.': In_Str) = File_position+1;
          File_position = %Scan( ' ' : In_Str : File_Position + 3);
        endif;

        File_Position += 1;
        if %scan('VALUES':in_str) > 0
           and %scan('(':in_str:%scan('VALUES':in_str)) > 0;
           string4 = %subst(in_str:%scan('(':in_str:%scan('VALUES':in_str)));
           string3 = string4;
           exsr checkcomma;
           m = 1 ;
           n = 1 ;
           if comma(m) <> 0;
           Dow m <= %elem(comma) and comma(m) <> 0;
               If comma(m) > 1 and n <= %elem(Value_FieldList1);
                  Value_FieldList1(n) = %SUBST(%TRIM(string4):1:COMMA(m)-1) ;
               Endif ;
               n = n+1;
               m = m+1;
               If comma(m) > 0  and COMMA(m)-(comma(m-1)+1) > 0
                  and n <= %elem(Value_FieldList1);
                  Value_FieldList1(n)
                  = %SUBST(%TRIM(string4):comma(m-1)+1:COMMA(m)-(comma(m-1)+1));

               Elseif n <= %elem(Value_FieldList1);
                  Value_FieldList1(n) =
               %SUBST(%TRIM(string4):comma(m-1)+1
                :%LEN(%TRIM(string4))-comma(m-1));
               Else;
                  leave;
              Endif ;
           Enddo ;

          else;
             Value_FieldList1(n)=string4;
          endif;
        endif;
   File_Position -= 1;                                                                   //YK11

   dou Value_FieldList1(temp_index)=*blank or temp_index = %elem(Value_FieldList1);
      clear  temp_count ;
      Value_FieldList=Value_FieldList1(temp_index);
      exsr insertsr;
      if Value_FieldList1(temp_index)=*blank or temp_index = %elem(Value_FieldList1);
         leave;
      endif;
     temp_index=temp_index+1;
   enddo;

   If %scan('WHERE': in_str) > 0;                                                        //0046
      OPTION = 'WHERE';
      // WhereHavingProc(in_Str : Option :in_SrcLib :in_SrcPf                            //0062
      //                   :in_SrcMbr : in_RrnS : in_RrnE);                              //0062
      WhereHavingProc(in_Str : Option :in_uwSrcDtl : in_RrnS : in_RrnE);                 //0062
   Endif;                                                                                //0046

   //4. WhereParsing / HavingParsing
   If %scan('HAVING': in_str) > 0;                                                       //0046
      OPTION = 'HAVING';
      // WhereHavingProc(in_Str : Option :in_SrcLib :in_SrcPf                            //0062
      //                   :in_SrcMbr : in_RrnS : in_RrnE);                              //0062
      WhereHavingProc(in_Str : Option :in_uwSrcDtl : in_RrnS : in_RrnE);                 //0062
   Endif;                                                                                //0046

   //5. OrderbyParsing / Groupbyparsing
   If %scan('GROUP BY':in_str) > 0;                                                      //0046
      mthd='1';
   //   GroupByProc(in_Str : Mthd : in_srclib :in_SrcPf                                  //0062
   //                :in_SrcMbr : in_RrnS : in_RrnE);                                    //0062
          GroupByProc(in_Str : Mthd : in_uwSrcDtl : in_RrnS : in_RrnE);                  //0062
   Endif;                                                                                //0046

   //5. OrderbyParsing / Groupbyparsing
   If %scan('ORDER BY':in_str) > 0;                                                      //0046
      mthd='2';
   //   GroupByProc(in_Str : Mthd : in_srclib :in_SrcPf                                  //0062
   //                :in_SrcMbr : in_RrnS : in_RrnE);                                    //0062
          GroupByProc(in_Str : Mthd : in_uwSrcDtl : in_RrnS : in_RrnE);                  //0062
   Endif;                                                                                //0046

 Begsr insertsr;

   If fileFieldsInStr <> 'Y' and File_Position > 0;                                      //YK11

      Val_OpnbktPos = %Scan('VALUES' : In_Str : File_Position );
      Val_OpnbktPos += %Len('VALUES') + 1;

      If Val_OpnbktPos > 7 ;

         File_Value_arr = GetDelimiterValue(Value_FieldList: Delimiter);
         File_Value_DS(k).File_val_arr = File_Value_arr;                                 //AP

         sql_Stmt= 'with cte as (   +
         select coalesce(NAME_TYPE, '' '')   AS NAME_TYPE, +
                coalesce(NAME, '' '' )       AS NAME, +
                coalesce(SCHEMA, '' '' )     AS SCHEMA, +
                coalesce(COLUMN_NAME, '' '') AS COLUMN_NAME +
         from table(QSYS2.PARSE_STATEMENT(''' + %trim(in_str) + ''')) As A ) +
                                                            //KM
         Select WHFLDI  +
         from cte tbl1 , idspffd dspffd , iaobjmap obj   +
         where tbl1.Name_Type = ''TABLE'' +
         //MT12
         and dspffd.whfile = obj.OBJECT_NAME  +
         and dspffd.whfile = tbl1.Name  +
         //MT12
         and ( dspffd.whlib = obj.OBJECT_LIBR     +
         or dspffd.whlib = tbl1.schema )';

         exec sql prepare file_Info from :sql_Stmt;
         exec sql declare FileField_Info cursor for file_Info;
         exec sql open FileField_Info;
         exec sql fetch FileField_Info for 250 rows into :FieldNameDs;                   //MT12
         exec sql Close FileField_Info;

         if FieldNameDs(1) = *blanks;                                                    //YK11
            fldCount = 250;                                                              //YK11
            // Get file fields from IDSPFFD/IAESQLFFD if found                           //YK11
            getFileFieldsIO(fileName: libName: fieldsName: fldCount);                    //YK11
            File_Fld_arr = fieldsName;                                                   //YK11
         else;                                                                           //YK11
            For i = 1 to %elem(values_arr);                                              //YK11
               if FieldNameDs(i).FieldName = *blanks;                                    //YK11
                  leave;                                                                 //YK11
               endIf;                                                                    //YK11
               File_Fld_arr(i) =  FieldNameDs(i).FieldName;                              //YK11
            EndFor;                                                                      //YK11
         endIf;                                                                          //YK11
      Else;
         // Select Statement for insert value                                            //AP
         Val_SelectPos = %Scan('SELECT' : In_Str : 1);                                   //AP
         if Val_SelectPos > 0 and %Len(In_Str) > (Val_SelectPos + 1);
           Temp_In_Str = %Subst(In_Str : Val_SelectPos                                   //AP
                                     : (%Len(In_Str) - (Val_SelectPos + 1)));            //AP
           File_Value_arr = GetFileFields(Temp_In_Str : File_Value_arr                   //AP
                                                    : Arr_index:in_SrcMbr);              //vm001
         endif;

         Val_Into_Pos = %Scan('INTO' : In_Str : 1);                                      //AP
         Space_Pos = %Scan(' ' : In_Str : (Val_Into_Pos + 5));                           //AP
          if %scan('/': In_Str) = Space_Pos -1                                           //SK
             Or %scan('/': In_Str) = Space_Pos+1;                                        //SK
             Space_Pos = %Scan( ' ' : In_Str : Space_Pos +3) ;                           //SK
                                                                                         //SK
          endif;                                                                         //SK

          if %scan('.': In_Str) = Space_Pos-1                                            //SK
             Or %scan('.': In_Str) = Space_Pos+1;                                        //SK
             Space_Pos = %Scan( ' ' : In_Str : Space_Pos + 3);                           //SK
                                                                                         //SK
          endif;                                                                         //SK

         if Space_Pos > (Val_Into_Pos + 5);
           IntoFileName = %Subst(In_Str : (Val_Into_Pos + 5)                             //AP
                                      : (Space_Pos - (Val_Into_Pos + 5)));               //AP
         endif;
         Pos_Slash1 = %Scan('/' : %Trim(IntoFileName));                                  //AP
         If Pos_Slash1 = *Zero;                                                          //AP
            Pos_Slash1 = %Scan('.' : %Trim(IntoFileName));                               //AP
         Endif;                                                                          //AP

         If Pos_Slash1 > 1 and %Len(%Trim(IntoFileName)) > Pos_Slash1;                  //AP
            IntoLibName  = %Subst(%Trim(IntoFileName) : 1 : (Pos_Slash1 - 1));           //AP
            IntoFileName = %Subst(%Trim(IntoFileName) : (Pos_Slash1 + 1)                 //AP
                             :(%Len(%Trim(IntoFileName)) - Pos_Slash1));                 //AP
         Endif;                                                                          //AP
                                                                                         //AP
         Clear RowCount1;                                                                //AP
                                                                                         //AP
         Exec sql                                                                        //AP
           Select Count(*)                                                               //AP
             Into :RowCount1                                                             //AP
             From IDSPFFD                                                                //AP
            Where WHLIB  = Trim(:IntoLibName)                                            //AP
              And WHFILE = Trim(:IntoFileName);                                          //AP
                                                                                         //AP
         If RowCount1 > *Zero;                                                           //YK01
            Exec sql Declare C1_IDSPFFD Cursor for                                       //AP
              Select WHFLDI                                                              //AP
                From IDSPFFD                                                             //AP
               Where WHLIB  = Trim(:IntoLibName)                                         //AP
                 And WHFILE = Trim(:IntoFileName);                                       //AP
            Exec sql Open C1_IDSPFFD;                                                    //AP
            if sqlCode = -502;                                                           //MT21
              exec sql close C1_IDSPFFD;                                                 //MT21
              exec sql open  C1_IDSPFFD;                                                 //MT21
            endif;                                                                       //MT21
            Exec sql Fetch C1_IDSPFFD for :RowCount1 rows into :FileFldList;             //AP
            File_Fld_arr = %Trim(FileFldList);                                           //AP
            Exec sql Close C1_IDSPFFD;                                                   //AP
            File_Value_DS(j).File_val_arr = File_Value_arr;                              //AP
         EndIf;                                                                          //YK01

      EndIf;
   EndIf;

   If fileFieldsInStr = 'Y';                                                             //YK11

      File_Position += 1;               //KM

      Clo_bkt_Position =  %Scan( ')' : In_Str : File_Position );
      Val_OpnbktPos =  %Scan('VALUES' : In_Str : File_Position );
      Val_OpnbktPos += %Len('VALUES')+ 1;

      If ( Clo_bkt_Position < Val_OpnbktPos ) And
         ( Val_OpnbktPos > 7 ) ;
          opn_bkt(j) = %scan('(':in_str:Clo_bkt_Position+1);                              //PJ-Start
         If opn_bkt(j) > 0;
            opn_flg = 1;
            Dow opn_flg > 0;
               If  %SCAN(')' : %TRIM(in_str)) > *Zero;
                  cls_bkt1 = 1;
                  For I = 1 to %Len(%Trim(in_str));
                     cls_bkt2 = %SCAN(')' : %TRIM(in_str) : cls_bkt1);
                     If cls_bkt2 > *Zero;
                        cls_bkt1 = cls_bkt2;
                     Endif;
                     If (cls_bkt2 = *Zero and cls_bkt1 > *Zero) Or
                        (Cls_Bkt1 = %Len(%Trim(in_str)));
                        cls_bkt(j) = cls_bkt1;
                        Leave;
                     Endif;
                     If Cls_Bkt1 < %Len(%Trim(in_str));
                        cls_bkt1 += 1;
                     Endif;
                  Endfor;
               Endif;                                                                     //AP
               Value_FieldList = %SubSt ( In_Str
                                          : opn_bkt(j)+1
                                          : cls_bkt(j)-opn_bkt(j)-1);


               File_Value_DS(j).File_val_arr =
                           GetDelimiterValue(Value_FieldList: Delimiter);

               opn_bkt(j+1) = %scan('(':in_str:cls_bkt(j)+1);
               If opn_bkt(j+1) > 0;
                  opn_flg = 1;
                  Clear Value_FieldList;
                  j+=1;
               Else;
                  opn_flg = 0;
               Endif;
            Enddo;
         Endif;                                                                           //PJ-End

         File_FieldList = %SubSt (  In_Str
                                 : File_Position
                                 : Clo_bkt_Position - File_Position);
      EndIf;

      File_Fld_arr   = GetDelimiterValue(File_FieldList : Delimiter);
      File_Value_arr = GetDelimiterValue(Value_FieldList: Delimiter);

      If (%Scan('VALUES' : In_Str : File_Position) = *zero) And                           //AP
         (%Scan('SELECT' : In_Str : File_Position) > *zero);
         Clear Temp1_In_Str;                                                              //AP
         Val_SelectPos = %Scan('SELECT' : In_Str : 1);
         Val_OpnbktPos = %Scan('(' : In_Str : 1);
         Clo_bkt_Position = %Scan(')' : In_Str : 1);
         Len_In_Str = %Len(%trim(In_Str));

         if Val_SelectPos > 0 and Len_In_Str > Val_SelectPos;
           Temp1_In_Str = %Subst(In_Str : Val_SelectPos                                   //AP
                                         : (Len_In_Str - Val_SelectPos));                 //AP
         endif;

         Clear Val_From_Pos;                                                              //AP
         Clear Space_Pos;                                                                 //AP
         Val_From_Pos = %Scan('FROM' : Temp1_In_Str : 1);                                 //AP
         Val_From_Pos += 5;                                                               //AP
         Space_Pos = %Scan(' ' : Temp1_In_Str : Val_From_Pos);                            //AP
         if Space_Pos > 1;
           Temp1_In_Str = %Subst(Temp1_In_Str : 1 : (Space_Pos - 1));                     //AP
           File_Value_arr = GetFileFields(Temp1_In_Str : File_Value_arr                   //AP
                                                       : Arr_index:in_Srcmbr);            //vm001
           File_Value_DS(j).File_val_arr = File_Value_arr;                                //AP
         endif;
                                                                                          //AP
         Select;
         When Clo_bkt_Position < Val_SelectPos;
            Temp1_In_Str = %Subst(In_Str : (Val_OpnbktPos + 1)
                                 : (Clo_bkt_Position - (Val_OpnbktPos + 1)));
            File_Fld_arr = GetDelimiterValue(Temp1_In_Str: Delimiter);
         When (Val_SelectPos > 0 And Clo_bkt_Position = 0
                                 And Clo_bkt_Position = 0) Or
              (Val_SelectPos > 0 And Clo_bkt_Position > Val_SelectPos);
            Val_Into_Pos = %Scan('INTO' : In_Str : 1);                                    //AP
            Space_Pos = %Scan(' ' : In_Str : (Val_Into_Pos + 5));                         //AP
            if Space_Pos > (Val_Into_Pos + 5);
              IntoFileName = %Subst(In_Str : (Val_Into_Pos + 5)                           //AP
                                         : (Space_Pos - (Val_Into_Pos + 5)));             //AP
            endif;
            Pos_Slash1 = %Scan('/' : %Trim(IntoFileName));                                //AP
            If Pos_Slash1 = *Zero;                                                        //AP
               Pos_Slash1 = %Scan('.' : %Trim(IntoFileName));                             //AP
             Endif;                                                                       //AP
                                                                                          //AP
            If Pos_Slash1 > *Zero;                                                        //AP
               IntoLibName  = %Subst(%Trim(IntoFileName) : 1                              //AP
                                                         : (Pos_Slash1 - 1));
               IntoFileName = %Subst(%Trim(IntoFileName) : (Pos_Slash1 + 1)               //AP
                                :(%Len(%Trim(IntoFileName)) - Pos_Slash1));               //AP
            Endif;                                                                        //AP
                                                                                          //AP
            fileName = IntoFileName;                                                      //YK11
            libName = IntoLibName;                                                        //YK11
            fldCount = 250;                                                               //YK11
            // Get file fields from IDSPFFD/IAESQLFFD if found                            //YK11
            getFileFieldsIO(fileName: libName: fieldsName: fldCount);                     //YK11
            File_Fld_arr = fieldsName;                                                    //YK11
         Other;
         EndSl;

      Endif;                                                                              //AP
   EndIf;

   For k = 1 to j;                                                                       //PJ-Start
      For i = 1 to %elem(File_Value_DS(k).File_val_arr);
         If ( File_fld_arr(i) = *Blanks  or                                              //ap
             File_Value_DS(k).File_val_arr(i) = *Blanks );                               //ap
             Leave;
         EndIf;
         clear sq_pos;
         sq_pos = %scan('(':File_Value_DS(k).File_val_arr(i):1);
         if sq_pos > 0;
            File_Value_DS(k).File_val_arr(i) = RMVbrackets(                              //AP
                            File_Value_DS(k).File_val_arr(i));                           //AP
         endif;

         clear sq_pos;
         sq_pos = %scan('(':File_Value_DS(k).File_val_arr(i):1);
         if sq_pos > 0;
            File_Value_DS(k).File_val_arr(i) =
                    %replace('(': File_Value_DS(k).File_val_arr(i): sq_Pos: 1);
            File_Value_DS(k).File_val_arr(i) =
                                      %Trim(File_Value_DS(k).File_val_arr(i));
         endif;
         posclsbrk=%scan(')':File_Value_DS(k).File_val_arr(i));
         if posclsbrk <> 0;
            sub1=File_Value_DS(k).File_val_arr(i);
            exsr clsbrk;
            File_Value_DS(k).File_val_arr(i) = sub1;
         endif;
         posopnbrk=%scan('(':File_Value_DS(k).File_val_arr(i));
         If posopnbrk<>0;
            sub1=File_Value_DS(k).File_val_arr(i);
            exsr opnbrk;
            File_Value_DS(k).File_val_arr(i) = sub1;
         endif;

         clear sq_pos;                                                                   //KM
         sq_Pos = %scan(sq_dquote:%Trim(File_Value_DS(k).File_val_arr(i)):1);            //KM
         If sq_Pos > 0;                                                                  //KM
            File_Value_DS(k).File_val_arr(i) =                                           //KM
                     'Const(' + %trim(File_Value_DS(k).File_val_arr(i)) + ')';
         EndIf;                                                                          //KM

         clear sq_pos;                                                                   //KM
         sq_Pos =                                                                        //KM
             %check('0123456789.':%trim(File_Value_DS(k).File_val_arr(i)):1);
         If sq_Pos = 0;                                                                  //KM
            File_Value_DS(K).File_Val_arr(i) =                                           //KM
                    'Const(' + %trim(File_Value_DS(k).File_val_arr(i)) + ')';
         endif;                                                                          //PJ-End

         clear sq_pos;                                                                   //KM22
         sq_pos = %scan(':':File_Value_DS(k).File_val_arr(i):1);                         //KM22
         if sq_pos > 0;                                                                  //KM22
            File_Value_DS(k).File_val_arr(i) =                                           //KM22
             %trim(%replace(' ': File_Value_DS(k).File_val_arr(i): sq_Pos: 1));          //KM22
         endif;                                                                          //KM22

         //Once VALUE is tagged as CONST,no need to perform this check,this is for      //0036
         //Dynamic sql                                                                  //0036
         if %Scan('Const(' : File_Value_DS(k).File_val_arr(i) )  =  *Zeros;              //0036
            clear sq_pos;                                                                //KM22
            sq_pos = %scan('.':File_Value_DS(k).File_val_arr(i):1);                      //KM22
            if sq_pos > 0;                                                               //KM22
               File_Value_DS(k).File_val_arr(i) =                                        //KM22
                %Trim(%SubSt((File_Value_DS(k).File_val_arr(i)): sq_Pos+ 1));            //KM22
            Endif;                                                                       //0036
         endif;                                                                          //KM22
         Clear RowCount1;                                                                //AP
         Ds_Name = %Trim(File_Value_DS(k).File_val_arr(i));                              //AP

         posopnbrk=%scan('(':Ds_Name );
         If posopnbrk<>0;
            sub1=ds_name;
            exsr opnbrk;
            Ds_Name = sub1;
         endif;
         posclsbrk=%scan(')':Ds_Name);
         if posclsbrk <> 0;
            sub1=ds_name;
            exsr clsbrk;
            Ds_Name = sub1;
         endif;
                                                                                         //AP
         Exec Sql                                                                        //AP
           Select Count(*)                                                               //AP
             Into :RowCount1                                                             //AP
             From IAPGMDS                                                                //AP
            Where DSNAME = Trim(:Ds_Name);
         If RowCount1 > *Zero;                                                           //AP
            Exec sql Declare C3_IAPGMDS Cursor for                                       //AP
              Select DSFLDNM                                                             //AP
                From IAPGMDS                                                             //AP
               Where DSNAME = Trim(:Ds_Name);                                            //AP
            Exec sql Open C3_IAPGMDS;                                                    //AP
            Exec sql Fetch C3_IAPGMDS for :RowCount1 rows into :File_Value_arr1;         //AP
            Exec sql Close C3_IAPGMDS;                                                   //AP
            Temp_File_Value_arr = File_Value_arr1;
         else;
            Temp_File_Value_arr(1) = File_Value_arr(i);

                                                                                         //0020
               //Once VALUE is tagged as CONST,no need to perform this check,this is for//0036
               //Dynamic sql                                                            //0036
                                                                                         //0020
         Endif;

         For L = 1 to %elem(Temp_File_Value_arr);
            If Temp_File_Value_arr(l) = *Blanks;
               Leave;
            Endif;
            temp_count=temp_count+1;

            Opcode = 'CASE';                                                             //0055
            casepos = %scan(%trim(Opcode) : Temp_File_Value_arr(l));                     //0055
            //Check only valid case keyword                                             //0055
            if casepos > 0;                                                              //0055
               DoW ValidateOpcodeName(Temp_File_Value_arr(l):                            //0055
                                            Opcode: casepos);                            //0055
                  casepos = %scan(%trim(Opcode) : Temp_File_Value_arr(l):                //0055
                                   casepos + %len(%trim(Opcode)) + 1 );                  //0055
               EndDo;                                                                    //0055
            endif ;                                                                      //0055
            IF casepos > 0;                                                              //0055
               CASESTRING = %XLATE(LOWER:UPPER:Temp_File_Value_arr(l));
               IF %SCAN('CONST(':CASESTRING)<>0;
                  CASESTRING = %SCANRPL('CONST(':' ':CASESTRING);
                  CASESTRING = %SCANRPL(')':' ':CASESTRING);
               ENDIF;
               casestring1=ProcessCase(casestring);                                   //SK06
               Temp_CASE_Value_arr=GetDelimiterValue(casestring1: Delimiter);
               For index_case=1 to %elem(Temp_CASE_Value_arr);
                  If Temp_case_Value_arr(index_case) = *Blanks;
                     Leave;
                  Endif;
                  //Check if Field belong to any DS then extract the field only         //0055
                  source = Temp_case_Value_arr(index_case);                              //0055
                  ExSr ExtractDsField;                                                   //0055
                  Temp_case_Value_arr(index_case) =                                      //0055
                      IsVariableOrConst(source);                                         //0055

            tmpstr = Temp_case_Value_arr(index_case);                                    //MT01
                                                                                         //MT01
            string  = 'Select SOURCE_RRN   ' +                                           //MT01
                      'from   IAPGMREF '+                                                //MT01
                      'where LIBRARY_NAME = ' + sq_quote + %trim(in_srclib)              //0002
                      + sq_quote +  ' and  SRC_PF_NAME = ' + sq_quote +                  //0002
                       %trim(In_srcpf) + sq_quote +                                      //0002
                      ' and MEMBER_NAME  = ' +  sq_quote +  %trim(in_srcmbr)             //0002
                      + sq_quote +                                                       //0002
                      ' and SOURCE_RRN between ' + %trim(%char(in_rrns)) +               //0002
                      ' and ' +  %trim(%char(in_rrne)) +                                 //0002
                      ' and  SOURCE_WORD  like ' + sq_quote                              //0002
                      + '%' +  %trim(tmpstr)  + '%' +  sq_quote +                        //0002
                      ' fetch first row only ';                                          //MT01
                                                                                         //MT01
            exec sql PREPARE SqlSt1  FROM :string;                                       //MT01
            exec sql declare rrnC1 cursor for sqlst1;                                    //MT01
            exec sql open rrnC1;                                                         //MT01
            exec sql fetch from rrnC1 into :exact_rrn;                                   //MT01
            exec sql close rrnC1;                                                        //MT01
            if exact_rrn = 0;                                                            //MT01
               exact_rrn = in_rrne;                                                      //MT01
            endif;                                                                       //MT01

            IAVARRELLOG(in_srclib:
                         in_srcpf:
                        in_srcmbr:
                        in_ifsloc:                                                       //0062
                          in_rrns:
                       exact_rrn :                                                       //MT01
                     SQ_REROUTIN :
                     SQ_RERELTYP :
                     SQ_RERELNUM :
                     SQ_REOPC    :
         File_fld_arr(temp_count):
                     SQ_REBIF    :
                     SQ_REFACT1  :
                     SQ_RECOMP   :
           Temp_case_Value_arr(index_case):                                                //SK
                     sq_RECONTIN :
                     sq_RERESIND :
                     sq_RECAT1   :
                     sq_RECAT2   :
                     sq_RECAT3   :
                     sq_RECAT4   :
                     sq_RECAT5   :
                     sq_RECAT6   :
                     sq_REUTIL   :
                     sq_RENUM1   :
                     sq_RENUM2   :
                     sq_RENUM3   :
                     sq_RENUM4   :
                     sq_RENUM5   :
                     sq_RENUM6   :
                     sq_RENUM7   :
                     sq_RENUM8   :
                     sq_RENUM9   :
                     sq_REEXC    :
                     sq_REINC);


              endfor;
              FLAG='Y';
            ELSE;                                                                        //0055
               clear sq_pos;                                                             //0055
               sq_pos = %scan('(':Temp_File_Value_arr(1):1);                             //0055
               if sq_pos > 0;                                                            //0055
                  Temp_File_Value_arr(1) = RMVbrackets(Temp_File_Value_arr(1));          //0055
               endif;                                                                    //0055
               clear sq_pos;                                                             //0055
               sq_pos = %scan('(':Temp_File_Value_arr(1):1);                             //0055
               if sq_pos > 0;                                                            //0055
                  posopnbrk=sq_pos;                                                      //0055
                  sub1=Temp_File_Value_arr(1);                                           //0055
                  exsr opnbrk;                                                           //0055
                 Temp_File_Value_arr(1) = sub1;                                          //0055
                                                                                         //0055
               endif;                                                                    //0055
               IF %SCAN(')':Temp_File_Value_arr(1))<>0;                                  //0055
                   sub1=Temp_File_Value_arr(1);                                          //0055
                   exsr clsbrk;                                                          //0055
                   Temp_File_Value_arr(1) = sub1;                                        //0055
               ENDIF;                                                                    //0055
               clear sq_pos;                                                             //0055
               sq_pos = %scan(':':Temp_File_Value_arr(1):1);                             //0055
               if sq_pos > 0;                                                            //0055
                  Temp_File_Value_arr(1) =                                               //0055
                  %trim(%replace(' ': Temp_File_Value_arr(1): sq_Pos: 1));               //0055
               endif;                                                                    //0055
               source = Temp_File_Value_arr(1);                                          //0055
               ExSr ExtractDsField;                                                      //0055
               Temp_File_Value_arr(1) = source;                                          //0055
            ENDIF;
           If FLAG='Y';
             FLAG='N';
             LEAVE;
           ENDIF;

           tmpstr = Temp_File_Value_arr(l);                                             //MT01

           Exec Sql
                select source_rrn                                                       //0062
                Into  :tmpRRN                                                           //0062
                from   IAPGMREF                                                         //0062
                where  library_name = :in_srclib                                        //0062
                and    src_pf_name  = :in_srcspf                                        //0062
                and    member_name  = :in_srcmbr                                        //0062
                and    ifs_location = :in_ifsloc                                        //0062
                and    SOURCE_WORD  = 'VALUES'                                          //0062
                and    source_rrn between char(:in_rrns)                                //0062
                                  and     char(:in_rrne)                                //0062
                Fetch First Row only  ;

                If SQLCODE <> 0    And                                                  //0062
                   tmpRRN   = 0       ;                                                 //0062
                   tmpRRN   = in_rrns ;                                                 //0062
                EndIf ;                                                                 //0062
                                                                                        //MT01
           string  = 'Select SOURCE_RRN,  IAPGMREF_PK '   +                             //MT01
                     'from   IAPGMREF '+                                                //MT01
                     'where LIBRARY_NAME = ' + sq_quote + %trim(in_srclib)               //0002
                     + sq_quote +  ' and  SRC_PF_NAME = ' + sq_quote +                  //MT01
                      %trim(In_srcpf) + sq_quote +                                      //MT01
                     ' and MEMBER_NAME  = ' +  sq_quote +  %trim(in_srcmbr)             //MT01
                     + sq_quote + ' and  ifs_location = '                                //0002 0062
                     + sq_quote + %trim(in_ifsloc)  + sq_quote  +                        //0062
                     ' and SOURCE_RRN between ' + %trim(%char(tmpRRN))  +                //0002
                     ' and ' +  %trim(%char(in_rrne)) +                                  //0002
                     ' and  SOURCE_WORD  like ' + sq_quote                              //MT01
                     + '%' +  %trim(tmpstr)  + '%' +  sq_quote +                        //MT01
                     ' and IAPGMREF_PK > '+ %Char(tmpId)       +                        //0062
                     ' Order by SOURCE_RRN  ' +                                         //0062
                     ' fetch first row only ';                                          //MT01
                                                                                         //MT01
           exec sql PREPARE SqlSt02  FROM :string;                                       //MT01
           exec sql declare rrnC02 cursor for sqlst02;                                   //MT01
           exec sql open rrnC02;                                                         //MT01
           exec sql fetch from rrnC02 into :exact_rrn, :tmpId ;                          //MT01
           exec sql close rrnC02;                                                        //MT01
           if exact_rrn = 0;                                                             //MT01
              exact_rrn = in_rrne;                                                       //MT01
           endif;                                                                        //MT01

           Temp_File_Value_arr(l) = IsVariableOrConst(Temp_File_Value_arr(l));           //0055
            IAVARRELLOG(in_srclib:
                         in_srcpf:
                        in_srcmbr:
                        in_ifsloc:                                                       //0062
                          in_rrns:
                        Exact_rrn:                                                       //MT01
                     SQ_REROUTIN :
                     SQ_RERELTYP :
                     SQ_RERELNUM :
                     SQ_REOPC    :
         File_fld_arr(temp_count):
                     SQ_REBIF    :
                     SQ_REFACT1  :
                     SQ_RECOMP   :
           Temp_File_Value_arr(l):                                                       //SK
                     sq_RECONTIN :
                     sq_RERESIND :
                     sq_RECAT1   :
                     sq_RECAT2   :
                     sq_RECAT3   :
                     sq_RECAT4   :
                     sq_RECAT5   :
                     sq_RECAT6   :
                     sq_REUTIL   :
                     sq_RENUM1   :
                     sq_RENUM2   :
                     sq_RENUM3   :
                     sq_RENUM4   :
                     sq_RENUM5   :
                     sq_RENUM6   :
                     sq_RENUM7   :
                     sq_RENUM8   :
                     sq_RENUM9   :
                     sq_REEXC    :
                     sq_REINC);
         Endfor;
         clear Temp_File_Value_arr;
      EndFor;
   Endfor;                                                                               //PJ
endsr;
BegSr ExtractDsField;                                                                    //0055
   clear sq_pos;                                                                         //0055
   //Do not perfom any checking if field contains only digits,                          //0055
   //Means field is Numeric Constant                                                    //0055
   sq_Pos = %check('0123456789.':%trim(source):1);                                       //0055
   If sq_Pos <> 0; // If not numeric then only check for '.'                             //0055
      //Skip checking if field is Character Constant.                                   //0055
      If %Subst(source:1:1) <> '"';                                                      //0055
         Pos1 = %Scan('.':source);                                                       //0055
         If  Pos1 <> 0;                                                                  //0055
            source = %Trim(%SubSt (source: Pos1+1 :                                      //0055
                    %Scan(' ' : source: Pos1+1) -1 ));                                   //0055
         Endif;                                                                          //0055
      Endif;                                                                             //0055
   Endif;                                                                                //0055
EndSr;                                                                                   //0055
                                                                                         //0055
   Begsr  checkbr ;
      ndx = 1;
      pos = 1;
      rdx = 1;
      CaptureFlg = 'Y';
      tr_Brackets = 0;
      tr_Length = %len(%trim(string4));
      OBPOS = 0;
      For tr_Counter = OBPos + 1 to tr_Length;
         select;
         when %subst(%trim(string4):tr_Counter:1) = '(';
            In_postion = Tr_counter;
            tr_Brackets += 1;
         when %subst(%trim(string4):tr_Counter:1) = ')';
            In_postion = Tr_counter;
            tr_Brackets -= 1;
         Endsl;
         If In_postion <> 0 and tr_Brackets =  0;
            CaptureFlg  = 'Y';
            Leave;
         Else ;
            CaptureFlg  = 'N';
         Endif;
      Endfor;
   Endsr ;
   Begsr checkcomma;
      clear comma ;
      clear tempcomma ;
      poscomma = 0 ;
      poscomma = %scan(',':%TRIM(string3):1) ;
      if poscomma <> *zero ;
         i = 1 ;
         Dow poscomma <> 0 ;
            string5 = %trim(string3) ;
            Exsr checkbr1  ;
            If captureflg = 'Y' ;
               comma(i) = poscomma ;
               I= I+1 ;                                                                     //0016
            Endif ;
            If poscomma < %len(%trim(string3));                                          //0048
               poscomma = %scan(',':%trim(string3):poscomma+1) ;
            Else;                                                                        //0048
               leave;                                                                    //0048
            Endif;                                                                       //0048
         Enddo ;
       Endif ;
   Endsr ;
   Begsr  checkbr1;
      ndx = 1;
      pos = 1;
      rdx = 1;
      CaptureFlg = 'Y';
      tr_Brackets = 0;
      tr_Length = %len(%trim(string5));
      OBPOS = 0;
      For tr_Counter = OBPos + 1 to tr_Length;
         select;
         when %subst(%trim(string5):tr_Counter:1) = '(';
            In_postion = Tr_counter;
            tr_Brackets += 1;
         when %subst(%trim(string5):tr_Counter:1) = ')';
            In_postion = Tr_counter;
            tr_Brackets -= 1;
         Endsl;
         If poscomma  = Tr_counter and tr_Brackets =  0;
            CaptureFlg  = 'Y';
            Leave;
         Else ;
            CaptureFlg  = 'N';
         Endif;
      Endfor;
   Endsr ;
   begsr opnbrk;
      dow posopnbrk<>0;
         posopnbrk1=posopnbrk;
         posopnbrk=%scan('(':%triml(sub1):posopnbrk+1);
      enddo;
      sub1=%subst(sub1:posopnbrk1+1:%len(%trim(sub1)));
   endsr;

   begsr clsbrk;
      posclsbrk=%scan(')':%trimR(sub1):1);
      sub1=%subst(%TRIM(sub1):1:posclsbrk-1);
   endsr;

End-proc;

Dcl-proc commentsSqlRemoval export;                                                      //MT01
   Dcl-pi commentsSqlRemoval;                                                            //MT01
      in_string   char(5000);                                                            //MT01
   end-pi;                                                                               //MT01
                                                                                         //MT01
   dcl-s cmntPos   packed(4:0);                                                          //MT01
   dcl-s spacePos  packed(4:0);                                                          //MT01
                                                                                         //MT01
   dcl-c sqlCmnt  Const('--');                                                           //MT01
                                                                                         //MT01
   cmntPos = %scan(sqlCmnt : in_String);                                                 //MT01
   spacePos = %scan(' ' : in_String : cmntPos + 1);                                      //MT01
                                                                                         //MT01
   if cmntPos > 0;                                                                       //MT01
      dow cmntPos <> 0;                                                                  //MT01
         in_string = %replace(' ' : in_string :cmntPos                                   //MT01
                                  :(spacePos + 1) - cmntPos);
         cmntPos   = %scan(sqlCmnt : in_String);                                         //MT01
         spacePos  = %scan(' ' : in_String : cmntPos + 1);                               //MT01
      enddo;                                                                             //MT01
   endif;                                                                                //MT01
                                                                                         //MT01
End-proc;                                                                                //MT01

//------------------------------------------------------------------------------------- //
//Procedure Getfilefields: Procedure to fetch the fields from a string that String can
//                         be normal string or from a select query. From select query
//                         it gives the selected fields.
//------------------------------------------------------------------------------------- //
Dcl-proc Getfilefields Export;

   Dcl-pi Getfilefields char(50) dim(250);
      In_str      char(500);
      FIELD_ARRAY char(50)     dim(250);
      Arr_index   packed(4:0)  options(*nopass);
      in_member   char(10)     options(*nopass);
   End-pi;

   Dcl-s flag            char(1) ;
   Dcl-s pgm             char(10) ;
   Dcl-s file            char(10) ;
   dcl-s fileName     varChar(128);
   Dcl-s lib             char(10) ;
   Dcl-s string          char(5000) ;
   Dcl-s string1         char(5000) ;
   Dcl-s string2         char(5000) ;
   Dcl-s string3         char(5000) ;
   Dcl-s string4         char(5000) ;
   Dcl-s string5         char(5000) ;
   Dcl-s stringas        char(500) ;
   Dcl-s fieldNames      char(10)      dim(999);
   Dcl-s fieldarray      char(500)     dim(40) ;
   Dcl-s fieldarray1     char(500)     dim(40) ;
   Dcl-s filearray       char(500)     dim(250) ;
   Dcl-s casearray       char(500)     dim(250) ;
   dcl-s tempfieldarr    char(500)     dim(250) ;
   Dcl-s JoinFileArray   char(500)     dim(250) ;
   Dcl-s In_flag         char(1)      inz;
   Dcl-s SP_constant     char(80)     inz;
   Dcl-s Sp_field        char(5000)   inz;
   Dcl-s In_string1      char(5000)   inz;
   Dcl-s Sp_opcode       char(10)     inz;
   Dcl-s In_bif          char(10)     inz;
   Dcl-s File_Field      char(10)     inz;
   Dcl-s CaptureFlg      char(1)      inz;
   Dcl-s in_str1         char(500);
   Dcl-s Case_Str        Char(500);
   Dcl-s LSK             char(10);
   Dcl-s Have_Keyword    char(1)      inz('N')  ;
   Dcl-s SOURCE          char(500);
   Dcl-s SOURCE1         char(500);
   Dcl-s SOURCE2         char(500);
   Dcl-s SOURCE3         char(500);
   Dcl-s SOURCE5         char(500);
   Dcl-s constvar        char(80);
   Dcl-s SUBST_SRC       char(300);
   Dcl-s One_time        char(1)      inz('N');
   Dcl-s File_Library    char(50);
   Dcl-s File_Name       char(50);
   Dcl-s trflag          char(1);
   Dcl-s TEMP_ARRAY      char(500)    dim(100);
   Dcl-s TEMPARRAY       char(500)    dim(100);
   Dcl-s TempValue       char(500) ;                                                         //0052
   Dcl-s posinto         packed(4:0) ;
   Dcl-s Poscdot         packed(4:0) ;
   Dcl-s posfrom         packed(4:0) ;
   Dcl-s poscomma        packed(4:0);
   Dcl-s poswhen         packed(4:0);
   Dcl-s posas           packed(4:0);
   Dcl-s poselse         packed(4:0);
   Dcl-s posstar         packed(4:0);
   Dcl-s comma           packed(4:0)  dim(40) ;
   Dcl-s Pcomma          packed(4:0)  dim(40) ;
   Dcl-s poswogh         packed(4:0)  dim(40) ;
   Dcl-s tempcwogh       packed(4:0)  dim(40) ascend;
   Dcl-s TEMPcomma       packed(4:0)  dim(40) ascend;
   Dcl-s poSsel          packed(4:0) ;
   Dcl-s poSend          packed(4:0) ;
   Dcl-s poSslash        packed(4:0) ;
   Dcl-s poSspace        packed(4:0) ;
   Dcl-s g               packed(4:0) ;
   Dcl-s h               packed(4:0) ;
   Dcl-s I               packed(4:0) ;
   Dcl-s J               packed(4:0) ;
   Dcl-s k               packed(4:0) ;
   Dcl-s l               packed(4:0) ;
   Dcl-s x               packed(4:0) ;
   Dcl-s y               packed(4:0) ;
   Dcl-s z               packed(4:0) ;
   Dcl-s Fld_Index       packed(4:0) ;        //Some logical Name for array Index       //0047
   Dcl-s In_postion      packed(4:0)  inz;
   Dcl-s In_postion1     packed(4:0)  inz;
   Dcl-s tr_Counter      packed(4:0)  inz;
   Dcl-s tr_length       packed(4:0)  inz;
   Dcl-s tr_open         packed(4:0)  inz;
   Dcl-s tr_close        packed(4:0)  inz;
   Dcl-s tr_Brackets     packed(4:0)  inz;
   Dcl-s Position        packed(4:0)  inz;
   Dcl-s Position1       packed(4:0)  inz;
   Dcl-s OBpos           packed(4:0)  inz;
   Dcl-s fld_ind         packed(4:0)  inz;
   Dcl-s star_pos        packed(5:0);
   Dcl-s Blnk_Pos        packed(5:0);
   Dcl-s Case_Pos        packed(5:0);
   Dcl-s MAIN_SEL        packed(5:0);
   Dcl-s MAIN_FROM       packed(5:0);
   Dcl-s TEMP_SEL        packed(5:0);
   Dcl-s Comma_Pos       packed(5:0);
   Dcl-s S_Comma_Pos     packed(5:0);
   Dcl-s Lst_Comma_pos   packed(5:0);
   Dcl-s SV_Comma_Pos    packed(5:0);
   Dcl-s FROM_POS        packed(5:0);
   Dcl-s Sv_Frm_Pos      packed(5:0);
   Dcl-s SEL_POS         packed(5:0);
   Dcl-s Sv_Sel_POs      packed(5:0);
   Dcl-s count           packed(5:0);
   Dcl-s LAST_FROM       packed(5:0);
   Dcl-s Temp_Pos1       packed(5:0);
   Dcl-s LAST_SEL        packed(5:0);
   Dcl-s TEMP_FROM       packed(5:0);
   Dcl-s As_Pos          packed(5:0);
   Dcl-s avg             packed(5:0);
   Dcl-s Keyword_Pos     packed(5:0);
   Dcl-s Open_Brac       packed(5:0);
   Dcl-s Close_Brac      packed(5:0);
   Dcl-s Sv_Open_Brac    packed(5:0);
   Dcl-s COUNT1          packed(5:0);
   Dcl-s COUNT2          packed(5:0);
   Dcl-s COUNT3          packed(5:0);
   Dcl-s Subst_Loc       packed(5:0);
   Dcl-s Slash_Pos       packed(5:0);
   Dcl-s Source_Len      packed(5:0);
   Dcl-s Eval_Pos        packed(5:0);
   Dcl-s Astrik_Pos      packed(5:0);
   Dcl-s Astrik_Frm_pos  packed(5:0);
   Dcl-s Lib_int_Pos     packed(5:0);
   Dcl-s Host_Loc        packed(5:0);
   Dcl-s Quote_Pos       packed(5:0);
   Dcl-s SV_Quote_Pos    packed(5:0);
   Dcl-s POS_ARRAY       packed(10:0)  dim(100);
   Dcl-s POS_IND         packed(1:0)   inz(1);
   Dcl-s TEMP_IND        packed(1:0);
   Dcl-s Rtn_idx         packed(1:0);
   Dcl-s fldCount        packed(4) inz;
   Dcl-s ndx             int(5)        inz;
   Dcl-s rdx             int(5)        inz;
   Dcl-s Pos             int(5)        inz;
   Dcl-S l_NoStarFlg     ind           inz(*Off);
   Dcl-S FileAlias       char(30)      inz;
   Dcl-S posFileAlias    int(5)        inz;
   Dcl-S posStar1        int(5)        inz;
   Dcl-S FieldStr1       char(5000)    inz;
   Dcl-S FIELDN1         char(80)      inz;
   Dcl-S posDot          packed(4:0)  inz;
   dcl-s loop            int(5)       inz;
   Dcl-s StrPos zoned(3:0) inz(0);                                                       //0025
   Dcl-s StrPipe zoned(3:0) inz(0);                                                      //0025
   Dcl-s LastPipe zoned(3:0) inz(0);                                                     //0025
   Dcl-s StrBrkt zoned(3:0) inz(0);                                                      //0025
   Dcl-s EndBrkt zoned(3:0) inz(0);                                                      //0025
   Dcl-s PosMathOpr zoned(3:0) inz(0);                                                   //0025
   Dcl-s SqlOperCnt zoned(3:0) inz(0);                                                   //0032
   Dcl-s Keyword_Member char(25) ;                                                       //0032
   Dcl-s Keyword_Type char(25) ;                                                         //0032
   Dcl-s SqlFuncArray char(25) dim(500);                                                 //0032
   Dcl-s SqlOperArray char(25) dim(500);                                                 //0032
   Dcl-s SqlCsKyCnt zoned(3:0) inz(0);                                                   //0038
   Dcl-s SqlCsKyArray char(25) dim(500);                                                 //0038
   Dcl-s ExcptnFunct  char(25) ;                                                         //0053
   Dcl-s ExcptnField  char(1) ;                                                          //0053
   Dcl-s SqlFunExaray char(25) dim(500);                                                 //0053
   Dcl-s SqlFldExaray char(1) dim(50);                                                   //0053
   Dcl-s PosCaseKey zoned(3:0) inz(0);                                                   //0038
   dcl-s OpCode          char(50);                                                       //0038
   dcl-s casepos    zoned(4:0);                                                          //0038
   Dcl-c upper         'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
   Dcl-c lower         'abcdefghijklmnopqrstuvwxyz';
   Dcl-c commas        ',,,,';                                                           //0025
   Dcl-c arith         '+-*/';                                                           //0025
   Dcl-c Quote  '''';

   Keyword_Member = 'SQL';                                                               //0032
   Keyword_Type = 'FUNCTION';                                                            //0032
   //Fetch SQL functions from IAKEYWORD file
   SqlFuncArray = GetKeywords(Keyword_Member:                                            //0032
                              Keyword_Type:SqlFuncArray);                                //0032

   Keyword_Type = 'OPERATOR';                                                            //0032
   //Fetch SQL Operators from IAKEYWORD file
   SqlOperArray = GetKeywords(Keyword_Member:                                            //0032
                              Keyword_Type:SqlOperArray);                                //0032
   //Calculate the Operators Count
   SqlOperCnt = %lookup(' ':SqlOperArray) - 1;                                           //0032
                                                                                         //0053
   //Array for the function which has fields as parameter                               //0053
   Keyword_Type = 'FLDEXCPTN';                                                           //0053
   SqlFunExaray = GetKeywords(Keyword_Member:                                            //0053
                              Keyword_Type:SqlFunExaray);                                //0053

   STRING   = %TRIM(IN_STR) ;
   Posinto  = %scan(' INTO ' :%trim(STRING):1) ;                                         //0021
   posstar  = %SCAN('*':%trim(STRING):1);
   posFrom  = %SCAN('FROM' :%trim(STRING):1);

   If (posStar = 0) or
      (posStar > 0 and posFrom < posStar);
      l_NoStarFlg = *On;
   EndIf;

   If  Posinto > 0 ;
      posComma  = %SCAN(',':%SUBST(STRING:1:POSINTO):1) ;
   Else ;
      posComma  = %SCAN(',':%trim(STRING):1);
   Endif  ;

   If posComma > 0 and posComma < posFrom and
      posStar > 0 and posStar < posFrom;
        l_NoStarFlg = *On;
   EndIf;

   Poscdot= %scan('.*':%trim(STRING):1) ;
   If Poscdot <> 0 ;
      l_NoStarFlg = *On;
   Endif ;

   poscomma = posstar ;
   string4  =  %trim(string) ;
   Exsr checkbr ;

   IF %SCAN('*':%trim(STRING):1) > 0 and
       captureflg  = 'Y' and l_NoStarFlg = *Off
       and POSFROM > 0;

      i = 1 ;
      POSFROM    = %SCAN('FROM' :STRING:POSSTAR) ;
      poswogh(i) = %scan('WHERE':%TRIM(STRING):POSFROM) ;
      I = I+1 ;
      poswogh(i) = %scan('ORDER BY':%TRIM(STRING):POSFROM) ;
      I = I+1 ;
      poswogh(i) = %scan('GROUP BY':%TRIM(STRING):POSFROM) ;
      I = I+1 ;
      poswogh(i) = %scan('HAVING':%TRIM(STRING):POSFROM) ;
      I = I+1 ;
      poswogh(i) = %scan('FETCH':%TRIM(STRING):POSFROM) ;

      Sorta  %subarr(comma:1:i) ;
      TEMPCWOGH = poswogh ;
      CLEAR poswogh ;
      I = 1 ;
      J = 1 ;
      loop = %LOOKUPGT(*ZEROS:TEMPCWOGH);

      If Loop <> *Zeros;
       FOR  I = Loop TO %ELEM(TEMPCWOGH);
         If TEMPCWOGH(I) <> 0 ;
            poswogh(J) = TEMPCWOGH(I) ;
            J = J+1 ;
         Endif ;
       Endfor ;
      Endif ;

      I =1 ;
      If poswogh(i) > 0 ;
         If (poswogh(i) - (posfrom+4)) > 0;
            STRING2 =
                %SUBST(%TRIM(string):posfrom+4:poswogh(i)-(posfrom+4));
         Endif;
      Else ;
         If ((%len(%trim(string))) - (posfrom+3)) > 0;
            STRING2 = %SUBST(%TRIM(string):posfrom+4:
                               %len(%trim(string))-(posfrom+3));
         Endif;
      Endif ;

      string3 = string2 ;
      Exsr checkcomma ;
      j = 1 ;
      i = 1 ;
      If comma(i) =  0   ;
         If (%len(%trim(string2))) > 0;
            Filearray(j) = %SUBST(%TRIM(STRING2):1:%len(%trim(string2)));
         Endif;
      Endif  ;
      Dow comma(i) <> 0   ;
         If comma(I) <>  0  and I = 1 ;
            If (COMMA(i) - 1) > 0;
               filearray(j) = %SUBST(%TRIM(STRING2):1:COMMA(i)-1 );
            Endif;
         Endif ;
         J =J+1  ;
         I= I+1 ;
         If  comma(i) <> 0   ;
            If (COMMA(i) - comma(I-1)) > 0;
               filearray(i)
                     = %SUBST(%TRIM(STRING2):comma(I-1)+1:COMMA(i)-comma(I-1));
            Endif;
         Else ;
            If ((%LEN(%TRIM(STRING2))) - comma(I-1)) > 0;
               filearray(i) =
               %SUBST(%TRIM(STRING2):comma(I-1)+1:%LEN(%TRIM(STRING2))-comma(I-1));
            Endif;
         Endif ;
      Enddo ;
      clear fieldarray ;
      I = 1 ;
      Fld_ind  = 0 ;
      For i =1 to %elem(filearray) ;
         if filearray(i) <> *blanks ;
            posslash = %scan('/':%trim(filearray(i)):1);
            If PosSlash  = *Zero;
               PosSlash  = %Scan('.' : %Trim(filearray(i)));
            Endif;

            If posslash > 1 and ((%len(%trim(filearray(i)))) - (posslash)) > 0;
               Lib = %subst(%trim(filearray(I)):1:posslash-1);
               file =%subst(%trim(filearray(I)):posslash+1:
                                  %len(%trim(filearray(i)))-(posslash));
            Else ;
               file =%trim(filearray(i));
            Endif ;

            posspace = %scan(' ':%trim(file):1);
            if posspace > 1;
               file = %subst(%trim(file): 1 : posspace -1);
            endif;

            fldCount = 250;
            fileName = file;
            // Get file fields from IDSPFFD/IAESQLFFD if found
            getFileFieldsIO(fileName: lib: fieldNames: fldCount);
            FieldArray = fieldNames;
         Else ;
            leave ;
         Endif ;
      Endfor;
   Else  ;
      posfrom = %scan('FROM':%trim(string):1);
      If POSINTO = 0 and posfrom > 1 ;
         STRING1 = %SUBST(%TRIM(STRING):1:POSFROM-1) ;

      //Merged the 2 Diff Elseif Condition as same operation is happenning
      //in both the conditions
      Elseif posfrom >= 0 and posinto > 1;                                               //0023
         STRING1 = %SUBST(%TRIM(STRING):1:POSINTO-1) ;
      Else;
         STRING1 = %TRIM(STRING);
      Endif ;

      string3 = string1 ;
      Exsr checkcomma ;
      Fld_Index = 1 ; // Using Fld_Index instead of J                                    //0047
      i = 1 ;
      possel = %scan('SELECT' :%TRIM(STRING1) :1) ;
      If comma(i) =  0   ;

         If ((%len(%trim(string1))) - (possel+5)) > 0;
            stringas      =
                %SUBST(%TRIM(STRING1):POSSEL+6:%len(%trim(string1))-(possel+5));
         Endif;

         Posas = %scan(' AS ' : %TRIM(STRINGAS):1) ;
         If POSAS > 1;
            Fieldarray(Fld_Index)= %SUBST(%TRIM(STRINGAS):1:POSAS-1) ;                   //0047
         else ;
            Fieldarray(Fld_Index)  = stringas ;                                          //0047
         Endif  ;
      Endif  ;

      Dow comma(i) <> 0   ;

         If comma(I) <>  0    and I = 1 ;
            If (COMMA(i) - (POSSEL+6)) > 0;
               STRINGAS = %SUBST(%TRIM(STRING1):POSSEL+6:COMMA(i)-(POSSEL+6));
            Endif;
            Posas = %scan(' AS ' : %TRIM(STRINGAS):1) ;
            If POSAS > 1;
               Fieldarray(Fld_Index)= %SUBST(%TRIM(STRINGAS):1:POSAS-1) ;                 //0047
            else ;
               Fieldarray(Fld_Index)  = stringas ;                                        //0047
            Endif  ;
         Endif ;

         Fld_Index += 1;                                                                  //0047
         I= I+1 ;
         If comma(i) <> 0   ;
            If (COMMA(i) - (comma(I-1))) >= 0;
               STRINGAS
               = %SUBST(%TRIM(STRING1):comma(I-1)+1:COMMA(i)-(comma(I-1)+1));
            Endif;
            Posas = %scan(' AS ' : %TRIM(STRINGAS):1) ;
            If POSAS > 1;
               Fieldarray(Fld_Index)= %SUBST(%TRIM(STRINGAS):1:POSAS-1) ;                 //0047
            else ;
               Fieldarray(Fld_Index)  = stringas ;                                        //0047
            Endif  ;
         Else ;
            If ((%LEN(%TRIM(STRING1))) - comma(I-1)) > 0;
               STRINGAS = %SUBST(%TRIM(STRING1):
                           comma(I-1)+1:%LEN(%TRIM(STRING1))-comma(I-1));
            Endif;
            Posas = %scan(' AS ' : %TRIM(STRINGAS):1) ;
            If POSAS > 1;
               Fieldarray(Fld_Index)= %SUBST(%TRIM(STRINGAS):1:POSAS-1) ;                 //0047
            else ;
               Fieldarray(Fld_Index)  = stringas ;                                        //0047
            Endif  ;

         Endif ;

      Enddo ;

      Exsr checksel ;
      Exsr Filter_Array ;
      Exsr filterfield  ;
      Exsr filterAlias  ;

   Endif;

   Field_array = fiELdarray ;
   arr_index = z-1 ;

   return Field_array  ;

   //---------------------------------------------------------------------------------- //
   //SR Checkbr: Check bracket
   //---------------------------------------------------------------------------------- //
   Begsr  checkbr ;
      ndx = 1;
      pos = 1;
      rdx = 1;
      CaptureFlg = 'Y';
      tr_Brackets = 0;
      tr_Length = %len(%trim(string4));
      OBPOS = 0;

      For tr_Counter = OBPos + 1 to tr_Length;

         select;
         when %subst(%trim(string4):tr_Counter:1) = '(';
            In_postion = Tr_counter;
            tr_Brackets += 1;
         when %subst(%trim(string4):tr_Counter:1) = ')';
            In_postion = Tr_counter;
            tr_Brackets -= 1;
         Endsl;

         If poscomma  = Tr_counter and tr_Brackets =  0;
            CaptureFlg  = 'Y';
            Leave;
         Else ;
            CaptureFlg  = 'N';
         Endif;

      Endfor;

   Endsr ;

   //---------------------------------------------------------------------------------- //
   //SR Checkcomma: Check commas.
   //---------------------------------------------------------------------------------- //
   Begsr checkcomma;
      clear comma ;
      clear tempcomma ;
      poscomma = 0 ;
      poscomma = %scan(',':string3:1) ;

      if poscomma > *zero ;

         i = 1 ;
         Dow poscomma <> 0 ;
            string4 = %trim(string3) ;
            Exsr checkbr   ;
            If captureflg = 'Y' ;
               comma(i) = poscomma ;
               I= I+1 ;                                                                  //0016
            Endif ;
            If poscomma < %len(%trim(string3));                                          //0048
               poscomma = %scan(',':string3:poscomma+1) ;
            Else;                                                                        //0048
              leave;                                                                     //0048
            Endif;                                                                       //0048
         Enddo ;

       Endif ;

   Endsr ;

   //---------------------------------------------------------------------------------- //
   //SR Checksel: Check SELECT clause.
   //---------------------------------------------------------------------------------- //
   Begsr checksel ;
      I = 1  ;
    //No need to run the loop till %elem(fieldarray) as we filled this till Fld_Index    //0047
    //So run the loop Fld_Index times only                                               //0047
      For i=1 to Fld_Index ;                                                              //0047
         If fieldarray(i) = *blanks ;                                                     //0047
            Iter ;                                                                        //0047
         Endif;                                                                           //0047
            possel = 0 ;
            POSFROM = 0 ;
            possel = %scan('SELECT' :%trim(FIELDARRAY(I)):1) ;
            IF POSSEL > 0 ;
               POSFROM = %SCAN('FROM':%trim(FIELDARRAY(I)):possel) ;
               If possel > 0  and posfrom > 0 ;
                  If (posfrom - (possel+6)) > 0;
                     FIELDARRAY(I) =
                     %subst(%trim(FIELDARRAY(I)):possel+6:posfrom-(possel+6));
                  Endif;
               Else ;
                //Commented the line as it is useless                                       //0047
               Endif ;
            Endif ;
      Endfor ;
   Endsr ;

   //---------------------------------------------------------------------------------- //
   //SR Starfield: If all field selected in SELSCT clause
   //---------------------------------------------------------------------------------- //
   Begsr starfield ;
      If file  <> *blanks and lib <> *blanks ;
         Exec Sql
         Declare C1 Cursor for (Select WHFLDI  from IDSPFFD
                                where WHLIB = trim(:Lib)
                                and   WHFILE = trim(:file));

         Exec Sql Open C1;

         Exec Sql Fetch Next from C1 into :File_Field;

         Dow SqlCode  = 0;
            Fld_ind += 1;
            FieldArray(Fld_ind) = File_Field;
            Exec Sql Fetch Next from C1 into :File_Field;
         Enddo;
         Exec Sql  Close C1;

      Else ;
         Exec Sql
         Declare C2 Cursor for (Select WHFLDI  from IDSPFFD
                                where WHLIB in (select
                                      IAOBJLIB from IAOBJMAP
                                where IAOBJNAM = trim(:File)
                                 and  IAOBJTYP = '*FILE'
                                 and  IAMBRNAM <> ' '
                                 fetch first row only)
                                 and   WHFILE = trim(:file));
         Exec Sql  Open C2;

         Exec Sql Fetch Next from C2 into :File_Field;

         Dow SqlCode  = 0;
             Fld_ind += 1;
             FieldArray(Fld_ind) = File_Field;
             Exec Sql Fetch Next from C2 into :File_Field;
         Enddo;
         Exec Sql  Close C2;
      Endif ;
      Z = Fld_ind+1 ;
   Endsr ;

   //---------------------------------------------------------------------------------- //
   //SR Filter_Array:
   //---------------------------------------------------------------------------------- //
   Begsr Filter_Array;

    //No need to run the loop till %elem(fieldarray) as we filled this till Fld_Index    //0047
    //So run the loop Fld_Index times only                                               //0047
      For Count = 1 to Fld_Index ;                                                        //0047

         If Fieldarray(Count) = *Blanks;
            Iter;                                                                         //0047
         Endif;

         Opcode = 'CASE';                                                                 //0038
         //Changed the scan operation as Fieldarray array starts with 'CASE' only
         casepos = %scan(%trim(Opcode) : %trim(Fieldarray(Count)));                       //0038
         //Check only valid case keyword
         If casepos > 0;                                                                  //0038
            DoW ValidateOpcodeName(%trim(Fieldarray(Count)) :                             //0038
                                   Opcode : casepos);                                     //0038
               casepos = %scan(%trim(Opcode):%trim(Fieldarray(Count)):                    //0038
                                casepos + %len(%trim(Opcode)) + 1 );                      //0038
               if casepos = 0 ;                                                           //0051
                  Leave ;                                                                 //0051
               endif ;                                                                    //0051
            EndDo;                                                                        //0038
         Endif;                                                                           //0038

         If casepos > 0;                                                                  //0038
            Fieldarray(Count) = processcase(Fieldarray(Count));                           //0038
         Else;                                                                            //0038
            Source = *Blanks;                                                             //0038
            Source2= *Blanks;                                                             //0038
            Source =  %trim(Fieldarray(Count));                                           //0038
            Exsr extfldsr ;                                                               //0038
            Fieldarray(Count) = %trim(Source2);                                           //0038
         Endif;                                                                           //0038

      Endfor;

   Endsr;
                                                                                         //0025
   //---------------------------------------------------------------------------------- //
   //SR AddBrkt: Add a bracket
   //---------------------------------------------------------------------------------- //
   BegSr AddBrkt;                                                                        //0025
                                                                                         //0025
      StrPos = 1;                                                                        //0025
      StrPipe = 1;                                                                       //0025
      dow StrPipe <> 0;                                                                  //0025
                                                                                         //0025
         //Saving last pipe position
         LastPipe = StrPipe;                                                             //0025
                                                                                         //0025
         StrPipe  = %scan('||':Source:StrPos);                                           //0025
         StrBrkt  = %scan('(':Source:StrPos);                                            //0025
         EndBrkt  = %scan(')':Source:StrPos);                                            //0025
                                                                                         //0025
         //If no more '||' and brackets found
         If StrPipe = 0 and StrBrkt = 0 and EndBrkt = 0                                  //0025
            and LastPipe <> 0 and StrPos > 1                                             //0025
            and %len(%trimr(Source))-StrPos+1  > 0;                                      //0025

            Source = %subst(Source:1:StrPos-1)+'(' +                                     //0025
                     %subst(Source:StrPos:%len(%trimr(Source))-StrPos+1) +')';           //0025

         endif;                                                                          //0025

         //If '||' found
         if StrPipe <> 0;                                                                //0025
                                                                                         //0025
            //If Open and Close Brackets are present after '||' <||--(--)>
            //then enclose the before '||' value in brackets
            if StrBrkt > StrPipe and EndBrkt > StrPipe;                                  //0025

               if StrPos = 1 and StrPipe > 1;                                            //0025
                  Source = '('+ %subst(Source:StrPos:StrPipe-1)+')' +                    //0025
                            %subst(Source:StrPipe);                                      //0025

               elseif StrPos > 1 and StrPipe > StrPos;                                   //0025
                  Source = %subst(Source:1:StrPos-1)+'('+                                //0025
                           %subst(Source:StrPos:StrPipe-StrPos)+')' +                    //0025
                           %subst(Source:StrPipe);                                       //0025
               endif;                                                                    //0025

               StrPos = StrPipe + 4;                                                     //0025

            endif;                                                                       //0025

            //If '||' lies between open bracket and close brackets <(--||--)>
            //enclose left and right side value of '||' in brackets
            if StrBrkt < StrPipe and EndBrkt > StrPipe                                   //0025
               and StrBrkt > 0 and StrPipe > StrBrkt+1;                                  //0025

               Source = %subst(Source:1:StrBrkt)+'('+                                    //0025
                        %subst(Source:StrBrkt+1:StrPipe-StrBrkt-1)+ ')' +                //0025
                        %subst(Source:StrPipe);                                          //0025

               EndBrkt += 2;                                                             //0025
               StrPos = StrPipe + 4;                                                     //0025
               StrPipe= %scan('||':Source:StrPos:EndBrkt-StrPos);                        //0025

               if StrPipe = 0 and StrPos > 1 and EndBrkt > StrPos                        //0025
                  and EndBrkt > 0;                                                       //0025

                  Source = %subst(Source:1:StrPos-1)+'('+                                //0025
                           %subst(Source:StrPos:EndBrkt-StrPos)+ ')' +                   //0025
                           %subst(Source:EndBrkt);                                       //0025
                  StrPos = EndBrkt + 3;                                                  //0025

               endif;                                                                    //0025

            endif;                                                                       //0025

            //If '||' lies b/w close bracket and open bracket <)--||--(>
            //enclose the values till close bracket in brackets
            if StrBrkt > StrPipe and EndBrkt < StrPipe                                   //0025
               and StrPos > 1 and EndBrkt > 0                                            //0025
               and EndBrkt > StrPos;                                                     //0025

               Source = %subst(Source:1:StrPos-1)+'('+                                   //0025
                        %subst(Source:StrPos:EndBrkt-StrPos)+ ')' +                      //0025
                        %subst(Source:EndBrkt);                                          //0025
               StrPos = StrPipe + 4;                                                     //0025

            endif;                                                                       //0025

            //If Open and Close Brackets are present before '||' <(--)--||>
            //then enclose the before '||' value in brackets
            if StrBrkt < StrPipe and EndBrkt < StrPipe;                                  //0025

               if StrBrkt = 0 and EndBrkt = 0;                                           //0025

                  if StrPos = 1 and StrPipe > 1;                                         //0025
                     Source = '('+ %subst(Source:StrPos:StrPipe-1)+')' +                 //0025
                               %subst(Source:StrPipe);                                   //0025

                  elseif StrPos > 1 and StrPipe > 0                                      //0025
                         and StrPipe > StrPos;
                     Source = %subst(Source:1:StrPos-1)+'('+                             //0025
                              %subst(Source:StrPos:StrPipe-StrPos)+')' +                 //0025
                              %subst(Source:StrPipe);                                    //0025
                  endif;                                                                 //0025

                  StrPos = StrPipe + 4;                                                  //0025

               else;                                                                     //0025

                  StrPos = StrPipe + 2;                                                  //0025

               endif;                                                                    //0025

            endif;                                                                       //0025
                                                                                         //0025
      endif;                                                                             //0025
                                                                                         //0025
   enddo;                                                                                //0025
   Source2= Source;                                                                      //0025

   EndSr;                                                                                //0025
                                                                                         //0025
   //---------------------------------------------------------------------------------- //
   //SR RmvMathOper: Remove arthimatic operators
   //---------------------------------------------------------------------------------- //
   BegSr RmvMathOper;                                                                    //0025

      PosMathOpr = 1;                                                                    //0025
      dow PosMathOpr <> 0;                                                               //0025

         //Replace the ** to comma
         PosMathOpr = %Scan('**' : Source);                                              //0025
         if PosMathOpr <> 0;                                                             //0025
            Source = %Replace(', ': Source : PosMathOpr : 2);                            //0025
         endif;                                                                          //0025

      enddo;                                                                             //0025

      //Replace Arithmatic operators to comma
      Source2 = %xlate(arith:commas:Source);                                             //0025

   EndSr;                                                                                //0025

   //---------------------------------------------------------------------------------- //
   //SR Extfldsr:
   //---------------------------------------------------------------------------------- //
   Begsr  Extfldsr;

      For i=1 to SqlOperCnt;                                                             //0032
         Source = %xlate(%trim(SqlOperArray(i)):commas:Source);                          //0032
      Endfor;                                                                            //0032
      Source2 = Source;                                                                  //0032

   Endsr ;

   Begsr checkcase ;
      Keyword_Member = 'SQL';                                                            //0038
      Keyword_Type = 'CASKEYWORD';                                                       //0038

      //Fetch SQL functions from IAKEYWORD file
      SqlCsKyArray = GetKeywords(Keyword_Member:                                         //0038
                                 Keyword_Type:SqlCsKyArray);                             //0038
      //Calculate functions count
      SqlCsKyCnt = %lookup(' ':SqlCsKyArray) - 1;                                        //0038
                                                                                         //0038
      poswhen = %scan(' WHEN ':%TRIM(SOURCE):1) ;
      poselse = %scan(' ELSE ':%TRIM(SOURCE):1) ;
      posend  = %scan(' END' :%TRIM(SOURCE):1) ;
                                                                                             //SB04
      If ((POSEND) - (POSwhen+5)) > 0;                                                       //SB04
         SOURCE2 = %SUBST(%TRIM(SOURCE):POSWHEN+5:(POSEND)-(POSwhen+5));
      Endif;                                                                                 //SB04
                                                                                             //SB04
      If SOURCE2 = *Blanks;                                                              //0038
         Clear Source3;                                                                  //0038
         LeaveSr;                                                                        //0038
      Endif;                                                                             //0038

      //Introduced logic to replace case keywords to comma
      For Count3 = 1 to SqlCsKyCnt;                                                      //0038

         if %len(%trim(SqlCsKyArray(Count3))) = 1;                                       //0038

            Source2 = %xlate(%trim(SqlCsKyArray(Count3)):commas:Source2);                //0038

         else;                                                                           //0038

            PosCaseKey = 1;                                                              //0038
            Dow PosCaseKey <> 0;                                                         //0038
               PosCaseKey = %scan(%trim(SqlCsKyArray(Count3)):                           //0038
                            Source2);                                                    //0038
               If PosCaseKey <> 0;                                                       //0038
                  Source2 = %Replace(',' :Source2:                                       //0038
                            (%Scan(%trim(SqlCsKyArray(Count3)) : Source2)):              //0038
                            %len(%trim(SqlCsKyArray(Count3))));                          //0038
               Endif;                                                                    //0038
            Enddo;                                                                       //0038

         Endif;                                                                          //0038

      EndFor;                                                                            //0038

      string3 = source2 ;
      Exsr checkcomma ;
      j = 1 ;
      i = 1 ;
      Dow comma(i) > 0   ;
         If comma(I) > 1 and I = 1 ;                                                         //SB04
            casearray(j) = %SUBST(%TRIM(source2):1:COMMA(i)-1) ;
         Endif ;
         J =J+1  ;
         I= I+1 ;
         If comma(i) <> 0   ;
            If (COMMA(i) - (comma(I-1))) >= 0;                                               //SB04
               casearray(j)
               = %SUBST(%TRIM(source2):comma(I-1)+1:COMMA(i)-(comma(I-1)+1));
            Endif;
         Else ;
            If ((%LEN(%TRIM(source2))) - (comma(I-1))) > 0;                                  //SB04
               casearray(j) = %SUBST(%TRIM(source2):comma(I-1)+1:                            //SB04
                              %LEN(%TRIM(source2))-comma(I-1));                              //SB04
            Endif;                                                                           //SB04
         Endif ;
      Enddo ;
      Flag = 'Y' ;
      I = 1 ;
      //Using J instead of %ELEM(CASEARRAY) as we filled the array till J only
      For I = 1 TO J ;                                                                   //0038
         IF %TRIM(CASEARRAY(I) ) <> *BLANKS ;
            If flag = 'Y' ;
               flag = 'N' ;
               source3 = %trim(CASEARRAY(I));
            Else ;
               source3 = %trim(source3)+',' + %trim(CASEARRAY(I)) ;
            Endif ;
         Endif ;
      Endfor;
   Endsr ;

   //---------------------------------------------------------------------------------- //
   //SR filterfield: Validate the fields and skip if invalid
   //---------------------------------------------------------------------------------- //
   Begsr filterfield ;
      clear ExcptnFunct;                                                                 //0053
      clear ExcptnField;                                                                 //0053
      z = 1 ;
    //No need to run the loop till %elem(fieldarray) as we filled this till Fld_Index    //0047
    //So run the loop Fld_Index times only                                               //0047
      For z = 1 to Fld_Index ;                                                            //0047
         If fieldarray(z) = *blanks ;
            Iter ;                                                                        //0047
         Else ;
            clear temparray;  //Clear the temp array to make all index blank            //0027
            clear source2 ;
            source2 = fieldarray(z) ;
            string3 = source2 ;
            If %scan(',':string3:1) <> 0 ;
               Exsr checkcomma ;
               x = 1 ;
               y = 1 ;
               Dow comma(x) <> 0   ;
                  clear TempValue ;                                                          //0052
                                                                                             //0052
                  //If Field / Value is getting repeated in any select Expression           //0052
                  //Then write it only once in array to avoid duplicate entry               //0052
                  //in IAVARREL file for same RRN                                           //0052
                  If comma(x) > 1 and x = 1 ;                                                //SB04
                  // temparray(y) = %SUBST(%TRIM(source2):1:COMMA(x)-1) ;                    //0052
                     TempValue = %SUBST(%TRIM(source2):1:COMMA(x)-1) ;                       //0052
                     If %LOOKUP(%trim(TempValue):temparray) = 0;                             //0052
                        temparray(y) = %trim(TempValue) ;                                    //0052
                     Endif;                                                                  //0052
                  Endif ;
                //y =y+1  ;                                                                  //0052
                  x= x+1 ;
                  If comma(x) <> 0   ;
                     If (COMMA(x) - (comma(x-1))) >= 0;                                      //SB04
                     // temparray(y)   = %SUBST(%TRIM(source2):                              //0052
                     //            comma(x-1)+1:COMMA(x)-(comma(x-1)+1));                    //0052
                        TempValue = %SUBST(%TRIM(source2):                                   //0052
                                   comma(x-1)+1:COMMA(x)-(comma(x-1)+1));                    //0052
                        If %LOOKUP(%trim(TempValue):temparray) = 0;                          //0052
                           y += 1  ;                                                         //0052
                           temparray(y) = %trim(TempValue) ;                                 //0052
                        Endif;                                                               //0052
                     Endif;                                                                  //SB04
                  Else ;
                     If ((%LEN(%TRIM(source2))) - (comma(x-1))) > 0;                         //SB04
                     // temparray(y) =  %SUBST(%TRIM(source2):comma(x-1)+1                   //0052
                     //              :%LEN(%TRIM(source2))-(comma(x-1)));                    //0052
                        TempValue = %SUBST(%TRIM(source2):comma(x-1)+1                       //0052
                                     :%LEN(%TRIM(source2))-(comma(x-1)));                    //0052
                        If %LOOKUP(%trim(TempValue):temparray) = 0;                          //0052
                           y += 1  ;                                                         //0052
                           temparray(y) = %trim(TempValue) ;                                 //0052
                        Endif;                                                               //0052
                     Endif;                                                                  //SB04
                  Endif ;
               Enddo ;
               I = 1 ;
               For I = 1 TO Y ; //Use the array till where it was filled                //0032

                  If %TRIM(temparray(I) ) =  *BLANKS ;
                     iter;      //Lookup next index as there may be blanks in between   //0032
                  Else ;
                     //If First character is digit then skip the field
                     If %scan(%subst(%trim(temparray(I)):1:1)                            //0032
                                  :'1234567890':1) <> 0;                                 //0032
                        temparray(i) = *blanks ;                                         //0032
                        iter;                                                            //0032
                     Endif ;                                                             //0032

                     //Check if field is maintained in exception list                   //0053
                     If %LOOKUP(%trim(temparray(i)):SqlFunExaray) > 0;                   //0053
                        ExcptnFunct = %trim(temparray(i));                               //0053
                        SqlFldExaray = GetExceptionField(Keyword_Member:                 //0053
                                       Keyword_Type:ExcptnFunct:                         //0053
                                       SqlFunExaray);                                    //0053
                     Endif ;                                                             //0053
                                                                                         //0053
                     If ExcptnFunct <> *Blanks and                                       //0053
                        %LOOKUP(%trim(temparray(i)):SqlFldExaray) > 0;                   //0053
                        temparray(i) = *blanks ;                                         //0053
                        iter;                                                            //0053
                     Endif;                                                              //0053
                                                                                         //0053
                     //Skip, if maintained in IAKEYWORD file
                     If %LOOKUP(%trim(temparray(i)):SqlFuncArray) > 0;                   //0032
                        temparray(i) = *blanks ;                                         //0032
                        iter;                                                            //0032
                     Endif ;                                                             //0032

                  Endif ;

               Endfor;
               Flag = 'Y' ;
               I = 1 ;
               For I = 1 TO Y ; // Use the array till where it was filled                //0032
                  If %TRIM(temparray(I) ) <> *BLANKS ;
                     If flag = 'Y' ;
                        flag = 'N' ;
                        source2 = %trim(tempARRAY(I));
                     else ;
                        source2 = %trim(source2)+',' + %trim(temparrAY(I)) ;
                     Endif ;
                  Endif ;
               Endfor;
            Endif ;
            fieldarray(z)  = source2 ;
         Endif ;
      Endfor ;
   Endsr ;

   Begsr filterAlias ;                                                                    //VM02
      z = 1 ;                                                                             //VM02
    //No need to run the loop till %elem(fieldarray) as we filled this till Fld_Index    //0047
    //So run the loop Fld_Index times only                                               //0047
      For z = 1 to Fld_Index ;                                                      //VM02//0047
         If fieldarray(z) = *blanks ;                                                     //VM02
            Iter ;                                                                  //VM02//0047
         Else ;                                                                           //VM02
            Select;                                                                       //AK05
               When %scan('.*':%trim(fieldarray(z)):1) <> 0;                              //AK05
                    posStar1 = %scan('.*':%trim(fieldarray(z)):1);                        //AK05
                    exsr getAliasFields;                                                  //AK05
               When %scan('.':%trim(fieldarray(z)):1) <> 0;                               //AK05
               posDot = %scan('.':%trim(fieldarray(z)):1);                                //VM02
               if posDot <> 0;                                                            //VM02
                  If ((%len(%trim(fieldarray(z)))) - (posDot)) > 0;                       //SB04
                     fieldarray(z) = %subst(%trim(fieldarray(z)):posDot + 1:              //VM02
                                      %len(%trim(fieldarray(z))) - posDot);               //VM02
                  Endif;                                                                  //SB04
               Endif;                                                                     //VM02
            EndSl;                                                                        //AK05
         EndIf;                                                                           //VM02
      Endfor ;                                                                            //VM02
      if %SCAN('.*':%trim(in_str):1) <> 0;                                                //VM05
         exsr putFields;                                                                  //AK05
      endif;                                                                              //AK05
   Endsr ;                                                                                //VM02

   Begsr getAliasFields;                                                                  //AK05
      i = 1 ;                                                                             //AK05
      POSINTO    = %SCAN('INTO' :STRING:1);                                               //AK05
      If POSINTO = *Zeros;                                                                //AK05
         POSFROM = %SCAN('FROM' :STRING:1);                                               //AK05
      else;                                                                               //AK05
         POSFROM = %SCAN('FROM' :STRING:POSINTO) ;                                        //AK05
      endif;                                                                              //AK05
      poswogh(i) = %scan('WHERE':%TRIM(STRING):POSFROM) ;                                 //AK05
      I = I+1 ;                                                                           //AK05
      poswogh(i) = %scan('ORDER BY':%TRIM(STRING):POSFROM) ;                              //AK05
      I = I+1 ;                                                                           //AK05
      poswogh(i) = %scan('GROUP BY':%TRIM(STRING):POSFROM) ;                              //AK05
      I = I+1 ;                                                                           //AK05
      poswogh(i) = %scan('HAVING':%TRIM(STRING):POSFROM) ;                                //AK05
      I = I+1 ;                                                                           //AK05
      poswogh(i) = %scan('FETCH':%TRIM(STRING):POSFROM) ;                                 //AK05
                                                                                          //AK05
      Sorta  %subarr(comma:1:i) ;                                                         //AK05
      TEMPCWOGH = poswogh ;                                                               //AK05
      CLEAR poswogh ;                                                                     //AK05
      I = 1 ;                                                                             //AK05
      J = 1 ;                                                                             //AK05
      FOR  I = 1 TO %ELEM(TEMPCWOGH) ;
         If TEMPCWOGH(I) <> 0 ;                                                           //AK05
            poswogh(J) = TEMPCWOGH(I) ;                                                   //AK05
            J = J+1 ;                                                                     //AK05
         else ;                                                                           //VM05
           Leave ;                                                                        //VM05
         Endif ;                                                                          //AK05
      Endfor ;                                                                            //AK05
      I =1 ;                                                                              //AK05
      If poswogh(i) <> 0 ;                                                                //AK05
         If (poswogh(i) - (posfrom+4)) > 0;                                               //SB04
            STRING2 = %SUBST(%TRIM(string):posfrom+4:poswogh(i)-(posfrom+4));             //AK05
         Endif;                                                                           //SB04
      Else ;                                                                              //AK05
         If (%len(%trim(string)) - (posfrom+3)) > 0;                                      //SB04
            STRING2 = %SUBST(%TRIM(string):posfrom+4:                                     //AK05
                               %len(%trim(string))-(posfrom+3));                          //AK05
         Endif;                                                                           //SB04
      Endif ;                                                                             //AK05
                                                                                          //AK05
      string3 = string2 ;                                                                 //AK05
      CLEAR PCOMMA   ;                                                                    //VM05
      Exsr checkcomma ;                                                                   //AK05
      H = 1 ;                                                                             //VM05
      G = 1 ;                                                                             //VM05
      PCOMMA = COMMA ;                                                                    //VM05
      If Pcomma(G) =  0;                                                                  //VM05
         If (%len(%trim(string2))) > 0;                                                   //SB04
            Filearray(H) = %SUBST(%TRIM(STRING2):1:%len(%trim(string2)));                 //VM05
         Endif;                                                                           //SB04
         exsr getFields;                                                                  //AK05
      Endif  ;                                                                            //AK05
      g = 1 ;                                                                             //VM05
      h = 1 ;                                                                             //VM05
      Dow Pcomma(G) <> 0;                                                                 //VM05
         If Pcomma(G) > 1 and G = 1 ;                                                     //SB04
            filearray(H) = %SUBST(%TRIM(STRING2):1:PCOMMA(G)-1 );                         //VM05
            exsr getFields;                                                               //VM05
         Endif ;                                                                          //AK05
         g =g+1  ;                                                                        //VM05
         h= h+1 ;                                                                         //VM05
         If  Pcomma(G) <> 0   ;                                                           //VM05
            If (pCOMMA(g) - pcomma(g-1)) >= 0;                                            //SB04
               filearray(H) = %SUBST(%TRIM(STRING2):pcomma(g-1)+1:                        //VM05
                              pCOMMA(g)-(pcomma(g-1)+1));                                 //VM05
            Endif;                                                                        //SB04
            exsr getFields;                                                               //VM05
         Else ;                                                                           //AK05
            If (%LEN(%TRIM(STRING2)) - Pcomma(g-1)) > 0;                                  //SB04
               filearray(H) =                                                             //VM05
               %SUBST(%TRIM(STRING2):pcomma(g-1)+1:                                       //VM05
               %LEN(%TRIM(STRING2))-pcomma(g-1));                                         //VM05
            Endif;                                                                        //SB04
            exsr getFields;                                                               //VM05
         Endif ;                                                                          //AK05
      Enddo ;                                                                             //AK05
   Endsr ;                                                                                //AK05

   Begsr getFields;                                                                       //AK05
      String5 = Filearray(H);                                                             //VM05
      Source5 = String5;                                                                  //AK05
      For Count3 = 1 to %Elem(KEYWRDARRAY1);                                              //AK05
        Dow  %Scan(%trimr(KEYWRDARRAY1(count3)):%trim(Source5)) > 0;                      //AK05
            Source5 = %Replace(',' :%trim(Source5):                                       //AK05
                      (%Scan(%trimr(KEYWRDARRAY1(Count3)) : %trim(Source5))):             //AK05
                      %len(%trimr(KEYWRDARRAY1(Count3))));                                //AK05
         Enddo ;                                                                          //AK05
      Endfor;                                                                             //AK05
      string3 = source5 ;                                                                 //AK05
      Exsr checkcomma ;                                                                   //AK05
      k = 1 ;                                                                             //AK05
      l = 1 ;                                                                             //AK05
      if comma(k) = 0;                                                                    //AK05
         JoinFileArray(l) = %trim(source5);                                               //AK05
      endIf;                                                                              //AK05
      Dow comma(k) <> 0;                                                                  //AK05
         If comma(k) > 1 and k = 1;                                                       //SB04
            JoinFileArray(l) = %SUBST(%TRIM(source5):1:COMMA(k)-1) ;                      //AK05
         Endif ;                                                                          //AK05
         l = l+1;                                                                         //AK05
         k = k+1;                                                                         //AK05
         If comma(k) <> 0   ;                                                             //AK05
            If (COMMA(k) - (comma(k-1))) >= 0;                                            //SB04
               JoinFileArray(l) =                                                         //AK05
               %SUBST(%TRIM(source5):comma(k-1)+1:COMMA(k)-(comma(k-1)+1));               //AK05
            Endif;                                                                        //SB04
         else;                                                                            //AK05
            If (%LEN(%TRIM(source5)) - (comma(k-1))) > 0;                                 //SB04
               JoinFileArray(l) =                                                         //AK05
               %SUBST(%TRIM(source5):comma(k-1)+1:                                        //AK05
               %LEN(%TRIM(source5))-comma(k-1));                                          //AK05
            Endif;                                                                        //SB04
         Endif ;                                                                          //AK05
      Enddo ;                                                                             //AK05
      k = 1 ;                                                                             //AK05
      For k = 1 TO %ELEM(JoinFileArray);                                                  //AK05
         If %TRIM(JoinFileArray(k)) <> *BLANKS ;                                          //AK05
           If %scan('=':%trim(JoinFileArray(k)):1) <> 0;                                  //AK05
              JoinFileArray(k) = *blanks ;                                                //AK05
           Else;                                                                          //AK05
              iter  ;                                                                     //VM05
           Endif ;                                                                        //AK05
         Endif ;                                                                          //AK05
      Endfor;                                                                             //AK05
      k = 1 ;                                                                             //AK05
      For k = 1 TO %ELEM(JoinFileArray);                                                  //AK05
         if JoinFileArray(k) <> *blanks;                                                  //AK05
            posslash = %scan('/':%trim(JoinFileArray(k)):1);                              //AK05
            If PosSlash  = *Zero;                                                         //VM05
               PosSlash  = %scan('.':%trim(JoinFileArray(k)):1);                          //VM05
            Endif;                                                                        //VM05

            If posslash > 1;                                                              //SB04
               lib  = %subst(%trim(JoinFileArray(k)):1:posslash-1);                       //AK05
               If (%len(%trim(JoinFileArray(k))) - posslash) > 0;                         //SB04
                  file = %subst(%trim(JoinFileArray(k)):posslash+1:                       //AK05
                             %len(%trim(JoinFileArray(k)))-posslash);                     //AK05
               Endif;                                                                     //SB04
            Else ;                                                                        //AK05
               file = %trim(JoinFileArray(k));                                            //AK05
            Endif ;                                                                       //AK05
            posspace = %scan(' ':%trim(file):1);                                          //AK05
            if posspace > 0;                                                              //AK05
               fileAlias = %subst(%trim(file): posspace + 1);                             //AK05
               fileAlias = %trim(fileAlias) + '.*';                                       //AK05
               If posspace > 1;                                                           //SB04
                  file = %subst(%trim(file): 1 :posspace - 1);                            //AK05
               Endif;                                                                     //SB04
            endif;                                                                        //AK05
            if %trim(fieldarray(z)) = fileAlias and                                       //AK05
               %lookup(fileAlias:fieldArray:1) > 0;                                       //AK05
               exsr Starfield1;                                                           //AK05
            endif;                                                                        //AK05
         endif;                                                                           //AK05
      Endfor;                                                                             //AK05
   Endsr ;                                                                                //AK05

   Begsr StarField1;                                                                      //AK05
      If file  <> *blanks and lib <> *blanks ;                                            //AK05
         clear fieldstr1 ;                                                                //VM05
         Exec Sql                                                                         //AK05
         Declare C3 Cursor for (Select WHFLDI  from IDSPFFD                               //AK05
                                where WHLIB = trim(:Lib)                                  //AK05
                                and   WHFILE = trim(:file));                              //AK05
                                                                                          //AK05
         Exec Sql Open C3;                                                                //AK05
                                                                                          //AK05
         Exec Sql Fetch Next from C3 into :File_Field;                                    //AK05
                                                                                          //AK05
         Dow SqlCode  = 0;                                                                //AK05
            if fieldStr1 = *Blanks;                                                       //AK05
               FieldStr1 = %trim(File_Field);                                             //AK05
            else;                                                                         //AK05
               FieldStr1 = %trim(FieldStr1) + '&' + %trim(File_Field);                    //VM05
            endif;                                                                        //AK05
            Exec Sql Fetch Next from C3 into :File_Field;                                 //AK05
         Enddo;                                                                           //AK05
         Exec Sql  Close C3;                                                              //AK05
                                                                                          //AK05
      Else ;                                                                              //AK05
      clear fieldstr1 ;                                                                   //VM05
         Exec Sql                                                                         //AK05
         Declare C4 Cursor for (Select WHFLDI  from IDSPFFD                               //AK05
                                where WHLIB in (select                                    //AK05
                                      IAOBJLIB from IAOBJMAP                              //AK05
                                where IAOBJNAM = trim(:File)                              //AK05
                                 and  IAOBJTYP = '*FILE'                                  //AK05
                                 and  IAMBRNAM <> ' '                                     //AK05
                                 fetch first row only)                                    //AK05
                                 and   WHFILE = trim(:file));                             //AK05
         Exec Sql  Open C4;                                                               //AK05
                                                                                          //AK05
         Exec Sql Fetch Next from C4 into :File_Field;                                    //AK05
                                                                                          //AK05
         Dow SqlCode  = 0;                                                                //AK05
             if fieldStr1 = *Blanks;                                                      //AK05
                FieldStr1 = %trim(File_Field);                                            //AK05
             else;                                                                        //AK05
                FieldStr1 = %trim(FieldStr1) + '&' + %trim(File_Field);                   //VM05
             endif;                                                                       //AK05
             Exec Sql Fetch Next from C4 into :File_Field;                                //AK05
         Enddo;                                                                           //AK05
         Exec Sql  Close C4;                                                              //AK05
      Endif ;                                                                             //AK05
       fieldarray(z) = %trim(FieldStr1) ;                                                 //VM05
   EndSr;                                                                                 //AK05
                                                                                          //AK05
   Begsr putFields;                                                                       //AK05
      k = 1;                                                                              //VM05
      clear tempfieldarr  ;                                                               //VM05
      tempfieldarr =  fieldarray  ;                                                       //VM05
      clear fieldarray;                                                                   //AK05
      For  i = 1 to %elem(tempfieldarr) ;                                                 //VM05
      If tempfieldarr (i) <> *blanks ;                                                    //VM05
         fieldStr1  = tempfieldarr(i) ;                                                   //VM05
      l = 1;                                                                              //AK05
      Dow %len(%trim(fieldStr1)) > l;                                                     //BA11
        posComma = %scan('&':%trim(fieldStr1):l);                                         //VM05
        If posComma > l;                                                                  //SB04
           FieldN1 = %subst(%trim(fieldStr1):l:posComma-l);                               //AK05
           fieldarray(k) = %trim(FieldN1);                                                //AK05
           k = k +1;                                                                      //AK05
           l = posComma + 1;                                                              //AK05
        else;                                                                             //AK05
           fieldarray(k) = %trim(%subst(%trim(fieldStr1):l));                             //AK05
             k = k +1;                                                                    //VM05
           leave;                                                                         //AK05
        endif;                                                                            //AK05
      EndDo ;                                                                             //AK05
      Else ;                                                                              //VM05
      Z= k ;                                                                              //VM05
      leave ;                                                                             //VM05
     Endif ;                                                                              //VM05
  Endfor ;                                                                                //VM05
   EndSr;                                                                                 //AK05

End-Proc;

Dcl-proc ProcessSelectSQL Export;
   Dcl-pi ProcessSelectSQL;
      in_Str char(5000);
      // in_SrcLib char(10) options(*nopass);                                             //0062
      // in_SrcPf  char(10) options(*nopass);                                             //0062
      // in_SrcMbr char(10) options(*nopass);                                             //0062
      in_uwSrcDtl likeds(uwSrcDtl) options(*nopass);                                       //0062
      in_RrnS   packed(6:0) options(*nopass);
      in_RrnE   packed(6:0) options(*nopass);
   End-pi;

   Dcl-s  option      Char(10);
   Dcl-s  mthd        Char(1);
   Dcl-s  FIELD_ARRAY Char(50) Dim(250);
   Dcl-S  ErrorYN     Char(1);
   Dcl-S  ErrorDes    Char(500);
   Dcl-s  Out_msg     Char(999);

   Dcl-ds VarArr Dim(999) Qualified Inz;
      VarName Char(120);
   End-ds;


   //1. GetFileFieldArray -- Populate File Fields From Sql Query
   Field_Array = GetFileFields(in_Str : Field_Array :arr_index:in_SrcMbr);                 //vm001

   //2. GetIntoArrayArray -- Populate PGM Variables From Sql Query
   //No INTO Clause if this is Declare Query
   If %SubSt(in_Str : 1 : 7) = 'DECLARE';                                                //0019
      VarArr = Field_Array;                                                              //0019
   Else;                                                                                 //0019
      VarArr = GetIntoArray(in_Str : VarArr : ErrorYN : ErrorDes :temp_count             //0019
                              :in_srclib:in_srcmbr);                                     //0019
   Endif;                                                                                //0019
                                                                                         //0019
   //3. WriteIAVARREL
   // WrtIaVarRel(Field_Array : VarArr : Out_Msg : in_srclib                             //0062
   //              : in_srcpf : in_srcmbr :in_rrns :in_rrne);                            //0062
   WrtIaVarRel(Field_Array : VarArr : Out_Msg : in_uwSrcDtl                              //0062
                : in_rrns :in_rrne);                                                     //0062

   //4a. On Clause Parsing                                                               //AK06
   If %scan(' ON ': in_str) > 0;                                                         //0046
      OPTION = 'ON';                                                                         //AK06
      // @ParseOnClause(in_Str : Option    : in_SrcLib : in_SrcPf               0062         //AK06
      //                       : in_SrcMbr : in_RrnS   : in_RrnE);              0062         //AK06
      @ParseOnClause(in_Str : Option    : in_uwSrcDtl : in_RrnS   : in_RrnE);                //0062

   EndIf;                                                                                //0046

   //4. WhereParsing / HavingParsing
   If %scan('WHERE': in_str) > 0;                                                        //0046
      OPTION = 'WHERE';
      // WhereHavingProc(in_Str : Option :in_SrcLib :in_SrcPf                            //0062
      //                   :in_SrcMbr : in_RrnS : in_RrnE);                              //0062
      WhereHavingProc(in_Str : Option :in_uwSrcDtl : in_RrnS : in_RrnE);                 //0062
   EndIf;                                                                                //0046

   //4. WhereParsing / HavingParsing
   If %scan('HAVING': in_str) > 0;                                                       //0046
      OPTION = 'HAVING';
      // WhereHavingProc(in_Str : Option :in_SrcLib :in_SrcPf                            //0062
      //                   :in_SrcMbr : in_RrnS : in_RrnE);                              //0062
      WhereHavingProc(in_Str : Option :in_uwSrcDtl : in_RrnS : in_RrnE);                 //0062
   EndIf;                                                                                //0046
   //5. OrderbyParsing / Groupbyparsing
   If %scan('GROUP BY':in_str) > 0;                                                      //0046
      mthd='1';
   //   GroupByProc(in_Str : Mthd : in_srclib :in_SrcPf                                  //0062
   //                :in_SrcMbr : in_RrnS : in_RrnE);                                    //0062
          GroupByProc(in_Str : Mthd : in_uwSrcDtl : in_RrnS : in_RrnE);                  //0062
   EndIf;                                                                                //0046
   //5. OrderbyParsing / Groupbyparsing
   If %scan('ORDER BY':in_str) > 0;                                                      //0046
      mthd='2';
   //   GroupByProc(in_Str : Mthd : in_srclib :in_SrcPf                                  //0062
   //                :in_SrcMbr : in_RrnS : in_RrnE);                                    //0062
          GroupByProc(in_Str : Mthd : in_uwSrcDtl : in_RrnS : in_RrnE);                  //0062
   EndIf;                                                                                //0046

End-proc;

dcl-proc ProcessUpdateSql Export;
   dcl-pi ProcessUpdateSql;
      In_Str            char(5000);
   // In_srclib         char(10)     options(*nopass);
   // In_srcpf          char(10)     options(*nopass);
   // In_srcmbr         char(10)     options(*nopass);
      in_UwSrcDtl Likeds(UwSrcDtl);                                                       //0062
      In_rrns           packed(6:0)  options(*nopass);
      In_rrne           packed(6:0)  options(*nopass);
   end-pi;

   dcl-s string          char(500);                                                      //MT01
   dcl-s in_Str1         char(5000);                                                     //SK1
   dcl-s data2           char(1000)   dim(50);                                           //SK1
   dcl-s temp_data       char(1000)   dim(50);                                           //SK1
   dcl-s temp_array      char(1000)   dim(50);                                           //VM05
   dcl-s temp_data1      char(1000)   dim(50);                                           //SK1
   dcl-s FIELD_ARRAY1    char(50)     dim(250);                                          //SK1
   dcl-s Temp_Lib        char(10);                                                       //SK1
   dcl-s Temp_Pf         char(10);                                                       //SK1
   dcl-s TempDotPf       char(15);                                                       //SK1
   dcl-s temp_where      char(6)     inz('WHERE');                                       //SK1
   dcl-s sub1            char(50)    inz;                                                //SK1
   dcl-s option          char(10);
   dcl-s mthd            char(1);
   dcl-s data            char(1000)  dim(50);
   dcl-s data1           char(1000)  dim(50);
   dcl-s Fact1           char(1000);
   dcl-s Fact2           char(1000);
   dcl-s casestring      char(1000);                                                     //VM05
   dcl-s casestring1     char(1000);                                                     //VM05
   dcl-s sq_REROUTIN     char(80)    inz;
   dcl-s sq_RERELTYP     char(10)    inz;
   dcl-s sq_RERELNUM     char(10)    inz;
   dcl-s sq_REOPC        char(10)    inz('SQLEXC');
   dcl-s sq_REBIF        char(10)    inz;
   dcl-s sq_REFACT1      char(80)    inz;
   dcl-s sq_RECOMP       char(10)    inz;
   dcl-s sq_REFACT2      char(80)    inz;
   dcl-s sq_RECONTIN     char(10)    inz;
   dcl-s sq_RERESIND     char(06)    inz;
   dcl-s sq_RECAT1       char(1)     inz;
   dcl-s sq_RECAT2       char(1)     inz;
   dcl-s sq_RECAT3       char(1)     inz;
   dcl-s sq_RECAT4       char(1)     inz;
   dcl-s sq_RECAT5       char(1)     inz;
   dcl-s sq_RECAT6       char(1)     inz;
   dcl-s sq_REUTIL       char(10)    inz;
   dcl-s sq_REEXC        char(1)     inz;
   dcl-s sq_REINC        char(1)     inz;
   dcl-s exact_rrn       packed(6:0);                                                    //MT01
   dcl-s Temp_Pos        packed(5:0);                                                    //SK1
   dcl-s temp_i          packed(5:0);                                                    //SK1
   dcl-s temp_j          packed(5:0);                                                    //SK1
   dcl-s posopnbrk       packed(5:0);                                                    //SK1
   dcl-s posopnbrk1      packed(5:0);                                                    //SK1
   dcl-s posclsbrk       packed(5:0);                                                    //SK1
   dcl-s posclsbrk2      packed(5:0);                                                    //SK1
   dcl-s sq_pos          packed(5:0) inz;
   dcl-s I               packed(5:0) inz;                                                //VM05
   dcl-s sq_RENUM1       packed(5:0) inz;
   dcl-s sq_RENUM2       packed(5:0) inz;
   dcl-s sq_RENUM3       packed(5:0) inz;
   dcl-s sq_RENUM4       packed(5:0) inz;
   dcl-s sq_RENUM5       packed(5:0) inz;
   dcl-s sq_RENUM6       packed(5:0) inz;
   dcl-s sq_RENUM7       packed(5:0) inz;
   dcl-s sq_RENUM8       packed(5:0) inz;
   dcl-s sq_RENUM9       packed(5:0) inz;
   dcl-s Pos3            zoned(5:0);                                             //SK1   //0049
   dcl-s DotPos1         zoned(5:0);                                             //SK1   //0049
   dcl-s DotPos2         zoned(5:0);                                             //SK1   //0049
   dcl-s PlusPos         zoned(2:0);                                                     //SK1
   dcl-s Pos1            zoned(5:0);                                                     //0049
   dcl-s Pos2            zoned(5:0);                                                     //0049
   dcl-s Index           zoned(2:0);
   dcl-s WherePos        zoned(4:0);                                                     //0035
   dcl-s casepos         zoned(4:0);                                                     //0035
   dcl-s PosEqual        zoned(3:0);                                                     //0035
   dcl-s OpCode          char(50);                                                       //0035
   dcl-s Pos4            zoned(2:0);                                             //SB03  //0049
   dcl-s wk_Count        packed(2:0) inz;                                                //SB03
   dcl-s loop_Count      packed(2:0) inz;                                                //SB03
   dcl-s loop            int(5)       inz;                                               //SS01
   dcl-s in_srcpf        char(10)     inz;                                               //0062

   dcl-c sq_quote        '''';                                                           //MT01
   dcl-c UpperChars      'ABCDEFGHIJKLMNOPQRSTUVWXYZ_';                                  //SB03
   dcl-c VALIDPARM  CONST('() ') ;                                                       //0035

   in_srcpf    = in_srcspf ;                                                             //0062
   If %scan(',':in_str) < %scan('=':in_str) and %scan(',':in_str) > 0 ;
      Exsr abnormal;
   Else;
      Exsr normalsr;
   Endif;
   //4. WhereParsing / HavingParsing
   If %scan('WHERE': in_str) > 0;                                                        //0046
      OPTION = 'WHERE';
      // WhereHavingProc(in_Str : Option :in_SrcLib :in_SrcPf                            //0062
      //                   :in_SrcMbr : in_RrnS : in_RrnE);                              //0062
      WhereHavingProc(in_Str : Option :in_uwSrcDtl : in_RrnS : in_RrnE);                 //0062
   Endif;                                                                                //0046
   //4. WhereParsing / HavingParsing
   If %scan('HAVING': in_str) > 0;                                                       //0046
      OPTION = 'HAVING';
      // WhereHavingProc(in_Str : Option :in_SrcLib :in_SrcPf                            //0062
      //                   :in_SrcMbr : in_RrnS : in_RrnE);                              //0062
      WhereHavingProc(in_Str : Option :in_uwSrcDtl : in_RrnS : in_RrnE);                 //0062
   Endif;                                                                                //0046
   //5. OrderbyParsing / Groupbyparsing
   If %scan('GROUP BY':in_str) > 0;                                                      //0046
      mthd = '1';
   //   GroupByProc(in_Str : Mthd : in_srclib :in_SrcPf                                  //0062
   //                :in_SrcMbr : in_RrnS : in_RrnE);                                    //0062
          GroupByProc(in_Str : Mthd : in_uwSrcDtl : in_RrnS : in_RrnE);                  //0062
   Endif;                                                                                //0046
   //5. OrderbyParsing / Groupbyparsing
   If %scan('ORDER BY':in_str) > 0;                                                      //0046
      mthd = '2';
   //   GroupByProc(in_Str : Mthd : in_srclib :in_SrcPf                                  //0062
   //                :in_SrcMbr : in_RrnS : in_RrnE);                                    //0062
          GroupByProc(in_Str : Mthd : in_uwSrcDtl : in_RrnS : in_RrnE);                  //0062
   Endif;                                                                                //0046
   Begsr AbNormal;
      Temp_Data = GetDelimiterValue(in_str    : ',') ;
      Temp_i=1;
      Dow Temp_Data(Temp_i) <> *Blank and Temp_i <= %elem(Temp_Data);
         Temp_Data(Temp_i)=Temp_Data(Temp_i);
         If %scan('=':Temp_Data(Temp_i))<>0;
            Leave;
         Endif;
         Temp_i=Temp_i+1;
      Enddo;
      If (%len(%trim(In_str))) > 1;                                                          //SB04
         In_str1=%subst(In_str:%scan('=':In_str)+1:%len(%trim(In_str))-1);
      Endif;                                                                                 //SB04

      If %scan(%trim(Temp_Where):In_str1) > 1;                                               //SB04
         In_str1=%subst(%trim(In_str1):1:(%scan('WHERE':%trim(In_str1))-1));
      endif;
      Temp_Data1 = GetDelimiterValue(in_str1   : ',') ;
      Temp_j=1;
      Dow Temp_Data(Temp_j) <> *Blank and Temp_j <= %elem(Temp_Data);
         If Temp_Data1(Temp_j) = *Blank;
            Leave;
         Endif;
         Temp_Data(Temp_j) = RMVbrackets(temp_data(temp_j));

         Temp_Data1(Temp_j) = RMVbrackets(temp_data1(temp_j));
         Fact1=Temp_Data(Temp_j);

         If %scan('=':%trim(fact1)) > 1;                                                     //SB04
            Fact1=%subst(%trim(Fact1):1:%scan('=':%trim(Fact1))-1);
         Endif;
         Fact2=Temp_Data1(Temp_j);

         Pos1 = %Scan('SET':Fact1);
         If Pos1 > *Zero;
            Fact1 = %Trim(%Subst(%Trim(fact1):Pos1+4));
         Else;
            Fact1 = %Trim(Fact1);
         Endif;
         Posopnbrk=%scan('(':%triml(Fact1));
         Posclsbrk=%scan(')':%triml(Fact1));
         If posopnbrk > 0;
            Exsr opnbrk;
            Fact1=%subst(%TRIML(fact1):posopnbrk1+1);
         Endif;

         If Posclsbrk > 1;                                                                   //SB04
            Exsr clsbrk;
            Fact1=%subst(fact1:1:posclsbrk-1);
         Endif;
         Clear posopnbrk;
         Clear posclsbrk;
         Posopnbrk=%scan('(':%triml(fact2));
         Posclsbrk=%scan(')':%triml(fact2));
         If posopnbrk > 0;
            Exsr opnbrk1;
            Fact2=%subst(%TRIML(fact2):posopnbrk1+1);
         Endif;

         If posclsbrk > 1;                                                                   //SB04
            exsr clsbrk1;
            fact2=%subst(fact2:1:posclsbrk-1);
         Endif;
         clear casestring ;                                                               //VM05
         clear casestring1 ;                                                              //VM05
         if %scan(' CASE ' : %Trim(fact2)) > 0;                                           //VM05
           casestring=%trim(fact2);                                                       //VM05
           casestring1 = ProcessCase(casestring);                                         //VM05
         Endif ;                                                                          //VM05
                                                                                          //VM05
         DotPos1 = %Scan('.' : fact1);                                                    //KM22
         If DotPos1 > *Zero;                                                              //KM22
            Fact1 = %Trim(%Subst(%Trim(Fact1) : DotPos1 +1));                             //KM22
         EndIf;                                                                           //KM22

         Pos2 = %Scan('WHERE':%Trim(Fact1));
         Pos3 = %Scan('SELECT' : %Trim(Fact1));

         Pos1 = %Scan(':':%Trim(Fact2));

         If Pos2 = *Zero;
            Pos2 = %Scan('LIMIT':%Trim(fact2));
         EndIf;

         If Pos2 = *Zero;
            Pos2 = %Scan('FETCH':%Trim(fact2));
         EndIf;

         If Pos1 > *Zero;
            If Pos2 = *Zero;
               Fact2 = %Trim(%SubSt(%Trim(fact2):2));
            Else;
               If Pos2 > 2;                                                                  //SB04
                  Fact2 = %Trim(%SubSt(%Trim(fact2):2: Pos2 - 2));
               Endif;                                                                        //SB04
            Endif;
         endif;
         clear pos1;
         Pos1 = %Scan(':':%Trim(data1(2)));
         If Pos1 > *Zero;
            Clear sq_Pos;                                                                 //KM22
            Sq_Pos = %Scan('.' : Fact2);                                                  //KM22
            If Sq_Pos > *Zero;                                                            //KM22
               Fact2 = %Trim(%SubSt(Fact2 : Sq_Pos +1));                                  //KM22
            EndIf;                                                                        //KM22
         Endif;
         clear  temp_array ;
         if %scan(',': %Trim(casestring1))<> 0;
            TEMP_ARRAY = GetDelimiterValue(%TRIM(casestring1): ',' );
         else;
            TEMP_ARRAY(1) = %Trim(fact2) ;
         endif;

         For  i = 1 to %elem(temp_array) ;
           fact2 = temp_array(I)   ;

         If fact2 <> *blanks ;
         string  = 'Select SOURCE_RRN  from IAPGMREF '                                   //MT01
                 + ' where   LIBRARY_NAME = ' + sq_quote + %trim(in_srclib) + sq_quote   //MT01
                 + ' and     SRC_PF_NAME  = ' + sq_quote + %trim(In_srcpf)  + sq_quote   //0002
                 + ' and     MEMBER_NAME  = ' + sq_quote + %trim(in_srcmbr) + sq_quote   //MT01
                 + ' and     IFS_LOCATION = ' + sq_quote + %trim(In_ifsloc) + sq_quote   //MT01 0062
                 + ' and SOURCE_RRN between '                                            //0002
                 +       %trim(%char(in_rrns)) +' and ' + %trim(%char(in_rrne))          //0002
                 + ' and SOURCE_WORD like '                                              //0002
                 +       sq_quote + '%' +  %trim(Fact2)  + '%' +  sq_quote               //MT01
                 + ' fetch first row only ';                                             //MT01
                                                                                         //MT01
         exec sql PREPARE SqlST2  FROM :string;                                          //MT01
         exec sql declare rrnCsr cursor for sqlst2;                                      //MT01
         exec sql open rrnCsr;                                                           //MT01
         if sqlCode = -502;                                                              //MT21
           exec sql close rrnCsr;                                                        //MT21
           exec sql open  rrnCsr;                                                        //MT21
         endif;                                                                          //MT21
         exec sql fetch from rrnCsr into :exact_rrn;                                     //MT01
         exec sql close rrnCsr;                                                          //MT01
         if exact_rrn = 0;                                                               //MT01
            exact_rrn = in_rrne;                                                         //MT01
         endif;                                                                          //MT01
         Fact2      = IsVariableOrConst(Fact2);                                          //VM05
         IAVARRELLOG(in_srclib   :
                     in_srcpf    :
                     in_srcmbr   :
                     in_ifsloc   :                                                       //0062
                     in_rrns     :
                     exact_rrn   :                                                       //MT01
                     SQ_REROUTIN :
                     SQ_RERELTYP :
                     SQ_RERELNUM :
                     SQ_REOPC    :
                     Fact1       :
                     SQ_REBIF    :
                     SQ_REFACT1  :
                     SQ_RECOMP   :
                     Fact2       :
                     sq_RECONTIN :
                     sq_RERESIND :
                     sq_RECAT1   :
                     sq_RECAT2   :
                     sq_RECAT3   :
                     sq_RECAT4   :
                     sq_RECAT5   :
                     sq_RECAT6   :
                     sq_REUTIL   :
                     sq_RENUM1   :
                     sq_RENUM2   :
                     sq_RENUM3   :
                     sq_RENUM4   :
                     sq_RENUM5   :
                     sq_RENUM6   :
                     sq_RENUM7   :
                     sq_RENUM8   :
                     sq_RENUM9   :
                     sq_REEXC    :
                     sq_REINC);
            Else ;                                                                        //VM05
              Leave ;                                                                     //VM05
            endif ;                                                                       //VM05
            Endfor ;                                                                      //VM05
         temp_j=temp_j+1;
      enddo;
   endsr;
   Begsr Opnbrk;
      Dow Posopnbrk <> 0;
         Posopnbrk1 = posopnbrk;
         Posopnbrk = %scan('(':%triml(fact1):posopnbrk+1);
      Enddo;
   Endsr;

   Begsr clsbrk;
      Posclsbrk=%scan(')':%trimR(fact1):1);
   Endsr;

   Begsr opnbrk1;
      Dow posopnbrk<>0;
         posopnbrk1=posopnbrk;
         posopnbrk=%scan('(':%triml(fact2):posopnbrk+1);
      Enddo;
   Endsr;

   Begsr clsbrk1;
      posclsbrk=%scan(')':%trimR(fact2):1);
   Endsr;
   Begsr Normalsr;
      Data = GetDelimiterValue(in_str    : ',') ;                                         //NG
      Temp_i=1;
      Index = 1;

      If %Scan('/' : in_str) <> *Zero;                                                    //KM22
         If (%Scan('/' : in_str) - 7) > 0;                                                //SB04
            Temp_Lib = %SubSt(In_Str : %Scan('UPDATE' : In_Str)+7:                        //SB04
                       %Scan('/' : in_str)-7);                                            //SB04
         Endif;                                                                           //SB04
         If ((%Scan('SET':In_Str)) - (%Scan('/' : in_str))) > 1;                          //SB04
            Temp_Pf = %SubSt(In_Str:  %Scan('/' : in_str) +1 : %Scan('SET':In_Str)-       //KM22
                          %Scan('/' : in_str)-1);                                         //KM22
         Endif;                                                                           //SB04
         Temp_Pf = %Trim(Temp_Pf);                                                        //KM22
         TempDotPf = %Trim(Temp_Pf) + '.';                                                //KM22
      Else;                                                                               //KM22
         If (%Scan('SET':In_Str) - 8) > 0;                                                //SB04
            Temp_Pf =  %SubSt(In_Str: %Scan('UPDATE':In_Str)+7:                           //SB04
                       %Scan('SET':In_Str)-8);                                            //SB04
         Endif;                                                                           //SB04
         Temp_Pf = %Trim(Temp_Pf);                                                        //KM22
       //Temp_Pos = %Len(%Trim(Temp_Pf));                                                 //KM22
         Temp_Pos = %Len(Temp_Pf);                                                        //RB
       //TempDotPf = %Trim(Temp_Pf) + '.';                                                //KM22
         TempDotPf = Temp_Pf + '.';                                                       //RB
      EndIf;                                                                              //KM22

      Dow Index <= %elem(Data) and Data(Index) <> *Blank;
         Clear Pos1;
         Clear Pos2;
         Clear Pos4;                                                                      //SB03
         //We Need to seperate the values from first = only.
         clear data1;                                                                     //003
         PosEqual = %Scan('=':Data(Index));                                               //0035
         IF PosEqual > 1;                                                                 //0048
           data1(1) = %trim(%Subst(Data(Index):1:PosEqual-1));                            //0035
           data1(2) = %trim(%Subst(Data(Index):PosEqual+1));                              //0035
         Endif;                                                                           //0048
         Exsr CheckDataStr;                                                               //SB03
         If wk_Count = %len(%trim(data1(1)));                                             //SB03
           Index += 1;                                                                    //SB03
           Iter;                                                                          //SB03
         Endif;                                                                           //SB03
         Pos1 = %Scan('SET':data1(1));
         Pos4 = %Scan('UCASE':data1(1));                                                  //SB03
         If Pos1 > *Zero;
            Fact1 = %Trim(%Subst(%Trim(data1(1)):Pos1+4));
         Else;
            Fact1 = %Trim(data1(1));
         Endif;

         If Pos4 > *Zero;                                                                 //SB03
           Pos2 = %Scan('(':data1(1));                                                    //SB03
           Pos3 = %Scan(')':data1(1));                                                    //SB03
           If (Pos3 - Pos2) > 1;                                                          //SB04
              Fact1 = %Trim(%Subst(%Trim(data1(1)):Pos2+1:(Pos3-Pos2)-1));                //SB03
           Endif;                                                                         //SB04
           Clear Pos2;                                                                    //SB03
           Clear Pos3;                                                                    //SB03
         Endif;                                                                           //SB03

         DotPos1 = %Scan('.' : fact1);                                                    //KM22
         If DotPos1 > *Zero;                                                              //KM22
            Fact1 = %Trim(%Subst(%Trim(Fact1) : DotPos1 +1));                             //KM22
         EndIf;                                                                           //KM22
         clear casestring ;                                                               //VM05
         clear casestring1;                                                               //VM05
         Opcode = 'CASE';                                                                //0035
         //Changed the scan operation as data1 array starts with 'CASE' only
         casepos = %scan(%trim(Opcode) : %Trim((data1(2))));                             //0035
         //Check only valid case keyword
         if casepos > 0;                                                                 //0035
            DoW ValidateOpcodeName(data1(2) : Opcode : casepos);                         //0035
               casepos = %scan(%trim(Opcode) : %Trim((data1(2))) :                       //0035
                                casepos + %len(%trim(Opcode)) + 1 );                     //0035
            EndDo;                                                                       //0035
         endif ;                                                                          //VM05
         if casepos > 0;                                                                 //0035
           casestring=%trim(data1(2));                                                    //VM05
           casestring1 = ProcessCase(casestring);                                         //VM05
         endif ;                                                                          //VM05
         Pos2 = %Scan('WHERE':%Trim(data1(2)));
         WherePos = Pos2;                                                                //0035
         Pos3 = %Scan('SELECT' : %Trim(data1(2)));

         If Pos3 > *Zero and Pos3 < Pos2;                                                 //KM22
            Field_Array1 = GetFileFields((data1(2)) : Field_Array1 : arr_index            //vm001
                                                       :In_srcmbr) ;
         EndIf;                                                                           //KM22

         //Search the ':' till "Where" clause only if no Where clause
         //Then search till end of Query
         If WherePos = 0;                                                                //0035
            Pos1 = %Scan(':':%Trim(data1(2)));
         Else;                                                                           //0035
            Pos1 = %Scan(':':%Trim(data1(2)):1:WherePos);                                //0035
         EndIf;                                                                          //0035

         DotPos2 = %Scan(%Trim(TempDotPf):%Trim(data1(2)));                               //KM22

         If Pos2 = *Zero;
            Pos2 = %Scan('LIMIT':%Trim(data1(2)));
         EndIf;

         If Pos2 = *Zero;
            Pos2 = %Scan('FETCH':%Trim(data1(2)));
         EndIf;

         If Pos1 > *Zero;

            If Pos2 = *Zero;
               Fact2 = %Trim(%SubSt(%Trim(data1(2)):2));

            Elseif %Scan(' ' : %Trim(data1(2)): Pos1+1) > 1;
               Fact2 = %Trim(%SubSt (%Trim(data1(2)): Pos1+1 :                           //0035
                       %Scan(' ' : %Trim(data1(2)): Pos1+1) -1 ));                       //0035

              If %Scan(')': Fact2) > 1;                                                  //SB04
                 fact2 = %subst(fact2:1:(%Scan(')': Fact2) - 1));                        //SJ01
              Endif;                                                                     //SJ01

            Endif;

         Else;
            //There is a separate procedure to add 'CONST(' to the values so
            //commenting it here
            If Pos2 = *Zero;
               Fact2 = %Trim(data1(2)) ;                                                 //0035
            Else;
               Select;                                                                    //KM22
               When DotPos2 > *Zero;                                                      //KM22
                  Fact2=%ScanRpl(%Trim(TempDotPf):' ':(%Trim(data1(2))));                 //KM22
                  Pos2 = %scan('WHERE' : %Trim(fact2));
                  If Pos2 > 1;                                                            //SB04
                     Fact2 = 'Const(' +  %Trim(%SubSt(%Trim(Fact2):1:                     //KM22
                          Pos2 -1))+ ')';                                                 //KM22
                  Endif;                                                                  //SB04
               Other;                                                                     //KM22
                  If Pos2 > 1;                                                            //SB04
                     Fact2 = %Trim(%SubSt(%Trim(data1(2)):1:Pos2 -1)) ;                  //0035
                  Endif;
               EndSl;                                                                     //KM22
            Endif;

            If Field_Array1(index) <> *Blanks;                                            //KM22
               clear pos3;                                                                //KM22
               Fact2 = %trim(Field_Array1(index));                                        //KM22
            EndIf;                                                                           //KM22

         Endif;
         clear temp_array ;                                                                  //VM05
         if %scan(',': %Trim(casestring1))<> 0;                                              //VM05
         TEMP_ARRAY = GetDelimiterValue(%TRIM(casestring1): ','      );                      //VM05
         else;                                                                               //VM05
         TEMP_ARRAY(1) = %Trim(fact2) ;                                                      //VM05
         endif;                                                                              //VM05
                                                                                             //VM05
         For  i = 1 to %elem(temp_array) ;                                                   //VM05
           fact2 = temp_array(I)   ;                                                         //VM05
                                                                                             //VM05
           If fact2 <> *blanks ;                                                             //VM05

         string  = 'Select SOURCE_RRN   ' +                                              //MT01
                   'from   IAPGMREF '+                                                   //MT01
                   'where LIBRARY_NAME = ' + sq_quote + %trim(in_srclib)                 //0002
                   + sq_quote +  ' and  SRC_PF_NAME = ' + sq_quote +                     //MT01
                    %trim(In_srcpf) + sq_quote +                                         //MT01
                   ' and MEMBER_NAME  = ' +  sq_quote +  %trim(in_srcmbr)                //MT01
                   + sq_quote +                                                          //0002
                   ' and IFS_LOCATION  = ' +  sq_quote +  %trim(in_ifsloc)               //0062
                   + sq_quote +                                                          //0062
                   ' and SOURCE_RRN between ' + %trim(%char(in_rrns)) +                  //0002
                   ' and ' +  %trim(%char(in_rrne)) +                                    //0002
                   ' and  SOURCE_WORD  like ' + sq_quote                                 //0002
                   + '%' +  %trim(Fact2)  + '%' +  sq_quote +                            //MT01
                   ' fetch first row only ';                                             //MT01

         exec sql PREPARE SqlSTm1  FROM :string;                                         //MT01
         exec sql declare rrnC2 cursor for sqlstm1;                                      //MT01
         exec sql open rrnC2;                                                            //MT01
         if sqlCode = -502;                                                              //MT21
           exec sql close rrnC2;                                                         //MT21
           exec sql open  rrnC2;                                                         //MT21
         endif;                                                                          //MT21
         exec sql fetch from rrnC2 into :exact_rrn;                                      //MT01
         exec sql close rrnC2;                                                           //MT01
         if exact_rrn = 0;                                                               //MT01
            exact_rrn = in_rrne;                                                         //MT01
         endif;                                                                          //MT01

         //Check if Field belong to any DS then extract the field only
         clear sq_pos;                                                                   //0035
         sq_Pos = %check('0123456789.':%trim(Fact2):1);                                  //0035
         If sq_Pos <> 0; //If not numeric then only check for '.'
            If %Subst(Fact2:1:1) <> '"';                                                 //0035
               Pos1 = %Scan('.':Fact2);                                                  //0035
               If  Pos1 <> 0 and %Scan(' ' : Fact2: Pos1+1) > 1;                         //0035
                  Fact2 = %Trim(%SubSt (Fact2: Pos1+1 :                                  //0035
                          %Scan(' ' : Fact2: Pos1+1) -1 ));                              //0035
               Endif;                                                                    //0035
            Endif;                                                                       //0035
         Endif;                                                                          //0035

         Fact2      = IsVariableOrConst(Fact2);                                          //VM05
         IAVARRELLOG(in_srclib   :
                     in_srcpf    :
                     in_srcmbr   :
                     in_ifsloc   :                                                       //0062
                     in_rrns     :
                     exact_rrn   :                                                       //MT01
                     SQ_REROUTIN :
                     SQ_RERELTYP :
                     SQ_RERELNUM :
                     SQ_REOPC    :
                     Fact1       :
                     SQ_REBIF    :
                     SQ_REFACT1  :
                     SQ_RECOMP   :
                     Fact2       :
                     sq_RECONTIN :
                     sq_RERESIND :
                     sq_RECAT1   :
                     sq_RECAT2   :
                     sq_RECAT3   :
                     sq_RECAT4   :
                     sq_RECAT5   :
                     sq_RECAT6   :
                     sq_REUTIL   :
                     sq_RENUM1   :
                     sq_RENUM2   :
                     sq_RENUM3   :
                     sq_RENUM4   :
                     sq_RENUM5   :
                     sq_RENUM6   :
                     sq_RENUM7   :
                     sq_RENUM8   :
                     sq_RENUM9   :
                     sq_REEXC    :
                     sq_REINC);
          else ;                                                                         //VM05
            leave ;                                                                      //VM05
          endif ;                                                                        //VM05
          Endfor ;                                                                       //VM05
         Index += 1;

      Enddo;
   endsr;

   Begsr CheckDataStr;                                                                   //SB03
      wk_Count = 0;                                                                      //SB03
      For loop_Count = 1 to %len(%trim(data1(1)));                                       //SB03
         If %Check(UpperChars : %Subst(data1(1):loop_Count:1)) > 0;                      //SB03
            wk_Count += 1;                                                               //SB03
         Endif;                                                                          //SB03
      Endfor;                                                                            //SB03
   Endsr;                                                                                //SB03

End-proc;


Dcl-proc ProcessDeleteSql Export;
  Dcl-pi ProcessDeleteSql;
    in_Str char(5000);
   //  in_srclib char(10) options(*nopass);                                              //0062
   //  in_srcpf  char(10) options(*nopass);                                              //0062
   //  in_srcmbr char(10) options(*nopass);                                              //0062
    in_uwSrcDtl likeds(uwSrcDtl) options(*nopass);                                       //0062
    in_rrns   packed(6:0) options(*nopass);
    in_rrne   packed(6:0) options(*nopass);
  End-pi;

  Dcl-s  option      Char(10);
  Dcl-s  mthd        Char(1);

  //4. WhereParsing / HavingParsing
  If %scan('WHERE': in_str) > 0;                                                         //0046
     Option = 'WHERE';
      // WhereHavingProc(in_Str : Option :in_SrcLib :in_SrcPf                            //0062
      //                   :in_SrcMbr : in_RrnS : in_RrnE);                              //0062
      WhereHavingProc(in_Str : Option :in_uwSrcDtl : in_RrnS : in_RrnE);                 //0062
  Endif;                                                                                 //0046
  //4. WhereParsing / HavingParsing
  If %scan('HAVING': in_str) > 0;                                                        //0046
     Option = 'HAVING';
      // WhereHavingProc(in_Str : Option :in_SrcLib :in_SrcPf                            //0062
      //                   :in_SrcMbr : in_RrnS : in_RrnE);                              //0062
      WhereHavingProc(in_Str : Option :in_uwSrcDtl : in_RrnS : in_RrnE);                 //0062
  Endif;                                                                                 //0046
  //5. OrderbyParsing / Groupbyparsing
  If %scan('GROUP BY':in_str) > 0;                                                       //0046
     mthd = '1';
   //   GroupByProc(in_Str : Mthd : in_srclib :in_SrcPf                                  //0062
   //                :in_SrcMbr : in_RrnS : in_RrnE);                                    //0062
          GroupByProc(in_Str : Mthd : in_uwSrcDtl : in_RrnS : in_RrnE);                  //0062
  Endif;                                                                                 //0046
  //5. OrderbyParsing / Groupbyparsing
  If %scan('ORDER BY':in_str) > 0;                                                       //0046
     mthd = '2';
   //   GroupByProc(in_Str : Mthd : in_srclib :in_SrcPf                                  //0062
   //                :in_SrcMbr : in_RrnS : in_RrnE);                                    //0062
          GroupByProc(in_Str : Mthd : in_uwSrcDtl : in_RrnS : in_RrnE);                  //0062
  Endif;                                                                                 //0046
End-proc;

Dcl-Proc GetIntoArray export;
   Dcl-pi GetIntoArray Char(120) Dim(999) ;
      pi_str1         Char(5000)         options(*nopass);
      Pi_VarArr       Char(120) Dim(999) options(*nopass);
      Pi_ErrorYN      Char(1)            options(*nopass);
      Pi_ErrorDes     Char(500)          options(*nopass);
      temp_count      packed(4:0)        options(*nopass);
      in_srclib       Char(10)           options(*nopass);
      in_srcmbr       Char(10)           options(*nopass);
   End-pi;


   Dcl-s str1        Char(5000);
   Dcl-s Var_Select  Char(3000);
   Dcl-s Var_Into    Char(1000);
   Dcl-s Var_Where   Char(3000);
   Dcl-s Var_GroupBy Char(3000);
   Dcl-s Var_Having  Char(3000);
   Dcl-s Var_OrderBy Char(3000);
   Dcl-s Var_Update  Char(3000);
   Dcl-s W_FileName  Char(20);
   Dcl-s W_LibName   Char(20);
   Dcl-S Delimiter   Char(1) Inz(',');

   Dcl-s Pos_Last    Packed(4:0);
   Dcl-s Pos_Select  Packed(4:0);
   Dcl-s Pos_From    Packed(4:0);
   Dcl-s POS_FROMS   Packed(4:0);
   Dcl-s Pos_Into    Packed(4:0);
   Dcl-s Pos_Where   Packed(4:0);
   Dcl-s Pos_Group   Packed(4:0);
   Dcl-s Pos_Fetch   Packed(4:0);
   Dcl-s Pos_Limit   Packed(4:0);
   Dcl-s Pos_Order   Packed(4:0);
   Dcl-s Pos_Star    Packed(4:0);
   Dcl-s Pos_Slash   Packed(4:0);
   Dcl-s RowCount    Packed(4:0);
   Dcl-s Index       Packed(4:0);
   Dcl-s W_Count     Packed(5:0);

   STR1 = pi_str1;
   Pos_Select = %Scan('SELECT '  : Str1);
   Pos_Star   = %Scan(' *'       : Str1);
   Pos_Into   = %Scan(' INTO '   : Str1);
   Pos_From   = %Scan(' FROM '   : Str1);
   Pos_Where  = %Scan(' WHERE '  : Str1);
   Pos_Group  = %Scan(' GROUP '  : Str1);
   Pos_Order  = %Scan(' ORDER '  : Str1);
   Pos_Limit  = %Scan(' LIMIT '  : Str1);
   Pos_Fetch  = %Scan(' FETCH '  : Str1);
   Pos_Last   = %Len(%Trim(Str1));

   //Get Library and File Name
   If Pos_Select > *Zero;
      clear temp_count;
      Select;
      When Pos_Where > *ZERO and Pos_Where > (Pos_From + 6);
         W_FileName = %Subst(Str1 : (Pos_From + 6) : (Pos_Where -(Pos_From + 6)));
      When Pos_Group > *ZERO and Pos_Group > (Pos_From + 6);
         W_FileName = %Subst(Str1 : (Pos_From + 6) : (Pos_Group - (Pos_From + 6)));
      When Pos_Order > *ZERO and Pos_Order > (Pos_From + 6);
         W_FileName = %Subst(Str1 : (Pos_From + 6) : (Pos_Order - (Pos_From + 6)));
      When Pos_Limit  > *ZERO and Pos_Limit > (Pos_From + 6);
         W_FileName = %Subst(Str1 : (Pos_From + 6) : (Pos_Limit - (Pos_From + 6)));
      When Pos_Fetch > *ZERO and Pos_Fetch > (Pos_From + 6);
         W_FileName = %Subst(Str1 : (Pos_From + 6) : (Pos_Fetch - (Pos_From + 6)));
      OTHER;
         If (Pos_Last - (Pos_From + 6)) > 0;                                                //BS02
            W_FileName = %Subst(Str1 : (Pos_From + 6): (Pos_Last - (Pos_From + 6)));        //BS02
         Endif;                                                                             //BS02
      Endsl;

      Pos_Slash = %Scan('/' : %Trim(W_FileName));
      If Pos_Slash = *Zero;
         Pos_Slash = %Scan('.' : %Trim(W_FileName));
      Endif;

      If Pos_Slash > 1 and %Len(%Trim(W_FileName)) > Pos_Slash;
         W_LibName  = %Subst(%Trim(W_FileName) : 1 : (Pos_Slash - 1));
         W_FileName = %Subst(%Trim(W_FileName) : (Pos_Slash + 1)
                    :(%Len(%Trim(W_FileName)) - Pos_Slash));
      Endif;
   Endif;

   W_libName = in_srclib;
   w_filename=in_srcmbr;
   POS_FROMS=POS_FROM;
   DOW POS_FROMS<>0;
      POS_FROM=%SCAN('FROM':STR1:POS_FROMS+5);
      IF POS_FROM=0;
         POS_FROM=POS_FROMS;
         LEAVE;
      ENDIF;
      POS_FROMS=POS_FROM;
   ENDDO;
   //Break String after 'INTO' till 'FROM'
   If Pos_Into > *Zero and Pos_From > (Pos_Into + 5);
      Var_Into = %Subst(Str1 : (Pos_Into + 5) : (Pos_From - (Pos_Into + 5)));
      Var_Into = %ScanRpl(':' : ' ' : Var_Into);
        if %SCAN('FROM':%trim(var_into))>1;                                               //sk
          var_into=%subst(%trim(var_into):1:%SCAN('FROM':%trim(var_into))-1);             //sk
        endif;                                                                            //sk
      Clear VarArr;
      Temp1VarArr = GetDelimiterValue(%Trim(Var_Into) : Delimiter);
      ProcessVar(W_LibName:in_srcmbr);
   Endif;

   Pi_VarArr       = VarArr     ;
   Pi_ErrorYN      = 'N'        ;
   Pi_ErrorDes     = *Blanks    ;
   Return vararr;
End-Proc;

//Procedure to get the details of the Host Variables used INTO sql statement
Dcl-proc ProcessVar Export;
   Dcl-pi ProcessVar;
    W_LibName       Char(20);
    in_srcmbr       Char(10)           options(*nopass);
   End-pi;

   Dcl-s Pos_Dot  Packed(5:0);
   Dcl-s Pos_Dot1 Packed(5:0);
   Dcl-s I        Packed(5:0);
   Dcl-s VarName  Char(120);
   Dcl-s RowCount    Packed(4:0);
   Dcl-s Index       Packed(4:0);
   Dcl-s WK_DSSPCY   Char(10);                                                           //0034
   Dcl-s WK_DSBASED  Char(128);                                                          //0034
                                                                                         //0034
   Dcl-c LDSDSTYP    Const('LDS');                                                       //0034

   Index = 1;
   Dow Index < %elem(Temp1VarArr) and Temp1VarArr(Index) <> *Blank;
      Clear Pos_Dot;
      If  %SCAN('.' : %TRIM(Temp1VarArr(Index))) > *Zero;  //Check for Dot position
         For I = 1 to %Len(%Trim(Temp1VarArr(Index)));
            Pos_Dot1 = %SCAN('.' : %TRIM(Temp1VarArr(Index)) : (Pos_Dot + 1));
            If Pos_Dot1 > *Zero;
               Pos_Dot = Pos_Dot1;
            Endif;
            If Pos_Dot1 = *Zero and Pos_Dot > *Zero;
               Leave;
            Endif;
         Endfor;
      Endif;

      If Pos_Dot > *Zero;
         Clear Temp2VarArr;
         Temp2VarArr(1) = %Subst(%Trim(Temp1VarArr(Index)) : (Pos_Dot + 1));
         StoreFinalVar();
      Else;
         Clear RowCount;
         Clear Temp2VarArr;
         VarName = %Trim(Temp1VarArr(Index));
         Exec Sql
            Select Count(*)
            Into :RowCount
            From IAPGMDS
            Where DSPGMNM = Trim(:in_srcmbr)
            And DSNAME   = Trim(:VarName);
         If RowCount > *Zero;
            Exec sql Declare C2_IAPGMDS Cursor for
               Select DSFLDNM
               From IAPGMDS
               Where DSPGMNM = Trim(:in_srcmbr)
               And DSNAME   = Trim(:VarName);
            Exec sql Open C2_IAPGMDS;
            Exec sql Fetch C2_IAPGMDS for :RowCount rows into :Temp2VarArr;
            Exec sql Close C2_IAPGMDS;
            StoreFinalVar();
         Else;
            Clear Temp2VarArr;
            Temp2VarArr(1) = %Trim(Temp1VarArr(Index));   //KM (I=INDEX)
         StoreFinalVar();
         Endif;
      Endif;
      Index += 1;
   Enddo;
End-proc;

Dcl-proc StoreFinalVar Export;
   Dcl-pi StoreFinalVar;
   End-pi;
   Dcl-s Index1  Packed(5:0);
   Dcl-s W_I     Packed(5:0);
   Dcl-s W_J     Packed(3:0);                                                   //SK02
   Dcl-s W_Count     Packed(5:0);
   W_Count = *Zero;
   W_I     = *Zero;
   W_J     = %Lookup(*Blanks:VarArr:1);                                         //SK02

   //Commented Out Temp2Vararr Sorting & related code logics from                       //0034
   //StoreFinalVar Sub-Proc to fix the wrong  ield mapping issue during                 //0034
   //SQL_INTO clause parsing                                                            //0034

   For W_I = 1 to %Elem(Temp2VarArr);                                                    //0034
     If Temp2VarArr(W_I) <> *Blanks;                                                     //SK02
       VarArr(W_J) = Temp2VarArr(W_I);                                                   //SK02
       W_J +=1;                                                                          //SK02
       temp_count=temp_count+1;                                                          //SK02
     Endif;                                                                              //SK02
   Endfor;                                                                               //SK02

End-proc;

DCL-PROC WrtIaVarRel EXPORT;
   DCL-PI WrtIaVarRel;
      IN_RERESULT CHAR(50)     DIM(250)  CONST OPTIONS(*VARSIZE);
      IN_REFACT1  CHAR(80)     DIM(250)  CONST OPTIONS(*VARSIZE);
      OUT_MSG     CHAR(100);
      // in_srclib   char(10)     options(*nopass);                                    //0062
      // in_srcpf    char(10)     options(*nopass);                                    //0062
      // in_srcmbr   char(10)     options(*nopass);                                    //0062
      in_uwSrcDtl likeds(uwSrcDtl);                                                    //0062
      in_rrns     packed(6:0)  options(*nopass);
      in_rrne     packed(6:0)  options(*nopass);
   END-PI;

   dcl-s wRESRCLIB     char(10)     inz('');
   dcl-s wRESRCFLN     char(10)     inz('');
   dcl-s wREPGMNM      char(10)     inz('');
   dcl-s wREIFSLOC     char(100)    inz('');                                             //0062
   dcl-s wREROUTINE    char(80)     inz(' ');
   dcl-s wRERELTYP     char(10)     inz('');
   dcl-s wRERELNUM     char(10)     inz('');
   dcl-s wREOPC        char(10)     inz('SQLEXC');
   dcl-s wRERESULT     char(50)     inz('');
   dcl-s wREBIF        char(10)     inz('');
   dcl-s wREFACT1      char(80)     inz('');
   dcl-s wRECOMP       char(10)     inz('');
   dcl-s wREFACT2      char(80)     inz('');
   dcl-s wRECONTIN     char(10)     inz('');
   dcl-s wRERESIND     char(06)     inz('');
   dcl-s wRECAT1       char(1)      inz('');
   dcl-s wRECAT2       char(1)      inz('');
   dcl-s wRECAT3       char(1)      inz('');
   dcl-s wRECAT4       char(1)      inz('');
   dcl-s wRECAT5       char(1)      inz('');
   dcl-s wRECAT6       char(1)      inz('');
   dcl-s wREUTIL       char(10)     inz('');
   dcl-s wREEXC        char(1)      inz('');
   dcl-s wREINC        char(1)      inz('');
   dcl-s wAnd          char(3)      inz('AND');
   dcl-s TEMPARRAY     char(500)    dim(100);
   dcl-s CaptureFlg    char(1)      inz;
   dcl-s Source2       char(80);
   Dcl-s string        char(500);                                                        //MT01
   dcl-s tmpstr        char(80)     inz;                                                 //MT01
   Dcl-s string4       char(5000);
   Dcl-s string3       char(5000);
   dcl-s wRESEQ        packed(6:0)  inz(1);
   dcl-s wRERRN        packed(6:0)  inz(1);
   dcl-s wRENUM1       packed(5:0)  inz(1);
   dcl-s wRENUM2       packed(5:0)  inz(1);
   dcl-s wRENUM3       packed(5:0)  inz(1);
   dcl-s wRENUM4       packed(5:0)  inz(1);
   dcl-s wRENUM5       packed(5:0)  inz(1);
   dcl-s wRENUM6       packed(5:0)  inz(1);
   dcl-s wRENUM7       packed(5:0)  inz(1);
   dcl-s wRENUM8       packed(5:0)  inz(1);
   dcl-s wRENUM9       packed(5:0)  inz(1);
   dcl-s wInResultLen  packed(5:0);
   dcl-s wInRefact1Len packed(5:0);
   dcl-s wIndex        packed(5:0)  inz(1);
   dcl-s poscomma      packed(4:0);
   dcl-s I             packed(4:0);
   dcl-s J             packed(4:0);
   dcl-s x             packed(4:0);
   dcl-s y             packed(4:0);
   dcl-s z             packed(4:0);
   Dcl-s comma         packed(4:0)  dim(40);
   Dcl-s TEMPcomma     packed(4:0)  dim(40) ascend;                                      //SS01
   Dcl-s posdot        packed(4:0)         ;
   Dcl-s Exact_rrn     packed(6:0) ;                                                     //MT01
   dcl-s loop          int(5)       inz;                                                 //SS01
   dcl-s in_srcpf      char(10);                                                         //0062

   dcl-c wLenNotEqual const('array length not equal');

   dcl-c cFileNotFnd                                                                         //br01
    'An error was encountered, when the destination file not found' ;                        //br01
   dcl-c sq_quote     '''';                                                              //MT01

   uwSrcDtl = in_uwSrcDtl;                                                               //0062
   in_srcpf = in_srcspf;                                                                 //0062
   wInRefact1len = arraySize(IN_REFACT1);
   wInResultLen  = arraySize(IN_RERESULT);

   if wInResultLen  = wInRefact1len;
      for wIndex = 1  to  wInRefact1len;
         if (wIndex =  wInRefact1len);
            wAnd ='';
         endif;
         clear temparray ;
         source2 = %trim(IN_RERESULT(windex)) ;
         If %scan(',':source2:1) <> 0 ;
            string3 = source2 ;
            Exsr checkcomma ;
            x = 1 ;
            y = 1 ;
            Dow x <= %elem(comma) and comma(x) <> 0   ;
               If comma(x) >  1    and x = 1 ;
                  temparray(y) = %SUBST(%TRIM(source2):1:COMMA(x)-1) ;
               Endif ;
               y = y+1  ;
               x = x+1 ;
               If comma(x) <> 0 and COMMA(x)-(comma(x-1)+1) > 0;
                  temparray(y) = %SUBST(%TRIM(source2):
                                  comma(x-1)+1:COMMA(x)-(comma(x-1)+1));
               Elseif %LEN(%TRIM(source2))-(comma(x-1)) > 0;
                  temparray(y) = %SUBST(%TRIM(source2):comma(x-1)+1
                                     :%LEN(%TRIM(source2))-(comma(x-1)));
               Endif ;
            Enddo ;
         Else ;
            y = 1 ;
            temparray(y)  = %trim(source2);
         endif ;

         For z = 1 to %elem(temparray);
            If temparray(z) <> *blanks ;
               temparray(z)  = IsVariableOrConst(temparray(z));                             //vm03
                                                                                            //vm03
               If %SCAN('CONST' :%trim(temparray(z)):1) <> 1 ;                              //vm04
                  posDot = %scan('.':%trim(temparray(z)):1);                                //vm03
                  if posDot <> 0 and %len(%trim(temparray(z))) - posDot > 0;                //vm03
                     temparray(z)  = %subst(%trim(temparray(z)):posDot + 1:                 //vm03
                                         %len(%trim(temparray(z))) - posDot);               //vm03
                  Endif;                                                                    //vm03
               Endif ;                                                                   //vm03
               wRERESULT = temparray(z);
               wREFACT1 =  IN_REFACT1(wIndex);
               wRECONTIN = wAnd;
               wRESRCLIB = in_srclib;
               wRESRCFLN = in_srcpf;
               wREPGMNM  = in_srcmbr;
               wREIFSLOC = in_ifsloc;                                                    //0062
               wRESEQ    = in_rrns;
               tmpstr    = IN_REFACT1(wIndex);                                           //MT01
                                                                                         //MT01
               If in_ifsloc = *blanks;                                                   //0062
               string  = 'Select SOURCE_RRN   ' +                                        //MT01
                         'from   IAPGMREF '+                                             //MT01
                         'where   LIBRARY_NAME = ' + sq_quote +                          //0002
                         %trim(in_srclib)  + sq_quote +  ' and  SRC_PF_NAME = '          //MT01
                         + sq_quote + %trim(In_srcpf) + sq_quote +                       //MT01
                         ' and MEMBER_NAME  = ' +  sq_quote +  %trim(in_srcmbr)          //MT01
                         + sq_quote +                                                    //0002
                         ' and SOURCE_RRN between ' + %trim(%char(in_rrns)) +            //0002
                         ' and ' +  %trim(%char(in_rrne)) +                              //0002
                         ' and  SOURCE_WORD  like ' + sq_quote                           //0002
                         + '%' +  %trim(tmpstr)  + '%' +  sq_quote +                     //MT01
                         ' fetch first row only ';                                       //MT01
               else;                                                                     //0062
               string  = 'Select SOURCE_RRN   ' +                                        //0062
                         'from   IAPGMREF '+                                             //0062
                         'where   IFS_LOCATION = ' + sq_quote +                          //0062
                         %trim(in_ifsloc)  + sq_quote +                                  //0062
                         ' and MEMBER_NAME  = ' +  sq_quote +  %trim(in_srcmbr)          //0062
                         + sq_quote +                                                    //0062
                         ' and SOURCE_RRN between ' + %trim(%char(in_rrns)) +            //0062
                         ' and ' +  %trim(%char(in_rrne)) +                              //0062
                         ' and  SOURCE_WORD  like ' + sq_quote                           //0062
                         + '%' +  %trim(tmpstr)  + '%' +  sq_quote +                     //0062
                         ' fetch first row only ';                                       //0062
               Endif;                                                                    //0062
               exec sql PREPARE SqlStr FROM :string;                                     //MT01
               exec sql declare rrnC3 cursor for sqlstr;                                 //MT01
               exec sql open rrnC3;                                                      //MT01
               exec sql fetch from rrnC3 into :exact_rrn;                                //MT01
               exec sql close rrnC3;                                                     //MT01
               if exact_rrn = 0;                                                         //MT01
                  exact_rrn = in_rrne;                                                   //MT01
               endif;                                                                    //MT01

               wRERRN    = exact_rrn;                                                    //MT01

            // IAVARRELLOG(wRESRCLIB :wRESRCFLN :wREPGMNM                                //0062
               IAVARRELLOG(wRESRCLIB :wRESRCFLN :wREPGMNM :wREIFSLOC                     //0062
               :wRESEQ :wRERRN :wREROUTINE :wRERELTYP
               :wRERELNUM :wREOPC :wRERESULT :wREBIF
               :wREFACT1 :wRECOMP :wREFACT2  :wRECONTIN
               :wRERESIND :wRECAT1 :wRECAT2
               :wRECAT3 :wRECAT4 :wRECAT5 :wRECAT6
               :wREUTIL :wRENUM1 :wRENUM2 :wRENUM3
               :wRENUM4 :wRENUM5 :wRENUM6
               :wRENUM7 :wRENUM8 :wRENUM9 :wREEXC
               :wREINC);
            Else ;
               Leave ;
            Endif ;
        Endfor;
     Endfor ;
   Else;
      // This logic seems incorrect, need to revisit seperately.
      // This is not a bug, just capturing the info message.
      if  wInResultLen = *Zeros and wInReFact1Len <> *Zeros;                              //br01
          OUT_MSG = cFileNotFnd ;                                                         // |
      else;                                                                               //br01
      OUT_MSG =wlennotequal;
      endif;                                                                              //Br01
   Endif;

   Begsr checkcomma;
      clear comma ;
      clear tempcomma ;
      poscomma = 0 ;
      poscomma = %scan(',':%TRIM(string3):1) ;
      if poscomma > *zero ;
         i = 1 ;
         Dow i < %elem(comma) and poscomma <> 0 ;
            string4 = %trim(string3) ;
            comma(i) = poscomma ;
            I= I+1 ;
            If poscomma < %len(%trim(string3));                                          //0048
               poscomma = %scan(',':%trim(string3):poscomma+1) ;
            Else;                                                                        //0048
               leave;                                                                    //0048
            Endif;                                                                       //0048
         Enddo ;
         sorta  comma;                                                                      //0016
         TEMPCOMMA = COMMA ;
         CLEAR COMMA ;
         J = 1 ;
         loop = %lookupgt(*ZEROS:TEMPCOMMA);
         If loop <> *Zeros;
           For  I = Loop TO %ELEM(TEMPCOMMA) ;
            If TEMPCOMMA(I) <> 0 ;
               COMMA(J) = TEMPCOMMA(I) ;
               J = J+1 ;
            Endif ;
           Endfor ;
         Endif ;
       Endif ;
   Endsr ;

END-PROC;

dcl-proc arraySize;
   dcl-pi arraySize packed(4:0);
      inInputArray char(80) dim(250) const;
   end-pi;
  //KD01 dcl-s wArray char(80) dim(250);
   dcl-s count packed(4:0);
    //KD01  wArray = inInputArray;
    //KD01  count =  %LOOKUP(*BLANKS : wArray) - 1;
    count =  %LOOKUP(*BLANKS : inInputArray) - 1;                                        //KD01
      return count;
end-proc;

dcl-proc WhereHavingProc export;
   dcl-pi WhereHavingProc;
      in_str    char(5000);
      option    char(10);
      // in_SrcLib char(10) options(*nopass);                                           //0062
      // in_SrcPf  char(10) options(*nopass);                                           //0062
      // in_SrcMbr char(10) options(*nopass);                                           //0062
      in_uwSrcDtl likeds(uwSrcDtl) options(*nopass);                                    //0062
      in_RrnS   packed(6:0) options(*nopass);
      in_RrnE   packed(6:0) options(*nopass);
   end-pi;

   dcl-pr Getfilefields char(50) dim(250);
      in_str  char(500);
      Field_array char(50) dim(250);
      arr_index packed(4:0)  options(*nopass);
      In_member char(10)     options(*nopass);                                             //vm001
   end-pr;

   dcl-s  OUT_MSG    CHAR(100);
   dcl-s  tmp_string char(500);
   dcl-s  str1       varchar(5000);
   dcl-s  opr        char(7);
   dcl-s  value      char(10);
   dcl-s  oprarr     char(1)   dim(600);                                                 //MT03
   dcl-s  temp_arr   char(80)  DIM(250);
   dcl-s  Filefldarr char(50)  dim(250);
   dcl-s  Valuesarr  char(80)  dim(250);
   dcl-s  WHEREARR   char(500) DIM(500);
   dcl-s  ARR2       char(500) DIM(500);
   dcl-s  out_arr    char(600) dim(600);                                                 //MT03
   dcl-s  WHEREPOS   packed(4:0);
   dcl-s  search_val packed(4:0);
   dcl-s  idx        packed(4:0);
   dcl-s  unionpos   packed(4:0);
   dcl-s  commapos   packed(4:0);
   dcl-s  in_from    packed(4:0);
   dcl-s  sv_commapos packed(4:0);
   dcl-s  sv_selpos  packed(4:0);
   dcl-s  selpos     packed(4:0);
   dcl-s  SAVEPOS    packed(4:0);
   dcl-s  ANDPOS     packed(4:0);
   dcl-s  notPOS     packed(4:0);
   dcl-s  opnbrackt  packed(4:0);
   dcl-s  closbrackt packed(4:0);
   dcl-s  CLAUSEPOS  packed(4:0);
   dcl-s  ORPOS      packed(4:0);
   dcl-s  pos1       packed(4:0);
   dcl-s  Oprpos     packed(4:0);
   dcl-s  I          packed(4:0);
   dcl-s  j          packed(4:0) inz(1);
   dcl-s  k          packed(4:0) inz(1);
   dcl-s  INDEX      packed(4:0);
   dcl-s  save       packed(4:0);
   dcl-s  tmpi       packed(4:0) inz(1);
   dcl-s  in_srcpf   char(10);                                                           //0062

   dcl-c  squote     CONST('''');
   dcl-c  dquote     CONST('"');
   dcl-c  VALIDPARM  CONST('() ') ;
   dcl-c  UP         CONST(' ABCDEFGHIJKLMNOPQRSTUVWXYZ');
   dcl-c  LO         CONST(' abcdefghijklmnopqrstuvwxyz ') ;

      if in_str = *blanks;                                                     //KM
         return;                                                               //KM
      endif;                                                                   //KM

      in_str          = %trim(in_str);
      in_str          = %XLATE(LO : UP : in_str);
      uwSrcDtl        = in_uwSrcDtl;                                                      //0062
      in_srcpf        = in_srcspf;                                                        //0062

      //Find the First occurence of Where
      wherepos = %scan(%trim(OPTION) : in_str);                                           //0033
      savepos = 0;                                                                        //0033
      Dow wherepos > 1 or savepos > 0;                                                    //0033
                                                                                          //0033
         If wherepos > 1;                                                                 //0033
                                                                                          //0033
            //Check if the where clause is valid or not
            If  %check(validParm: in_str : wherepos-1) = wherepos-1 OR                    //0033
                %check(validParm: in_str : wherepos+%len(%trim(OPTION)))                  //0033
                                   = wherepos+%len(%trim(OPTION));                        //0033
               wherepos = %scan(%trim(OPTION): in_str : wherepos                          //0033
                                                       +%len(%trim(OPTION))+1);           //0033
               iter;    //Find next where if current where is invalid
                                                                                          //0033
            Else;  //If Where is valid                                                   //0033
                                                                                          //0033
               if savepos > 0;                                                            //0033
                  index += 1;                                                             //0033
               Endif;                                                                     //0033
                                                                                          //0033
               //Fetch the String b/w two Where caluse
               If savepos < wherepos and savepos > 0;                                     //0033
                  WHEREARR(index) = %subst(in_str : savepos                               //0033
                                    : wherepos - savepos);                                //0033
                  Exsr Break;                                                             //0033
               Endif;                                                                     //0033
                                                                                          //0033
               savepos = wherepos;                                                        //0033
               wherepos = %scan(%trim(OPTION): in_str : wherepos + 6);                    //0033
                                                                                          //0033
            Endif;                                                                        //0033
         Else;                                                                            //0033
            If wherepos = 0 and savepos > 0;                                              //0033
               index += 1;                                                                //0033
               //Fetch the String from where till end of the query
               WHEREARR(index) = %subst(in_str : savepos );                               //0033
               Exsr Break;                                                                //0033
               savepos = 0;                                                               //0033
            Endif;                                                                        //0033
         Endif;                                                                           //0033
      EndDo;                                                                              //0033

      // WrtIaVarRel(filefldarr :valuesarr : out_msg :in_srclib :in_srcpf                  //0062
      //               :in_srcmbr : in_rrns :in_rrne );                                    //0062

      WrtIaVarRel(filefldarr:valuesarr:out_msg:in_uwSrcDtl:in_rrns:in_rrne );             //0062
   Begsr Break;
      WHEREARR(index) = %trim(WHEREARR(index));
      clausepos = %scan(%trim(OPTION) : WHEREARR(index));
      clausepos = Clausepos + %len(%trim(Option)) +1;

      if clausepos > 0;                                                        //KM
         unionpos = %scan('UNION' : WHEREARR(index):clausepos);
      endif;                                                                   //KM

   // if unionpos > 0;                                                         //KM
      if unionPos-1 > 0;                                                       //KM
         doW %check(validParm:WHEREARR(index) :unionPos-1) = unionpos - 1;
            unionpos  = %scan( 'UNION': WHEREARR(index): unionPos+5  );
            if unionpos = 0;
               leave;
            endIf;
         endDo;
      endIf;

      if clausepos > 0;                                                        //KM
         andpos = %scan('AND' : WHEREARR(index) : clausepos);

         If %scan('BETWEEN' : WHEREARR(index) :clausepos) > 0
            and %scan('BETWEEN' : WHEREARR(index) :clausepos) < andpos;

            andpos = %scan('AND' : WHEREARR(index)
                       :  %scan('BETWEEN' : WHEREARR(index)) +1);
            andpos += 3;
            andpos = %scan('AND' : WHEREARR(index) :andpos);
         Endif;
      endif;                                                                   //KM

    //if andpos > 0;                                                           //KM
      if andPos-1 > 0;                                                         //KM
         doW %check(validParm:WHEREARR(index) :andPos-1) = andpos - 1;
            andpos  = %scan( 'AND ': WHEREARR(index): andPos+3  );
            if andpos = 0;
               leave;
            endIf;
         endDo;
      endIf;

      orpos  = %scan('OR' : WHEREARR(index));
    //if orpos > 0;                                                            //KM
      if orPos-1 > 0;                                                          //KM
         doW %check(validParm:WHEREARR(index) :orPos-1) = orpos - 1;
            orpos  = %scan( 'OR': WHEREARR(index): orPos+2  );
            if orpos = 0;
               leave;
            endIf;
         endDo;

         doW %check(validParm:WHEREARR(index) :orPos+2) = orpos + 2;
            orpos  = %scan( 'OR': WHEREARR(index): orPos+2  );
            if orpos = 0;
               leave;
            endIf;
         endDo;
      endIf;

      dow andpos <> 0 or orpos <> 0 or unionpos <> 0;
         i += 1;
         select;
         When andpos <> 0 and orpos <> 0 and unionpos <> 0
          and unionpos < andpos and unionpos < orpos;
                                                                                             //SB04
         // If (unionpos - clausepos) > 0;                                            //SB04 //KM
            If (unionpos - clausepos) > 0 and clausepos > 0;                                 //KM
               arr2(i) = %subst(WHEREARR(index) : clausepos
                                : unionpos - clausepos);
            Endif;                                                                           //SB04
            clausepos = unionpos + 5;

         When andpos <> 0 and orpos <> 0 and unionpos <> 0
          and andpos < unionpos and andpos < orpos;
                                                                                             //SB04
         // If (andpos - clausepos) > 0;                                              //SB04 //KM
            If (andpos - clausepos) > 0 and clausepos > 0;                                   //KM
               arr2(i) = %subst(WHEREARR(index) : clausepos
                                 : andpos - clausepos);
            Endif;                                                                           //SB04
            clausepos = andpos + 3 ;

         When andpos <> 0 and orpos <> 0 and unionpos <> 0
          and orpos < unionpos and orpos < andpos;
                                                                                             //SB04
         // If (orpos - clausepos) > 0;                                               //SB04 //KM
            If (orpos - clausepos) > 0 and clausepos > 0;                                    //KM
               arr2(i) = %subst(WHEREARR(index) : clausepos
                                 : orpos - clausepos);
            Endif;                                                                           //SB04
            clausepos = orpos  + 2 ;

         When andpos = 0 and orpos <> 0 and unionpos <> 0 and orpos < unionpos ;
                                                                                             //SB04
         // If (orpos - clausepos) > 0;                                               //SB04 //KM
            If (orpos - clausepos) > 0 and clausepos > 0;                                    //KM
               arr2(i) = %subst(WHEREARR(index) : clausepos
                                 : orpos - clausepos);
            Endif;                                                                           //SB04
            clausepos = orpos  + 2 ;

         When andpos = 0 and orpos <> 0 and unionpos <> 0 and unionpos < orpos;
                                                                                             //SB04
         // If (unionpos - clausepos) > 0;                                            //SB04 //KM
            If (unionpos - clausepos) > 0 and clausepos > 0;                                 //KM
               arr2(i) = %subst(WHEREARR(index) : clausepos
                                : unionpos - clausepos);
            Endif;                                                                           //SB04
            clausepos = unionpos + 5;

         When orpos = 0 and andpos <> 0 and unionpos <> 0 and unionpos < andpos;
                                                                                             //SB04
         // If (unionpos - clausepos) > 0;                                            //SB04 //KM
            If (unionpos - clausepos) > 0 and clausepos > 0;                                 //KM
               arr2(i) = %subst(WHEREARR(index) : clausepos :
                             unionpos - clausepos);
            Endif;                                                                           //SB04
            clausepos = unionpos + 5;

         When orpos = 0 and andpos <> 0 and unionpos <> 0 and andpos < unionpos;
                                                                                             //SB04
         // If (andpos - clausepos) > 0;                                              //SB04 //KM
            If (andpos - clausepos) > 0 and clausepos > 0;                                   //KM
               arr2(i) = %subst(WHEREARR(index) : clausepos : andpos - clausepos);
            Endif;                                                                           //SB04
                                                                                             //SB04
            clausepos = andpos + 3 ;

         When unionpos = 0 and andpos <> 0 and orpos <> 0 and andpos < orpos;
                                                                                             //SB04
         // If (andpos - clausepos) > 0;                                              //SB04 //KM
            If (andpos - clausepos) > 0 and clausepos > 0;                                   //KM
               arr2(i) = %subst(WHEREARR(index) : clausepos : andpos - clausepos);
            Endif;                                                                           //SB04
                                                                                             //SB04
            clausepos = andpos + 3 ;

         When unionpos = 0 and andpos <> 0 and orpos <> 0 and orpos < andpos;
                                                                                             //SB04
         // If (orpos - clausepos) > 0;                                               //SB04 //KM
            If (orpos - clausepos) > 0 and clausepos > 0;                                    //KM
               arr2(i) = %subst(WHEREARR(index) : clausepos : orpos - clausepos);
            Endif;                                                                           //SB04
                                                                                             //SB04
            clausepos = orpos  + 2 ;

         When unionpos = 0 and andpos = 0 and orpos <> 0 ;
                                                                                             //SB04
         // If (orpos - clausepos) > 0;                                               //SB04 //KM
            If (orpos - clausepos) > 0 and clausepos > 0;                                    //KM
               arr2(i) = %subst(WHEREARR(index) : clausepos
                                 : orpos - clausepos);
            Endif;                                                                           //SB04
            clausepos = orpos  + 2 ;

         When unionpos = 0 and orpos = 0 and andpos <> 0 ;
                                                                                             //SB04
         // If (andpos - clausepos) > 0;                                              //SB04 //KM
            If (andpos - clausepos) > 0 and clausepos > 0;                                   //KM
               arr2(i) = %subst(WHEREARR(index) : clausepos
                                 : andpos - clausepos);
            Endif;                                                                           //SB04
            clausepos = andpos + 3 ;

         When andpos = 0 and orpos = 0 and unionpos <> 0;
                                                                                             //SB04
         // If (unionpos - clausepos) > 0;                                            //SB04 //KM
            If (unionpos - clausepos) > 0 and clausepos > 0;                                 //KM
               arr2(i) = %subst(WHEREARR(index) : clausepos
                                : unionpos - clausepos);
            Endif;                                                                           //SB04
            clausepos = unionpos + 5;
         endsl;

         If clausepos > 0;                                                               //KM
            andpos = %scan('AND' : WHEREARR(index) : clausepos);
            If %scan('BETWEEN' : WHEREARR(index)) > 0 and
               %scan('BETWEEN' : WHEREARR(index) :clausepos) < andpos;

               andpos = %scan('AND' : WHEREARR(index)
                             :  %scan('BETWEEN' : WHEREARR(index)) +1);
               andpos += 3;
               andpos = %scan('AND' : WHEREARR(index) :andpos);
            Endif;
         EndIf;                                                                          //KM

      // if andpos > 0;                                                                  //KM
         if andPos-1 > 0;                                                                //KM
            doW %check(  validParm: WHEREARR(index) : andPos-1 )
                                                        = andpos -1;
               andpos  = %scan( 'AND ': WHEREARR(index): andPos+3  );
               if andpos = 0;
                  leave;
               endIf;
            endDo;
         endIf;

         if clausepos > 0;                                                               //KM
            orpos  = %scan('OR' : WHEREARR(index) :clausepos);
         endif;                                                                          //KM
      // if orpos > 0;                                                            //MT14 //KM
         if orPos-1 > 0;                                                                 //KM
            doW %check(validParm:WHEREARR(index) :orPos-1) = orpos - 1;
               orpos  = %scan( 'OR': WHEREARR(index): orPos+2  );
               if orpos = 0;
                  leave;
               endIf;
            endDo;

         // if orpos <> 0;                                                               //KM
            if orpos  > 0;                                                               ///KM
               doW %check(validParm:WHEREARR(index) :orPos+2) = orpos + 2;
                  orpos  = %scan( 'OR': WHEREARR(index): orPos+2  );
                  if orpos = 0;
                     leave;
                  endIf;
               endDo;
            endif;                                                                       //MT14
         endIf;

         if clausepos > 0;                                                               //KM
            unionpos = %scan('UNION' : WHEREARR(index) : clausepos);
         endif;                                                                          //KM
      // if unionpos > 0;                                                                //KM
         if unionpos - 1 > 0;                                                            //KM
            doW %check(validParm:WHEREARR(index) :unionPos-1) = unionpos-1;
               unionpos  = %scan( 'UNION': WHEREARR(index): unionPos+5);
               if unionpos = 0;
                  leave;
               endIf;
            endDo;
         endIf;
         Exsr Filterarr2;

      Enddo;

      If andpos = 0 and orpos = 0 and unionpos = 0;
         If clausepos > 0;                                                                   //SB04
            i += 1;
            arr2(i) = %subst(WHEREARR(index) : clausepos);
            Exsr Filterarr2;                                                                 //SB04
         Endif;
      Endif;
   Endsr;

   Begsr Filterarr2;
      notpos = %scan('NOT': arr2(i));
      opnbrackt = %scan('(': arr2(i));
      closbrackt = %scan(')' : arr2(i));
      if notpos > 1;
         doW %check(  validParm: arr2(i)  : notPos-1 ) = notpos -1;
            notpos  = %scan( 'NOT ': arr2(i): notPos+3  );
            if notpos = 0;
               leave;
            endIf;
         endDo;
      endIf;

      dow (notpos <> 0 );
      // If notpos <> 0;                                                                 //KM
         If notpos  > 0;                                                                 //KM
            arr2(i) = %replace ( ' ': arr2(i) : notpos :3);
            notpos = %scan('NOT' : arr2(i) : notpos+1);

            If notpos > 1;
               doW %check(  validParm: arr2(i)  : notPos-1 ) = notpos-1;
                  notpos  = %scan( 'NOT ': arr2(i): notPos+3  );
                  if notpos = 0;
                     leave;
                  endIf;
               endDo;
            endIf;

         endif;
      Enddo;

      arr2(i) = %trim(arr2(i));
      clear opr;
      select;
      when %scan('<>' : arr2(i)) > 0 ;
         opr = '<>';
      when %scan('>=' : arr2(i)) > 0 ;
         opr = '>=';
      when %scan('<=' : arr2(i)) > 0 ;
         opr = '<=';
      when %scan('<' : arr2(i)) > 0;
         opr = '<';
      when %scan('>' : arr2(i)) > 0;
         opr = '>';
      when %scan('=' : arr2(i)) > 0;
         opr = '=';
      endsl;

      oprpos  = %scan('IN' : arr2(i));
   // if oprpos > 0;                                                                     //KM
      if oprpos > 1;                                                                     //KM
         doW %check( validParm : arr2(i) :oprPos-1) = oprpos - 1;
            oprpos  = %scan( 'IN': arr2(i) : oprPos+2  );
            if oprpos = 0;
               leave;
            endIf;
         endDo;
         If oprpos <> 0;
            opr = 'IN';
         Endif;
      Endif;

      oprpos  = %scan('IS' : arr2(i));
   // if oprpos > 0;                                                                     //KM
      if oprpos > 1;                                                                     //KM
         doW %check(validParm : arr2(i) :oprPos-1) = oprpos - 1;
            oprpos  = %scan( 'IS': arr2(i) : oprPos+2  );
            if oprpos = 0;
               leave;
            endIf;
         endDo;
         If oprpos <> 0;
            opr = 'IS';
         Endif;
      Endif;

      oprpos  = %scan('LIKE' : arr2(i));
    //if oprpos > 0;                                                                     //KM
      if oprpos > 1;                                                                     //KM
         doW %check(validParm: arr2(i) :oprPos-1) = oprpos - 1;
            oprpos  = %scan( 'LIKE': WHEREARR(index): oprPos+4  );
            if oprpos = 0;
               leave;
            endIf;
         endDo;
         If oprpos <> 0;
            opr = 'LIKE';
         Endif;
      Endif;

      oprpos  = %scan('BETWEEN': arr2(i));
    //if oprpos > 0;                                                                     //KM
      if oprpos > 1;                                                                     //KM
         doW %check(validParm: arr2(i) : oprpos - 1) = oprpos - 1;
            oprpos  = %scan( 'BETWEEN' : arr2(i) : oprPos+7  );
            if oprpos = 0;
               leave;
            endIf;
         endDo;
         If oprpos <> 0;
            opr = 'BETWEEN';
         Endif;
      Endif;

      Exsr FilterMainArr;
      If opr <> *blanks;
         oprpos = %scan(%trim(opr) : arr2(i));
         If (oprpos - 1) > 0;                                                                //SB04
            filefldarr(j) = %subst(arr2(i) : 1 : oprpos -1);
         Endif;                                                                              //SB04
         If tmpi <= %Elem(temp_arr) and tmpi > 0 ;                                           //0049
            temp_arr(tmpi) = filefldarr(j);
            Exsr Bracktremoval;
            filefldarr(j) = temp_arr(tmpi);
            clear temp_arr;

            if oprpos > 0;                                                                  //KM
               valuesarr(k) = %subst(arr2(i) : oprpos + %len(%trim(opr)));
            endif;                                                                          //KM
            temp_arr(tmpi) = valuesarr(k);
            Exsr Bracktremoval;
            valuesarr(k) = temp_arr(tmpi);
            clear temp_arr;

            If %scan('CASE': valuesarr(k)) > 0 and
               %scan('CASE': filefldarr(j)) = 0;
             If (%scan('CASE': valuesarr(k)) - 1) > 0;                                        //SB04
                  valuesarr(k) = %subst(Valuesarr(k) : 1 :
                                     %scan('CASE': valuesarr(k)) - 1);
             Endif;                                                                           //SB04
               if valuesarr(k) <> *blanks;
                  tmpi = %len(%trim(valuesarr(k)));
                If tmpi > 1;                                                                  //SB04
                     valuesarr(k) = %subst(Valuesarr(k) : 1 : tmpi - 1);
                Endif;                                                                        //SB04
                  Exsr SplitArithmetic;
               endif;

               exsr ParseCaseWhen;
               valuesarr(k) = %subst(arr2(i) : %scan('END' : arr2(i)) + 3 );

               if valuesarr(k) <> *blanks;
                  tmpi = %check(' ':valuesarr(k));
                  valuesarr(k) = %subst(Valuesarr(k) :  tmpi + 1);
                  Exsr SplitArithmetic;
               endif;
            Else;
               If  %scan('CASE': filefldarr(j)) = 0;
                  Exsr ParseWhereHaving;
               else;
                  clear filefldarr;
                  clear valuesarr;
               Endif;
            endif;
         Endif ;                                                                          //0049

      Else;
         If %scan('SELECT' : filefldarr(j)) > 0;
         Endif;
      Endif;

   Endsr;

   Begsr ParseWhereHaving;
      Select;
      When opr = 'IN';
         If %scan('SELECT': filefldarr(j)) > 0;
            Tmp_String  = filefldarr(j);

            Temp_arr  = GetFileFields(Tmp_String :temp_arr :arr_index:in_SrcMbr);         //vm001
            filefldarr(j) = temp_arr(tmpi);
         Endif;
         j += 1;

         commapos =  %scan(',': valuesarr(k));
         In_From  = %scan('FROM': valuesarr(k));
         if commapos <> 0 and in_FROM > 0;
            sv_commapos = %scan(',': valuesarr(k) : IN_FROM + 4);
         endif;
         If ( commapos > %scan('SELECT': valuesarr(k)) and commapos < in_From
             and sv_commapos = 0) or  commapos = 0;

            If %scan('SELECT': valuesarr(k)) > 0;
               Tmp_String  = valuesarr(k);

               Temp_arr  = GetFileFields(Tmp_String:temp_arr:arr_index:in_SrcMbr);          //vm001
               valuesarr(k) = temp_arr(tmpi);
            Endif;
            exsr checkvaluesarr;
            k += 1;
         Else;
            Exsr MultipleValueIn;
         Endif;

      When opr = 'BETWEEN';
         pos1 =  %Scan('AND' :arr2(i) : oprpos + 7);
         If oprpos > 0 and ((pos1 - oprpos) - %len(%trim(opr))) > 0;                         //SB04
            Valuesarr(k) = %subst(arr2(i) : oprpos + %len(%trim(opr))
                               : pos1 -oprpos -%len(%trim(opr)) );
         Endif;                                                                              //SB04
         If %scan('SELECT': Valuesarr(k)) > 0;
            Tmp_String  = valuesarr(k);

            Temp_arr  = GetFileFields(Tmp_String : temp_arr :arr_index:in_srcmbr);           //vm001
            valuesarr(k) = temp_arr(tmpi);
         Endif;

         Exsr Checkvaluesarr;
         k += 1;
         If %scan('SELECT': filefldarr(j)) > 0;
            Tmp_String  = filefldarr(j);

            Temp_arr  = GetFileFields(Tmp_String : temp_arr :arr_index:in_srcmbr);           //vm001
            filefldarr(j) = temp_arr(tmpi);
         else;
            If %trim(option) = 'WHERE';
               If oprpos > 1;                                                                //SB04
                  filefldarr(j) = %subst(arr2(i) : 1 : oprpos -1);
               Endif;                                                                        //SB04
            Endif;
         Endif;

         j += 1;
         filefldarr(j) = filefldarr(j-1);
         pos1 += 3;
         If (%len(%trim(arr2(i))) - pos1) >= 0;                                              //SB04
            Valuesarr(k) = %subst(arr2(i) : pos1 :
                            %len(%trim(arr2(i))) - pos1 +1);
         Endif;                                                                              //SB04

         If %scan('SELECT': Valuesarr(k)) > 0;
            Tmp_String  = valuesarr(k);
            Temp_arr  = GetFileFields(Tmp_String : temp_arr :arr_index:in_srcmbr);         //vm001
            valuesarr(k) = temp_arr(tmpi);
         Endif;
         Exsr Checkvaluesarr;
         k += 1;
         j += 1;
      Other;
         Select;
         When %scan('SELECT': filefldarr(j)) > 0 and
              %scan('SELECT': valuesarr(k)) > 0;
            Tmp_String  = filefldarr(j);

            Temp_arr  = GetFileFields(Tmp_String : temp_arr:arr_index:in_SrcMbr);          //vm001
            filefldarr(j) = temp_arr(tmpi);
            j += 1;
            Tmp_String  = Valuesarr(k);

            Temp_arr  = GetFileFields(Tmp_String : temp_arr :arr_index:in_SrcMbr);         //vm001
            Valuesarr(k)  = temp_arr(tmpi);
            k += 1;
            Exsr CheckValuesarr;
         When %scan('SELECT': filefldarr(j)) > 0 ;
            Tmp_String  = filefldarr(j);

            Temp_arr  = GetFileFields(Tmp_String : temp_arr:arr_index:in_SrcMbr);          //vm001
            filefldarr(j) = temp_arr(tmpi);
            j += 1;
            Exsr CheckValuesarr;
            k += 1;
         When %scan('SELECT': valuesarr(k)) > 0;
            Tmp_String  = Valuesarr(k);

            Temp_arr  = GetFileFields(Tmp_String : temp_arr:arr_index:in_srcmbr);          //vm001
            Valuesarr(k)  = temp_arr(tmpi);
            Exsr CheckValuesarr;
            k += 1;
            j += 1;
         Other;
            If %scan(',' : filefldarr(j)) > 0 and
               %scan(',' : valuesarr(k)) > 0;
               Exsr Checkcomma;
            Else;
               j += 1;
               Exsr CheckValuesarr;
               k += 1;
            Endif;
         Endsl;
      Endsl;
   Endsr;

   Begsr ParseCaseWhen;
      Tmp_String  = %subst(arr2(i) : %scan(' CASE ': arr2(i))
                                   : (%scan(' END ': arr2(i)) + 3) -
                                     %scan(' CASE ': arr2(i)) );
      Tmp_String = ProcessCase(Tmp_String);
      temp_arr   = GetDelimiterValue(Tmp_string : ',') ;
      For tmpi = 1 to %elem(temp_arr);
         if temp_arr(tmpi) = *blanks;
            leave;
         Endif;

         valuesarr(k) = temp_arr(tmpi);
         Exsr Checkvaluesarr;
         k += 1;
         filefldarr(j) = filefldarr(j-1);
         j += 1;
      Endfor;
      clear temp_arr;
      clear tmpi;
   Endsr;

   Begsr SplitArithmetic;
      str1 = Valuesarr(k);
      if %Scan('+' : STR1) > 0 or %Scan('-' : STR1) > 0 or
         %Scan('*' : STR1) > 0 or %Scan('/' : STR1) > 0 or
         %Scan('(' : STR1) > 0 or %Scan(')' : STR1) > 0 or
         %Scan('||' : STR1) > 0 ;

         clear tmpi;
         split_component_5(str1 : out_arr : oprarr : tmpi);
         For tmpi = 1 to %elem(out_arr);

            if out_arr(tmpi) = *blanks;
               leave;
            Endif;
            valuesarr(k) = out_arr(tmpi);
            Exsr Checkvaluesarr;
            k += 1;
            j +=1;
            filefldarr(j-1) = filefldarr(1) ;
         Endfor;
      endif;
      clear out_arr;
      clear tmpi;
      clear str1;
   Endsr;

   Begsr CheckComma;
      temp_arr(tmpi) = filefldarr(j) ;
      commapos = %scan(',' : temp_arr(tmpi));
      sv_commapos = 1;
      Dow commapos <> 0;
                                                                                             //SB04
         If (commapos - sv_commapos) > 0;                                                    //SB04
            filefldarr(j) = %subst(temp_arr(tmpi): sv_commapos
                                    :commapos - sv_commapos);
         Endif;                                                                              //SB04
                                                                                             //SB04
         j += 1;
         sv_commapos = commapos +1;
         If commapos < %len(%trim(temp_arr(tmpi)));                                      //0048
            commapos = %scan(',' : temp_arr(tmpi) :commapos + 1);
         Else;                                                                           //0048
            leave;                                                                       //0048
         Endif;                                                                          //0048
         If commapos = 0;
            filefldarr(j) = %subst(temp_arr(tmpi): sv_commapos);
            j += 1;
         endif;
      Enddo;

      temp_arr(tmpi) = valuesarr(k);
      commapos = %scan(',' : temp_arr(tmpi));
      sv_commapos = 1;
      Dow commapos <> 0;
                                                                                             //SB04
         If (commapos - sv_commapos) > 0;                                                    //SB04
            valuesarr(k)  = %subst(temp_arr(tmpi): sv_commapos
                                   :commapos - sv_commapos);
         Endif;                                                                              //SB04
                                                                                             //SB04
         Exsr Checkvaluesarr;
         k += 1;
         sv_commapos = commapos +1;
         IF commapos < %len(%trim(temp_arr(tmpi)));                                      //0048
            commapos = %scan(',' : temp_arr(tmpi) :commapos + 1);
         Else;                                                                           //0048
            leave;                                                                       //0048
         Endif;                                                                          //0048
         If commapos = 0;
            valuesarr(k) = %subst(temp_arr(tmpi): sv_commapos);
            Exsr Checkvaluesarr;
            k += 1;
         endif;
      Enddo;
      clear temp_arr(tmpi);
   Endsr;

   Begsr Checkvaluesarr;                                                                 //MT11
      opnbrackt  =  %scan('(' : valuesarr(k));                                           //MT11
      closbrackt =  %scan(')' : valuesarr(k));                                           //MT11
                                                                                         //MT11
      If (opnbrackt > 0 or closbrackt > 0 );                                             //MT11
         Dow opnbrackt <> 0;                                                             //MT11
            valuesarr(k) = %replace(' ' : valuesarr(k) : opnbrackt : 1);                 //MT11
            opnbrackt =  %scan('(' : valuesarr(k) : opnbrackt + 1);                      //MT11
         Enddo;                                                                          //MT11
                                                                                         //MT11
         Dow closbrackt <> 0;                                                            //MT11
            valuesarr(k) = %replace(' ' : valuesarr(k) : closbrackt : 1);                //MT11
            closbrackt =  %scan(')' : valuesarr(k) : closbrackt + 1);                    //MT11
         Enddo;                                                                          //MT11
      Endif;                                                                             //MT11

      If %scan('.' : valuesarr(k)) > 0;                                                  //MT14
         valuesarr(k) = %subst(valuesarr(k) : %scan('.' : valuesarr(k)) + 1);            //MT14
      Endif;                                                                             //MT14

      value = 'Const(';
      Select;
      When %scan(squote :valuesarr(k)) > 0 or %scan(dquote :valuesarr(k)) > 0;
         valuesarr(k) = %trim(value)   +  %trim(valuesarr(k));
         valuesarr(k) =  %trim(valuesarr(k)) + ')';
      When %scan(':' : valuesarr(k)) > 0;
         valuesarr(k)  = %replace (' ': valuesarr(k): %scan(':' :valuesarr(k))
                                    :1);
      When %check(' _.0123456789': valuesarr(k) : 1) = 0;
         valuesarr(k) = %trim(value) +
                                 %trim(valuesarr(k));
         valuesarr(k) = %trim(valuesarr(k)) + ')';
      When %scan('.' : valuesarr(k)) > 0;
         If ((%scan(' ' :valuesarr(k)) - %scan('.' :valuesarr(k))) - 1) > 0;                 //SB04
            valuesarr(k) = %subst(valuesarr(k): %scan('.':valuesarr(k)) + 1
                                            : %scan(' ' :valuesarr(k))
                                   -  %scan('.' :valuesarr(k)) - 1);
         Endif;                                                                              //SB04
      Endsl;
      valuesarr(k) = %trim(valuesarr(k));
   Endsr;

   Begsr FilterMainArr;
      For idx = 1 to %elem(keywordarr);
         search_Val = %scan(%trim(keywordarr(idx)) : %trim(arr2(i)) );
         If search_val > 1;
            //Check is keyword is suffixed with valid character or not
            doW %check(validParm : arr2(i)                                               //0033
                       :search_Val -1) = search_val - 1 or                               //0033
                %check(validParm : arr2(i)                                               //0033
                       :search_Val +%LEN(%TRIM(keywordarr(idx))))                        //0033
                        = search_val + %LEN(%TRIM(keywordarr(idx)));                     //0033

               search_Val = %scan(%trim(keywordarr(idx)) :
                                  arr2(i)           :
                                  search_val + %len(%trim(keywordarr(idx))));
               if search_Val = 0;
                  leave;
               endIf;
            endDo;

            If search_val > 1 ;
               IF (%trim(keywordarr(idx)) ='GROUP BY'
                or %trim(keywordarr(idx)) ='ORDER BY'
                or %trim(keywordarr(idx)) ='WHERE'
                or %trim(keywordarr(idx)) ='FETCH'
                or %trim(keywordarr(idx)) ='HAVING'                                      //SB02
                or %trim(keywordarr(idx)) ='LIMIT');                                     //SB02
                  arr2(i)  = %subst(%trim(arr2(i))  : 1 : search_Val -1);


               Else;
                  If %scan(' ' : arr2(i) : (%len(%trim(keywordarr(idx))) +1) )           //SB04
                           = 1;                                                          //SB04
                     arr2(i) = %replace ( ' '
                                       : arr2(i)
                                       : search_val
                                       : %len(%trim(keywordarr(idx))) +1 );
                  Endif;                                                                 //SB04
               Endif;
            Endif;
         elseif search_val = 1 ;
            If %scan(' ' : arr2(i) : (%len(%trim(keywordarr(idx))) +1) ) = 1;            //SB04
               arr2(i) = %replace ( ' '
                                 : arr2(i)
                                 : search_val
                                 : %len(%trim(keywordarr(idx))) +1 );
            Endif;                                                                       //SB04
         Endif;
      Endfor;

      closbrackt = %scan(')' : arr2(i));
      opnbrackt = %scan('(' : arr2(i));
      If closbrackt > 0 and opnbrackt = 0;
         arr2(i) = %replace ( ' ' : arr2(i) : closbrackt : 1);
      Endif;
   Endsr;

   Begsr MultipleValueIn;
      commapos = %scan(',' : arr2(i) :oprpos+2);
      sv_commapos = oprpos +2;
      dow commapos <> 0;
         If (commapos - sv_commapos) > 0;                                                    //SB04
            valuesarr(k) = %subst(arr2(i):sv_commapos : commapos-sv_commapos);
         Endif;                                                                              //SB04
         selpos= %scan('SELECT': valuesarr(k));

         if selpos > 0;
            selpos = %scan('SELECT': arr2(i) :sv_commapos);
            In_from = %scan('FROM': arr2(i):selpos);
            Sv_commapos = commapos;
            commapos = %scan(',' : arr2(i) :in_from + 1);
            If commapos > 0;
               If selpos > 0 and (commapos - selpos) > 0;                                    //SB04
                  valuesarr(k) = %subst(arr2(i): selpos : commapos- selpos);
               Endif;                                                                        //SB04
            Endif;
            Tmp_String  = valuesarr(k);

            Temp_arr  = GetFileFields(Tmp_String : temp_arr:arr_index:in_srcmbr);         //vm001
            for tmpi = 1 to %elem(Temp_arr);
               if Temp_arr(tmpi) = *blanks;
                  leave;
               endif;
               valuesarr(k) = temp_arr(tmpi);
               Exsr checkvaluesarr;
               k+=1;
               filefldarr(j)= filefldarr(j-1);
               j+=1;
            endfor;
         else;
            Exsr checkvaluesarr;
            k+=1;
            filefldarr(j)= filefldarr(j-1);
            j+=1;
         endif;
         sv_commapos = commapos +1;
         commapos = %scan(',' : arr2(i) :commapos +1);
      enddo;

      If commapos = 0;
         Valuesarr(k) = %subst(arr2(i) : sv_commapos);                                   //MT11
         selpos= %scan('SELECT': valuesarr(k));
         if selpos > 0;
            Tmp_String  = valuesarr(k);

            Temp_arr  = GetFileFields(Tmp_String : temp_arr:arr_index:in_srcmbr);         //vm001
            for tmpi = 1 to %elem(Temp_arr);
               if Temp_arr(tmpi) = *blanks;
                  leave;
               endif;
               valuesarr(k) = temp_arr(tmpi);
               Exsr checkvaluesarr;
               k+=1;
               filefldarr(j)= filefldarr(j-1);
               j+=1;
            endfor;
         else;
            Exsr checkvaluesarr;
            k+=1;
         endif;
      Endif;
   Endsr;

   Begsr Bracktremoval;
      opnbrackt = %scan('(': temp_arr(tmpi));
      closbrackt = %scan(')': temp_arr(tmpi));
      save = opnbrackt;
      If opnbrackt >  0 and closbrackt > 0   and
         %scan('SELECT' :temp_arr(tmpi)) = 0 and
         %scan('+': temp_arr(tmpi)) = 0      and
         %scan('-': temp_arr(tmpi)) = 0      and
         %scan('*': temp_arr(tmpi)) = 0      and
         %scan('/': temp_arr(tmpi)) = 0      and
         %scan('||': temp_arr(tmpi)) = 0 ;

         Dow opnbrackt <> 0 and opnbrackt < closbrackt;
            opnbrackt = %scan('(': temp_arr(tmpi) : opnbrackt + 1);
            if opnbrackt = 0 or opnbrackt > closbrackt;
               leave;
            endif;
            save = opnbrackt;
         Enddo;
         If (closbrackt - save) > 1;                                                         //SB04
            temp_arr(tmpi)= %subst(temp_arr(tmpi) : save + 1:
                                   closbrackt - save -1);
         Endif;                                                                              //SB04
         if %scan(':' :temp_arr(tmpi)) > 0 ;
            temp_arr(tmpi)=  %subst(temp_arr(tmpi) :
                                      %scan(':' :temp_arr(tmpi))+1);
         endif;
         if %scan(',' :temp_arr(tmpi)) > 0 and %trim(opr) <> 'IN';
            If (%scan(',' :temp_arr(tmpi)) - 1) > 0;                                         //SB04
               temp_arr(tmpi)=  %subst(temp_arr(tmpi) : 1 :
                                      %scan(',' :temp_arr(tmpi)) - 1);
            Endif;                                                                           //SB04
         endif;
      endif;
      if opnbrackt > 0 and closbrackt = 0;
         temp_arr(tmpi) = %subst(temp_arr(tmpi) : opnbrackt +1);
      endif;
      temp_arr(tmpi) = %trim(temp_arr(tmpi));
   Endsr;

end-proc;

Dcl-Proc GroupByProc  export;
   Dcl-PI GroupByProc;
      pi_in_str Char(5000);                                                              //0015
      pi_MTHD CHAR(1);
      // in_SrcLib char(10) options(*nopass);                                            //0062
      // in_SrcPf  char(10) options(*nopass);                                            //0062
      // in_SrcMbr char(10) options(*nopass);                                            //0062
      in_UwSrcDtl likeds(uWSrcDtl) options(*nopass);                                     //0062
      in_RrnS   packed(6:0) options(*nopass);
      in_RrnE   packed(6:0) options(*nopass);
   End-PI;

   dcl-s FIELD_ARRAY    Char(50) Dim(250);
   dcl-s string          char(500);                                                      //MT01
   dcl-s DELIMITER       char(1)    inz(',');                                             //SK15
   dcl-s in_srcpf        char(10);                                                        //0062
   dcl-s casestring      char(500);                                                       //SK15
   dcl-s casestring1     char(500);                                                       //SK15
  //dcl-s in_str          char(1550);                                                    //0028
   dcl-s in_str          char(5000);                                                     //0028
   dcl-s sub1            char(140);
   dcl-s sub2            char(140);
   dcl-s sub5            char(1000);                                                      //SK15
   dcl-s sub10           char(140);                                                       //SK15
   dcl-s TEMP_ARRAY      char(500) dim(100);                                              //SK15
   dcl-s TEMP_ARRAY1     char(500) dim(100);                                              //SK15
   dcl-s temp_i          packed(4:0);                                                     //SK15
   dcl-s temp_j          packed(4:0);                                                     //SK15
   dcl-s group_var       char(9)   inz('GROUP BY');
   dcl-s order_var       char(9)   inz('ORDER BY');
   dcl-s HAVING_Var      char(7)   inz('HAVING');
   dcl-s INTO_Var        char(4) inz('INTO');
   dcl-s grparry         char(50) dim(100);
   dcl-s vararr          char(50) dim(100);
   dcl-S MTHD            CHAR(1);
   dcl-s IN_RESRCLIB     char(10);
   dcl-s IN_RESRCFLN     char(10);
   dcl-s IN_REPGMNM      char(10);
   dcl-s IN_REIFSLOC     char(100);                                                      //0062
   dcl-s IN_REROUTINE    char(80);
   dcl-s IN_RERELTYP     char(10);
   dcl-s IN_RERELNUM     char(10);
   dcl-s IN_REOPC        char(10) inz('SQLEXC');
   dcl-s IN_RERESULT     char(50);
   dcl-s IN_BIF          char(10);
   dcl-s IN_REFACT1      char(80);
   dcl-s IN_RECOMP       char(10);
   dcl-s IN_REFACT2      char(80);
   dcl-s IN_RECONTIN     char(10);
   dcl-s IN_RERESIND     char(06);
   dcl-s IN_RECAT1       char(1);
   dcl-s IN_RECAT2       char(1);
   dcl-s IN_RECAT3       char(1);
   dcl-s IN_RECAT4       char(1);
   dcl-s IN_RECAT5       char(1);
   dcl-s IN_RECAT6       char(1);
   dcl-s IN_REUTIL       char(10);
   dcl-s IN_REEXC        char(1);
   dcl-s IN_REINC        char(1);
   dcl-s exact_rrn   packed(6:0);                                                        //MT01
   dcl-s IN_RESEQ    packed(6:0);
   dcl-s IN_RERRN    packed(6:0);
   dcl-s LNGHT       packed(4:0);
   dcl-s I           packed(4:0) inz(1);
   dcl-s T           packed(4:0);
   dcl-s COUNT       packed(4:0) INZ(1);
   dcl-s POS         packed(4:0);
   dcl-s postemp     packed(4:0);
   dcl-s possemicln  packed(4:0);
   dcl-s poscomma    packed(4:0);
   dcl-s poscomma1   packed(4:0);
   dcl-s posbrck     packed(4:0);
   dcl-s posopnbrk   packed(4:0);
   dcl-s posopnbrk1  packed(4:0);
   dcl-s poshaving   packed(4:0);
   dcl-s posclsbrk   packed(4:0);
   dcl-s posclsbrk1  packed(4:0);
   dcl-s posorderby  packed(4:0);
   dcl-s COMMATEMP   packed(4:0);
   dcl-s COMMATEMP1  packed(4:0);
   dcl-s TEMPINTO    packed(4:0);
   dcl-s TEMPSELECT  packed(4:0);
   dcl-s posby       packed(4:0);
   dcl-S tempdot     packed(4:0);
   dcl-s posorder    packed(4:0);
   dcl-S posin_str   packed(4:0);
   dcl-S posordern   packed(4:0);
   dcl-S tempordr    packed(4:0);
   dcl-S tempclsbrk  packed(4:0);
   dcl-S tempclsbrk1 packed(4:0);
   dcl-S posKEYDSC   packed(4:0);
   dcl-S posKEYASC   packed(4:0);
   dcl-S TEMPSMCLN   packed(4:0);
   dcl-s pos_dup     packed(4:0);
   dcl-s pos_char    packed(4:0);
   dcl-s pos_nmrc    packed(4:0);
   dcl-s IN_RENUM1   packed(5:0);
   dcl-s IN_RENUM2   packed(5:0);
   dcl-s IN_RENUM3   packed(5:0);
   dcl-s IN_RENUM4   packed(5:0);
   dcl-s IN_RENUM5   packed(5:0);
   dcl-s IN_RENUM6   packed(5:0);
   dcl-s IN_RENUM7   packed(5:0);
   dcl-s IN_RENUM8   packed(5:0);
   dcl-s IN_RENUM9   packed(5:0);

   dcl-c sq_quote     '''';                                                              //MT01

   uwSrcDtl = in_uWSrcDtl;                                                               //0062
   in_srcpf = in_srcspf;                                                                 //0062
   in_str = pi_in_str;
   mthd = pi_mthd;
   lnght=%LEN(%TRIM(in_str));
   in_str=%replace(';':in_str:lnght+1);

   select;
   when mthd='1';
      exsr grpbysr;
   when mthd='2';
      exsr ordrbysr;
   endsl;

   lnght=%LEN(%TRIM(in_str));

   IF %SCAN(';':IN_STR)<>0;
      in_str=%replace(' ':in_str:lnght);
   ENDIF;

   t=i;

   for i=1 to t-1;
      Exsr rmvAlias;                                                                     //MT13
      in_RERESULT=grparry(i);
      in_REFACT2 = grparry(i);
      in_RESRCLIB = in_SrcLib;
      in_RESRCFLN = in_SrcPf;
      in_REPGMNM = in_SrcMbr;
      in_REIFSLOC = in_ifsloc;                                                           //0062
      in_RESEQ = in_RrnS;                                                                //MT01

      If in_ifsloc = *Blanks;                                                            //0062
      string  = 'Select SOURCE_RRN   ' +                                                 //MT01
                'from   IAPGMREF '+                                                      //MT01
                'where LIBRARY_NAME = ' + sq_quote + %trim(in_srclib)                    //0002
                + sq_quote +  ' and  SRC_PF_NAME = ' + sq_quote +                        //MT01
                 %trim(In_srcpf) + sq_quote +                                            //MT01
                ' and MEMBER_NAME  = ' +  sq_quote +  %trim(in_srcmbr)                   //MT01
                + sq_quote +                                                             //0002
                ' and SOURCE_RRN between ' + %trim(%char(in_rrns)) +                     //0002
                ' and ' +  %trim(%char(in_rrne)) +                                       //0002
                ' and  SOURCE_WORD  like ' + sq_quote                                    //0002
                + '%' +  %trim(in_REFACT2)  + '%' +  sq_quote +                          //MT01
                ' fetch first row only ';                                                //MT01
      else;                                                                              //0062
      string  = 'Select SOURCE_RRN   ' +                                                 //0062
                'from   IAPGMREF '+                                                      //0062
                'where IFS_LOCATION = ' + sq_quote + %trim(in_ifsloc)                    //0062
                + sq_quote +                                                             //0062
                ' and MEMBER_NAME  = ' +  sq_quote +  %trim(in_srcmbr)                   //0062
                + sq_quote +                                                             //0062
                ' and SOURCE_RRN between ' + %trim(%char(in_rrns)) +                     //0062
                ' and ' +  %trim(%char(in_rrne)) +                                       //0062
                ' and  SOURCE_WORD  like ' + sq_quote                                    //0062
                + '%' +  %trim(in_REFACT2)  + '%' +  sq_quote +                          //0062
                ' fetch first row only ';                                                //0062
      endif;

      exec sql PREPARE SqlSTMT FROM :string;                                             //MT01
      exec sql declare rrnCur cursor for sqlstmt;                                        //MT01
      exec sql open rrnCur;                                                              //MT01
      exec sql fetch from rrnCur into :exact_rrn;                                        //MT01
      exec sql close rrnCur;                                                             //MT01

      if exact_rrn = 0;                                                                  //MT01
         exact_rrn = in_rrne;                                                            //MT01
      endif;                                                                             //MT01

      in_RERRN = exact_rrn;                                                              //MT01

      callp IAVARRELLOG(in_RESRCLIB:
                        in_RESRCFLN:
                        in_REPGMNM:
                        in_REIFSLOC:                                                     //0062
                        in_RESEQ:
                        in_RERRN:
                        in_REROUTINE:
                        in_RERELTYP:
                        in_RERELNUM:
                        in_REOPC:
                        in_RERESULT:
                        in_bif:
                        in_REFACT1:
                        in_RECOMP:
                        in_REFACT2:
                        in_RECONTIN:
                        in_RERESIND:
                        in_RECAT1:
                        in_RECAT2:
                        in_RECAT3:
                        in_RECAT4:
                        in_RECAT5:
                        in_RECAT6:
                        in_REUTIL:
                        in_RENUM1:
                        in_RENUM2:
                        in_RENUM3:
                        in_RENUM4:
                        in_RENUM5:
                        in_RENUM6:
                        in_RENUM7:
                        in_RENUM8:
                        in_RENUM9:
                        in_REEXC:
                        in_REINC);
   endfor;
   Begsr grpbysr;
       Pos=%scan(group_var:in_str);
       If pos=0;
          Leavesr;
       Endif;
       PosHAVING=%scan(HAVING_Var:in_str:POS);
       Possemicln=%scan(';':in_str);
       Poscomma=%scan(',':in_str:pos+9);
       Posbrck=%scan(')':in_str:pos+9);
       Posorder=%scan(order_var:in_str:pos+9);
       Poscomma1=poscomma;
       Dou pos=0;
          Dou poscomma=0 ;
             IF posbrck > pos;
                IF (
                   poshaving>0) OR (POSORDER>0 AND POSORDER<POSBRCK);
                   IF  Poshaving > 0 and poshaving-pos-9 > 0;
                      Sub5=%subst(in_str:POS+9:poshaving-pos-9);
                      Poscomma=%scan(',':sub5);
                      POSCOMMA1=POSCOMMA;
                      EXSR HAVINGSR;
                      posHAVING=%scan(HAVING_Var:in_str:POShaving+5);
                   ELSEIF POSORDER > 0 and POSORDER-POS-9 > 0;
                      SUB5=%SUBST(in_str:POS+9:POSORDER-POS-9);
                      POSCOMMA=%SCAN(',':SUB5);
                      POSCOMMA1=POSCOMMA;
                      EXSR HAVINGSR;
                      posHAVING=%scan(HAVING_Var:in_str:POShaving+5);
                      leave;
                   ENDIF;
                else;
                   if postemp > 0 and posbrck-POS-9 > 0;
                      SUB5=%SUBST(in_str:POS+9:posbrck-POS-9);
                   else;
                      if POSORDER<>0;
                         if commatemp<POSTEMP and commatemp<postemp
                            AND TEMPSELECT=0;
                            exsr lastbrck;
                         endif;
                         if POSORDER-POS-9 > 0;
                            SUB5=%SUBST(in_str:POS+9:POSORDER-POS-9);
                            sub5=%trim(sub5);
                         endif;
                      elseif possemicln-POS-9 > 0;
                         SUB5=%SUBST(in_str:POS+9:possemicln-POS-9);
                      endif;
                endif;
                POSCOMMA=%SCAN(',':SUB5);
                POSCOMMA1=POSCOMMA;
                EXSR HAVINGSR;
             endif;
          ENDIF;
          if possemicln>poscomma and posbrck=0 ;
             if POSORDER > 0 and POSORDER-POS-9 > 0;
                SUB5=%SUBST(in_str:POS+9:POSORDER-POS-9);
             elseif possemicln-POS-9 > 0;
                SUB5=%SUBST(in_str:POS+9:possemicln-POS-9);
             endif;
             POSCOMMA=%SCAN(',':SUB5);
             POSCOMMA1=POSCOMMA;
             exsr havingsr;
             leave;
          endif;
       enddo;
       pos=%scan(group_var:in_str:pos+10);
       if poshaving > 0;
          posHAVING=%scan(HAVING_Var:in_str:poshaving+6);
       endif;

       if pos > 0;
          poscomma=%scan(',':in_str:pos+10);
          poscomma1=poscomma;
          posbrck=%scan(')':in_str:pos+10);
          Posorder=%scan(order_var:in_str:pos+10);                                       //0015
       else;
          leave;
       endif;
    enddo;
    endsr ;

    begsr notbrckt;
       if poscomma1=poscomma;
          clear sub1;
          if poscomma = 0 and possemicln-pos-9 > 0;
             sub1=%subst(in_str:pos+9:possemicln-pos-9);
             exsr   hvngordr;
          elseif poscomma-pos-9 > 0;
             sub1=%subst(in_str:pos+9:poscomma-pos-9);
             exsr   hvngordr;
           endif;
           grparry(i)=%triml(sub2);
           i=i+1;
       else;
          clear sub1;
          if poscomma1 > 0 and poscomma-poscomma1-1 > 0;
             sub1=%subst(in_str:poscomma1+1:poscomma-poscomma1-1);
             exsr   hvngordr;
          endif;
          grparry(i)=%triml(sub2);
          i=i+1;
       endif;
    endsr;

    Begsr Havingsr;                                                                       //SK15
                                                                                          //SK15
       TEMP_ARRAY = GetDelimiterValue(%TRIM(SUB5): Delimiter);                            //SK15
       TEMP_I=1;                                                                          //SK15
       TEMP_j=1;                                                                          //SK15
                                                                                          //SK15
       DOW TEMP_I <= %elem(TEMP_ARRAY) and TEMP_ARRAY(TEMP_I)<>*blank;                    //SK15
           if temp_array(temp_i)=*blank;                                                  //SK15
              leave;                                                                      //SK15
           endif;                                                                         //SK15
        if %scan(' CASE ':%trim(temp_array(temp_i)))<>0;                                  //SK15
           casestring=%trim(temp_array(temp_i));                                          //SK15
           casestring1 = ProcessCase(casestring);                                         //SK15
           TEMP_ARRAY1 = GetDelimiterValue(%TRIM(casestring1): Delimiter);                //SK15
           DOW TEMP_j < %elem(TEMP_ARRAY1) and TEMP_ARRAY1(TEMP_j)<>*blank;               //SK15
               if temp_array1(temp_j)=*blank;                                             //SK15
                  leave;                                                                  //SK15
               endif;                                                                     //SK15
               sub1=IsVariableOrConst(%trim(TEMP_ARRAY1(TEMP_j)));                        //SK15
               if %scan('CONST(':%TRIM(SUB1))<>0;                                         //SK15
                  sub2=sub1;                                                              //SK15
               else;                                                                      //SK15
                  exsr hvngordr;                                                          //SK15
               endif;                                                                     //SK15
               grparry(i)=%triml(sub2);                                                   //SK15
               i=i+1;                                                                     //SK15
               temp_j=temp_j+1;                                                           //SK15
           enddo;                                                                         //SK15
           temp_j =1;                                                                     //SK15
        else;                                                                             //SK15
           sub1=TEMP_ARRAY(TEMP_i);                                                       //SK15
           exsr hvngordr;                                                                 //SK15
           grparry(i)=%triml(sub2);                                                       //SK15
           i=i+1;                                                                         //SK15
        endif;                                                                            //SK15
        temp_i=temp_i+1;                                                                  //SK15
      enddo;                                                                              //SK15
      POSCOMMA=0 ;                                                                        //SK15
      POSCOMMA1=POSCOMMA;                                                                 //SK15
    endsr;                                                                                //SK15

   begsr hvngordr;
      poshaving=%scan('HAVING':sub1);
      posorderby=%scan('order by':sub1);
      posin_str=%scan(' ':%triml(sub1));
      posopnbrk=%scan('(':%triml(sub1));
      posclsbrk=%scan(')':%triml(sub1));
      if posin_str<>0;
         if posopnbrk<>0;
            exsr opnbrk;
            sub1=%subst(%TRIML(sub1):posopnbrk1+1);
         endif;
         if posclsbrk > 1;
            exsr clsbrk;
            sub1=%subst(sub1:1:posclsbrk-1);
            posin_str=posclsbrk;
         endif;
         exsr dotsr;
         if posin_str > 1;
           sub2=%subst(sub1:1:posin_str-1);
         endif;
      else;
         if posopnbrk<>0;
            exsr opnbrk;
            sub1=%subst(sub1:posopnbrk1+1);
         endif;
         if posclsbrk>1;
            exsr clsbrk;
            sub1=%subst(sub1:1:posclsbrk-1);
         endif;
         exsr dotsr;
         sub2=sub1;
      endif;
   endsr;
   begsr opnbrk;
      dow posopnbrk<>0;
         posopnbrk1=posopnbrk;
         posopnbrk=%scan('(':%triml(sub1):posopnbrk+1);
      enddo;
   endsr;

   begsr clsbrk;
      posclsbrk=%scan(')':%trimR(sub1):1);
   endsr;
   BEGSR SMCLNSR;
      TEMPSMCLN=%SCAN(';':%TRIM(SUB1):1);
      IF TEMPSMCLN>1;
         SUB1=%SUBST(SUB1:1:TEMPSMCLN-1);
      ELSE;
         LEAVESR;
      ENDIF;
   ENDSR;

   begsr lastbrck;
      commatemp=%scan(',':in_str:pos+9);
      TEMPINTO=%scan(INTO_VAR:in_str:pos+9);
      dow COMMATEMP>0 and commatemp<POSTEMP;
         IF TEMPINTO>0 AND TEMPINTO<POSTEMP;
            commatemp1=commatemp;
            tempclsbrk1=tempclsbrk;
            tempclsbrk=%scan(')':in_str:commatemp1+1);
            commatemp=%scan(',':in_str:commatemp1+1);
         IF (COMMATEMP>TEMPINTO AND COMMATEMP<>0) OR COMMATEMP>POSTEMP;
            LEAVE;
         ENDIF;
         ELSE;
         IF COMMATEMP<POSTEMP AND COMMATEMP>POS ;
            commatemp1=commatemp;
            tempclsbrk1=tempclsbrk;
            tempclsbrk=%scan(')':in_str:commatemp1+1);
            commatemp=%scan(',':in_str:commatemp1+1);
            IF COMMATEMP>POSTEMP;
               LEAVE;
            ENDIF;
         ENDIF;
      ENDIF;
   enddo;
      if tempclsbrk<postemp ;
         posbrck=tempclsbrk ;
      endif;
   endsr;
   begsr dotsr;
      tempdot=%scan('.':%trim(sub1));
     if tempdot>0;
        sub1=%subst(sub1:tempdot+1);
      endif;
   endsr;

   begsr ordrbysr;
      posordern=%scan(order_vAR:in_str);
      possemicln=%scan(';':in_str);
      poscomma=%scan(',':in_str:posordern+5);
      posbrck=%scan(')':in_str:posordern+5);
      poscomma1=poscomma;
      doW posordern > 0;
         dou poscomma=0;
            tempordr=%scan(oRder_var:in_str:posordern+8);
            if tempoRdr=0;
               if poscomma>0 and possemicln>posordern;
                  sub5=%subst(in_str:posordern+8:possemicln-posordern);
                  sub5=%trim(sub5);
                  POSCOMMA=%SCAN(',':SUB5);
                  POSCOMMA1=POSCOMMA;
                  exsr HAVINGSR1 ;
               ELSEIF possemicln>posordern;
                  sub5=%subst(in_str:posordern+8:possemicln-posordern);
                  sub5=%trim(sub5);
                  POSCOMMA=%SCAN(',':SUB5);
                  POSCOMMA1=POSCOMMA;
                  exsr HAVINGSR1 ;
               endif;
            ELSE;
               commatemp=%SCAN(',':in_str:posordern+8);
               IF commatemp<>0 AND commatemp<TEMPORDR AND
               commatemp>posordern;
               EXSR LASTBRCKT;
            ENDIF;
            If posBRCK>posordern;
              sub5=%subst(in_str:posordern+8:posBRCK-posordern);
              sub5=%trim(sub5);
              POSCOMMA=%SCAN(',':SUB5);
              POSCOMMA1=POSCOMMA;
              exsr HAVINGSR1;
            endif;
         endif;
      enddo;
      posordern=%scan(ORDER_var:in_str:posordern+8);
      poscomma=%scan(',':in_str:posordern+8);
      poscomma1=poscomma;
    //posbrck=%scan(')':in_str:pos+10);                                                  //0028
      posbrck=%scan(')':in_str:posordern+10);                                            //0028
      if posORDERN=0;
         leave;
      endif;
      enddo;
   endsr;

   BEGSR HAVINGSR1;

      TEMP_ARRAY = GetDelimiterValue(%TRIM(SUB5): Delimiter);                             //SK15
      TEMP_I=1;                                                                           //SK15
      TEMP_j=1;                                                                           //SK15

      dow TEMP_I < %elem(TEMP_ARRAY) and TEMP_ARRAY(TEMP_I) <> *blank;                    //SK15
          if temp_array(temp_i) = *blank;                                                 //SK15
             leave;                                                                       //SK15
          endif;                                                                          //SK15
          if %scan(' CASE ' : %trim(temp_array(temp_i))) <>0;                             //SK15
             casestring  = %trim(temp_array(temp_i));                                     //SK15
             casestring1 = ProcessCase(casestring);                                       //SK15
             TEMP_ARRAY1 = GetDelimiterValue(%TRIM(casestring1): Delimiter);              //SK15
             DOW TEMP_j < %elem(TEMP_ARRAY1) and TEMP_ARRAY1(TEMP_j) <> *blank;           //SK15
                 if temp_array1(temp_j) = *blank;                                         //SK15
                    leave;                                                                //SK15
                 endif;                                                                   //SK15
                 sub1 = IsVariableOrConst(%trim(TEMP_ARRAY1(TEMP_j)));                    //SK15
                 if %scan('CONST(':%TRIM(SUB1)) <> 0;                                     //SK15
                    sub2 = sub1;                                                          //SK15
                 else;                                                                    //SK15
                    exsr hvngordr1;                                                       //SK15
                 endif;                                                                   //SK15
                 pos_dup = %lookup(sub2:grparry);                                         //SK15
                 if pos_dup = 0;                                                          //SK15
                    grparry(i) = %triml(sub2);                                            //SK15
                    i = i+1;                                                              //SK15
                 endif;                                                                   //SK15
                 temp_j = temp_j+1;                                                       //SK15
             enddo;                                                                       //SK15
          else;                                                                           //SK15
             sub1 = TEMP_ARRAY(TEMP_i);                                                   //SK15
             exsr hvngordr1;                                                              //SK15
             pos_dup = %lookup(sub2:grparry);                                             //SK15
             if pos_dup = 0;                                                              //SK15
                grparry(i) = %triml(sub2);                                                //SK15
                i = i+1;                                                                  //SK15
             endif;                                                                       //SK15
          endif;                                                                          //SK15
          temp_i = temp_i+1;                                                              //SK15
      enddo;                                                                              //SK15
      POSCOMMA=0 ;                                                                        //SK15
      POSCOMMA1=POSCOMMA;                                                                 //SK15
   ENDSR;

 begsr hvngordr1;
    poshaving=%scan('HAVING':sub1);
    posorderby=%scan('order by':sub1);
    posin_str=%scan(' ':%triml(sub1));
    posopnbrk=%scan('(':%triml(sub1));
    posclsbrk=%scan(')':%triml(sub1));
    if posin_str<>0;
       if posopnbrk<>0;
          exsr opnbrk;
          sub1=%subst(%TRIML(sub1):posopnbrk1+1);
       endif;
       if posclsbrk>1;
          exsr clsbrk;
          sub1=%subst(sub1:1:posclsbrk-1);
          posin_str=posclsbrk;
       endif;
       exsr SMCLNSR ;
       EXSR Chckaphbt;
       if posin_str>1;
          sub2=%subst(sub1:1:posin_str-1);
       else;
          sub2=sub1;
       endif;
    else;
       if posopnbrk<>0;
          exsr opnbrk;
          EXSR KEYWRDSR;
          sub1=%subst(sub1:posopnbrk1+1);
        endif;
        if posclsbrk>1;
           exsr clsbrk;
           sub1=%subst(sub1:1:posclsbrk-1);
           EXSR KEYWRDSR;
        endif;
        EXSR SMCLNSR;
        EXSR Chckaphbt;
        sub2=sub1;
     endif;
  endsr;

  BEGSR KEYWRDSR;
     posKEYDSC=%scan('DESC':%triml(sub1));
   //posKEYASC=%scan('AESC':%triml(sub1));                                               //0028
     posKEYASC=%scan('ASC':%triml(sub1));                                                //0028
     LNGHT=%LEN(%TRIM(SUB1));
     IF posKEYDSC>0 and LNGHT>posKEYDSC;
        SUB1=%SUBST(SUB1:1:LNGHT-posKEYDSC);
     ELSEIF  posKEYASC>0 and LNGHT>posKEYASC;
        SUB1=%SUBST(SUB1:1:LNGHT-posKEYASC);
     ENDIF;
  ENDSR;
  BEGSR LASTBRCKT;
     commatemp=%scan(',':in_str:posORDERN+8);
     dow commatemp<TEMPORDR AND COMMATEMP>POSORDERN;
        commatemp1=commatemp;
        tempclsbrk=%scan(')':in_str:commatemp1+1);
        commatemp=%scan(',':in_str:commatemp1+1);
     enddo;
     if tempclsbrk<TEMPORDR AND TEMPCLSBRK>POSORDERN;
        posbrck=tempclsbrk;
     endif;
  ENDSR;

  Begsr Chckaphbt;
     pos_char=%check('ABCDEFGHIJKLMNOPQRSTUVWXYZ':%TRIM(SUB1));
     POS_NMRC=%CHECK('123456789':%TRIM(SUB1));
     IF POS_CHAR=0 AND POS_NMRC=0;
     ELSEIF POS_CHAR>0 AND POS_NMRC=0;
        Field_Array = GetFileFields(in_Str : Field_Array:arr_index:in_SrcMbr);            //vm001
        IF %DECH(SUB1:4:0)<=ARR_INDEX+1;
           SUB1=FIELD_ARRAY(%DECH(SUB1:4:0));
           posin_str=%scan(' ':%trim(sub1):1);
        ELSE;
        ENDIF;
     ENDIF;
  endsr;

  Begsr rmvAlias;                                                                        //MT13
     If %scan('.' : grparry(i)) > 0;                                                     //MT13
        grparry(i) = %subst(grparry(i) : %scan('.' : grparry(i)) + 1);                   //MT13
     Endif;                                                                              //MT13
  Endsr;                                                                                 //MT13

END-PROC;


dcl-proc IAEXCPLOG;
   dcl-pi  IAEXCPLOG;
      in_srclib char(10) const options(*trim);                                           //OJ01
      in_srcspf char(10) const options(*trim);                                           //OJ01
      in_srcmbr char(10) const options(*trim);                                           //OJ01
      in_lib char(10)    const options(*trim);                                           //OJ01
      in_ProcNme char(10)  const options(*trim);                                         //OJ01
      in_ExcptTyp char(3)  const options(*trim);                                         //OJ01
      in_ExcptNbr char(4)   const options(*trim);                                        //OJ01
      in_RtvExcptDt char(80)  const options(*trim);                                      //OJ01
      in_ModulePGM  char(10)  const options(*trim);                                      //OJ01
      in_ModuleProc char(10)  const options(*trim);                                      //OJ01
   end-pi;

   exec sql
   insert into IAEXCPLOG (PRS_SOURCE_LIB,
                          PRS_SOURCE_FILE,
                          PRS_SOURCE_SRC_MBR,
                          LIBRARY_NAME,
                          PROGRAM_NAME,
                          EXCEPTION_TYPE,
                          EXCEPTION_NO,
                          EXCEPTION_DATA,
                          MODULE_PGM,
                          MODULE_PROC)
                   values(:in_srclib ,                                                   //OJ01
                          :in_srcspf ,                                                   //OJ01
                          :in_srcmbr ,                                                   //OJ01
                          :in_Lib ,                                                      //OJ01
                          :in_ProcNme ,                                                  //OJ01
                          :in_ExcptTyp ,                                                 //OJ01
                          :in_ExcptNbr ,                                                 //OJ01
                          :in_RtvExcptDt ,                                               //OJ01
                          :in_ModulePGM ,                                                //OJ01
                          :in_ModuleProc );                                              //OJ01
end-proc;

dcl-proc ProcessCreateSql export;                                                        //YK02
   dcl-pi *n;
      in_Str     char(5000) value options(*trim);                                        //OJ01
      in_repoLib char(10) value options(*trim);                                          //OJ01
      // in_srclib  char(10)  options(*nopass);                                          //0062
      // in_srcpf   char(10)  options(*nopass);                                          //0062
      // in_srcmbr  char(10)  options(*nopass);                                          //0062
      in_uwSrcDtl likeds(uwSrcDtl) options(*nopass);                                     //0062
   end-pi;

   //Data structure to hold table information
   dcl-ds tblInfoDs qualified dim(100);
      objSqlName  varChar(128);
      objSysName  char(10);
      sqlFldName  varChar(128);
      sysFldName  char(10);
      fldDataType char(10);
      fldLength   packed(9:0);
      fldDecPos   packed(9:0);
   end-ds;

   dcl-ds tblInfo;
      objSqlName  varChar(128);
      objSysName  char(10);
      sqlFldName  varChar(128);
      sysFldName  char(10);
      fldDataType char(10);
      fldLength   packed(9:0);
      fldDecPos   packed(9:0);
   end-ds;

   dcl-s crtStatement    char(5000);
   dcl-s extractWord     char(100);
   dcl-s fileExist       char(1);
   dcl-s libName         char(10);
   dcl-s objType         char(10);
   dcl-s sqlStmt         char(5000);                                                     //MT01
   dcl-s tblSchema       char(10);
   dcl-s fileName        varChar(128);
   dcl-s endPos          packed(5:0);
   dcl-s createPos       packed(5:0);
   dcl-s index           packed(5:0);
   dcl-s openBracketPos  packed(5:0);
   dcl-s seperatorPos    packed(5:0);
   dcl-s startPos        packed(5:0);
   dcl-s in_srcpf        char(10);                                                       //0062

   dcl-c createTable     const('CREATE TABLE');
   dcl-c createOrReplace const('CREATE OR REPLACE TABLE');

   crtStatement = in_Str;                                                                //OJ01
   uwSrcDtl = in_uwSrcDtl;                                                               //0062
   in_srcpf = in_srcspf;                                                                 //0062

   //Validating for CREATE TABLE or CREATE OR REPLACE table statement
   select;
   when %scan( createTable: crtStatement: 1 ) = 1;
      createPos = %len(createTable) + 1;
      objType   = 'CREATE TBL';
   when %scan( createOrReplace: crtStatement: 1 ) = 1;
      createPos = %len(createOrReplace) + 1;
      objType   = 'CREATE TBL';
   other;
      return;
   endSl;

   //Start position for LIBRARYNAME[./]FILENAME
   startPos = %check( ' ': crtStatement: createPos );
   if startPos > 1;

      //End position for LIBRARYNAME[./]FILENAME
      endPos = %scan( ' ': crtStatement: startPos );
      openBracketPos = %scan( '(': crtStatement: startPos );
      if endPos > 1 and openBracketPos > 1 and openBracketPos < endPos;
         endPos = openBracketPos;
      endIf;

      //Extracted word will be LIBRARYNAME[./]FILENAME or FILENAME
      if endPos > startPos;
         extractWord = %subst(  crtStatement:
                                startPos:
                                endPos-startPos  );
      endIf;
   else;
      return;
   endIf;

   if %scan( '"': extractWord ) > 0;
      extractWord = %scanRpl( '"': '': extractWord );
   endIf;

   //Getting seperator position in extracted word
   select;
   when %scan( '.': extractWord ) > 1;
      seperatorPos = %scan( '.': extractWord );
   when %scan( '/': extractWord ) > 1;
      seperatorPos = %scan( '/': extractWord );
   other;
      clear seperatorPos;
   endSl;

   if seperatorPos > 1;
      libName  = %subst( extractWord: 1: seperatorPos-1 );
      fileName = %subst( extractWord: seperatorPos+1 );

      //Checking table if exists in given library of statement
      if libName <> 'QTEMP';
         exec sql
           select 'Y' into :fileExist
           from sysColumns
           where TABLE_NAME = trim(:fileName)
             and TABLE_SCHEMA = trim(:libName)
           limit 1;
      endIf;
   else;
      fileName = %trim(extractWord);
   endIf;

   if fileExist <> 'Y';
      //Checking if table exist in repository library
      exec sql
        select 'Y' into :fileExist
         from sysColumns
         where TABLE_NAME = trim(:fileName)
           and TABLE_SCHEMA = :in_repoLib                                                //OJ01
         limit 1;

      if fileExist <> 'Y';

         //Replacing existing library in statement to repository library
         //in_repoLib = %trim(in_repoLib);                                               //OJ01
         if libName <> *blanks;
            sqlStmt = %replace(  in_repoLib:                                             //OJ01
                                 crtStatement:
                                 startPos:
                                 %len( %trim(libName) )  );
         else;
            sqlStmt = %subst( crtStatement: 1: startPos-1 ) +
                      in_repoLib + '.' +                                                 //OJ01
                     %subst( crtStatement: startPos );
         endIf;

         //Replacing OR REPLACE with blank
         if %scan( ' OR REPLACE ': sqlStmt ) > 6;
            sqlStmt = %scanRpl( ' OR REPLACE ': ' ': sqlStmt );
         endIf;

         //Replacing WITH DATA with blank
         if %scan( 'WITH DATA': sqlStmt ) > 1;
            sqlStmt = %scanRpl( 'WITH DATA'    :
                                'WITH NO DATA' :
                                sqlStmt      );
         endIf;

         exec sql execute immediate :sqlStmt;
         clear sqlStmt;

      endIf;

      tblSchema = in_repoLib;                                                            //OJ01

   else;
      tblSchema = %trim(libName);
   endIf;

   //SqlCod will be 7905 for table created but not journaled
   if sqlCod = 0 or sqlCod = 7905;

      // Declaring cursor to get table information
      exec sql
        declare tblInfoCsr cursor for
         select IFNULL( TABLE_NAME, ' ' ),
                IFNULL( SYSTEM_TABLE_NAME, ' ' ),
                IFNULL( COLUMN_NAME, ' ' ),
                IFNULL( SYSTEM_COLUMN_NAME, ' ' ),
                IFNULL( DATA_TYPE, ' ' ),
                IFNULL( LENGTH, 0 ),
                IFNULL( NUMERIC_SCALE, 0 )
         from syscolumns
         where TABLE_NAME = :fileName
           and TABLE_SCHEMA = :tblSchema;

      exec sql open tblInfoCsr;
      if sqlCod = 0;
         exec sql
           fetch from tblInfoCsr for 100 rows into :tblInfoDs;
      endIf;
      exec sql close tblInfoCsr;

      //Drop table in repository library if created in this pgm
      if fileExist <> 'Y';
         sqlStmt = 'drop table ' +
                    in_repoLib + '/' +                                                   //OJ01
                    %trim(fileName) ;
         exec sql execute immediate :sqlStmt;
      endIf;

   endIf;

   //Writing records into IAESQLFFD
   for index = 1 to %elem(tblInfoDs);
      if tblInfoDs(index).objSysName = *blanks;
         leave;
      endIf;

      tblInfo = tblInfoDs(index);

      exec sql
        insert into IAESQLFFD ( CSRCLIB,
                                CSRCFLN,
                                CPGMNM,
                                CIFSLOC,                                                 //0062
                                COBJTYPE,
                                COBJSQLNM,
                                COBJSYSNM,
                                CFLDSQLNM,
                                CFLDSYSNM,
                                CFLDTYP,
                                CFLDLEN,
                                CFLDDEC )
          values (:in_srclib,
                  :in_srcpf,
                  :in_srcmbr,
                  :in_ifsloc,                                                            //0062
                  :objType,
                  :objSqlName,
                  :objSysName,
                  :sqlFldName,
                  :sysFldName,
                  :fldDataType,
                  :fldLength,
                  :fldDecPos  );

   endFor;

   return;

end-proc;

// Procedure for handing CASE clause in Sql parse                                        //0035
dcl-proc ProcessCase  Export ;                                                           //0035

   dcl-pi ProcessCase char(500) ;                                                        //0035
      in_Str      char(500) const options(*trim);                                        //0035
   End-pi;                                                                               //0035

   Dcl-s poswhen         packed(4:0);                                                    //0035
   Dcl-s poselse         packed(4:0);                                                    //0035
   Dcl-s poSend          packed(4:0) ;                                                   //0035
   Dcl-s SOURCE          char(500);                                                      //0035
   Dcl-s SOURCE1         char(500);                                                      //0035
   Dcl-s SOURCE2         char(500);                                                      //0035
   Dcl-s SOURCE3         char(500);                                                      //0035
   Dcl-s COUNT3          packed(5:0);                                                    //0035
   Dcl-s string3         char(5000) ;                                                    //0035
   Dcl-s casevalue       char(50) ;                                                      //0035
   Dcl-s casearray       char(50)     dim(250) ;                                         //0035
   Dcl-s poscomma        packed(4:0);                                                    //0035
   Dcl-s TEMPcomma       packed(4:0)  dim(40) ascend;                                    //0035
   Dcl-s ArrayIndex      packed(4:0) ;                                                   //0035
   Dcl-s FillIndex       packed(4:0) ;                                                   //0035
   Dcl-s TEMP_ARRAY      char(500)    dim(100);                                          //0035
   Dcl-s TEMPARRAY       char(500)    dim(100);                                          //0035
   Dcl-s string4         char(5000) ;                                                    //0035
   Dcl-s comma           packed(4:0)  dim(40) ;                                          //0035
   Dcl-c Quote  '''';                                                                    //0035
   Dcl-c commas        ',,,,';                                                           //0035
   Dcl-s flag            char(1) ;                                                       //0035
   Dcl-s loop            int(5)       inz;                                               //0035
   Dcl-s SqlCsKyCnt zoned(3:0) inz(0);                                                   //0035
   Dcl-s SqlCsKyArray char(25) dim(500);                                                 //0035
   Dcl-s Keyword_Member char(25) ;                                                       //0035
   Dcl-s Keyword_Type char(25) ;                                                         //0035
   Dcl-s pos_casekey zoned(4:0) inz(0);                                                  //0039
   Dcl-s pos_from    zoned(4:0) ;                                                        //0039
   Dcl-s dQuoteCnt   zoned(4:0) inz(1);                                                  //0039
   Dcl-s OpCode          char(50);                                                       //0039
   Dcl-s ShouldValidate  char(1);                                                        //0039
   Dcl-s dQuote          char(1) inz('"');                                               //0039
                                                                                         //0035
   Keyword_Member = 'SQL';                                                               //0035
   Keyword_Type = 'CASKEYWORD';                                                          //0035

   //Fetch SQL functions from IAKEYWORD file
   SqlCsKyArray = GetKeywords(Keyword_Member:                                            //0035
                              Keyword_Type:SqlCsKyArray);                                //0035
   //Calculate functions count
   SqlCsKyCnt = %lookup(' ':SqlCsKyArray) - 1;                                           //0035

   source = in_str ;                                                                     //0035
   poswhen = %scan(' WHEN ':%TRIM(SOURCE):1) ;                                           //0035
   poselse = %scan(' ELSE ':%TRIM(SOURCE):1) ;                                           //0035
   posend  = %scan(' END' :%TRIM(SOURCE):1) ;                                            //0035
   if POSEND > (POSwhen+5);                                                              //0035
      SOURCE2= %TRIM(%SUBST(%TRIM(SOURCE):POSWHEN+5:(POSEND)-(POSwhen+5)));              //0039
   endif;                                                                                //0035

   If SOURCE2 = *Blanks;                                                                 //0035
      Clear source3;                                                                     //0035
      Return  source3;                                                                   //0035
   Endif;                                                                                //0035

   //Introduced logic to replace case keywords to comma
   For Count3 = 1 to SqlCsKyCnt;                                                         //0035
      if %len(%trim(SqlCsKyArray(Count3))) = 1;                                          //0035
         Source2 = %xlate(%trim(SqlCsKyArray(Count3)):commas:Source2);                   //0035
      else;                                                                              //0035
         Opcode = %trim(SqlCsKyArray(Count3));                                           //0039
         pos_casekey = %scan(%trim(Opcode):Source2);                                     //0039
         Dow pos_casekey <> 0;                                                           //0035

            pos_from = 1;                                                                //0039
            clear ShouldValidate;                                                        //0039
            //Count '"' till the position where keyword is found                        //0039
            //If count is even that means keyword is not in constant                    //0039
            //If count is odd  that means keyword is part of constant                   //0039
            dQuoteCnt = GetStrOcrCount(dQuote:Source2:                                   //0039
                                       pos_from:pos_casekey);                            //0039
            If dQuoteCnt <> 0;                                                           //0039
               If %rem(dQuoteCnt:2) = 1;                                                 //0039
                  ShouldValidate = 'N';                                                  //0039
               Else;                                                                     //0039
                  ShouldValidate = 'Y';                                                  //0039
               Endif;                                                                    //0039
            Else;                                                                        //0039
               ShouldValidate = 'Y';                                                     //0039
            Endif;                                                                       //0039

            //Validate the keyword if it is not part of constant
            If ShouldValidate = 'Y';                                                     //0039
               If ValidateOpcodeName(Source2 : Opcode : pos_casekey);                    //0039
                  pos_casekey = %scan(%trim(Opcode) : Source2 :                          //0039
                                pos_casekey + %len(%trim(Opcode)) + 1 );                 //0039
               Else;                                                                     //0039
                  Source2 = %Replace(',' :Source2: pos_casekey :                         //0039
                            %len(%trim(Opcode)));                                        //0039
                  pos_casekey = %scan(%trim(Opcode):Source2:                             //0039
                                pos_casekey + 1 );                                       //0039
               Endif;                                                                    //0039
            Else;                                                                        //0039
               pos_casekey = %scan(%trim(Opcode) : Source2 :                             //0039
                             pos_casekey + %len(%trim(Opcode)) + 1 );                    //0039
            Endif;                                                                       //0039
         Enddo;                                                                          //0035
      Endif;                                                                             //0035
   EndFor;                                                                               //0035

   string3 = source2 ;                                                                   //0035
   Exsr checkcomma ;                                                                     //0035
   FillIndex = 1;                                                                        //0035
   ArrayIndex = 1;                                                                       //0035
   //Fresh logic to build array based on comma positions
   Dow comma(ArrayIndex) <> 0   ;                                                        //0035
      if ArrayIndex = 1;                                                                 //0035
         If comma(ArrayIndex) = 1;                                                       //0035
            ArrayIndex += 1;                                                             //0035
            Iter;                                                                        //0035
         Endif;                                                                          //0035
      ELSE;                                                                              //0035
         If comma(ArrayIndex) - comma(ArrayIndex-1) = 1;                                 //0035
            ArrayIndex += 1;                                                             //0035
            Iter;                                                                        //0035
         Endif;                                                                          //0035
      Endif;                                                                             //0035

      //A Case statement may have duplicate Fields/Values but we need to write
      //it only once to remove duplicacy in IAVARREL file
      clear casevalue;                                                                   //0035

      If ArrayIndex = 1;                                                                 //0035
         casevalue = %SUBST(%TRIM(source2):1:COMMA(ArrayIndex)-1) ;                      //0035
         If %LOOKUP(%trim(casevalue):casearray) = 0;                                     //0035
            casearray(FillIndex) = %trim(casevalue) ;                                    //0035
            FillIndex  += 1;                                                             //0035
         Endif;                                                                          //0035
      Else;                                                                              //0035
         casevalue = %SUBST(%TRIM(source2):comma(ArrayIndex-1)+1:                        //0035
                     comma(ArrayIndex) - comma(ArrayIndex-1)-1);                         //0035
         If %LOOKUP(%trim(casevalue):casearray) = 0;                                     //0035
            casearray(FillIndex) = %trim(casevalue) ;                                    //0035
            FillIndex  += 1;                                                             //0035
         Endif;                                                                          //0035
      Endif;                                                                             //0035
      ArrayIndex += 1;                                                                   //0035
   Enddo ;                                                                               //0035

   casevalue = %SUBST(%TRIM(source2):comma(ArrayIndex-1)+1);                             //0035
   If %LOOKUP(%trim(casevalue):casearray) = 0;                                           //0035
      casearray(FillIndex) = %trim(casevalue) ;                                          //0035
      FillIndex  += 1;                                                                   //0035
   Endif;                                                                                //0035

   Flag = 'Y' ;                                                                          //0035
   ArrayIndex = 1;                                                                       //0035
   //Loop till J only as we have filled the array till J only
   For ArrayIndex = 1 TO FillIndex;                                                      //0035
      IF %TRIM(CASEARRAY(ArrayIndex)) <> *BLANKS ;                                       //0035
         If flag = 'Y' ;                                                                 //0035
            flag = 'N' ;                                                                 //0035
            source3 = %trim(CASEARRAY(ArrayIndex));                                      //0035
         Else ;                                                                          //0035
            source3 = %trim(source3)+',' + %trim(CASEARRAY(ArrayIndex));                 //0035
         Endif ;                                                                         //0035
      Endif ;                                                                            //0035
   Endfor;                                                                               //0035

   return  source3 ;                                                                     //0035
                                                                                         //0035
   Begsr checkcomma;                                                                     //0035

      clear comma ;                                                                      //0035
      clear tempcomma ;                                                                  //0035
      poscomma = 0 ;                                                                     //0035
      poscomma = %scan(',':%TRIM(string3):1) ;                                           //0035
      if poscomma > *zero ;                                                              //0035
         ArrayIndex = 1;                                                                 //0035

         Dow poscomma <> 0 ;                                                             //0035
            string4 = %trim(string3) ;                                                   //0035
               comma(ArrayIndex) = poscomma ;                                            //0035
            ArrayIndex += 1;                                                             //0035
            If poscomma < %len(%trim(string3));                                          //0048
               poscomma = %scan(',':%trim(string3):poscomma+1) ;                         //0035
            Else;                                                                        //0048
               leave;                                                                    //0048
            Endif;                                                                       //0048
         Enddo ;                                                                         //0035

      Endif ;                                                                            //0035

   Endsr ;                                                                               //0035

End-proc ;                                                                               //0035

//-------------------------------------------------------------------------------------//
//@ParseOnClause: - Parsing ON clause                                                  //
//-------------------------------------------------------------------------------------//
dcl-proc  @ParseOnClause  export;                                                         //AK06
   dcl-pi @ParseOnClause;                                                                 //AK06
//OJ01in_Str    char(5000);                                                               //AK06
      in_Str    char(5000) const options(*trim);                                          //OJ01
      in_Option char(10);                                                                 //AK06
      // in_SrcLib char(10)    options(*nopass);                                     0062    //AK06
      // in_SrcPf  char(10)    options(*nopass);                                     0062    //AK06
      // in_SrcMbr char(10)    options(*nopass);                                     0062    //AK06
      in_uwSrcDtl likeds(uwSrcDtl) options(*nopass);                                       //0062
      in_RrnS   packed(6:0) options(*nopass);                                             //AK06
      in_RrnE   packed(6:0) options(*nopass);                                             //AK06
   end-pi;                                                                                //AK06
                                                                                          //AK06
   dcl-s  l_pos           packed(4:0);                                                    //AK06
   dcl-s  l_string2       varchar(5000);                                                 //0028
   dcl-s  l_String1       varchar(5000);                                                 //0028
 //dcl-s  l_string2       varchar(500);                                           //0028  //AK06
 //dcl-s  l_String1       varchar(500);                                           //0028  //AK06
   dcl-s  l_PosON         packed(4:0);                                                    //AK06
   dcl-s  l_ArrClusLst    packed(4:0) dim(10);                                            //AK06
   dcl-s  FieldArray      char(80)    dim(250);                                           //AK06
   dcl-s  VarArray        char(80)    dim(250);                                           //AK06
   dcl-s  l_len           packed(4:0);                                                    //AK06
   dcl-s  l_I             packed(4:0);                                                    //AK06
   dcl-s  l_J             packed(4:0);                                                    //AK06
   dcl-s  l_K             packed(4:0);                                                    //AK06
   dcl-s  Out_message     char(999);
   dcl-s  in_srcpf        char(10);                                                       //0062
                                                                                          //AK06
   dcl-c  UP              CONST('ABCDEFGHIJKLMNOPQRSTUVWXYZ');                            //AK06
   dcl-c  LO              CONST('abcdefghijklmnopqrstuvwxyz');                            //AK06

   uwSrcDtl = in_uwSrcDtl;                                                                //0062
   in_srcpf = in_srcspf;                                                                  //0062
   //Trim initial spaces from string, if any and convert lower case character to upper   //AK06
//OJ01  l_String1  = %xlate(LO : UP : %trim(in_str));                                     //AK06
   l_String1  = %xlate(LO : UP : in_str);                                                 //OJ01
   //Get position of 'ON' clause.                                                        //AK06
   l_PosOn    = %scan(' ON ': l_String1);                                                 //AK06
   //If 'ON' clause exist in string.                                                     //AK06
   if l_PosOn <> *Zeros;                                                                  //AK06
      l_I = 1;                                                                  //Index 1//AK06
      l_ArrClusLst(l_i)= %scan(' WHERE '   : l_String1 : l_PosOn);                        //AK06
      l_I += 1;                                                                 //Index 2//AK06
      l_ArrClusLst(l_i)= %scan(' ORDER BY ': l_String1 : l_PosOn);                        //AK06
      l_I += 1;                                                                 //Index 3//AK06
      l_ArrClusLst(l_i)= %scan(' GROUP BY ': l_String1 : l_PosOn);                        //AK06
      l_I += 1;                                                                 //Index 4//AK06
      l_ArrClusLst(l_i) =%scan(' HAVING '  : l_String1 : l_PosOn);                        //AK06
      l_I += 1;                                                                 //Index 5//AK06
      l_ArrClusLst(l_i)= %scan(' FETCH '   : l_String1 : l_PosOn);                        //AK06
      l_I += 1;                                                                 //Index 6//AK06
      l_ArrClusLst(l_i)= %scan(' LIMIT '   : l_String1 : l_PosOn);                        //AK06
      for l_J = 1 to l_I;                                                                 //AK06
         if l_ArrCLusLst(l_J) > 0;                                                        //AK06
            l_len  = l_ArrCLusLst(l_J);                                                   //AK06
            leave;                                                                        //AK06
         endif;                                                                           //AK06
      endfor;                                                                             //AK06
      //Fetch string after ON clause and before any clause occurs.                       //AK06
      If l_Len > 0 and l_len-l_PosOn - 3 > 0;                                             //AK06
         l_String1 = %subst(%trim(l_String1):l_PosOn + 3:l_len-l_PosOn - 3);              //AK06
      //Fetch string after ON clause and before end.                                     //AK06
      Elseif %len(%trim(l_String1)) > (l_PosOn + 3);                                      //AK06
         l_String1 = %subst(%trim(l_String1):l_PosOn + 3);                                //AK06
      EndIf;                                                                              //AK06
      //Fetch data for respective arrays.                                                //AK06
      ExSr @sr_FetchFields;                                                               //AK06
      //Filter aliases such as 'A.FLD001' to 'FLD001'                                    //AK06
      ExSr @sr_FilterAlias;                                                               //AK06

      //Write into IAVARREL file.                                                        //AK06
      // WrtIaVarRel(FieldArray : VarArray : Out_message : in_SrcLib : in_SrcPf   0062       //AK06
      //                        : in_SrcMbr : in_RrnS : in_RrnE);                 0062       //AK06
      WrtIaVarRel(FieldArray : VarArray : Out_message : in_uwSrcDtl                       //0062
                             : in_RrnS : in_RrnE);                                        //0062
                                                                                          //AK06
   //If 'ON' clause does exist in string.                                                //AK06
   Else;                                                                                  //AK06
      Return;                                                                             //AK06
   EndIf;                                                                                 //AK06
   Return;                                                                                //AK06

   //Subroutine to fetch all file fields and var fields relation and put into            //AK06
   //FileArray and VarArray                                                              //AK06
   BegSr @sr_FetchFields;                                                                 //AK06
      l_String2 = %scanrpl('AND':',':l_String1);                                          //AK06
      l_String2 = %scanrpl('OR' :',':l_String2);                                          //AK06
      l_I = 1;                                                                            //AK06
      l_J = 0;                                                                            //AK06
      l_K = 1;                                                                            //AK06
      l_String2  = l_String2 + ' ,';                                                      //AK06
      DoW %len(%trim(l_String2)) > l_I and                                                //AK06
          %scan('=':l_String2 :l_I) > 0;                                                  //AK06
          l_Pos = %scan('=':l_String2:l_I);                                               //AK06
          if l_Pos > l_I and l_K < %elem(FieldArray);
             FieldArray(l_K) = %trim( %subst(l_String2:l_I:l_Pos -l_I));                  //AK06
          endif;
          If %scan(',': l_String2 :l_Pos+1) > 0;                                          //AK06
             l_J = %scan(',': l_String2 :l_Pos);                                          //AK06
             if l_J > 0 and l_J - l_Pos - 1 > 0
                and l_k < %elem(VarArray);
                VarArray(l_k) = %subst(l_String2: l_Pos + 1 : l_J - l_Pos - 1);           //AK06
             endif;
          Endif;                                                                          //AK06
          l_K += 1;                                                                       //AK06
          l_I  = l_J + 1;                                                                 //AK06
      Enddo;                                                                              //AK06
   EndSr;                                                                                 //AK06

   //Subroutine to filter aliases. A.FLD -> FLD.                                         //AK06
   //Apply Const if encountered.                                                         //AK06
   //Remove ':', '(', ')' if encountered.                                                //AK06
   BegSr @sr_FilterAlias;                                                                 //AK06
      l_I = 1;                                                                            //AK06
      l_J = %lookup(' ':FieldArray);                                                      //AK06
      For   l_I = 1 to l_J;                                                               //AK06
         If %scan('.':%trim(FieldArray(l_I)):1) > 0                                       //AK06
            and l_I < %elem(FieldArray);
            l_Pos = %scan('.':%trim(FieldArray(l_I)):1);                                  //AK06
            FieldArray(l_I) = %subst(%trim(FieldArray(l_I)):l_Pos + 1);                   //AK06
         EndIf;                                                                           //AK06
         if l_I < %elem(FieldArray);
            FieldArray(l_I) = %Trim(FieldArray(l_I):' ():');                              //AK06
            FieldArray(l_I) = IsVariableOrConst(%trim(FieldArray(l_I)));                  //AK06
         endif;
      EndFor;                                                                             //AK06
      l_I = 1;                                                                            //AK06
      l_J = %lookup(' ':VarArray);                                                        //AK06
      For   l_I = 1 to l_J;                                                               //AK06
         if l_I < %elem(VarArray);
            If %scan('.':%trim(VarArray(l_I)):1) > 0;                                     //AK06
               l_Pos = %scan('.':%trim(VarArray(l_I)):1);                                 //AK06
               VarArray(l_I) = %subst(%trim(VarArray(l_I)):l_Pos + 1);                    //AK06
            EndIf;                                                                        //AK06
            VarArray(l_I) = %Trim(VarArray(l_I):' ():');                                  //AK06
            VarArray(l_I) = IsVariableOrConst(%trim(VarArray(l_I)));                      //AK06
         endif;
      EndFor;                                                                             //AK06
   EndSr;                                                                                 //AK06

End-Proc @ParseOnClause;                                                                  //AK06

//-------------------------------------------------------------------------------------//
//Parse DDS file (LF) source to add variable relation in IAVARREL.                     //
//-------------------------------------------------------------------------------------//
dcl-proc  iaParsePfLfSrc  export;                                                         //PJ01
   dcl-pi iaParsePfLfSrc ;                                                                //PJ01
      in_pSrcLib char(10) ;                                                               //PJ01
      in_pSrcPf  char(10) ;                                                               //PJ01
      in_pSrcMbr char(10) ;                                                               //PJ01
   // in_pIfsLoc char(100);                                                               //0062
   end-pi;                                                                                //PJ01
                                                                                          //PJ01
 //External data structure defination.                                                   //PJ01
 dcl-ds DbDdsDs extname('IAQDDSSRC') end-ds ;                                             //PJ01
                                                                                          //PJ01
 dcl-ds IAVARRELDs extname('IAVARREL') prefix(vr_) inz;                                   //PJ01
 end-ds;                                                                                  //PJ01
                                                                                          //PJ01
 //Array data structure Defination.                                                      //PJ01
 dcl-ds KeywDs qualified dim(10) ;                                                        //PJ01
   KeyW char(10) ;                                                                        //PJ01
   Pos  packed(2) ;                                                                       //PJ01
 end-ds ;                                                                                 //PJ01
                                                                                          //PJ01
 dcl-ds Fact2Ds qualified dim(99) ;                                                       //PJ01
   Fact2    char(80) ;                                                                    //PJ01
   SrcRrn  packed(6) ;                                                                    //PJ01
 end-ds ;                                                                                 //PJ01
                                                                                          //PJ01
 //Data structure based on DDS positions.                                                //PJ01
 dcl-ds SrcFldDs ;                                                                        //PJ01
   DsFill1  Char(5) ;                                                                     //PJ01
   DsSpec   Char(1) ;                                                                     //PJ01
   DsComnt  Char(1) ;                                                                     //PJ01
   DsFill2  Char(9) ;                                                                     //PJ01
   Dsnamtyp Char(1) ;                                                                     //PJ01
   DsFill3  Char(1) ;                                                                     //PJ01
   Dsfldnam Char(10);                                                                     //PJ01
   DsRef    Char(1) ;                                                                     //PJ01
   Dslen    Char(5) ;                                                                     //PJ01
   Dsdatyp  Char(1) ;                                                                     //PJ01
   Dsdecpos Char(2) ;                                                                     //PJ01
   Dsusage  Char(1) ;                                                                     //PJ01
   DsFill4  Char(6) ;                                                                     //PJ01
   Dskeyw   Char(36);                                                                     //PJ01
   DsFill5  Char(20) ;                                                                    //PJ01
 end-ds;                                                                                  //PJ01
                                                                                          //PJ01
 //Standalone field defination.                                                          //PJ01
 dcl-s Wkfldnam  char(10)  Inz(*Blanks) ;                                                 //PJ01
 dcl-s Wkspos    packed(3) Inz(*zeros) ;                                                  //PJ01
 dcl-s Wkpos     packed(3) Inz(*zeros) ;                                                  //PJ01
 dcl-s WkEpos    packed(3) Inz(*zeros) ;                                                  //PJ01
 dcl-s Wkindex   packed(2) Inz(*zeros) ;                                                  //PJ01
 dcl-s WkSavIdx  packed(2) Inz(*zeros) ;                                                  //PJ01
 dcl-s Wki       packed(2) Inz(*zeros) ;                                                  //PJ01
 dcl-s wkj       packed(2) Inz(*zeros) ;                                                  //PJ01
 dcl-s Wklen     packed(2) Inz(*zeros) ;                                                  //PJ01
 dcl-s wkcount   packed(2) Inz(*zeros) ;                                                  //PJ01
 dcl-s wkkeyw    char(10)  Inz(*Blanks) ;                                                 //PJ01
 dcl-s wkKeyWString char(1024)  Inz(*Blanks) ;                                           //0017
 dcl-s wkstring     varchar(1024) ;                                                      //0017
 dcl-s wkObjLib     char(10);                                                            //0058
 dcl-s wkObjNam     char(10);                                                            //0058
 dcl-s wkKeyWrd     char(10);                                                            //0058
 dcl-s wkKeyValue   char(50);                                                            //0058
 dcl-s wkKValue     char(50);                                                            //0058
 dcl-s wkStrPos     packed(3) Inz(*zeros) ;                                              //0058
 dcl-s wkEndPos     packed(3) Inz(*zeros) ;                                              //0058
 dcl-s wkArrayPos   packed(2) Inz(*zeros) ;                                              //0058
 dcl-s uiKeyWordPos packed(2) Inz(*zeros) ;                                              //0058
 dcl-s KeyWordCompltFlag  ind inz('0');                                                  //0058
 dcl-s KeyWordCounFlag    ind inz('0');                                                  //0058
 dcl-s wkKeyWordVal char(100);                                                           //0058
 dcl-s WkposTmp  packed(3) Inz(*zeros) ;                                                 //0058
 dcl-s wkDsfldnam char(10);                                                              //0058
                                                                                          //PJ01
 //Indicator type variable.                                                              //PJ01
 dcl-s IsFound       ind Inz(*off) ;                                                      //PJ01
 dcl-s IsDefContinue ind Inz(*off) ;                                                      //PJ01
 dcl-s IsSstFound    ind Inz(*off) ;                                                      //PJ01
 dcl-s IsCompFound   ind Inz(*off) ;                                                      //PJ01
 dcl-s IsRefFldFound ind Inz(*off) ;                                                      //PJ01
 dcl-s IsJfldFound   ind Inz(*off) ;                                                      //PJ01
 dcl-s IsJDupSeqFound ind Inz(*off) ;                                                     //PJ01
                                                                                          //PJ01
 //Constants.                                                                            //PJ01
 dcl-c True Const('1') ;                                                                  //PJ01
 dcl-c False Const('0') ;                                                                 //PJ01
                                                                                          //PJ01
                                                                                          //PJ01
 Monitor ;                                                                                //PJ01
   //Declare cursor to fetch file defination from iaqddssrc.                             //PJ01
   exec sql declare C2_ddssrc cursor for                                                  //PJ01
     Select * from iaqddssrc                                                              //PJ01
     where library_name  = :in_pSrcLib and                                                //PJ01
           sourcepf_name = :in_pSrcPf  and                                                //PJ01
           member_name   = :in_pSrcMbr and                                                //PJ01
           substr(source_data,7,1) <> '*' and            // Exclude commented Source.     //PJ01
           substr(upper(source_data),17,1)                                                //PJ01
           in (' ', 'S','O','K') and                                                      //PJ01
           source_data <> ' ' ;                          // Exclude blank lines.          //PJ01
                                                                                          //PJ01
   exec sql open C2_ddssrc ;                                                              //PJ01
                                                                                          //PJ01
   //Is cursor already opened?                                                           //PJ01
   if sqlCode = -502;                                                                     //PJ01
     exec sql close C2_ddssrc ;                                                           //PJ01
     exec sql open  C2_ddssrc ;                                                           //PJ01
   endif;                                                                                 //PJ01
                                                                                          //PJ01
   exec sql fetch next from C2_ddssrc into :DbDdsDs ;                                     //PJ01
   Clear IAVARRELDs ;                                                                     //PJ01
   IsDefContinue = False ;                                                                //PJ01
                                                                                          //PJ01
   dow sqlcode = 0 ;                                                                      //PJ01
      SrcFldDs = wsrcdta  ;                                                               //PJ01
      //Checking for the keyword                                                        //0058
      Exsr Sr_AddKeyword;                                                                //0058
      Exec sql set :Dsnamtyp = upper(:Dsnamtyp) ;                                         //PJ01
      //Field extraction logic.                                                          //PJ01
      If Dsfldnam <> ' ' ;                  // Field name.                                //PJ01
         exsr Sr_Check_and_Write ;                                                        //PJ01
         Wkfldnam  = Dsfldnam ;                                                           //PJ01
         exsr Sr_Move_VarRel_Fld ;                                                        //PJ01
         //Fetch variables inside the keyword if any.                                    //PJ01
         exsr Sr_fetch_tovar ;                                                            //PJ01
      else ;                                                                              //PJ01
         //Fetch variables inside the keyword if any.                                    //PJ01
         exsr Sr_fetch_tovar ;                                                            //PJ01
      endif ;                                                                             //PJ01
      if IsDefContinue = True;                                                           //0017
      //0058 wkstring = wkstring + %subst(Dskeyw:1:%scan('-':Dskeyw:1)-1);               //0017
         if %scan('-':Dskeyw:1) > 0;                                                     //0058
           wkstring = wkstring + %subst(Dskeyw:1:%scan('-':Dskeyw:1)-1);                 //0058
         elseif  %scan('+':Dskeyw:1) > 0;                                                //0058
           wkstring = wkstring + %subst(Dskeyw:1:%scan('+':Dskeyw:1)-1);                 //0058
         elseif  %subst(%trim(Dskeyw):%len(%trim(Dskeyw)):1) <> ')';                     //0058
           wkstring = wkstring + %subst(Dskeyw:1:%len(Dskeyw)-1);                        //0058
         endif;                                                                          //0058
                                                                                         //0017
      else;                                                                              //0017
         wkstring = wkstring + %trimr(Dskeyw);                                           //0017
         wkKeyWString = %trim(wkstring);                                                 //0017
                                                                                         //0017
         if %scan('REFFLD(':wkKeyWString:1) > 0 Or                                       //0060
            (%scan('REF(': wkKeyWString: 1) > 0 And                                      //0060
             %scan('JREF(': wkKeyWString:1) = 0);                                        //0060
                                                                                         //0017
            FileRefValDs = iAGetFileRefVal(wkKeyWString);                                //0017
                                                                                         //0017
            if FileRefValDs.RefObj <> *Blanks ;                                          //0017
                                                                                         //0017
               IASRCREFW(in_pSrcLib                                                      //0017
                        :in_pSrcMbr                                                      //0017
                        :wMbrTyp                                                         //0017
                        :in_pSrcPf                                                       //0017
               //       :in_pIfsLoc                                                      //0062
                        :FileRefValDs.refObj                                             //0017
                        :'*FILE'                                                         //0017
                        :FileRefValDs.refLib                                             //0017
                        :'I'                                                             //0042
                        :'REF');                                                         //0017
            endif;                                                                       //0017
         endif;                                                                          //0017
         clear wkstring;                                                                 //0017
         clear wkKeyWString;                                                             //0017
      endif;                                                                             //0017

      exec sql fetch next from C2_ddssrc into :DbDdsDs ;                                  //PJ01
      If SqlCode = 100 ;                                                                  //PJ01
         exsr Sr_Check_and_Write ;                                                        //PJ01
         leave ;                                                                          //PJ01
      endif ;                                                                             //PJ01
   enddo ;                                                                                //PJ01
   exec sql close C2_ddssrc ;                                                             //PJ01
 On-Error ;                                                                               //PJ01
    //Do Nothing.                                                                        //PJ01
 Endmon ;                                                                                 //PJ01
 return ;                                                                                 //PJ01
                                                                                          //PJ01
 //------------------------------------------------------------------------------------ //0058
 //Fetching complete field key word from the source.                                    //0058
 //------------------------------------------------------------------------------------ //0058
 Begsr Sr_AddKeyword;                                                                    //0058
   //fetch the keywords supplied.                                                       //0058
   wkArrayPos = %Lookup(*Blanks:urFileFieldKeyWord:1) ;                                  //0058
   if wkArrayPos = *zeros ;                                                              //0058
     wkArrayPos = %elem(urFileFieldKeyWord) ;                                            //0058
   else ;                                                                                //0058
     wkArrayPos -= 1 ;                                                                   //0058
   endif ;                                                                               //0058
   //When key words are present in the array                                            //0058
   If wkArrayPos > 0 ;                                                                   //0058
     wkpos = 0;                                                                          //0058
     for uiKeyWordPos = 1 to wkArrayPos by 1 ;                                           //0058
       //Cheking the position of the key word in the source                             //0058
       wkpos = %Scan(%trim(urFileFieldKeyWord(uiKeyWordPos)):Dskeyw:1) ;                 //0058
       if wkpos > 0  or KeyWordCounFlag;                                                 //0058
         //When complete key word is in one line                                        //0058
         if wkpos > 0  and  %subst(%trim(Dskeyw):%len(%trim(Dskeyw)):1) = ')';           //0058
           wkKeyWordVal =   %trim(Dskeyw);                                               //0058
           KeyWordCompltFlag = *on;                                                      //0058
           KeyWordCounFlag = *off;                                                       //0058
           wkDsfldnam = Dsfldnam;                                                        //0058
         //When key word is in multiple line ('-'.'+' and Blank)                        //0058
         elseif %subst(%trim(Dskeyw):%len(%trim(Dskeyw)):1) = '-'                        //0058
                or %subst(%trim(Dskeyw):%len(%trim(Dskeyw)):1) = '+' ;                   //0058
           wkKeyWordVal = %trim(wkKeyWordVal) + ' ' + %subst(%trim(Dskeyw):1             //0058
                                                     :%len(%trim(Dskeyw))-1);            //0058
           KeyWordCounFlag = *on;                                                        //0058
           //In the case of mltiple line file field name is present only on first line   //0058
           if wkpos > 0;                                                                 //0058
             wkPosTmp = wkpos;                                                           //0058
             wkDsfldnam = Dsfldnam;                                                      //0058
           endif;                                                                        //0058
         //When key word is in multiple line uses blank in place of '-'/'+'             //0058
         elseif %subst(%trim(Dskeyw):%len(%trim(Dskeyw)):1) <> ')';                      //0058
           wkKeyWordVal = %trim(wkKeyWordVal) + ' ' + %subst(%trim(Dskeyw):1             //0058
                                                     :%len(%trim(Dskeyw)));              //0058
           KeyWordCounFlag = *on;                                                        //0058
           //In the case of mltiple line file field name is present only on first line  //0058
           if wkpos > 0;                                                                 //0058
             wkPosTmp = wkpos;                                                           //0058
             wkDsfldnam = Dsfldnam;                                                      //0058
           endif;                                                                        //0058
         //When key word is in multiple line ends with the ')'                          //0058
         elseif wkpos = 0 and KeyWordCounFlag and                                        //0058
                %subst(%trim(Dskeyw):%len(%trim(Dskeyw)):1) = ')';                       //0058
             wkKeyWordVal = %trim(wkKeyWordVal) + ' ' + %subst(%trim(Dskeyw):1           //0058
                                                       :%len(%trim(Dskeyw)));            //0058
             KeyWordCompltFlag = *on;                                                    //0058
             KeyWordCounFlag = *off;                                                     //0058
             wkpos = wkPosTmp;                                                           //0058
         endif;                                                                          //0058
         //When complete key word is processed a single line (in case of multiple lines)//0058
         if KeyWordCompltFlag;                                                           //0058
           //Process the complete key word                                              //0058
           exsr SrProcessKeyWord;                                                        //0058
           KeyWordCompltFlag = *off;                                                     //0058
           wkKeyWordVal = *blank;                                                        //0058
           leave;                                                                        //0058
         //When continuation line is processed                                          //0058
         elseif KeyWordCounFlag;                                                         //0058
           leave;                                                                        //0058
         endif;                                                                          //0058
       endif;                                                                            //0058
     endfor;                                                                             //0058
   endif;                                                                                //0058
                                                                                         //0058
 endsr ;                                                                                 //0058
                                                                                         //0058
 //------------------------------------------------------------------------------------ //0058
 //Adding the keyword value to file IADSPFFDP table.                                    //0058
 //------------------------------------------------------------------------------------ //0058
 Begsr SrProcessKeyWord;                                                                 //0058
                                                                                         //0058
   //When continuation line is processed                                                //0058
   WkKeyWrd = %Subst(wkKeyWordVal:wkpos:%len(                                            //0058
                     %trim(urFileFieldKeyWord(uiKeyWordPos)))-1);                        //0058
   WkKeyValue = %Subst(wkKeyWordVal: wkpos + %len(                                       //0058
                       %trim(urFileFieldKeyWord(uiKeyWordPos)))-1);                      //0058
   wkKValue = *blank;                                                                    //0058
   wkStrPos = 1;                                                                         //0058
                                                                                         //0058
   dow wkStrPos <= %len(%trim(WkKeyValue));                                              //0058
     wkEndPos = %scan(' ':%trim(WkKeyValue):wkStrPos);                                   //0058
     if wkStrPos = 1;                                                                    //0058
       wkKValue = %subst(%trim(wkKeyValue):wkStrPos:wkEndPos-wkStrPos);                  //0058
     elseif wkEndPos - wkStrPos > 0;                                                     //0058
       wkKValue = %trim(wkKValue) + ',' + %subst(%trim(wkKeyValue):                      //0058
                       wkStrPos:wkEndPos-wkStrPos);                                      //0058
     elseif wkEndPos = 0;                                                                //0058
       wkKValue = %trim(wkKValue) + ',' + %subst(%trim(wkKeyValue):wkStrPos);            //0058
       leave;                                                                            //0058
     endif;                                                                              //0058
     wkStrPos = wkEndPos + 1;                                                            //0058
   enddo;                                                                                //0058
                                                                                         //0058
   //Fetching the object name of the file                                               //0058
   exec sql                                                                              //0058
     Select IaObjLib, IaObjNam into :wkObjLib, :wkObjNam                                 //0058
     from iaobjmap Where Member_LibR = :in_pSrcLib                                       //0058
     And Member_SrcF = :in_pSrcPf                                                        //0058
     And Member_Name = :in_pSrcMbr;                                                      //0058
                                                                                         //0058
   if sqlcode = 0;                                                                       //0058
   //Updating the key word details in file IAFILEDTL                                    //0058
     exec sql                                                                            //0058
       update iafiledtl SET KEYWORD_NAME = :wkKeyWrd,                                    //0058
                            KEYWORD_VALUE = :wkKValue                                    //0058
       where File_Name = :wkObjNam and Library_Name = :wkObjLib                          //0058
       and Field_Name_External = :wkDsfldnam;                                            //0058
   endif;                                                                                //0058
 endsr ;                                                                                 //0058
                                                                                         //PJ01
 //--------------------------------------------------------------------                 //PJ01
 //Verify if we have field details then write.                                          //PJ01
 //--------------------------------------------------------------------                 //PJ01
 Begsr Sr_Move_VarRel_Fld ;                                                               //PJ01
  Clear IAVARRELDs ;                                                                      //PJ01
  vr_resrclib =  wlibnam ;                                                                //PJ01
  vr_resrcfln =  wsrcnam ;                                                                //PJ01
  vr_repgmnm  =  wmbrnam ;                                                                //PJ01
  vr_reseq    =  1 ;                                                                      //PJ01
  vr_rerrn    = wsrcrrn ;                                                                 //PJ01
  vr_refact1  = Dsfldnam ;                                                                //PJ01
  vr_reopc    = 'DBF' ;                                                                   //PJ01
 endsr ;                                                                                  //PJ01
                                                                                          //PJ01
 //--------------------------------------------------------------------                  //PJ01
 //Verify if we have field details then write.                                           //PJ01
 //--------------------------------------------------------------------                  //PJ01
 Begsr Sr_Check_and_Write ;                                                               //PJ01
  //Write record after all the keywords are checked and                                  //PJ01
  //new field availble for the next scan.                                                //PJ01
  if (Wkfldnam <> Dsfldnam and Dsfldnam <> *Blanks) or                                    //PJ01
     Dsnamtyp <> *blanks or SqlCode = 100 ;                                               //PJ01
     If vr_refact1 <> *Blanks ;                                                           //PJ01
        If %lookup(*blanks:Fact2Ds(*).Fact2:1) = 1 ;                                      //PJ01
           Exsr Sr_Wrt_VarRel ;                                                           //PJ01
        else ;                                                                            //PJ01
           wkpos = %lookup(*blanks:Fact2Ds(*).Fact2:1) ;                                  //PJ01
           If wkpos = 0 ;                                                                 //PJ01
              wkpos = 99 ;                                                                //PJ01
           else ;                                                                         //PJ01
              wkpos -= 1 ;                                                                //PJ01
           endif ;                                                                        //PJ01
           for wkIndex = 1 to wkpos by 1 ;                                                //PJ01
              vr_refact2 = Fact2Ds(wkIndex).Fact2 ;                                       //PJ01
              vr_rerrn   = Fact2Ds(wkIndex).SrcRrn ;                                      //PJ01
              Exsr Sr_Wrt_VarRel ;                                                        //PJ01
           endfor ;                                                                       //PJ01
        endif ;                                                                           //PJ01
     endif ;                                                                              //PJ01
     //Clear fields and reset indicators.                                                //PJ01
     Clear IAVARRELDs ;                                                                   //PJ01
     Clear Fact2Ds ;                                                                      //PJ01
     Clear wkIndex ;                                                                      //PJ01
     IsDefContinue = False ;                                                              //PJ01
     IsSstFound = False ;                                                                 //PJ01
     IsCompFound = False ;                                                                //PJ01
     IsRefFldFound = False ;                                                              //PJ01
     IsJfldFound = False ;                                                                //PJ01
     IsJDupSeqFound = False ;                                                             //PJ01
  endif ;                                                                                 //PJ01
 Endsr ;                                                                                  //PJ01
 //--------------------------------------------------------------------                  //PJ01
 //Check for the keywords and fetch fields.                                              //PJ01
 //--------------------------------------------------------------------                  //PJ01
 Begsr Sr_fetch_tovar ;                                                                   //PJ01
   If Dskeyw <> *Blanks ;                                                                 //PJ01
      Clear KeyWDs ;                                                                      //PJ01
      Clear WkKeyw ;                                                                      //PJ01
      Clear wkpos ;                                                                       //PJ01
      wkpos = 0 ;                                                                         //PJ01
      wkcount = 0 ;                                                                       //PJ01
      //Set String to Upper case.                                                        //PJ01
      exec sql set :Dskeyw = upper(:Dskeyw) ;                                             //PJ01
      //fetch the keywords supplied.                                                     //PJ01
      wkj = %Lookup(*Blanks:KEYWORDARRAY3:1) ;                                            //PJ01
      if wkj = *zeros ;                                                                   //PJ01
         wkj = %elem(KEYWORDARRAY3) ;                                                     //PJ01
      else ;                                                                              //PJ01
         wkj -= 1 ;                                                                       //PJ01
      endif ;                                                                             //PJ01
      If wkj > 0 ;                                                                        //PJ01
         for wki = 1 to wkj by 1 ;                                                        //PJ01
            wkpos = %Scan(%trim(KEYWORDARRAY3(wki)):Dskeyw:1) ;                           //PJ01
            if wkpos > 0 ;                                                                //PJ01
               wkcount += 1 ;                                                             //PJ01
               KeyWDs(wkcount).KeyW = KEYWORDARRAY3(wki) ;                                //PJ01
               KeywDs(wkcount).Pos  = wkpos ;                                             //PJ01
               //Check If the same keyword specified Multiple times on the same line.    //PJ01
               Dow wkpos > 0 ;                                                            //PJ01
                  wkpos = %Scan(%trim(KEYWORDARRAY3(wki)):Dskeyw:Wkpos+1) ;               //PJ01
                  if wkpos > 0 ;                                                          //PJ01
                     wkcount += 1 ;                                                       //PJ01
                     KeyWDs(wkcount).KeyW = KEYWORDARRAY3(wki) ;                          //PJ01
                     KeywDs(wkcount).Pos  = wkpos ;                                       //PJ01
                  endif ;                                                                 //PJ01
               enddo ;                                                                    //PJ01
            endif ;                                                                       //PJ01
         endfor ;                                                                         //PJ01
      Endif ;                                                                             //PJ01
      //if keyword definition continued to next line.                                    //PJ01
      if IsDefContinue = True ;                                                           //PJ01
         wkpos = 0 ;                                                                      //PJ01
         exsr Sr_GetVar ;                                                                 //PJ01
      endif ;                                                                             //PJ01
      //Parse the keyword one by one if supplied.                                        //PJ01
      wkj = %Lookup(*Blanks:KeyWDs(*).KeyW:1) - 1 ;                                       //PJ01
      If wkj > 0 ;                                                                        //PJ01
         for wki = 1 to wkj by 1 ;                                                        //PJ01
            WkKeyw = KeyWDs(wki).KeyW ;                                                   //PJ01
            wkpos =  KeywDs(wki).Pos ;                                                    //PJ01
            exsr Sr_GetVar ;                                                              //PJ01
         endfor ;                                                                         //PJ01
      endif ;                                                                             //PJ01
   endif ;                                                                                //PJ01
 Endsr ;                                                                                  //PJ01
 //--------------------------------------------------------------------                  //PJ01
 //Get field name from keyword.                                                          //PJ01
 //--------------------------------------------------------------------                  //PJ01
 Begsr Sr_GetVar ;                                                                        //PJ01
   Select ;                                                                               //PJ01
     //Check if Substring Keyword specified?                                             //PJ01
     when WkKeyw = 'SST(' ;                                                               //PJ01
        IsSstFound = True ;                                                               //PJ01
        exsr Sr_Save_Index ;                                                              //PJ01
     //Check if Compare Keyword specified?                                               //PJ01
     when WkKeyw = 'COMP(' or                                                             //PJ01
        WkKeyw = 'CMP(' ;                                                                 //PJ01
        IsCompFound = True ;                                                              //PJ01
     //Check if Refer field Keyword specified?                                           //PJ01
     when WkKeyw = 'REFFLD(' ;                                                            //PJ01
        IsRefFldFound = True ;                                                            //PJ01
        exsr Sr_Save_Index ;                                                              //PJ01
     //Check if JFLD Keyword specified?                                                  //PJ01
     when WkKeyw = 'JFLD('  ;                                                             //PJ01
        IsJfldFound = True ;                                                              //PJ01
        exsr Sr_Save_Index ;                                                              //PJ01
     //Check if JDUPSEQ Keyword specified?                                               //PJ01
     when WkKeyw = 'JDUPSEQ(' ;                                                           //PJ01
        IsJDupSeqFound = True ;                                                           //PJ01
        exsr Sr_Save_Index ;                                                              //PJ01
     other ;                                                                              //PJ01
       //Do nothing.                                                                     //PJ01
   endsl ;                                                                                //PJ01
                                                                                          //PJ01
   //Get Start and End position if available.                                            //PJ01
   if wkpos > 0 ;   // New keyword on the same line.                                      //PJ01
      wkSpos = %scan('(':Dskeyw:wkpos) + 1 ;                                              //PJ01
   else ;           // If line continues.                                                 //PJ01
      wkSpos = %scan('(':Dskeyw:1) + 1 ;                                                  //PJ01
   endif ;                                                                                //PJ01
                                                                                          //PJ01
   //Keyword defination continues to next line and another keyword is                    //PJ01
   //available on the same line, adjust the start position.                              //PJ01
   If IsDefContinue = True ;                                                              //PJ01
      wkEpos = %scan(')':Dskeyw:1)  ;                                                     //PJ01
      if wkepos > 0 and wkSpos > wkepos ;                                                 //PJ01
         wkSpos = 1 ;                                                                     //PJ01
      Endif ;                                                                             //PJ01
   else ;                                                                                 //PJ01
      wkEpos = %scan(')':Dskeyw:wkSpos)  ;                                                //PJ01
   endif ;                                                                                //PJ01
                                                                                          //PJ01
   //Handle Substring keyword.                                                           //PJ01
   //If First parameter found, ignore the other two length params.                       //PJ01
   If IsDefContinue = True and                                                            //PJ01
      IsSstFound = True and                                                               //PJ01
      Fact2Ds(WkSavIdx).fact2 <> *Blanks ;                                                //PJ01
      if wkEpos > *zeros ;                                                                //PJ01
         IsSstFound = False ;                                                             //PJ01
         IsDefContinue = False ;                                                          //PJ01
         Clear WkSavIdx ;                                                                 //PJ01
      endif ;                                                                             //PJ01
      Leavesr ;                                                                           //PJ01
   endif ;                                                                                //PJ01
   //Handle Refer Field keyword.                                                         //PJ01
   //If reference field is found then ignore the other parameters.                       //PJ01
   If IsDefContinue = True and                                                            //PJ01
      IsRefFldFound = True and                                                            //PJ01
      Fact2Ds(WkSavIdx).fact2 <> *Blanks ;                                                //PJ01
      if wkEpos > *zeros ;                                                                //PJ01
         IsRefFldFound = False ;                                                          //PJ01
         IsDefContinue = False ;                                                          //PJ01
         Clear WkSavIdx ;                                                                 //PJ01
      endif ;                                                                             //PJ01
      Leavesr ;                                                                           //PJ01
   endif ;                                                                                //PJ01
                                                                                          //PJ01
   //Check for line continuation.                                                        //PJ01
   If wkEpos = *zeros ;                                                                   //PJ01
      IsDefContinue = True ;                                                              //PJ01
   else ;                                                                                 //PJ01
      IsDefContinue = False ;                                                             //PJ01
   endif ;                                                                                //PJ01
                                                                                          //PJ01
   wklen = %len(%trimr(Dskeyw)) ;                                                         //PJ01
   If wkspos >= wklen ;                                                                   //PJ01
      IsFound = True ;                                                                    //PJ01
   else ;                                                                                 //PJ01
      IsFound = False ;                                                                   //PJ01
   endif ;                                                                                //PJ01
   //Extract all the fields available.                                                   //PJ01
   Dow isFound = False ;                                                                  //PJ01
      if %subst(DsKeyw:(wkSpos):1) <> *blanks ;                                           //PJ01
         if IsRefFldFound = True and                                                      //PJ01
            %scan('/':Dskeyw:wkspos) > 0 ;   //Is record format/File/Lib name provided    //PJ01
            //Alter the start position and extract the DB field after '/'.               //PJ01
            select ;                                                                      //PJ01
             when %scan('/':Dskeyw:wkspos) < %scan(' ':Dskeyw:wkspos) ;                   //PJ01
               wkspos = %scan('/':Dskeyw:wkspos) + 1 ;                                    //PJ01
             when %scan('/':Dskeyw:wkspos) < %scan('-':Dskeyw:wkspos) and                 //PJ01
                  %checkr('-':Dskeyw) < 36 ;   // Defination COntinues.                   //PJ01
               wkspos = %scan('/':Dskeyw:wkspos) + 1 ;                                    //PJ01
             when %scan('/':Dskeyw:wkspos) < %scan(')':Dskeyw:wkspos) and                 //PJ01
                  %checkr(')':Dskeyw) < 36 ;   // Defination complete.                    //PJ01
               wkspos = %scan('/':Dskeyw:wkspos) + 1 ;                                    //PJ01
             other ;                                                                      //PJ01
            endsl ;                                                                       //PJ01
         endif ;                                                                          //PJ01
         //Defination like "FIELD1) " or "FIELD1- "                                      //PJ01
         If %scan(' ':Dskeyw:wkspos) > *zeros ;                                           //PJ01
            //End of defination ')' or continuation mark '-' found.                      //PJ01
            //Get the last field.                                                        //PJ01
            If %subst(Dskeyw:%scan(' ':Dskeyw:wkspos)-1:1) = ')' or                       //PJ01
               %subst(Dskeyw:%scan(' ':Dskeyw:wkspos)-1:1) = '-' ;                        //PJ01
               wkIndex += 1 ;                                                             //PJ01
               if wkSpos > 0 and (%scan(' ':Dskeyw:wkspos)-1) > (wkspos);
                  Fact2Ds(wkIndex).fact2 = %Trim(%subst(Dskeyw:wkSpos:                    //PJ01
                      ((%scan(' ':Dskeyw:wkspos)-1) - (wkspos) ))) ;                      //PJ01
                  Fact2Ds(wkIndex).SrcRrn = wsrcrrn ;                                     //PJ01
                  exsr Sr_chk_CompVar ;                                                   //PJ01
               endif;
            else ;                                                                        //PJ01
               //Extract the fields between spaces.                                      //PJ01
               //Defination like "FIELD1 FIELD2"                                         //PJ01
               wkIndex += 1 ;                                                             //PJ01
               if wkSpos > 0 and %scan(' ':Dskeyw:wkspos) > wkspos;
                  Fact2Ds(wkIndex).fact2 = %Trim(%subst(Dskeyw:wkSpos:                    //PJ01
                         (%scan(' ':Dskeyw:wkspos) - wkspos))) ;                          //PJ01
                  Fact2Ds(wkIndex).SrcRrn = wsrcrrn ;                                     //PJ01
                  exsr Sr_chk_CompVar ;                                                   //PJ01
               endif;
            endif ;                                                                       //PJ01
            //Extract the fields before '-' or ')' at the last position.                 //PJ01
            //Defination like "FIELD1)" or "FIELD1-"                                     //PJ01
         elseif %scan(' ':Dskeyw:wkspos) = *zeros ;                                       //PJ01
            if %scan('-':Dskeyw:wkspos) > wkspos ;                                        //PJ01
               wkIndex += 1 ;                                                             //PJ01
               Fact2Ds(wkIndex).fact2 = %Trim(%subst(Dskeyw:wkSpos:                       //PJ01
                   (%scan('-':Dskeyw:wkspos) - (wkspos) ))) ;                             //PJ01
               Fact2Ds(wkIndex).SrcRrn = wsrcrrn ;                                        //PJ01
               exsr Sr_chk_CompVar ;                                                      //PJ01
            elseif %scan(')':Dskeyw:wkspos) > wkspos ;                                    //PJ01
               wkIndex += 1 ;                                                             //PJ01
               Fact2Ds(wkIndex).fact2 = %Trim(%subst(Dskeyw:wkSpos:                       //PJ01
                   (%scan(')':Dskeyw:wkspos) - (wkspos) ))) ;                             //PJ01
               Fact2Ds(wkIndex).SrcRrn = wsrcrrn ;                                        //PJ01
               exsr Sr_chk_CompVar ;                                                      //PJ01
            endif ;                                                                       //PJ01
         endif ;                                                                          //PJ01
         //Get the next position of blanks.                                              //PJ01
         wkpos = %scan(' ':Dskeyw:wkspos) ;                                               //PJ01
         //If position is zero, check for end of the defination                          //PJ01
         //or line continuation.                                                         //PJ01
         if wkpos = *zeros ;                                                              //PJ01
            if wkEpos > *zeros ;                                                          //PJ01
               wkpos = %scan(')':Dskeyw:wkspos) ;                                         //PJ01
               wkspos = wkpos ;                                                           //PJ01
            else;                                                                         //PJ01
               wkpos = %scan('-':Dskeyw:wkspos) ;                                         //PJ01
               wkspos = wkpos ;                                                           //PJ01
            endif ;                                                                       //PJ01
         else ;                                                                           //PJ01
            wkspos = wkpos ;                                                              //PJ01
         endif ;                                                                          //PJ01
      else ;                                                                              //PJ01
         //Get the first non blank position.                                             //PJ01
         wkspos = %check(' ':Dskeyw:wkSpos) ;                                             //PJ01
      endif ;                                                                             //PJ01
      //Whole string is searched? go out.                                                //PJ01
      If (wkspos >= wklen) or                                                             //PJ01
         (wkspos >= wkEpos and wkEpos <> *zeros) ;                                        //PJ01
         IsFound = True ;                                                                 //PJ01
      endif ;                                                                             //PJ01
      //Parameters found for the specified keyword?                                      //PJ01
      if wkEpos > 0 ;                                                                     //PJ01
         If IsSstFound = True and                                                         //PJ01
            Fact2Ds(WkSavIdx).fact2 <> *Blanks ;                                          //PJ01
            IsSstFound = False ;                                                          //PJ01
            Clear WkSavIdx ;                                                              //PJ01
            IsFound = True ;                                                              //PJ01
         endif ;                                                                          //PJ01
         If IsRefFldFound = True and                                                      //PJ01
            Fact2Ds(WkSavIdx).fact2 <> *Blanks ;                                          //PJ01
            IsRefFldFound = False ;                                                       //PJ01
            Clear WkSavIdx ;                                                              //PJ01
            IsFound = True ;                                                              //PJ01
         endif ;                                                                          //PJ01
         If IsJfldFound = True ;                                                          //PJ01
            Exsr Sr_Check_Jfld ;                                                          //PJ01
         endif ;                                                                          //PJ01
         If IsJDupSeqFound = True ;                                                       //PJ01
            Exsr Sr_Check_JDupSeq ;                                                       //PJ01
         endif ;                                                                          //PJ01
      endif ;                                                                             //PJ01
   enddo ;                                                                                //PJ01
 Endsr ;                                                                                  //PJ01
                                                                                          //PJ01
 //--------------------------------------------------------------------                  //PJ01
 //Save Index position.                                                                  //PJ01
 //--------------------------------------------------------------------                  //PJ01
 Begsr Sr_Save_Index ;                                                                    //PJ01
   if WkIndex > *zeros ;                                                                  //PJ01
      WkSavIdx = WkIndex + 1 ;  //Save next index value to check parameter found.         //PJ01
   else ;                                                                                 //PJ01
      WkSavIdx = 1 ;                                                                      //PJ01
   endif ;                                                                                //PJ01
 Endsr ;                                                                                  //PJ01
                                                                                          //PJ01
 //--------------------------------------------------------------------                  //PJ01
 //Check COMP Keyword.                                                                   //PJ01
 //--------------------------------------------------------------------                  //PJ01
 Begsr Sr_chk_CompVar ;                                                                   //PJ01
   if IsCompFound ;                                                                       //PJ01
      Select ;                                                                            //PJ01
        //Remove Relational operators if parsed.                                         //PJ01
        when %lookup(Fact2Ds(wkIndex).fact2:ReloprAry:1) > 0 ;                            //PJ01
           Fact2Ds(wkIndex).fact2 = *Blanks ;                                             //PJ01
           Fact2Ds(wkIndex).SrcRrn = *zeros  ;                                            //PJ01
           wkIndex -= 1 ;                                                                 //PJ01
        //Remove Text or numbers.                                                        //PJ01
        when  %Scan('"':Fact2Ds(wkIndex).fact2:1) > 0 or   // Text supplied.              //PJ01
           %check('0123456789':%trim(Fact2Ds(wkIndex).fact2):1) = 0 ; // Number supplied  //PJ01
           Fact2Ds(wkIndex).fact2 = *Blanks ;                                             //PJ01
           Fact2Ds(wkIndex).SrcRrn = *zeros  ;                                            //PJ01
           wkIndex -= 1 ;                                                                 //PJ01
           //Second parameter found switch off the flag.                                 //PJ01
           IsCompFound = False ;                                                          //PJ01
           IsFound = True ;                                                               //PJ01
        other ;                                                                           //PJ01
           //Second parameter found switch off the flag.                                 //PJ01
           IsCompFound = False ;                                                          //PJ01
           IsFound = True ;                                                               //PJ01
      endsl ;                                                                             //PJ01
   endif ;                                                                                //PJ01
 Endsr ;                                                                                  //PJ01
                                                                                          //PJ01
 //--------------------------------------------------------------------                  //PJ01
 //Check JFLD Keyword.                                                                   //PJ01
 //--------------------------------------------------------------------                  //PJ01
 Begsr Sr_Check_Jfld  ;                                                                   //PJ01
   if Fact2Ds(WkSavIdx).fact2 <> *Blanks and                                              //PJ01
      Fact2Ds(WkSavIdx + 1 ).fact2 <> *Blanks ;                                           //PJ01
      exsr Sr_Move_VarRel_Fld ;                                                           //PJ01
      vr_refact1  = Fact2Ds(WkSavIdx).fact2  ;                                            //PJ01
      vr_refact2  = Fact2Ds(WkSavIdx + 1).fact2 ;                                         //PJ01
      vr_rerrn    = Fact2Ds(WkSavIdx).SrcRrn ;                                            //PJ01
      exsr Sr_Wrt_VarRel ;                                                                //PJ01
      Clear IAVARRELDs ;                                                                  //PJ01
      IsJfldFound = False ;                                                               //PJ01
      Fact2Ds(WkSavIdx).fact2 = *Blanks ;                                                 //PJ01
      Fact2Ds(WkSavIdx + 1 ).fact2 = *Blanks ;                                            //PJ01
      Fact2Ds(WkSavIdx).SrcRrn = *zeros ;                                                 //PJ01
      Fact2Ds(WkSavIdx + 1).SrcRrn = *zeros ;                                             //PJ01
      Clear WkSavIdx ;                                                                    //PJ01
      wkIndex -= 2 ;                                                                      //PJ01
      IsFound = True ;                                                                    //PJ01
   Endif ;                                                                                //PJ01
 Endsr ;                                                                                  //PJ01
                                                                                          //PJ01
 //--------------------------------------------------------------------                  //PJ01
 //Check JDUPSEQ Keyword.                                                                //PJ01
 //--------------------------------------------------------------------                  //PJ01
 Begsr Sr_Check_JDupSeq ;                                                                 //PJ01
   if Fact2Ds(WkSavIdx).fact2 <> *Blanks ;                                                //PJ01
      exsr Sr_Move_VarRel_Fld ;                                                           //PJ01
      vr_refact1  = Fact2Ds(WkSavIdx).fact2  ;                                            //PJ01
      vr_rerrn    = Fact2Ds(WkSavIdx).SrcRrn ;                                            //PJ01
      exsr Sr_Wrt_VarRel ;                                                                //PJ01
      Clear IAVARRELDs ;                                                                  //PJ01
      IsJfldFound = False ;                                                               //PJ01
      Fact2Ds(WkSavIdx).fact2 = *Blanks ;                                                 //PJ01
      Fact2Ds(WkSavIdx).SrcRrn = *zeros ;                                                 //PJ01
      Clear WkSavIdx ;                                                                    //PJ01
      wkIndex -= 1 ;                                                                      //PJ01
      IsFound = True ;                                                                    //PJ01
   Endif ;                                                                                //PJ01
 Endsr ;                                                                                  //PJ01
                                                                                          //PJ01
 //--------------------------------------------------------------------                  //PJ01
 //Write into IAVARREL file.                                                             //PJ01
 //--------------------------------------------------------------------                  //PJ01
 Begsr Sr_Wrt_VarRel ;                                                                    //PJ01
   iaVarRelLog(                                                                           //PJ01
 // vr_resrclib  :vr_resrcfln  :vr_repgmnm    :vr_reseq     :vr_rerrn                     //PJ01
    vr_resrclib  :vr_resrcfln  :vr_repgmnm    :vr_reifsloc  :vr_reseq :vr_rerrn           //0062
   :vr_reroutine :vr_rereltyp  :vr_rerelnum   :vr_reopc     :vr_reresult                  //PJ01
   :vr_rebif     :vr_refact1   :vr_recomp     :vr_refact2   :vr_recontin                  //PJ01
   :vr_reresind  :vr_recat1    :vr_recat2     :vr_recat3    :vr_recat4                    //PJ01
   :vr_recat5    :vr_recat6    :vr_reutil     :vr_renum1    :vr_renum2                    //PJ01
   :vr_renum3    :vr_renum4    :vr_renum5     :vr_renum6    :vr_renum7                    //PJ01
   :vr_renum8    :vr_renum9    :vr_reexc      :vr_reinc  );                               //PJ01
 Endsr ;                                                                                  //PJ01
end-proc iaParsePfLfSrc ;                                                                 //PJ01

//------------------------------------------------------------------------------------- //
//Procedure iaParseDSPFSrc: To parse the display file
//------------------------------------------------------------------------------------- //
dcl-proc iaParseDSPFSrc  export;                                                         //0014

   dcl-pi iaParseDSPFSrc;                                                                //0014
      in_pSrcLib char(10);                                                               //0014
      in_pSrcPf  char(10);                                                               //0014
      in_pSrcMbr char(10);                                                               //0014
   end-pi;                                                                               //0014
                                                                                         //0014
   //External data structure defination.
   dcl-ds SourceDataNextLineDs LikeDs(SourceDataDs);                                     //0014
                                                                                         //0014
   dcl-ds iAVarRelDs extname('IAVARREL') prefix(vr_) inz;                                //0014
   end-ds;                                                                               //0014
                                                                                         //0014
   //Data structure based on DDS positions.
   dcl-ds DspfFldDs ;                                                                    //0014
      DspfFil1   Char(5) ;                                                               //0014
      DspfSpec   Char(1) ;                                                               //0014
      DspfAOC    Char(1) ;                                                               //0014
      DspfInd1   Char(3) ;                                                               //0014
      DspfInd2   Char(3) ;                                                               //0014
      DspfInd3   Char(3) ;                                                               //0014
      Dspfnmtyp  Char(1) ;                                                               //0014
      DspfFil2   Char(1) ;                                                               //0014
      Dspffldnm  Char(10);                                                               //0014
      DspfRef    Char(1) ;                                                               //0014
      Dspflen    Char(5) ;                                                               //0014
      Dspfdatyp  Char(1) ;                                                               //0014
      Dspfdecps  Char(2) ;                                                               //0014
      Dspfusage  Char(1) ;                                                               //0014
      DspfLine   Char(3) ;                                                               //0014
      DspfFlPos  Char(3) ;                                                               //0014
      DspfFunc   Char(36);                                                               //0014
      DspfFil3   Char(20) ;                                                              //0014
   end-ds;                                                                               //0014
                                                                                         //0014
   dcl-ds DspfFldNxtLineds LikeDs(DspfFldDs);                                            //0014
                                                                                         //0014
   dcl-ds SourceDataDs     Qualified;                                                    //0014
      wLibNam   Char(10)            ;                                                    //0014
      wSrcNam   Char(10)            ;                                                    //0014
      wMbrNam   Char(10)            ;                                                    //0014
      wSrcRrn   Packed(6:0)         ;                                                    //0014
      wSrcDta   Char(4048)          ;                                                    //0014
   end-ds;                                                                               //0014
                                                                                         //0014
   //Standalone field defination.
   dcl-s WkKeyW               char(10)  Inz(*Blanks) ;                                   //0014
   dcl-s KeyPos               packed(4) Inz(*zeros) ;                                    //0014
   dcl-s NxtPos               packed(4) Inz(*zeros) ;                                    //0014
   dcl-s Wkpos                packed(4) Inz(*zeros) ;                                    //0014
   dcl-s ReadNextRecord       Ind       Inz('0')    ;                                    //0014
   dcl-s ConcateWithBlanks    Ind                   ;                                    //0014
   dcl-s WkSpos               packed(4) Inz(*zeros) ;                                    //0014
   dcl-s WkBpos               packed(4) Inz(*zeros) ;                                    //0014
   dcl-s WkposF               packed(4) Inz(*zeros) ;                                    //0014
   dcl-s WkposBr              packed(4) Inz(*zeros) ;                                    //0014
   dcl-s WkposBl              packed(4) Inz(*zeros) ;                                    //0014
   dcl-s WkLen                packed(4) Inz(*zeros) ;                                    //0014
   dcl-s WkDspfFunc           char(1024)Inz(' ')    ;                                    //0014
   dcl-s WkDSPFFLDNM          char(10)Inz(' ')     ;                                     //0014
   Dcl-S Endoffunc            Char(1)   Inz(' ') ;                                       //0014
   Dcl-S NoFuncFlg            Char(1)   Inz(' ') ;                                       //0014
   Dcl-s Rmnfunc              Char(200) ;                                                //0014
   Dcl-S SltApos              Packed(4) Inz(*zeros) ;                                    //0014
   Dcl-S SltSpos              Packed(4) Inz(*zeros) ;                                    //0014
   Dcl-S Sltvarl              Packed(4) Inz(*zeros) ;                                    //0014
   Dcl-S Fact1                Char(80) ;                                                 //0014
   Dcl-S HTMLcd               Char(1)   Inz(' ') ;                                       //0014
                                                                                         //0014

   //Cursor Declaration
   exec sql                                                                              //0014
     declare DspfCur cursor for                                                          //0014
       Select wlibnam, wsrcnam, wmbrnam, wsrcrrn, wsrcdta                                //0014
         From   iaqddssrc                                                                //0014
       where  library_name  = :in_pSrcLib                                                //0014
         and  sourcepf_name = :in_pSrcPf                                                 //0014
         and  member_name   = :in_pSrcMbr                                                //0014
         and  substr(source_data,7,1) <> '*'                                             //0014
         and  substr(upper(source_data),17,1) in (' ', 'R')                              //0014
         and  source_data <> ' ' ;                                                       //0014
                                                                                         //0014
   //Open cursor. If it is already opened then close and open again.
   exec sql open DspfCur ;                                                               //0014
   if sqlCode = -502;                                                                    //0014
      exec sql close DspfCur;                                                            //0014
      exec sql open  DspfCur;                                                            //0014
   endif;                                                                                //0014
                                                                                         //0014
   exec sql fetch next from DspfCur into :SourceDataDs;                                  //0014

   clear iAVarRelDs ;                                                                    //0014

   dow sqlcode = 0 ;                                                                     //0014

      //Initializing the work variables
      WkKeyw    = *blanks;                                                               //0014
      WkPos     = *Zeros;                                                                //0014
      KeyPos    = *Zeros;                                                                //0014
      WkPosBr   = *Zeros;                                                                //0014
      WkDSPFFUNC = *Zeros;                                                               //0014
                                                                                         //0014
      NofuncFlg = 'N';                                                                   //0014
      WkposBl = *zeros ;                                                                 //0014
      DspfFldDs = SourceDataDs.wsrcdta  ;                                                //0014
      WkDspfFunc = DspfFunc;                                                             //0014
                                                                                         //0014
      //Skip HTML code
      if DspfFunc <> *blanks and HTMLcd = 'Y';                                           //0014

         if %SubSt(DspfFunc:%Len(%Trim(DspfFunc)):1) = ')';                              //0014
           HTMLcd = ' ' ;                                                                //0014
         endIf;                                                                          //0014

         exec sql fetch next from DspfCur into :SourceDataDs;                            //0014
         Iter ;                                                                          //0014

      endIf;                                                                             //0014
                                                                                         //0014
      //Skip if blank line
      if DspfFldNm = *Blanks and WkDspfFunc = *Blanks;                                   //0014

         Exec sql fetch next from DspfCur into :SourceDataDs;                            //0014
         Iter ;                                                                          //0014

      endIf;                                                                             //0014
                                                                                         //0014
      //Get next line of function if current line is continuous
      if WkDspfFunc <> *blanks and DspfFunc <> *blanks                                   //0014
         and (%SubSt(DspfFunc:%Len(%Trim(DspfFunc)):1) = '-'                             //0014
         or  %Subst(DspfFunc:%Len(%Trim(DspfFunc)):1) = '+');                            //0014

        exSr Sr_GetNextLineOfFunction;                                                   //0014

      endIf;                                                                             //0014

      exec sql set :Dspfnmtyp = upper(:Dspfnmtyp);                                       //0014

      //Assigning the variables to load IAVARREL
      exsr Sr_AssignVar;                                                                 //0014

      //Getting the positions
      if WkDspfFunc <> *Blanks;                                                          //0014
         exsr Sr_GetPos;                                                                 //0014
      endIf;                                                                             //0014

      if DspfFldNm <> *blanks and DspfNmTyp <> 'R' ;                                     //0014
         //Loading the field details
         exsr Sr_LoadFld;                                                                //0014
      else;                                                                              //0014
         //Loading the function defined fields
         if WkDspfFunc <> *Blanks;                                                       //0014
           exsr Sr_LoadFunc;                                                             //0014
         endIf;                                                                          //0014
      endif;                                                                             //0014

      if %scan('REF':WkDspfFunc:1) <> 0 or                                               //0017
         %scan('REFFLD':WkDspfFunc:1) <> 0;                                              //0017
                                                                                         //0017
         FileRefValDs = iAGetFileRefVal(WkDspfFunc);                                     //0017
                                                                                         //0017
         if FileRefValDs.RefObj <> *Blanks;                                              //0017
            IASRCREFW(in_pSrcLib                                                         //0017
                     :in_pSrcMbr                                                         //0017
                     :'DSPF'                                                             //0017
                     :in_pSrcPf                                                          //0017
                     :FileRefValDs.refObj                                                //0017
                     :'*FILE'                                                            //0017
                     :FileRefValDs.refLib                                                //0017
                     :'I'                                                                //0042
                     :'REF');                                                            //0017
         endif;                                                                          //0017
      endif;                                                                             //0017

      //Fetching the data from Cursor
      exec sql fetch next from DspfCur into :SourceDataDs;                               //0014

   enddo ;                                                                               //0014

   //Closing the cursor
   exec sql close DspfCur;                                                               //0014

   return;                                                                               //0014

   //---------------------------------------------------------------------------------- //
   //Subroutine Sr_GetPos - Subroutine to get the positions
   //---------------------------------------------------------------------------------- //
   begsr Sr_GetPos ;                                                                     //0014

      //Getting the total length of each line
      WkLen  = %len(%trimr(WkDspfFunc));                                                 //0014

      //Searching for open bracket position
      KeyPos = %Scan('(':WkDSPFFUNC:1);                                                  //0014

      //Getting the keyword into work variable
      if KeyPos > 1;                                                                     //0014
        WkKeyW = %subst(WkDSPFFUNC:1:KeyPos-1);                                          //0014
      else;                                                                              //0014
        NofuncFlg = 'Y';                                                                 //0014
      endif;                                                                             //0014

   endsr;                                                                                //0014

   //---------------------------------------------------------------------------------- //
   //Subroutine Sr_AssignVar: Variable assignment
   //---------------------------------------------------------------------------------- //
   begsr Sr_AssignVar ;                                                                  //0014
                                                                                         //0014
      clear iAVarRelDs ;                                                                 //0014
      vr_resrclib =  SourceDataDs.wLibNam;                                               //0014
      vr_resrcfln =  SourceDataDs.wSrcNam;                                               //0014
      vr_repgmnm  =  SourceDataDs.wMbrNam;                                               //0014
      vr_reseq    =  1;                                                                  //0014
      vr_rerrn    =  SourceDataDs.wSrcRrn;                                               //0014
      vr_reopc    = 'DSPF';                                                              //0014
                                                                                         //0014
   endsr;                                                                                //0014
                                                                                         //0014
   //---------------------------------------------------------------------------------- //
   //Subroutine Sr_LoadFld: To write field details
   //---------------------------------------------------------------------------------- //
   begsr Sr_LoadFld;                                                                     //0014
                                                                                         //0014
      WkDspfFldNm = DspfFldNm;                                                           //0014
      vr_Refact1  = DspfFldnm ;                                                          //0014
                                                                                         //0014
      //Loading data
      if %Lookup(WkKeyW:DspfRfArray) = *Zeros;                                           //0014
         exsr Sr_VarrelWrt;                                                              //0014
      endIf ;                                                                            //0014
                                                                                         //0014
      //Loading Keyword related fields if any
      if WkDspfFunc <> *Blanks;                                                          //0014
         exsr Sr_Loadfunc;                                                               //0014
      endIf;                                                                             //0014
                                                                                         //0014
   endsr;                                                                                //0014

   //---------------------------------------------------------------------------------- //
   //Subroutine Sr_LoadFunc: Subroutine to write the function details
   //---------------------------------------------------------------------------------- //
   begsr Sr_LoadFunc;                                                                    //0014
                                                                                         //0014
      WkPos = *Zeros;                                                                    //0014
      //Getting the keyword into work variable
      if KeyPos <> *zeros or NoFuncFlg = 'Y';                                            //0014
                                                                                         //0014
         //Verifying the keyword existance in array
         if wkKeyW <> *Blanks;                                                           //0014
            wkPos  = %Lookup(WkKeyW:DspfKwArray);                                        //0014
         endIf;                                                                          //0014

         //Proceeding further to process if the keyword is exist
         if WkPos <> *zeros or NoFuncFlg = 'Y';                                          //0014

            //End position search
            if KeyPos <> *zeros;                                                         //0014
               WkPosBr = %Scan(')':WkDspfFunc:1);                                        //0014
               if WkPosBr = *zeros;                                                      //0014
                 WkPosBr = %Len(%Trim(WkDspfFunc));                                      //0014
               endif;                                                                    //0014
            endif;                                                                       //0014

            select;                                                                      //0014

               //If the keyword is without & fields like REFFLD, ALIAS etc.
               when %Lookup(WkKeyW:DSPFRFARRAY) <> *Zeros;                               //0014
                  exsr Sr_WriteRef;                                                      //0014
                                                                                         //0014
               //Other all keywords
               other;                                                                    //0014
                  exsr Sr_WriteFld;                                                      //0014
            endSl;                                                                       //0014

         endIf ;                                                                         //0014

      endif;                                                                             //0014

   endsr ;                                                                               //0014

   //---------------------------------------------------------------------------------- //
   //Subroutine Sr_WriteFld: subroutine to write field details into IAVARREL file
   //---------------------------------------------------------------------------------- //
   begsr Sr_WriteFld;                                                                    //0014

      WkPosF  = *Zeros;                                                                  //0014
      if KeyPos = *Zeros;                                                                //0014
         keyPos = 1;                                                                     //0014
      endIf;                                                                             //0014

      //Scan with & to identify the field definition
      WkPosF = %Scan('&':WkDSPFFUNC:KeyPos);                                             //0014

      if Wkkeyw = 'HTML'                                                                 //0014
         and WkposF = *zeros                                                             //0014
         and %Scan('-':WkDSPFFUNC:KeyPos) <> *Zeros                                      //0014
         and %Scan(')':WkDSPFFUNC:KeyPos) = *Zeros;                                      //0014
         HTMLcd = 'Y' ;                                                                  //0014
      endIf ;                                                                            //0014

      //Multiple field verificatin on the same line
      dow WKPosF <> *Zeros and Wkposbl < Wkposbr ;                                       //0014
         exsr Sr_CheckPos;                                                               //0014
         KeyPos = WkPosF + 1;                                                            //0031
         WkPosF = %Scan('&':WkDSPFFUNC:KeyPos);                                          //0014
      enddo;                                                                             //0014

   endsr ;                                                                               //0014

   //---------------------------------------------------------------------------------- //
   //Subroutine Sr_CheckPos: Subroutine to get the position
   //---------------------------------------------------------------------------------- //
   begsr Sr_CheckPos;                                                                    //0014

      WkPosBl = *Zeros;                                                                  //0014

      //Blank position search
      WkPosBl  = %Scan(' ':WkDSPFFUNC:WkPosF);                                           //0014

      // If WkPosBl <> *zeros;                                                           //0014
      if WkPosBl <> *zeros and WkPosBl > (WkPosF+1);                                     //0031

         if WkPosBl < WkPosBr and WkPosBl > (WkPosF+1)  ;                                //0014
            vr_refact1  = %Trim(%Subst(WkDSPFFUNC:WkPosF+1                               //0014
                              :(WkPosBl-(WkPosF+1)) ) );                                 //0014
      //    KeyPos  = WkPosBl + 1;                                                       //0031

         elseif WkPosBr > (WkPosF+1);                                                    //0014
            vr_refact1 = %Trim(%Subst(WkDSPFFUNC:WkPosF+1                                //0014
                             :(WkPosBr-(WkPosF+1)) ) );                                  //0014
         endIf ;                                                                         //0014

         if %Scan('&':vr_refact1) <> *Zeros ;                                            //0014
           exsr Sr_Splitvar ;                                                            //0014
         else ;                                                                          //0014
           exsr Sr_VarrelWrt;                                                            //0014
         endIf ;                                                                         //0014

      endif;                                                                             //0014

   endsr;                                                                                //0014

   //---------------------------------------------------------------------------------- //
   //Subroutine Sr_SplitVar: subroutine to Split the variable
   //---------------------------------------------------------------------------------- //
   begsr Sr_SplitVar;                                                                    //0014

      SltAPos = %Scan('&':vr_refact1) ;                                                  //0014
      SltSpos = %Scan('/':vr_refact1) ;                                                  //0014
      Sltvarl = %Len(%Trim(vr_refact1)) ;                                                //0014
      Fact1 = %Trim(vr_refact1) ;                                                        //0014

      if SltSpos > 1;                                                                    //0014
         vr_refact1 = %Trim(%Subst(Fact1:1:SltSpos-1)) ;                                 //0014
         exsr Sr_VarrelWrt;                                                              //0014
      endif;                                                                             //0014

      if Sltvarl > SltApos;                                                              //0014
         vr_refact1 = %Trim(%Subst(Fact1:SltApos+1:Sltvarl-SltApos));                    //0014
         exsr Sr_VarrelWrt;                                                              //0014
      endif;                                                                             //0014

   endsr;                                                                                //0014

   //---------------------------------------------------------------------------------- //
   //Subroutine Sr_WriteRef: subroutine to write & fields
   //---------------------------------------------------------------------------------- //
   begsr Sr_WriteRef;                                                                    //0014

      NxtPos = KeyPos ;                                                                  //0014
      Endoffunc = ' ' ;                                                                  //0014
      WkPosBl = *Zeros;                                                                  //0014

      exsr Sr_CheckPosr;                                                                 //0014

      dow Endoffunc <> 'Y' ;                                                             //0014

         Rmnfunc = %Trim(%Subst(WkDSPFFUNC:NxtPos)) ;                                    //0014
         if Rmnfunc <> *Blanks ;                                                         //0014
            exsr Sr_CheckPosR ;                                                          //0014
         else ;                                                                          //0014
            Endoffunc = 'Y' ;                                                            //0014
         endIf ;                                                                         //0014

      enddo;                                                                             //0014

   endsr ;                                                                               //0014

   //---------------------------------------------------------------------------------- //
   //Subroutine Sr_CheckPosR: To get the position
   //---------------------------------------------------------------------------------- //
   begsr Sr_CheckPosr;                                                                   //0014

      //Blank position search
      WkPosBl = WkPosBl + %Scan(' ':WkDSPFFUNC:NxtPos+1);                                //0014

      if WkPosBl > WkPosBr and WkPosBr > (NxtPos+1);                                     //0014
         vr_refact2  = %Trim(%Subst(WkDSPFFUNC:NxtPos+1                                  //0014
                           :(WkPosBr-(NxtPos+1)) ) );                                    //0014
         Endoffunc = 'Y' ;                                                               //0014

      elseif WkPosBl > (NxtPos+1);                                                       //0014
         vr_refact2  = %Trim(%Subst(WkDSPFFUNC:NxtPos+1                                  //0014
                           :(WkPosBl-(NxtPos+1)) ) );                                    //0014
         NxtPos = WkPosBl ;                                                              //0014
      endif;                                                                             //0014

      //if function is REFFLD validate and get the filed name alone
      if WkKeyW = 'REFFLD';                                                              //0014
         exsr Sr_RefFldVal;                                                              //0014
         endOfFunc = 'Y' ;                                                               //0014
      endif;                                                                             //0014

      //Factor1 could be zero for Alias if field is defined with REFFLD
      //as Alias comes in the next line, moving the factor 1 from work field
      if WkKeyW = 'ALIAS';                                                               //0014
         if vr_refact1 = *Blanks;                                                        //0014
            vr_refact1 = WkDSPFFLDNM;                                                    //0014
         endIf;                                                                          //0014
      endIf;                                                                             //0014

      //Loading field detials into file
      exsr Sr_VarrelWrt;                                                                 //0014

   endsr;                                                                                //0014

   //---------------------------------------------------------------------------------- //
   //Subroutine Sr_RefFldVal: Validating the REFFLD and getting the field name
   //---------------------------------------------------------------------------------- //
   begsr Sr_RefFldVal;                                                                   //0014

      WkBpos = *Zeros;                                                                   //0014
      WkSpos = *Zeros;                                                                   //0014

      WkBpos = %Scan(' ':%trim(vr_refact2):1);                                           //0014
      WkSpos = %Scan('/':%trim(vr_refact2):1);                                           //0014

      //Getting only Field name from REFFLD definition
      select;                                                                            //0014
         When WkBpos =*Zeros and WkSpos = *Zeros;                                        //0014
             //Do nothing.

         When (WkBpos <> *Zeros and WkSpos = *Zeros)                                     //0014
              or (WkBpos < WKSpos and WkBpos <> *Zeros                                   //0014
              and WkSpos <> *Zeros)                                                      //0014
              and %len(%trim(vr_refact2)) > (WkBpos+1);                                  //0014

            vr_refact2  = %Subst(vr_refact2:1                                            //0014
                          :%len(%trim(vr_refact2))-(WkBpos+1) );                         //0014

         When (WkBpos = *Zeros and WkSpos <> *Zeros)                                     //0014
              or (WkSpos < WKBpos and WkBpos <> *Zeros                                   //0014
              and WkSpos <> *Zeros)                                                      //0014
              and %len(%trim(vr_refact2)) > (WkSpos);                                    //0014
            vr_refact2  = %Subst(vr_refact2:WkSpos+1                                     //0014
                          :%len(%trim(vr_refact2))-(WkSpos) );                           //0014
      endsl;                                                                             //0014

   endsr;                                                                                //0014

   //---------------------------------------------------------------------------------- //
   //Subroutine Sr_VarrelWrt: Writing the data into IAVARREL file
   //---------------------------------------------------------------------------------- //
   begsr Sr_VarrelWrt;                                                                   //0014

   // iaVarRelLog(vr_resrclib   :vr_resrcfln   :vr_repgmnm   :vr_reseq     :vr_rerrn     //0014
      iaVarRelLog(vr_resrclib   :vr_resrcfln   :vr_repgmnm   :vr_reifsloc                //0062
                  :vr_reseq     :vr_rerrn                                                //0062
                  :vr_reroutine :vr_rereltyp  :vr_rerelnum   :vr_reopc     :vr_reresult  //0014
                  :vr_rebif     :vr_refact1   :vr_recomp     :vr_refact2   :vr_recontin  //0014
                  :vr_reresind  :vr_recat1    :vr_recat2     :vr_recat3    :vr_recat4    //0014
                  :vr_recat5    :vr_recat6    :vr_reutil     :vr_renum1    :vr_renum2    //0014
                  :vr_renum3    :vr_renum4    :vr_renum5     :vr_renum6    :vr_renum7    //0014
                  :vr_renum8    :vr_renum9    :vr_reexc      :vr_reinc  );               //0014

   endsr;                                                                                //0014

   //---------------------------------------------------------------------------------- //
   //Subroutine Sr_GetNextLineOfFunction: Get Next Line of function if current
   //                                     line is continuous
   //---------------------------------------------------------------------------------- //
   begSr Sr_GetNextLineOfFunction;                                                       //0014

      //Skip HTML function
      KeyPos = %Scan('(':WkDSPFFUNC:1);                                                  //0014
      if KeyPos > 1;                                                                     //0014
         WkKeyW = %subst(WkDSPFFUNC:1:KeyPos-1);                                         //0014
         if WkKeyW = 'HTML';                                                             //0014
            leaveSr;                                                                     //0014
         endIf;                                                                          //0014
      endIf;                                                                             //0014

      ConcateWithBlanks = *Off;                                                          //0014
      WkDspfFunc = *Blanks;                                                              //0014
      DspfFldNxtLineDs = DspfFldDs;                                                      //0014

      dow SQLCODE = *Zeros;                                                              //0014

         //Continuous line
         if %Len(%Trim(DspfFldNxtLineDS.DSPFFUNC)) > 1                                   //0014
            and (%SubSt(DspfFldNxtLineDs.DSPFFUNC:                                       //0014
                   %Len(%Trim(DspfFldNxtLineDS.DSPFFUNC)):1) = '-'                       //0014
            or %SubSt(DspfFldNxtLineDs.DSPFFUNC:                                         //0014
                   %Len(%Trim(DspfFldNxtLineDs.DSPFFUNC)):1) = '+');                     //0014

            if ConcateWithBlanks;                                                        //0014
               WkDspfFunc = %Trim(WkDspfFunc) + ' ' +                                    //0014
                            %SubSt(DspfFldNxtLineDS.DSPFFUNC:1:                          //0014
                            %Len(%Trim(DspfFldNxtLineDs.DSPFFUNC))-1);                   //0014
            else;                                                                        //0014
               WkDspfFunc = %Trim(WkDspfFunc) +                                          //0014
                            %SubSt(DspfFldNxtLineDS.DSPFFUNC:1:                          //0014
                            %Len(%Trim(DspfFldNxtLineDs.DSPFFUNC))-1);                   //0014
            endIf;                                                                       //0014

            //Check if blanks to be concatenated
            if %SubSt(DspfFldNxtLineDS.DSPFFUNC:                                         //0014
                   %Len(%Trim(DspfFldNxtLineDs.DSPFFUNC))-1) = *Blanks;                  //0014
               ConcateWithBlanks = *On;                                                  //0014
            endIf;                                                                       //0014

         else;                                                                           //0014

            //Last Line
            if ConcateWithBlanks;                                                        //0014
               WkDspfFunc = %Trim(WkDspfFunc) + ' ' +                                    //0014
                            DspfFldNxtLineDS.DSPFFUNC;                                   //0014
            else;                                                                        //0014
               WkDspfFunc = %Trim(WkDspfFunc) +                                          //0014
                            DspfFldNxtLineDs.DSPFFUNC;                                   //0014
            endIf;                                                                       //0014

            leave;                                                                       //0014

         endIf;                                                                          //0014

         //Read next continous line
         exec sql                                                                        //0014
            fetch next from DspfCur into :SourceDataNextLineDs;                          //0014

          DspfFldNxtLineDs = SourceDataNextLineDs.wsrcdta  ;                             //0014

       endDo;                                                                            //0014

   endSr;                                                                                //0014

end-proc iaParseDSPFSrc;                                                                 //0014

//------------------------------------------------------------------------------------- //
//Procedure iaParsePrtfSrc: Procedure to parse PRTF (Printer File) members              //
//------------------------------------------------------------------------------------- //

dcl-proc iaParsePrtfSrc export;                                                          //0013

  dcl-pi *n;                                                                             //0013
    in_pSrcLib char(10);                                                                 //0013
    in_pSrcPf  char(10);                                                                 //0013
    in_pSrcMbr char(10);                                                                 //0013
  end-pi;                                                                                //0013

  //External data structure defination                                                  //0013
  dcl-ds recDdssrc extname('IAQDDSSRC') end-ds;                                          //0013
  dcl-ds IAVARRELDs extname('IAVARREL') prefix(vr_);                                     //0013
  end-ds;                                                                                //0013

  //Data structure based on DDS positions                                               //0013
  dcl-ds sourceFieldDs;                                                                  //0013
    tagFill            Char(5);      //Sequence number                                   //0013
    formType           Char(1);      //A for DDS, optional                               //0013
    condition          Char(10);     //Indicators, comment                               //0013
    type               Char(1);      //Type of spec, R or blank                          //0013
    blank              Char(1);      //Always blanks                                     //0013
    fieldName          Char(10);     //Record or field names, blank for constants        //0013
    referenced         Char(1);      //Referenced field or not, R and ' '                //0013
    lengthOfField      Char(5);      //Length of the field                               //0013
    dataType           Char(1);      //S,A,F,L,T,Z,O,G                                   //0013
    decimal            Char(2);      //0 to 63, incase of decimal datatype               //0013
    usage              Char(1);      //Output only or program to system field            //0013
    location           Char(6);      //Where the field begins on the page(line and pos)  //0013
    keywords_s         Char(36);     //Keywords                                          //0044
  end-ds;                                                                                //0013

  //Standalone variables                                                                //0013
  dcl-s posOfVariable  int(3);                                                           //0013
  dcl-s posOfAmp       int(3);                                                           //0013
  dcl-s posOfSlash     int(3);                                                           //0013
  dcl-s posOfSpace     int(3);                                                           //0013
  dcl-s posOfBrace     int(3);                                                           //0013
  dcl-s posOfDash      int(3);                                                           //0013
  dcl-s posOfSep       int(3);                                                           //0013
  dcl-s keyIdx         int(3);                                                           //0013
  dcl-s fieldInParsing char(10);                                                         //0013
  dcl-s fieldName_w    char(10) inz;                                                     //0044
  dcl-s type_w         char(1) inz;                                                      //0044
  dcl-s w_string    varchar(1024) inz;                                                   //0044
  dcl-s w_keywrd    varchar(1024) inz;                                                   //0044
  dcl-s keywords     char(1024) inz;                                                     //0044

  dcl-s parsedVar      like(vr_refact1);                                                 //0013
  dcl-s saveFact1      like(vr_refact1);                                                 //0013
  dcl-s lastFact1      like(vr_refact1);                                                 //0013
  dcl-s typeInParsing  like(type);                                                       //0013

  monitor;                                                                               //0013
    //Declare cursor to fetch file defination from iaqddssrc                            //0013
    exec sql declare curReadSource cursor for                                            //0013
       Select * from iaqddssrc                                                           //0013
         where library_name  = :in_pSrcLib and                                           //0013
               sourcepf_name = :in_pSrcPf  and                                           //0013
               member_name   = :in_pSrcMbr and                                           //0013
               substr(upper(source_data),17,1) in (' ','R') and                          //0013
               substr(source_data,7,1) <> '*' and                                        //0013
               source_data <> ' ' ;                                                      //0013

    //Open cursor                                                                       //0013
    exec sql open curReadSource;                                                         //0013
    //Is cursor already opened?                                                         //0013
    if sqlCode = CSR_OPN_COD;                                                            //0013
       exec sql close curReadSource;                                                     //0013
       exec sql open  curReadSource;                                                     //0013
    endif;                                                                               //0013

    exec sql fetch next from curReadSource into :recDdssrc;                              //0013
    Clear IAVARRELDs;                                                                    //0013

    dow sqlcode = 0;                                                                     //0013

       sourceFieldDs = wsrcdta;                                                          //0013
       if keywords_s <> *blanks;                                                         //0044
          posOfDash = %scan('-':keywords_s:1);                                           //0044
          if posOfDash > 0;                                                              //0044
             w_keywrd = %subst(keywords_s:1:posOfDash-1);                                //0044
             w_string = w_string + w_keywrd;                                             //0044
             exec sql fetch next from curReadSource into :recDdssrc;                     //0044
                                                                                         //0044
             fieldName_w = fieldName;                                                    //0044
             type_w = type;                                                              //0044
                                                                                         //0044
             iter;                                                                       //0044
          else;                                                                          //0044
             w_string = w_string + %trim(keywords_s);                                    //0044
             keywords = %trim(w_string);                                                 //0044
             fieldName = fieldName_w;                                                    //0044
             type      = type_w;                                                         //0044
             clear fieldname_w;                                                          //0044
             clear type_w;                                                               //0044
             clear w_keywrd;                                                             //0044
             clear w_string;                                                             //0044
          endif;                                                                         //0044
       endif;                                                                            //0044
                                                                                         //0044
       //Field extraction logic                                                         //0013
       if fieldName <> *blanks and fieldInParsing <> fieldName;                          //0013

          if lastFact1 <> vr_refact1 and vr_refact1 <> *blanks;                          //0013
             exsr logVariables;                                                          //0013
          endif;                                                                         //0013

          //Save it if keywords for a variable extends multiple lines                   //0013
          fieldInParsing = fieldName;                                                    //0013
          typeInParsing = type;                                                          //0013

       endif;                                                                            //0013

       If fieldName <> *blanks;                                                          //0013
          //Skip record names and only check keywords                                   //0013
          if typeInParsing <> 'R';                                                       //0013
             exsr mvSourceFieldsToVarrel;                                                //0013
          endif;                                                                         //0013
          //Parse variables inside a keyword and write                                  //0013
          exsr fetchVarFromKeywd;                                                        //0013
       else ;                                                                            //0013
          //Parse variables inside a keyword and write                                  //0013
          //if keywords extends multiple lines                                          //0013
          exsr fetchVarFromKeywd;                                                        //0013
       endif ;                                                                           //0013

       exsr write_reffile_iasrcintpf;                                                    //0044

       exec sql fetch next from curReadSource into :recDdssrc;                           //0013
       If SqlCode = 100 and vr_refact1 <> *blanks;                                       //0013
          exsr logVariables;                                                             //0013
          leave;                                                                         //0013
       endif;                                                                            //0013
       clear keywords;                                                                   //0044
    enddo;                                                                               //0013

    //Close cursor                                                                      //0013
    exec sql close curReadSource;                                                        //0013

  On-Error;                                                                              //0013
  Endmon;                                                                                //0013

  return;                                                                                //0013

  //----------------------------------------------------------------------------------- //
  //Subroutine mvSourceFieldsToVarrel: Verify if we have field details then write       //
  //----------------------------------------------------------------------------------- //
  Begsr mvSourceFieldsToVarrel;                                                          //0013

     Clear IAVARRELDs;                                                                   //0013
     vr_resrclib =  wlibnam;                                                             //0013
     vr_resrcfln =  wsrcnam;                                                             //0013
     vr_repgmnm  =  wmbrnam;                                                             //0013
     vr_reseq    =  1;                                                                   //0013
     vr_rerrn    = wsrcrrn;                                                              //0013
     vr_refact1  = fieldInParsing;                                                       //0013
     vr_reopc    = 'PRTFFLD';                                                            //0013

  endsr;                                                                                 //0013

  //----------------------------------------------------------------------------------- //
  //Subroutine fetchVarFromKeywd: Check for the keywords and fetch fields               //
  //----------------------------------------------------------------------------------- //
  Begsr fetchVarFromKeywd;                                                               //0013

     If keywords <> *blanks;                                                             //0013

        //Set String to Upper case                                                      //0013
        exec sql set :keywords = upper(:keywords);                                       //0013

        //Check exception cases where field is not in the form &FIELD                   //0013
        //e.g REFFLD, ALIAS                                                             //0013
        clear keyIdx;                                                                    //0013
        clear posOfVariable;                                                             //0013

        dow posOfVariable = 0;                                                           //0013
           keyIdx = keyIdx + 1;                                                          //0013
           if keywordExcArr(keyIdx) = *blanks or                                         //0013
              keyIdx > %elem(keywordExcArr);                                             //0013
              leave;                                                                     //0013
           endif;                                                                        //0013
           posOfVariable = %scan(keywordExcArr(keyIdx):keywords);                        //0013
        enddo;                                                                           //0013

        If posOfVariable > 0;                                                            //0013

           posOfSpace = %scan(' ':keywords:posOfVariable+1);                             //0013
           posOfSlash = %scan('/':keywords:posOfVariable+1);                             //0013
           posOfBrace = %scan(')':keywords:posOfVariable+1);                             //0013
           posOfDash = %scan('-':keywords:posOfVariable+1);                              //0013

           //Find the closest seperator                                                 //0013
           exec sql                                                                      //0013
              with positions as (                                                        //0013
                select * from table (values :posOfSlash,:posOfSpace,                     //0013
                                     :posOfBrace,:posOfDash )                            //0013
                   as t(position))                                                       //0013
                select min(position) into :posOfSep from positions                       //0013
                   where position <> 0;                                                  //0013

           if posOfSep = 0;                                                              //0013
              posOfSep = %len(%trim(keywords));                                          //0013
           endif;                                                                        //0013

           //Variable continues to next line                                            //0013
           if posOfSep = posOfDash and posOfSep > posOfAmp + 1;                          //0013
              saveFact1 = %subst(keywords:posOfVariable+1:                               //0013
                                          posOfSep-posOfAmp-1);                          //0013
           endif;                                                                        //0013

           clear iAVarRelDs;                                                             //0013
           vr_resrclib =  wlibnam;                                                       //0013
           vr_resrcfln =  wsrcnam;                                                       //0013
           vr_repgmnm  =  wmbrnam;                                                       //0013
           vr_reseq    =  1;                                                             //0013
           vr_rerrn    = wsrcrrn;                                                        //0013
           vr_reopc    = 'PRTFFLD';                                                      //0013

           //Extract after slash                                                        //0013
           if posOfSep = posOfSlash;                                                     //0013

              //find next seperator - blank or ')'                                      //0013
              if posOfSpace < posOfBrace                                                 //0013
                 and posOfSpace > posOfSlash + 1;                                        //0013
                 parsedVar = %subst(keywords:posOfSlash+1:                               //0013
                                                  posOfSpace-posOfSlash-1);              //0013
              elseif posOfBrace > posOfSlash + 1;                                        //0013
                 parsedVar = %subst(keywords:posOfSlash+1:                               //0013
                                                  posOfBrace-posOfSlash-1);              //0013
              endif;                                                                     //0013

           //Else, Extract before blank or brace                                        //0013
           elseif posOfSep > %len(keywordExcArr(keyIdx)) + 1;                            //0013
              parsedVar = %subst(keywords:%len(keywordExcArr(keyIdx))+1:                 //0013
                                    posOfSep-%len(keywordExcArr(keyIdx))-1);             //0013
           endif;                                                                        //0013

           if typeInParsing = 'R';                                                       //0013
              vr_refact1 = parsedVar;                                                    //0013
           else;                                                                         //0013
              vr_refact2 = parsedVar;                                                    //0013
              vr_refact1 = fieldInParsing;                                               //0013
           endif;                                                                        //0013

           exsr logVariables;                                                            //0013
           clear iAVarRelDs ;                                                            //0013
        endif;                                                                           //0013

        //Find variables of the form '&VARIABLE'                                        //0013
        If posOfVariable <= 0;                                                           //0013

           posOfAmp = %scan('&':keywords);                                               //0013

           dow posOfAmp > 0;                                                             //0013

              posOfSlash = %scan('/':keywords:posOfAmp+1);                               //0013
              posOfSpace = %scan(' ':keywords:posOfAmp+1);                               //0013
              posOfBrace = %scan(')':keywords:posOfAmp+1);                               //0013

              //Find the closest seperator                                              //0013
              exec sql                                                                   //0013
                 with positions as (                                                     //0013
                   select * from table (values :posOfSlash,                              //0013
                                        :posOfSpace,:posOfBrace )                        //0013
                     as t(position))                                                     //0013
                   select min(position) into :posOfSep from positions                    //0013
                     where position <> 0;                                                //0013

              if posOfSep = 0;                                                           //0013
                 posOfSep = %len(%trim(keywords));                                       //0013
              endif;                                                                     //0013

              clear iAVarRelDs;                                                          //0013
              vr_resrclib =  wlibnam;                                                    //0013
              vr_resrcfln =  wsrcnam;                                                    //0013
              vr_repgmnm  =  wmbrnam;                                                    //0013
              vr_reseq    =  1 ;                                                         //0013
              vr_rerrn    = wsrcrrn;                                                     //0013
              vr_reopc    = 'PRTFFLD';                                                   //0013

              if posOfSep > posOfAmp + 1;                                                //0013
                 parsedVar = %subst(keywords:posOfAmp+1:                                 //0013
                                             posOfSep-posOfAmp-1);                       //0013
              endif;                                                                     //0013

              if typeInParsing = 'R';                                                    //0013
                 vr_refact1 = parsedVar;                                                 //0013
              else;                                                                      //0013
                 vr_refact2 = parsedVar;                                                 //0013
                 vr_refact1 = fieldInParsing;                                            //0013
              endif;                                                                     //0013

              exsr logVariables;                                                         //0013
              clear iAVarRelDs;                                                          //0013
              posOfAmp = %scan('&':keywords:posOfAmp+1);                                 //0013

           enddo;                                                                        //0013

        endif;                                                                           //0013

     endif;                                                                              //0013

  endsr;                                                                                 //0013

  //----------------------------------------------------------------------------------- //0044
  //Subroutine to fetch file name from REFFLD and write in IASRCINTPF                   //0044
  //----------------------------------------------------------------------------------- //0044
  Begsr write_reffile_iasrcintpf;                                                        //0044
                                                                                         //0044
     if %scan('REFFLD':keywords:1) > 0;                                                  //0044
                                                                                         //0044
        FileRefValDs = iAGetFileRefVal(keywords);                                        //0044
                                                                                         //0044
        if FileRefValDs.RefObj <> *Blanks ;                                              //0044
           IASRCREFW(in_pSrcLib                                                          //0044
                    :in_pSrcMbr                                                          //0044
                    :'PRTF'                                                              //0044
                    :in_pSrcPf                                                           //0044
                    :FileRefValDs.refObj                                                 //0044
                    :'*FILE'                                                             //0044
                    :FileRefValDs.refLib                                                 //0044
                    :'I'                                                                 //0044
                    :'REF');                                                             //0044
        endif;                                                                           //0044
                                                                                         //0044
     endif;                                                                              //0044
                                                                                         //0044
  endsr;                                                                                 //0044

  //----------------------------------------------------------------------------------- //
  //Subroutine logVariables: Write variables in VARREL file                             //
  //----------------------------------------------------------------------------------- //
  Begsr logVariables;                                                                    //0013

    lastFact1 = vr_refact1;                                                              //0013

 // iaVarRelLog(vr_resrclib  :vr_resrcfln  :vr_repgmnm    :vr_reseq     :vr_rerrn        //0013
    iaVarRelLog(vr_resrclib  :vr_resrcfln  :vr_repgmnm    :vr_reifsloc                   //0062
               :vr_reseq     :vr_rerrn                                                   //0062
               :vr_reroutine :vr_rereltyp  :vr_rerelnum   :vr_reopc     :vr_reresult     //0013
               :vr_rebif     :vr_refact1   :vr_recomp     :vr_refact2   :vr_recontin     //0013
               :vr_reresind  :vr_recat1    :vr_recat2     :vr_recat3    :vr_recat4       //0013
               :vr_recat5    :vr_recat6    :vr_reutil     :vr_renum1    :vr_renum2       //0013
               :vr_renum3    :vr_renum4    :vr_renum5     :vr_renum6    :vr_renum7       //0013
               :vr_renum8    :vr_renum9    :vr_reexc      :vr_reinc  );                  //0013
  endsr;                                                                                 //0013

end-proc iaParsePrtfSrc;                                                                 //0013
//------------------------------------------------------------------------------------- //

dcl-proc getFileName;                                                                    //YK11
dcl-pi getFileName;
   fileNameStr char(200);
   fileName varChar(128);
   libName char(10);
end-pi;
dcl-s seperatorPos packed(4);

   select;
   when %scan( '.': fileNameStr ) > 1;
      seperatorPos = %scan( '.': fileNameStr );
   when %scan( '/': fileNameStr ) > 1;
      seperatorPos = %scan( '/': fileNameStr );
   other;
      clear seperatorPos;
   endSl;

   if seperatorPos > 1;
      fileName = %subst( fileNameStr: seperatorPos+1 );
      libName  = %subst( fileNameStr: 1: seperatorPos-1 );
   else;
      fileName = %trim(fileNameStr);
   endIf;

end-proc;

dcl-proc getFileFieldsIO;                                                                //YK11
dcl-pi getFileFieldsIO;
   fileName varChar(128);
   libName char(10);
   FieldsName char(10) dim(999);
   fldCount packed(4);
end-pi;

dcl-ds FieldDs DIM(999) Qualified;
   FieldName char(250);
end-ds;
dcl-s fileExists char(1);

   clear fileExists;
   // Check if file present in IDSPFFD
   if fileName <> *blanks and libName <> *blanks;
      exec sql
        select 'Y' into :fileExists
        from IDSPFFD
        where WHFILE = :fileName
          and WHLIB = :libName
        limit 1;
   elseIf fileName <> *blanks;
      exec sql
        select 'Y' into :fileExists
        from IDSPFFD
        where WHFILE = :fileName
        limit 1;
   endIf;

   if fileExists = 'Y';
      if libName <> *blanks;
         exec sql
           declare fileFieldI1Csr cursor for
           select WHFLDE
           from IDSPFFD
           where WHFILE = :fileName
             and WHLIB = :libName
           limit :fldCount;
         exec sql open fileFieldI1Csr;
         exec sql
           fetch fileFieldI1Csr for :fldCount rows into :FieldDs;
         exec sql close fileFieldI1Csr;
      else;
         exec sql
           declare fileFieldI2Csr cursor for
           select WHFLDE
           from IDSPFFD
           where WHFILE = :fileName
           limit :fldCount;
         exec sql open fileFieldI2Csr;
         exec sql
           fetch fileFieldI2Csr for :fldCount rows into :FieldDs;
         exec sql close fileFieldI2Csr;
      endIf;

   else;
      clear fileExists;
      exec sql
        select 'Y' into :fileExists
        from IAESQLFFD
        where OBJ_SQL_NAME = :fileName
           or OBJ_SYS_NAME = :fileName
        limit 1;
      if fileExists = 'Y';
         exec sql
           declare fileFldECsr cursor for
           select FLD_SYS_NAME
           from IAESQLFFD
           where OBJ_SQL_NAME = :fileName
              or OBJ_SYS_NAME = :fileName
           limit :fldCount;

         exec sql open fileFldECsr;
         exec sql
           fetch fileFldECsr for :fldCount rows into :FieldDs;
         exec sql close fileFldECsr;
      endIf;
   endIf;

   for fldCount=1 to %elem(fieldsName);
      if FieldDs(fldCount).FieldName = *blanks;
         fldCount -= 1;
         leave;
      endIf;
      fieldsName(fldCount) = FieldDs(fldCount).FieldName;
   endFor;
end-proc;

//------------------------------------------------------------------------------------- //
//Procedure iAPsrOSpec:  Procedure to Parse O-Spec                                      //
//------------------------------------------------------------------------------------- //
dcl-proc  IAPSROSPEC  Export;                                                            //0012

  dcl-pi IAPSROSPEC;                                                                     //0012
    instr    Char(5000);                                                                 //0012
    in_type   char(10);                                                                  //0012
    in_error  char(10);                                                                  //0012
    in_xref   char(10);                                                                  //0012
//  in_srclib char(10);                                                                  //0012 0062
//  in_srcspf char(10);                                                                  //0012 0062
//  in_srcmbr char(10);                                                                  //0012 0062
    in_uWSrcDtl likeds(uWSrcDtl);                                                        //0062
    in_rrns   packed(6:0);                                                               //0012
    in_rrne   packed(6:0);                                                               //0012
  end-pi;                                                                                //0012

  dcl-s uwRefFile  char(80)     inz;                                                     //0012
  dcl-s uwFieldNam char(80)     inz;                                                     //0012

  dcl-ds OspecDsforRPG3 Likeds (OSpecDs);                                                //0012
  dcl-ds OspecDsforRPG4 Likeds (OSpecDsV4);                                             //0012

  uwsrcdtl = In_uwsrcdtl;                                                                //0062
  if in_type = 'RPG' or in_type = 'RPG38' or in_type = 'RPG36';                          //0012
    OspecDsforRPG3 =  instr ;                                                            //0012
    //Initialize Skip_Before field for future use                                        //0057
    If OspecDsforRPG3.Skip_Beforec <> *Blanks and                                        //0057
       %Check(cwDigits : %Trim(OspecDsforRPG3.Skip_Beforec)) = *Zeros;                   //0057
       OspecDsforRPG3.Skip_Before = %Uns(OspecDsforRPG3.Skip_Beforec) ;                  //0057
    Else ;                                                                               //0057
       OspecDsforRPG3.Skip_Before = *Zeros ;                                             //0057
    Endif ;                                                                              //0057
    //Initialize Skip_After field for future use                                         //0057
    If OspecDsforRPG3.Skip_Afterc <> *Blanks and                                         //0057
       %Check(cwDigits : %Trim(OspecDsforRPG3.Skip_Afterc)) = *Zeros ;                   //0057
       OspecDsforRPG3.Skip_After = %Uns(OspecDsforRPG3.Skip_Afterc);                     //0057
    Else ;                                                                               //0057
       OspecDsforRPG3.Skip_After = *Zeros ;                                              //0057
    Endif ;                                                                              //0057
  else;                                                                                  //0012
    OspecDsforRPG4 =  instr ;                                                            //0012
  endif;                                                                                 //0012

  select;                                                                                //0012
     when OspecDsforRPG3.FileName <> '';                                                 //0012
        uwRefFile = OspecDsforRPG3.FileName;                                             //0012

     when OspecDsforRPG4.O_FileName <> '';                                               //0012
        uwRefFile = OspecDsforRPG4.O_FileName;                                           //0012
  endsl;                                                                                 //0012

  exec Sql                                                                               //0012
    insert into iASrcIntpf(Member_Lib_Name,                                              //0012
                           Member_Src_Name,                                              //0012
                           Member_Name,                                                  //0012
                           MEMBER_IFS_LOC,                                               //0062
                           Member_Type,                                                  //0012
                           Referenced_Obj,                                               //0012
                           Referenced_ObjTyp,                                            //0012
                           Referenced_ObjLib,                                            //0012
                           Referenced_ObjUsg,                                            //0012
                           File_Usages)                                                  //0012
                    Values(:in_srclib,                                                   //0012
                           :in_srcspf,                                                   //0012
                           :in_srcmbr,                                                   //0012
                           :in_IfsLoc,                                                   //0062
                           :in_type,                                                     //0012
                           :uwRefFile,                                                   //0012
                           '*FILE',                                                      //0012
                           'QTEMP',                                                      //0012
                           'O',                                                          //0042
                           'EDS');                                                       //0012

  select;                                                                                //0012
     when OspecDsforRPG4.O_Rcdfmt_or_Fldname  <> ' '                                     //0012
          and OspecDsforRPG4.O_FileName = ' '                                            //0012
          and OspecDsforRPG4.O_Type = ' ' ;                                              //0012
        uwFieldNam = OspecDsforRPG4.O_Rcdfmt_or_Fldname;                                 //0012

     when OspecDsforRPG3.Rcdfmt_or_Fldname  <> ' '                                       //0012
          and OspecDsforRPG3.FileName = ' '                                              //0012
          and OspecDsforRPG3.Type = ' ' ;                                                //0012
        uwFieldNam = OspecDsforRPG3.Rcdfmt_or_Fldname;                                   //0012
  endsl;                                                                                 //0012

  Exec Sql                                                                               //0012
    Insert into iAVarRel(Library_Name,                                                   //0012
                         Src_Pf_Name,                                                    //0012
                         Member_Name,                                                    //0012
                         Ifs_Location,                                                   //0062
                         Source_Rrn,                                                     //0012
                         Factor1_Val)                                                    //0012
                  Values(:in_srclib,                                                     //0012
                         :in_srcspf,                                                     //0012
                         :in_srcmbr,                                                     //0012
                         :in_IfsLoc,                                                     //0062
                         :in_rrns,                                                       //0012
                         :uwFieldNam);                                                   //0012

End-proc;                                                                                //0012

//------------------------------------------------------------------------------------- //
//Procedure iAGetFileRefVal :  Procedure to get Reference File Details                  //
//------------------------------------------------------------------------------------- //
dcl-proc iAGetFileRefVal Export;                                                         //0017
                                                                                         //0017
  dcl-pi iAGetFileRefVal Like(FileRefValDs);                                             //0017
    i_keyWString char(1024);                                                             //0017
  end-pi;                                                                                //0017
                                                                                         //0017
  dcl-s WkposEndBr           packed(4) Inz(*zeros) ;                                     //0017
  dcl-s WkposEndSl           packed(4) Inz(*zeros) ;                                     //0017
  dcl-s WkposEndSp           packed(4) Inz(*zeros) ;                                     //0017
  dcl-s WkposStrNoSp         packed(4) Inz(*zeros) ;                                     //0017
  dcl-s WkRefParms           char(1024)Inz(' ') ;                                        //0017
                                                                                         //0017
  clear FileRefValDs.RefObj;                                                             //0017
  clear FileRefValDs.RefLib;                                                             //0017
                                                                                         //0017
  select;                                                                                //0017
     when %scan('REFFLD(':i_keyWString) <> 0 and                                         //0017
          %scan('*':%trim(i_keyWString):1) = 0 and                                       //0017
          %scan(')':%trim(i_keyWString):1) > %scan('(':%trim(i_keyWString):1);           //0017
        exsr Sr_RefFldObjVal;                                                            //0017
     when %scan('REF(':i_keyWString) <> 0 and                                            //0017
          %scan(')':%trim(i_keyWString):1) > %scan('(':%trim(i_keyWString):1);           //0017
        exsr Sr_RefObjVal;                                                               //0017
  endsl;                                                                                 //0017
                                                                                         //0017
  Return FileRefValDs;                                                                   //0017

  //---------------------------------------------------------------------------------- //
  //Subroutine Sr_RefFldObjVal: getting reference file details with REFFLD keyword
  //---------------------------------------------------------------------------------- //
  begsr Sr_RefFldObjVal;                                                                 //0017
                                                                                         //0017
    WkposEndBr   = *Zeros;                                                               //0017
    WkposEndSl   = *Zeros;                                                               //0017
    WkposEndSp   = *Zeros;                                                               //0017
    WkposStrNoSp = *Zeros;                                                               //0017
    clear WkRefParms;                                                                    //0017
                                                                                         //0017
    WkposStrNoSp = %scan('REFFLD(':%trim(i_keyWString):1);                               //0017
    WkposEndSp   = %len(%trim(i_keyWString));                                            //0017
                                                                                         //0017
    WkRefParms = %subst(i_keyWString:WkposStrNoSp+7:WkposEndSp-WkposStrNoSp-7);          //0017
                                                                                         //0017
     WkposEndBr = %len(%trim(WkRefParms));                                               //0017
     WkposEndSl = %Scanr('/':%trim(WkRefParms):1);                                       //0017
     WkposEndSp = %Scanr(' ':%trim(WkRefParms):1:WkposEndBr);                            //0017
                                                                                         //0017
     select;                                                                             //0017
        when WkposEndBr <> *Zeros and WkposEndSp > WkposEndSl                            //0017
             and WkposEndBr > WkposEndSp;                                                //0017
           FileRefValDs.RefObj=%subst(%trim(WkRefParms):WkposEndSp+1                     //0017
                                                       :WkposEndBr-WkposEndSp);          //0017
                                                                                         //0017
        when WkposEndBr <> *Zeros and WkposEndSl > WkposEndSp                            //0017
             and WkposEndSp <> *Zeros and WkposEndBr > WkposEndSl;                       //0017
           FileRefValDs.RefObj=%subst(%trim(WkRefParms):WkposEndSl+1                     //0017
                                                       :WkposEndBr-WkposEndSl);          //0017
           FileRefValDs.RefLib=%subst(%trim(WkRefParms):WkposEndSp+1                     //0017
                                                     :WkposEndSl-WkposEndSp-1);          //0017
     endsl;                                                                              //0017
                                                                                         //0017
  endsr;                                                                                 //0017
                                                                                         //0017
  //---------------------------------------------------------------------------------- //
  //Subroutine Sr_RefObjVal: getting reference file details with REF keyword
  //---------------------------------------------------------------------------------- //
  begsr Sr_RefObjVal;                                                                    //0017
                                                                                         //0017
    WkposStrNoSp = *Zeros;                                                               //0017
    WkposEndSp   = *Zeros;                                                               //0017
    WkposEndSl   = *Zeros;                                                               //0017
    clear WkRefParms;                                                                    //0017
                                                                                         //0017
    WkposStrNoSp = %scan('REF(':%trim(i_keyWString):1);                                  //0017
    WkposEndSp   = %len(%trim(i_keyWString));                                            //0017
                                                                                         //0017
    WkRefParms = %subst(i_keyWString:WkposStrNoSp+4:WkposEndSp-WkposStrNoSp-4);          //0017
                                                                                         //0017
    if %scan('/':WkRefParms:1) > 0;                                                      //0017
       WkposEndSl = %Scan('/':%Trim(WkRefParms):1);                                      //0017
       FileRefValDs.RefLib = %subst(%Trim(WkRefParms):1:WkposEndSl-1);                   //0017
    else;                                                                                //0017
       WkposEndSl = 0;                                                                   //0017
    endif;                                                                               //0017
                                                                                         //0017
    if %scan(' ':%Trim(WkRefParms):1) > 0;                                               //0017
       FileRefValDs.RefObj = %subst(%Trim(WkRefParms):WkposEndSl+1                       //0017
                       :%scan(' ':%Trim(WkRefParms):1)-WkposEndSl);                      //0017
    elseif WkRefParms <> *blanks;                                                        //0017
       FileRefValDs.RefObj = %subst(%Trim(WkRefParms):WkposEndSl+1                       //0017
                       :%len(%Trim(WkRefParms))-WkposEndSl);                             //0017
    endif;                                                                               //0017
                                                                                         //0017
  endsr;                                                                                 //0017
                                                                                         //0017
End-proc iAGetFileRefVal;                                                                //0017

dcl-proc Process_generic_opcode_parsing export;                                          //0037
  dcl-pi Process_generic_opcode_parsing;                                                 //0037
    in_string    char(5000);                                                             //0037
    in_type      char(10);                                                               //0037
    in_error     char(10);                                                               //0037
    in_xref      char(10);                                                               //0037
//  in_srclib    char(10);                                                          0062 //0037
//  in_srcspf    char(10);                                                          0062 //0037
//  in_srcmbr    char(10);                                                          0062 //0037
    in_uWSrcDtl  likeds(uWSrcDtl);                                                       //0062
    in_rrn_s     packed(6:0);                                                            //0037
    in_rrn_e     packed(6:0);                                                            //0037
    in_ErrLogFlg char(1);                                                                //0037
  end-pi;                                                                                //0037

  dcl-s first_var        char(50)    inz;                                                //0037
  dcl-s element          char(50)    inz;                                                //0037
  dcl-s pos              packed(2:0) inz;                                                //0037
  dcl-s pos_semicolon    packed(2:0) inz;                                                //0037
  dcl-s pos_open_bracket packed(2:0) inz;                                                //0037
  dcl-s pos_close_bracket packed(2:0) inz;                                               //0037
  dcl-s BreakStr         char(9999)  inz;                                                //0037
  dcl-s Index            packed(4:0) inz;                                                //0037
  dcl-s ReturnArray      char(120)   inz dim(4999);                                      //0037
  dcl-s counter          packed(4:0) inz;                                                //0037
  dcl-s pos_bif_openbracket   packed(6:0) inz;                                           //0037
  dcl-s pos_bif_start         packed(6:0) inz;                                           //0037
  dcl-s pos_bif_end           packed(6:0) inz;                                           //0037
  dcl-s pos_dot               packed(6:0) inz;                                           //0037
  dcl-s string_bif            char(5000)  inz;                                           //0037
  dcl-s ArrFound              char(1)     inz;                                           //0037
  dcl-s field2                char(500)   inz;                                           //0037
  dcl-s field4                char(5000)  inz;                                           //0037
  dcl-s flag                  char(10)    inz;                                           //0037
  dcl-s io_bkseq              packed(6:0) inz;                                           //0037

  dcl-ds IAVARRELDs extname('IAVARREL') prefix(In_) inz;                                 //0037
  end-ds;                                                                                //0037

  UwSrcDtl    = in_UwSrcDtl ;                                                            //0062
  in_RESRCLIB = in_srclib;                                                               //0037
  in_RESRCFLN = in_srcspf;                                                               //0037
  in_REPGMNM  = in_srcmbr;                                                               //0037
  in_REIFSLOC = in_ifsloc;                                                               //0062
  in_RERRN    = in_rrn_s;                                                                //0037

  if in_string = *blanks;                                                                //0037
    return;                                                                              //0037
  else;                                                                                  //0037
    in_string = %trim(in_string);                                                        //0037
    pos_semicolon = %scanr(';':in_string);                                               //0037
    in_string = %replace(' ':in_string:pos_semicolon);                                   //0037
    pos = %scan(' ':in_string:1);                                                        //0037
    if pos > 1;                                                                          //0037
      in_REOPC   = %subst(in_string:1:pos-1);                                            //0037
      first_var  = %trim(%subst(in_String:pos));                                         //0037

      select;                                                                            //0037
        when ((%scan('%TRIM':first_var) = 1 or %scan('%SUBST':first_var) = 1             //0045
             or %scan('%CHAR':first_var) = 1 )                                           //0045
             and (in_REOPC = 'DSPLY' or in_REOPC = 'RETURN'                              //0037
             or in_REOPC = 'DSPLY(E)'))                                                  //0037
             or (%scan('%SUBARR':first_var) = 1 and (in_REOPC = 'SORTA'                  //0037
             or in_REOPC = 'SORTA(A)' or in_REOPC = 'SORTA(D)'));                        //0037

          pos_bif_start = %scan('%' : first_var);                                        //0037
          pos_bif_openbracket = %scan('(' : first_var : pos_bif_start + 1);              //0037
          pos_bif_end = %scan(')' : first_var : pos_bif_start + 1);                      //0037

          if pos_bif_openbracket > pos_bif_start;                                        //0037
             in_rebif = %subst(first_var : pos_bif_start :                               //0037
                                   pos_bif_openbracket - pos_bif_start);                 //0037
          endif;                                                                         //0037

          if pos_bif_end - pos_bif_start + 1 > 0;                                        //0037
             string_bif = %subst(first_var : pos_bif_start :                             //0037
                                     pos_bif_end - pos_bif_start + 1);                   //0037
          endif;                                                                         //0037

          string_bif = '~' + string_bif;                                                 //0037
           // callbif(in_srclib  :                                                //0062 //0037
           //         in_srcspf  :                                                //0062 //0037
           //         in_srcmbr  :                                                //0062 //0037
              callbif(In_uWSrcDtl:                                                       //0062
                      in_rerrn   :                                                       //0037
                      in_reseq   :                                                       //0037
                      io_bkseq   :                                                       //0037
                      in_REOPC   :                                                       //0037
                      in_refact1 :                                                       //0037
                      in_refact2 :                                                       //0037
                      in_type    :                                                       //0037
                      in_RECOMP  :                                                       //0037
                      in_reBIF   :                                                       //0037
                      flag       :                                                       //0037
                      field2     :                                                       //0037
                      string_bif :                                                       //0037
                      field4 );                                                          //0037

        //For parsing a variable of data structure, if exist                            //0037
        when %scan('.':first_var) > 0;                                                   //0037
          pos_dot = %scan('.' : first_var);                                              //0037
          in_refact1 = %trim(%subst(first_var : pos_dot+1));                             //0037
          in_reseq   += 1;                                                               //0037
          exsr write_iavarrel;                                                           //0037

        //For parsing index of array, if exist                                          //0037
        when %scan('(':first_var) > 0;                                                   //0037
          pos_open_bracket  = %scan('(' : first_var : 1);                                //0037
          if %len(first_var) > pos_open_bracket;                                         //0050
             pos_close_bracket = %scan(')' : first_var : pos_open_bracket+1);            //0037
          endif;                                                                         //0050
          element = %subst(first_var : 1 : pos_open_bracket-1);                          //0037
          exsr check_if_array;                                                           //0037
          if ArrFound = 'Y';                                                             //0037
             in_refact1 = element;                                                       //0037
             in_reseq   += 1;                                                            //0037
             exsr write_iavarrel;                                                        //0037

             if pos_close_bracket-pos_open_bracket-1 > 0;                                //0037
                BreakStr = %subst(first_var : pos_open_bracket+1 :                       //0037
                                           pos_close_bracket-pos_open_bracket-1);        //0037
             endif;                                                                      //0037

             IaBreakSrcString(BreakStr:ReturnArray:Index);                               //0037
             for counter = 1 to Index;                                                   //0037
                if ReturnArray(counter) = *blanks;                                       //0037
                   iter;                                                                 //0037
                endif;                                                                   //0037
                in_refact1  = isVariableOrConst(ReturnArray(counter));                   //0037
                in_reseq   += 1;                                                         //0037
                exsr write_iavarrel;                                                     //0037
             endfor;                                                                     //0037
          endif;                                                                         //0037

        other;                                                                           //0037
          in_refact1 = first_var;                                                        //0037
          in_reseq   += 1;                                                               //0037
          exsr write_iavarrel;                                                           //0037
      endsl;                                                                             //0037
                                                                                         //0037
    endif;                                                                               //0037
  endif;                                                                                 //0037
                                                                                         //0037
  return;                                                                                //0037

  begsr write_iavarrel;                                                                  //0037

    if in_reseq > 1;                                                                     //0037
       clear in_REOPC;                                                                   //0037
    endif;                                                                               //0037

    IAVARRELLOG(in_RESRCLIB:                                                             //0037
                in_RESRCFLN:                                                             //0037
                in_REPGMNM:                                                              //0037
                in_REIFSLOC:                                                             //0062
                in_RESEQ:                                                                //0037
                in_RERRN:                                                                //0037
                in_REROUTINE:                                                            //0037
                in_RERELTYP:                                                             //0037
                in_RERELNUM:                                                             //0037
                in_REOPC:                                                                //0037
                in_RERESULT:                                                             //0037
                in_REBIF:                                                                //0037
                in_REFACT1:                                                              //0037
                in_RECOMP:                                                               //0037
                in_REFACT2:                                                              //0037
                in_RECONTIN:                                                             //0037
                in_RERESIND:                                                             //0037
                in_RECAT1:                                                               //0037
                in_RECAT2:                                                               //0037
                in_RECAT3:                                                               //0037
                in_RECAT4:                                                               //0037
                in_RECAT5:                                                               //0037
                in_RECAT6:                                                               //0037
                in_REUTIL:                                                               //0037
                in_RENUM1:                                                               //0037
                in_RENUM2:                                                               //0037
                in_RENUM3:                                                               //0037
                in_RENUM4:                                                               //0037
                in_RENUM5:                                                               //0037
                in_RENUM6:                                                               //0037
                in_RENUM7:                                                               //0037
                in_RENUM8:                                                               //0037
                in_RENUM9:                                                               //0037
                in_REEXC:                                                                //0037
                in_REINC);                                                               //0037

  endsr;                                                                                 //0037

  begsr check_if_array;                                                                  //0037

    exec sql                                                                             //0037
      select 'Y' as flag                                                                 //0037
        into :ArrFound                                                                   //0037
        from IAPGMVARS                                                                   //0037
        where IAV_MBR   = :in_srcmbr                                                     //0037
          and IAV_SFILE = :in_srcspf                                                     //0037
          and IAV_LIB   = :in_srclib                                                     //0037
          and IAV_VAR   = :element                                                       //0037
          and (IAV_TYP  = 'CT_AR'                                                        //0037
          or  IAV_TYP   = 'RT_AR'                                                        //0037
          or  IAV_TYP   = 'PT_AR');                                                      //0037

  endsr;                                                                                 //0037

end-proc;                                                                                //0037

** CTDATA keywordarr
EXISTS
FETCH
ANY
ALL
WHERE
HAVING
GROUP BY
ORDER BY
AS
ON
TRIM
LIMIT                                                                                    //SB02
** CTDATA aggregatearr
SUM
COUNT
AVG
MAX
MIN
** ctdata KEYWRDARRAY
WHEN
THEN
ELSE
IS
XXXX                        //<=                                                            //VM005
XXXX                        //=>                                                            //VM005
+
-
/
*
=                                                                                           //VM005
XXXX                        //>                                                             //VM005
XXXX                        //<                                                             //VM005
** ctdata KEYWRDARRAY1
INNER
OUTER
LEFT
RIGHT
EXCEPTION
JOIN
FULL
ON
,,
** ctdata KEYWRDARRAY2                                                                      //VM05
<=                                                                                          //VM05
=>                                                                                          //VM05
<                                                                                           //VM05
>                                                                                           //VM05
=                                                                                           //VM05
** CTDATA FILTERARR
1
2
3
4
5
6
7
8
9
0
+
-
*
/
,
** CTDATA SQLDatTypArr
BINARY             CHAR
VARBINARY          VARCHAR
BLOB               CHAR
BLOB_LOCATOR       UNS(10)
CLOB               CHAR
CLOB_LOCATOR       UNS(10)
DBCLOB             GRAPH
DBCLOB_LOCATOR     UNS(10)
BLOB_FILE          CHAR(255)
CLOB_FILE          CHAR(255)
DBCLOB_FILE        CHAR(255)
ROWID              VARCHAR(40)
RESULT_SET_LOCATOR INT(20)
XML_BLOB           CHAR
XML_CLOB           CHAR
XML_DBCLOB         UCS2
XML_LOCATOR        UNS(10)
XML_BLOB_FILE      CHAR(255)
XML_CLOB_FILE      CHAR(255)
XML_DBCLOB_FILE    CHAR(255)
** CTDATA CLOPCODEARR                                                                   //vm06
*CAT                                                                                    //vm06
*BCAT                                                                                   //vm06
*TCAT                                                                                   //vm06
*AND                                                                                    //vm06
*OR                                                                                     //vm06
*NOT                                                                                    //vm06
*EQ                                                                                     //vm06
*GT                                                                                     //vm06
*LT                                                                                     //vm06
*GE                                                                                     //vm06
*LE                                                                                     //vm06
*NE                                                                                     //vm06
*NG                                                                                     //vm06
*NL                                                                                     //vm06
||                                                                                      //vm06
¬                                                                                       //vm06
|>                                                                                      //vm06
>=                                                                                      //vm06
|<                                                                                      //vm06
<=                                                                                      //vm06
|                                                                                       //vm06
¬=                                                                                      //vm06
¬>                                                                                      //vm06
¬<                                                                                      //vm06
=                                                                                       //vm06
>                                                                                       //vm06
<                                                                                       //vm06
+                                                                                       //vm06
-                                                                                       //vm06
/                                                                                       //vm06
*                                                                                       //vm06
** CTDATA KEYWORDARRAY3
RENAME(
CONCAT(
SST(
ALIAS(
REFFLD(
COMP(
JFLD(
JDUPSEQ(
** CTDATA CLSPCLKEYWD
*LDA
*GDA
** CTDATA RelOprAry
EQ
NE
LT
NL
GT
NG
LE
GE
** CTDATA keywordExcArr
REFFLD(
ALIAS(
** CTDATA DSPFKWARRAY
ALIAS
CHCACCEL
CHCCTL
CHKMSGID
CHOICE
CSRLOC
DSPATR
ERRMSGID
HLPPNLGRP
HLPRCD
HTML
MNUBARCHC
MNUBARDSP
MSGID
PSHBTNCHC
REFFLD
RTNCSRLOC
SFLCSRRRN
SFLMLTCHC
SFLMODE
SFLMSGID
SFLSIZ
WDWTITLE
WINDOW
** CTDATA DSPFRFARRAY
ALIAS
REFFLD
** CTDATA urFileFieldKeyWord
CONCAT(
SST(
