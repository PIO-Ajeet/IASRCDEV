**free
      //%METADATA                                                      *
      // %TEXT Copy all obj. ref. data to final ref file               *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------- //
//Created By    : Programmers.io @ 2023                                                 //
//Creation Date : 2023/11/02                                                            //
//Developer     : Abhijit Charhate                                                      //
//Description   : To Copy Populate Final Reference File                                 //
//                                                                                      //
//Procedure Log :                                                                       //
//------------------------------------------------------------------------------------- //
//Procedure Name           | Procedure Description                                      //
//-------------------------|----------------------------------------------------------- //
//                         |                                                            //
//------------------------------------------------------------------------------------- //
//Modification Log:                                                                     //
//------------------------------------------------------------------------------------- //
//Date    | Mod_ID | Developer  | Case and Description                                  //
//--------|--------|------------|------------------------------------------------------ //
//05112023| 0001   | Sai        | Refresh builtmetadata changes.                        //
//        |        |            |                                                       //
//24112023| 0002   | Akhil K.   | Bug fix on the Refresh related SQLs. [Task#409]       //
//        |        |            |                                                       //
//27112023| 0003   | Kunal P.   | Refresh builtmetadata changes. [Task #402]            //
//        |        |            |                                                       //
//28112023| 0004   | Kunal P.   | Refresh builtmetadata changes. [Task #420]            //
//        |        |            |                                                       //
//13122023| 0005   | Kunal P.   | Refresh builtmetadata changes. [Task #438]            //
//        |        |            |                                                       //
//18012024| 0006   | Venkatesh B| Removed Ref object library update logic.  [Task #523] //
//26122023| 0007   | Sribalaji  | Mapped from Object-driven/Source-driven               //
//        |        |            | in IAALLREFPF. [Task #457]                            //
//22042024| 0008   | Pranav     | In case object usage is not populated the process is  //
//        |        |            | failing. Avoid writing such records in IAALLREFPF.    //
//03052024| 0009   | Bhavit Jain| Display file usage should be recorded as C instead    //
//        |        |            | of I/U/O                                              //
//24052024| 0010   | Saumya     | In chkRecordExists Proc for some cases the usRefObjLib//
//      |        | Arora      | is empty that's the reason why the record was not     //
//      |        |            | getting tracked and was comming as record won't exists//
//     |        |            | so commented out that condition so as to have         //
//      |        |            | no duplicacy of records.                              //
//        |        |            | Removed Ref Object Library from where condition       //
//        |        |            | while checking whether referenced object/source exists//
//       |        |            | or not in IAALLREFPF File. [TASK #661]                //
//13102023| 0011   | Rituraj    | Rename program from AI to IA [Task #248]              //
//06062024| 0012   | Saumya     | Rename program AIEXCTIMR to AIEXCTIMR [Task #262]     //
//02072024| 0013   | Vamsi      | Rename the file AILNGNMDTL from IALNGNMDTL[Task#246] //
//04072024| 0014   | Akhil K.   | Rename AIERRBND and copybooks AICERRLOG and, AIDERRLOG//
//        |        |            | and IASQLDIAGNOSTIC with IA*                          //
//16092024| 0015   | Gopi Thorat| Rename IACPYBDTL file fields wherever used due to     //
//                                table changes. [Task#940]                             //
//04042024| 0016   | Venkatesh B| While checking for record in IAALLREFPF using Ref Obj //
//        |        |            |    Library only when it is not blank.     [Task #609] //
//        |        |            |  Discarded incorrect changes done for task#661        //
//18122024| 0017   | Vivek Shar | Add new field REFERENCED_OBJATR Logic [Tsk#1084]      //
//10/11/23| 0018   | Abhijit    | Enhancement required for IA --> Object Context Matrix //
//        |        |    Charhate| (Task#342)                                            //
//01172025| 0019   | Bpal       | Multiple issues with the query in CPY2FNLREF program. //
//        |        |            | #1116                                                 //
//13082024| 0020   | Sabarish   | IFS Member Parsing Feature [Task#833]                 //
//------------------------------------------------------------------------------------- //
ctl-opt copyright('Programmers.io Â© 2023');
ctl-opt option(*noDebugIo: *srcStmt: *noUnRef) expropts(*RESDECPOS);
ctl-opt bndDir('IAERRBND');                                                              //0014

//------------------------------------------------------------------------------------- //
//Prototype Declaration
//------------------------------------------------------------------------------------- //
dcl-pr iasprocref extpgm('IASPROCREF');                                                  //0011
   upCrossRef char(10);
end-pr;

dcl-pr IAEXCTIMR extpgm('IAEXCTIMR');                                                    //0012
   *n Char(10) Const;
   *n Char(10);
   *n Char(10);
   *n Char(10) Const;
   *n Char(10);
   *n Char(10);
   *n Char(10);
   *n Char(100) Const;                                                                   //0020
   *n Char(10) Const;
   *n Timestamp;
   *n Char(6) Const;
end-pr;

//------------------------------------------------------------------------------------- //
//Constant Declaration
//------------------------------------------------------------------------------------- //
dcl-c wI         const('I');
dcl-c wO         const('O');
dcl-c wU         const('U');
dcl-c w_Yes      const('Y');
dcl-c wSeperator const('/');
dcl-c TRUE            '1';
dcl-c FALSE           '0';
dcl-c wC         const('C');                                                             //0018
dcl-c uwRefObjat const('DSPF');                                                          //0018

