**free
      //%METADATA                                                      *
      // %TEXT Program to Copy records from IDSPOBJD file.             *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------- //
//Created By    : Programmers.io @ 2023                                                 //
//Created Date  : 2023/09/04                                                            //
//Developer     : Manasa Shanmugam                                                      //
//Description   : Program to Copy records from IDSPOBJD to IAOBJECT.                    //
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
//04/10/23|  0001  | BPAL       | Added a subroutine to copy records from IDSPOBJD to   //
//        |        |            | IAOBJECT for refresh process                          //
//05/12/23|  0002  | AC01       | Enhancement to Refresh process.Changes related to     //
//        |        |            | IAOBJECT file.                                        //
//01/02/24|  0003  | Santosh Kr | Refresh process is also processing Sources/Objects    //
//        |        |            | processed in the last refresh run (Task #562)         //
//08/02/24|  0004  | Vamsi      | If there are no changes and the refresh process runs, //
//        |        | Krishna2   | audit report is picking up the same result from the   //
//        |        |            | last refresh process (Task#575)                       //
//06/06/24|  0005  | Saumya     | Rename AIEXCTIMR to IAEXCTIMR [Task #262]             //
//05/07/24|  0006  | Akhil K.   | Renamed AIERRBND, AICERRLOG, AIDERRLOG and AISQLDIAGNO//
//        |        |            | STIC with IA*                                         //
//18092024|  0007  | Piyush     | Task#907 - Adding EXPORT Source Details in IAOBJECT   //
//        |        |            | File for Service Program Object Type                  //
//16/08/24|  0008  | Sabarish   | IFS Member Parsing Feature [Task 833]                 //
//------------------------------------------------------------------------------------- //
ctl-opt copyright('Copyright @ Programmers.io © 2023');
ctl-opt option(*NoDebugIO : *SrcStmt : *noUnRef);
ctl-opt dftactgrp(*no) bndDir('IAERRBND');                                               //0006

//------------------------------------------------------------------------------------- //
//Standalone Variables
//------------------------------------------------------------------------------------- //
dcl-s uptimestamp     Timestamp;
dcl-s uppgm_name      char(10)     inz;
dcl-s uplib_name      char(10)     inz;
dcl-s upsrc_name      char(10)     inz;
dcl-s upRowsFetched   uns(5);                                                            //0001
dcl-s upnoOfRows      uns(3);                                                            //0001
dcl-s uwindx          uns(3);                                                            //0001
dcl-s uprowFound      ind          inz('0');                                             //0001
dcl-c upTRUE          '1';                                                               //0001
dcl-c upFALSE         '0';                                                               //0001
dcl-s uwRowFound      ind          inz;                                                  //0007
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

//Retrieve Service Program Information API                                              //0007
dcl-pr RtvSrvPgmInfo Extpgm('QBNRSPGM');                                                 //0007
   SrvPgmInfo Likeds(udSrvPgmDS) Options(*varsize);                                      //0007
   SrvPgmInfL Int(10)   Const;                                                           //0007
   SrvPgmIFmt Char(8)   Const;                                                           //0007
   SrvPgmName Char(20)  Const;                                                           //0007
   SrvPgmErrC Likeds(ApiErrC)  Options(*varsize);                                        //0007
end-pr;                                                                                  //0007

//------------------------------------------------------------------------------------- //
//Data structure declaration
//------------------------------------------------------------------------------------- //
dcl-ds IaMetaInfo dtaara len(62);                                                        //0001
   up_mode char(7) pos(1);                                                               //0001
end-ds;                                                                                  //0001

dcl-ds objDetail  qualified dim(99);                                                     //0001
   Obj_Name char(10);                                                                    //0001
   Obj_lib  char(10);                                                                    //0001
   Obj_Typ  char(10);                                                                    //0001
   Obj_Sts  char(1) ;                                                                    //0002
end-ds;                                                                                  //0001

dcl-ds dsObject qualified;                                                               //0001
   Obj_Name char(10);                                                                    //0001
   Obj_lib  char(10);                                                                    //0001
   Obj_Typ  char(10);                                                                    //0001
   Obj_Sts  char(1) ;                                                                    //0002
end-ds;                                                                                  //0001

//Service Program Data Structure for QBNRSPGM                                           //0007
dcl-ds udSrvPgmDS qualified inz;                                                         //0007
   usExportSrcFile  Char(10)   Pos(62);                                                  //0007
   usExportSrcLib   Char(10)   Pos(72);                                                  //0007
   usExportSrcMbr   Char(10)   Pos(82);                                                  //0007
   usExportSrcSTMF  Char(5000) Pos(445);                                                 //0007
