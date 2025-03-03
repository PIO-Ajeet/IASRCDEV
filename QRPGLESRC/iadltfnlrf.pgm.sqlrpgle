**free
      //%METADATA                                                      *
      // %TEXT Delete Final References from IAALLREFPF for S/O         *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------- //
//Created By    : Programmers.io @ 2024                                                 //
//Created Date  : 2024/02/24                                                            //
//Developer     : Abhijith Ravindran                                                    //
//Description   : This program updates(deltes,reverts) the references/usages in IAALLREF//
//              : when any object/source that was present in INIT run and is deleted    //
//              : on REFRESH run.It acts on Source/Object-Source based references and is//
//              : driven from IAREFOBJF file-selecting deleted source/objects.          //
//------------------------------------------------------------------------------------- //
//Modification Log:                                                                     //
//------------------------------------------------------------------------------------- //
//Date    | Mod_ID | Developer  | Case and Description                                  //
//--------|--------|------------|------------------------------------------------------ //
//04/07/24| 0001   | Vamsi      | Rename Bnddir AIERRBND, copybooks AICERRLOG/AIDERRLOG //
//        |        |            | and procedures AISQLDIAGNOSTIC and AIPSSRERRORLOG     //
//        |        |            | with IA*  [Task#261]                                  //
//16/09/24| 0002   | Gopi Thorat| Rename IACPYBDTL file fields wherever used due to     //
//        |        |            | table changes. [Task#940]                             //
//        |        |            |                                                       //
//------------------------------------------------------------------------------------- //
ctl-opt copyright('Programmers.io © 2024');
ctl-opt option(*nodebugio:*srcstmt:*nounref);
ctl-opt dftactgrp(*no);
ctl-opt bndDir('IAERRBND');                                                              //0001

//------------------------------------------------------------------------------------- //
//Main Entry Parameter
//------------------------------------------------------------------------------------- //
dcl-pr IADLTFNLRF extpgm('IADLTFNLRF');
   in_repoName    char(10);
end-pr;

dcl-pi IADLTFNLRF;
   in_repoName    char(10);
end-pi;

//------------------------------------------------------------------------------------- //
//Prototype Declaration
//------------------------------------------------------------------------------------- //

//------------------------------------------------------------------------------------- //
//Standalone Variable Definitions
//------------------------------------------------------------------------------------- //
dcl-s wkRefObjectUsage     char(10);
dcl-s wkSqlString          varchar(2000);

//------------------------------------------------------------------------------------- //
//Data Structure Definitions
//------------------------------------------------------------------------------------- //
dcl-ds dltObjDtls qualified;
   objectName        char(10);
   objectLibrary     char(10);
   objectType        char(10);
   objectAtr         char(10);
end-ds;

dcl-ds dltSrcDtls qualified;
   memberName        char(10);
   memberLib         char(10);
   memberSrcPf       char(10);
   memberType        char(10);
end-ds;

dcl-ds dltSrcRefs qualified;
   objectLibrary     char(10);
   objectName        char(10);
   objectType        char(10);
   objectAtr         char(10);
   refObjName        char(80);
   refObjType        char(11);
   refObjUsage       char(10);
end-ds;

