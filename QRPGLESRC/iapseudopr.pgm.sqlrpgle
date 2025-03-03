**Free
      //%METADATA                                                      *
      // %TEXT IA Pseudocode generation processing for RPG             *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------- //
//Created By  : Programmers.io @ 2024                                                   //
//Created Date: 2024/01/01                                                              //
//Developer   : Programmers.io                                                          //
//Description : This program generate Pseudocode for Rpgle                              //
//                                                                                      //
//Procedure Log:                                                                        //
//------------------------------------------------------------------------------------- //
//Procedure Name           | Procedure Description                                      //
//-------------------------|----------------------------------------------------------- //
//GenerateRpgPseudoCode    | Generate PseudoCode for RPG,RPGLE,SQLRPG,SQLRPGLE sources  //
//FetchRecordsFromCursor   | Fetch records from FetchSourceDetailFromiAQRpgSrc cursor   //
//GetRPGLESpecstoInclude   | Get the List of Specification For Pseudo Code Generation   //
//                         | From IAPSEUDOKP File.                                      //
//------------------------------------------------------------------------------------- //
//                                                                                      //
//Modification Log:                                                                     //
//------------------------------------------------------------------------------------- //
//Date-DMY| Mod_Id | Developer  | Case and Description                                  //
//--------|--------|------------|------------------------------------------------------ //
//07/05/24| 0003   | Khushi     | Task 621 - Populating the glossary section            //
//07/05/24| 0004   | Azhar Uddin| Task#619 - Added the logic to skip the next non-comme-//
//        |        |            |            nted statement (Actually DOx statement     //
//        |        |            |            considered with READx operation)           //
//10/05/24| 0005   | Prabhu S   | Task#660 - FFC source data clean up - mod tag(pos 1-6)//
//        |        |            |            and comments removal                       //
//15/05/24| 0006   | Sarthak    | Task#631 - Long Name for D and P spec Improvement     //
//15/05/24| 0007   | Sarthak    | Task#631 - Modified Fixed Format Line Cont Proc.      //
//16/05/24| 0008   | Manav T.   | Task#617 - Update IADWNDTLP file status instead of    //
//        |        |            |            IADWNREQ file status. Parameters to        //
//        |        |            |            iARequestStatusUpdate are added.           //
//21/05/24| 0009   | Santosh    | Task#665 - Bug in Pseudocode Generation for Variable  //
//        |        |            |            Declaration.                               //
//18/06/24| 0010   | Azhar Uddin| Task#728 - Included the handling to retrieve source   //
//        |        |            |            rrn for main logic ending line from        //
//        |        |            |            IAQRPGSRC to print statement for ending    //
//        |        |            |            main logic.                                //
//27/06/24| 0011   | Azhar Uddin| Task#677 - Included the handling to load the mapping  //
//        |        |            |            of IAPSEUDOMP in DS in the beginning to    //
//        |        |            |            avoid multiple i/o from file.              //
//04/07/24| 0012   | Vamsi      | Rename Bnddir AIERRBND, copybooks AICERRLOG/AIDERRLOG //
//        |        |            | and procedures AISQLDIAGNOSTIC and AIPSSRERRORLOG     //
//        |        |            | with IA*  [Task#261]                                  //
//10/07/24| 0013   | Manju      | Task#779 - Hspec for Multi-line Free format Fixed     //
//        |        |            |            and Calculate length has been Increased    //
//        |        |            |            from 2 Packed to 3 to Hold more than 99.   //
//03/07/24| 0014   | Azhar Uddin| Task#752 - Modified the i/o parameters to pass        //
//        |        |            |            indentation related parameters in DS       //
//07/08/24| 0015   | Azhar Uddin| Task#756(4)-Use order by clause to pick the source    //
//        |        |            |             data in correct RRN order.                //
//13/08/24| 0016   | Shefali    | Task#798 - Load C spec data from IAPSEUDOKP into      //
//        |        |            |            array for correct opcode mapping           //
//26/08/24| 0017   | Manju      | Task#884 - Load K spec Header only for /COPY and      //
//        |        |            |            /INCLUDE Compiler Directives               //
//20/09/24| 0018   | Azhar Uddin| Task#956 - Added new handling to parse I spec data    //
//        |        |            |            for fixed format.                          //
//13/09/24| 0019   | Manju      | Task#923 - Handled Copybook Header issue, When prev   //
//        |        |            |            Kspec line is Not /Include or /copy but    //
//        |        |            |            Next Kspec line was /Include or /copy.     //
//30/05/24| 0020   | Azhar Uddin| Task#689 - Modified to write the commented text based //
//        |        |            |            on new input parameter flag value          //
//03/10/24| 0021   | Manju      | Task#977 - Clear wksrcdta to avoid appending with next//
//        |        |            |            statement causing incorrect results.       //
//25/09/24| 0022   | Manju      | Task#959 - Dont Merge next line if MutilineConditional//
//        |        |            |            Indicator is found in FixedFormat without  //
//        |        |            |            Opcode.                                    //
//27/09/24| 0023   | SriniG     | Following tasks are done on TASK# 968                 //
//        |        |            | 1. File declaration is not translated correctly       //
//        |        |            |    in mixd format pseudocode generation.              //
//        |        |            | 2. Multiple lines of code are missed and Incorrect    //
//        |        |            |    RRN in mixd format pseudocode generation.          //
//13/12/24| 0024   | S Karthick | Pseudo code generation based on configured in Table   //
//        |        |            | IAPSEUDOKP For both Fixed/Mixed Free format RPGLE src //
//        |        |            | Added logic to skip specifications in procedures      //
//06/01/25| 0025   | HIMANSHUGA | Based on i/p flag determine what config wil be used   //
//        |        |            | from KP file to print or not print declaration specs  //
//------------------------------------------------------------------------------------- //
Ctl-Opt CopyRight('Copyright @ Programmers.io © 2024');
Ctl-Opt Option(*NoDebugIo:*SrcStmt:*NoUnRef);
Ctl-Opt BndDir('IABNDDIR' : 'IAERRBND');                                                 //0012