//------------------------------------------------------------------------------------- //
//Variable Declaration
//------------------------------------------------------------------------------------- //
dcl-s wMode            char(10) inz;
dcl-s wSavObjectLib    char(10) inz;
dcl-s wSavObjectNam    char(10) inz;
dcl-s wSaveObjectTyp   char(1)  inz;
dcl-s uwOdObAt         char(10) inz;
dcl-s uwOdObTx         char(50) inz;
dcl-s lib              char(10) inz;
dcl-s uppgm_name       char(10) inz;
dcl-s uplib_name       char(10) inz;
dcl-s upsrc_name       char(10) inz;
dcl-s w_ObjectTyp      char(10) inz;
dcl-s w_ExternalNam    char(11) inz;
dcl-s w_Fileusage      char(10) inz;
dcl-s w_Iambrlib       char(10) inz;
dcl-s w_Iambrsrc       char(10) inz;
dcl-s w_Iambrnam       char(10) inz;
dcl-s wUsage           packed(2:0)inz;
dcl-s uptimestamp      Timestamp;
dcl-s noOfRows         uns(5) inz;
dcl-s LibraryCount     uns(5) inz;
dcl-s RowsFetched      uns(5);
dcl-s wRowsFetched     uns(5);
dcl-s wkRownum         uns(5);
dcl-s uwindx           uns(5);
dcl-s RowFound         ind inz('0');
dcl-s uwindex          uns(5);
dcl-s wkSqlText1       char(1000) Inz ;                                                  //0001
dcl-s wkSqlText2       char(1000) Inz ;                                                  //0001
dcl-s w_MapedBased     char(7);                                                          //0007
dcl-s wRefObjAtr      char(10);                                                          //0009
dcl-s uwModindx        uns(5);                                                           //0018
dcl-s uwFileusage      char(10) inz;                                                     //0018
dcl-s uwRefOdObAt      char(10) inz;                                                     //0018

//------------------------------------------------------------------------------------- //
//Data Structure Declaration
//------------------------------------------------------------------------------------- //
dcl-ds ia_wPgmRefDtl extname('IAOBJREFPF') qualified dim(99) end-ds;

dcl-ds ia_wSrcRefDtl extname('IASRCINTPF') qualified dim(99) end-ds;

dcl-ds udPgmRefDtl  likeds(ia_wPgmRefDtl);

dcl-ds udSrcRefDtl  likeds(ia_wSrcRefDtl);

//Data structure to check IAALLREFPF duplicate data and data popualation.
dcl-ds udRefObjDtl;
   usObjectLib       char(10);
   usObjectName      char(10);
   usObjectType      char(10);
   usObjectAttr      char(10);
   usObjectTxt       char(50);
   usRefObjName      char(11);
   usMapedFrom       char(7);                                                            //0007
   usRefObjType      char(11);
   usRefObjLib       char(11);
   usRefObjUsage     char(10);
   usRefObjAttr      char(10);                                                           //0017
end-ds;

//Data structure to fetch appropriate reference libray name.
dcl-ds udSavRefObjDtl;
   usSavRefObjName      char(11);
   usSavRefObjType      char(11);
end-ds;

//Data structure to get the object/copy book mapping.
dcl-ds udSrcObjectMap dim(999) qualified ;
   uwObjectLib       char(10);
   uwObjectNam       char(10);
   uwObjectTyp       char(10);
   uwObjectAttr      char(10);
   uwObjecttxt       char(50);
end-ds;

dcl-ds IaMetaInfo dtaara len(62);                                                        //0001
   runmode char(7) pos(1);                                                               //0001
end-ds;                                                                                  //0001

//------------------------------------------------------------------------------------- //
//Copybook Declaration
//------------------------------------------------------------------------------------- //
/copy 'QCPYSRC/iaderrlog.rpgleinc'

//------------------------------------------------------------------------------------- //
//Entry Parameter
//------------------------------------------------------------------------------------- //
dcl-pi CPY2FNLREF  extpgm('CPY2FNLREF');
   xref char(10);
end-pi;

//------------------------------------------------------------------------------------- //
//Mainline Logic
//------------------------------------------------------------------------------------- //
exec sql
  set option Commit    = *None,
             Naming    = *Sys,
             UsrPrf    = *User,
             DynUsrPrf = *User,
             CloSqlCsr = *EndMod;

In IaMetaInfo;                                                                           //0001
//------------------------------------------------------------------------------------- //
//Cursor definition
//------------------------------------------------------------------------------------- //
//If Process is 'INIT'                                                                  //0001
if runmode = 'INIT';                                                                     //0001

   //Declaring cursor to retrieve the object ref file details
   wksqltext1 =                                                                          //0001
      ' select *'                                                +                       //0001
      ' from  iaobjrefpf'                                        +                       //0001
      ' where whlnam not in (''QSYS'',''QSYS2'')  and '          +                       //0001
      '      whfnam <> ''OBJ_LOCK''  and '                       +                       //0001
      '      substr(trim(whfnam),1,1) not in (''*'',''&'') and ' +                       //0001
      '      whfnam <> '' '' ';                                                          //0001

   //Declaring cursor to retrieve the intermediate file details
   wksqltext2 =                                                                          //0001
      ' select *'                           +                                            //0001
      ' from  iasrcintpf'                   +                                            //0001
      ' where iarefobj <> '' '' ';                                                       //0001

