**free
      //%METADATA                                                      *
      // %TEXT To load binding references                              *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------- //
//Created By    : Programmers.io @ 2022                                                 //
//Creation Date : 2022/02/04                                                            //
//Developer     : Bhoomish Atha                                                         //
//Description   : Create References for Binding directory                               //
//                                                                                      //
//PROCEDURE LOG:                                                                        //
//------------------------------------------------------------------------------------- //
//Procedure Name           | Procedure Description                                      //
//-------------------------|----------------------------------------------------------- //
//No Procedure             |                                                            //
//------------------------------------------------------------------------------------- //
//                                                                                      //
//Modification Log:                                                                     //
//------------------------------------------------------------------------------------- //
//Date    | Mod_ID | Developer  | Case and Description                                  //
//--------|--------|------------|------------------------------------------------------ //
//08/11/23|0001    |BPAL        |Refresh Program changes (Task#365)                     //
//27/11/23|0002    |Kunal P.    |Refresh Program changes (Task#402)                     //
//13/12/23|0003    |Kunal P.    |Refresh Program changes (Task#438)                     //
//10/01/24|0004    |Himanshu    |Refresh enhancement-replaced IDSPOBJD with IAOBJECT    //
//        |        |Gahtori     |Task#-441.                                             //
//06/06/24|0005    |Saumya      |Rename program AIEXCTIMR to IAEXCTIMR [Task #262]      //
//05/10/23|        |Vipul       |Rename program AIBNDDREFR to IABNDDREFR [Task #271]    //
//04/07/24|0006    |Akhil K.    |Rename AIBNDDIR, AICERRLOG, AIDERRLOG and              //
//        |        |            |AISQLDIAGNOSTIC with IA*                               //
// 13/08/24|0007    |Sabarish    |IFS Member Parsing                                     //
//------------------------------------------------------------------------------------- //
ctl-opt copyright('Programmers.io Â© 2022');
ctl-opt option(*NoDebugIO : *SrcStmt : *noUnRef);
ctl-opt bndDir('IABNDDIR' : 'IAERRBND');                                                 //0006

//------------------------------------------------------------------------------------- //
//Standalone Variables
//------------------------------------------------------------------------------------- //
dcl-s command         char(1000)   inz;
dcl-s uwerror         char(1)      inz;
dcl-s uwexist         char(1)      inz;
dcl-s uppgm_name      char(10)     inz;
dcl-s uplib_name      char(10)     inz;
dcl-s upsrc_name      char(10)     inz;
dcl-s wkSqlText       char(1000)   inz ;                                                 //0003

dcl-s RowsFetched     uns(5);
dcl-s noOfRows        uns(3);
dcl-s uwindx          uns(3);

dcl-s rowFound        ind          inz('0');
dcl-s DupRecord       ind          inz('0');                                             //0003

dcl-s uptimestamp     Timestamp;
//------------------------------------------------------------------------------------- //
//Constant Variables
//------------------------------------------------------------------------------------- //
dcl-c TRUE            '1';
dcl-c FALSE           '0';

//------------------------------------------------------------------------------------- //
//Datastructure Definitions
//------------------------------------------------------------------------------------- //
dcl-ds bnddirdtls qualified dim(99);
   library  char(10);
   bnddir   char(10);
end-ds;

dcl-ds w_GetIaAllrefpfDS qualified dim(99);                                              //0003
   IaoobjLib   char(10);                                                                 //0003
   IaoobjNam   char(10);                                                                 //0003
   IaoobjTyp   char(10);                                                                 //0003
   IaoobjAtr   char(10);                                                                 //0003
   IaoobjTxt   char(50);                                                                 //0003
   IarobjNam   char(11);                                                                 //0003
   IarobjLib   char(11);                                                                 //0003
end-ds;                                                                                  //0003

dcl-ds w_CheckIaAllrefpfDS;                                                              //0003
   w_checkIaAllrefpfDS_IaoobjLib   char(10);                                             //0003
   w_checkIaAllrefpfDS_IaoobjNam   char(10);                                             //0003
   w_checkIaAllrefpfDS_IaoobjTyp   char(10);                                             //0003
   w_checkIaAllrefpfDS_IaoobjAtr   char(10);                                             //0003
   w_checkIaAllrefpfDS_IaoobjTxt   char(50);                                             //0003
   w_checkIaAllrefpfDS_IarobjNam   char(11);                                             //0003
   w_checkIaAllrefpfDS_IarobjLib   char(11);                                             //0003
end-ds;                                                                                  //0003

