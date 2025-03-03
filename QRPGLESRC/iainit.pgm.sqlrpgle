**free
      //%METADATA                                                      *
      // %TEXT IA Initialization Process                               *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------- //
//Created By   : Programmers.io @ 2020                                                  //
//Created Date : 2020/01/01                                                             //
//Developer    : Programmers.io                                                         //
//Description  : This program initializes all setup activity for IA Product.            //
//                                                                                      //
//Procedure Log:                                                                        //
//------------------------------------------------------------------------------------- //
//Procedure Name           | Procedure Description                                      //
//-------------------------|----------------------------------------------------------- //
//                         |                                                            //
//------------------------------------------------------------------------------------- //
//                                                                                      //
//Modification Log:                                                                     //
//------------------------------------------------------------------------------------- //
//Date    | Developer        | Case and Description                                     //
//--------| -----------------|--------------------------------------------------------- //
//23/01/27| Manesh K         | Replace IAMENUR with BLDMTADTA (Mod:0001)                //
//23/02/20| Vipul P          | Removed The Progress Bar Process(Mod:0002)               //
//23/09/13| Vamsi Krishna2   | Implement call of IAOBJECTR program(Mod:0003)(Task#213)  //
//23/09/28| Sonali Sulake    | Checking IDSPOBJD Option From Data Area(Mod:0004)        //
//09/11/23| Abhijith Ravndran| Refresh Metadata process (Mod:0005 - Task#322)           //
//18/12/23| Akhil Kallur     | To call IAREFOBJC with a new parameter. The further      //
//        |                  | Refresh process will happen if that parameter is 'Y'.    //
//        |                  | (Mod:0006 - Task#463)                                    //
//29/12/23| Venkatesh        | Added Repo name as parm to IACMDREFD call                //
//        |   Battula        |     [Mod#: 0007 - Task#: 430]                            //
//23/12/07| Roshan Wankar    | Implement call of IAMEMBERR program(Mod:0008)(Task#442)  //
//08/01/23| Tanisha K        | Remove the IDSPFDDISP file and its usages from product   //
//        |                  | (Mod:0009 - Task#:505)                                   //
//24/01/29| Himanshu Gahtori | Object Exclusion processing(INIT)  (MOD:0010)(Task#498)  //
//02/02/24| Naresh S         | Move Backup and Restore process to new programs.         //
//        |                  | (Mod:0011 - Task#:528,553)                               //
//23/12/26| Saikiran         | Added a condition to include member field in Exclusion   //
//        |                  | logic and changed IAXSRCPF field names according to the  //
//        |                  | new table (Mod:0012 - Task#500)                          //
//02/04/24| Mahima T         | Alter query for resequencing the cursor after CPYF comman//
//        |                  | command to avoid data duplicacy issue in case of exclusio//
//        |                  | n files IAXSRCPF and AIEXCOBJS(Mod: 0013 )               //
//24/02/14| Himanshu Gahtori | Replaced call to IAEXCOBJR with IAREFDLTR since later is //
//        |                  | now handling the INIT exclusion process also.            //
//        |                  | (MOD:0014)(Task#535)                                     //
//23/10/13| Rituraj          | Changed file name AIEXCTIME to IAEXCTIME (Mod:0015)      //
//        |                  | [Task #248]                                              //
//23/10/04| Khushi W         | Rename AIEXCOBJS to IAEXCOBJS (Mod:0016) [Task #252]     //
//02/07/24| Sribalaji        | Remove the hardcoded #IADTA lib from all                 //
//        |                  | sources (Mod: 0017)  [Task# 754]                         //
//04/07/24| Akhil K.         | Renamed AIERRBND, AICERRLOG, AIDERRLOG and AISQLDIAGNOSTIC//
//        |                  | with IA* (Mod: 0018) [Task# 261]                         //
//18/09/24| Bpal             | Reset the variable UWERROR before calling the restoration//
//        |                  | program  (Mod: 0019) [Task# 841]                         //
//08/14/24| Sasikumar R      | To add repo name as parameter to call IAMEMBERR as part  //
//        |                  | of IFS member parsing (Mod: 0020) [Task# 833]            //
//------------------------------------------------------------------------------------- //
ctl-opt CopyRight('Copyright @ Programmers.io © 2022 ');
ctl-opt Option(*NoDebugIo:*SrcStmt:*NoUnref);
ctl-opt BndDir('IABNDDIR' : 'IAERRBND');                                                 //0018

