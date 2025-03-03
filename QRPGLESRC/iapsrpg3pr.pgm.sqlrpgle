**Free
      //%METADATA                                                      *
      // %TEXT IA Pseudocode generation processing for RPG3            *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------- //
//Created By  : Programmers.io @ 2024                                                   //
//Created Date: 2024/05/01                                                              //
//Developer   : Programmers.io                                                          //
//Description : This program generate Pseudocode for Rpg3                               //
//                                                                                      //
//Procedure Log:                                                                        //
//------------------------------------------------------------------------------------- //
//Procedure Name           | Procedure Description                                      //
//-------------------------|----------------------------------------------------------- //
//GeinitseRpgPseudoCode    | Generate PseudoCode for RPG source                         //
//FetchRecordsFromCursor   | Fetch records from FetchSourceDetailFromiAQRpgSrc cursor   //
//------------------------------------------------------------------------------------- //
//                                                                                      //
//Modification Log:                                                                     //
//------------------------------------------------------------------------------------- //
//Date-DMY| Mod_Id | Developer  | Case and Description                                  //
//--------|--------|------------|------------------------------------------------------ //
//24/06/24|  0001  | Shobhit    | Task:735- RPG3 C-Spec observations                    //
//10/07/24|  0002  | Santosh    | Task:773- Analysis for error in error log file        //
//        |        |            |           AIdumpdtlp/AIerrlogp for RPG3               //
//25/07/24|  0003  | Gokul R    | Task:817- Add the new column "Font Code" in the insert//
//        |        |            |           statement to Bold the Start and End Tag     //
//24/08/02|  0004  | Munumonika | Populating the glossary section for Rpg3 source       //
//        |        |            | Corrected query for fetching correct seq no: Task-837 //
//26/07/24|  0005  | Ruhi       | Task:724 Enhancement in procedure Calling Name        //
//        |        |            | and parameters in RPG3 source                         //
//13/08/24|  0006  | Manju      | Task:798- RPG3 C Spec Pseudo code Improvement         //
//        |        |            |           for Opcode with Optional Factor1            //
//26/08/24|  0007  | Manju      | Task:884- RPG3 K Spec Pseudo code Logic Implemented   //
//        |        |            |           for /COPY and /INCLUDE                      //
//29/08/24|  0008  | Himanshu   | Task:896- Declarations done in C-spec are not printing//
//        |        |            |           at designated place.                        //
//30/08/24|  0009  | Azhar Uddin| Task:893- Load I spec headers to be used in service   //
//        |        |            |           program for field details printing          //
//05/09/24|  0010  | Manju      | Task:918- Logic applied to handle Copybook anywhere   //
//        |        |            |           inside the Program and Write to work file   //
//        |        |            |           when Copybook is within CSpec else writes in//
//        |        |            |           IAPSEUDOCP file                             //
//04/09/24|  0011  | Shefali    | Task:913- Read IAQRPGSRC records in order of RRN      //
//30/05/24|  0012  | Azhar Uddin| Task#689 - Modified to write the commented text based //
//        |        |            |            on new input parameter flag value          //
//27/09/24|  0013  | Gokul R    | Task:931 - Minimize the repetition of SQL queries by  //
//        |        |            |            reusing the existing procedure to retrieve //
//        |        |            |            Pseudocode mapping details                 //
//29/11/24|  0014  | Azhar Uddin| Task:815- Use new indentation procedure               //
//27/09/24|  0015  | Mahima T   | Task:1071- Except F and C spec other specs should be  //
//        |        |            |            optional to print in RPG3 psuedocode       //
//        |        |            |            and K spec to be printed if coming after C //
//        |        |            |           >Updated SQLs to read/update WK and CP files//
//        |        |            |            to be read with complete key values        //
//06/01/25| 0016   | HIMANSHUGA | Based on i/p flag determine what config wil be used   //
//        |        |            | from KP file to print or not print declaration specs  //
//        |        |            | Task 1099.                                            //
//------------------------------------------------------------------------------------- //
Ctl-Opt CopyRight('Copyright @ Programmers.io © 2024');
Ctl-Opt Option(*NoDebugIo:*SrcStmt:*NoUnRef);
Ctl-Opt BndDir('IABNDDIR' : 'IAERRBND');

