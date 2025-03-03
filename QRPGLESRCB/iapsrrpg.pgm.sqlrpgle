**free
      //%METADATA                                                      *
      // %TEXT IA RPG Source Parser emg                                *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------- //
//Created By    : Programmers.io @ 2020                                                 //
//Created Date  : 2020/01/01                                                            //
//Developer     : Programmer                                                            //
//Description   : Main Parser Program                                                   //
//Procedure Log :                                                                       //
//------------------------------------------------------------------------------------- //
//Procedure Name           | Procedure Description                                      //
//-------------------------|----------------------------------------------------------- //
//No Procedure             |                                                            //
//------------------------------------------------------------------------------------- //
//Modification Log:                                                                     //
//------------------------------------------------------------------------------------- //
//Date    | Mod_ID | Developer  | Case and Description                                  //
//--------|--------|------------|------------------------------------------------------ //
//27/01/23| 0001   | Pranav     | Changed r_obrpos > r_dimpos to r_obrpos >= r_dimpos   //
//        |        |     Joshi  | in Process_VAR subroutine.                            //
//16/02/23| 0002   | Ahmed s    | Fixed bug - Long procedure name and RRN was not get   //
//        |        |            | getting Capture in AIPROCDTL                          //
//06/03/23| 0003   | Vipul P    | Removed the Progress Bar Process.                     //
//03/17/23| 0004   | Ahmed S.   | Fixed issue where Multiple comments not excluded.     //
//06/03/23| 0005   | Sarvesh B  | Use of %Xlate BIF instead of UPPER for IAQRPGSRC      //
//18/04/23| 0006   | Arshaa     | Commented out calls to IAPSRVARFR and IAPSRVARFX.     //
//17/04/23| 0007   | Yogesh J.  | Modified The SQL Query To Ignore The Comment In       //
//        |        |            | Source                                                //
//16/03/23| 0008   | Pratik A   | PLIST Entry into IAPGMVARS by calling new procedure   //
//        |        |            | IAPSRPLSTFX and IAPSRPLSTFX3                          //
//15/02/23| 0009   | Prateek J  | Adding call to IAPSROSPEC procedure for O specs       //
//        |        |            | prasing using Data structure                          //
//20/06/23| 0010   | Himanshu   | Change the UwSrcDtl ds parameter and corrosponding    //
//        |        | Gehlot     | lines where these parameters are being used.          //
//27/07/23| 0011   | Akshay     | Fixed issue with procedure without pi not getting     //
//        |        |   Sopori   | inserted in AIPROCDTL and modified code for           //
//27/07/23| 0012   | Akshay S   | Changed the IAQRPGSRC cursor for the seq number       //
//        |        |   Sopori   | and passed the sequence number as parameter.          //
//02/08/23| 0013   | Megha      | Stop writing duplicate entry in file IAPGMCALLS       //
//10/08/23| 0014   |Bhavit Jain | Added the in_procedure parameter into IAPSRPRFR       //
//        |        | Tanisha K. | procedure [Task #150]                                 //
//09/09/23| 0015   |Akshay      | Changed the AIPROCDTL file to IAPROCINFO              //
//        |        | Sopori     | [Task #208]                                           //
//07/09/23| 0016   | Satyabrat  | Skip the source line when only the spec is mentioned. //
//        | Task#82| Sabat      | It is just like a commented line.                     //
//01/11/23| 0017   | Abhijith   | Modify the init & parser proess to include refresh    //
//        |        | Ravindran  | functionality (Task#322)                              //
//07/11/23| 0018   |Santosh     | Add check to handle exception                         //
//        |        | Kumar      | [Task #339]                                           //
//20/10/23| 0019   |Akshay      | Capturing Procedure Name in IAPGMVARS file incase     //
//        |        | Sopori     | of *N PI. #215                                        //
//06/11/23| 0020   | Bhavit     | Added the in_procedure parameter into IAPSRPRFX       //
//        |        |   Jain     | procedure [Task #348].                                //
//06/06/24| 0021   | Saumya     | Rename AIEXCTIMR to IAEXCTIMR [Task #262]             //
//05/10/23| 0022   | Khushi W   | Rename program AIMBRPRSER to IAMBRPRSER.[Task #263]   //
//05/07/24| 0023   | Akhil K.   | Renamed AIERRBND, AICERRLOG, AIDERRLOG and AISQLDIAGNO//
//        |        |            | STIC with IA*                                         //
//29/05/24| 0024   | Azhar Uddin| Modify to check fourth character as non-blank instead //
//        |        |            | of hard coding for source line type from IAQRPGSRC    //
//        |        |            | (Task - #689)                                         //
//24/07/05| 0025   |Piyush Kumar| Task#416 Long Procedure name is not parsing in        //
//        |        |            | Fixed Format                                          //
//09/07/24| 0026   |Piyush Kumar| Task#768 Binding Directory not capture for free format//
//        |        |            | source in IASRCINTPF file.                            //
//------------------------------------------------------------------------------------- //
ctl-opt copyright('Copyright @ Programmers.io © 2022 ');
ctl-opt option(*nodebugio:*srcstmt:*nounref);
ctl-opt bndDir('IABNDDIR' : 'IAERRBND');                                                 //0023

//------------------------------------------------------------------------------------- //
//Prototype Declarations
//------------------------------------------------------------------------------------- //
dcl-pr iAExcTimr extpgm('IAEXCTIMR');                                                    //0021
    *n Char(10) Const;
    *n Char(10);
    *n Char(10);
    *n Char(10) Const;
    *n Char(10);
    *n Char(10);
    *n Char(10);
    *n Char(10) Const;
    *n Timestamp;
    *n Char(6) Const;
end-pr;

//------------------------------------------------------------------------------------- //
//Data Structure Declarations
//------------------------------------------------------------------------------------- //
dcl-ds UwSrcDtl inz qualified;                                                           //0010
   srclib  char(10);                                                                     //0010
   srcSpf  char(10);                                                                     //0010
   srcmbr  char(10);                                                                     //0010
   srcType char(10);                                                                     //0010
   srcStat char(1);                                                                      //0017
end-ds;                                                                                  //0010

dcl-ds uwdsdtl extname('IAPGMDS') inz qualified;
end-ds;

dcl-ds uwkldtl extname('IAPGMKLIST') inz qualified;
end-ds;

dcl-ds uwdstyp inz qualified;
   dsfile  char(10);
   dsinfds char(10);
   dsindds char(10);
end-ds;

//DS for SRCSTMT cursor fetch                                                           //0012
Dcl-Ds IAQRPG_DATA;                                                                      //0012
  r_rrn               Packed(6);                                                         //0012
  r_srcSeq            Packed(6:2);                                                       //0012
  r_Src_Type          Char(5);                                                           //0012
  r_Line_Cntn         Char(1);                                                           //0012
  r_Src_Spec          Char(1);                                                           //0026
  r_Stm               Char(4046);                                                        //0012
End-ds;                                                                                  //0012

//------------------------------------------------------------------------------------- //
//Variable Declarations
//------------------------------------------------------------------------------------- //
dcl-s r_callCPYB      ind          inz;
dcl-s ind_PrFlag      ind          inz;
dcl-s w_opnbrkfnd     ind          inz;
dcl-s in_procedure    ind          inz;
dcl-s r_iter          char(1)      inz('N');
dcl-s r_error         char(10)     inz('N');
dcl-s r_type          char(10)     inz('N');
dcl-s r_tfree         char(1)      inz('N');
dcl-s r_mfree         char(1)      inz('N');
dcl-s r_chkprv        char(1)      inz('N');
dcl-s r_ext           char(1)      inz('N');
dcl-s r_subrflg       char(1)      inz('N');
dcl-s r_srcflag       char(1)      inz('R');
dcl-s uwaction        char(20)     inz;
dcl-s uwactdtl        char(50)     inz;
dcl-s r_clprocnm      char(50)     inz;
dcl-s r_Procname      char(128)    inz;
//dcl-s r_Stm           char(4046)   inz;                                                //0011
dcl-s r_fix           char(1)      inz;
dcl-s r_PrName        char(128)    inz;
dcl-s r_GetMsg        char(1000)   inz;
dcl-s r_string        char(5000)   inz;
dcl-s r_cat           char(1)      inz;
dcl-s r_dsdcl         char(3)      inz;
dcl-s r_dsmody        char(10)     inz;
dcl-s r_dsobjv        char(10)     inz;
dcl-s r_dsname        char(128)    inz;
dcl-s r_sts           char(7)      inz;
dcl-s r_lname         char(50)     inz;
dcl-s r_prc           char(80)     inz;
dcl-s r_word          char(30)     inz;
dcl-s r_subrNAM       char(20)     inz;
dcl-s r_stringnew     char(5000)   inz;
dcl-s r_prstring      char(5000)   inz;
dcl-s r_longprname    char(50)     inz;
dcl-s h_mbrnm         char(10)     inz;
dcl-s h_jobdetail     char(80)     inz;
dcl-s h_jobstatus     char(2)      inz;
dcl-s r_ioopcode      char(10)     inz;
dcl-s w_progMsg       char(74)     inz;
dcl-s wk_LikeDsNm     char(128)    inz;
dcl-s wk_Likedsfnd    char(128)    inz;
dcl-s r_pos1          packed(4:0)  inz;
dcl-s wr_pos1         packed(4:0)  inz;
dcl-s r_pos2          packed(4:0)  inz;
//dcl-s r_rrn           packed(6:0)  inz;                                                //0011
dcl-s r_rrns          packed(6:0)  inz;
dcl-s r_rrnext        packed(6:0)  inz;
dcl-s r_rrne          packed(6:0)  inz;
dcl-s r_pos7          packed(4:0)  inz;
dcl-s r_scanpos       packed(4:0)  inz;
dcl-s r_len           packed(4:0)  inz;
dcl-s r_count         packed(4:0)  inz;
dcl-s r_pos8          packed(4:0)  inz;
dcl-s r_seq           packed(5:0)  inz;
dcl-s r_lpos          packed(5)    inz;
dcl-s r_spos          packed(4:0)  inz(1);
dcl-s r_dcls          packed(5:0)  inz;
dcl-s r_likepos       packed(5:0)  inz;
dcl-s r_pos3          packed(4:0)  inz;
dcl-s r_CPYBpos       packed(5)    inz;
dcl-s wk_pos1         packed(4:0)  inz;
dcl-s wk_pos2         packed(4:0)  inz;
dcl-s wk_pos3         packed(4:0)  inz;
dcl-s wk_pos4         packed(4:0)  inz;
dcl-s wk_pos5         packed(4:0)  inz;
dcl-s wk_pos6         packed(4:0)  inz;
dcl-s wBndStart       packed(4:0)  inz;
dcl-s WBndBrk         packed(4:0)  inz;
dcl-s wBndEnd         packed(4:0)  inz;
dcl-s wBndDirName     char(10)     inz;
dcl-s wBndDirLib      char(10)     inz;
dcl-s wBndQPos        packed(4:0)  inz;
dcl-s wBndPos         packed(4:0)  inz(1);
dcl-s ColonInd        Ind          inz('1');
dcl-s uppgm_name      char(10)     inz;
dcl-s uplib_name      char(10)     inz;
dcl-s uptimestamp     Timestamp;
dcl-s r_dsFlag        Ind          inz('1');
dcl-s w_LongVar       char(5000)   inz;
dcl-s q_stm           char(5000)   inz;
dcl-s b_pos           packed(6:0)  inz;
dcl-s r_pcmt          packed(4:0)  inz;
dcl-s in_value        char(1)      inz;
dcl-s r_dimpos        packed(5:0)  inz;
dcl-s r_obrpos        packed(5:0)  inz;
dcl-s r_dim           char(1)      inz;
//dcl-s r_Src_Type      char(5)      inz;                                                //0011
dcl-s procedureNm     char(80)     inz;                                                  //0011
dcl-s procEI          char(1)      inz;                                                  //0011
dcl-s prNameEnd       packed(4:0)  inz;                                                  //0011
dcl-s procPos         packed(4:0)  inz;                                                  //0011
dcl-s prNameStrt      packed(4:0)  inz;                                                  //0011
dcl-s r_srcSeqs       packed(6:2)  inz;                                                  //0012
dcl-s w_bracket       char(1)      inz;                                                  //0025
dcl-s c_pos           packed(6:0)  inz;                                                  //0025

//------------------------------------------------------------------------------------- //
//Constant Variable Declarations
//------------------------------------------------------------------------------------- //
dcl-c wk_lo                'abcdefghijklmnopqrstuvwxyz';                                 //0005
dcl-c wk_Up                'ABCDEFGHIJKLMNOPQRSTUVWXYZ';                                 //0005

//------------------------------------------------------------------------------------- //
//CopyBook Declarations
//------------------------------------------------------------------------------------- //
/copy 'QMODSRC/iasrv01pr.rpgleinc'
/copy 'QMODSRC/iasrv02pr.rpgleinc'
/copy 'QCPYSRC/iaderrlog.rpgleinc'

//------------------------------------------------------------------------------------- //
//Entry Parameter Declarations
//------------------------------------------------------------------------------------- //
dcl-pi IAPSRRPG extpgm('IAPSRRPG');
   uwxref char(10);
   UwSrcDtl5 like(UwSrcDtl);
   uwProg char(74);
end-pi;

//------------------------------------------------------------------------------------- //
//Main Program Logic
//------------------------------------------------------------------------------------- //
exec sql
  set option commit    = *none,
             naming    = *sys,
             usrprf    = *user,
             dynusrprf = *user,
             closqlcsr = *endmod;

Eval-corr uDpsds = wkuDpsds;
//Insert record to IASRCMBRID file
UwSrcDtl= UwSrcDtl5;
if UwSrcDtl.srcStat = 'A';                                                               //0017
   exsr Get_Rec_IASRCMBRID;
endIf;                                                                                   //0017

if h_mbrnm <> uwsrcdtl.srcmbr;

   uptimeStamp = %Timestamp();
   CallP IAEXCTIMR('IAMBRPRSER' :udpsds.ProcNme : udpsds.Lib : '*PGM' :                  //0022
                   UwSrcDtl.srcSpf : uwsrcdtl.srcmbr : uwsrcdtl.srclib :                 //0010
                   UwSrcDtl.srcType : uptimeStamp : 'INSERT');                           //0010


endif;

r_type  = UwSrcDtl.srcType;                                                              //0010
r_tfree = 'N';
r_mfree = 'N';
r_fix   = ' ';
exec sql delete from QTemp/WkLikeDSPF;

exsr processSourceData;
WriteLikeDSDtl();
reset R_SubrNam;

if h_mbrnm <> uwsrcdtl.srcmbr;
   h_mbrnm     = uwsrcdtl.srcmbr;

   uptimeStamp = %Timestamp();
   CallP IAEXCTIMR('IAMBRPRSER' :udpsds.ProcNme : udpsds.Lib : '*PGM' :                  //0022
                   UwSrcDtl.srcSpf : uwsrcdtl.srcmbr : uwsrcdtl.srclib :                 //0010
                   UwSrcDtl.srcType : uptimeStamp : 'UPDATE');                           //0010


endif;
*inlr = *on;
return;

/copy 'QCPYSRC/iacerrlog.rpgleinc'

