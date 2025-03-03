**free
      //%METADATA                                                      *
      // %TEXT Driver Program To Parse Members                         *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------- //
//Created By    : Programmers.io @ 2020                                                 //
//Creation Date : 2022/01/13                                                            //
//Developer     : Bhoomish Atha                                                         //
//Description   : Program to Build CL,RPGLE,SQLRPGLE,DSS data and parse all sources     //
//                This populates the below details in IAQRPGSRC table                   //
//                1. SRCLIN_TYPE - (FFR - Fully Free, FFC - Free Column Spec            //
//                                 FX3 - RPG3 ,FX4 -RPG4)                               //
//                                 Commented line  - Added 4th Char C for flag          //
//                2. SOURCE_SPEC - Specification for free and Fixed format              //
//                3. SRCLIN_CNTN - Line continuation Flag added                         //
//                                 (B - Begin , C- Line continuation                    //
//                                  E - End of Line)                                    //
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
//20230504|0001    |Anchal      |Correct the spec information for file spec in          //
//        |        |            |IAQRPGSRC file                                         //
//        |        |            |                                                       //
//20230620|0002    |Himanshu    |Change the UwSrcDtl ds parameters and used mlseu2      //
//        |        |Gehlot      |for identifying member type instead of mlseu.          //
//        |        |            |                                                       //
//20230621|0003    |Himanshu    |Query optimization for file idspfdmbrl, now only taking//
//        |        |Gehlot      |those fileds which are required.                       //
//        |        |            |                                                       //
//        |0004    |Himanshu    |Change the logic to capture the rrn value in           //
//        |        |Gehlot      |buildcldata subprocedure for IAQCLSRC file.            //
//        |        |            |                                                       //
//20230317|0005    |Sujatha &   |Including new Procedure call to load the DSPF field    //
//        |        | Freeda     |details into IAVARREL.                                 //
//        |        |            |                                                       //
//20230803|0006    |Vivek Sharma|Added member_ type field in insert operation           //
//        |        |            |iaqddssrc, iaqrpgsrc, iaqclsrc                         //
//20230825|0007    |Abhijit C   |Enhance current functionality to log Menu references.  //
//        |        |            |[Task #190]                                            //
//27/10/23|0008    |Abhijith    |Modify the init & parser proess to include refresh     //
//        |        |Ravindran   |functionality (Task#322)                               //
//16/11/23|0009    |Arun Chacko |Modified to clear the entire file iaprcparm & IAPGMDS  //
//        |        |            |only for Build metadata not for Refresh - Task 374     //
//21/11/23|0010    |Naresh S    |Re-arranged the IAPGMREF deletion query to take care   //
//        |        |            |of both CL and RPG sources. (Task #383)                //
//14/12/23|0011    |Abhijit C   |Use IAMEMBER file instead of IDSPFDMBRL file (Task#442)//
//01/04/24|0012    |Manav T     |Fix Issue in parsing PFSQL source (Commented lines) and//
//        |        |            |IAQDDSSRC source field values (single instead of double//
//        |        |            | quotes) (Task#613)                                    //
//07/05/24|0013    |Chirranjiwe |Moving DLTOVR at the end of the loop. All the Overrides//
//        |        |            |will be deleted once the data is built. (Task#629)     //
//18/04/24|0014    |Azhar Uddin |1-Modify to generate the line continuation field for   //
//        |        |            |fixed format RPG in-line with existing handling        //
//        |        |            |2-Modified to generate blank line of fixed format as   //
//        |        |            |  commented line  (Task #656)                          //
//14/05/24|0015    |Azhar Uddin |1-Modify to populate line continuation field as 'E' for//
//        |        |            |'K' spec source line for free format.                  //
//        |        |            |2-Check if next line in 'D' specification contains     //
//        |        |            |  long variable name while continuation in effect (fix)//
//        |        |            |3-Fixed to generate the variable declaration D spec    //
//        |        |            |  line continuation as 'E' for one variable at a time  //
//        |        |            |  Task #656                                            //
//06/06/24|0016    |Saumya      |Rename AIEXCTIMR to IAEXCTIMR [Task #262]              //
//05/10/23|0017    |Khushi W    |Rename program AIMBRPRSER to IAMBRPRSER.[Task #263]    //
//04/07/24|0018    |Akhil K     |Renamed AIERRBND, AICERRLOG, AIDERRLOG and AISQLDIAGNOS//
//        |        |            |TIC with IA*
//07/10/24|0019    |Shefali     |Added logic to write Src Spec correctly for multiline  //
//        |        |            |H Spec RPG Code for task #784                          //
//29/05/24|0020    |Azhar Uddin |Task #689 - Modify to populate source line type as     //
//        |        |            |           '***T' for commented text of C spec.        //
//08/10/24|0021    |Gopi Thorat |Rename IACPYBDTL file fields wherever used due to      //
//        |        |            |table changes. [Task#940]                              //
//01/16/25|0022    | Bpal       | Issues with the query in IAMBRPRSER program #1117     //
//        |        |            | iaerrlogp file reported an error                      //
//        |        |            | SQLCOD -801 received against the 'Fetch1_CSR_C2'      //
//22/01/25|0023    |Vamsi       | IAPGMFILES is restructured.So,updated the columns     //
//        |        |Krishna2    | accordingly.(Task#63)                                 //
//01/08/24|0024    |Sabarish    |IFS Member Processing Feature [Task# 833]              //
//------------------------------------------------------------------------------------- //
ctl-opt copyright('Programmers.io © 2022');
ctl-opt option(*nodebugio:*srcstmt:*nounref);
ctl-opt bndDir('IABNDDIR' : 'IAERRBND');                                                 //0018

//------------------------------------------------------------------------------------- //
//Variable Definitions
//------------------------------------------------------------------------------------- //
dcl-s uwlib           char(10)      inz;
dcl-s uwfil           char(10)      inz;
dcl-s uwmbr           char(10)      inz;
dcl-s uwsrcdta        char(4046)    inz;
dcl-s uwerror         char(1)       inz;
dcl-s uwaction        char(20)      inz;
dcl-s uwactdtl        char(50)      inz;
dcl-s uppgm_name      char(10)      inz;
dcl-s upsrc_name      char(10)      inz;
dcl-s uplib_name      char(10)      inz;
dcl-s uwmbrtyp        char(10)      inz;
dcl-s uwmbrtyp1       char(10)      inz;
dcl-s wkNextSrcDta    char(132)     inz;                                                 //0014

dcl-s command         varchar(1000) inz;

dcl-s uwcount         packed(6:0)   inz;
dcl-s uwsrcseq        packed(6:2)   inz;
dcl-s uwsrcdat        packed(6:0)   inz;

dcl-s RowsFetched     uns(5);
dcl-s noOfRows        uns(5);
dcl-s uwindx          uns(5);
dcl-s rowFound        ind          inz('0');

dcl-s uptimestamp     Timestamp;
dcl-s sqlString       varchar(1000) inz;                                                 //0008
dcl-s bifptr          pointer;                                                           //0024
dcl-s opcodeptr       pointer;                                                           //0024

//------------------------------------------------------------------------------------- //
//Constant Variable Definitions
//------------------------------------------------------------------------------------- //
dcl-c UP               'ABCDEFGHIFKLMNOPQRSTUVWXYZ';
dcl-c LO               'abcdefghijklmnopqrstuvwxyz';

dcl-c sq               '''';
dcl-c dq               '"';
dcl-c PBarWeightage    const(79);
dcl-c oldStep          const(11);

dcl-c TRUE            '1';
dcl-c FALSE           '0';

//------------------------------------------------------------------------------------- //
//Datastructure Definitions
//------------------------------------------------------------------------------------- //
dcl-ds uwsource inz qualified;
   srcseq packed(6:2);
   srcdat packed(6:0);
   srcdta char(4046);
end-ds;

dcl-ds UwSrcDtl inz qualified;                                                           //0002
   srclib  char(10);                                                                     //0002
   srcSpf  char(10);                                                                     //0002
   srcmbr  char(10);                                                                     //0002
   ifsloc  char(100);                                                                    //0024
   srcType char(10);                                                                     //0002
   srcStat char(1);                                                                      //0008
end-ds;                                                                                  //0002


dcl-ds ds_member extname('IAMEMBER') qualified;                                          //0011
end-ds;                                                                                  //0011


dcl-ds dsmember qualified;                                                               //0011
   mllib   like(ds_member.iASrcLib);                                                     //0011
   mlfile  like(ds_member.iASrcPfNam);                                                   //0011
   mlname  like(ds_member.iAMbrNam);                                                     //0011
   mlseu2  like(ds_member.iAMbrType);                                                    //0011
   mlstat  like(ds_member.iARefflg);                                                     //0011
   mlifsl  like(ds_member.iAIfsloc);                                                     //0024
end-ds;                                                                                  //0011


dcl-ds mbrDetail qualified dim(999);                                                     //0011
   mllib   like(ds_member.iASrcLib);                                                     //0011
   mlfile  like(ds_member.iASrcPfNam);                                                   //0011
   mlname  like(ds_member.iAMbrNam);                                                     //0011
   mlseu2  like(ds_member.iAMbrType);                                                    //0011
   mlstat  like(ds_member.iARefflg);                                                     //0011
   mlifsl  like(ds_member.IAIfsloc);                                                     //0024
end-ds;                                                                                  //0011

//Data structure declaration                                                            //0008
dcl-ds iaMetaInfo dtaara len(62);                                                        //0008
   runMode char(7) pos(1);                                                               //0008
end-ds;                                                                                  //0008

//Data structure to hold the source data and divide in fixed format factors             //0014
dcl-ds DsAllSpecDta Qualified;                                                           //0014
   Spec                  char(1)  pos(6);                                                //0014
   Star                  char(1)  pos(7);                                                //0014
   FullSrcCode           char(72) pos(8);                                                //0014
   FX3FileName           char(8)  pos(7);                                                //0014
   FX4VarName            char(15) pos(7);                                                //0014
   FX4AllDeclarationFlds char(36) pos(7);                                                //0015
   FX4DeclarationType    char(2)  pos(24);                                               //0014
   FX4OpCode             char(10) pos(26);                                               //0014
   FX3OpCode             char(5)  pos(28);                                               //0014
   FX4KeyWords           char(27) pos(44);                                               //0014
   FX4ExtFactor2         char(45) pos(36);                                               //0014
   FX3FileContKeyWrd     char(1)  pos(53);                                               //0014
   CommentData           char(20) pos(81);                                               //0014
end-ds;                                                                                  //0014

dcl-ds DsRpgOpcodesLst qualified dim(999);                                               //0020
   Opcode  char(10);                                                                     //0020
end-ds;                                                                                  //0020

dcl-ds DsRpgBifsLst qualified dim(999);                                                  //0020
   BIFName char(10);                                                                     //0020
end-ds;                                                                                  //0020

//------------------------------------------------------------------------------------- //
//Prototype Definitions
//------------------------------------------------------------------------------------- //
dcl-pr IAPSRCL extpgm('IAPSRCL');
   in_Repository char(10);
   UwSrcDtl5 like(UwSrcDtl);
   uwprog char(74);
end-pr;

dcl-pr buildrpgData;                                                                     //0024
  *n like(UwSrcDtl);                                                                     //0024
  *n pointer;                                                                            //0024
  *n pointer;                                                                            //0024
end-pr;                                                                                  //0024

dcl-pr IAPSRPH3 extpgm('IAPSRPH3');
   *n char(10);
   *n LIKE(UwSrcDtl);
end-pr;

dcl-pr IAPSRRPG extpgm('IAPSRRPG');
   uwxref char(10);
   UwSrcDtl5 like(UwSrcDtl);
   uwProg char(74);
end-pr;

dcl-pr IAOVRCL extpgm('IAOVRCL');
   *n char(10) const;
   *n char(10) const;
   *n char(10) const;
end-pr;

dcl-pr IAEXCTIMR extpgm('IAEXCTIMR');                                                    //0016
   *n Char(10) Const;
   *n Char(10);
   *n Char(10);
   *n Char(10) Const;
   *n Char(10);
   *n Char(10);
   *n Char(10);
   *n Char(100) Const;                                                                   //0024
   *n Char(10) Const;
   *n Timestamp;
   *n Char(6) Const;
end-pr;

dcl-pr IAPSRMNU extpgm('IAPSRMNU');                                                      //0007
   in_Repository char(10);                                                               //0007
   UpSrcDtl  like(UwSrcDtl);                                                             //0007
end-pr;                                                                                  //0007
//------------------------------------------------------------------------------------- //
//Copybook Definitions
//------------------------------------------------------------------------------------- //
/define ProcessCreateSQLOpcode
/copy 'QMODSRC/iasrv01pr.rpgleinc'
/copy 'QMODSRC/iasrv02pr.rpgleinc'
/copy 'QCPYSRC/iaderrlog.rpgleinc'

//------------------------------------------------------------------------------------- //
//Entry Parameter
//------------------------------------------------------------------------------------- //
dcl-pi IAMBRPRSER  extpgm('IAMBRPRSER');                                                 //0017
   uwxref char(10) options(*noPass);
   uwProg char(74) options(*noPass);
end-pi;

//------------------------------------------------------------------------------------- //
//Set options
//------------------------------------------------------------------------------------- //
exec sql
   set option commit = *none,
              naming = *sys,
              usrprf = *user,
              dynusrprf = *user,
              closqlcsr = *endmod;
//------------------------------------------------------------------------------------- //
//Declare cursors
//------------------------------------------------------------------------------------- //
in IAMETAINFO;                                                                           //0008

//Fetch details based on run type                                                       //0008
if runMode = 'REFRESH';                                                            //0008//0011

   sqlString = 'Select IaSrclib, IaSrcpfnam, IaMbrnam , IaMbrtype, IaRefflg ' +          //0011
             //'from  iamember ' +                                                 //0024//0011
               ',Iaifsloc from iamember' +                                               //0024
               'where IaRefflg in (' + '''A'', ''M'')';                                  //0011
