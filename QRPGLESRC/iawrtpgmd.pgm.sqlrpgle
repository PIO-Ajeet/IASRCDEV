**free
      //%METADATA                                                      *
      // %TEXT Write Pgm/Srvpgm src Info-Has to be part of INIT        *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------ //
//Created By  :  Programmers.io @ 2021                                                 //
//Created Date:  2021/12/15                                                            //
//Developer   :  Rohini Alagarsamy, Sandeep Gupta                                      //
//Description :  Write Program and service program descriptions using below APIs       //
//                     1. QBNLPGMI  (for program info)                                 //
//                     2. QBNLSPGM  (for service program info)                         //
//                     3. QCLRPGMI  (to PEP info)                                      //
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
//26/10/23| 0001   |Abhijith    | Metadata refresh process changes (Task#299)          //
//        |        |Ravindran   |                                                      //
//06/12/23| 0002   |Abhijit C.  | Enhancement to Refresh process.Changes               //
//        |        |            | related to IAOBJECT file.(Task#441)                  //
//01/05/24| 0003   |Akhil K.    | PEP module check and flag change should be done for  //
//        |        |            | each module in *PGM. Earlier, all modules were having//
//        |        |            | PEP flag as 'Y' in IAPGMINF. (Task#653)              //
//06/06/24| 0004   |Saumya      | Renam AIEXCTIMR to AIEXCTIMR [Task #262]             //
//05/07/24| 0005   | Vamsi      | Rename Bnddir AIERRBND, copybooks AICERRLOG/AIDERRLOG//
//        |        |            | and procedures AISQLDIAGNOSTIC and AIPSSRERRORLOG    //
//        |        |            | with IA*  [Task#261]                                 //
//20/08/24| 0006   |Sabarish    | IFS Member Parsing Upgrade                           //
//------------------------------------------------------------------------------------ //
ctl-opt copyright('Programmers.io Â© 2021');
ctl-opt option(*NoDebugIO : *SrcStmt : *noUnRef);
ctl-opt dftactgrp(*no);
ctl-opt bndDir('IAERRBND');                                                              //0005

dcl-f IAPGMINF usage(*Output);

//------------------------------------------------------------------------------------ //
//Standalone Variables
//------------------------------------------------------------------------------------ //
dcl-s PgmName         char(10);
dcl-s LibName         char(10);
dcl-s PgmType         char(10);
dcl-s ErrorInfo       char(1070);
dcl-s RP_Format       char(10)     inz('PGMI0100');
dcl-s uppgm_name      char(10)     inz;
dcl-s uplib_name      char(10)     inz;
dcl-s upsrc_name      char(10)     inz;
dcl-s wkSqlText1      char(1000)   Inz;                                                  //0002

dcl-s ErrorRtnCode    int(10)      inz;
dcl-s Index1          int(10)      inz;
dcl-s Index2          int(10)      inz;
dcl-s RP_rcv_len      int(10)      inz(500);

dcl-s RowsFetched     uns(5);
dcl-s WKROWNUM        uns(5);
dcl-s noOfRows        uns(3);
dcl-s uwindx          uns(3);

dcl-s RowFound        ind          inz('0');

dcl-s uptimestamp     Timestamp;
//------------------------------------------------------------------------------------ //
//Datastructure Definitions.
//------------------------------------------------------------------------------------ //
dcl-ds SrcInfoDS qualified dim(99);
   PgmName char(10) inz;
   LibName char(10) inz;
   PgmType char(10) inz;
end-ds;

dcl-ds QualPgmName;
   Program char(10);
   Library char(10);
end-ds;

dcl-ds HeaderInfo based(pHeaderInfo);
   *n         char(103);
   ListStatus char(1 );
   *n         char(20);
   ListOffset int (10);
   ListSize   int (10);
   NbrEntries int (10);
   EntryLen   int (10);
end-ds;

dcl-ds HeaderInf1 based(pHeaderInf1);
   *n          char(103);
   ListStatus1 char(1 );
   *n          char(20);
   ListOffset1 int (10);
   ListSize1   int (10);
   NbrEntries1 int (10);
   EntryLen1   int (10);
end-ds;

dcl-ds RP_Rcv;
   *n      char(348);
   PEP_Pgm char(10);
   PEP_Lib char(10);
   *n      char(132);
end-ds;

