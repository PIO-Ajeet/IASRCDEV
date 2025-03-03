**free
      //%METADATA                                                      *
      // %TEXT CHECKING FOR LIBRARY LIST PRESENT IN REPO               *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------ //
//Created By    : Programmers.io @ 2023                                                //
//Creation Date : 2023/02/27                                                           //
//Developer     : Karan Messi                                                          //
//Description   : To check the library list present in the repositary and finding      //
//                correct library from IAIANPLIB and updating the IAROBJLIB field      //
//                of file IAALLREFPF.                                                  //
//PROCEDURE LOG :                                                                      //
//------------------------------------------------------------------------------------ //
//Procedure Name           | Procedure Description                                     //
//-------------------------|---------------------------------------------------------- //
//                         |                                                           //
//------------------------------------------------------------------------------------ //
//MODIFICATION LOG:                                                                    //
//------------------------------------------------------------------------------------ //
//Date    | Mod_ID | Developer  | Case and Description                                 //
//--------|--------|------------|----------------------------------------------------- //
//23/03/14| 0001   | Stephen    | Handled Null Values Issues-While Updating            //
//        |        |            | IAALLREFPF Table.                                    //
//23/10/13| 0002   | Rituraj    | Changed file name AIEXCTIME to IAEXCTIME [Task #248] //
//05/07/24| 0003   | Akhil K.   | Renamed AIERRBND, AIDERRLOG and AISQLDIAGNOSTIC with //
//        |        |            | IA*                                                  //
//20/08/24| 0004   | Sabarish   | IFS Member Parsing Feature [Task #833]               //
//------------------------------------------------------------------------------------ //
ctl-opt copyright('Programmers.io © 2023');
ctl-opt option(*NoDebugIO : *SrcStmt : *noUnRef);
ctl-opt dftactgrp(*NO);
ctl-opt bndDir('IAERRBND');                                                              //0003

//--------------------------------------------------------------------------------------- //
//Standalone Variables                                                                    //
//--------------------------------------------------------------------------------------- //
dcl-s RepoLib            char(500)       inz;
dcl-s NbrOfRowsLibLst    uns(5)          inz(%elem(LibraryList));
dcl-s NbrOfRowsIaall     uns(5)          inz(%elem(Iaallrefpf_ds));
dcl-s Sqlstmte           char(5000)      inz;
dcl-s RowFound           Ind             inz('0');
dcl-s RowsFetched        uns(5);
dcl-s LibraryCount       uns(5);
dcl-s Index              uns(3);
dcl-s uppgm_name         char(10)        inz;
dcl-s uplib_name         char(10)        inz;
dcl-s upsrc_name         char(10)        inz;
dcl-s uptimestamp        Timestamp;
dcl-s RefObjLibnm        char(11)        inz;                                            //0001

//--------------------------------------------------------------------------------------- //
//Constant Variables                                                                      //
//--------------------------------------------------------------------------------------- //
dcl-c TRUE            '1';
dcl-c FALSE           '0';

//--------------------------------------------------------------------------------------- //
//Data Structure Definations                                                              //
//--------------------------------------------------------------------------------------- //

//Data structure for library list present in the repository
dcl-ds LibraryList Dim(300) qualified;
 LibraryLst char(10);
end-ds;

//Data structure for external file IAALLREFPF
dcl-ds Iaallrefpf_ds  EXTNAME('IAALLREFPF') DIM(99) qualified;
end-ds;

dcl-ds Iaallrefpf_ds1 likeDs(Iaallrefpf_ds);

//--------------------------------------------------------------------------------------- //
//Prototype Definations                                                                   //
//--------------------------------------------------------------------------------------- //

dcl-pr IAEXCTIMR extpgm('IAEXCTIMR');                                                    //0002
    *n Char(10) Const;
    *n Char(10);
    *n Char(10);
    *n Char(10) Const;
    *n Char(10);
    *n Char(10);
    *n Char(10);
    *n Char(100) Const;                                                                  //0004
    *n Char(10) Const;
    *n Timestamp;
    *n Char(6) Const;
end-pr;

//--------------------------------------------------------------------------------------- //
//Entry Parameters                                                                        //
//--------------------------------------------------------------------------------------- //

dcl-pi IAUPDRFLIB extpgm('IAUPDRFLIB');
  xref  char(10);
end-pi;

//--------------------------------------------------------------------------------------- //
//Copy Book Defination                                                                    //
//--------------------------------------------------------------------------------------- //

/copy 'QCPYSRC/iaderrlog.rpgleinc'

