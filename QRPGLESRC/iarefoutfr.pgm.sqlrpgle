**Free
      //%METADATA                                                      *
      // %TEXT Updates the iA outfiles during refresh process          *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------- //
//Created By  : Programmers.io @ 2023                                                   //
//Created Date: 2023/05/13                                                              //
//Developer   : Braj                                                                    //
//Description : This program updates the iA outfiles with the latest changes during     //
//              refresh process.                                                        //
//                                                                                      //
//Modification Log:                                                                     //
//------------------------------------------------------------------------------------- //
//Date    | MOD  | Developer | Case and Description                                     //
//--------| -----| ----------|--------------------------------------------------------- //
//23/11/23| 0001 | Akshay    | Refresh Process : Issues in entry of IAREFOBJF.          //
//        |      |  Sopori   | Task:#401                                                //
//23/11/23| 0002 | Akshay    | Refresh Process : Newly added file fields not getting    //
//        |      |  Sopori   | captured. Task #403                                      //
//04/12/23| 0003 | Naresh S  | Refresh process : Corrected incorrect fetch statement    //
//        |      |           | on IADSPDBR and Resolved incorrect entries issue.Task#415//
//05/11/23| 0004 | Akshay    | Refresh Process : Rewrite the logic for outfiles based   //
//        |      |  Sopori   | on DSPPGMREF. Task #428                                  //
//07/12/23| 0005 | Akshay    | Refresh : IAOBJREFPF not correctly reflecting refresh    //
//        |      |  Sopori   | changes. #454                                            //
//13/12/23| 0006 | Akshay    | Refresh : IDSPFDMBR file not reflecting refresh changes  //
//        |      |  Sopori   | in case of multimember physical file. #449               //
//18/12/23| 0007 | Akhil K.  | Refresh : To check if the qtemp files exist before       //
//        |      |           | calling the related procedure. Not checking for 4 files  //
//        |      |           | as those are created without any condition. #463         //
//22/12/23| 0008 | Naresh S  | Eliminate unnecessary  loops for same PF in IADSPDBR     //
//        |      |           | populate logic.Task#486.                                 //
//04/01/24| 0009 | Tanisha K | Remove the IDSPFDDISP file and its usages from product   //
//        |      |           | [Task#:505]                                              //
//06/06/24| 0010 | Saumya    | Rename AIEXCTIMR to IAEXCTIMR [Task #262]                //
//05/07/24| 0011 | Akhil K.  | Renamed AIERRBND, AICERRLOG, AIDERRLOG and AISQLDIAGNOSTI//
//        |      |           | C with IA*                                               //
//20/08/24| 0012 | Sabarish  | IFS Member Parsing Upgrade                               //
//------------------------------------------------------------------------------------- //
ctl-opt CopyRight('Copyright @ Programmers.io © 2022 ');
ctl-opt Option(*NoDebugIo:*SrcStmt:*NoUnref);
ctl-opt BndDir('IABNDDIR' : 'IAERRBND');                                                 //0011

//------------------------------------------------------------------------------------- //
//Entry Parameter
//------------------------------------------------------------------------------------- //
dcl-pi IAOUTFILES extpgm('IAOUTFILES');
   uwxref       char(10) options(*nopass);
   uwProg       char(74) options(*nopass);
   uwRefreshErr char(01) options(*nopass);
end-pi;

//------------------------------------------------------------------------------------- //
//CopyBooks Declaration
//------------------------------------------------------------------------------------- //
/copy 'QMODSRC/iasrv01pr.rpgleinc'
/copy 'QCPYSRC/iaderrlog.rpgleinc'

//------------------------------------------------------------------------------------- //
//Prototype declaration
//------------------------------------------------------------------------------------- //
dcl-pr IAEXCTIMR extpgm('IAEXCTIMR');                                                    //0010
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

//------------------------------------------------------------------------------------- //
//Data Structure declaration
//------------------------------------------------------------------------------------- //
dcl-ds DspObjDS;
   wODLBNM char(10);
   wODOBNM char(10);
   wODOBTP char(8);
   wODCDAT char(6);
   wODCTIM char(6);
   wODLDAT char(6);
   wODLTIM char(6);
end-ds;

dcl-ds DspfdMbrlDS;
   wMLLIB  char(10);
   wMLNAME char(10);
   wMLFILE char(10);
   wMLSEU2 char(10);
   wMLCDAT char(6);
   wMLCHGD char(6);
   wMLCHGT char(6);
end-ds;

dcl-ds IaObjMbrDTDS extname('IAREFOBJF') qualified end-ds;

dcl-ds IaObjMapDS extname('IAOBJMAP') qualified end-ds;

//------------------------------------------------------------------------------------- //
//Variable declaration
//------------------------------------------------------------------------------------- //
dcl-s command            char(1000)   inz;
dcl-s uwerror            char(1)      inz;
dcl-s uwlib              char(10)     inz;
dcl-s uwname             char(10)     inz;
dcl-s uwbkname           char(10)     inz;
dcl-s data_library       varchar(10)  inz;
dcl-s uwcount            packed(4:0)  inz;
dcl-s uwcount1           packed(4:0)  inz;
dcl-s Ind_FirstTime      ind          inz;
dcl-s uppgm_name         char(10)     inz;
dcl-s uplib_name         char(10)     inz;
dcl-s upsrc_name         char(10)     inz;
dcl-s uptimestamp        Timestamp;
dcl-s RefreshTimeStamp   timestamp inz;
dcl-s ObjRefType         char(1) inz;

//------------------------------------------------------------------------------------- //
//Constant declaration
//------------------------------------------------------------------------------------- //

//------------------------------------------------------------------------------------- //
//Mainline Programming
//------------------------------------------------------------------------------------- //
exec sql
  set option commit    = *none,
             naming    = *sys,
             usrprf    = *user,
             dynusrprf = *user,
             closqlcsr = *endmod;

Eval-corr uDpsds = wkuDpsds;
uptimeStamp = %Timestamp();

CallP IAEXCTIMR('BLDMTADTA':udpsds.ProcNme  : udpsds.Lib : '*PGM' :                      //0010
                 upsrc_name : uppgm_name : uplib_name : ' ' :
                 //0012 uptimeStamp : 'INSERT');
                 ' ' : uptimeStamp : 'INSERT');                                          //0012

clear command;
uwRefreshErr = 'N';

//Refresh the IDSPFDBASA details
RefreshIDSPFDBASADetail();

//Refresh the IDSPFDSLOM details
if CheckforFileExistence('IDSPFDSLOM');                                                  //0007
   RefreshIDSPFDSLOMDetail();
endif;                                                                                   //0007

//Refresh the IDSPFDKEYS details
if CheckforFileExistence('IDSPFDKEYS');                                                  //0007
   RefreshIDSPFDKEYSDetail();
endif;                                                                                   //0007

//Refresh the IDSPFDSEQ  details
if CheckforFileExistence('IDSPFDSEQ');                                                   //0007
   RefreshIDSPFDSEQDetail();
endif;                                                                                   //0007

//Refresh the IDSPFDRFMT details
if CheckforFileExistence('IDSPFDRFMT');                                                  //0007
   RefreshIDSPFDRFMTDetail();
endif;                                                                                   //0007

//Refresh the IDSPFDMBR details
RefreshIDSPFDMBRDetail();                                                                //0001

//Refresh the IDSPFDMBRL details
RefreshIDSPFDMBRLDetail();

//Refresh the IDSPFDJOIN details
if CheckforFileExistence('IDSPFDJOIN');                                                  //0007
   RefreshIDSPFDJOINDetail();
endif;                                                                                   //0007

//Refresh the IDSPFDTRG details
if CheckforFileExistence('IDSPFDTRG');                                                   //0007
   RefreshIDSPFDTRGDetail();
endif;                                                                                   //0007

//Refresh the IDSPFDCST details
if CheckforFileExistence('IDSPFDCST');                                                   //0007
   RefreshIDSPFDCSTDetail();
endif;                                                                                   //0007

//Refresh the IADSPDBR details
if CheckforFileExistence('IADSPDBR');                                                    //0007
   RefreshIADSPDBRDetail();
endif;                                                                                   //0007

//Refresh the IAOBJREFPFDetails
if CheckforFileExistence('IAOBJREFPF');                                                  //0007
   RefreshIAOBJREFPFDetail();
endif;                                                                                   //0007

//Refresh the IDSPPGMREFDetails
if CheckforFileExistence('IDSPPGMREF');                                                  //0007
   RefreshIDSPPGMREFDetail();
endif;                                                                                   //0007

//Refresh the IDSPSRVREFDetails
if CheckforFileExistence('IDSPSRVREF');                                                  //0007
   RefreshIDSPSRVREFDetail();
endif;                                                                                   //0007

//Refresh the IDSPMODREFDetails
if CheckforFileExistence('IDSPMODREF');                                                  //0007
   RefreshIDSPMODREFDetail();
endif;                                                                                   //0007

//Refresh the IDSPQRYREFDetails
if CheckforFileExistence('IDSPQRYREF');                                                  //0007
   RefreshIDSPQRYREFDetail();
endif;                                                                                   //0007

//Refresh the IDSPOBJDDetails                                                           //0001
RefreshIDSPOBJDDetail();                                                                 //0001

//Refresh the IDSPFFDDetails                                                            //0002
if CheckforFileExistence('IDSPFFD');                                                     //0007
   RefreshIDSPFFDDetail();                                                               //0002
endif;                                                                                   //0007

UPTimeStamp = %Timestamp();
CallP IAEXCTIMR('BLDMTADTA': udpsds.ProcNme  : udpsds.Lib : '*PGM' :                     //0010
                 upsrc_name : uppgm_name : uplib_name : ' ' :
                 //0012 uptimeStamp : 'UPDATE');
                 ' ' : uptimeStamp : 'UPDATE');                                          //0012

*inlr = *on;
return;

/copy 'QCPYSRC/iacerrlog.rpgleinc'