end-ds;                                                                                  //0007

//Error Data Structure for QBNRSPGM                                                     //0007
dcl-ds ApiErrC qualified inz;                                                            //0007
   BytProv  Int(10:0) Inz(%size(ApiErrC));                                               //0007
   BytAvail Int(10:0);                                                                   //0007
   MsgId    Char(7);                                                                     //0007
   Reserved Char(1);                                                                     //0007
   MsgData  Char(3000);                                                                  //0007
end-ds;                                                                                  //0007

//Data Structure array to hold Service Program Object and Lib Name                      //0007
dcl-ds udSrvPgmList qualified inz;                                                       //0007
   usObjPgmLb   Char(10);                                                                //0007
   usObjPgmNm   Char(10);                                                                //0007
end-ds;

//------------------------------------------------------------------------------------- //
//Copybook Definitions
//------------------------------------------------------------------------------------- //
/copy 'QCPYSRC/iaderrlog.rpgleinc'

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
                upsrc_name : uppgm_name : uplib_name : ' ' :
                //uptimeStamp : 'INSERT');                                               //0008
                ' ' : uptimeStamp : 'INSERT');                                           //0008


//If Process is 'INIT' or 'REFRESH'
if up_mode = 'INIT';                                                                     //0001
   exsr Build_Object_list;                                                               //0001
elseif up_mode = 'REFRESH';                                                              //0001
   exsr Refresh_Object_list;                                                             //0001
endif;                                                                                   //0001

//Retrieve Export Source Information of Service Program                                 //0007
RtvExportSrcInfo();                                                                      //0007

//Update process end time
UPTimeStamp = %Timestamp();
CallP IAEXCTIMR('IAINIT' :udpsds.ProcNme : udpsds.Lib : '*PGM' :                         //0005
                upsrc_name : uppgm_name : uplib_name : ' ' :
                //uptimeStamp : 'UPDATE');                                               //0008
                ' ' : uptimeStamp : 'UPDATE');                                           //0008

*Inlr = *On;

/copy 'QCPYSRC/iacerrlog.rpgleinc'

//------------------------------------------------------------------------------------- //
//Build_Object_list Subroutine - Insert record into IAOBJECT file.
//------------------------------------------------------------------------------------- //
begsr Build_Object_list;                                                                 //0001

  //Insert record into IAOBJECT file.
  exec sql
     insert into Iaobject (Ialibnam ,
                           Iaobjnam ,
                           Iaobjtyp ,
                           Iaobjatr ,
                           Iaobjsiz ,
                           Iatxtdes ,
                           Iaoccen  ,
                           Iaocdat  ,
                           Iaoctim  ,
                           Iaobow   ,
                           Iacpfl   ,
                           Iasrcfil ,
                           Iasrclib ,
                           Iasrcmbr ,
                           Iasrccen ,
                           Iasrcdat ,
                           Iasrctim ,
                           Iachgcen ,
                           Iachgdat ,
                           Iachgtim ,
                           Iaobjsys ,
                           Iacrtusr ,
                           Iacrtsys ,
                           Iaduupd  ,
                           Iaducen  ,
                           Iadudat  ,
                           Iaducnt  ,
                           Iadaspl  ,
                           Iadlasn  ,
                           Iadoadn  ,
                           Iadladn  ,
                           Crtuser  ,
                           Crtonts  )
         (Select Odlbnm  ,
                 Odobnm  ,
                 Odobtp  ,
                 Odobat  ,
                 Odobsz  ,
                 Odobtx  ,
                 Odccen  ,
                 Odcdat  ,
                 Odctim  ,
                 Odobow  ,
                 Odcpfl  ,
                 Odsrcf  ,
                 Odsrcl  ,
                 Odsrcm  ,
                 Odsrcc  ,
                 Odsrcd  ,
                 Odsrct  ,
                 Odlcen  ,
                 Odldat  ,
                 Odltim  ,
                 Odobsy  ,
                 Odcrtu  ,
                 Odcrts  ,
                 Oduupd  ,
                 Oducen  ,
                 Odudat  ,
                 Oducnt  ,
                 Odaspl  ,
                 Odlasn  ,
                 Odoadn  ,
                 Odladn  ,
                 USER    ,
                 Now()
          From iDspObjD );

  if sqlCode < successCode;
     uDpsds.wkQuery_Name = 'Insert_iAObject';
     IaSqlDiagnostic(uDpsds);                                                            //0006
  endif;

