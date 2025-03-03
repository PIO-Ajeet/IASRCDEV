**free
      //%METADATA                                                      *
      // %TEXT IA Main C spec Parser                                   *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------- //
//Created By  :   Programmers.io @ 2020                                                 //
//Created Date:   2020/01/01                                                            //
//Developer   :   Programmers                                                           //
//Description :   Main Parser Program For C Spec                                        //
//                                                                                      //
//Procedure Log:                                                                        //
//------------------------------------------------------------------------------------- //
//Procedure Name           | Procedure Description                                      //
//-------------------------|----------------------------------------------------------- //
//No Procedure             |                                                            //
//------------------------------------------------------------------------------------- //
//                                                                                      //
//MODIFICATION LOG:                                                                     //
//------------------------------------------------------------------------------------- //
//Date    | Mod_ID | Developer  | Case and Description                                  //
//--------|--------|------------|------------------------------------------------------ //
//03/14/23| 0001   | Pranav J   | Fixed issue where Comment not excluded properly.      //
//03/14/23| 0002   | Ahmad S.   | Fixed issue where Multiple comments not excluded.     //
//06/03/23| 0003   | Sarvesh B  | Use of %Xlate BIF instead of UPPER for IAQRPGSRC      //
//        |        |            | source data fetch.                                    //
//03/23/23| 0004   | Ahmed S.   | Ignored the commented line using IAQRPGSRC field and  //
//        |        |            | optimise Format String subroutine using new IAqrpgsrc //
//04/03/23| 0005   | Sarvesh    | Commenting out the IPSRHSTLOG procedure call.         //
//20/06/23| 0006   | Himanshu   | Change the UwSrcDtl ds parameter and corrosponding    //
//        |        | Gehlot     | lines where these parameters are being used.          //
//04/28/23| 0007   | Ruchika N  | Added Process_generic_opcode_parsing(Task#28)         //
//06/06/24| 0008   | Saumya     | Rename AIEXCTIMR to IAEXCTIMR [Task #262]             //
//05/10/23| 0009   | Khushi W   | Rename program AIMBRPRSER to IAMBRPRSER. [Task #263]  //
//05/07/24| 0010   | Akhil K.   | Renamed AIERRBND, AICERRLOG, AIDERRLOG and AISQLDIAGNO//
//        |        |            | STIC with IA*                                         //
//29/05/24| 0011   | Azhar Uddin| Modify to check fourth character as non-blank instead//
//        |        |            | of hard coding for source line type from IAQRPGSRC   //
//        |        |            | (Task - #689)                                        //
//07/08/24| 0012   | Sabarish & | IFS Member Parsing Enhancements                       //
//        |        | Vishwas    |                                                       //
//------------------------------------------------------------------------------------- //
ctl-opt copyright('Copyright @ Programmers.io © 2022 ');
ctl-opt option(*nodebugio:*srcstmt:*nounref);
ctl-opt bndDir('IABNDDIR' : 'IAERRBND');                                                 //0010

//------------------------------------------------------------------------------------- //
//File Declaration
//------------------------------------------------------------------------------------- //
dcl-f iAClCmd disk usage(*input);

//------------------------------------------------------------------------------------- //
//Prototype Declaration
//------------------------------------------------------------------------------------- //
dcl-pr IAPSRPH3;
   *n char(10);
   *n like(UwSrcDtl);
end-pr;

dcl-pr IAEXCTIMR extpgm('IAEXCTIMR');                                                    //0008
   *n Char(10) Const;
   *n Char(10);
   *n Char(10);
   *n Char(10) Const;
   *n Char(10);
   *n Char(10);
   *n Char(10);
   *n Char(100) Const;                                                                   //0012
   *n Char(10) Const;
   *n Timestamp;
   *n Char(6) Const;
end-pr;

dcl-pi IAPSRPH3;
   dcl-parm uwxref char(10);
   dcl-parm UwSrcDtl5 like(UwSrcDtl);
end-pi;

//------------------------------------------------------------------------------------- //
//Data Structure Declaration
//------------------------------------------------------------------------------------- //
dcl-ds UwSrcDtl qualified inz;                                                           //0006
   srclib  char(10);                                                                     //0006
   srcSpf  char(10);                                                                     //0006
   srcmbr  char(10);                                                                     //0006
   ifsloc  char(100);                                                                    //0012
   srcType char(10);                                                                     //0006
   srcStat char(1);                                                                      //0017
end-ds;                                                                                  //0012

dcl-ds PRArr dim(100) qualified inz;
   prarrv char(128);
end-ds;

//------------------------------------------------------------------------------------- //
//Variabble Declaration
//------------------------------------------------------------------------------------- //
dcl-s opcode_arr  char(10) dim(300) ctdata perrcd(1);
dcl-s opcode_arr1 char(10) dim(84) ctdata perrcd(1);
dcl-s r_tfree     char(1)     inz('N');
dcl-s r_mfree     char(1)     inz('N');
dcl-s r_iter      char(1)     inz('N');
dcl-s r_error     char(10)    inz('N');
dcl-s r_xyz       char(10)    inz('N');
dcl-s r_type      char(10)    inz('N');
dcl-s r_chkprv    char(1)     inz('N');
dcl-s r_ErrLogFlg char(1)     inz;
dcl-s uwaction    char(20)    inz;
dcl-s uwactdtl    char(50)    inz;
dcl-s r_Stm       char(4046)  inz;
dcl-s r_Src_Type      char(5)      inz;                                                  //0004
dcl-s r_fix       char(1)     inz;
dcl-s r_string    char(5000)  inz;
dcl-s str         char(5000)  inz;
dcl-s Tmp_String  char(5000)  inz;
dcl-s wrk_str     char(5000)  inz;
dcl-s cl_status   char(1)     inz;
dcl-s r_cat       char(1)     inz;
dcl-s h_mbrnm     char(10)    inz;
dcl-s r_ioopcode  char(10)    inz;
dcl-s W_SrcFile   char(10)    inz;
dcl-s r_posb      packed(4:0) inz;
dcl-s r_pos1      packed(4:0) inz;
dcl-s pos1        packed(4:0) inz;
dcl-s r_pos2      packed(4:0) inz;
dcl-s r_rrn       packed(6:0) inz;
dcl-s r_rrns      packed(6:0) inz;
dcl-s r_rrne      packed(6:0) inz;
dcl-s uppgm_name      char(10)     inz;
dcl-s uplib_name      char(10)     inz;
dcl-s uptimestamp     Timestamp;
dcl-s q_stm           char(5000)   inz;
dcl-s r_pcmt          packed(4:0)  inz;
dcl-s in_value        char(1)      inz;
dcl-s b_pos       packed(6:0) inz;
dcl-s r_sqlstm    char(2000)  inz;