//------------------------------------------------------------------------------------- //
//Subroutine Fetch_Specs: To fetch specifications
//------------------------------------------------------------------------------------- //
begsr Fetch_Specs;

   r_iter = 'N';

   //If full Free Code
   if r_tfree = 'N' and r_stm <> *blanks
      and %scan('**FREE': r_stm : 1) = 1;

      r_tfree = 'Y';
      exsr clear_vars;
   // exec sql fetch SrcStmt into :r_stm, :r_rrn, :r_Src_Type;                           //0012
      Exec Sql Fetch SrcStmt Into :IAQRPG_DATA;                                          //0012
      r_stm = %xlate(wk_lo:wk_Up:r_stm);                                                 //0005
      if sqlCode < successCode;
         uDpsds.wkQuery_Name = 'Fetch_6_SrcStmt';
         IaSqlDiagnostic(uDpsds);                                                        //0023
      endif;
      r_iter = 'Y';
      leavesr;

   endif;

   //If /FREE Is Encountered
   if r_mfree = 'N' and r_stm <> *blanks and %subst(r_stm: 7: 1) <> '*'
      and %len(%trim(r_stm)) >= 7 and %scan('//': %trim(r_stm):7) <> 1
      and %scan('/FREE':%trim(%subst(r_stm:7)):1) = 1;

      r_mfree = 'Y';
      exsr clear_vars;
    //exec sql fetch SrcStmt into :r_stm, :r_rrn, :r_Src_Type;                           //0012
      Exec Sql Fetch SrcStmt Into :IAQRPG_DATA;                                          //0012
      r_stm = %xlate(wk_lo:wk_Up:r_stm);                                                 //0005
      if sqlCode < successCode;
         uDpsds.wkQuery_Name = 'Fetch_7_SrcStmt';
         IaSqlDiagnostic(uDpsds);                                                        //0023
      endif;
      r_iter = 'Y';
      leavesr;

   endif;

   //If /END-FREE IS Encountered
   if r_stm <> *blanks and %subst(r_stm: 7: 1) <> '*'
      and %len(%trim(r_stm)) >= 7 and %scan('//': %trim(r_stm):7) <> 1
      and %scan('/END-FREE':%trim(%subst(r_stm:7)):1) = 1;

      r_mfree = 'N';
      exsr clear_vars;
   // exec sql fetch SrcStmt into :r_stm, :r_rrn, :r_Src_Type;                           //0012
      Exec Sql Fetch SrcStmt Into :IAQRPG_DATA;                                          //0012
      r_stm = %xlate(wk_lo:wk_Up:r_stm);                                                 //0005
      if sqlCode < successCode;
         uDpsds.wkQuery_Name = 'Fetch_8_SrcStmt';
         IaSqlDiagnostic(uDpsds);                                                        //0023
      endif;
      r_iter = 'Y';
      leavesr;

   endif;

   //If FIXED Is Encountered
   if r_tfree = 'N' and r_mfree = 'N' and r_stm <> *blanks
      and (%scan('H': r_stm : 6) = 6 or %scan('F': r_stm : 6) = 6
      or %scan('D': r_stm : 6) = 6 or %scan('E': r_stm : 6) = 6
      or %scan('I': r_stm : 6) = 6 or %scan('C': r_stm : 6) = 6
      or %scan('O': r_stm : 6) = 6 or %scan('P': r_stm : 6) = 6 );
      r_fix = %subst(r_stm  : 6 : 1);
   endif;

   if r_sts = 'DSFXN' and r_stm <> *blanks
      and (r_fix <> 'D' and r_fix <> *blanks and %subst(r_stm: 7: 1) <> '*');
      clear r_sts;
   endif;

endsr;

//------------------------------------------------------------------------------------- //
//Subroutine Clear_Vars: Clear variables
//------------------------------------------------------------------------------------- //
begsr Clear_Vars;

   if r_chkprv = 'N';
      clear r_rrns;
      clear r_rrne;
      clear r_string;
   endif;

endsr;
//------------------------------------------------------------------------------------- //
//Subroutine Format_String: To format string
//------------------------------------------------------------------------------------- //
Begsr Format_String;

   r_iter = 'N';

   select ;
      //If Fixed , Remove the TAGS
      when r_Src_Type = 'FX3' or r_Src_Type = 'FX4';
         r_stm  = %replace('     ':r_stm:1:5);

      //If Free (8-80), Remove the Tags
      when r_Src_Type = 'FFC';
         r_stm  = %replace('      ':r_stm:1:6);
   endsl ;

   //Remove Comments if any, based on the source type
   select;
      when r_Src_Type = 'FX4' and %subst(r_stm:81:20) <> *blanks;
         r_stm = %replace(' ':r_stm:81:20);

      when  r_Src_Type = 'FX3' and %subst(r_stm:60:15) <> *blanks;
         r_stm = %replace(' ':r_stm:60:15);

      //If total free and partial commented line
      when r_Src_Type = 'FFC' or r_Src_Type = 'FFR';
         If %len(%trim(r_stm )) >= 1
            and %scan('//': %trim(r_stm ):1)>1;

            //check if comment line is in between " "
            r_pcmt = 0;
            b_pos = %scan('//': %trim(r_stm ):1);
            q_stm = %trim(r_stm);

            dow b_pos > 0;
              InQuote(q_stm:b_pos:in_value);
              if in_value = 'Y';
                r_pcmt = 0;
              else;
                r_pcmt = b_pos;
                Leave;                                                                   //0004
              endif;
              if %len(%trim(r_stm)) >= b_pos+1;
                b_pos = %scan('//': %trim(r_stm):b_pos+1);
              endif;
            enddo;

            //if last comment line is in between " "
            if r_pcmt = 0;
              r_stm  = %trim(r_stm );
            elseif r_pcmt > 1 and %len(%trim(r_stm )) > r_pcmt-1;
              r_stm  = %subst(%trim(r_stm ):1:r_pcmt-1);
            endif;

         endif;
   endsl ;

   //Process /EJECT & /TITLE
   if %scan('/TITLE':r_stm:1)= 7
      or %scan('/EJECT': r_stm:1)= 7 ;
      r_iter = 'Y';
    //exec sql fetch SrcStmt into :r_stm, :r_rrn, :r_Src_Type;                           //0012
      Exec Sql Fetch SrcStmt Into :IAQRPG_DATA;                                          //0012
      r_stm = %xlate(wk_lo:wk_Up:r_stm);                                                 //0005
      if sqlCode < successCode;
         uDpsds.wkQuery_Name = 'Fetch_18_SrcStmt';
         IaSqlDiagnostic(uDpsds);                                                        //0023
      endif;
      leavesr;
   endif;

endsr;

//------------------------------------------------------------------------------------- //
//Subroutine Process_SQL : Process Fix format Sql Statements
//------------------------------------------------------------------------------------- //
begsr Process_SQL;

   //SQL Comments Removed
   commentsSqlRemoval(r_string);

   r_iter = 'N';

   //Remove 'C+'
   if %scan('C+': r_string : 1) > 0;
      clear r_pos2;
      r_pos2 = %scan('C+': r_string : 1);
      if r_pos2 > 0;
         r_string = %replace('': r_string : r_pos2 : 2);
      endif;
   endif;

   //Remove 'C/'
   if %scan('C/': r_string : 1) > 0;
      clear r_pos2;
      r_pos2 = %scan('C/': r_string : 1);
      if r_pos2 > 0;
         r_string = %replace('': r_string : r_pos2: 2);
      endif;
   endif;

   //Concate Complete Statement Till End
   if %len(%trimr(r_string)) >=1
      and (not (%scan('END-EXEC': r_string :1) > 0
      or %subst(r_string:%len(%trimr(r_string)):1) = ';'));

    //exec sql fetch SrcStmt into :r_stm, :r_rrn, :r_Src_Type;                           //0012
      Exec Sql Fetch SrcStmt Into :IAQRPG_DATA;                                          //0012
      r_stm = %xlate(wk_lo:wk_Up:r_stm);                                                 //0005
      if sqlCode < successCode;
         uDpsds.wkQuery_Name = 'Fetch_19_SrcStmt';
         IaSqlDiagnostic(uDpsds);                                                        //0023
      endif;
      r_iter = 'Y';
      leavesr;

   endif;

   //Parse Sql Statement
   IAPSRSQL(r_string        : r_type          : r_error         :
            uwxref          : UwSrcDtl.srclib : UwSrcDtl.srcspf :
            UwSrcDtl.srcmbr : r_rrns          : r_rrne          :
            UwSrcDtl.srcType);                                                           //0010

   if r_error = 'C';
      exsr clear_vars;
   endif;

endsr;

//------------------------------------------------------------------------------------- //
//Subroutine Process_DS_Fr: To process the datastructure (Free case)
//------------------------------------------------------------------------------------- //
begsr Process_DS_fr;

   r_iter = 'N';
   r_sts = 'DSFRN';

   //Concate Complete Statement Till End
   if r_string <> *blanks and %len(%trimr(r_string)) > 0
      and %subst(r_string:%len(%trimr(r_string)):1) <> ';';

    //exec sql fetch SrcStmt into :r_stm, :r_rrn, :r_Src_Type;                           //0012
      Exec Sql Fetch SrcStmt Into :IAQRPG_DATA;                                          //0012
      r_stm = %xlate(wk_lo:wk_Up:r_stm);                                                 //0005
      if sqlCode < successCode;
         uDpsds.wkQuery_Name = 'Fetch_20_SrcStmt';
         IaSqlDiagnostic(uDpsds);                                                        //0023
      endif;
      r_iter = 'Y';
      leavesr;

   endif;

   //Format String Into Single Spacing String
   exsr snglspcstring;

   //Define String Type DS/DS-FLD/END-DS
   select;
   //When END-DS is found
   when %scan('END-DS' : %trim(r_string)) = 1;
      //If Status Is DS, Write DS info into IAPGMDS
      if r_dsdcl = 'DS';
         r_dsdcl = 'WDS';
         IAPSRDSFR(r_string        : r_type          : r_error         : uwxref   :
                   UwSrcDtl.srclib : UwSrcDtl.srcspf : UwSrcDtl.srcmbr : r_rrns   :
                   r_rrne          : r_dsdcl         : r_dsobjv        : r_dsname :
                   r_dsmody        : uwdsdtl );
      endif;

      //Clear DS Related Variables
      clear r_dsdcl;
      clear r_sts;
      clear r_dsobjv;
      clear r_dsname;
      clear r_dsmody;
      clear uwdsdtl;
      leavesr;

   //When DS Declaration
   when r_dsdcl = *blanks;
      r_dsdcl = 'DS';
      r_pos7 = %scan(' ' : %trim(r_string));

      select;
      when r_pos7 > 0 and %scan(' ' : %trim(r_string) : r_pos7 + 1) > 0;
         r_pos8 = %scan(' ' : %trim(r_string) : r_pos7 + 1);
      when r_pos7 > 0 and %scan(';' : %trim(r_string) : r_pos7 + 1) > 0;
         r_pos8 = %scan(';' : %trim(r_string) : r_pos7 + 1);
      endsl;

      //Find DS Name And Objective
      if r_pos8 > r_pos7 + 1;
         r_dsname = %subst(%trim(r_string) : r_pos7 + 1 : r_pos8 - r_pos7 - 1);
      endif;

      if r_dsname <> *blanks;
         exsr finddsdtl;
      endif;

      select;
      when r_dsobjv = 'INFDS-VAR';
      when r_dsobjv = 'INDDS-VAR';
      when %scan(' PSDS' : %trim(r_string)) > 0;
         r_dsobjv = 'PSDS-VAR';
      when %scan(' LIKE' : %trim(r_string)) > 0;
         r_dsobjv = 'DS-VAR';
         clear r_sts;
      other;
         r_dsobjv = 'DS-VAR';
      endsl;

   other;
      clear r_dsname;
      clear r_dsmody;
      r_dsdcl = 'DSS';
      r_pos7 = %scan('-' : r_dsobjv);
      r_dsobjv = %replace('SUB': r_dsobjv : r_pos7+1 : 3);
   endsl;

   IAPSRDSFR(r_string        : r_type          : r_error         : uwxref   :
             UwSrcDtl.srclib : UwSrcDtl.srcspf : UwSrcDtl.srcmbr : r_rrns   :
             r_rrne          : r_dsdcl         : r_dsobjv        : r_dsname :
             r_dsmody        : uwdsdtl );


   r_error = 'C';
   if r_error = 'C';

      r_iter = 'N';
      clear wk_pos1;
      clear wk_pos2;

      if %scan('LIKEDS' : r_string) > *zero;

         wk_pos1 = %scan('LIKEDS' : r_string);
         wk_pos2 = %scan(')' : r_string:wk_pos1+1);
         if wk_pos2 > (wk_pos1 + 7);
            wk_pos2 = wk_pos2 - (wk_pos1 + 7);
         endif;

         if wk_pos2 > 0;
            wk_LikeDsNm =%subst(r_string :(wk_pos1 +7) :wk_pos2);
            wk_Likedsfnd = 'DCL-DS ' + %trim(r_dsname) + ' ' +
                        'LIKEDS(' + %trim(wk_LikeDsNm) + ')';
         endif;

         r_dsFlag = *Off;

      endif;

      clear wk_pos3;
      clear wk_pos4;
      if r_string <> *blanks and %scan('LIKEREC' : r_string) > *zero;

         wk_pos3 = %scan('LIKEREC' : r_string);
         wk_pos4 = %scan(')' : r_string:wk_pos3+1);
         if wk_pos4 > (wk_pos3 + 7);
            wk_pos4 = wk_pos4 - (wk_pos3 + 7);
         endif;

         if wk_pos4 > 0;
            wk_LikeDsNm =%subst(r_string :(wk_pos3 +7) :wk_pos4);
            wk_Likedsfnd = 'DCL-DS ' + %trim(r_dsname) + ' ' +
                        'LIKEREC(' + %trim(wk_LikeDsNm) + ')';
         endif;

      endif;

      if wk_LikeDsNm <> *Blanks;
         wk_pos1 = %scan(%trim(wk_Likedsfnd) : %trim(r_string));
      endif;

      if r_string <> *blanks;
         wk_pos2 = %scan(' END-DS' : %trim(r_string));
      endif;

      if (wk_pos1 > *Zero or wk_pos3 > *Zero) or wk_pos2 > *Zero;

         if r_dsdcl = 'DS';

            r_dsdcl = 'WDS';
            if r_dsFlag = *Off;
               r_dsdcl = 'XDS';
            endif;

            IAPSRDSFR(r_string        : r_type          : r_error         : uwxref   :
                      UwSrcDtl.srclib : UwSrcDtl.srcspf : UwSrcDtl.srcmbr : r_rrns   :
                      r_rrne          : r_dsdcl         : r_dsobjv        : r_dsname :
                      r_dsmody        : uwdsdtl );

            if r_string <> *blanks and %scan('DCL-DS ' : %trim(r_string)) = 0;
               r_string = 'DCL-DS ' + %trim(r_string);
               IAPSRVARFR(r_string        : r_type          : r_error      :
                          uwxref          : UwSrcDtl.srclib : UwSrcDtl.srcspf :
                          UwSrcDtl.srcmbr : r_rrns          : r_rrne          :
                          in_procedure                                       );
            endif;

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

