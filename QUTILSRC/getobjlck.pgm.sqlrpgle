**free
      //%METADATA                                                      *
      // %TEXT iA Tool Purge all object locks                          *
      //%EMETADATA                                                     *
     //----------------------------------------------------------------------*/
     //Copyright © Programmers.Io, 2021 All rights reserved.                 */
     //----------------------------------------------------------------------*/
     //File   : iA Tool Purge all object locks                               */
     //----------------------------------------------------------------------*/
     //Description:                                                          */
     //iA Tool requires purging all object locks of DATA, OBJECT & SOURCE    */
     //library in order avoid lock waits in iA Tool Compilation utility.     */
     //----------------------------------------------------------------------*/
     //Modification Log:                                                     */
     //-----------------                                                     */
     //----------------------------------------------------------------------*/

     //------
     //h-Spec
     //------
     Ctl-Opt Copyright('Copyright © Programmers.Io, 2021 All rights reserved');
     Ctl-Opt Option(*nodebugio:*srcstmt:*nounref)
             Dftactgrp(*no);

     //------
     //f-Spec
     //------
     Dcl-F GETOBJLCKD workstn    Usage(*Input:*Output) SFile(SFL01:RRN1)
                                                       IndDs(IndDs1)
                                                       InfDs(InfDs1);

     //------
     //d-Spec
     //------

     //--------------------------------
     //Main Program Prototype Interface
     //--------------------------------
     Dcl-PI MainPgm ExtPgm('GETOBJLCK');
     End-PI;

     //------------------------
     //Indicator Data Structure
     //------------------------
     Dcl-Ds IndDs1;
        Exit      ind pos(03);
        Refresh   ind pos(05);
        Confirm   ind pos(10);
        Repeat    ind pos(13);
        SflDsp    ind pos(25);
        SflDspCtl ind pos(26);
        SflClr    ind pos(27);
        SflEnd    ind pos(28);
        SflNxtChg ind pos(29);
        RIS1Opt   ind pos(30);
     End-Ds;

     //-------------------------------
     //File Information Data Structure
     //-------------------------------
     Dcl-Ds InfDs1;
        FunKey char(01) pos(369);
     End-Ds;

     //------------------------------------
     //Data Area data structure declaration
     //------------------------------------
     Dcl-Ds AICTLDTA   dtaara len(200);
        Dcl-SubF g_SrcLib char(10) pos(01);
        Dcl-SubF g_DtaLib char(10) pos(11);
        Dcl-SubF g_ObjLib char(10) pos(21);
     End-Ds;

     //--------------------------------
     //Other data structure declaration
     //--------------------------------
     Dcl-Ds g_C01Ds;
        Dcl-SubF g_JOBDTL  char(28);
        Dcl-SubF g_LIBNAM  char(10);
     End-Ds;

     //--------------------
     //Arrays
     //--------------------
     Dcl-S  g_MsgInfArr    char(80) Dim(10)
                                    CTData
                                    PerRcd(1);

     //--------------------
     //Standalone Variables
     //--------------------
     Dcl-S  g_ErrFlg       ind Inz(*Off);

     //---------
     //Constants
     //---------
     Dcl-C  SQL_ALL_OK         Const('00000');
     Dcl-C  SQL_NO_MORE_RCD    Const('02000');
     Dcl-C  ENTER              Const(x'F1')  ;
     Dcl-C  QUOTE              Const(x'7D')  ;
     Dcl-C  SFLSIZ             Const(9999)   ;

     //--------------------
     //Mainline Programming
     //--------------------

     //Set processing options to be used for SQL Statements in program.
     Exec Sql
          Set Option Commit    = *None,
                     Naming    = *Sys,
                     UsrPrf    = *User,
                     DynUsrPrf = *User,
                     CloSqlCsr = *EndMod;
     *inLR = *On;
     //Retrieve Data library name.
     in AICTLDTA;

     //Clear Subfile 01.
     @pr_ClrSfl();
     //Load Subfile 01.
     @pr_LodSfl();
     //Display Subfile 01.
     @pr_DspSfl();
     //Write Header & Footer.
     @pr_WrtHdrFtr();
     //Do until user press 'F3'
     DoU Exit;
        ExFmt SFLCTL01;
        //Reset global error message and indicators
        @pr_ReSetErr();
        Select;
           //When user press 'F3'
           When Exit;
              Leave;
           //When user press 'F5'
           When Refresh;
              @pr_ClrSfl();
              @pr_LodSfl();
              @pr_DspSfl();
              @pr_WrtHdrFtr();
           //When user press 'F13'
           When Repeat;
              @pr_ProcessRepeat();
           //When user press 'ENTER'
           When FunKey = ENTER;
              @pr_ProcessEnter();
        EndSl;
     EndDo;

     //End of Program!
     @pr_EndPgm();
     Return;

     //--------------------------
     //Procedure to clear subfile
     //--------------------------
     Dcl-Proc  @pr_ClrSfl;
        Dcl-PI @pr_ClrSfl;
        End-PI @pr_ClrSfl;

        //Set Off Sfl Dsp/DspCtl/End indicators.
        SflDspCtl = *Off;
        SflDsp    = *Off;
        SflEnd    = *Off;
        //Set RRN to Zero and Set On Sfl Clr indicator.
        RRN1      = *Zeros;
        SflClr    = *On;
        //Clear subfile.
        Write SFLCTL01;
        SflClr    = *Off;

     End-Proc  @pr_ClrSfl;

     //-------------------------
     //Procedure to Load subfile
     //-------------------------
     Dcl-Proc  @pr_LodSfl;
        Dcl-PI @pr_LodSfl;
           Dcl-Parm p_Opt char(01) Const Options(*NoPass);
        End-PI @pr_LodSfl;

        Dcl-S  l_JobDtl char(28);
        Dcl-S  l_Pos1   packed(2:0);
        Dcl-S  l_Pos2   packed(2:0);

        //Close Cursor 'C01', if exists.
        @pr_HdlCsrC01Act('CLOSE');
        //Declare Cursor 'C01'.
        @pr_HdlCsrC01Act('DECLARE');
        //Open Cursor 'C01'.
        @pr_HdlCsrC01Act('OPEN');
        //Fetch Cursor 'C01'.
        @pr_HdlCsrC01Act('FETCH');

        //Fetch Cursor 'C01'.
        DoW SQLSTATE = SQL_ALL_OK;

           //get job details after fetch command.
           l_JobDtl  = g_JOBDTL;
           l_Pos1    = %scan('/':l_JobDtl:1);
           l_Pos2    = %scan('/':l_JobDtl:l_Pos1 + 1);

           //Populate subfile fields
           If p_Opt  = ' ';
              S1OPT  = *Blank;
           Else;
              S1OPT  = p_Opt;
           EndIf;
           S1USRNAM  = %subst(l_JobDtl: l_Pos1 + 1 : l_Pos2 - l_Pos1 -1);
           S1LIBNAM  = g_LIBNAM;
           S1JOBDTL  = l_JobDtl;

           //Increment RRN, before loading subfile
           RRN1 += 1;
           Write SFL01;

           //Handle when RRN reached maximum SFLSIZ
           If RRN1 = SFLSIZ;
              Leave;
           EndIf;

           //Fetch Cursor 'C01'.
           @pr_HdlCsrC01Act('FETCH');
        EndDo;

     End-Proc  @pr_LodSfl;

     //---------------------------------------
     //Procedure to Handle Cursor C01 Activity
     //---------------------------------------
     Dcl-Proc  @pr_HdlCsrC01Act;
        Dcl-PI @pr_HdlCsrC01Act;
           Dcl-Parm p_Activity char(07) Const;
        End-PI @pr_HdlCsrC01Act;

        //Declare Cursor 'C01'.
        If p_Activity = 'DECLARE';
           Exec Sql
                DECLARE C01 CURSOR FOR
                SELECT  DISTINCT(JOB_NAME),
                        SUBSTR(SYSTEM_OBJECT_NAME,1,10)
                FROM    QSYS2.OBJECT_LOCK_INFO
                WHERE   SYSTEM_OBJECT_SCHEMA = 'QSYS'
                  AND  (SYSTEM_OBJECT_NAME   = :g_DtaLib
                   OR   SYSTEM_OBJECT_NAME   = :g_ObjLib
                   OR   SYSTEM_OBJECT_NAME   = :g_SrcLib)
                  AND   OBJECT_TYPE          = '*LIB'
                  AND   STATUS               = 'HELD'
                  FOR   read only;

        //Open Cursor 'C01'.
        ElseIf p_Activity = 'OPEN';
           Exec Sql
                Open C01;

        //Fetch Cursor 'C01'.
        ElseIf p_Activity = 'FETCH';
           Exec Sql
                Fetch next from C01 into :g_C01DS;

        //Close Cursor 'C01'.
        ElseIf p_Activity = 'CLOSE';
           Exec Sql
                Close C01;

        EndIf;

     End-Proc  @pr_HdlCsrC01Act;

     //----------------------------
     //Procedure to Display Subfile
     //----------------------------
     Dcl-Proc  @pr_DspSfl;
        Dcl-PI @pr_DspSfl;
        End-PI @pr_DspSfl;

        //Set Sfl Dsp/DspCtl/End indicators accordingly.
        SflDspCtl = *On;
        If RRN1   = *Zeros;
           SflDsp = *Off;
        Else;
           SflDsp = *On;
           RRN1   = 1;
        EndIf;
        SflEnd    = (SQLSTATE = SQL_NO_MORE_RCD);

     End-Proc  @pr_DspSfl;

     //-------------------------
     //Procedure to ReSet errors
     //-------------------------
     Dcl-Proc  @pr_ReSetErr;
        Dcl-PI @pr_ReSetErr;
        End-PI @pr_ReSetErr;

        //Clear Footer message.
        Clear F1MSG;
        //Set Off global error flag.
        g_ErrFlg  = *Off;
        //Set Off all reverse image indicators.
        RIS1Opt   = *Off;

     End-Proc  @pr_ReSetErr;

     //------------------------
     //Procedure to End Program
     //------------------------
     Dcl-Proc  @pr_EndPgm;
        Dcl-PI @pr_EndPgm;
        End-PI @pr_EndPgm;

        //Close Cursor 'C01', if active.
        @pr_HdlCsrC01Act('CLOSE');
        //Check Error.
        If SQLSTATE <> SQL_ALL_OK;
           //Log Error
        EndIf;
        //Out AICTLDTA;

     End-Proc  @pr_EndPgm;

     //------------------------------------
     //Procedure to Write Header and Footer
     //------------------------------------
     Dcl-Proc  @pr_WrtHdrFtr;
        Dcl-PI @pr_WrtHdrFtr;
        End-PI @pr_WrtHdrFtr;

        //Write Header
        Write Header1;
        //Write Footer
        F1TITLE = g_MsgInfArr(1);
        F1MSG   = *Blanks;
        Write Footer1;

     End-Proc  @pr_WrtHdrFtr;

     //----------------------------
     //Procedure to Process Repeat.
     //----------------------------
     Dcl-PROC  @pr_ProcessRepeat;
        Dcl-PI @pr_ProcessRepeat;
        End-PI @pr_ProcessRepeat;

        //Declare local variable.
        Dcl-S  l_Opt char(01) inz(' ');

        //Read first changed record.
        ReadC SFL01;
        //If no record has been changed, then return.
        If %eof;
          Return;
        Else;
            DoW not %eof;
               Select;
               //If changed record is having S1OPT = ' ', then iter.
               When S1OPT = ' ';
                  SflNxtChg = *Off;
                  Clear S1OPT;
                  Update SFL01;
                  //Read next changed record.
                  ReadC SFL01;
               //If changed record is having S1OPT = '4'/'5', then repeat.
               When S1OPT = '4'
                 or S1OPT = '5';
                  l_Opt = S1OPT;
                  SflNxtChg = *On;
                  Clear S1OPT;
                  Update SFL01;
                  F1MSG = g_MsgInfArr(2);
                  Leave;
               EndSl;
            EndDo;
        EndIf;
        @pr_ClrSfl();
        @pr_LodSfl(l_Opt);
        @pr_DspSfl();
        @pr_WrtHdrFtr();

     End-PROC  @pr_ProcessRepeat;

     //---------------------------
     //Procedure to Process Enter.
     //---------------------------
     Dcl-PROC  @pr_ProcessEnter;
        Dcl-PI @pr_ProcessEnter;
        End-PI @pr_ProcessEnter;

        //Read first changed record.
        ReadC SFL01;
        //If no record has been changed, then return.
        If %eof;
          Return;
        Else;
            DoW not %eof;
               Select;
               //If changed record is having S1OPT = ' ', then iter.
               When S1OPT = ' ';
               //If changed record is having S1OPT = '4', then end job.
               When S1OPT = '4';
                  @pr_EndJob(S1JOBDTL);
               //If changed record is having S1OPT = '5', then send msg.
               When S1OPT = '5';
                  @pr_SndBrkMsg(S1USRNAM);
               EndSl;
               Clear S1OPT;
               Update SFL01;
               //Read next changed record.
               ReadC SFL01;
            EndDo;
        EndIf;
        @pr_ClrSfl();
        @pr_LodSfl();
        @pr_DspSfl();
        @pr_WrtHdrFtr();

     End-PROC  @pr_ProcessEnter;

     //-----------------------------
     //Procedure to End Active Jobs.
     //-----------------------------
     Dcl-PROC  @pr_EndJob;
        Dcl-PI @pr_EndJob;
           Dcl-Parm p_JobDtl Char(28) Const;
        End-PI @pr_EndJob;

        //Declare local variable.
        Dcl-S l_CmdString char(100);

        //Prepare string for CL command 'ENDJOB'.
        l_CmdString = 'ENDJOB JOB('
                    + %trim(p_JobDtl)
                    + ') OPTION(*IMMED) DELAY(1) LOGLMT(0)';

        //Call QCMDEXC.
        Exec Sql
             CALL QSYS2.QCMDEXC(:l_CmdString);
        //Check Error.
        If SQLSTATE <> SQL_ALL_OK;
           //Log Error
        EndIf;

        Return;

     End-PROC  @pr_EndJob;

     //--------------------------------
     //Procedure to Send Break Message.
     //--------------------------------
     Dcl-PROC  @pr_SndBrKMsg;
        Dcl-PI @pr_SndBrKMsg;
           Dcl-Parm p_UsrNam Char(10) Const;
        End-PI @pr_SndBrKMsg;

        //Declare local variable.
        Dcl-S l_CmdString char(100);

        //Prepare string for CL command 'SNDBRKMSG'.
        l_CmdString = 'SNDBRKMSG MSG('
                    + QUOTE
                    + %trim(g_MsgInfArr(3))
                    + QUOTE
                    + ') TOMSGQ('
                    + %trim(p_UsrNam)
                    + ')';

        //Call QCMDEXC.
        Exec Sql
             CALL QSYS2.QCMDEXC(:l_CmdString);
        //Check Error.
        If SQLSTATE <> SQL_ALL_OK;
           //Log Error
        EndIf;

        Return;

     End-PROC  @pr_SndBrKMsg;

** CTA - Message Info Array
F3=Exit  F5=Refresh  F13=Repeat
Successfully ended Job.
Please come out of session.
