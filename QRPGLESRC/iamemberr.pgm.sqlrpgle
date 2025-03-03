**free
      //%METADATA                                                      *
      // %TEXT To populate member details in IAMEMBER file.            *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------- //
//Created By    : Programmers.io @ 2023                                                 //
//Created Date  : 2023/12/05                                                            //
//Developer     : Roshan Wankar                                                         //
//Description   : Program to Copy records from IDSPFDMBRL to IAMEMBER.                  //
//                                                                                      //
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
//01/02/24| 0001   | Santosh Kr | Refresh process is also processing Sources/Objects    //
//        |        |            | processed in the last refresh run (Task #562)         //
//08/02/24| 0002   | Vamsi      | If there are no changes and the refresh process runs, //
//        |        | Krishna2   | audit report is picking up the same result from the   //
//        |        |            | last refresh process (Task#575)                       //
//23/12/29| 0003   | Saikiran   | Changes to the Sql of INIT process to Exclude the     //
//        |        |            | source member details from IAMEMBER file (Task#500)   //
//24/03/11| 0004   | Suraj      | Insert only non blank member records in IAMEMBER file.//
//        |        |            | (Task#597)                                            //
//06/06/24| 0005   | Saumya     | Rename AIEXCTIMR to IAEXCTIMR [Task #262]             //
//04/07/24| 0006   | Akhil K.   | Renamed AIERRBND, AICERRLOG, AIDERRLOG and AISQLDIAGNO//
//        |        |            | STIC with IA*  [Task #261]                            //
//26/12/24| 0007   | S Karthick | [Task#761] Adding the logic for Capture Creation Time //
//        |        |            | in IAMEMBER file                                      //
//08/13/24| 0008   | Sasikumar R| Included the logic for parsing IFS member [Task #833] //
//------------------------------------------------------------------------------------- //
ctl-opt copyright('Copyright @ Programmers.io © 2023');
ctl-opt option(*NoDebugIO : *SrcStmt : *noUnRef);
ctl-opt dftactgrp(*no) bndDir('IAERRBND');                                               //0006

//------------------------------------------------------------------------------------- //
//Standalone Variables
//------------------------------------------------------------------------------------- //
dcl-s uppgm_name      char(10)     inz;
dcl-s uplib_name      char(10)     inz;
dcl-s upsrc_name      char(10)     inz;
dcl-s uwIFSloc        char(100)    inz;                                                  //0008

dcl-s upRowsFetched   uns(5);
dcl-s upnoOfRows      uns(3);
dcl-s uwindx          uns(3);

dcl-s uprowFound      ind          inz('0');

dcl-s uptimestamp     Timestamp;

