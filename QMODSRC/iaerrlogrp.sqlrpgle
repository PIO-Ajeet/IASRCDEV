**free
      //%METADATA                                                      *
      // %TEXT Populate the Exceptions/Errors in log table             *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------ //
//CREATED BY :   Programmers.io @ 2020                                                 //
//CREATE DATE:   2022/02/14                                                            //
//DEVELOPER  :   Ajeet Srivastava                                                      //
//DESCRIPTION:   To capture the runtime exceptions/errors in log table                 //
//PROCEDURE LOG:                                                                       //
//------------------------------------------------------------------------------------ //
//Procedure Name           | Procedure Description                                     //
//-------------------------|---------------------------------------------------------- //
//No Procedure             |                                                           //
//------------------------------------------------------------------------------------ //
//MODIFICATION LOG:                                                                    //
//------------------------------------------------------------------------------------ //
//Date    | Mod_ID | Developer  | Case and Description                                 //
//--------|--------|------------|----------------------------------------------------- //
//        |  0001  |            | Renamed AIERRLOGP to IAERRLOGP (Task#247)            //
//        |  0002  |            | Rename AIERRLOGSV to IAERRLOGSV (Task#260)           //
//------------------------------------------------------------------------------------ //
ctl-opt copyright('Copyright @ Programmers.io © 2022');
ctl-opt option(*NoDebugIO : *SrcStmt : *noUnRef);
ctl-opt nomain;

//------------------------------------------------------------------------------------ //
//DataStructure Definition                                                             //
//------------------------------------------------------------------------------------ //
/copy 'QCPYSRC/iaderrlog.rpgleinc'

exec sql
   set option commit    = *none,
              naming    = *sys,
              usrprf    = *user,
              dynusrprf = *user,
              closqlcsr = *endmod,
              srtseq    = *langidshr;
//------------------------------------------------------------------------------------ //
//Prototype iAPssrErrorLog: To capture the PSSR exceptions/errors                      //
//------------------------------------------------------------------------------------ //
dcl-proc iAPssrErrorLog export;               //0002

   dcl-pi *n;
      upPsds likeds(uDpsds);
   end-pi ;

   monitor;
      Exec sql
      // insert into AIERRLOGP values(:upPsds);           //0001
         insert into IAERRLOGP values(:upPsds);           //0001
   on-error;
   endmon;

   return;
end-proc;
//------------------------------------------------------------------------------------ //
//Prototype iASqlDiagnostic: To capture the SQL exceptions/errors                      //
//------------------------------------------------------------------------------------ //
dcl-proc iASqlDiagnostic export;                 //0002

   dcl-pi iASqlDiagnostic;                       //0002
      upDiag likeds(uDpsds);
   end-pi ;

   monitor;
      exec sql GET DIAGNOSTICS
          :RowsCount = ROW_COUNT;

      exec sql GET DIAGNOSTICS CONDITION 1
            :ReturnedSqlCode = DB2_RETURNED_SQLCODE,
            :ReturnedSQLState = RETURNED_SQLSTATE,
            :MessageLength = MESSAGE_LENGTH,
            :MessageText = MESSAGE_TEXT,
            :MessageId = DB2_MESSAGE_ID,
            :MessageId1 = DB2_MESSAGE_ID1,
            :MessageId2 = DB2_MESSAGE_ID2 ;

      upDiag.StsCde         = %Dec(ReturnedSQLState:5:0);
      upDiag.EXCPTTYP       = MessageId;
      upDiag.EXCPTNBR       = MessageId1;
      upDiag.RTVEXCPTDT     = MessageText;

      Exec sql
      // Insert Into AIERRLOGP Values(:upDiag);           //0001
         Insert Into IAERRLOGP Values(:upDiag);           //0001
      If SqlState <> '00000';
      Endif;
   on-error;
   endmon;

   Return;

end-proc;