//If Process is 'REFRESH'                                                               //0001
elseif runmode = 'REFRESH';                                                              //0001

   //Declaring cursor to retrieve the object ref file details
   wksqltext1 =                                                                       //0002
      ' select t1.*'                                             +                    //0002
      ' from  iaobjrefpf t1 join iarefobjf t2'                   +                    //0002
      ' on  t1.whpnam = t2.IaObjName and '                       +                    //0002
      '     t1.whlib  = t2.IaObjlib  and '                       +                    //0002
      '       t2.iaobjtype =        '                            +                    //0002
      '       case when t1.whspkg = ''V'' then ''*SRVPGM'' '     +                    //0002
      '            when t1.whspkg = ''P'' then ''*PGM'' '        +                    //0002
      '            when t1.whspkg = ''M'' then ''*MODULE'' '     +                    //0002
      '            when t1.whspkg = ''S'' then ''*SQLPKG'' '     +                    //0002
      '            when t1.whspkg = ''Q'' then ''*QRYDFN'' '     +                    //0002
      '       end '                                              +                    //0002
      ' where t1.whlnam not in (''QSYS'',''QSYS2'')  and '       +                    //0002
      '      t1.whfnam <> ''OBJ_LOCK''  and '                    +                    //0002
      '      substr(trim(t1.whfnam),1,1) not in (''*'',''&'') and ' +                 //0002
      '      t1.whfnam <> '' '' and t2.status in (''M'', ''A'')';                     //0002


   //Declaring cursor to retrieve the intermediate file details
   wksqltext2 =                                                                          //0002
      ' select t1.*'                           +                                         //0002
      ' from  iasrcintpf t1 join iarefobjf t2' +                                         //0002
      ' on  t1.iambrnam = t2.iamemname and'    +                                         //0002
      '     t1.iambrlib = t2.iamemlib and '    +                                         //0002
      '     t1.iambrsrc = t2.iasrcpf and '     +                                         //0002
      '     t1.iambrtyp = t2.iamemtype '       +                                         //0002
      ' where t1.iarefobj <> '' '' and t2.status in (''M'', ''A'')';                     //0002

endif;                                                                                   //0001

//Declaring cursor to retrieve the library names from the repository
exec sql
  declare GetRepoLiblist cursor for
    select library_Name
      from IAINPLIB
     where xrefnam = :Xref;

//Declaring cursor to retrieve the object mapping.
exec sql
  declare GetObjectmap cursor for
    Select iaobjlib, iaobjnam, iaobjtyp, odobat, odobtx
      from iaobjmap join idspobjd on
           odlbnm = iaobjlib
       and odobnm = iaobjnam
       and odobtp = iaobjtyp
     where iambrlib  = :udSrcRefDtl.iambrlib
       and iambrsrcf = :udSrcRefDtl.iambrsrc
       and iambrnam  = :udSrcRefDtl.iambrnam;

//Declaring cursor to retrieve the Cpyb mapping.
exec sql
  declare GetCopybkmap cursor for
    Select B.iAObjLib, B.iAObjNam, B.iAObjTyp,                                           //0015
           ifnull(C.OdObAt,' '), ifnull(C.OdObTx,' ')                                    //0015
      from iACpybDtl A                                                                   //0015
      join iAObjMap B on                                                                 //0015
           A.iAMbrLib   = B.iAMbrLib                                                     //0015
       and A.iAMbrSrcPf = B.iAMbrSrcf                                                    //0015
       and A.iAMbrName  = B.iAMbrNam                                                     //0015
 left join iDspObjd C on                                                                 //0015
           C.OdLbNm = B.iAObjLib                                                         //0015
       and C.OdObNm = B.iAObjNam                                                         //0015
       and C.OdObTp = B.iAObjTyp                                                         //0015
     where A.iACpyLib   = :udSrcRefDtl.iAMbrLib                                          //0015
       and A.iACpySrcPf = :udSrcRefDtl.iAMbrSrc                                          //0015
       and A.iACpyMbr   = :udSrcRefDtl.iAMbrNam;                                         //0015

//------------------------------------------------------------------------------------- //
//Main process to capture the references
//------------------------------------------------------------------------------------- //
eval-corr uDpsds = wkuDpsds;

//Populate process start time
uptimeStamp = %Timestamp();
callP IAEXCTIMR('BLDMTADTA': udpsds.ProcNme : udpsds.Lib : '*PGM' :                      //0012
              //upsrc_name : uppgm_name : uplib_name : ' ' :                             //0020
                upsrc_name : uppgm_name : uplib_name : ' ' : ' ' :                       //0020
                uptimeStamp : 'INSERT');

//Populate the object driven references in reference table
exsr populateObjectDrivenRef;
//Populate the source driven references in reference table
exsr populateSourceDrivenRef;

//Write the stored procedure references in reference file iaallrefpf
iasprocref(xref);                                                                        //0011

//Update process end time
UPTimeStamp = %Timestamp();
callP IAEXCTIMR('BLDMTADTA' :udpsds.ProcNme : udpsds.Lib : '*PGM' :                      //0012
                //upsrc_name : uppgm_name : uplib_name : ' ' :                           //0020
                upsrc_name : uppgm_name : uplib_name : ' ' : ' ' :                       //0020
                uptimeStamp : 'UPDATE');

*inlr = *on;
return;

//Error handling copybook
/copy 'QCPYSRC/iacerrlog.rpgleinc'

