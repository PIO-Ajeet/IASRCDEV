**free
      //%METADATA                                                      *
      // %TEXT 02 Service Program Module                               *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------ //
//CREATED BY :   Programmers.io @ 2020                                                 //
//CREATE DATE:   2020/01/01                                                            //
//DEVELOPER  :   Kaushal kumar                                                         //
//DESCRIPTION:   Service Program Module - 2                                            //
//                                                                                     //
//PROCEDURE LOG:                                                                       //
//------------------------------------------------------------------------------------ //
//Procedure Name           | Procedure Description                                     //
//-------------------------|---------------------------------------------------------- //
//WrtSrcIntRefF            | Write into Source Intermediate Reference File             //
//IAPSRDTAARA              | Parse CL statement having CL DTAARA commands              //
//                         |                                                           //
//                         |                                                           //
//                         |                                                           //
//                         |                                                           //
//                         |                                                           //
//                         |                                                           //
//------------------------------------------------------------------------------------ //
//                                                                                     //
//MODIFICATION LOG:                                                                    //
//------------------------------------------------------------------------------------ //
//Date    | Mod_ID | Developer  | Case and Description                                 //
//--------|--------|------------|----------------------------------------------------- //
//21/12/15| AK11   | Ashwani Kr | Changes related to write source intermediate file    //
//21/12/20| AK12   | Ashwani Kr | Adding CL DTAARA commands, RGZPFM, CPYF, SBMJOB etc  //
//22/04/21| SK01   | Santhosh   | Bug Fix - Data Mapping Issue IAENTPRM/IAPGMVARS      //
//22/05/10| MT01   | Mahima     | Corrected Process of DCLF Proc : IAPRDFOVR           //
//22/05/19| TK01   | Tushar K   | Corrected the data structure field name process.     //
//22/06/01| VHM1   | Vaibhav M  | Process rename for EXTFLD keyword                    //
//22/07/07| TK02   | Tushar K   | Bug Fix - LikeDs logic.                              //
//22/07/25| RS01   | Raman S    | CLLE Programs Variable declarations                  //
//22/08/23| SK02   | Santhosh   | CL Parser Enhancement - 4 CL Commands                //
//22/08/25| SG01   | Shobhit    | populating the procedure detail table AIPROCDTL      //
//22/09/07|        | Santhosh   | CL Parser Enhancement - IAPREPOVR Parms parsing fixed//
//22/09/15| SG02   | Shobhit    | Procedure name is coming with ';' for some cases     //
//22/09/19|        | Santhosh   | IAEXCPLOG Len or Start Pos - IACPYTOSTMF Enhancement //
//22/09/19|        | Santhosh   | IAEXCPLOG Len or Start Pos - IAPRDVVAR               //
//22/09/20|        | Santhosh   | IAEXCPLOG Rcvr too small bug - IAPSRDSFX             //
// 22/10/04|        | KD         | DCL parsing bug - Factor 1 had *CHAR in IAVARREL     //
//22/10/06| SB01   | Sriram B   | Removed all the Monitor - On Error Blocks used       //
//22/12/13| ST01   | Stephen    | Added the logic to handle the crashing situation     //
//        |        |            | on below procedures.                                 //
//        |        |            |   (IAPSRPRFX, IAPSRPRFR, PR_LIKEDETAILS).            //
//22/12/07| AJ01   | Anchal     | Optimize the subprocedure for the creasing situation //
//22/12/23| SS03   | Sushant S  | Changed code for SQL Dump bcz of "Value for variable //
//        |        |            | too long"                                            //
//22/12/28|        | Manav T    | Changed code to optimize procedures                  //
//22/12/23| SC01   | Shantanu   | Optimize the subprocedure and put precautions for    //
//        |        |            | possible crashing situations.                        //
//23/01/23| PJ01   | Pranav     | Fixed issue in procedure IAPSRFLFR.                  //
//        |        |   Joshi    |  1. Increased length of FL_KeyWord                   //
//        |        |            |  2. Exit the loop in case closing bracket not found. //
//27/01/23| 0001   | Pranav     | Added VALUE keyword for string param in IAPSRDSFR    //
//        |        |   Joshi    |                                                      //
//23/02/01| 0002   | Ojasva     | Replace %trim and SQL trim with options(*trim)       //
//07/02/23| 0003   |Pranav Joshi| Changed queries selection criterion based on the     //
//        |        |            | indexes available.                                   //
//07/02/23| 0003   |Pranav Joshi| Changed queries selection criterion based on the     //
//        |        |            | indexes available.                                   //
//15/02/23| 0004   |Yogesh      | Write KList Attributes in IMPGMVARS                  //
//        |        |            |                                                      //
//16/02/23| 0005   |Pratik      | Skip IAPGMREF and IAPGMVARS for attribute search in  //
//        |        |Atodaria    | KLIST. Write in IAPGMVARS when KLIST have            //
//        |        |            | attributes defined In KLIST only.                    //
//        |        |            | Remove Length and Decimal pos attr. from IAPGMKLIST  //
//24/01/23| 0006   | Pranav     | IAPSRPRFX procedure optimization with DSpecV4 DS.    //
//24/01/23| 0007   | Shubham    | IAPSRPRFX procedure optimization with DSpecV4 DS.    //
//10/03/23| 0008   |Pratik      | Skip IAPGMREF for Length, Data type and Array value  //
//        |        |Atodaria    | when Searching in IAEMTPRM. Write in IAPGMVARS for   //
//        |        |            | attributes defined In PLIST only.                    //
//        |        |            | Remove Length and Decimal pos attr. And array info.  //
//        |        |            | from IAENTPRM                                        //
//18/04/23| 0009   |Arshaa      | 1. Moved all IAVARREL DS data related inserts into   //
//        |        |            |    IAPSRDSFX, IAPSRDSFR from IAPSRVARFX, IAPSRVARFR  //
//        |        |            |    procedures respectively for optimisation.         //
//        |        |            | 2. DS related records will now hold the DS name in   //
//        |        |            |    'Resulting Variable' field in IAVARREL            //
//16/03/23| 0010   | Sarvesh B  | Commenting the IAUPDATEPGMREF procedure call from    //
//        |        |            | each calling procedure.                              //
//16/03/23| 0011   |Pratik      | PLIST values need to be inserted into IAPGMVARS      //
//        |        |Atodaria    | when the PLIST is not *ENTRY parameters              //
//17/07/23| 0012   |Sumer       | Issue in Prefix column when we add Quotes with       //
//        |        |            | Prefix in source                                     //
//27/07/23| 0013   |Akshay      | 1. If Dcl-proc without dcl-pi it was not getting     //
//        |        | Sopori     |    inserted in AIPROCDTL, fixed that.                //
//        |        |            | 2. Fixed issue with the sequence number, RRN number  //
//        |        |            |    in the AIPROCDTL file.                            //
//        |        |            |    ( Fixed/Free both )                               //
//17/08/23| 0014   | Anjan Ghosh| User Defined command reference creation in IASRCINTF //
//07/08/23| 0015   |Bhavit Jain | 1. IAPRCPARM File was populating incorrect data in   //
//        |        |Tanisha K.  |    data type field (INT and POINTER).                //
//        |        |[Task#57]   | 2. LIKE keyword was populating in incorrect manner,  //
//        |        |            |    was populating with some extra brackets.          //
//        |        |            |                                                      //
//10/08/23| 0016   |Bhavit Jain | 1. Parameter attribute should populate in IAPGMVARS  //
//        |        |Tanisha K.  |    file instead of IAPRCPARM file.                   //
//        |        |[Task#150]  | 2. IAPGMVARS file should not populate the unnamed    //
//        |        |            |    variables.                                        //
//        |        |            | 3. Data type length is not populated in the case of  //
//        |        |            |    PI and PR variable in IAPGMVARS File.             //
//        |        |            | 4. In place of PI and PR populate the value PG_GL for//
//        |        |            |    global variable and PG_LO for the local variable  //
//        |        |            |    in PI and PR in IAPGMVARS file.                   //
//09/09/23| 0017   |Akshay      | Fixed the issue with parsing of CPYF command         //
//        |        |  Sopori    | For task - 118                                       //
//31/08/23| 0018   |Abhijit C   | Enhance current functionality to log Menu references.//
//        |        |task#190    |                                                      //
//09/09/23| 0019   |Akshay      | Changed the AIPROCDTL file to IAPROCINFO             //
//        |        |  Sopori    | [Task #208]                                          //
//03/10/23| 0020   |Naresh S    | Fixed the issue with incorrect extraction of         //
//        |        |            | procedure name in Fixed Format.(Task #235)           //
//27/09/23| 0021   |Himanshu    | 1. Done the changes in IaPsrDsFr procedure for       //
//        |        |Gehlot      |    Extname keyword issue in Free Format.             //
//        |        |Task #135   | 2. Done the changes in IaPsrDsFx procedure for       //
//        |        |            |    Extname keyword issue in Fix Format.              //
//07/09/23| 0022   | Satyabrat  | 1. Entry parameters for Fully free format and RPGIV  //
//        | Task#82| Sabat      |    Fixed format (Procedure Interface parameters) not //
//        |        |            |    populated in IAENTPRM/IAPGMVARS.                  //
//        |        |            | 2. Entry parameter field attributes (Length and Dec  //
//        |        |            |    Positions) not correct for all fields in          //
//        |        |            |    IAPRCPARM.                                        //
//        |        |            | 3. Removed unused fields from IAENTPRM.              //
//02/11/23| 0023   | Abhijit    | Need to change the usage filed to literal value      //
//        |        | Charhate   | instead of decimal.(Task#312)                        //
//        |        |            |                                                      //
//20/10/23| 0024   |Akshay      | 1. For data types having default length, attributes  //
//        |        |  Sopori    | not correctly getting captured in IAPGMVARS file.    //
//        |        |            | #216 (Epic #215)                                     //
//        |        |            | 2. For PR parameters, type of variable not correct.  //
//        |        |            | #219 (Epic #215)                                     //
//        |        |            | 3. Procedure name not getting captured in IAPGMVARS  //
//        |        |            | while parameter population.                          //
//        |        |            | #225 (Epic #215)                                     //
//25/04/24| 0025   | Sribalaji  | When the length of the decimal conversion is long    //
//        |        |            | handel by monitor increase the length from 5 to 8    //
//        |        |            | in %decimal (Task #644)                              //
//29/04/24| 0026   | Sribalaji  | In IAPRSDOVR procedure and IAPRSOVR procedure        //
//        |        |            | while updating "iaovrpf" file                        //
//        |        |            | the field of iovr_rrn, iovr_drrn, iovr_darrn         //
//        |        |            | initialized as character but they are decimal        //
//        |        |            | (Task #630)                                          //
//09/05/24| 0027   |Rishab      | Fixed the issue with SQL where more than one records //
//        |        |Kaushik     | were returned by subquery TASK#635                   //
//06/11/23| 0028   | Bhavit     | Fixed format parameter attribute should populate into//
//        |        |   Jain     | IAPGMVARS file instead of IAPRCPARM file.[Task #348] //
//03/06/24| 0029   |Chirranjiwe | Fixed the issue where RRN# was not populated in the  //
//        |        |Reddi       | file IAPGMVARS for variables of PR in fixed format   //
//        |        |            | and PR, PI in Free Format (Task #698)                //
//15/01/25| 0030   |Akhil Kallur| In IAPSRUSRCMD - rewrote the logic such that only the//
//        |        |            | first term in the line will be checked for if it is a//
//        |        |            | user defined command.                                //
//20/01/25| 0031   |Rajesh G &  | Record Format name parsing logic for both Fixed &    //
//        |        |Vamsi       | Free RPGLE progams. Also,IAPGMFILES is restructured. //
//        |        |Krishna2    | So,updated in all dependent procedures. (Task#63)    //
//17/09/24| 0032   |Rishab      | Added the code changes to insert entries into the    //
//        |        |Kaushik     | file IASRCINTPF for CL variables[Task# 686]          //
//08/08/24| 0033   |Sabarish &  | IFS Member Parsing Feature                           //
//        |        |Vishwas     |                                                      //
//23/08/23| 0034   |Abhijit C   | Remove the logic to populate IAPGMFILES for CL cmds  //
//        |        |            | not using the files in READ, WRITE, UPDATE or delete //
//        |        |            | [task#176]                                           //
//------------------------------------------------------------------------------------ //

ctl-opt copyright('Copyright @ Programmers.io © 2022');                                       //SG01
ctl-opt option(*noDebugIo: *srcStmt: *noUnRef) expropts(*RESDECPOS) debug;
ctl-opt nomain;
ctl-opt bndDir('IABNDDIR');

/copy 'QMODSRC/iasrv01pr.rpgleinc'
/copy 'QMODSRC/iasrv02pr.rpgleinc'
/copy 'QCPYSRC/rpgivds.rpgleinc'

dcl-ds PSDS extname('IAPSDSF') PSDS qualified;
end-ds;

dcl-ds xl_IAVARRELDS extname('IAVARREL') prefix(xl_) inz;
end-ds;

dcl-ds UwSrcDtl ;                                                                        //0033
       in_srclib   Char(10) ;                                                            //0033
       in_srcspf   Char(10) ;                                                            //0033
       in_srcmbr   Char(10) ;                                                            //0033
       in_ifsloc   Char(100);                                                            //0033
       in_srcType  Char(10) ;                                                            //0033
       in_srcStat  Char(1)  ;                                                            //0033
end-ds;                                                                                  //0033

dcl-c UPPER      'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
dcl-c LOWER      'abcdefghijklmnopqrstuvwxyz';
dcl-c SQL_ALL_OK '00000';
dcl-c numConst   '0123456789.';
dcl-c numConst1  '0123456789';

exec sql
  set option commit    = *none,
             naming    = *sys,
             usrprf    = *user,
             dynusrprf = *user,
             closqlcsr = *endmod,
             srtseq    = *langidshr;

dcl-proc IACPYFRMIMPF export;
   dcl-pi *n;
      in_ParmPointer pointer;
   end-pi;

   dcl-ds w_IAPGMFILES extName('IAPGMFILES') qualified inz end-ds;
   dcl-ds w_ParmDS qualified based(in_ParmPointer);
      w_String     char(5000);
      w_Error      char(10);
      w_Repository char(10);
      w_SrcLib     char(10);
      w_SrcPf      char(10);
      w_SrcMbr     char(10);
      w_IfsLoc     char(100);                                                             //0033
      w_RRNStr     packed(6:0);
      w_RRNEnd     packed(6:0);
   end-ds;

   dcl-s w_ClStatement char(5000)          inz;
   dcl-s w_WordsArray  char(120)  dim(100) inz;
   dcl-s w_FileKeyPos  char(5000)          inz;
   dcl-s PosBlank      packed(6:0)         inz;                                            //SS03

   clear w_IAPGMFILES;
   w_ClStatement          = w_ParmDS.w_String;
   w_IAPGMFILES.IAMBRNAME  = w_ParmDS.w_SrcMbr;                                          //0031
   w_IAPGMFILES.IASRCFILE  = w_ParmDS.w_SrcPf;                                           //0031
   w_IAPGMFILES.IALIBNAM   = w_ParmDS.w_SrcLib;                                          //0031
   w_IAPGMFILES.IAIFSLOC  = w_ParmDS.w_IfsLoc;                                           //0033

   if w_ClStatement = *Blanks;
      return;
   endif;

   GetWordsInArray(w_ClStatement : w_WordsArray);

   w_FileKeyPos = scanKeyword('TOFILE(':w_ClStatement);

   if w_FileKeyPos = *blanks;
      w_FileKeyPos = w_WordsArray(2);
   endif;

   //PS01 if %scan('/':w_FileKeyPos) > 0;
   if w_FileKeyPos <> *blanks and %scan('/':w_FileKeyPos) > 0 and                         //PS01
      %len(w_FileKeyPos) > %scan('/': w_FileKeyPos);                                      //PS01
      w_FileKeyPos = %subst(w_FileKeyPos: %scan('/': w_FileKeyPos)+1:
                                          %len(w_FileKeyPos) - %scan('/': w_FileKeyPos));
   endif;


//Handling case when we have value in variable "w_FileKeyPos" with length more than 10
   If %len(%trim(w_FileKeyPos)) > 10 ;                                                    //SS03
     Posblank  = %Scan(' ':%trim(w_FileKeyPos));                                          //SS03
     If PosBlank > 0 AND PosBlank <= 10;                                                  //SS03
        w_FileKeyPos = %Subst(%trim(w_FileKeyPos):1:PosBlank);                            //SS03
     ElseIf PosBlank = 0;
        w_FileKeyPos = %Subst(w_FileKeyPos:1:10);
     Endif;                                                                               //SS03
   Endif;                                                                                 //SS03

 //exec sql                                                                              //0034
 //  insert into IAPGMFILES (IALIBNAM,                                             //0034//0031
 //                          IASRCFILE,                                            //0034//0031
 //                          IAMBRNAME,                                            //0034//0031
 //                          IAIFSLOC,                                             //0034//0033
 //                          IAACTFILE)                                            //0034//0031
 //    values(trim(:w_IAPGMFILES.IALIBNAM),                                        //0034//0031
 //           trim(:w_IAPGMFILES.IASRCFILE),                                       //0034//0031
 //           trim(:w_IAPGMFILES.IAMBRNAME),                                       //0034//0031
 //           trim(:w_IAPGMFILES.IAIFSLOC),                                        //0034//0033
 //           trim(:w_FileKeyPos));                                                //0034//0031

 //if SQLSTATE <> SQL_ALL_OK;                                                            //0034
 //   //log error                                                                       //0034
 //endif;                                                                                //0034

   return;
end-proc;

dcl-proc IACPYTOSTMF export;
   dcl-pi *n;
      in_ParmPointer pointer;
   end-pi;

   dcl-ds w_IAPGMFILES extName('IAPGMFILES') qualified inz end-ds;
   dcl-ds w_ParmDS qualified based(in_ParmPointer);
      w_String     char(5000);
      w_Error      char(10);
      w_Repository char(10);
      w_SrcLib     char(10);
      w_SrcPf      char(10);
      w_SrcMbr     char(10);
      w_IfsLoc     char(100);                                                            //0033
      w_RRNStr     packed(6:0);
      w_RRNEnd     packed(6:0);
   end-ds;
   //DS declarations
   dcl-ds IAVARRELDS extname('IAVARREL') inz;
   end-ds;

   // Standalone declarations
   Dcl-S NumOfElem     packed(4:0)          inz;
   Dcl-S Elem          packed(4:0)          inz(0);
   Dcl-S SeqNo         packed(4:0)          inz(0);
   dcl-s w_ClStatement char(5000)           inz;
   dcl-s w_WordsArray  char(120)   dim(100) inz;
   dcl-s w_slashpos1   packed(6:0)          inz(1);
   dcl-s w_tempstr     char(300)            inz;
   dcl-s w_slashpos2   packed(6:0)          inz;
   dcl-s w_FileKeyPos  char(5000)           inz;

   clear w_IAPGMFILES;
   w_ClStatement          = w_ParmDS.w_String;
   w_IAPGMFILES.IAMBRNAME  = w_ParmDS.w_SrcMbr;                                          //0031
   w_IAPGMFILES.IASRCFILE  = w_ParmDS.w_SrcPf;                                           //0031
   w_IAPGMFILES.IALIBNAM   = w_ParmDS.w_SrcLib;                                          //0031
   w_IAPGMFILES.IAIFSLOC   = w_ParmDS.w_IfsLoc;                                          //0033

   if w_ClStatement = *Blanks;
      return;
   endif;


   GetWordsInArray(w_ClStatement : w_WordsArray);

   w_FileKeyPos = %trim(scanKeyword('FROMMBR(':w_ClStatement));

   if w_FileKeyPos = *blanks;
      w_FileKeyPos = w_WordsArray(2);
   endif;

   dow w_slashpos1 > 0;
      w_slashpos1 = %scan('/':w_Filekeypos:w_slashpos1);
      w_slashpos2 = %scan('/':w_Filekeypos:w_slashpos1+1);
      If w_Slashpos2 - w_slashpos1 - 1 <= 0;
         Leave;
      Endif;
      w_tempstr   = %subst(w_FileKeyPos:w_slashpos1+1:w_Slashpos2-w_slashpos1-1);

      if %scan('.FILE':w_tempstr) > 1;                                                     //KM
         w_FileKeyPos = %subst(w_tempstr:1:%scan('.FILE':w_tempstr)-1);

          //exec sql                                                                     //0034
          //  insert into IAPGMFILES (IALIBNAM,                                    //0034//0031
          //                          IASRCFILE,                                   //0034//0031
          //                          IAMBRNAME,                                   //0034//0031
          //                          IAIFSLOC,                                    //0034//0033
          //                          IAACTFILE)                                   //0034//0031
          //   values(trim(:w_IAPGMFILES.IALIBNAM),                                //0034//0031
          //          trim(:w_IAPGMFILES.IASRCFILE),                               //0034//0031
          //          trim(:w_IAPGMFILES.IAMBRNAME),                               //0034//0031
          //          trim(:w_IAPGMFILES.IAIFSLOC),                                //0034//0033
          //          trim(:w_FileKeyPos));                                        //0034//0031

         leave;
      else;
         w_slashpos1 = w_slashpos2;
         w_slashPos2 = 0;
      endif;
   enddo;

   NumOfElem = %lookup(' ' : w_WordsArray);
   For Elem = 1 to NumOfElem - 1;
      //Retrieve only the Variables and insert into IAVARREL
      If %subst( %trim(w_WordsArray(Elem)) : 1 : 1) = '&';
         SeqNo +=  1;
         REFACT1 = %trim(w_WordsArray(Elem));

         Exec sql
            Insert into IAVARREL (RESRCLIB,
                        RESRCFLN,
                        REPGMNM,
                        REIFSLOC,                                                        //0033
                        RESEQ,
                        RERRN,
                        REOPC,
                        REFACT1)
            values(trim(:w_ParmDS.w_SrcLib),
                  trim(:w_ParmDS.w_SrcPf),
                  trim(:w_ParmDS.w_SrcMbr),
                  trim(:w_ParmDS.w_IfsLoc),                                              //0033
                  trim(:SeqNo),
                  trim(:w_ParmDS.w_RRNStr),
                  'CPYTOSTMF',
                  trim(:REFACT1));
      Endif;
   Endfor;

   if SQLSTATE <> SQL_ALL_OK;
      //log error
   endif;

   return;
end-proc;

dcl-proc IAPRADDPFM export;
   dcl-pi *n;
      in_ParmPointer pointer;
      in_MbrTyp1     Char(10) CONST;                                                      //AK11
   end-pi;

   dcl-ds w_IAPGMFILES extName('IAPGMFILES') qualified inz end-ds;
   dcl-ds w_ParmDS qualified based(in_ParmPointer);
      w_String     char(5000);
      w_Error      char(10);
      w_Repository char(10);
      w_SrcLib     char(10);
      w_SrcPf      char(10);
      w_SrcMbr     char(10);
      w_IfsLoc     char(100);                                                            //0033
      w_RRNStr     packed(6:0);
      w_RRNEnd     packed(6:0);
   end-ds;

   dcl-s w_ClStatement char(5000)          inz;
   dcl-s w_WordsArray  char(120)  dim(100) inz;
   dcl-s w_FileKeyPos  char(100)           inz;
   dcl-s w_LibName     char(10)            inz;                                           //AK11

   clear w_IAPGMFILES;
   w_ClStatement          = w_ParmDS.w_String;
   w_IAPGMFILES.IAMBRNAME  = w_ParmDS.w_SrcMbr;                                          //0031
   w_IAPGMFILES.IASRCFILE  = w_ParmDS.w_SrcPf;                                           //0031
   w_IAPGMFILES.IALIBNAM   = w_ParmDS.w_SrcLib;                                          //0031
   w_IAPGMFILES.IAIFSLOC   = w_ParmDS.w_IfsLoc;                                          //0033

   if w_ClStatement = *Blanks;
      return;
   endif;

   GetWordsInArray(w_ClStatement : w_WordsArray);

   w_FileKeyPos = scanKeyword(' FILE(':w_ClStatement);

   if w_FileKeyPos = *blanks;
      w_FileKeyPos = w_WordsArray(2);
   endif;

   if %scan('/':w_FileKeyPos) > 1 and                                                      //PS01
      %len(w_FileKeyPos) > %scan('/':w_FileKeyPos);                                        //PS01
      w_LibName    = %subst(w_FileKeyPos:1:%scan('/':w_FileKeyPos)-1);                    //AK11
      w_FileKeyPos = %subst(w_FileKeyPos:%scan('/':w_FileKeyPos)+1:
                                         %len(w_FileKeyPos) - %scan('/':w_FileKeyPos));
   else;                                                                                  //AK11
      w_LibName    = *Blanks;                                                             //AK11
   endif;

// exec sql                                                                              //0034
//    insert into IAPGMFILES (IALIBNAM,                                            //0034//0031
//                            IASRCFILE,                                           //0034//0031
//                            IAMBRNAME,                                           //0034//0031
//                            IAIFSLOC,                                            //0034//0033
//                            IAACTFILE)                                           //0034//0031
//      values(trim(:w_IAPGMFILES.IALIBNAM),                                       //0034//0031
//             trim(:w_IAPGMFILES.IASRCFILE),                                      //0034//0031
//             trim(:w_IAPGMFILES.IAMBRNAME),                                      //0034//0031
//             trim(:w_IAPGMFILES.IAIFSLOC),                                       //0034//0033
//             trim(:w_FileKeyPos));                                               //0034//0031

// if SQLSTATE <> SQL_ALL_OK;                                                            //0034
//    //log error                                                                       //0034
// endif;                                                                                //0034
   //Write source intermediate reference detail file                                    //AK11
   WrtSrcIntRefF(w_IAPGMFILES.IALIBNAM                                                   //0031
                :w_IAPGMFILES.IASRCFILE                                                  //0031
                :w_IAPGMFILES.IAMBRNAME                                                  //0031
                :w_IAPGMFILES.IAIFSLOC                                                   //0033
                :in_MbrTyp1                                                               //AK11
                :w_FileKeyPos                                                             //AK11
                :'*FILE'                                                                  //AK11
                :w_LibName                                                                //AK11
              //:1                                                                  //AK11//0023
                :'I'                                                                      //0023
                :'CLP'                                                                    //AK11
                );                                                                        //AK11

   return;
end-proc;

dcl-proc IAPRCHGLF export;
   dcl-pi *n;
      in_ParmPointer pointer;
   end-pi;

   dcl-ds w_IAPGMFILES extName('IAPGMFILES') qualified inz end-ds;
   dcl-ds w_ParmDS qualified based(in_ParmPointer);
      w_String     char(5000);
      w_Error      char(10);
      w_Repository char(10);
      w_SrcLib     char(10);
      w_SrcPf      char(10);
      w_SrcMbr     char(10);
      w_RRNStr     packed(6:0);
      w_RRNEnd     packed(6:0);
   end-ds;

   dcl-s w_ClStatement char(5000)          inz;
   dcl-s w_WordsArray  char(120)  dim(100) inz;
   dcl-s w_FileKeyPos  char(5000)          inz;

   clear w_IAPGMFILES;
   w_ClStatement          = w_ParmDS.w_String;
   w_IAPGMFILES.IAMBRNAME  = w_ParmDS.w_SrcMbr;                                          //0031
   w_IAPGMFILES.IASRCFILE  = w_ParmDS.w_SrcPf;                                           //0031
   w_IAPGMFILES.IALIBNAM   = w_ParmDS.w_SrcLib;                                          //0031

   if w_ClStatement = *Blanks;
      return;
   endif;

   GetWordsInArray(w_ClStatement : w_WordsArray);

   w_FileKeyPos = scanKeyword(' FILE(':w_ClStatement);

   if w_FileKeyPos = *blanks;
      w_FileKeyPos = w_WordsArray(2);
   endif;

   if %scan('/':w_FileKeyPos) > 0 and                                               //PS01
      %len(w_FileKeyPos) > %scan('/':w_FileKeyPos);                                 //PS01
      w_FileKeyPos = %subst(w_FileKeyPos:%scan('/':w_FileKeyPos)+1:
                                         %len(w_FileKeyPos) - %scan('/':w_FileKeyPos));
   endif;

 //exec sql                                                                              //0034
 //   insert into IAPGMFILES (IALIBNAM,                                            //0034//0031
 //                           IASRCFILE,                                           //0034//0031
 //                           IAMBRNAME,                                           //0034//0031
 //                           IAACTFILE)                                           //0034//0031
 //     values(trim(:w_IAPGMFILES.IALIBNAM),                                       //0034//0031
 //            trim(:w_IAPGMFILES.IASRCFILE),                                      //0034//0031
 //            trim(:w_IAPGMFILES.IAMBRNAME),                                      //0034//0031
 //            trim(:w_FileKeyPos));                                               //0034//0031

 //if SQLSTATE <> SQL_ALL_OK;                                                            //0034
 //   //log error                                                                       //0034
 //endif;                                                                                //0034

   return;
end-proc;

dcl-proc IAPRCHGLFM export;
   dcl-pi *n;
      in_ParmPointer pointer;
   end-pi;

   dcl-ds w_IAPGMFILES extName('IAPGMFILES') qualified inz end-ds;
   dcl-ds w_ParmDS qualified based(in_ParmPointer);
      w_String     char(5000);
      w_Error      char(10);
      w_Repository char(10);
      w_SrcLib     char(10);
      w_SrcPf      char(10);
      w_SrcMbr     char(10);
      w_RRNStr     packed(6:0);
      w_RRNEnd     packed(6:0);
   end-ds;

   dcl-s w_ClStatement char(5000)          inz;
   dcl-s w_WordsArray  char(120)  dim(100) inz;
   dcl-s w_FileTemp    char(5000)          inz;

   clear w_IAPGMFILES;
   w_ClStatement          = w_ParmDS.w_String;
   w_IAPGMFILES.IAMBRNAME  = w_ParmDS.w_SrcMbr;                                          //0031
   w_IAPGMFILES.IASRCFILE  = w_ParmDS.w_SrcPf;                                           //0031
   w_IAPGMFILES.IALIBNAM   = w_ParmDS.w_SrcLib;                                          //0031

   if w_ClStatement = *Blanks;
      return;
   endif;

   GetWordsInArray(w_ClStatement : w_WordsArray);

   w_FileTemp = scanKeyword(' FILE(':w_ClStatement);

   if w_FileTemp = *blanks;
      w_Filetemp = w_WordsArray(2);
   endif;

   if %scan('/':w_FileTemp) > 0 and                                           //PS01
      %len(w_FileTemp) > %scan('/':w_FileTemp);                               //PS01
      w_FileTemp = %subst(w_FileTemp:%scan('/':w_FileTemp)+1:
                                     %len(w_FileTemp) - %scan('/':w_FileTemp));
   endif;

 //exec sql                                                                              //0034
 //   insert into IAPGMFILES (IALIBNAM,                                            //0034//0031
 //                           IASRCFILE,                                           //0034//0031
 //                           IAMBRNAME,                                           //0034//0031
 //                           IAACTFILE)                                           //0034//0031
 //     values(trim(:w_IAPGMFILES.IALIBNAM),                                       //0034//0031
 //            trim(:w_IAPGMFILES.IASRCFILE),                                      //0034//0031
 //            trim(:w_IAPGMFILES.IAMBRNAME),                                      //0034//0031
 //            trim(:w_FileTemp));                                                 //0034//0031

 //if SQLSTATE <> SQL_ALL_OK;                                                            //0034
 //   //log error                                                                       //0034
 //endif;                                                                                //0034

   return;
end-proc;

dcl-proc IAPRCHGPF export;
   dcl-pi *n;
      in_ParmPointer pointer;
   end-pi;

   dcl-ds w_IAPGMFILES extName('IAPGMFILES') qualified inz end-ds;
   dcl-ds w_ParmDS qualified based(in_ParmPointer);
      w_String     char(5000);
      w_Error      char(10);
      w_Repository char(10);
      w_SrcLib     char(10);
      w_SrcPf      char(10);
      w_SrcMbr     char(10);
      w_RRNStr     packed(6:0);
      w_RRNEnd     packed(6:0);
   end-ds;

   dcl-s w_ClStatement char(5000)          inz;
   dcl-s w_WordsArray  char(120)  dim(100) inz;
   dcl-s w_FileTemp    char(5000)          inz;

   clear w_IAPGMFILES;
   w_ClStatement          = w_ParmDS.w_String;
   w_IAPGMFILES.IAMBRNAME  = w_ParmDS.w_SrcMbr;                                          //0031
   w_IAPGMFILES.IASRCFILE  = w_ParmDS.w_SrcPf;                                           //0031
   w_IAPGMFILES.IALIBNAM   = w_ParmDS.w_SrcLib;                                          //0031

   if w_ClStatement = *Blanks;
      return;
   endif;

   GetWordsInArray(w_ClStatement : w_WordsArray);

   w_FileTemp = scanKeyword(' FILE(':w_ClStatement);

   if w_FileTemp = *blanks;
      w_Filetemp = w_WordsArray(2);
   endif;

   if %scan('/':w_FileTemp) > 0 and                                           //PS01
      %len(w_FileTemp) > %scan('/':w_FileTemp);                               //PS01
      w_FileTemp = %subst(w_FileTemp:%scan('/':w_FileTemp)+1:
                                     %len(w_FileTemp) - %scan('/':w_FileTemp));
   endif;

// exec sql                                                                              //0034
//    insert into IAPGMFILES (IALIBNAM,                                            //0034//0031
//                            IASRCFILE,                                           //0034//0031
//                            IAMBRNAME,                                           //0034//0031
//                            IAACTFILE)                                           //0034//0031
//      values(trim(:w_IAPGMFILES.IALIBNAM),                                       //0034//0031
//             trim(:w_IAPGMFILES.IASRCFILE),                                      //0034//0031
//             trim(:w_IAPGMFILES.IAMBRNAME),                                      //0034//0031
//             trim(:w_FileTemp));                                                 //0034//0031

// if SQLSTATE <> SQL_ALL_OK;                                                            //0034
//    //log error                                                                       //0034
// endif;                                                                                //0034

   return;
end-proc;

dcl-proc IAPRCHGPFCST export;
   dcl-pi *n;
      in_ParmPointer pointer;
   end-pi;

   dcl-ds w_IAPGMFILES extName('IAPGMFILES') qualified inz end-ds;
   dcl-ds w_ParmDS qualified based(in_ParmPointer);
      w_String     char(5000);
      w_Error      char(10);
      w_Repository char(10);
      w_SrcLib     char(10);
      w_SrcPf      char(10);
      w_SrcMbr     char(10);
      w_RRNStr     packed(6:0);
      w_RRNEnd     packed(6:0);
   end-ds;

   dcl-s w_ClStatement char(5000)          inz;
   dcl-s w_WordsArray  char(120)  dim(100) inz;
   dcl-s w_FileKeyPos  char(5000)          inz;

   clear w_IAPGMFILES;
   w_ClStatement          = w_ParmDS.w_String;
   w_IAPGMFILES.IAMBRNAME  = w_ParmDS.w_SrcMbr;                                          //0031
   w_IAPGMFILES.IASRCFILE  = w_ParmDS.w_SrcPf;                                           //0031
   w_IAPGMFILES.IALIBNAM   = w_ParmDS.w_SrcLib;                                          //0031

   if w_ClStatement = *Blanks;
      return;
   endif;

   GetWordsInArray(w_ClStatement : w_WordsArray);
   w_FileKeyPos = scanKeyword(' FILE(':w_ClStatement);

   if w_FileKeyPos = *blanks;
      w_FileKeyPos = w_WordsArray(2);
   endif;

   if %scan('/':w_FileKeyPos) > 0 and                                               //PS01
      %len(w_FileKeyPos) > %scan('/':w_FileKeyPos);                                 //PS01
      w_FileKeyPos = %subst(w_FileKeyPos:%scan('/':w_FileKeyPos)+1:
                                         %len(w_FileKeyPos) - %scan('/':w_FileKeyPos));
   endif;

// exec sql                                                                              //0034
//    insert into IAPGMFILES (IALIBNAM,                                            //0034//0031
//                            IASRCFILE,                                           //0034//0031
//                            IAMBRNAME,                                           //0034//0031
//                            IAACTFILE)                                           //0034//0031
//      values(trim(:w_IAPGMFILES.IALIBNAM),                                       //0034//0031
//             trim(:w_IAPGMFILES.IASRCFILE),                                      //0034//0031
//             trim(:w_IAPGMFILES.IAMBRNAME),                                      //0034//0031
//             trim(:w_FileKeyPos));                                               //0034//0031

// if SQLSTATE <> SQL_ALL_OK;                                                            //0034
//    //log error                                                                       //0034
// endif;                                                                                //0034

   return;
end-proc;

dcl-proc IAPRCHGPFM export;
   dcl-pi *n;
      in_ParmPointer pointer;
   end-pi;

   dcl-ds w_IAPGMFILES extName('IAPGMFILES') qualified inz end-ds;
   dcl-ds w_ParmDS qualified based(in_ParmPointer);
      w_String     char(5000);
      w_Error      char(10);
      w_Repository char(10);
      w_SrcLib     char(10);
      w_SrcPf      char(10);
      w_SrcMbr     char(10);
      w_RRNStr     packed(6:0);
      w_RRNEnd     packed(6:0);
   end-ds;

   dcl-s w_ClStatement char(5000)          inz;
   dcl-s w_WordsArray  char(120)  dim(100) inz;
   dcl-s w_FileKeyPos  char(5000)          inz;

   clear w_IAPGMFILES;
   w_ClStatement          = w_ParmDS.w_String;
   w_IAPGMFILES.IAMBRNAME  = w_ParmDS.w_SrcMbr;                                          //0031
   w_IAPGMFILES.IASRCFILE  = w_ParmDS.w_SrcPf;                                           //0031
   w_IAPGMFILES.IALIBNAM   = w_ParmDS.w_SrcLib;                                          //0031

   if w_ClStatement = *Blanks;
      return;
   endif;

   GetWordsInArray(w_ClStatement : w_WordsArray);

   w_FileKeyPos = scanKeyword(' FILE(':w_ClStatement);

   if w_FileKeyPos = *blanks;
      w_FileKeyPos = w_WordsArray(2);
   endif;

   if %scan('/':w_FileKeyPos) > 0 and                                                //PS01
      %len(w_FileKeyPos) > %scan('/':w_FileKeyPos);                                  //PS01
      w_FileKeyPos = %subst(w_FileKeyPos:%scan('/':w_FileKeyPos)+1:
                                         %len(w_FileKeyPos) - %scan('/':w_FileKeyPos));
   endif;

// exec sql                                                                              //0034
//    insert into IAPGMFILES (IALIBNAM,                                            //0034//0031
//                            IASRCFILE,                                           //0034//0031
//                            IAMBRNAME,                                           //0034//0031
//                            IAACTFILE)                                           //0034//0031
//      values(trim(:w_IAPGMFILES.IALIBNAM),                                       //0034//0031
//             trim(:w_IAPGMFILES.IASRCFILE),                                      //0034//0031
//             trim(:w_IAPGMFILES.IAMBRNAME),                                      //0034//0031
//             trim(:w_FileKeyPos));                                               //0034//0031

// if SQLSTATE <> SQL_ALL_OK;                                                            //0034
//    //log error                                                                       //0034
// endif;                                                                                //0034

   return;
end-proc;

dcl-proc IAPRCHGPFTRG export;
   dcl-pi *n;
      in_ParmPointer pointer;
   end-pi;

   dcl-ds w_IAPGMFILES extName('IAPGMFILES') qualified inz end-ds;
   dcl-ds w_ParmDS qualified based(in_ParmPointer);
      w_String     char(5000);
      w_Error      char(10);
      w_Repository char(10);
      w_SrcLib     char(10);
      w_SrcPf      char(10);
      w_SrcMbr     char(10);
      w_RRNStr     packed(6:0);
      w_RRNEnd     packed(6:0);
   end-ds;

   dcl-s w_ClStatement char(5000)          inz;
   dcl-s w_WordsArray  char(120)  dim(100) inz;
   dcl-s w_FileKeyPos  char(5000)          inz;

   clear w_IAPGMFILES;
   w_ClStatement          = w_ParmDS.w_String;
   w_IAPGMFILES.IAMBRNAME  = w_ParmDS.w_SrcMbr;                                          //0031
   w_IAPGMFILES.IASRCFILE  = w_ParmDS.w_SrcPf;                                           //0031
   w_IAPGMFILES.IALIBNAM   = w_ParmDS.w_SrcLib;                                          //0031

   if w_ClStatement = *Blanks;
      return;
   endif;

   GetWordsInArray(w_ClStatement : w_WordsArray);

   w_FileKeyPos = scanKeyword(' FILE(':w_ClStatement);

   if w_FileKeyPos = *blanks;
      w_FileKeyPos = w_WordsArray(2);
   endif;

   if %scan('/':w_FileKeyPos) > 0 and                                               //PS01
      %len(w_FileKeyPos) > %scan('/':w_FileKeyPos);                                 //PS01
      w_FileKeyPos = %subst(w_FileKeyPos:%scan('/':w_FileKeyPos)+1:
                                         %len(w_FileKeyPos) - %scan('/':w_FileKeyPos));
   endif;

 //exec sql                                                                              //0034
 //   insert into IAPGMFILES (IALIBNAM,                                            //0034//0031
 //                           IASRCFILE,                                           //0034//0031
 //                           IAMBRNAME,                                           //0034//0031
 //                           IAACTFILE)                                           //0034//0031
 //     values(trim(:w_IAPGMFILES.IALIBNAM),                                       //0034//0031
 //            trim(:w_IAPGMFILES.IASRCFILE),                                      //0034//0031
 //            trim(:w_IAPGMFILES.IAMBRNAME),                                      //0034//0031
 //            trim(:w_FileKeyPos));                                               //0034//0031

 //if SQLSTATE <> SQL_ALL_OK;                                                            //0034
 //   //log error                                                                       //0034
 //endif;                                                                                //0034

   return;
end-proc;

dcl-proc IAPRCHGPRTF export;
   dcl-pi *n;
      in_ParmPointer pointer;
   end-pi;

   dcl-ds w_IAPGMFILES extName('IAPGMFILES') qualified inz end-ds;
   dcl-ds w_ParmDS qualified based(in_ParmPointer);
      w_String     char(5000);
      w_Error      char(10);
      w_Repository char(10);
      w_SrcLib     char(10);
      w_SrcPf      char(10);
      w_SrcMbr     char(10);
      w_RRNStr     packed(6:0);
      w_RRNEnd     packed(6:0);
   end-ds;

   dcl-s w_ClStatement char(5000)          inz;
   dcl-s w_WordsArray  char(120)  dim(100) inz;
   dcl-s w_FileKeyPos  char(5000)          inz;

   clear w_IAPGMFILES;
   w_ClStatement          = w_ParmDS.w_String;
   w_IAPGMFILES.IAMBRNAME  = w_ParmDS.w_SrcMbr;                                          //0031
   w_IAPGMFILES.IASRCFILE  = w_ParmDS.w_SrcPf;                                           //0031
   w_IAPGMFILES.IALIBNAM   = w_ParmDS.w_SrcLib;                                          //0031

   if w_ClStatement = *Blanks;
      return;
   endif;

   GetWordsInArray(w_ClStatement : w_WordsArray);

   w_FileKeyPos = scanKeyword(' FILE(':w_ClStatement);

   if w_FileKeyPos = *blanks;
      w_FileKeyPos = w_WordsArray(2);
   endif;

   if %scan('/':w_FileKeyPos) > 0 and                                          //PS01
      %len(w_FileKeyPos) > %scan('/':w_FileKeyPos);                            //PS01
      w_FileKeyPos = %subst(w_FileKeyPos:%scan('/':w_FileKeyPos)+1:
                                         %len(w_FileKeyPos) - %scan('/':w_FileKeyPos));
   endif;

 //exec sql                                                                              //0034
 //   insert into IAPGMFILES (IALIBNAM,                                            //0034//0031
 //                           IASRCFILE,                                           //0034//0031
 //                           IAMBRNAME,                                           //0034//0031
 //                           IAACTFILE)                                           //0034//0031
 //     values(trim(:w_IAPGMFILES.IALIBNAM),                                       //0034//0031
 //            trim(:w_IAPGMFILES.IASRCFILE),                                      //0034//0031
 //            trim(:w_IAPGMFILES.IAMBRNAME),                                      //0034//0031
 //            trim(:w_FileKeyPos));                                               //0034//0031

 //if SQLSTATE <> SQL_ALL_OK;                                                            //0034
 //   //log error                                                                       //0034
 //endif;                                                                                //0034

   return;
end-proc;

dcl-proc IAPRCLRPFM export;
   dcl-pi *n;
      in_ParmPointer pointer;
      in_MbrTyp1     char(10) CONST ;                                                     //AK11
   end-pi;

   dcl-ds w_IAPGMFILES extName('IAPGMFILES') qualified inz end-ds;
   dcl-ds w_ParmDS qualified based(in_ParmPointer);
      w_String     char(5000);
      w_Error      char(10);
      w_Repository char(10);
      w_SrcLib     char(10);
      w_SrcPf      char(10);
      w_SrcMbr     char(10);
      w_IfsLoc     char(100);                                                             //0033
      w_RRNStr     packed(6:0);
      w_RRNEnd     packed(6:0);
   end-ds;

   dcl-s w_ClStatement char(5000)          inz;
   dcl-s w_WordsArray  char(120)  dim(100) inz;
   dcl-s w_FileKeyPos  char(100)           inz;
   dcl-s w_LibName     char(10)            inz;                                           //AK11
   dcl-s s_pos         packed(4:0)         inz;
   dcl-s f_len         packed(4:0)         inz;

   clear w_IAPGMFILES;
   w_ClStatement          = w_ParmDS.w_String;
   w_IAPGMFILES.IAMBRNAME  = w_ParmDS.w_SrcMbr;                                          //0031
   w_IAPGMFILES.IASRCFILE  = w_ParmDS.w_SrcPf;                                           //0031
   w_IAPGMFILES.IALIBNAM   = w_ParmDS.w_SrcLib;                                          //0031
   w_IAPGMFILES.IAIFSLOC   = w_ParmDS.w_IfsLoc;                                          //0033

   if w_ClStatement = *Blanks;
      return;
   endif;

   GetWordsInArray(w_ClStatement : w_WordsArray);

   w_FileKeyPos = scanKeyword(' FILE(':w_ClStatement);

   if w_FileKeyPos = *blanks;
      w_FileKeyPos = w_WordsArray(2);
   endif;

   s_pos = %scan('/':w_FileKeyPos);
   f_len = %len(w_FileKeyPos);
   if s_pos > 1 and f_len > s_pos;                                                        //PS01
      w_LibName    = %subst(w_FileKeyPos:1:s_pos-1);                                      //AK11
      w_FileKeyPos = %subst(w_FileKeyPos:s_pos+1:f_len-s_pos);
   else;                                                                                  //AK11
      w_LibName    = *Blanks;                                                             //AK11
   endif;

 //exec sql                                                                              //0034
 //   insert into IAPGMFILES (IALIBNAM,                                            //0034//0031
 //                           IASRCFILE,                                           //0034//0031
 //                           IAMBRNAME,                                           //0034//0031
 //                           IAIFSLOC,                                            //0034//0033
 //                           IAACTFILE)                                           //0034//0031
 //     values(trim(:w_IAPGMFILES.IALIBNAM),                                       //0034//0031
 //            trim(:w_IAPGMFILES.IASRCFILE),                                      //0034//0031
 //            trim(:w_IAPGMFILES.IAMBRNAME),                                      //0034//0031
 //            trim(:w_IAPGMFILES.IAIFSLOC),                                       //0034//0033
 //            trim(:w_FileKeyPos));                                               //0034//0031

 //if SQLSTATE <> SQL_ALL_OK;                                                            //0034
 //   //log error                                                                       //0034
 //endif;                                                                                //0034
   //Write source intermediate reference detail file                                     //AK11
   WrtSrcIntRefF(w_IAPGMFILES.IALIBNAM                                                   //0031
                :w_IAPGMFILES.IASRCFILE                                                  //0031
                :w_IAPGMFILES.IAMBRNAME                                                  //0031
                :w_IAPGMFILES.IAIFSLOC                                                   //0033
                :in_MbrTyp1                                                               //AK11
                :w_FileKeyPos                                                             //AK11
                :'*FILE'                                                                  //AK11
                :w_LibName                                                                //AK11
              //:4                                                                  //AK11//0023
                :'U'                                                                      //0023
                :'CLP'                                                                    //AK11
                );                                                                        //AK11

   return;
end-proc;

dcl-proc IAPRCPYF export;
   dcl-pi *n;
      in_ParmPointer pointer;
      in_MbrTyp1     char(10) Const;                                                      //AK12
   end-pi;

   dcl-ds w_IAPGMFILES extName('IAPGMFILES') qualified inz end-ds;
   dcl-ds w_ParmDS qualified based(in_ParmPointer);
      w_String     char(5000);
      w_Error      char(10);
      w_Repository char(10);
      w_SrcLib     char(10);
      w_SrcPf      char(10);
      w_SrcMbr     char(10);
      w_IfsLoc     char(100);                                                             //0033
      w_RRNStr     packed(6:0);
      w_RRNEnd     packed(6:0);
   end-ds;

   dcl-s w_ClStatement char(5000)          inz;
   dcl-s w_WordsArray  char(120)  dim(100) inz;
   dcl-s w_FileName    char(100)           inz;
   dcl-s w_FileTemp    char(100)           inz;
   dcl-s w_Count       zoned(4:0)          inz(1);
   dcl-s w_LibName     char(10)            inz;                                           //AK12
   dcl-s s_pos         packed(4:0)         inz;
   dcl-s f_len         packed(4:0)         inz;

   clear w_IAPGMFILES;
   w_ClStatement          = w_ParmDS.w_String;
   w_IAPGMFILES.IAMBRNAME  = w_ParmDS.w_SrcMbr;                                          //0031
   w_IAPGMFILES.IASRCFILE  = w_ParmDS.w_SrcPf;                                           //0031
   w_IAPGMFILES.IALIBNAM   = w_ParmDS.w_SrcLib;                                          //0031
   w_IAPGMFILES.IAIFSLOC   = w_ParmDS.w_IfsLoc;                                          //0033

   if w_ClStatement = *Blanks;
      return;
   endif;

   GetWordsInArray(w_ClStatement : w_WordsArray);

   w_FileName = scanKeyword(' FROMFILE(':w_ClStatement);
   if w_FileName = *blanks;
      w_FileName = w_WordsArray(1);
   endif;

   s_pos = %scan('/':w_FileName);
   f_len = %len(w_Filename);
   if s_pos > 1 and f_len > s_pos;
      w_LibName = %subst(w_FileName:1:s_pos-1);
      w_IAPGMFILES.IAACTFILE = %subst(w_FileName:s_pos+1:f_len-s_pos);                   //0031
   else;
      w_LibName = *Blanks;
      w_IAPGMFILES.IAACTFILE = w_FileName;                                               //0031
   endif;

 //exec sql                                                                              //0034
 //   insert into IAPGMFILES (IALIBNAM,                                            //0034//0031
 //                           IASRCFILE,                                           //0034//0031
 //                           IAMBRNAME,                                           //0034//0031
 //                           IAIFSLOC,                                            //0034//0033
 //                           IAACTFILE,                                           //0034//0031
 //                           IAACTRCDNM)                                          //0034//0031
 //     values(trim(:w_IAPGMFILES.IALIBNAM),                                       //0034//0031
 //            trim(:w_IAPGMFILES.IASRCFILE),                                      //0034//0031
 //            trim(:w_IAPGMFILES.IAMBRNAME),                                      //0034//0031
 //            trim(:w_IAPGMFILES.IAIFSLOC),                                       //0034//0033
 //            trim(:w_IAPGMFILES.IAACTFILE),                                      //0034//0031
 //            trim(:w_IAPGMFILES.IAACTRCDNM));                                    //0034//0031

   //Write source intermediate reference detail file
   WrtSrcIntRefF(w_IAPGMFILES.IALIBNAM                                                   //0031
                :w_IAPGMFILES.IASRCFILE                                                  //0031
                :w_IAPGMFILES.IAMBRNAME                                                  //0031
                :w_IAPGMFILES.IAIFSLOC                                                   //0033
                :in_MbrTyp1                                                              //0031
                :w_IAPGMFILES.IAACTFILE                                                  //0031
                :'*FILE'
                :w_LibName
                :'I'                                                                     //0023
                :'CLP'
                );
   w_FileName = scanKeyword(' TOFILE(':w_ClStatement);
   if w_FileName = *blanks;
      w_FileName = w_WordsArray(1);
   endif;

   s_pos = %scan('/':w_FileName);
   f_len = %len(w_Filename);
   if s_pos > 1 and f_len > s_pos;
      w_LibName = %subst(w_FileName:1:s_pos-1);
      w_IAPGMFILES.IAACTFILE = %subst(w_FileName:s_pos+1:f_len-s_pos);                   //0031
   else;
      w_LibName = *Blanks;
      w_IAPGMFILES.IAACTFILE = w_FileName;                                               //0031
   endif;

   //Write source intermediate reference detail file
   WrtSrcIntRefF(w_IAPGMFILES.IALIBNAM                                                   //0031
                :w_IAPGMFILES.IASRCFILE                                                  //0031
                :w_IAPGMFILES.IAMBRNAME                                                  //0031
                :w_IAPGMFILES.IAIFSLOC                                                   //0033
                :in_MbrTyp1                                                              //0031
                :w_IAPGMFILES.IAACTFILE                                                  //0031
                :'*FILE'
                :w_LibName
                :'O'                                                                     //0023
                :'CLP'
                );

 //exec sql                                                                              //0034
 //   insert into IAPGMFILES (IALIBNAM,                                            //0034//0031
 //                           IASRCFILE,                                           //0034//0031
 //                           IAMBRNAME,                                           //0034//0031
 //                           IAIFSLOC,                                            //0034//0033
 //                           IAACTFILE,                                           //0034//0031
 //                           IAACTRCDNM)                                          //0034//0031
 //     values(trim(:w_IAPGMFILES.IALIBNAM),                                       //0034//0031
 //            trim(:w_IAPGMFILES.IASRCFILE),                                      //0034//0031
 //            trim(:w_IAPGMFILES.IAMBRNAME),                                      //0034//0031
 //            trim(:w_IAPGMFILES.IAIFSLOC),                                       //0034//0033
 //            trim(:w_IAPGMFILES.IAACTFILE),                                      //0034//0031
 //            trim(:w_IAPGMFILES.IAACTRCDNM));                                    //0034//0031
   return;
end-proc;

dcl-proc IAPRCRTDSPF export;
   dcl-pi *n;
      in_ParmPointer pointer;
   end-pi;

   dcl-ds w_IAPGMFILES extName('IAPGMFILES') qualified inz end-ds;
   dcl-ds w_ParmDS qualified based(in_ParmPointer);
      w_String     char(5000);
      w_Error      char(10);
      w_Repository char(10);
      w_SrcLib     char(10);
      w_SrcPf      char(10);
      w_SrcMbr     char(10);
      w_IfsLoc     char(100);                                                            //0033
      w_RRNStr     packed(6:0);
      w_RRNEnd     packed(6:0);
   end-ds;

   dcl-s w_ClStatement char(5000)          inz;
   dcl-s w_WordsArray  char(120)  dim(100) inz;
   dcl-s w_FileKeyPos  char(5000)          inz;
   dcl-s f_len         packed(4:0)         inz;
   dcl-s s_pos         packed(4:0)         inz;

   clear w_IAPGMFILES;
   w_ClStatement          = w_ParmDS.w_String;
   w_IAPGMFILES.IAMBRNAME  = w_ParmDS.w_SrcMbr;                                          //0031
   w_IAPGMFILES.IASRCFILE  = w_ParmDS.w_SrcPf;                                           //0031
   w_IAPGMFILES.IALIBNAM   = w_ParmDS.w_SrcLib;                                          //0031
   w_IAPGMFILES.IAIFSLOC   = w_ParmDS.w_IfsLoc;                                          //0033

   if w_ClStatement = *Blanks;
      return;
   endif;

   GetWordsInArray(w_ClStatement : w_WordsArray);

   w_FileKeyPos = scanKeyword(' FILE(':w_ClStatement);

   if w_FileKeyPos = *blanks;
      w_FileKeyPos = w_WordsArray(2);
   endif;

   s_pos = %scan('/':w_FileKeyPos);
   f_len = %len(w_FileKeyPos);
   if s_pos > 0 and f_len > s_pos;                                             //PS01
      w_FileKeyPos = %subst(w_FileKeyPos:s_pos+1:f_len-s_pos);
   endif;

 //exec sql                                                                              //0034
 //   insert into IAPGMFILES (IALIBNAM,                                            //0034//0031
 //                           IASRCFILE,                                           //0034//0031
 //                           IAMBRNAME,                                           //0034//0031
 //                           IAIFSLOC,                                            //0034//0033
 //                           IAACTFILE)                                           //0034//0031
 //     values(trim(:w_IAPGMFILES.IALIBNAM),                                       //0034//0031
 //            trim(:w_IAPGMFILES.IASRCFILE),                                      //0034//0031
 //            trim(:w_IAPGMFILES.IAMBRNAME),                                      //0034//0031
 //            trim(:w_IAPGMFILES.IAIFSLOC),                                       //0034//0033
 //            trim(:w_FileKeyPos));                                               //0034//0031

 //if SQLSTATE <> SQL_ALL_OK;                                                            //0034
 //   //log error                                                                       //0034
 //endif;                                                                                //0034

   return;
end-proc;

dcl-proc IAPRCRTLF export;
   dcl-pi *n;
      in_ParmPointer pointer;
   end-pi;

   dcl-ds w_IAPGMFILES extName('IAPGMFILES') qualified inz end-ds;
   dcl-ds w_ParmDS qualified based(in_ParmPointer);
      w_String     char(5000);
      w_Error      char(10);
      w_Repository char(10);
      w_SrcLib     char(10);
      w_SrcPf      char(10);
      w_SrcMbr     char(10);
      w_IfsLoc     char(100);                                                            //0033
      w_RRNStr     packed(6:0);
      w_RRNEnd     packed(6:0);
   end-ds;

   dcl-s w_ClStatement char(5000)          inz;
   dcl-s w_WordsArray  char(120)  dim(100) inz;
   dcl-s w_FileKeyPos  char(5000)          inz;
   dcl-s s_pos         packed(4:0)         inz;
   dcl-s f_len         packed(4:0)         inz;

   clear w_IAPGMFILES;
   w_ClStatement          = w_ParmDS.w_String;
   w_IAPGMFILES.IAMBRNAME  = w_ParmDS.w_SrcMbr;                                          //0031
   w_IAPGMFILES.IASRCFILE  = w_ParmDS.w_SrcPf;                                           //0031
   w_IAPGMFILES.IALIBNAM   = w_ParmDS.w_SrcLib;                                          //0031
   w_IAPGMFILES.IAIFSLOC   = w_ParmDS.w_IfsLoc;                                          //0033

   if w_ClStatement = *Blanks;
      return;
   endif;

   GetWordsInArray(w_ClStatement : w_WordsArray);

   w_FileKeyPos = scanKeyword(' FILE(':w_ClStatement);

   if w_FileKeyPos = *blanks;
      w_FileKeyPos = w_WordsArray(2);
   endif;

   s_pos = %scan('/':w_FileKeyPos);
   f_len = %len(w_FileKeyPos);
   if s_pos > 0 and f_len > s_pos;                                             //PS01
      w_FileKeyPos = %subst(w_FileKeyPos:s_pos+1:f_len-s_pos);
   endif;

 //exec sql                                                                              //0034
 //   insert into IAPGMFILES (IALIBNAM,                                            //0034//0031
 //                           IASRCFILE,                                           //0034//0031
 //                           IAMBRNAME,                                           //0034//0031
 //                           IAIFSLOC,                                            //0034//0033
 //                           IAACTFILE)                                           //0034//0031
 //     values(trim(:w_IAPGMFILES.IALIBNAM),                                       //0034//0031
 //            trim(:w_IAPGMFILES.IASRCFILE),                                      //0034//0031
 //            trim(:w_IAPGMFILES.IAMBRNAME),                                      //0034//0031
 //            trim(:w_IAPGMFILES.IAIFSLOC),                                       //0034//0033
 //            trim(:w_FileKeyPos));                                               //0034//0031

 //if SQLSTATE <> SQL_ALL_OK;                                                            //0034
 //   //log error                                                                       //0034
 //endif;                                                                                //0034

   return;
end-proc;

dcl-proc IAPRCRTPF export;
   dcl-pi *n;
      in_ParmPointer pointer;
      in_MbrTyp1     char(10) const;                                                      //AK12
   end-pi;

   dcl-ds w_IAPGMFILES extName('IAPGMFILES') qualified inz end-ds;
   dcl-ds w_ParmDS qualified based(in_ParmPointer);
      w_String     char(5000);
      w_Error      char(10);
      w_Repository char(10);
      w_SrcLib     char(10);
      w_SrcPf      char(10);
      w_SrcMbr     char(10);
      w_IfsLoc     char(100);                                                            //0033
      w_RRNStr     packed(6:0);
      w_RRNEnd     packed(6:0);
   end-ds;

   dcl-s w_ClStatement char(5000)          inz;
   dcl-s w_WordsArray  char(120)  dim(100) inz;
   dcl-s w_FileKeyPos  char(5000)          inz;
   dcl-s w_LibName     char(10)            inz;                                           //AK12
 //dcl-s w_Usage       zoned(2:0)          inz;                                     //AK12//0023
   dcl-s w_Usage       char(10)            inz;                                           //0023
   dcl-s s_pos         packed(4:0)         inz;
   dcl-s f_len         packed(4:0)         inz;

   clear w_IAPGMFILES;
   w_ClStatement          = w_ParmDS.w_String;
   w_IAPGMFILES.IAMBRNAME  = w_ParmDS.w_SrcMbr;                                          //0031
   w_IAPGMFILES.IASRCFILE  = w_ParmDS.w_SrcPf;                                           //0031
   w_IAPGMFILES.IALIBNAM   = w_ParmDS.w_SrcLib;                                          //0031
   w_IAPGMFILES.IAIFSLOC   = w_ParmDS.w_IfsLoc;                                          //0033

   if w_ClStatement = *Blanks;
      return;
   endif;

   GetWordsInArray(w_ClStatement : w_WordsArray);

   w_FileKeyPos = scanKeyword(' FILE(':w_ClStatement);

   if w_FileKeyPos = *blanks;
      w_FileKeyPos = w_WordsArray(2);
   endif;

   s_pos = %scan('/':w_FileKeyPos);
   f_len = %len(w_FileKeyPos);
   if s_pos > 0 and f_len > s_pos;                                             //PS01
      w_LibName    = %subst(w_FileKeyPos:1:s_pos-1);                                      //AK12
      w_FileKeyPos = %subst(w_FileKeyPos:s_pos+1:f_len-s_pos);
   else;                                                                                  //AK12
      w_LibName    = *Blanks;                                                             //AK12
   endif;
   if w_WordsArray(1) = 'CRTPF';                                                          //AK12
    //w_Usage         = 1;                                                          //AK12//0023
      w_Usage         = 'I';                                                              //0023
   elseif w_WordsArray(1) = 'DLTF';                                                       //AK12
    //w_Usage         = 4;                                                          //AK12//0023
      w_Usage         = 'U';                                                              //0023
   endif;                                                                                 //AK12


 //exec sql                                                                              //0034
 //   insert into IAPGMFILES (IALIBNAM,                                            //0034//0031
 //                           IASRCFILE,                                           //0034//0031
 //                           IAMBRNAME,                                           //0034//0031
 //                           IAIFSLOC,                                            //0034//0033
 //                           IAIFSLOC,                                            //0034//0033
 //                           IAACTFILE)                                           //0034//0031
 //     values(trim(:w_IAPGMFILES.IALIBNAM),                                       //0034//0031
 //            trim(:w_IAPGMFILES.IASRCFILE),                                      //0034//0031
 //            trim(:w_IAPGMFILES.IAMBRNAME),                                      //0034//0031
 //            trim(:w_IAPGMFILES.IAIFSLOC),                                       //0034//0033
 //            trim(:w_IAPGMFILES.IAIFSLOC),                                       //0034//0033
 //            trim(:w_FileKeyPos));                                               //0034//0031

 //if SQLSTATE <> SQL_ALL_OK;                                                            //0034
 //   //log error                                                                       //0034
 //endif;                                                                                //0034
   //Write source intermediate reference detail file                                     //AK12
   WrtSrcIntRefF(w_IAPGMFILES.IALIBNAM                                                   //0031
                :w_IAPGMFILES.IASRCFILE                                                  //0031
                :w_IAPGMFILES.IAMBRNAME                                                  //0031
                :w_IAPGMFILES.IAIFSLOC                                                   //0033
                :in_MbrTyp1                                                           //AK12
                :w_FileKeyPos                                                             //AK12
                :'*FILE'                                                                  //AK12
                :w_LibName                                                                //AK12
                :w_Usage                                                                  //AK12
                :'CLP'                                                                    //AK12
                );                                                                        //AK12

   return;
end-proc;

dcl-proc IAPRCSOVR export;
   dcl-pi *n;
      in_ParmPointer pointer;
   end-pi;

   dcl-ds w_IAVARCAL extName('IAVARCAL') qualified inz end-ds;
   dcl-ds w_ParmDS qualified based(in_ParmPointer);
      w_String     char(5000);
      w_Error      char(10);
      w_Repository char(10);
      w_SrcLib     char(10);
      w_SrcPf      char(10);
      w_SrcMbr     char(10);
      w_IfsLoc     char(100);                                                            //0033
      w_RRNStr     packed(6:0);
      w_RRNEnd     packed(6:0);
   end-ds;

   dcl-s w_ClStatement  char(5000) inz;
   dcl-s w_andposition  zoned(4:0) inz;
   dcl-s w_posaftercall zoned(4:0) inz;
   dcl-s b_pos          zoned(4:0) inz;

   clear w_IAVARCAL;
   w_IAVARCAL.IVCALMBR  = w_ParmDS.w_SrcMbr;
   w_IAVARCAL.IVCALFILE = w_ParmDS.w_SrcPf;
   w_IAVARCAL.IVCALLIB  = w_ParmDS.w_SrcLib;
   w_ClStatement        = w_ParmDS.w_String;
   w_IAVARCAL.IVCALVAR  = scanKeyword(' PGM(':w_ClStatement);

   if w_IAVARCAL.IVCALVAR = '';
      w_posaftercall = %scan('CALL':w_ClStatement);
      w_posaftercall = %check(' ':w_ClStatement:w_posaftercall+4);
      b_pos = %scan(' ':w_ClStatement:w_posaftercall);
      If w_posaftercall > 0 and (b_pos-w_posaftercall) > 0;                                 //AJ01
      w_IAVARCAL.IVCALVAR = %subst(w_ClStatement:w_posaftercall:
                                                b_pos-w_posaftercall);
      endif;                                                                                //AJ01
   endif;

   w_andposition = %scan('&':w_IAVARCAL.IVCALVAR);
   w_IAVARCAL.IVCALTYP = 'DIRECT';

   if w_andposition > 0;
      exec sql
        insert into IAVARCAL
          values(trim(:w_IAVARCAL.IVCALMBR),
                 trim(:w_IAVARCAL.IVCALFILE),
                 trim(:w_IAVARCAL.IVCALLIB),
                 trim(:w_IAVARCAL.IVCALVAR),
                 trim(:w_IAVARCAL.IVCALPGM),
                 trim(:w_IAVARCAL.IVCALJOB),
                 trim(:w_IAVARCAL.IVCALTYP),
                 trim(:w_IAVARCAL.IVCALJOBD),
                 trim(:w_IAVARCAL.IVCALJOBQ),
                 trim(:w_IAVARCAL.IVCALHOLD));

      if SQLSTATE <> SQL_ALL_OK;
         //log error
      endif;
   endif;

   return;
end-proc;

dcl-proc IAPRDFOVR export;
   dcl-pi *n;
      in_ParmPointer pointer;
      in_MbrTyp1     char(10) CONST;                                                     //0032
   end-pi;

   dcl-ds w_IAPGMFILES extName('IAPGMFILES') qualified inz end-ds;
   dcl-ds w_IASRCINTPF extName('IASRCINTPF') qualified inz end-ds;                       //0032
   dcl-ds w_ParmDS qualified based(in_ParmPointer);
      w_String     char(5000);
      w_Error      char(10);
      w_Repository char(10);
      w_SrcLib     char(10);
      w_SrcPf      char(10);
      w_SrcMbr     char(10);
      w_IfsLoc     char(100);                                                            //0033
      w_RRNStr     packed(6:0);
      w_RRNEnd     packed(6:0);
   end-ds;

   dcl-s w_ClStatement char(5000)          inz;
   dcl-s w_WordsArray  char(120)  dim(100) inz;
   dcl-s w_FileKeyPos  char(40)            inz;
// dcl-s tempFILEKywrd char(40)            inz;                                    //0034//MT01
// dcl-s w_Count packed(3:0);                                                      //0034//MT01
   dcl-s i       packed(3:0);                                                            //MT01
   dcl-s w_Lib   char(10);                                                               //MT01
// dcl-s Library char(10);                                                         //0034//MT01
   dcl-s s_pos   packed(3:0);
   dcl-s f_len   packed(3:0);
   dcl-s fileNameLen packed(3:0);                                                        //0032

   clear w_IAPGMFILES;
   clear w_IASRCINTPF;                                                                   //0032
   w_ClStatement          = w_ParmDS.w_String;
   w_IAPGMFILES.IAMBRNAME  = w_ParmDS.w_SrcMbr;                                          //0031
   w_IAPGMFILES.IASRCFILE  = w_ParmDS.w_SrcPf;                                           //0031
   w_IAPGMFILES.IALIBNAM   = w_ParmDS.w_SrcLib;                                          //0031
   w_IASRCINTPF.IAMBRNAM = w_ParmDS.w_SrcMbr;                                            //0032
   w_IASRCINTPF.IAMBRSRC = w_ParmDS.w_SrcPf;                                             //0032
   w_IASRCINTPF.IAMBRLIB = w_ParmDS.w_SrcLib;                                            //0032
   w_IASRCINTPF.IAMBRTYP = in_MbrTyp1;                                                   //0032
   w_IAPGMFILES.IAIFSLOC  = w_ParmDS.w_IfsLoc;                                           //0033

   if w_ClStatement = *Blanks;
      return;
   endif;

   GetWordsInArray(w_ClStatement : w_WordsArray);

   w_FileKeyPos = scanKeyword(' FILE(':w_ClStatement);
 //tempFILEKywrd = w_FileKeyPos ;                                                  //0034//MT01
   if %scan(':' :w_WordsArray(1)) > 0;                                                   //MT01
      w_WordsArray(1) = *blanks;                                                         //MT01
      for i = 1 to %elem(w_WordsArray);                                                  //MT01
         w_WordsArray(i) = w_WordsArray(i + 1);                                          //MT01
         if w_WordsArray(i) = *blanks;                                                   //MT01
            leave;                                                                       //MT01
         endif;                                                                          //MT01
      endfor;                                                                            //MT01
   endif;                                                                                //MT01

   if w_FileKeyPos = *blanks;
      w_FileKeyPos = w_WordsArray(2);
   endif;

   //if %scan('/':w_FileKeyPos) > 0;                                                     //AJ01
   s_pos = %scan('/':w_FileKeyPos);
   f_len = %len(w_FileKeyPos);
   if s_pos > 1 and f_len > s_pos;                                                       //AJ01
    //w_IAPGMFILES.IAACTFILE = %subst(w_FileKeyPos:s_pos+1:f_len-s_pos);           //0034//0031
      w_lib = %subst(w_FileKeyPos : 1 : s_pos-1);                                        //MT01
    //w_IASRCINTPF.IAREFOBJ = w_IAPGMFILES.FLPGFILE ;                                    //0032
      w_IASRCINTPF.IAREFOBJ = w_IAPGMFILES.iAActFile;                                    //0032
      w_IASRCINTPF.IAREFOLIB = w_lib;                                                    //0032
   else;
    //w_IAPGMFILES.IAACTFILE = w_FileKeyPos;                                       //0034//0031
    //w_IASRCINTPF.IAREFOBJ = w_IAPGMFILES.FLPGFILE ;                                    //0032
      w_IASRCINTPF.IAREFOBJ = w_IAPGMFILES.iAActFile;                                    //0032
   endif;

 //w_IAPGMFILES.IAACTRCDNM = scanKeyword(' RCDFMT(':w_ClStatement);                //0034//0031
 //if tempFILEKywrd <> *blanks;                                                    //0034//MT01
 //   if w_IAPGMFILES.IAACTRCDNM <> *blanks;                                       //0034//0031
 //      w_IAPGMFILES.IAACTRCDNM = w_WordsArray(5);                                //0034//0031
 //   endif;                                                                       //0034//MT01
 //else;                                                                           //0034//MT01
 //   if w_IAPGMFILES.IAACTRCDNM <> *blanks;                                       //0034//0031
 //      w_IAPGMFILES.IAACTRCDNM = w_WordsArray(4);                                //0034//0031
 //   else;                                                                        //0034//MT01
 //      if w_lib <> *blanks;                                                      //0034//MT01
 //         Library = w_lib ;                                                      //0034//MT01
 //      else;                                                                     //0034//MT01
 //         Library = w_IAPGMFILES.IALIBNAM;                                       //0034//0031
 //      endif;                                                                    //0034//MT01
 //      w_IAPGMFILES.IAACTRCDNM = w_WordsArray(3);                                //0034//0031
 //      Exec Sql                                                                  //0034//MT01
 //        Select count(*) into :w_Count                                           //0034//MT01
 //         from IDSPFFD where                                                     //0034//MT01
 //         WHFILE = trim(:w_IAPGMFILES.IAACTFILE) and                             //0034//0031
 //         WHLIB  = trim(:Library) and                                            //0034//MT01
 //         WHNAME = trim(:w_IAPGMFILES.IAACTRCDNM);                               //0034//0031
 //
 //      if w_count <> *Zeros;                                                     //0034//MT01
 //         w_IAPGMFILES.IAACTRCDNM = w_WordsArray(3);                             //0034//0031
 //      else;                                                                     //0034//MT01
 //         w_IAPGMFILES.IAACTRCDNM = *blanks;                                     //0034//0031
 //      endif;                                                                    //0034//MT01
 //   endif;                                                                       //0034//MT01
 //endif;                                                                                //0034

 //s_pos = %scan(' ': w_IAPGMFILES.IAACTRCDNM);                                    //0034//0031
 //if w_IAPGMFILES.IAACTRCDNM <> *blanks and s_pos > 1;                            //0034//0031
 //   w_IAPGMFILES.IAACTRCDNM = %subst(w_IAPGMFILES.IAACTRCDNM:1:s_pos-1);         //0034//0031
 //endif;                                                                          //0034//0031

 //w_IAPGMFILES.IAPREFIX = scanKeyword(' OPNID(':w_ClStatement);                   //0034//0031
 //If w_IAPGMFILES.IAPREFIX <> *Blanks;                                            //0034//0031
 //   w_IAPGMFILES.IAPREFIX = %trim(w_IAPGMFILES.IAPREFIX) + '_';                  //0034//0031
 //Endif;                                                                          //0034//0031

 //exec sql                                                                        //0034//0031
 //  insert into IAPGMFILES (IALIBNAM,                                             //0034//0031
 //                          IASRCFILE,                                            //0034//0031
 //                          IAMBRNAME,                                            //0034//0031
 //                          IAIFSLOC,                                             //0034//0033
 //                          IAACTFILE,                                            //0034//0031
 //                          IAACTRCDNM,                                           //0034//0031
 //                          IAPREFIX)                                             //0034//0031
 //    values(trim(:w_IAPGMFILES.IALIBNAM),                                        //0034//0031
 //           trim(:w_IAPGMFILES.IASRCFILE),                                       //0034//0031
 //           trim(:w_IAPGMFILES.IAMBRNAME),                                       //0034//0031
 //           trim(:w_IAPGMFILES.IAIFSLOC),                                        //0034//0033
 //           trim(:w_IAPGMFILES.IAACTFILE),                                       //0034//0031
 //           trim(:w_IAPGMFILES.IAACTRCDNM),                                      //0034//0031
 //           trim(:w_IAPGMFILES.IAPREFIX));                                       //0034//0031

 //if SQLSTATE <> SQL_ALL_OK;                                                            //0034
 //   //log error                                                                       //0034
 //endif;                                                                                //0034

   w_IASRCINTPF.IAREFOTYP = '*FILE';                                                     //0032
   w_IASRCINTPF.IARFILEUSG = 'CLP' ;                                                     //0032
   w_IASRCINTPF.IAREFOUSG  = 'I' ;                                                       //0032
   // Add record in IASRCINTPF                                                           //0032
   exec sql                                                                              //0032
     insert into IASRCINTPF values(:w_IASRCINTPF);                                       //0032
   if SQLSTATE <> SQL_ALL_OK;                                                            //0032
      //log error                                                                       //0032
   endif;                                                                                //0032

   return;
end-proc;


dcl-proc IAPRDVVAR export;
   dcl-pi *n;
      in_ParmPointer pointer;
   end-pi;

   dcl-ds Dcl_IAVARRELDS extname('IAVARREL') prefix(Dcl_) inz;                           //RS01
   end-ds;                                                                               //RS01

   dcl-ds w_ParmDS qualified based(in_ParmPointer);
      w_String     char(5000);
      w_Error      char(10);
      w_Repository char(10);
      w_SrcLib     char(10);
      w_SrcPf      char(10);
      w_SrcMbr     char(10);
      w_IfsLoc     char(100);                                                            //0033
      w_RRNStr     packed(6:0);
      w_RRNEnd     packed(6:0);
   end-ds;
                                                                                         //RS01
   dcl-s Dcl_Opcode    char(20)    inz;                                                  //RS01
   dcl-s Dcl_Factor1   char(20)    inz;                                                  //RS01

   dcl-s w_IAVTYP      char(10)            inz;
   dcl-s w_IAVDLEN     char(10)            inz;
   dcl-s w_IAVKWDNM    char(20)            inz;
   dcl-s w_IAVKWVAL    char(40)            inz;
   dcl-s w_IAVBASE     char(80)            inz;
   dcl-s w_IAVKEYWRD   char(80)            inz;
   dcl-s w_ClStatement char(5000)          inz;
   dcl-s w_DtaType     char(120)           inz;
   dcl-s w_lenanddec   char(120)           inz;
   dcl-s w_WordsArray  char(120)  dim(100) inz;
   dcl-s w_IAVMBR      char(10)            inz;
   dcl-s w_IAVSFILE    char(10)            inz;
   dcl-s w_IAVLIB      char(10)            inz;
   dcl-s w_IAVVAR      char(80)            inz;
   dcl-s w_IAVIFSLOC   char(100)           inz;                                          //0033
   dcl-s w_IAVDTYP     char(10)            inz;
   dcl-s w_IAVLEN      packed(8:0)         inz;
   dcl-s w_IAVPOS1     packed(5:0)         inz;
   dcl-s w_IAVPOS2     packed(5:0)         inz;
   dcl-s w_IAVPOS3     packed(5:0)         inz;
   dcl-s w_IAVDEC      packed(2:0)         inz;
   dcl-s w_SpcafterLen zoned(7:0)          inz;
   dcl-s w_poslen      zoned(7:0)          inz;
   dcl-s w_DtypPos     zoned(7:0)          inz;
   dcl-s w_DtypPos1    zoned(7:0)          inz;
   dcl-s w_PosafterLen zoned(7:0)          inz;
   dcl-s w_Valuepos    zoned(4:0)          inz;

   w_IAVMBR      = w_ParmDS.w_SrcMbr;
   w_IAVSFILE    = w_ParmDS.w_SrcPf;
   w_IAVLIB      = w_ParmDS.w_SrcLib;
   w_IAVIFSLOC   = w_ParmDS.w_ifsloc;                                                    //0033
   w_ClStatement = w_ParmDS.w_String;

   if w_ClStatement = *Blanks;
      return;
   endif;

   GetWordsInArray(w_ClStatement : w_WordsArray);

   w_IAVVAR = scanKeyword(' VAR(':w_ClStatement);
   if w_IAVVAR = *blanks;
      w_IAVVAR = w_WordsArray(2);
   endif;

   if w_IAVVAR <> *blanks;
      w_IAVTYP = 'PG';
   endif;

   w_DtaType = scanKeyword(' TYPE(':w_ClStatement);
   if w_DtaType = *blanks;
      w_DtaType = w_WordsArray(3);
   endif;

   select;
   when w_DtaType = '*CHAR';
      w_IAVDTYP = 'CHARACTER';
   when w_DtaType = '*DEC';
      w_IAVDTYP = 'DECIMAL';
   when w_DtaType = '*LGL';
      w_IAVDTYP = 'LOGICAL';
   when w_DtaType = '*INT';
      w_IAVDTYP = 'SGND INT';
   when w_DtaType = '*UINT';
      w_IAVDTYP = 'UNSGND INT';
   when w_DtaType = '*PTR';
      w_IAVDTYP = 'POINTER';
   endsl;

  // If %SCAN('ADDRESS':w_ClStatement ) > *ZERO;                                           //AJ01
   If %SCAN('ADDRESS(':w_ClStatement ) > *ZERO;                                            //AJ01
      W_Iavbase = scanKeyword('ADDRESS(' : w_ClStatement);
  //  If %len(%trim(W_Iavbase)) > *Zero and  %Scan(' ':%trim(W_Iavbase)) > *Zero;          //AJ01
      If W_Iavbase  <> *Blanks and  %Scan(' ':%trim(W_Iavbase)) > 1;                    //PS02
         W_iavbase = %trim(%subst(W_Iavbase:1:%scan(' ':%trim(W_Iavbase))-1));
      Endif;
   else;
      w_poslen  = %scan('LEN(':w_ClStatement);
      If w_poslen  > 0;
         w_lenanddec   = scanKeyword('LEN(':w_ClStatement);
         w_SpcafterLen = %scan(' ':%trim(w_lenanddec));

      // If w_SpcafterLen > 0;                                                             //AJ01
         If w_SpcafterLen > 1 ;                                                            //AJ01
            If %check(numconst1:%trim(%subst(%trim(w_lenanddec):1:w_SpcafterLen - 1)))= 0;
               w_IAVLEN = %int(%subst(%trim(w_lenanddec):1:w_SpcafterLen - 1));
            endif;

            If %len(w_lenanddec) > w_SpcafterLen
               and %check(numconst1:%trim(%subst(w_lenanddec:w_SpcafterLen:
                                             %len(w_lenanddec)-w_SpcafterLen)))=0;
               w_IAVDEC = %int(%trim(%subst(w_lenanddec:w_SpcafterLen:
                                            %len(w_lenanddec)-w_SpcafterLen)));
            endif;
         elseif w_lenanddec <> *blanks;

            If %check(numconst1:%trim(%subst(%trim(w_lenanddec):1:
                                       %len(%trim(w_lenanddec))))) = 0;
               w_IAVLEN = %int(%subst(%trim(w_lenanddec):1:%len(%trim(w_lenanddec))));
            Endif;
         endif;
      else;
         w_DtypPos  = %scan(%trim(w_DtaType):w_ClStatement:1);
         w_ValuePos = %scan('VALUE':w_ClStatement:w_DtypPos+1);

      // If w_ValuePos > 0;                                                               //AJ01
         If w_ValuePos > 1;                                                               //AJ01
            w_ClStatement = %subst(w_ClStatement:1:w_Valuepos-1);
         endif;

         If w_DtaType='*DEC';
            If (%check(numconst1:%trim(w_WordsArray(4)))=0 and
                w_WordsArray(4) <> *blanks) and
               (%check(numconst1:%trim(w_WordsArray(5)))=0 and
          //    w_WordsArray(5) <> *blanks) ;                                             //AJ01
                w_WordsArray(5) <> *blanks) and w_DtypPos > 0;                            //AJ01
                                                                                          //AJ01
               W_IAVPOS2 = %scan(%trim(w_WordsArray(4)):w_ClStatement:w_DtypPos) ;
               If W_IAVPOS2-w_DtypPos > 0;                                                //AJ01
               W_IAVPOS3 = %scan('(':%subst(w_ClStatement:w_DtypPos:W_IAVPOS2-w_DtypPos));
               Endif;                                                                     //AJ01

           //  If W_IAVPOS3 > *ZERO;                                                      //AJ01
               If W_IAVPOS3 > *ZERO and w_DtypPos > 0;                                    //AJ01
                  w_IAVDLEN = scankeyword(' (':%subst(w_ClStatement:w_DtypPos));
                  If %SCAN(' ':%trim(w_IAVDLEN))>*ZERO;
                     w_IAVLEN = %int(%trim(w_WordsArray(4)));
                     w_IAVDEC = %int(%trim(w_WordsArray(5)));
                  Else;
                     w_IAVLEN = %int(%trim(w_WordsArray(4)));
                  Endif;
               Else;
                  w_IAVLEN = %int(%trim(w_WordsArray(4)));
               Endif;
            Elseif %check(numconst1:%trim(w_WordsArray(4)))=0 and
                   w_WordsArray(4) <> *blanks;
               w_IAVLEN = %int(%trim(w_WordsArray(4)));
            Endif;
         Else;
            If %check(numconst1:%trim(w_WordsArray(4)))=0 and
               w_WordsArray(4) <> *blanks;
               w_IAVLEN = %int(%trim(w_WordsArray(4)));
            Endif;
         Endif;
      Endif;

      Select ;
  //  When %SCAN('BASPTR':w_clstatement) > *ZERO  ;                                      //AJ01
      When %SCAN('BASPTR(':w_clstatement) > *ZERO  ;                                     //AJ01
         clear w_IAVKWVAL ;
         w_IAVbase = scanKeyword('BASPTR(':w_ClStatement);
  //  When %SCAN('DEFVAR':w_clstatement) > *ZERO  ;                                      //AJ01
      When %SCAN('DEFVAR(':w_clstatement) > *ZERO  ;                                     //AJ01
         clear w_IAVKWVAL ;
         w_IAVbase = scanKeyword('DEFVAR(':w_ClStatement);
      Other;
         w_IAVKWDNM = scanKeyword(' VALUE(':w_ClStatement);
         if w_IAVKWDNM <> *blanks;
            w_IAVKWVAL  = w_IAVKWDNM;
            w_IAVKWDNM  = 'INZ';
            w_IAVKEYWRD = 'VALUE' + '(' + %trim(w_IAVKWVAL) +')';
         endif;
      Endsl;
   Endif;

   If %trim(w_IAVbase)  = '*NULL';
      w_IAVbase = 'Const(*NULL)';
   Endif;

   exec sql
     insert into IAPGMVARS (IAVMBR,
                            IAVSFILE,
                            IAVLIB,
                            IAVIFSLOC,                                                   //0033
                            IAVVAR,
                            IAVTYP,
                            IAVDTYP,
                            IAVLEN,
                            IAVDEC,
                            IAVKWDNM,
                            IAVKWVAL,
                            IAVKEYWRD,
                            IAVBASE)
       values(trim(:w_IAVMBR),
              trim(:w_IAVSFILE),
              trim(:w_IAVLIB),
              trim(:w_IAVIFSLOC),                                                        //0033
              trim(:w_IAVVAR),
              trim(:w_IAVTYP),
              trim(:w_IAVDTYP),
              char(:w_IAVLEN),
              char(:w_IAVDEC),
              trim(:w_IAVKWDNM),
              trim(:w_IAVKWVAL),
              trim(:w_IAVKEYWRD),
              trim(:w_IAVBASE));

   if SQLSTATE <> SQL_ALL_OK;
      //log error
   endif;

   Dcl_Opcode = w_WordsArray(1);                                                         //RS01
   //Dcl_Factor1 = w_WordsArray(3);
   Dcl_Factor1 = w_IAVVAR;
   Dcl_RESEQ = 1;                                                                        //RS01
   exec sql                                                                              //RS01
     insert into IAVARREL (RESRCLIB,                                                     //RS01
                           RESRCFLN,                                                     //RS01
                           REPGMNM,                                                      //RS01
                           REIFSLOC,                                                     //0033
                           RESEQ,                                                        //RS01
                           RERRN,                                                        //RS01
                           REOPC,                                                        //RS01
                           REFACT1)                                                      //RS01
       values(trim(:w_IAVLIB),                                                           //RS01
              trim(:w_IAVSFILE),                                                         //RS01
              trim(:w_IAVMBR),                                                           //RS01
              trim(:w_IAVIFSLOC),                                                        //0033
              trim(:Dcl_RESEQ),                                                          //RS01
              trim(:w_ParmDS.w_RRNStr),                                                  //RS01
              trim(:Dcl_opcode),                                                         //RS01
              trim(:Dcl_Factor1));                                                       //RS01
   return;
end-proc;

dcl-proc IAPREPOVR export;
   dcl-pi *n;
      in_ParmPointer pointer;
   end-pi;

   dcl-ds w_IAENTPRM extName('IAENTPRM') qualified inz end-ds;
   dcl-ds w_ParmDS qualified based(in_ParmPointer);
      w_String     char(5000);
      w_Error      char(10);
      w_Repository char(10);
      w_SrcLib     char(10);
      w_SrcPf      char(10);
      w_SrcMbr     char(10);
      w_IfsLoc     char(100);                                                             //0033
      w_RRNStr     packed(6:0);
      w_RRNEnd     packed(6:0);
   end-ds;

   dcl-s w_ClStatement char(5000)          inz;
   dcl-s w_ParmArray   char(120)  dim(100) inz;
   dcl-s w_WordsArray  char(120)  dim(100) inz;
   dcl-s w_parmMbr     char(10)            inz;
   dcl-s w_parmSrcPf   char(10)            inz;
   dcl-s w_parmLib     char(10)            inz;
   dcl-s w_parmIfsL    char(100)           inz;                                           //0033
   // dcl-s w_FileTemp    char(5000)          inz;
   dcl-s allClParms    char(5000)          inz;
   dcl-s w_ParamName   char(80)            inz;
   dcl-s count         zoned(4:0)          inz(1);
   dcl-s w_ParamSeq    zoned(5:0)          inz;

   clear w_IAENTPRM;
   w_parmMbr     = w_ParmDS.w_SrcMbr;
   w_parmSrcPf   = w_ParmDS.w_SrcPf;
   w_parmLib     = w_ParmDS.w_SrcLib;
   w_parmIfsL    = w_ParmDS.w_IfsLoc;                                                     //0033

   w_ClStatement = w_ParmDS.w_String;

   if w_ClStatement = *Blanks;
      return;
   endif;
   GetWordsInArray(w_ClStatement : w_WordsArray);

   //w_FileTemp = scanKeyword(' PARM(':w_ClStatement);
   Select;
   // If CL source line has Params with in PARM Keyword
   When %scan(' PARM(' : %trim(w_ClStatement)) > 0;
      allClParms = scanKeyword(' PARM(' : w_ClStatement);

   // If CL source line has paramaters only with in ()
   When %scan(' (' : %trim(w_ClStatement)) > 0;
      allClParms = scanKeyword(' (' : w_ClStatement);

   // If Source line doesnt have neither PARM nor ()
   Other;
      If %check('PGM ' : %trim(w_ClStatement)) > 0;                                       //AJ01
      allClParms = %subst( %trim(w_ClStatement) :
                            %check('PGM ' : %trim(w_ClStatement)));
      Endif;                                                                              //AJ01
   Endsl;
   GetWordsInArray(allClParms : w_ParmArray);

   dow w_parmArray(count) <> ' ';
      w_ParamName = w_parmArray(count);
      w_ParamSeq  = count;
      count += 1;

      exec sql
        insert into IAENTPRM (EMBRNAM,
                              ESRCPFNM,
                              ELIBNAME,
                              EIFSLOC ,                                                  //0033
                              EPRMSEQ,
                              EPRMNAM,
                              EPRCNAM,
                              EKEYNAM,
                              EKEYVAL)
          values(:w_ParmMbr,
                 :w_ParmSrcPf,
                 :w_ParmLib,
                 :w_parmIfsL,                                                            //0033
                  char(:w_ParamSeq),
                 :w_ParamName,
                 :w_IAENTPRM.EPRCNAM,
                 :w_IAENTPRM.EKEYNAM,
                 :w_IAENTPRM.EKEYVAL);

      if SQLSTATE <> SQL_ALL_OK;
         //log error
      endif;
   enddo;

   return;
end-proc;

dcl-proc IAPREPOVR2 export;
   dcl-pi *n;
      in_Repository char(10);
   end-pi;

   dcl-s w_Sqlstmt Char(5000);

   MONITOR;
   w_sqlstmt = 'Update IAENTPRM a '                +
               'Set (a.EKEYNAM, a.EKEYVAL) = '                           +               //0008
               '(Select b.IAV_KWDNM, b.IAV_KWVAL From IAPGMVARS b Where '+               //0008
                                          'b.IAV_LIB   = a.ELIBNAME AND '+               //0003
                                          'b.IAV_SFILE = a.ESRCPFNM AND '+               //0003
                                          'b.IAV_MBR   = a.EMBRNAM  AND '+               //0003
                                    //    'b.IAV_VAR   = a.EPRMNAM '     +               //0033
                                          'b.IAV_VAR   = a.EPRMNAM  AND '+               //0033
                                          'b.IAV_IFSLOC= a.EIFSLOC '     +               //0033
               'fetch first row only) '                                  +
               'Where EXISTS '                                           +     //SK01
           //  '(Select b.IAV_LEN, b.IAV_DTYP, b.IAV_DEC, b.IAV_DIM, '   +     //SK01
               '(Select b.IAV_KWDNM, b.IAV_KWVAL From IAPGMVARS b Where '+               //0008
                                          'b.IAV_LIB   = a.ELIBNAME AND '+               //0003
                                          'b.IAV_SFILE = a.ESRCPFNM AND '+     //SK01
                                          'b.IAV_MBR   = a.EMBRNAM  AND '+               //0003
                                      //  'b.IAV_VAR   = a.EPRMNAM '     +     //SK01    //0033
                                          'b.IAV_VAR   = a.EPRMNAM  AND '+               //0033
                                          'b.IAV_IFSLOC= a.EIFSLOC '     +               //0033
               'fetch first row only)';                                        //SK01

   w_Sqlstmt = %Trim(w_Sqlstmt);
   Exec sql PREPARE C1 FROM :w_SqlStmt;

   If Sqlcode = *Zero;
      Exec Sql EXECUTE C1;
   Endif;
   ON-ERROR;
   ENDMON;

   if SQLSTATE <> SQL_ALL_OK;
      //log error
   endif;

   return;
end-proc;


dcl-proc IAPRSDOVR export;
   dcl-pi *n;
      in_ParmPointer pointer;
      in_MbrTyp1     char(10) CONST ;                                                     //AK11
   end-pi;

   dcl-ds w_ParmDS qualified based(in_ParmPointer);
      w_String     char(5000);
      w_Error      char(10);
      w_Repository char(10);
      w_SrcLib     char(10);
      w_SrcPf      char(10);
      w_SrcMbr     char(10);
      w_IfsLoc     char(100);                                                             //0033
      w_RRNStr     packed(6:0);
      w_RRNEnd     packed(6:0);
   end-ds;

   dcl-s w_ClStatement char(5000)          inz;
   dcl-s w_KeywValue   char(20)            inz;
   dcl-s w_WordsArray  char(120)  dim(100) inz;

   w_ClStatement = w_ParmDS.w_String;

   if w_ClStatement = *Blanks;
      return;
   endif;

   GetWordsInArray(w_ClStatement : w_WordsArray);

   w_KeywValue = scanKeyword(' FILE(' : w_ClStatement);
   if w_KeywValue = *blanks;
      w_KeywValue = w_WordsArray(2);
   endif;

   if w_KeywValue = '*ALL';
      exec sql
        update iaovrpf
          set iovr_darrn = :w_ParmDS.w_RRNStr                                            //0026
        where iovr_lib   = :w_ParmDS.w_SrcLib
          and iovr_file  = :w_ParmDS.w_SrcPf
          and iovr_mbr   = :w_ParmDS.w_SrcMbr
          and iovr_rrn   < :w_ParmDS.w_RRNStr                                            //0026
          and iovr_drrn  = 0                                                             //0026
          and iovr_darrn = 0  ;                                                          //0026

      if SQLSTATE <> SQL_ALL_OK;
         //log error
      endif;
   else;
      exec sql
        update iaovrpf
          set iovr_drrn  = :w_ParmDS.w_RRNStr                                            //0026
        where iovr_lib   = :w_ParmDS.w_SrcLib
          and iovr_file  = :w_ParmDS.w_SrcPf
          and iovr_mbr   = :w_ParmDS.w_SrcMbr
          and iovr_from  = :w_KeywValue                                                  //0026d
          and iovr_rrn   < :w_ParmDS.w_RRNStr
          and iovr_drrn  = 0                                                             //0026
          and iovr_darrn = 0  ;                                                          //0026

      if SQLSTATE <> SQL_ALL_OK;
         //log error
      endif;
      //Write source intermediate reference detail file                                  //AK11
      WrtSrcIntRefF(w_ParmDS.w_SrcLib                                                     //AK11
                   :w_ParmDS.w_SrcPf                                                      //AK11
                   :w_ParmDS.w_SrcMbr                                                     //AK11
                   :w_ParmDS.w_IfsLoc                                                     //0033
                   :in_MbrTyp1                                                            //AK11
                   :w_KeywValue                                                           //AK11
                   :'*FILE'                                                               //AK11
                   :*Blanks                                                               //AK11
                 //:1                                                               //AK11//0023
                   :'I'                                                                   //0023
                   :'CLP'                                                                 //AK11
                   );                                                                     //AK11
   endif;

   return;
end-proc;

dcl-proc IAPRSSOVR export;
   dcl-pi *n;
      in_ParmPointer pointer;
      in_MbrTyp1     char(10) Const;                                                      //AK12
   end-pi;

   dcl-ds w_ParmDS qualified based(in_ParmPointer);
      w_String     char(5000);
      w_Error      char(10);
      w_Repository char(10);
      w_SrcLib     char(10);
      w_SrcPf      char(10);
      w_SrcMbr     char(10);
      w_IfsLoc     char(100);                                                            //0033
      w_RRNStr     packed(6:0);
      w_RRNEnd     packed(6:0);
   end-ds;
   dcl-ds w_IAVARCAL extName('IAVARCAL') qualified inz end-ds;

   dcl-s w_ClStatement  char(5000)          inz;
   dcl-s w_WordsArray   char(120)  dim(100) inz;
   dcl-s w_Cmd          char(5000)          inz;
   dcl-s w_slashelmnt   char(30)            inz;
   dcl-s w_CallPosition zoned(4:0)          inz;
   dcl-s w_LibName      char(10)            inz;                                          //AK12
   dcl-s s_pos          packed(4:0)         inz;
   dcl-s f_len          packed(4:0)         inz;

   clear w_IAVARCAL;
   w_IAVARCAL.IVCALMBR  = w_ParmDS.w_SrcMbr;
   w_IAVARCAL.IVCALFILE = w_ParmDS.w_SrcPf;
   w_IAVARCAL.IVCALLIB  = w_ParmDS.w_SrcLib;

   w_ClStatement = w_ParmDS.w_String;

   if w_ClStatement = *Blanks;
      return;
   endif;
   w_Cmd = scanKeyword(' CMD(':w_ClStatement);

   if w_Cmd <> *blanks;
      w_CallPosition = %scan('CALL':w_Cmd);
      if w_CallPosition <> 0;
         w_slashelmnt = scanKeyword(' PGM(':w_Cmd);
         if w_slashelmnt = *blanks;
            GetWordsInArray(w_Cmd : w_WordsArray);
            w_slashelmnt = w_WordsArray(2);
         endif;

      // if %scan('/':w_slashelmnt) > 0;                                                  //AJ01
         s_pos = %scan('/':w_slashelmnt);
         f_len = %len(w_slashelmnt);
         if s_pos > 1 and f_len>s_pos;                                                    //AJ01
            w_LibName    = %subst(w_slashelmnt:1:s_pos-1);                                //AK12
            w_IAVARCAL.IVCALPGM = %subst(w_slashelmnt:s_pos+1:f_len-s_pos);
         else;
            w_LibName    = *Blanks;                                                       //AK12
            w_IAVARCAL.IVCALPGM = w_slashelmnt;
         endif;

         clear w_slashelmnt;
         w_IAVARCAL.IVCALJOB  = scanKeyword(' JOB(':w_ClStatement);
         w_IAVARCAL.IVCALTYP  = 'SBMJOB';
         w_slashelmnt         = scanKeyword(' JOBD(':w_ClStatement);
         w_IAVARCAL.IVCALJOBQ = scanKeyword(' JOBQ(':w_ClStatement);
         w_IAVARCAL.IVCALHOLD = scanKeyword(' HOLD(':w_ClStatement);

   //    if %scan('/':w_slashelmnt) > 0;                                                    //AJ01
         s_pos = %scan('/':w_slashelmnt);
         f_len = %len(w_slashelmnt);
         if s_pos > 0 and f_len>s_pos;                                                      //AJ01
            w_IAVARCAL.IVCALJOBD = %subst(w_slashelmnt:s_pos+1:
                                          f_len-s_pos);
         else;
            w_IAVARCAL.IVCALJOBD = w_slashelmnt;
         endif;

         clear w_slashelmnt;
      endif;

      exec sql
        insert into IAVARCAL
          values(trim(:w_IAVARCAL.IVCALMBR),
                 trim(:w_IAVARCAL.IVCALFILE),
                 trim(:w_IAVARCAL.IVCALLIB),
                 trim(:w_IAVARCAL.IVCALVAR),
                 trim(:w_IAVARCAL.IVCALPGM),
                 trim(:w_IAVARCAL.IVCALJOB),
                 trim(:w_IAVARCAL.IVCALTYP),
                 trim(:w_IAVARCAL.IVCALJOBD),
                 trim(:w_IAVARCAL.IVCALJOBQ),
                 trim(:w_IAVARCAL.IVCALHOLD));

      if SQLSTATE <> SQL_ALL_OK;
         //log error
      endif;
   endif;
   //Write source intermediate reference detail file                                     //AK12
   WrtSrcIntRefF(w_ParmDS.w_SrcLib                                                        //AK12
                :w_ParmDS.w_SrcPf                                                         //AK12
                :w_ParmDS.w_SrcMbr                                                        //AK12
                :w_ParmDS.w_IfsLoc                                                        //0033
                :in_MbrTyp1                                                               //AK12
                :w_IAVARCAL.IVCALPGM                                                      //AK12
                :'*PGM'                                                                   //AK12
                :w_LibName                                                                //AK12
              //:1                                                                  //AK12//0023
                :'I'                                                                      //0023
                :'CLP'                                                                    //AK12
                );                                                                        //AK12

   return;
end-proc;

dcl-proc IAPRSOVR export;
   dcl-pi *n;
      in_ParmPointer pointer;
      in_MbrTyp1     char(10) CONST ;                                                     //AK11
   end-pi;

   dcl-ds w_IAOVRPF extName('IAOVRPF') qualified inz end-ds;
   dcl-ds w_ParmDS qualified based(in_ParmPointer);
      w_String     char(5000);
      w_Error      char(10);
      w_Repository char(10);
      w_SrcLib     char(10);
      w_SrcPf      char(10);
      w_SrcMbr     char(10);
      w_IfsLoc     char(100);                                                            //0033
      w_RRNStr     packed(6:0);
      w_RRNEnd     packed(6:0);
   end-ds;

   dcl-s w_ClStatement char(5000)          inz;
   dcl-s w_KeywValue   char(20)            inz;
   dcl-s w_Pos         zoned(4:0)          inz;
   dcl-s w_WordsArray  char(120)  dim(100) inz;
   dcl-s w_OvrToFile   char(10)            inz;                                           //AK11
   dcl-s w_OvrToLib    char(10)            inz;                                           //AK11
   dcl-s s_pos         zoned(4:0)          inz;
   dcl-s f_len         zoned(4:0)          inz;

   clear w_Iaovrpf;
   w_Iaovrpf.IOVRMBR  = w_ParmDS.w_SrcMbr;
   w_Iaovrpf.IOVRFILE = w_ParmDS.w_SrcPf;
   w_Iaovrpf.IOVRLIB  = w_ParmDS.w_SrcLib;
   w_Iaovrpf.IOVRRRN  = w_ParmDS.w_RRNStr;
   w_ClStatement      = w_ParmDS.w_String;

   if w_ClStatement = *Blanks;
      return;
   endif;

   GetWordsInArray(w_ClStatement : w_WordsArray);

   w_Iaovrpf.IOVRFROM = scanKeyword(' FILE(':w_ClStatement);

   if w_Iaovrpf.IOVRFROM = *blanks;
      w_Iaovrpf.IOVRFROM = w_WordsArray(2);
   endif;

   w_Iaovrpf.IOVRTO     = scanKeyword(' TOFILE(':w_ClStatement);
   w_Iaovrpf.IOVRFILMBR = scanKeyword(' MBR(':w_ClStatement);
   w_Iaovrpf.IOVRSCP    = scanKeyword(' OVRSCOPE(':w_ClStatement);
   w_Iaovrpf.IOVRSHR    = scanKeyword(' SHARE(':w_ClStatement);
   w_Iaovrpf.IOVRDEVTYP = scanKeyword(' DEVTYPE(':w_ClStatement);
   w_KeywValue          = scanKeyword(' PAGESIZE(':w_ClStatement);

   if w_KeywValue <> *blanks;
      w_Pos = %scan(' ' : %trim(w_KeywValue));
      If w_Pos > 0;                                                                        //AJ01
      w_Iaovrpf.IOVRPAGH = %subst(%trim(w_KeywValue) : 1 : w_Pos);
      w_Iaovrpf.IOVRPAGW = %subst(%trim(w_KeywValue) : w_Pos + 1);
      Endif;                                                                               //AJ01
   endif;

   exec sql
     with a as (select WHFNAM
                from IDSPPGMREF
                where WHOTYP <> '*FILE' and
                      WHPNAM =  :w_Iaovrpf.IOVRMBR)
       select whpnam
         into :w_Iaovrpf.IOVRPGM
       from IDSPPGMREF
       where whpnam in (select * from a)
         and whfnam = :w_Iaovrpf.IOVRFROM limit 1;                                         //0025

   if SQLSTATE <> SQL_ALL_OK;
      //log error
   endif;

   w_Iaovrpf.IOVRFRTOVL = scanKeyword(' FRONTOVL(':w_ClStatement);
   w_Iaovrpf.IOVROUTQ   = scanKeyword(' OUTQ(':w_ClStatement);
   w_Iaovrpf.IOVRHLDSPL = scanKeyword(' HOLD(':w_ClStatement);
   w_Iaovrpf.IOVRSAVSPL = scanKeyword(' SAVE(':w_ClStatement);
   w_Iaovrpf.IOVRSPLFNM = scanKeyword(' SPLFNAME(':w_ClStatement);

   exec sql
     insert into IAOVRPF (IOVR_MBR,
                          IOVR_FILE,
                          IOVR_LIB,
                          IOVR_FROM,
                          IOVR_TO,
                          IOVR_FILMBR,
                          IOVR_SCP,
                          IOVR_SHR,
                          IOVR_PGM,
                          IOVR_RRN,
                          IOVR_DRRN,
                          IOVR_DARRN,
                          IOVR_DEVTYP,
                          IOVR_OUTQ,
                          IOVR_PAGH,
                          IOVR_PAGW,
                          IOVR_FRTOVL,
                          IOVR_HLDSPL,
                          IOVR_SAVSPL,
                          IOVR_SPLFNM)
       values(trim(:w_Iaovrpf.IOVRMBR),
              trim(:w_Iaovrpf.IOVRFILE),
              trim(:w_Iaovrpf.IOVRLIB),
              trim(:w_Iaovrpf.IOVRFROM),
              trim(:w_Iaovrpf.IOVRTO),
              trim(:w_Iaovrpf.IOVRFILMBR),
              trim(:w_Iaovrpf.IOVRSCP),
              trim(:w_Iaovrpf.IOVRSHR),
              trim(:w_Iaovrpf.IOVRPGM),
                  (:w_Iaovrpf.IOVRRRN),                                                  //0026
                  (:w_Iaovrpf.IOVRDRRN),                                                 //0026
                  (:w_Iaovrpf.IOVRDARRN),                                                //0026
              trim(:w_Iaovrpf.IOVRDEVTYP),
              trim(:w_Iaovrpf.IOVROUTQ),
              trim(:w_Iaovrpf.IOVRPAGH),
              trim(:w_Iaovrpf.IOVRPAGW),
              trim(:w_Iaovrpf.IOVRFRTOVL),
              trim(:w_Iaovrpf.IOVRHLDSPL),
              trim(:w_Iaovrpf.IOVRSAVSPL),
              trim(:w_Iaovrpf.IOVRSPLFNM));

   if SQLSTATE <> SQL_ALL_OK;
      //log error
   endif;
   //Write source intermediate reference detail file                                     //AK11
   WrtSrcIntRefF(w_Iaovrpf.IOVRLIB                                                        //AK11
                :w_Iaovrpf.IOVRFILE                                                       //AK11
                :w_Iaovrpf.IOVRMBR                                                        //AK11
                :w_ParmDS.w_IfsLoc                                                        //0033
                :in_MbrTyp1                                                               //AK11
                :w_Iaovrpf.IOVRFROM                                                       //AK11
                :'*FILE'                                                                  //AK11
                :*Blanks                                                                  //AK11
              //:1                                                                  //AK11//0023
                :'I'                                                                      //0023
                :'CLP'                                                                    //AK11
                );                                                                        //AK11
   if w_Iaovrpf.IOVRTO <> *Blanks;                                                        //AK11
   //if %scan('/':w_Iaovrpf.IOVRTO) > 0;                                        //AJ01    //AK11
     s_pos = %scan('/':w_Iaovrpf.IOVRTO);
     f_len = %len(w_Iaovrpf.IOVRTO);
     if s_pos > 1 and f_len>s_pos;                                                        //AJ01
       w_OvrToLib  = %subst(w_Iaovrpf.IOVRTO:1:s_pos-1);                                  //AK11
       w_OvrToFile = %subst(w_Iaovrpf.IOVRTO:                                             //AK11
                     s_pos+1:                                                             //AK11
                     f_len-s_pos);                                                        //AK11
     else;                                                                                //AK11
       w_OvrToFile = w_Iaovrpf.IOVRTO;                                                    //AK11
       w_OvrToLib  = *Blanks;                                                             //AK11
     endif;                                                                               //AK11
     //Write source intermediate reference detail file                                   //AK11
     WrtSrcIntRefF(w_Iaovrpf.IOVRLIB                                                      //AK11
                  :w_Iaovrpf.IOVRFILE                                                     //AK11
                  :w_Iaovrpf.IOVRMBR                                                      //AK11
                  :w_ParmDS.w_IfsLoc                                                      //0033
                  :in_MbrTyp1                                                             //AK11
                  :w_OvrToFile                                                            //AK11
                  :'*FILE'                                                                //AK11
                  :w_OvrToLib                                                             //AK11
                //:1                                                                //AK11//0023
                  :'I'                                                                    //0023
                  :'CLP'                                                                  //AK11
                  );                                                                      //AK11
   endif;                                                                                 //AK11

   return;
end-proc;

dcl-proc IAPRSTRJRNPF export;
   dcl-pi *n;
      in_ParmPointer pointer;
   end-pi;

   dcl-ds w_IAPGMFILES extName('IAPGMFILES') qualified inz end-ds;
   dcl-ds w_ParmDS qualified based(in_ParmPointer);
      w_String     char(5000);
      w_Error      char(10);
      w_Repository char(10);
      w_SrcLib     char(10);
      w_SrcPf      char(10);
      w_SrcMbr     char(10);
      w_IfsLoc     char(100);                                                            //0033
      w_RRNStr     packed(6:0);
      w_RRNEnd     packed(6:0);
   end-ds;

   dcl-s w_ClStatement char(5000)          inz;
   dcl-s w_WordsArray  char(120)  dim(100) inz;
   dcl-s w_FileKeyPos  char(5000)          inz;
   dcl-s s_pos         packed(4:0)         inz;
   dcl-s f_len         packed(4:0)         inz;

   clear w_IAPGMFILES;
   w_ClStatement          = w_ParmDS.w_String;
   w_IAPGMFILES.IAMBRNAME  = w_ParmDS.w_SrcMbr;                                          //0031
   w_IAPGMFILES.IASRCFILE  = w_ParmDS.w_SrcPf;                                           //0031
   w_IAPGMFILES.IALIBNAM   = w_ParmDS.w_SrcLib;                                          //0031
   w_IAPGMFILES.IAIFSLOC  = w_ParmDS.w_IfsLoc;                                            //0033

   if w_ClStatement = *Blanks;
      return;
   endif;

   GetWordsInArray(w_ClStatement : w_WordsArray);

   w_FileKeyPos = scanKeyword(' FILE(':w_ClStatement);

   if w_FileKeyPos = *blanks;
      w_FileKeyPos = w_WordsArray(2);
   endif;

   s_pos = %scan('/':w_FileKeyPos);
   f_len = %len(w_FileKeyPos);
   if s_pos > 0 and f_len > s_pos;                                                          //AJ01
      w_FileKeyPos = %subst(w_FileKeyPos:s_pos+1:f_len-s_pos);
   endif;

 //exec sql                                                                              //0034
 //   insert into IAPGMFILES (IALIBNAM,                                            //0034//0031
 //                           IASRCFILE,                                           //0034//0031
 //                           IAMBRNAME,                                           //0034//0031
 //                           IAIFSLOC,                                            //0034//0033
 //                           IAACTFILE)                                           //0034//0031
 //     values(trim(:w_IAPGMFILES.IALIBNAM),                                       //0034//0031
 //            trim(:w_IAPGMFILES.IASRCFILE),                                      //0034//0031
 //            trim(:w_IAPGMFILES.IAMBRNAME),                                      //0034//0031
 //            trim(:w_IAPGMFILES.IAIFSLOC),                                       //0034//0033
 //            trim(:w_FileKeyPos));                                               //0034//0031

 //if SQLSTATE <> SQL_ALL_OK;                                                            //0034
 //   //log error                                                                       //0034
 //endif;                                                                                //0034

   return;
end-proc;

dcl-proc IAPSRENTFX export;
   dcl-pi IAPSRENTFX;
      in_string    char(5000);
      in_type      char(10);
      in_error     char(10);
      in_xref      char(10);
   // in_srclib    char(10);                                                             //0033
   // in_srcspf    char(10);                                                             //0033
   // in_srcmbr    char(10);                                                             //0033
      in_uWSrcDtl likeds(uWSrcDtl);                                                      //0033
      in_rrns      packed(6:0);
      in_rrne      packed(6:0);
      in_seq       packed(5:0);
      in_procedure char(80);
   end-pi;

   dcl-s E_Length    char(10)    inz;
   dcl-s E_PRMLEN    char(10)    inz;
   dcl-s E_DECPOS    char(10)    inz;
   dcl-s E_Data_Typ  char(10)    inz;
   dcl-s E_String    char(243)   inz;
   dcl-s E_xref      char(10)    inz;
   dcl-s E_Dim       char(10)    inz;
   dcl-s E_srclib    char(10)    inz;
   dcl-s E_srcspf    char(10)    inz;
   dcl-s E_srcmbr    char(10)    inz;
   dcl-s E_IfsLoc    char(100)   inz;                                                    //0033
   dcl-s E_rrns      packed(6:0) inz;
   dcl-s E_rrne      packed(6:0) inz;
   dcl-s E_Pwrdobjv  char(10)    inz;
   dcl-s E_objvref   char(10)    inz;
   dcl-s E_attr      char(10)    inz;
   dcl-s E_mody      char(10)    inz;
   dcl-s E_sts       char(10)    inz;
   dcl-s E_seq       packed(6:0) inz;
   dcl-s E_sequence  packed(5:0) inz;
   dcl-s E_procedure char(80)    inz;
   dcl-s E_parmname  char(128)   inz;
   dcl-s E_prmnam    char(80)    inz;
   dcl-s E_count     packed(4:0) inz;
   dcl-s ED_Prmlen   packed(8:0) inz;
   dcl-s ED_Prmdec   packed(2:0) inz;
   dcl-s ED_Prmarr   packed(5:0) inz;
   dcl-s ED_Keynam   char(20)    inz;
   dcl-s ED_Keyval   char(20)    inz;
   dcl-s c_pos       packed(4:0) inz;
   dcl-s ar_Pos      packed(5:0)  inz;                                                   //0008
   dcl-s ar_Pos1     packed(5:0)  inz;                                                   //0008
   dcl-s ar_IAV_DIM  char(20)     inz;                                                   //0008

   if in_string = *Blanks;
      return;
   endif;
   uWSrcDtl    = in_uWSrcDtl;                                                            //0033
   E_string    = in_string;
   E_xref      = in_xref;
   E_srclib    = in_srclib;
   E_srcspf    = in_srcspf;
   E_srcmbr    = in_srcmbr;
   E_IfsLoc    = in_IfsLoc;                                                              //0033
   E_rrns      = in_rrns;
   E_rrne      = in_rrne;
   E_seq       = in_seq;
   E_sequence  = in_seq;
   E_procedure = in_procedure;

   exsr Eprm_calculatefx;

   E_pwrdobjv  = 'ENTPRM';
   E_objvref   = *blanks;


   ED_Keynam = *blanks;
   ED_Keyval = *blanks;

   exec sql
   insert into iaentprm (EMBRNAM,
                         ESRCPFNM,
                         ELIBNAME,
                         EIFSLOC ,                                                       //0033
                         EPRMSEQ,
                         EPRMNAM,
                         EPRCNAM,
                         EKEYNAM,
                         EKEYVAL)
     values(:E_srcmbr,
            :E_srcspf,
            :E_srclib,
            :E_IfsLoc,                                                                   //0033
            :E_sequence,
            :E_prmnam,
            :E_procedure,
            :ED_Keynam,
            :ED_Keyval);

   if SQLSTATE <> SQL_ALL_OK;
      //log error
   endif;

   return;

   begsr Eprm_calculatefx;
      if %subst(E_STRING:6:1)  = 'C' and
         %subst(E_STRING:7:1) <> '*' and
         %subst(E_STRING:26:4) = 'PARM';
         E_PRMLEN   = %subst(E_STRING:64:5);
         E_DECPOS   = %subst(E_STRING:69:2);
         If %subst(E_STRING:64:5) <> *Blanks;                                            //0008
            ED_PRMLEN   = %DEC(%subst(E_STRING:64:5):5:0);                               //0008
         EndIf;                                                                          //0008
         If %subst(E_STRING:69:2) <> *Blanks;                                            //0008
            ED_Prmdec   = %DEC(%subst(E_STRING:69:2):2:0);                               //0008
         EndIf;                                                                          //0008
         E_Parmname = %trim(%subst(E_STRING:50:14));
         E_Prmnam   = %trim(%subst(E_STRING:50:14));

         if %subst(E_STRING:64:7) <> *blanks;
            if E_DECPOS = *blanks;
               E_Data_Typ = 'CHAR';
            else;
               E_Data_Typ = 'DECIMAL';
            endif;

            if E_PRMLEN <> *blanks And
               E_DECPOS  = *blanks;
               E_Length = E_PRMLEN;
            endif;

            if E_PRMLEN <> *blanks And
               E_DECPOS <> *blanks;                                                      //0008
               E_Length = E_PRMLEN + ',' + E_DECPOS;
            endif;

   //  If %subst(E_STRING:81:20) <> *blanks;                                   //0008    //0011
   //    ar_pos = %scan('DIM':E_STRING:81);                                    //0008    //0011
   //    If ar_pos > 0;                                                        //0008    //0011
   //       ar_pos = %scan('(':E_STRING:ar_pos);                               //0008    //0011
   //    endif;                                                                //0008    //0011
   //    If ar_pos > 0;                                                        //0008    //0011
   //       ar_pos1= %scan(')':E_STRING:ar_pos);                               //0008    //0011
   //    endif;                                                                //0008    //0011
   //                                                                          //0008    //0011
   //    If (ar_pos1 - ar_pos) > 1;                                            //0008    //0011
   //       ar_IAV_DIM  = %trim(%subst(E_STRING:ar_pos+1:ar_pos1-ar_pos -1));  //0008    //0011
   //    Endif;                                                                //0008    //0011
   //    if %scan(':':ar_IAV_DIM) > 0;                                         //0008    //0011
   //       ar_pos1 = %scan(':':ar_IAV_DIM);                                   //0008    //0011
   //       ar_IAV_DIM = %trim(%subst(ar_IAV_DIM:ar_pos1+1));                  //0008    //0011
   //    endif;                                                                //0008    //0011
   //    if %trim(ar_IAV_DIM) <> *blanks;                                      //0008    //0011
   //       if %check(numConst:%trim(ar_IAV_DIM)) = 0;                         //0008    //0011
   //          ED_Prmarr = %dec(ar_IAV_DIM:5:0);                               //0008    //0011
   //       endif;                                                             //0008    //0011
   //    endif;                                                                //0008    //0011
   //  EndIf;                                                                  //0008    //0011

     If ED_PRMLEN <> 0;                                                                  //0008
        Exec SQL                                                                         //0008
        Insert into IAPGMVARS(IAVMBR,                                                    //0008
                            IAVSFILE,                                                    //0008
                            IAVLIB,                                                      //0008
                            IAVIFSLOC,                                                   //0033
                            IAVVAR,                                                      //0008
                            IAVDTYP,                                                     //0008
                            IAVLEN,                                                      //0008
                            IAVDEC,                                                      //0008
   //                       IAVDIM,                                            //0008    //0011
                            IAVRRN)                                                      //0008
        Values(trim(:E_srcmbr),                                                          //0008
               trim(:E_srcspf),                                                          //0008
               trim(:E_srclib),                                                          //0008
               trim(:E_ifsloc),                                                          //0033
               trim(:E_prmnam),                                                          //0008
               trim(:E_Data_Typ),                                                        //0008
               char(:E_Length),                                                          //0008
               char(:ED_Prmdec),                                                         //0008
   //          char(:ED_Prmarr),                                               //0008    //0011
               char(:in_rrns));                                                          //0008
     EndIf;                                                                              //0008

               //log error
         endif;
      endif;
   endsr;
end-proc;

dcl-proc IAPSRENTFX3 Export;
   dcl-pi IAPSRENTFX3;
      in_string   char(5000);
      in_type     char(10);
      in_error    char(10);
      in_xref     char(10);
   // in_srclib   char(10);
   // in_srcspf   char(10);
   // in_srcmbr   char(10);
      in_uWSrcDtl likeds(uWSrcDtl);                                                      //0033
      in_rrns     packed(6:0);
      in_rrne     packed(6:0);
      in_seq      packed(5:0);
      in_procedure char(80);
   end-pi;

   dcl-s E_Length    char(10)    inz;
   dcl-s E_PRMLEN    char(10)    inz;
   dcl-s E_DECPOS    char(10)    inz;
   dcl-s E_Data_Typ  char(10)    inz;
   dcl-s E_String    char(243)   inz;
   dcl-s E_xref      char(10)    inz;
   dcl-s E_srclib    char(10)    inz;
   dcl-s E_Dim       char(10)    inz;
   dcl-s E_srcspf    char(10)    inz;
   dcl-s E_srcmbr    char(10)    inz;
   dcl-s E_IfsLoc    char(100)   inz;                                                    //0033
   dcl-s E_rrns      packed(6:0) inz;
   dcl-s E_rrne      packed(6:0) inz;
   dcl-s E_Pwrdobjv  char(10)    inz;
   dcl-s E_objvref   char(10)    inz;
   dcl-s E_attr      char(10)    inz;
   dcl-s E_mody      char(10)    inz;
   dcl-s E_sts       char(10)    inz;
   dcl-s E_seq       packed(6:0) inz;
   dcl-s E_sequence  packed(5:0) inz;
   dcl-s E_procedure char(80)    inz;
   dcl-s E_parmname  char(128)   inz;
   dcl-s E_prmnam    char(80)    inz;
   dcl-s E_count     packed(4:0) inz;
   dcl-s ED_Prmlen   packed(8:0) inz;
   dcl-s ED_Prmdec   packed(2:0) inz;
   dcl-s ED_Prmarr   packed(5:0) inz;
   dcl-s ED_Keyval   char(20)    inz;
   dcl-s ED_Keynam   char(20)    inz;
   dcl-s c_pos       packed(4:0) inz;
   dcl-s ar_Pos      packed(5:0)  inz;                                                   //0008
   dcl-s ar_Pos1     packed(5:0)  inz;                                                   //0008
   dcl-s ar_IAV_DIM  char(20)     inz;                                                   //0008

   if in_string = *blanks;                                                               //SC01
      return;                                                                            //SC01
   endif;                                                                                //SC01

   uWSrcDtl    = in_uWSrcDtl;                                                            //0033
   E_string    = in_string;
   E_xref      = in_xref;
   E_srclib    = in_srclib;
   E_srcspf    = in_srcspf;
   E_srcmbr    = in_srcmbr;
   E_IfsLoc    = in_IfsLoc;                                                              //0033
   E_rrns      = in_rrns;
   E_rrne      = in_rrne;
   E_seq       = in_seq;
   E_sequence  = in_seq;
   E_procedure = in_procedure;

   exsr Eprm_calculatefx3;

   E_pwrdobjv = 'ENTPRM';
   E_objvref  = *blanks;


 //     ED_Prmlen  =  %dec(E_PRMLEN:8:0);



   ED_Keynam = *blanks;
   ED_Keyval = *blanks;

   exec sql
     insert into iaentprm (EMBRNAM,
                           ESRCPFNM,
                           ELIBNAME,
                           EIFSLOC ,                                                     //0033
                           EPRMSEQ,
                           EPRMNAM,
                           EPRCNAM,
                           EKEYNAM,
                           EKEYVAL)
       values(:E_srcmbr,
              :E_srcspf,
              :E_srclib,
              :E_IfsLoc,                                                                 //0033
              :E_sequence,
              :E_prmnam,
              :E_procedure,
              :ED_Keynam,
              :ED_Keyval);

   if SQLSTATE <> SQL_ALL_OK;
      //log error
   endif;

   return;

   begsr Eprm_calculatefx3;
      if %subst(E_STRING:6:1)  = 'C'  and
         %subst(E_STRING:7:1) <> '*' and
         %subst(E_STRING:28:4) = 'PARM';

         E_PRMLEN   = %subst(E_STRING:49:3);
         E_DECPOS   = %subst(E_STRING:52:1);
         If %subst (E_STRING:49:3) <> *Blanks;                                           //0008
            ED_PRMLEN   = %DEC(%subst(E_STRING:49:3):3:0);                               //0008
         EndIf;                                                                          //0008
         If %subst(E_STRING:52:1) <> *Blanks;                                            //0008
            ED_Prmdec   = %DEC(%subst(E_STRING:52:1):1:0);                               //0008
         EndIf;                                                                          //0008
         E_Parmname = %trim(%subst(E_STRING:43:6));
         E_Prmnam   = %trim(%subst(E_STRING:43:6));

         if %subst(E_STRING:49:4) <> *blanks;
            if %subst(E_STRING:52:1) = *blanks;
               E_Data_Typ  = 'CHAR';
            else;
               E_Data_Typ  = 'DECIMAL';
            endif;

            if E_PRMLEN <> *blanks and
               E_DECPOS = *blanks;
             //E_Length = %subst(E_STRING:49:3) + ',' + %subst(E_STRING:52:1);           //SC01
               E_Length = E_PRMLEN + ',' + E_DECPOS;                                     //SC01
            endif;

            if E_PRMLEN <> *blanks and
               E_DECPOS <> *blanks;                                                      //0008
               E_Length = E_PRMLEN + ',' + E_DECPOS;
            endif;

 //    If %subst(E_STRING:60:15) <> *blanks;                                   //0008    //0011
 //      ar_pos = %scan('DIM':E_STRING:60);                                    //0008    //0011
 //      If ar_pos > 0;                                                        //0008    //0011
 //         ar_pos = %scan('(':E_STRING:ar_pos);                               //0008    //0011
 //      endif;                                                                //0008    //0011
 //      If ar_pos > 0;                                                        //0008    //0011
 //         ar_pos1= %scan(')':E_STRING:ar_pos);                               //0008    //0011
 //      endif;                                                                //0008    //0011
 //                                                                            //0008    //0011
 //      If (ar_pos1 - ar_pos) > 1;                                            //0008    //0011
 //         ar_IAV_DIM  = %trim(%subst(E_STRING:ar_pos+1:ar_pos1-ar_pos -1));  //0008    //0011
 //      Endif;                                                                //0008    //0011
 //      if %scan(':':ar_IAV_DIM) > 0;                                         //0008    //0011
 //         ar_pos1 = %scan(':':ar_IAV_DIM);                                   //0008    //0011
 //         ar_IAV_DIM = %trim(%subst(ar_IAV_DIM:ar_pos1+1));                  //0008    //0011
 //      endif;                                                                //0008    //0011
 //      if %trim(ar_IAV_DIM) <> *blanks;                                      //0008    //0011
 //         if %check(numConst:%trim(ar_IAV_DIM)) = 0;                         //0008    //0011
 //            ED_Prmarr = %dec(ar_IAV_DIM:5:0);                               //0008    //0011
 //         endif;                                                             //0008    //0011
 //      endif;                                                                //0008    //0011
 //    EndIf;                                                                  //0008    //0011

     If ED_PRMLEN <> 0;                                                                  //0008
        Exec SQL                                                                         //0008
        Insert into IAPGMVARS(IAVMBR,                                                    //0008
                            IAVSFILE,                                                    //0008
                            IAVLIB,                                                      //0008
                            IAVIFSLOC,                                                   //0033
                            IAVVAR,                                                      //0008
                            IAVDTYP,                                                     //0008
                            IAVLEN,                                                      //0008
                            IAVDEC,                                                      //0008
 //                         IAVDIM,                                            //0008    //0011
                            IAVRRN)                                                      //0008
        Values(trim(:E_srcmbr),                                                          //0008
               trim(:E_srcspf),                                                          //0008
               trim(:E_srclib),                                                          //0008
               trim(:E_ifsloc),                                                          //0033
               trim(:E_prmnam),                                                          //0008
               trim(:E_Data_Typ),                                                        //0008
               char(:E_Length),                                                          //0008
               char(:ED_Prmdec),                                                         //0008
 //            char(:ED_Prmarr),                                               //0008    //0011
               char(:in_rrns));                                                          //0008
     EndIf;

               //log error
         endif;
      endif;
   endsr;
end-proc;

//------------------------------------------------------------------------------------- //
//Procedure iAPsrPlstFx: Procedure to Parse PLIST wihout *ENTRY param (RPGIV)           //
//------------------------------------------------------------------------------------- //
Dcl-Proc IAPSRPLSTFX Export;                                                             //0011

   Dcl-Pi IAPSRPLSTFX;                                                                   //0011
      In_String    Char(5000);                                                           //0011
      In_Type      Char(10);                                                             //0011
      In_Error     Char(10);                                                             //0011
      In_Xref      Char(10);                                                             //0011
   // In_Srclib    Char(10);                                                             //0033
   // In_Srcspf    Char(10);                                                             //0033
   // In_Srcmbr    Char(10);                                                             //0033
      in_uWSrcDtl likeds(uWSrcDtl);                                                      //0033
      In_Rrns      Packed(6:0);                                                          //0011
      In_Rrne      Packed(6:0);                                                          //0011
      In_Seq       Packed(5:0);                                                          //0011
      In_Procedure Char(80);                                                             //0011
   End-Pi;                                                                               //0011

   Dcl-S E_Length    Char(10)    Inz;                                                    //0011
   Dcl-S E_PRMLEN    Char(10)    Inz;                                                    //0011
   Dcl-S E_DECPOS    Char(10)    Inz;                                                    //0011
   Dcl-S E_Data_Typ  Char(10)    Inz;                                                    //0011
   Dcl-S E_String    Char(243)   Inz;                                                    //0011
   Dcl-S E_Xref      Char(10)    Inz;                                                    //0011
   Dcl-S E_Dim       Char(10)    Inz;                                                    //0011
   Dcl-S E_Srclib    Char(10)    Inz;                                                    //0011
   Dcl-S E_Srcspf    Char(10)    Inz;                                                    //0011
   Dcl-S E_Srcmbr    Char(10)    Inz;                                                    //0011
   dcl-s E_IfsLoc    char(100)   inz;                                                    //0033
   Dcl-S E_Rrns      Packed(6:0) Inz;                                                    //0011
   Dcl-S E_Rrne      Packed(6:0) Inz;                                                    //0011
   Dcl-S E_Pwrdobjv  Char(10)    Inz;                                                    //0011
   Dcl-S E_Objvref   Char(10)    Inz;                                                    //0011
   Dcl-S E_Attr      Char(10)    Inz;                                                    //0011
   Dcl-S E_Mody      Char(10)    Inz;                                                    //0011
   Dcl-S E_Sts       Char(10)    Inz;                                                    //0011
   Dcl-S E_Seq       Packed(6:0) Inz;                                                    //0011
   Dcl-S E_Sequence  Packed(5:0) Inz;                                                    //0011
   Dcl-S E_Procedure Char(80)    Inz;                                                    //0011
   Dcl-S E_ParmName  Char(128)   Inz;                                                    //0011
   Dcl-S E_PrmNam    Char(80)    Inz;                                                    //0011
   Dcl-S E_Count     Packed(4:0) Inz;                                                    //0011
   Dcl-S ED_Prmlen   Packed(8:0) Inz;                                                    //0011
   Dcl-S ED_Prmdec   Packed(2:0) Inz;                                                    //0011
   Dcl-S ED_Prmarr   Packed(5:0) Inz;                                                    //0011
   Dcl-S ED_Keynam   Char(20)    Inz;                                                    //0011
   Dcl-S ED_Keyval   Char(20)    Inz;                                                    //0011
   Dcl-S C_Pos       Packed(4:0) Inz;                                                    //0011
   Dcl-S Ar_Pos      Packed(5:0) Inz;                                                    //0011
   Dcl-S Ar_Pos1     Packed(5:0) Inz;                                                    //0011
   Dcl-S Ar_IAV_DIM  Char(20)    Inz;                                                    //0011

   If In_String = *Blanks;                                                               //0011
      Return;                                                                            //0011
   EndIf;                                                                                //0011

   uWSrcDtl    = in_uWSrcDtl;                                                            //0033
   E_String    = In_String;                                                              //0011
   E_Xref      = In_Xref;                                                                //0011
   E_Srclib    = In_Srclib;                                                              //0011
   E_Srcspf    = In_Srcspf;                                                              //0011
   E_Srcmbr    = In_Srcmbr;                                                              //0011
   E_IfsLoc    = in_IfsLoc;                                                              //0033
   E_Rrns      = In_Rrns;                                                                //0011
   E_Rrne      = In_Rrne;                                                                //0011
   E_Seq       = In_Seq;                                                                 //0011
   E_Sequence  = In_Seq;                                                                 //0011
   E_Procedure = In_Procedure;                                                           //0011

   //Subroutine Eplistprm_Calcfx: to calculate the Length and position of array         //0011
   //element and index                                                                  //0011
   Exsr Eplistprm_Calcfx;                                                                //0011

   Return;                                                                               //0011

   //-----------------------------------------------------------------------------------//
   //Subroutine Eplistprm_Calcfx: to calculate the Length and position of array element //
   //and index                                                                          //
   //-----------------------------------------------------------------------------------//
   Begsr Eplistprm_Calcfx;                                                               //0011

      If %Subst(E_String:6:1)  = 'C' And                                                 //0011
         %Subst(E_String:7:1) <> '*' And                                                 //0011
         %Subst(E_String:26:4) = 'PARM';                                                 //0011

         E_PrmLen   = %Subst(E_String:64:5);                                             //0011
         E_DecPos   = %Subst(E_String:69:2);                                             //0011

         //Checking the length value of the Param variable                              //0011
         If %Subst(E_String:64:5) <> *Blanks;                                            //0011
            ED_PrmLen   = %Dec(%Subst(E_String:64:5):5:0);                               //0011
         EndIf;                                                                          //0011

         //Checking the Decimal value of the Param variabe if present                   //0011
         If %Subst(E_String:69:2) <> *Blanks;                                            //0011
            Ed_PrmDec   = %Dec(%Subst(E_String:69:2):2:0);                               //0011
         EndIf;                                                                          //0011
         E_ParmName = %Trim(%Subst(E_String:50:14));                                     //0011
         E_PrmNam   = %Trim(%Subst(E_String:50:14));                                     //0011

         //Checking the Decimal value if present is Decimal else Character              //0011
         If %Subst(E_String:64:7) <> *Blanks;                                            //0011

            If E_DecPos = *Blanks;                                                       //0011
               E_Data_Typ = 'CHAR';                                                      //0011
            Else;                                                                        //0011
               E_Data_Typ = 'DECIMAL';                                                   //0011
            EndIf;                                                                       //0011

            //If Length is only present and no Decimal value                            //0011
            //then Put length value in E_Length                                         //0011
            If E_PrmLen <> *Blanks and E_DecPos  = *Blanks;                              //0011
               E_Length = E_PrmLen;                                                      //0011
            EndIf;                                                                       //0011

            //If Length is only present and Decimal is also present                     //0011
            //then put Length and Deimal value in E_Length                              //0011
            If E_PrmLen <> *Blanks and E_DecPos <> *Blanks;                              //0011
               E_Length = E_PrmLen + ',' + E_DecPos;                                     //0011
            EndIf;                                                                       //0011

            //Insert values in IAPGMVARS if Length is present                           //0011
            If Ed_PrmLen <> 0;                                                           //0011
               Exec Sql                                                                  //0011
                 Insert Into Iapgmvars(IavMbr,                                           //0011
                                       IavsFile,                                         //0011
                                       IavLib,                                           //0011
                                       IavIfsLoc,                                        //0033
                                       IavVar,                                           //0011
                                       IavDtyp,                                          //0011
                                       IavLen,                                           //0011
                                       IavDec,                                           //0011
                                       IavRrn)                                           //0011
                 Values(Trim(:E_Srcmbr),                                                 //0011
                        Trim(:E_Srcspf),                                                 //0011
                        Trim(:E_Srclib),                                                 //0011
                        Trim(:E_IfsLoc),                                                 //0011
                        Trim(:E_Prmnam),                                                 //0011
                        Trim(:E_Data_Typ),                                               //0011
                        Char(:E_Length),                                                 //0011
                        Char(:Ed_Prmdec),                                                //0011
                        Char(:In_Rrns));                                                 //0011
            EndIf;                                                                       //0011
         EndIf;                                                                          //0011
     EndIf;                                                                              //0011

  EndSr;                                                                                 //0011

End-Proc;                                                                                //0011

//------------------------------------------------------------------------------------- //
//Procedure iAPsrPlstFx3: Procedure to Parse PLIST wihout *ENTRY param (RPGIII)         //
//------------------------------------------------------------------------------------- //
Dcl-Proc IAPSRPLSTFX3 Export;                                                            //0011

   Dcl-Pi IAPSRPLSTFX3;                                                                  //0011
      In_String   Char(5000);                                                            //0011
      In_Type     Char(10);                                                              //0011
      In_Error    Char(10);                                                              //0011
      In_Xref     Char(10);                                                              //0011
   // In_Srclib   Char(10);                                                              //0033
   // In_Srcspf   Char(10);                                                              //0033
   // In_Srcmbr   Char(10);                                                              //0033
      in_uWSrcDtl likeds(uWSrcDtl);                                                      //0033
      In_Rrns     Packed(6:0);                                                           //0011
      In_Rrne     Packed(6:0);                                                           //0011
      In_Seq      Packed(5:0);                                                           //0011
      In_Procedure Char(80);                                                             //0011
   End-Pi;                                                                               //0011

   Dcl-S E_Length    Char(10)    Inz;                                                    //0011
   Dcl-S E_PrmLen    Char(10)    Inz;                                                    //0011
   Dcl-S E_DecPos    Char(10)    Inz;                                                    //0011
   Dcl-S E_Data_Typ  Char(10)    Inz;                                                    //0011
   Dcl-S E_String    Char(243)   Inz;                                                    //0011
   Dcl-S E_Xref      Char(10)    Inz;                                                    //0011
   Dcl-S E_Srclib    Char(10)    Inz;                                                    //0011
   Dcl-S E_Dim       Char(10)    Inz;                                                    //0011
   Dcl-S E_Srcspf    Char(10)    Inz;                                                    //0011
   Dcl-S E_Srcmbr    Char(10)    Inz;                                                    //0011
   dcl-s E_IfsLoc    char(100)   inz;                                                    //0033
   Dcl-S E_Rrns      Packed(6:0) Inz;                                                    //0011
   Dcl-S E_Rrne      Packed(6:0) Inz;                                                    //0011
   Dcl-S E_Pwrdobjv  Char(10)    Inz;                                                    //0011
   Dcl-S E_Objvref   Char(10)    Inz;                                                    //0011
   Dcl-S E_Attr      Char(10)    Inz;                                                    //0011
   Dcl-S E_Mody      Char(10)    Inz;                                                    //0011
   Dcl-S E_Sts       Char(10)    Inz;                                                    //0011
   Dcl-S E_Seq       Packed(6:0) Inz;                                                    //0011
   Dcl-S E_Sequence  Packed(5:0) Inz;                                                    //0011
   Dcl-S E_Procedure Char(80)    Inz;                                                    //0011
   Dcl-S E_ParmName  Char(128)   Inz;                                                    //0011
   Dcl-S E_PrmNam    Char(80)    Inz;                                                    //0011
   Dcl-S E_Count     Packed(4:0) Inz;                                                    //0011
   Dcl-S ED_Prmlen   Packed(8:0) Inz;                                                    //0011
   Dcl-S ED_Prmdec   Packed(2:0) Inz;                                                    //0011
   Dcl-S ED_Prmarr   Packed(5:0) Inz;                                                    //0011
   Dcl-S ED_Keyval   Char(20)    Inz;                                                    //0011
   Dcl-S ED_Keynam   Char(20)    Inz;                                                    //0011
   Dcl-S C_Pos       Packed(4:0) Inz;                                                    //0011
   Dcl-S Ar_Pos      Packed(5:0)  Inz;                                                   //0011
   Dcl-S Ar_Pos1     Packed(5:0)  Inz;                                                   //0011
   Dcl-S Ar_Iav_Dim  Char(20)     Inz;                                                   //0011

   If In_String = *Blanks;                                                               //0011
      Return;                                                                            //0011
   EndIf;
                                                                                         //0011
   uWSrcDtl    = in_uWSrcDtl;                                                            //0033
   E_String    = In_String;                                                              //0011
   E_Xref      = In_Xref;                                                                //0011
   E_Srclib    = In_Srclib;                                                              //0011
   E_Srcspf    = In_Srcspf;                                                              //0011
   E_Srcmbr    = In_Srcmbr;                                                              //0011
   E_IfsLoc    = in_IfsLoc;                                                              //0033
   E_Rrns      = In_Rrns;                                                                //0011
   E_Rrne      = In_Rrne;                                                                //0011
   E_Seq       = In_Seq;                                                                 //0011
   E_Sequence  = In_Seq;                                                                 //0011
   E_Procedure = In_Procedure;                                                           //0011

   //Subroutine Eplistprm_Calcfx3: to calculate the Length and position of array        //0011
   //element and index                                                                  //0011
   Exsr Eplistprm_Calcfx3;                                                               //0011

   Return;                                                                               //0011

   //-----------------------------------------------------------------------------------//
   //Subroutine Eplistprm_Calcfx3: to calculate the Length and position of array        //
   //element and index                                                                  //
   //-----------------------------------------------------------------------------------//
   Begsr Eplistprm_Calcfx3;                                                              //0011

      If %Subst(E_String:6:1)  = 'C'                                                     //0011
         and %Subst(E_String:7:1) <> '*'                                                 //0011
         and %Subst(E_String:28:4) = 'PARM';                                             //0011

         E_PrmLen   = %Subst(E_String:49:3);                                             //0011
         E_DecPos   = %Subst(E_String:52:1);                                             //0011

         //Checking the length value of the Param variable                              //0011
         If %Subst (E_String:49:3) <> *Blanks;                                           //0011
            Ed_PrmLen   = %Dec(%Subst(E_String:49:3):3:0);                               //0011
         EndIf;                                                                          //0011

         //Checking the Decimal value of the Param variabe if present                   //0011
         If %Subst(E_String:52:1) <> *Blanks;                                            //0011
            Ed_Prmdec   = %Dec(%Subst(E_String:52:1):1:0);                               //0011
         EndIf;                                                                          //0011
         E_ParmName = %Trim(%Subst(E_String:43:6));                                      //0011
         E_PrmNam   = %Trim(%Subst(E_String:43:6));                                      //0011

         //Checking the Decimal value if present is Decimal else Character              //0011
         If %Subst(E_String:49:4) <> *Blanks;                                            //0011

            If %Subst(E_String:52:1) = *Blanks;                                          //0011
               E_Data_Typ  = 'CHAR';                                                     //0011
            Else;                                                                        //0011
               E_Data_Typ  = 'DECIMAL';                                                  //0011
            EndIf;                                                                       //0011

            //If Length is only present and no Decimal value then Put                   //0011
            //length value in E_Length                                                  //0011
            If E_PrmLen <> *Blanks and E_DecPos = *Blanks;                               //0011
               E_Length = E_PrmLen + ',' + E_DecPos;                                     //0011
            EndIf;                                                                       //0011

            //If Length is only present and Decimal is also present then                //0011
            //put Length and Deimal value in E_Length                                   //0011
            If E_PrmLen <> *Blanks And                                                   //0011
               E_DecPos <> *Blanks;                                                      //0011
               E_Length = E_PrmLen + ',' + E_DecPos;                                     //0011
            EndIf;                                                                       //0011

            //Insert values in IAPGMVARS if Length is present                           //0011
            If Ed_PrmLen <> 0;                                                           //0011
               Exec Sql                                                                  //0011
                 Insert Into IapgmVars(IavMbr,                                           //0011
                                       IavsFile,                                         //0011
                                       IavLib,                                           //0011
                                       IavIfsLoc,                                        //0033
                                       IavVar,                                           //0011
                                       IAvdTyp,                                          //0011
                                       IavLen,                                           //0011
                                       IavDec,                                           //0011
                                       IavRrn)                                           //0011
                 Values(Trim(:E_Srcmbr),                                                 //0011
                        Trim(:E_Srcspf),                                                 //0011
                        Trim(:E_Srclib),                                                 //0011
                        Trim(:E_IfsLoc),                                                 //0033
                        Trim(:E_Prmnam),                                                 //0011
                        Trim(:E_Data_Typ),                                               //0011
                        Char(:E_Length),                                                 //0011
                        Char(:Ed_Prmdec),                                                //0011
                        Char(:In_Rrns));                                                 //0011
            EndIf;                                                                       //0011
         EndIf;                                                                          //0011
      EndIf;                                                                             //0011
   EndSr;                                                                                //0011

End-Proc;                                                                                //0011

dcl-proc IAPSRFLFR export;
   dcl-pi IAPSRFLFR;
    //in_string char(5000);                                                                   //0002
      in_string char(5000) const options(*trim);                                              //0002
      in_type   char(10);
      in_error  char(10);
      in_xref   char(10);
   // in_srclib char(10);                                                                //0033
   // in_srcspf char(10);                                                                //0033
   // in_srcmbr char(10);                                                                //0033
      in_uWSrcDtl likeds(uWSrcDtl);                                                      //0033
      in_rrns   packed(6:0);
      in_rrne   packed(6:0);
   end-pi;

   dcl-s FL_Xref         char(10)    inz;
   dcl-s FL_SrcLib       char(10)    inz;
   dcl-s FL_SrcsPf       char(10)    inz;
   dcl-s FL_SrcMbr       char(10)    inz;
   dcl-s FL_IfsLoc       char(100)   inz;                                                //0033
   dcl-s FL_Name         char(128)   inz;
   dcl-s FL_ActName      char(128)   inz;                                                //0031
   dcl-s FL_RnmName      char(128)   inz;                                                //0031
   dcl-s FL_PgmType      char(10)    inz;
   dcl-s FL_Error        char(10)    inz;
   dcl-s FL_RrnS         packed(6:0) inz;
   dcl-s FL_RrnE         packed(6:0) inz;
   dcl-s FL_PwrdObjV     char(10)    inz;
   dcl-s FL_ObjvRef      char(10)    inz;
   dcl-s FL_ParseStr     char(5000)  inz;
   dcl-s FL_ParseTmp1    char(5000)  inz;
   dcl-s FL_ParseTmp2    char(5000)  inz;
   dcl-s FL_Pos1         packed(5)   inz;
   dcl-s FL_Pos2         packed(5)   inz;
   dcl-s FL_Pos3         packed(5)   inz;
   dcl-s FL_KeyWord      char(1000)   inz;                                               //PJ01
   dcl-s FL_KeyWordTmp   char(360)   inz;
   dcl-s FL_AryIdx       packed(2)   inz(1);
   dcl-s FL_Array        char(30)    inz dim(10);
   dcl-s FL_KeyWrdAry    char(30)    inz dim(50);
   dcl-s FL_FmtName      char(10)    inz;
   dcl-s FL_FmtRName     char(10)    inz;
   dcl-s FL_PreFix       char(10)    inz;
   dcl-s FL_UsageTyp     char(8)     inz;
   dcl-s FL_FDesig       char(1)     inz;
   dcl-s FL_FType        char(4)     inz;
   dcl-s FL_SFileRec     char(100)   inz;
   dcl-s FL_Keyed        char(3)     inz('No');
   dcl-s FL_Usropn       char(3)     inz('No');
   dcl-s FL_Indds        char(128)   inz;
   dcl-s FL_Infds        char(128)   inz;
   dcl-s FL_Infsr        char(5)     inz;
   dcl-s FL_ExtFile      char(10)    inz;
   dcl-s FL_ExtInd       char(20)    inz;
   dcl-s FL_Mody         char(10)    inz;
   dcl-s FL_STS          char(10)    inz;
   dcl-s FL_Seq          packed(6:0) inz;
   dcl-s FL_Attr         char(10)    inz;
   dcl-s FL_WrdObjective char(10)    inz;
   dcl-s FL_ExtLib       char(10)    inz;                                                //0031
   dcl-s FL_ExtMbr       char(10)    inz;                                                //0031

   dcl-c FL_Quotes   '"';
   dcl-c Sp          ' ';

   if in_string = *blanks;                                                               //SC01
      return;                                                                            //SC01
   endif;                                                                                //SC01

   uWSrcDtl    = in_uWSrcDtl;                                                            //0033
   FL_ParseStr = in_string;                                                                   //0002
   FL_PgmType  = in_type;
   FL_Error   = in_error;
   FL_Xref    = in_xref;
   FL_SrcLib  = in_srclib;
   FL_SrcsPf  = in_srcspf;
   FL_SrcMbr  = in_srcmbr;
   FL_IfsLoc  = in_IfsLoc;                                                                 //0033
   FL_RrnS    = in_rrns;
   FL_RrnE    = in_rrne;

   exsr FL_ProcessStrFree;
   exsr FL_UpdIAPgmFiles;

   in_error = 'C';
   return;

   begsr FL_ProcessStrFree;
      FL_Pos1     = %scan('DCL-F':FL_ParseStr);
      FL_Pos1     = %check(' ':FL_ParseStr:FL_Pos1+5);
      FL_Pos2     = %scan(' ':FL_ParseStr:FL_Pos1+1);
      If FL_Pos1 > 0 and (FL_Pos2-FL_Pos1) > 0;                                            //AJ01
      FL_Name     = %trim(%subst(FL_ParseStr:FL_Pos1:FL_Pos2-FL_Pos1):';');
      Endif;                                                                               //AJ01
      FL_Array(1) = FL_Name;

      select;
      when %scan('WORKSTN':FL_ParseStr) > 0;
         FL_Pos1 = %scan('WORKSTN':FL_ParseStr);
         FL_Pos1 = %scan(' ':FL_ParseStr:FL_Pos1);
         exsr parsefreeworkstn;

      when %scan('PRINTER':FL_ParseStr) > 0;
         FL_Pos1 = %scan('PRINTER':FL_ParseStr);
         FL_Pos1 = %scan(' ':FL_ParseStr:FL_Pos1);
         exsr parsefreeprinter;

      when %scan('SPECIAL':FL_ParseStr) > 0;
         FL_Pos1 = %scan('SPECIAL':FL_ParseStr);
         FL_Pos1 = %scan(' ':FL_ParseStr:FL_Pos1);
         exsr parsefreespecial;

      when %scan('SEQ':FL_ParseStr) > 0;
         FL_Pos1 = %scan('SEQ':FL_ParseStr);
         FL_Pos1 = %scan(' ':FL_ParseStr:FL_Pos1);
         exsr parsefreeseq;

      other;
         exsr parsefreedisk;
      endsl;
   endsr;

   begsr parsefreeworkstn;
      If FL_Pos1 > 0;                                                                       //AJ01
      FL_Array(6) = 'WORKSTN';
      Fl_KeyWord  = %trim(%subst(FL_ParseStr:FL_Pos1));
      exsr FL_ParseKwrd;
      Endif;                                                                                //AJ01
   endsr;

   begsr parsefreeprinter;
      If FL_Pos1 > 0;                                                                       //AJ01
      FL_Array(6) = 'PRINTER';
      FL_KeyWord  = %trim(%subst(FL_ParseStr:FL_Pos1));
      exsr FL_parseKwrd;
      Endif;                                                                                //AJ01
   endsr;

   begsr parsefreeSpecial;
      If FL_Pos1 > 0 ;                                                                      //AJ01
      FL_Array(6) = 'SPECIAL';
      FL_KeyWord  = %trim(%subst(FL_ParseStr:FL_Pos1));
      exsr FL_parseKwrd;
      Endif;                                                                                //AJ01
   endsr;

   begsr parsefreeSeq;
      If FL_Pos1 > 0 ;                                                                      //AJ01
      FL_Array(6) = 'SEQ';
      FL_KeyWord  = %trim(%subst(FL_ParseStr:FL_Pos1));
      exsr FL_parseKwrd;
      Endif;                                                                                //AJ01
   endsr;

   begsr parsefreedisk;
      select;
      when %scan('DISK':FL_ParseStr) > 0;
         Fl_Pos1     = %scan('DISK':FL_ParseStr);
         Fl_Pos1     = %scan(' ':FL_ParseStr:FL_Pos1);
         If Fl_Pos1 > 0 ;                                                                   //AJ01
         FL_Array(6) = 'DISK';
         FL_KeyWord  = %trim(%subst(FL_ParseStr:FL_Pos1));
         exsr FL_ParseKWrd;
         Endif;                                                                             //AJ01
      other;
         If FL_Pos1 > 0 ;                                                                   //AJ01
         FL_KeyWord  = %trim(%subst(FL_ParseStr:FL_Pos1));
         exsr FL_ParseKwrd;
         Endif;                                                                             //AJ01
      endsl;
   endsr;

   begsr FL_Parsekwrd;
      FL_AryIdx = 1;

      dow FL_KeyWord <> ' ';
         FL_Pos1 = %scan(' ':FL_KeyWord);

         if FL_Pos1 > 0;
            FL_KeyWordTmp = %subst(FL_KeyWord:1:FL_Pos1);
            FL_Pos2       = %scan('(':FL_KeyWordTmp);

            if FL_Pos2 > 1;                                                                 //AJ01
               FL_Pos3 = %scan(')':FL_Keyword);
               FL_KeyWrdAry(FL_AryIdx)   = %subst(FL_Keyword:1:FL_Pos2-1);
               If FL_Pos3 > 0 and (FL_Pos3-2-FL_Pos2+1) > 0;                                //AJ01
                  FL_KeyWrdAry(FL_AryIdx+1) = %trim(%subst(FL_KeyWord
                                          :FL_Pos2+1:FL_Pos3-2-FL_Pos2+1):'" ');            //0012
                  FL_Keyword = %trim(%subst(FL_KeyWord:FL_Pos3+1));
                  FL_AryIdx  = FL_AryIdx + 2;
               Else;                                                                        //PJ01
                  //If closing bracket not found i.e. incomplete string, come out.         //PJ01
                  leave;                                                                    //PJ01
               Endif;                                                                       //AJ01
            else;
               If (FL_Pos1-1) > 0;                                                          //AJ01
                  FL_KeyWrdAry(FL_AryIdx)   = %subst(FL_Keyword:1:FL_Pos1-1);
                  FL_KeyWrdAry(FL_AryIdx+1) = ' ';
                  FL_AryIdx  = FL_AryIdx + 2;
                  FL_KeyWord = %trim(%subst(FL_Keyword:FL_Pos1));
               Endif;                                                                       //AJ01
            endif;
         endif;
      enddo;
   endsr;

   begsr FL_UpdIAPgmFiles;
      if FL_Array(2) <> ' ';
         FL_UsageTyp = FL_Array(2);
      endif;

      if FL_Array(3) <> ' ';
         FL_FDesig = FL_Array(3);
      endif;

      if FL_Array(5) = 'K';
         FL_Keyed = 'Yes';
      endif;

      if FL_Array(6) <> ' ';
         select;
         when FL_Array(6) = 'DISK';
            FL_FTYPE = 'DB';
         when FL_Array(6) = 'WORKSTN';
            FL_FTYPE = 'DSPF';
         when FL_Array(6) = 'PRINTER';
            FL_FTYPE = 'PRTF';
         when FL_Array(6) = 'SPECIAL';
            FL_FTYPE = 'SPCL';
         when FL_Array(6) = 'SEQ';
            FL_FTYPE  = 'SEQ';
         when FL_Array(6) = 'CONSOLE';
            FL_FTYPE  = 'CNSL';
         when FL_Array(6) = 'KEYBORD';
            FL_FTYPE  = 'KYBD';
         when FL_Array(6) = 'CRT';
            FL_FTYPE  = 'CRT';
         when FL_Array(6) = 'BSCA';
            FL_FTYPE  = 'BSCA';
         endsl;
      endif;

      for FL_AryIdx = 1 to %elem(Fl_KeywrdAry) by 2;
       If FL_KeywrdAry(FL_AryIdx) <> *Blanks;
         select;
         when FL_KeywrdAry(FL_AryIdx) = 'RENAME';
            FL_Pos1     = %scan(':':Fl_KeywrdAry(FL_AryIdx+1));
            If (FL_Pos1-1) > 0;                                                             //AJ01
            FL_FmtName  = %subst(FL_KeywrdAry(FL_AryIdx+1):1:FL_Pos1-1);
            FL_FmtRName = %subst(FL_KeywrdAry(FL_AryIdx+1):FL_Pos1+1);
            Endif;                                                                          //AJ01

         when FL_KeywrdAry(FL_AryIdx) = 'KEYED';
            FL_Keyed = 'Yes';

         when FL_KeywrdAry(FL_AryIdx) = 'USROPN';
           FL_Usropn = 'Yes';

         when FL_KeywrdAry(FL_AryIdx) = 'PREFIX';
           FL_Prefix = Fl_KeywrdAry(FL_AryIdx+1);

         when FL_KeywrdAry(FL_AryIdx) = 'USAGE';
            if %scan('*INPUT':FL_KeywrdAry(FL_AryIdx+1))  > 0;
               FL_UsageTyp = 'I ' + %trim(FL_UsageTyp);
            endif;

            if %scan('*OUTPUT':FL_KeywrdAry(FL_AryIdx+1)) > 0;
               FL_UsageTyp = 'O ' + %trim(FL_UsageTyp);
            endif;

            if %scan('*UPDATE':FL_KeywrdAry(FL_AryIdx+1)) > 0;
               FL_UsageTyp  = 'U ' + %trim(FL_UsageTyp);
            endif;

            if %scan('*DELETE':FL_KeywrdAry(FL_AryIdx+1)) > 0;
               FL_UsageTyp  = 'D ' + %trim(FL_UsageTyp);
            endif;

         //Check for Sfile keyword
         when FL_KeywrdAry(FL_AryIdx) = 'SFILE';
            FL_Pos1     = %scan(':':FL_KeywrdAry(FL_AryIdx+1));
            If (FL_Pos1-1) > 0;                                                            //AJ01
            FL_SfileRec = %trim(%subst(FL_KeywrdAry(FL_AryIdx+1): 1: FL_Pos1-1)) +
                                             ' ' + %trim(FL_SfileRec);
            Endif;                                                                         //AJ01

         //Check for Indds keyword
         when FL_KeywrdAry(FL_AryIdx) = 'INDDS';
            FL_INDDS = FL_KeywrdAry(FL_AryIdx+1);

         //Check for Infds keyword
         when FL_KeywrdAry(FL_AryIdx) = 'INFDS';
            FL_INFDS = FL_KeywrdAry(FL_AryIdx+1);

         //Check for Infsr keyword
         when FL_KeywrdAry(FL_AryIdx) = 'INFSR';
            FL_INFSR    = FL_KeywrdAry(FL_AryIdx+1);

         //Check for ExtFile keyword
         when FL_KeywrdAry(FL_AryIdx) = 'EXTFILE';
            FL_Pos1 = %scan('/':FL_KeywrdAry(FL_AryIdx+1));
            if FL_Pos1 > 0;                                                              //0031
                FL_ExtLib = %subst(FL_KeywrdAry(FL_AryIdx+1):1:FL_Pos1-1);               //0031
                FL_ExtFile = %subst(FL_KeywrdAry(FL_AryIdx+1):FL_Pos1+1);                //0031
            else;                                                                        //0031
                FL_ExtFile = %trim(FL_KeywrdAry(FL_AryIdx+1));                           //0031
            endif;                                                                       //0031

            //Check for *EXTDESC Keyword
            if FL_ExtFile  = '*EXTDESC';
               FL_Pos1      = %scan('/':FL_KeywrdAry(FL_AryIdx+3));
               if FL_Pos1 > 0;                                                           //0031
                  FL_ExtLib = %subst(FL_KeywrdAry(FL_AryIdx+3):1:FL_Pos1-1);             //0031
                  FL_ExtFile = %subst(FL_KeywrdAry(FL_AryIdx+3):FL_Pos1+1);              //0031
               else;                                                                     //0031
                  FL_ExtFile = %trim(FL_KeywrdAry(FL_AryIdx+3));                         //0031
               endif;                                                                    //0031
            endif;

         //Check for ExtMbr keyword                                                     //0031
         when FL_KeywrdAry(FL_AryIdx) = 'EXTMBR';                                        //0031
           FL_ExtMbr = Fl_KeywrdAry(FL_AryIdx+1);                                        //0031

         //Check for ExtInd keyword
         when FL_KeywrdAry(FL_AryIdx) = 'EXTIND' Or FL_KeywrdAry(FL_AryIdx) = 'OFLIND';
            FL_ExtInd = %trim(FL_KeywrdAry(FL_AryIdx+1)) + ' ' + %trim(FL_ExtInd);
         endsl;
       EndIf;
        //To handle unnecessary iteration of loop
       If FL_KeywrdAry(FL_AryIdx) = ' ' AND FL_KeywrdAry(FL_AryIdx + 1) = '  ' AND
          FL_KeywrdAry(FL_AryIdx + 2) = ' ' AND FL_KeywrdAry(FL_AryIdx + 3) = '  ' ;
          leave;
       Endif;
      endfor;

      //Check for Renamed File and format Actual/Renamed file accordingly               //0031
      If FL_ExtFile <> *Blanks;                                                          //0031
         FL_ActName = %Trim(FL_ExtFile);                                                 //0031
         FL_RnmName = %Trim(FL_Array(1));                                                //0031
      Else;                                                                              //0031
         FL_ActName = %Trim(FL_Array(1));                                                //0031
         FL_RnmName = *Blanks;                                                           //0031
      EndIf;                                                                             //0031

      //Check for Record Format, if it is blanks                                        //0031
      if FL_FmtName = *Blanks;                                                           //0031
         if FL_ExtLib = *Blanks;                                                         //0031
            exec sql                                                                     //0031
               Select RFNAME Into :FL_FmtName From IDSPFDRFMT                            //0031
               Where RFFILE = :FL_ActName                                                //0031
               Limit 1;                                                                  //0031
         else;                                                                           //0031
            exec sql                                                                     //0031
               Select RFNAME Into :FL_FmtName From IDSPFDRFMT                            //0031
               Where RFFILE = :FL_ActName and                                            //0031
                     RFLIB  = :FL_ExtLib                                                 //0031
               Limit 1;                                                                  //0031
         endif;                                                                          //0031
      endif;                                                                             //0031

      exec sql
        insert into IAPGMFILES (IALIBNAM,                                                //0031
                                IASRCFILE,                                               //0031
                                IAMBRNAME,                                               //0031
                                IAIFSLOC,                                                //0033
                                IAMBRTYP,                                                //0031
                                IAACTFILE,                                               //0031
                                IARNMFILE,                                               //0031
                                IAACTRCDNM,                                              //0031
                                IARNMRCDNM,                                              //0031
                                IAQUALLIB,                                               //0031
                                IAPREFIX,                                                //0031
                                IAEXTMBRNM,                                              //0031
                                IAFILINFDS,                                              //0031
                                IAINDDS)                                                 //0031
                        values(:FL_SrcLib,                                               //0031
                               :FL_Srcspf,                                               //0031
                               :FL_Srcmbr,                                               //0031
                               :FL_IfsLoc,                                               //0033
                               :FL_FType,                                                //0031
                               :FL_ActName,                                              //0031
                               :FL_RnmName,                                              //0031
                               :FL_FmtName,                                              //0031
                               :FL_FmtRName,                                             //0031
                               :FL_ExtLib,                                               //0031
                               :FL_Prefix,                                               //0031
                               :FL_ExtMbr,                                               //0031
                               :FL_InfDs,                                                //0031
                               :FL_IndDs);                                               //0031

      if SQLSTATE <> SQL_ALL_OK;
         //log error
      endif;
   endsr;

end-proc;

dcl-proc IAPSRFLFX Export;
   dcl-pi IAPSRFLFX;
      in_string char(5000);
      in_type   char(10);
      in_error  char(10);
      in_xref   char(10);
   // in_srclib char(10);                                                                //0033
   // in_srcspf char(10);                                                                //0033
   // in_srcmbr char(10);                                                                //0033
      in_uWSrcDtl likeds(uWSrcDtl);                                                      //0033
      in_rrns   packed(6:0);
      in_rrne   packed(6:0);
   end-pi;

   dcl-s FL_Xref         char(10)    inz;
   dcl-s FL_SrcLib       char(10)    inz;
   dcl-s FL_SrcsPf       char(10)    inz;
   dcl-s FL_SrcMbr       char(10)    inz;
   dcl-s FL_IfsLoc       char(100)   inz;                                                //0033
   dcl-s FL_Name         char(128)   inz;
   dcl-s FL_ActName      char(128)   inz;                                                //0031
   dcl-s FL_RnmName      char(128)   inz;                                                //0031
   dcl-s FL_PgmType      char(10)    inz;
   dcl-s FL_Error        char(10)    inz;
   dcl-s FL_RrnS         packed(6:0) inz;
   dcl-s FL_RrnE         packed(6:0) inz;
   dcl-s FL_PwrdObjV     char(10)    inz;
   dcl-s FL_ObjvRef      char(10)    inz;
   dcl-s FL_ParseStr     char(5000)  inz;
   dcl-s FL_ParseTmp1    char(5000)  inz;
   dcl-s FL_ParseTmp2    char(5000)  inz;
   dcl-s FL_Pos1         packed(5)   inz;
   dcl-s FL_Pos2         packed(5)   inz;
   dcl-s FL_Pos3         packed(5)   inz;
   dcl-s FL_KeyWord      char(1000)   inz;
   dcl-s FL_KeyWordTmp   char(1000)   inz;
   dcl-s FL_AryIdx       packed(2)   inz(1);
   dcl-s FL_Array        char(30)    inz dim(10);
   dcl-s FL_KeyWrdAry    char(30)    inz dim(50);
   dcl-s FL_FmtName      char(10)    inz;
   dcl-s FL_FmtRName     char(10)    inz;
   dcl-s FL_PreFix       char(10)    inz;
   dcl-s FL_UsageTyp     char(8)     inz;
   dcl-s FL_FDesig       char(1)     inz;
   dcl-s FL_FType        char(4)     inz;
   dcl-s FL_SFileRec     char(100)   inz;
   dcl-s FL_Keyed        char(3)     inz('No');
   dcl-s FL_Usropn       char(3)     inz('No');
   dcl-s FL_Indds        char(128)   inz;
   dcl-s FL_Infds        char(128)   inz;
   dcl-s FL_Infsr        char(5)     inz;
   dcl-s FL_ExtFile      char(10)    inz;
   dcl-s FL_ExtInd       char(20)    inz;
   dcl-s FL_Mody         char(10)    inz;
   dcl-s FL_STS          char(10)    inz;
   dcl-s FL_Seq          packed(6:0) inz;
   dcl-s FL_Attr         char(10)    inz;
   dcl-s FL_WrdObjective char(10)    inz;
   dcl-s FL_ExtLib       char(10)    inz;                                                //0031
   dcl-s FL_ExtMbr       char(10)    inz;                                                //0031

   dcl-c FL_Quotes   '"';
   dcl-c Sp          ' ';

   if in_string = *blanks;                                                                 //SC01
      return;                                                                              //SC01
   endif;                                                                                  //SC01

   uWSrcDtl     = in_uWSrcDtl;                                                           //0033
   FL_ParseStr  = in_string;
   FL_PgmType   = in_type;
   FL_Error     = in_error;
   FL_Xref      = in_xref;
   FL_SrcLib    = in_srclib;
   FL_SrcsPf    = in_srcspf;
   FL_SrcMbr    = in_srcmbr;
   FL_IfsLoc    = in_IfsLoc;                                                               //0033
   FL_RrnS      = in_rrns;
   FL_RrnE      = in_rrne;
   FL_ParseTmp1 = FL_ParseStr;

   //Process String                                    
   exsr FL_ProcessStrFix;

   //Update IAPGMFILES
   exsr FL_UpdIAPgmFiles;

   //Update Iapgmref Files

   In_error  = 'C';
   return;

   begsr FL_ProcessStrFix;
      FL_AryIdx = 1;
      FL_Pos1 = %scan('@     ':FL_ParseStr:1);

      if FL_ParseStr <> *blanks and FL_Pos1 > 1;                          //KM
         FL_ParseStr = %subst(FL_ParseStr:1:FL_Pos1-1);
      endif;

      //Remove '@' from input string, If present
      dow FL_Pos1 > 0;
         FL_Pos2 = %scan('@     ':FL_ParseTmp1:FL_Pos1+1);

         if FL_Pos2 > 0 and FL_Pos2-1-FL_Pos1 > 0;                                 //KM
            FL_ParseTmp2 = %subst(FL_ParseTmp1:FL_Pos1+1:FL_Pos2-1-FL_Pos1);
         else;
            FL_ParseTmp2 = %subst(FL_ParseTmp1:FL_Pos1+1);
         endif;

         select;
         when FL_PgmType = 'RPGLE' or FL_PgmType = 'SQLRPGLE';
            if %subst(FL_ParseTmp2:44) <> *blanks;                                         //SC01
               Fl_KeyWord  = %subst(FL_ParseTmp2:44);
               FL_ParseStr = %trimr(FL_ParseStr) + '     ' + FL_KeyWord;
            endif;                                                                         //SC01
            FL_Pos1     = %scan('@     ':FL_ParseTmp1:FL_Pos1+1);


         when FL_PgmType = 'RPG'   or FL_PgmType = 'SQLRPG' or
            FL_PgmType = 'RPT'   or FL_PgmType = 'RPG38'  or
            FL_PgmType = 'RPT38' or FL_PgmType = 'RPG36'  or
            FL_PgmType = 'RPT36';
            exsr ParseKwrdRpg;
            FL_AryIdx = FL_AryIdx + 2;
            FL_Pos1   = %scan('@     ':FL_ParseTmp1:FL_Pos1+1);

         //Prevent infinite loop
         other;
            FL_Pos1 = 0;
         endsl;
      enddo;

      select;
      when FL_PgmType = 'RPG'    or
           FL_PgmType = 'SQLRPG' or
           FL_PgmType = 'RPT'    or
           FL_PgmType = 'RPG38'  or
           FL_PgmType = 'RPT38'  or
           FL_PgmType = 'RPG36'  or
           FL_PgmType = 'RPT36';
         exsr ParseFix_RPG;
      when FL_PgmType = 'RPGLE' or FL_PgmType = 'SQLRPGLE';
         exsr ParseFix_RPGLE;
      endsl;

      FL_Name = FL_Array(1);
   endsr;

   begsr ParseKwrdRPG;
      if FL_AryIdx >= %elem(FL_keyWrdAry) - 1;                                             //SC01
         leavesr;                                                                          //SC01
      endif;                                                                               //SC01
      select;
      when %scan('INFDS':FL_ParseTmp2) > 0 or
           %scan('INFSR':FL_ParseTmp2) > 0 or
           %scan('INDDS':FL_ParseTmp2) > 0;
         FL_keyWrdAry(FL_AryIdx)   = %subst(FL_ParseTmp2:54:6);
         FL_keyWrdAry(FL_AryIdx+1) = %subst(FL_ParseTmp2:60:8);
      when %scan('SFILE':FL_ParseTmp2) > 0;
         FL_keyWrdAry(FL_AryIdx)   = %subst(FL_ParseTmp2:54:6);
         FL_keyWrdAry(FL_AryIdx+1) = %trim(%subst(FL_ParseTmp2:60:8)) +
                                     ':' + %trim(%subst(FL_ParseTmp2:47:6));
      when %scan('RENAME':FL_ParseTmp2) > 0;
         FL_keyWrdAry(FL_AryIdx)   = %subst(FL_ParseTmp2:54:6);
         FL_keyWrdAry(FL_AryIdx+1) = %trim(%subst(FL_ParseTmp2:19:10)) +
                                     ':' + %trim(%subst(FL_ParseTmp2:60:8));
      endsl;
   endsr;

   begsr ParseFix_RPG;
      //File Name
      FL_Array(1) = %trim(%subst(FL_ParseStr:7:8));

      //File Mode
      FL_Array(2) = %subst(FL_ParseStr:15:1);

      //File Designation
      FL_Array(3) = %subst(FL_ParseStr:16:1);

      //File Format
      FL_Array(4) = %subst(FL_ParseStr:19:1);

      //Record Address Type
      FL_Array(5) = %subst(FL_ParseStr:31:1);

      //Device
      FL_Array(6) = %subst(FL_ParseStr:40:7);

      //File Addition
      FL_Array(7) = %subst(FL_ParseStr:66:1);

      //File Name in local variable
      FL_Name = %trim(FL_Array(1));
   endsr;

   begsr ParseFix_RPGLE;
      //File Name
      FL_Array(1) = %subst(FL_ParseStr:7:10);

      //File Mode
      FL_Array(2) = %subst(FL_ParseStr:17:1);

      //File Designation
      FL_Array(3) = %subst(FL_ParseStr:18:1);

      //File Format
      FL_Array(4) = %subst(FL_ParseStr:22:1);

      //Record Address Type
      FL_Array(5) = %subst(FL_ParseStr:34:1);

      //Device
      FL_Array(6) = %subst(FL_ParseStr:36:7);

      //File Addition
      FL_Array(7) = %subst(FL_ParseStr:20:1);

      //File Name in local variable
      FL_Name     = %trim(FL_Array(1));

      //Breaking Keyword From parse string
      if %subst(FL_ParseStr:44)  <> *blanks;                                          //SC01
         FL_Keyword  = %trim(%subst(FL_ParseStr:44));
         exsr FL_ParseKwrd;
      endif;                                                                               //SC01

   endsr;

   begsr FL_Parsekwrd;
      FL_AryIdx = 1;

      dow FL_KeyWord <> ' ' and FL_AryIdx < %elem(FL_KeyWrdAry) - 1;                       //SC01
         FL_Pos1 = %scan(' ':FL_KeyWord);

         if FL_Pos1 > 0;
            FL_KeyWordTmp = %subst(FL_KeyWord:1:FL_Pos1);
            FL_Pos2       = %scan('(':FL_KeyWordTmp);

            if FL_Pos2 > 1;
               FL_Pos3 = %scan(')':FL_Keyword);
               If FL_Pos3 > 0 and FL_Pos3-2-FL_Pos2+1 > 0;                       //KM
                  FL_KeyWrdAry(FL_AryIdx)   = %subst(FL_Keyword:1:FL_Pos2-1);
                  FL_KeyWrdAry(FL_AryIdx+1) = %trim(%subst(FL_KeyWord
                                               :FL_Pos2+1:FL_Pos3-2-FL_Pos2+1));
               else;                                                                       //OJ01
                  leave;                                                                   //OJ01
               EndIf;                                                             //KM
               if FL_KeyWord <> *blanks and FL_Pos3 > 0;                                   //SC01
                  FL_Keyword = %trim(%subst(FL_KeyWord:FL_Pos3+1));
                  FL_AryIdx  = FL_AryIdx + 2;
               endif;                                                                      //SC01
            else;
               If FL_Pos1 > 1;                                                    //KM
                  FL_KeyWrdAry(FL_AryIdx)   = %subst(FL_Keyword:1:FL_Pos1-1);
               EndIf;                                                             //KM
               FL_KeyWrdAry(FL_AryIdx+1) = ' ';
               FL_AryIdx  = FL_AryIdx + 2;
               FL_KeyWord = %trim(%subst(FL_Keyword:FL_Pos1));
            endif;
         endif;
      enddo;
   endsr;

   begsr FL_UpdIAPgmFiles;
      if FL_Array(2) <> ' ';
         FL_UsageTyp = FL_Array(2);
      endif;

      if FL_Array(3) <> ' ';
         FL_FDesig = FL_Array(3);
      endif;

      if FL_Array(5) = 'K';
         FL_Keyed = 'YES';                                                                 //SC01
      endif;

      if FL_Array(6) <> ' ';
         select;
         when FL_Array(6) = 'DISK';
            FL_FTYPE = 'DB';
         when FL_Array(6) = 'WORKSTN';
            FL_FTYPE = 'DSPF';
         when FL_Array(6) = 'PRINTER';
            FL_FTYPE = 'PRTF';
         when FL_Array(6) = 'SPECIAL';
            FL_FTYPE = 'SPCL';
         when FL_Array(6) = 'SEQ';
            FL_FTYPE  = 'SEQ';
         when FL_Array(6) = 'CONSOLE';
            FL_FTYPE  = 'CNSL';
         when FL_Array(6) = 'KEYBORD';
            FL_FTYPE  = 'KYBD';
         when FL_Array(6) = 'CRT';
            FL_FTYPE  = 'CRT';
         when FL_Array(6) = 'BSCA';
            FL_FTYPE  = 'BSCA';
         endsl;
      endif;

      for FL_AryIdx = 1 to %elem(Fl_KeywrdAry) - 3 by 2;                                   //SC01
       If FL_KeywrdAry(FL_AryIdx) <> *Blanks;
         select;
         when FL_KeywrdAry(FL_AryIdx) = 'RENAME';
            FL_Pos1     = %scan(':':Fl_KeywrdAry(FL_AryIdx+1));
            If FL_Pos1 > 1;                                                      //KM
               FL_FmtName  = %subst(FL_KeywrdAry(FL_AryIdx+1):1:FL_Pos1-1);
               FL_FmtRName = %subst(FL_KeywrdAry(FL_AryIdx+1):FL_Pos1+1);
            EndIf;                                                               //KM

         when FL_KeywrdAry(FL_AryIdx) = 'KEYED';
            FL_Keyed     = 'Yes';

         when FL_KeywrdAry(FL_AryIdx) = 'USROPN';
            FL_Usropn    = 'Yes';

         when FL_KeywrdAry(FL_AryIdx) = 'PREFIX';
            FL_Prefix    = Fl_KeywrdAry(FL_AryIdx+1);
            FL_Prefix    = %trim(%xlate(FL_Quotes:Sp:FL_Prefix));                        //0031

         when FL_KeywrdAry(FL_AryIdx) = 'USAGE';
            if %scan('*INPUT':FL_KeywrdAry(FL_AryIdx+1))  > 0;
               FL_UsageTyp = 'I ' + %trim(FL_UsageTyp);
            endif;

            if %scan('*OUTPUT':FL_KeywrdAry(FL_AryIdx+1)) > 0;
               FL_UsageTyp   = 'O ' + %trim(FL_UsageTyp);
            endif;

            if %scan('*UPDATE':FL_KeywrdAry(FL_AryIdx+1)) > 0;
               FL_UsageTyp  = 'U ' + %trim(FL_UsageTyp);
            endif;

            if %scan('*DELETE':FL_KeywrdAry(FL_AryIdx+1)) > 0;
               FL_UsageTyp  = 'D ' + %trim(FL_UsageTyp);
            endif;

         //Check for Sfile keyword
         when FL_KeywrdAry(FL_AryIdx) = 'SFILE';
            FL_Pos1     = %scan(':':FL_KeywrdAry(FL_AryIdx+1));
            If FL_Pos1 > 1;                                                     //KM
               FL_SfileRec = %trim(%subst(FL_KeywrdAry(FL_AryIdx+1):1:
                                  FL_Pos1-1)) + ' ' + %trim(FL_SfileRec);
            EndIf;                                                              //KM
         //Check for Indds keyword
         when FL_KeywrdAry(FL_AryIdx) = 'INDDS';
            FL_INDDS    = FL_KeywrdAry(FL_AryIdx+1);

         //Check for Infds keyword
         when FL_KeywrdAry(FL_AryIdx) = 'INFDS';
            FL_INFDS    = FL_KeywrdAry(FL_AryIdx+1);

         //Check for Infsr keyword
         when FL_KeywrdAry(FL_AryIdx) = 'INFSR';
            FL_INFSR    = FL_KeywrdAry(FL_AryIdx+1);

         //Check for ExtFile keyword
         when FL_KeywrdAry(FL_AryIdx) = 'EXTFILE';
            FL_Pos1 = %scan('/':FL_KeywrdAry(FL_AryIdx+1));
            if FL_Pos1 > 0;
               FL_Pos2    = %scan(Fl_Quotes:FL_KeywrdAry(FL_AryIdx+1):FL_Pos1);
               If FL_Pos2 > 0 and (FL_Pos2-FL_Pos1-1) > 0;                        //KM
                  FL_ExtFile = %subst(FL_KeywrdAry(FL_AryIdx+1):
                                      FL_Pos1+1:(FL_Pos2-FL_Pos1-1));
               EndIf;                                                             //KM
               FL_ExtLib = %subst(FL_KeywrdAry(FL_AryIdx+1):1:FL_Pos1-1);                //0031
               FL_ExtLib = %trim(%xlate(FL_Quotes:Sp:FL_ExtLib));                        //0031
            else;
               FL_ExtFile = %trim(%xlate(FL_Quotes:Sp:FL_KeywrdAry(FL_AryIdx+1)));
            endif;

            //Check for *EXTDESC Keyword
            if FL_ExtFile  = '*EXTDESC';
               FL_Pos1 = %scan('/':FL_KeywrdAry(FL_AryIdx+3));
               if FL_Pos1 > 0;
                  FL_Pos2    = %scan(Fl_Quotes:FL_KeywrdAry(FL_AryIdx+3):FL_Pos1);
                  If FL_Pos2 > 0 and (FL_Pos2-FL_Pos1-1) > 0;                             //KM
                     FL_ExtFile = %subst(FL_KeywrdAry(FL_AryIdx+3):
                                         FL_Pos1+1:(FL_Pos2-FL_Pos1-1));
                  EndIf;                                                                  //KM
                  FL_ExtLib = %subst(FL_KeywrdAry(FL_AryIdx+3):1:FL_Pos1-1);              //0031
                  FL_ExtLib = %trim(%xlate(FL_Quotes:Sp:FL_ExtLib));                      //0031
               else;
                  FL_ExtFile = %trim(%xlate(FL_Quotes:Sp:FL_KeywrdAry(FL_AryIdx+3)));
               endif;
            endif;

         //Check for ExtMbr keyword                                                     //0031
         when FL_KeywrdAry(FL_AryIdx) = 'EXTMBR';                                        //0031
           FL_ExtMbr = Fl_KeywrdAry(FL_AryIdx+1);                                        //0031
           FL_ExtMbr = %trim(%xlate(FL_Quotes:Sp:FL_ExtMbr));                            //0031

         //Check for ExtInd keyword
         when FL_KeywrdAry(FL_AryIdx) = 'EXTIND' Or
              FL_KeywrdAry(FL_AryIdx) = 'OFLIND';
              FL_ExtInd   = %trim(FL_KeywrdAry(FL_AryIdx+1)) + ' ' + %trim(FL_ExtInd);
         endsl;
       EndIf;
        //To handle unnecessary iteration of loop
       If FL_KeywrdAry(FL_AryIdx) = ' ' AND FL_KeywrdAry(FL_AryIdx + 1) = '  ' AND
          FL_KeywrdAry(FL_AryIdx + 2) = ' ' AND FL_KeywrdAry(FL_AryIdx + 3) = '  ' ;
          leave;
       Endif;
      endfor;

      //Check for Renamed File and format Actual/Renamed file accordingly               //0031
      If FL_ExtFile <> *Blanks;                                                          //0031
         FL_ActName = %Trim(FL_ExtFile);                                                 //0031
         FL_RnmName = %Trim(FL_Array(1));                                                //0031
      Else;                                                                              //0031
         FL_ActName = %Trim(FL_Array(1));                                                //0031
         FL_RnmName = *Blanks;                                                           //0031
      EndIf;                                                                             //0031

      //Check for Record Format, if it is blanks                                        //0031
      if FL_FmtName = *Blanks;                                                           //0031
         if FL_ExtLib = *Blanks;                                                         //0031
            exec sql                                                                     //0031
               Select RFNAME Into :FL_FmtName From IDSPFDRFMT                            //0031
               Where RFFILE = :FL_ActName                                                //0031
               Limit 1;                                                                  //0031
         else;                                                                           //0031
            exec sql                                                                     //0031
               Select RFNAME Into :FL_FmtName From IDSPFDRFMT                            //0031
               Where RFFILE = :FL_ActName and                                            //0031
                     RFLIB  = :FL_ExtLib                                                 //0031
               Limit 1;                                                                  //0031
         endif;                                                                          //0031
      endif;                                                                             //0031

      exec sql
        insert into IAPGMFILES (IALIBNAM,                                                //0031
                                IASRCFILE,                                               //0031
                                IAMBRNAME,                                               //0031
                                IAIFSLOC,                                                //0033
                                IAMBRTYP,                                                //0031
                                IAACTFILE,                                               //0031
                                IARNMFILE,                                               //0031
                                IAACTRCDNM,                                              //0031
                                IARNMRCDNM,                                              //0031
                                IAQUALLIB,                                               //0031
                                IAPREFIX,                                                //0031
                                IAEXTMBRNM,                                              //0031
                                IAFILINFDS,                                              //0031
                                IAINDDS)                                                 //0031
                        values(:FL_SrcLib,                                               //0031
                               :FL_Srcspf,                                               //0031
                               :FL_Srcmbr,                                               //0031
                               :FL_IfsLoc,                                               //0033
                               :FL_FType,                                                //0031
                               :FL_ActName,                                              //0031
                               :FL_RnmName,                                              //0031
                               :FL_FmtName,                                              //0031
                               :FL_FmtRName,                                             //0031
                               :FL_ExtLib,                                               //0031
                               :FL_Prefix,                                               //0031
                               :FL_ExtMbr,                                               //0031
                               :FL_InfDs,                                                //0031
                               :FL_IndDs);                                               //0031

      if SQLSTATE <> SQL_ALL_OK;
         //log error
      endif;
   endsr;

end-proc;

dcl-proc IAPSRDSFR Export;
   dcl-pi IAPSRDSFR;
      in_string  char(5000) value ;                                                      //0001
      in_type    char(10);
      in_error   char(10);
      in_xref    char(10);
   // in_srclib  char(10);                                                               //0033
   // in_srcspf  char(10);                                                               //0033
   // in_srcmbr  char(10);                                                               //0033
      in_uWSrcDtl likeds(uWSrcDtl);                                                      //0033
      in_rrn_s   packed(6:0);
      in_rrn_e   packed(6:0);
      in_dsdcl   char(3);
      in_dsobjv  char(10);
      in_dsname  char(128);
      in_dsmody  char(10);
      in_uwdsdtl likeds(uwdsdtl_t);
   end-pi;

   dcl-ds DsFileDtl;
      ds_WHFLDI char(10);
      ds_WHFLDB packed(5:0);
      ds_WHFLDD packed(2:0);
      ds_WHFLDP packed(2:0);
      ds_WHFLDT char(1);
   end-ds;

   dcl-ds uwdsdtl1 likeds(uwdsdtl_t) inz;

   dcl-s ds_pos1     packed(2:0) inz;
   dcl-s ds_pos2     packed(2:0) inz;
   dcl-s ds_pos3     packed(2:0) inz;
   dcl-s ds_pos4     packed(2:0) inz;
   dcl-s ds_pos5     packed(2:0) inz;
   dcl-s ds_pos6     packed(2:0) inz;
   dcl-s ds_pos7     packed(2:0) inz;
   dcl-s ds_name     char(128)   inz;
   dcl-s ds_objv     char(10)    inz;
   dcl-s ds_attr     char(10)    inz;
   dcl-s ds_mody     char(128)   inz;
   dcl-s ds_sts      char(10)    inz;
   dcl-s ds_seqn     packed(6:0) inz;
   dcl-s ds_sseqn    char(10)    inz;
   dcl-s ds_eseqn    char(10)    inz;
   dcl-s ds_objvref  char(10)    inz;
   dcl-s ds_fseqn    char(10)    inz;
   dcl-s ds_scoln    char(1)     inz;
   dcl-s ds_qulflg   char(1)     inz;
   dcl-s ds_length   packed(8:0) inz;
   dcl-s ds_dim      packed(7:0) inz;
   dcl-s ds_flddec   packed(2:0) inz;
   dcl-s ds_type     char(1)     inz;
   dcl-s lref        char(10)    inz;
 //dcl-s ExtFileNm   char(10) inz;                                                       //0021
   dcl-s ExtFileNm   varchar(5000) inz;                                                  //0021
   dcl-s ExtLibNm    char(10)    inz;                                                     //AG01
   dcl-s ds_LikeDsNm char(128)   inz;
   dcl-s ds_LibNm    char(10)    inz;
   dcl-s ds_srcpf    char(10)    inz;
   dcl-s ds_MbrNm    char(10)    inz;
   dcl-s ds_IfsLoc   char(100)   inz;                                                    //0033
   dcl-s replaceStr  char(20)    inz;
   dcl-s wk_pos      packed(4:0) inz;
   dcl-s len         packed(4:0) inz;
   dcl-s ds_position packed(2:0) inz;                                                    //TK01
   dcl-s ds_string char(5000) inz;                                                       //TK01
   dcl-s ds_Flag     Ind         inz('1');                                               //TK01
   dcl-s ds_instringlen packed(4:0) inz;                                                 //SC01
   dcl-s l_CalledFrom Char(50) inz;                                                      //0009

   if in_string = *blanks;                                                               //SC01
      return;                                                                            //SC01
   else;                                                                                 //AK41
      in_string = %trim(in_string);                                                      //AK41
   endif;                                                                                //SC01
   clear in_uwdsdtl.dsfldnm;
   clear in_uwdsdtl.dsfltyp;
   clear in_uwdsdtl.dsflto;
   clear in_uwdsdtl.dsflfr;
   clear in_uwdsdtl.dsflsiz;
   clear in_uwdsdtl.dsbfldnm;
   clear in_uwdsdtl.dsqualnm;
   clear in_uwdsdtl.dsfldec;
   clear in_uwdsdtl.dsbfldnm;
   clear in_uwdsdtl.dsflspcy;

   uWSrcDtl = in_uWSrcDtl;                                                               //0033
   ds_mody  = in_dsmody;
   ds_name  = in_dsname;
   ds_objv  = in_dsobjv;
   ds_LibNm = in_srclib;
   ds_srcpf = in_srcspf;
   ds_MbrNm = in_srcmbr;
   ds_IfsLoc= in_IfsLoc;                                                                 //0033

   //When Data Structure declare with LikeDs                                            //TK02
   if in_dsdcl = 'XDS';                                                                  //TK02
      ds_Flag = *Off;                                                                    //TK02
      in_dsdcl = 'DSS';
   endif;                                                                                //TK02

   select;
   //When It Is Data Structure Declaration
   when in_dsdcl = 'DS';
      clear in_uwdsdtl.dsfldrnk;
      clear in_uwdsdtl.dslength;
      clear in_uwdsdtl.dsdimen;
      if ds_objv = 'INFDS-VAR' or ds_objv = 'INDDS-VAR';
         ds_type = 'E';
      endif;

      //Find Data Structure info
      exsr finddsinfofr;

      //Get DS Values in in_uwdsdtl Data Structure
      exsr get_uwdsdtl;

   //When It Is DS Field Declaration
   when in_dsdcl = 'DSS';
      //Find Data Structure Field Info
      exsr finddsfieldinfofr;

      //Get Field Values in in_uwdsdtl Data Structure
      exsr get_uwdsdtl;

   //When Data Structure declare with LikeDs                                            //TK02
      if ds_Flag = *Off;                                                                 //TK02
        in_uwdsdtl.DSFLDNM = in_uwdsdtl.DSBFLDNM;                                        //TK02
      endif;                                                                             //TK02

      if ds_attr = 'EFLD';                                                       //VHM1
        //Update Rename field using EXTFLD                  
        updatedsinfo(in_string : in_uwdsdtl : in_xref);                          //VHM1
      else;                                                                      //VHM1
        //Write DS Details in in_uwdsdtl Data Structure     
        writedsinfo(in_string : in_uwdsdtl : in_xref);
      endif;                                                                     //VHM1


   //When It Is LDS or EDS declaration
   when in_dsdcl = 'WDS';
      //Write DS Details in in_uwdsdtl Data Structure    
      writedsinfo(in_string : in_uwdsdtl : in_xref);
      return;

   other;
      return;
   endsl;

   if ds_mody <> *blanks and %scan(':':%trim(ds_mody)) > 0;
      ds_pos1 = %scan(':':%trim(ds_mody));
      if ds_pos1 > 1;                                                  //KM
         ds_mody = %subst(%trim(ds_mody) : 1 : ds_pos1 - 1);
      endif;                                                           //KM
   endif;

 //if %scan('"':%trim(ds_mody)) = 1;                                   //KM
   if %scan('"':ds_mody) = 1;                                          //KM
      ds_mody = %xlate('"' : '' : ds_mody);
   endif;

   //Update IAPGMREF file for DS and Its Fields
   return;

   begsr finddsfieldinfofr;
      //Find Data Structure Field Name

      exec sql                                                                           //TK01
        values upper(:in_String) into :ds_String;                                        //TK01
      ds_position = %scan('DCL-SUBF ' : %trim(ds_string));                               //TK01
      ds_instringlen = %len(%trim(in_string));                                           //SC01
    //if ds_position > *Zero;                                                    //SC01  //TK01
      if ds_position > 0 and %len(%trim(in_string)) >= 10;                               //SC01
        in_string = %subst(%trim(in_string) : 10);                                       //TK01
      endif;                                                                             //TK01
      ds_pos1 = %scan(' ' : %trim(in_string) : 1);
   // if ds_pos1 > *Zero;                                                                //KM
      if ds_pos1 > 1;                                                                    //KM
         ds_name = %subst(%trim(in_string) : 1 : ds_pos1-1 );
      endif;

      //Find Data Structure field Attribute
      select;
      //Check If It Is Based Field
      when (%scan(' LIKEDS' : in_string) > 0);                                  //KM
         ds_pos1 = %scan('LIKEDS' : in_string);                                 //KM
         ds_attr = 'LDS';
      when (%scan(' LIKE' : in_string) > 0);                                    //KM
         ds_pos1 = %scan('LIKE' : in_string);                                   //KM
         ds_attr = 'LFLD';
      when (%scan(' EXTFLD' : in_string) > 0);                                  //KM
         ds_pos1 = %scan('EXTFLD' : in_string);                                 //KM
         ds_attr = 'EFLD';
      other;
         //Check If It Is Overlay Field
       //if %scan(' OVERLAY': %trim(in_string) : ds_pos1 + 1)>0;                           //SC01
         if %scan(' OVERLAY': in_string : ds_pos1 + 1)>0;                                  //SC01
            ds_pos2 = %scan('OVERLAY': %trim(in_string) : ds_pos1 +1 );
            ds_pos2 = %scan('(' : %trim(in_string) : ds_pos2 + 1);
            ds_pos3 = %scan(':' : %trim(in_string) : ds_pos2 + 1);
            If  ds_pos2 + 1  <= ds_instringlen;                                            //SC01
               ds_pos3 = %scan(':' : %trim(in_string) : ds_pos2 + 1);
            endif;                                                                         //SC01
            if ds_pos3 = 0;
               ds_pos3 = %scan(')' : %trim(in_string) : ds_pos2 + 1);
            endif;
            If (ds_pos3 - ds_pos2 - 1) > 1;                                              //KM
               ds_mody = %subst(%trim(in_string) : ds_pos2 + 1 :ds_pos3 - ds_pos2 - 1);
            endif;
         endif;                                                                          //KM

         select;
         when %scan(' ' : %trim(in_string) : ds_pos1 + 1) > 0;
            ds_pos2 = %scan(' ' : %trim(in_string) : ds_pos1 + 1);
         when %scan(';' : %trim(in_string) : ds_pos1 + 1) > 0;
            ds_pos2 = %scan(';' : %trim(in_string) : ds_pos1 + 1);
         endsl;

         //Find DS Field Type
         clear wk_pos;
         if ds_pos1 > *zero;
            wk_pos = %scan(' OVERLAY' : %trim(in_string) : ds_pos1);
         endif;

         if ds_pos2 > 0 and wk_pos = 0;                                            //KM
            ds_attr = %subst(%trim(in_string) :ds_pos1+1 :ds_pos2-ds_pos1-1);
            if %scan('(' : %trim(ds_attr)) > 0;
               ds_pos3 = %scan('(' : %trim(ds_attr));
               if ds_pos3 > 1;                                                     //KM
                  ds_attr = %subst(%trim(ds_attr) : 1 : ds_pos3-1);
               endif;                                                             //KM
            endif;

            if (%scan(' POS' :%trim(in_string)) > 0 and ds_objv = 'INDDS-SUB');
               ds_pos1 = %scan('POS' : %trim(in_string): ds_pos1 + 1);
            endif;
         endif;
      endsl;

      ds_pos2 = %scan('(' : %trim(in_string) : ds_pos1 + 1);
      if ds_pos2 > 0 and ds_attr <> *blanks;
         ds_pos3 = %scan(':' : %trim(in_string) : ds_pos2 + 1);
         if ds_pos3 = 0;
            ds_pos3 = %scan(')' : %trim(in_string) : ds_pos2 + 1);
         endif;

         //Find Based Field Name
         if ds_attr = 'LFLD' or ds_attr = 'EFLD' or ds_attr = 'LDS';
            if ds_attr = 'EFLD';
               if ((ds_pos3 - ds_pos2) -3) > 0;                                              //KM
                  ds_mody = %subst(%trim(in_string) :(ds_pos2 + 2) :(ds_pos3 - ds_pos2) -3);
               endif;                                                                        //KM
            else;
               if (ds_pos3 - ds_pos2 -1) > 0;                                                //KM
                  ds_mody = %subst(%trim(in_string) :ds_pos2 + 1 :ds_pos3 - ds_pos2 -1);
               endif;                                                                        //KM
            endif;

         //Find Field Size/Indicator
         else;
            if (ds_pos3 - ds_pos2 -1) > 0;                                              //KM
               ds_fseqn = %subst(%trim(in_string): ds_pos2 + 1 :ds_pos3 - ds_pos2 -1);
            endif;                                                                      //KM
            ds_pos3  = %scan(':' : %trim(in_string) : ds_pos2 + 1);
            if ds_pos3 <> 0;
               monitor;
                  ds_pos4 = %scan(')' : %trim(in_string) : ds_pos3 + 1);
                  if (%check('0123456789': %trim(%subst(%trim(in_string): ds_pos3+1 :
                                                        ds_pos4 - ds_pos3 -1))) = 0 and
                      %subst(%trim(in_string):ds_pos3+1:ds_pos4 - ds_pos3 -1) <> *blanks);
                     ds_flddec = %dec(%subst(%trim(in_string): ds_pos3+1 :
                                             ds_pos4 - ds_pos3 -1) : 2 : 0);
                  endif;
               on-error;
                  ds_flddec = 0;
               endmon;
            endif;

            monitor;
               if %check(numConst:%trim(ds_fseqn)) = 0 and ds_fseqn <> *blanks;
                  ds_seqn = %dec(ds_fseqn : 6 : 0);
               endIf;
            on-error;
               ds_seqn = 0;
            endmon;
         endif;
      endif;
   endsr;

   begsr finddsinfofr;
      select;
      when %scan(' ' : %trim(in_string) : 8) > 0;
      when %scan(';' : %trim(in_string) : 8) > 0;
         ds_scoln = 'Y';
      other;
      endsl;

      //Find Data Structure Attribute
      if ds_scoln <> 'Y';

         //Check If Qualified
         if (%scan(' QUALIFIED' : %trim(in_string)) > 0);
            ds_qulflg = 'Q';
         endif;

         if (%scan(' PREFIX' : %trim(in_string)) > 0);
            ds_pos1 = %scan('(':%trim(in_string):%scan(' PREFIX' : %trim(in_string)));
            ds_pos2 = %scan(')' : %trim(in_string) : ds_pos1);
            if (ds_pos2 - ds_pos1 - 1) > 0;                                                   //KM
               in_uwdsdtl.dsprefix = %trim(%subst(%trim(in_string) :ds_pos1+1
                                                                   :ds_pos2 - ds_pos1 - 1));
            endif;                                                                            //KM
         endif;

         clear ds_pos1;
         clear ds_pos2;

         //Check If It Is Based Data Structure
         select;
         when (%scan(' LIKEDS': in_string) > 0);                                //KM
            ds_pos1 = %scan('LIKEDS' : in_string);                              //KM
            ds_attr = 'LDS';
            ds_type = 'B';
            ds_pos1 = %scan('LIKEDS' : in_string);
            ds_pos7 = %scan(')' : in_string:ds_pos1+1);
            ds_pos7 = ds_pos7 - (ds_pos1 + 7);
            if ds_pos7 > 0;                                                     //KM
            // ds_LikeDsNm = %subst(in_string :(ds_pos1 +7) :ds_pos7);
               ds_LikeDsNm =                                                             //0033
                      %trim(%subst(in_string :(ds_pos1 +7) :ds_pos7));                   //0033
            endif;                                                              //KM

            exec sql insert into qtemp/WkLikeDSPF values (:ds_MbrNm,
                                                          :ds_LibNm,
                                                          :ds_IfsLoc,                    //0033
                                                          :ds_LikeDsNm,
                                                          :ds_name);

         when (%scan(' EXTNAME': in_string) > 0);
            ds_pos1   = %scan('EXTNAME' : in_string);
            ds_type   = 'E';
            ds_attr   = 'EDS';

            ExtFileNm = scankeyword('EXTNAME(' :in_string);
            ds_pos5 = %scan('/' :ExtFileNm :1);
            ds_pos6 = %scan(':':ExtFileNm:1);                                            //0021

            select;                                                                      //0021
              when ds_pos5 > 1 and ds_pos6 = *zeros;                                     //0021
                 ExtLibNm  = %subst(ExtFileNm :1 :ds_pos5-1);                            //0021
                 ExtFileNm = %subst(ExtFileNm :ds_pos5+1);                               //0021
              when ds_pos5 > 1 and ds_pos6 > *zeros                                      //0021
                   and ds_pos6-ds_pos5-2 > *zeros;                                       //0021
                 ExtLibNm  = %subst(ExtFileNm :1 :ds_pos5-1);                            //0021
                 ExtFileNm = %subst(ExtFileNm :ds_pos5+1:ds_pos6-ds_pos5-2);             //0021
              when ds_pos5 = *zeros and ds_pos6 > 2;                                     //0021
                 ExtFileNm = %subst(ExtFileNm :1:ds_pos6-2);                             //0021

            endsl;                                                                       //0021

          //WrtSrcIntRefF(in_srclib :in_srcspf :in_srcmbr :in_type :                      //0033
            WrtSrcIntRefF(in_srclib :in_srcspf :in_srcmbr :in_IfsLoc :in_type :           //0033
                       // ExtFileNm :'*FILE'   :ExtLibNm  :1       :ds_attr);             //0023
                          ExtFileNm :'*FILE'   :ExtLibNm  :'I'     :ds_attr);             //0023

            exsr WriteExtFileFieldDtlFr;

         when (%scan(' LIKEREC': in_string) > 0);                                         //KM
            ds_pos1 = %scan('LIKEREC' : in_string);                                       //KM
            ds_type = 'E';
            ds_attr = 'DBDS';

         when (%scan(' DTAARA' : in_string) > 0);
            ds_pos1 = %scan('DTAARA' : in_string);                                        //KM
            ds_attr = 'DADS';                                                             //KM
            ds_type = 'B';

         when (%scan(' BASED' : in_string) > 0);                                          //KM
            ds_pos1 = %scan('BASED' : in_string);                                         //KM
            ds_attr = 'BDS';
            ds_type = 'B';

         other;
         endsl;

         //Find Based Data Structure name
         if ds_pos1 > 0;
            ds_pos2 = %scan('(' : %trim(in_string) : ds_pos1+ 1);
            if ds_pos2 > 0;
               ds_pos3 = %scan(')' : %trim(in_string) : ds_pos2 + 1);
               if (ds_pos3 - ds_pos2 - 1) > 1;                                             //KM
                  ds_mody = %subst(%trim(in_string) : ds_pos2 + 1 :ds_pos3 - ds_pos2 - 1);
               endif;                                                                      //KM
            endif;
         endif;

         //Find Data Structure Dimention
         if %scan(' DIM': %trim(in_string)) > 0;
            ds_pos1 = %scan(' DIM': %trim(in_string));
            ds_pos2 = %scan('(' : %trim(in_string) : ds_pos1 + 1);

            if ds_pos2 > 0;
               monitor;
                  ds_pos3 = %scan(')' : %trim(in_string) : ds_pos2 + 1);
                  if %check(numConst:%trim(%subst(%trim(in_string) : ds_pos2 + 1 :
                                                  ds_pos3 - ds_pos2 - 1))) = 0 and
                     %subst(%trim(in_string): ds_pos2+1 :ds_pos3-ds_pos2-1) <> *blanks;
                     ds_dim = %dec(%subst(%trim(in_string) : ds_pos2 + 1 :
                                          ds_pos3 - ds_pos2 - 1) : 7 : 0);
                  endIf;
               on-error;
                  ds_dim = 0;
               endmon;
            endif;
         endif;
      endif;
   endsr;

   begsr get_uwdsdtl;
      select;
      //When It Is Data Structure Declaration
      when in_dsdcl = 'DS';
         in_uwdsdtl.dssrclib = %trim(in_srclib);
         in_uwdsdtl.dssrcfln = %trim(in_srcspf);
         in_uwdsdtl.dspgmnm  = %trim(in_srcmbr);
         in_uwdsdtl.dsifsloc = %trim(in_ifsloc);                                         //0033
         in_uwdsdtl.dsname   = %trim(ds_name);

         if ds_type <> *blanks;
            in_uwdsdtl.dstype   = %trim(ds_type);
         else;
            in_uwdsdtl.dstype   = 'I';
         endif;

         in_uwdsdtl.dsobjv   = %trim(ds_objv);
         in_uwdsdtl.dsspcy   = %trim(ds_attr);
         in_uwdsdtl.dsbased  = %trim(ds_mody);
         in_uwdsdtl.dsqulflg = ds_qulflg;
         in_uwdsdtl.dslength = ds_length;
         in_uwdsdtl.dsdimen  = ds_dim;

         //Define The Data Structure Origin
         select;
         when ds_type = 'E';
            in_uwdsdtl.dsorigin = 'REFERENCE EXT FILE - ' + %trim(in_uwdsdtl.dsbased);
         when ds_type = 'B';
            in_uwdsdtl.dsorigin = 'REFERENCE DS - ' + %trim(in_uwdsdtl.dsbased);
         other;
            in_uwdsdtl.dsorigin = 'INTERNAL DS';
         endsl;

      //Create IAVVARREL entry for DS Definition...
         l_CalledFrom = 'IAPSRDSFR';                                                      //0009
         insertIavarrellog(l_CalledFrom  :ds_Attr   :ds_Flag   :in_xref                   //0009
                 //0033    :in_srclib    :in_srcspf :in_srcmbr :in_rrn_s                  //0009
                           :in_uWSrcDtl  :in_rrn_s                                        //0033
                           :in_dsdcl     :in_uwdsdtl);                                    //0009

      //When It Is DS Field Declaration
      when in_dsdcl = 'DSS';
         in_uwdsdtl.dsfldnm  = %trim(ds_name);

         if ds_attr = 'LFLD' or ds_attr = 'EFLD' or ds_attr = 'LDS' or
            %scan('*' : %trim(ds_attr) : 1) = 1;
            in_uwdsdtl.dsflspcy = %trim(ds_attr);
         else;
            in_uwdsdtl.dsfltyp  = %trim(ds_attr);
         endif;

         in_uwdsdtl.dsflto   = %trim(ds_eseqn);
         in_uwdsdtl.dsflfr   = %trim(ds_sseqn);
         in_uwdsdtl.dsflsiz  = ds_seqn;
         in_uwdsdtl.dsbfldnm = %trim(ds_mody);
         in_uwdsdtl.dsflobjv = %trim(ds_objv);
         in_uwdsdtl.dsfldrnk = in_uwdsdtl.dsfldrnk + 1;

         if in_uwdsdtl.dsqulflg = 'Q';
            in_uwdsdtl.dsqualnm = %trim(in_uwdsdtl.dsname) + '.' + %trim(ds_name);
         else;
            in_uwdsdtl.dsqualnm = %trim(ds_name);
         endif;

         in_uwdsdtl.dsfldec = ds_flddec;
         in_uwdsdtl.dsbfldnm = %trim(ds_mody);

      //Create IAVVARREL entry for DS Definition...
         l_CalledFrom = 'IAPSRDSFR';                                                      //0009
         insertIavarrellog(l_CalledFrom  :ds_Attr   :ds_Flag   :in_xref                   //0009
                 //0033    :in_srclib    :in_srcspf :in_srcmbr :in_rrn_s                  //0009
                           :in_uWSrcDtl  :in_rrn_s                                        //0033
                           :in_dsdcl     :in_uwdsdtl);                                    //0009

      endsl;
   endsr;

   begsr WriteExtFileFieldDtlFr;
      //Write external file field Detail
      exec sql
        declare IAPSRDS_C2 cursor for
          select WHFLDI, WHFLDB, WHFLDD, WHFLDP , WHFLDT
          from IDSPFFD
          where WHFILE = trim(:ExtFileNm)
            and WHFTYP = 'P';

      exec sql open IAPSRDS_C2;

      if SQLSTATE = SQL_ALL_OK;
         exec sql fetch IAPSRDS_C2 into :DsFileDtl;
         dow SQLSTATE = SQL_ALL_OK;
            in_uwdsdtl.DSSRCLIB = ds_LibNm;
            in_uwdsdtl.DSSRCFLN = ds_srcpf;
            in_uwdsdtl.DSPGMNM  = ds_MbrNm;
            in_uwdsdtl.DSIFSLOC = ds_IfsLoc;                                             //0033
            in_uwdsdtl.DSNAME   = %trim(ds_name);
            in_uwdsdtl.DSTYPE   = ds_type;
            in_uwdsdtl.DSFLDNM  = ds_WHFLDI;
            in_uwdsdtl.DSFLSIZ  = ds_WHFLDD;
            in_uwdsdtl.DSFLDEC  = ds_WHFLDP;

            select;
            when ds_WHFLDT ='A';
               in_uwdsdtl.DSFLTYP = 'CHAR';
            when ds_WHFLDT ='B';
               in_uwdsdtl.DSFLTYP = 'BINARY';
            when ds_WHFLDT ='P';
               in_uwdsdtl.DSFLTYP = 'PACKED';
            when ds_WHFLDT ='Z';
               in_uwdsdtl.DSFLTYP = 'TIMESTAMP';
            when ds_WHFLDT ='D';
               in_uwdsdtl.DSFLTYP = 'DATE';
            when ds_WHFLDT ='F';
               in_uwdsdtl.DSFLTYP = 'FLOATING';
            when ds_WHFLDT ='G';
               in_uwdsdtl.DSFLTYP = 'GRAPHIC';
            when ds_WHFLDT ='I';
               in_uwdsdtl.DSFLTYP = 'SIGNED INT';
            when ds_WHFLDT ='N';
               in_uwdsdtl.DSFLTYP = 'IND';
            when ds_WHFLDT ='S';
               in_uwdsdtl.DSFLTYP = 'ZONED';
            when ds_WHFLDT ='T';
               in_uwdsdtl.DSFLTYP = 'TIME';
            when ds_WHFLDT ='U';
               in_uwdsdtl.DSFLTYP = 'UNSIGN INT';
            when ds_WHFLDT ='*';
               in_uwdsdtl.DSFLTYP = 'POINTER';
            endsl;

            select;
            when ds_WHFLDD =  *Zero And ds_WHFLDP = *Zero;
               in_uwdsdtl.DSFLSIZ = ds_WHFLDB;
               in_uwdsdtl.DSFLDEC = ds_WHFLDP;
            when ds_WHFLDD <> *Zero And ds_WHFLDP <> *Zero;
               in_uwdsdtl.DSFLSIZ = ds_WHFLDD;
               in_uwdsdtl.DSFLDEC = ds_WHFLDP;
            when ds_WHFLDD <> *Zero And ds_WHFLDP = *Zero;
               in_uwdsdtl.DSFLSIZ = ds_WHFLDD;
               in_uwdsdtl.DSFLDEC = ds_WHFLDP;
            endsl;

         // If %scan(':' :%trim(in_uwdsdtl.dsprefix)) > 0;                               //MT01
            If %scan(':' :%trim(in_uwdsdtl.dsprefix)) > 1;                               //KM
               replaceStr = %subst(in_uwdsdtl.dsprefix : 1                               //MT01
                                      : %scan(':' :%trim(in_uwdsdtl.dsprefix)) -1);      //MT01
               len = %int(%subst(in_uwdsdtl.dsprefix :                                   //MT01
                                %scan(':' :%trim(in_uwdsdtl.dsprefix)) + 1) );           //MT01
               in_uwdsdtl.dsfldnmpf =  %replace(%trim(replaceStr) :                      //MT01
                                                %trim(in_uwdsdtl.dsfldnm) : 1 : len);    //MT01
            Else;                                                                        //MT01
               in_uwdsdtl.dsfldnmpf = %trim(in_uwdsdtl.dsprefix) +                       //MT01
                                      %trim(in_uwdsdtl.DSFLDNM) ;                        //MT01
            Endif;                                                                       //MT01

            writedsinfo(in_string : in_uwdsdtl : lref);
            exec sql fetch IAPSRDS_C2 into :DsFileDtl;
         enddo;
      endif;

      exec sql close IAPSRDS_C2;
      clear in_uwdsdtl.dsfldnmpf;
   endsr;

end-proc;

Dcl-Proc insertIavarrellog EXPORT;                                                        //0009
   Dcl-Pi insertIavarrellog;                                                              //0009
      in_CalledFrm  Char(50);                                                             //0009
      in_dsAttr     Char(10);                                                             //0009
      in_ds_Flag    Ind;                                                                  //0009
      in_xref       char(10);                                                             //0009
   // in_srclib     char(10);                                                             //0033
   // in_srcspf     char(10);                                                             //0033
   // in_srcmbr     char(10);                                                             //0033
      in_uWSrcDtl likeds(uWSrcDtl);                                                       //0033
      in_rrn_s      packed(6:0);                                                          //0009
      in_dsdcl      char(3);                                                              //0009
      in_uwdsdtl    likeds(uwdsdtl_t);                                                    //0009
   End-Pi;                                                                                //0009

      uWSrcDtl = in_uWSrcDtl;                                                            //0033
   //Only applicable for free format calls...                                            //0009
   //Skip for DS specials (LIKEDS/EXTNAME/LDS)...                                        //0009
      If in_CalledFrm = 'IAPSRDSFR';                                                      //0009
         If Not in_ds_Flag;                                                               //0009
            Return;                                                                       //0009
         EndIf;                                                                           //0009
      EndIf;                                                                              //0009

   //Insert the variables into IAVARREL File                                             //0009
      xl_RESRCLIB = in_srclib;                                                            //0009
      xl_RESRCFLN = in_srcspf;                                                            //0009
      xl_REPGMNM  = in_srcmbr;                                                            //0009
      xl_REIFSLOC = in_ifsloc;                                                            //0033
      xl_RESEQ    = 1;                                                                    //0009
      xl_RERRN    = in_rrn_s;                                                             //0009
      xl_REOPC    = 'DCL-DS';                                                             //0009
      If in_dsdcl = 'DS';                                                                 //0009
         Clear xl_RERESULT;                                                               //0009
         xl_REFACT1  = in_uwdsdtl.dsname;                                                 //0009
      ElseIf in_dsdcl = 'DSS';                                                            //0009
         xl_RERESULT = in_uwdsdtl.dsname;                                                 //0009
         xl_REFACT1  = in_uwdsdtl.dsfldnm;                                                //0009
      EndIf;                                                                              //0009
      If in_dsAttr = 'LDS';                                                               //0009
         xl_REFACT2 = in_uwdsdtl.dsbased;                                                 //0009
      Else;                                                                               //0009
         Clear xl_REFACT2;                                                                //0009
      EndIf;                                                                              //0009
      xl_RENUM1 = 0;                                                                      //0009
      xl_RENUM2 = 0;                                                                      //0009
      xl_RENUM3 = 0;                                                                      //0009
      xl_RENUM4 = 0;                                                                      //0009
      xl_RENUM5 = 0;                                                                      //0009
      xl_RENUM6 = 0;                                                                      //0009
      xl_RENUM7 = 0;                                                                      //0009
      xl_RENUM8 = 0;                                                                      //0009
      xl_RENUM9 = 0;                                                                      //0009
                                                                                          //0009
      IaVarRelLog(                                                                        //0009
//0033 xl_RESRCLIB  :xl_RESRCFLN   :xl_REPGMNM     :xl_RESEQ       :xl_RERRN              //0009
       xl_RESRCLIB  :xl_RESRCFLN   :xl_REPGMNM     :xl_REIFSLOC    :xl_RESEQ   :xl_RERRN  //0033
      :xl_REROUTINE :xl_RERELTYP   :xl_RERELNUM    :xl_REOPC       :xl_RERESULT           //0009
      :xl_REBIF     :xl_REFACT1    :xl_RECOMP      :xl_REFACT2     :xl_RECONTIN           //0009
      :xl_RERESIND  :xl_RECAT1     :xl_RECAT2      :xl_RECAT3      :xl_RECAT4             //0009
      :xl_RECAT5    :xl_RECAT6     :xl_REUTIL      :xl_RENUM1      :xl_RENUM2             //0009
      :xl_RENUM3    :xl_RENUM4     :xl_RENUM5      :xl_RENUM6      :xl_RENUM7             //0009
      :xl_RENUM8    :xl_RENUM9     :xl_REEXC       :xl_REINC  );                          //0009
                                                                                          //0009
      if SQLSTATE <> SQL_ALL_OK;                                                          //0009
         //log error                                                                     //0009
      endif;                                                                              //0009
End-Proc;                                                                                 //0009

dcl-proc IAPSRDSFX Export;
   dcl-pi IAPSRDSFX;
      in_string  char(5000);
      in_type    char(10);
      in_error   char(10);
      in_xref    char(10);
    //in_srclib  char(10);                                                                    //0002
    //in_srcspf  char(10);                                                                    //0002
    //in_srcmbr  char(10);                                                                    //0002
    //in_srclib  char(10) const options(*trim);                                          0033 //0002
    //in_srcspf  char(10) const options(*trim);                                          0033 //0002
    //in_srcmbr  char(10) const options(*trim);                                          0033 //0002
      in_uWSrcDtl likeds(uWSrcDtl);                                                           //0033
      in_rrn_s   packed(6:0);
      in_rrn_e   packed(6:0);
      in_dsdcl   char(3);
      in_dsobjv  char(10);
      in_dsname  char(128);
      in_dsmody  char(10);
      in_uwdsdtl likeds(uwdsdtl_t);
      in_longnm  char(74) options(*nopass) value;                                        //0031
   end-pi;

   dcl-ds DsFileDtl;
      ds_WHFLDI char(10);
      ds_WHFLDB packed(5:0);
      ds_WHFLDD packed(2:0);
      ds_WHFLDP packed(2:0);
      ds_WHFLDT char(1);
   end-ds;

   dcl-ds uwdsdtl1 likeds(uwdsdtl_t) inz;

   dcl-s ds_pos1    packed(6:0) inz;                                                     //MT01
   dcl-s ds_pos2    packed(6:0) inz;                                                     //MT01
   dcl-s ds_pos3    packed(6:0) inz;                                                     //MT01
   dcl-s ds_pos4    packed(6:0) inz;                                                     //MT01
   dcl-s ds_pos5    packed(6:0) inz;                                                     //MT01
   dcl-s ds_pos7    packed(6:0) inz;
   dcl-s ds_name    char(128)   inz;
   dcl-s ds_objv    char(10)    inz;
   dcl-s ds_attr    char(10)    inz;
   dcl-s ds_mody    char(128)   inz;
   dcl-s ds_sts     char(10)    inz;
   dcl-s ds_seqn    packed(6:0) inz;
   dcl-s ds_sseqn   char(10)    inz;
   dcl-s ds_eseqn   char(10)    inz;
   dcl-s ds_objvref char(10)    inz;
   dcl-s ds_fseqn   char(10)    inz;
   dcl-s ds_scoln   char(1)     inz;
   dcl-s ds_qulflg  char(1)     inz;
   dcl-s ds_length  packed(8:0) inz;
   dcl-s ds_dim     packed(7:0) inz;
   dcl-s ds_flddec  packed(2:0) inz;
   dcl-s len        packed(4:0) inz;                                                     //MT01
   dcl-s ds_type    char(1)     inz;
   dcl-s lref       char(10)    inz;
 //dcl-s ExtFileNm  char(10) inz;                                                        //0021
   dcl-s ExtFileNm  varchar(5000) inz;                                                   //0021
   dcl-s ExtLibNm   char(10)    inz;                                                     //0021
   dcl-s ds_LikeDsNm char(128)  inz;
   dcl-s ds_LibNm   char(10)    inz;
   dcl-s ds_srcpf   char(10)    inz;
   dcl-s ds_MbrNm   char(10)    inz;
   dcl-s ds_IfsLoc  char(100)   inz;                                                     //0033
   dcl-s ds_InvCln  char(4)     inz('''');
   dcl-s ds_DInvCln char(4)     inz('"');
   dcl-s replaceStr char(20);                                                            //MT01
   dcl-s c          char(1);
   dcl-s l_CalledFrom Char(50);                                                          //0009
   dcl-s l_DsFlag     Ind;                                                               //0009
   dcl-s ds_name1       char(128)   inz;                                                 //0033
   dcl-s Wk_Pos         packed(4:0) inz;                                                 //0033
   dcl-s Wk_LongKeyword char(128)   inz;                                                 //0033

   if in_string = *Blanks;
      return;
   endif;
   clear in_uwdsdtl.dsfldnm;
   clear in_uwdsdtl.dsfldnmpf;
   clear in_uwdsdtl.dsfltyp;
   clear in_uwdsdtl.dsflto;
   clear in_uwdsdtl.dsflfr;
   clear in_uwdsdtl.dsflsiz;
   clear in_uwdsdtl.dsbfldnm;
   clear in_uwdsdtl.dsqualnm;
   clear in_uwdsdtl.dsfldec;
   clear in_uwdsdtl.dsbfldnm;
   clear in_uwdsdtl.dsflspcy;

   //D-Spec data structure info                                                             //0007
   Clear DspecV4 ;                                                                           //0007
   DspecV4 =  in_string  ;                                                                   //0007

   uWSrcDtl = in_uWSrcDtl;                                                               //0033
   //Set program variables
   ds_mody  = in_dsmody;
   ds_name  = in_dsname;
   ds_objv  = in_dsobjv;
   ds_LibNm = in_srclib;
   ds_srcpf = in_srcspf;
   ds_MbrNm = in_srcmbr;
   ds_IfsLoc= in_IfsLoc;                                                                 //0033

   //Check Declaration Status and capture info
   select;

   //When It Is Data Structure Declaration
   when in_dsdcl = 'DS';
      clear in_uwdsdtl.dsfldrnk;
      clear in_uwdsdtl.dslength;
      clear in_uwdsdtl.dsdimen;

      if ds_objv = 'INFDS-VAR' or ds_objv = 'INDDS-VAR';
        ds_type = 'E';
      endif;

      //Find Data Structure info 
      exsr finddsinfofx;

      //Get DS Values in in_uwdsdtl Data Structure
      exsr get_uwdsdtl;

   //When It Is DS Field Declaration
   when in_dsdcl = 'DSS';
      //Find Data Structure Field Info
      exsr finddsfieldinfofx;

      //Get Field Values in in_uwdsdtl Data Structure
      exsr get_uwdsdtl;

      if ds_attr = 'EFLD';                                                       //VHM1
        //Update Rename field using EXTFLD                  
        updatedsinfo(in_string : in_uwdsdtl : in_xref);                          //VHM1
      else;                                                                      //VHM1
        //Write DS Details in in_uwdsdtl Data Structure    
        writedsinfo(in_string : in_uwdsdtl : in_xref);
      endif;

   //When It Is LDS or EDS declaration
   when in_dsdcl = 'WDS';
      //Write DS Details in in_uwdsdtl Data Structure    
      writedsinfo(in_string : in_uwdsdtl : in_xref);
      return;

   other;
      return;
   endsl;

   if ds_mody <> *blanks and %scan(':':%trim(ds_mody)) > 0;
      ds_pos1 = %scan(':':%trim(ds_mody));
      if ds_pos1 > 1;                                                            //KM
         ds_mody = %subst(%trim(ds_mody) : 1 : ds_pos1 - 1);
      endif;                                                                     //KM
   endif;

   if %scan('"':ds_mody) = 1;                                                    //KM
      ds_mody = %xlate('"' : '' : ds_mody);
   endif;

   //Update IAPGMREF file for DS and Its Fields
   return;

   begsr finddsinfofx;
      //Check If Qualified
      if DspecV4.keyword <> *blank and %scan('QUALIFIED' : DspecV4.keyword) > 0 ;          //0007
         ds_qulflg = 'Q';
      endif;

        //if (%scan('PREFIX' : in_string : 44) > 0);                                        //MT01
        //   ds_pos1 = %scan('(': in_string                                                 //MT01
        //                      : %scan('PREFIX' : in_string  : 44 ));                      //MT01
        //   if ds_pos1 > 0 ;                                                               //MT05
        //   ds_pos2 = %scan(')' :  in_string  : ds_pos1);                                  //MT01
        //   endif ;                                                                        //MT05
        //   if ds_pos2 > 0 and (ds_pos2 - ds_pos1 ) > 1;                                   //KM
        //      in_uwdsdtl.dsprefix = %trim(%subst( in_string  : ds_pos1 + 1                //MT01
        //                                                       : ds_pos2 - ds_pos1 - 1)); //MT01
      if DspecV4.keyword <> *blank ;                                                        //0007
          if (%scan('PREFIX' : DspecV4.keyword )) > 0;                                      //0007
             ds_pos1 = %scan('(': DspecV4.keyword                                           //0007
                                : %scan('PREFIX' : DspecV4.keyword ));                      //0007
             ds_pos2 = %scan(')' : DspecV4.keyword : ds_pos1);                              //0007
             if (ds_pos2 - ds_pos1 - 1) >= 1 ;                                              //KM
                in_uwdsdtl.dsprefix = %trim(%subst( DspecV4.keyword  : ds_pos1 + 1          //0007
                                                                 : ds_pos2 - ds_pos1 - 1)); //0007
             endif;                                                                         //KM
          endif;                                                                            //MT01
      endif;

      clear ds_pos1;
      clear ds_pos2;

      //Find Data Structure Attribute 
      select;
      //Check If It Is Based Data Structure
      when DspecV4.keyword <> *blank and %scan('LIKEDS' : DspecV4.keyword) > 0 ;         //0007
         ds_pos1     = %scan('LIKEDS' : DspecV4.keyword);                                //0007
         ds_attr     = 'LDS';
         ds_type     = 'B';
         ds_pos7     = %scan(')' : DspecV4.keyword:ds_pos1+1);                           //0007
         if ds_pos7 > 0 and  ds_pos7 > ds_pos1 + 7;
            ds_pos7     = ds_pos7 - (ds_pos1 + 7);
         endif;

         if ds_pos7 > 0 ;                                                                //MT05
          //ds_LikeDsNm = %subst(DspecV4.keyword :(ds_pos1 +7) :ds_pos7);                //0007 0033
            ds_LikeDsNm =                                                                //0033
            %trim(%subst(DspecV4.keyword :(ds_pos1 +7) :ds_pos7));                       //0033
         endif ;                                                                         //MT05

         exec sql insert into qtemp/WkLikeDSPF values (:ds_MbrNm,
                                                       :ds_LibNm,
                                                       :ds_IfsLoc,                       //0033
                                                       :ds_LikeDsNm, :ds_name);

      when (DspecV4.keyword <> *blank and %scan('EXTNAME' : DspecV4.keyword) > 0) and       //0007
           (DspecV4.external = 'E');                                                        //0007
         ds_pos1 = %scan('(' :DspecV4.keyword);                                          //0021
         ds_attr = 'EDS';
         ds_type = 'E';
         ds_pos5 = %scan(')' : DspecV4.keyword:ds_pos1+1);                                  //0007

         If ds_pos5 = *Zeros ;                                                           //0033
            Wk_LongKeyword = %trim(DspecV4.keyword) + %trim(DSPECV4.COMMENT);            //0033
            ds_pos5 = %scan(')' : Wk_LongKeyword:ds_pos1+1);                             //0033
         EndIf ;                                                                         //0033

         if ds_pos5 > ds_pos1+1;                                                         //0021
            If ds_pos5 < 38 ;                                                            //0033
            ExtFileNm = %subst(DspecV4.keyword:ds_pos1 +1 :ds_pos5-(ds_pos1+1));         //0021
            Else ;                                                                       //0033
            ExtFileNm = %subst(Wk_LongKeyword:ds_pos1 +1 :ds_pos5-(ds_pos1+1));          //0033
            EndIf ;                                                                      //0033
         endif;                                                                          //0021

         if ExtFileNm <> *blanks;                                                        //0021
            ExtFileNm =%trim(ExtFileNm:' ''''" ');                                       //0021
            ds_pos1=%scan('/':ExtFileNm);                                                //0021
            ds_pos5=%scan(':': ExtFileNm);                                               //0021
         endif;                                                                          //0021

         select;                                                                         //0021
           when ds_pos1 > 1 and ds_pos5 > *zero                                          //0021
                and ds_pos5-ds_pos1-1 > *zero;                                           //0021
              ExtLibnm  = %subst(ExtFileNm:1:ds_pos1-1);                                 //0021
              ExtFileNm = %subst(ExtFileNm:ds_pos1+1:ds_pos5-ds_pos1-1);                 //0021

           when ds_pos1 > 1;                                                             //0021
              ExtLibnm  = %subst(ExtFileNm:1:ds_pos1-1);                                 //0021
              ExtFileNm = %subst(ExtFileNm:ds_pos1+1);                                   //0021

           when ds_pos5 > 1;                                                             //0021
              ExtFileNm = %subst(ExtFileNm:1:ds_pos5-1);                                 //0021

           other;                                                                        //0021
              ExtFileNm = %subst(ExtfileNm:1);                                           //0021

         endsl;                                                                          //0021

         ExtFileNm =%trim(ExtFileNm:' ''''" ');                                          //0021

      // WrtSrcIntRefF(in_srclib :in_srcspf :in_srcmbr :in_type :                    0033//0021
         WrtSrcIntRefF(in_srclib :in_srcspf :in_srcmbr :in_IfsLoc :in_type :             //0033
                    // ExtFileNm :'*FILE'   : ExtLibNm :1       :ds_attr);         //0021//0023
                       ExtFileNm :'*FILE'   : ExtLibNm :'I'     :ds_attr);         //0021//0023

         exsr WriteExtFileFieldDtlFx;

      when DspecV4.keyword <> *blank and %scan('LIKEREC' : DspecV4.keyword) >0 ;         //0007
         ds_pos1 = %scan('LIKEREC' : DspecV4.keyword );                                  //0007
         ds_attr = 'DBDS';
         ds_type = 'E';

      when (DspecV4.keyword <> *blank and %scan('DTAARA' : DspecV4.keyword) >0) and      //0007
           (DspecV4.dsType = 'U');                                                       //0007
         ds_pos1 = %scan('DTAARA' : DspecV4.keyword);                                    //0007
         ds_attr = 'DADS';
         ds_type = 'B';

       when DspecV4.keyword <> *blank and %scan('BASED' : DspecV4.keyword) >0 ;              //0007
          ds_pos1 = %scan('BASED' : DspecV4.keyword);                                        //0007
         ds_attr = 'BDS';
         ds_type = 'B';

      other;
      endsl;

      //Find Based Data Structure name
      if ds_pos1 > 0;
         ds_pos2 = %scan('(' : DspecV4.keyword : ds_pos1+ 1);                               //0007
         if ds_pos2 > 0;
            ds_pos3 = %scan(')' : DspecV4.keyword : ds_pos2 + 1);                           //0007
            if (ds_pos3 - ds_pos2 - 1) > 0;                                             //KM
               ds_mody = %subst(DspecV4.keyword  : ds_pos2 + 1 :ds_pos3 - ds_pos2 - 1);     //0007
            endif;                                                                      //KM
         endif;
      endif;

      //Find Data Structure Length
                                                                                            //0007
      if (DspecV4.toLength <> *blanks and  %check(numConst:%trim(DspecV4.toLength)) = 0);   //0007
            ds_length = %dec(DspecV4.toLength:8:0) ;                                        //0007
      endif;                                                                                //0007


      //Find Data Structure Dimention
      if DspecV4.keyword <> *blank and %scan('DIM' : DspecV4.keyword) >0 ;                  //0007
         ds_pos1 = %scan('DIM':DspecV4.keyword);                                            //0007
         ds_pos2 = %scan('(' : DspecV4.keyword : ds_pos1 + 1);                              //0007

         if ds_pos2 > 0;
            monitor;
                                                                                              //0007
                ds_pos3 = %scan(')' : DspecV4.keyword : ds_pos2 + 1);                         //0007
                if (%check(numConst:%trim(%subst(DspecV4.keyword:ds_pos2+1:                   //0007
                                                 ds_pos3-ds_pos2-1))) = 0  and                //0007
                    %subst(DspecV4.keyword :ds_pos2+1 :ds_pos3-ds_pos2-1) <> *blanks);        //0007
                   ds_dim = %dec(%subst(DspecV4.keyword: ds_pos2+1:ds_pos3-ds_pos2-1):7:0);   //0007

               endIf;
            on-error;
               ds_dim = 0;
            endmon;
         endif;
      endif;
   endsr;

   begsr finddsfieldinfofx;
      //Find Data Structure Field Name
      If %parms > 14;                                                                    //0033
         ds_name = in_longnm;                                                            //0033
      Else;                                                                              //0033
      ds_name = DspecV4.name;                                                                //0007
      Endif;                                                                             //0033

      //Find Data Structure field Attribute
      select;
      //Check If It Is Based Field
      when DspecV4.keyword <> *blank and %scan('LIKEDS' : DspecV4.keyword) > 0 ;             //0007
         ds_pos1 = %scan('LIKEDS' : DspecV4.keyword);                                        //0007
         ds_attr = 'LDS';
      when DspecV4.keyword <> *blank and %scan('LIKE' : DspecV4.keyword) > 0 ;               //0007
         ds_pos1 = %scan('LIKE' : DspecV4.keyword);                                          //0007
         ds_attr = 'LFLD';
      when (DspecV4.keyword <> *blank and %scan('EXTFLD' : DspecV4.keyword) > 0 )            //0007
            and (DspecV4.external = 'E');                                                    //0007
         ds_pos1 = %scan('EXTFLD' : DspecV4.keyword);                                        //0007
         ds_attr = 'EFLD';
      other;
         //Get Field Type

         if DspecV4.internalDataType <> *blanks;                                             //0007
            select;                                                                          //0007
            when (DspecV4.internalDataType = 'A');                                           //0007
               ds_attr = 'Char';                                                             //0007
            when (DspecV4.internalDataType = 'B');                                           //0007
               ds_attr = 'Binary';                                                           //0007
            when (DspecV4.internalDataType = 'D');                                           //0007
               ds_attr = 'Date';                                                             //0007
            when (DspecV4.internalDataType = 'F');                                           //0007
               ds_attr = 'Floating';                                                         //0007
            when (DspecV4.internalDataType = 'G');                                           //0007
               ds_attr = 'Graphic';                                                          //0007
            when (DspecV4.internalDataType = 'I');                                           //0007
               ds_attr = 'Signed int';                                                       //0007
            when (DspecV4.internalDataType = 'N');                                           //0007
               ds_attr = 'Ind';                                                              //0007
            when (DspecV4.internalDataType = 'P');                                           //0007
               ds_attr = 'Packed';                                                           //0007
            when (DspecV4.internalDataType = 'S');                                           //0007
               ds_attr = 'Zoned';                                                            //0007
            when (DspecV4.internalDataType = 'T');                                           //0007
               ds_attr = 'Time';                                                             //0007
            when (DspecV4.internalDataType = 'Z');                                           //0007
               ds_attr = 'Timestamp';                                                        //0007
            when (DspecV4.internalDataType = 'U');                                           //0007
               ds_attr = 'Unsign Int';                                                       //0007
            when (DspecV4.internalDataType = '*');                                           //0007
               ds_attr = 'Pointer';                                                          //0007
            endsl;                                                                           //0007
         else;                                                                               //0007
            ds_attr = 'Char';                                                                //0007
         endif;                                                                              //0007
         //Check If It Is Overlay Field 
         if DspecV4.keyword <> *blank and %scan('OVERLAY' : DspecV4.keyword) > 0;            //0007
            ds_pos1 = %scan('OVERLAY': DspecV4.keyword);                                     //0007
         endif;
      endsl;

      //Get Based Field Name
      if ds_pos1 <> 0;                                                                       //0007
         ds_pos2 = %scan('(' : DspecV4.keyword : ds_pos1 + 1);                               //0007
         if ds_pos2 > 0;                                                                     //0007
            ds_pos3 = %scan(':' : DspecV4.keyword: ds_pos2 + 1);                             //0007
            if ds_pos3 <> 0;                                                                 //0007
               // Get Indicator value                                                        //0007
               ds_pos4 = %scan(')' : DspecV4.keyword : ds_pos3 + 1);                         //0007
               if ds_attr = 'Ind';                                                           //0007
                  monitor;                                                                   //0007
                     if %check(numConst:%trim(%subst(DspecV4.keyword : ds_pos3+1 :           //0007
                                                     ds_pos4 - ds_pos3 - 1))) = 0 and        //0007
                        %subst(DspecV4.keyword :ds_pos3+1 :ds_pos4-ds_pos3-1) <> *blanks;    //0007
                        ds_seqn = %dec(%trim(%subst(DspecV4.keyword : ds_pos3+1 :            //0007
                                                    ds_pos4-ds_pos3-1)): 6 : 0);             //0007
                     endIf;                                                                  //0007
                  on-error;                                                                  //0007
                     ds_seqn = 0;                                                            //0007
                  endmon;                                                                    //0007
               endif;                                                                        //0007
            else;                                                                            //0007
               ds_pos3 = %scan(')' : DspecV4.keyword : ds_pos2 + 1);                         //0007
            endif;                                                                           //0007
            if (ds_pos3 - ds_pos2 -1) > 0;                                            //KM
               ds_mody = %subst(DspecV4.keyword : ds_pos2 + 1 :ds_pos3 - ds_pos2 -1);        //0007
            endif;                                                                    //KM
         endif;
      endif;

      //Find Field Size, From Pos, To Pos & Dec Pos
      if (DspecV4.fromLength <> *blanks or                                                   //0007
          DspecV4.toLength <> *blanks) and ds_attr <> 'Ind';                                 //0007
         ds_eseqn = DspecV4.toLength;                                                        //0007
         if ds_eseqn <> *blanks;
            ds_sseqn = DspecV4.fromLength ;                                               //0007
            select;
            when ds_sseqn = *blanks;
               monitor;
                  if %check(numConst:%trim(ds_eseqn)) = 0 ;
                     ds_seqn = %dec(ds_eseqn : 6 : 0);
                  endIf;
               on-error;
                  ds_seqn = 0;
               endmon;
            when %subst(%trim(ds_sseqn) : 1 : 1) = '*';
               ds_attr = ds_sseqn;
            other;
               monitor;
                  if %check(numConst:%trim(ds_eseqn)) = 0 ;
                     ds_seqn = %dec(ds_eseqn : 6 : 0) - %dec(ds_sseqn : 6 : 0) + 1;
                  endIf;
               on-error;
                  ds_seqn = 0;
               endmon;
            endsl;
          elseif DspecV4.fromLength <> *blanks;                                               //0007
             ds_attr = DspecV4.fromLength;                                                    //0007
         endif;
      endif;


      if DspecV4.decimalPosition <> *blanks;                                                 //0007
         if %check(numConst:DspecV4.decimalPosition) = 0 ;                                   //0007
            ds_flddec = %dec(DspecV4.decimalPosition: 2 : 0);                                //0007
         endIf;                                                                              //0007
         if ds_attr = 'Char';
            ds_attr = 'Zoned Dec';
         endif;
      endif;
   endsr;

   begsr get_uwdsdtl;
      select;
      //When It Is Data Structure Declaration
      when in_dsdcl = 'DS';
       //in_uwdsdtl.dssrclib = %trim(in_srclib);                                              //0002
       //in_uwdsdtl.dssrcfln = %trim(in_srcspf);                                              //0002
       //in_uwdsdtl.dspgmnm  = %trim(in_srcmbr);                                              //0002
         in_uwdsdtl.dssrclib = in_srclib;                                                     //0002
         in_uwdsdtl.dssrcfln = in_srcspf;                                                     //0002
         in_uwdsdtl.dspgmnm  = in_srcmbr;                                                     //0002
         in_uwdsdtl.dsifsloc = %trim(in_ifsloc);                                              //0033
         in_uwdsdtl.dsname   = %trim(ds_name);

         if ds_type <> *blanks;
            in_uwdsdtl.dstype   = %trim(ds_type);
         else;
            in_uwdsdtl.dstype   = 'I';
         endif;

         in_uwdsdtl.dsobjv   = %trim(ds_objv);
         in_uwdsdtl.dsspcy   = %trim(ds_attr);
         in_uwdsdtl.dsbased  = %trim(ds_mody);
         in_uwdsdtl.dsqulflg = ds_qulflg;
         in_uwdsdtl.dslength = ds_length;
         in_uwdsdtl.dsdimen  = ds_dim;

         //Define The Data Structure Origin
         select;
         when ds_type = 'E';
            in_uwdsdtl.dsorigin = 'DEFERENCE EXT FILE - ' + %trim(in_uwdsdtl.dsbased);
         when ds_type = 'B';
            in_uwdsdtl.dsorigin = 'REFERENCE DS - ' + %trim(in_uwdsdtl.dsbased);
         other;
            in_uwdsdtl.dsorigin = 'INTERNAL DS';
         endsl;

      //Create IAVVARREL entry for DS Definition...
         l_CalledFrom = 'IAPSRDSFX';                                                      //0009
         l_DsFlag     = *Off;                                                             //0009
         insertIavarrellog(l_CalledFrom  :ds_Attr   :l_DsFlag  :in_xref                   //0009
                      //   :ds_LibNm     :ds_srcpf  :ds_MbrNm  :in_rrn_s            //0033//0009
                           :in_uWSrcDtl  :in_rrn_s                                        //0033
                           :in_dsdcl     :in_uwdsdtl);                                    //0009

      //When It Is DS Field Declaration
      when in_dsdcl = 'DSS';
         in_uwdsdtl.dsfldnm  = %trim(ds_name);

         if ds_attr = 'LFLD' or ds_attr = 'EFLD' or ds_attr = 'LDS' or
            %scan('*' : %trim(ds_attr) : 1) = 1;
            in_uwdsdtl.dsflspcy = %trim(ds_attr);
         else;
            in_uwdsdtl.dsfltyp  = %trim(ds_attr);
         endif;

         in_uwdsdtl.dsflto   = %trim(ds_eseqn);
         in_uwdsdtl.dsflfr   = %trim(ds_sseqn);
         in_uwdsdtl.dsflsiz  = ds_seqn;
         in_uwdsdtl.dsbfldnm = %trim(ds_mody);
         in_uwdsdtl.dsflobjv = %trim(ds_objv);
         in_uwdsdtl.dsfldrnk = in_uwdsdtl.dsfldrnk + 1;

         if in_uwdsdtl.dsqulflg = 'Q';
            in_uwdsdtl.dsqualnm = %trim(in_uwdsdtl.dsname) + '.' + %trim(ds_name);
         else;
            in_uwdsdtl.dsqualnm = %trim(ds_name);
         endif;

         in_uwdsdtl.dsfldec = ds_flddec;
         in_uwdsdtl.dsbfldnm = %trim(ds_mody);

      //Create IAVVARREL entry for DS Definition...
         l_CalledFrom = 'IAPSRDSFX';                                                      //0009
         l_DsFlag     = *Off;                                                             //0009
         insertIavarrellog(l_CalledFrom  :ds_Attr   :l_DsFlag  :in_xref                   //0009
                       //  :ds_LibNm     :ds_srcpf  :ds_MbrNm  :in_rrn_s            //0033//0009
                           :in_uWSrcDtl  :in_rrn_s                                        //0033
                           :in_dsdcl     :in_uwdsdtl);                                    //0009

      endsl;
   endsr;

   begsr WriteExtFileFieldDtlFx;
      //Write external file field Detail
      exec sql
        declare IAPSRDS_C1 cursor for
          select WHFLDI, WHFLDB, WHFLDD, WHFLDP , WHFLDT
          from IDSPFFD
          where WHFILE = trim(:ExtFileNm)
            and WHFTYP = 'P';

      exec sql open IAPSRDS_C1;

      if SQLSTATE = SQL_ALL_OK;
         exec sql fetch IAPSRDS_C1 into :DsFileDtl;

         dow SQLSTATE = SQL_ALL_OK;
            in_uwdsdtl.DSSRCLIB = ds_LibNm;
            in_uwdsdtl.DSSRCFLN = ds_srcpf;
            in_uwdsdtl.DSPGMNM  = ds_MbrNm;
            in_uwdsdtl.DSIFSLOC = ds_IfsLoc;                                             //0033
            in_uwdsdtl.DSNAME   = %trim(ds_name);
            in_uwdsdtl.DSTYPE   = ds_type;
            in_uwdsdtl.DSFLDNM  = ds_WHFLDI;
            in_uwdsdtl.DSFLSIZ  = ds_WHFLDD;
            in_uwdsdtl.DSFLDEC  = ds_WHFLDP;

            select;
            when ds_WHFLDT ='A';
               in_uwdsdtl.DSFLTYP = 'CHAR';
            when ds_WHFLDT ='B';
               in_uwdsdtl.DSFLTYP = 'BINARY';
            when ds_WHFLDT ='P';
               in_uwdsdtl.DSFLTYP = 'PACKED';
            when ds_WHFLDT ='Z';
               in_uwdsdtl.DSFLTYP = 'TIMESTAMP';
            when ds_WHFLDT ='D';
               in_uwdsdtl.DSFLTYP = 'DATE';
            when ds_WHFLDT ='F';
               in_uwdsdtl.DSFLTYP = 'FLOATING';
            when ds_WHFLDT ='G';
               in_uwdsdtl.DSFLTYP = 'GRAPHIC';
            when ds_WHFLDT ='I';
               in_uwdsdtl.DSFLTYP = 'SIGNED INT';
            when ds_WHFLDT ='N';
               in_uwdsdtl.DSFLTYP = 'IND';
            when ds_WHFLDT ='S';
               in_uwdsdtl.DSFLTYP = 'ZONED';
            when ds_WHFLDT ='T';
               in_uwdsdtl.DSFLTYP = 'TIME';
            when ds_WHFLDT ='U';
               in_uwdsdtl.DSFLTYP = 'UNSIGN INT';
            when ds_WHFLDT ='*';
               in_uwdsdtl.DSFLTYP = 'POINTER';
            endsl;

            select;
            when ds_WHFLDD =  *Zero And ds_WHFLDP = *Zero;
               in_uwdsdtl.DSFLSIZ = ds_WHFLDB;
               in_uwdsdtl.DSFLDEC = ds_WHFLDP;
            when ds_WHFLDD <> *Zero And ds_WHFLDP <> *Zero;
               in_uwdsdtl.DSFLSIZ = ds_WHFLDD;
               in_uwdsdtl.DSFLDEC = ds_WHFLDP;
            when ds_WHFLDD <> *Zero And ds_WHFLDP = *Zero;
               in_uwdsdtl.DSFLSIZ = ds_WHFLDD;
               in_uwdsdtl.DSFLDEC = ds_WHFLDP;
            endsl;

            If %scan(':' :%trim(in_uwdsdtl.dsprefix)) > 1;                               //MT01
               replaceStr = %subst(%trim(in_uwdsdtl.dsprefix) : 1                        //MT01
                                      : %scan(':' :%trim(in_uwdsdtl.dsprefix)) -1);      //MT01
               len = %int(%subst( %trim(in_uwdsdtl.dsprefix) :                           //MT01
                                      %scan(':' : %trim(in_uwdsdtl.dsprefix)) +1));     //MT01
               if len > 0;
                  in_uwdsdtl.dsfldnmpf =  %replace(%trim(replaceStr) :                      //MT01
                                              %trim(in_uwdsdtl.DSFLDNM) : 1 : len);      //MT01
               endif;
            Else;                                                                        //MT01
               in_uwdsdtl.dsfldnmpf = %trim(in_uwdsdtl.dsprefix) +                       //MT01
                                      %trim(in_uwdsdtl.DSFLDNM);                         //MT01
            Endif;                                                                       //MT01

            writedsinfo(in_string : in_uwdsdtl : lref);
            exec sql fetch IAPSRDS_C1 into :DsFileDtl;
         enddo;
      endif;
      exec sql close IAPSRDS_C1;
      clear in_uwdsdtl.dsfldnmpf;                                                        //MT01
   endsr;

end-proc;

dcl-proc IAPSRDSRPG3 Export;
   dcl-pi IAPSRDSRPG3;
      in_string  char(5000);
      in_type    char(10);
      in_error   char(10);
      in_xref    char(10);
    //in_srclib  char(10);                                                                    //0002
    //in_srcspf  char(10);                                                                    //0002
    //in_srcmbr  char(10);                                                                    //0002
   // in_srclib  char(10) const options(*trim);                                          0033 //0002
   // in_srcspf  char(10) const options(*trim);                                          0033 //0002
   // in_srcmbr  char(10) const options(*trim);                                          0033 //0002
      in_uWSrcDtl likeds(uWSrcDtl);                                                           //0033
      in_rrn_s   packed(6:0);
      in_rrn_e   packed(6:0);
      in_dsdcl   char(3);
      in_dsobjv  char(10);
      in_dsname  char(128);
      in_dsmody  char(10);
      in_uwdsdtl likeds(uwdsdtl_t);
   end-pi;

   dcl-s ds_pos1    packed(2:0) inz;
   dcl-s ds_pos2    packed(2:0) inz;
   dcl-s ds_pos3    packed(2:0) inz;
   dcl-s ds_pos4    packed(2:0) inz;
   dcl-s ds_name    char(128)   inz;
   dcl-s ds_objv    char(10)    inz;
   dcl-s ds_attr    char(10)    inz;
   dcl-s ds_mody    char(128)   inz;
   dcl-s ds_sts     char(10)    inz;
   dcl-s ds_seqn    packed(6:0) inz;
   dcl-s ds_sseqn   char(10)    inz;
   dcl-s ds_eseqn   char(10)    inz;
   dcl-s ds_objvref char(10)    inz;
   dcl-s ds_fseqn   char(10)    inz;
   dcl-s ds_scoln   char(1)     inz;
   dcl-s ds_qulflg  char(1)     inz;
   dcl-s ds_length  packed(8:0) inz;
   dcl-s ds_dim     packed(7:0) inz;
   dcl-s ds_flddec  packed(2:0) inz;
   dcl-s ds_type    char(1)     inz;
   dcl-s ds_tmpvar  char(1)     inz;                                                       //SC01

   if in_string = *blanks;                                                                 //SC01
      return;                                                                              //SC01
   endif;                                                                                  //SC01

   //Initialize Variables
   clear in_uwdsdtl.dsfldnm;
   clear in_uwdsdtl.dsfldnmpf;
   clear in_uwdsdtl.dsfltyp;
   clear in_uwdsdtl.dsflto;
   clear in_uwdsdtl.dsflfr;
   clear in_uwdsdtl.dsflsiz;
   clear in_uwdsdtl.dsbfldnm;
   clear in_uwdsdtl.dsqualnm;
   clear in_uwdsdtl.dsfldec;
   clear in_uwdsdtl.dsbfldnm;
   clear in_uwdsdtl.dsflspcy;

   //Set program variables 
   uWSrcDtl= in_uWSrcDtl;                                                               //0033
   ds_mody = in_dsmody;
   ds_name = in_dsname;
   ds_objv = in_dsobjv;

   //Check Declaration Status and capture info
   select;
   //When It Is Data Structure Declaration
   when in_dsdcl = 'DS';
      clear in_uwdsdtl.dsfldrnk;
      clear in_uwdsdtl.dslength;
      clear in_uwdsdtl.dsdimen;
      if ds_objv = 'INFDS-VAR' or ds_objv = 'INDDS-VAR';
         ds_type = 'E';
      endif;

      //Find Data Structure info
      exsr finddsinforpg3;

      //Get DS Values in in_uwdsdtl Data Structure
      exsr get_uwdsdtl;

   //When It Is DS Field Declaration
   when in_dsdcl = 'DSS';
      //Find Data Structure Field Info
      exsr finddsfieldinforpg3;

      //Get Field Values in in_uwdsdtl Data Structure
      exsr get_uwdsdtl;

      //Write DS Details in in_uwdsdtl Data Structure
      writedsinfo(in_string : in_uwdsdtl : in_xref);

   //When It Is LDS or EDS declaration
   when in_dsdcl = 'WDS';
      //Write DS Details in in_uwdsdtl Data Structure 
      writedsinfo(in_string : in_uwdsdtl : in_xref);
      return;

   other;
      return;
   endsl;

 //if ds_mody <> *blanks and %scan(':':%trim(ds_mody)) > 0;                                //AJ01
   if ds_mody <> *blanks and %scan(':':%trim(ds_mody)) > 1;                                //AJ01
      ds_pos1 = %scan(':':%trim(ds_mody));
      ds_mody = %subst(%trim(ds_mody) : 1 : ds_pos1 - 1);
   endif;

   if %scan('"':%trim(ds_mody)) = 1;
      ds_mody = %xlate('"' : '' : ds_mody);
   endif;

   //Update IAPGMREF file for DS and Its Fields
   return;

   begsr finddsinforpg3;
      //Check If It Is Based Data Structure
      select;
      when (%len(in_string) > 20 and %subst(in_string : 21 : 10) <> *blanks);
         ds_attr = 'EDS';
         ds_mody = %subst(in_string : 21 : 10);
         ds_type = 'E';
      when (%subst(in_string : 18 :1) = 'U');
         ds_attr = 'DADS';
      endsl;

      //Find Data Structure Length
      if %subst(in_string:48:4) <> *blanks;
         if %check(numConst:%trim(%subst(in_string:48:4))) = 0 ;
            ds_length = %dec(%subst(in_string:48:4):8:0);
         endIf;
      endif;
   endsr;

   begsr finddsfieldinforpg3;
      //Find Data Structure Field Name
      if %subst(in_string : 53 : 6) <> *blanks;                                            //SC01
         ds_name = %subst(in_string : 53 : 6);
      endif;                                                                               //SC01

      //Find Data Structure Field Type
      select;
      when (%subst(in_string : 43 : 1) = 'B');
       //ds_attr = 'Binary';                                                               //SC01
         ds_attr = 'BINARY';                                                               //SC01
      when (%subst(in_string : 43 : 1) = 'R');
       //ds_attr = 'Signed Num';                                                           //SC01
         ds_attr = 'SIGNED NUM';                                                           //SC01
      when (%subst(in_string : 43 : 1) = 'P');
       //ds_attr = 'Packed';                                                               //SC01
         ds_attr = 'PACKED';                                                               //SC01
      other;
       //ds_attr = 'Char';                                                                 //SC01
         ds_attr = 'CHAR';                                                                 //SC01
      endsl;

      //Find Field Size, From Pos, To Pos & Dec Pos
      if %subst(in_string : 44 : 4) <> *blanks or %subst(in_string : 48 : 4) <> *blanks;
         select;
         when %scan('*' : %subst(in_string : 44 : 4)) >0;
            ds_attr = %subst(in_string : 44 : 8);
         when %subst(in_string : 48 : 4) <> *blanks;
            ds_eseqn = %subst(in_string : 48 : 4);
            ds_sseqn = %subst(in_string : 44 : 4);

            monitor;
               if %check(numConst:%trim(ds_eseqn)) = 0;
                  if ds_sseqn = *blanks ;
                     ds_seqn  = %dec(ds_eseqn : 6 : 0);
                  elseif %check(numConst:%trim(ds_sseqn)) = 0 ;
                     ds_seqn  = %dec(ds_eseqn : 6 : 0) - %dec(ds_sseqn : 6 : 0) + 1;
                  endif;
               endIf;
            on-error;
               ds_seqn = 0;
            endmon;
         endsl;
      endif;


     ds_tmpvar = %subst(in_string : 52 : 1);

    //if %subst(in_string : 52 : 1) <> *blanks;                                            //SC01
       //if %check(numConst:%trim(%subst(in_string : 52 : 1))) = 0 ;                       //SC01
          //ds_flddec = %dec(%subst(in_string : 52 : 1) : 2 : 0);                          //SC01
       //endIf;                                                                            //SC01
      if ds_tmpvar <> *blanks and %check(numConst:ds_tmpvar) = 0;                          //SC01
         ds_flddec = %dec(ds_tmpvar : 2 : 0);                                              //SC01
      endif;                                                                               //SC01


       //if ds_attr = 'Char';                                                              //SC01
          //ds_attr = 'Zoned Dec';                                                         //SC01
         if ds_attr = 'CHAR';                                                              //SC01
            ds_attr = 'ZONED DEC';                                                         //SC01
         endif;                                                                            //SC01
  //  endif;                                                                               //SC01
   endsr;

   begsr get_uwdsdtl;
      select;
      //When It Is Data Structure Declaration
      when in_dsdcl = 'DS';
       //in_uwdsdtl.dssrclib = %trim(in_srclib);                                              //0002
       //in_uwdsdtl.dssrcfln = %trim(in_srcspf);                                              //0002
       //in_uwdsdtl.dspgmnm  = %trim(in_srcmbr);                                              //0002
         in_uwdsdtl.dssrclib = in_srclib;                                                     //0002
         in_uwdsdtl.dssrcfln = in_srcspf;                                                     //0002
         in_uwdsdtl.dspgmnm  = in_srcmbr;                                                     //0002
         in_uwdsdtl.dsifsloc = %trim(in_ifsloc);                                              //0033
         in_uwdsdtl.dsname   = %trim(ds_name);

         if ds_type <> *blanks;
            in_uwdsdtl.dstype   = %trim(ds_type);
         else;
            in_uwdsdtl.dstype   = 'I';
         endif;

         in_uwdsdtl.dsobjv   = %trim(ds_objv);
         in_uwdsdtl.dsspcy   = %trim(ds_attr);
         in_uwdsdtl.dsbased  = %trim(ds_mody);
         in_uwdsdtl.dsqulflg = ds_qulflg;
         in_uwdsdtl.dslength = ds_length;
         in_uwdsdtl.dsdimen  = ds_dim;

         //Define The Data Structure Origin 
         select;
         when ds_type = 'E';
            in_uwdsdtl.dsorigin = 'REFERENCE EXT FILE - ' + %trim(in_uwdsdtl.dsbased);
         when ds_type = 'B';
            in_uwdsdtl.dsorigin = 'REFERENCE DS - ' + %trim(in_uwdsdtl.dsbased);
         other;
            in_uwdsdtl.dsorigin = 'INTERNAL DS';
         endsl;

      //When It Is DS Field Declaration
      when in_dsdcl = 'DSS';
         in_uwdsdtl.dsfldnm  = %trim(ds_name);

         if ds_attr = 'LFLD' or ds_attr = 'EFLD' or ds_attr = 'LDS' or
            %scan('*' : %trim(ds_attr) : 1) = 1;
            in_uwdsdtl.dsflspcy = %trim(ds_attr);
         else;
            in_uwdsdtl.dsfltyp  = %trim(ds_attr);
         endif;

         in_uwdsdtl.dsflto   = %trim(ds_eseqn);
         in_uwdsdtl.dsflfr   = %trim(ds_sseqn);
         in_uwdsdtl.dsflsiz  = ds_seqn;
         in_uwdsdtl.dsbfldnm = %trim(ds_mody);
         in_uwdsdtl.dsflobjv = %trim(ds_objv);
         in_uwdsdtl.dsfldrnk = in_uwdsdtl.dsfldrnk + 1;

         if in_uwdsdtl.dsqulflg = 'Q';
            in_uwdsdtl.dsqualnm = %trim(in_uwdsdtl.dsname) + '.' + %trim(ds_name);
         else;
            in_uwdsdtl.dsqualnm = %trim(ds_name);
         endif;

         in_uwdsdtl.dsfldec = ds_flddec;
         in_uwdsdtl.dsbfldnm = %trim(ds_mody);
      endsl;
   endsr;
end-proc;

dcl-proc writedsinfo export;
   dcl-pi writedsinfo;
      in_string  char(5000);
      in_uwdsdtl likeds(uwdsdtl_t);
      in_xref    char(10);
   end-pi;

   //SQL To Insert Data Into IAPGMDS
   exec sql
     insert into IAPGMDS (DSSRCLIB,
                          DSSRCFLN,
                          DSPGMNM,
                          DSIFSLOC,                                                      //0033
                          DSNAME,
                          DSTYPE,
                          DSOBJV,
                          DSFLOBJV,
                          DSSPCY,
                          DSBASED,
                          DSLENGTH,
                          DSDIMEN,
                          DSFLDNM,
                          DSFLDNMPF,
                          DSFLFR,
                          DSFLTO,
                          DSFLTYP,
                          DSFLSIZ,
                          DSFLDEC,
                          DSBFLDNM,
                          DSQULFLG,
                          DSPREFIX,
                          DSQUALNM,
                          DSFLSPCY,
                          DSFLDRNK,
                          DSORIGIN)
       values(:in_uwdsdtl.DSSRCLIB,
              :in_uwdsdtl.DSSRCFLN,
              :in_uwdsdtl.DSPGMNM,
              :in_uwdsdtl.DSIFSLOC,                                                      //0033
              :in_uwdsdtl.DSNAME,
              :in_uwdsdtl.DSTYPE,
              :in_uwdsdtl.DSOBJV,
              :in_uwdsdtl.DSFLOBJV,
              :in_uwdsdtl.DSSPCY,
              :in_uwdsdtl.DSBASED,
              :in_uwdsdtl.DSLENGTH,
              :in_uwdsdtl.DSDIMEN,
              :in_uwdsdtl.DSFLDNM,
              :in_uwdsdtl.DSFLDNMPF,
              :in_uwdsdtl.DSFLFR,
              :in_uwdsdtl.DSFLTO,
              :in_uwdsdtl.DSFLTYP,
              :in_uwdsdtl.DSFLSIZ,
              :in_uwdsdtl.DSFLDEC,
              :in_uwdsdtl.DSBFLDNM,
              :in_uwdsdtl.DSQULFLG,
              :in_uwdsdtl.DSPREFIX,
              :in_uwdsdtl.DSQUALNM,
              :in_uwdsdtl.DSFLSPCY,
              :in_uwdsdtl.DSFLDRNK,
              :in_uwdsdtl.DSORIGIN);

   if SQLSTATE <>  SQL_ALL_OK;
      //log error
   endif;

   return;
end-proc;

dcl-proc updatedsinfo export;                                                  //VHM1
   dcl-pi updatedsinfo;
      in_string  char(5000);
      in_uwdsdtl likeds(uwdsdtl_t);
      in_xref    char(10);
   end-pi;

   //SQL To Insert Data Into IAPGMDS
   exec sql
     update IAPGMDS
     set DSFLDNMPF = :in_uwdsdtl.DSQUALNM,
         DSFLSPCY = :in_uwdsdtl.DSFLSPCY
     where DSSRCLIB = :in_uwdsdtl.DSSRCLIB
     and DSSRCFLN = :in_uwdsdtl.DSSRCFLN
     and DSPGMNM = :in_uwdsdtl.DSPGMNM
     and DSIFSLOC = :in_uwdsdtl.DSIFSLOC                                                 //0033
     and DSNAME = :in_uwdsdtl.DSNAME
     and DSFLDNM = :in_uwdsdtl.DSBFLDNM;

   if SQLSTATE <>  SQL_ALL_OK;
      //log error
   endif;

   return;
end-proc;                                                                       //VHM1


dcl-proc IAPSRKLFX Export;
   dcl-pi IAPSRKLFX;
      in_string  char(5000);
      in_type    char(10);
      in_error   char(10);
      in_xref    char(10);
    //in_srclib  char(10);                                                                    //0002
    //in_srcspf  char(10);                                                                    //0002
    //in_srcmbr  char(10);                                                                    //0002
    //in_srclib  char(10) const options(*trim);                                          0033 //0002
    //in_srcspf  char(10) const options(*trim);                                          0033 //0002
    //in_srcmbr  char(10) const options(*trim);                                          0033 //0002
      in_uWSrcDtl likeds(uWSrcDtl);                                                           //0033
      in_rrn_s   packed(6:0);
      in_rrn_e   packed(6:0);
      in_opcode  char(10);
      in_uwkldtl likeds(uwkldtl_t);
   end-pi;

   dcl-s kl_name    char(128)   inz;
   dcl-s kl_length  packed(8:0) inz;
   dcl-s kl_length6 packed(6:0) inz;
   dcl-s kl_decpos  packed(2:0) inz;
   dcl-s kl_objv    char(10)    inz;
   dcl-s kl_objvref char(10)    inz;
   dcl-s kl_type    char(10)    inz;
   dcl-s kl_mody    char(10)    inz;
   dcl-s kl_sts     char(10)    inz;
   dcl-s kl_spcy    char(10)    inz;
   dcl-s kl_based   char(128)   inz;
   dcl-s sub_str    char(5)  inz;
   dcl-s sub_str2   char(2)  inz;

   clear in_uwkldtl.KLFLDNM;
   clear in_uwkldtl.KLFLDSPC;
   clear in_uwkldtl.KLFLDBSD;
   clear in_uwkldtl.KLFLDCTG;
   uWSrcDtl = in_uWSrcDtl;                                                               //0033

   //Process for KLIST/KFLD Accordingly
   select;
   when in_opcode = 'KLIST';
      //Get KLIST Details
      kl_name  = %subst(in_string : 12 : 14);

      //Get KLIST/KFLD Values in in_uwkldtl DS
      exsr get_uwkldtl;

   when in_opcode = 'KFLD';
      //Get KFLD Details
      kl_name = %subst(in_string : 50 : 14);
      sub_str = %subst(in_string : 64 : 5);
      if sub_str <> *blanks;
         Sub_Str = %ScanRpl(' ': '0':Sub_Str);                                           //0005
         if %check(numConst:sub_str) = 0 ;
            kl_length = %dec(sub_str : 8 : 0);
         endIf;

         sub_str2 = %subst(in_string : 69 : 2);
         if sub_str2 <> *blanks;
         Sub_Str2 = %ScanRpl(' ': '0':Sub_Str2);                                         //0005
            if %check(numConst:sub_str2) = 0 ;
               kl_decpos = %dec(sub_str : 2 : 0);
            endIf;

            kl_type = 'Packed';
         else;
            kl_type = 'Char';
         endif;
      endif;

      //Get KLIST/KFLD Values in in_uwkldtl DS
      exsr get_uwkldtl;

      //Write KLIST/KFLD Details in IAPGMKLIST file
      writeklistinfo(in_uwkldtl);
   other;
      return;
   endsl;

   //Update IAPGMREF file for DS and Its Fields
   clear kl_length6;
   monitor;
      kl_length6 = kl_length;
   on-error;
      clear kl_length6;
   endmon;


   If kl_type <> *Blanks;                                                                //0005
     Exec SQL
       Insert into IAPGMVARS(IAVMBR,                                                     //0004
                           IAVSFILE,                                                     //0004
                           IAVLIB,                                                       //0004
                           IAVIFSLOC,                                                    //0033
                           IAVVAR,                                                       //0004
                           IAVDTYP,                                                      //0004
                           IAVLEN,                                                       //0004
                           IAVDEC,                                                       //0004
                           IAVRRN)                                                       //0004
       Values(trim(:in_srcmbr),                                                          //0004
              trim(:in_srcspf),                                                          //0004
              trim(:in_srclib),                                                          //0004
              trim(:in_IfsLoc),                                                          //0033
              trim(:kl_name),                                                            //0004
              Upper(trim(:kl_type)),                                                     //0005
              char(:kl_length6),                                                         //0004
              char(:kl_decpos),                                                          //0004
              char(:in_rrn_s));                                                          //0004
   EndIf;                                                                                //0005

   return;

   begsr get_uwkldtl;
      select;
      //When It Is KLIST Declaration
      when in_opcode = 'KLIST';
       //in_uwkldtl.klsrclib = %trim(in_srclib);                                              //0002
       //in_uwkldtl.klsrcfln = %trim(in_srcspf);                                              //0002
       //in_uwkldtl.klpgmnm  = %trim(in_srcmbr);                                              //0002
         in_uwkldtl.klsrclib = in_srclib;                                                     //0002
         in_uwkldtl.klsrcfln = in_srcspf;                                                     //0002
         in_uwkldtl.klpgmnm  = in_srcmbr;                                                     //0002
         in_uwkldtl.klifsloc = in_IfsLoc;                                                     //0033
         in_uwkldtl.klname   = %trim(kl_name);

      //When It Is KFLD Declaration
      when in_opcode = 'KFLD';
         in_uwkldtl.klfldnm  = %trim(kl_name);
         in_uwkldtl.klfldspc = kl_spcy;
         in_uwkldtl.klfldbsd = kl_based;
      endsl;
   endsr;

end-proc;

dcl-proc IAPSRKLRPG3 Export;
   dcl-pi IAPSRKLRPG3;
      in_string  char(5000);
      in_type    char(10);
      in_error   char(10);
      in_xref    char(10);
    //in_srclib  char(10);                                                                    //0002
    //in_srcspf  char(10);                                                                    //0002
    //in_srcmbr  char(10);                                                                    //0002
    //in_srclib  char(10) const options(*trim);                                          0033 //0002
    //in_srcspf  char(10) const options(*trim);                                          0033 //0002
    //in_srcmbr  char(10) const options(*trim);                                          0033 //0002
      in_uWSrcDtl likeds(uWSrcDtl);                                                           //0033
      in_rrn_s   packed(6:0);
      in_rrn_e   packed(6:0);
      in_opcode  char(10);
      in_uwkldtl likeds(uwkldtl_t);
   end-pi;

   dcl-s kl_name    char(128)   inz;
   dcl-s kl_length  packed(8:0) inz;
   dcl-s kl_length6 packed(6:0) inz;
   dcl-s kl_decpos  packed(2:0) inz;
   dcl-s kl_objv    char(10)    inz;
   dcl-s kl_objvref char(10)    inz;
   dcl-s kl_type    char(10)    inz;
   dcl-s kl_mody    char(10)    inz;
   dcl-s kl_sts     char(10)    inz;
   dcl-s kl_spcy    char(10)    inz;
   dcl-s kl_based   char(128)   inz;

   clear in_uwkldtl.KLFLDNM;
   clear in_uwkldtl.KLFLDSPC;
   clear in_uwkldtl.KLFLDBSD;
   clear in_uwkldtl.KLFLDCTG;
   uWSrcDtl = in_uWSrcDtl;                                                               //0033

   //Process for KLIST/KFLD Accordingly
   select;
   when in_opcode = 'KLIST';
      //Get KLIST Details
      kl_name = %subst(in_string : 18 : 10);

      //Get KLIST/KFLD Values in in_uwkldtl DS
      exsr get_uwkldtl;

   when in_opcode = 'KFLD';
      //Get KFLD Details 
      kl_name   = %subst(in_string : 43 : 6);

      if %subst(in_string : 49 : 3) <> *blanks;
         %subst(In_String: 49 : 3) =  %ScanRpl(' ': '0':%subst(in_string : 49 : 3));     //0005
         if %check(numConst:%trim(%subst(in_string : 49 : 3))) = 0 ;
            kl_length = %dec(%subst(in_string : 49 : 3) : 8 : 0);
         endIf;

         if %subst(in_string : 52 : 1) <> *blanks;
            if %check(numConst:%trim(%subst(in_string : 52 : 1))) = 0 ;
               kl_decpos = %dec(%subst(in_string : 52 : 1) : 2 : 0);
            endIf;
            kl_type = 'Packed';
         else;
            kl_type = 'Char';
         endif;
      endif;

      //  --------------- Get KLIST/KFLD Values in in_uwkldtl DS ------- *//
      exsr get_uwkldtl;

      //  --------------- Write KLIST/KFLD Details in IAPGMKLIST file -- *//
      writeklistinfo(in_uwkldtl);

   other;
      return;
   endsl;

   clear kl_length6;
   monitor;
      kl_length6 = kl_length;
   on-error;
      clear kl_length6;
   endmon;


   If Kl_type <> *Blanks;                                                                //0005
      Exec SQL
       Insert into IAPGMVARS(IAVMBR,                                                     //0004
                           IAVSFILE,                                                     //0004
                           IAVLIB,                                                       //0004
                           IAVIFSLOC,                                                    //0033
                           IAVVAR,                                                       //0004
                           IAVDTYP,                                                      //0004
                           IAVLEN,                                                       //0004
                           IAVDEC,                                                       //0004
                           IAVRRN)                                                       //0004
       Values(trim(:in_srcmbr),                                                          //0004
              trim(:in_srcspf),                                                          //0004
              trim(:in_srclib),                                                          //0004
              trim(:in_ifsloc),                                                          //0033
              trim(:kl_name),                                                            //0004
              Upper(trim(:kl_type)),                                                     //0005
              char(:kl_length6),                                                         //0004
              char(:kl_decpos),                                                          //0004
              char(:in_rrn_s));                                                          //0004
   EndIf;                                                                                //0005
   return;

   begsr get_uwkldtl;
      select;
      //When It Is KLIST Declaration 
      when in_opcode = 'KLIST';
       //in_uwkldtl.klsrclib = %trim(in_srclib);                                              //0002
       //in_uwkldtl.klsrcfln = %trim(in_srcspf);                                              //0002
       //in_uwkldtl.klpgmnm  = %trim(in_srcmbr);                                              //0002
         in_uwkldtl.klsrclib = in_srclib;                                                     //0002
         in_uwkldtl.klsrcfln = in_srcspf;                                                     //0002
         in_uwkldtl.klpgmnm  = in_srcmbr;                                                     //0002
         in_uwkldtl.klname   = %trim(kl_name);

      //When It Is KFLD Declaration 
      when in_opcode = 'KFLD';
         in_uwkldtl.klfldnm  = %trim(kl_name);
         in_uwkldtl.klfldspc = kl_spcy;
         in_uwkldtl.klfldbsd = kl_based;
      endsl;
   endsr;

end-proc;

dcl-proc writeklistinfo export;
   dcl-pi writeklistinfo;
      in_uwkldtl likeds(uwkldtl_t);
   end-pi;

   exec sql
     insert into IAPGMKLIST (KLSRCLIB,
                             KLSRCFLN,
                             KLPGMNM,
                             KLIFSLOC,                                                   //0033
                             KLNAME,
                             KLFLDNM,
                             KLFLDSPC,
                             KLFLDBSD,
                             KLFLDCTG)
       values (:in_uwkldtl.KLSRCLIB,
               :in_uwkldtl.KLSRCFLN,
               :in_uwkldtl.KLPGMNM,
               :in_uwkldtl.KLIFSLOC,                                                     //0033
               :in_uwkldtl.KLNAME,
               :in_uwkldtl.KLFLDNM,
               :in_uwkldtl.KLFLDSPC,
               :in_uwkldtl.KLFLDBSD,
               :in_uwkldtl.KLFLDCTG);

   if SQLSTATE <> SQL_ALL_OK;
      //log error
   endif;

   return;
end-proc;

dcl-proc IAPSRPRFR Export;
   dcl-pi IAPSRPRFR;
      in_string char(5000);
      in_type   char(10);
      in_error  char(10);
      in_xref   char(10);
      // in_srclib char(10);                                                             //0033
      // in_srcspf char(10);                                                             //0033
      // in_srcmbr char(10);                                                             //0033
      in_uWSrcDtl likeds(uWSrcDtl);                                                      //0033
      in_rrns   packed(6:0);
      in_rrne   packed(6:0);
      in_seqNum packed(6:2);                                                             //0013
      in_prc    ind;                                                                     //0016
      in_procNm char(80) options(*omit);                                                 //0034
   end-pi;

   dcl-ds pr_IAPRCPARM extname('IAPRCPARM') qualified inz end-ds;

   dcl-s pr_XRef         char(10)    inz;
   dcl-s pr_srclib       char(10)    inz;
   dcl-s pr_srcspf       char(10)    inz;
   dcl-s pr_srcmbr       char(10)    inz;
   dcl-s pr_ifsloc       char(100)   inz;                                                //0033
   dcl-s pr_WordObj      char(10)    inz;
   dcl-s pr_ObjRef       char(10)    inz;
   dcl-s pr_DclPrPos     packed(5)   inz;
   dcl-s pr_DclPrPos1    packed(5)   inz;
   dcl-s pr_DclPiPos     packed(5)   inz;
   dcl-s pr_DclPiPos1    packed(5)   inz;
   dcl-s pr_DclParmPos   packed(5)   inz;
   dcl-s pr_ParmAttrpos  packed(5)   inz;
   dcl-s pr_ParmAttrpos1 packed(5)   inz;
   dcl-s pr_ParmAttrpos2 packed(5)   inz;
   dcl-s pr_ParmAttrpos3 packed(5)   inz;
   dcl-s pr_QuoteBrktPos packed(5)   inz;
   dcl-s pr_BrktQuotePos packed(5)   inz;
   dcl-s pr_ExtPgmPos    packed(5)   inz;
   dcl-s pr_EndPrPos     packed(5)   inz;
   dcl-s pr_EndPrPos1    packed(5)   inz;
   dcl-s pr_EndPiPos     packed(5)   inz;
   dcl-s pr_EndPiPos1    packed(5)   inz;
   dcl-s pr_SourceWord   char(128)   inz;
   dcl-s pr_procnamefree char(128)   inz;
   dcl-s pr_parmnamefree char(128)   inz;
   dcl-s pr_keyname      char(128)   inz;
   dcl-s pr_ParmAttr     char(128)   inz;
   dcl-s pr_ExPgmName    char(128)   inz;
   dcl-s pr_Pos1         packed(6)   inz;
   dcl-s pr_Pos2         packed(6)   inz;
   dcl-s pr_Dim          char(10)    inz;
   dcl-s pr_Dim1         packed(6)   inz;
   dcl-s pr_Dim2         packed(6)   inz;
   dcl-s pr_String       char(200)   inz;
   dcl-s pr_SrcRrnCnt    packed(6:0) inz;
   dcl-s pr_InString     char(5000)  inz;
   dcl-s pr_Attr         char(10)    inz;
   dcl-s pr_Mody         char(10)    inz;
   dcl-s pr_Seq          packed(6:0) inz;
   dcl-s pr_Sts          char(10)    inz;
   dcl-s pr_position     packed(5)   inz;
   dcl-s PrPiFlag        char(2)     inz;
   dcl-s w_PrcSign       char(1)     inz;                                                    //SG01
   dcl-s W_ProcVal       char(200)   inz;                                                    //SG01
   dcl-s w_NonOcrPos     packed(5)   inz;                                                    //SG01
   dcl-s w_ProcNam       char(80)    inz;                                                    //SG01
   dcl-s seq_num         packed(6:2) inz;                                                //0013
   dcl-s w_IAVR_TYP      char(5);                                                        //0016
   dcl-s defaultDType    char(1)     inz;                                                //0024
   dcl-s dateFmt         char(5)     inz;                                                //0024
   Dcl-S pr_RRN          Like(in_rrns);                                                  //0022

   dcl-c Quote       '"';
   dcl-c quot        '''';

   dcl-ds defaultDataType;                                                               //0024
      *n char(9) inz('DATE');                                                            //0024
      *n char(9) inz('TIME');                                                            //0024
      *n char(9) inz('TIMESTAMP');                                                       //0024
      *n char(9) inz('IND');                                                             //0024
      *n char(9) inz('POINTER');                                                         //0024
      defaultDataTypeArr char(9) dim(5) pos(1);                                          //0024
   end-ds;                                                                               //0024

   pr_Pos1 = 1;
   uWSrcDtl     = in_uWSrcDtl;                                                           //0033
   pr_SrcRrnCnt = in_rrns - 1;
   pr_XRef      = in_XRef;
   pr_Srclib    = in_Srclib;
   pr_Srcspf    = in_Srcspf;
   pr_Srcmbr    = in_Srcmbr;
   pr_InString  = in_String;
   pr_ifsloc    = in_ifsloc;                                                             //0033
   pr_ObjRef    = ' ';
   pr_Attr      = ' ';
   pr_Mody      = ' ';
   pr_Seq       = 0;
   pr_Sts       = ' ';
   W_ProcVal    = ' ';                                                                       //SG01
   seq_num = in_seqNum;                                                                  //0013

   exsr ReadNextLine;

   dow %trim(pr_string) <> *blanks;
      exec sql
        values upper(:pr_String) into :pr_String;

      pr_String = %trim(pr_String);
      pr_String = squeezeString(pr_String);

      select;
      //Search for 'DCL-PR' word in each line .E.g.  Dcl-Pr Rtvmsg  ExtPgm('USR
      when %scan('DCL-PR ':pr_String) >0;
         exsr ProcessPRFree;

      //Search for 'DCL-PI' word in each line .E.g.  Dcl-Pi ValidateFields Ind;
      when %scan('DCL-PI ':pr_string) >0;
         exsr ProcessPIFree;

      //Search for 'DCL-PROC' word in each line .E.g.  Dcl-Proc ValidateFields Export;  C    //SG01
      when %scan('DCL-PROC ':pr_string) >0;                                                   //SG01
         W_ProcVal = %trim(Pr_string);                                                        //SG01
      endsl;

      exsr ReadNextLine;
   enddo;

   in_error = 'C';
   return;

   begsr ReadNextLine;
      pr_Pos2 = %scan(';': pr_InString : pr_Pos1);
      if Pr_Pos2  > *zero;
         pr_String = %subst(pr_InString : pr_Pos1 :(Pr_Pos2 + 1)- pr_Pos1);
         pr_Pos1   = pr_Pos2 + 1;
         pr_SrcRrnCnt += 1;
      else;
         pr_String = *blanks;
      endif;
   endsr;

   //Sub-Proc To Parse Free Format PR & PI
   begsr ProcessPRFree;
      pr_DclPrPos= %scan('DCL-PR ':pr_String);

      if pr_DclPrPos> 0;
         pr_DclPrPos1= %scan(' ':pr_String:pr_DclPrPos +7);

         if %scan(';':pr_String:pr_DclPrPos +7) < pr_DclPrPos1;
            pr_DclPrPos1= %scan(';':pr_String:pr_DclPrPos +7);
         endif;

         if pr_DclPrPos1 > 0;                                                                 //ST01
            pr_SourceWord = %subst(pr_String:(pr_DclPrPos +7):pr_DclPrPos1-(pr_DclPrPos +7)); //ST01
            pr_SourceWord = %trim(pr_SourceWord);                                             //ST01
         else;                                                                                //ST01
            pr_SourceWord = *blanks;                                                          //ST01
         endif;                                                                               //ST01
         pr_procnamefree = pr_SourceWord;
         pr_WordObj = 'PR-NAM';


         If %scan('EXTPGM':pr_String) = 0 and                                                 //SG01
            %scan('EXTPROC':pr_String) = 0 and                                                //SG01
            pr_SourceWord <> pr_srcmbr;                                                       //SG01
            w_ProcNam = pr_SourceWord;                                                        //SG01
         // WriteProceduredetail(IN_SRCMBR                                               0033 //SG01
         //                     :IN_SRCSPF                                                    //0033
         //                     :IN_SRCLIB                                                    //0033
            WriteProceduredetail(IN_uWSrcDtl                                                  //0033
                                :IN_TYPE
                                :seq_num                                                 //0013
                                :IN_RRNs                                                 //0013
                                :w_ProcNam
                                :'PR'
                                :' ');
         Endif;                                                                               //SG01

         pr_ExtPgmPos = %scan('EXTPGM':pr_String);

         if pr_ExtPgmPos  >0 and pr_SourceWord <> pr_srcmbr;
            pr_BrktquotePos = %scan(('('+ Quote):pr_String:pr_ExtPgmPos+6);

            if pr_BrktquotePos > 0;
               pr_QuoteBrktPos = %scan((Quote+')'):pr_String:pr_ExtPgmPos+6);
               if pr_QuoteBrktPos > 0;                                                        //ST01
                  pr_ExPgmName    = %subst(pr_String:pr_BrktquotePos+2:                       //ST01
                                                     pr_QuoteBrktPos-(pr_BrktquotePos+2));    //ST01
                  pr_ExPgmName  = %trim(pr_ExPgmName);                                        //ST01
               else;                                                                          //ST01
                  pr_ExPgmName  = *blanks;                                                    //ST01
               endif;                                                                         //ST01
               pr_WordObj    = 'EX-PGM';

            endif;
         endif;

         pr_ExtPgmPos = %scan('EXTPROC':pr_String);
         if pr_ExtPgmPos > 0 and pr_SourceWord <> pr_srcmbr;
            pr_BrktquotePos = %scan(('('+ Quote):pr_String:pr_ExtPgmPos+7);
            if pr_BrktquotePos > 0;
               pr_QuoteBrktPos = %scan((Quote+')'):pr_String:pr_ExtPgmPos+7);
               if pr_QuoteBrktPos > 0;                                                        //ST01
                  pr_ExPgmName    = %subst(pr_String:pr_BrktquotePos+2:                       //ST01
                                                     pr_QuoteBrktPos-(pr_BrktquotePos+2));    //ST01
                  pr_ExPgmName = %trim(pr_ExPgmName);                                         //ST01
               else;                                                                          //ST01
                  pr_ExPgmName = *blanks;                                                     //ST01
               endif;                                                                         //ST01
               pr_WordObj   = 'EX-PGM';

            endif;
         endif;

         //Scan for End-Pr
         pr_EndPrPos  = %scan('END-PR ':pr_String);
         pr_EndPrPos1 = %scan('END-PR;':pr_String);

         if pr_EndPrPos = 0 and pr_EndPrPos1= 0;
            //Set the pointer on next line of Dcl-Pr
            exsr ReadNextLine;

            dow %trim(pr_string) <> *blanks;
               exec sql values upper(:pr_string) into :pr_string;
               pr_string = %trim(pr_string);

               //Search if 'END-PR'is there in next line
               pr_EndPrPos = %scan('END-PR ':pr_string);
               pr_EndPrPos1= %scan('END-PR;':pr_string);

               if pr_EndPrPos <> 0 OR pr_EndPrPos1 <> 0;
                  leave;
               else;
                  //Search if parameters are there in next line
                  if %scan('DCL-PARM ':pr_string) <> 0;
                     pr_string = %replace('         ':pr_string:1:9);
                     pr_string = %trim(pr_string);
                  endif;

                  pr_DclParmPos   = %scan(' ':pr_string);
                  if pr_DclParmPos > 1;                                                       //ST01
                     pr_SourceWord   = %subst(pr_string:1:(pr_DclParmPos-1));                 //ST01
                     pr_parmnamefree = pr_SourceWord;                                         //ST01
                     pr_DclParmPos   = %check(' ':pr_string:pr_DclParmPos);                   //ST01
                     pr_WordObj      = 'PR-PRM';                                              //ST01
                     if pr_DclParmPos > 0;                                                    //ST01
                        pr_ParmAttrpos  = %scan('(':pr_string:pr_DclParmPos);                 //ST01
                        pr_ParmAttrpos2 = %scan(' ':pr_string:pr_DclParmPos);                 //ST01
                        pr_ParmAttrpos3 = %scan(';':pr_string:pr_DclParmPos);                 //ST01
                     endif;                                                                   //ST01
                  endif;                                                                      //ST01

                  select;
                  when (pr_ParmAttrpos > 0) and
                       (pr_ParmAttrpos < pr_ParmAttrpos2) and
                       (pr_ParmAttrpos < pr_ParmAttrpos3);
                     pr_ParmAttr =  %subst(pr_string:pr_DclParmPos:
                                          (pr_ParmAttrpos-pr_DclParmPos));
                     pr_Attr = %trim(pr_ParmAttr);
                     pr_ParmAttrpos1 = %scan(')':pr_string:pr_ParmAttrpos+1);
                     if pr_ParmAttrpos1 > 0;                                                  //ST01
                        pr_Mody = %trim(%subst(pr_string:pr_ParmAttrpos+1:                    //ST01
                                           (pr_ParmAttrpos1-pr_ParmAttrpos-1)));              //ST01
                        pr_keyname = %trim(%subst(pr_string:pr_ParmAttrpos1 +1:               //ST01
                                         pr_ParmAttrpos3-(pr_ParmAttrpos1 +1)));              //ST01
                     endif;                                                                   //ST01

                  when (pr_ParmAttrpos2 > 0) and (pr_ParmAttrpos = 0) and
                       (pr_ParmAttrpos2 < pr_ParmAttrpos3);
                     pr_ParmAttr =  %subst(pr_string:pr_DclParmPos:
                                          (pr_ParmAttrpos2-pr_DclParmPos));
                     pr_Attr = %trim(pr_ParmAttr);
                     pr_keyname = %trim(%subst(pr_string:pr_ParmAttrpos2 +1:
                                      pr_ParmAttrpos3-(pr_ParmAttrpos2 +1)));

                  when (pr_ParmAttrpos2 > 0) and (pr_ParmAttrpos2 < pr_ParmAttrpos) and
                       (pr_ParmAttrpos2 < pr_ParmAttrpos3);
                     pr_ParmAttr =  %subst(pr_string:pr_DclParmPos:                      //0015
                                          (pr_ParmAttrpos2-pr_DclParmPos));
                     pr_Attr = %trim(pr_ParmAttr);
                     pr_keyname = %trim(%subst(pr_string:pr_ParmAttrpos2 +1:
                                               pr_ParmAttrpos3-(pr_ParmAttrpos2 +1)));
                     pr_Mody = *blanks ;                                                 //0015

                  when (pr_ParmAttrpos3 > 0) and (pr_ParmAttrpos = 0) and
                       (pr_ParmAttrpos3 < pr_ParmAttrpos2);
                     pr_ParmAttr =  %subst(pr_string:pr_DclParmPos:
                                          (pr_ParmAttrpos3-pr_DclParmPos));
                     pr_Attr = %trim(pr_ParmAttr);

                  when (pr_ParmAttrpos3 > 0) and
                       (pr_ParmAttrpos3 < pr_ParmAttrpos) and
                       (pr_ParmAttrpos3 < pr_ParmAttrpos2);
                     pr_ParmAttr = %subst(pr_string:pr_DclParmPos+1:
                                         (pr_ParmAttrpos3-pr_DclParmPos));
                     pr_Attr = %trim(pr_ParmAttr);
                  endsl;


                  PrPiFlag = 'PR';
                  exsr InsertDDLData;
               endif;

               exsr ReadNextLine;
            enddo;
         endif;
      endif;
   endsr;

   begsr ProcessPIFree;
      pr_DclPiPos = %scan('DCL-PI ':pr_string);
      if pr_DclPiPos> 0;
         // pr_DclPiPos1 = %scan(' ':pr_string:pr_DclPiPos +7);                               //SG01
         w_NonOcrPos = %check(' ' : %trim(pr_string):pr_DclPiPos +7);                         //SG01
         if w_NonOcrPos > 0;                                                                  //ST01
            pr_DclPiPos1 = %scan(' ':pr_string:w_NonOcrPos);                                  //ST01
         endif;                                                                               //ST01
         if %scan(';':pr_String:pr_DclPiPos +7) < pr_DclPiPos1;
            pr_DclPiPos1 = %scan(';':pr_String:pr_DclPiPos +7);
         endif;

         if pr_DclPiPos1 > 0;                                                                 //ST01
            pr_SourceWord = %subst(pr_string:(pr_DclPiPos +7):pr_DclPiPos1-(pr_DclPiPos +7)); //ST01
            pr_SourceWord = %trim(pr_SourceWord);                                             //ST01
         else;                                                                                //ST01
            pr_SourceWord = *blanks;                                                          //ST01
         endif;                                                                               //ST01
         pr_procnamefree = pr_SourceWord;
         pr_WordObj    = 'PI-NAM';

         w_PrcSign = ' ';                                                                     //SG01
         if %trim(pr_SourceWord) = '*N' ;                                                     //SG01
           pr_DclPiPos = %scan('DCL-PROC ':w_ProcVal);                                        //SG01
           if pr_DclPiPos> 0;                                                                 //SG01
              w_NonOcrPos = %check(' ' : %trim(w_ProcVal):pr_DclPiPos +8);                    //SG01
              if w_NonOcrPos > 0;                                                             //ST01
                 pr_DclPiPos1 = %scan(' ':w_ProcVal:w_NonOcrPos);                             //ST01
                 if pr_DclPiPos1 > 0;                                                         //ST01
                    pr_SourceWord = %subst(w_ProcVal:w_NonOcrPos:(pr_DclPiPos1-w_NonOcrPos)); //ST01
                 endif;                                                                       //ST01
              endif;                                                                          //ST01
              if %subst(pr_SourceWord:%len(%trim(pr_SourceWord)):1) = ';';                    //SG02
                 pr_SourceWord = %subst(pr_SourceWord:1:                                      //SG02
                                        %len(%trim(pr_SourceWord))-1);                        //SG02
              endif;                                                                          //SG02
              pr_procnamefree = pr_SourceWord;                                                //SG01

           endif;                                                                             //SG01
         endif;                                                                               //SG01


         If %scan('EXTPGM':pr_String) = 0 and                                                 //SG01
            %scan('EXTPROC':pr_String) = 0 and                                                //SG01
            pr_SourceWord <> pr_srcmbr;                                                       //SG01
                                                                                              //SG01
           w_PrcSign = ' ';
           if %scan('IMPORT ':w_ProcVal) > 0 or                                               //SG01
              %scan('IMPORT;':w_ProcVal) > 0;                                                 //SG01
             w_PrcSign = 'I';                                                                 //SG01
           elseif %scan('EXPORT ':w_ProcVal) > 0 or                                           //SG01
                  %scan('EXPORT;':w_ProcVal) > 0;                                             //SG01
             w_PrcSign = 'E';                                                                 //SG01
           endif;                                                                             //SG01
           w_ProcNam = pr_SourceWord;                                                         //SG01
      //   WriteProceduredetail(IN_SRCMBR                                                     //SG01
      //                       :IN_SRCSPF
      //                       :IN_SRCLIB
      //                       :IN_TYPE
      //                       :IN_RRNs
      //                       :IN_RRNe
      //                       :w_ProcNam
      //                       :'PI'
      //                       :w_PrcSign);
         Endif;                                                                               //SG01

         //Scan for End-Pi
         pr_EndPiPos = %scan('END-PI ':pr_string);
         pr_EndPiPos1= %scan('END-PI;':pr_string);

         if pr_EndPiPos = 0 and pr_EndPiPos1= 0;
            //Set the pointer on next line of Dcl-Pi
            exsr ReadNextline;
            pr_RRN = in_rrns;                                                            //0022

            dow %trim(pr_string) <> *blanks;
               pr_RRN += 1;                                                              //0022
               exec sql values upper(:pr_string) into :pr_string;
               pr_string = %trim(pr_string);

               //Search if 'END-PI'is there in next line
               pr_EndPiPos  = %scan('END-PI ':pr_string);
               pr_EndPiPos1 = %scan('END-PI;':pr_string);

               if pr_EndPiPos <> 0 OR pr_EndPiPos1 <> 0;
                  leave;
               else;
                  //Search if parameters are there in next line
                  if %scan('DCL-PARM ':pr_string) <> 0;
                     pr_string = %replace('         ':pr_string:1:9);
                     pr_string = %trim(pr_string);
                  endif;

                  pr_DclParmPos   = %scan(' ':pr_string);
                  if pr_DclParmPos > 1;                                                       //ST01
                     pr_SourceWord   = %subst(pr_string:1:(pr_DclParmPos-1));                 //ST01
                     pr_parmnamefree = pr_SourceWord;                                         //ST01
                     pr_DclParmPos   = %check(' ':pr_string:pr_DclParmPos);                   //ST01
                     pr_WordObj      = 'PI-PRM';                                              //ST01
                     if pr_DclParmPos > 0;                                                    //ST01
                        pr_ParmAttrpos  = %scan('(':pr_string:pr_DclParmPos);                 //ST01
                        pr_ParmAttrpos2 = %scan(' ':pr_string:pr_DclParmPos);                 //ST01
                        pr_ParmAttrpos3 = %scan(';':pr_string:pr_DclParmPos);                 //ST01
                     endif;                                                                   //ST01
                  endif;                                                                      //ST01

                  select;
                  when (pr_ParmAttrpos > 0) and
                       (pr_ParmAttrpos < pr_ParmAttrpos2) and
                       (pr_ParmAttrpos < pr_ParmAttrpos3);
                     pr_ParmAttr = %subst(pr_string:pr_DclParmPos:
                                         (pr_ParmAttrpos-pr_DclParmPos));
                     pr_Attr = %trim(pr_ParmAttr);
                     pr_ParmAttrpos1 = %scan(')':pr_string:pr_ParmAttrpos+1);
                     if pr_ParmAttrpos1 > 0;                                                  //ST01
                        pr_Mody = %trim(%subst(pr_string:pr_ParmAttrpos+1:                    //ST01
                                              (pr_ParmAttrpos1-pr_ParmAttrpos-1)));           //ST01
                        pr_keyname = %trim(%subst(pr_string:pr_ParmAttrpos1 +1:               //ST01
                                                  pr_ParmAttrpos3-(pr_ParmAttrpos1 +1)));     //ST01
                     endif;                                                                   //ST01

                  when (pr_ParmAttrpos2 > 0) and (pr_ParmAttrpos = 0) and
                       (pr_ParmAttrpos2 < pr_ParmAttrpos3);
                     pr_ParmAttr =  %subst(pr_string:pr_DclParmPos:
                                          (pr_ParmAttrpos2-pr_DclParmPos));
                     pr_Attr = %trim(pr_ParmAttr);
                     pr_keyname = %trim(%subst(pr_string:pr_ParmAttrpos2 +1:
                                      pr_ParmAttrpos3-(pr_ParmAttrpos2 +1)));

                  when (pr_ParmAttrpos2 > 0) and (pr_ParmAttrpos2 < pr_ParmAttrpos) and
                       (pr_ParmAttrpos2 < pr_ParmAttrpos3);
                     pr_ParmAttr =  %subst(pr_string:pr_DclParmPos:                      //0015
                                          (pr_ParmAttrpos2-pr_DclParmPos));
                     pr_Attr = %trim(pr_ParmAttr);
                     pr_keyname = %trim(%subst(pr_string:pr_ParmAttrpos2 +1:
                                      pr_ParmAttrpos3-(pr_ParmAttrpos2 +1)));
                     pr_Mody = *blanks ;                                                 //0015

                  when (pr_ParmAttrpos3 > 0) and (pr_ParmAttrpos = 0) and
                       (pr_ParmAttrpos3 < pr_ParmAttrpos2);
                     pr_ParmAttr =  %subst(pr_string:pr_DclParmPos:
                                          (pr_ParmAttrpos3-pr_DclParmPos));
                     pr_Attr = %trim(pr_ParmAttr);
                  when (pr_ParmAttrpos3 > 0) and
                       (pr_ParmAttrpos3 < pr_ParmAttrpos) and
                       (pr_ParmAttrpos3 < pr_ParmAttrpos2);
                     pr_ParmAttr =  %subst(pr_string:pr_DclParmPos+1:
                                          (pr_ParmAttrpos3-pr_DclParmPos));
                     pr_Attr = %trim(pr_ParmAttr);
                  endsl;


                  PrPiFlag = 'PI';
                  exsr InsertDdlData;
                  exsr EntryParmData;                                                    //0022
               endif;

               exsr ReadNextLine;
            enddo;
         endif;
      endif;
   endsr;

   // ------------------* Procedure Declaration (End) ------------------ *//
   begsr InsertDDLData;

      clear pr_IaPrcParm;
      pr_position = *zero;
      pr_IaPrcParm.PLIBNAM  = pr_Srclib;
      pr_IaPrcParm.PSRCPF = pr_srcspf;
      pr_IaPrcParm.PMBRNAM = pr_srcmbr;
      pr_IaPrcParm.PIFSLOC = pr_ifsloc;                                                   //0033

      select;
         //When Procedure Name is passed from IAPSRRPG                                   //0024
         when %addr(in_procNm) <> *null;                                                  //0024
            pr_IaPrcParm.PPRNAM = in_procNm;                                              //0024
         other;                                                                           //0024
            pr_IaPrcParm.PPRNAM = pr_procnamefree;                                        //0024
      endsl;                                                                              //0024

      pr_IaPrcParm.PPRMNAM = pr_parmnamefree;
      pr_IaPrcParm.PPRMDTA = pr_Attr;
      pr_IaPrcParm.PPRPIFLG = PrPiFlag;

      pr_IaPrcParm.PPRSEQ = GetSeqNumber(pr_IaPrcParm.PLIBNAM :
                                         pr_IaPrcParm.PSRCPF  :
                                         pr_IaPrcParm.PMBRNAM :
                                         pr_IaPrcParm.PIFSLOC :                          //0033
                                         pr_IaPrcParm.PPRPIFLG:
                                         pr_IaPrcParm.PPRNAM );

      pr_IaPrcParm.PPRMSEQ = GetSeqNumber(pr_IaPrcParm.PLIBNAM :
                                          pr_IaPrcParm.PSRCPF  :
                                          pr_IaPrcParm.PMBRNAM :
                                          pr_IaPrcParm.PIFSLOC :                         //0033
                                          pr_IaPrcParm.PPRPIFLG:
                                          pr_IaPrcParm.PPRNAM  :
                                          pr_IaPrcParm.PPRMNAM);

      //Checking whether the data type is  date, time, indicator, pointer               //0024
      //timestamp i.e data types where length is not specified                          //0024
      if %lookup( %trim(pr_attr): defaultDataTypeArr ) > 0;                              //0024
         defaultDType = 'Y';                                                             //0024
         select;                                                                         //0024
            when %trim(pr_attr) = 'DATE';                                                //0024
               pr_IaPrcParm.PPRMLEN = 10;                                                //0024
               pr_IaPrcParm.PPRMDEC = 0;                                                 //0024
            when %trim(pr_attr) = 'TIME';                                                //0024
               pr_IaPrcParm.PPRMLEN = 8 ;                                                //0024
               pr_IaPrcParm.PPRMDEC = 0;                                                 //0024
            when %trim(pr_attr) = 'TIMESTAMP';                                           //0024
               pr_IaPrcParm.PPRMLEN = 26;                                                //0024
               pr_IaPrcParm.PPRMDEC = 0;                                                 //0024
            when %trim(pr_attr) = 'IND';                                                 //0024
               pr_IaPrcParm.PPRMLEN = 1;                                                 //0024
               pr_IaPrcParm.PPRMDEC = 0;                                                 //0024
            when %trim(pr_attr) = 'POINTER';                                             //0024
               pr_IaPrcParm.PPRMLEN = 0;                                                 //0024
               pr_IaPrcParm.PPRMDEC = 0;                                                 //0024
         endsl;                                                                          //0024
      endif;                                                                             //0024

      if %scan(':':pr_mody) > 0;
         monitor;
            if %check(numConst:%trim(%subst(pr_mody :1:
                      %scan(':':pr_mody)-1))) = 0 and
               %subst(pr_mody :1:%scan(':':pr_mody)-1) <> *blanks;
                  pr_IaPrcParm.PPRMLEN  = %dec(%trim(%subst(pr_mody :1:
                                          %scan(':':pr_mody)-1)):5:0);
            endIf;
         on-error;
            pr_IaPrcParm.PPRMLEN = 0;
         endmon;

         monitor;
            if %check(numConst:%trim(%subst(pr_mody:%scan(':':pr_mody)+1))) = 0 and
               %subst(pr_mody:%scan(':':pr_mody)+1) <> *blanks;
               pr_IaPrcParm.PPRMDEC =  %dec(%trim(%subst(pr_mody:
                                            %scan(':':pr_mody)+1)):5:0);
            endIf;
         on-error;
            pr_IaPrcParm.PPRMDEC = 0;
         endmon;
      else;
         if defaultDType <> 'Y';                                                         //0024
            pr_IaPrcParm.PPRMDEC   = 0;
            pr_position = %check('0123456789' : %trim(pr_mody));

            if pr_position > *zero or pr_mody = *blanks;
               pr_IaPrcParm.PPRMLEN   = *zero;
            else;
               if pr_mody <> *blanks                                                     //0016
               and %check(numConst:%Trim(pr_mody)) = 0;                                  //0022
                  monitor;                                                               //0025
                     pr_IaPrcParm.PPRMLEN   = %dec(pr_mody:6:0);                         //0025
                  on-error;                                                              //0025
                     pr_IaPrcParm.PPRMLEN   = 0;                                         //0025
                  endmon;                                                                //0025
               endIf;
            endif;
         else;                                                                           //0024
           if %scan('*':%trim(pr_mody)) = 1;                                             //0024
              dateFmt = pr_mody;                                                         //0024
           endif;                                                                        //0024
         endif;
      endif;

      if %scan('DIM':pr_string) > 0;
         pr_dim1 = %scan('DIM':pr_String);
         pr_dim1 = %scan('(':pr_string:pr_dim1) +1;
         pr_dim2 = %scan(')':pr_string:pr_dim1);
         if pr_dim2 > 0;                                                                      //ST01
            pr_Dim = %subst(pr_string:pr_dim1:pr_dim2 - pr_dim1);                             //ST01
         endif;                                                                               //ST01

         if %trim(pr_dim) <> *blanks;
            if %check(numConst:%trim(pr_dim)) = 0;
               pr_IaPrcParm.PPRMARR = %dec(pr_dim:5:0);
            endIf;
         endif;
      endif;

      pr_IaPrcParm.PKEYNAM   = pr_keyname;
      if pr_IaPrcParm.PPRMDTA = 'LIKE' Or
         pr_IaPrcParm.PPRMDTA = 'LIKEDS';
         if pr_Mody <> *blanks ;                                                         //0015
            pr_IaPrcParm.PKEYNAM = %trim(pr_IaPrcParm.PPRMDTA) + '(' + %trim(pr_mody) +
                                   ')' + ' ' +  pr_IaPrcParm.PKEYNAM;
         else;                                                                           //0015
            pr_IaPrcParm.PKEYNAM = %trim(pr_IaPrcParm.PPRMDTA) +                         //0015
                                   pr_IaPrcParm.PKEYNAM;                                 //0015
         endif ;                                                                         //0015
         pr_IaPrcParm.PPRMDTA = *blanks;
         pr_IaPrcParm.PPRMLEN = *zero;
      endif;

      exec sql
        insert into IaPrcParm (PLIBNAM,
                               PSRCPF,
                               PMBRNAM,
                               PIFSLOC,                                                  //0033
                               PPRPIFLG,
                               PPRSEQ,
                               PPRNAM,
                               PPRMSEQ,
                               PPRMNAM,
                               PPRMARR,
                               PKEYNAM)
          values (trim(:pr_IaPrcParm.PLIBNAM),
                  trim(:pr_IaPrcParm.PSRCPF ),
                  trim(:pr_IaPrcParm.PMBRNAM),
                  trim(:pr_IaPrcParm.PIFSLOC),                                           //0033
                  trim(:pr_IaPrcParm.PPRPIFLG),
                  trim(char(:pr_IaPrcParm.PPRSEQ)),
                  trim(:pr_IaPrcParm.PPRNAM),
                  trim(char(:pr_IaPrcParm.PPRMSEQ)),
                  trim(:pr_IaPrcParm.PPRMNAM),
                  trim(char(:pr_IaPrcParm.PPRMARR)),
                  trim(:pr_IaPrcParm.PKEYNAM));

      if in_prc = *on;                                                                   //0016
         w_IAVR_TYP    = 'PG_LO';                                                        //0016
      else;                                                                              //0016
         w_IAVR_TYP    = 'PG_GL';                                                        //0016
      endIf;                                                                             //0016

      if pr_IaPrcParm.PPRMNAM <> '*N';                                                   //0016
         exec sql                                                                        //0016
           insert into IAPGMVARS(IAVMBR,                                                 //0016
                                 IAVSFILE,                                               //0016
                                 IAVLIB,                                                 //0016
                                 IAVIFSLOC,                                              //0033
                                 IAVVAR,                                                 //0016
                                 IAVRRN,                                                 //0029
                                 IAVTYP,                                                 //0016
                                 IAVPRCNM,                                               //0024
                                 IAVDTYP,                                                //0016
                                 IAVLEN,                                                 //0016
                                 IAVDEC,                                                 //0016
                                 IAVDIM,                                                 //0016
                                 IAVDATF,                                                //0024
                                 IAVKEYWRD)                                              //0022
           values (trim(:pr_IaPrcParm.PMBRNAM),                                          //0016
                   trim(:pr_IaPrcParm.PSRCPF),                                           //0016
                   trim(:pr_IaPrcParm.PLIBNAM),                                          //0016
                   trim(:pr_IaPrcParm.PIFSLOC),                                          //0033
                   trim(:pr_IaPrcParm.PPRMNAM),                                          //0016
                   :pr_SrcRRNCnt,                                                        //0029
                   trim(:w_IAVR_TYP),                                                    //0016
                   trim(:pr_IaPrcParm.PPRNAM),                                           //0024
                   trim(:pr_IaPrcParm.PPRMDTA),                                          //0016
                   trim(char(:pr_IaPrcParm.PPRMLEN)),                                    //0016
                   trim(char(:pr_IaPrcParm.PPRMDEC)),                                    //0016
                   trim(char(:pr_IaPrcParm.PPRMARR)),                                    //0016
                   trim(:dateFmt),                                                       //0024
                   trim(:pr_IaPrcParm.PKEYNAM));                                         //0016
      endif ;                                                                            //0016

      clear pr_mody;                                                                     //0024
      clear dateFmt;                                                                     //0024
      clear defaultDType;                                                                //0024

      if SQLSTATE <> SQL_ALL_OK;
         //log error
      endif;
   endsr;

   //Capture Entry Parameters into IAENTPRM File also...
   BegSr EntryParmData;                                                                  //0022

      If SQLSTATE = SQL_ALL_OK ;                                                         //0022
         Exec SQL                                                                        //0022
              Insert                                                                     //0022
              Into   IAENTPRM                                                            //0022
                     (MEMBER_NAME,                                                       //0022
                      SRCPF_NAME,                                                        //0022
                      LIBRARY_NAME,                                                      //0022
                      IFS_LOCATION,                                                      //0033
                      PARM_SEQ,                                                          //0022
                      PARM_NAME,                                                         //0022
                      PROC_NAME,                                                         //0022
                      PARM_KEYVAL)                                                       //0022
              Values (trim(:pr_IaPrcParm.PMBRNAM),                                       //0022
                      trim(:pr_IaPrcParm.PSRCPF ),                                       //0022
                      trim(:pr_IaPrcParm.PLIBNAM),                                       //0022
                      trim(:pr_IaPrcParm.PIFSLOC),                                       //0033
                      trim(char(:pr_IaPrcParm.PPRMSEQ)),                                 //0022
                      trim(:pr_IaPrcParm.PPRMNAM),                                       //0022
                      trim(:pr_IaPrcParm.PPRNAM),                                        //0022
                      trim(:pr_IaPrcParm.PKEYNAM));                                      //0022
      Elseif SQLSTATE <> SQL_ALL_OK;                                                     //0022
         //log error
      endif;                                                                             //0022
   EndSr;                                                                                //0022

end-proc;

dcl-proc IAPSRPRFX Export;
   dcl-pi IAPSRPRFX;
      in_string  char(5000);
      in_type    char(10);
      in_error   char(10);
      in_xref    char(10);
   // in_srclib  char(10);                                                               //0033
   // in_srcspf  char(10);                                                               //0033
   // in_srcmbr  char(10);                                                               //0033
      in_uWSrcDtl likeds(uWSrcDtl);                                                      //0033
      in_rrns    packed(6:0);
      in_rrne    packed(6:0);
      in_seqNum  packed(6:2);                                                            //0013
      in_lprname char(50);
      in_prc     ind;                                                                    //0028
   end-pi;

   dcl-ds pr_IAPRCPARM extname('IAPRCPARM') qualified inz end-ds;

   dcl-s pr_XRef         char(10)    inz;
   dcl-s pr_srclib       char(10)    inz;
   dcl-s pr_srcspf       char(10)    inz;
   dcl-s pr_srcmbr       char(10)    inz;
   dcl-s pr_ifsloc       char(100)   inz;                                                //0033
   dcl-s pr_WordObj      char(10)    inz;
   dcl-s pr_ObjRef       char(10)    inz;
   dcl-s pr_QuoteBrktPos packed(5)   inz;
   dcl-s pr_BrktQuotePos packed(5)   inz;
   dcl-s pr_ExtPgmPos    packed(5)   inz;
   dcl-s pr_SourceWord   char(128)   inz;
   dcl-s pr_procnamefree char(128)   inz;
   dcl-s pr_parmnamefree char(128)   inz;
   dcl-s pr_keyname      char(128)   inz;
   dcl-s pr_ExPgmName    char(128)   inz;
   dcl-s pr_Pos1         packed(6)   inz;
   dcl-s pr_Pos2         packed(6)   inz;
   dcl-s pr_Dim          char(10)    inz;
   dcl-s pr_Dim1         packed(6)   inz;
   dcl-s pr_Dim2         packed(6)   inz;
   dcl-s pr_String       char(200)   inz;
   dcl-s pr_SrcRrnCnt    packed(6:0) inz;
   dcl-s pr_InString     char(5000)  inz;
   dcl-s pr_Attr         char(10)    inz;
   dcl-s pr_Mody         char(10)    inz;
   dcl-s pr_Seq          packed(6:0) inz;
   dcl-s pr_rrns         packed(6:0) inz;
   dcl-s pr_rrne         packed(6:0) inz;
   dcl-s pr_Sts          char(10)    inz;
   dcl-s pr_Lprname      char(50)    inz;
   dcl-s pr_position     packed(5)   inz;
   dcl-s PrPiFlag        char(2)     inz;
   dcl-s w_PrcSign       char(1)     inz;                                                     //SG01
   dcl-s w_FixProcB      char(5000)  inz;                                                     //SG01
   dcl-s w_ProcNam       char(80)    inz;                                                     //SG01
   dcl-s proc_rrn        packed(6:0) inz;                                                //0013
   dcl-s procEI          char(1)     inz;                                                //0013
   dcl-s pr_seqNum       packed(6:2) inz;                                                //0013
   Dcl-S pr_RRN          Like(in_rrns);                                                  //0022
   dcl-s w_ProcNamD      char(80)    inz;                                                //0022
   dcl-s w_IAVARTYP      char(5);                                                        //0028

   dcl-c Quote       '"';
   dcl-c quot        '''';

   pr_Pos1 = 1;
   uWSrcDtl  = in_uWSrcDtl;                                                              //0033
   pr_SrcRrnCnt = in_rrns - 1;
   pr_seqNum = in_seqNum;                                                                //0013
   pr_rrns   = in_rrns;
   pr_rrne   = in_rrne;
   pr_XRef   = in_XRef;
   pr_Srclib = in_Srclib;
   pr_Srcspf = in_Srcspf;
   pr_Srcmbr = in_Srcmbr;
   pr_ifsloc = in_Ifsloc;                                                                  //0033
   pr_InString = in_String;
   pr_ObjRef   = ' ';
   pr_Attr     = ' ';
   pr_Mody     = ' ';
   pr_Seq      = 0;
   pr_Sts      = ' ';
   pr_lprname  = in_lprname;
   w_FixProcB = ' ';                                                                          //SG01
                                                                                              //ST01
   Clear DSpecV4;                                                                        //0022
   exec sql                                                                                   //ST01
     values upper(:pr_InString) into :pr_InString;                                            //ST01
    //----------Getting Procedure name if Procedure declaration----------//
     if in_lprname <> *blanks;                                                           //0013

        w_procNam  = in_lprname;                                                         //0013


        if %scan( 'EXPORT': pr_InString:44 ) > 1;                                        //0013
           procEI = 'E';                                                                 //0013
        else;                                                                            //0013
           procEI = 'I';                                                                 //0013
        endif;                                                                           //0013

        exsr insertIntoProcInfo;                                                         //0019

     elseif %scan( 'P':pr_InString:6 ) = 6 and %scan( 'B':pr_InString:24) = 24;          //0013

        w_ProcNam   = %subst( pr_InString :7:15 );                                       //0013

        if %scan( ' EXPORT': %trim(pr_InString) ) > 0;                                   //0013
           procEI = 'E';                                                                 //0013
        else;                                                                            //0013
         procEI = 'I';                                                                   //0013
       endif;                                                                            //0013

       exsr insertIntoProcInfo;                                                          //0019

     endif;                                                                              //0013

   exsr ReadNextLineFix;

   dow pr_string <> *blanks;
      exec sql
        values upper(:pr_String) into :pr_String;

      if %subst(pr_String:6:1) = 'D' ;                                                   //0006
         DspecV4 = pr_String ;                                                           //0006
      elseif %subst(pr_String:6:1) = 'P';                                                //0006
      endif ;                                                                            //0006

      select;
      //Search for 'DCL-PR' word in each line .
      //E.g.  Dcl-Pr Rtvmsg  ExtPgm('USRC002');
      when DspecV4.specification = 'D' and DspecV4.declarationType = 'PR';               //0006
         exsr ProcessPRFix;

      //Search for 'DCL-PI' word in each line
      //E.g.  Dcl-Pi ValidateFields Ind;
      when DspecV4.specification = 'D' and DspecV4.declarationType = 'PI';               //0006
         exsr ProcessPIFix;

      //Search for Beginning of procedure in fix format                                      //SG01
      //E.g.  P ProcName    B           EXPORT                                               //SG01
      when %subst(pr_String:6:1) = 'P' and %subst(pr_String:24:1) = 'B';                      //SG01
         w_FixProcB = %trimr(pr_String);                                                      //SG01

      //Fetch the long procedure name from D spec within the procedure.
      //E.g.  D ProcName...
      when %subst(pr_String:6:1) = 'D' and %scan('...':pr_String) <> 0;                  //0022
        w_ProcNamD = %Trim(w_ProcNamD) + %Trim(%SubSt(pr_String:7:                       //0022
                                                %scan('...':pr_String) - 7));            //0022
      endsl;                                                                                  //SG01

      exsr ReadNextLineFix;
   enddo;

   in_error = 'C';
   return;

   //Sub-Proc To Parse Fix Format PR & PI
   begsr ReadNextLineFix;
      pr_Pos2 = %scan('^': pr_InString : pr_Pos1);

      if Pr_Pos2  > *zero and pr_Pos2 > pr_Pos1;
         pr_String = %subst(pr_InString : pr_Pos1 : pr_Pos2 - pr_Pos1 );
         pr_Pos1 = pr_Pos2 + 1;
         pr_SrcRrnCnt    += 1;
      else;
         pr_String = *blanks;
      endif;
   endsr;

   //----------Insert into IAPROCINFO file------------------------ //
   begsr insertIntoProcInfo;                                                             //0019
    // WriteProceduredetail( in_srcmbr                                              0033 //0013
    //                      :in_srcspf                                              0033 //0013
    //                      :in_srclib                                              0033 //0013
       WriteProceduredetail(IN_uWSrcDtl                                                  //0033
                           :in_type                                                      //0013
                           :pr_seqNum                                                    //0013
                           :in_RRNs                                                      //0013
                           :w_ProcNam                                                    //0013
                           :'PI'                                                         //0013
                           :procEI );                                                    //0013
   endsr;                                                                                //0013


   begsr ProcessPRFix;
      pr_SourceWord   = DspecV4.name ;                                                   //0006
      pr_procnamefree = pr_SourceWord;
      pr_WordObj      = 'PR-NAM';

      if pr_lprname <> ' ';
         pr_SourceWord   = %trim( pr_lprname + pr_SourceWord);
         pr_procnamefree = pr_SourceWord;
         pr_SrcRrnCnt -= 1;


         pr_SrcRrnCnt += 1;
      else;
      endif;

      If %scan('EXTPGM':DspecV4.keyword) = 0 and                                         //0006
         %scan('EXTPROC':DspecV4.keyword) = 0 and                                        //0006
         pr_SourceWord <> pr_srcmbr;                                                       //SG01
        w_ProcNam = pr_SourceWord;                                                         //SG01
      // WriteProceduredetail(IN_SRCMBR                                                  0033 //SG01
      //                      :IN_SRCSPF                                                      //0033
      //                      :IN_SRCLIB                                                      //0033
         WriteProceduredetail(IN_uWSrcDtl                                                     //0033
                             :IN_TYPE
                             :pr_seqNum                                                  //0013
                             :IN_RRNs                                                    //0013
                             :w_ProcNam
                             :'PR'
                             :' ');
      endif;                                                                               //SG01

      pr_ExtPgmPos = %scan('EXTPGM':DspecV4.keyword);                                    //0006

      //If ExtPgm Keyword found and if there is string after
      //Extpgm keyword then search for
      if pr_ExtPgmPos > 0 and pr_SourceWord <> pr_srcmbr;
         pr_BrktquotePos = %scan(('('+ Quote):DspecV4.keyword:pr_ExtPgmPos+6);                //0006
         if pr_BrktquotePos > 0;
            pr_QuoteBrktPos = %scan((Quote+')'):DspecV4.keyword:pr_ExtPgmPos+6);              //0006
            if pr_QuoteBrktPos > 0 and pr_QuoteBrktPos > (pr_BrktquotePos+2);                 //ST01
               pr_ExPgmName    = %subst(DspecV4.keyword:pr_BrktquotePos+2:                    //0006
                                        pr_QuoteBrktPos-(pr_BrktquotePos+2));                 //ST01
               pr_ExPgmName  = %trim(pr_ExPgmName);                                           //ST01
            else;                                                                             //ST01
               pr_ExPgmName  = *blanks;                                                       //ST01
            endif;                                                                            //ST01
            pr_WordObj    = 'EX-PGM';

         endif;
      endif;

      pr_ExtPgmPos = %scan('EXTPROC':DspecV4.keyword);                                        //0006

      //If ExtPgm Keyword found and if there is string after
      //Extpgm keyword then search for
      if pr_ExtPgmPos > 0 and pr_SourceWord <> pr_srcmbr;
         pr_BrktquotePos = %scan(('('+ Quote):DspecV4.keyword:pr_ExtPgmPos+7);                //0006

         if pr_BrktquotePos > 0;
            pr_QuoteBrktPos = %scan((Quote+')'):DspecV4.keyword:pr_ExtPgmPos+7);              //0006
            if pr_QuoteBrktPos > 0 and pr_QuoteBrktPos > (pr_BrktquotePos+2);                 //ST01
               pr_ExPgmName    = %subst(DspecV4.keyword:pr_BrktquotePos+2:                    //0006
                                        pr_QuoteBrktPos-(pr_BrktquotePos+2));                 //ST01
               pr_ExPgmName  = %trim(pr_ExPgmName);                                           //ST01
            else;                                                                             //ST01
               pr_ExPgmName  = *blanks;                                                       //ST01
            endif;                                                                            //ST01
            pr_WordObj    = 'EX-PROC';

         endif;
      endif;

      //Set the pointer on next line of Dcl-Pr
      exsr readnextlinefix;
      pr_RRN = in_rrns;                                                                  //0029

      dow pr_string <> *blanks;
         pr_RRN += 1;                                                                    //0029
         DspecV4 = pr_String ;                                                                //0006
         pr_SourceWord = DspecV4.name ;                                                       //0006
         pr_WordObj = 'PR-PRM';
         pr_parmnamefree = pr_SourceWord;

         pr_Attr = GetDataType(DspecV4.internalDataType:                                      //0006
                               DspecV4.decimalPosition:                                       //0006
                               DspecV4.toLength);                                             //0006

         pr_Mody = %trim(DspecV4.toLength);                                                   //0006
         if DspecV4.decimalPosition <> '  ';                                                  //0006
            pr_Mody  = %trim(pr_Mody) + ':' + %trim(DspecV4.decimalPosition) ;                //0006
         endif;

         pr_keyname = %trim(DspecV4.keyword);                                            //0006
         if %scan('LIKEDS':pr_keyname) > 0;
            pr_Attr = 'LIKEDS';
            pr_Mody = pr_LikeDetails(pr_keyname);
         endif;

         if %scan('LIKE':pr_keyname) > 0;
            pr_Attr = 'LIKE';
            pr_Mody = pr_LikeDetails(pr_keyname);
         endif;

         if pr_parmnamefree <> *blanks;
         endif;

         if %scan('LIKEDS':pr_keyname) > 0 Or
            %scan('LIKE':pr_keyname) > 0;
            pr_Attr = *blanks;
            pr_Mody = *blanks;
         endif;

         PrPiFlag = 'PR';

         exsr InsertDdlData;
         exsr EntryParmData;                                                             //0029
         exsr ReadNextLineFix;
      enddo;
   endsr;

   begsr ProcessPIFix;
      pr_SourceWord = %trim(DspecV4.name) ;                                              //0006
      pr_procnamefree = pr_SourceWord;
      pr_WordObj    = 'PI-NAM';

      If pr_SourceWord = ' ' and w_FixProcB <> ' ';                                           //SG01
        pr_SourceWord = %trim(%subst(w_FixProcB:7:17));                                       //SG01
        pr_procnamefree = pr_SourceWord;                                                      //SG01
      endif;                                                                                  //SG01

      if pr_lprname <> ' ';
         pr_SourceWord = %Trim(w_ProcNamD) + %trim(DspecV4.name) ;                       //0022
         pr_procnamefree = pr_SourceWord;
         pr_SrcRrnCnt -= 1;


         pr_SrcRrnCnt += 1;
      else;
      endif;

      If %scan('EXTPGM':DspecV4.keyword) = 0 and                                             //0006
         %scan('EXTPROC':DspecV4.keyword) = 0 and                                            //0006
         pr_SourceWord <> pr_srcmbr;                                                         //SG01

        w_PrcSign = ' ';                                                                     //SG01
     // if %scan('IMPORT ':w_FixProcB) > 0 or                                            //0013
        if %scan('EXPORT ':w_FixProcB) > 0;                                              //0013
        // %scan('IMPORT;':w_FixProcB) > 0;                                              //0013
          w_PrcSign = 'E';                                                                   //SG01
     // elseif %scan('EXPORT ':w_FixProcB) > 0 or                                        //0013
       //      %scan('EXPORT;':w_FixProcB) > 0;                                          //0013
          w_PrcSign = 'E';                                                                   //SG01
        else;
          w_prcSign = 'I';                                                               //0013
        endif;                                                                               //SG01
        w_FixProcB = ' ';                                                                    //SG01

        w_ProcNam = pr_SourceWord;                                                           //SG01
     // WriteProceduredetail(IN_SRCMBR                                                       //SG01
     //                      :IN_SRCSPF
     //                      :IN_SRCLIB
     //                      :IN_TYPE
     //                      :IN_RRNs
     //                      :IN_RRNe
     //                      :w_ProcNam
     //                      :'PI'
     //                      :w_PrcSign);
      endif;                                                                               //SG01

      //Set the pointer on next line of Dcl-Pr
      exsr ReadNextLineFix;
      pr_RRN = in_rrns;                                                                  //0022

      dow pr_string <> *blanks;
         pr_RRN += 1;                                                                    //0022
         DspecV4 = pr_String ;                                                                //0006
         pr_SourceWord   = %trim(DspecV4.name);                                               //0006
         pr_parmnamefree = pr_SourceWord;
         pr_WordObj      = 'PI-PRM';

         pr_Attr = GetDataType(DspecV4.internalDataType:                                      //0006
                               DspecV4.decimalPosition:                                       //0006
                               DspecV4.toLength);                                             //0006

         pr_Mody = %trim(DspecV4.toLength);                                                   //0006
         if DspecV4.decimalPosition <> '  ';                                                  //0006
            pr_Mody  = %trim(pr_Mody) + ':'+ %trim(DspecV4.decimalPosition) ;                //0006
         endif;

         pr_keyname = %trim(DspecV4.keyword);                                                //0006
         if %scan('LIKEDS':pr_keyname) > 0;
            pr_Attr = 'LIKEDS';
            pr_Mody = pr_LikeDetails(pr_keyname);
         endif;

         if %scan('LIKE':pr_keyname) > 0;
            pr_Attr = 'LIKE';
            pr_Mody = pr_LikeDetails(pr_keyname);
         endif;


         if %scan('LIKEDS':pr_keyname) > 0 Or %scan('LIKE':pr_keyname) > 0;
            pr_Attr = *blanks;
            pr_Mody = *blanks;
         endif;

         PrPiFlag = 'PI';

         exsr InsertDdlData;
         exsr EntryParmData;                                                             //0022
         exsr ReadNextLineFix;
      enddo;

      leavesr;
   endsr;

   begsr InsertDDLData;
      clear pr_IaPrcParm;
      pr_position = *zero;
      pr_IaPrcParm.PLIBNAM  = pr_Srclib;
      pr_IaPrcParm.PSRCPF = pr_srcspf;
      pr_IaPrcParm.PMBRNAM = pr_srcmbr;
      pr_IaPrcParm.PIFSLOC = pr_ifsloc;                                                  //0033
      pr_IaPrcParm.PPRNAM = pr_procnamefree;
      pr_IaPrcParm.PPRMNAM = pr_parmnamefree;
      pr_IaPrcParm.PPRMDTA = pr_Attr;
      pr_IaPrcParm.PPRPIFLG = PrPiFlag;

      pr_IaPrcParm.PPRSEQ = GetSeqNumber(pr_IaPrcParm.PLIBNAM :
                                         pr_IaPrcParm.PSRCPF  :
                                         pr_IaPrcParm.PMBRNAM :
                                         pr_IaPrcParm.PIFSLOC :                          //0033
                                         pr_IaPrcParm.PPRPIFLG:
                                         pr_IaPrcParm.PPRNAM );

      pr_IaPrcParm.PPRMSEQ = GetSeqNumber(pr_IaPrcParm.PLIBNAM :
                                          pr_IaPrcParm.PSRCPF  :
                                          pr_IaPrcParm.PMBRNAM :
                                         pr_IaPrcParm.PIFSLOC :                          //0033
                                          pr_IaPrcParm.PPRPIFLG:
                                          pr_IaPrcParm.PPRNAM  :
                                          pr_IaPrcParm.PPRMNAM);
      if %scan(':':pr_mody) > 0;
         monitor;
            if %scan(':':pr_mody) > 1
               and %subst(pr_mody :1:%scan(':':pr_mody)-1) <> *blanks
               and (%check(numConst:%trim(%subst(pr_mody :1:
                               %scan(':':pr_mody)-1)))) = 0;
               pr_IaPrcParm.PPRMLEN = %dec(%trim(%subst(pr_mody :1:
                                        %scan(':':pr_mody)-1)):5:0);
            endIf;
         on-error;
            pr_IaPrcParm.PPRMLEN = 0;
         endmon;

         monitor;
            if (%check(numConst:%trim(%subst(pr_mody:%scan(':':pr_mody)+1))) = 0 and
                %subst(pr_mody:%scan(':':pr_mody)+1)<> *blanks);
               pr_IaPrcParm.PPRMDEC=%dec(%trim(%subst(pr_mody:%scan(':':pr_mody)+1)):5:0);
            endIf;
         on-error;
            pr_IaPrcParm.PPRMDEC = 0;
         endmon;
      else;
         pr_IaPrcParm.PPRMDEC   = 0;
         pr_position = %check('0123456789' : %trim(pr_mody));

         if pr_position > *zero or pr_mody = *blanks;
            pr_IaPrcParm.PPRMLEN   = *zero;
         else;
            if %check(numConst:%trim(pr_mody)) = 0 and
               pr_mody <> *blanks;
               pr_IaPrcParm.PPRMLEN  = %dec(pr_mody:5:0);
            endIf;
         endif;
      endif;

      if %scan('DIM':DspecV4.keyword) > 0;                                                    //0006
         pr_dim1 = %scan('DIM':DspecV4.keyword);                                              //0006
         pr_dim1 = %scan('(':DspecV4.keyword:pr_dim1) +1;                                     //0006
         pr_dim2 = %scan(')':DspecV4.keyword:pr_dim1);                                        //0006
         if pr_dim1 > 0 and pr_dim2 > 0 and pr_dim2 > pr_dim1;                                //ST01
            pr_Dim = %subst(DspecV4.keyword:pr_dim1:pr_dim2 - pr_dim1);                       //0006
         endif;                                                                               //ST01

         if %trim(pr_dim) <> *blanks;
            if %check(numConst:%trim(pr_dim)) = 0 ;
               pr_IaPrcParm.PPRMARR = %dec(pr_dim:5:0);
            endIf;
         endif;
      endif;

      pr_IaPrcParm.PKEYNAM   = pr_keyname;
      if pr_IaPrcParm.PPRMDTA = 'LIKE' Or
         pr_IaPrcParm.PPRMDTA = 'LIKEDS';
         pr_IaPrcParm.PKEYNAM = %trim(pr_IaPrcParm.PPRMDTA) + '(' +
                                %trim(pr_mody) + ')' + ' ' + pr_IaPrcParm.PKEYNAM;
         pr_IaPrcParm.PPRMDTA = *blanks;
         pr_IaPrcParm.PPRMLEN = *zero;
      endif;

      exec sql
        insert into IaPrcParm (PLIBNAM,
                               PSRCPF,
                               PMBRNAM,
                               PIFSLOC,                                                  //0033
                               PPRPIFLG,
                               PPRSEQ,
                               PPRNAM,
                               PPRMSEQ,
                               PPRMNAM,
                               PKEYNAM)
          values (trim(:pr_IaPrcParm.PLIBNAM),
                  trim(:pr_IaPrcParm.PSRCPF ),
                  trim(:pr_IaPrcParm.PMBRNAM),
                  trim(:pr_IaPrcParm.PIFSLOC),                                           //0033
                  trim(:pr_IaPrcParm.PPRPIFLG),
                  trim(char(:pr_IaPrcParm.PPRSEQ)),
                  trim(:pr_IaPrcParm.PPRNAM),
                  trim(char(:pr_IaPrcParm.PPRMSEQ)),
                  trim(:pr_IaPrcParm.PPRMNAM),
                  trim(:pr_IaPrcParm.PKEYNAM));

         if in_prc = *on;                                                                //0028
            w_IAVARTYP    = 'PG_LO';                                                     //0028
         else;                                                                           //0028
            w_IAVARTYP    = 'PG_GL';                                                     //0028
         endIf;                                                                          //0028
                                                                                         //0028
         exec sql                                                                        //0028
           insert into IAPGMVARS(IAVMBR,                                                 //0028
                                 IAVSFILE,                                               //0028
                                 IAVLIB,                                                 //0028
                                 IAVIFSLOC,                                              //0033
                                 IAVVAR,                                                 //0028
                                 IAV_RRN,
                                 IAVTYP,                                                 //0028
                                 IAVDTYP,                                                //0028
                                 IAVLEN,                                                 //0028
                                 IAVDEC,                                                 //0028
                                 IAVDIM,                                                 //0028
                                 IAVKWDNM)                                               //0028
           values(trim(:pr_IaPrcParm.PMBRNAM),                                           //0028
                 trim(:pr_IaPrcParm.PSRCPF ),                                            //0028
                 trim(:pr_IaPrcParm.PLIBNAM),                                            //0028
                 trim(:pr_IaPrcParm.PIFSLOC),                                            //0033
                 trim(:pr_IaPrcParm.PPRMNAM),                                            //0028
                 :pr_RRN,
                 trim(:w_IAVARTYP),                                                      //0028
                 trim(:pr_IaPrcParm.PPRMDTA),                                            //0028
                 trim(:pr_IaPrcParm.PPRMLEN),                                            //0028
                 trim(:pr_IaPrcParm.PPRMDEC),                                            //0028
                 trim(:pr_IaPrcParm.PPRMARR),                                            //0028
                 trim(:pr_IaPrcParm.PKEYNAM));                                           //0028

      if SQLSTATE <> SQL_ALL_OK;
         //log error
      endif;
   endsr;

   //Capture Entry Parameters into IAENTPRM File also...
   BegSr EntryParmData;                                                                  //0022
                                                                                         //0022
      If SQLSTATE = SQL_ALL_OK ;                                                         //0022
         Exec SQL                                                                        //0022
              Insert                                                                     //0022
              Into   IAENTPRM                                                            //0022
                     (MEMBER_NAME,                                                       //0022
                      SRCPF_NAME,                                                        //0022
                      LIBRARY_NAME,                                                      //0022
                      IFS_LOCATION,                                                      //0033
                      PARM_SEQ,                                                          //0022
                      PARM_NAME,                                                         //0022
                      PROC_NAME,                                                         //0022
                      PARM_KEYVAL)                                                       //0022
              Values (trim(:pr_IaPrcParm.PMBRNAM),                                       //0022
                      trim(:pr_IaPrcParm.PSRCPF ),                                       //0022
                      trim(:pr_IaPrcParm.PLIBNAM),                                       //0022
                      trim(:pr_IaPrcParm.PIFSLOC),                                       //0033
                      trim(char(:pr_IaPrcParm.PPRMSEQ)),                                 //0022
                      trim(:pr_IaPrcParm.PPRMNAM),                                       //0022
                      trim(:pr_IaPrcParm.PPRNAM),                                        //0022
                      trim(:pr_IaPrcParm.PKEYNAM));                                      //0022
      Else;                                                                              //0022
         //log error
      endif;                                                                             //0022
                                                                                         //0022
   EndSr;                                                                                //0022

end-proc;

dcl-proc Pr_LikeDetails export;
   dcl-pi Pr_LikeDetails char(10);
      Keywords char(128) const;
   end-pi;

   dcl-s Pos1  packed(5) inz;
   dcl-s Pos2  packed(5) inz;
   dcl-s Value char(10)  inz;

   select;
   when %scan('LIKEDS':Keywords) > 0;
      Pos1 = %scan('LIKEDS':Keywords);
   when %scan('LIKE':Keywords) > 0;
      Pos1 = %scan('LIKE':Keywords);
   endsl;

   if pos1 > 0;                                                                               //ST01
      pos1  = %scan('(':Keywords:Pos1);                                                       //ST01
      if pos1 > 0;                                                                            //ST01
         pos2  = %scan(')':Keywords:Pos1);                                                    //ST01
         if pos2 > Pos1 + 1;                                                                 //ST01
            value = %subst(Keywords: Pos1 + 1: Pos2 - Pos1 - 1);                              //ST01
         endif;                                                                               //ST01
      endif;                                                                                  //ST01
   endif;                                                                                     //ST01

   return Value;
end-proc;

dcl-proc WriteLikeDSDtl export;
   dcl-pi WriteLikeDSDtl;
   end-pi;

   dcl-ds wk_uwdsdtl extname('IAPGMDS') qualified inz;
   end-ds;

   dcl-s wk_LikeDsNm char(128);
   dcl-s wk_MainDsNm char(128);
   dcl-s wk_MbrNm    char(10);
   dcl-s wk_LibNm    char(10);
   dcl-s wk_IfsLoc   char(100);                                                          //0033

   exec sql
     declare IAPSRDS_C4 cursor for
       select * from qtemp/wklikedsPf;

   exec sql open IAPSRDS_C4;
// exec sql fetch from IAPSRDS_C4 into :wk_MbrNm, :wk_LibNm, :wk_LikeDsNm, :wk_MainDsNm; //0033
   exec sql fetch from IAPSRDS_C4 into :wk_MbrNm, :wk_LibNm, :wk_IfsLoc,                 //0033
      :wk_LikeDsNm, :wk_MainDsNm;                                                        //0033

   dow sqlstate = SQL_ALL_OK;
      exec sql
        declare IAPSRDS_C3 cursor for
          select *
          from IAPGMDS
          where DATASTR_NAME = :wk_LikeDsNm
            and DSSPCY       = ' '
            and DSSRCLIB     = :wk_LibNm
            and DSIFSLOC     = :wk_Ifsloc                                                //0033
            and DSPGMNM      = :wk_MbrNm;

      exec sql open IAPSRDS_C3;
      exec sql fetch from IAPSRDS_C3 into :WK_uwdsdtl;

      dow sqlstate = SQL_ALL_OK;
         wk_uwdsdtl.DSNAME = %trim(wk_MainDsNM);
         wk_uwdsdtl.DSBASED = 'LIKEDS';                                                  //TK02

         exec sql
           insert into IAPGMDS (DSSRCLIB,
                                DSSRCFLN,
                                DSPGMNM,
                                DSIFSLOC,                                                //0033
                                DSNAME,
                                DSTYPE,
                                DSOBJV,
                                DSFLOBJV,
                                DSSPCY,
                                DSBASED,
                                DSLENGTH,
                                DSDIMEN,
                                DSFLDNM,
                                DSFLDNMPF,
                                DSFLFR,
                                DSFLTO,
                                DSFLTYP,
                                DSFLSIZ,
                                DSFLDEC,
                                DSBFLDNM,
                                DSQULFLG,
                                DSPREFIX,
                                DSQUALNM,
                                DSFLSPCY,
                                DSFLDRNK,
                                DSORIGIN)
             values(:wk_uwdsdtl.DSSRCLIB,
                    :wk_uwdsdtl.DSSRCFLN,
                    :wk_uwdsdtl.DSPGMNM,
                    :wk_uwdsdtl.DSIFSLOC,                                                //0033
                    :wk_uwdsdtl.DSNAME,
                    :wk_uwdsdtl.DSTYPE,
                    :wk_uwdsdtl.DSOBJV,
                    :wk_uwdsdtl.DSFLOBJV,
                    :wk_uwdsdtl.DSSPCY,
                    :wk_uwdsdtl.DSBASED,
                    :wk_uwdsdtl.DSLENGTH,
                    :wk_uwdsdtl.DSDIMEN,
                    :wk_uwdsdtl.DSFLDNM,
                    :wk_uwdsdtl.DSFLDNMPF,
                    :wk_uwdsdtl.DSFLFR,
                    :wk_uwdsdtl.DSFLTO,
                    :wk_uwdsdtl.DSFLTYP,
                    :wk_uwdsdtl.DSFLSIZ,
                    :wk_uwdsdtl.DSFLDEC,
                    :wk_uwdsdtl.DSBFLDNM,
                    :wk_uwdsdtl.DSQULFLG,
                    :wk_uwdsdtl.DSPREFIX,
                    :wk_uwdsdtl.DSQUALNM,
                    :wk_uwdsdtl.DSFLSPCY,
                    :wk_uwdsdtl.DSFLDRNK,
                    :wk_uwdsdtl.DSORIGIN);

         if SQLSTATE <>  SQL_ALL_OK;
            //log error
         endif;

         exec sql fetch from IAPSRDS_C3 into :wk_uwdsdtl;
      enddo;

      exec sql close IAPSRDS_C3;
      exec sql
    //  fetch from IAPSRDS_C4 into :wk_MbrNm, :wk_LibNm, :wk_LikeDsNm, :wk_MainDsNm;     //0033
        fetch from IAPSRDS_C4 into :wk_MbrNm, :wk_LibNm, :wk_IfsLoc    ,                 //0033
        :wk_LikeDsNm, :wk_MainDsNm;                                                      //0033
   enddo;

   exec sql close IAPSRDS_C4;
   exec sql delete from Qtemp/WKLIKEDSPF;
end-proc;

//---------------------------------------------------------------------------------------//AK12
//IAPSRDTAARA - Procedure to parse CL statement having CL DTAARA commands                //AK12
//---------------------------------------------------------------------------------------//AK12
dcl-proc IAPSRDTAARA export;                                                              //AK12
   dcl-pi *n;                                                                             //AK12
      in_ParmPointer pointer;                                                             //AK12
      in_MbrTyp1     char(10) CONST;                                                      //AK12
   end-pi;                                                                                //AK12
                                                                                          //AK12
   dcl-ds l_ParmDS qualified based(in_ParmPointer);                                       //AK12
      l_String       char(5000);                                                          //AK12
      l_Error        char(10);                                                            //AK12
      l_Repository   char(10);                                                            //AK12
      l_SrcLib       char(10);                                                            //AK12
      l_SrcPf        char(10);                                                            //AK12
      l_SrcMbr       char(10);                                                            //AK12
      l_IfsLoc       char(100);                                                           //0033
      l_RRNStr       packed(6:0);                                                         //AK12
      l_RRNEnd       packed(6:0);                                                         //AK12
   end-ds;                                                                                //AK12
                                                                                          //AK12
   Dcl-S l_ClStatement char(5000)          inz;                                           //AK12
   Dcl-S l_WordsArray  char(120)  dim(100) inz;                                           //AK12
   Dcl-S l_FileKeyPos  char(100)           inz;                                           //AK12
   Dcl-S l_LibName     char(10)            inz;                                           //AK12
   Dcl-S l_DtaAraName  char(10)            inz;                                           //AK12
 //Dcl-S l_Usage       zoned(2:0)          inz;                                     //AK12//0023
   Dcl-S l_Usage       char(10)            inz;                                           //0023
   Dcl-S sl_pos        packed(4:0)         inz;
   Dcl-S br_pos        packed(4:0)         inz;
                                                                                          //AK12
   l_ClStatement   = l_ParmDS.l_String;                                                   //AK12

   if l_ClStatement = *Blanks;
      return;
   endif;
                                                                                          //AK12
   GetWordsInArray(l_ClStatement : l_WordsArray);                                         //AK12
                                                                                          //AK12
   l_FileKeyPos = scanKeyword(' DTAARA(':l_ClStatement);                                  //AK12
   If l_FileKeyPos = *blanks;                                                             //AK12
      l_FileKeyPos = l_WordsArray(2);                                                     //AK12
   EndIf;                                                                                 //AK12
   If %scan('*LDA':l_FileKeyPos) > 0;                                                     //AK12
      Return;                                                                             //AK12
   EndIf;                                                                                 //AK12
   sl_pos = %scan('/':l_FileKeyPos);
   br_pos = %scan('(':l_FileKeyPos);
 //If %scan('/':l_FileKeyPos) > 0;                                               //AJ01   //AK12
   If sl_pos > 1;                                                                         //AJ01
      l_LibName    = %subst(l_FileKeyPos:1:sl_pos-1);                                     //AK12
   // If %scan('(':l_FileKeyPos) > 0;                                            //AJ01   //AK12
      If (br_pos - 1 - sl_pos) > 0;                                                       //AJ01
         l_DtaAraName = %subst(l_FileKeyPos:                                              //AK12
                        sl_pos+1:                                                         //AK12
                        br_pos-1-sl_pos);                                                 //AK12
  //  ElseIf %scan('*ALL':l_FileKeyPos) > 0;                                     //AJ01   //AK12
      ElseIf %scan('*ALL':l_FileKeyPos) > 0                                               //AJ01
             and (%scan('*ALL':l_FileKeyPos) - 1 - sl_pos) > 0;                           //AJ01
         l_DtaAraName = %subst(l_FileKeyPos:                                              //AK12
                        sl_pos+1:                                                         //AK12
                        %scan('*ALL':l_FileKeyPos) - 1 -                                  //AK12
                        sl_pos);                                                          //AK12
      Else;                                                                               //AK12
         l_DtaAraName = %subst(l_FileKeyPos:                                              //AK12
                        sl_pos+1);                                                        //AK12
      EndIf;                                                                              //AK12
   Else;                                                                                  //AK12
      l_LibName    = *Blanks;                                                             //AK12
   // If %scan('(':l_FileKeyPos) > 0;                                           //AJ01    //AK12
      If br_pos > 1;                                                                      //AJ01
         l_DtaAraName = %subst(l_FileKeyPos:1:br_pos-1);                                  //AK12
   // ElseIf %scan('*ALL':l_FileKeyPos) > 0;                                    //AJ01    //AK12
      ElseIf %scan('*ALL':l_FileKeyPos) > 1;                                              //AJ01
         l_DtaAraName = %subst(l_FileKeyPos:1:                                            //AK12
                        %scan('*ALL':l_FileKeyPos)-1);                                    //AK12
      Else;                                                                               //AK12
         l_DtaAraName = %subst(l_FileKeyPos:                                              //AK12
                        sl_pos+1);                                                        //AK12
      EndIf;                                                                              //AK12
   EndIf;                                                                                 //AK12
   If l_WordsArray(1) = 'CRTDTAARA' or                                                    //AK12
      l_WordsArray(1) = 'DSPDTAARA' or                                                    //AK12
      l_WordsArray(1) = 'RTVDTAARA';                                                      //AK12
    //l_Usage         = 1;                                                          //AK12//0023
      l_Usage         = 'I';                                                              //0023
   ElseIf l_WordsArray(1) = 'CHGDTAARA' or                                                //AK12
          l_WordsArray(1) = 'DLTDTAARA';                                                  //AK12
    //l_Usage         = 4;                                                          //AK12//0023
      l_Usage         = 'U';                                                              //0023
   EndIf;                                                                                 //AK12
                                                                                          //AK12
   //Write source intermediate reference detail file                                     //AK12
   WrtSrcIntRefF(l_ParmDS.l_SrcLib                                                        //AK12
                :l_ParmDS.l_SrcPf                                                         //AK12
                :l_ParmDS.l_SrcMbr                                                        //AK12
                :l_ParmDS.l_IfsLoc                                                        //0033
                :in_MbrTyp1                                                               //AK12
                :l_DtaAraName                                                             //AK12
                :'*DTAARA'                                                                //AK12
                :l_LibName                                                                //AK12
                :l_Usage                                                                  //AK12
                :'CLP'                                                                    //AK12
                );                                                                        //AK12
   return;                                                                                //AK12
end-proc;                                                                                 //AK12

//---------------------------------------------------------------------------------------//AK11
//WrtSrcIntRefF - Write CL Source Intermediate Reference File                            //AK11
//---------------------------------------------------------------------------------------//AK11
//dcl-proc WrtSrcIntRefF;                                                          //AK11 //0018
dcl-proc WrtSrcIntRefF Export;                                                            //0018
  dcl-pi *n;                                                                              //AK11
    in_MBRLIB     char(10)   const;                                                       //AK11
    in_MBRSRC     char(10)   const;                                                       //AK11
    in_MBRNAM     char(10)   const;                                                       //AK11
    in_IFSLOC     char(100)  const;                                                       //0033
    in_MBRTYP     char(10)   const;                                                       //AK11
    in_REFOBJ     char(11)   const;                                                       //AK11
    in_REFOTYP    char(11)   const;                                                       //AK11
    in_REFOLIB    char(11)   const;                                                       //AK11
  //in_REFOUSG    Zoned(2:0) const;                                                 //AK11//0023
    in_REFOUSG    Char(10)   const;                                                       //0023
    in_RFILEUSG   char(10)   const;                                                       //AK11
  end-pi;                                                                                 //AK11
                                                                                          //AK11
  Exec Sql                                                                                --AK11
  // Insert into IASRCINTPF(IAMBRLIB, IAMBRSRC,  IAMBRNAM,  IAMBRTYP,                     --AK110033
     Insert into IASRCINTPF(IAMBRLIB, IAMBRSRC,  IAMBRNAM,  IAMBRTYP, IAMIFSLC,           --0033
                            IAREFOBJ, IAREFOTYP, IAREFOLIB, IAREFOUSG,                    --AK11
                            IARFILEUSG)                                                   --AK11
                     VALUES(trim(:in_MBRLIB),                                             --AK11
                            trim(:in_MBRSRC),                                             --AK11
                            trim(:in_MBRNAM),                                             --AK11
                            trim(:in_MBRTYP),                                             --AK11
                            trim(:in_IFSLOC),                                             --0033
                            trim(:in_REFOBJ),                                             --AK11
                            trim(:in_REFOTYP),                                            --AK11
                            trim(:in_REFOLIB),                                            --AK11
                          //:in_REFOUSG,                                            --AK11--0023
                            trim(:in_REFOUSG),                                            --0023
                            trim(:in_RFILEUSG));                                          --AK11
                                                                                          //AK11
  if SQLSTATE <>  SQL_ALL_OK;                                                             //AK11
    //log error                                                                          //AK11
  endIf;                                                                                  //AK11
                                                                                          //AK11
  return;                                                                                 //AK11
end-Proc;                                                                                 //AK11

//-----------------------------------------------------------------                      //SK02
//IASNDUSRMSG - PARSE CL commands that sends messages to users                          //SK02
//-----------------------------------------------------------------                      //SK02
dcl-proc IASNDUSRMSG export;                                                             //SK02
   dcl-pi *n;                                                                            //SK02
      in_ParmPointer pointer;                                                            //SK02
      CmdName        char(10);                                                           //SK02
   end-pi;                                                                               //SK02
                                                                                         //SK02
   //DS declarations                                                                    //SK02
   dcl-ds IAVARRELDS extname('IAVARREL') inz;                                            //SK02
   end-ds;                                                                               //SK02
                                                                                         //SK02
   dcl-ds w_ParmDS qualified based(in_ParmPointer);                                      //SK02
      w_String     char(5000);                                                           //SK02
      w_Error      char(10);                                                             //SK02
      w_Repository char(10);                                                             //SK02
      w_SrcLib     char(10);                                                             //SK02
      w_SrcPf      char(10);                                                             //SK02
      w_SrcMbr     char(10);                                                             //SK02
      w_RRNStr     packed(6:0);                                                          //SK02
      w_RRNEnd     packed(6:0);                                                          //SK02
   end-ds;                                                                               //SK02
                                                                                         //SK02
   Dcl-Ds WordsArray Qualified dim(100);                                                 //SK02
      Element char(120) inz;                                                             //SK02
      Pos     Packed(6:0) Inz;                                                           //SK02
   End-ds;                                                                               //SK02
                                                                                         //SK02
   //Stand alone declarations                                                           //SK02
   Dcl-S ClStatement    char(5000)          inz;                                         //SK02
   Dcl-S No_of_elem     packed(4:0) inz;                                                 //SK02
   Dcl-S arrayElem      packed(4:0) inz;                                                 //SK02
   Dcl-S SeqNo          packed(4:0) inz(0);                                              //SK02
   Dcl-S ClStm          char(5000);                                                      //SK02
   Dcl-S strPos         zoned(4:0) inz(1);                                               //SK02
   Dcl-S EndPos         zoned(4:0) inz(1);                                               //SK02
   Dcl-S index          zoned(3:0) inz;                                                  //SK02
   Dcl-S inQuoteFlg     char(1)    inz;                                                  //SK02
                                                                                         //SK02
   ClStatement = %TRIM(w_ParmDS.w_String);                                               //SK02
                                                                                         //SK02
   //Split the command into word array                                                  //SK02
   Exsr GetArray;                                                                        //SK02
                                                                                         //SK02
   //get no of NON BLANK elem in the array                                              //SK02
   No_of_elem = %lookup(' ': WordsArray(*).Element);                                     //SK02
                                                                                         //SK02
   For arrayElem = 1 to No_of_elem - 1;                                                 //SK02
      //Retrieve only the Variables or file fields.                                     //SK02
      If %subst( %trim(WordsArray(arrayElem).Element) : 1 : 1) = '&';                    //SK02
                                                                                         //SK02
         //Check the field or var name is inside a string. If yes do not process.       //SK02
         Clear inQuoteFlg;                                                               //SK02
         inquote(ClStatement : WordsArray(arrayElem).Pos :inQuoteFlg);                   //SK02
                                                                                         //SK02
         If inquoteFlg = 'Y';                                                            //SK02
           //Do nothing                                                                 //SK02
         Else;                                                                           //SK02
            SeqNo +=  1;                                                                 //SK02
            REFACT1 = %trim(WordsArray(arrayElem).Element);                              //SK02
            exec sql                                                                     //SK02
               Insert into IAVARREL (RESRCLIB,                                           //SK02
                           RESRCFLN,                                                     //SK02
                           REPGMNM,                                                      //SK02
                           RESEQ,                                                        //SK02
                           RERRN,                                                        //SK02
                           REOPC,                                                        //SK02
                           REFACT1)                                                      //SK02
               values(trim(:w_ParmDS.w_SrcLib),                                          //SK02
                     trim(:w_ParmDS.w_SrcPf),                                            //SK02
                     trim(:w_ParmDS.w_SrcMbr),                                           //SK02
                     trim(:SeqNo),                                                       //SK02
                     trim(:w_ParmDS.w_RRNStr),                                           //SK02
                     trim(:CmdName),                                                     //SK02
                     trim(:REFACT1));                                                    //SK02
                                                                                         //SK02
         Endif;                                                                          //SK02
      Endif;                                                                             //SK02
   Endfor;                                                                               //SK02
   Return;                                                                               //SK02
                                                                                         //SK02
   Begsr GetArray;                                                                       //SK02
                                                                                         //SK02
     //Split the CL statement into an array of words (find space and split)             //SK02
     clstm = %xlate('()' :'  ' :ClStatement);                                            //SK02
        DoW EndPos <> 0 and StrPos <> 0;                                                 //SK02
           StrPos = %check(' ' :Clstm :EndPos);                                          //SK02
           If StrPos <> 0;                                                               //SK02
              EndPos = %scan(' ' :ClStm :StrPos);                                        //SK02
          //  If EndPos <> 0;                                                   //AJ01   //SK02
              If EndPos <> 0 and EndPos > StrPos ;                                       //AJ01
                 Index += 1;                                                             //SK02
                 WordsArray(Index).Element = %subst(ClStm :StrPos:EndPos - StrPos);      //SK02
                 WordsArray(Index).Pos     = StrPos;                                     //SK02
              endif;                                                                     //SK02
           endif;                                                                        //SK02
        enddo;                                                                           //SK02
   Endsr;                                                                                //SK02
   End-proc;                                                                             //SK02

//-----------------------------------------------------------------
//squeezeString - Squeezes out multiple spaces
//-----------------------------------------------------------------
DCL-PROC squeezeString EXPORT;
   DCL-PI squeezeString VARCHAR(65535);
   //argInBytes VARCHAR(65535) const;                                                         //0002
     argInBytes VARCHAR(65535) const options(*trim);                                          //0002
   END-PI;

   DCL-S posi ZONED(5);
   DCL-S inBytes VARCHAR(65535);
   DCL-S outBytes VARCHAR(65535);

   //inBytes  = %trim(argInBytes);                                                            //0002
   inBytes  = argInBytes;                                                                     //0002
   outBytes = *BLANKS;
   posi     = %scan(' ':inBytes);

   dow posi > 0;
      outBytes = %trim(outBytes) + ' ' + %subst(inBytes:1:posi);
      inBytes  = %trim(%subst(inBytes:posi));

      if (inBytes = *BLANKS);
        leave;
      else;
      endif;

      posi = %scan(' ':inBytes);
   enddo;

   if (inBytes = *BLANKS);
   else;
      outBytes = %trim(outBytes) + ' ' + %trim(inBytes);
   endif;

   return %trim(outBytes);
END-PROC;

//-----------------------------------------------------------------                       //SG01
//WriteProceduredetail : Procedure to writethe record in procedure                       //SG01
//                       Reference file IAPROCINFO                                       //0019
//-----------------------------------------------------------------                       //SG01
dcl-proc WriteProceduredetail export;                                             //0013  //SG01
  dcl-pi *n;                                                                              //SG01
 // IN_SRCMBR     char(10)   const;                                                 0033  //SG01
 // IN_SRCSPF     char(10)   const;                                                 0033  //SG01
 // IN_SRCLIB     char(10)   const;                                                 0033  //SG01
    IN_uWSrcDtl   likeds(uWSrcDtl);                                                       //0033
    IN_TYPE       char(10)   const;                                                       //SG01
    IN_SeqNum     packed(6:2) const;                                              //0013  //SG01
    IN_RRNS       packed(6:0) const;                                                      //SG01
    IN_ProcNam    char(80)   const options(*trim) ;                                      //0020
    In_ProcTyp    char(2)    const;                                                       //SG01
    In_procSig    char(1)    const;                                                       //SG01
  end-pi;                                                                                 //SG01

  uWSrcDtl = in_uWSrcDtl;                                                                 //0033

     exec sql                                                                             //SG01
       INSERT INTO  IAPROCINFO (MEMBER_NAME,                                             //0019
                              SOURCE_FILE,
                              MEMBER_LIBRARY,
                              IFS_LOCATION ,                                             //0033
                              MEMBER_TYPE,
                              SEQUENCE_NUMBER,
                              RRN_NUMBER,
                              PROCEDURE_NAME,
                              PROCEDURE_TYPE,
                              EXPORT_Or_IMPORT,
                              CREATED_BY,
                              UPDATED_BY)
                       VALUES(:IN_SRCMBR,
                              :IN_SRCSPF,
                              :IN_SRCLIB,
                              :IN_IFSLOC,                                                //0033
                              :IN_TYPE,
                              :IN_SeqNum,
                              :IN_RRNS,
                              :IN_ProcNam,
                              :In_ProcTyp,
                              :In_procSig,
                               user,
                               user);

  if SQLSTATE <>  SQL_ALL_OK;                                                                 //SG01
    // log error                                                                              //SG01
  endIf;                                                                                      //SG01

  return;                                                                                     //SG01
End-Proc;                                                                                     //SG01

//-------------------------------------------------------------------------------------- //
//IAPSRUSRCMD: User Defined command reference creation in IASRCINTF
//-------------------------------------------------------------------------------------- //
dcl-proc IAPSRUSRCMD export;                                                             //0014
  dcl-pi *n;                                                                             //0014
     in_ParmPointer pointer;                                                             //0014
     in_MbrTyp1     char(10) CONST ;                                                     //0014
  end-pi;                                                                                //0014

  dcl-ds w_ParmDS qualified based(in_ParmPointer);                                       //0014
     w_String     char(5000);                                                            //0014
     w_Error      char(10);                                                              //0014
     w_Repository char(10);                                                              //0014
     w_SrcLib     char(10);                                                              //0014
     w_SrcPf      char(10);                                                              //0014
     w_SrcMbr     char(10);                                                              //0014
     w_IfsLoc     char(100);                                                             //0033
     w_RRNStr     packed(6:0);                                                           //0014
     w_RRNEnd     packed(6:0);                                                           //0014
  end-ds;                                                                                //0014

  dcl-s i       packed(3:0);                                                             //0014
  dcl-s strPos  packed(3:0);                                                             //0030
  dcl-s endPos  packed(3:0);                                                             //0030
  dcl-s firstTerm char(21);                                                              //0030
  dcl-s w_ClStatement  char(5000) inz;                                                   //0014
  dcl-s w_WordsArray  char(120)  dim(100) inz;                                           //0014
  dcl-s w_CmdLib char(10) inz;                                                           //0014
  dcl-s w_CmdLibQ char(10) inz;                                                          //0014
  dcl-s w_UsrCmd char(10) inz;                                                           //0014
  dcl-s w_Qualified char(1) inz('N');                                                    //0014

  w_ClStatement = w_ParmDS.w_String;                                                     //0014
  if w_ClStatement = *Blanks;                                                            //0014
     return;                                                                             //0014
  endif;                                                                                 //0014

  //If there is a user command in the line, it will be the first term.                  //0030
  //No need to go through all the other words.                                          //0030
  strPos = %check(' ':w_ClStatement:1);                                                  //0030
  if strPos > 0;                                                                         //0030
     endPos = %scan(' ':w_ClStatement:strPos);                                           //0030
     firstTerm= %subst(w_ClStatement:strPos:(endPos-strPos));                            //0030
  endif;                                                                                 //0030

  w_Qualified = 'N';                                                                     //0014
  if %scan('/':firstTerm) > 0;                                                           //0030
     w_CmdLibQ = %subst(firstTerm:1:%scan('/': firstTerm)-1);                            //0030
     w_UsrCmd  = %subst(firstTerm:%scan('/': firstTerm)+1:                               //0030
                         %len(firstTerm)-%scan('/': firstTerm));                         //0030
     w_Qualified = 'Y';                                                                  //0030
  else;                                                                                  //0030
     w_UsrCmd = %trim(firstTerm);                                                        //0030
  endif;                                                                                 //0030

  exec sql                                                                               //0014
    select odlbnm into :w_CmdLib                                                         //0014
      from iDspOBJD                                                                      //0014
      where odobnm = :w_UsrCmd                                                           //0014
        and odobtp = '*CMD';                                                             //0014

  if sqlcode = 0;                                                                        //0014
     if w_qualified = 'Y';                                                               //0014
        w_CmdLib = w_CmdLibQ;                                                            //0014
     endif;                                                                              //0014
                                                                                         //0014
     //Write source intermediate reference detail file
     WrtSrcIntRefF(w_ParmDS.w_SrcLib                                                     //0014
                   :w_ParmDS.w_SrcPf                                                     //0014
                   :w_ParmDS.w_SrcMbr                                                    //0014
                   :w_ParmDS.w_IfsLoc                                                    //0033
                   :in_MbrTyp1                                                           //0014
                   :w_UsrCmd                                                             //0014
                   :'*CMD'                                                               //0014
                   :w_CmdLib                                                             //0014
                   :'I'                                                                  //0014
                   :'CLP'                                                                //0014
                    );                                                                   //0014
  endif;                                                                                 //0014

  return;                                                                                //0014
                                                                                         //0014
end-proc;                                                                                //0014