//------------------------------------------------------------------------------------- //
//Procedure   :  RefreshIDSPFDBASADetail
//Description :  Read all records from QTEMP/IDSPFDBASA Refresh it.
//------------------------------------------------------------------------------------- //
dcl-proc RefreshIDSPFDBASADetail;

  dcl-s exclusion_Flag char(1);
  dcl-s src_file             char(10);
  dcl-s src_lib              char(10);
  dcl-s Dependent_file       char(10);
  dcl-s Dependent_Library    char(10);

  dcl-c recordnotfoundCode 100;
  dcl-c File    'IDSPFDBASA';
  dcl-c Obj     'ATFILE  ' ;
  dcl-c ObjLib  'ATLIB   ' ;

  //Declare the IDSPFDBASADetail cursor
  exec sql
    declare IDSPFDBASADetail cursor for
      select atfile, atlib
        from QTEMP/IDSPFDBASA;

  //Open the IDSPFDBASADetail cursor
  exec sql open IDSPFDBASADetail;
  if sqlCode = CSR_OPN_COD;
     exec sql close IDSPFDBASADetail;
     exec sql open  IDSPFDBASADetail;
  endif;

  if sqlCode < successCode;
     uDpsds.wkQuery_Name = 'Open_Cursor_IDSPFDBASADetail';
     IaSqlDiagnostic(uDpsds);                                                            //0011
  endif;

  //Fetch the IDSPFDBASADetail cursor
  if sqlCode = successCode;

     exec sql fetch from IDSPFDBASADetail into :src_file, :src_lib;

     if sqlCode < successCode;
        uDpsds.wkQuery_Name = 'Fetch_1_IDSPFDBASADetail';
        IaSqlDiagnostic(uDpsds);                                                         //0011
     endif;

     dow sqlCode = successCode;

        //Check if the details already present in IDSPFDBASA file
        exclusion_Flag = '0';

        exec sql
          select '1' into :exclusion_Flag
            from IDSPFDBASA
           where upper(atfile) = :src_file
             and upper(atlib)  = :src_lib
           limit 1;

        //if the details already present in IADSPBASA file, then delete it.
        if exclusion_Flag = '1';

           exec sql
             delete from IDSPFDBASA
              where upper(atfile)= :src_file
                and upper(atlib) = :src_lib;

           if sqlCode < successCode;
              uDpsds.wkQuery_Name = 'Delete_IDSPFDBASA';
              IaSqlDiagnostic(uDpsds);                                                   //0011
           endif;

        endif;

        //Insert back to IDSPFDBASA file.
        exec sql
          insert into IDSPFDBASA
            select * from QTEMP/IDSPFDBASA
              where upper(atfile)= :src_file
                and upper(atlib) = :src_lib;

        if sqlCode < successCode;
           uDpsds.wkQuery_Name = 'Insert_IDSPFDBASA';
           IaSqlDiagnostic(uDpsds);                                                      //0011
        endif;

        //Fetch the next set of record.
        exec sql fetch from IDSPFDBASADetail into :src_file,:src_lib;

        if sqlCode < successCode;
           uDpsds.wkQuery_Name = 'Fetch_2_IDSPFDBASADetail';
           IaSqlDiagnostic(uDpsds);                                                      //0011
           Leave;
        endif;

     enddo;

     //Close the cursor for IDSPFDBASADetail.
     exec sql close IDSPFDBASADetail;

  endif;

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  RefreshIDSPFDKEYSDetail
//Description :  Read all records from QTEMP/IDSPFDKEYS Refresh it.
//------------------------------------------------------------------------------------- //
dcl-proc RefreshIDSPFDKEYSDetail;

  dcl-s exclusion_Flag char(1);
  dcl-s src_file             char(10);
  dcl-s src_lib              char(10);
  dcl-s Dependent_file       char(10);
  dcl-s Dependent_Library    char(10);

  dcl-c recordnotfoundCode 100;
  dcl-c File    'IDSPFDKEYS';
  dcl-c Obj     'APFILE  ' ;
  dcl-c ObjLib  'APLIB   ' ;

  //Declare the IDSPFDKEYSDetail cursor
  exec sql
    declare IDSPFDKEYSDetail cursor for
      select apfile, aplib
        from QTEMP/IDSPFDKEYS;

  //Open the IDSPFDKEYSDetail cursor
  exec sql open IDSPFDKEYSDetail;
  if sqlCode = CSR_OPN_COD;
     exec sql close IDSPFDKEYSDetail;
     exec sql open  IDSPFDKEYSDetail;
  endif;

  if sqlCode < successCode;
     uDpsds.wkQuery_Name = 'Open_Cursor_IDSPFDKEYSDetail';
     IaSqlDiagnostic(uDpsds);                                                            //0011
  endif;

  //Fetch the IDSPFDKEYSDetail cursor
  if sqlCode = successCode;

     exec sql fetch from IDSPFDKEYSDetail into :src_file, :src_lib;

     if sqlCode < successCode;
        uDpsds.wkQuery_Name = 'Fetch_1_IDSPFDKEYSDetail';
        IaSqlDiagnostic(uDpsds);                                                         //0011
     endif;

     dow sqlCode = successCode;

        //Check if the details already present in IDSPFDKEYS file
        exclusion_Flag = '0';

        exec sql
           select '1' into :exclusion_Flag
             from IDSPFDKEYS
             where upper(apfile) = :src_file and
                   upper(aplib)  = :src_lib
             limit 1;

        //if the details already present in IADSPKEYS file, then delete it.
        if exclusion_Flag = '1';

           exec sql
             delete from IDSPFDKEYS
               where upper(apfile)= :src_file
                 and upper(aplib) = :src_lib;

           if sqlCode < successCode;
              uDpsds.wkQuery_Name = 'Delete_IDSPFDKEYS';
              IaSqlDiagnostic(uDpsds);                                                   //0011
           endif;

        endif;

        //Insert back to IDSPFDKEYS file.
        exec sql
          insert into IDSPFDKEYS
            select * from QTEMP/IDSPFDKEYS
              where upper(apfile)= :src_file
                and upper(aplib) = :src_lib;

        if sqlCode < successCode;
           uDpsds.wkQuery_Name = 'Insert_IDSPFDKEYS';
           IaSqlDiagnostic(uDpsds);                                                      //0011
        endif;

        //Fetch the next set of record.
        exec sql fetch from IDSPFDKEYSDetail into :src_file,:src_lib;

        if sqlCode < successCode;
           uDpsds.wkQuery_Name = 'Fetch_2_IDSPFDKEYSDetail';
           IaSqlDiagnostic(uDpsds);                                                      //0011
           leave;
        endif;

     enddo;

     //Close the cursor for IDSPFDKEYSDetail.
     exec sql close IDSPFDKEYSDetail;

  endif;

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  RefreshIDSPFDSLOMDetail
//Description :  Read all records from QTEMP/IDSPFDSLOM Refresh it.
//------------------------------------------------------------------------------------- //
dcl-proc RefreshIDSPFDSLOMDetail;

  dcl-s exclusion_Flag char(1);
  dcl-s src_file             char(10);
  dcl-s src_lib              char(10);
  dcl-s Dependent_file       char(10);
  dcl-s Dependent_Library    char(10);

  dcl-c recordnotfoundCode 100;
  dcl-c File    'IDSPFDSLOM';
  dcl-c Obj     'SOFILE  ' ;
  dcl-c ObjLib  'SOLIB   ' ;

  //Declare the IDSPFDKEYSDetail cursor
  exec sql
    declare IDSPFDSLOMDetail cursor for
      select sofile, solib
        from QTEMP/IDSPFDSLOM;

  //Open the IDSPFDSLOMDetail cursor
  exec sql open IDSPFDSLOMDetail;
  if sqlCode = CSR_OPN_COD;
     exec sql close IDSPFDSLOMDetail;
     exec sql open  IDSPFDSLOMDetail;
  endif;

  if sqlCode < successCode;
     uDpsds.wkQuery_Name = 'Open_Cursor_IDSPFDSLOMDetail';
     IaSqlDiagnostic(uDpsds);                                                            //0011
  endif;

  //Fetch the IDSPFDSLOMDetail cursor
  if sqlCode = successCode;

     exec sql fetch from IDSPFDSLOMDetail into :src_file, :src_lib;

     if sqlCode < successCode;
        uDpsds.wkQuery_Name = 'Fetch_1_IDSPFDSLOMDetail';
        IaSqlDiagnostic(uDpsds);                                                         //0011
     endif;

     dow sqlCode = successCode;

        //Check if the details already present in IDSPFDSLOM file
        exclusion_Flag = '0';

        exec sql
          select '1' into :exclusion_Flag
            from IDSPFDSLOM
           where upper(sofile) = :src_file
             and upper(solib ) = :src_lib
           limit 1;

        //if the details already present in IDSPFDSLOM file, then delete it.
        if exclusion_Flag = '1';

           exec sql
              delete from IDSPFDSLOM
                where upper(sofile)= :src_file
                  and upper(solib )= :src_lib;

           if sqlCode < successCode;
              uDpsds.wkQuery_Name = 'Delete_IDSPFDSLOM';
              IaSqlDiagnostic(uDpsds);                                                   //0011
           endif;

        endif;

        //Insert back to IDSPFDSLOM file.
        exec sql
          insert into IDSPFDSLOM
            select * from QTEMP/IDSPFDSLOM
              where upper(sofile)= :src_file
                and upper(solib )= :src_lib;

        if sqlCode < successCode;
           uDpsds.wkQuery_Name = 'Insert_IDSPFDSLOM';
           IaSqlDiagnostic(uDpsds);                                                      //0011
        endif;

        //Fetch the next set of record.
        exec sql fetch from IDSPFDSLOMDetail into :src_file,:src_lib;

        if sqlCode < successCode;
           uDpsds.wkQuery_Name = 'Fetch_2_IDSPFDSLOMDetail';
           IaSqlDiagnostic(uDpsds);                                                      //0011
           leave;
        endif;

     enddo;

     //Close the cursor for IDSPFDSLOMDetail.
     exec sql close IDSPFDSLOMDetail;

  endif;

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  RefreshIDSPFDRFMTDetail
//Description :  Read all records from QTEMP/IDSPFDRFMT Refresh it.
//------------------------------------------------------------------------------------- //
dcl-proc RefreshIDSPFDRFMTDetail;

  dcl-s exclusion_Flag char(1);
  dcl-s src_file             char(10);
  dcl-s src_lib              char(10);
  dcl-s Dependent_file       char(10);
  dcl-s Dependent_Library    char(10);

  dcl-c recordnotfoundCode 100;
  dcl-c File    'IDSPFDRFMT';
  dcl-c Obj     'RFFILE  ' ;
  dcl-c ObjLib  'RFLIB   ' ;

  //Declare the IDSPFDRFMTDetail cursor
  exec sql
   declare IDSPFDRFMTDetail cursor for
     select rffile, rflib
       from QTEMP/IDSPFDRFMT;

  //Open the IDSPFDRFMTDetail cursor
  exec sql open IDSPFDRFMTDetail;
  if sqlCode = CSR_OPN_COD;
     exec sql close IDSPFDRFMTDetail;
     exec sql open  IDSPFDRFMTDetail;
  endif;

  if sqlCode < successCode;
     uDpsds.wkQuery_Name = 'Open_Cursor_IDSPFDRFMTDetail';
     IaSqlDiagnostic(uDpsds);                                                            //0011
  endif;

  //Fetch the IDSPFDRFMTDetail cursor
  if sqlCode = successCode;

     exec sql fetch from IDSPFDRFMTDetail into :src_file, :src_lib;

     if sqlCode < successCode;
        uDpsds.wkQuery_Name = 'Fetch_1_IDSPFDRFMTDetail';
        IaSqlDiagnostic(uDpsds);                                                         //0011
     endif;

     dow sqlCode = successCode;

        //Check if the details already present in IDSPFDSLOM file
        exclusion_Flag = '0';

        exec sql
           select '1' into :exclusion_Flag
             from IDSPFDRFMT
            where upper(rffile) = :src_file
              and upper(rflib ) = :src_lib
            limit 1;

        //if the details already present in IDSPFDRFMT file, then delete it.
        if exclusion_Flag = '1';

           exec sql
              delete from IDSPFDRFMT
                 where upper(rffile)= :src_file
                   and upper(rflib )= :src_lib;

           if sqlCode < successCode;
              uDpsds.wkQuery_Name = 'Delete_IDSPFDRFMT';
              IaSqlDiagnostic(uDpsds);                                                   //0011
           endif;

        endif;

        //Insert back to IDSPFDRFMT file.
        exec sql
          insert into IDSPFDRFMT
            select * from QTEMP/IDSPFDRFMT
              where upper(rffile)= :src_file
                and upper(rflib )= :src_lib;

        if sqlCode < successCode;
           uDpsds.wkQuery_Name = 'Insert_IDSPFDRFMT';
           IaSqlDiagnostic(uDpsds);                                                      //0011
        endif;

        //Fetch the next set of record.
        exec sql fetch from IDSPFDRFMTDetail into :src_file,:src_lib;

        if sqlCode < successCode;
           uDpsds.wkQuery_Name = 'Fetch_2_IDSPFDRFMTDetail';
           IaSqlDiagnostic(uDpsds);                                                      //0011
           leave;
        endif;

     enddo;

     //Close the cursor for IDSPFDRFMTDetail.
     exec sql close IDSPFDRFMTDetail;

  endif;

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  RefreshIDSPFDJOINDetail
//Description :  Read all records from QTEMP/IDSPFDJOIN Refresh it.
//------------------------------------------------------------------------------------- //
dcl-proc RefreshIDSPFDJOINDetail;

  dcl-s exclusion_Flag char(1);
  dcl-s src_file             char(10);
  dcl-s src_lib              char(10);
  dcl-s Dependent_file       char(10);
  dcl-s Dependent_Library    char(10);

  dcl-c recordnotfoundCode 100;
  dcl-c File    'IDSPFDJOIN';
  dcl-c Obj     'JNFILE  ' ;
  dcl-c ObjLib  'JNLIB   ' ;

  //Declare the IDSPFDJOINDetail cursor
  exec sql
   declare IDSPFDJOINDetail cursor for
     select jnfile, jnlib
       from QTEMP/IDSPFDJOIN;

  //Open the IDSPFDJOINDetail cursor
  exec sql open IDSPFDJOINDetail;
  if sqlCode = CSR_OPN_COD;
     exec sql close IDSPFDJOINDetail;
     exec sql open  IDSPFDJOINDetail;
  endif;

  if sqlCode < successCode;
     uDpsds.wkQuery_Name = 'Open_Cursor_IDSPFDJOINDetail';
     IaSqlDiagnostic(uDpsds);                                                            //0011
  endif;

  //Fetch the IDSPFDJOINDetail cursor
  if sqlCode = successCode;

     exec sql fetch from IDSPFDJOINDetail into :src_file, :src_lib;

     if sqlCode < successCode;
        uDpsds.wkQuery_Name = 'Fetch_1_IDSPFDJOINDetail';
        IaSqlDiagnostic(uDpsds);                                                         //0011
     endif;

     dow sqlCode = successCode;

        //Check if the details already present in IDSPFDJOIN file
        exclusion_Flag = '0';

        exec sql
           select '1' into :exclusion_Flag
             from IDSPFDJOIN
             where upper(jnfile) = :src_file
               and upper(jnlib ) = :src_lib
             limit 1;

        //if the details already present in IDSPFDJOIN file, then delete it.
        if exclusion_Flag = '1';

           exec sql
              delete from IDSPFDJOIN
                where upper(jnfile)= :src_file
                  and upper(jnlib )= :src_lib;

           if sqlCode < successCode;
              uDpsds.wkQuery_Name = 'Delete_IDSPFDJOIN';
              IaSqlDiagnostic(uDpsds);                                                   //0011
           endif;

        endif;

        //Insert back to IDSPFDJOIN file.
        exec sql
          insert into IDSPFDJOIN
            select * from QTEMP/IDSPFDJOIN
              where upper(jnfile)= :src_file
                and upper(jnlib )= :src_lib;

        if sqlCode < successCode;
           uDpsds.wkQuery_Name = 'Insert_IDSPFDJOIN';
           IaSqlDiagnostic(uDpsds);                                                      //0011
        endif;

        //Fetch the next set of record.
        exec sql fetch from IDSPFDJOINDetail into :src_file,:src_lib;

        if sqlCode < successCode;
           uDpsds.wkQuery_Name = 'Fetch_2_IDSPFDJOINDetail';
           IaSqlDiagnostic(uDpsds);                                                      //0011
           leave;
        endif;

     enddo;

     //Close the cursor for IDSPFDJOINDetail.
     exec sql close IDSPFDJOINDetail;

  endif;

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  RefreshIAOBJREFPFDetail
//Description :  Read all records from QTEMP/IAOBJREFPF Refresh it.
//------------------------------------------------------------------------------------- //
dcl-proc RefreshIAOBJREFPFDetail;

  dcl-s exclusion_Flag char(1);
  dcl-s program              char(10);                                                   //0001
  dcl-s library              char(10);                                                   //0001
  dcl-s obj_typ              char(1);                                                    //0001

  dcl-c recordnotfoundCode 100;
  dcl-c File    'IAOBJREFPF';
  dcl-c Obj     'WHPNAM  ' ;
  dcl-c ObjLib  'WHLIB   ' ;
  dcl-c ObjTyp  'WHSPKG  ' ;                                                             //0004

  //Declare the IAOBJREFPFDetail cursor
  exec sql
   declare IAOBJREFPFDetail cursor for
     select distinct whpnam, whlib, whspkg
       from QTEMP/IAOBJREFPF;                                                            //0004
                                                                                         //0004
  //Open the IAOBJREFPFDetail cursor
  exec sql open IAOBJREFPFDetail;
  if sqlCode = CSR_OPN_COD;
     exec sql close IAOBJREFPFDetail;
     exec sql open  IAOBJREFPFDetail;
  endif;

  if sqlCode < successCode;
     uDpsds.wkQuery_Name = 'Open_Cursor_IAOBJREFPFDetail';
     IaSqlDiagnostic(uDpsds);                                                            //0011
  endif;

  //Fetch the IAOBJREFPFDetail cursor
  if sqlCode = successCode;

     exec sql fetch from IAOBJREFPFDetail into :program , :library, :obj_typ;            //0004

     if sqlCode < successCode;
        uDpsds.wkQuery_Name = 'Fetch_1_IAOBJREFPFDetail';
        IaSqlDiagnostic(uDpsds);                                                         //0011
     endif;

     dow sqlCode = successCode;

        //Check if the details already present in IAOBJREFPF file
        exclusion_Flag = '0';

        exec sql
           select '1' into :exclusion_Flag
             from IAOBJREFPF
            where upper(whpnam) = :program                                               //0001
              and upper(whlib ) = :library                                               //0001
              and upper(whspkg) = :obj_typ                                               //0005
            limit 1;

        //if the details already present in IAOBJREFPF file, then delete it.
        if exclusion_Flag = '1';

           exec sql
              delete from IAOBJREFPF
                where upper(whpnam)= :program                                            //0001
                  and upper(whlib )= :library                                            //0001
                  and upper(whspkg)= :obj_typ ;                                          //0005

           if sqlCode < successCode;
              uDpsds.wkQuery_Name = 'Delete_IAOBJREFPF';
              IaSqlDiagnostic(uDpsds);                                                   //0011
           endif;

        endif;

        //Insert back to IAOBJREFPF file.
        exec sql
          insert into IAOBJREFPF
            select * from QTEMP/IAOBJREFPF
              where upper(whpnam)= :program                                              //0001
                and upper(whlib )= :library                                              //0001
                and upper(whspkg)= :obj_typ ;                                            //0005

        if sqlCode < successCode;
           uDpsds.wkQuery_Name = 'Insert_IAOBJREFPF';
           IaSqlDiagnostic(uDpsds);                                                      //0011
        endif;

        //Fetch the next set of record.
        exec sql fetch from IAOBJREFPFDetail into :program , :library, :obj_typ ;        //0001

        if sqlCode < successCode;
           uDpsds.wkQuery_Name = 'Fetch_2_IAOBJREFPFDetail';
           IaSqlDiagnostic(uDpsds);                                                      //0011
           leave;
        endif;

     enddo;

     //Close the cursor for IAOBJREFPFDetail.
     exec sql close IAOBJREFPFDetail;

  endif;

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  RefreshIDSPPGMREFDetail
//Description :  Read all records from QTEMP/IDSPPGMREF Refresh it.
//------------------------------------------------------------------------------------- //
dcl-proc RefreshIDSPPGMREFDetail;

  dcl-s exclusion_Flag char(1);
  dcl-s program              char(10);
  dcl-s library              char(10);
  dcl-s obj_typ              char(10);                                                   //0001

  dcl-c recordnotfoundCode 100;
  dcl-c File    'IDSPPGMREF';
  dcl-c Obj     'WHPNAM  ' ;
  dcl-c ObjLib  'WHLIB   ' ;                                                             //0001
  dcl-c ObjTyp  'WHSPKG  ' ;                                                             //0004

  //Declare the IDSPPGMREFDetail cursor
  exec sql
   declare IDSPPGMREFDetail cursor for
     select distinct whpnam, whlib                                                       //0004
       from QTEMP/IDSPPGMREF;                                                            //0004

  //Open the IDSPPGMREFDetail cursor
  exec sql open IDSPPGMREFDetail;
  if sqlCode = CSR_OPN_COD;
     exec sql close IDSPPGMREFDetail;
     exec sql open  IDSPPGMREFDetail;
  endif;

  if sqlCode < successCode;
     uDpsds.wkQuery_Name = 'Open_Cursor_IDSPPGMREFDetail';
     IaSqlDiagnostic(uDpsds);                                                            //0011
  endif;

  //Fetch the IDSPPGMREFDetail cursor
  if sqlCode = successCode;

     exec sql fetch from IDSPPGMREFDetail into :program , :library ;                     //0004

     if sqlCode < successCode;
        uDpsds.wkQuery_Name = 'Fetch_1_IDSPPGMREFDetail';
        IaSqlDiagnostic(uDpsds);                                                         //0011
     endif;

     dow sqlCode = successCode;

        //Check if the details already present in IDSPPGMREF file
        exclusion_Flag = '0';

        exec sql
           select '1' into :exclusion_Flag
             from IDSPPGMREF
            where upper(whpnam) = :program                                               //0004
              and upper(whlib ) = :library                                               //0004
            limit 1;

        //if the details already present in IDSPPGMREF file, then delete it.
        if exclusion_Flag = '1';

           exec sql
              delete from IDSPPGMREF
                where upper(whpnam)= :program                                            //0004
                  and upper(whlib )= :library ;                                          //0004

           if sqlCode < successCode;
              uDpsds.wkQuery_Name = 'Delete_IDSPPGMREF';
              IaSqlDiagnostic(uDpsds);                                                   //0011
           endif;

        endif;

        //Insert back to IDSPPGMREF file.
        exec sql
          insert into IDSPPGMREF
            select * from QTEMP/IDSPPGMREF                                               //0004
              where upper(whpnam)= :program                                              //0004
                and upper(whlib )= :library;

        if sqlCode < successCode;
           uDpsds.wkQuery_Name = 'Insert_IDSPPGMREF';
           IaSqlDiagnostic(uDpsds);                                                      //0011
        endif;

        //Fetch the next set of record.
        exec sql fetch from IDSPPGMREFDetail into :program , :library ;                  //0004

        if sqlCode < successCode;
           uDpsds.wkQuery_Name = 'Fetch_2_IDSPPGMREFDetail';
           IaSqlDiagnostic(uDpsds);                                                      //0011
           leave;
        endif;

     enddo;

     //Close the cursor for IDSPPGMREFDetail.
     exec sql close IDSPPGMREFDetail;

  endif;

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  RefreshIDSPSRVREFDetail
//Description :  Read all records from QTEMP/IDSPSRVREF Refresh it.
//------------------------------------------------------------------------------------- //
dcl-proc RefreshIDSPSRVREFDetail;

  dcl-s exclusion_Flag char(1);
  dcl-s program              char(10);                                                   //0001
  dcl-s library              char(10);                                                   //0001
  dcl-s obj_typ              char(10);                                                   //0001

  dcl-c recordnotfoundCode 100;
  dcl-c File    'IDSPSRVREF';
  dcl-c Obj     'WHPNAM  ' ;
  dcl-c ObjLib  'WHLIB   ' ;
  dcl-c ObjTyp  'WHSPKG  ' ;                                                             //0004

  //Declare the IDSPSRVREFDetail cursor
  exec sql
   declare IDSPSRVREFDetail cursor for
     select distinct whpnam, whlib                                                       //0004
       from QTEMP/IDSPSRVREF;

  //Open the IDSPSRVREFDetail cursor
  exec sql open IDSPSRVREFDetail;
  if sqlCode = CSR_OPN_COD;
     exec sql close IDSPSRVREFDetail;
     exec sql open  IDSPSRVREFDetail;
  endif;

  if sqlCode < successCode;
     uDpsds.wkQuery_Name = 'Open_Cursor_IDSPSRVREFDetail';
     IaSqlDiagnostic(uDpsds);                                                            //0011
  endif;

  //Fetch the IDSPSRVREFDetail cursor
  if sqlCode = successCode;

     exec sql fetch from IDSPSRVREFDetail into :program , :library ;                     //0004

     if sqlCode < successCode;
        uDpsds.wkQuery_Name = 'Fetch_1_IDSPSRVREFDetail';
        IaSqlDiagnostic(uDpsds);                                                         //0011
     endif;

     dow sqlCode = successCode;

        //Check if the details already present in IDSPSRVREF file
        exclusion_Flag = '0';

        exec sql
           select '1' into :exclusion_Flag
             from IDSPSRVREF
            where upper(whpnam) = :program                                               //0004
              and upper(whlib ) = :library                                               //0004
            limit 1;

        //if the details already present in IDSPSRVREF file, then delete it.
        if exclusion_Flag = '1';

           exec sql
              delete from IDSPSRVREF
                where upper(whpnam)= :program                                            //0004
                  and upper(whlib )= :library ;                                          //0004

           if sqlCode < successCode;
              uDpsds.wkQuery_Name = 'Delete_IDSPSRVREF';
              IaSqlDiagnostic(uDpsds);                                                   //0011
           endif;

        endif;

        //Insert back to IDSPSRVREF file.
        exec sql
          insert into IDSPSRVREF
            select * from QTEMP/IDSPSRVREF
              where upper(whpnam)= :program                                              //0004
                and upper(whlib )= :library  ;                                           //0004

        if sqlCode < successCode;
           uDpsds.wkQuery_Name = 'Insert_IDSPSRVREF';
           IaSqlDiagnostic(uDpsds);                                                      //0011
        endif;

        //Fetch the next set of record.
        exec sql fetch from IDSPSRVREFDetail into :program , :library ;                  //0004

        if sqlCode < successCode;
           uDpsds.wkQuery_Name = 'Fetch_2_IDSPSRVREFDetail';
           IaSqlDiagnostic(uDpsds);                                                      //0011
           leave;
        endif;

     enddo;

     //Close the cursor for IDSPSRVREFDetail.
     exec sql close IDSPSRVREFDetail;

  endif;

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  RefreshIDSPMODREFDetail
//Description :  Read all records from QTEMP/IDSPMODREF Refresh it.
//------------------------------------------------------------------------------------- //
dcl-proc RefreshIDSPMODREFDetail;

  dcl-s exclusion_Flag char(1);
  dcl-s program              char(10);
  dcl-s library              char(10);
  dcl-s obj_typ              char(10);                                                   //0001

  dcl-c recordnotfoundCode 100;
  dcl-c File    'IDSPMODREF';
  dcl-c Obj     'WHPNAM  ' ;
  dcl-c ObjLib  'WHLIB   ' ;
  dcl-c ObjTyp  'WHSPKG  ' ;                                                             //0004

  //Declare the IDSPMODREFDetail cursor
  exec sql
   declare IDSPMODREFDetail cursor for
     select distinct whpnam, whlib                                                       //0004
       from QTEMP/IDSPMODREF;

  //Open the IDSPMODREFDetail cursor
  exec sql open IDSPMODREFDetail;
  if sqlCode = CSR_OPN_COD;
     exec sql close IDSPMODREFDetail;
     exec sql open  IDSPMODREFDetail;
  endif;

  if sqlCode < successCode;
     uDpsds.wkQuery_Name = 'Open_Cursor_IDSPMODREFDetail';
     IaSqlDiagnostic(uDpsds);                                                            //0011
  endif;

  //Fetch the IDSPMODREFDetail cursor
  if sqlCode = successCode;

     exec sql fetch from IDSPMODREFDetail into :program , :library;                      //0004

     if sqlCode < successCode;
        uDpsds.wkQuery_Name = 'Fetch_1_IDSPMODREFDetail';
        IaSqlDiagnostic(uDpsds);                                                         //0011
     endif;

     dow sqlCode = successCode;

        //Check if the details already present in IDSPMODREF file
        exclusion_Flag = '0';

        exec sql
           select '1' into :exclusion_Flag
             from IDSPMODREF
            where upper(whpnam) = :program                                               //0004
              and upper(whlib ) = :library                                               //0004
            limit 1;

        //if the details already present in IDSPMODREF file, then delete it.
        if exclusion_Flag = '1';

           exec sql
              delete from IDSPMODREF
                where upper(whpnam)= :program                                            //0004
                  and upper(whlib )= :library ;                                          //0004


           if sqlCode < successCode;
              uDpsds.wkQuery_Name = 'Delete_IDSPMODREF';
              IaSqlDiagnostic(uDpsds);                                                   //0011
           endif;

        endif;

        //Insert back to IDSPMODREF file.
        exec sql
          insert into IDSPMODREF
            select * from QTEMP/IDSPMODREF                                               //0001
              where upper(whpnam)= :program                                              //0004
                and upper(whlib )= :library  ;                                           //0004

        if sqlCode < successCode;
           uDpsds.wkQuery_Name = 'Insert_IDSPMODREF';
           IaSqlDiagnostic(uDpsds);                                                      //0011
        endif;

        //Fetch the next set of record.
        exec sql fetch from IDSPMODREFDetail into :program , :library;                   //0004

        if sqlCode < successCode;
           uDpsds.wkQuery_Name = 'Fetch_2_IDSPMODREFDetail';
           IaSqlDiagnostic(uDpsds);                                                      //0011
           leave;
        endif;

     enddo;

     //Close the cursor for IDSPMODREFDetail.
     exec sql close IDSPMODREFDetail;

  endif;

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  RefreshIDSPQRYREFDetail
//Description :  Read all records from QTEMP/IDSPQRYREF Refresh it.
//------------------------------------------------------------------------------------- //
dcl-proc RefreshIDSPQRYREFDetail;

  dcl-s exclusion_Flag char(1);
  dcl-s program              char(10);                                                   //0001
  dcl-s library              char(10);                                                   //0001
  dcl-s obj_typ              char(10);                                                   //0001

  dcl-c recordnotfoundCode 100;
  dcl-c File    'IDSPQRYREF';
  dcl-c Obj     'WHPNAM  ' ;
  dcl-c ObjLib  'WHLIB   ' ;
  dcl-c ObjTyp  'WHSPKG  ' ;                                                             //0004

  //Declare the IDSPQRYREFDetail cursor
  exec sql
   declare IDSPQRYREFDetail cursor for
     select distinct whpnam, whlib, whspkg                                               //0004
       from QTEMP/IDSPQRYREF;

  //Open the IDSPQRYREFDetail cursor
  exec sql open IDSPQRYREFDetail;
  if sqlCode = CSR_OPN_COD;
     exec sql close IDSPQRYREFDetail;
     exec sql open  IDSPQRYREFDetail;
  endif;

  if sqlCode < successCode;
     uDpsds.wkQuery_Name = 'Open_Cursor_IDSPQRYREFDetail';
     IaSqlDiagnostic(uDpsds);                                                            //0011
  endif;

  //Fetch the IDSPQRYREFDetail cursor
  if sqlCode = successCode;

     exec sql fetch from IDSPQRYREFDetail into :program , :library, :obj_typ ;            //0001

     if sqlCode < successCode;
        uDpsds.wkQuery_Name = 'Fetch_1_IDSPQRYREFDetail';
        IaSqlDiagnostic(uDpsds);                                                         //0011
     endif;

     dow sqlCode = successCode;

        //Check if the details already present in IDSPQRYREF file
        exclusion_Flag = '0';

        exec sql
           select '1' into :exclusion_Flag
             from IDSPQRYREF
            where upper(whpnam) = :program                                               //0001
              and upper(whlib ) = :library                                               //0001
              and upper(whotyp) = :obj_typ                                               //0001
            limit 1;

        //if the details already present in IDSPQRYREF file, then delete it.
        if exclusion_Flag = '1';

           exec sql
              delete from IDSPQRYREF
                where upper(whpnam)= :program                                            //0001
                  and upper(whlib )= :library                                            //0001
                  and upper(whotyp)= :obj_typ ;                                          //0001

           if sqlCode < successCode;
              uDpsds.wkQuery_Name = 'Delete_IDSPQRYREF';
              IaSqlDiagnostic(uDpsds);                                                   //0011
           endif;

        endif;

        //Insert back to IDSPQRYREF file.
        exec sql
          insert into IDSPQRYREF
            select * from QTEMP/IDSPQRYREF
              where upper(whpnam)= :program                                              //0001
                and upper(whlib )= :library                                              //0001
                and upper(whotyp)= :obj_typ ;                                            //0001

        if sqlCode < successCode;
           uDpsds.wkQuery_Name = 'Insert_IDSPQRYREF';
           IaSqlDiagnostic(uDpsds);                                                      //0011
        endif;

        //Fetch the next set of record.
        exec sql fetch from IDSPQRYREFDetail into :program , :library, :obj_typ ;         //0001

        if sqlCode < successCode;
           uDpsds.wkQuery_Name = 'Fetch_2_IDSPQRYREFDetail';
           IaSqlDiagnostic(uDpsds);                                                      //0011
           leave;
        endif;

    enddo;

    //Close the cursor for IDSPQRYREFDetail.
    exec sql close IDSPQRYREFDetail;

  endif;

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  RefreshIDSPFDSEQDetail
//Description :  Read all records from QTEMP/IDSPFDSEQ  Refresh it.
//------------------------------------------------------------------------------------- //
dcl-proc RefreshIDSPFDSEQDetail;

  dcl-s exclusion_Flag char(1);
  dcl-s src_file             char(10);
  dcl-s src_lib              char(10);
  dcl-s Dependent_file       char(10);
  dcl-s Dependent_Library    char(10);

  dcl-c recordnotfoundCode 100;
  dcl-c File    'IDSPFDSEQ ';
  dcl-c Obj     'SQFILE  ' ;
  dcl-c ObjLib  'SQLIB   ' ;

  //Declare the IDSPFDKEYSDetail cursor
  exec sql
    declare IDSPFDSEQDetail cursor for
      select sqfile, sqlib
        from QTEMP/IDSPFDSEQ ;

  //Open the IDSPFDSEQDetail cursor
  exec sql open IDSPFDSEQDetail;
  if sqlCode = CSR_OPN_COD;
     exec sql close IDSPFDSEQDetail;
     exec sql open  IDSPFDSEQDetail;
  endif;

  if sqlCode < successCode;
     uDpsds.wkQuery_Name = 'Open_Cursor_IDSPFDSEQDetail';
     IaSqlDiagnostic(uDpsds);                                                            //0011
  endif;

  //Fetch the IDSPFDSEQDetail cursor
  if sqlCode = successCode;

     exec sql fetch from IDSPFDSEQDetail into :src_file, :src_lib;

     if sqlCode < successCode;
        uDpsds.wkQuery_Name = 'Fetch_1_IDSPFDSEQDetail';
        IaSqlDiagnostic(uDpsds);                                                         //0011
     endif;

     dow sqlCode = successCode;

        //Check if the details already present in IDSPFDSLOM file
        exclusion_Flag = '0';

        exec sql
          select '1' into :exclusion_Flag
            from IDSPFDSEQ
           where upper(sqfile) = :src_file
             and upper(sqlib ) = :src_lib
           limit 1;

        //if the details already present in IDSPFDSEQ  file, then delete it.
        if exclusion_Flag = '1';

           exec sql
              delete from IDSPFDSEQ
                where upper(sqfile)= :src_file
                  and upper(sqlib )= :src_lib;

           if sqlCode < successCode;
              uDpsds.wkQuery_Name = 'Delete_IDSPFDSEQ ';
              IaSqlDiagnostic(uDpsds);                                                   //0011
           endif;

        endif;

        //Insert back to IDSPFDSEQ  file.
        exec sql
          insert into IDSPFDSEQ
            select * from QTEMP/IDSPFDSEQ
              where upper(sqfile)= :src_file
                and upper(sqlib )= :src_lib;

        if sqlCode < successCode;
           uDpsds.wkQuery_Name = 'Insert_IDSPFDSEQ ';
           IaSqlDiagnostic(uDpsds);                                                      //0011
        endif;

        //Fetch the next set of record.
        exec sql fetch from IDSPFDSEQDetail into :src_file,:src_lib;

        if sqlCode < successCode;
           uDpsds.wkQuery_Name = 'Fetch_2_IDSPFDSEQDetail';
           IaSqlDiagnostic(uDpsds);                                                      //0011
           leave;
        endif;

     enddo;

     //Close the cursor for IDSPFDSEQDetail.
     exec sql close IDSPFDSEQDetail;

  endif;

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  RefreshIDSPFDTRGDetail
//Description :  Read all records from QTEMP/IDSPFDTRG  Refresh it.
//------------------------------------------------------------------------------------- //
dcl-proc RefreshIDSPFDTRGDetail;

  dcl-s exclusion_Flag char(1);
  dcl-s src_file             char(10);
  dcl-s src_lib              char(10);
  dcl-s Dependent_file       char(10);
  dcl-s Dependent_Library    char(10);

  dcl-c recordnotfoundCode 100;
  dcl-c File    'IDSPFDTRG ';
  dcl-c Obj     'TRFILE  ' ;
  dcl-c ObjLib  'TRLIB   ' ;

  //Declare the IDSPFDTRGSDetail cursor
  exec sql
   declare IDSPFDTRGDetail cursor for
     select trfile, trlib
       from QTEMP/IDSPFDTRG ;

  //Open the IDSPFDTRGDetail cursor
  exec sql open IDSPFDTRGDetail;
  if sqlCode = CSR_OPN_COD;
     exec sql close IDSPFDTRGDetail;
     exec sql open  IDSPFDTRGDetail;
  endif;

  if sqlCode < successCode;
     uDpsds.wkQuery_Name = 'Open_Cursor_IDSPFDTRGDetail';
     IaSqlDiagnostic(uDpsds);                                                            //0011
  endif;

  //Fetch the IDSPFDTRGDetail cursor
  if sqlCode = successCode;

     exec sql fetch from IDSPFDTRGDetail into :src_file, :src_lib;

     if sqlCode < successCode;
        uDpsds.wkQuery_Name = 'Fetch_1_IDSPFDTRGDetail';
        IaSqlDiagnostic(uDpsds);                                                         //0011
     endif;

     dow sqlCode = successCode;

        //Check if the details already present in IDSPFDTRG file
        exclusion_Flag = '0';

        exec sql
           select '1' into :exclusion_Flag
             from IDSPFDTRG
            where upper(trfile) = :src_file
              and upper(trlib ) = :src_lib
            limit 1;

        //if the details already present in IDSPFDTRG  file, then delete it.
        if exclusion_Flag = '1';

           exec sql
              delete from IDSPFDTRG
                where upper(trfile)= :src_file
                  and upper(trlib )= :src_lib;

           if sqlCode < successCode;
              uDpsds.wkQuery_Name = 'Delete_IDSPFDTRG ';
              IaSqlDiagnostic(uDpsds);                                                   //0011
           endif;

        endif;

        //Insert back to IDSPFDTRG  file.
        exec sql
          insert into IDSPFDTRG
            select * from QTEMP/IDSPFDTRG
              where upper(trfile)= :src_file
                and upper(trlib )= :src_lib;

        if sqlCode < successCode;
           uDpsds.wkQuery_Name = 'Insert_IDSPFDTRG ';
           IaSqlDiagnostic(uDpsds);                                                      //0011
        endif;

        //Fetch the next set of record.
        exec sql fetch from IDSPFDTRGDetail into :src_file,:src_lib;

        if sqlCode < successCode;
           uDpsds.wkQuery_Name = 'Fetch_2_IDSPFDSEQDetail';
           IaSqlDiagnostic(uDpsds);                                                      //0011
           leave;
        endif;

     enddo;

     //Close the cursor for IDSPFDTRGDetail.
     exec sql close IDSPFDTRGDetail;

  endif;

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  RefreshIDSPFDMBRDetail                                                //
//Description :  Read all records from QTEMP/IDSPFDMBR  Refresh it.                     //
//------------------------------------------------------------------------------------- //
dcl-proc RefreshIDSPFDMBRDetail;
                                                                                         //0001
  dcl-s exclusion_Flag char(1);                                                          //0001
  dcl-s src_file             char(10);                                                   //0001
  dcl-s src_lib              char(10);                                                   //0001
  dcl-s mbr_name             char(10);                                                   //0001
  dcl-s Dependent_file       char(10);                                                   //0001
  dcl-s Dependent_Library    char(10);                                                   //0001

  dcl-c recordnotfoundCode 100;                                                          //0001
  dcl-c File    'IDSPFDMBR ';                                                            //0001
  dcl-c member  'MBNAME  ' ;                                                             //0001
  dcl-c mbrlib  'MBLIB   ' ;                                                             //0001
  dcl-c srcpf   'MBFILE  ' ;                                                             //0001

  //Declare the IDSPFDMBRSDetail cursor                                                 //0001
  exec sql                                                                               //0001
    declare IDSPFDMBRDetail cursor for                                                   //0001
      select distinct mbfile, mblib                                                      //0006
        from QTEMP/IDSPFDMBR ;                                                           //0001

  //Open the IDSPFDMBRDetail cursor                                                     //0001
  exec sql open IDSPFDMBRDetail;                                                         //0001
  if sqlCode = CSR_OPN_COD;                                                              //0001
     exec sql close IDSPFDMBRDetail;                                                     //0001
     exec sql open  IDSPFDMBRDetail;                                                     //0001
  endif;                                                                                 //0001

  if sqlCode < successCode;                                                              //0001
     uDpsds.wkQuery_Name = 'Open_Cursor_IDSPFDMBRDetail';                                //0001
     IaSqlDiagnostic(uDpsds);                                                            //0011
  endif;                                                                                 //0001

  //Fetch the IDSPFDMBRDetail cursor                                                    //0001
  if sqlCode = successCode;                                                              //0001

     exec sql fetch from IDSPFDMBRDetail into :src_file, :src_lib ;                      //0006

     if sqlCode < successCode;                                                           //0001
        uDpsds.wkQuery_Name = 'Fetch_1_IDSPFDMBRDetail';                                 //0001
        IaSqlDiagnostic(uDpsds);                                                         //0011
     endif;                                                                              //0001

     dow sqlCode = successCode;                                                          //0001

        //Check if the details already present in IDSPFDMBR file                        //0001
        exclusion_Flag = '0';                                                            //0001

        exec sql                                                                         //0001
          select '1' into :exclusion_Flag                                                //0001
            from IDSPFDMBR                                                               //0001
           where upper(mbfile) = :src_file                                               //0001
             and upper(mblib ) = :src_lib                                                //0001
           limit 1;                                                                      //0001

        //if the details already present in IDSPFDMBR  file, then delete it.            //0001
        if exclusion_Flag = '1';                                                         //0001

           exec sql                                                                      //0001
              delete from IDSPFDMBR                                                      //0001
                where upper(mbfile)= :src_file                                           //0001
                  and upper(mblib )= :src_lib ;                                          //0001

           if sqlCode < successCode;                                                     //0001
              uDpsds.wkQuery_Name = 'Delete_IDSPFDMBR ';                                 //0001
              IaSqlDiagnostic(uDpsds);                                                   //0011
           endif;                                                                        //0001

        endif;                                                                           //0001

        //Insert back to IDSPFDMBR  file.                                               //0001
        exec sql                                                                         //0001
          insert into IDSPFDMBR                                                          //0001
            select * from QTEMP/IDSPFDMBR                                                //0001
              where upper(mbfile)= :src_file                                             //0001
                and upper(mblib )= :src_lib ;                                            //0001

        if sqlCode < successCode;                                                        //0001
           uDpsds.wkQuery_Name = 'Insert_IDSPFDMBR ';                                    //0001
           IaSqlDiagnostic(uDpsds);                                                      //0011
        endif;                                                                           //0001

        //Fetch the next set of record.                                                 //0001
        exec sql fetch from IDSPFDMBRDetail into :src_file,:src_lib ;                    //0006

        if sqlCode < successCode;                                                        //0001
           uDpsds.wkQuery_Name = 'Fetch_2_IDSPFDMBRDetail';                              //0001
           IaSqlDiagnostic(uDpsds);                                                      //0011
           leave;                                                                        //0001
        endif;                                                                           //0001

     enddo;                                                                              //0001

     //Close the cursor for IDSPFDMBRDetail.                                            //0001
     exec sql close IDSPFDMBRDetail;                                                     //0001

  endif;