//------------------------------------------------------------------------------------- //
//Procedure Definitions                                                                 //
//------------------------------------------------------------------------------------- //
dcl-pi crtbndref extpgm('CRTBNDREF');
   uref char(10);
end-pi;

dcl-pr IAEXCTIMR extpgm('IAEXCTIMR');                                                    //0005
   *n Char(10) Const;
   *n Char(10);
   *n Char(10);
   *n Char(10) Const;
   *n Char(10);
   *n Char(10);
   *n Char(10);
   *n Char(100) Const;                                                                   //0007
   *n Char(10) Const;
   *n Timestamp;
   *n Char(6) Const;
end-pr;

dcl-ds IaMetaInfo dtaara len(62);                                                        //0001
   runmode char(7) pos(1);                                                               //0001
end-ds;                                                                                  //0001
//------------------------------------------------------------------------------------- //
//Copybook Definitions
//------------------------------------------------------------------------------------- //
/copy 'QMODSRC/iasrv01pr.rpgleinc'
/copy 'QCPYSRC/iaderrlog.rpgleinc'

//------------------------------------------------------------------------------------- //
//Set optons
//------------------------------------------------------------------------------------- //
exec sql
   set option commit = *none,
              naming = *sys,
              usrprf = *user,
              dynusrprf = *user,
              closqlcsr = *endmod;

In IaMetaInfo;                                                                           //0001
//------------------------------------------------------------------------------------- //
//Cursor Definitions
//------------------------------------------------------------------------------------- //
exec sql                                                                                 //0001
    declare bnddir cursor for                                                            //0001
     select T1.IaLibNam, T1.IaObjNam                                                     //0001
       from IaObject T1                                                                  //0001
      where T1.IaObjTyp = '*BNDDIR';                                                     //0003
                                                                                         //0001
//------------------------------------------------------------------------------------- //
//Main Functions
//------------------------------------------------------------------------------------- //
Eval-corr uDpsds = wkuDpsds;

//Insert process start time
uptimeStamp = %Timestamp();
CallP IAEXCTIMR('BLDMTADTA' :udpsds.ProcNme : udpsds.Lib : '*PGM' :                      //0005
              // 0007 upsrc_name : uppgm_name : uplib_name : ' ' :
                upsrc_name : uppgm_name : uplib_name : ' ' : ' ' :                       //0007
                uptimeStamp : 'INSERT');

//Using IAOBJECT file                                                                   //0004
exec sql
   select 'Y' into :uwexist from iAObject                                                //0004
      where iAObjTyp ='*BNDDIR' limit 1;                                                 //0004
if uwexist <> 'Y';
   UPTimeStamp = %Timestamp();
   CallP IAEXCTIMR('BLDMTADTA' :udpsds.ProcNme : udpsds.Lib : '*PGM' :                   //0005
                 // 0007 upsrc_name : uppgm_name : uplib_name : ' ' :
                    upsrc_name : uppgm_name : uplib_name : ' ' : ' ' :                   //0007
                    uptimeStamp : 'UPDATE');
   *inlr = *on;
   return;
endif;

//Open cursor
exec sql open bnddir;
if sqlCode = CSR_OPN_COD;
   exec sql close bnddir;
   exec sql open  bnddir;
endif;

if sqlCode < successCode;
   uDpsds.wkQuery_Name = 'Open_Bnddir';
   IaSqlDiagnostic(uDpsds);                                                              //0006
endif;

//Get the number of elements
noOfRows = %elem(bnddirdtls);

//Fetch records from BNDDIR cursor
rowFound = fetchRecordBnddirCursor();

dow rowFound;

   for uwindx = 1 to RowsFetched;
      clear command;
      command = 'DSPBNDDIR BNDDIR('+ %TRIM(bnddirdtls(uwindx).library) +'/'+
                %TRIM(bnddirdtls(uwindx).bnddir) +')' +
                ' OUTPUT(*OUTFILE) OUTFILE(QTEMP/BNDDIRDTL)' +
                ' OUTMBR(*FIRST *ADD)';
      RunCommand(Command:Uwerror);
   endfor;

   //if fetched rows are less than the array elements then come out of the loop.
   if RowsFetched < noOfRows ;
      leave ;
   endif ;

   //Fetch records from BNDDIR cursor
   rowFound = fetchRecordBnddirCursor();

enddo;

//Close cursor
exec sql close bnddir;

//Delete references of a binding directory only for refresh                             //0001
if runmode = 'REFRESH';                                                                  //0001
   DltBndDirEntry() ;                                                                    //0001
endif;                                                                                   //0001

//Cpature references of a binding directory
makeBndDirEntry();

