**free
      //%METADATA                                                      *
      // %TEXT Write list of procedures & Related Modules(DSPMOD)      *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------- //
//Created By  :   Programmers.io @ 2021                                                 //
//Created Date:   2021/12/27                                                            //
//Developer   :   Rohini Alagarsamy                                                     //
//Description :   Write relations between Module to Module, Program to Module and       //
//                Service Program to Module into all reference final table.             //
//Procedure Log:                                                                        //
//------------------------------------------------------------------------------------- //
//Procedure Name           | Procedure Description                                      //
//-------------------------|----------------------------------------------------------- //
//FindBndPgm               | Extract Bound relations into an array for passed parms     //
//------------------------------------------------------------------------------------- //
//                                                                                      //
//Modification Log:                                                                     //
//------------------------------------------------------------------------------------- //
//Date    | Mod_ID | Developer  | Case and Description                                  //
//--------|--------|------------|------------------------------------------------------ //
//23/02/13| 0001   | Pratik A   | Fixed Error Handling and Array Index error            //
//23/06/23| 0002   | Vamsi      | IAMODINF table will get replaced with IAPROCDTLP and  //
//        |        | Krishna2   | so updating here as well                              //
//23/07/21| 0003   | Vamsi      | Existing cursors are updated to SQL block read        //
//        |        | Krishna2   | mechanism                                             //
//04/10/23| 0004   | BPAL       | Metadata refresh process changes (Task#299)           //
//        |        |            | IAOBJECT for refresh process                          //
//22/11/23| 0005   | Venkatesh  | Added logic to avoid duplicates on IAALLREFPF         //
//        |        |   Battula  |    during metadata refresh.  [Task#: 398]             //
//27/11/23| 0006   | Kunal P.   | Metadata refresh process changes (Task#402)           //
//27/11/23| 0007   | Mahima T   | Range subscript exception fix handled error logging   //
//        |        |            | at procedure level (Task: #605)                       //
//04/07/24| 0008   | Vamsi      | Rename Bnddir AIERRBND, copybooks AICERRLOG/AIDERRLOG //
//        |        |            | and procedures AISQLDIAGNOSTIC and AIPSSRERRORLOG     //
//        |        |            | with IA*  [Task#261]                                  //
//------------------------------------------------------------------------------------- //
ctl-opt CopyRight('Copyright @ Programmers.io © 2022');
ctl-opt Option(*NoDebugIO: *SrcStmt: *NoUnRef);
ctl-opt DftActGrp(*No);
ctl-opt bndDir('IAERRBND');                                                              //0008

//------------------------------------------------------------------------------------- //
//Prototypes declaration
//------------------------------------------------------------------------------------- //
dcl-pr FindBndPgm likeDs(BuffPgm) rtnparm;
   *n likeds(BuffDs) value;
   *n char(10) value;
   *n char(10) value;
end-pr;

//------------------------------------------------------------------------------------- //
//Data Structure declaration
//------------------------------------------------------------------------------------- //
dcl-ds ProcDs qualified dim(999);                                                        //0003
   PMod     char(10) inz;
   PModLib  char(10) inz;
   PModAttr char(10) inz;
   PModText char(50) inz;
   ProName  char(30) inz;
end-ds;

//Buffer Structure
dcl-dS BuffDs;
   Name    char(10);
   Library char(10);
   Type    char(10);
end-ds;

//Related Module
dcl-dS RModDs likeDs(BuffDs);

//Buffer Structure for procedure call
dcl-ds BuffPgm qualified;
   ParmDs likeDs(BuffDs) dim(2000);                                                      //0001
   Parm_ind int(10);
end-ds;

//Bound Programs for Modules
dcl-ds BndPgm qualified;
   BndPgmDS likeDs(BuffDs) dim(2000);                                                    //0001
   Max_indX int(10);
end-ds;

//Bound Programs for Related Module
dcl-ds RBndPgm qualified;
   RBndPgmDS likeDs(BuffDs) dim(2000);                                                   //0001
   Max_indI int(10);
end-ds;

//Bound Service Programs for Module
dcl-ds SBndPgm qualified;
   SBndPgmDS likeDs(BuffDs) dim(2000);                                                   //0001
   Max_indY int(10);
end-ds;

//Bound Service Programs for Related Module
dcl-ds SRBndPgm qualified;
   SRBndPgmDS likeDs(BuffDs) dim(2000);                                                  //0001
   Max_indJ int(10);
