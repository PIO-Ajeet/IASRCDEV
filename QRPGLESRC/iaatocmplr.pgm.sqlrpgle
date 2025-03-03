**Free
      //%METADATA                                                      *
      // %TEXT Compile all source in Lib and SrcPf                     *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------ //
//CREATED BY :   Programmers.io @ 2020                                                 //
//CREATE DATE:   2020/01/01                                                            //
//DEVELOPER  :   Kaushal kumar                                                         //
//DESCRIPTION:   This program compiles all Source members from passed source file      //
//                 Source Library into Object Library and creates Auto Compile         //
//                 report in passed developer's library                                //
//                                                                                     //
//PROCEDURE LOG:                                                                       //
//------------------------------------------------------------------------------------ //
//Procedure Name                          | Procedure Description                      //
//----------------------------------------|------------------------------------------- //
//CompileAllSources                       |                                            //
//InputsExists                            |                                            //
//PrepareAutoCompileFileSuccessfull       |                                            //
//CompileSource                           |                                            //
//CopyRecordsIntoDevLibFromQtemp          |                                            //
//UpdateCompilationFlagInAutoCompileFile  |                                            //
//RunClCommandSuccessfull                 |                                            //
//WriteCompilationReportInJoblog          |                                            //
//logMessage e                            |                                            //
//------------------------------------------------------------------------------------ //
//                                                                                     //
//MODIFICATION LOG:                                                                    //
//------------------------------------------------------------------------------------ //
//Date    | Mod_ID | Developer  | Case and Description                                 //
//--------|--------|------------|----------------------------------------------------- //
//06/04/22| HJ01   | Himanshu J | Adding cursor open check and wkSqlstmtNbr logic      //
//------------------------------------------------------------------------------------ //
ctl-opt copyright('Programmers.io © 2020 | Ashish | Changed April 2021');
ctl-opt option(*NoDebugIO : *SrcStmt : *noUnRef);
ctl-opt dftActGrp(*no);
ctl-opt bndDir('AIERRBND');

dcl-pi IAATOCMPLR extpgm('IAATOCMPLR');
   in_P1srcFile char(10) const;
   in_P2srcLib  char(10) const;
   in_P3objLib  char(10) const;
   in_P4devLib  char(10) const;
end-pi;

dcl-s T_flag         char(1)       template inz;
dcl-s T_library      varchar(10)   template inz;
dcl-s T_file         varchar(10)   template inz;
dcl-s T_srcMbrName   varchar(10)   template inz;
dcl-s T_srcMbrType   varchar(10)   template inz;
dcl-s T_clCmdStr     varchar(1000) template inz;
dcl-s T_message      varchar(500)  template inz;
dcl-s T_counter      packed(5)     template inz;
dcl-s T_numericDate8 zoned(8)      template inz;

