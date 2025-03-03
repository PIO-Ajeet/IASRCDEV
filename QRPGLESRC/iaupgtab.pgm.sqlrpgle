**free
      //%METADATA                                                      *
      // %TEXT Upgrades IA tables if version is upgraded               *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------- //
//Created By  :  Programmers.io @ 2024                                                  //
//Created Date:  11-Jan-2024                                                            //
//Developer   :  Venkatesh Battula                                                      //
//Description :  Upgrades IA tables if version is upgraded                              //
//Task#       :  531                                                                    //
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
//06/06/24| 0001   | Saumya     | Rename AIEXCTIMR to IAEXCTIMR [Task #262]             //
//05/07/24| 0002   | Akhil K.   | Renamed AIERRBND, AICERRLOG, AIDERRLOG and AISQLDIAGNO//
//        |        |            | STIC with IA*                                         //
//29/07/24| 0003   |Kaushal Kum.| Remove the hardcoded library  [Task#824]              //
//20/08/24| 0004   | Sabarish   | IFS Member Parsing Feature                            //
//------------------------------------------------------------------------------------- //
ctl-opt Copyright('Programmers.io Â© 2024');
ctl-opt option(*NoDebugIO : *SrcStmt : *noUnRef);
ctl-opt dftactgrp(*No);
ctl-opt bndDir('IAERRBND');                                                              //0002

//------------------------------------------------------------------------------------- //
//Variable Declaration
//------------------------------------------------------------------------------------- //
dcl-s uptimestamp     Timestamp;
dcl-s uppgm_name      char(10)   inz;
dcl-s uplib_name      char(10)   inz;
dcl-s upsrc_name      char(10)   inz;
dcl-s wExtVersion     char(10)   inz;
dcl-s uwerror         char(1)    inz;
dcl-s wFile           char(10)   inz;
dcl-s uwLib           char(10)   inz;                                                    //0003
dcl-s command         char(1000) inz;

dcl-s noOfRows        uns(5);
dcl-s noOfFiles       uns(5);
dcl-s ariFilenames    uns(5);

//Data structure for files to upgrade
dcl-ds arrFilenames   Dim(300) qualified;
   filetoUpgrade      char(10);
   fileNewChange      char(1);
end-ds;

//------------------------------------------------------------------------------------- //
//Prototype Declaration
//------------------------------------------------------------------------------------- //
dcl-pr IAEXCTIMR extpgm('IAEXCTIMR');                                                    //0001
   *n Char(10) Const;
   *n Char(10);
   *n Char(10);
   *n Char(10) Const;
   *n Char(10);
   *n Char(10);
   *n Char(10);
   *n Char(100) Const;                                                                   //0004
   *n Char(10) Const;
   *n Timestamp;
   *n Char(6) Const;
end-pr;

dcl-pr Runcommand extpgm('QCMDEXC');
   Command char(1000) options(*varsize) const;
   Commandlen packed(15:5) const;
end-pr;

//------------------------------------------------------------------------------------- //
//Copybook Declaration
//------------------------------------------------------------------------------------- //
/copy 'QCPYSRC/iaderrlog.rpgleinc'

//------------------------------------------------------------------------------------- //
//Entry Parameter
//------------------------------------------------------------------------------------- //
dcl-pi IAUPGTAB extpgm('IAUPGTAB');
   xref char(10) Const;
end-pi;

//------------------------------------------------------------------------------------ //
//Set options
//------------------------------------------------------------------------------------ //
Exec sql
  set option Commit = *None,
             Naming = *Sys,
             DynUsrPrf = *User,
             CloSqlCsr = *EndMod;

//------------------------------------------------------------------------------------- //
//Main logic
//------------------------------------------------------------------------------------- //
Eval-corr uDpsds = wkuDpsds;

//Insert process start time
uptimeStamp = %Timestamp();
CallP IAEXCTIMR('BLDMTADTA' :udpsds.ProcNme : udpsds.Lib : '*PGM' :                      //0001
   // 0004 upsrc_name : uppgm_name : uplib_name : ' ' : uptimeStamp : 'INSERT');
   upsrc_name : uppgm_name : uplib_name : ' ' : ' ' : uptimeStamp : 'INSERT');           //0004

//Check for files needed to upgrade and upgrade them
exsr upgradeFiles;

//Update process end time
UPTimeStamp = %Timestamp();
CallP IAEXCTIMR('BLDMTADTA' :udpsds.ProcNme : udpsds.Lib : '*PGM' :                      //0001
   //0004 upsrc_name : uppgm_name : uplib_name : ' ' : uptimeStamp : 'UPDATE');
   upsrc_name : uppgm_name : uplib_name : ' ' : ' ' : uptimeStamp : 'UPDATE');           //0004

*Inlr = *On;

/copy 'QCPYSRC/iacerrlog.rpgleinc'

//------------------------------------------------------------------------------------- //
//upgradeFiles - Upgrade files
//------------------------------------------------------------------------------------- //
begsr upgradeFiles;

   //Get the list of files
   exsr getFiles;

   //Process all files for backup and restore
   ariFilenames = 1;
   dow ariFilenames <= noOfFiles;

      wFile = arrFilenames(ariFilenames).filetoUpgrade;

      //Process backup if the file is not new ('C')
      if arrFilenames(ariFilenames).fileNewChange = 'C';
         exsr backupFile;
      endIf;

      exsr copyNewVersionFile;

      //Process restore if the file is not new ('C')
      if arrFilenames(ariFilenames).fileNewChange = 'C';
         exsr restoreFile;
      endIf;

      ariFilenames += 1;

   enddo;