//------------------------------------------------------------------------------------- //
//Constant Variables                                                                    //
//------------------------------------------------------------------------------------- //
Dcl-C cwTrue         '1';
Dcl-C cwFalse        '0';
Dcl-C cwUp           'ABCDEFGHIFKLMNOPQRSTUVWXYZ';
Dcl-C cwLo           'abcdefghijklmnopqrstuvwxyz';
Dcl-C cwSrcLength    4046;
Dcl-C cwF            'F';
Dcl-C cwE            'E';
Dcl-C cwC            'C';                                                                //0006
Dcl-C cwI            'I';                                                                //0009
Dcl-C cwA            'A';                                                                //0013

//------------------------------------------------------------------------------------- //
//Standalone Variables                                                                  //
//------------------------------------------------------------------------------------- //
Dcl-S WkSpec         Char(1)               Inz;
Dcl-S WkFrSpec       Char(5)               Inz('FFC');
Dcl-S WkIsKSpecAfterCSpec Char(1)          Inz('N');                                     //0015
Dcl-S wkInclusiveSpecArr  Char(1) Dim(10);                                               //0015
// To Fetch Cspec info from Secondary Mapping file for Opcode with Optional Var         //0006
// FX4 SourceLineType is mentioned because it uses same Opcodes as FX3                  //0006
// and also to avoid Duplicate lines for same Opcode                                    //0006
Dcl-S WkFx3Spec      Char(5)               Inz('FX4');                                   //0006
Dcl-S wkInclDeclSpec Char(1);                                                            //0016

Dcl-S rowsFetched    Uns(5)                Inz;
Dcl-S noOfRows       Uns(5)                Inz;
Dcl-S iAqRpgIdx      Uns(5)                Inz;

Dcl-S RcdFound       Ind                   Inz;
Dcl-S RowFound       Ind                   Inz('0');
Dcl-S wkHSpecHdrInd  Ind                   Inz('0');
Dcl-S wkFSpecHdrInd  Ind                   Inz('0');
Dcl-S wkESpecHdrInd  Ind                   Inz('0');
Dcl-S wkCSpecHdrInd  Ind                   Inz('0');
Dcl-S wkISpecHdrInd  Ind                   Inz('0');
Dcl-S wkKSpecHdrInd  Ind                   Inz('0');                                     //0007
Dcl-S wkDocseq       Packed(6:0);
Dcl-S wkCSpecInd     Ind                   Inz('0');
Dcl-S wkGlossaryInd  Ind                   Inz('0');                                     //0004
Dcl-S wkWriteCmntInd Ind                   Inz('0');                                     //0012

Dcl-S ioParmPointer  Pointer               Inz(*Null);

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

//Datastructure to save the previous process data                                       //0010
Dcl-Ds PrviAQRpgSrc likeds(iAQRpgSrcPrvDs) inz;                                          //0010

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
   dsSkipNxtStm  ind;
   dsFileNames   char(10) dim(99);
   dsFileCount   zoned(2:0);
   dsDocseq      Packed(6:0);
   dsVarAry      char(6)  dim(9999);                                                     //0002
   dsVarCount    zoned(4:0);                                                             //0002
   dsIfCount     zoned(4:0);                                                             //0002
   dsSkipParm    ind;                                                                    //0005
End-Ds;

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
// Data Structure for indent data                                                        //0014
Dcl-Ds RPGIndentParmDs LikeDS(RPGIndentParmDsTmp);                                       //0014

//------------------------------------------------------------------------------------- //
//Prototype Definitions                                                                 //
//------------------------------------------------------------------------------------- //

