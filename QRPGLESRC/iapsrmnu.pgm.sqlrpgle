**free
      //%METADATA                                                      *
      // %TEXT IA MENU source parser                                   *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------- //
//Created By    : Programmers.io @ 2023                                                 //
//Created Date  : 2023/08/28                                                            //
//Developer     : Abhijit Charhate                                                      //
//Description   : This program parses source members that are having type 'MNUCMD'      //
//                                                                                      //
//Procedure Log:                                                                        //
//------------------------------------------------------------------------------------- //
//Procedure Name           | Procedure Description                                      //
//-------------------------|----------------------------------------------------------- //
//ProcessSourceData        |                                                            //
//Write_RRN1_Error         |                                                            //
//------------------------------------------------------------------------------------- //
//                                                                                      //
//Modification Log:                                                                     //
//------------------------------------------------------------------------------------- //
//Date    | Mod_ID | Developer  | Case and Description                                  //
//--------|--------|------------|------------------------------------------------------ //
//23/11/02| 0001   | Abhijit    | Need to change the usage filed to literal value       //
//        |        | Charhate   | instead of decimal.(Task#312)                         //
//23/12/06| 0002   | Alok Kumar | Fixed truncation issue in program name. As of now     //
//        |        |            | qualified program name is being truncated to 15 chars //
//        |        |            | only and wrong program name ib being written in       //
//        |        |            | outfiles. (Task#440)                                  //
//        |        |            |                                                       //
//23/12/15| 0003   | Akhil K.   | The reference program information should be updated   //
//        |        |            | in IAALLREFPF if commands in MNUCMD member is added   //
//        |        |            | or modified or removed.(Task#462)                     //
//23/10/13| 0004   | Rituraj    | Changed file name AIEXCTIME to IAEXCTIME [Task #248]  //
//23/10/05| 0005   | Khushi W   | Rename program AIMBRPRSER to IAMBRPRSER. [Task #263]  //
//05/07/24| 0006   | Akhil K.   | Renamed AIERRBND, AICERRLOG, AIDERRLOG and AISQLDIAGNO//
//        |        |            | STIC with IA*                                         //
//21/08/24| 0007   | Sabarish   | IFS Member Parsing Upgrade. [Task #833]               //
//------------------------------------------------------------------------------------- //
ctl-opt CopyRight('Copyright @ Programmers.io © 2023');
ctl-opt Option(*SrcStmt:*NoDebugIo:*NoUnRef);
ctl-opt BndDir('IABNDDIR' : 'IAERRBND');                                                 //0006

//------------------------------------------------------------------------------------- //
//Prototypes declaration
//------------------------------------------------------------------------------------- //
dcl-pr IAEXCTIMR extpgm('IAEXCTIMR');                                                    //0004
   *n Char(10) Const;
   *n Char(10);
   *n Char(10);
   *n Char(10) Const;
   *n Char(10);
   *n Char(10);
   *n Char(10);
   *n Char(100) Const;                                                                   //0007
   *n Char(10) Const;
   *n Timestamp;
   *n Char(6) Const;
end-pr;

dcl-pi IAPSRMNU extpgm('IAPSRMNU');
   in_Repository    char(10);
   UpSrcDtl         like(UwSrcDtl);
end-pi;

//------------------------------------------------------------------------------------- //
//Data structure declaration
//------------------------------------------------------------------------------------- //
dcl-ds UwSrcDtl qualified inz;
   srclib char(10);
   srcSpf char(10);
   srcmbr char(10);
   ifsloc char(100);                                                                     //0007
   srcType char(10);
end-ds;

dcl-ds UwObjDtl qualified inz;                                                           //0003
   objLib char(10);                                                                      //0003
   objNam char(10);                                                                      //0003
   objType char(10);                                                                     //0003
end-ds;                                                                                  //0003

dcl-ds iaMetaInfo dtaara len(62);                                                        //0003
   runMode char(7) pos(1);                                                               //0003
end-ds;                                                                                  //0003

