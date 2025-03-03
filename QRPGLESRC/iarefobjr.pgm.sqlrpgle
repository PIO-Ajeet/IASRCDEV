**Free
      //%METADATA                                                      *
      // %TEXT IA Refresh Program to create IAREFOBJF MOD/NEW/DEL      *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------- //
//Created By  : Programmers.io @ 2023                                                   //
//Created Date: 2023/05/13                                                              //
//Developer   : Joshua Nadar                                                            //
//Description : This program identifies the newly added, modified and deleted           //
//              members/objects and populate the file IAREFOBJF for Refresh Process.    //
//                                                                                      //
//Modification Log:                                                                     //
//------------------------------------------------------------------------------------- //
//Date    | Mod_ID | Developer  | Case and Description                                  //
//--------| -------|------------|------------------------------------------------------ //
//        |        |            |                                                       //
//01/12/23| 0001   |Akshay S.   |Refresh : Incorrect entries in IAREFOBJF. Task#401     //
//        |        |            |                                                       //
//18/12/23| 0002   |Akhil K.    |Refresh : Added an entry parameter. At the end of the  //
//        |        |            |program, it will have 'Y' if any object or member is   //
//        |        |            |with status 'A' or 'M'. If there are no such, then 'N'.//
//        |        |            |Task #463                                              //
//29/12/23| 0003   |Akshay S.   |Refresh : Records missing in IAREFOBJF if multiple     //
//        |        |            |members having same name in diffrent srcfiles. Deleted //
//        |        |            |the existence check of member and object logic. #503   //
//02/01/24| 0004   |Saikiran    |Refresh :                                              //
//        |        |            |- For Modified or Newly added members, Avoid the       //
//        |        |            |  population of members, to IAREFOBJF file, which are  //
//        |        |            |  in Exclusion list.                                   //
//        |        |            |- If any exclusion is added during refresh, populate   //
//        |        |            |  the IAREFOBJF with Status 'D' (Task#500)             //
//        |        |            |- Replaced IDSPFDMBRL from the repo with the IAMEMBER  //
//        |        |            |  file                                                 //
//08/02/24| 0005   | Vamsi      | Reset the flag for the member/object marked as        //
//        |        | Krishna2   | new/modified in the last refresh run, in order to     //
//        |        |            | avoid conflict with the current refresh process.      //
//        |        |            | (Task#575)                                            //
//08/03/24| 0006   | Bhavit     |REFRESH: Exclusion of Source file alone or the         //
//      |        |   Jain     |combination of Source file + Library happens then      //
//       |        |            |exclusion will fail. [Task#586]                        //
//24/02/01| 0007   |Himanshuga &|Object Exclusion for refresh. Task#535                 //
//        |        |Mahima      |Currently following combinations(AIEXCOBJS) are valid  //
//        |        |            |1.Library,Object 2.Library,Object* 3.Object,Type       //
//        |        |            |4.Library,Object,Type 5.Library,Object*,Type           //
//        |        |            |6.Object,7.Object*           '*'means wild card        //
//23/10/04| 0008   | Khushi W   | Rename AIEXCOBJS to IAEXCOBJS [Task #252]             //
//05/07/24| 0009   | Akhil K.   | Renamed AIERRBND, AICERRLOG, AIDERRLOG and AISQLDIAGNO//
//        |        |            | STIC with IA*                                         //
//20/08/24| 0010   | Sabarish   | IFS Member Parsing                                    //
//------------------------------------------------------------------------------------- //
ctl-opt CopyRight('Copyright @ Programmers.io © 2023 ');
ctl-opt Option(*NoDebugIo:*SrcStmt:*NoUnref);
ctl-opt BndDir('IABNDDIR' : 'IAERRBND');                                                 //0009

//-------------------------FILE DEFINITIONS----------------------------------------*    //0007
//Object exclusion control table                                                        //0007
dcl-f IAEXCOBJS  disk usage(*input) keyed;                                               //0008
//IA Refresh Object/Member table                                                        //0007
dcl-f IAREFOBJF  disk usage(*update : *output : *delete);                                //0007

//Main Program Prototype interface
dcl-pi IAREFOBJR extpgm('IAREFOBJR');
   uwxref       char(10) options(*nopass);
   uwProg       char(74) options(*nopass);
   uwRefreshErr char(01) options(*nopass);
   uwrcdfnd     char(1)  options(*nopass);                                               //0002
end-pi;

//CopyBooks
/copy 'QMODSRC/iasrv01pr.rpgleinc'
/copy 'QCPYSRC/iaderrlog.rpgleinc'

//Prototype declaration
dcl-pr IAEXCTIMR extpgm('IAEXCTIMR');                                                    //0008
   *n Char(10) Const;
   *n Char(10);
   *n Char(10);
   *n Char(10) Const;
   *n Char(10);
   *n Char(10);
   *n Char(10);
   *n Char(100) Const;                                                                   //0010
   *n Char(10) Const;
   *n Timestamp;
   *n Char(6) Const;
end-pr;