dcl-ds PGML0100 based(pPgmL0100);
   Pgm        char(10);
   Pgmlib     char(10);
   Mod        char(10);
   ModLib     char(10);
   Srcf       char(10);
   SrcLib     char(10);
   SrcMbr     char(10);
   ModAttrib  char(10);
   CrtDate    char(07);
   ModCrtTime char(06);
   UpdDate    char(07);
   SrcUpdTime char(06);
   TgtRls     char(06) Pos(161);
   Obsrv      char(01) Pos(212);
end-ds;

dcl-ds PGML0200 based(pPgmL0200) qualified;
   Pgm    char(10);
   Pgmlib char(10);
   Mod    char(10);
   ModLib char(10);
end-ds;

//Data structure declaration                                                            //0001
dcl-ds iaMetaInfo dtaara len(62);                                                        //0001
   runMode char(7) pos(1);                                                               //0001
end-ds;                                                                                  //0001

//------------------------------------------------------------------------------------ //
//Constant Variables
//------------------------------------------------------------------------------------ //
dcl-c TRUE            '1';
dcl-c FALSE           '0';

//------------------------------------------------------------------------------------ //
//Prototype definition
//------------------------------------------------------------------------------------ //
dcl-pr GetPgmInf   extpgm('QBNLPGMI');
   *n  char(20)    const;
   *n  char(08)    const;
   *n  char(20)    const;
   *n  char(37627) options(*varsize:*nopass);
end-pr;

dcl-pr GetSrvPgmI  extpgm('QBNLSPGM');
   *n  char(20)    const;
   *n  char( 8)    const;
   *n  char(20)    const;
   *n  char(37627) options(*varsize:*nopass);
end-pr;

dcl-pr RtvPgmInfo  extpgm('QCLRPGMI');
   *n  char(500);
   *n  int (10)    const;
   *n  char(8 )    const;
   *n  char(20)    const;
   *n  char(32767) options(*varsize:*noPass);
end-pr;

dcl-pr CrtUserSpace extpgm('QUSCRTUS');
   *n  char(20)     const;                      //UserSpace Name
   *n  char(10)     const;                      //Attribute
   *n  int(10)      const;                      //Initial Size
   *n  char(1)      const;                      //Initial Value
   *n  char(10)     const;                      //Authority
   *n  char(50)     const;                      //Text
   *n  char(10)     const options(*noPass);     //Replace Existing
   *n  char(32767)  options(*varsize:*noPass);  //Error Feedback
end-pr;

dcl-pr GetPointer  extpgm('QUSPTRUS');
   *n  char(20)    const;                       //Name
   *n  pointer;                                 //Pointer to user space
   *n  char(32767) options(*varsize:*nopass);   //Error feedback
end-pr;

dcl-pr DltUserSpace extpgm('QUSDLTUS');
   *n  char(20)     const;                       //Name
   *n  char(32767)  options(*varsize:*nopass);   //Error Feedback
end-pr;

dcl-pr IAEXCTIMR extpgm('IAEXCTIMR');                                                    //0004
    *n Char(10) Const;
    *n Char(10);
    *n Char(10);
    *n Char(10) Const;
    *n Char(10);
    *n Char(10);
    *n Char(10);
    *n Char(100) Const;                                                                  //0006
    *n Char(10) Const;
    *n Timestamp;
    *n Char(6) Const;
end-pr;
//------------------------------------------------------------------------------------ //
//Copybook Definitions
//------------------------------------------------------------------------------------ //
/copy qsysinc/qrpglesrc,qusec
/copy 'QCPYSRC/iaderrlog.rpgleinc'
//------------------------------------------------------------------------------------ //
//Set options
//------------------------------------------------------------------------------------ //
exec sql
  set option Commit = *None,
             Naming = *Sys,
             Dynusrprf = *User,
             Closqlcsr = *EndMod;
                                                                                         //0001
//Retrieve value from Data Area                                                         //0001
in IaMetaInfo;                                                                           //0001

//------------------------------------------------------------------------------------ //
//Cursor definitions
//------------------------------------------------------------------------------------ //

//If Process is 'INIT'                                                                  //0002
if runmode = 'INIT';                                                                     //0002
   wksqltext1 =                                                                          //0002
      ' select IaObjNam, IaLibNam, IaObjTyp'        +                                    //0002
      '   from IaObject'                            +                                    //0002
      '  where IaObjTyp in (''*PGM'',''*SRVPGM'')';                                      //0002
                                                                                         //0002