//------------------------------------------------------------------------------------- //
//Copybook definitions                                                                  //
//------------------------------------------------------------------------------------- //
/copy 'QCPYSRC/iaderrlog.rpgleinc'
/copy 'QMODSRC/iapcod01pr.rpgleinc'
/copy 'QMODSRC/iapcod02pr.rpgleinc'

//------------------------------------------------------------------------------------- //
//Entry Parameter Declarations
//------------------------------------------------------------------------------------- //
Dcl-Pr IAPSRPG3PR Extpgm('IAPSRPG3PR');
   *N       Char(18);
   *N       Char(10);
   *N       Char(10);
   *N       Char(10);
   *N       Char(10);
   *N       Char(1)  options(*nopass);                                                   //0012
   *N       Char(1)  options(*nopass);                                                   //0016
End-Pr;

Dcl-Pi IAPSRPG3PR ;
   inReqId  Char(18);
   inLibNam Char(10);
   inSrcNam Char(10);
   inMbrNam Char(10);
   inMbrTyp Char(10);
   inAddComment  Char(1)   options(*nopass);                                             //0012
   inInclDeclSpecs Char(1) options(*nopass);                                             //0016
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
//Cursor to process
Exec Sql
   Declare FetchSourceDetailFromiAQRpgSrc No Scroll Cursor For
      Select XSrcRrn,
             XSrcSeq,
             XSrcLtyp,
             XSrcSpec,
             XSrcLnct,
             XSrcDta
       From  iAQRpgSrc
      Where  XLibNam   = :inLibNam
        And  XSrcNam   = :inSrcNam
        And  XMbrNam   = :inMbrNam
        And  XMbrTyp   = :inMbrTyp
      Order by XSrcSeq, XSrcRrn                                                          //0011
      For Fetch Only;

//------------------------------------------------------------------------------------- //
//Main Processing                                                                       //
//------------------------------------------------------------------------------------- //

//Check if commented text needs to be included in pseudo-code document                  //0012
wkWriteCmntInd= *Off;                                                                    //0012
If %parms > 5 and (inAddComment = 'Y' or inAddComment='y');                              //0012
   wkWriteCmntInd = *On;                                                                 //0012
EndIf;                                                                                   //0012
                                                                                         //0012
wkInclDeclSpec = 'N';                                                                    //0016
If %parms > 6 and (inInclDeclSpecs = 'Y' Or inInclDeclSpecs = 'y');                      //0016
   wkInclDeclSpec = 'Y';                                                                 //0016
EndIf;                                                                                   //0016
//Generate the RPG source documentation - PseudoCode
GenerateRpgPseudoCode();

*Inlr = *On;
Return;

/copy 'QCPYSRC/iacerrlog.rpgleinc'

//------------------------------------------------------------------------------------- //
//GenerateRpgPseudoCode: Generate PseudoCode for RPG sources                            //
//------------------------------------------------------------------------------------- //
Dcl-Proc GenerateRpgPseudoCode;

  //CopyBook Declaration
