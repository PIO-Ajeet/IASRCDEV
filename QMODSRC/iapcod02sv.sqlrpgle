**free
      //%METADATA                                                      *
      // %TEXT RPG3 IA Pseudocode generation service pgm               *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------- //
//Created By   :  Programmers.io @ 2024                                                 //
//Created Date :  2024/05/01                                                            //
//Developer    :  Programmers.io                                                        //
//Description  :  Service Program to fetch the control data for Pseudocode              //
//                                                                                      //
//Procedure Log:                                                                        //
//------------------------------------------------------------------------------------- //
//Procedure Name           | Procedure Description                                      //
//-------------------------|----------------------------------------------------------- //
//processRpg3CSpec         | Procedure to process the RPG3 C-spec statements            //
//                         |                                                            //
//------------------------------------------------------------------------------------- //
//                                                                                      //
//Modification Log:                                                                     //
//------------------------------------------------------------------------------------- //
//Date    | Mod_ID | Developer  | Case and Description                                  //
//--------|--------|------------|------------------------------------------------------ //
//06/06/24| 0001   | SHOBHIT    | Task:708 RPG3 program C_spec special cases            //
//12/06/24| 0002   | SHOBHIT    | Task:718 RPG3 Seperating decimal with ':'             //
//20/06/24| 0003   | SHOBHIT    | Task:719 RPG3 program C_spec special cases generic    //
//24/06/24| 0004   | SHOBHIT    | Task:735 RPG3 Some Observations                       //
//10/07/24| 0005   | SANTOSH    | Task:773 Analysis for error in error log file         //
//        |        |            |      AIdumpdtlp/AIerrlogp for RPG3.                   //
//10/07/24| 0006   | SUSHANT    | Task:712 RPG3 I Spec Improvement for alignment of     //
//        |        |            |      DS field decleration and Added scenario for DS   //
//        |        |            |      decleration without any name                     //
//24/07/24| 0007   | RUHI       | Task:724 Enhancement in procedure Calling Name        //
//        |        |            | and parameters in RPG3 source                         //
//24/07/24| 0008   | RUHI       | Task:818 In RPG, if result field is Blanks in case    //
//       |        |            | of parameter call, &Var3 is displayed in pseudocode   //
//        |        |            | This needs to be fixed.                              //
//24/06/24| 0009   | Azhar Uddin| Task:734 - Consider to print non-RPG names for files  //
//25/07/24| 0010   | Gokul R    | Task:817 Determine whether the Tag can be printed as  //
//        |        |            |      Bold based on the wkIndentType value and populate//
//        |        |            |      the new column "Font Code" of IAPSEUDOWK table   //
//        |        |            |      with 'B' in 1st position to indicate the Tag     //
//        |        |            |      which needs to be printed with Bold Font         //
//01/08/24| 0011   | Gokul R    | Task:785 - Increased the FileMode Size to 8 and       //
//        |        |            | decreased the FileKey Size to 4 to align the File     //
//        |        |            | declaration Mode properly and blank out the FileKey   //
//        |        |            | when there is no key                                  //
//13/08/24| 0012   | MANJU      | Task:798 RPG3 C Spec Pseudo code Improvement          //
//        |        |            |      for Opcode with Factor1 Optional                 //
//01/08/24| 0013   | Azhar Uddin| Task #739 - Modify to write a comment in case there   //
//        |        |            |             is no executable code inside a loop or    //
//        |        |            |             condition or subroutine.                  //
//05/08/24| 0014   | Munumonika | Task:835 - RPG-3 Declaration spec, print in same      //
//        |        |            | format as RPGiV                                       //
//07/08/24| 0015   | SHOBHIT    | Task:836 RPG-3 Alignment is not proper in I spec      //
//24/08/28| 0016   | Manju      | Task #889 - Added logic to Change Pseudo for CALL     //
//        |        |            |           with PARM Keyword having Factor1/Factor2    //
//24/08/26| 0017   | Manju      | Task #879 - Added Logic to Append Pipe Indent to RPG3 //
//        |        |            |             Blank lines Inbetween every Tagged lines  //
//24/08/30| 0018   | Manju      | Task #904 - Added Logic to Improve Text for SETON and //
//        |        |            |             SETOF Indicator                           //
//02/09/24| 0019   | Shefali    | Task:895 Split Pseudo code to subsequent lines if it  //
//        |        |            | more than 109 characters to fit report page           //
//29/08/24| 0020   | Azhar Uddin| Task:893 - Use correct source type in I spec parsing  //
//        |        |            |            and modify processing to handle all        //
//        |        |            |            possible scenarios in I spec.              //
//05/09/24| 0021   | Himanshu   | Avoid exceptions(handling variable len assignemnts)   //
//11/09/24| 0022   | Shefali    | Task:909 Report array variables correctly in Factor1  //
//        |        |            |  and Factor 2 in IF,MOVE keywords                     //
//03/09/24| 0023   | Manju      | Task:912 Added Pipe for Split lines and Bold issue    //
//        |        |            |          for Split on Tagged Lines                    //
//11/09/24| 0024   | Manju      | Task:904 Changed Logic to Improve Text for SETON and  //
//        |        |            |          SETOF Indicator                              //
//12/09/24| 0025   | Shefali    | Task:908 Fix issues with Z-ADD and MOVE* keywords     //
//        |        |            | when Factor 2 is 0/*ZERO/*ALL                         //
//24/09/06| 0026   | Manju      | Task:918 Changed logic to write IAPSEUDOWK through    //
//        |        |            |          Procedure WriteIaPseudowk instead Subroutine //
//04/09/24| 0027   | Shefali    | Task:913 - Fix code to not print 2 subsequent blank   //
//        |        |            | lines between 2 code lines                            //
//12/09/24| 0028   | Azhar Uddin| Task:926 - Fix issue of the I spec DS subfields with  //
//        |        |            |            Initialized value (Prompt type SV)         //
//03/09/24| 0029   | Azhar Uddin| Task:802 - For 'TAG' op-code consider to write a      //
//        |        |            |            blank line after the pseudo-code           //
//11/09/24| 0030   | Azhar Uddin| Task #689 : Added new procedure WriteCommentedText    //
//        |        |            |             to write the input commented text to o/p  //
//19/09/24| 0031   | Azhar Uddin| Task:928 - Fix code to print array variable correctly //
//        |        |            |            if given in parameter list.                //
//03/09/24| 0032   | Manju      | Task:911 Added logic to Change Pseudo for PLIST       //
//        |        |            |          with PARM Keyword having Factor1/Factor2     //
//        |        | Srini G    | Task:1040 Added logic to Fix With Parameter Mapping   //
//        |        |            |           issue for PARM                              //
//08/10/24| 0033   | SriniG     | Task:975  Handling Data Area operations in RPG        //
//19/09/24| 0034   | Manju      | Task:922 Added Logic to handle Conditional Indicator  //
//        |        |            |          for any Opcode on Cspec                      //
//07/10/24| 0035   | Shefali    | Task:970 - Print a new format for F spec based on the //
//        |        |            |            configuration flag                         //
//27/09/24| 0036   | Gokul R    | Task:931 - Minimize the repetition of SQL queries by  //
//        |        |            |            reusing the existing procedure to retrieve //
//        |        |            |            Pseudocode mapping details                 //
//29/10/24| 0037   | Shefali    | Task:1051 Added logic to handle numeric fields and    //
//        |        |            |           stop adding decimal data error to joblog    //
//29/11/24| 0038   | Azhar Uddin| Task:815 - Modify code to use new indentation proced- //
//        |        |            |            ure to apply correct indentation for       //
//        |        |            |            Selec-WhXX, If-ElseIf ladder and CASxx     //
//25/11/24| 0039   | Mahima T   | Task:1071 Except F and C spec other spec should be    //
//        |        |            |           optional to print in RPG3 pseudo code       //
//        |        |            |           and K spec will only print if comes after C //
//05/09/24| 0040   | Gokul R    | Task:910 Handling SetLL & SetGT opcodes to make the   //
//        |        |            | sentence more clearer                                 //
//27/12/24| 0041   | Monika     | Task:925 SFILE keyword not appearing in document      //
//07/01/25| 0042   | HIMANSHUGA | Task:1099-Determine if declaration specs will be      //
//        |        |            | included in doc.                                      //
//------------------------------------------------------------------------------------- //
Ctl-Opt Copyright('Programmers.io Â© 2024 | Created Nov 2024');
Ctl-Opt Option(*noDebugIo: *srcStmt: *noUnRef) expropts(*RESDECPOS) debug;
Ctl-Opt Nomain;
Ctl-Opt BndDir('IABNDDIR' : 'IAERRBND');

//------------------------------------------------------------------------------------- //
//Copybook Definitions
//------------------------------------------------------------------------------------- //
/copy 'QMODSRC/iapcod01pr.rpgleinc'
/copy 'QMODSRC/iapcod02pr.rpgleinc'
/copy 'QMODSRC/iasrv01pr.rpgleinc'
/copy 'QCPYSRC/rpgiiids.rpgleinc'
/copy 'QCPYSRC/iaderrlog.rpgleinc'

//------------------------------------------------------------------------------------- //
//Constant Variables
//------------------------------------------------------------------------------------- //
Dcl-C SQL_ALL_OK         '00000';
Dcl-C True               '1';
Dcl-C False              '0';
Dcl-C cwUP               'ABCDEFGHIFKLMNOPQRSTUVWXYZ';
Dcl-C cwLO               'abcdefghijklmnopqrstuvwxyz';
Dcl-C cwSrcLength        4046;
Dcl-C cwAdd              Const('ADD');                                                   //0010
Dcl-C cwAddCheck         Const('ADDCHK');                                                //0010
Dcl-C cwRemove           Const('REMOVE');                                                //0010
Dcl-C cwRemoveCheck      Const('REMOVECHK');                                             //0010
Dcl-C cwBranch           Const('BRANCH');                                                //0038
Dcl-C cwCase             Const('CASE');                                                  //0038
Dcl-C cwNewBranch        Const('NEWBRANCH');                                             //0038
Dcl-C cwSplitCharacter   Const('~&|.');                                                  //0038
Dcl-C cwBoldFont         Const('B');                                                     //0010
Dcl-C cwNewFormat       Const('LFSPECFORMAT') ;                                          //0035
Dcl-C cwStoreData       Const('S') ;                                                     //0035
Dcl-C cwWriteData       Const('W') ;                                                     //0035
Dcl-C cwFX3             Const('FX3');                                                    //0036
Dcl-C cwC               Const('C');                                                      //0036
Dcl-C cwDigits          Const('0123456789');                                             //0037

Dcl-S wkFontCodeVar      Char(4)              Inz;                                       //0010

//------------------------------------------------------------------------------------- //
//Variables Definitions                                                                 //
//------------------------------------------------------------------------------------- //
Dcl-S wkCountOfLinesUnderTag Packed(6:0) Inz;                                            //0013
Dcl-S wkDoNothingComment     Char(109);                                                  //0013
Dcl-S wkPreviousIndentType   Char(10);                                                   //0013
Dcl-S wkHoldForParm          Ind ;                                                       //0016
Dcl-S IndentParmPointer      Pointer;                                                    //0038
Dcl-S wkTempCallMap          VarChar(cwSrcLength) ;                                      //0016
Dcl-S wkISpecConstValArr     Char(22) Dim(99) Inz;                                       //0020
Dcl-S wkParmEntryRtnArr      Char(120) Dim(100) ;                                        //0032
Dcl-S wkPrIdx1               Packed(3:0) ;                                               //0032
Dcl-S wkPrIdx2               Packed(3:0) ;                                               //0032
Dcl-S wkISpecConstValArrCnt  Packed(3:0) Inz;                                            //0020
Dcl-S wkLastwrittenData      Char(110)   Inz ;                                           //0027
Dcl-S wkTempCIndMapping      VarChar(cwSrcLength) ;                                      //0034
Dcl-S wkFileConfigFlag       Char(12)    Inz ;                                           //0035
Dcl-S wkKeyWrdCntr           Packed(2:0) Inz ;                                           //0035
Dcl-S wkFileDtlCntr          Packed(2:0) Inz ;                                           //0035
Dcl-S wkiAPseudoMpCount      Packed(4:0) Inz;                                            //0036
Dcl-S wkIndentType3          Char(10)    Inz;                                            //0036
Dcl-S wkMapIdx               Packed(4:0) Inz;                                            //0036
Dcl-S wkSrcLtyp3             Char(5)     Inz;                                            //0036
Dcl-S wkSrcSpec3             Char(1)     Inz;                                            //0036
Dcl-S WkMpIakeyfield2        Char(10)    Inz;                                            //0036
//------------------------------------------------------------------------------------- //
//Data Structure Definitions                                                            //
//------------------------------------------------------------------------------------- //

Dcl-Ds wkIndentParmDS  Qualified inz;
   dsIndentType        Char(10);
   dsIndentLevel       Packed(5:0);
   dsPseudocode        Char(4046);
   dsMaxLevel          Packed(5:0);
   dsIncrLevel         Packed(5:0);
   dsIndentArray       Packed(5:0) Dim(999);
End-Ds;

//Data Structure to Holds Data Types
Dcl-Ds RPG3DataTypeDs  Qualified Dim(20);
   dsDataType     Char(15);
   dsDataTypeDesc Char(30);
End-Ds;

//F spec note data structure
Dcl-Ds FSpecNoteDs Qualified Dim(10);
   dsNote         Char(60);
End-Ds;

//F spec mapping data structure
Dcl-Ds FSpecMappingDs likeds(SpecMappingDs) Dim(100) Inz;                                //0021

//C spec mapping data structure for Optional Variable                                   //0012
Dcl-Ds CSpecMappingDs likeds(SpecMappingDs) Dim(100);                                    //0012

//I spec header for record format & its fields                                          //0020
Dcl-Ds DSIspecRcdFmtHdr qualified Dim(4);                                                //0020
   HeaderMapping  Char(200);                                                             //0020
End-Ds;                                                                                  //0020

//I spec header for DS & its fields                                                     //0020
Dcl-Ds DSIspecDSHdr qualified Dim(4);                                                    //0020
   HeaderMapping  Char(200);                                                             //0020
End-Ds;                                                                                  //0020

//I spec header for constants and their values                                          //0020
Dcl-Ds DSIspecConstantHdr qualified Dim(3);                                              //0020
   HeaderMapping  Char(200);                                                             //0020
End-Ds;                                                                                  //0020
Dcl-Ds RPGIndentParmDs LikeDS(RPGIndentParmDsTmp) Based(IndentParmPointer);              //0038
//------------------------------------------------------------------------------------- //
//Prototype Definitions
//------------------------------------------------------------------------------------- //

//------------------------------------------------------------------------------------- //
//Main Logic
//------------------------------------------------------------------------------------- //
Exec Sql
   Set Option Commit = *None,
              Naming = *Sys,
              UsrPrf = *User,
              DynUsrPrf = *User,
              CloSqlCsr = *Endmod,
              SrtSeq = *Langidshr;

//------------------------------------------------------------------------------------- //
//Procedure to parse the RPG3 H - Spec source                                           //
//------------------------------------------------------------------------------------- //

Dcl-Proc rpg3HSpecParser Export;

   Dcl-Pi rpg3HSpecParser;
      inHSpecParmPointer Pointer;
   End-Pi;

   // Declaration of datastructure
   // H Spec Parser Parameter datastructure
   Dcl-Ds inHSpecParmDS  Qualified Based(inHSpecParmPointer);
      inReqId        Char(18);
      inSrcLib       Char(10);
      inSrcPf        Char(10);
      inSrcMbr       Char(10);
      insrcType      Char(10);
      inSrcRrn       Packed(6:0);
      inSrcSeq       Packed(6:2);
      inSrcLtyp      Char(5);
      inSrcSpec      Char(1);
      inSrcLnct      Char(1);
      inSrcDta       VarChar(cwSrcLength);
      IOIndentParmPointer Pointer;                                                       //0038
      inDclType      Char(10);
      inSubType      Char(10);
      inhCmtReqd     Char(1);
      inSkipNxtStm   ind;                                                                //0005
      inFileNames    char(10) dim(99);                                                   //0005
      inFileCount    zoned(2:0);                                                         //0005
      inDocSeq       packed(6:0);                                                        //0005
      inVarAry       Char(6) dim(9999);                                                  //0005
      inVarCount     zoned(4:0);                                                         //0005
      inIfCount      zoned(4:0);                                                         //0005
      inSkipParm     ind;                                                                //0007
   End-Ds;

   //Declaration of work variables
   Dcl-S  wkPseudoCode                Char(cwSrcLength) Inz;
   Dcl-S  wkSrcType                   Char(10);
   Dcl-S  wkHSpecKeyword              Char(30);
   Dcl-S  wkSrcDta                    VarChar(cwSrcLength) Inz;
   Dcl-S  wkHSpecMapping              Char(200);
   Dcl-S  IOParmPointer               Pointer Inz(*Null);
   Dcl-S  wkSrcSpec                   Char(1) Inz;
   Dcl-S  wkHSpecDescription          Char(300);

   Dcl-C  colon                       ': ';
   //------------------------------------------------------------------------------------- //
   //CopyBook declaration
   //------------------------------------------------------------------------------------- //
/copy 'QCPYSRC/iaprderlog.rpgleinc'

   // Initialise the variables
   exsr Initialise;

   exsr checkRpg3HSpecKeyword;

   Return;

   //--------------------------------------------------------------------
   //Check RPG3 HSpec Keyword
   //--------------------------------------------------------------------
   begSr checkRpg3HSpecKeyword;

      if debug <> *blanks;
         wkHSpecKeyword = 'DEBUG';
         wkHSpecDescription = debug + colon + 'DEBUG/DUMP operation';
         exsr processRpg3HSpecKeyword;
      endif;

      if currency <> *blanks;
         wkHSpecKeyword = 'CURSYM';
         wkHSpecDescription = currency;
         exsr processRpg3HSpecKeyword;
      endif;

      if dateformat <> *blanks;
         wkHSpecKeyword = 'DATFMT';

         select;

            when dateformat = 'M' or
                 (dateformat = *blanks and invertprint = *blanks);
               wkHSpecDescription = dateformat + colon + 'month/day/year';

            when dateformat = 'D' or
                 (dateformat = *blanks and invertprint = 'D') or
                 (dateformat = *blanks and invertprint = 'I') or
                 (dateformat = *blanks and invertprint = 'J');
               wkHSpecDescription = dateformat + colon + 'day/month/year';

            when dateformat = 'Y';
               wkHSpecDescription = dateformat + colon + 'year/month/day';

            other;
         endsl;

         exsr processRpg3HSpecKeyword;
      endif;

      if dateedit <> *blanks;
         wkHSpecKeyword = 'DATEDIT';

         if dateedit = '&';
            wkHSpecDescription =  dateedit + colon +
                                  'Blank is used as separator character';
         else;
            wkHSpecDescription = dateedit;
         endif;

         exsr processRpg3HSpecKeyword;
      endif;

      if invertprint <> *blanks;
         wkHSpecKeyword = 'INVPRT';

         select;

            when invertprint = 'I';
               wkHSpecDescription = invertprint + colon +
                                    'Numeric fields use a comma to denote decimals ' +
                                    'and a period as a separator.';

            when invertprint = 'J';
               wkHSpecDescription = invertprint + colon +
                                    'J is same as I, except zero is written to the ' +
                                    'left of the decimal (comma) when the field ' +
                                    'contains a zero balance.';

            when invertprint = 'D';
               wkHSpecDescription = invertprint + colon +
                                    'Numeric fields use a period to denote decimals ' +
                                    'and a comma as a separator.';
            other;
         endsl;

         exsr processRpg3HSpecKeyword;
      endif;

      if alternatesequence <> *blanks;
         wkHSpecKeyword = 'ALTSEQ';

         select;

            when alternatesequence = 'S';
               wkHSpecDescription = alternatesequence + colon +
                                    'The alternate-collating-sequence records are ' +
                                    'specified in the program.';

            when alternatesequence = 'D';
               wkHSpecDescription = alternatesequence + colon +
                                    'The alternate-collating-sequence specified '   +
                                    'in the SRTSEQ or LANGID parameter of the ' +
                                    'CRTRPGPGM or CRTRPTPGM command.';
            other;
         endsl;
         exsr processRpg3HSpecKeyword;
      endif;

      if onepformsPosition <> *blanks;
         wkHSpecKeyword = '1PFORMS';
         wkHSpecDescription = onepformsPosition + colon +
                              'The first line print repeatedly';
         exsr processRpg3HSpecKeyword;
      endif;

      if filetranslation <> *blanks;
         wkHSpecKeyword = 'FILTRN';
         wkHSpecDescription = filetranslation + colon +
                              'Files translated.';
         exsr processRpg3HSpecKeyword;
      endif;

      if programname <> *blanks;
         wkHSpecKeyword = 'PGMID';
         wkHSpecDescription = programname;
         exsr processRpg3HSpecKeyword;
      endif;

   endsr;

   //--------------------------------------------------------------------
   //Process RPG3 HSpec Keyword
   //--------------------------------------------------------------------
   begSr processRpg3HSpecKeyword;

      //Get the mapping for the keyword
      Exec Sql
        Select iASrcMap  Into  :wkHSpecMapping
        From IaPseudoMP
        Where iASrcMTyp = :wkSrcType
        And iASrcSpec = :wkSrcSpec
        And iAKeyFld1 = :wkHSpecKeyword;

      if SqlCode < SuccessCode;
         uDpsds.wkQuery_Name = 'Select_IaHspecPseudoMP';
         IaSqlDiagnostic(uDpsds);
      endIf;

      if SqlCode = SuccessCode;
         wkPseudocode = %trim(wkHSpecMapping);
         wkPseudocode = %trim(wkPseudocode) + ' ' + %trim(wkHSpecDescription);
         exsr writeRpg3HSpecPseudocode;
      endif;

   endsr;

//------------------------------------------------------------------------------------- //
//WriteHSpecPseudocode - Subroutine to write H Spec Pseudocode                          //
//------------------------------------------------------------------------------------- //
   Begsr WriteRpg3HSpecPseudocode;
      OutParmWriteSrcDocDS.dsPseudocode = %Trim(wkPseudocode);
      ioParmPointer  = %Addr(OutParmWriteSrcDocDS);
      WritePseudoCode(ioParmPointer);
   Endsr;

//------------------------------------------------------------------------------------- //
//Initialise - Initialise the work variables                                            //
//------------------------------------------------------------------------------------- //
   Begsr Initialise;
     wkSrcDta                    =  %TrimL(inHSpecParmDS.inSrcDta);
     hSpecDs                     =  inHSpecParmDS.inSrcDta;
     wkSrcSpec                   =  inHSpecParmDS.inSrcSpec;
     wkSrcType                   =  'RPG';
     OutParmWriteSrcDocDS        =  inHSpecParmDS;
     wkHSpecKeyword              = *Blanks;
     wkHSpecMapping              = *Blanks;
     wkPseudocode                = *Blanks;
     wkHSpecDescription          = *Blanks;
   Endsr;