else;                                                                                    //0008

   sqlString = 'Select IaSrclib, IaSrcpfnam, IaMbrnam , IaMbrtype, ''A'' ' +             //0011
             //'from  iamember ' ;                                                 //0024//0011
               ',Iaifsloc from iamember ';                                               //0024
endIf;                                                                                   //0008
                                                                                         //0008
//Prepare sql statement for cursor                                                      //0008
exec sql                                                                                 //0008
   prepare sqlStatement from :sqlString;                                                 //0008
                                                                                         //0008
//Declare cursor                                                                        //0008
exec sql                                                                                 //0008
   declare dsmbrdtl cursor for sqlStatement;                                             //0008

//------------------------------------------------------------------------------------- //
//Main Functions
//------------------------------------------------------------------------------------- //
Eval-corr uDpsds = wkuDpsds;

//Insert process start time
uptimeStamp = %Timestamp();
CallP IAEXCTIMR('BLDMTADTA' :udpsds.ProcNme : udpsds.Lib : '*PGM' :                      //0016
              //upsrc_name : uppgm_name : uplib_name : ' ' :                             //0024
                upsrc_name : uppgm_name : uplib_name : ' ' : ' ' :                       //0024
                uptimeStamp : 'INSERT');

exec sql create table QTemp/WkLikeDSPF (DS_Mbr char(10),
                                        DS_Lib    char(10),
                                        DS_IfsLoc char(100),                             //0024
                                        DS_LikeDS char(128),
                                        DS_mainds char(128));

if runMode = 'INIT';                                                                     //0009
   //Delete records
   exec sql delete from IAPGMDS;
   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Delete_IAPGMDS';
      IaSqlDiagnostic(uDpsds);                                                           //0018
   endif;

   exec sql delete from iaprcparm;
   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Delete_IAPRCPARM';
      IaSqlDiagnostic(uDpsds);                                                           //0018
   endif;
endif;                                                                                   //0009

//Open cursor
exec sql open dsmbrdtl;
if sqlCode = CSR_OPN_COD;
   exec sql close dsmbrdtl;
   exec sql open  dsmbrdtl;
endif;

if sqlCode < successCode;
   uDpsds.wkQuery_Name = 'Open_CSR_Dsmbrdtl';
   IaSqlDiagnostic(uDpsds);                                                              //0018
endif;

if sqlCode = successCode;

   //Get the number of elements
   noOfRows = %elem(mbrDetail);
   rowFound = fetchRecordDsMbrDtlcursor();

   //Load the RPG keywords in an Array                                                  //0020
   Exsr LoadRPGKeyWords;                                                                 //0020

   dow rowFound;

      for uwindx = 1 to RowsFetched;

         dsmember = mbrDetail(uwindx);

         if dsmember.mlname <> ' ';

            if dsmember.mlifsl = ' ';                                                    //0024
               iaovrcl(dsmember.mlfile:dsmember.mllib:dsmember.mlname);
            endif;                                                                       //0024
            UwSrcDtl.srclib  = dsmember.mllib ;
            UwSrcDtl.srcSpf  = dsmember.mlfile;
            UwSrcDtl.srcmbr  = dsmember.Mlname;
            UwSrcDtl.srcType = dsmember.mlseu2;                                          //0002
            UwSrcDtl.srcStat = dsmember.mlStat;                                          //0008

            if runMode = 'REFRESH' and UwSrcDtl.srcStat = 'M';                           //0008
               deleteIARefs();                                                           //0008
            endIf;                                                                       //0008

            select;
               when %trim(dsmember.mlseu2) = 'CLLE'                                      //0002
                    or %trim(dsmember.mlseu2) = 'CLP';                                   //0002

                  buildClData();
                  IAPSRCL (uwxref :UwSrcDtl :uwProg);

               when %trim(dsmember.mlseu2) = 'PF'                                        //0002
                    or %trim(dsmember.mlseu2) = 'LF'                                     //0002
                    or %trim(dsmember.mlseu2) = 'PFSQL'                                  //0002
                    or %trim(dsmember.mlseu2) = 'DDL'                                    //0002
                    or %trim(dsmember.mlseu2) = 'SQL'                                    //0002
                    or %trim(dsmember.mlseu2) = 'DSPF'                                   //0002
                    or %trim(dsmember.mlseu2) = 'PRTF'                                   //0007
                    or %trim(dsmember.mlseu2) = 'MNUDDS'                                 //0007
                    or %trim(dsmember.mlseu2) = 'MNUCMD';                                //0007

                  buildDdsdata();
                  If %trim(dsmember.mlseu2) = 'MNUCMD';                                  //0007
                     IAPSRMNU(uwxref :UwSrcDtl );                                        //0007
                  Endif;                                                                 //0007

               when %trim(dsmember.mlseu2) ='RPGLE'                                      //0002
                    or %trim(dsmember.mlseu2) ='RPG'                                     //0002
                    or %trim(dsmember.mlseu2) ='SQLRPGLE'                                //0002
                    or %trim(dsmember.mlseu2) ='SQLRPG';                                 //0002

                //buildRpgData();                                                        //0024
                  buildRpgData(UwSrcDtl:bifptr:opcodeptr);                               //0024

                  iapsrrpg(uwxref :UwSrcDtl :uwProg);
                  IAPSRPH3(uwxref :UwSrcDtl );

            endsl;

            if %trim(dsmember.mlseu2)= 'PFSQL';                                          //0002
               ProcessDDLSrc( );
            EndIf;

            clear command;                                                               //0013
            command = 'DLTOVR FILE(*ALL) LVL(*JOB)';                                     //0013
            runcmd();                                                                    //0013
         endif;                                                                          //0013

      endfor;

      //if fetched rows are less than the array elements then come out of the loop.
      if RowsFetched < noOfRows ;
         leave ;
      endif ;

      //Fetch next record
      rowFound = fetchRecordDsMbrDtlcursor();

   enddo;

   exec sql
      close dsmbrdtl;

endif;

iaprepovr2(uwxref);

//Update process end time
UPTimeStamp = %Timestamp();
CallP IAEXCTIMR('BLDMTADTA' : udpsds.ProcNme : udpsds.Lib : '*PGM' :                     //0016
              //upsrc_name : uppgm_name : uplib_name : ' ' :                             //0024
                upsrc_name : uppgm_name : uplib_name : ' ' :  ' ' :                      //0024
                uptimeStamp : 'UPDATE');

*inlr = *on;

/copy 'QCPYSRC/iacerrlog.rpgleinc'

//------------------------------------------------------------------------------------- //0020
//Subroutine LoadRPGKeyWords : Load all RPG keywords in array to check commented code   //0020
//------------------------------------------------------------------------------------- //0020
begsr  LoadRPGKeyWords;                                                                  //0020
                                                                                         //0020
  //Declare cursor to load all opcode/declaration words in DS array.                    //0020
  exec sql                                                                               //0020
    declare LoadOpCodes cursor for                                                       //0020
      select iAKwdOpc                                                                    //0020
        from IAPSEUDOKP                                                                  //0020
       where iASrcsExtn= 'SCANOPCODE';                                                   //0020
                                                                                         //0020
  //Open cursor                                                                         //0020
  exec sql                                                                               //0020
    open LoadOpCodes;                                                                    //0020
                                                                                         //0020
  if sqlCode = CSR_OPN_COD;                                                              //0020
     exec sql close LoadOpCodes;                                                         //0020
     exec sql open  LoadOpCodes;                                                         //0020
  endif;                                                                                 //0020
                                                                                         //0020
  if sqlCode < successCode;                                                              //0020
     uDpsds.wkQuery_Name = 'Open_CSR_LoadOpCodes';                                       //0020
     IaSqlDiagnostic(uDpsds);                                                            //0020
  endif;                                                                                 //0020
                                                                                         //0020
  //Fetch cursor data                                                                   //0020
  if sqlCode = successCode;                                                              //0020
     Clear DsRpgOpcodesLst;                                                              //0020
     noOfRows = %elem(DsRpgOpcodesLst);                                                  //0020
     exec sql                                                                            //0020
       fetch LoadOpCodes for :noOfRows rows into :DsRpgOpcodesLst;                       //0020
  endif;                                                                                 //0020
                                                                                         //0020
  //Close cursor                                                                        //0020
  exec sql close LoadOpCodes;                                                            //0020
                                                                                         //0020
  //Declare cursor to load all built in function names in DS array.                     //0020
  exec sql                                                                               //0020
    declare LoadBIFname cursor for                                                       //0020
      select iAKwdOpc                                                                    //0020
        from IAPSEUDOKP                                                                  //0020
       where iASrcsExtn= 'SCANBIFNAM';                                                   //0020
                                                                                         //0020
  //Open cursor                                                                         //0020
  exec sql open LoadBIFname;                                                             //0020
  if sqlCode = CSR_OPN_COD;                                                              //0020
     exec sql close LoadBIFname;                                                         //0020
     exec sql open  LoadBIFname;                                                         //0020
  endif;                                                                                 //0020
                                                                                         //0020
  if sqlCode < successCode;                                                              //0020
     uDpsds.wkQuery_Name = 'Open_CSR_LoadBIFname';                                       //0020
     IaSqlDiagnostic(uDpsds);                                                            //0020
  endif;                                                                                 //0020
                                                                                         //0020
  //Fetch cursor data                                                                   //0020
  if sqlCode = successCode;                                                              //0020
     Clear DsRpgBifsLst;                                                                 //0020
     noOfRows = %elem(DsRpgBifsLst);                                                     //0020
     exec sql                                                                            //0020
       fetch LoadBIFname for :noOfRows rows into :DsRpgBifsLst;                          //0020
  endif;                                                                                 //0020
                                                                                         //0020
  //Close cursor                                                                        //0020
  exec sql close LoadBIFname;                                                            //0020
                                                                                         //0020
   bifptr = %addr(DsRpgBifsLst) ;                                                        //0024
   opcodeptr = %addr(DsRpgOpcodesLst);                                                   //0024
endsr;                                                                                   //0020

//------------------------------------------------------------------------------------- //
//SubProcedure runcmd: To execute the command
//------------------------------------------------------------------------------------- //
dcl-proc runcmd;

   dcl-pr runcommand extpgm('QCMDEXC');
      command    char(1000) options(*varsize) const;
      commandlen packed(15:5) const;
   end-pr;

   clear uwerror;
   monitor;
      runcommand(Command:%len(%trimr(command)));
   on-error;
      uwerror = 'Y';
   endmon;

end-proc;