//------------------------------------------------------------------------------------- //
//Constant Variables                                                                    //
//------------------------------------------------------------------------------------- //
Dcl-C cwTrue         '1';
Dcl-C cwFalse        '0';
Dcl-C cwFxExecSql    Const('C/EXEC SQL');
Dcl-C cwFxEndExec    Const('C/END-EXEC');
Dcl-C cwFrExecSql    Const('EXEC SQL');
Dcl-C cwUp           'ABCDEFGHIFKLMNOPQRSTUVWXYZ';
Dcl-C cwLo           'abcdefghijklmnopqrstuvwxyz';
Dcl-C cwSrcLength    4046;
Dcl-C cwDInits       '     D';
Dcl-C cwPInits       '     P';
Dcl-C cwF            'F' ;
Dcl-C cwD            'D' ;
Dcl-C cwA            'A' ;                                                               //0011
Dcl-C cwC            'C' ;                                                               //0016

Dcl-C ExcludeProcSpecs   'EXPROCSPEC';                                                   //0024
Dcl-C MainSpecs          'MAINSPECS';                                                    //0024
Dcl-C AllSpecs           'ALLSPECS';                                                     //0025
Dcl-C SrcLineType        'FX4';                                                          //0024
//------------------------------------------------------------------------------------- //
//Standalone Variables                                                                  //
//------------------------------------------------------------------------------------- //
Dcl-S wkDName        Char(50)              Inz;
Dcl-S WkSpec         Char(1)               Inz;
Dcl-S WkFrSpec       Char(5)               Inz('FFC');
Dcl-S WkFxSpec       Char(5)               Inz('FX4');                                   //0016
Dcl-S uwSpecKwd      Char(10)              Inz;                                          //0024
Dcl-S urInclSpecArr  Char(1)               Dim(10);                                      //0024
Dcl-S urExclSpecArr  Char(1)               Dim(10);                                      //0024
Dcl-S wkInclDeclSpec Char(1)               Inz;                                          //0025

Dcl-S wkSrcDta       VarChar(cwSrcLength)  Inz;
Dcl-S wkSrcDta2      VarChar(cwSrcLength)  Inz;

Dcl-S rowsFetched    Uns(5)                Inz;
Dcl-S MaxRows        Uns(5)                Inz;
Dcl-S iAqRpgIdx1     Uns(5)                Inz;
Dcl-S iAqRpgIdx2     Uns(5)                Inz;

Dcl-S RcdFound       Ind                   Inz;
Dcl-S RowFound       Ind                   Inz('0');
Dcl-S wkHSpecHdrInd  Ind                   Inz('0');
Dcl-S wkFSpecHdrInd  Ind                   Inz('0');
Dcl-S WkIterFlag     Ind                   Inz('0');
Dcl-S wkGlossaryInd  Ind                   Inz('0');                                     //0003
Dcl-S wkKSpecHdrInd  Ind                   Inz('1');                                     //0019
Dcl-S wkWriteCmntInd Ind                   Inz('0');                                     //0020
Dcl-S uwProcFlg      Ind                   Inz('0');                                     //0024

Dcl-S ioParmPointer  Pointer               Inz(*Null);

Dcl-S wkScanpos      Packed(5:0)           Inz;                                          //0013
Dcl-S wkStrPos       Packed(5:0)           Inz;                                          //0013
Dcl-S wkEndPos       Packed(5:0)           Inz;                                          //0013
Dcl-S wkSubstLen     Packed(5:0)           Inz;                                          //0013
Dcl-S wk3DotPos      Packed(5:0)           Inz;                                          //0013
//------------------------------------------------------------------------------------- //
//Datastructure Definitions                                                             //
//------------------------------------------------------------------------------------- //
//Datastructure array to hold the cursor data
Dcl-Ds iAQRpgSrcArr Qualified Dim(999);
   dsSrcRrn  Packed(6:0);
   dsSrcSeq  Packed(6:2);
   dsSrcLtyp Char(5);
   dsSrcSpec Char(1);
   dsSrcLnct Char(1);
   dsSrcDta  Varchar(cwSrcLength);
End-Ds;

//Datastructure to save the previous process data
Dcl-Ds iAQRpgSrcPrv Qualified;
   dsSrcRrn  Packed(6:0);
   dsSrcSeq  Packed(6:2);
   dsSrcLtyp Char(5);
   dsSrcSpec Char(1);
   dsSrcLnct Char(1);
   dsSrcDta  Varchar(cwSrcLength);
End-Ds;

Dcl-Ds PrvSavedLineDs likeds(iAQRpgSrcPrv) inz;                                          //0007

//Datastructure to hold the data to pass as parameter
Dcl-Ds DsParmRpgSrc ;
   dsReqId       Char(18);
   dsLibNam      Char(10);
   dsSrcNam      Char(10);
   dsMbrNam      Char(10);
   dsMbrTyp      Char(10);
   dsSrcRrn      Packed(6:0);
   dsSrcSeq      Packed(6:2);
   dsSrcLtyp     Char(5);
   dsSrcSpec     Char(1);
   dsSrcLnct     Char(1);
   dsSrcDta      VarChar(cwSrcLength);
   dsIOIndentParmPointer Pointer;                                                        //0014
   dsDclType     Char(10);
   dsSubType     Char(10);
   dsHCmtReqd    Char(1);
   dsSkipNxtStm  ind;                                                                    //0004
   dsFileNames   char(10) dim(99);                                                       //0004
   dsFileCount   zoned(2:0);                                                             //0004
   dsName        Char(50);                                                               //0006
End-Ds;
                                                                                         //0007
Dcl-Ds PrvParmDataDs likeds(DsParmRpgSrc);                                               //0007

//Datastructure to hold the data to pass as parameter
Dcl-Ds dsParmHeader Qualified;
   dsReqId   Char(18);
   dsLibNam  Char(10);
   dsSrcNam  Char(10);
   dsMbrNam  Char(10);
   dsMbrTyp  Char(10);
   dsSrcSpec Char(1);
   dsKeyFld  Char(10);
End-Ds;

//Data Structure to fetch the source without comments in Fixed format
Dcl-Ds SourceDataDs qualified;
   Data           Char(200)  Pos(1);                                                     //0023
   NonBlankData   Char(192)  Pos(7);                                                     //0023
End-Ds;
//Data Structure for indent data                                                        //0014
Dcl-Ds RPGIndentParmDs LikeDS(RPGIndentParmDsTmp);                                       //0014

//------------------------------------------------------------------------------------- //
//Prototype Definitions                                                                 //
//------------------------------------------------------------------------------------- //

