**free
      //%METADATA                                                      *
      // %TEXT IA - App Area Maintenance Object Details Program        *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------- //
//Created By  : Programmers.io @ 2024                                                   //
//Created Date: 2024/08/30                                                              //
//Developer   : Programmers.io                                                          //
//Description : IA - Application Area Maintainence Program                              //
//                                                                                      //
//                                                                                      //
//                       Input Parameters:                                              //
//              inRepo           -  Repo Name                                           //
//             inAppAreaName    -  Application Area Name                               //
//             inOperationMode  -  Operation Mode                                      //
//              inUserId         -  Input User                                          //
//                                                                                      //
//                       Ouput Parameters:                                              //
//              outStatus        -  Output Status                                       //
//              outMessage       -  Output Message                                      //
//                                                                                      //
//------------------------------------------------------------------------------------- //
//Procedure Log:                                                                        //
//------------------------------------------------------------------------------------- //
//Procedure Name                | Procedure Description                                 //
//------------------------------|-------------------------------------------------------//
//GetAppAreaObjectDetails       | To get Application Area Object Details                //
//PrepareWhereSql               | To prepare the sql where conditions                   //
//PrepareFinalSql               | To prepare the final sql based on all conditions      //
//                              | processed                                             //
//InsertAppAObjL                | To Insert data into IAAPPAOBJL                        //
//FetchRecordCursorAppAreaRules | To fetch Application Area Rules                       //
//DeleteAppAObjL                | To delete the application area details from IAAPPAOBJL//
//GetCreatedUser                | To get the created user in case of Application Area   //
//                              | Modify/Update                                         //
//InsertTempDtl                 | To Insert data into temporary detail file             //
//DeleteTempDtl                 | To delete the objects from temporary details file     //
//ClearVariables                | To clear the variables                                //
//AddAndOperator                | To add AND operator into SQL expression               //
//EvalLikeExpression            | To evaluate the LIKE/NOT LIKE of SQL expression       //
//EvalArithmeticOperator        | To evaluate the Arithmetic Operator                   //
//------------------------------------------------------------------------------------- //
//Modification Log:                                                                     //
//------------------------------------------------------------------------------------- //
//Date-DMY| Mod_ID | Developer  | Case and Description                                  //
//--------|--------|------------|------------------------------------------------------ //
//30/12/24|  0001  | S Karthick | QTEMP/TempAppDtl File strcuture in Changed as per the //
//        |        |            | iAAppAObjL and while insert the data Creation         //
//        |        |            | Timestamp changed to Current Timestamp not Object Date//
//        |        |            | -[TASK# 1097]                                         //
//08/01/25|  0002  | Sasikumar R| When days used count = 0 and days used condition is   //
//        |        |            | provided. Fix for [Task# 1083]                        //
//------------------------------------------------------------------------------------- //
Ctl-Opt CopyRight('Copyright @ Programmers.io © 2024');
Ctl-Opt Option(*NoDebugIo:*SrcStmt:*NoUnRef);
Ctl-Opt BndDir('IABNDDIR' : 'IAERRBND');
Ctl-Opt ActGrp(*Caller);

//------------------------------------------------------------------------------------- //
//Standalone Variables                                                                  //
//------------------------------------------------------------------------------------- //
Dcl-S wkCrtUserId            Char(10)       Inz;
Dcl-S wkUpdUserId            Char(10)       Inz;
Dcl-S wkCreatedUser          Char(10)       Inz;
Dcl-S wkWildCharacter        Char(10)       Inz;
Dcl-S wkLikeExpression       Char(10)       Inz;
Dcl-S wkArithmeticOperator   Char(2)        Inz;
Dcl-S wkTempNameType         Char(10)       Inz;
Dcl-S wkObjName              Char(10)       Inz;
Dcl-S wkObjType              Char(8)        Inz;
Dcl-S wkRuletype             Char(1)        Inz;
Dcl-S wkLibName              Char(10)       Inz;
Dcl-S wkObjNameCon           Char(2)        Inz;
Dcl-S wkObjTypeCon           Char(2)        Inz;
Dcl-S wkLibNameCon           Char(2)        Inz;
Dcl-S wkCrtDateCon           Char(2)        Inz;
Dcl-S wkUseDateCon           Char(2)        Inz;
Dcl-S wkChgDateCon           Char(2)        Inz;
Dcl-S wkDaysUseCon           Char(2)        Inz;
Dcl-S wkIncRefFile           Char(1)        Inz('N');
Dcl-S wkIncReferringPgm      Char(1)        Inz('N');
Dcl-S wkIncReferredPgm       Char(1)        Inz('N');
Dcl-S wkFirstCond            Char(1)        Inz('Y');
Dcl-S wkInsertSql            Char(300)      Inz;
Dcl-S wkConvertedObjDt       Char(200)      Inz;
Dcl-S wkConvertedCrtDt       Char(100)      Inz;
Dcl-S wkConvertedUseDt       Char(100)      Inz;
Dcl-S wkConvertedChgDt       Char(100)      Inz;

Dcl-S wkObjectSql            Varchar(2000)  Inz;
Dcl-S wkRefFileSqlLF         Varchar(2000)  Inz;
Dcl-S wkRefFileSqlOthers     Varchar(2000)  Inz;
Dcl-S wkReferringSql         Varchar(2000)  Inz;
Dcl-S wkReferredSql          Varchar(2000)  Inz;
Dcl-S wkWhereSql             Varchar(2000)  Inz;
Dcl-S wkDeleteSql            Varchar(2000)  Inz;