//------------------------------------------------------------------------------------- //
//SubProcedure buildClDat: Build source data of CL members
//------------------------------------------------------------------------------------- //
dcl-proc buildClData;

   dcl-s r_rrn packed(6:0) inz;                                                          //0004

   clear command;
   clear uwlib;
   clear uwfil;
   clear uwmbr;
   clear uwmbrtyp;                                                                       //0006
   uwlib = dsmember.mllib;
   uwfil = dsmember.mlfile;
   uwmbr = dsmember.mlname;
   uwmbrtyp = dsmember.mlseu2;                                                           //0006

   command = 'Select RRN(a), a.* from "' + %trim(uwlib) + '"/' + %trim(uwfil) + ' a';    //0004
   exec sql prepare clstmt from :command;

   if sqlCode = successCode;

      exec sql declare sourcecl cursor for clstmt;
      exec sql open sourcecl;
      if sqlCode = CSR_OPN_COD;
         exec sql close SOURCECL;
         exec sql open  SOURCECL;
      endif;

      if sqlCode < successCode;
         uDpsds.wkQuery_Name = 'Open_CSR_SOURCECL';
         IaSqlDiagnostic(uDpsds);                                                        //0018
      endif;

      if sqlcode = successCode;

         exec sql fetch SOURCECL into :r_rrn,:uwSOURCE;                                  //0004
         if sqlCode < successCode;
            uDpsds.wkQuery_Name = 'Fetch1_CSR_SOURCECL';
            IaSqlDiagnostic(uDpsds);                                                     //0018
         endif;

         dow sqlCode = successCode;
            clear uwsrcseq;
            clear uwsrcdat;
            clear uwsrcdta;
            uwsrcseq = uwsource.srcseq;
            uwsrcdat = uwsource.srcdat;
            uwsrcdta = %xlate(sq:dq:uwsource.srcdta);
            exec sql
               insert into iaqclsrc(library_name,
                                    sourcepf_name,
                                    member_name,
                                    member_type,                                         //0006
                                    source_rrn,
                                    source_seq,
                                    source_date,
                                    source_data)
                             values(trim(:uwlib),
                                    trim(:uwfil),
                                    trim(:uwmbr),
                                    trim(:uwmbrtyp),                                     //0006
                                    char(:r_rrn),                                        //0004
                                    char(:uwsrcseq),
                                    char(:uwsrcdat),
                                    rtrim(:uwsrcdta));

            if sqlCode < successCode;
               uDpsds.wkQuery_Name = 'Insert_into_IAQCLSRC';
               IaSqlDiagnostic(uDpsds);                                                  //0018
            endif;

            exec sql
               fetch SOURCECL into :r_rrn,:uwSOURCE;                                     //0004
            if sqlCode < successCode;
               uDpsds.wkQuery_Name = 'Fetch2_CSR_SOURCECL';
               IaSqlDiagnostic(uDpsds);                                                  //0018
            endif;

         enddo;
         exec sql close sourcecl;

      endif;

   endif;

end-proc;

//------------------------------------------------------------------------------------- //
//SubProcedure buildDdsData: Build source data of DDS members
//------------------------------------------------------------------------------------- //
dcl-proc buildDdsData;

    clear command;
    clear uwlib;
    clear uwfil;
    clear uwmbr;
    clear uwmbrtyp;                                                                      //0006
    uwlib = dsmember.mllib;
    uwfil = dsmember.mlfile;
    uwmbr = dsmember.mlname;
    uwmbrtyp = dsmember.mlseu2;                                                          //0006

    if UwSrcDtl.srcStat = 'A';                                                           //0008
       exec sql
          insert into iasrcmbrid(mbrname,
                                 mbrsrcpf,
                                 mbrlib,
                                 mbrtype,
                                 mbrtloc,
                                 mbrcloc,
                                 mbrbloc,
                                 mbrbflag,
                                 mbrlocn,
                                 mbrifsid)
                          Values(:uwmbr ,
                                 :uwfil ,
                                 :uwlib ,
                                 :dsmember.mlseu2 ,
                                  0,0,0,' ',' ',0);

       if sqlCode < successCode;
          uDpsds.wkQuery_Name = 'Insert_into_IASRCMBRID';
          IaSqlDiagnostic(uDpsds);                                                       //0018
       endif;

    endif;                                                                               //0008

    command = 'Select * from "' + %trim(uwlib) + '"/' + %trim(uwfil);

    exec sql
       prepare ddsstmt from :command;

    if sqlCode = successCode;
       exec sql
          declare sourcedds cursor for ddsstmt;

       exec sql
          open sourcedds;

       if sqlCode = CSR_OPN_COD;
          exec sql close sourcedds;
          exec sql open  sourcedds;
       endif;

       if sqlCode < successCode;
          uDpsds.wkQuery_Name = 'Open_CSR_SOURCEDDS';
          IaSqlDiagnostic(uDpsds);                                                       //0018
       endif;

       exec sql
          fetch sourcedds into :uwsource;

       if sqlCode < successCode;
          uDpsds.wkQuery_Name = 'Fetch1_CSR_SOURCEDDS';
          IaSqlDiagnostic(uDpsds);                                                       //0018
       endif;

       dow sqlCode = successCode;
          clear uwsrcseq;
          clear uwsrcdat;
          clear uwsrcdta;
          uwsrcseq = uwsource.srcseq;
          uwsrcdat = uwsource.srcdat;
          uwsrcdta = uwsource.srcdta;                                                    //0012
          uwCount += 1;

          if sqlCode = successCode;

             exec sql
                insert into iaqddssrc (library_name,
                                        sourcepf_name,
                                        member_name,
                                        member_type,                                     //0006
                                        source_rrn,
                                        source_seq,
                                        source_date,
                                        source_data)
                                  values(trim(:uwlib),
                                         trim(:uwfil),
                                         trim(:uwmbr),
                                         trim(:uwmbrtyp),                                //0006
                                         char(:uwcount),
                                         char(:uwsrcseq),
                                         char(:uwsrcdat),
                                         rtrim(:uwsrcdta));

             if sqlCode < successCode;
                uDpsds.wkQuery_Name = 'Insert_into_IAQDDSSRC';
                IaSqlDiagnostic(uDpsds);                                                 //0018
             endif;

          endif;

          exec sql
             fetch sourcedds into :uwsource;

          if sqlCode < successCode;
             uDpsds.wkQuery_Name = 'Fetch2_CSR_SOURCEDDS';
             IaSqlDiagnostic(uDpsds);                                                    //0018
          endif;

       enddo;

       //Parse DDS source for PF to add variables in IAVARREL file.
       select;                                                                           //0002
          when %trim(dsmember.mlseu2)= 'PF'                                              //0002
               or %trim(dsmember.mlseu2)= 'LF' ;                                         //0002
             Monitor ;
                iaParsePfLfSrc(uwlib:
                               uwfil:
                               uwmbr) ;
             On-Error ;
                // Do nothing.
             Endmon ;

          when %trim(dsmember.mlseu2)= 'PRTF';                                           //0002
             Monitor ;
             iaParsePrtfSrc(uwlib:
                          uwfil:
                          uwmbr) ;
             On-Error ;
                // Do nothing.
             Endmon ;

          when %trim(dsmember.mlseu2)= 'DSPF';                                           //0005
              Monitor ;                                                                  //0005
                 iaParseDSPFSrc(uwlib:                                                   //0005
                                uwfil:                                                   //0005
                                uwmbr) ;                                                 //0005
              On-Error ;                                                                 //0005
                 // Do nothing.                                                          //0005
              Endmon ;                                                                   //0005

       endsl ;                                                                           //0002

       uwCount=0;
       exec sql close sourcedds;

    endif;

end-proc;

//------------------------------------------------------------------------------------- //
//SubProcedure buildRpgData: Build source data of RPG members
//------------------------------------------------------------------------------------- //
//0024dcl-proc buildRpgData;

//0024   Dcl-s w_SrcLinTyp char(5) Inz(' ');
//0024   Dcl-s wkPrvSrcLinTyp char(5) Inz(' ');                                               //0020
//0024   Dcl-s W_Tfree  char(1) inz('N');
//0024   Dcl-s CNTDCL   char(1) inz('N');
//0024   Dcl-s DCLLNCNT char(1) inz('N');
//0024   Dcl-s W_Spec   Char(1) inz(' ');
//0024   Dcl-s W_CTDATA Char(1) inz('N');
//0024   Dcl-s W_UwSrcDta char(5000) inz(' ');
//0024   Dcl-s wkLastCharPos zoned(4) inz(0)  ;                                               //0014
//0024   Dcl-s wkCkSrcDta char(5000)  inz(' ');                                               //0020
//0024   Dcl-s wkOpCode   char(10)    inz;                                                    //0020
//0024   Dcl-s wkTempBIFName char(10) inz;                                                    //0020
//0024   Dcl-s wkBkRRNComment zoned(8) dim(9999) Inz;                                         //0020
//0024   Dcl-s wkCommentCnt zoned(8) Inz;                                                     //0020
//0024   Dcl-s SlashPos zoned(4) ;
//0024   Dcl-s SmiclnPos zoned(4) ;
//0024   Dcl-s Srclength zoned(4) ;
//0024   Dcl-s wkIdx     zoned(8) ;                                                           //0020
//0024   Dcl-s wkIdx2    zoned(8) ;                                                           //0020
//0024   Dcl-s W_XSRCLNCT Char(1);
//0024   Dcl-s SvXSRCLNCT Char(1);
//0024   dcl-s r_rrn  packed(6:0)  inz;
//0024   Dcl-s Svspec   Char(1) inz(' ');                                                     //0001
//0024   Dcl-s CNTHSPEC char(1) inz('N');                                                     //0019

//0024   clear command;
//0024   clear uwlib;
//0024   clear uwfil;
//0024   clear uwmbr;
//0024   clear uwmbrtyp;                                                                      //0006
//0024   uwlib = dsmember.mllib;
//0024   uwfil = dsmember.mlfile;
//0024   uwmbr = dsmember.mlname;
//0024   uwmbrtyp = dsmember.mlseu2;                                                          //0006

//0024command = 'Select RRN(a), a.* from "' + %trim(uwlib) + '"/' + %trim(uwfil) + ' a';

//0024exec sql
//0024    prepare rpgstmt from :command;

//0024if sqlCode = successCode;

//0024   exec sql
//0024      declare sourcerpg cursor for rpgstmt;

//0024   exec sql open sourcerpg;
//0024   if sqlCode = CSR_OPN_COD;
//0024      exec sql close sourcerpg;
//0024      exec sql open  sourcerpg;
//0024   endif;

//0024   if sqlCode < successCode;
//0024      uDpsds.wkQuery_Name = 'Open_CSR_SOURCERPG';
//0024      IaSqlDiagnostic(uDpsds);                                                        //0018
//0024   endif;

//0024   if sqlCode = successCode;
//0024      exec sql
//0024         fetch sourcerpg into :r_rrn,:uwsource;

//0024      if sqlCode < successCode;
//0024         uDpsds.wkQuery_Name = 'Fetch1_CSR_SOURCERPG';
//0024         IaSqlDiagnostic(uDpsds);                                                     //0018
//0024      endif;

//0024      dow sqlCode = successCode;
//0024         clear uwsrcseq;
//0024         clear uwsrcdat;
//0024         clear uwsrcdta;
//0024         clear W_uwsrcdta;
//0024         uwsrcseq = uwsource.srcseq;
//0024         uwsrcdat = uwsource.srcdat;
//0024         uwsrcdta = %xlate(sq:dq:uwsource.srcdta);

//0024         Clear W_XSRCLNCT ;
//0024         Clear w_SrcLinTyp;
//0024         Clear w_spec;
//0024         If UWSRCDTA  <> *Blanks;

//0024            //Get Source type Flag , Fixed/Free format
//0024            Exsr GetSrcLintyp;

//0024            //Get Specification for Free format
//0024            ExSr FreeSpecification;

//0024              //1- Check if a comment line is text and not commented code (Consider    //0020
//0024              //   the commented text must have more than 30 characters).              //0020
//0024              //2- For already identified commented text line, ensure that the next    //0020
//0024              //   executable line is either from 'C' or 'P' spec only.                //0020
//0024            If (%SubSt(W_SrcLinTyp:4:1) <> ' ' and %len(%trim(W_UwSrcDta)) >= 30)       //0020
//0024               or (W_Spec <> ' ' and %SubSt(W_SrcLinTyp:4:1) = ' '                      //0020
//0024               and wkCommentCnt <> 0);                                                  //0020
//0024               ExSr IdentifyCommentedText;                                              //0020
//0024            EndIf;                                                                      //0020
//0024              wkPrvSrcLinTyp = W_SrcLinTyp;                                             //0020

//0024            //Get Line continuation Flag, If not a comment/blank line
//0024            If %SubSt(W_SrcLinTyp:4:1)=' ';                                           //0014
//0024               ExSr Linectnuatn;
//0024               SVXSRCLNCT = W_XSRCLNCT ;                                              //0014
//0024            EndIf;                                                                    //0014

//0024         endif;

//0024         exec sql
//0024            insert into iaqrpgsrc (library_name,
//0024                                   sourcepf_name,
//0024                                   member_name,
//0024                                   member_type,                                       //0006
//0024                                   source_rrn,
//0024                                   source_seq,
//0024                                   source_date,
//0024                                   srclin_type,
//0024                                   source_spec,
//0024                                   SRCLIN_CNTN,
//0024                                   source_data)
//0024                            values(trim(:uwlib),
//0024                                   trim(:uwfil),
//0024                                   trim(:uwmbr),
//0024                                   trim(:uwmbrtyp),                                   //0006
//0024                                   char(:r_rrn),
//0024                                   char(:uwsrcseq),
//0024                                   char(:uwsrcdat),
//0024                                   trim(:w_SrcLinTyp),
//0024                                   :w_spec,
//0024                                   :W_XSRCLNCT,
//0024                                   rtrim(:uwsrcdta));