//------------------------------------------------------------------------------------- //
//Copybook definitions                                                                  //
//------------------------------------------------------------------------------------- //
/copy 'QCPYSRC/iaderrlog.rpgleinc'
/copy 'QMODSRC/iapcod01pr.rpgleinc'
/copy 'QMODSRC/iasrv01pr.rpgleinc'
/copy 'QCPYSRC/rpgivds.rpgleinc'

//------------------------------------------------------------------------------------- //
//Entry Parameter Declarations                                                          //
//------------------------------------------------------------------------------------- //
Dcl-Pr iAPseudoPr Extpgm('IAPSEUDOPR');
   *N       Char(18);
   *N       Char(10);
   *N       Char(10);
   *N       Char(10);
   *N       Char(10);
   *N       Char(1)   options(*nopass);                                                  //0020
   *N       Char(1)   options(*nopass);                                                  //0025
End-Pr;

Dcl-Pi iAPseudoPr ;
   inReqId  Char(18);
   inLibNam Char(10);
   inSrcNam Char(10);
   inMbrNam Char(10);
   inMbrTyp Char(10);
   inAddComment  Char(1)   options(*nopass);                                             //0020
   inInclDeclSpec Char(1)  options(*nopass);                                             //0025
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

//------------------------------------------------------------------------------------- //
//Cursor Declarations                                                                   //
//------------------------------------------------------------------------------------- //
//Cursor to process
Exec Sql
  Declare FetchSourceDetailFromiAQRpgSrc No Scroll Cursor For
     Select XSrcRrn,
            XSrcSeq,
            XSrcLtyp,
            XSrcSpec,
            XSrcLnct,
            XSrcDta
       From iAQRpgSrc
      Where XLibNam   = :inLibNam And
            XSrcNam   = :inSrcNam And
            XMbrNam   = :inMbrNam And
            XMbrTyp   = :inMbrTyp
      Order by XSrcSeq, XSrcRrn                                                          //0015
      For Fetch Only;

//------------------------------------------------------------------------------------- //
//Main Processing                                                                       //
//------------------------------------------------------------------------------------- //
Eval-Corr uDpsds = wkuDpsds;

//Check if commented text needs to be included in pseudo-code document                  //0020
wkWriteCmntInd= *Off;                                                                    //0020
If %parms > 5 and (inAddComment = 'Y' or inAddComment='y');                              //0020
   wkWriteCmntInd = *On;                                                                 //0020
EndIf;                                                                                   //0020

//Check if decl specs needs to be included in pseudo-code document                      //0025
wkInclDeclSpec = 'N';                                                                    //0025
If %Parms > 6 and (inInclDeclSpec = 'Y' Or inInclDeclSpec = 'y');                        //0025
   wkInclDeclSpec = 'Y';                                                                 //0025
EndIf;                                                                                   //0025
//Generate the RPG source documentation - PseudoCode
GenerateRpgPseudoCode();

*Inlr = *On;
Return;

/copy 'QCPYSRC/iacerrlog.rpgleinc'

//------------------------------------------------------------------------------------- //
//GenerateRpgPseudoCode: Generate PseudoCode for RPG, RPGLE, SQLRPG, & SQLRPGLE sources //
//------------------------------------------------------------------------------------- //
Dcl-Proc GenerateRpgPseudoCode;

  //CopyBook Declaration
/copy 'QCPYSRC/iaprderlog.rpgleinc'

  Eval-corr w_uDpsds = wkuDpsds;

  //Initialization Subroutine
  Exsr InitSr;

  //Open cursor
  Exec Sql Open FetchSourceDetailFromiAQRpgSrc;
  If SqlCode = CSR_OPN_COD;
     Exec Sql Close FetchSourceDetailFromiAQRpgSrc;
     Exec Sql Open  FetchSourceDetailFromiAQRpgSrc;
  EndIf;

  If SqlCode < successCode;
     uDpsds.wkQuery_Name = 'Open_iAQRpgSrc_FetchSourceDetailFromiAQRpgSrc';
     IaSqlDiagnostic(uDpsds);                                                            //0012
  EndIf;


  If SqlCode = successCode;

     //Get Number of Rows
     MaxRows  = %Elem(iAQRpgSrcArr);
     //Fetch records from FetchSourceDetailFromiAQRpgSrc cursor.
     rowFound = FetchRecordsFromCursor();
     wkGlossaryInd = rowFound;                                                           //0003

     Dow rowFound;

        For iAqRpgIdx1 = 1 To rowsFetched;

           WkIterFlag = *Off ;

           //Load the Parameter Data Structure
           dsSrcRrn   = iAQRpgSrcArr(iAqRpgIdx1).dsSrcRrn;
           dsSrcSeq   = iAQRpgSrcArr(iAqRpgIdx1).dsSrcSeq;
           dsSrcLtyp  = iAQRpgSrcArr(iAqRpgIdx1).dsSrcLtyp;
           dsSrcSpec  = iAQRpgSrcArr(iAqRpgIdx1).dsSrcSpec;
           dsSrcLnct  = iAQRpgSrcArr(iAqRpgIdx1).dsSrcLnct;
           dsSrcDta   = iAQRpgSrcArr(iAqRpgIdx1).dsSrcDta;

           //Turn On Indicator for all other spec except Kspec                          //0019
           If dsSrcSpec <> 'K';                                                          //0019
               wkKSpecHdrInd = *On;                                                      //0019
           EndIf;                                                                        //0019
                                                                                         //0019
           If uwProcFlg = *on and
              %lookup(dsSrcSpec:urExclSpecArr) >0;
              Iter;
           Endif;

           //Based on the line type call respective parsing procedure.
           Select ;

              When dsSrcLtyp = 'FX4'                                                     //0024
                   and %Lookup(dsSrcSpec:urInclSpecArr) > 0;                             //0024
                 SourceDataDs = iAQRpgSrcArr(iAqRpgIdx1).dsSrcDta;                       //0009
                 iAQRpgSrcArr(iAqRpgIdx1).dsSrcDta = SourceDataDs.Data;                  //0009
                 dsSrcDta = SourceDataDs.Data;                                           //0009
                                                                                         //0009
                 SourceDataDs = dsSrcDta ;
                 If SourceDataDs.NonBlankData <> *Blanks;
                    FixFormatLineCont();
                    If WkIterFlag = *On ;
                        Iter  ;
                    Endif ;

                    ParseFx4Src() ;
                 Endif;

              When dsSrcLtyp = 'FX3' ;
                 ParseFx3Src() ;

              When (dsSrcLtyp = 'FFC' or dsSrcLtyp = 'FFR')                              //0024
                   and %Lookup(dsSrcSpec:urInclSpecArr) > 0;                             //0024
                                                                                         //0009
                 //Skip the source line if it is **FREE,//FREE,//END-FREE,              //0009
                 ///FREE,/END-FREE                                                      //0009
                 SourceDataDs = %Xlate(cwLo:cwUp:dsSrcDta);                              //0009
                 if ((%Scan('**FREE':SourceDataDs.Data:1) > *Zeros and                   //0009
                      %Trim(SourceDataDs.Data) = '**FREE') or                            //0009
                     (%Scan('//FREE':SourceDataDs.Data:6) > *Zeros and                   //0009
                      %Trim(SourceDataDs.Data) = '//FREE') or                            //0009
                     (%Scan('//END-FREE':SourceDataDs.Data:6) > *Zeros and               //0009
                      %Trim(SourceDataDs.Data) = '//END-FREE') or                        //0009
                      %Trim(SourceDataDs.Data) = '/FREE' or                              //0009
                      %Trim(SourceDataDs.Data) = '/END-FREE');                           //0009
                         Iter;                                                           //0009
                 endif;                                                                  //0009

                    FreeFormatLineCont () ;
                    If WkIterFlag = *On or dsSrcDta=*Blanks;
                        Iter  ;
                    Endif ;

                 ParseFreeSrc() ;
                                                                                         //0020
              When %subst(dsSrcLtyp : 4 : 1) = 'T'                                       //0020
                   and wkWriteCmntInd = *On;                                             //0020

                 ioParmPointer =  %Addr(DsParmRpgSrc);                                   //0020
                 IaWriteCommentedText(ioParmPointer);                                    //0020
                                                                                         //0020
           EndSl;

           If WkIterFlag = *On ;
             Iter ;
           Endif ;

           iAQRpgSrcPrv = iAQRpgSrcArr(iAqRpgIdx1);
        EndFor ;

        //if fetched rows are less than the array elements then come out of the loop.
        If rowsFetched < MaxRows ;
           Leave;
        Endif;

        //Fetch records from FetchSourceDetailFromiAQRpgSrc cursor.
        rowFound = FetchRecordsFromCursor();

     EndDo;

     Exec Sql Close FetchSourceDetailFromiAQRpgSrc;

     If wkGlossaryInd = cwTrue;                                                          //0003
        ioParmPointer =  %Addr(dsParmHeader);                                            //0003
        WriteGlossary(ioParmPointer);                                                    //0003
     EndIf;                                                                              //0003

  Endif;

  //Update the request status in IAFDWNDTLP - export file                               //0008
  iARequestStatusUpdate(inReqId:inLibNam:inSrcNam                                        //0008
                                         :inMbrNam:inMbrTyp);                            //0008

  Return;