//------------------------------------------------------------------------------------- //
//Main Program Prototype interface
//------------------------------------------------------------------------------------- //
dcl-pi iainit extpgm('IAINIT');
   uwxref    char(10) options(*nopass);
   uwProg    char(74) options(*nopass);
   uwInItErr char(01) options(*nopass);
   uwRefresh char(01) options(*nopass);                                                  //0006
end-pi;

//------------------------------------------------------------------------------------- //
//CopyBook Declarations
//------------------------------------------------------------------------------------- //
/copy 'QMODSRC/iasrv01pr.rpgleinc'
/copy 'QCPYSRC/iaderrlog.rpgleinc'

//------------------------------------------------------------------------------------- //
//Prototype Declarations
//------------------------------------------------------------------------------------- //
dcl-pr WritePgmD extpgm('IAWRTPGMD');
end-pr;

dcl-pr Iaobjmbrs extpgm('IAOBJMBRS');
   *n char(10);
end-pr;

dcl-pr CommandRef extpgm('IACMDREFD');
   *n char(10);                                                                          //0007
end-pr;

dcl-pr ProcedureList extpgm('IAWRTMODI');
end-pr;

dcl-pr IAEXCTIMR extpgm('IAEXCTIMR');                                                    //0015
   *n Char(10) Const;
   *n Char(10);
   *n Char(10);
   *n Char(10) Const;
   *n Char(10);
   *n Char(10);
   *n Char(10);
   *n Char(100) Const;                                                                   //0020
   *n Char(10) Const;
   *n Timestamp;
   *n Char(6) Const;
end-pr;

dcl-pr IAOBJECTR extpgm('IAOBJECTR');                                                    //0003
end-pr;                                                                                  //0003
                                                                                         //0008
dcl-pr IAMEMBERR extpgm('IAMEMBERR');                                                    //0008
   uwxref    char(10);                                                                   //0020
end-pr;                                                                                  //0008

dcl-pr refreshMetaData  extpgm('IAREFOBJC');                                             //0004
   uwxref    char(10) options(*nopass);                                                  //0004
   uwRcdFnd  char(1)  options(*nopass);                                                  //0006
end-pr;                                                                                  //0004

dcl-pr IAREFDLTR Extpgm('IAREFDLTR');                                                    //0014
   *n   Char(7) Const;                                                                   //0014
   *n   Char(1) Const;                                                                   //0014
end-pr;                                                                                  //0014

dcl-pr backup_Files_DataAreas extpgm('IAINITBKP');                                       //0011
   uwxref    char(10) options(*nopass);                                                  //0011
   uwerror   char(1)  options(*nopass);                                                  //0011
end-pr;                                                                                  //0011

dcl-pr restore_Files_DataAreas extpgm('IAINITRST');                                      //0011
   uwxref    char(10) options(*nopass);                                                  //0011
   uwerror   char(1)  options(*nopass);                                                  //0011
end-pr;                                                                                  //0011
//------------------------------------------------------------------------------------- //
//Variable Declarations
//------------------------------------------------------------------------------------- //
dcl-s command         char(1000)   inz;
dcl-s uwerror         char(1)      inz;
dcl-s uwlib           char(10)     inz;
dcl-s uwname          char(10)     inz;
dcl-s uwbkname        char(10)     inz;
dcl-s uwaction        char(20)     inz;
dcl-s uwactdtl        char(50)     inz;
dcl-s data_library    varchar(10)  inz;
dcl-s uwcount         packed(4:0)  inz;
dcl-s uwcount1        packed(4:0)  inz;
dcl-s Ind_FirstTime   ind          inz;
dcl-s uppgm_name      char(10)     inz;
dcl-s uplib_name      char(10)     inz;
dcl-s upsrc_name      char(10)     inz;
dcl-s uptimestamp     Timestamp;
dcl-s Initdtra        char(7)      inz;                                                  //0004
dcl-s UwRcdFnd        Char(1)      inz;                                                  //0006
dcl-s w_maxSeq        packed(3:0)  inz;                                                  //0013
dcl-s w_SqlStmt       char(100)    inz;                                                  //0013

//------------------------------------------------------------------------------------- //
//Constant declarations
//------------------------------------------------------------------------------------- //

