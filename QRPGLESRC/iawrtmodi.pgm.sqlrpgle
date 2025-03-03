**free
      //%METADATA                                                      *
      // %TEXT Write list of procedures (DSPMOD)                       *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------- //
//CREATED BY :   Programmers.io @ 2021                                                  //
//CREATE DATE:   2021/12/17                                                             //
//DEVELOPER  :   Rohini Alagarsamy                                                      //
//DESCRIPTION:   Extract List of procedures both import and export for a module using   //
//               API QBNLMODI.                                                          //
//PROCEDURE LOG:                                                                        //
//------------------------------------------------------------------------------------- //
//Procedure Name           | Procedure Description                                      //
//-------------------------|----------------------------------------------------------- //
//No Procedure             |                                                            //
//------------------------------------------------------------------------------------- //
//                                                                                      //
//MODIFICATION LOG:                                                                     //
//------------------------------------------------------------------------------------- //
//Date    | Mod_ID | Developer  | Case and Description                                  //
//--------|--------|------------|------------------------------------------------------ //
//27/01/23| 0001   |Manesh K    | Replace IAMENUR with BLDMTADTA                        //
//08/02/23| 0002   |Pranav Joshi| Handled crashing scenario.                            //
//20/06/23| 0003   |Vamsi       | Enhanced to capture the export procedure list from    //
//        |        |Krishna2    | a service program to IAPROCDTLP                       //
//28/09/23| 0004   |Vamsi       | Modified the extraction logic of procedure list from a//
//        |        |Krishna2    | Module to get correct procedure names(Task#233)       //
//20/10/23| 0005   |Abhijith    | Metadata refresh process changes                      //
//        |        |Ravindran   |                                                       //
//16/11/23| 0006   |Akhil K.    | IAPROCDTLP will be cleared only in 'INIT' mode        //
//        |        |            | (Task#388)                                            //
//06/12/23| 0007   |Abhijit C.  | Enhancement to Refresh process.Changes                //
//        |        |            | related to IAOBJECT file.(Task#441)                   //
//13/10/23| 0008   | Rituraj    | Changed file name AIEXCTIME to IAEXCTIME [Task #248]  //
//05/07/24| 0009   |Akhil K.    | Renamed AIERRBND, AICERRLOG, AIDERRLOG and AISQLDIAGNO//
//        |        |            | STIC with IA*                                         //
//20/08/24| 0010   |Sabarish    | IFS Member Parsing Feature                            //
//------------------------------------------------------------------------------------- //
ctl-opt copyright('Programmers.io Â© 2021');
ctl-opt option(*NoDebugIO : *SrcStmt : *noUnRef);
ctl-opt dftactgrp(*no);
ctl-opt bndDir('IAERRBND');                                                              //0009

dcl-pr GetModInf   extpgm('QBNLMODI');
   *n  char(20)    const;
   *n  char(08)    const;
   *n  char(20)    const;
   *n  char(37627) options(*varsize:*nopass);
end-pr;

dcl-pr CrtUserSpace extpgm('QUSCRTUS');
   *n  char(20)     const;                      //UserSpace Name
   *n  char(10)     const;                      //Attribute
   *n  int(10)      const;                      //Initial Size
   *n  char(1)      const;                      //Initial Value
   *n  char(10)     const;                      //Authority
   *n  char(50)     const;                      //Text
   *n  char(10)     const options(*noPass);     //Replace Existing
   *n  char(32767)  options(*varsize:*noPass);  //Error Feedback
end-pr;

dcl-pr GetPointer  extpgm('QUSPTRUS');
   *n  char(20)    const;                       //Name
   *n  pointer;                                 //Pointer to user space
   *n  char(32767) options(*varsize:*nopass);   //Error feedback
end-pr;

dcl-pr DltUserSpace extpgm('QUSDLTUS');
   *n  char(20)     const;                       //Name
   *n  char(32767)  options(*varsize:*nopass);   //Error Feedback
end-pr;

dcl-pr IAEXCTIMR extpgm('IAEXCTIMR');                                                    //0008
    *n Char(10) Const;
    *n Char(10);
    *n Char(10);
    *n Char(10) Const;
    *n Char(10);
    *n Char(10);
    *n Char(10);
    *n Char(100) Const;                                                                  //0010
    *n Char(10) Const;
    *n Timestamp;
    *n Char(6) Const;