/copy 'QCPYSRC/iaprderlog.rpgleinc'

  Eval-corr w_uDpsds = wkuDpsds;

  //Initialization Subroutine
  Exsr InitSr;

  Exec Sql Open FetchSourceDetailFromiAQRpgSrc;
  If SqlCode = CSR_OPN_COD;
     Exec Sql Close FetchSourceDetailFromiAQRpgSrc;
     Exec Sql Open  FetchSourceDetailFromiAQRpgSrc;
  EndIf;

  If SqlCode < successCode;
     uDpsds.wkQuery_Name = 'Open_iAQRpgSrc_FetchSourceDetailFromiAQRpgSrc';
     IaSqlDiagnostic(uDpsds);
  EndIf;

  If SqlCode = successCode;

     //Get Number of Rows
     noOfRows = %Elem(iAQRpgSrcArr);
     //Fetch records from FetchSourceDetailFromiAQRpgSrc cursor.
     rowFound = FetchRecordsFromCursor();
     wkGlossaryInd = rowFound;                                                           //0004

     Dow rowFound;

        For iAqRpgIdx = 1 To rowsFetched;

           //Load the Parameter Data Structure
           dsSrcRrn   = iAQRpgSrcArr(iAqRpgIdx).dsSrcRrn;
           dsSrcSeq   = iAQRpgSrcArr(iAqRpgIdx).dsSrcSeq;
           dsSrcLtyp  = iAQRpgSrcArr(iAqRpgIdx).dsSrcLtyp;
           dsSrcSpec  = iAQRpgSrcArr(iAqRpgIdx).dsSrcSpec;
           dsSrcLnct  = iAQRpgSrcArr(iAqRpgIdx).dsSrcLnct;
           dsSrcDta   = iAQRpgSrcArr(iAqRpgIdx).dsSrcDta;

           //Flag to check if K spec coming after C spec if yes                         //0015
           //then it should come in pseudocode                                          //0015
           If dsSrcSpec = 'C' and WkIsKSpecAfterCSpec  = 'N';                            //0015
               WkIsKSpecAfterCSpec = 'Y';                                                //0015
           Endif;                                                                        //0015
                                                                                         //0015
           If %lookup(dsSrcSpec : wkInclusiveSpecArr ) = 0 or                            //0015
              (dsSrcSpec = 'K' and WkIsKSpecAfterCSpec = 'N' );                          //0015
              iter;                                                                      //0015
           Endif;                                                                        //0015
           //Write the commented text                                                   //0012
           If %subst(dsSrcLtyp : 4 : 1) = 'T'                                            //0012
              and wkWriteCmntInd = *On;                                                  //0012

              ioParmPointer =  %Addr(DsParmRpgSrc);                                      //0012
              Rpg3WriteCommentedText(ioParmPointer);                                     //0012

           EndIf;                                                                        //0012

           //call respective parsing procedure for RPG3.
           if dsSrcLtyp = 'FX3' ;
              ParseFx3Src() ;
              if dsSrcSpec = 'C';
                 wkCSpecInd = *on;
              endif;
           endif;

           //Checking the end of C-spec to merger the table with main file
           if dsSrcLtyp = 'FX3' and
              Not (dsSrcSpec = 'C' Or dsSrcSpec = 'K') And                               //0008
              wkCSpecInd ;
              exsr MergerFiles;
              wkCSpecInd = *off;
           endif;
           Eval-Corr PrviAQRpgSrc = iAQRpgSrcArr(iAqRpgIdx);                             //0010
        EndFor ;

        //if fetched rows are less than the array elements then come out of the loop.
        If rowsFetched < noOfRows;
           exsr MergerFiles;
           Leave;
        Endif;
        //Fetch records from FetchSourceDetailFromiAQRpgSrc cursor.
        rowFound = FetchRecordsFromCursor();

        //Checking the end of C-spec to merger the table with main file
        if not rowFound and
           wkCSpecInd ;
           exsr MergerFiles;
           wkCSpecInd = *off;
        endif;

     EndDo;

     Exec Sql Close FetchSourceDetailFromiAQRpgSrc;

  Endif;

  //Add Glossary at the End                                                             //0004
  If wkGlossaryInd = cwTrue;                                                             //0004
     ioParmPointer =  %Addr(dsParmHeader);                                               //0004
     WriteGlossary(ioParmPointer);                                                       //0004
  EndIf;                                                                                 //0004

  //Update the request status in IAFDWNREQ - export file
  iARequestStatusUpdate(inReqId:inLibNam:inSrcNam
                                   :inMbrNam:inMbrTyp);

  Return;

  //----------------------------------------------------------------------------------- //
  //InitSr : Initialization SubRoutine                                                  //
  //----------------------------------------------------------------------------------- //
  BegSr InitSr;

    Clear DsParmRpgSrc;
    Clear RPGIndentParmDS;                                                               //0014
    dsIOIndentParmPointer = %addr(RPGIndentParmDS);                                      //0014
    dsReqId       =  inReqId;
    dsLibNam      =  inLibNam;
    dsSrcNam      =  inSrcNam;
    dsMbrNam      =  inMbrNam;
    dsMbrTyp      =  inMbrTyp;
    dshCmtReqd    =  'Y';
    dsParmHeader.dsReqId       =  inReqId;
    dsParmHeader.dsLibNam      =  inLibNam;
    dsParmHeader.dsSrcNam      =  inSrcNam;
    dsParmHeader.dsMbrNam      =  inMbrNam;
    dsParmHeader.dsMbrTyp      =  inMbrTyp;
    dsParmHeader.dsKeyFld      = ' ';

    //Write the heading for the source documentation
    ioParmPointer =  %Addr(dsParmHeader);
    WriteHeader(ioParmPointer);
    //Load F spec DS
    WkSpec  = cwF;
    GetRPG3SpecSrcMapping(WkFrSpec : WkSpec);
    //Load C spec DS for RPG3 Opcodes which has Optional Variable                       //0006
    WkSpec  = cwC;                                                                       //0006
    GetRPG3SpecSrcMapping(WkFx3Spec : WkSpec);                                           //0006
    //Load I spec headers to be used for printing the field/DS details in I spec        //0009
    WkSpec  = cwI;                                                                       //0009
    GetRPG3SpecSrcMapping(WkFx3Spec : WkSpec);                                           //0009
    //Load all mapping data from IAPSEUDOMP for RPG-3                                   //0013
    WkSpec  = cwA;                                                                       //0013
    GetRPG3SpecSrcMapping(WkFx3Spec : WkSpec);                                           //0013
    //Load the specs that need to be considered for printing                            //0013
    Clear wkInclusiveSpecArr;                                                            //0015
    WkInclusiveSpecArr = GetRPG3SpecsToInclude(wkInclDeclSpec);                          //0016

  EndSr;

  //----------------------------------------------------------------------------------- //
  //MergerFiles: Process to merge the temporary file to permanent file                  //
  //----------------------------------------------------------------------------------- //
  BegSr MergerFiles;

    //Fetch the highest document seq from the main file
    exec sql
      select Coalesce(Max(document_seq),0) into :wkDocseq                                //0004
      from iapseudocp where                                                              //0015
           iaReqId   =   :inReqId    And                                                 //0015
           iaMbrlib  =   :inLibNam   And                                                 //0015
           iaSrcfile =   :inSrcNam   And                                                 //0015
           iaMbrnam  =   :inMbrNam   And                                                 //0015
           iaMbrtyp  =   :inMbrTyp;                                                      //0015

    //Updating the temporary document seq with the new seq as per permanent file
    exec sql
      update IAPSEUDOwk set DOCUMENT_SEQ  = DOCUMENT_SEQ + :wkDocseq
      Where
           wkReqId   =   :inReqId    And                                                 //0015
           wkMbrlib  =   :inLibNam   And                                                 //0015
           wkSrcfile =   :inSrcNam   And                                                 //0015
           wkMbrnam  =   :inMbrNam   And                                                 //0015
           wkMbrtyp  =   :inMbrTyp;                                                      //0015

    //Inserting the c-spec processing pseudo code from temp file to main file
    exec sql
      INSERT INTO IAPSEUDOCP (REQUEST_ID,
         LIBRARY_NAME,SOURCEFILE_NAME, MEMBER_NAME,
         MEMBER_TYPE, SOURCE_RRN, SOURCE_SEQ,SRCLIN_TYPE,
         SOURCE_SPEC, DOCUMENT_SEQ, GENERATED_PSEUDOCODE,
         FONT_CODE,                                                                      //0003
         CREATED_BY_USER)
         (SELECT REQUEST_ID, LIBRARY_NAME, SOURCEFILE_NAME,
         MEMBER_NAME,MEMBER_TYPE, SOURCE_RRN,SOURCE_SEQ,
         SRCLIN_TYPE, SOURCE_SPEC, DOCUMENT_SEQ, GENERATED_PSEUDOCODE,
         FONT_CODE,                                                                      //0003
         CREATED_BY_USER FROM IAPSEUDOWK);

    //Clear the temporary file before processing
    exec sql
      delete from IAPSEUDOWK;

  EndSr;