//------------------------------------------------------------------------------------- //
//InitSr : Initialization SubRoutine                                                    //
//------------------------------------------------------------------------------------- //
  BegSr InitSr;

    Clear DsParmRpgSrc;
    Clear RPGIndentParmDS;                                                               //0014
    dsIOIndentParmPointer = %addr(RPGIndentParmDS);                                      //0014
    dsReqId       =  inReqId;
    dsLibNam      =  inLibNam;
    dsSrcNam      =  inSrcNam;
    dsMbrNam      =  inMbrNam;
    dsMbrTyp      =  inMbrTyp;
    wkSrcDta      =  *Blanks;
    dshCmtReqd    =  'Y';
    dsSkipNxtStm  =  *Off;                                                               //0004
    dsFileNames   =  *Blanks;                                                            //0004
    dsFileCount   =  *Zeros;                                                             //0004

    dsParmHeader.dsReqId  = inReqId;
    dsParmHeader.dsLibNam = inLibNam;
    dsParmHeader.dsSrcNam = inSrcNam;
    dsParmHeader.dsMbrNam = inMbrNam;
    dsParmHeader.dsMbrTyp = inMbrTyp;
    dsParmHeader.dsKeyFld = ' ';

    //Write the heading for the source documentation
    ioParmPointer =  %Addr(dsParmHeader);
    WriteHeader(ioParmPointer);

    //Load F spec DS
    WkSpec  = cwF;
    GetSpecSrcMapping(WkFrSpec : WkSpec);

    //Load D spec DS
    WkSpec  = cwD;
    GetSpecSrcMapping(WkFrSpec : WkSpec);
                                                                                         //0016
    //Load C spec DS for Fixed format opcodes                                           //0016
    WkSpec  = cwC;                                                                       //0016
    GetSpecSrcMapping(WkFxSpec : WkSpec);                                                //0016

    //Load Fixed Format DataType Mapping
    LoadFixedDataTypeMap();

    //Load all mapping data from IAPSEUDOMP                                             //0011
    WkSpec  = cwA;                                                                       //0011
    GetSpecSrcMapping(WkFrSpec : WkSpec);                                                //0011

    //Load RRN of last executable line of main logic & text to be printed after main    //0010
    ioParmPointer =  %Addr(dsParmHeader);                                                //0010
    GetLastRrnOfMainLogic(ioParmPointer);                                                //0010
                                                                                         //0010
    //Load the list of specs to be included/excluded,applicable for RPGLE all source    //0024
    //line types and  Spec(d) exclude from Procedures.                                  //0024
    Clear urInclSpecArr;                                                                 //0024
    Clear urExclSpecArr;                                                                 //0024
    If wkInclDeclSpec  =  'Y';                                                           //0025
       uwSpecKwd       =  AllSpecs;                                                      //0025
    Else;                                                                                //0025
       //only selected specs
       uwSpecKwd       =  MainSpecs;                                                     //0025
    Endif;                                                                               //0025

    urInclSpecArr  =  GetRPGLESpecstoInclude(SrcLineType : uwSpecKwd);                   //0024

    //Get the list of Specification to Exclude from Procedure                           //0024
    If wkInclDeclSpec =  'N';                                                            //0025
       uwSpecKwd      =  ExcludeProcSpecs;                                               //0025
       urExclSpecArr  =  GetRPGLESpecstoInclude(SrcLineType : uwSpecKwd);                //0025
    Endif;

  EndSr;

/copy 'QCPYSRC/iaprcerlog.rpgleinc'

End-proc;

