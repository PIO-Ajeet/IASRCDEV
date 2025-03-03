**free
      //%METADATA                                                      *
      // %TEXT Purge refresh audit data from IAREFAUDF                 *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------- //
//Created By  :  Programmers.io @ 2024                                                  //
//Created Date:  02-Jan-2024                                                            //
//Developer   :  Venkatesh Battula                                                      //
//Description :  Purge refresh audit data from IAREFAUDF                                //
//Task#       :  506                                                                    //
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
//20/08/24| 0003   | Sabarish   | IFS Member Parsing Upgrade                            //
//------------------------------------------------------------------------------------- //
ctl-opt Copyright('Programmers.io Â© 2024');
ctl-opt option(*NoDebugIO : *SrcStmt : *noUnRef);
ctl-opt dftactgrp(*No);
ctl-opt bndDir('IAERRBND');                                                              //0002

//------------------------------------------------------------------------------------- //
//Variable Declaration
//------------------------------------------------------------------------------------- //
dcl-s uptimestamp     Timestamp;
dcl-s uppgm_name      char(10)     inz;
dcl-s uplib_name      char(10)     inz;
dcl-s upsrc_name      char(10)     inz;
dcl-s PurgeDays       Packed(6)    inz;
dcl-s PurgeDate       Char(26)     inz('9999-12-12-23.59.59.999999');

//------------------------------------------------------------------------------------- //
//Constant Declaration
//------------------------------------------------------------------------------------- //
dcl-c wProperty        'FEATURE.PURGE_REFRESH_AUDIT';

//-------------------------------------------------------------------------------------
//Prototype Declaration
//-------------------------------------------------------------------------------------
dcl-pr IAEXCTIMR extpgm('IAEXCTIMR');                                                    //0001
   *n Char(10) Const;
   *n Char(10);
   *n Char(10);
   *n Char(10) Const;
   *n Char(10);
   *n Char(10);
   *n Char(10);
   *n Char(100) Const;                                                                   //0003
   *n Char(10) Const;
   *n Timestamp;
   *n Char(6) Const;
end-pr;

//------------------------------------------------------------------------------------- //
//Copybook Declaration
//------------------------------------------------------------------------------------- //
/copy 'QCPYSRC/iaderrlog.rpgleinc'

//-------------------------------------------------------------------------------------
//Entry Parameter
//-------------------------------------------------------------------------------------
dcl-pi IAPURRFAUD extpgm('IAPURRFAUD');
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
   //0003 upsrc_name : uppgm_name : uplib_name : ' ' : uptimeStamp : 'INSERT');
   upsrc_name : uppgm_name : uplib_name : ' ' : ' ' : uptimeStamp : 'INSERT');           //0003

//Get days required to purge
exec sql
   select trim(IAPVALUE) into :PurgeDays
     from iAConFigT
    Where iAPKey = :wProperty;

if sqlcod = successCode;

   //Calculate purge date from purge days and Purge IAREFAUDF
   %Subst(PurgeDate:1:10) = %Char(%Date()-%Days(PurgeDays));

   exec sql
      delete from iARefAudF
            where iAStartTim < :PurgeDate;

   if sqlCode < successCode;
      uDpsds.wkQuery_Name = 'Delete_IAREFAUDF';
      IaSqlDiagnostic(uDpsds);                                                           //0002
   endif;

endif;

//Update process end time
UPTimeStamp = %Timestamp();
CallP IAEXCTIMR('BLDMTADTA' :udpsds.ProcNme : udpsds.Lib : '*PGM' :                      //0001
   //0003 upsrc_name : uppgm_name : uplib_name : ' ' : uptimeStamp : 'UPDATE');
   upsrc_name : uppgm_name : uplib_name : ' ' : ' ' : uptimeStamp : 'UPDATE');           //0003

*Inlr = *On;
/copy 'QCPYSRC/iacerrlog.rpgleinc'