/copy 'QCPYSRC/iaprcerlog.rpgleinc'

End-proc;

//-------------------------------------------------------------------------------------//
//Procedure fetchRecordsfromCursor : Fetch Records From FetchSourceDetailFromiAQRpgSrc //
//------------------------------------------------------------------------------------- //
Dcl-Proc FetchRecordsFromCursor;

  Dcl-Pi FetchRecordsFromCursor Ind End-Pi;

  Dcl-S  rcdFound Ind Inz('0');
  Dcl-S  wkRowNum Uns(5);

  //CopyBook declaration
/copy 'QCPYSRC/iaprderlog.rpgleinc'

  eval-corr w_uDpsds = wkuDpsds;

  Clear iAQRpgSrcArr;
  Exec Sql
    Fetch FetchSourceDetailFromiAQRpgSrc For :noOfRows Rows Into :iAQRpgSrcArr;

  If Sqlcode = successCode;
     Exec Sql Get Diagnostics
       :wkRowNum = ROW_COUNT;

         rowsFetched  = wkRowNum;
  Endif;

  If rowsFetched > 0;
     rcdFound = cwTrue;
  ElseIf Sqlcode < successCode;
     rcdFound = cwFalse;
  Endif;

  Return rcdFound;

/copy 'QCPYSRC/iaprcerlog.rpgleinc'