//------------------------------------------------------------------------------------- //
//Procedure fetchRecordsfromCursor : Fetch Records From FetchSourceDetailFromiAQRpgSrc  //
//------------------------------------------------------------------------------------- //
Dcl-Proc FetchRecordsFromCursor;

  Dcl-Pi FetchRecordsFromCursor Ind End-Pi;

  Dcl-S  rcdFound Ind Inz('0');
  Dcl-S  wkRowNum Uns(5);

  //CopyBook declaration
/copy 'QCPYSRC/iaprderlog.rpgleinc'

  eval-corr w_uDpsds = wkuDpsds;

  Clear iAQRpgSrcArr;
  //Fetch record
  Exec Sql
     Fetch FetchSourceDetailFromiAQRpgSrc For :MaxRows  Rows Into :iAQRpgSrcArr;

  //Retreive number of fetched rows
  If Sqlcode = successCode;
     Exec Sql Get Diagnostics
         :wkRowNum = ROW_COUNT;
     rowsFetched  = wkRowNum;
  Endif;

  //If no of fetched rows greater than zero then rerun true, else false
  If rowsFetched > 0;
     rcdFound = cwTrue;
  ElseIf Sqlcode < successCode;
     rcdFound = cwFalse;
  Endif;

  Return rcdFound;

/copy 'QCPYSRC/iaprcerlog.rpgleinc'

End-Proc;

//------------------------------------------------------------------------------------- //
//Procedure ParseFx4Src() : Parse RPGLE IV fix format source.                           //
//------------------------------------------------------------------------------------- //
Dcl-Proc ParseFx4Src;

  //CopyBook Declaration
/copy 'QCPYSRC/iaprderlog.rpgleinc'

  wkIterFlag = *Off ;
  Select;
     When dsSrcSpec = 'H' ;
        //Fixed format - Get the start position and end position
        wkStrPos = 7;
        wkEndPos = %Len(%TrimR(wkSrcDta)) + 1;
        iAHSpec() ;
        Return ;

     When dsSrcSpec = 'C' ;

        If %Scan(cwFxEndExec : %Xlate(cwLo:cwUp:%Trim(dsSrcDta))) = 1;
           dsSrcDta = wkSrcDta2;
           ioParmPointer = %Addr(DsParmRpgSrc);

           If iASqlPseudocodeParser(ioParmPointer);

           Endif;
           Clear wkSrcDta2;
           WkIterFlag = *On ;
           Return ;
        EndIf;

     When dsSrcSpec = 'F' ;       //Directly Goes to Parser
     When dsSrcSpec = 'D' ;       //Directly Goes to Parser                              //0006
     When dsSrcSpec = 'I' ;                                                              //0018
        ioParmPointer = %Addr(DsParmRpgSrc);                                             //0018
        IaFixedFormatISpecParser(ioParmPointer);                                         //0018
        Return ;
     When dsSrcSpec = 'P' ;       //Directly Goes to Parser
        //Flag is Turned on to Identify the Procedure is begin                          //0024
        if uwProcFlg = *off;                                                             //0024
          uwProcFlg = *on;                                                               //0024
        else;                                                                            //0024
          uwProcFlg = *off;                                                              //0024
        endif;                                                                           //0024

     When dsSrcSpec = 'O' ;       //To be started
        Return ;
     When dsSrcSpec = 'K' ;

        //Process header only /COPY and /INCLUDE directives                             //0019
        If  %Scan('/INCLUDE ': %Xlate(cwLo:cwUp:%Trim(dsSrcDta)):1) > *Zeros or          //0019
            %Scan('/COPY ': %Xlate(cwLo:cwUp:%Trim(dsSrcDta)):1)    > *Zeros ;           //0019
                                                                                         //0019
           //Don't print repeatative Copybook header lines                              //0019
           If wkKSpecHdrInd = *On ;                                                      //0019
              wkKSpecHdrInd = *Off;                                                      //0019
              dsParmHeader.dsSrcSpec = 'K';                                              //0019
              ioParmPointer =  %Addr(dsParmHeader);                                      //0019
              iAWriteSpecHeader(ioParmPointer);                                          //0019
           EndIf;                                                                        //0019
        EndIf;

        ioParmPointer =  %Addr(dsParmRpgSrc);
        iACopyBookDclParser(ioParmPointer : dsSrcDta);
        //Clear wksrcdta since returned to End-Proc and prvsrcdata merged in next line  //0021
        Clear wkSrcDta;                                                                  //0021
        Return ;
  EndSl;

  dsSrcDta = wksrcdta;
  ioParmPointer = %Addr(DsParmRpgSrc);

  // Process Fixed Fromat RPGLE Code Parser and write the Pseudocode in IAPSEUDOCP
  If iAFixedFormatParser(ioParmPointer);

  Endif;
  Clear wkSrcDta;
  Clear CSpecDsV4;
  Clear wkDName;
  Clear dsName;                                                                          //0006
  Clear PrvSavedLineDs;                                                                  //0007
/copy 'QCPYSRC/iaprcerlog.rpgleinc'

End-Proc;
//------------------------------------------------------------------------------------- //
//Procedure ParseFx3Src   : Parse RPG III fix format source.                            //
//------------------------------------------------------------------------------------- //
Dcl-Proc ParseFx3Src   ;

   //CopyBook Declaration
/copy 'QCPYSRC/iaprderlog.rpgleinc'

   Select ;
      When   dsSrcSpec = 'C' ;
      When   dsSrcSpec = 'H' ;
      When   dsSrcSpec = 'F' ;
      When   dsSrcSpec = 'E' ;
      When   dsSrcSpec = 'L' ;
      When   dsSrcSpec = 'I' ;
      When   dsSrcSpec = 'O' ;
   Endsl ;

/copy 'QCPYSRC/iaprcerlog.rpgleinc'

End-Proc;

//------------------------------------------------------------------------------------- //
//Procedure ParseFreeSrc() : Parse Fully Free Format or Free Format Column Based Source
//------------------------------------------------------------------------------------- //
Dcl-Proc ParseFreeSrc   ;

   //CopyBook Declaration
