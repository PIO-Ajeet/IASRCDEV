**free
      //%METADATA                                                      *
      // %TEXT Procedure-To-Procedure Mapping Tracking                 *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------- //
//Created By    : Programmers.io @ 2022                                                 //
//Creation Date : 14/04/2023                                                            //
//Developer     : Ankit Bansal                                                          //
//Description   : Build procedure to procedure reference                                //
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
//16/06/23| 0001   | Akshay     | Changed the sequence number to RRN number             //
//        |        |  Sopori   |in SQL query                                          //
//        |        |            |                                                      //
//01/08/23| 0002   | Naresh S   | Fixed fetching invalid entries from IAQRPGSRC for a   //
//        |        |           |specific procedure.                                   //
//        |        |            |                                                      //
//09/08/23| 0003   | Santosh    | Procedure to Procedure refrence not captured          //
//        |        | Kumar      |in file AIPROCREF in a particular case (Task #103)    //
//        |        |            |                                                      //
//10/08/23| 0003   | Santosh    | Procedure to Procedure refrence captured both         //
//        |        | Kumar      |with *Module and *pgm (Task #103)                     //
//        |        |            |                                                      //
//04/09/23| 0004   | Naresh S   | Handled Partial match invalid entries fetch from      //
//        |        |            | IAQRPGSRC file. (Task #183)                           //
//09/09/23| 0005   | Akshay     | Changed the AIPROCDTL file to IAPROCINFO file         //
//        |        |   Sopori   | [Task #208]                                           //
//15/12/23| 0006   | Akshay     | Refresh : AIPROCREF file not getting updated          //
//        |        |   Sopori   | correctly after refresh. #485                         //
//06/06/24| 0007   | Saumya     | Rename AIEXCTIMR to IAEXCTIMR [Task #262]             //
//02/07/24| 0008   | Akhil K.   | Rename AIPROCREF and AIPROCREFR to IAPROCREF and      //
//        |        |            | IAPROCREFR.                                           //
//05/07/24| 0009   | Akhil K.   | Renamed AIERRBND and iASqlDiagnostic with IA*         //
//18/06/24| 0010   | Manav      | Add SQL exception handling into AIPROCREFR program    //
//        |        |  Tripathi  | [Task# 212]                                           //
//04/06/24| 0011   | Vamsi      | Implemented the logic to capture Unused procedures    //
//        |        | Krishna2   | into IAGENAUDTP file,for both INIT & REFRESH          //
//        |        |            | Task# 1102                                            //
//01/22/25| 0012   | Bpal       | BLDMTADTA issue : issues with the query in IAPROCREFR //
//        |        |            | Task# 1124                                            //
//16/08/24| 0013   | Sabarish   | IFS Member Parsing Feature[Task #833]                 //
//------------------------------------------------------------------------------------- //
ctl-opt copyRight('Programmers.IO © 2023');
ctl-opt bndDir('IABNDDIR' : 'IAERRBND');                                                 //0009

ctl-opt alwNull(*UsrCtl)
        option(*NoDebugIO:*SrcStmt)
        dftActGrp(*No);
//------------------------------------------------------------------------------------- //0010
//Copybook Definitions                                                                  //0010
//------------------------------------------------------------------------------------- //0010
/copy 'QMODSRC/iasrv01pr.rpgleinc'
/copy 'QCPYSRC/iaderrlog.rpgleinc'
                                                                                         //0010

//------------------------------------------------------------------------------------- //
//Entry Parameter
//------------------------------------------------------------------------------------- //
dcl-pr MainPgm ExtPgm('IAPROCREFR')                                                      //0008
end-pr;

dcl-pi MainPgm;
end-pi;

//------------------------------------------------------------------------------------- //
//Prototype Declaration
//------------------------------------------------------------------------------------- //
dcl-pr IaExcTimR ExtPgm('IAEXCTIMR');                                                    //0007
   *n Char(10) Const;
   *n Char(10) Const;
   *n Char(10) Const;
   *n Char(10) Const;
   *n Char(10) Const;
   *n Char(10) Const;
   *n Char(10) Const;
   *n Char(100) Const;                                                                   //0013
   *n Char(10) Const;
   *n Timestamp Const;
   *n Char(6) Const;
end-pr;

//------------------------------------------------------------------------------------- //
//Data Structure Declaration
//------------------------------------------------------------------------------------- //
dcl-ds sourceDetail Qualified;
   sourceLibrary Char(10);
   sourceFile Char(10);
   sourceName Char(10);
end-ds;

dcl-dS objectDetail Qualified;
   objectLibrary Char(10);
   objectName Char(10);
   objectType Char(10);
   objectAttribute Char(10);
end-ds;

dcl-ds procedureSource LikeDS(SourceDetail);

dcl-ds ProcedureObject LikeDS(ObjectDetail);

dcl-ds iaMetaInfo dtaara len(62);                                                        //0006
   runMode char(7) pos(1);                                                               //0006
end-ds;                                                                                  //0006