end-ds;

dcl-ds ModuleExportProcDs qualified dim(999);                                            //0003
   DsRMod    char(10)  inz;                                                              //0003
   DsRLib    char(10)  inz;                                                              //0003
end-ds;                                                                                  //0003

dcl-ds PgmDs qualified dim(999);                                                         //0003
   Name    char(10);                                                                     //0003
   Library char(10);                                                                     //0003
   Type    char(10);                                                                     //0003
end-ds;                                                                                  //0003

dcl-ds IaMetaInfo dtaara len(62);                                                        //0004
   up_mode char(7) pos(1);                                                               //0004
end-ds;                                                                                  //0004

//------------------------------------------------------------------------------------- //
//Standalone variables
//------------------------------------------------------------------------------------- //
dcl-s wkSqlText1 char(500) Inz ;                                                         //0004
dcl-s WRMod      char(10) inz;

dcl-s Arr_indX  int (5) inz;                                                             //0001
dcl-s Arr_indY  int (5) inz;                                                             //0001
dcl-s Arr_indI  int (5) inz;                                                             //0001
dcl-s Arr_indJ  int (5) inz;                                                             //0001
dcl-s Loop_indI int (5) inz;                                                             //0001
dcl-s Loop_indX int (5) inz;                                                             //0001

dcl-s noOfRows        uns(5);                                                            //0003
dcl-s noOfRows1       uns(5);                                                            //0003
dcl-s noOfRows2       uns(5);                                                            //0003
dcl-s noOfRows3       uns(5);                                                            //0003
dcl-s uwindx          uns(5);                                                            //0003
dcl-s uwindx1         uns(5);                                                            //0003
dcl-s uwindx2         uns(5);                                                            //0003
dcl-s uwindx3         uns(5);                                                            //0003
dcl-s RowsFetched     uns(5);                                                            //0003
dcl-s RowsFetched1    uns(5);                                                            //0003
dcl-s RowsFetched2    uns(5);                                                            //0003
dcl-s RowsFetched3    uns(5);                                                            //0003

dcl-s ImportProc_ProcName  char(30) inz;                                                 //0003
dcl-s ImportProc_ModLib    char(10) inz;                                                 //0003
dcl-s ImportProc_Mod       char(10) inz;                                                 //0003
dcl-s ImportProc_ModAttr   char(10) inz;                                                 //0003
dcl-s ImportProc_ModText   char(50) inz;                                                 //0003
dcl-s ExportProc_ModLib    char(10) inz;                                                 //0003
dcl-s ExportProc_Mod       char(10) inz;                                                 //0002
dcl-s Wk_CsrName           char(30) inz;                                                 //0002
                                                                                         //0003
dcl-s rowFound          ind        inz('0');                                             //0003
dcl-s Bound_Obj_Success ind        inz('0');                                             //0003

//------------------------------------------------------------------------------------- //
//Constant declaration
//------------------------------------------------------------------------------------- //
dcl-c TRUE            '1';                                                               //0003
dcl-c FALSE           '0';                                                               //0003

//------------------------------------------------------------------------------------- //
//CopyBook declaration
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
//Mainline Programming
//------------------------------------------------------------------------------------- //
eval-corr uDpsds = wkuDpsds;

//Retrieve value from Data Area                                                         //0004
in IaMetaInfo;                                                                           //0004
Clear wksqltext1 ;                                                                       //0004

//If Process is 'REFRESH'                                                               //0004
if up_mode = 'REFRESH';                                                                  //0004

   wksqltext1 =                                                                          //0004
     ' select t1.iAObjName, t1.iAObjLib, '                                  +            //0004
     '        t1.iAObjAttr, t1.iAObjText, t1.iAProcName '                   +
     '   from iAProcDtlp t1 join iarefobjf t2 '                             +            //0004
     '   on  t1.iaobjname = t2.IaObjName and '                              +            //0004
     '       t1.iaobjlib  = t2.IaObjlib  and '                              +            //0004
     '       t1.iaobjtype = t2.iaobjtype     '                              +            //0004
     ' where t1.iAProcType =''IMPORT'' and t1.iAObjType = ''*MODULE'' and ' +            //0004
     '       t2.status in (''M'', ''A'') and t2.iaObjName <> '' '' ';                    //0004