//--------------------------------------------------------------------------------------- //
//Main Functions                                                                          //
//--------------------------------------------------------------------------------------- //

exec sql
set option commit = *none,
           naming = *sys,
           usrprf = *user,
           dynusrprf = *user,
           closqlcsr = *endmod;

//--------------------------------------------------------------------------------------- //
//Log process start time                                                                  //
//--------------------------------------------------------------------------------------- //

Eval-corr uDpsds = wkuDpsds;

uptimeStamp = %Timestamp();

//Call IAEXCTIMR to insert the start time of the process in the IAEXCTIME file
CallP IAEXCTIMR('BLDMTADTA' :udpsds.ProcNme : udpsds.Lib  :                              //0002
                '*PGM'      :upsrc_name     : uppgm_name  :
                 //0004 uplib_name :' '            : uptimeStamp : 'INSERT');
                 uplib_name :' ':' '        : uptimeStamp : 'INSERT');                   //0004

//--------------------------------------------------------------------------------------- //
//Cursor Definations                                                                      //
//--------------------------------------------------------------------------------------- //

//Declaring cursor to retrieve the library names from the repository
exec sql
 declare repo_lib cursor for
  select library_Name
    from IAINPLIB
   where xrefnam = :Xref;

//Declare a cursor on the basis of prepared statement
exec sql
 declare ObjectLibList cursor for stmt_for_iaallrefpf_file;

//--------------------------------------------------------------------------------------- //
//Main Logic                                                                              //
//--------------------------------------------------------------------------------------- //

//Open the Cursor
exec sql
    open repo_lib;

if sqlCode = CSR_OPN_COD;
  exec sql close repo_lib;
  exec sql open  repo_lib;
endif;

if sqlCode < successCode;
  uDpsds.wkQuery_Name = 'Open_Repo_lib';
  IaSqlDiagnostic(uDpsds);                                                               //0003
endif;

//Fetching all the library name present in the repository
exec sql
   fetch repo_lib for :NbrOfRowsLibLst ROWS INTO :LibraryList;

if sqlCode < successCode;
  uDpsds.wkQuery_Name = 'Fetch_Repo_Lib';
  IaSqlDiagnostic(uDpsds);                                                               //0003
endif;

//Count of the libraries which has been retrieved
exec sql
     GET DIAGNOSTICS :Librarycount = ROW_COUNT;

if sqlCode < successCode;
  uDpsds.wkQuery_Name = 'Get_Diagnostics_Repo_Lib';
  IaSqlDiagnostic(uDpsds);                                                               //0003
endif;

//Close the cursor
exec sql
   close repo_lib;

if sqlCode < successCode;
  uDpsds.wkQuery_Name = 'Close_Repo_Lib';
  IaSqlDiagnostic(uDpsds);                                                               //0003
endif;

//Separting all the libraries into a variable
for Index = 1 to LibraryCount;
  if RepoLib <> *blanks;
    RepoLib = %trim(RepoLib) + ','  + '''' + %trim(LibraryList(Index)) + '''';
  else;
    RepoLib = '(' + '''' + %trim(LibraryList(Index)) + '''';
  endif;
endfor;

If RepoLib <> *blanks;
   RepoLib = %trim(RepoLib) + ')';
Endif;

//Declare a string for creating a statement which will be used while declaring a cursor
Sqlstmte = 'select * from IAALLREFPF '                 +
            'where iarobjlib = ' + ''' '''             +
              ' or iarobjlib = ' + '''*LIBL'''         +
              ' or iarobjlib = ' + '''QTEMP'''         +
              ' or iarobjlib = ' + '''*CURLIB'''       +
              ' or substr(iarobjlib,1,1) = ' + '''&''' +
              ' or iarobjlib NOT IN ' + RepoLib;

//Prepare a statement for the above delared string
exec sql
 prepare Stmt_for_iaallrefpf_file from :Sqlstmte;

if sqlCode < successCode;
  uDpsds.wkQuery_Name = 'Prepare_stmt_for_iaallrefpf_file';
  IaSqlDiagnostic(uDpsds);                                                               //0003
endif;

//Open the cursor
exec sql
    open ObjectLibList;

if sqlCode = CSR_OPN_COD;
  exec sql close ObjectLibList;
  exec sql open  ObjectLibList;
endif;

if sqlCode < successCode;
  uDpsds.wkQuery_Name = 'Open_ObjectLibList';
  IaSqlDiagnostic(uDpsds);                                                               //0003
endif;

//Fetch beginning records from ObjectLibList Cursor
Rowfound = FetchRecordObjectLibListCursor();