//------------------------------------------------------------------------------------- //
//DS Declarations
//------------------------------------------------------------------------------------- //
dcl-ds IaMetaInfo dtaara len(62);                                                        //0004
   up_mode char(7) pos(1);                                                               //0004
end-ds;                                                                                  //0004

dcl-ds UwSrcDtl ;                                                                        //0020
   in_srclib   Char(10) ;                                                                //0020
   in_srcspf   Char(10) ;                                                                //0020
   in_srcmbr   Char(10) ;                                                                //0020
   in_ifsloc   Char(100);                                                                //0020
   in_srcType  Char(10) ;                                                                //0020
   in_srcStat  Char(1)  ;                                                                //0020
end-ds;                                                                                  //0020
//------------------------------------------------------------------------------------- //
//Mainline Programming
//------------------------------------------------------------------------------------- //
exec sql
  set option commit    = *none,
             naming    = *sys,
             usrprf    = *user,
             dynusrprf = *user,
             closqlcsr = *endmod;

eval-corr uDpsds = wkuDpsds;

uptimeStamp = %Timestamp();
callP IAEXCTIMR('BLDMTADTA' : udpsds.ProcNme  : udpsds.Lib : '*PGM' :                    //0015
                upsrc_name  : uppgm_name      : uplib_name : ' ' :
                //0020 uptimeStamp : 'INSERT');
                ' ' : uptimeStamp : 'INSERT');                                           //0020

//Retrieve value from Data Area
In IaMetaInfo;                                                                           //0004
Initdtra = up_mode;                                                                      //0004

uwInItErr = 'N';                                                                         //0004
uwRcdFnd  = ' ';                                                                         //0006

//If it is Refresh process
If up_Mode = 'REFRESH';                                                                  //0004
   refreshMetaData(uwxref:uwRcdFnd);                                                     //0006
   uwRefresh = uwRcdFnd;                                                                 //0006
//Else, run the complete INIT process
Elseif up_Mode = 'INIT';                                                                 //0004
   builtMetaData();                                                                      //0004
endif;                                                                                   //0004

//uwrcdfnd will be blank in case of INIT. 'Y' in case of any objects or members with    //0006
//status 'A' or 'M', else it will have 'N'                                              //0006
if uwInItErr = 'N' and uwRcdFnd <> 'N';                                                  //0006

   //Populate the object details to IAOBJECT from IDSPOBJD                              //0003
   iaobjectr();                                                                          //0003
                                                                                         //0003
   //Populate the member detail in table IDSPFDMBRL
   if up_Mode = 'INIT';                                                                  //0004
      populateSourceMemberDetail();
   endif;                                                                                //0004

   // Populate the object details to IAMEMBER from IDSPFDMBRL                            //0008
   //iamemberr();                                                                 //0020 //0008
   iamemberr(uwxref);                                                                    //0020
                                                                                         //0008
   //Retrieve Command Reference Description
   CommandRef(uwxref);                                                                   //0007

   //Retrieve program and service-program information
   WritePgmD();

   //Retrieve best possible match of member and object
   Iaobjmbrs(uwxref);

   //Retrieve Procedure List
   ProcedureList();

   //Log Status in History log file
   uwaction = 'INITIALIZATION PH-1';
   uwactdtl = 'INITIALIZATION PH-1 END';
   IREPHSTLOG(uwxref: uwaction: uwactdtl);

endif;                                                                                   //0004

UPTimeStamp = %Timestamp();
CallP IAEXCTIMR('BLDMTADTA': udpsds.ProcNme  : udpsds.Lib : '*PGM' :                     //0015
                upsrc_name : uppgm_name      : uplib_name : ' ' :
                                //0020 uptimeStamp : 'UPDATE');
                                ' ' : uptimeStamp : 'UPDATE');                           //0020
*inlr = *on;
return;

/copy 'QCPYSRC/iacerrlog.rpgleinc'