//0024         if sqlCode < successCode;
//0024            uDpsds.wkQuery_Name = 'Insert_Into_IAQRPGSRC';
//0024            IaSqlDiagnostic(uDpsds);                                                  //0018
//0024         endif;

//0024         exec sql
//0024             fetch sourcerpg into :r_rrn,:uwsource;
//0024         if sqlCode < successCode;
//0024            uDpsds.wkQuery_Name = 'Fetch2_CSR_SOURCERPG';
//0024            IaSqlDiagnostic(uDpsds);                                                  //0018
//0024         endif;

//0024      enddo;
//0024      uwCount=0;
//0024      Reset W_Tfree;
//0024      Reset W_Ctdata;
//0024      Reset CNTDCL;
//0024      Reset CNTHSPEC ;                                                                //0019
//0024   endif;

//0024   exec sql
//0024      close SOURCERPG;

//0024endif;

//0024//---------------------------------------------------------------------------------- //
//0024//SubRoutine GetSrcLintyp: Check for the source line type free/fixed format
//0024//---------------------------------------------------------------------------------- //
//0024begSr GetSrcLintyp;

//0024   Reset W_Spec;
//0024   Reset w_SrcLinTyp;

//0024   Exec Sql values upper(:UWSRCDTA) into :W_UWSRCDTA;

//0024   //Check For Fully Free format
//0024   If W_Tfree = 'N';
//0024      If %Scan('**FREE':W_uwsrcdta:1) = 1;
//0024        W_Tfree = 'Y';
//0024        W_Spec = 'R';
//0024        W_SrcLinTyp = 'FFR';
//0024        LeaveSr;
//0024      Endif;
//0024   Endif;

//0024   //Check For Compile Time Array
//0024   If %SubSt(W_UwSrcDta:1:3) = '** ' Or W_Ctdata = 'Y';
//0024     W_Ctdata = 'Y';
//0024     W_SrcLinTyp = 'FX4';
//0024     W_Spec = 'T';
//0024     LeaveSr;
//0024   EndIf;

//0024   //Check For End Free
//0024   If %Scan('**END-FREE':W_uwsrcdta:1) = 1 and W_Tfree = 'Y';
//0024     W_Tfree = 'N';
//0024     W_Spec = 'R';
//0024     W_SrcLinTyp = 'FFR';
//0024     LeaveSr;
//0024   Endif;

//0024   //Get Falg for Fixed format - FX3 -RPG3
//0024   ExSr GetFixedflg;

//0024   //Get Fully Free , /Free format and RPG4
//0024   ExSr GetColSpFree;

//0024   //Check for Commented Line
//0024   ExSr CommtLine;

//0024endsr;

//0024//---------------------------------------------------------------------------------- //
//0024//SubRoutine FreeSpecification: Check for the specification for free format
//0024//---------------------------------------------------------------------------------- //
//0024begSr FreeSpecification;

//0024   //Check for Declaration Spec
//0024   if (W_SrcLinTyp = 'FFC' Or  W_SrcLinTyp = 'FFR') and w_Spec = *Blanks;

//0024      select;

//0024         //Check for Declaration Spec
//0024         when %scan('DCL-' : %Trim(W_uwsrcdta): 1) =  1
//0024              or %scan('END-' : %Trim(W_uwsrcdta): 1)   =  1 Or CNTDCL ='Y'
//0024              Or DCLLNCNT = 'Y';

//0024            w_Spec = 'D';

//0024            if %scan('DCL-F' : %Trim(W_uwsrcdta): 1) =  1;                            //0001
//0024               w_Spec = 'F';                                                          //0001
//0024            endif;                                                                    //0001

//0024            if SvSpec = 'F' and DCLLNCNT = 'Y';                                       //0001
//0024               w_Spec = SvSpec;                                                       //0001
//0024            endif;                                                                    //0001

//0024            //Check for Data structure and procedure declaration
//0024            if %scan('DCL-DS': %Trim(W_uwsrcdta): 1) =  1
//0024               or %scan('DCL-PR': %Trim(W_uwsrcdta): 1)  =  1
//0024               or %scan('DCL-PI' : %Trim(W_uwsrcdta): 1) =  1;
//0024
//0024               CNTDCL ='Y';

//0024               //Check for Data structure End ds
//0024               if ((%scan('LIKEDS': %Trim(W_uwsrcdta): 1) <>  0                       //0001
//0024                  or %scan('LIKEREC': %Trim(W_uwsrcdta): 1) <>  0))                   //0001
//0024                  and %scan('DCL-DS': %Trim(W_uwsrcdta): 1) =  1;                     //0001
//0024                  CNTDCL ='N';                                                        //0001
//0024               endif;                                                                 //0001

//0024            endif;

//0024            //Check for Data structure and procedure declaration
//0024            if %scan('END-' : %Trim(W_uwsrcdta): 1) <> 0 and CNTDCL ='Y';
//0024               CNTDCL ='N';
//0024            endif;

//0024            //Check for Declaration continuation on second line
//0024            if %scan(';' : %Trim(W_uwsrcdta): 1) =  0 and CNTDCL ='N';
//0024               DCLLNCNT = 'Y';
//0024               SvSpec = w_Spec;                                                       //0001
//0024            endif;

//0024            //End second line declaration
//0024            if %scanr(';' : %Trim(W_uwsrcdta): 1) <> 0 and DCLLNCNT = 'Y';
//0024               DCLLNCNT = 'N';
//0024               Svspec= *Blanks;                                                       //0001
//0024            endif;

//0024            //Check for P Spec
//0024            if %scan('DCL-PROC': %Trim(W_uwsrcdta): 1) <> 0
//0024               or %scan('END-PROC' : %Trim(W_uwsrcdta): 1) = 1;
//0024               w_Spec = 'P';
//0024               CNTDCL ='N';
//0024            endif;

//0024         //Check for Header Spec
//0024         when %scan('CTL-OPT' : %Trim(W_uwsrcdta): 1) = 1 OR CNTHSPEC = 'Y' ;         //0019
//0024            w_Spec = 'H';
//0024            if %scan(';' : %Trim(W_UwSrcDta): 1) = 0 ;                                //0019
//0024               CNTHSPEC = 'Y' ;                                                       //0019
//0024            else;                                                                     //0019
//0024               CNTHSPEC = 'N' ;                                                       //0019
//0024            endif;                                                                    //0019

//0024         //Check for Compiler Directorys
//0024         when %scan('/' : %Trim(W_uwsrcdta): 1) = 1;
//0024            w_Spec = 'K';

//0024         Other;
//0024            w_Spec = 'C';

//0024      endSl;
//0024  endif;
//0024  // If semicolon not found(invalid source) reset H spec continuation flag            //0019
//0024  If w_Spec  <>  *Blanks  And  w_Spec <>  'H';                                        //0019
//0024     CNTHSPEC = 'N' ;                                                                 //0019
//0024  Endif;                                                                              //0019

//0024endSr;

//0024//---------------------------------------------------------------------------------- //
//0024//SubRoutine Linectnuatn: Check for the Line Continuation Statement
//0024//---------------------------------------------------------------------------------- //
//0024begSr Linectnuatn;

//0024   if W_SrcLinTyp = 'FFR' or W_SrcLinTyp = 'FFC';

//0024      if w_Spec = 'K';                                                                //0015
//0024         W_XSrcLnCt ='E';                                                             //0015
//0024         LeaveSr;                                                                     //0015
//0024      endIf;                                                                          //0015

//0024      Srclength = %Len(%Trimr(W_uwsrcdta));
//0024      SmiclnPos = %ScanR(';': W_uwsrcdta : 1);

//0024      if SmiclnPos <> *Zeros;

//0024         //If Semi colon found then Mark as End of statement
//0024         W_XSRCLNCT ='E';

//0024         if SmiclnPos <>  Srclength;

//0024            //Check for data after semi colon if found then make it as Begin
//0024            if %SubSt(W_uwsrcdta:SmiclnPos+1:Srclength) <> *Blanks;

//0024               W_XSRCLNCT = 'B';
//0024               SlashPos = %Scan('//':W_uwsrcdta :SmiclnPos+1);

//0024               if  SlashPos = *Zeros;
//0024                   SlashPos = %Scan('--':W_uwsrcdta :SmiclnPos+1);
//0024               endif;

//0024               if  SlashPos = SmiclnPos + 1;
//0024                   W_XSRCLNCT = 'E';
//0024               elseIf (SlashPos > SmiclnPos);

//0024                   //If data found after semicolon is commented then mark as End
//0024                   if (%SubSt(W_uwsrcdta:SmiclnPos + 1:SlashPos-SmiclnPos-1)
//0024                                                      = *Blanks);
//0024                      W_XSRCLNCT = 'E';
//0024                   endif;
//0024               endif;

//0024            endif;

//0024         endif;

//0024      else;

               //If No Semi colon found then mark as begnining of statement
//0024         W_XSRCLNCT = 'B';
//0024      endif;

//0024      if (SVXSRCLNCT = 'B' Or SVXSRCLNCT = 'C') and W_XSRCLNCT = 'B';

//0024         //If Begin , then next statement with no semi colon with be c - cont.
//0024         W_XSRCLNCT = 'C';
//0024      endif;

//0024   endif;

       //Generate line continuation for RPG4 & RPG3 fixed format code                      //0014
//0024 If W_SrcLinTyp = 'FX4' OR W_SrcLinTyp = 'FX3';                                       //0014
//0024    If SVXSRCLNCT = 'B' or SVXSRCLNCT = 'C';                                          //0014
//0024       W_XSRCLNCT =  'C';                                                             //0014
//0024    Else;                                                                             //0014
//0024       W_XSRCLNCT = 'E';                                                              //0014
//0024    EndIf;                                                                            //0014
//0024    wkLastCharPos=%len(%trimr(W_uwsrcdta));                                           //0014

//0024    Select;                                                                           //0014

//0024    //Skip commented and blank lines irrespective of which spec line it is           //0014
//0024    When  %subst(W_uwsrcdta:7:1)= '*' or  %subst(W_uwsrcdta:8:72)=*Blanks;            //0014
//0024          LeaveSr;                                                                    //0014

//0024    //Handling for 'F' specification continuation (For both FX3 & FX4)               //0014
//0024    When %subst(W_uwsrcdta:6:1)='F';                                                  //0014
//0024         Select;                                                                      //0014
//0024         //Case 1 - Check if next non blank line is in same 'F' spec and contains    //0014
//0024         //         only keywords fields, If so current line will be marked as 'B'   //0014
//0024         //         or 'C' (Begin or continue) based on previous line. (For FX4)     //0014
//0024         //Case 1 - Check if next non blank line is in same 'F' spec and contains    //0014
//0024         //         the continuation keyword as 'K' with no file name, if so mark    //0014
//0024         //         this line as 'B' or 'C' based on previous line. (For FX3)        //0014
//0024         When  CheckNextLineForContinuation(R_RRN:SVXSRCLNCT:W_XSRCLNCT:              //0014
//0024               W_SrcLinTyp:W_UWSRCDTA);                                               //0014
//0024               LeaveSr;                                                               //0014
//0024         //Case 2 - If not a continuation line, mark current line as 'E'.            //0014
//0024         Other;                                                                       //0014
//0024               W_XSRCLNCT = 'E';                                                      //0014
//0024         EndSl;                                                                       //0014

//0024    //Handling for 'D' & 'P' specification continuation (For FX4 only)               //0014
//0024    When (%subst(W_uwsrcdta:6:1)='D' or %subst(W_uwsrcdta:6:1)='P') and               //0014
//0024          W_SrcLinTyp = 'FX4';                                                        //0014
//0024         Select;                                                                      //0014
//0024         //Case 1 - Long name of variable/Procedure ending with three dots which     //0014
//0024         //         must continue in next line.                                      //0014
//0024         When  %subst(W_uwsrcdta:wkLastCharPos-2:3)='...';                            //0014
//0024               If SVXSRCLNCT='B' or SVXSRCLNCT='C';                                   //0014
//0024                  W_XSRCLNCT = 'C';                                                   //0014
//0024               Else;                                                                  //0014
//0024                  W_XSRCLNCT = 'B';                                                   //0014
//0024               EndIf;                                                                 //0014
//0024         //Case 2 - If its not a long name check if next line have only keywords;    //0014
//0024         //         If so this line should be begining OR continuation line of       //0014
//0024         //         previous line (For "D" spec only).                               //0014
//0024         When  %subst(W_uwsrcdta:6:1)='D' and                                         //0014
//0024               CheckNextLineForContinuation(R_RRN:SVXSRCLNCT:W_XSRCLNCT:              //0014
//0024               W_SrcLinTyp:W_UWSRCDTA);                                               //0014
//0024               LeaveSr;                                                               //0014
//0024         //Case 3 - In case of no long name AND no continuation in next line;        //0014
//0024         //         consider the line as ending statement.                           //0014
//0024         Other;                                                                       //0014
//0024               W_XSRCLNCT = 'E';                                                      //0014
//0024         EndSl;                                                                       //0014

