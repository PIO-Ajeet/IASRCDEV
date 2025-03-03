**free
      //%METADATA                                                      *
      // %TEXT Program to fetch source details of an object            *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------- //
//Created By    : Programmers.io @ 2020                                                 //
//Created Date  : 2021/12/15                                                            //
//Developer     : Sandeep Gupta                                                         //
//Description   : Program to fetch Object -> Source mapping                             //
//                                                                                      //
//Procedure Log :                                                                       //
//------------------------------------------------------------------------------------- //
//Procedure Name           | Procedure Description                                      //
//-------------------------|----------------------------------------------------------  //
//No Procedure             |                                                            //
//------------------------------------------------------------------------------------- //
//Modification Log:                                                                     //
//------------------------------------------------------------------------------------- //
//Date    | Mod_ID | Developer  | Case and Description                                  //
//--------|--------|------------|------------------------------------------------------ //
//31/08/23| 0001   | Abhijit C  | Enhance current functionality to log Menu references. //
//        |        |            | [Task #190]                                           //
//23/10/23| 0002   | Bpal       | Refresh functionality. [Task#299]                     //
//23/11/23| 0003   | Akhil K.   | In the case of Refresh, any newly added object with   //
//        |        |            | source code details in IAOBJECT file is not added in  //
//        |        |            | IAOBJMAP file. [Task#405]                             //
//21/12/23| 0004   | Akshay     | Refresh: Keep delete logic for refresh outside        //
//        |        |  Sopori    | main logic. #421                                      //
//06/12/23| 0005   | Abhijit C. | Enhancement to Refresh process.Changes                //
//        |        |            | related to IAOBJECT file.(Task#441)                   //
//30/05/24| 0006   | Vamsi      | Capture Objects with No Source,in Audit File          //
//        |        | Krishna2   | IAGENAUDTP under the category NoSrcFnd (Task#15)      //
//03/06/24| 0007   | Vamsi      | Implement Objects with No Source,in IAGENAUDTP        //
//        |        | Krishna2   | under category NoSrcFnd for REFRESH process(Task#15)  //
//04/07/24| 0008   | Vamsi      | Rename Bnddir AIERRBND, copybooks AICERRLOG/AIDERRLOG //
//        |        |            | and procedures AISQLDIAGNOSTIC and AIPSSRERRORLOG     //
//        |        |            | with IA*  [Task#261]                                  //
//------------------------------------------------------------------------------------- //
ctl-opt copyright('Copyright @ Programmers.io © 2022');
ctl-opt option(*NoDebugIO : *SrcStmt : *noUnRef);
ctl-opt dftactgrp(*no);
ctl-opt bndDir('IAERRBND');                                                              //0008

dcl-f IAOBJMAPIX disk usage(*delete) keyed;                                              //0003
                                                                                         //0003
dcl-pi Iaobjmbrs extpgm('IAOBJMBRS');
   wRepoLib char(10);
end-pi;

dcl-ds DspObjDS;
   wOdlbnm char(10);
   wOdobnm char(10);
   wOdobtp char(10);
   wOdobat char(10);
   wOdsrcf char(10);
   wOdsrcl char(10);
   wOdsrcm char(10);
   wOdrefg char(10);                                                                     //0007
end-ds;

dcl-ds IaMetaInfo dtaara len(62);                                                        //0002
   up_mode char(7) pos(1);                                                               //0002
end-ds;                                                                                  //0002

dcl-s wText        char(40) inz(' ');
dcl-s wPgm         char(10) inz('*PGM');
dcl-s wSrvPgm      char(10) inz('*SRVPGM');
dcl-s uwMatchFound char(01) inz;
dcl-s wSrcTyp      char(10) inz(' ');
dcl-s status_ref   char(1);                                                              //0003
dcl-s wkSqlText1   char(1000) Inz ;                                                      //0005
dcl-c wobtp        Const('*MENU');                                                       //0001

/copy 'QCPYSRC/iaderrlog.rpgleinc'

