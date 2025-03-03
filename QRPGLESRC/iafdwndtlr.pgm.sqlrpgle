**free
      //%METADATA                                                      *
      // %TEXT Add records in File_Download_Request_details file       *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------- //
//Created By     : Programmers.io @ 2022                                                //
//Creation Date  : 2024/04/23                                                           //
//Developer      : Sabarish Prakash                                                     //
//Description    : Add bulk records in File_Download_Request_Detail file.               //
//                 Request may be as follows:                                           //
//                    Library   Source File  Member Type                                //
//                 1. LIB1      QRPGLESRC    *ALL   RPGLE                               //
//                 2. LIB1      QRPGLESRC    *ALL   *ALL                                //
//Validations    : 1. Retrieve the Repo name from IAFDWNREQ file for the request ID     //
//                    received.                                                         //
//                 2. Validate the library provided is associated with the repo in      //
//                    IAINPLIB file.                                                    //
//                 3. Validate from REPO.IASRCPF file that provided source file is in   //
//                    the received library.                                             //
//                                                                                      //
//Procedure Log:                                                                        //
//------------------------------------------------------------------------------------- //
//Procedure Name           | Procedure Description                                      //
//-------------------------|----------------------------------------------------------- //
//IAFDWNDTLR               | This Procedure will retrive all the Source members using   //
//                         | IAMEMBER File based on the Selection Criteria provided and //
//                         | add records in FILE_DOWNLOAD_REQUEST_DETAILS file.         //
//------------------------------------------------------------------------------------- //
//                                                                                      //
//MODIFICATION LOG:                                                                     //
//------------------------------------------------------------------------------------- //
//Date    | Mod_ID | Developer  | Case and Description                                  //
//--------|--------|------------|------------------------------------------------------ //
//25/07/24| 0001   | Sasikumar R| To add input parameters for user id and               //
//        |        |            | environment library.                                  //
//------------------------------------------------------------------------------------- //
ctl-opt option(*NoDebugIO : *SrcStmt : *noUnRef);

//------------------------------------------------------------------------------------- //
//Variable Declarations
//------------------------------------------------------------------------------------- //
dcl-s command varchar(1000) inz;

//------------------------------------------------------------------------------------- //
//Constant Declarations
//------------------------------------------------------------------------------------- //
dcl-c notfound 100;
dcl-c success  0;

//------------------------------------------------------------------------------------- //
//Prototype Declarations
//------------------------------------------------------------------------------------- //
dcl-pr runcommand extpgm('QCMDEXC');
   command    char(1000) options(*varsize) const;
   commandlen packed(15:5) const;
end-pr;

//------------------------------------------------------------------------------------- //
//Entry parameters
//------------------------------------------------------------------------------------- //
dcl-pi *n;
  upRequestID   char(18);
  upRepoName    char(10);
  upMemberLib   char(10);
  upMemberSrcpf char(10);
  upMemberName  char(10);
  upMemberType  char(10);
  upUserId      char(10);                                                                //0001
  upEnvLib      char(10);                                                                //0001
  upReturnStat  char(1);
  upReturnMsg   char(100);
end-pi;

//------------------------------------------------------------------------------------- //
//Set Options
//------------------------------------------------------------------------------------- //
*Inlr = *on;

exec sql
   set option commit = *none,
              naming = *sys,
              usrprf = *user,
              dynusrprf = *user,
              closqlcsr = *endmod;

//------------------------------------------------------------------------------------- //
//Main Logic
//------------------------------------------------------------------------------------- //
//Set library list before process starts.
exec sql set :upEnvLib = UPPER(:upEnvLib);                                               //0001
If %Trim(upEnvLib) = '#IAOBJ';                                                           //0001
  command = 'CHGLIBL LIBL(' + %trim(upRepoName) +
            ' #IADTA #IAOBJ QTEMP QGPL)';
Else;                                                                                    //0001
  command = 'CHGLIBL LIBL(' + %trim(upRepoName) +                                        //0001
            ' IADTADEV IAOBJDEV QTEMP QGPL)';                                            //0001
Endif;                                                                                   //0001
runcommand(Command:%len(%trimr(command)));

//Validate If the Requested Library is available in Repo.
exec sql
  Select XLibNam into :upMemberLib
    from IaInpLib
   where XRefNam = :upRepoName
     and XLibNam = :upMemberLib;

If sqlcode = notFound;
  upReturnStat = 'E';
  upReturnMsg = 'Requested Library is not associated with the Repository';
  return;
EndIf;

If sqlcode < success;
  upReturnStat = 'E';
  upReturnMsg = 'Process failed while validating application library.';
  return;
EndIf;

//Validate Requested File is Available in the Library.
exec sql
  Select XSrcPf into :upMemberSrcpf
    from iaSrcPf
   where XLibNam = :upMemberLib
     and XSrcPf = :upMemberSrcpf;

If sqlcode = notFound;
  upReturnStat = 'E';
  upReturnMsg = 'Source file does not exists in the given library.';
  return;
EndIf;

If sqlcode < success;
  upReturnStat = 'E';
  upReturnMsg = 'Process failed while validating Source file.';
  return;
EndIf;

//All the Validations Passed. Now fill the data in IAFDWNDTLP file.

exec sql
  Insert into IaFDwnDtlP
  Select :upRequestID, IaSrcLib, IaSrcPfNam, IaMbrNam, IaMbrType, 'P',
         0, ' ', ' ', current_timestamp,  ' '
    from iamember
   where IaSrcPfNam = :upMemberSrcpf
     and IaSrcLib   = :upMemberLib
     and (:upMemberName =  '*ALL'
      or IaMbrNam   = :upMemberName)
     and ((:upMemberType <> '*ALL'
     and IaMbrType  = :upMemberType)
      or (:upMemberType =  '*ALL'
     and IaMbrType in (
                        Select IAKEYVAL1
                          from IABCKCNFG
                         where IAKEYNAME1 = 'PSEUDOCODE'
                           and IAKEYNAME2 like 'VALIDSRCTYPE%')));

If sqlcode = success;
  upReturnStat = 'S';
  upReturnMsg = 'Request Successfully Processed';
  return;
EndIf;

If sqlcode < success;
  upReturnStat = 'E';
  upReturnMsg = 'Error Occured while Processing the Request';
  return;
EndIf;

If sqlcode = notfound;
  upReturnStat = 'S';
  upReturnMsg = 'No Members found for the Selection Criteria';
  return;
EndIf;

return;
