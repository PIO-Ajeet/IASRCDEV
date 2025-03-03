**free
      //%METADATA                                                      *
      // %TEXT CU Delete locking jobs program                          *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------ //
//CREATED BY :   Programmers.io @ 2022                                                 //
//CREATE DATE:   2022/01/28                                                            //
//DEVELOPER  :   Ashwani Kumar                                                         //
//DESCRIPTION:   Compilation utility based on main control file.                       //
//                                                                                     //
//PROCEDURE LOG:                                                                       //
//------------------------------------------------------------------------------------ //
//Procedure Name           | Procedure Description                                     //
//-------------------------|---------------------------------------------------------- //
//No Procedure             |                                                           //
//------------------------------------------------------------------------------------ //
//                                                                                     //
//MODIFICATION LOG:                                                                    //
//------------------------------------------------------------------------------------ //
//Date    | Mod_ID | Developer  | Case and Description                                 //
//--------|--------|------------|----------------------------------------------------- //
//        |        |            |                                                      //
//------------------------------------------------------------------------------------ //

//h-spec
ctl-opt Copyright('Programmers.io @ All rights reserved.| Ashwani Kumar');
ctl-opt Option(*NoDebugIo:*SrcStmt:*NoUnRef)
        DftActGrp(*No)
        ActGrp(*Caller);

//d-spec
//Main program prototypes
dcl-pi MainPgm  extpgm('CUGETLCKR');
end-pi;

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
End-Ds;

//Constants
dcl-c SQL_ALL_OK        '00000';
dcl-c SQL_NO_MORE_RCD   '02000';
dcl-c Quote             x'7D';

//-------------------------------------------------------------------------------------//
//Mainline Programming                                                                 //
//-------------------------------------------------------------------------------------//

//Set processing options to be used for SQL Statements in program.
Exec Sql
  Set Option Commit    = *None,
             Naming    = *Sys,
             UsrPrf    = *User,
             DynUsrPrf = *User,
             CloSqlCsr = *EndMod;
*inLR = *On;

in AICTLDTA;

//Get list of all jobs which are locking.
@pr_GetJobLckLst();

//End of Program!
Return;

//-------------------------------------------------------------------------------------//
//Compile Reference File - REF.                                                        //
//-------------------------------------------------------------------------------------//
Dcl-Proc  @pr_GetJobLckLst;
   Dcl-PI @pr_GetJobLckLst;
   End-PI @pr_GetJobLckLst;

   //Declare cursor C01.
   Exec Sql
     DECLARE C01 CURSOR FOR
     SELECT  DISTINCT(JOB_NAME)
     FROM    QSYS2.OBJECT_LOCK_INFO
     WHERE   SYSTEM_OBJECT_SCHEMA = 'QSYS'
       AND  (SYSTEM_OBJECT_NAME   = :g_DtaLib
        OR   SYSTEM_OBJECT_NAME   = :g_ObjLib
        OR   SYSTEM_OBJECT_NAME   = :g_SrcLib)
       AND   OBJECT_TYPE          = '*LIB'
       AND   STATUS               = 'HELD'
       FOR   read only;

   //Open Cursor 'C01'.
   Exec Sql
     Open C01;

   //Fetch Cursor 'C01'.
   Exec Sql
     Fetch next from C01 into :g_C01DS;

   //Do until all rows of cursor C01 are processed.
   DoW SQLSTATE = SQL_ALL_OK;

       //End Job Detail.
       @pr_EndJob(g_JOBDTL);

       //Fetch first row of cursor C01.
       Exec Sql
         Fetch C01 into :g_C01Ds;

   EndDo;

   //Close Cursor 'C01'.
   Exec Sql
     Close C01;

End-Proc  @pr_GetJobLckLst;

//-----------------------------
//Procedure to End Active Jobs.
//-----------------------------
Dcl-PROC  @pr_EndJob;
   Dcl-PI @pr_EndJob;
      Dcl-Parm p_JobDtl like(g_JOBDTL) Const;
   End-PI @pr_EndJob;

   //Declare local variable.
   Dcl-S l_CmdString char(500);

   //Prepare string for CL command 'ENDJOB'.
   l_CmdString = 'ENDJOB JOB('
               + %trim(p_JobDtl)
               + ') OPTION(*IMMED) DELAY(1) LOGLMT(0)';

   //Call QCMDEXC.
   Exec Sql
         CALL QSYS2.QCMDEXC(:l_CmdString);

   //Check Error.
   If SQLSTATE <> SQL_ALL_OK;
      //Log Error
   EndIf;

   Return;

End-PROC  @pr_EndJob;
