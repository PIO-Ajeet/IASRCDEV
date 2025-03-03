**free
      //%METADATA                                                      *
      // %TEXT CU Generate utility main control file.                  *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------ //
//CREATED BY :   Programmers.io @ 2022                                                 //
//CREATE DATE:   2022/01/03                                                            //
//DEVELOPER  :   Ashwani Kumar                                                         //
//DESCRIPTION:   This program allow user to add source and object library.             //
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
ctl-opt Copyright('Programmers.io @ 2022 | Ashwani Kumar');
ctl-opt Option(*NoDebugIo:*SrcStmt:*NoUnRef)
        DftActGrp(*No)
        ActGrp(*Caller);

//f-spec
//Compilation main control utility file.
dcl-f CUCTRLPF   Disk    Usage(*Output);

//Copy Books

//Main program prototypes
dcl-pi MainPgm  extpgm('GRNCNTRLR');
end-pi;

//Other data structure
dcl-ds g_C01DS;
   g_MLLIB      char(10);
   g_MLFILE     char(10);
   g_MLNAME     char(10);
   g_MLSEU2     char(10);
   g_ODLBNM     char(10);
   g_ODOBNM     char(10);
   g_ODOBTP     char(08);
end-ds;

//Constants
dcl-c SQL_ALL_OK        '00000';
dcl-c SQL_NO_MORE_RCD   '02000';

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

//Declare cursor C01.
Exec Sql
  DECLARE C01 CURSOR FOR
   SELECT ifnull( A.MLLIB ,' '),
          ifnull( A.MLFILE,' '),
          ifnull( A.MLNAME,' '),
          ifnull( A.MLSEU2,' '),
          ifnull( B.ODLBNM,' '),
          ifnull( B.ODOBNM,' '),
          ifnull( B.ODOBTP,' ')
     FROM SRCLIST A FULL JOIN OBJLIST B
       ON A.MLNAME = B.ODOBNM;

//Open cursor C01.
Exec Sql
  OPEN C01;

//Fetch cursor C01.
Exec Sql
  FETCH C01 INTO :g_C01DS;

//Do while SQLSTATE is successful
DoW SQLSTATE = SQL_ALL_OK;

    //Populate control file fields
    CUSEQNBR += 1         ;
    CUSRCLIB  = g_MLLIB   ;
    CUSRCFLE  = g_MLFILE  ;
    CUSRCMBR  = g_MLNAME  ;
    CUSRCTYP  = g_MLSEU2  ;
    CUOBJLIB  = g_ODLBNM  ;
    CUOBJNAM  = g_ODOBNM  ;
    CUOBJTYP  = g_ODOBTP  ;
    CUGENSCT  = *Blanks   ;

    //Write main utility control file.
    Write CUCTRLPFR;

    //Fetch cursor C01.
    Exec Sql
      FETCH C01 INTO :g_C01DS;
EndDo;

//End of Program!
Return;
