**free
      //%METADATA                                                      *
      // %TEXT Performance Testing                                     *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------ //
//CREATED BY :   Programmers.io @ 2020                                                 //
//CREATE DATE:   2020/01/01                                                            //
//DEVELOPER  :   Kaushal Kumar                                                         //
//DESCRIPTION:   Main Parser Program                                                   //
//                                                                                     //
//PROCEDURE LOG:                                                                       //
//------------------------------------------------------------------------------------ //
//Procedure Name           | Procedure Description                                     //
//-------------------------|---------------------------------------------------------- //
//No Procedure             |                                                           //
//------------------------------------------------------------------------------------ //
//                                                                                     //
//MODIFICATION LOG:                                                                    //
//------------------------------------------------------------------------------------ //
//Date    | Mod_ID | Developer  | Case and Description                                 //
//--------|--------|------------|----------------------------------------------------- //
//05/04/22| AK09   |ASHWANI KR  | Adding cursor open check and wkSqlstmtNbr logic      //
//27/01/23|        |Pranav J.   | Remcompile for IaPsrVARfr and IAPSRDSFR param changes//
//04/07/24| 0001   | Vamsi      | Rename Bnddir AIERRBND, copybooks AICERRLOG/AIDERRLOG//
//        |        |            | and procedures AISQLDIAGNOSTIC and AIPSSRERRORLOG    //
//        |        |            | with IA*  [Task#261]                                 //
//08/28/24| 0002   | Vishwas K  | IFS Member Parsing Enhancements                      //
//------------------------------------------------------------------------------------ //
ctl-opt copyright('Copyright @ Programmers.io © 2022 ');
ctl-opt option(*nodebugio:*srcstmt:*nounref);
ctl-opt bndDir('IABNDDIR' : 'IAERRBND');                                                 //0001

dcl-pi IAPSRCSPCR extpgm('IAPSRCSPCR');
   uwxref char(10);
end-pi;

/copy 'QMODSRC/iasrv01pr.rpgleinc'
/copy 'QMODSRC/iasrv02pr.rpgleinc'
/copy 'QCPYSRC/iaderrlog.rpgleinc'

dcl-ds uwkldtl extname('IAPGMKLIST') qualified inz;
end-ds;

dcl-ds uwdsdtl extname('IAPGMDS') qualified inz;
end-ds;

dcl-ds UwSrcDtl1 qualified inz;
   srclib char(10);
end-ds;

dcl-ds UwSrcDtl2 qualified inz;
   srclib char(10);
   srcSpf char(10);
end-ds;

dcl-ds UwSrcDtl qualified inz;
   srclib char(10);
   srcSpf char(10);
   srcmbr char(10);
   ifsloc  char(100);                                                                    //0002
// mbrtyp char(4);                                                                       //0002
   mbrtyp1 char(10);
   srcStat char(1);                                                                      //0002
end-ds;

dcl-ds uwdstyp qualified inz;
   dsfile char(10);
   dsinfds char(128);
   dsindds char(128);
end-ds;

dcl-s in_procedure    ind          inz;                                                  //YK04
dcl-s r_Stm        char(120)   inz;
dcl-s r_tfree      char(1)     inz('N');
dcl-s r_mfree      char(1)     inz('N');
dcl-s r_fix        char(1)     inz;
dcl-s r_iter       char(1)     inz('N');
dcl-s r_error      char(10)    inz('N');
dcl-s r_type       char(10)    inz('N');
dcl-s r_dsdcl      char(3)     inz;
dcl-s r_string     char(5000)  inz;
dcl-s r_cat        char(1)     inz;
dcl-s r_dsmody     char(10)    inz;
dcl-s r_dsobjv     char(10)    inz;
dcl-s r_dsname     char(128)   inz;
dcl-s r_sts        char(7)     inz;
dcl-s r_lname      char(30)    inz;
dcl-s r_prc        char(80)    inz;
dcl-s r_word       char(30)    inz;
dcl-s r_ext        char(1)     inz('N');
dcl-s r_subrflg    char(1)     inz('N');
dcl-s r_subrNAM    char(20)    inz;
dcl-s r_longprname char(50)    inz;
dcl-s r_prstring   char(5000)  inz;
dcl-s r_stringnew  char(5000)  inz;
dcl-s r_pos1       packed(4:0) inz;
dcl-s r_pos2       packed(4:0) inz;
dcl-s r_rrn        packed(6:0) inz;
dcl-s r_rrns       packed(6:0) inz;
dcl-s r_rrnext     packed(6:0) inz;
dcl-s r_rrne       packed(6:0) inz;
dcl-s r_pos7       packed(4:0) inz;
dcl-s r_pos8       packed(4:0) inz;
dcl-s r_spos       packed(4:0) inz(1);
dcl-s r_seq        packed(5:0) inz;
dcl-s r_lpos       packed(5)   inz;
dcl-s r_dcls       packed(5:0) inz;
dcl-s r_likepos    packed(5:0) inz;
dcl-s r_CPYBpos    packed(5)   inz;
dcl-s r_pos3       packed(4:0) inz;
dcl-s r_callCPYB   ind         inz;


exec sql
  set option commit = *none,
             naming = *sys,
             usrprf = *user,
             dynusrprf = *user,
             closqlcsr = *endmod;

Eval-corr uDpsds = wkuDpsds;                                                           //MT22
exec sql
  declare Library cursor for
    select DISTINCT LIBRARY_NAME
      from #IADTA/IAINPLIB
     where XREF_NAME = trim(:uwXref);

exec sql open Library;
if sqlCode = CSR_OPN_COD;                                                                 //AK09
   exec sql close Library;                                                                //AK09
   exec sql open  Library;                                                                //AK09
endif;                                                                                    //AK09

if sqlCode < successCode;
   uDpsds.wkQuery_Name = 'Open_Library';                                                  //MT22
   IaSqlDiagnostic(uDpsds);                                                              //0001
endif;

if sqlCode = successCode;
   exec sql fetch Library into :UwSrcDtl1;

   if sqlCode < successCode;                                                             //MT22
      uDpsds.wkQuery_Name = 'Fetch_1_Library';                                           //MT22
      IaSqlDiagnostic(uDpsds);                                                  //0001   //MT22
   endif;                                                                                //MT22

   dow sqlCode = successCode;

      // ----------------- Get Distinct SRC-PF Cursor Begin ------------- *//
      exec sql
        declare SourcePf cursor for
          select LIBRARY_NAME, SRCPF_NAME
            from IASRCPF
           where LIBRARY_NAME = trim(:uwSrcDtl1.SrcLib);

      exec sql open SourcePf;
      if sqlCode = CSR_OPN_COD;                                                           //AK09
         exec sql close SourcePf;                                                         //AK09
         exec sql open  SourcePf;                                                         //AK09
      endif;                                                                              //AK09

      if sqlCode < successCode;
         uDpsds.wkQuery_Name = 'Open_SourcePF';                                           //MT22
         IaSqlDiagnostic(uDpsds);                                                        //0001
      endif;

      if sqlCode = successCode;
         exec sql fetch SourcePf into :UwSrcDtl2;
         if sqlCode < successCode;                                                       //MT22
            uDpsds.wkQuery_Name = 'Fetch_1_SourcePF';                                    //MT22
            IaSqlDiagnostic(uDpsds);                                            //0001   //MT22
         endif;                                                                          //MT22
         dow sqlCode = successCode;

            exec sql
              declare Member cursor for
                select MLLIB, MLFILE, MLNAME, MLSEU, MLSEU2
                  from IDSPFDMBRL
                 where MLLIB = trim(:uwSrcDtl2.SrcLib)
                   and MLFILE = trim(:uwSrcDtl2.SrcSpf)
                   and MLSEU2 like '%RPG%';

            exec sql open Member;
            if sqlCode = CSR_OPN_COD;                                                     //AK09
               exec sql close Member;                                                     //AK09
               exec sql open  Member;                                                     //AK09
            endif;                                                                        //AK09

            if sqlCode < successCode;
               uDpsds.wkQuery_Name = 'Open_Member' ;                                      //MT22
               IaSqlDiagnostic(uDpsds);                                                  //0001
            endif;

            if sqlCode = successCode;
               exec sql fetch Member into :UwSrcDtl;
               if sqlCode < successCode;                                                  //MT22
                  uDpsds.wkQuery_Name = 'Fetch_1_Member';                                 //MT22
                  IaSqlDiagnostic(uDpsds);                                       //0001   //MT22
               endif;                                                                     //MT22

               dow sqlCode = successCode;
                  r_type  = UwSrcDtl.mbrtyp1;
                  r_tfree = 'N';
                  r_mfree = 'N';
                  r_fix   = ' ';
                  exsr processRpgSource;
                  reset R_SubrNam;
                  exec sql fetch Member into :UwSrcDtl;
                  if sqlCode < successCode;                                                 //MT22
                     uDpsds.wkQuery_Name = 'Fetch_2_Member';                                //MT22
                     IaSqlDiagnostic(uDpsds);                                      //0001   //MT22
                  endif;                                                                    //MT22
               enddo;
               exec sql close Member;
            endif;

            exec sql fetch SourcePf into :UwSrcDtl2;
            if sqlCode < successCode;                                                       //MT22
               uDpsds.wkQuery_Name = 'Fetch_2_SourcePf';                                    //MT22
               IaSqlDiagnostic(uDpsds);                                             //0001  //MT22
            endif;                                                                          //MT22
         enddo;
         exec sql close SourcePf;
      endif;

      // ----------------- Get Distinct SRC-PF Cursor End --------------- *//
      exec sql fetch Library into :UwSrcDtl1;
      if sqlCode < successCode;                                                       //MT22
         uDpsds.wkQuery_Name = 'Fetch_2_Library';                                     //MT22
         IaSqlDiagnostic(uDpsds);                                              //0001 //MT22
      endif;                                                                          //MT22
   enddo;
   exec sql close Library;