//------------------------------------------------------------------------------------- //
//Standalone Variable Declaration
//------------------------------------------------------------------------------------- //
dcl-s w_ProcedureName  VarChar(81);
dcl-s w_Stmt           VarChar(2500);
dcl-s w_Present        Ind;
Dcl-S w_ModuleExist    Ind;                                                              //0003
Dcl-S w_SourceMember   Char(10);                                                         //0003
Dcl-S w_StrPos         packed(3) Inz ;                                                   //0004
Dcl-S w_EndPos         packed(3) Inz ;                                                   //0004
Dcl-S w_RefferingSourceDataUpper   Char(2000) inz ;                                      //0004
Dcl-S w_PrefixChar     char(1) ;                                                         //0004
Dcl-S w_SuffixChar     char(1) ;                                                         //0004
Dcl-S w_sqlText        varchar(5000) inz;                                                //0006
//------------------------------------------------------------------------------------- //
//Constant Declaration
//------------------------------------------------------------------------------------- //
dcl-c w_up      'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
dcl-c w_lo      'abcdefghijklmnopqrstuvwxyz';
dcl-c allow_Prefix  '(= ' ;                                                              //0004
dcl-c allow_Suffix  '(; ' ;                                                              //0004

//------------------------------------------------------------------------------------- //
//Main Logic
//------------------------------------------------------------------------------------- //
exec sql set option commit = *NONE, cloSqlCsr = *ENDMOD;

eval-corr udPsds = wkudPsds;                                                             //0010
iAExcTimR('BLDMTADTA':udpsds.procnme : udpsds.lib : '*PGM' : ' ':                        //0010
          // 0013 ' ':' ':' ': %TimeStamp():'INSERT');
          ' ':' ':' ': ' ' : %TimeStamp():'INSERT');                                     //0013

//Create Temporary Table To Hold Related Object Details
exec sql create or replace table QTemp/RelatedObj
         ( ObjectLibrary           Char(10),
           ObjectName              Char(10),
           ObjectType              Char(10),
           RelatedObjectLibrary    Char(10),
           RelatedObjectName       Char(10),
           RelatedObjectType       Char(10),
           RelatedObjectDepthLevel Char(10));

declareEachProcedureCursor();                                                            //0006

exec sql Open EachProcedure;

if sqlCode = CSR_OPN_COD;                                                                //0010
   exec sql close EachProcedure;                                                         //0010
   exec sql open  EachProcedure;                                                         //0010
endif;                                                                                   //0010
                                                                                         //0010
if sqlCode < successCode;                                                                //0010
   uDpsds.wkQuery_Name = 'Open_CSR_IAEachProcedure';                                     //0010
   iASqlDiagnostic(uDpsds);                                                              //0010
endif;                                                                                   //0010
                                                                                         //0010
exec sql Fetch EachProcedure InTo :ProcedureSource,
                                  :ProcedureObject,
                                  :w_ProcedureName;

if sqlCode < successCode;                                                                //0010
   uDpsds.wkQuery_Name = 'Fetch1_ProcedureDtl';                                          //0010
   iASqlDiagnostic(uDpsds);                                                              //0010
endif;                                                                                   //0010
                                                                                         //0010
dow SqlCode = 0;

   //Load all the references from which this procedure is called
   LoadAllReferences(ProcedureSource
                    :ProcedureObject
                    :w_ProcedureName);

   Exec Sql Fetch EachProcedure InTo :ProcedureSource,
                                     :ProcedureObject,
                                     :w_ProcedureName;
                                                                                         //0010
   if sqlCode < successCode;                                                             //0010
      uDpsds.wkQuery_Name = 'Fetch2_ProcedureDtl';                                       //0010
      iASqlDiagnostic(uDpsds);                                                           //0010
   endif;                                                                                //0010
enddo;

exec sql Close EachProcedure;

exec sql Drop Table QTemp/RelatedObj;

//Write Unused Procedures into IAGENAUDTP                                               //0011
AuditUnusedProcedure();                                                                  //0011

iAExcTimR('BLDMTADTA':udpsds.procnme : udpsds.lib : '*PGM' : ' ':                        //0010
          // 0013 ' ':' ':' ': %TimeStamp():'UPDATE');
          ' ':' ':' ': ' ' : %TimeStamp():'UPDATE');                                     //0013

//Exit from the program
*Inlr = *On;
Return;