Dcl-S AppARulesIdx           Packed(3:0)    Inz;
Dcl-S wkDepRulesIdx          Packed(3:0)    Inz;
Dcl-S wkCrtDate              Packed(8:0)    Inz;
Dcl-S wkUseDate              Packed(8:0)    Inz;
Dcl-S wkChgDate              Packed(8:0)    Inz;
Dcl-S wkDaysUsed             Packed(5:0)    Inz;

Dcl-S RowsFetched            Uns(5)         Inz;
Dcl-S noOfRows               Uns(5)         Inz;

Dcl-S rcdFound               Ind            Inz('0');
Dcl-S rowFound               Ind            Inz('0');

//------------------------------------------------------------------------------------- //
//Constant Variables                                                                    //
//------------------------------------------------------------------------------------- //
Dcl-C True            '1';
Dcl-C False           '0';
Dcl-C Squote          '''';
Dcl-C Space           ' ';

//------------------------------------------------------------------------------------- //
//Datastructure Definitions                                                             //
//------------------------------------------------------------------------------------- //
//Datastructure array for Application Area Rules
Dcl-Ds udAppARules Qualified Dim(100);
   usRulSeqNo  Packed(3);
   usRuleType  Char(1);
   usObjName   Char(10);
   usObNmCon   Char(2);
   usObjType   Char(8);
   usObTpCon   Char(2);
   usLibName   Char(10);
   usLbNmCon   Char(2);
   usCrtDate   Packed(8);
   usCrDtCon   Char(2);
   usUseDate   Packed(8);
   usUDatCon   Char(2);
   usChgDate   Packed(8);
   usCgDtCon   Char(2);
   usDuCnt     Packed(5);
   usDUCtCon   Char(2);
   usRfdPgm    Char(1);
   usRfrPgm    Char(1);
   usRefFil    Char(1);
End-Ds;

//------------------------------------------------------------------------------------- //
//Copybook definitions                                                                  //
//------------------------------------------------------------------------------------- //
/copy 'QCPYSRC/iaderrlog.rpgleinc'

//------------------------------------------------------------------------------------- //
//Entry Parameter Declarations
//------------------------------------------------------------------------------------- //
Dcl-Pr iaAppAMntR ExtPgm('IAAPPAMNTR');
   inRepo            Char(10);
   inAppAName        Char(20);
   inOperMode        Char(3);
   inUserId          Char(10);
   outStatus         Char(1);
   outMessage        Char(80);
End-Pr;

Dcl-Pi iaAppAMntR;
   inRepo            Char(10);
   inAppAName        Char(20);
   inOperMode        Char(3);
   inUserId          Char(10);
   outStatus         Char(1);
   outMessage        Char(80);
End-Pi;

//------------------------------------------------------------------------------------- //
//Set options                                                                           //
//------------------------------------------------------------------------------------- //
Exec Sql
   Set Option Commit    = *None,
              Naming    = *Sys,
              UsrPrf    = *User,
              DynUsrPrf = *User,
              CloSqlCsr = *Endmod;

//------------------------------------------------------------------------------------- //
//Mainline Programming                                                                  //
//------------------------------------------------------------------------------------- //
Eval-corr uDpsds = wkuDpsds;

//Creating Insert SQL
wkInsertSql = 'Insert Into Qtemp/TempAppDtl(IAREPONAM, IAAPPANAM, IAOBJLIB, ' +
              'IAOBJNAM, IAOBJTYP, IAOBJATR, IAOBJTXT, IACRTUSR, IAUPDUSR, ' +           //0001
              'IACRTDTTM) (';                                                            //0001

//Initializng the out message, for unsuccessful cases
outMessage  = 'Unsuccessful operation of Application Area Objects.Please Try Later.';

//------------------------------------------------------------------------------------- //
//Cursor Declarations                                                                   //
//------------------------------------------------------------------------------------- //
//Fetch the Application Area Rules from iAAppRuleP
Exec Sql
   Declare CursorAppAreaRules Cursor For
          Select iarulseqno,
                 iaruletype,
                 iaobjnam,
                 iaobnmcon,
                 iaobjtyp,
                 iaobtpcon,
                 ialibnam,
                 ialbnmcon,
                 iacrtdat,
                 iacrdtcon,
                 iausedat,
                 iaudatcon,
                 iAChgDat,
                 iACgDtCon,
                 iADuCnt,
                 iADuCtCon,
                 iarfdpgm,
                 iarfrpgm,
                 iareffil
            From iAAppRuleP
           Where iareponam = :inRepo
             And iaappanam = :inAppAName
            With Ur;

//------------------------------------------------------------------------------------- //
//Main Processing                                                                       //
//------------------------------------------------------------------------------------- //

//Perform the steps based on operation mode (Addition/Deletion/Modify)
Select;
   When inOperMode = 'ADD';
      GetAppAreaObjectDetails();
      If outStatus   = 'E';
         outMessage  = %ScanRpl('operation' : 'Creation' : outMessage);
      EndIf;

   When inOperMode = 'DEL';
      DeleteAppAObjL();
      If outStatus   = 'E';
         outMessage  = %ScanRpl('operation' : 'Deletion' : outMessage);
      EndIf;

   When inOperMode = 'MOD';
      GetCreatedUser();
      DeleteAppAObjL();
      If outStatus   = 'E';
         outMessage  = %ScanRpl('operation' : 'Modification' : outMessage);
         Return;
      EndIf;

      GetAppAreaObjectDetails();
      If outStatus   = 'E';
         outMessage  = %ScanRpl('operation' : 'Modification' : outMessage);
      EndIf;

   Other;
EndSl;

//Populating the out message, in case of successful
If outStatus  <> 'E';
   outStatus   = 'S';
   outMessage  = 'Successfully generated Application Area Objects';
EndIf;

*Inlr = *On;
Return;

/copy 'QCPYSRC/iacerrlog.rpgleinc'

//------------------------------------------------------------------------------------- //
//Procedure GetAppAreaObjectDetails : To get Application Area Object Details            //
//------------------------------------------------------------------------------------- //
Dcl-Proc GetAppAreaObjectDetails;
   Dcl-Pi *n;
   End-Pi;

   //Open cursor
   Exec Sql Open CursorAppAreaRules;
   If sqlCode = CSR_OPN_COD;
      Exec Sql Close CursorAppAreaRules;
      Exec Sql Open  CursorAppAreaRules;
   EndIf;

   If sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Open_CursorAppAreaRules';
      IaSqlDiagnostic(uDpsds);
   EndIf;

   //Get the number of elements
   noOfRows = %elem(udAppARules);

   //Fetch records from CursorAppAreaRules
   rowFound = FetchRecordCursorAppAreaRules();

   If rowFound;
      If inOperMode = 'MOD';
         wkCrtUserId = wkCreatedUser;
         wkUpdUserId = inUserId;
      Else;
         wkCrtUserId = inUserId;
         wkUpdUserId = inUserId;
      EndIf;
   EndIf;

   Dow rowFound;

      For AppARulesIdx = 1 To RowsFetched;

         //Prepare the sql where conditions based on the rule
         PrepareWhereSql();

         //If rule type is omit,then delete the records from temp table
         If wkRuleType = 'O';
            DeleteTempDtl();
         EndIf;

         //Prepare the final sql
         PrepareFinalSql();

         //Insert objects into temp file based on the rule
         InsertTempDtl();

         //Clear all the necessary variables
         ClearVariables();

      EndFor;

      //If fetched rows are less than the array elements then come out of the loop.
      If RowsFetched < noOfRows ;
         Leave ;
      EndIf ;

      //Fetch records from CursorAppAreaRules
      rowFound = FetchRecordCursorAppAreaRules();

   Enddo;

   //Close cursor
   Exec Sql Close CursorAppAreaRules;

   //Insert objects into IAAPPAOBJL file from temp detail file
   InsertAppAObjL();

   Return;

End-Proc;

//------------------------------------------------------------------------------------- //
//Procedure PrepareWhereSql : To prepare the sql where conditions                       //
//------------------------------------------------------------------------------------- //
Dcl-Proc PrepareWhereSql;

   Dcl-Pi PrepareWhereSql End-Pi ;

   wkObjName         = udAppARules(AppARulesIdx).usobjname;
   wkObjType         = udAppARules(AppARulesIdx).usObjType;
   wkLibName         = udAppARules(AppARulesIdx).usLibName;
   wkCrtDate         = udAppARules(AppARulesIdx).usCrtDate;
   wkUseDate         = udAppARules(AppARulesIdx).usUseDate;
   wkRuleType        = udAppARules(AppARulesIdx).usRuleType;
   wkObjNameCon      = udAppARules(AppARulesIdx).usObNmCon;
   wkObjTypeCon      = udAppARules(AppARulesIdx).usObTpCon;
   wkLibNameCon      = udAppARules(AppARulesIdx).usLbNmCon;
   wkCrtDateCon      = udAppARules(AppARulesIdx).usCrDtCon;
   wkUseDateCon      = udAppARules(AppARulesIdx).usUDatCon;
   wkIncReferredPgm  = udAppARules(AppARulesIdx).usRfdPgm;
   wkIncReferringPgm = udAppARules(AppARulesIdx).usRfrPgm;
   wkIncRefFile      = udAppARules(AppARulesIdx).usRefFil;
   wkChgDate         = udAppARules(AppARulesIdx).usChgDate;
   wkChgDateCon      = udAppARules(AppARulesIdx).usCgDtCon;
   wkDaysUsed        = udAppARules(AppARulesIdx).usDuCnt;
   wkDaysUseCon      = udAppARules(AppARulesIdx).usDUCtCon;

   //Reset the First Condition,at start of each rule
   wkFirstCond = 'Y';

   //If rule type is omit, then add NOT into SQL where clause
   If wkRuleType = 'O';
      wkWhereSql = %Trim(wkWhereSql) + Space + 'not';
   EndIf;

   wkWhereSql = %Trim(wkWhereSql) + Space + '(';

   //Process Object Name condition
   If wkObjName <> *Blanks;

      Select;
         When wkObjNameCon = 'SW';
              wkWhereSql = %Trim(wkWhereSql) + Space + '(' + 'iaobjnam LIKE' + Space +
                           Squote + %Trim(wkObjName) + '%' + Squote + ')' ;
         Other;
              wkArithmeticOperator = EvalArithmeticOperator(wkObjNameCon);
              wkWhereSql = %Trim(wkWhereSql) + Space +'(' + 'iaobjnam ' +
                           wkArithmeticOperator + Space + Squote + %Trim(wkObjName) + Squote + ')';
      EndSl;

      //Update  the First Condition to N, as first condition of rule is processed
      wkFirstCond = 'N';
   EndIf;


   //Process Object Type condition
   If wkObjType <> *Blanks and wkObjType <> '*ALL' ;

      AddAndOperator();

      wkArithmeticOperator = EvalArithmeticOperator(wkObjTypeCon);

      wkWhereSql = %Trim(wkWhereSql) + Space +'(' + 'iaobjtyp ' + wkArithmeticOperator +
                   Space + Squote + %Trim(wkObjType) + Squote + ')';

      //Update  the First Condition to N, as first condition of rule is processed
      If wkFirstCond = 'Y';
         wkFirstCond = 'N';
      EndIf;
   EndIf;


   //Process Library Name condition
   If wkLibName <> *Blanks;

      AddAndOperator();

      Select;
         When wkLibNameCon = 'SW';
              wkWhereSql = %Trim(wkWhereSql) + Space + '(' + 'ialibnam LIKE' + Space +
                           Squote + %Trim(wkLibName) + '%' + Squote + ')' ;
         Other;
              wkArithmeticOperator = EvalArithmeticOperator(wkLibNameCon);
              wkWhereSql = %Trim(wkWhereSql) + Space +'(' + 'ialibnam ' +
                           wkArithmeticOperator + Space + Squote + %Trim(wkLibName) + Squote + ')';
      EndSl;

      //Update the First Condition to N, as first condition of rule is processed
      If wkFirstCond = 'Y';
         wkFirstCond = 'N';
      EndIf;
   EndIf;


   //Process Create Date condition
   If wkCrtDate <> *Zeros;

      AddAndOperator();

      //Convert Create date of object
      wkConvertedObjDt = 'dec(varchar_format(TIMESTAMP_FORMAT(iaocdat,' +
                          Squote + 'MMDDRR' + Squote + '),' + Squote + 'YYYYMMDD' +
                          Squote + '))' ;

      //Convert Create date of the rule
      wkConvertedCrtDt = 'dec(' + %Char(wkCrtDate) + ')' ;

      wkArithmeticOperator = EvalArithmeticOperator(wkCrtDateCon);

      wkWhereSql = %Trim(wkWhereSql) + Space + '(' + %Trim(wkConvertedObjDt) +
                   wkArithmeticOperator + %Trim(wkConvertedCrtDt) + ')';

      //Update  the First Condition to N, as first condition of rule is processed
      If wkFirstCond = 'Y';
         wkFirstCond = 'N';
      EndIf;
   EndIf;


   //Process Use Date condition
   If wkUseDate <> *Zeros;

      AddAndOperator();

      //Convert Use date of object
      wkConvertedObjDt = 'dec(varchar_format(TIMESTAMP_FORMAT(iadudat,' +
                         Squote + 'MMDDRR' + Squote + '),' + Squote + 'YYYYMMDD' +
                         Squote + '))' ;

      //Convert Use date of the rule
      wkConvertedUseDt = 'dec(' + %Char(wkUseDate) + ')' ;

      wkArithmeticOperator = EvalArithmeticOperator(wkUseDateCon);

      wkWhereSql = %Trim(wkWhereSql) + Space + '(' + %Trim(wkConvertedObjDt) +
                   wkArithmeticOperator + %Trim(wkConvertedUseDt) + ')';

      //Update  the First Condition to N, as first condition of rule is processed
      If wkFirstCond = 'Y';
         wkFirstCond = 'N';
      EndIf;
   EndIf;

   //Process Change Date condition
   If wkChgDate <> *Zeros;

      AddAndOperator();

      //Convert Change date of object
      wkConvertedObjDt = 'dec(varchar_format(TIMESTAMP_FORMAT(iAChgDat,' +
                         Squote + 'MMDDRR' + Squote + '),' + Squote + 'YYYYMMDD' +
                         Squote + '))' ;

      //Convert Change date of the rule
      wkConvertedChgDt = 'dec(' + %Char(wkChgDate) + ')' ;

      wkArithmeticOperator = EvalArithmeticOperator(wkChgDateCon);

      wkWhereSql = %Trim(wkWhereSql) + Space + '(' + %Trim(wkConvertedObjDt) +
                   wkArithmeticOperator + %Trim(wkConvertedChgDt) + ')';

      //Update  the First Condition to N, as first condition of rule is processed
      If wkFirstCond = 'Y';
         wkFirstCond = 'N';
      EndIf;
   EndIf;

   //Process days used count condition
   If wkDaysUsed <> *Zeros or                                                            //0002
      (wkDaysUseCon <> *Blanks and wkDaysUsed = *Zeros);                                 //0002

      AddAndOperator();

      wkArithmeticOperator = EvalArithmeticOperator(wkDaysUseCon);

      If wkDaysUsed > *Zeros;                                                            //0002
         wkWhereSql = %Trim(wkWhereSql) + Space +'(' + 'iaDuCnt ' + wkArithmeticOperator +
                      %Trim(%Editc(wkDaysUsed:'Z')) + ')';
      Else;                                                                              //0002
         wkWhereSql = %Trim(wkWhereSql) + Space +'(' + 'iaDuCnt ' +                      //0002
                      wkArithmeticOperator + '0' + ')';                                  //0002
      Endif;                                                                             //0002

      //Update the First Condition to N, as first condition of rule is processed
      If wkFirstCond = 'Y';
         wkFirstCond = 'N';
      EndIf;
   EndIf;

   wkWhereSql = %Trim(wkWhereSql) + Space + ')';

   Return;

End-Proc;

//--------------------------------------------------------------------------------------//
//Procedure PrepareFinalSql : To prepare the final sql based on all conditions processed//
//--------------------------------------------------------------------------------------//
Dcl-Proc PrepareFinalSql;

   Dcl-Pi PrepareFinalSql End-Pi ;

   //Prepare SQL for objects
   wkObjectSql = 'Select ' + Squote + %trim(inRepo) + Squote + ',' +
                   Squote + %trim(inAppAName) + Squote + ',' +
                  'ialibnam, iaobjnam, iaobjtyp, iaobjatr, iatxtdes, ' +
                   Squote + %trim(wkCrtUserId) + Squote + ',' +
                   Squote + %trim(wkUpdUserId) + Squote + ',' +
               // ' iaocdat, iadudat , iachgdat, iaduCnt ' +                             //0001
                  ' Current_Timestamp ' +                                                //0001
                  'from iaobject where ' + %Trim(wkWhereSql) +
                  ' And not EXISTS (select *'+
                  '  from Qtemp/TempAppDtl where iaobjlib = ialibnam and' +
                  '  iaobjnam =  iaobjnam and iaobjnam =  IAOBJTYP  ))' ;


   //Prepare SQL for Referred Files
   If wkIncRefFile = 'Y';

      //Prepare SQL for referred files (LFs)
      wkRefFileSqlLF = 'Select ' + Squote + %trim(inRepo) + Squote + ',' +
                       Squote + %trim(inAppAName) + Squote + ',' +
                       'whreli , whrefi ,' + Squote + '*FILE' + Squote +
                       ',' + Squote + 'LF' + Squote + ',' + 'iatxtdes, ' +
                       Squote + %trim(wkCrtUserId) + Squote + ',' +
                       Squote + %trim(wkUpdUserId) + Squote + ',' +
                    // ' iaocdat, iadudat , iachgdat, iaducnt ' +                        //0001
                       ' Current_Timestamp ' +                                           //0001
                       'from iadspdbr, iaobject where ' +
                       'EXISTS (select * from iaobject where ' +
                       %Trim(wkWhereSql) + ' and ialibnam = whrli and ' +
                       'iaobjnam = whrfi ) ' +
                       'And whreli = ialibnam ' +
                       ' And iaobjnam = whrefi' +
                       ' And iaobjtyp = ' + Squote + '*FILE' + Squote + ' And ' +
                       Space + 'whrefi <> ' + Squote + ' ' + Squote + ' And ' +
                       'NOT EXISTS (Select * from ' +
                       'Qtemp/TempAppDtl Where iaobjtyp = ' + Squote + '*FILE' + Squote +
                       'And iaobjatr = ' + Squote + 'LF' + Squote +
                       ' And iaobjlib = whreli And iaobjnam = whrefi ))';

      //Prepare SQL for referred files (DSPF/PRTF etc)
      wkRefFileSqlOthers = 'Select ' + Squote + %trim(inRepo) + Squote + ',' +
                           Squote + %trim(inAppAName) + Squote + ',' +
                           'ref1.iaoobjlib, ref1.iaoobjnam, ref1.iaoobjtyp, ' +
                           'ref1.iaoobjatr, ref1.iaoobjtxt, '  +
                           Squote + %trim(wkCrtUserId) + Squote + ',' +
                           Squote + %trim(wkUpdUserId) + Squote + ',' +
                       //  ' iaocdat, iadudat, iachgdat, iaducnt ' +                     //0001
                           ' Current_Timestamp '                   +                     //0001
                           'from iaallrefpf ref1, iaobject where ' +
                           'EXISTS (select * from iaobject where ' +
                           %Trim(wkWhereSql) +
                           ' and trim(ref1.iarobjlib) = ialibnam and ' +
                           'trim(ref1.iarobjnam) = iaobjnam and ' +
                           'trim(ref1.iarobjtyp) = iaobjtyp )' +
                           ' And ref1.iaoobjtyp = ' + Squote + '*FILE' + Squote +
                           ' And ref1.iaoobjlib = ialibnam ' +
                           'And ref1.iaoobjnam = iaobjnam And ' +
                           'ref1.iarobjtyp = ' + Squote + '*FILE' + Squote + ' And ' +
                           'Not EXISTS (Select * from Qtemp/TempAppDtl where ' +
                           'ref1.iaoobjlib = iaobjlib and ref1.iaoobjnam = iaobjnam ' +
                           'And ref1.iaoobjtyp = iaobjtyp ))' ;
   EndIf;


   //Prepare SQL for Referred Programs
   If wkIncReferredPgm = 'Y';
      wkReferredSql = 'Select ' + Squote + %trim(inRepo) + Squote + ',' +
                      Squote + %trim(inAppAName) + Squote + ',' +
                      'ref2.iaoobjlib, ref2.iaoobjnam, ' +
                      'ref2.iaoobjtyp, ref2.iaoobjatr, ref2.iaoobjtxt, ' +
                      Squote + %trim(wkCrtUserId) + Squote + ',' +
                      Squote + %trim(wkUpdUserId) + Squote + ',' +
                    //' iaocdat, iadudat, iachgdat, iaducnt ' +                          //0001
                      ' Current_Timestamp ' +                                            //0001
                      'from iaallrefpf ref2 , iaobject where ' +
                      'EXISTS (select * from iaobject where ' + %Trim(wkWhereSql) +
                      ' And trim(ref2.iarobjlib) = ialibnam' +
                      ' And trim(ref2.iarobjnam) = iaobjnam' +
                      ' And trim(ref2.iarobjtyp) = iaobjtyp )' +
                      ' And ref2.iaoobjtyp in (' + Squote + '*PGM' +
                      Squote + ',' + Squote + '*FILE' +
                      Squote + ',' + Squote + '*BNDDIR' +
                      Squote + ',' + Squote + '*CMD' +
                      Squote + ',' + Squote + '*DTAARA' +
                      Squote + ',' + Squote + '*DTAQ' +
                      Squote + ',' + Squote + '*JRN' +
                      Squote + ',' + Squote + '*JRNRCV' +
                      Squote + ',' + Squote + '*MENU' +
                      Squote + ',' + Squote + '*MODULE' +
                      Squote + ',' + Squote + '*MSGF' +
                      Squote + ',' + Squote + '*OUTQ' +
                      Squote + ',' + Squote + '*PNLGRP' +
                      Squote + ',' + Squote + '*SRVPGM' + Squote + ')' +
                      ' And ref2.iaoobjlib = ialibnam' +
                      ' And ref2.iaoobjnam = iaobjnam And ref2.iaoobjtyp = iaobjtyp ' +
                      'And Not EXISTS (Select * from Qtemp/TempAppDtl where ' +
                      'trim(ref2.iaoobjlib)= iaobjlib  and ' +
                      'trim(ref2.iaoobjnam)= iaobjnam and ' +
                      'trim(ref2.iaoobjtyp)= iaobjtyp ))' ;
   EndIf;


   //Prepare SQL for Referring Programs
   If wkIncReferringPgm = 'Y';
      wkReferringSql = 'Select ' + Squote + %trim(inRepo) + Squote + ',' +
                       Squote + %trim(inAppAName) + Squote + ',' +
                       'ref3.iarobjlib, ref3.iarobjnam, ref3.iarobjtyp, ' +
                       'iaobjatr, iatxtdes, '  +
                       Squote + %trim(wkCrtUserId) + Squote + ',' +
                       Squote + %trim(wkUpdUserId) + Squote + ',' +
                    // ' iaocdat, iadudat, iachgdat, iaducnt ' +                         //0001
                       ' Current_Timestamp ' +                                           //0001
                       'from iaallrefpf ref3 , iaobject where ' +
                       'EXISTS (Select * from iaobject where ' +
                       ' trim(ref3.iaoobjlib) = ialibnam and ' +
                       ' trim(ref3.iaoobjnam) = iaobjnam and ' +
                       ' trim(ref3.iaoobjtyp) = iaobjtyp )' +
                       ' And ref3.iarobjtyp in (' + Squote + '*PGM' +
                       Squote + ',' + Squote + '*BNDDIR' +
                       Squote + ',' + Squote + '*CMD' +
                       Squote + ',' + Squote + '*MENU' +
                       Squote + ',' + Squote + '*MODULE' +
                       Squote + ',' + Squote + '*SRVPGM' + Squote + ')' +
                       ' And ref3.iarobjlib = ialibnam' +
                       ' And ref3.iarobjnam = iaobjnam And ref3.iarobjtyp = iaobjtyp ' +
                       'And Not EXISTS (Select * from Qtemp/TempAppDtl where ' +
                       'trim(ref3.iarobjlib) = iaobjlib and ' +
                       'trim(ref3.iarobjnam) = iaobjnam and ' +
                       'trim(ref3.iaoobjtyp) = iaobjtyp ))';
   EndIf;

   Return;

End-Proc;

//--------------------------------------------------------------------------------------//
//Procedure InsertAppAObjL : To Insert data into IAAPPAOBJL                             //
//--------------------------------------------------------------------------------------//
Dcl-Proc InsertAppAObjL;

   Dcl-Pi InsertAppAObjL End-Pi ;

   Exec Sql
         Insert into iAAppAObjL(IAREPONAM, IAAPPANAM, IAOBJLIB,
         IAOBJNAM, IAOBJTYP, IAOBJATR, IAOBJTXT, IACRTUSR, IAUPDUSR)
         (select distinct IAREPONAM, IAAPPANAM, IAOBJLIB, IAOBJNAM, IAOBJTYP,IAOBJATR,
          IAOBJTXT, IACRTUSR, IAUPDUSR from qtemp/TempAppDtl);

   If SqlCode < successCode;
      uDpsds.wkQuery_Name = 'Insert_IAAPPAOBJL' ;
      IaSqlDiagnostic(uDpsds);

      outStatus   = 'E';
   EndIf;

   Return;

End-Proc;

//--------------------------------------------------------------------------------------//
//Procedure InsertTempDtl : To Insert data into temporary detail file                   //
//--------------------------------------------------------------------------------------//
Dcl-Proc InsertTempDtl;

   Dcl-Pi InsertTempDtl End-Pi ;

   //Execute the Objects SQL
   wkObjectSql = %Trim(wkInsertSql) + %Trim(wkObjectSql);

   Exec Sql Execute Immediate :wkObjectSql;
   If SqlCode < successCode;
      uDpsds.wkQuery_Name = 'Insert_Objects_TempAppDtl' ;
      IaSqlDiagnostic(uDpsds);
   EndIf;

   //Execute the Referred files SQL
   If wkIncRefFile = 'Y';

      wkRefFileSqlLF = %Trim(wkInsertSql) + %Trim(wkRefFileSqlLF);

      Exec Sql Execute Immediate :wkRefFileSqlLF;
      If SqlCode < successCode;
         uDpsds.wkQuery_Name = 'Insert_RefF_LF_TempAppDtl' ;
         IaSqlDiagnostic(uDpsds);
      EndIf;

      wkRefFileSqlOthers = %Trim(wkInsertSql) + %Trim(wkRefFileSqlOthers);

      Exec Sql Execute Immediate :wkRefFileSqlOthers;
      If SqlCode < successCode;
         uDpsds.wkQuery_Name = 'Insert_RefF_Others_/TempAppDtl' ;
         IaSqlDiagnostic(uDpsds);
      EndIf;
   EndIf;

   //Execute the Referred Programs SQL
   If wkIncReferredPgm = 'Y';
      wkReferredSql = %Trim(wkInsertSql) + %Trim(wkReferredSql);

      Exec Sql Execute Immediate :wkReferredSql;
      If SqlCode < successCode;
         uDpsds.wkQuery_Name = 'Insert_Referred_TempAppDtl' ;
         IaSqlDiagnostic(uDpsds);
      EndIf;
   EndIf;

   //Execute the Referring Programs SQL
   If wkIncReferringPgm = 'Y';
      wkReferringSql = %Trim(wkInsertSql) + %Trim(wkReferringSql);

      Exec Sql Execute Immediate :wkReferringSql;
      If SqlCode < successCode;
         uDpsds.wkQuery_Name = 'Insert_Referring_TempAppDtl' ;
         IaSqlDiagnostic(uDpsds);
      EndIf;
   EndIf;

   Return;

End-Proc;
//------------------------------------------------------------------------------------- //
//Procedure FetchRecordCursorAppAreaRules : To fetch Application Area Rules             //
//------------------------------------------------------------------------------------- //
Dcl-Proc FetchRecordCursorAppAreaRules;

   Dcl-Pi FetchRecordCursorAppAreaRules Ind End-Pi ;

   Dcl-S  rcdFound Ind Inz('0');
   Dcl-S  wkRowNum Like(RowsFetched) ;

   RowsFetched = *zeros;
   Clear udAppARules;

   Exec Sql
      Fetch CursorAppAreaRules For :noOfRows Rows Into :udAppARules;

   If sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Fetch_CursorAppAreaRules';
      IaSqlDiagnostic(uDpsds);
   EndIf;

   If sqlcode = successCode;
      Exec Sql Get Diagnostics
         :wkRowNum = ROW_COUNT;
      RowsFetched  = wkRowNum ;
   EndIf;

   If RowsFetched > 0;
      rcdFound = TRUE;
   ElseIf sqlcode < successCode ;
      rcdFound = FALSE;
   EndIf;

   Return rcdFound;

End-Proc;

//------------------------------------------------------------------------------------- //
//Procedure DeleteAppAObjL : To delete the application area details from IAAPPAOBJL     //
//------------------------------------------------------------------------------------- //
Dcl-Proc DeleteAppAObjL;
   Dcl-Pi *n;
   End-Pi;

   Exec Sql
      Delete From iAAppAObjL
            Where iareponam = :inRepo
              And iaappanam = :inAppAName;

   If SqlCode < successCode;
      uDpsds.wkQuery_Name = 'Delete_IAAPPAOBJL' ;
      IaSqlDiagnostic(uDpsds);

      outStatus   = 'E';
   EndIf;

   Return;

End-Proc;

//------------------------------------------------------------------------------------- //
//Procedure DeleteTempDtl  : To delete the objects from temporary details file          //
//------------------------------------------------------------------------------------- //
Dcl-Proc DeleteTempDtl;
   Dcl-Pi *n;
   End-Pi;

   //Remove NOT from where condition in order to prepare delete SQL
   wkWhereSql  = %TrimL(wkWhereSql : 'not') ;

   //Delete the objects based on rule conditions
   Clear wkDeleteSql ;
   wkDeleteSql = 'Delete from qtemp/TempAppDtl Where ' + %Trim(wkWhereSql);

   Exec Sql Execute Immediate :wkDeleteSql;
   If SqlCode < successCode;
      uDpsds.wkQuery_Name = 'Delete1_Qtemp_TempAppDtl' ;
      IaSqlDiagnostic(uDpsds);
   EndIf;

   //If referred files is set then delete corresponding objects
   If wkIncRefFile = 'Y';
      Clear wkDeleteSql ;

      //Delete LFs referred as per IADSPDBR
      wkDeleteSql = 'Delete from qtemp/TempAppDtl T1 Where ' +
                    'EXISTS (Select * from iADspDbr Where ' +
                    'T1.iaobjlib = whreli and ' +
                    'T1.iaobjnam = whrefi and ' +
                    'EXISTS (Select * from iaobject where ' +
                    'whrli = ialibnam and ' +
                    'whrfi = iaobjnam and ' +
                    %Trim(wkWhereSql) + ' ))' + ' And ' +
                    'T1.iaobjtyp = ' + Squote + '*FILE' + Squote ;

      Exec Sql Execute Immediate :wkDeleteSql;
      If SqlCode < successCode;
         uDpsds.wkQuery_Name = 'Delete2_Qtemp_TempAppDtl' ;
         IaSqlDiagnostic(uDpsds);
      EndIf;

      Clear wkDeleteSql ;

      //Delete other files referred as per IAALLREFPF
      wkDeleteSql = 'Delete from qtemp/TempAppDtl T1 Where ' +
                    'EXISTS (Select * from iAAllRefPf Where ' +
                    'T1.iaobjlib = iaoobjlib and ' +
                    'T1.iaobjnam = iaoobjnam and ' +
                    'T1.iaobjtyp = iaoobjtyp and ' +
                    'EXISTS (Select * from iaobject where ' +
                    'iarobjlib = ialibnam and ' +
                    'iarobjnam = iaobjnam and ' +
                    'iarobjtyp = iaobjtyp and ' +
                    %Trim(wkWhereSql) + ' ))' + ' And ' +
                    'T1.iaobjtyp = ' + Squote + '*FILE' + Squote ;

      Exec Sql Execute Immediate :wkDeleteSql;
      If SqlCode < successCode;
         uDpsds.wkQuery_Name = 'Delete3_Qtemp_TempAppDtl' ;
         IaSqlDiagnostic(uDpsds);
      EndIf;
   EndIf;


   //If referred programs is set then delete corresponding objects
   If wkIncReferredPgm = 'Y';
      Clear wkDeleteSql ;

      wkDeleteSql = 'Delete from qtemp/TempAppDtl T1 Where ' +
                    'EXISTS (Select * from iAAllRefPf Where ' +
                    'T1.iaobjlib = iarobjlib and ' +
                    'T1.iaobjnam = iarobjnam and ' +
                    'T1.iaobjtyp = iarobjtyp and ' +
                    'EXISTS (Select * from iaobject where ' +
                    'iaoobjlib = ialibnam and ' +
                    'iaoobjnam = iaobjnam and ' +
                    'iaoobjtyp = iaobjtyp and ' +
                    %Trim(wkWhereSql) + ' ))' ;

      Exec Sql Execute Immediate :wkDeleteSql;
      If SqlCode < successCode;
         uDpsds.wkQuery_Name = 'Delete4_Qtemp_TempAppDtl' ;
         IaSqlDiagnostic(uDpsds);
      EndIf;
   EndIf;


   //If referring programs is set then delete corresponding objects
   If wkIncReferringPgm = 'Y';
      Clear wkDeleteSql ;

      wkDeleteSql = 'Delete from qtemp/TempAppDtl T1 Where ' +
                    'EXISTS (Select * from iAAllRefPf Where ' +
                    'T1.iaobjlib = iaoobjlib and ' +
                    'T1.iaobjnam = iaoobjnam and ' +
                    'T1.iaobjtyp = iaoobjtyp and ' +
                    'EXISTS (Select * from iaobject where ' +
                    'iarobjlib = ialibnam and ' +
                    'iarobjnam = iaobjnam and ' +
                    'iarobjtyp = iaobjtyp and ' +
                    %Trim(wkWhereSql) + ' ))' ;

      Exec Sql Execute Immediate :wkDeleteSql;
      If SqlCode < successCode;
         uDpsds.wkQuery_Name = 'Delete5_Qtemp_TempAppDtl' ;
         IaSqlDiagnostic(uDpsds);
      EndIf;

   EndIf;

   //Adding NOT back to where condition
   wkWhereSql  = 'not ' + %Trim(wkWhereSql) ;

   Return;

End-Proc;

//------------------------------------------------------------------------------------- //
//Procedure AddAndOperator : To add AND operator into SQL expression                    //
//------------------------------------------------------------------------------------- //
Dcl-Proc AddAndOperator;
   Dcl-Pi *n;
   End-Pi;

   //Add AND into SQL where clause, if this is not a first condition of rule
   If wkFirstCond = 'N';
      wkWhereSql = %Trim(wkWhereSql) + ' And ';
   EndIf;

   Return;

End-Proc;

//------------------------------------------------------------------------------------- //
//Procedure EvalLikeExpression : To evaluate the LIKE/NOT LIKE of SQL expression        //
//------------------------------------------------------------------------------------- //
Dcl-Proc EvalLikeExpression;

   Dcl-Pi EvalLikeExpression Char(10);
      inCondition Char(2);
   End-Pi;

   If inCondition = 'EQ'
      Or inCondition = 'SW';
      wkLikeExpression = 'LIKE';
   ElseIf inCondition = 'NE';
      wkLikeExpression = 'NOT LIKE';
   EndIf;

   Return wkLikeExpression;

End-Proc;

//------------------------------------------------------------------------------------- //
//Procedure EvalArithmeticOperator : To evaluate the Arithmetic Operator                //
//------------------------------------------------------------------------------------- //
Dcl-Proc EvalArithmeticOperator;

   Dcl-Pi EvalArithmeticOperator Char(2);
      inCondition   Char(2);
   End-Pi;

   Select;
     When inCondition = 'EQ';
        wkArithmeticOperator = '=' ;
     When inCondition = 'NE';
        wkArithmeticOperator = '<>' ;
     When inCondition = 'GT';
        wkArithmeticOperator = '>' ;
     When inCondition = 'LT';
        wkArithmeticOperator = '<' ;
     When inCondition = 'GE';
        wkArithmeticOperator = '>=' ;
     When inCondition = 'LE';
        wkArithmeticOperator = '<=' ;
   EndSl;

   Return wkArithmeticOperator;

End-Proc;

//------------------------------------------------------------------------------------- //
//Procedure GetCreatedUser : To get the created user in case of Application Area UPDATE //
//------------------------------------------------------------------------------------- //
Dcl-Proc GetCreatedUser;

   Dcl-Pi *n;
   End-Pi;

   Exec Sql
      Select iacrtusr Into :wkCreatedUser
        From iAAppAObjL
       Where iareponam = :inRepo
         And iaappanam = :inAppAName
       Limit 1;

   If SqlCode < successCode;
      uDpsds.wkQuery_Name = 'Select_CreatedUser_IAAPPAOBJL' ;
      IaSqlDiagnostic(uDpsds);
   EndIf;

   Return;

End-Proc;

//------------------------------------------------------------------------------------- //
//Procedure ClearVariables : To clear the variables                                     //
//------------------------------------------------------------------------------------- //
Dcl-Proc ClearVariables;

   Dcl-Pi *n;
   End-Pi;

   Clear wkDeleteSql;
   Clear wkWhereSql;
   Clear wkObjectSql;
   Clear wkRefFileSqlLF;
   Clear wkRefFileSqlOthers;
   Clear wkReferringSql;
   Clear wkReferredSql;

   Return;

End-Proc;