//0024    //Handling for 'C' specification line continuation (For FX4)                     //0014
//0024    When %subst(W_uwsrcdta:6:1)='C' and W_SrcLinTyp = 'FX4';                          //0014
//0024         Select;                                                                      //0014
//0024         //Case 1 - Check for SQL statements line continuation, If it is an SQL      //0014
//0024         //         statement and line continuation is decided after checking (i.e.  //0014
//0024         //         procedure returns ON value of indicator) then leave.             //0014
//0024         When  CheckSqlContinuation(W_UWSRCDTA:W_XSRCLNCT);                           //0014
//0024               LeaveSr;                                                               //0014
//0024         //Case 2 - Check if the next line is also fixed format & it doesn't have    //0014
//0024         //         an op-Code but extended factor 2 is there then it means next     //0014
//0024         //         line is a continuation of current line.                          //0014
//0024         //         So current line is either a Begin line OR Continuation line      //0014
//0024         //         which can be decided based on previous line continuation var.    //0014
//0024         //         If this is the case and after checking,line continuation is      //0014
//0024         //         decided (i.e. proc returns ON value of indicator) then leave.    //0014
//0024         When  CheckNextLineForContinuation(R_RRN:SVXSRCLNCT:W_XSRCLNCT:              //0014
//0024               W_SrcLinTyp:W_UWSRCDTA);                                               //0014
//0024               LeaveSr;                                                               //0014
//0024         //Case 3 - Check if current line doesn't have any op-code but there is some //0014
//0024         //         data in extended factor2, If so then current line must be an End //0014
//0024         //         of previous line (Because based on case 2, Next line is not link //0014
//0024         //         to current line so previous line is ending on current line).     //0014
//0024         When  CheckBlankOpCodeContinuation(W_UWSRCDTA:W_XSRCLNCT);                   //0014
//0024               LeaveSr;                                                               //0014
//0024         //Case 4 - If all above checks are failed than this is a single line        //0014
//0024         //         and there is no line continuation so "E" should be populated     //0014
//0024         //         in line continuation field.                                      //0014
//0024         Other;                                                                       //0014
//0024               W_XSRCLNCT = 'E';                                                      //0014
//0024         EndSl;                                                                       //0014
//0024   //Handling for 'C' specification continuation (For FX3)                           //0014
//0024    When %subst(W_uwsrcdta:6:1)='C' and W_SrcLinTyp = 'FX3';                          //0014
//0024         Select;                                                                      //0014
//0024         //Case 1 - Check for SQL statements line continuation, If it is an SQL      //0014
//0024         //         statement and line continuation is decided after checking (i.e.  //0014
//0024         //         procedure returns ON value of indicator) then leave.             //0014
//0024         When  CheckSqlContinuation(W_UWSRCDTA:W_XSRCLNCT);                           //0014
//0024               LeaveSr;                                                               //0014
//0024         //Case 2 - Check if next non blank line is in same 'C' spec and contains    //0014
//0024         //         'ANDxx' or 'ORxx' opcodes. If so, mark the line as 'B' or 'C'    //0014
//0024         //         based on previous source line continuation.                      //0014
//0024         When  CheckNextLineForContinuation(R_RRN:SVXSRCLNCT:W_XSRCLNCT:              //0014
//0024               W_SrcLinTyp:W_UWSRCDTA);                                               //0014
//0024               LeaveSr;                                                               //0014
//0024         //Case 3 - If above checks are failed than this is a single line            //0014
//0024         //         and there is no line continuation so "E" should be populated     //0014
//0024         //         in line continuation field.                                      //0014
//0024         Other;                                                                       //0014
//0024               W_XSRCLNCT = 'E';                                                      //0014
//0024         EndSl;                                                                       //0014
//0024    //For other spec apart from 'F','D','C' & 'P', mark current line as ending line  //0014
//0024    Other;                                                                            //0014
//0024         W_XSRCLNCT = 'E';                                                            //0014
//0024    EndSl;                                                                            //0014
                                                                                            //0014
//0024 EndIf;                                                                               //0014

//0024endSr;

//0024//---------------------------------------------------------------------------------- //
//0024//SubRoutine FIxed format - Get fixed format flag RPG3
//0024//---------------------------------------------------------------------------------- //
//0024begsr GetFixedflg;

//0024   if %trim(dsmember.mlseu2) = 'RPG' or                                               //0002
//0024      %trim(dsmember.mlseu2) = 'SQLRPG';                                              //0002
//0024       w_SrcLinTyp = 'FX3';
//0024       if W_CtData = 'N';
//0024         w_Spec    = %Subst(uwsrcdta : 6 : 1);
//0024       endIf;
//0024   endIf;

//0024endsr;

//0024//---------------------------------------------------------------------------------- //
//0024//SubRoutine GetColSpFree: Get free format Column Specific
//0024//---------------------------------------------------------------------------------- //
//0024begsr GetColSpFree;
//0024   if w_SrcLinTyp = *Blanks;

//0024      //Check if it is fully Free format
//0024      if W_Tfree ='Y';
//0024         w_SrcLinTyp = 'FFR';
//0024      else;

//0024         w_SrcLinTyp = 'FFC';

//0024         //Check if Specification is not blank then make it as RPG4
//0024         if %SubSt(W_uwsrcdta:6:1) <> *blanks and
//0024            %Subst(W_Uwsrcdta:6:2) <> '//';
//0024           W_Spec = %SubSt(W_uwsrcdta:6:1);
//0024           W_SrcLinTyp = 'FX4';
//0024         endif;

//0024      endif;

//0024   endif;

//0024endsr;

//0024//---------------------------------------------------------------------------------- //
//0024//SubRoutine CommtLine: Check For commented Line
//0024//---------------------------------------------------------------------------------- //
//0024begSr CommtLine;

//0024   select;

//0024      when w_SrcLinTyp = 'FX3' Or w_SrcLinTyp = 'FX4';

//0024         if  %Subst(W_uwsrcdta:7:1) =  '/' and                                        //0001
//0024             %Scan('/EXEC':W_uwsrcdta:1) = 0 and                                      //0001
//0024             %Scan('/END':W_uwsrcdta:1) = 0;                                          //0001
//0024             w_spec = 'K';                                                            //0001
//0024         endif;                                                                       //0001

//0024         //Check for commented line for RPG3 and RPG4 format
//0024         //& for blank line (no data from 8th position onwards), mark commented
//0024         if %SubSt(uwsrcdta : 7 : 1) = '*' or %SubSt(uwsrcdta : 8 :72) = *Blanks;     //0014

//0024            w_spec = *Blanks;

//0024            if w_SrcLinTyp = 'FX3';
//0024               w_SrcLinTyp = 'FX3C';
//0024            else;
//0024               w_SrcLinTyp = 'FX4C';
//0024            endif;

//0024         endif;

//0024      when w_SrcLinTyp = 'FFR';

//0024         //Check for commented line for Fully free and Mixed format
//0024         if %Scan('//':%TRIM(W_uwsrcdta)) = 1;
//0024            w_spec = *Blanks;

//0024            w_SrcLinTyp = 'FFRC';

//0024      endif;

//0024      when w_SrcLinTyp = 'FFC';
//0024         W_uwsrcdta = %Trim(%SubSt(W_uwsrcdta:7));

//0024         if %Scan('//':%TRIM(W_uwsrcdta)) = 1 Or
//0024            %SubSt(uwsrcdta : 7 : 1) = '*';
//0024            w_spec = *Blanks;
//0024            w_SrcLinTyp = 'FFCC';
//0024         endif;
//0024   endSl;


//0024endsr;

//0024//---------------------------------------------------------------------------------- //0020
//0024//SubRoutine IdentifyCommentedText - Identify if a source line is commented text     //0020
//0024//---------------------------------------------------------------------------------- //0020
//0024begSr IdentifyCommentedText;                                                          //0020
//0024
//0024  //If this is an executable line AND there are some commented text which have       //0020
//0024  //already been identified before this executable line, than check if this line     //0020
//0024  //belongs to 'C' or 'P' spec. If so, just clear out the array storing the RRN of   //0020
//0024  //commented text line before this executable line OTHERWISE update the previously  //0020
//0024  //identified line source line type's last character as 'C' so that those lines     //0020
//0024  //should not be considered in pseudo document.                                     //0020
//0024  If %subst(W_SrcLinTyp : 4 : 1) = ' ';                                               //0020

//0024     If W_Spec <> 'C' and W_Spec <> 'P';                                              //0020

//0024        For wkIdx=1 TO wkCommentCnt;                                                  //0020
//0024           wkIdx2 = wkBkRRNComment(wkIdx);                                            //0020
//0024           exec sql                                                                   //0020
//0024             Update IaQrpgSrc                                                         //0020
//0024                Set XSRCLTYP = SUBSTRING(XSRCLTYP,1,3) || 'C'                         //0020
//0024              Where library_name = trim(:uwlib)                                       //0020
//0024                and sourcepf_name = trim(:uwfil)                                      //0020
//0024                and member_name = trim(:uwmbr)                                        //0020
//0024                and member_type = trim(:uwmbrtyp)                                     //0020
//0024                and source_rrn     = char(:wkIdx2);                                   //0020
//0024        EndFor;                                                                       //0020

//0024     EndIf;                                                                           //0020

//0024     Clear wkBkRRNComment;                                                            //0020
//0024     Clear wkCommentCnt;                                                              //0020
//0024     LeaveSr;                                                                         //0020
//0024  EndIf;                                                                              //0020

//0024  //Check if a commented line is fixed format OR free format line.                   //0020
//0024  wkCkSrcDta = W_UwSrcDta;                                                            //0020
//0024  If %subst(W_SrcLinTyp : 1 : 2) = 'FX'                                               //0020
//0024     or %scan('*':%trim(wkCkSrcDta))=1;                                               //0020

//0024     //Fixed format checking of commented code, Leave if commented code is found.    //0020
//0024     wkCkSrcDta  = %Xlate(Lo:Up:UWSRCDTA);                                            //0020
//0024     wkIdx = %scan('*' : wkCkSrcDta :7);                                              //0020
//0024     Select;                                                                          //0020

//0024       When    wkIdx = 0;                                                             //0020
//0024          LeaveSr;                                                                    //0020

//0024       //1 - Check if commented sql statements, If so, consider the source line      //0020
//0024       //    as commented SQL code.                                                  //0020
//0024       When  %scan('/EXEC SQL': %trim(%subst(wkCkSrcDta : wkIdx)))<> 0                //0020
//0024             or %scan('/END-EXEC': %trim(%subst(wkCkSrcDta : wkIdx)))<> 0             //0020
//0024             or %scan('+': %trim(%subst(wkCkSrcDta : wkIdx))) = 1;                    //0020
//0024         LeaveSr;                                                                     //0020

//0024       Other;                                                                         //0020

//0024         //2 - Check for valid op-codes, if exists on specific position.             //0020
//0024         For wkIdx = 1 to %elem(DsRpgOpcodesLst);                                     //0020

//0024             If DsRpgOpcodesLst(wkIdx).OpCode = *Blanks;                              //0020
//0024                Leave;                                                                //0020

//0024             ElseIf  %scan(%trim(DsRpgOpcodesLst(wkIdx).OpCode) :                     //0020
//0024                                                      wkCkSrcDta) <> 0;               //0020

//0024                wkIdx2 = %scan(%trim(DsRpgOpcodesLst(wkIdx).OpCode)
//0024                                : wkCkSrcDta);                                        //0020
//0024                //Ensure op-code is present in near about of the op-code position     //0020
//0024                If wkIdx2 >= 20 and wkIdx2 <= 35;                                     //0020
//0024                   //Ensure there is a space before op-code OR full length of         //0020
//0024                   //factor 2 is occupied with non-blank characters                   //0020
//0024                   If %subst(wkCkSrcDta : wkIdx2-1 : 1)= ' ' or                       //0020
//0024                      %scan(' ' : %subst(wkCkSrcDta : wkIdx2-13 : 13))=0;             //0020
//0024                      LeaveSr;                                                        //0020
//0024                   EndIf;                                                             //0020
//0024                EndIf;                                                                //0020
//0024
//0024            EndIf;                                                                    //0020

//0024        EndFor;                                                                       //0020