/copy 'QCPYSRC/iaprderlog.rpgleinc'

   Select ;
      When dsSrcSpec = 'H' ;
          wkSrcDta = %Trim(dsSrcDta);                                                    //0013
          // Free  format - Get the start position and end position
          wkStrPos = 8;
          wkEndPos  = %Scan(';' : wkSrcDta : 1 );
          iAHSpec() ;

      When dsSrcSpec = 'C' ;

         //Check for SQL Query
         If %Scan(cwFrExecSql : %Xlate(cwLo:cwUp:%Trim(dsSrcDta))) = 1;
            //Process Sql Query Code Parser and write the Pseudocode in IAPSEUDOCP
            If iASqlPseudocodeParser(ioParmPointer);

            EndIf;
         Else;

            //Process Free Fromat RPGLE Code Parser and write the Pseudocode in IAPSEUDOCP
            If iAFreeFormatPseudocodeParser(ioParmPointer);

            Endif;
         Endif;

      When dsSrcSpec = 'F';

          wkSrcDta = %Trim(iAQrpgSrcArr(iAqRpgIdx1).dsSrcDta);
           //Write the heading for H Spec
           If wkFSpecHdrInd = *Off;
              wkFSpecHdrInd = *On;
              dsParmHeader.dsSrcSpec = 'F';
              ioParmPointer = %Addr(dsParmHeader);
              iAWriteSpecHeader(ioParmPointer);
           EndIf;
           //Call F spec parser for FreeFormat RPG code
           ioParmPointer =  %Addr(dsParmRpgSrc);
           freeFormatFSpecParser(ioParmPointer);

      When dsSrcSpec = 'D' ;

         //Call D spec parser for Free Format
         ioParmPointer =  %Addr(dsParmRpgSrc);
         FreeFormatDSpecParser(ioParmPointer);

      When dsSrcSpec = 'P' ;
         ioParmPointer =  %Addr(dsParmRpgSrc);
         //Process Free Fromat RPGLE Code Parser and write the Pseudocode in IAPSEUDOCP
         If iAFreeFormatPseudocodeParser(ioParmPointer);

         Endif;

         if uwProcFlg = *off;                                                            //0024
           uwProcFlg = *on;                                                              //0024
         else;                                                                           //0024
           uwProcFlg = *off;                                                             //0024
         endif;                                                                          //0024

      When dsSrcSpec = 'K' ;

         //Process header only /COPY and /INCLUDE directives                            //0019
         If  %Scan('/INCLUDE ': %Xlate(cwLo:cwUp:%Trim(dsSrcDta)):1) > *Zeros or         //0019
             %Scan('/COPY ': %Xlate(cwLo:cwUp:%Trim(dsSrcDta)):1)    > *Zeros ;          //0019
                                                                                         //0019
            //Don't print repeatative Copybook header lines                             //0019
            If wkKSpecHdrInd = *On ;                                                     //0019
               wkKSpecHdrInd = *Off;                                                     //0019
               dsParmHeader.dsSrcSpec = 'K';                                             //0019
               ioParmPointer =  %Addr(dsParmHeader);                                     //0019
               iAWriteSpecHeader(ioParmPointer);                                         //0019
            EndIf;                                                                       //0019
         EndIf;

         ioParmPointer =  %Addr(dsParmRpgSrc);
         iACopyBookDclParser(ioParmPointer : dsSrcDta);

   Endsl ;
   Clear wkSrcDta;
/copy 'QCPYSRC/iaprcerlog.rpgleinc'

End-Proc;
//0001 Ends Here.
//------------------------------------------------------------------------------------- //
//iAHspec : Process H Specfication code
//------------------------------------------------------------------------------------- //
   Dcl-Proc iAHspec;

   //CopyBook Declaration
/copy 'QCPYSRC/iaprderlog.rpgleinc'

      //Write the heading for H spec
       If wkHSpecHdrInd = *Off;
          wkHSpecHdrInd = *On;
          dsParmHeader.dsSrcSpec = 'H';
          ioParmPointer = %Addr(dsParmHeader);
          iAWriteSpecHeader(ioParmPointer);
       EndIf;

      //Get the H Spec Data to parse
      wkSubstLen = wkEndPos - wkStrPos;
      If wkStrPos > *Zeros and wkEndPos > *Zeros And wkSubstLen > *Zeros;
         dsSrcDta   = *Blanks;
         dsSrcDta   =
            %Subst(wkSrcDta : wkStrPos : wkSubstLen);

         //Call the H spec Pseudocode procedure
         ioParmPointer =  %Addr(dsParmRpgSrc);
         iAHSpecPseudocodeParser(ioParmPointer);
      EndIf;

/copy 'QCPYSRC/iaprcerlog.rpgleinc'

   End-proc iAHspec;
//------------------------------------------------------------------------------------- //
//FreeFormatLineCont :  Procedure for Line continuation in free format
//------------------------------------------------------------------------------------- //
   Dcl-Proc FreeFormatLineCont ;

   //CopyBook Declaration
/copy 'QCPYSRC/iaprderlog.rpgleinc'

      //If Free Format Column (FFC), get the data between 7 to 80                        //0005
      If dsSrcLtyp  = 'FFC';                                                              //0005
         SourceDataDs = iAQRpgSrcArr(iAqRpgIdx1).dsSrcDta;                                //0005
         If SourceDataDs.NonBlankData <> *Blanks;                                         //0005
           iAQRpgSrcArr(iAqRpgIdx1).dsSrcDta = SourceDataDs.NonBlankData;                 //0005
         EndIf;                                                                           //0005
      EndIf;                                                                              //0005

      //If full free(FFR), change it to FFC as the IAPSEUDOMP is done with FFC
      If iAQRpgSrcArr(iAqRpgIdx1).dsSrcLtyp = 'FFR';
          dsSrcLtyp = 'FFC';
      EndIf;

      //Removing comments (//)
      wkScanPos = %Scan('//' : iAQRpgSrcArr(iAqRpgIdx1).dsSrcDta);
      If wkScanpos <> 0;
         iAQRpgSrcArr(iAqRpgIdx1).dsSrcDta =
                         %Subst(iAQRpgSrcArr(iAqRpgIdx1).dsSrcDta
                         : 1 : wkScanpos - 1);
         dsSrcDta = iAQRpgSrcArr(iAqRpgIdx1).dsSrcDta;                                   //0009
      EndIf;

     //If source line Cont is B or C, keep storing the srcdta till
     //we encounter E, and sent the whole statement for parsing
      If iAQRpgSrcArr(iAqRpgIdx1).dsSrcLnct = 'B' Or
         iAQRpgSrcArr(iAqRpgIdx1).dsSrcLnct = 'C';
         wkSrcDta = %Trim(wkSrcDta) +  ' ' +
                    %Trim(iAQRpgSrcArr(iAqRpgIdx1).dsSrcDta);
          dsSrcDta  = %Trim(wkSrcDta)  ;                                                 //0013
         WkIterFlag = *On ;
         Return ;
      ElseIf iAQRpgSrcArr(iAqRpgIdx1).dsSrcLnct  = 'E';
         wkSrcDta = %Trim(wkSrcDta) +  ' ' +
                    %Trim(iAQRpgSrcArr(iAqRpgIdx1).dsSrcDta);
          dsSrcDta  = %Trim(wkSrcDta)  ;
      EndIf;

      ioParmPointer =  %Addr(dsParmRpgSrc);