End-Proc;

//------------------------------------------------------------------------------------- //
//Procedure ParseFx3Src   : Parse RPG III fix format source.                            //
//------------------------------------------------------------------------------------- //
Dcl-Proc ParseFx3Src   ;

   //Standalone Variables                                                               //0010
   Dcl-S WkFiletype Char(1) Inz;                                                         //0010

   //CopyBook Declaration
/copy 'QCPYSRC/iaprderlog.rpgleinc'

   //Turn off Initialize of variables for all other spec Except K spec                  //0010
   If dsSrcSpec <> 'K';                                                                  //0010
      wkKSpecHdrInd = *off;                                                              //0010
   Endif;                                                                                //0010

   Select ;
      When   dsSrcSpec = 'C' ;
         exsr rpg3CSpecParsing;
      When   dsSrcSpec = 'H' ;
         exsr rpg3HSpecParsing;
      When   dsSrcSpec = 'F' ;
         exsr rpg3FSpecParsing;
      When   dsSrcSpec = 'E' ;
         exsr rpg3ESpecParsing;
      When   dsSrcSpec = 'L' ;
      When   dsSrcSpec = 'I' ;
         exsr rpg3ISpecParsing ;
      When   dsSrcSpec = 'O' ;
      When   dsSrcSpec = 'K' ;                                                           //0007
         exsr rpg3KSpecParsing;                                                          //0007
   Endsl ;

//------------------------------------------------------------------------------------- //
//RPG3 H Spec Parsing                                                                   //
//------------------------------------------------------------------------------------- //
   begSr rpg3HSpecParsing;

    //Leave if commented line
      if %subst(dsSrcDta:7:1) = '*' or
         %subst(dsSrcDta:7:1) = '/';
         leavesr;
      endif;

    //Write the heading for H Spec
      If wkHSpecHdrInd = *Off;
         wkHSpecHdrInd = *On;
         dsParmHeader.dsSrcSpec = 'H';
         ioParmPointer = %Addr(dsParmHeader);
         iAWriteSpecHeader(ioParmPointer);
      endif;

      ioParmPointer = %Addr(DsParmRpgSrc);

      //Call the H spec parcer procedure
      rpg3HSpecParser(ioParmPointer);

   endsr;

