**free
      //%METADATA                                                      *
      // %TEXT Update reference library in IAALLREFPF                  *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------- //
//Created By  :  Programmers.io @ 2024                                                  //
//Created Date:  16-Jan-2024                                                            //
//Developer   :  Venkatesh Battula                                                      //
//Description :  Update reference library in IAALLREFPF                                 //
//Task#       :  523                                                                    //
//                                                                                      //
//Procedure Log:                                                                        //
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
//02/19/24|0001    |Hemant      | #584:Actual library is not getting updated in         //
//       |        |            | IAALLREFPF in Referenced_Object_Library column.       //
//05/29/24|0002    |Akhil K.    | #15 :When the referenced object library is *LIBL      //
//        |        |            | record that object in IAGENAUDTP as a missing object. //
//05/30/24|0003    |Vamsi       | #15 :Just added the check before inserting into       //
//        |        |Krishna2    | IAGENAUDTP to avoid duplicate records.                //
//06/06/24|0004    |Saumya      | Rename AIEXCTIMR to IAEXCTIMR [Task #262]             //
//05/07/24|0005    |Akhil K.    | Renamed AIERRBND, AICERRLOG, AIDERRLOG and AISQLDIAGNO//
//        |        |            | STIC with IA*                                         //
//24/09/24|0006    |Manav T.    | IAALLREFPF : Data Population Issue for File in QTEMP  //
//        |        |            | [Task #962]                                           //
//20/08/24|0007    |Sabarish    | IFS Member Parsing Upgrade [Task 833]                 //
//------------------------------------------------------------------------------------- //
ctl-opt Copyright('Programmers.io Â© 2024');
ctl-opt option(*NoDebugIO : *SrcStmt : *noUnRef);
ctl-opt dftactgrp(*No);
ctl-opt bndDir('IAERRBND');                                                              //0005

//------------------------------------------------------------------------------------- //
//Variable Declaration
//------------------------------------------------------------------------------------- //
dcl-s uptimestamp     Timestamp;
dcl-s uppgm_name      char(10)   inz;
dcl-s uplib_name      char(10)   inz;
dcl-s upsrc_name      char(10)   inz;

dcl-s wRefObject       char(10) inz;
dcl-s wRefObjLib       char(10) inz;
dcl-s wRefObjType      char(10) inz;
dcl-s recCount         packed(4:0) inz;                                                  //0003

//------------------------------------------------------------------------------------- //
//Prototype Declaration
//------------------------------------------------------------------------------------- //
dcl-pr IAEXCTIMR extpgm('IAEXCTIMR');                                                    //0004
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

//------------------------------------------------------------------------------------- //
//Copybook Declaration
//------------------------------------------------------------------------------------- //
/copy 'QCPYSRC/iaderrlog.rpgleinc'

//------------------------------------------------------------------------------------- //
//Entry Parameter
//------------------------------------------------------------------------------------- //
dcl-pi IAUPREFLIB extpgm('IAUPREFLIB');
   xref char(10) Const;
end-pi;

//------------------------------------------------------------------------------------- //
//Set options
//------------------------------------------------------------------------------------- //
Exec sql
  set option Commit = *None,
             Naming = *Sys,
             DynUsrPrf = *User,
             CloSqlCsr = *EndMod;

//------------------------------------------------------------------------------------- //
//Main logic
//------------------------------------------------------------------------------------- //
eval-corr uDpsds = wkuDpsds;

//Insert process start time
upTimeStamp = %Timestamp();
callP IAEXCTIMR('BLDMTADTA' :udpsds.ProcNme : udpsds.Lib : '*PGM' :                      //0004
   //0007 upsrc_name : uppgm_name : uplib_name : ' ' : uptimeStamp : 'INSERT');
   upsrc_name : uppgm_name : uplib_name : ' ' : ' ' : uptimeStamp : 'INSERT');           //0007

//Update reference library
exsr updateRefLibraries;

//Update process end time
upTimeStamp = %Timestamp();
callP IAEXCTIMR('BLDMTADTA' :udpsds.ProcNme : udpsds.Lib : '*PGM' :                      //0004
   //0007 upsrc_name : uppgm_name : uplib_name : ' ' : uptimeStamp : 'UPDATE');
   upsrc_name : uppgm_name : uplib_name : ' ' : ' ' : uptimeStamp : 'UPDATE');           //0007

*Inlr = *On;

/copy 'QCPYSRC/iacerrlog.rpgleinc'