//------------------------------------------------------------------------------------- //
//Procedure LoadAllReferences: Load all the references of the passed procedure
//------------------------------------------------------------------------------------- //
dcl-proc LoadAllReferences;

  dcl-pi LoadAllReferences;
     ProcedureSource LikeDs(SourceDetail);
     ProcedureObject LikeDs(ObjectDetail);
     w_ProcedureName VarChar(81);
  end-pi;

  dcl-ds w_OldReferringSource LikeDs(SourceDetail);
  dcl-ds ReferringSource LikeDs(SourceDetail);
  dcl-ds ReferringObject LikeDs(ObjectDetail);
  dcl-s w_OldReferringProcedureName VarChar(81);
  dcl-s w_ReferringProcedureName VarChar(81);
  dcl-s w_ReferringSourceRRN Zoned(6);
  dcl-s w_ReferringSourceData VarChar(2000);

  //Find all the sources where current procedure is called, ignore the cases where it is just
  //declared or code is commented or invalid code
  exec sql Declare SourceReferringProcedure Cursor For
           Select Library_Name,
                  SourcePF_Name,
                  Member_Name,
                  Source_RRN,
                  Source_Data
           From IAQRpgSrc
           Where (Upper(Source_Data) Like '%' || Trim(:w_ProcedureName) || '%'           //0002
                 OR Upper(Source_Data) Like Trim(:w_ProcedureName) || '%')
             And Not (Trim(Upper(Source_Data)) Like 'DCL-PR%'
                 OR  Trim(Upper(Source_Data)) Like 'DCL-PI%'
                 OR  Trim(Upper(Source_Data)) Like 'DCL-PROC%'
                 OR  Trim(Upper(Source_Data)) Like 'END-PR%'
                 OR  Trim(Upper(Source_Data)) Like 'END-PI%'
                 OR  Trim(Upper(Source_Data)) Like 'END-PROC%'
                 OR  SubString(Trim(Source_Data), 1, 2) = '//'
                 OR  SubString(Source_Data,7,1)= '*'
                 OR  (SubString(Upper(Source_Data),6,1) ='D'
                      And SubString(Upper(Source_Data),24,2) ='PR')
                 OR  (SubString(Upper(Source_Data),6,1) ='D'
                      And SubString(Upper(Source_Data),24,2) ='PI')
                 OR  (SubString(Upper(Source_Data),6,1) ='D'                             //0002
                      And Upper(Source_Data) LIKE '%...%' )                              //0002
                 OR  (SubString(Upper(Source_Data),6,1) ='P'
                      And SubString(Upper(Source_Data),24,1) ='B')
                 OR  (SubString(Upper(Source_Data),6,1) ='P'
                      And SubString(Upper(Source_Data),24,1) ='E')
                 OR  (SubString(Upper(Source_Data),6,1) ='P'                             //0002
                      And Upper(Source_Data) LIKE '%...%' )                              //0002
        OR  Upper(Source_Data) like '%"' ||'%' || Trim(:w_ProcedureName) || '%' || '"%'  //0002
                     )
           Order By Library_Name, SourcePF_Name, Member_Name;

  exec sql Open SourceReferringProcedure;

  if sqlCode = CSR_OPN_COD;                                                              //0010
     exec sql close SourceReferringProcedure;                                            //0010
     exec sql open  SourceReferringProcedure;                                            //0010
  endif;                                                                                 //0010
                                                                                         //0010
  if sqlCode < successCode;                                                              //0010
     uDpsds.wkQuery_Name = 'Open_CSR_SourceReferringProcedure';                          //0010
     iASqlDiagnostic(uDpsds);                                                            //0010
  endif;                                                                                 //0010
                                                                                         //0010
  exec sql Fetch SourceReferringProcedure InTo :ReferringSource,
                                               :w_ReferringSourceRRN,
                                               :w_ReferringSourceData;

  if sqlCode < successCode;                                                              //0010
     uDpsds.wkQuery_Name = 'Fetch1_ReferringSource';                                     //0010
     iASqlDiagnostic(uDpsds);                                                            //0010
  endif;                                                                                 //0010
                                                                                         //0010
  dow SqlCode = 0;

     //Below Logic will skip the process for the statements those fetched due to
     //partial match with procedure name.
     //Ex. MyProc , Partial matches MyProc1,ItsMtProc..etc
     clear w_PrefixChar;
     clear w_SuffixChar;

     w_RefferingSourceDataUpper = %xlate(w_lo:w_up:w_ReferringSourceData);               //0004
     w_StrPos = %scan(%Trim(w_ProcedureName):w_RefferingSourceDataUpper:1) ;             //0004

     if w_StrPos > 0 ;                                                                   //0004

        //Check whether procedure is having any other character as a prefix
        w_EndPos = w_StrPos + %len(%trim(w_ProcedureName))  ;                            //0004
        if w_StrPos > 1 ;                                                                //0004
           w_PrefixChar = %subst(w_RefferingSourceDataUpper:w_StrPos - 1:1) ;            //0004
        endif ;                                                                          //0004

        //Check whether procedure is having any other character as a suffix
        w_SuffixChar = %subst(w_RefferingSourceDataUpper:w_EndPos :1)  ;                 //0004

        if (%check(allow_Prefix:w_PrefixChar) > 0                                        //0004
           or %check(allow_Suffix:w_SuffixChar) > 0 ) ;                                  //0004

            exec sql Fetch SourceReferringProcedure InTo :ReferringSource,               //0004
                                                         :w_ReferringSourceRRN,          //0004
                                                         :w_ReferringSourceData;         //0004
            if sqlCode < successCode;                                                    //0010
               uDpsds.wkQuery_Name = 'Fetch1_SourceReferringProcedure';                  //0010
               iASqlDiagnostic(uDpsds);                                                  //0010
            endif;                                                                       //0010
            Iter ;                                                                       //0004

        endif;                                                                           //0004

     endif;                                                                              //0004

     w_ReferringProcedureName = *Blanks;

     //For each source RRN where sub-procedure was called, find it's caller sub-procedure
     //if any sub-procedure is there above the call mark that as calling sub-proc,else main_Logic
     exec sql
       Select Procedure_Name InTo :w_ReferringProcedureName
         From IaProcInfo                                                                 //0005
        Where RRN_NUMBER = (Select Max(RRN_NUMBER)                                       //0001
                              From IaProcInfo                                            //0005
                             Where Member_Library = :ReferringSource.SourceLibrary
                               And Source_File = :ReferringSource.SourceFile
                               And Member_Name = :ReferringSource.SourceName
                               And RRN_NUMBER  < :w_ReferringSourceRRN                   //0001
                               And Procedure_Type <> 'PR')
          And Member_Library = :ReferringSource.SourceLibrary
          And Source_File = :ReferringSource.SourceFile
          And Member_Name = :ReferringSource.SourceName;

     if w_ReferringProcedureName = *Blanks;
        w_ReferringProcedureName = 'MAIN_LOGIC';
     endif;

     if w_OldReferringSource <> ReferringSource;
        w_OldReferringProcedureName = *Blanks;
     endif;

     if w_OldReferringProcedureName <> w_ReferringProcedureName;
        //Find referring source's object - there can be multiple objects for the source
        exec sql
          Declare ReferringObject Cursor For
           Select Distinct A.Object_Libr,
                           A.Object_Name,
                           A.Object_Type,
                           A.Object_Attr
             From IAObjMap A
            Where A.Member_Libr = :ReferringSource.SourceLibrary
              And A.Member_SrcF = :ReferringSource.SourceFile
              And A.Member_Name = :ReferringSource.SourceName
              And A.Object_Type <> '*SRVPGM'                                             //0003
            Order by A.Object_Type;                                                      //0003

        exec sql Open ReferringObject;
        if sqlCode = CSR_OPN_COD;                                                        //0010
           exec sql close ReferringObject;                                               //0010
           exec sql open  ReferringObject;                                               //0010
        endif;                                                                           //0010
                                                                                         //0010
        if sqlCode < successCode;                                                        //0010
           uDpsds.wkQuery_Name = 'Open_CSR_ReferringObject';                             //0010
           iASqlDiagnostic(uDpsds);                                                      //0010
        endif;                                                                           //0010
                                                                                         //0010

        exec sql Fetch ReferringObject InTo :ReferringObject;
        if sqlCode < successCode;                                                        //0010
           uDpsds.wkQuery_Name = 'Fetch1_ReferringObject';                               //0010
           iASqlDiagnostic(uDpsds);                                                      //0010
        endif;                                                                           //0010
                                                                                         //0010
        w_ModuleExist = *Off;                                                            //0003
        dow SqlCode = 0;

           if ReferringObject.ObjectType = '*MODULE'                                     //0003
              and w_ModuleExist = *Off;                                                  //0003
             w_ModuleExist = *On;                                                        //0003
           endif;                                                                        //0003
                                                                                         //0003
           if ReferringObject.ObjectType = '*PGM'                                        //0003
              and w_ModuleExist = *On;                                                   //0003
                                                                                         //0003
              exec sql Select ODSRCM InTo :w_SourceMember                                //0003
                         From Idspobjd                                                   //0003
                       Where ODLBNM = :ReferringObject.objectLibrary                     //0003
                         And ODOBNM = :ReferringObject.objectName                        //0003
                         And ODOBTP = :ReferringObject.objectType                        //0003
                         And ODOBAT = :ReferringObject.objectAttribute;                  //0003
                                                                                         //0003
              if w_SourceMember = *Blanks;                                               //0003
                 exec sql Fetch ReferringObject InTo :ReferringObject;                   //0003
                 if sqlCode < successCode;                                               //0010
                    uDpsds.wkQuery_Name = 'Fetch2_ReferringObject';                      //0010
                    iASqlDiagnostic(uDpsds);                                             //0010
                 endif;                                                                  //0010
                 Iter;                                                                   //0003
              endif;                                                                     //0003
           endif;                                                                        //0003
                                                                                         //0003
           //Check whether our main object and this referring objects both are linked in IAALLREFPF
           if ReferringObject = ProcedureObject
              or CheckRelatedObjects(ReferringObject:ProcedureObject);

              //Write record in IAPROCREF file                                          //0008
              WriteRecord(ProcedureSource:
                          ProcedureObject:
                          w_ProcedureName:
                          ReferringSource:
                          ReferringObject:
                          w_ReferringProcedureName);
           endif;

           exec sql Fetch ReferringObject InTo :ReferringObject;
           if sqlCode < successCode;                                                     //0010
              uDpsds.wkQuery_Name = 'Fetch2_ReferringObject';                            //0010
              iASqlDiagnostic(uDpsds);                                                   //0010
           endif;                                                                        //0010
        enddo;

        exec sql Close ReferringObject;

        w_OldReferringProcedureName = w_ReferringProcedureName;
        w_OldReferringSource = ReferringSource;

     endif;

     exec sql Fetch SourceReferringProcedure InTo :ReferringSource,
                                                  :w_ReferringSourceRRN,
                                                  :w_ReferringSourceData;
     if sqlCode < successCode;                                                           //0010
        uDpsds.wkQuery_Name = 'Fetch2_ReferringSource';                                  //0010
        iASqlDiagnostic(uDpsds);                                                         //0010
     endif;                                                                              //0010
                                                                                         //0010
  enddo;

  exec sql Close SourceReferringProcedure;

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure CheckRelatedObjects: Check whether there is any relationship between
//                               procedure object and referring object
//------------------------------------------------------------------------------------- //
dcl-proc CheckRelatedObjects;

  dcl-pi CheckRelatedObjects Ind;
     ReferringObject LikeDs(ObjectDetail);
     ReferredObject LikeDs(ObjectDetail);
  end-pi;

  dcl-s w_Index Packed(5);
  dcl-s w_DepthLevel Packed(2) Inz(2);

  w_Present = *Off;
  //Check whether this object is already processed to load related objects or not
  exec sql Select '1' InTo :w_Present
           From QTemp/RelatedObj
           Where ObjectLibrary = :ReferredObject.ObjectLibrary
             And ObjectName    = :ReferredObject.ObjectName
             And ObjectType    = :ReferredObject.ObjectType
           Limit 1;                                                                      //0003

  if w_Present;

     //If this object is already processed, then check whether they are related or not
     w_Present = *Off;
     exec sql Select '1' InTo :w_Present
              From QTemp/RelatedObj
              Where ObjectLibrary = :ReferredObject.ObjectLibrary
                And ObjectName    = :ReferredObject.ObjectName
                And ObjectType    = :ReferredObject.ObjectType
                And RelatedObjectLibrary = :ReferringObject.ObjectLibrary
                And RelatedObjectName    = :ReferringObject.ObjectName
                And RelatedObjectType    = :ReferringObject.ObjectType
              Limit 1;                                                                   //0003
                                                                                         //0003
     //Check next level relation between referred and referring objects
     if w_Present = *Off;                                                                //0003
        exsr CheckNextLevelRelation;                                                     //0003
     endif;                                                                              //0003
                                                                                         //0003
     Return w_Present;

  else;

     //Now, this object is not already loaded with related objects, load related objects first
     //and then check whether referring and referred objects are related or not
     //Load data in QTEMP/RELATEDOBJ file
     exec sql Insert Into Qtemp/RelatedObj
              Select Referenced_ObjLib,
                     Referenced_Obj,
                     Referenced_ObjTyp,
                     Library_Name,
                     Object_Name,
                     Object_Type,
                     1 As DepthLevel
              From IAALLREFPF
              Where Referenced_ObjLib = :ReferredObject.ObjectLibrary
                And Referenced_Obj    = :ReferredObject.ObjectName
                And Referenced_ObjTyp = :ReferredObject.ObjectType;

        if sqlCode < successCode;                                                        //0010
           uDpsds.wkQuery_Name = 'Insert1_RelatedObj';                                   //0010
           iASqlDiagnostic(uDpsds);                                                      //0010
        endif;                                                                           //0010

     //Load refereces upto provided depth level
     for w_Index = 2 To w_DepthLevel;
        if SqlCode = 0;
           //Load data in QTEMP/RELATEDOBJ file
           Exec Sql Insert Into Qtemp/RelatedObj
                    Select :ReferredObject.ObjectLibrary,
                           :ReferredObject.ObjectName   ,
                           :ReferredObject.ObjectType   ,
                           Library_Name,
                           Object_Name,
                           Object_Type,
                           :w_Index
                    From IAALLREFPF
                    Where (Referenced_ObjLib, Referenced_Obj, Referenced_ObjTyp) In
                            (Select RelatedObjectLibrary, RelatedObjectName,
                                    RelatedObjectType
                          From QTemp/RelatedObj
                          Where RelatedObjectDepthLevel = :w_Index - 1
                            And RelatedObjectType In ('*SRVPGM','*MODULE')
                            And ObjectLibrary = :ReferredObject.ObjectLibrary
                            And ObjectName = :ReferredObject.ObjectName
                            And ObjectType = :ReferredObject.ObjectType);
            if sqlCode < successCode;                                                    //0010
               uDpsds.wkQuery_Name = 'Insert2_RelatedObj';                               //0010
               iASqlDiagnostic(uDpsds);                                                  //0010
            endif;                                                                       //0010
        endif;

     endfor;

     //Now check whether referrring and referred objects are related or not
     w_Present = *Off;
     exec sql Select '1' InTo :w_Present
              From QTemp/RelatedObj
              Where ObjectLibrary = :ReferredObject.ObjectLibrary
                And ObjectName    = :ReferredObject.ObjectName
                And ObjectType    = :ReferredObject.ObjectType
              Limit 1;                                                                   //0003
     if w_Present = *Off;

        //Write a blank entry to inform that we already processed this
        //source and no need to load agn
        exec sql Insert Into QTemp/RelatedObj
                 Values(:ReferredObject.ObjectLibrary,
                        :ReferredObject.ObjectName   ,
                        :ReferredObject.ObjectType   ,
                        ' ',
                        ' ',
                        ' ',
                        1);
            if sqlCode < successCode;                                                    //0010
               uDpsds.wkQuery_Name = 'Insert3_RelatedObj';                               //0010
               iASqlDiagnostic(uDpsds);                                                  //0010
            endif;                                                                       //0010
        Return w_Present;

     else;

        w_Present = *Off;
        exec sql Select '1' InTo :w_Present
                 From QTemp/RelatedObj
                 Where ObjectLibrary = :ReferredObject.ObjectLibrary
                   And ObjectName    = :ReferredObject.ObjectName
                   And ObjectType    = :ReferredObject.ObjectType
                   And RelatedObjectLibrary = :ReferringObject.ObjectLibrary
                   And RelatedObjectName    = :ReferringObject.ObjectName
                   And RelatedObjectType    = :ReferringObject.ObjectType
                 Limit 1;                                                                //0003

        //Check next level relation between referred and referring objects
        if w_Present = *Off;                                                             //0003
           exsr CheckNextLevelRelation;                                                  //0003
        endif;                                                                           //0003
                                                                                         //0003
        return w_Present;
     endif;
  endif;

  return w_Present;