//------------------------------------------------------------------------------------- //
//RPG3 F Spec Parsing                                                                   //
//------------------------------------------------------------------------------------- //
   begSr rpg3FSpecParsing;

    //Leave if commented line
      if %subst(dsSrcDta:7:1) = '*' or
         (%subst(dsSrcDta:7:8) = *Blanks and
          %subst(dsSrcDta:53:1) = 'K');
         leavesr;
      endif;

    //Write the heading for F Spec
      If wkFSpecHdrInd = *Off;
         wkFSpecHdrInd = *On;
         dsParmHeader.dsSrcSpec = 'F';
         ioParmPointer = %Addr(dsParmHeader);
         iAWriteSpecHeader(ioParmPointer);
      endif;

      ioParmPointer = %Addr(DsParmRpgSrc);

      //Call the F spec parcer procedure
      rpg3FSpecParser(ioParmPointer);

   endsr;

//------------------------------------------------------------------------------------- //
//RPG3 E Spec Parsing                                                                   //
//------------------------------------------------------------------------------------- //
   begSr rpg3ESpecParsing;

    //Leave if commented line
      if %subst(dsSrcDta:7:1) = '*';
         leavesr;
      endif;

    //Write the heading for E Spec
      If wkESpecHdrInd = *Off;
         wkESpecHdrInd = *On;
         dsParmHeader.dsSrcSpec = 'E';
         ioParmPointer = %Addr(dsParmHeader);
         iAWriteSpecHeader(ioParmPointer);
      endif;

      ioParmPointer = %Addr(DsParmRpgSrc);

      //Call the E spec parcer procedure
      rpg3ESpecParser(ioParmPointer);

   endsr;

//------------------------------------------------------------------------------------- //
//RPG3 C Spec Parsing                                                                   //
//------------------------------------------------------------------------------------- //
   begSr rpg3CSpecParsing;

    //Leave if commented line
      if %subst(dsSrcDta:7:1) = '*';
         leavesr;
      endif;

    //Write the heading for C Spec
      If wkCSpecHdrInd = *Off;                                                           //0015
         If %Lookup('D' : wkInclusiveSpecArr) > *Zeros;                                  //0015
         wkCSpecHdrInd = *On;
         dsParmHeader.dsSrcSpec = 'C';
         dsParmHeader.dsKeyFld  = 'D';
         ioParmPointer = %Addr(dsParmHeader);
         iAWriteSpecHeader(ioParmPointer);
         dsDocSeq = 0;
         clear dsVarAry;
         dsVarCount = 0;
         dsIfCount = 0;                                                                  //0001
         Endif;                                                                          //0015
      endif;

      //Fetch the highest document seq from the main file after Kspec lines             //0010
      If dsSrcSpec <> PrviAQRpgSrc.dsSrcSpec and PrviAQRpgSrc.dsSrcSpec ='K';            //0010
         exec sql                                                                        //0010
           select Coalesce(Max(document_seq),0) into :dsDocseq                           //0010
           from iapseudowk where                                                         //0015
           wkReqId   =   :dsReqId    And                                                 //0015
           wkMbrlib  =   :dsLibNam   And                                                 //0015
           wkSrcfile =   :dsSrcNam   And                                                 //0015
           wkMbrnam  =   :dsMbrNam   And                                                 //0015
           wkMbrtyp  =   :dsMbrTyp;                                                      //0015
      EndIf;                                                                             //0010

      ioParmPointer = %Addr(DsParmRpgSrc);

      //Call the E spec parcer procedure
      rpg3CSpecParser(ioParmPointer : wkInclDeclSpec);                                   //0016

   endsr;

    //SS01 TAG STARTS HERE