else;                                                                                    //0004

   //Cursor to select all import Modules
   wksqltext1 =                                                                          //0004
      ' select iAObjName, iAObjLib, iAObjAttr, iAObjText, iAProcName '+                  //0004
      '   from iAProcDtlp ' +                                                            //0004
      ' where iAProcType =''IMPORT'' and iAObjType = ''*MODULE'' ' ;                     //0004

endif;                                                                                   //0004

exec sql prepare stmt1 from :wksqltext1 ;
exec sql declare ModuleWithImportProc cursor for Stmt1 ;

exec sql open ModuleWithImportProc;
if sqlCode = CSR_OPN_COD;
   exec sql close ModuleWithImportProc;
   exec sql open  ModuleWithImportProc;
endif;

if sqlCode < successCode;
   uDpsds.wkQuery_Name = 'Open_Cursor_ModuleWithImportProc';
   IaSqlDiagnostic(uDpsds);                                                              //0008
endif;

if sqlCode = successCode;                                                                //0003

   //Get the number of elements                                                         //0003
   noOfRows = %elem(ProcDs);                                                             //0003
                                                                                         //0003
   Wk_CsrName = 'ModuleImportProc';                                                      //0003
   //Fetch records from ModuleDtl cursor                                                //0003
   rowFound = fetchModuleDtlCursor();                                                    //0003
                                                                                         //0003
   dow rowFound;                                                                         //0003
                                                                                         //0003
      for uwindx = 1 to RowsFetched;                                                     //0003
         ImportProc_ProcName = ProcDs(uwindx).ProName;                                   //0003
         ImportProc_ModLib   = ProcDs(uwindx).PModLib;                                   //0003
         ImportProc_Mod      = ProcDs(uwindx).PMod;                                      //0003
         ImportProc_ModAttr  = ProcDs(uwindx).PModAttr;                                  //0003
         ImportProc_ModText  = ProcDs(uwindx).PModText;                                  //0003
         exsr RelatedModule;                                                             //0003
      endfor;                                                                            //0003
                                                                                         //0003
      Wk_CsrName = 'ModuleImportProc';                                                   //0003
                                                                                         //0003
      //if fetched rows are less than the array elements then come out of the loop.     //0003
      if RowsFetched < noOfRows ;                                                        //0003
         leave ;                                                                         //0003
      endif ;                                                                            //0003
                                                                                         //0003
      //Fetch records from ModuleDtl cursor                                             //0003
      rowFound = fetchModuleDtlCursor();                                                 //0003
   enddo;                                                                                //0003

endif;                                                                                   //0003

exec sql close ModuleWithImportProc;
exsr InsertSPgmToMod;

*Inlr = *On;
/copy 'QCPYSRC/iacerrlog.rpgleinc'

