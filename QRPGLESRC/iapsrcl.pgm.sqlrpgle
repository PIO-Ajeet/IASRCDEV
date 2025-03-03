**free
      //%METADATA                                                      *
      // %TEXT IA CL source parser                                     *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------- //
//Created By  : Programmers.io @ 2020                                                   //
//Created Date: 2020/01/01                                                              //
//Developer   : Programmer                                                              //
//Description : This program parses source members that are having type 'CLP' or 'CLLE' //
//                                                                                      //
//Procedure Log:                                                                        //
//------------------------------------------------------------------------------------- //
//Procedure Name           | Procedure Description                                      //
//-------------------------|----------------------------------------------------------- //
//IAPSRCL_ScanKeyword      |                                                            //
//ProcessSourceData        |                                                            //
//Write_RRN1_Error         |                                                            //
//------------------------------------------------------------------------------------- //
//                                                                                      //
//Modification Log:                                                                     //
//------------------------------------------------------------------------------------- //
//Date    | Mod_ID | Developer  | Case and Description                                  //
//--------|--------|------------|------------------------------------------------------ //
//23/06/20| 0001   | Himanshu   | Change the UwSrcDtl ds parameter and corrosponding    //
//        |        | Gehlot     | lines where these parameters are being used.          //
//        |        |            |                                                       //
//23/08/17| 0002   | AnjanGhosh | User Defined command reference creation in IASRCINTF  //
//        |        |            |                                                       //
//27/10/23| 0003   | Abhijith   | Modify the init & parser proess to include refresh    //
//        |        | Ravindran  | functionality (Task#322)                              //
//18/01/24| 0004   | Naresh S   | Parse CRTPRTF command. [Task #538]                    //
//06/06/24| 0005   | Saumya     | Rename AIEXCTIMR tp IAEXCTIMR [Task #262]             //
//05/10/23| 0006   | Khushi W   | Rename program AIMBRPRSER to IAMBRPRSER.[Task #263]   //
//05/07/24| 0007   | Akhil K.   | Renamed AIERRBND, AICERRLOG, AIDERRLOG and AISQLDIAGNO//
//        |        |            | STIC with IA*                                         //
//15/01/25| 0008   |Akhil Kallur| Removal of tags in CL program lines and exclude some  //
//        |        |            | unhandled IBM commands before calling IAPSRUSRCMD.    //
//18/09/24| 0009   | Rishab K.  | Added a new parameter for member type for IAPRDFOVR   //
//        |        |            | Fix for file fields used in CL program[Task# 686]     //
//21/08/24| 0010   | Sabarish   | IFS Member Parsing Upgrade.[Task #833]                //
//------------------------------------------------------------------------------------- //
ctl-opt CopyRight('Copyright @ Programmers.io © 2022');
ctl-opt Option(*SrcStmt:*NoDebugIo:*NoUnRef);
ctl-opt BndDir('IABNDDIR' : 'IAERRBND');                                                 //0007

//------------------------------------------------------------------------------------- //
//Prototypes declaration
//------------------------------------------------------------------------------------- //
dcl-pr IaGetMsg extpgm('IAGETMSG');
   *n char(01)   options(*noPass)   Const;
   *n char(07)   options(*noPass)   Const;
   *n char(1000) options(*noPass);
end-pr;

dcl-pr GetJobType Extpgm('IARTVJOBA');
   *n char(1);
end-pr;

dcl-pr IAPSRCL_scanKeyword char(30);
   *n char(12) const;
   *n char(5000) const;
end-pr;

dcl-pr IAEXCTIMR extpgm('IAEXCTIMR');                                                    //0005
    *n Char(10) Const;
    *n Char(10);
    *n Char(10);
    *n Char(10) Const;
    *n Char(10);
    *n Char(10);
    *n Char(10);
    *n Char(100) Const;                                                                   //0010
    *n Char(10) Const;
    *n Timestamp;
    *n Char(6) Const;