/copy 'QCPYSRC/iaprcerlog.rpgleinc'
End-Proc;

//------------------------------------------------------------------------------------- //
//Procedure to parse the RPG3 F - Spec source                                           //
//------------------------------------------------------------------------------------- //

Dcl-Proc rpg3FSpecParser Export;

   Dcl-Pi rpg3FSpecParser;
      inFSpecParmPointer Pointer;
   End-Pi;

   // Declaration of datastructure
   // F Spec Parser Parameter datastructure
   Dcl-Ds inFSpecParmDS  Qualified Based(inFSpecParmPointer);
      inReqId        Char(18);
      inSrcLib       Char(10);
      inSrcPf        Char(10);
      inSrcMbr       Char(10);
      insrcType      Char(10);
      inSrcRrn       Packed(6:0);
      inSrcSeq       Packed(6:2);
      inSrcLtyp      Char(5);
      inSrcSpec      Char(1);
      inSrcLnct      Char(1);
      inSrcDta       VarChar(cwSrcLength);
      IOIndentParmPointer Pointer;                                                       //0038
      inDclType      Char(10);
      inSubType      Char(10);
      inbCmtReqd     Char(1);
      inSkipNxtStm   ind;                                                                //0005
      inFileNames    char(10) dim(99);                                                   //0005
      inFileCount    zoned(2:0);                                                         //0005
      inDocSeq       packed(6:0);                                                        //0005
      inVarAry       Char(6) dim(9999);                                                  //0005
      inVarCount     zoned(4:0);                                                         //0005
      inIfCount      zoned(4:0);                                                         //0005
      inSkipParm     ind;                                                                //0007
   End-Ds;
                                                                                         //0035
   Dcl-Ds dsFSpecLFNewFormat likeDS(TdsFSpecLFNewFormat)   Inz(*likeDS) ;                //0035
   Dcl-Ds dsFSpecKeywords    likeDS(TdsFSpecKeywords)                                    //0035
                             Dim(99)  Inz(*likeDS) ;                                     //0035

   //Declaration of work variables
   Dcl-S  wkPseudoCode                Char(cwSrcLength) Inz;
   Dcl-S  wkSrcType                   Char(10);
   Dcl-S  wkFSpecKeyword              Char(30);
   Dcl-S  wkSrcDta                    VarChar(cwSrcLength) Inz;
   Dcl-S  wkSrcStmt                   VarChar(cwSrcLength) Inz;
   Dcl-S  wkFSpecMapping              Char(200);
   Dcl-S  IOParmPointer               Pointer Inz(*Null);
   Dcl-S  wkSrcSpec                   Char(1) Inz;
   Dcl-S  wkFSpecDescription          Char(300);

   Dcl-S  wkScanPos                   Packed(3:0)   Inz;
   Dcl-S  wkFileOSpecCount            Packed(3:0)   Inz;
   Dcl-S  wkFileKey                   Char(4)       Inz;                                 //0011
   Dcl-S  wkFName                     Char(11)      Inz;
   Dcl-S  wkFMode                     Char(8)       Inz;                                 //0011
   Dcl-S  wkFRcdFormat                Char(24)      Inz;
   Dcl-S  wkFDevice                   Char(11)      Inz;
   Dcl-S  wkFileName                  Char(8)       Inz;
   Dcl-S  wkOtherSpecification        Char(70)      Inz;
   Dcl-S  urOtherentry                char(70) dim(100);
   Dcl-S  uiOtherentry                uns(5)        Inz;
   Dcl-S  uiNote                      uns(5)        Inz;
   Dcl-S  wkFirstRecord               ind           Inz;
   Dcl-S  wkLSpecOnNextRecord         ind           Inz;
   Dcl-S  wkFileAttribute       Char(10)      Inz;                                       //0009
   Dcl-S  wkIndexFlag           Char(1)       Inz;                                       //0009
   Dcl-S  wkCallMode                  Char(1)       Inz ;                                //0035
   Dcl-S  wkKeyWrdPointer             Pointer       Inz ;                                //0035
   Dcl-S  wkKeyWrdCntr                Packed(2:0)   Inz ;                                //0035

   Dcl-C  colon              Const(':');
   Dcl-C  space              Const('  ');
   Dcl-C  slash              Const('/');
   Dcl-C  cwDelimiter        Const('| ');
   Dcl-C  cwDisk             Const('DISK');                                              //0009
   Dcl-C  cwPF               Const('PF');                                                //0009
   Dcl-C  cwLF               Const('LF');                                                //0009
   Dcl-C  cwINDEX            Const('IX');                                                //0009
   Dcl-C  cwVIEW             Const('VW');                                                //0009
   //------------------------------------------------------------------------------------- //
   //CopyBook declaration
   //------------------------------------------------------------------------------------- //
/copy 'QCPYSRC/iaprderlog.rpgleinc'

   // Initialise the variables
   exsr Initialise;

   exsr processRpg3FSpec;

   Return;

   //--------------------------------------------------------------------
   //process RPG3 F Spec
   //--------------------------------------------------------------------
   begSr processRpg3FSpec;

      clear fSpecDsV3;
      fSpecDsV3 = wkSrcDta;

      //Fetching File Name
      wkFName = %Trim(FSpecDsV3.FileName);

      //Fetching File Mode
      wkFMode = '  ' + FSpecDsV3.FileType;

      if FSpecDsV3.fileAddition <> *blanks;
        wkFMode = %trim(wkFMode) + slash + 'O';
      endif;

      //Before fetching file device, check if its a PF/LF by retrieving the attributes  //0009
      If FSpecDsV3.Device = cwDisk;                                                      //0009
         exec sql select iAObjAtr into :wkFileAttribute from IAOBJECT                    //0009
                   where iAObjNam = :wkFName and iAObjTyp = '*FILE' Limit 1;             //0009
         //If the file is a logical file, consider it as Index for priting if its a     //0009
         // keyed logical AND it must also not be a join logical.                       //0009
         If wkFileAttribute = cwLF;                                                      //0009
            wkIndexFlag = 'N';                                                           //0009
            exec sql select 'Y' into :wkIndexFlag from IDSPFDKEYS                        //0009
                      where APKeyF <> ' ' and APKeyF <> '*NONE'                          //0009
                      and   APFile = :wkFName and APJoin<>'Y';                           //0009
            If wkIndexFlag = 'Y';                                                        //0009
               FSpecDsV3.Device = %Trim(FSpecDsV3.Device) + '-'+ cwINDEX;                //0009
            Else;                                                                        //0009
               FSpecDsV3.Device = %Trim(FSpecDsV3.Device) + '-'+ cwVIEW;                 //0009
            EndIf;                                                                       //0009
         Else;                                                                           //0009
            FSpecDsV3.Device = %Trim(FSpecDsV3.Device) + '-' + cwPF;                     //0009
         EndIf;                                                                          //0009
      EndIf;                                                                             //0009
      //Fetching File Device
      wkScanPos = %Lookup(%Xlate(cwLo:cwUp:FSpecDsV3.Device)
                                          :FSpecMappingDs(*).dsKeywrdOpcodeName);
      if wkScanPos <> *Zeros;
         wkFDevice = %Trim(FSpecMappingDs(wkScanPos).dsSrcMapping);                        //0021
      else;
         wkFDevice = *Blanks;
      endIf;

      //Fetching File is keyed or not
      if FSpecDsV3.RecordAddressType= 'K' ;
      //   wkFileKey = ' Yes';                                                          //0011
         wkFileKey = 'Yes ';                                                             //0011
      else;
      //   wkFileKey = ' No';                                                           //0011
         wkFileKey = *Blanks;                                                            //0011
      endIf;

      if FSpecDsV3.extnCode = 'L' and
         %trim(%Xlate(cwLo:cwUp:FSpecDsV3.Device)) = 'PRINTER' ;                         //0035
         wkLSpecOnNextRecord = *On;
      endif;

      exsr CheckForOtherSpecification;
      exsr CheckForContinuation;
      exsr buildPseudoCode;

   endsr;

//------------------------------------------------------------------------------------- //
//buildPseudoCode - Build PseudoCode                                                    //
//------------------------------------------------------------------------------------- //
   Begsr buildPseudoCode;
      wkFileName = wkFName;
      wkFirstRecord = *off;
      uiOtherentry = 1;

      //Preparing the Pseudocode using Concatenation the Data
      //Populate pseudocode as per the configuration                                     //0035
      If wkFileConfigFlag = cwNewFormat ;                                                //0035
         //Prepare pseudo code in new format using DS defined                            //0035
         dsFSpecLFNewFormat.dsName       = wkFName ;                                     //0035
         dsFSpecLFNewFormat.dsMode       = wkFMode ;                                     //0035
         dsFSpecLFNewFormat.dsDevice     = wkFDevice ;                                   //0035
         wkPseudoCode = dsFSpecLFNewFormat ;                                             //0035
         //Call procedure to get file level details and store in array                   //0035
         If wkFName <> *Blanks ;                                                         //0035
            wkCallMode = cwStoreData ;                                                   //0035
            IaGetLogicalFileDetails(wkCallMode : dsFSpecLFNewFormat :                    //0035
                                    wkKeyWrdPointer : wkKeyWrdCntr) ;                    //0035
         Endif ;                                                                         //0035
      Else ;                                                                             //0035
         //Preparing the Pseudocode using Concatenation the Data                        //0035
         wkPseudoCode = wkFName + cwDelimiter + wkFMode + cwDelimiter + wkFileKey +      //0035
                        cwDelimiter + wkFRcdFormat + cwDelimiter + wkFDevice +           //0035
                        cwDelimiter;                                                     //0035
      Endif ;                                                                            //0035

      dow uiOtherentry <= %elem(urOtherentry);

         wkOtherSpecification = %trim(urOtherentry(uiOtherentry));

         if not wkFirstRecord;

            wkPseudoCode = %trimr(wkPseudoCode) +  %trim(wkOtherSpecification);
            wkFirstRecord = *on;
            exsr WriteRpg3FSpecPseudocode;

         else;

            if wkOtherSpecification <> *blanks;
               exsr BuildBlankPseudoCode;
               wkPseudoCode = %trimr(wkPseudoCode) +  %trim(wkOtherSpecification);
               exsr WriteRpg3FSpecPseudocode;
            endif;

         endif;

         if wkOtherSpecification = *blanks Or wkSrcSpec = 'L';                             //0035
            leave;
         endif;

         uiOtherentry = uiOtherentry + 1;
      enddo;

      if fSpecDsV3.fileFormat = 'F';
         exsr CheckForOSpecification;
      endif;

   endsr;

//------------------------------------------------------------------------------------- //
//CheckForOSpecification - Check if file is defined on O Specification                  //
//------------------------------------------------------------------------------------- //
   Begsr CheckForOSpecification;

      exec sql
        Select Count(*) Into :wkFileOSpecCount
          from IAQRPGSRC
         where upper(Library_Name)  = trim(:inFSpecParmDS.inSrcLib)
           and upper(Sourcepf_Name) = trim(:inFSpecParmDS.inSrcPf)
           and upper(Member_Name)   = trim(:inFSpecParmDS.inSrcMbr)
           and upper(Member_Type)   = trim(:inFSpecParmDS.insrcType)
           and upper(Source_Spec)   = 'O'
           and upper(substr(Source_Data,7,8)) = :wkFileName;

      If SqlCode < SuccessCode;
         uDpsds.wkQuery_Name = 'Select_SrcStmt';
          IaSqlDiagnostic(uDpsds);
      EndIf;

      if wkFileOSpecCount > *zeros;

         uiNote = 1;
         dow uiNote <= %elem(FSpecNoteDs);

            if FSpecNoteDs(uiNote).dsNote = *blanks;
               leave;
            endif;

            exsr BuildBlankPseudoCode;
            wkPseudoCode = %trimr(wkPseudoCode) + %trim(FSpecNoteDs(uiNote).dsNote);
            exsr WriteRpg3FSpecPseudocode;
            uiNote = uiNote + 1;

         enddo;

      endif;

   endsr;

//------------------------------------------------------------------------------------- //
//BuildBlankPseudoCode- Build Blank PseudoCode Line                                     //
//------------------------------------------------------------------------------------- //
   Begsr BuildBlankPseudoCode;

      clear wkFName;
      clear wkFMode;
      clear wkFileKey;
      clear wkFRcdFormat;
      clear wkFDevice;

      wkPseudoCode = wkFName + cwDelimiter + wkFMode +
                     cwDelimiter + wkFileKey +
                     cwDelimiter + wkFRcdFormat + cwDelimiter +
                     wkFDevice + cwDelimiter;

   endsr;

//------------------------------------------------------------------------------------- //
//CheckForOtherSpecification- Check For Other Specification                             //
//------------------------------------------------------------------------------------- //
   Begsr CheckForOtherSpecification;

      if fSpecDsV3.recordLength <> *blanks;
         uiOtherentry = uiOtherentry + 1;
         urOtherentry(uiOtherentry) = 'Record Length' +  colon +
                                      fSpecDsV3.recordLength;
         wkKeyWrdCntr += 1 ;                                                             //0035
         dsFSpecKeywords(wkKeyWrdCntr).dsKeyWrdDtls = urOtherentry(uiOtherentry) ;       //0035
      endif;

      if fSpecDsV3.overFlowIndicatorc <> *blanks;
         uiOtherentry = uiOtherentry + 1;
         urOtherentry(uiOtherentry) = 'Page Break Indicator' +  colon +
                                      fSpecDsV3.overFlowIndicatorc;
         wkKeyWrdCntr += 1 ;                                                             //0035
         dsFSpecKeywords(wkKeyWrdCntr).dsKeyWrdDtls = urOtherentry(uiOtherentry) ;       //0035
      endif;

      if fSpecDsV3.continuation = 'K' and fSpecDsV3.exit <> *blanks;
         uiOtherentry = uiOtherentry + 1;
         urOtherentry(uiOtherentry) = %trim(fSpecDsV3.exit) +  colon +
                                      %trim(%subst(fSpecDsV3.entry : 1 : 6));            //0041
         wkKeyWrdCntr += 1 ;                                                             //0035
         dsFSpecKeywords(wkKeyWrdCntr).dsKeyWrdDtls = urOtherentry(uiOtherentry) ;       //0035
      endif;

   endsr;

//------------------------------------------------------------------------------------- //
//CheckForContinuation - Check for continuation                                         //
//------------------------------------------------------------------------------------- //
   Begsr CheckForContinuation;
      clear wkSrcSpec;
      clear wkSrcStmt;

      exec sql
       declare SrcStmt cursor for
        select ucase(Source_Spec) , ucase(Source_Data)
          from IAQRPGSRC
         where upper(Library_Name)  = trim(:inFSpecParmDS.inSrcLib)
           and upper(Sourcepf_Name) = trim(:inFSpecParmDS.inSrcPf)
           and upper(Member_Name)   = trim(:inFSpecParmDS.inSrcMbr)
           and upper(Member_Type)   = trim(:inFSpecParmDS.insrcType)
           and Source_Rrn           > :inFSpecParmDS.inSrcRrn
           and upper(Source_Spec) in ('F' , 'L');

      exec sql open SrcStmt;
      if sqlCode = CSR_OPN_COD;
         exec sql close SrcStmt;
         exec sql open  SrcStmt;
      endif;

      if sqlCode < successCode;
         uDpsds.wkQuery_Name = 'Open_srcStmt';
         IaSqlDiagnostic(uDpsds);
      endif;

      if sqlCode = successCode;
         exec sql fetch SrcStmt into :wkSrcSpec , :wkSrcStmt;
         if sqlCode < successCode;
            uDpsds.wkQuery_Name = 'Fetch_1_srcStmt';
            IaSqlDiagnostic(uDpsds);
         endif;

         dow sqlCode = successCode;

            if %subst(wkSrcStmt:7:1) = '*';

               exec sql fetch SrcStmt into :wkSrcSpec , :wkSrcStmt;
               if sqlCode < successCode;
                  uDpsds.wkQuery_Name = 'Fetch_1_srcStmt';
                  IaSqlDiagnostic(uDpsds);
               endif;

               iter;
            endif;

            select;

            when wkSrcSpec = 'F';

               clear fSpecDsV3;
               fSpecDsV3 = wkSrcStmt;

               if fSpecDsV3.fileName = *blanks and
                  fSpecDsV3.continuation = 'K';

                  select;
                     when fSpecDsV3.option = 'RENAME';
                        wkFRcdFormat = %trim(fSpecDsV3.extRecordName) +
                                       colon + %trim(fSpecDsV3.entry);
                        //Store file keywords in array                                   //0035
                        If wkFileConfigFlag = cwNewFormat ;                              //0035
                           wkKeyWrdCntr += 1 ;                                           //0035
                           dsFSpecKeywords(wkKeyWrdCntr).dsKeyWrdDtls =                  //0035
                                 fSpecDsV3.option + ' - ' +                              //0035
                                 %trim(fSpecDsV3.extRecordName)                          //0035
                                 + colon + %trim(fSpecDsV3.entry) ;                      //0035
                        Endif ;                                                          //0035

                     when fSpecDsV3.option = 'SFILE';
                        //Store file keywords in array                                   //0035
                        If wkFileConfigFlag = cwNewFormat ;                              //0035
                           wkKeyWrdCntr += 1 ;                                           //0035
                           dsFSpecKeywords(wkKeyWrdCntr).dsKeyWrdDtls =                  //0035
                                 fSpecDsV3.option + ' - '                                //0035
                                 + %trim(fSpecDsV3.entry) + colon                        //0035
                                 + %trim(fSpecDsV3.recordNumField) ;                     //0035
                        Endif ;                                                          //0035
                     other;
                        uiOtherentry = uiOtherentry + 1;                                 //0041
                        urOtherentry(uiOtherentry) =                                     //0041
                                       %trim(fSpecDsV3.option) + '(' +                   //0041
                                       %trim(fSpecDsV3.entry)  + ')';                    //0041
                                                                                         //0041
                        //Store file keywords in array                                   //0041
                        If wkFileConfigFlag = cwNewFormat ;                              //0041
                           wkKeyWrdCntr += 1 ;                                           //0041
                           dsFSpecKeywords(wkKeyWrdCntr).dsKeyWrdDtls =                  //0041
                                 fSpecDsV3.option + ' - '                                //0041
                                 + %trim(fSpecDsV3.entry)                                //0041
                                 + %trim(fSpecDsV3.recordNumField) ;                     //0041
                        Endif ;                                                          //0041
                  endsl;

               else;
                  leave;
               endif;

            when wkSrcSpec = 'L';

               if wkLSpecOnNextRecord = *On;
                  wkLSpecOnNextRecord = *Off;
                  clear lSpecDsV3;
                  lSpecDsV3 = wkSrcStmt;

                  if lSpecDsV3.LineNumberc <> *blanks;
                     uiOtherentry = uiOtherentry + 1;
                     urOtherentry(uiOtherentry) =
                                 'Number of lines per page to print'
                                 + colon + %trim(lSpecDsV3.LineNumberc);
                     wkKeyWrdCntr += 1 ;                                                 //0035
                     dsFSpecKeywords(wkKeyWrdCntr).dsKeyWrdDtls =                        //0035
                                          urOtherentry(uiOtherentry) ;                   //0035
                  endif;

                  if lSpecDsV3.OverflowLineNumberc <> *blanks;
                     uiOtherentry = uiOtherentry + 1;
                     urOtherentry(uiOtherentry) =
                                 'Line at which page break occurs'
                                 + colon + %trim(lSpecDsV3.OverflowLineNumberc);
                     wkKeyWrdCntr += 1 ;                                                 //0035
                     dsFSpecKeywords(wkKeyWrdCntr).dsKeyWrdDtls =                        //0035
                                          urOtherentry(uiOtherentry) ;                   //0035
                  endif;

               endif;

               leave;
            other;
               leave;
            endsl;

            clear wkSrcSpec;
            clear wkSrcStmt;
            exec sql fetch SrcStmt into :wkSrcSpec , :wkSrcStmt;
            if sqlCode < successCode;
               uDpsds.wkQuery_Name = 'Fetch_2_srcStmt';
               IaSqlDiagnostic(uDpsds);
            endif;
         enddo;

         exec sql close SrcStmt;
      endif;

   endsr;

//------------------------------------------------------------------------------------- //
//WriteFSpecPseudocode - Subroutine to write F Spec Pseudocode                          //
//------------------------------------------------------------------------------------- //
   Begsr WriteRpg3FSpecPseudocode;
      //Call procedure to print F spec data for new config                               //0035
      If wkFileConfigFlag = cwNewFormat ;                                                //0035
         wkCallMode = cwWriteData ;                                                      //0035
            IaGetLogicalFileDetails(wkCallMode : dsFSpecLFNewFormat :                    //0035
                                    wkKeyWrdPointer : wkKeyWrdCntr) ;                    //0035
      Else ;                                                                             //0035
         OutParmWriteSrcDocDS.dsPseudocode = wkPseudocode;                               //0035
         ioParmPointer  = %addr(OutParmWriteSrcDocDS);                                   //0035
         writePseudoCode(ioParmPointer);                                                 //0035
      Endif ;                                                                            //0035
   Endsr;

//------------------------------------------------------------------------------------- //
//Initialise - Initialise the work variables                                            //
//------------------------------------------------------------------------------------- //
   Begsr Initialise;
     clear OutParmWriteSrcDocDS;
     wkSrcDta                 = %Xlate(cwLo:cwUp:inFSpecParmDS.inSrcDta);
     wkSrcSpec                = *Blanks;
     wkSrcType                =  'RPG';
     OutParmWriteSrcDocDS     =  inFSpecParmDS;
     wkFileKey                = *Blanks;
     wkFName                  = *Blanks;
     wkFileName               = *Blanks;
     wkFMode                  = *Blanks;
     wkFRcdFormat             = *Blanks;
     wkFDevice                = *Blanks;
     wkOtherSpecification     = *Blanks;
     wkSrcStmt                = *Blanks;
     wkFileOSpecCount         = *Zeros;
     wkFirstRecord            = *off;
     wkLSpecOnNextRecord      = *off;
     clear urOtherentry;
     clear uiOtherentry;
     wkFileDtlCntr = *Zeros ;                                                            //0035
     wkKeyWrdCntr  = *Zeros ;                                                            //0035
     //Clear file and Keywords data structure for every run                              //0035
     Clear dsFSpecKeywords ;                                                             //0035
     Clear dsFSpecLFNewFormat ;                                                          //0035
     //Store address for keyword DS                                                      //0035
     wkKeyWrdPointer = %Addr(dsFSpecKeywords) ;                                          //0035

   Endsr;