//0024        // 3 - If nothing is found from 7th till op-code position, consider it        //0020
//0024        //     as continuation of previous code and skip.                             //0020
//0024        wkIdx = %scan(' ' : wkCkSrcDta : 7);                                          //0020
//0024        wkIdx = %check(' ' : wkCkSrcDta : wkIdx+1);                                   //0020
//0024        If %subst(W_SrcLinTyp:1:3)='FX4' and wkIdx >= 36;                             //0020
//0024           LeaveSr;                                                                   //0020
//0024        EndIf;                                                                        //0020

//0024        // 4 - Check for any built-in function                                        //0020
//0024        wkIdx2= %scanr('(': wkCkSrcDta : 7);                                          //0020
//0024        If wkIdx2-11 > 7 and wkIdx2 < 80;                                             //0020

//0024           wkIdx = %scanr(' ' : wkCkSrcDta : wkIdx2-11);                              //0020
//0024           If wkIdx2 > wkIdx and wkIdx2-wkIdx > 1;                                    //0020

//0024              wkTempBIFName = %trim(%subst(wkCkSrcDta : wkIdx : wkIdx2-wkIdx ));      //0020
//0024              If %lookup(wkTempBIFName:DsRpgBifsLst(*).BIFName) <> 0;                 //0020
//0024                 LeaveSr;                                                             //0020
//0024              EndIf;                                                                  //0020

//0024           EndIf;                                                                     //0020

//0024        EndIf;                                                                        //0020
//0024
//0024     EndSl;                                                                           //0020

//0024  Else;                                                                               //0020

//0024  //Free format checking of commented code, Leave if commented code is found.     //0020

//0024     //1 - Pickup first word after '//' and check it against the list of keywords    //0020
//0024     wkIdx =%check('/ ': wkCkSrcDta);                                                 //0020
//0024     Select;                                                                          //0020
//0024       When wkIdx = 0;                                                                //0020
//0024          LeaveSr;                                                                    //0020

//0024       //2 - If commented SQL code, leave considering the same.                      //0020
//0024       When %subst(wkCkSrcDta : wkIdx : 8) = 'EXEC SQL';                              //0020
//0024          LeaveSr;                                                                    //0020

//0024       Other;                                                                         //0020
//0024          //3 - Pick the op-code from source code.                                   //0020
//0024          wkIdx2 = %scan(' ' : wkCkSrcDta : wkIdx);                                   //0020
//0024          If wkIdx2 = 0;                                                              //0020
//0024             LeaveSr;                                                                 //0020
//0024          EndIf;                                                                      //0020
//0024          wkOpCode = %subst(wkCkSrcDta : wkIdx : wkIdx2-wkIdx);                       //0020
//0024
//0024          //Remove extender i.e. brackets & anything b/w brackets                    //0020
//0024          If %scan('(' : wkOpCode) <> 0;                                              //0020

//0024             wkIdx = %scan('(' : wkOpCode);  //Open bracket position                  //0020
//0024             If wkIdx > 1;                                                            //0020
//0024                wkOpCode = %subst(wkOpCode : 1 : wkIdx-1);                            //0020
//0024             EndIf;                                                                   //0020

//0024          EndIf;                                                                      //0020

//0024          //Remove semicolon from opcode if found                                    //0020
//0024          If %scan(';' : wkOpCode) <> 0;                                              //0020

//0024             wkIdx = %scan(';' : wkOpCode);                                           //0020
//0024             If wkIdx > 1;                                                            //0020
//0024                wkOpCode = %subst(wkOpCode : 1 : wkIdx-1);                            //0020
//0024             EndIf;                                                                   //0020

//0024          EndIf;                                                                      //0020
                                                                                         //0020
//0024          //Remove any comment if present after op-code                              //0020
//0024          If %scan('//' : wkCkSrcDta : wkIdx2) <> 0;                                  //0020
//0024             wkCkSrcDta = %subst(wkCkSrcDta : 1 :                                     //0020
//0024                                 %scan('//':wkCkSrcDta:wkIdx2)-1);                    //0020
//0024          EndIf;                                                                      //0020

//0024          //Check if word at op-code position is valid op-code, If                   //0020
//0024          //so leave subroutine considering its a commented code line                //0020
//0024          If %lookup(wkOpCode:DsRpgOpcodesLst(*).Opcode) <> 0;                        //0020
//0024             LeaveSr;                                                                 //0020
//0024          EndIf;                                                                      //0020

//0024          //4a- In case the first word is not an op-code, check if second character  //0020
//0024          //    is '=' which mean its a commented assignment (eval without op-code)  //0020
//0024          wkIdx = %check(' ' : wkCkSrcDta : wkIdx2);                                  //0020
//0024          If wkIdx <> 0 and %subst(wkCkSrcDta : wkIdx : 1) = '=';                     //0020
//0024             LeaveSr;                                                                 //0020
//0024          EndIf;                                                                      //0020

//0024          //4b- In case the first word is not an op-code, check if the last character//0020
//0024          //    is semi-colon, If so and previous source line type was commented code//0020
//0024          //    or valid code, consider this an extended commented code and leave.   //0020
//0024          If %subst(wkCkSrcDta : %len(%trimr(wkCkSrcDta)) : 1) = ';' and              //0020
//0024             %subst(wkPrvSrcLinTyp : 4 : 1) <> 'T';                                   //0020
//0024             LeaveSr;                                                                 //0020
//0024          EndIf;                                                                      //0020

//0024          //5 - In case the last character is not semi-colon, check if any built-in  //0020
//0024          //    function has been used in current line, If so, consider it as        //0020
//0024          //    commented code and leave.                                            //0020
//0024          //    a- Check if '%' is there. b- Check open bracket '(' exists after %   //0020
//0024          wkIdx = %scan('%' : wkCkSrcDta : 1);                                        //0020
//0024          If wkIdx <> 0;                                                              //0020

//0024             wkIdx2 = %scan('(' : wkCkSrcDta : wkIdx);                                //0020
//0024             If wkIdx2 <> 0 and wkIdx2-wkIdx <= 10;                                   //0020
//0024                wkTempBIFName = %trim(%subst(wkCkSrcDta : wkIdx : wkIdx2-wkIdx));     //0020
//0024                If %lookup(wkTempBIFName:DsRpgBifsLst(*).BIFName) <> 0;               //0020
//0024                   LeaveSr;                                                           //0020
//0024                EndIf;                                                                //0020
//0024             EndIf;                                                                   //0020

//0024          EndIf;                                                                      //0020

//0024      EndSl;                                                                          //0020
//0024  EndIf;                                                                              //0020

//0024  //If all checks failed for commented code, consider it as commented text and       //0020
//0024  //update the last character (i.e. 4th character) as 'T' (i.e. source line type     //0020
//0024  //will become FX3T/ FX4T/ FFCT/ FFRT for commented text.                           //0020
//0024  %subst(W_SrcLinTyp : 4 : 1) = 'T';                                                  //0020
//0024  wkCommentCnt += 1;                                                                  //0020
//0024  wkBkRRNComment(wkCommentCnt) = R_RRN;                                               //0020

//0024endsr;                                                                                //0020

