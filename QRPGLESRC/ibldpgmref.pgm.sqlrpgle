**free
//-------------------------------------------------------------------------------------//
//CREATED BY.......: Programmers.io @ 2020                                             //
//CREATE DATE......: 2020/01/01                                                        //
//DEVELOPER........: Kaushal Kumar                                                     //
//DESCRIPTION......: Program To Build Program Reference                                //
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
//16/02/22| BA08   |BHOOMISH A  | Source being skipped in parsing                      //
//05/04/22| SB01   | Sriram B   | Added the error handling code.                       //
//06/04/22| MT01   | Mahima     | Close Cursor changes and SQL error tracking changes  //
//11/04/22| SB02   | Sriram B   | Populating udPsds with Query Name for SQL Errors     //
//22/05/17| HJ01   | Himanshu J | Added check execution time logic                        //
//22/09/07| SJ01   | Bhoomish   | Adapting new field of file AIEXCTIME which captures //
//        |        | Atha       | source file name.                                   //
//22/02/20| 0001   | Vipul P    | Removed the Progress Bar process                    //
//23/10/13| 0002   | Rituraj    | Changed file name AIEXCTIME to IAEXCTIME [Task #248] //
//05/07/24| 0003   | Vamsi      | Rename Bnddir AIERRBND, copybooks AICERRLOG/AIDERRLOG//
//        |        |            | and procedures AISQLDIAGNOSTIC and AIPSSRERRORLOG    //
//        |        |            | with IA*  [Task#261]                                 //
//20/08/24| 0004   | Sabarish   | IFS Member Parsing Feature [Task #833]               //
//------------------------------------------------------------------------------------ //
ctl-opt copyright('Programmers.io © 2020 | Kaushal | Changed March 2020');
ctl-opt option(*nodebugio:*srcstmt:*nounref);
ctl-opt bndDir('IABNDDIR' : 'IAERRBND');                                         //0003  //SB01

/copy 'QMODSRC/iasrv01pr.rpgleinc'

dcl-pi IBLDPGMREF extpgm('IBLDPGMREF');
   uwxref char(10);
   uwprog char(74);
end-pi;

dcl-pr IAEXCTIMR extpgm('IAEXCTIMR');                                                    //0002
    *n Char(10) Const;                                                                   //HJ02
    *n Char(10);                                                                         //HJ02
    *n Char(10);                                                                         //HJ02
    *n Char(10) Const;                                                                   //HJ02
    *n Char(10);                                                                         //SJ01
    *n Char(10);                                                                         //HJ02
    *n Char(10);                                                                         //HJ02
    *n Char(100) Const;                                                                  //0004
    *n Char(10) Const;                                                                   //HJ02
    *n Timestamp;                                                                        //HJ02
    *n Char(6) Const;                                                                    //HJ02
end-pr;                                                                                  //HJ02

dcl-ds UwSrcDtl qualified inz;
   srclib char(10);
   srcSpf char(10);
   srcmbr char(10);
   ifsloc char(100);                                                             //0004
   srcRrn packed(6:0);
   srcDta char(4046);                                                            //BA08
end-ds;

dcl-s ReturnArray      char(120)    inz dim(4999);
dcl-s return_statement char(120)    inz;
dcl-s Index            packed(4:0)  inz;
dcl-s SrcStmt          char(9999)   inz;
dcl-s i                packed(2:0)  inz;
dcl-s r_tfree          char(1)      inz('N');
dcl-s r_mfree          char(1)      inz('N');
dcl-s r_fix            char(1)      inz;
dcl-s new_member       char(10)     inz;
dcl-s prv_member       char(10)     inz;
dcl-s uwaction         char(20)     inz;
dcl-s uwactdtl         char(50)     inz;
dcl-s uppgm_name      char(10)     inz;                                                  //HJ02
dcl-s uplib_name      char(10)     inz;                                                  //HJ02
dcl-s uptimestamp     Timestamp;                                                         //HJ02
dcl-s upsrc_name      char(10)     inz;                                                  //SJ01

dcl-c UP         'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
dcl-c LO         'abcdefghijklmnopqrstuvwxyz';
dcl-c pads       '?+~-/=<>():;,''"';
dcl-c blk        '                ';

/copy 'QCPYSRC/iaderrlog.rpgleinc'