//DS declaration
dcl-ds DspObjDS;
   wODLBNM char(10);
   wODOBNM char(10);
   wODOBTP char(8);
   wODOBAT char(10);
   wODCDAT char(6);
   wODCTIM char(6);
   wODLDAT char(6);
   wODLTIM char(6);
   wODSRCF char(10);
   wODSRCL char(10);
   wODSRCM char(10);
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

//Variable declaration
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
dcl-s wkRefreshTimeStamp char(26) inz;
dcl-s ObjRefType         char(1) inz;
dcl-s exclusion_Flag     char(1);

//Constant declaration

//-------------------------------------------------------------------------------------//
//Mainline Programming                                                                 //
//-------------------------------------------------------------------------------------//
exec sql
  set option commit    = *none,
             naming    = *sys,
             usrprf    = *user,
             dynusrprf = *user,
             closqlcsr = *endmod;

Eval-corr uDpsds = wkuDpsds;
uptimeStamp = %Timestamp();

callP IAEXCTIMR('BLDMTADTA':udpsds.ProcNme  : udpsds.Lib : '*PGM' :                      //0008
                 upsrc_name : uppgm_name : uplib_name : ' ' :
                 //0010 uptimeStamp : 'INSERT');
                 ' ' : uptimeStamp : 'INSERT');                                          //0010

clear command;
uwRefreshErr = 'N';

//Clear Refresh flags in IAOBJECT and IAMEMBER files                                    //0005
exec sql update iAMember set iARefFlg = ' '                                              //0005
         where  iARefFlg in ('A','M');                                                   //0005
if sqlCode < successCode;                                                                //0005
   uDpsds.wkQuery_Name = 'Update_iAMember';                                              //0005
   IaSqlDiagnostic(uDpsds);                                                              //0009
endif;                                                                                   //0005
                                                                                         //0005
exec sql update iAObject set iARefresh = ' '                                             //0005
         where  iARefresh in ('A','M');                                                  //0005
if sqlCode < successCode;                                                                //0005
   uDpsds.wkQuery_Name = 'Update_iAObject';                                              //0005
   IaSqlDiagnostic(uDpsds);                                                              //0009
endif;                                                                                   //0005

//Find Modified Objects
findModifiedObjects();

//Find Newly Added Objects
findNewlyAddedObjects();

//Find Deleted Objects
findDeletedObjects();

//Find Modified Members
findModifiedMembers();

//Find Newly Added Members
findNewlyAddedMembers();

//Find Deleted Members
findDeletedMembers();

//process object exclusions                                                             //0007
processObjectExclusion();                                                                //0007
                                                                                         //0007
//To check for any member or object with 'A' or 'M' status in IAREFOBJF                 //0002
exec sql                                                                                 //0002
  select 'Y' into :uwrcdfnd                                                              //0002
    from iARefObjF                                                                       //0002
   where iAStatus in ('A','M')                                                           //0002
   limit 1;                                                                              //0002
                                                                                         //0002
if sqlCode < successCode;                                                                //0002
   uwrcdfnd = 'N';                                                                       //0002
   uDpsds.wkQuery_Name = 'Select_IAREFOBJF';                                             //0002
   IaSqlDiagnostic(uDpsds);                                                              //0009
endif;                                                                                   //0002
                                                                                         //0002
//If no object or member with status 'A' or 'M'                                         //0002
if sqlCode = NO_DATA_FOUND;                                                              //0002
   uwrcdfnd = 'N';                                                                       //0002
endif;                                                                                   //0002
                                                                                         //0002
upTimeStamp = %Timestamp();

callP IAEXCTIMR('BLDMTADTA': udpsds.ProcNme  : udpsds.Lib : '*PGM' :                     //0008
                 upsrc_name : uppgm_name : uplib_name : ' ' :
                 //0010 uptimeStamp : 'UPDATE');
                 ' ' : uptimeStamp : 'UPDATE');                                          //0010

*inlr = *on;
return;

/copy 'QCPYSRC/iacerrlog.rpgleinc'

