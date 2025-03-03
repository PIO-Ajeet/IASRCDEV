**free
      //%METADATA                                                      *
      // %TEXT Write Command References                                *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------- //
//Created By  :  Programmers.io @ 2021                                                  //
//Created Date:  2021/12/15                                                             //
//Developer   :  Rohini Alagarsamy                                                      //
//Description :  Write Command object references using API QCDRCMDI                     //
//                                                                                      //
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
//20/10/23| 0001   |Abhijith    | Metadata refresh process changes (Task#299)           //
//        |        |Ravindran   |                                                       //
//27/11/23| 0002   |Kunal P.    | Metadata refresh process changes (Task#402)           //
//29/12/23| 0003   |Venkatesh   | Added logic to get Reference object library when      //
//        |        |  Battula   |    it was *LIBL. [Task#: 430]                         //
//05/12/23| 0004   |Abhijit C.  | Enhancement to Refresh process.Changes                //
//        |        |            | related to IAOBJECT file.(Task#441)                   //
//18/01/24| 0005   |Venkatesh   | Removed Task#430 logic as we have new IAUPREFLIB pgm  //
//        |        |  Battula   |    to update Ref object library.  [Task#: 523]        //
//06/06/24| 0006   |Saumya      | Rename AIEXCTIMR to IAEXCTIMR [Task#: 262]            //
//04/07/24| 0007   |Akhil K.    | Rename AIERRBND, AICERRLOG, AIDERRLOG and             //
//        |        |            | AISQLDIAGNOSTIC with IA*  [Task# 261]                 //
// 16/08/24| 0008   |Sabarish    | IFS Member Parsing Feature                            //
//------------------------------------------------------------------------------------- //
ctl-opt copyright('Programmers.io Â© 2021');
ctl-opt option(*NoDebugIO : *SrcStmt : *noUnRef);
ctl-opt dftactgrp(*no);
ctl-opt bndDir('IAERRBND');                                                              //0007
//------------------------------------------------------------------------------------- //
//Variable Declaration
//------------------------------------------------------------------------------------- //
dcl-s ErrorInfo       char(1070);
dcl-s Rcv_Format      char(8)      inz('CMDI0100');
dcl-s uppgm_name      char(10)     inz;
dcl-s uplib_name      char(10)     inz;
dcl-s upsrc_name      char(10)     inz;
dcl-s uwCmdName       char(10)     inz;
dcl-s uwLibName       char(10)     inz;
dcl-s uwObjType       char(10)     inz;
dcl-s wkSqlText1      char(1000)   inz;                                                  //0004

dcl-s Rcv_Len         int(10)      inz(500);

dcl-s RowsFetched     uns(5);
dcl-s noOfRows        uns(5);
dcl-s uwindx          uns(5);

dcl-s rowFound        ind          inz('0');

dcl-s uptimestamp     Timestamp;

//------------------------------------------------------------------------------------- //
//Constant Declaration
//------------------------------------------------------------------------------------- //
dcl-c TRUE            '1';
dcl-c FALSE           '0';

//------------------------------------------------------------------------------------- //
//Data Structure Declaration
//------------------------------------------------------------------------------------- //
dcl-ds Cmd_Ds;
   Cmd_Name   char(10) Pos(  9);   //Command Name
   Cmd_Lib    char(10) Pos( 19);   //Command Library
   ProcPgmNam char(10) Pos( 29);   //Process Program Name
   ProcPgmLib char(10) Pos( 39);   //Process Library Name
   ValChkpgm  char(10) Pos( 79);   //Validity Check Pgm Name
   ValChkLib  char(10) Pos( 89);   //Validity Check Pgm Lib Name
   Cmd_Desc   char(50) Pos(265);   //Description
end-ds;

dcl-ds CmdInfoDS qualified dim(999);
   CmdName char(10) inz;
   LibName char(10) inz;
   ObjType char(10) inz;
end-ds;

//Data structure declaration                                                            //0001
dcl-ds iaMetaInfo dtaara len(62);                                                        //0001
   runMode char(7) pos(1);                                                               //0001
end-ds;                                                                                  //0001

//------------------------------------------------------------------------------------- //
//Prototype Declaration
//------------------------------------------------------------------------------------- //
dcl-pr RtvCmdRef extpgm('QCDRCMDI');
   *n char(110);
   *n int (10 ) const;
   *n char(8  ) const;
   *n char(20 ) const;
   *n char(32767) options(*varsize:*noPass);
end-pr;