//Cpature binding directory as a referenced object
mapbnddir();

//Update process end time
UPTimeStamp = %Timestamp();
CallP IAEXCTIMR('BLDMTADTA' :udpsds.ProcNme : udpsds.Lib : '*PGM' :                      //0005
   // 0007 upsrc_name : uppgm_name : uplib_name : ' ' : uptimeStamp : 'UPDATE');
   upsrc_name : uppgm_name : uplib_name : ' ' : ' ' : uptimeStamp : 'UPDATE');           //0007

*inlr = *on;

/copy 'QCPYSRC/iacerrlog.rpgleinc'

//------------------------------------------------------------------------------------- //
//Procedure makeBndDirEntry: Write references of binding directory
//------------------------------------------------------------------------------------- //
dcl-proc makeBndDirEntry;

  select;                                                                                //0003
    when runmode = 'REFRESH';                                                            //0003
      exec sql
        insert into iaallrefpf (library_name,
                                object_name,
                                object_type,
                                object_text,
                                referenced_obj,
                                referenced_objtyp,
                                referenced_objlib,
                                referenced_objusg,                                       //0003
                                crt_pgm_name,
                                crt_usr_name)
                         select a.Ialibnam , a.Iaobjnam,a.Iaobjtyp,a.Iatxtdes,           //0004
                                b.bnobnm,b.bnobtp,                                       //0004
                                b.bnolnm ,'I',:uDpsds.ProcNme,                           //0004
                                current_user                                             //0004
                           from IAOBJECT  a                                              //0004
                           join BNDDIRDTL b                                              //0004
                             on a.Ialibnam = b.bndrlb                                    //0004
                            and a.Iaobjnam = b.bndrnm                                    //0004
                           join IAREFOBJF c                                              //0004
                             on a.Ialibnam = c.Object_Library                            //0004
                            and a.Iaobjnam = c.Object_Name                               //0004
                          where Iaobjtyp = '*BNDDIR'                                     //0004
                            and c.status <> 'D';                                         //0004
                                                                                         //0004
    other;                                                                               //0003
      exec sql                                                                           //0003
        insert into iaallrefpf (library_name,                                            //0003
                                object_name,                                             //0003
                                object_type,                                             //0003
                                object_text,                                             //0003
                                referenced_obj,                                          //0003
                                referenced_objtyp,                                       //0003
                                referenced_objlib,                                       //0003
                                referenced_objusg,                                       //0003
                                crt_pgm_name,                                            //0003
                                crt_usr_name)                                            //0003
                         select a.Ialibnam , a.Iaobjnam,a.Iaobjtyp,a.Iatxtdes,           //0004
                                b.bnobnm,b.bnobtp,                                       //0004
                                b.bnolnm ,'I',:uDpsds.ProcNme,                           //0004
                                current_user                                             //0004
                           from IAOBJECT  a                                              //0004
                           join BNDDIRDTL b                                              //0004
                             on a.Ialibnam = b.bndrlb                                    //0004
                            and a.Iaobjnam = b.bndrnm                                    //0004
                          where Iaobjtyp = '*BNDDIR';                                    //0004
                                                                                         //0004
  endsl;                                                                                 //0004

  if sqlCode < successCode;
     uDpsds.wkQuery_Name = 'Insert_1_IAALLREFPF';
     IaSqlDiagnostic(uDpsds);                                                            //0006
  endif;

end-proc;

//------------------------------------------------------------------------------------- //0001
//Procedure DltBndDirEntry : Delete references of binding directory for refresh         //0001
//------------------------------------------------------------------------------------- //0001
dcl-proc DltBndDirEntry ;                                                                //0001
                                                                                         //0001
  //Delete existing entries from iaallrefpf                                             //0001
  exec sql                                                                               //0001
    delete from iaallrefpf where exists (                                                //0001
         select 1                                                                        //0001
           from iARefObjF T1                                                             //0001
          where ((iaallrefpf.Library_Name = T1.iAObjLib                                  //0002
            and iaallrefpf.Object_Name  = T1.iAObjName                                   //0001
            and iaallrefpf.Object_Type  = '*BNDDIR')                                     //0001
             or (iaallrefpf.Referenced_Objlib = T1.iAObjLib                              //0002
            and iaallrefpf.Referenced_Obj    = T1.iAObjName                              //0002
            and iaallrefpf.Referenced_Objtyp = '*BNDDIR' ))                              //0002
            and  T1.status = 'M'                                                         //0002
            and iaallrefpf.Crt_Pgm_Name = :uDPsDs.procNme);                              //0002
                                                                                         //0001
  if sqlCode < successCode;                                                              //0001
     uDpsds.wkQuery_Name = 'Delete_iaallrefpf';                                          //0001
     IaSqlDiagnostic(uDpsds);                                                            //0001 0006
  endif;                                                                                 //0001
                                                                                         //0001