endif;

//-------------------- Get Distinct Libraries Cursor Begin -------------- *//
*inlr = *on;
return;

/copy 'QCPYSRC/iacerrlog.rpgleinc'

//--------------------------------------------------------------------
//Fetch_Specs :
//---------------------------------------------------------------------
begsr Fetch_Specs;

   r_iter = 'N';

   //----------------- If full Free Code ---------------------------- *//
   if r_tfree = 'N' and  %scan('**FREE': r_stm : 1) = 1;
      r_tfree = 'Y';
      exsr clear_vars;
      exec sql fetch SrcStmt into :r_stm, :r_rrn;
      if sqlCode < successCode;                                                             //MT22
         uDpsds.wkQuery_Name = 'Fetch_6_srcStmt';                                           //MT22
         IaSqlDiagnostic(uDpsds);                                                  //0001   //MT22
      endif;                                                                                //MT22
      r_iter = 'Y';
      leavesr;
   endif;

   //----------------- If /FREE Is Encountered ---------------------- *//
   if r_mfree = 'N' and %scan('/FREE':r_stm :7) > 0;
      r_mfree = 'Y';
      exsr clear_vars;
      exec sql fetch SrcStmt into :r_stm, :r_rrn;
      if sqlCode < successCode;                                                             //MT22
         uDpsds.wkQuery_Name = 'Fetch_7_srcStmt';                                           //MT22
         IaSqlDiagnostic(uDpsds);                                                  //0001   //MT22
      endif;                                                                                //MT22

      r_iter = 'Y';
      leavesr;
   endif;

   //----------------- If /END-FREE IS Encountered ------------------ *//
   if %scan('/END-FREE':r_stm :7) > 1;
      r_mfree = 'N';
      exsr clear_vars;
      exec sql fetch SrcStmt into :r_stm, :r_rrn;
      if sqlCode < successCode;                                                             //MT22
         uDpsds.wkQuery_Name = 'Fetch_8_srcStmt';                                           //MT22
         IaSqlDiagnostic(uDpsds);                                                  //0001   //MT22
      endif;                                                                                //MT22
      r_iter = 'Y';
      leavesr;
   endif;

   //----------------- If FIXED Is Encountered ---------------------- *//
   if r_tfree = 'N' and r_mfree = 'N' and
      (%scan('H': r_stm : 6) = 6 or %scan('F': r_stm : 6) = 6 or
       %scan('D': r_stm : 6) = 6 or %scan('E': r_stm : 6) = 6 or
       %scan('I': r_stm : 6) = 6 or %scan('C': r_stm : 6) = 6 or
       %scan('O': r_stm : 6) = 6 or %scan('P': r_stm : 6) = 6 );
      r_fix = %subst(r_stm  : 6 : 1);
   endif;

endsr;
//----------------------------------------------------------------------------
//Clear_Vars :
//----------------------------------------------------------------------------
begsr Clear_Vars;

   clear r_rrns;
   clear r_rrne;
   clear r_string;

endsr;
//----------------------------------------------------------------------------
//Format_String :
//----------------------------------------------------------------------------
begsr Format_String;

   r_iter = 'N';
   //----------------- If Total free and full line is commented ----- *//
   if r_tfree = 'Y' and %scan('//': %trim(r_stm ):1) = 1;
      if r_string <> *blanks;
         exec sql fetch SrcStmt into :r_stm, :r_rrn;
         If sqlCode < successCode;                                                       //MT22
            uDpsds.wkQuery_Name = 'Fetch_9_srcStmt';                                     //MT22
            IaSqlDiagnostic(uDpsds);                                             //0001  //MT22
         Endif;                                                                          //MT22
         r_iter = 'Y';
         leavesr;
      elseif r_string = *blanks;
         exsr clear_vars;
         exec sql fetch SrcStmt into :r_stm, :r_rrn;
         If sqlCode < successCode;                                                       //MT22
            uDpsds.wkQuery_Name = 'Fetch_10_srcStmt';                                    //MT22
            IaSqlDiagnostic(uDpsds);                                              //0001 //MT22
         Endif;                                                                          //MT22
         r_iter = 'Y';
         leavesr;
      endif;
   endif;

   //----------------- If total free and partial commented line ----- *//
   if r_tfree = 'Y' and %scan('//': %trim(r_stm ):1) > 1;
      r_pos1 = %scan('//': %trim(r_stm ):1);
      r_stm = %subst(%trim(r_stm ):1:r_pos1-1);
   endif;

   //----------------- If Mixed free, Remove the TAGS --------------- *//
   if r_mfree = 'Y';
      r_stm = %replace('     ':r_stm:1:5);
   endif;

   //----------------- If Mixed free and full line is commented ----- *//
   if r_mfree = 'Y' and %scan('//': %trim(r_stm ):1) = 1;
      if r_string <> *blanks;
         exec sql fetch SrcStmt into :r_stm, :r_rrn;
         If sqlCode < successCode;                                                       //MT22
            uDpsds.wkQuery_Name = 'Fetch_11_srcStmt';                                    //MT22
            IaSqlDiagnostic(uDpsds);                                            //0001   //MT22
         Endif;                                                                          //MT22
         r_iter = 'Y';
         leavesr;
      elseif r_string = *blanks;
         exsr clear_vars;
         exec sql fetch SrcStmt into :r_stm, :r_rrn;
         If sqlCode < successCode;                                                       //MT22
            uDpsds.wkQuery_Name = 'Fetch_12_srcStmt';                                    //MT22
            IaSqlDiagnostic(uDpsds);                                             //0001  //MT22
         Endif;                                                                          //MT22
         r_iter = 'Y';
         leavesr;
      endif;
   endif;

   //----------------- If Mixed free and partial commented line ----- *//
   if r_mfree = 'Y' and %scan('//': %trim(r_stm ):1) > 1;
      r_pos1 = %scan('//': %trim(r_stm ):1);
      r_stm  = %subst(%trim(r_stm ):1:r_pos1-1);
   endif;

   //----------------- If Fixed , Remove the TAGS ------------------- *//
   if r_fix <> *blanks;
      r_stm = %replace('     ':r_stm:1:5);
   endif;

   //----------------- If Fixed and full line is commented ---------- *//
   if %len(%trimr(r_stm)) >= 7;
      if r_tfree = 'N' and r_mfree = 'N' and %scan('*': r_stm  :7) = 7;
         r_pos1 = %scan('*': r_stm  :7);
         if r_string <> *blanks;
            exec sql fetch SrcStmt into :r_stm, :r_rrn;
            If sqlCode < successCode;                                                       //MT22
               uDpsds.wkQuery_Name = 'Fetch_13_srcStmt';                                    //MT22
               IaSqlDiagnostic(uDpsds);                                             //0001  //MT22
            Endif;                                                                          //MT22
            r_iter = 'Y';
            leavesr;
         elseif r_string = *blanks;
            exsr clear_vars;
            exec sql fetch SrcStmt into :r_stm, :r_rrn;
            If sqlCode < successCode;                                                       //MT22
               uDpsds.wkQuery_Name = 'Fetch_14_srcStmt';                                    //MT22
               IaSqlDiagnostic(uDpsds);                                              //0001 //MT22
            Endif;                                                                          //MT22

            r_iter = 'Y';
            leavesr;
         endif;
      endif;
   endif;

   //----------------- If Fixed , Remove the TAGS ------------------- *//
   if r_fix = *blanks And r_tfree = 'N' And r_mfree = 'N';
      r_stm = %replace('      ':r_stm:1:6);
      if %scan('//':%trim(r_stm):1) = 1;
         if r_string <> *blanks;
            exec sql fetch SrcStmt into :r_stm, :r_rrn;
            If sqlCode < successCode;                                                       //MT22
               uDpsds.wkQuery_Name = 'Fetch_15_srcStmt';                                    //MT22
               IaSqlDiagnostic(uDpsds);                                             //0001  //MT22
            Endif;                                                                          //MT22
            r_iter = 'Y';
            leavesr;
         elseif r_string = *blanks;
            exsr clear_vars;
            exec sql fetch SrcStmt into :r_stm, :r_rrn;
            If sqlCode < successCode;                                                       //MT22
               uDpsds.wkQuery_Name = 'Fetch_16_srcStmt';                                    //MT22
               IaSqlDiagnostic(uDpsds);                                             //0001  //MT22
            Endif;                                                                          //MT22
            r_iter = 'Y';
            leavesr;
         endif;
      elseif %scan('//': %trim(r_stm ):1)>1;
         r_pos1 = %scan('//': %trim(r_stm ):1);
         r_stm  = %subst(%trim(r_stm ):1:r_pos1-1);
      endif;
   endif;

