**free
      //%METADATA                                                      *
      // %TEXT Remove deleted source/object data from iA files         *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------- //
//Created By  :  Programmers.io @ 2023                                                  //
//Created Date:  28/11/23                                                               //
//Developer   :  Akshay Sopori                                                          //
//Description :  This program removes entries of deleted sources or objects from iA     //
//               files during refresh process.                                          //
//------------------------------------------------------------------------------------- //
//MODIFICATION LOG:                                                                     //
//------------------------------------------------------------------------------------- //
//Date    | Mod_ID | Developer  | Case and Description                                  //
//--------|--------|------------|------------------------------------------------------ //
//07/12/23| 0001   | Akshay S.  | Refresh:Delete logic for IAVARTRK file added. #448    //
//13/12/23| 0002   | Akshay     | Refresh:Delete logic not working for IDSPFDMBR file   //
//        |        |  Sopori    | if source/object is deleted. #449                     //
//14/12/23| 0003   | Akshay     | Refresh : Added where condition for delete logic      //
//14/12/23|        |  Sopori    | for IAVARTRK file. #473                               //
//14/12/23| 0004   | Venkatesh  | Added member based deletion logic for file IAOBJMAP.  //
//        |        |   Battula  |     [Task#:450]                                       //
//15/12/23| 0005   | Akshay     | Refresh : Changed deletion logic for AIPROCREF file.  //
//        |        |   Sopori   |     [Task#:485]                                       //
//19/12/23| 0006   | Naresh S   | Refresh: Added Deletion logic for IADSPDBR to delete  //
//        |        |            | the dependent records.[Task#493]                      //
//13/12/23| 0007   | Himanshu   | Delete entries from IAMEMBER file also for deleted    //
//        |        | Gahtori    | members-Task:#442.                                    //
//04/01/24| 0008   | Tanisha K  | Remove the IDSPFDDISP file and its usages from product//
//        |        |            |  [Task#:505]                                          //
//06/02/24| 0009   | Bpal       | To comment out the procedures to delete records from  //
//        |        |            | the files - IAFILREL, IAFLRLTRK, and IAFILNORM        //
//        |        |            | These files have been removed from IADUPOBJ.          //
//        |        |            |  [Task#:571]                                          //
//13/02/24| 0010   | Himanshu   | 1.On Refresh: IAREFDLTR Incorrectly deleting records  //
//        |        | Gahtori    | for file related out files when same named object     //
//        |        |            | with diff TYPE is deleted from repo lib.              //
//        |        |            | [Task#:573]                                           //
//        |        |            | 2.Merged INIT exclusion code in this program as well  //
//        |        |            | handled REFRESH exclusion process.                    //
//        |        |            | [Task#:498,535]                                       //
//08/02/24| 0011   | Bpal       | Remove the below files and its usages from product    //
//        |        |            |  IASRCOBJ                                             //
//        |        |            |  IARESULT                                             //
//        |        |            |  IAFILREL                                             //
//        |        |            |  IAPGMTREE                                            //
//        |        |            |  IAFFWUDTL                                            //
//        |        |            |  IAFILNORM                                            //
//        |        |            |  IAFLRLTRK                                            //
//        |        |            |  [Task#:444]                                          //
//23/10/04| 0012   | Khushi W   | Rename AIEXCOBJS to IAEXCOBJS [Task #252]             //
//02/07/24| 0013   | Vamsi      | Rename AIALLREFHF to IAALLREFHF [Task #244]           //
//02/07/24| 0014   | Vamsi      | Rename AILNGNMDTL to IALNGNMDTL [Task #246]           //
//02/07/24| 0015   | Akhil K.   | Rename AIPROCREF to IAPROCREF [Task #272]             //
//05/07/24| 0016   | Akhil K.   | Renamed AIERRBND, AICERRLOG, AIDERRLOG and AISQLDIAGNO//
//        |        |            | STIC with IA*                                         //
//17/09/24| 0017   | Gopi Thorat| Rename IACPYBDTL file fields wherever used due to     //
//        |        |            | table changes. [Task#940]                             //
//10/01/25| 0018   | Vamsi      | Delete entries from IAGENAUDTP file for deleted       //
//        |        | Krishna2   | members/objects of UnusedSrc/NoSrcFnd/UnusedProc      //
//        |        |            | NoRefFnd categories [Task#15][Task#1102]              //
//22/01/25| 0019   | Vamsi      | IAPGMFILES is restructured.So,updated the columns     //
//        |        | Krishna2   | accordingly.(Task#63)                                 //
//20/08/24| 0020   | Sabarish   | IFS Member Parsing Upgrade                            //
//------------------------------------------------------------------------------------- //
ctl-opt copyright('Programmers.io Â© 2023');
ctl-opt option(*NoDebugIO : *SrcStmt : *noUnRef);
ctl-opt dftactgrp(*no);
ctl-opt bndDir('IAERRBND');                                                              //0016

//------------------------------------------------------------------------------------- //0010
//File declarations                                                                     //0010
//------------------------------------------------------------------------------------- //0010
//Exclusion control table                                                               //0010
dcl-f IAEXCOBJS Disk Usage(*Input);                                                      //0012

//------------------------------------------------------------------------------------- //
//Variable Declaration
//------------------------------------------------------------------------------------- //
dcl-s uppgm_name    char(10)      inz;
dcl-s uplib_name    char(10)      inz;
dcl-s upsrc_name    char(10)      inz;
dcl-s uptimestamp   Timestamp        ;
dcl-s command       varchar(5000) inz;

//------------------------------------------------------------------------------------- //
//Prototype Declaration
//------------------------------------------------------------------------------------- //
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

//------------------------------------------------------------------------------------- //0010
//Entry Parameter                                                                       //0010
//------------------------------------------------------------------------------------- //0010
//Prototype for this program                                                            //0010
dcl-pr IAREFDLTR  Extpgm('IAREFDLTR');                                                   //0010
   *n char(7) Const;                                                                     //0010
   *n char(1) Const;                                                                     //0010
end-pr;                                                                                  //0010

//Interface for this program                                                            //0010
dcl-pi IAREFDLTR;                                                                        //0010
   up_RunMode char(7) Const;                                                             //0010
   up_DelFlag char(1) Const;                                                             //0010
end-pi;                                                                                  //0010

//------------------------------------------------------------------------------------- //
//Copybook Declaration
//------------------------------------------------------------------------------------- //

/copy 'QCPYSRC/iaderrlog.rpgleinc'
//------------------------------------------------------------------------------------- //
//Set options
//------------------------------------------------------------------------------------- //
exec sql
  set option Commit = *None,
             Naming = *Sys,
             DynUsrPrf = *User,
             CloSqlCsr = *EndMod;

//------------------------------------------------------------------------------------- //
//Main logic
//------------------------------------------------------------------------------------- //

Eval-corr uDpsds = wkuDpsds;

//Insert process start time
uptimeStamp = %Timestamp();
CallP IAEXCTIMR('BLDMTADTA' :udpsds.ProcNme : udpsds.Lib : '*PGM' :                      //0012
   //0020 upsrc_name : uppgm_name : uplib_name : ' ' : uptimeStamp : 'INSERT');
   upsrc_name : uppgm_name : uplib_name : ' ' : ' ' : uptimeStamp : 'INSERT');           //0020

select;                                                                                  //0010
   //Process exclusion for INIT                                                         //0010
   when up_RunMode  =  'INIT';                                                           //0010
      processInitExclusion();                                                            //0010
                                                                                         //0010
   //REFRESH deletion and exclusion                                                     //0010
   when up_RunMode  =  'REFRESH';                                                        //0010
      deleteIAOutfilesForRefresh();                                                      //0010
                                                                                         //0010
      deleteIAfilesForRefresh()   ;                                                      //0010
                                                                                         //0010
endsl;                                                                                   //0010

//Update process end time
UPTimeStamp = %Timestamp();
CallP IAEXCTIMR('BLDMTADTA' :udpsds.ProcNme : udpsds.Lib : '*PGM' :                      //0012
  //0020 upsrc_name : uppgm_name : uplib_name : ' ' : uptimeStamp : 'UPDATE');
  upsrc_name : uppgm_name : uplib_name : ' ' : ' ' : uptimeStamp : 'UPDATE');            //0020

*inlr = *on;