end-pr;

dcl-ds ObjectDS;                                                                         //0003
   ObjName char(10) inz;                                                                 //0003
   ObjLib  char(10) inz;                                                                 //0003
   ObjType char(10) inz;                                                                 //0003
   ObjAttr char(10) inz;                                                                 //0003
   ObjText char(50) inz;                                                                 //0003
end-ds;                                                                                  //0003

dcl-ds ProcDS;
   PMod     char(10) inz;
   PModLib  char(10) inz;
   PModText char(50) inz;
   ProName  char(30) inz;
end-ds;

dcl-ds HeaderInfo based(pHeaderInfo);
   *n         char(103);
   ListStatus char(1 );
   *n         char(20);
   ListOffset int (10);
   ListSize   int (10);
   NbrEntries int (10);
   EntryLen   int (10);
end-ds;

dcl-ds MODL0100 based(pModL0100);
   ProcList char(8000);
end-ds;

dcl-ds OutDs;
   *n       char(4);
   Mod      char(10);
   ModLib   char(10);
   *n       char(22);
   ProcName char(80);                                                                    //0004
end-ds;

dcl-pr GetSrvPgmInf extpgm('QBNLSPGM');                                                  //0003
   *n  char(20)    const;                                                                //0003
   *n  char(08)    const;                                                                //0003
   *n  char(20)    const;                                                                //0003
   *n  char(30000) options(*varsize:*nopass);                                            //0003
end-pr;                                                                                  //0003
                                                                                         //0003
dcl-ds SPGL0600 based(pSPGL0600);                                                        //0003
   SrvPgm_ProcList char(30000);                                                          //0003
end-ds;                                                                                  //0003
                                                                                         //0003
dcl-ds SrvPgm_OutDs;                                                                     //0003
   SrvPgm          char(10);                                                             //0003
   SrvPgmLib       char(10);                                                             //0003
   *n              char(8);                                                              //0003
   SrvPgm_ProcName char(256);                                                            //0003
end-ds;                                                                                  //0003
                                                                                         //0005
//Data structure declaration                                                            //0005
dcl-ds iaMetaInfo dtaara len(62);                                                        //0005
   runMode char(7) pos(1);                                                               //0005
end-ds;                                                                                  //0005
                                                                                         //0003
dcl-s ErrorInfo         char(1070);
dcl-s Index             int(10)      inz(261);
dcl-s StrPos            int(10)      inz(1);
dcl-s EndPos            int(10)      inz(1);
dcl-s ProcLen           int(10)      inz(1);
dcl-s RcdCnt            int(10)      inz(0);
dcl-s ProcType          char(10)     inz;
dcl-s uppgm_name        char(10)     inz;
dcl-s uplib_name        char(10)     inz;
dcl-s uptimestamp       Timestamp;
dcl-s upsrc_name        char(10)     inz;
dcl-s ProcName_StartPos int(10)      inz;                                                //0004
dcl-s BlankPos          int(10)      inz;                                                //0004
dcl-s NextModPos        int(10)      inz;                                                //0004
dcl-s LastProc_End      int(10)      inz;                                                //0004
dcl-s wkSqlText1        char(1000)   Inz ;                                               //0007

/copy qsysinc/qrpglesrc,qusec
/copy 'QCPYSRC/iaderrlog.rpgleinc'

//------------------------------------------------------------------------------------- //
//Mainline
//------------------------------------------------------------------------------------- //
exec sql
  set option Commit = *None,
             Naming = *Sys,
             Dynusrprf = *User,
             Closqlcsr = *EndMod;

Eval-corr uDpsds = wkuDpsds;

uptimeStamp = %Timestamp();
CallP IAEXCTIMR('BLDMTADTA' :udpsds.ProcNme : udpsds.Lib : '*PGM' :                      //0008
                //0010 upsrc_name : uppgm_name : uplib_name : ' ' : uptimeStamp :
                upsrc_name : uppgm_name : uplib_name : ' ' : ' ' : uptimeStamp :         //0010
                'INSERT');

//If Process is 'INIT'                                                                  //0007
if runmode = 'INIT';                                                                     //0007
   wksqltext1 =                                                                          //0007
      ' select IaObjNam,IaLibNam,IaObjTyp,IaObjAtr,IaTxtDes' +                           //0007
      ' from IaObject'                                       +                           //0007
      ' where IaObjTyp in (''*MODULE'',''*SRVPGM'')';                                    //0007
                                                                                         //0007