/copy 'QCPYSRC/iaprcerlog.rpgleinc'
End-Proc;
//------------------------------------------------------------------------------------- //
//Procedure to parse the RPG3 E - Spec source                                           //
//------------------------------------------------------------------------------------- //

Dcl-Proc rpg3ESpecParser Export;

   Dcl-Pi rpg3ESpecParser;
      inESpecParmPointer Pointer;
   End-Pi;

   // Declaration of datastructure
   // E Spec Parser Parameter datastructure
   Dcl-Ds inESpecParmDS  Qualified Based(inESpecParmPointer);
      inReqId        Char(18);
      inSrcLib       Char(10);
      inSrcPf        Char(10);
      inSrcMbr       Char(10);
      insrcType      Char(10);
      inSrcRrn       Packed(6:0);
      inSrcSeq       Packed(6:2);
      inSrcLtyp      Char(5);
      inSrcSpec      Char(1);
      inSrcLnct      Char(1);
      inSrcDta       VarChar(cwSrcLength);
      IOIndentParmPointer Pointer;                                                       //0038
      inDclType      Char(10);
      inSubType      Char(10);
      inbCmtReqd     Char(1);
      inSkipNxtStm   ind;                                                                //0005
      inFileNames    char(10) dim(99);                                                   //0005
      inFileCount    zoned(2:0);                                                         //0005
      inDocSeq       packed(6:0);                                                        //0005
      inVarAry       Char(6) dim(9999);                                                  //0005
      inVarCount     zoned(4:0);                                                         //0005
      inIfCount      zoned(4:0);                                                         //0005
      inSkipParm     ind;                                                                //0007
   End-Ds;

   //Declaration of work variables
   Dcl-S  wkPseudoCode                Char(cwSrcLength) Inz;
   Dcl-S  wkSrcDta                    VarChar(cwSrcLength) Inz;
   Dcl-S  IOParmPointer               Pointer Inz(*Null);

   Dcl-S  wkArrayName                 Char(10)      Inz;
   Dcl-S  wkDataType                  Char(5)       Inz;
   Dcl-S  wkAltDataType               Char(1)       Inz;
   Dcl-S  wkArrayLength               Char(7)       Inz;
   Dcl-S  wkArrayDim                  Char(4)       Inz;
   Dcl-S  wkKeyword                   Char(80)      Inz;
   Dcl-S  urOtherentry                char(80) dim(100);
   Dcl-S  uiOtherentry                uns(5)        Inz;
   Dcl-S  wkSrcMbr                    Char(10)      Inz;
   Dcl-S  wkSrcMtyp                   Char(10)      Inz;
   Dcl-S  wkSrcLtyp                   Char(5)       Inz;
   Dcl-S  wkSrcSpec                   Char(1)       Inz;
   Dcl-S  wkOtherEntry                Char(80)      Inz;
   Dcl-S  wkFirstRecord               ind           Inz;

   Dcl-C  colon              Const(':');
   Dcl-C  space              Const(' ');
   Dcl-C  slash              Const('/');
   Dcl-C  cwDelimiter        Const('| ');
   Dcl-C  cwAscending        Const('Ascending');
   Dcl-C  cwDescending       Const('Descending');
   //------------------------------------------------------------------------------------- //
   //CopyBook declaration
   //------------------------------------------------------------------------------------- //
/copy 'QCPYSRC/iaprderlog.rpgleinc'

   // Initialise the variables
   exsr Initialise;

   // process RPG3 E Spec
   exsr processRpg3ESpec;

   Return;

   //--------------------------------------------------------------------
   //process RPG3 E Spec
   //--------------------------------------------------------------------
   begSr processRpg3ESpec;

      eSpecDsV3 = wkSrcDta;

      if eSpecDsV3.TableName <> *blanks;
         wkArrayName = %trim(eSpecDsV3.TableName);
      endif;

      select;
         when eSpecDsV3.DecimalPositionc = *blanks and
              eSpecDsV3.PBLR1 = *blanks;
            wkDataType = 'A';

         when eSpecDsV3.DecimalPositionc <> *blanks and
              eSpecDsV3.PBLR1 = *blanks;
            wkDataType = 'S';

         when eSpecDsV3.DecimalPositionc <> *blanks and
              (eSpecDsV3.PBLR1 = 'P' or
               eSpecDsV3.PBLR1 = 'L' or
               eSpecDsV3.PBLR1 = 'R');
            wkDataType = 'P';

         when eSpecDsV3.PBLR1 = 'B';
            wkDataType = 'B';

         other;
      endsl;

      if eSpecDsV3.LengthOfEntry1c <> *blanks;
         wkArrayLength = %trim(eSpecDsV3.LengthOfEntry1c);

         if wkDataType = 'S' or wkDataType = 'P';
            wkArrayLength = %trim(wkArrayLength) + colon +
                             eSpecDsV3.DecimalPositionc;
         endif;

      endif;

      if eSpecDsV3.EntryPerTablec <> *blanks;
         wkArrayDim = %trim(eSpecDsV3.EntryPerTablec);
      endif;

      exsr getOtherDetails;

      exsr buildPseudoCode;

   endsr;

//------------------------------------------------------------------------------------- //
//getOtherDetails - Get Other Details                                                   //
//------------------------------------------------------------------------------------- //
   Begsr getOtherDetails;

      if eSpecDsV3.FromFilename <> *blanks;
         uiOtherentry = uiOtherentry + 1;
         urOtherentry(uiOtherentry) = 'Array records loaded from file' +  colon +
                                      %trim(eSpecDsV3.FromFilename);
      endif;

      if eSpecDsV3.EntryPerRecordc <> *blanks;
         uiOtherentry = uiOtherentry + 1;
         urOtherentry(uiOtherentry) = 'Number of entries in one record' +  colon +
                                      %trim(eSpecDsV3.EntryPerRecordc);
      endif;

      select;
         when eSpecDsV3.Sequence = 'A';
            uiOtherentry = uiOtherentry + 1;
            urOtherentry(uiOtherentry) = 'Sequence' + colon + cwAscending;

         when eSpecDsV3.Sequence = 'D';
            uiOtherentry = uiOtherentry + 1;
            urOtherentry(uiOtherentry) = 'Sequence' + colon + cwDescending;

         other;
      endsl;

      if eSpecDsV3.AlternateName <> *blanks;
         uiOtherentry = uiOtherentry + 1;
         urOtherentry(uiOtherentry) = 'Corrosponding Array Name' + colon +
                                      %trim(eSpecDsV3.AlternateName);

         select;
            when eSpecDsV3.AltDecimalPositionc = *blanks and
                 eSpecDsV3.PBLR2 = *blanks;
               wkAltDataType = 'A';

            when eSpecDsV3.AltDecimalPositionc <> *blanks and
                 eSpecDsV3.PBLR2 = *blanks;
               wkAltDataType = 'S';

            when eSpecDsV3.AltDecimalPositionc <> *blanks and
                 (eSpecDsV3.PBLR2 = 'P' or
                  eSpecDsV3.PBLR2 = 'L' or
                  eSpecDsV3.PBLR2 = 'R');
               wkAltDataType = 'P';

            when eSpecDsV3.PBLR2 = 'B';
               wkAltDataType = 'B';

            other;
         endsl;

         If wkAltDataType <> *blanks;
            uiOtherentry = uiOtherentry + 1;
            urOtherentry(uiOtherentry) = 'Corrosponding Array Data Type' + colon +
                                         wkAltDataType;
         EndIf;

         if eSpecDsV3.LengthOfEntryc <> *blanks;
            If wkAltDataType = 'S' or wkAltDataType = 'P';
               uiOtherentry = uiOtherentry + 1;
               urOtherentry(uiOtherentry) = 'Corrosponding Array Length' + colon +
                                            %trim(eSpecDsV3.LengthOfEntryc) +
                                            colon + eSpecDsV3.AltDecimalPositionc;
            else;
               uiOtherentry = uiOtherentry + 1;
               urOtherentry(uiOtherentry) = 'Corrosponding Array Length' + colon +
                                            %trim(eSpecDsV3.LengthOfEntryc);
            endif;
         endif;

         select;
            when eSpecDsV3.AltSequence = 'A';
               uiOtherentry = uiOtherentry + 1;
               urOtherentry(uiOtherentry) = 'Corrosponding Array Sequence' + colon +
                                            cwAscending;

            when eSpecDsV3.AltSequence = 'D';
               uiOtherentry = uiOtherentry + 1;
               urOtherentry(uiOtherentry) = 'Corrosponding Array Sequence' + colon +
                                            cwDescending;
            other;
         endsl;

      endif;

   endsr;

//------------------------------------------------------------------------------------- //
//buildPseudoCode - Build PseudoCode                                                    //
//------------------------------------------------------------------------------------- //
   Begsr buildPseudoCode;

      wkFirstRecord = *off;
      uiOtherentry = 1;

      //Preparing the Pseudocode using Concatenation the Data
      wkPseudoCode =  wkArrayName + cwDelimiter + wkDataType + cwDelimiter +
                      wkArrayLength + cwDelimiter + wkArrayDim  +
                      cwDelimiter;

      dow uiOtherentry <= %elem(urOtherentry);

         wkOtherEntry = %trim(urOtherentry(uiOtherentry));

         if not wkFirstRecord;

            wkPseudoCode = %trimr(wkPseudoCode) + space + %trim(wkOtherEntry);
            wkFirstRecord = *on;
            exsr WriteRpg3ESpecPseudocode;

         else;

            if wkOtherEntry <> *blanks;
               clear wkArrayName;
               clear wkDataType;
               clear wkArrayLength;
               clear wkArrayDim;
               wkPseudoCode =  wkArrayName + cwDelimiter + wkDataType +
                               cwDelimiter + wkArrayLength + cwDelimiter +
                               wkArrayDim  + cwDelimiter;
               wkPseudoCode = %trimr(wkPseudoCode) + space + %trim(wkOtherEntry);
               exsr WriteRpg3ESpecPseudocode;
            endif;

         endif;

         if wkOtherEntry = *blanks;
            leave;
         endif;

         uiOtherentry = uiOtherentry + 1;
      enddo;


   endsr;

//------------------------------------------------------------------------------------- //
//WriteESpecPseudocode - Subroutine to write E Spec Pseudocode                          //
//------------------------------------------------------------------------------------- //
   Begsr WriteRpg3ESpecPseudocode;
      OutParmWriteSrcDocDS.dsPseudocode = wkPseudocode;
      ioParmPointer  = %addr(OutParmWriteSrcDocDS);
      writePseudoCode(ioParmPointer);
   Endsr;

//------------------------------------------------------------------------------------- //
//Initialise - Initialise the work variables                                            //
//------------------------------------------------------------------------------------- //
   Begsr Initialise;
     clear OutParmWriteSrcDocDS;
     clear eSpecDsV3;
     clear wkPseudoCode;
     clear wkArrayName;
     clear wkDataType;
     clear wkArrayLength;
     clear wkArrayDim;
     clear wkKeyword;
     clear urOtherentry;
     clear uiOtherentry;
     clear wkDataType;
     clear wkAltDataType;
     clear wkOtherEntry;
     clear wkFirstRecord;

     wkSrcMbr   = %Xlate(cwLo:cwUp:inESpecParmDS.inSrcMbr);
     wkSrcMtyp  = %Xlate(cwLo:cwUp:inESpecParmDS.insrcType);
     wkSrcLtyp  = %Xlate(cwLo:cwUp:inESpecParmDS.inSrcLtyp);
     wkSrcDta   = %Xlate(cwLo:cwUp:inESpecParmDS.inSrcDta);
     wkSrcSpec  = %Xlate(cwLo:cwUp:inESpecParmDS.inSrcSpec);

     OutParmWriteSrcDocDS = inESpecParmDS;
   Endsr;

/copy 'QCPYSRC/iaprcerlog.rpgleinc'
End-Proc;

//------------------------------------------------------------------------------------- //
//Procedure to Load RPG3 spec Mapping DS                                                //
//------------------------------------------------------------------------------------- //

Dcl-Proc GetRPG3SpecSrcMapping Export ;

    Dcl-Pi GetRPG3SpecSrcMapping  ;
       inSrcLinType   Char(5);
       inSourceSpec   Char(1) ;
    End-Pi ;
    //Data Structure (Without key) to retrieve data from IAPSEUDOMP file                //0036
    Dcl-Ds iAPSeudoMPNoKeyDS Qualified Dim(9999);                                        //0036
       iASrcLtyp          Char(5)    ;                                                   //0036
       iASrcSpec          Char(1)    ;                                                   //0036
       iAKeyFld1          Char(10)   ;                                                   //0036
       iAKeyFld2          Char(10)   ;                                                   //0036
       iAKeyFld3          Char(10)   ;                                                   //0036
       iAKeyFld4          Char(10)   ;                                                   //0036
       iASeqNo            Zoned(2:0) ;                                                   //0036
       iAIndntTy          Char(10)   ;                                                   //0036
       iASubSChr          Char(10)   ;                                                   //0036
       iAActType          Char(10)   ;                                                   //0036
       iACmtDesc          Char(100)  ;                                                   //0036
       iASrhFld1          Char(10)   ;                                                   //0036
       iASrhFld2          Char(10)   ;                                                   //0036
       iASrhFld3          Char(10)   ;                                                   //0036
       iASrhFld4          Char(10)   ;                                                   //0036
       iASrcMap        Varchar(200)  ;                                                   //0036
    End-Ds ;                                                                             //0036

    Dcl-S wkArrElem  Uns(5)  Inz;
    Dcl-S RowNum Packed(4:0) ;

   //Copybook declaration
/copy 'QCPYSRC/iaprderlog.rpgleinc'

   Select;                                                                               //0020
                                                                                         //0020
   When inSourceSpec = 'I';                                                              //0020
      // a- Load the header for record format & field renaming                           //0020
      Exec Sql                                                                           //0020
         Declare GetHeaderMappingRcdFmt Cursor for                                       //0020
            Select iASrcMap from IAPSEUDOMP                                              //0020
            Where iASrcMTyp = 'RPG'                                                      //0020
            and   iAKeyFld1 = 'HEADER'                                                   //0020
            and   iAKeyFld2 = 'RECORDFMT' order by iASeqNo;                              //0020

      Exec Sql Open GetHeaderMappingRcdFmt;                                              //0020
      If SqlCode = Csr_Opn_Cod;                                                          //0020
         Exec Sql Close GetHeaderMappingRcdFmt;                                          //0020
         Exec Sql Open GetHeaderMappingRcdFmt;                                           //0020
      EndIf;                                                                             //0020
                                                                                         //0020
      If SqlCode < SuccessCode;                                                          //0020
         uDpsds.wkQuery_Name = 'Open_GetHeaderMappingRcdFmt';                            //0020
         IaSqlDiagnostic(uDpsds);                                                        //0020
      EndIf;                                                                             //0020
      wkArrElem = %Elem(DSIspecRcdFmtHdr);                                               //0020
      If Sqlcode = successCode;                                                          //0020
         Exec Sql                                                                        //0020
            Fetch GetHeaderMappingRcdFmt For :wKArrElem Rows                             //0020
            Into :DSIspecRcdFmtHdr;                                                      //0020
      EndIf;                                                                             //0020
      Exec Sql Close GetHeaderMappingRcdFmt ;                                            //0020
                                                                                         //0020
       // b- Load the header for data structure and its fields                           //0020
      Exec Sql                                                                           //0020
         Declare GetHeaderMappingDS Cursor for                                           //0020
            Select iASrcMap from IAPSEUDOMP                                              //0020
            Where iASrcMTyp = 'RPG'                                                      //0020
            and   iAKeyFld1 = 'HEADER'                                                   //0020
            and   iAKeyFld2 = 'DATASTRUCT' order by iASeqNo;                             //0020

      Exec Sql Open GetHeaderMappingDS;                                                  //0020
      If SqlCode = Csr_Opn_Cod;                                                          //0020
         Exec Sql Close GetHeaderMappingDS;                                              //0020
         Exec Sql Open GetHeaderMappingDS;                                               //0020
      EndIf;                                                                             //0020
                                                                                         //0020
      If SqlCode < SuccessCode;                                                          //0020
         uDpsds.wkQuery_Name = 'Open_GetHeaderMappingDS';                                //0020
         IaSqlDiagnostic(uDpsds);                                                        //0020
      EndIf;                                                                             //0020
      wkArrElem = %Elem(DSIspecDSHdr);                                                   //0020
      If Sqlcode = successCode;                                                          //0020
         Exec Sql                                                                        //0020
            Fetch GetHeaderMappingDS For :wKArrElem Rows                                 //0020
            Into :DSIspecDSHdr;                                                          //0020
      EndIf;                                                                             //0020
      Exec Sql Close GetHeaderMappingDS;                                                 //0020
                                                                                         //0020
       // c- Load the header for constants and their values                              //0020
      Exec Sql                                                                           //0020
         Declare GetHeaderMappingConst Cursor for                                        //0020
            Select iASrcMap from IAPSEUDOMP                                              //0020
            Where iASrcMTyp = 'RPG'                                                      //0020
            and   iAKeyFld1 = 'HEADER'                                                   //0020
            and   iAKeyFld2 = 'CONSTANT' order by iASeqNo;                               //0020

      Exec Sql Open GetHeaderMappingConst;                                               //0020
      If SqlCode = Csr_Opn_Cod;                                                          //0020
         Exec Sql Close GetHeaderMappingConst;                                           //0020
         Exec Sql Open GetHeaderMappingConst;                                            //0020
      EndIf;                                                                             //0020
                                                                                         //0020
      If SqlCode < SuccessCode;                                                          //0020
         uDpsds.wkQuery_Name = 'Open_GetHeaderMappingConst';                             //0020
         IaSqlDiagnostic(uDpsds);                                                        //0020
      EndIf;                                                                             //0020
      wkArrElem = %Elem(DSIspecConstantHdr);                                             //0020
      If Sqlcode = successCode;                                                          //0020
         Exec Sql                                                                        //0020
            Fetch GetHeaderMappingConst For :wKArrElem Rows                              //0020
            Into :DSIspecConstantHdr;                                                    //0020
      EndIf;                                                                             //0020
      Exec Sql Close GetHeaderMappingConst;                                              //0020
   When inSourceSpec = 'A';                                                              //0036
      //For all specs, load mapping data from IAPSEUDOMP to iAPSeudopMPDs               //0036
      Clear iAPSeudoMpDs ;                                                               //0036
      Clear iAPSeudoMPNoKeyDS;                                                           //0036
      Clear wkiAPseudoMpCount;                                                           //0036
                                                                                         //0036
      Exec Sql                                                                           //0036
         Declare MappingDataCursorASpec Cursor for                                       //0036
            Select iASrcLtyp, iASrcSpec, iAKeyFld1, iAKeyFld2, iAKeyFld3,                //0036
                   iAKeyfld4, iASeqNo,   iAIndntTy, iASubSChr, iAActType,                //0036
                   iACmtDesc, iASrhFld1,iASrhFld2, iASrhFld3, iASrhFld4, iASrcMap        //0036
              From iAPseudoMp                                                            //0036
             Where (iASrcMtyp = 'RPG' or iASrcMtyp = 'SQLRPG') and                       //0036
                   iASrcLtyp <> ' ' and iAKeyFld1 <> 'HEADER'                            //0036
             Order by iASrcLtyp,iAKeyFld1,iAKeyFld2,iAKeyFld3,iASeqNo                    //0036
             For Fetch Only;                                                             //0036

      wkArrElem = %Elem(iAPSeudoMPNoKeyDS);                                              //0036

      Exec Sql Open MappingDataCursorASpec;                                              //0036

      If SqlCode = Csr_Opn_Cod;                                                          //0036
         Exec Sql Close MappingDataCursorASpec;                                          //0036
         Exec Sql Open MappingDataCursorASpec;                                           //0036
      EndIf;                                                                             //0036

      If SqlCode < SuccessCode;                                                          //0036
         uDpsds.wkQuery_Name = 'Open_MappingDataCursorASpec';                            //0036
         IaSqlDiagnostic(uDpsds);                                                        //0036
      EndIf;                                                                             //0036

      If Sqlcode = successCode;                                                          //0036
         Exec Sql                                                                        //0036
            Fetch MappingDataCursorASpec For :wKArrElem  Rows                            //0036
            Into :iAPSeudoMPNoKeyDS;                                                     //0036

            For Rownum=1 To SQLER3;                                                      //0036
                Eval-Corr iAPSeudoMpDs(RowNum)= iAPSeudoMPNoKeyDS(RowNum);               //0036
            EndFor;                                                                      //0036
        wkiAPseudoMpCount = SQLER3;                                                      //0036
      EndIf;                                                                             //0036

      Exec Sql Close MappingDataCursorASpec;                                             //0036
                                                                                         //0020
   Other;                                                                                //0020
      Exec Sql
         Declare MappingDataCursor Cursor For
            Select KEYWORD_OPCODE, ACTION_TYPE, SRC_MAPPING
            From IAPSEUDOKP
            Where  SrcLin_Type = :inSrcLinType
            And  Source_Spec = :inSourceSpec
            For Fetch Only;

      Exec Sql Open MappingDataCursor ;
      If SqlCode = Csr_Opn_Cod;
         Exec Sql Close MappingDataCursor;
         Exec Sql Open MappingDataCursor;
      EndIf;

      If SqlCode < SuccessCode;
         uDpsds.wkQuery_Name = 'Open_MappingDataCursor';
         IaSqlDiagnostic(uDpsds);
      EndIf;

      wkArrElem = %Elem(FSpecMappingDs);

      If Sqlcode = successCode;
          Select ;
             When inSourceSpec ='F'  ;
                Exec Sql
                   Fetch MappingDataCursor For :wKArrElem Rows
                   Into :FSpecMappingDs;
             //Get C spec info from Keyword mapping file and Copy to Array              //0012
             When inSourceSpec ='C'  ;                                                   //0012
                Exec Sql                                                                 //0012
                   Fetch MappingDataCursor For :wKArrElem Rows                           //0012
                   Into :CSpecMappingDs;                                                 //0012
          Endsl;
      EndIf;
    Exec Sql Close MappingDataCursor ;

    //Get F spec note from source mapping file
    Exec Sql
       Declare NoteStmt Cursor For
          Select  Src_Mapping
             From IaPseudoMP
             Where SrcMbr_Type = 'RPG' and
                   Source_Spec = :inSourceSpec and
                   Keyfield_1 = 'NOTE'
             Order By Seq_No
             For Fetch Only;

    Exec Sql Open NoteStmt;
    If SqlCode = CSR_OPN_COD;
       Exec Sql Close NoteStmt;
       Exec Sql Open  NoteStmt;
    EndIf;

    If SqlCode < successCode;
       uDpsds.wkQuery_Name = 'Open_NoteStmt';
       IaSqlDiagnostic(uDpsds);
    EndIf;

    wkArrElem = %Elem(FSpecNoteDs);

    if Sqlcode = successCode;
       Exec Sql
          Fetch NoteStmt For :wKArrElem Rows
          Into :FSpecNoteDs;
    endif;

    Exec Sql Close NoteStmt;

    //Get the comment to be written when no executable code is found in a loop           //0013
    //condition or subroutine                                                            //0013
    Exec Sql Select TRIM(Src_Mapping) into :wkDoNothingComment from IaPseudoKp           //0013
          Where Srcmbr_Type    = 'RPG' and Keyword_Opcode = 'DONOTHING';                 //0013

   //Get Config flag from IABCKCNFG file                                                 //0035
   Exec SQL                                                                              //0035
      Select KEY_VALUE1                                                                  //0035
      Into :wkFileConfigFlag                                                             //0035
      From IABCKCNFG                                                                     //0035
      Where KEY_NAME1 = 'FSPECFORMAT' ;                                                  //0035
                                                                                         //0035
   EndSl;                                                                                //0020