end-proc;                                                                                //0001

//------------------------------------------------------------------------------------- //
//Procedure   :  RefreshIDSPFDMBRLDetail                                                //
//Description :  Read all records from QTEMP/IDSPFDMBRL  Refresh it.                     //
//------------------------------------------------------------------------------------- //
dcl-proc RefreshIDSPFDMBRLDetail;

  dcl-s exclusion_Flag char(1);
  dcl-s src_file             char(10);
  dcl-s src_lib              char(10);
  dcl-s mbr_name             char(10);
  dcl-s Dependent_file       char(10);
  dcl-s Dependent_Library    char(10);

  dcl-c recordnotfoundCode 100;
  dcl-c File    'IDSPFDMBRL';
  dcl-c member  'MLNAME  ' ;                                                             //0001
  dcl-c mbrlib  'MLLIB   ' ;                                                             //0001
  dcl-c srcpf   'MLFILE  ' ;                                                             //0001

  //Declare the IDSPFDMBRLDetail cursor
  exec sql
    declare IDSPFDMBRLDetail cursor for
      select mlfile, mllib, mlname
        from QTEMP/IDSPFDMBRL;

  //Open the IDSPFDMBRLDetail cursor
  exec sql open IDSPFDMBRLDetail;
  if sqlCode = CSR_OPN_COD;
     exec sql close IDSPFDMBRLDetail;
     exec sql open  IDSPFDMBRLDetail;
  endif;

  if sqlCode < successCode;
     uDpsds.wkQuery_Name = 'Open_Cursor_IDSPFDMBRLDetail';
     IaSqlDiagnostic(uDpsds);                                                            //0011
  endif;

  //Fetch the IDSPFDMBRLDetail cursor
  if sqlCode = successCode;

     exec sql fetch from IDSPFDMBRLDetail into :src_file, :src_lib, :mbr_name;

     if sqlCode < successCode;
        uDpsds.wkQuery_Name = 'Fetch_1_IDSPFDMBRLDetail';
        IaSqlDiagnostic(uDpsds);                                                         //0011
     endif;

     dow sqlCode = successCode;

        //Check if the details already present in IDSPFDMBRL file
        exclusion_Flag = '0';

        exec sql
          select '1' into :exclusion_Flag
            from IDSPFDMBRL
           where upper(mlfile) = :src_file
             and upper(mllib ) = :src_lib
             and upper(mlname) = :mbr_name
           limit 1;

        //if the details already present in IDSPFDMBRL file, then delete it.
        if exclusion_Flag = '1';

           exec sql
              delete from IDSPFDMBRL
                where upper(mlfile)= :src_file
                  and upper(mllib )= :src_lib
                  and upper(mlname)= :mbr_name;

           if sqlCode < successCode;
              uDpsds.wkQuery_Name = 'Delete_IDSPFDMBRL';
              IaSqlDiagnostic(uDpsds);                                                   //0011
           endif;

        endif;

        //Insert back to IDSPFDMBRL file.
        exec sql
          insert into IDSPFDMBRL
            select * from QTEMP/IDSPFDMBRL
              where upper(mlfile)= :src_file
                and upper(mllib )= :src_lib
                and upper(mlname)= :mbr_name ;

        if sqlCode < successCode;
           uDpsds.wkQuery_Name = 'Insert_IDSPFDMBRL';
           IaSqlDiagnostic(uDpsds);                                                      //0011
        endif;

        //Fetch the next set of record.
        exec sql fetch from IDSPFDMBRLDetail into :src_file,:src_lib, :mbr_name;

        if sqlCode < successCode;
           uDpsds.wkQuery_Name = 'Fetch_2_IDSPFDMBRLDetail';
           IaSqlDiagnostic(uDpsds);                                                      //0011
           leave;
        endif;

     enddo;

     //Close the cursor for IDSPFDMBRLDetail.
     exec sql close IDSPFDMBRLDetail;

  endif;

