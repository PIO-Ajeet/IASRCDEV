**free
      //%METADATA                                                      *
      // %TEXT CU Send Break Message program                           *
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
ctl-opt Copyright('Programmers.io @ All rights reserved.');
ctl-opt Option(*NoDebugIo:*SrcStmt:*NoUnRef)
        DftActGrp(*No)
        ActGrp(*Caller);

//d-spec
//Main program prototypes
dcl-pi MainPgm  extpgm('CUGETLCKR');
end-pi;

//Data Area data structure declaration
Dcl-Ds AICTLDTA   dtaara len(200);
   Dcl-SubF g_SrcLib char(10) pos(01);
   Dcl-SubF g_DtaLib char(10) pos(11);
   Dcl-SubF g_ObjLib char(10) pos(21);
   Dcl-SubF g_ImgLib char(10) pos(31);
End-Ds;

//Other data structure declaration
Dcl-Ds g_C01Ds;
   Dcl-SubF g_JobDtl  char(28);
End-Ds;

//Array declaration
Dcl-S g_UsrLstArr Char(010) Dim(999);

//Standalone variables
Dcl-S g_MsgTxt Char(150) Inz('Metadata build process starts soon. Please sign off -
                               as this job will be ended.');

//Constants
dcl-c SQL_ALL_OK        '00000';
dcl-c SQL_NO_MORE_RCD   '02000';
dcl-c QUOTE             x'7D';
dcl-c SLASH             '/';

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

   //Declare local variables.
   Dcl-s l_Pos      Zoned(2:0) inz;
   Dcl-s l_User     Char(10)   inz;

   //Declare cursor 'C01'.
   Exec Sql
     DECLARE C01 CURSOR FOR
     SELECT  DISTINCT(JOB_NAME)
     FROM    QSYS2.OBJECT_LOCK_INFO
     WHERE   SYSTEM_OBJECT_SCHEMA = 'QSYS'
       AND  (SYSTEM_OBJECT_NAME   = :g_DtaLib
        OR   SYSTEM_OBJECT_NAME   = :g_ObjLib
        OR   SYSTEM_OBJECT_NAME   = :g_SrcLib
        OR   SYSTEM_OBJECT_NAME   = :g_ImgLib)
       AND   OBJECT_TYPE          = '*LIB'
       AND   STATUS               = 'HELD'
       FOR   read only;

   //Open Cursor 'C01'.
   Exec Sql
     Open C01;

   //Fetch first row of cursor 'C01'.
   Exec Sql
     Fetch next from C01 into :g_C01DS;

   //Do until all rows of cursor 'C01' are processed.
   DoW SQLSTATE = SQL_ALL_OK;

       //Get position of 1st slash.
       l_Pos  = %scan(SLASH:g_JobDtl:1);
       //Get position of 2nd slash.
       l_Pos  = %scan(SLASH:g_JobDtl:l_Pos+1);
       //Exract user remianing from job detail.
       l_User = %subst(g_JobDtl:l_Pos+1);

       //Send Break Message to Users.
       @pr_SndBrkMsg(l_User);

       //Fetch next row of cursor 'C01'.
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
Dcl-PROC  @pr_SndBrkMsg;
   Dcl-PI @pr_SndBrkMsg;
      Dcl-Parm p_User   char(10) Const;
   End-PI @pr_SndBrkMsg;

   //Declare local variable.
   Dcl-S l_CmdString char(500);

   If %lookup(p_User:g_UsrLstArr) = 0;

      //Add user profile name to array.
      g_UsrLstArr(%lookup(' ':g_UsrLstArr)) = %trim(p_User);
      //Prepare string for CL command 'SNDBRKMSG'.
      l_CmdString = 'SNDBRKMSG  MSG('     + %trim(g_MsgTxt)
                  + ') TOMSGQ('           + %trim(p_User)
                  + ')';

      //Call QCMDEXC.
      Exec Sql
        CALL QSYS2.QCMDEXC(:l_CmdString);

      //Check Error.
      If SQLSTATE <> SQL_ALL_OK;
         //Log Error
      EndIf;
   EndIf;

End-PROC  @pr_SndBrkMsg;