//------------------------------------------------------------------------------------- //
//Constant Definitions
//------------------------------------------------------------------------------------- //
dcl-c  wkQuote   '''';
//------------------------------------------------------------------------------------- //
//Copy Book Definitions
//------------------------------------------------------------------------------------- //
/copy 'QCPYSRC/iaderrlog.rpgleinc'
/copy 'QCPYSRC/iamsgsflf.rpgleinc'
/copy 'QMODSRC/iasrv01pr.rpgleinc'

//------------------------------------------------------------------------------------- //
//Set Options
//------------------------------------------------------------------------------------- //
exec sql
  set option Commit    = *None,
             Naming    = *Sys,
             UsrPrf    = *User,
             DynUsrPrf = *User,
             CloSqlCsr = *EndMod;

//------------------------------------------------------------------------------------- //
//Main Logic
//------------------------------------------------------------------------------------- //
//Delete object driven references
removeObjectUsageReferences();

//Delete source driven references
removeSourceUsageReferences();

*inlr = *on;
return;

//------------------------------------------------------------------------------------- //
// removeObjectUsageReferences : Delete object based usage mappings.
//------------------------------------------------------------------------------------- //
dcl-proc removeObjectUsageReferences;

   //Reset variables
   reset dltObjDtls;

   //Cursor to fecth the deleted objects during refresh
   exec sql
     declare deletedObjects cursor for
       Select a.iaobjname, a.iaobjlib, a.iaobjtype, a.iaobjattr
         from iarefobjf a
        where a.iaobjname <> ''
          and a.iaobjlib  <> ''
          and a.iaobjtype <> ''
          and a.status    =  'D'
     order by a.iaobjname, a.iaobjlib, a.iaobjtype, a.iaobjattr;

   //Open cursor
   exec sql open deletedObjects;
   if sqlCode = CSR_OPN_COD;
      exec sql close deletedObjects;
      exec sql open  deletedObjects;
   endif;

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Open_ObjDlt';
      IaSqlDiagnostic(uDpsds);                                                           //0001
   endif;

   //Fetch records from Deleted Sources cursor
   exec sql
      fetch deletedObjects into :dltObjDtls;

   dow sqlcode = successCode;

      //Update usage for the objects mapped from source
      deleteIAALLREFPF(dltObjDtls.objectLibrary :
                       dltObjDtls.objectName :
                       dltObjDtls.objectType :
                       dltObjDtls.objectAtr);

      //Fetch records from Deleted Objects cursor
      exec sql
         fetch deletedObjects into :dltObjDtls;

      if sqlCode < successCode;
         uDpsds.wkQuery_Name = 'Fetch_ObjDlt';
         IaSqlDiagnostic(uDpsds);                                                        //0001
      endif;

   endDo;

   exec sql Close deletedObjects;

end-proc;

//------------------------------------------------------------------------------------- //
// removeSourceUsageReferences : Delete source based usage mappings.
//------------------------------------------------------------------------------------- //
dcl-proc removeSourceUsageReferences;

   //Reset variables
   dcl-s isCopybookbased   ind inz('0');

   //Cursor to fecth the deleted sources during refresh
   exec sql
     declare deletedSources cursor for
      Select a.iamemname, a.iamemlib, a.iasrcpf, a.iamemtype
        from iarefobjf a
       where a.iamemname <> ''
         and a.iamemlib  <> ''
         and a.iasrcpf   <> ''
         and a.status    =  'D'
    order by a.iamemname, a.iamemlib, a.iasrcpf, a.iamemtype;

   //Open cursor
   exec sql open deletedSources;
   if sqlCode = CSR_OPN_COD;
      exec sql close deletedSources;
      exec sql open  deletedSources;
   endif;

   //Handle SQL errors
   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Open_SrcDlt';
      IaSqlDiagnostic(uDpsds);                                                           //0001
   endif;

   //Fetch records from Deleted Sources cursor
   exec sql
     fetch deletedSources into :dltSrcDtls;

   dow sqlcode = successCode;

      //Check if the source has object mapping
      if objectMappingExist(dltSrcDtls);
         isCopybookbased = '0';
         prepareSourceCursor(dltSrcDtls);
      else;
         isCopybookbased = '1';
         prepareCopybookCursor(dltSrcDtls);
      endIf;

      //Process Source References
      processSourceReferences(dltSrcDtls);

      //Delete records from IASRCINTPF & IACPYBDTL
      deleteIASRCINTPF(dltSrcDtls);
      if isCopybookbased;
         deleteIACPYBDTL(dltSrcDtls);
      endIf;
      //Fetch records from Deleted Sources cursor
      exec sql
         fetch deletedSources into :dltSrcDtls;
   endDo;

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Fetch_SrcDlt';
      IaSqlDiagnostic(uDpsds);                                                           //0001
   endif;

   exec Sql Close deletedSources;
end-proc;
//------------------------------------------------------------------------------------- //
// deleteIAALLREFPF : Delete the IAALLREFPF record.
//------------------------------------------------------------------------------------- //
dcl-proc deleteIAALLREFPF;

   dcl-pi deleteIAALLREFPF;
      objectLib     char(10);
      objectName    char(10);
      objectType    char(10);
      objectAtr     char(10);
      refObjName    char(10) options(*nopass);
      refObjType    char(10) options(*nopass);
      refObjLib     char(10) options(*nopass);
   end-pi;

   //Local variables
   dcl-s wkRefObjName        char(10) inz;
   dcl-s wkRefObjType        char(10) inz;

   //Set work variables
   if %parms() > 4;
      wkRefObjName = refObjName;
      wkRefObjType = refObjType;
   endIf;

   //Delete details from IAALLREFPF
   exec sql
     delete from IAALLREFPF a
     where ((a.iaoobjlib = :objectLib    And
           a.iaoobjnam   = :objectName   And
           a.iaoobjtyp   = :objectType)  OR

           (a.iarobjnam  = :objectName   And
           a.iarobjtyp   = :objectType)) AND

           (:wkRefObjName = '' or a.iarobjnam = :wkRefObjName) And
           (:wkRefObjType = '' or a.iarobjtyp = :wkRefObjType);

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Delete_IAALLREFPF';
      IaSqlDiagnostic(uDpsds);                                                           //0001
   endif;

end-proc;

//------------------------------------------------------------------------------------- //
// objectMappingExist : Check if the object mapping exist for the source.
//------------------------------------------------------------------------------------- //
dcl-proc objectMappingExist;

   dcl-pi objectMappingExist ind;
      parmDltSrcDtls     likeds(dltSrcDtls);
   end-pi;

   //Declare local varaibles
   dcl-s wkRcdExist    ind inz(*off);

   //Delete details from IAOBJREFPF
   exec sql
     select '1' into :wkRcdExist
       from iaobjmap a
      where a.iambrlib   =  :parmDltSrcDtls.memberLib
        and a.iambrsrcf  =  :parmDltSrcDtls.memberSrcPf
        and a.iambrnam   =  :parmDltSrcDtls.memberName
        and a.iambrtyp   =  :parmDltSrcDtls.memberType
      limit 1;

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Fetch_1_IAOBJMAP';
      IaSqlDiagnostic(uDpsds);                                                           //0001
   endif;

   return wkRcdExist;

end-proc;

//------------------------------------------------------------------------------------- //
// prepareSrcbasedCursor : Prepare source based cursor.
//------------------------------------------------------------------------------------- //
dcl-proc prepareSourceCursor;

   dcl-pi prepareSourceCursor;
      parmDltSrcDtls      likeds(dltSrcDtls);
   end-pi;

   wkSqlString =
      'Select distinct b.iaobjlib, b.iaobjnam, b.iaobjtyp, b.iaobjatr, a.iarefobj, ' +
              'a.iarefotyp,a.iarefousg ' +
      'from   iasrcintpf a ' +

      'join   iaobjmap b ' +
      'on     b.iambrlib  = a.iambrlib ' +
      'and    b.iambrsrcf = a.iambrsrc ' +
      'and    b.iambrnam  = a.iambrnam ' +
      'and    b.iambrtyp  = a.iambrtyp ' +

      'where  a.iambrlib = ' + wkQuote + %trim(parmDltSrcDtls.memberLib) + wkQuote +
      ' and   a.iambrsrc = ' + wkQuote + %trim(parmDltSrcDtls.memberSrcPf) + wkQuote +
      ' and   a.iambrnam = ' + wkQuote + %trim(parmDltSrcDtls.memberName) + wkQuote +
      ' and   a.iambrtyp = ' + wkQuote + %trim(parmDltSrcDtls.memberType) + wkQuote;

end-proc;

//------------------------------------------------------------------------------------- //
// prepareCopybookCursor : Prepare copybook based cursor.
//------------------------------------------------------------------------------------- //
dcl-proc prepareCopybookCursor;

   dcl-pi prepareCopybookCursor;
      parmDltSrcDtls likeds(dltSrcDtls);
   end-pi;

   //Cursor to fetch the deleted source's references
   wkSqlString =
      'Select distinct c.iaobjlib, c.iaobjnam, c.iaobjtyp, c.iaobjatr, a.iarefobj, ' +
            'a.iarefotyp,a.iarefousg' +
      'from   iasrcintpf a ' +

      'join   iacpybdtl b ' +
      'on     b.iACpyLib   =  a.iAMbrLib ' +                                             //0002
      'and    b.iACpySrcPf =  a.iAMbrSrc ' +                                             //0002
      'and    b.iACpyMbr   =  a.iAMbrNam ' +                                             //0002

      'join   iaobjmap c ' +
      'on     c.iAMbrLib  =  b.iAMbrLib ' +                                              //0002
      'and    c.iAMbrSrcf =  b.iAMbrSrcPf ' +                                            //0002
      'and    c.iAMbrNam  =  b.iAMbrName ' +                                             //0002

      'where  a.iambrlib = ' + wkQuote + %trim(parmDltSrcDtls.memberLib) + wkQuote +
      ' and   a.iambrsrc = ' + wkQuote + %trim(parmDltSrcDtls.memberSrcPf) + wkQuote +
      ' and   a.iambrnam = ' + wkQuote + %trim(parmDltSrcDtls.memberName) + wkQuote +
      ' and   a.iambrtyp = ' + wkQuote + %trim(parmDltSrcDtls.memberType) + wkQuote ;

end-proc;

//------------------------------------------------------------------------------------- //
// processSourceReferences : Process the source refrences.
//------------------------------------------------------------------------------------- //
dcl-proc processSourceReferences;

   dcl-pi processSourceReferences;
      parmDltSrcDtls      likeds(dltSrcDtls);
   end-pi;

   //Variable declarations
   dcl-s wkRefObjUsage    char(10) inz;
   dcl-s wkMappedFrom     char(7) inz;

   dcl-ds wkDltSrcRefs    likeds(dltSrcRefs) inz;

   //Prepare cursor
   exec sql
      prepare sqlStatement from :wkSqlString;

   //Cursor to fetch the deleted source's references
   exec sql
     declare deletedSourceReferences cursor for sqlStatement;

   //Open cursor
   exec sql open deletedSourceReferences;
   if sqlCode = CSR_OPN_COD;
      exec sql close deletedSourceReferences;
      exec sql open  deletedSourceReferences;
   endif;

   //Handle SQL errors
   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Open_DltSrcRef';
      IaSqlDiagnostic(uDpsds);                                                           //0001
   endif;

   //Fetch records from Deleted Sources cursor
   exec sql
     fetch deletedSourceReferences into :dltSrcRefs;

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Fetch_DltSrcRef';
      IaSqlDiagnostic(uDpsds);                                                           //0001
   endif;

   //Map work variables if blanks
   if sqlcode = successCode;
      wkDltSrcRefs = dltSrcRefs;
      wkMappedFrom = getAllRefMappedBasedOn(dltSrcRefs: wkRefObjUsage);
      wkRefObjectUsage = wkRefObjUsage;
   endIf;

   dow sqlcode = successCode;

      //update/delete object details from IAALLREFPF
      if (wkDltSrcRefs.objectLibrary <>  dltSrcRefs.objectLibrary or
          wkDltSrcRefs.objectName    <>  dltSrcRefs.objectName    or
          wkDltSrcRefs.objectType    <>  dltSrcRefs.objectType    or
          wkDltSrcRefs.objectAtr     <>  dltSrcRefs.objectAtr     or
          wkDltSrcRefs.refObjName    <>  dltSrcRefs.refObjName    or
          wkDltSrcRefs.refObjType    <>  dltSrcRefs.refObjType);
         //update only if source based mapping
         if wkMappedFrom <> 'O'  And wkRefObjectUsage  <>  *Blanks;
            updateIAALLREFPF(wkDltSrcRefs : wkRefObjectUsage);
         endif;

         wkMappedFrom = getAllRefMappedBasedOn(dltSrcRefs: wkRefObjUsage);
         wkDltSrcRefs = dltSrcRefs;

      endIf;

      //Delete record from IAALLREFPF if mapped only based on source
      if (wkMappedFrom = 'S');

         deleteIAALLREFPF(dltSrcRefs.objectLibrary :
                          dltSrcRefs.objectName :
                          dltSrcRefs.objectType :
                          dltSrcRefs.objectAtr :
                          dltSrcRefs.refObjName :
                          dltSrcRefs.refObjType);

      elseif (wkMappedFrom = 'O/S');

         //Check for Object mapped usage existence,only for *FILE objects
         if dltSrcRefs.refObjType = '*FILE'
            and Not objectUsageExist(dltSrcRefs);
            wkRefObjectUsage =  %Xlate(%Trim(dltSrcRefs.refObjUsage) : ' ' :
                                             wkRefObjUsage);
            wkRefObjectUsage =  %Xlate('/ ' : ' ' : wkRefObjectUsage);
         endIf;

      endIf;

      //Fetch records from Deleted Sources cursor
      exec sql
         fetch deletedSourceReferences into :dltSrcRefs;

      if sqlCode < successCode;
         uDpsds.wkQuery_Name = 'Fetch_DltSrcRef';
         IaSqlDiagnostic(uDpsds);                                                        //0001
      endif;

   endDo;

   //Update IAALLREFPF
   if wkDltSrcRefs      <>  *Blanks  And
      wkMappedFrom      <>  'O'      And
      wkRefObjectUsage  <>  *Blanks;
      updateIAALLREFPF(wkDltSrcRefs : wkRefObjectUsage);
   endif;

   Exec Sql Close deletedSourceReferences;

end-proc;

//------------------------------------------------------------------------------------- //
// getAllRefMappedBasedOn : Check if the object mapping exist for the source.
//------------------------------------------------------------------------------------- //
dcl-proc getAllRefMappedBasedOn;

   dcl-pi getAllRefMappedBasedOn    char(7);
      parmDltSrcRefs        likeds(dltSrcRefs);
      parmRefObjUsage       char(10);
   end-pi;

   //Declare local varaibles
   dcl-s wkMapBasedOn       char(7) inz;

   parmRefObjUsage = *Blanks;
   //get mapping details
   exec sql
     select a.iamapfrm, a.iarusages
       into :wkMapBasedOn, :parmRefObjUsage
       from iaallrefpf a
      where a.iaoobjlib = :parmDltSrcRefs.objectLibrary
        and a.iaoobjnam = :parmDltSrcRefs.objectName
        and a.iaoobjtyp = :parmDltSrcRefs.objectType
        and a.iaoobjatr = :parmDltSrcRefs.objectAtr
        and a.iarobjnam = :parmDltSrcRefs.refObjName
        and a.iarobjtyp = :parmDltSrcRefs.refObjType
      limit 1;

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Fetch_1_IAALLREFPF';
      IaSqlDiagnostic(uDpsds);                                                           //0001
   endif;

   return wkMapBasedOn;

end-proc;

//------------------------------------------------------------------------------------- //
// objectUsageExist : Check if the usage exist for object.
//------------------------------------------------------------------------------------- //
dcl-proc objectUsageExist;

   dcl-pi objectUsageExist ind;
      parmDltSrcRefs        likeds(dltSrcRefs);
   end-pi;

   //Variable declarations
   dcl-s wkObjUsageExist    ind inz;

   //Get the source usage for the object
   exec sql
      select '1'
        into :wkObjUsageExist
        from iaobjrefpf a
       where a.whlib = :parmDltSrcRefs.objectLibrary
         and a.whpnam = :parmDltSrcRefs.objectName
         and a.whfnam = :parmDltSrcRefs.refObjName
         and a.whotyp = :parmDltSrcRefs.refObjType
         and ((:parmDltSrcRefs.refObjUsage = 'I' and (a.whfusg = 0 or a.whfusg = 1 or
                      a.whfusg = 3 or a.whfusg > 7))
          or (:parmDltSrcRefs.refObjUsage  = 'O' and (a.whfusg = 2 or a.whfusg = 3 or
                      a.whfusg = 6 or a.whfusg = 7))
          or (:parmDltSrcRefs.refObjUsage  = 'U' and (a.whfusg = 4 or a.whfusg = 5 or
                      a.whfusg = 6 or a.whfusg = 7)));

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Fetch_ObjUsage';
      IaSqlDiagnostic(uDpsds);                                                           //0001
   endif;

   return wkObjUsageExist;

end-proc;

//------------------------------------------------------------------------------------- //
// updateIAALLREFPF : Update the IAALLREPF record.
//------------------------------------------------------------------------------------- //
dcl-proc updateIAALLREFPF;

   dcl-pi updateIAALLREFPF;
      parmDltSrcRefs    likeds(dltSrcRefs);
      parmRefObjUsage   char(7);
   end-pi;

   //Update details into IAALLREFPF
   exec sql
     update iaallrefpf a
        set a.iamapfrm = 'O',
            a.iarusages = :parmRefObjUsage
      where a.iaoobjlib = :parmDltSrcRefs.objectLibrary
        and a.iaoobjnam = :parmDltSrcRefs.objectName
        and a.iaoobjtyp = :parmDltSrcRefs.objectType
        and a.iaoobjatr = :parmDltSrcRefs.objectAtr
        and a.iarobjnam = :parmDltSrcRefs.refObjName
        and a.iarobjtyp = :parmDltSrcRefs.refObjType;

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Update_IAALLREFPF';
      IaSqlDiagnostic(uDpsds);                                                           //0001
   endif;

end-proc;

//------------------------------------------------------------------------------------- //
// deleteIASRCINTPF : Delete the IASRCINTPF record.
//------------------------------------------------------------------------------------- //
dcl-proc deleteIASRCINTPF;

   dcl-pi deleteIASRCINTPF;
      parmDltSrcDtls likeds(dltSrcDtls);
   end-pi;

   //Delete details from IASRCINTPF
   exec sql
      delete
      from iasrcintpf a
      where  a.iambrlib = :dltSrcDtls.memberLib
      and    a.iambrsrc = :dltSrcDtls.memberSrcPf
      and    a.iambrnam = :dltSrcDtls.memberName
      and    a.iambrtyp = :dltSrcDtls.memberType;

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Delete_IASRCINTPF';
      IaSqlDiagnostic(uDpsds);                                                           //0001
   endif;

end-proc;

//------------------------------------------------------------------------------------- //
// deleteIACPYBDTL : Delete the IACPYBDTL record.
//------------------------------------------------------------------------------------- //
dcl-proc deleteIACPYBDTL;

   dcl-pi deleteIACPYBDTL;
      parmDltSrcDtls likeds(dltSrcDtls);
   end-pi;

   //Delete details from IASRCINTPF
   exec sql
      delete
      from   iacpybdtl a
      where  a.iACpyLib   = :dltSrcDtls.memberLib                                        //0002
      and    a.iACpySrcPf = :dltSrcDtls.memberSrcPf                                      //0002
      and    a.iACpyMbr   = :dltSrcDtls.memberName;                                      //0002

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Delete_IACPYBDTL';
      IaSqlDiagnostic(uDpsds);                                                           //0001
   endif;

end-proc;