//------------------------------------------------------------------------------------- //
//SR populateObjectDrivenRef: Populate object driven references in reference table
//------------------------------------------------------------------------------------- //
begsr populateObjectDrivenRef;

  exec sql prepare stmt1 from :wksqltext1 ;                                              //0001
  exec sql declare GetPgmrefdetail cursor for Stmt1 ;                                    //0001
  //Open cursor
  exec sql open GetPgmrefdetail;
  if sqlCode = CSR_OPN_COD;
     exec sql close GetPgmrefdetail;
     exec sql open  GetPgmrefdetail;
  endif;

  if sqlCode < successCode;
     uDpsds.wkQuery_Name = 'Open_Cursor_GetPgmrefdetail';
     IaSqlDiagnostic(uDpsds);                                                            //0014
  endif;

  //Get the number of elements
  noOfRows = %elem(ia_wPgmRefDtl);

  //Fetch block set of record
  rowFound = fetchRecordObjRefCursor();

  dow rowFound;

     for uwindx = 1 to RowsFetched;

        udPgmRefDtl = ia_wPgmRefDtl(uwindx);

        //Get object type, attribute and description of original object
        if wSavObjectLib <> udPgmRefDtl.whlib or wSavObjectNam <> udPgmRefDtl.whpnam
           or wSaveObjectTyp <> udPgmRefDtl.whspkg;

           if runMode = 'REFRESH';                                                       //0001
              exsr dltinfo;                                                              //0001
           endif;                                                                        //0001
           exsr getRefObjTyp;
           exsr getObjAttr;

           wSavObjectLib = udPgmRefDtl.whlib ;
           wSavObjectNam = udPgmRefDtl.whpnam;
           wSaveObjectTyp = udPgmRefDtl.whspkg;

        endif;

        //Check the referred object library refrences.
        Clear udSavRefObjDtl ;
        usSavRefObjName = udPgmRefDtl.whfnam ;
        usSavRefObjType = udPgmRefDtl.whotyp ;

        //Get the usage mode.
        exsr getFileMode;                                                                //0018

        //Populate the reference details
        clear udRefObjDtl;
        usObjectLib   = udPgmRefDtl.whlib  ;
        usObjectName  = udPgmRefDtl.whpnam ;
        usObjectType  = w_ObjectTyp         ;
        usRefObjName  = udPgmRefDtl.whfnam ;
        usRefObjType  = udPgmRefDtl.whotyp ;
        usRefObjLib   = udPgmRefDtl.whlnam ;
        usObjectAttr  = uwOdObAt;
        usObjectTxt   = uwOdObTx;
        usRefObjUsage = %trim(wMode);

        //Do not write records in case object usage is not available.
        if usRefObjUsage = *blanks ;                                                     //0008
           iter;                                                                         //0008
        endif ;                                                                          //0008

        if chkRecordExists(w_Fileusage:w_MapedBased) = w_Yes;                            //0007

           //Skip, if the file is display file.                                         //0001
           //Also skip, all other object types except data area.                        //0001
           if (usRefObjType = '*FILE' and usRefObjUsage <> wC)                           //0001
              or usRefObjType = '*DTAARA';                                               //0001

              //Save the usage value.                                                   //0001
              uwFileusage = %trim(w_Fileusage);                                          //0001

              For uwModindx = 1 by 2 to %len(%Trim(usRefObjUsage));                      //0018
                 if %Scan(%subst(%trim(usRefObjUsage):uwModindx:1)                       //0018
                        :w_Fileusage) = 0;                                               //0018
                    w_Fileusage = %trim(w_Fileusage) + wSeperator +                      //0018
                                  %subst(%trim(usRefObjUsage):uwModindx:1);              //0018
                    usRefObjUsage = w_Fileusage;                                         //0018
                 endif;                                                                  //0018
              endfor;                                                                    //0018
                                                                                         //0018
              //Update the file usage with new details.                                 //0015
              if uwFileusage <> w_Fileusage;                                             //0018
                 exsr CorrectFileUsageSequence;                                          //0018
                 usRefObjUsage = w_Fileusage;                                            //0018
                 Update_IAallrefpf();                                                    //0018
              endif;                                                                     //0018

           endif;                                                                        //0018
        else;
           //The record dosn't exist in IAALLREFPF so, Mapped as Object based on 'O'    //0007
           usMapedFrom = 'O';                                                            //0007

           //Insert new details in file.
           Insert_IAallrefpf();

        endif;

     endfor;

     //if fetched rows are less than the array elements then come out of the loop.
     if RowsFetched < noOfRows ;
        leave ;
     endif ;

     //fetched next set of rows.
     rowFound = fetchRecordObjRefCursor();

  enddo;

  //Close the cursor.
  exec sql close GetPgmrefdetail;

endsr;

//------------------------------------------------------------------------------------- //
//SR CorrectFileUsageSequence: To correct the file usage sequence
//------------------------------------------------------------------------------------- //
begsr CorrectFileUsageSequence;                                                          //0018

  select;                                                                                //0018
   //If all Input,Output and Update modes exist then sequence should be I/O/U           //0018
   when %scan(wI:w_Fileusage) > 0                                                        //0018
    and %scan(wO:w_Fileusage) > 0                                                        //0018
    and %scan(wU:w_Fileusage) > 0;                                                       //0018
         w_Fileusage = wI + wSeperator + wO + wSeperator + wU ;                          //0018

   //If only Input and Output modes exist then sequence should be I/O                   //0018
   when %scan(wI:w_Fileusage) > 0                                                        //0018
    and %scan(wO:w_Fileusage) > 0;                                                       //0018
         w_Fileusage = wI + wSeperator + wO ;                                            //0018

   //If only Input and Update modes exist then sequence should be I/U                   //0018
   when %scan(wI:w_Fileusage) > 0                                                        //0018
    and %scan(wU:w_Fileusage) > 0;                                                       //0018
         w_Fileusage = wI + wSeperator + wU ;                                            //0018

   //If only Ouput and Update modes exist then sequence should be O/U                   //0018
   when %scan(wO:w_Fileusage) > 0                                                        //0018
    and %scan(wU:w_Fileusage) > 0;                                                       //0018
         w_Fileusage = wO + wSeperator + wU ;                                            //0018

   other;                                                                                //0018
  endsl;                                                                                 //0018

endsr;                                                                                   //0018

//------------------------------------------------------------------------------------- //
//SR getRefObjTyp: To get Object Type
//------------------------------------------------------------------------------------- //
begsr getRefObjTyp;

  select;
     when udPgmRefDtl.whspkg = 'V';
          w_ObjectTyp = '*SRVPGM';
     when udPgmRefDtl.whspkg = 'P';
          w_ObjectTyp = '*PGM';
     when udPgmRefDtl.whspkg = 'M';
          w_ObjectTyp = '*MODULE';
     when udPgmRefDtl.whspkg = 'S';
          w_ObjectTyp = '*SQLPKG';
     when udPgmRefDtl.whspkg = 'Q';
          w_ObjectTyp = '*QRYDFN';
     other;
          w_ObjectTyp = ' ';
  endsl;