//------------------------------------------------------------------------------------- //
//Procedure   :  deleteIAOutfilesForRefresh
//Description :  Delete records from IA outFiles where status = 'D' in IAREFOBJF
//------------------------------------------------------------------------------------- //
dcl-proc deleteIAOutfilesForRefresh;

   deleteIdspFfdForRefresh();

   deleteIdspDbrForRefresh();

   deleteIdspObjDForRefresh();

   deleteIdspfdSeqForRefresh();

   deleteIdspfdCstForRefresh();

   deleteIdspfdTrgForRefresh();

   deleteIdspfdMbrForRefresh();

   deleteIdspfdBasaForRefresh();

   deleteIdspfdSlomForRefresh();

   deleteIdspfdKeysForRefresh();

   deleteIdspfdJoinForRefresh();

   deleteIdspfdRFmtForRefresh();

   deleteIdspfdMbrlForRefresh();

   deleteIaObjRefPfForRefresh();

   deleteIdspPgmRefForRefresh();

   deleteIdspModRefForRefresh();

   deleteIdspSrvRefForRefresh();

   deleteIdspQryRefForRefresh();

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  deleteIAfilesForRefresh                                                //
//Description :  Delete records from IA Files where status = 'D' in IAREFOBJF           //
//------------------------------------------------------------------------------------- //
dcl-proc deleteIAfilesForRefresh  ;

   deleteIaPgmDsForRefresh()   ;

   deleteIaOvrPfForRefresh()   ;

   deleteIaVarTrkForRefresh()  ;                                                         //0001

   deleteIaObjectForRefresh()  ;

   deleteIaProcRefForRefresh() ;                                                         //0015

   deleteIaObjMapForRefresh()  ;

   deleteIaEntPrmForRefresh()  ;

   deleteIaPgmRefForRefresh()  ;

   deleteIaPgmInfForRefresh()  ;

   deleteIaVarrelForRefresh()  ;

   deleteIaQclsrcForRefresh()  ;

   deleteIaVarCalForRefresh()  ;

   deleteIaQrpgSrcForRefresh() ;

   deleteIaQcblSrcForRefresh() ;

   deleteIaQddsSrcForRefresh() ;

   deleteIaPgmVarsForRefresh() ;

   deleteIaPrcParmForRefresh() ;

   deleteIaCPgmRefForRefresh() ;

   deleteIaCpybDtlForRefresh() ;

   deleteIaSubrDtlForRefresh() ;

   deleteIaESqlFfdForRefresh() ;

   deleteIaPrfxDtlForRefresh() ;

   deleteIaPgmCallsForRefresh();

   deleteIaSrcMbrIdForRefresh();

   deleteIaPgmKListForRefresh();

   deleteIaSrcintPfForRefresh();

   deleteIaProcInfoForRefresh();

   deleteIaCallParmForRefresh();

   deleteIaPgmFilesForRefresh();

   deleteIaLngNmDtlForRefresh();                                                         //0014

   deleteIaAllRefHfForRefresh();                                                         //0013

   deleteIaProcDtLPForRefresh();

   deleteIAMEMBERForRefresh();                                                           //0007

   deleteIaGenAudtpForRefresh();                                                         //0018

   deleteIaAllRefPfForRefresh();                                                         //0018

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  deleteIaGenAudtpForRefresh
//Description :  Delete records from IAGENAUDTP where status = 'D' in IAREFOBJF
//------------------------------------------------------------------------------------- //
dcl-proc deleteIaGenAudtpForRefresh ;                                                    //0018
                                                                                         //0018
//Delete UnsusedSrc records from IAGENAUDTP                                             //0018
  Exec Sql                                                                               //0018
     Delete From IaGenAudtp a where a.UniqueCode ='UnusedSrc'                            //0018
     And Exists (Select 1 from IaRefObjf b Where                                         //0018
                 b.iAMemName   = a.iAMbrName                                             //0018
             And b.iAMemLib    = a.iAMbrLib                                              //0018
             And b.iASrcPf     = a.iAMbrSrcPf                                            //0018
             And b.iAMemType   = a.iAMbrType                                             //0018
             And b.status = 'D' );                                                       //0018

  if sqlCode < successCode;                                                              //0018
     uDpsds.wkQuery_Name = 'DELETE_IAGENAUDTP_UnsusedSrc_Refresh';                       //0018
     IaSqlDiagnostic(uDpsds);                                                            //0018
  endif;                                                                                 //0018

//Delete NoSrcFnd/UnUsedProc records from IAGENAUDTP                                    //0018
  Exec Sql                                                                               //0018
     Delete From IaGenAudtp a where a.UniqueCode In ('NoSrcFnd','UnUsedProc')            //0018
     And Exists (Select 1 from IaRefObjf b Where                                         //0018
                 b.iAObjName   = a.iAObjName                                             //0018
             And b.iAObjLib    = a.iAObjLib                                              //0018
             And b.iAObjType   = a.iAObjTyp                                              //0018
             And b.iAObjAttr   = a.iAObjAttr                                             //0018
             And b.status = 'D' );                                                       //0018

  if sqlCode < successCode;                                                              //0018
     uDpsds.wkQuery_Name = 'DELETE_IAGENAUDTP_NoSrcFnd_Refresh';                         //0018
     IaSqlDiagnostic(uDpsds);                                                            //0018
  endif;                                                                                 //0018

//Delete NoRefFnd records from IAGENAUDTP                                               //0018
  Exec Sql                                                                               //0018
     Delete From IaGenAudtp a where a.UniqueCode = 'NoRefFnd'                            //0018
     And Exists (Select 1 from IaRefObjf b , IaAllRefPF c Where                          //0018
                 a.iAObjName   = c.iARobjNam                                             //0018
             And a.iAObjTyp    = c.iARObjTyp                                             //0018
             And c.iAOobjLib   = b.iAObjLib                                              //0018
             And c.iAOobjNam   = b.iAObjName                                             //0018
             And c.iAOobjTyp   = b.iAObjType                                             //0018
             And c.iAOobjAtr   = b.iAObjAttr                                             //0018
             And b.status = 'D' );                                                       //0018

  if sqlCode < successCode;                                                              //0018
     uDpsds.wkQuery_Name = 'DELETE_IAGENAUDTP_NoRefFnd_Refresh';                         //0018
     IaSqlDiagnostic(uDpsds);                                                            //0018
  endif;                                                                                 //0018

end-proc;                                                                                //0018