exec sql
  set option commit = *none,
             naming = *sys,
             usrprf = *user,
             dynusrprf = *user,
             closqlcsr = *endmod;

Eval-corr uDpsds = wkuDpsds;                                                             //SB02

uptimeStamp = %Timestamp();                                                             //HJ02
CallP IAEXCTIMR('IAMENUR' :udpsds.ProcNme : udpsds.Lib : '*PGM' :                       //0002
upsrc_name :                                                                            //SJ01
//0004 uppgm_name : uplib_name : ' ' : uptimeStamp : 'INSERT');                         //HJ02
uppgm_name : uplib_name : ' ' : ' ' : uptimeStamp : 'INSERT');                          //0004

uwaction = 'INITIALIZATION PH-1';
uwactdtl = 'INITIALIZATION PH-1 (BUILD SRC-WRD) BEGIN';
IREPHSTLOG(uwxref: uwaction: uwactdtl);

exec sql
  declare IBLDPGMREF_C1 Cursor for
    select LIBRARY_NAME,
           SOURCEPF_NAME,
           MEMBER_NAME,
           IFS_LOCATION,                                                                //0004
           SOURCE_RRN,
           SOURCE_DATA
      from IAQRPGSRC;

exec sql open IBLDPGMREF_C1;
if sqlCode = CSR_OPN_COD;                                                               //MT01
   exec sql close IBLDPGMREF_C1;                                                        //MT01
   exec sql open  IBLDPGMREF_C1;                                                        //MT01
endif;                                                                                  //MT01

if sqlCode < successCode;                                                               //SB01
   uDpsds.wkQuery_Name = 'Open_Cursor_IBLDPGMREF_C1';                                   //SB02
   IaSqlDiagnostic(uDpsds);                                                    //0003   //SB01
endif;                                                                                  //SB01