end-proc;
//------------------------------------------------------------------------------------- //
//Procedure   :  RefreshIDSPFDCSTDetail
//Description :  Read all records from QTEMP/IDSPFDCST  Refresh it.
//------------------------------------------------------------------------------------- //
dcl-proc RefreshIDSPFDCSTDetail;

  dcl-s exclusion_Flag char(1);
  dcl-s src_file             char(10);
  dcl-s src_lib              char(10);
  dcl-s Dependent_file       char(10);
  dcl-s Dependent_Library    char(10);

  dcl-c recordnotfoundCode 100;
  dcl-c File    'IDSPFDCST ';
  dcl-c Obj     'CSFILE  ' ;
  dcl-c ObjLib  'CSLIB   ' ;

  //Declare the IDSPFDCSTSDetail cursor
  exec sql
    declare IDSPFDCSTDetail cursor for
      select csfile, cslib
        from QTEMP/IDSPFDCST ;

  //Open the IDSPFDCSTDetail cursor
  exec sql open IDSPFDCSTDetail;
  if sqlCode = CSR_OPN_COD;
     exec sql close IDSPFDCSTDetail;
     exec sql open  IDSPFDCSTDetail;
  endif;

  if sqlCode < successCode;
     uDpsds.wkQuery_Name = 'Open_Cursor_IDSPFDCSTDetail';
     IaSqlDiagnostic(uDpsds);                                                            //0011
  endif;

  //Fetch the IDSPFDCSTDetail cursor
  if sqlCode = successCode;

     exec sql fetch from IDSPFDCSTDetail into :src_file, :src_lib;

     if sqlCode < successCode;
        uDpsds.wkQuery_Name = 'Fetch_1_IDSPFDCSTDetail';
        IaSqlDiagnostic(uDpsds);                                                         //0011
     endif;

     dow sqlCode = successCode;

        //Check if the details already present in IDSPFDCST file
        exclusion_Flag = '0';

        exec sql
          select '1' into :exclusion_Flag
            from IDSPFDCST
           where upper(csfile) = :src_file
             and upper(cslib ) = :src_lib
           limit 1;

        //if the details already present in IDSPFDCST  file, then delete it.
        if exclusion_Flag = '1';

           exec sql
              delete from IDSPFDCST
                where upper(csfile)= :src_file
                  and upper(cslib )= :src_lib;

           if sqlCode < successCode;
              uDpsds.wkQuery_Name = 'Delete_IDSPFDCST ';
              IaSqlDiagnostic(uDpsds);                                                   //0011
           endif;

        endif;

        //Insert back to IDSPFDCST  file.
        exec sql
          insert into IDSPFDCST
            select * from QTEMP/IDSPFDCST
              where upper(csfile)= :src_file
                and upper(cslib )= :src_lib;

        if sqlCode < successCode;
           uDpsds.wkQuery_Name = 'Insert_IDSPFDCST ';
           IaSqlDiagnostic(uDpsds);                                                      //0011
        endif;

        //Fetch the next set of record.
        exec sql fetch from IDSPFDCSTDetail into :src_file,:src_lib;

        if sqlCode < successCode;
           uDpsds.wkQuery_Name = 'Fetch_2_IDSPFDCSTDetail';
           IaSqlDiagnostic(uDpsds);                                                      //0011
           leave;
        endif;

     enddo;

     //Close the cursor for IDSPFDCSTDetail.
     exec sql close IDSPFDCSTDetail;

  endif;

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  RefreshIADSPDBRDetail
//Description :  Read all records from QTEMP/IADSPDBR & Refresh it.
//------------------------------------------------------------------------------------- //
dcl-proc RefreshIADSPDBRDetail;

  dcl-s exclusion_Flag char(1);
  dcl-s src_file             char(10);
  dcl-s src_lib              char(10);
  dcl-s Dependent_file       char(10);
  dcl-s Dependent_Library    char(10);

  dcl-c recordnotfoundCode 100;
  dcl-c File    'IADSPDBR' ;
  dcl-c Obj     'WHRFI   ' ;
  dcl-c ObjLib  'WHRLI   ' ;

  //if the details are duplicated in QTEMP/IADSPDBR file, then delete them.             //0003
  DeleteDuplicatesfromQtempIADSPDBR();                                                   //0003

  //Delete LF references from repo/IADSPDBR to avoid redundant records incase           //0003
  //of modifcations on LFs/JLFs.                                                        //0003
  DeleteLFReferencesfromRepoIADSPDBR();                                                  //0003

  //Declare the IADSPDBRDetail cursor
  exec sql
    declare  IADSPDBRDetail  cursor for
      select DISTINCT whrfi, whrli                                                       //0008
        from QTEMP/IADSPDBR ;                                                            //0008

  //Open the IADSPDBRDetail cursor
  exec sql open  IADSPDBRDetail;
  if sqlCode = CSR_OPN_COD;
     exec sql close IADSPDBRDetail;
     exec sql open  IADSPDBRDetail;
  endif;

  if sqlCode < successCode;
     uDpsds.wkQuery_Name = 'Open_Cursor_IADSPDBRDetail';
     IaSqlDiagnostic(uDpsds);                                                            //0011
  endif;

  //Fetch the IADSPDBRDetail cursor
  if sqlCode = successCode;

     exec sql fetch from IADSPDBRDetail into :src_file, :src_lib ;                       //0008

     if sqlCode < successCode;
        uDpsds.wkQuery_Name = 'Fetch_1_IADSPDBRDetail';
        IaSqlDiagnostic(uDpsds);                                                         //0011
     endif;

     dow sqlCode = successCode;

        //Check if the details already present in IADSPDBR file
        exclusion_Flag = '0';

        exec sql
           select '1' into :exclusion_Flag
             from IADSPDBR
            where upper(whrfi) = :src_file
              and upper(whrli) = :src_lib
            limit 1;

        //if the details already present in IADSPDBR file, then delete it.
        if exclusion_Flag = '1';

           exec sql
              delete from IADSPDBR
                where upper(whrfi) = :src_file
                  and upper(whrli) = :src_lib;

           if sqlCode < successCode;
              uDpsds.wkQuery_Name = 'Delete_IADSPDBR';
              IaSqlDiagnostic(uDpsds);                                                   //0011
           endif;

        endif;

        //Insert back to IADSPDBR file.
        exec sql
          insert into IADSPDBR
            select * from QTEMP/IADSPDBR
              where upper(whrfi) = :src_file
                and upper(whrli) = :src_lib;

        if sqlCode < successCode;
           uDpsds.wkQuery_Name = 'Insert_IADSPDBR';
           IaSqlDiagnostic(uDpsds);                                                      //0011
        endif;

        //Fetch the next set of record.
        exec sql fetch from IADSPDBRDetail into :src_file, :src_lib ;                    //0008

        if sqlCode < successCode;
           uDpsds.wkQuery_Name = 'Fetch_2_IADSPDBRDetail';
           IaSqlDiagnostic(uDpsds);                                                      //0011
           leave;
        endif;

     enddo;

     //Close the cursor for IADSPDBRDetail.
     exec sql close IADSPDBRDetail;

  endif;