//------------------------------------------------------------------------------------- //
//Procedure   :  deleteIdspFfdForRefresh
//Description :  Delete records from IDSPFFD where status = 'D' in IAREFOBJF
//------------------------------------------------------------------------------------- //
dcl-proc deleteIdspFfdForRefresh  ;

  dcl-c fileName 'IDSPFFD ' ;
  dcl-c ObjNm    'WHFILE  ' ;
  dcl-c ObjLib   'WHLIB   ' ;
  dcl-c ObjType  '*FILE' ;                                                               //0010

  deleteFilesBasedOnObjects(fileName :ObjNm :ObjLib :ObjType ) ;                         //0010

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  deleteIdspDbrForRefresh
//Description :  Delete records from IDSPDBR   where status = 'D' in IAREFOBJF
//------------------------------------------------------------------------------------- //
dcl-proc deleteIdspDbrForRefresh;

  dcl-c FileName 'IADSPDBR' ;
  dcl-c ObjNm    'WHRFI   ' ;
  dcl-c ObjLib   'WHRLI   ' ;
  dcl-c ObjType  '*FILE' ;                                                               //0010

  deleteFilesBasedOnObjects(fileName :ObjNm :ObjLib :ObjType) ;                          //0010

  //Deletion of dependent records when LF is  deleted                                   //0006
  exec sql                                                                               //0006
     delete from IADSPDBR  A where exists (                                              //0006
       select 1 from iarefobjf B                                                         //0006
        where B.iaobjname = A.whrefi                                                     //0006
          and B.iaobjlib  = A.whreli                                                     //0006
          and B.iaobjtype = '*FILE'                                                      //0010
          and B.iaobjattr = 'LF'                                                         //0006
          and B.status = 'D' );                                                          //0006

  if sqlCode < successCode;                                                              //0006
     uDpsds.wkQuery_Name = 'Delete_DspDbr_File_Refresh' ;                                //0006
     IaSqlDiagnostic(uDpsds);                                                            //0016
  endif;                                                                                 //0006

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  deleteIdspObjDForRefresh
//Description :  Delete records from IAPGMDS where status = 'D' in IAREFOBJF
//------------------------------------------------------------------------------------- //
dcl-proc deleteIdspObjDForRefresh ;

  dcl-c fileName 'IDSPOBJD' ;
  dcl-c Object   'ODOBNM  ' ;
  dcl-c ObjLib   'ODLBNM  ' ;
  dcl-c ObjTyp   'ODOBTP  ' ;

  deleteFilesBasedOnObjects(fileName : object  : objLib  : objTyp );

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  deleteIdspfdSeqForRefresh
//Description :  Delete records from IDSPFDSEQ where status = 'D' in IAREFOBJF
//------------------------------------------------------------------------------------- //
dcl-proc deleteIdspfdSeqForRefresh;

  dcl-c FileName 'IDSPFDSEQ';
  dcl-c ObjNm    'SQFILE  ' ;
  dcl-c ObjLib   'SQLIB   ' ;
  dcl-c ObjType  '*FILE' ;                                                               //0010

  deleteFilesBasedOnObjects(fileName :ObjNm :ObjLib :ObjType ) ;                         //0010

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  deleteIdspfdcstForRefresh
//Description :  Delete records from IDSPFDCST where status = 'D' in IAREFOBJF
//------------------------------------------------------------------------------------- //
dcl-proc deleteIdspfdCstForRefresh;

  dcl-c FileName 'IDSPFDCST';
  dcl-c ObjNm    'CSFILE  ' ;
  dcl-c ObjLib   'CSLIB   ' ;
  dcl-c ObjFile  '*FILE' ;                                                               //0010

  deleteFilesBasedOnObjects(fileName :ObjNm :ObjLib :ObjFile );                          //0010

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  deleteIdspfdTrgForRefresh
//Description :  Delete records from IDSPFDTRG where status = 'D' in IAREFOBJF
//------------------------------------------------------------------------------------- //
dcl-proc deleteIdspfdTrgForRefresh ;

  dcl-c FileName 'IDSPFDTRG';
  dcl-c ObjNm    'TRFILE  ' ;
  dcl-c ObjLib   'TRLIB   ' ;
  dcl-c ObjType  '*FILE' ;                                                               //0010

  deleteFilesBasedOnObjects(fileName :ObjNm :ObjLib :ObjType );                          //0010

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  deleteIdspfdMbrForRefresh
//Description :  Delete records from IDSPFDMBR where status = 'D' in IAREFOBJF
//------------------------------------------------------------------------------------- //
dcl-proc deleteIdspfdMbrForRefresh ;

  dcl-c FileName 'IDSPFDMBR';
  dcl-c srcFile  'MBFILE  ' ;
  dcl-c library  'MBLIB   ' ;
  dcl-c member   'MBNAME  ' ;

  deleteFilesBasedOnMembers(fileName : srcFile : library : member );

  //Deletion when object of a file is deleted                                           //0002
  exec sql                                                                               //0002
     delete from IDSPFDMBR A where exists (                                              //0002
       select 1 from iarefobjf b                                                         //0002
        where b.iaobjname = a.mbfile                                                     //0002
          and b.iaobjlib = a.mblib                                                       //0002
          and b.iaobjtype = '*FILE'                                                      //0010
          and b.iaobjattr = a.mbfatr                                                     //0002
          and b.status = 'D' );                                                          //0002

  if sqlCode < successCode;                                                              //0002
     uDpsds.wkQuery_Name = 'Delete_DspFdMbr_File_Refresh' ;                              //0002
     IaSqlDiagnostic(uDpsds);                                                            //0016
  endif;                                                                                 //0002

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  deleteIdspfdBasaForRefresh
//Description :  Delete records from IDSPFDBASA where status = 'D' in IAREFOBJF
//------------------------------------------------------------------------------------- //
dcl-proc deleteIdspfdBasaForRefresh ;

  dcl-c FileName 'IDSPFDBASA';
  dcl-c ObjNm    'ATFILE  ' ;
  dcl-c ObjLib   'ATLIB   ' ;
  dcl-c ObjType  '*FILE' ;                                                               //0010

  deleteFilesBasedOnObjects(fileName :ObjNm :ObjLib :ObjType );                          //0010

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  deleteIdspfdSlomForRefresh
//Description :  Delete records from IDSPFDSLOM where status = 'D' in IAREFOBJF
//------------------------------------------------------------------------------------- //
dcl-proc deleteIdspfdSlomForRefresh ;

  dcl-c FileName 'IDSPFDSLOM';
  dcl-c ObjNm    'SOFILE  ' ;
  dcl-c ObjLib   'SOLIB   ' ;
  dcl-c ObjType  '*FILE';                                                                //0010

  deleteFilesBasedOnObjects(fileName :ObjNm :ObjLib :ObjType );                          //0010

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  deleteIdspfdKeysForRefresh                                             //
//Description :  Delete records from IDSPFDKEYS where status = 'D' in IAREFOBJF         //
//------------------------------------------------------------------------------------- //
dcl-proc deleteIdspfdKeysForRefresh ;

  dcl-c FileName 'IDSPFDKEYS';
  dcl-c ObjNm    'APFILE  ' ;
  dcl-c ObjLib   'APLIB   ' ;
  dcl-c ObjType  '*FILE';                                                                //0010

  deleteFilesBasedOnObjects(fileName :ObjNm :ObjLib :ObjType );                          //0010

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  deleteIdspfdJoinForRefresh
//Description :  Delete records from IDSPFDSLOM where status = 'D' in IAREFOBJF
//------------------------------------------------------------------------------------- //
dcl-proc deleteIdspfdJoinForRefresh ;

  dcl-c FileName 'IDSPFDJOIN';
  dcl-c ObjNm    'JNFILE  ' ;
  dcl-c ObjLib   'JNLIB   ' ;
  dcl-c ObjType  '*FILE';                                                                //0010

  deleteFilesBasedOnObjects(fileName :ObjNm :ObjLib :ObjType );                          //0010

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  deleteIdspfdRFmtForRefresh
//Description :  Delete records from IDSPFDRFMT where status = 'D' in IAREFOBJF
//------------------------------------------------------------------------------------- //
dcl-proc deleteIdspfdRFmtForRefresh ;

  dcl-c FileName 'IDSPFDRFMT';
  dcl-c ObjNm    'RFFILE  ' ;
  dcl-c ObjLib   'RFLIB   ' ;
  dcl-c ObjType  '*FILE';                                                                //0010

  deleteFilesBasedOnObjects(fileName :ObjNm :ObjLib :ObjType );                          //0010

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  deleteIdspfdMbrlForRefresh
//Description :  Delete records from IDSPFDMBRL where status = 'D' in IAREFOBJF
//------------------------------------------------------------------------------------- //
dcl-proc deleteIdspfdMbrlForRefresh ;

  dcl-c FileName 'IDSPFDMBRL';
  dcl-c srcFile  'MLFILE  ' ;
  dcl-c library  'MLLIB   ' ;
  dcl-c member   'MLNAME  ' ;

  deleteFilesBasedOnMembers(fileName : srcFile : library : member );

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  deleteIaObjRefPfForRefresh
//Description :  Delete records from IAOBJREFPF where status = 'D' in IAREFOBJF
//------------------------------------------------------------------------------------- //
dcl-proc deleteIaObjRefPfForRefresh ;

  dcl-c FileName 'IAOBJREFPF';
  dcl-c Object   'WHPNAM  ' ;
  dcl-c ObjLib   'WHLIB   ' ;
  dcl-c ObjTyp   'WHSPKG  ' ;

  //Delete entries from IAOBJREFPF based on IAREFOBJF file and status = 'D'
  exec sql
     delete from iAObjRefPf t1
           where exists (
                 select 1
                   from iARefObjF t2
                  where
                        case
                            when t2.Object_Type = '*PGM'    then 'P'
                            when t2.Object_Type = '*MODULE' then 'M'
                            when t2.Object_Type = '*SRVPGM' then 'V'
                            when t2.Object_Type = '*FILE'   then 'F'
                            when t2.Object_Type = '*QRYDFN' then 'Q'
                            when t2.Object_Type = '*SQLPKG' then 'S'
                            when t2.Object_Type = '*MENU'   then 'N'
                            else ' '
                        end = T1.WHSPKG
                    and t2.Object_Name    = t1.whpNam
                    and t2.Object_Library = t1.whLib
                    and t2.Status         = 'D' );

  if sqlCode < successCode;
     uDpsds.wkQuery_Name = 'DELETE_OBJREFOutfile';
     IaSqlDiagnostic(uDpsds);                                                            //0016
  endif;

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  deleteIdspPgmRefForRefresh
//Description :  Delete records from IDSPPGMREF where status = 'D' in IAREFOBJF
//------------------------------------------------------------------------------------- //
dcl-proc deleteIdspPgmRefForRefresh;

  dcl-c FileName 'IDSPPGMREF';
  dcl-c Object   'WHPNAM  ' ;
  dcl-c ObjLib   'WHLIB   ' ;
  dcl-c ObjTyp   'WHSPKG  ' ;

  //Delete entries from IDSPPGMREF based on IAREFOBJF file and status = 'D'
  exec sql
     delete from iDspPgmRef t1
           where exists (
                 select 1
                   from iARefObjF t2
                  where
                        case
                          when t2.Object_Type = '*PGM' then 'P'
                        end = T1.WHSPKG
                    and t2.Object_Name    = t1.whpNam
                    and t2.Object_Library = t1.whLib
                    and t2.Status         = 'D' );

  if sqlCode < successCode;
     uDpsds.wkQuery_Name = 'DELETE_PGMREFOutfile';
     IaSqlDiagnostic(uDpsds);                                                            //0016
  endif;

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  deleteIdspModRefForRefresh
//Description :  Delete records from IDSPMODREF where status = 'D' in IAREFOBJF
//------------------------------------------------------------------------------------- //
dcl-proc deleteIdspModRefForRefresh  ;

  dcl-c FileName 'IDSPMODREF';
  dcl-c Object   'WHPNAM  ' ;
  dcl-c ObjLib   'WHLIB   ' ;
  dcl-c ObjTyp   'WHSPKG  ' ;

  //Delete entries from IDSPMODREF based on IAREFOBJF file and status = 'D'
  exec sql
     delete from iDspModRef t1
           where exists (
                 select 1
                   from iARefObjF t2
                  where
                        case
                          when t2.Object_Type = '*MODULE' then 'M'
                        end = t1.whsPkg
                    and t2.Object_Name    = t1.whpNam
                    and t2.Object_Library = t1.whLib
                    and t2.Status         = 'D' );

  if sqlCode < successCode;
     uDpsds.wkQuery_Name = 'DELETE_MODREFOutfile';
     IaSqlDiagnostic(uDpsds);                                                            //0016
  endif;

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  deleteIdspSrvRefForRefresh
//Description :  Delete records from IDSPSRVREF where status = 'D' in IAREFOBJF
//------------------------------------------------------------------------------------- //
dcl-proc deleteIdspSrvRefForRefresh  ;

  dcl-c FileName 'IDSPSRVREF';
  dcl-c Object   'WHPNAM  ' ;
  dcl-c ObjLib   'WHLIB   ' ;
  dcl-c ObjTyp   'WHSPKG  ' ;

  //Delete entries from IDSPMODREF based on IAREFOBJF file and status = 'D'
  exec sql
     delete from iDspSrvRef t1
           where exists (
                 select 1
                   from iARefObjF t2
                  where
                        case
                          when t2.Object_Type = '*SRVPGM' then 'V'
                        end = t1.whsPkg
                    and t2.Object_Name    = t1.whpNam
                    and t2.Object_Library = t1.whLib
                    and t2.Status         = 'D' );

  if sqlCode < successCode;
     uDpsds.wkQuery_Name = 'DELETE_SRVREFOutfile';
     IaSqlDiagnostic(uDpsds);                                                            //0016
  endif;

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  deleteIdspQryRefForRefresh
//Description :  Delete records from IDSPQRYREF where status = 'D' in IAREFOBJF
//------------------------------------------------------------------------------------- //
dcl-proc deleteIdspQryRefForRefresh  ;

  dcl-c FileName 'IDSPQRYREF';
  dcl-c Object   'WHPNAM  ' ;
  dcl-c ObjLib   'WHLIB   ' ;
  dcl-c ObjTyp   'WHSPKG  ' ;

  //Delete entries from IDSPQRYREF based on IAREFOBJF file and status = 'D'
  exec sql
     delete from iDspQryRef t1
           where exists (
                 select 1
                   from iARefObjF t2
                  where
                        Case
                          when t2.Object_Type = '*QRYDFN' then 'Q'
                        end = t1.whsPkg
                    and t2.Object_Name    = t1.whpNam
                    and t2.Object_Library = t1.whLib
                    and t2.Status         = 'D' );

  if sqlCode < successCode;
     uDpsds.wkQuery_Name = 'DELETE_QRYREFOutfile';
     IaSqlDiagnostic(uDpsds);                                                            //0016
  endif;

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  deleteIaPgmDsForRefresh
//Description :  Delete records from IAPGMDS where status = 'D' in IAREFOBJF
//------------------------------------------------------------------------------------- //
dcl-proc deleteIaPgmDsForRefresh ;

  dcl-c fileName 'IAPGMDS' ;
  dcl-c srcFile  'DSSRCFLN';
  dcl-c library  'DSSRCLIB';
  dcl-c member   'DSPGMNM' ;

  deleteFilesBasedOnMembers(fileName : srcFile : library : member );

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  deleteIaOvrPfForRefresh
//Description :  Delete records from IAOVRPF where status = 'D' in IAREFOBJF
//------------------------------------------------------------------------------------- //
dcl-proc deleteIaOvrPfForRefresh ;

  dcl-c fileName 'IAOVRPF' ;
  dcl-c srcFile  'IOVRFILE';
  dcl-c library  'IOVRLIB' ;
  dcl-c member   'IOVRMBR' ;

  deleteFilesBasedOnMembers(fileName : srcFile : library : member );

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  deleteIaVarTekForRefresh
//Description :  Delete records from IAVARTRK where status = 'D' in IAREFOBJF
//------------------------------------------------------------------------------------- //0001
dcl-proc deleteIaVarTrkForRefresh;                                                       //0001

  exec sql                                                                               //0001
    delete from iAVarTrk where Src_Mbr_Id in (                                           //0001
      select mbrSurId                                                                    //0001
        from iASrcMbrId                                                                  //0001
        join iARefObjF                                                                   //0001
          on ( mbrname  = iamemname                                                      //0001
         and mbrsrcpf = iasrcpf                                                          //0001
         and mbrlib   = iamemlib )                                                       //0001
          or ( mbrname  = iaobjname                                                      //0001
         and mbrlib   = iaobjlib                                                         //0001
         and ( iaobjattr in ('PF', 'LF', 'DSPF', 'PRTF') ) )                             //0001
       where iastatus = 'D');                                                            //0003

  if sqlCode < successCode;                                                              //0001
     uDpsds.wkQuery_Name = 'Delete_IaVarTrkForRefresh' ;                                 //0001
     IaSqlDiagnostic(uDpsds);                                                            //0016
  endif;                                                                                 //0001