//------------------------------------------------------------------------------------- //
//Mainline
//------------------------------------------------------------------------------------- //
exec sql
  set option Commit    = *None,
             Naming    = *Sys,
             DynUsrPrf = *User,
             CloSqlCsr = *EndMod;

Eval-corr uDpsds = wkuDpsds;


//If Process is 'INIT'                                                                  //0005
if up_Mode = 'INIT';                                                                     //0005
   wksqltext1 =                                                                          //0005
      ' select T1.IaLibNam, T1.IaObjNam, T1.IaObjTyp, T1.IaObjAtr,'+                     //0005
      ' T1.IASRCFIL, T1.IASRCLIB, T1.IASRCMBR, T1.IAREFRESH'       +                     //0007
      ' from IaObject T1 exception join Iasrcpf T2'                +                     //0005
      ' on T1.IaLibNam = T2.Xlibnam And T1.IaObjNam = T2.Xsrcpf'   +                     //0005
      ' where T1.IaObjTyp <> ''*DTAARA'' ';                                              //0005
                                                                                         //0005
//If Process is 'REFRESH'                                                               //0005
elseif up_Mode = 'REFRESH';                                                              //0005
   wksqltext1 =                                                                          //0005
      ' select T1.IaLibNam, T1.IaObjNam, T1.IaObjTyp, T1.IaObjAtr,'+                     //0005
      ' T1.IASRCFIL, T1.IASRCLIB, T1.IASRCMBR, T1.IAREFRESH'       +                     //0007
      ' from IaObject T1 exception join Iasrcpf T2'                +                     //0005
      ' on T1.IaLibNam = T2.Xlibnam And T1.IaObjNam = T2.Xsrcpf'   +                     //0005
      ' where T1.IaObjTyp <> ''*DTAARA'' and'                      +                     //0005
      ' T1.IaRefresh in (''A'' ,''M'')';                                                 //0005
endif;                                                                                   //0005
                                                                                         //0005
//Declare cusrsor to select objects from IDSPOBJD file.                                 //0005
exec sql prepare Dspstmt from :wksqltext1 ;                                              //0005
exec sql declare Dspobjd_cursor cursor for Dspstmt;                                      //0005

exec sql open Dspobjd_cursor;
if sqlCode = CSR_OPN_COD;
   exec sql close Dspobjd_cursor;
   exec sql open  Dspobjd_cursor;
endif;

if sqlCode < successCode;
   uDpsds.wkQuery_Name = 'open_Dspobjd_cursor';
   IaSqlDiagnostic(uDpsds);                                                              //0008
endif;

exec sql fetch next from Dspobjd_cursor into :DspObjDS;
if sqlCode < successCode;
   uDpsds.wkQuery_Name = 'fetch_1_Dspobjd_cursor';
   IaSqlDiagnostic(uDpsds);                                                              //0008
endif;