end-proc;
//------------------------------------------------------------------------------------- //0001
//Procedure   :  RefreshIDSPOBJDDetail                                                  //0001
//Description :  Read all records from QTEMP/IDSPOBJD & Refresh it.                     //0001
//------------------------------------------------------------------------------------- //0001
dcl-proc RefreshIDSPOBJDDetail ;                                                         //0001
                                                                                         //0001
  dcl-s exclusion_Flag char(1);                                                          //0001
  dcl-s obj_name             char(10);                                                   //0001
  dcl-s obj_lib              char(10);                                                   //0001
  dcl-s obj_typ              char(10);                                                   //0001

  dcl-c recordnotfoundCode 100;                                                          //0001
  dcl-c File    'IDSPOBJD' ;                                                             //0001
  dcl-c Obj     'ODOBNM  ' ;                                                             //0001
  dcl-c ObjLib  'ODLBNM  ' ;                                                             //0001
  dcl-c ObjTyp  'ODOBTP  ' ;                                                             //0001

  //Declare the IDSPOBJDDetail cursor                                                   //0001
  exec sql                                                                               //0001
    declare IDSPOBJDDetail cursor for                                                    //0001
      select odlbnm, odobnm, odobtp                                                      //0001
        from QTEMP/IDSPOBJD ;                                                            //0001

  //Open the IDSPOBJDDetail cursor                                                      //0001
  exec sql open  IDSPOBJDDetail;                                                         //0001
  if sqlCode = CSR_OPN_COD;                                                              //0001
     exec sql close IDSPOBJDDetail;                                                      //0001
     exec sql open  IDSPOBJDDetail;                                                      //0001
  endif;                                                                                 //0001

  if sqlCode < successCode;                                                              //0001
     uDpsds.wkQuery_Name = 'Open_Cursor_IDSPOBJDDetail';                                 //0001
     IaSqlDiagnostic(uDpsds);                                                            //0011
  endif;                                                                                 //0001

  //Fetch the IDSPOBJDDetail cursor                                                     //0001
  if sqlCode = successCode;                                                              //0001

     exec sql fetch from IDSPOBJDDetail into :obj_lib, :obj_name,:obj_typ;               //0001

     if sqlCode < successCode;                                                           //0001
        uDpsds.wkQuery_Name = 'Fetch_1_IDSPOBJDDetail';                                  //0001
        IaSqlDiagnostic(uDpsds);                                                         //0011
     endif;                                                                              //0001

     dow sqlCode = successCode;                                                          //0001

        //Check if the details already present in IDSPOBJD file                         //0001
        exclusion_Flag = '0';                                                            //0001

        exec sql                                                                         //0001
           select '1' into :exclusion_Flag                                               //0001
             from IDSPOBJD                                                               //0001
            where upper(odlbnm) = :obj_lib                                               //0001
              and upper(odobnm) = :obj_name                                              //0001
              and upper(odobtp) = :obj_typ                                               //0001
            limit 1;                                                                     //0001

        //if the details already present in IDSPOBJD file, then delete it.              //0001
        if exclusion_Flag = '1';                                                         //0001

           exec sql                                                                      //0001
              delete from IDSPOBJD                                                       //0001
                where upper(odlbnm) = :obj_lib                                           //0001
                  and upper(odobnm) = :obj_name                                          //0001
                  and upper(odobtp) = :obj_typ;                                          //0001

           if sqlCode < successCode;                                                     //0001
              uDpsds.wkQuery_Name = 'Delete_IADSPOBJD';                                  //0001
              IaSqlDiagnostic(uDpsds);                                                   //0011
           endif;                                                                        //0001

        endif;                                                                           //0001

        //Insert back to IDSPOBJD file.                                                 //0001
        exec sql                                                                         //0001
          insert into IDSPOBJD                                                           //0001
            select * from QTEMP/IDSPOBJD                                                 //0001
              where upper(odlbnm) = :obj_lib                                             //0001
                and upper(odobnm) = :obj_name                                            //0001
                and upper(odobtp) = :obj_typ;                                            //0001

        if sqlCode < successCode;                                                        //0001
           uDpsds.wkQuery_Name = 'Insert_IDSPOBJD';                                      //0001
           IaSqlDiagnostic(uDpsds);                                                      //0011
        endif;                                                                           //0001

        //Fetch the next set of record.                                                 //0001
        exec sql fetch from IDSPOBJDDetail into :obj_lib, :obj_name, :obj_typ;           //0001

        if sqlCode < successCode;                                                        //0001
           uDpsds.wkQuery_Name = 'Fetch_2_IDSPOBJDDetail';                               //0001
           IaSqlDiagnostic(uDpsds);                                                      //0011
           leave;                                                                        //0001
        endif;                                                                           //0001

     enddo;                                                                              //0001

     //Close the cursor for IDSPOBJDDetail.                                             //0001
     exec sql close IDSPOBJDDetail;                                                      //0001

  endif;                                                                                 //0001