end-proc;                                                                                //0001
//------------------------------------------------------------------------------------- //
//Procedure   :  deleteIaObjectForRefresh
//Description :  Delete records from IAOBJECT where status = 'D' in IAREFOBJF
//------------------------------------------------------------------------------------- //
dcl-proc deleteIaObjectForRefresh;

  dcl-c fileName 'IAOBJECT';
  dcl-c objNm    'IAOBJNAM';
  dcl-c objLib   'IALIBNAM';
  dcl-c objTyp   'IAOBJTYP';

  deleteFilesBasedOnObjects(fileName : objNm : objLib  : objTyp );

end-proc;
//------------------------------------------------------------------------------------- //
//Procedure   :  deleteIaObjMapForRefresh
//Description :  Delete records from IAOBJMAP   where status = 'D' in IAREFOBJF
//------------------------------------------------------------------------------------- //
dcl-proc deleteIaObjMapForRefresh  ;

  dcl-c fileName 'IAOBJMAP'   ;
  dcl-c objNm    'IAOBJNAM'   ;
  dcl-c objLib   'IAOBJLIB'   ;
  dcl-c objtyp   'IAOBJTYP'   ;
  dcl-c srcFile  'IAMBRSRCF' ;                                                           //0004
  dcl-c library  'IAMBRLIB'  ;                                                           //0004
  dcl-c member   'IAMBRNAM'  ;                                                           //0004

  deleteFilesBasedOnObjects(fileName : objNm : objLib : objTyp );

  //Member based deletion                                                               //0004
  deleteFilesBasedOnMembers(fileName : srcFile : library : member );                     //0004

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  deleteIaEntPrmForRefresh
//Description :  Delete records from IAENTPRM where status = 'D' in IAREFOBJF
//------------------------------------------------------------------------------------- //

dcl-proc deleteIaEntPrmForRefresh;

  dcl-c fileName 'IAENTPRM' ;
  dcl-c srcFile  'ESRCPFNM' ;
  dcl-c library  'ELIBNAME' ;
  dcl-c member   'EMBRNAM'  ;

  deleteFilesBasedOnMembers(fileName : srcFile : library : member );

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  deleteIaPgmRefForRefresh
//Description :  Delete records from IAPGMREF where status = 'D' in IAREFOBJF
//------------------------------------------------------------------------------------- //
dcl-proc deleteIaPgmRefForRefresh;

  dcl-c fileName 'IAPGMREF' ;
  dcl-c srcFile  'PSRCPFNM' ;
  dcl-c library  'PLIBNAM'  ;
  dcl-c member   'PMBRNAM'  ;

  deleteFilesBasedOnMembers(fileName : srcFile : library : member );

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  deleteIaPgmInfForRefresh
//Description :  Delete records from IAPGMINF where status = 'D' in IAREFOBJF
//------------------------------------------------------------------------------------- //
dcl-proc deleteIaPgmInfForRefresh;

  dcl-c fileName 'IAPGMINF' ;
  dcl-c objNm    'PGM'      ;
  dcl-c objLib   'PGMLIB'   ;
  dcl-c objTyp   'PGMTYP'   ;

  deleteFilesBasedOnObjects(fileName : objNm : objLib : objTyp );

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  deleteIaQclsrcForRefresh
//Description :  Delete records from IAQCLSRC where status = 'D' in IAREFOBJF
//------------------------------------------------------------------------------------- //
dcl-proc deleteIaQclsrcForRefresh;

  dcl-c fileName 'IAQCLSRC' ;
  dcl-c srcFile  'YSRCNAM'  ;
  dcl-c library  'YLIBNAM'  ;
  dcl-c member   'YMBRNAM'  ;

  deleteFilesBasedOnMembers(fileName : srcFile : library : member );

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  deleteIaVarrelForRefresh
//Description :  Delete records from IAVARREL where status = 'D' in IAREFOBJF
//------------------------------------------------------------------------------------- //
dcl-proc deleteIaVarrelForRefresh;

  dcl-c fileName 'IAVARREL' ;
  dcl-c srcFile  'RESRCFLN' ;
  dcl-c library  'RESRCLIB' ;
  dcl-c member   'REPGMNM'  ;

  deleteFilesBasedOnMembers(fileName : srcFile : library : member );

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  deleteIaVarCalForRefresh
//Description :  Delete records from IAVARCAL where status = 'D' in IAREFOBJF
//------------------------------------------------------------------------------------- //
dcl-proc deleteIaVarCalForRefresh;

  dcl-c fileName 'IAVARCAL' ;
  dcl-c srcFile  'IVCALFILE';
  dcl-c library  'IVCALLIB' ;
  dcl-c member   'IVCALMBR' ;

  deleteFilesBasedOnMembers(fileName : srcFile : library : member );

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  deleteIaQrpgSrcForRefresh
//Description :  Delete records from IAQRPGSRC where status = 'D' in IAREFOBJF
//------------------------------------------------------------------------------------- //
dcl-proc deleteIaQrpgSrcForRefresh;

  dcl-c fileName 'IAQRPGSRC';
  dcl-c srcFile  'XSRCNAM'  ;
  dcl-c library  'XLIBNAM'  ;
  dcl-c member   'XMBRNAM'  ;

  deleteFilesBasedOnMembers(fileName : srcFile : library : member );

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  deleteIaQcblSrcForRefresh
//Description :  Delete records from IAQCBLSRC where status = 'D' in IAREFOBJF
//------------------------------------------------------------------------------------- //
dcl-proc deleteIaQcblSrcForRefresh;

  dcl-c fileName 'IAQCBLSRC';
  dcl-c srcFile  'ZSRCNAM'  ;
  dcl-c library  'ZLIBNAM'  ;
  dcl-c member   'ZMBRNAM'  ;

  deleteFilesBasedOnMembers(fileName : srcFile : library : member );

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  deleteIaQddsSrcForRefresh
//Description :  Delete records from IAQDDSSRC where status = 'D' in IAREFOBJF
//------------------------------------------------------------------------------------- //
dcl-proc deleteIaQddsSrcForRefresh;

  dcl-c fileName 'IAQDDSSRC';
  dcl-c srcFile  'WSRCNAM'  ;
  dcl-c library  'WLIBNAM'  ;
  dcl-c member   'WMBRNAM'  ;

  deleteFilesBasedOnMembers(fileName : srcFile : library : member );

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  deleteIaPgmVarsForRefresh
//Description :  Delete records from IAPGMVARS where status = 'D' in IAREFOBJF
//------------------------------------------------------------------------------------- //
dcl-proc deleteIaPgmVarsForRefresh;

  dcl-c fileName 'IAPGMVARS';
  dcl-c srcFile  'IAVSFILE' ;
  dcl-c library  'IAVLIB'   ;
  dcl-c member   'IAVMBR'   ;

  deleteFilesBasedOnMembers(fileName : srcFile : library : member );

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  DeleteIaPrmParm
//Description :  Delete records from IAPRCPARM where status = 'D' in IAREFOBJF
//------------------------------------------------------------------------------------- //
dcl-proc deleteIaPrcParmForRefresh;

  dcl-c fileName 'IAPRCPARM';
  dcl-c srcFile  'PSRCPF'   ;
  dcl-c library  'PLIBNAM'  ;
  dcl-c member   'PMBRNAM'  ;

  deleteFilesBasedOnMembers(fileName : srcFile : library : member );

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  DeleteIaCPgmRefForRefresh
//Description :  Delete records from IACPGMREF where status = 'D' in IAREFOBJF
//------------------------------------------------------------------------------------- //
dcl-proc deleteIaCPgmRefForRefresh;

  dcl-c fileName 'IACPGMREF';
  dcl-c srcFile  'PSRCPFNM' ;
  dcl-c library  'PLIBNAM'  ;
  dcl-c member   'PMBRNAM'  ;

  deleteFilesBasedOnMembers(fileName : srcFile : library : member );

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  deleteIaCpybDtlForRefresh
//Description :  Delete records from IACPYBDTL where status = 'D' in IAREFOBJF
//------------------------------------------------------------------------------------- //
dcl-proc deleteIaCpybDtlForRefresh;

  dcl-c fileName 'IACPYBDTL' ;
  dcl-c srcFile  'IAMBRSRCPF';                                                           //0017
  dcl-c library  'IAMBRLIB'  ;                                                           //0017
  dcl-c member   'IAMBRNAME' ;                                                           //0017

  deleteFilesBasedOnMembers(fileName : srcFile : library : member );

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  deleteIaSubrDtlForRefresh
//Description :  Delete records from IASUBRDTL where status = 'D' in IAREFOBJF
//------------------------------------------------------------------------------------- //
dcl-proc deleteIaSubrDtlForRefresh;

  dcl-c fileName 'IASUBRDTL' ;
  dcl-c srcFile  'SRMEMSRCPF';
  dcl-c library  'SRMEMLIB'  ;
  dcl-c member   'SRMEMNAME' ;

  deleteFilesBasedOnMembers(fileName : srcFile : library : member );

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  deleteIaESqlFfdForRefresh
//Description :  Delete records from IAESQLFFD where status = 'D' in IAREFOBJF
//------------------------------------------------------------------------------------- //
dcl-proc deleteIaESqlFfdForRefresh;

  dcl-c fileName 'IAESQLFFD' ;
  dcl-c srcFile  'CSRCFLN'   ;
  dcl-c library  'CSRCLIB'   ;
  dcl-c member   'CPGMNM'    ;

  deleteFilesBasedOnMembers(fileName : srcFile : library : member );

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  deleteIaPrfxDtlForRefresh
//Description :  Delete records from IAPRFXDTL where status = 'D' in IAREFOBJF
//------------------------------------------------------------------------------------- //
dcl-proc deleteIaPrfxDtlForRefresh;

  dcl-c fileName 'IAPRFXDTL' ;
  dcl-c srcFile  'IAPFXSPF'  ;
  dcl-c library  'IAPFXLIB'  ;
  dcl-c member   'IAPFXMBR'  ;

  deleteFilesBasedOnMembers(fileName : srcFile : library : member );