dcl-c upTRUE          '1';
dcl-c upFALSE         '0';
dcl-c UP              'ABCDEFGHIFKLMNOPQRSTUVWXYZ';                                      //0008
dcl-c LO              'abcdefghijklmnopqrstuvwxyz';                                      //0008
dcl-c sq               '''';                                                             //0008

//------------------------------------------------------------------------------------- //
//Prototype Declaration
//------------------------------------------------------------------------------------- //
dcl-pr IAEXCTIMR extpgm('IAEXCTIMR');                                                    //0005
   *n Char(10) Const;
   *n Char(10);
   *n Char(10);
   *n Char(10) Const;
   *n Char(10);
   *n Char(10);
   *n Char(10);
   *n Char(100) Const;                                                                   //0008
   *n Char(10) Const;
   *n Timestamp;
   *n Char(6) Const;
end-pr;

//------------------------------------------------------------------------------------- //
//Data structure declaration
//------------------------------------------------------------------------------------- //
dcl-ds IaMetaInfo dtaara len(62);
   up_mode char(7) pos(1);
end-ds;

dcl-ds MbrDetail  qualified dim(99);
   Src_File    char(10);
   Src_lib     char(10);
   Src_MbrNam  char(10);
   Src_MbrTyp  char(10);
   Mbr_RefSts  Char(1);
end-ds;

dcl-ds dsMember qualified;
   Src_File    char(10);
   Src_lib     char(10);
   Src_MbrNam  char(10);
   Src_MbrTyp  char(10);
   Mbr_RefSts  Char(1);
end-ds;

dcl-ds ds_IfsDtl;                                                                        //0008
   Pathname char(100);                                                                   //0008
   Createts timestamp;                                                                   //0008
   Changets timestamp;                                                                   //0008
   Lastuts  timestamp;                                                                   //0008
   Daycount packed(5:0);                                                                 //0008
end-ds;                                                                                  //0008

dcl-ds uwIfsDtl qualified;                                                               //0008
   mbrnam  char(10);                                                                     //0008
   mbrtype char(10);                                                                     //0008
   mbrifsP char(100);                                                                    //0008
   mbrnmbn packed(5:0);                                                                  //0008
   mbrcdcn char(1);                                                                      //0008
   mbrcdat char(6);                                                                      //0008
   mbrchcn char(1);                                                                      //0008
   mbrchgd char(6);                                                                      //0008
   mbrchgt char(6);                                                                      //0008
   mbrudcn char(1);                                                                      //0008
   mbrudat char(6);                                                                      //0008
   mbrucnt packed(5:0);                                                                  //0008
end-ds;                                                                                  //0008

//------------------------------------------------------------------------------------- //
//Copybook Definitions
//------------------------------------------------------------------------------------- //
/copy 'QCPYSRC/iaderrlog.rpgleinc'

//------------------------------------------------------------------------------------- //0008
//Entry Parameter                                                                       //0008
//------------------------------------------------------------------------------------- //0008
dcl-pi IAMEMBERR  extpgm('IAMEMBERR');                                                   //0008
   uwxref char(10) options(*noPass);                                                     //0008
end-pi;                                                                                  //0008

//------------------------------------------------------------------------------------- //
//Set Options
//------------------------------------------------------------------------------------- //
exec sql
  set option Commit    = *None,
             Naming    = *Sys,
             DynUsrPrf = *User,
             CloSqlCsr = *EndMod;

//------------------------------------------------------------------------------------- //
//Cursor Definitions
//------------------------------------------------------------------------------------- //

//------------------------------------------------------------------------------------- //
//Main Functions
//------------------------------------------------------------------------------------- //
Eval-corr uDpsds = wkuDpsds;

//Insert process start time
uptimeStamp = %Timestamp();
CallP IAEXCTIMR('IAINIT' :udpsds.ProcNme : udpsds.Lib : '*PGM' :                         //0005
              //upsrc_name : uppgm_name : uplib_name : ' ' :                             //0008
                upsrc_name : uppgm_name : uplib_name : ' ' : ' ' :                       //0008
                uptimeStamp : 'INSERT');


//If Process is 'INIT' or 'REFRESH'
if up_mode = 'INIT';
   exsr Build_Member_list;
   exsr Build_Member_list_IFS;                                                           //0008
elseif up_mode = 'REFRESH';
   exsr Refresh_Member_list;
endif;

//Update process end time
UPTimeStamp = %Timestamp();
CallP IAEXCTIMR('IAINIT' :udpsds.ProcNme : udpsds.Lib : '*PGM' :                         //0005
              //upsrc_name : uppgm_name : uplib_name : ' ' :                             //0008
                upsrc_name : uppgm_name : uplib_name : ' ' : ' ' :                       //0008
                uptimeStamp : 'UPDATE');

*Inlr = *On;

/copy 'QCPYSRC/iacerrlog.rpgleinc'

//------------------------------------------------------------------------------------- //
//Build_Member_list Subroutine - Insert record into IAMEMBER file.
//------------------------------------------------------------------------------------- //
begsr Build_Member_list;

  //Insert record into IAMEMBER file.
  exec sql
     insert into iAMember(iASrcPfNam ,
                          iASrcLib   ,
                          iAMbrNam   ,
                          iAMbrType  ,
                          iAMbrTyp1  ,
                          iAMbrDsc   ,
                          iANoMbn    ,
                          iANRcd     ,
                          iANDtr     ,
                          iACCen     ,
                          iACDat     ,
                          iACTime    ,                                                   //0007
                          iAChgC     ,
                          iAChgD     ,
                          iAChgT     ,
                          iAUCen     ,
                          iAUDat     ,
                          iAUCnt     ,
                          iARefFlg  )
         (select mlfile  ,
                 mllib   ,
                 mlname  ,
                 mlseu2  ,
                 mlseu   ,
                 mlmtxt  ,
                 mlnomb  ,
                 mlnrcd  ,
                 mlndtr  ,
                 mlccen  ,
                 mlcdat  ,
                 mbctim  ,                                                               //0007
                 mlchgc  ,
                 mlchgd  ,
                 mlchgt  ,
                 mlucen  ,
                 mludat  ,
                 mlucnt  ,
                 ' '
          From idspfdmbrl a                                                              //0003
     Left Join idspfdmbr c                                                               //0007
            on a.Mlfile = c.Mbfile                                                       //0007
           and a.Mllib  = c.Mblib                                                        //0007
           and a.Mlname = c.Mbname                                                       //0007
         where not exists                                                                //0003
           (select * from iaxsrcpf b                                                     //0003
             where b.iasrcfile = a.mlfile                                                //0003
               and b.iasrclib  = a.mllib                                                 //0003
               and b.iasrcmbr  = a.mlname ) and a.mlname <> ' ');                        //0004

  if sqlCode < successCode;
     uDpsds.wkQuery_Name = 'Insert_iAMember';
     IaSqlDiagnostic(uDpsds);                                                            //0006
  endif;

endsr;

//------------------------------------------------------------------------------------- //0008
//Build_Member_list_IFS Subroutine - Insert the IFS source locations to IAMEMBER file.  //0008
//------------------------------------------------------------------------------------- //0008
begsr Build_Member_list_IFS;                                                             //0008

  //Check for the IFS locations mapped with the repo.                                   //0008
  exec sql                                                                               //0008
      Values (Select Count(*) From IAINPLIB Where                                        //0008
      upper(trim(XREFNAM)) = upper(trim(:uwxref)) and XIFSLOC <> ' '                     //0008
      ) Into :upRowsFetched;                                                             //0008

  if upRowsFetched > 0;                                                                  //0008
     clear upRowsFetched;                                                                //0008
     processIFSDirectory(uwXref);                                                        //0008
  endif;                                                                                 //0008

endsr;                                                                                   //0008

//------------------------------------------------------------------------------------- //
//Refresh_Member_list: Insert modified record into IAMEMBER file for refresh process.
//------------------------------------------------------------------------------------- //
begsr Refresh_Member_list ;

  //Declare cursor Refresh_Cursor
  exec sql
    declare Refresh_Cursor cursor for
      select iaSrcPf  ,
             iaMemLib,
             iaMemName,
             iaMemType,
             iaStatus
        from iaRefObjF
       where status in ('M', 'A') and iaMemName <> ' ' ;

  //Open the cursor Refresh_Cursor
  exec sql open Refresh_Cursor;
  if sqlCode = CSR_OPN_COD;
     exec sql close Refresh_Cursor;
     exec sql open  Refresh_Cursor;
  endif;

  if sqlCode < successCode;
     uDpsds.wkQuery_Name = 'Refresh_Cursor';
     IaSqlDiagnostic(uDpsds);                                                            //0006
  endif;

  //Get the number of elements
  upnoOfRows = %elem(MbrDetail);

  //Fetch records from Refresh cursor
  uprowFound = fetchRecordRefreshCursor();

  dow uprowFound;

     for uwindx = 1 to upRowsFetched;

        dsMember =  MbrDetail(uwindx);

        exec sql
           delete from iaMember
            where iASrcPfNam = :dsMember.Src_File
              and iASrcLib   = :dsMember.Src_Lib
              and iAMbrNam   = :dsMember.Src_MbrNam
              and iAMbrType  = :dsMember.Src_MbrTyp;

        if sqlCode < successCode;
           uDpsds.wkQuery_Name = 'Refresh_Cursor_Delete';
           IaSqlDiagnostic(uDpsds);                                                      //0006
        endif;

        exec sql
           insert into Iamember (iASrcPfNam ,
                                 iASrcLib   ,
                                 iAMbrNam   ,
                                 iAMbrType  ,
                                 iAMbrTyp1  ,
                                 iAMbrDsc   ,
                                 iANoMbn    ,
                                 iANRcd     ,
                                 iANDtr     ,
                                 iACCen     ,
                                 iACDat     ,
                                 iAChgC     ,
                                 iAChgD     ,
                                 iAChgT     ,
                                 iAUCen     ,
                                 iAUDat     ,
                                 iAUCnt     ,
                                 iARefFlg  )
               (Select mlfile  ,
                       mllib   ,
                       mlname  ,
                       mlseu2  ,
                       mlseu   ,
                       mlmtxt  ,
                       mlnomb  ,
                       mlnrcd  ,
                       mlndtr  ,
                       mlccen  ,
                       mlcdat  ,
                       mlchgc  ,
                       mlchgd  ,
                       mlchgt  ,
                       mlucen  ,
                       mludat  ,
                       mlucnt  ,
                      :dsMember.Mbr_RefSts
                from qtemp/iDspfdmbrl
               where upper(mlfile)= :dsMember.Src_File
                 and upper(mllib )= :dsMember.Src_Lib
                 and upper(mlname)= :dsMember.Src_MbrNam
                 and upper(mlseu2)= :dsMember.Src_Mbrtyp
                 and mlname <> ' ');                                             //0004
     endfor;

     //if fetched rows are less than the array elements then come out of the loop.
     if upRowsFetched < upnoOfRows ;
        leave ;
     endif ;

     //Fetch records from Refresh cursor
     uprowFound = fetchRecordRefreshCursor();
  enddo;

  //Close cursor
  exec sql close Refresh_Cursor;

endsr;

//------------------------------------------------------------------------------------- //
//Clear the table
//------------------------------------------------------------------------------------- //
begsr *Inzsr;

  //Retrieve value from Data Area
  in IaMetaInfo;

  if up_mode = 'INIT';

     exec sql delete from iAMember;
     if sqlCode < successCode;
        uDpsds.wkQuery_Name = 'Delete_iAMember';
        IaSqlDiagnostic(uDpsds);                                                         //0006
     endif;
                                                                                         //0001
  endif;

endsr;

//------------------------------------------------------------------------------------- //
//Procedure makeRefreshEntry: Write references of binding directory
//------------------------------------------------------------------------------------- //
dcl-proc fetchRecordRefreshCursor;

  dcl-pi fetchRecordRefreshCursor ind end-pi ;

  dcl-s  uprcdFound ind inz('0');
  dcl-s  wkRowNum like(UpRowsFetched) ;

  UpRowsFetched = *zeros;
  clear MbrDetail  ;

  exec sql
     fetch Refresh_Cursor for :upnoOfRows rows into :MbrDetail ;

  if sqlCode < successCode;
     uDpsds.wkQuery_Name = 'Fetch_Refresh';
     IaSqlDiagnostic(uDpsds);                                                            //0006
  endif;

  if sqlcode = successCode;
     exec sql get diagnostics
         :wkRowNum = ROW_COUNT;
          UpRowsFetched  = wkRowNum ;
  endif;

  if UpRowsFetched > 0;
     uprcdFound = upTRUE;
  elseif sqlcode < successCode ;
     uprcdFound = upFALSE;
  endif;

  return uprcdFound;

end-proc;
//------------------------------------------------------------------------------------- //0008
//Procedure to Process the source members in IFS Directory                              //0008
//------------------------------------------------------------------------------------- //0008
dcl-proc processIFSDirectory;                                                            //0008

   dcl-pi processIFSDirectory;                                                           //0008
      uwXref Char(10);                                                                   //0008
   end-pi;                                                                               //0008


   declareCursorsForProcessing(uwXref);                                                  //0008
   exec sql open fetchDataFromIAINPLIB;                                                  //0008
   if sqlCode = CSR_OPN_COD;                                                             //0008
      exec sql close fetchDataFromIAINPLIB;                                              //0008
      exec sql open  fetchDataFromIAINPLIB;                                              //0008
   endif;                                                                                //0008

   if sqlCode < successCode;                                                             //0008
      uDpsds.wkQuery_Name = 'OPN_CSR_fetchDataFromIAINPLIB';                             //0008
      IaSqlDiagnostic(uDpsds);                                                           //0008
   endif;                                                                                //0008

   if sqlCode = successCode;                                                             //0008
      exec sql                                                                           //0008
         fetch fetchDataFromIAINPLIB Into :uwIFSloc ;                                    //0008

      if sqlCode < successCode;                                                          //0008
         uDpsds.wkQuery_Name = 'fetchDataFromIAINPLIB';                                  //0008
         IaSqlDiagnostic(uDpsds);                                                        //0008
      endif;                                                                             //0008

     //Process For each IFS links for the repo library.                                 //0008
      dow sqlCode = successCode;                                                         //0008
         getlistOfMember();                                                              //0008
         exec sql                                                                        //0008
            fetch fetchDataFromIAINPLIB Into :uwIFSloc ;                                 //0008
      enddo;                                                                             //0008
   endif;                                                                                //0008

end-proc;                                                                                //0008
//------------------------------------------------------------------------------------- //0008
//Declare the cursors for processing the IFS Directories                                //0008
//------------------------------------------------------------------------------------- //0008
dcl-proc declareCursorsForProcessing;                                                    //0008

   dcl-pi declareCursorsForProcessing;                                                   //0008
      uwXRef Char(10);                                                                   //0008
   end-pi;                                                                               //0008

   dcl-s sqlString       varchar(1000) inz;                                              //0008

   sqlString = 'Select  XIFSLOC From IAINPLIB ' +                                        //0008
               'Where XREFNAM = ' + sq + %trim(uwxref) + sq +                            //0008
               ' And  XIFSLOC <> '+ sq + ' ' + sq;                                       //0008
   exec sql prepare sqlStmINP from :sqlString;                                           //0008
                                                                                         //0008
   if sqlCode = successCode;                                                             //0008
      exec sql declare fetchDataFromIAINPLIB cursor for sqlStmINP;                       //0008
   else;                                                                                 //0008
      return;                                                                            //0008
   endif;                                                                                //0008

   sqlString = 'Select cast(Path_name as char(100) ccsid 37) ,' +                        //0008
               'create_timestamp, ' +                                                    //0008
               'object_change_timestamp, last_used_timestamp, ' +                        //0008
               'days_used_count ' +                                                      //0008
               'From Table(QSYS2.IFS_Object_Statistics(?' +                              //0008
               ',' + sq + 'NO' + sq + ',' +                                              //0008
               sq + '*ALLSTMF' + sq + '))';                                              //0008
   exec sql prepare sqlStmt from :sqlString;                                             //0008

   if sqlCode = successCode;                                                             //0008
      exec sql declare fetchMemberDtlFromIFS cursor for sqlStmt;                         //0008
   else;                                                                                 //0008
      return;                                                                            //0008
   endif;                                                                                //0008

end-proc;                                                                                //0008
//------------------------------------------------------------------------------------- //0008
//Procedure to get the list of members from the IFS Directory                           //0008
//------------------------------------------------------------------------------------- //0008
dcl-proc getlistOfMember;                                                                //0008

  dcl-pi getlistOfMember;                                                                //0008
  end-pi;                                                                                //0008

  dcl-s wkIFSloc        varchar(100)  inz  ccsid(*utf8);                                 //0008

  dcl-s endpos          zoned(3:0)    inz;                                               //0008
  dcl-s strpos          zoned(3:0)    inz;                                               //0008
  dcl-s wkIdx           zoned(3:0)    inz;                                               //0008

  wkIFSloc = %trim(uwIFSloc);                                                            //0008

  exec sql open fetchMemberDtlFromIFS using :wkIFSLoc;                                   //0008
  if sqlCode = CSR_OPN_COD;                                                              //0008
     exec sql close fetchMemberDtlFromIFS;                                               //0008
     exec sql open  fetchMemberDtlFromIFS using :wkIFSLoc;                               //0008
  endif;                                                                                 //0008

  if sqlCode < successCode;                                                              //0008
     uDpsds.wkQuery_Name = 'OPN_CSR_fetchMemberDtlFromIFS';                              //0008
     IaSqlDiagnostic(uDpsds);                                                            //0008
  endif;                                                                                 //0008

  if sqlCode = successCode;                                                              //0008
     exec sql                                                                            //0008
        fetch fetchMemberDtlFromIFS Into :ds_IFSDtl;                                     //0008

     if sqlCode < successCode;                                                           //0008
        uDpsds.wkQuery_Name = 'fetchMemberDtlFromIFS';                                   //0008
        IaSqlDiagnostic(uDpsds);                                                         //0008
     endif;                                                                              //0008

    //Process For each IFS links for the repo library.                                  //0008
     dow sqlCode = successCode;                                                          //0008

        Pathname = %xlate(lo:up:Pathname);                                               //0008
        //Get the start position for extracting the member type.                        //0008
        endpos = 1;                                                                      //0008
        for wkidx = 1 to  (%len(%trim(Pathname))-endpos);                                //0008
           endpos = %scan('.':pathname:endpos);                                          //0008
           endpos+= 1;                                                                   //0008
        endfor;                                                                          //0008

        if endpos > *zeros;                                                              //0008
           uwIfsDtl.mbrtype = %subst(%trim(Pathname):endpos:                             //0008
                              (%len(%trim(Pathname))-(endpos-1)));                       //0008
        endif;                                                                           //0008

        if %trim(uwIfsDtl.mbrtype) ='RPGLE'                                              //0008
           or %trim(uwIfsDtl.mbrtype) ='RPG'                                             //0008
           or %trim(uwIfsDtl.mbrtype) ='SQLRPGLE'                                        //0008
           or %trim(uwIfsDtl.mbrtype) ='SQLRPG';                                         //0008

           //Get the end position for extracting the member name by                     //0008
           //checking the multiple '/' in the IFS location.                             //0008
           strpos = 1;                                                                   //0008
           for wkidx = 1 to  (%len(%trim(Pathname))-strpos);                             //0008
              strpos = %scan('/':pathname:strpos);                                       //0008
              strpos+= 1;                                                                //0008
           endfor;                                                                       //0008
           //extract the fields for IAMEMBER and insert it.                             //0008
           if strpos > *zeros and strpos < endpos;                                       //0008
              uwifsdtl.mbrnam  = %subst(%trim(Pathname):strpos:                          //0008
                                 ((endpos-1)-strpos));                                   //0008
              uwifsdtl.mbrifsP = %trim(Pathname);                                        //0008
              uwifsdtl.mbrnmbn = 1;                                                      //0008
              uwifsdtl.mbrcdcn = %subst(%char(%date(createts):*cymd0):1:1);              //0008
              uwifsdtl.mbrcdat = %char(%date(createts):*ymd0);                           //0008
              uwifsdtl.mbrchcn = %subst(%char(%date(changets):*cymd0):1:1);              //0008
              uwifsdtl.mbrchgd = %char(%date(changets):*ymd0);                           //0008
              uwifsdtl.mbrchgt = %char(%time(changets):*hms0);                           //0008
              uwifsdtl.mbrudcn = %subst(%char(%date(lastuts) :*cymd0):1:1);              //0008
              uwifsdtl.mbrudat = %char(%date(lastuts) :*ymd0);                           //0008
              uwifsdtl.mbrucnt = daycount;                                               //0008
           endif;                                                                        //0008

           populateMemberInIAMEMBER();                                                   //0008

        endif;                                                                           //0008
        exec sql                                                                         //0008
           fetch fetchMemberDtlFromIFS Into :ds_IFSDtl;                                  //0008
     enddo;                                                                              //0008
  endif;                                                                                 //0008

end-proc;                                                                                //0008
//------------------------------------------------------------------------------------- //0008
//Procedure to populate the IFS details into IAMEMBER.                                  //0008
//------------------------------------------------------------------------------------- //0008
dcl-proc populateMemberInIAMEMBER;                                                       //0008
                                                                                         //0008
   dcl-pi populateMemberInIAMEMBER;                                                      //0008
   end-pi;                                                                               //0008

   exec sql                                                                              //0008
      Insert Into IAMEMBER (IAMBRNAM, IAMBRTYPE, IAIFSLOC, IANOMBN ,                     //0008
                            IACCEN  , IACDAT   , IACHGC  , IACHGD  ,                     //0008
                            IACHGT  , IAUCEN  , IAUDAT   , IAUCNT)                       //0008
                     Values(:uwIfsDtl);                                                  //0008

end-proc;                                                                                //0008