//------------------------------------------------------------------------------------- //
//Procedure   : findNewlyAddedObjects
//Description : We are finding the records from IDSPOBJD which exactly matches IDSPOBJD
//              meaning now we have only the new and modified objects in IDSPOBJD
//------------------------------------------------------------------------------------- //
dcl-proc findNewlyAddedObjects;

  dcl-ds pIDspObjDS  likeDS(DspObjDS)   inz;
  dcl-s memberChangeDateYMD char(6) inz;

  //Cursor to find objects that were modified
  exec sql
    declare findNewlyAddedObjects_Cursor cursor For
      Select ODLBNM, ODOBNM, ODOBTP,ODOBAT, ODCDAT, ODCTIM, ODLDAT, ODLTIM,
             ODSRCF, ODSRCL, ODSRCM
        From QTEMP/IDSPOBJD T Where Not Exists
          (Select * from IDSPOBJD I
          Where T.ODLBNM = I.ODLBNM
            and T.ODOBNM = I.ODOBNM
            and T.ODOBTP = I.ODOBTP );

  exec sql open findNewlyAddedObjects_Cursor;
  if sqlCode = CSR_OPN_COD;
     exec sql close findNewlyAddedObjects_Cursor;
     exec sql open  findNewlyAddedObjects_Cursor;
  endif;

  if sqlCode < successCode;
     uDpsds.wkQuery_Name = 'open_findNewlyAddedObjects_Cursor';
     IaSqlDiagnostic(uDpsds);                                                            //0009
  endif;

  exec sql fetch next from findNewlyAddedObjects_Cursor into :pIDspObjDS;
  if sqlCode < successCode;
     uDpsds.wkQuery_Name = 'fetch_1_findNewlyAddedObjects_Cursor';
     IaSqlDiagnostic(uDpsds);                                                            //0009
  endif;

  dow sqlCode = successCode;

     //Write the newly added objects & source details into iarefobjf table
     WriteModAddDelObjSrcDetail(pIDspObjDS.wODOBNM   :                           // Object Name
                                pIDspObjDS.wODLBNM   :                           // Object Library
                                pIDspObjDS.wODOBTP   :                           // Object Type
                                pIDspObjDS.wODOBAT   :                           // Object Attr
                                *Blanks              :                           // Member Name
                                *Blanks              :                           // Member Lib
                                *Blanks              :                           // Src Pf Name
                                *blanks              :                           // Member Type
                                'A');                                            // Status

     exec sql fetch next from findNewlyAddedObjects_Cursor into :pIDspObjDS;
     if sqlCode < successCode;
        uDpsds.wkQuery_Name = 'fetch_2_findNewlyAddedObjects_Cursor';
        IaSqlDiagnostic(uDpsds);                                                         //0009
        Leave;
     endif;

  enddo;

  exec sql close findNewlyAddedObjects_Cursor;

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   : findNewlyAddedMembers
//Description : We are finding the records from IDSPFDMBRL which exactly matches
//              IDSPFDMBRL, meaning now we have only the new and modified members in
//              IDSPFDMBRL
//------------------------------------------------------------------------------------- //
dcl-proc findNewlyAddedMembers;

  dcl-ds pIDspfdMbrLDS  likeDS(DspfdMbrLDS) inz;

  //Cursor to find newly added members
  exec sql
    declare findNewlyAddedMembers_Cursor cursor For
      select MLLIB, MLNAME, MLFILE, MLSEU2, MLCDAT, MLCHGD, MLCHGT
        from QTEMP/IDSPFDMBRL T Where Not Exists
          (Select * from IAMEMBER I                                                      //0004
             Where T.MLLIB   = I.IASRCLIB                                                //0004
               and T.MLNAME  = I.IAMBRNAM                                                //0004
               and T.MLFILE  = I.IASRCPFNAM                                              //0004
               and T.MLSEU2  = I.IAMBRTYPE )                                             //0004
               and MLNAME <> ' '                                                         //0004
               and not Exists                                                            //0004
          (Select * from IAXSRCPF A                                                      //0004
            Where A.IASRCFILE = T.MLFILE                                                 //0004
              and A.IASRCLIB  = T.MLLIB                                                  //0004
              and A.IASRCMBR  = T.MLNAME);                                               //0004

  //Open the cursor for findNewlyAddedMembers_Cursor
  exec sql open findNewlyAddedMembers_Cursor;
  if sqlCode = CSR_OPN_COD;
     exec sql close findNewlyAddedMembers_Cursor;
     exec sql open  findNewlyAddedMembers_Cursor;
  endif;

  if sqlCode < successCode;
     uDpsds.wkQuery_Name = 'open_findNewlyAddedMembers_Cursor';
     IaSqlDiagnostic(uDpsds);                                                            //0009
  endif;

  //Fetch the cursor for findNewlyAddedMembers_Cursor
  exec sql fetch next from findNewlyAddedMembers_Cursor into :pIDspfdMbrLDs;
  if sqlCode < successCode;
     uDpsds.wkQuery_Name = 'fetch_1_findNewlyAddedMembers_Cursor';
     IaSqlDiagnostic(uDpsds);                                                            //0009
  endif;

  //Process each record of IDSPFDMBRL
  dow sqlCode = successCode;

     //Write the Modified, added, deleted objects & source details into iarefobjf table
     WriteModAddDelObjSrcDetail(*blanks              :
                                *blanks              :
                                *blanks              :
                                *blanks              :
                                pIDspfdMbrLDs.wMLNAME:
                                pIDspfdMbrLDs.wMLLIB :
                                pIDspfdMbrLDs.wMLFILE:
                                pIDspfdMbrLDs.WMLSEU2:
                                'A');


     //Fetch details into Table IAREFOBJF
     exec sql fetch next from findNewlyAddedMembers_Cursor into :pIDspfdMbrLDs;
     if sqlCode < successCode;
        uDpsds.wkQuery_Name = 'fetch_2_findNewlyAddedMembers_Cursor';
        IaSqlDiagnostic(uDpsds);                                                         //0009
        leave;
     endif;

  enddo;

  exec sql close findNewlyAddedMembers_Cursor;

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   : findDeletedObjects
//Description : We are finding all the objects from IDSPOBJD (captured in last run)
//              which do not exist in IDSPOBJD (objects from current run)
//------------------------------------------------------------------------------------- //
dcl-proc findDeletedObjects;

  dcl-ds pIDspObjDS  likeDS(DspObjDS) inz;

  //Cursor to find objects that were deleted
  exec sql
    declare findDeletedObjects_Cursor cursor For
      Select ODLBNM, ODOBNM, ODOBTP, ODOBAT, ODCDAT, ODCTIM, ODLDAT, ODLTIM,
             ODSRCF, ODSRCL, ODSRCM
        From IDSPOBJD I Where not exists
          (Select * from QTEMP/IDSPOBJD T
             Where T.ODLBNM = I.ODLBNM
               and T.ODOBNM = I.ODOBNM
               and T.ODOBTP = I.ODOBTP );

  exec sql open findDeletedObjects_Cursor;
  if sqlCode = CSR_OPN_COD;
     exec sql close findDeletedObjects_Cursor;
     exec sql open  findDeletedObjects_Cursor;
  endif;

  if sqlCode < successCode;
     uDpsds.wkQuery_Name = 'open_findDeletedObjects_Cursor';
     IaSqlDiagnostic(uDpsds);                                                            //0009
  endif;

  exec sql fetch next from findDeletedObjects_Cursor into :pIDspObjDS;
  if sqlCode < successCode;
     uDpsds.wkQuery_Name = 'fetch_1_findDeletedObjects_Cursor';
     IaSqlDiagnostic(uDpsds);                                                            //0009
  endif;

  //Process each record of IDSPOBJD
  dow sqlCode = successCode;
     //Write the deleted objects details into iarefobjf table
     WriteModAddDelObjSrcDetail(pIDspObjDS.wODOBNM   :
                                pIDspObjDS.wODLBNM   :                           // Object Name
                                pIDspObjDS.wODOBTP   :                           // Object Library
                                pIDspObjDS.wODOBAT   :                           // Object Type
                                *blanks              :                           // Object Attr
                                *blanks              :                           // Member Name
                                *blanks              :                          // Source Physical N
                                *blanks              :                           // Member Type
                                'D');                                            // Modified Object
                                                                                // Status

     exec sql fetch next from findDeletedObjects_Cursor into :pIDspObjDS;
     if sqlCode < successCode;
        uDpsds.wkQuery_Name = 'fetch_2_findDeletedObjects_Cursor';
        IaSqlDiagnostic(uDpsds);                                                         //0009
        leave;
     endif;

  enddo;

  exec sql close findDeletedObjects_Cursor;

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   : find eletedMembers
//Description : We are finding all the members from IDSPFDMBRL (captured in last run)
//              which do not exist in IDSPFDMBRL (members from current run)
//------------------------------------------------------------------------------------- //
dcl-proc findDeletedMembers;

  dcl-ds pIDspfdMbrLDS  likeDS(DspfdMbrLDS) inz;

  //Cursor to find members that were deleted
  exec sql
    declare findDeletedMembers_Cursor cursor For
      Select IASRCLIB, IAMBRNAM, IASRCPFNAM, IAMBRTYPE,                                  //0004
             IACDAT, IACHGD, IACHGT                                                      //0004
        From IAMEMBER I Where not exists                                                 //0004
     (Select * from qtemp/IDSPFDMBRL T                                                   //0004
       Where I.IASRCLIB   = T.MLLIB                                                      //0004
         and I.IAMBRNAM   = T.MLNAME                                                     //0004
         and I.IASRCPFNAM = T.MLFILE                                                     //0004
         and I.IAMBRTYPE  = T.MLSEU2)                                                    //0004
         and IAMBRNAM <> ' '                                                             //0004
          or exists                                                                      //0004
     (Select * from IAXSRCPF A                                                           //0004
       Where (A.IASRCFILE = I.IASRCPFNAM                                                 //0004
         and  A.IASRCLIB  = I.IASRCLIB                                                   //0004
         and  A.IASRCMBR  = I.IAMBRNAM));                                                //0004

  //Open the Cursor for findDeletedMembers_Cursor
  exec sql open findDeletedMembers_Cursor;
  if sqlCode = CSR_OPN_COD;
     exec sql close findDeletedMembers_Cursor;
     exec sql open  findDeletedMembers_Cursor;
  endif;

  if sqlCode < successCode;
     uDpsds.wkQuery_Name = 'open_findDeletedMembers_Cursor';
     IaSqlDiagnostic(uDpsds);                                                            //0009
  endif;

  exec sql fetch next from findDeletedMembers_Cursor into :pIDspfdMbrLDs;
  if sqlCode < successCode;
     uDpsds.wkQuery_Name = 'fetch_1_findDeletedMembers_Cursor';
     IaSqlDiagnostic(uDpsds);                                                            //0009
  endif;

  //Process each record of IDSPFDMBRL
  dow sqlCode = successCode;

     exclusion_Flag = '0';                                                               //0006

     //Checking for the Source file and Library                                         //0006
     exec sql                                                                            //0006
       Select '1' into :exclusion_Flag                                                   //0006
         from IaXSrcPf                                                                   //0006
        Where IaSrcFile = :pIDspfdMbrLDs.wMLFILE                                         //0006
          and IaSrcLib  = :pIDspfdMbrLDs.wMLLIB                                          //0006
          and IaSrcMbr  = ' ';                                                           //0006

     //Checking for the Source file                                                     //0006
     if exclusion_Flag = '0';                                                            //0006
       exec sql                                                                          //0006
         Select '1' into :exclusion_Flag                                                 //0006
           from IaXSrcPf                                                                 //0006
          Where IaSrcFile = :pIDspfdMbrLDs.wMLFILE                                       //0006
            and IaSrcLib  = ' '                                                          //0006
            and IaSrcMbr  = ' ';                                                         //0006
     endif;                                                                              //0006

     if exclusion_Flag = '0';                                                            //0006
        //Write the Modified, added, deleted objects & source details into iarefobjf table
        WriteModAddDelObjSrcDetail(*blanks              :                         // Object Name
                                   *blanks              :                         // Object Library
                                   *blanks              :                         // Object Type
                                   *blanks              :                         // Object Attr
                                   pIDspfdMbrLDs.wMLNAME:                         // Member Name
                                   pIDspfdMbrLDs.wMLLIB :                         // Member Type
                                   pIDspfdMbrLDs.wMLFILE:                         // Physical File
                                 pIDspfdMbrLDs.WMLSEU2:                           // Modified Object
                                   'D');                                          // Status
     endif;                                                                              //0006

     exec sql fetch next from findDeletedMembers_Cursor into :pIDspfdMbrLDs;
     if sqlCode < successCode;
        uDpsds.wkQuery_Name = 'fetch_2_findDeletedMembers_Cursor';
        IaSqlDiagnostic(uDpsds);                                                         //0009
        leave;
     endif;

  enddo;

  exec sql close findDeletedMembers_Cursor;

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   : findModifiedObjects
//Description : find the objects that were modified after the last build
//------------------------------------------------------------------------------------- //
dcl-proc findModifiedObjects;

  dcl-ds pIDspObjDS  likeDS(DspObjDS)   inz;
  dcl-s memberChangeDateYMD char(6) inz;

  //Cursor to find objects that were modified
  exec sql
    declare findModifiedObjects_Cursor cursor For
      Select ODLBNM, ODOBNM, ODOBTP, ODOBAT, ODCDAT, ODCTIM, ODLDAT, ODLTIM,
             ODSRCF, ODSRCL, ODSRCM
        From IDSPOBJD I Where Exists
          (Select * from QTEMP/IDSPOBJD T
             Where T.ODLBNM = I.ODLBNM
               and T.ODOBNM = I.ODOBNM
               and T.ODOBTP = I.ODOBTP
               and ((T.ODCDAT <> I.ODCDAT
                or T.ODCTIM <> I.ODCTIM)
                or (T.ODLDAT <> I.ODLDAT
                or T.ODLTIM <> I.ODLTIM)));

  exec sql open findModifiedObjects_Cursor;
  if sqlCode = CSR_OPN_COD;
     exec sql close findModifiedObjects_Cursor;
     exec sql open  findModifiedObjects_Cursor;
  endif;

  if sqlCode < successCode;
     uDpsds.wkQuery_Name = 'open_findModifiedObjects_Cursor';
     IaSqlDiagnostic(uDpsds);                                                            //0009
  endif;

  exec sql fetch next from findModifiedObjects_Cursor into :pIDspObjDS;
  if sqlCode < successCode;
     uDpsds.wkQuery_Name = 'fetch_1_findModifiedObjects_Cursor';
     IaSqlDiagnostic(uDpsds);                                                            //0009
  endif;

  //Process each record of IDSPOBJD
  dow sqlCode = successCode;

     //Write the Modified objects & source details into iarefobjf table
     WriteModAddDelObjSrcDetail(pIDspObjDS.wODOBNM   :                           // Object Name
                                pIDspObjDS.wODLBNM   :                           // Object Library
                                pIDspObjDS.wODOBTP   :                           // Object Type
                                pIDspObjDS.wODOBAT   :                           // Object Attr
                                *blanks              :                           // Member Name
                                *blanks              :                           // Member Lib
                                *blanks              :                           // Src Pf
                                *blanks              :                           // Member Type
                                'M');                                            // Status


     exec sql fetch next from findModifiedObjects_Cursor into :pIDspObjDS;
     if sqlCode < successCode;
        uDpsds.wkQuery_Name = 'fetch_2_findModifiedObjects_Cursor';
        IaSqlDiagnostic(uDpsds);                                                         //0009
        leave;
     endif;

  enddo;

  exec sql close findModifiedObjects_Cursor;

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   : findModifiedMembers
//Description : find the members that were modified after the last build
//------------------------------------------------------------------------------------- //
dcl-proc findModifiedMembers;

  dcl-ds pIDspfdMbrLDS  likeDS(DspfdMbrLDS) inz;

  //Cursor to find members that were modified
  exec sql
    declare findModifiedMembers_Cursor cursor For
      Select IASRCLIB, IAMBRNAM, IASRCPFNAM, IAMBRTYPE,                                  //0004
             IACDAT, IACHGD, IACHGT                                                      //0004
        From IAMEMBER I Where Exists                                                     //0004
          (Select * from QTEMP/IDSPFDMBRL T                                              //0004
             Where T.MLLIB   = I.IASRCLIB                                                //0004
               and T.MLNAME  = I.IAMBRNAM                                                //0004
               and T.MLFILE  = I.IASRCPFNAM                                              //0004
               and T.MLSEU2  = I.IAMBRTYPE                                               //0004
               and T.MLCDAT  = I.IACDAT                                                  //0004
               and (T.MLCHGD <> I.IACHGD                                                 //0004
                or T.MLCHGT <> I.IACHGT)                                                 //0004
               and not Exists                                                            //0004
           (Select * from IAXSRCPF A                                                     //0004
             Where A.IASRCFILE = T.MLFILE                                                //0004
               and A.IASRCLIB  = T.MLLIB                                                 //0004
               and A.IASRCMBR  = T.MLNAME));                                             //0004

  //Open the cursor for findModifiedMembers_Cursor
  exec sql open findModifiedMembers_Cursor;
  if sqlCode = CSR_OPN_COD;
     exec sql close findModifiedMembers_Cursor;
     exec sql open  findModifiedMembers_Cursor;
  endif;

  if sqlCode < successCode;
     uDpsds.wkQuery_Name = 'open_findModifiedMembers_Cursor';
     IaSqlDiagnostic(uDpsds);                                                            //0009
  endif;

  //Fetch the cursor for findModifiedMembers_Cursor
  exec sql fetch next from findModifiedMembers_Cursor into :pIDspfdMbrLDs;
  if sqlCode < successCode;
     uDpsds.wkQuery_Name = 'fetch_1_findModifiedMembers_Cursor';
     IaSqlDiagnostic(uDpsds);                                                            //0009
  endif;

  //Process each record of IDSPFDMBRL
  dow sqlCode = successCode;

     //Write the Modified, added, deleted objects & source details into iarefobjf table
     WriteModAddDelObjSrcDetail(*blanks              :
                                *blanks              :
                                *blanks              :
                                *blanks              :
                                pIDspfdMbrLDs.wMLNAME:
                                pIDspfdMbrLDs.wMLLIB :
                                pIDspfdMbrLDs.wMLFILE:
                                pIDspfdMbrLDs.WMLSEU2:
                                'M');


     //Fetch details into Table IAREFOBJF
     exec sql fetch next from findModifiedMembers_Cursor into :pIDspfdMbrLDs;
     if sqlCode < successCode;
        uDpsds.wkQuery_Name = 'fetch_2_findModifiedMembers_Cursor';
        IaSqlDiagnostic(uDpsds);                                                         //0009
        leave;
     endif;

  enddo;

  exec sql close findModifiedMembers_Cursor;

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   : WriteModAddDelObjSrcDetail
//Description : Write the record to table IAREFOBJF
//------------------------------------------------------------------------------------- //
dcl-proc WriteModAddDelObjSrcDetail;

  dcl-pi *n;
     pObjName          char(10) const;
     pObjLibrary       char(10) const;
     pObjType          char(7)  const;
     pObjAttr          char(10) const;
     pMbrName          char(10) const;
     pMbrLibrary       char(10) const;
     pSrcPFName        char(10) const;
     pMbrType          char(10) const;
     pStatus           char(1)  const;
  end-pi;

  //Skip to write, if object is source file
  exclusion_Flag = '0';

  if pobjName <> *blanks;
    exec sql
      select '1' into :exclusion_Flag
        from IASRCPF
       where XSRCPF  = :pObjName
         and XLIBNAM = :pObjLibrary
       limit 1;
  endif;

  if exclusion_Flag = '0';
     exec sql Insert into IAREFOBJF   ( IAOBJNAME ,
                                       IAOBJLIB  ,
                                       IAOBJTYPE ,
                                       IAOBJATTR ,
                                       IAMEMNAME ,
                                       IAMEMLIB ,
                                       IASRCPF   ,
                                       IAMEMTYPE ,
                                       IASTATUS )
                             Values ( :pObjName    ,
                                      :pObjLibrary ,
                                      :pObjType    ,
                                      :pObjAttr    ,
                                      :pMbrName    ,
                                      :pMbrLibrary ,
                                      :pSrcPFName  ,
                                      :pMbrType    ,
                                      :pStatus ) ;
     if sqlCode < successCode;
        uDpsds.wkQuery_Name = 'Insert_IAREFOBJ_1';
        IaSqlDiagnostic(uDpsds);                                                         //0009
     endif;
  endif;