endsr;                                                                                   //0001

//------------------------------------------------------------------------------------- //
//Refresh_Object_list: Insert modified record into IAOBJECT file for refresh process.
//------------------------------------------------------------------------------------- //
begsr Refresh_Object_list ;                                                              //0001
                                                                                         //0001
  //Declare cursor Refresh_Cursor
  exec sql                                                                               //0001
    declare Refresh_Cursor cursor for                                                    //0001
      select iaObjName,                                                                  //0001
             iaObjLib,                                                                   //0001
             iaObjType,                                                                  //0001
             iaStaTus                                                                    //0002
        from iaRefObjF                                                                   //0001
       where status in ('M', 'A') and iaObjName <> ' ' ;                                 //0002
                                                                                         //0001
  //Open the cursor Refresh_Cursor
  exec sql open Refresh_Cursor;                                                          //0001
  if sqlCode = CSR_OPN_COD;                                                              //0001
     exec sql close Refresh_Cursor;                                                      //0001
     exec sql open  Refresh_Cursor;                                                      //0001
  endif;                                                                                 //0001

  if sqlCode < successCode;                                                              //0001
     uDpsds.wkQuery_Name = 'Refresh_Cursor';                                             //0001
     IaSqlDiagnostic(uDpsds);                                                            //0006
  endif;                                                                                 //0001
                                                                                         //0001
  //Get the number of elements
  upnoOfRows = %elem(objDetail);                                                         //0001

  //Fetch records from Refresh cursor
  uprowFound = fetchRecordRefreshCursor();                                               //0001

  dow uprowFound;                                                                        //0001

     for uwindx = 1 to upRowsFetched;                                                    //0001

        dsObject =  objDetail(uwindx);                                                   //0001

        exec sql                                                                         //0001
           delete from iaObject                                                          //0001
            where IaObjNam = :dsObject.Obj_Name                                          //0001
              and IaLibNam = :dsObject.Obj_Lib                                           //0001
              and IaObjTyp = :dsObject.Obj_Typ;                                          //0001
                                                                                         //0001
        if sqlCode < successCode;                                                        //0001
           uDpsds.wkQuery_Name = 'Refresh_Cursor_Delete';                                //0001
           IaSqlDiagnostic(uDpsds);                                                      //0006
        endif;                                                                           //0001
                                                                                         //0001
        exec sql                                                                         //0001
           insert into IaObject (Ialibnam ,                                              //0001
                                 Iaobjnam ,                                              //0001
                                 Iaobjtyp ,                                              //0001
                                 Iaobjatr ,                                              //0001
                                 Iaobjsiz ,                                              //0001
                                 Iatxtdes ,                                              //0001
                                 Iaoccen  ,                                              //0001
                                 Iaocdat  ,                                              //0001
                                 Iaoctim  ,                                              //0001
                                 Iaobow   ,                                              //0001
                                 Iacpfl   ,                                              //0001
                                 Iasrcfil ,                                              //0001
                                 Iasrclib ,                                              //0001
                                 Iasrcmbr ,                                              //0001
                                 Iasrccen ,                                              //0001
                                 Iasrcdat ,                                              //0001
                                 Iasrctim ,                                              //0001
                                 Iachgcen ,                                              //0001
                                 Iachgdat ,                                              //0001
                                 Iachgtim ,                                              //0001
                                 Iaobjsys ,                                              //0001
                                 Iacrtusr ,                                              //0001
                                 Iacrtsys ,                                              //0001
                                 Iaduupd  ,                                              //0001
                                 Iaducen  ,                                              //0001
                                 Iadudat  ,                                              //0001
                                 Iaducnt  ,                                              //0001
                                 Iadaspl  ,                                              //0001
                                 Iadlasn  ,                                              //0001
                                 Iadoadn  ,                                              //0001
                                 Iadladn  ,                                              //0001
                                 iarefresh,                                              //0001
                                 Crtuser  ,                                              //0001
                                 Crtonts  )                                              //0001
               (select Odlbnm  ,                                                         //0001
                       Odobnm  ,                                                         //0001
                       Odobtp  ,                                                         //0001
                       Odobat  ,                                                         //0001
                       Odobsz  ,                                                         //0001
                       Odobtx  ,                                                         //0001
                       Odccen  ,                                                         //0001
                       Odcdat  ,                                                         //0001
                       Odctim  ,                                                         //0001
                       Odobow  ,                                                         //0001
                       Odcpfl  ,                                                         //0001
                       Odsrcf  ,                                                         //0001
                       Odsrcl  ,                                                         //0001
                       Odsrcm  ,                                                         //0001
                       Odsrcc  ,                                                         //0001
                       Odsrcd  ,                                                         //0001
                       Odsrct  ,                                                         //0001
                       Odlcen  ,                                                         //0001
                       Odldat  ,                                                         //0001
                       Odltim  ,                                                         //0001
                       Odobsy  ,                                                         //0001
                       Odcrtu  ,                                                         //0001
                       Odcrts  ,                                                         //0001
                       Oduupd  ,                                                         //0001
                       Oducen  ,                                                         //0001
                       Odudat  ,                                                         //0001
                       Oducnt  ,                                                         //0001
                       Odaspl  ,                                                         //0001
                       Odlasn  ,                                                         //0001
                       Odoadn  ,                                                         //0001
                       Odladn  ,                                                         //0001
                       Trim(:dsObject.Obj_Sts),                                          //0002
                       USER    ,                                                         //0001
                       Now()                                                             //0001
                from qtemp/iDspObjD                                                      //0001
               where upper(odobnm)= :dsObject.Obj_Name                                   //0001
                 and upper(Odlbnm)= :dsObject.Obj_Lib                                    //0001
                 and upper(OdObTp)= :dsObject.Obj_Typ);                                  //0001
     endfor;                                                                             //0001

     //if fetched rows are less than the array elements then come out of the loop.
     if upRowsFetched < upnoOfRows ;                                                     //0001
        leave ;                                                                          //0001
     endif ;                                                                             //0001

     //Fetch records from Refresh cursor
     uprowFound = fetchRecordRefreshCursor();                                            //0001
  enddo;                                                                                 //0001

  //Close cursor
  exec sql close Refresh_Cursor;                                                         //0001