endsr;

//------------------------------------------------------------------------------------- //
//getobjattr: To get Objects Attributes
//------------------------------------------------------------------------------------- //
begsr getobjattr;

  uwOdObAt = *blanks;
  uwOdObTx = *blanks;

  exec sql
    select odobat,odobtx into :uwOdObAt, :uwOdObTx
      from idspobjd
     where odlbnm = :udPgmRefDtl.whlib
       and odobnm= :udPgmRefDtl.whpnam
       and odobtp = :w_ObjectTyp
     limit 1;

  if sqlCode < successCode;
     uDpsds.wkQuery_Name = 'Select_IDSPOBJD';
     IaSqlDiagnostic(uDpsds);                                                            //0014
  endif;

endsr;

//------------------------------------------------------------------------------------- //0009
// GetRefObjAtr: Get the attribute of the referenced object.
//------------------------------------------------------------------------------------- //0009
begsr GetRefObjAtr;                                                                      //0009

  wRefObjAtr = *blanks;                                                                  //0009

  exec sql                                                                               //0009
    select odobat into :wRefObjAtr                                                       //0009
      from idspobjd                                                                      //0009
     where odobnm = :usRefObjName                                                        //0009
       and odobtp = :usRefObjType                                                        //0009
       and odlbnm = :usRefObjLib                                                         //0019
     limit 1;                                                                            //0019

  if sqlCode < successCode;                                                              //0009
     uDpsds.wkQuery_Name = 'Select_IDSPOBJD';                                            //0009
     IaSqlDiagnostic(uDpsds);                                                            //0014
  endif;                                                                                 //0009

  //Populate object usage as 'C' combined in case of display file.
  if sqlCode = 0 and wRefObjAtr = 'DSPF';                                                //0009
    usRefObjUsage = 'C';                                                                 //0009
  endif;                                                                                 //0009

endsr;                                                                                   //0009

//------------------------------------------------------------------------------------- //
//getFileMode: To get usages of Referenced object
//------------------------------------------------------------------------------------- //
begsr getFileMode;

  wUsage = udPgmRefDtl.whfusg;
  wMode  = *blanks;
  clear uwRefOdObAt ;                                                                    //0018

  //The referenced object is a *File and usage is 7, then verify whether                //0018
  //it is a DSPF or not. If it is DSPF then populate the usage as "C".                  //0018
  if udPgmRefDtl.whotyp = '*FILE' and wUsage = 7;
                                                                                         //0018
     exec sql                                                                            //0018
         select odobat into :uwRefOdObAt                                                 //0018
           from idspobjd                                                                 //0018
          where odlbnm = :udPgmRefDtl.whlnam                                             //0018
            and odobnm = :udPgmRefDtl.whfnam                                             //0018
            and odobtp = :udPgmRefDtl.whotyp                                             //0018
          limit 1;                                                                       //0018
                                                                                         //0018
     if sqlCode < successCode;                                                           //0018
        uDpsds.wkQuery_Name = 'Select_Ref_IDSPOBJD';                                     //0018
        IaSqlDiagnostic(uDpsds);                                                         //0018
     endif;                                                                              //0018
                                                                                         //0018
     if uwRefOdObAt = uwRefObjat;                                                        //0018
        wMode  = wC;                                                                     //0018
        leavesr;                                                                         //0018
     endif;                                                                              //0018

  endif;                                                                                 //0018

  //Populate usages type                                                                //0018
  select;                                                                                //0018
    when wUsage = 1;                                                                     //0018
       wMode = wI;                                                                       //0018

    when wUsage = 2;                                                                     //0018
       wMode = wO;                                                                       //0018

    when wUsage = 3;                                                                     //0018
       wMode = wI + wSeperator + wO;                                                     //0018

    when wUsage = 4;                                                                     //0018
       wMode = wU;                                                                       //0018

    when wUsage = 5;                                                                     //0018
       wMode = wI + wSeperator + wU;                                                     //0018

    when wUsage = 6;                                                                     //0018
       wMode = wO + wSeperator + wU;                                                     //0018

    when wUsage = 7;                                                                     //0018
       wMode = wI + wSeperator + wO + wSeperator + wU;                                   //0018

    other;                                                                               //0018
       wMode  = wI;                                                                      //0018
  endsl;                                                                                 //0018

  if wUsage = 0 or wUsage = 1 or wUsage = 3 or wUsage = 5 or
     wUsage >= 7;
     wMode  = wI;
  endif;

  if wUsage = 2 or wUsage = 3 or wUsage = 6 or wUsage = 7;
     wMode  = wO;
  endif;

  if wUsage = 4 or wUsage = 5 or wUsage = 6 or wUsage = 7;
     wMode  = wU;
  endif;

endsr;

