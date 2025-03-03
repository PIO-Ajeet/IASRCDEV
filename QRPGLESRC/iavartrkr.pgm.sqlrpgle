**free
      //%METADATA                                                      *
      // %TEXT Variable tracking                                       *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------- //
//Created By  : Programmers.io @ 2020                                                   //
//Created Date: 2020/01/01                                                              //
//Developer   : Programmers.io                                                          //
//Description : This program logs FFWU and VWU variables into IAVARTRK (Variable Track- //
//              ing detail file).                                                       //
//Procedure Log:                                                                        //
//------------------------------------------------------------------------------------- //
//Procedure Name           | Procedure Description                                      //
//-------------------------|----------------------------------------------------------- //
//FormatField              |                                                            //
//------------------------------------------------------------------------------------- //
//                                                                                      //
//MODIFICATION LOG:                                                                     //
//------------------------------------------------------------------------------------- //
//Date-DMY| Mod_ID | Developer  | Case and Description                                  //
//--------|--------|------------|------------------------------------------------------ //
//18/05/23|  0001  |Pranav Joshi| Segrigated the join queries that fatches field        //
//        |        |            | attribute for DDS source and DDS field used in program//
//21/08/23|  0002  |Himanshu    | In case of DCLVAR, Added the condition to check       //
//        |        |Gehlot      | Factor 2 value for LIKE keyword Used in Variable      //
//        |        |            | Declaration. Task#:94                                 //
//17/11/23|  0003  | Akshay     | Refresh Metadata : Duplicate records coming in        //
//        |        |  Sopori    | IAVARTRK file. #378                                   //
//20/12/23|  0004  | Akshay     | Variables interactions not getting captured for PRTF  //
//        |        |  Sopori    | & DSPF. #369                                          //
//21/12/23|  0005  | Venkatesh  | CLP variables are showing incorrect references when   //
//        |        |   Battula  |  IAVARREL.RERESULT field is blank. [Task: #497]       //
//26/12/23|  0006  | Akshay     | Refresh: IAVARTRK not reflecting changes if file is   //
//        |        |  Sopori    | compiled during refresh. #448                         //
//05/01/24|  0007  | Venkatesh  | Added logic Get variable Surrogate Id from IAPGMFILES //
//        |        |   Battula  |    [Task: #507]                                       //
//10/01/24|  0008  | Naresh S   | Write CLP variables into IASRCVARID file  without '&' //
//        |        |            | symbol in Variable name.[Task #508]                   //
//        |        |            | Ex: &VAR (before fix) , VAR (after fix)               //
//08/01/24|  0009  | Akhil      | Bug fix to avoid clearing 'To variable' ID if the     //
//        |        |  Kallur    | field is in either a 'DBF' or 'DSPF' or 'PRTF'. [#504]//
//07/02/24|  0010  | Pranav     | Avoid searching for Variable ID for blank variable    //
//        |        |            | name                                                  //
//19/09/23|  0011  |G Jayasimha | When RPGLE Fixed Format Keyword is used in RPGLE Free //
//        |        |            | Format (Eg: ADD),incorrect information is displayed in//
//        |        |            | IA (Where File Field is used).                        //
//        |        |            | Task#:226                                             //
//06/06/24|  0012  |Saumya      | Rename AIEXCTIMR to IAEXCTIMR [Task #262]             //
//05/07/24|  0013  |Akhil K.    | Renamed AIERRBND, AICERRLOG, AIDERRLOG and AISQLDIAGNO//
//        |        |            | STIC with IA*                                         //
//16/09/24|  0014  |Gopi Thorat | Rename IACPYBDTL file fields wherever used due to     //
//        |        |            | table changes. [Task#940]                             //
//22/01/25|  0015  |Vamsi       | IAPGMFILES is restructured.So,updated the columns     //
//        |        |Krishna2    | accordingly.(Task#63)                                 //
//16/09/24|  0016  |Rishab K.   | Program details for file fields used in CL program    //
//        |        |            | Task#686 [Remove changes done under task# 507]        //
//20/08/24|  0017  |Sabarish    | IFS Member Parsing Upgrade [Task #833]
//------------------------------------------------------------------------------------- //
ctl-opt CopyRight('Copyright @ Programmers.io © 2022');
ctl-opt Option(*NoDebugIo:*SrcStmt:*NoUnRef);
ctl-opt DftActgrp(*no);
ctl-opt bndDir('IAERRBND');                                                              //0013

//------------------------------------------------------------------------------------- //
//Standalone Variables                                                                  //
//------------------------------------------------------------------------------------- //
dcl-s WKEXIST       char(1)     inz('N');
dcl-s flag          char(1)     inz;
dcl-s w_result      char(80)    inz;
dcl-s w_varname     char(80)    inz;
dcl-s w_varnamex    char(80)    inz;
dcl-s w_filepfx     char(10)    inz;
dcl-s w_mbr1        char(10)    inz;
dcl-s w_mbr2        char(10)    inz;
dcl-s w_vartrktyp   char(4)     inz;
dcl-s Fromvar       char(80)    inz;
dcl-s Tovar         char(80)    inz;
dcl-s slib          char(10)    inz;
dcl-s smbrnm        char(10)    inz;
dcl-s LibNm         char(10)    inz;
dcl-s ssrcpf        char(10)    inz;
dcl-s Filenm        char(10)    inz;
dcl-s Reflib        char(10)    inz;
dcl-s Reffile       char(10)    inz;
dcl-s savLibNam     char(10)    inz;
dcl-s savSrcFil     char(10)    inz;
dcl-s savMbrNam     char(10)    inz;
dcl-s wksrcfil      char(10)    inz;
dcl-s wksrclib      char(10)    inz;
dcl-s wksrcmbr      char(10)    inz;
dcl-s wkfldnam      char(10)    inz;
dcl-s uppgm_name    char(10)    inz;
dcl-s uplib_name    char(10)    inz;
dcl-s upsrc_name    char(10)    inz;
dcl-s Wk_CsrName    char(50)    inz;

dcl-s W_SRCMBRID    zoned(9)    inz;
dcl-s W_VARFRMID    zoned(9)    inz;
dcl-s W_VARTOID     zoned(9)    inz;
dcl-s W_VARPFXID    zoned(9)    inz;
dcl-s ArrnextAlloc  zoned(5)    inz;
dcl-s ArrAlloc      zoned(5)    inz(500);
dcl-s W_TEMPFRMID    zoned(9)    inz;

dcl-s srrn          packed(6:0) inz;
dcl-s w_rrn1        packed(6:0) inz;
dcl-s w_rrn2        packed(6:0) inz;
dcl-s Wk_DataStructLen packed(3:0) inz;