/copy 'QCPYSRC/iaprcerlog.rpgleinc'
End-Proc GetRPG3SpecSrcMapping ;

//------------------------------------------------------------------------------------- //
//Procedure to Fetch the RPG3 Data Type Description                                     //
//------------------------------------------------------------------------------------- //
Dcl-Proc LoadRPG3DataTypeMap Export ;

   //Copybook declaration
/copy 'QCPYSRC/iaprderlog.rpgleinc'

   Dcl-S  wkArrElem          Packed(2:0)     Inz;
   Dcl-C  cwFxDataType       Const('FIXED_DATATYPE');

   wkArrElem = %Elem(RPG3DataTypeDs);

   //Fetching the Data Type Description
   Exec Sql
      Declare iADataTypeCsr Cursor for
         Select Key_Name2, Key_Value1
            From iABckCnfg
          Where Key_Name1 = :cwFxDataType;

   Exec Sql
      Open iADataTypeCsr;

   If SqlCode = Csr_Opn_Cod;
      Exec Sql Close iADataTypeCsr;
      Exec Sql Open  iADataTypeCsr;
   EndIf;

   If SqlCode < SuccessCode;
      uDpsds.wkQuery_Name = 'Open_iADataTypeCsr';
      IaSqlDiagnostic(uDpsds);
   EndIf;

   Exec Sql
      Fetch iADataTypeCsr for :wkArrElem rows Into :RPG3DataTypeDs;

   Exec Sql
      Close iADataTypeCsr;

/copy 'QCPYSRC/iaprcerlog.rpgleinc'

End-Proc LoadRPG3DataTypeMap;

//-------------------------------------------------------------------------------------
//Procedure to parse the RPG3 C - Spec source
//-------------------------------------------------------------------------------------

Dcl-Proc rpg3CSpecParser Export;

   Dcl-Pi rpg3CSpecParser;
      inCSpecParmPointer Pointer;
      inInclDeclSpecs    Char(1);                                                        //0042
   End-Pi;

   // Declaration of datastructure
   // C Spec Parser Parameter datastructure
   Dcl-Ds inCSpecParmDS  Qualified Based(inCSpecParmPointer);
      inReqId        Char(18);
      inSrcLib       Char(10);
      inSrcPf        Char(10);
      inSrcMbr       Char(10);
      insrcType      Char(10);
      inSrcRrn       Packed(6:0);
      inSrcSeq       Packed(6:2);
      inSrcLtyp      Char(5);
      inSrcSpec      Char(1);
      inSrcLnct      Char(1);
      inSrcDta       VarChar(cwSrcLength);
      IOIndentParmPointer Pointer;                                                       //0038
      inDclType      Char(10);
      inSubType      Char(10);
      inbCmtReqd     Char(1);
      inSkipNxtStm   ind;
      inFileNames    char(10) dim(99);
      inFileCount    zoned(2:0);
      inDocSeq       packed(6:0);
      inVarAry       Char(6) dim(9999);                                                  //0005
      inVarCount     zoned(4:0);                                                         //0005
      inIfCount      zoned(4:0);                                                         //0005
      inSkipParm     ind;                                                                //0007
   End-Ds;

   // Copy of C spec DS for checking the looping
   dcl-Ds ChkCSpecDsV3 likeds(cSpecDsV3);
                                                                                         //0019
   Dcl-Ds DsPseudoCodeForBlankCheck;                                                     //0019
      wkPseudoCodeForBlankCheckArr  Char(1) Dim(110);                                    //0019
   End-Ds;                                                                               //0019
   Dcl-Ds wkRPGIndentParmDS  LikeDs(RPGIndentParmDSTmp);                                 //0038
   Dcl-Ds wkOutParmWriteSrcDocDS LikeDs(OutParmWriteSrcDocDS)                            //0038
                                 Based(wkRPGIndentParmDS.dsSrcDtlDSPointer);             //0038

   //Declaration of work variables
   Dcl-S  wkPseudoCode                Char(cwSrcLength) Inz;
   Dcl-S  wkSrcDta                    VarChar(cwSrcLength) Inz;
   Dcl-S  IOParmPointer               Pointer Inz(*Null);

   Dcl-S  wkMapping                   VARCHAR(4046);
   Dcl-S  wkSrcMbr                    Char(10)      Inz;
   Dcl-S  wkSrcMtyp                   Char(10)      Inz;
   Dcl-S  wkSrcLtyp                   Char(5)       Inz;
   Dcl-S  wkSrcSpec                   Char(1)       Inz;
   Dcl-S wkTempIndentType             Char(10)      Inz;                                 //0038
   Dcl-S wkIndentParmPointer          Pointer       Inz;                                 //0038
   Dcl-S wkCLoopSrcDta                Char(132)     Inz;
   Dcl-S wkiAKeyFld2                  Char(10)      Inz;
   Dcl-S wkSkipNxtStm                 ind;
   Dcl-S wkFileNames                  char(10)      dim(99);
   Dcl-S wkFileCount                  zoned(2:0);
   Dcl-S wkSrhIndex                   Packed(3:0)   inz;
   Dcl-S ReqId                        Int(20)       Inz;
   Dcl-C cwDelimiter                  Const('| ');
   Dcl-S wkLength                     char(3);                                           //0004
   Dcl-S wkValue1                     char(6);                                           //0001
   Dcl-S wkVAry                       char(10);                                          //0001
   Dcl-S wkVIdx                       char(10);                                          //0001
   Dcl-S wkVAry1                      char(10);                                          //0001
   Dcl-S wkVIdx1                      char(10);                                          //0001
   Dcl-S wkNoDecflag                  ind;                                               //0002
   Dcl-S wkPseudocodeTmp              Char(4046);                                        //0002
   Dcl-S wkPseudocode1                Char(4046);                                        //0038
   Dcl-S wkFactor1                    Char(20);                                          //0003
   Dcl-S wkFactor2                    Char(20);                                          //0003
   Dcl-S wkResult                     Char(20);                                          //0003
   Dcl-S wkTempMap                    like(wkMapping);                                   //0004
   Dcl-S wkString                     VarChar(cwSrcLength) Inz;                          //0007
   Dcl-S wk_PrvRrn                    Packed(6:0);                                       //0007
   Dcl-S WkWithPos                    Packed(6:0);                                       //0008
   Dcl-S Wk_Datatype                  Char(4) ;                                          //0014
   Dcl-S wkParmMapping                VarChar(cwSrcLength) Inz;                          //0016
   Dcl-S wkParmRtnArr                 Char(120) Dim(100) Inz;                            //0016
   Dcl-S wkParmArr                    Char(120) Dim(100) Inz;                            //0032
   Dcl-S wkSrcRrnLast                 Packed(6:0)   Inz;                                 //0032
   Dcl-S wkPIdx1                      Packed(3:0)   Inz;                                 //0016
   Dcl-S wkPIdx2                      Packed(3:0)   Inz;                                 //0016
   Dcl-S wkPipelength                 Zoned(4:0)    Inz;                                 //0038
   Dcl-S wkFirstNonBlankCharPos       Zoned(4:0)    Inz;                                 //0038
   Dcl-S wkN01Mapping                 Char(20)             Inz;                          //0034
   Dcl-S wkN02Mapping                 Char(20)             Inz;                          //0034
   Dcl-S wkN03Mapping                 Char(20)             Inz;                          //0034
   Dcl-S wkN01N02N03                  Char(70)             Inz;                          //0034
   Dcl-S wkCScanPos                   Packed(4:0)          Inz;                          //0034
   Dcl-C cwComma                      Const(',');                                        //0024
   Dcl-C cwTo                         Const(' to ');                                     //0016
   Dcl-C cwAssign                     Const('Assign ');                                  //0016
   Dcl-C cwRetrns                     Const('return value ');                            //0016
   Dcl-C cwInd                        Const('*IN');                                      //0024
   Dcl-C cwTrue                       Const(' is TRUE');                                 //0034
   Dcl-C cwFalse                      Const(' is FALSE');                                //0034
   Dcl-C cwAnd                        Const(' And ');                                    //0034
   Dcl-C cwOr                         Const(' Or ');                                     //0034
   Dcl-C cwOpenParen                  Const('(');                                        //0034
   Dcl-C cwCloseParen                 Const(')');                                        //0034
   Dcl-C cw_Dspec                     Const('D');                                        //0039
   Dcl-S wkHLEValue                   Char(100) Inz;                                     //0024
   Dcl-S wkMaxDataToWrite             Char(109) Inz ;                                    //0019
   Dcl-S wkIdx                        Zoned(4:0) Inz ;                                   //0019
   Dcl-S wkSplitIdx                   Zoned(4:0) Inz ;                                   //0038
                                                                                         //0019
   Dcl-C cwMaxNoOfCharToPrint         109 ;                                              //0019
   Dcl-S wkPlistKey2                  Char(10) Inz;                                      //0032
   Dcl-S InclusiveSpecArr             char(1) dim(10);                                   //0039
   Dcl-S wkSetOpKey2                  Char(10) Inz;                                      //0040
   //-----------------------------------------------------------------------------------
   //CopyBook declaration
   //-----------------------------------------------------------------------------------