/copy 'QCPYSRC/iaprcerlog.rpgleinc'

   End-Proc FreeFormatLineCont ;

//------------------------------------------------------------------------------------- //
//FixFormatLineCont :  Procedure for Line continuation in fix format
//------------------------------------------------------------------------------------- //
Dcl-Proc FixFormatLineCont ;                                                              //0002
                                                                                          //0002
   //CopyBook Declaration                                                                //0002
/copy 'QCPYSRC/iaprderlog.rpgleinc'
                                                                                          //0002
 //SourceDataDs = iAQrpgSrcArr(iAqRpgIdx1).dsSrcDta;                                      //0002
   wksrcdta = SourceDataDs.Data;                                                          //0002

   If PrvSavedLineDs.dsSrcSpec <> dsSrcSpec and                                           //0007
      PrvSavedLineDs.dsSrcDta <> *Blanks;                                                 //0007
      Exsr MapPrvLineSr;                                                                  //0007
   EndIf;                                                                                 //0007

   Select;                                                                                //0002
      When dsSrcSpec = 'C' ;                                                              //0002
                                                                                          //0002
         //Check for EXEC SQL Keyword to parse SQL queries                               //0002
         If %Scan(cwFxExecSql : %Xlate(cwLo:cwUp:%Trim(dsSrcDta))) = 1 or                 //0002
              %Scan('C+' : %Xlate(cwLo:cwUp:%Trim(dsSrcDta))) = 1 ;                       //0002
            If wkSrcDta2 = *Blanks;                                                       //0002
               wkSrcDta2 = %Trim(wkSrcDta2) + %TrimR(dsSrcDta);                           //0002
            Else;                                                                         //0002
               wkSrcDta2 = %Trim(wkSrcDta2) + %TrimR(%Subst(dsSrcDta:8));                 //0002
            EndIf;                                                                        //0002
            WkIterFlag = *On ;                                                            //0002
            Return ;                                                                      //0002
         EndIf;                                                                           //0002
                                                                                          //0002
         If %Scan(cwFxEndExec : %Xlate(cwLo:cwUp:%Trim(dsSrcDta))) = 1;                   //0002
                                                                                          //0002
            //SQL Query is ready now to mapping procedure                                //0002
            Return ;                                                                      //0002
         EndIf;                                                                           //0002
                                                                                         //0007
         Clear CspecDsV4;                                                                //0007
                                                                                         //0007
         //After 999th rows checking is 1st row mergable with previous one              //0007
         If PrvSavedLineDs.dsSrcDta <> *Blanks;                                          //0007
               CSpecDsV4 = iAQRpgSrcArr(iAqRpgIdx1).dsSrcDta;                            //0007
                                                                                         //0007
               //Merging 999th row and 1st row                                          //0007
            If CSpecDsV4.C_Opcode = *Blanks And                                          //0007
                   SourceDataDs.NonBlankData <> *Blanks;                                 //0007
               wkSrcdta = %Trimr(PrvSavedLineDs.dsSrcDta)                                //0007
                               + ' ' + %Trim(CSpecDsV4.C_ExtFact2);                      //0007
            Else;                                                                        //0007
               ExSr MapPrvLineSr;                                                        //0007
            EndIf;                                                                       //0007
         EndIf;                                                                          //0007
         iAqRpgIdx2 = iAqRpgIdx1 + 1;                                                    //0007
         If iAqRpgIdx2 = MaxRows + 1;                                                    //0007
            PrvSavedLineDs = iAQRpgSrcArr(iAqRpgIdx1);                                   //0007
            wkIterFlag = *On;                                                            //0007
            Return;                                                                      //0007
         Else;                                                                           //0007
                                                                                         //0007
            //Checking next line should be C spec                                       //0007
            If iAQRpgSrcArr(iAqRpgIdx2).dsSrcSpec = 'C' and                              //0023
               iAQRpgSrcArr(iAqRpgIdx2).dsSrcLTyp = iAQRpgSrcArr(iAqRpgIdx1).dsSrcLTyp;  //0023
               CSpecDsV4 = iAQRpgSrcArr(iAqRpgIdx2).dsSrcDta;                            //0007
               SourceDataDs = iAQRpgSrcArr(iAqRpgIdx2).dsSrcDta;                         //0007
               //skip Only if Multiline Conditional Indicator is found                  //0022
               If CSpecDsV4.C_N01   <> *Blanks and                                       //0022
                  CSpecDsV4.C_Opcode = *Blanks and                                       //0022
                  (CSpecDsV4.C_Level = *Blanks or                                        //0022
                  %Xlate(cwLo:cwUp:CSpecDsV4.C_Level) ='AN' or                           //0022
                  %Xlate(cwLo:cwUp:CSpecDsV4.C_Level) ='OR' ) and                        //0022
                  SourceDataDs.NonBlankData <> *Blanks;                                  //0022
                  Return;                                                                //0022
               EndIf;                                                                    //0022
               If CSpecDsV4.C_Opcode = *Blanks And                                       //0007
                     SourceDataDs.NonBlankData <> *Blanks;                               //0007
                  Dow iAQRpgSrcArr(iAqRpgIdx2).dsSrcSpec = 'C' and                       //0007
                         CspecDsV4.C_Opcode = *Blanks  ;                                 //0007
                                                                                         //0007
                     //Merge Line Continuation                                          //0007
                     wkSrcDta = %Trimr(wkSrcDta) + ' ' + %Trim(CSpecDsV4.C_ExtFact2);    //0007
                     iAqRpgIdx2 = iAqRpgIdx2 + 1;                                        //0007
                                                                                         //0007
                     If iAqRpgIdx2 = MaxRows + 1;                                        //0007
                        PrvSavedLineDs = iAQRpgSrcArr(iAqRpgIdx1);                       //0007
                        PrvSavedLineDs.dsSrcDta = wkSrcDta ;                             //0007
                        wkIterFlag = *On;                                                //0007
                        Return;                                                          //0007
                     EndIf;                                                              //0007
                                                                                         //0007
                     CSpecDsV4  =  iAQRpgSrcArr(iAqRpgIdx2).dsSrcDta;                    //0007
                     SourceDataDs =  iAQRpgSrcArr(iAqRpgIdx2).dsSrcDta;                  //0007
                  EndDo;                                                                 //0007
                  iAqRpgIdx1 = iAqRpgIdx2 - 1;                                           //0007
               EndIf;                                                                    //0007
            EndIf;                                                                       //0007
         EndIf;                                                                          //0007
                                                                                         //0006
      When dsSrcSpec = 'D' or dsSrcSpec = 'P';                                           //0006
         Clear DspecV4;                                                                  //0006
         DspecV4 = dsSrcDta;                                                             //0006
         SourceDataDs = dsSrcDta;                                                        //0006
         wk3dotPos = %Scan('...' : DSpecV4.LongName);                                    //0006
                                                                                         //0006
         If SourceDataDs.NonBlankData = *Blanks;                                         //0006
            wk3dotPos = 1;                                                               //0006
         EndIf;                                                                          //0006
                                                                                         //0006
         If wk3dotPos > *Zeros;                                                          //0006
            If SourceDataDs.NonBlankData <> *Blanks;                                     //0006
               wkDName = %Trim(wkDName) +                                                //0006
                    %Trim(%Subst(DSpecV4.LongName : 1 : wk3dotPos-1));                   //0006
            EndIf;                                                                       //0006
            wkIterFlag = *On;                                                            //0006
            Return;                                                                      //0006
         EndIf;                                                                          //0006
         wkDName = %Trim(wkDName) +  %Trim(DspecV4.Name);                                //0006
         dsName  = wkDName ;                                                             //0006

   EndSl;                                                                                 //0002