//0024end-proc;
//------------------------------------------------------------------------------------- //
//SubProcedure ProcessDDLSrc: Build source data of DDL members
//------------------------------------------------------------------------------------- //
dcl-proc ProcessDDLSrc;

   dcl-s str1    char(5000);
   dcl-s in_Str  char(5000);
   dcl-c squote  const('''');
   dcl-c dquote  const('"');

   Exec sql
     Declare C2 cursor for
        Select Source_data
          from IAQDDSSRC
         where Library_Name  = :DSMEMBER.MLLIB
           and SourcePf_Name = :DSMEMBER.MLFILE
           and Member_Name   = :DSMEMBER.MLname
           and Source_Rrn   between
                ( Select Source_Rrn
                    from IAQDDSSRC
                   where Library_Name   = :DSMEMBER.MLLIB
                     and SourcePf_Name  = :DSMEMBER.MLFILE
                     and Member_Name    = :DSMEMBER.MLname
                     and (UPPER(Trim(Source_Data)) Like 'CREATE OR REPLACE TABLE%' or
                          UPPER(Trim(Source_Data)) like 'CREATE TABLE%')
                     Fetch First 1 Row Only                                              //0022
                ) and
                ( Select Source_Rrn
                    FROM IAQDDSSRC
                   where UPPER(Source_Data) like '%RCDFMT%'
                    and upper(source_data) like '%;%'
                     and Library_Name   = :DSMEMBER.MLLIB
                     and SourcePf_Name  = :DSMEMBER.MLFILE
                     and Member_Name = :DSMEMBER.MLname
                     Fetch First 1 Row Only );                                           //0022

   Exec Sql Open C2;

   if sqlCode = CSR_OPN_COD;
      exec sql close C2;
      exec sql open  C2;
   endif;

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Open_CSR_C2';
      IaSqlDiagnostic(uDpsds);                                                           //0018
   endif;

   if SQLCODE = successCode;
      Exec sql fetch next from C2 into :Str1;

      if sqlCode < successCode;
         uDpsds.wkQuery_Name = 'Fetch1_CSR_C2';
         IaSqlDiagnostic(uDpsds);                                                        //0018
      endif;

      Clear in_Str;
      dow SQLCODE = successCode;

         if Str1 <> *blanks ;                                                            //0012
            if %scan('--':%trim(Str1)) > 1 ;                                             //0012
               Str1 = %subst(Str1:1:%scan('--':Str1)-1);                                 //0012
            elseif %scan('--':%trim(Str1)) = 1 ;                                         //0012
               Str1 = ' ';                                                               //0012
            endif;                                                                       //0012
         endif;                                                                          //0012

         in_Str = ' ' + %trimr(in_Str) + %trimr(Str1);
         Exec sql fetch next from C2 into :Str1;

         if sqlCode < successCode;
            uDpsds.wkQuery_Name = 'Fetch2_CSR_C2';
            IaSqlDiagnostic(uDpsds);                                                     //0018
         endif;
      enddo;

      If In_str <> *blanks;
         in_Str = %replace(' ' : in_Str : %scan(';':in_Str:1):1);
         Exec Sql Values Upper(:in_Str) InTo :in_Str;

         if sqlCode < successCode;
            uDpsds.wkQuery_Name = 'Values_Upper_Into';
            IaSqlDiagnostic(uDpsds);                                                     //0018
         endif;

         ProcessCreateSql( in_Str    :
                           uwxref    :
                         //DSMEMBER.MLLIB  :                                             //0024
                         //DSMEMBER.MLFILE :                                             //0024
                         //DSMEMBER.MLname );                                            //0024
                           uwSrcDtl);                                                    //0024
      endif;
      exec sql close C2;

   endif;
end-proc;

//------------------------------------------------------------------------------------- //
//Procedure fetchRecordDsMbrDtlcursor: Write Member details into dsmember Array.
//------------------------------------------------------------------------------------- //
dcl-proc fetchRecordDsMbrDtlcursor;

   dcl-pi fetchRecordDsMbrDtlcursor ind end-pi ;

   dcl-s  rcdFound ind inz('0');
   dcl-s  wkRowNum like(RowsFetched) ;

   RowsFetched = *zeros;
   clear mbrDetail;

   exec sql
      fetch DsMbrDtl for :noOfRows rows into :mbrDetail;

   if sqlcode = successCode;
      exec sql get diagnostics
          :wkRowNum = ROW_COUNT;
           RowsFetched  = wkRowNum ;
   endif;

   if RowsFetched > 0;
      rcdFound = TRUE;
   elseif sqlcode < successCode ;
      rcdFound = FALSE;
   endif;

   return rcdFound;

end-proc;

//------------------------------------------------------------------------------------- //0008
//SubProcedure deleteIARefs: Delete IA product references                               //0008
//------------------------------------------------------------------------------------- //0008
dcl-proc deleteIARefs;                                                                   //0008
                                                                                         //0008
   clear uwlib;                                                                          //0008
   clear uwfil;                                                                          //0008
   clear uwmbr;                                                                          //0008
   clear uwmbrtyp;                                                                       //0008
   uwlib = dsmember.mllib;                                                               //0008
   uwfil = dsmember.mlfile;                                                              //0008
   uwmbr = dsmember.mlname;                                                              //0008
   uwmbrtyp = dsmember.mlseu2;                                                           //0008
                                                                                         //0008
   //Process deletes for all common files                                               //0008
   exec sql                                                                              //0008
      delete                                                                             //0008
        from iaSrcIntPf                                                                  //0008
       where iaMbrLib = :uwlib                                                           //0008
         and iaMbrSrc = :uwfil                                                           //0008
         and iaMbrNam = :uwmbr                                                           //0008
         and iaMbrTyp = :uwmbrtyp;                                                       //0008
                                                                                         //0008
   if sqlCode < successCode;                                                             //0008
      uDpsds.wkQuery_Name = 'Delete_IASRCINTPF';                                         //0008
      IaSqlDiagnostic(uDpsds);                                                           //0008 0018
   endif;                                                                                //0008
                                                                                         //0008
   exec sql                                                                              //0008
      delete                                                                             //0008
        from iaVarRel                                                                    //0008
       where reSrcLib = :uwlib                                                           //0008
         and reSrcFln = :uwfil                                                           //0008
         and rePgmNm  = :uwmbr;                                                          //0008
                                                                                         //0008
   if sqlCode < successCode;                                                             //0008
      uDpsds.wkQuery_Name = 'Delete_IAVARREL';                                           //0008
      IaSqlDiagnostic(uDpsds);                                                           //0008 0018
   endif;                                                                                //0008
                                                                                         //0008
   //Process deletes based on type for CL                                               //0008
   if %trim(dsmember.mlseu2) = 'CLLE'                                                    //0008
      or %trim(dsmember.mlseu2) = 'CLP';                                                 //0008
                                                                                         //0008
      //Delete from file IACPGMREF                                                      //0008
      exec sql                                                                           //0008
         delete                                                                          //0008
           from iaCPgmRef                                                                //0008
          where pSrcPfNm = :uwfil                                                        //0008
            and pLibNam  = :uwlib                                                        //0008
            and pMbrNam  = :uwmbr;                                                       //0008
                                                                                         //0008
      if sqlCode < successCode;                                                          //0008
         uDpsds.wkQuery_Name = 'Delete_IACPGMREF';                                       //0008
         IaSqlDiagnostic(uDpsds);                                                        //0008 0018
      endif;                                                                             //0008
                                                                                         //0008
      //Delete from file IAOVRPF                                                        //0008
      exec sql                                                                           //0008
         delete                                                                          //0008
           from iaOvrPf                                                                  //0008
          where iOvrMbr  = :uwmbr                                                        //0008
            and iOvrFile = :uwfil                                                        //0008
            and iOvrLib  = :uwlib;                                                       //0008
                                                                                         //0008
      if sqlCode < successCode;                                                          //0008
         uDpsds.wkQuery_Name = 'Delete_IAOVRPF';                                         //0008
         IaSqlDiagnostic(uDpsds);                                                        //0008 0018
      endif;                                                                             //0008
                                                                                         //0008
      //Delete from file IAQCLSRC                                                       //0008
      exec sql                                                                           //0008
         delete                                                                          //0008
           from iaQclSrc                                                                 //0008
          where yLibNam = :uwlib                                                         //0008
            and ySrcNam = :uwfil                                                         //0008
            and yMbrNam = :uwmbr                                                         //0008
            and yMbrTyp = :uwmbrtyp;                                                     //0008
                                                                                         //0008
      if sqlCode < successCode;                                                          //0008
         uDpsds.wkQuery_Name = 'Delete_IAQCLSRC';                                        //0008
         IaSqlDiagnostic(uDpsds);                                                        //0008 0018
      endif;                                                                             //0008
                                                                                         //0008
      //Delete from file IAVARCAL                                                       //0008
      exec sql                                                                           //0008
         delete                                                                          //0008
           from iaVarcal                                                                 //0008
          where iVcalMbr  = :uwmbr                                                       //0008
            and iVcalFile = :uwfil                                                       //0008
            and iVcalLib  = :uwlib;                                                      //0008
                                                                                         //0008
      if sqlCode < successCode;                                                          //0008
         uDpsds.wkQuery_Name = 'Delete_IAVARCAL';                                        //0008
         IaSqlDiagnostic(uDpsds);                                                        //0008 0018
      endif;                                                                             //0008
                                                                                         //0008
   endif;                                                                                //0008
                                                                                         //0008
   if %trim(dsmember.mlseu2) = 'PF'                                                      //0008
      or %trim(dsmember.mlseu2) = 'LF'                                                   //0008
      or %trim(dsmember.mlseu2) = 'PFSQL'                                                //0008
      or %trim(dsmember.mlseu2) = 'DDL'                                                  //0008
      or %trim(dsmember.mlseu2) = 'SQL'                                                  //0008
      or %trim(dsmember.mlseu2) = 'DSPF'                                                 //0008
      or %trim(dsmember.mlseu2) = 'PRTF'                                                 //0008
      or %trim(dsmember.mlseu2) = 'MNUDDS'                                               //0008
      or %trim(dsmember.mlseu2) = 'MNUCMD';                                              //0008
                                                                                         //0008
      //Delete from file IAQDDSSRC                                                      //0008
      exec sql                                                                           //0008
         delete                                                                          //0008
           from iaqddssrc                                                                //0008
          where library_name  = :uwlib                                                   //0008
            and sourcepf_name = :uwfil                                                   //0008
            and member_name   = :uwmbr                                                   //0008
            and member_type   = :uwmbrtyp;                                               //0008
                                                                                         //0008
      if sqlCode < successCode;                                                          //0008
         uDpsds.wkQuery_Name = 'Delete_IAQDDSSRC';                                       //0008
         IaSqlDiagnostic(uDpsds);                                                        //0008 0018
      endif;                                                                             //0008
                                                                                         //0008
   endif;                                                                                //0008
                                                                                         //0008
   if %trim(dsmember.mlseu2) = 'RPGLE'                                                   //0008
      or %trim(dsmember.mlseu2) = 'RPG'                                                  //0008
      or %trim(dsmember.mlseu2) = 'SQLRPGLE'                                             //0008
      or %trim(dsmember.mlseu2) = 'SQLRPG';                                              //0008
                                                                                         //0008
      //Delete from file IACALLPARM                                                     //0008
      exec sql                                                                           //0008
         delete                                                                          //0008
           from iaCallParm                                                               //0008
          where cpMemSrcPf = :uwlib                                                      //0008
            and cpMemLib   = :uwfil                                                      //0008
            and cpMemName  = :uwmbr;                                                     //0008
                                                                                         //0008
      if sqlCode < successCode;                                                          //0008
         uDpsds.wkQuery_Name = 'Delete_IACALLPARM';                                      //0008
         IaSqlDiagnostic(uDpsds);                                                        //0008 0018
      endif;                                                                             //0008
                                                                                         //0008
      //Delete from file IACPYBDTL                                                      //0008
      exec sql                                                                           //0008
         delete                                                                          //0008
           from iaCpyBdtl                                                                //0008
          where iAMbrSrcPf = :uwfil                                                      //0021
            and iAMbrLib   = :uwlib                                                      //0021
            and iAMbrName  = :uwmbr;                                                     //0021
                                                                                         //0008
      if sqlCode < successCode;                                                          //0008
         uDpsds.wkQuery_Name = 'Delete_IACPYBDTL';                                       //0008
         IaSqlDiagnostic(uDpsds);                                                        //0008 0018
      endif;                                                                             //0008
                                                                                         //0008
      //Delete from file IAPGMCALLS                                                     //0008
      exec sql                                                                           //0008
         delete                                                                          //0008
           from iaPgmCalls                                                               //0008
          where cpMemSrcPf = :uwfil                                                      //0008
            and cpMemLib   = :uwlib                                                      //0008
            and cpMemName  = :uwmbr;                                                     //0008
                                                                                         //0008
      if sqlCode < successCode;                                                          //0008
         uDpsds.wkQuery_Name = 'Delete_IAPGMCALLS';                                      //0008
         IaSqlDiagnostic(uDpsds);                                                        //0008 0018
      endif;                                                                             //0008
                                                                                         //0008
      //Delete from file IAPGMDS                                                        //0008
      exec sql                                                                           //0008
         delete                                                                          //0008
           from iaPgmDs                                                                  //0008
          where dsSrcLib = :uwlib                                                        //0008
            and dsSrcFln = :uwfil                                                        //0008
            and dsPgmNm  = :uwmbr;                                                       //0008
                                                                                         //0008
      if sqlCode < successCode;                                                          //0008
         uDpsds.wkQuery_Name = 'Delete_IAPGMDS';                                         //0008
         IaSqlDiagnostic(uDpsds);                                                        //0008 0018
      endif;                                                                             //0008
                                                                                         //0008
      //Delete from file IAPGMKLIST                                                     //0008
      exec sql                                                                           //0008
         delete                                                                          //0008
           from iaPgmKlist                                                               //0008
          where klSrcLib = :uwlib                                                        //0008
            and klSrcFln = :uwfil                                                        //0008
            and klPgmNm  = :uwmbr;                                                       //0008
                                                                                         //0008
      if sqlCode < successCode;                                                          //0008
         uDpsds.wkQuery_Name = 'Delete_IAPGMKLIST';                                      //0008
         IaSqlDiagnostic(uDpsds);                                                        //0008 0018
      endif;                                                                             //0008
                                                                                         //0008
      //Delete from file IAPRCPARM                                                      //0008
      exec sql                                                                           //0008
         delete                                                                          //0008
           from iaPrcParm                                                                //0008
          where pLibNam  = :uwlib                                                        //0008
            and pSrcPf   = :uwfil                                                        //0008
            and pMbrNam  = :uwmbr;                                                       //0008
                                                                                         //0008
      if sqlCode < successCode;                                                          //0008
         uDpsds.wkQuery_Name = 'Delete_IAPGMKLIST';                                      //0008
         IaSqlDiagnostic(uDpsds);                                                        //0008 0018
      endif;                                                                             //0008
                                                                                         //0008
      //Delete from file IAPROCINFO                                                     //0008
      exec sql                                                                           //0008
         delete                                                                          //0008
           from iaProcInfo                                                               //0008
          where iaMbrNam  = :uwmbr                                                       //0008
            and iaSrcFile = :uwfil                                                       //0008
            and iaMbrLib  = :uwlib                                                       //0008
            and iaMbrTyp  = :uwmbrtyp;                                                   //0008
                                                                                         //0008
      if sqlCode < successCode;                                                          //0008
         uDpsds.wkQuery_Name = 'Delete_IAPROCINFO';                                      //0008
         IaSqlDiagnostic(uDpsds);                                                        //0008 0018
      endif;                                                                             //0008
                                                                                         //0008
      //Delete from file IAQRPGSRC                                                      //0008
      exec sql                                                                           //0008
         delete                                                                          //0008
           from iaQrpgSrc                                                                //0008
          where xLibNam = :uwlib                                                         //0008
            and xSrcNam = :uwfil                                                         //0008
            and xMbrNam = :uwmbr                                                         //0008
            and xMbrTyp = :uwmbrtyp;                                                     //0008
                                                                                         //0008
      if sqlCode < successCode;                                                          //0008
         uDpsds.wkQuery_Name = 'Delete_IAQRPGSRC';                                       //0008
         IaSqlDiagnostic(uDpsds);                                                        //0008 0018
      endif;                                                                             //0008
                                                                                         //0008
   endif;                                                                                //0008
                                                                                         //0008
   if %trim(dsmember.mlseu2)= 'PFSQL'                                                    //0008
      or %trim(dsmember.mlseu2) ='RPGLE'                                                 //0008
      or %trim(dsmember.mlseu2) ='RPG'                                                   //0008
      or %trim(dsmember.mlseu2) ='SQLRPGLE'                                              //0008
      or %trim(dsmember.mlseu2) ='SQLRPG';                                               //0008
                                                                                         //0008
      //Delete from file IAESQLFFD                                                      //0008
      exec sql                                                                           //0008
         delete                                                                          //0008
           from iaesqlffd                                                                //0008
          where csrcLib  = :uwlib                                                        //0008
            and csrcFln  = :uwfil                                                        //0008
            and cpgmNm   = :uwmbr                                                        //0008
            and cobjType = :uwmbrtyp;                                                    //0008
                                                                                         //0008
      if sqlCode < successCode;                                                          //0008
         uDpsds.wkQuery_Name = 'Delete_IAESQLFFD';                                       //0008
         IaSqlDiagnostic(uDpsds);                                                        //0008 0018
      endif;                                                                             //0008
                                                                                         //0008
   endif;                                                                                //0008
                                                                                         //0008
   if %trim(dsmember.mlseu2) = 'CLLE'                                                    //0008
      or %trim(dsmember.mlseu2) = 'CLP'                                                  //0008
      or %trim(dsmember.mlseu2) = 'RPGLE'                                                //0008
      or %trim(dsmember.mlseu2) = 'RPG'                                                  //0008
      or %trim(dsmember.mlseu2) = 'SQLRPGLE'                                             //0008
      or %trim(dsmember.mlseu2) = 'SQLRPG';                                              //0008
                                                                                         //0008
      //Delete from file IAENTPRM                                                       //0008
      exec sql                                                                           //0008
         delete                                                                          //0008
           from iaEntPrm                                                                 //0008
          where eMbrNam  = :uwmbr                                                        //0008
            and eSrcPfNm = :uwfil                                                        //0008
            and eLibName = :uwlib;                                                       //0008
                                                                                         //0008
      if sqlCode < successCode;                                                          //0008
         uDpsds.wkQuery_Name = 'Delete_IAENTPRM';                                        //0008
         IaSqlDiagnostic(uDpsds);                                                        //0008 0018
      endif;                                                                             //0008
                                                                                         //0008
      //Delete from file IAPGMFILES                                           //0023    //0008
      exec sql                                                                 //0023    //0008
         delete                                                                //0023    //0008
           from iapgmfiles                                                     //0023    //0008
          where iALibNam  = :uwlib                                             //0023    //0008
            and iASrcFile = :uwfil                                             //0023    //0008
            and iAMbrName = :uwmbr;                                            //0023    //0008
                                                                                         //0008
      if sqlCode < successCode;                                                          //0008
         uDpsds.wkQuery_Name = 'Delete_IAPGMFILES';                                      //0008
         IaSqlDiagnostic(uDpsds);                                                        //0008 0018
      endif;                                                                             //0008
                                                                                         //0008
      //Delete from file IAPGMVARS                                                      //0008
      exec sql                                                                           //0008
         delete                                                                          //0008
           from iaPgmVars                                                                //0008
          where iaVMbr    = :uwmbr                                                       //0008
            and iaVSFile  = :uwfil                                                       //0008
            and iaVLib    = :uwlib;                                                      //0008
                                                                                         //0008
      if sqlCode < successCode;                                                          //0008
         uDpsds.wkQuery_Name = 'Delete_IAPGMVARS';                                       //0008
         IaSqlDiagnostic(uDpsds);                                                        //0008 0018
      endif;                                                                             //0008
                                                                                         //0008
      //Delete from file IASUBRDTL                                                      //0008
      exec sql                                                                           //0008
         delete                                                                          //0008
           from iaSubrDtl                                                                //0008
          where srDirName       = 'SUBROUTINE'                                           //0008
            and srMemSrcPf      = :uwfil                                                 //0008
            and srMemLib        = :uwlib                                                 //0008
            and srMemName       = :uwmbr;                                                //0008
                                                                                         //0008
      if sqlCode < successCode;                                                          //0008
         uDpsds.wkQuery_Name = 'Delete_IASUBRDTL';                                       //0008
         IaSqlDiagnostic(uDpsds);                                                        //0008 0018
      endif;                                                                             //0008
                                                                                         //0008
      //Delete from file IAPGMREF                                                       //0010
      exec sql                                                                           //0010
         delete                                                                          //0010
           from iaPgmRef                                                                 //0010
          where pSrcPfNm = :uwfil                                                        //0010
            and pLibNam  = :uwlib                                                        //0010
            and pMbrNam  = :uwmbr;                                                       //0010
                                                                                         //0010
      if sqlCode < successCode;                                                          //0010
         uDpsds.wkQuery_Name = 'Delete_IAPGMREF';                                        //0010
         IaSqlDiagnostic(uDpsds);                                                        //0010 0018
      endif;                                                                             //0010
                                                                                         //0010
   endif;                                                                                //0008
                                                                                         //0008
end-proc;                                                                                //0008

//------------------------------------------------------------------------------- //    //0014
//Check SQL line continuation for FX4 & FX3 format sources                              //0014
//------------------------------------------------------------------------------- //    //0014
dcl-proc CheckSqlContinuation;                                                           //0014

   dcl-pi *n ind;                                                                        //0014
      W_UWSRCDTA char(5000);                                                             //0014
      W_XSRCLNCT char(1);                                                                //0014
   end-pi;                                                                               //0014

   dcl-s wkFoundContinuation   Ind Inz;                                                  //0014

   select;                                                                               //0014
      //Case 1a- If current line is having '/EXEC SQL' from 7th position with 9         //0014
      //         lengththan mark it as a begining of continuation line as /END-EXEC     //0014
      //         is expected in next OR subsequent lines for such scenario              //0014
      when %subst(W_uwsrcdta:7:9)='/EXEC SQL';                                           //0014
         W_XSrcLnCt = 'B';                                                               //0014
         wkFoundContinuation = *On;                                                      //0014

      //Case 2 - If current line is having '/END-EXEC' from 7th position with 9         //0014
      //         length than mark it as an ending of continuation line as this is       //0014
      //         an ending line for SQL statement                                       //0014
      when %subst(W_uwsrcdta:7:9)='/END-EXEC';                                           //0014
         W_XSrcLnCt = 'E';                                                               //0014
         wkFoundContinuation = *On;                                                      //0014

      //Case 3 - If current line is having 'C+' from from 6th position with 2 length    //0014
      //         than mark it as a continuation line of SQL statement                   //0014
      when %subst(W_uwsrcdta:6:2)='C+';                                                  //0014
         W_XSRCLNCT = 'C';                                                               //0014
         wkFoundContinuation = *On;                                                      //0014

   endsl;                                                                                //0014

   Return wkFoundContinuation;                                                           //0014

end-proc CheckSqlContinuation;                                                           //0014

//------------------------------------------------------------------------------------- //
//SubProcedure CheckNextLineForContinuation
//------------------------------------------------------------------------------------- //
dcl-proc CheckNextLineForContinuation;                                                   //0014

   dcl-pi *n ind;                                                                        //0014
      R_rrn       packed(6:0);                                                           //0014
      SVXSRCLNCT  char(1);                                                               //0014
      W_XSRCLNCT  char(1);                                                               //0014
      W_SrcLinTyp char(5);                                                               //0014
      W_UWSrcDta  char(5000);                                                            //0014
   end-pi;                                                                               //0014

   dcl-s wkFoundContinuation   Ind Inz;                                                  //0014

   wkFoundContinuation = *Off;                                                           //0014

   //Read next line based on RRN.                                                       //0014
   command = 'select upper(srcdta) from '+%trim(uwlib)+'/'+                              //0014
              %trim(uwfil)+' b where rrn(b)>'+%char(r_rrn)+                              //0014
              ' order by rrn(b)';                                                        //0014

   //Prepare statement                                                                  //0014
   exec sql                                                                              //0014
       prepare CheckNextLine from :command;                                              //0014

   //Declare cursor                                                                     //0014
   exec sql                                                                              //0014
       declare FetchNextLineForContinuationCheck cursor for CheckNextLine;               //0014

   //Open cursor                                                                        //0014
   exec sql open FetchNextLineForContinuationCheck;                                      //0014
   if sqlCode = CSR_OPN_COD;                                                             //0014
      exec sql close  FetchNextLineForContinuationCheck;                                 //0014
      exec sql open  FetchNextLineForContinuationCheck;                                  //0014
   endif;                                                                                //0014

   dow sqlCode = successCode;                                                            //0014

      exec sql                                                                           //0014
         fetch FetchNextLineForContinuationCheck                                         //0014
          into :wkNextSrcDta;                                                            //0014

      dsAllSpecDta = wkNextSrcDta;
                                                                                         //0014
      select;                                                                            //0014
         //If no line is found after current line, Skip.                                //0014
         when sqlcode<>successCode;                                                      //0014
            leave;                                                                       //0014

         //If next line is commented OR blank, reiterate to read another line to        //0014
         //get to an executable line.                                                   //0014
         when DsAllSpecDta.Star='*' or DsAllSpecDta.FullSrcCode=*Blanks;                 //0014
            iter;                                                                        //0014

         //If next executable line is not in same spec as of current line, consider no  //0014
         //continuation and leave.                                                      //0014
         when DsAllSpecDta.Spec <> %subst(W_uwsrcdta:6:1);                               //0014
            leave;                                                                       //0014

         //For "F" spec of 'FX4', check if next line contains only keywords, if so      //0014
         //consider it as continuation of current line & Leave otherwise simply leave.  //0014
         when DsAllSpecDta.Spec = 'F'                                                    //0014
              and W_SrcLinTyp = 'FX4';                                                   //0014
            if DsAllSpecDta.FX4AllDeclarationFlds = *Blanks                              //0014
               and DsAllSpecDta.FX4KeyWords <> *Blanks;                                  //0014
               wkFoundContinuation = *On;                                                //0014
            endIf;                                                                       //0014
            leave;                                                                       //0014

         //For "F" spec of 'FX3', check if next line doesn't contains the file name &   //0014
         //the continuation keyword is specified as 'K' in next line. If so consider    //0014
         //it as continuation of current line & Leave otherwise simply leave.           //0014
         when DsAllSpecDta.Spec = 'F' and W_SrcLinTyp = 'FX3';                           //0014
            if DsAllSpecDta.FX3FileContKeyWrd = 'K';                                     //0014
               wkFoundContinuation = *On;                                                //0014
            endIf;                                                                       //0014
            leave;                                                                       //0014

         //For "D" spec, check if next line contains only keywords, or it contains a    //0014
         //              name of variable but no declaration type. If so, consider it   //0014
         //              as continuation of current line & Leave otherwise simply leave.//0014
         when   DsAllSpecDta.Spec ='D' and W_SrcLinTyp = 'FX4';                          //0014

            //In case the next line is a long variable name, consider                   //0015
            //to re-iterate to check further if the long variable is another            //0015
            //part of current DS or not                                                 //0015
            if %subst(wkNextSrcDta:%len(%trimr(wkNextSrcDta))-2:3)='...';                //0015
               iter;                                                                     //0015
            endIf;                                                                       //0015

            if DsAllSpecDta.FX4AllDeclarationFlds = *Blanks                              //0014
               and DsAllSpecDta.FX4KeyWords <> *Blanks;                                  //0015
               wkFoundContinuation = *On;                                                //0014
            endIf;                                                                       //0014
            leave;                                                                       //0014

         //For "C" spec of FX4, check if next line doesn't contains any op code         //0014
         //and extended factor 2 contains some non blank data. If so, consider it       //0014
         //as continuation of current line & Leave otherwise simply leave.              //0014
         when DsAllSpecDta.Spec ='C' and W_SrcLinTyp = 'FX4';                            //0014
            if DsAllSpecDta.FX4OpCode = *Blanks                                          //0014
               and DsAllSpecDta.FX4ExtFactor2 <> *Blanks;                                //0014
               wkFoundContinuation = *On;                                                //0014
            endIf;                                                                       //0014
            leave;                                                                       //0014

         //For "C" spec of FX3, check if next contains op code starting with 'OR' or    //0014
         //'AND', If so consider it as continuation of current line and leave otherwise //0014
         //simply leave.                                                                //0014
         when DsAllSpecDta.Spec ='C' and W_SrcLinTyp = 'FX3';                            //0014
            if %subst(DsAllSpecDta.FX3OpCode:1:2) = 'OR'                                 //0014
               or %subst(DsAllSpecDta.FX3OpCode:1:3) = 'AND';                            //0014
               wkFoundContinuation = *On;                                                //0014
            endIf;                                                                       //0014
            leave;                                                                       //0014

         //Leave in exception scenarios                                                 //0014
         other;                                                                          //0014
            leave;                                                                       //0014
      endsl;                                                                             //0014

   enddo;                                                                                //0014


   //Close cursor                                                                       //0014
   exec sql close FetchNextLineForContinuationCheck;                                     //0014

   if wkFoundContinuation;                                                               //0014
      if SVXSRCLNCT = 'B'  or SVXSRCLNCT = 'C';                                          //0014
         W_XSRCLNCT = 'C';                                                               //0014
      else;                                                                              //0014
         W_XSRCLNCT = 'B';                                                               //0014
      endif;                                                                             //0014
   endif;                                                                                //0014

   Return wkFoundContinuation;                                                           //0014

end-proc CheckNextLineForContinuation;                                                   //0014

//------------------------------------------------------------------------------------- //
//SubProcedure CheckBlankOpCodeContinuation
//------------------------------------------------------------------------------------- //
dcl-proc CheckBlankOpCodeContinuation;                                                   //0014

   dcl-pi *n ind;                                                                        //0014
      W_UWSRCDTA char(5000);                                                             //0014
      W_XSRCLNCT char(1);                                                                //0014
   end-pi;                                                                               //0014

   dcl-s wkFoundContinuation   Ind Inz;                                                  //0014

   wkFoundContinuation = *Off;                                                           //0014

   if %subst(W_uwsrcdta:26:10) = *Blanks                                                 //0014
      and %subst(W_uwsrcdta:36:45) <> *Blanks;                                           //0014
      wkFoundContinuation = *On;                                                         //0014
      W_XSRCLNCT = 'E';                                                                  //0014
   endIf;                                                                                //0014

   Return wkFoundContinuation;                                                           //0014

end-proc CheckBlankOpCodeContinuation;                                                   //0014