end-pr;

dcl-pi IAPSRCL extpgm('IAPSRCL');
   in_Repository char(10);
   UwSrcDtl5 like(UwSrcDtl);
   uwprog char(74);
end-pi;

//------------------------------------------------------------------------------------- //
//Data structure declaration
//------------------------------------------------------------------------------------- //
dcl-ds w_ParmDS qualified inz;
   w_String     char(5000);
   w_Error      char(10);
   w_Repository char(10);
   w_SrcLib     char(10);
   w_SrcPf      char(10);
   w_SrcMbr     char(10);
   w_IfsLoc     char(100);                                                               //0010
   w_RRNStr     packed(6:0);
   w_RRNEnd     packed(6:0);
   w_sbrnam     char(20);
end-ds;

dcl-ds UwSrcDtl qualified inz;                                                           //0001
   srclib char(10);                                                                      //0001
   srcSpf char(10);                                                                      //0001
   srcmbr char(10);                                                                      //0001
   ifsloc  char(100);                                                                    //0010
   srcType char(10);                                                                     //0001
   srcStat char(1);                                                                      //0003
end-ds;                                                                                  //0001

//------------------------------------------------------------------------------------- //
//Standalone Variables
//------------------------------------------------------------------------------------- //
dcl-s w_GetMsg        char(1000)   inz;
dcl-s uwaction        char(20)     inz;
dcl-s uwactdtl        char(50)     inz;
dcl-s w_progMsg       char(74)     inz;
dcl-s w_JobType       char(1)      inz;
dcl-s wk_srcflag      char(1)      inz('C');
dcl-s r_Stm           char(4046)   inz;
dcl-s Wk_Stm2         char(4046)   inz;
dcl-s Wk_Rrn2         packed(6:0)  inz;
dcl-s w_TotalRecord   packed(10:0) inz;
dcl-s w_CurrentRecord packed(10:0) inz;
dcl-s r_rrn           packed(6:0)  inz;
dcl-s uppgm_name      char(10)     inz;
dcl-s uplib_name      char(10)     inz;
dcl-s uptimestamp     Timestamp;
dcl-s otherCLcmd      Char(21)     Inz;                                                  //0008

//------------------------------------------------------------------------------------- //
//Arrays declaration
//------------------------------------------------------------------------------------- //
dcl-s otherCLcmds     Char(10) Dim(4) ctdata perrcd(1);                                  //0008

//------------------------------------------------------------------------------------- //
//Constant declaration
//------------------------------------------------------------------------------------- //

//------------------------------------------------------------------------------------- //
//CopyBook declaration
//------------------------------------------------------------------------------------- //
/copy 'QMODSRC/iasrv01pr.rpgleinc'
/copy 'QMODSRC/iasrv02pr.rpgleinc'
/copy 'QCPYSRC/iaderrlog.rpgleinc'

//------------------------------------------------------------------------------------- //
//Mainline programming
//------------------------------------------------------------------------------------- //
exec sql
  set option commit    = *none,
             naming    = *sys,
             usrprf    = *user,
             dynusrprf = *user,
             closqlcsr = *endmod;

Eval-corr uDpsds = wkuDpsds;
UwSrcDtl = UwSrcDtl5 ;

uptimeStamp = %Timestamp();
CallP IAEXCTIMR('IAMBRPRSER' :udpsds.ProcNme : udpsds.Lib : '*PGM' :                     //0006
                UwSrcDtl.srcSpf:uwsrcdtl.srcmbr : uwsrcdtl.srclib :                      //0001
         //0010 UwSrcDtl.srcType: uptimeStamp : 'INSERT');                               //0001
                ' ' : UwSrcDtl.srcType: uptimeStamp : 'INSERT');                         //0010

if UwSrcDtl.srcStat = 'A';                                                               //0003
   exsr Get_Rec_IASRCMBRID;
endIf;                                                                                   //0003