//------------------------------------------------------------------------------------- //
//Related Module :- Extract related module and check relation between them.
//------------------------------------------------------------------------------------- //
begsr RelatedModule;

   //Cursor to select all export Modules
   exec sql
     declare ModuleWithExportProc cursor for
      select iAObjName, iAObjLib                                                         //0002
        from iAProcDtlp                                                                  //0002
       where iAProcType = 'EXPORT'                                                       //0003
         and iAProcName = :ImportProc_ProcName                                           //0003
         and iAObjLib = :ImportProc_ModLib                                               //0003
         and iAObjType = '*MODULE'                                                       //0003
    order by iAObjName, iAObjLib;                                                        //0002

   exec sql open ModuleWithExportProc;
   if sqlCode = CSR_OPN_COD;
     exec sql close ModuleWithExportProc;
     exec sql open  ModuleWithExportProc;
   endif;

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Open_Cursor_ModuleWithExportProc';
      IaSqlDiagnostic(uDpsds);                                                           //0008
   endif;

   if sqlCode = successCode;                                                             //0003

      //Get the number of elements                                                      //0003
      noOfRows1 = %elem(ModuleExportProcDs);                                             //0003
                                                                                         //0003
      Wk_CsrName = 'ModuleExportProc';                                                   //0003
      //Fetch records from ModuleDtl cursor                                             //0003
      rowFound = fetchModuleDtlCursor();                                                 //0003
                                                                                         //0003
      dow rowFound;                                                                      //0003
                                                                                         //0003
         for uwindx1 = 1 to RowsFetched1;                                                //0003
            ExportProc_ModLib = ModuleExportProcDs(uwindx1).DsRLib;                      //0003
            ExportProc_Mod    = ModuleExportProcDs(uwindx1).DsRMod;                      //0003

            if ImportProc_Mod <> ExportProc_Mod;                                         //0003
               //Extract bound programs list for a Module
               BndPgm = FindBndPgm(ProcDs(uwindx):'*MODULE':'*PGM');                     //0003
               Arr_indX = BndPgm.Max_indX;

               //Extract bound service programs list for a Module
               SBndPgm = FindBndPgm(ProcDs(uwindx):'*MODULE':'*SRVPGM');                 //0003
               Arr_IndY = SBndPgm.Max_IndY;

               //Extract bound programs list for the above Service programs
               Loop_IndI = 1;
               dow Loop_IndI <= Arr_IndY and
                  Loop_IndI <= %Elem(SBndPgm.SBndpgmDS);

                  BuffDS = SBndPgm.SBndpgmDS(Loop_IndI);
                  BuffPgm = FindBndPgm(BuffDs:'*SRVPGM':'*PGM');
                  Loop_IndX = 1;
                  dow Loop_IndX <= BuffPgm.Parm_Ind And
                     Loop_IndX <= %Elem(BndPgm.BndPgmDs) And                             //0001
                     Arr_IndX < %Elem(BndPgm.BndPgmDs);
                     Arr_IndX += 1;
                     BndPgm.BndPgmDs(Arr_IndX) = BuffPgm.ParmDs(Loop_IndX);
                     Loop_indX += 1;
                  enddo;
                  Loop_IndI += 1;

               enddo;

               BndPgm.Max_IndX = Arr_IndX;

               //Related Modules
               RModDs.Name = ExportProc_Mod;                                             //0003
               RModDs.Library = ExportProc_ModLib;                                       //0003
               RModDs.Type = '*MODULE';

               //Extract bound programs list for a Related Module
               RbndPgm = FindBndPgm(RModDs:'*MODULE':'*PGM');
               Arr_IndI = RBndPgm.Max_IndI;

               //Extract bound service programs list for a Related Module
               SRBndPgm = FindBndPgm(RModDs:'*MODULE':'*SRVPGM');
               Arr_IndJ = SRBndPgm.Max_IndJ;

               //Extract bound programs list for the above Service programs
               Loop_IndI = 1;
               dow Loop_IndI <= Arr_IndJ
                   and Loop_IndI <= %Elem(SRBndPgm.SRBndpgmds);

                  BuffDS = SRBndPgm.SRBndpgmds(Loop_IndI);
                  BuffPgm = FindBndPgm(BuffDs:'*SRVPGM':'*PGM');
                  Loop_IndX = 1;
                  dow Loop_IndX <= BuffPgm.Parm_Ind And
                      Loop_IndX <= %Elem(RBndpgm.RBndpgmDs) And                          //0001
                      Arr_IndI < %Elem(RBndpgm.RBndpgmDs);
                     Arr_IndI += 1;
                     RBndpgm.RBndpgmDs(Arr_IndI) = BuffPgm.ParmDs(Loop_IndX);
                     Loop_IndX += 1;
                  enddo;
                  Loop_IndI += 1;

               enddo;

               RBndPgm.Max_IndI = Arr_IndI;
               exsr CheckRelation;

            endif;

         endfor;                                                                         //0003
                                                                                         //0003
         Wk_CsrName = 'ModuleExportProc';                                                //0003
                                                                                         //0003
         //if fetched rows are less than the array elements then come out of the loop.  //0003
         if RowsFetched1 < noOfRows1 ;                                                   //0003
            leave ;                                                                      //0003
         endif ;                                                                         //0003
                                                                                         //0003
         //Fetch records from ModuleDtl cursor                                          //0003
         rowFound = fetchModuleDtlCursor();                                              //0003
      enddo;                                                                             //0003

   endif;                                                                                //0003

   exec Sql Close ModuleWithExportProc;

endsr;