//------------------------------------------------------------------------------------- //
// Check Next Level Relation
//------------------------------------------------------------------------------------- //
  begsr CheckNextLevelRelation;                                                          //0003

    w_Present = *Off;                                                                    //0003
                                                                                         //0003
    exec sql Select '1' InTo :w_Present                                                  //0003
               From QTemp/RelatedObj                                                     //0003
             Where ObjectLibrary = :ReferringObject.ObjectLibrary                        //0003
               And ObjectName    = :ReferringObject.ObjectName                           //0003
               And ObjectType    = :ReferringObject.ObjectType                           //0003
             Limit 1;                                                                    //0003
                                                                                         //0003
    if w_Present = *Off;                                                                 //0003
       exec sql Insert Into Qtemp/RelatedObj                                             //0003
                Select Referenced_ObjLib,                                                //0003
                       Referenced_Obj,                                                   //0003
                       Referenced_ObjTyp,                                                //0003
                       Library_Name,                                                     //0003
                       Object_Name,                                                      //0003
                       Object_Type,                                                      //0003
                       1 As DepthLevel                                                   //0003
                From IAALLREFPF                                                          //0003
                Where Referenced_ObjLib = :ReferringObject.ObjectLibrary                 //0003
                  And Referenced_Obj    = :ReferringObject.ObjectName                    //0003
                  And Referenced_ObjTyp = :ReferringObject.ObjectType;                   //0003

          if sqlCode < successCode;                                                      //0010
             uDpsds.wkQuery_Name = 'Insert1_RelatedObj';                                 //0010
             iASqlDiagnostic(uDpsds);                                                    //0010
          endif;                                                                         //0010
       //Load refereces upto provided depth level
       For w_Index = 2 To w_DepthLevel;                                                  //0003

          if SqlCode = 0;                                                                //0003
             //Load data in QTEMP/RELATEDOBJ file
             exec sql Insert Into Qtemp/RelatedObj                                       //0003
                     Select :ReferringObject.ObjectLibrary,                              //0003
                            :ReferringObject.ObjectName,                                 //0003
                            :ReferringObject.ObjectType,                                 //0003
                            Library_Name,                                                //0003
                            Object_Name,                                                 //0003
                            Object_Type,                                                 //0003
                            :w_Index                                                     //0003
                     From IAALLREFPF                                                     //0003
                     Where (Referenced_ObjLib, Referenced_Obj, Referenced_ObjTyp) In     //0003
                             (Select RelatedObjectLibrary, RelatedObjectName,            //0003
                              RelatedObjectType From QTemp/RelatedObj                    //0003
                              Where RelatedObjectDepthLevel = :w_Index - 1               //0003
                                And RelatedObjectType In ('*SRVPGM','*MODULE')           //0003
                                And ObjectLibrary = :ReferringObject.ObjectLibrary       //0003
                                And ObjectName = :ReferringObject.ObjectName             //0003
                                And ObjectType = :ReferringObject.ObjectType);           //0003
             if sqlCode < successCode;                                                   //0010
                uDpsds.wkQuery_Name = 'Insert2_RelatedObj';                              //0010
                iASqlDiagnostic(uDpsds);                                                 //0010
             endif;                                                                      //0010
          endif;                                                                         //0003

       endfor;                                                                           //0003

    endif;                                                                               //0003
                                                                                         //0003
    w_Present = *Off;                                                                    //0003
                                                                                         //0003
    exec sql Select '1' InTo :w_Present                                                  //0003
             From QTemp/RelatedObj                                                       //0003
             Where ObjectLibrary = :ReferredObject.ObjectLibrary                         //0003
               And ObjectName    = :ReferredObject.ObjectName                            //0003
               And ObjectType    = :ReferredObject.ObjectType                            //0003
               And (RelatedObjectLibrary, RelatedObjectName, RelatedObjectType) In       //0003
                    (Select RelatedObjectLibrary, RelatedObjectName, RelatedObjectType   //0003
                     From QTemp/RelatedObj                                               //0003
                     Where ObjectLibrary = :ReferringObject.ObjectLibrary                //0003
                       And ObjectName    = :ReferringObject.ObjectName                   //0003
                       And ObjectType    = :ReferringObject.ObjectType)                  //0003
             Limit 1;                                                                    //0003
                                                                                         //0003
  endsr ;                                                                                //0003

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure WriteRecord: Write Record in IAPROCREF file
//------------------------------------------------------------------------------------- //
dcl-proc WriteRecord;

  dcl-pi *N;
     ProcedureSource LikeDs(SourceDetail);
     ProcedureObject LikeDs(ObjectDetail);
     w_ProcedureName VarChar(81);
     ReferringSource LikeDs(SourceDetail);
     ReferringObject LikeDs(ObjectDetail);
     w_ReferringProcedureName VarChar(81);
  end-pi;

  //Query to insert the record only when it does not exist already
  exec sql Insert InTo IaProcRef (Object_Name,                                           //0008
                                  Object_Library,
                                  Object_Type,
                                  Object_Attribute,
                                  Procedure_Name,
                                  Referenced_Object_Name,
                                  Referenced_Object_Library,
                                  Referenced_Object_Type,
                                  Referenced_Object_Attribute,
                                  Referenced_Procedure_Name,
                                  Created_By)
           Select * from (Values(:ReferringObject.ObjectName     ,
                                 :ReferringObject.ObjectLibrary  ,
                                 :ReferringObject.ObjectType     ,
                                 :ReferringObject.ObjectAttribute,
                                 :w_ReferringProcedureName       ,
                                 :ProcedureObject.ObjectName     ,
                                 :ProcedureObject.ObjectLibrary  ,
                                 :ProcedureObject.ObjectType     ,
                                 :ProcedureObject.ObjectAttribute,
                                 :w_ProcedureName                ,
                                 USER)) b
           Where Not Exists (Select *
                 From IaProcRef                                                          //0008
                 Where Object_Name                 = :ReferringObject.ObjectName
                   And Object_Library              = :ReferringObject.ObjectLibrary
                   And Object_Type                 = :ReferringObject.ObjectType
                   And Object_Attribute            = :ReferringObject.ObjectAttribute
                   And Procedure_Name              = :w_ReferringProcedureName
                   And Referenced_Object_Name      = :ProcedureObject.ObjectName
                   And Referenced_Object_Library   = :ProcedureObject.ObjectLibrary
                   And Referenced_Object_Type      = :ProcedureObject.ObjectType
                   And Referenced_Object_Attribute = :ProcedureObject.ObjectAttribute
                   And Referenced_Procedure_Name   = :w_ProcedureName);
          if sqlCode < successCode;                                                      //0010
             uDpsds.wkQuery_Name = 'Insert_AiProcRef';                                   //0010
             iASqlDiagnostic(uDpsds);                                                    //0010
             return ;                                                                    //0010
          endif;                                                                         //0010
  Return;