endsr;
//-------------------------------------------------------------------------------
//Process_SQL :
//-------------------------------------------------------------------------------
begsr Process_SQL;

   r_iter = 'N';

   //----------------- Remove 'C+' ---------------------------------- *//
   if %scan('C+': r_string : 1) > 0;
      clear r_pos2;
      r_pos2 = %scan('C+': r_string : 1);
      r_string = %replace('': r_string : r_pos2 : 2);
   endif;

   //----------------- Remove 'C/' ---------------------------------- *//
   if %scan('C/': r_string : 1) > 0;
      clear r_pos2;
      r_pos2 = %scan('C/': r_string : 1);
      r_string = %replace('': r_string : r_pos2: 2);
   endif;

   //----------------- Concate Complete Statement Till End ---------- *//
   if not (%scan('END-EXEC': r_string :1) > 0 or
           ProcessScanR(';': r_string) > 0);
      exec sql fetch SrcStmt into :r_stm, :r_rrn;
      If sqlCode < successCode;                                                       //MT22
         uDpsds.wkQuery_Name = 'Fetch_17_srcStmt';                                    //MT22
         IaSqlDiagnostic(uDpsds);                                             //0001  //MT22
      Endif;                                                                          //MT22
      r_iter = 'Y';
      leavesr;
   endif;

   //----------------- Parse Sql Statement -------------------------- *//
   IAPSRSQL(r_string        : r_type           : r_error          :
       //   uwxref          : UwSrcDtl.srclib  : UwSrcDtl.srcspf  :                      //0002
       //   UwSrcDtl.srcmbr : r_rrns           : r_rrne);                                //0002
            uwxref          : UwSrcDtl         : r_rrns           :                      //0002
            r_rrne);                                                                     //0002

   if r_error = 'C';
      exsr clear_vars;
   endif;

endsr;
//----------------------------------------------------------------------------//
//Process_DS_fr;
//----------------------------------------------------------------------------//
begsr Process_DS_fr;

   r_iter = 'N';
   r_sts = 'DSFRN';

   //----------------- Concate Complete Statement Till End ---------- *//
   if ProcessScanR(';': r_string) = 0;
      exec sql fetch SrcStmt into :r_stm, :r_rrn;
      If sqlCode < successCode;                                                       //MT22
         uDpsds.wkQuery_Name = 'Fetch_18_srcStmt';                                    //MT22
         IaSqlDiagnostic(uDpsds);                                             //0001  //MT22
      Endif;                                                                          //MT22
      r_iter = 'Y';
      leavesr;
   endif;

   //----------------- Format String Into Single Spacing String ----- *//
   exsr snglspcstring;

   //----------------- Define String Type DS/DS-FLD/END-DS ---------- *//
   select;
   //----------------- When END-DS is found ------------------------- *//
   when %scan('END-DS' : %trim(r_string)) = 1;

      //--------------- If Status Is DS, Write DS info into IAPGMDS -- *//
      if r_dsdcl = 'DS';
         r_dsdcl = 'WDS';
         IAPSRDSFR(r_string         : r_type          : r_error         : uwxref   :
                // UwSrcDtl.srclib  : UwSrcDtl.srcspf : UwSrcDtl.srcmbr : r_rrns   :     //0002
                   UwSrcDtl         : r_rrns          :                                  //0002
                   r_rrne           : r_dsdcl         : r_dsobjv        : r_dsname :
                   r_dsmody         : uwdsdtl );
      endif;

      //--------------- Clear DS Related Variables ------------------- *//
      clear r_dsdcl;
      clear r_sts;
      clear r_dsobjv;
      clear r_dsname;
      clear r_dsmody;
      clear uwdsdtl;
      leavesr;

   //----------------- When DS Declaration -------------------------- *//
   when r_dsdcl = *blanks;
      r_dsdcl = 'DS';
      r_pos7  = %scan(' ' : %trim(r_string));

      select;
      when %scan(' ' : %trim(r_string) : r_pos7 + 1) > 0;
         r_pos8 = %scan(' ' : %trim(r_string) : r_pos7 + 1);
      when %scan(';' : %trim(r_string) : r_pos7 + 1) > 0;
         r_pos8 = %scan(';' : %trim(r_string) : r_pos7 + 1);
      endsl;

      //----------------- Find DS Name And Objective ----------------- *//
      r_dsname = %subst(%trim(r_string) : r_pos7 + 1 : r_pos8 - r_pos7 - 1);

      if r_dsname <> *blanks;
         exsr finddsdtl;
      endif;

      select;
      when r_dsobjv = 'INFDS-VAR';
      when r_dsobjv = 'INDDS-VAR';
      when %scan(' PSDS' : %trim(r_string)) > 0;
         r_dsobjv = 'PSDS-VAR';
      other;
         r_dsobjv = 'DS-VAR';
      endsl;

   //----------------- When DS Field Declaration -------------------- *//
   other;
      clear r_dsname;
      clear r_dsmody;
      r_dsdcl  = 'DSS';
      r_pos7   = %scan('-' : r_dsobjv);
      r_dsobjv = %replace('SUB': r_dsobjv : r_pos7+1 : 3);
   endsl;

   //----------------- Parse Data Structure (Free) ------------------ *//
   IAPSRDSFR(r_string        : r_type          : r_error         : uwxref   :
          // UwSrcDtl.srclib  : UwSrcDtl.srcspf : UwSrcDtl.srcmbr : r_rrns  :            //0002
             UwSrcDtl         : r_rrns          :                                        //0002
             r_rrne          : r_dsdcl         : r_dsobjv        : r_dsname :
             r_dsmody        : uwdsdtl );

   r_error = 'C';    //add logic
   if r_error = 'C';
      r_iter = 'N';
      if %scan(' END-DS' : %trim(r_string)) > 0;
         if r_dsdcl = 'DS';
            r_dsdcl = 'WDS';
            IAPSRDSFR(r_string        : r_type          : r_error         : uwxref   :
                  // UwSrcDtl.srclib  : UwSrcDtl.srcspf : UwSrcDtl.srcmbr : r_rrns   :   //0002
                     UwSrcDtl         : r_rrns          :                                //0002
                      r_rrne          : r_dsdcl         : r_dsobjv        : r_dsname :
                      r_dsmody        : uwdsdtl );
         endif;
         clear r_dsdcl;
         clear r_sts;
         clear r_dsobjv;
         clear r_dsname;
         clear r_dsmody;
         clear uwdsdtl;
      endif;
      exsr clear_vars;
   endif;