//------------------------------------------------------------------------------------- //
//Subroutine CheckRelation: Compare bound service programs and compare bound programs
//------------------------------------------------------------------------------------- //
begsr CheckRelation;

   //Check relations between bound service programs
   Arr_IndY= 1;
   dow Arr_IndY <= Sbndpgm.Max_IndY and                                                  //0001
       Arr_IndY <= %Elem(SBndPgm.SBndpgmDS);                                             //0001

      for Arr_IndJ = 1 by 1 to SrBndpgm.Max_IndJ;
         if Arr_IndJ <= %elem(SRBndPgm.SRBndPgmDs) and                                   //0001
            SBndPgm.SBndPgmDs(Arr_indY) = SRBndPgm.SRBndPgmDs(Arr_indJ);                 //0001
            exsr InsertRef;
            leavesr;
         endif;
      endfor;

      Arr_IndY += 1;
   enddo;

   //Check relations between bound programs
   Arr_IndX= 1;
   dow Arr_IndX <= BndPgm.Max_IndX and                                                   //0001
       Arr_IndX > %Elem(BndPgm.BndpgmDS);                                                //0001

      for Arr_IndI =1 by 1 to RBndPgm.Max_IndI;
         if Arr_IndI <= %elem(RBndPgm.RBndPgmDs) and                                     //0001
            Bndpgm.BndpgmDs(Arr_IndX) = RBndPgm.RBndPgmDs(Arr_IndI);                     //0001
            exsr InsertRef;
            leavesr;
         endif;
      endfor;

      Arr_IndX += 1;
   enddo;

endsr;

//------------------------------------------------------------------------------------- //
//Subroutine InsertRef: Insert Mod to Mod data into IAALLREFPF Final reference file
//------------------------------------------------------------------------------------- //
begsr InsertRef;

   exec sql
     select Referenced_obj
       into :WrMod
       from IaALLRefPf
      where Library_Name      = :ImportProc_ModLib                                       //0003
        and Object_Name       = :ImportProc_Mod                                          //0003
        and Object_Type       = '*MODULE'
        and Referenced_Obj    = :ExportProc_Mod                                          //0003
        and Referenced_ObjTyp = '*MODULE'
        and Referenced_ObjLib = :ExportProc_ModLib;                                      //0003

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Select_1_IaALLRefPf';
      IaSqlDiagnostic(uDpsds);                                                           //0008
   endif;

   if sqlCode = NO_DATA_FOUND;
      exec sql
        insert into IaAllRefPf (Library_Name,
                                Object_Name,
                                Object_Type,
                                Object_Attr,
                                Object_Text,
                                Referenced_Obj,
                                Referenced_ObjTyp,
                                Referenced_ObjLib,
                                Referenced_ObjUsg,
                                Crt_Pgm_Name,
                                Crt_Usr_Name)
          values (trim(:ImportProc_ModLib),                                              //0003
                  trim(:ImportProc_Mod),                                                 //0003
                  '*MODULE',
                  trim(:ImportProc_ModAttr),                                             //0003
                  trim(:ImportProc_ModText),                                             //0003
                  trim(:ExportProc_Mod),                                                 //0003
                  '*MODULE',
                  trim(:ExportProc_ModLib),                                              //0003
                  'I',
                  trim(:uDpsds.SrcMbr),
                  trim(:uDpsds.User));

      if sqlCode < successCode;
         uDpsds.wkQuery_Name = 'Insert_2_IaALLRefPf';
         IaSqlDiagnostic(uDpsds);                                                        //0008
      endif;

   endif;

endsr;

//------------------------------------------------------------------------------------- //0005
//Subroutine DeleteExistingRefs: Deletes existing Pgm to Mod and Srvpgm to Mod records  //0005
//------------------------------------------------------------------------------------- //0005
begsr DeleteExistingRefs;                                                                //0005
                                                                                         //0005
   exec sql                                                                              //0005
      delete from iAAllRefPf                                                             //0005
       where Object_Type in ('*SRVPGM', '*PGM')                                          //0005
         and Referenced_ObjTyp = '*MODULE'                                               //0005
         and Crt_Pgm_Name = :UDPSDS.PROCNME                                              //0006
         and ( (Object_Name, Library_Name, Object_Type) in                               //0005
              (select iAObjname, iAObjLib, iAObjType from iARefObjF                      //0005
                  where iAStatus in ('A','M') )                                          //0005
            ) ;                                                                          //0005
                                                                                         //0005
   if sqlCode < successCode;                                                             //0005
      uDpsds.wkQuery_Name = 'Delete_1_IaALLRefPf';                                       //0005
      IaSqlDiagnostic(uDpsds);                                                   //0008  //0005
   endif;                                                                                //0005
                                                                                         //0005
endsr;                                                                                   //0005