//Process each record of IDSPOBJD
dow sqlCode = successCode;

   //Mapping of *MENU object
   if wOdobtp =  wobtp;                                                                  //0001
      wOdsrcm = %trim(wOdobnm)+ 'QQ';                                                    //0001
      exsr zGetMatchedObjectSource;                                                      //0001
      exec sql fetch next from Dspobjd_cursor into :DspObjDS;                            //0001
      Iter;                                                                              //0001
   endif;                                                                                //0001

   if wOdsrcf = *blanks and wOdsrcl = *blanks and
      wOdsrcm = *blanks;

      //Get member detail
      exec sql
        select Srcf, Srclib, Srcmbr
        into :wOdsrcf, :wOdsrcl, :wOdsrcm
        from Iapgminf
        where Pgm = :wOdobnm and
              Pgmlib = :wOdlbnm and
              Pgmtyp = :wOdobtp
        limit 1;

      if sqlCode < successCode;
        uDpsds.wkQuery_Name = 'Select_1_Iapgminf';
        IaSqlDiagnostic(uDpsds);                                                         //0008
      endif;

   endif;

   if sqlCode = successCode and wOdsrcf <> *Blanks
      and wOdsrcl <> *Blanks and wOdsrcm <> *Blanks;
      exsr zGetMatchedObjectSource;
   else;
      exec sql
        select Srcf, Srclib, Srcmbr
        into :wOdsrcf, :wOdsrcl, :wOdsrcm
        from Iapgminf
        where Pgm = :wOdobnm and
              Pgmlib = :wOdlbnm and
              SRCMBR = :wOdobnm and
              Pgmtyp = :wOdobtp
        limit 1;

      if sqlCode < successCode;
         uDpsds.wkQuery_Name = 'select_2_Iapgminf';
         IaSqlDiagnostic(uDpsds);                                                        //0008
      endif;

      if sqlCode = successCode and wOdsrcf <> *Blanks
         and wOdsrcl <> *Blanks and wOdsrcm <> *Blanks;
         exsr zGetMatchedObjectSource;
      else;
         exec sql
           select Srcf, Srclib, Srcmbr
           into :wOdsrcf, :wOdsrcl, :wOdsrcm
           from Iapgminf
           where Pgm = :wOdobnm and
                 Pgmlib = :wOdlbnm and
                 Pgmtyp = :wOdobtp limit 1;

         if sqlCode < successCode;
            uDpsds.wkQuery_Name = 'select_3_Iapgminf';
            IaSqlDiagnostic(uDpsds);                                                     //0008
         endif;

         if sqlCode = successCode and wOdsrcf <> *Blanks
            and wOdsrcl <> *Blanks and wOdsrcm <> *Blanks;
            exsr zGetMatchedObjectSource;
         endif;
      endif;
   endif;

   //Insert into audit file if no source found for the object                           //0006
   if uwMatchFound = 'N';                                                                //0006
      //Below list of objects are valid with out any source. So, skip them.             //0006
      if wOdobtp <> '*BNDDIR' and wOdobtp <> '*DOC' and wOdobtp <> '*DTAARA'             //0006
         and wOdobtp <> '*DTAQ' and wOdobtp <> '*JRN' and wOdobtp <> '*JRNRCV'           //0006
         and wOdobtp <> '*MSGF' and wOdobtp <> '*SRVPGM';                                //0006

           //Adding a new record for the object                                         //0007
           if up_Mode = 'INIT' or (up_Mode = 'REFRESH' and wOdrefg = 'A');               //0007
              exsr insertIntoAuditFile;                                                  //0006

           //Updating the existing records for the object                               //0007
           elseif up_Mode = 'REFRESH' and wOdrefg = 'M' ;                                //0007
              exsr updateAuditFile;                                                      //0007
           endif;                                                                        //0007

      endif;                                                                             //0006
   endif;                                                                                //0006

   exec sql fetch next from Dspobjd_cursor into :DspObjDS;
   if sqlCode < successCode;
         uDpsds.wkQuery_Name = 'fetch_2_Dspobjd_cursor';
         IaSqlDiagnostic(uDpsds);                                                        //0008
      Leave;
   endif;

enddo;

exec sql close Dspobjd_cursor;

*Inlr = *On;

/copy 'QCPYSRC/iacerrlog.rpgleinc'