if sqlCode = successCode;                                                               //SB01
                                                                                        //SB01
   exec sql fetch IBLDPGMREF_C1 into :UwSrcDtl;
                                                                                        //SB01
   if sqlCode < successCode;                                                            //SB01
      uDpsds.wkQuery_Name = 'Fetch_1_Cursor_IBLDPGMREF_C1';                             //SB02
      IaSqlDiagnostic(uDpsds);                                                 //0003   //SB01
   endif;                                                                               //SB01

   dow sqlCode = successCode;                                                           //SB01

      SrcStmt = UwSrcDtl.SrcDta;
      new_member = uwsrcdtl.srcmbr;
      clear ReturnArray;
      clear Index;

      if new_member <> prv_member;
         r_tfree = 'N';
         r_mfree = 'N';
         r_fix = ' ';
      endif;

      srcstmt = %xlate(lo:up:srcstmt);

      //* ----------------- If full Free Code ---------------------------- *//
      if r_tfree = 'N' and  %scan('**FREE': srcstmt : 1) = 1;
         r_tfree = 'Y';
         exec sql fetch IBLDPGMREF_C1 into :UwSrcDtl;

         if sqlCode < successCode;                                                      //SB01
            uDpsds.wkQuery_Name = 'Fetch_2_Cursor_IBLDPGMREF_C1';                       //SB02
            IaSqlDiagnostic(uDpsds);                                           //0003   //SB01
         endif;                                                                         //SB01

         iter;
      endif;

      //* ----------------- If /FREE Is Encountered ---------------------- *//
      if r_mfree = 'N' and %scan('/FREE':srcstmt :7) > 0;
         r_mfree = 'Y';
         exec sql fetch IBLDPGMREF_C1 into :UwSrcDtl;
                                                                                        //SB01
         if sqlCode < successCode;                                                      //SB01
            uDpsds.wkQuery_Name = 'Fetch_3_Cursor_IBLDPGMREF_C1';                       //SB02
            IaSqlDiagnostic(uDpsds);                                            //0003  //SB01
         endif;                                                                         //SB01

         iter;
      endif;

      //* ----------------- If /END-FREE IS Encountered ------------------ *//
      if  %scan('/END-FREE':srcstmt :7) > 1;
         r_mfree = 'N';
         exec sql fetch IBLDPGMREF_C1 Into :UwSrcDtl;

         if sqlCode < successCode;                                                      //SB01
            uDpsds.wkQuery_Name = 'Fetch_4_Cursor_IBLDPGMREF_C1';                       //SB02
            IaSqlDiagnostic(uDpsds);                                           //0003   //SB01
         endif;                                                                         //SB01

         iter;
      endif;

      //* ----------------- If FIXED Is Encountered ---------------------- *//
      if r_tfree = 'N' and r_mfree = 'N' and
         (%scan('H': srcstmt : 6) = 6 or %scan('F': srcstmt : 6) = 6 or
          %scan('D': srcstmt : 6) = 6 or %scan('E': srcstmt : 6) = 6 or
          %scan('I': srcstmt : 6) = 6 or %scan('C': srcstmt : 6) = 6 or
          %scan('O': srcstmt : 6) = 6 or %scan('P': srcstmt : 6) = 6 );
         r_fix = %subst(srcstmt  : 6 : 1);
      endif;

      //* ----------------- If Total free and full line is commented ----- *//
      if (%len(%trim(srcstmt)) > 0 and
         ((r_tfree = 'Y' and %scan('//': %trim(srcstmt):1)=1)  or
         (r_mfree = 'Y' and %scan('//': %trim(srcstmt):1)=1))) or
         (%len(%trimr(srcstmt)) >= 7 and
         (r_tfree = 'N' and r_mfree = 'N' and %scan('*': srcstmt  :7) = 7));
         exec sql fetch IBLDPGMREF_C1 into :UwSrcDtl;

         if sqlCode < successCode;                                                      //SB01
            uDpsds.wkQuery_Name = 'Fetch_5_Cursor_IBLDPGMREF_C1';                       //SB02
            IaSqlDiagnostic(uDpsds);                                           //0003   //SB01
         endif;                                                                         //SB01

         iter;
      endif;

      //* ----------------- If Mixed free, Remove the TAGS --------------- *//
      if r_mfree = 'Y' or r_fix <> *blanks;
         srcstmt = %replace('     ':srcstmt:1:5);
      endif;

      //* ----------------- If Fixed , Remove the TAGS ------------------- *//
      if r_fix = *blanks and r_tfree = 'N' and r_mfree = 'N';
         srcstmt  = %replace('      ':srcstmt:1:6);
         if %trim(srcstmt) <> ' ' and %scan('//':%trim(srcstmt):1) = 1;
            exec sql fetch IBLDPGMREF_C1 into :UwSrcDtl;

            if sqlCode < successCode;                                                   //SB01
               uDpsds.wkQuery_Name = 'Fetch_6_Cursor_IBLDPGMREF_C1';                    //SB02
               IaSqlDiagnostic(uDpsds);                                        //0003   //SB01
            endif;                                                                      //SB01
                                                                                        //SB01
            iter;
         endif;
      endif;

      srcstmt = %xlate(pads:blk:srcstmt);

      if %len(%trim(srcstmt)) > 0;
         IaBreakSrcString(SrcStmt:ReturnArray:index);
         for i = 1 to Index-1;
            return_statement = ReturnArray(i);
            exec sql
              insert into IAPGMREF (SRC_PF_NAME,
                                    LIBRARY_NAME,
                                    MEMBER_NAME,
                                    IFS_LOCATION,                              //0004
                                    SOURCE_RRN,
                                    SOURCE_WORD)
                            values(trim(:UwSrcDtl.SrcSpf),
                                   trim(:UwSrcDtl.SrcLib),
                                   trim(:UwSrcDtl.SrcMbr),
                                   trim(:UwSrcDtl.ifsloc),                     //0004
                                   char(:UwSrcDtl.SrcRrn),
                                   trim(:return_statement));

             if sqlCode < successCode;                                                  //SB01
                uDpsds.wkQuery_Name = 'Insert_IAPGMREF';                                //SB02
                IaSqlDiagnostic(uDpsds);                                       //0003   //SB01
             endif;                                                                     //SB01

         endfor;
      endif;

      prv_member = new_member;
      exec sql fetch IBLDPGMREF_C1 into :UwSrcDtl;

      if sqlCode < successCode;                                                         //SB01
         uDpsds.wkQuery_Name = 'Fetch_7_Cursor_IBLDPGMREF_C1';                          //SB02
         IaSqlDiagnostic(uDpsds);                                               //0003  //SB01
      endif;                                                                            //SB01

   enddo;