//------------------------------------------------------------------------------------- //
//Subroutine InsertSPgmToMod: Insert Pgm to Mod and Srvpgm to Mod into Final
//                            reference file
//------------------------------------------------------------------------------------- //
begsr InsertSPgmToMod;                                                                   //0005
                                                                                         //0005
   //REFRESH Mode                                                                       //0005
   if up_mode = 'REFRESH';                                                               //0005
                                                                                         //0005
      exsr DeleteExistingRefs;                                                           //0005
                                                                                         //0005
      exec sql                                                                           //0005
        insert into IaAllRefPf (Library_Name,                                            //0005
                                Object_Name,                                             //0005
                                Object_Type,                                             //0005
                                Object_Attr,                                             //0005
                                Referenced_Obj,                                          //0005
                                Referenced_ObjTyp,                                       //0005
                                Referenced_ObjLib,                                       //0005
                                Referenced_ObjUsg,                                       //0005
                                Crt_Pgm_Name,                                            //0005
                                Crt_Usr_Name)                                            //0005
          select PgmLib, Pgm, PgmTyp, ModAttrib, Mod,                                    //0005
                 ModTyp, ModLib,'I', :uDpsds.SrcMbr, :uDpsds.User                        //0005
            from IaPgmInf                                                                //0005
           where PgmTyp In ('*SRVPGM','*PGM')                                            //0005
             and ModTyp  = '*MODULE'                                                     //0005
             and ModLib <> 'QTEMP'                                                       //0005
             and ( (PGM, PgmLib, PgmTyp) In                                              //0005
                     (select Object_Name, Object_Library, Object_Type                    //0005
                      from iARefObjF where iAStatus in ('A','M') )                       //0005
                 ) ;                                                                     //0005
                                                                                         //0005
      if sqlCode < successCode;                                                          //0005
         uDpsds.wkQuery_Name = 'Insert_4_IaALLRefPf';                                    //0005
         IaSqlDiagnostic(uDpsds);                                                //0008  //0005
      endif;                                                                             //0005

   else;                                                                                 //0005

      //INIT Mode                                                                       //0005
      exec sql
        insert into IaAllRefPf (Library_Name,
                                Object_Name,
                                Object_Type,
                                Object_Attr,
                                Referenced_Obj,
                                Referenced_ObjTyp,
                                Referenced_ObjLib,
                                Referenced_ObjUsg,
                                Crt_Pgm_Name,
                                Crt_Usr_Name)
          select PgmLib, Pgm, PgmTyp, ModAttrib, Mod,
                 ModTyp, ModLib,'I', :uDpsds.SrcMbr, :uDpsds.User
            from IaPgmInf
           where (PgmTyp = '*SRVPGM'
             and ModTyp  = '*MODULE')
              or (PgmTyp = '*PGM'
             and ModTyp  = '*MODULE'
             and ModLib <> 'QTEMP');

      if sqlCode < successCode;
         uDpsds.wkQuery_Name = 'Insert_3_IaALLRefPf';
         IaSqlDiagnostic(uDpsds);                                                        //0008
      endif;

   endif;                                                                                //0005

endsr;

//------------------------------------------------------------------------------------- //
//Subroutine FindBndPgm: Extract Bound relations into an array for passed parms
//------------------------------------------------------------------------------------- //
dcl-proc FindBndPgm;

   dcl-pi *n likeds(PassPgm) rtnparm;
      PassDs likeds(pgmDs)  value;
      Module_Type  char(10) value;
      Program_Type char(10) value;
   end-pi;

   dcl-ds PassPgm qualified;
      BndDs likeds(PgmDs) dim(2000);                                                     //0001
      Index int(10);
   end-ds;

   dcl-s Aindex int(10);

   //------------------------------------------------------------------------------------- //
   //CopyBook declaration
   //------------------------------------------------------------------------------------- //