//If Process is 'REFRESH'                                                               //0002
elseif runmode = 'REFRESH';                                                              //0002
   wksqltext1 =                                                                          //0002
      ' select IaObjNam, IaLibNam, IaObjTyp'           +                                 //0002
      '   from IaObject'                               +                                 //0002
      '  where IaObjTyp in (''*PGM'',''*SRVPGM'') and' +                                 //0002
      '        IaRefresh in (''A'' ,''M'')';                                             //0002
endif;                                                                                   //0002
                                                                                         //0002
//Declare cusrsor for program and srv-pgm objects retrieve details.                     //0002
exec sql prepare PgmSrvstmt from :wksqltext1 ;                                           //0002
exec sql declare GetPgmSrvpgmObj cursor for PgmSrvstmt;                                  //0002
                                                                                         //0002
//------------------------------------------------------------------------------------ //
//Main Logic
//------------------------------------------------------------------------------------ //
Eval-corr uDpsds = wkuDpsds;

//Insert process start time
uptimeStamp = %Timestamp();
CallP IAEXCTIMR('BLDMTADTA' :udpsds.ProcNme : udpsds.Lib : '*PGM' :                      //0004
   //0006 upsrc_name : uppgm_name : uplib_name : ' ' : uptimeStamp : 'INSERT');
   upsrc_name : uppgm_name : uplib_name : ' ' : ' ' : uptimeStamp : 'INSERT');           //0006

//Create user space
CrtUserSpace('OBJDESCUS QTEMP':'':131072:X'00':
             '*ALL':'Pgm or Srvpgm description':'*YES':QUSEC) ;

//Get pointer address
GetPointer('OBJDESCUS QTEMP': pHeaderInfo);

//Create user space
CrtUserSpace('BNDSRVPGM QTEMP':'':131072:X'00':
             '*ALL':'Bound Service Programs':'*YES':QUSEC) ;

//Get pointer address
GetPointer('BNDSRVPGM QTEMP': pHeaderInf1);

//Open cursor
exec sql open GetPgmSrvPgmObj;
if sqlCode = CSR_OPN_COD;
   exec sql close GetPgmSrvPgmObj;
   exec sql open  GetPgmSrvPgmObj;
endif;

if sqlCode < successCode;
   uDpsds.wkQuery_Name = 'Open_Cursor_GetPgmSrvPgmObj';
   IaSqlDiagnostic(uDpsds);                                                              //0005
endif;

//Get the number of elements
noOfRows = %elem(SrcInfoDS);

//Fetch block set of record
rowFound = fetchRecordSrvpgmCursor();

dow rowFound ;

   for uwindx = 1 to RowsFetched;
      PgmName = SrcInfoDS(uwindx).PgmName;
      LibName = SrcInfoDS(uwindx).LibName;
      PgmType = SrcInfoDS(uwindx).PgmType;

      //Delete exisiting records if 'REFRESH'.                                          //0001
      if runMode = 'REFRESH';                                                            //0001
         deleteObjDesc();                                                                //0001
      endIf;                                                                             //0001

      exsr WriteObjDesc;
   endfor;

   //if fetched rows are less than the array elements then come out of the loop.
   if RowsFetched < noOfRows ;
      leave ;
   endif ;

   //Fetch next block set of record
   rowFound = fetchRecordSrvpgmCursor();

enddo;

//Close cursor
exec sql close GetPgmSrvPgmObj;

//Delete user space
DltUserSpace('OBJDESCUS QTEMP':ErrorInfo);
DltUserSpace('BNDSRVPGM QTEMP':ErrorInfo);

//Update process end time
UPTimeStamp = %Timestamp();
CallP IAEXCTIMR('BLDMTADTA' :udpsds.ProcNme : udpsds.Lib : '*PGM' :                      //0004
   //0006 upsrc_name : uppgm_name : uplib_name : ' ' : uptimeStamp : 'UPDATE');
   upsrc_name : uppgm_name : uplib_name : ' ' : ' ' : uptimeStamp : 'UPDATE');           //0006

*Inlr = *On;
/copy 'QCPYSRC/iacerrlog.rpgleinc'