endsr;

//------------------------------------------------------------------------------------- //
//backupFile - Backup existing version file
//------------------------------------------------------------------------------------- //
begsr backupFile;

  clear command;
  command = 'CPYF FROMFILE(' + %Trim(xref) + '/' + wFile + ')' +
                ' TOFILE(QTEMP/' + wFile + ')' +
                ' MBROPT(*REPLACE) CRTFILE(*YES)';
  monitor;
     Runcommand(Command :%Len(%trimr(Command)));
  on-error;

     uwerror = 'Y';
     //Save in Error log file AIERRLOGP
     udpsds.EXCPTTYP       = 'CPY';
     udpsds.EXCPTNBR       = 'ERR';
     udpsds.RTVEXCPTDT     = 'Error while backing up existing version file ' + wFile;
     IaPssrErrorLog(uDpsds);                                                             //0002

  endmon;

endsr;

//------------------------------------------------------------------------------------- //
//copyNewVersionFile - Copy new version file
//------------------------------------------------------------------------------------- //
begsr copyNewVersionFile;

   if arrFilenames(ariFilenames).fileNewChange = 'C';

      //Delete existing file from Repo
      clear command;
      command = 'DLTF FILE(' + %trim(xref) +'/' + %trim(wFile) + ')';

      monitor;
         Runcommand(Command :%Len(%trimr(Command)));
      on-error;

         uwerror = 'Y';
         //Save in Error log file AIERRLOGP
         udpsds.EXCPTTYP       = 'CPY';
         udpsds.EXCPTNBR       = 'ERR';
         udpsds.RTVEXCPTDT     = 'Error while copying new version file ' + wFile;
         IaPssrErrorLog(uDpsds);                                                         //0002
      endmon;

   endif;

   If uDpsds.lib = '#IAOBJ';                                                             //0003
     uwLib = '#IADTA';                                                                   //0003
   Else;                                                                                 //0003
     uwLib = 'IADTADEV';                                                                 //0003
   Endif;                                                                                //0003

   //Copy new version file
   clear command;
   command = 'CRTDUPOBJ OBJ(' + %trim(wFile) + ')' +                                     //0003
             ' FROMLIB(' + %trim(uwLib) + ')' +                                          //0003
             ' OBJTYPE(*FILE)' +
             ' TOLIB(' + %trim(xref) + ')' +
             ' DATA(*NO)';
   monitor;
      Runcommand(Command :%Len(%trimr(Command)));
   on-error;

      uwerror = 'Y';
      //Save in Error log file AIERRLOGP
      udpsds.EXCPTTYP       = 'CPY';
      udpsds.EXCPTNBR       = 'ERR';
      udpsds.RTVEXCPTDT     = 'Error while copying new version file ' + wFile;
      IaPssrErrorLog(uDpsds);                                                            //0002

   endmon;

endsr;

//------------------------------------------------------------------------------------- //
//restoreFile - Restore data from existing version file
//------------------------------------------------------------------------------------- //
begsr restoreFile;

   clear command;
   command = 'CPYF FROMFILE(QTEMP/' + %trim(wFile) + ')' +
                ' TOFILE(' + %trim(xref) + '/' + wFile + ')' +
                ' MBROPT(*REPLACE) FMTOPT(*MAP *DROP) ';
   monitor;
      Runcommand(Command :%Len(%trimr(Command)));
   on-error;

      uwerror = 'Y';
      //Save in Error log file AIERRLOGP
      udpsds.EXCPTTYP       = 'CPY';
      udpsds.EXCPTNBR       = 'ERR';
      udpsds.RTVEXCPTDT     = 'Error while restoring new version file ' + wFile;
      IaPssrErrorLog(uDpsds);                                                            //0002

   endmon;

endsr;

//------------------------------------------------------------------------------------- //
//getFiles - get the list of files to upgrade
//------------------------------------------------------------------------------------- //
begsr getFiles;

   //Get existing version
   wExtVersion = *blanks;
   exec sql
     select xVersion into :wExtVersion
       from iAInpLib
      where xRefNam = :xRef
      limit 1;

   //Declaring cursor to retrieve the files need to upgrade
   exec sql
     declare filestoUpgrade cursor for
      select iAFlName, iAFlNewChg
        from iADupObj
       where iAFlSts = 'Y'
         and iAPrdVrsn > :wExtVersion;

   //Open the Cursor
   exec sql open filestoUpgrade;

   if sqlCode = CSR_OPN_COD;
      exec sql close filestoUpgrade;
      exec sql open  filestoUpgrade;
   endif;

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Open_filestoUpgrade';
      IaSqlDiagnostic(uDpsds);                                                           //0002
   endif;

   //Get the number of elements
   noOfRows = %elem(arrFilenames);

   //Fetching all files to upgrade
   exec sql
     fetch filestoUpgrade for :noOfRows Rows Into :arrFilenames;

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Fetch_filestoUpgrade';
      IaSqlDiagnostic(uDpsds);                                                           //0002
   endif;

   //No of files retrieved
   exec sql
     get diagnostics :noOfFiles = ROW_COUNT;

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Get_Diagnostics_filestoUpgrade';
      IaSqlDiagnostic(uDpsds);                                                           //0002
   endif;

   //Close the cursor
   exec sql close filestoUpgrade;

endsr;