/copy 'QCPYSRC/iaprderlog.rpgleinc'

   eval-corr w_uDpsds = wkuDpsds;                                                        //0007

   exec sql
     declare BoundObject cursor for
      select pgm, pgmlib, pgmtyp
        from IaPgmInf
       where Mod    = :PassDs.Name
         and ModLib = :PassDs.Library
         and ModTyp = :Module_Type
         and PgmTyp = :Program_Type;

   exec sql open BoundObject;
   if sqlCode = CURSOR_OPEN_CODE;                                                        //0007
      exec sql close BoundObject;
      exec sql open  BoundObject;
   endif;

   if sqlCode < SQL_successCode;                                                         //0007
      uDpsds.wkQuery_Name = 'Open_Cursor_BoundObject';
      IaSqlDiagnostic(w_uDpsds);                                               //0008    //0007
   endif;

   Aindex = 0;

   if sqlCode = SQL_successCode;                                                         //0007

      //Get the number of elements                                                      //0003
      noOfRows2 = %elem(PgmDs);                                                          //0003
                                                                                         //0003
      Wk_CsrName = 'Bound_Object';                                                       //0003
      //Fetch records from ModuleDtl cursor                                             //0003
      rowFound = fetchModuleDtlCursor();                                                 //0003
                                                                                         //0003
      //Checking for BoundObject.If BoundObject not found,                              //0003
      //then executing BoundObjWithoutLib                                               //0003
      Bound_Obj_Success = rowFound;                                                      //0003
                                                                                         //0003
      dow rowFound                                                                       //0003
          and AIndex <  %Elem(PassPgm.BndDs);                                            //0003

         for uwindx2 = 1 to RowsFetched2;                                                //0003
            Aindex   += 1;
            PassPgm.BndDs(AIndex) = PgmDs(uwindx2);                                      //0003
         endfor;                                                                         //0003
                                                                                         //0003
         Wk_CsrName = 'Bound_Object';                                                    //0003
                                                                                         //0003
         //if fetched rows are less than the array elements then come out of the loop.  //0003
         if RowsFetched2 < noOfRows2 ;                                                   //0003
            leave ;                                                                      //0003
         endif ;                                                                         //0003
                                                                                         //0003
         //Fetch records from ModuleDtl cursor                                          //0003
         rowFound = fetchModuleDtlCursor();                                              //0003
      enddo;                                                                             //0003

   endif;                                                                                //0003

   exec sql close BoundObject;                                                           //0003

   if Bound_Obj_Success = '0';                                                           //0003

      AIndex   = 0;
      exec sql
        declare BoundObjWithoutLib Cursor For
         select Pgm, PgmLib, PgmTyp
           from IaPgmInf
          where Mod    = :PassDs.Name
            and ModTyp = :Module_Type
            and PgmTyp = :Program_Type;

      exec sql open BoundObjWithoutLib;
      if sqlCode = CURSOR_OPEN_CODE;                                                     //0007
         exec sql close BoundObjWithoutLib;
         exec sql open  BoundObjWithoutLib;
      endif;

      if sqlCode < SQL_successCode;                                                      //0007
         uDpsds.wkQuery_Name = 'Open_Cursor_BoundObjWithoutLib';
         IaSqlDiagnostic(w_uDpsds);                                           //0008     //0007
      endif;

      if sqlCode = SQL_successCode;                                                      //0007
                                                                                         //0003
         //Get the number of elements                                                   //0003
         noOfRows3 = %elem(PgmDs);                                                       //0003
                                                                                         //0003
         Wk_CsrName = 'Bound_ObjectWithout_Lib';                                         //0003
         //Fetch records from ModuleDtl cursor                                          //0003
         rowFound = fetchModuleDtlCursor();                                              //0003
                                                                                         //0003
         dow rowFound                                                                    //0003
             and aIndex <  %Elem(PassPgm.BndDs);                                         //0003

            for uwindx3 = 1 to RowsFetched3 ;                                            //0003
               Aindex += 1;
               PassPgm.BndDs(AIndex) = PgmDs(uwindx3);                                   //0003
            endfor;                                                                      //0003
                                                                                         //0003
            Wk_CsrName = 'Bound_ObjectWithout_Lib';                                      //0003
                                                                                         //0003
            //if fetched rows are less than the array elements                          //0003
            //then come out of the loop.                                                //0003
            if RowsFetched3 < noOfRows3 ;                                                //0003
               leave ;                                                                   //0003
            endif ;                                                                      //0003
                                                                                         //0003
            //Fetch records from ModuleDtl cursor                                       //0003
            rowFound = fetchModuleDtlCursor();                                           //0003

         enddo;                                                                          //0003

      endif;                                                                             //0003
      exec sql close BoundObjWithoutLib;

   endif;

   Passpgm.Index = Aindex;

   return PassPgm;

/copy 'QCPYSRC/iaprcerlog.rpgleinc'
end-proc;

