**free
      //%METADATA                                                      *
      // %TEXT Update/Write Missing Details in IACPYBDTL               *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------ //
//Created By  :  Programmers.io @ 2024                                                 //
//Created Date:  2024/11/15                                                            //
//Developer   :  Kumar Abhishek Anurag                                                 //
//Description :  Update/Write Missing Details for Copy Book Members in IACPYBDTL       //
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
//17/09/24|        |K Abhishek A|  New Program to update the source file and library   //
//        |        |            |  details for missing Copy Book members in IACPYBDTL  //
//        |        |            |  Table. (TASK#1065)                                   //
//------------------------------------------------------------------------------------ //
ctl-opt copyright('Programmers.io © 2024');
ctl-opt option(*NoDebugIO : *SrcStmt : *noUnRef);
ctl-opt dftactgrp(*no);
ctl-opt bndDir('IAERRBND');

//------------------------------------------------------------------------------------- //
//Data Structure Definitions
//------------------------------------------------------------------------------------- //
dcl-ds uDCpyBookDtl qualified dim(999);
   iACpyDir      char(8);
   iAMbrLib      char(10);
   iAMbrSrcPf    char(10);
   iAMbrName     char(10);
   iAMbrType     char(10);
   iAMbrRRN      packed(6:0);
   iACpyMbr      char(10);
   iACpySrcPf    char(10);
   iACpyLib      char(10);
end-ds;

dcl-ds w_CpyBookDtlDS qualified;
   iACpyDir      char(8);
   iAMbrLib      char(10);
   iAMbrSrcPf    char(10);
   iAMbrName     char(10);
   iAMbrType     char(10);
   iAMbrRRN      packed(6:0);
   iACpyMbr      char(10);
   iACpySrcPf    char(10);
   iACpyLib      char(10);
end-ds;

dcl-ds w_CpyBookDtlDSBk LikeDs(w_CpyBookDtlDS);

dcl-ds uDCpyBookMbrRef qualified Dim(999);
   iACpyLib    char(10);
   iACpySrcPf  char(10);
end-ds;

//------------------------------------------------------------------------------------- //
//Standalone Variable Definitions
//------------------------------------------------------------------------------------- //
dcl-s wUpdAudFlg          char(1);
dcl-s wUpdDoneFlg         char(1);

dcl-s RowsFetched         uns(5);
dcl-s RowsFetched2        uns(5);
dcl-s noOfRows            uns(5);
dcl-s numOfRows           uns(5);
dcl-s uwindx              uns(5);
dcl-s arrindex            uns(5);

dcl-s rowFound            ind    inz('0');
dcl-s wRecFound           ind    inz('0');

dcl-s wkRowNum            like(RowsFetched);

//------------------------------------------------------------------------------------- //
//Constant Variables
//------------------------------------------------------------------------------------- //
dcl-c TRUE            '1';
dcl-c FALSE           '0';

//------------------------------------------------------------------------------------- //
//Copybook Definitions
//------------------------------------------------------------------------------------- //
/copy 'QCPYSRC/iaderrlog.rpgleinc'

//------------------------------------------------------------------------------------- //
//Entry Parameter
//------------------------------------------------------------------------------------- //
dcl-pi IACPYBDTLR extpgm('IACPYBDTLR');
   xref char(10);
end-pi;

//------------------------------------------------------------------------------------ //
//Set options
//------------------------------------------------------------------------------------ //
exec sql
  set option Commit = *None,
             Naming = *Sys,
             DynUsrPrf = *User,
             CloSqlCsr = *EndMod;

//------------------------------------------------------------------------------------ //
//Mainline
//------------------------------------------------------------------------------------ //
Eval-corr uDpsds = wkuDpsds;

//Declare Cursor
exec sql
  declare Copybook_Detail sensitive cursor for
    select iACpyDir, iAMbrLib, iAMbrSrcPf,
           iAMbrName, iAMbrType, iAMbrRRN,
           iACpyMbr, iACpySrcPf, iACpyLib
      from IaCpyBDtl;

//Open Cursor
exec sql open Copybook_Detail;

if sqlCode = CSR_OPN_COD;
   exec sql close Copybook_Detail;
   exec sql open  Copybook_Detail;
endif;

//Get the number of elements
noOfRows = %elem(uDCpyBookDtl);

//Fetch records from CopyBook Detail Cursor
rowFound = fetchRecordCpyBookDtlCursor();