end-proc;


//------------------------------------------------------------------------------------- //
//Procedure   :  deleteIaPgmCallsForRefresh
//Description :  Delete records from IAPGMCALLS where status = 'D' in IAREFOBJF
//------------------------------------------------------------------------------------- //
dcl-proc deleteIaPgmCallsForRefresh;

  dcl-c fileName 'IAPGMCALLS' ;
  dcl-c srcFile  'CPMEMSRCPF' ;
  dcl-c library  'CPMEMLIB'   ;
  dcl-c member   'CPMEMNAME'  ;

  deleteFilesBasedOnMembers(fileName : srcFile : library : member );

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  deleteIaSrcMbrIdForRefresh
//Description :  Delete records from IASRCMBRID where status = 'D' in IAREFOBJF
//------------------------------------------------------------------------------------- //
dcl-proc deleteIaSrcMbrIdForRefresh;

  dcl-c fileName 'IASRCMBRID';
  dcl-c srcFile  'MBRSRCPF'  ;
  dcl-c library  'MBRLIB'    ;
  dcl-c member   'MBRNAME'   ;

  deleteFilesBasedOnMembers(fileName : srcFile : library : member );

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  deleteIaPgmKListForRefresh
//Description :  Delete records from IAPGMKLIST where status = 'D' in IAREFOBJF
//------------------------------------------------------------------------------------- //
dcl-proc deleteIaPgmKListForRefresh;

  dcl-c fileName 'IAPGMKLIST';
  dcl-c srcFile  'KLSRCFLN'  ;
  dcl-c library  'KLSRCLIB'  ;
  dcl-c member   'KLPGMNM'   ;

  deleteFilesBasedOnMembers(fileName : srcFile : library : member );

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  deleteIaSrcintPfForRefresh
//Description :  Delete records from IASRCINTPF where status = 'D' in IAREFOBJF
//------------------------------------------------------------------------------------- //
dcl-proc deleteIaSrcintPfForRefresh;

  dcl-c fileName 'IASRCINTPF';
  dcl-c srcFile  'IAMBRSRC'  ;
  dcl-c library  'IAMBRLIB'  ;
  dcl-c member   'IAMBRNAM'  ;

  deleteFilesBasedOnMembers(fileName : srcFile : library : member );

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  deleteIaProcInfoForRefresh
//Description :  Delete records from IAPROCINFO where status = 'D' in IAREFOBJF
//------------------------------------------------------------------------------------- //
dcl-proc deleteIaProcInfoForRefresh;

  dcl-c fileName 'IAPROCINFO' ;
  dcl-c srcFile  'IASRCFILE'  ;
  dcl-c library  'IAMBRLIB'   ;
  dcl-c member   'IAMBRNAM'   ;

  deleteFilesBasedOnMembers(fileName : srcFile : library : member );

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  deleteIaCallParmForRefresh
//Description :  Delete records from IACALLPARM where status = 'D' in IAREFOBJF
//------------------------------------------------------------------------------------- //
dcl-proc deleteIaCallParmForRefresh;

  dcl-c fileName 'IACALLPARM';
  dcl-c srcFile  'CPMEMSRCPF';
  dcl-c library  'CPMEMLIB'  ;
  dcl-c member   'CPMEMNAME' ;

  deleteFilesBasedOnMembers(fileName : srcFile : library : member );

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  deleteIaPgmFilesForRefresh
//Description :  Delete records from IAPGMFILES where status = 'D' in IAREFOBJF
//------------------------------------------------------------------------------------- //
dcl-proc deleteIaPgmFilesForRefresh;

  dcl-c fileName 'IAPGMFILES';
  dcl-c srcFile  'IASRCFILE' ;                                                           //0019
  dcl-c library  'IALIBNAM'  ;                                                           //0019
  dcl-c member   'IAMBRNAME' ;                                                           //0019

  deleteFilesBasedOnMembers(fileName : srcFile : library : member );

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  deleteiALngNmDtlForRefresh                                             //0014
//Description :  Delete records from IALNGNMDTL where status = 'D' in IAREFOBJF         //0014
//------------------------------------------------------------------------------------- //
dcl-proc deleteIaLngNmDtlForRefresh;                                                     //0014

  dcl-c fileName 'IALNGNMDTL' ;                                                          //0014
  dcl-c srcFile  'AISRCFIL'   ;
  dcl-c library  'AISRCLIB'   ;
  dcl-c member   'AISRCMBR'   ;

  deleteFilesBasedOnMembers(fileName : srcFile : library : member );

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  deleteIaAllRefPfForRefresh
//Description :  Delete records from IAALLREFPF where status = 'D' in IAREFOBJF
//------------------------------------------------------------------------------------- //
dcl-proc deleteIaAllRefPfForRefresh;

  dcl-c fileName 'IAALLREFPF' ;
  dcl-c objNm    'IAOOBJNAM'  ;
  dcl-c objLib   'IAOOBJLIB'  ;
  dcl-c objtyp   'IAOOBJTYP'  ;

  deleteFilesBasedOnObjects(fileName : objNm : objLib : objTyp );

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  deleteIAAllRefHfForRefresh
//Description :  Delete records from IAALLREFPF where status = 'D' in IAREFOBJF
//------------------------------------------------------------------------------------- //
dcl-proc deleteIaAllRefHfForRefresh;                                                     //0013

  dcl-c fileName 'IAALLREFHF' ;                                                          //0013
  dcl-c objNm    'IAOOBJNAM'  ;
  dcl-c objLib   'IAOOBJLIB'  ;
  dcl-c objtyp   'IAOOBJTYP'  ;

  deleteFilesBasedOnObjects(fileName : objNm : objLib : objTyp );

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  deleteIaProcRefForRefresh
//Description :  Delete records from IAPROCREF  where status = 'D' in IAREFOBJF
//------------------------------------------------------------------------------------- //
dcl-proc deleteIaProcRefForRefresh ;                                                     //0015

  dcl-c fileName 'IAPROCREF'  ;                                                          //0015
  dcl-c objNm    'AIOBJNAM'   ;
  dcl-c objLib   'AIOBJLIB'   ;
  dcl-c objtyp   'AIOBJTYP'   ;

//deleteFilesBasedOnObjects(fileName : objNm : objLib : objTyp );                        //0005

  exec sql                                                                               //0005
    delete from IaProcRef p                                                              //0005 0015
          where exists (                                                                 //0005
         select 1                                                                        //0005
           from iARefObjf r                                                              //0005
          where iastatus = 'D'                                                           //0005
            and ((p.object_library = r.object_library                                    //0005
            and p.object_type = r.object_type                                            //0005
            and p.object_name = r.object_name)                                           //0005
             or (exists (select 1                                                        //0005
                           from iAObjMap o                                               //0005
                          where r.member_name = o.iambrnam                               //0005
                            and r.member_library = o.iambrlib                            //0005
                            and r.source_physical_file = o.iambrsrcf))));                //0005

   if sqlCode < successCode;                                                             //0005
      uDpsds.wkQuery_Name = 'Delete_IAPROCREF_D';                                        //0005 0015
      IaSqlDiagnostic(uDpsds);                                                           //0016
      return ;                                                                           //0005
   endif;                                                                                //0005

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   :  DeleteIaProcDtlPForRefresh
//Description :  Delete records from IAPROCDTLP where status = 'D' in IAREFOBJF
//------------------------------------------------------------------------------------- //
dcl-proc deleteIaProcDtLPForRefresh;

  dcl-c fileName 'IAPROCDTLP' ;
  dcl-c objNm    'IAOBJNAME'  ;
  dcl-c objLib   'IAOBJLIB'   ;
  dcl-c objtyp   'IAOBJTYPE'  ;

  deleteFilesBasedOnObjects(fileName : objNm : objLib : objTyp );

end-proc;