//------------------------------------------------------------------------------------- //
//updateRefLibraries - Update Reference Library from IAALLREFPF
//------------------------------------------------------------------------------------- //
begsr updateRefLibraries;

   //Define Cursor
   exec sql
      declare refLibCursor cursor for
        select iARObjLib,
               iARObjNam,
               iARObjTyp
          from iAAllRefPf
         where iARObjLib = ' '
            or iARObjLib = '*LIBL'
            or iARObjLib = 'QTEMP'
            or iARObjLib = '*CURLIB'
            or substr(iARObjLib,1,1) = '&'
            or iARObjLib not in (select library_Name
                                   from iAInpLib
                                  where xrefnam = :xref)
           for update of iARObjLib;

   //Open the Cursor
   exec sql open refLibCursor;

   if sqlCode = CSR_OPN_COD;
      exec sql close refLibCursor;
      exec sql open  refLibCursor;
   endif;

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Open_refLibCursor';
      IaSqlDiagnostic(uDpsds);                                                           //0005
   endif;

   exec sql
      fetch refLibCursor into :wRefObjLib,
                              :wRefObject,
                              :wRefObjType;
   dow sqlCode = successCode;

      getRefLibraryName(wRefObjLib);

      exec sql
         update iAAllRefPf
            set iARObjLib = :wRefObjLib
          where current of refLibCursor;

      if sqlCode < successCode;
         uDpsds.wkQuery_Name = 'Update_refLibCursor';
         IaSqlDiagnostic(uDpsds);                                                        //0005
      endif;

      //If reference object library in IAALLREFPF is '*LIBL', add that object
      //in IAGENAUDTP
      if wRefObjLib = '*LIBL';                                                           //0002
         exsr insertIntoAuditFile;                                                       //0002
      endIf;                                                                             //0002

      exec sql
         fetch refLibCursor into :wRefObjLib,
                                 :wRefObject,
                                 :wRefObjType;
   enddo;

   //Close the cursor
   exec sql close refLibCursor;

endsr;

//------------------------------------------------------------------------------------- //0002
//insertIntoAuditFile - Record referenced object if it does not exist in application    //0002
//                      libraries.                                                      //0002
//------------------------------------------------------------------------------------- //0002
begSr insertIntoAuditFile;                                                               //0002
                                                                                         //0002
   exec sql                                                                              //0003
        select count(*) into :recCount from iAGenAudtP                                   //0003
         where UniqueCode = 'NoRefFnd'                                                   //0003
           and iAObjName  = :wRefObject                                                  //0003
           and iAObjTyp   = :wRefObjType ;                                               //0003
                                                                                         //0003
  If recCount = 0;                                                                       //0003
                                                                                         //0003
     exec sql                                                                            //0002
          insert into iAGenAudtP (UniqueCode,                                            //0002
                                  iADesText ,                                            //0002
                                  iAObjName ,                                            //0002
                                  iAObjTyp  ,                                            //0002
                                  Crtuser   ,                                            //0002
                                  Crtpgm    )                                            //0002
          values ('NoRefFnd',                                                            //0002
                  'Referenced Object Does Not Exist',                                    //0002
                  :wRefObject    ,                                                       //0002
                  :wRefObjType   ,                                                       //0002
                  :uDpsds.User   ,                                                       //0002
                  :uDpsds.SrcMbr );                                                      //0002
                                                                                         //0002
     if SqlCode < SuccessCode;                                                           //0002
        uDpsds.wkQuery_Name = 'Insert_Iagenaudtp';                                       //0002
        IaSqlDiagnostic(uDpsds);                                                         //0005
     endif;                                                                              //0002
                                                                                         //0003
  endif;                                                                                 //0003
                                                                                         //0002
endSr;                                                                                   //0002

//------------------------------------------------------------------------------------- //
// getRefLibraryName: Get the appropriate library.
//------------------------------------------------------------------------------------- //
dcl-proc  getRefLibraryName;

   dcl-pi getRefLibraryName;
      RefObjLibnm char(10);
   end-pi;

   exec sql
     select case when odlbnm = ' ' then '*LIBL'
                 else odlbnm end
      into :RefObjLibnm
      from IDSPOBJD
      join IAINPLIB
        on xlibnam = odlbnm
     where xrefnam = :xref
       and odobnm  = :wRefObject
       and odobtp =  :wRefObjType                                                        //0006
     order by xlibseq
     limit 1;

   if sqlCode < successCode;
      uDpsds.wkquery_Name = 'Get_RefLibraryName';
      IaSqlDiagnostic(uDpsds);                                                           //0005
   endif;

   if sqlCode =NO_DATA_FOUND or RefObjLibnm = *Blanks;
      RefObjLibnm ='*LIBL';
   endif;

   return ;

end-proc;