//------------------------------------------------------------------------------------- //
//Procedure builtMetaData: Built Metadata from INIT process
//------------------------------------------------------------------------------------- //
dcl-proc builtMetaData  ;                                                                //0004

  clear command;
  uwInItErr = 'N';
  Uwerror = ' ' ;                                                                        //0011

  //Check for Repository library existance.
  command = 'CHKOBJ OBJ(QSYS/' + %trim(uwxref) + ') OBJTYPE(*LIB)';
  runCommand(Command:Uwerror);

  if Uwerror = 'Y';                                                                      //0011
     uwInItErr = Uwerror;                                                                //0011
     return ;                                                                            //0011
  endIf;                                                                                 //0011

  //Take backup of files and data areas into backup library                             //0011
  clear uwerror;                                                                         //0019
  backup_Files_DataAreas(uwxref:uwerror) ;                                               //0011

  if Uwerror = 'Y';                                                                      //0011
     uwInItErr = Uwerror;                                                                //0011
     return ;                                                                            //0011
  endIf;                                                                                 //0011


 //Clear the Repository Library                                                         //0011
  clear command;
  command = 'CLRLIB LIB(' + %trim(uwxref) + ')';
  runCommand(Command:Uwerror);

  if Uwerror = 'Y';                                                                      //0011
     uwInItErr = Uwerror;                                                                //0011
     return ;                                                                            //0011
  endIf;                                                                                 //0011

  if uwInItErr = 'N';

     //Create files from #IADTA library using CRTDUPOBJ
     exec sql
       declare files cursor for
        select file_name, file_bkname
         // from #IADTA/iadupobj                                                         //0017
          from iadupobj                                                                  //0017
         where file_status = 'Y';

     exec sql open files;
     if sqlCode = CSR_OPN_COD;
        exec sql close files;
        exec sql open  files;
     endif;

     if sqlCode < successCode;
        uDpsds.wkQuery_Name = 'Open_Cursor_Files';
        IaSqlDiagnostic(uDpsds);                                                         //0018
     endif;

     exec sql fetch files into :uwname, :uwbkname;

     if sqlCode < successCode;
        uDpsds.wkQuery_Name = 'Fetch_1_Files';
        IaSqlDiagnostic(uDpsds);                                                         //0018
     endif;

     dow sqlCode = successCode;

        //Copy object from #IADTA To Repository Library
        clear command;
        command = 'CRTDUPOBJ OBJ(' + %trim(uwname) + ') +
                             FROMLIB(*LIBL) +
                             OBJTYPE(*FILE) +
                             TOLIB(' + %trim(uwxref) + ') +
                             DATA(*NO)';
        runCommand(Command:Uwerror);

        if Ind_FirstTime = *off;
           Ind_FirstTime = *on;
        endif;

        exec sql fetch files into :uwname, :uwbkname;

        if sqlCode < successCode;
           uDpsds.wkQuery_Name = 'Fetch_2_Files';
           IaSqlDiagnostic(uDpsds);                                                      //0018
           Leave;
        endif;

     enddo;

     exec sql close files;


     //Restore files and data areas from Backup Library to Repo Library                 //0011
     clear uwerror;                                                                      //0019
     restore_Files_DataAreas(uwxref:uwerror) ;                                           //0011

     if Uwerror = 'Y';                                                                   //0011
        uwInItErr = Uwerror;                                                             //0011
        return ;                                                                         //0011
     endIf;                                                                              //0011

     //Once the files IAXSRCPF and IAEXCOBJS are restored thru restore_Files_DataAreas  //0016
     //Restart Sequence number field to prevent program faliure in case if it is not    //0013
     //set properly for IAXSRCPF file.                                                  //0013
     exec sql                                                                            //0013
       select max(IASQNO) + 1 into :w_maxSeq  from IAXSRCPF;                             //0013
                                                                                         //0013
     w_SqlStmt = 'Alter table ' + %trim(uwxref) + '/iaxsrcpf ' +                         //0013
                 ' alter column IASQNO restart with ' + %char(w_maxSeq);                 //0013
                                                                                         //0013
     exec sql execute Immediate :w_SqlStmt;                                              //0013
                                                                                         //0013
     if sqlCode < successCode;                                                           //0013
        Eval-corr uDpsds = wkuDpsds;                                                     //0013
        uDpsds.wkQuery_Name ='Alter_IAXSRCPF';                                           //0013
        IaSqlDiagnostic(uDpsds);                                                         //0013 0018
     endif;                                                                              //0013
                                                                                         //0013
     //After CPYF command restarting Sequence number field as its a Primary key         //0013
     //to avoid data duplicay issue in IAEXCOBJS file                                   //0016
     clear w_maxSeq;                                                                     //0013
     exec sql                                                                            //0013
       select max(IASQNO) + 1 into :w_maxSeq  from iaexcobjs;                            //0016
                                                                                         //0013
     w_SqlStmt = 'Alter table ' + %trim(uwxref) + '/iaexcobjs' +                         //0016
                 ' alter column IASQNO restart with ' + %char(w_maxSeq);                 //0013
                                                                                         //0013
     exec sql execute Immediate :w_SqlStmt;                                              //0013
                                                                                         //0013
     if sqlCode < successCode;                                                           //0013
        Eval-corr uDpsds = wkuDpsds;                                                     //0013
        uDpsds.wkQuery_Name ='Alter_IAEXCOBJS';                                          //0016
        IaSqlDiagnostic(uDpsds);                                                         //0013 0018
     endif;                                                                              //0013

     //Log Status in History log file
     uwaction = 'INITIALIZATION PH-1';
     uwactdtl = 'INITIALIZATION PH-1 BEGIN';
     IREPHSTLOG(uwxref: uwaction: uwactdtl);

     //Read IAINPLIB file for libraries
     clear uwlib;
     exec sql
       declare library cursor for
        select XLIBNAM
         // from #IADTA/IAINPLIB                                                         //0017
          from IAINPLIB                                                                  //0017
         where XREFNAM = trim(:uwxref);

     exec sql open library;
     if sqlCode = CSR_OPN_COD;
        exec sql close library;
        exec sql open  library;
     endif;

     if sqlCode < successCode;
        uDpsds.wkQuery_Name = 'Open_Cursor_Library';
        IaSqlDiagnostic(uDpsds);                                                         //0018
     endif;

     if sqlCode = successCode;
        exec sql fetch library into :uwlib;

        if sqlCode < successCode;
           uDpsds.wkQuery_Name = 'Fetch_1_Library';
           IaSqlDiagnostic(uDpsds);                                                      //0018
        endif;

        //Process For Each library
        dow sqlCode = successCode;

           //Output file for DSPFD TYPE(*BASATR)
           clear command;
           command = 'DSPFD FILE('+%trim(uwlib)+'/*ALL) TYPE(*BASATR) ' +
                     'OUTPUT(*OUTFILE) OUTFILE(' + %trim(uwxref) + '/IDSPFDBASA)'+
                     ' OUTMBR(*FIRST *ADD)';
           RunCommand(Command:Uwerror);

           //Output file for DSPFD TYPE(*ACCPTH)
           clear command;
           command = 'DSPFD FILE('+ %trim(uwlib)+'/*ALL) TYPE(*ACCPTH) ' +
                     'OUTPUT(*OUTFILE) OUTFILE(' + %trim(uwxref) + '/IDSPFDKEYS)'+
                     ' OUTMBR(*FIRST *ADD)';
           RunCommand(Command:Uwerror);

           //Output file for DSPFD TYPE(*SELECT)
           clear command;
           command = 'DSPFD FILE('+%trim(uwlib)+'/*ALL) TYPE(*SELECT) ' +
                     'OUTPUT(*OUTFILE) OUTFILE(' + %trim(uwxref) + '/IDSPFDSLOM)'+
                     ' OUTMBR(*FIRST *ADD)';
           RunCommand(Command:Uwerror);

           //Output file for DSPFD TYPE(*SEQ)
           clear command;
           command = 'DSPFD FILE(' + %trim(uwlib) + '/*ALL) TYPE(*SEQ) '+
                     'OUTPUT(*OUTFILE) OUTFILE(' + %trim(uwxref) + '/IDSPFDSEQ)'+
                     ' OUTMBR(*FIRST *ADD)';
           RunCommand(Command:Uwerror);

           //Output file for DSPFD TYPE(*RCDFMT)
           clear command;
           command = 'DSPFD FILE('+%trim(uwlib)+'/*ALL) TYPE(*RCDFMT) '+
                     'OUTPUT(*OUTFILE) OUTFILE(' + %trim(uwxref) + '/IDSPFDRFMT)'+
                     ' OUTMBR(*FIRST *ADD)';
           RunCommand(Command:Uwerror);

           //Output file for DSPFD TYPE(*MBR)
           clear command;
           command = 'DSPFD FILE(' + %trim(uwlib) + '/*ALL) TYPE(*MBR) '+
                     'OUTPUT(*OUTFILE) OUTFILE(' + %trim(uwxref) + '/IDSPFDMBR)'+
                     ' OUTMBR(*FIRST *ADD)';
           RunCommand(Command:Uwerror);

           //Output file for DSPFD TYPE(*JOIN)
           clear command;
           command = 'DSPFD FILE('+%trim(uwlib)+'/*ALL) TYPE(*JOIN) '+
                     'OUTPUT(*OUTFILE) OUTFILE(' + %trim(uwxref) + '/IDSPFDJOIN)'+
                     ' OUTMBR(*FIRST *ADD)';
           RunCommand(Command:Uwerror);

           //Output file for DSPFD TYPE(*TRG)
           clear command;
           command = 'DSPFD FILE(' + %trim(uwlib)+ '/*ALL) TYPE(*TRG) '+
                     'OUTPUT(*OUTFILE) OUTFILE(' + %trim(uwxref) + '/IDSPFDTRG)'+
                     ' OUTMBR(*FIRST *ADD)';
           RunCommand(Command:Uwerror);

           //Output file for DSPFD TYPE(*CST)
           clear command;
           command = 'DSPFD FILE(' + %trim(uwlib)+ '/*ALL) TYPE(*CST) '+
                     'OUTPUT(*OUTFILE) OUTFILE(' + %trim(uwxref) + '/IDSPFDCST)'+
                     ' OUTMBR(*FIRST *ADD)';
           RunCommand(Command:Uwerror);

           //Output file for DSPDBR dependent files
           clear command;
           command = 'DSPDBR FILE(' + %trim(uwlib) + '/*ALL) ' +
                     'OUTPUT(*OUTFILE) OUTFILE(' + %trim(uwxref) + '/IADSPDBR)'+
                     ' OUTMBR(*FIRST *ADD)';
           RunCommand(Command:Uwerror);

           //Output file for DSPPGMREF(*ALL)
           clear command;
           command = 'DSPPGMREF PGM(' + %trim(uwlib) + '/*ALL) OUTPUT(*OUTFILE) '+
                     'OBJTYPE(*PGM *SQLPKG *SRVPGM *MODULE *QRYDFN) ' +
                     'OUTFILE(' + %trim(uwxref) + '/IAOBJREFPF) ' +
                     'OUTMBR(*FIRST *ADD)';
           RunCommand(Command:Uwerror);

           //Output file for DSPPGMREF(*PGM)
           clear command;
           command = 'DSPPGMREF PGM(' + %trim(uwlib) + '/*ALL) OUTPUT(*OUTFILE) '+
                     'OBJTYPE(*PGM) OUTFILE(' + %trim(uwxref) + '/IDSPPGMREF) ' +
                     'OUTMBR(*FIRST *ADD)';
           RunCommand(Command:Uwerror);

           //Output file for DSPPGMREF(*SQLPKG)
           clear command;
           command = 'DSPPGMREF PGM(' + %trim(uwlib) + '/*ALL) OUTPUT(*OUTFILE) '+
                     'OBJTYPE(*SQLPKG) OUTFILE(' + %trim(uwxref)+ '/IDSPSQLREF) '+
                     'OUTMBR(*FIRST *ADD)';
           RunCommand(Command:Uwerror);

           //Output file for DSPPGMREF(*SRVPGM)
           clear command;
           command = 'DSPPGMREF PGM(' + %trim(uwlib) + '/*ALL) OUTPUT(*OUTFILE) '+
                     'OBJTYPE(*SRVPGM) OUTFILE('+ %trim(uwxref)+ '/IDSPSRVREF) ' +
                     'OUTMBR(*FIRST *ADD)';
           RunCommand(Command:Uwerror);

           //Output file for DSPPGMREF(*MODULE)
           clear command;
           command = 'DSPPGMREF PGM(' + %trim(uwlib) + '/*ALL) OUTPUT(*OUTFILE) '+
                     'OBJTYPE(*MODULE) OUTFILE('+ %trim(uwxref)+ '/IDSPMODREF) ' +
                     'OUTMBR(*FIRST *ADD)';
           RunCommand(Command:Uwerror);

           //Output file for DSPPGMREF(*QRYDFN)
           clear command;
           command = 'DSPPGMREF PGM(' + %trim(uwlib) + '/*ALL) OUTPUT(*OUTFILE) '+
                     'OBJTYPE(*QRYDFN) OUTFILE('+ %trim(uwxref)+ '/IDSPQRYREF) ' +
                     'OUTMBR(*FIRST *ADD)';
           RunCommand(Command:Uwerror);

           //Output file for DSPOBJD
           clear command;
           command = 'DSPOBJD OBJ('+%trim(uwlib)+'/*ALL) OBJTYPE(*ALL) '+
                     'OUTPUT(*OUTFILE) OUTFILE(' + %trim(uwxref) + '/IDSPOBJD)'+
                     ' OUTMBR(*FIRST *ADD)';
           RunCommand(Command:Uwerror);

           //Output file for DSPFFD
           clear command;
           command = ' DSPFFD FILE('+%trim(uwlib)+ '/*ALL) OUTPUT(*OUTFILE)' +
                     ' OUTFILE('+ %trim(uwxref)+ '/IDSPFFD) OUTMBR(*FIRST *ADD)';
           RunCommand(Command:Uwerror);

           exec sql fetch library into :uwlib;

           if sqlCode < successCode;
              uDpsds.wkQuery_Name = 'Fetch_2_Library';
              IaSqlDiagnostic(uDpsds);                                                   //0018
              Leave;
           endif;
        enddo;

        exec sql close library;

     endif;

     exec sql
       insert into IASRCPF (LIBRARY_NAME,
                            SRCPF_NAME)
                    select ATLIB,
                           ATFILE
                      from IDSPFDBASA
                     where ATDTAT = 'S';

     if sqlCode < successCode;
        uDpsds.wkQuery_Name = 'Insert_IASRCPF';
        IaSqlDiagnostic(uDpsds);                                                         //0018
     endif;

     //Object Exclusion processing.                                                     //0010
     //O=delete excluded obj's entry from DSPFD/DSPFFD/DSPOBJD based outfiles           //0014
     IAREFDLTR('INIT' : 'O');                                                            //0014

  endif;                                                                                 //0004

