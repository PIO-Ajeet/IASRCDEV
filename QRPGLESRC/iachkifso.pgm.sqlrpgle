**free
      //%METADATA                                                      *
      // %TEXT Check object on IFS path.                               *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------ //
//CREATED BY :   Programmers.io @ 2020                                                 //
//CREATE DATE:   2020/01/01                                                            //
//DEVELOPER  :   Kaushal kumar                                                         //
//DESCRIPTION:   check object on IFS path program.                                     //
//                                                                                     //
//PROCEDURE LOG:                                                                       //
//------------------------------------------------------------------------------------ //
//Procedure Name           | Procedure Description                                     //
//-------------------------|---------------------------------------------------------- //
//ChkIfsObj                | Check IFS Directory for user is exist if not create it    //
//ChkIfsDir                | Checks whether object exists and accessible               //
//                         |                                                           //
//------------------------------------------------------------------------------------ //
//                                                                                     //
//MODIFICATION LOG:                                                                    //
//------------------------------------------------------------------------------------ //
//Date    | Mod_ID | Developer  | Case and Description                                 //
//--------|--------|------------|----------------------------------------------------- //
//04/07/24| 0001   | Vamsi      | Rename Bnddir AIERRBND, copybooks AICERRLOG/AIDERRLOG//
//        |        |            | and procedures AISQLDIAGNOSTIC and AIPSSRERRORLOG    //
//        |        |            | with IA*  [Task#261]                                 //
//        |        |            |                                                      //
//------------------------------------------------------------------------------------ //
ctl-opt copyright('Programmers.io Â© 2020 | Ashish | Changed April 2021');
ctl-opt option(*nodebugio:*srcstmt:*nounref);
ctl-opt bndDir('IABNDDIR' : 'IAERRBND');                                                 //0001

/copy 'QMODSRC/iasrv01pr.rpgleinc'
/copy 'QCPYSRC/iaderrlog.rpgleinc'

//------------------------------------------------------------------------------------ //
//                    Prototye Declaration                                             //
//------------------------------------------------------------------------------------ //
dcl-Pr IaChkIfsO ExtPgm('IACHKIFSO');
   *n VarChar(256) Options(*NoPass);
   *n Char(01)     Options(*NoPass);
   *n Char(10)     Options(*NoPass);
end-pr;

dcl-pr OpenDir Pointer ExtProc('opendir');
   *N Pointer Value Options(*String);
end-pr;

dcl-pr Access int(10) Extproc( 'access' );
   Path Pointer Value   Options(*String);
   Aflagg       int(10) value;
end-pr;

dcl-pr ChkIfsObj int(10);
  Path        VarChar(256) value;
  Accessflag  int(10)   Value options(*nopass);
end-pr;

dcl-pr ChkIfsDir;
  *n VarChar(256) value;
end-pr;

//------------------------------------------------------------------------------------ //
//                   Prototye Interface                                                //
//------------------------------------------------------------------------------------ //

Dcl-Pi IaChkIfsO;
  p_IfsPath  VarChar(256) Options(*NoPass);
  p_ErrFlag  Char(01)     Options(*NoPass);
  p_UserName Char(10)     Options(*NoPass);
End-pi;

//StandAlone Variable
dcl-S ReturnDir    Pointer;
dcl-s w_RtnError   char(1);
dcl-s w_Command    varchar(1000);
dcl-c w_Quote      Const('''');

//------------------------------------------------------------------------------------ //
//  Main Line (Begin)                                                                  //
//------------------------------------------------------------------------------------ //
exec sql
  set option commit = *none,
             naming = *sys,
             usrprf = *user,
             dynusrprf = *user,
             closqlcsr = *endmod;
Select;
When %parms = 3;
   ChkIfsDir(p_IfsPath);
Other;
   If Chkifsobj(%trim(p_IfsPath)) <> *Zero;
      p_ErrFlag = 'Y';
   Else;
      Clear p_ErrFlag;
   Endif;
Endsl;

Return;

/copy 'QCPYSRC/iacerrlog.rpgleinc'
//------------------------------------------------------------------------------------ //
// ChkIfsDir - Check IFS Directory for user is exist if not create it                  //
//------------------------------------------------------------------------------------ //
dcl-proc ChkIfsDir;
   Dcl-pi ChkIfsDir;
      IfsPath VarChar(256) value;
   End-pi;

   //Check Directory - /Home
   IfsPath = '/home';
   ReturnDir = OpenDir(%trim(IfsPath));

   If ReturnDir = *NULL;
      w_Command = 'MKDIR DIR('+ w_Quote + %trim(IfsPath) + w_Quote +')';
      RunCommand(w_Command :w_RtnError);
   Endif;

   //Check Directory - /Home/IA_TOOL
   IfsPath = %trim(IfsPath) + '/IA_TOOL';
   ReturnDir = OpenDir(%trim(IfsPath));

   If ReturnDir = *NULL;
      w_Command = 'MKDIR DIR('+ w_Quote + %trim(IfsPath) + w_Quote +')';
      RunCommand(w_Command :w_RtnError);
   Endif;

   //Check Directory - /Home/IA_TOOL/User name
   IfsPath = %trim(IfsPath) + '/' + %trim(p_UserName);
   ReturnDir = OpenDir(%trim(IfsPath));

   If ReturnDir = *NULL;
      w_Command = 'MKDIR DIR('+ w_Quote + %trim(IfsPath) + w_Quote +')';
      RunCommand(w_Command :w_RtnError);
   Endif;

   p_IfsPath = %trim(IfsPath);

end-proc;

//------------------------------------------------------------------------------------ //
// chkIfsObj - Checks whether object exists and accessible                             //
//------------------------------------------------------------------------------------ //
//    input   - Variable containing path Options regarding opening of file              //
//                (sum of options) OPTIONAL -> Check existance                          //
//    returns - 0 when file is accessable -1 when not                                   //
//------------------------------------------------------------------------------------ //
dcl-proc ChkIfsObj;
   Dcl-pi ChkIfsObj Int(10);
      Path       VarChar(256) value;
      accessflag Int(10)      value Options(*nopass);
   End-pi;

   Dcl-s pos Int(10);

   If path = *blank;
      return -1;
   Endif;

   //Determine last position of path for length.
   Pos = %checkr(' ' :path);

   Select;
   When %parms < 2;
      return access( %subst(path :1 :pos ) :0);
   other;
      return access( %subst(path :1 :pos ) :accessflag);
   Endsl;

end-proc;