// exec sql close IBLDPGMREF_C1;                                                //YK02
endif;
exec sql close IBLDPGMREF_C1;                                                   //YK02

exec sql
  declare IBLDPGMREF_C2 Cursor for
    select LIBRARY_NAME,
           SOURCEPF_NAME,
           MEMBER_NAME,
           SOURCE_RRN,
           SOURCE_DATA
      from IAQCLSRC;

exec sql open IBLDPGMREF_C2;
if sqlCode = CSR_OPN_COD;                                                               //MT01
   exec sql close IBLDPGMREF_C2;                                                        //MT01
   exec sql open  IBLDPGMREF_C2;                                                        //MT01
endif;                                                                                  //MT01

if sqlCode < successCode;                                                               //SB01
   uDpsds.wkQuery_Name = 'Open_Cursor_IBLDPGMREF_C2';                                   //SB02
   IaSqlDiagnostic(uDpsds);                                                     //0003  //SB01
endif;                                                                                  //SB01

if sqlCode = successCode;                                                               //SB01

   exec sql fetch IBLDPGMREF_C2 into :UwSrcDtl;

   if sqlCode < successCode;                                                            //SB01
      uDpsds.wkQuery_Name = 'Fetch_1_Cursor_IBLDPGMREF_C2';                             //SB02
      IaSqlDiagnostic(uDpsds);                                                 //0003   //SB01
   endif;                                                                               //SB01
                                                                                        //SB01
   dow sqlCode = successCode;                                                           //SB01

      SrcStmt = UwSrcDtl.SrcDta;
      clear ReturnArray;
      clear Index;

      srcstmt = %xlate(lo:up:srcstmt);
      srcstmt = %xlate(pads:blk:srcstmt);
      if srcstmt <> *blanks;
         IaBreakSrcString(SrcStmt:ReturnArray:index);
         for i = 1 to Index-1;
            return_statement = ReturnArray(i);
            exec sql
              insert into IACPGMREF (SRC_PF_NAME,
                                    LIBRARY_NAME,
                                    MEMBER_NAME,
                                    IFS_LOCATION,                                       //0004
                                    SOURCE_RRN,
                                    SOURCE_WORD)
                             values(trim(:UwSrcDtl.SrcSpf),
                                    trim(:UwSrcDtl.SrcLib),
                                    trim(:UwSrcDtl.SrcMbr),
                                    trim(:UwSrcDtl.ifsloc),                             //0004
                                    char(:UwSrcDtl.SrcRrn),
                                    trim(:return_statement));

            if sqlCode < successCode;                                                   //SB01
               uDpsds.wkQuery_Name = 'Insert_IACPGMREF';                                //SB02
               IaSqlDiagnostic(uDpsds);                                        //0003   //SB01
            endif;                                                                      //SB01

         endfor;
      endif;
      exec sql fetch IBLDPGMREF_C2 into :UwSrcDtl;
                                                                                        //SB01
      if sqlCode < successCode;                                                         //SB01
         uDpsds.wkQuery_Name = 'Fetch_2_Cursor_IBLDPGMREF_C2';                          //SB02
         IaSqlDiagnostic(uDpsds);                                              //0003   //SB01
      endif;                                                                            //SB01
                                                                                        //SB01
   enddo;
// exec sql close IBLDPGMREF_C2;                                                //YK02
endif;
exec sql close IBLDPGMREF_C2;                                                   //YK02

uwaction = 'INITIALIZATION PH-1';
uwactdtl = 'INITIALIZATION PH-1 (BUILD SRC-WRD) END';
IREPHSTLOG(uwxref: uwaction: uwactdtl);

UPTimeStamp = %Timestamp();                                                           //HJ02
CallP IAEXCTIMR('IAMENUR' :udpsds.ProcNme : udpsds.Lib : '*PGM' :                        //0002
upsrc_name :                                                                            //SJ01
//0004 uppgm_name : uplib_name : ' ' : uptimeStamp : 'UPDATE');                         //HJ02
uppgm_name : uplib_name : ' ' : ' ' : uptimeStamp : 'UPDATE');                           //0004

*inlr = *on;
return;

/copy 'QCPYSRC/iacerrlog.rpgleinc'
                                                                                          //SB01
