**FREE
      //%METADATA                                                      *
      // %TEXT IA Environment Setup                                    *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------- //
//Created By   :  Programmers.io @ 2024                                                 //
//Created Date :  2024/08/02                                                            //
//Developer    :  Piyush Kumar                                                          //
//Description  :  IA Environment Setup                                                  //
//                                                                                      //
//Procedure Log:                                                                        //
//------------------------------------------------------------------------------------- //
//Procedure Name           | Procedure Description                                      //
//-------------------------|----------------------------------------------------------- //
//IA_SetEnvironment        | Procedure to set environment based on the Environment      //
//                         | Library received from SP. Library List details are         //
//                         | configured in IABCKCNFG with DEVLIBL and PRODLIBL keys.    //
//------------------------------------------------------------------------------------- //
//                                                                                      //
//Modification Log:                                                                     //
//------------------------------------------------------------------------------------- //
//Date    | Mod_ID | Developer  | Case and Description                                  //
//--------|--------|------------|------------------------------------------------------ //
//        |        |            |                                                       //
// ------------------------------------------------------------------------------------- //
Ctl-Opt Copyright('Programmers.io Â© 2024 | Created Aug 2024');
Ctl-Opt Option(*noDebugIo: *srcStmt: *noUnRef) expropts(*RESDECPOS) Debug;
Ctl-Opt DftActGrp(*No);

//------------------------------------------------------------------------------------- //
//Copybook Definitions
//------------------------------------------------------------------------------------- //

//------------------------------------------------------------------------------------- //
//Prototype Definitions
//------------------------------------------------------------------------------------- //
Dcl-Pr QcmdExc ExtPgm('QCMDEXC');
   *N Char(500)    Options(*Varsize) Const;
   *N Packed(15:5) Const;
   *N Char(3)      Options(*Nopass) Const;
End-Pr;

//------------------------------------------------------------------------------------- //
//Constant and Variables Definitions
//------------------------------------------------------------------------------------- //
Dcl-S wk_CmdStr VarChar(1000) Inz;

//------------------------------------------------------------------------------------- //
//Main Program
//------------------------------------------------------------------------------------- //
Dcl-Pi IASETENV;
   pLibName Char(10);
   pStatus  Ind;
End-Pi;

pStatus = IA_SetEnvironment(pLibName);

*InLr = *On;

//------------------------------------------------------------------------------------- //
//IA_SetEnvironment : Procedure to set environment
//Input Fields      : Library Name
//                  : Environment Type
//------------------------------------------------------------------------------------- //
Dcl-Proc IA_SetEnvironment;
   Dcl-Pi *N Ind;
      pLibName Char(10) Const;
   End-Pi;

   //Local Variables
   Dcl-S lDataLibN VarChar(10)  Inz;
   Dcl-S lKey1     VarChar(15)  Inz(*BLANKS) ;
   Dcl-S lKeyValue VarChar(30)  Inz;
   Dcl-S lSqlStm   VarChar(500) Inz;
   Dcl-S lLibList  VarChar(500) Inz;

   //Set the library.
   If pLibName = 'IAOBJDEV'  ;
      lDataLibN = 'IADTADEV' ;
      lKey1 = 'DEVLIBL';
   Else;
      lDataLibN = '#IADTA' ;
      lKey1 = 'PRODLIBL';
   EndIf ;

   lSqlStm ='Select IAKEYVAL1 from ' + %Trim(lDataLibN) +
            '/IABCKCNFG Where IAKEYNAME1 = ''' +
            lKey1 + ''' ';

   Exec Sql Prepare StmtLibList From :lSqlStm;

   Exec Sql Declare CursorLibList Cursor For StmtLibList;

   Exec Sql Open CursorLibList;

   If SqlCode = -502;
      Exec Sql Close CursorLibList;
      Exec Sql Open CursorLibList;
   EndIf;

   If SqlCode = *Zeros;
      Exec Sql Fetch Next from CursorLibList Into :lKeyValue;

      DoW SqlCode = *Zeros;
         lLibList = %Trim(lLibList) + ' ' + %Trim(lKeyValue);
         Exec Sql Fetch Next from CursorLibList Into :lKeyValue;
      EndDo;

      Exec Sql Close CursorLibList;

   EndIf;

   If lLibList <> *Blanks;
      wk_CmdStr = 'CHGLIBL LIBL(' + %Trim(lLibList) + ')';
      Monitor;
         QCmdExc(wk_CmdStr:%Len(wk_CmdStr));
      On-Error;
         Return *Off;
      EndMon;
   Else;
      Return *Off;
   EndIF;

   Return *On;

End-Proc;