//------------------------------------------------------------------------------------- //
//Get matched source object detail
//------------------------------------------------------------------------------------- //
begsr zGetMatchedObjectSource;

   uwMatchFound = 'N';
   wSrcTyp = *Blanks;
   wText = *Blanks;

   exec sql
     select Mlseu2 into :wSrcTyp
     from Idspfdmbrl
     where Mlfile = :wOdsrcf and
           Mllib  = :wOdsrcl and
           Mlname = :wOdsrcm
           limit 1;

   if sqlCode < successCode;
         uDpsds.wkQuery_Name = 'select_1_Idspfdmbrl';
         IaSqlDiagnostic(uDpsds);                                                        //0008
   endif;

   //If member does not exist, then search using the source file and member
   if sqlCode <> successCode;

      wOdsrcl = *Blanks;
      wSrcTyp = *Blanks;
      exec sql
        select T1.Mllib, T1.Mlseu2 into :wOdsrcl, :wSrcTyp
        from Idspfdmbrl T1 inner join Iainplib T2
        on T1.Mllib = T2.Xlibnam
        where T1.Mlfile  =  :wOdsrcf and
              T1.Mlname  =  :wOdsrcm and
              T1.Mlseu2  <> ' '      and
              T2.Xrefnam =  :wRepoLib
        order by T2.Xlibseq fetch first row only;

      if sqlCode < successCode;
         uDpsds.wkQuery_Name = 'select_2_Idspfdmbrl';
         IaSqlDiagnostic(uDpsds);                                                        //0008
      endif;

      if sqlCode = successCode and wOdsrcf <> *Blanks and
         wOdsrcl <> *Blanks and wOdsrcm <> *Blanks;

         uwMatchFound = 'Y';

         if wOdobat <> ' ' and wSrcTyp <> ' '
            and %scan(%trim(wOdobat):wSrcTyp) > 0;
            wText = 'Matched on Member, Source file & Type';
         else;
            wText = 'Matched on Member & Source file';
         endif;
      else;

         wOdsrcl = *Blanks;
         wOdsrcf = *Blanks;
         wSrcTyp = *Blanks;

         //If member does not exist, then search using the member
         exec sql
           select T1.Mlfile, T1.Mllib, T1.Mlseu2
           into   :wOdsrcf,  :wOdsrcl, :wSrcTyp
           from Idspfdmbrl T1
            inner join Iainplib T2
            on T1.Mllib = T2.Xlibnam
            where T1.Mlname  = :wOdsrcm and
                  T1.Mlseu2  <> ' '     and
                  T2.Xrefnam = :wRepoLib
            order by T2.Xlibseq
            fetch first row only;

         if sqlCode < successCode;
            uDpsds.wkQuery_Name = 'Select_3_Idspfdmbrl';
            IaSqlDiagnostic(uDpsds);                                                     //0008
         endif;

         if sqlCode = successCode and wOdsrcf <> *Blanks and
            wOdsrcl <> *Blanks and wOdsrcm <> *Blanks;

            uwMatchFound = 'Y';
            if wOdobat <> ' ' and wSrcTyp <> ' '
               and %scan(%trim(wOdobat):wSrcTyp) > 0;
               wText = 'Matched on Member & Type';
            else;
               wText = 'Matched on Member';
            endif;

         endif;
      endif;
   else;
      uwMatchFound = 'Y';
   endif;

   //Insert mapped source details into file IAOBJMAP
   if uwMatchFound = 'Y';
      exsr Insrt_MapDtl;
   endif;

endsr;
//------------------------------------------------------------------------------------- //
//Write into Mapping table
//------------------------------------------------------------------------------------- //
begsr Insrt_MapDtl;

  //Insert record into Mapping file
   exec sql
     insert into Iaobjmap (Iaobjlib ,
                           Iaobjnam ,
                           Iaobjtyp ,
                           Iaobjatr ,
                           Iambrlib ,
                           Iambrsrcf,
                           Iambrnam ,
                           Iambrtyp ,
                           Iarmks   ,
                           Crtuser  ,
                           Crtpgm   )
       values(:wOdlbnm ,
              :wOdobnm ,
              :wOdobtp ,
              :wOdobat ,
              :wOdsrcl ,
              :wOdsrcf ,
              :wOdsrcm ,
              :wSrcTyp ,
              :wText   ,
              :uDpsds.User   ,
              :uDpsds.SrcMbr);

   if sqlCode < successCode;
         uDpsds.wkQuery_Name = 'Insert_Iaobjmap';
         IaSqlDiagnostic(uDpsds);                                                        //0008
   endif;

endsr;