//------------------------------------------------------------------------------------- //
//populateSourceDrivenRef: Populate source driven reference in reference table
//------------------------------------------------------------------------------------- //
begsr populateSourceDrivenRef;

  clear noOfRows;

  exec sql prepare stmt2 from :wksqltext2 ;                                              //0001
  exec sql declare GetSrcrefdetail cursor for Stmt2 ;                                    //0001
  //Open cursor
  exec sql open GetSrcrefdetail;
  if sqlCode = CSR_OPN_COD;
     exec sql close GetSrcrefdetail;
     exec sql open  GetSrcrefdetail;
  endif;

  if sqlCode < successCode;
     uDpsds.wkQuery_Name = 'Open_Cursor_GetSrcrefdetail';
     IaSqlDiagnostic(uDpsds);                                                            //0014
  endif;

  //Get the number of elementsName
  noOfRows = %elem(ia_wSrcRefDtl);

  //Fetch block set of record
  rowFound = fetchRecordSrcRefCursor();

  dow rowFound;

     for uwindx = 1 to RowsFetched;

        udSrcRefDtl  =  ia_wSrcRefDtl(uwindx);

        //Get object details from object mapping file.
        if w_Iambrlib <> udSrcRefDtl.iambrlib
           or w_Iambrsrc <> udSrcRefDtl.iambrsrc
           or w_Iambrnam <> udSrcRefDtl.iambrnam;

           clear udSrcObjectMap;
           clear wRowsFetched;
           getSrcObjectMapping(wRowsFetched);

           w_Iambrlib = udSrcRefDtl.iambrlib;
           w_Iambrsrc = udSrcRefDtl.iambrsrc;
           w_Iambrnam = udSrcRefDtl.iambrnam;

        endif;

        //If object found then populate the reference in reference table
        for uwindex = 1 to wRowsFetched;

           //Fetch the details for long name (Stored procedure)
           if %len(%trim(udSrcRefDtl.iarefobj)) > 10;

              clear w_ExternalNam;
              exec sql
                select aiextnam into :w_ExternalNam
                  from ialngnmdtl                                                        //0013
                 where airtnnam  = :udSrcRefDtl.iarefobj
                   and airtnlib = :udSrcRefDtl.iarefolib;

              if sqlCode < successCode;
                 uDpsds.wkQuery_Name = 'Extnam_1_AILNGNMDTL';
                 IaSqlDiagnostic(uDpsds);                                                //0014
              endif;

              if sqlCode = successCode and w_ExternalNam <> *Blanks;
                 udSrcRefDtl.iarefobj = w_ExternalNam;
              endif;

           endif;

           //Check the referred object library refrences.
           Clear udSavRefObjDtl ;
           usSavRefObjName = udSrcRefDtl.iarefobj ;
           usSavRefObjType = udSrcRefDtl.iarefotyp ;

           clear udRefObjDtl;
           usObjectLib   =  udSrcObjectMap(uwindex).uwObjectLib;
           usObjectName  =  udSrcObjectMap(uwindex).uwObjectNam;
           usObjectType  =  udSrcObjectMap(uwindex).uwObjectTyp;
           usRefObjName  =  udSrcRefDtl.iarefobj;
           usRefObjType  =  udSrcRefDtl.iarefotyp;
           usRefObjLib   =  udSrcRefDtl.iarefolib;
           usObjectAttr  =  udSrcObjectMap(uwindex).uwObjectAttr;
           usObjectTxt   =  udSrcObjectMap(uwindex).uwObjecttxt;
           usRefObjUsage =  %trim(%char(udSrcRefDtl.iarefousg)) ;

           Exsr GetRefObjAtr;                                                            //0017
           usRefObjAttr  =  wRefObjAtr;                                                  //0017
           //Populate Ref Object usage as 'I' for *BNDDIR.                              //0005
           If usRefObjType = '*BNDDIR';                                                  //0005
              usRefObjUsage = 'I';                                                       //0005
           EndIf;                                                                        //0005
           //Do not write records in case object usage is not available.
           if usRefObjUsage = *blanks ;                                                  //0008
              iter;                                                                      //0008
           endif ;                                                                       //0008

           If chkRecordExists(w_Fileusage:w_MapedBased) = w_Yes;                         //0007
              //Skip,if the file is display file. Also skip,all other object types.     //0018
              if usRefObjType = '*FILE' and usRefObjUsage <> wC;                         //0018

              //Check and append the new usage details.
              if %Scan(%trim(usRefObjUsage):w_Fileusage) = 0;
                 w_Fileusage = %trim(w_Fileusage) + wSeperator + usRefObjUsage;

                 //Update the file usage with new details.
                 exsr CorrectFileUsageSequence;                                          //0018
                 usRefObjUsage = w_Fileusage;

                 // If the record exist and already mapped as 'O' then mapped as 'O/S'   //0007
                 if w_MapedBased = 'O';                                                  //0007
                    usMapedFrom = 'O/S';                                                 //0007
                 else;                                                                   //0007
                    usMapedFrom = w_MapedBased;                                          //0007
                 endif;                                                                  //0007

                 //Update the file usage with new details.
                 Update_IAallrefpf();
              endif;                                                                     //0018
              endif;
           else;
              //If the record doesn't exist insert with map as 'S'                       //0007
              usMapedFrom = 'S';                                                         //0007

              //Insert new details in file.
              Insert_IAallrefpf();
           endif;

        endfor;

     endfor;

     //if fetched rows are less than the array elements then come out of the loop.
     if RowsFetched < noOfRows ;
        leave ;
     endif ;

     //fetched next set of rows.
     rowFound = fetchRecordSrcRefCursor();

  enddo;

  //Close the cursor.
  exec sql close GetSrcrefdetail;

endsr;

//------------------------------------------------------------------------------------- //
// dltinfo subroutine : Delete entries from iaallrefpf for refresh
//------------------------------------------------------------------------------------- //
begsr dltinfo;                                                                           //0001
                                                                                         //0001
  //Delete existing entries from iaallrefpf
  exec sql                                                                               //0001
    delete                                                                               //0001
      from  iaallrefpf                                                                   //0001
     where  Library_Name = :udPgmRefDtl.whlib                                            //0001
       and  Object_Name = :udPgmRefDtl.whpnam                                            //0001
       and  Object_Type =                                                                //0004
           case when :udPgmRefDtl.whspkg = 'V' then '*SRVPGM'                            //0004
                when :udPgmRefDtl.whspkg = 'P' then '*PGM'                               //0004
                when :udPgmRefDtl.whspkg = 'M' then '*MODULE'                            //0004
                when :udPgmRefDtl.whspkg = 'S' then '*SQLPKG'                            //0004
                when :udPgmRefDtl.whspkg = 'Q' then '*QRYDFN'                            //0004
           end                                                                           //0004
       and  Crt_Pgm_Name = :udpsds.procnme    ;                                          //0003
                                                                                         //0001
  if sqlCode < successCode;                                                              //0001
     uDpsds.wkQuery_Name = 'Delete_iaallrefpf';                                          //0001
     IaSqlDiagnostic(uDpsds);                                                            //0001 0014
  endif;                                                                                 //0001