endsr;
//----------------------------------------------------------------------------//
//Process_DS_fx :
//----------------------------------------------------------------------------//
begsr Process_DS_fx;

   r_iter = 'N';
   r_sts = 'DSFXN';

   //----------------- Concate Complete String Till End ------------- *//
   if (ProcessScan4('  ' : r_stm : 24 : 2) <> 0 or
       ProcessScan4('DS' : r_stm : 24 : 2) > 0) and r_fix = 'D';
      dow 1 = 1;
         exec sql fetch SrcStmt into :r_Stm, :r_Rrn;
         If sqlCode < successCode;                                                       //MT22
            uDpsds.wkQuery_Name = 'Fetch_19_srcStmt';                                    //MT22
            IaSqlDiagnostic(uDpsds);                                          //0001     //MT22
         Endif;                                                                          //MT22
         exsr fetch_specs;
         exsr Format_string;
         if r_iter ='Y';
            r_iter = 'N';
            leave;
         endif;
         if %subst(r_stm:6:1)  = 'D'        and
            %subst(r_stm:7:36) = *blanks    and
            %subst(r_stm:44:%len(r_stm)-44) <> *blanks;
            r_stm = %subst(r_stm:7:%len(r_stm)-7);
            if %len(%trimr(r_string)) > 44;
               %subst(r_string : %len(%trimr(r_string))+2 :
                     (%len(r_string) - (%len(%trimr(r_string)) + 2))) = %trim(r_stm);
            else;
               %subst(r_string : 44 : (%len(r_string))- 44) = %trim(r_stm);
            endif;
         else;
            leave;
         endif;
      enddo;
   endif;

   //----------------- Define String Type DS/DS-FLD/END-DS ---------- *//
   select;
   when r_dsdcl = *blanks or %subst(r_string : 24 : 2) = 'DS';
      if r_dsdcl = 'DS';
         r_dsdcl = 'WDS';
         IAPSRDSFX(r_string        : r_type          : r_error          : uwxref   :
                // UwSrcDtl.srclib : UwSrcDtl.srcspf : UwSrcDtl.srcmbr  : r_rrns   :     //0002
                   UwSrcDtl        : r_rrns          :                                   //0002
                   r_rrne          : r_dsdcl         : r_dsobjv         : r_dsname :
                   r_dsmody        : uwdsdtl );
      endif;
      clear r_dsmody;
      clear uwdsdtl;

      r_dsdcl  = 'DS';
      r_dsname = %subst(r_string : 7 : 15);
      if r_dsname <> *blanks;
         exsr finddsdtl;
      endif;

      select;
      when r_dsobjv = 'INFDS-VAR';
      when r_dsobjv = 'INDDS-VAR';
      when (ProcessScan4('S': r_string : 23 :1) > 0);
         r_dsobjv = 'PSDS-VAR';
      other;
         r_dsobjv = 'DS-VAR';
      endsl;

   when ProcessScan4('  ' : r_string : 24 : 2) = 0 or r_fix <> 'D';
      if r_dsdcl = 'DS';
         r_dsdcl = 'WDS';
         IAPSRDSFX(r_string        : r_type          : r_error         : uwxref   :
                // UwSrcDtl.srclib : UwSrcDtl.srcspf : UwSrcDtl.srcmbr : r_rrns   :     //0002
                   UwSrcDtl        : r_rrns          :                                  //0002
                   r_rrne          : r_dsdcl         : r_dsobjv        : r_dsname :
                   r_dsmody        :  uwdsdtl );
      endif;
      clear r_dsdcl;
      clear r_sts;
      clear r_dsobjv;
      clear r_dsname;
      clear r_dsmody;
      clear uwdsdtl;
      r_iter = 'N';
      leavesr;
   other;
      clear r_dsname;
      r_dsdcl  = 'DSS';
      r_pos7   = %scan('-' : r_dsobjv);
      r_dsobjv = %replace('SUB': r_dsobjv : r_pos7+1 : 3);
   endsl;

   //----------------- Parse Data Structure ------------------------- *//
 //IAPSRDSFX(r_string        : r_type          : r_error  : uwxref : UwSrcDtl.srclib :
 //          UwSrcDtl.srcspf : UwSrcDtl.srcmbr : r_rrns   : r_rrne : r_dsdcl         :   //0002
   IAPSRDSFX(r_string        : r_type          : r_error  : uwxref  :
             UwSrcDtl        : r_rrns          : r_rrne   : r_dsdcl :
             r_dsobjv        : r_dsname        : r_dsmody : uwdsdtl );

   r_error = 'C';    //add logic
   if r_error = 'C';
      r_iter = 'Y';
      exsr clear_vars;
   endif;

endsr;
//-----------------------------------------------------------------------------
//Process_DS_rpg :
//-----------------------------------------------------------------------------
begsr Process_DS_rpg;

   r_iter = 'N';
   r_sts  = 'DSRPG3N';

   //----------------- Concate Complete Statement Till End ---------- *//
   select;
   when r_dsdcl = *blanks or %subst(r_string : 19 : 2) = 'DS';
      if r_dsdcl = 'DS';
         r_dsdcl = 'WDS';
         IAPSRDSRPG3(r_string        : r_type          : r_error         : uwxref   :
                 //  UwSrcDtl.srclib : UwSrcDtl.srcspf : UwSrcDtl.srcmbr : r_rrns   :    //0002
                     UwSrcDtl        : r_rrns          :                                 //0002
                     r_rrne          : r_dsdcl         : r_dsobjv        : r_dsname :
                     r_dsmody        : uwdsdtl );
      endif;
      clear r_dsmody;
      clear uwdsdtl;

      r_dsdcl  = 'DS';
      r_dsname = %subst(r_string : 7 : 6);

      if r_dsname <> *blanks;
         exsr finddsdtl;
      endif;

      select;
      when r_dsobjv = 'INFDS-VAR';
      when r_dsobjv = 'INDDS-VAR';
      when (ProcessScan4('S': r_string : 18 :1) > 0);
         r_dsobjv   = 'PSDS-VAR';
      other;
         r_dsobjv   = 'DS-VAR';
      endsl;

   when ProcessScan4('  ' : r_string : 19 : 2) = 0 or r_fix <> 'I';
      if r_dsdcl = 'DS';
         r_dsdcl = 'WDS';
         IAPSRDSFX(r_string        : r_type          : r_error         : uwxref   :
            //     UwSrcDtl.srclib : UwSrcDtl.srcspf : UwSrcDtl.srcmbr : r_rrns   :      //0002
                   UwSrcDtl        : r_rrns          :                                   //0002
                   r_rrne          : r_dsdcl         : r_dsobjv        : r_dsname :
                   r_dsmody        : uwdsdtl );
      endif;
      clear r_dsdcl;
      clear r_sts;
      clear r_dsobjv;
      clear r_dsname;
      clear r_dsmody;
      clear uwdsdtl;
      r_iter = 'N';
      leavesr;
   other;
      clear r_dsname;
      r_dsdcl = 'DSS';
      r_pos7 = %scan('-' : r_dsobjv);
      r_dsobjv = %replace('SUB': r_dsobjv : r_pos7+1 : 3);
   endsl;

   //----------------- Parse Data Structure ------------------------- *//
   IAPSRDSRPG3(r_string        : r_type          : r_error         : uwxref   :
           //  UwSrcDtl.srclib : UwSrcDtl.srcspf : UwSrcDtl.srcmbr : r_rrns   :          //0002
               UwSrcDtl        : r_rrns          :                                       //0002
               r_rrne          : r_dsdcl         : r_dsobjv        : r_dsname :
               r_dsmody        : uwdsdtl );

   r_error = 'C';    //ns add logic
   if r_error = 'C';
      r_iter = 'N';
      exsr clear_vars;
   endif;