//------------------------------------------------------------------------------------- //0007
//Procedure   :  DeleteIAMEMBERForRefresh                                               //0007
//Description :  Delete records from IAMEMBER where status = 'D' in IAREFOBJF           //0007
//------------------------------------------------------------------------------------- //0007
dcl-proc DeleteIAMEMBERforRefresh;                                                       //0007
                                                                                         //0007
  dcl-c FileName 'IAMEMBER';                                                             //0007
  dcl-c srcFile  'IASRCPFNAM';                                                           //0007
  dcl-c library  'IASRCLIB' ;                                                            //0007
  dcl-c member   'IAMBRNAM' ;                                                            //0007
                                                                                         //0007
  DeleteFilesBasedOnMembers(fileName : srcFile : library : member );                     //0007
                                                                                         //0007
end-proc;                                                                                //0007
                                                                                         //0007
//------------------------------------------------------------------------------------- //
//Procedure   : DeleteFilesBasedOnMembers
//Description : We are deleting the records from iA Files    ,  when status = 'D'
//              which are based on member details
//------------------------------------------------------------------------------------- //
dcl-proc DeleteFilesBasedOnMembers ;

  dcl-pi DeleteFilesBasedOnMembers ;
     PFile     char(10)        const;
     PsrcFile  char(10)        const;
     PmbrLib   char(10)        const;
     Pmember   char(10)        const;
  end-pi;

  clear command;
  command = ' Delete from ' + %trim(Pfile) + ' a ' + ' where exists '  +
            ' (Select 1 from iarefobjf b where '                       +
            ' b.member_name          = a.' + %trim(Pmember ) + ' and'  +
            ' b.member_library       = a.' + %trim(PmbrLib)  + ' and'  +
            ' b.source_physical_file = a.' + %trim(PsrcFile) +  ' and' +
            ' b.status = ''D'' ' + ')';

  exec sql prepare SqlStmt from :command;
  exec sql execute SqlStmt;

  if sqlCode < successCode;
     uDpsds.wkQuery_Name = 'DELETE_'+ %trim(pFile) + '_Refresh';
     IaSqlDiagnostic(uDpsds);                                                            //0016
  endif;

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure   : deleteFilesBasedOnObjects
//Description : We are deleting the records from IA Files    ,  when status = 'D'
//              which are based on object details
//------------------------------------------------------------------------------------- //
dcl-proc DeleteFilesBasedOnObjects;

  dcl-pi DeleteFilesBasedOnObjects;
     PFile     char(10)        const;
     Pobject   char(10)        const;
     PobjLib   char(10)        const;
     PobjTyp   char(10)        const options(*omit);
  end-pi;

  clear command;

  if %addr(PObjTyp) <> *null ;
     //Match the object type also for object based deletion                             //0010
     command = ' Delete from ' + %trim(Pfile) + ' a ' + ' where exists ' +               //0010
               ' (Select * from iarefobjf b where '                      +               //0010
               ' b.object_name    =  a.' + %Trim(Pobject ) + ' and'      +               //0010
               ' b.object_library =  a.' + %Trim(PobjLib)  + ' and';                     //0010
                                                                                         //0010
     if PobjTyp  =  '*FILE';                                                             //0010
        command  =  %Trimr(Command) + ' ' + 'b.object_type = ''*FILE''  '+               //0010
                    ' and b.status = ''D'' ' + ')';                                      //0010
     else;                                                                               //0010
        command  =  %Trimr(Command) + ' ' + 'b.object_type =' +                          //0010
                    'a.' + %Trim(PobjTyp) +' and b.status = ''D'' ' + ')';               //0010
     endif;                                                                              //0010
  endif;

  exec sql prepare SqlStmt from :command;
  exec sql execute SqlStmt;

  if sqlCode < successCode;
     uDpsds.wkQuery_Name = 'DELETE_' + %trim(pFile) + '_Refresh' ;
     IaSqlDiagnostic(uDpsds);                                                            //0016
  endif;

end-proc;

