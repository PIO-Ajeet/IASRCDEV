**free
      //%METADATA                                                      *
      // %TEXT Validate if the source details can be excluded          *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------- //
//Created By     : Programmers.io @ 2023                                                //
//Creation Date  : 2023/12/15                                                           //
//Developer      : Saikiran Parupalli                                                   //
//Description    : Exclude the source member details that are present in IAXSRCPF       //
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
//Date    | Developer  | Case and Description                                           //
//--------|------------|--------------------------------------------------------------- //
//23/12/26| Saikiran   | Added a condition to include the Member field in the Exclusion //
//        |            | logic and changed IAXSRCPF field names according to the new    //
//        |            | table (Mod:0001 - Task#500)                                    //
//04/07/24| Vamsi      | Rename Bnddir AIERRBND, copybooks AICERRLOG/AIDERRLOG          //
//        |            | and procedures AISQLDIAGNOSTIC and AIPSSRERRORLOG              //
//        |            | with IA*  [Task#261] [ModId#0002]                              //
//------------------------------------------------------------------------------------- //
ctl-opt copyright('Programmers.io Â© 2023');
ctl-opt option(*NoDebugIO : *SrcStmt : *noUnRef);
ctl-opt bndDir('IAERRBND');                                                              //0002

//------------------------------------------------------------------------------------- //
//Variable Declaration
//------------------------------------------------------------------------------------- //

//------------------------------------------------------------------------------------- //
//Constant Declaration
//------------------------------------------------------------------------------------- //
dcl-c ucFalse     '0';
dcl-c ucTrue      '1';

//------------------------------------------------------------------------------------- //
//Data Structure Declaration
//------------------------------------------------------------------------------------- //

//------------------------------------------------------------------------------------- //
//Copybook Declaration
//------------------------------------------------------------------------------------- //
/copy 'QCPYSRC/iaderrlog.rpgleinc'

//------------------------------------------------------------------------------------- //
//Entry Parameters
//------------------------------------------------------------------------------------- //
dcl-pi MainPgm   extpgm('IAMBREXCR');
   upSrcFile       Char(10) Const;
   upSrcLib        Char(10) Const;
   upExclusionFlag Char(1);
end-pi;

//------------------------------------------------------------------------------------- //
//Set Options
//------------------------------------------------------------------------------------- //
exec sql
  set option Commit    = *None,
             Naming    = *Sys,
             UsrPrf    = *User,
             DynUsrPrf = *User,
             CloSqlCsr = *EndMod;

//------------------------------------------------------------------------------------- //
//Mainline Logic
//------------------------------------------------------------------------------------- //
//upExclusionFlag will be switched on when the data is present in IAXSRCPF
upExclusionFlag  = ucFalse;

//Checking for the Source file and Library
exec sql
  select :ucTrue into :upExclusionFlag
    from iaxsrcpf
   where upper(iasrcfile) = :upSrcFile                                                   //0001
     and upper(iasrclib)  = :upSrcLib                                                    //0001
     and upper(iasrcmbr)  = ' ';                                                         //0001

//Checking for the Source file
If sqlcode = No_Data_Found;
   exec sql
     select :ucTrue into :upExclusionFlag
       from iaxsrcpf
      where upper(iasrcfile) = :upSrcFile                                                //0001
        and upper(iasrclib)  = ' '                                                       //0001
        and upper(iasrcmbr)  = ' ';                                                      //0001
endif;

*inlr = *on;
return;

