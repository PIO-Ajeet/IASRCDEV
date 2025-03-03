**free
      //%METADATA                                                      *
      // %TEXT AI- Program to Load Store Procedure References          *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------- //
//Created By    : Programmers.io @ 2022                                                 //
//Creation Date : 2022/08/18                                                            //
//Developer     : Brajkishor Pal                                                        //
//Description   : This program captures stored procedure references corresponding to    //
//                the actual program in the reference file "iaallrefpf". It processes   //
//                each reference record from file iasrcintpf and maps members with the  //
//                actual name of an object.                                             //
//Procedure Log:                                                                        //
//------------------------------------------------------------------------------------- //
//Procedure Name           | Procedure Description                                      //
//-------------------------|----------------------------------------------------------- //
//initializeProcedure      | Initialize the variables                                   //
//insertStoredProcedureRef | For store procedure references records into iaallrefpf file//
//------------------------------------------------------------------------------------- //
//                                                                                      //
//Modification Log:                                                                     //
//------------------------------------------------------------------------------------- //
//Date    | Developer  | Case and Description                                           //
//--------|------------|--------------------------------------------------------------- //
//22/09/07| Sunny Jha  | Adapting new field of file AIEXCTIME which captures            //
//23/01/27| Manesh k   | Replaced IAMENUR with BLDMTADTA (MOD:0001)                     //
//23/02/08| Praveen Si | Substring the value from aiextnam if it contains '(' in it     //
//        |            | (MOD:0002)                                                     //
//23/02/07| Yogesh J   | Store The Ref. Object Type In IAALLREFPF1 File (MOD:0003)      //
//23/02/16|Pranav Joshi| Corrected the file name AIOBJMAP to IAOBJMAP.  (MOD:0004)      //
//23/11/02|Abhijit     | Need to change the usage filed to literal value (MOD:0005)     //
//        |Charhate    | instead of decimal.(Task#312)                                  //
//07/11/23| Abhijith   | Changes to include refresh functionality (Task#299 - Mod:0006) //
//        | Ravindran  |                                                                //
//27/11/23| Kunal P.   | Changes to include refresh functionality (Task#402 - Mod:0007) //
//23/10/13|Rituraj     | Changed the file name AIEXCTIME to IAEXCTIME (MOD:0008) [#248] //
//07/02/24|Vamsi       | Rename the file AILNGNMDTL from IALNGNMDTL (Mod:0009) [#246]   //
//03/07/24|Yogesh Chand| Changed the file name AISPROCREF to IASPROCREF (MOD:0010) [#300] //
//05/07/24|Akhil K.    | Renamed AIERRBND, AICERRLOG, AIDERRLOG and AISQLDIAGNOSTIC with  //
//        |            | IA* (Mod:0011) [#261]                                            //
//20/08/24|Sabarish    | IFS Member Parsing Feature (Mod:0012) [#833]                   //
//------------------------------------------------------------------------------------- //

ctl-opt copyright('Programmers.io Â© 2022');
ctl-opt option(*NoDebugIO : *SrcStmt : *noUnRef);
ctl-opt bndDir('IABNDDIR' : 'IAERRBND');                                                 //0011

//------------------------------------------------------------------------------------- //
//Standalone Variables
//------------------------------------------------------------------------------------- //
dcl-s isRecordExistInAILNGNMDTL    char(1)      inz;
dcl-s uppgm_name      char(10)     inz;
dcl-s uplib_name      char(10)     inz;
dcl-s upsrc_name      char(10)     inz;
dcl-s uptimestamp     timestamp;