end-proc;                                                                                //0001

//------------------------------------------------------------------------------------- //
//Procedure mapBndDir: Populate binding directory as a referenced object
//------------------------------------------------------------------------------------- //
dcl-proc mapBndDir;
                                                                                         //0003
  clear wksqltext;                                                                       //0003

  wksqltext = 'Select LIBRARY_NAME, OBJECT_NAME, OBJECT_TYPE, '        +                 //0003
              'OBJECT_ATTR, OBJECT_TEXT ,B.BNDRNM,B.BNDRLB '           +                 //0003
              'from IAALLREFPF A Join BNDDIRDTL B On '                 +                 //0003
              'A.IAROBJNAM = B.BNOBNM and A.IAROBJTYP = B.BNOBTP and ' +                 //0003
              '(A.IAROBJLIB  = B.BNOLNM or B.BNOLNM = ''*LIBL'') '     +                 //0003
              'AND B.BNDRLB = (Select Ialibnam From IAOBJECT '         +                 //0004
              'Join IAINPLIB on xlibnam = IALIBNAM Where xrefnam = '   +                 //0004
              ''''  +  %trim(Uref) + ''''                              +                 //0004
              ' and IAOBJNAM = B.BNDRNM Order By xlibseq limit 1) '    +                 //0004
              'WHERE object_name <> bndrnm and a.iaoobjtyp  '          +                 //0004
              '<> ''*BNDDIR''';                                                          //0004
                                                                                         //0003
  exec sql prepare stmt from :wksqltext;                                                 //0003
  exec sql declare CheckIaAllRefPfDupRec cursor for Stmt ;                               //0003
                                                                                         //0003
  //Open Cursor CheckIaAllRefPfDupRec                                                   //0003
  exec sql open CheckIaAllRefPfDupRec;                                                   //0003
  if sqlCode = CSR_OPN_COD;                                                              //0003
     exec sql close CheckIaAllRefPfDupRec;                                               //0003
     exec sql open  CheckIaAllRefPfDupRec;                                               //0003
  endif;                                                                                 //0003
                                                                                         //0003
  if sqlCode < successCode;                                                              //0003
     uDpsds.wkQuery_Name = 'Open_CheckIaAllRefPfDupRec';                                 //0003
     IaSqlDiagnostic(uDpsds);                                                            //0003 0006
  endif;                                                                                 //0003
                                                                                         //0003
  //Get the number of elements                                                          //0003
  noOfRows = %elem(w_GetIaAllrefpfDs);                                                   //0003
                                                                                         //0003
  //Fetch records from CheckIaAllRefPfDupRec cursor                                     //0003
  rowFound = fetchRecordCheckIaAllRefPfDupRecCursor();                                   //0003

  dow rowFound;                                                                          //0003
                                                                                         //0003
     for uwindx = 1 to RowsFetched;                                                      //0003
        DupRecord = *Off;                                                                //0003
                                                                                         //0003
        w_CheckIaAllrefpfDS = w_GetIaAllrefpfDS(uwindx);                                 //0003
                                                                                         //0003
        //Check duplicate record in IAALLREFPF file.                                    //0003
        exec Sql                                                                         //0003
         select '1' into :DupRecord from iAAllRefPf                                      //0003
           where iAOobjLib = :w_checkIaAllrefpfDS_iAOobjLib                              //0003
             and iAOobjNam = :w_checkIaAllrefpfDS_iAOobjNam                              //0003
             and iAOobjTyp = :w_checkIaAllrefpfDS_iAOobjTyp                              //0003
             and iAOobjAtr = :w_checkIaAllrefpfDS_iAOobjAtr                              //0003
             and iARobjNam = :w_checkIaAllrefpfDS_iARobjNam                              //0003
             and iARobjTyp = '*BNDDIR'                                                   //0003
             and iARobjLib = :w_checkIaAllrefpfDS_iARobjLib;                             //0003
                                                                                         //0003
        //If no duplicate found in IAALLREFPF file then do Insert.                      //0003
        if not DupRecord;                                                                //0003
           exec Sql                                                                      //0003
             Insert into iAAllRefPf (iAOobjLib,                                          //0003
                                     iAOobjNam,                                          //0003
                                     iAOobjTyp,                                          //0003
                                     iAOobjAtr,                                          //0003
                                     iAOobjTxt,                                          //0003
                                     iARobjNam,                                          //0003
                                     iARobjTyp,                                          //0003
                                     iARobjLib,                                          //0003
                                     iARusages,                                          //0003
                                     crt_pgm_name,                                       //0003
                                     crt_usr_name)                                       //0003
                             values (:w_checkIaAllrefpfDS_iAOobjLib,                     //0003
                                     :w_checkIaAllrefpfDS_iAOobjNam,                     //0003
                                     :w_checkIaAllrefpfDS_iAOobjTyp,                     //0003
                                     :w_checkIaAllrefpfDS_iAOobjAtr,                     //0003
                                     :w_checkIaAllrefpfDS_iAOobjTxt,                     //0003
                                     :w_checkIaAllrefpfDS_iARobjNam,                     //0003
                                     '*BNDDIR',                                          //0003
                                     :w_checkIaAllrefpfDS_iARobjLib,                     //0003
                                     'I',                                                //0003
                                     :uDpsds.ProcNme,                                    //0003
                                     current_user                                        //0003
                                    );                                                   //0003
                                                                                         //0003
           if sqlCode < successCode;                                                     //0003
              uDpsds.wkQuery_Name = 'Insert_2_IAALLREFPF';                               //0003
              IaSqlDiagnostic(uDpsds);                                                   //0003 0006
           endif;                                                                        //0003
                                                                                         //0003
        endif;                                                                           //0003
                                                                                         //0003
        clear w_checkIaAllrefpfDS;                                                       //0003
                                                                                         //0003
     endfor;                                                                             //0003
                                                                                         //0003
     //if fetched rows are less than the array elements then come out of the loop.      //0003
     if RowsFetched < noOfRows ;                                                         //0003
        leave ;                                                                          //0003
     endif ;                                                                             //0003
                                                                                         //0003
     //Fetch records from cursor.                                                       //0003
     rowFound = fetchRecordCheckIaAllRefPfDupRecCursor();                                //0003
                                                                                         //0003
  enddo;                                                                                 //0003

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure makeBndDirEntry: Write references of binding directory
//------------------------------------------------------------------------------------- //
dcl-proc fetchRecordBnddirCursor;

   dcl-pi fetchRecordBnddirCursor ind end-pi ;

   dcl-s  rcdFound ind inz('0');
   dcl-s  wkRowNum like(RowsFetched) ;

   RowsFetched = *zeros;
   clear bnddirdtls ;

   exec sql
      fetch bnddir for :noOfRows rows into :bnddirdtls;

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Fetch_Bnddir';
      IaSqlDiagnostic(uDpsds);                                                           //0006
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

   return rcdFound;

