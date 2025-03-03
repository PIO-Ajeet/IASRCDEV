**free
      //%METADATA                                                      *
      // %TEXT IA Pseudocode generation processing for CL              *
      //%EMETADATA                                                     *
//--------------------------------------------------------------------------------------//
//Created By  : Programmers.io @ 2024                                                   //
//Created Date: 2024/01/01                                                              //
//Developer   : Programmers.io                                                          //
//Description : This program generate source documentation - Pseudocode for CL          //
//                                                                                      //
//Procedure Log:                                                                        //
//--------------------------------------------------------------------------------------//
//Procedure Name           | Procedure Description                                      //
//-------------------------|------------------------------------------------------------//
//ProcessSourceData        | Process source data for CL sources                         //
//Write_RRN1_Error         | Write RRN error in iAExcPLog                               //
//--------------------------------------------------------------------------------------//
//                                                                                      //
//Modification Log:                                                                     //
//--------------------------------------------------------------------------------------//
//Date-DMY| Mod ID | Developer  | Case and Description                                  //
//--------|--------|------------|-------------------------------------------------------//
//16/05/24|  0001  | Manav T.   | #617 - Update IADWNDTLP file status instead of        //
//        |        |            | IADWNREQ file status. Parameters to                   //
//        |        |            | iARequestStatusUpdate are added.                      //
//04/07/24|  0002  | Vamsi      | Rename Bnddir AIERRBND, copybooks AICERRLOG/AIDERRLOG //
//        |        |            | and procedures AISQLDIAGNOSTIC and AIPSSRERRORLOG     //
//        |        |            | with IA*  [Task#261]                                  //
//        |        |            |                                                       //
//        |        |            |                                                       //
//        |        |            |                                                       //
//        |        |            |                                                       //
//--------------------------------------------------------------------------------------//
Ctl-Opt CopyRight('Copyright @ Programmers.io © 2024');
Ctl-Opt Option(*SrcStmt:*NoDebugIo:*NoUnRef);
Ctl-Opt BndDir('IABNDDIR' : 'IAERRBND');                                                 //0002

//------------------------------------------------------------------------------------- //
//CopyBook declaration
//------------------------------------------------------------------------------------- //
/copy 'QMODSRC/iapcod01pr.rpgleinc'
/copy 'QMODSRC/iasrv01pr.rpgleinc'
/copy 'QCPYSRC/iaderrlog.rpgleinc'

//------------------------------------------------------------------------------------- //
//Prototypes Declaration
//------------------------------------------------------------------------------------- //
Dcl-Pi IAPSEUDOCL ExtPgm('IAPSEUDOCL');
   inReqId   Like(ReqId);
   inSrclib  Like(SrcLib);
   inSrcSpf  Like(SrcSpf);
   inSrcMbr  Like(SrcMbr);
   inSrcType Like(SrcType);
End-Pi;

//------------------------------------------------------------------------------------- //
//Constant declaration
//------------------------------------------------------------------------------------- //
Dcl-C cwSrcLength    4046;

//------------------------------------------------------------------------------------- //
//Data structure declaration
//------------------------------------------------------------------------------------- //
Dcl-Ds wkParmDs Qualified Inz;
   wkReqId      Char(18);
   wkSrcLib     Char(10);
   wkSrcPf      Char(10);
   wkSrcMbr     Char(10);
   wkSrcType    Char(10);
   wkRrn        Packed(6:0);
   wkSeq        Packed(6:2);
   wkSrcLtyp    Char(5);
   wkSrcSpec    Char(1);
   wkSrcLnct    Char(1);
   wkPseudoCode Char(cwSrcLength);
End-Ds;

Dcl-Ds wkParmClds Qualified Inz;
   wkString      Char(5000);
   wkReqId       Char(18);
   wkSrcLib      Char(10);
   wkSrcPf       Char(10);
   wkSrcMbr      Char(10);
   wkSrcType     Char(10);
   wkRrn         Packed(6:0);
   wkSeq         Packed(6:2);
   wkLblName     Char(25);
   wkWriteFlg    Char(1);
   wkIndentLevel Packed(5:0);
   wkMaxLevel    Packed(5:0);
   wkIncrLevel   Packed(5:0);
   wkIndentArray Packed(5:0) Dim(999);