end-proc;

//------------------------------------------------------------------------------------- //0006
//Procedure   :  declareEachProcedureCursor                                             //0006
//Description :  Declare cursor for each subprocedure present in IAPROCINFO             //0006
//------------------------------------------------------------------------------------- //0006
dcl-proc declareEachProcedureCursor ;                                                    //0006

  in IaMetaInfo;                                                                         //0006

  if runMode  = 'REFRESH';                                                               //0006
     clearRefreshDataForIaprocref();                                                     //0006 0008

     w_sqlText = 'SELECT PD.Member_Library, '                               +            //0006
                 '       PD.Source_File, '                                  +            //0006
                 '       PD.Member_Name, '                                  +            //0006
                 '       OM.Object_Libr, '                                  +            //0006
                 '       OM.Object_Name, '                                  +            //0006
                 '       OM.Object_Type, '                                  +            //0006
                 '       OM.Object_Attr, '                                  +            //0006
                 '       PD.Procedure_Name '                                +            //0006
                 '    FROM IaProcInfo PD '                                  +            //0006
                 '         JOIN IaObjMap OM '                               +            //0006
                 '             ON  PD.Member_Library = OM.Member_Libr '     +            //0006
                 '             AND PD.Source_File = OM.Member_SrcF '        +            //0006
                 '             AND PD.Member_Name = OM.Member_Name '        +            //0006
                 '         JOIN iaRefobjf RF '                              +            //0006
                 '             ON (RF.object_name = OM.object_name '        +            //0006
                 '             AND RF.object_type = OM.object_type '        +            //0006
                 '             AND RF.object_library = OM.object_libr ) '   +            //0006
                 '             OR (RF.member_Name    = OM.Member_name '     +            //0006
                 '             AND RF.member_library = OM.Member_Libr '     +            //0006
                 '             AND RF.iasrcpf       =  OM.Member_SrcF ) '   +            //0006
                 '    WHERE Procedure_Type = ''PI'' '                       +            //0006
                 '          AND Procedure_Name <> '' '' '                   +            //0006
                 '          AND OM.Object_Type <> ''*SRVPGM'' ' ;                        //0006
  else;                                                                                  //0006
     w_sqlText = 'SELECT PD.Member_Library, '                               +            //0006
                 '       PD.Source_File, '                                  +            //0006
                 '       PD.Member_Name, '                                  +            //0006
                 '       OM.Object_Libr, '                                  +            //0006
                 '       OM.Object_Name, '                                  +            //0006
                 '       OM.Object_Type, '                                  +            //0006
                 '       OM.Object_Attr, '                                  +            //0006
                 '       PD.Procedure_Name '                                +            //0006
                 '    FROM IaProcInfo PD '                                  +            //0006
                 '         JOIN IaObjMap OM '                               +            //0006
                 '             ON  PD.Member_Library = OM.Member_Libr '     +            //0006
                 '             AND PD.Source_File = OM.Member_SrcF '        +            //0006
                 '             AND PD.Member_Name = OM.Member_Name '        +            //0006
                 '    WHERE Procedure_Type = ''PI'' '                       +            //0006
                 '          AND Procedure_Name <> '' '' '                   +            //0006
                 '          AND OM.Object_Type <> ''*SRVPGM'' ' ;                        //0006
  endif;                                                                                 //0006

  exec sql prepare stmt1 from :w_sqlText  ;                                              //0006
  exec sql declare eachProcedure cursor for Stmt1 ;                                      //0006
  if sqlCode < successCode;                                                              //0010
     uDpsds.wkQuery_Name = 'Declare_eachProcedure';                                      //0010
     iASqlDiagnostic(uDpsds);                                                            //0010
     return ;                                                                            //0010
  endif;                                                                                 //0010