endsr;
//-------------------------------------------------------------------//
//Process_VAR :
//-------------------------------------------------------------------//
begsr Process_VAR;

   r_iter = 'N';
   if %scan('DCL-S ': %trim(r_string) :1) = 1 or
      %scan('DCL-C ': %trim(r_string):1) = 1;

      //--------------- Concate Complete Statement Till End ---------- *//
      if %scan(';': r_string : %len(%trimr(r_string))) = 0;
         exec sql fetch SrcStmt into :r_Stm, :r_Rrn;
         If sqlCode < successCode;                                                       //MT22
            uDpsds.wkQuery_Name = 'Fetch_20_srcStmt';                                    //MT22
            IaSqlDiagnostic(uDpsds);                                          //0001     //MT22
         Endif;                                                                          //MT22
         r_iter = 'Y';
         leavesr;
      endif;
      if %scan(';': r_string) > 0 and
         %scan('DCL-C ': %trim(r_string):1) = 1 and r_iter = 'N';
         IAPSRVARFR(r_string        : r_type          : r_error         :
                //  uwxref          : UwSrcDtl.srclib : UwSrcDtl.srcspf :                //0002
                //  UwSrcDtl.srcmbr : r_rrns          : r_rrne          :                //0002
                    uwxref          :                                                    //0002
                    UwSrcDtl        : r_rrns          : r_rrne          :                //0002
                    in_procedure                                       );                //YK04
      endif;

      //--------------- Parse Variable ------------------------------- *//
      if %scan(';': r_string) > 0 and
         %scan('DCL-S ': %trim(r_string) :1) = 1 and r_iter = 'N';
         r_dcls = %scan('DCL-S ':r_string) + 6;
         r_dcls = %check(' ':r_string:r_dcls);
         r_dcls = %scan(' ':r_string:r_dcls);
         if %scan('LIKE':r_string:r_dcls )  > 0;
            r_likepos  = %scan('LIKE':r_string:r_dcls ) + 5;
            r_likepos  = %scan(')':r_string:r_likepos);
            if %scan('DIM':r_string:r_likepos ) = 0;
               IAPSRVARFR(r_string        : r_type          : r_error         :
                      //  uwxref          : UwSrcDtl.srclib : UwSrcDtl.srcspf :           //0002
                      //  UwSrcDtl.srcmbr : r_rrns          : r_rrne          :           //0002
                          uwxref          :                                               //0002
                          UwSrcDtl        : r_rrns          : r_rrne          :           //0002
                         in_procedure                                       );            //YK04
            endif;
            if %scan('DIM':r_string:r_likepos ) > 0;
               IAPSRARRFR(r_string        : r_type          : r_error         :
                     //   uwxref          : UwSrcDtl.srclib : UwSrcDtl.srcspf :          //0002
                     //   UwSrcDtl.srcmbr : r_rrns          : r_rrne);                   //0002
                          uwxref          : UwSrcDtl        : r_rrns          :          //0002
                          r_rrne);                                                       //0002
            endif;
         endif;
         if (%scan('DIM':r_string:r_dcls ) = 0 and
             %scan('LIKE':r_string:r_dcls ) = 0);
            IAPSRVARFR(r_string        : r_type          : r_error         :
                  //   uwxref          : UwSrcDtl.srclib : UwSrcDtl.srcspf :             //0002
                  //   UwSrcDtl.srcmbr : r_rrns          : r_rrne);                      //0002
                  //   in_procedure                                       );             //YK04 0002
                       uwxref          : UwSrcDtl        : r_rrns          :             //0002
                       r_rrne          : in_procedure    );                              //0002

         endif;
         if %scan('DIM':r_string:r_dcls ) > 0 and
            %scan('LIKE':r_string:r_dcls ) = 0;
            IAPSRARRFR(r_string        : r_type          : r_error         :
                     //   uwxref          : UwSrcDtl.srclib : UwSrcDtl.srcspf :          //0002
                     //   UwSrcDtl.srcmbr : r_rrns          : r_rrne);                   //0002
                          uwxref          : UwSrcDtl        : r_rrns          :          //0002
                          r_rrne);                                                       //0002
         endif;
         exsr clear_vars;
      endif;
   endif;

   if r_fix = 'D' and %subst(r_string:24:1) = 'C' and
      %scan('...':r_string) = 0;

      IAPSRVARFX(r_string        : r_type          : r_error         :                   //YK04
            //   uwxref          : UwSrcDtl.srclib : UwSrcDtl.srcspf :                   //YK04 0002
            //   UwSrcDtl.srcmbr : r_rrns          : r_rrne          :                   //YK04 0002
            //   r_lname         : r_word          : in_procedure   );                   //YK04 0002
                 uwxref          : UwSrcDtl        : r_rrns          :                   //0002
                 r_rrne          : r_lname         : r_word          :                   //0002
                 in_procedure   );                                                       //0002
      exsr clear_vars;
      clear r_lname;
      clear r_word;
      r_ext = 'N';
   endif;

   if r_fix = 'D' and %subst(r_string:24:1) = 'S' and %scan('...':r_string) = 0;
      if r_ext <> 'Y';
         r_rrns = r_Rrn;
      endif;
      if r_ext =  'Y';
         r_rrns = r_Rrnext;
      endif;
      exec sql fetch SrcStmt into :r_stm , :r_rrn;
      If sqlCode < successCode;                                                       //MT22
         uDpsds.wkQuery_Name = 'Fetch_21_srcStmt';                                    //MT22
         IaSqlDiagnostic(uDpsds);                                             //0001  //MT22
      Endif;                                                                          //MT22
      r_stringnew = r_stm;

      dow (%len(%trimr(r_stringnew)) > 43 and
           %subst(r_stringnew:6:1) =  'D' and
           %subst(r_stringnew:7:1) <> '*' and
           %subst(r_stringnew:24:1) = ' ') or
           (%len(%trim(r_stringnew)) < 3 )or
           (r_stringnew  = *blanks) or
           (%subst(r_stringnew:7:1) = '*');
         if %len(%trimr(r_stringnew)) > 43 and
            %subst(r_stringnew:6:1) =  'D' and
            %subst(r_stringnew:24:1) = ' ' and
            %subst(r_stringnew:7:1) <> '*';
            r_string = %trimr(r_string) + '    ' + %trim(%subst(r_stm:44:36));
         endif;
         exec sql fetch SrcStmt into :r_stm , :r_rrn;
         If sqlCode < successCode;                                                       //MT22
            uDpsds.wkQuery_Name = 'Fetch_22_srcStmt';                                    //MT22
            IaSqlDiagnostic(uDpsds);                                          //0001     //MT22
         Endif;                                                                          //MT22
         r_stringnew = r_stm;
      enddo;

      if %scan('DIM': %subst(r_string:44)) = 0  and
         %scan('LIKE': %subst(r_string:44)) = 0;
         IAPSRVARFX(r_string        : r_type          : r_error         :                   //YK04
               //   uwxref          : UwSrcDtl.srclib : UwSrcDtl.srcspf :                //YK04 0002
               //   UwSrcDtl.srcmbr : r_rrns          : r_rrne          :                //YK04 0002
               //   r_lname         : r_word          : in_procedure   );                //YK04 0002
                    uwxref          : UwSrcDtl        : r_rrns          :                //0002
                    r_rrne          : r_lname         : r_word          :                //0002
                    in_procedure   );                                                    //0002
      endif;

      if %scan('DIM': %subst(r_string:44)) > 0 and
         %scan('LIKE': %subst(r_string:44)) = 0;
         IAPSRARRFX(r_string        : r_type          : r_error         : uwxref :
                 // UwSrcDtl.srclib : UwSrcDtl.srcspf : UwSrcDtl.srcmbr : r_rrns :       //0002
                    UwSrcDtl        : r_rrns          :                                  //0002
                    r_rrne          : r_lname         :  r_word );
      endif;

      if %scan('LIKE':r_string:44 )  > 0;
         r_likepos  = %scan('LIKE':r_string:44) + 4;
         r_likepos  = %scan(')':r_string:r_likepos);
         if %scan('DIM': %subst(r_string:r_likepos)) = 0;
         IAPSRVARFX(r_string        : r_type          : r_error         :                   //YK04
               //   uwxref          : UwSrcDtl.srclib : UwSrcDtl.srcspf :                //YK04 0002
               //   UwSrcDtl.srcmbr : r_rrns          : r_rrne          :                //YK04 0002
               //   r_lname         : r_word          : in_procedure   );                //YK04 0002
                    uwxref          : UwSrcDtl        : r_rrns          :                //0002
                    r_rrne          : r_lname         : r_word          :                //0002
                    in_procedure   );                                                    //0002
         endif;
         if %scan('DIM': %subst(r_string:r_likepos)) > 0;
            IAPSRARRFX(r_string        : r_type          : r_error         : uwxref :
                 //    UwSrcDtl.srclib : UwSrcDtl.srcspf : UwSrcDtl.srcmbr : r_rrns :    //0002
                       UwSrcDtl        : r_rrns          :                               //0002
                       r_rrne          : r_lname         : r_word );
         endif;
      endif;
      exsr clear_vars;
      clear r_lname;
      clear r_word;
      clear r_rrnext;
      r_ext = 'N';
   endif;

   if r_fix = 'D' and %scan('...':r_string:8) > 0;
      dow (%scan('...':r_string) > 0 and r_fix = 'D' and
           %subst(r_string:7:1) <> '*') or
          (%len(%trim(r_string)) < 3 ) or
          (%subst(r_string:7:1) = '*' );
          r_lpos = %scan('...':r_string);
         if r_ext <> 'Y'  and r_lpos > 0;
            r_rrnext = r_Rrn;
            r_word   = %trim(%subst(r_string:7:r_lpos-7));
            r_word   = %trim(r_word) + '...';
         endif;
         if r_lpos > 0 and %subst(r_string:7:1) <> '*';
            r_Lname = %trim(r_Lname) + %trim(%subst(r_string:7:r_lpos-7));
         endif;
         r_ext = 'Y';
         exec sql fetch SrcStmt into :r_Stm, :r_Rrn;
         If sqlCode < successCode;                                                       //MT22
            uDpsds.wkQuery_Name = 'Fetch_23_srcStmt';                                    //MT22
            IaSqlDiagnostic(uDpsds);                                          //0001     //MT22
         Endif;                                                                          //MT22
         r_string =  r_stm;
         r_fix    =  %subst(r_string:6:1);
      enddo;
      clear r_string;
      r_iter = 'Y';
      leavesr;
   endif;