end-proc;

//------------------------------------------------------------------------------------- //0003
//Procedure: Fetch references of binding directory.
//------------------------------------------------------------------------------------- //0003
dcl-proc fetchRecordCheckIaAllRefPfDupRecCursor;                                         //0003
                                                                                         //0003
   dcl-pi fetchRecordCheckIaAllRefPfDupRecCursor ind end-pi ;                            //0003
                                                                                         //0003
   dcl-s  rcdFound ind inz('0');                                                         //0003
   dcl-s  wkRowNum like(RowsFetched) ;                                                   //0003
                                                                                         //0003
   RowsFetched = *zeros;                                                                 //0003
   clear w_GetIaAllrefpfDs;                                                              //0003
                                                                                         //0003
   exec sql                                                                              //0003
      fetch CheckIaAllRefPfDupRec for :noOfRows rows into :w_GetIaAllrefpfDs;            //0003
                                                                                         //0003
   if sqlCode < successCode;                                                             //0003
      uDpsds.wkQuery_Name = 'Fetch_CheckIaAllRefPfDupRec';                               //0003
      IaSqlDiagnostic(uDpsds);                                                           //0003 0006
   endif;                                                                                //0003

   if sqlcode = successCode;                                                             //0003
      exec sql get diagnostics                                                           //0003
          :wkRowNum = ROW_COUNT;                                                         //0003
           RowsFetched  = wkRowNum ;                                                     //0003
   endif;                                                                                //0003
                                                                                         //0003
   if RowsFetched > 0;                                                                   //0003
      rcdFound = TRUE;                                                                   //0003
   elseif sqlcode < successCode ;                                                        //0003
      rcdFound = FALSE;                                                                  //0003
   endif;                                                                                //0003
                                                                                         //0003
   return rcdFound;                                                                      //0003
                                                                                         //0003
end-proc;                                                                                //0003