//------------------------------------------------------------------------------------- //
//Constant Variable Declaration
//------------------------------------------------------------------------------------- //
dcl-c r_quote    '''';

dcl-c wk_lo                'abcdefghijklmnopqrstuvwxyz';                                 //0003
dcl-c wk_Up                'ABCDEFGHIJKLMNOPQRSTUVWXYZ';                                 //0003

//------------------------------------------------------------------------------------- //
//CopyBook Declaration
//------------------------------------------------------------------------------------- //
/copy 'QMODSRC/iasrv01pr.rpgleinc'
/copy 'QMODSRC/iasrv02pr.rpgleinc'
/copy 'QMODSRC/iasrv03pr.rpgleinc'
/copy 'QCPYSRC/iaderrlog.rpgleinc'

//------------------------------------------------------------------------------------- //
//Mainline Logic
//------------------------------------------------------------------------------------- //
exec sql
  set option commit = *none,
             naming = *sys,
             usrprf = *user,
             dynusrprf = *user,
             closqlcsr = *endmod;

eval-corr uDpsds = wkuDpsds;

UwSrcDtl=UwSrcDtl5;
if h_mbrnm <> uwsrcdtl.srcmbr;

   uptimeStamp = %Timestamp();
   CallP IAEXCTIMR('IAMBRPRSER' :udpsds.ProcNme : udpsds.Lib : '*PGM' :                  //0009
                   UwSrcDtl.srcSpf:uwsrcdtl.srcmbr : uwsrcdtl.srclib :                   //0006
                   UwSrcDtl.ifsloc:                                                      //0012
                   UwSrcDtl.srcType : uptimeStamp : 'INSERT');                           //0006


endif;

r_type  = UwSrcDtl.srcType;                                                              //0006
r_tfree = 'N';
r_mfree = 'N';
r_fix   = ' ';

r_sqlstm = 'Select Distinct pPrNam '+                                                    //0012
           'From   iAPrcParm '      ;                                                    //0012
   If UwSrcDtl.ifsloc  <> *blanks ;                                                      //0012
      r_sqlstm =  %trim( r_sqlstm)                                                       //0012
               + ' Where pIfsLoc = '+ r_quote + %trim(UwSrcDtl.ifsloc) + r_quote         //0012
               + ' And   pMbrNam = '+ r_quote + %trim(UwSrcDtl.srcmbr) + r_quote ;       //0012
   else;                                                                                 //0012
      r_sqlstm =  %trim( r_sqlstm)                                                       //0012
               + ' Where pLibNam = '+ r_quote + %trim(UwSrcDtl.srclib) + r_quote         //0012
               + ' And   pSrcPf  = '+ r_quote + %trim(UwSrcDtl.srcspf) + r_quote         //0012
               + ' And   pMbrNam = '+ r_quote + %trim(UwSrcDtl.srcmbr) + r_quote ;       //0012
   endif;                                                                                //0012

   exec sql prepare Stmt1 from  :r_sqlstm  ;                                             //0012
   exec sql declare PRCsr cursor for stmt1 ;                                             //0012
clear PRArr;
//exec sql                                                                                 0012
//     declare PRCsr cursor for                                                            0012
//     select  Distinct pPrNam                                                             0012
//     from    iAPrcParm                                                                   0012
//     where   pLibNam = :uwsrcdtl.srclib                                                  0012
//     and     pSrcPf  = :uwsrcdtl.srcspf                                                  0012
//     and     pMbrNam = :uwsrcdtl.srcmbr;                                                 0012

exec sql open  PRCsr;
if sqlCode = CSR_OPN_COD;
   exec sql close PRCsr;
   exec sql open  PRCsr;
endif;

if sqlCode < successCode;
   uDpsds.wkQuery_Name = 'Open_PRCsr';
   IaSqlDiagnostic(uDpsds);                                                              //0010
endif;

if sqlCode = successCode;

   exec sql fetch PRCsr for 99 rows into :PRArr;
   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Fetch_PRCsr';
      IaSqlDiagnostic(uDpsds);                                                           //0010
   endif;
   exec sql close PRCsr;

endif;

//*Get Source Statements Cursor Begin
exsr processSourceStatement;

if h_mbrnm <> uwsrcdtl.srcmbr;
   h_mbrnm = uwsrcdtl.srcmbr;

   uptimeStamp = %Timestamp();
   CallP IAEXCTIMR('IAMBRPRSER' :udpsds.ProcNme : udpsds.Lib : '*PGM' :                  //0009
                   UwSrcDtl.srcSpf:uwsrcdtl.srcmbr : uwsrcdtl.srclib :                   //0006
                   UwSrcDtl.ifsloc:                                                      //0012
                   UwSrcDtl.srcType : uptimeStamp : 'UPDATE');                           //0006
endif;

*inlr = *on;
return;

/copy 'QCPYSRC/iacerrlog.rpgleinc'

//------------------------------------------------------------------------------------- //
//Subroutine Fetch_Specs: Subroutine To Fetch Specs indicator
//------------------------------------------------------------------------------------- //
begsr Fetch_Specs;

   r_iter = 'N';

   //If full Free Code
   if r_tfree = 'N' and r_stm <> *blanks
      and  %scan('**FREE': r_stm : 1) = 1;
      r_tfree = 'Y';
      exsr clear_vars;
      exec sql fetch SrcStmt into :r_stm , :r_rrn, :r_Src_Type;                          //0004
      r_stm = %xlate(wk_lo:wk_Up:r_stm);                                                 //0003
      if sqlCode < successCode;
         uDpsds.wkQuery_Name = 'Fetch_1_srcStmt';
         IaSqlDiagnostic(uDpsds);                                                        //0010
      endif;
      r_iter = 'Y';
      leavesr;
   endif;

   //If /FREE Is Encountered
   if r_stm <> *blanks and %subst(r_stm:7) <> *blanks
      and %len(%trim(%subst(r_stm:7))) >= 1
      and %scan('/FREE':%trim(%subst(r_stm:7)):1) = 1;
      if r_MFree  = 'N' ;
         r_mfree  = 'Y';
         exsr clear_vars;
         exec sql fetch SrcStmt into :r_stm , :r_rrn, :r_Src_Type;                       //0004
         r_stm = %xlate(wk_lo:wk_Up:r_stm);                                              //0003
         if sqlCode < successCode;
            uDpsds.wkQuery_Name = 'Fetch_2_srcStmt';
            IaSqlDiagnostic(uDpsds);                                                     //0010
         endif;
         r_iter = 'Y';
         leavesr;
      else ;
         exsr clear_vars;
         exec sql fetch SrcStmt into :r_stm , :r_rrn, :r_Src_Type;                       //0004
         r_stm = %xlate(wk_lo:wk_Up:r_stm);                                              //0003
         if sqlCode < successCode;
            uDpsds.wkQuery_Name = 'Fetch_3_srcStmt';
            IaSqlDiagnostic(uDpsds);                                                     //0010
         endif;
         r_iter = 'Y';
         leavesr;
      endif ;
   endif;

   //If /END-FREE IS Encountered
   if r_stm <> *blanks and %subst(r_stm:7) <> *blanks
      and %len(%trim(%subst(r_stm:7))) >= 1
      and %scan('/END-FREE':%trim(%subst(r_stm:7)):1) = 1;
      r_mfree = 'N';
      exsr clear_vars;
      exec sql fetch SrcStmt into :r_stm , :r_rrn, :r_Src_Type;                          //0004
      r_stm = %xlate(wk_lo:wk_Up:r_stm);                                                 //0003
      if sqlCode < successCode;
         uDpsds.wkQuery_Name = 'Fetch_4_srcStmt';
         IaSqlDiagnostic(uDpsds);                                                        //0010
      endif;
      r_iter = 'Y';
      leavesr;
   endif;

   //If FIXED Is Encountered
   if r_tfree = 'N' and r_stm <> *blanks and
      (%scan('H': r_stm : 6) = 6 or %scan('F': r_stm : 6) = 6 or
       %scan('D': r_stm : 6) = 6 or %scan('E': r_stm : 6) = 6 or
       %scan('I': r_stm : 6) = 6 or %scan('C': r_stm : 6) = 6 or
       %scan('O': r_stm : 6) = 6 or %scan('P': r_stm : 6) = 6 );
       r_fix = %subst(r_stm  : 6 : 1);
      r_mfree = 'N';
   endif;

endsr;

//------------------------------------------------------------------------------------- //
//Subroutine Clear_Vars: Subroutine To Clear Work Variables
//------------------------------------------------------------------------------------- //
begsr Clear_Vars;

   if r_chkprv = 'N';
      clear r_rrns;
      clear r_rrne;
      clear r_string;
      clear r_ioopcode;
   endif;

endsr;

//------------------------------------------------------------------------------------- //
//Subroutine Format_String: Subroutine To Foramt String
//------------------------------------------------------------------------------------- //
begsr Format_String;

   r_iter = 'N';

   //If Fixed , Remove the TAGS
   select ;
     when r_Src_Type = 'FX3' or r_Src_Type = 'FX4';                                      //0004
        r_stm  = %replace('     ':r_stm:1:5);                                            //0004

     //If Free (8-80), Remove the Tags
     when r_Src_Type = 'FFC';                                                            //0004
        r_stm  = %replace('      ':r_stm:1:6);                                           //0004
   endsl;                                                                                //0004

   //Remove Comments if any, based on the source type.
   select;                                                                               //0004
                                                                                         //0004
     when r_Src_Type = 'FX4' and %subst(r_stm:81:20) <> *blanks;                         //0004
        r_stm = %replace(' ':r_stm:81:20);                                               //0004
                                                                                         //0004
     when  r_Src_Type = 'FX3' and %subst(r_stm:60:15) <> *blanks;                        //0004
        r_stm = %replace(' ':r_stm:60:15);                                               //0004

     //If total free and partial commented line
     when r_Src_Type = 'FFC' or r_Src_Type = 'FFR';                                      //0004

        if %len(%trim(r_stm )) >= 1                                                      //0004
           and %scan('//': %trim(r_stm ):1)>1;

           //check if comment line is in between " "
           r_pcmt = 0;
           b_pos = %scan('//': %trim(r_stm) :1);                                         //0001
           q_stm = %trim(r_stm);
           dow b_pos > 0;
              InQuote(q_stm:b_pos:in_value);
              if in_value = 'Y';
                 r_pcmt = 0;
              else;
                 r_pcmt = b_pos;
                 Leave;                                                                  //0002
              endif;
              if b_pos < %len(%trim(r_stm)) ;                                            //0001
                 b_pos = %scan('//': %trim(r_stm): b_pos+1);                             //0001
              endif ;                                                                    //0001
           enddo;

           //if last comment line is in between " "
           if r_pcmt = 0;
              r_stm  = %trim(r_stm );
           elseif r_pcmt > 1 and %len(%trim(r_stm )) >= r_pcmt-1;
              r_stm  = %subst(%trim(r_stm ):1:r_pcmt-1);
           endif;
        Endif;

   endsl ;                                                                               //0004

   //Process /EJECT & /TITLE
   if %scan('/TITLE':r_stm:1)= 7 or
      %scan('/EJECT': r_stm:1)= 7 ;
      r_iter = 'Y';
      exec sql fetch SrcStmt into :r_stm , :r_rrn, :r_Src_Type;                          //0004
      r_stm = %xlate(wk_lo:wk_Up:r_stm);                                                 //0003
      if sqlCode < successCode;
         uDpsds.wkQuery_Name = 'Fetch_14_srcStmt';
         IaSqlDiagnostic(uDpsds);                                                        //0010
      endif;
      leavesr;
   endif;

endsr;

//------------------------------------------------------------------------------------- //
//Subroutine Process_io_rpg3: To Process I/O operations (RPG3)
//------------------------------------------------------------------------------------- //
begsr Process_io_rpg3;

   r_iter = 'N';

   //Parse Input/output operations
   IAPsrFxFx(r_string        : r_type          : r_error         : uwxref :
         //  UwSrcDtl.srclib : UwSrcDtl.srcspf : UwSrcDtl.srcmbr : r_rrns :              //0012
             UwSrcDtl        : r_rrns :                                                  //0012
             r_rrne          : r_ErrLogFlg );

   if r_ErrLogFlg = 'Y';
      leavesr;
   endif;

   //add logic
   r_error = 'C';
   if r_error = 'C';
      r_iter = 'N';
      exsr clear_vars;
   endif;

endsr;

//------------------------------------------------------------------------------------- //
//Subroutine Process_cond_fx: To Process conditional statment
//------------------------------------------------------------------------------------- //
begsr Process_cond_fx;

   r_iter = 'N';

   IAPSR3CON(r_string        :r_type          : r_error:uwxref
           //:UwSrcDtl.srclib:UwSrcDtl.srcspf : UwSrcDtl.srcmbr                          //0012
             :UwSrcDtl                                                                   //0012
             :r_rrns:r_rrne);

   if r_ErrLogFlg = 'Y';
      leavesr;
   endif;

   r_error = 'C';
   if r_error = 'C';
      r_iter = 'Y';
      Exsr clear_vars;
   Endif;

Endsr;

//------------------------------------------------------------------------------------- //
//Subroutine Process_io_fr: To Process I/O operations (Free)
//------------------------------------------------------------------------------------- //
begsr process_io_fr;

   r_iter = 'N';

   //Parse Input/output operations
   IAPSRIOFR(r_string        : r_type          : r_error         :
          // uwxref          : UwSrcDtl.srclib : UwSrcDtl.srcspf :                       //0012
          // UwSrcDtl.srcmbr : r_rrns          : r_rrne          :                       //0012
             uwxref          : UwSrcDtl        : r_rrns          : r_rrne :              //0012
             r_ErrLogFlg );

   if r_ErrLogFlg = 'Y';
      leavesr;
   endif;

   r_error = 'C';
   if r_error = 'C';
      r_iter = 'N';
      exsr clear_vars;
   endif;

endsr;

//------------------------------------------------------------------------------------- //
//Subroutine concat_continue_lines: To Concat continue lines (Fix Format)
//------------------------------------------------------------------------------------- //
begsr concat_continue_lines;
   r_iter = 'N';

   dow sqlCode = successCode;

      r_chkprv = 'Y';
      if r_iter = 'N';
         exec sql Fetch SrcStmt into :r_stm, :r_rrn, :r_Src_Type;                        //0004
         r_stm = %xlate(wk_lo:wk_Up:r_stm);                                              //0003
         if sqlCode <> successCode;
            r_chkprv = 'N';
            leave;
         endif;
      else;
         r_iter = 'N';
      endif;

      exsr Fetch_Specs;
      exsr Format_string;
      if r_iter ='Y';
         if sqlcod <> 0;
            r_chkprv = 'N';
            leave;
         else;
            iter;
         endif;
      endif;

      r_chkprv = 'N';
      if r_stm <> *blanks and %subst(r_stm:6:1)  = 'C'
         and %subst(r_stm:26:10) = '          '
         and %len(%trim(%subst(r_stm:7))) > 1
         and %subst(%trim(%subst(r_stm:7)):1) <> '/'
         and %len(%trimr(r_string))+2 < 5000
         and (%len(r_string) - (%len(%trimr(r_string)) + 2)) > 1;

         r_stm = %subst(r_stm:7:%len(r_stm)-7);
                 %subst(r_string:%len(%trimr(r_string))+2:(%len(r_string)
                 - (%len(%trimr(r_string)) + 2))) = %trim(r_stm);

      else;
         leave;
      endif;
   enddo;
endsr;

//------------------------------------------------------------------------------------- //
//Subroutine process_EVAL_fx: To Process EVAL operations (Fix)
//------------------------------------------------------------------------------------- //
begsr process_EVAL_fx;

   pos1= %scan( '=' : r_string : 1);
   if pos1 > 0 and (%len(r_string)) - pos1 > 0;
      str= %subst(r_string : pos1 +1 :(%len(r_string)) - pos1);
   endif;

   str= RMVbrackets(str);

   if pos1 > 0;
      r_string = %subst(r_string:1 :pos1) + %trim(str) ;
   endif;

   if %scan('"':r_string) > 0;
      setll *start iaclcmd;
      read iaclcmdr;
      Dow not %eof(IACLCMD);
         If %scan(%trim(CLCMDNAME) : r_string ) > 0;
            cl_status = 'Y';
            leave;
         Endif;
         read iaclcmdr;
      Enddo;
   endif;

   if cl_status = ' ';
      if r_string <> *blanks and %scan('=' : r_string) > 1
         and %scan('(' : r_string : %scan('=' : r_string)) > 0;

         clear wrk_str;
         wrk_str = %trim(%subst(r_string : %scan('=' : r_string) + 1 :
                         %scan('(' : r_string : %scan('=' : r_string)) -
                         %scan('=' : r_string) - 1));

         if %scan(' ' : wrk_str) = 0
            and %scan('/' : wrk_str) = 0
            and %scan('%' : wrk_str) = 0
            and %scan('+' : wrk_str) = 0
            and %scan('-' : wrk_str) = 0
            and %scan('*' : wrk_str) = 0
            and %lookup(%trim(wrk_str) : PRArr(*).PrArrv) > 0
            and wrk_str  <> *blanks ;
            leavesr;
         endif;

      endif;

      //Parse Eval operations
      IAPSRCEVFX(r_string        : r_type          : r_error         : uwxref :
             //  UwSrcDtl.srclib : UwSrcDtl.srcspf : UwSrcDtl.srcmbr : r_rrns :          //0012
                 UwSrcDtl        : r_rrns :                                              //0012
                 r_rrne          :  r_ErrLogFlg );
   endif;

   if r_ErrLogFlg = 'Y';
      leavesr;
   endif;

   clear cl_status;
   r_error = 'C';
   if r_error = 'C';
      r_iter = 'Y';
      exsr clear_vars;
   endif;

endsr;

//------------------------------------------------------------------------------------- //
//Subroutine process_EVAL_fr: To Process EVAL operations (Free)
//------------------------------------------------------------------------------------- //
begsr process_EVAL_fr;

   r_iter = 'N';
   pos1 = %scan( '=' : %trim(r_string) : 1);

   if pos1 > 0 and %len(%trim(r_string)) >= pos1 + 1
      and  %len(%trim(r_string)) >= ( %len(%trim(r_string))-1 ) - pos1
      and  (%len(%trim(r_string))-1 ) > pos1 ;

      str = %subst(%trim(r_string) : pos1 +1 :( %len(%trim(r_string))-1 ) - pos1);
      str = RMVbrackets(%trim(str));
      r_string = %subst(%trim(r_string) :1 :pos1) + %trim(str) + ';' ;

   endif;

   if %scan('"':r_string) > 0;
      setll *start iaclcmd;
      read iaclcmdr;
      dow not %eof(IACLCMD);
         if %scan(%trim(CLCMDNAME) : r_string ) > 0;
            cl_status = 'Y';
            leave;
         endif;
         read iaclcmdr;
      enddo;
   endif;

   if cl_status = ' ';
      if r_string <> *blanks and %scan('=' : r_string) > 0
         and %scan('(' : r_string : %scan('=' : r_string)) > 0;

         clear wrk_str;
         if  %scan('=' : r_string) > 1 and
             %scan('(' : r_string : %scan('=' : r_string)) >
             %scan('=' : r_string) - 1 ;
             wrk_str = %trim(%subst(r_string : %scan('=' : r_string) + 1 :
                         %scan('(' : r_string : %scan('=' : r_string)) -
                         %scan('=' : r_string) - 1));
         endif;

         if %scan(' ' : wrk_str) = 0
            and %scan('/' : wrk_str) = 0
            and %scan('%' : wrk_str) = 0
            and %scan('+' : wrk_str) = 0
            and %scan('-' : wrk_str) = 0
            and %scan('*' : wrk_str) = 0
            and %lookup(%trim(wrk_str) : PRArr(*).PrArrv) > 0
            and wrk_str  <> *blanks ;
            leavesr;
         endif;
      endif;

      //Parse Input/output operations
      IAPSRCFREE(r_string        : r_type          : r_error         : uwxref :
             //  UwSrcDtl.srclib : UwSrcDtl.srcspf : UwSrcDtl.srcmbr : r_rrns :          //0012
                 UwSrcDtl        : r_rrns :                                              //0012
                 r_rrne          : r_ErrLogFlg );
   endif;

   if r_ErrLogFlg = 'Y';
      Exsr clear_vars;
      leavesr;
   endif;

   clear cl_status;
   r_error = 'C';
   if r_error = 'C';
      r_iter = 'N';
      exsr clear_vars;
   endif;

endsr;

//------------------------------------------------------------------------------------- //
//Subroutine Process_lookup_fx: To Process LOOKUP operations (Fix)
//------------------------------------------------------------------------------------- //
begsr Process_lookup_fx;

   r_iter = 'N';

   //Parse Input/output operations
   IALOOKUPOP(r_string        : r_type          : r_error         :
          //  uwxref          : UwSrcDtl.srclib : UwSrcDtl.srcspf :                      //0012
              uwxref          : UwSrcDtl :                                               //0012
          //  UwSrcDtl.srcmbr : r_rrns          : r_rrne);                               //0012
              r_rrns          : r_rrne);                                                 //0012

   r_error = 'C';
   If r_error = 'C';
      r_iter = 'N';
      exsr clear_vars;
   Endif;

endsr;

//------------------------------------------------------------------------------------- //
//Subroutine Process_rpgle_fx: Generic Subroutine for Fixed RPGLE Opcodes
//------------------------------------------------------------------------------------- //
begsr Process_rpgle_fx;

   r_iter = 'N';

   IAPSR3FAC(r_string       :r_type         :r_error        :uwxref:
          // UwSrcDtl.srclib:UwSrcDtl.srcspf:UwSrcDtl.srcmbr:r_rrns:                     //0012
             UwSrcDtl       :r_rrns:                                                     //0012
             r_rrne);

   r_error = 'C';
   if r_error = 'C';
      r_iter = 'N';
      exsr clear_vars;
   endif;

endsr;

//------------------------------------------------------------------------------------- //
//Subroutine Write_RRN_Error: Write RRN Detail in Log File, If any Error Happened
//------------------------------------------------------------------------------------- //
begsr Write_RRN_Error;

   w_SrcFile   = uDpsds.SrcFile;
   exec sql
     insert into iAExcPLog (Prs_Source_Lib,
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
       values (trim(:uwSrcDtl.SrcLib),
              trim(:uwSrcDtl.SrcSpf),
              trim(:uwSrcDtl.SrcMbr),
              trim(:uDpsds.SrcLib),
              trim(:uDpsds.ProcNme),
              trim(Char(:r_Rrn)),
              trim(:uDpsds.ExcptTyp),
              trim(:uDpsds.ExcptNbr),
              trim(:uDpsds.RtvExcptDt),
              trim(:r_Stm),
              trim(:uDpsds.ModulePgm),
              trim(:uDpsds.ModuleProc));

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Insert_IAEXCPLOG';
      IaSqlDiagnostic(uDpsds);                                                           //0010
   endif;

endsr;

//------------------------------------------------------------------------------------- //
//Subroutine *Inzsr: Initialize Subroutine
//------------------------------------------------------------------------------------- //
begsr *inzsr;

endsr;

//------------------------------------------------------------------------------------- //
//Subroutine ProcessSourceStatement: To process each source line
//------------------------------------------------------------------------------------- //
begsr processSourceStatement;

   r_sqlstm = 'Select SOURCE_DATA, SOURCE_RRN, SRCLIN_TYPE '                             //0012
            + 'From   IaQrpgsrc '                                                        //0012
            + 'WHERE  substring(SrcLin_Type , 4 , 1) = '' '' '                  //0011   //0012
            + 'And    SrcLin_Type <> '' ''    '                                          //0012
            + 'And '  ;                                                                  //0012

   If UwSrcDtl.ifsloc <> *blanks;                                                        //0012
     r_sqlstm = %trim(r_sqlstm) + ' IFS_LOCATION = ''' + %trim(UwSrcDtl.ifsloc)+         //0012
                ''' order by SOURCE_rrn';                                                //0012
   else;                                                                                 //0012
     r_sqlstm = %trim(r_sqlstm) + ' LIBRARY_NAME = ''' + %trim(UwSrcDtl.srclib)+         //0012
                           ''' AND SOURCEPF_NAME = ''' + %trim(UwSrcDtl.srcspf)+         //0012
                           ''' and MEMBER_NAME   = ''' + %trim(UwSrcDtl.srcmbr)+         //0012
                           ''' order by SOURCE_rrn';                                     //0012
   endif;                                                                                //0012

   exec sql prepare Stmt from :r_sqlstm;                                                 //0012
   exec sql declare SrcStmt cursor for stmt;                                             //0012
   // 0012exec sql
   // 0012  declare SrcStmt cursor for
   // 0012    select Source_Data, Source_Rrn, SrcLin_Type                                //0004
   // 0012      from IaQrpgsrc
   // 0012    where Library_Name  = trim(:UwSrcDtl.SrcLib)
   // 0012      and SourcePf_Name = trim(:UwSrcDtl.SrcSpf)
   // 0012      and Member_Name   = trim(:UwSrcDtl.SrcMbr)
   // 0012      and SrcLin_Type <> 'FFRC' and SrcLin_Type <> 'FFCC'                      //0004
   // 0012      and SrcLin_Type <> 'FX3C' and SrcLin_Type <> 'FX4C'                      //0004
   // 0012      and SrcLin_Type <> ' '                                                   //0004
   // 0012     order by Source_Rrn ;

   //Review use order by rrn criteria.
   //Review use ucase to xlate input srcdta
   exec sql open SrcStmt;
   if sqlCode = CSR_OPN_COD;
      exec sql close SrcStmt;
      exec sql open  SrcStmt;
   endif;

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Open_srcStmt';
      IaSqlDiagnostic(uDpsds);                                                           //0010
   endif;

   if sqlCode = successCode;

      exec sql fetch SrcStmt into :r_Stm, :r_Rrn, :r_Src_Type;                           //0004
      if sqlCode < successCode;
         uDpsds.wkQuery_Name = 'Fetch_16_srcStmt';
         IaSqlDiagnostic(uDpsds);                                                        //0010
      endif;

      dow sqlCode = successCode;

         r_stm = %xlate(wk_lo:wk_Up:r_stm);                                              //0003
         monitor;

            r_ErrLogFlg = 'N';
            //Fetch next member if compile time array
            if %subst(r_stm:1:3) = '** ';
               leave;
            endif;

            r_fix = *blanks;
            if r_string = *blanks;
               r_rrns= r_rrn;
            endif;

            //Fetch Free Or Fix Format status
            exsr Fetch_Specs;

            //Pls remove line 194 - 198 after testing
            if (%subst(r_stm:6:1) = 'H' or %subst(r_stm:6:1) = 'P') And
               r_tfree = 'N';
               exsr Clear_vars;
               exec sql fetch SrcStmt into :r_Stm, :r_Rrn, :r_Src_Type;                  //0004
               r_stm = %xlate(wk_lo:wk_Up:r_stm);                                        //0003
               if sqlCode < successCode;
                  uDpsds.wkQuery_Name = 'Fetch_17_srcStmt';
                  IaSqlDiagnostic(uDpsds);                                               //0010
               endif;
               iter;
            endif;

            if r_iter = 'Y';
               r_iter = 'N';
               iter;
            endif;

            //Remove Comments, Tags And Skip Blanks
            exsr Format_String;
            if r_iter = 'Y';
               r_iter = 'N';
               iter;
            endif;

            if r_string = *blanks;
               r_string = %trimr(r_stm );
               r_rrns= r_rrn;
            else;
               r_string = %trim(r_string) + r_cat + %trim(r_stm );
               r_rrne= r_rrn;
            endif;

            if (r_tfree = 'Y' or r_mfree = 'Y' or
               (r_fix = *blanks and r_tfree = 'N' and r_mfree = 'N')) and
               ProcessScanR(';': r_string) = 0;
               exec sql fetch SrcStmt into :r_Stm, :r_Rrn, :r_Src_Type;                  //0004
               r_stm = %xlate(wk_lo:wk_Up:r_stm);                                        //0003
               if sqlCode < successCode;
                  uDpsds.wkQuery_Name = 'Fetch_18_srcStmt';
                  IaSqlDiagnostic(uDpsds);                                               //0010
               endif;
               iter;
            endif;

            if (%scan('SELECT ' : r_string) > 0
               or %scan('INSERT ' : r_string) > 0
               or %scan('UPDATE ' : r_string) > 0
               or %scan('ALTER '  : r_string) > 0
               or %scan('WHERE '  : r_string) > 0
               or %scan('DELETE ' : r_string) > 0
               or %scan('%EOF'    : r_string) > 0
               or %scan('%EQUAL'  : r_string) > 0
               or %scan('%ELEM'   : r_string) > 0
               or %scan('%ERROR'  : r_string) > 0
               or %scan('%FOUND'  : r_string) > 0 )
               and %scan('"'       : r_string) = 0;

               exsr clear_vars;
               exec sql fetch SrcStmt into :r_stm , :r_rrn, :r_Src_Type;                 //0004
               r_stm = %xlate(wk_lo:wk_Up:r_stm);                                        //0003
               if sqlCode < successCode;
                  uDpsds.wkQuery_Name = 'Fetch_19_srcStmt';
                  IaSqlDiagnostic(uDpsds);                                               //0010
               endif;
               iter;

            endif;

            //Get The Opcode
            select;

            //For RPG4 Fix Format
            when r_fix = 'C' and (r_type = 'RPGLE' or r_type = 'SQLRPGLE');
               r_ioopcode = %subst(r_string:26:10);
               if r_ioopcode <> *blanks
                  and %lookup(r_ioopcode:opcode_arr:1) >  0
                  and %lookup(r_ioopcode:opcode_arr:1) <= 135
                  and %subst(r_ioopcode:1:4) <> 'EVAL';

                  Exsr Process_rpgle_fx ;
                  if r_ErrLogFlg = 'Y';
                     exec sql fetch SrcStmt into :r_stm , :r_rrn, :r_Src_Type;           //0004
                     r_stm = %xlate(wk_lo:wk_Up:r_stm);                                  //0003
                     if sqlCode < successCode;
                        uDpsds.wkQuery_Name = 'Fetch_20_srcStmt';
                        IaSqlDiagnostic(uDpsds);                                         //0010
                     endif;
                     iter;
                  endif;

               endif;

               if r_ioopcode <> *blanks
                  and %lookup(r_ioopcode:opcode_arr:1) >= 136
                  and %lookup(r_ioopcode:opcode_arr:1) <= 155;

                  exsr concat_continue_lines;
                  exsr Process_Cond_fx;
                  if r_ErrLogFlg = 'Y';
                     exec sql fetch SrcStmt into :r_stm , :r_rrn, :r_Src_Type;           //0004
                     r_stm = %xlate(wk_lo:wk_Up:r_stm);                                  //0003
                     if sqlCode < successCode;
                        uDpsds.wkQuery_Name = 'Fetch_21_srcStmt';
                        IaSqlDiagnostic(uDpsds);                                         //0010
                     endif;
                     iter;
                  endif;

               endif;

               if r_ioopcode <> *blanks
                  and %lookup(r_ioopcode:opcode_arr:1) >= 156
                  and %lookup(r_ioopcode:opcode_arr:1) <= 160;

                  exsr concat_continue_lines;
                  exsr Process_eval_fx;

                  if r_ErrLogFlg = 'Y';
                     exec sql fetch SrcStmt into :r_stm , :r_rrn, :r_Src_Type;           //0004
                     r_stm = %xlate(wk_lo:wk_Up:r_stm);                                  //0003
                     if sqlCode < successCode;
                        uDpsds.wkQuery_Name = 'Fetch_22_srcStmt';
                        IaSqlDiagnostic(uDpsds);                                         //0010
                     endif;
                     iter;
                  endif;

               endif;

               if r_iter = 'Y';
                  r_iter = 'N';
                  iter;
               endif;

            //For RPG3 Fix Format
            when r_fix = 'C' and (r_type = 'RPG' or r_type = 'RPG38'
                 or r_type = 'SQLRPG' or r_type = 'RPG36');
               r_ioopcode = %subst(r_string:28:5);
               if r_ioopcode <> *blanks and
                  %lookup(r_ioopcode:opcode_arr1:1) > 0 and
                  %lookup(r_ioopcode:opcode_arr1:1) <= 84;
                  exsr Process_IO_rpg3;
                  if r_ErrLogFlg = 'Y';
                     exec sql fetch SrcStmt into :r_stm , :r_rrn, :r_Src_Type;           //0004
                     r_stm = %xlate(wk_lo:wk_Up:r_stm);                                  //0003
                     if sqlCode < successCode;
                        uDpsds.wkQuery_Name = 'Fetch_23_srcStmt';
                        IaSqlDiagnostic(uDpsds);                                         //0010
                     endif;
                     iter;
                  endif;
               endif;

               if r_iter = 'Y';
                  r_iter = 'N';
                  iter;
               endif;

            //For RPG Free Format
            when r_tfree = 'Y' or r_mfree = 'Y'
                 or (r_fix = *blanks and r_tfree = 'N' and r_mfree = 'N');

               r_posb = %scan(' ' : %triml(r_string) : 1);

               if r_posb-1 > 0 ;
                  if r_string <> *blanks and %len(%trim(r_string)) >= r_posb-1
                     and %lookup(%subst(%trim(r_string):1:r_posb-1):opcode_arr:1) > 0
                     and %lookup(%subst(%trim(r_string):1:r_posb-1):opcode_arr:1) <= 21;

                     r_ioopcode = %subst(r_string:1:r_posb-1);
                     exsr Process_IO_fr;
                     if r_ErrLogFlg = 'Y';
                        exec sql fetch SrcStmt into :r_stm , :r_rrn, :r_Src_Type;        //0004
                        r_stm = %xlate(wk_lo:wk_Up:r_stm);                               //0003
                        if sqlCode < successCode;
                           uDpsds.wkQuery_Name = 'Fetch_24_srcStmt';
                           IaSqlDiagnostic(uDpsds);                                      //0010
                        endif;
                        iter;
                     endif;

                  elseif %lookup(%subst(%trim(r_string):1:r_posb-1):opcode_arr:1)= 34     //0007
                    or %lookup(%subst(%trim(r_string):1:r_posb-1):opcode_arr:1)= 41       //0007
                    or %lookup(%subst(%trim(r_string):1:r_posb-1):opcode_arr:1)= 42       //0007
                    or %lookup(%subst(%trim(r_string):1:r_posb-1):opcode_arr:1)= 89       //0007
                    or %lookup(%subst(%trim(r_string):1:r_posb-1):opcode_arr:1)= 90       //0007
                    or %lookup(%subst(%trim(r_string):1:r_posb-1):opcode_arr:1)= 103      //0007
                    or %lookup(%subst(%trim(r_string):1:r_posb-1):opcode_arr:1)= 104      //0007
                    or %lookup(%subst(%trim(r_string):1:r_posb-1):opcode_arr:1)= 105;     //0007
                    Process_generic_opcode_parsing(r_string        :                      //0007
                        r_type          :  r_error         : uwxref :                     //0007
                    //  UwSrcDtl.srclib : UwSrcDtl.srcspf  : UwSrcDtl.srcmbr :        0012//0007
                    //  r_rrns : r_rrne          : r_ErrLogFlg );                     0012//0007
                        UwSrcDtl        : r_rrns : r_rrne  : r_ErrLogFlg );               //0012
                  endif;
               endif;

               if r_String <> *blanks and (%scan('+=':r_String) > 0
                  or %scan('-=':r_String) > 0
                  or %scan('*=':r_String) > 0
                  or %scan('/=':r_String) > 0 );

                  if %scan('=':%trim(r_String))-2  > 0;
                     Tmp_String = %subst(%trim(r_String):1
                                 :%scan('=':%trim(r_String))-2);
                  endif;

                  if %scan('=':%trim(r_String)) - 1 > 0;
                     Tmp_String = %trim(Tmp_String) + ' = '+%trim(Tmp_String)+
                                  %subst(%trim(r_String):(%scan('=':
                                  %trim(r_String)) - 1):1);
                  endif;

                  if %scan('=':%trim(r_String)) > 0
                     and %len(%Trim(r_String)) > %scan('=':%trim(r_String));

                     Tmp_String = %trim(Tmp_String) + %subst(%trim(r_String):
                          %scan('=':%trim(r_String))+1:%len(%Trim(r_String))
                             - %scan('=':%trim(r_String)));
                  endif;
                  r_String = %trim(Tmp_String);

               endif;

               if (%scan('=' : %trim(r_string) : 1) > 0
                  and %scan(' ' : %trim(%subst(%trim(r_string) : 1 :
                   %scan('=' : %trim(r_string) : 1) - 1)) : 1) = 0)
                  or (%scan('=' : %trim(r_string) : 1) > 0
                  and (%subst(%trim(r_string):1:4) = 'EVAL'));

                  r_ioopcode = 'EVAL';
                  exsr Process_EVAL_fr;
                  if r_ErrLogFlg = 'Y';
                     exec sql fetch SrcStmt into :r_stm , :r_rrn, :r_Src_Type;           //0004
                     r_stm = %xlate(wk_lo:wk_Up:r_stm);                                  //0003
                     if sqlCode < successCode;
                        uDpsds.wkQuery_Name = 'Fetch_25_srcStmt';
                        IaSqlDiagnostic(uDpsds);                                         //0010
                     endif;
                     iter;
                  endif;
               endif;

               if r_iter = 'Y';
                  r_iter = 'N';
                  iter;
               endif;

            endsl;

         on-error;
            exsr Write_RRN_Error;
            exsr Clear_vars;
         endmon;

         clear r_stm;
         clear r_rrn;
         clear r_string;
         clear r_ioopcode;
         exec sql fetch SrcStmt into :r_stm , :r_rrn, :r_Src_Type;                       //0004
         r_stm = %xlate(wk_lo:wk_Up:r_stm);                                              //0003
         if sqlCode < successCode;
            uDpsds.wkQuery_Name = 'Fetch_26_srcStmt';
            IaSqlDiagnostic(uDpsds);                                                     //0010
         endif;

      enddo;

      exec sql close SrcStmt;

   endif;

endsr;

//------------------------------------------------------------------------------------- //
//Compile Time Array Definitions
//------------------------------------------------------------------------------------- //
** ctdata opcode_arr
ADD                                                                  1
ADD(H)                                                               2
ADDDUR
ANDEQ                                                                3
ANDGE
ANDGT
ANDLE
ANDLT
ANDNE
BITOFF
BITON
CABEQ
CABGE
CABGT
CABLE
CABLT
CABNE
CASEQ
CASGE
CASGT
CASLE
CASLT
CASNE
CAS
CAT
CAT(P)
CHAIN
CHAIN(N)
CHAIN(E)
CHECK
CHECK(E)
CHECKR
CHECKR(E)
CLEAR
COMP
DEFINE
XXXXXXXXX                                                           //REMOVE DELETE
XXXXXXXXX                                                           //REMOVE DELETE(E)
DIV
DIV(H)
DSPLY
DSPLY(E)
XXXXXXX                                                              //REMOVE EXCEPT
XXXXXXX                                                              //REMOVE EXFMT
XXXXXXX                                                              //REMOVE EXFMT(E)
EXTRCT
EXTRCT(E)
IN
KFLD
KLIST
XXXXXX                                                              //REMOVE LEAVE
LOOKUP
MHHZO
MHLZO
MLHZO
MLLZO
MOVE
MOVE(P)
MOVEA
MOVEA(P)
MOVEL
MOVEL(P)
MULT
MULT(H)
MVR
XXXXXXX                                                            //REMOVE NEXT
XXXXXXX                                                            //REMOVE NEXT(E)
OR
ORGT
ORLT
OREQ
ORGE
ORLE
ORNE
OUT
OUT(E)
PARM
PLIST
POST
POST(E)
XXXXXXXX                                                           //REMOVE READ SECOND INDEX
XXXXXXXX                                                           //REMOVE READ(E)SECOND INDEX
XXXXXXXX                                                           //REMOVE READ(N)SECOND INDEX
XXXXXXXX                                                           //REMOVE READC  SECOND INDEX
READC(E)
READE
READE(N)
READE(E)
RESET                                                       //AP01 //REMOVE READP  SECOND INDEX
RETURN                                                     //0007  //REMOVE READP(N) SECOND INDEX
XXXXXXXX                                                           //REMOVE READP(E) SECOND INDEX
READPE
READPE(N)
READPE(E)
SCAN
SCAN(E)
SCANR
SCANR(E)
SETLL
SETLL(E)
SETGT
SETGT(E)
SORTA
SORTA(A)
SORTA(D)
SQRT
SQRT(H)
SUB
SUB(H)
SUBDUR
SUBDUR(E)
SUBST
SUBST(P)
SUBST(E)
TEST
TEST (D)
TEST (E)
TEST (T)
TEST (N)
TESTB
TESTN
TESTZ
TIME
UNLOCK
DO                                                                  //REMOVE UPDATE ADD DO
XXXXXX                                                              //REMOVE WRITE
XLATE
XLATE(E)
XLATE(P)
XFOOT
XFOOT(H)
Z-ADD
Z-ADD(H)
Z-SUB
Z-SUB(H)
WHEN
FOR
IF
IFEQ
IFLT
IFGT
IFGE
IFLE
IFNE
xxxxxx                                                              //remove do and added above
DOU
DOW
XXXXXX                                                              //REMOVE ELSE
ELSEIF
WHENEQ                                                              //RK15
WHENLT                                                              //RK15
WHENGT                                                              //RK15
WHENGE                                                              //RK15
WHENLE                                                              //RK15
WHENNE                                                              //RK15
EVAL
EVAL
EVAL(R)                                                              //remove evalr
EVAL(H)
EVAL(M)
SETLL
SETLL(E)
SETGT
SETGT(E)
CHAIN
CHAIN(N)
CHAIN(E)
XXXXXXXX                                                            //REMOVE READ
XXXXXXXX                                                            //REMOVE read(E)
XXXXXXXX                                                            //REMOVE READ(N)
XXXXXXXX                                                            //REMOVE READC
XXXXXXXX                                                            //REMOVE READC(E)
READE
READE(N)
READE(E)
XXXXXXXX                                                            //REMOVE READP
XXXXXXXX                                                            //REMOVE READP(N)
XXXXXXXX                                                            //REMOVE READP(E)
READPE
READPE(N)
READPE(E)
xxxxxxxx
xxxxxxxx
xxxxxxxx
DIV
DIV(H)
COMP
XFOOT
XFOOT(H)
SUB
SUB(H)
SUBDUR
SUBDUR(E)
XLATE
XLATE(E)
XLATE(P)
EVAL
EVAL(R)
EVAL(H)
EVAL(M)
SUBST
SUBST(E)
SUBST(P)
LOKUP
LOOKUP
ADD
Z-ADD
Z-ADD(H)
EXTRCT
EXTRCT(E)
TIME
** ctdata opcode_arr1
ADD                                                                                      // 1
ANDEQ                                                                                    // 2
ANDGE                                                                                    // 3
ANDGT                                                                                    // 4
ANDLE                                                                                    // 5
ANDLT                                                                                    // 6
ANDNE                                                                                    // 7
CABEQ                                                                                    // 8
CABGE                                                                                    // 9
CABGT                                                                                    // 10
CABLE                                                                                    // 11
CABLT                                                                                    // 12
CABNE                                                                                    // 13
CASEQ                                                                                    // 14
CASGE                                                                                    // 15
CASGT                                                                                    // 16
CASLE                                                                                    // 17
CASLT                                                                                    // 18
CASNE                                                                                    // 19
CAS                                                                                      // 20
CAT                                                                                      // 21
CHAIN                                                                                    // 22
CHECK                                                                                    // 23
CHEKR                                                                                    // 24
CLEAR                                                                                    // 25
COMP                                                                                     // 26
DIV                                                                                      // 27
DSPLY                                                                                    // 28
EXCPT                                                                                    // 29
KFLD                                                                                     // 30
KLIST                                                                                    // 31
LOKUP                                                                                    // 32
MOVE                                                                                     // 33
MOVEA                                                                                    // 34
MOVEL                                                                                    // 35
MULT                                                                                     // 36
MVR                                                                                      // 37
OCUR                                                                                     // 38
OR                                                                                       // 39
ORGT                                                                                     // 40
ORLT                                                                                     // 41
OREQ                                                                                     // 42
ORGE                                                                                     // 43
ORLE                                                                                     // 44
ORNE                                                                                     // 45
PARM                                                                                     // 46
PLIST                                                                                    // 47
READE                                                                                    // 48
READP                                                                                    // 49
REDPE                                                                                    // 50
SCAN                                                                                     // 51
SCANR                                                                                    // 52
SETLL                                                                                    // 53
SETGT                                                                                    // 54
SORTA                                                                                    // 55
SQRT                                                                                     // 56
SUB                                                                                      // 57
SUBST                                                                                    // 58
TESTB                                                                                    // 59
TESTN                                                                                    // 60
TESTZ                                                                                    // 61
TIME                                                                                     // 62
Z-ADD                                                                                    // 63
Z-SUB                                                                                    // 64
UNLCK                                                                                    // 65
DO                                                                  //REMOVE UPDATE ADD D// 66
XLATE                                                                                    // 67
XFOOT                                                                                    // 68
WHEN                                                                                     // 69
FOR                                                                                      // 70
IF                                                                                       // 71
IFEQ                                                                                     // 72
IFLT                                                                                     // 73
IFGT                                                                                     // 74
IFGE                                                                                     // 75
IFLE                                                                                     // 76
IFNE                                                                                     // 77
DOU                                                                                      // 78
DOW                                                                                      // 79
WHEQ                                                                                     // 80
WHGE                                                                                     // 81
WHGT                                                                                     // 82
WHLE                                                                                     // 83
WHEQ                                                                                     // 84