end-proc;                                                                                //0001

//------------------------------------------------------------------------------------- //0002
//Procedure   :  RefreshIDSPFFDDetail                                                   //0002
//Description :  Read all records from QTEMP/IDSPFFD  & Refresh it.                     //0002
//------------------------------------------------------------------------------------- //0002
dcl-proc RefreshIDSPFFDDetail  ;                                                         //0002
                                                                                         //0002
  dcl-s exclusion_Flag char(1);                                                          //0002
  dcl-s file_name            char(10);                                                   //0002
  dcl-s obj_lib              char(10);                                                   //0002

  dcl-c recordnotfoundCode 100;                                                          //0002
  dcl-c File    'IDSPFFD ' ;                                                             //0002
  dcl-c Obj     'WHFILE  ' ;                                                             //0002
  dcl-c ObjLib  'WHLIB   ' ;                                                             //0002

  //Declare the IDSPFFDDetail cursor                                                    //0002
  exec sql                                                                               //0002
    declare IDSPFFDDetail cursor for                                                     //0002
      select distinct whfile, whlib                                                      //0002
        from QTEMP/IDSPFFD  ;                                                            //0002

  //Open the IDSPFFDDetail cursor                                                       //0002
  exec sql open  IDSPFFDDetail;                                                          //0002
  if sqlCode = CSR_OPN_COD;                                                              //0002
     exec sql close IDSPFFDDetail;                                                       //0002
     exec sql open  IDSPFFDDetail;                                                       //0002
  endif;                                                                                 //0002

  if sqlCode < successCode;                                                              //0002
     uDpsds.wkQuery_Name = 'Open_Cursor_IDSPFFDDetail';                                  //0002
     IaSqlDiagnostic(uDpsds);                                                            //0011
  endif;                                                                                 //0002

  //Fetch the IDSPFFDDetail cursor                                                      //0002
  if sqlCode = successCode;                                                              //0002

     exec sql fetch from IDSPFFDDetail into :file_name, :obj_lib;                        //0002

     if sqlCode < successCode;                                                           //0002
        uDpsds.wkQuery_Name = 'Fetch_1_IDSPFFDDetail';                                   //0002
        IaSqlDiagnostic(uDpsds);                                                         //0011
     endif;                                                                              //0002

     dow sqlCode = successCode;                                                          //0002

        //Check if the details already present in IDSPOBJD file                         //0002
        exclusion_Flag = '0';                                                            //0002

        exec sql                                                                         //0002
           select '1' into :exclusion_Flag                                               //0002
             from IDSPFFD                                                                //0002
            where upper(whfile) = :file_name                                             //0002
              and upper(whlib ) = :obj_lib                                               //0002
            limit 1;                                                                     //0002

        //if the details already present in IDSPFFD file, then delete it.               //0002
        if exclusion_Flag = '1';                                                         //0002

           exec sql                                                                      //0002
              delete from IDSPFFD                                                        //0002
                where upper(whfile) = :file_name                                         //0002
                  and upper(whlib ) = :obj_lib ;                                         //0002

           if sqlCode < successCode;                                                     //0002
              uDpsds.wkQuery_Name = 'Delete_IADSPFFD';                                   //0002
              IaSqlDiagnostic(uDpsds);                                                   //0011
           endif;                                                                        //0002

        endif;                                                                           //0002

        //Insert back to IDSPFFD  file.                                                 //0002
        exec sql                                                                         //0002
          insert into IDSPFFD                                                            //0002
            select * from QTEMP/IDSPFFD                                                  //0002
              where upper(whfile) = :file_name                                           //0002
                and upper(whlib ) = :obj_lib;                                            //0002

        if sqlCode < successCode;                                                        //0002
           uDpsds.wkQuery_Name = 'Insert_IDSPFFD';                                       //0002
           IaSqlDiagnostic(uDpsds);                                                      //0011
        endif;                                                                           //0002

        //Fetch the next set of record.                                                 //0002
        exec sql fetch from IDSPFFDDetail into :file_name, :obj_lib;                     //0002

        if sqlCode < successCode;                                                        //0002
           uDpsds.wkQuery_Name = 'Fetch_2_IDSPFFDDetail';                                //0002
           IaSqlDiagnostic(uDpsds);                                                      //0011
           leave;                                                                        //0002
        endif;                                                                           //0002

     enddo;                                                                              //0002

     //Close the cursor for IADSPFFDetail.                                              //0002
     exec sql close IDSPFFDDetail;                                                       //0002

  endif;                                                                                 //0002