//------------------------------------------------------------------------------------- //
//Standalone Variables
//------------------------------------------------------------------------------------- //
dcl-s wk_SourceStm    char(4046)   inz;
dcl-s wk_SourceRrn    packed(6:0)  inz;
dcl-s uwBlankPos      packed(3:0)  inz;
dcl-s uwCloseBrkt     packed(3:0)  inz;
dcl-s uwNonBlankPos   packed(3:0)  inz;
dcl-s uwPgmPos        packed(3:0)  inz;
dcl-s uwSlashPos      packed(3:0)  inz;
dcl-s uwRefObj        char(21)     inz;                                                  //0002
dcl-s uptimestamp     Timestamp;

//------------------------------------------------------------------------------------- //
//Constant declaration
//------------------------------------------------------------------------------------- //
dcl-c w_lo                 'abcdefghijklmnopqrstuvwxyz';
dcl-c w_Up                 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

//------------------------------------------------------------------------------------- //
//CopyBook declaration
//------------------------------------------------------------------------------------- //
/copy 'QMODSRC/iasrv01pr.rpgleinc'
/copy 'QMODSRC/iasrv02pr.rpgleinc'
/copy 'QCPYSRC/iaderrlog.rpgleinc'

//------------------------------------------------------------------------------------- //
//Mainline programming
//------------------------------------------------------------------------------------- //
exec sql
  set option commit    = *none,
             naming    = *sys,
             usrprf    = *user,
             dynusrprf = *user,
             closqlcsr = *endmod;

Eval-corr uDpsds = wkuDpsds;
UwSrcDtl = UpSrcDtl;

//Populate the file IAEXCTIME with start time
uptimeStamp = %Timestamp();
CallP IAEXCTIMR('IAMBRPRSER' :udpsds.ProcNme : udpsds.Lib : '*PGM' :                     //0005
                UwSrcDtl.srcSpf:uwsrcdtl.srcmbr : uwsrcdtl.srclib :
       //0007   UwSrcDtl.srcType: uptimeStamp : 'INSERT');
                ' ' : UwSrcDtl.srcType: uptimeStamp : 'INSERT');                         //0007

//To know if the job is in 'REFRESH' mode or not.                                       //0003
In *lock iaMetaInfo;                                                                     //0003
if runMode = 'REFRESH';                                                                  //0003
   clrRefreshData();                                                                     //0003
endif;                                                                                   //0003

//Process the source statments to get references
processSourceData();

//Populate the file IAEXCTIME with end time
uptimeStamp = %Timestamp();
CallP IAEXCTIMR('IAMBRPRSER' :udpsds.ProcNme : udpsds.Lib : '*PGM' :                     //0005
                UwSrcDtl.srcSpf:uwsrcdtl.srcmbr : uwsrcdtl.srclib :
       //0007   UwSrcDtl.srcType : uptimeStamp : 'UPDATE');
                ' ' : UwSrcDtl.srcType : uptimeStamp : 'UPDATE');                        //0007

*inlr = *on;

/copy 'QCPYSRC/iacerrlog.rpgleinc'