/copy 'QCPYSRC/iaprderlog.rpgleinc'

   // Initialise the variables
   exsr Initialise;

   // process RPG3 C Spec
   exsr processRpg3CSpec;

   Return;

   //--------------------------------------------------------------------
   //process RPG3 C Spec
   //--------------------------------------------------------------------
   begSr processRpg3CSpec;

      clear wkMapping;
      wkiAKeyFld2 =' ' ;
      cSpecDsV3 = wkSrcDta;
      wkPseudoCode = ' ';
      wkIndentType = ' ';                                                                //0038

      //Initilizing the length and decimal values when populated with garbage value     //0037
      If cSpecDsV3.lengthc <> *Blanks   And                                              //0037
         %Check(cwDigits : %Trim(cSpecDsV3.lengthc)) =  *Zeros;                          //0037
         cSpecDsV3.length  =  %Uns(cSpecDsV3.lengthc) ;                                  //0037
      Else ;                                                                             //0037
         cSpecDsV3.length  =  *Zeros;                                                    //0037
      Endif ;                                                                            //0037
      //Initialize value for decimal position                                           //0037
      If cSpecDsV3.decPosc <> *Blanks   And                                              //0037
         %Check(cwDigits : %Trim(cSpecDsV3.decPosc)) =  *Zeros;                          //0037
         cSpecDsV3.decPos = %Uns(cSpecDsV3.decPosc) ;                                    //0037
      Else ;                                                                             //0037
         //cSpecDsV3.decPos  =  *Zeros;                                                  //0037
         wkNoDecflag = *on;                                                              //0037
      Endif ;                                                                            //0037

   //Process when length is present with variable and its not dublicate
      //Only proceed if D spec is included in IAPSEUDOKP file                           //0039
      If %Lookup(cw_Dspec : InclusiveSpecArr) > 0;                                       //0039
      if cSpecDsV3.length > 0 and
         %lookup(cSpecDsV3.result:inCSpecParmDS.inVarAry) = 0;
         // process RPG3 C Spec declarations
         exsr processVariableDeclarations;
         inCSpecParmDS.inVarCount = inCSpecParmDS.inVarCount + 1;
         inCSpecParmDS.inVarAry(inCSpecParmDS.inVarCount) = cSpecDsV3.result;
      endif;
      Endif;                                                                             //0039

   //Write the header for the c-spec processing in the temporary file
      if inCSpecParmDS.inDocSeq = 0 ;
        exsr WriteHeader;
      endif;
   //Write Pseudo for Conditional Indicator                                            //0034
      Exsr ConditionalIndicator;                                                        //0034
                                                                                        //0034
      Select;
   //Skip the next statement from processing
      When inCSpecParmDS.inSkipNxtStm = *On;
           inCSpecParmDS.inSkipNxtStm = *Off;
           //Before skip Write *ENTRY PLIST return Values at End of Pgm,if last Line    //0032
           Exsr PgmEntryReturnValues;                                                    //0032
           return;

   //Skip the next PARM Stmt from processing                                            //0007
      When inCSpecParmDS.inSkipParm   = *On and CSpecDsV3.Opcode = 'PARM';               //0007
           //Before skip Write *ENTRY PLIST return Values at End of Pgm,if last Line    //0032
           Exsr PgmEntryReturnValues;                                                    //0032
           Return ;                                                                      //0007
                                                                                         //0007
   //Skip the next statement from processing                                            //0004
      When inCSpecParmDS.inIfCount > 0;                                                  //0004
           inCSpecParmDS.inIfCount = inCSpecParmDS.inIfCount - 1;                        //0004
           //Before skip Write *ENTRY PLIST return Values at End of Pgm,if last Line    //0032
           Exsr PgmEntryReturnValues;                                                    //0032
           return;                                                                       //0004
                                                                                         //0004
   //Process IF Else                                                                    //0004
      When %subst(cSpecDsV3.opcode:1:2) = 'IF';                                          //0004

           //Write the pseudo code                                                      //0004

            wkDclType = cSpecDsV3.opcode;                                                //0036
            Exsr SrGetRPG3Mapping;                                                       //0036

            Exsr MapReplacePseudoCode ;                                                  //0022
            wkTempMap = wkMapping;                                                       //0004
            wkTempIndentType = wkIndentType;                                             //0038
            inCSpecParmDS.inIfCount =  0;
            //Read next source lines and if there is ending of loop in next lines       //0004
            //skip processing of this line if the READ loop was active                  //0004
            exec sql declare CheckIf cursor for                                          //0004
                 select XSrcDta from iAQRpgSrc where                                     //0004
                 XLibNam =:inCSpecParmDS.inSrcLib and                                    //0004
                 XSrcNam =:inCSpecParmDS.inSrcPf and                                     //0004
                 XMbrNam =:inCSpecParmDS.inSrcMbr and                                    //0004
                 XMbrTyp =:inCSpecParmDS.insrcType and                                   //0004
                 XSrcRrn >:inCSpecParmDS.inSrcRrn                                        //0004
                 for fetch only;                                                         //0004
            exec sql open CheckIf;                                                       //0004
            DoW sqlcode = SuccessCode;                                                   //0004
                exec sql fetch from CheckIf into :wkCLoopSrcDta;                         //0004
                If sqlcode = SuccessCode;                                                //0004
                   ChkCSpecDsV3 = %Xlate(cwLo:cwUp:wkCLoopSrcDta);                       //0004
                   Select;                                                               //0004
                   //Skip commented and blank lines while searching for next loop       //0004
                   When   ChkCSpecDsV3.spec= ' ' or                                      //0004
                          %subst(ChkCSpecDsV3.level:1:1)='*' or                          //0004
                          ChkCSpecDsV3.Opcode=*Blanks;                                   //0004
                          Iter;                                                          //0004
                   //Don't consider looping on file if next op code is not a 'IFx' loop //0004
                   When   %subst(ChkCSpecDsV3.Opcode:1:3) <> 'AND' and                   //0004
                          %subst(ChkCSpecDsV3.Opcode:1:2) <> 'OR';                       //0004
                          Leave;                                                         //0004
                   //Process the record is AND and OR is present after IF               //0004
                   Other;                                                                //0004
                           wkDclType = ChkCSpecDsV3.opcode;                              //0036
                           Exsr SrGetRPG3Mapping;                                        //0036
                                                                                         //0004
                           cSpecDsV3 = ChkcSpecDsV3 ;                                    //0022
                           Exsr MapReplacePseudoCode ;                                   //0022
                           wkTempMap = %trim(wkTempMap) + wkMapping;                     //0004
                          //Skip the next IF statement                                  //0004
                          inCSpecParmDS.inIfCount = inCSpecParmDS.inIfCount + 1;         //0004
                   EndSl;                                                                //0004
                EndIf;                                                                   //0004
           EndDo;                                                                        //0004
           exec sql close CheckIf;                                                       //0004

           //Moving back the mapped data to mapping field                               //0004
           wkMapping = %trim(wkTempMap);                                                 //0004
           wkIndentType = wkTempIndentType;                                              //0038
           exsr buildPseudoCode;                                                         //0004

   //Process for All PLIST                                                              //0032
      When %subst(cSpecDsV3.opcode:1:5) = 'PLIST' ;                                      //0032
           wkTempCallMap = *Blanks;                                                      //0032
           inCSpecParmDS.inSkipParm  = *Off;                                             //0032
           wkHoldForParm = *Off;                                                         //0032

           wkPlistKey2 = ' ';                                                            //0032
           If cSpecDsV3.factor1 = '*ENTRY';                                              //0032
              wkPlistKey2 = 'ENTRY';                                                     //0032
           EndIf;                                                                        //0032

              wkDclType       =  cSpecDsV3.opcode;                                       //0036
              WkMpIakeyfield2 =  wkPlistKey2;                                            //0036
              Exsr SrGetRPG3Mapping;                                                     //0036

              //Save the pseudo for PLIST with Plistname to print Assign PARM First     //0032
              If cSpecDsV3.factor1 <> '*ENTRY';                                          //0032
                 wkTempCallMap = %scanrpl('&Var1':%trim(cSpecDsV3.factor1):wkMapping);   //0032
                 wkHoldForParm = *On;                                                    //0032
              EndIf;                                                                     //0032

              //Write the pseudo code for PLIST with *ENTRY                             //0032
              If wkHoldForParm = *Off;                                                   //0032
                 exsr buildPseudoCode;                                                   //0032
              EndIf;                                                                     //0032

      //Process CALL with or without parameter in same line                             //0016
      When %subst(cSpecDsV3.opcode:1:4) = 'CALL';                                        //0016
           //Write the pseudo code for CALL/CALLB/CALLP                                 //0016
           inCSpecParmDS.inSkipParm  = *Off;                                             //0016
           wkHoldForParm = *Off;                                                         //0016
           wkTempCallMap = *Blanks;                                                      //0016
              wkDclType = cSpecDsV3.opcode;                                              //0036
              Exsr SrGetRPG3Mapping;                                                     //0036
                                                                                         //0016
              If CSpecDsV3.result  = *Blanks ;                                           //0016
                   wkWithPos    = %ScanR('with': %Trim(wkMapping ) ) ;                   //0016
                   wkMapping    = %Subst(wkMapping: 1: wkWithPos-1) ;                    //0016
                   wkHoldForParm = *On;                                                  //0016
                   wkTempCallMap =  %scanrpl('&Var2':%Xlate(cwLo:cwUp:cSpecDsV3.factor2) //0016
                                    :wkMapping);                                         //0016
              EndIf;                                                                     //0016
              If wkHoldForParm = *Off;                                                   //0016
                 exsr buildPseudoCode;                                                   //0016
              EndIf;                                                                     //0016

   //Process Z-ADD with ZERO                                                            //0001
      When (%subst(cSpecDsV3.opcode:1:5) = 'Z-ADD' and                                   //0001
           (cSpecDsV3.factor2 = '0' or %scan('*ALL':cSpecDsV3.factor2) > 0 or            //0001
            %subst(cSpecDsV3.factor2:1:5) = '*ZERO')) or                                 //0001
           (%subst(cSpecDsV3.opcode:1:4) = 'MOVE' and                                    //0001
            %subst(cSpecDsV3.factor2:1:4) = '*ALL') ;                                    //0025
                                                                                         //0001
           if cSpecDsV3.factor2 = '0' or %subst(cSpecDsV3.factor2:1:5) = '*ZERO';        //0001
               //Write the pseudo code for Z-ADD with 0/*ZERO                           //0025
               wkDclType        =  cSpecDsV3.opcode;                                     //0036
               WkMpIakeyfield2  =  '0';                                                  //0036
               Exsr SrGetRPG3Mapping;                                                    //0036

               exsr buildPseudoCode;                                                     //0025
           endif;                                                                        //0001
                                                                                         //0001
           if %subst(cSpecDsV3.factor2:1:4) = '*ALL';                                    //0001
              wkValue1 = %subst(cSpecDsV3.factor2:                                       //0001
                         (%scan('*ALL':cSpecDsV3.factor2) + 4));                         //0001
                                                                                         //0001
              //Write the pseudo code for Z-ADD/MOVE with *ALL                          //0001
               wkDclType         =  cSpecDsV3.opcode;                                    //0036
               WkMpIakeyfield2   =  'ALL';                                               //0036
               Exsr SrGetRPG3Mapping;                                                    //0036
            //wkMapping = %scanrpl('&Var2':wkValue1:wkMapping);                          //0001
              wkMapping = %scanrpl('&Var2':%trim(wkValue1):wkMapping);                   //0025
                                                                                         //0001
              exsr buildPseudoCode;                                                      //0001
           endif;                                                                        //0001

      When %Subst(cSpecDsV3.opcode:1:5) = 'SETLL' Or                                     //0040
           %Subst(cSpecDsV3.opcode:1:5) = 'SETGT';                                       //0040
                                                                                         //0040
           wkSetOpKey2 = cSpecDsV3.factor1;                                              //0040
                                                                                         //0040
           If cSpecDsV3.factor1 <> '*LOVAL' And                                          //0040
              cSpecDsV3.factor1 <> '*HIVAL' And                                          //0040
              cSpecDsV3.factor1 <> '*START' And                                          //0040
              cSpecDsV3.factor1 <> '*END';                                               //0040
              wkSetOpKey2 = *Blanks;                                                     //0040
           EndIf;                                                                        //0040
                                                                                         //0040
           //Write the pseudo code for SetLL & SetGT Opcodes                            //0040
           wkDclType        =  cSpecDsV3.opcode;                                         //0040
           WkMpIakeyfield2  =  wkSetOpKey2;                                              //0040
           Exsr SrGetRPG3Mapping;                                                        //0040
                                                                                         //0040
           ExSr BuildPseudoCode;                                                         //0040

      When %subst(cSpecDsV3.opcode:1:4) = 'MOVE';

           if cSpecDsV3.factor2 = '" "'  or  cSpecDsV3.factor2 = '"  "' or                //0004
              cSpecDsV3.factor2 = '"   " ' or cSpecDsV3.factor2 = '"    "' or             //0004
              cSpecDsV3.factor2 = '"     "' or cSpecDsV3.factor2 = '"      "' or          //0004
              cSpecDsV3.factor2 = '"       "' or cSpecDsV3.factor2 = '"        "';        //0004
              cSpecDsV3.factor2 = '*BLANKS';                                              //0004
            endif;                                                                        //0004

           //Write the pseudo code for MOVE with padding/half adjust
               wkDclType        =  cSpecDsV3.opcode;                                     //0036
               WkMpIakeyfield2  =  cSpecDsV3.halfAdj;                                    //0036
               Exsr SrGetRPG3Mapping;                                                    //0036

              exsr buildPseudoCode;

      When %subst(cSpecDsV3.opcode:1:4) = 'SETO';                                         //0018
            //Write the pseudo code - SETON or SETOFF for Each Indicator                 //0018
            clear wkHLEValue;                                                             //0024
               wkDclType = cSpecDsV3.opcode;                                             //0036
               Exsr SrGetRPG3Mapping;                                                    //0036
               If cSpecDsV3.HIind <> *Blanks;                                             //0018
                  wkHLEValue =cwInd + cSpecDsV3.HIind;                                    //0024
               EndIf;                                                                     //0018
               If cSpecDsV3.LOind <> *Blanks;                                             //0018
                  If wkHLEValue <> *Blanks;                                               //0024
                     wkHLEValue = %trim(wkHLEValue) + cwComma + cwInd + cSpecDsV3.LOind;  //0024
                  else;                                                                   //0024
                     wkHLEValue =cwInd + cSpecDsV3.LOind;                                 //0024
                  Endif;                                                                  //0024
               EndIf;                                                                     //0018
               If cSpecDsV3.EQind <> *Blanks;                                             //0018
                  If wkHLEValue <> *Blanks;                                               //0024
                     wkHLEValue = %trim(wkHLEValue) + cwComma + cwInd + cSpecDsV3.EQind;  //0024
                  else;                                                                   //0024
                     wkHLEValue =cwInd + cSpecDsV3.EQind;                                 //0024
                  Endif;                                                                  //0024
               EndIf;                                                                     //0018
               wkMapping = %scanrpl('&HLE':%trim(wkHLEValue):wkMapping);                  //0024
               exsr buildPseudoCode;                                                      //0024

      When (%subst(cSpecDsV3.opcode:1:4) ='READ' or
           %subst(cSpecDsV3.opcode:1:5) ='CHAIN') and
           cSpecDsV3.Factor2<>*Blanks;

            //3 - Check if its a READ statement within loop to be skipped
            If   %subst(cSpecDsV3.opcode:1:4) ='READ' and
                 %lookup(cSpecDsV3.Factor2 : inCSpecParmDS.inFileNames : 1 :
                 inCSpecParmDS.inFileCount)<>0;
                 wkSrhIndex=%lookup(cSpecDsV3.Factor2 :
                            inCSpecParmDS.inFileNames:1:inCSpecParmDS.inFileCount);
                 wkFileNames(wkSrhIndex)=*Blanks;
                 wkFileCount -= 1;
                 Return;
            EndIf;
            //4 - Check if its a READ/CHAIN operation for which looping is used
            //Read next source lines and if there is ending of loop in next lines
            //skip processing of this line if the READ loop was active
            exec sql declare CheckLooping cursor for
                 select XSrcDta from iAQRpgSrc where
                 XLibNam =:inCSpecParmDS.inSrcLib and
                 XSrcNam =:inCSpecParmDS.inSrcPf and
                 XMbrNam =:inCSpecParmDS.inSrcMbr and
                 XMbrTyp =:inCSpecParmDS.insrcType and
                 XSrcRrn >:inCSpecParmDS.inSrcRrn
                 for fetch only;
            exec sql open CheckLooping;
            DoW sqlcode = SuccessCode;
                exec sql fetch from CheckLooping into :wkCLoopSrcDta;
                If sqlcode = SuccessCode;
                   ChkCSpecDsV3 = %Xlate(cwLo:cwUp:wkCLoopSrcDta);
                   Select;
                   //Skip commented and blank lines while searching for next loop
                   When   ChkCSpecDsV3.spec= ' ' or
                          %subst(ChkCSpecDsV3.level:1:1)='*' or
                          ChkCSpecDsV3.Opcode=*Blanks;
                          Iter;
                   //Don't consider looping on file if next op code is not a 'DOx' loop
                   When   %subst(ChkCSpecDsV3.Opcode:1:2) <> 'DO';
                          Leave;
                   Other;
                   //If %EOF built in function OR and indicator which has been used
                   //with READx operation is present as Factor 2 with DOx loop, consider
                   //it as reading all record loop otherwise do not consider
                          If   (%scan('*IN':ChkCSpecDsV3.factor1:1)<>0 and
                               %subst(ChkCSpecDsV3.factor1:
                               %scan('*IN':ChkCSpecDsV3.factor1)+3:2)=
                               cSpecDsV3.EQind);
                               inCSpecParmDS.inSkipNxtStm = *On;
                               inCSpecParmDS.inFileCount += 1;
                               inCSpecParmDS.inFileNames(inCSpecParmDS.inFileCount)=
                               %Trim(CspecDsV3.Factor2);
                               wkiAKeyFld2 = 'LOOP';
                          EndIf;
                   EndSl;
                EndIf;
            EndDo;
            exec sql close CheckLooping;
           //Write the pseudo code with LOOP
             wkDclType        =  cSpecDsV3.opcode;                                       //0036
             WkMpIakeyfield2  =  wkiAKeyFld2;                                            //0036
             Exsr SrGetRPG3Mapping;                                                      //0036

             exsr buildPseudoCode;
      When %subst(cSpecDsV3.opcode:1:4) = 'PARM' and                                     //0007
          cSpecDsV3.result <> *Blanks ;                                                  //0007
          //Process Parm Opcode                                                         //0007
          exec sql declare CheckParm cursor for                                          //0007
             select XSrcDta, XSrcRrn from iAQRpgSrc where                                //0007
             XLibNam =:inCSpecParmDS.inSrcLib and                                        //0007
             XSrcNam =:inCSpecParmDS.inSrcPf and                                         //0007
             XMbrNam =:inCSpecParmDS.inSrcMbr and                                        //0007
             XMbrTyp =:inCSpecParmDS.insrcType and                                       //0007
             XSrcRrn >=:inCSpecParmDS.inSrcRrn                                           //0016
             for fetch only;                                                             //0007
          exec sql open CheckParm ;                                                      //0007
          DoW sqlcode = SuccessCode ;                                                    //0007
              exec sql fetch from CheckParm into :wkCLoopSrcDta, :Wk_PrvRRn;             //0007
              ChkCSpecDsV3 = %Xlate(cwLo:cwUp:wkCLoopSrcDta);                            //0007
              CSpecDsV3    = ChkCSpecDsV3;                                               //0031
              If sqlcode = SuccessCode and ChkCSpecDsV3.opcode ='PARM' ;                 //0007
                 Select ;                                                                //0007
                 //Skip commented and blank lines while searching for next loop         //0007
                 When   CSpecDsV3.spec= ' ' or                                           //0007
                        %subst(CSpecDsV3.level:1:1)='*' or                               //0007
                        CSpecDsV3.Opcode=*Blanks;                                        //0007
                        Iter;                                                            //0007
                                                                                         //0007
                 When   cSpecDsV3.result <> *Blanks and                                  //0007
                        cSpecDsV3.opcode  = 'PARM' ;                                     //0007
                        WkString = %Trim(WkString) + ', ' +%Trim(ChkCSpecDsV3.result) ;  //0007

                        Select ;                                                         //0032
                        //Derive Pseudo for CALL with Parm Passing Input Values         //0032
                        When ChkCSpecDsV3.factor2 <> *Blanks and                         //0032
                             wkHoldForParm = *On;                                        //0032
                             wkMapping = *Blanks;                                        //0032
                             wkMapping = cwAssign + '&Var2' +                            //0032
                                         cwTo     + '&Var3' ;                            //0032
                             exsr buildPseudoCode;                                       //0032
                        //Derive Pseudo for PLIST with *Entry Parm return value         //0032
                        When ChkCSpecDsV3.factor2 <> *Blanks;                            //0032
                             wkPrIdx1  = wkPrIdx1 + 1;                                   //0032
                             wkMapping = cwAssign + cwRetrns + '&Var2' +                 //0032
                                                        cwTo + '&Var3';                  //0032
                             Exsr MapReplacePseudoCode;                                  //0032
                             wkParmEntryRtnArr(wkPrIdx1) = %Trim(wkMapping);             //0032
                        EndSl;                                                           //0032
                                                                                         //0032
                        Select ;                                                         //0032
                        //Derive Pseudo for CALL with Parm Return Values                //0032
                        When ChkCSpecDsV3.factor1 <> *Blanks and                         //0032
                             wkHoldForParm = *On;                                        //0032
                             wkPIdx1   = wkPIdx1  + 1;                                   //0032
                             wkMapping = cwAssign + cwRetrns + '&Var3' +                 //0032
                                                        cwTo + '&Var1';                  //0032
                             Exsr MapReplacePseudoCode;                                  //0032
                             wkParmRtnArr(wkPIdx1) = %Trim(wkMapping);                   //0032
                        //Derive Pseudo for PLIST with *Entry with Parm Input Values    //0032
                        When ChkCSpecDsV3.factor1 <> *Blanks;                            //0032
                             wkPIdx1   = wkPIdx1  + 1;                                   //0032
                             wkMapping = cwAssign + '&Var3' +                            //0032
                                             cwTo + '&Var1';                             //0032
                             Exsr MapReplacePseudoCode;                                  //0032
                             wkParmArr(wkPIdx1)=%Trim(wkMapping);                        //0032
                        EndSl;                                                           //0032
                 Other;                                                                  //0007
                 EndSl ;                                                                 //0007
              Else ;         // If Opcode <> 'PARM'                                     //0007
                 //Set Opcode to get Mapping                                            //0032
                 CSpecDsV3.Opcode = 'PARM';                                              //0032
                 //Write the pseudo code for Parm                                       //0007
                      wkDclType = cSpecDsV3.opcode;                                      //0036
                      Exsr SrGetRPG3Mapping;                                             //0036

                      //Substring to remove ',' from first position                      //0016
                      wkString = %Trim(%subst(wkString:2));                              //0016
                      wkMapping = %scanrpl('&Var3':wkString:wkMapping);                  //0007
                      //Skip the next statement if its PARM                             //0007
                      inCSpecParmDS.inSkipParm   = *On;                                  //0007
                      Leave;                                                             //0007
              Endif;                                                                     //0007
          Enddo;                                                                         //0007
          exec sql close  CheckParm ;                                                    //0007

          //Process and Build Pseudo for CALL and PARM in Proper order                   //0016
          wkParmMapping = wkMapping;                                                     //0016
          wkMapping = *Blanks;                                                           //0032

          //Write Pseudo for CALL or PLIST (Not *Entry) with PARM                       //0032
          If wkHoldForParm = *On;                                                        //0016

             //Write Pseudo for CALL or PLIST                                           //0032
             If wkTempCallMap > *Blanks;                                                 //0016
                wkMapping = wkTempCallMap;                                               //0016
                exsr buildPseudoCode;                                                    //0016
                wkTempCallMap = *Blanks;                                                 //0016
             EndIf;                                                                      //0016

             //Write Pseudo for with all parameter                                      //0032
             If wkParmMapping > *Blanks;                                                 //0016
                wkMapping = wkParmMapping;                                               //0016
                exsr buildPseudoCode;                                                    //0016
             EndIf;                                                                      //0016

             //Write Pseudo for Return value                                            //0032
             If wkPIdx1 > *Zeros;                                                        //0016
                For wkPIdx2 = 1 by 1 to wkPIdx1;                                         //0016
                   wkMapping = *Blanks;                                                  //0016
                   wkMapping = wkParmRtnArr(wkPIdx2);                                    //0016
                   If wkMapping > *Blanks;                                               //0016
                     exsr buildPseudoCode;                                               //0016
                   EndIf;                                                                //0016
                EndFor;                                                                  //0016
             Clear wkParmRtnArr;                                                         //0016
             EndIf;                                                                      //0016
             wkHoldForParm = *Off;                                                       //0016

          Else;                                                                          //0032

             //Write Pseudo for all parameter                                           //0032
             If wkParmMapping > *Blanks;                                                 //0032
                wkMapping = wkParmMapping;                                               //0032
                Exsr buildPseudoCode;                                                    //0032
                Clear wkParmMapping ;                                                    //0032
             EndIf;                                                                      //0032

             //Write Pseudo for Assign value                                            //0032
             If wkPIdx1 > *Zeros;                                                        //0032
                For wkPIdx2 = 1 by 1 to wkPIdx1;                                         //0032
                   wkMapping = *Blanks;                                                  //0032
                   wkMapping = wkParmArr(wkPIdx2);                                       //0032
                   If wkMapping > *Blanks;                                               //0032
                      Exsr buildPseudoCode;                                              //0032
                   EndIf;                                                                //0032
                EndFor;                                                                  //0032
                Clear wkParmArr;                                                         //0032
             EndIf;                                                                      //0032

          Endif;                                                                         //0016
                                                                                         //0033
      When %subst(cSpecDsV3.opcode:1:5) = 'SETLL' OR                                     //0033
           %subst(cSpecDsV3.opcode:1:4) = 'DEFN' ;                                       //0033
                                                                                         //0033
          //Process  Opcode                                                             //0033
              wkDclType        =  cSpecDsV3.opcode;                                      //0036
              WkMpIakeyfield2  =  cSpecDsV3.factor1 ;                                    //0036
              Exsr SrGetRPG3Mapping;                                                     //0036

           exsr buildPseudoCode;                                                         //0033

     other;
          //Write the pseudo code                                                       //0007
          if cSpecDsV3.opcode <> *blank;
             //Skip the next statement from processing                                  //0007
             If inCSpecParmDS.inSkipParm  = *On and CSpecDsV3.Opcode <> 'PARM';          //0007
                inCSpecParmDS.inSkipParm  = *Off ;                                       //0007
             Endif;                                                                      //0007
              wkDclType        =  cSpecDsV3.opcode;                                      //0036
              WkMpIakeyfield2  =  *Blanks;                                               //0036
              Exsr SrGetRPG3Mapping;                                                     //0036

              exsr buildPseudoCode;
          endif;
     EndSl;
     //Write *ENTRY PLIST return Values at End of Program ,if found                     //0032
     Exsr PgmEntryReturnValues;                                                          //0032
   endsr;

//------------------------------------------------------------------------------------- //0036
//SrGetRPG3Mapping: Execute the GetRPG3Mapping procedure to fetch the                   //0036
//                  Source mapping & Indent Type from the data structure                //0036
//------------------------------------------------------------------------------------- //0036
   Begsr SrGetRPG3Mapping;                                                               //0036

      If GetRPG3Mapping() = *On;                                                         //0036
         wkMapping    = wkSrcMapOut;                                                     //0036
         wkIndentType = wkIndentType3;                                                   //0036
      EndIf;                                                                             //0036

   Endsr;                                                                                //0036
//-------------------------------------------------------------------------------------//0003
//CkechValues - Check for the array values                                             //0003
//-------------------------------------------------------------------------------------//0003
   Begsr CkechValues;                                                                   //0003
                                                                                        //0003
      wkVAry = ' ';                                                                     //0003
      wkVIdx = ' ';                                                                     //0003
      wkFactor1 = ' ';                                                                  //0003
      if %scan(',':cSpecDsV3.factor1) > 0 and cSpecDsV3.factor1 <> ',';                 //0003
         wkVAry = %subst(cSpecDsV3.factor1:1:%scan(',':cSpecDsV3.factor1)-1);           //0003
         wkVIdx = %subst(cSpecDsV3.factor1:%scan(',':cSpecDsV3.factor1)+1);             //0003
         wkFactor1 = 'Array ' + %trim(wkVAry) + '(' + %trim(wkVIdx) + ')' ;             //0003
      else;                                                                             //0003
         wkFactor1 = cSpecDsV3.factor1;                                                 //0003
      endif;                                                                            //0003
                                                                                        //0003
      wkFactor2 = ' ';                                                                  //0003
      if %scan(',':cSpecDsV3.factor2) > 0 and cSpecDsV3.factor2 <> ',';                 //0003
         wkVAry = %subst(cSpecDsV3.factor2:1:%scan(',':cSpecDsV3.factor2)-1);           //0003
         wkVIdx = %subst(cSpecDsV3.factor2:%scan(',':cSpecDsV3.factor2)+1);             //0003
         wkFactor2 = 'Array ' + %trim(wkVAry) + '(' + %trim(wkVIdx) + ')' ;             //0003
      else;                                                                             //0003
         wkFactor2 = cSpecDsV3.factor2;                                                 //0003
      endif;                                                                            //0003
                                                                                        //0003
      wkResult = ' ';                                                                   //0003
      if %scan(',':cSpecDsV3.result) > 0 and cSpecDsV3.result <> ',';                   //0003
         wkVAry = %subst(cSpecDsV3.result:1:%scan(',':cSpecDsV3.result)-1);             //0003
         wkVIdx = %subst(cSpecDsV3.result:%scan(',':cSpecDsV3.result)+1);               //0003
         wkResult = 'Array ' + %trim(wkVAry) + '(' + %trim(wkVIdx) + ')' ;              //0003
      else;                                                                             //0003
         wkResult = cSpecDsV3.result;                                                   //0003
      endif;                                                                            //0003
                                                                                        //0003
   endsr;                                                                               //0003

//------------------------------------------------------------------------------------- //0012
//OptionalOpcode - Opcode with Optional Variable handled with Secondary Mapping file    //0012
//------------------------------------------------------------------------------------- //0012
   Begsr OptionalOpcode;                                                                 //0012
     //For Opcode with Factor1 Optional , Replace Factor1 with Result                   //0012
     If %Lookup(%Xlate(cwLo:cwUp:CSpecDsV3.opcode):CSpecMappingDs(*).dsKeywrdOpcodeName) //0012
        > *Zeros and cSpecDsV3.factor1 = *Blanks and wkMapping <> *Blanks;               //0012
        wkMapping = %scanrpl('&Var1':'&Var3':wkMapping);                                 //0012
     Endif;                                                                              //0012
   Endsr;                                                                                //0012

//------------------------------------------------------------------------------------- //0034
//ConditionalIndicator - Write Additional Pseudo line for any Opcode wherever Applicable//0034
//------------------------------------------------------------------------------------- //0034
   Begsr ConditionalIndicator;                                                           //0034
      //Execute when Conditional Indicator is not blank                                 //0034
      If cSpecDsV3.N01N02N03 <> *Blanks;                                                 //0034
         //Get Mapping for N01N02N03 Opcode from IAPSEUDOKP                             //0034
         wkCScanPos = %Lookup('N01N02N03':CSpecMappingDs(*).dsKeywrdOpcodeName);         //0034
         Clear wkMapping;                                                                //0034
         If wkCScanPos <> *Zeros;                                                        //0034
            wkMapping = %Trim(CSpecMappingDs(wkCScanPos).dsSrcMapping);                  //0034
         EndIf;                                                                          //0034
         //Calculate conditional Indicator  N01,N02 and N03 Individually                //0034
         Select;                                                                         //0034
            When %subst(cSpecDsV3.N01N02N03:1:1) = 'N';                                  //0034
               wkN01Mapping = cwInd + %subst(cSpecDsV3.N01N02N03:2:2) + cwFalse;         //0034
            When %subst(cSpecDsV3.N01N02N03:1:3) <> *Blanks;                             //0034
               wkN01Mapping = cwInd + %subst(cSpecDsV3.N01N02N03:2:2) + cwTrue;          //0034
         EndSl;                                                                          //0034
         Select;                                                                         //0034
            When %subst(cSpecDsV3.N01N02N03:4:1) = 'N';                                  //0034
               wkN02Mapping = cwInd + %subst(cSpecDsV3.N01N02N03:5:2) + cwFalse;         //0034
            When %subst(cSpecDsV3.N01N02N03:4:3) <> *Blanks;                             //0034
               wkN02Mapping = cwInd + %subst(cSpecDsV3.N01N02N03:5:2) + cwTrue;          //0034
         EndSl;                                                                          //0034
         Select;                                                                         //0034
            When %subst(cSpecDsV3.N01N02N03:7:1) = 'N';                                  //0034
               wkN03Mapping = cwInd + %subst(cSpecDsV3.N01N02N03:8:2) + cwFalse;         //0034
            When %subst(cSpecDsV3.N01N02N03:7:3) <> *Blanks;                             //0034
               wkN03Mapping = cwInd + %subst(cSpecDsV3.N01N02N03:8:2) + cwTrue;          //0034
         EndSl;                                                                          //0034
         // Mapping for N01 , If found                                                  //0034
         If wkN01Mapping <> *Blanks;                                                     //0034
            wkN01N02N03  =  wkN01Mapping;                                                //0034
         EndIf;                                                                          //0034
         // Mapping for N02 , If found                                                  //0034
         If wkN02Mapping   <> *Blanks;                                                   //0034
            If wkN01N02N03 <> *Blanks;                                                   //0034
               wkN01N02N03 = %trim(wkN01N02N03) + cwAnd + %trim(wkN02Mapping);           //0034
            Else;                                                                        //0034
               wkN01N02N03 = wkN02Mapping;                                               //0034
            EndIf;                                                                       //0034
         EndIf;                                                                          //0034
         // Mapping for N03 , If found                                                  //0034
         If wkN03Mapping   <> *Blanks;                                                   //0034
            If wkN01N02N03 <> *Blanks;                                                   //0034
               wkN01N02N03 = %trim(wkN01N02N03) + cwAnd + %trim(wkN03Mapping);           //0034
            Else;                                                                        //0034
               wkN01N02N03 = wkN03Mapping;                                               //0034
            EndIf;                                                                       //0034
         EndIf;                                                                          //0034
         //Logic to calculate Conditional Indicator PseudoCode                          //0034
         If wkN01N02N03 <> *Blanks and wkMapping <> *Blanks;                             //0034
            Select;                                                                      //0034
               //Write Pseudo for Single line Conditional Indicator                     //0034
               When cSpecDsV3.opcode <> *Blanks and cSpecDsV3.level = *Blanks;           //0034
                  wkMapping = %trim (wkMapping) + %trim (wkN01N02N03);                   //0034
                  Exsr buildPseudoCode;                                                  //0034
               //Calculate Pseudo for Multi line Conditional Indicator                  //0034
               When cSpecDsV3.opcode = *Blanks and cSpecDsV3.level = *Blanks;            //0034
                  wkTempCIndMapping  = cwOpenParen + %trim (wkN01N02N03) +               //0034
                                       cwCloseParen;                                     //0034
               When cSpecDsV3.opcode = *Blanks and cSpecDsV3.level = 'AN';               //0034
                  wkTempCIndMapping  = %trim (wkTempCIndMapping) + cwAnd +               //0034
                                       cwOpenParen + %trim (wkN01N02N03) +               //0034
                                       cwCloseParen;                                     //0034
               When cSpecDsV3.opcode = *Blanks and cSpecDsV3.level = 'OR';               //0034
                  wkTempCIndMapping  = %trim (wkTempCIndMapping) + cwOr  +               //0034
                                       cwOpenParen + %trim (wkN01N02N03) +               //0034
                                       cwCloseParen;                                     //0034
               //Write Pseudo for Multi line Conditional Indicator                      //0034
               When cSpecDsV3.opcode <> *Blanks and cSpecDsV3.level = 'AN';              //0034
                  wkMapping = %trim (wkMapping) + %trim(wkTempCIndMapping) +             //0034
                              cwAnd +  cwOpenParen + %trim (wkN01N02N03)   +             //0034
                              cwCloseParen;                                              //0034
                  Exsr buildPseudoCode;                                                  //0034
                  Clear wkTempCIndMapping;                                               //0034
               When cSpecDsV3.opcode <> *Blanks and cSpecDsV3.level = 'OR';              //0034
                  wkMapping = %trim (wkMapping) + %trim (wkTempCIndMapping) +            //0034
                              cwOr +   cwOpenParen + %trim (wkN01N02N03)    +            //0034
                              cwCloseParen;                                              //0034
                  Exsr buildPseudoCode;                                                  //0034
                  Clear wkTempCIndMapping;                                               //0034
            EndSl;                                                                       //0034
         EndIf;                                                                          //0034
         Clear wkMapping;                                                                //0034
     EndIf;                                                                              //0034
   Endsr;                                                                                //0034