end-proc;                                                                                //0002

//------------------------------------------------------------------------------------- //0003
//Procedure   :  DeleteDuplicatesfromQtempIADSPDBR                                      //0003
//Description :  Delete duplicate records from QTEMP/IADSPDBR if any.                   //0003
//------------------------------------------------------------------------------------- //0003
dcl-proc DeleteDuplicatesfromQtempIADSPDBR;                                              //0003
                                                                                         //0003
   exec sql                                                                              //0003
      delete from QTEMP/IADSPDBR t1                                                      //0003
        where rrn(t1) < (select max(rrn(t2))                                             //0003
                           from qtemp/IADSPDBR t2                                        //0003
                          where t1.whrfi  = t2.whrfi                                     //0003
                            and t1.whrli  = t2.whrli                                     //0003
                            and t1.whrefi = t2.whrefi                                    //0003
                            and t1.whreli = t2.whreli);                                  //0003
                                                                                         //0003
   if sqlCode < successCode;                                                             //0003
      uDpsds.wkQuery_Name = 'Delete_QTEMP/IADSPDBR' ;                                    //0003
      IaSqlDiagnostic(uDpsds);                                                           //0011
   endif;                                                                                //0003
                                                                                         //0003
end-proc;                                                                                //0003
                                                                                         //0003
