**free
      //%METADATA                                                      *
      // %TEXT Program to populate file IAPRFXDTL                      *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------- //
//Created By  :  Programmers.io @ 2020                                                  //
//Created Date:  2022/02/14                                                             //
//Developer   :  Mahima                                                                 //
//Description :  Program to populate info of prefix at file level                       //
//                                                                                      //
//Procedure Log:                                                                        //
//------------------------------------------------------------------------------------- //
//Procedure Name           | Procedure Description                                      //
//-------------------------|----------------------------------------------------------- //
//No Procedure             |                                                            //
//------------------------------------------------------------------------------------- //
//MODIFICATION LOG:                                                                     //
//------------------------------------------------------------------------------------- //
//Date    | Mod_ID | Developer  | Case and Description                                  //
//--------|--------|------------|------------------------------------------------------ //
//23/01/27| 0001   | Manesh K   | Replace IAMENUR with BLDMTADTA                        //
//21/11/23| 0002   | Naresh S   | REFRESH Functionality changes (Task #375)             //
//23/10/13| 0003   | Rituraj    | Changed file name AIEXCTIME to IAEXCTIME [Task #248]  //
//05/07/24| 0004   | Vamsi      | Rename Bnddir AIERRBND, copybooks AICERRLOG/AIDERRLOG//
//        |        |            | and procedures AISQLDIAGNOSTIC and AIPSSRERRORLOG    //
//        |        |            | with IA*  [Task#261]                                 //
//22/01/25| 0005   | Vamsi      | IAPGMFILES is restructured.So,updated the columns     //
//        |        | Krishna2   | accordingly.(Task#63)                                 //
//20/08/24| 0006   | Sabarish   | IFS Member Parsing Feature                           //
//------------------------------------------------------------------------------------- //
//H-spec
//------------------------------------------------------------------------------------- //
ctl-opt Copyright('Programmers.io @ 2022');
ctl-opt Option(*NoDebugIo:*SrcStmt:*NoUnRef)
        DftActGrp(*No)
        ActGrp(*Caller);
ctl-opt bndDir('IAERRBND');                                                              //0004

//Main program prototypes
dcl-pi MainPgm  extpgm('PROCSSPRFX');
end-pi;

dcl-pr IAEXCTIMR extpgm('IAEXCTIMR');                                                    //0003
   *n Char(10) Const;
   *n Char(10);
   *n Char(10);
   *n Char(10) Const;
   *n Char(10);
   *n Char(10);
   *n Char(10);
   *n Char(100) Const;                                                                   //0006
   *n Char(10) Const;
   *n Timestamp;
   *n Char(6) Const;
end-pr;

dcl-s uppgm_name      char(10)     inz;
dcl-s uplib_name      char(10)     inz;
dcl-s uptimestamp     Timestamp;
dcl-s upsrc_name      char(10)     inz;
dcl-s wkSqlText       varchar(5000) inz;                                                 //0002

dcl-ds IaMetaInfo dtaara len(62);                                                        //0002
   runmode char(7) pos(1);                                                               //0002
end-ds;                                                                                  //0002

/copy 'QCPYSRC/iaderrlog.rpgleinc'

//------------------------------------------------------------------------------------- //
//Mainline Programming
//------------------------------------------------------------------------------------- //

//Set processing options to be used for SQL Statements in program.
Exec Sql
  Set Option Commit    = *None,
             Naming    = *Sys,
             UsrPrf    = *User,
             DynUsrPrf = *User,
             CloSqlCsr = *EndMod;

In IaMetaInfo;                                                                           //0002

Eval-corr uDpsds = wkuDpsds;

uptimeStamp = %Timestamp();
CallP IAEXCTIMR('BLDMTADTA' :udpsds.ProcNme : udpsds.Lib : '*PGM' :                      //0003
                //0006 upsrc_name : uppgm_name : uplib_name : ' ' :
                upsrc_name : uppgm_name : uplib_name : ' ' : ' ' :                       //0006
                uptimeStamp : 'INSERT');

//Delete references of source member in IAPRFXDTL file for REFRSH                       //0002
if runmode = 'REFRESH';                                                                  //0002
   DltOldPrfxEntries() ;                                                                 //0002
endif;                                                                                   //0002

InsertToIAPRFXDTL();

UPTimeStamp = %Timestamp();
CallP IAEXCTIMR('BLDMTADTA' :udpsds.ProcNme : udpsds.Lib : '*PGM' :                      //0003
                //0006 upsrc_name : uppgm_name : uplib_name : ' ' :
                upsrc_name : uppgm_name : uplib_name : ' ' : ' ' :                       //0006
                uptimeStamp : 'UPDATE');

*inlr = *on;
/copy 'QCPYSRC/iacerrlog.rpgleinc'