//Updating the referenced object library field (IAROBJLIB) of file IAALLREFPF
clear Index;
dow Rowfound;

  for Index = 1 to RowsFetched;

    Iaallrefpf_ds1 = Iaallrefpf_ds(Index);
                                                                                         //0001
    Clear RefObjLibnm;                                                                   //0001
    exec sql                                                                             //0001
      select case when odlbnm = ' ' then '*LIBL'                                         //0001
                  else odlbnm end                                                        //0001
        into :RefObjLibnm                                                                //0001
        from IDSPOBJD                                                                    //0001
        join IAINPLIB on                                                                 //0001
             xlibnam = odlbnm                                                            //0001
       where xrefnam = :xref and                                                         //0001
             odobnm  = :Iaallrefpf_ds1.iarobjnam and                                     //0001
             odobtp  = :Iaallrefpf_ds1.iarobjtyp                                         //0001
       order by xlibseq                                                                  //0001
       limit 1;                                                                          //0001
                                                                                         //0001
    If Sqlcode = 0;                                                                      //0001
                                                                                         //0001
    exec sql
      update IAALLREFPF set IAROBJLIB = :RefObjLibnm                                     //0001
        where iaoobjlib = :Iaallrefpf_ds1.iaoobjlib and
              iaoobjnam = :Iaallrefpf_ds1.iaoobjnam and
              iaoobjtyp = :Iaallrefpf_ds1.iaoobjtyp and
              iaoobjatr = :Iaallrefpf_ds1.iaoobjatr and
              iarobjnam = :Iaallrefpf_ds1.iarobjnam and
              iarobjtyp = :Iaallrefpf_ds1.iarobjtyp;

    if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Update_IAALLREFPF';
      IaSqlDiagnostic(uDpsds);                                                           //0003
    endif;

    endif;                                                                               //0001
                                                                                         //0001
  endfor;

  //Come out of the loop if reaches end of file.
  if RowsFetched < NbrOfRowsIaall;
    leave;
  endif;

  //Fetch next records from ObjectLibList Cursor
  Rowfound = FetchRecordObjectLibListCursor();

enddo;

//Close the cursor
exec sql
   close ObjectLibList;

if sqlCode < successCode;
  uDpsds.wkQuery_Name = 'Close_ObjectLibList';
  IaSqlDiagnostic(uDpsds);                                                               //0003
endif;

//------------------------------------------------------------------------------------ //
//Log pocess end time                                                                  //
//------------------------------------------------------------------------------------ //

UPTimeStamp = %Timestamp();

//Call IAEXCTIMR to update the IAEXCTIME file to log the process time taken to complete.
CallP IAEXCTIMR('BLDMTADTA' :udpsds.ProcNme : udpsds.Lib  :                              //0002
                '*PGM'      :upsrc_name     : uppgm_name  :
                 //0004 uplib_name : ' '           : uptimeStamp :
                 uplib_name : ' ':' '           : uptimeStamp :                          //0004
                'UPDATE');

*inlr  = *on;

//------------------------------------------------------------------------------------ //
//Procedure: Fetch records from the cursor ObjectLibList                               //
//------------------------------------------------------------------------------------ //
dcl-proc FetchRecordObjectLibListCursor;

  dcl-pi FetchRecordObjectLibListCursor ind end-pi ;

  //Declare variables with there initialization values
  dcl-s  RcdFound ind inz('0');
  dcl-s  w_RowFetched like(RowsFetched) ;

  //Clear the variables before fetching the records
  RowsFetched = *zeros;
  clear Iaallrefpf_ds;
  clear Iaallrefpf_ds1;

  //Fetch the records from ObjectLibList created for IAALLREFPF file
  exec sql
     fetch ObjectLibList for :NbrOfRowsIaall ROWS into :Iaallrefpf_ds;

  if sqlCode < successCode;
    uDpsds.wkQuery_Name = 'Fetch_ObjectLibList';
    IaSqlDiagnostic(uDpsds);                                                             //0003
  endif;

  if sqlcode = successCode;
    exec sql get diagnostics :w_RowFetched = ROW_COUNT;
    RowsFetched  = w_RowFetched;
  endif;

  //If record found then initialize the variable with TRUE as 1 and if the records is
  //not found then intialize the variable with TRUE as 0 and return the value

  if RowsFetched > 0;
     RcdFound = TRUE;
  elseif sqlcode < successCode ;
     RcdFound = FALSE;
  endif;

  return RcdFound;

end-proc;