//------------------------------------------------------------------------------------- //
//ProcessSourceData : To process each source line of a member
//------------------------------------------------------------------------------------- //
dcl-proc ProcessSourceData;

   //Stanalone variables
   dcl-s w_SourceString  char(5000)  inz;
   dcl-s wk_Stm          char(120)   inz;
   dcl-s w_LibName       char(10)    inz;
   dcl-s wk_Rrn          packed(6:0) inz;
   dcl-s w_Usage         char(10)    inz('I');                                           //0001

   //Data Structure Definition
   dcl-ds w_IASRCINTPF  extName('IASRCINTPF') qualified inz end-ds;

   //Cursor declaration
   exec sql
     declare SrcStmt cursor for
       select SOURCE_DATA, SOURCE_RRN
         from IAQDDSSRC
       where  Library_Name  = trim(:uwSrcDtl.SrcLib)
         and  SourcePf_Name = trim(:uwSrcDtl.SrcSpf)
         and  Member_Name   = trim(:uwSrcDtl.SrcMbr)
         and  Source_Data   <> ' '
       order by Source_Rrn ;

   //Open cursor
   exec sql open SrcStmt;
   if sqlCode = CSR_OPN_COD;
      exec sql close SrcStmt;
      exec sql open  SrcStmt;
   endif;

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Open_SrcStmt';
      IaSqlDiagnostic(uDpsds);                                                           //0006
   endif;

   //Fetch first record
   exec sql fetch SrcStmt into :Wk_Stm, :Wk_Rrn;
   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Fetch_1_SrcStmt';
      IaSqlDiagnostic(uDpsds);                                                           //0006
   endif;

   dow sqlCode = successCode;

      clear Wk_SourceStm;
      clear Wk_SourceRrn;
      clear uwBlankPos;
      clear uwCloseBrkt;
      clear uwNonBlankPos;
      clear uwPgmPos;
      clear uwSlashPos;

      monitor;

      if wk_stm <> *blanks;

         w_SourceString = %xlate(w_lo:w_Up:wk_stm);

         //parse the constant characters for menu
         w_SourceString = %trim(%subst(w_SourceString:(%scan(' ':w_SourceString:1))));

         //if it is blank the process the next record
         if w_SourceString = *blanks;

            exec sql fetch SrcStmt into :Wk_Stm, :Wk_Rrn;
            if sqlCode < successCode;
               uDpsds.wkQuery_Name = 'Fetch_2_SrcStmt';
               IaSqlDiagnostic(uDpsds);                                                  //0006
               leave;
            endif;

            iter;
         endif;

         //Get the blank position
         uwBlankPos = %scan(' ': w_SourceString:1);

         select;
            //Get reference from CALL command
            when uwBlankPos > 0 and %subst(w_SourceString:1:uwBlankPos-1) = 'CALL';

               select;

                  //Get reference from "PGM("
                  when %scan('PGM(': w_SourceString:uwBlankPos) > 0;
                     uwPgmPos  = %scan('PGM(': w_SourceString:uwBlankPos);
                     uwCloseBrkt = %scan(')': w_SourceString:uwPgmPos+4);

                     if uwCloseBrkt > 0 and uwCloseBrkt > uwPgmPos+4;
                        uwRefObj = %trim(%subst(w_SourceString:uwPgmPos+4
                                                    :uwCloseBrkt-uwPgmPos-4));
                        w_iASrcIntpf.iARefObj = uwRefObj;
                     endif;

                  other;
                     uwNonBlankPos = %check(' ': w_SourceString:uwBlankPos);

                     //If it is CALL (ProgramName) then get the position of close bracket
                     //in order to remove the extra blank space e.g. CALL ( ProgramName )
                     if %subst(w_SourceString:uwNonBlankPos:1) = '(';

                        uwBlankPos = %scan(')': w_SourceString:uwNonBlankPos);
                        if uwBlankPos > (uwNonBlankPos+1);
                           uwRefObj = %trim(%subst(w_SourceString:uwNonBlankPos+1
                                                    :uwBlankPos-uwNonBlankPos-1));
                           w_iASrcIntpf.iARefObj = uwRefObj;
                        endif;

                     else;

                        //Else, get the blank position
                        uwBlankPos = %scan(' ': w_SourceString:uwNonBlankPos);
                        if uwBlankPos > uwNonBlankPos;
                           uwRefObj = %trim(%subst(w_SourceString:uwNonBlankPos
                                                    :uwBlankPos-uwNonBlankPos));
                           w_iASrcIntpf.iARefObj = uwRefObj;
                        endif;

                     endif;

               endsl;

               clear w_LibName;
               //Check whether it is qualified name or not
               if uwRefObj <> *blanks and %scan('/':uwRefObj)  > 0;
                  uwSlashPos = %scan('/':uwRefObj);
                  w_LibName = %subst(uwRefObj:1:uwSlashPos-1);
                  w_iASrcIntpf.iARefObj = %trim(%subst(uwRefObj:uwSlashPos+1));
               endif;

            other;
               //Do nothing

         endsl;

         //Populate the *MENU references in IASRCINTPF file
         if w_iASrcIntpf.iARefObj <> *Blanks;
            wrtSrcIntRefF(uwSrcDtl.Srclib
                         :uwSrcDtl.SrcSpf
                         :uwSrcDtl.SrcMbr
                         :UwSrcDtl.ifsloc                                                //0007
                         :uwSrcDtl.SrcType
                         :w_iASrcIntpf.iaRefObj
                         :'*PGM'
                         :w_LibName
                         :w_Usage
                         :'MNUCMD'
                         );
         endif;

      endif;

      on-error;
         Wk_SourceRrn = Wk_Rrn ;
         Wk_SourceStm = %trim(wk_stm);
         Write_RRN1_Error () ;
      endmon;

      //Fetch first record
      exec sql fetch SrcStmt into :Wk_Stm, :Wk_Rrn;
      if sqlCode < successCode;
         uDpsds.wkQuery_Name = 'Fetch_3_SrcStmt';
         IaSqlDiagnostic(uDpsds);                                                        //0006
      endif;

   enddo;

   exec sql close SrcStmt;