end-proc;

//------------------------------------------------------------------------------------- //0006
//Procedure   :  clearRefreshDataForIaProcRef                                           //0006
//Description :  Delete records from IAPROCREF where status = 'M' in IAREFOBJF          //0006
//------------------------------------------------------------------------------------- //0006
//Clear refresh data where status in IAREFOBJF is 'M'                                   //0006
dcl-proc clearRefreshDataForIAprocref;                                                   //0006 0008

  exec sql                                                                               //0006
    delete from IaProcRef p where exists (                                               //0006 0008
      select 1                                                                           //0006
        from iARefObjf r                                                                 //0006
       where iastatus = 'M'                                                              //0006
         and ((p.object_library = r.object_library                                       //0006
         and p.object_type = r.object_type                                               //0006
         and p.object_name = r.object_name)                                              //0006
          or (exists (select 1                                                           //0006
                        from iAObjMap o                                                  //0006
                       where r.member_name = o.iambrnam                                  //0006
                         and r.member_library = o.iambrlib                               //0006
                         and r.source_physical_file = o.iambrsrcf))));                   //0006

  if sqlCode < successCode;                                                              //0006
     uDpsds.wkQuery_Name = 'Delete_IAPROCREF_M';                                         //0006
     IaSqlDiagnostic(uDpsds);                                                            //0009
     return ;                                                                            //0006
  endif;                                                                                 //0006