processSourceData(uwSrcDtl.srcType);                                                     //0001

uptimeStamp = %Timestamp();
CallP IAEXCTIMR('IAMBRPRSER' :udpsds.ProcNme : udpsds.Lib : '*PGM' :                     //0006
                UwSrcDtl.srcSpf:uwsrcdtl.srcmbr : uwsrcdtl.srclib :                      //0001
         //0010 UwSrcDtl.srcType : uptimeStamp : 'UPDATE');                              //0001
                ' ' : UwSrcDtl.srcType : uptimeStamp : 'UPDATE');                        //0010

*inlr = *on;
/copy 'QCPYSRC/iacerrlog.rpgleinc'

//---- -------------------------------------------------------------------------------- //
//Get_Rec_IASRCMBRID :
//------------------------------------------------------------------------------------- //
begsr Get_Rec_IASRCMBRID;

   exec sql
     Insert into IASRCMBRID (MBRNAME, MBRSRCPF, MBRLIB, MBRTYPE, MBRTLOC,
                             MBRCLOC, MBRBLOC,  MBRBFLAG, MBRLOCN, MBRIFSID)
       values(:UwSrcDtl.srcmbr, :UwSrcDtl.srcSpf, :UwSrcDtl.srclib,
              :UwSrcDtl.srcType, 0, 0, 0, ' ', ' ', 0);                                  //0001

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Insert_IASRCMBRID';
      IaSqlDiagnostic(uDpsds);                                                           //0007
   endif;

endsr;

//------------------------------------------------------------------------------------- //
//IAPSRCL_ScanKeyword :
//------------------------------------------------------------------------------------- //
dcl-proc IAPSRCL_ScanKeyword;

   dcl-pi *n char(30);
      keyword       char(12)   const;
      w_ClStatement char(5000) const;
   end-pi;

   dcl-s w_Keyword  char(12)   inz;
   dcl-s w_Result   char(5000) inz;
   dcl-s w_cl       char(500)  inz;
   dcl-s w_StrPos   zoned(4:0) inz;
   dcl-s w_Len      zoned(4:0) inz;
   dcl-s w_EndPos   zoned(4:0) inz;
   dcl-s w_EndPos1  zoned(4:0) inz;
   dcl-s w_open     zoned(4:0) inz;
   dcl-s w_close    zoned(4:0) inz;
   dcl-s w_Strpos1  zoned(4:0) inz;

   w_Keyword = Keyword;
   w_StrPos = %scan(%trim(w_Keyword):w_ClStatement:1);

   if w_StrPos <> 0;

      w_StrPos = w_StrPos + %len(%trim(w_keyword));
      w_StrPos1 = w_StrPos;

      dow w_Strpos1 <> 0;
         if w_Endpos <> 0;
            w_StrPos1 = w_EndPos + 1;
         endif;
         w_EndPos = %scan(')' : w_ClStatement : w_StrPos1);
         if w_EndPos > 0;
            w_StrPos1 = %scan('(' : w_ClStatement: w_StrPos1);
            if w_StrPos1 > w_EndPos;
               w_StrPos1 = 0;
            endif;
         endif;
      enddo;

      w_result = %subst(w_Clstatement:w_StrPos:w_EndPos-w_StrPos);

   endif;

   return w_result;

end-proc;