dcl-pr IAEXCTIMR extpgm('IAEXCTIMR');                                                    //0006
    *n Char(10) Const;
    *n Char(10);
    *n Char(10);
    *n Char(10) Const;
    *n Char(10);
    *n Char(10);
    *n Char(10);
    *n Char(100) Const;                                                                  //0008
    *n Char(10) Const;
    *n Timestamp;
    *n Char(6) Const;
end-pr;

//------------------------------------------------------------------------------------- //
//Copybook Declaration
//------------------------------------------------------------------------------------- //
/copy 'QCPYSRC/iaderrlog.rpgleinc'

//------------------------------------------------------------------------------------- //0003
//Entry Parameter                                                                       //0003
//------------------------------------------------------------------------------------- //0003
dcl-pi IACMDREFD  extpgm('IACMDREFD');                                                   //0003
   xref char(10);                                                                        //0003
end-pi;                                                                                  //0003

//------------------------------------------------------------------------------------ //
//Set options
//------------------------------------------------------------------------------------ //
exec sql
  set option Commit = *None,
             Naming = *Sys,
             DynUsrPrf = *User,
             CloSqlCsr = *EndMod;

//Retrieve value from Data Area                                                         //0001
in IaMetaInfo;                                                                           //0001

//------------------------------------------------------------------------------------- //
//Declare cursor
//------------------------------------------------------------------------------------- //
                                                                                   //0001//0004
//If Process is 'INIT'                                                                  //0004
if runmode = 'INIT';                                                                     //0004
   wksqltext1 =                                                                          //0004
      ' select IaObjNam, IaLibNam, IaObjTyp' +                                           //0004
      ' from IaObject'                       +                                           //0004
      ' where IaObjTyp = ''*CMD'' ';                                                     //0004
                                                                                         //0004
//If Process is 'REFRESH'                                                               //0004
elseif runmode = 'REFRESH';                                                              //0004
   wksqltext1 =                                                                          //0004
      ' select IaObjNam, IaLibNam, IaObjTyp' +                                           //0004
      ' from IaObject'                       +                                           //0004
      ' where IaObjTyp = ''*CMD'' and'       +                                           //0004
      ' IaRefresh in (''A'' ,''M'')';                                                    //0004
endif;                                                                                   //0004

//Declare cusrsor for Command Objects retrieve details.                                 //0004
exec sql prepare cmdstmt from :wksqltext1 ;                                              //0004
exec sql declare Command_Object cursor for cmdstmt;                                      //0004

//------------------------------------------------------------------------------------- //
//Main logic
//------------------------------------------------------------------------------------- //
Eval-corr uDpsds = wkuDpsds;

//Insert process start time
uptimeStamp = %Timestamp();
CallP IAEXCTIMR('BLDMTADTA' :udpsds.ProcNme : udpsds.Lib : '*PGM' :                      //0006
   //upsrc_name : uppgm_name : uplib_name : ' ' : uptimeStamp : 'INSERT');               //0008
   upsrc_name : uppgm_name : uplib_name : ' ' : ' ' : uptimeStamp : 'INSERT');           //0008

//Open cursor
exec sql open Command_Object;
if sqlCode = CSR_OPN_COD;
  exec sql close Command_Object;
  exec sql open  Command_Object;
endif;

if sqlCode < successCode;
   uDpsds.wkQuery_Name = 'Open_Cursor_Command_Object';
   IaSqlDiagnostic(uDpsds);                                                              //0007
endif;

//Get the number of elements
noOfRows = %elem(CmdInfoDS);

//Fetch records from Command_Object cursor
rowFound = fetchRecordCmdObjCursor();

dow rowFound;
   for uwindx = 1 to RowsFetched;
      if runMode = 'REFRESH';                                                            //0001
         exSr DltInfo;                                                                   //0001
      endIf;                                                                             //0001
      exsr CmdInfo;
   endfor;

   //if fetched rows are less than the array elements then come out of the loop.
   if RowsFetched < noOfRows ;
      leave ;
   endif ;

   //Fetch records from Command_Object cursor
   rowFound = fetchRecordCmdObjCursor();
enddo;

//Close cursor
exec sql close Command_Object;

//Update process end time
UPTimeStamp = %Timestamp();
CallP IAEXCTIMR('BLDMTADTA' :udpsds.ProcNme : udpsds.Lib : '*PGM' :                      //0006
   //upsrc_name : uppgm_name : uplib_name : ' ' : uptimeStamp : 'UPDATE');               //0008
   upsrc_name : uppgm_name : uplib_name : ' ' : ' ' : uptimeStamp : 'UPDATE');           //0008

