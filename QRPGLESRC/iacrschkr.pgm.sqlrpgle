**free
      //%METADATA                                                      *
      // %TEXT Compare Before and After Image of files                 *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------ //
//CREATED BY :   Programmers.io @ 2020                                                 //
//CREATE DATE:   2020/01/01                                                            //
//DEVELOPER  :   Kaushal kumar                                                         //
//DESCRIPTION:   Compare Before and After Image of files                               //
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
//17/12/22|  YG01  | YGAWANDE   | Cursor C1 Close statement added                      //
//07/04/22|  HJ01  | Himanshu J | Adding cursor open check and wkSqlstmtNbr logic      //
//22/05/17| HJ02   | Himanshu J | Added check execution time logic                        //
//22/09/07| SJ01   | Sunny Jha  | Adapting new field of file AIEXCTIME which captures //
//        |        |            | source file name.                                   //
//23/10/13| 0001   | Rituraj    | Changed file name AIEXCTIME to IAEXCTIME [Task #248] //
//04/07/24| 0002   | Akhil K.   | Renamed AIERRBND, AICERRLOG, AIDERRLOG and           //
//        |        |            | AIDERRLOG with IA*  [Task #261]                      //
// 16/08/24| 0003   | Sabarish   | IFS Member Parsing Feature                           //
//------------------------------------------------------------------------------------ //
ctl-opt copyright('Programmers.io Â© 2020 | Ashish | Changed April 2021');
ctl-opt option(*noDebugIo: *srcStmt: *noUnRef);
ctl-opt bndDir('IAERRBND');                                                              //0002

dcl-pr IAEXCTIMR extpgm('IAEXCTIMR');                                                    //0001
    *n Char(10) Const;                                                                   //HJ02
    *n Char(10);                                                                         //HJ02
    *n Char(10);                                                                         //HJ02
    *n Char(10) Const;                                                                   //HJ02
    *n Char(10);                                                                         //SJ01
    *n Char(10);                                                                         //HJ02
    *n Char(10);                                                                         //HJ02
    *n Char(100) Const;                                                                  //0003
    *n Char(10) Const;                                                                   //HJ02
    *n Timestamp;                                                                        //HJ02
    *n Char(6) Const;                                                                    //HJ02
end-pr;                                                                                  //HJ02

dcl-pi IACRSCHKR  extpgm('IACRSCHKR');
   Bfrepo  char(10) options( *nopass );
   Afrepo  char(10) options( *nopass );
end-pi;

dcl-s Command     Varchar(500);
dcl-s filename    char(10);
dcl-s diffcount   packed(10:0);
dcl-s Afcount     packed(10:0);
dcl-s Bfcount     packed(10:0);
dcl-s uppgm_name      char(10)     inz;                                                  //HJ02
dcl-s uplib_name      char(10)     inz;                                                  //HJ02
dcl-s upsrc_name      char(10)     inz;                                                  //SJ01
dcl-s uptimestamp     Timestamp;                                                         //HJ02

/copy 'QCPYSRC/iaderrlog.rpgleinc'

Eval-corr uDpsds = wkuDpsds;                                                          //HJ01

uptimeStamp = %Timestamp();                                                             //HJ02
CallP IAEXCTIMR('IAMENUR' :udpsds.ProcNme : udpsds.Lib : '*PGM' :                        //0001
upsrc_name :                                                                            //SJ01
//0003 uppgm_name : uplib_name : ' ' : uptimeStamp : 'INSERT');                         //HJ02
uppgm_name : uplib_name : ' ' : ' ' : uptimeStamp : 'INSERT');                          //0003

exec sql
  Declare c1  cursor for
    select FILNAME
    from IAFILLSTP;

exec sql OPEN C1;

if sqlCode = CSR_OPN_COD;                                                                //HJ01
  exec sql close C1;                                                                     //HJ01
  exec sql open  C1;                                                                     //HJ01
endif;                                                                                   //HJ01

if sqlCode < successCode;
   uDpsds.wkQuery_Name = 'Open_Cursor_C1';                                               //HJ01
   IaSqlDiagnostic(uDpsds);                                                              //0002
endif;