//If Process is 'REFRESH'                                                               //0007
elseif runmode = 'REFRESH';                                                              //0007
   wksqltext1 =                                                                          //0007
      ' select IaObjNam,IaLibNam,IaObjTyp,IaObjAtr,IaTxtDes' +                           //0007
      '   from IaObject'                                     +                           //0007
      '  where IaObjTyp in (''*MODULE'',''*SRVPGM'') and'    +                           //0007
      '        IaRefresh in (''A'' ,''M'')';
endif;                                                                                   //0007
                                                                                         //0007
//Declare cusrsor for Module and ServiceProgram objects retrieve details.               //0007
exec sql prepare ModSrvstmt from :wksqltext1 ;                                           //0007
exec sql declare ModSrvPgmObject cursor for ModSrvstmt;                                  //0007
                                                                                         //0007
exec sql open ModSrvPgmObject;                                                           //0003
if sqlCode = CSR_OPN_COD;
   exec sql close ModSrvPgmObject;                                                       //0003
   exec sql open  ModSrvPgmObject;                                                       //0003
endif;

if sqlCode < successCode;
   uDpsds.wkQuery_Name = 'Open_Cursor_ModSrvPgmObject';                                  //0003
   IaSqlDiagnostic(uDpsds);                                                              //0009
endif;

exec sql fetch next from ModSrvPgmObject into :ObjectDS;                                 //0003

if sqlCode < successCode;
   uDpsds.wkQuery_Name = 'Fetch_1_Cursor_ModSrvPgmObject';                               //0003
   IaSqlDiagnostic(uDpsds);                                                              //0009
endif;

dow sqlCode = successCode;

   //Delete exisiting records if 'REFRESH'.                                             //0005
   if runMode = 'REFRESH';                                                               //0005
      exsr deleteSrvPgmObjects;                                                          //0005
   endIf;                                                                                //0005

   exsr ProcListSr;
   exec sql fetch next from ModSrvPgmObject into :ObjectDS;                              //0003

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Fetch_2_Cursor_ModSrvPgmObject';                            //0003
      IaSqlDiagnostic(uDpsds);                                                           //0009
   endif;

enddo;

exec sql close ModSrvPgmObject;                                                          //0003

UPTimeStamp = %Timestamp();
CallP IAEXCTIMR('BLDMTADTA' :udpsds.ProcNme : udpsds.Lib : '*PGM' :                      //0008
                //0010 upsrc_name : uppgm_name : uplib_name : ' ' : uptimeStamp :
                upsrc_name : uppgm_name : uplib_name : ' ' : ' ' : uptimeStamp :         //0010
                'UPDATE');

*Inlr = *On;
/copy 'QCPYSRC/iacerrlog.rpgleinc'

//------------------------------------------------------------------------------------- //
//Extract List of procedures.
//------------------------------------------------------------------------------------- //
begsr ProcListSr;

   CrtUserSpace('OBJDESCUS QTEMP':'':131072:X'00':                                       //0003
                '*ALL':'Object description':'*YES':QUSEC) ;                              //0003

   GetPointer('OBJDESCUS QTEMP': pHeaderInfo);                                           //0003

   Select;                                                                               //0003
    when ObjType = '*MODULE';                                                            //0003
       GetModInf ('OBJDESCUS QTEMP' : 'MODL0100' :                                       //0003
                 ObjName + ObjLib : ErrorInfo );                                         //0003

       ProcType = 'EXPORT';
       exsr LoadSr;

       GetModInf ('OBJDESCUS QTEMP' : 'MODL0200' :                                       //0003
                   ObjName + ObjLib : ErrorInfo );                                       //0003

       ProcType = 'IMPORT';
       exsr LoadSr;

    when ObjType = '*SRVPGM';                                                            //0003
       GetSrvPgmInf ('OBJDESCUS QTEMP' : 'SPGL0600' :                                    //0003
                      ObjName + ObjLib : ErrorInfo );                                    //0003
                                                                                         //0003
       ProcType = 'EXPORT';                                                              //0003
       exsr SrvPgm_Loadsr;                                                               //0003
                                                                                         //0003
   endsl;                                                                                //0003
                                                                                         //0003
   DltUserSpace('OBJDESCUS QTEMP':ErrorInfo);                                            //0003
endsr;