dcl-c TRUE              '1';
dcl-c AUTO_CMPL_FILE    'IAAUTOCMPL';
dcl-c SRC_TO_BE_SKIPPED 'IAATOCMPLR';
dcl-c OUTPUT_FILE       'ALLSRCMBRS';
dcl-c QUOTE             '''';

/copy qcpysrc,aiderrlog

exec sql
  set option naming = *sys,
            commit = *none,
            usrPrf = *user,
            datFmt = *iso,
            timFmt = *iso,
            dynUsrPrf = *user,
            cloSqlCsr = *endMod;

Eval-corr uDpsds = wkuDpsds;                                                          //NG01
*inLR = TRUE;
//PROCEDURE LOG:
logMessage('------ Auto compile program starts ------');

CompileAllSources(in_P1srcFile:                               //Source file
                  in_P2srcLib:                                //Source Library
                  in_P3objLib:                                //Object Library
                  in_P4devLib);                               //Dev Library

logMessage('------- Auto compile program ends -------');

return;

/copy qcpysrc,aicerrlog

//------------------------------------------------------------------------------------ //
//CompileAllSources                                                                    //
//------------------------------------------------------------------------------------ //
dcl-proc CompileAllSources;
   dcl-pi CompileAllSources;
      P1srcFile like(T_file)    const options(*trim);
      P2srcLib  like(T_library) const options(*trim);
      P3objLib  like(T_library) const options(*trim);
      P4devLib  like(T_library) const options(*trim);
   end-pi;

   dcl-ds dsSourceNameAndType dim(10000) qualified inz;
      srcMbrName like(T_srcMbrName);
      srcMbrType like(T_srcMbrType);
   end-ds;

   dcl-s W_message      like(T_message)    inz;
   dcl-s W_srcMbrName   like(T_srcMbrName) inz;
   dcl-s W_srcMbrType   like(T_srcMbrType) inz;
   dcl-s W_successFlg   like(T_flag)       inz;
   dcl-s W_UpdateFlg    like(T_flag)       inz;
   dcl-s W_rowsFetched  like(T_counter)    inz;
   dcl-s W_index        like(T_counter)    inz;
   dcl-s W_SuccessCount like(T_counter)    inz;
   dcl-s W_FailureCount like(T_counter)    inz;
   dcl-s W_rows         like(T_counter)    inz;

   if P1srcFile = *blanks OR
      P2srcLib  = *blanks OR
      P3objLib  = *blanks OR
      P4devLib  = *blanks;
      logMessage('Atleast one Input parameter is Blank');
      return;
   endif;

   if not InputsExists(P1srcFile:
                       P2srcLib:
                       P3objLib:
                       P4devLib);
      W_message = 'Inputs not found or have Authority issue';
      logMessage(W_message);
      return;
   endif;

   if not PrepareAutoCompileFileSuccessfull(P1srcFile:
                                            P2srcLib:
                                            P3objLib:
                                            P4devLib);
      W_message = AUTO_CMPL_FILE + ' file in ' + P4devLib
                    + ' cannot be prepared';
      logMessage(W_message);
      return;
   endif;

   W_rows = %elem(dsSourceNameAndType);

   exec sql
    declare C_getMbrNameAndMbrType cursor for
     select ATSRCMBRNM,ATSRCMBRTP
       from IAAUTOCMPL;

   exec sql open C_getMbrNameAndMbrType;

   if sqlCode = CSR_OPN_COD;                                                                //HJ01
     exec sql close C_getMbrNameAndMbrType;                                                 //HJ01
     exec sql open  C_getMbrNameAndMbrType;                                                 //HJ01
   endif;                                                                                   //HJ01

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Open_C_getMbrNameAndMbrType';                                  //NG01
      AiSqlDiagnostic(uDpsds);
   endif;

   if sqlCode = successCode;

      exec sql fetch C_getMbrNameAndMbrType
                for :w_rows ROWS into :dsSourceNameAndType;

      If sqlCode < successCode;
         uDpsds.wkQuery_Name = 'Fetch_C_getMBrNameAndMbrType';                              //NG01
         AiSqlDiagnostic(uDpsds);
      endif;

      if sqlCode = successCode;
         exec sql get diagnostics :RowsCount = ROW_COUNT;
      endif;

      exec sql close C_getMbrNameAndMbrType;

   endif;

   if RowsCount = 0;
      logMessage('No records found in IAAUTOCMPL');
      return;
   endif;

   //Start compilation of sources                                                        //
   logMessage('-------- Compilation Starts -------------');

   for W_index = 1 to W_rowsFetched;
      W_srcMbrName = dsSourceNameAndType(W_index).srcMbrName;
      W_srcMbrType = dsSourceNameAndType(W_index).srcMbrType;
      CompileSource(W_srcMbrName:
                    W_srcMbrType:
                    P1srcFile:
                    P2srcLib:
                    P3objLib:
                    W_successFlg);

      select;
      when W_successFlg = 'Y';
         W_SuccessCount = W_SuccessCount + 1;
      when W_successFlg <> 'Y';
         W_FailureCount = W_FailureCount + 1;
      endsl;

      UpdateCompilationFlagInAutoCompileFile(P4devLib:
                                             W_srcMbrName:
                                             W_successFlg);
   endfor;
   logMessage('- - - - -- Compilation Ends -- - - - - --');

   WriteCompilationReportInJoblog(P1srcFile:
                                  P2srcLib:
                                  P3objLib:
                                  P4devLib:
                                  W_rowsFetched:
                                  W_SuccessCount:
                                  W_FailureCount);

end-proc CompileAllSources;

//------------------------------------------------------------------------------------ //
//InputsExists                                                                         //
//------------------------------------------------------------------------------------ //
dcl-proc InputsExists;
   dcl-pi InputsExists ind;
      P1srcFile  like(T_file)    const;
      P2srcLib   like(T_library) const;
      P3objLib   like(T_library) const;
      P4devLib   like(T_library) const;
   end-pi;

   dcl-s clCmdStr   like(T_clCmdStr) inz;

   dcl-c INPUTS_EXISTS '1';
   dcl-c CHECK_OBJECT 'CHKOBJ OBJ({1}/{2}) OBJTYPE(*FILE)';
   dcl-c CHECK_LIBRARY 'CHKOBJ OBJ({1}) OBJTYPE(*LIB)';

   clCmdStr = CHECK_OBJECT;
   clCmdStr = %scanrpl('{1}': P2srcLib : clCmdStr);
   clCmdStr = %scanrpl('{2}': P1srcFile: clCmdStr);
   if not RunClCommandSuccessfull(clCmdStr);
      return not INPUTS_EXISTS;
   endif;

   clCmdStr = CHECK_LIBRARY;
   clCmdStr = %scanrpl('{1}': P3objLib: clCmdStr);
   if not RunClCommandSuccessfull(clCmdStr);
      return not INPUTS_EXISTS;
   endif;

   clCmdStr = CHECK_LIBRARY;
   clCmdStr = %scanrpl('{1}': P4devLib: clCmdStr);
   if not RunClCommandSuccessfull(clCmdStr);
      return not INPUTS_EXISTS;
   endif;

   return INPUTS_EXISTS;

end-proc InputsExists;

//------------------------------------------------------------------------------------ //
//PrepareAutoCompileFileSuccessfull                                                    //
//------------------------------------------------------------------------------------ //
dcl-proc PrepareAutoCompileFileSuccessfull;
   dcl-pi PrepareAutoCompileFileSuccessfull ind;
      P1srcFile like(T_file)    const;
      P2srcLib  like(T_library) const;
      P3objLib  like(T_library) const;
      P4devLib  like(T_library) const;
   end-pi;

   dcl-s clCmdStr like(T_clCmdStr)  inz;
   dcl-s W_Dummy   char(1)          inz;  // debug Variable

   dcl-c SUCCESS '1';
   dcl-c CREATE_FILE     'DSPFD FILE({1}/{2}) TYPE(*MBR) -
                             OUTPUT(*OUTFILE) OUTFILE({3}/{4})';
   dcl-c TEMP_LIB        'QTEMP';
   dcl-c CRT_DUPL_OBJ    'CRTDUPOBJ OBJ({1}) FROMLIB({2}) -
                             OBJTYPE(*FILE) TOLIB({3}) -
                             CST(*NO) TRG(*NO)';
   dcl-c #IADTA          '#IADTA';
   dcl-c DELETE_FILE     'DLTOBJ OBJ({1}/{2}) OBJTYPE(*FILE)';

   //Delete outFile of DSPFD from QTEMP
   clCmdStr = DELETE_FILE;
   clCmdStr = %scanrpl('{1}': TEMP_LIB    : clCmdStr);
   clCmdStr = %scanrpl('{2}': OUTPUT_FILE : clCmdStr);

   if not RunClCommandSuccessfull(clCmdStr);
      W_dummy = '1';
   endif;

   //Create outFile of DSPFD in QTEMP
   clCmdStr = CREATE_FILE;
   clCmdStr = %scanrpl('{1}': P2srcLib   : clCmdStr);
   clCmdStr = %scanrpl('{2}': P1srcFile  : clCmdStr);
   clCmdStr = %scanrpl('{3}': TEMP_LIB   : clCmdStr);
   clCmdStr = %scanrpl('{4}': OUTPUT_FILE: clCmdStr);

   if not RunClCommandSuccessfull(clCmdStr);
      return not SUCCESS;
   endif;

   //Delete IAAUTOCMPL file from Developer's library if
   // it already exists
   clCmdStr = DELETE_FILE;
   clCmdStr = %scanrpl('{1}': P4devLib       : clCmdStr);
   clCmdStr = %scanrpl('{2}': AUTO_CMPL_FILE : clCmdStr);

   if not RunClCommandSuccessfull(clCmdStr);
      W_dummy = '1';
   endif;

   //Copy Object of file IAAUTOCMPL from #IADTA to
   // Developer's Library
   clCmdStr = CRT_DUPL_OBJ;
   clCmdStr = %scanrpl('{1}': AUTO_CMPL_FILE: clCmdStr);
   clCmdStr = %scanrpl('{2}': #IADTA        : clCmdStr);
   clCmdStr = %scanrpl('{3}': P4devLib      : clCmdStr);

   if not RunClCommandSuccessfull(clCmdStr);
      return not SUCCESS;
   endif;

   if not CopyRecordsIntoDevLibFromQtemp(TEMP_LIB:
                                         P3objLib:
                                         P4devLib);
      return not SUCCESS;
   endif;

   //Delete outFile of DSPFD from QTEMP
   clCmdStr = DELETE_FILE;
   clCmdStr = %scanrpl('{1}': TEMP_LIB   : clCmdStr);
   clCmdStr = %scanrpl('{2}': OUTPUT_FILE: clCmdStr);
   if not RunClCommandSuccessfull(clCmdStr);
      W_dummy = '1';
   endif;

   return SUCCESS;

end-proc PrepareAutoCompileFileSuccessfull;

//------------------------------------------------------------------------------------ //
//CompileSource;                                                                       //
//------------------------------------------------------------------------------------ //
dcl-proc CompileSource;
   dcl-pi CompileSource;
      in_srcMbrName   like(T_srcMbrName) const;
      in_srcMbrTyp    like(T_srcMbrType) const;
      P1srcFile       like(T_file)       const;
      P2srcLib        like(T_library)    const;
      P3objLib        like(T_library)    const;
      out_successFlg  like(T_flag);
   end-pi;

   dcl-s clCmdStr like(T_clCmdStr) inz;
   dcl-s W_dummy  char(1)          inz;

   dcl-c YES  'Y';
   dcl-c NO   'N';
   dcl-c CREATE_OBJ    'CRTSQLRPGI OBJ({1}/{2}) -
                               SRCFILE({3}/{4}) -
                               SRCMBR({2}) -
                               OBJTYPE({5}) -
                               DBGVIEW({6}) -
                               COMMIT(*NONE) -
                               RPGPPOPT(*LVL2) -
                               CLOSQLCSR(*ENDMOD) -
                               REPLACE(*YES)';

   dcl-c OBJTYP       '*MODULE';
   dcl-c DBGVIEW      '*SOURCE';
   dcl-c SQLRPGLE     'SQLRPGLE';
   dcl-c DLT_MODULE   'DLTOBJ OBJ({1}/{2}) OBJTYPE(*MODULE)';

   clear out_successFlg;

   // Source of this program should not be compiled.
   if in_srcMbrName = SRC_TO_BE_SKIPPED;
      out_successFlg = YES;
      return;
   endif;

   // Currently this code compiles only SQLRPGLE type of
   // source members.
   if in_srcMbrTyp <> SQLRPGLE;
      out_successFlg = NO;
      return;
   endif;

   clCmdStr = DLT_MODULE;
   clCmdStr = %scanrpl('{1}': P3objLib     : clCmdStr);
   clCmdStr = %scanrpl('{2}': in_srcMbrName: clCmdStr);
   if not RunClCommandSuccessfull(clCmdStr);
      W_dummy = '1';
   endif;

   clCmdStr = CREATE_OBJ;
   clCmdStr = %scanrpl('{1}': P3objLib     : clCmdStr);
   clCmdStr = %scanrpl('{2}': in_srcMbrName: clCmdStr);
   clCmdStr = %scanrpl('{3}': P2srcLib     : clCmdStr);
   clCmdStr = %scanrpl('{4}': P1srcFile    : clCmdStr);
   clCmdStr = %scanrpl('{5}': OBJTYP       : clCmdStr);
   clCmdStr = %scanrpl('{6}': DBGVIEW      : clCmdStr);
   if not RunClCommandSuccessfull(clCmdStr);
      out_successFlg = NO;
   endif;

   out_successFlg = YES;

end-proc CompileSource;

//------------------------------------------------------------------------------------ //
//CopyRecordsIntoDevLibFromQtemp                                                       //
//------------------------------------------------------------------------------------ //
dcl-proc CopyRecordsIntoDevLibFromQtemp;

   dcl-pi CopyRecordsIntoDevLibFromQtemp ind;
      in_fromLib      like(T_library)    const;
      P3objLib        like(T_library)    const;
      P4devLib        like(T_library)    const;
   end-pi;

   dcl-c RECORDS_COPIED '1';

   exec sql
     insert into AUTO_CMPL_FILE(ATDEVLIB,
                                ATOBJLIB,
                                ATSRCLIB,
                                ATSRCFILE,
                                ATSRCMBRNM,
                                ATSRCMBRTP,
                                ATSRCMBRTX,
                                ATCRTNDT,
                                ATLSTCHGDT)
                         select :P4devLib,
                                :P3objLib,
                                MBLIB,
                                MBFILE,
                                MBNAME,
                                MBSEU2,
                                MBMTXT,
                                MBCDAT,
                                MBUPDD
                           from OUTPUT_FILE;

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Insert_AUTO_CMPL_FILE';                                     //NG01
      AiSqlDiagnostic(uDpsds);
      return not RECORDS_COPIED;                                                         //HJ01
   endif;

   return RECORDS_COPIED;

end-proc CopyRecordsIntoDevLibFromQtemp;

//------------------------------------------------------------------------------------ //
//UpdateCompilationFlagInAutoCompileFile                                               //
//------------------------------------------------------------------------------------ //
dcl-proc UpdateCompilationFlagInAutoCompileFile;

   dcl-pi UpdateCompilationFlagInAutoCompileFile;
      P4devLib              like(T_library) const;
      in_srcMbrName         like(T_library) const;
      in_cmplSuccessFlg     like(T_flag)    const;
   end-pi;

   dcl-s W_Dummy   char(1)  inz;

   exec sql
     update AUTO_CMPL_FILE
        set ATCMPLDFLG = :in_cmplSuccessFlg
      where ATSRCMBRNM = :in_srcMbrName;

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Update_Auto_Cmpl_File';                                     //NG01
      AiSqlDiagnostic(uDpsds);
      W_Dummy = '1';                                                                     //HJ01
   endif;

end-proc UpdateCompilationFlagInAutoCompileFile;

//------------------------------------------------------------------------------------ //
//RunClCommandSuccessfull                                                              //
//------------------------------------------------------------------------------------ //
dcl-proc RunClCommandSuccessfull;

   dcl-pi RunClCommandSuccessfull ind;
      in_clCommandString like(T_clCmdStr) const;
   end-pi;

   dcl-pr executeQcmdexc extPgm('QCMDEXC');
      *n char(10000) const;
      *n packed(15:5) const;
   end-pr;

   dcl-c COMMAND_EXECUTED '1';

   monitor;
      executeQcmdexc(in_clCommandString:
                     %len(in_clCommandString));
      return COMMAND_EXECUTED;
   on-error;
      return not COMMAND_EXECUTED;
   endmon;

end-proc RunClCommandSuccessfull;

//------------------------------------------------------------------------------------ //
//WriteCompilationReportInJoblog                                                       //
//------------------------------------------------------------------------------------ //
dcl-proc WriteCompilationReportInJoblog;

   dcl-pi WriteCompilationReportInJoblog;
      P1srcFile            like(T_file)    const;
      P2srcLib             like(T_library) const;
      P3objLib             like(T_library) const;
      P4devLib             like(T_library) const;
      in_totalNoOfSrcMbrs  like(T_counter) const;
      in_SuccessCount      like(T_counter) const;
      in_FailureCount      like(T_counter) const;
   end-pi;

   dcl-s W_message         like(T_message)    inz;

   logMessage('-----------------------------------------');

   W_message = 'Source File .................:' + P1srcFile;
   logMessage(W_message);

   W_message = 'Source Library ..............:' + P2srcLib;
   logMessage(W_message);

   W_message = 'Object Library ..............:' + P3objLib;
   logMessage(W_message);

   W_message = 'Developer-s Library .........:' + P4devLib;
   logMessage(W_message);

   logMessage('--  --  --  --  --  --  --  --  --  --  -');

   W_message = 'Total no of Sources .........:'
                 + %char(in_totalNoOfSrcMbrs);
   logMessage(W_message);

   W_message = 'Successfull Compilations ....:'
                 + %char(in_SuccessCount);
   logMessage(W_message);

   W_message = 'UnSuccessfull Compilations...:'
                 + %char(in_failureCount);
   logMessage(W_message);

   logMessage('-----------------------------------------');

   logMessage(*blanks);
   W_message = 'Select * from ' + P4devLib + '/' + AUTO_CMPL_FILE;
   logMessage(W_message);
   W_message = '     where ATCMPLDFLG <> ' + QUOTE + 'Y' + QUOTE;
   logMessage(W_message);

end-proc WriteCompilationReportInJoblog;

//------------------------------------------------------------------------------------ //
//logMessage :                                                                         //
//------------------------------------------------------------------------------------ //
dcl-proc logMessage;

   dcl-pi logMessage;
      in_message like(T_message) const;
   end-pi;

   dcl-pr writeCustomJobLog int(10) extProc('Qp0zLprintf');
      *n pointer value options(*string);
      *n pointer value options(*string:*noPass);
   end-pr;

   dcl-s W_customizedMessage varchar(1000) inz;

   dcl-c LINE_FEED x'25';

   if in_message = *blanks;
      return;
   endif;

   W_customizedMessage = '   ' + in_message + LINE_FEED;
   writeCustomJobLog(W_customizedMessage);

end-proc logMessage;
