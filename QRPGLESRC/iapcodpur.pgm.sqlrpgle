**free
      //%METADATA                                                      *
      // %TEXT IA Pseudocode purge IAPSEUDOCP file                     *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------- //
//Created By  :  Programmers.io @ 2024                                                  //
//Created Date:  2024/02/21                                                             //
//Developer   :  Programmers.io                                                         //
//Description :  Purge IAPSEUDOCP Pseudocode file                                       //
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
//04/07/24| 0001   | Vamsi      | Rename Bnddir AIERRBND, copybooks AICERRLOG/AIDERRLOG //
//        |        |            | and procedures AISQLDIAGNOSTIC and AIPSSRERRORLOG     //
//        |        |            | with IA*  [Task#261]                                  //
//        |        |            |                                                       //
//------------------------------------------------------------------------------------- //
Ctl-Opt Copyright('Programmers.io Â© 2024');
Ctl-Opt Option(*NoDebugIO : *SrcStmt : *noUnRef);
Ctl-Opt DftActGrp(*No) datfmt(*ISO);
Ctl-Opt BndDir('IAERRBND');                                                              //0001

//------------------------------------------------------------------------------------- //
//Variable Declaration
//------------------------------------------------------------------------------------- //
Dcl-S PurgeDays           Packed(6)    Inz;
Dcl-S PurgeDate           Char(26)     Inz('9999-12-12-23.59.59.999999');
Dcl-S wTodayDate          Date         Inz;
Dcl-S wLastPurgeDate      Date         Inz;
Dcl-S wLastPurgeDateChar  Char(10)     Inz;

//------------------------------------------------------------------------------------- //
//Constant Declaration
//------------------------------------------------------------------------------------- //
Dcl-C wKeyName1        'PSEUDO_CODE' ;
Dcl-C wKeyName2        'PURGE_DAYS' ;

//------------------------------------------------------------------------------------- //
//Copybook Declaration
//------------------------------------------------------------------------------------- //
/copy 'QCPYSRC/iaderrlog.rpgleinc'

//-------------------------------------------------------------------------------------
//Entry Parameter
//-------------------------------------------------------------------------------------
Dcl-Pi IAPCODPUR  ExtPgm('IAPCODPUR');
   xRef Char(10) Const;
End-Pi;

//------------------------------------------------------------------------------------ //
//Set options
//------------------------------------------------------------------------------------ //
Exec sql
  Set Option Commit    = *None,
             Naming    = *Sys,
             DynUsrPrf = *User,
             CloSqlCsr = *EndMod;

//------------------------------------------------------------------------------------- //
//Main logic
//------------------------------------------------------------------------------------- //
Eval-Corr uDpsds = wkuDpsds;

//Get days required to purge, last purge date
Exec Sql
   Select Trim(KEY_VALUE1), Trim(KEY_VALUE2) into :PurgeDays, :wLastPurgeDateChar
     From IABCKCNFG
    Where KEY_NAME1  = :wKeyName1  And
          KEY_NAME2  = :wKeyName2;

If SqlCod = SuccessCode;

   //Date Conversion
    Monitor;
      wLastPurgeDate  = %Date(wLastPurgeDateChar);
      wTodayDate      = %Date();
    On-Error;
      Exsr *Pssr;
    EndMon;

   //If not purged for today , then do the purging
   If wTodayDate <> wLastPurgeDate;
     //Calculate purge date from purge days and Purge IAPSEUDOCP
     %Subst(PurgeDate:1:10) = %Char(wTodayDate-%Days(PurgeDays));

     Exec Sql
        Delete From IaPseudoCp
            Where  CRT_TIMESTAM  < :PurgeDate;

     If SqlCode < SuccessCode;
       uDpsds.wkQuery_Name = 'Delete_IAPSEUDOCP';
       IaSqlDiagnostic(uDpsds);                                                          //0001

     Else;
       //Update, today's date as last purge date in IABCKCNFG
       wLastPurgeDateChar  = %Char(wTodayDate);
       Exec Sql
         Update IABCKCNFG
         Set   Key_Value2 = :wLastPurgeDateChar
         Where KEY_NAME1  = :wKeyName1  And
               KEY_NAME2  = :wKeyName2;

       If SqlCode < SuccessCode;
         uDpsds.wkQuery_Name = 'Update_IABCKCNFG';
         IaSqlDiagnostic(uDpsds);                                                        //0001
       EndIf;
     EndIf;

   EndIf;

EndIf;

*Inlr = *On;
/copy 'QCPYSRC/iacerrlog.rpgleinc'
