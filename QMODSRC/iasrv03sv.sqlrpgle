**free
      //%METADATA                                                      *
      // %TEXT 03 Service Program Module                               *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------    //
//CREATED BY :   Programmers.io @ 2020                                                    //
//CREATE DATE:   2020/01/01                                                               //
//DEVELOPER  :   Kaushal kumar                                                            //
//DESCRIPTION:   Service Program Module - 3                                               //
//                                                                                        //
//PROCEDURE LOG:                                                                          //
//------------------------------------------------------------------------------------    //
//Procedure Name           | Procedure Description                                        //
//-------------------------|----------------------------------------------------------    //
//IaPsrMoveFx              |                                                              //
//IaPsrCharFr              |                                                              //
//IaSubStbif               |                                                              //
//IaPsrTrm                 |                                                              //
//IaPsrEditc               |                                                              //
//IaPsrEditw               |                                                              //
//IaPsrDat                 |                                                              //
//IaDivBif                 |                                                              //
//IaPsrcFree               |                                                              //
//IaLookupBif              |                                                              //
//IaReplace                |                                                              //
//IaPsrXfFr                |                                                              //
//IaPsrCevFx               |                                                              //
//IaPsrScn                 |                                                              //
//IaPsrLen                 |                                                              //
//IaPsrChkop               |                                                              //
//IaPsrChk                 |                                                              //
//IaTimeBif                |                                                              //
//IaXltBif                 |                                                              //
//IaIntBif                 |                                                              //
//IaPsrIoFr                |                                                              //
//IaDays                   |                                                              //
//IaRemBif                 |                                                              //
//IaSubsttBif              |                                                              //
//IaDecBif                 |                                                              //
//CallBif                  |                                                              //
//Split_Component_4        |                                                              //
//Split_Component_6        |                                                              //
//ProcedureCallCheck       |                                                              //
//Split_Component_5        |                                                              //
//IaPsrcFix                |                                                              //
//------------------------------------------------------------------------------------    //
//                                                                                        //
//MODIFICATION LOG:                                                                       //
//------------------------------------------------------------------------------------    //
//Date    | Mod_ID | Developer  | Case and Description                                    //
//--------|--------|------------|-----------------------------------------------------    //
//22/03/16| NG01   | Nikhil     | Const missing in Negative numbers                       //
//22/03/08| YK01   | Yashwant   | %Check Data was not coming in IAVARREL                  //
//22/04/04| SK02   | Santhosh   | %Check BIF doesnt retrieve Factor 2 with a BIF          //
//07/04/22| BA11   | BHOOMISH A | Infinite Loop issue (DOW 1=1)                           //
//22/04/04| SK01   | Santhosh   | Bug fix - Range of subscript error                      //
//22/16/06| SB01   | Sriram B   | Free Format Eval Issue Fix - Code Optimization          //
//22/30/06| JM01   | Jagdish M  | Fixed format Eval Added new assingment operator logic   //
//22/07/01| JM02   | Jagdish M  | Added pasing logic operators after equalto              //
//22/07/04| JM03   | Jagdish M  | Added pasing logic operators after equalto-eval free    //
//22/07/06| RK15   | Rahul K    | WHENxx opcode included in fix format                    //
//22/24/06| MT02   | Mahima     | Array tracking of VWU                                   //
//22/06/16| VK01   | Vishwas K. | Bug fix - %check, %Scan factor sepration                //
//22/08/24| SK05   | Santhosh   | Generic BIF parser proc - 14 BIFs                       //
//22/08/26| SK06   | Santhosh   | EXCPLOG Bugs - Len or start pos error                   //
//22/08/25| MT03   | Mahima     | IAEXCPLOG issue Range or Subscript error                //
//22/08/25| MT04   | Mahima     | IAEXCPLOG issue Receiver Value too small to hold result //
//22/09/13| BS01   | Sudha      | IAEXCPLOG issue 'Length or start position is out of     //
//        |        |            | range for the string operation'                         //
//22/09/14| BS02   | Sudha      | IAEXCPLOG issue 'Length or start position is out of     //
//        |        |            | range for the string operation' for %lookup bif         //
//22/09/14| SJxx   | Sunny Jha  | IAEXCPLOG issue'Receiver value too small to hold result'//
//22/09/16|        | Santhosh   | IAEXCPLOG Len or pos issue - IAPSRCEVFX, Assignment_Oper//
//22/09/16|        | Santhosh   | RCVR too small issue - Split_Component_6                //
//22/09/19|        | Manav T    | Changed logic to handle multiple operator handling      //
//22/09/19|        | Sushant S  | Handled Nested BIF like %Dec(%Date)                    //
//22/09/26| BS03   | Sudha      | IAEXCPLOG issue 'AUTOMATIC STORAGE OVERFLOW' for %time  //
//        |        |            | bif                                                     //
//22/09/27|        | Anchal J   | Error handling in procedures                            //
//22/10/04|        | Manav T    | Optimization of procedures IAPSRCHARFR,IAPSRTRM,IAPSRBIF//
//        |        |            | ,IAPSREDITC,IAPSREDITW,IADIVBIF,IAREPLACE,IAPSRSCN,     //
//        |        |            | IAPSRCHK,IAREMBIF,IASUBSTTBIF and IADECBIF              //
//22/10/12| BS04   | Sudha      | Added logic to handle %scanrpl BIF using IAREPLACE      //
//22/10/06| SB02   | Sriram B   | Removed all the Monitor - On Error Blocks used          //
//22/12/12| SS02   | Sushant S  | Handled Crashing Situation in Diff procedures           //
//22/12/27|        | Manav T    | Optimized code for error and faster computation         //
//23/01/02| AK01   | Akshay S   | Optimized code for error and faster computation         //
//23/01/02| VP01   | Vipul P    | Optimized code for error and faster computation         //
//23/02/01| 0001   |Pranav Joshi| Error handling.                                         //
//23/10/06| 0002   | Vamsi      | Added %SUBARR BIF to the list to get parsed by          //
//        |        | Krishna2   | IAPSRBIF (Task#28)                                      //
//24/05/24| 0003   |Yogesh      | Issue: Jira #648 - Automatic storage overflow           //
//        |        |Chandra     | CALLBIF procedure called recursively, due to this recur-//
//        |        |            | sive call storage overflow message populated in the job //
//        |        |            | log during the build metada process.                    //
//        |        |            | Recursive call happened because after extraction of     //
//        |        |            | factor-1 and factor-2, position variable r_epos is not  //
//        |        |            | calculated, so r_epos always have the default value, it //
//        |        |            | cause the factor-2 values as a complete string during   //
//        |        |            | the re-extraction.Due to this CALLBIF executed recursiv-//
//        |        |            | iely even once both factor-1 and factor-2 extracted.    //
//        |        |            | So avoid the re-extraction of the factor-2 once both    //
//        |        |            | factor-1 and factor-2 extracted sucessfully.            //
//21/01/25| 0004   |Vamsi       | IAPGMFILES is restructured.So,updated in all dependent  //
//        |        |Krishna2    | procedures. (Task#63)                                   //
//08/26/24| 0005   |Vishwas  K. | Included the logic for parsing IFS member.              //
//--------------------------------------------------------------------------------------- //

ctl-opt copyright('Programmers.io Â© 2020 | Ashish | Changed April 2021');
ctl-opt option(*noDebugIo: *srcStmt: *noUnRef) expropts(*RESDECPOS) debug;
ctl-opt nomain;
ctl-opt bndDir('IABNDDIR');

dcl-ds UwSrcDtl ;                                                                        //0005
       in_srclib   Char(10) ;                                                            //0005
       in_srcspf   Char(10) ;                                                            //0005
       in_srcmbr   Char(10) ;                                                            //0005
       in_ifsloc   Char(100);                                                            //0005
       in_srcType  Char(10) ;                                                            //0005
       in_srcStat  Char(1)  ;                                                            //0005
end-ds;                                                                                  //0005

/copy 'QMODSRC/iasrv01pr.rpgleinc'
/copy 'QMODSRC/iasrv03pr.rpgleinc'

dcl-ds PSDS extname('IAPSDSF') PSDS qualified;
end-ds;

dcl-ds IAVARRELDS    extname('IAVARREL') prefix(in_) inz;
end-ds;

dcl-ds IAVARRELDS1   extname('IAVARREL') prefix(Ch_) inz;
end-ds;

dcl-ds dv_IAVARRELDS extname('IAVARREL') prefix(dv_) inz;
end-ds;

dcl-ds lk_IAVARRELDS extname('IAVARREL') prefix(lk_) inz;
end-ds;

dcl-ds mt_IAVARRELDS extname('IAVARREL') prefix(mt_) inz;
end-ds;

dcl-ds xl_IAVARRELDS extname('IAVARREL') prefix(xl_) inz;
end-ds;

dcl-ds ss_IAVARRELDS extname('IAVARREL') prefix(ss_) inz;
end-ds;

dcl-c UPPER      'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
dcl-c LOWER      'abcdefghijklmnopqrstuvwxyz';
dcl-c DIGITS     '0123456789';
dcl-c SQL_ALL_OK '00000';

exec sql
  set option commit    = *none,
             naming    = *sys,
             usrprf    = *user,
             dynusrprf = *user,
             closqlcsr = *endmod,
             srtseq    = *langidshr;


//---------------------------------------------------------------------------- //
//IaPsrCharFr :
//---------------------------------------------------------------------------- //
Dcl-proc IAPSRCHARFR Export;
   dcl-pi IAPSRCHARFR;
      in_string  char(5000);
      in_opcode  char(10);
      in_type    char(10);
    //in_srclib  char(10);                                                               //0005
    //in_srcspf  char(10);                                                               //0005
    //in_srcmbr  char(10);                                                               //0005
      in_uWSrcDtl likeds(uWSrcDtl);                                                      //0005
      in_RRN     packed(6:0);
      in_Factor1 char(80);
      in_Factor2 char(80);
      in_Seq     packed(6:0);
   end-pi;

   dcl-ds  Ch_IAVARRELDS  extname('IAVARREL') prefix(Ch_) inz;
   end-ds;

   dcl-s arraysignpositions packed(5)     dim(600) ascend inz;                           //MT03
   dcl-s tempArray          packed(5)     dim(600) ascend inz;                           //MT03
   dcl-s arrayaddsign       packed(3:0)   dim(600);                                      //MT03
   dcl-s arraysubsign       packed(3:0)   dim(600);                                      //MT03
   dcl-s arraymulsign       packed(3:0)   dim(600);                                      //MT03
   dcl-s arraydivsign       packed(3:0)   dim(600);                                      //MT03
   dcl-s Ch_Spos            packed(6:0)   inz;
   dcl-s Ch_Epos            packed(6:0)   inz;
   dcl-s Ch_pos             packed(6:0)   inz;
   dcl-s start              packed(6:0)   inz;
   dcl-s Ch_TLpos           packed(4:0)   inz;
   dcl-s Ch_OBpos           packed(4:0)   inz;
   dcl-s Ch_Length          packed(4:0)   inz;
   dcl-s Ch_CBpos           packed(4:0)   inz;
   dcl-s Ch_BIF1pos         packed(4:0)   inz;
   dcl-s Ch_BIF2OBpos       packed(4:0)   inz;
   dcl-s Ch_BIF1            packed(4:0)   inz;
   dcl-s ch_BIF1@           packed(4:0)   inz;
   dcl-s Ch_BIF2            packed(4:0)   inz;
   dcl-s Ch_BIF2pos         packed(4:0)   inz;
   dcl-s Ch_SCpos           packed(4:0)   inz;
   dcl-s ch_bkseq           packed(6:0)   inz;
   dcl-s Ch_BIF1OBpos       packed(4:0)   inz;
   dcl-s intermediateAddPos packed(3:0)   inz;
   dcl-s intermediateSubPos packed(3:0)   inz;
   dcl-s intermediateMulPos packed(3:0)   inz;
   dcl-s intermediateDivPos packed(3:0)   inz;
   dcl-s OBpos              packed(4:0)   inz;
   dcl-s tr_Counter         packed(4:0)   inz;
   dcl-s ev_bkseq           packed(6:0)   inz;
   dcl-s tr_Length          packed(4:0)   inz;
   dcl-s tr_Bracket         packed(4:0)   inz;
   dcl-s frompos            packed(3:0)   inz;
   dcl-s i                  packed(6:0)   inz;
   dcl-s j                  packed(4:0)   inz;
   dcl-s Count              packed(2:0)   inz;
   dcl-s Ch_Len2            packed(4:0)   inz;
   dcl-s operatorArr        char(1)       dim(600) ascend inz;                           //MT03
   dcl-s arr                char(600)     dim(600) ascend inz;                           //MT03
   dcl-s SUBSETVARS         char(600)     dim(600) ascend inz;                           //MT03
   dcl-s Ch_rebif1          char(80)      inz;
   dcl-s W_SrcFile          char(10)      inz;
   dcl-s flag               Char(10)      inz;
   dcl-s CaptureFlg         char(1)       inz;
   dcl-s Ch_Opflg           char(1)       inz;
   dcl-s Ch_bifFlg          char(1)       inz;
   dcl-s field2             Char(500)     inz;
   dcl-s field4             Char(5000)    inz;
   dcl-s Ch_inquote         char(1)       inz;
   dcl-s Ch_Factor1         char(50)      inz;
   dcl-s Ch_Factor2         char(50)      inz;
   dcl-s Ch_BIFstring       char(5000)    inz;
   dcl-s Ch_String1         char(5000)    inz;
   dcl-s Ch_String2         char(5000)    inz;
   dcl-s Ch_BIF1name        char(10)      inz;
   dcl-s Ch_BIF2name        char(10)      inz;
   dcl-s Ch_BIFname         char(10)      inz;
   dcl-s in_tmpFlag         char(10)      inz;
   dcl-s in_tmpString       char(5000)    inz;
   dcl-s Ch_Result          char(500)     inz;
   dcl-s string             char(5000)    inz;
   dcl-s In_bif             char(10)      inz;
   dcl-s Ch_bkfact2         varchar(5000) inz;
   dcl-s Ch_bkfact1         varchar(5000) inz;
   dcl-s In_string1         varchar(5000) inz;
   dcl-s k                  packed(4:0)   inz;
   dcl-s l                  int(5)        inz;
   dcl-s Z                  int(5)        inz;
   dcl-s index              int(5)        inz;
   dcl-s itr                int(5)        inz;
   dcl-s ndx                int(5)        inz;
   dcl-s rdx                int(5)        inz;
   dcl-s Pos                int(5)        inz;
   dcl-s X                  int(5)        inz;
   dcl-s c                  char(1)       inz;
   dcl-s arr_var            char(600)     inz;
   dcl-s str_len            packed(4:0)   inz;
   dcl-c Ch_Quote           '"';

   if in_string = *Blanks;
      return;
   endif;

   uwsrcdtl = In_uwsrcdtl;                                                               //0005

   clear Ch_IAVARRELDS;
   in_string = %xlate(LOWER :UPPER :in_string);
   Ch_pos = %scan('~' :in_string :1);
   If Ch_pos <> 0 and %len(%trim(in_string)) >= Ch_pos;                                    //SS02
     in_string = %replace('' :in_string :Ch_pos :1);
     Ch_pos = %scan('%CHAR':%trim(in_string):Ch_pos);
   elseif %len(%trim(in_string)) >= 1;                                                     //SS02
     Ch_pos = %scan('%CHAR':%trim(in_string):1);                                           //SS02
   EndIf;                                                                                  //SS02
   k = 0;
   str_len = %len(%trim(in_string));
   if Ch_pos <> 0 and str_len >= Ch_pos +5;
      for i = Ch_pos +5 to str_len;
          c = %subst(in_string:i:1);
          select;
          when c = '(';
             inquote(in_string :i :Ch_inquote);
             if Ch_inquote = 'N';
                if start = 0;
                   start = i;
                else;
                   tr_bracket +=1;
                endif;
             endif;
          when c = ')';
             inquote(in_string :i :Ch_inquote);
             if Ch_inquote = 'N';
                select;
                when k = 0 and tr_bracket = 0 and i-start > 1;                             //SS02
                   Ch_bkfact1 = %subst(in_string :start+1 :i-start-1);
                   start=i+1;
                when k = 1 and tr_bracket = 0 and start > 0 and i > start ;                //SS02
                   Ch_bkfact2 = %subst(in_string :start :i-start);
                   leave;
                endsl;
                tr_bracket -=1;
             endif;
          when c = ':';
             inquote(in_string :i :Ch_inquote);
             if Ch_inquote = 'N';
                if tr_bracket = 0;
                   k+=1;
                   select;
                   when k = 1 and i-start > 1;                                             //SS02
                      Ch_bkfact1 = %subst(in_string :start+1 :i-start-1);
                      start=i+1;
                   when k = 2 and start > 0 and i > start ;                                //SS02
                      Ch_bkfact2 = %subst(in_string :start :i-start);
                      leave;
                   endsl;
                endif;
             endif;
          other;
          endsl;
      endfor;

      k = 0;
      if Ch_bkfact1 <> *Blanks;
         In_string1 = %trim(Ch_bkfact1);
         split_component_5(In_string1 :arr :operatorarr :k);
      else;
         return;
      endif;
      k += 1;

      ch_reseq = in_seq;
      for j = 1 to k-1;
         if j <= %elem(arr) and arr(j) <> *Blanks;
            arr_var = %trim(arr(j));
            Ch_Epos = %scan('%'  : arr_var);
            Ch_Spos = %scan('''' : arr_var);
            if Ch_Spos = 0;
               Ch_Spos = %scan('"' : arr_var);
            endif;
            Ch_recomp  = %trim(operatorarr(j));

            clear In_factor2;
            select;
            when Ch_Spos <> 0 and Ch_Epos <> 0 and Ch_Spos < Ch_Epos;
               in_Factor1 = 'CONST(' + %trim(arr(j)) + ')';
               if k = 2;
                  leave;
               endif;
               Ch_reseq += 1;
               Ch_recontin = 'AND';
               IAVARRELLOG( in_srclib    :
                            in_srcspf    :
                            in_srcmbr    :
                            in_ifsloc    :                                               //0005
                            in_reseq     :
                            in_rrn       :
                            Ch_reroutine :
                            Ch_rereltyp  :
                            Ch_rerelnum  :
                            Ch_reopc     :
                            Ch_reresult  :
                            Ch_rebif     :
                            in_factor1   :
                            Ch_recomp    :
                            in_factor2   :
                            Ch_recontin  :
                            Ch_reresind  :
                            Ch_recat1    :
                            Ch_recat2    :
                            Ch_recat3    :
                            Ch_recat4    :
                            Ch_recat5    :
                            Ch_recat6    :
                            Ch_reutil    :
                            Ch_renum1    :
                            Ch_renum2    :
                            Ch_renum3    :
                            Ch_renum4    :
                            Ch_renum5    :
                            Ch_renum6    :
                            Ch_renum7    :
                            Ch_renum8    :
                            Ch_renum9    :
                            Ch_reexc     :
                            Ch_reinc);

            when Ch_Epos <> 0 and (Ch_Spos > Ch_Epos or Ch_Spos = 0);
               Ch_pos      = %scan('(' :arr(j) :Ch_Epos);
               // If Ch_pos <> 0;                                                           //PJ01
               If Ch_Epos > 0 and Ch_pos > Ch_Epos ;                                        //PJ01
                  Ch_rebif    = %subst(arr(j) :Ch_Epos :Ch_pos-Ch_Epos);
               Else;
                  Ch_rebif    = arr(j);
               EndIf;
               string     = '~' + %subst(%trim(arr(j)) :Ch_Epos);
             //callbif(in_srclib  :                                                      //0005
             //        in_srcspf  :                                                      //0005
             //        in_srcmbr  :                                                      //0005
               callbif(in_uWSrcDtl:                                                      //0005
                       In_rrn     :
                       Ch_reseq   :
                       Ch_bkseq   :
                       Ch_REOPC   :
                       in_factor1 :
                       in_factor2 :
                       in_type    :
                       Ch_RECOMP  :
                       Ch_rebif   :
                       flag       :
                       field2     :
                       string     :
                       field4 );
            Other;
               select ;
               when Ch_Spos <> 0;
                  clear Ch_rebif;
                  in_factor1 = 'CONST(' + %trim(arr(j)) + ')';
               when %check('.0123456789' :%Trim(arr(j))) <> 0;
                  in_factor1 = %trim(arr(j));
               other ;
                  clear Ch_rebif;
                  in_factor1 = 'CONST(' + %trim(arr(j)) + ')';
               endsl;
               if k = 2;
                  leave;
               endif;

               If %trim(in_factor1) = 'CONST()';
               else;
                  Ch_reseq += 1;
                  Ch_recontin = 'AND';
                  IAVARRELLOG( in_srclib    :
                               in_srcspf    :
                               in_srcmbr    :
                               in_ifsloc    :                                            //0005
                               Ch_reseq     :
                               in_rrn       :
                               Ch_reroutine :
                               Ch_rereltyp  :
                               Ch_rerelnum  :
                               Ch_reopc     :
                               Ch_reresult  :
                               Ch_rebif     :
                               in_factor1   :
                               Ch_recomp    :
                               in_factor2   :
                               Ch_recontin  :
                               Ch_reresind  :
                               Ch_recat1    :
                               Ch_recat2    :
                               Ch_recat3    :
                               Ch_recat4    :
                               Ch_recat5    :
                               Ch_recat6    :
                               Ch_reutil    :
                               Ch_renum1    :
                               Ch_renum2    :
                               Ch_renum3    :
                               Ch_renum4    :
                               Ch_renum5    :
                               Ch_renum6    :
                               Ch_renum7    :
                               Ch_renum8    :
                               Ch_renum9    :
                               Ch_reexc     :
                               Ch_reinc );
               Endif;
            Endsl;
            In_factor2 = %trim(Ch_bkfact2);
            clear In_factor1;
         endif;
      endfor;
      in_seq = Ch_reseq;
   endif;

   return;
end-proc;


//----------------------------------------------------------------------------- //
//IaPsrTrm :
//----------------------------------------------------------------------------- //
Dcl-proc IAPSRTRM export;
   dcl-pi IAPSRTRM;
      in_string  char(5000);
      in_opcode  char(10);
      in_type    char(10);
   // in_srclib  char(10);                                                               //0005
   // in_srcspf  char(10);                                                               //0005
   // in_srcmbr  char(10);                                                               //0005
      in_uWSrcDtl likeds(uWSrcDtl);                                                      //0005
      in_RRN     packed(6:0);
      lk_refact1 char(80);
      lk_refact2 char(80);
      in_Seq     packed(6:0);
   end-pi;

   dcl-s Arr           char(600)      inz dim(600);                                      //MT03
   dcl-s xl_ArrayOpt   char(1)        dim(600);                                          //MT03
   dcl-s flag          Char(10)       inz;
   dcl-s field2        Char(500)      inz;
   dcl-s String        char(5000)     inz;
   dcl-s field4        Char(5000)     inz;
   dcl-s l_inquote     char(1)        inz;
   dcl-s l_bkfact2     varchar(5000)  inz;
   dcl-s l_bkfact1     varchar(5000)  inz;
   dcl-s xl_in_string  varchar(5000);
   dcl-s l_bkseq       packed(6:0)    inz;
   dcl-s l_pos         packed(6:0)    inz;
   dcl-s l_Spos        packed(6:0)    inz;
   dcl-s l_Epos        packed(6:0)    inz;
   dcl-s w_Epos        packed(6:0)    inz;
   dcl-s w_ctl         packed(2:0)    inz;
   dcl-s start         packed(6:0)    inz;
   dcl-s i             packed(4:0)    inz;
   dcl-s j             packed(4:0)    inz;
   dcl-s k             packed(6:0)    inz;
   dcl-s c             char(1)        inz;
   dcl-s tr_Bracket    packed(4:0)    inz;
   dcl-s str_len       packed(4:0)    inz;
   dcl-s arr_var       char(600)      inz;

   if in_string = *Blanks;
      return;
   endif;
   uwsrcdtl = In_uwsrcdtl;                                                                 //0005
   str_len = %len(%trimr(in_string));
   in_string = %xlate(LOWER: UPPER: in_string);
   l_pos     = %scan('~' :in_string :1);
   If l_pos > 0;                                                                           //SS02
      in_string = %replace('' :in_string :l_pos :1);
      l_pos = %scan('%TRIM':in_string :l_pos);
   else ;                                                                                  //SS02
      l_pos = %scan('%TRIM':in_string :1);                                                 //SS02
   Endif;                                                                                  //SS02
   tr_bracket = 0;
   start = 0;
   if l_pos <> 0;
      for k = l_pos +5 to str_len;
          c = %subst(in_string:k:1);
          select;
          when c = '(';
             inquote(in_string :k :l_inquote);
             if l_inquote = 'N';
                if start = 0;
                   start = k;
                else;
                   tr_bracket +=1;
                endif;
             endif;
          when c = ')';
             inquote(in_string :k :l_inquote);
             if l_inquote = 'N';
                if tr_bracket = 0 and k-start > 1;                                         //SS02
                   l_bkfact1 = %subst(in_string :start+1 :k-start-1);
                endif;
                tr_bracket -=1;
             endif;
          when c = ':';
             inquote(in_string :k :l_inquote);
             if l_inquote = 'N';
                if tr_bracket = 0 and k-start > 1;                                         //SS02
                   l_bkfact1 = %subst(in_string :start+1 :k-start-1);
                endif;
             endif;
          other;
          endsl;
      endfor;
// if %scan('%TRIM'     :in_string :l_pos) <> 0 or
//     %scan('%TRIMR'    :in_string :l_pos) <> 0 or
//     %scan('%TRIML'    :in_string :l_pos) <> 0 ;

//     l_pos =  %scan('(' :in_string :l_pos);
//     start =  l_pos;

//     l_Spos = %scan('(' :in_string :l_pos+1);
//     if l_spos <> 0;
//        inquote(in_string :l_spos :l_inquote);
//        dow l_inquote = 'Y';
//           l_Spos = %scan('(' :in_string :l_spos+1);
//           if l_spos <> 0;
//              inquote(in_string :l_spos :l_inquote);
//           else;
//              l_inquote = 'N';
//           endif;
//        enddo;
//     endif;
//
//     l_Epos = %scan(':' :in_string :l_pos+1);
//     if l_epos <> 0;
//        inquote(in_string :l_epos :l_inquote);
//        dow l_inquote = 'Y';
//           l_epos = %scan(':' :in_string :l_epos+1);
//           if l_epos <> 0;
//              inquote(in_string :l_epos :l_inquote);
//           else;
//              l_inquote = 'N';
//           endif;
//        enddo;
//     endif;

//     dow l_Spos < l_Epos;
//
//        if l_Spos <> 0;
//           findcbr(l_Spos :in_string);
//           l_pos = l_Spos;
//
//           if l_pos < l_Epos;
//              l_Spos = %scan('(' :in_string :l_pos+1);
//              if l_spos <> 0;
//                 inquote(in_string :l_spos :l_inquote);
//                 dow l_inquote = 'Y';
//                    l_spos = %scan(':' :in_string :l_spos+1);
//                    if l_spos <> 0;
//                       inquote(in_string :l_spos :l_inquote);
//                    else;
//                       l_inquote = 'N';
//                    endif;
//                 enddo;
//              endif;
//
//           elseif l_pos > l_Epos;
//              l_Epos = %scan(':' :in_string :l_pos+1);
//              if l_epos <> 0;
//                 inquote(in_string :l_epos :l_inquote);
//                 dow l_inquote = 'Y';
//                    l_epos = %scan(':' :in_string :l_epos+1);
//                    if l_epos <> 0;
//                       inquote(in_string :l_epos :l_inquote);
//                    else;
//                       l_inquote = 'N';
//                    endif;
//                 enddo;
//              endif;
//
//              l_Spos = %scan('(' :in_string :l_pos+1);
//              if l_spos <> 0;
//                 inquote(in_string :l_spos :l_inquote);
//                 dow l_inquote = 'Y';
//                    l_spos = %scan(':' :in_string :l_spos+1);
//                    if l_spos <> 0;
//                       inquote(in_string :l_spos :l_inquote);
//                    else;
//                       l_inquote = 'N';
//                    endif;
//                 enddo;
//              endif;
//           endif;
//        else;
//           l_Spos = l_Epos + 1;
//        endif;

//     enddo;
//
//     //If l_Epos <> 0 ;
//     If (l_Epos-start) > 1;
//        l_bkfact1 = %subst(in_string :start+1 :l_Epos-start-1);
//     Else ;
//        l_Epos = start;
//        findcbr(l_Epos :in_string);
//        l_bkfact1 = %subst(in_string :start+1 :l_Epos-start-1);
//     EndIf ;

       l_bkfact1 = RMVbrackets(l_bkfact1);

       xl_in_string = l_bkfact1 ;
       split_component_5(xl_in_string :arr :xl_ArrayOpt :i);

       lk_reseq = in_seq;
       for j = 1 to i ;
           if j <= %elem(arr) and arr(j) <> *Blanks;
              arr_var = %trim(arr(j));
              if %scan('(' : arr_var) = 1;
                 arr(j) = RMVbrackets(arr(j));
              endif;
              l_Epos = %scan('%'  :arr_var);
              l_Spos = %scan('''' :arr_var);
              if l_Spos = 0;
                l_Spos = %scan('"' :arr_var);
              endif;

              lk_recomp  = xl_ArrayOpt(J);

              clear lk_refact2;
              select;
              when l_Spos <> 0 and l_Spos < l_Epos;
                 lk_refact1 = 'CONST(' + %trim(arr(j)) + ')';

                 if i = 1;
                    leave;
                 endif;

                 lk_reseq += 1;
                 lk_recontin = 'AND';

                 iavarrellog(in_srclib    :
                             in_srcspf    :
                             in_srcmbr    :
                             in_ifsloc    :                                              //0005
                             lk_reseq     :
                             in_rrn       :
                             lk_reroutine :
                             lk_rereltyp  :
                             lk_rerelnum  :
                             lk_reopc     :
                             lk_reresult  :
                             lk_rebif     :
                             lk_refact1   :
                             lk_recomp    :
                             lk_refact2   :
                             lk_recontin  :
                             lk_reresind  :
                             lk_recat1    :
                             lk_recat2    :
                             lk_recat3    :
                             lk_recat4    :
                             lk_recat5    :
                             lk_recat6    :
                             lk_reutil    :
                             lk_renum1    :
                             lk_renum2    :
                             lk_renum3    :
                             lk_renum4    :
                             lk_renum5    :
                             lk_renum6    :
                             lk_renum7    :
                             lk_renum8    :
                             lk_renum9    :
                             lk_reexc     :
                             lk_reinc );

              when l_Epos <> 0 and (l_Spos > l_Epos or l_Spos = 0);

                 l_pos      = %scan('(' :arr(j) :l_Epos);
               //If l_pos <> 0;
                 If l_pos > l_Epos ;                                                        //PJ01
                    lk_rebif   = %subst(arr(j) :l_Epos :l_pos-l_Epos);
                 Else;
                    lk_rebif   = arr(j);
                 EndIf;
                 string     = '~' + %subst(%trim(arr(j)) :l_Epos);

               //callbif(in_srclib  :                                                      //0005
               //        in_srcspf  :                                                      //0005
               //        in_srcmbr  :                                                      //0005
                 callbif(in_uWSrcDtl:                                                      //0005
                         In_rrn     :
                         lk_reseq   :
                         l_bkseq    :
                         lk_REOPC   :
                         lk_refact1 :
                         lk_refact2 :
                         in_type    :
                         lk_RECOMP  :
                         lk_reBIF   :
                         flag       :
                         field2     :
                         string     :
                         field4 );

              other;
                 if l_Spos <> 0;
                    lk_refact1 = 'CONST(' + %trim(arr(j)) + ')';
                 elseif %check('.0123456789' :%trim(arr(j))) <> 0;
                    lk_refact1 = %trim(arr(j));
                 else;
                    lk_refact1 = 'CONST(' + %trim(arr(j)) + ')';
                 endif;

                 if i = 1;
                    leave;
                 endif;

                 If %trim(lk_refact1) = 'CONST()';
                 Else;
                    lk_reseq += 1;
                    lk_recontin = 'AND';
                    iavarrellog(in_srclib    :
                                in_srcspf    :
                                in_srcmbr    :
                                in_ifsloc    :                                           //0005
                                lk_reseq     :
                                in_rrn       :
                                lk_reroutine :
                                lk_rereltyp  :
                                lk_rerelnum  :
                                lk_reopc     :
                                lk_reresult  :
                                lk_rebif     :
                                lk_refact1   :
                                lk_recomp    :
                                lk_refact2   :
                                lk_recontin  :
                                lk_reresind  :
                                lk_recat1    :
                                lk_recat2    :
                                lk_recat3    :
                                lk_recat4    :
                                lk_recat5    :
                                lk_recat6    :
                                lk_reutil    :
                                lk_renum1    :
                                lk_renum2    :
                                lk_renum3    :
                                lk_renum4    :
                                lk_renum5    :
                                lk_renum6    :
                                lk_renum7    :
                                lk_renum8    :
                                lk_renum9    :
                                lk_reexc     :
                                lk_reinc );
                 Endif;

              endsl;
              clear lk_refact1;
          endif;
       endfor;

       in_seq = lk_reseq;

   endif;

   Return;

end-proc;

//--------------------------------------------------------------------------- //        //SK05
//IAPSRBIF - Generic BIF parser for 14 BIFs                                   //        //SK05
//--------------------------------------------------------------------------- //        //SK05
Dcl-proc IAPSRBIF export;                                                                //SK05
   dcl-pi IAPSRBIF;                                                                      //SK05
      in_string  char(5000);                                                             //SK05
      in_opcode  char(10);                                                               //SK05
      in_type    char(10);                                                               //SK05
  //  in_srclib  char(10);                                                               //0005
  //  in_srcspf  char(10);                                                               //0005
  //  in_srcmbr  char(10);                                                               //0005
      in_uWSrcDtl likeds(uWSrcDtl);                                                      //0005
      in_RRN     packed(6:0);                                                            //SK05
      lk_refact1 char(80);                                                               //SK05
      lk_refact2 char(80);                                                               //SK05
      in_Seq     packed(6:0);                                                            //SK05
   end-pi;                                                                               //SK05
                                                                                         //SK05
   dcl-s Arr           char(600)      inz dim(600);                                      //MT03
   dcl-s xl_ArrayOpt   char(1)        dim(600);                                          //MT03
   dcl-s flag          Char(10)       inz;                                               //SK05
   dcl-s field2        Char(500)      inz;                                               //SK05
   dcl-s String        char(5000)     inz;                                               //SK05
   dcl-s field4        Char(5000)     inz;                                               //SK05
   dcl-s l_inquote     char(1)        inz;                                               //SK05
   dcl-s l_bkfact2     varchar(5000)  inz;                                               //SK05
   dcl-s l_bkfact1     varchar(5000)  inz;                                               //SK05
   dcl-s xl_in_string  varchar(5000);                                                    //SK05
   dcl-s l_bkseq       packed(6:0)    inz;                                               //SK05
   dcl-s l_pos         packed(6:0)    inz;                                               //SK05
   dcl-s l_Spos        packed(6:0)    inz;                                               //SK05
   dcl-s l_Epos        packed(6:0)    inz;                                               //SK05
   dcl-s n_pos         packed(6:0)    inz;                                               //SK05
   dcl-s w_Epos        packed(6:0)    inz;                                               //SK05
   dcl-s w_ctl         packed(2:0)    inz;                                               //SK05
   dcl-s start         packed(6:0)    inz;                                               //SK05
   dcl-s i             packed(4:0)    inz;                                               //SK05
   dcl-s j             packed(4:0)    inz;                                               //SK05
   dcl-s l             packed(6:0)    inz;
   dcl-s k             packed(6:0)    inz;
   dcl-s tr_bracket    packed(6:0)    inz;
   dcl-s c             char(1)        inz;
   dcl-s bif_len       packed(6:0)    inz;
   dcl-s str_len       packed(4:0)    inz;
   dcl-s arr_var       char(600)      inz;
                                                                                         //SK05
   if in_string = *Blanks;
      return;
   endif;
   uwsrcdtl = In_uwsrcdtl;                                                               //0005
   str_len = %len(%trimr(in_string));
   in_string = %xlate(LOWER: UPPER: in_string);                                          //SK05
   l_pos     = %scan('~' :in_string :1);                                                 //SK05
   if l_pos > 0;                                                                         //SS02
      in_string = %replace('' :in_string :l_pos :1);                                     //SK05
                                                                                         //SK05
       //Start with the first '('                                                       //SK05
       l_pos =  %scan('(' :in_string :l_pos);                                            //SK05
   else ;                                                                                //SS02
       l_pos =  %scan('(' :in_string :1);                                                //SS02
   Endif;                                                                                //SS02
       start =  l_pos;                                                                   //SK05
                                                                                         //SK05
   k = 0;
// if l_pos <> 0;
      for l = l_pos+1 to str_len;
          c = %subst(in_string:l:1);
          select;
          when c = '(';
             inquote(in_string :l :l_inquote);
             if l_inquote = 'N';
                tr_bracket +=1;
             endif;
          when c = ')';
             inquote(in_string :l :l_inquote);
             if l_inquote = 'N';
                select;
                when k = 0 and tr_bracket = 0 and l-start > 1;                             //SS02
                   l_bkfact1 = %subst(in_string :start+1 :l-start-1);
                   start=l+1;
                when k = 1 and tr_bracket = 0 and l-start > 0 and start > 0 ;              //SS02
                   l_bkfact2 = %subst(in_string :start :l-start);
                   leave;
                endsl;
                tr_bracket -=1;
             endif;
          when c = ':';
             inquote(in_string :l :l_inquote);
             if l_inquote = 'N';
                if tr_bracket = 0;
                   k+=1;
                   select;
                   when k = 1 and (l-start) > 1;                                         //SS02
                      l_bkfact1 = %subst(in_string :start+1 :l-start-1);
                      start=l+1;
                   when k = 2 and l-start > 0 and start > 0 ;                            //SS02
                      l_bkfact2 = %subst(in_string :start :l-start);
                      leave;
                   endsl;
                endif;
             endif;
          endsl;
      endfor;
       //Check if another BIF present by searching for next '('                         //SK05
 //    l_Spos = %scan('(' :in_string :l_pos+1);                                          //SK05
 //    if l_spos <> 0;                                                                   //SK05
 //       inquote(in_string :l_spos :l_inquote);                                         //SK05
 //       dow l_inquote = 'Y';                                                           //SK05
 //          l_Spos = %scan('(' :in_string :l_spos+1);                                   //SK05
 //          if l_spos <> 0;                                                             //SK05
 //             inquote(in_string :l_spos :l_inquote);                                   //SK05
 //          else;                                                                       //SK05
 //             l_inquote = 'N';                                                         //SK05
 //          endif;                                                                      //SK05
 //       enddo;                                                                         //SK05
 //    endif;                                                                            //SK05
 //                                                                                      //SK05
 //    //Search for ':' to retrieve factors                                             //SK05
 //    l_Epos = %scan(':' :in_string :l_pos+1);                                          //SK05
 //    if l_epos <> 0;                                                                   //SK05
 //       inquote(in_string :l_epos :l_inquote);                                         //SK05
 //       dow l_inquote = 'Y';                                                           //SK05
 //          l_epos = %scan(':' :in_string :l_epos+1);                                   //SK05
 //          if l_epos <> 0;                                                             //SK05
 //             inquote(in_string :l_epos :l_inquote);                                   //SK05
 //          else;                                                                       //SK05
 //             l_inquote = 'N';                                                         //SK05
 //          endif;                                                                      //SK05
 //       enddo;                                                                         //SK05
 //    endif;                                                                            //SK05
 //                                                                                      //SK05
 //    //Retrieving Factor 1                                                            //SK05
 //    dow l_Spos < l_Epos;                                                              //SK05
 //                                                                                      //SK05
 //       if l_Spos <> 0;                                                                //SK05
 //          findcbr(l_Spos :in_string);                                                 //SK05
 //          l_pos = l_Spos;                                                             //SK05
 //                                                                                      //SK05
 //          if l_pos < l_Epos;                                                          //SK05
 //             l_Spos = %scan('(' :in_string :l_pos+1);                                 //SK05
 //             if l_spos <> 0;                                                          //SK05
 //                inquote(in_string :l_spos :l_inquote);                                //SK05
 //                dow l_inquote = 'Y';                                                  //SK05
 //                   l_spos = %scan(':' :in_string :l_spos+1);                          //SK05
 //                   if l_spos <> 0;                                                    //SK05
 //                      inquote(in_string :l_spos :l_inquote);                          //SK05
 //                   else;                                                              //SK05
 //                      l_inquote = 'N';                                                //SK05
 //                   endif;                                                             //SK05
 //                enddo;                                                                //SK05
 //             endif;                                                                   //SK05
 //                                                                                      //SK05
 //          elseif l_pos > l_Epos;                                                      //SK05
 //             l_Epos = %scan(':' :in_string :l_pos+1);                                 //SK05
 //             if l_epos <> 0;                                                          //SK05
 //                inquote(in_string :l_epos :l_inquote);                                //SK05
 //                dow l_inquote = 'Y';                                                  //SK05
 //                   l_epos = %scan(':' :in_string :l_epos+1);                          //SK05
 //                   if l_epos <> 0;                                                    //SK05
 //                      inquote(in_string :l_epos :l_inquote);                          //SK05
 //                   else;                                                              //SK05
 //                      l_inquote = 'N';                                                //SK05
 //                   endif;                                                             //SK05
 //                enddo;                                                                //SK05
 //             endif;                                                                   //SK05
 //                                                                                      //SK05
 //             l_Spos = %scan('(' :in_string :l_pos+1);                                 //SK05
 //             if l_spos <> 0;                                                          //SK05
 //                inquote(in_string :l_spos :l_inquote);                                //SK05
 //                dow l_inquote = 'Y';                                                  //SK05
 //                   l_spos = %scan(':' :in_string :l_spos+1);                          //SK05
 //                   if l_spos <> 0;                                                    //SK05
 //                      inquote(in_string :l_spos :l_inquote);                          //SK05
 //                   else;                                                              //SK05
 //                      l_inquote = 'N';                                                //SK05
 //                   endif;                                                             //SK05
 //                enddo;                                                                //SK05
 //             endif;                                                                   //SK05
 //          endif;                                                                      //SK05
 //       else;                                                                          //SK05
 //          l_Spos = l_Epos + 1;                                                        //SK05
 //       endif;                                                                         //SK05
 //                                                                                      //SK05
 //    enddo;                                                                            //SK05
 //    n_pos = l_Epos;                                                                   //SK05
 //    If l_Epos <> 0 ;                                                                  //SK05
 //       l_bkfact1 = %subst(in_string :start+1 :l_Epos-start-1);                        //SK05
 //    Else ;                                                                            //SK05
 //       l_Epos = start;                                                                //SK05
 //       findcbr(l_Epos :in_string);                                                    //SK05
 //       If l_Epos-start-1 > 0;                                                         //SK05
 //          l_bkfact1 = %subst(in_string :start+1 :l_Epos-start-1);                     //SK05
 //       Endif;                                                                         //SK05
 //    EndIf ;                                                                           //SK05
 //                                                                                      //SK05
 //    //Retrieving Factor 2                                                            //SK05
 //    if n_pos = l_Epos;                                                                //SK05
 //       start      = n_pos;                                                            //SK05
 //       l_Spos     = %scan('(' :in_string :start+1);                                   //SK05
 //       if l_Spos <> 0;                                                                //SK05
 //          inquote(in_string :l_Spos :l_inquote);                                      //SK05
 //          dow l_inquote = 'Y';                                                        //SK05
 //             l_Spos = %scan('(' :in_string :l_Spos+1);                                //SK05
 //             if l_Spos <> 0;                                                          //SK05
 //                inquote(in_string :l_Spos :l_inquote);                                //SK05
 //             else;                                                                    //SK05
 //                l_inquote = 'N';                                                      //SK05
 //             endif;                                                                   //SK05
 //          enddo;                                                                      //SK05
 //       endif;                                                                         //SK05
 //                                                                                      //SK05
 //       l_Epos = %scan(':' :in_string :l_Epos+1);                                      //SK05
 //       if l_epos <> 0;                                                                //SK05
 //          inquote(in_string :l_epos :l_inquote);                                      //SK05
 //          dow l_inquote = 'Y';                                                        //SK05
 //             l_epos = %scan(':' :in_string :l_epos+1);                                //SK05
 //             if l_epos <> 0;                                                          //SK05
 //                inquote(in_string :l_epos :l_inquote);                                //SK05
 //             else;                                                                    //SK05
 //                l_inquote = 'N';                                                      //SK05
 //             endif;                                                                   //SK05
 //          enddo;                                                                      //SK05
 //       endif;                                                                         //SK05
 //                                                                                      //SK05
 //       dow l_Spos < l_Epos;                                                           //SK05
 //          if l_Spos <> 0;                                                             //SK05
 //             findcbr(l_Spos :in_string);                                              //SK05
 //             l_pos = l_Spos;                                                          //SK05
 //             if l_pos < l_Epos;                                                       //SK05
 //                l_Spos = %scan('(' :in_string :l_pos+1);                              //SK05
 //                if l_Spos <> 0;                                                       //SK05
 //                   inquote(in_string :l_Spos :l_inquote);                             //SK05
 //                   dow l_inquote = 'Y';                                               //SK05
 //                      l_Spos = %scan('(' :in_string :l_Spos+1);                       //SK05
 //                      if l_Spos <> 0;                                                 //SK05
 //                         inquote(in_string :l_Spos :l_inquote);                       //SK05
 //                      else;                                                           //SK05
 //                         l_inquote = 'N';                                             //SK05
 //                      endif;                                                          //SK05
 //                   enddo;                                                             //SK05
 //                endif;                                                                //SK05
 //             elseif l_pos > l_Epos;                                                   //SK05
 //                l_Epos = %scan(':' :in_string :l_pos+1);                              //SK05
 //                if l_epos <> 0;                                                       //SK05
 //                   inquote(in_string :l_epos :l_inquote);                             //SK05
 //                   dow l_inquote = 'Y';                                               //SK05
 //                      l_epos = %scan(':' :in_string :l_epos+1);                       //SK05
 //                      if l_epos <> 0;                                                 //SK05
 //                         inquote(in_string :l_epos :l_inquote);                       //SK05
 //                      else;                                                           //SK05
 //                         l_inquote = 'N';                                             //SK05
 //                      endif;                                                          //SK05
 //                   enddo;                                                             //SK05
 //                endif;                                                                //SK05
 //                                                                                      //SK05
 //                l_Spos = %scan('(' :in_string :l_pos+1);                              //SK05
 //                if l_Spos <> 0;                                                       //SK05
 //                   inquote(in_string :l_Spos :l_inquote);                             //SK05
 //                   dow l_inquote = 'Y';                                               //SK05
 //                      l_epos = %scan('(' :in_string :l_Spos+1);                       //SK05
 //                      if l_Spos <> 0;                                                 //SK05
 //                         inquote(in_string :l_Spos :l_inquote);                       //SK05
 //                      else;                                                           //SK05
 //                         l_inquote = 'N';                                             //SK05
 //                      endif;                                                          //SK05
 //                   enddo;                                                             //SK05
 //                endif;                                                                //SK05
 //             endif;                                                                   //SK05
 //          else;                                                                       //SK05
 //             l_Spos = l_Epos + 1;                                                     //SK05
 //          endif;                                                                      //SK05
 //       enddo;                                                                         //SK05
 //                                                                                      //SK05
 //       if l_Epos <> 0;                                                                //SK05
 //          l_bkfact2 = %subst(in_string :start+1 :l_Epos-start-1);                     //SK05
 //       else;                                                                          //SK05
 //          l_Epos = ProcessScanr(')':in_String:start+1);                               //SK05
 //          if l_epos <> 0;                                                             //SK05
 //             inquote(in_string :l_epos :l_inquote);                                   //SK05
 //             dow l_inquote = 'Y';                                                     //SK05
 //                l_epos = %scan(')' :in_string :l_epos+1);                             //SK05
 //                if l_epos <> 0;                                                       //SK05
 //                   inquote(in_string :l_epos :l_inquote);                             //SK05
 //                else;                                                                 //SK05
 //                   l_inquote = 'N';                                                   //SK05
 //                endif;                                                                //SK05
 //             enddo;                                                                   //SK05
 //          endif;                                                                      //SK05
 //                                                                                      //SK05
 //          l_bkfact2 = %subst(in_string :start+1 :l_Epos-start-1);                     //SK05
 //       endif;                                                                         //SK05
 //    Endif;                                                                            //SK05
                                                                                         //SK05
       l_bkfact1 = RMVbrackets(l_bkfact1);                                               //SK05
       l_bkfact2 = RMVbrackets(l_bkfact2);                                               //SK05
                                                                                         //SK05
       //If both factors are blank leave                                                //SK05
       If l_bkfact1 = *Blanks and l_bkfact2 = *Blanks;                                   //SK05
         Return;                                                                        //SK05
       Endif;                                                                            //SK05
       //Split Factor1 (based on operators) into an array when it has 2 or more operands//SK05
       xl_in_string = l_bkfact1 ;                                                        //SK05
       split_component_5(xl_in_string :arr :xl_ArrayOpt :i);                             //SK05
                                                                                         //SK05
       lk_reseq = in_seq;                                                                //SK05
       //Loop through every item in the splitted array                                  //SK05
       for j = 1 to i ;                                                                  //SK05
           if j <= %elem(arr) and arr(j) = *Blanks;
              arr_var = %trim(arr(j));
              if %scan('(' : arr_var ) = 1;                                              //SK05
              // Remove brackets if it is in the first pos                              //SK05
                 arr(j) = RMVbrackets(arr(j));                                           //SK05
              endif;                                                                     //SK05
              l_Epos = %scan('%'  :arr_var);                                             //SK05
              l_Spos = %scan('''' :arr_var);                                             //SK05
              if l_Spos = 0;                                                             //SK05
                l_Spos = %scan('"' :arr_var);                                            //SK05
              endif;                                                                     //SK05
                                                                                         //SK05
              lk_recomp  = xl_ArrayOpt(J);                                               //SK05
                                                                                         //SK05
              clear lk_refact2;                                                          //SK05
              select;                                                                    //SK05
              when l_Spos <> 0 and l_Spos < l_Epos;                                      //SK05
              //When it is a String Constant                                            //SK05
                 lk_refact1 = 'CONST(' + %trim(arr(j)) + ')';                            //SK05
                                                                                         //SK05
                 if i = 1;                                                               //SK05
                 //When array has only 1 item - means it doesnt have anyother operand   //SK05
                    leave;                                                               //SK05
                 endif;                                                                  //SK05
                 // insert array element (factor) into IAVARRELLOG                      //SK05
                 lk_reseq += 1;                                                          //SK05
                                                                                         //SK05
                 iavarrellog(in_srclib    :                                              //SK05
                             in_srcspf    :                                              //SK05
                             in_srcmbr    :                                              //SK05
                             in_ifsloc    :                                              //0005
                             lk_reseq     :                                              //SK05
                             in_rrn       :                                              //SK05
                             lk_reroutine :                                              //SK05
                             lk_rereltyp  :                                              //SK05
                             lk_rerelnum  :                                              //SK05
                             lk_reopc     :                                              //SK05
                             lk_reresult  :                                              //SK05
                             lk_rebif     :                                              //SK05
                             lk_refact1   :                                              //SK05
                             lk_recomp    :                                              //SK05
                             lk_refact2   :                                              //SK05
                             lk_recontin  :                                              //SK05
                             lk_reresind  :                                              //SK05
                             lk_recat1    :                                              //SK05
                             lk_recat2    :                                              //SK05
                             lk_recat3    :                                              //SK05
                             lk_recat4    :                                              //SK05
                             lk_recat5    :                                              //SK05
                             lk_recat6    :                                              //SK05
                             lk_reutil    :                                              //SK05
                             lk_renum1    :                                              //SK05
                             lk_renum2    :                                              //SK05
                             lk_renum3    :                                              //SK05
                             lk_renum4    :                                              //SK05
                             lk_renum5    :                                              //SK05
                             lk_renum6    :                                              //SK05
                             lk_renum7    :                                              //SK05
                             lk_renum8    :                                              //SK05
                             lk_renum9    :                                              //SK05
                             lk_reexc     :                                              //SK05
                             lk_reinc );                                                 //SK05
                                                                                         //SK05
              when l_Epos <> 0 and (l_Spos > l_Epos or l_Spos = 0);                      //SK05
                 //When Its a BIF - Call BIF Parser                                     //SK05
                 l_pos      = %scan('(' :arr(j) :l_Epos);                                //SK05
               //If l_pos <> 0;                                                          //SK05
                 If (l_pos-l_Epos) > 0;                                                  //SK05
                    lk_rebif   = %subst(arr(j) :l_Epos :l_pos-l_Epos);                   //SK05
                 Else;                                                                   //SK05
                    lk_rebif   = arr(j);                                                 //SK05
                 EndIf;                                                                  //SK05
                 string     = '~' + %subst(%trim(arr(j)) :l_Epos);                       //SK05
                                                                                         //SK05
               //callbif(in_srclib  :                                                    //0005
               //        in_srcspf  :                                                    //0005
               //        in_srcmbr  :                                                    //0005
                 callbif(in_uWSrcDtl:                                                    //0005
                         In_rrn     :                                                    //SK05
                         lk_reseq   :                                                    //SK05
                         l_bkseq    :                                                    //SK05
                         lk_REOPC   :                                                    //SK05
                         lk_refact1 :                                                    //SK05
                         lk_refact2 :                                                    //SK05
                         in_type    :                                                    //SK05
                         lk_RECOMP  :                                                    //SK05
                         lk_reBIF   :                                                    //SK05
                         flag       :                                                    //SK05
                         field2     :                                                    //SK05
                         string     :                                                    //SK05
                         field4 );                                                       //SK05
                                                                                         //SK05
              other;                                                                     //SK05
                 if l_Spos <> 0;                                                         //SK05
                 //String Constant                                                      //SK05
                    lk_refact1 = 'CONST(' + %trim(arr(j)) + ')';                         //SK05
                 elseif %check('.0123456789' :%trim(arr(j))) <> 0;                       //SK05
                 //Variable name                                                        //SK05
                    lk_refact1 = %trim(arr(j));                                          //SK05
                 else;                                                                   //SK05
                 //Constant value                                                       //SK05
                    lk_refact1 = 'CONST(' + %trim(arr(j)) + ')';                         //SK05
                 endif;                                                                  //SK05
                                                                                         //SK05
                 if i = 1;                                                               //SK05
                    leave;                                                               //SK05
                 endif;                                                                  //SK05
                                                                                         //SK05
                 If %trim(lk_refact1) = 'CONST()';                                       //SK05
                 Else;                                                                   //SK05
                    lk_reseq += 1;                                                       //SK05
                    clear lk_recontin;                                                   //SK05
                    If j < i ;                                                           //SK05
                      lk_recontin = 'AND';                                               //SK05
                    Endif;                                                               //SK05
                    iavarrellog(in_srclib    :                                           //SK05
                                in_srcspf    :                                           //SK05
                                in_srcmbr    :                                           //SK05
                                in_ifsloc    :                                           //0005
                                lk_reseq     :                                           //SK05
                                in_rrn       :                                           //SK05
                                lk_reroutine :                                           //SK05
                                lk_rereltyp  :                                           //SK05
                                lk_rerelnum  :                                           //SK05
                                lk_reopc     :                                           //SK05
                                lk_reresult  :                                           //SK05
                                lk_rebif     :                                           //SK05
                                lk_refact1   :                                           //SK05
                                lk_recomp    :                                           //SK05
                                lk_refact2   :                                           //SK05
                                lk_recontin  :                                           //SK05
                                lk_reresind  :                                           //SK05
                                lk_recat1    :                                           //SK05
                                lk_recat2    :                                           //SK05
                                lk_recat3    :                                           //SK05
                                lk_recat4    :                                           //SK05
                                lk_recat5    :                                           //SK05
                                lk_recat6    :                                           //SK05
                                lk_reutil    :                                           //SK05
                                lk_renum1    :                                           //SK05
                                lk_renum2    :                                           //SK05
                                lk_renum3    :                                           //SK05
                                lk_renum4    :                                           //SK05
                                lk_renum5    :                                           //SK05
                                lk_renum6    :                                           //SK05
                                lk_renum7    :                                           //SK05
                                lk_renum8    :                                           //SK05
                                lk_renum9    :                                           //SK05
                                lk_reexc     :                                           //SK05
                                lk_reinc );                                              //SK05
                 Endif;                                                                  //SK05
                                                                                         //SK05
              endsl;                                                                     //SK05
              clear lk_refact1;                                                          //SK05
          endif;                                                                         //SK05
       endfor;                                                                           //SK05
                                                                                         //SK05
      //Factor 2 processing as same as factor 1
      if l_bkfact2 <> *Blanks;                                                           //SK05

         split_component_5(l_bkfact2 :arr : xl_ArrayOpt :i);                             //SK05
      Else;                                                                              //SK05
         return;                                                                         //SK05
      Endif;                                                                             //SK05
                                                                                         //SK05
      for j = 1 to i;                                                                    //SK05
         if j <= %elem(arr) and arr(j) <> *Blanks;
            arr_var = %trim(arr(j));
            l_Epos    = %scan('%'  : arr_var);                                           //SK05
            l_Spos    = %scan('''' : arr_var);                                           //SK05
            if l_Spos = 0;                                                               //SK05
               l_Spos = %scan('"' : arr_var);                                            //SK05
            endif;                                                                       //SK05
                                                                                         //SK05
            lk_recomp = xl_ArrayOpt(j);                                                  //SK05
                                                                                         //SK05
            select;                                                                      //SK05
            when l_Spos <> 0 and l_Spos < l_Epos;                                        //SK05
               lk_refact2 = 'CONST(' + %trim(arr(j)) + ')';                              //SK05
                                                                                         //SK05
               if i = 1;                                                                 //SK05
                  leave;                                                                 //SK05
               endif;                                                                    //SK05
                                                                                         //SK05
               lk_reseq += 1;                                                            //SK05
               clear lk_recontin;                                                        //SK05
               If j < i;                                                                 //SK05
                 lk_recontin = 'AND';                                                    //SK05
               Endif;                                                                    //SK05
               clear lk_rebif;                                                           //SK05
                                                                                         //SK05
               iavarrellog(in_srclib    :                                                //SK05
                           in_srcspf    :                                                //SK05
                           in_srcmbr    :                                                //SK05
                           in_ifsloc    :                                                //0005
                           lk_reseq     :                                                //SK05
                           in_rrn       :                                                //SK05
                           lk_reroutine :                                                //SK05
                           lk_rereltyp  :                                                //SK05
                           lk_rerelnum  :                                                //SK05
                           lk_reopc     :                                                //SK05
                           lk_reresult  :                                                //SK05
                           lk_rebif     :                                                //SK05
                           lk_refact1   :                                                //SK05
                           lk_recomp    :                                                //SK05
                           lk_refact2   :                                                //SK05
                           lk_recontin  :                                                //SK05
                           lk_reresind  :                                                //SK05
                           lk_recat1    :                                                //SK05
                           lk_recat2    :                                                //SK05
                           lk_recat3    :                                                //SK05
                           lk_recat4    :                                                //SK05
                           lk_recat5    :                                                //SK05
                           lk_recat6    :                                                //SK05
                           lk_reutil    :                                                //SK05
                           lk_renum1    :                                                //SK05
                           lk_renum2    :                                                //SK05
                           lk_renum3    :                                                //SK05
                           lk_renum4    :                                                //SK05
                           lk_renum5    :                                                //SK05
                           lk_renum6    :                                                //SK05
                           lk_renum7    :                                                //SK05
                           lk_renum8    :                                                //SK05
                           lk_renum9    :                                                //SK05
                           lk_reexc     :                                                //SK05
                           lk_reinc );                                                   //SK05
                                                                                         //SK05
            when l_Epos <> 0 and (l_Spos > l_Epos or l_Spos = 0);                        //SK05
               //when string has another BIF
               l_pos      = %scan('(' :arr(j) :l_Epos);                                  //SK05
             //If l_pos <> 0;                                                            //SK05
               If (l_pos-l_Epos) > 0;                                                    //SK05
                  lk_rebif = %subst(arr(j) :l_Epos :l_pos-l_Epos);                       //SK05
               Else;                                                                     //SK05
                  lk_rebif = arr(j);                                                     //SK05
               EndIf;                                                                    //SK05
               string = '~' + %subst(%trim(arr(j)) :l_Epos);                             //SK05
                                                                                         //SK05
             //callbif(in_srclib  :                                                      //0005
             //        in_srcspf  :                                                      //0005
             //        in_srcmbr  :                                                      //0005
               callbif(in_uWSrcDtl:                                                      //0005
                       In_rrn     :                                                      //SK05
                       lk_reseq   :                                                      //SK05
                       l_bkseq    :                                                      //SK05
                       lk_REOPC   :                                                      //SK05
                       lk_refact1 :                                                      //SK05
                       lk_refact2 :                                                      //SK05
                       in_type    :                                                      //SK05
                       lk_RECOMP  :                                                      //SK05
                       lk_reBIF   :                                                      //SK05
                       flag       :                                                      //SK05
                       field2     :                                                      //SK05
                       string     :                                                      //SK05
                       field4 );                                                         //SK05
                                                                                         //SK05
            other;                                                                       //SK05
               select;                                                                   //SK05
               when l_Spos <> 0;                                                         //SK05
                  clear lk_rebif;                                                        //SK05
                  lk_refact2 = 'CONST(' + %trim(arr(j)) + ')';                           //SK05
               when %check('.0123456789' :%Trim(arr(j))) <> 0;                           //SK05
                  lk_refact2 = %trim(arr(j));                                            //SK05
               other ;                                                                   //SK05
                  clear lk_rebif;                                                        //SK05
                  lk_refact2 = 'CONST(' + %trim(arr(j)) + ')';                           //SK05
               endsl;                                                                    //SK05
                                                                                         //SK05
               if i = 1;                                                                 //SK05
                  leave;                                                                 //SK05
               endif;                                                                    //SK05
                                                                                         //SK05
               If %trim(lk_refact2) = 'CONST()';                                         //SK05
               Else;                                                                     //SK05
                  lk_reseq += 1;                                                         //SK05
                  lk_recontin = 'AND';                                                   //SK05
                  iavarrellog(in_srclib    :                                             //SK05
                              in_srcspf    :                                             //SK05
                              in_srcmbr    :                                             //SK05
                              in_ifsloc    :                                             //0005
                              lk_reseq     :                                             //SK05
                              in_rrn       :                                             //SK05
                              lk_reroutine :                                             //SK05
                              lk_rereltyp  :                                             //SK05
                              lk_rerelnum  :                                             //SK05
                              lk_reopc     :                                             //SK05
                              lk_reresult  :                                             //SK05
                              lk_rebif     :                                             //SK05
                              lk_refact1   :                                             //SK05
                              lk_recomp    :                                             //SK05
                              lk_refact2   :                                             //SK05
                              lk_recontin  :                                             //SK05
                              lk_reresind  :                                             //SK05
                              lk_recat1    :                                             //SK05
                              lk_recat2    :                                             //SK05
                              lk_recat3    :                                             //SK05
                              lk_recat4    :                                             //SK05
                              lk_recat5    :                                             //SK05
                              lk_recat6    :                                             //SK05
                              lk_reutil    :                                             //SK05
                              lk_renum1    :                                             //SK05
                              lk_renum2    :                                             //SK05
                              lk_renum3    :                                             //SK05
                              lk_renum4    :                                             //SK05
                              lk_renum5    :                                             //SK05
                              lk_renum6    :                                             //SK05
                              lk_renum7    :                                             //SK05
                              lk_renum8    :                                             //SK05
                              lk_renum9    :                                             //SK05
                              lk_reexc     :                                             //SK05
                              lk_reinc );                                                //SK05
               Endif;                                                                    //SK05
            endsl;                                                                       //SK05
            Clear lk_refact2;                                                            //SK05
         endif;                                                                          //SK05
      endfor;                                                                            //SK05
       in_seq = lk_reseq;                                                                //SK05
                                                                                         //SK05
                                                                                         //SK05
   Return;                                                                               //SK05
                                                                                         //SK05
end-proc;                                                                                //SK05

//--------------------------------------------------------------------------- //
//IaPsrEditc :
//--------------------------------------------------------------------------- //
dcl-proc IAPSREDITC export;
   dcl-pi IAPSREDITC;
      in_string  char(5000);
      in_opcode  char(10);
      in_type    char(10);
  //  in_srclib  char(10);                                                               //0005
  //  in_srcspf  char(10);                                                               //0005
  //  in_srcmbr  char(10);                                                               //0005
      in_uWSrcDtl likeds(uWSrcDtl);                                                      //0005
      in_RRN     packed(6:0);
      lk_refact1 char(80);
      lk_refact2 char(80);
      in_Seq     packed(6:0);
   end-pi;

   dcl-s arr           char(600)     dim(600) inz;                                       //MT03
   dcl-s xl_ArrayOpt   char(1)       dim(600) inz;                                       //MT03
   dcl-s flag          Char(10)      inz;
   dcl-s field2        Char(500)     inz;
   dcl-s String        char(5000)    inz;
   dcl-s field4        Char(5000)    inz;
   dcl-s l_inquote     char(1)       inz;
   dcl-s l_bkfact2     varchar(5000) inz;
   dcl-s l_bkfact1     varchar(5000) inz;
   dcl-s xl_in_string  varchar(5000) inz;
   dcl-s l_pos         packed(6:0)   inz;
   dcl-s l_Spos        packed(6:0)   inz;
   dcl-s l_Epos        packed(6:0)   inz;
   dcl-s start         packed(6:0)   inz;
   dcl-s i             packed(4:0)   inz;
   dcl-s j             packed(4:0)   inz;
   dcl-s l_bkseq       packed(6:0)   inz;
   dcl-s l             packed(6:0)   inz;
   dcl-s tr_bracket    packed(6:0)   inz;
   dcl-s c             char(1)       inz;
   dcl-s str_len       packed(4:0)   inz;
   dcl-s arr_var       char(600)     inz;

   if in_string = *Blanks;
      return;
   endif;
   uwsrcdtl = In_uwsrcdtl;                                                                 //0005
   str_len = %len(%trimr(in_string));
   in_string = %xlate(LOWER: UPPER: in_string);
   l_pos     = %scan('~' :in_string :1);
   if l_pos > 0;                                                                           //SS02
      in_string = %replace('' :in_string :l_pos :1);

      l_pos = %scan('%EDITC'   :in_string :l_pos);
   Else;                                                                                   //SS02
     l_pos = %scan('%EDITC'   :in_string :1);                                              //SS02
   Endif;                                                                                  //SS02
   if l_pos <> 0;
      for l = l_pos+6 to str_len;
          c = %subst(in_string:l:1);
          select;
          when c = '(';
             inquote(in_string :l :l_inquote);
             if l_inquote = 'N';
                if start = 0;
                   start = l;
                else;
                   tr_bracket +=1;
                endif;
             endif;
          when c = ')';
             inquote(in_string :l :l_inquote);
             if l_inquote = 'N';
                if tr_bracket =0 and l-start > 1;                                          //SS02
                   l_bkfact1 = %subst(in_string :start+1 :l-start-1);
                   leave;
                endif;
                tr_bracket -=1;
             endif;
          when c = ':';
             inquote(in_string :l :l_inquote);
             if l_inquote = 'N';
                if tr_bracket = 0 and l-start > 1;                                         //SS02
                   l_bkfact1 = %subst(in_string :start+1 :l-start-1);
                   leave;
                endif;
             endif;
          endsl;
      endfor;
// if %scan('%EDITC'   :in_string :l_pos)  <> 0;
//    l_pos =  %scan('(' :in_string :l_pos);
//    start =  l_pos;
//
//    l_Spos = %scan('(' :in_string :l_pos+1);
//    if l_spos <> 0;
//       inquote(in_string :l_spos :l_inquote);
//       dow l_inquote = 'Y';
//          l_Spos = %scan('(' :in_string :l_spos+1);
//          if l_spos <> 0;
//             inquote(in_string :l_spos :l_inquote);
//          else;
//             l_inquote = 'N';
//          endif;
//       enddo;
//    endif;

//    l_Epos = %scan(':' :in_string :l_pos+1);
//    if l_epos <> 0;
//       inquote(in_string :l_epos :l_inquote);
//       dow l_inquote = 'Y';
//          l_epos = %scan(':' :in_string :l_epos+1);
//          if l_epos <> 0;
//             inquote(in_string :l_epos :l_inquote);
//          else;
//             l_inquote = 'N';
//          endif;
//       enddo;
//    endif;
//
//    dow l_Spos < l_Epos;
//
//       if l_Spos <> 0;
//          findcbr(l_Spos :in_string);
//          l_pos = l_Spos;
//
//          if l_pos < l_Epos;
//             l_Spos = %scan('(' :in_string :l_pos+1);
//             if l_spos <> 0;
//                inquote(in_string :l_spos :l_inquote);
//                dow l_inquote = 'Y';
//                   l_spos = %scan(':' :in_string :l_spos+1);
//                   if l_spos <> 0;
//                      inquote(in_string :l_spos :l_inquote);
//                   else;
//                      l_inquote = 'N';
//                   endif;
//                enddo;
//             endif;
//
//          elseif l_pos > l_Epos;
//             l_Epos = %scan(':' :in_string :l_pos+1);
//             if l_epos <> 0;
//                inquote(in_string :l_epos :l_inquote);
//                dow l_inquote = 'Y';
//                   l_epos = %scan(':' :in_string :l_epos+1);
//                   if l_epos <> 0;
//                      inquote(in_string :l_epos :l_inquote);
//                   else;
//                      l_inquote = 'N';
//                   endif;
//                enddo;
//             endif;
//
//             l_Spos = %scan('(' :in_string :l_pos+1);
//             if l_spos <> 0;
//                inquote(in_string :l_spos :l_inquote);
//                dow l_inquote = 'Y';
//                   l_spos = %scan(':' :in_string :l_spos+1);
//                   if l_spos <> 0;
//                      inquote(in_string :l_spos :l_inquote);
//                   else;
//                      l_inquote = 'N';
//                   endif;
//                enddo;
//             endif;
//          endif;
//       else;
//         l_Spos = l_Epos + 1;
//       endif;
//
//   enddo;

//   l_bkfact1 = %subst(in_string :start+1 :l_Epos-start-1);

     l_bkfact1 = RMVbrackets(l_bkfact1);

     xl_in_string = l_bkfact1;
     split_component_5(xl_in_string :arr :xl_ArrayOpt :i);
     i = i + 1;

     lk_reseq = in_seq;
     for j = 1 to i-1;
        if j <= %elem(arr) and arr(j) <> *Blanks;
           arr_var = %trim(arr(j));
           if %scan('(' :arr_var) = 1;
              arr(j) = RMVbrackets(arr(j));
           endif;
           l_Epos = %scan('%'  :arr_var);
           l_Spos = %scan('''' :arr_var);
           if l_Spos = 0;
              l_Spos = %scan('"' :arr_var);
           endif;

           lk_recomp = xl_ArrayOpt(j);

           clear lk_refact2;
           select;
           when l_Spos <> 0 and l_Spos < l_Epos;
              lk_refact1 = 'CONST(' + %trim(arr(j)) + ')';

              if i = 2;
                 leave;
              endif;

              lk_reseq += 1;
              lk_recontin = 'AND';

              iavarrellog(in_srclib    :
                          in_srcspf    :
                          in_srcmbr    :
                          in_ifsloc    :                                                 //0005
                          lk_reseq     :
                          in_rrn       :
                          lk_reroutine :
                          lk_rereltyp  :
                          lk_rerelnum  :
                          lk_reopc     :
                          lk_reresult  :
                          lk_rebif     :
                          lk_refact1   :
                          lk_recomp    :
                          lk_refact2   :
                          lk_recontin  :
                          lk_reresind  :
                          lk_recat1    :
                          lk_recat2    :
                          lk_recat3    :
                          lk_recat4    :
                          lk_recat5    :
                          lk_recat6    :
                          lk_reutil    :
                          lk_renum1    :
                          lk_renum2    :
                          lk_renum3    :
                          lk_renum4    :
                          lk_renum5    :
                          lk_renum6    :
                          lk_renum7    :
                          lk_renum8    :
                          lk_renum9    :
                          lk_reexc     :
                          lk_reinc );

           when l_Epos <> 0 and (l_Spos > l_Epos or l_Spos = 0);
              l_pos      = %scan('(' :arr(j) :l_Epos);
            //If l_pos <> 0;
              If (l_pos-l_Epos) > 0;
                 lk_rebif   = %subst(arr(j) :l_Epos :l_pos-l_Epos);
              Else;
                 lk_rebif   = arr(j);
              Endif;
              string     = '~' + %subst(%trim(arr(j)) :l_Epos);

            //callbif(in_srclib  :                                                       //0005
            //        in_srcspf  :                                                       //0005
            //        in_srcmbr  :                                                       //0005
              callbif(in_uWSrcDtl:                                                       //0005
                      In_rrn     :
                      lk_reseq   :
                      l_bkseq    :
                      lk_REOPC   :
                      lk_refact1 :
                      lk_refact2 :
                      in_type    :
                      lk_RECOMP  :
                      lk_reBIF   :
                      flag       :
                      field2     :
                      string     :
                      field4 );

           other;
              if l_Spos <> 0;
                 lk_refact1 = 'CONST(' + %trim(arr(j)) + ')';
              elseif %check('.-0123456789' :%trim(arr(j))) <> 0;
                 lk_refact1 = %trim(arr(j));
              else;
                 lk_refact1 = 'CONST(' + %trim(arr(j)) + ')';
              endif;

              if i = 2;
                 leave;
              endif;

              If %trim(lk_refact1) = 'CONST()' ;
              Else ;
                 lk_reseq += 1;
                 lk_recontin = 'AND';
                 iavarrellog(in_srclib    :
                             in_srcspf    :
                             in_srcmbr    :
                             in_ifsloc    :                                              //0005
                             lk_reseq     :
                             in_rrn       :
                             lk_reroutine :
                             lk_rereltyp  :
                             lk_rerelnum  :
                             lk_reopc     :
                             lk_reresult  :
                             lk_rebif     :
                             lk_refact1   :
                             lk_recomp    :
                             lk_refact2   :
                             lk_recontin  :
                             lk_reresind  :
                             lk_recat1    :
                             lk_recat2    :
                             lk_recat3    :
                             lk_recat4    :
                             lk_recat5    :
                             lk_recat6    :
                             lk_reutil    :
                             lk_renum1    :
                             lk_renum2    :
                             lk_renum3    :
                             lk_renum4    :
                             lk_renum5    :
                             lk_renum6    :
                             lk_renum7    :
                             lk_renum8    :
                             lk_renum9    :
                             lk_reexc     :
                             lk_reinc );
              EndIf ;

           endsl;
           Clear lk_refact1;
        endif;
      endfor;

      in_seq = lk_reseq;

   endif;

   Return;

end-proc;

//------------------------------------------------------------------------------ //
//IaPsrEditw :
//------------------------------------------------------------------------------ //
dcl-proc IAPSREDITW export;
   dcl-pi IAPSREDITW;
      in_string  char(5000);
      in_opcode  char(10);
      in_type    char(10);
  //  in_srclib  char(10);                                                               //0005
  //  in_srcspf  char(10);                                                               //0005
  //  in_srcmbr  char(10);                                                               //0005
      in_uWSrcDtl likeds(uWSrcDtl);                                                      //0005
      in_RRN     packed(6:0);
      lk_refact1 char(80);
      lk_refact2 char(80);
      in_Seq     packed(6:0);
   end-pi;

   dcl-s arr           char(600)     dim(600) inz;                                       //MT03
   dcl-s xl_ArrayOpt   char(1)       dim(600) inz;                                       //MT03
   dcl-s flag          Char(10)      inz;
   dcl-s field2        Char(500)     inz;
   dcl-s String        char(5000)    inz;
   dcl-s field4        Char(5000)    inz;
   dcl-s l_inquote     char(1)       inz;
   dcl-s l_bkfact2     varchar(5000) inz;
   dcl-s l_bkfact1     varchar(5000) inz;
   dcl-s xl_in_string  varchar(5000) inz;
   dcl-s l_pos         packed(6:0)   inz;
   dcl-s l_Spos        packed(6:0)   inz;
   dcl-s l_Epos        packed(6:0)   inz;
   dcl-s start         packed(6:0)   inz;
   dcl-s i             packed(4:0)   inz;
   dcl-s j             packed(4:0)   inz;
   dcl-s l_bkseq       packed(6:0)   inz;
   dcl-s l             packed(6:0)   inz;
   dcl-s tr_bracket    packed(6:0)   inz;
   dcl-s c             char(1)       inz;
   dcl-s arr_var       char(600)     inz;
   dcl-s str_len       packed(4:0)   inz;

   if in_string = *Blanks;
      return;
   endif;
   uwsrcdtl = In_uwsrcdtl;                                                                //0005
   str_len = %len(%trimr(in_string));
   in_string = %xlate(LOWER: UPPER: in_string);
   l_pos     = %scan('~' :in_string :1);
   if l_pos > 0;                                                                           //SS02
      in_string = %replace('' :in_string :l_pos :1);

      l_pos = %scan('%EDITW'   :in_string :l_pos);
   Else;                                                                                   //SS02
      l_pos = %scan('%EDITW'   :in_string :1);                                             //SS02
   Endif;                                                                                  //SS02
   if l_pos <> 0;
      for l = l_pos+6 to str_len;
          c = %subst(in_string:l:1);
          select;
          when c = '(';
             inquote(in_string :l :l_inquote);
             if l_inquote = 'N';
                if start = 0;
                   start = l;
                else;
                   tr_bracket +=1;
                endif;
             endif;
          when c = ')';
             inquote(in_string :l :l_inquote);
             if l_inquote = 'N';
                if tr_bracket =0 and l-start > 1;                                          //SS02
                   l_bkfact1 = %subst(in_string :start+1 :l-start-1);
                   leave;
                endif;
                tr_bracket -=1;
             endif;
          when c = ':';
             inquote(in_string :l :l_inquote);
             if l_inquote = 'N';
                if tr_bracket = 0 and l-start > 1;                                         //SS02
                   l_bkfact1 = %subst(in_string :start+1 :l-start-1);
                   leave;
                endif;
             endif;
          endsl;
      endfor;
// if %scan('%EDITW'   :in_string :l_pos)  <> 0;
//    l_pos =  %scan('(' :in_string :l_pos);
//    start =  l_pos;

//    l_Spos = %scan('(' :in_string :l_pos+1);
//    if l_spos <> 0;
//       inquote(in_string :l_spos :l_inquote);
//       dow l_inquote = 'Y';
//          l_Spos = %scan('(' :in_string :l_spos+1);
//          if l_spos <> 0;
//             inquote(in_string :l_spos :l_inquote);
//          else;
//             l_inquote = 'N';
//          endif;
//       enddo;
//    endif;

//    l_Epos = %scan(':' :in_string :l_pos+1);
//    if l_epos <> 0;
//       inquote(in_string :l_epos :l_inquote);
//       dow l_inquote = 'Y';
//          l_epos = %scan(':' :in_string :l_epos+1);
//          if l_epos <> 0;
//             inquote(in_string :l_epos :l_inquote);
//          else;
//             l_inquote = 'N';
//          endif;
//       enddo;
//    endif;

//    dow l_Spos < l_Epos;
//
//       if l_Spos <> 0;
//          findcbr(l_Spos :in_string);
//          l_pos = l_Spos;
//
//          if l_pos < l_Epos;
//             l_Spos = %scan('(' :in_string :l_pos+1);
//             if l_spos <> 0;
//                inquote(in_string :l_spos :l_inquote);
//                dow l_inquote = 'Y';
//                   l_spos = %scan(':' :in_string :l_spos+1);
//                   if l_spos <> 0;
//                      inquote(in_string :l_spos :l_inquote);
//                   else;
//                      l_inquote = 'N';
//                   endif;
//                enddo;
//             endif;
//
//          elseif l_pos > l_Epos;
//             l_Epos = %scan(':' :in_string :l_pos+1);
//             if l_epos <> 0;
//                inquote(in_string :l_epos :l_inquote);
//                dow l_inquote = 'Y';
//                   l_epos = %scan(':' :in_string :l_epos+1);
//                   if l_epos <> 0;
//                      inquote(in_string :l_epos :l_inquote);
//                   else;
//                      l_inquote = 'N';
//                   endif;
//                enddo;
//             endif;
//
//             l_Spos = %scan('(' :in_string :l_pos+1);
//             if l_spos <> 0;
//                inquote(in_string :l_spos :l_inquote);
//                dow l_inquote = 'Y';
//                   l_spos = %scan(':' :in_string :l_spos+1);
//                   if l_spos <> 0;
//                      inquote(in_string :l_spos :l_inquote);
//                   else;
//                      l_inquote = 'N';
//                   endif;
//                enddo;
//             endif;
//          endif;
//       else;
//          l_Spos = l_Epos + 1;
//       endif;
//
//    enddo;
//
//    l_bkfact1 = %subst(in_string :start+1 :l_Epos-start-1);

      l_bkfact1 = RMVbrackets(l_bkfact1);

      xl_in_string = l_bkfact1;
      split_component_5(xl_in_string :arr :xl_ArrayOpt :i);
      i = i + 1;

      lk_reseq = in_seq;
      for j = 1 to i-1;
         if j <= %elem(arr) and arr(j) <> *Blanks;
            arr_var = %trim(arr(j));
            if %scan('(' :arr_var) = 1;
               arr(j) = RMVbrackets(arr(j));
            endif;
            l_Epos = %scan('%'  : arr_var);
            l_Spos = %scan('''' : arr_var);
            if l_Spos = 0;
               l_Spos = %scan('"' : arr_var);
            endif;

            lk_recomp = xl_ArrayOpt(j);

            clear lk_refact2;
            select;
            when l_Spos <> 0 and l_Spos < l_Epos;
               lk_refact1 = 'CONST(' + %trim(arr(j)) + ')';

               if i = 2;
                  leave;
               endif;

               lk_reseq += 1;
               lk_recontin = 'AND';

               iavarrellog(in_srclib    :
                           in_srcspf    :
                           in_srcmbr    :
                           in_ifsloc    :                                                //0005
                           lk_reseq     :
                           in_rrn       :
                           lk_reroutine :
                           lk_rereltyp  :
                           lk_rerelnum  :
                           lk_reopc     :
                           lk_reresult  :
                           lk_rebif     :
                           lk_refact1   :
                           lk_recomp    :
                           lk_refact2   :
                           lk_recontin  :
                           lk_reresind  :
                           lk_recat1    :
                           lk_recat2    :
                           lk_recat3    :
                           lk_recat4    :
                           lk_recat5    :
                           lk_recat6    :
                           lk_reutil    :
                           lk_renum1    :
                           lk_renum2    :
                           lk_renum3    :
                           lk_renum4    :
                           lk_renum5    :
                           lk_renum6    :
                           lk_renum7    :
                           lk_renum8    :
                           lk_renum9    :
                           lk_reexc     :
                           lk_reinc );

            when l_Epos <> 0 and (l_Spos > l_Epos or l_Spos = 0);
               l_pos      = %scan('(' :arr(j) :l_Epos);
             //If l_pos <> 0;
               If (l_pos-l_Epos) > 0;
                  lk_rebif   = %subst(arr(j) :l_Epos :l_pos-l_Epos);
               Else;
                  lk_rebif   = arr(j);
               Endif;
               string     = '~' + %subst(%trim(arr(j)) :l_Epos);

             //callbif(in_srclib  :                                                      //0005
             //        in_srcspf  :                                                      //0005
             //        in_srcmbr  :                                                      //0005
               callbif(in_uWSrcDtl:                                                      //0005
                       In_rrn     :
                       lk_reseq   :
                       l_bkseq    :
                       lk_REOPC   :
                       lk_refact1 :
                       lk_refact2 :
                       in_type    :
                       lk_RECOMP  :
                       lk_reBIF   :
                       flag       :
                       field2     :
                       string     :
                       field4 );

            other;
               if l_Spos <> 0;
                  lk_refact1 = 'CONST(' + %trim(arr(j)) + ')';
               elseif %check('.0123456789' :%trim(arr(j))) <> 0;
                  lk_refact1 = %trim(arr(j));
               else;
                  lk_refact1 = 'CONST(' + %trim(arr(j)) + ')';
               endif;

               if i = 2;
                  leave;
               endif;

               If %trim(lk_refact1) = 'CONST()' ;
               Else ;
                  lk_reseq += 1;
                  lk_recontin = 'AND';
                  iavarrellog(in_srclib    :
                              in_srcspf    :
                              in_srcmbr    :
                              in_ifsloc    :                                             //0005
                              lk_reseq     :
                              in_rrn       :
                              lk_reroutine :
                              lk_rereltyp  :
                              lk_rerelnum  :
                              lk_reopc     :
                              lk_reresult  :
                              lk_rebif     :
                              lk_refact1   :
                              lk_recomp    :
                              lk_refact2   :
                              lk_recontin  :
                              lk_reresind  :
                              lk_recat1    :
                              lk_recat2    :
                              lk_recat3    :
                              lk_recat4    :
                              lk_recat5    :
                              lk_recat6    :
                              lk_reutil    :
                              lk_renum1    :
                              lk_renum2    :
                              lk_renum3    :
                              lk_renum4    :
                              lk_renum5    :
                              lk_renum6    :
                              lk_renum7    :
                              lk_renum8    :
                              lk_renum9    :
                              lk_reexc     :
                              lk_reinc );
               EndIf ;

            endsl;
            Clear lk_refact1;
         endif;
      endfor;

      in_seq = lk_reseq;

   endif;
   return;

end-proc;

//---------------------------------------------------------------------------------
//IaPsrDat : %Date Built in function parsing
//---------------------------------------------------------------------------------
dcl-proc IAPSRDAT export;
   dcl-pi IAPSRDAT;
      in_string  char(5000);
      in_opcode  char(10);
      in_type    char(10);
  //  in_srclib  char(10);                                                               //0005
  //  in_srcspf  char(10);                                                               //0005
  //  in_srcmbr  char(10);                                                               //0005
      in_uWSrcDtl likeds(uWSrcDtl);                                                      //0005
      in_RRN     packed(6:0);
      in_Factor1 char(80);
      in_Factor2 char(80);
      in_Seq     packed(6:0);
   end-pi;

   dcl-ds IAVARRELDS extname('IAVARREL') prefix(DT_) inz;
   end-ds;

   dcl-s arr         char(600)   inz dim(600);                                           //MT03
   dcl-s flag        char(10)    inz;
   dcl-s BIF_flag    char(1)     inz;
   dcl-s E_flag      char(1)     inz;
   dcl-s field2      char(500)   inz;
   dcl-s String      char(5000)  inz;
   dcl-s field4      char(5000)  inz;
   dcl-s D_bkfact2   char(80)    inz;
   dcl-s Dat_MainBIF char(10)    inz;
   dcl-s Tmp_Str     char(80)    inz;
   dcl-s DatFactor1  char(80)    inz;
   dcl-s DatFactor2  char(80)    inz;
   dcl-s Dat_BIF     char(10)    inz;
   dcl-s in_String1  char(80)    inz;
   dcl-s Tmp_Cst     char(80)    inz;
   dcl-s TmpFct2     char(80)    inz;
   dcl-s Pos1        packed(4:0) inz;
   dcl-s Pos2        packed(4:0) inz;
   dcl-s l_pos       packed(6:0) inz;
   dcl-s l_Spos      packed(6:0) inz;
   dcl-s l_Epos      packed(6:0) inz;
   dcl-s start       packed(6:0) inz;
   dcl-s i           packed(4:0) inz;
   dcl-s j           packed(4:0) inz;
   dcl-s DT_bkseq    packed(6:0) inz;
   dcl-s arr_var     char(600)   inz;

   dcl-c QUOTE       '"';

   if in_string = *Blanks;
      return;
   endif;
   clear IAVARRELDS;

   uwsrcdtl = In_uwsrcdtl;                                                                 //0005
   in_string = %xlate(LOWER :UPPER :in_string);
   Pos1 = %scan('~' :in_string :1);
   If Pos1 > 0;                                                                            //SS02
      in_string = %replace('' :in_string :Pos1 :1);

      Pos2 =  %scan('(' :in_string :Pos1);
   Else;                                                                                   //SS02
     Pos2 =  %scan('(' :in_string :1);                                                     //SS02
   Endif;                                                                                  //SS02
   start =  Pos2;

   If Pos2 <> 0;
      If Pos1 > 0  and (Pos2-Pos1) > 0;                                                     //SS02
         Dat_MainBIF = %subst(in_String:Pos1:Pos2-Pos1);
      Endif;                                                                                //SS02
      Pos1    = Pos2;                                                                       //BS01
      Pos2    = ProcessScanr(')':in_String:Pos1);                                           //BS01
      If Pos2-Pos1 > 1;                                                                     //SS02
         Tmp_Str = %subst(in_String:Pos1+1:Pos2-Pos1-1);                                    //BS01
      Endif;                                                                                //SS02
   Else;
      Dat_MainBif = in_String;
   EndIf;

   // Pos1    = Pos2;                                                                       //BS01
   // Pos2    = ProcessScanr(')':in_String:Pos1);                                           //BS01
   // Tmp_Str = %subst(in_String:Pos1+1:Pos2-Pos1-1);                                       //BS01

   if Tmp_Str <> *blanks;
      if %scan(':' :in_string) > 0;
         Pos1 = ProcessScanr(':':in_String);
         If Pos2-Pos1 > 1;                                                                  //SS02
            TmpFct2 = %subst(in_String:Pos1+1:Pos2-Pos1-1);
         Endif;                                                                             //SS02

         if (%scan('(':TmpFct2) > 0 and  %scan(')':TmpFct2) = 0) or
            (%scan(')':TmpFct2) > 0 and  %scan('(':TmpFct2) = 0 );
            E_flag = 'Y';
         endif;

         if %scan(Quote:TmpFct2) > 0;
            E_flag = 'Y';
         endif;

         if E_Flag = 'Y';
            If start > 0 and Pos2-Start > 1;                                                //SS02
               DatFactor1 = %subst(in_String:start:Pos2-Start-1);
            Endif;                                                                          //SS02
            DatFactor2 = *blanks;
         else;
            If Pos1-Start > 1;                                                              //SS02
               DatFactor1 = %subst(In_String:Start+1:Pos1-Start-1);
            Endif;                                                                          //SS02
            DatFactor2 = %trim(TmpFct2);
         endif;

      else ;
         Pos1 = ProcessScanr(')':in_string);
         If Pos1-Start > 1;                                                                 //SS02
            DatFactor1 = %subst(in_String:Start+1:Pos1-Start-1);
         Endif;                                                                             //SS02
      endif;
   else;
      DatFactor1 = *blanks;
      DatFactor2 = *blanks;
      DT_reseq = 1;
   endif;

   DatFactor1 = RMVbrackets(DatFactor1);

   if %scan(Quote:DatFactor1) >  0;
      Pos1 = %scan(Quote:DatFactor1);
      Pos2 = %scan(Quote:DatFactor1:Pos1+1);
      if %scan('+':DatFactor1:Pos2+1) > 0;
         split_component_2(DatFactor1 :arr :i);
      endif;
   endif;

   select;
   when %scan('%':DatFactor1) > 0 and %scan(Quote:DatFactor1) = 0 and i= 0;
      Pos1       = %scan('%':DatFactor1);
      Pos2       = %scan('(':DatFactor1:Pos1);
      If  Pos2 > Pos1 and Pos1 > 0 ;                                                       //SS02
         Dat_Bif    = %subst(DatFactor1:Pos1:Pos2-Pos1);
      Endif;                                                                               //SS02
      Pos2       = %scan(%trim(Dat_Bif):DatFactor1);
      in_String1 = '~' + DatFactor1;
      Bif_Flag   = 'Y';
      exsr  CallBIF1;
      clear Dat_Bif;
      clear DatFactor1;
      clear in_String1;

   when %scan(Quote:DatFactor1) > 0 and %scan('+':DatFactor1) = 0;
      Pos1    = %scan(Quote:DatFactor1);
      Pos2    = %scan(Quote:DatFactor1:Pos1+1);
      If (Pos2-Pos1) > 1;                                                                  //SS02
         Tmp_Cst = %subst(DatFactor1:Pos1+1:(Pos2-Pos1)-1);
      Endif;                                                                               //SS02
      clear DatFactor1;
      DatFactor1 = 'CONST(' + %trim(Tmp_Cst) + ')';
   endsl;

   if i > 0;
      for j = 1 to i-1;

         if j <= %elem(arr) and arr(j) <> *Blanks;
            arr_var = %trim(arr(j));
            if %scan('(' : arr_var) = 1;
               arr(j) = RMVbrackets(arr(j));
            endif;
            l_Epos = %scan('%'  : arr_var);
            l_Spos = %scan('''' : arr_var);
            if l_Spos = 0;
               l_Spos = %scan('"' : arr_var);
            endif;
            if j < i-1;
               DT_recomp  = '+';
            else;
               DT_recomp  = ' ';
            endif;

            select;
            when l_Spos <> 0 and l_Spos < l_Epos;
               DT_refact1 = 'CONST(' + %trim(arr(j)) + ')';
               if i = 2;
                  leave;
               endif;
               D_bkfact2 = DT_refact2;
               clear DT_refact2;
               DT_reseq += 1;
               DT_recontin = 'AND';
               if J = 1;
                  DT_rebif  = Dat_MainBif;
               else;
                  DT_rebif  = *blanks;
               endif;

               iavarrellog(in_srclib    :
                           in_srcspf    :
                           in_srcmbr    :
                           in_ifsloc    :                                                //0005
                           DT_reseq     :
                           in_rrn       :
                           DT_reroutine :
                           DT_rereltyp  :
                           DT_rerelnum  :
                           DT_reopc     :
                           DT_reresult  :
                           DT_rebif     :
                           DT_refact1   :
                           DT_recomp    :
                           DT_refact2   :
                           DT_recontin  :
                           DT_reresind  :
                           DT_recat1    :
                           DT_recat2    :
                           DT_recat3    :
                           DT_recat4    :
                           DT_recat5    :
                           DT_recat6    :
                           DT_reutil    :
                           DT_renum1    :
                           DT_renum2    :
                           DT_renum3    :
                           DT_renum4    :
                           DT_renum5    :
                           DT_renum6    :
                           DT_renum7    :
                           DT_renum8    :
                           DT_renum9    :
                           DT_reexc     :
                           DT_reinc );

               DT_refact2 = D_bkfact2;
               clear D_bkfact2;
               clear DT_refact1;

            when l_Epos <> 0 and (l_Spos > l_Epos or l_Spos = 0);
               l_pos        = %scan('(' :arr(j) :l_Epos);
             //If l_pos <> 0;
               If (l_pos-l_Epos) > 0;
                 DT_rebif   = %subst(arr(j) :l_Epos :l_pos-l_Epos);
               Else;
                 DT_rebif   = arr(j);
               Endif;
               string     = '~' + %subst(%trim(arr(j)) :l_Epos);
               DT_refact1 = *blanks;

               D_bkfact2  = DT_refact2;
               clear DT_refact2;
               Bif_Flag = 'Y';
             //callbif(in_srclib  :                                                      //0005
             //        in_srcspf  :                                                      //0005
             //        in_srcmbr  :                                                      //0005
               callbif(in_uWSrcDtl:                                                      //0005
                       In_rrn     :
                       DT_reseq   :
                       DT_bkseq   :
                       DT_REOPC   :
                       DT_refact1 :
                       DT_refact2 :
                       in_type    :
                       DT_RECOMP  :
                       DT_reBIF   :
                       flag       :
                       field2     :
                       string     :
                       field4 );

               DT_refact2 = D_bkfact2;
               clear D_bkfact2;

            other;
               if l_Spos <> 0;
                  DT_refact1 = 'CONST(' + %trim(arr(j)) + ')';
               elseif %check('0123456789' :arr(j)) <> 0;
                  DT_refact1 = %trim(arr(j));
               else;
                  DT_refact1 = 'CONST(' + %trim(arr(j)) + ')';
               endif;
               if i = 2;
                  leave;
               endif;
               DT_reseq += 1;
               DT_recontin = 'AND';
               D_bkfact2 = DT_refact2;
               clear DT_refact2;
               if  J = 1;
                  DT_rebif  = Dat_MainBif;
               else;
                  DT_rebif  = *blanks;
               endif;

               iavarrellog(in_srclib    :
                           in_srcspf    :
                           in_srcmbr    :
                           in_ifsloc    :                                                //0005
                           DT_reseq     :
                           in_rrn       :
                           DT_reroutine :
                           DT_rereltyp  :
                           DT_rerelnum  :
                           DT_reopc     :
                           DT_reresult  :
                           DT_rebif     :
                           DT_refact1   :
                           DT_recomp    :
                           DT_refact2   :
                           DT_recontin  :
                           DT_reresind  :
                           DT_recat1    :
                           DT_recat2    :
                           DT_recat3    :
                           DT_recat4    :
                           DT_recat5    :
                           DT_recat6    :
                           DT_reutil    :
                           DT_renum1    :
                           DT_renum2    :
                           DT_renum3    :
                           DT_renum4    :
                           DT_renum5    :
                           DT_renum6    :
                           DT_renum7    :
                           DT_renum8    :
                           DT_renum9    :
                           DT_reexc     :
                           DT_reinc );
               DT_refact2 = D_bkfact2;
               clear D_bkfact2;
               clear DT_refact1;
            endsl;
         endif;

      endfor;
      in_seq = DT_reseq;

   endif;

   if BIF_FLAG = 'Y';
      DT_Refact1  = DatFactor1;
      DT_Refact2  = DatFactor2;
      DT_RECONTIN = 'AND';
      DT_rebif    = Dat_MainBIF;

      if I > 0;
         DT_rebif   = *blanks;
         DT_Refact1 = *blanks;
      endif;
   else;
      DT_Refact1 = DatFactor1;
      DT_Refact2 = DatFactor2;
      DT_rebif   = Dat_MainBIF;
      if I > 0;
         DT_rebif   = *blanks;
         DT_Refact1 = *blanks;
      endif;
   endif;

   in_factor1 = Dt_Refact1;
   If Dt_Refact2 <> *Blanks;
      in_factor2 = 'CONST(' + %trim(Dt_Refact2) + ')';
   Else;
      in_factor2 = Dt_Refact2;
      in_seq     = DT_reseq;
   Endif;

   return;

   begsr CallBif1;

      string  = in_String1;
      DT_reseq +=  1;
      DT_reBIF  = Dat_Bif;
    //callbif(in_srclib  :                                                               //0005
    //        in_srcspf  :                                                               //0005
    //        in_srcmbr  :                                                               //0005
      callbif(in_uWSrcDtl:                                                               //0005
              In_rrn     :
              DT_reseq   :
              DT_bkseq   :
              DT_REOPC   :
              DT_refact1 :
              DT_refact2 :
              in_type    :
              DT_RECOMP  :
              DT_reBIF   :
              flag       :
              field2     :
              string     :
              field4 );

   endsr;

end-proc;

//-----------------------------------------------------------------------------
//IaDivBif : %Div Built in function parsing
//-----------------------------------------------------------------------------
dcl-proc iadivbif export;
   dcl-pi iadivbif;
      in_string  char(5000);
      in_opcode  char(10);
      in_type    char(10);
  //  in_srclib  char(10);                                                               //0005
  //  in_srcspf  char(10);                                                               //0005
  //  in_srcmbr  char(10);                                                               //0005
      in_uWSrcDtl likeds(uWSrcDtl);                                                      //0005
      in_RRN     packed(6:0);
      dv_refact1 char(80);
      dv_refact2 char(80);
      in_Seq     packed(6:0);
   end-pi;

   Dcl-s out_Array    char(600)     dim(600);                                            //MT03
   dcl-s arr          char(600)     inz dim(600);                                        //MT03
   Dcl-s out_Arrayopr char(1)       dim(600);                                            //MT03
   dcl-s bk_refact1   char(80)      inz;
   dcl-s flag         char(10)      inz;
   dcl-s field2       char(500)     inz;
   dcl-s String       char(5000)    inz;
   dcl-s field4       char(5000)    inz;
   dcl-s d_bkfact2    char(5000)    inz;
   dcl-s d_bkfact1    char(5000)    inz;
   dcl-s d_inquote    char(1)       inz;
   Dcl-s in_string1   varchar(5000);
   Dcl-s out_NoOfElm  packed(4:0);
   dcl-s d_pos        packed(6:0)   inz;
   dcl-s d_Spos       packed(6:0)   inz;
   dcl-s d_Epos       packed(6:0)   inz;
   dcl-s start        packed(6:0)   inz;
   dcl-s i            packed(4:0)   inz;
   dcl-s j            packed(4:0)   inz;
   dcl-s d_bkseq      packed(6:0)   inz;
   dcl-s k            packed(6:0)    inz;
   dcl-s tr_Bracket   packed(4:0)    inz;
   dcl-s c            char(1)        inz;
   dcl-s arr_var      char(600)      inz;

   if in_string = *Blanks;
      return;
   endif;
   uwsrcdtl = In_uwsrcdtl;                                                                 //0005
   in_string = %xlate(LOWER: UPPER:in_string);
   d_pos     = %scan('~' :in_string :1);
   if d_pos > 0;                                                                           //SS02
      in_string = %replace('' :in_string :d_pos :1);

      d_pos = %scan('%DIV' :in_string :d_pos);
   Else;                                                                                   //SS02
     d_pos = %scan('%DIV' :in_string :1);                                                  //SS02
   Endif;                                                                                  //SS02
   tr_bracket = 0;
   if d_pos <> 0;
      for k = d_pos+3 to %len(%trimr(in_string));
          c = %subst(in_string:k:1);
          select;
          when c = '(';
             inquote(in_string :k :d_inquote);
             if d_inquote = 'N';
                if start = 0;
                   start = k;
                else;
                   tr_bracket +=1;
                endif;
             endif;
          when c = ')';
             inquote(in_string :k :d_inquote);
             if d_inquote = 'N';
                tr_bracket -=1;
             endif;
          when c = ':';
             inquote(in_string :k :d_inquote);
             if d_inquote = 'N';
                if tr_bracket = 0 ;
                   if k-start > 1;                                                         //SS02
                   d_bkfact1  = %subst(in_string :start+1 :k-start-1);
                   endif ;                                                                 //SS02
                   findcbr(start :in_string);
                   if start-k > 1;                                                         //SS02
                      d_bkfact2  = %subst(in_string :k+1 :start-k-1);
                   Endif;                                                                  //SS02
                   leave;
                endif;
             endif;
          endsl;
      endfor;
// if %scan('%DIV' :in_string :d_pos) <> 0;
//
//    d_pos =  %scan('(' :in_string :d_pos);
//    start =  d_pos;
//
//    d_Spos = %scan('(' :in_string :d_pos+1);
//    if d_Spos <> 0;
//       inquote(in_string :d_Spos :d_inquote);
//       dow d_inquote = 'Y';
//          d_Spos = %scan('(' :in_string :d_Spos+1);
//          if d_Spos <> 0;
//             inquote(in_string :d_Spos :d_inquote);
//          else;
//             d_inquote = 'N';
//          endif;
//       enddo;
//    endif;
//
//    d_Epos = %scan(':' :in_string :d_pos+1);
//    if d_epos <> 0;
//       inquote(in_string :d_epos :d_inquote);
//       dow d_inquote = 'Y';
//          d_epos = %scan(':' :in_string :d_epos+1);
//          if d_epos <> 0;
//             inquote(in_string :d_epos :d_inquote);
//          else;
//             d_inquote = 'N';
//          endif;
//       enddo;
//    endif;
//
//    dow d_Spos < d_Epos;
//
//       if d_Spos <> 0;
//          findcbr(d_Spos :in_string);
//          d_pos = d_Spos;
//
//          if d_pos < d_Epos;
//             d_Spos = %scan('(' :in_string :d_pos+1);
//             if d_Spos <> 0;
//                inquote(in_string :d_Spos :d_inquote);
//                dow d_inquote = 'Y';
//                   d_Spos = %scan('(' :in_string :d_Spos+1);
//                   if d_Spos <> 0;
//                      inquote(in_string :d_Spos :d_inquote);
//                   else;
//                      d_inquote = 'N';
//                   endif;
//                enddo;
//             endif;
//
//          elseif d_pos > d_Epos;
//             d_Epos = %scan(':' :in_string :d_pos+1);
//             if d_epos <> 0;
//                   inquote(in_string :d_epos :d_inquote);
//                dow d_inquote = 'Y';
//                   d_epos = %scan(':' :in_string :d_epos+1);
//                   if d_epos <> 0;
//                      inquote(in_string :d_epos :d_inquote);
//                   else;
//                      d_inquote = 'N';
//                   endif;
//                enddo;
//             endif;
//
//             d_Spos = %scan('(' :in_string :d_pos+1);
//             if d_Spos <> 0;
//                inquote(in_string :d_Spos :d_inquote);
//                dow d_inquote = 'Y';
//                   d_epos = %scan('(' :in_string :d_Spos+1);
//                   if d_Spos <> 0;
//                      inquote(in_string :d_Spos :d_inquote);
//                   else;
//                      d_inquote = 'N';
//                   endif;
//                enddo;
//             endif;
//
//          endif;
//
//       else;
//          d_Spos = d_Epos + 1;
//       endif;
//
//    enddo;

//    d_bkfact1  = %subst(in_string :start+1 :d_Epos-start-1);
//    findcbr(start :in_string);
//    d_bkfact2  = %subst(in_string :d_epos+1 :start-d_epos-1);
      d_bkfact1  = RMVbrackets(d_bkfact1);
      d_bkfact2  = RMVbrackets(d_bkfact2);
      dv_reseq   = in_seq;
      in_string1 = d_bkfact1;
      split_component_5(in_string1:out_Array:out_Arrayopr:out_NoOfElm );
      i = out_NoOfElm + 1;

      for j = 1 to i-1;
         if j <= %elem(out_Array) and out_Array(j) <> *Blanks;
            arr_var = %trim(out_Array(j));
            d_Epos = %scan('%'  : arr_var);
            d_Spos = %scan('''' : arr_var);
            if d_Spos = 0;
               d_Spos = %scan('"' : arr_var);
            endif;

            dv_recomp  = out_Arrayopr(j);

            clear dv_refact2;
            select;
            when d_Epos <> 0 and (d_Spos > d_Epos or d_Spos = 0);

               d_pos      = %scan('(' :out_Array(j) :d_Epos);
             //If d_pos <> 0;
               If (d_pos-d_Epos) > 0;
                  dv_rebif   = %subst(out_Array(j) :d_Epos :d_pos-d_Epos);
               Else;
                  dv_rebif   = out_Array(j);
               Endif;
               string     = '~' + %subst(%trim(out_Array(j)) :d_Epos);

              //callbif(in_srclib  :                                                      //0005
              //        in_srcspf  :                                                      //0005
              //        in_srcmbr  :                                                      //0005
                callbif(in_uWSrcDtl:                                                      //0005
                       In_rrn     :
                       dv_reseq   :
                       d_bkseq    :
                       dv_REOPC   :
                       dv_refact1 :
                       dv_refact2 :
                       in_type    :
                       dv_RECOMP  :
                       dv_reBIF   :
                       flag       :
                       field2     :
                       string     :
                       field4);

            other;
               if %check('.0123456789' :out_Array(j)) <> 0;
                  dv_refact1 = %trim(out_Array(j));
               else;
                  dv_refact1 = 'CONST(' + %trim(out_Array(j)) + ')';
               endif;

               if i = 2;
                  leave;
               endif;

               If %trim(dv_refact1) = 'CONST()';
               Else;
                  dv_reseq += 1;
                  dv_recontin = 'AND';
                  iavarrellog(in_srclib    :
                              in_srcspf    :
                              in_srcmbr    :
                              in_ifsloc    :                                             //0005
                              dv_reseq     :
                              in_rrn       :
                              dv_reroutine :
                              dv_rereltyp  :
                              dv_rerelnum  :
                              dv_reopc     :
                              dv_reresult  :
                              dv_rebif     :
                              dv_refact1   :
                              dv_recomp    :
                              dv_refact2   :
                              dv_recontin  :
                              dv_reresind  :
                              dv_recat1    :
                              dv_recat2    :
                              dv_recat3    :
                              dv_recat4    :
                              dv_recat5    :
                              dv_recat6    :
                              dv_reutil    :
                              dv_renum1    :
                              dv_renum2    :
                              dv_renum3    :
                              dv_renum4    :
                              dv_renum5    :
                              dv_renum6    :
                              dv_renum7    :
                              dv_renum8    :
                              dv_renum9    :
                              dv_reexc     :
                              dv_reinc );
              Endif;
            endsl;
            clear dv_refact1;
         endif;
      endfor;

      d_bkfact1 = %trim(dv_refact1);

      in_string1 = d_bkfact2;
      split_component_5(in_string1:out_Array :
                         out_Arrayopr:out_NoOfElm );
      i = out_NoOfElm + 1;

      for j = 1 to i-1;
         if j <= %elem(out_Array) and out_Array(j) <> *Blanks;
            arr_var = %trim(out_Array(j));
            d_Epos = %scan('%'  : arr_var);
            d_Spos = %scan('''' : arr_var);
            if d_Spos = 0;
               d_Spos = %scan('"' : arr_var);
            endif;

            dv_recomp  = out_Arrayopr(j);

            clear dv_refact1;
            select;
            when d_Epos <> 0 and (d_Spos > d_Epos or d_Spos = 0);

               d_pos = %scan('(' :out_Array(j) :d_Epos);
             //If d_pos <> 0;
               If (d_pos-d_Epos) > 0;
                  dv_rebif = %subst(out_Array(j) :d_Epos :d_pos-d_Epos);
               Else;
                  dv_rebif = out_Array(j);
               Endif;
               if (d_pos-d_Epos) > 0;                                                       //PJ01
               dv_rebif = %subst(out_Array(j) :d_Epos :d_pos-d_Epos);
               endif;                                                                       //PJ01
               string = '~' + %subst(%trim(out_Array(j)) :d_Epos);

             //callbif(in_srclib  :                                                      //0005
             //        in_srcspf  :                                                      //0005
             //        in_srcmbr  :                                                      //0005
               callbif(in_uWSrcDtl:                                                      //0005
                       In_rrn     :
                       dv_reseq   :
                       d_bkseq    :
                       dv_REOPC   :
                       dv_refact1 :
                       dv_refact2 :
                       in_type    :
                       dv_RECOMP  :
                       dv_reBIF   :
                       flag       :
                       field2     :
                       string     :
                       field4 );

            other;
               if %check('.0123456789' :out_Array(j)) <> 0;
                  dv_refact2 = %trim(out_Array(j));
               else;
                  dv_refact2 = 'CONST(' + %trim(out_Array(j)) + ')';
               endif;

               if i = 2;
                  leave;
               endif;

               If %trim(dv_refact2) = 'CONST()';
               Else;
                  dv_reseq += 1;
                  dv_recontin = 'AND';
                  iavarrellog(in_srclib    :
                              in_srcspf    :
                              in_srcmbr    :
                              in_ifsloc    :                                             //0005
                              dv_reseq     :
                              in_rrn       :
                              dv_reroutine :
                              dv_rereltyp  :
                              dv_rerelnum  :
                              dv_reopc     :
                              dv_reresult  :
                              dv_rebif     :
                              dv_refact1   :
                              dv_recomp    :
                              dv_refact2   :
                              dv_recontin  :
                              dv_reresind  :
                              dv_recat1    :
                              dv_recat2    :
                              dv_recat3    :
                              dv_recat4    :
                              dv_recat5    :
                              dv_recat6    :
                              dv_reutil    :
                              dv_renum1    :
                              dv_renum2    :
                              dv_renum3    :
                              dv_renum4    :
                              dv_renum5    :
                              dv_renum6    :
                              dv_renum7    :
                              dv_renum8    :
                              dv_renum9    :
                              dv_reexc     :
                              dv_reinc );
               Endif;
            endsl;
            Clear dv_refact2;
         endif;

      endfor;
      dv_refact1 = d_bkfact1;
      in_seq = dv_reseq;
   endif;

   return;

end-proc;

//------------------------------------------------------------------- //
//IAPSRCFREE : Eval Free format parsing
//------------------------------------------------------------------- //
dcl-proc IAPSRCFREE  Export;
   dcl-pi IAPSRCFREE;
      in_string    char(5000);
      in_type      char(10);
      in_error     char(10);
      in_xRef      char(10);
  //  in_srclib  char(10);                                                               //0005
  //  in_srcspf  char(10);                                                               //0005
  //  in_srcmbr  char(10);                                                               //0005
      in_uWSrcDtl likeds(uWSrcDtl);                                                      //0005
      in_RRN       packed(6:0);
      in_rrn_e     packed(6:0);
      in_ErrLogFlg char(1);
   end-pi;

   dcl-pr IAPQUOTE;
      *n  char(5000);
      *n  packed(4:0);
      *n  char(1);
   end-pr;

   dcl-s operatorArr        char(1)     inz dim(600) ascend;                          //MT03
   dcl-s SUBSETVARS         char(600)   inz dim(600) ascend;                          //MT03
   dcl-s Ev_field           char(5000)  inz;                                          //MT03
   dcl-s Ev_field2          char(5000)  inz;                                          //MT03
   dcl-s Ev_field3          char(5000)  inz;                                          //MT03
   dcl-s Ev_field4          char(5000)  inz;                                          //MT03
   dcl-s Ev_flag            char(10)    inz;
   dcl-s Ev_bif             char(10)    inz;
   dcl-s W_SrcFile          char(10)    inz;
   dcl-s In_flag            char(1)     inz;
   dcl-s Ev_factor1         char(80)    inz;
   dcl-s Ev_factor2         char(80)    inz;
   dcl-s Ev_type            char(10)    inz;
   dcl-s br_inquote         char(1)     inz;
   dcl-s Ev_CONT            char(10)    inz;
   dcl-s CaptureFlg         char(1)     inz;
   dcl-s Ev_field3bk        char(5000)  inz;
   dcl-s Ev_opcode          char(10)    inz;
   dcl-s Ev_opcode1         char(10)    inz;                                              //SB01
   dcl-s In_bif             char(10)    inz;
   dcl-s Ev_constant        char(80)    inz;
   dcl-s arraysignpositions packed(5)   inz dim(600)ascend;                               //MT03
   dcl-s tempArray          packed(5)   inz dim(600)ascend;                               //MT03
   dcl-s arrayaddsign       packed(3:0) inz dim(600);                                     //MT03
   dcl-s arraydivsign       packed(3:0) inz dim(600);                                     //MT03
   dcl-s arraysubsign       packed(3:0) inz dim(600);                                     //MT03
   dcl-s arraymulsign       packed(3:0) inz dim(600);                                     //MT03
   dcl-s Count              packed(2:0) inz;
   dcl-s tr_Counter         packed(4:0) inz;
   dcl-s tr_Length          packed(4:0) inz;
   dcl-s tr_Brackets        packed(4:0) inz;
   dcl-s Elementpos         packed(4:0) inz;
   dcl-s OBpos              packed(4:0) inz;
   dcl-s Ev_seq             packed(6:0) inz;
   dcl-s Ev_bkseq           packed(6:0) inz;
   dcl-s Ev_pos1            packed(6:0) inz;
   dcl-s Ev_pos2            packed(6:0) inz;
   dcl-s Ev_pos3            packed(6:0) inz;                                              //SB01
   dcl-s In_postion         packed(4:0) inz;
   dcl-s Ev_length          packed(4:0) inz;
   dcl-s Ev_length2         packed(4:0) inz;
   dcl-s intermediateAddPos packed(6:0) inz;
   dcl-s intermediateSubPos packed(6:0) inz;
   dcl-s intermediateMulPos packed(6:0) inz;
   dcl-s intermediateDivPos packed(6:0) inz;
   dcl-s frompos            packed(3:0) inz;
   dcl-s qualfd_dotpos      packed(3:0) inz;                                             //MT01
   dcl-s i                  int(5)      inz;
   dcl-s j                  int(5)      inz;
   dcl-s k                  int(5)      inz;
   dcl-s l                  int(5)      inz;
   dcl-s Z                  int(5)      inz;
   dcl-s index              int(5)      inz;
   dcl-s itr                int(5)      inz;
   dcl-s ndx                int(5)      inz;
   dcl-s rdx                int(5)      inz;
   dcl-s Pos                int(5)      inz;
   dcl-s X                  int(5)      inz;
   dcl-s In_string1         varchar(5000) inz ;
   dcl-c Ch_Quote           '''';
   dcl-c quote              '"';
   dcl-c SQL_ALL_OK         '00000';
   dcl-s w_pos              packed(4:0) inz;                                              //JM03
   dcl-s w_string           Char(500)   inz;                                              //JM03
   dcl-s in_stringt         Char(5000)  inz;

   dcl-ds IAVARRELDs extname('IAVARREL') prefix(In_) inz;
   end-ds;

   if in_string = *Blanks;
      return;
   endif;
   clear ev_seq;
   clear ev_bkseq;
   clear IAVARRELDS;
   uwsrcdtl = In_uwsrcdtl;                                                               //0005
   //SB02 monitor;
      //------------------Replace ';' with  ''----------------------------- //
      exec sql
           set :In_String = replace(:In_String, ';', '');
      Ev_length = %len(%trim(in_String));
      in_stringt = %trim(in_String);
      //Check Eval is also present or not                                                //SB01
   // If %subst(%trim(in_String):1:4) = 'EVAL';                                //SB01     //SK06
   // If %scan('EVAL ' :  %subst(%trim(in_String):1)) = 1;                     //AJ01     //SK06
      If in_String <> *blanks and Ev_length > 0 And                                       //SS02
         ((%scan('EVAL ' :  %subst(in_Stringt:1)) = 1) or                                 //SS02
         (%scan('EVAL(' :  %subst(in_Stringt:1)) = 1) or                                  //AJ01
         (%scan('EVALR ' : %subst(in_Stringt:1)) = 1) or                                  //AJ01
         (%scan('EVALR(' : %subst(in_Stringt:1)) = 1));                                   //SS02
         Ev_Pos3 = %scan(' ':in_Stringt:1);                                               //SB01
         If Ev_Pos3 > 0;                                                                  //SS02
           Ev_Opcode1 = %subst(in_stringt:1:Ev_Pos3);                                     //AJ01
         Endif;                                                                           //SS02
         in_String = %subst(in_stringt:Ev_Pos3+1);                                        //SB01
      EndIf;                                                                              //SB01
      Ev_length = %len(%trim(in_string));
      in_stringt = %trim(in_string);
      //---------------Scan Postion '='----------------------------------- //
      Ev_pos1 = %scan('=' : in_Stringt);

      if Ev_pos1 > 1;
         //*---------------Extract Resultant Field----------------------------*/
         Ev_field2 = %subst(In_stringt : 1 :Ev_pos1-1 );
         //*---------------Extract Factor Field ------------------------------*/
         w_string = in_stringt;                                                            //JM03
         w_pos    = %scan('=' : in_Stringt);                                              //JM03
         procAddSub(w_string:w_pos:Ev_field3);                                            //JM03
         If Ev_field3 = *Blanks and Ev_length > ev_pos1;                                  //SS02
           Ev_field3 = %subst(In_stringt:ev_pos1+1:Ev_length-ev_pos1);                    //JM03
         EndIf;                                                                           //JM03
         Ev_length2 = %len(%trim(Ev_field3));
         //*---------------------Split the factor in array---------------*//
         if Ev_field3 <> *blanks and %subst(%trim(Ev_field3):1:1) <> '*';
            In_string1 = %trim(Ev_field3);
            split_component_5(In_string1 :subsetVars
                              :operatorArr:elementpos);
            rdx = 1;
            dow rdx <= %elem(subsetVars) and subsetVars(rdx) <> *blanks;
               clear Ev_field3;
               Ev_field3 =  %trim(subsetVars(rdx));
         //*operatorArr = 'P'--> '**'//
               if operatorArr(rdx) <> 'P';
                  in_RECOMP     = operatorArr(rdx);
               else;
                  in_RECOMP     = '**';
               endif;
               exsr Sr_factor;
               rdx += 1;
            enddo;
         elseif Ev_field3 <> *blanks;
            exsr varref;
         endif;
      endif;

   return;

   Begsr Sr_Factor;

      clear Ev_pos1;
      //----------------- Search for  BIF -- ------------------------ //
      ev_field3bk = %trim(Ev_field3);
      Ev_pos1     = %scan('%' : ev_field3bk);
      if Ev_pos1 > 0;
         inquote(ev_field3bk:Ev_pos1:br_inquote);
         dow br_inquote = 'Y';
            Ev_pos1= %scan('%' :ev_field3bk :Ev_pos1+1);
            if Ev_pos1 > 0;
               inquote(ev_field3bk:Ev_pos1:br_inquote);
            else;
               br_inquote = 'N';
            endif;
         enddo;
      endif;

      //------------BIF found call the respective procedure------------- //
      if Ev_field3 <> *blanks and Ev_pos1 > 0;
         Ev_pos2    =   %scan('(' : %trim(Ev_field3): ev_pos1);                           //AS01
         If Ev_pos2 > 0 and Ev_pos2 > Ev_pos1;
            Ev_bif  =   %subst(%trim(ev_field3) : ev_pos1 :Ev_pos2-Ev_pos1);
         Else;
            Ev_bif  =   ev_field3;
         EndIf;
         Ev_field4  = '~'+%trim(Ev_field3);

         exsr callbif1;
      else;
      //*-------------Factor Field --------------------------------------*//
         in_RERESULT  =  Ev_field2;
         in_REFACT1   =  Ev_field3;
         in_REOPC     =  Ev_type;
         in_REFACT2   = *blanks;
         exsr varref;
         ev_bkseq     = ev_seq;
      endif;

      if in_RECOMP <> ' ';
         in_RECONTIN = ' ';
      else;
         in_RECOMP = ' ';
         in_RECONTIN = ' ';
      endif;
      exec sql
        update IAVARREL
         set RECOMP = :in_RECOMP,
             RECONTIN = :in_RECONTIN
         where RESEQ = :ev_bkseq
           and RERRN = :in_rrn
           and RESRCLIB = :in_srclib
           and RESRCFLN = :in_srcspf
           and REPGMNM = :in_srcmbr;
      if SQLSTATE <> SQL_ALL_OK;
         //log error
      endif;

   endsr;

   begsr varref;

      in_RESRCLIB  =  in_srclib;
      in_RESRCFLN  =  in_srcspf;
      in_REPGMNM   =  in_srcmbr;
      in_REIFSLOC  =  in_ifsloc;                                                         //0005
      Ev_constant  = Ev_field3;
      exsr Check_constant;
      Ev_field3    = Ev_constant;
      in_RERESULT  =  Ev_field2;
      in_REFACT1   =  Ev_field3;
      If Ev_Pos3   > 0;                                                                   //SB01
         in_REOPC  =  Ev_Opcode1;                                                         //SB01
      Else;                                                                               //SB01
         in_REOPC  =  '=';
      EndIf;                                                                              //SB01

      if ev_seq    = 0;
         in_RESEQ  = 1;
         ev_seq    = in_reseq;
      else;
         in_RECONTIN  = 'AND';
      // in_RERESULT  = *blanks;                                                          //AJ01
         in_RERESULT  =  Ev_field2;                                                       //AJ01
         in_REOPC     = *blanks;
         in_reseq     = Ev_seq+1;
         ev_seq       = in_reseq;
      endif;

      in_RERRN  =  In_rrn;
      in_RENUM1 = 0;
      in_RENUM2 = 0;
      in_RENUM3 = 0;
      in_RENUM4 = 0;
      in_RENUM5 = 0;
      in_RENUM6 = 0;
      in_RENUM7 = 0;
      in_RENUM8 = 0;
      in_RENUM9 = 0;

      If %scan('Const(' : in_REFACT1) =  0;                                            //MT01
         qualfd_dotpos = %scan('.' : in_REFACT1);
         Dow qualfd_dotpos > 0 ;                                                       //MT01
            in_REFACT1= %subst(in_REFACT1: qualfd_dotpos + 1);                         //MT01
            qualfd_dotpos = %scan('.' : in_REFACT1 : 1);
         Enddo;
         If %scan('(' : in_REFACT1)  > 1 and %scan(')' : in_REFACT1)  > 0              //SS02
            and %scan('%' : in_REFACT1)  = 0;                                          //MT02
            in_REFACT1 =  %subst(in_REFACT1 : 1 :                                      //MT02
                                       %scan('(' : in_REFACT1) - 1);                   //MT02
         Endif;                                                                        //MT02
      Endif;                                                                           //MT01

      If %scan('Const(' : in_REFACT2) =  0;                                            //MT01
         qualfd_dotpos = %scan('.' : in_REFACT2);
         Dow qualfd_dotpos <> 0 ;                                                      //MT01
            in_REFACT2= %subst(in_REFACT2: qualfd_dotpos + 1);                         //MT01
            qualfd_dotpos = %scan('.' : in_REFACT2 : 1);
         Enddo;
         If %scan('(' : in_REFACT2)  > 1 and %scan(')' : in_REFACT2)  > 0              //SS02
            and %scan('%' : in_REFACT2)  = 0;                                          //MT02
            in_REFACT2 =  %subst(in_REFACT2 : 1 :                                      //MT02
                                       %scan('(' : in_REFACT2) - 1);                   //MT02
         Endif;                                                                        //MT02
      Endif;                                                                           //MT01

      If %scan('Const(' : in_RERESULT ) = 0;                                           //MT01
         qualfd_dotpos = %scan('.' : in_RERESULT);
         Dow qualfd_dotpos <> 0 ;                                                      //MT01
            in_RERESULT = %subst(in_RERESULT : qualfd_dotpos+ 1);                      //MT01
            qualfd_dotpos = %scan('.' : in_RERESULT: 1);
         Enddo;
         If %scan('(' : in_RERESULT) > 1 and %scan(')' : in_RERESULT) > 0              //MT02
            and %scan('%' : in_RERESULT) = 0;                                          //MT02
            in_RERESULT = %subst(in_RERESULT : 1 :                                     //MT02
                                       %scan('(' : in_RERESULT) - 1);                  //MT02
         Endif;                                                                        //MT02
      Endif;                                                                           //MT01

      IAVARRELLOG(in_RESRCLIB  :
                  in_RESRCFLN  :
                  in_REPGMNM   :
                  in_REIFSLOC  :                                                         //0005
                  in_RESEQ     :
                  in_RERRN     :
                  in_REROUTINE :
                  in_RERELTYP  :
                  in_RERELNUM  :
                  in_REOPC     :
                  in_RERESULT  :
                  In_Bif       :
                  in_REFACT1   :
                  in_RECOMP    :
                  in_REFACT2   :
                  in_RECONTIN  :
                  in_RERESIND  :
                  in_RECAT1    :
                  in_RECAT2    :
                  in_RECAT3    :
                  in_RECAT4    :
                  in_RECAT5    :
                  in_RECAT6    :
                  in_REUTIL    :
                  in_RENUM1    :
                  in_RENUM2    :
                  in_RENUM3    :
                  in_RENUM4    :
                  in_RENUM5    :
                  in_RENUM6    :
                  in_RENUM7    :
                  in_RENUM8    :
                  in_RENUM9    :
                  in_REEXC     :
                  in_REINC );

   endsr;


   begsr Check_constant;

      //Check for constant value.... ex:- *BLANKS, *ON, *OFF
    if Ev_constant <> *blanks ;                                                          //PJ01
      select;
      when %scan('*':%trim(Ev_constant):1) > 0;
         Ev_constant =  'Const(' + %trim(Ev_constant) + ')';
      when %scan(Ch_Quote:%trim(Ev_constant ):1) > 0
      or  %scan(Quote: %trim(Ev_constant ):1) > 0 ;
         Ev_constant =  'Const(' + %trim(Ev_constant) + ')';
      when %check('(!@#$%Â¢&*()_-<>?/:;"-)':%trim(Ev_constant):1) = 0;
         Ev_constant =  'Const(' + %trim(Ev_constant) + ')';
      other;
      endsl;

      if %check('+-.0123456789':%trim(Ev_constant):1) = 0;                               //NG01
         Ev_constant =  'Const(' + %trim(Ev_constant) + ')';
      endif;
    endif ;                                                                              //PJ01

   endsr;

   begsr callBif1;

      ev_seq     = ev_bkseq;
      If ev_opcode1 <> ' ' and Ev_seq = 0;                                                 //AJ01
         ev_opcode  = ev_opcode1;                                                          //AJ01
      Else;                                                                                //AJ01
         If Ev_seq = 0;                                                                    //AJ01
      ev_opcode  = '=';
         Else;                                                                             //AJ01
            ev_opcode  = ' ';                                                              //AJ01
         Endif;                                                                            //AJ01
      Endif;                                                                               //AJ01
      ev_factor1 = *blanks;
      ev_factor2 = *blanks;
      in_bif     = EV_bif;
      in_string  = Ev_field4;
      ev_flag    = *blanks;
      ev_field4  = *blanks;
      ev_field2  = Ev_field2;

    //Callbif(in_srclib  :                                                               //0005
    //        in_srcspf  :                                                               //0005
    //        in_srcmbr  :                                                               //0005
      callbif(in_uWSrcDtl:                                                               //0005
              in_rrn     :
              ev_Seq     :
              ev_bkseq   :
              ev_opcode  :
              ev_factor1 :
              ev_factor2 :
              in_type    :
              Ev_CONT    :
              in_bif     :
              Ev_flag    :
              Ev_field2  :
              in_String  :
              Ev_field4 );

   endsr;

end-proc;

//-------------------------------------------------------------------- //
//IaLookupBif :
//-------------------------------------------------------------------- //
dcl-proc ialookupbif export;
   dcl-pi ialookupbif;
      in_string  char(5000);
      in_opcode  char(10);
      in_type    char(10);
  //  in_srclib  char(10);                                                               //0005
  //  in_srcspf  char(10);                                                               //0005
  //  in_srcmbr  char(10);                                                               //0005
      in_uWSrcDtl likeds(uWSrcDtl);                                                      //0005
      in_RRN     packed(6:0);
      lk_refact1 char(80);
      lk_refact2 char(80);
      in_Seq     packed(6:0);
   end-pi;

   dcl-s flag         Char(10)      inz;
   dcl-s field2       Char(500)     inz;
   dcl-s String       char(5000)    inz;
   dcl-s field4       Char(5000)    inz;
   dcl-s arr          char(600)     dim(600) inz;                                        //MT03
   dcl-s xl_ArrayOpt  char(1)       dim(600) inz;                                        //MT03
   dcl-s l_inquote    char(1)       inz;
   dcl-s l_bkfact2    varchar(5000) inz;
   dcl-s l_bkfact1    varchar(5000) inz;
   dcl-s xl_in_string varchar(5000) inz;
   dcl-s l_pos        packed(6:0)   inz;
   dcl-s l_Spos       packed(6:0)   inz;
   dcl-s l_Epos       packed(6:0)   inz;
   dcl-s start        packed(6:0)   inz;
   dcl-s i            packed(4:0)   inz;
   dcl-s j            packed(4:0)   inz;
   dcl-s l_bkseq      packed(6:0)   inz;
   dcl-s arr_var      char(600)     inz;

   if in_string = *Blanks;
      return;
   endif;
   uwsrcdtl = In_uwsrcdtl;                                                                 //0005
   in_string = %xlate(LOWER: UPPER: in_string);
   l_pos     = %scan('~' :in_string :1);
   If l_pos > 0;                                                                           //SS02
      in_string = %replace('' :in_string :l_pos :1);
   Else;                                                                                   //SS02
     l_pos = 1;                                                                            //SS02
   Endif;                                                                                  //SS02

   if %scan('%LOOKUP'   :in_string :l_pos) <> 0 or
      %scan('%TLOOKUP'  :in_string :l_pos) <> 0 or
      %scan('%LOOKUPLT' :in_string :l_pos) <> 0 or
      %scan('%LOOKUPLE' :in_string :l_pos) <> 0 or
      %scan('%LOOKUPGT' :in_string :l_pos) <> 0 or
      %scan('%LOOKUPGE' :in_string :l_pos) <> 0;

      if  %scan('%LOOKUP' : in_string) > 0;                                                //MT05
         l_pos = %scan('(' : in_string : %scan('%LOOKUP' : in_string));                    //BS02
      endif;                                                                               //MT05
      // l_pos =  %scan('(' :in_string :l_pos);                                            //BS02
      start =  l_pos;

      l_Spos = %scan('(' :in_string :l_pos+1);
      if l_spos <> 0;
         inquote(in_string :l_spos :l_inquote);
         dow l_inquote = 'Y';
            l_Spos = %scan('(' :in_string :l_spos+1);
            if l_spos <> 0;
               inquote(in_string :l_spos :l_inquote);
            else;
               l_inquote = 'N';
            endif;
         enddo;
      endif;

      l_Epos = %scan(':' :in_string :l_pos+1);
      if l_epos <> 0;
         inquote(in_string :l_epos :l_inquote);
         dow l_inquote = 'Y';
            l_epos = %scan(':' :in_string :l_epos+1);
            if l_epos <> 0;
               inquote(in_string :l_epos :l_inquote);
            else;
               l_inquote = 'N';
            endif;
         enddo;
      endif;

      dow l_Spos < l_Epos;

         if l_Spos <> 0;
            findcbr(l_Spos :in_string);
            l_pos = l_Spos;

            if l_pos < l_Epos;
               l_Spos = %scan('(' :in_string :l_pos+1);
               if l_spos <> 0;
                  inquote(in_string :l_spos :l_inquote);
                  dow l_inquote = 'Y';
                     l_spos = %scan(':' :in_string :l_spos+1);
                     if l_spos <> 0;
                        inquote(in_string :l_spos :l_inquote);
                     else;
                        l_inquote = 'N';
                     endif;
                  enddo;
               endif;

            elseif l_pos > l_Epos;
               l_Epos = %scan(':' :in_string :l_pos+1);
               if l_epos <> 0;
                  inquote(in_string :l_epos :l_inquote);
                  dow l_inquote = 'Y';
                     l_epos = %scan(':' :in_string :l_epos+1);
                     if l_epos <> 0;
                        inquote(in_string :l_epos :l_inquote);
                     else;
                        l_inquote = 'N';
                     endif;
                  enddo;
               endif;

               l_Spos = %scan('(' :in_string :l_pos+1);
               if l_spos <> 0;
                  inquote(in_string :l_spos :l_inquote);
                  dow l_inquote = 'Y';
                     l_spos = %scan(':' :in_string :l_spos+1);
                     if l_spos <> 0;
                        inquote(in_string :l_spos :l_inquote);
                     else;
                        l_inquote = 'N';
                     endif;
                  enddo;
               endif;
            endif;
         else;
            l_Spos = l_Epos + 1;
         endif;

      enddo;

      if (l_Epos-start-1) > 0;                                                  //VP01
         l_bkfact1 = %subst(in_string :start+1 :l_Epos-start-1);
      endif;                                                                    //VP01
      start     = l_Epos;

      l_Epos = %scan(':' :in_string :l_Epos+1);
      if l_epos <> 0;
         inquote(in_string :l_epos :l_inquote);
         dow l_inquote = 'Y';
            l_epos = %scan(':' :in_string :l_epos+1);
            if l_epos <> 0;
               inquote(in_string :l_epos :l_inquote);
            else;
               l_inquote = 'N';
            endif;
         enddo;
      endif;

     // if l_Epos <> 0;
      if (l_Epos-start) > 1;
         l_bkfact2 = %subst(in_string :start+1 :l_Epos-start-1);
      else;
         l_Epos = %scan(')' :in_string :start+1);
         if (l_Epos-start) > 1;                                                            //SS02
            l_bkfact2 = %subst(in_string :start+1 :l_Epos-start-1);
         Endif;                                                                            //SS02
      endif;

      l_bkfact1 = RMVbrackets(l_bkfact1);

      xl_in_string = l_bkfact1;
      split_component_5(xl_in_string :arr :xl_ArrayOpt :i);
      i = i + 1;

      lk_reseq = in_seq;
      for j = 1 to i-1;
         if j <= %elem(arr) and arr(j) <> *Blanks;
            arr_var = %trim(arr(j));
            if %scan('(' : arr_var) = 1;
               arr(j) = RMVbrackets(arr(j));
            endif;
            if arr(j) <> *blanks;                                                           //MT05
               l_Epos = %scan('%'  : arr_var);
               l_Spos = %scan('''' : arr_var);
               if l_Spos = 0;
                  l_Spos = %scan('"' : arr_var);
               endif;
            endif;                                                                          //MT05

            lk_recomp = xl_ArrayOpt(j);

            clear lk_refact2;
            select;
            when l_Spos <> 0 and l_Spos < l_Epos and arr(j) <> *blanks;                     //MT05
               lk_refact1 = 'CONST(' + %trim(arr(j)) + ')';

               if i = 2;
                  leave;
               endif;

               lk_reseq += 1;
               lk_recontin = 'AND';

               iavarrellog(in_srclib    :
                           in_srcspf    :
                           in_srcmbr    :
                           in_ifsloc    :                                                //0005
                           lk_reseq     :
                           in_rrn       :
                           lk_reroutine :
                           lk_rereltyp  :
                           lk_rerelnum  :
                           lk_reopc     :
                           lk_reresult  :
                           lk_rebif     :
                           lk_refact1   :
                           lk_recomp    :
                           lk_refact2   :
                           lk_recontin  :
                           lk_reresind  :
                           lk_recat1    :
                           lk_recat2    :
                           lk_recat3    :
                           lk_recat4    :
                           lk_recat5    :
                           lk_recat6    :
                           lk_reutil    :
                           lk_renum1    :
                           lk_renum2    :
                           lk_renum3    :
                           lk_renum4    :
                           lk_renum5    :
                           lk_renum6    :
                           lk_renum7    :
                           lk_renum8    :
                           lk_renum9    :
                           lk_reexc     :
                           lk_reinc );

           when l_Epos <> 0 and (l_Spos > l_Epos or l_Spos = 0);
              l_pos      = %scan('(' :arr(j) :l_Epos);
             // If ( l_pos <> 0);
              If (l_pos-l_Epos) > 0;
                 lk_rebif   = %subst(arr(j) :l_Epos :l_pos-l_Epos);
              Else;
                 lk_rebif = arr(j);
              EndIf;
              if l_Epos > 0 and arr(j) <> *blanks;                                          //MT05
                 string  = '~' + %subst(%trim(arr(j)) :l_Epos);
              endif;                                                                        //MT05

            //callbif(in_srclib  :                                                       //0005
            //        in_srcspf  :                                                       //0005
            //        in_srcmbr  :                                                       //0005
              callbif(in_uWSrcDtl:                                                       //0005
                      In_rrn     :
                      lk_reseq   :
                      l_bkseq    :
                      lk_REOPC   :
                      lk_refact1 :
                      lk_refact2 :
                      in_type    :
                      lk_RECOMP  :
                      lk_reBIF   :
                      flag       :
                      field2     :
                      string     :
                      field4 );

           other;
              if arr(j) <> *blanks;                                                           //MT05
                 if l_Spos <> 0;
                    lk_refact1 = 'CONST(' + %trim(arr(j)) + ')';
                 elseif %check('.0123456789' :%trim(arr(j))) <> 0;
                    lk_refact1 = %trim(arr(j));
                 else;
                    lk_refact1 = 'CONST(' + %trim(arr(j)) + ')';
                 endif;
             endif;                                                                           //MT05

              if i = 2;
                 leave;
              endif;

              If %trim(lk_refact1) = 'CONST()' ;
              Else ;
                 lk_reseq += 1;
                 lk_recontin = 'AND';
                 iavarrellog(in_srclib    :
                             in_srcspf    :
                             in_srcmbr    :
                             in_ifsloc    :                                              //0005
                             lk_reseq     :
                             in_rrn       :
                             lk_reroutine :
                             lk_rereltyp  :
                             lk_rerelnum  :
                             lk_reopc     :
                             lk_reresult  :
                             lk_rebif     :
                             lk_refact1   :
                             lk_recomp    :
                             lk_refact2   :
                             lk_recontin  :
                             lk_reresind  :
                             lk_recat1    :
                             lk_recat2    :
                             lk_recat3    :
                             lk_recat4    :
                             lk_recat5    :
                             lk_recat6    :
                             lk_reutil    :
                             lk_renum1    :
                             lk_renum2    :
                             lk_renum3    :
                             lk_renum4    :
                             lk_renum5    :
                             lk_renum6    :
                             lk_renum7    :
                             lk_renum8    :
                             lk_renum9    :
                             lk_reexc     :
                             lk_reinc );
              EndIf ;

           endsl;
           Clear lk_refact1;
       endif;
     endfor;

     if l_bkfact2 <> *blanks;                                                            //MT05
        lk_refact2 = %trim(l_bkfact2);
     endif;                                                                              //MT05
     in_seq     = lk_reseq;

   endif;

   Return;
end-proc;

//---------------------------------------------------------------------------- //
//IaReplace :
//---------------------------------------------------------------------------- //
dcl-proc iareplace export;
   dcl-pi iareplace;
      in_string  char(5000);
      in_opcode  char(10);
      in_type    char(10);
  //  in_srclib  char(10);                                                               //0005
  //  in_srcspf  char(10);                                                               //0005
  //  in_srcmbr  char(10);                                                               //0005
      in_uWSrcDtl likeds(uWSrcDtl);                                                      //0005
      in_RRN     packed(6:0);
      ik_refact1 char(80);
      ik_refact2 char(80);
      in_Seq     packed(6:0);
   end-pi;

   dcl-s arr        char(600)     inz dim(600);                                          //MT03
   dcl-s arrOpr     char(1)       inz dim(600);                                          //MT03
   dcl-s flag       Char(10)      inz;
   dcl-s field2     Char(500)     inz;
   dcl-s String     char(5000)    inz;
   dcl-s field4     Char(5000)    inz;
   dcl-s l_bkfact2  char(80)      inz;
   dcl-s l_bkfact1  char(80)      inz;
   dcl-s l_inquote  char(1)       inz;
   dcl-s In_string1 varchar(5000) inz;
   dcl-s lk_refact1 varchar(5000) inz;
   dcl-s lk_refact2 varchar(5000) inz;
   dcl-s l_pos      packed(6:0)   inz;
   dcl-s s_pos      packed(6:0)   inz;                                                        //BS04
   dcl-s l_Spos     packed(6:0)   inz;
   dcl-s l_Epos     packed(6:0)   inz;
   dcl-s start      packed(6:0)   inz;
   dcl-s i          packed(4:0)   inz;
   dcl-s j          packed(4:0)   inz;
   dcl-s l_bkseq    packed(6:0)   inz;
   dcl-s k          packed(6:0)   inz;
   dcl-s l          packed(6:0)   inz;
   dcl-s tr_bracket packed(6:0)   inz;
   dcl-s c          char(1)       inz;
   dcl-s arr_var    char(600)     inz;

   if in_String = *Blanks;
      return;
   endif;
   uwsrcdtl = In_uwsrcdtl;                                                               //0005
   in_string = %xlate(LOWER: UPPER: in_string);
   s_pos     = %scan('~' :in_string :1);                                                      //BS04
   if s_pos > 0;                                                                          //MT05
      in_string = %replace('' :in_string :s_pos :1);                                          //BS04

      l_pos = %scan('%REPLACE' :in_string :s_pos);                                            //BS04
      if l_pos = 0;                                                                          //BS04
         l_pos = %scan('%SCANRPL' :in_string : s_pos);                                       //BS04
      endif;                                                                                //BS04
   endif;                                                                                 //MT05
   k = 0;
   if l_pos <> 0;
      for l = l_pos+8 to %len(%trimr(in_string));
          c = %subst(in_string:l:1);
          select;
          when c = '(';
             inquote(in_string :l :l_inquote);
             if l_inquote = 'N';
                if start = 0;
                   start = l;
                else;
                   tr_bracket +=1;
                endif;
             endif;
          when c = ')';
             inquote(in_string :l :l_inquote);
             if l_inquote = 'N';
                select;
                when k = 0 and tr_bracket = 0 and l-start > 1;                            //MT05
                   lk_refact1 = %subst(in_string :start+1 :l-start-1);
                   start=l+1;
                when k = 1 and tr_bracket = 0 and start > 0 and l-start > 0;              //MT05
                   lk_refact2 = %subst(in_string :start :l-start);
                   leave;
                endsl;
                tr_bracket -=1;
             endif;
          when c = ':';
             inquote(in_string :l :l_inquote);
             if l_inquote = 'N';
                if tr_bracket = 0;
                   k+=1;
                   select;
                   when k = 1 and l-start > 1;                                             //MT05
                      lk_refact1 = %subst(in_string :start+1 :l-start-1);
                      start=l+1;
                   when k = 2  and start > 0 and l-start > 0;                               //MT05
                      lk_refact2 = %subst(in_string :start :l-start);
                      leave;
                   endsl;
                endif;
             endif;
          other;
          endsl;
      endfor;
// if %scan('%REPLACE' :in_string :l_pos) <> 0;
//    l_pos  =  %scan('(' :in_string :l_pos);
//    start  =  l_pos;
//    l_Spos = %scan('(' :in_string :l_pos+1);
//    if l_Spos <> 0;
//       inquote(in_string :l_Spos :l_inquote);
//       dow l_inquote = 'Y';
//          l_Spos = %scan('(' :in_string :l_Spos+1);
//          if l_Spos <> 0;
//             inquote(in_string :l_Spos :l_inquote);
//          else;
//             l_inquote = 'N';
//          endif;
//       enddo;
//    endif;
//
//    l_Epos = %scan(':' :in_string :l_pos+1);
//    if l_epos <> 0;
//       inquote(in_string :l_epos :l_inquote);
//       dow l_inquote = 'Y';
//          l_epos = %scan(':' :in_string :l_epos+1);
//          if l_epos <> 0;
//             inquote(in_string :l_epos :l_inquote);
//          else;
//             l_inquote = 'N';
//          endif;
//       enddo;
//    endif;
//
//    dow l_Spos < l_Epos;
//       if l_Spos <> 0;
//          findcbr(l_Spos :in_string);
//          l_pos = l_Spos;
//          if l_pos < l_Epos;
//             l_Spos = %scan('(' :in_string :l_pos+1);
//             if l_Spos <> 0;
//                inquote(in_string :l_Spos :l_inquote);
//                dow l_inquote = 'Y';
//                   l_Spos = %scan('(' :in_string :l_Spos+1);
//                   if l_Spos <> 0;
//                      inquote(in_string :l_Spos :l_inquote);
//                   else;
//                      l_inquote = 'N';
//                   endif;
//                enddo;
//             endif;
//          elseif l_pos > l_Epos;
//             l_Epos = %scan(':' :in_string :l_pos+1);
//             if l_epos <> 0;
//                inquote(in_string :l_epos :l_inquote);
//                dow l_inquote = 'Y';
//                   l_epos = %scan(':' :in_string :l_epos+1);
//                   if l_epos <> 0;
//                      inquote(in_string :l_epos :l_inquote);
//                   else;
//                      l_inquote = 'N';
//                   endif;
//                enddo;
//             endif;
//
//             l_Spos = %scan('(' :in_string :l_pos+1);
//             if l_Spos <> 0;
//                inquote(in_string :l_Spos :l_inquote);
//                dow l_inquote = 'Y';
//                   l_epos = %scan('(' :in_string :l_Spos+1);
//                   if l_Spos <> 0;
//                      inquote(in_string :l_Spos :l_inquote);
//                   else;
//                      l_inquote = 'N';
//                   endif;
//                enddo;
//             endif;
//          endif;
//       else;
//          l_Spos = l_Epos + 1;
//       endif;
//    enddo;
//
//    lk_refact1 = %subst(in_string :start+1 :l_Epos-start-1);
//    start      = l_Epos;
//    l_Spos     = %scan('(' :in_string :l_Epos+1);
//    if l_Spos <> 0;
//       inquote(in_string :l_Spos :l_inquote);
//       dow l_inquote = 'Y';
//          l_Spos = %scan('(' :in_string :l_Spos+1);
//          if l_Spos <> 0;
//             inquote(in_string :l_Spos :l_inquote);
//          else;
//             l_inquote = 'N';
//          endif;
//       enddo;
//    endif;
//
//    l_Epos = %scan(':' :in_string :l_Epos+1);
//    if l_epos <> 0;
//       inquote(in_string :l_epos :l_inquote);
//       dow l_inquote = 'Y';
//          l_epos = %scan(':' :in_string :l_epos+1);
//          if l_epos <> 0;
//             inquote(in_string :l_epos :l_inquote);
//          else;
//             l_inquote = 'N';
//          endif;
//       enddo;
//    endif;
//
//    dow l_Spos < l_Epos;
//       if l_Spos <> 0;
//          findcbr(l_Spos :in_string);
//          l_pos = l_Spos;
//          if l_pos < l_Epos;
//             l_Spos = %scan('(' :in_string :l_pos+1);
//             if l_Spos <> 0;
//                inquote(in_string :l_Spos :l_inquote);
//                dow l_inquote = 'Y';
//                   l_Spos = %scan('(' :in_string :l_Spos+1);
//                   if l_Spos <> 0;
//                      inquote(in_string :l_Spos :l_inquote);
//                   else;
//                      l_inquote = 'N';
//                   endif;
//                enddo;
//             endif;
//          elseif l_pos > l_Epos;
//             l_Epos = %scan(':' :in_string :l_pos+1);
//             if l_epos <> 0;
//                inquote(in_string :l_epos :l_inquote);
//                dow l_inquote = 'Y';
//                   l_epos = %scan(':' :in_string :l_epos+1);
//                   if l_epos <> 0;
//                      inquote(in_string :l_epos :l_inquote);
//                   else;
//                      l_inquote = 'N';
//                   endif;
//                enddo;
//             endif;
//
//             l_Spos = %scan('(' :in_string :l_pos+1);
//             if l_Spos <> 0;
//                inquote(in_string :l_Spos :l_inquote);
//                dow l_inquote = 'Y';
//                   l_epos = %scan('(' :in_string :l_Spos+1);
//                   if l_Spos <> 0;
//                      inquote(in_string :l_Spos :l_inquote);
//                   else;
//                      l_inquote = 'N';
//                   endif;
//                enddo;
//             endif;
//          endif;
//       else;
//          l_Spos = l_Epos + 1;
//       endif;
//    enddo;
//
//    if l_Epos <> 0;
//       lk_refact2 = %subst(in_string :start+1 :l_Epos-start-1);
//    else;
//       l_Epos = ProcessScanr(')':in_String:start+1);
//       if l_epos <> 0;
//          inquote(in_string :l_epos :l_inquote);
//          dow l_inquote = 'Y';
//             l_epos = %scan(')' :in_string :l_epos+1);
//             if l_epos <> 0;
//                inquote(in_string :l_epos :l_inquote);
//             else;
//                l_inquote = 'N';
//             endif;
//          enddo;
//       endif;
//
//       lk_refact2 = %subst(in_string :start+1 :l_Epos-start-1);
//    endif;

      lk_refact1 = RMVbrackets(lk_refact1);
      lk_refact2 = RMVbrackets(lk_refact2);
      if lk_refact1 <> *Blanks;
         In_string1 = lk_refact1;
         split_component_5(In_string1 :arr : arrOpr :i);
      Else;
         return;
      Endif;
      i += 1;
      lk_reseq = in_seq;
      for j = 1 to i-1;
         if j <= %elem(arr) and arr(j) <> *Blanks;
            arr_var = %trim(arr(j));
            if arr(j) <> *blanks;                                                           //MT05
               l_Epos = %scan('%'  : arr_var);
               l_Spos = %scan('''' : arr_var);
               if l_Spos = 0;
                  l_Spos = %scan('"' : arr_var);
               endif;
            endif;                                                                          //MT05

            lk_recomp = arrOpr(j);

            Clear Ik_refact2;
            select;
            when l_Spos <> 0 and l_Spos < l_Epos  and arr(j) <> *blanks;                     //MT05
               Ik_refact1 = 'CONST(' + %trim(arr(j)) + ')';

               if i = 2;
                  leave;
               endif;

               lk_reseq += 1;
               lk_recontin = 'AND';

               iavarrellog(in_srclib    :
                           in_srcspf    :
                           in_srcmbr    :
                           in_ifsloc    :                                                //0005
                           lk_reseq     :
                           in_rrn       :
                           lk_reroutine :
                           lk_rereltyp  :
                           lk_rerelnum  :
                           lk_reopc     :
                           lk_reresult  :
                           lk_rebif     :
                           ik_refact1   :
                           lk_recomp    :
                           ik_refact2   :
                           lk_recontin  :
                           lk_reresind  :
                           lk_recat1    :
                           lk_recat2    :
                           lk_recat3    :
                           lk_recat4    :
                           lk_recat5    :
                           lk_recat6    :
                           lk_reutil    :
                           lk_renum1    :
                           lk_renum2    :
                           lk_renum3    :
                           lk_renum4    :
                           lk_renum5    :
                           lk_renum6    :
                           lk_renum7    :
                           lk_renum8    :
                           lk_renum9    :
                           lk_reexc     :
                           lk_reinc );

            when l_Epos <> 0 and (l_Spos > l_Epos or l_Spos = 0)                            //MT05
                   and arr(j) <> *blanks;
               l_pos      = %scan('(' :arr(j) :l_Epos);
             //if l_pos <> 0;
               if (l_pos-l_Epos) > 0;
                  lk_rebif   = %subst(arr(j) :l_Epos :l_pos-l_Epos);
               Else;
                  lk_rebif   = arr(j);
               EndIf;

               If l_Epos > 0;                                                               //MT05
                  string     = '~' + %subst(%trim(arr(j)) :l_Epos);
               endif;                                                                       //MT05

             //callbif(in_srclib  :                                                      //0005
             //        in_srcspf  :                                                      //0005
             //        in_srcmbr  :                                                      //0005
               callbif(in_uWSrcDtl:                                                      //0005
                       In_rrn     :
                       lk_reseq   :
                       l_bkseq    :
                       lk_REOPC   :
                       ik_refact1 :
                       ik_refact2 :
                       in_type    :
                       lk_RECOMP  :
                       lk_reBIF   :
                       flag       :
                       field2     :
                       string     :
                       field4 );

            other;
               if arr(j) <> *blanks;                                                        //MT05
                  select;
                  when l_Spos <> 0;
                     clear lk_rebif;
                     iK_refact1 = 'CONST(' + %trim(arr(j)) + ')';
                  when %check('.0123456789' :%Trim(arr(j))) <> 0;
                     ik_refact1 = %trim(arr(j));
                  other ;
                     clear lk_rebif;
                     ik_refact1 = 'CONST(' + %trim(arr(j)) + ')';
                  endsl;
               endif;                                                                       //MT05

               if i = 2;
                  leave;
               endif;

               If %trim(ik_refact1) = 'CONST()';
               Else;
                  lk_reseq += 1;
                  lk_recontin = 'AND';
                  iavarrellog(in_srclib    :
                              in_srcspf    :
                              in_srcmbr    :
                              in_ifsloc    :                                             //0005
                              lk_reseq     :
                              in_rrn       :
                              lk_reroutine :
                              lk_rereltyp  :
                              lk_rerelnum  :
                              lk_reopc     :
                              lk_reresult  :
                              lk_rebif     :
                              ik_refact1   :
                              lk_recomp    :
                              ik_refact2   :
                              lk_recontin  :
                              lk_reresind  :
                              lk_recat1    :
                              lk_recat2    :
                              lk_recat3    :
                              lk_recat4    :
                              lk_recat5    :
                              lk_recat6    :
                              lk_reutil    :
                              lk_renum1    :
                              lk_renum2    :
                              lk_renum3    :
                              lk_renum4    :
                              lk_renum5    :
                              lk_renum6    :
                              lk_renum7    :
                              lk_renum8    :
                              lk_renum9    :
                              lk_reexc     :
                              lk_reinc );
               Endif;

            endsl;
            Clear Ik_Refact1;
         endif;
      endfor;

      lk_refact1 = Ik_refact1;

      if lk_refact2 <> *Blanks;
         In_string1 = lk_refact2;
         split_component_5(In_string1 :arr : arrOpr :i);
      Else;
         return;
      Endif;
      i += 1;

      for j = 1 to i-1;
         if j <= %elem(arr) and arr(j) <> *Blanks;
            arr_var = %trim(arr(j));
            l_Epos    = %scan('%'  : arr_var);
            l_Spos    = %scan('''' : arr_var);
            if l_Spos = 0;
               l_Spos = %scan('"' : arr_var);
            endif;

            lk_recomp = arrOpr(j);

            Clear Ik_refact1;
            select;
            when l_Spos <> 0 and l_Spos < l_Epos;
               Ik_refact2 = 'CONST(' + %trim(arr(j)) + ')';

               if i = 2;
                  leave;
               endif;

               lk_reseq += 1;
               lk_recontin = 'AND';
               clear lk_rebif;

               iavarrellog(in_srclib    :
                           in_srcspf    :
                           in_srcmbr    :
                           in_ifsloc    :                                                //0005
                           lk_reseq     :
                           in_rrn       :
                           lk_reroutine :
                           lk_rereltyp  :
                           lk_rerelnum  :
                           lk_reopc     :
                           lk_reresult  :
                           lk_rebif     :
                           ik_refact1   :
                           lk_recomp    :
                           ik_refact2   :
                           lk_recontin  :
                           lk_reresind  :
                           lk_recat1    :
                           lk_recat2    :
                           lk_recat3    :
                           lk_recat4    :
                           lk_recat5    :
                           lk_recat6    :
                           lk_reutil    :
                           lk_renum1    :
                           lk_renum2    :
                           lk_renum3    :
                           lk_renum4    :
                           lk_renum5    :
                           lk_renum6    :
                           lk_renum7    :
                           lk_renum8    :
                           lk_renum9    :
                           lk_reexc     :
                           lk_reinc );

            when l_Epos <> 0 and (l_Spos > l_Epos or l_Spos = 0);
               l_pos      = %scan('(' :arr(j) :l_Epos);
             //If l_pos <> 0;
               If (l_pos-l_Epos) > 0;
                  lk_rebif = %subst(arr(j) :l_Epos :l_pos-l_Epos);
               Else;
                  lk_rebif = arr(j);
               EndIf;
               if l_Epos > 0;                                                            //MT05
                  string = '~' + %subst(%trim(arr(j)) :l_Epos);
               endif;                                                                    //MT05

             //callbif(in_srclib  :                                                      //0005
             //        in_srcspf  :                                                      //0005
             //        in_srcmbr  :                                                      //0005
               callbif(in_uWSrcDtl:                                                      //0005
                       In_rrn     :
                       lk_reseq   :
                       l_bkseq    :
                       lk_REOPC   :
                       ik_refact1 :
                       ik_refact2 :
                       in_type    :
                       lk_RECOMP  :
                       lk_reBIF   :
                       flag       :
                       field2     :
                       string     :
                       field4 );

            other;
               select;
               when l_Spos <> 0;
                  clear lk_rebif;
                  iK_refact2 = 'CONST(' + %trim(arr(j)) + ')';
               when %check('.0123456789' :%Trim(arr(j))) <> 0;
                  ik_refact2 = %trim(arr(j));
               other ;
                  clear lk_rebif;
                  ik_refact2 = 'CONST(' + %trim(arr(j)) + ')';
               endsl;

               if i = 2;
                  leave;
               endif;

               If %trim(ik_refact2) = 'CONST()';
               Else;
                  lk_reseq += 1;
                  lk_recontin = 'AND';
                  iavarrellog(in_srclib    :
                              in_srcspf    :
                              in_srcmbr    :
                              in_ifsloc    :                                             //0005
                              lk_reseq     :
                              in_rrn       :
                              lk_reroutine :
                              lk_rereltyp  :
                              lk_rerelnum  :
                              lk_reopc     :
                              lk_reresult  :
                              lk_rebif     :
                              ik_refact1   :
                              lk_recomp    :
                              ik_refact2   :
                              lk_recontin  :
                              lk_reresind  :
                              lk_recat1    :
                              lk_recat2    :
                              lk_recat3    :
                              lk_recat4    :
                              lk_recat5    :
                              lk_recat6    :
                              lk_reutil    :
                              lk_renum1    :
                              lk_renum2    :
                              lk_renum3    :
                              lk_renum4    :
                              lk_renum5    :
                              lk_renum6    :
                              lk_renum7    :
                              lk_renum8    :
                              lk_renum9    :
                              lk_reexc     :
                              lk_reinc );
               Endif;
            endsl;
            Clear Ik_refact2;

         endif;                                                                         //MT05
      endfor;
      Ik_refact1 = lk_refact1;
      in_seq     = lk_reseq;
   endif;

   return;

end-proc;

//---------------------------------------------------------------------------- //
//IaPsrXfFr :
//---------------------------------------------------------------------------- //
dcl-proc IAPSRXFFR Export;
   dcl-pi IAPSRXFFR;
      in_string  char(5000);
      in_opcode  char(10);
      in_type    char(10);
  //  in_srclib  char(10);                                                               //0005
  //  in_srcspf  char(10);                                                               //0005
  //  in_srcmbr  char(10);                                                               //0005
      in_uWSrcDtl likeds(uWSrcDtl);                                                      //0005
      in_RRNs    packed(6:0);
      in_factor1 char(80);
      in_factor2 char(80);
      in_Seq     packed(6:0);
   End-Pi;

   dcl-s XF_subsetVars          char(600)     inz dim(600);                              //MT03
   dcl-s XF_operatorArr         char(1)       inz dim(600);                              //MT03
   dcl-s XF_opcode_used         char(10)      inz;
   dcl-s XF_BIF                 char(10)      inz;
   dcl-s XF_passBIF             char(10)      inz;
   dcl-s XF_passFactor1         char(80)      inz;
   dcl-s XF_passFactor2         char(80)      inz;
   dcl-s XF_Result              char(50)      inz;
   dcl-s XF_source              char(80)      inz;
   dcl-s XF_source1             char(80)      inz;
   dcl-s XF_source2             char(80)      inz;
   dcl-s XF_RoutineNm           char(80)      inz;
   dcl-s XF_Continuation        char(10)      inz;
   dcl-s XF_operator            char(10)      inz;
   dcl-s xf_flag                char(10)      inz;
   dcl-s field2                 char(500)     inz;
   dcl-s field4                 char(5000)    inz;
   dcl-s XF_String              char(5000)    inz;
   dcl-s XF_workingValue        char(2000)    inz;
   dcl-s XF_ReturnString        char(5000)    inz;
   dcl-s XF_tempVar             char(200)     inz;
   dcl-s XF_Holder              char(1)       inz;
   dcl-s XF_Target              char(50)      inz;
   dcl-s parm7                  char(10)      inz;
   dcl-s parm8                  char(10)      inz;
   dcl-s parm14                 char(10)      inz;
   dcl-s parm15                 char(06)      inz;
   dcl-s parm16                 char(1)       inz;
   dcl-s parm17                 char(1)       inz;
   dcl-s parm18                 char(1)       inz;
   dcl-s parm19                 char(1)       inz;
   dcl-s parm20                 char(1)       inz;
   dcl-s parm32                 char(1)       inz;
   dcl-s parm33                 char(1)       inz;
   dcl-s TempBlanks             char(80)      inz;
   dcl-s parm21                 char(1)       inz;
   dcl-s parm22                 char(10)      inz;
   dcl-s XF_passTarget          char(50)      inz;
   dcl-s XF_CompOperator        char(10)      inz;
   dcl-s XF_passoperator        char(10)      inz;
   dcl-s XF_Opcode              char(10)      inz;
   dcl-s XF_fromVar             char(14)      inz;
   dcl-s XF_toVar               char(14)      inz;
   dcl-s XF_Factor1             varchar(5000) inz;
   dcl-s XF_Factor2             varchar(5000) inz;
   dcl-s in_string1             varchar(5000) inz;
   dcl-s XF_tempArray           packed(5)     inz dim(600);                              //MT03
   dcl-s XF_arrayaddsign        packed(5)     inz dim(600);                              //MT03
   dcl-s XF_arraySubsign        packed(5)     inz dim(600);                              //MT03
   dcl-s XF_arrayMulsign        packed(5)     inz dim(600);                              //MT03
   dcl-s XF_arrayDivsign        packed(5)     inz dim(600);                              //MT03
   dcl-s XF_arraysignpositions  packed(5)     inz dim(600) ascend;                       //MT03
   dcl-s XF_userVarSeparator    packed(5)     inz;
   dcl-s XF_bracketPos          packed(4:0)   inz;
   dcl-s XF_BRACKETCPOS         packed(4:0)   inz;
   dcl-s XF_startPos            packed(5)     inz;
   dcl-s XF_endBracketPos       packed(5)     inz;
   dcl-s XF_dotPos              packed(5)     inz;
   dcl-s XF_fromPos             packed(5)     inz;
   dcl-s XF_bkseq               packed(6:0)   inz;
   dcl-s XF_reseq               packed(6:0)   inz;
   dcl-s XF_nextdotpos          packed(5)     inz;
   dcl-s XF_opcodeStartPos      packed(5)     inz;
   dcl-s XF_intermediateAddPos  packed(5)     inz;
   dcl-s XF_intermediateSubPos  packed(5)     inz;
   dcl-s XF_intermediateMulPos  packed(5)     inz;
   dcl-s XF_intermediateDivPos  packed(5)     inz;
   dcl-s XF_VardotPos           packed(5)     inz;
   dcl-s XF_VarBracketPos       packed(5)     inz;
   dcl-s XF_VarEndBracketPos    packed(5)     inz;
   dcl-s XF_passBracketPos      packed(5)     inz;
   dcl-s XF_tempPos             packed(5)     inz;
   dcl-s xf_seq                 packed(6:0)   inz;
   dcl-s parm5                  packed(6:0)   inz;
   dcl-s parm23                 packed(5:0)   inz;
   dcl-s parm24                 packed(5:0)   inz;
   dcl-s parm25                 packed(5:0)   inz;
   dcl-s parm26                 packed(5:0)   inz;
   dcl-s parm27                 packed(5:0)   inz;
   dcl-s parm28                 packed(5:0)   inz;
   dcl-s parm29                 packed(5:0)   inz;
   dcl-s parm30                 packed(5:0)   inz;
   dcl-s parm31                 packed(5:0)   inz;
   dcl-s k                      packed(4:0)   inz;
   dcl-s j                      packed(4:0)   inz;
   dcl-s XF_i                   int(5)        inz;
   dcl-s XF_j                   int(5)        inz;
   dcl-s XF_k                   int(5)        inz;
   dcl-s XF_l                   int(5)        inz;
   dcl-s XF_z                   int(5)        inz;
   dcl-s XF_x                   int(5)        inz;
   dcl-s XF_loop                int(5)        inz;
   dcl-s XF_index               int(5)        inz;
   dcl-s XF_itr                 int(5)        inz;
   dcl-s XF_ndx                 int(5)        inz;
   dcl-s XF_pos                 int(5)        inz;
   dcl-s XF_Ctr                 int(5)        inz;
   dcl-s XF_BracketCount        int(5)        inz;
   dcl-s XF_opCodePresent       ind           inz('0');
   dcl-s XF_keeplooping         ind           inz('1');

   if in_string = *Blanks;
      return;
   endif;
   uwsrcdtl = In_uwsrcdtl;                                                               //0005
   xf_reseq = in_seq;
   parm5    = in_rrns;
   XF_BIF   = '%XFOOT';

   //------------------- Pick position for ~ and reformat input code --- //
   XF_String   = in_string;
   XF_startPos = %scan('~' : XF_String);
   Exec sql set :XF_String = replace(:XF_String, '~', '');
   if XF_startPos > 0;                                                                   //MT05
      XF_bracketPos  = %scan('(' : XF_String: XF_startPos);
   endif;                                                                                //MT05
   If XF_bracketPos > 0;                                                                //VP01
      XF_bracketcpos = GetCBPos(xf_String : XF_bracketPos);
   EndIf;                                                                               //VP01
   If (XF_bracketcpos-XF_bracketPos-1) > 0;                                              //MT05
      XF_Factor1     = %subst(xf_String :XF_bracketPos + 1
                                :XF_bracketcpos-XF_bracketPos-1);
   endif;                                                                                //MT05

   if XF_Factor1 <> *blanks;                                                             //MT05
      In_string1 =  %trim(XF_Factor1) ;
   endif;                                                                                //MT05
   split_component_5(in_String1:XF_subsetVars:XF_operatorArr:k);

   for j = 1 to k;
      if j <= %elem(XF_subsetVars) and XF_subsetVars(j) <> *Blanks;
         XF_tempPos        = %scan('%' : XF_subsetVars(j));
         XF_passBracketPos = %scan('(' : XF_subsetVars(j));
         XF_operator       =  XF_operatorArr(j);
         clear in_factor2;
         Select;
         when XF_tempPos <> 0 ;
            XF_passBracketPos = %scan('(' : XF_subsetVars(j));
          //if XF_passBracketPos <> 0;
            if XF_passBracketPos > 1;
               XF_passBIF = %subst(%trim(XF_subsetVars(j)): 1 :
                                             XF_passBracketPos - 1);
            Else;
               XF_passBIF = XF_subsetVars(j);
            EndIf;
            XF_ReturnString = '~' + %trim(XF_subsetVars(j));

            if XF_passBIF <> ' ';
             //callbif(in_srclib       :                                                 //0005
             //        in_srcspf       :                                                 //0005
             //        in_srcmbr       :                                                 //0005
               callbif(in_uWSrcDtl     :                                                 //0005
                       In_rrns         :
                       xf_reseq        :
                       xf_bkseq        :
                       in_opcode       :
                       in_Factor1      :
                       in_Factor2      :
                       in_type         :
                       XF_operator     :
                       XF_passBIF      :
                       xf_flag         :
                       field2          :
                       XF_ReturnString :
                       field4 );

            endif;
         when XF_tempPos  = 0 ;
            if %scan('"' : XF_subsetVars(j)) > 0 or
               %check('.0123456789' : %trim(XF_subsetVars(j))) = 0;
               in_factor1 = 'CONST(' + %trim(XF_subsetVars(j)) + ')';
            else;
               in_factor1 = XF_subsetVars(j);
            endif;

            If k = 1;
               leave;
            endif;
            clear XF_BIF;

            //-------- add code to update fact1/fact2/opr/contin opr ------ //
            //-------- pass factor1 as blanks here while adding ----------- //
            xf_reseq += 1;                                             // RRN field
            IAVARRELLOG(in_srclib       :
                        in_srcspf       :
                        in_srcmbr       :
                        in_ifsloc       :                                                //0005
                        xf_reseq        :
                        Parm5           :
                        XF_RoutineNm    :
                        parm7           :
                        Parm8           :
                        XF_Opcode       :
                        XF_Target       :
                        XF_BIF          :
                        in_factor1      :
                        XF_operator     :
                        in_Factor2      :
                        XF_Continuation :
                        Parm15          :
                        Parm16          :
                        Parm17          :
                        Parm18          :
                        Parm19          :
                        Parm20          :
                        Parm21          :
                        Parm22          :
                        Parm23          :
                        Parm24          :
                        Parm25          :
                        Parm26          :
                        Parm27          :
                        Parm28          :
                        Parm29          :
                        Parm30          :
                        Parm31          :
                        Parm32          :
                        Parm33 );

         Endsl ;
         clear in_factor1;
      endif;
   endfor ;
   in_seq = Xf_reseq;
   Return;
   //------------------- check if operation extender has been used ----- //
End-proc;

//--------------------------------------------------------------------------- //
//IaPsrCevFx :
//--------------------------------------------------------------------------- //
Dcl-proc IAPSRCEVFX Export;
   dcl-pi IAPSRCEVFX;
      in_string    char(5000);
      in_type      char(10);
      in_error     char(10);
      in_xref      char(10);
  //  in_srclib    char(10);                                                             //0005
  //  in_srcspf    char(10);                                                             //0005
  //  in_srcmbr    char(10);                                                             //0005
      in_uWSrcDtl  likeds(uWSrcDtl);                                                     //0005
      in_RRN       packed(6:0);
      in_rrn_e     packed(6:0);
      in_ErrLogFlg char(1);
   end-pi;

   dcl-s arraysignpositions packed(5)     inz dim(600) ascend;                           //MT03
   dcl-s tempArray          packed(5)     inz dim(600) ascend;                           //MT03
   dcl-s arrayaddsign       packed(5:0)   inz dim(600);                                  //MT03
   dcl-s arraysubsign       packed(5:0)   inz dim(600);                                  //MT03
   dcl-s arraymulsign       packed(5:0)   inz dim(600);                                  //MT03
   dcl-s arraydivsign       packed(5:0)   inz dim(600);                                  //MT03
   dcl-s Ev_pos             packed(2:0)   inz;
   dcl-s Ev_pos1            packed(2:0)   inz;
   dcl-s Ev_pos2            packed(2:0)   inz;
   dcl-s frompos            packed(5:0)   inz;
   dcl-s Ev_seq             packed(6:0)   inz;
   dcl-s Ev_length1         packed(4:0)   inz;
   dcl-s In_postion         packed(5:0)   inz;
   dcl-s Ev_length2         packed(4:0)   inz;
   dcl-s Ev_length          packed(4:0)   inz;
   dcl-s intermediateAddPos packed(5:0)   inz;
   dcl-s intermediateSubPos packed(5:0)   inz;
   dcl-s intermediateMulPos packed(5:0)   inz;
   dcl-s intermediateDivPos packed(5:0)   inz;
   dcl-s OBpos              packed(4:0)   inz;
   dcl-s tr_Counter         packed(4:0)   inz;
   dcl-s ev_bkseq           packed(6:0)   inz;
   dcl-s tr_Length          packed(4:0)   inz;
   dcl-s tr_Brackets        packed(4:0)   inz;
   dcl-s Elementpos         packed(4:0)   inz;
   dcl-s Count              packed(2:0)   inz;
   dcl-s qualfd_dotpos      packed(3:0)   inz;                                           //MT01
   dcl-s operatorArr        char(1)       inz dim(600) ascend;                           //MT03
   dcl-s SUBSETVARS         char(600)     inz dim(600) ascend;                           //MT03
   dcl-s Ev_field1          char(500)     inz;
   dcl-s Ev_field           char(500)     inz;
   dcl-s Ev_type            char(10)      inz;
   dcl-s Ev_field3          char(500)     inz;
   dcl-s Ev_bif             char(10)      inz;
   dcl-s W_SrcFile          char(10)      inz;
   dcl-s In_flag            char(1)       inz;
   dcl-s In_bif             char(10)      inz;
   dcl-s Ev_CONT            char(10)      inz;
   dcl-s Ev_FIELD2          char(500)     inz;
   dcl-s Ev_FIELD4          char(5000)    inz;
   dcl-s Ev_FLAG            char(10)      inz;
   dcl-s CaptureFlg         char(1)       inz;
   dcl-s Ev_constant        char(80)      inz;
   dcl-s Ev_opcode          char(10)      inz;
   dcl-s Ev_factor1         char(80)      inz;
   dcl-s Ev_factor2         char(80)      inz;
   dcl-s In_string1         varchar(5000) inz;
   dcl-s i                  int(5)        inz;
   dcl-s j                  int(5)        inz;
   dcl-s k                  int(5)        inz;
   dcl-s l                  int(5)        inz;
   dcl-s Z                  int(5)        inz;
   dcl-s index              int(5)        inz;
   dcl-s itr                int(5)        inz;
   dcl-s ndx                int(5)        inz;
   dcl-s rdx                int(5)        inz;
   dcl-s Pos                int(5)        inz;
   dcl-s X                  int(5)        inz;

   dcl-c Ch_Quote   '''';
   dcl-c quote      '"';
   dcl-c Quo        '''';
   dcl-c Ev_quot    '''';

   if in_string = *Blanks;
      return;
   endif;
   uwsrcdtl = In_uwsrcdtl;                                                               //0005
   clear IAVARRELDS;
   exec sql values Upper(:in_String) into :in_String;
   Ev_Type  = %subst(in_string:26:10);

   clear ev_seq;
   clear ev_bkseq;
   //SB02 monitor;
      if %trim(Ev_type) = 'EVAL'     or
         %trim(Ev_type) = 'EVAL(H)'  or
         %trim(Ev_type) = 'EVAL(M)'  or
         %trim(Ev_type) = 'EVAL(R)';

         In_postion = %scan('(':%trim(In_string));
         iapquote(in_string:In_postion:In_flag);

         Ev_length  = %len(%trimr(in_string));
         if (Ev_length-35) > 0;                                                          //KM
            Ev_field1  = %subst(in_string:36:Ev_length-35);
         endif ;                                                                         //KM
     //  Ev_length1 = %len(%trim(Ev_field1));
         Ev_length1 = %len(%trim(Ev_field1));
         //Ev_pos1    = %scan('=' : %trim(Ev_field1));                                       //JM01
//Added new logic for Assignment operators                                                  //JM01
         Assignment_Oper(Ev_field1:Ev_length1:Ev_pos1:Ev_field3);                            //JM01

         if Ev_pos1-1 > 0;                                                               //KM
            Ev_field2  = %subst(ev_field1 : 1 :Ev_pos1-1 );
         endif ;                                                                         //KM
         //Ev_field3  = %subst(ev_field1 : ev_pos1+1 :Ev_length1);                           //JM01
         Ev_length2 = %len(%trim(Ev_field3));
         if Ev_field3 <> *blanks;                                                        //PS01
         if  %subst(%trim(Ev_field3):1:1) <> '*';
            In_string1 = %trim(Ev_field3);
            split_component_5(In_string1 :subsetVars :operatorArr:elementpos);
            rdx = 1 ;
            dow subsetVars(rdx) <> *blanks;
               clear Ev_field3;
               Ev_field3 = %trim(subsetVars(rdx));
         //*operatorArr = 'P'--> '**'//
               if operatorArr(rdx) <> 'P';
                  in_RECOMP = operatorArr(rdx);
               else;
                  in_RECOMP = '**';
               endif;
               exsr Sr_factor;
               rdx += 1;
            enddo;
         else;
            exsr varref;
         endif;
         endif;                                                                          //PS01
      endif;
   //SB02 on-error;
      //SB02 in_ErrLogFlg = 'Y';
      //SB02 W_SrcFile    = PSDS.SrcFile;

      //SB02 exec sql
        //SB02 insert into IAEXCPLOG (PRS_SOURCE_LIB,
                               //SB02 PRS_SOURCE_FILE,
                               //SB02 PRS_SOURCE_SRC_MBR,
                               //SB02 LIBRARY_NAME,
                               //SB02 PROGRAM_NAME,
                               //SB02 RRN_NO,
                               //SB02 EXCEPTION_TYPE,
                               //SB02 EXCEPTION_NO,
                               //SB02 EXCEPTION_DATA,
                               //SB02 SOURCE_STM,
                               //SB02 MODULE_PGM,
                               //SB02 MODULE_PROC)
          //SB02 values (trim(:in_srclib),
                  //SB02 trim(:in_srcspf),
                  //SB02 trim(:in_srcmbr),
                  //SB02 trim(:PSDS.Lib),
                  //SB02 trim(:PSDS.ProcNme),
                  //SB02 :in_rrn,
                  //SB02 trim(:PSDS.ExcptTyp),
                  //SB02 trim(:PSDS.ExcptNbr),
                  //SB02 trim(:PSDS.RtvExcptDt),
                  //SB02 trim(:in_string),
                  //SB02 trim(:PSDS.ModulePGM),
                  //SB02 trim(:PSDS.ModuleProc));
      //SB02 if SQLSTATE <> SQL_ALL_OK;
         //log error
      //SB02 endif;
   //SB02 endmon;

   return;

   begsr Sr_Factor;
      clear Ev_pos1;
      Ev_pos1    =    %scan('%' : %trim(Ev_field3));
      CaptureFlg = 'Y';
      if Ev_pos1 <> 0  and CaptureFlg  = 'Y';
         Ev_pos2    = %scan('(' : %trim(Ev_field3));
         if Ev_pos2 = 0;
            Ev_pos2 = %scan(' ' : Ev_field3);
         endif;
         If (Ev_pos2 - Ev_pos1) > 0;                                                          //SJxx
            Ev_bif     = %subst(%trim(ev_field3) : ev_pos1 :Ev_pos2-Ev_pos1);
            Ev_field4  = '~'+%trim(Ev_field3);
            exsr callbif1;
         Else;                                                                                //SJxx
            Clear Ev_bif;                                                                     //SJxx
            Clear Ev_field4;                                                                  //SJxx
         EndIf;                                                                               //SJxx
      else;
         in_RERESULT  =  Ev_field2;
         in_REFACT1   =  Ev_field3;
         in_REOPC     =  Ev_type;
         in_REFACT2   = *blanks;
         exsr varref;
         ev_bkseq     = ev_seq;
      endif;

      if in_RECOMP <> ' ';
         in_RECONTIN = ' ';
      else;
         in_RECOMP = ' ';
         in_RECONTIN = ' ';
      endif;

      exec sql
        update IAVARREL
           set RECOMP   = :in_RECOMP,
               RECONTIN = :in_RECONTIN
         where RESEQ    = :ev_bkseq
           and RERRN    = :in_rrn
           and RESRCLIB = :in_srclib
           and RESRCFLN = :in_srcspf
           and REPGMNM  = :in_srcmbr;
      if SQLSTATE <> SQL_ALL_OK;
         //log error
      endif;

   endsr;

   begsr varref;

      in_RESRCLIB  =  in_srclib;
      in_RESRCFLN  =  in_srcspf;
      in_REPGMNM   =  in_srcmbr;
      Ev_constant  = Ev_field3;
      exsr  Check_constant;
      Ev_field3 = Ev_constant;
      in_RERESULT  =  Ev_field2;
      in_REFACT1   =  Ev_field3;
      in_REOPC     =  Ev_type;
      if ev_seq    = 0;
         in_RESEQ  = 1;
         ev_seq    = in_reseq;
      else;
         in_RECONTIN = 'AND';
         in_RERESULT = *blanks;
         in_REOPC    = *blanks;
         in_reseq    = Ev_seq+1;
         ev_seq      = in_reseq;
      endif;
      in_RERRN  = In_rrn;
      in_RENUM1 = 0;
      in_RENUM2 = 0;
      in_RENUM3 = 0;
      in_RENUM4 = 0;
      in_RENUM5 = 0;
      in_RENUM6 = 0;
      in_RENUM7 = 0;
      in_RENUM8 = 0;
      in_RENUM9 = 0;

      If %scan('Const(' : %trim(in_RERESULT) ) = 0;                                    //MT01
         qualfd_dotpos = %scan('.' : in_RERESULT);
         Dow qualfd_dotpos <> 0 ;                                                      //MT01
            in_RERESULT = %subst(in_RERESULT : %scan('.' :in_RERESULT)+ 1);            //MT01
            qualfd_dotpos = %scan('.' : in_RERESULT: 1);
         Enddo;
         If %scan('(' : in_RERESULT) > 1 and %scan(')' : in_RERESULT) > 0              //MT02 //KM
            and %scan('%' : in_RERESULT) = 0;                                          //MT02
            in_RERESULT = %subst(in_RERESULT : 1 :                                     //MT02
                                       %scan('(' : in_RERESULT) - 1);                  //MT02
         Endif;                                                                        //MT02
      Endif;                                                                           //MT01

      If %scan('Const(' : %trim(in_REFACT1)) =  0;                                     //MT01
         qualfd_dotpos = %scan('.' : in_REFACT1);
         Dow qualfd_dotpos <> 0 ;                                                      //MT01
            in_REFACT1= %subst(in_REFACT1: %scan('.' :in_REFACT1) + 1);                //MT01
            qualfd_dotpos = %scan('.' : in_REFACT1 : 1);
         Enddo;
         If %scan('(' : in_REFACT1)  > 1 and %scan(')' : in_REFACT1)  > 0              //MT02 //KM
            and %scan('%' : in_REFACT1)  = 0;                                          //MT02
            in_REFACT1 =  %subst(in_REFACT1 : 1 :                                      //MT02
                                       %scan('(' : in_REFACT1) - 1);                   //MT02
         Endif;                                                                        //MT02
      Endif;                                                                           //MT01

      If %scan('Const(' : %trim(in_REFACT2)) =  0;                                     //MT01
         qualfd_dotpos = %scan('.' : in_REFACT2);
         Dow qualfd_dotpos <> 0 ;                                                      //MT01
            in_REFACT2= %subst(in_REFACT2: %scan('.' :in_REFACT2) + 1);                //MT01
            qualfd_dotpos = %scan('.' : in_REFACT2 : 1);
         Enddo;
         If %scan('(' : in_REFACT2)  > 1 and %scan(')' : in_REFACT2)  > 0              //MT02 //KM
            and %scan('%' : in_REFACT2)  = 0;                                          //MT02
            in_REFACT2 =  %subst(in_REFACT2 : 1 :                                      //MT02
                                       %scan('(' : in_REFACT2) - 1);                   //MT02
         Endif;                                                                        //MT02
      Endif;                                                                           //MT01

      IAVARRELLOG(in_RESRCLIB  :
                  in_RESRCFLN  :
                  in_REPGMNM   :
                  in_REIFSLOC  :                                                         //0005
                  in_RESEQ     :
                  in_RERRN     :
                  in_REROUTINE :
                  in_RERELTYP  :
                  in_RERELNUM  :
                  in_REOPC     :
                  in_RERESULT  :
                  In_Bif       :
                  in_REFACT1   :
                  in_RECOMP    :
                  in_REFACT2   :
                  in_RECONTIN  :
                  in_RERESIND  :
                  in_RECAT1    :
                  in_RECAT2    :
                  in_RECAT3    :
                  in_RECAT4    :
                  in_RECAT5    :
                  in_RECAT6    :
                  in_REUTIL    :
                  in_RENUM1    :
                  in_RENUM2    :
                  in_RENUM3    :
                  in_RENUM4    :
                  in_RENUM5    :
                  in_RENUM6    :
                  in_RENUM7    :
                  in_RENUM8    :
                  in_RENUM9    :
                  in_REEXC     :
                  in_REINC );

   endsr;

   begsr Check_constant;

      select;
      when %scan('*':%trim(Ev_constant):1) > 0;
         Ev_constant =  'Const(' + %trim(Ev_constant) + ')';
      when %scan(Ch_Quote:%trim(Ev_constant ):1) > 0  or
           %scan(Quote:%trim(Ev_constant ):1) > 0;
         Ev_constant =  'Const(' + %trim(Ev_constant) + ')';
      other;
      endsl;

      if %check('+-/':%trim(Ev_constant):1) = 0;
         Ev_constant =  'Const(' + %trim(Ev_constant) + ')';
      endif;

      if %check('+-.0123456789':%trim(Ev_constant):1) = 0;                               //MT01
         Ev_constant =  'Const(' + %trim(Ev_constant) + ')';
      endif;

   endsr;

   begsr callBif1;

      ev_seq    = ev_bkseq;
      ev_opcode = ev_type;
      In_bif    = Ev_bif;
      in_string = Ev_field4;
      Ev_flag   = *blanks;
      Ev_field4 = *blanks;
      Ev_field2 = Ev_field2;
    //Callbif(in_srclib  :                                                               //0005
    //        in_srcspf  :                                                               //0005
    //        in_srcmbr  :                                                               //0005
      callbif(in_uWSrcDtl:                                                               //0005
              in_rrn     :
              ev_Seq     :
              ev_bkseq   :
              ev_opcode  :
              ev_factor1 :
              ev_factor2 :
              in_type    :
              Ev_CONT    :
              in_bif     :
              Ev_flag    :
              Ev_field2  :
              in_String  :
              Ev_field4 );
   endsr;

end-proc;

//----------------------------------------------------------------------------- //
//IaPsrScn :
//----------------------------------------------------------------------------- //
dcl-proc IAPSRSCN  Export;
   dcl-pi IAPSRSCN;
      In_string  char(5000);
      In_opcode  char(10);
      In_type    char(10);
  //  in_srclib  char(10);                                                               //0005
  //  in_srcspf  char(10);                                                               //0005
  //  in_srcmbr  char(10);                                                               //0005
      in_uWSrcDtl likeds(uWSrcDtl);                                                      //0005
      In_rrn     packed(6:0);
      ik_refact1 char(80);
      ik_refact2 char(80);
      In_seq     packed(6:0);
   end-pi;

   dcl-s arr        char(600)      inz dim(600);                                         //MT03
   dcl-s arrOpr     char(1)        inz dim(600);                                         //MT03
   dcl-s flag       Char(10)       inz;
   dcl-s field2     Char(500)      inz;
   dcl-s String     char(5000)     inz;
   dcl-s field4     Char(5000)     inz;
   dcl-s l_bkfact2  char(80)       inz;
   dcl-s l_bkfact1  char(80)       inz;
   dcl-s l_inquote  char(1)        inz;
   dcl-s In_string1 varchar(5000)  inz;
   dcl-s ChkFactor1 varchar(5000)  inz;                                                    //VK01
   dcl-s lk_refact1 varchar(5000)  inz;
   dcl-s lk_refact2 varchar(5000)  inz;
   dcl-s lk_refact3 varchar(5000)  inz;                                                    //VK01
   dcl-s lk_refact4 varchar(5000)  inz;                                                    //VK01
   dcl-s l_pos      packed(6:0)    inz;
   dcl-s l_Spos     packed(6:0)    inz;
   dcl-s l_Epos     packed(6:0)    inz;
   dcl-s start      packed(6:0)    inz;
   dcl-s i          packed(4:0)    inz(1) ;                                                //VK01
   dcl-s l_bkseq    packed(6:0)    inz;
   dcl-s j          packed(4:0)    inz;
   dcl-s Pos1       packed(6:0)    inz;                                                    //VK01
   dcl-s Pos2       packed(6:0)    inz;                                                    //VK01
   dcl-s BultYN     char(1)        inz('Y');                                               //VK01
   dcl-s AllFctr    char(1)        inz('N');                                               //VK01
   dcl-s refact1_T  char(1)        inz(' ');                                               //VK01
   dcl-s refact2_T  char(1)        inz(' ');                                               //VK01
   dcl-s Fact_Typ   char(1)        inz(' ');                                               //VK01
   dcl-s k          packed(6:0)    inz;
   dcl-s sc_inquote char(1)        inz;
   dcl-s tr_bracket packed(6:0)    inz;
   dcl-s str_len    packed(4:0)    inz;

   if in_string = *Blanks;
      return;
   endif;
   str_len = %len(%trim(in_string));
   in_string = %xlate(LOWER: UPPER: in_string);
   l_pos     = %scan('~' :in_string :1);
   if l_pos > 0;                                                                         //KM
      in_string = %replace('' :in_string :l_pos :1);
   endif ;                                                                               //KM

   in_string = %replace(';' :in_string : str_len+1:1);         //Added to identify end  //VK01
                                                                                           //VK01
   if l_pos > 0;                                                                         //KM
      Pos2   =  %scan('(' :in_string :l_pos) ;                                             //VK01
   endif ;                                                                               //KM
   start     =  Pos2 + 1;                                                                  //VK01
   pos1   = %Scan(':':in_string);                                                          //VK01
   Exsr ChkBultFcn;                                    // Check for built-in function      //VK01
   Dow AllFctr = 'N' ;                                 // Do till all factors sparated     //VK01
     Select ;                                                                              //VK01
      When     j    >  0    ;                          // When factor is bultin function   //VK01
           pos1     =  pos2 ;                                                              //VK01
           Fact_Typ = 'B'   ;                          // Factor type is buil-in Function  //VK01
    //     If j =  1    ;                              // Function having only one factor  //VK01
              tr_bracket = 0;
              if pos1 > 0;                                                               //KM
                 pos2 = %Scan('(': in_string : pos1 );
              endif ;                                                                    //KM
              for k = pos2 to %len(%trimr(in_string));
                 select;
                 when %subst(in_string:k:1) = '(';
                    InQuote(in_string :k :sc_InQuote);
                    if sc_InQuote = 'N';
                       tr_bracket +=1;
                    endif;
                 when %subst(in_string:k:1) = ')';
                    InQuote(in_string :k :sc_InQuote);
                    if sc_InQuote = 'N';
                       tr_bracket -=1;
                       if tr_bracket = 0;
                          l_Epos = k;
                          leave;
                       endif;
                    endif;
                 endsl;
              endfor;
        if l_Epos > start and start > 0 ;                                                  //PS01
           ChkFactor1 = %subst(in_string :start : l_Epos-start+1);                         //VK01
        endif ;                                                                            //PS01
        if l_Epos > 0 ;                                                                    //PS01
           pos1       = %Scan(':':in_string:l_Epos);                                       //VK01
        endif ;                                                                            //PS01
              If pos1 = *zeros ;                                                           //VK01
                 pos1 = l_Epos ;                                                           //VK01
              Endif;                                                                       //VK01
                                                                                           //VK01
      When %len(%trim(in_string)) > 0 and start > 0 And (Pos1-start) > 0 and
           %Scan('"':in_string:start:pos1-start) > 0 ;  //When factor is Constant          //VK01
           BultYN     = 'Y' ;                                                              //VK01
           Dow BultYN = 'Y' ;                                                              //VK01
               pos2 = %Scan(':':in_string:pos1+1);                                         //VK01
               If pos2 = *zeros ;                                                          //VK01
                  l_Epos = pos1 ;                                                          //VK01
                  BultYN = 'N'  ;                                                          //VK01
                  Iter;                                                                    //VK01
               Else;                                                                       //VK01
                 If pos1 > 0 and (pos2-pos1) > 0;                                          //KM
                  If %Scan('"':in_string:pos1:pos2-pos1) = 0 ;                             //VK01
                     BultYN = 'N'  ;                    //Check for the ':' is in qutos    //VK01
                     l_Epos = pos1 ;                                                       //VK01
                     Iter;                                                                 //VK01
                  Endif;                                                                   //VK01
                 endif ;                                                                   //KM
               Endif;                                                                      //VK01
               pos1 = pos2 ;                                                               //VK01
           Enddo;                                                                          //VK01
                                                                                           //VK01
           Fact_Typ   = 'C' ;                           //Factor type is Constatnt         //VK01
           if l_Epos-start > 0 and start > 0 ;                                             //KM
              ChkFactor1 = %subst(in_string :start : l_Epos-start );                       //VK01
           endif ;                                                                         //KM
           ChkFactor1 = %Trim(ChkFactor1) ;                                                //VK01
           %subst(ChkFactor1:1:1) = ' ' ;               //Remove Opening quots             //VK01
           ChkFactor1 = %Trim(ChkFactor1) ;                                                //VK01
           if ChkFactor1 <> *blanks ;                                                      //PJ01
              %subst(ChkFactor1:%len(%trim(ChkFactor1)): 1) = ' ' ; //Remove closing quots //VK01
           endif ;                                                                         //PJ01
                                                                                           //VK01
      Other;                                            //When factor is Variable          //VK01
           l_Epos = pos1   ;                                                               //VK01
           Fact_Typ   = 'V' ;                           //Factor type is Variable          //VK01
           if l_Epos-start > 0 and start > 0 ;                                             //KM
              ChkFactor1 = %subst(in_string :start : l_Epos-start);                        //VK01
           endif ;                                                                         //KM
                                                                                           //VK01
     EndSl;                                                                                //VK01
     Exsr Ev_Factors;                       // Save factors in saparate variables          //VK01
     if i > 3;                                                                             //MT00
       leave;                                                                              //MT00
     endif;                                                                                //MT00
     start = pos1 + 1;                                                                     //VK01
     pos1  = %Scan(':':in_string:start);                                                   //VK01
     If pos1    = *zeros    ;                                                              //VK01
        Exsr    Chk_FactNTyp;                                                              //VK01
     Else;                                                                                 //VK01
     Exsr ChkBultFcn;                                                                      //VK01
     Endif;                                                                                //VK01
     if i > 3;                                                                             //MT00
       leave;                                                                              //MT00
     endif;                                                                                //MT00
   EndDo;                                                                                  //VK01
   i = 0 ;                                                                                 //VK01

      lk_refact1 = RMVbrackets(lk_refact1);
      lk_refact2 = RMVbrackets(lk_refact2);
                                                                                           //VK01
         select ;                                                                          //VK01
             When refact1_T  = 'C' AND refact2_T  = 'V'  ;                                 //VK01
                  lk_refact1 = 'CONST(' + %trim(lk_refact1) + ')';                         //VK01
                  If lk_refact1 <> 'CONST()';                                              //VK01
                     ik_refact1 =  lk_refact1 ;                                            //VK01
                  Else ;                                                                   //VK01
                     ik_refact1 =  *Blanks ;                                               //VK01
                  EndIf;                                                                   //VK01
                  ik_refact2 =  lk_refact2 ;                                               //VK01
                                                                                           //VK01
             When refact1_T  = 'C' AND refact2_T  = 'B'  ;                                 //VK01
                  lk_refact1 = 'CONST(' + %trim(lk_refact1) + ')';                         //VK01
                  If lk_refact1 <> 'CONST()';                                              //VK01
                     ik_refact1 =  lk_refact1 ;                                            //VK01
                  Else ;                                                                   //VK01
                     ik_refact1 =  *Blanks ;                                               //VK01
                  EndIf;                                                                   //VK01
                      Clear    ik_refact2 ;                                                //VK01
                  string     = '~' + %trim(lk_refact2);                                    //VK01
                        Exsr    CallBultFctn ;                                             //VK01
                                                                                           //VK01
             When refact1_T  = 'C' AND refact2_T  = 'C'  ;                                 //VK01
                  lk_refact1 = 'CONST(' + %trim(lk_refact1) + ')';                         //VK01
                  If lk_refact1 <> 'CONST()';                                              //VK01
                     ik_refact1 =  lk_refact1 ;                                            //VK01
                  Else ;                                                                   //VK01
                     ik_refact1 =  *Blanks ;                                               //VK01
                  EndIf;                                                                   //VK01
                                                                                           //VK01
                  lk_refact2 = 'CONST(' + %trim(lk_refact2) + ')';                         //VK01
                  If lk_refact2 <> 'CONST()';                                              //VK01
                     ik_refact2 =  lk_refact2;                                             //VK01
                  Else ;                                                                   //VK01
                     ik_refact2 =  *Blanks ;                                               //VK01
                  EndIf;                                                                   //VK01
                                                                                           //VK01
             When refact1_T  = 'V' AND refact2_T  = 'V'  ;                                 //VK01
                  ik_refact1 =  lk_refact1 ;                                               //VK01
                  ik_refact2 =  lk_refact2 ;                                               //VK01
                                                                                           //VK01
             When refact1_T  = 'V' AND refact2_T  = 'B'  ;                                 //VK01
                  ik_refact1 =  lk_refact1 ;                                               //VK01
                  clear    ik_refact2 ;                                                    //VK01
                  string     = '~' + %trim(lk_refact2);                                    //VK01
                        Exsr    CallBultFctn ;                                             //VK01
                                                                                           //VK01
             When refact1_T  = 'V' AND refact2_T  = 'C'  ;                                 //VK01
                  ik_refact1 =  lk_refact1 ;                                               //VK01
                                                                                           //VK01
                  lk_refact2 = 'CONST(' + %trim(lk_refact2) + ')';                         //VK01
                  If lk_refact2 <> 'CONST()';                                              //VK01
                     ik_refact2 =  lk_refact2 ;                                            //VK01
                  Else ;                                                                   //VK01
                     ik_refact2 =  *Blanks ;                                               //VK01
                  EndIf;                                                                   //VK01
                                                                                           //VK01
             When refact1_T  = 'B' AND refact2_T  = 'V'  ;                                 //VK01
                  clear    ik_refact1 ;                                                    //VK01
                  ik_refact2 =  lk_refact2 ;                                               //VK01
                  string     = '~' + %trim(lk_refact1);                                    //VK01
                        Exsr    CallBultFctn ;                                             //VK01
                                                                                           //VK01
             When refact1_T  = 'B' AND refact2_T  = 'B'  ;                                 //VK01
                  clear    ik_refact1 ;                                                    //VK01
                  clear    ik_refact2 ;                                                    //VK01
                  string     = '~' + %trim(lk_refact1);                                    //VK01
                        Exsr    CallBultFctn ;                                             //VK01
                  string     = '~' + %trim(lk_refact2);                                    //VK01
                        Exsr    CallBultFctn ;                                             //VK01
                                                                                           //VK01
             When refact1_T  = 'B' AND refact2_T  = 'C'  ;                                 //VK01
                      Clear    ik_refact1 ;                                                //VK01
                      string = '~' + %trim(lk_refact1);                                    //VK01
                        Exsr   CallBultFctn ;                                              //VK01
                                                                                           //VK01
                  lk_refact2 = 'CONST(' + %trim(lk_refact2) + ')';                         //VK01
                  If lk_refact2 <> 'CONST()';                                              //VK01
                     ik_refact2 =  lk_refact2 ;                                            //VK01
                  Else ;                                                                   //VK01
                     ik_refact2 =  *Blanks ;                                               //VK01
                  EndIf;                                                                   //VK01
                                                                                           //VK01
         EndSl ;                                                                           //VK01

   return;
   //--------------------------------------------------------------------------------------//VK01
   // This subrutine used to process last factor of function                               //VK01
   //--------------------------------------------------------------------------------------//VK01
   begsr Chk_FactNTyp;                                                                     //VK01
                                                                                           //VK01
         AllFctr    = 'Y'    ;                                                             //VK01
         If start > 0;                                                                  //VP01
            pos2 = %Scan(';':in_string:start) ;           // End of functn                 //VK01
         EndIf;                                                                         //VP01
         if (pos2-start) > 0 and start > 0 ;                                               //KM
            ChkFactor1 = %subst(in_string :start : pos2-start);                            //VK01
         endif;                                                                            //KM
         ChkFactor1 = %Trim(ChkFactor1) ;                                                  //VK01
         If ChkFactor1 <> *blanks ;                                                        //SS02
            %subst(ChkFactor1:%len(%trim(ChkFactor1)):1) = ' '; // Remove ')' of funtn     //VK01
         Endif;                                                                            //SS02
                                                                                           //VK01
         pos2       = %Scan('"':ChkFactor1) ;                                              //VK01
         if pos2    <> *Zeros ;                              // Find type of factor        //VK01
            ChkFactor1 = %Trim(ChkFactor1) ;                                               //VK01
            %subst(ChkFactor1:1:1) = ' ' ;                                                 //VK01
            ChkFactor1 = %Trim(ChkFactor1) ;                                               //VK01
            If ChkFactor1 <> *blanks ;                                                     //PJ01
               %subst(ChkFactor1:%len(%trim(ChkFactor1)): 1) = ' ' ;                       //VK01
            endif ;                                                                        //PJ01
            Fact_Typ   = 'C' ;                                                             //VK01
         Else;                                                                             //VK01
            Fact_Typ   = 'V' ;                                                             //VK01
         EndIf;                                                                            //VK01
                                                                                           //VK01
         Exsr Ev_Factors;                                                                  //VK01
                                                                                           //VK01
   endsr;                                                                                  //VK01
   //--------------------------------------------------------------------------------------//VK01
   begsr CallBultFctn ;                                                                    //VK01
                                                                                           //VK01
         lk_RECOMP = 'AND';                                                                //VK01
         lk_reseq  +=  1;                                                                  //VK01
         l_bkfact1 = *Blanks;                                                              //VK01
         l_bkfact2 = *Blanks;                                                              //VK01
         if %Scan('(':string)-2  > 0;                                                      //KM
            lk_reBIF  = %Subst(string : 2 :%Scan('(':string)-2);  // saparate built-in fn  //VK01
         endif ;                                                                           //KM
                                                                                           //VK01
       //Callbif(in_srclib  :                                                            //VK01 0005
       //        in_srcspf  :                                                            //VK01 0005
       //        in_srcmbr  :                                                            //VK01 0005
         callbif(in_uWSrcDtl:                                                            //0005
                 In_rrn     :                                                              //VK01
                 lk_reseq   :                                                              //VK01
                 l_bkseq    :                                                              //VK01
                 lk_REOPC   :                                                              //VK01
                 l_bkfact1  :                                                              //VK01
                 l_bkfact2  :                                                              //VK01
                 in_type    :                                                              //VK01
                 lk_RECOMP  :                                                              //VK01
                 lk_reBIF   :                                                              //VK01
                 flag       :                                                              //VK01
                 field2     :                                                              //VK01
                 string     :                                                              //VK01
                 field4 );                                                                 //VK01
                                                                                           //VK01
   endsr;                                                                                  //VK01
   //--------------------------------------------------------------------------------------//VK01
   begsr ChkBultFcn;                                                                       //VK01
                                                                                           //VK01
        j  =  0  ;                                                                         //VK01
      if (pos1-start-1) > 0 and start > 0 ;                                                //KM
         pos2 = %Scan('%':in_string:start:pos1-start-1) ;                                  //VK01
      endif;                                                                               //KM
                                                                                           //VK01
      If  pos2 - start > 0 and start > 0;                                            //PJ01//VK01
           j   = %Scan('"':in_string:start:pos2-start) ; //Funtn in qoutes or actual funtn //VK01
      EndIf;                                                                               //VK01
                                                                                           //VK01
      If       j    =  0  and  pos2 <> 0 ;                                                 //VK01
                                                                                           //VK01
          // In Funtn subst. if  '(' comes with function replace with blank                //VK01
          l_bkfact2 = %ScanRpl('(':' ':%SubSt(in_string:pos2+1:5)) ;                       //VK01
                                                                                           //VK01
          Select ;                                                                         //VK01
             When l_bkfact2 = 'SCAN'  OR                                                   //VK01
                  l_bkfact2 = 'CHECK' OR                                                   //VK01
                  l_bkfact2 = 'SUBST' ;                                                    //VK01
                  j    = 2  ;               // Function having 2 or more factors           //VK01
                                                                                           //VK01
             When l_bkfact2 = 'TRIM'  OR                                                   //VK01
                  l_bkfact2 = 'TRIML' OR                                                   //VK01
                  l_bkfact2 = 'TRIMR' OR                                                   //VK01
                  l_bkfact2 = 'EDITC' OR                                                   //VK01
                  l_bkfact2 = 'CHAR'  ;                                                    //VK01
                  j    = 1  ;               // Function having only one factor             //VK01
             other;                                                                        //VK01
                  j    = 0  ;                                                              //VK01
          EndSl;                                                                           //VK01
      Else ;                                                                               //VK01
         j    = 0  ;                                                                       //VK01
      EndIf;                                                                               //VK01
   endsr;                                                                                  //VK01
                                                                                           //VK01
   //--------------------------------------------------------------------------------------//VK01
   begsr Ev_Factors;                                                                       //VK01
                                                                                           //VK01
     Select ;                                                                              //VK01
                                                                                           //VK01
       When i = 1 ;                                                                        //VK01
            lk_refact1 = ChkFactor1 ;                                                      //VK01
            refact1_T  = Fact_Typ   ;                                                      //VK01
                                                                                           //VK01
       When i = 2 ;                                                                        //VK01
            lk_refact2 = ChkFactor1 ;                                                      //VK01
            refact2_T  = Fact_Typ   ;                                                      //VK01
                                                                                           //VK01
       When i = 3 ;                                                                        //VK01
            lk_refact3 = ChkFactor1 ;                                                      //VK01
                                                                                           //VK01
       When i = 4 ;                                                                        //VK01
            lk_refact4 = ChkFactor1 ;                                                      //VK01
                                                                                           //VK01
     EndSl;                                                                                //VK01
     i += 1 ;                                                                              //VK01
                                                                                           //VK01
   endsr;                                                                                  //VK01
                                                                                           //VK01
end-proc;

//---------------------------------------------------------------------------- //
//IaPsrLen :
//---------------------------------------------------------------------------- //
dcl-proc IAPSRLEN  Export;
   dcl-pi IAPSRLEN;
      in_string  char(5000);
      in_opcode  char(10);
      in_type    char(10);
  //  in_srclib  char(10);                                                               //0005
  //  in_srcspf  char(10);                                                               //0005
  //  in_srcmbr  char(10);                                                               //0005
      in_uWSrcDtl likeds(uWSrcDtl);                                                      //0005
      in_rrn     packed(6:0);
      In_Factor1 char(80);
      In_Factor2 char(80);
      In_seq     packed(6:0);
   end-pi;

   dcl-s arraysignpositions packed(5)       inz dim(600) ascend;                         //MT03
   dcl-s tempArray          packed(5)       inz dim(600) ascend;                         //MT03
   dcl-s arraysubsign       packed(5:0)     inz dim(600);                                //MT03
   dcl-s arraymulsign       packed(5:0)     inz dim(600);                                //MT03
   dcl-s arraydivsign       packed(5:0)     inz dim(600);                                //MT03
   dcl-s arrayaddsign       packed(5:0)     inz dim(600);                                //MT03
   dcl-s In_postion         packed(5:0)     inz;
   dcl-s Len_pos            packed(2:0)     inz;
   dcl-s Len_pos1           packed(2:0)     inz;
   dcl-s Len_Length         packed(4:0)     inz;
   dcl-s Len_pos2           packed(2:0)     inz;
   dcl-s Len_pos3           packed(2:0)     inz;
   dcl-s Len_pos4           packed(2:0)     inz;
   dcl-s Len_Length1        packed(4:0)     inz;
   dcl-s Len_Length2        packed(4:0)     inz;
   dcl-s Count              packed(2:0)     inz;
   dcl-s Len_bkseq          packed(6:0)     inz;
   dcl-s intermediateAddPos packed(5:0)     inz;
   dcl-s OBpos              packed(4:0)     inz;
   dcl-s tr_Counter         packed(4:0)     inz;
   dcl-s tr_Length          packed(4:0)     inz;
   dcl-s tr_Brackets        packed(4:0)     inz;
   dcl-s intermediateSubPos packed(5:0)     inz;
   dcl-s intermediateMulPos packed(5:0)     inz;
   dcl-s intermediateDivPos packed(5:0)     inz;
   dcl-s j                  packed(4:0)     inz;
   dcl-s frompos            packed(5:0)     inz;
   dcl-s len_OBpos          packed(4:0)     inz;
   dcl-s len_CBpos          packed(4:0)     inz;
   dcl-s elementpos         packed(4:0);
   dcl-s len_bifpos         packed(4:0);
   dcl-s len_SCpos          packed(4:0)     inz;
   dcl-s len_Spos           packed(4:0)     inz;
   dcl-s operatorArr        char(1)         inz dim(600) ascend;                         //MT03
   dcl-s SUBSETVARS         char(600)       inz dim(600) ascend;                         //MT03
   dcl-s In_flag            char(1)         inz;
   dcl-s Len_flag1          char(10)        inz;
   dcl-s Len_String1        char(5000)      inz;
   dcl-s Len_bif            char(10)        inz;
   dcl-s Len_bif1           char(10)        inz;
   dcl-s Len_CONT           char(10)        inz;
   dcl-s Len_Field2         char(500)       inz;
   dcl-s Len_Field4         char(5000)      inz;
   dcl-s Len_Flag           char(10)        inz;
   dcl-s CaptureFlg         char(1)         inz;
   dcl-s Len_opflag         char(1)         inz;
   dcl-s In_bif             char(10)        inz;
   dcl-s len_constant       char(300)       inz;
   dcl-s len_cflag          char(1);
   dcl-s In_string1         varchar(5000);
   dcl-s Len_factor1        varchar(5000)   inz;
   dcl-s Len_factor2        varchar(5000)   inz;
   dcl-s i                  int(5)          inz;
   dcl-s k                  int(5)          inz;
   dcl-s l                  int(5)          inz;
   dcl-s Z                  int(5)          inz;
   dcl-s index              int(5)          inz;
   dcl-s itr                int(5)          inz;
   dcl-s ndx                int(5)          inz;
   dcl-s rdx                int(5)          inz;
   dcl-s Pos                int(5)          inz;
   dcl-s X                  int(5)          inz;
   dcl-s arr_var            char(600)       inz;
   dcl-c quote    '"';
   dcl-c Ch_Quote '''';

   uwsrcdtl = In_uwsrcdtl;                                                               //0005
   if in_string = *Blanks;
      return;
   endif;
   clear IAVARRELDS;

   Len_pos1   = %scan('~' : %trim(In_string));
   Exec sql set :In_String= replace(:In_String, '~', '');
   if Len_pos1 > 0;                                                                      //KM
   Len_OBpos = %scan('(' : %trim(in_String): Len_pos1);
   endif ;                                                                               //KM
   len_SCpos = GetSCPos(in_String : len_OBpos);
   len_CBpos = GetCBPos(in_String : len_OBpos);

   //if len_SCpos <> 0;
   // PS01 if (len_SCpos-len_OBpos) > 1;
   if (len_SCpos-len_OBpos) > 1 and (len_CBpos-len_SCpos-1) > 1;                         //PS01
      len_Factor1 = %subst(in_String :len_OBpos + 1 :len_SCpos-len_OBpos-1);
      len_Factor2 = %subst(in_String :len_SCpos + 1 :len_CBpos-len_SCpos-1);
   else;
      if (len_CBpos-len_OBpos) > 1;                                                      //KM
         len_Factor1 = %subst(in_String :len_OBpos + 1 :len_CBpos-len_OBpos-1);
      endif ;                                                                            //KM
   endif;

   In_string1 =  %trim(len_factor1) ;
   split_component_5(In_string1 :subsetVars :operatorArr:elementpos);

   For j = 1 to Elementpos ;
      if j <= %elem(subsetVars) and subsetVars(j) <> *Blanks;
         arr_var = %trim(subsetVars(j));
         Len_bifpos  = %scan('%' : arr_var) ;
         len_length  = %len(%trim(subsetVars(j)));
         len_Spos    = %scan('''' : arr_var) ;
         if len_Spos = 0;
            len_spos = %scan('"' : arr_var) ;
         endif;
         in_RECOMP   =  operatorArr(j);

         clear in_factor2;
         select;
         when len_Spos <> 0 and len_Spos < len_bifpos;
            in_factor1 =  'CONST(' + %trim(subsetVars(j)) + ')';
            if Elementpos = 1;
               leave;
            endif;
            in_RESRCLIB  =  in_srclib;
            in_RESRCFLN  =  in_srcspf;
            in_REPGMNM   =  in_srcmbr;
            in_REIFSLOC  =  in_ifsloc;                                                   //0005
            in_RERRN  =  In_rrn;
            in_seq+=1 ;
            IAVARRELLOG(in_RESRCLIB   :
                         in_RESRCFLN  :
                         in_REPGMNM   :
                         in_REIFSLOC  :                                                  //0005
                         in_SEQ       :
                         in_RERRN     :
                         in_REROUTINE :
                         in_RERELTYP  :
                         in_RERELNUM  :
                         in_REOPC     :
                         in_RERESULT  :
                         In_Bif       :
                         in_factor1   :
                         in_RECOMP    :
                         in_factor2   :
                         in_RECONTIN  :
                         in_RERESIND  :
                         in_RECAT1    :
                         in_RECAT2    :
                         in_RECAT3    :
                         in_RECAT4    :
                         in_RECAT5    :
                         in_RECAT6    :
                         in_REUTIL    :
                         in_RENUM1    :
                         in_RENUM2    :
                         in_RENUM3    :
                         in_RENUM4    :
                         in_RENUM5    :
                         in_RENUM6    :
                         in_RENUM7    :
                         in_RENUM8    :
                         in_RENUM9    :
                         in_REEXC     :
                         in_REINC );

         when len_bifpos <> 0 and (len_Spos > len_bifpos or len_Spos = 0);
            Len_pos2    = %scan('(' : %trim(subsetVars(j)));
          //If Len_pos2 <> 0;
            If (Len_pos2-Len_bifpos) > 0 and Len_bifpos > 0 ;                               //PS01
               Len_bif1 = %subst(arr_var:Len_bifpos
                                        :Len_pos2-Len_bifpos);
            Else;
               Len_bif1 = arr_var;
            EndIf;
            Len_string1 = '~' + arr_var;
            Len_bif     = %trim(Len_bif1);
          //Callbif(in_srclib   :                                                        //0005
          //        in_srcspf   :                                                        //0005
          //        in_srcmbr   :                                                        //0005
            callbif(in_uWSrcDtl :                                                        //0005
                    in_rrn      :
                    in_Seq      :
                    len_bkseq   :
                    in_opcode   :
                    In_factor1  :
                    In_factor2  :
                    in_type     :
                    in_RECOMP   :
                    Len_bif     :
                    Len_flag    :
                    Len_field2  :
                    len_String1 :
                    Len_field4 );
         other;
            select ;
            when len_Spos <> 0;
               clear In_rebif;
               in_factor1 =  'CONST(' + %trim(subsetVars(j)) + ')';
            when %check('.0123456789' :arr_var ) <> 0;
               in_factor1 = arr_var;
            other ;
               clear In_rebif;
               in_factor1 =  'CONST(' + %trim(subsetVars(j)) + ')';
            endsl;
            if Elementpos  = 1;
               leave;
            endif;

            If %trim(in_factor1) = 'CONST()';
            Else;
               in_RESRCLIB = in_srclib;
               in_RESRCFLN = in_srcspf;
               in_REPGMNM  = in_srcmbr;
               in_REIFSLOC = in_ifsloc;                                                  //0005
               in_RERRN    = In_rrn;
               in_seq      += 1 ;
               IAVARRELLOG(in_RESRCLIB  :
                           in_RESRCFLN  :
                           in_REPGMNM   :
                           in_REIFSLOC  :                                                //0005
                           in_SEQ       :
                           in_RERRN     :
                           in_REROUTINE :
                           in_RERELTYP  :
                           in_RERELNUM  :
                           in_REOPC     :
                           in_RERESULT  :
                           In_Bif       :
                           in_factor1   :
                           in_RECOMP    :
                           in_factor2   :
                           in_RECONTIN  :
                           in_RERESIND  :
                           in_RECAT1    :
                           in_RECAT2    :
                           in_RECAT3    :
                           in_RECAT4    :
                           in_RECAT5    :
                           in_RECAT6    :
                           in_REUTIL    :
                           in_RENUM1    :
                           in_RENUM2    :
                           in_RENUM3    :
                           in_RENUM4    :
                           in_RENUM5    :
                           in_RENUM6    :
                           in_RENUM7    :
                           in_RENUM8    :
                           in_RENUM9    :
                           in_REEXC     :
                           in_REINC );
            Endif;
         Endsl;
         clear in_factor1;
     endif;
   Endfor ;

   If %trim(len_factor2) <> *blanks;
      in_factor2 = 'CONST(' + %trim(len_factor2) + ')';
   Endif;

  return;

end-proc;


//---------------------------------------------------------------------------- //
//IaPsrChk :
//---------------------------------------------------------------------------- //
dcl-proc IAPSRCHK export;
   dcl-pi IAPSRCHK;
      in_string  char(5000);
      in_opcode  char(10);
      in_type    char(10);
  //  in_srclib  char(10);                                                               //0005
  //  in_srcspf  char(10);                                                               //0005
  //  in_srcmbr  char(10);                                                               //0005
      in_uWSrcDtl likeds(uWSrcDtl);                                                      //0005
      in_RRN     packed(6:0);
      in_Factor1 char(80);
      in_Factor2 char(80);
      in_Seq     packed(6:0);
   end-pi;

   //----------------- local variable declaration ------------------ //
   dcl-s   Pos1        packed(4:0)   inz(0);
   dcl-s   Pos2        packed(4:0)   inz(0);
   dcl-s   l_pos       packed(6:0)   inz(0);
   dcl-s   l_Spos      packed(6:0)   inz(0);
   dcl-s   l_Epos      packed(6:0)   inz(0);
   dcl-s   start       packed(6:0)   inz(0);
   dcl-s   i           packed(4:0)   inz(1);                                               //VK01
   dcl-s   j           packed(4:0)   inz(0);
   dcl-s   C_bkseq     packed(6:0)   inz(0);
   dcl-s   ch_bkseq    packed(6:0)   inz;
   dcl-s   flag        Char(10)      inz(' ');
   dcl-s   BIF_flag    Char(1)       inz(' ');
   dcl-s   E_flag      Char(1)       inz(' ');
   dcl-s   field2      Char(500)     inz(' ');
   dcl-s   String      char(5000)    inz(' ');
   dcl-s   field4      Char(5000)    inz(' ');
   dcl-s   arr         char(600)     dim(600);                                           //MT03
   dcl-s   arr1       char(80)       dim(600);                                           //AK01
   dcl-s   C_bkfact2   char(80)      inz(' ');
   dcl-s   C_bkfact1   char(80)      inz(' ');
   dcl-s   Chk_MainBIF Char(10)      inz(' ');
   dcl-s   Tmp_Str     char(80)      inz(' ');
   dcl-s   Tmp_Fct2    char(80)      inz(' ');
   dcl-s   ChkFactor1  char(80)      inz(' ');
   dcl-s   ChkFactor2  char(80)      inz(' ');
   dcl-s   ChkFactor3  char(80)      inz(' ');                                             //VK01
   dcl-s   ChkFactor4  char(80)      inz(' ');                                             //VK01
   dcl-s   Chk_BIF     char(10)      inz(' ');
   dcl-s   in_String1  char(80)      inz(' ');
   dcl-s   Tmp_Cst     char(80)      inz(' ');
   dcl-s   BultYN      char(1)      inz('Y');                                              //VK01
   dcl-s   AllFctr     char(1)      inz('N');                                              //VK01
   dcl-s k          packed(6:0)    inz;
   dcl-s sc_inquote char(1)        inz;
   dcl-s tr_bracket packed(6:0)    inz;
   dcl-s   str_len     packed(4:0)   inz;
   dcl-s   arr_var     char(600)     inz;

   dcl-s l_inquote    char(1)       inz;                                                 //SK02

   dcl-c   QUOTE       CONST('''');

   if in_string = *blanks ;                                                              //PJ01
      return ;                                                                           //PJ01
   endif ;                                                                               //PJ01
   uwsrcdtl = In_uwsrcdtl;                                                               //0005
   str_len = %len(%trim(in_string));
   //----------------- Initialisation procedure -------------------- //
   in_string = %xlate(lower :upper :in_string);
   Pos1      = %scan('~' :in_string :1);
   if Pos1 > 0;                                                                            //PS01
      in_string = %replace('' :in_string :Pos1 :1);
   endif;                                                                                  //PS01
   in_string = %replace(';' :in_string : str_len+1:1);            //Added to identify end  //VK01

   if pos1 > 0 ;                                                                           //KM
      Pos2   =  %scan('(' :in_string :Pos1);
   else ;                                                                                  //PJ01
      Pos2   =  %scan('(' :in_string :1) ;                                                 //PJ01
   endif ;                                                                                 //KM
   start     =  Pos2 + 1;                                                                  //VK01
   pos1 = %Scan(':':in_string);                                                            //VK01
   Exsr ChkBultFcn;                                    // Check for built-in function      //VK01
   Dow AllFctr = 'N' ;                                 // Do till all factors sparated     //VK01
     Select ;                                                                              //VK01
      When   j  >  0    ;                              // When factor is bultin function   //VK01
           pos1 =  pos2 ;                                                                  //VK01
     //    If j =  1    ;                              // Function having only one factor  //VK01
              tr_bracket = 0;
              if pos1 > 0;                                                                 //KM
                 pos2 = %Scan('(': in_string : pos1 );
              endif ;                                                                      //KM
              for k = pos2 to str_len;
                 select;
                 when %subst(in_string:k:1) = '(';
                    InQuote(in_string :k :sc_InQuote);
                    if sc_InQuote = 'N';
                       tr_bracket +=1;
                    endif;
                 when %subst(in_string:k:1) = ')';
                    InQuote(in_string :k :sc_InQuote);
                    if sc_InQuote = 'N';
                       tr_bracket -=1;
                       if tr_bracket = 0;
                          l_Epos = k;
                          leave;
                       endif;
                    endif;
                 endsl;
              endfor;
           if start > 0 and l_Epos-start > 0;                                              //PS01
              Tmp_Fct2 = %subst(in_string :start : l_Epos-start+1);                        //VK01
           endif ;                                                                         //PS01
           if l_Epos > 0;                                                                  //KM
              pos1    = %Scan(':':in_string:l_Epos);                                       //VK01
           endif;                                                                          //KM
              If pos1 = *zeros ;                                                           //VK01
                 pos1 = l_Epos ;                                                           //VK01
              Endif;                                                                       //VK01
                                                                                           //VK01
      When start > 0 and pos1-start > 0 and                                                //KM
           %Scan('"':in_string:start:pos1-start) > 0 ;     //When factor is Constant       //VK01
           BultYN     = 'Y' ;                                                              //VK01
           Dow BultYN = 'Y' ;                                                              //VK01
               pos2 = %Scan(':':in_string:pos1+1);                                         //VK01
               If pos2 = *zeros  ;                                                         //VK01
                  l_Epos = pos1  ;                                                         //VK01
                  BultYN = 'N'   ;                                                         //VK01
                  Iter;                                                                    //VK01
               Else;                                                                       //VK01
                 if pos1 > 0 and (pos2 - pos1) > 0;                                        //KM
                  If %Scan('"':in_string:pos1:pos2-pos1) = 0 ;     //Check for the ':' is in qutos
                     BultYN = 'N'  ;                                                       //VK01
                     l_Epos = pos1 ;                                                       //VK01
                     Iter;                                                                 //VK01
                  Endif;                                                                   //VK01
                 endif ;                                                                   //KM
               Endif;                                                                      //VK01
               pos1 = pos2 ;                                                               //VK01
           Enddo;                                                                          //VK01
                                                                                           //VK01
           if start > 0 and l_Epos-start > 0;                                              //PS01
              Tmp_Fct2 = %subst(in_string :start : l_Epos-start);                          //VK01
           endif ;                                                                         //PS01
           Tmp_Fct2 = %Trim(Tmp_Fct2) ;                                                    //VK01
           If Tmp_Fct2 <> *blanks;                                                         //MT05
              %subst(Tmp_Fct2 :1:1) = ' ';                         //Remove Opening quots  //VK01
              Tmp_Fct2 = %Trim(Tmp_Fct2) ;                                                 //VK01
           Endif;                                                                          //MT05
           if Tmp_Fct2 <> *blanks and %len(%trim(Tmp_Fct2)) > 0;                          //PS01
              %subst(Tmp_Fct2:%len(%trim(Tmp_Fct2)):1) = ' ' ;     //Remove closing quots  //VK01
           endif;                                                                          //PS01
                                                                                           //VK01
      Other;                                                    //When factor is Variable  //VK01
           l_Epos = pos1   ;                                                               //VK01
           if start > 0 and (l_Epos-start) > 0;                                            //PS01
              Tmp_Fct2 = %subst(in_string :start : l_Epos-start);                          //VK01
           endif ;                                                                         //PS01
                                                                                           //VK01
     EndSl;                                                                                //VK01
     Exsr Ev_Factors;                              // Save factors in saparate variables   //VK01
     if i > 3;                                                                             //MT05
        leave;                                                                             //MT05
     endif;                                                                                //MT05
     start = pos1 + 1;                                                                     //VK01
     pos1  = %Scan(':':in_string:start);                                                   //VK01
     If pos1    = *zeros    ;                                                              //VK01
        AllFctr = 'Y'    ;                                                                 //VK01
        pos2    = %Scan(';':in_string:start) ;                                             //VK01
        if start > 0 and (pos2 - start) > 0 ;                                              //KM
           Tmp_Fct2 = %subst(in_string :start : pos2-start);                               //VK01
        endif ;                                                                            //KM
        Tmp_Fct2 = %Trim(Tmp_Fct2) ;                                                       //VK01
        if Tmp_Fct2 <> *blanks ;                                                           //PJ01
           %subst(Tmp_Fct2:%len(%trim(Tmp_Fct2)):1) = ' ';                                 //VK01
        endif ;                                                                            //PJ01
        Exsr Ev_Factors;                                                                   //VK01
        if i > 3;                                                                          //MT05
           leave;                                                                          //MT05
        endif;                                                                             //MT05
     Else;                                                                                 //VK01
     Exsr ChkBultFcn;                                                                      //VK01
     Endif;                                                                                //VK01
   EndDo;                                                                                  //VK01
   i = 0;                                                                                  //VK01

   ChkFactor1 = RMVbrackets(ChkFactor1);

   If %Scan(Quote:ChkFactor1) >  0;
      Pos1 = %Scan(Quote:ChkFactor1);
      Pos2 = %Scan(Quote:ChkFactor1:Pos1+1);

      If %Scan('+':ChkFactor1:Pos2+1) > 0;
      // split_component_2(ChkFactor1 :arr :i);
         split_component_2(ChkFactor1 :arr1 :i);                                         //AK01
      Endif;
   Endif;

   Select;
   When %Scan('%':ChkFactor1) > 0 and %Scan(Quote:ChkFactor1) = 0 AND  i= 0;

      Pos1 = %Scan('%':ChkFactor1);
      if Pos1 > 0;                                                                       //PS01
         Pos2 = %Scan('(':ChkFactor1:Pos1);
      endif ;                                                                            //PS01

      // If Pos2 <> 0;
      If Pos1 > 0 and  (Pos2-Pos1) > 0 and ChkFactor1 <> *blanks;                        //PS01
            Chk_Bif = %Subst(ChkFactor1:Pos1:Pos2-Pos1);
      Else;
         Chk_Bif = ChkFactor1 ;
      EndIf;
      if Chk_Bif <> *blanks  and ChkFactor1 <> *blanks;                                  //PJ01
      Pos2 = %Scan(%Trim(Chk_Bif):ChkFactor1);
      endif ;                                                                            //PJ01

      in_String1 = '~' + ChkFactor1;

      Exsr CallBIF1;
      Clear Chk_Bif;
      Clear ChkFactor1;
      Clear in_String1;

   When %Scan(Quote:ChkFactor1) > 0 and %Scan('+':ChkFactor1) = 0;

      Tmp_Cst =  ChkFactor1;
      Clear ChkFactor1;
      ChkFactor1 = 'CONST(' + Tmp_Cst + ')';
   Endsl;

   If %Scan('%':ChkFactor2) > 0;
      Pos1       = %Scan('%':ChkFactor2);
      If Pos1 > 0;                                                                       //MT05
         Pos2       = %Scan('(':ChkFactor2:Pos1);
      endif;                                                                             //MT05
      if Pos1 > 0 and (Pos2-Pos1) > 0;                                                   //KM
         Chk_Bif    = %Subst(ChkFactor2:Pos1:Pos2-Pos1);
      endif ;                                                                            //KM
      if Chk_Bif <> *blanks and ChkFactor2 <> *blanks;                                   //MT05
         Pos2       = %Scan(%Trim(Chk_Bif):ChkFactor2);
      endif;                                                                             //MT05
      in_String1 = '~' + ChkFactor2;

      Exsr CallBIF1;
      Clear Chk_Bif;
      Clear ChkFactor2;
      Clear in_String1;
   Endif;

   If i > 0 and arr(j) <> *blanks;                                                       //MT05
      For j = 1 to i-1;
         if j <= %elem(arr) and arr(j) <> *Blanks;
            arr_var = %trim(arr(j));
            if %scan('(' : arr_var) = 1;
               arr(j) = RMVbrackets(arr(j));
            endif;
            l_Epos = %scan('%'  :arr_var);
            l_Spos = %scan('''' :arr_var);
            if l_Spos = 0;
               l_Spos = %scan('"' :arr_var);
            endif;

            if j < i-1;
               Ch_recomp  = '+';
            else;
               Ch_recomp  = ' ';
            endif;

            select;
            when l_Spos <> 0 and l_Spos < l_Epos;
               Ch_refact1 = 'CONST(' + %trim(arr(j)) + ')';

               if i = 2;
                  leave;
               endif;

               C_bkfact2 = Ch_refact2;
               clear Ch_refact2;

               Ch_reseq += 1;
               Ch_recontin = 'AND';

               iavarrellog(in_srclib    :
                           in_srcspf    :
                           in_srcmbr    :
                           in_ifsloc    :                                                //0005
                           Ch_reseq     :
                           in_rrn       :
                           Ch_reroutine :
                           Ch_rereltyp  :
                           Ch_rerelnum  :
                           Ch_reopc     :
                           Ch_reresult  :
                           Ch_rebif     :
                           Ch_refact1   :
                           Ch_recomp    :
                           Ch_refact2   :
                           Ch_recontin  :
                           Ch_reresind  :
                           Ch_recat1    :
                           Ch_recat2    :
                           Ch_recat3    :
                           Ch_recat4    :
                           Ch_recat5    :
                           Ch_recat6    :
                           Ch_reutil    :
                           Ch_renum1    :
                           Ch_renum2    :
                           Ch_renum3    :
                           Ch_renum4    :
                           Ch_renum5    :
                           Ch_renum6    :
                           Ch_renum7    :
                           Ch_renum8    :
                           Ch_renum9    :
                           Ch_reexc     :
                           Ch_reinc );

               Ch_refact2 = C_bkfact2;
               clear C_bkfact2;
               clear Ch_refact1;

            when l_Epos <> 0 and (l_Spos > l_Epos or l_Spos = 0);

               l_pos = %scan('(' :arr(j) :l_Epos);
            // If l_pos <> 0;                                                               //PJ01
               If l_pos > l_Epos ;                                                          //PJ01
                  Ch_rebif = %subst(arr(j) :l_Epos :l_pos-l_Epos);
               Else;
                  Ch_rebif = arr(j);
               EndIf;
               if l_Epos > 0;                                                               //MT05
                  string     = '~' + %subst(%trim(arr(j)) :l_Epos);
               endif;                                                                       //MT05
               Ch_refact1 = *blanks;

               C_bkfact2  = Ch_refact2;
               clear Ch_refact2;

             //callbif(in_srclib  :                                                      //0005
             //        in_srcspf  :                                                      //0005
             //        in_srcmbr  :                                                      //0005
               callbif(in_uWSrcDtl:                                                      //0005
                       In_rrn     :
                       Ch_reseq   :
                       ch_bkseq   :
                       Ch_REOPC   :
                       Ch_refact1 :
                       Ch_refact2 :
                       in_type    :
                       Ch_RECOMP  :
                       Ch_reBIF   :
                       flag       :
                       field2     :
                       string     :
                       field4 );

               Ch_refact2 = C_bkfact2;
               clear C_bkfact2;

            other;
               if l_Spos <> 0;
                  Ch_refact1 = 'CONST(' + %trim(arr(j)) + ')';
               elseif %check('0123456789' :arr(j)) <> 0;
                  Ch_refact1 = %trim(arr(j));
               else;
                  Ch_refact1 = 'CONST(' + %trim(arr(j)) + ')';
               endif;

               if i = 2;
                  leave;
               endif;

               Ch_reseq += 1;
               Ch_recontin = 'AND';

               C_bkfact2 = Ch_refact2;
               clear Ch_refact2;

               iavarrellog(in_srclib    :
                           in_srcspf    :
                           in_srcmbr    :
                           in_ifsloc    :                                                //0005
                           Ch_reseq     :
                           in_rrn       :
                           Ch_reroutine :
                           Ch_rereltyp  :
                           Ch_rerelnum  :
                           Ch_reopc     :
                           Ch_reresult  :
                           Ch_rebif     :
                           Ch_refact1   :
                           Ch_recomp    :
                           Ch_refact2   :
                           Ch_recontin  :
                           Ch_reresind  :
                           Ch_recat1    :
                           Ch_recat2    :
                           Ch_recat3    :
                           Ch_recat4    :
                           Ch_recat5    :
                           Ch_recat6    :
                           Ch_reutil    :
                           Ch_renum1    :
                           Ch_renum2    :
                           Ch_renum3    :
                           Ch_renum4    :
                           Ch_renum5    :
                           Ch_renum6    :
                           Ch_renum7    :
                           Ch_renum8    :
                           Ch_renum9    :
                           Ch_reexc     :
                           Ch_reinc );
               Ch_refact2 = C_bkfact2;
               clear C_bkfact2;
               clear Ch_refact1;
            endsl;
         endif;

      endfor;

      in_seq = Ch_reseq;

   endif;

   If I = 0;

      If BIF_FLAG = 'Y';
         Ch_Refact1  = ChkFactor1;
         Ch_Refact2  = ChkFactor2;
         Ch_RECONTIN = 'AND';
         iavarrellog(in_srclib    :
                     in_srcspf    :
                     in_srcmbr    :
                     in_ifsloc    :                                                      //0005
                     Ch_reseq     :
                     in_rrn       :
                     Ch_reroutine :
                     Ch_rereltyp  :
                     Ch_rerelnum  :
                     Ch_reopc     :
                     Ch_reresult  :
                     Ch_rebif     :
                     Ch_refact1   :
                     Ch_recomp    :
                     Ch_refact2   :
                     Ch_recontin  :
                     Ch_reresind  :
                     Ch_recat1    :
                     Ch_recat2    :
                     Ch_recat3    :
                     Ch_recat4    :
                     Ch_recat5    :
                     Ch_recat6    :
                     Ch_reutil    :
                     Ch_renum1    :
                     Ch_renum2    :
                     Ch_renum3    :
                     Ch_renum4    :
                     Ch_renum5    :
                     Ch_renum6    :
                     Ch_renum7    :
                     Ch_renum8    :
                     Ch_renum9    :
                     Ch_reexc     :
                     Ch_reinc );
      Else;

      // Ch_Refact1 = ChkFactor1;                                                         //YK01
      // Ch_Refact2 = ChkFactor2;                                                         //YK01
         in_Factor1 = ChkFactor1;                                                         //YK01
         in_Factor2 = ChkFactor2;                                                         //YK01
                                                                                          //YK01
      // iavarrellog(in_srclib:                                                           //YK01
      //             in_srcspf:                                                           //YK01
      //             in_srcmbr:                                                           //YK01
      //             Ch_reseq:                                                            //YK01
      //             in_rrn:                                                              //YK01
      //             Ch_reroutine:                                                        //YK01
      //             Ch_rereltyp:                                                         //YK01
      //             Ch_rerelnum:                                                         //YK01
      //             Ch_reopc:                                                            //YK01
      //             Ch_reresult:                                                         //YK01
      //             Ch_rebif:                                                            //YK01
      //             Ch_refact1:                                                          //YK01
      //             Ch_recomp:                                                           //YK01
      //             Ch_refact2:                                                          //YK01
      //             Ch_recontin:                                                         //YK01
      //             Ch_reresind:                                                         //YK01
      //             Ch_recat1:                                                           //YK01
      //             Ch_recat2:                                                           //YK01
      //             Ch_recat3:                                                           //YK01
      //             Ch_recat4:                                                           //YK01
      //             Ch_recat5:                                                           //YK01
      //             Ch_recat6:                                                           //YK01
      //             Ch_reutil:                                                           //YK01
      //             Ch_renum1:                                                           //YK01
      //             Ch_renum2:                                                           //YK01
      //             Ch_renum3:                                                           //YK01
      //             Ch_renum4:                                                           //YK01
      //             Ch_renum5:                                                           //YK01
      //             Ch_renum6:                                                           //YK01
      //             Ch_renum7:                                                           //YK01
      //             Ch_renum8:                                                           //YK01
      //             Ch_renum9:                                                           //YK01
      //             Ch_reexc:                                                            //YK01
      //             Ch_reinc);                                                           //YK01
      Endif;
   Endif;

   Begsr CallBif1;
      Ch_RECOMP = 'AND';
      string    = in_String1;
      Ch_reseq  +=  1;
      Ch_reBIF  = Chk_Bif;
    //callbif(in_srclib  :                                                               //0005
    //        in_srcspf  :                                                               //0005
    //        in_srcmbr  :                                                               //0005
      callbif(in_uWSrcDtl:                                                               //0005
              In_rrn     :
              Ch_reseq   :
              ch_bkseq   :
              Ch_REOPC   :
              Ch_refact1 :
              Ch_refact2 :
              in_type    :
              Ch_RECOMP  :
              Ch_reBIF   :
              flag       :
              field2     :
              string     :
              field4 );
   Endsr;

   //--------------------------------------------------------------------------------------//VK01
   begsr ChkBultFcn;                                                                       //VK01
                                                                                           //VK01
        j  =  0  ;                                                                         //VK01
      if start > 0 and pos1-start > 1;                                                     //KM
         pos2 = %Scan('%':in_string:start:pos1-start-1) ;                                  //VK01
      endif;                                                                               //KM
                                                                                           //VK01
      If  pos2 > start and start > 0 ;                                               //PJ01//VK01
           j   = %Scan('"':in_string:start:pos2-start) ; //Funtn in qoutes or actual funtn //VK01
      EndIf;                                                                               //VK01
                                                                                           //VK01
      If       j    =  0  and  pos2 <> 0 and in_string <> *blanks;                         //VK01
                                                                                           //VK01
          // In Funtn subst. if  '(' comes with function replace with blank                //VK01
          C_bkfact2 = %ScanRpl('(':' ':%SubSt(in_string:pos2+1:5)) ;                       //VK01
                                                                                           //VK01
          Select ;                                                                         //VK01
             When C_bkfact2 = 'SCAN'  OR                                                   //VK01
                  C_bkfact2 = 'CHECK' OR                                                   //VK01
                  C_bkfact2 = 'SUBST' ;                                                    //VK01
                  j    = 2  ;               // Function having 2 or more factors           //VK01
                                                                                           //VK01
             When C_bkfact2 = 'TRIM'  OR                                                   //VK01
                  C_bkfact2 = 'TRIMR' OR                                                   //VK01
                  C_bkfact2 = 'TRIML' OR                                                   //VK01
                  C_bkfact2 = 'EDITC' OR                                                   //VK01
                  C_bkfact2 = 'CHAR' ;                                                     //VK01
                  j    = 1  ;               // Function having only one factor             //VK01
             other;                                                                        //VK01
                  j    = 0  ;                                                              //VK01
          EndSl;                                                                           //VK01
      Else ;                                                                               //VK01
         j    = 0  ;                                                                       //VK01
      EndIf;                                                                               //VK01
   endsr;                                                                                  //VK01
                                                                                           //VK01
   //--------------------------------------------------------------------------------------//VK01
   begsr Ev_Factors;                                                                       //VK01
                                                                                           //VK01
     Select ;                                                                              //VK01
                                                                                           //VK01
       When i = 1 ;                                                                        //VK01
            ChkFactor1 = Tmp_Fct2 ;                                                        //VK01
                                                                                           //VK01
       When i = 2 ;                                                                        //VK01
            ChkFactor2 = Tmp_Fct2 ;                                                        //VK01
                                                                                           //VK01
       When i = 3 ;                                                                        //VK01
            ChkFactor3 = Tmp_Fct2 ;                                                        //VK01
                                                                                           //VK01
     EndSl;                                                                                //VK01
     i += 1 ;                                                                              //VK01
                                                                                           //VK01
   endsr;                                                                                  //VK01
                                                                                           //VK01
end-proc;

//---------------------------------------------------------------------------- //
//IaTimeBif :
//---------------------------------------------------------------------------- //
dcl-proc IATIMEBIF export;
   dcl-pi IATIMEBIF;
      in_string  char(5000);
      in_opcode  char(10);
      in_type    char(10);
  //  in_srclib  char(10);                                                               //0005
  //  in_srcspf  char(10);                                                               //0005
  //  in_srcmbr  char(10);                                                               //0005
      in_uWSrcDtl likeds(uWSrcDtl);                                                      //0005
      in_RRN     packed(6:0);
      ik_refact1 char(80);
      ik_refact2 char(80);
      in_Seq     packed(6:0);
   end-pi;

   dcl-s posarr     packed(4:0)   inz dim(600);                                          //MT03
   dcl-s old_plus   packed(6:0)   inz(1);
   dcl-s l_pos      packed(6:0)   inz;
   dcl-s l_Sposbk   packed(6:0)   inz;
   dcl-s l_Sposbk1  packed(6:0)   inz;
   dcl-s l_Spos     packed(6:0)   inz;
   dcl-s l_Epos     packed(6:0)   inz;
   dcl-s new_plus   packed(6:0)   inz;
   dcl-s start      packed(6:0)   inz;
   dcl-s l_length   packed(6:0)   inz;
   dcl-s bracket    packed(4:0)   inz;
   dcl-s i          packed(4:0)   inz;
   dcl-s j          packed(4:0)   inz;
   dcl-s k          packed(4:0)   inz;
   dcl-s l_bkseq    packed(6:0)   inz;
   dcl-s arropr     char(1)       inz dim(600);                                          //MT03
   dcl-s arr        char(600)     inz dim(600);                                          //MT03
   dcl-s flag       char(10)      inz;
   dcl-s field2     char(500)     inz;
   dcl-s String     char(5000)    inz;
   dcl-s field4     char(5000)    inz;
   dcl-s l_bkfact2  char(80)      inz;
   dcl-s l_bkfact1  char(80)      inz;
   dcl-s In_string1 varchar(5000) inz;
   dcl-s lk_refact1 varchar(5000) inz;
   dcl-s lk_refact2 varchar(5000) inz;
   dcl-s arr_var    char(600)     inz;

   if in_string = *Blanks;
      return;
   endif;
   uwsrcdtl = In_uwsrcdtl;                                                               //0005
   in_string = %xlate(LOWER :UPPER :in_string);
   l_pos     = %scan('~' :in_string :1);
   If l_pos > 0;                                                                         //SC01
      in_string = %replace('' :in_string :l_pos :1);
   else ;
      l_pos = 1 ;                                                                        //SC01
   Endif;                                                                                //SC01

   if %scan('%TIMESTAMP':in_string :l_pos) <> 0;

      l_pos =  %scan('(' :in_string :l_pos);
      If L_pos = 0 ;                                                                     // VM001
         return;                                                                         // VM001
      endif ;                                                                            // VM001
      start  =  l_pos;
      l_Spos = %scan('(' :in_string :l_pos+1);
      l_Epos = %scan(':' :in_string :l_pos+1);

      dow l_Spos < l_Epos;
         if l_Spos <> 0;
            findcbr(l_Spos :in_string);
            l_pos = l_Spos;
            if l_pos < l_Epos;
               l_Spos = %scan('(' :in_string :l_pos+1);
            elseif l_pos > l_Epos;
               l_Epos = %scan(':' :in_string :l_pos+1);
               l_Spos = %scan('(' :in_string :l_pos+1);
            endif;
         else;
            l_Spos = l_Epos + 1;
         endif;
      enddo;

      //Break into factor 1 and factor 2
      //if l_Epos <> 0;
      if (l_Epos-start) > 1;
         lk_refact1 = %subst(in_string :start+1 :l_Epos-start-1);
         start      = l_Epos;
         l_Epos     = %scan(':' :in_string :l_Epos+1);
         // if l_Epos <> 0;                                                              //PS01
         if l_Epos-start > 1;                                                            //PS01
            lk_refact2 = %subst(in_string :start+1 :l_Epos-start-1);
         else;
            l_Epos     = %scan(')' :in_string :start+1);
            if l_Epos-start > 1;                                                         //PS01
               lk_refact2 = %subst(in_string :start+1 :l_Epos-start-1);
            endif ;                                                                      //PS01
         endif;
      else;
         //Build the factor 1 as its 1 component senario
         l_Epos = l_pos;
         findcbr(l_Epos :in_string);
         If (l_Epos-start) > 1 ;                                                         //SC01
            lk_refact1 = %subst(in_string :start+1 :l_Epos-start-1);
         endif ;                                                                         //SC01
      endif;

      if lk_refact1 <> *Blanks;
         In_string1 = %trim(lk_refact1);
         split_component_5(In_string1 :arr :arropr:i);
      else;
         return;
      endif;
      i += 1;

      lk_reseq = in_seq;
      for j = 1 to i-1;
         if j <= %elem(arr) and arr(j) <> *Blanks;
            arr_var = %trim(arr(j));
            l_Epos = %scan('%'  :arr_var);
            l_Spos = %scan('''' :arr_var);
            if l_Spos = 0;
               l_Spos = %scan('"' :arr_var);
            endif;
            lk_recomp = %trim(arropr(j));

            Clear Ik_refact2;
            select;
            when l_Spos <> 0 and l_Spos < l_Epos;
               Ik_refact1 = 'CONST(' + %trim(arr(j)) + ')';
               if i = 2;
                  leave;
               endif;
               lk_reseq += 1;
               lk_recontin = 'AND';
               clear lk_rebif;
               iavarrellog(in_srclib    :
                           in_srcspf    :
                           in_srcmbr    :
                           in_ifsloc    :                                                //0005
                           lk_reseq     :
                           in_rrn       :
                           lk_reroutine :
                           lk_rereltyp  :
                           lk_rerelnum  :
                           lk_reopc     :
                           lk_reresult  :
                           lk_rebif     :
                           ik_refact1   :
                           lk_recomp    :
                           ik_refact2   :
                           lk_recontin  :
                           lk_reresind  :
                           lk_recat1    :
                           lk_recat2    :
                           lk_recat3    :
                           lk_recat4    :
                           lk_recat5    :
                           lk_recat6    :
                           lk_reutil    :
                           lk_renum1    :
                           lk_renum2    :
                           lk_renum3    :
                           lk_renum4    :
                           lk_renum5    :
                           lk_renum6    :
                           lk_renum7    :
                           lk_renum8    :
                           lk_renum9    :
                           lk_reexc     :
                           lk_reinc );

            when l_Epos <> 0 and (l_Spos > l_Epos or l_Spos = 0);
               l_pos      = %scan('(' :arr(j) :l_Epos);
            // If l_pos <> 0;
               If l_pos > l_Epos ;                                                          //PJ01
                  lk_rebif = %subst(arr(j) :l_Epos :l_pos-l_Epos);
               Else;
                  lk_rebif = arr(j);
               EndIf;
               string     = '~' + %subst(%trim(arr(j)) :l_Epos);
             //callbif(in_srclib  :                                                      //0005
             //        in_srcspf  :                                                      //0005
             //        in_srcmbr  :                                                      //0005
               callbif(in_uWSrcDtl:                                                      //0005
                       In_rrn     :
                       lk_reseq   :
                       l_bkseq    :
                       lk_REOPC   :
                       ik_refact1 :
                       ik_refact2 :
                       in_type    :
                       lk_RECOMP  :
                       lk_reBIF   :
                       flag       :
                       field2     :
                       string     :
                       field4 );

            other;
               select ;
               when l_Spos <> 0;
                  clear lk_rebif;
                  Ik_refact1 = 'CONST(' + %trim(arr(j)) + ')';
               when %check('.0123456789' :%Trim(arr(j))) <> 0;
                  Ik_refact1 = %trim(arr(j));
               other ;
                  clear lk_rebif;
                  Ik_refact1 = 'CONST(' + %trim(arr(j)) + ')';
               endsl;
               if i = 2;
                  leave;
               endif;

               If %trim(Ik_refact1) = 'CONST()';
               Else;
                  lk_reseq += 1;
                  lk_recontin = 'AND';
                  iavarrellog(in_srclib    :
                              in_srcspf    :
                              in_srcmbr    :
                              in_ifsloc    :                                             //0005
                              lk_reseq     :
                              in_rrn       :
                              lk_reroutine :
                              lk_rereltyp  :
                              lk_rerelnum  :
                              lk_reopc     :
                              lk_reresult  :
                              lk_rebif     :
                              ik_refact1   :
                              lk_recomp    :
                              ik_refact2   :
                              lk_recontin  :
                              lk_reresind  :
                              lk_recat1    :
                              lk_recat2    :
                              lk_recat3    :
                              lk_recat4    :
                              lk_recat5    :
                              lk_recat6    :
                              lk_reutil    :
                              lk_renum1    :
                              lk_renum2    :
                              lk_renum3    :
                              lk_renum4    :
                              lk_renum5    :
                              lk_renum6    :
                              lk_renum7    :
                              lk_renum8    :
                              lk_renum9    :
                              lk_reexc     :
                              lk_reinc );
               Endif;
            endsl;
            Clear Ik_refact1;
         endif;
      endfor;
      if Lk_refact2  <> *blanks;
         Ik_refact2 = 'CONST(' + Lk_refact2 + ')';
      Endif;
      in_seq = lk_reseq;
   endif;

   return;
end-proc;

//-------------------------------------------------------------------------------- //
//IaXltBif :
//-------------------------------------------------------------------------------- //
dcl-proc iaxltbif export;
   dcl-pi iaxltbif;
      in_string  char(5000);
      in_opcode  char(10);
      in_type    char(10);
  //  in_srclib  char(10);                                                               //0005
  //  in_srcspf  char(10);                                                               //0005
  //  in_srcmbr  char(10);                                                               //0005
      in_uWSrcDtl likeds(uWSrcDtl);                                                      //0005
      in_RRN     packed(6:0);
      xl_refact1 char(80);
      xl_refact2 char(80);
      in_Seq     packed(6:0);
   end-pi;

   dcl-s x_pos         packed(6:0)     inz;
   dcl-s x_Spos        packed(6:0)     inz;
   dcl-s x_Epos        packed(6:0)     inz;
   dcl-s start         packed(6:0)     inz;
   dcl-s end           packed(6:0)     inz;
   dcl-s startbk       packed(6:0)     inz;
   dcl-s i             packed(4:0)     inz;
   dcl-s j             packed(4:0)     inz;
   dcl-s x_bkseq       packed(6:0)     inz;
   dcl-s arr           char(600)       inz dim(600);                                     //MT03
   dcl-s xl_ArrayOpt   char(1)         dim(600);                                         //MT03
   dcl-s flag          Char(10)        inz;
   dcl-s field2        Char(500)       inz;
   dcl-s String        char(5000)      inz;
   dcl-s field4        Char(5000)      inz;
   dcl-s x_inquote     char(1)         inz;
   dcl-s x_bkfact2     varchar(5000)   inz;
   dcl-s xl_in_string  varchar(5000);
   dcl-s x_bkfact1     varchar(5000)   inz;
   dcl-s arr_var       char(600)       inz;

   clear xl_IAVARRELDS;
   uwsrcdtl = In_uwsrcdtl;                                                               //0005
   in_string = %xlate(LOWER :UPPER :in_string);
   x_pos     = %scan('~' :in_string :1);
   if x_pos > 0;                                                                         //PS01
      in_string = %replace('' :in_string :x_pos :1);
   endif;                                                                                //PS01

   if %scan('%XLATE'    :in_string :x_pos) <> 0;
      If x_pos > 0;                                                                      //MT04
         x_pos =  %scan('(' :in_string :x_pos);
      endif;                                                                             //MT04
      end   =  x_pos;
      findcbr(end :in_string);

      x_Spos = %scan('(' :in_string :x_pos+1);
      if x_spos <> 0;
         inquote(in_string :x_spos :x_inquote);
         dow x_inquote = 'Y';
            x_Spos = %scan('(' :in_string :x_spos+1);
            if x_spos <> 0;
               inquote(in_string :x_spos :x_inquote);
            else;
               x_inquote = 'N';
            endif;
         enddo;
      endif;

      x_Epos = %scan(':' :in_string :x_pos+1);
      if x_epos <> 0;
         inquote(in_string :x_epos :x_inquote);
         dow x_inquote = 'Y';
            x_epos = %scan(':' :in_string :x_epos+1);
            if x_epos <> 0;
               inquote(in_string :x_epos :x_inquote);
            else;
               x_inquote = 'N';
            endif;
         enddo;
      endif;

      for i = 1 to 3;
         dow x_Spos < x_Epos;
            if x_Spos <> 0;
               findcbr(x_Spos :in_string);
               x_pos = x_Spos;
               if x_pos < x_Epos;
                  x_Spos = %scan('(' :in_string :x_pos+1);
                  if x_spos <> 0;
                     inquote(in_string :x_spos :x_inquote);
                      dow x_inquote = 'Y';
                         x_spos = %scan(':' :in_string :x_spos+1);
                         if x_spos <> 0;
                            inquote(in_string :x_spos :x_inquote);
                         else;
                            x_inquote = 'N';
                         endif;
                      enddo;
                  endif;
               elseif x_pos > x_Epos;
                  x_Epos = %scan(':' :in_string :x_pos+1);
                  if x_epos <> 0;
                     inquote(in_string :x_epos :x_inquote);
                     dow x_inquote = 'Y';
                        x_epos = %scan(':' :in_string :x_epos+1);
                        if x_epos <> 0;
                           inquote(in_string :x_epos :x_inquote);
                        else;
                           x_inquote = 'N';
                        endif;
                     enddo;
                  endif;

                  x_Spos = %scan('(' :in_string :x_pos+1);
                  if x_spos <> 0;
                     inquote(in_string :x_spos :x_inquote);
                     dow x_inquote = 'Y';
                        x_spos = %scan(':' :in_string :x_spos+1);
                        if x_spos <> 0;
                           inquote(in_string :x_spos :x_inquote);
                        else;
                           x_inquote = 'N';
                        endif;
                     enddo;
                  endif;
               endif;
            else;
               x_Spos = x_Epos + 1;
            endif;
         enddo;

         if x_epos <> 0;
            startbk = start;
            start   = x_epos;
            if i <> 3;
               x_Spos = %scan('(' :in_string :x_epos+1);
               if x_spos <> 0;
                  inquote(in_string :x_spos :x_inquote);
                  dow x_inquote = 'Y';
                     x_Spos = %scan('(' :in_string :x_spos+1);
                     if x_spos <> 0;
                        inquote(in_string :x_spos :x_inquote);
                     else;
                        x_inquote = 'N';
                     endif;
                  enddo;
               endif;
               x_Epos = %scan(':' :in_string :x_epos+1);
               if x_epos <> 0;
                  inquote(in_string :x_epos :x_inquote);
                  dow x_inquote = 'Y';
                     x_epos = %scan(':' :in_string :x_epos+1);
                     if x_epos <> 0;
                        inquote(in_string :x_epos :x_inquote);
                     else;
                        x_inquote = 'N';
                     endif;
                  enddo;
               endif;
            endif;
         endif;
      endfor;

      if x_Epos <> 0 and start-startbk > 1;                                              //MT04
         x_bkfact1 = %subst(in_string :startbk+1 :start-startbk-1);
      else;
         if end-start > 1;                                                               //MT04
            x_bkfact1 = %subst(in_string :start+1 :end-start-1);
         endif;                                                                          //MT04
      endif;

      x_bkfact1    = RMVbrackets(x_bkfact1);
      xl_in_string = x_bkfact1 ;
      split_component_5(xl_in_string :arr :xl_ArrayOpt :i);
      xl_reseq = in_seq;
      for j=1 by 1 to (i+1);
         if j <= %elem(arr) and arr(j) <> *Blanks;
            arr_var = %trim(arr(j));
            if %scan('(' :arr_var) = 1;
               arr(j) = RMVbrackets(arr(j));
            endif;
            x_Epos = %scan('%'  :arr_var);
            x_Spos = %scan('''' :arr_var);
            if x_Spos = 0;
               x_Spos = %scan('"' :arr_var);
            endif;
            xl_recomp  = xl_ArrayOpt(J);

            select;
            when x_Spos <> 0 and x_Spos < x_Epos;
               xl_refact1 = 'CONST(' + %trim(arr(j)) + ')';
               if i = 2;
                  leave;
               endif;
               clear xl_refact2;
               xl_reseq += 1;
               xl_recontin = 'AND';

               iavarrellog(in_srclib    :
                           in_srcspf    :
                           in_srcmbr    :
                           in_ifsloc    :                                                //0005
                           xl_reseq     :
                           in_rrn       :
                           xl_reroutine :
                           xl_rereltyp  :
                           xl_rerelnum  :
                           xl_reopc     :
                           xl_reresult  :
                           xl_rebif     :
                           xl_refact1   :
                           xl_recomp    :
                           xl_refact2   :
                           xl_recontin  :
                           xl_reresind  :
                           xl_recat1    :
                           xl_recat2    :
                           xl_recat3    :
                           xl_recat4    :
                           xl_recat5    :
                           xl_recat6    :
                           xl_reutil    :
                           xl_renum1    :
                           xl_renum2    :
                           xl_renum3    :
                           xl_renum4    :
                           xl_renum5    :
                           xl_renum6    :
                           xl_renum7    :
                           xl_renum8    :
                           xl_renum9    :
                           xl_reexc     :
                           xl_reinc );

            when x_Epos <> 0 and (x_Spos > x_Epos or x_Spos = 0);
               x_pos      = %scan('(' :arr(j) :x_Epos);
               If x_pos > x_Epos ;                                                          //PJ01
                  xl_rebif   = %subst(arr(j) :x_Epos :x_pos-x_Epos);
               Else;
                  xl_rebif   = arr(j);
               EndIf;
               string     = '~' + %subst(%trim(arr(j)) :x_Epos);
               xl_refact1 = *blanks;
               clear xl_refact2;

             //Callbif(in_srclib  :                                                      //0005
             //        in_srcspf  :                                                      //0005
             //        in_srcmbr  :                                                      //0005
               callbif(in_uWSrcDtl:                                                      //0005
                       In_rrn     :
                       xl_reseq   :
                       x_bkseq    :
                       xl_REOPC   :
                       xl_refact1 :
                       xl_refact2 :
                       in_type    :
                       xl_RECOMP  :
                       xl_reBIF   :
                       flag       :
                       field2     :
                       string     :
                       field4 );

            other;
               if x_Spos <> 0;
                  xl_refact1 = 'CONST(' + %trim(arr(j)) + ')';
               else;
                  If %check('.0123456789' : %trim(arr(j))) <> 0 ;
                     xl_refact1 = %trim(arr(j)) ;
                  Else ;
                     xl_refact1 = 'CONST(' + %trim(arr(j)) + ')';
                  EndIf ;
               endif;
               clear xl_refact2;

               If %trim(xl_refact1) =  'CONST()' ;
               Else ;
                  xl_reseq += 1;
                  xl_recontin = 'AND';
                  iavarrellog(in_srclib    :
                              in_srcspf    :
                              in_srcmbr    :
                              in_ifsloc    :                                             //0005
                              xl_reseq     :
                              in_rrn       :
                              xl_reroutine :
                              xl_rereltyp  :
                              xl_rerelnum  :
                              xl_reopc     :
                              xl_reresult  :
                              xl_rebif     :
                              xl_refact1   :
                              xl_recomp    :
                              xl_refact2   :
                              xl_recontin  :
                              xl_reresind  :
                              xl_recat1    :
                              xl_recat2    :
                              xl_recat3    :
                              xl_recat4    :
                              xl_recat5    :
                              xl_recat6    :
                              xl_reutil    :
                              xl_renum1    :
                              xl_renum2    :
                              xl_renum3    :
                              xl_renum4    :
                              xl_renum5    :
                              xl_renum6    :
                              xl_renum7    :
                              xl_renum8    :
                              xl_renum9    :
                              xl_reexc     :
                              xl_reinc );
               EndIf ;

            endsl;
         endif;
      endfor;
      in_seq = xl_reseq;
   endif;

   return;

end-proc;

//------------------------------------------------------------------------- //
//IaIntBif :
//------------------------------------------------------------------------- //
dcl-proc iaintbif export;
   dcl-pi iaintbif;
      in_string  char(5000);
      in_opcode  char(10);
      in_type    char(10);
  //  in_srclib  char(10);                                                               //0005
  //  in_srcspf  char(10);                                                               //0005
  //  in_srcmbr  char(10);                                                               //0005
      in_uWSrcDtl likeds(uWSrcDtl);                                                      //0005
      in_RRN     packed(6:0);
      mt_refact1 char(80);
      mt_refact2 char(80);
      in_Seq     packed(6:0);
   end-pi;

   dcl-s arr          char(600)      inz dim(600);                                       //MT03
   dcl-s out_Array    char(600)      dim(600);                                           //MT03
   dcl-s out_Arrayopr char(1)        dim(600);                                           //MT03
   dcl-s flag         Char(10)       inz;
   dcl-s field2       Char(500)      inz;
   dcl-s String       char(5000)     inz;
   dcl-s field4       Char(5000)     inz;
   dcl-s i_inquote    char(1)        inz;
   dcl-s i_bkfact2    varchar(5000)  inz;
   dcl-s In_String1   varchar(5000);
   dcl-s i_bkfact1    varchar(5000)  inz;
   dcl-s out_NoOfElm  packed(4:0);
   dcl-s i_pos        packed(6:0)    inz;
   dcl-s i_Spos       packed(6:0)    inz;
   dcl-s i_Epos       packed(6:0)    inz;
   dcl-s start        packed(6:0)    inz;
   dcl-s i            packed(4:0)    inz;
   dcl-s i_bkseq      packed(6:0)    inz;
   dcl-s j            packed(4:0)    inz;
   dcl-s arr_var      char(600)      inz;                                                //MT03

   if in_string = *Blanks;
      return;
   endif;
   clear mt_IAVARRELDS;
   uwsrcdtl = In_uwsrcdtl;                                                               //0005

   in_string = %xlate(LOWER :UPPER :in_string);
   i_pos     = %scan('~' :in_string :1);

   if i_pos > 0;                                                                           //PS01
      in_string = %replace('' :in_string :i_pos :1);
   endif;                                                                                  //PS01

   if %scan('%INT'   :in_string :i_pos) <> 0;
      if i_pos > 0;                                                                        //KM
         i_pos =  %scan('(' :in_string :i_pos);
      endif;                                                                               //KM
      start =  i_pos;
      findcbr(i_pos :in_string);
      if i_pos-start>1;
 //   i_bkfact1  = %subst(in_string :start+1 :i_pos-start-1);
 //   i_bkfact1  = RMVbrackets(i_bkfact1);
         i_bkfact1  = %subst(in_string :start+1 :i_pos-start-1);
         i_bkfact1  = RMVbrackets(i_bkfact1);
      endif;
      mt_reseq   = in_seq;
      in_string1 = i_bkfact1;
      split_component_5(in_string1:out_Array:out_Arrayopr:out_NoOfElm );
      i = out_NoOfElm + 1;

      for j = 1 to i-1;
         if j <= %elem(out_Array) and out_Array(j) <> *Blanks;
            arr_var = %trim(out_Array(j));
            if %scan('(' :arr_var) = 1;
               out_Array(j) = RMVbrackets(out_Array(j));
            endif;
            i_Epos = %scan('%'  :arr_var);
            i_Spos = %scan('''' :arr_var);
            if i_Spos = 0;
               i_Spos = %scan('"' :arr_var);
            endif;
            mt_recomp = out_Arrayopr(j);

            clear mt_refact2;
            select;
            when i_Epos <> 0 and (i_Spos > i_Epos or i_Spos = 0);
               i_pos      = %scan('(' :out_Array(j) :i_Epos);
    //         if i_pos <> 0;
          //   if i_pos > i_Epos;                                                            //PS01
               if i_Epos > 0 and i_pos > i_Epos;                                             //PS01
                  mt_rebif   = %subst(out_Array(j) :i_Epos :i_pos-i_Epos);
               Else;
                  mt_rebif = out_Array(j);
               EndIf;

               string     = '~' + %subst(%trim(out_Array(j)) :i_Epos);
              //Callbif(in_srclib  :                                                     //0005
              //        in_srcspf  :                                                     //0005
              //        in_srcmbr  :                                                     //0005
                callbif(in_uWSrcDtl:                                                     //0005
                        In_rrn     :
                        mt_reseq   :
                        i_bkseq    :
                        mt_REOPC   :
                        mt_refact1 :
                        mt_refact2 :
                        in_type    :
                        mt_RECOMP  :
                        mt_reBIF   :
                        flag       :
                        field2     :
                        string     :
                        field4 );

            other;
               if i_Spos <> 0;
                  mt_refact1 = 'CONST(' + %trim(out_Array(j)) + ')';
               elseif %check('.0123456789' :%trim(out_Array(j))) <> 0;
                  mt_refact1 = %trim(out_Array(j));
               else;
                  mt_refact1 = 'CONST(' + %trim(out_Array(j)) + ')';
               endif;
               if i = 2;
                  leave;
               endif;
               If mt_refact1 =  'CONST()' ;
               Else ;
                  mt_reseq += 1;
                  mt_recontin = 'AND';
                  iavarrellog(in_srclib    :
                              in_srcspf    :
                              in_srcmbr    :
                              in_ifsloc    :                                             //0005
                              mt_reseq     :
                              in_rrn       :
                              mt_reroutine :
                              mt_rereltyp  :
                              mt_rerelnum  :
                              mt_reopc     :
                              mt_reresult  :
                              mt_rebif     :
                              mt_refact1   :
                              mt_recomp    :
                              mt_refact2   :
                              mt_recontin  :
                              mt_reresind  :
                              mt_recat1    :
                              mt_recat2    :
                              mt_recat3    :
                              mt_recat4    :
                              mt_recat5    :
                              mt_recat6    :
                              mt_reutil    :
                              mt_renum1    :
                              mt_renum2    :
                              mt_renum3    :
                              mt_renum4    :
                              mt_renum5    :
                              mt_renum6    :
                              mt_renum7    :
                              mt_renum8    :
                              mt_renum9    :
                              mt_reexc     :
                              mt_reinc );
               EndIf ;
            endsl;
            clear mt_refact1;
        endif;
      endfor;
      in_seq = mt_reseq;
    endif;

   return;

end-proc;

//---------------------------------------------------------------------------- //
//IaPsrIoFr :
//---------------------------------------------------------------------------- //
dcl-proc IAPSRIOFR export;
   dcl-pi IAPSRIOFR;
      in_string    char(5000);
      in_type      char(10);
      in_error     char(10);
      in_xref      char(10);
  //  in_srclib  char(10);                                                               //0005
  //  in_srcspf  char(10);                                                               //0005
  //  in_srcmbr  char(10);                                                               //0005
      in_uWSrcDtl likeds(uWSrcDtl);                                                      //0005
      in_rrn       packed(6:0);
      in_rrn_e     packed(6:0);
      in_ErrLogFlg char(1);
   end-pi;

   dcl-ds VARRELIODS extname('IAVARREL') prefix(io_) inz;
   end-ds;

   dcl-s io_factor1arr char(600)   inz dim(600);                                         //MT03
   dcl-s arr           char(600)   inz dim(600);                                         //MT03
   dcl-s io_opcode     char(10)    inz;
   dcl-s io_indicator  char(6)     inz;
   dcl-s io_factor1cnt char(20)    inz;
   dcl-s io_factor1    char(80)    inz;
   dcl-s io_factor1k   char(5000)  inz;
   dcl-s io_factor2    char(80)    inz;
   dcl-s io_result     char(50)    inz;
   dcl-s recFound      char(1)     inz;
   dcl-s field2        char(500)   inz;
   dcl-s String        char(5000)  inz;
   dcl-s field4        char(5000)  inz;
   dcl-s io_bkfact2    char(80)    inz;
   dcl-s W_SrcFile     char(10)    inz;
   dcl-s parm6         char(80)    inz;
   dcl-s parm7         char(10)    inz;
   dcl-s parm8         char(10)    inz;
   dcl-s parm11        char(10)    inz;
   dcl-s parm13        char(10)    inz;
   dcl-s parm15        char(10)    inz;
   dcl-s flag          char(10)    inz;
   dcl-s parm17        char(1)     inz;
   dcl-s parm18        char(1)     inz;
   dcl-s parm19        char(1)     inz;
   dcl-s parm20        char(1)     inz;
   dcl-s parm21        char(1)     inz;
   dcl-s parm22        char(1)     inz;
   dcl-s parm23        char(10)    inz;
   dcl-s parm33        char(1)     inz;
   dcl-s parm34        char(1)     inz;
   dcl-s io_pos1       packed(6:0) inz;
   dcl-s io_pos2       packed(6:0) inz;
   dcl-s io_pos3       packed(6:0) inz;
   dcl-s io_pos4       packed(6:0) inz;
   dcl-s in_seq        packed(6:0) inz;
   dcl-s io_seqn       packed(6:0) inz;
   dcl-s io_f1count    packed(6:0) inz;
   dcl-s l_Spos        packed(6:0) inz;
   dcl-s l_pos         packed(6:0) inz;
   dcl-s l_Epos        packed(6:0) inz;
   dcl-s old_plus      packed(6:0) inz;
   dcl-s start         packed(6:0) inz;
   dcl-s bracket       packed(4:0) inz;
   dcl-s i             packed(4:0) inz;
   dcl-s j             packed(4:0) inz;
   dcl-s m             packed(4:0) inz;
   dcl-s k             packed(4:0) inz;
   dcl-s io_bkseq      packed(6:0) inz;
   dcl-s parm24        packed(5:0) inz;
   dcl-s parm25        packed(5:0) inz;
   dcl-s parm26        packed(5:0) inz;
   dcl-s parm27        packed(5:0) inz;
   dcl-s parm28        packed(5:0) inz;
   dcl-s parm29        packed(5:0) inz;
   dcl-s parm30        packed(5:0) inz;
   dcl-s parm31        packed(5:0) inz;
   dcl-s parm32        packed(5:0) inz;
   dcl-s arr_var       char(600)   inz;
   dcl-s in_stringt    char(5000)  inz;
   dcl-s str_len       packed(4:0) inz;

      if in_string = *Blanks;
         return;
      endif;
      uwsrcdtl = In_uwsrcdtl;                                                            //0005
   //SB02 monitor;
      if str_len > 1;                                                                    //PS01
        in_string = %subst(%trimr(in_string) :1 :%len(%trimr(in_string))-1);
      endif;                                                                             //PS01
      io_pos1   = %scan(' ' : %triml(in_string) : 1);
      if io_pos1 > 1;
 //   io_opcode = %subst(%trim(in_string) : 1 :  io_pos1 - 1);
         io_opcode = %subst(%trim(in_string) : 1 :  io_pos1 - 1);
      endif;
      io_reopc  = io_opcode;
      select;
      when (%scan('%KDS' : %trim(in_string) : io_pos1+1) > 0);
         io_pos2 = %scan('(' : %trim(in_string) : io_pos1+1);
         io_pos3 = %scan(':' : %trim(in_string) : io_pos2+1);
         if io_pos3 = 0;
            io_pos3 = io_pos2;
            findcbr(io_pos3 :in_string);
            io_pos4 = io_pos3;
         else;
            io_pos4 = io_pos3;
            findcbr(io_pos4 :in_string);
            if io_pos4 - io_pos3 > 1;
 //         io_factor1cnt = %subst(%trim(in_string) : io_pos3 + 1 :
 //                                io_pos4 - io_pos3 - 1);
               io_factor1cnt = %subst(%trim(in_string) : io_pos3 + 1 :
                                      io_pos4 - io_pos3 - 1);
            endif;
            if %check('0123456789' : %trim(io_factor1cnt)) = 0;
               io_f1count = %dec(%trim(io_factor1cnt): 2 : 0);
            endif;
         endif;
         if io_pos3 - io_pos2 > 1;
 //      io_factor1 = %subst(%trim(in_string) : io_pos2 + 1 :
 //                       io_pos3 - io_pos2 - 1);
            io_factor1 = %subst(%trim(in_string) : io_pos2 + 1 :
                             io_pos3 - io_pos2 - 1);
         endif;
         exsr find_f2_result;
         exsr writedsinfofr;
      when %scan('(' : %trim(%subst(%trim(in_string):io_pos1 + 1))) = 1;
         io_pos1    = %scan('(' : %trim(in_string) : io_pos1 + 1);
         io_pos2    = io_pos1;
         in_string  = %trim(in_string);                                         //AP01
         findcbr(io_pos2 :in_string);
         if io_pos2 - io_pos1 > 1;
  //     io_factor1 = %subst(%trim(in_string) : io_pos1 + 1 :
 //                       io_pos2 - io_pos1 - 1);
            io_factor1 = %subst(%trim(in_string) : io_pos1 + 1 :
                             io_pos2 - io_pos1 - 1);
         endif;
         io_pos4    = io_pos2;
         exsr find_f2_result;

         start  =  0;
         l_pos  = 0;
         l_Epos = %scan(':' :%trim(io_factor1));
         l_Spos = %scan('(' :%trim(io_factor1));
         dow l_Epos > 0;
            dow l_Spos < l_Epos;
               if l_Spos <> 0;
                  io_factor1k = io_factor1;
                  findcbr(l_Spos :io_factor1k);
                  io_factor1 = io_factor1k;
                  l_pos      = l_Spos;

                  if l_pos < l_Epos;
                     l_Spos = %scan('(' :%trim(io_factor1) :l_pos+1);
                  elseif l_pos > l_Epos;
                     l_Epos = %scan(':' :%trim(io_factor1) :l_pos+1);
                     l_Spos = %scan('(' :%trim(io_factor1) :l_pos+1);
                  endif;
               else;
                  l_Spos = l_Epos + 1;
               endif;
            enddo;
            i += 1;
            if l_Epos-start>1;
   //       io_factor1Arr(i) = %subst(%trim(io_factor1):start+1 :
   //                         l_Epos-start-1);
               io_factor1Arr(i) = %subst(%trim(io_factor1):start+1 :
                                 l_Epos-start-1);
            endif;
            start  = l_Epos;
            l_Spos = %scan('(' :%trim(io_factor1) : l_epos+1);
            l_Epos = %scan(':' :%trim(io_factor1) :l_Epos+1);
         enddo;

         i += 1;
         io_factor1Arr(i) = %subst(%trim(io_factor1):start+1);
         for m =1 to i;
            io_factor1Arr(m) = RMVbrackets(io_factor1Arr(m));
            split_component_3(io_factor1Arr(m):arr:k);

            for j = 1 to k-1;
               if j <= %elem(arr) and arr(j) <> *Blanks;
                  arr_var = %trim(arr(j));
                  l_Epos = %scan('%'  :arr_var);
                  l_Spos = %scan('''' :arr_var);
                  if l_Spos = 0;
                     l_Spos = %scan('"' :arr_var);
                  endif;

                  if j < k-1;
                     io_recomp  = '+';
                  else;
                     io_recomp  = ' ';
                  endif;
                  select;
                  when l_Spos <> 0 and l_Spos < l_Epos;
                     io_refact1  = 'CONST(' + %trim(arr(j)) + ')';
                     io_bkfact2  = io_refact2;
                     io_reseq   += 1;
                     io_recontin = 'AND';

                     iavarrellog(in_srclib    :
                                 in_srcspf    :
                                 in_srcmbr    :
                                 in_ifsloc    :                                          //0005
                                 io_reseq     :
                                 in_rrn       :
                                 io_reroutine :
                                 io_rereltyp  :
                                 io_rerelnum  :
                                 io_reopc     :
                                 io_reresult  :
                                 io_rebif     :
                                 io_refact1   :
                                 io_recomp    :
                                 io_refact2   :
                                 io_recontin  :
                                 io_reresind  :
                                 io_recat1    :
                                 io_recat2    :
                                 io_recat3    :
                                 io_recat4    :
                                 io_recat5    :
                                 io_recat6    :
                                 io_reutil    :
                                 io_renum1    :
                                 io_renum2    :
                                 io_renum3    :
                                 io_renum4    :
                                 io_renum5    :
                                 io_renum6    :
                                 io_renum7    :
                                 io_renum8    :
                                 io_renum9    :
                                 io_reexc     :
                                 io_reinc );

                     io_refact2 = io_bkfact2;
                     clear io_bkfact2;
                     clear io_refact1;

                  when l_Epos <> 0 and (l_Spos > l_Epos or l_Spos = 0);
                     l_pos      = %scan('(' :arr(j) :l_Epos);
                  // If l_pos <> 0;
                     If l_pos > l_Epos ;
                     io_rebif   = %subst(arr(j) :l_Epos :l_pos-l_Epos);
                     Else;
                     io_rebif   = arr(j);
                     EndIf;
                     string     = '~' + %subst(%trim(arr(j)) :l_Epos);
                     io_refact1 = *blanks;
                     io_bkfact2 = io_refact2;

                   //Callbif(in_srclib  :                                                //0005
                   //        in_srcspf  :                                                //0005
                   //        in_srcmbr  :                                                //0005
                     callbif(in_uWSrcDtl:                                                //0005
                             In_rrn     :
                             io_reseq   :
                             io_bkseq   :
                             io_REOPC   :
                             io_refact1 :
                             io_refact2 :
                             in_type    :
                             io_RECOMP  :
                             io_reBIF   :
                             flag       :
                             field2     :
                             string     :
                             field4 );
                     io_refact2 = io_bkfact2;
                     clear io_bkfact2;
                  other;
                     if l_Spos <> 0;
                        io_refact1 = 'CONST(' + %trim(arr(j)) + ')';
                     elseif %check('0123456789' :arr(j)) <> 0;
                        io_refact1 = %trim(arr(j));
                     else;
                        io_refact1 = 'CONST(' + %trim(arr(j)) + ')';
                     endif;
                     io_reseq += 1;
                     io_recontin = 'AND';
                     io_bkfact2 = io_refact2;

                     iavarrellog(in_srclib    :
                                 in_srcspf    :
                                 in_srcmbr    :
                                 in_ifsloc    :                                          //0005
                                 io_reseq     :
                                 in_rrn       :
                                 io_reroutine :
                                 io_rereltyp  :
                                 io_rerelnum  :
                                 io_reopc     :
                                 io_reresult  :
                                 io_rebif     :
                                 io_refact1   :
                                 io_recomp    :
                                 io_refact2   :
                                 io_recontin  :
                                 io_reresind  :
                                 io_recat1    :
                                 io_recat2    :
                                 io_recat3    :
                                 io_recat4    :
                                 io_recat5    :
                                 io_recat6    :
                                 io_reutil    :
                                 io_renum1    :
                                 io_renum2    :
                                 io_renum3    :
                                 io_renum4    :
                                 io_renum5    :
                                 io_renum6    :
                                 io_renum7    :
                                 io_renum8    :
                                 io_renum9    :
                                 io_reexc     :
                                 io_reinc );

                     io_refact2 = io_bkfact2;
                     clear io_bkfact2;
                     clear io_refact1;
                  endsl;
               endif;
            endfor;
            clear j;
            in_seq = io_reseq;
         endfor;
         clear i;
         clear m;

      when %scan('"' : %trim(%subst(%trim(in_string):io_pos1 + 1))) = 1;
         io_pos1    = %scan('"' : %trim(in_string) : io_pos1 + 1);
         io_pos2    = %scan('"' : %trim(in_string) : io_pos1 + 1);
         if io_pos2 - io_pos1 > 1;
 //      io_factor1 = 'CONST(' + '''' + %subst(%trim(in_string) :
 //      io_pos1 + 1 : io_pos2 - io_pos1 - 1) + '''' + ')';
            io_factor1 = 'CONST(' + '''' + %subst(%trim(in_string) :
            io_pos1 + 1 : io_pos2 - io_pos1 - 1) + '''' + ')';
         endif;
         io_pos4    = io_pos2;
         exsr find_f2_result;
         exsr writedsinfofr;

      other;
         io_pos2    = %scan(' ' : %triml(in_string) : io_pos1 + 1);
         if io_pos2 - io_pos1 > 1;
  //     io_factor1 = %subst(%trim(in_string) : io_pos1 + 1 :
  //                                  io_pos2 - io_pos1 - 1);
            io_factor1 = %subst(%trim(in_string) : io_pos1 + 1 :
                                         io_pos2 - io_pos1 - 1);
         endif;
         if %check('0123456789' : %trim(io_factor1)) = 0;
            io_pos2    = %scan(' ' : %triml(in_string) : io_pos1 + 1);
            if io_pos2 - io_pos1 > 1;
  //        io_factor1 = 'CONST(' + %subst(%trim(in_string) : io_pos1 + 1 :
 //                     io_pos2 - io_pos1 - 1) + ')';
               io_factor1 = 'CONST(' + %subst(%trim(in_string) :
                           io_pos1 + 1 :io_pos2 - io_pos1 - 1) + ')';
            endif;
            io_pos4    = io_pos2;
            exsr find_f2_result;
         else;
            exsr checkiffile;
            if io_factor2 = ' ' and (%len(%trim(in_string)) > io_pos2 - 1);
               io_pos4 = io_pos2;
               exsr find_f2_result;
            else;
               io_factor2 = io_factor1;
               clear io_factor1;
            endif;
         endif;
         exsr writedsinfofr;
      endsl;

      // ---------------- Update IAVARREL file for I/O Operations ---- *//
      if io_reseq > 0;
         exec sql
           update IAVARREL
              set RECOMP   = ' ', RECONTIN = ' '
            where RESEQ    = :io_reseq
              and RERRN    = :in_rrn
              and RESRCLIB = :in_srclib
              and RESRCFLN = :in_srcspf
              and REPGMNM  = :in_srcmbr;
         if SQLSTATE <> SQL_ALL_OK;
            //log errror
         endif;
      endif;

   //SB02 on-error;
      //SB02 in_ErrLogFlg = 'Y';
      //SB02 W_SrcFile    = PSDS.SrcFile;
      //SB02 exec sql
        //SB02 insert into IAEXCPLOG (PRS_SOURCE_LIB,
                               //SB02 PRS_SOURCE_FILE,
                               //SB02 PRS_SOURCE_SRC_MBR,
                               //SB02 LIBRARY_NAME,
                               //SB02 PROGRAM_NAME,
                               //SB02 RRN_NO,
                               //SB02 EXCEPTION_TYPE,
                               //SB02 EXCEPTION_NO,
                               //SB02 EXCEPTION_DATA,
                               //SB02 SOURCE_STM,
                               //SB02 MODULE_PGM,
                               //SB02 MODULE_PROC)
          //SB02 values(trim(:in_srclib),
                 //SB02 trim(:in_srcspf),
                 //SB02 trim(:in_srcmbr),
                 //SB02 trim(:PSDS.Lib),
                 //SB02 trim(:PSDS.ProcNme),
                 //SB02 :in_rrn,
                 //SB02 trim(:PSDS.ExcptTyp),
                 //SB02 trim(:PSDS.ExcptNbr),
                 //SB02 trim(:PSDS.RtvExcptDt),
                 //SB02 trim(:in_string),
                 //SB02 trim(:PSDS.ModulePGM),
                 //SB02 trim(:PSDS.ModuleProc));
      //SB02 if SQLSTATE <> SQL_ALL_OK;
         //log errror
      //SB02 endif;
   //SB02 endmon;
   return;

   begsr find_f2_result;

      in_stringt = %trim(in_string);
      io_pos3 = %scan('(' :in_stringt: io_pos4+1);
      if io_pos3 = 0;
         io_pos3 = %scan(' ' : in_stringt : io_pos4+2);
         io_pos1 = %scan(' ' : in_stringt : io_pos3+1);
      else;
         io_pos1 = io_pos3;
         findcbr(io_pos1 :in_string);
      endif;
      if io_pos3 - io_pos4 > 1;
  //  io_factor2 = %trim(%subst(%trim(in_string) : io_pos4 + 1 :
 //                       io_pos3 - io_pos4 - 1));
         io_factor2 = %trim(%subst(in_stringt :
                             io_pos4 + 1 : io_pos3 - io_pos4 - 1));
      endif;
      io_refact2 = io_factor2;
      if %subst(%triml(in_string) : io_pos3+1 ) <> ' ';
         if io_pos1 - io_pos3 > 1;
   //    io_result  = %subst(in_stringt : io_pos3 + 1 :
   //                       io_pos1 - io_pos3 - 1);
            io_result  = %subst(in_stringt : io_pos3 + 1 :
                               io_pos1 - io_pos3 - 1);
         endif;
         io_reresult = io_result;
      endif;
      clear io_pos1;
      clear io_pos2;
      clear io_pos3;
      clear io_pos4;

   endsr;

   begsr checkiffile;

      exec sql
        select 'Y' as flag
          into :recFound
          from IAPGMFILES
         where IAACTFILE  = trim(:io_factor1)                                            //0004
            or IAACTRCDNM = trim(:io_factor1)                                            //0004
            or IARNMRCDNM = trim(:io_factor1)                                            //0004
            or locate(trim(:io_factor1),KEYWRD_SFILE,1) > 0                              //0004
           and IALIBNAM   = trim(:in_srclib)                                             //0004
           and IASRCFILE  = trim(:in_srcspf)                                             //0004
           and IAMBRNAME  = trim(:in_srcmbr)                                             //0004
           fetch first row only;                                                         //0004
      if SQLSTATE <> SQL_ALL_OK;
         //log error
      endif;

      if SQLSTATE = SQL_ALL_OK and recFound = 'Y';
         io_factor2 = io_factor1;
      endif;

   endsr;

   begsr writedsinfofr;

      io_seqn += 1;
      parm15 = ' ';

      IAVARRELLOG(in_srclib    :
                  in_srcspf    :
                  in_srcmbr    :
                  in_ifsloc    :                                                         //0005
                  io_seqn      :
                  in_rrn       :
                  parm6        :
                  parm7        :
                  Parm8        :
                  io_opcode    :
                  io_result    :
                  parm11       :
                  io_factor1   :
                  parm13       :
                  io_factor2   :
                  Parm15       :
                  io_indicator :
                  Parm17       :
                  Parm18       :
                  Parm19       :
                  Parm20       :
                  Parm21       :
                  Parm22       :
                  Parm23       :
                  Parm24       :
                  Parm25       :
                  Parm26       :
                  Parm27       :
                  Parm28       :
                  Parm29       :
                  Parm30       :
                  Parm31       :
                  Parm32       :
                  Parm33       :
                  parm34 );

   endsr;

end-proc;

//---------------------------------------------------------------------------- //
//IaDays :
//---------------------------------------------------------------------------- //
dcl-proc IADAYS export;
   dcl-pi IADAYS;
      in_string  char(5000);
      in_opcode  char(10);
      in_type    char(10);
  //  in_srclib  char(10);                                                               //0005
  //  in_srcspf  char(10);                                                               //0005
  //  in_srcmbr  char(10);                                                               //0005
      in_uWSrcDtl likeds(uWSrcDtl);                                                      //0005
      in_RRN     packed(6:0);
      in_Factor1 char(80);
      in_Factor2 char(80);
      in_Seq     packed(6:0);
   end-pi;

   dcl-ds IAVARRELDS extname('IAVARREL') prefix(in_) inz;
   end-ds;

   dcl-s i           packed(4:0)    inz(2);
   dcl-s k           Packed(4:0)    inz;
   dcl-s w_pos       packed(2)      inz;
   dcl-s next_plus   packed(2)      inz;
   dcl-s plus_pos    packed(2)      inz;
   dcl-s j           packed(4:0)    inz;
   dcl-s l           packed(4:0)    inz;
   dcl-s isAlphaFlag packed(4:0)    inz;
   dcl-s a_TLpos     packed(4:0)    inz;
   dcl-s w_pos1      packed(4:0)    inz;
   dcl-s a_OBpos     packed(4:0)    inz;
   dcl-s a_bkseq     packed(6:0)    inz;
   dcl-s a_CBpos     packed(4:0)    inz;
   dcl-s a_SCpos     packed(4:0)    inz;
   dcl-s a_BIF1      packed(4:0)    inz;
   dcl-s a_spos      packed(4:0)    inz;
   dcl-s fnd         packed(4:0)    inz;
   dcl-s a_Length    packed(4:0)    inz;
   dcl-s a_Field2    char(500)      inz;
   dcl-s a_BString   char(500)      inz;
   dcl-s arr         Char(600)      dim(600) inz;                                        //MT03
   dcl-s arropr      Char(1)        dim(600) inz;                                        //MT03
   dcl-s a_String1   char(5000)     inz;
   dcl-s a_flag      char(10)       inz;
   dcl-s a_BIFname   char(10)       inz;
   dcl-s a_Factor1   varchar(5000)  inz;
   dcl-s a_Factor2   varchar(5000)  inz;
   dcl-s in_String1  Varchar(5000)  inz;

   dcl-c NUMBERS   '0123456789';
   dcl-c OPERATORS '+-*/%';

   if in_string = *Blanks;
      return;
   endif;
   uwsrcdtl = In_uwsrcdtl;                                                                 //0005
   in_string  = %trim(in_string);
   fnd = %scan(' ' : %trim(in_string):fnd+1);                                              //BA11
  //dow 1=1;                                                                               //BA11
   dow fnd > 0 and (%len(%trim(in_string))  > fnd);                                        //BA11
      // fnd = %scan(' ' : %trim(in_string):fnd+1);                                        //BA11
      //if fnd > 0;                                                                        //BA11
      in_string = %replace('' : %trim(in_string):fnd:1);
      //else;                                                                              //BA11
      //leave;                                                                             //BA11
     // endif;                                                                             //BA11
      fnd = %scan(' ' : %trim(in_string):fnd+1);                                           //BA11
   enddo;

   in_string = %xlate(LOWER:UPPER:in_string);
   a_TLpos   = %scan('~' :in_string);
   If a_TLpos > 0;                                                                      //VP01
      a_OBpos   = %scan('(' :in_string :a_TLpos);
   EndIf;                                                                               //VP01
   if a_OBpos > 0;
 //a_CBpos   = GetCBPos(in_string : a_OBpos);
      a_CBpos   = GetCBPos(in_string : a_OBpos);
   endif;
   if a_CBpos-a_OBpos>1;
 //a_factor1 = %Subst(in_string :a_OBpos + 1 :a_CBpos-a_OBpos-1);
      a_factor1 = %Subst(in_string :a_OBpos + 1 :a_CBpos-a_OBpos-1);
   endif;

   exec sql set :in_string = replace(:in_string, '~', '');
   a_Length   = %Len(%Trim(In_String));
   a_factor1  = %Trim(a_factor1 );
   in_String1 = a_factor1 ;
   Split_Component_5(in_String1:arr:arropr:k);

   in_reseq = in_seq;
   for j=1 to k;
      if j <= %elem(arr) and arr(j) <> *Blanks;
         a_BIF1    = %scan('%' : arr(j));
         a_length  = %len(%trim(arr(j)));
         a_BString = arr(j);
         in_RECOMP =  arropr(j);
         Clear in_factor2;

         select ;
         When a_BIF1 <> 0;
            w_pos1 = %scan('(' : arr(j):a_BIF1);
     //     if w_pos1 <> 0;
            if w_pos1>a_BIF1;
               a_BifName = %subst(arr(j):a_BIF1:w_pos1-a_BIF1);
            Else;
               a_BifName = arr(j);
            EndIf;
            a_String1 = '~' + arr(j);
          //callbif(in_srclib  :                                                        //0005
          //        in_srcspf  :                                                        //0005
          //        in_srcmbr  :                                                        //0005
            callbif(in_uWSrcDtl:                                                        //0005
                    in_Rrn      :
                    in_Seq      :
                    a_bkseq     :
                    in_OpCode   :
                    in_factor1  :
                    in_factor2  :
                    in_Type     :
                    in_RECONTIN :
                    a_BifName   :
                    a_Flag      :
                    a_Field2    :
                    a_String1   :
                    In_String );

         When a_BIF1 =  0;
            Select ;
            When %check(Numbers :%trim(arr(j)))>0;
               in_factor1 = %trim(arr(j));
            other ;
               in_factor1 = 'Const(' + %trim(arr(j)) + ')';
            endsl;
            If  K = 1 ;
               leave ;
            Endif ;

            If %trim(in_factor1) = 'CONST()';
            Else;
               in_recontin = 'AND';
               in_reseq += 1;
               iavarrellog(in_srclib      :
                             in_srcspf    :
                             in_srcmbr    :
                             in_ifsloc    :                                              //0005
                             in_reseq     :
                             in_rrn       :
                             in_reroutine :
                             in_rereltyp  :
                             in_rerelnum  :
                             in_reopc     :
                             in_reresult  :
                             in_rebif     :
                             in_factor1   :
                             in_recomp    :
                             in_factor2   :
                             in_recontin  :
                             in_reresind  :
                             in_recat1    :
                             in_recat2    :
                             in_recat3    :
                             in_recat4    :
                             in_recat5    :
                             in_recat6    :
                             in_reutil    :
                             in_renum1    :
                             in_renum2    :
                             in_renum3    :
                             in_renum4    :
                             in_renum5    :
                             in_renum6    :
                             in_renum7    :
                             in_renum8    :
                             in_renum9    :
                             in_reexc     :
                             in_reinc );
            Endif;
         Endsl;
         clear in_factor1;
      endif;
   Endfor;

   IN_SEQ = IN_RESEQ;
   return;

end-proc;

//----------------------------------------------------------------------------- //
//IaRemBif :
//----------------------------------------------------------------------------- //
dcl-proc iarembif export;
   dcl-pi iarembif;
      in_string  char(5000);
      in_opcode  char(10);
      in_type    char(10);
  //  in_srclib  char(10);                                                               //0005
  //  in_srcspf  char(10);                                                               //0005
  //  in_srcmbr  char(10);                                                               //0005
      in_uWSrcDtl likeds(uWSrcDtl);                                                      //0005
      in_RRN     packed(6:0);
      mt_refact1 char(80);
      mt_refact2 char(80);
      in_Seq     packed(6:0);
   end-pi;

   Dcl-s out_Array    char(600)      dim(600);                                           //MT03
   Dcl-s out_Arrayopr char(1)        dim(600);                                           //MT03
   dcl-s arr          char(600)      inz dim(600);                                       //MT03
   Dcl-s bk_refact1   char(80)       inz;
   dcl-s flag         char(10)       inz;
   dcl-s r_inquote    char(1)        inz;
   dcl-s field2       char(500)      inz;
   dcl-s String       char(5000)     inz;
   dcl-s field4       char(5000)     inz;
   dcl-s r_bkfact2    varchar(5000)  inz;
   Dcl-s in_string1   varchar(5000);
   dcl-s r_bkfact1    varchar(5000)  inz;
   dcl-s r_pos        packed(6:0)    inz;
   Dcl-s out_NoOfElm  packed(4:0);
   dcl-s r_Spos       packed(6:0)    inz;
   dcl-s r_Epos       packed(6:0)    inz;
   dcl-s start        packed(6:0)    inz;
   dcl-s i            packed(4:0)    inz;
   dcl-s j            packed(4:0)    inz;
   dcl-s r_bkseq      packed(6:0)    inz;
   dcl-s k            packed(6:0)    inz;
   dcl-s tr_Bracket   packed(4:0)    inz;
   dcl-s c            char(1)        inz;
   Dcl-s arr_var      char(600)      inz;

   if in_string = *Blanks;
      return;
   endif;
   clear mt_IAVARRELDS;

   uwsrcdtl = In_uwsrcdtl;                                                               //0005
   in_string = %xlate(LOWER :UPPER :in_string);
   r_pos     = %scan('~' :in_string :1);
   if r_pos > 0;                                                                         //PS01
      in_string = %replace('' :in_string :r_pos :1);
      r_pos = %scan('%REM' :in_string :r_pos);
   Else;                                                                                 //SS02
      r_pos = %scan('%REM' :in_string :1);                                               //SS02
   endif;                                                                                //PS01
   tr_bracket = 0;
   if r_pos <> 0;
      for k = r_pos +4 to %len(%trimr(in_string));
          c = %subst(in_string:k:1);
          select;
          when c = '(';
             inquote(in_string :k :r_inquote);
             if r_inquote = 'N';
                if start = 0;
                   start = k;
                else;
                   tr_bracket +=1;
                endif;
             endif;
          when c = ')';
             inquote(in_string :k :r_inquote);
             if r_inquote = 'N';
                tr_bracket -=1;
             endif;
          when c = ':';
             inquote(in_string :k :r_inquote);
             if r_inquote = 'N';
                if tr_bracket = 0;
                   if k-start > 1;                                                       //PS01
                      r_bkfact1  = %subst(in_string :start+1 :k-start-1);
                   endif;
                   findcbr(start :in_string);
                   if start-k > 1;                                                       //PS01
                      r_bkfact2  = %subst(in_string :k+1 :start-k-1);
                   endif;                                                                //PS01
                   leave;
                endif;
             endif;
          other;
          endsl;
      endfor;

 //if %scan('%REM' :in_string :r_pos) <> 0;
 //   r_pos  =  %scan('(' :in_string :r_pos);
 //   start  =  r_pos;
 //   r_Spos = %scan('(' :in_string :r_pos+1);
 //   if r_Spos <> 0;
 //      inquote(in_string :r_Spos :r_inquote);
 //      dow r_inquote = 'Y';
 //         r_Spos = %scan('(' :in_string :r_Spos+1);
 //         if r_Spos <> 0;
 //            inquote(in_string :r_Spos :r_inquote);
 //         else;
 //            r_inquote = 'N';
 //         endif;
 //      enddo;
 //   endif;
 //
 //   r_Epos = %scan(':' :in_string :r_pos+1);
 //   if r_epos <> 0;
 //      inquote(in_string :r_epos :r_inquote);
 //      dow r_inquote = 'Y';
 //         r_epos = %scan(':' :in_string :r_epos+1);
 //         if r_epos <> 0;
 //            inquote(in_string :r_epos :r_inquote);
 //         else;
 //            r_inquote = 'N';
 //         endif;
 //      enddo;
 //   endif;
 //
 //   dow r_Spos < r_Epos;
 //      if r_Spos <> 0;
 //         findcbr(r_Spos :in_string);
 //         r_pos = r_Spos;
 //         if r_pos < r_Epos;
 //            r_Spos = %scan('(' :in_string :r_pos+1);
 //            if r_Spos <> 0;
 //               inquote(in_string :r_Spos :r_inquote);
 //               dow r_inquote = 'Y';
 //                  r_Spos = %scan('(' :in_string :r_Spos+1);
 //                  if r_Spos <> 0;
 //                     inquote(in_string :r_Spos :r_inquote);
 //                  else;
 //                     r_inquote = 'N';
 //                  endif;
 //               enddo;
 //            endif;
 //
 //         elseif r_pos > r_Epos;
 //            r_Epos = %scan(':' :in_string :r_pos+1);
 //            if r_epos <> 0;
 //               inquote(in_string :r_epos :r_inquote);
 //               dow r_inquote = 'Y';
 //                  r_epos = %scan(':' :in_string :r_epos+1);
 //                  if r_epos <> 0;
 //                     inquote(in_string :r_epos :r_inquote);
 //                  else;
 //                     r_inquote = 'N';
 //                  endif;
 //               enddo;
 //            endif;
 //
 //            r_Spos = %scan('(' :in_string :r_pos+1);
 //            if r_Spos <> 0;
 //               inquote(in_string :r_Spos :r_inquote);
 //               dow r_inquote = 'Y';
 //                  r_epos = %scan('(' :in_string :r_Spos+1);
 //                  if r_Spos <> 0;
 //                     inquote(in_string :r_Spos :r_inquote);
 //                  else;
 //                     r_inquote = 'N';
 //                  endif;
 //               enddo;
 //            endif;
 //         endif;
 //      else;
 //         r_Spos = r_Epos + 1;
 //      endif;
 //   enddo;
 //
 //   r_bkfact1  = %subst(in_string :start+1 :r_Epos-start-1);
 //   findcbr(start :in_string);
      r_bkfact1  = RMVbrackets(r_bkfact1);
      r_bkfact2  = RMVbrackets(r_bkfact2);
      mt_reseq   = in_seq;
      in_string1 = r_bkfact1;
      split_component_5(in_string1:out_Array:out_Arrayopr:out_NoOfElm );
      i = out_NoOfElm + 1;

      for j = 1 to i-1;
         if j <= %elem(out_Array) and out_Array(j) <> *Blanks;
            arr_var = %trim(out_Array(j));
            r_Epos    = %scan('%'  : arr_var);
            r_Spos    = %scan('''' : arr_var);
            if r_Spos = 0;
               r_Spos = %scan('"' : arr_var);
            endif;

            mt_recomp = out_Arrayopr(j);

            clear mt_refact2;
            select;
            when r_Epos <> 0 and (r_Spos > r_Epos or r_Spos = 0);
               r_pos    = %scan('(' :out_Array(j) :r_Epos);
               if r_pos <> 0;
                  mt_rebif = %subst(out_Array(j) :r_Epos :r_pos-r_Epos);
               Else;
                  mt_rebif = out_Array(j);
               EndIf;

               string = '~' + %subst(%trim(out_Array(j)) :r_Epos);
             //callbif(in_srclib  :                                                      //0005
             //        in_srcspf  :                                                      //0005
             //        in_srcmbr  :                                                      //0005
               callbif(in_uWSrcDtl:                                                      //0005
                       In_rrn     :
                       mt_reseq   :
                       r_bkseq    :
                       mt_REOPC   :
                       mt_refact1 :
                       mt_refact2 :
                       in_type    :
                       mt_RECOMP  :
                       mt_reBIF   :
                       flag       :
                       field2     :
                       string     :
                       field4 );

            other;
               if %check('.0123456789' :out_Array(j)) <> 0;
                  mt_refact1 = %trim(out_Array(j));
               else;
                  mt_refact1 = 'CONST(' + %trim(out_Array(j)) + ')';
               endif;
               if i = 2;
                  leave;
               endif;
               mt_reseq += 1;
               mt_recontin = 'AND';
               iavarrellog(in_srclib    :
                           in_srcspf    :
                           in_srcmbr    :
                           in_ifsloc    :                                                //0005
                           mt_reseq     :
                           in_rrn       :
                           mt_reroutine :
                           mt_rereltyp  :
                           mt_rerelnum  :
                           mt_reopc     :
                           mt_reresult  :
                           mt_rebif     :
                           mt_refact1   :
                           mt_recomp    :
                           mt_refact2   :
                           mt_recontin  :
                           mt_reresind  :
                           mt_recat1    :
                           mt_recat2    :
                           mt_recat3    :
                           mt_recat4    :
                           mt_recat5    :
                           mt_recat6    :
                           mt_reutil    :
                           mt_renum1    :
                           mt_renum2    :
                           mt_renum3    :
                           mt_renum4    :
                           mt_renum5    :
                           mt_renum6    :
                           mt_renum7    :
                           mt_renum8    :
                           mt_renum9    :
                           mt_reexc     :
                           mt_reinc );
            endsl;
            clear mt_refact1;
         endif;
      endfor;

      r_bkfact1 = %trim(mt_refact1);

      in_string1 = r_bkfact2;
      split_component_5(in_string1:out_Array : out_Arrayopr:out_NoOfElm );

      i = out_NoOfElm + 1;

      for j = 1 to i-1;
         if j <= %elem(out_Array) and out_Array(j) <> *Blanks;
            arr_var = %trim(out_Array(j));
            r_Epos    = %scan('%'  : arr_var);
            r_Spos    = %scan('''' : arr_var);
            if r_Spos = 0;
               r_Spos = %scan('"' : arr_var);
            endif;
            mt_recomp = out_Arrayopr(j);
            clear mt_refact1;
            select;
            when r_Epos <> 0 and (r_Spos > r_Epos or r_Spos = 0);
               r_pos      = %scan('(' :out_Array(j) :r_Epos);
               If r_pos   <> 0;
                 mt_rebif = %subst(out_Array(j) :r_Epos :r_pos-r_Epos);
               Else;
                 mt_rebif = out_Array(j);
               EndIf;
               string     = '~' + %subst(%trim(out_Array(j)) :r_Epos);
             //callbif(in_srclib  :                                                      //0005
             //        in_srcspf  :                                                      //0005
             //        in_srcmbr  :                                                      //0005
               callbif(in_uWSrcDtl:                                                      //0005
                       In_rrn     :
                       mt_reseq   :
                       r_bkseq    :
                       mt_REOPC   :
                       bk_refact1 :
                       mt_refact2 :
                       in_type    :
                       mt_RECOMP  :
                       mt_reBIF   :
                       flag       :
                       field2     :
                       string     :
                       field4 );
            other;
               if %check('.0123456789' :out_Array(j)) <> 0;
                  mt_refact2 = %trim(out_Array(j));
               else;
                  mt_refact2 = 'CONST(' + %trim(out_Array(j)) + ')';
               endif;
               if i = 2;
                  leave;
               endif;

               If %trim(mt_refact2) = 'CONST()';
               Else;
                  mt_reseq += 1;
                  mt_recontin = 'AND';
                  iavarrellog(in_srclib    :
                              in_srcspf    :
                              in_srcmbr    :
                              in_ifsloc    :                                             //0005
                              mt_reseq     :
                              in_rrn       :
                              mt_reroutine :
                              mt_rereltyp  :
                              mt_rerelnum  :
                              mt_reopc     :
                              mt_reresult  :
                              mt_rebif     :
                              mt_refact1   :
                              mt_recomp    :
                              mt_refact2   :
                              mt_recontin  :
                              mt_reresind  :
                              mt_recat1    :
                              mt_recat2    :
                              mt_recat3    :
                              mt_recat4    :
                              mt_recat5    :
                              mt_recat6    :
                              mt_reutil    :
                              mt_renum1    :
                              mt_renum2    :
                              mt_renum3    :
                              mt_renum4    :
                              mt_renum5    :
                              mt_renum6    :
                              mt_renum7    :
                              mt_renum8    :
                              mt_renum9    :
                              mt_reexc     :
                              mt_reinc );
               Endif;
            endsl;
            clear mt_refact2;
         endif;
      endfor;
      mt_refact1 = r_bkfact1;
      in_seq     = mt_reseq;
   endif;

   return;

end-proc;

//------------------------------------------------------------------------------- //
//IaSubsttBif :
//------------------------------------------------------------------------------- //
dcl-proc iasubsttbif export;
   dcl-pi iasubsttbif;
      in_string  char(5000);
      in_opcode  char(10);
      in_type    char(10);
  //  in_srclib  char(10);                                                               //0005
  //  in_srcspf  char(10);                                                               //0005
  //  in_srcmbr  char(10);                                                               //0005
      in_uWSrcDtl likeds(uWSrcDtl);                                                      //0005
      in_RRN     packed(6:0);
      sk_refact1 char(80);
      sk_refact2 char(80);
      in_Seq     packed(6:0);
   end-pi;

   dcl-s arr        char(600)     inz dim(600);                                          //MT03
   dcl-s arrOpr     char(1)       inz dim(600);                                          //MT03
   dcl-s flag       char(10)      inz;
   dcl-s field2     char(500)     inz;
   dcl-s String     char(5000)    inz;
   dcl-s field4     char(5000)    inz;
   dcl-s s_bkfact2  char(80)      inz;
   dcl-s s_bkfact1  char(80)      inz;
   dcl-s s_inquote  char(1)       inz;
   dcl-s Factor1    varchar(5000);
   dcl-s In_string1 varchar(5000) inz ;
   dcl-s ss_refact1 varchar(5000) inz;
   dcl-s ss_refact2 varchar(5000) inz;
   dcl-s s_pos      packed(6:0)   inz;
   dcl-s s_Spos     packed(6:0)   inz;
   dcl-s s_Epos     packed(6:0)   inz;
   dcl-s start      packed(6:0)   inz;
   dcl-s i          packed(4:0)   inz;
   dcl-s s_bkseq    packed(6:0)   inz;
   dcl-s j          packed(4:0)   inz;
   dcl-s c          char(1)       inz;
   dcl-s tr_bracket packed(6:0)   inz;
   dcl-s k          packed(6:0)   inz;
   dcl-s arr_var    char(600)     inz;

   if in_string = *Blanks;
      return;
   endif;
   uwsrcdtl = In_uwsrcdtl;                                                               //0005
   clear ss_IAVARRELDS;
   in_string = %xlate(LOWER :UPPER :in_string);
   s_pos     = %scan('~' :in_string :1);

   in_string = %replace('' :in_string :s_pos :1);
   s_pos = %scan('%SUBST' : in_string :s_pos);
   tr_bracket = 0;
   if s_pos <> 0;
      for k = s_pos +6 to %len(%trimr(in_string));
          c = %subst(in_string:k:1);
          select;
          when c = '(';
             inquote(in_string :k :s_inquote);
             if s_inquote = 'N';
                if start = 0;
                   start = k;
                else;
                   tr_bracket +=1;
                endif;
             endif;
          when c = ')';
             inquote(in_string :k :s_inquote);
             if s_inquote = 'N';
                tr_bracket -=1;
             endif;
          when c = ':';
             inquote(in_string :k :s_inquote);
             if s_inquote = 'N';
                if tr_bracket = 0;
                   if start >= *zeros and (k-start) > 1 ;                                //PJ01
                      ss_refact1 = %subst(in_string :start+1 :k-start-1);
                   endif ;                                                               //PJ01
                   ss_refact1 = RMVbrackets(ss_refact1);
                   leave;
                endif;
             endif;
          other;
          endsl;
      endfor;

 //if %scan('%SUBST' : in_string :s_pos) <> 0;
 //
      //Check whether open bracket is inside quoted
 //   s_pos  =  %scan('(' :in_string :s_pos);
 //   start  =  s_pos;
 //   s_Spos = %scan('(' :in_string :s_pos+1);
 //   if s_spos <> 0;
 //      inquote(in_string :s_spos :s_inquote);
 //      dow s_inquote = 'Y';
 //         s_Spos = %scan('(' :in_string :s_spos+1);
 //         if s_spos <> 0;
 //            inquote(in_string :s_spos :s_inquote);
 //         else;
 //            s_inquote = 'N';
 //         endif;
 //      enddo;
 //   endif;
 //
 //   //Check whether colon is inside quoted
 //   s_Epos = %scan(':' :in_string :s_pos+1);
 //   if s_epos <> 0;
 //      inquote(in_string :s_epos :s_inquote);
 //      dow s_inquote = 'Y';
 //         s_epos = %scan(':' :in_string :s_epos+1);
 //         if s_epos <> 0;
 //            inquote(in_string :s_epos :s_inquote);
 //         else;
 //            s_inquote = 'N';
 //         endif;
 //      enddo;
 //   endif;
 //
 //   //Get the factor1 and factor2
 //   dow s_Spos < s_Epos;
 //      if s_Spos <> 0;
 //         findcbr(s_Spos :in_string);
 //         s_pos = s_Spos;
 //         if s_pos < s_Epos;
 //            s_Spos = %scan('(' :in_string :s_pos+1);
 //            if s_spos <> 0;
 //               inquote(in_string :s_spos :s_inquote);
 //               dow s_inquote = 'Y';
 //                  s_spos = %scan(':' :in_string :s_spos+1);
 //                  if s_spos <> 0;
 //                     inquote(in_string :s_spos :s_inquote);
 //                  else;
 //                     s_inquote = 'N';
 //                  endif;
 //               enddo;
 //            endif;
 //         elseif s_pos > s_Epos;
 //            s_Epos = %scan(':' :in_string :s_pos+1);
 //            if s_epos <> 0;
 //               inquote(in_string :s_epos :s_inquote);
 //               dow s_inquote = 'Y';
 //                  s_epos = %scan(':' :in_string :s_epos+1);
 //                  if s_epos <> 0;
 //                     inquote(in_string :s_epos :s_inquote);
 //                  else;
 //                     s_inquote = 'N';
 //                  endif;
 //               enddo;
 //            endif;
 //            s_Spos = %scan('(' :in_string :s_pos+1);
 //            if s_spos <> 0;
 //               inquote(in_string :s_spos :s_inquote);
 //               dow s_inquote = 'Y';
 //                  s_spos = %scan(':' :in_string :s_spos+1);
 //                  if s_spos <> 0;
 //                     inquote(in_string :s_spos :s_inquote);
 //                  else;
 //                     s_inquote = 'N';
 //                  endif;
 //               enddo;
 //            endif;
 //         endif;
 //      else;
 //         s_Spos = s_Epos + 1;
 //      endif;
 //   enddo;
 //
 //   ss_refact1 = %subst(in_string :start+1 :s_Epos-start-1);
 //   ss_refact1 = RMVbrackets(ss_refact1);
      if SS_refact1 <> *Blanks;
         In_string1 = ss_refact1;
         split_component_5(In_string1 :arr : arrOpr :i);
      Else;
         return;
      Endif;
      i += 1;
      ss_reseq = in_seq;
      for j = 1 to i-1;
         if j <= %elem(arr) and arr(j) <> *Blanks;
            arr_var = %trim(arr(j));
            if %scan('(' : arr_var) = 1;
               arr(j) = RMVbrackets(arr(j));
            endif;
            s_Epos    = %scan('%'  :arr_var);
            s_Spos    = %scan('''' :arr_var);
            if s_Spos = 0;
               s_Spos = %scan('"' :arr_var);
            endif;
            ss_recomp = arrOpr(j);
            select;
            when s_Spos <> 0 and s_Spos < s_Epos;
               ss_refact1 = 'CONST(' + %trim(arr(j)) + ')';
               if i = 2;
                  leave;
               endif;
               sk_refact1  = ss_refact1 ;
               sk_refact2  = ss_refact2;
               clear ss_refact2;
               ss_reseq    += 1;
               ss_recontin = 'AND';
               clear ss_rebif;

                If %scan('.' : sk_refact1) > 0 and                                            //MT01
                   %scan('Const(' : %trim(sk_refact1)) =  0;                                  //MT01
                   sk_refact1= %subst(sk_refact1: %scan('.' :sk_refact1) + 1);                //MT01
                Endif;                                                                        //MT01
                If %scan('.' : sk_refact2) > 0 and                                            //MT01
                   %scan('Const(' : %trim(sk_refact2)) =  0;                                  //MT01
                   sk_refact2= %subst(sk_refact2: %scan('.' : sk_refact2)+ 1);                //MT01
                Endif;                                                                        //MT01
                If %scan('.' : ss_reresult) > 0 and                                           //MT01
                   %scan('Const(' : %trim(ss_reresult) ) = 0;                                 //MT01
                   ss_reresult = %subst(ss_reresult :                                         //MT01
                                               %scan('.' : ss_reresult) + 1);
                Endif;                                                                        //MT01

               iavarrellog(in_srclib    :
                           in_srcspf    :
                           in_srcmbr    :
                           in_ifsloc    :                                                //0005
                           ss_reseq     :
                           in_rrn       :
                           ss_reroutine :
                           ss_rereltyp  :
                           ss_rerelnum  :
                           ss_reopc     :
                           ss_reresult  :
                           ss_rebif     :
                           sk_refact1   :
                           ss_recomp    :
                           sk_refact2   :
                           ss_recontin  :
                           ss_reresind  :
                           ss_recat1    :
                           ss_recat2    :
                           ss_recat3    :
                           ss_recat4    :
                           ss_recat5    :
                           ss_recat6    :
                           ss_reutil    :
                           ss_renum1    :
                           ss_renum2    :
                           ss_renum3    :
                           ss_renum4    :
                           ss_renum5    :
                           ss_renum6    :
                           ss_renum7    :
                           ss_renum8    :
                           ss_renum9    :
                           ss_reexc     :
                           ss_reinc );

            when s_Epos <> 0 and (s_Spos > s_Epos or s_Spos = 0);
               s_pos      = %scan('(' :arr(j) :s_Epos);
               if s_pos   <> 0 ;
                 ss_rebif = %subst(arr(j) :s_Epos :s_pos-s_Epos);
               Else;
                 ss_rebif = arr(j);
               EndIf;

               string     = '~' + %subst(%trim(arr(j)) :s_Epos);
               ss_refact1 = *blanks;
               clear ss_refact2;
               clear sk_refact1;
               clear sk_refact1;

             //Callbif(in_srclib  :                                                      //0005
             //        in_srcspf  :                                                      //0005
             //        in_srcmbr  :                                                      //0005
               callbif(in_uWSrcDtl:                                                      //0005
                       In_rrn     :
                       ss_reseq   :
                       s_bkseq    :
                       ss_REOPC   :
                       sk_refact1 :
                       sk_refact2 :
                       in_type    :
                       ss_RECOMP  :
                       ss_reBIF   :
                       flag       :
                       field2     :
                       string     :
                       field4 );
            other;
               select ;
               when s_Spos <> 0;
                  clear Ss_rebif;
                  SK_refact1 = 'CONST(' + %trim(arr(j)) + ')';
               when %check('.0123456789' :%Trim(arr(j))) <> 0;
                  Sk_refact1 = %trim(arr(j));
               other ;
                  clear Ss_rebif;
                  Sk_refact1 = 'CONST(' + %trim(arr(j)) + ')';
               endsl;
               if i = 2;
                  leave;
               endif;
               ss_reseq += 1;
               ss_recontin = 'AND';
               clear ss_refact2;

                If %scan('.' : sK_refact1) > 0 and                                            //MT01
                   %scan('Const(' : %trim(sK_refact1)) =  0;                                  //MT01
                   sK_refact1= %subst(sK_refact1: %scan('.' :sK_refact1) + 1);                //MT01
                Endif;                                                                        //MT01
                If %scan('.' : sK_refact2) > 0 and                                            //MT01
                   %scan('Const(' : %trim(sK_refact2)) =  0;                                  //MT01
                   sK_refact2= %subst(sK_refact2: %scan('.' : sK_refact2)+ 1);                //MT01
                Endif;                                                                        //MT01
                If %scan('.' : ss_reresult) > 0 and                                           //MT01
                   %scan('Const(' : %trim(ss_reresult) ) = 0;                                 //MT01
                   ss_reresult = %subst(ss_reresult :                                         //MT01
                                           %scan('.' : ss_reresult) + 1);
                Endif;                                                                        //MT01

               iavarrellog(in_srclib    :
                           in_srcspf    :
                           in_srcmbr    :
                           in_ifsloc    :                                                //0005
                           ss_reseq     :
                           in_rrn       :
                           ss_reroutine :
                           ss_rereltyp  :
                           ss_rerelnum  :
                           ss_reopc     :
                           ss_reresult  :
                           ss_rebif     :
                           sK_refact1   :
                           ss_recomp    :
                           sK_refact2   :
                           ss_recontin  :
                           ss_reresind  :
                           ss_recat1    :
                           ss_recat2    :
                           ss_recat3    :
                           ss_recat4    :
                           ss_recat5    :
                           ss_recat6    :
                           ss_reutil    :
                           ss_renum1    :
                           ss_renum2    :
                           ss_renum3    :
                           ss_renum4    :
                           ss_renum5    :
                           ss_renum6    :
                           ss_renum7    :
                           ss_renum8    :
                           ss_renum9    :
                           ss_reexc     :
                           ss_reinc );
               clear ss_refact1;
               clear sk_refact1;
            endsl;
         endif;
      endfor;
      in_seq = ss_reseq;
   endif;

   return;

end-proc;

//----------------------------------------------------------------------------- //
//IaDecBif :
//----------------------------------------------------------------------------- //
dcl-proc iadecbif export;
   dcl-pi iadecbif;
      in_string  char(5000);
      in_opcode  char(10);
      in_type    char(10);
  //  in_srclib  char(10);                                                               //0005
  //  in_srcspf  char(10);                                                               //0005
  //  in_srcmbr  char(10);                                                               //0005
      in_uWSrcDtl likeds(uWSrcDtl);                                                      //0005
      in_RRN     packed(6:0);
      mt_refact1 char(80);
      mt_refact2 char(80);
      in_Seq     packed(6:0);
   end-pi;

   dcl-s arr          char(600)      inz dim(600);                                       //MT03
   dcl-s out_Array    char(600)      dim(600);                                           //MT03
   dcl-s out_Arrayopr char(1)        dim(600);                                           //MT03
   dcl-s flag         char(10)       inz;
   dcl-s field2       char(500)      inz;
   dcl-s d_inquote    char(1)        inz;
   dcl-s String       char(5000)     inz;
   dcl-s field4       char(5000)     inz;
   dcl-s In_String1   varchar(5000);
   dcl-s d_bkfact2    varchar(5000)  inz;
   dcl-s d_bkfact1    varchar(5000)  inz;
   dcl-s out_NoOfElm  packed(4:0);
   dcl-s d_pos        packed(6:0)    inz;
   dcl-s d_Spos       packed(6:0)    inz;
   dcl-s d_Epos       packed(6:0)    inz;
   dcl-s start        packed(6:0)    inz;
   dcl-s i            packed(6:0)    inz;
   dcl-s j            packed(4:0)    inz;
   dcl-s d_bkseq      packed(6:0)    inz;
   dcl-s tr_Bracket   packed(4:0)    inz;
   dcl-s c            char(1)        inz;
   dcl-s arr_var      char(600)      inz;

   if in_string = *Blanks;
      return;
   endif;
   clear mt_IAVARRELDS;

   uwsrcdtl = In_uwsrcdtl;                                                               //0005

   in_string = %xlate(LOWER :UPPER :in_string);
   d_pos     = %scan('~' :in_string :1);
   in_string = %replace('' :in_string :d_pos :1);
   d_pos = %scan('%DEC'   :in_string :d_pos);
   if d_pos <> 0;
      for i = d_pos +4 to %len(%trim(in_string));
          c = %subst(in_string:i:1);
          select;
          when c = '(';
             inquote(in_string :i :d_inquote);
             if d_inquote = 'N';
                if start = 0;
                   start = i;
                else;
                   tr_bracket +=1;
                endif;
             endif;
          when c = ')';
             inquote(in_string :i :d_inquote);
             if d_inquote = 'N';
                if tr_bracket =0;
                   if start >= *zeros and i-start > 1 ;                                  //PJ01
                      d_bkfact1 = %subst(in_string :start+1 :i-start-1);
                   endif ;                                                               //PJ01
                   leave;
                endif;
                tr_bracket -=1;
             endif;
          when c = ':';
             inquote(in_string :i :d_inquote);
             if d_inquote = 'N';
                if tr_bracket = 0;
                   if start >= *zeros and i-start > 1 ;                                  //PJ01
                      d_bkfact1 = %subst(in_string :start+1 :i-start-1);
                   endif ;                                                               //PJ01
                   leave;
                endif;
             endif;
          other;
          endsl;
      endfor;
 //if %scan('%DEC'   :in_string :d_pos) <> 0;
 //   d_pos  =  %scan('(' :in_string :d_pos);
 //   start  =  d_pos;
 //   d_Spos = %scan('(' :in_string :d_pos+1);
 //   if d_spos <> 0;
 //      inquote(in_string :d_spos :d_inquote);
 //      dow d_inquote = 'Y';
 //         d_Spos = %scan('(' :in_string :d_spos+1);
 //         if d_spos <> 0;
 //            inquote(in_string :d_spos :d_inquote);
 //         else;
 //            d_inquote = 'N';
 //         endif;
 //      enddo;
 //   endif;
 //
 //   d_Epos = %scan(':' :in_string :d_pos+1);
 //   if d_epos <> 0;
 //      inquote(in_string :D_epos :D_inquote);
 //      dow d_inquote = 'Y';
 //         d_epos = %scan(':' :in_string :d_epos+1);
 //         if d_epos <> 0;
 //            inquote(in_string :d_epos :d_inquote);
 //         else;
 //            d_inquote = 'N';
 //         endif;
 //      enddo;
 //   endif;
 //
 //   dow d_Spos < d_Epos;
 //      if d_Spos <> 0;
 //         findcbr(d_Spos :in_string);
 //         d_pos = d_Spos;
 //         if d_pos < d_Epos;
 //            d_Spos = %scan('(' :in_string :d_pos+1);
 //            if d_spos <> 0;
 //               inquote(in_string :d_spos :d_inquote);
 //               dow d_inquote = 'Y';
 //                  d_spos = %scan(':' :in_string :d_spos+1);
 //                  if d_spos <> 0;
 //                     inquote(in_string :d_spos :d_inquote);
 //                  else;
 //                     d_inquote = 'N';
 //                  endif;
 //               enddo;
 //            endif;
 //         elseif d_pos > d_Epos;
 //            d_Epos = %scan(':' :in_string :d_pos+1);
 //            if d_epos <> 0;
 //               inquote(in_string :d_epos :d_inquote);
 //               dow d_inquote = 'Y';
 //                  d_epos = %scan(':' :in_string :d_epos+1);
 //                  if d_epos <> 0;
 //                     inquote(in_string :d_epos :d_inquote);
 //                  else;
 //                     d_inquote = 'N';
 //                  endif;
 //               enddo;
 //            endif;
 //
 //            d_Spos = %scan('(' :in_string :d_pos+1);
 //            if d_spos <> 0;
 //               inquote(in_string :d_spos :d_inquote);
 //               dow d_inquote = 'Y';
 //                  d_spos = %scan(':' :in_string :d_spos+1);
 //                  if d_spos <> 0;
 //                     inquote(in_string :d_spos :d_inquote);
 //                  else;
 //                     d_inquote = 'N';
 //                  endif;
 //               enddo;
 //            endif;
 //         endif;
 //      else;
 //         d_Spos = d_Epos + 1;
 //      endif;
 //   enddo;
 //
 //   if d_Epos <> 0;
 //      d_bkfact1 = %subst(in_string :start+1 :d_Epos-start-1);
 //   else;
 //      d_Epos    = %scan(')' :in_string :start+1);
 //      d_Epos    = start ;
 //      findcbr( d_Epos : in_string );
 //      d_bkfact1 = %subst(in_string :start+1 :d_Epos-start-1);
 //   endif;

      d_bkfact1  = RMVbrackets(d_bkfact1);
      mt_reseq   = in_seq;
      in_string1 = d_bkfact1;
      split_component_5(in_string1:out_Array:out_Arrayopr:out_NoOfElm );

      i = out_NoOfElm + 1;

      for j = 1 to i-1;
         if j <= %elem(out_Array) and out_Array(j) <> *Blanks;
            arr_var = %trim(out_Array(j));
            if %scan('(' :arr_var) = 1;
               out_Array(j) = RMVbrackets(out_Array(j));
            endif;
            d_Epos = %scan('%'  : arr_var);
            d_Spos = %scan('''' : arr_var);
            if d_Spos = 0;
               d_Spos = %scan('"' : arr_var);
            endif;
            mt_recomp  = out_Arrayopr(J) ;
            clear mt_refact2;
            select;
            when d_Spos <> 0 and d_Spos < d_Epos;
               mt_refact1 = 'CONST(' + %trim(out_Array(j)) + ')';
               if i = 2;
                  leave;
               endif;
               mt_reseq += 1;
               mt_recontin = 'AND';

               iavarrellog(in_srclib    :
                           in_srcspf    :
                           in_srcmbr    :
                           in_ifsloc    :                                                //0005
                           mt_reseq     :
                           in_rrn       :
                           mt_reroutine :
                           mt_rereltyp  :
                           mt_rerelnum  :
                           mt_reopc     :
                           mt_reresult  :
                           mt_rebif     :
                           mt_refact1   :
                           mt_recomp    :
                           mt_refact2   :
                           mt_recontin  :
                           mt_reresind  :
                           mt_recat1    :
                           mt_recat2    :
                           mt_recat3    :
                           mt_recat4    :
                           mt_recat5    :
                           mt_recat6    :
                           mt_reutil    :
                           mt_renum1    :
                           mt_renum2    :
                           mt_renum3    :
                           mt_renum4    :
                           mt_renum5    :
                           mt_renum6    :
                           mt_renum7    :
                           mt_renum8    :
                           mt_renum9    :
                           mt_reexc     :
                           mt_reinc );

            when d_Epos <> 0 and (d_Spos > d_Epos or d_Spos = 0);
               d_pos      = %scan('(' :out_Array(j) :d_Epos);
               if d_pos <> 0;
                  mt_rebif   = %subst(out_Array(j) :d_Epos :d_pos-d_Epos);
               Else;
                  mt_rebif = out_Array(j);
               EndIf;

               string     = '~' + %subst(%trim(out_Array(j)) :d_Epos);

             //Callbif(in_srclib  :                                                      //0005
             //        in_srcspf  :                                                      //0005
             //        in_srcmbr  :                                                      //0005
               callbif(in_uWSrcDtl:                                                      //0005
                       In_rrn     :
                       mt_reseq   :
                       d_bkseq    :
                       mt_REOPC   :
                       mt_refact1 :
                       mt_refact2 :
                       in_type    :
                       mt_RECOMP  :
                       mt_reBIF   :
                       flag       :
                       field2     :
                       string     :
                       field4 );
            other;
               if d_Spos <> 0;
                  mt_refact1 = 'CONST(' + %trim(out_Array(j)) + ')';
               elseif %check('.0123456789' :%trim(out_Array(j))) <> 0;
                  mt_refact1 = %trim(out_Array(j));
               else;
                  mt_refact1 = 'CONST(' + %trim(out_Array(j)) + ')';
               endif;
               if i = 2;
                  leave;
               endif;

               If %trim(mt_refact1) =  'CONST()' ;
               Else ;
                  mt_reseq += 1;
                  mt_recontin = 'AND';
                  iavarrellog(in_srclib    :
                              in_srcspf    :
                              in_srcmbr    :
                              in_ifsloc    :                                             //0005
                              mt_reseq     :
                              in_rrn       :
                              mt_reroutine :
                              mt_rereltyp  :
                              mt_rerelnum  :
                              mt_reopc     :
                              mt_reresult  :
                              mt_rebif     :
                              mt_refact1   :
                              mt_recomp    :
                              mt_refact2   :
                              mt_recontin  :
                              mt_reresind  :
                              mt_recat1    :
                              mt_recat2    :
                              mt_recat3    :
                              mt_recat4    :
                              mt_recat5    :
                              mt_recat6    :
                              mt_reutil    :
                              mt_renum1    :
                              mt_renum2    :
                              mt_renum3    :
                              mt_renum4    :
                              mt_renum5    :
                              mt_renum6    :
                              mt_renum7    :
                              mt_renum8    :
                              mt_renum9    :
                              mt_reexc     :
                              mt_reinc );
               EndIf ;
               clear mt_recontin ;
            endsl;
            clear mt_refact1;
         endif;
      endfor;
      in_seq = mt_reseq;
   endif;

   return;

end-proc;

//---------------------------------------------------------------------------- //
//CallBif :
//---------------------------------------------------------------------------- //
dcl-proc callbif export;
   dcl-pi callbif;
  //  in_srclib  char(10);                                                               //0005
  //  in_srcspf  char(10);                                                               //0005
  //  in_srcmbr  char(10);                                                               //0005
      in_uWSrcDtl likeds(uWSrcDtl);                                                      //0005
      in_rrn     packed(6:0);
      in_Seq     packed(6:0);
      in_bkseq   packed(6:0);
      in_opcode  char(10);
      In_factor1 char(80);
      In_factor2 char(80);
      in_type    char(10);
      in_CONT    char(10);
      in_bif     char(10);
      in_flag    char(10);
      in_field2  char(500);
      in_String  char(5000);
      in_field4  char(5000);
   end-pi;

   dcl-ds IAVARRELDS extname('IAVARREL') prefix(Fl_) inz;
   end-ds;

   dcl-s un_seq packed(6:0) inz;
   dcl-s qualfd_dotpos      packed(3:0) inz;                                             //MT01

   dcl-c w_lo                 'abcdefghijklmnopqrstuvwxyz';
   dcl-c w_Up                 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

   un_seq = in_seq;
   clear IAVARRELDS;

   uwsrcdtl = In_uwsrcdtl;                                                               //0005
   in_seq       = un_seq;
   Fl_RERESULT  =  in_field2;
   Fl_REOPC     =  in_opcode;
   Fl_RECONTIN  =  'AND';
   Fl_RECOMP    =  in_cont;
   Fl_reseq     =  in_Seq;
   Fl_rebif     =  in_bif;

   exsr wrtVarref;

   select;
   //****************** Procedure (%scan) ****************** *//
   when %trim(in_bif) = '%SCAN';
      IAPSRSCN(in_String  :
               in_opcode  :
               in_type    :
            // in_srclib  :                                                              //0005
            // in_srcspf  :                                                              //0005
            // in_srcmbr  :                                                              //0005
               in_uWSrcDtl:                                                              //0005
               In_rrn     :
               In_factor1 :
               In_factor2 :
               Fl_reseq );

   //****************** Procedure (%len) ****************** *//
   when %trim(in_bif) = '%LEN';
      IAPSRLEN(in_String  :
               in_opcode  :
               in_type    :
            // in_srclib  :                                                              //0005
            // in_srcspf  :                                                              //0005
            // in_srcmbr  :                                                              //0005
               in_uWSrcDtl:                                                              //0005
               In_rrn     :
               In_factor1 :
               In_factor2 :
               Fl_reseq );

   //****************** Procedure (%Char) ****************** *//
   when %trim(in_bif) = '%CHAR';
      IAPSRCHARFR(in_string  :
                  in_opcode  :
                  in_type    :
               // in_srclib  :                                                           //0005
               // in_srcspf  :                                                           //0005
               // in_srcmbr  :                                                           //0005
                  in_uWSrcDtl:                                                           //0005
                  In_rrn     :
                  In_factor1 :
                  In_factor2 :
                  Fl_reseq );

   //****************** Procedure (%Trim) ****************** *//
   when %trim(in_bif) = '%TRIM' Or %trim(in_bif) = '%TRIML' Or
        %trim(in_bif) = '%TRIMR' ;
      IAPSRTRM(in_string  :
               in_opcode  :
               in_type    :
            // in_srclib  :                                                           //0005
            // in_srcspf  :                                                           //0005
            // in_srcmbr  :                                                           //0005
               in_uWSrcDtl:                                                           //0005
               In_rrn     :
               In_factor1 :
               In_factor2 :
               Fl_reseq );

   //****************** Procedure (%lookup) **************** *//
// when %trim(in_bif) = '%LOOKUP';
   when %trim(in_bif) = '%LOOKUP'    or
        %trim(in_bif) = '%TLOOKUP'   or
        %trim(in_bif) = '%LOOKUPLT'  or
        %trim(in_bif) = '%LOOKUPLE'  or
        %trim(in_bif) = '%LOOKUPGT'  or
        %trim(in_bif) = '%LOOKUPGE';
      IALOOKUPBIF(in_string  :
                  in_opcode  :
                  in_type    :
               // in_srclib  :                                                           //0005
               // in_srcspf  :                                                           //0005
               // in_srcmbr  :                                                           //0005
                  in_uWSrcDtl:                                                           //0005
                  In_rrn     :
                  In_factor1 :
                  In_factor2 :
                  Fl_reseq );

   //****************** Procedure (%subst) **************** *//
   when %trim(in_bif) = '%SUBST';
      IASUBSTTBIF(in_string  :
                  in_opcode  :
                  in_type    :
               // in_srclib  :                                                           //0005
               // in_srcspf  :                                                           //0005
               // in_srcmbr  :                                                           //0005
                  in_uWSrcDtl:                                                           //0005
                  In_rrn     :
                  In_factor1 :
                  In_factor2 :
                  Fl_reseq );

   //****************** Procedure (%replace) *************** *//
   when %trim(in_bif) = '%REPLACE'                                                            //BS04
        or %trim(in_bif) = '%SCANRPL';                                                        //BS04
      IAREPLACE(in_string  :
                in_opcode  :
                in_type    :
             // in_srclib  :                                                           //0005
             // in_srcspf  :                                                           //0005
             // in_srcmbr  :                                                           //0005
                in_uWSrcDtl:                                                           //0005
                In_rrn     :
                In_factor1 :
                In_factor2 :
                Fl_reseq );

   //****************** Procedure (%Timestamp) ************* *//
   when %trim(in_bif) = '%TIMESTAMP';
      IATIMEBIF(in_string  :
                in_opcode  :
                in_type    :
             // in_srclib  :                                                           //0005
             // in_srcspf  :                                                           //0005
             // in_srcmbr  :                                                           //0005
                in_uWSrcDtl:                                                           //0005
                In_rrn     :
                In_factor1 :
                In_factor2 :
                Fl_reseq );

   //****************** Procedure (%xfoot) **************** *//
   when %trim(in_bif) = '%XFOOT';
      IAPSRXFFR(in_string  :
                in_opcode  :
                in_type    :
             // in_srclib  :                                                           //0005
             // in_srcspf  :                                                           //0005
             // in_srcmbr  :                                                           //0005
                in_uWSrcDtl:                                                           //0005
                In_rrn     :
                In_factor1 :
                In_factor2 :
                Fl_reseq );

   //****************** Procedure (%XLATE) ***************** *//
   when %trim(in_bif) = '%XLATE';
      IAXLTBIF(in_string  :
               in_opcode  :
               in_type    :
            // in_srclib  :                                                           //0005
            // in_srcspf  :                                                           //0005
            // in_srcmbr  :                                                           //0005
               in_uWSrcDtl:                                                           //0005
               In_rrn     :
               In_factor1 :
               In_factor2 :
               Fl_reseq );

   //****************** Procedure (%DAYS) ****************** *//
   when %trim(in_bif) = '%DAYS';
      IADAYS(in_String  :
             in_opcode  :
             in_type    :
          // in_srclib  :                                                           //0005
          // in_srcspf  :                                                           //0005
          // in_srcmbr  :                                                           //0005
             in_uWSrcDtl:                                                           //0005
             In_rrn     :
             In_factor1 :
             In_factor2 :
             Fl_reseq );

   //****************** Procedure (%EDITW) ***************** *//
   when %trim(in_bif) = '%EDITW';
      IAPSREDITW(in_String  :
                 in_opcode  :
                 in_type    :
              // in_srclib  :                                                           //0005
              // in_srcspf  :                                                           //0005
              // in_srcmbr  :                                                           //0005
                 in_uWSrcDtl:                                                           //0005
                 In_rrn     :
                 In_factor1 :
                 In_factor2 :
                 Fl_reseq );

   //****************** Procedure (%EDITC) ***************** *//
   when %trim(in_bif) = '%EDITC';
      IAPSREDITC(in_String  :
                 in_opcode  :
                 in_type    :
              // in_srclib  :                                                           //0005
              // in_srcspf  :                                                           //0005
              // in_srcmbr  :                                                           //0005
                 in_uWSrcDtl:                                                           //0005
                 In_rrn     :
                 In_factor1 :
                 In_factor2 :
                 Fl_reseq );

   //****************** Procedure (%INT) ******************* *//
   when %trim(in_bif) = '%INT'or %trim(in_bif) = '%INTH';
      IAINTBIF(in_string  :
               in_opcode  :
               in_type    :
            // in_srclib  :                                                           //0005
            // in_srcspf  :                                                           //0005
            // in_srcmbr  :                                                           //0005
               in_uWSrcDtl:                                                           //0005
               In_rrn     :
               In_factor1 :
               In_factor2 :
               Fl_reseq );

   //****************** Procedure (%REM) ******************* *//
   when %trim(in_bif) = '%REM';
      IAREMBIF(in_string  :
               in_opcode  :
               in_type    :
            // in_srclib  :                                                           //0005
            // in_srcspf  :                                                           //0005
            // in_srcmbr  :                                                           //0005
               in_uWSrcDtl:                                                           //0005
               In_rrn     :
               In_factor1 :
               In_factor2 :
               Fl_reseq );

   //****************** Procedure (%DEC) ******************* *//
   when %trim(in_bif) = '%DEC' OR  %trim(in_bif) = '%DECH';
      IADECBIF(in_string  :
               in_opcode  :
               in_type    :
            // in_srclib  :                                                           //0005
            // in_srcspf  :                                                           //0005
            // in_srcmbr  :                                                           //0005
               in_uWSrcDtl:                                                           //0005
               In_rrn     :
               In_factor1 :
               In_factor2 :
               Fl_reseq ) ;

   //****************** Procedure (%DIV) ******************* *//
   when %trim(in_bif) = '%DIV';
      IADIVBIF(in_string  :
               in_opcode  :
               in_type    :
            // in_srclib  :                                                           //0005
            // in_srcspf  :                                                           //0005
            // in_srcmbr  :                                                           //0005
               in_uWSrcDtl:                                                           //0005
               In_rrn     :
               In_factor1 :
               In_factor2 :
               Fl_reseq ) ;

   //****************** Procedure (%Date) ****************** *//
   when %trim(in_bif) = '%DATE';
      IAPSRDAT(in_string  :
               in_opcode  :
               in_type    :
            // in_srclib  :                                                           //0005
            // in_srcspf  :                                                           //0005
            // in_srcmbr  :                                                           //0005
               in_uWSrcDtl:                                                           //0005
               In_rrn     :
               In_factor1 :
               In_factor2 :
               Fl_reseq );

   when %trim(in_bif) = '%CHECK' or %trim(in_bif) = '%CHECKR';                           //YK01
      IAPSRCHK(in_string  :                                                              //YK01
               in_opcode  :                                                              //YK01
               in_type    :                                                              //YK01
            // in_srclib  :                                                              //0005
            // in_srcspf  :                                                              //0005
            // in_srcmbr  :                                                              //0005
               in_uWSrcDtl:                                                              //0005
               in_rrn     :                                                              //YK01
               In_factor1 :                                                              //YK01
               In_factor2 :                                                              //YK01
               in_seq     );                                                             //YK01

   //****************** Procedure (14 other BIFs) ****************** *//                //SK05
   When  %trim(in_bif) = '%ABS'     or %trim(in_bif) = '%DECPOS' or                      //SK05
         %trim(in_bif) = '%DIFF'    or %trim(in_bif) = '%FLOAT' or                       //SK05
         %trim(in_bif) = '%HOURS'   or %trim(in_bif) = '%MINUTES' or                     //SK05
         %trim(in_bif) = '%MONTHS'  or %trim(in_bif) = '%SECONDS' or                     //SK05
         %trim(in_bif) = '%SQRT'    or %trim(in_bif) = '%STR' or                         //SK05
         %trim(in_bif) = '%TIME'    or %trim(in_bif) = '%UNS' or                         //SK05
         %trim(in_bif) = '%UNSH'    or %trim(in_bif) = '%YEARS' or                       //0002
         %trim(in_bif) = '%SUBARR';                                                      //0002
      IAPSRBIF(in_string  :                                                              //SK05
               in_opcode  :                                                              //SK05
               in_type    :                                                              //SK05
            // in_srclib  :                                                              //0005
            // in_srcspf  :                                                              //0005
            // in_srcmbr  :                                                              //0005
               in_uWSrcDtl:                                                              //0005
               in_rrn     :                                                              //SK05
               In_factor1 :                                                              //SK05
               In_factor2 :                                                              //SK05
               Fl_reseq   );                                                             //SK05
   other;

   endSl;

   in_bkseq    = Fl_RESEQ;
   Fl_REFACT1  = In_factor1;
   Fl_REFACT2  = In_factor2;
   Fl_RECONTIN = 'AND';
   in_seq      = un_seq+1;
   exsr UpdVarref;
   clear in_factor1;
   clear in_bif;
   clear in_factor2;
   in_seq      = in_bkseq;

   return;

   begsr wrtvarref;

      Fl_RESRCLIB = in_srclib;
      Fl_RESRCFLN = in_srcspf;
      Fl_REPGMNM  = in_srcmbr;
      Fl_REIFSLOC = in_ifsloc;                                                           //0005

      if in_seq   = 0;
         Fl_RESEQ = 1;
         in_seq   = Fl_reseq;
      else;
         Fl_RESEQ = Fl_RESEQ+1;
         in_seq   = Fl_RESEQ;
      endif;

      Fl_RERRN  = In_rrn;
      Fl_RENUM1 = 0;
      Fl_RENUM2 = 0;
      Fl_RENUM3 = 0;
      Fl_RENUM4 = 0;
      Fl_RENUM5 = 0;
      Fl_RENUM6 = 0;
      Fl_RENUM7 = 0;
      Fl_RENUM8 = 0;
      Fl_RENUM9 = 0;

    //If %scan('Const(' : %trim(Fl_RERESULT) ) = 0;                                    //MT01
      If %scan('CONST(' : %xlate(w_lo:w_Up:(%trim(Fl_RERESULT)))) = 0;         //MT01  //SK05
         qualfd_dotpos = %scan('.' : Fl_RERESULT);
         Dow qualfd_dotpos <> 0 ;                                                      //MT01
            Fl_RERESULT = %subst(Fl_RERESULT : %scan('.' :Fl_RERESULT)+ 1);            //MT01
            qualfd_dotpos = %scan('.' : Fl_RERESULT: 1);
         Enddo;
      Endif;                                                                           //MT01

      IAVARRELLOG(Fl_RESRCLIB  :
                  Fl_RESRCFLN  :
                  Fl_REPGMNM   :
                  Fl_REIFSLOC  :                                                         //0005
                  Fl_RESEQ     :
                  Fl_RERRN     :
                  Fl_REROUTINE :
                  Fl_RERELTYP  :
                  Fl_RERELNUM  :
                  Fl_REOPC     :
                  Fl_RERESULT  :
                  Fl_REBIF     :
                  Fl_REFACT1   :
                  Fl_RECOMP    :
                  Fl_REFACT2   :
                  Fl_RECONTIN  :
                  Fl_RERESIND  :
                  Fl_RECAT1    :
                  Fl_RECAT2    :
                  Fl_RECAT3    :
                  Fl_RECAT4    :
                  Fl_RECAT5    :
                  Fl_RECAT6    :
                  Fl_REUTIL    :
                  Fl_RENUM1    :
                  Fl_RENUM2    :
                  Fl_RENUM3    :
                  Fl_RENUM4    :
                  Fl_RENUM5    :
                  Fl_RENUM6    :
                  Fl_RENUM7    :
                  Fl_RENUM8    :
                  Fl_RENUM9    :
                  Fl_REEXC     :
                  Fl_REINC );
   endsr;

   begsr updvarref;

      Fl_RESRCLIB = in_srclib;
      Fl_RESRCFLN = in_srcspf;
      Fl_REPGMNM  = in_srcmbr;
      Fl_REIFSLOC = in_ifsloc;                                                           //0005
      Fl_REFACT1  = in_factor1;
      Fl_REFACT2  = in_factor2;
      Fl_REBIF    = in_bif;
      Fl_RERRN    = in_rrn;
      Fl_RENUM1   = 0;
      Fl_RENUM2   = 0;
      Fl_RENUM3   = 0;
      Fl_RENUM4   = 0;
      Fl_RENUM5   = 0;
      Fl_RENUM6   = 0;
      Fl_RENUM7   = 0;
      Fl_RENUM8   = 0;
      Fl_RENUM9   = 0;

   // If %scan('Const(' : %trim(Fl_REFACT1) ) = 0;                                       //MT01
      If %scan('CONST(' : %xlate(w_lo:w_Up:(%trim(Fl_REFACT1))) ) = 0;                   //SK05
         qualfd_dotpos = %scan('.' : Fl_REFACT1);
         Dow qualfd_dotpos <> 0 ;                                                        //MT01
            Fl_REFACT1  = %subst(Fl_REFACT1  : %scan('.' :Fl_REFACT1)+ 1);               //MT01
            qualfd_dotpos = %scan('.' : Fl_REFACT1 : 1);
         Enddo;
      Endif;                                                                             //MT01

   // If %scan('Const(' : %trim(Fl_REFACT2) ) = 0;                                       //MT01
      If %scan('CONST(' : %xlate(w_lo:w_Up:(%trim(Fl_REFACT2))) ) = 0;                   //SK05
         qualfd_dotpos = %scan('.' : Fl_REFACT2);
         Dow qualfd_dotpos <> 0 ;                                                        //MT01
            Fl_REFACT2  = %subst(Fl_REFACT2  : %scan('.' :Fl_REFACT2)+ 1);               //MT01
            qualfd_dotpos = %scan('.' : Fl_REFACT2 : 1);
         Enddo;
      Endif;                                                                             //MT01

      If Fl_REFACT1 = 'CONST()' ;
      Else;
         IAVARRELUPDLOG(Fl_RESRCLIB  :
                        Fl_RESRCFLN  :
                        Fl_REPGMNM   :
                        Fl_REIFSLOC  :                                                   //0005
                        in_SEQ       :
                        Fl_RERRN     :
                        Fl_REROUTINE :
                        Fl_RERELTYP  :
                        Fl_RERELNUM  :
                        Fl_REOPC     :
                        Fl_RERESULT  :
                        Fl_REBif     :
                        Fl_REFACT1   :
                        Fl_RECOMP    :
                        Fl_REFACT2   :
                        Fl_RECONTIN  :
                        Fl_RERESIND  :
                        Fl_RECAT1    :
                        Fl_RECAT2    :
                        Fl_RECAT3    :
                        Fl_RECAT4    :
                        Fl_RECAT5    :
                        Fl_RECAT6    :
                        Fl_REUTIL    :
                        Fl_RENUM1    :
                        Fl_RENUM2    :
                        Fl_RENUM3    :
                        Fl_RENUM4    :
                        Fl_RENUM5    :
                        Fl_RENUM6    :
                        Fl_RENUM7    :
                        Fl_RENUM8    :
                        Fl_RENUM9    :
                        Fl_REEXC     :
                        Fl_REINC );
      EndIf ;

   endsr;

end-proc;



//------------------------------------------------------------------------------- //
//Split_Component_6 :
//------------------------------------------------------------------------------- //
Dcl-proc SPLIT_COMPONENT_6 export;
   Dcl-pi  SPLIT_COMPONENT_6;
      in_string    varchar(5000);
      out_Array    char(600)     dim(600);                                               //MT03
      out_Arrayopr char(1)       dim(600);                                               //MT03
      out_NoOfElm  packed(4:0);
   End-pi;

   Dcl-pr IAPQUOTE;
      *n  char(5000);
      *n  packed(4:0);
      *n  char(1);
   End-pr;

   dcl-s arraysignpositions  packed(5)   inz dim(600) ascend;                             //MT03
 //dcl-s tempArray           packed(5)   inz dim(600) ascend; PJ01                        //MT03
   dcl-s arrayaddsign        packed(6:0) inz dim(600);                                    //MT03
   dcl-s arraysubsign        packed(6:0) inz dim(600);                                    //MT03
   dcl-s arraymulsign        packed(6:0) inz dim(600);                                    //MT03
   dcl-s arraydivsign        packed(6:0) inz dim(600);                                    //MT03
   dcl-s In_postion          packed(4:0) inz;
   dcl-s Sp_length           packed(4:0) inz;
   dcl-s Sp_length2          packed(4:0) inz;
   dcl-s intermediateAddPos  packed(6:0) inz;
   dcl-s intermediateSubPos  packed(6:0) inz;
   dcl-s intermediateMulPos  packed(6:0) inz;
   dcl-s frompos             packed(5:0) inz;
   dcl-s intermediateDivPos  packed(6:0) inz;
   dcl-s tr_Counter          packed(4:0) inz;
   dcl-s tr_Length           packed(4:0) inz;
   dcl-s tr_Brackets         packed(4:0) inz;
   dcl-s Count               packed(2:0) inz;
   dcl-s OBpos               packed(4:0) inz;
   dcl-s operatorArr         char(1)     inz dim(600) ascend;                             //MT03
   dcl-s SUBSETVARS          char(600)   inz dim(600) ascend;                             //MT03
   dcl-s br_inquote          char(1)     inz;
   dcl-s In_flag             char(1)     inz;
   dcl-s Sp_CONT             char(10)    inz;
   dcl-s CaptureFlg          char(1)     inz;
   dcl-s SP_constant         char(80)    inz;
   dcl-s Sp_field            char(5000)  inz;
   dcl-s In_string1          char(5000)  inz;
   dcl-s Sp_opcode           char(10)    inz;
   dcl-s In_bif              char(10)    inz;
   dcl-s i                   int(5)      inz;
   dcl-s j                   int(5)      inz;
   dcl-s k                   int(5)      inz;
   dcl-s l                   int(5)      inz;
   dcl-s Z                   int(5)      inz;
   dcl-s index               int(5)      inz;
   dcl-s itr                 int(5)      inz;
   dcl-s ndx                 int(5)      inz;
   dcl-s rdx                 int(5)      inz;
   dcl-s Pos                 int(5)      inz;
   dcl-s X                   int(5)      inz;
   dcl-s ins_manual          char(1)     inz;
   dcl-s same_process        char(1)     inz;
   dcl-s varprod             int(5)      inz;
   dcl-s varplus             int(5)      inz;
   dcl-s loop                int(5)      inz;

   dcl-c Ch_Quote            '''';
   dcl-c quote               '"';
   dcl-c SQL_ALL_OK          '00000';

   if In_string = *blanks ;                                                              //PJ01
      return ;                                                                           //PJ01
   endif ;                                                                               //PJ01
   Sp_length2 = %len(%trim(In_string));
   Sp_field   = %trim(In_string);
   intermediateAddPos = %scan('+' : Sp_field);
   if intermediateAddPos <> 0;
      inquote(Sp_field:intermediateAddPos:br_inquote);
      dow br_inquote = 'Y';
         intermediateAddPos= %scan('+' :Sp_field :intermediateAddPos+1);
         if intermediateAddPos <> 0;
            inquote(Sp_field:intermediateAddPos:br_inquote);
         else;
            br_inquote = 'N';
         endif;
      enddo;
   endif;

   Sp_field    = %trim(In_string);
   intermediateSubPos = %scan('-' : Sp_field);
   if intermediateSubPos <> 0;
      inquote(SP_field :intermediateSubPos:br_inquote);
      dow br_inquote = 'Y';
         intermediateSubPos= %scan('-' :Sp_field :intermediateSubPos+1);
         if intermediateSubPos <> 0;
            inquote(Sp_field:intermediateSubPos:br_inquote);
         else;
            br_inquote = 'N';
         endif;
      enddo;
   endif;

   Sp_field           = %trim(In_string);
   intermediateMulPos = %scan('*' : Sp_field);
   if intermediateMulPos <> 0;
      inquote(sp_field:intermediateMulPos:br_inquote);
      dow br_inquote = 'Y';
         intermediateMulPos= %scan('*' :Sp_field :intermediateMulPos+1);
         if intermediateMulPos <> 0;
            inquote(Sp_field :intermediateMulPos:br_inquote);
         else;
            br_inquote = 'N';
         endif;
      enddo;
   endif;

   Sp_field           = %trim(In_string);
   intermediateDivPos = %scan('/' : Sp_field);
   if intermediateDivPos <> 0;
      inquote(Sp_field:intermediateDivPos:br_inquote);
      dow br_inquote = 'Y';
         intermediateDivPos = %scan('/' :Sp_field :intermediateDivPos+1);
         if intermediateDivPos <> 0;
            inquote(Sp_field:intermediateDivPos:br_inquote);
         else;
            br_inquote = 'N';
         endif;
      enddo;
   endif;

   i = 0;
   frompos = 1;
   dow intermediateAddPos > 0 and i < %elem(arrayaddsign);                               //MT03
      i+=1;
      arrayaddsign(i) = intermediateaddPos;
      fromPos = intermediateaddPos + 1;
      if In_string <> *Blanks and fromPos > 0                                            //PJ01
         and %len(%trim(In_string)) >= fromPos;                                          //PJ01
      intermediateaddPos = %scan('+' : %trim(In_string) : fromPos);
      endif ;                                                                            //PJ01
   enddo;

   j = 0;
   frompos = 1;
   dow intermediateSubPos > 0 and j < %elem(arraySubsign);                               //MT03
      j+=1;
      arraySubsign(j) = intermediateSubPos;
      fromPos = intermediateSubPos + 1;
      if In_string <> *blanks and fromPos > 0                                            //PJ01
         and %len(%trim(In_string)) >= fromPos;                                          //PJ01
      intermediateSubPos = %scan('-' : %trim(In_string) :fromPos);
      endif ;                                                                            //PJ01
   enddo;

   k = 0;
   frompos = 1;
   dow intermediateMulPos > 0 and k < %elem(arraymulsign);                               //MT03
      k+=1;
      arraymulsign(k) = intermediateMulPos;
      fromPos = intermediateMulPos + 1;
      if In_string <> *blanks and fromPos > 0                                            //PJ01
         and %len(%trim(In_string)) >= fromPos;                                          //PJ01
      intermediateMulPos = %scan('*' : %trim(In_string): fromPos);
      endif ;                                                                            //PJ01
   enddo;

   l = 0;
   frompos = 1;
   dow intermediatedivPos > 0 and l < %elem(arraydivsign);                               //MT03
      l+=1;
      arraydivsign(l) = intermediatedivPos;
      fromPos = intermediatedivPos + 1;
      if In_string <> *blanks and fromPos > 0                                            //PJ01
         and %len(%trim(In_string)) >= fromPos;                                          //PJ01
      intermediatedivPos = %scan('/' : %trim(In_string) :fromPos);
      endif ;                                                                            //PJ01
   enddo;

   z = 0;
   for x = 1 to i;
      Z += 1;
      if z > %elem(arraysignpositions) or x > %elem(arrayaddsign);
        leave;
      endif;
      arraysignpositions(z) = arrayaddsign(x);
   endfor;

   for x = 1 to j;
      Z += 1;
      if z > %elem(arraysignpositions) or x > %elem(arraySubsign);
        leave;
      endif;
      arraysignpositions(z) = arraySubsign(x);
   endfor;

   for x = 1 to k;
      Z += 1;
      if z > %elem(arraysignpositions) or x > %elem(arrayMulsign);
        leave;
      endif;
      arraysignpositions(z) = arrayMulsign(x);
   endfor;

   for x = 1 to l;
      Z += 1;
      if z > %elem(arraysignpositions) or x > %elem(arrayDivsign);
        leave;
      endif;
      arraysignpositions(z) = arrayDivsign(x);
   endfor;

   //------sorting positions of sign occurance in ascending------ //
   //sorta arraysignpositions;                                                           //PJ01
   //tempArray = arraysignpositions;                                                     //PJ01
   //clear arraysignpositions;                                                           //PJ01
   //loop = %lookupGT(*zeros:tempArray);                                                 //PJ01
   //If Loop <> *zeros;                                                                  //PJ01
   //for itr = 1 to %elem(arraysignpositions);
   //  for itr = loop to %elem(arraysignpositions);                                      //PJ01
   //   if tempArray(itr) <> *zero;                                                      //PJ01
   //      index += 1;                                                                   //PJ01
   //      arraysignpositions(index) = tempArray(itr);                                   //PJ01
   //   endif;                                                                           //PJ01
   //  endfor;                                                                           //PJ01
   //endif;                                                                              //PJ01
   loop = %lookup(*zeros:arraysignpositions) ;                                           //PJ01
   //Sort array in case more than two elements. Only one element i.e. already sorted.   //PJ01
   if loop > 2 ;                                                                         //PJ01
      sorta %subarr(arraysignpositions:1:(loop-1)) ;                                     //PJ01
   elseif loop = *zeros ;                                                                //PJ01
      //In case all the elements of array are filled.                                   //PJ01
      sorta arraysignpositions ;                                                         //PJ01
   endif ;                                                                               //PJ01

   ndx = 1;
   pos = 1;
   rdx = 1;
 //dow arraysignpositions(ndx) <> *zeros;                                                //SK01
   dow ndx <= %elem(arraysignpositions) and arraysignpositions(ndx) <> *zeros;           //SK01
      CaptureFlg  = 'Y';
      tr_Brackets = 0;
      tr_Length   = %len(%trim(In_string));
      OBPOS       = 0;
      for tr_Counter = OBPos + 1 to tr_Length;
         select;
         when %subst(%trim(In_string):tr_Counter:1) = '(';
            In_string1 = In_string;
            In_postion = Tr_counter;
            IAPQUOTE(in_string1:In_postion:In_flag);
            if in_flag = 'N';
               tr_Brackets += 1;
            endif;
         when %subst(%trim(In_string):tr_Counter:1) = ')';
            In_string1 = In_string;
            In_postion = Tr_counter;
            IAPQUOTE(in_string1:In_postion:In_flag);
            if in_flag = 'N';
               tr_Brackets -= 1;
            endif;
         endsl;
         if arraysignpositions(ndx)  = tr_counter and tr_Brackets <> 0;
             CaptureFlg  = 'N';
             leave;
         endif;
      endfor;

      if CaptureFlg = 'Y';
         If arraysignpositions(ndx) <> 1 ;
            ins_manual = 'N';
            same_process = 'N';
         //*if arraysignpositions(ndx) is not equals to oprator position *//
            select;
            when arraysignpositions(ndx) <> pos;
         //*gets values/variables between two operators in subsetvars *//
               if pos > *zeros and arraysignpositions(ndx) - pos > *zeros ;              //PJ01
                  subsetVars(rdx) = %trim(%subst(%trim(In_string) : pos :
                                          arraysignpositions(ndx) - pos));
               endif ;                                                                   //PJ01
         //*if there is no value/variable between two opeartors --> consequetive operators *//
               if subsetVars(rdx) = *Blanks;
                  ins_manual = 'Y';
               endif;
            other;
               ins_manual = 'Y';
            endsl;
            if %lookup(arraysignpositions(ndx) : arrayaddsign) <> 0;
               varplus += 1;
         //*checks for multiple continuos occurance of operator '+' ex: 2+ +3//
               select;
               when varplus > 1 and ins_manual = 'Y';
                  rdx-=1;
                  same_process = 'Y';
               other;
                  operatorArr(rdx) = '+';
               endsl;
               varprod = 0;
            elseif %lookup(arraysignpositions(ndx) : arraySubsign) <> 0;
               if ins_manual = 'N';
                  operatorArr(rdx) = '-';
               endif;
               varprod = 0;
               varplus = 0;
            elseif %lookup(arraysignpositions(ndx) : arrayMulsign) <> 0;
               varprod += 1;
         //*checks for multiple continuos occurance of operator '*' ex: 2**3//
               select;
               when varprod >1 and ins_manual = 'Y';
                  if rdx-1 > 0;
                     rdx-=1;
                     operatorArr(rdx) = 'P';
                     same_process = 'Y';
                  endif;
               other;
                  operatorArr(rdx) = '*';
               endsl;
               varplus = 0;
            elseif %lookup(arraysignpositions(ndx) : arrayDivsign) <> 0;
               if ins_manual = 'N';
                  operatorArr(rdx) = '/';
               endif;
               varprod = 0;
               varplus = 0;
            endif;
         //*when there is no variable/value between two operators  //
            select;
            when ins_manual = 'Y' and same_process = 'N';
               pos = arraysignpositions(ndx-1) + 1;
            other;
         //*when there variable/value between two operators  //
               pos = arraysignpositions(ndx) + 1;
               rdx += 1;
            endsl;
         Endif;
      Endif;
      ndx += 1;
   enddo;

   Count = 1;
   if ndx <= %elem(arraysignpositions)
      and arraysignpositions(ndx) = *zeros and Count = 1;
      if In_string <> *blanks and %len(%trim(In_string)) >= pos
         and %len(%trim(In_string)) >= (Sp_length2+1) - pos
         and (Sp_length2+1) - pos  >0;
         subsetVars(rdx) = %trim(%subst(%trim(In_string): pos :
                              (Sp_length2+1) - pos));
      endif;
      Count +=1;
   endif;
   clear out_array ;
   clear out_arrayopr ;
   out_Array    = SUBSETVARS ;
   out_Arrayopr = operatorArr;
   out_NoOfElm  = rdx ;

   return ;
End-proc ;

//----------------------------------------------------------------------------- //
//ProcedureCallCheck :
//----------------------------------------------------------------------------- //
Dcl-proc ProcedureCallCheck;
   Dcl-pi ProcedureCallCheck;
      out_Array   char(600)    dim(600);                                                 //MT03
      out_NoOfElm packed(4:0);
   End-pi;

   //Procedure variable declaration
   dcl-s recFound          char(1)       inz;
   dcl-s ProcName          varchar(500)  inz;
   dcl-s BracketPosProc    packed(4:0)   inz;
   dcl-s ProcCount         packed(4:0)   inz;
   dcl-s Index             packed(4:0)   inz;

   for Index = 1 to out_NoOfElm;
      BracketPosProc =  %scan('(' :%trim(out_Array(Index)));

      If BracketPosProc > 1;

         ProcName = %SubSt( %trim(out_Array(Index)): 1 : BracketPosProc - 1 );

         exec sql
           select 'Y' as flag
             into :recFound
             from iaprcparm
             Where PROCEDURE_NAME = :ProcName
             fetch first row only;

         If SQLSTATE <> SQL_ALL_OK;
            //log error
         EndIf;

         If SQLSTATE = SQL_ALL_OK and recFound  = 'Y';
            out_Array(Index) = 'Const('+ ProcName + ')';
         EndIf;
      EndIf;
   Endfor;

   return ;
End-proc ;

//----------------------------------------------------------------------------------- //
//Split_Component_5 :
//----------------------------------------------------------------------------------- //
Dcl-proc SPLIT_COMPONENT_5 export;
   Dcl-pi  SPLIT_COMPONENT_5;
      in_string    varchar(5000);
      out_Array    char(600)     dim(600);                                               //MT03
      out_Arrayopr char(1)       dim(600);                                               //MT03
      out_NoOfElm  packed(4:0);
   End-pi;

   dcl-s Index             packed(4:0)    inz;
   dcl-s SplittedElements# Packed(4:0)    inz;
   dcl-s Sav_arr           char(600)      inz dim(600);                                  //MT03
   dcl-s New_arr           char(600)      inz dim(600);                                  //MT03
   //dcl-s bk_arrval         char(300)      inz;                                         //PS02
   dcl-s bk_arrval         char(600)      inz;                                           //PS02
   dcl-s Sav_arrOpr        char(1)      inz dim(600);                                    //MT03
   dcl-s New_arrOpr        char(1)      inz dim(600);                                    //MT03
   dcl-s Factor1           varchar(5000)  inz ;

   split_component_6(in_string: out_Array: out_Arrayopr: out_NoOfElm);

   //Check for Procedure call
   ProcedureCallCheck(out_Array: out_NoOfElm);
   //Save the input array values
   Sav_arr    = out_Array;
   Sav_arrOpr = out_Arrayopr;

   for Index = 1 to out_NoOfElm;

      //if %scan('(' :%subst(%trim(out_Array(Index)):1:1)) = 1;                          //PJ01
      if %scan('(' :%trim(out_Array(Index)):1) = 1 ;                                     //PJ01
         bk_arrval        = out_Array(Index);
         out_Array(Index) = RMVbrackets(out_Array(Index));
         If %trim(out_Array(Index)) = %trim(bk_arrval);
            leave;
         Endif;

         Factor1 = out_Array(Index) ;
         split_component_6(Factor1 :New_arr :New_arrOpr: SplittedElements#);

         //Check for Procedure call
         ProcedureCallCheck(out_Array: out_NoOfElm);

         //Move the new splitted value into existing array
         %Subarr(out_Array:Index:SplittedElements#) = New_Arr;
         If SplittedElements# > 1;
            %Subarr(out_Arrayopr:Index:SplittedElements#) =
                           %Subarr(New_ArrOpr:1:SplittedElements#-1);
         Endif;

         //Move the new splitted value into existing array
         %Subarr(out_Array:Index+SplittedElements#) = %Subarr(Sav_arr:Index+1);
         If SplittedElements# = 1;
            %Subarr(out_Arrayopr:Index) =  %Subarr(Sav_arrOpr:Index);
         Else;
            %Subarr(out_Arrayopr:Index+SplittedElements#-1) =
                                          %Subarr(Sav_arrOpr:Index);
         Endif;

         //Save the array values
         Sav_arr = out_Array;
         Sav_arrOpr = out_Arrayopr;

         //Increment the total elmentes based on new splitted elements
         out_NoOfElm = out_NoOfElm + SplittedElements# - 1;

         //To read the same index again
         Index = Index - 1;
         Iter;
      endif;

   Endfor;

   return;
End-proc;
//----------------------------------------------------------------------------------- //
//New logic for assingment operator procedure
//----------------------------------------------------------------------------------- //
Dcl-proc Assignment_Oper  export;                                                            //JM01
   Dcl-pi  Assignment_Oper;                                                                  //JM01
      in_field1    char(500);                                                                //JM01
      in_length1   packed(4:0) ;                                                             //JM01
      out_Ev_pos1  packed(2:0) ;                                                             //JM01
      out_field3   char(500);                                                                //JM01
   End-pi;                                                                                   //JM01

   dcl-s w_pos1            packed(4:0) inz;                                                  //JM02
   dcl-s w_pos2            packed(2:0) inz;                                                  //JM01
   dcl-s w_pos3            packed(2:0) inz;                                                  //JM01
   dcl-s w_field3          char(500)   inz;                                                  //JM01
   dcl-s w_string          char(500)   inz;                                                  //JM01
   dcl-c w_blanks          ' '    ;                                                          //JM01
   dcl-s w_field4          char(500)   inz;                                                  //JM02

//Scenario 1 Covers += ,-= , *= ,/= , **= (No space allowed between +-*/ and =)
   w_pos1 = *Zeros;                                                                          //JM01
   Select;                                                                                   //JM01
   When %scan('+=':in_field1) > 0 ;                                                          //JM01
        w_pos1 = %scan('+=':in_field1);                                                      //JM01
        w_field3 = %subst(in_field1 : w_pos1+2 :in_length1);                                 //JM01
   When %scan('-=':in_field1) > 0 ;                                                          //JM01
        w_pos1 =  %scan('-=':in_field1);                                                     //JM01
        w_field3  = %subst(in_field1 :w_pos1+2 :in_length1);                                 //JM01
   When %scan('**=':in_field1) > 0 ;                                                         //JM01
        w_pos1 =  %scan('**=':in_field1);                                                    //JM01
        w_field3  = %subst(in_field1 : w_pos1+3 :in_length1);                                //JM01
   When %scan('*=':in_field1) > 0 ;                                                          //JM01
        w_pos1 =  %scan('*=':in_field1);                                                     //JM01
        w_field3  = %subst(in_field1 : w_pos1+2 :in_length1);                                //JM01
   When %scan('/=':in_field1) > 0 ;                                                          //JM01
        w_pos1 =  %scan('/=':in_field1);                                                     //JM01
        w_field3  = %subst(in_field1 : w_pos1+2 :in_length1);                                //JM01
   Other;                                                                                    //JM01
      //w_pos1 = %scan('=' : %trim(in_field1));                                              //JM01
        w_pos1 = %scan('=' : %triml(in_field1));                                             //PJ01
        if w_pos1 > *zeros and (in_length1 - w_pos1) > *zeros ;                              //PJ01
         //w_field3 = %subst(%TRIM(in_field1) : w_pos1+1 :in_length1 - w_pos1);              //JM01
           w_field3 = %subst(%triml(in_field1) : w_pos1+1 :in_length1 - w_pos1);             //PJ01
        endif ;                                                                              //PJ01
        If w_pos1 > *Zeros;                                                                  //JM02
           procAddSub(in_field1:w_pos1:w_field4);                                            //JM02
           If w_field4 <> *Blanks;                                                           //JM02
              out_Ev_pos1 = w_pos1;                                                          //JM02
              out_field3  = w_field4;                                                        //JM02
              Return;                                                                        //JM02
           EndIf;                                                                            //JM02
        EndIf;                                                                               //JM02
   Endsl;                                                                                    //JM01
   out_Ev_pos1 = w_pos1;                                                                     //JM01
   out_field3  = w_field3;                                                                   //JM01
   return;                                                                                   //JM01
End-proc;                                                                                    //JM01
//----------------------------------------------------------------------------------- //
//process is similar to z-add,z-sub parsing
//----------------------------------------------------------------------------------- //
Dcl-proc procAddSub export;                                                                  //JM02
   Dcl-pi  procAddSub;                                                                       //JM02
      in_field1    char(500);                                                                //JM02
      in_length1   packed(4:0) ;                                                             //JM02
      out_field3   char(500) ;                                                               //JM02
   End-pi;                                                                                   //JM02
   dcl-s w_pos1            packed(4:0) inz;                                                  //JM02
   dcl-s w_pos2            packed(4:0) inz;                                                  //JM02
   dcl-s w_length          packed(4:0) inz;                                                  //JM02
   dcl-s w_field3          char(500)   inz;                                                  //JM02
   dcl-s w_string          char(500)   inz;                                                  //JM02
   out_field3 = *Blanks;                                                                     //JM02
   w_pos1 = %scan('+':in_field1:in_length1+1);                                               //JM02
   w_pos2 = %scan('-':in_field1:in_length1+1);                                               //JM02
   Select;                                                                                   //JM02
   When w_pos1 <> 0 And w_pos2 <> 0 ;                                                        //JM02
     If w_pos1 < w_pos2;                                                                     //JM02
        w_pos2 = w_pos1;                                                                     //JM02
     EndIf;                                                                                  //JM02
   When w_pos1 <> 0 ;                                                                        //JM02
     w_pos2 = w_pos1;                                                                        //JM02
   When w_pos2 <> 0 ; // It has value                                                        //JM02
   EndSl;                                                                                    //JM02
   If w_pos2 > 1 ;                                                                           //JM02
      w_length = (w_pos2-1) - in_length1;                                                    //JM02
      Select;                                                                                //JM02
      When w_length > 0 and w_pos2 > in_length1;                                             //JM02
        w_string = %subst(in_field1:in_length1+1:w_length);                                  //JM02
        If %check(' ':w_string) = 0 ;                                                        //JM02
           w_field3 = '0' + %subst(in_field1:w_pos2);                                        //JM02
        EndIf;                                                                               //JM02
      When w_length = 0;                                                                     //JM02
        w_field3 = '0' + %subst(in_field1:w_pos2);                                           //JM02
      Endsl;                                                                                 //JM02
      out_field3  = w_field3;                                                                //JM02
   EndIf;                                                                                    //JM02
   return;                                                                                   //JM02
End-proc;                                                                                    //JM02

//--------------------------------------------------------------------------------- //
//IaPsrcFix :
//--------------------------------------------------------------------------------- //
dcl-proc IaPsrcFix   Export;
   dcl-pi IaPsrcFix;                                                                     //AP01
      in_string    char(5000);                                                           //AP01
      in_type      char(10);                                                             //AP01
      in_error     char(10);                                                             //AP01
      in_xRef      char(10);                                                             //AP01
  //  in_srclib    char(10);                                                             //0005
  //  in_srcspf    char(10);                                                             //0005
  //  in_srcmbr    char(10);                                                             //0005
      in_uWSrcDtl likeds(uWSrcDtl);                                                      //0005
      in_RRN       packed(6:0);                                                          //AP01
      in_rrn_e     packed(6:0);                                                          //AP01
      in_ErrLogFlg char(1);                                                              //AP01
   end-pi;                                                                               //AP01
                                                                                         //AP01
   dcl-pr IAPQUOTE;                                                                      //AP01
      *n  char(5000);                                                                    //AP01
      *n  packed(4:0);                                                                   //AP01
      *n  char(1);                                                                       //AP01
   end-pr;                                                                               //AP01
                                                                                         //AP01
   dcl-s SUBSETVARS         char(300)      inz dim(40) ascend;                           //AP01
   dcl-s operatorArr        char(1)        inz dim(40) ascend;                           //AP01
   dcl-s Ev_field           char(500)      inz;                                          //AP01
   dcl-s Ev_field2          char(500)      inz;                                          //AP01
   dcl-s Ev_field3          char(500)      inz;                                          //AP01
   dcl-s Ev_field4          char(5000)     inz;                                          //AP01
   dcl-s Ev_flag            char(10)       inz;                                          //AP01
   dcl-s Ev_bif             char(10)       inz;                                          //AP01
   dcl-s W_SrcFile          char(10)       inz;                                          //AP01
   dcl-s br_inquote         char(1)        inz;                                          //AP01
   dcl-s Ev_type            char(10)       inz;                                          //AP01
   dcl-s In_flag            char(1)        inz;                                          //AP01
   dcl-s Ev_factor1         char(80)       inz;                                          //AP01
   dcl-s Ev_constant        char(80)       inz;                                          //AP01
   dcl-s Ev_field3bk        char(5000)     inz;                                          //AP01
   dcl-s Ev_opcode          char(10)       inz;                                          //AP01
   dcl-s In_bif             char(10)       inz;                                          //AP01
   dcl-s Ev_factor2         char(80)       inz;                                          //AP01
   dcl-s Ev_CONT            char(10)       inz;                                          //AP01
   dcl-s CaptureFlg         char(1)        inz;                                          //AP01
   dcl-s in_StringTmp       Varchar(5000)  inz;                                          //AP01
   dcl-s In_string1         varchar(5000)  inz;                                          //AP01
   dcl-s arraysignpositions packed(5)      inz dim(30) ascend;                           //AP01
   dcl-s tempArray          packed(5)      inz dim(30) ascend;                           //AP01
   dcl-s arrayaddsign       packed(3:0)    inz dim(30);                                  //AP01
   dcl-s arraysubsign       packed(3:0)    inz dim(30);                                  //AP01
   dcl-s arraymulsign       packed(3:0)    inz dim(30);                                  //AP01
   dcl-s arraydivsign       packed(3:0)    inz dim(30);                                  //AP01
   dcl-s Ev_seq             packed(6:0)    inz;                                          //AP01
   dcl-s Ev_bkseq           packed(6:0)    inz;                                          //AP01
   dcl-s Ev_pos1            packed(6:0)    inz;                                          //AP01
   dcl-s Ev_OprPos          packed(6:0)    inz;                                          //AP01
   dcl-s Ev_IfCondPos       packed(6:0)    inz;                                          //AP01
   dcl-s Ev_EqlPos          packed(6:0)    inz;                                          //AP01
   dcl-s Ev_length          packed(4:0)    inz;                                          //AP01
   dcl-s Ev_length2         packed(4:0)    inz;                                          //AP01
   dcl-s Ev_NotEqPos        packed(6:0)    inz;                                          //AP01
   dcl-s Ev_pos2            packed(6:0)    inz;                                          //AP01
   dcl-s In_postion         packed(4:0)    inz;                                          //AP01
   dcl-s intermediateAddPos packed(6:0)    inz;                                          //AP01
   dcl-s intermediateSubPos packed(6:0)    inz;                                          //AP01
   dcl-s intermediateMulPos packed(6:0)    inz;                                          //AP01
   dcl-s intermediateDivPos packed(6:0)    inz;                                          //AP01
   dcl-s frompos            packed(3:0)    inz;                                          //AP01
   dcl-s Count              packed(2:0)    inz;                                          //AP01
   dcl-s tr_Counter         packed(4:0)    inz;                                          //AP01
   dcl-s tr_Length          packed(4:0)    inz;                                          //AP01
   dcl-s tr_Brackets        packed(4:0)    inz;                                          //AP01
   dcl-s OBpos              packed(4:0)    inz;                                          //AP01
   dcl-s Elementpos         packed(4:0)    inz;                                          //AP01
   dcl-s Ev_field3Pos       packed(4:0)    inz;                                          //AP01
   dcl-s i                  int(5)         inz;                                          //AP01
   dcl-s j                  int(5)         inz;                                          //AP01
   dcl-s k                  int(5)         inz;                                          //AP01
   dcl-s l                  int(5)         inz;                                          //AP01
   dcl-s Z                  int(5)         inz;                                          //AP01
   dcl-s index              int(5)         inz;                                          //AP01
   dcl-s itr                int(5)         inz;                                          //AP01
   dcl-s ndx                int(5)         inz;                                          //AP01
   dcl-s rdx                int(5)         inz;                                          //AP01
   dcl-s Pos                int(5)         inz;                                          //AP01
   dcl-s X                  int(5)         inz;                                          //AP01
   dcl-s in_stringt         char(5000)     inz;
   dcl-s Ev_constantt       char(80)       inz;

   dcl-c Ch_Quote           '''';                                                        //AP01
   dcl-c quote              '"';                                                         //AP01
   dcl-c SQL_ALL_OK         '00000';                                                     //AP01
                                                                                         //AP01
   dcl-ds IAVARRELDs extname('IAVARREL') prefix(In_) inz;                                //AP01
   end-ds;                                                                               //AP01
                                                                                         //AP01
   if in_string = *Blanks;
      return;
   endif;
   clear ev_seq;                                                                         //AP01
   clear ev_bkseq;                                                                       //AP01
   clear IAVARRELDS;                                                                     //AP01
   uwsrcdtl = In_uwsrcdtl;                                                               //0005

      //------------------Replace ';' with  ''----------------------------- //          //AP01
      exec sql                                                                           //AP01
      set :In_String = replace(:In_String, ';', '');                                     //AP01
      in_stringt = %trim(in_string);
      Ev_length = %len(%trim(in_string));                                                //AP01

      //Check for logical operator.                                                     //AP01
      In_RECOMP  = *Blank;                                                               //AP01
      If in_type <> 'IFEQ' and in_type <> 'IFGT' and                                     //AP01
        in_type <> 'IFLT' and in_type <> 'IFNE' and                                      //AP01
        in_type <> 'IFLE' and in_type <> 'IFGE' and                                      //RK15
        in_type <> 'WHENEQ' and in_type <> 'WHENGT' and                                  //RK15
        in_type <> 'WHENLT' and in_type <> 'WHENNE' and                                  //RK15
        in_type <> 'WHENLE' and in_type <> 'WHENGE';                                     //RK15
        if in_String <> *blanks ;                                                        //0001
         Ev_EqlPos = %scan('=' : %trim(in_String));                                      //AP01
        endif ;                                                                          //0001
         If Ev_EqlPos > 0;                                                               //AP01
            in_StringTmp = %subst(in_String:1:Ev_EqlPos);                                //AP01
            Ev_OprPos    = %scan( '<' : in_stringt);                                     //AP01
            If Ev_OprPos < 1;                                                            //AP01
               Ev_OprPos = %scan( '>' : in_stringt);                                     //AP01
            EndIf;                                                                       //AP01
            If EV_EQLPOS > 0 and EV_OPRPOS = 0;                                          //AP01
               Ev_OprPos = Ev_EqlPos;                                                    //AP01
            Endif;                                                                       //AP01

            if Ev_OprPos > 1;
               Ev_field2    = %subst(In_stringt : 1 : Ev_OprPos - 1 );                   //AP01
            endif;

            if Ev_length > Ev_eqlPos;
               Ev_field3    = %subst(In_stringt : ev_eqlPos + 1                          //AP01
                                             : Ev_length - Ev_eqlPos);                   //AP01
              if Ev_field3 <> *blanks ;                                                  //0001
               Ev_field3Pos = %Scan(%trim(Ev_field3) : in_stringt);                      //AP01
              endif ;                                                                    //0001
            endif;

            If (Ev_field3Pos - Ev_OprPos) > 0 and Ev_OprPos <> 0;                        //MT04
               In_RECOMP    = %subst(in_Stringt : Ev_OprPos :                            //AP01
                                   (Ev_field3Pos - Ev_OprPos));                          //AP01
            endif;                                                                       //MT04
         Else;                                                                           //AP01
            Select;                                                                      //AP01
            When %scan( '<>' : in_Stringt) > *zero;                                      //AP01
               Ev_OprPos    = %scan( '<>' : in_Stringt);                                 //AP01
               if Ev_OprPos > 1 and Ev_length > (Ev_OprPos+1);
                  Ev_field2    = %subst(In_stringt : 1 : Ev_OprPos - 1);                 //AP01
                  Ev_field3    = %subst(In_stringt: Ev_OprPos + 2                        //AP01
                                                : Ev_length - (Ev_OprPos+1));            //AP01
                 if Ev_field3 <> *blanks ;                                               //0001
                  Ev_field3Pos = %Scan(%trim(Ev_field3) : in_stringt);                   //AP01
                 endif ;                                                                 //0001
               endif;
               In_RECOMP    = '<>';                                                      //AP01
            When %scan( '<' : in_Stringt) > 0;                                           //AP01
               Ev_OprPos    = %scan( '<' : in_Stringt);                                  //AP01
               if Ev_OprPos > 1 and Ev_length > Ev_OprPos;
                  Ev_field2    = %subst(In_stringt : 1 : Ev_OprPos - 1);                 //AP01
                  Ev_field3    = %subst(In_stringt: Ev_OprPos + 1                        //AP01
                                                : Ev_length - Ev_OprPos);                //AP01
                 if Ev_field3 <> *blanks ;                                               //0001
                  Ev_field3Pos = %Scan(%trim(Ev_field3) : in_stringt);                   //AP01
                 endif ;                                                                 //0001
               endif;
               In_RECOMP    = '<';                                                       //AP01
            When %scan( '>' : in_Stringt) > 0;                                           //AP01
               Ev_OprPos    = %scan( '>' : in_Stringt);                                  //AP01
               if Ev_OprPos > 1 and Ev_length > Ev_OprPos;
                  Ev_field2    = %subst(In_stringt : 1 : Ev_OprPos - 1);                 //AP01
                  Ev_field3    = %subst(In_stringt: Ev_OprPos + 1                        //AP01
                                                : Ev_length - Ev_OprPos);                //AP01
                 if Ev_field3 <> *blanks ;                                               //0001
                  Ev_field3Pos = %Scan(%trim(Ev_field3) : in_stringt);                   //AP01
                 endif ;                                                                 //0001
               endif;
               In_RECOMP    = '>';                                                       //AP01
            Other;                                                                       //SK06
               // If no operators were found                                             //SK06
               If in_Stringt <> *Blanks;                                                 //SK06
                  Ev_field3 = in_Stringt;                                                //SK06
               Endif;                                                                    //SK06
            EndSl;                                                                       //AP01
         EndIf;                                                                          //AP01
         Ev_field2 = %trim(Ev_field2);                                                   //YK02
         Ev_field3 = %trim(Ev_field3);                                                   //YK02
         If Ev_field3 <> *Blank;                                                         //AP01
            Ev_length2 = %len(%trim(Ev_field3));                                         //AP01
         EndIf;                                                                          //AP01
      Else;                                                                              //AP01
         Ev_field3 = %Subst(in_String:1:10);                                             //AP01
         Ev_field2 = %Subst(in_String:11:20);                                            //AP01
      EndIf;                                                                             //AP01
      //*----------------------Split the factor in array---------------*//              //AP01
      //If %subst(%trim(Ev_field3):1:1) <> '*';                                         //0001//AP01
      If Ev_field3 <> *blanks and %subst(%trim(Ev_field3):1:1) <> '*';                   //0001
         In_string1 = %trim(Ev_field3);                                                  //AP01
         exsr Sr_factor;                                                                 //AP01
      Else;                                                                              //AP01
         exsr varref;                                                                    //AP01
      Endif;                                                                             //AP01
                                                                                         //AP01
   return;                                                                               //AP01
                                                                                         //AP01
   begsr Sr_Factor;                                                                      //AP01
                                                                                         //AP01
      clear Ev_pos1;                                                                     //AP01
      //----------------- Search for  BIF -- ------------------------ //                //AP01
      ev_field3bk = %trim(Ev_field3);                                                    //AP01
      Ev_pos1     = %scan('%' : ev_field3bk);                                            //AP01
      if Ev_pos1 > 0;                                                                    //AP01
         inquote(ev_field3bk:Ev_pos1:br_inquote);                                        //AP01
         dow br_inquote = 'Y';                                                           //AP01
            Ev_pos1 = %scan('%' :ev_field3bk :Ev_pos1+1);                                //AP01
            if Ev_pos1 <> 0;                                                             //AP01
               inquote(ev_field3bk:Ev_pos1:br_inquote);                                  //AP01
            else;                                                                        //AP01
               br_inquote = 'N';                                                         //AP01
            endif;                                                                       //AP01
         enddo;                                                                          //AP01
      endif;                                                                             //AP01
                                                                                         //AP01
      //------------BIF found call the respective procedure------------- //             //AP01
      if Ev_pos1 <> 0;                                                                   //AP01
        if Ev_field3 <> *blanks and %len(%trim(Ev_field3)) >= ev_pos1 ;                  //0001
         Ev_pos2   =    %scan('(' : %trim(Ev_field3): ev_pos1);                          //AP01
        endif ;                                                                          //0001
         If Ev_pos2 > 0 and Ev_pos2 > Ev_pos1;                                           //AP01
            Ev_bif =   %subst(%trim(ev_field3) : ev_pos1 :Ev_pos2-Ev_pos1);              //AP01
         Else;                                                                           //AP01
            Ev_bif =   ev_field3;                                                        //AP01
         EndIf;                                                                          //AP01
         Ev_field4 = '~'+%trim(Ev_field3);                                               //AP01
         exsr callbif1;                                                                  //AP01
      else;                                                                              //AP01
         //*-------------Factor Field --------------------------------------*//         //AP01
         in_RERESULT  =  Ev_field2;                                                      //AP01
         in_REFACT1   =  Ev_field3;                                                      //AP01
         in_REOPC     =  Ev_type;                                                        //AP01
         in_REFACT2   = *blanks;                                                         //AP01
         exsr varref;                                                                    //AP01
         ev_bkseq     = ev_seq;                                                          //AP01
      endif;                                                                             //AP01
                                                                                         //AP01
      if in_RECOMP <> ' ';                                                               //AP01
         in_RECONTIN = ' ';                                                              //AP01
      else;                                                                              //AP01
         in_RECOMP   = ' ';                                                              //AP01
         in_RECONTIN = ' ';                                                              //AP01
      endif;                                                                             //AP01

      exec sql                                                                           //AP01
        update IAVARREL                                                                  //AP01
        set    RECOMP   = :in_RECOMP, RECONTIN = :in_RECONTIN                            //AP01
         where RESEQ    = :ev_bkseq                                                      //AP01
           and RERRN    = :in_rrn                                                        //AP01
           and RESRCLIB = :in_srclib                                                     //AP01
           and RESRCFLN = :in_srcspf                                                     //AP01
           and REPGMNM  = :in_srcmbr;                                                    //AP01
      if SQLSTATE <> SQL_ALL_OK;                                                         //AP01
         //log error                                                                    //AP01
      endif;                                                                             //AP01
                                                                                         //AP01
   endsr;                                                                                //AP01
                                                                                         //AP01
   begsr varref;                                                                         //AP01
                                                                                         //AP01
      in_RESRCLIB  = in_srclib;                                                          //AP01
      in_RESRCFLN  = in_srcspf;                                                          //AP01
      in_REPGMNM   = in_srcmbr;                                                          //AP01
      in_REIFSLOC  = in_ifsloc;                                                          //0005
      Ev_constant  = Ev_field3;                                                          //AP01
      exsr Check_constant;                                                               //AP01
      Ev_field3    = Ev_constant;                                                        //AP01
      in_RERESULT  = Ev_field2;                                                          //AP01
      in_REFACT1   = Ev_field3;                                                          //AP01
      in_REOPC     = in_type;                                                            //AP01
      if ev_seq  = 0;                                                                    //AP01
         in_RESEQ  = 1;                                                                  //AP01
         ev_seq    = in_reseq;                                                           //AP01
      else;                                                                              //AP01
         in_RECONTIN = 'AND';                                                            //AP01
         in_RERESULT = *blanks;                                                          //AP01
         in_REOPC    = *blanks;                                                          //AP01
         in_reseq    = Ev_seq+1;                                                         //AP01
         ev_seq      = in_reseq;                                                         //AP01
      endif;                                                                             //AP01

      in_RERRN  =  In_rrn;                                                               //AP01
      in_RENUM1 = 0;                                                                     //AP01
      in_RENUM2 = 0;                                                                     //AP01
      in_RENUM3 = 0;                                                                     //AP01
      in_RENUM4 = 0;                                                                     //AP01
      in_RENUM5 = 0;                                                                     //AP01
      in_RENUM6 = 0;                                                                     //AP01
      in_RENUM7 = 0;                                                                     //AP01
      in_RENUM8 = 0;                                                                     //AP01
      in_RENUM9 = 0;                                                                     //AP01

      IAVARRELLOG(in_RESRCLIB  :                                                         //AP01
                  in_RESRCFLN  :                                                         //AP01
                  in_REPGMNM   :                                                         //AP01
                  in_REIFSLOC  :                                                         //0005
                  in_RESEQ     :                                                         //AP01
                  in_RERRN     :                                                         //AP01
                  in_REROUTINE :                                                         //AP01
                  in_RERELTYP  :                                                         //AP01
                  in_RERELNUM  :                                                         //AP01
                  in_REOPC     :                                                         //AP01
                  in_RERESULT  :                                                         //AP01
                  In_Bif       :                                                         //AP01
                  in_REFACT1   :                                                         //AP01
                  in_RECOMP    :                                                         //AP01
                  in_REFACT2   :                                                         //AP01
                  in_RECONTIN  :                                                         //AP01
                  in_RERESIND  :                                                         //AP01
                  in_RECAT1    :                                                         //AP01
                  in_RECAT2    :                                                         //AP01
                  in_RECAT3    :                                                         //AP01
                  in_RECAT4    :                                                         //AP01
                  in_RECAT5    :                                                         //AP01
                  in_RECAT6    :                                                         //AP01
                  in_REUTIL    :                                                         //AP01
                  in_RENUM1    :                                                         //AP01
                  in_RENUM2    :                                                         //AP01
                  in_RENUM3    :                                                         //AP01
                  in_RENUM4    :                                                         //AP01
                  in_RENUM5    :                                                         //AP01
                  in_RENUM6    :                                                         //AP01
                  in_RENUM7    :                                                         //AP01
                  in_RENUM8    :                                                         //AP01
                  in_RENUM9    :                                                         //AP01
                  in_REEXC     :                                                         //AP01
                  in_REINC );                                                            //AP01
                                                                                         //AP01
   endsr;                                                                                //AP01
                                                                                         //AP01
                                                                                         //AP01
   begsr Check_constant;                                                                 //AP01
                                                                                         //AP01
      if Ev_constant <> *Blanks;
         leavesr;
      else;
         Ev_constantt = %trim(Ev_constant);
      endif;
      //Check for constant value.... ex:- *BLANKS, *ON, *OFF                            //AP01
      Select;                                                                            //AP01
      when %scan('*': Ev_constantt :1) > 0;                                              //AP01
         Ev_constant =  'Const(' + %trim(Ev_constant) + ')';                             //AP01
      when %scan(Ch_Quote:Ev_constantt:1) > 0                                            //AP01
         or  %scan(Quote: Ev_constantt:1) > 0 ;                                          //AP01
         Ev_constant =  'Const(' + %trim(Ev_constant) + ')';                             //AP01
      when %check('(!@#$%Â¢&*()_-<>?/:;"-)':Ev_constantt:1) = 0;                         //AP01
         Ev_constant =  'Const(' + %trim(Ev_constant) + ')';                             //AP01
      other;                                                                             //AP01
      endsl;                                                                             //AP01
                                                                                         //AP01
      If %check('0123456789':Ev_constantt:1) = 0;                                        //AP01
         Ev_constant =  'Const(' + %trim(Ev_constant) + ')';                             //AP01
      Endif;                                                                             //AP01
                                                                                         //AP01
   endsr;                                                                                //AP01
                                                                                         //AP01
   begsr callBif1;                                                                       //AP01
                                                                                         //AP01
      ev_seq     = ev_bkseq;                                                             //AP01
      ev_opcode  = '=';                                                                  //AP01
      ev_factor1 = *blanks;                                                              //AP01
      ev_factor2 = *blanks;                                                              //AP01
      in_bif     = EV_bif;                                                               //AP01
      in_string  = Ev_field4;                                                            //AP01
      ev_flag    = *blanks;                                                              //AP01
      ev_field4  = *blanks;                                                              //AP01
      ev_field2  = Ev_field2;                                                            //AP01
                                                                                         //AP01
    //Callbif(in_srclib  :                                                               //0005
    //        in_srcspf  :                                                               //0005
    //        in_srcmbr  :                                                               //0005
      callbif(in_uWSrcDtl:                                                               //0005
              in_rrn     :                                                               //AP01
              ev_Seq     :                                                               //AP01
              ev_bkseq   :                                                               //AP01
              ev_opcode  :                                                               //AP01
              ev_factor1 :                                                               //AP01
              ev_factor2 :                                                               //AP01
              in_type    :                                                               //AP01
              Ev_CONT    :                                                               //AP01
              in_bif     :                                                               //AP01
              Ev_flag    :                                                               //AP01
              Ev_field2  :                                                               //AP01
              in_String  :                                                               //AP01
              Ev_field4 );                                                               //AP01
                                                                                         //AP01
   endsr;                                                                                //AP01
                                                                                         //AP01
End-proc;                                                                                //AP01