end-proc;

//------------------------------------------------------------------------------------- //0007
//Procedure: processObjectExclusion                                                     //0007
//Description: write excluded object into IAREFOBJF with REF_Flag = D,refresh will      //0007
//           : further handle the deletion                                              //0007
//           : Also check if IAREFOBJF contains excluded objects                        //0007
//------------------------------------------------------------------------------------- //0007
dcl-proc processObjectExclusion;                                                         //0007
                                                                                         //0007
  dcl-s wkSqlStmt       varchar(1000);                                                   //0007
  dcl-s wkStarPosition  packed(3:0) inz;                                                 //0007
                                                                                         //0007
  dcl-c singleQuote     const('''');                                                     //0007
                                                                                         //0007
  exsr checkIfExcludedObjectInIAREFOBJF;                                                 //0007
                                                                                         //0007
  exsr writeExcludedObjectsIntoIAREFOBJF;                                                //0007
                                                                                         //0007
  //----------------------------------------------------------------------------------- //0007
  //Subroutine: checkIfExcludedObjectInIAREFOBJF                                        //0007
  //Function: check if excluded objects are present in IAREFOBJF                        //0007
  //        : If present with A flag we will delete entry from IAREFOBJF                //0007
  //        : If present with M flag we will update IASTATUS = 'D'                      //0007
  //----------------------------------------------------------------------------------- //0007
  begsr checkIfExcludedObjectInIAREFOBJF;                                                //0007
                                                                                         //0007
     setll *start IAREFOBJF;                                                             //0007
     read IAREFOBJF;                                                                     //0007
                                                                                         //0007
     dow not %Eof();                                                                     //0007
                                                                                         //0007
        if IaobjName <> *Blanks And IaobjLib <> *Blanks                                  //0007
           and IaobjType <> *Blanks;                                                     //0007
           //if newly added object is in excl list,refresh should not pick it           //0007
           //if modified object is in excl list,refresh should treat it as deleted      //0007
           //so that its entries are removed from IA files/outfiles.                    //0007
           if isObjectExcluded(IaobjName : IaobjLib : IaobjType);                        //0007
                                                                                         //0007
              select;                                                                    //0007
                 when Iastatus = 'A';                                                    //0007
                    Delete(E) IAREFOBJF;                                                 //0007
                                                                                         //0007
                    if %Error();                                                         //0007
                       uDpsds.wkQuery_Name = 'delete_IAREFOBJF';                         //0007
                       IaSqlDiagnostic(uDpsds);                                          //0009
                    endif;                                                               //0007
                                                                                         //0007
                 when Iastatus = 'M';                                                    //0007
                    Iastatus = 'D';                                                      //0007
                    Update(E) IAREFOBJFR;                                                //0007
                                                                                         //0007
                    if %Error();                                                         //0007
                       uDpsds.wkQuery_Name = 'update_IAREFOBJF';                         //0007
                       IaSqlDiagnostic(uDpsds);                                          //0009
                    endif;                                                               //0007
              endsl;                                                                     //0007
                                                                                         //0007
           endif;                                                                        //0007
                                                                                         //0007
        endif;                                                                           //0007
                                                                                         //0007
        read IAREFOBJF;                                                                  //0007
     enddo;                                                                              //0007
                                                                                         //0007
   endsr;                                                                                //0007
                                                                                         //0007
   //---------------------------------------------------------------------------------- //0007
   //Subroutine: writeExcludedObjectsIntoIAREFOBJF                                      //0007
   //Function: In case if an object is included in INIT process and we exclude it       //0007
   //          and then take REFRESH option so it will write excluded entries into      //0007
   //          IAREFOBJF file with 'D' flag                                             //0007
   //---------------------------------------------------------------------------------- //0007
   begsr writeExcludedObjectsIntoIAREFOBJF;                                              //0007
                                                                                         //0007
     setll *Loval IAEXCOBJS;                                                             //0008
     read IAEXCOBJS;                                                                     //0008
                                                                                         //0007
     dow not %Eof();                                                                     //0007
                                                                                         //0007
         clear wkStarPosition;                                                           //0007
         wkSqlStmt =  'Insert into IAREFOBJF (Iaobjname,Iaobjlib,Iaobjtype,' +           //0007
                      'Iaobjattr,Iastatus) (Select Iaobjnam, Ialibnam,'      +           //0007
                      'Iaobjtyp, Iaobjatr, ' +  singleQuote + 'D'            +           //0007
                       singleQuote  + ' From IAOBJECT where';                            //0007
                                                                                         //0007
         //Check wild card                                                              //0007
         wkStarPosition  = %scan('*' : Iaoobjnam);                                       //0007
         //In case of Object Name with Wildcard                                         //0007
         if wkStarPosition  >  1;                                                        //0007
            wkSqlStmt = %trim(wkSqlStmt) + ' Iaobjnam Like ' + singleQuote +             //0007
                        %trim(%subst(Iaoobjnam : 1 : wkStarPosition - 1))  +             //0007
                        '%' + singleQuote;                                               //0007
                                                                                         //0007
         //In case of Object Name without Wildcard                                      //0007
         else;                                                                           //0007
            wkSqlStmt = %trim(wkSqlStmt) + ' Iaobjnam  = ' +                             //0007
                        singleQuote  +  %trim(Iaoobjnam)  + singleQuote ;                //0007
         endif;                                                                          //0007
                                                                                         //0007
         select;                                                                         //0007
            //In case of Object Name and Library Name                                   //0007
            when Iaoobjlib <> *blanks and Iaoobjtyp = *blanks;                           //0007
               wkSqlStmt = %trim(wkSqlStmt) + ' And  IaLibNam  = ' +                     //0007
                           singleQuote +  %trim(Iaoobjlib) + singleQuote;                //0007
                                                                                         //0007
            //In case of Object Name and Library Name and Object Type                   //0007
            when Iaoobjlib <> *blanks and Iaoobjtyp <> *blanks;                          //0007
               wkSqlStmt = %trim(wkSqlStmt) + ' And IaLibNam = '  +                      //0007
                          singleQuote  + %trim(Iaoobjlib) + singleQuote +                //0007
                          ' And IaObjTyp = ' + singleQuote              +                //0007
                          %trim(Iaoobjtyp) + singleQuote;                                //0007
                                                                                         //0007
            //In case of Object Name and Object Type-no wild card in this case          //0007
            when Iaoobjlib = *blanks and Iaoobjtyp <> *blanks                            //0007
                 and wkStarPosition <= 1;                                                //0007
               wkSqlStmt = %trim(wkSqlStmt) + ' And IaObjTyp  = ' +                      //0007
                           singleQuote + %trim(Iaoobjtyp) +                              //0007
                           singleQuote;                                                  //0007
                                                                                         //0007
         endsl;                                                                          //0007
                                                                                         //0007
         wkSqlStmt = %trim(wkSqlStmt) + ' ) Except Select Iaobjname, ' +                 //0007
                    'Iaobjlib, Iaobjtype,Iaobjattr, ' + singleQuote +                    //0007
                    'D' + singleQuote + ' From  IAREFOBJF';                              //0007
                                                                                         //0007
         exec sql execute immediate :wkSqlStmt;                                          //0007
                                                                                         //0007
         if SqlCode < successCode;                                                       //0007
            uDpsds.wkQuery_Name = 'Insert_IAREFOBJF';                                    //0007
            IaSqlDiagnostic(uDpsds);                                                     //0009
         endif;                                                                          //0007
                                                                                         //0007
         read IAEXCOBJS;                                                                 //0008
      enddo;                                                                             //0007
                                                                                         //0007
   endsr;                                                                                //0007
                                                                                         //0007
end-proc;                                                                                //0007
                                                                                         //0007
//------------------------------------------------------------------------------------- //0007
//Procedure: isobjectExcluded                                                           //0007
//Description: Check the exclusion criteria and see if object needs to be excluded      //0007
//           : Exclusion criterias-Library,Object,Type/Library,Object*,Type             //0007
//           : Library,Object/Library,Object* | Object,Type | Object/Object*            //0007
//------------------------------------------------------------------------------------- //0007
dcl-proc isobjectExcluded;                                                               //0007
                                                                                         //0007
  dcl-pi *n  Ind;                                                                        //0007
     uwObjnam   Like(Iaobjname);                                                         //0007
     uwObjlib   Like(Iaobjlib);                                                          //0007
     uwObjtyp   Like(Iaobjtype);                                                         //0007
  end-pi;                                                                                //0007
                                                                                         //0007
  dcl-s Wk_StarPosition packed(3:0);                                                     //0007
  dcl-s Wk_isObjectExcluded ind inz('0');                                                //0007
                                                                                         //0007
  setll *loval IAEXCOBJS;                                                                //0008
  read IAEXCOBJS;                                                                        //0008
                                                                                         //0007
  dow not %Eof();                                                                        //0007
                                                                                         //0007
     if Iaoobjnam  <>  *Blanks;                                                          //0007
                                                                                         //0007
        clear Wk_StarPosition;                                                           //0007
        Wk_StarPosition = %scan('*' : Iaoobjnam);                                        //0007
                                                                                         //0007
        if Wk_StarPosition  >  1;                                                        //0007
           uwObjnam  =  %subst(uwObjnam  : 1 : Wk_StarPosition - 1);                     //0007
           Iaoobjnam =  %subst(Iaoobjnam : 1 : Wk_StarPosition - 1);                     //0007
        endif;                                                                           //0007
                                                                                         //0007
        if uwObjnam  =  Iaoobjnam;                                                       //0007
                                                                                         //0007
           select;                                                                       //0007
              //just with Object                                                        //0007
              when IaoobjLib = *Blanks  And Iaoobjtyp  = *Blanks;                        //0007
                 Wk_isObjectExcluded = *on;                                              //0007
                 leave;                                                                  //0007
                                                                                         //0007
              //with Library,Object                                                     //0007
              when IaoobjLib <> *Blanks  And Iaoobjtyp = *Blanks                         //0007
                   and IaoobjLib =  uwObjlib;                                            //0007
                 Wk_isObjectExcluded = *on;                                              //0007
                 leave;                                                                  //0007
                                                                                         //0007
              //with Library,Object,Type                                                //0007
              when IaoobjLib <> *Blanks  And Iaoobjtyp <> *Blanks                        //0007
                   and IaoobjLib =  uwObjlib  And Iaoobjtyp = uwObjtyp;                  //0007
                 Wk_isObjectExcluded = *on;                                              //0007
                 leave;                                                                  //0007
                                                                                         //0007
              //with Object,Type-Wild card not applicable here                          //0007
              when Iaoobjtyp <> *Blanks  And  Wk_StarPosition  <= 1                      //0007
                   and Iaoobjtyp = uwObjtyp;                                             //0007
                 Wk_isObjectExcluded = *on;                                              //0007
                 leave;                                                                  //0007
           endsl;                                                                        //0007
                                                                                         //0007
        endif;                                                                           //0007
                                                                                         //0007
     endif;                                                                              //0007
                                                                                         //0007
     read IAEXCOBJS;                                                                     //0008
  enddo;                                                                                 //0007
                                                                                         //0007
  return Wk_isObjectExcluded;                                                            //0007
                                                                                         //0007
end-proc;                                                                                //0007