//------------------------------------------------------------------------------------- //0003
//Procedure   :  DeleteLFReferencesfromRepoIADSPDBR                                     //0003
//Description :  Delete LF references from Repo/IADSPDBR if any to avoid redundant      //0003
//               records in case of Modifications done on LFs/JLFs.                     //0003
//------------------------------------------------------------------------------------- //0003
dcl-proc DeleteLFReferencesfromRepoIADSPDBR ;                                            //0003
                                                                                         //0003
   exec sql                                                                              //0003
     delete                                                                              //0003
       from IADSPDBR t1                                                                  //0003
      where exists (select 1                                                             //0003
                      from iARefObjF t2                                                  //0003
                     where t1.WHRELI = t2.iaobjlib                                       //0003
                       and t1.WHREFI = t2.iaobjname                                      //0003
                       and t2.iastatus = 'M'                                             //0003
                       and t2.iaobjattr='LF') ;                                          //0003
                                                                                         //0003
   if sqlCode < successCode;                                                             //0003
      uDpsds.wkQuery_Name = 'Delete_IADSPDBR_2' ;                                        //0003
      IaSqlDiagnostic(uDpsds);                                                           //0011
   endif;                                                                                //0003
                                                                                         //0003
end-proc;                                                                                //0003

//------------------------------------------------------------------------------------- //0007
//Procedure   :  CheckforFileExistence                                                  //0007
//Description :  To check if the DSPFD* outfiles are created in QTEMP. If not,          //0007
//               Uwerror will have the value 'Y'.                                       //0007
//------------------------------------------------------------------------------------- //0007
dcl-proc CheckforFileExistence;                                                          //0007
                                                                                         //0007
   dcl-pi CheckforFileExistence ind;                                                     //0007
      tempfile_w char(10) value;                                                         //0007
   end-pi;                                                                               //0007
                                                                                         //0007
   clear command;                                                                        //0007
   clear uwerror;                                                                        //0007
                                                                                         //0007
   command = 'CHKOBJ OBJ(QTEMP/'+%trim(tempfile_w)+') OBJTYPE(*FILE)';                   //0007
   RunCommand(Command:Uwerror);                                                          //0007
   if Uwerror = 'Y';                                                                     //0007
      return *off;                                                                       //0007
   else;                                                                                 //0007
      return *on;                                                                        //0007
   endif;                                                                                //0007
                                                                                         //0007
end-proc;                                                                                //0007