endsr;
//-----------------------------------------------------------------------------
//Process_File :
//-----------------------------------------------------------------------------
begsr process_file;

   r_iter = 'N';
   if %scan('DCL-F ':r_string:1) > 0;

      //--------------- Concate Complete Statement Till End ---------- *//
      if %scan(';': r_string : %len(%trimr(r_string))) = 0;
         exec sql fetch SrcStmt into :r_Stm, :r_Rrn;
         If sqlCode < successCode;                                                       //MT22
            uDpsds.wkQuery_Name = 'Fetch_24_srcStmt';                                    //MT22
            IaSqlDiagnostic(uDpsds);                                          //0001     //MT22
         Endif;                                                                          //MT22
         r_iter ='Y';
         leavesr;
      endif;

      //--------------- Parse File Statement ------------------------- *//
      if %scan(';': r_string : %len(%trimr(r_string))) > 0;
         IAPSRFLFR(r_string        : r_type          : r_error         :
             //    uwxref          : UwSrcDtl.srclib : UwSrcDtl.srcspf :                 //0002
             //    UwSrcDtl.srcmbr : r_rrns          : r_rrne);                          //0002
                   uwxref          : UwSrcDtl        : r_rrns          : r_rrne);        //0002

         if r_error = 'C';
            exsr clear_vars;
         endif;
      endif;

   elseif %subst(r_string:6:1) = 'F' and %subst(r_string:7:1) <> '*';
      dow 1 = 1;
         r_cat = '@';
         exec sql fetch SrcStmt into :r_Stm, :r_Rrn;
         If sqlCode < successCode;                                                       //MT22
            uDpsds.wkQuery_Name = 'Fetch_25_srcStmt';                                    //MT22
            IaSqlDiagnostic(uDpsds);                                          //0001     //MT22
         Endif;                                                                          //MT22
         exsr Fetch_Specs;
         exsr Format_string;
         //if sqlcode = 100;                                                              //AK09
         if sqlcode = NO_DATA_FOUND;                                                      //AK09
            leave;
         endif;
         if r_iter ='Y';
            leave;
         endif;
         if %subst(r_stm:6:1)  = 'F' and %subst(r_stm:7:10) = '          ';
            r_string = %trimr(r_string) + r_cat + r_stm;
         else;
            leave;
         endif;
      enddo;
      r_cat = ' ';
      IAPSRFLFX(r_string        : r_type          : r_error         :
           //   uwxref          : UwSrcDtl.srclib : UwSrcDtl.srcspf :                    //0002
           //   UwSrcDtl.srcmbr : r_rrns          : r_rrne);                             //0002
                uwxref          : UwSrcDtl        : r_rrns          : r_rrne);           //0002

      r_error = 'C';
      if r_error = 'C';
         exsr clear_vars;
         r_iter ='Y';
         leavesr;
      endif;
   endif;

endsr;
//--------------------------------------------------------------------------
//Process_Arr :
//--------------------------------------------------------------------------
begsr process_arr;

   if %len(%trimr(r_string)) > 40;
      if %subst(r_string:6:1)  =  'E'  and
         %subst(r_string:7:1)  <> '*'  and
         %subst(r_string:27:6) <> ' '  and
         %subst(r_string:36:4) <> ' ';
         r_type   = 'RPG';
         r_word   = *blanks;
         r_lname  = *blanks;
         //--------------- Parse Array Statement------------------------- *//
         IAPSRARRFX(r_string        : r_type          : r_error         : uwxref :
                 // UwSrcDtl.srclib : UwSrcDtl.srcspf : UwSrcDtl.srcmbr : r_rrns :       //0002
                    UwSrcDtl        : r_rrns          :                                  //0002
                    r_rrne          : r_lname         : r_word );
      endif;
   endif;
   r_error = 'C';
   if r_error = 'C';
      r_iter = 'N';
      exsr clear_vars;
   endif;

endsr;
//----------------------------------------------------------------------------
//FindDsDtl :
//----------------------------------------------------------------------------
begsr finddsdtl;

   exec sql
      select FLPGFILE, FLKWNFDS, FLKWNDDS
        into :uwdstyp
        from IAPGMFILES
       where FLLIBNM   = trim(:uwsrcdtl.srclib)
         and FLSRCPFNM = trim(:uwsrcdtl.srcspf)
         and FLSRCMBR  = trim(:uwsrcdtl.srcmbr)
         and (FLKWNFDS = trim(:r_dsname) or
              FLKWNDDS = trim(:r_dsname)) limit 1;                                   //AJ01

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Select_IAPGMFILES';                                     //MT22
      IaSqlDiagnostic(uDpsds);                                                //0001 //MT22
   endif;

   if sqlCode = successCode;
      select;
      when %trim(uwdstyp.dsinfds) = %trim(r_dsname);
         r_dsobjv = 'INFDS-VAR';
         r_dsmody = uwdstyp.dsfile;
      when %trim(uwdstyp.dsindds) = %trim(r_dsname);
         r_dsobjv = 'INDDS-VAR';
         r_dsmody = uwdstyp.dsfile;
      other;
      endsl;
   endif;
   clear uwdstyp;

endsr;
//-----------------------------------------------------------------------------
//SnglSpcString :
//-----------------------------------------------------------------------------
begsr snglspcstring;

   r_spos = 1;
   dow 1=1;
      r_pos7 = %scan(' ':%trim(r_string):r_spos);
      r_pos8 = r_pos7;
      if r_pos7 > 0;
         dow %subst(%trim(r_string):r_pos8+1:1)= ' ';
            r_pos8 += 1;
            r_string = %replace('':%trim(r_string):r_pos8:1);
            r_pos8 = r_pos7;
         enddo;
      endif;
      r_spos = r_pos7 + 1;

      if r_pos7 = %len(%trim(r_string)) + 1 or r_pos7 = 0;
         leave;
      endif;
   enddo;

endsr;
//-----------------------------------------------------------------------------
//Process_PRPI:
//-----------------------------------------------------------------------------

//------------------- Subroutine To Process PR & PI ---------------- *//
begsr Process_PRPI;

   r_iter = 'N';
   select;
   when %scan('DCL-PR ':r_string:1) > 0 or
        %scan('DCL-PI ':r_string:1) > 0;

      select;
      when %scan('END-PR ': r_string ) = 0 and
           %scan('END-PR;': r_string ) = 0 and
           %scan('END-PI ': r_string ) = 0 and
           %scan('END-PI;': r_string ) = 0;
         exec sql fetch SrcStmt into :r_Stm, :r_Rrn;
         If sqlCode < successCode;                                                       //MT22
            uDpsds.wkQuery_Name = 'Fetch_26_srcStmt';                                    //MT22
            IaSqlDiagnostic(uDpsds);                                           //0001    //MT22
         Endif;                                                                          //MT22
         r_iter = 'Y';
         leavesr;
      when %scan('END-PR ': r_string ) > 0 or
           %scan('END-PR;': r_string ) > 0 or
           %scan('END-PI ': r_string ) > 0 or
           %scan('END-PI;': r_string ) > 0;
     //  IAPSRPRFR(r_string        : r_type          : r_error         :
     //            uwxref          : UwSrcDtl.srclib : UwSrcDtl.srcspf :
     //            UwSrcDtl.srcmbr : r_rrns          : r_rrne );

         if r_error = 'C';
            exsr clear_vars;
         endif;
      endsl;
   when (%subst(r_string:6:1) = 'D' and %subst(r_string:24:2) = 'PR' ) or
        (%subst(r_string:6:1) = 'D' and %subst(r_string:24:2) = 'PI' );
      dow 1 = 1;
         exec sql fetch SrcStmt into :r_Stm, :r_Rrn;
         If sqlCode < successCode;                                                       //MT22
            uDpsds.wkQuery_Name = 'Fetch_27_srcStmt';                                    //MT22
            IaSqlDiagnostic(uDpsds);                                           //0001    //MT22
         Endif;                                                                          //MT22
         if %subst(r_stm: 7: 1) = '*';
            iter;
         endif;
         if %subst(r_stm: 6: 1) = 'D' and %subst(r_stm: 24: 2) = '  ' and
            SqlCode = successCode;                                                        //AK09
            //SqlCode = 0;                                                                //AK09
            r_string = %trimr(r_string) + r_cat + %trimr(r_stm );
            r_rrne= r_rrn;
            iter;
         else;
            leave;
         endif;
      enddo;
      //Call program
      r_prstring = %trimr(r_string) + r_cat;
  //  IAPSRPRFX(r_prstring      : r_type          : r_error         : uwxref :
  //            UwSrcDtl.srclib : UwSrcDtl.srcspf : UwSrcDtl.srcmbr : r_rrns :
  //            r_rrne          : r_longprname    : r_callCPYB );

      //Remove
      exsr Clear_Vars;
      clear r_longprname;
      r_cat =' ';
      r_iter = 'Y';
      leavesr;
   endsl;

