**free
      //%METADATA                                                      *
      // %TEXT Service Program Module - 1 (Initialisations)            *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------ //
//CREATED BY    : Programmers.io @ 2020                                                //
//CREATE DATE   : 2020/01/01                                                           //
//DEVELOPER     : Kaushal kumar                                                        //
//DESCRIPTION   : Service Program Module - 1 Does Some initializations                 //
//PROCEDURE LOG :                                                                      //
//------------------------------------------------------------------------------------ //
//Procedure Name           | Procedure Description                                     //
//-------------------------|---------------------------------------------------------- //
//No Procedure
//------------------------------------------------------------------------------------ //
//MODIFICATION LOG:                                                                    //
//------------------------------------------------------------------------------------ //
//Date    | Mod_ID | Developer  | Case and Description                                 //
//--------|--------|------------|----------------------------------------------------- //
//03/02/22|        | Mahima     | Code Indentation                                     //
//04/07/24| 0001   | Vamsi      | Rename Bnddir AIERRBND, copybooks AICERRLOG/AIDERRLOG//
//        |        |            | and procedures AISQLDIAGNOSTIC and AIPSSRERRORLOG    //
//        |        |            | with IA*  [Task#261]                                 //
//------------------------------------------------------------------------------------ //
ctl-opt option(*nodebugio:*srcstmt:*nounref);
ctl-opt Copyright('Copyright @ Programmers.io © 2022 ');
ctl-opt bndDir('IAERRBND');                                                              //0001

dcl-pi IAMENURVLD extpgm('IAMENURVLD');
   mdname    char(10);
   isvalid   char(1);
end-pi;

/copy 'QCPYSRC/iaderrlog.rpgleinc'

//*----------------------------------------------------------------- *//
//*                   Mainline code (Begin)                          *//
//*----------------------------------------------------------------- *//
exec sql set option commit    = *none,
                    naming    = *sys,
                    usrprf    = *user,
                    dynusrprf = *user,
                    closqlcsr = *endmod;

isvalid = 'Y';
return;
/copy 'QCPYSRC/iacerrlog.rpgleinc'