if rowFound;

   for uwindx = 1 to RowsFetched;

      w_CpyBookDtlDS    = uDCpyBookDtl(uwindx);
      w_CpyBookDtlDSBk  = uDCpyBookDtl(uwindx);

      exsr CopyBookInfo;

   endfor;

endif;

*Inlr = *On;

/copy 'QCPYSRC/iacerrlog.rpgleinc'

//------------------------------------------------------------------------------------ //
//SR CopyBookInfo: Retrieve CopyBook Details and write/update in file IACPYBDTL        //
//------------------------------------------------------------------------------------ //
begsr CopyBookInfo;

   if w_CpyBookDtlDSBk.iACpyLib <> ' ';
      exsr SrUpdAuditFlag;
      leaveSr;
   endif;

   //Get all the references of CopyBook present in library list setup
   exsr SrGetCopyBookRef;

   wUpdAudFlg  = 'Y';
   wUpdDoneFlg = 'N';

   for arrindex = 1 to RowsFetched2;

      select;
        when w_CpyBookDtlDSBk.iACpySrcPf <> ' '
             and w_CpyBookDtlDSBk.iACpySrcPf <> uDCpyBookMbrRef(arrindex).iACpySrcPf;
            iter;
        when w_CpyBookDtlDSBk.iACpyLib <> ' '
             and w_CpyBookDtlDSBk.iACpyLib <> uDCpyBookMbrRef(arrindex).iACpyLib;
            iter;
      endsl;

      if w_CpyBookDtlDSBk.iACpySrcPf = ' '
         and w_CpyBookDtlDSBk.iACpyLib   = ' '
         and uDCpyBookMbrRef(arrindex).iACpySrcPf <> 'QRPGLESRC';
         iter;
      endif;

      w_CpyBookDtlDS.iACpyLib   = uDCpyBookMbrRef(arrindex).iACpyLib;
      w_CpyBookDtlDS.iACpySrcPf = uDCpyBookMbrRef(arrindex).iACpySrcPf;
      wUpdAudFlg = 'N';

      if wUpdDoneFlg = 'N';
         exsr SrUpdCpyBDtl;
      else;
         exsr SrWrtCpyBDtl;
      endif;

   endfor;

   if wUpdAudFlg = 'Y';
      exsr SrUpdAuditFlag;
   endif;

endsr;
//------------------------------------------------------------------------------------ //
//SR SrUpdAuditFlag: Check if Get other reference of CopyBook in the lib               //
//------------------------------------------------------------------------------------ //
begsr SrUpdAuditFlag;
   wRecFound = '0';

   exec sql
   Select '1' into :wRecFound
     from IAMEMBER
    where IASRCLIB   = :w_CpyBookDtlDSBk.iACpyLib
      and IASRCPFNAM = :w_CpyBookDtlDSBk.iACpySrcPf
      and IAMBRNAM   = :w_CpyBookDtlDSBk.iACpyMbr;

   if wRecFound = '0';
      exec sql
        update IACPYBDTL
           set IAAUDIT = 'Y',
               IAUPDBYUSR = Current_User
         where IAMBRLIB   = :w_CpyBookDtlDSBk.iAMbrLib
           and IAMBRSRCPF = :w_CpyBookDtlDSBk.iAMbrSrcPf
           and IAMBRNAME  = :w_CpyBookDtlDSBk.iAMbrName
           and IACPYLIB   = :w_CpyBookDtlDSBk.iACpyLib
           and IACPYSRCPF = :w_CpyBookDtlDSBk.iACpySrcPf
           and IACPYMBR   = :w_CpyBookDtlDSBk.iACpyMbr;
   endif;

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Update_AuditFlag_IaCpyBDtl';
      IaSqlDiagnostic(uDpsds);
   endif;

endsr;
//------------------------------------------------------------------------------------ //
//SR SrUpdCpyBDtl: Update CopyBook details                                             //
//------------------------------------------------------------------------------------ //
begsr SrUpdCpyBDtl;

   exec sql
     update IACPYBDTL
        set IACPYLIB   = :w_CpyBookDtlDS.iACpyLib,
            IACPYSRCPF = :w_CpyBookDtlDS.iACpySrcPf,
            IAUPDBYUSR = Current_User
      where IAMBRLIB = :w_CpyBookDtlDSBk.iAMbrLib
        and IAMBRSRCPF = :w_CpyBookDtlDSBk.iAMbrSrcPf
        and IAMBRNAME  = :w_CpyBookDtlDSBk.iAMbrName
        and IACPYLIB   = :w_CpyBookDtlDSBk.iACpyLib
        and IACPYSRCPF = :w_CpyBookDtlDSBk.iACpySrcPf
        and IACPYMBR   = :w_CpyBookDtlDSBk.iACpyMbr;


   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Update_IaCpyBDtl';
      IaSqlDiagnostic(uDpsds);
   else;
      wUpdDoneFlg = 'Y';
   endif;