//------------------------------------------------------------------------------------- //
//RPG3 I Spec Parsing                                                                   //
//------------------------------------------------------------------------------------- //
   begSr rpg3ISpecParsing;

    //Leave if commented line
      if %subst(dsSrcDta:7:1) = '*';
         leavesr;
      endif;

    //Write the heading for I Spec
      If wkISpecHdrInd = *Off;
         wkISpecHdrInd = *On;
         dsParmHeader.dsSrcSpec = 'I';
         ioParmPointer = %Addr(dsParmHeader);
         iAWriteSpecHeader(ioParmPointer);
      endif;

      ioParmPointer = %Addr(DsParmRpgSrc);

      //Call the I spec parcer procedure
      rpg3ISpecParser(ioParmPointer);

   endsr;
    //SS01 TAG ENDS HERE                                                                  //

//------------------------------------------------------------------------------------- //0007
//RPG3 K Spec Parsing                                                                   //0007
//------------------------------------------------------------------------------------- //0007
   BegSr rpg3KSpecParsing;                                                               //0007
    //Leave if commented line                                                           //0007
      If %subst(dsSrcDta:7:1) = '*';                                                     //0007
         Leavesr;                                                                        //0007
      EndIf;                                                                             //0007
                                                                                         //0010
      //Turn on Indicator for Copybook heading only for /COPY and /INCLUDE              //0010
      If ((%Scan('/COPY ' : %Xlate(cwLo:cwUp:dsSrcDta):1) <> *Zeros  or                  //0010
         %Scan('/INCLUDE ': %Xlate(cwLo:cwUp:dsSrcDta):1) <> *Zeros)  and                //0010
         dsSrcSpec <> PrviAQRpgSrc.dsSrcSpec) or                                         //0010
         (dsSrcSpec = PrviAQRpgSrc.dsSrcSpec  and                                        //0010
         (%Scan('/COPY '  : %Xlate(cwLo:cwUp:dsSrcDta):1) <> *Zeros  or                  //0010
         %Scan('/INCLUDE ': %Xlate(cwLo:cwUp:dsSrcDta):1) <> *Zeros)  and                //0010
         (%Scan('/COPY '  : %Xlate(cwLo:cwUp:PrviAQRpgSrc.dsSrcDta):1) = *Zeros and      //0010
         %Scan('/INCLUDE ': %Xlate(cwLo:cwUp:PrviAQRpgSrc.dsSrcDta):1) = *Zeros)) ;      //0010
         //Indicator turned on to Display header                                        //0010
         wkKSpecHdrInd = *On;                                                            //0010
      EndIf;                                                                             //0010
                                                                                         //0010
      //If K Spec is Inbetween Cspec , set filetype to Write Pseudo to IAPSEUDOWK       //0010
      clear WkFiletype;                                                                  //0010
      If wkCSpecInd = *On;                                                               //0010
         WkFiletype = 'W';                                                               //0010
      EndIf;                                                                             //0010
                                                                                         //0010
      //Write the heading for K Spec only for /COPY and /INCLUDE                        //0007
      If wkKSpecHdrInd = *On ;                                                           //0010
         wkKSpecHdrInd = *Off;                                                           //0010
         dsParmHeader.dsSrcSpec = 'K';                                                   //0007
         //Intialized dsKeyFld , since It carried previous line value                   //0010
         dsParmHeader.dsKeyFld  = ' ';                                                   //0010
         ioParmPointer = %Addr(dsParmHeader);                                            //0007
         //Call the SpecHeader procedure with addtional param                           //0010
         //Write K Spec header in IAPSEUDOCP or IAPSEUDOWP based on wkFiletype          //0010
         iAWriteSpecHeader(ioParmPointer : WkFiletype);                                  //0010
      EndIf;                                                                             //0007
                                                                                         //0010
      ioParmPointer =  %Addr(DsParmRpgSrc);                                              //0007
      //Call the K spec parcer procedure with addtional param                           //0010
      //Write K Spec Pseudo in IAPSEUDOCP or IAPSEUDOWP based on wkFiletype             //0010
      iACopyBookDclParser(ioParmPointer : dsSrcDta : WkFiletype);                        //0010
   Endsr;                                                                                //0007
/copy 'QCPYSRC/iaprcerlog.rpgleinc'
End-Proc;