//------------------------------------------------------------------------------------- //
//Load into intermediate table IAPROCDTLP
//------------------------------------------------------------------------------------- //
begsr LoadSr;

   pModL0100 = pHeaderInfo + ListOffset;
   ProcName_StartPos = 47;                                                               //0004
   for Index = 1 to NbrEntries;

      NextModPos = %scan(ObjName:ProcList:ProcName_StartPos+1);                          //0004
      if NextModPos > 0;                                                                 //0004
         ProcName = %subst(ProcList:ProcName_StartPos:NextModPos-ProcName_StartPos-4);   //0004
      else;                                                                              //0004
         //Last Procedure in ProcList                                                   //0004
         procname = %subst(ProcList:ProcName_StartPos);                                  //0004
      endif;                                                                             //0004

      if %Scan('_QRN':ProcName) <> 0 or
         %Scan('Q LE':ProcName) <> 0 or
         %Scan('CEE':ProcName) <> 0;
      else;
         if %Scan(' ':ProcName) <> 0;
            ProcName = %Trim(Procname);
         else;
            ProcName = %Trim(Procname: X'00') ;
         endif;

         Clear RcdCnt;
         exec sql
          select Count(*)
           into :RcdCnt
           from  iAProcDtlp                                                              //0003
           where Object_Name      = trim(:ObjName)                                       //0003
             and Object_Library   = trim(:ObjLib)                                        //0003
             and Object_Attribute = trim(:ObjAttr)                                       //0003
             and Object_Text      = trim(:Objtext)                                       //0003
             and Object_Type      = '*MODULE'                                            //0003
             and Procedure_Name   = trim(:ProcName)                                      //0003
             and Procedure_Type   = trim(:ProcType);                                     //0003

         if RcdCnt = *Zero;
            exec sql
              insert into iAProcDtlp(Object_Name,                                        //0003
                                    Object_Library,                                      //0003
                                    Object_Attribute,                                    //0003
                                    Object_Type,                                         //0003
                                    Object_Text,                                         //0003
                                    Procedure_Name,                                      //0003
                                    Procedure_Type,                                      //0003
                                    Create_ByUser,                                       //0003
                                    Create_ByProgram)                                    //0003
                    values (trim(:ObjName),                                              //0003
                            trim(:ObjLib),                                               //0003
                            trim(:ObjAttr),                                              //0003
                            '*MODULE',                                                   //0003
                            trim(:Objtext),                                              //0003
                            trim(:ProcName),                                             //0003
                            trim(:ProcType),                                             //0003
                            trim(:wkuDpsds.User),                                        //0003
                            trim(:wkuDpsds.SrcMbr));                                     //0003
         endif;

         if sqlCode < successCode;
            uDpsds.wkQuery_Name = 'Insert_Module_iAProcDtlp';                            //0003
            IaSqlDiagnostic(uDpsds);                                                     //0009
         endif;

      endif;
      ProcName_StartPos = NextModPos + 42;                                               //0004
   endfor;
endsr;