//------------------------------------------------------------------------------------- //
//Refresh_delete_iaobjmap_details  - Delete iaobjmbrs entry for refresh
//------------------------------------------------------------------------------------- //
begsr Refresh_delete_iaobjmap_details;                                                   //0002

   exec sql                                                                              //0004
      delete from IAOBJMAP O where Exists (                                              //0004
        Select 1 from IAREFOBJF R where                                                  //0004
          O.iaobjnam  = R.iaobjname and                                                  //0004
          O.iaobjlib  = R.iaobjlib  and                                                  //0004
          O.iaobjtyp  = R.iaobjtype and                                                  //0004
          R.iastatus = 'M' );                                                            //0004

endsr;                                                                                   //0002

//------------------------------------------------------------------------------------- //0006
//insertIntoAuditFile - Capture Objects with no source found in any of application      //0006
//                      libraries.                                                      //0006
//------------------------------------------------------------------------------------- //0006
begSr insertIntoAuditFile;                                                               //0006
                                                                                         //0006
   exec sql                                                                              //0006
        insert into iAGenAudtP (UniqueCode,                                              //0006
                                iADesText ,                                              //0006
                                iAObjLib  ,                                              //0006
                                iAObjName ,                                              //0006
                                iAObjTyp  ,                                              //0006
                                iAObjAttr ,                                              //0006
                                iAMbrObjD ,                                              //0006
                                CrtUser   ,                                              //0006
                                CrtPgm    )                                              //0006
        values ('NoSrcFnd' ,                                                             //0006
                'Source Not Found' ,                                                     //0006
                :wOdlbnm  ,                                                              //0006
                :wOdobnm  ,                                                              //0006
                :wOdobtp  ,                                                              //0006
                :wOdobat  ,                                                              //0006
                :wText    ,                                                              //0006
                :uDpsds.User ,                                                           //0006
                'IAOBJMBRS'  );                                                          //0006
                                                                                         //0006
   if SqlCode < SuccessCode;                                                             //0006
      uDpsds.wkQuery_Name = 'Insert_Iagenaudtp';                                         //0006
      IaSqlDiagnostic(uDpsds);                                                  //0008   //0006
   endif;                                                                                //0006
                                                                                         //0006
endSr;                                                                                   //0006

//------------------------------------------------------------------------------------- //
//updateAuditFile : To update the change details
//------------------------------------------------------------------------------------- //
BegSr updateAuditFile;                                                                   //0007
                                                                                         //0007
   Exec Sql                                                                              //0007
      Update iAGenAudtP set ChgUser = :uDpsds.User, ChgPgm = 'IAOBJMBRS'                 //0007
         Where UniqueCode = 'NoSrcFnd'                                                   //0007
           And iAObjLib   = :wOdlbnm                                                     //0007
           And iAObjName  = :wOdobnm                                                     //0007
           And iAObjTyp   = :wOdobtp                                                     //0007
           And iAObjAttr  = :wOdobat ;                                                   //0007
                                                                                         //0007
   If SqlCode < SuccessCode;                                                             //0007
      uDpsds.wkQuery_Name = 'Update_Iagenaudtp';                                         //0007
      IaSqlDiagnostic(uDpsds);                                                  //0008   //0007
   EndIf;                                                                                //0007
                                                                                         //0007
EndSr;                                                                                   //0007
                                                                                         //0007
//------------------------------------------------------------------------------------- //
//Clear the table
//------------------------------------------------------------------------------------- //
begsr *Inzsr;

   //Retrieve value from Data Area                                                      //0002
   in IaMetaInfo;                                                                        //0002
   if up_mode = 'INIT';                                                                  //0002
      exec sql delete from IAOBJMAP;
   else;                                                                                 //0004
      exsr Refresh_delete_iaobjmap_details ;                                             //0004
   endif;                                                                                //0004

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Delete_IAOBJMAP';
      IaSqlDiagnostic(uDpsds);                                                           //0008
   endif;                                                                                //0002

endsr;