//------------------------------------------------------------------------------------- //0032
//Write *ENTRY PLIST return Values at End of Program                                    //0032
//------------------------------------------------------------------------------------- //0032
   Begsr PgmEntryReturnValues;                                                           //0032

      //Get the Last SourcRRN from IAQRPGSRC for the source member                      //0032
      exec sql                                                                           //0032
         select Coalesce(Max(XSrcRrn),0) into :wkSrcRrnLast                              //0032
         from iAQRpgSrc where                                                            //0032
            XLibNam  =:inCSpecParmDS.inSrcLib  and                                       //0032
            XSrcNam  =:inCSpecParmDS.inSrcPf   and                                       //0032
            XMbrNam  =:inCSpecParmDS.inSrcMbr  and                                       //0032
            XMbrTyp  =:inCSpecParmDS.insrcType and                                       //0032
            XSrcSpec =:inCSpecParmDS.inSrcSpec ;                                         //0032
                                                                                         //0032
      // Write Pseudo for *ENTRY PLIST return Values, If last RRN                       //0032
      If wkSrcRrnLast = inCSpecParmDS.inSrcRrn ;                                         //0032

          //Write Pseudo for Return value                                               //0032
         If wkPrIdx1 > *Zeros;                                                           //0032
            clear wkIndentType;                                                          //0032

            For wkPrIdx2 = 1 by 1 to wkPrIdx1;                                           //0032
               wkMapping = *Blanks;                                                      //0032
               wkMapping = wkParmEntryRtnArr(wkPrIdx2);                                  //0032

               If wkMapping > *Blanks;                                                   //0032
                  Exsr buildPseudoCode;                                                  //0032
               EndIf;                                                                    //0032

            EndFor;                                                                      //0032

            Clear wkParmEntryRtnArr;                                                     //0032
            Clear wkPrIdx1;                                                              //0032
            Clear wkPrIdx2;                                                              //0032

         EndIf;                                                                          //0032
      EndIf;                                                                             //0032
   EndSr;                                                                                //0032

//-------------------------------------------------------------------------------------
//buildPseudoCode - Build PseudoCode
//-------------------------------------------------------------------------------------
   Begsr buildPseudoCode;

     //Check for the Optional Opcode                                                    //0012
     exsr OptionalOpcode;                                                                //0012
     // Check for the array values
     exsr CkechValues;                                                                   //0003

   //Populating the pseudo code statements
     if wkMapping <> *blank;
        if cSpecDsV3.factor1 <> *blank;
           //0003 wkMapping = %scanrpl('&Var1':%trim(cSpecDsV3.factor1):wkMapping);
           wkMapping = %scanrpl('&Var1':%trim(wkFactor1):wkMapping);                    //0003
        endif;
        if cSpecDsV3.factor1 = *blank and cSpecDsV3.Opcode ='DO';                        //0034
            wkMapping = %scanrpl('&Var1':'1':wkMapping);                                 //0034
        endif;                                                                           //0034
        if cSpecDsV3.factor2 <> *blank;
           //0003 wkMapping = %scanrpl('&Var2':%trim(cSpecDsV3.factor2):wkMapping);
           wkMapping = %scanrpl('&Var2':%trim(wkFactor2):wkMapping);                    //0003
        endif;
        if cSpecDsV3.result <> *blank;
           //0003 wkMapping = %scanrpl('&Var3':%trim(cSpecDsV3.result):wkMapping);
           wkMapping = %scanrpl('&Var3':%trim(wkResult):wkMapping);                     //0003
        endif;
     endif;

      //Pseudo Change when CAS Condition is handled with Conditional Indicator          //0034
      If cSpecDsV3.N01N02N03 <> *blanks and cSpecDsV3.factor1 = *Blanks and              //0034
         cSpecDsV3.factor2    = *Blanks ;                                                //0034
         If %Scan('when all' : wkMapping) > *Zeros and cSpecDsV3.Opcode = 'CAS';         //0034
            wkMapping =  %Subst(wkMapping : 1 : %Scan('when all' : wkMapping) - 1);      //0034
         EndIf;                                                                          //0034
         If %Scan('Iterate' : wkMapping) > *Zeros and cSpecDsV3.Opcode = 'DO';           //0034
            wkMapping =  %Subst(wkMapping : 1 : %Scan('Iterate' : wkMapping) - 1);       //0034
         EndIf;                                                                          //0034
      EndIf;                                                                             //0034

      // Write a comment for no-executable code found inside a loop/condition/subroutine //0013
      exsr WriteDoNothingComment;                                                        //0013
                                                                                         //0013
     //Add the space after each indentation start and Apply PipeIndent                  //0017
     //OR write a blank line before the pseudo-code of "TAG" op-code                    //0029
     if wkIndentType <>*Blanks or CSpecDsV3.Opcode = 'TAG';                              //0038
        //Add Pipe Indent for Blank line                                                //0017
        wkPseudoCode = *Blanks;                                                          //0038
        exsr WriteRpg3CSpecPseudocode;                                                   //0017
     endif;                                                                              //0017


   //Perform indentation on the pseduo code


     //Consider to pass the source details to indentation proc so that in case any      //0038
     //printing to be done from there can also be handled                               //0038
     wkPseudocode = wkMapping;                                                           //0038
     OutParmWriteSrcDocDS = inCSpecParmDS;                                               //0038
     OutParmWriteSrcDocDS.dsPseudocode = *Blanks;                                        //0038
     OutParmWriteSrcDocDS.dsDocSeq = inCSpecParmDS.inDocSeq;                             //0038
     wkRPGIndentParmDs.dsSrcDtlDSPointer = %Addr(OutParmWriteSrcDocDS);                  //0038
     If wkRPGIndentParmDs.dsCurrentIndents > *Zeros or  wkIndentType <> *Blanks;         //0038
        wkRPGIndentParmDs.dsIndentType = wkIndentType ;                                  //0038
        wkRPGIndentParmDs.dsPseudocode = wkMapping;                                      //0038
        wkIndentParmPointer = %Addr(wkRPGIndentParmDs);                                  //0038
        IndentRPGPseudoCode(wkIndentParmPointer);                                        //0038
        wkPseudocode = wkRPGIndentParmDs.dsPseudocode;                                   //0038
        //Check if the pseudo-code has been written while indenting, if so increase      //0038
        //the document sequence accordingly                                              //0038
        OutParmWriteSrcDocDS = wkOutParmWriteSrcDocDS;                                   //0038
        If wkOutParmWriteSrcDocDS.dsDocSeq > inCSpecParmDS.inDocSeq;                     //0038
           inCSpecParmDS.inDocSeq = wkOutParmWriteSrcDocDS.dsDocSeq;                     //0038
        EndIf;                                                                           //0038
     EndIf;                                                                              //0038

     //For NewBranch (If condition) write part 1 first                                  //0038
     If wkIndentType = cwNewBranch;                                                      //0038
        Exsr NewBranchPseudoCodeSplit;                                                   //0038
     EndIf;                                                                              //0038

     //Write font code B for TAG                                                        //0010
     Clear wkFontCodeVar;                                                                //0010
     If wkIndentType = cwAdd Or wkIndentType = cwAddCheck Or                             //0010
        wkIndentType = cwRemove Or wkIndentType = cwRemoveCheck;                         //0010
        wkFontCodeVar = cwBoldFont;                                                      //0010
     EndIf;                                                                              //0010

   // Write the pseduo code with the indentation in the file
     If wkPseudoCode <> *Blanks OR                                                       //0038
        (wkPseudocode = *Blanks and wkMapping = *Blanks);                                //0038
        exsr WriteRpg3CSpecPseudocode;                                                   //0038
        Clear wkFontCodeVar;                                                             //0038
     EndIf;                                                                              //0038

     //Increase the count of the Pseudocode written to file                              //0013
     If %check(' |' :wkMaxDataToWrite)<>0;                                               //0038
        wkCountOfLinesUnderTag +=1;                                                      //0013
     EndIf;                                                                              //0013
                                                                                         //0013
   //Add the space after each indentation end
   //OR in case the op-code is 'TAG'                                                    //0029
     if wkIndentType <> *Blanks or CSpecDsV3.Opcode = 'TAG';                             //0038
        //Add Pipe Indent for Blank line                                                //0017
        wkPseudoCode = *Blanks;                                                          //0038
        exsr WriteRpg3CSpecPseudocode;
     endif;
                                                                                         //0013
     //Re-initialize the count of executable code written                                //0013
     If wkIndentType <> *Blanks and wkIndentType <> 'REMOVE';                            //0013
        wkCountOfLinesUnderTag = 0 ;                                                     //0013
     EndIf;                                                                              //0013

     //Pass the current indentation level to keep a track in the next call              //0038
     Eval-Corr RPGIndentParmDS  =  wkRPGIndentParmDS;                                    //0038
     inCSpecParmDS.IOIndentParmPointer = IndentParmPointer;                              //0038

     //Save the indent type                                                              //0013
     If wkIndentType <> *Blanks;                                                         //0013
        wkPreviousIndentType = wkIndentType;                                             //0013
     EndIf;                                                                              //0013
                                                                                         //0013
   endsr;

//-------------------------------------------------------------------------------------
//WriteRpg3CSpecDeclaration - Subroutine to write C Spec Pseudocode
//-------------------------------------------------------------------------------------
   Begsr WriteRpg3CSpecDeclaration;
      OutParmWriteSrcDocDS.dsPseudocode = wkPseudocode;
      ioParmPointer  = %addr(OutParmWriteSrcDocDS);
      writePseudoCode(ioParmPointer);
   Endsr;

//-------------------------------------------------------------------------------------
//Initialise - Initialise the work variables
//-------------------------------------------------------------------------------------
   Begsr Initialise;
     clear OutParmWriteSrcDocDS;
     wkNoDecflag = *off;                                                                 //0002
     wkSrcMbr   = %Xlate(cwLo:cwUp:inCSpecParmDS.inSrcMbr);
     wkSrcMtyp  = %Xlate(cwLo:cwUp:inCSpecParmDS.insrcType);
     wkSrcLtyp  = %Xlate(cwLo:cwUp:inCSpecParmDS.inSrcLtyp);
     wkSrcDta   = %Xlate(cwLo:cwUp:inCSpecParmDS.inSrcDta);
     wkSrcSpec  = %Xlate(cwLo:cwUp:inCSpecParmDS.inSrcSpec);
     IndentParmPointer   = inCSpecParmDS.IOIndentParmPointer;                            //0038
     Eval-Corr wkRPGIndentParmDS  = RPGIndentParmDS;                                     //0038

     OutParmWriteSrcDocDS = inCSpecParmDS;
     OutParmWriteSrcDocDS.dsPseudocode = *Blanks;                                        //0038
     wkSrcLtyp3   = cwFX3;                                                               //0036
     wkSrcSpec3   = cwC;                                                                 //0036
     WkMpIakeyfield2  =   *Blanks;                                                       //0036
     //Load specs to include                                                            //0039
     If InclusiveSpecArr(1)  =  *Blanks;                                                 //0039
        InclusiveSpecArr = GetRPG3SpecsToInclude(inInclDeclSpecs);                       //0042
     Endif;                                                                              //0039
   Endsr;

//-------------------------------------------------------------------------------------
//Process the c-spec declatation
//-------------------------------------------------------------------------------------
   Begsr processVariableDeclarations;

     evalr wkLength = %char(cSpecDsV3.length);                                           //0004
     if not wkNoDecflag;                                                                 //0002
        Wk_Datatype = 'P' ;                                                              //0014
        wkPseudoCode =  cSpecDsV3.result + '   ' + cwDelimiter + ' ' +
                        Wk_DataType + cwDelimiter + ' ' +                                //0014
                        wkLength +  ':' + %char(cSpecDsV3.decPos) +                      //0002
                        '  ' + cwDelimiter ;                                             //0002
     else;                                                                               //0002
        Wk_Datatype = 'A' ;                                                              //0014
        wkPseudoCode =  cSpecDsV3.result + '   ' + cwDelimiter + ' ' +                   //0002
                        Wk_DataType +  cwDelimiter + ' ' +                               //0014
                        wkLength + '    ' + cwDelimiter ;                                //0002
        wkNoDecflag  = *off;                                                             //0002
     endif;                                                                              //0002

     exsr WriteRpg3CSpecDeclaration;
   Endsr;

//-------------------------------------------------------------------------------------
//WriteRpg3CSpecPseudocode  - Subroutine to write C Spec Pseudocode
//-------------------------------------------------------------------------------------
   Begsr WriteRpg3CSpecPseudocode;

     // If wkIndentParmDS.dsPseudocode = *Blanks ;                                       //0023
      If wkPseudocode = *Blanks or  %Check(' |' : wkPseudocode)= *Zeros ;                //0038
         wkMaxDataToWrite = *Blanks;                                                     //0038
         Exsr SrAddPipesBeforePseudoCode;                                                //0038
         OutParmWriteSrcDocDS.dsPseudocode = wkMaxDataToWrite;                           //0038
         //Write Pseudo to IAPSEUDOWK using new procedure WriteIaPseudowk               //0026
         ioParmPointer  = %addr(OutParmWriteSrcDocDS);                                   //0026
         WriteIaPseudowk(ioParmPointer : inCSpecParmDS.inDocSeq : wkFontCodeVar) ;       //0026
      Else ;                                                                             //0019
         wkPseudoCodeTmp= *Blanks;                                                       //0038
         wkFirstNonBlankCharPos = %Check(' |': wkPseudoCode);                            //0038
         Dow wkPSeudoCode <> *Blanks ;                                                   //0019
            Exsr BreakCode ;                                                             //0019
            Exsr SrAddPipesBeforePseudoCode;                                             //0038
            If wkMaxDataToWrite = *Blanks or %Check(' |' : wkMaxDataToWrite)= *Zeros ;   //0023
               Leave ;                                                                   //0019
            Endif ;                                                                      //0019
            OutParmWriteSrcDocDS.dsPseudocode = wkMaxDataToWrite ;                       //0019
            //Write Pseudo to IAPSEUDOWK using new procedure WriteIaPseudowk            //0026
            ioParmPointer  = %addr(OutParmWriteSrcDocDS);                                //0026
            WriteIaPseudowk(ioParmPointer : inCSpecParmDS.inDocSeq : wkFontCodeVar) ;    //0026
            //Clear Fontcode if its split line                                          //0026
            If wkFontCodeVar = cwBoldFont and wkMaxDataToWrite <> *Blanks  and           //0023
               wkPSeudoCode <> *Blanks ;                                                 //0023
               Clear wkFontCodeVar;                                                      //0023
            EndIf;                                                                       //0023
         Enddo ;                                                                         //0019
      Endif ;                                                                            //0019
   Endsr;
//------------------------------------------------------------------------------------- //0038
//Subroutine SrAddPipesBeforePseudoCode - Append Pipes before the pseudocode            //0038
//------------------------------------------------------------------------------------- //0038
   Begsr SrAddPipesBeforePseudoCode;

      If wkRPGIndentParmDS.dsPipeIndentSave <> *Blanks ;                                 //0038
         wkPipelength = %len(%trim(wkRPGIndentParmDS.dsPipeIndentSave));                 //0038

         // Removes Last Pipe for Every new Tag and Its comment line                     //0038
         If wkRPGIndentParmDS.dsPipeTagInd = *on and                                     //0038
            %subst(wkMaxDataToWrite : 1 : wkPipelength) <> *Blanks;                      //0038
            wkPipelength = wkPipelength - 1;                                             //0038
         EndIf;                                                                          //0038
         // Append Calculated PipeIndent for Every nestedd Line in Pseudocode            //0038
         %subst(wkMaxDataToWrite : 1 : wkPipelength)=                                    //0038
         %trimr(wkRPGIndentParmDS.dsPipeIndentSave);                                     //0038
      EndIf;                                                                             //0038

   EndSr;                                                                                //0038
//-------------------------------------------------------------------------------------
//WriteHeader  - Subroutine to write the header
//-------------------------------------------------------------------------------------
   Begsr WriteHeader;

      exec sql
         declare C1 cursor for
            SELECT SRC_MAPPING
            FROM IAPSEUDOMP
            WHERE SRCMBR_TYPE = 'RPG'
            and KEYFIELD_1  = 'HEADER'
            and SOURCE_SPEC = 'C'
            and KEYFIELD_2  = ' '
            ORDER BY SEQ_NO;

      exec sql
         open c1;

      exec sql
         fetch from C1 into :wkPseudoCode;

      dow sqlcode = 0 ;
         exsr WriteRpg3CSpecPseudocode;
         exec sql
            fetch from C1 into :wkPseudoCode;
      enddo;
      exec sql
         close c1;
   Endsr;
//------------------------------------------------------------------------------------- //0013
//WriteDoNothingComment - In case no executable statement found in a loop/condition     //0013
//                        or a subroutine, write a comment to mention the same.         //0013
//------------------------------------------------------------------------------------- //0013
   Begsr WriteDoNothingComment;                                                          //0013

      If (wkIndentType = 'REMOVE' or (wkIndentType = 'BRANCH' and                        //0013
         wkPreviousIndentType<>'ADD' and wkPreviousIndentType<>*Blanks))                 //0013
         and                                                                             //0013
         wkPreviousIndentType<>'CASE'                                                    //0013
         and                                                                             //0013
         wkCountOfLinesUnderTag = 0;                                                     //0013

         //Write a blank line.                                                           //0013
         //Add Pipe Indent for Blank line                                               //0017
         //wkIndentParmDS.dsPseudocode = *Blanks;                                        //0017
         wkPseudoCode = *Blanks;                                                         //0038
         Exsr WriteRpg3CSpecPseudocode;                                                  //0013

         //Indent the comment to be written                                              //0013
         wkRPGIndentParmDs.dsIndentType = *Blanks ;                                      //0038
         wkRPGIndentParmDs.dsPseudocode = wkDoNothingComment;                            //0038
         wkIndentParmPointer = %Addr(wkRPGIndentParmDs);                                 //0038
         IndentRPGPseudoCode(wkIndentParmPointer);                                       //0038
         wkPseudoCode = wkRPGIndentParmDs.dsPseudocode;                                  //0038
         Exsr WriteRpg3CSpecPseudocode;                                                  //0013

         //Write a blank line.                                                           //0013
         //Add Pipe Indent for Blank line                                               //0017
         wkPseudoCode = *Blanks;                                                         //0038
         Exsr WriteRpg3CSpecPseudocode;                                                  //0013

      EndIf;                                                                             //0013

   EndSr;                                                                                //0013
                                                                                         //0019
//------------------------------------------------------------------------------------- //0019
//BreakCode  - Subroutine to break pseudocode if it is more than 109 length             //0019
//------------------------------------------------------------------------------------- //0019
   Begsr BreakCode ;                                                                     //0019
      //Break the code is code length > 109                                              //0019
      If %len(%trimr(wkPseudoCode)) > cwMaxNoOfCharToPrint ;                             //0019
         //Move the Pseudo-code to DS to check from where it should be broken            //0019
         DsPseudoCodeForBlankCheck = %trimr(wkPseudoCode);                               //0019
                                                                                         //0019
         //Start checking from 110th position backwards to find blank, wherever         //0019
         //blank position will be found Pseudo-code will be broke from there            //0019
         For wkIdx = cwMaxNoOfCharToPrint + 1 DownTo 1;                                  //0019
            If wkPseudoCodeForBlankCheckArr(wkIdx)=' ';                                  //0019
               Leave;                                                                    //0019
            EndIf;                                                                       //0019
         EndFor;                                                                         //0019
                                                                                         //0019
         //Exception handling.                                                          //0019
         If wkIdx = 0 Or %subst(wkPseudoCode : 1 : wkIdx) = *Blanks;                     //0019
            wkIdx = cwMaxNoOfCharToPrint;                                                //0019
         EndIf;                                                                          //0019
                                                                                         //0019
         //Increment Indent to display PipeSymbol from second split line of Tag         //0038
         If wkRPGIndentParmDS.dsPipeTagInd=*On and wkPseudoCodeTmp = *Blanks;            //0038
            wkFirstNonBlankCharPos = wkFirstNonBlankCharPos + 2;                         //0038
         EndIf;                                                                          //0038

         //Move the data which can be printed to wkMaxDataToWrite                        //0019
         wkMaxDataToWrite = %trimr(%subst(wkPseudoCode : 1 : wkIdx));                    //0019
                                                                                         //0019
         //Move remaining data to wkPseudoCode and add indentation                      //0038
         wkPseudoCodeTmp    = wkPseudoCode;                                              //0038
         Clear wkPseudoCode;                                                             //0038
         %subst(wkPseudoCode : wkFirstNonBlankCharPos) =                                 //0038
                                      %trim(%subst(wkPseudoCodeTmp : wkIdx+1));          //0038

         //Add Indent and Pipe for the Split Lines                                      //0023
      Else;                                                                              //0019
         //If total length of Pseudo code is less than 109, move full data               //0019
         wkMaxDataToWrite = %trimr(wkPseudoCode);                                        //0019
         wkPseudoCode     = *Blanks;                                                     //0019
      Endif ;                                                                            //0019
   Endsr ;                                                                               //0019
                                                                                         //0019