end-proc;                                                                                //0006

//===================================================================================== //0011
//AuditUnusedProcedure : To capture unused procedures into IAGENAUDTP table             //0011
//===================================================================================== //0011
dcl-proc AuditUnusedProcedure;                                                           //0011
                                                                                         //0011
  dcl-pi *n;                                                                             //0011
  end-pi;                                                                                //0011
                                                                                         //0011
  //In case of REFRESH, just delete all UnusedProc records & re-execute process         //0011
  If runMode  = 'REFRESH';                                                               //0011
     Exec Sql                                                                            //0011
        Delete From IaGenAudTp Where UniqueCode = 'UnUsedProc' ;                         //0011
                                                                                         //0011
     If sqlCode < successCode;                                                           //0011
        uDpsds.wkQuery_Name = 'Delete_IAGENAUDTP_UnusedProc';                            //0011
        IaSqlDiagnostic(uDpsds);                                                         //0011
     EndIf;                                                                              //0011
  EndIf;                                                                                 //0011
                                                                                         //0011
  //Insert the UnusedProc records into IAGENAUDTP                                       //0011
  Exec Sql Insert InTo IaGenAudTp (UniqueCode,                                           //0011
                                   iADesText ,                                           //0011
                                   iAObjLib  ,                                           //0011
                                   iAObjName ,                                           //0011
                                   iAObjTyp  ,                                           //0011
                                   iAObjAttr ,                                           //0011
                                   iAProcNm ,                                            //0011
                                   iAProcTyp,                                            //0011
                                   CrtUser,                                              //0011
                                   CrtPgm )                                              //0011
          (Select 'UnUsedProc',                                                          //0011
                  'No Procedure Call Found',                                             //0011
                   map.iAObjLib,                                                         //0011
                   map.iAObjNam,                                                         //0011
                   map.iAObjTyp,                                                         //0011
                   map.iAObjAtr,                                                         //0011
                   dtl.iAPrcNam,                                                         //0011
                   dtl.iAExpImp,                                                         //0011
                   USER,                                                                 //0011
                   'AIPROCREFR'                                                          //0011
             From  iAProcInfo dtl                                                        //0011
             Join  iAObjMap map                                                          //0011
               On  dtl.iAMbrLib = map.iAMbrLib                                           //0011
              And  dtl.iASrcFile = map.iAMbrSrcf                                         //0011
              And  dtl.iAMbrNam  = map.iAMbrNam                                          //0011
            Where  dtl.iAPrcTyp = 'PI'                                                   //0011
              And  map.iAObjTyp in ('*PGM','*MODULE')                                    //0011
              And  Not Exists ( Select * from iAProcRef ref                              //0012
                                 Where map.iaobjnam = ref.airobjnam                      //0011
                                   And map.iaobjlib = ref.airobjlib                      //0011
                                   And map.iaobjtyp = ref.airobjtyp                      //0011
                                   And dtl.iaprcnam = ref.airprcnam ));                  //0011
                                                                                         //0011
  if sqlCode < successCode;                                                              //0011
     uDpsds.wkQuery_Name = 'Insert_IAGENAUDTP_UnusedProc';                               //0011
     IaSqlDiagnostic(uDpsds);                                                            //0011
  endif;                                                                                 //0011
                                                                                         //0011
end-proc;                                                                                //0011