//------------------------------------------------------------------------------------ //
//Write Object descriptions - *PGM and *SRVPGM
//------------------------------------------------------------------------------------ //
begsr WriteObjDesc;

   //Get program or Service-Program information
   select;
      when (PgmType = '*PGM');
         GetPgmInf ('OBJDESCUS QTEMP' : 'PGML0100' :
                    PgmName + LibName : ErrorInfo );

         GetPgmInf ('BNDSRVPGM QTEMP' : 'PGML0200' :
                    PgmName + LibName : ErrorInfo );

      when (PgmType = '*SRVPGM');
         GetSrvPgmI ('OBJDESCUS QTEMP' : 'SPGL0100':
                     PgmName + LibName : ErrorInfo );

         GetSrvPgmI ('BNDSRVPGM QTEMP' : 'SPGL0200' :
                     PgmName + LibName : ErrorInfo );
   endsl;

   pPGML0100 = pHeaderInfo + ListOffset;
   pPGML0200 = pHeaderInf1 + ListOffset1;

   //Get PEP (Program Entry Module) information.
   RtvPgmInfo (RP_rcv : RP_rcv_len : RP_Format :
               PgmName + LibName : ErrorInfo );

   for Index1 = 1 to NbrEntries;
      if PEP_pgm = Mod and PEP_Lib = ModLib;                                             //0003
         PEP = 'Y';                                                                      //0003
      else;                                                                              //0003
         PEP = 'N';                                                                      //0003
      endif;                                                                             //0003
      pgmTyp = pgmtype;
      ModTyp = '*MODULE';
      ModCrtDate = %subst(CrtDate:2:6);
      SrcUpdDate = %subst(UpdDate:2:6);
      write IapgminfR;
      pPGML0100 = pPGML0100 + EntryLen;
   endfor;

   for Index2 = 1 to NbrEntries1;
      Clear IapgminfR;
      pgmTyp = pgmtype;
      ModTyp = '*SRVPGM';
      Pgm = PGML0200.Pgm;
      PgmLib = PGML0200.PgmLib;
      Mod = PGML0200.Mod;
      if %Scan(X'00':PGML0200.ModLib) <> 0;
         ModLib = '*LIBL';
      else;
         ModLib = PGML0200.ModLib;
      endif;
      if ModLib <> 'QSYS';
         write IapgminfR;
      endif;
      pPGML0200 = pPGML0200 + EntryLen1;
   endfor;

endsr;

//------------------------------------------------------------------------------------  //0001
//Delete Object descriptions - *PGM and *SRVPGM                                         //0001
//------------------------------------------------------------------------------------  //0001
dcl-proc DeleteObjDesc;                                                                  //0001
                                                                                         //0001
   exec sql                                                                              //0001
      delete                                                                             //0001
        from Iapgminf a                                                                  //0001
       where a.Pgm = :pgmName                                                            //0001
         and a.PgmLib = :libName                                                         //0001
         and a.PgmTyp = :pgmType;                                                        //0001
                                                                                         //0001
   if sqlCode < successCode;                                                             //0001
      uDpsds.wkQuery_Name = 'Delete_Iapgminf';                                           //0001
      IaSqlDiagnostic(uDpsds);                                                 //0005    //0001
   endif;                                                                                //0001
                                                                                         //0001
end-proc;                                                                                //0001

//------------------------------------------------------------------------------------ //
//Procedure to fetch data from IdspObjd
//------------------------------------------------------------------------------------ //
dcl-proc fetchRecordSrvpgmCursor;

   dcl-pi fetchRecordSrvpgmCursor ind end-pi ;

   dcl-s  rcdFound ind inz('0');
   dcl-s  wkRowNum like(RowsFetched) ;

   RowsFetched = *zeros;
   clear SrcInfoDS ;

   //Fetch data from file
   exec sql
      fetch GetPgmSrvPgmObj for :noofRows rows into :SrcInfoDS;

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Fetch_1_Cursor_GetPgmSrvPgmObj';
      IaSqlDiagnostic(uDpsds);                                                           //0005
   endif;

   //Get fetched no of rows
   if sqlcode = successCode;
      exec sql get diagnostics
         :wkRowNum = ROW_COUNT;
         RowsFetched  = wkRowNum ;
   endif;

   if RowsFetched > 0;
      rcdFound = TRUE;
   elseif sqlcode < successCode ;
      rcdFound = FALSE;
   endif;

   return rcdFound;

end-proc;