//------------------------------------------------------------------------------------- //0022
//MapReplacePseudoCode - Check for array values and replace variables                   //0022
//------------------------------------------------------------------------------------- //0022
   Begsr MapReplacePseudoCode ;                                                          //0022
      // Check for the array values                                                     //0022
      Exsr CkechValues;                                                                  //0022
                                                                                         //0022
      //Populating the pseudo code statements                                           //0022
      If wkMapping <> *Blanks ;                                                          //0022
         If cSpecDsV3.factor1 <> *Blanks ;                                               //0022
           wkMapping = %scanrpl('&Var1':%trim(wkFactor1):wkMapping);                     //0022
         Endif;                                                                          //0022
         If cSpecDsV3.factor2 <> *Blanks ;                                               //0022
           wkMapping = %scanrpl('&Var2':%trim(wkFactor2):wkMapping);                     //0022
         Endif;                                                                          //0022
         If cSpecDsV3.result <> *Blanks ;                                                //0022
           wkMapping = %scanrpl('&Var3':%trim(wkResult):wkMapping);                      //0022
         Endif;                                                                          //0022
      Endif;                                                                             //0022
   Endsr ;                                                                               //0022
   //-----------------------------------------------------------------------------------//0038
   //NewBranchPseudoCodeSplit - Subroutine to write part 1 of pseudocode                //0038
   //-----------------------------------------------------------------------------------//0038
   Begsr NewBranchPseudoCodeSplit;                                                       //0038

      //Write part 1 of the pseudo code first                                            //0038
      Clear wkPseudoCode1;                                                               //0038
      wkPseudoCode1   = wkPseudoCode;                                                    //0038
      wkSplitIdx = %scan(cwSplitCharacter : wkPSeudoCode);                               //0038
      If wkSplitIdx <> 0;                                                                //0038
         //Split                                                                         //0038
         Clear wkPSeudoCode;                                                             //0038
         wkPseudoCode = %Subst(wkPseudoCode1 : 1: wkSplitIdx-1);                         //0038

         //Write part1 of Pseudocode to the IAPSEUDOWK file                              //0038
         wkFontCodeVar = cwBoldFont;                                                     //0038
         Exsr WriteRpg3CSpecPseudocode;                                                  //0038

         //Write blank line after part 1                                                 //0038
         wkPseudoCode = *Blanks;                                                         //0038
         wkFontCodeVar= *Blanks;                                                         //0038
         Exsr WriteRpg3CSpecPseudocode;                                                  //0038

         //Move remaining part2 to pseudocode                                            //0038
         Clear wkPSeudoCode;                                                             //0038
         wkPseudoCode = %Subst(wkPseudoCode1 : wkSplitIdx+4);                            //0038

         //Move indentation type as BRANCH for part 2 and add indentation                //0038
         wkRPGIndentParmDS.dsIndentType = cwBranch ;                                     //0038
         wkRPGIndentParmDS.dsPseudocode = wkPseudoCode;                                  //0038
         wkIndentParmPointer = %Addr(wkRPGIndentParmDs);                                 //0038
         IndentRPGPseudoCode(wkIndentParmPointer);                                       //0038
         wkPseudocode = wkRPGIndentParmDS.dsPseudocode;                                  //0038

      EndIf;                                                                             //0038

   EndSr;                                                                                //0038

/copy 'QCPYSRC/iaprcerlog.rpgleinc'
End-Proc;

//SS01 TAG STARTS HERE ----------------------------------------------------------------//
//-------------------------------------------------------------------------------------//
//Procedure to parser the I - Spec source to Pseudocode                                //
//------------------------------------------------------------------------------------- //

Dcl-Proc rpg3ISpecParser Export;

   Dcl-Pi rpg3ISpecParser;
      inISpecParmPointer Pointer;
   End-Pi;

   // Declaration of datastructure
   // I Spec Parser Parameter datastructure
   Dcl-Ds inISpecParmDS  Qualified Based(inISpecParmPointer);
      inReqId        Char(18);
      inSrcLib       Char(10);
      inSrcPf        Char(10);
      inSrcMbr       Char(10);
      insrcType      Char(10);
      inSrcRrn       Packed(6:0);
      inSrcSeq       Packed(6:2);
      inSrcLtyp      Char(5);
      inSrcSpec      Char(1);
      inSrcLnct      Char(1);
      inSrcDta       VarChar(cwSrcLength);
      IOIndentParmPointer Pointer;                                                       //0038
      inDclType      Char(10);
      inSubType      Char(10);
      inhCmtReqd     Char(1);
      inSkipNxtStm   ind;                                                                //0005
      inFileNames    char(10) dim(99);                                                   //0005
      inFileCount    zoned(2:0);                                                         //0005
      inDocSeq       packed(6:0);                                                        //0005
      inVarAry       Char(6) dim(9999);                                                  //0005
      inVarCount     zoned(4:0);                                                         //0005
      inIfCount      zoned(4:0);                                                         //0005
      inSkipParm     ind;                                                                //0007
   End-Ds;

   //Declaration of constants
   Dcl-C  cwLocalDtaara               Const('*LOCAL DTAARA');                            //0020
   Dcl-C  cwProgramDS                 Const('*PROGRAM DS');                              //0020
   Dcl-C  cwNOName                    Const('*NONAME');                                  //0020
   //Declaration of work variables
   Dcl-S  wkPseudoCode                Char(cwSrcLength) Inz;
   Dcl-S  wkSrcType                   Char(10);
   Dcl-S  wkSrcDta                    VarChar(cwSrcLength) Inz;
   Dcl-S  IOParmPointer               Pointer Inz(*Null);
   Dcl-S  WKDclTyp                    Char(10);
   Dcl-S  wkPromptTyp                 Char(2)   Inz;                                     //0020
   Dcl-S  wkIdx                       Packed(5:0) Inz;                                   //0020
   Dcl-S  IspecFromPos                Packed(4:0) Inz;                                   //0020
   Dcl-S  IspecToPos                  Packed(4:0) Inz;                                   //0020

   // DS to move the record format/field details for writing to output file             //0020
   Dcl-Ds DSForRecordFormat Qualified;                                                   //0020
      RecFldName     char(14) pos(1)  Inz;                                               //0020
      Delimiter1     char(1)  pos(15) Inz('|');                                          //0020
      ReNamed        char(11) pos(16) Inz;                                               //0020
      Delimiter2     char(1)  pos(27) Inz('|');                                          //0020
      Position       char(9)  pos(28) Inz;                                               //0020
      Delimiter3     char(1)  pos(37) Inz('|');                                          //0020
      Length         char(6)  pos(39) Inz;                                               //0020
      Delimiter4     char(1)  pos(45) Inz('|');                                          //0020
      DataType       char(1)  pos(49) Inz;                                               //0020
      Delimiter5     char(1)  pos(56) Inz('|');                                          //0020
      InitValue      char(22) pos(57) Inz;                                               //0020
   End-Ds;                                                                               //0020

   // DS to move the data structure & its field details for writing to output file      //0020
   Dcl-Ds DSForDataStruct Qualified;                                                     //0020
      DSFldName      char(14) pos(1)  Inz;                                               //0020
      Delimiter1     char(1)  pos(15) Inz('|');                                          //0020
      Position       char(9)  pos(16) Inz;                                               //0020
      Delimiter3     char(1)  pos(25) Inz('|');                                          //0020
      Length         char(8)  pos(27) Inz;                                               //0020
      Delimiter4     char(1)  pos(35) Inz('|');                                          //0020
      DataType       char(1)  pos(39) Inz;                                               //0020
      Delimiter5     char(1)  pos(46) Inz('|');                                          //0020
      Dimension      char(5)  pos(47) Inz;                                               //0020
      Delimiter6     char(1)  pos(52) Inz('|');                                          //0020
      ExtFileInit    char(22) pos(53) Inz;                                               //0020
   End-Ds;                                                                               //0020

   // DS to move the constant variable and its value to write to o/p file                //0020
   Dcl-Ds DSForConstant Qualified;                                                       //0020
      ConstantName   char(14) pos(1)  Inz;                                               //0020
      Delimiter1     char(1)  pos(15) Inz('|');                                          //0020
      InitValue      char(25) pos(16) Inz;                                               //0020
   End-Ds;                                                                               //0020

   //Copybook declaration
/copy 'QCPYSRC/iaprderlog.rpgleinc'

   // Initialise the variables
     Exsr Initialise;

     //Identify the prompt type                                                         //0020
     Exsr IdentifyPromptType;                                                            //0020

     //Move required values (file/field/DS name, length etc) to output DS based on      //0020
     //prompt type                                                                      //0020
     Exsr MoveValuesToOutputDSAndPrint;                                                  //0020

     inISpecParmDS.inDclType     = WkDclTyp;
   Return;

//------------------------------------------------------------------------------------- //
//Initialise - Initialise the work variables                                            //
//------------------------------------------------------------------------------------- //
   Begsr Initialise;
     wkSrcDta                    =  %TrimR(inISpecParmDS.inSrcDta);                      //0020
     wkSrcSpec                   =  inISpecParmDS.inSrcSpec;
     wkSrcType                   =  inISpecParmDS.inSrcType;                             //0020
     OutParmWriteSrcDocDS        =  inISpecParmDS;
     WkDclTyp                    =  inISpecParmDS.inDclType;
   Endsr;
//------------------------------------------------------------------------------------- //0020
//IdentifyPromptType - Identify which type of prompt has been taken for I spec code     //0020
//------------------------------------------------------------------------------------- //0020
   Begsr IdentifyPromptType;                                                             //0020
                                                                                         //0020
     //Move the data to data structure to break the code in different parts for checking //0020
     ChkISpecDsV3 = wkSrcDta;                                                            //0020
     //Move from to pos                                                                 //0020
     IspecFromPos  =  *Zeros;                                                            //0020
     If ChkISpecDsV3.FromPosNum  <>  *Blanks   And                                       //0020
        %Check(cwDigits : %Trim(ChkISpecDsV3.FromPosNum)) =  *Zeros;                     //0020
        IspecFromPos    = %Uns(ChkISpecDsV3.FromPosNum);                                 //0020
     Endif;                                                                              //0020
                                                                                         //0020
     IspecToPos  =  *Zeros;                                                              //0020
     If ChkISpecDsV3.ToPosNum  <>  *Blanks   And                                         //0020
        %Check(cwDigits : %Trim(ChkISpecDsV3.ToPosNum)) =  *Zeros;                       //0020
        IspecToPos = %Uns(ChkISpecDsV3.ToPosNum);                                        //0020
     Endif;                                                                              //0020

     Select;                                                                             //0020
         When ChkISpecDsV3.ChkForI_IX_DS_SV_Prompt <> *Blanks;                           //0020
            Select;                                                                      //0020
               When  ChkISpecDsV3.RecordId_Or_DS = 'DS';                                 //0020
                     wkPromptTyp = 'DS';                                                 //0020
                                                                                         //0020
               When  ChkISpecDsV3.ChkForSV_Prompt=*Blanks;                               //0020
                     wkPromptTyp = 'SV';                                                 //0020
                                                                                         //0020
               When  ChkISpecDsV3.ChkForI_Prompt1<>*Blanks OR                            //0020
                     ChkISpecDsV3.ChkForI_Prompt2<>*Blanks;                              //0020
                     wkPromptTyp = 'I';                                                  //0020
                                                                                         //0020
               Other;                                                                    //0020
                  wkPromptTyp = 'IX';                                                    //0020
            EndSl;                                                                       //0020
                                                                                         //0020
         When  ChkISpecDsV3.ChkForJ_Prompt = *Blanks;                                    //0020
               wkPromptTyp = 'J';                                                        //0020
                                                                                         //0020
         When  ChkISpecDsV3.ChkForN_Prompt = *Blanks OR                                  //0020
               ChkISpecDsV3.FieldType  = 'C';                                            //0020
               wkPromptTyp = 'N';                                                        //0020
                                                                                         //0020
         When  ChkISpecDsV3.ChkForSS_Prompt <> *Blanks;                                  //0020
               wkPromptTyp = 'SS';                                                       //0020
                                                                                         //0020
         Other;                                                                          //0020
               wkPromptTyp = 'JX';                                                       //0020
      EndSl;                                                                             //0020
                                                                                         //0020
   Endsr;                                                                                //0020
                                                                                         //0020
//------------------------------------------------------------------------------------- //0020
//MoveValuesToOutputDSAndPrint - Move value from input source data to output DS          //0020
//------------------------------------------------------------------------------------- //0020
   Begsr MoveValuesToOutputDSAndPrint;                                                   //0020
                                                                                         //0020
     //Check the prompt type and write the output based on the same                      //0020
      Select;                                                                            //0020
         When wkPromptTyp = 'I' OR wkPromptTyp = 'IX' OR                                 //0020
              (wkPromptTyp <> 'DS' and wkPromptTyp<>'N' and wkDclTyp = 'FR');            //0020
               wkDclTyp = 'FR';                                                          //0020
               Exsr MoveValuesForRcdFmt;                                                 //0020
                                                                                         //0020
               //Write header if its the start of record format declaration              //0020
               If wkPromptTyp = 'I' OR wkPromptTyp = 'IX';                               //0020
                  //Print a blank line first                                             //0020
                  wkPseudoCode = *Blanks;                                                //0020
                  Exsr WriteISpecPseudocode;                                             //0020
                  //Print header for record format                                       //0020
                  For wkIdx = 1 to %Elem(DSIspecRcdFmtHdr);                              //0020
                     If DSIspecRcdFmtHdr(wkIdx) <> *Blanks;                              //0020
                        wkPseudoCode = DSIspecRcdFmtHdr(wkIdx);                          //0020
                        Exsr WriteISpecPseudocode;                                       //0020
                     Else;                                                               //0020
                        Leave;                                                           //0020
                     EndIf;                                                              //0020
                  EndFor;                                                                //0020
               EndIf;                                                                    //0020
               //Print data                                                              //0020
               wkPseudoCode = DSForRecordFormat;                                         //0020
               Exsr WriteISpecPseudocode;                                                //0020
                                                                                         //0020
         When wkPromptTyp = 'DS' OR (wkPromptTyp <> 'N' and wkDclTyp = 'FD');            //0020
               wkDclTyp = 'FD';                                                          //0020
               Exsr MoveValuesForDs;                                                     //0020
                                                                                         //0020
               //Write header if its the start of DS declaration                         //0020
               If wkPromptTyp = 'DS';                                                    //0020
                  //Print a blank line first                                             //0020
                  wkPseudoCode = *Blanks;                                                //0020
                  Exsr WriteISpecPseudocode;                                             //0020
                  //Print header for data structure                                      //0020
                  For wkIdx = 1 to %Elem(DSIspecDSHdr);                                  //0020
                     If DSIspecDSHdr(wkIdx) <> *Blanks;                                  //0020
                        wkPseudoCode = DSIspecDSHdr(wkIdx);                              //0020
                        Exsr WriteISpecPseudocode;                                       //0020
                     Else;                                                               //0020
                        Leave;                                                           //0020
                     EndIf;                                                              //0020
                  EndFor;                                                                //0020
               EndIf;                                                                    //0020
               //Print data                                                              //0020
               wkPseudoCode = DSForDataStruct;                                           //0020
               Exsr WriteISpecPseudocode;                                                //0020
                                                                                         //0020
         When wkPromptTyp = 'N';                                                         //0020
               //In case constant declaration ended/one liner; move to DS and print.     //0020
               If ChkISpecDsV3.FieldType = 'C';                                          //0020
                                                                                         //0020
                  Exsr MoveValuesForConstantAndPrint;                                    //0020
                                                                                         //0020
               Else;                                                                     //0020
                                                                                         //0020
                  //In case there is some continuation in constant declaration, save     //0020
                  //and return without printing.                                         //0020
                  wkISpecConstValArrCnt +=1;                                             //0020
                  wkISpecConstValArr(wkISpecConstValArrCnt) =                            //0020
                     ChkISpecDsV3.Initial_Or_ConstValue;                                 //0020
                  Return;                                                                //0020
                                                                                         //0020
               EndIf;                                                                    //0020
                                                                                         //0020
      EndSl;                                                                             //0020
                                                                                         //0020
   EndSr;                                                                                //0020
//------------------------------------------------------------------------------------- //0020
//MoveValuesForRcdFmt - Move values from input source data to record format O/P DS       //0020
//------------------------------------------------------------------------------------- //0020
   Begsr MoveValuesForRcdFmt;                                                            //0020
                                                                                         //0020
      //a- Move format/file/field name to o/p DS                                         //0020
      Select;                                                                            //0020
         When wkPromptTyp = 'SV';                                                        //0028
            %subst(DSForRecordFormat.RecFldName:4)=                                      //0028
                                           ChkISpecDsV3.Actual_Or_RenamedField;          //0028
                                                                                         //0028
         When ChkISpecDsV3.file_RecFmt_Ds_Name <> *Blanks;                               //0020
            DSForRecordFormat.RecFldName = ChkISpecDsV3.file_RecFmt_Ds_Name;             //0020
                                                                                         //0020
         When ChkISpecDsV3.ActualField_Or_ExtFileName <> *Blanks;                        //0020
            %subst(DSForRecordFormat.RecFldName:4)=                                      //0020
                                  ChkISpecDsV3.ActualField_Or_ExtFileName;               //0020
                                                                                         //0020
         Other;                                                                          //0020
            %subst(DSForRecordFormat.RecFldName:4)=ChkISpecDsV3.Actual_Or_RenamedField;  //0020
                                                                                         //0020
      EndSl;                                                                             //0020
                                                                                         //0020
      //b- Move new name of the field to O/P DS                                          //0020
      If ChkISpecDsV3.Actual_Or_RenamedField <> *Blanks and                              //0020
         wkPromptTyp <> 'SV' and                                                         //0028
         ChkISpecDsV3.ActualField_Or_ExtFileName <> *Blanks;                             //0020
                                                                                         //0020
         DSForRecordFormat.ReNamed = ChkISpecDsV3.Actual_Or_RenamedField;                //0020
                                                                                         //0020
      EndIf;                                                                             //0020
                                                                                         //0020
      //c- Move position to O/P DS                                                       //0020
      DSForRecordFormat.Position = chkISpecDsV3.FromPos_Or_OccursDs;                     //0020
                                                                                         //0020
      //d- Move length to O/P DS                                                         //0020
      Select;                                                                            //0020
         When  chkISpecDsV3.FromPos_Or_OccursDs <> *Blanks and                           //0020
               chkISpecDsV3.ToPos_Or_DSLength <> *Blanks and                             //0020
               IspecFromPos  <>  0  and IspecToPos <>  0 and                             //0020
               IspecFromPos  <=  IspecToPos;                                             //0020
                                                                                         //0020
               DSForRecordFormat.Length = %Char(IspecToPos - IspecFromPos +1);           //0020
                                                                                         //0020
         When  chkISpecDsV3.ToPos_Or_DSLength <> *Blanks and                             //0020
               IspecToPos > 0;                                                           //0020
                                                                                         //0020
               DSForRecordFormat.Length = %Char(IspecToPos);                             //0020
      EndSl;                                                                             //0020
      //Add decimal point after the length                                               //0020
      If DSForRecordFormat.Length <> *Blanks AND                                         //0020
         chkISpecDsV3.decimalPosition <> *Blanks;                                        //0020
                                                                                         //0020
         DSForRecordFormat.Length = %trim(DSForRecordFormat.Length) + ':' +              //0020
                                    %trim(chkISpecDsV3.decimalPosition);                 //0020
      EndIf;                                                                             //0020
                                                                                         //0020
      //e- Move data type to O/P DS                                                      //0020
      Select;                                                                            //0020
         When chkISpecDsV3.FieldType = 'B';                                              //0020
            DSForRecordFormat.DataType = 'B';                                            //0020
                                                                                         //0020
         when chkISpecDsV3.FieldType = 'P' or chkISpecDsV3.decimalPosition<>*Blanks;     //0020
               DSForRecordFormat.DataType = 'P';                                         //0020
                                                                                         //0020
         When chkISpecDsV3.FromPos_Or_OccursDs <> *Blanks and                            //0020
               chkISpecDsV3.ToPos_Or_DSLength <> *Blanks;                                //0020
               DSForRecordFormat.DataType = 'A';                                         //0020
                                                                                         //0020
      EndSl;                                                                             //0020
                                                                                         //0020
      //f- Move initialization value                                                     //0020
      If wkPromptTyp = 'SV'                                                              //0020
         and ChkISpecDsV3.Initial_Or_ConstValue<>*Blanks;                                //0020
         DSForRecordFormat.InitValue=ChkISpecDsV3.Initial_Or_ConstValue;                 //0020
      EndIf;                                                                             //0020
                                                                                         //0020
   EndSr;                                                                                //0020