dcl-s RowsFetched     uns(5);                                                            //0006
dcl-s noOfRows        uns(5);                                                            //0006
dcl-s uwindx          uns(5);                                                            //0006
dcl-s rowFound        ind          inz('0');                                             //0006
dcl-s RowsFetchedAddnl uns(5);                                                           //0006
dcl-s noOfRowsAddnl   uns(5);                                                            //0006
dcl-s uwindxAddnl     uns(5);                                                            //0006
dcl-s rowFoundAddnl   ind          inz('0');                                             //0006
dcl-c TRUE            '1';                                                               //0006
dcl-c FALSE           '0';                                                               //0006
dcl-s sqlString       varchar(1000) inz;                                                 //0006
dcl-c quote  const('''');                                                                //0006

//------------------------------------------------------------------------------------- //
//Constant Variables
//------------------------------------------------------------------------------------- //

//------------------------------------------------------------------------------------- //0006
//Datastructure Definitions
//------------------------------------------------------------------------------------- //0006
dcl-ds iaMetaInfo dtaara len(62);                                                        //0006
   runMode char(7) pos(1);                                                               //0006
end-ds;                                                                                  //0006
                                                                                         //0006
dcl-ds ds_lngNam extname('IAALLREFPF') qualified;                                        //0006
end-ds;                                                                                  //0006
                                                                                         //0006
dcl-ds dsLngNam qualified;                                                               //0006
   lnSpcObj char(128);                                                                   //0006
   lnSpcTxt like(ds_lngNam.iaOObjTxt);                                                   //0006
   lnSpcNam like(ds_lngNam.iaRObjNam);                                                   //0006
   lnSpcTyp like(ds_lngNam.iaRObjTyp);                                                   //0006
   lnExtNam like(ds_lngNam.iaRObjNam);                                                   //0006
   lnExtLib like(ds_lngNam.iaRObjLib);                                                   //0006
end-ds;                                                                                  //0006
                                                                                         //0006
dcl-ds lngNamDtl qualified dim(999);                                                     //0006
   lnSpcObj char(128);                                                                   //0006
   lnSpcTxt like(ds_lngNam.iaOObjTxt);                                                   //0006
   lnSpcNam like(ds_lngNam.iaRObjNam);                                                   //0006
   lnSpcTyp like(ds_lngNam.iaRObjTyp);                                                   //0006
   lnExtNam like(ds_lngNam.iaRObjNam);                                                   //0006
   lnExtLib like(ds_lngNam.iaRObjLib);                                                   //0006
end-ds;                                                                                  //0006
                                                                                         //0006
dcl-ds dsLngNamAddnl qualified;                                                          //0006
   lnObjLib like(ds_lngNam.iaOObjLib);                                                   //0006
   lnObjNam like(ds_lngNam.iaOObjNam);                                                   //0006
   lnObjTyp like(ds_lngNam.iaOObjTyp);                                                   //0006
   lnRObjLb like(ds_lngNam.iaRObjLib);                                                   //0006
   lnRUsage like(ds_lngNam.iaRUsages);                                                   //0006
end-ds;                                                                                  //0006
                                                                                         //0006
dcl-ds lngNamAddnlDtl qualified dim(999);                                                //0006
   lnObjLib like(ds_lngNam.iaOObjLib);                                                   //0006
   lnObjNam like(ds_lngNam.iaOObjNam);                                                   //0006
   lnObjTyp like(ds_lngNam.iaOObjTyp);                                                   //0006
   lnRObjLb like(ds_lngNam.iaRObjLib);                                                   //0006
   lnRUsage like(ds_lngNam.iaRUsages);                                                   //0006
end-ds;                                                                                  //0006

//------------------------------------------------------------------------------------- //
//Procedure Definitions
//------------------------------------------------------------------------------------- //
dcl-pr iaexctimr extpgm('IAEXCTIMR');                                                    //0008
   *n char(10) const;
   *n char(10);
   *n char(10);
   *n char(10) const;
   *n Char(10);
   *n char(10);
   *n char(10);
   *n char(10) const;
   *n timestamp;
   *n char(6) const;
end-pr;

//------------------------------------------------------------------------------------- //
//Copybook Definitions
//------------------------------------------------------------------------------------- //
/copy 'QMODSRC/iasrv01pr.rpgleinc'
/copy 'QCPYSRC/iaderrlog.rpgleinc'

//------------------------------------------------------------------------------------- //
//*Entry Parameters
//------------------------------------------------------------------------------------- //
dcl-pi iasprocref extpgm('IASPROCREF');                                                  //0010
    upCrossRef  char(10);
end-pi;

//------------------------------------------------------------------------------------- //
//Main Functions
//------------------------------------------------------------------------------------- //
exec sql
   set option commit = *none,
              naming = *sys,
              usrprf = *user,
              dynusrprf = *user,
              closqlcsr = *endmod;

//Initialize procedure
in iaMetaInfo;

//Initialize procedure
initializeProcedure();

//Insert stored procedure references into iaallrefpf file
//insertStoredProcedureReferences();                                                     //0006

//Get long Name details
getLongNameDtls();

*inlr = *on;
/copy 'QCPYSRC/iacerrlog.rpgleinc'

//------------------------------------------------------------------------------------- //
//Procedure InitializeProcedure
//------------------------------------------------------------------------------------- //
dcl-proc initializeProcedure ;

  eval-corr udPsds = wkudPsds;

  upTimeStamp = %timestamp();
  callp iaexctimr('BLDMTADTA' :udpsds.procnme : udpsds.lib : '*PGM' :                    //0008
                  upsrc_name : uppgm_name : uplib_name : ' ' :
                  //0012 uptimeStamp : 'INSERT');
                  ' ' : uptimeStamp : 'INSERT');                                         //0012

  exec sql
     select 'Y' into :isRecordExistInAILNGNMDTL
        from ialngnmdtl limit 1;                                                         //0009

  if isRecordExistInAILNGNMDTL  <> 'Y';
     upTimeStamp = %timestamp();
     callp iaexctimr('BLDMTADTA':udpsds.procnme : udpsds.lib : '*PGM' :                  //0008
                     upsrc_name : uppgm_name : uplib_name : ' ' :
                     //0012 uptimeStamp : 'UPDATE');
                     ' ' : uptimeStamp : 'UPDATE');                                      //0012
     *inlr = *on;
     return;
  endif;

end-proc;

//--------------------------------------------------------------------------------------//0006
//getLongNameDtls : Get the Long Name details for Store Procedure                       //0006
//------------------------------------------------------------------------------------- //0006
dcl-proc getLongNameDtls;                                                                //0006
                                                                                         //0006
  sqlString = 'Select aispcnam, concat(' + quote +                                       //0006
               'SQL PROCEDURE' + quote + ' , trim(aispcnam)), ' +                        //0006
               'case when locate(' + quote + '(' + quote + ', aiextnam) <> 0 ' +         //0006
               'then substring(aispcnam,1,locate(' + quote + '(' + quote +               //0006
               ', aiextnam )-1) else substr(aiextnam,1,10) end, ' +                      //0006
               'airtntyp, aiextnam, aiextlib from ialngnmdtl t01';                       //0006 0009
                                                                                         //0006
  if runMode = 'REFRESH';                                                                //0006
     sqlString = %trim(sqlString) +                                                      //0006
                ' join iarefobjf t02 on t02.iaMemName = t01.aiSrcMbr and ' +             //0006
                ' t02.iaMemLib = t01.aiSrcLib and t02.iaSrcpf = t01.aiSrcFil' +          //0006
                ' where t02.iaStatus in (' + quote + 'M' + quote + ',' + quote +         //0006
                'A' + quote + ')';                                                       //0006
  endIf;                                                                                 //0006
                                                                                         //0006
  //Prepare sql statement for cursor                                                    //0006
  exec sql                                                                               //0006
     prepare sqlStatement from :sqlString;                                               //0006
                                                                                         //0006
  //Declare cursor                                                                      //0006
  exec sql                                                                               //0006
     declare ialongNameDtl cursor for sqlStatement;                                      //0006
                                                                                         //0006
  //Open cursor                                                                         //0006
  exec sql open ialongNameDtl;                                                           //0006
  if sqlCode = CSR_OPN_COD;                                                              //0006
     exec sql close ialongNameDtl;                                                       //0006
     exec sql open  ialongNameDtl;                                                       //0006
  endif;                                                                                 //0006
                                                                                         //0006
  if sqlCode < successCode;                                                              //0006
     uDpsds.wkQuery_Name = 'Open_CSR_IALongNameDtl';                                     //0006
     IaSqlDiagnostic(uDpsds);                                                            //0006 0011
  endif;                                                                                 //0006
                                                                                         //0006
  if sqlCode = successCode;                                                              //0006
                                                                                         //0006
     //Get the number of elements                                                       //0006
     noOfRows = %elem(lngNamDtl);                                                        //0006
     rowFound = fetchRecordDsLngNamDtlcursor();                                          //0006
                                                                                         //0006
     dow rowFound;                                                                       //0006
                                                                                         //0006
        for uwindx = 1 to RowsFetched;                                                   //0006
                                                                                         //0006
           dslngNam = lngNamDtl(uwindx);                                                 //0006
                                                                                         //0006
           if runMode = 'REFRESH';                                                       //0006
              deleteReferences();                                                        //0006
           endIf;                                                                        //0006
                                                                                         //0006
           getLongNameAddnlDtls();                                                       //0006
                                                                                         //0006
        endfor;                                                                          //0006
                                                                                         //0006
        //if fetched rows are less than the array elements then come out of the loop    //0006
        if RowsFetched < noOfRows ;                                                      //0006
           leave ;                                                                       //0006
        endif ;                                                                          //0006
                                                                                         //0006
        //Fetch next record                                                             //0006
        rowFound = fetchRecordDsLngNamDtlcursor();                                       //0006
                                                                                         //0006
     enddo;                                                                              //0006
                                                                                         //0006
     exec sql                                                                            //0006
        close ialongNameDtl;                                                             //0006
                                                                                         //0006
  endIf;                                                                                 //0006
                                                                                         //0006
  uptimestamp = %timestamp();                                                            //0006
  callp iaexctimr('BLDMTADTA' :udpsds.procnme : udpsds.lib : '*PGM' :                    //0006 0008
                  upsrc_name : uppgm_name : uplib_name : ' ' :                           //0006
          //0012  uptimeStamp : 'UPDATE');                                               //0006
                  ' ' :uptimeStamp : 'UPDATE');                                          //0006
                                                                                         //0006
end-proc;                                                                                //0006
                                                                                         //0006
//------------------------------------------------------------------------------------- //0006
//Procedure fetchRecordDsLngNamDtlcursor: Write SP details into lngNamDtl Array.        //0006
//------------------------------------------------------------------------------------- //0006
dcl-proc fetchRecordDsLngNamDtlcursor;                                                   //0006
                                                                                         //0006
  dcl-pi fetchRecordDsLngNamDtlcursor ind end-pi ;                                       //0006
                                                                                         //0006
  dcl-s  rcdFound ind inz('0');                                                          //0006
  dcl-s  wkRowNum like(RowsFetched) ;                                                    //0006
                                                                                         //0006
  RowsFetched = *zeros;                                                                  //0006
  clear lngNamDtl;                                                                       //0006
                                                                                         //0006
  exec sql                                                                               //0006
     fetch ialongNameDtl for :noOfRows rows into :lngNamDtl;                             //0006
                                                                                         //0006
  if sqlcode = successCode;                                                              //0006
     exec sql get diagnostics                                                            //0006
         :wkRowNum = ROW_COUNT;                                                          //0006
          RowsFetched  = wkRowNum ;                                                      //0006
  endif;                                                                                 //0006
                                                                                         //0006
  if RowsFetched > 0;                                                                    //0006
     rcdFound = TRUE;                                                                    //0006
  elseif sqlcode < successCode ;                                                         //0006
     rcdFound = FALSE;                                                                   //0006
  endif;                                                                                 //0006
                                                                                         //0006
  return rcdFound;                                                                       //0006
                                                                                         //0006
end-proc;                                                                                //0006
                                                                                         //0006
//------------------------------------------------------------------------------------- //0006
//getLongNameAddnlDtls : Get the Additional details for Store Procedure                 //0006
//------------------------------------------------------------------------------------- //0006
dcl-proc getLongNameAddnlDtls;                                                           //0006
                                                                                         //0006
  exec sql                                                                               //0006
     declare ialongNameAddnlDtl cursor for                                               //0006
     Select distinct                                                                     //0006
            f1.iambrlib,                                                                 //0006
            f2.Object_Name,                                                              //0006
            f2.Object_Type,                                                              //0006
            f1.iarefolib,                                                                //0006
            f1.iarefousg                                                                 //0006
       from iasrcintpf f1                                                                //0006
       join iaobjmap   f2                                                                //0006
         on f2.iambrlib   = f1.iambrlib                                                  //0006
        and f2.iambrsrcf  = f1.iambrsrc                                                  //0006
        and f2.iambrnam   = f1.iambrnam                                                  //0006
        and f2.iambrtyp   = f1.iambrtyp                                                  //0006
      where f1.iaRefObj   = :dsLngNam.lnSpcObj                                           //0006
        and f1.iaRefOTyp in ('*MODULE', '*PGM');                                         //0006
                                                                                         //0006
  //Open cursor                                                                         //0006
  exec sql open ialongNameAddnlDtl;                                                      //0006
  if sqlCode = CSR_OPN_COD;                                                              //0006
     exec sql close ialongNameAddnlDtl;                                                  //0006
     exec sql open  ialongNameAddnlDtl;                                                  //0006
  endif;                                                                                 //0006
                                                                                         //0006
  if sqlCode < successCode;                                                              //0006
     uDpsds.wkQuery_Name = 'Open_CSR_IALongNameAddnlDtl';                                //0006
     IaSqlDiagnostic(uDpsds);                                                            //0006 0011
  endif;                                                                                 //0006
                                                                                         //0006
  if sqlCode = successCode;                                                              //0006
                                                                                         //0006
     //Get the number of elements                                                       //0006
     noOfRowsAddnl = %elem(lngNamAddnlDtl);                                              //0006
     rowFoundAddnl = fetchRecordDsLngNamAddnlDtlcursor();                                //0006
                                                                                         //0006
     dow rowFoundAddnl;                                                                  //0006
                                                                                         //0006
        for uwindxAddnl = 1 to RowsFetchedAddnl;                                         //0006
                                                                                         //0006
           dslngNamAddnl = lngNamAddnlDtl(uwindxAddnl);                                  //0006
           insertLongNameDtl();                                                          //0006
                                                                                         //0006
        endfor;                                                                          //0006
                                                                                         //0006
        //if fetched rows are less than the array elements then come out of the loop    //0006
        if RowsFetchedAddnl < noOfRowsAddnl ;                                            //0006
           leave ;                                                                       //0006
        endif ;                                                                          //0006
                                                                                         //0006
        //Fetch next record                                                             //0006
        rowFound = fetchRecordDsLngNamAddnlDtlcursor();                                  //0006
                                                                                         //0006
     enddo;                                                                              //0006
                                                                                         //0006
     exec sql                                                                            //0006
        close ialongNameAddnlDtl;                                                        //0006
                                                                                         //0006
  endIf;                                                                                 //0006
                                                                                         //0006
end-proc;                                                                                //0006
                                                                                         //0006
//------------------------------------------------------------------------------------- //0006
//Procedure fetchRecordDsLngNamAddnlDtlcursor: Write SP details into lngNamAddnlDtl Arr //0006
//------------------------------------------------------------------------------------- //0006
dcl-proc fetchRecordDsLngNamAddnlDtlcursor;                                              //0006
                                                                                         //0006
  dcl-pi fetchRecordDsLngNamAddnlDtlcursor ind end-pi ;                                  //0006
                                                                                         //0006
  dcl-s  rcdFound ind inz('0');                                                          //0006
  dcl-s  wkRowNum like(RowsFetched) ;                                                    //0006
                                                                                         //0006
  RowsFetchedAddnl = *zeros;                                                             //0006
  clear lngNamAddnlDtl;                                                                  //0006
                                                                                         //0006
  exec sql                                                                               //0006
     fetch ialongNameAddnlDtl for :noOfRowsAddnl rows into :lngNamAddnlDtl;              //0006
                                                                                         //0006
  if sqlcode = successCode;                                                              //0006
     exec sql get diagnostics                                                            //0006
          :wkRowNum = ROW_COUNT;                                                         //0006
     RowsFetchedAddnl = wkRowNum ;                                                       //0006
  endif;                                                                                 //0006
                                                                                         //0006
  if RowsFetchedAddnl > 0;                                                               //0006
     rcdFound = TRUE;                                                                    //0006
  elseif sqlcode < successCode ;                                                         //0006
     rcdFound = FALSE;                                                                   //0006
  endif;                                                                                 //0006
                                                                                         //0006
  return rcdFound;                                                                       //0006
                                                                                         //0006
end-proc;                                                                                //0006
                                                                                         //0006
//------------------------------------------------------------------------------------- //0006
//insertLongNameDtl: Insert the Long Name details for Store Procedure                   //0006
//------------------------------------------------------------------------------------- //0006
dcl-proc insertLongNameDtl;                                                              //0006
                                                                                         //0006
  exec sql                                                                               //0006
     insert into iAAllRefPf (library_name,                                               //0006
                            object_name,                                                 //0006
                            object_type,                                                 //0006
                            object_text,                                                 //0006
                            referenced_obj,                                              //0006
                            referenced_objtyp,                                           //0006
                            referenced_objlib,                                           //0006
                            referenced_ObjUsg,                                           //0006
                            crt_pgm_name,                                                //0006
                            crt_usr_name)                                                //0006
                   values  (:dsLngNamAddnl.lnObjLib,                                     //0006
                            :dsLngNamAddnl.lnObjNam,                                     //0006
                            :dsLngNamAddnl.lnObjTyp,                                     //0006
                            :dsLngNam.lnSpcTxt,                                          //0006
                            :dsLngNam.lnSpcNam,                                          //0006
                            :dsLngNam.lnSpcTyp,                                          //0006
                            :dsLngNamAddnl.lnRObjLb,                                     //0006
                            :dsLngNamAddnl.lnRUsage,                                     //0006
                            trim(:udpsds.srcmbr),                                        //0006
                            trim(:udpsds.user));                                         //0006
                                                                                         //0006
  if sqlCode < successCode;                                                              //0006
     udpsds.wkquery_name = 'Insert_1_IAALLREFPF';                                        //0006
     IaSqlDiagnostic(uDpsds);                                                            //0006 0011
  endif;                                                                                 //0006
                                                                                         //0006
end-proc;                                                                                //0006
                                                                                         //0006
//------------------------------------------------------------------------------------- //0006
//deleteReferences: Delete the Long Name details for Store Procedure                    //0006
//------------------------------------------------------------------------------------- //0006
dcl-proc deleteReferences;                                                               //0006
                                                                                         //0006
  exec sql                                                                               //0006
     delete from iaAllRefPf t01                                                          //0006
           where t01.iaRObjNam = :dsLngNam.lnExtNam                                      //0006
             and t01.iaRObjTyp = :dsLngNam.lnSpcTyp                                      //0006
             and t01.iaRObjLib = :dsLngNam.lnExtLib                                      //0006
             and t01.iaCrtPgmn = :udpsds.procnme;                                        //0007
                                                                                         //0006
  if sqlCode < successCode;                                                              //0006
     udpsds.wkquery_name = 'Delete_1_IAALLREFPF';                                        //0006
     IaSqlDiagnostic(uDpsds);                                                            //0006 0011
  endif;                                                                                 //0006
                                                                                         //0006
end-proc;                                                                                //0006