endsr;                                                                                   //0001

//------------------------------------------------------------------------------------- //
// fetchRecordObjRefCursor: To fetch data from IAOBJREFPF
//------------------------------------------------------------------------------------- //
dcl-proc fetchRecordObjRefCursor;

  dcl-pi fetchRecordObjRefCursor ind end-pi;

  dcl-s  rcdFound ind inz('0');
  dcl-s  wkRowNum like(RowsFetched);

  RowsFetched = *zeros;
  clear udPgmRefDtl;
  clear ia_wPgmRefDtl;

  //Fetch data from file
  exec sql
    fetch GetPgmrefdetail for :noofRows rows into :ia_wPgmRefDtl;

  if sqlCode < successCode;
     uDpsds.wkQuery_Name = 'Fetch_1_Cursor_GetPgmrefdetail';
     IaSqlDiagnostic(uDpsds);                                                            //0014
  endif;

  //Get fetched no of rows
  if sqlcode = successCode;
     exec sql get diagnostics
         :wkRowNum = ROW_COUNT;
     RowsFetched  = wkRowNum ;
  endif;

  if rowsFetched > 0;
     rcdFound = TRUE;
  elseif sqlcode < successCode ;
     rcdFound = FALSE;
  endif;

  return rcdFound;

end-proc;

//------------------------------------------------------------------------------------- //
// fetchRecordSrcRefCursor: Procedure to fetch data from IASRCINTPF
//------------------------------------------------------------------------------------- //
dcl-proc fetchRecordSrcRefCursor;

  dcl-pi fetchRecordSrcRefCursor ind end-pi ;

  dcl-s  rcdFound ind inz('0');
  dcl-s  wkRowNum like(RowsFetched) ;

  RowsFetched = *zeros;
  clear udSrcRefDtl;
  clear ia_wSrcRefDtl;

  //Fetch data from file
  exec sql
     fetch GetSrcrefdetail for :noofRows rows into :ia_wSrcRefDtl;

  if sqlCode < successCode;
     uDpsds.wkQuery_Name = 'Fetch_1_Cursor_GetSrcrefdetail';
     IaSqlDiagnostic(uDpsds);                                                            //0014
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

//------------------------------------------------------------------------------------- //
// GetSrcObjectMapping: Get the source/Copybk mapping from IAOBJMAP.
//------------------------------------------------------------------------------------- //
dcl-proc  GetSrcObjectMapping ;

  dcl-pi GetSrcObjectMapping ;
     uwRowsFetched  like(wRowsFetched);
  end-pi;

  dcl-s uwObjectDtlCount uns(5)   Inz(0);

  //fetch the object references.
  //get the Number of rows to be fetched.
  exec sql
    select count(iaobjnam) into :uwObjectDtlCount
      from iaobjmap join idspobjd on
           odlbnm = iaobjlib
       and odobnm = iaobjnam
       and odobtp = iaobjtyp
     where iambrlib  = :udSrcRefDtl.iambrlib
       and iambrsrcf = :udSrcRefDtl.iambrsrc
       and iambrnam  = :udSrcRefDtl.iambrnam;

  if sqlCode < successCode;
     uDpsds.wkQuery_Name = 'Count_GetObjectmap';
     IaSqlDiagnostic(uDpsds);                                                            //0014
  endif;

  if uwObjectDtlCount <> *Zeros;

     //Check the count against no of array element.
     if uwObjectDtlCount > %Elem(udSrcObjectMap);
        uwObjectDtlCount = %elem(udSrcObjectMap);
     endif;

     //Open the Cursor.
     exec sql open GetObjectMap;

     if sqlCode = CSR_OPN_COD;
        exec sql close GetObjectMap;
        exec sql open  GetObjectMap;
     endif;

     if sqlCode < successCode;
        uDpsds.wkQuery_Name = 'Open_GetObjectMap';
        IaSqlDiagnostic(uDpsds);                                                         //0014
     endif;

     //Fetch the object mapping.
     exec sql
       fetch GetObjectMap for :uwObjectDtlCount rows Into :udSrcObjectMap;

     if sqlCode < successCode;
        uDpsds.wkQuery_Name = 'Fetch_GetObjectmap';
        IaSqlDiagnostic(uDpsds);                                                         //0014
     endif;

     //Get no of fetched rows
     if sqlcode = successCode;
        exec sql get diagnostics
          :uwRowsFetched = ROW_COUNT;
     endif;

     //Close the cursor.
     exec sql close GetObjectMap;
  endif;

  //Get the copy book references if no object mapping exist.
  if uwRowsFetched = *Zeros;

     clear uwObjectDtlCount;

     //get the Number of rows to be fetched.
     exec sql
       Select count(B.iAMbrNam) into :uwObjectDtlCount                                   //0015
         from iACpybDtl A                                                                //0015
         join iAObjMap B on                                                              //0015
              A.iAMbrLib   = B.iAMbrLib                                                  //0015
          and A.iAMbrSrcPf = B.iAMbrSrcf                                                 //0015
          and A.iAMbrName  = B.iAMbrNam                                                  //0015
        where A.iACpyLib   = :udSrcRefDtl.iAMbrLib                                       //0015
          and A.iACpySrcPf = :udSrcRefDtl.iAMbrSrc                                       //0015
          and A.iACpyMbr   = :udSrcRefDtl.iAMbrNam;                                      //0015

     if sqlCode < successCode;
        uDpsds.wkQuery_Name = 'Count_GetCopybkMap';
        IaSqlDiagnostic(uDpsds);                                                         //0014
     endif;

     if uwObjectDtlCount <> *Zeros;

        //Check the count against no of array element.
        if uwObjectDtlCount > %Elem(udSrcObjectMap);
           uwObjectDtlCount = %elem(udSrcObjectMap);
        endif;

        //Open the Cursor.
        exec sql open GetCopybkMap;

        if sqlCode = CSR_OPN_COD;
           exec sql close GetCopybkMap;
           exec sql open  GetCopybkMap;
        endif;

        if sqlCode < successCode;
           uDpsds.wkQuery_Name = 'Open_GetCopybkMap';
           IaSqlDiagnostic(uDpsds);                                                      //0014
        endif;

        //Fetch the Copy book mapping.
        exec sql
          fetch GetCopybkMap for :uwObjectDtlCount rows into :udSrcObjectMap;

        if sqlCode < successCode;
           uDpsds.wkQuery_Name = 'Fetch_GetCopybkMap';
           IaSqlDiagnostic(uDpsds);                                                      //0014
        endif;

        //Get no of fetched rows
        if sqlcode = successCode;
           exec sql get diagnostics
             :uwRowsFetched = ROW_COUNT;
        endif;

        //Close the cursor.
        exec sql close GetCopybkMap;
     endif;
  endif;

  Return ;