endsr;
//--------------------------------------------------------------------
//*Inzsr :
//--------------------------------------------------------------------
begsr *Inzsr;

   exec sql delete from IASUBRDTL;

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Delete_IASUBRDTL';                                      //MT22
      IaSqlDiagnostic(uDpsds);                                                 //0001//MT22
   endif;

   exec sql delete from IAPGMDS;

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Delete_IAPGMDS';                                        //MT22
      IaSqlDiagnostic(uDpsds);                                                           //0001
   endif;

   exec sql delete from IAPRCPARM;

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Delete_IAPRCPARM';                                      //MT22
      IaSqlDiagnostic(uDpsds);                                                           //0001
   endif;

endsr;
//-------------------------------------------------------------------
//Process_Ent :
//-------------------------------------------------------------------
begsr process_ent;

   if %subst(r_string:6:1)  = 'C' and %subst(r_string:7:1) <> '*' and
      %subst(r_string:12:6) = '*ENTRY' and
      %subst(r_string:26:5) = 'PLIST';
      r_prc = *blanks;
      r_seq = 0;
      exec sql fetch SrcStmt into :r_Stm, :r_Rrn;
      if sqlCode < successCode;                                                         //MT22
         uDpsds.wkQuery_Name = 'Fetch_28_srcStmt';                                      //MT22
         IaSqlDiagnostic(uDpsds);                                              //0001   //MT22
      endif;                                                                            //MT22

      r_string = r_Stm;
      dow (%subst(r_string:6:1)   = 'C'    and
           %subst(r_string:26:4)  = 'PARM' and
           %subst(r_string:7:1)   <> '*')  or
          (%len(%trim(r_string))  < 3 )    or
          (%subst(r_string:7:1)   = '*' );
         if %subst(r_string:6:1)  = 'C'    and
            %subst(r_string:26:4) = 'PARM' and
            %subst(r_string:7:1)  <> '*';
            r_rrns = r_rrn;
            r_seq = r_seq + 1;
            IAPSRENTFX(r_string        : r_type          : r_error         : uwxref :
                   //  UwSrcDtl.srclib : UwSrcDtl.srcspf : UwSrcDtl.srcmbr : r_rrns :      //0002
                       UwSrcDtl        : r_rrns          :                                 //0002
                       r_rrne          : r_seq           : r_prc );
            exsr clear_vars;
         endif;
         exec sql fetch SrcStmt into :r_Stm, :r_Rrn;
         if sqlCode < successCode;                                                         //MT22
            uDpsds.wkQuery_Name = 'Fetch_29_srcStmt';                                      //MT22
            IaSqlDiagnostic(uDpsds);                                           //0001      //MT22
         endif;                                                                            //MT22
         //if Sqlcode = 100;                                                               //AK09
         if Sqlcode = successCode;                                                         //AK09
            leavesr;
         endif;
         r_string = r_Stm;
      enddo;
      clear r_string;
      r_iter = 'Y';
      leavesr;
   endif;

   if %subst(r_string:6:1) = 'C' and %subst(r_string:7:1) <> '*' and
      %subst(r_string:18:6) = '*ENTRY' and
      %subst(r_string:28:5) = 'PLIST';
      r_seq = 0;
      r_prc = *blanks;
      exec sql fetch SrcStmt into :r_Stm, :r_Rrn;
      if sqlCode < successCode;                                                         //MT22
         uDpsds.wkQuery_Name = 'Fetch_30_srcStmt';                                      //MT22
         IaSqlDiagnostic(uDpsds);                                              //0001   //MT22
       endif;                                                                           //MT22

      r_string = r_Stm;
      dow (%subst(r_string:6:1)  = 'C'    and
           %subst(r_string:28:4) = 'PARM' and
           %subst(r_string:7:1)  <> '*')  or
          (%len(%trim(r_string)) < 3 )    or
          (%subst(r_string:7:1)  = '*' );

         if %subst(r_string:6:1) = 'C' and
            %subst(r_string:28:4) = 'PARM' and
            %subst(r_string:7:1) <> '*';
            r_rrns = r_rrn;
            r_seq = r_seq + 1;
            IAPSRENTFX3(r_string        : r_type          : r_error         :
                    //  uwxref          : UwSrcDtl.srclib : UwSrcDtl.srcspf :            //0002
                    //  UwSrcDtl.srcmbr : r_rrns          : r_rrne          :            //0002
                    //  r_seq           : r_prc );                                       //0002
                        uwxref          : UwSrcDtl        : r_rrns          :            //0002
                        r_rrne          : r_seq           : r_prc );                     //0002
            exsr clear_vars;
         endif;

         exec sql fetch SrcStmt into :r_Stm, :r_Rrn;
         if sqlCode < successCode;                                                       //MT22
            uDpsds.wkQuery_Name = 'Fetch_31_srcStmt';                                    //MT22
            IaSqlDiagnostic(uDpsds);                                            //0001   //MT22
          endif;                                                                         //MT22
         r_string = r_Stm;
      enddo;
      clear r_string;
      r_iter = 'Y';
      leavesr;
   endif;