End-Ds;

Dcl-Ds InputDataDs  Qualified Dim(100);
   wkSourceData     Char(cwSrcLength)     Inz;
   wkSourceRrn      Packed(6:0)           Inz;
   wkSourceSeq      Packed(6:2)           Inz;
End-Ds;

//------------------------------------------------------------------------------------- //
//Standalone Variables
//------------------------------------------------------------------------------------- //
Dcl-S wkStm2          Char(cwSrcLength) Inz;
Dcl-S ReqId           Char(18)          Inz;
Dcl-S Srclib          Char(10)          Inz;
Dcl-S SrcSpf          Char(10)          Inz;
Dcl-S Srcmbr          Char(10)          Inz;
Dcl-S SrcType         Char(10)          Inz;
Dcl-S wkRrn2          Packed(6:0)       Inz;
Dcl-S LabelStrpos     Packed(2:0)       Inz;
Dcl-S LabelEndpos     Packed(2:0)       Inz;
Dcl-S NbrOfRows       Int(5)            Inz(%Elem(InputDataDs)) ;
Dcl-S wkRowNums       Int(5);
Dcl-S InputFileIdx    Int(5);

//------------------------------------------------------------------------------------- //
//Mainline programming
//------------------------------------------------------------------------------------- //
Exec Sql
  Set Option Commit    = *None,
             Naming    = *Sys,
             UsrPrf    = *User,
             DynUsrPrf = *User,
             CloSqlCsr = *EndMod;

Eval-corr uDpsds = wkuDpsds;
ReqId   = inReqId;
Srclib  = inSrclib;
SrcSpf  = inSrcSpf;
Srcmbr  = inSrcMbr;
SrcType = inSrcType;


//Process the CL source statement
ProcessSourceData(SrcType);

*Inlr = *On;
/copy 'QCPYSRC/iacerrlog.rpgleinc'

//------------------------------------------------------------------------------------- //
//ProcessSourceData :
//------------------------------------------------------------------------------------- //
Dcl-Proc ProcessSourceData;

   Dcl-Pi *n;
      inMbrtyp1 Char(10) Const;
   End-Pi;

   Dcl-S wkSourceString  Char(5000)  Inz;
   Dcl-S wkSourceString1 Char(5000)  Inz;
   Dcl-S wkStm           Char(120)   Inz;
   Dcl-S wkCLKeywordPrv  Char(10)    Inz;
   Dcl-S SrcstmType      Char(10)    Inz;
   Dcl-S wkSrcLabel      Char(20)    Inz;
   Dcl-S wkElseStmt      Char(1)     Inz;
   Dcl-S ElseIndtFlg     Char(1)     Inz;
   Dcl-S wkParmPointer   Pointer     Inz;
   Dcl-S wkParmClptr     Pointer     Inz;
   Dcl-S wkRrn           Packed(6:0) Inz;
   Dcl-S wkSeq           Packed(6:2) Inz;
   Dcl-S wkFirstStmLine  Ind         Inz('1');
   Dcl-S wkPosStrCmt     Zoned(5:0)  Inz;
   Dcl-S wkPos           Zoned(4:0)  Inz;
   Dcl-S wkPosEnd        Zoned(4:0)  Inz;
   Dcl-S wkPosEndCmt     Zoned(5:0)  Inz;

   //CopyBook Declaration