end-proc;

//------------------------------------------------------------------------------------- //
// chkRecordExists: Check whether referenced object exists or not
//------------------------------------------------------------------------------------- //
dcl-proc  chkRecordExists;

  dcl-pi chkRecordExists Char(1);
     w_Fusage like (w_Fileusage);
     w_MapedBased like(usMapedFrom);                                                     //0007
  end-pi;

  dcl-s w_Rcdexist char(1) inz('N');
  clear w_Fusage;

  if usRefObjLib <> *Blanks;                                                             //0016
     exec sql
       select 'Y', iarusages, iamapfrm                                                   //0007
         into :w_Rcdexist, :w_Fusage, :w_MapedBased                                      //0007
         from iaallrefpf
        where iaoobjlib = :usObjectLib
          and iaoobjnam = :usObjectName
          and iaoobjtyp = :usObjectType
          and iarobjnam = :usRefObjName
          and iarobjtyp = :usRefObjType
          and iarobjlib = :usRefObjLib ;
  else;                                                                                  //0016
     exec sql                                                                            //0016
       select 'Y', iarusages, iamapfrm                                                   //0016
         into :w_Rcdexist, :w_Fusage, :w_MapedBased                                      //0016
         from iaallrefpf                                                                 //0016
        where iaoobjlib = :usObjectLib                                                   //0016
          and iaoobjnam = :usObjectName                                                  //0016
          and iaoobjtyp = :usObjectType                                                  //0016
          and iarobjnam = :usRefObjName                                                  //0016
          and iarobjtyp = :usRefObjType                                                  //0019
        limit 1;                                                                         //0019

  endif;                                                                                 //0016

  if sqlCode < successCode;
     uDpsds.wkquery_Name = 'Check_Dup_IAALLREFPF';
     IaSqlDiagnostic(uDpsds);                                                            //0014
  endif;

  return w_Rcdexist ;

end-proc;

//------------------------------------------------------------------------------------- //
// Update_IAallrefpf: Update referenced detail in IAALLREFPF
//------------------------------------------------------------------------------------- //
Dcl-proc Update_IAallrefpf;

  dcl-pi Update_IAallrefpf;
  end-pi;

  exec sql
    update iaallrefpf
       set iarusages = :usRefObjUsage,
           iaupdpgmn = :uDpsds.ProcNme,
           iamapfrm  = :usMapedFrom,                                                     //0007
           iaupdusrn = current_user
     where iaoobjlib = :usObjectLib
       and iaoobjnam = :usObjectName
       and iaoobjtyp = :usObjectType
       and iarobjnam = :usRefObjName
       and iarobjtyp = :usRefObjType
       and iarobjlib = :usRefObjLib;

  if sqlCode < successCode;
    uDpsds.wkQuery_Name = 'Update_IAALLREFPF';
    IaSqlDiagnostic(uDpsds);                                                             //0014
  endif;

  return;

end-proc;

//------------------------------------------------------------------------------------- //
// Insert_IAallrefpf: Insert IAALLREFPF procedure
//------------------------------------------------------------------------------------- //
dcl-proc Insert_IAallrefpf;

  dcl-pi Insert_IAallrefpf;
  end-pi;

  exec sql
    insert into iaallrefpf (library_name,
                            object_name,
                            object_type,
                            object_attr,
                            object_text,
                            referenced_obj,
                            referenced_objtyp,
                            referenced_objlib,
                            referenced_objusg,
                            referenced_objatr,                                           //0017
                            maped_from,                                                  //0007
                            crt_pgm_name,
                            crt_usr_name)
                     Values (:usObjectLib,
                             :usObjectName,
                             :usObjectType,
                             :usObjectAttr,
                             :usObjectTxt,
                             :usRefObjName,
                             :usRefObjType,
                             :usRefObjLib,
                             :usRefObjUsage,
                             :usRefObjAttr,                                              //0017
                             :usMapedFrom,                                               //0007
                             :uDpsds.ProcNme,
                             current_user );

  if sqlCode < successCode;
     uDpsds.wkQuery_Name = 'Insert_IAALLREFPF';
     IaSqlDiagnostic(uDpsds);                                                            //0014
  endif;

  return;

end-proc;