//------------------------------------------------------------------------------------- //0007
//MapPrvLineSr : Map Previous Line SubRoutine                                           //0007
//------------------------------------------------------------------------------------- //0007
   BegSr MapPrvLineSr;                                                                   //0007
                                                                                         //0007
      PrvParmDataDs = DsParmRpgSrc ;                                                     //0007
                                                                                         //0007
      PrvParmDataDs.dsSrcRrn   = PrvSavedLineDs.dsSrcRrn;                                //0007
      PrvParmDataDs.dsSrcSeq   = PrvSavedLineDs.dsSrcSeq;                                //0007
      PrvParmDataDs.dsSrcLtyp  = PrvSavedLineDs.dsSrcLtyp;                               //0007
      PrvParmDataDs.dsSrcSpec  = PrvSavedLineDs.dsSrcSpec;                               //0007
      PrvParmDataDs.dsSrcLnct  = PrvSavedLineDs.dsSrcLnct;                               //0007
      PrvParmDataDs.dsSrcDta   = PrvSavedLineDs.dsSrcDta;                                //0007
                                                                                         //0007
      ioParmPointer = %Addr(PrvParmDataDs);                                              //0007
      If iAFixedFormatParser(ioParmPointer);                                             //0007
                                                                                         //0007
      Endif;                                                                             //0007
      DsParmRpgSrc = PrvParmDataDs;                                                      //0007
      Clear PrvSavedLineDs;                                                              //0007
      Clear wkSrcDta;                                                                    //0007
      SourceDataDs = iAQrpgSrcArr(iAqRpgIdx1).dsSrcDta;                                  //0007
      wksrcdta = SourceDataDs.Data;                                                      //0007
                                                                                         //0007
   EndSr;                                                                                //0007

/copy 'QCPYSRC/iaprcerlog.rpgleinc'
End-Proc FixFormatLineCont ;                                                              //0002

//------------------------------------------------------------------------------------- //0024
//GetRPGLESpecs: Get the spec from in IAPSEUDOKP file                                   //0024
//------------------------------------------------------------------------------------- //0024
Dcl-Proc GetRPGLESpecstoInclude;                                                         //0024
                                                                                         //0024
   Dcl-pi *N char(1) dim(10);                                                            //0024
      upSrcLinTyp Char(5)  Const;                                                        //0024
      upKeyword   Char(10) Const;                                                        //0024
   End-pi;                                                                               //0024
                                                                                         //0024
   Dcl-s uwIdx                 packed(3:0);                                              //0024
   Dcl-s uwRpgleSpecArray      char(1) dim(10);                                          //0024
   Dcl-S uwSpecs               char(200);                                                //0024
   Dcl-S uwStartPos            packed(3:0) inz(1);                                       //0024
   Dcl-S uwCommaPos            packed(3:0);                                              //0024
   Dcl-S uwSpec                char(1);                                                  //0024
                                                                                         //0024
   Exec Sql                                                                              //0024
     Select IASRCMAP into :uwSpecs                                                       //0024
       from IAPSEUDOKP                                                                   //0024
      where IASRCMTYP = 'RPGLE'                                                          //0024
        and IASRCLTYP = Trim(:upSrcLinTyp)                                               //0024
        and IAKWDOPC  = Trim(:upKeyword)                                                 //0024
      limit 1;                                                                           //0024
                                                                                         //0024
   uwCommaPos = %scan(',' : uwSpecs : uwStartPos);                                       //0024
   Dow uwCommaPos <> 0;                                                                  //0024
                                                                                         //0024
      uwSpec = %subst(uwSpecs : uwStartPos : uwCommaPos - uwStartPos);                   //0024
      uwIdx += 1;                                                                        //0024
      uwRpgleSpecArray(uwIdx) = uwSpec;                                                  //0024
      uwStartPos = uwCommaPos + 1;                                                       //0024
      uwCommaPos = %scan(',' : uwSpecs : uwCommaPos + 1);                                //0024
                                                                                         //0024
      If uwCommaPos = 0;                                                                 //0024
         uwSpec = %subst(uwSpecs : uwStartPos);                                          //0024
         uwIdx += 1;                                                                     //0024
         uwRpgleSpecArray(uwIdx) = uwSpec;                                               //0024
      Endif;                                                                             //0024
                                                                                         //0024
   Enddo;                                                                                //0024
                                                                                         //0024
   return uwRpgleSpecArray;                                                              //0024
                                                                                         //0024
End-Proc;                                                                                //0024