dcl-s VarRows            uns(5) inz;
dcl-s VarIndx            uns(5) inz;
dcl-s VarRowsFetched     uns(5) inz;
dcl-s dsinfoRowsFetched  uns(5) inz;
dcl-s dsfldRowsFetched   uns(5) inz;
dcl-s DsRows             uns(5) inz;
dcl-s FldRows            uns(5) inz;
dcl-s Dsindx             uns(5) inz;
dcl-s fldindx            uns(5) inz;
dcl-s C1_RowsFetched     uns(5) inz;
dcl-s C2_RowsFetched     uns(5) inz;
dcl-s C1_noOfRows        uns(5) inz;
dcl-s C2_noOfRows        uns(5) inz;
dcl-s C1_idx             uns(5) inz;
dcl-s C2_idx             uns(5) inz;
dcl-s index              uns(5);
dcl-s ResultIndex        uns(5);

dcl-s rcdFound      ind         inz;
dcl-s W_srrnfound   ind         inz;
dcl-s ResNotBlk     ind         inz;
dcl-s rowFound      ind         inz('0');
dcl-s wkSqlText     varchar(5000) inz;                                                   //0003

dcl-s uptimestamp   Timestamp;

dcl-s PArray Pointer inz(*Null);

//------------------------------------------------------------------------------------- //
//Constant Variables
//------------------------------------------------------------------------------------- //
dcl-c TRUE            '1';
dcl-c FALSE           '0';
dcl-c UP              'ABCDEFGHIFKLMNOPQRSTUVWXYZ';
dcl-c LO              'abcdefghijklmnopqrstuvwxyz';
dcl-c squote          Const('''');

//------------------------------------------------------------------------------------- //
//Datastructure Definitions
//------------------------------------------------------------------------------------- //
dcl-ds IAVARRELDS qualified inz;
   SrcMbrID Zoned(9);
   srclib   char(10);
   srcfln   char(10);
   pgmnam   char(10);
   rrnds    packed(6:0);
   result   char(80);
   fact1    char(80);
   fact2    char(80);
   opcnm    char(10);
end-ds;

dcl-ds DsFldARR qualified  dim(999);
    dsfld char(128);
end-ds;

dcl-ds IAVARRELARR qualified dim(999);
   SrcMbrID Zoned(9);
   srclib   char(10);
   srcfln   char(10);
   pgmnam   char(10);
   rrnds    packed(6:0);
   result   char(80);
   fact1    char(80);
   fact2    char(80);
   opcnm    char(10);
end-ds;

dcl-ds DsFILEPFXARR qualified dim(999);
  w_filepfx char(10);
end-ds;

dcl-ds VarArrDs Qualified Dim(1000) inz;
   FromVar like(FromVar) ;
   ToVar   like(ToVar)   ;
   Libnm   like(Libnm)   ;
   Filenm  like(Filenm)  ;
   Reflib  like(Reflib)  ;
   reffile like(reffile) ;
end-ds;

dcl-ds VarSurID qualified dim(32000) based(PArray);
   Ar_Varnam char(80);
   Ar_SurID  zoned(9);
end-ds;

dcl-ds iaMetaInfo dtaara len(62);                                                        //0003
   runMode char(7) pos(1);                                                               //0003
end-ds;                                                                                  //0003

//------------------------------------------------------------------------------------- //
//Prototype Definitions
//------------------------------------------------------------------------------------- //
dcl-pr IAEXCTIMR extpgm('IAEXCTIMR');                                                    //0012
   *n Char(10) Const;
   *n Char(10);
   *n Char(10);
   *n Char(10) Const;
   *n Char(10);
   *n Char(10);
   *n Char(10);
   *n Char(100) Const;                                                                   //0017
   *n Char(10) Const;
   *n Timestamp;
   *n Char(6) Const;
end-pr;

//------------------------------------------------------------------------------------- //
//Copybook definitions
//------------------------------------------------------------------------------------- //
/copy 'QCPYSRC/iaderrlog.rpgleinc'

//------------------------------------------------------------------------------------- //
//Mainline Programming
//------------------------------------------------------------------------------------- //
exec sql
  set option commit    = *none,
             naming    = *sys,
             usrprf    = *user,
             dynusrprf = *user,
             closqlcsr = *endmod;

Eval-corr uDpsds = wkuDpsds;

//Log process start time
uptimeStamp = %Timestamp();
CallP IAEXCTIMR('BLDMTADTA' :udpsds.ProcNme : udpsds.Lib : '*PGM' :                      //0012
//0017 upsrc_name : uppgm_name : uplib_name : ' ' : uptimeStamp : 'INSERT');
upsrc_name : uppgm_name : uplib_name : ' ' : ' ' : uptimeStamp : 'INSERT');              //0017

//------------------------------------------------------------------------------------- //
//Cursor Declarations
//------------------------------------------------------------------------------------- //
                                                                                         //0003
In *lock iaMetaInfo;                                                                     //0003

if runMode = 'REFRESH';                                                                  //0003
   clrRefreshData();                                                                     //0003

   wkSqlText = 'With C1 As ( ' +                                                         //0006
               'Select  B.MBR_SUR_ID, A.RESRCLIB, A.RESRCFLN, A.REPGMNM, '     +         //0006
               'A.RERRN, A.RERESULT,   A.REFACT1,  A.REFACT2,  A.REOPC '       +         //0006
               'From IAVARREL A Join '                                         +         //0006
               'IASRCMBRID B On B.MEMBER_LIB  = A.RESRCLIB And '               +         //0006
               'B.MBR_SRC_PF  = A.RESRCFLN And B.MEMBER_NAME = A.REPGMNM '     +         //0006
               'Join IAREFOBJF REF ON ( A.RESRCLIB = REF.IAMEMLIB '            +         //0006
               'And A.RESRCFLN = REF.IASRCPF And A.REPGMNM = REF.IAMEMNAME ) ' +         //0006
               'Or (REF.IAOBJNAME = A.REPGMNM '                                +         //0006
               'And REF.IAOBJLIB = a.RESRCLIB '                                +         //0006
               'And REF.IAOBJATTR IN (''PF'', ''LF'', ''DSPF'', ''PRTF''))) '  +         //0006
               'Select  * from C1 Order By MBR_SUR_ID, RERRN';                           //0006

else;                                                                                    //0003

   wkSqlText = 'With C1 As ( ' +                                                         //0003
               'Select  B.MBR_SUR_ID, A.RESRCLIB, A.RESRCFLN, A.REPGMNM, ' +             //0003
               'A.RERRN, A.RERESULT,   A.REFACT1,  A.REFACT2,  A.REOPC ' +               //0003
               'From IAVARREL A ' +                                                      //0003
               'Join IASRCMBRID B On B.MEMBER_LIB  = A.RESRCLIB And ' +                  //0003
               'B.MBR_SRC_PF  = A.RESRCFLN And B.MEMBER_NAME = A.REPGMNM ) ' +           //0003
               'Select  * from C1 Order By MBR_SUR_ID, RERRN';                           //0003
endif;                                                                                   //0003

exec sql prepare stmt1 from :wkSqlText  ;                                                //0003
exec sql declare IAVARTRKR_C1 cursor for stmt1 ;                                         //0003

//------------------------------------------------------------------------------------- //
//Main Processing
//------------------------------------------------------------------------------------- //

//Allocate the memeory for the array
PArray   = %alloc(ArrAlloc * %size(VarSurID));
Index = 1;
ArrnextAlloc = ArrAlloc;

//Track references of data structure and subfields
clear w_varname;

//Clear the saved member detail
savLibNam = *blanks;
savSrcFil = *blanks;
savMbrNam = *blanks;

//Track the references of variables used in program
trackVariableRefrences();

//Log process end time
UPTimeStamp = %Timestamp();
CallP IAEXCTIMR('BLDMTADTA' :udpsds.ProcNme : udpsds.Lib : '*PGM' :                      //0012
upsrc_name :
//0017 uppgm_name : uplib_name : ' ' : uptimeStamp : 'UPDATE');
uppgm_name : uplib_name : ' ' : ' ' : uptimeStamp : 'UPDATE');                           //0017

//Deallocate the memeory
Dealloc PArray;

*inlr = *on;
return;

/copy 'QCPYSRC/iacerrlog.rpgleinc'

//------------------------------------------------------------------------------------- //
//trackVariableRefrences: Track variable references
//------------------------------------------------------------------------------------- //
dcl-proc trackVariableRefrences;

   exec sql open IAVARTRKR_C1;
   if sqlCode = CSR_OPN_COD;
      exec sql close IAVARTRKR_C1;
      exec sql open  IAVARTRKR_C1;
   endif;

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Open_IAVARREL_IAVARTRKR_C1';
      IaSqlDiagnostic(uDpsds);                                                           //0013
   endif;

   if sqlCode = successCode;

      //Get member surrogate id
      C1_noOfRows = %elem(IaVarRelArr);
      Wk_CsrName = 'IAVARTRKR_C1';
      //Fetch records from IAVARTRKR_C1 cursor.
      rowFound = fetchRecordsfromCursor();

      dow rowFound;

         for C1_idx = 1 to C1_RowsFetched;
            w_vartrktyp = 'VWU';
            IaVarRelDs = IaVarRelArr(C1_idx);
            w_rrn1            = iaVarRelDs.rrnDs;
            w_mbr1            = iaVarRelDs.pgmnam;

            If w_rrn1 <> w_rrn2 or w_mbr2 <> w_mbr1;
               Clear W_VARTOID;
               Clear ResNotBlk;
            Endif;

            //Get member surrogate id
            if savLibNam <> iaVarRelDs.srclib or savSrcFil <> iaVarRelDs.srcfln
               or savMbrNam <> iaVarRelDs.pgmnam;

               savLibNam = iaVarRelDs.srclib;
               savSrcFil = iaVarRelDs.srcfln;
               savMbrNam = iaVarRelDs.pgmnam;

               AllocArray();

               W_SRCMBRID = iaVarRelDs.SrcMbrID;

            endif;

            select;
               when  iaVarRelDs.opcnm = 'DCLVAR';
                  W_VARFRMID = GetSurID(iaVarRelDs.fact1 :
                                        iaVarRelDs.srclib :
                                        iaVarRelDs.srcfln :
                                        iaVarRelDs.pgmnam);

                  if iaVarRelDs.fact2 <> *blanks;                                        //0002
                     W_VARTOID = GetSurID(iaVarRelDs.fact2 :                             //0002
                                          iaVarRelDs.srclib :                            //0002
                                          iaVarRelDs.srcfln :                            //0002
                                          iaVarRelDs.pgmnam);                            //0002
                  else;                                                                  //0002
                     W_VARTOID =  W_VARFRMID ;                                           //0002
                  endif;                                                                 //0002

                  if W_VARFRMID <> 0 and W_VARTOID <> 0;
                     exec sql
                        insert into IAVARTRK (VARTRKTYP,
                                             SRCMBRID,
                                             SRCRRN,
                                             VARFRMID,
                                             VARTOID,
                                             VARLVL,
                                             VARREF)
                          values(:w_vartrktyp,
                                 :W_SRCMBRID ,
                                 :IAVARRELDS.RRNDS,
                                 :W_VARFRMID ,
                                 :W_VARTOID ,
                                 0,
                                 ' ');
                     if sqlCode < successCode;
                        uDpsds.wkQuery_Name = 'Insert_2_IAVARTRK';
                        IaSqlDiagnostic(uDpsds);                                         //0013
                     endif;

                  endif;

               //Is it datastructure ?
               when iaVarRelDs.opcnm ='DCL-DS';
                  w_vartrktyp = 'VWU';
                  if iaVarRelDs.result = *blanks;
                     //Retriving the subrougate id and add the mapping info of DS
                     //in the IAVARTRK file.
                     clear w_VarFrmID;
                     clear W_TempFrmID;
                     clear w_VarToID;
                     if iaVarRelDs.fact1 <> *blanks;                                     //0011
                        W_TempFrmID = GetSurID(iaVarRelDs.fact1 :
                                               iaVarRelDs.srclib :
                                               iaVarRelDs.srcfln :
                                               iaVarRelDs.pgmnam );
                     EndIf;                                                              //0011
                     w_VarFrmID = W_TempFrmID;
                     w_VarToID = w_VarFrmID;
                     //DS Defined with LIKEDS?
                     if iaVarRelDs.fact2 <> *blanks;
                        w_VarToID = GetSurID(iaVarRelDs.fact2 :
                                             iaVarRelDs.srclib :
                                             iaVarRelDs.srcfln :
                                             iaVarRelDs.pgmnam );
                     endif ;
                  //For first time DS to DS relation From and To ID are same
                  //in else part DS to subfield relation so To ID is different
                  else;
                     clear w_VarToID;
                     w_VarFrmID = W_TempFrmID;
                     if iaVarRelDs.fact1 <> *blanks;                                     //0011
                        w_VarToID =  GetSurID(iaVarRelDs.fact1 :
                                              iaVarRelDs.srclib :
                                              iaVarRelDs.srcfln :
                                              iaVarRelDs.pgmnam );
                     endif;                                                              //0011
                     if w_VarToID = 0 ;
                        w_varnamex = iaVarRelDs.fact1;
                        exsr Handle_Prefix;
                        w_VarToID = W_VARPFXID;
                     endif ;
                  endif;
                  Get_Rec_IAVARTRK();

               //Is it database field from PF/LF?
           //  when iaVarRelDs.opcnm ='DBF';                                             //0004
               when iaVarRelDs.opcnm ='DBF' or iaVarRelDs.opcnm ='DSPF' or               //0004
                    iaVarRelDs.opcnm ='PRTFFLD';                                         //0004
                  w_vartrktyp = 'FFWU';
                  Clear W_VARFRMID ;
                  Clear W_VARTOID ;
                  //Any Keywords associated with field or field is reference field?
                  if iaVarRelDs.fact2 <> ' ' ;
                     //Fetch sourcepf, src library and src member name
                     //for the field reference file.
                     Clear wksrcfil ;
                     Clear wksrclib ;
                     Clear wksrcmbr ;
                     exec sql select MEMBER_SRCF, OBJECT_LIBR, OBJECT_NAME
                                 into :wksrcfil, :wksrclib, :wksrcmbr
                              from IAFILEDTL inner join IAOBJMAP on
                                 DBREFLIB = OBJECT_LIBR AND DBREFFILE = OBJECT_NAME
                              where DBREFFLD = :iaVarRelDs.fact2 limit 1;

                     if sqlCode < successCode;
                        uDpsds.wkQuery_Name = 'Select_1_IAFILEDTL_IAOBJMAP' ;
                        IaSqlDiagnostic(uDpsds);                                         //0013
                     endif;

                     //If field is not reference field. Check for field in DB file.
                     if sqlcode = 100 ;
                        exec sql select MEMBER_SRCF, OBJECT_LIBR, OBJECT_NAME
                                   into :wksrcfil, :wksrclib, :wksrcmbr
                                 from IAFILEDTL inner join IAOBJMAP on
                                   DBLIBNAME = OBJECT_LIBR AND DBFILENM = OBJECT_NAME
                                 where DBFLDNMI = :iaVarRelDs.fact2 or
                                   DBFLDNMX = :iaVarRelDs.fact2 limit 1;
                     endif ;

                     if sqlCode < successCode;
                        uDpsds.wkQuery_Name = 'Select_2_IAFILEDTL_IAOBJMAP' ;
                        IaSqlDiagnostic(uDpsds);                                         //0013
                     endif;

                     //Not found in above two queries? Check if its ALIAS.
                     wkfldnam = *Blanks ;
                     if sqlcode = 100 ;
                        exec sql select MEMBER_SRCF, OBJECT_LIBR, OBJECT_NAME,
                                        DBFLDNMX
                                   into :wksrcfil, :wksrclib, :wksrcmbr, :wkfldnam
                                   from IAFILEDTL inner join IAOBJMAP on
                                    DBLIBNAME = OBJECT_LIBR AND DBFILENM = OBJECT_NAME
                                   where DBFLDNMA = :iaVarRelDs.fact2 limit 1;
                     endif ;

                     if sqlCode < successCode;
                        uDpsds.wkQuery_Name = 'Select_3_IAFILEDTL_IAOBJMAP' ;
                        IaSqlDiagnostic(uDpsds);                                         //0013
                     endif;

                     //Get surrogate ID for the field.
                     clear w_vartoid ;
                     If wkfldnam = *blanks ;
                        w_result = iaVarRelDs.fact2 ;
                     else ;
                        w_result = wkfldnam ;
                     endif ;
                     FormatField(w_result) ;
                     iaVarRelDs.fact2  = %trim(w_result) ;
                     if iaVarRelDs.fact2 <> *blanks;                                     //0011
                        W_VARTOID = GetSurID(iaVarRelDs.fact2 :
                                             wksrclib :
                                             wksrcfil :
                                             wksrcmbr) ;
                     endif;                                                              //0011

                     w_rrn1 = w_rrn2 ;
                     w_mbr1 = w_mbr2 ;
                  endif ;

               when iaVarRelDs.opcnm ='SQLEXC';
                  Exsr CalculateToId;

               other;
                  if w_rrn1 <> w_rrn2 or w_mbr2 <> w_mbr1;
                     Exsr CalculateToId;
                  endif;
            endsl;

            if iaVarRelDs.result <> ' ' AND iaVarRelDs.result <> '*INLR';
               if (iaVarRelDs.fact1 <> ' ' AND
                   %subst(%TRIML(%xlate(lo:up:iaVarRelDs.fact1)):1:6) = 'CONST('  ) OR
                   (iaVarRelDs.fact2 <> ' ' AND
                   %subst(%TRIML(%xlate(lo:up:iaVarRelDs.fact2)):1:6) = 'CONST('  ) OR
                   (iaVarRelDs.fact1 = *blanks  AND  iaVarRelDs.fact2 = *blanks);
                   W_VARFRMID = W_VARTOID;
                   w_varname = iaVarRelDs.result;
                   Get_Rec_IAVARTRK();
               endif;
            endif;

            if iaVarRelDs.fact1 <> ' ' AND  iaVarRelDs.opcnm <> 'DCLVAR'  AND
               iaVarRelDs.opcnm <> 'DCL-DS' AND
               %subst(%TRIML(%xlate(lo:up:iaVarRelDs.fact1)):1:6) <> 'CONST(' ;
               FormatField(iaVarRelDs.fact1);

               w_varnamex = iaVarRelDs.fact1;
               exsr Handle_Prefix;
               If flag = '1';
                  W_VARFRMID = W_VARPFXID;
               else;
                  if iaVarRelDs.fact1 <> *blanks;                                        //0011
                     W_VARFRMID = GetSurID(iaVarRelDs.fact1 :
                                           iaVarRelDs.srclib :
                                           iaVarRelDs.srcfln :
                                           iaVarRelDs.pgmnam);
                  endif;                                                                 //0011

               endif;
               If ResNotBlk = *off and iaVarRelDs.result = ' ';
                  //In case of Reference field Fact 2 will be populated to W_VARTOID
                  If ( iaVarRelDs.opcnm <> 'DBF' and iaVarRelDs.opcnm <> 'DSPF' and      //0009
                       iaVarRelDs.opcnm <> 'PRTFFLD' ) or iaVarRelDs.fact2 = ' ';        //0009
                     Clear W_VARTOID;
                  Endif;
               Endif;
               if W_VARFRMID = 0 And W_VARTOID <> 0;
                  W_VARFRMID = W_VARTOID;
               endif;
               if W_VARFRMID <> 0 And W_VARTOID = 0;
                  W_VARTOID= W_VARFRMID;
               endif;
               if W_VARFRMID <> 0;
                  w_varname = iaVarRelDs.fact1;
                  Get_Rec_IAVARTRK();
               endif;
            endif;

            if iaVarRelDs.fact2 <> ' ' AND
               iaVarRelDs.opcnm <> 'DBF' and
               iaVarRelDs.opcnm <> 'DSPF' and                                            //0004
               iaVarRelDs.opcnm <> 'PRTFFLD' and                                         //0004
               iaVarRelDs.opcnm <> 'DCL-DS' AND
               iaVarRelDs.opcnm <> 'DCLVAR' AND                                          //0002
               %subst(%TRIML(%xlate(lo:up:iaVarRelDs.fact2)):1:6) <> 'CONST(' ;
               FormatField(iaVarRelDs.fact2);

               W_VARFRMID = GetSurID(iaVarRelDs.fact2 :
                                     iaVarRelDs.srclib :
                                     iaVarRelDs.srcfln :
                                     iaVarRelDs.pgmnam);

               if W_VARFRMID = 0 And W_VARTOID <> 0;
                  W_VARFRMID = W_VARTOID;
               endif;
               if W_VARFRMID <> 0 And W_VARTOID = 0;
                  W_VARTOID= W_VARFRMID;
               endif;

               If W_VARFRMID <> 0;
                  w_varname = iaVarRelDs.fact2;
                  Get_Rec_IAVARTRK();
               elseif W_VARFRMID = 0;
                  w_varnamex = iaVarRelDs.fact2;
                  exsr Handle_Prefix;
                  W_VARFRMID = W_VARPFXID;
                  w_varname = iaVarRelDs.fact2;
                  Get_Rec_IAVARTRK();
               endif;
            endif;

            w_mbr2 = iaVarRelDs.pgmnam;
            w_rrn2 = iaVarRelDs.RRNDS;

            clear w_varnamex;
            clear w_varpfxid;
            clear w_filepfx;
            Clear W_VARFRMID;
         endfor ;
         //if fetched rows are less than the array elements then come out of the loop.
         if C1_RowsFetched < C1_noOfRows ;
            leave ;
         endif ;
         //Fetch records from IAVARTRKR_C1 cursor.
         Wk_CsrName = 'IAVARTRKR_C1';
         rowFound = fetchRecordsfromCursor();
      enddo;

      exec sql close IAVARTRKR_C1;

   endif;

   return;

   //---------------------------------------------------------------------------------- //
   //CalculateToId :
   //---------------------------------------------------------------------------------- //
   Begsr CalculateToId;

      clear w_vartoid;
      w_result = IAVARRELDS.result;
      FormatField(w_result);
      IAVARRELDS.result = %trim(w_result);

      If IAVARRELDS.result <> *Blanks;                                                   //0005
         W_VARTOID = GetSurID(IAVARRELDS.result :
                              IAVARRELDS.srclib :
                              IAVARRELDS.srcfln :
                              IAVARRELDS.pgmnam);
      endif;                                                                             //0005

      if W_VARTOID  <> 0;
         ResNotBlk = *on;
         w_varnamex = IAVARRELDS.result;
         exsr Handle_Prefix;
         If flag ='1';
            W_VARTOID = W_VARPFXID;
         endif;
      endif;
      w_rrn1 = w_rrn2;
      w_mbr1 = w_mbr2;

   endsr;

   //---------------------------------------------------------------------------------- //
   //Handle_Prefix :
   //---------------------------------------------------------------------------------- //
   Begsr Handle_Prefix;

      Flag = '0';

      If %len(%trim(w_varnamex)) >= 2 and %Scan('&': %trim(w_varnamex)) = 1;
         w_varnamex = %subst(%trim(w_varnamex): 2 );
      Endif;

      exec sql
        declare IAVARTRKR_C2 Cursor For
          select PREFIX                                                                  //0015
            from iapgmfiles                                                              //0015
          where MEMBER_NAME  = trim(:IAVARRELDS.pgmnam)                                  //0015
            and SOURCE_FILE  = trim(:IAVARRELDS.srcfln)                                  //0015
            and LIBRARY      = trim(:IAVARRELDS.srclib)                                  //0015
            and PREFIX <> ' '                                                            //0015
          union
          select DS_PREFIX
            from iapgmds
          where LIBRARY_NAME = trim(:IAVARRELDS.srclib)
            and SRC_PF_NAME = trim(:IAVARRELDS.srcfln)
            and MEMBER_NAME = trim(:IAVARRELDS.pgmnam)
            and DS_PREFIX <> ' ';

      exec sql open IAVARTRKR_C2;
      if sqlCode = CSR_OPN_COD;
         exec sql close IAVARTRKR_C2;
         exec sql open  IAVARTRKR_C2;
      endif;

      if sqlCode < successCode;
         uDpsds.wkQuery_Name = 'Open_IAPGMFILES_IAVARTRKR_C2';
         IaSqlDiagnostic(uDpsds);                                                        //0013
      endif;

      if sqlCode = successCode;

         //Get the number of elements.
         C2_noOfRows = %elem(DSFilepfxArr);
         Wk_CsrName = 'IAVARTRKR_C2';

         rowFound = fetchRecordsfromCursor();

         dow rowFound;
            for C2_idx = 1 to C2_RowsFetched;
               W_Filepfx = DsFilepfxArr(C2_idx);
               if %len(%trim(w_varnamex)) > %len(%trim(w_filepfx)) and
                  %trim(w_filepfx) = %subst(w_varnamex:1:%len(%trim(w_filepfx)))
                  and iavarrelds.opcnm = 'DCL-DS';
                  w_varnamex = %subst(w_varnamex:%len(%trim(w_filepfx))+1);

                  W_VARPFXID = GetSurID(w_varnamex       :
                                       IAVARRELDS.srclib :
                                       IAVARRELDS.srcfln :
                                       IAVARRELDS.pgmnam);
                  if W_VARPFXID <> 0;
                     flag='1';
                     leave;
                  endif;
               endif;
            endfor ;

            //if fetched rows are less than the array elements then come out of the loop.
            if C2_RowsFetched < C2_noOfRows ;
               leave ;
            endif ;
            Wk_CsrName = 'IAVARTRKR_C2';
            rowFound = fetchRecordsfromCursor();
         enddo;
         exec sql close IAVARTRKR_C2;
      endif;

   endsr;

end-proc;

//------------------------------------------------------------------------------------- //
//Get_Rec_IAVARTRK :
//------------------------------------------------------------------------------------- //
dcl-proc  Get_Rec_IAVARTRK;

   if W_VARFRMID <> 0 and W_VARTOID <> 0;


      exec sql
        insert into IAVARTRK (VARTRKTYP,
                             SRCMBRID,
                             SRCRRN,
                             VARFRMID,
                             VARTOID,
                             VARLVL,
                             VARREF)
          values(:w_vartrktyp,
                 :W_SRCMBRID ,
                 :IAVARRELDS.RRNDS,
                 :W_VARFRMID ,
                 :W_VARTOID ,
                 0,
                  ' ');

      if sqlCode < successCode;
         uDpsds.wkQuery_Name = 'Insert_IAVARTRK';
         IaSqlDiagnostic(uDpsds);                                                        //0013
      else;
         clear W_VARFRMID;
      endif;
   endif;

end-proc;
//------------------------------------------------------------------------------------- //
//FormatField :
//------------------------------------------------------------------------------------- //
dcl-proc FormatField;

   dcl-pi FormatField;
      fr_string char(80);
   end-pi;

   if fr_string <> ' ';
      select;
      when %scan('(' : %trim(fr_string)) > 1
           and %len(%trim(fr_string)) >= (%scan('(' : %trim(fr_string)) - 1);
         fr_string = %subst(%trim(fr_string) : 1 :
                         %scan('(' : %trim(fr_string)) - 1);
      when %scan('.' : %trim(fr_string)) > 0 and
           %scan('.' : %trim(fr_string)) < %len(%trim(fr_string));
         monitor;
            fr_string = %subst(%trim(fr_string):
                               %scan('.': %trim(fr_string))+1);
         on-error;
            fr_string = %trim(fr_string);
         endmon;
      endsl;

      if %len(%trim(fr_string)) >= 1 and %subst(%trim(fr_string):1:1) = '&';
         fr_string = %subst(%trim(fr_string):1);
      endif;
   endif;
   return;

end-proc;

//------------------------------------------------------------------------------------- //
//GetSurID: Get surrogate ID from IASRCVARID / Create if not available
//------------------------------------------------------------------------------------- //
dcl-proc GetSurID;

   dcl-pi GetSurID zoned(9);
     pr_Varname char(80);
     pr_srclib char(10);
     pr_srcfln char(10);
     pr_pgmnam char(10);
   end-pi;

   dcl-s recordExists   char(1) inz;
   dcl-s l_VarFrmId     like(w_VarFrmId);

   dcl-ds iaSrcVads qualified inz;
      varNam char(80);
      varLen packed(8);
      varTyp char(10);
   end-ds;


   if pr_Varname =  *blanks;                                                             //0010
      return 0 ;                                                                         //0010
   endif;                                                                                //0010

   resultIndex = %Lookup(pr_Varname:VarSurID(*).Ar_varnam:1:Index);

   if ResultIndex > 0;

      Return VarSurID(ResultIndex).Ar_SurId;

   else;
      Exsr GetVariableAttr;

      If Sqlcode  = successCode;

         l_VarFrmId = *zeros;
         recordExists = 'N';

         //Below logic is to remove '&' symbol from CLP variable name                   //0008
         if %subst(%trim(iaSrcVaDs.varNam):1:1)= '&';                                    //0008
            iaSrcVaDs.varNam = %subst(%trim(iaSrcVaDs.varNam):2);                        //0008
         endif;                                                                          //0008

         //Check if the records for Variable already there in IASRCMBRID
         //then fetch surrogate id
         exec sql
            select 'Y', varSurId into :recordExists, :l_VarFrmId
              from iaSrcVarId
            where varName = :iaSrcVads.VarNam
              and varLen = :iaSrcVads.VarLen
              and varType = :iaSrcVads.VarTyp limit 1;

         if sqlCode < successCode;
            uDpsds.wkQuery_Name = 'Record_exists_IASRCVARID';
            IaSqlDiagnostic(uDpsds);                                                     //0013
         endif;

         //If surrogate id does not exist
         if recordExists <> 'Y';

            //inserting value to IASRCVARID File
            If iaSrcVaDs.varNam  <> ' ';

               if %subst(%trim(iaSrcVaDs.varNam):1:1)= '&';
                  iaSrcVaDs.varNam = %subst(%trim(iaSrcVaDs.varNam):1);
               endif;

               Exec Sql
                 select varSurId
                   into :l_VarFrmId
                 from final table
                 (insert into iaSrcVarId (varName,
                                          varLen,
                                          varType)
                   Values (:iaSrcVaDs.VarNam,
                           :iaSrcVaDs.VarLen,
                           :iaSrcVaDs.VarTyp));

               if sqlCode < successCode;
                  uDpsds.wkQuery_Name = 'Insert_into_IASRCVARID';
                  IaSqlDiagnostic(uDpsds);                                               //0013
               endif;

            elseif sqlCode = successCode;

               //Get surrogate ID for the inserted/existing var name
               exec Sql
                  select varSurId
                    into :l_VarFrmId
                  from iaSrcVarId
                    where varName = :iaSrcVaDs.varNam
                      and varLen = :iaSrcVaDs.varLen
                      and varType = :iaSrcVaDs.varTyp limit 1;

               if sqlCode < successCode;
                  uDpsds.wkQuery_Name = 'Select_VARSURID_IASRCVARID';
                  IaSqlDiagnostic(uDpsds);                                               //0013
               endif;

            endif;

         endif;

      endif;

      If Index > ArrnextAlloc;
         ArrnextAlloc = ArrnextAlloc + ArrAlloc;
         PArray   = %Realloc(PArray:ArrnextAlloc * %size(VarSurID));
      EndIf;

      VarSurID(Index).Ar_varnam = pr_Varname;
      VarSurID(Index).Ar_SurID  = l_VarFrmId;
      Index += 1;

   Endif;

   return l_VarFrmId;

   //---------------------------------------------------------------------------------- //
   //GetVariableAttr: Get attribute of avriable
   //---------------------------------------------------------------------------------- //
   Begsr GetVariableAttr;

   // if iaVarRelDs.opcnm ='DBF';                                                //0004  //0001
      if iaVarRelDs.opcnm ='DBF' or iaVarRelDs.opcnm ='DSPF' or                          //0004
         iaVarRelDs.opcnm ='PRTFFLD';                                                    //0004
         //Check if Internal field name matches with variable name.                     //0001
         Exec sql                                                                        //0001
            select dbfldnmi, dbfldlen, dbdatatype                                        //0001
              into :iasrcvads                                                            //0001
                from iafiledtl a join iaobjmap b                                         //0001
                    on a.file_name = b.object_name                                       //0001
                   and b.object_attr = a.file_type                                       //0001
                   and b.object_libr = a.library_name                                    //0001
                where  b.member_libr = :pr_srclib                                        //0001
                   and b.member_srcf = :pr_srcfln                                        //0001
                   and b.member_name = :pr_pgmnam                                        //0001
                   and a.dbfldnmi = :pr_varname                                          //0001
                limit 1;                                                                 //0001
         if sqlCode = successCode ;                                                      //0001
            Leavesr ;                                                                    //0001
         elseIf sqlCode < successCode;                                                   //0001
            uDpsds.wkQuery_Name = 'Select_for_IAFILEDTL1';                               //0001
            IaSqlDiagnostic(uDpsds);                                                     //0013
            leavesr;                                                                     //0001
         endif ;                                                                         //0001
                                                                                         //0001
         //Check if External field name matches with variable name.                     //0001
         if sqlCode = NO_DATA_FOUND;                                                     //0001
            Exec sql                                                                     //0001
               select dbfldnmx, dbfldlen, dbdatatype                                     //0001
                 into :iasrcvads                                                         //0001
                   from iafiledtl a join iaobjmap b                                      //0001
                       on a.file_name = b.object_name                                    //0001
                      and b.object_attr = a.file_type                                    //0001
                      and b.object_libr = a.library_name                                 //0001
                   where  b.member_libr = :pr_srclib                                     //0001
                      and b.member_srcf = :pr_srcfln                                     //0001
                      and b.member_name = :pr_pgmnam                                     //0001
                      and a.dbfldnmx = :pr_varname                                       //0001
                   limit 1;                                                              //0001
            if sqlCode = successCode ;                                                   //0001
               Leavesr ;                                                                 //0001
            elseIf sqlCode < successCode;                                                //0001
               uDpsds.wkQuery_Name = 'Select_for_IAFILEDTL2';                            //0001
               IaSqlDiagnostic(uDpsds);                                                  //0013
               leavesr;                                                                  //0001
            endif ;                                                                      //0001
         endif;                                                                          //0001
         //Check if Alias is used instead of field name, use original field.            //0001
         if sqlCode = NO_DATA_FOUND;                                                     //0001
            Exec sql                                                                     //0001
               select dbfldnmx, dbfldlen, dbdatatype                                     //0001
                 into :iasrcvads                                                         //0001
                   from iafiledtl a join iaobjmap b                                      //0001
                       on a.file_name = b.object_name                                    //0001
                      and b.object_attr = a.file_type                                    //0001
                      and b.object_libr = a.library_name                                 //0001
                   where  b.member_libr = :pr_srclib                                     //0001
                      and b.member_srcf = :pr_srcfln                                     //0001
                      and b.member_name = :pr_pgmnam                                     //0001
                      and a.dbfldnma = :pr_varname                                       //0001
                   limit 1;                                                              //0001
            if sqlCode = successCode ;                                                   //0001
               Leavesr ;                                                                 //0001
            elseIf sqlCode < successCode;                                                //0001
               uDpsds.wkQuery_Name = 'Select_for_IAFILEDTL3';                            //0001
               IaSqlDiagnostic(uDpsds);                                                  //0013
               leavesr;                                                                  //0001
            endif ;                                                                      //0001
         endif;                                                                          //0001
      endif;                                                                             //0001

      Exec sql
        select iavvar, iavlen, iavdtyp
          into :iasrcvads
        from iapgmvars
        where iavlib   = :pr_srclib
          and iavsfile = :pr_srcfln
          and iavmbr   = :pr_pgmnam
          and iavvar   = :pr_varname limit 1;

      if sqlCode = successCode ;
         Leavesr ;
      elseif sqlCode < successCode;
          uDpsds.wkQuery_Name = 'Select_for_IAPGMVARS';
          IaSqlDiagnostic(uDpsds);                                                       //0013
          leavesr;
      endif;

      if sqlCode = NO_DATA_FOUND;
         exec sql
           select dsfldnm, dsflsiz, dsfltyp
             into :iasrcvads
           from iapgmds
           where dssrclib = :pr_srclib
             and dssrcfln = :pr_srcfln
             and dspgmnm  = :pr_pgmnam
             and dsfldnm  = :pr_varname limit 1;

         if sqlCode = successCode ;
            Leavesr ;
         elseIf sqlCode < successCode;
             uDpsds.wkQuery_Name = 'Select_for_IAPGMDS1';
             IaSqlDiagnostic(uDpsds);                                                    //0013
             leavesr;
         endif ;
      endif ;

      if sqlCode = NO_DATA_FOUND;
         exec sql
            select datastr_name, datastr_len, datastr_type
              into :iasrcvads
            from iapgmds
            where dssrclib = :pr_srclib
              and dssrcfln = :pr_srcfln
              and dspgmnm = :pr_pgmnam
              and datastr_name = :pr_varname limit 1;
         if sqlCode = successCode ;
            Leavesr ;
         elseIf sqlCode < successCode;
            uDpsds.wkQuery_Name = 'Select_for_IAPGMDS2';
            IaSqlDiagnostic(uDpsds);                                                     //0013
            leavesr;
         endif ;
      endif;

      if sqlCode = NO_DATA_FOUND;
         exec sql
            select pprmnam, pprmlen, pprmdta
              into :iasrcvads
            from  iaprcparm
            where pprmnam = :pr_varname
              and plibnam = :pr_srclib
              and psrcpf = :pr_srcfln
              and pmbrnam = :pr_pgmnam limit 1;
         if sqlCode = successCode ;
            Leavesr ;
         elseIf sqlCode < successCode;
             uDpsds.wkQuery_Name = 'Select_for_IAPRCPARM';
             IaSqlDiagnostic(uDpsds);                                                    //0013
             leavesr;
         endif ;
      endif;

      if sqlCode = NO_DATA_FOUND;
         Exec sql
            select substring(fld_sql_name,1,80), coalesce(fld_length, 0),
                   coalesce(fld_datatype, ' ')
              into :iasrcvads
            from  iaesqlffd
            where fld_sql_name <> fld_sys_name
              and fld_sql_name <> ' '
              and substring(fld_sql_name,1,80) = :pr_varname
              and csrclib = :pr_srclib
              and csrcfln = :pr_srcfln
              and cpgmnm = :pr_pgmnam limit 1;
         if sqlCode = successCode ;
            Leavesr ;
         elseIf sqlCode < successCode;
             uDpsds.wkQuery_Name = 'Select_for_IAESQLFFD';
             IaSqlDiagnostic(uDpsds);                                                    //0013
             leavesr;
         endif ;
      endif;

      if sqlCode = NO_DATA_FOUND;
         exec sql
            select iav_var, iav_len, iav_dtyp
              into :iasrcvads
            from iapgmvars tbl1
              join iacpybdtl tbl2
                on tbl1.iav_mbr = tbl2.iAMbrName                                         //0014
            where Tbl2.iAMbrName = :pr_pgmnam                                            //0014
              and iav_var = :pr_varname
              and iav_lib = :pr_srclib
              and iav_sfile = :pr_srcfln limit 1;
         if sqlCode = successCode ;
            Leavesr ;
         elseIf sqlCode < successCode;
            uDpsds.wkQuery_Name = 'Select_for_IAPGMVARS_IACPYBDTL';
            IaSqlDiagnostic(uDpsds);                                                     //0013
            leavesr;
         endif ;
      endif;

      if sqlCode = NO_DATA_FOUND;
         exec sql
            select datastr_name, datastr_len, datastr_type
              into :iasrcvads
            from  iapgmds tbl3
              join  iacpybdtl tbl4
                on tbl3.dspgmnm  = tbl4.iAMbrName                                        //0014
            where Tbl4.iAMbrName = :pr_pgmnam                                            //0014
              and datastr_name = :pr_varname
              and dssrclib = :pr_srclib
              and dssrcfln = :pr_srcfln limit 1;
         if sqlCode = successCode ;
            Leavesr ;
         elseIf sqlCode < successCode;
            uDpsds.wkQuery_Name = 'Select_for_IAPGMDS_IACPYBDTL1';
            IaSqlDiagnostic(uDpsds);                                                     //0013
            leavesr;
         endif ;
      endif;

      if sqlCode = NO_DATA_FOUND;
         exec sql
            select ds_fld_name, ds_fld_size, ds_fld_type
              into :iasrcvads
            from  iapgmds tbl3
              join  iacpybdtl tbl4
                on   tbl3.dspgmnm  = tbl4.iAMbrName                                      //0014
            Where Tbl4.iAMbrName = :pr_pgmnam                                            //0014
              and ds_fld_name  = :pr_varname
              and dssrclib = :pr_srclib
              and dssrcfln = :pr_srcfln limit 1;
         if sqlCode = successCode ;
            Leavesr ;
         elseIf sqlCode < successCode;
            uDpsds.wkQuery_Name = 'Select_for_IAPGMDS_IACPYBDTL2';
            IaSqlDiagnostic(uDpsds);                                                     //0013
            leavesr;
         endif ;
      endif;

      //Below query is written to fetch file field details through                      //0001
      //object mapping and reference checking.                                          //0001
      if sqlCode = NO_DATA_FOUND;                                                        //0001
         exec sql                                                                        //0001
            with refobj as (                                                             //0001
              select iarobjnam, iarobjlib                                                //0001
                 from iaobjmap a join iaallrefpf b                                       //0001
                  on b.iaoobjnam = a.object_name                                         //0001
                  and b.iaoobjlib = a.object_libr                                        //0001
                  where member_libr = :pr_srclib                                         //0001
                    and member_srcf = :pr_srcfln                                         //0001
                    and member_name = :pr_pgmnam                                         //0001
                    and iarobjtyp = '*FILE')                                             //0001
              select dbfldnmi, dbfldlen, dbdatatype                                      //0001
                 into :iasrcvads                                                         //0001
                 from refobj join iafiledtl                                              //0001
                  on file_name = iarobjnam                                               //0001
                  and dblibname = iarobjlib                                              //0001
                  //Check Field used in program is a file Internal field.               //0001
                  where dbfldnmi = (                                                     //0001
                    case                                                                 //0001
                      when substr(:pr_varname, 1, 1) = '&' then substr(:pr_varname, 2)   //0001
                      else :pr_varname end)                                              //0001
                  //Check Field used in program is a file external field.               //0001
                  or dbfldnmx = (                                                        //0001
                    case                                                                 //0001
                      when substr(:pr_varname, 1, 1) = '&' then substr(:pr_varname, 2)   //0001
                      else :pr_varname end)                                              //0001
                  //Check Field used in program is a file field Alias.                  //0001
                  or dbfldnma = (                                                        //0001
                    case                                                                 //0001
                      when substr(:pr_varname, 1, 1) = '&' then substr(:pr_varname, 2)   //0001
                      else :pr_varname end) limit 1;                                     //0001
         if sqlCode = successCode ;                                                      //0001
            Leavesr ;                                                                    //0001
         elseIf sqlCode < successCode;                                                   //0001
            uDpsds.wkQuery_Name = 'Select_for_REFOBJ_IAFILEDTL1';                        //0001
            IaSqlDiagnostic(uDpsds);                                                     //0013
            leavesr;                                                                     //0001
         endif ;                                                                         //0001
      endif;                                                                             //0001

      if sqlCode = NO_DATA_FOUND;
         exec sql
            select coalesce(new_fld_name, ' '), coalesce(field_length, 0),
                   coalesce(field_data_type, ' ')
              into :iasrcvads
            from iaprfxdtl a
              left join iafiledtl b
              on   a.old_fld_name = b.field_name_external and
                   a.iapfxflnm = b.dbfilenm
            where iapfxlib = :pr_srclib
              and iapfxmbr = :pr_pgmnam
              and iapfxspf = :pr_srcfln
              and new_fld_name = (
                       Case
                       When substr(:pr_varname, 1, 1) = '&' then substr(:pr_varname, 2)
                       Else :pr_varname
                       End
                       )
              and (file_name in (select iarobjnam from iaallrefpf
            where iaoobjnam = :pr_pgmnam and iarobjtyp = '*FILE')
            //Below check not required as this query will only execute in case of       //0001
            //program source.                                                           //0001
            //or  exists (select * from iafiledtl where file_name = :pr_pgmnam))         //0001
              )                                                                          //0001
              limit 1   ;
         if sqlCode = successCode ;
            Leavesr ;
         elseIf sqlCode < successCode;
            uDpsds.wkQuery_Name = 'Select_for_IAFILEDTL3';
            IaSqlDiagnostic(uDpsds);                                                     //0013
            leavesr;
         endif ;
      endif;

      if Sqlcode = NO_DATA_FOUND;
         Exec sql
            select coalesce(ds_fld_name_prf, ' '), coalesce(field_length, 0),
                   coalesce(field_data_type, ' ')
              into :iasrcvads
            from iapgmds c
              left join iafiledtl d
              on   c.ds_fld_name = d.field_name_external
            where c.ds_prefix <> ' ' and c.datastr_objv = ' '
              and dssrclib = :pr_srclib
              and dspgmnm  = :pr_pgmnam
              and dssrcfln = :pr_srcfln
              and ds_fld_name_prf = (
                       Case
                       When substr(:pr_varname, 1, 1) = '&' then substr(:pr_varname, 2)
                       Else :pr_varname
                       End
                     )
              and (file_name in (select iarobjnam from iaallrefpf
            where iaoobjnam = :pr_pgmnam and iarobjtyp = '*FILE')
            //Below check not required as this query will only execute in case of       //0001
            //program source.                                                           //0001
            //or  exists (select * from iafiledtl where file_name = :pr_pgmnam))         //0001
            )                                                                            //0001
              limit 1   ;
         if sqlCode = successCode ;
            Leavesr ;
         elseif sqlCode < successCode;
            uDpsds.wkQuery_Name = 'Select_for_IAFILEDTL4';
            IaSqlDiagnostic(uDpsds);                                                     //0013
            Leavesr ;
         endif ;
      endif ;
   endsr;

end-proc;

//------------------------------------------------------------------------------------- //
//clear and allcoate memeory for the pointer array
//------------------------------------------------------------------------------------- //
dcl-proc AllocArray;

   Clear PArray ;
   Dealloc PArray;
   PArray   = %alloc(ArrAlloc * %size(VarSurID));
   Index =1;
   ArrnextAlloc = ArrAlloc;

end-proc;
//------------------------------------------------------------------------------------- //
//Procedure fetchRecordsfromCursor to get the variable tracking details
//------------------------------------------------------------------------------------- //
dcl-proc fetchRecordsfromCursor;

   dcl-pi fetchRecordsfromCursor ind end-pi ;

   dcl-s  rcdFound ind inz('0');
   dcl-s  wkRowNum uns(5);

   Select;
   when Wk_CsrName ='IAVARTRKR_C1';
      C1_RowsFetched = *zeros;
      clear IaVarRelArr;
      exec sql
         fetch IAVARTRKR_C1 for :C1_noOfRows rows into :IaVarRelArr;

      if sqlcode = successCode;
         exec sql get diagnostics
             :wkRowNum = ROW_COUNT;
              C1_RowsFetched  = wkRowNum ;
      endif;

      if C1_RowsFetched > 0;
         rcdFound = TRUE;
      elseif sqlcode < successCode ;
         rcdFound = FALSE;
      endif;

   when Wk_CsrName = 'IAVARTRKR_C2';
      C2_RowsFetched = *zeros;
      clear DsFilepfxArr;
      exec sql
         fetch IAVARTRKR_C2 for :C2_noOfRows rows into :DsFilepfxArr;
      if sqlcode = successCode;
         exec sql get diagnostics
             :wkRowNum = ROW_COUNT;
              C2_RowsFetched  = wkRowNum ;
      endif;

      if C2_RowsFetched > 0;
         rcdFound = TRUE;
      elseif sqlcode < successCode ;
         rcdFound = FALSE;
      endif;
   endsl;

   return rcdFound;
end-proc;
//------------------------------------------------------------------------------------- //
//Procedure clrRefreshData to clear records for modified members from IAVARTRK file
//------------------------------------------------------------------------------------- //
dcl-proc clrRefreshData ;                                                                //0003

   exec sql                                                                              //0003
     delete from iAVarTrk where Src_Mbr_Id in (                                          //0003
       select mbrSurId                                                                   //0003
         from iASrcMbrId join iARefObjF                                                  //0003
           on mbrname = iamemname                                                        //0003
          and mbrsrcpf = iasrcpf                                                         //0003
          and mbrlib = iamemlib                                                          //0003
        where iastatus = 'M' );                                                          //0003

   if sqlCode < successCode;                                                             //0003
      uDpsds.wkQuery_Name = 'Delete_IAVARTRKR';                                          //0003
      IaSqlDiagnostic(uDpsds);                                                           //0013
   endif;                                                                                //0003

end-proc;                                                                                //0003
