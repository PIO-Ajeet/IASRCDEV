**free
      //%METADATA                                                      *
      // %TEXT CU Write Pgm/Srvpgm source information                  *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------ //
//CREATED BY :   Programmers.io @ 2021                                                 //
//CREATE DATE:   2021/12/15                                                            //
//DEVELOPER  :   Rohini Alagarsamy, Sandeep Gupta                                      //
//DESCRIPTION:   Write Program and service program descriptions using below APIs       //
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
//        |        |            |                                                      //
//------------------------------------------------------------------------------------ //
ctl-opt copyright('Programmers.io Â© 2021');
ctl-opt option(*NoDebugIO : *SrcStmt : *noUnRef);
ctl-opt dftactgrp(*no);

dcl-f CUPGMINF usage(*Output);

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

dcl-ds SrcInfoDS;
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

dcl-s  ErrorInfo    char(1070);
dcl-s  ErrorRtnCode int(10)  inz;
dcl-s  Index1       int(10)  inz;
dcl-s  Index2       int(10)  inz;
dcl-s  RP_rcv_len   int(10)  inz(500);
dcl-s  RP_Format    char(10) inz('PGMI0100');

dcl-c SQL_ALL_OK '00000';

/copy qsysinc/qrpglesrc,qusec
//------------------------------------------------------------------------------------ //
//Mainline
//------------------------------------------------------------------------------------ //
exec sql
  set option Commit = *None,
             Naming = *Sys,
             Dynusrprf = *User,
             Closqlcsr = *EndMod;

CrtUserSpace('OBJDESCUS QTEMP':'':131072:X'00':
             '*ALL':'Pgm or Srvpgm description':'*YES':QUSEC) ;

GetPointer('OBJDESCUS QTEMP': pHeaderInfo);

CrtUserSpace('BNDSRVPGM QTEMP':'':131072:X'00':
             '*ALL':'Bound Service Programs':'*YES':QUSEC) ;

GetPointer('BNDSRVPGM QTEMP': pHeaderInf1);

//Cursor to select program objects and srv-pgm objects ONLY.
exec sql
  declare GetPgmSrvpgmObj cursor for
    select OdObNm,OdLbNm,OdObTp
    from   IdspObjd
    where  OdObTp In ('*PGM','*SRVPGM');

exec sql open GetPgmSrvPgmObj;
exec sql fetch next from GetPgmSrvPgmObj into :SrcInfoDS;
dow SQLSTATE = SQL_ALL_OK;
   exsr WriteObjDesc;
   exec sql fetch next from GetPgmSrvPgmObj into :SrcInfoDS;
enddo;

exec sql close GetPgmSrvPgmObj;

DltUserSpace('OBJDESCUS QTEMP':ErrorInfo);
DltUserSpace('BNDSRVPGM QTEMP':ErrorInfo);

*Inlr = *On;
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

   if PEP_pgm = Mod and PEP_Lib = ModLib;
      PEP = 'Y';
   else;
      PEP = 'N';
   endif;

   for Index1 = 1 to NbrEntries;
      pgmTyp = pgmtype;
      ModTyp = '*MODULE';
      ModCrtDate = %subst(CrtDate:2:6);
      SrcUpdDate = %subst(UpdDate:2:6);
      write CUPGMINFR;
      pPGML0100 = pPGML0100 + EntryLen;
   endfor;

   for Index2 = 1 to NbrEntries1;
      Clear CUPGMINFR;
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
         write CUPGMINFR;
      endif;
      pPGML0200 = pPGML0200 + EntryLen1;
   endfor;
endsr;