end-proc;

//------------------------------------------------------------------------------------- //
//Write_RRN1_Error :
//------------------------------------------------------------------------------------- //
dcl-proc Write_RRN1_Error;

   exec sql
     insert into iAExcPLog (Prs_Source_Lib,
                            Prs_Source_File,
                            PRS_SOURCE_SRC_MBR,
                            Library_Name,
                            Program_Name,
                            Rrn_No,
                            Exception_Type,
                            Exception_No,
                            Exception_Data,
                            Source_Stm,
                            Module_Pgm,
                            Module_Proc)
       values(trim(:uwSrcDtl.SrcLib),
                trim(:uwSrcDtl.SrcSpf),
                trim(:uwSrcDtl.SrcMbr),
                trim(:uDpsds.SrcLib),
                trim(:uDpsds.ProcNme),
                trim(char(:Wk_SourceRrn)),
                trim(:uDpsds.ExcpTTyp),
                trim(:uDpsds.ExcpTNbr)    ,
                trim(:uDpsds.RtvExcPTdt)   ,
                trim(:Wk_SourceStm),
                trim(:uDpsds.ModulePgm),
                trim(:uDpsds.ModuleProc));

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Insert_IAEXCPLOG';
      IaSqlDiagnostic(uDpsds);                                                           //0006
   endif;

end-proc;

//------------------------------------------------------------------------------------- //0003
//To delete records in IAALLREFPF file for modified MNUCMD members.                     //0003
//------------------------------------------------------------------------------------- //0003
dcl-proc clrRefreshData ;                                                                //0003
                                                                                         //0003
    exec sql                                                                             //0003
      select iAObjLib, iAObjNam, iAObjTyp                                                //0003
        into :uwObjDtl                                                                   //0003
        from iAObjMap                                                                    //0003
       where iAMbrLib  = trim(:uwSrcDtl.srcLib)                                          //0003
         and iAMbrSrcF = trim(:uwSrcDtl.srcSpf)                                          //0003
         and iAMbrNam  = trim(:uwSrcDtl.srcMbr)                                          //0003
         and iAMbrTyp  = trim(:uwSrcDtl.srcType);                                        //0003
                                                                                         //0003
    if sqlCode < successCode;                                                            //0003
       uDpsds.wkQuery_Name = 'Select_IAOBJMAP';                                          //0003
       IaSqlDiagnostic(uDpsds);                                                          //0006
    endif;                                                                               //0003
                                                                                         //0003
    if sqlCode = successCode;                                                            //0003
       exec sql                                                                          //0003
         delete from iAAllRefPf                                                          //0003
               where iAOObjLib = trim(:uwObjDtl.objLib)                                  //0003
                 and iAOObjNam = trim(:uwObjDtl.objNam)                                  //0003
                 and iAOObjTyp = trim(:uwObjDtl.objType);                                //0003
                                                                                         //0003
       if sqlCode < successCode;                                                         //0003
          uDpsds.wkQuery_Name = 'Delete_IAALLREFPF';                                     //0003
          IaSqlDiagnostic(uDpsds);                                                       //0006
       endif;                                                                            //0003
    endif;                                                                               //0003

end-proc;                                                                                //0003