*Inlr = *On;
/copy 'QCPYSRC/iacerrlog.rpgleinc'

//------------------------------------------------------------------------------------- //
//Command Info :- Retrieve Command Reference information.
//------------------------------------------------------------------------------------- //
begsr CmdInfo;

   clear uwCmdName;
   clear uwLibName;
   clear uwObjType;

   uwCmdName = CmdInfoDS(uwindx).CmdName;
   uwLibName = CmdInfoDS(uwindx).LibName;
   uwObjType = CmdInfoDS(uwindx).ObjType;

   RtvCmdRef (Cmd_ds:Rcv_len:Rcv_Format:uwCmdName + uwLibName:ErrorInfo);

   if ProcPgmNam <> ' ' and ProcPgmNam <> '*NONE';

      exec sql
        insert into IaAllRefPf (Library_Name,
                                Object_Name,
                                Object_Type,
                                Object_Text,
                                Referenced_Obj,
                                Referenced_ObjTyp,
                                Referenced_ObjLib,
                                Referenced_ObjUsg,
                                Crt_Pgm_Name,
                                Crt_Usr_Name)
          values (trim(:Cmd_Lib),
                  trim(:Cmd_Name),
                  trim(:uwObjType),
                  trim(:Cmd_Desc),
                  trim(:ProcPgmNam),
                  '*PGM',
                  trim(:ProcPgmLib),
                  'I',
                  trim(:uDpsds.SrcMbr),
                  trim(:uDpsds.User));

      if sqlCode < successCode;
         uDpsds.wkQuery_Name = 'Insert_1_IaAllRefPf';
         IaSqlDiagnostic(uDpsds);                                                        //0007
      endif;

   endif;

   if ValChkpgm <> ' ' and ValChkpgm <> '*NONE';

      exec sql
        insert into IaAllRefPf (Library_Name,
                                Object_Name,
                                Object_Type,
                                Object_Text,
                                Referenced_Obj,
                                Referenced_ObjTyp,
                                Referenced_ObjLib,
                                Referenced_ObjUsg,
                                Crt_Pgm_Name,
                                Crt_Usr_Name)
          values (trim(:Cmd_Lib),
                  trim(:Cmd_Name),
                  trim(:uwObjType),
                  trim(:Cmd_Desc),
                  trim(:ValChkPgm),
                  '*PGM',
                  trim(:ValChkLib),
                  'I',
                  trim(:uDpsds.SrcMbr),
                  trim(:uDpsds.User));

      if sqlCode < successCode;
         uDpsds.wkQuery_Name = 'Insert_2_IaAllRefPf';
         IaSqlDiagnostic(uDpsds);                                                        //0007
      endif;

   endif;

endsr;

//------------------------------------------------------------------------------------- //
//Delete Command Info : Delete Command Info for refesh if already present
//------------------------------------------------------------------------------------- //
begsr DltInfo;                                                                           //0001
                                                                                         //0001
   uwCmdName = CmdInfoDS(uwindx).CmdName;                                                //0001
   uwLibName = CmdInfoDS(uwindx).LibName;                                                //0001
   uwObjType = CmdInfoDS(uwindx).ObjType;                                                //0001
                                                                                         //0001
   //Delete existing entries
   exec sql                                                                              //0001
     delete                                                                              //0001
       from  IaAllRefPf                                                                  //0001
      where  Library_Name = :uwLibName                                                   //0001
        and  Object_Name = :uwCmdName                                                    //0001
        and  Object_Type = :uwObjType                                                    //0001
        and  Crt_Pgm_Name = :udpsds.procnme;                                             //0002
                                                                                         //0001
   if sqlCode < successCode;                                                             //0001
      uDpsds.wkQuery_Name = 'Delete_IaAllRefPf';                                         //0001
      IaSqlDiagnostic(uDpsds);                                                           //0001 0007
   endif;                                                                                //0001
                                                                                         //0001
endSr;                                                                                   //0001

//------------------------------------------------------------------------------------- //
//Procedure makeBndDirEntry: Write references of binding directory
//------------------------------------------------------------------------------------- //
dcl-proc fetchRecordCmdObjCursor;

   dcl-pi fetchRecordCmdObjCursor ind end-pi ;

   dcl-s  rcdFound ind inz('0');
   dcl-s  wkRowNum like(RowsFetched) ;

   RowsFetched = *zeros;
   clear CmdInfoDs;

   exec sql
      fetch Command_Object for :noOfRows rows into :CmdInfoDs;

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