endsr;
//------------------------------------------------------------------------------------ //
//SR SrWrtCpyBDtl: Insert other references of CopyBook details from the library list   //
//------------------------------------------------------------------------------------ //
begsr SrWrtCpyBdtl;
   exec sql
     insert into IACPYBDTL (IACPYDIR  ,
                            IAMBRSRCPF,
                            IAMBRLIB,
                            IAMBRNAME,
                            IAMBRTYPE,
                            IAMBRRRN,
                            IACPYLIB ,
                            IACPYSRCPF,
                            IACPYMBR  ,
                            IACRTBYUSR,
                            IACRTBYTIM)
                    values(:w_CpyBookDtlDS.IACPYDIR  ,
                           :w_CpyBookDtlDS.IAMBRSRCPF,
                           :w_CpyBookDtlDS.IAMBRLIB  ,
                           :w_CpyBookDtlDS.IAMBRNAME ,
                           :w_CpyBookDtlDS.IAMBRTYPE ,
                           :w_CpyBookDtlDS.IAMBRRRN  ,
                           :w_CpyBookDtlDS.IACPYLIB  ,
                           :w_CpyBookDtlDS.IACPYSRCPF,
                           :w_CpyBookDtlDS.IACPYMBR  ,
                           Current_user          ,
                           Current_TimeStamp)    ;

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Insert_IaCpyBDtl';
      IaSqlDiagnostic(uDpsds);
   endif;

endsr;
//------------------------------------------------------------------------------------ //
//SR SrGetCopyBookRef: Get other reference of CopyBook in the lib                      //
//------------------------------------------------------------------------------------ //
begsr SrGetCopyBookRef;

   numofRows = %elem(uDCpyBookMbrRef);
   reset RowsFetched2;
   reset wkRowNum;
   clear uDCpyBookMbrRef;

   Exec Sql
     Declare GetMbrLibDetails Cursor for
      select MLLIB, MLFILE
        from IDSPFDMBRL
        join IAINPLIB
          on XREF_NAME = :xref
         and LIBRARY_NAME = MLLIB
         and MLNAME = :w_CpyBookDtlDSBk.iaCpyMbr
       where not exists (Select *
                           from IAOBJMAP
                          where IAMBRLIB = MLLIB
                            and IAMBRSRCF = MLFILE
                            and IAMBRNAM = MLNAME)
                order by XLIBSeq;

   //Open Cursor
   exec Sql open GetMbrLibDetails;

   if sqlCode = CSR_OPN_COD;
      exec sql close GetMbrLibDetails;
      exec sql open  GetMbrLibDetails;
   endif;

   exec Sql
      fetch GetMbrLibDetails for :numOfRows rows into :uDCpyBookMbrRef;

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Fetch_GetMbrLibDetails_Detail';
      IaSqlDiagnostic(uDpsds);
   endif;

   if sqlcode = successCode;
      exec sql get diagnostics
          :wkRowNum = ROW_COUNT;
           RowsFetched2  = wkRowNum;
   endif;

   exec Sql close GetMbrLibDetails;

endsr;

//------------------------------------------------------------------------------------- //
//Procedure fetchRecordCpyBookDtlCursor:
//------------------------------------------------------------------------------------- //
dcl-proc fetchRecordCpyBookDtlCursor;

   dcl-pi fetchRecordCpyBookDtlCursor ind end-pi ;

   dcl-s  rcdFound ind inz('0');

   reset RowsFetched;
   reset wkRowNum;
   clear uDCpyBookDtl;

   exec sql
      fetch Copybook_Detail for :noOfRows rows into :uDCpyBookDtl;

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Fetch_Copybook_Detail';
      IaSqlDiagnostic(uDpsds);
   endif;

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

   exec sql close Copybook_Detail;

   return rcdFound;

end-proc;