//------------------------------------------------------------------------------------- //
//Subroutine Process_DS_Subfield_Fx: Parse DS and its subfields and write into
//                                   IAVARREL/IAPGMDS
//------------------------------------------------------------------------------------- //
begsr Process_DS_Subfield_Fx;

   r_iter = 'N';
   r_sts = 'DSFXN';

   //Concate Complete String Till End
   if  r_stm <> *blanks and (%subst(r_stm : 24 : 2) = '  '
       or %subst(r_stm : 24 : 2) = 'DS') and r_fix = 'D';

       if %subst(r_stm:7:10) = '          ';
        // exec sql fetch SrcStmt into :r_stm, :r_rrn, :r_Src_Type;                      // 0012
           Exec Sql Fetch SrcStmt Into :IAQRPG_DATA;                                     //0012
           r_stm = %xlate(wk_lo:wk_Up:r_stm);                                            //0005
           if sqlCode < successCode;
              uDpsds.wkQuery_Name = 'Fetch_21_SrcStmt';
              IaSqlDiagnostic(uDpsds);                                                   //0023
           endif;
           r_iter = 'Y';
           leavesr;
       endif;

   endif;

   select;

      //Process DS name fields in fix format
      when r_dsdcl = *blanks                                                             //0006
           or (%subst(r_string : 24 : 2) = 'DS' And r_fix = 'D');                        //0006
         if r_dsdcl = 'DS';
            r_dsdcl = 'WDS';
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
            when (%subst(r_string : 23 :1) = 'S');
               r_dsobjv = 'PSDS-VAR';
            other;
               r_dsobjv = 'DS-VAR';
         endsl;

      //End of DS decided here
      when %subst(r_string : 24 : 2) <> '  '
           or %subst(r_string : 6 : 1) <> 'D';
         if r_dsdcl = 'DS';
            r_dsdcl = 'WDS';
            IAPSRDSFX(r_string        : r_type          : r_error         : uwxref   :
                      UwSrcDtl.srclib : UwSrcDtl.srcspf : UwSrcDtl.srcmbr : r_rrns   :
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

      //Process subfields in fix format
      other;
         clear r_dsname;
         clear r_dsmody;
         r_dsdcl  = 'DSS';
         r_pos7   = %scan('-' : r_dsobjv);
         r_dsobjv = %replace('SUB': r_dsobjv : r_pos7+1 : 3);
   endsl;

   IAPSRDSFX(r_string        : r_type          : r_error         : uwxref   :
             UwSrcDtl.srclib : UwSrcDtl.srcspf : UwSrcDtl.srcmbr : r_rrns   :
             r_rrne          : r_dsdcl         : r_dsobjv        : r_dsname :
             r_dsmody        : uwdsdtl );


   r_error = 'C';
   if r_error = 'C';
      r_iter = 'N';
      exsr clear_vars;
   endif;

endsr;

//------------------------------------------------------------------------------------- //
//Subroutine Process_DS_Rpg:
//------------------------------------------------------------------------------------- //
begsr Process_DS_rpg;

   r_iter = 'N';
   r_sts  = 'DSRPG3N';

   select;
      when r_dsdcl = *blanks or %subst(r_string : 19 : 2) = 'DS';
         if r_dsdcl = 'DS';
            r_dsdcl = 'WDS';
            IAPSRDSRPG3(r_string        : r_type          : r_error         : uwxref   :
                        UwSrcDtl.srclib : UwSrcDtl.srcspf : UwSrcDtl.srcmbr : r_rrns   :
                        r_rrne          : r_dsdcl         : r_dsobjv        : r_dsname :
                        r_dsmody        : uwdsdtl );

            if %scan('I': r_string: 6) = 6;
               IAPSRISPCV(r_string        : r_type          : r_error         :
                          uwxref          : UwSrcDtl.srclib : UwSrcDtl.srcspf :
                          UwSrcDtl.srcmbr : r_rrns          : r_rrne);
            endif;

         endif;

         clear r_dsmody;
         clear uwdsdtl;
         r_dsdcl = 'DS';
         r_dsname = %subst(r_string : 7 : 6);
         if r_dsname <> *blanks;
            exsr finddsdtl;
         endif;

         select;
            when r_dsobjv = 'INFDS-VAR';
            when r_dsobjv = 'INDDS-VAR';
            when r_string <> *blanks and (%subst(r_string : 18 :1) = 'S');
               r_dsobjv = 'PSDS-VAR';
            other;
               r_dsobjv = 'DS-VAR';
         endsl;

      when r_string <> *blanks and (%subst(r_string : 19 : 2) <> '  '
           or %subst(r_string : 6 : 1) <> 'I');
         if r_dsdcl = 'DS';
            r_dsdcl = 'WDS';
            IAPSRDSFX(r_string        : r_type          : r_error         : uwxref   :
                      UwSrcDtl.srclib : UwSrcDtl.srcspf : UwSrcDtl.srcmbr : r_rrns   :
                      r_rrne          : r_dsdcl         : r_dsobjv        : r_dsname :
                      r_dsmody        : uwdsdtl );

           if %scan('I': r_string: 6) = 6;
              IAPSRISPCV(r_string        : r_type          : r_error         :
                         uwxref          : UwSrcDtl.srclib : UwSrcDtl.srcspf :
                         UwSrcDtl.srcmbr : r_rrns          : r_rrne);
           endif;

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
         clear r_dsmody;
         r_dsdcl  = 'DSS';
         r_pos7   = %scan('-' : r_dsobjv);
         r_dsobjv = %replace('SUB': r_dsobjv : r_pos7+1 : 3);

   endsl;

   IAPSRDSRPG3(r_string          : r_type          : r_error         : uwxref   :
               UwSrcDtl.srclib   : UwSrcDtl.srcspf : UwSrcDtl.srcmbr : r_rrns   :
               r_rrne            : r_dsdcl         : r_dsobjv        : r_dsname :
               r_dsmody          : uwdsdtl );

   if r_string <> *blanks and %scan('I': r_string: 6) = 6;
      IAPSRISPCV(r_string        : r_type          : r_error         :
                 uwxref          : UwSrcDtl.srclib : UwSrcDtl.srcspf :
                 UwSrcDtl.srcmbr : r_rrns          : r_rrne);
   endif;

   r_error    = 'C';
   if r_error = 'C';
      r_iter  = 'N';
      exsr clear_vars;
   endif;

endsr;

//------------------------------------------------------------------------------------- //
//Subroutine Process_Var: Standalone variable parsing in free format
//------------------------------------------------------------------------------------- //
begsr Process_VAR;

   r_iter = 'N';
   if r_string <> *blanks and (%scan('DCL-S ': %trim(r_string) :1) = 1
      or %scan('DCL-C ': %trim(r_string):1) = 1);

      //Concate Complete Statement Till End
      if %scan(';': r_string : %len(%trimr(r_string))) = 0;
       //exec sql fetch SrcStmt into :r_Stm, :r_Rrn, :r_Src_Type;                        //0012
         Exec Sql Fetch SrcStmt Into :IAQRPG_DATA;                                       //0012
         r_stm = %xlate(wk_lo:wk_Up:r_stm);                                              //0005
         if sqlCode < successCode;
            uDpsds.wkQuery_Name = 'Fetch_22_SrcStmt';
            IaSqlDiagnostic(uDpsds);                                                     //0023
         endif;
         r_iter = 'Y';
         leavesr;
      endif;

      if r_string <> *blanks and %scan(';': r_string) > 0
         and %Scan('DCL-C ': %trim(r_string):1) = 1
         and r_iter = 'N';
         IAPSRVARFR(r_string        : r_type          : r_error         :
                    uwxref          : UwSrcDtl.srclib : UwSrcDtl.srcspf :
                    UwSrcDtl.srcmbr : r_rrns          : r_rrne          :
                    in_procedure                                       );

      endif;

      if r_string <> *blanks and %scan(';': r_string) > 0
         and %scan('DCL-S ': %trim(r_string) :1) = 1
         and r_iter = 'N';

         r_dcls = %scan('DCL-S ':r_string) + 6;
         r_dcls = %check(' ':r_string:r_dcls);
         if r_dcls > 0;
            r_dcls = %scan(' ':r_string:r_dcls);
         endif;

         r_dim = 'N';
         //Checking if line contatins DIM keyword and ( after each other
         r_dimpos = %scan('DIM':r_string);
         if r_dimpos > 0;
            r_dimpos +=3;
            r_obrpos = %scan('(':r_string:r_dimpos );
            if r_obrpos > 0 and r_obrpos >= r_dimpos and                                 //0001
              %trim(%subst(r_string:r_dimpos:(r_obrpos-r_dimpos)+1)) = '(';
              r_dim = 'Y';
            endif;
         endif;

         if %scan('LIKE':r_string:r_dcls )  > 0;

            r_likepos  = %scan('LIKE':r_string:r_dcls ) + 5;
            if r_likepos > 0;
               r_likepos  = %scan(')':r_string:r_likepos);
            endif;

            if r_string <> *blanks and r_likepos > 0 and r_dcls > 0
               and %scan('DIM':r_string:r_likepos ) = 0
               and %scan('DIM': %subst(r_string:r_dcls:
                   %scan('LIKE':r_string:r_dcls) - r_dcls)) = 0;

               IAPSRVARFR(r_string        : r_type          : r_error         :
                          uwxref          : UwSrcDtl.srclib : UwSrcDtl.srcspf :
                          UwSrcDtl.srcmbr : r_rrns          : r_rrne          :
                          in_procedure                                       );
            endif;

            if r_string <> *blanks and r_likepos > 0  and r_dcls > 0
               and ( %scan('DIM':r_string:r_likepos ) > 0
               or %scan('DIM': %subst(r_string:r_dcls:
                    %scan('LIKE':r_string:r_dcls) - r_dcls)) > 0);

               IAPSRARRFR(r_string        : r_type          : r_error         :
                          uwxref          : UwSrcDtl.srclib : UwSrcDtl.srcspf :
                          UwSrcDtl.srcmbr : r_rrns          : r_rrne );
            endif;

         endif;

         if r_string <> *blanks and r_dcls > 0
            and (%scan('DIM':r_string:r_dcls ) = 0
            and %scan('LIKE':r_string:r_dcls ) = 0);
            IAPSRVARFR(r_string        : r_type          : r_error         :
                       uwxref          : UwSrcDtl.srclib : UwSrcDtl.srcspf :
                       UwSrcDtl.srcmbr : r_rrns          : r_rrne          :
                       in_procedure                                       );
         endif;

         if r_string <> *blanks and r_dcls > 0
            and %scan('DIM':r_string:r_dcls ) > 0 and r_dim = 'Y'
            and %scan('LIKE':r_string:r_dcls ) = 0;
            IAPSRARRFR(r_string        : r_type          : r_error         :
                       uwxref          : UwSrcDtl.srclib : UwSrcDtl.srcspf :
                       UwSrcDtl.srcmbr : r_rrns          : r_rrne );
         endif;

         exsr clear_vars;

      endif;

   endif;

   if r_fix = 'D' and r_string <> *blanks
      and %subst(r_string:24:1) = 'C' and %scan('...':r_string) = 0;

      if r_ext  <> 'Y';
         r_rrns = r_Rrn;
      endif;

      if r_ext  =  'Y';
         r_rrns = r_Rrnext;
      endif;

      if %len(%trimr(r_string)) > 44;

         r_ext  = 'N';
      // exec sql fetch SrcStmt into :r_stm, :r_rrn, :r_Src_Type;                        //0012
         Exec Sql Fetch SrcStmt Into :IAQRPG_DATA;                                       //0012
         if sqlCode < successCode;
            uDpsds.wkQuery_Name = 'Fetch_23_SrcStmt';
            IaSqlDiagnostic(uDpsds);                                                     //0023
         endif;

         r_stm = %xlate(wk_lo:wk_Up:r_stm);                                              //0005
         r_stringnew = r_stm;
         dow (%len(%trimr(r_stringnew)) > 43
             and %subst(r_stringnew:6:1) =  'D'
             and %subst(r_stringnew:7:1) <> '*'
             and %subst(r_stringnew:24:1) = ' ')
             or (%len(%trim(r_stringnew)) < 3 )
             or (r_stringnew  = *blanks)
             or (%subst(r_stringnew:7:1) = '*');

            iabreakword(uwsrcdtl.srclib : uwsrcdtl.srcspf : uwsrcdtl.srcmbr :
                        r_rrn           : r_stm           :  r_srcflag );

            if %len(%trimr(r_stringnew)) > 43
               and %subst(r_stringnew:6:1) =  'D'
               and %subst(r_stringnew:24:1) = ' '
               and %subst(r_stringnew:7:1) <> '*'
               and %subst(r_stringnew:8:14) = ' '
               and r_ext  = 'N';

               r_ext  = 'Y';
               if %subst(r_string : %len(%trimr(r_String)) : 1) = '-';
                  r_string = %Subst(r_string : 1 : %len(%trimr(r_String)) - 1 );
               endif;

               if %subst(r_stm : %len(%trimr(r_Stm)) : 1) = '-';
                  r_Stm = %Subst(r_Stm : 1 : %len(%trimr(r_Stm)) - 1 );
                  r_ext  = 'N';
               endif;

               r_string = %trimr(r_string) +
                          %trim(%subst(r_stm:44:36));

            endif;

            if %len(%trimr(r_stringnew)) > 43
               and %subst(r_stringnew:6:1) =  'D'
               and %subst(r_stringnew:24:1) = ' '
               and %subst(r_stringnew:7:1) <> '*'
               and r_ext  = 'Y';
               r_string = %trimr(r_string);
            endif;

        //  exec sql fetch SrcStmt into :r_stm, :r_rrn, :r_Src_Type;                     //0012
            Exec Sql Fetch SrcStmt Into :IAQRPG_DATA;                                    //0012
            if sqlCode < successCode;
               uDpsds.wkQuery_Name = 'Fetch_24_SrcStmt';
               IaSqlDiagnostic(uDpsds);                                                  //0023
            endif;

            if SQLCODE = NO_DATA_FOUND;
               leave;
            endif;

            r_stm = %xlate(wk_lo:wk_Up:r_stm);                                           //0005
            r_stringnew = r_stm;

         enddo;

      endif;

      IAPSRVARFX(r_string        : r_type          : r_error         :
                 uwxref          : UwSrcDtl.srclib : UwSrcDtl.srcspf :
                 UwSrcDtl.srcmbr : r_rrns          : r_rrne          :
                 r_lname         : r_word          : in_procedure   );

      exsr clear_vars;
      clear r_lname;
      clear r_word;
      r_ext = 'N';

   endif;

   if r_fix = 'D' and r_string <> *blanks
      and %subst(r_string:24:1) = 'S' and %scan('...':r_string) = 0;

      r_dim = 'N';
      //Checking if line contatins DIM keyword and ( after each other
      r_dimpos = %scan('DIM':r_string);
      if r_dimpos > 0;
         r_dimpos +=3;
         r_obrpos = %scan('(':r_string:r_dimpos );
         if r_obrpos > 0 and r_dimpos > 0 and
           %trim(%subst(r_string:r_dimpos:(r_obrpos-r_dimpos)+1)) = '(';
           r_dim = 'Y';
         endif;
      endif;

      if r_ext <> 'Y';
         r_rrns = r_Rrn;
      endif;

      if r_ext =  'Y';
         r_rrns = r_Rrnext;
      endif;

   // exec sql fetch SrcStmt into :r_stm, :r_rrn, :r_Src_Type;                           //0012
      Exec Sql Fetch SrcStmt Into :IAQRPG_DATA;                                          //0012
      if sqlCode < successCode;
         uDpsds.wkQuery_Name = 'Fetch_25_SrcStmt';
         IaSqlDiagnostic(uDpsds);                                                        //0023
      endif;

      r_stm = %xlate(wk_lo:wk_Up:r_stm);                                                 //0005
      r_stringnew = r_stm;

      dow (%len(%trimr(r_stringnew)) > 43
          and %subst(r_stringnew:6:1) =  'D'
          and %subst(r_stringnew:7:1) <> '*'
          and %subst(r_stringnew:24:1) = ' ')
          or (%len(%trim(r_stringnew)) < 3 )
          or (r_stringnew  = *blanks)
          or (%subst(r_stringnew:7:1) = '*');

         iabreakword(uwsrcdtl.srclib :
                     uwsrcdtl.srcspf :
                     uwsrcdtl.srcmbr :
                     r_rrn           :
                     r_stm           :
                     r_srcflag);

         if %len(%trimr(r_stringnew)) > 43
            and %subst(r_stringnew:6:1) =  'D'
            and %subst(r_stringnew:24:1) = ' '
            and %subst(r_stringnew:7:1) <> '*';
            r_string = %trimr(r_string) + '    ' + %trim(%subst(r_stm:44:36));
         endif;

      // exec sql fetch SrcStmt into :r_stm, :r_rrn, :r_Src_Type;                        //0012
         Exec Sql Fetch SrcStmt Into :IAQRPG_DATA;                                       //0012
         if sqlCode < successCode;
            uDpsds.wkQuery_Name = 'Fetch_26_SrcStmt';
            IaSqlDiagnostic(uDpsds);                                                     //0023
         endif;

         if SQLCODE = NO_DATA_FOUND;
            leave;
         endif;

         r_stm = %xlate(wk_lo:wk_Up:r_stm);                                              //0005
         r_stringnew = r_stm;

      enddo;

      if r_string <> *blanks and %scan('LIKE':r_string:24) > 24
         and %scan('LIKE':r_string:24) < 44;
         r_string  = %subst(r_string:1:24) +
                     '                   ' +
                     %trim(%subst(r_string:
                     %scan('LIKE':r_string:24)));
      endif;

      if r_string <> *blanks and %scan('DIM': %subst(r_string:44))  = 0
         and %scan('LIKE': %subst(r_string:44)) = 0;
         IAPSRVARFX(r_string        : r_type          : r_error         :
                    uwxref          : UwSrcDtl.srclib : UwSrcDtl.srcspf :
                    UwSrcDtl.srcmbr : r_rrns          : r_rrne          :
                    r_lname         : r_word          : in_procedure   );

      endif;

      if r_string <> *blanks and %scan('DIM': %subst(r_string:44))  > 0
         and r_dim = 'Y' and %scan('LIKE': %subst(r_string:44)) = 0;
         IAPSRARRFX(r_string        : r_type          : r_error         :
                    uwxref          : UwSrcDtl.srclib : UwSrcDtl.srcspf :
                    UwSrcDtl.srcmbr : r_rrns          : r_rrne          :
                    r_lname         : r_word );

      endif;

      if r_string <> *blanks and %scan('LIKE':r_string:44 )  > 0;

         r_likepos  = %scan('LIKE':r_string:44) + 4;
         r_likepos  = %scan(')':r_string:r_likepos);
         if r_likepos > 0 and %scan('DIM': %subst(r_string:r_likepos)) = 0 and
            %scan('DIM': %subst(r_string:24:%scan('LIKE':r_string:44)-24)) = 0;
            IAPSRVARFX(r_string        : r_type          : r_error         :
                       uwxref          : UwSrcDtl.srclib : UwSrcDtl.srcspf :
                       UwSrcDtl.srcmbr : r_rrns          : r_rrne          :
                       r_lname         : r_word          : in_procedure   );
         endif;

         if r_likepos > 0 and (%scan('DIM': %subst(r_string:r_likepos)) > 0
            or %scan('DIM': %subst(r_string:24:%scan('LIKE':r_string:44)-24)) > 0);
            IAPSRARRFX(r_string        : r_type          : r_error         :
                       uwxref          : UwSrcDtl.srclib : UwSrcDtl.srcspf :
                       UwSrcDtl.srcmbr : r_rrns          : r_rrne          :
                       r_lname         : r_word );
         endif;

      endif;

      exsr clear_vars;
      clear r_lname;
      clear r_word;
      clear r_rrnext;
      r_ext = 'N';

   endif;

   if r_fix = 'D' and %scan('...':r_string:8) > 0;

      dow (%scan('...':r_string) > 0 and r_fix = 'D'
          and %subst(r_string:7:1) <> '*')
          or (%len(%trim(r_string)) < 3 )
          or (%subst(r_string:7:1) = '*' );

          r_lpos = %scan('...':r_string);
          if r_ext <> 'Y' and r_lpos > 0;
             r_rrnext = r_Rrn;
             r_word = %trim(%subst(r_string:7:r_lpos-7));
             r_word = %trim(r_word) + '...';
          endif;

          if r_lpos > 0 and %subst(r_string:7:1) <> '*';
             r_Lname = %trim(r_Lname) + %trim(%subst(r_string:7:r_lpos-7));
          endif;

          r_ext = 'Y';
       // exec sql fetch SrcStmt into :r_Stm, :r_Rrn, :r_Src_Type;                       //0012
          Exec Sql Fetch SrcStmt Into :IAQRPG_DATA;                                      //0012
          if sqlCode < successCode;
             uDpsds.wkQuery_Name = 'Fetch_27_SrcStmt';
             IaSqlDiagnostic(uDpsds);                                                    //0023
          endif;

          r_stm = %xlate(wk_lo:wk_Up:r_stm);                                             //0005

          iabreakword(uwsrcdtl.srclib : uwsrcdtl.srcspf : uwsrcdtl.srcmbr :
                      r_rrn           : r_stm           : r_srcflag );

          r_string =  r_stm;
          r_fix = %subst(r_string:6:1);

      enddo;

      clear r_string;
      r_iter = 'Y';
      leavesr;

   endif;

endsr;

//------------------------------------------------------------------------------------- //
//Subroutine Process_File : File Parsing in free format
//------------------------------------------------------------------------------------- //
Begsr process_file;

   r_iter = 'N';
   if %scan('DCL-F ':r_string:1) > 0;

      //Concate Complete Statement Till End
      if %scan(';': r_string : %len(%trimr(r_string))) = 0;
       //Exec sql fetch SrcStmt into :r_Stm, :r_Rrn, :r_Src_Type;                        //0012
         Exec Sql Fetch SrcStmt Into :IAQRPG_DATA;                                       //0012
         r_stm = %xlate(wk_lo:wk_Up:r_stm);                                              //0005
         if sqlCode < successCode;
            uDpsds.wkQuery_Name = 'Fetch_28_SrcStmt';
            IaSqlDiagnostic(uDpsds);                                                     //0023
         endif;
         r_iter ='Y';
         leavesr;
      endif;

      //Parse File Statement
      if %scan(';': r_string : %len(%trimr(r_string))) > 0;
         IAPSRFLFR(r_string        : r_type          : r_error         :
                   uwxref          : UwSrcDtl.srclib : UwSrcDtl.srcspf :
                   UwSrcDtl.srcmbr : r_rrns          : r_rrne );

         if r_error = 'C';
            exsr clear_vars;
         endif;

      endif;

   elseif %subst(r_string:6:1)  = 'F'
          and %subst(r_string:7:1) <> '*';

      dow sqlCode = successCode;
         r_cat     = '@';
         r_chkprv  = 'Y';
         if r_iter = 'N';

         // exec sql fetch SrcStmt into :r_Stm, :r_Rrn, :r_Src_Type;                     //0012
            Exec Sql Fetch SrcStmt Into :IAQRPG_DATA;                                    //0012
            r_stm = %xlate(wk_lo:wk_Up:r_stm);                                           //0005
            if sqlCode < successCode;
               uDpsds.wkQuery_Name = 'Fetch_29_SrcStmt';
               IaSqlDiagnostic(uDpsds);                                                  //0023
            Elseif sqlCode <> successCode;
               r_chkprv = 'N';
               leave;
            endif;

         else;
            r_iter = 'N';
         endif;

         exsr Fetch_Specs;
         exsr Format_string;

         if sqlcod = 100;
            r_iter ='N';
            leave;
         endif;

         if r_iter ='Y';
            iter;
         endif;

         iabreakword(uwsrcdtl.srclib :  uwsrcdtl.srcspf : uwsrcdtl.srcmbr :
                     r_rrn           :  r_stm           : r_srcflag);

         r_chkprv = 'N';
         if %subst(r_stm:6:1)  = 'F'
            and %subst(r_stm:7:10) = '          ';
            r_string = %trimr(r_string) + r_cat + r_stm;
         else;
            leave;
         endif;

      enddo;

      r_cat = ' ';
      IAPSRFLFX(r_string        : r_type          : r_error         :
                uwxref          : UwSrcDtl.srclib : UwSrcDtl.srcspf :
                UwSrcDtl.srcmbr : r_rrns          : r_rrne );

      r_error = 'C';
      if r_error = 'C';
         exsr clear_vars;
         r_iter ='Y';
      endif;

   endif;

endsr;

//------------------------------------------------------------------------------------- //
//Subroutine Process_klist_fx: To process the Key list
//------------------------------------------------------------------------------------- //
begsr Process_klist_fx;

   r_iter = 'N';
   IAPSRKLFX(r_string        : r_type          : r_error         :
             uwxref          : UwSrcDtl.srclib : UwSrcDtl.srcspf :
             UwSrcDtl.srcmbr : r_rrns          : r_rrne          :
             r_ioopcode      : uwkldtl );

   r_error = 'C';
   if r_error = 'C';
      r_iter = 'N';
      exsr clear_vars;
   endif;

endsr;

//------------------------------------------------------------------------------------- //
//Subroutine Process_Klist_Rpg3: To process key lsit (RPG III)
//------------------------------------------------------------------------------------- //
begsr Process_klist_rpg3;

   r_iter = 'N';
   IAPSRKLRPG3(r_string        : r_type          : r_error         :
               uwxref          : UwSrcDtl.srclib : UwSrcDtl.srcspf :
               UwSrcDtl.srcmbr : r_rrns          : r_rrne          :
               r_ioopcode      : uwkldtl );

   r_error    = 'C';
   if r_error = 'C';
      r_iter  = 'N';
      exsr clear_vars;
   endif;

endsr;

//------------------------------------------------------------------------------------- //
//Subroutine Process_Arr: To process arrays
//------------------------------------------------------------------------------------- //
begsr Process_Arr;

   r_iter = 'N';
   if %len(%trimr(r_string))   >  40;

      if %subst(r_string:6:1)  =  'E'
         and %subst(r_string:7:1)  <> '*'
         and %subst(r_string:27:6) <> ' '
         and %subst(r_string:36:4) <> ' ';
         r_word = *blanks;
         r_lname = *blanks;
         IAPSRARRFX(r_string        : r_type          : r_error         :
                    uwxref          : UwSrcDtl.srclib : UwSrcDtl.srcspf :
                    UwSrcDtl.srcmbr : r_rrns          : r_rrne          :
                    r_lname         : r_word );

         exsr clear_vars;
      endif;

   endif;

endsr;

//------------------------------------------------------------------------------------- //
//Subroutine FindDsDtl: Get DS detail
//------------------------------------------------------------------------------------- //
begsr FindDsDtl;

   exec sql
     select FLPGFILE, FLKWNFDS, FLKWNDDS  into :uwdstyp
       from IAPGMFILES
     where FlLibNm    = trim(:uwSrcDtl.SrcLib)
       and FlSrcPfNm  = trim(:uwSrcDtl.SrcSpf)
       and FlSrcMbr   = trim(:uwSrcDtl.SrcMbr)
       and (FlKwNfds  = trim(:r_DsName)
       or   FlKwNdds = trim(:r_DsName) )
     fetch first row only;

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Select_IAPGMFILES';
      IaSqlDiagnostic(uDpsds);                                                           //0023
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
         r_dsobjv = *blanks;
         r_dsmody = *blanks;
      endsl;
   endif;

   sqlCode = successCode;
   clear uwdstyp;

endsr;

//------------------------------------------------------------------------------------- //
//Subroutine SnglSpcString : Format String Into Single Spacing String
//------------------------------------------------------------------------------------- //
begsr SnglSpcString;

   r_spos = 1;
   r_pos7 = %scan(' ':%trim(r_string):r_spos);
   dow r_pos7 > 0 and  (r_pos7 < %len(%trim(r_string)));

      r_pos8 = %check(' ':%trim(r_string):r_pos7);

      If r_pos7  > 0 and r_pos8 > 0  and (r_pos8 - r_pos7) > 1 ;
         r_string = %trim(%replace(' ':%trim(r_string):r_pos7:r_pos8-r_pos7));
      endif ;

      r_pos7 = r_pos7 + 1;
      r_pos7 = %scan(' ':%trim(r_string):r_pos7);

   enddo;

endsr;

//------------------------------------------------------------------------------------- //
//Subroutine Process_PRPI: Process PR/PI definitions
//------------------------------------------------------------------------------------- //
begsr Process_PRPI;

   r_iter = 'N';
   select;
      when %scan('DCL-PR ':r_string:1) > 0
           or %scan('DCL-PI ':r_string:1) > 0
           or %scan('DCL-PROC ':r_string:1) > 0;

          //-----To check for a valid DCL-PROC statement ------//                         //0011

          procPos = %scan('DCL-PROC ': r_string );                                         //0011
          if procPos > 0 and %len( %trim(r_string) ) >= 10;                                //0011

            //------------- Getting the Procedure name ----------------//                 //0011

            prNameStrt =  %check( ' ':r_string : procPos + 8 );                            //0011

            if prNameStrt > 0;                                                             //0011
               prNameEnd = %scan( ' ': %trimR( r_string ): prNameStrt );                   //0011

               if prNameEnd  <= %len(%trimR(r_string));                                    //0011
                                                                                           //0011

                  if prNameEnd > 0 and prNameEnd > prNameStrt;                             //0011
                     procedureNm = %subst( r_string : prNameStrt                           //0011
                                     : prNameEnd - prNameStrt );                           //0011
                  elseif prNameEnd = 0;                                                    //0011
                     prNameEnd   = %len(%trimR(r_string));                                 //0011
                     procedureNm = %subst( r_string : prNameStrt                           //0011
                                     : prNameEnd - prNameStrt );                           //0011
                  endif;                                                                   //0011

                //-------------- If EXPORT Keyword --------------- //

                  if %scan('EXPORT': r_string: prNameEnd ) > 0;                            //0011
                    procEI = 'E';                                                          //0011
                  else;                                                                    //0011
                    procEI = 'I';                                                          //0011
                  endif;                                                                   //0011

               endif;                                                                      //0011

            endif;                                                                         //0011

               //-----------Insert into IAPROCINFO file-------------- //                  //0015
               WriteProceduredetail( UwSrcDtl.srcmbr                                       //0011
                                    :UwSrcDtl.srcspf                                       //0011
                                    :UwSrcDtl.srclib                                       //0011
                                    :UwSrcDtl.srcType                                      //0011
                                    :r_srcSeq                                              //0011
                                    :r_rrn                                                 //0011
                                    :procedurenm                                           //0011
                                    :'PI'                                                  //0011
                                    :procEI );                                             //0011
               exsr clear_vars;                                                            //0011
               leavesr;                                                                    //0011
          endif;                                                                           //0011


         wk_pos5 = %scan(';' : r_string : 1);
         wk_pos6 = %scan(';' : r_string : wk_pos5 + 1);

         select;

            when wk_pos5 > 0  and  wk_pos6 > 0
                 and %Scan('DCL-PI ':r_string:1) = 0
                 and %Scan('DCL-PR ':r_string:1) = 0 ;

                  exsr clear_vars;

            when %scan('END-PR ': r_string ) = 0
                 and %scan('END-PR;': r_string ) = 0
                 and %scan('END-PI ': r_string ) = 0
                 and %scan('END-PI;': r_string ) = 0;

             //exec sql fetch SrcStmt into :r_Stm, :r_Rrn, :r_Src_Type;                  //0012
               Exec Sql Fetch SrcStmt Into :IAQRPG_DATA;                                 //0012
               r_stm = %xlate(wk_lo:wk_Up:r_stm);                                        //0005
               r_iter = 'Y';
               leavesr;

            when %scan('END-PR ': r_string ) > 0
                 or %scan('END-PR;': r_string ) > 0;
               IAPSRPRFR(r_string        : r_type          : r_error         :
                         uwxref          : UwSrcDtl.srclib : UwSrcDtl.srcspf :
                         UwSrcDtl.srcmbr : r_rrns          : r_rrne          :
                          r_srcSeqs       : in_procedure    : *omit          );          //0019

              // Passing the procedure name in case of PI                                  //0019
              when  %scan('END-PI ': r_string ) > 0                                        //0019
                   or %scan('END-PI;': r_string ) > 0;                                     //0019
                 IAPSRPRFR(r_string        : r_type          : r_error         :           //0019
                           uwxref          : UwSrcDtl.srclib : UwSrcDtl.srcspf :           //0019
                           UwSrcDtl.srcmbr : r_rrns          : r_rrne          :           //0019
                           r_srcSeqs       : in_procedure : procedureNm        );          //0019
                 clear procedureNm;                                                        //0019

               if r_error = 'C';
                  exsr clear_vars;
               endif;
         endsl;


      when (%subst(r_string:6:1) = 'D' and %subst(r_string:24:2) = 'PR' )
           or (%subst(r_string:6:1) = 'D' and %subst(r_string:24:2) = 'PI' );

          dow sqlCode = successCode;

           //exec sql fetch SrcStmt into :r_Stm, :r_Rrn, :r_Src_Type;                    //0007
             Exec Sql Fetch SrcStmt Into :IAQRPG_DATA;                                   //0012
             r_stm = %xlate(wk_lo:wk_Up:r_stm);                                          //0005

             if sqlCode < successCode;
                uDpsds.wkQuery_Name = 'Fetch_31_SrcStmt';
                IaSqlDiagnostic(uDpsds);                                                 //0023
             Elseif sqlCode <> successCode;
                r_chkprv = 'N';
                leave;
             endif;

             if %subst(r_stm: 7: 1) = '*';
                iter;
             endif;

             //... > 78 condition is for tag given after Valid procedure declaration
             if %subst(r_stm: 6: 1)  = 'D'
                and %subst(r_stm: 24: 2) = '  '
                and ((%scan('...':r_stm) = 0) Or (%scan('...':r_stm) > 78))              //0002
                and sqlCode = successCode;

                iabreakword(uwsrcdtl.srclib : uwsrcdtl.srcspf :  uwsrcdtl.srcmbr :
                            r_rrn           : r_stm           :  r_srcflag);

                r_string = %trimr(r_string) + r_cat + %trimr(r_stm );
                r_rrne= r_rrn;
                iter;
             else;
                If r_rrne = *Zeros;                                                      //0002
                   r_rrne = r_rrn;                                                       //0002
                Endif;                                                                   //0002
                leave;
             endif;

         enddo;

         //Call program
         r_prstring = %trimr(r_string) + r_cat;
         IAPSRPRFX(r_prstring      : r_type          : r_error         : uwxref :
                   UwSrcDtl.srclib : UwSrcDtl.srcspf : UwSrcDtl.srcmbr : r_rrns :
                   r_rrne          : r_srcSeqs       : r_longprname :                    //0011
                   in_procedure);                                                        //0020

         //Remove
         exsr Clear_Vars;
         clear r_longprname;
         r_cat = ' ';
         r_iter = 'Y';
         leavesr;

         //Condition to capture the PI with procedure begning source statement in fix RPG
      when r_fix = 'P' and %subst(r_string:24:1) = 'B';

         dow sqlCode = successCode;

            exsr ReadNext;
            if sqlCode <> successCode;
               leave;
            elseif %subst(r_stm: 7: 1) = '*';
               iter;
            endif;

            w_LongVar = *blank;

            if %subst(r_stm:6:1) = 'D' and (%subst(r_stm:24:2) = 'PI'
               or %subst(r_stm:24:2) = ' ')
               and sqlCode = successCode;

               iabreakword(uwsrcdtl.srclib : uwsrcdtl.srcspf :  uwsrcdtl.srcmbr :
                           r_rrn           : r_stm           :  r_srcflag);

               r_string = %trimr(r_string) + r_cat + %trimr(r_stm );
               r_rrne= r_rrn;
               iter;

            //Condition to capture the PI if long name is used in fix RPG
            elseif %subst(r_stm:6:1) = 'D' and %scan('...':r_stm) > 0;
               w_LongVar = %trimr(r_stm);

               iabreakword(uwsrcdtl.srclib : uwsrcdtl.srcspf :  uwsrcdtl.srcmbr :
                           r_rrn           : r_stm           :  r_srcflag);

               exsr ReadNext;
               dow %subst(r_stm: 7: 1) = '*';
                 exsr ReadNext;
               enddo;

               if %subst(r_stm:6:1) = 'D' and (%subst(r_stm:24:2) = ' '
                  or %subst(r_stm:24:2) = 'PI');

                  iabreakword(uwsrcdtl.srclib : uwsrcdtl.srcspf :  uwsrcdtl.srcmbr :
                             r_rrn           : r_stm           :  r_srcflag);

                  r_string = %trimr(r_string) + r_cat + %trimr(w_LongVar)
                             + r_cat + %trimr(r_stm );
                  r_rrne= r_rrn;
                  iter;

               else;
                 leave;
               endif;
            else;
               leave;
            endif;

        enddo;
         //Call program
         r_prstring = %trimr(r_string) + r_cat;                                              //SG01
         IAPSRPRFX(r_prstring      : r_type          : r_error         : uwxref :            //SG01
                   UwSrcDtl.srclib : UwSrcDtl.srcspf : UwSrcDtl.srcmbr : r_rrns :            //SG01
                   r_rrne          : r_srcSeqs       : r_longprname :                        //0011
                   in_procedure);                                                        //0020
                                                                                             //SG01
         //Remove                                                                           //SG01
         exsr Clear_Vars;                                                                    //SG01
         clear r_longprname;                                                                 //SG01
         r_cat = ' ';                                                                        //SG01
         r_iter = 'Y';                                                                       //SG01
         leavesr;                                                                            //SG01
   endsl;

endsr;

//--------------------------------------------------------------------------------           //SG01
begsr ReadNext;                                                                               //SG01

//exec sql fetch SrcStmt into :r_Stm, :r_Rrn, :r_Src_Type;                               //0012
  Exec Sql Fetch SrcStmt Into :IAQRPG_DATA;                                              //0012
  r_stm = %xlate(wk_lo:wk_Up:r_stm);                                                     //0005
  if sqlCode < successCode;                                                                   //SG01
    uDpsds.wkQuery_Name = 'Fetch_31_SrcStmt';                                                 //SG01
    IaSqlDiagnostic(uDpsds);                                                             //0023/SG01
  Elseif sqlCode <> successCode;                                                              //SG01
    r_chkprv = 'N';                                                                           //SG01
    leavesr;                                                                                  //SG01
  endif;                                                                                      //SG01

endsr;                                                                                        //SG01

//--------------------------------------------------------------------------------
//Process_Ent :
//--------------------------------------------------------------------------------
begsr process_ent;

   if %subst(r_string:6:1) = 'C' and
      %subst(r_string:7:1) <> '*' and
      %subst(r_string:12:6) = '*ENTRY' and
      %subst(r_string:26:5) = 'PLIST';

      r_prc = *blanks;
      r_seq = 0;
    //exec sql fetch SrcStmt into :r_Stm, :r_Rrn, :r_Src_Type;                           //0012
      Exec Sql Fetch SrcStmt Into :IAQRPG_DATA;                                          //0012
      if sqlCode < successCode;
         uDpsds.wkQuery_Name = 'Fetch_32_SrcStmt';                                       //AK09
         IaSqlDiagnostic(uDpsds);                                                        //0023
      endif;
      r_stm = %xlate(wk_lo:wk_Up:r_stm);                                                 //0005
      r_string = r_Stm;
      dow (%subst(r_string:6:1) = 'C' and
           %subst(r_string:26:4) = 'PARM' and
           %subst(r_string:7:1) <> '*') or
          (%len(%trim(r_string)) < 3 ) or
          (%subst(r_string:7:1) = '*' );

          iabreakword(uwsrcdtl.srclib :  uwsrcdtl.srcspf : uwsrcdtl.srcmbr :
                      r_rrn           :  r_stm           : r_srcflag );

          if %subst(r_string:6:1) = 'C' and
             %subst(r_string:26:4) = 'PARM' and
             %subst(r_string:7:1) <> '*';

             r_rrns = r_rrn;
             r_seq = r_seq + 1;
             IAPSRENTFX(r_string        : r_type          : r_error         : uwxref :
                        UwSrcDtl.srclib : UwSrcDtl.srcspf : UwSrcDtl.srcmbr : r_rrns :
                        r_rrne          : r_seq           : r_prc );

             exsr clear_vars;
          endif;
       // exec sql fetch SrcStmt into :r_Stm, :r_Rrn, :r_Src_Type;                       //0012
          Exec Sql Fetch SrcStmt Into :IAQRPG_DATA;                                      //0012
          r_stm = %xlate(wk_lo:wk_Up:r_stm);                                             //0005
          if sqlCode < successCode;
             uDpsds.wkQuery_Name = 'Fetch_33_SrcStmt';                                   //AK09
             IaSqlDiagnostic(uDpsds);                                                    //0023
          endif;
          if SQLCODE = NO_DATA_FOUND;                                                    //MT02
            leavesr;
          endif;
          if %subst(r_stm:1:3) = '** ';
             clear r_string;
             r_iter = 'Y';
             leavesr;
          endif;
          r_string = r_Stm;
      enddo;
      clear r_string;
      r_iter = 'Y';
      leavesr;
   endif;

   if %subst(r_string:6:1) = 'C' and
      %subst(r_string:7:1) <> '*' and
      %subst(r_string:18:6) = '*ENTRY' and
      %subst(r_string:28:5) = 'PLIST';

      r_seq = 0;
      r_prc = *blanks;
    //exec sql fetch SrcStmt into :r_Stm, :r_Rrn, :r_Src_Type;                           //0012
      Exec Sql Fetch SrcStmt Into :IAQRPG_DATA;                                          //0012
      if sqlCode < successCode;
         uDpsds.wkQuery_Name = 'Fetch_34_SrcStmt';                                       //AK09
         IaSqlDiagnostic(uDpsds);                                                        //0023
      endif;
      r_stm = %xlate(wk_lo:wk_Up:r_stm);                                                 //0005
      r_string = r_Stm;
      dow (%subst(r_string:6:1) = 'C' and
           %subst(r_string:28:4) = 'PARM' and
           %subst(r_string:7:1) <> '*') or
          (%len(%trim(r_string)) < 3 ) or
          (%subst(r_string:7:1) = '*' );

          iabreakword(uwsrcdtl.srclib :
                      uwsrcdtl.srcspf :
                      uwsrcdtl.srcmbr :
                      r_rrn           :
                      r_stm           :
                      r_srcflag);

         if %subst(r_string:6:1) = 'C' and
            %subst(r_string:28:4) = 'PARM' and
            %subst(r_string:7:1) <> '*';
            r_rrns = r_rrn;
            r_seq = r_seq + 1;
            IAPSRENTFX3(r_string        : r_type          : r_error         : uwxref :
                        UwSrcDtl.srclib : UwSrcDtl.srcspf : UwSrcDtl.srcmbr : r_rrns :
                        r_rrne          : r_seq           : r_prc );

            exsr clear_vars;
         endif;

     //  exec sql fetch SrcStmt into :r_Stm, :r_Rrn, :r_Src_Type;                        //0012
         Exec Sql Fetch SrcStmt Into :IAQRPG_DATA;                                       //0012
         r_stm = %xlate(wk_lo:wk_Up:r_stm);                                              //0005
         if sqlCode < successCode;
            uDpsds.wkQuery_Name = 'Fetch_35_SrcStmt';                                    //AK09
            IaSqlDiagnostic(uDpsds);                                                     //0023
         endif;
         if SQLCODE = NO_DATA_FOUND;                                                     //MT02
            leavesr;
         endif;
         if %subst(r_stm:1:3) = '** ';
            clear r_string;
            r_iter = 'Y';
            leavesr;
         endif;
         r_string = r_Stm;
      enddo;
      clear r_string;
      r_iter = 'Y';
      leavesr;
   endif;

endsr;
//--------------------------------------------------------------------------------      //0008
//Process_Plist: Enter values of PLIST into IAPGMVARS                                   //0008
//--------------------------------------------------------------------------------      //0008
BegSr Process_Plist;                                                                     //0008
                                                                                         //0008
   //Check if PLIST which is not *ENTRY for RPG4                                        //0008
   If %SubSt(r_String:6:1) = 'C' And                                                     //0008
      %SubSt(r_String:7:1) <> '*' And                                                    //0008
      %SubSt(r_String:12:6) <> '*ENTRY' And                                              //0008
      %SubSt(r_String:26:5) = 'PLIST';                                                   //0008
                                                                                         //0008
      R_Prc = *blanks;                                                                   //0008
      R_Seq = 0;                                                                         //0008
    //Exec Sql Fetch SrcStmt Into :R_Stm, :R_Rrn;                                        //0012
      Exec Sql Fetch SrcStmt Into :IAQRPG_DATA;                                          //0012
      If SqlCode < SuccessCode;                                                          //0008
         UdPsds.WkQuery_Name = 'Fetch_40_SrcStmt';                                       //0008
         IaSqlDiagnostic(UdPsds);                                                        //0023
      EndIf;                                                                             //0008

     r_String = r_Stm;                                                                   //0008
     //Check for PLIST Value with PARAM entry which is not *ENTRY
     Dow (%SubSt(r_String:6:1) = 'C' And                                                 //0008
         %SubSt(r_String:26:4) = 'PARM' And                                              //0008
         %SubSt(r_String:7:1) <> '*') ;                                                  //0008

        R_Rrns = R_Rrn;                                                                  //0008
        R_seq = R_seq + 1;                                                               //0008

        IAPSRPLSTFX(R_string        : R_type          : R_error         : Uwxref         //0008
                    : UwSrcDtl.Srclib : UwSrcDtl.Srcspf : UwSrcDtl.Srcmbr : R_Rrns       //0008
                    : R_Rrne          : R_Seq           : R_Prc );                       //0008
                                                                                         //0008
        Exsr Clear_Vars;                                                                 //0008

    //  Exec Sql Fetch SrcStmt Into :R_Stm, :R_Rrn;                                      //0012
        Exec Sql Fetch SrcStmt Into :IAQRPG_DATA;                                        //0012

        If SqlCode < SuccessCode;                                                        //0008
           UdPsds.WkQuery_Name = 'Fetch_41_SrcStmt';                                     //0008
           IaSqlDiagnostic(UdPsds);                                                      //0023
        EndIf;                                                                           //0008

        If SQLCODE = NO_DATA_FOUND;                                                      //0008
           LeaveSr;                                                                      //0008
        EndIf;
                                                                                         //0008
        If %Subst(R_Stm:1:3) = '** ';                                                    //0008
           Clear R_String;                                                               //0008
           R_Iter = 'Y';                                                                 //0008
           LeaveSr;                                                                      //0008
        EndIf;                                                                           //0008
        R_String = R_Stm;                                                                //0008

     EndDo;                                                                              //0008

     Clear R_String;                                                                     //0008
     R_Iter = 'Y';                                                                       //0008
     LeaveSr;                                                                            //0008
   EndIf;                                                                                //0008

   //Check if PLIST which is not *ENTRY for RPG3                                        //0008
   If %SubSt(R_String:6:1) = 'C' And                                                     //0008
      %SubSt(R_String:7:1) <> '*' And                                                    //0008
      %SubSt(R_String:18:6) <> '*ENTRY' And                                              //0008
      %SubSt(R_String:28:5) = 'PLIST';                                                   //0008

      R_Seq = 0;                                                                         //0008
      R_Prc = *Blanks;                                                                   //0008
   // Exec Sql Fetch SrcStmt Into :R_Stm, :R_Rrn;                                        //0012
      Exec Sql Fetch SrcStmt Into :IAQRPG_DATA;                                          //0012

      If SqlCode < SuccessCode;                                                          //0008
         UdPsds.WkQuery_Name = 'Fetch_42_SrcStmt';                                       //0008
         IaSqlDiagnostic(UdPsds);                                                        //0023
      EndIf;                                                                             //0008

      R_String = R_Stm;                                                                  //0008
      //Check for PLIST Value with PARAM entry which is not *ENTRY                      //0008
      Dow (%SubSt(R_String:6:1) = 'C' And                                                //0008
           %SubSt(R_String:28:4) = 'PARM' And                                            //0008
           %SubSt(R_String:7:1) <> '*');                                                 //0008

         R_Rrns = R_Rrn;                                                                 //0008
         R_Seq = R_Seq + 1;                                                              //0008
         IAPSRPLSTFX3(R_String        : R_Type          : R_Error         : Uwxref       //0008
                      : UwSrcDtl.Srclib : UwSrcDtl.Srcspf : UwSrcDtl.Srcmbr : R_Rrns     //0008
                      : R_Rrne          : R_Seq           : R_Prc );                     //0008

         Exsr Clear_Vars;                                                                //0008

      // Exec Sql Fetch SrcStmt Into :R_Stm, :R_Rrn;                                     //0012
         Exec Sql Fetch SrcStmt Into :IAQRPG_DATA;                                       //0012
         If SqlCode < SuccessCode;                                                       //0008
            UdPsds.WkQuery_Name = 'Fetch_43_SrcStmt';                                    //0008
            IaSqlDiagnostic(UdPsds);                                                     //0023
         EndIf;                                                                          //0008

         If SQLCODE = NO_DATA_FOUND;                                                     //0008
              LeaveSr;                                                                   //0008
         EndIf;                                                                          //0008

         If %Subst(R_Stm:1:3) = '** ';                                                   //0008
            Clear R_String;                                                              //0008
            R_Iter = 'Y';                                                                //0008
            LeaveSr;                                                                     //0008
         EndIf;                                                                          //0008

         R_String = R_Stm;                                                               //0008
     EndDo;                                                                              //0008

     Clear R_String;                                                                     //0008
     R_Iter = 'Y';                                                                       //0008
     LeaveSr;                                                                            //0008
  EndIf;                                                                                 //0008

Endsr;                                                                                   //0008
//--------------------------------------------------------------------------//
//Get_Rec_IASRCMBRID : Populate File IASRCMBRID
//--------------------------------------------------------------------------//
begsr Get_Rec_IASRCMBRID;

   exec sql insert into IASRCMBRID (MBRNAME,
                                    MBRSRCPF,
                                    MBRLIB,
                                    MBRTYPE,
                                    MBRTLOC,
                                    MBRCLOC,
                                    MBRBLOC,
                                    MBRBFLAG,
                                    MBRLOCN,
                                    MBRIFSID)
     values(:UwSrcDtl.srcmbr,
            :UwSrcDtl.srcSpf,
            :UwSrcDtl.srclib,
  //        :UwSrcDtl.mbrtyp1,                                                       //0010
            :UwSrcDtl.srcType,                                                       //0010
            0,
            0,
            0,
            ' ',
            ' ',
            0);

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Insert_IASRCMBRID';                                         //AK09
      IaSqlDiagnostic(uDpsds);                                                           //0023
   endif;

endsr;
//--------------------------------------------------------------------------//
//Write_RRN_Error : Populate File IAEXCPLOG
//--------------------------------------------------------------------------//
Begsr Write_RRN_Error;

   exec sql
     insert into IAEXCPLOG (PRS_SOURCE_LIB,
                            PRS_SOURCE_FILE,
                            PRS_SOURCE_SRC_MBR,
                            LIBRARY_NAME,
                            PROGRAM_NAME,
                            RRN_NO,
                            EXCEPTION_TYPE,
                            EXCEPTION_NO,
                            EXCEPTION_DATA,
                            SOURCE_STM,
                            MODULE_PGM,
                            MODULE_PROC)
       values(trim(:uwsrcdtl.srclib),
              trim(:uwsrcdtl.srcspf),
              trim(:uwsrcdtl.srcmbr),
              trim(:uDpsds.SrcLib),
              trim(:uDpsds.ProcNme),
              trim(char(:R_rrn)),
              trim(:uDpsds.ExcptTyp),
              trim(:uDpsds.ExcptNbr),
              trim(:uDpsds.RtvExcptDt),
              trim(:r_stm),
              trim(:uDpsds.ProcNme),
              trim(:uDpsds.ModuleProc));

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Insert_IAEXCPLOG';                                          //AK09
      IaSqlDiagnostic(uDpsds);                                                           //0023
   endif;

endsr;
//--------------------------------------------------------------------------//
//Process_Call :
//--------------------------------------------------------------------------//
begsr process_call;

   select;
   when %subst(r_string:r_pos1:5) = 'CALLP';
      r_pos1 = %scan('(':r_string:36);
      if r_pos1 > 0;
         r_clprocnm = %subst(r_string:36:r_pos1-36);
         w_opnbrkfnd = *on;                                         // AK01
      endif;

      if w_opnbrkfnd = *on;                                         // AK01
         w_opnbrkfnd = *off;                                        // AK01
         w_bracket = ')';                                                                //0025
      else;                                                                              //0025
         w_bracket = '(';                                                                //0025
      endif;                                                                             //0025

      // dow %scan(')':r_string:36) = *zero;                                             //0025
         dow %scan(w_bracket:r_string:36) = *zero;                                       //0025
            r_chkprv = 'Y';
            if r_iter = 'N';
           //  exec sql fetch SrcStmt into :r_Stm, :r_Rrn, :r_Src_Type;                  //0012
               Exec Sql Fetch SrcStmt Into :IAQRPG_DATA;                                 //0012
               if sqlCode < successCode;
                  uDpsds.wkQuery_Name = 'Fetch_36_SrcStmt';                              //AK09
                  IaSqlDiagnostic(uDpsds);                                               //0023
               endif;
            else;
               r_iter = 'N';
            endif;
            r_stm = %xlate(wk_lo:wk_Up:r_stm);                                           //0005
            exsr Fetch_Specs;
            exsr Format_string;
            if r_iter ='Y';
               iter;
            endif;

            iabreakword(uwsrcdtl.srclib :
                        uwsrcdtl.srcspf :
                        uwsrcdtl.srcmbr :
                        r_rrn           :
                        r_stm           :
                        r_srcflag);

            r_chkprv = 'N';

            // for long program name checing next line
            c_pos = %scan('...':r_string:36);                                            //0025
            If c_pos > 0;                                                                //0025
               r_string = %subst(r_string:1:c_pos-1);                                    //0025
            Endif;                                                                       //0025

            //r_string = %trim(r_string) + %trim(%subst(r_Stm:36:45));
            r_string = %trimr(r_string) + %trim(%subst(r_Stm:36:45));

            r_pos1 = %scan('(':r_string:36);                                             //0025
            if r_pos1 > 0;                                                               //0025
               r_clprocnm = %subst(r_string:36:r_pos1-36);                               //0025
               w_bracket = ')';                                                          //0025
            else;                                                                        //0025
               w_bracket = '(';                                                          //0025
            endif;                                                                       //0025

         enddo;
   // endif;                                                                             //0025

      IAPSRCALLP(r_string        : r_type          : r_error         :
                 uwxref          : UwSrcDtl.srclib : UwSrcDtl.srcspf :
                 UwSrcDtl.srcmbr : r_rrns          : r_rrne );

   when %subst(r_string:r_pos1:5) = 'CALL' or
        %subst(r_string:r_pos1:5) = 'CALL(' or
        %subst(r_string:r_pos1:5) = 'CALLB';

      if (%subst(r_string:50:14) <> *blanks and r_pos1 = 26) or
         (%subst(r_string:43:6) <> *blanks and r_pos1 = 28);

         IAPSRCALLP(r_string        : r_type          : r_error         :
                    uwxref          : UwSrcDtl.srclib : UwSrcDtl.srcspf :
                    UwSrcDtl.srcmbr : r_rrns          : r_rrne );
      else;
         dow sqlCode = successCode;                                                   //DB01
            R_chkprv = 'Y';
            if r_iter = 'N';
             //exec sql fetch SrcStmt into :r_Stm, :r_Rrn, :r_Src_Type;                  //0012
               Exec Sql Fetch SrcStmt Into :IAQRPG_DATA;                                 //0012
               r_stm = %xlate(wk_lo:wk_Up:r_stm);                                        //0005
               if sqlCode < successCode;
                  uDpsds.wkQuery_Name = 'Fetch_37_SrcStmt';                              //AK09
                  IaSqlDiagnostic(uDpsds);                                               //0023
               ElseIf sqlCode <> successCode;                                            //YG01
                  R_chkprv = 'N';                                                        //YG01
                  Leave;                                                                 //YG01
               endif;
            else;
               r_iter = 'N';
            endif;
            wr_pos1 = r_pos1;

            exsr Fetch_Specs;
            exsr Format_string;
            r_pos1 = wr_pos1;

            If sqlCode <> successCode;                                              //YG01
               R_chkprv = 'N';                                                       //YG01
               Leave;                                                                //YG01
            EndIf;                                                                  //YG01
            if r_iter ='Y';
               iter;
            endif;

            iabreakword(uwsrcdtl.srclib :
                        uwsrcdtl.srcspf :
                        uwsrcdtl.srcmbr :
                        r_rrn           :
                        r_stm           :
                        r_srcflag);

            R_chkprv = 'N';
            if %subst(r_stm:6:1) = 'C' and
               %subst(r_stm:r_pos1:4) = 'PARM' and  SQLCODE = successCode;

                r_string = %trimr(r_string)  + ' @'  + r_Stm;
            else;
                leave;
            endif;
         enddo;

         r_cat = ' ';
         IAPSRCALLP(r_string        : r_type          : r_error         :
                    uwxref          : UwSrcDtl.srclib : UwSrcDtl.srcspf :
                    UwSrcDtl.srcmbr : r_rrns          : r_rrne );

         r_error = 'C';
         if r_error = 'C';
            exsr clear_vars;
            r_iter ='Y';
         endif;
      endif;
   endsl;

endsr;
//-----------------------------------------------------------------------------//
//Process_Free_Call :
//-----------------------------------------------------------------------------//
Begsr Process_free_call;

   exec sql
     select Count(1) into :r_count                                                       //VM002
      from IAPRCPARM
      where PLIBNAM = :uwsrcdtl.srclib
        and PSRCPF  = :uwsrcdtl.srcspf
        and PMBRNAM = :uwsrcdtl.srcmbr
        and PPRNAM <> ' '                                                                //0018
        and PPRMSEQ = 1;

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Select_IAPRCPARM';                                          //AK09
      IaSqlDiagnostic(uDpsds);                                                           //0023
   endif;

   If R_count > 0;
      exec sql
        declare Proc_Name_Cur cursor for
         select DISTINCT PPRNAM
         from IAPRCPARM
         where PLIBNAM = :uwsrcdtl.srclib
          and PSRCPF   = :uwsrcdtl.srcspf
          and PMBRNAM  = :uwsrcdtl.srcmbr
          and PPRNAM <> ' '                                                              //0018
          and PPRMSEQ  = 1;

      exec sql open Proc_Name_Cur;
      if sqlCode = CSR_OPN_COD ;                                                         //MT02
         exec sql close Proc_Name_Cur;                                                   //MT02
         exec sql open Proc_Name_Cur;                                                    //MT02
      endif;                                                                             //MT02

      if sqlCode < successCode;
         uDpsds.wkQuery_Name = 'Open_cursor_Proc_Name_Cur';                              //AK09
         IaSqlDiagnostic(uDpsds);                                                        //0023
      endif;

      if sqlCode = successCode;
         exec sql fetch Proc_Name_Cur into :r_Procname;
         if sqlCode < successCode;                                                       //AK09
            uDpsds.wkQuery_Name = 'Fetch_1_Proc_Name_Cur';                               //AK09
            IaSqlDiagnostic(uDpsds);                                                     //0023
         endif;                                                                          //AK09
         dow sqlCode = successCode;
            if %scan(%trim(r_Procname):r_string) > 0                                     //0013
               and %scan(%trim(r_Procname):r_string) < %scan('(':r_string);              //0013
               dow %scan(';':r_string) = 0;
                  if r_iter = 'N';
                  // exec sql fetch SrcStmt into :r_Stm, :r_Rrn, :r_Src_Type;            //0012
                     Exec Sql Fetch SrcStmt Into :IAQRPG_DATA;                           //0012
                     r_stm = %xlate(wk_lo:wk_Up:r_stm);                                  //0005
                     if sqlCode < successCode;
                        uDpsds.wkQuery_Name = 'Fetch_38_SrcStmt';                        //AK09
                        IaSqlDiagnostic(uDpsds);                                         //0023
                     endif;

                     if sqlCode = successCode;
                        exsr Format_String;

                        iabreakword(uwsrcdtl.srclib :
                                    uwsrcdtl.srcspf :
                                    uwsrcdtl.srcmbr :
                                    r_rrn           :
                                    r_stm           :
                                    r_srcflag);

                        if %len(r_string) > %len(%trim(r_string));                       //SS01
                           r_string = %trim(r_string) + %trimr(r_stm);                   //SS01
                        else;                                                            //SS01
                           leave;                                                        //SS01
                        endif;                                                           //SS01
                     else;                                                               //SS01
                        leave;                                                           //SS01
                     endif;
                  else;
                     r_iter = 'N';
                  endif;
               enddo;

               r_String = ' ' + r_string;                                                     //BS02
               if %scan(' CALLP':r_string) > 0;                                               //BS02
                  IAPSRCALLP(r_string        : r_type          : r_error         :            //BS02
                             uwxref          : UwSrcDtl.srclib : UwSrcDtl.srcspf :            //BS02
                             UwSrcDtl.srcmbr : r_rrns          : r_rrne );                    //BS02
               endif;                                                                         //BS02

            endif;
            exec sql fetch Proc_Name_Cur into :r_Procname;
            if sqlCode < successCode;                                                    //AK09
               uDpsds.wkQuery_Name = 'Fetch_2_Proc_Name_Cur';                            //AK09
               IaSqlDiagnostic(uDpsds);                                                  //0023
            endif;                                                                       //AK09
         enddo;
      endif;
      exec sql close Proc_Name_Cur;
   Else;
      dow %scan(';':r_string) = 0;
         if r_iter = 'N';
          //exec sql fetch SrcStmt into :r_Stm, :r_Rrn, :r_Src_Type;                     //0012
            Exec Sql Fetch SrcStmt Into :IAQRPG_DATA;                                    //0012
            r_stm = %xlate(wk_lo:wk_Up:r_stm);                                           //0005
            if sqlCode < successCode;
               uDpsds.wkQuery_Name = 'Fetch_39_SrcStmt';                                 //AK09
               IaSqlDiagnostic(uDpsds);                                                  //0023
            endif;

            if sqlCode = successCode;
               exsr Format_String;

               iabreakword(uwsrcdtl.srclib :
                           uwsrcdtl.srcspf :
                           uwsrcdtl.srcmbr :
                           r_rrn           :
                           r_stm           :
                           r_srcflag);

                if %len(r_string) > %len(%trim(r_string));                               //SS01
                   r_string = %trim(r_string) + %trimr(r_stm);
                else;                                                                    //SS01
                   leave;                                                                //SS01
                endif;                                                                   //SS01
            Else;                                                                        //SS01
               Leave;                                                                    //SS01
            endif;
         else;
            r_iter = 'N';
         endif;
      enddo;

      r_String = ' ' + r_string;                                                              //BS02
      if %scan(' CALLP':r_string) > 0;                                                        //BS02
         IAPSRCALLP(r_string        : r_type          : r_error         :                     //BS02
                    uwxref          : UwSrcDtl.srclib : UwSrcDtl.srcspf :                     //BS02
                    UwSrcDtl.srcmbr : r_rrns          : r_rrne );                             //BS02
      endif;                                                                                  //BS02

   EndIf;

endsr;
//----------------------------------------------------------------------------------
//ProcessSourceData : Line by line parsing of source statements
//----------------------------------------------------------------------------------
Begsr ProcessSourceData;

//----------------------------------------------------------------------------------
//The IaQrpgsrc Table Have Indexes In IACRTINDXR PGM
//----------------------------------------------------------------------------------
   exec sql
     declare SrcStmt cursor for
    //select Upper(SOURCE_DATA) ,SOURCE_RRN, SRCLIN_TYPE                                 //0007
      select  SOURCE_RRN, SOURCE_SEQ, SRCLIN_TYPE, SRCLIN_CNTN,                          //0011
              SOURCE_SPEC,                                                               //0026
              Upper(SOURCE_DATA)                                                         //0011
      from IaQrpgsrc                                                                     //0007
      where LIBRARY_NAME = trim(:UwSrcDtl.srclib)                                        //0007
       and SOURCEPF_NAME = trim(:UwSrcDtl.srcspf)                                        //0007
       and MEMBER_NAME   = trim(:UwSrcDtl.srcmbr)                                        //0007
       and substring(SRCLIN_TYPE,4,1)=' ' and                                            //0024
       SRCLIN_TYPE <> ' '                                                                //0007
       Order by SOURCE_rrn;
       //Review use order by rrn criteria.
       //Review use ucase to xlate input srcdta

   exec sql open SrcStmt;
   if sqlCode = CSR_OPN_COD;                                                             //MT02
      exec sql close SrcStmt;                                                            //MT02
      exec sql open  SrcStmt;                                                            //MT02
   endif;                                                                                //MT02

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Open_cursor_SrcStmt';                                       //AK09
      IaSqlDiagnostic(uDpsds);                                                           //0023
   endif;


   if sqlCode = successCode;
      r_stm    = *blanks;
    //exec sql fetch SrcStmt into :r_stm , :r_rrn, :r_Src_Type;                          //0007
      Exec Sql Fetch SrcStmt Into :IAQRPG_DATA;                                          //0012
      if sqlCode < successCode;
         uDpsds.wkQuery_Name = 'Fetch_1_SrcStmt';                                        //AK09
         IaSqlDiagnostic(uDpsds);                                                        //0023
      endif;
      dow sqlCode = successCode;
         r_stm = %xlate(wk_lo:wk_Up:r_stm);                                              //0005
         monitor;
            //----------- Fetch next member if compile time array ------ //
            if %subst(r_stm:1:3) = '** ';
               leave;
            endif;

            r_fix       = *blanks;
            if r_string = *blanks;
               r_rrns   = r_rrn;
            endif;

            //----------- Check Comment Line --------------------------- //

            //----------- Fetch Free Or Fix Format status -------------- //
            exsr Fetch_Specs;

            //Skip line if only spec is menioned, this is like a commented line...
               If r_tfree <> 'Y' And                                                      //0016
                  ((r_fix = 'H' Or r_fix = 'F' Or r_fix = 'D' Or r_fix = 'C' Or           //0016
                    r_fix = 'I' Or r_fix = 'E' Or r_fix = 'O' Or r_fix = 'K' Or           //0016
                    r_fix = 'P' Or r_fix = 'T') And                                       //0016
                   %SubSt(r_stm:8:73) = *Blanks);                                         //0016
                  Exec SQL                                                                //0016
                       Fetch SrcStmt Into :IAQRPG_DATA;                                   //0016
                  If sqlCode < successCode;                                               //0016
                     uDpsds.wkQuery_Name = 'Fetch_2_SrcStmt';                             //0016
                     IaSqlDiagnostic(uDpsds);                                            //0023
                  EndIf;                                                                  //0016
                  Iter;                                                                   //0016
               EndIf;                                                                     //0016

            //Pls remove line 194 - 198 after testing
            If r_fix <> *Blanks and                                                         //BS01
               (%subst(r_stm:6:1) = 'P') ;                                                  //BS01
               if %scan('B':r_stm:24) = 24 ;                                                //BS01
                  in_procedure = *on;                                                       //BS01
               endIf;                                                                       //BS01
               if %scan('E':r_stm:24) = 24 ;                                                //BS01
                  in_procedure = *off;                                                      //BS01
               endIf;                                                                       //BS01
            Endif;                                                                          //BS01
            If r_fix <> *Blanks and                                                         //PJ01
               (%subst(r_stm:6:1) = 'H' or %subst(r_stm:6:1) = 'P')                         //BS01
            // and (%scan('BNDDIR(':r_stm) <> 0);                                     //0026//BS01
               and (%scan('BNDDIR(':r_stm) <> 0) or                                         //0026
               (r_fix = *Blanks and r_Src_Spec ='H' and (r_Src_Type = 'FFC' or              //0026
               r_Src_Type = 'FFR') and (%scan('BNDDIR(':r_stm) <> 0));                      //0026

               wBndstart = %scan('BNDDIR(':r_stm) + 6;                                      //HJ04
               wBndEnd =  %scan(')':r_stm:wBndstart);                                       //HJ04

               r_stm = %Trim(%subst(r_stm : wBndstart + 1 :                                 //HJ04
                       (wBndEnd) - (wBndstart + 1)));                                       //HJ04
               if wBndstart > 8;                                                            //BA06
                  wBndDirLib = '*LIBL';                                                     //BA06
                  Reset ColonInd;                                                           //HJ04
                  Reset WBndPos;                                                            //HJ04
                  Dow ColonInd;                                                             //HJ04
                     wBndQPos = %scan('"' : r_stm : wBndPos+1);                             //HJ04
                     wbndBrk = %scan('/':r_stm:wBndPos);                                    //BA06
                     if wbndBrk > 0;                                                        //BA06
                        wBndDirLib = %subst(r_stm : wBndPos + 1 :                           //HJ04
                                           (wbndBrk - wBndPos) - 1);                        //HJ04
                        wBndDirName = %subst(r_stm:wbndBrk+1:                               //HJ04
                                             (wBndQPos - wBndBrk) - 1);                     //HJ04
                        wBndPos = %scan('"' : r_stm : wBndQPos +1);                         //HJ04
                        if wBndPos = 0;                                                     //HJ04
                           ColonInd = *Off;                                                 //HJ04
                        endif;                                                              //HJ04
                     else;                                                                  //BA06
                        wBndDirName = %subst(r_stm : wBndPos + 1 :                          //HJ04
                                       (wBndQPos - wBndPos) - 1);                           //HJ04
                        wBndPos = %scan('"' : r_stm : wBndQPos +1);                         //HJ04
                        if wBndPos = 0;                                                     //HJ04
                           ColonInd = *Off;                                                 //HJ04
                        endif;                                                              //HJ04
                     endif;                                                                 //BA06
                     exec sql                                                               //BA06
                        insert into iasrcintpf (iambrlib,                                   //BA06
                                                iambrnam,                                   //BA06
                                                iambrtyp,                                   //BA06
                                                iambrsrc,                                   //BA06
                                                iarefobj,                                   //BA06
                                                iarefotyp,                                  //BA06
                                                iarefolib,                                  //BA06
                                                iarefousg,                                  //BA06
                                                iarfileusg)                                 //BA06
                                         values (:UwSrcDtl.srclib,                          //BA06
                                                 :UwSrcDtl.srcmbr,                          //BA06
        //                                       :UwSrcDtl.mbrtyp1,                  //0010 //BA06
                                                 :UwSrcDtl.srcType,                  //0010 //BA06
                                                 :UwSrcDtl.srcSpf,                          //BA06
                                                 :wBndDirName,                              //BA06
                                                 '*BNDDIR',                                 //BA06
                                                 :wBndDirLib,                               //BA06
                                                 1,                                         //BA06
                                                 'RPG');                                    //BA06
                                                                                            //BA06
                     if sqlCode < successCode;                                              //BA06
                        uDpsds.wkQuery_Name = 'Insert_IASRCINTPFMT';                        //BA06
                        IaSqlDiagnostic(uDpsds);                                         //0023
                     endif;                                                                 //BA06
                  EndDo;                                                                    //HJ04

               endif;
               exsr Clear_vars;
             //exec sql fetch SrcStmt into :r_stm, :r_rrn, :r_Src_Type;                   //0012
               Exec Sql Fetch SrcStmt Into :IAQRPG_DATA;                                  //0012
               r_stm = %xlate(wk_lo:wk_Up:r_stm);                                        //0005
               if sqlCode < successCode;
                  uDpsds.wkQuery_Name = 'Fetch_2_SrcStmt';                               //AK09
                  IaSqlDiagnostic(uDpsds);                                               //0023
               endif;
               iter;
            endif;

            //----------- Remove Comments, Tags And Skip Blanks -------- //
            exsr Format_String;

            if r_iter = 'Y';
               r_iter = 'N';
               iter;
            endif;

            iabreakword(uwsrcdtl.srclib : uwsrcdtl.srcspf : uwsrcdtl.srcmbr :
                        r_rrn           : r_stm           : r_srcflag );               //ag_iter_fix

            if r_string = *blanks;
               r_string = %trimr(r_stm );
               r_rrns= r_rrn;                                                              //0012
               r_srcseqS = r_srcSeq;
            else;
               r_string = %trimr(r_string) + r_cat + %trimr(r_stm );
               r_rrne= r_rrn;
            endif;

            //----------- Process The Statement Containing EXEC SQL ---- //
            if %scan('EXEC SQL':%trim(r_string):1) > 0;
               exsr Process_SQL;
               if r_iter = 'Y';
                  r_iter = 'N';
                 iter;
               endif;
            endif;

            if %scan('DCL-PROC':%trim(r_string):1) = 1;                                  //YK04
               in_procedure = *on;                                                       //YK04
            endif;                                                                       //YK04

            if %scan('END-PROC':%trim(r_string):1) = 1;                                  //YK04
               in_procedure = *off;                                                      //YK04
            endif;                                                                       //YK04

            //----------- Process The Statement Containing DS (Fix) ---- //
            if (r_fix = 'D' and %subst(r_string:24:2) = 'DS') or
               (r_sts = 'DSFXN');
               exsr Process_DS_Subfield_Fx;                                         //SM01
               if r_iter = 'Y';
                  r_iter = 'N';
                  iter;
               endif;
            endif;

            if r_fix = 'I' and %subst(r_string:7:1) <> '*';                         //HJ06
               if r_ext <> 'Y';                                                     // |
                  r_rrns = r_Rrn;                                                   // |
               endif;                                                               // |
               if r_ext =  'Y';                                                     // |
                  r_rrns = r_Rrnext;                                                // |
               endif;                                                               // |
                                                                                    // |
            // exec sql fetch SrcStmt into :r_stm, :r_rrn, :r_Src_Type;             //0007
               Exec Sql Fetch SrcStmt Into :IAQRPG_DATA;                                 //0012
                                                                                    // |
               if sqlCode < successCode;                                            // |
                  uDpsds.wkQuery_Name = 'Fetch_25_SrcStmt';                         // |
                  IaSqlDiagnostic(uDpsds);                                               //0023
               endif;                                                               // |
               r_stm = %xlate(wk_lo:wk_Up:r_stm);                                        //0005
               r_stringnew = r_stm;                                                 // |
               IAPSRVARFX(r_string        : r_type          : r_error         :     // |
                          uwxref          : UwSrcDtl.srclib : UwSrcDtl.srcspf :     // |
                          UwSrcDtl.srcmbr : r_rrns          : r_rrne          :     // |
                          r_lname         : r_word          : in_procedure   );     // |
                                                                                    // |
               exsr clear_vars;                                                     // |
               clear r_lname;                                                       // |
               clear r_word;                                                        // |
               clear r_rrnext;                                                      // |
               r_ext = 'N';                                                         // |
               if r_iter = 'Y';                                                     // |
                  r_iter = 'N';                                                     // |
                  iter;                                                             // |
               endif;                                                               // |
            endif;                                                                  // |
                                                                                    //HJ06
            //----------- Process The Statement Containing DS (RPG3) --- //
            if (r_fix = 'I' and %subst(r_string:19:2) = 'DS') or
               (r_sts = 'DSRPG3N');
               exsr Process_DS_RPG;
               if r_iter = 'Y';
                  r_iter = 'N';
                  iter;
               endif;
            endif;

            //------Process The Statement Containing O Specifications--- //             //0009
                                                                                         //0009
            if r_fix = 'O' and r_string <> *blanks ;                                     //0009
               IAPSROSPEC(r_string: r_type : r_error : uwxref :UwSrcDtl.srclib:          //0009
                          UwSrcDtl.srcspf: UwSrcDtl.srcmbr : r_rrns: r_rrne);            //0009
                                                                                         //0009
            endif;                                                                       //0009

            //----------- Process The Statement Containing Variables --- //
            //----------- and Constants (RPG3) ------------------------- //
            if r_fix = 'I' and %subst(r_string:7:1) <> '*' and
               %subst(r_string:43:1) = 'C' and
               %subst(r_string:53:6) <> *blanks and
               %subst(r_string:21:22) <> *blanks;
               IAPSRISPCC(r_string        : r_type          : r_error         :
                          uwxref          : UwSrcDtl.srclib : UwSrcDtl.srcspf :
                          UwSrcDtl.srcmbr : r_rrns          : r_rrne );

               exsr clear_vars;
            endif;

            if r_fix = 'I' and %subst(r_string:7:1) <> '*' and
               %subst(r_string:31:21) = *blanks and
               %subst(r_string:53:6) <> *blanks and
               %subst(r_string:21:10) <> *blanks;
               IAPSRISPCV(r_string        : r_type          : r_error         :
                          uwxref          : UwSrcDtl.srclib : UwSrcDtl.srcspf :
                          UwSrcDtl.srcmbr : r_rrns          : r_rrne);

               exsr clear_vars;
            endif;

            //----------- Process The Statement Containing DCL-DS ------ //
            if %scan('DCL-DS ':%trim(r_string):1) = 1 or (r_sts = 'DSFRN');
               exsr Process_DS_fr;
               if r_iter = 'Y';
                  r_iter = 'N';
                  iter;
               endif;
            endif;

            //----------- Process The Statement Containing File -------- //
            if %scan('DCL-F ': %trim(r_string):1) = 1 or
               (%scan('F':r_string:6)  = 6 and
                %scan('*':r_string:7) <> 7 and r_fix = 'F');
               exsr process_file;
               if r_iter = 'Y';
                  r_iter = 'N';
                  iter;
               endif;
            endif;

            //----------- Process The Statement Containing DCL-VAR ----- //
            if %scan('DCL-S ':%trim(r_string):1) = 1 or
               %scan('DCL-C ':%trim(r_string):1) = 1 or
               (r_fix = 'D' and %subst(r_string:7:1)<> '*');
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

            //----------- Process The Statement Containing Array ------- //
            if (%subst(r_string:6:1)='E' and %len(%trimr(r_string)) > 40) and
               r_tfree = 'N' and r_mfree = 'N';
               exsr process_arr;
               if r_iter = 'Y';
                  r_iter = 'N';
                  iter;
               endif;
            endif;

            //----------- Process The Statement Containing Entry Parameter//
            if (r_fix = 'C' and %scan('*ENTRY':r_string) > 0 );
               exsr process_ent;
               if r_iter = 'Y';
                  r_iter = 'N';
                  iter;
               endif;
            endif;

            //----------- Process The Statement Containing PLIST Parameter//            //0008
            if (r_fix = 'C' and %subst(r_string:7:1) <> '*'                              //0008
               and %scan('*ENTRY':r_string) = 0                                          //0008
               and %scan('PLIST':r_string) > 0 );                                        //0008
               exsr process_Plist;                                                       //0008
               if r_iter = 'Y';                                                          //0008
                  r_iter = 'N';                                                          //0008
                  iter;                                                                  //0008
               endif;                                                                    //0008
            endif;                                                                       //0008

            //----------- Process The Statement Containing Opcodes  ---- //
            if r_fix = 'C' and %subst(r_string:7:1) <> '*' and
               (%subst(r_string:26:5) = 'Z-ADD' or
                %subst(r_string:26:4) = 'MOVE'  or
                %subst(r_string:26:5) = 'MOVEL' or
                %subst(r_string:26:3) = 'ADD'   or
                %subst(r_string:26:3) = 'SUB'   or
                %subst(r_string:26:3) = 'DIV'   or
                %subst(r_string:26:5) = 'Z-SUB' or
                %subst(r_string:26:4) = 'MULT'  ) and
                %subst(r_string:64:5) <> *blanks;
               IAPSROPCFX(r_string        : r_type          : r_error         :
                          uwxref          : UwSrcDtl.srclib : UwSrcDtl.srcspf :
                          UwSrcDtl.srcmbr : r_rrns          : r_rrne );

               exsr clear_vars;
            endif;

            select;
            when r_fix = 'C' and (r_type = 'RPGLE' or r_type = 'SQLRPGLE');
               r_ioopcode = %subst(r_string:26:10);
            when r_fix = 'C' and (r_type = 'RPG' or r_type = 'RPG38' or
                                      r_type = 'RPG36');
               r_ioopcode = %subst(r_string:28:5);
            endsl;

            if r_ioopcode = 'KLIST' or r_ioopcode = 'KFLD';
               if r_ioopcode = 'KLIST';
                  clear uwkldtl;
               endif;

               select;
               when r_type = 'RPGLE' or r_type = 'SQLRPGLE';
                  exsr Process_klist_fx;
               when r_type = 'RPG' or r_type = 'RPG38' or r_type = 'RPG36';
                  exsr Process_klist_rpg3;
               other;
               endsl;

               if r_iter = 'Y';
                  r_iter = 'N';
                  iter;
               endif;
            endif;

            if r_fix = 'C' and %subst(r_string:7:1) <> '*' and
               (%subst(r_string:26:5) = 'Z-ADD' or
                %subst(r_string:26:4) = 'MOVE'  or
                %subst(r_string:26:5) = 'MOVEL' or
                %subst(r_string:26:3) = 'ADD'   or
                %subst(r_string:26:3) = 'SUB'   or
                %subst(r_string:26:3) = 'DIV'   or
                %subst(r_string:26:5) = 'Z-SUB' or
                %subst(r_string:26:4) = 'MULT'  );
                exsr clear_vars;
            endif;

            if r_fix = 'C' and %subst(r_string:7:1) <> '*' and
               (%subst(r_string:28:5) = 'Z-ADD' or
                %subst(r_string:28:4) = 'MOVE'  or
                %subst(r_string:28:5) = 'MOVEL' or
                %subst(r_string:28:3) = 'ADD'   or
                %subst(r_string:28:3) = 'SUB'   or
                %subst(r_string:28:3) = 'DIV'   or
                %subst(r_string:28:5) = 'Z-SUB' or
                %subst(r_string:28:4) = 'MULT'  ) and
                %subst(r_string:49:4) <> *blanks;
               IAPSROPCFX3(r_string        : r_type          : r_error         :
                           uwxref          : UwSrcDtl.srclib : UwSrcDtl.srcspf :
                           UwSrcDtl.srcmbr : r_rrns          : r_rrne );

               exsr clear_vars;
            endif;

            if r_fix = 'C' and %subst(r_string:7:1) <> '*' and
               (%subst(r_string:28:5) = 'Z-ADD' or
                %subst(r_string:28:4) = 'MOVE'  or
                %subst(r_string:28:5) = 'MOVEL' or
                %subst(r_string:28:3) = 'ADD'   or
                %subst(r_string:28:3) = 'SUB'   or
                %subst(r_string:28:3) = 'DIV'   or
                %subst(r_string:28:5) = 'Z-SUB' or
                %subst(r_string:28:4) = 'MULT'  );
                exsr clear_vars;
            endif;

            if r_fix = 'C' and
               %subst(r_string:7:1) <> '*' and
               %subst(r_string:12:5) = '*LIKE' and
               %subst(r_string:26:6) = 'DEFINE';
               IAPSRDEFFX(r_string        : r_type          : r_error         :
                          uwxref          : UwSrcDtl.srclib : UwSrcDtl.srcspf :
                          UwSrcDtl.srcmbr : r_rrns          : r_rrne);

                  exsr clear_vars;
            endif;

            if r_fix = 'C' and
               %subst(r_string:7:1) <> '*' and
               %subst(r_string:18:5) = '*LIKE' and
               %subst(r_string:28:4) = 'DEFN';
               IAPSRDEFFX3(r_string        : r_type          : r_error         :
                           uwxref          : UwSrcDtl.srclib : UwSrcDtl.srcspf :
                           UwSrcDtl.srcmbr : r_rrns          : r_rrne );

               exsr clear_vars;
            endif;

            //----------- Process The Statement for PR & PI Def   ------ //
            if (r_fix = 'D' or r_fix = 'P') and %scan('...':r_string) > 0;                   //SG01
               r_longprname = %trim(%subst(r_string:7));
               r_pos3       = %scan('...':r_Longprname);
               r_longprname = %subst(r_longprname:1:r_pos3-1);
            // exec sql fetch SrcStmt into :r_stm, :r_rrn, :r_Src_Type;                  //0012
               Exec Sql Fetch SrcStmt Into :IAQRPG_DATA;                                 //0012
               if sqlCode < successCode;
                  uDpsds.wkQuery_Name = 'Fetch_3_SrcStmt';                               //AK09
                  IaSqlDiagnostic(uDpsds);                                               //0023
               endif;
               r_stm = %xlate(wk_lo:wk_Up:r_stm);                                        //0005

               iabreakword(uwsrcdtl.srclib :
                           uwsrcdtl.srcspf :
                           uwsrcdtl.srcmbr :
                           r_rrn           :
                           r_stm           :
                           r_srcflag);

               if (%subst(r_Stm:6:1) = 'D' and %subst(r_Stm:24:2) = 'PR' ) or
                  (%subst(r_Stm:6:1) = 'D' and %subst(r_Stm:24:2) = 'PI' ) or                 //SG01
                   r_fix = 'P' ;                                                              //SG01
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
                 %subst(r_string:24:2) = 'PI' )  or                                           //SG01
                 (r_fix = 'P' and %subst(r_string:24:1) = 'B') or                             //SG01
               //%scan('DCL-PROC ':%trim(r_string):1) = 1);                                   //SG01
                //----------- For line continuation ----------- //
                ( %scan( 'DCL-PROC ':%trim(r_string):1 ) = 1 and                              //0011
                     %scan( ';':%trim(r_string) ) > 0 ));                                     //0011

               if r_fix = 'P' and %subst(r_string:24:1) = 'B' and                             //SG01
                  %subst(r_string:7:17) <> ' ' and r_longprname <> ' ';                       //SG01
                 clear r_longprname;                                                          //SG01
               endif;                                                                         //SG01

               if (r_fix = 'D' or r_fix = 'P') and r_cat = ' ';                               //SG01
                  r_cat ='^';
               endif;

               if r_lname <> *blanks;     //To handle long name set in VAR
                  r_longprname = r_lname;
                  clear r_lname;
               endif;

               exsr Process_PRPI;
               if r_iter = 'Y';
                  r_iter = 'N';
                  iter;
               endif;
            endif;

            //----------- Process The CALL Opcode ------------------------//
            //------- If procedure call under sub procedure --------------//
            if (r_fix = 'C' and                                                          // AK01
               (%scan(' CALL '    :r_string) = 27  or                                     // AK01
                %scan(' CALL '    :r_string) = 25  or                                     // AK01
                %scan(' CALL(E) ' :r_string) = 25  or                                     // AK01
                %scan(' CALLP '   :r_string) = 25  or                                     // AK01
                %scan(' CALLP(E'  :r_string) = 25  or                                     // AK01
                %scan(' CALLP(M'  :r_string) = 25  or                     // AK01
                %scan(' CALLP(R'  :r_string) = 25  or                     // AK01
                %scan(' CALLB '   :r_string) = 25  or                     // AK01
                %scan(' CALLB(E'  :r_string) = 25  or                     // AK01
                %scan(' CALLB(D'  :r_string) = 25));                      // AK01

               r_Pos1 = %scan('CALL':r_string:1);
               exsr process_call;
               if r_iter = 'Y';
                  r_iter = 'N';
                  iter;
               endif;
            endif;

            //----------- Process The Free CALL Programs------------------//
            if r_fix = *blank and r_string <> *blanks;
               if (%scan('CALL '    :r_string) > 0)   or
                  (%scan('CALL(E) ' :r_string) > 0)   or
                  (%scan('CALLP '   :r_string) > 0)   or
                  (%scan('CALLP(E'  :r_string) > 0)   or
                  (%scan('CALLP(M'  :r_string) > 0)   or
                  (%scan('CALLP(R'  :r_string) > 0)   or
                  (%scan('CALLB '   :r_string) > 0)   or
                  (%scan('CALLB(E'  :r_string) > 0)   or
                  (%scan('CALLB(D'  :r_string) > 0);
                  Ind_PrFlag = *On;
               else;                                                                     // A
                  exsr ChkProcName;                                                      // A
                  if r_count <> *zero;                                                   // A
                     Ind_PrFlag = *On;                                                   // A
                  endif;                                                                 // A
               endif;                                                                    // A
               if Ind_PrFlag = *On;                                                      // A
                  Ind_PrFlag = *off;                                                     // A
                  exsr process_free_call;                                                // A
               endif;                                                                    // A
               if r_iter = 'Y';
                  r_iter = 'N';
                  iter;
               endif;
            endif;

            //----------- Process The copybook ------------------------- //
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
               IAPSRCPYB(r_string        : r_type          : r_error         :
                         uwxref          : UwSrcDtl.srclib : UwSrcDtl.srcspf :
                         UwSrcDtl.srcmbr : r_rrns          : r_rrne );

               exsr Clear_vars;
            endif;

            //----------- Process Subroutine --------------------------- //
            if %trim(r_string) <> *blanks;
               reset R_subrflg;

               if %subst(r_string:6:1) = 'C';
                  //---------If EXSR in RPG400------------------------------//
                  if %subst(r_string:26:4) = 'EXSR' or
                     %subst(r_string:26:5) = 'BEGSR' or
                     %subst(r_string:26:5) = 'ENDSR' or
                     %subst(r_string:26:3) = 'CAS'   or
                     //---------If EXSR in RPG3  -----------------------------
                     %subst(r_string:28:4) = 'EXSR' or
                     %subst(r_string:28:5) = 'BEGSR' or
                     %subst(r_string:28:5) = 'ENDSR' or
                     %subst(r_string:28:3) = 'CAS';
                     r_subrflg = 'Y';
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
                  if %subst(r_string:%len(%trimr(r_string)):1) = ';';
                     if (%scan('EXSR ' :R_String) > 0 or
                         %scan('BEGSR ':R_String) > 0 or
                         %scan('ENDSR':R_String) > 0);
                        r_SubrFlg = 'Y';
                        select;
                        when %scan('BEGSR ':r_string)>0;
                           r_subrnam = %subst(r_string:
                                       (%scan('BEGSR ':r_string)+6):
                                       (%len(%trimr(r_string))-
                                       (%scan('BEGSR ':r_string)+6)));
                        when %scan('ENDSR':R_String:1) > 0;
                           reset r_subrnam;
                        endsl;
                     else;
                        r_SubrFlg = 'N';
                     endif;
                  elseif r_fix = ' ' and %scan('/':%trim(r_string):1) <> 1;
                  // exec sql Fetch SrcStmt into :r_Stm, :r_Rrn, :r_Src_Type;            //0012
                     Exec Sql Fetch SrcStmt Into :IAQRPG_DATA;                           //0012
                     r_stm = %xlate(wk_lo:wk_Up:r_stm);                                  //0005
                     if sqlCode < successCode;
                        uDpsds.wkQuery_Name = 'Fetch_4_SrcStmt';                         //AK09
                        IaSqlDiagnostic(uDpsds);                                         //0023
                     endif;
                     iter;
                  endif;
               endif;

               if r_SubrFlg = 'Y';
                  if R_rrns>=R_rrne and r_rrne <> 0;
                     R_rrne = R_rrns;
                  endif;
                  //------Call subroutine parser procedure-----------------//
                  IAPSRSUBR(r_string        : r_type          : r_error         :
                            uwxref          : UwSrcDtl.srclib : UwSrcDtl.srcspf :
                            UwSrcDtl.srcmbr : r_rrns          : r_rrne          :
                            r_SubrNam );

                  exsr Clear_vars;
               endif;
            endif;
         on-error;
            exsr Write_RRN_Error;
            exsr Clear_vars;
         endmon;

         //---------------------------------------------------------- //
         clear r_stm;
         clear r_rrn;
         clear r_string;
         clear r_ioopcode;
         clear r_lname;
         clear r_word;
         clear r_rrnext;
         r_ext = 'N';
         r_stm = *blanks;
     //  exec sql Fetch SrcStmt into :r_Stm, :r_Rrn, :r_Src_Type;                        //0012
         Exec Sql Fetch SrcStmt Into :IAQRPG_DATA;                                       //0012
         r_stm = %xlate(wk_lo:wk_Up:r_stm);                                              //0005
         if sqlCode < successCode;
            uDpsds.wkQuery_Name = 'Fetch_5_SrcStmt';                                     //AK09
            IaSqlDiagnostic(uDpsds);                                                     //0023
         endif;
      enddo;
      exec sql close SrcStmt;
   endif;