endsr;                                                                                   //0001
//------------------------------------------------------------------------------------- //
//Clear the table
//------------------------------------------------------------------------------------- //
begsr *Inzsr;

  //Retrieve value from Data Area
  in IaMetaInfo;                                                                         //0001
  if up_mode = 'INIT';                                                                   //0001
     exec sql delete from iAObject;

     if sqlCode < successCode;
        uDpsds.wkQuery_Name = 'Delete_iAObject';
        IaSqlDiagnostic(uDpsds);                                                         //0006
     endif;
  endif;                                                                                 //0001

endsr;
//------------------------------------------------------------------------------------- //
//Procedure makeRefreshEntry: Write references of binding directory
//------------------------------------------------------------------------------------- //
dcl-proc fetchRecordRefreshCursor;                                                       //0001
                                                                                         //0001
  dcl-pi fetchRecordRefreshCursor ind end-pi ;                                           //0001
                                                                                         //0001
  dcl-s  uprcdFound ind inz('0');                                                        //0001
  dcl-s  wkRowNum like(UpRowsFetched) ;                                                  //0001
                                                                                         //0001
  UpRowsFetched = *zeros;                                                                //0001
  clear objDetail  ;                                                                     //0001
                                                                                         //0001
  exec sql                                                                               //0001
     fetch Refresh_Cursor for :upnoOfRows rows into :objDetail ;                         //0001

  if sqlCode < successCode;                                                              //0001
     uDpsds.wkQuery_Name = 'Fetch_Refresh';                                              //0001
     IaSqlDiagnostic(uDpsds);                                                            //0006
  endif;                                                                                 //0001
  if sqlcode = successCode;                                                              //0001
     exec sql get diagnostics                                                            //0001
         :wkRowNum = ROW_COUNT;                                                          //0001
          UpRowsFetched  = wkRowNum ;                                                    //0001
  endif;                                                                                 //0001
                                                                                         //0001
  if UpRowsFetched > 0;                                                                  //0001
     uprcdFound = upTRUE;                                                                //0001
  elseif sqlcode < successCode ;                                                         //0001
     uprcdFound = upFALSE;                                                               //0001
  endif;                                                                                 //0001
                                                                                         //0001
  return uprcdFound;                                                                     //0001
                                                                                         //0001