//------------------------------------------------------------------------------------- //0020
//MoveValuesForDs - Move values from input source data to Data Structure O/P DS          //0020
//------------------------------------------------------------------------------------- //0020
   Begsr MoveValuesForDS;                                                                //0020
                                                                                         //0020
      //a- Move format/file/field name to o/p DS                                         //0020
      Select;                                                                            //0020
         When wkPromptTyp = 'SV';                                                        //0028
            %subst(DSForDataStruct.DSFldName:4)=                                         //0028
                                        ChkISpecDsV3.Actual_Or_RenamedField;             //0028
                                                                                         //0028
         When ChkISpecDsV3.file_RecFmt_Ds_Name <> *Blanks;                               //0020
            DSForDataStruct.DSFldName = ChkISpecDsV3.file_RecFmt_Ds_Name;                //0020
                                                                                         //0020
         When ChkISpecDsV3.ActualField_Or_ExtFileName <> *Blanks;                        //0020
            %subst(DSForDataStruct.DSFldName:4)=                                         //0020
                                  ChkISpecDsV3.ActualField_Or_ExtFileName;               //0020
                                                                                         //0020
         Other;                                                                          //0020
            %subst(DSForDataStruct.DSFldName:4)=ChkISpecDsV3.Actual_Or_RenamedField;     //0020
                                                                                         //0020
      EndSl;                                                                             //0020
      //In case the Name of the DS is returned as blanks, check if its local data
      //ares OR psds, If so generate the name correspondingly
      If wkPromptTyp = 'DS' and DSForDataStruct.DSFldName = *Blanks;
         Select;
           When ChkISpecDsV3.option_or_DS_Type = 'U';
                DSForDataStruct.DSFldName =cwLocalDtaara ;

           When ChkISpecDsV3.option_or_DS_Type = 'S';
                DSForDataStruct.DSFldName = cwProgramDS ;

           Other;
                DSForDataStruct.DSFldName = cwNOName;

           EndSl;
      EndIf;
                                                                                         //0020
      //b- Move position/Dimension to O/P DS                                             //0020
      Select;                                                                            //0020
         When  chkISpecDsV3.FromPos_Or_OccursDs <> *Blanks and wkPromptTyp='DS';         //0020
               DSForDataStruct.Dimension = chkISpecDsV3.FromPos_Or_OccursDs;             //0020
                                                                                         //0020
         When  chkISpecDsV3.FromPos_Or_OccursDs <> *Blanks;                              //0020
               DSForDataStruct.Position = chkISpecDsV3.FromPos_Or_OccursDs;              //0020
      EndSl;                                                                             //0020
                                                                                         //0020
      //c- Move length to O/P DS                                                         //0020
      Select;                                                                            //0020
         When wkPromptTyp='DS' and chkISpecDsV3.ToPos_Or_DSLength <> *Blanks;            //0020
                                                                                         //0020
               DSForDataStruct.Length = %trim(chkISpecDsV3.ToPos_Or_DSLength);           //0020
                                                                                         //0020
         When  wkPromptTyp <> 'DS' and                                                   //0020
               chkISpecDsV3.FromPos_Or_OccursDs <> *Blanks and                           //0020
               chkISpecDsV3.ToPos_Or_DSLength <> *Blanks and                             //0020
               IspecFromPos  <>  0  And IspecTopos  <>  0  And                           //0020
               IspecFromPos  <=  IspecTopos;                                             //0020
                                                                                         //0020
               DSForDataStruct.Length = %char(IspecToPos - IspecFromPos + 1);            //0020
                                                                                         //0020
         When  wkPromptTyp <> 'DS' and                                                   //0020
               chkISpecDsV3.ToPos_Or_DSLength <> *Blanks and                             //0020
               IspecToPos  > 0;                                                          //0020
                                                                                         //0020
               DSForDataStruct.Length =%char(IspecToPos);                                //0020
      EndSl;                                                                             //0020
      //Add decimal point after the length                                               //0020
      If wkPromptTyp<>'DS' and DSForDataStruct.Length <> *Blanks AND                     //0020
         chkISpecDsV3.decimalPosition <> *Blanks;                                        //0020
                                                                                         //0020
         DSForDataStruct.Length = %trim(DSForDataStruct.Length) + ':' +                  //0020
                                    %trim(chkISpecDsV3.decimalPosition);                 //0020
      EndIf;                                                                             //0020
                                                                                         //0020
      //d- Move data type to O/P DS                                                      //0020
      If wkPromptTyp <> 'DS';                                                            //0020
         Select;                                                                         //0020
            When chkISpecDsV3.FieldType = 'B';                                           //0020
               DSForDataStruct.DataType = 'B';                                           //0020
                                                                                         //0020
            when chkISpecDsV3.FieldType = 'P' or chkISpecDsV3.decimalPosition<>*Blanks;  //0020
                  DSForDataStruct.DataType = 'P';                                        //0020
                                                                                         //0020
            When chkISpecDsV3.FromPos_Or_OccursDs <> *Blanks and                         //0020
                  chkISpecDsV3.ToPos_Or_DSLength <> *Blanks;                             //0020
                  DSForDataStruct.DataType = 'A';                                        //0020
                                                                                         //0020
         EndSl;                                                                          //0020
      EndIf;                                                                             //0020
                                                                                         //0020
      //e- Move external file                                                            //0020
      If wkPromptTyp = 'DS' and ChkISpecDsV3.ActualField_Or_ExtFileName<>*Blanks;        //0020
         DSForDataStruct.ExtFileInit=ChkISpecDsV3.ActualField_Or_ExtFileName;            //0020
      EndIf;                                                                             //0020
                                                                                         //0020
      //f- Move initial values                                                           //0028
      If wkPromptTyp = 'SV';                                                             //0028
         DSForDataStruct.ExtFileInit=ChkISpecDsV3.Initial_Or_ConstValue;                 //0028
      EndIf;                                                                             //0028
                                                                                         //0028
   EndSr;                                                                                //0020
                                                                                         //0020
//------------------------------------------------------------------------------------- //0020
//MoveValuesForConstant - Move values for constant declarations                          //0020
//------------------------------------------------------------------------------------- //0020
   Begsr MoveValuesForConstantAndPrint;                                                  //0020
                                                                                         //0020
      //a- Move constant name to o/p DS                                                  //0020
      DSForConstant.ConstantName = ChkISpecDsV3.Actual_Or_RenamedField;                  //0020
                                                                                         //0020
      //b - Move current constant value to array                                         //0020
      wkISpecConstValArrCnt +=1;                                                         //0020
      wkISpecConstValArr(wkISpecConstValArrCnt) =                                        //0020
                     ChkISpecDsV3.Initial_Or_ConstValue;                                 //0020
                                                                                         //0020
      //d-Write the header for constant (same header as of record format)                //0020
      If wkDclTyp <> 'FN';
                                                                                         //0020
         //Print a blank line first                                                      //0020
         wkPseudoCode = *Blanks;                                                         //0020
         Exsr WriteISpecPseudocode;                                                      //0020
                                                                                         //0020
         //Print header for record format                                                //0020
         For wkIdx = 1 to %Elem(DSIspecConstantHdr);                                     //0020
               If DSIspecConstantHdr(wkIdx) <> *Blanks;                                  //0020
                  wkPseudoCode = DSIspecConstantHdr(wkIdx);                              //0020
                  Exsr WriteISpecPseudocode;                                             //0020
               Else;                                                                     //0020
                  Leave;                                                                 //0020
               EndIf;                                                                    //0020
         EndFor;                                                                         //0020
                                                                                         //0020
      EndIf;                                                                             //0020
      //e-Write all values one by one (clear name & type after first value)              //0020
      For wkIdx = 1 to wkISpecConstValArrCnt;                                            //0020
         DSForConstant.InitValue = wkISpecConstValArr(wkIdx);                            //0020
         If wkIdx < wkISpecConstValArrCnt;                                               //0020
            DSForConstant.InitValue = %trimr(DSForConstant.InitValue) + '+';             //0020
         EndIf;                                                                          //0020
         wkPseudoCode = DSForConstant;                                                   //0020
         Exsr WriteISpecPseudocode;                                                      //0020
         //Clear variable name and type for next row continuation                        //0020
         If wkIdx = 1;                                                                   //0020
            Clear DSForConstant.ConstantName;                                            //0020
         EndIf;                                                                          //0020
                                                                                         //0020
      EndFor;                                                                            //0020
                                                                                         //0020
      //f-Clear the array and counter                                                    //0020
      Clear wkISpecConstValArrCnt;                                                       //0020
      Clear wkISpecConstValArr;                                                          //0020
      wkDclTyp = 'FN';                                                                   //0020
                                                                                         //0020
   EndSr;                                                                                //0020

//------------------------------------------------------------------------------------- //
//WriteISpecPseudocode - Subroutine to write I Spec Pseudocode                          //
//------------------------------------------------------------------------------------- //
   Begsr WriteISpecPseudocode;
      OutParmWriteSrcDocDS.dsPseudocode = wkPseudocode;                                  //0006
      ioParmPointer  = %Addr(OutParmWriteSrcDocDS);
      WritePseudoCode(ioParmPointer);
   Endsr;

/copy 'QCPYSRC/iaprcerlog.rpgleinc'
End-Proc;

//--------------------------------------------------------------------------------------//0030
//Procedure to Write commented text                                                     //0030
//--------------------------------------------------------------------------------------//0030
Dcl-Proc Rpg3WriteCommentedText Export;                                                  //0030

  Dcl-Pi Rpg3WriteCommentedText;                                                         //0030
     inParmPointer Pointer;                                                              //0030
  End-Pi;                                                                                //0030

  // Declaration of input datastructure                                                 //0030
  Dcl-Ds inParmDS  Qualified Based(inParmPointer);                                       //0030
     dsReqId        Char(18);                                                            //0030
     dsSrcLib       Char(10);                                                            //0030
     dsSrcPf        Char(10);                                                            //0030
     dsSrcMbr       Char(10);                                                            //0030
     dssrcType      Char(10);                                                            //0030
     dsSrcRrn       Packed(6:0);                                                         //0030
     dsSrcSeq       Packed(6:2);                                                         //0030
     dsSrcLtyp      Char(5);                                                             //0030
     dsSrcSpec      Char(1);                                                             //0030
     dsSrcLnct      Char(1);                                                             //0030
     dsSrcDta       VarChar(cwSrcLength);                                                //0030
     IOIndentParmPointer Pointer;                                                        //0038
     dsDclType      Char(10);                                                            //0030
     dsSubType      Char(10);                                                            //0030
     dsbCmtReqd     Char(1);                                                             //0030
     dsSkipNxtStm   ind;                                                                 //0030
     dsFileNames    char(10) dim(99);                                                    //0030
     dsFileCount    zoned(2:0);                                                          //0030
     dsDocSeq       packed(6:0);                                                         //0030
     dsVarAry       Char(6) dim(9999);                                                   //0030
     dsVarCount     zoned(4:0);                                                          //0030
     dsIfCount      zoned(4:0);                                                          //0030
     dsSkipParm     ind;                                                                 //0030
  End-Ds;                                                                                //0030

  Dcl-Ds DsSrcDataForBlankCheck;                                                         //0030
     wkSrcDataForBlankCheckArr  Char(1) Dim(110);                                        //0030
  End-Ds;                                                                                //0030

  Dcl-Ds wkRPGIndentParmDS  LikeDs(RPGIndentParmDSTmp);                                  //0038
  Dcl-Ds wkOutParmWriteSrcDocDS LikeDs(OutParmWriteSrcDocDS)                             //0038
                                Based(wkRPGIndentParmDS.dsSrcDtlDSPointer);              //0038

  Dcl-C  cwMaxNoOfCharToPrint         109 ;                                              //0030

  Dcl-S  wkIdx                Packed(6:0)          Inz;                                  //0030
  Dcl-S  wkMaxDataToWrite     Char(109)            Inz;                                  //0030
  Dcl-S  wkIndentParmPointer  Pointer              Inz;                                  //0038

  Dcl-S  wkSrcDta             VarChar(cwSrcLength) Inz;                                  //0030
  Dcl-S  wkSrcDta2            VarChar(cwSrcLength) Inz;                                  //0030
                                                                                         //0030
  IndentParmPointer   = inParmDS.IOIndentParmPointer;                                    //0038
  Eval-Corr wkRPGIndentParmDS  = RPGIndentParmDS;                                        //0038
  wkSrcDta = inParmDs.dsSrcDta;                                                          //0030
  Eval-Corr OutParmWriteSrcDocDS = inParmDs;                                             //0030

  //Remove '*' from the commented text while writing.                                   //0030
  wkIdx = %scan('*' : wkSrcDta : 7);                                                     //0030
  If wkIdx <> 0;                                                                         //0030
     wkSrcDta = '--' + %trim(%subst(wkSrcDta : wkIdx+1));                                //0030
  Else;                                                                                  //0030
     wkSrcDta = '--' + %trim(wkSrcDta);                                                  //0030
  EndIf;                                                                                 //0030

  //Include Indentation & pipes                                                         //0030
  wkRPGIndentParmDs.dsIndentType = *Blanks ;                                             //0038
  wkRPGIndentParmDs.dsPseudocode = wkSrcDta;                                             //0038
  wkIndentParmPointer = %Addr(wkRPGIndentParmDs);                                        //0038
  IndentRPGPseudoCode(wkIndentParmPointer);                                              //0038
  wkSrcDta  = wkRPGIndentParmDs.dsPseudocode;                                            //0038
                                                                                         //0030
  //Write to document                                                                   //0030
  If %len(%trimr(wkSrcDta)) <= cwMaxNoOfCharToPrint;                                     //0030
     Exsr WriteTextToFile;                                                               //0030
  Else;                                                                                  //0030
     wkSrcDta = %trim(wkSrcDta);                                                         //0030
     Dow wkSrcDta <> *Blanks;                                                            //0030
        // Include Indentation & pipes                                                   //0030
        wkRPGIndentParmDs.dsIndentType = *Blanks ;                                       //0038
        wkRPGIndentParmDs.dsPseudocode = wkMaxDataToWrite;                               //0038
        wkIndentParmPointer = %Addr(wkRPGIndentParmDs);                                  //0038
        IndentRPGPseudoCode(wkIndentParmPointer);                                        //0038
        wkSrcDta  = wkRPGIndentParmDs.dsPseudocode;                                      //0038

        DsSrcDataForBlankCheck = %trim(wkSrcDta);                                        //0030

        // Start checking from 110th position backwards to find blank, wherever          //0030
        // blank position will be found Pseudo-code will be broke from there             //0030
        For wkIdx = cwMaxNoOfCharToPrint + 1 DownTo 1;                                   //0030
           If wkSrcDataForBlankCheckArr(wkIdx)=' ';                                      //0030
              Leave;                                                                     //0030
           EndIf;                                                                        //0030
        EndFor;                                                                          //0030

        // Exception handling.                                                           //0030
        If wkIdx = 0 Or %subst(wkSrcDta : 1 : wkIdx) = *Blanks;                          //0030
           wkIdx = cwMaxNoOfCharToPrint;                                                 //0030
        EndIf;                                                                           //0030

        //Move the data which can be printed to wkMaxDataToWrite                         //0030
        wkMaxDataToWrite = %trimr(%subst(wkSrcDta : 1 : wkIdx));                         //0030

        //Exception handling                                                             //0030
        If %Check(' |' : wkMaxDataToWrite) =0;                                           //0030
           Leave;                                                                        //0030
        EndIf;                                                                           //0030
        //Take backup of source data                                                     //0030
        wkSrcDta2 = wkSrcDta;                                                            //0030
        //Move the data to be printed to wkSrcDta and write the data                     //0030
        wkSrcDta = wkMaxDataToWrite;                                                     //0030
        Exsr WriteTextToFile;                                                            //0030

        //Move the remaining part back to wkSrcDta                                       //0030
        Clear wkSrcDta;                                                                  //0030
        wkSrcDta = %trim(%subst(wkSrcDta2 : wkIdx+1));                                   //0030

      EndDo;                                                                             //0030
   EndIf;                                                                                //0030

//------------------------------------------------------------------------------------- //0030
//WriteTextToFile - Subroutine to write pseudocode to temporary file IAPSEUDOWK         //0030
//------------------------------------------------------------------------------------- //0030
   Begsr WriteTextToFile;                                                                //0030
      inParmDS.dsDocSeq = inParmDS.dsDocSeq + 1;                                         //0030
      //Write the Pseudo code                                                           //0030
      exec sql                                                                           //0030
         insert into IAPSEUDOWK (wkReqId,                                                //0030
                                 wkMbrLib,                                               //0030
                                 wkSrcFile,                                              //0030
                                 wkMbrNam,                                               //0030
                                 wkMbrTyp,                                               //0030
                                 wkSrcRrn,                                               //0030
                                 wkSrcSeq,                                               //0030
                                 wkSrcLTyp,                                              //0030
                                 wkSrcSpec,                                              //0030
                                 wkDocSeq,                                               //0030
                                 wkGenPsCde,                                             //0030
                                 wkFontCode)                                             //0030
                  values ( :inParmDs.dsReqID,                                            //0030
                           :inParmDs.dsSrcLib,                                           //0030
                           :inParmDs.dsSrcPf,                                            //0030
                           :inParmDs.dsSrcMbr,                                           //0030
                           :inParmDs.dssrcType,                                          //0030
                           :inParmDs.dsSrcRrn,                                           //0030
                           :inParmDs.dsSrcSeq ,                                          //0030
                           :inParmDs.dsSrcLtyp,                                          //0030
                           :inParmDs.dsSrcSpec,                                          //0030
                           :inParmDs.dsDocSeq,                                           //0030
                           :wkSrcDta,                                                    //0030
                           ' ');                                                         //0030
                                                                                         //0030
      If SqlCode < SuccessCode;                                                          //0030
         uDpsds.wkQuery_Name = 'Rpg3WriteCommentedText_Insert_IAPSEUDOWK';               //0030
         IaSqlDiagnostic(uDpsds);                                                        //0030
      EndIf;                                                                             //0030
   Endsr ;                                                                               //0030
                                                                                         //0030
End-Proc Rpg3WriteCommentedText;                                                         //0030
//------------------------------------------------------------------------------------- //0036
//GetRPG3Mapping: Get the mapping data from the data structure storing IAPSEUDOMP       //0036
//                data                                                                  //0036
//------------------------------------------------------------------------------------- //0036
Dcl-Proc GetRPG3Mapping;                                                                 //0036

  Dcl-Pi GetRPG3Mapping     Ind;                                                         //0036
  End-Pi;                                                                                //0036

  //Copybook declaration                                                                //0036
/copy 'QCPYSRC/iaprderlog.rpgleinc'

  Dcl-S  wkMappingFoundInd     Ind             Inz;                                      //0036
  Dcl-S  wkiAKeyFld1           Like(wkDclType) Inz;                                      //0036

  wkMappingFoundInd = *Off;                                                              //0036
  Clear DsMappingOutData;                                                                //0036
  wkiAKeyFld1 = %Xlate(cwLo : cwUp : wkDclType);                                         //0036
  wkMapIdx = %Lookup(wkSrcLtyp3 + wkSrcSpec3 + wkiAKeyFld1 + WkMpIakeyfield2 :           //0036
                    iAPSeudoMpDs(*).Key : 1 : wkiAPseudoMpCount);                        //0036
  If  wkMapIdx > 0;                                                                      //0036
      wkkeyFld2     =  iAPSeudoMpDs(wkMapIdx).iAKeyFld2   ;                              //0036
      wkkeyFld3     =  iAPSeudoMpDs(wkMapIdx).iAKeyFld3   ;                              //0036
      wkkeyFld4     =  iAPSeudoMpDs(wkMapIdx).iAKeyFld4   ;                              //0036
      wkIndentType3 =  iAPSeudoMpDs(wkMapIdx).iAIndntTy   ;                              //0036
      wkSubsChr     =  iAPSeudoMpDs(wkMapIdx).iASubSChr   ;                              //0036
      wkActionType  =  iAPSeudoMpDs(wkMapIdx).iAActType   ;                              //0036
      wkSrcMapOut   =  iAPSeudoMpDs(wkMapIdx).iASrcMap    ;                              //0036
      wkSearchFld1  =  iAPSeudoMpDs(wkMapIdx).iASrhFld1   ;                              //0036
      wkSearchFld2  =  iAPSeudoMpDs(wkMapIdx).iASrhFld2   ;                              //0036
      wkSearchFld3  =  iAPSeudoMpDs(wkMapIdx).iASrhFld3   ;                              //0036
      wkSearchFld4  =  iAPSeudoMpDs(wkMapIdx).iASrhFld4   ;                              //0036
      wkCommentDesc =  iAPSeudoMpDs(wkMapIdx).iACmtDesc   ;                              //0036
      wkMappingFoundInd = *On;                                                           //0036
  EndIf;                                                                                 //0036

  Return wkMappingFoundInd;                                                              //0036

  //Copy book Declaration for error handling                                            //0036
/copy 'QCPYSRC/iaprcerlog.rpgleinc'
End-Proc GetRPG3Mapping;                                                                 //0036

Dcl-Proc GetRPG3SpecsToInclude   Export;                                                 //0039
   Dcl-pi *N char(1) dim(10);                                                            //0039
      inInclDeclSpecs    Char(1);                                                        //0042
   End-pi;                                                                               //0039
                                                                                         //0039
   Dcl-C AllSpecs             'ALLSPECS';                                                //0042
   Dcl-C MainSpecs            'MAINSPECS';                                               //0042
                                                                                         //0042
   Dcl-s wkIdx                packed(3:0);                                               //0039
   Dcl-s wkRpg3InclusiveArray char(1) dim(10);                                           //0039
   Dcl-S wkIncludedSpecs      char(200);                                                 //0039
   Dcl-S wkStartPos           packed(3:0) inz(1);                                        //0039
   Dcl-S wkCommaPos           packed(3:0);                                               //0039
   Dcl-S wkIncludedSpec       char(1);                                                   //0039
   Dcl-S wkKeyword            Char(10);                                                  //0042
                                                                                         //0039
   If inInclDeclSpecs  = 'Y';                                                            //0042
      WkKeyWord  =  AllSpecs;                                                            //0042
   Else;                                                                                 //0042
      WkKeyWord  =  MainSpecs;                                                           //0042
   Endif;                                                                                //0042
                                                                                         //0042
   Exec Sql                                                                              //0039
     Select IASRCMAP into :wkIncludedSpecs                                               //0039
     from IAPSEUDOKP  where                                                              //0039
     IASRCMTYP = 'RPG' and IASRCLTYP ='FX3' and IAKWDOPC = :WkKeyWord                    //0042
     limit 1;                                                                            //0039
                                                                                         //0039
   wkCommaPos = %scan(',' : wkIncludedSpecs : wkStartPos);                               //0039
   Dow wkCommaPos <> 0;                                                                  //0039
      wkIncludedSpec = %subst(wkIncludedSpecs : wkStartPos                               //0039
                                              : wkCommaPos - wkStartPos);                //0039
      wkIdx += 1;                                                                        //0039
      wkRpg3InclusiveArray(wkIdx) = wkIncludedSpec;                                      //0039
      wkStartPos = wkCommaPos + 1;                                                       //0039
      wkCommaPos = %scan(',' : wkIncludedSpecs : wkCommaPos + 1);                        //0039
      If wkCommaPos = 0;                                                                 //0039
         wkIncludedSpec = %subst(wkIncludedSpecs : wkStartPos);                          //0039
         wkIdx += 1;                                                                     //0039
         wkRpg3InclusiveArray(wkIdx) = wkIncludedSpec;                                   //0039
      Endif;                                                                             //0039
   Enddo;                                                                                //0039
                                                                                         //0039
   return wkRpg3InclusiveArray;                                                          //0039
End-proc;                                                                                //0039