end-proc;                                                                                //0004

//------------------------------------------------------------------------------------- //
//Procedure populateSourceMemberDetail : Populate IDSPFDMBRL file
//------------------------------------------------------------------------------------- //
dcl-proc populateSourceMemberDetail;

   dcl-s exclusion_Flag char(1);
   dcl-s src_file char(10);
   dcl-s src_lib  char(10);

   dcl-c recordnotfoundCode 100;

   exec sql
     declare SourceFileDetail cursor for
       select xsrcpf,xlibnam
         from IASRCPF;

   exec sql open SourceFileDetail;
   if sqlCode = CSR_OPN_COD;
      exec sql close SourceFileDetail;
      exec sql open  SourceFileDetail;
   endif;

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Open_Cursor_SourceFileDetail';
      IaSqlDiagnostic(uDpsds);                                                           //0018
   endif;

   if sqlCode = successCode;

      exec sql fetch from SourceFileDetail into :src_file,:src_lib;

      if sqlCode < successCode;
         uDpsds.wkQuery_Name = 'Fetch_1_SourceFileDetail';
         IaSqlDiagnostic(uDpsds);                                                        //0018
      endif;

      dow sqlCode = successCode;

         exclusion_Flag = '0';

         exec sql
            select '1' into :exclusion_Flag
              from IAXSRCPF
            where upper(iasrcfile) = :src_file                                           //0012
              and upper(iasrclib)  = :src_lib                                            //0012
              and iasrcmbr  = ' ' limit 1;                                               //0012

         if sqlCode = recordnotfoundCode;
            exec sql
               select '1' into :exclusion_Flag
                 from IAXSRCPF
               where iasrcfile = :src_file                                               //0012
                 and iasrclib  = ' '                                                     //0012
                 and iasrcmbr  = ' ' limit 1;                                            //0012
         endif;

         //Output file for DSPFD TYPE(*MBRLIST)
         if exclusion_Flag = '0';
            clear command;
            command = 'DSPFD FILE('+%trim(src_lib)+'/'+%trim(src_file)+') ' +
                      'TYPE(*MBRLIST) ' +
               'OUTPUT(*OUTFILE) OUTFILE(' + %trim(uwxref) + '/IDSPFDMBRL)'+
                      ' OUTMBR(*FIRST *ADD)';
            runCommand(Command:Uwerror);
         endif;

         exec sql fetch from SourceFileDetail into :src_file,:src_lib;

         if sqlCode < successCode;
            uDpsds.wkQuery_Name = 'Fetch_2_SourceFileDetail';
            IaSqlDiagnostic(uDpsds);                                                     //0018
            leave;
         endif;

      enddo;

      exec sql close SourceFileDetail;

   endif;

end-proc;