end-proc;                                                                                //0001
//------------------------------------------------------------------------------------- //
//Procedure RtvExportSrcInfo: Retrieve Export Source Information of Service Program     //
//------------------------------------------------------------------------------------- //
dcl-proc RtvExportSrcInfo;                                                               //0007
                                                                                         //0007
  // Local variables                                                                     //0007
  Dcl-S lExportSrcSTMF Char(100);                                                        //0007
                                                                                         //0007
  //Cursor to Retrieve *SRVPGM Object from IAOBJECT File                                //0007
  Exec Sql                                                                               //0007
    Declare CursorSrvPgmObjList Cursor For                                               //0007
     Select iALibNam,                                                                    //0007
            iAObjNam                                                                     //0007
       From iAObject                                                                     //0007
      Where iAObjTyp = '*SRVPGM'                                                         //0007
        For Update of iAExpFil, iAExpLib, iAExpMbr, iAExpSTMF;                           //0007
                                                                                         //0007
  //Open Cursor for CursorSrvPgmObjList                                                 //0007
  Exec Sql Open CursorSrvPgmObjList;                                                     //0007
  If SqlCode = CSR_OPN_COD;                                                              //0007
     Exec Sql Close CursorSrvPgmObjList;                                                 //0007
     Exec Sql Open  CursorSrvPgmObjList;                                                 //0007
  EndIf;                                                                                 //0007
                                                                                         //0007
  //Fetch records from CursorSrvPgmObjList                                              //0007
  uwRowFound = FetchRecordCursorSrvPgmObjList();                                         //0007
                                                                                         //0007
  DoW uwRowFound;                                                                        //0007
     Clear udSrvPgmDS;                                                                   //0007
                                                                                         //0007
     //Retrieve Service Program Information API                                         //0007
     RtvSrvPgmInfo(udSrvPgmDS                                                            //0007
                   :%Len(udSrvPgmDS)                                                     //0007
                   :'SPGI0100'                                                           //0007
                   :udSrvPgmList.usObjPgmNm + udSrvPgmList.usObjPgmLb                    //0007
                   :ApiErrC);                                                            //0007
                                                                                         //0007
     lExportSrcSTMF = %Subst(udSrvPgmDS.usExportSrcSTMF:1:100);                          //0007
                                                                                         //0007
     //Update current row with Export Source Details of Service Program                 //0007
     Exec Sql                                                                            //0007
       Update iAObject                                                                   //0007
          Set iAExpFil  = :udSrvPgmDS.usExportSrcFile,                                   //0007
              iAExpLib  = :udSrvPgmDS.usExportSrcLib,                                    //0007
              iAExpMbr  = :udSrvPgmDS.usExportSrcMbr,                                    //0007
              iAExpSTMF = :lExportSrcSTMF                                                //0007
        Where Current Of CursorSrvPgmObjList;                                            //0007
                                                                                         //0007
     //Fetch next row                                                                   //0007
     uwRowFound = FetchRecordCursorSrvPgmObjList();                                      //0007
  EndDo;                                                                                 //0007
                                                                                         //0007
  //Close Cursor for CursorSrvPgmObjList                                                //0007
  Exec Sql Close CursorSrvPgmObjList;                                                    //0007
                                                                                         //0007
end-proc;                                                                                //0007
//------------------------------------------------------------------------------------- //
//Procedure FetchRecordCursorSrvPgmObjList : Fetch the Service Program Object List      //
//------------------------------------------------------------------------------------- //
dcl-proc FetchRecordCursorSrvPgmObjList;                                                 //0007
                                                                                         //0007
  dcl-pi *n ind end-pi;                                                                  //0007
                                                                                         //0007
  dcl-s uwRcdFound ind inz;                                                              //0007
                                                                                         //0007
  //Fetch service Program Object one by one                                             //0007
  Exec Sql                                                                               //0007
     Fetch CursorSrvPgmObjList into :udSrvPgmList;                                       //0007
                                                                                         //0007
  If SqlCode < SuccessCode;                                                              //0007
     uDpsds.wkQuery_Name = 'Fetch_CursorSrvPgmObjList';                                  //0007
     IaSqlDiagnostic(uDpsds);                                                            //0007
  EndIf;                                                                                 //0007
                                                                                         //0007
  //If the fetch was successful                                                         //0007
  If SqlCode = SuccessCode;                                                              //0007
     uwRcdFound = upTRUE;                                                                //0007
  //If there are no more records to fetch                                               //0007
  Else;                                                                                  //0007
     uwRcdFound = upFALSE;                                                               //0007
  EndIf;                                                                                 //0007
                                                                                         //0007
  Return uwRcdFound;                                                                     //0007
                                                                                         //0007
end-proc;                                                                                //0007