//------------------------------------------------------------------------------------////0003
//Procedure fetchModuleDtlCursor: fetch the module details in array                   ////0003
//------------------------------------------------------------------------------------////0003
dcl-proc fetchModuleDtlCursor;                                                           //0003
                                                                                         //0003
   dcl-pi fetchModuleDtlCursor ind end-pi ;                                              //0003
                                                                                         //0003
   dcl-s  rcdFound ind inz('0');                                                         //0003
   dcl-s  wkRowNum like(RowsFetched) ;                                                   //0003
                                                                                         //0003
   //------------------------------------------------------------------------------------- //
   //CopyBook declaration
   //------------------------------------------------------------------------------------- //
/copy 'QCPYSRC/iaprderlog.rpgleinc'

   eval-corr w_uDpsds = wkuDpsds;                                                        //0007

   select;                                                                               //0003
      when Wk_CsrName = 'ModuleImportProc';                                              //0003
                                                                                         //0003
         RowsFetched = *zeros;                                                           //0003
         clear ProcDs;                                                                   //0003
                                                                                         //0003
         exec sql                                                                        //0003
            fetch ModuleWithImportProc for :noOfRows rows into :ProcDs;                  //0003
         if sqlcode = SQL_successCode;                                                   //0007
            exec sql get diagnostics                                                     //0003
                :wkRowNum = ROW_COUNT;                                                   //0003
                 RowsFetched  = wkRowNum ;                                               //0003
         endif;                                                                          //0003
         if RowsFetched > 0;                                                             //0003
            rcdFound = TRUE;                                                             //0003
         elseif sqlcode < SQL_successCode;                                               //0007
            rcdFound = FALSE;                                                            //0003
         endif;                                                                          //0003
                                                                                         //0003
      when Wk_CsrName = 'ModuleExportProc';                                              //0003
                                                                                         //0003
         RowsFetched1 = *zeros;                                                          //0003
         clear ModuleExportProcDs;                                                       //0003
                                                                                         //0003
         exec sql                                                                        //0003
            fetch ModuleWithExportProc for :noOfRows1 rows into :ModuleExportProcDs;     //0003
         if sqlcode = SQL_successCode;                                                   //0007
            exec sql get diagnostics                                                     //0003
                :wkRowNum = ROW_COUNT;                                                   //0003
                 RowsFetched1 = wkRowNum ;                                               //0003
         endif;                                                                          //0003
         if RowsFetched1 > 0;                                                            //0003
            rcdFound = TRUE;                                                             //0003
         elseif sqlcode < SQL_successCode;                                               //0007
            rcdFound = FALSE;                                                            //0003
         endif;                                                                          //0003
                                                                                         //0003
      when Wk_CsrName = 'Bound_Object';                                                  //0003
                                                                                         //0003
         RowsFetched2 = *zeros;                                                          //0003
         clear PgmDs;                                                                    //0003
                                                                                         //0003
         exec sql                                                                        //0003
            fetch BoundObject for :noOfRows2 rows into :PgmDs;                           //0003
         if sqlcode = SQL_successCode;                                                   //0007
            exec sql get diagnostics                                                     //0003
                :wkRowNum = ROW_COUNT;                                                   //0003
                 RowsFetched2 = wkRowNum ;                                               //0003
         endif;                                                                          //0003
         if RowsFetched2 > 0;                                                            //0003
            rcdFound = TRUE;                                                             //0003
         elseif sqlcode < SQL_successCode;                                               //0007
            rcdFound = FALSE;                                                            //0003
         endif;                                                                          //0003
                                                                                         //0003
      when Wk_CsrName = 'Bound_ObjectWithout_Lib';                                       //0003
                                                                                         //0003
         RowsFetched3 = *zeros;                                                          //0003
         clear PgmDs;                                                                    //0003
                                                                                         //0003
         exec sql                                                                        //0003
            fetch BoundObjWithoutLib for :noOfRows3 rows into :PgmDs;                    //0003
         if sqlcode = SQL_successCode;                                                   //0007
            exec sql get diagnostics                                                     //0003
                :wkRowNum = ROW_COUNT;                                                   //0003
                 RowsFetched3 = wkRowNum ;                                               //0003
         endif;                                                                          //0003
         if RowsFetched3 > 0;                                                            //0003
            rcdFound = TRUE;                                                             //0003
         elseif sqlcode < SQL_successCode ;                                              //0007
            rcdFound = FALSE;                                                            //0003
         endif;                                                                          //0003
   endsl;                                                                                //0003

   return rcdFound;                                                                      //0003

/copy 'QCPYSRC/iaprcerlog.rpgleinc'
                                                                                         //0003
end-proc;                                                                                //0003