//------------------------------------------------------------------------------------- //0010
//Procedure   : ProcessINITExclusion                                                    //0010
//Description : Process deletion for excluded object for INIT.                          //0010
//              which are based on object details                                       //0010
//------------------------------------------------------------------------------------- //0010
dcl-proc ProcessInitExclusion;                                                           //0010

  //Variable declarations                                                               //0010
  dcl-s Wk_WildCard       Char(10);                                                      //0010
  dcl-s Wk_Position       Packed(3);                                                     //0010
  dcl-s SqlStmt           Char(1000) Inz;                                                //0010

  //Constant declarations                                                               //0010
  dcl-c File              Const('*FILE');                                                //0010
  dcl-c Quote             Const('''');                                                   //0010
  dcl-c Space             Const(' ');                                                    //0010

  //process each excluded object from exclusion control table.                          //0010
  setll *Start iAExcObjs;                                                                //0012
  read iAExcObjs;                                                                        //0012
  dow not %eof(iAExcObjs);                                                               //0012
                                                                                         //0010
     if iAOObjNam <>  *Blanks;                                                           //0010
        wk_Position  =  *Zero;                                                           //0010
        wk_WildCard  =  *Blanks;                                                         //0010
                                                                                         //0010
        //If it is wildcard, get the position of "*"                                    //0010
        wk_Position  =  %scan('*' : Iaoobjnam);                                          //0010
        if wk_Position  >  1;                                                            //0010
           wk_Position -=  1;                                                            //0010
           wk_WildCard  =  %subst(iAOObjNam : 1 : wk_Position);                          //0010
        endif;                                                                           //0010
                                                                                         //0010
        //Delete the excluded object from all the related files.                        //0010
        exsr deleteExcludedObjects;                                                      //0010
     endif;                                                                              //0010
                                                                                         //0010
     read iAExcObjs;                                                                     //0012
                                                                                         //0010
  enddo;                                                                                 //0010
                                                                                         //0010
  //----------------------------------------------------------------------------------- //0010
  //Subroutine: DeleteExcludedObjects                                                   //0010
  //Delete the entries of excluded objects from relevent tables                         //0010
  //----------------------------------------------------------------------------------- //0010
  begsr deleteExcludedObjects;                                                           //0010
                                                                                         //0010
     select;                                                                             //0010
        //O = Delete from IDSPOBJD and DSPFD outfiles and DSPFFD outfiles               //0010
        //right after populating them during INIT process                               //0010
        when up_DelFlag  =  'O';                                                         //0010
           //Delete entry from file IDSPOBJD-for all types                              //0010
           exsr deleteDSPOBJD_OutFile;                                                   //0010
                                                                                         //0010
           //For *File object types.                                                    //0010
           if Iaoobjtyp  =  FILE Or Iaoobjtyp  =  *Blanks;                               //0010
              exsr deleteDSPFD_OutFiles;                                                 //0010
           endif;                                                                        //0010
                                                                                         //0010
        //R = Delete from IAALLREFPF at the end of the INIT process                     //0010
        when up_DelFlag  =  'R';                                                         //0010
           exsr deleteIAALLREFPF;                                                        //0010
     endsl;                                                                              //0010
  endsr;                                                                                 //0010
                                                                                         //0010
  //----------------------------------------------------------------------------------- //0010
  //Subroutine: deleteDSPFD_OutFiles                                                    //0010
  //Delete the entries of excluded objects from outfiles related to DSPFD command       //0010
  //----------------------------------------------------------------------------------- //0010
  begsr deleteDSPFD_OutFiles;                                                            //0010
                                                                                         //0010
     //Delete entry from file IDSPFDBASA.                                               //0010
     sqlStmt =  'Delete from IDSPFDBASA Where';                                          //0010
     if wk_WildCard  <> *Blanks;                                                         //0010
        sqlStmt =  %trim(sqlStmt) + Space + 'Substr(ATFILE,1,'              +            //0010
                   %char(wk_Position) + ') = ' + Quote + %trim(Wk_WildCard) +            //0010
                   Quote;                                                                //0010
     else;                                                                               //0010
        sqlStmt =  %trim(sqlStmt) + Space + 'ATFILE='+ Quote + %trim(iAoObjNam)          //0010
                   + Quote;                                                              //0010
     endif;                                                                              //0010
                                                                                         //0010
     //If Lib provided                                                                  //0010
     if iAOObjLib <> *Blanks;                                                            //0010
        sqlStmt =  %trim(sqlStmt) + Space + 'And ATLIB='  +  Quote  +                    //0010
                   %trim(IAOOBJLIB) + Quote;                                             //0010
     endif;                                                                              //0010
                                                                                         //0010
     exec sql execute immediate :sqlStmt;                                                //0010
                                                                                         //0010
     if SqlCode < SuccessCode;                                                           //0010
        uDpsds.wkQuery_Name = 'Delete_IDSPFDBASA';                                       //0010
        IaSqlDiagnostic(uDpsds);                                                         //0016
     endif;                                                                              //0010
                                                                                         //0010
     //Delete entry from file IDSPFDKEYS.                                               //0010
     sqlStmt =  'Delete from IDSPFDKEYS Where';                                          //0010
                                                                                         //0010
     if wk_WildCard <> *Blanks;                                                          //0010
        sqlStmt =  %trim(sqlStmt) + Space + 'Substr(APFILE,1,'              +            //0010
                   %char(wk_Position) + ') = ' + Quote + %trim(wk_WildCard) +            //0010
                   Quote;                                                                //0010
     else;                                                                               //0010
        sqlStmt =  %trim(sqlStmt) + Space + 'APFILE='+ Quote + %trim(iAOObjNam)          //0010
                   + Quote;                                                              //0010
     endif;                                                                              //0010
                                                                                         //0010
     //If Lib provided                                                                  //0010
     if iAOObjLib <> *Blanks;                                                            //0010
        sqlStmt =  %trim(sqlStmt) + Space + 'And APLIB = '  +  Quote  +                  //0010
                   %Trim(iAOObjLib) + Quote;                                             //0010
     endif;                                                                              //0010
                                                                                         //0010
     exec sql execute immediate :sqlStmt;                                                //0010
                                                                                         //0010
     if SqlCode < SuccessCode;                                                           //0010
        uDpsds.wkQuery_Name = 'Delete_IDSPFDKEYS';                                       //0010
        IaSqlDiagnostic(uDpsds);                                                         //0016
     endif;                                                                              //0010
                                                                                         //0010
     //Delete entry from file IDSPFDSLOM.                                               //0010
     sqlStmt =  'Delete from IDSPFDSLOM Where';                                          //0010
                                                                                         //0010
     if wk_WildCard  <> *Blanks;                                                         //0010
        sqlStmt =  %trim(sqlStmt) + Space + 'Substr(SOFILE,1,'              +            //0010
                   %char(wk_Position) + ') = ' + Quote + %Trim(wk_WildCard) +            //0010
                   Quote;                                                                //0010
     else;                                                                               //0010
        sqlStmt =  %trim(sqlStmt) + Space + 'SOFILE = '+ Quote + %trim(iAOObjNam)        //0010
                   + Quote;                                                              //0010
     endif;                                                                              //0010
                                                                                         //0010
     //If Lib provided                                                                  //0010
     if iAOObjLib <> *Blanks;                                                            //0010
        sqlStmt =  %trim(sqlStmt) + Space + 'And SOLIB = '  +  Quote  +                  //0010
                   %trim(iAOObjLib) + Quote;                                             //0010
     endif;                                                                              //0010
                                                                                         //0010
     exec sql execute immediate :sqlStmt;                                                //0010
                                                                                         //0010
     if SqlCode < SuccessCode;                                                           //0010
        uDpsds.wkQuery_Name = 'Delete_IDSPFDSLOM';                                       //0010
        IaSqlDiagnostic(uDpsds);                                                         //0016
     endif;                                                                              //0010
                                                                                         //0010
     //Delete entry from file IDSPFDSEQ.                                                //0010
     sqlStmt =  'Delete from IDSPFDSEQ Where';                                           //0010
                                                                                         //0010
     if wk_WildCard  <> *Blanks;                                                         //0010
        sqlStmt =  %trim(sqlStmt) + Space + 'Substr(SQFILE,1,'              +            //0010
                   %char(wk_Position) + ') = ' + Quote + %trim(wk_WildCard) +            //0010
                   Quote;                                                                //0010
     else;                                                                               //0010
        sqlStmt =  %trim(sqlStmt) + Space + 'SQFILE='+ Quote + %Trim(iAOObjNam)          //0010
                   + Quote;                                                              //0010
     endif;                                                                              //0010
                                                                                         //0010
     //If Lib provided                                                                  //0010
     if iAOObjLib <> *Blanks;                                                            //0010
        sqlStmt =  %trim(sqlStmt) + Space + 'And SQLIB='  +  Quote  +                    //0010
                   %trim(iAOObjLib) + Quote;                                             //0010
     endif;                                                                              //0010
                                                                                         //0010
     exec sql execute immediate :sqlStmt;                                                //0010
                                                                                         //0010
     if SqlCode < SuccessCode;                                                           //0010
        uDpsds.wkQuery_Name = 'Delete_IDSPFDSEQ';                                        //0010
        IaSqlDiagnostic(uDpsds);                                                         //0016
     endif;                                                                              //0010
                                                                                         //0010
     //Delete entry from file IDSPFDRFMT.                                               //0010
     sqlStmt =  'Delete from IDSPFDRFMT Where';                                          //0010
                                                                                         //0010
     if wk_WildCard <> *Blanks;                                                          //0010
        sqlStmt =  %trim(sqlStmt) + Space + 'Substr(RFFILE,1,'              +            //0010
                   %char(wk_Position) + ') = ' + Quote + %trim(wk_WildCard) +            //0010
                   Quote;                                                                //0010
     else;                                                                               //0010
        sqlStmt =  %trim(Sqlstmt) + Space + 'RFFILE = '+ Quote + %Trim(iAOObjNam)        //0010
                   + Quote;                                                              //0010
     endif;                                                                              //0010
                                                                                         //0010
     //If Lib provided                                                                  //0010
     if iAOObjLib <> *Blanks;                                                            //0010
        sqlStmt =  %trim(sqlStmt) + Space + 'And RFLIB = '  +  Quote  +                  //0010
                   %trim(iAOObjLib) + Quote;                                             //0010
     endif;                                                                              //0010
                                                                                         //0010
     exec sql execute immediate :sqlStmt;                                                //0010
                                                                                         //0010
     if SqlCode < SuccessCode;                                                           //0010
        uDpsds.wkQuery_Name = 'Delete_IDSPFDRFMT';                                       //0010
        IaSqlDiagnostic(uDpsds);                                                         //0016
     endif;                                                                              //0010
                                                                                         //0010
     //Delete entry from file IDSPFDMBR.                                                //0010
     sqlStmt =  'Delete from IDSPFDMBR Where';                                           //0010
                                                                                         //0010
     if wk_WildCard <> *Blanks;                                                          //0010
        sqlStmt =  %trim(sqlStmt) + Space + 'Substr(MBFILE,1,'              +            //0010
                   %char(wk_Position) + ') = ' + Quote + %Trim(wk_WildCard) +            //0010
                   Quote;                                                                //0010
     else;                                                                               //0010
        sqlStmt =  %trim(sqlStmt) + Space + 'MBFILE = '+ Quote + %Trim(iAOObjNam)        //0010
                   + Quote;                                                              //0010
     endif;                                                                              //0010
                                                                                         //0010
     //If Lib provided                                                                  //0010
     if iAOObjLib <> *Blanks;                                                            //0010
        sqlStmt =  %trim(sqlStmt) + Space + 'And MBLIB = '  +  Quote  +                  //0010
                   %trim(iAOObjLib) + Quote;                                             //0010
     endif;                                                                              //0010
                                                                                         //0010
     exec sql execute immediate :sqlStmt;                                                //0010
                                                                                         //0010
     if SqlCode < SuccessCode;                                                           //0010
        uDpsds.wkQuery_Name = 'Delete_IDSPFDMBR';                                        //0010
        IaSqlDiagnostic(uDpsds);                                                         //0016
     endif;                                                                              //0010
                                                                                         //0010
     //Delete entry from file IDSPFDJOIN.                                               //0010
     sqlStmt =  'Delete from IDSPFDJOIN Where';                                          //0010
                                                                                         //0010
     if wk_WildCard <> *Blanks;                                                          //0010
        sqlStmt =  %trim(sqlStmt) + Space + 'Substr(JNFILE,1,'              +            //0010
                   %char(wk_Position) + ') = ' + Quote + %Trim(wk_WildCard) +            //0010
                   Quote;                                                                //0010
     else;                                                                               //0010
        sqlStmt =  %trim(sqlStmt) + Space + 'JNFILE = '+ Quote + %Trim(iAOObjNam)        //0010
                   + Quote;                                                              //0010
     endif;                                                                              //0010
                                                                                         //0010
     //If Lib provided                                                                  //0010
     if iAOObjLib <> *Blanks;                                                            //0010
        sqlStmt =  %trim(sqlStmt) + Space + 'And JNLIB = '  +  Quote  +                  //0010
                   %trim(iAOObjLib) + Quote;                                             //0010
     endif;                                                                              //0010
                                                                                         //0010
     exec sql execute immediate :sqlStmt;                                                //0010
                                                                                         //0010
     if SqlCode < SuccessCode;                                                           //0010
        uDpsds.wkQuery_Name = 'Delete_IDSPFDJOIN';                                       //0010
        IaSqlDiagnostic(uDpsds);                                                         //0016
     endif;                                                                              //0010
                                                                                         //0010
     //Delete entry from file IDSPFDTRG.                                                //0010
     sqlStmt =  'Delete from IDSPFDTRG Where';                                           //0010
                                                                                         //0010
     if wk_WildCard <> *Blanks;                                                          //0010
        sqlStmt =  %trim(sqlStmt) + Space + 'Substr(TRFILE,1,'              +            //0010
                   %char(wk_Position) + ') = ' + Quote + %Trim(wk_WildCard) +            //0010
                   Quote;                                                                //0010
     else;                                                                               //0010
        sqlStmt =  %Trim(sqlStmt) + Space + 'TRFILE = '+ Quote + %Trim(iAOObjNam)        //0010
                   + Quote;                                                              //0010
     endif;                                                                              //0010
                                                                                         //0010
     //If Lib provided                                                                  //0010
     if iAOObjLib <> *Blanks;                                                            //0010
        sqlStmt =  %trim(sqlStmt) + Space + 'And TRLIB = '  +  Quote  +                  //0010
                   %trim(iAOObjLib) + Quote;                                             //0010
     endif;                                                                              //0010
                                                                                         //0010
     exec sql execute immediate :sqlStmt;                                                //0010
                                                                                         //0010
     if SqlCode < SuccessCode;                                                           //0010
        uDpsds.wkQuery_Name = 'Delete_IDSPFDTRG';                                        //0010
        IaSqlDiagnostic(uDpsds);                                                         //0016
     endif;                                                                              //0010
                                                                                         //0010
     //Delete entry from file IDSPFDCST.                                                //0010
     sqlStmt =  'Delete from IDSPFDCST Where';                                           //0010
                                                                                         //0010
     if wk_WildCard <> *Blanks;                                                          //0010
        sqlStmt =  %trim(sqlStmt) + Space + 'Substr(CSFILE,1,'              +            //0010
                   %char(wk_Position) + ') = ' + Quote + %trim(wk_WildCard) +            //0010
                   Quote;                                                                //0010
     else;                                                                               //0010
        sqlStmt =  %trim(sqlStmt) + Space + 'CSFILE = '+ Quote + %trim(iAOObjNam)        //0010
                   + Quote;                                                              //0010
     endif;                                                                              //0010
                                                                                         //0010
     //If Lib provided                                                                  //0010
     if iAOObjLib <> *Blanks;                                                            //0010
        sqlStmt =  %trim(sqlStmt) + Space + 'And CSLIB = '  +  Quote  +                  //0010
                   %trim(iAOObjLib) + Quote;                                             //0010
     endif;                                                                              //0010
                                                                                         //0010
     exec sql execute immediate :sqlStmt;                                                //0010
                                                                                         //0010
     if SqlCode < SuccessCode;                                                           //0010
        uDpsds.wkQuery_Name = 'Delete_IDSPFDCST';                                        //0010
        IaSqlDiagnostic(uDpsds);                                                         //0016
     endif;                                                                              //0010
                                                                                         //0010
     //Delete entry from file IADSPDBR.                                                 //0010
     sqlStmt =  'Delete from IADSPDBR Where';                                            //0010
                                                                                         //0010
     if wk_WildCard <> *Blanks;                                                          //0010
        sqlStmt =  %trim(sqlStmt) + Space + 'Substr(WHRFI,1,'               +            //0010
                   %char(wk_Position) + ') = ' + Quote + %trim(wk_WildCard) +            //0010
                   Quote;                                                                //0010
     else;                                                                               //0010
        sqlStmt =  %trim(sqlstmt) + Space + 'WHRFI = '+ Quote + %trim(iAOObjNam)         //0010
                   + Quote;                                                              //0010
     endif;                                                                              //0010
                                                                                         //0010
     //If Lib provided                                                                  //0010
     if iAOObjLib <> *Blanks;                                                            //0010
        sqlStmt =  %trim(sqlStmt) + Space + 'And WHRLI = '  +  Quote  +                  //0010
                   %trim(iAOObjLib) + Quote;                                             //0010
     endif;                                                                              //0010
                                                                                         //0010
     exec sql execute immediate :sqlStmt;                                                //0010
                                                                                         //0010
     if SqlCode < SuccessCode;                                                           //0010
        uDpsds.wkQuery_Name = 'Delete_IADSPDBR';                                         //0010
        IaSqlDiagnostic(uDpsds);                                                         //0016
     endif;                                                                              //0010
                                                                                         //0010
     //Delete entry from file IDSPFFD.                                                  //0010
     sqlStmt =  'Delete from IDSPFFD Where';                                             //0010
                                                                                         //0010
     if wk_WildCard <> *Blanks;                                                          //0010
        sqlStmt =  %trim(sqlStmt) + Space + 'Substr(WHFILE,1,'              +            //0010
                   %char(wk_Position) + ') = ' + Quote + %trim(wk_WildCard) +            //0010
                   Quote;                                                                //0010
     else;                                                                               //0010
        sqlStmt =  %trim(sqlStmt) + Space + 'WHFILE = '+ Quote + %Trim(iAOObjNam)        //0010
                   + Quote;                                                              //0010
     endif;                                                                              //0010
                                                                                         //0010
     //If Lib provided                                                                  //0010
     if iAOObjLib <> *Blanks;                                                            //0010
        sqlStmt =  %trim(sqlStmt) + Space + 'And WHLIB = '  +  Quote  +                  //0010
                   %trim(iAOObjLib) + Quote;                                             //0010
     endif;                                                                              //0010
                                                                                         //0010
     exec sql execute immediate :sqlStmt;                                                //0010
                                                                                         //0010
     if SqlCode < SuccessCode;                                                           //0010
        uDpsds.wkQuery_Name = 'Delete_IDSPFFD';                                          //0010
        IaSqlDiagnostic(uDpsds);                                                         //0016
     endif;                                                                              //0010
                                                                                         //0010
  endsr;                                                                                 //0010
  //----------------------------------------------------------------------------------- //0010
  //Subroutine: deleteDSPOBJD_OutFile                                                   //0010
  //Delete the entries of excluded objects from IDSPOBJD file                           //0010
  //----------------------------------------------------------------------------------- //0010
  begsr deleteDSPOBJD_OutFile;                                                           //0010
                                                                                         //0010
     sqlStmt =  'Delete from IDSPOBJD Where';                                            //0010
     if wk_WildCard <> *Blanks;                                                          //0010
        sqlStmt =  %trim(sqlStmt) + Space + 'Substr(ODOBNM,1,' +                         //0010
                   %char(wk_Position) + ') = ' + Quote + %trim(wk_WildCard) +            //0010
                   Quote;                                                                //0010
     else;                                                                               //0010
        sqlStmt =  %trim(sqlStmt) + Space + 'ODOBNM = '+ Quote + %Trim(iAOObjNam)        //0010
                   + Quote;                                                              //0010
     endif;                                                                              //0010
                                                                                         //0010
     //If LIB provided                                                                  //0010
     if iAOObjLib <> *Blanks;                                                            //0010
        sqlStmt =  %trim(sqlStmt) + Space + 'And ODLBNM =' + Quote +                     //0010
                   %trim(iAOObjLib) + Quote ;                                            //0010
     endif;                                                                              //0010
                                                                                         //0010
     //If TYPE provided                                                                 //0010
     if iAOObjTyp <> *Blanks;                                                            //0010
        sqlStmt =  %trim(sqlStmt) + Space + 'And ODOBTP =' + Quote +                     //0010
                   %trim(iAOObjTyp) + Quote;                                             //0010
     endif;                                                                              //0010
                                                                                         //0010
     exec sql execute immediate :sqlStmt;                                                //0010
                                                                                         //0010
     if SqlCode < SuccessCode;                                                           //0010
        uDpsds.wkQuery_Name = 'Delete_IDSPOBJD';                                         //0010
        IaSqlDiagnostic(uDpsds);                                                         //0016
     endif;                                                                              //0010
                                                                                         //0010
  endsr;                                                                                 //0010
                                                                                         //0010
  //----------------------------------------------------------------------------------- //0010
  //Subroutine: deleteIAALLREFPF                                                        //0010
  //Delete the entries of excluded objects as referenced as well as referencing         //0010
  //object.                                                                             //0010
  //----------------------------------------------------------------------------------- //0001
  begsr deleteIAALLREFPF;                                                                //0010
                                                                                         //0010
     //Delete as referenced object                                                      //0010
     sqlStmt =  'Delete from IAALLREFPF Where';                                          //0010
     if wk_WildCard <>  *Blanks;                                                         //0010
        sqlStmt =  %Trim(sqlStmt) + Space + 'Substr(iarObjNam,1,'           +            //0010
                   %Char(wk_Position) + ') = ' + Quote + %Trim(wk_WildCard) +            //0010
                   Quote;                                                                //0010
     else;                                                                               //0010
        sqlStmt =  %Trim(sqlStmt) + Space + 'iarObjNam= '+ Quote +                       //0010
                   %Trim(iAOObjNam) + Quote;                                             //0010
                                                                                         //0010
     endif;                                                                              //0010
                                                                                         //0010
     //Lib = both *LIBL and LIBNAME, If IAOOBJLIB = ' ' then do not check lib           //0010
     if iAOObjLib <> *Blanks;                                                            //0010
        sqlStmt =  %Trim(sqlStmt) + Space + 'And (IarObjLib =' + Quote +                 //0010
                   %Trim(iAOObjLib) + Quote  +  Space  +  'Or IarObjLib ='  +            //0010
                   Quote + '*LIBL' +  Quote + ')';                                       //0010
                                                                                         //0010
     endif;                                                                              //0010
                                                                                         //0010
     //If TYPE provided                                                                 //0010
     if iAOObjTyp <> *Blanks;                                                            //0010
        sqlStmt =  %Trim(sqlStmt) + Space + 'And iarObjTyp =' + Quote +                  //0010
                   %Trim(iAOObjTyp) + Quote;                                             //0010
     endif;                                                                              //0010
                                                                                         //0010
     exec sql execute immediate :sqlStmt;                                                //0010
                                                                                         //0010
     if SqlCode < SuccessCode;                                                           //0010
        uDpsds.wkQuery_Name = 'Delete_IAALLREFPF';                                       //0010
        IaSqlDiagnostic(uDpsds);                                                         //0016
     endif;                                                                              //0010
                                                                                         //0010
     //Delete as referencing object                                                     //0010
     sqlStmt =  'Delete from IAALLREFPF Where';                                          //0010
     if wk_WildCard <>  *Blanks;                                                         //0010
        sqlStmt =  %Trim(sqlStmt) + Space + 'Substr(IaoObjNam,1,'           +            //0010
                   %Char(wk_Position) + ') = ' + Quote + %Trim(wk_WildCard) +            //0010
                   Quote;                                                                //0010
     else;                                                                               //0010
        sqlStmt =  %Trim(sqlStmt) + Space + 'IaoObjNam = '+ Quote +                      //0010
                   %Trim(iAOObjNam)  + Quote;                                            //0010
     endif;                                                                              //0010
                                                                                         //0010
     //If LIB  provided                                                                 //0010
     if iAOObjLib <> *Blanks;                                                            //0010
        sqlStmt =  %Trim(sqlStmt) + Space + 'And IaoObjLib=' + Quote +                   //0010
                   %Trim(iAOObjLib) + Quote ;                                            //0010
     endif;                                                                              //0010
                                                                                         //0010
     //If TYPE provided                                                                 //0010
     if iAOObjTyp <> *Blanks;                                                            //0010
        sqlStmt =  %Trim(sqlStmt) + Space + 'And iaoObjTyp=' + Quote +                   //0010
                   %Trim(iAOObjTyp) + Quote;                                             //0010
     endif;                                                                              //0010
                                                                                         //0010
     exec sql execute immediate :sqlStmt;                                                //0010
                                                                                         //0010
     if SqlCode < SuccessCode;                                                           //0010
        uDpsds.wkQuery_Name = 'Delete_IAALLREFPF';                                       //0010
        IaSqlDiagnostic(uDpsds);                                                         //0016
     endif;                                                                              //0010
                                                                                         //0010
  endsr;                                                                                 //0010
                                                                                         //0010
end-proc;                                                                                //0010
//-------------------------------------------------------------------------------------* //0010