//------------------------------------------------------------------------------------- //
//ProcessSourceData :
//------------------------------------------------------------------------------------- //
dcl-proc ProcessSourceData;

   dcl-pi *n;
      in_Mbrtyp1 char(10) const;
   end-pi;

   dcl-ds CmdDS;
      *n     char(10) Inz('SNDUSRMSG');
      *n     char(10) Inz('SNDPGMMSG');
      *n     char(10) Inz('SNDMSG');
      *n     char(10) Inz('SNDBRKMSG');
      CmdArr char(10) DIM(4) POS(1);
   end-ds;

   dcl-s cmdI            packed(3:0) Inz;
   dcl-s w_SourceString  char(5000)  inz;
   dcl-s w_SourceString1 char(5000)  inz;
   dcl-s Wk_Stm          char(120)   inz;
   dcl-s w_ParmPointer   pointer     inz;
   dcl-s Wk_Rrn          packed(6:0) inz;
   dcl-s w_PosEndCmt     zoned(5:0)  inz;
   dcl-s w_PosStrCmt     zoned(5:0)  inz;
   dcl-s w_FirstStmLine  ind         inz('1');
   dcl-s cmdName         char(10)    inz;
   dcl-s w_Pos           zoned(4:0)  inz;
   dcl-s tagPos          Zoned(4:0)  Inz;                                                //0008

   exec sql
     declare SrcStmt cursor for
       select upper(SOURCE_DATA), SOURCE_RRN
         from   IaQclsrc
       where  Library_Name  = trim(:uwSrcDtl.SrcLib)
         and  SourcePf_Name = trim(:uwSrcDtl.SrcSpf)
         and  Member_Name   = trim(:uwSrcDtl.SrcMbr)
         and  Source_Data   <> ' '
       order by Source_Rrn ;

   exec sql open SrcStmt;
   if sqlCode = CSR_OPN_COD;
      exec sql close SrcStmt;
      exec sql open  SrcStmt;
   endif;

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Open_SrcStmt';
      IaSqlDiagnostic(uDpsds);                                                           //0007
   endif;

   dow sqlCode = successCode;

      exec sql fetch SrcStmt into :Wk_Stm, :Wk_Rrn;
      if sqlCode < successCode;
         uDpsds.wkQuery_Name = 'Fetch_SrcStmt';
         IaSqlDiagnostic(uDpsds);                                                        //0007
         leave;
      elseif sqlcode = 100 or Wk_Stm = *blanks;
         leave;
      endif;

      monitor;

         w_SourceString = %trim(wk_stm);
         Wk_Stm2 = %trim(wk_stm);
         Wk_Rrn2 = Wk_Rrn;

         select;
         when (%scan('/*' : wk_stm) > 0
              and %scan('*/' : wk_stm : %scan('/*' : wk_stm)) = 0
              and (%subst(wk_stm:%len(%trim(wk_stm)):1)       = '+' OR
               %subst(wk_stm:%len(%trim(wk_stm)):1)       = '-' ));
            wk_stm = %replace(' ' :wk_stm :%scan('/*' : wk_stm));

         when %scan('/*' : wk_stm) > 0
              and %scan('*/' : wk_stm : %scan('/*' : wk_stm)) > 0  ;
            wk_stm = %replace(' ' :wk_stm :%scan('/*' : wk_stm)
                                  :%scan('*/' :wk_stm :%scan('/*' : wk_stm))+1);
         endsl;

         iabreakword(UwSrcDtl.srclib : UwSrcDtl.srcspf : UwSrcDtl.srcmbr :
                  // wk_rrn          : wk_stm          : wk_srcflag);                    //0010
                     ' ': wk_rrn     : wk_stm          : wk_srcflag);                    //0010

         if w_firstStmLine;
            w_FirstStmLine = *off;
            w_ParmDS.w_Repository  = in_Repository;
            w_ParmDS.w_srclib = UwSrcDtl.srclib;
            w_ParmDS.w_srcpf  = UwSrcDtl.srcSpf;
            w_ParmDS.w_srcmbr = UwSrcDtl.srcmbr;
            w_ParmDS.w_RRNStr = Wk_Rrn;
         endif;

         if %subst(w_SourceString:%len(%trim(w_SourceString)):1) = '+'
            or %subst(w_SourceString:%len(%trim(w_SourceString)):1) = '-';
            w_SourceString  = %subst(w_SourceString : 1:
                              %len(%trim(w_SourceString))-1);
            w_SourceString1 = %trim(w_SourceString1) + ' ' +
                              %trim(w_SourceString);
            iter;
         else;
            if w_SourceString1 = *blanks;
               w_SourceString1 =  %trim(w_SourceString);
            else;
               w_SourceString1 = %trimr(w_SourceString1) + ' ' +
                                 %trim(w_SourceString);
            endif;
            w_ParmDS.w_RRNEnd = Wk_Rrn;
         endif;

         w_PosEndCmt = 1;
         dow w_PosEndCmt <> 0;
            w_PosEndCmt = 0;
            w_PosStrCmt = %scan('/*' : w_SourceString1);
            if w_PosStrCmt > 0;
               w_PosEndCmt = %scan('*/' : w_SourceString1 : w_PosStrCmt);
               if w_PosEndCmt > 0;
                  w_SourceString1 = %replace(' ': w_SourceString1: w_PosStrCmt:
                                                w_PosEndCmt - w_PosStrCmt +2);
               endif;
            endif;
         enddo;

         //To remove the tag if found                                                   //0008
         w_Pos = %check(' ':w_SourceString1);                                            //0008
         tagPos = %scan(':':w_SourceString1:w_Pos);                                      //0008
         if tagPos > 0;                                                                  //0008
            w_SourceString1 = %replace(' ':w_SourceString1:                              //0008
                                       w_Pos:(tagPos-w_Pos)+1);                          //0008
         endif;                                                                          //0008

         w_ParmDS.w_String = w_SourceString1;
         w_firstStmLine    = *on;
         w_ParmPointer     = %addr(w_ParmDs);
         If w_SourceString1 = *blanks;
            w_Pos = 1;
         Else;
            w_Pos = %check(' ':w_SourceString1);
         Endif;

         select;
         //Process Override Statements
         when %subst(w_SourceString1:w_Pos:7) = 'OVRDBF '
              or %subst(w_SourceString1:w_Pos:8) = 'OVRDSPF '
              or %subst(w_SourceString1:w_Pos:8) = 'OVRPRTF ';
            IAPRSOVR(w_ParmPointer:in_MbrTyp1);

         //Process Delete Override Stmts
         when %subst(w_SourceString1:w_Pos:7) = 'DLTOVR ';
            IAPRSDOVR(w_ParmPointer:in_MbrTyp1);

         //Process Submit Job Stmts
         when %subst(w_SourceString1:w_Pos:7) = 'SBMJOB ';
            IAPRSSOVR(w_ParmPointer:in_MbrTyp1);

         //Process Call Stmts
         when %subst(w_SourceString1:w_Pos:5) = 'CALL ';
            IAPRCSOVR(w_ParmPointer);

         //Process Declare File Stmts
         when %subst(w_SourceString1:w_Pos:5) = 'DCLF ';
            IAPRDFOVR(w_ParmPointer:in_MbrTyp1);                                         //0009

         //Process Declare Variable Stmts
         when %subst(w_SourceString1:w_Pos:4) = 'DCL ';
            IAPRDVVAR(w_ParmPointer);

         //Process Entry Param Stmts
         when %subst(w_SourceString1:w_Pos:4) = 'PGM ';
            if  %check(' ' : w_SourceString1 : w_Pos + 4) <> 0;
                IAPREPOVR(w_ParmPointer);
            endif;

         //Process Add File Stmts
         when (%subst(w_SourceString1:w_Pos:7) = 'ADDPFM ') or
              (%subst(w_SourceString1:w_Pos:5) = 'RMVM ');
            IAPRADDPFM(w_ParmPointer:in_MbrTyp1);

         //Process Change LF Stmts
         when %subst(w_SourceString1:w_Pos:6) = 'CHGLF ';
            IAPRCHGLF(w_ParmPointer);

         //Process Change PF MBR Stmts
         when %subst(w_SourceString1:w_Pos:7) = 'CHGPFM ';
            IAPRCHGPFM(w_ParmPointer);

         //Process Clear PF Stmts
         when (%subst(w_SourceString1:w_Pos:7) = 'CLRPFM ') or
              (%subst(w_SourceString1:w_Pos:7) = 'RGZPFM ');
            IAPRCLRPFM(w_ParmPointer:in_MbrTyp1);

         //Clear File Stmts
         when %subst(w_SourceString1:w_Pos:5) = 'CPYF ';
              IAPRCPYF(w_ParmPointer:in_MbrTyp1);

         //Change PF  Stmts
         when %subst(w_SourceString1:w_Pos:6) = 'CHGPF ';
            IAPRCHGPF(w_ParmPointer);

         //Change LFM Stmts
         when %subst(w_SourceString1:w_Pos:7) = 'CHGLFM ';
            IAPRCHGLFM(w_ParmPointer);

         //Change IACPYFRMIMPF
         when %subst(w_SourceString1:w_Pos:11) = 'CPYFRMIMPF ';
            IACPYFRMIMPF(w_ParmPointer);

         //Change IACPYTOSTMF
         when %subst(w_SourceString1:w_Pos:10) = 'CPYTOSTMF ' ;
            IACPYTOSTMF(w_ParmPointer);

         //Change IAPRCRTPF
         when (%subst(w_SourceString1:w_Pos:6) = 'CRTPF ') or
              (%subst(w_SourceString1:w_Pos:5) = 'DLTF ');
            IAPRCRTPF(w_ParmPointer:in_MbrTyp1);

         //Change IAPRCRTLF
         when %subst(w_SourceString1:w_Pos:6) = 'CRTLF ';
            IAPRCRTLF(w_ParmPointer);

         //Change IAPRCHGPFCST
         when %subst(w_SourceString1:w_Pos:9) = 'CHGPFCST ';
            IAPRCHGPFCST(w_ParmPointer);

         //Change IAPRCHGPFTRG
         when %subst(w_SourceString1:w_Pos:9) = 'CHGPFTRG ';
            IAPRCHGPFTRG(w_ParmPointer);

         //Change IAPRCHGPRTF
         when (%subst(w_SourceString1:w_Pos:8) = 'CHGPRTF ')                             //0004
              or (%subst(w_SourceString1:w_Pos:8) = 'CRTPRTF ');                         //0004
            IAPRCHGPRTF(w_ParmPointer);

         //Change IAPRCRTDSPF
         when %subst(w_SourceString1:w_Pos:8) = 'CRTDSPF ';
            IAPRCRTDSPF(w_ParmPointer);

         //Change IAPRSTRJRNPF
         when %subst(w_SourceString1:w_Pos:9) = 'STRJRNPF ';
            IAPRSTRJRNPF(w_ParmPointer);

         //Create DOBJ Stmts
         when %subst(w_SourceString1:w_Pos:10) = 'CRTDUPOBJ ';
            IAPRCRTOBJ(w_ParmPointer);

         //CHGVAR Stmt Parsing
         when %subst(w_SourceString1:w_Pos:7) = 'CHGVAR ';
            IAPSRCLCHG(w_ParmPointer);

         //CL DTAARA Stmt Parsing
         when %subst(w_SourceString1:w_Pos+3:7) = 'DTAARA ';
            IAPSRDTAARA(w_ParmPointer:in_MbrTyp1);

         //Four major CL commands used to send messages
         when (%subst(w_SourceString1:w_Pos:10) = 'SNDUSRMSG ')
              or (%subst(w_SourceString1:w_Pos:10) = 'SNDPGMMSG ')
              or (%subst(w_SourceString1:w_Pos:7) = 'SNDMSG ')
              or (%subst(w_SourceString1:w_Pos:10) = 'SNDBRKMSG ');
            Clear cmdName;
            for cmdI = 1 to %elem(CmdArr);
              // Find the command name which is getting parsed.
              if %scan(%SUBST(CmdArr(cmdI):1:%LEN(%TRIM(CmdArr(cmdI)))+1)
                 : w_SourceString1) <> 0;
                 CmdName = CmdArr(cmdI);
                 Leave;
              endif;
            endfor;

            IASNDUSRMSG(w_ParmPointer : cmdName);

         //CL Subroutine
         when (%subst(w_SourceString1:w_Pos:9) = 'CALLSUBR ')
              or (%subst(w_SourceString1:w_Pos:5) = 'SUBR ')
              or (%subst(w_SourceString1:w_Pos:8) = 'RTNSUBR ')
              or (%subst(w_SourceString1:w_Pos:8) = 'ENDSUBR ');
            select;
            when %scan('SUBR '     : %trim(w_SourceString1)) <> *zeros;
               if %scan('CALLSUBR ' : %trim(w_SourceString1)) = *zeros;
                  w_ParmDS.w_sbrnam = IAPSRCL_scanKeyword(' SUBR(': w_SourceString1);
               endif;
            when %scan('RTNSUBR ': %trim(w_SourceString1)) <> *zeros;
               clear w_ParmDS.w_sbrnam;
            when %scan('ENDSUBR ': %trim(w_SourceString1)) <> *zeros;
               clear w_ParmDS.w_sbrnam;
            endsl;
            IAPSRCLSBR(w_ParmPointer);
         //----------- User Defined Command -------------------- //
         other;                                                                          //0002
            //To exclude unhandled IBM commands                                         //0008
            otherCLcmd = %subst(w_SourceString1:w_Pos:                                   //0008
                         (%scan(' ':w_SourceString1:w_Pos)-w_Pos));                      //0008
            if %scan('/':otherCLcmd) > 0;                                                //0008
               otherCLcmd = %subst(otherCLcmd:%scan('/':otherCLcmd)+1:                   //0008
                                   %len(otherCLcmd)-%scan('/':otherCLcmd));              //0008
            endif;                                                                       //0008

            if %Lookup(otherCLcmd:otherCLcmds) = 0;                                      //0008
               IAPSRUSRCMD(w_ParmPointer:in_MbrTyp1);                                    //0002
            endif;                                                                       //0008

         endsl;

      on-error;
         Write_RRN1_Error () ;
      endmon;

      w_SourceString1 = *blanks;
   enddo;
   exec sql close SrcStmt;