//------------------------------------------------------------------------------------- //
//Load Service Program procedures into intermediate table IAPROCDTLP
//------------------------------------------------------------------------------------- //
begsr SrvPgm_Loadsr;                                                                     //0003

   EndPos = 1;                                                                           //0003
   StrPos = 1;                                                                           //0003
   pSPGL0600 = pHeaderInfo + ListOffset;                                                 //0003
   for Index = 1 to NbrEntries;                                                          //0003

      //If nothing left for parsing come out of the loop.
      if EndPos = 0  or EndPos >= %Len(%trim(SrvPgm_ProcList));                          //0003
         Leave ;                                                                         //0003
      endif ;                                                                            //0003

      StrPos = %Scan(ObjName:SrvPgm_ProcList:EndPos);                                    //0003
      EndPos = %Scan(ObjName:SrvPgm_ProcList:StrPos+10);                                 //0003
                                                                                         //0003
      if EndPos <> 0;                                                                    //0003
         ProcLen = EndPos - StrPos;                                                      //0003
      else;                                                                              //0003
         ProcLen = %Len(%TrimR(%SubSt(SrvPgm_ProcList:StrPos): X'00'));                  //0003
      endif;                                                                             //0003
                                                                                         //0003
      SrvPgm_OutDs = %SubSt(SrvPgm_ProcList:StrPos:ProcLen);                             //0003
                                                                                         //0003
      if %Scan('_QRN':SrvPgm_ProcName) <> 0 or                                           //0003
         %Scan('Q LE':SrvPgm_ProcName) <> 0 or                                           //0003
         %Scan('CEE':SrvPgm_ProcName) <> 0;                                              //0003
      else;                                                                              //0003
         if %Scan(' ':SrvPgm_ProcName) <> 0;                                             //0003
            SrvPgm_ProcName = %Trim(SrvPgm_ProcName);                                    //0003
         else;                                                                           //0003
            SrvPgm_ProcName = %Trim(SrvPgm_ProcName: X'00');                             //0003
         endif;                                                                          //0003
                                                                                         //0003
         Clear RcdCnt;                                                                   //0003
         exec sql                                                                        //0003
           select Count(*)                                                               //0003
             into :RcdCnt                                                                //0003
           from  iAProcDtlp                                                              //0003
           where Object_Name      = trim(:ObjName)                                       //0003
             and Object_Library   = trim(:ObjLib)                                        //0003
             and Object_Attribute = trim(:ObjAttr)                                       //0003
             and Object_Text      = trim(:Objtext)                                       //0003
             and Object_Type      = '*SRVPGM'                                            //0003
             and Procedure_Name   = trim(:SrvPgm_ProcName);                              //0003
                                                                                         //0003
         if RcdCnt = *Zero;                                                              //0003
            exec sql                                                                     //0003
              insert into iAProcDtlp(Object_Name,                                        //0003
                                     Object_Library,                                     //0003
                                     Object_Attribute,                                   //0003
                                     Object_Type,                                        //0003
                                     Object_Text,                                        //0003
                                     Procedure_Name,                                     //0003
                                     Procedure_Type,                                     //0003
                                     Create_ByUser,                                      //0003
                                     Create_ByProgram)                                   //0003
                             values (trim(:ObjName),                                     //0003
                                     trim(:ObjLib),                                      //0003
                                     trim(:ObjAttr),                                     //0003
                                     '*SRVPGM',                                          //0003
                                     trim(:Objtext),                                     //0003
                                     trim(:SrvPgm_ProcName),                             //0003
                                     trim(:ProcType),                                    //0003
                                     trim(:wkuDpsds.User),                               //0003
                                     trim(:wkuDpsds.SrcMbr));                            //0003
         endif;                                                                          //0003
                                                                                         //0003
         if sqlCode < successCode;                                                       //0003
            uDpsds.wkQuery_Name = 'Insert_SrvPgm_iAProcDtlp';                            //0003
            IaSqlDiagnostic(uDpsds);                                                     //0009
         endif;                                                                          //0003
                                                                                         //0003
      endif;                                                                             //0003

   endfor;                                                                               //0003

endsr;                                                                                   //0003

//------------------------------------------------------------------------------------- //
//Clear the table
//------------------------------------------------------------------------------------- //
begsr *InzSr;

   //Retrieve value from Data Area                                                      //0006
   in IaMetaInfo;                                                                        //0006

   if runMode <> 'REFRESH';                                                              //0006

      exec sql delete from iAProcDtlp;                                                   //0003
      if sqlCode < successCode;
         uDpsds.wkQuery_Name = 'Delete_iAProcDtlp';                                      //0003
         IaSqlDiagnostic(uDpsds);                                                        //0009
      endif;

   endif;                                                                                //0006

endsr;

//------------------------------------------------------------------------------------- //0005
//Delete Object descriptions - *PGM and *SRVPGM                                         //0005
//------------------------------------------------------------------------------------- //0005
begSr deleteSrvPgmObjects;                                                               //0005
                                                                                         //0005
   exec sql                                                                              //0005
      delete                                                                             //0005
      from  iAProcDtlp                                                                   //0005
      where Object_Name      = trim(:ObjName)                                            //0005
        and Object_Library   = trim(:ObjLib)                                             //0005
        and Object_Type      = trim(:ObjType)                                            //0005
        and Object_Attribute = trim(:ObjAttr);                                           //0005
                                                                                         //0005
   if sqlCode < successCode;                                                             //0005
      uDpsds.wkQuery_Name = 'Delete_iAProcDtlp';                                         //0005
      IaSqlDiagnostic(uDpsds);                                                           //0009
   endif;                                                                                //0005
                                                                                         //0005
endSr;                                                                                   //0005