/copy 'QCPYSRC/iaprderlog.rpgleinc'

   //Fetch the Cl Source Data From iAQClSrc - Input file
   Exec Sql
     Declare SrcStmt No Scroll Cursor For
       Select Upper(Source_Data), Source_Rrn, Source_Seq
         From   iAQClSrc
       Where  Library_Name  = Trim(:SrcLib)
         And  SourcePf_Name = Trim(:SrcSpf)
         And  Member_Name   = Trim(:SrcMbr)
         And  Source_Data   <> ' '
       Order By Source_Rrn
       For Fetch Only;

   Exec Sql Open SrcStmt;
   If SqlCode = Csr_Opn_Cod;
      Exec Sql Close SrcStmt;
      Exec Sql Open  SrcStmt;
   EndIf;

   If SqlCode < SuccessCode;
      uDpsds.wkQuery_Name = 'Open_SrcStmt';
      IaSqlDiagnostic(uDpsds);                                                           //0002
   EndIf;

   //Write the Header of program for Pseudo code Source Documention
   If SqlCode = SuccessCode;
       //Write the Pseudocode header
       wkParmDs.wkReqId   = ReqId;
       wkParmDs.wkSrcLib  = Srclib;
       wkParmDs.wkSrcPf   = SrcSpf;
       wkParmDs.wkSrcMbr  = Srcmbr;
       wkParmDs.wkRrn     = wkRrn;
       wkParmDs.wkSrcType = SrcType;
       wkParmPointer      = %Addr(wkParmDs);
       WriteHeader(wkParmPointer);
   EndIf;

   //Reset the Indentation fields
   Clear wkParmClds.wkIndentLevel;
   Clear wkParmClds.wkMaxLevel;
   Clear wkParmClds.wkIncrLevel;
   Clear wkParmClds.wkIndentArray;

   Dow SqlCode = SuccessCode;

      //Fetch rows from IAQCLSRC file
      Clear InputDataDs;
      Exec Sql Fetch SrcStmt For :NbrOfRows Rows
                  Into :InputDataDs;
      If SqlCode < SuccessCode;
         uDpsds.wkQuery_Name = 'Fetch_SrcStmt';
         IaSqlDiagnostic(uDpsds);                                                        //0002
         Leave;
      ElseIf Sqlcode = 100;
         Leave;
      EndIf;
      wkRowNums = 0;
      Exec Sql Get Diagnostics
        :wkRowNums = Row_Count;

      //Process the Cl statement
      For InputFileIdx = 1 to wkRowNums by 1 ;
        wkStm  = InputDataDs(InputFileIdx).wkSourceData;
        wkRrn  = InputDataDs(InputFileIdx).wkSourceRrn;
        wkSeq  = InputDataDs(InputFileIdx).wkSourceSeq;
        wkSourceString = %Trim(wkStm);
        wkStm2 = %Trim(wkStm);

        If wkSourceString = *Blanks;
           Iter;
        EndIf;

        Monitor;
           //Validation for Commented lines
           Select;
           When (%Scan('/*' : wkStm) > 0
                and %Scan('*/' : wkStm : %Scan('/*' : wkStm)) = 0
                and (%Subst(wkStm:%Len(%Trim(wkStm)):1)       = '+' Or
                %Subst(wkStm:%Len(%Trim(wkStm)):1)       = '-' ));
              wkStm = %Replace(' ' :wkStm :%Scan('/*' : wkStm));

           When %Scan('/*' : wkStm) > 0
                and %Scan('*/' : wkStm : %Scan('/*' : wkStm)) > 0  ;
              wkStm = %Replace(' ' :wkStm :%Scan('/*' : wkStm)
                                 :%Scan('*/' :wkStm :%Scan('/*' : wkStm))+1);
           EndSl;

           If wkFirstStmLine;
              wkFirstStmLine       = *off;
              wkParmClds.wkReqId   = ReqId;
              wkParmClds.wkSrcLib  = Srclib;
              wkParmClds.wkSrcPf   = SrcSpf;
              wkParmClds.wkSrcMbr  = Srcmbr;
              wkParmClds.wkSrcType = SrcType;
              wkParmClds.wkRrn     = wkRrn;
              wkParmClds.wkSeq     = wkSeq;
           EndIf;

           //Validation for line continuation
           If %Subst(wkSourceString:%Len(%Trim(wkSourceString)):1) = '+'
              or %Subst(wkSourceString:%Len(%Trim(wkSourceString)):1) = '-';
              wkSourceString  = %Subst(wkSourceString : 1:
                                %Len(%Trim(wkSourceString))-1);
              wkSourceString1 = %Trim(wkSourceString1) + ' ' +
                              %Trim(wkSourceString);
              Iter;
           Else;
              If wkSourceString1 = *Blanks;
                 wkSourceString1 = %Trim(wkSourceString);
              Else;
                 wkSourceString1 = %Trimr(wkSourceString1) + ' ' +
                                   %Trim(wkSourceString);
              EndIf;
           EndIf;

           wkPosEndCmt = 1;
           Dow wkPosEndCmt <> 0;
              wkPosEndCmt = 0;
              wkPosStrCmt = %Scan('/*' : wkSourceString1);
              If wkPosStrCmt > 0;
                 wkPosEndCmt = %Scan('*/' : wkSourceString1 : wkPosStrCmt);
                 If wkPosEndCmt > 0;
                   wkSourceString1 = %Replace(' ': wkSourceString1: wkPosStrCmt:
                                                wkPosEndCmt - wkPosStrCmt +2);
                 EndIf;
              EndIf;
           EndDo;

           //Check for 'Labels' in Cl statements - store it in wkLblName parameter
           wkParmClds.wkLblName = *Blanks;
           LabelEndpos = %Scan(':' : wkSourceString1);
           If LabelEndpos > 1;
             LabelStrpos = %Check(' ':wkSourceString1);
             wkParmClds.wkLblName = %Subst(wkSourceString1: LabelStrpos:
                                                     LabelEndpos-LabelStrpos);
             wkSourceString1 = %Replace(' ': wkSourceString1: LabelStrpos:
                                            LabelEndpos);
           EndIf;

           wkParmClds.wkString = wkSourceString1;
           wkParmClds.wkWriteFlg = 'Y';
           wkElseStmt = 'N';
           Clear ElseIndtFlg;

           wkFirstStmLine     = *On;
           wkParmClptr        = %Addr(wkParmClds);
           If wkSourceString1 = *Blanks;
              wkPos = 1;
           Else;
              wkPos = %Check(' ':wkSourceString1);
           EndIf;

           Select;
           //Process Entry Param Stmts
           When %Subst(wkSourceString1:wkPos:4) = 'PGM ';
              If %Check(' ' : wkSourceString1 : wkPos + 4) <> 0;
                iAPrPsPgm(wkParmClptr);
              EndIf;

           //Process Declare Variable Stmts
           When %Subst(wkSourceString1:wkPos:4) = 'DCL ';
              iAPrPsDcl(wkParmClptr:wkCLKeywordPrv);

           //Monitor message Stmts
           When %Subst(wkSourceString1:wkPos:7) = 'MONMSG ';
              iAPsMonMsg(wkParmClptr);

           //CHGVAR Stmt Parsing
           When %Subst(wkSourceString1:wkPos:7) = 'CHGVAR ';
              iAPsChgVar(wkParmClptr);

           //Goto Label Stmts
           When %Subst(wkSourceString1:wkPos:5) = 'GOTO ';
              iAPsGoto(wkParmClptr);

           //DOWHILE, DOUNTIL, IF Stmt Parsing
           When %Subst(wkSourceString1:wkPos:8) = 'DOWHILE '
               Or %Subst(wkSourceString1:wkPos:8) = 'DOUNTIL '
               Or %Subst(wkSourceString1:wkPos:10) = 'OTHERWISE '
               Or %Subst(wkSourceString1:wkPos:5) = 'WHEN '
               Or %Subst(wkSourceString1:wkPos:3) = 'IF ';
              iAPsDoLoop(wkParmClptr:WkElseStmt:ElseIndtFlg);

           //ELSE Stmt Parsing
           When %Subst(wkSourceString1:wkPos:5) = 'ELSE ';
              iAPsElse(wkParmClptr);

           //END Stmts Parsing
           When %Subst(wkSourceString1:wkPos:6)    = 'ENDDO '
               or %Subst(wkSourceString1:wkPos:7)  = 'SELECT '
               or %Subst(wkSourceString1:wkPos:10) = 'ENDSELECT '
               or %Subst(wkSourceString1:wkPos:6)  = 'LEAVE '
               or %Subst(wkSourceString1:wkPos:8)  = 'ITERATE '
               or %Subst(wkSourceString1:wkPos:7)  = 'ENDPGM '
               or %Subst(wkSourceString1:wkPos:7)  = 'RETURN ';
              iAPsEnd(wkParmClptr);

           //Other CL commands
           Other;
              iAPsClMap(wkParmClptr:wkCLKeywordPrv);

              //If the statement only has LABEL, then write pseudo code for the same
              If wkSourceString1 = *Blanks and wkParmClds.wkLblName <> *Blanks;
                wkParmDs.wkSrcLib  = srclib;
                wkParmDs.wkSrcPf   = srcSpf;
                wkParmDs.wkSrcMbr  = srcmbr;
                wkParmDs.wksrcType = srcType;
                wkParmDs.wkRrn     = wkRrn;
                wkParmDs.wkseq     = wkSeq;
                Clear wkSrcLabel;
                SrcstmType = 'CL';
                iAPsLabel(SrcstmType: wkParmClds.wkLblName: wkSrcLabel);
                wkParmDs.wkPseudocode = wkSrcLabel;
                wkParmPointer = %Addr(wkParmDs);
                WritePseudoCode(wkParmPointer);
              EndIf;

           EndSl;

           wkPosEnd = %Scan(' ':wkSourceString1:wkPos);
           wkClKeywordPrv = %Trim(%Subst(wkSourceString1:wkPos:wkPosEnd));
        On-Error;
          Write_RRN1_Error () ;
        EndMon;
        wkSourceString1 = *Blanks;
      EndFor;
      If wkRowNums < NbrOfRows;
        Leave;
      EndIf;
   Enddo;
   Exec Sql Close SrcStmt;

   //Update the request status in IAFDWNDTLP - export file                              //0001
   iARequestStatusUpdate(ReqId:Srclib:SrcSpf:Srcmbr:SrcType);                            //0001