if sqlCode = successCode;

   exec sql fetch C1 into :filename;

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Fetch_1_Cursor_C1';                                         //HJ01
      IaSqlDiagnostic(uDpsds);                                                           //0002
   endif;

   dow sqlCode = successCode;

     Exsr getbfcount ;
     Exsr getafcount ;

     diffcount = bfcount-afcount ;

     Exsr Insrtcnt ;
     exec sql fetch C1 into :filename;

     if sqlCode < successCode;
        uDpsds.wkQuery_Name = 'Fetch_2_Cursor_C1';                                       //HJ01
        IaSqlDiagnostic(uDpsds);                                                         //0002
     endif;

   Enddo ;
   exec sql CLOSE C1;

Endif ;

UPTimeStamp = %Timestamp();                                                           //HJ02
CallP IAEXCTIMR('IAMENUR' :udpsds.ProcNme : udpsds.Lib : '*PGM' :                        //0001
upsrc_name :                                                                            //SJ01
//0003 uppgm_name : uplib_name : ' ' : uptimeStamp : 'UPDATE');                       //HJ02
uppgm_name : uplib_name : ' ' : ' ' : uptimeStamp : 'UPDATE');                        //0003

*inlr = *on  ;
/copy 'QCPYSRC/iacerrlog.rpgleinc'

//------------------------------------------------------------------------------------ //
//Getbfcount                                                                           //
//------------------------------------------------------------------------------------ //
Begsr Getbfcount ;

   clear command ;
   clear Bfcount ;

   command = 'Select count(1) from '+ %trim(bfrepo)+ '/'+
                                 %trim(filename) ;

   exec sql PREPARE SqlSTMT FROM :command;

   if sqlCode = successCode;

      exec sql
       DECLARE Bfcnt  cursor for SqlSTMT;

      exec sql OPEN Bfcnt ;

      if sqlCode = CSR_OPN_COD;                                                          //HJ01
        exec sql close Bfcnt ;                                                           //HJ01
        exec sql open  Bfcnt ;                                                           //HJ01
      endif;                                                                             //HJ01

      if sqlCode < successCode;
         uDpsds.wkQuery_Name = 'Open_Cursor_Bfcnt';                                      //HJ01
         IaSqlDiagnostic(uDpsds);                                                        //0002
      endif;

      exec sql fetch Bfcnt  into :Bfcount;

      if sqlCode < successCode;
         uDpsds.wkQuery_Name = 'Fetch_Cursor_Bfcnt';                                     //HJ01
         IaSqlDiagnostic(uDpsds);                                                        //0002
      endif;
      exec sql close Bfcnt  ;

   Endif ;

Endsr ;

//------------------------------------------------------------------------------------ //
//GetAfcount                                                                           //
//------------------------------------------------------------------------------------ //
Begsr GetAfcount ;

   clear command ;
   clear Afcount ;

   command = 'Select count(1) from '+ %trim(Afrepo)+ '/'+
                                 %trim(filename) ;

   exec sql PREPARE SqlSTMT1 FROM :command;

   if sqlCode = successCode;

      exec sql
       DECLARE Afcnt  cursor for SqlSTMT1;

      exec sql OPEN Afcnt ;

      if sqlCode = CSR_OPN_COD;                                                          //HJ01
        exec sql close Afcnt ;                                                           //HJ01
        exec sql open  Afcnt ;                                                           //HJ01
      endif;                                                                             //HJ01

      if sqlCode < successCode;
         uDpsds.wkQuery_Name = 'Open_Cursor_Afcnt';                                      //HJ01
         IaSqlDiagnostic(uDpsds);                                                        //0002
      endif;

      exec sql fetch Afcnt  into :Afcount;

      if sqlCode < successCode;
         uDpsds.wkQuery_Name = 'Fetch_Cursor_Afcnt';                                     //HJ01
         IaSqlDiagnostic(uDpsds);                                                        //0002
      endif;
      exec sql close Afcnt  ;

   Endif ;
Endsr ;

//------------------------------------------------------------------------------------ //
//GetAfcount                                                                           //
//------------------------------------------------------------------------------------ //
Begsr Insrtcnt ;

   Exec sql insert into IACRSCHKP(
            CHKNAME, BFREPO, AFREPO, BFCNT, AFCNT, DIFFCNT )
            values(:filename ,:bfrepo ,:afrepo ,:bfcount ,
                   :afcount,:diffcount ) ;

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Insert_IACRSCHKP';                                          //HJ01
      IaSqlDiagnostic(uDpsds);                                                           //0002
   endif;

Endsr ;