endsr;
//-----------------------------------------------------------------------------
//ProcessRpgSource :
//-----------------------------------------------------------------------------
begsr processRpgSource;

   exec sql
    declare SrcStmt cursor for
     select UCASE(SOURCE_DATA), SOURCE_RRN
       from IAQRPGSRC
      where LIBRARY_NAME  = trim(:UwSrcDtl.srclib)
        and SOURCEPF_NAME = trim(:UwSrcDtl.srcspf)
        and SOURCE_DATA   <> ' '
        and MEMBER_NAME   = trim(:UwSrcDtl.srcmbr);

   //Review use order by rrn criteria.
   //Review use ucase to xlate input srcdta
   exec sql open SrcStmt;
   if sqlCode = CSR_OPN_COD;                                                              //AK09
      exec sql close SrcStmt;                                                             //AK09
      exec sql open  SrcStmt;                                                             //AK09
   endif;                                                                                 //AK09

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Open_srcStmt';                                               //MT22
      IaSqlDiagnostic(uDpsds);                                                  //0001
   endif;

   if sqlCode = successCode;
      exec sql fetch SrcStmt into :r_stm, :r_rrn;
      if sqlCode < successCode;
         uDpsds.wkQuery_Name = 'Fetch_1_srcStmt';                                          //MT22
         IaSqlDiagnostic(uDpsds);                                                        //0001
      endif;
      dow sqlCode = successCode;
         r_fix = *blanks;
         if r_string = *blanks;
            r_rrns= r_rrn;
         endif;

         //----------- Fetch Free Or Fix Format status -------------- *//
         exsr Fetch_Specs;
         if %subst(r_stm:6:1) = 'H' or %subst(r_stm:6:1) = 'P'; //P-Spec
            exsr Clear_vars;
            exec sql fetch SrcStmt into :r_stm, :r_rrn;
            If sqlCode < successCode;                                                       //MT22
               uDpsds.wkQuery_Name = 'Fetch_2_srcStmt';                                     //MT22
               IaSqlDiagnostic(uDpsds);                                             //0001  //MT22
            Endif;                                                                          //MT22
            iter;
         endif;
         if r_iter = 'Y';
            r_iter = 'N';
            iter;
         endif;

         //----------- Remove Comments, Tags And Skip Blanks -------- *//
         exsr Format_String;
         if r_iter = 'Y';
            r_iter = 'N';
            iter;
         endif;

         if r_string = *blanks;
            r_string = %trimr(r_stm );
            r_rrns= r_rrn;
         else;
            r_string = %trimr(r_string) + r_cat + %trimr(r_stm );
            r_rrne= r_rrn;
         endif;

         //----------- Process The Statement Containing EXEC SQL ---- *//
         if %scan('EXEC SQL':%trim(r_string):1) > 0;
            exsr Process_SQL;
            if r_iter = 'Y';
               r_iter = 'N';
               iter;
            endif;
         endif;

         //----------- Process The Statement Containing DS (RPG4) --- *//
         if (r_fix = 'D' and %subst(r_string:24:2) = 'DS') or
            (r_sts = 'DSFXN');
            exsr Process_DS_fx;
            if r_iter = 'Y';
               r_iter = 'N';
               iter;
            endif;
         endif;

         //----------- Process The Statement Containing DS (RPG3) --- *//
         if (r_fix = 'I' and %subst(r_string:19:2) = 'DS') or
            (r_sts = 'DSRPG3N');
            exsr Process_DS_RPG;
            if r_iter = 'Y';
               r_iter = 'N';
               iter;
            endif;
         endif;

         //----------- Process The Statement Containing DCL-DS ------ *//
         if %scan('DCL-DS ':%trim(r_string):1) = 1 or
            (r_sts = 'DSFRN');
            exsr Process_DS_fr;
            if r_iter = 'Y';
               r_iter = 'N';
               iter;
            endif;
         endif;

         //----------- Process The Statement Containing File -------- *//
         if %scan('DCL-F ': %trim(r_string):1) = 1 or
            (%scan('F':r_string:6)  = 6 and
             %scan('*':r_string:7) <> 7 and r_fix = 'F');
            exsr process_file;
            if r_iter = 'Y';
               r_iter = 'N';
               iter;
            endif;
         endif;

         //----------- Process The Statement Containing DCL-VAR ----- *//
         if %scan('DCL-S ':%trim(r_string):1) = 1 or
            %scan('DCL-C ':%trim(r_string):1) = 1 or
            (r_fix = 'D' and %subst(r_string:7:1) <> '*');
            exsr Process_VAR;
            if r_iter = 'Y';
               r_iter = 'N';
               iter;
            endif;
         endif;

         if r_stringnew <> *blanks;
            r_iter = 'N';
            clear r_stringnew;
            iter;
         endif;

         //----------- Process The Statement Containing Array ------- *//
         if (%subst(r_string:6:1)='E' and %len(%trimr(r_string)) > 40);
            exsr process_arr;
            if r_iter = 'Y';
               r_iter = 'N';
               iter;
            endif;
         endif;

         //----------- Process The Statement Containing Entry Parameter*//
         if (r_fix = 'C' and %scan('*ENTRY':r_string) > 0 );
            exsr process_ent;
            if r_iter = 'Y';
               r_iter = 'N';
               iter;
            endif;
         endif;

         //----------- Process The Statement for PR & PI Def   ------ *//
         if r_fix = 'D' and %scan('...':r_string) > 0;
            r_longprname = %trim(%subst(r_string:7));
            r_pos3       = %scan('...':r_Longprname);
            r_longprname = %subst(r_longprname:1:r_pos3-1);
            exec sql fetch SrcStmt into :r_Stm, :r_Rrn;
            If sqlCode < successCode;                                                       //MT22
               uDpsds.wkQuery_Name = 'Fetch_3_srcStmt';                                     //MT22
               IaSqlDiagnostic(uDpsds);                                              //0001 //MT22
            Endif;                                                                          //MT22
            if (%subst(r_stm:6:1) = 'D' and %subst(r_stm:24:2) = 'PR') or
               (%subst(r_stm:6:1) = 'D' and %subst(r_stm:24:2) = 'PI');
               exsr clear_vars;
               iter;
            else;
               clear r_longprname;
            endif;
         endif;

         if (%scan('DCL-PR ':%trim(r_string):1) = 1 or
            (%len(%trimr(r_string)) >= 25 and
             %subst(r_string:6:1) = 'D' and
             %subst(r_string:24:2) = 'PR' )) or
            (%scan('DCL-PI ':%trim(r_string):1) = 1 or
            (%len(%trimr(r_string)) >= 25 and
             %subst(r_string:6:1) = 'D' and
             %subst(r_string:24:2) = 'PI' ));
            if r_fix = 'D' and r_cat = ' ';
               r_cat ='^';
            endif;
            if r_lname <> *blanks;     // To handle long name set in VAR
               r_longprname = r_lname;
               clear r_lname;
            endif;
            exsr Process_PRPI;
            if r_iter = 'Y';
               r_iter = 'N';
               iter;
            endif;
         endif;

         //----------- Process The copybook ------------------------- *//
         r_callCPYB = *off;
         r_CPYBpos = *zeros;

         if r_Fix <> *blanks;
            if %scan('/COPY ':%trimr(r_string):1) = 7 or
               %scan('/INCLUDE ':%trimr(r_string):1) = 7;
               r_callCPYB = *on;
            endif;
         else;
            r_CPYBpos = %scan('/COPY ':%trimr(r_string):1);
            if r_CPYBpos = 0;
               r_CPYBpos = %scan('/INCLUDE ':%trimr(r_string):1);
            endif;
            if r_CPYBpos > 0;
               if %subst(r_string:1:(r_CPYBpos - 1)) = *blanks;
                  r_callCPYB = *on;
               endif;
            endif;
         endif;

         if r_callCPYB = *on;
            IAPSRCPYB(r_string:
                      r_type:
                      r_error:
                      uwxref:
                 //   UwSrcDtl.srclib:                                                   //0002
                 //   UwSrcDtl.srcspf:                                                   //0002
                 //   UwSrcDtl.srcmbr:                                                   //0002
                      UwSrcDtl :                                                         //0002
                      r_rrns:
                      r_rrne);
            exsr Clear_vars;
         endif;

         //----------- Process Subroutine --------------------------- *//
         if %trim(r_string) <> *blanks;
            reset R_subrflg;
            if %subst(r_string:6:1) = 'C';
               // ---------If EXSR in RPG400------------------------------*//
               if %subst(r_string:26:4) = 'EXSR' or
                  %subst(r_string:26:5) = 'BEGSR' or
                  %subst(r_string:26:5) = 'ENDSR' or
                  %subst(r_string:26:3) = 'CAS' or
                  // ---------If EXSR in RPG3  ------------------------------*//
                  %subst(r_string:28:4) = 'EXSR' or
                  %subst(r_string:28:5) = 'BEGSR' or
                  %subst(r_string:28:5) = 'ENDSR' or
                  %subst(r_string:28:3) = 'CAS';
                  r_SubrFlg = 'Y';
                  select;
                  when %subst(r_string:26:5) = 'BEGSR';
                     r_subrnam = %subst(r_string:7:18);
                  when %subst(r_string:28:5) = 'BEGSR';
                     r_subrnam = %subst(r_string:7:20);
                  when %subst(r_string:26:5) = 'ENDSR' or
                       %subst(r_string:28:5) = 'ENDSR';
                     reset R_SubrNam;
                  endsl;
               else;
                  r_SubrFlg = 'N';
               endif;
            else;
               if ProcessScanR(';':r_string) > 0;
                  if (%scan('EXSR ' :R_String) > 0 or
                      %scan('BEGSR ':R_String) > 0 or
                      %scan('ENDSR':R_String) > 0);
                     r_SubrFlg = 'Y';
                     select;
                     when %scan('BEGSR ':r_string) > 0;
                        r_subrnam = %subst(r_string : (%scan('BEGSR ':r_string)+6) :
                                    (ProcessScanR(';':r_string) -
                                     (%scan('BEGSR ':r_string)+6)));
                     when %scan('ENDSR':R_String:1) > 0;
                        reset r_subrnam;
                     endsl;
                  else;
                     r_SubrFlg = 'N';
                  endif;
               elseif r_fix = ' ';
                  exec sql fetch SrcStmt into :r_stm, :r_rrn;
                  if sqlCode < successCode;                                              //MT22
                     uDpsds.wkQuery_Name = 'Fetch_4_srcStmt';                            //MT22
                     IaSqlDiagnostic(uDpsds);                                      //0001//MT22
                  endif;                                                                 //MT22
                  iter;
               endif;
            endif;

            if r_SubrFlg = 'Y';
               if R_rrns >=R_rrne and r_rrne <> 0;
                  R_rrne = R_rrns;
               endif;
               //------Call subroutine parser procedure-----------------*//
               IAPSRSUBR(r_string        : r_type          : r_error         : uwxref :
                    //   UwSrcDtl.srclib : UwSrcDtl.srcspf : UwSrcDtl.srcmbr : r_rrns :  //0002
                         UwSrcDtl        : r_rrns          :                             //0002
                         r_rrne          : r_SubrNam );
               exsr Clear_vars;
            endif;
         endif;

         clear r_stm;
         clear r_rrn;
         clear r_string;
         exec sql fetch SrcStmt into :r_stm, :r_rrn;
         if sqlCode < successCode;                                              //MT22
            uDpsds.wkQuery_Name = 'Fetch_5_srcStmt';                            //MT22
            IaSqlDiagnostic(uDpsds);                                            //MT22   //0001
         endif;                                                                 //MT22
      enddo;
      exec sql close SrcStmt;
   endif;

endsr;