end-proc;
//------------------------------------------------------------------------------------- //
//Write_RRN1_Error :
//------------------------------------------------------------------------------------- //
dcl-proc Write_RRN1_Error;

   exec sql
     insert into iAExcPLog (Prs_Source_Lib,
                            Prs_Source_File,
                            PRS_SOURCE_SRC_MBR,
                            Library_Name,
                            Program_Name,
                            Rrn_No,
                            Exception_Type,
                            Exception_No,
                            Exception_Data,
                            Source_Stm,
                            Module_Pgm,
                            Module_Proc)
       values(trim(:uwSrcDtl.SrcLib),
                trim(:uwSrcDtl.SrcSpf),
                trim(:uwSrcDtl.SrcMbr),
                trim(:uDpsds.SrcLib),
                trim(:uDpsds.ProcNme),
                trim(char(:wk_Rrn2)),
                trim(:uDpsds.ExcpTTyp),
                trim(:uDpsds.ExcpTNbr)    ,
                trim(:uDpsds.RtvExcPTdt)   ,
                trim(:wk_Stm2),
                trim(:uDpsds.ModulePgm),
                trim(:uDpsds.ModuleProc));

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Insert_IAEXCPLOG';
      IaSqlDiagnostic(uDpsds);                                                           //0007
   endif;

end-proc;
** CTDATA otherCLcmds                                                                    //0008
ENDPGM                                                                                   //0008
MONMSG                                                                                   //0008
RUNSQL                                                                                   //0008
QSH                                                                                      //0008