endsr;
//------------------------------------------------------//                              // AP01
Begsr ChkProcName;                                                                       // AP01

   r_scanpos = %scan('(' : %trim(r_string));                                             // AP01
   r_len     = %len(%trim(r_string));                                                    // AP01
   if r_scanpos > 1;                                                                     // AP01
      r_PrName = %subst(%trim(r_string) : 1: (r_scanpos -1));                            // AP01
   elseif r_scanpos = 0;                                                                 // AP01
      r_PrName = %trim(r_string);                                                        // AP01
   endif;                                                                                // AP01
                                                                                         // AP01
   if r_PrName <> *Blanks;                                                               // AP01
      exec sql                                                                           // AP01
        // select count(*)                                                               // AP01
        select count(1) into :r_count                                                    // VM002
        from IAPRCPARM                                                                   // AP01
        where PMBRNAM        = :uwsrcdtl.srcmbr                                          // AP01
          and PR_PI_FLAG     = 'PR'                                                      // AP01
          and PROCEDURE_NAME = :r_PrName;                                                // AP01
      r_PrName = *Blanks;                                                                // AP01

     if sqlCode < successCode;
        uDpsds.wkQuery_Name = 'Select_IAPRCPARM';                                        //AK09
        IaSqlDiagnostic(uDpsds);                                                         //0023
     endif;

   endif;                                                                                // AP01
endsr;                                                                                   // AP01