/copy 'QCPYSRC/iaprcerlog.rpgleinc'
End-Proc;

//------------------------------------------------------------------------------------- //
//Write_RRN1_Error :
//------------------------------------------------------------------------------------- //
Dcl-Proc Write_RRN1_Error;

   //CopyBook Declaration
/copy 'QCPYSRC/iaprderlog.rpgleinc'

   Exec Sql
     Insert Into iAExcPLog (Prs_Source_Lib,
                            Prs_Source_File,
                            Prs_Source_Src_Mbr,
                            Library_Name,
                            Program_Name,
                            Rrn_No,
                            Exception_Type,
                            Exception_No,
                            Exception_Data,
                            Source_Stm,
                            Module_Pgm,
                            Module_Proc)
         values(Trim(:SrcLib),
                Trim(:SrcSpf),
                Trim(:SrcMbr),
                Trim(:uDpsds.SrcLib),
                Trim(:uDpsds.ProcNme),
                Trim(char(:wkRrn2)),
                Trim(:uDpsds.ExcpTTyp),
                Trim(:uDpsds.ExcpTNbr)    ,
                Trim(:uDpsds.RtvExcPTdt)   ,
                Trim(:wkStm2),
                Trim(:uDpsds.ModulePgm),
                Trim(:uDpsds.ModuleProc));

   If SqlCode < SuccessCode;
      uDpsds.wkQuery_Name = 'Insert_IAEXCPLOG';
      IaSqlDiagnostic(uDpsds);                                                           //0002
   EndIf;

/copy 'QCPYSRC/iaprcerlog.rpgleinc'
End-Proc;