//------------------------------------------------------------------------------------- //
//Procedure InsertToIAPRFXDTL
//------------------------------------------------------------------------------------- //
dcl-proc InsertToIAPRFXDTL;

  dcl-pi InsertToIAPRFXDTL;
  end-pi;

  dcl-ds FldInfoDs;
     FieldName   char(10);
     Lib_Name    char(10);
     File_name   char(10);
     Member_name char(10);
     Prefix      char(10);
     SourcePF    char(10);
  end-ds;

  dcl-s changedFieldName char(30);
  dcl-s replacingStr     char(20);
  dcl-s len              packed(4:0);


  if runmode = 'REFRESH';                                                                //0002
     wkSqlText =                                                                         //0002
         'with PGMFILEFIELDS as ' +                                                      //0002
         '(Select  FILEDTL.FIELD_NAME_INTERNAL , FILEDTL.LIBRARY_NAME,' +                //0005
         'FILEDTL.FILE_NAME, PGMFILES.IAMBRNAME,'  +                                     //0005
         'PGMFILES.IAPREFIX , PGMFILES.IASRCFILE ' +                                     //0005
         'from   IAFILEDTL  as FILEDTL '  +                                              //0005
         'join   IAPGMFILES as PGMFILES ' +                                              //0005
         'on  PGMFILES.IALIBNAM  = FILEDTL.LIBRARY_NAME and ' +                          //0005
             'FILEDTL.FILE_NAME = PGMFILES.IAACTFILE ' +                                 //0005
         'where IAPREFIX <> '' '')' +                                                    //0005
         'select  FIELD_NAME_INTERNAL,LIBRARY_NAME,FILE_NAME,' +                         //0005
                 'IAMBRNAME,IAPREFIX,IASRCFILE ' +                                       //0005
         'from PGMFILEFIELDS ' +                                                         //0005
         'join IAREFOBJF ' +                                                             //0005
         'on    LIBRARY_NAME = IAMEMLIB   and ' +                                        //0005
               'IASRCFILE    = IASRCPF    and ' +                                        //0005
               'IAMBRNAME     = IAMEMNAME'  ;                                            //0005
  else ;                                                                                 //0002
     wkSqlText =                                                                         //0002
         'Select  FILEDTL.FIELD_NAME_INTERNAL , FILEDTL.LIBRARY_NAME,' +                 //0005
                 'FILEDTL.FILE_NAME, PGMFILES.IAMBRNAME ,' +                             //0005
                 'PGMFILES.IAPREFIX , PGMFILES.IASRCFILE ' +                             //0005
          'from   IAFILEDTL  as FILEDTL '  +                                             //0005
          'join   IAPGMFILES as PGMFILES ' +                                             //0005
            'on   PGMFILES.IALIBNAM  = FILEDTL.LIBRARY_NAME and ' +                      //0005
                 'FILEDTL.FILE_NAME = PGMFILES.IAACTFILE ' +                             //0005
          'where IAPREFIX <> '' ''';                                                     //0005
  endif;

  exec sql prepare sqlStatement from :wkSqlText  ;
  exec sql declare FldNameCrsr cursor for sqlStatement ;

  exec sql
    Open FldNameCrsr;

  if sqlCode = CSR_OPN_COD;
     exec sql close FldNameCrsr;
     exec sql open  FldNameCrsr;
  endif;

  if sqlCode < successCode;
     uDpsds.wkQuery_Name = 'Open_Cursor_FldNameCrsr';
     IaSqlDiagnostic(uDpsds);                                                            //0004
  endif;

  if sqlCode = successCode;

     exec sql fetch FldNameCrsr into :FldInfoDs;

     if sqlCode < successCode;
        uDpsds.wkQuery_Name = 'Fetch_1_Cursor_FldNameCrsr';
        IaSqlDiagnostic(uDpsds);                                                         //0004
     endif;

     If Prefix <> *Blanks;

        dow sqlCode = successCode;
           clear replacingStr;
           clear len;

           if %scan(':' : Prefix) > 0;
              len = %int(%subst(Prefix : %scan(':' : Prefix) + 1));
              replacingStr = %subst(Prefix : 1 : %scan(':' : Prefix) - 1);
              changedFieldName = %replace(%trim(replacingStr) : fieldname : 1:len);
           else;
              changedFieldName = %trim(Prefix) + %trim(FieldName);
           endif;

           exec sql
             Insert into IAPRFXDTL(LIB_NAME,
                                   FILENAM,
                                   MBR_NAME,
                                   SOURCE_PF,
                                   OLD_FLD_NAME,
                                   NEW_FLD_NAME)
               Values(:Lib_Name,
                      :File_name,
                      :Member_name,
                      :SourcePF,
                      :FieldName,
                      :changedFieldName);

           if sqlCode < successCode;
              uDpsds.wkQuery_Name = 'Insert_IAPRFXDTL';
              IaSqlDiagnostic(uDpsds);                                                   //0004
           endif;

           exec sql fetch FldNameCrsr into :FldInfoDs;

           if sqlCode < successCode;
              uDpsds.wkQuery_Name = 'Fetch_2_Cursor_FldNameCrsr';
              IaSqlDiagnostic(uDpsds);                                                   //0004
           endif;

        enddo;
     Endif;
  endif;

  exec sql close FldNameCrsr;

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure DltOldPrfxEntries : Delete old references of Prefix entries for Refresh
//------------------------------------------------------------------------------------- //
dcl-proc DltOldPrfxEntries ;                                                             //0002
                                                                                         //0002
  //Delete existing old entries from IAPRFXDTL                                          //0002
  exec sql                                                                               //0002
    delete                                                                               //0002
      from iaprfxdtl where exists (                                                      //0002
    select 1                                                                             //0002
      from iARefObjf T1                                                                  //0002
     where iaprfxdtl.IAPFXLIB = T1.IAMEMLIB                                              //0002
       and iaprfxdtl.IAPFXSPF = T1.IASRCPF                                               //0002
       and iaprfxdtl.IAPFXMBR = T1.IAMEMNAME);                                           //0002
                                                                                         //0002
  if sqlCode < successCode;                                                              //0002
     uDpsds.wkQuery_Name = 'Delete_iaprfxdtl';                                           //0002
     IaSqlDiagnostic(uDpsds);                                                  //0004    //0002
  endif;                                                                                 //0002

end-proc;                                                                                //0002
