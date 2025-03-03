**free
      //%METADATA                                                      *
      // %TEXT IA PseudoCode generation Parallel submissions           *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------- //
//Created By  : Programmers.io @ 2024                                                   //
//Created Date: 30/05/2024                                                              //
//Developer   : Rishab Kaushik                                                          //
//Description : Program to run parallel threads for pseudocode generation               //
//                                                                                      //
//Procedure Log:                                                                        //
//------------------------------------------------------------------------------------- //
//Procedure Name              | Procedure Description                                   //
//----------------------------|---------------------------------------------------------//
//                            |                                                         //
//------------------------------------------------------------------------------------- //
//                                                                                      //
//Modification Log:                                                                     //
//------------------------------------------------------------------------------------- //
//Date-DMY| Mod_ID | Developer  | Case and Description                                  //
//--------|--------|------------|------------------------------------------------------ //
//04/07/24| 0001   | Vamsi      | Rename Bnddir AIERRBND, copybooks AICERRLOG/AIDERRLOG //
//        |        |            | and procedures AISQLDIAGNOSTIC and AIPSSRERRORLOG     //
//        |        |            | with IA*  [Task#261]                                  //
//        |        |            |                                                       //
//08/10/24| 0002   | HIMANSHUGA | Added parm to determine if commented text will be     //
//        |        |            | added in pseudo code text: Task-689                   //
//12/10/24| 0003   | Sribalaji  | On requesting bulk pseudo code from front end,        //
//        |        |            | associated job is not submitting.                     //
//        |        |            | Entry parameters 'inStartRRN' and 'inEndRRN' Changed  //
//        |        |            | as charecter. [Task #1081]                            //
//07/01/25| 0004   | HIMANSHUGA | Added parm to determine if declaration specs will be  //
//        |        |            | added in pseudo code : Task-1099                      //

//------------------------------------------------------------------------------------- //
Ctl-Opt CopyRight('Copyright @ Programmers.io © 2024');
Ctl-Opt Option(*NoDebugIo:*SrcStmt:*NoUnRef);
Ctl-Opt BndDir('IAERRBND' : 'IABNDDIR');                                                 //0001
//------------------------------------------------------------------------------------- //
//Variable Definitions
//------------------------------------------------------------------------------------- //
Dcl-s  wkStartRRN   Packed(10:0)  inz;                                                   //0003
Dcl-s  wkEndRRN     Packed(10:0)  inz;                                                   //0003
//------------------------------------------------------------------------------------- //
//Constant Definitions
//------------------------------------------------------------------------------------- //
//------------------------------------------------------------------------------------- //
//Data Structure Definition
//------------------------------------------------------------------------------------- //
dcl-ds detailDS;
  reqID  CHAR(18);
  libName CHAR(10);
  srcPfName CHAR(10);
  mbrName CHAR(10);
  mbrType CHAR(10);
  currentRRN packed(15:0);
end-ds;
//------------------------------------------------------------------------------------- //
//Entry Parameter
//------------------------------------------------------------------------------------- //
Dcl-Pi IAPSEUDOMR;
   inrequestID   Char(18);
   inRepoName    Char(10);
   inStartRRN    Char(10);
   inEndRRN      Char(10);
   inIncludeText Char(1);                                                                //0002
   inIncludeDeclSpecs Char(1);                                                           //0004
End-Pi;
//------------------------------------------------------------------------------------- //
//Prototype Definitions
//------------------------------------------------------------------------------------- //
Dcl-Pr IAPSEUDODR Extpgm('IAPSEUDODR');
   *n           Char(18);
   *n           Char(10);
   *n           Char(10);
   *n           Char(10);
   *n           Char(10);
   *n           Char(10);
   *n           Char(1);                                                                 //0002
   *n           Char(1);                                                                 //0004
End-Pr;
//------------------------------------------------------------------------------------- //
//Copybook definitions
//------------------------------------------------------------------------------------- //
/copy 'QCPYSRC/iaderrlog.rpgleinc'
//------------------------------------------------------------------------------------- //
//Set options
//------------------------------------------------------------------------------------- //
Exec Sql
   Set Option Commit    = *None,
              Naming    = *Sys,
              Usrprf    = *User,
              Dynusrprf = *User,
              Closqlcsr = *Endmod;

//------------------------------------------------------------------------------------- //
//Main Logic
//------------------------------------------------------------------------------------- //
Eval-Corr uDpsds = wkuDpsds;

//Converting the Charecter StartRrN and EndRrn as unsigned integer.                      //0003
wkStartRrn = %uns(inStartRrn);                                                           //0003
wkEndRrn   = %uns(inEndRrn);                                                             //0003
exec sql
   declare parallel cursor for
     select iareqid,ialibname,iasrcfile,
            iamemname,iamemtype, rrn(a)
       from iafdwndtlp a
      where request_id = : inrequestID
        and rrn(a) >= :wkStartRrn                                                        //0003
        and rrn(a) <= :wkEndRrn ;                                                        //0003

exec sql
   Open parallel ;

exec sql
   fetch next from parallel into :detailDS;

dow sqlcod = 0;

  IAPSEUDODR( inRequestID
            : inRepoName
            : LibName
            : SrcPfName
            : MbrName
            : MbrType                                                                    //0002
            : inIncludeText                                                              //0004
            : inIncludeDeclSpecs);                                                       //0004
  exec sql
     update IAFDWNDTLP a
        set request_status = 'F'
      where rrn(a) = :currentRRN
        and request_status not in ('G' , 'F');


  exec sql
     fetch next from parallel into :detailDS;

enddo;

exec sql
     Close Parallel ;

*Inlr = *On;
Return;

/copy 'QCPYSRC/iacerrlog.rpgleinc'

