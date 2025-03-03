**free
      //%METADATA                                                      *
      // %TEXT IA Repository Maintenance Program for UI                *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------- //
//Created By    : Programmers.io @ 2024                                                 //
//Created Date  : 2024/01/23                                                            //
//Developer     : Abhijith Ravindran                                                    //
//Description   : Repo maintenance program for frontend application                     //
//Procedure Log : Return parameter upStatus has below values,                           //
//                'E' = Error                                                           //
//                'S' = Successfull                                                     //
//------------------------------------------------------------------------------------- //
//Procedure Name           | Procedure Description                                      //
//-------------------------|----------------------------------------------------------- //
//No Procedure             |                                                            //
//------------------------------------------------------------------------------------- //
//Modification Log:                                                                     //
//------------------------------------------------------------------------------------- //
//Date    | Mod_ID | Task# | Developer  | Case and Description                          //
//--------|--------|-------|------------|-----------------------------------------------//
//        |        | 551   | Naresh  S  | Initial Creation.                             //
//02/07/24| 0001   | #298  | Yogesh Chan| Rename AIPURGDTA to IAPURGDTA [Task #298]     //
//02/07/24| 0002   | 248   | Vamsi      | Rename AIEXCTIME to IAEXCTIME                 //
//03/07/24| 0003   | 245   | Yogesh Chan| Rename AILICKEYP to IALICKEYP                 //
//03/07/24| 0004   | 252   | Vamsi      | Rename AIEXCOBJS to IAEXCOBJS                 //
//04/07/24| 0005   | 261   | Akhil K.   | Renamed AIERRBND, AICERRLOG, AIDERRLOG and    //
//        |        |       |            | AISQLDIAGNOSTIC with IA*                      //
//25/09/24| 0006   | 963   | Manav T.   | Issue in inserting data in source exclusion   //
//        |        |       |            | table IAXSRCPF. Need fix.                     //
//04/11/24| 0007   | 833   | Sasikumar R| Increase the length of the library and add the//
//        |        |       |            | validation for IFS location.                  //
//------------------------------------------------------------------------------------- //
ctl-opt copyright('Copyright @Programmers.io 2024');
ctl-opt option(*nodebugio:*srcstmt:*nounref);
ctl-opt bnddir('IABNDDIR' : 'IAERRBND');                                                 //0005

//------------------------------------------------------------------------------------- //
//Copy Book Definitions
//------------------------------------------------------------------------------------- //
/copy 'QCPYSRC/iaderrlog.rpgleinc'
/copy 'QMODSRC/iavalidtpr.rpgleinc'
/copy 'QMODSRC/iasrv01pr.rpgleinc'

//------------------------------------------------------------------------------------- //
//Prototype Declaration
//------------------------------------------------------------------------------------- //
dcl-pr initiateDeleteRepositoryProcess;
end-pr;

dcl-pr IAGETMSG extpgm('IAGETMSG');
   MsgType     char(1);
   MsgId       char(7);
   MsgData     char(1000);
   MsgDtaFld   char(80);
end-pr;

//------------------------------------------------------------------------------------- //
//Standalone Variable Definitions
//------------------------------------------------------------------------------------- //
dcl-s uwXRef         char(10) inz;
dcl-s uwMessageID    char(7)  inz;
dcl-s uwIaVersion    char(6)  inz(' ');
dcl-s uwExist        char(1)  inz;
dcl-s uwError        char(1)  inz;
dcl-s MsgType        char(1)  inz;
dcl-s MsgId          char(7)  inz;
dcl-s MsgDtaFld      char(80) inz;
dcl-s MsgData        char(1000)    inz;
dcl-s Command        varchar(1000) inz;

dcl-s uwChangeDescInd      ind;
dcl-s uwChangeLibListInd   ind;

dcl-s uwCount        packed(12:0) inz;
dcl-s uwCommaPos     packed(4:0)  inz;
dcl-s uwStartPos     packed(4:0)  inz;
dcl-s uwStrLength    packed(4:0)  inz;
dcl-s uwMaxSeq       packed(3:0)  inz;                                                   //0006

dcl-s uwIndex        uns(5)   Inz;

//------------------------------------------------------------------------------------- //
//Data Structure Definitions
//------------------------------------------------------------------------------------- //
dcl-ds MsgDataFldDs;
   MsgFld1 Char(20);
   MsgFld2 Char(20);
   MsgFld3 Char(20);
   MsgFld4 Char(20);
end-ds;

//------------------------------------------------------------------------------------- //
//Array Definitions
//------------------------------------------------------------------------------------- //
// dcl-s arrayOfLibraries  char(10) dim(100);                                            //0007
dcl-s arrayOfLibraries  char(100) dim(100);                                              //0007

//------------------------------------------------------------------------------------- //
//Constant Definitions
//------------------------------------------------------------------------------------- //
dcl-c ucQuote        '''';
dcl-c ucPgmName      'IAMNTREPOR';
dcl-c SqlAllOk       '00000';

//------------------------------------------------------------------------------------- //
//Main Entry Parameter
//------------------------------------------------------------------------------------- //
dcl-pr IAMNTREPOR extpgm('IAMNTREPOR');
   upAction      char(1)     const;
   upRepoName    char(10)    const options(*trim);
   upDescription char(30)    const options(*trim);
   upLibraryList char(1000)  const options(*trim);
   upUserId      char(10)    const options(*trim);
   upStatus      char(1);
   upMessage     char(200);
end-pr;

dcl-pi IAMNTREPOR;
   upAction      char(1)     const;
   upRepoName    char(10)    const options(*trim);
   upDescription char(30)    const options(*trim);
   upLibraryList char(1000)  const options(*trim);
   upUserId      char(10)    const options(*trim);
   upStatus      char(1);
   upMessage     char(200);
end-pi;

//------------------------------------------------------------------------------------- //
//Main Logic
//------------------------------------------------------------------------------------- //
exec sql
   set option  commit      =  *none,
               naming      =  *sys,
               usrprf      =  *user,
               dynusrprf   =  *user,
               closqlcsr   =  *endmod;

eval-corr uDpsds = wkuDpsds;

//Initialize the work variables
exsr initializeVariables;

//Incoming Repository name validation
if upRepoName = *BLANKS;
   Clear MsgDataFldDs;
   upStatus  = 'E';
   upMessage = RetrieveMsgText('1':'MSG0001':MsgDataFldDs);
   *inlr = *on;
   return;
else;
   uwXRef  = %trim(upRepoName);
endif;

//Incoming User name validation
if upUserId  = *Blanks;
   Clear MsgDataFldDs;
   upStatus  = 'E';
   MsgFld1   = uwXRef;
   upMessage = RetrieveMsgText('1':'MSG0170':MsgDataFldDs);
   *inlr = *on;
   return;
endif;

select;
   //Add a New Repo
   when upAction = 'A';
      initiateAddRepositoryProcess();

   //Repo Modification
   when upAction = 'M';
      initiateModifyRepositoryProcess();

   //Repo Deletion
   when upAction = 'D';
      initiateDeleteRepositoryProcess();

   other;
      upStatus  =  'E';
      upMessage =  'Invalid Action Code';
endsl;

*inlr = *on;
return;

/copy 'QCPYSRC/iacerrlog.rpgleinc'

//--------------------------------------------------------------------------------------//
//Initialize the variables
//--------------------------------------------------------------------------------------//
begsr initializeVariables;

   clear upStatus;
   clear uwMessageID;
   clear upMessage;
   clear uwIaVersion;
   uwChangeDescInd = *off;
   uwChangeLibListInd = *off;

   exec sql
     select Version_Number
       into :uwIaVersion
    // from ailickeyp;                                                                  //0003
       from ialickeyp;                                                                  //0003

endsr;

//--------------------------------------------------------------------------------------//
//initiateAddRepositoryProcess - Validate and Add a new repository
//--------------------------------------------------------------------------------------//
dcl-proc initiateAddRepositoryProcess;

   dcl-pi initiateAddRepositoryProcess;
   end-pi;

 //dcl-s libraryInRepo  char(10);                                                        //0007
   dcl-s libraryInRepo  char(100);                                                       //0007
   dcl-s wk_user        char(10);
   dcl-s wk_pgm         char(10);
   dcl-s wkLibSeq       packed(4:0) inz;

   //check whether repo already exists or not.
   isRepositoryExists(uwXRef:upAction:upStatus:uwMessageID);
   //if Repo already exists then return to caller with message.
   if upStatus   = 'S';
      clear MsgDataFldDs;
      upStatus  = 'E';
      MsgFld1   = uwXRef;
      upMessage = RetrieveMsgText('1':uwMessageID:MsgDataFldDs);
      return;
   endif;

   //Verify whether Library List is passed or not.If not, return to caller with message
   if upLibraryList = *Blanks;
      clear MsgDataFldDs;
      upStatus  = 'E';
      MsgFld1   = uwXRef;
      upMessage = RetrieveMsgText('1':'MSG0002':MsgDataFldDs);
      return;
   endif;

   //Verify whether repo name is valid or not.
   isRepositoryNameValid(uwXRef:upStatus:uwMessageID);
   //If repo name is not valid then return to caller with message.
   if upStatus = 'E';
      clear MsgDataFldDs;
      upMessage = RetrieveMsgText('1':uwMessageID:MsgDataFldDs);
      return;
   endif;

   //Split the ,(comma) delimited library list into Array
   MoveLibraryLstToArray();

   //Check if the libraries in the library list are valid.
   if Not IsValidLibraryInList();
      return;
   endif;

   //Loop the array and Add record into file IAINPLIB.
   uwIndex = 1;
   dow arrayOfLibraries(uwIndex) <> *BLANKS;

      wkLibSeq = uwIndex * 10;
      LibraryInRepo = %trim(arrayOfLibraries(uwIndex));
      if %scan('/':LibraryInRepo) = *zeros;                                              //0007

      exec sql
        insert into IaInplib (Xref_Name,
                              Library_SeqNo,
                              Library_Name,
                              Built_Version,
                              Crt_ByUser,
                              Crt_Bypgm,
                              Desc)
                      values (:uwXRef,
                              :wkLibSeq,
                              :libraryInRepo,
                              :uwIaVersion,
                              :upUserId,
                              :uDpsds.SrcMbr,
                              :upDescription);
      else;                                                                              //0007
      exec sql                                                                           //0007
        insert into IaInplib (Xref_Name,                                                 //0007
                              Library_SeqNo,                                             //0007
                              IFS_LOCATION,                                              //0007
                              Built_Version,                                             //0007
                              Crt_ByUser,                                                //0007
                              Crt_Bypgm,                                                 //0007
                              Desc)                                                      //0007
                      values (:uwXRef,                                                   //0007
                              :wkLibSeq,                                                 //0007
                              :libraryInRepo,                                            //0007
                              :uwIaVersion,                                              //0007
                              :upUserId,                                                 //0007
                              :uDpsds.SrcMbr,                                            //0007
                              :upDescription);                                           //0007

      endif;                                                                             //0007

      if sqlCode < successCode;
         Eval-corr uDpsds = wkuDpsds;
         uDpsds.wkQuery_Name ='IAMNTREPOR_Insert1_IAINPLIB';
         IaSqlDiagnostic(uDpsds);                                                        //0005
      else;
         uwIndex = uwIndex + 1;
      endif;

   enddo;

   //Create the Repository Library
   clear Command;
   command = 'CRTLIB LIB(' + uwXRef + ') +
                     TYPE(*PROD) +
                     TEXT(' + ucQuote + 'Repo: ' + upDescription + ucQuote + ')';
   runCommand(Command:uwError);

   if uwError <> *BLANK;

      //Delete the records which were added earlier to make data in sync in case
      //Repo library creation process ended in error
      exec sql
        delete from iainplib
              where Xref_Name = :uwXRef;

      if sqlCode < successCode;
         Eval-corr uDpsds = wkuDpsds;
         uDpsds.wkQuery_Name ='IAMNTREPOR_Delete_IAINPLIB';
         IaSqlDiagnostic(uDpsds);                                                        //0005
      endif;

      clear MsgDataFldDs;
      upStatus  = 'E';
      MsgFld1   = uwXRef;
      upMessage = RetrieveMsgText('1':'MSG0165':MsgDataFldDs);
      return;

   endif;

   //Copy below files and data areas from IA data library to Repo library.
   clear command;
   //Copy IAEXCTIME                                                                     //0002
   // Below line changed as part of #0002
   command = 'CRTDUPOBJ OBJ(IAEXCTIME) +
                     FROMLIB(#IADTA) +
                     OBJTYPE(*FILE) +
                     TOLIB(' + uwXRef + ') +
                     DATA(*No)';
   runCommand(Command:uwError);

   //Copy IAREPOLOG
   clear command;
   command = 'CRTDUPOBJ OBJ(IAREPOLOG) +
                     FROMLIB(#IADTA) +
                     OBJTYPE(*FILE) +
                     TOLIB(' + uwXRef + ') +
                     DATA(*No)';
   runCommand(Command:uwError);

   //Copy IAEXCOBJS                                                                     //0004
   clear command;
   //Below line is part of #0004
   command = 'CRTDUPOBJ OBJ(IAEXCOBJS) +
                     FROMLIB(#IADTA) +
                     OBJTYPE(*FILE) +
                     TOLIB(' + uwXRef + ') ' +
                     'DATA(*YES)';
   runCommand(Command:uwError);

   //Correct sequence number for IAEXCOBJS file after CRTDUPOBJ command                 //0006
   clear uwMaxSeq;                                                                       //0006
   command   = 'values( ' +                                                              //0006
               'select max(IASQNO) + 1 ' +                                               //0006
               'from ' + %trim(uwXRef) + '/IAEXCOBJS) ' +                                //0006
               'into ?';                                                                 //0006
                                                                                         //0006
   exec sql prepare stmt from :command ;                                                 //0006
                                                                                         //0006
   exec sql execute stmt using :uwMaxSeq;                                                //0006
                                                                                         //0006
   command = 'Alter table ' + %trim(uwXRef) + '/IAEXCOBJS' +                             //0006
               ' alter column IASQNO restart with ' + %char(uwMaxSeq);                   //0006
                                                                                         //0006
   exec sql execute Immediate :command ;                                                 //0006

   //Copy IAXSRCPF
   clear command;
   command = 'CRTDUPOBJ OBJ(IAXSRCPF) +
                      FROMLIB(#IADTA) +
                      OBJTYPE(*FILE) +
                      TOLIB(' + uwXRef + ') ' +
                      'DATA(*YES)';
   runCommand(Command:uwError);

   //Correct sequence number for IAXSRCPF  file after CRTDUPOBJ command                 //0006
   clear uwMaxSeq;                                                                       //0006
   command   = 'values( ' +                                                              //0006
               'select max(IASQNO) + 1 ' +                                               //0006
               'from ' + %trim(uwXRef) + '/IAXSRCPF) ' +                                 //0006
               'into ?';                                                                 //0006
                                                                                         //0006
   exec sql prepare stmt from :command ;                                                 //0006
                                                                                         //0006
   exec sql execute stmt using :uwMaxSeq;                                                //0006
                                                                                         //0006
   command = 'Alter table ' + %trim(uwXRef) + '/IAXSRCPF' +                              //0006
               ' alter column IASQNO restart with ' + %char(uwMaxSeq);                   //0006
                                                                                         //0006
   exec sql execute Immediate :command ;                                                 //0006

   //Copy IAPURGDTA                                                                          //0001
   clear command;
   command = 'CRTDUPOBJ OBJ(IAPURGDTA) +
                     FROMLIB(#IADTA) +
                     OBJTYPE(*DTAARA) +
                     TOLIB(' + uwXRef + ')';
   runCommand(Command:uwError);

   //Copy IAJOBDAREA
   clear command;
   command = 'CRTDUPOBJ OBJ(IAJOBDAREA) +
                     FROMLIB(#IADTA) +
                     OBJTYPE(*DTAARA) +
                     TOLIB(' + uwXRef + ')';
   runCommand(Command:uwError);

   //Copy IAMETAINFO
   clear command;
   command = 'CRTDUPOBJ OBJ(IAMETAINFO) +
                      FROMLIB(#IADTA) +
                      OBJTYPE(*DTAARA) +
                      TOLIB(' + uwXRef + ')';
   runCommand(Command:uwError);

   //If no error, finally send successful message to caller
   clear MsgDataFldDs;
   upStatus  = 'S';
   MsgFld1   = uwXRef;
   upMessage = RetrieveMsgText('1':'MSG0007':MsgDataFldDs);
   return;

end-proc initiateAddRepositoryProcess;

//------------------------------------------------------------------------------------- //
//initiateModifyRepositoryprocess : Validate and Update the Repository accordingly
//------------------------------------------------------------------------------------- //
dcl-proc initiateModifyRepositoryProcess;

   dcl-pi initiateModifyRepositoryProcess;
   end-pi;

   dcl-s w_desc         varchar(30) inz;
   dcl-s libraryInRepo  char(10);
   dcl-s wkLibSeq       packed(4:0) inz;
   dcl-s wkBuilt        char(1)     inz;

   //Check Existance of the repo.
   isRepositoryExists(uwXRef:upAction:upStatus:uwMessageID);
   if upStatus = 'E';
      clear MsgDataFldDs;
      MsgFld1   = uwXRef;
      upMessage = RetrieveMsgText('1':uwMessageID:MsgDataFldDs);
      return;
   endif;

   //If repo is already in use send error.
   isRepositoryInUse(uwXRef:upStatus:uwMessageID);
   if upStatus = 'E';
      clear MsgDataFldDs;
      MsgFld1   = uwXRef;
      upMessage = RetrieveMsgText('1':uwMessageID:MsgDataFldDs);
      return;
   endif;

   //Get original description and build status before performing any updates.
   exec sql
     select desc, xmdbuilt
       into :w_desc, :wkBuilt
       from IaInpLib
      where XREF_NAME = :uwXRef
      limit 1;

   //Verify if description changes are received.
   if upDescription <>  *BLANKS
      and w_desc <> upDescription;
      uwChangeDescInd = *on;
   endif;

   //Verify if library list changes are received.
   if upLibraryList <> *Blanks;

      uwChangeLibListInd = *on;
      //Parse comma separated libraries received in parameter and store in an array.
      moveLibraryLstToArray();

      //Verify if the supplied libraries in the library list are valid.
      if Not IsValidLibraryInList();
         return;
      endif;

   endif;

   //lock the repository before update
   lockRepository(uwXRef:upUserId:upStatus:uwMessageID);

   select;
      when uwChangeLibListInd;

         exec sql
           delete from iainplib
                 where XREF_NAME = :uwXRef;

         //Add new description if provided.
         if uwChangeDescInd;
            w_desc = upDescription;
         endif;

         //Insert updated library list.
         uwIndex = 1;
         dow arrayOfLibraries(uwIndex) <> *Blanks;

            wkLibSeq = uwIndex * 10;
            LibraryInRepo = %trim(arrayOfLibraries(uwIndex));

            if %scan('/':LibraryInRepo) = *zeros;                                        //0007

            exec sql
              insert into IaInplib (Xref_Name,
                                    Library_Name,
                                    Library_SeqNo,
                                    Is_Md_Built,
                                    Built_Version,
                                    Crt_ByUser,
                                    Crt_Bypgm,
                                    Desc)
                            values (:uwXRef,
                                    :libraryInRepo,
                                    :wkLibSeq,
                                    :wkBuilt,
                                    :uwIaVersion,
                                    :upUserId,
                                    :uDpsds.SrcMbr,
                                    :w_desc);
            else;                                                                        //0007

            exec sql                                                                     //0007
              insert into IaInplib (Xref_Name,                                           //0007
                                    IFS_LOCATION,                                        //0007
                                    Library_SeqNo,                                       //0007
                                    Is_Md_Built,                                         //0007
                                    Built_Version,                                       //0007
                                    Crt_ByUser,                                          //0007
                                    Crt_Bypgm,                                           //0007
                                    Desc)                                                //0007
                            values (:uwXRef,                                             //0007
                                    :libraryInRepo,                                      //0007
                                    :wkLibSeq,                                           //0007
                                    :wkBuilt,                                            //0007
                                    :uwIaVersion,                                        //0007
                                    :upUserId,                                           //0007
                                    :uDpsds.SrcMbr,                                      //0007
                                    :w_desc);                                            //0007

            endif;                                                                       //0007

            if sqlCode < successCode;
               Eval-corr uDpsds = wkuDpsds;
               uDpsds.wkQuery_Name ='IAMNTREPOR_Insert2_IAINPLIB';
               IaSqlDiagnostic(uDpsds);                                                  //0005
            endif;

            uwIndex += 1;
            //Preventive checks to prevent program from failing.
            if uwIndex > %elem(arrayOfLibraries);
               leave;
            endif;

         enddo;

         //Change text description of the repo object.
         if uwChangeDescInd;
            exsr SrChangeLibDesc;
            if upStatus = 'E';
               return;
            endif;
         endif;

      when uwChangeDescInd;

         //Update description in IAINPLIB.
         exec sql
           update IaInpLib
              set Desc     = :upDescription,
                  chgPgm   = :ucPgmName,
                  chgUser  = :upUserId
            where Xref_Name = :uwXRef;

         //Update Repo Object description.
         exsr srChangeLibDesc;

         //Restoring the previous meta data built.
         exec sql
           update IaInpLib
              set xmdbuilt = :wkBuilt
            where Xref_Name = :uwXRef
              and ChgPgm   = :ucPgmName
              and ChgUser  = :upUserId;

         if upStatus = 'E';
            return;
         endif;

   endsl;

   if uwChangeDescInd = *on and uwChangeLibListInd = *on;
      MsgId = 'MSG0171';
   elseif uwChangeDescInd = *on;
      MsgId = 'MSG0166';
   elseif uwChangeLibListInd = *on;
      MsgId = 'MSG0169';
   endif;

   //send successful message to caller
   clear MsgDataFldDs;
   upStatus  = 'S';
   MsgFld1   = uwXRef;
   upMessage = RetrieveMsgText('1':MsgId:MsgDataFldDs);
   return;

   //---------------------------------------------------------------------------------- //
   //SrChangeLibDesc : Change Text description of the repository.
   //---------------------------------------------------------------------------------- //
   begsr srChangeLibDesc;

      clear upStatus;
      clear Command;
      command = 'CHGLIB LIB(' + uwXRef + ') +
                 TEXT(' + ucQuote + 'Repo: ' + upDescription + ucQuote + ')';
      runCommand(Command:uwError);

      if uwError <> *Blank;

         //unlock the repository
         unlockRepository(uwXRef:upUserId:upStatus:uwMessageID);

         Clear MsgDataFldDs;
         upStatus  = 'E';
         MsgFld1   = uwXRef;
         upMessage = RetrieveMsgText('1':'MSG0167':MsgDataFldDs);

      endif;

   endsr;

end-proc initiateModifyRepositoryProcess;

//------------------------------------------------------------------------------------- //
//initiateDeleteRepositoryprocess : Validate and Delete the Repository
//------------------------------------------------------------------------------------- //
dcl-proc initiateDeleteRepositoryProcess;

   dcl-pi initiateDeleteRepositoryProcess;
   end-pi;

   //Check if repo exists.
   isRepositoryExists(uwXRef:upAction:upStatus:uwMessageID);
   if upStatus = 'E';
      Clear MsgDataFldDs;
      MsgFld1  = uwXRef;
      upMessage = RetrieveMsgText('1':uwMessageID:MsgDataFldDs);
      return;
   endif;

   //Check if repo is in use or metadata is being process or scheduled.
   isRepositoryInUse(uwXRef:upStatus:uwMessageID);
   if upStatus = 'E';
      Clear MsgDataFldDs;
      MsgFld1  = uwXRef;
      upMessage = RetrieveMsgText('1':uwMessageID:MsgDataFldDs);
      return;
   endif;

   //Deallocate all the objects in repo.
   deallocateRepoObjects(uwXRef:upStatus:uwMessageID);
   if upStatus = 'E';
      Clear MsgDataFldDs;
      MsgFld1   = uwXRef;
      upMessage = RetrieveMsgText('1':uwMessageID:MsgDataFldDs);
      return;
   endif;

   //Lock the repo so that no one else can use it.
   lockRepository(uwXRef:upUserId:upStatus:uwMessageID);
   if upStatus = 'E';
      Clear MsgDataFldDs;
      MsgFld1   = uwXRef;
      upMessage = RetrieveMsgText('1':uwMessageID:MsgDataFldDs);
      return;
   endif;

   uwExist = 'N';
   exec sql
     select 'Y'
       into :uwExist
       from IaInpLib
      where Xref_Name = :uwXRef
      limit 1;

   if uwExist ='Y';

      exec sql
        delete from IaInpLib
              where XREF_NAME = :uwXRef;

      if sqlState = SqlAllOk;

         clear Command;
         command = 'RMVLIBLE LIB('+ uwXRef + ')';
         runCommand(Command:uwError);

         clear Command;
         command = 'DLTLIB LIB(' + uwXRef + ')';
         runCommand(Command:uwError);

         if uwError = *BLANK;
            //To delete the existing entries from the IaRefLibP for the Repository
            exec sql
              select count(*)
                into :uwCount from IaRefLibP
               where MRefNam = :uwXRef;

            if uwCount <> 0;
               exec sql
                 delete from IaRefLibP
                       where MRefNam = :uwXRef;
            endif;

            //send successful message to caller
            clear MsgDataFldDs;
            upStatus  = 'S';
            MsgFld1   = uwXRef;
            upMessage = RetrieveMsgText('1':'MSG0009':MsgDataFldDs);
         else;
            Clear MsgDataFldDs;
            upStatus  = 'E';
            MsgFld1   = uwXRef;
            upMessage = RetrieveMsgText('1':'MSG0141':MsgDataFldDs);
         endif;

      else;
         Clear MsgDataFldDs;
         upStatus  = 'E';
         MsgFld1   = uwXRef;
         upMessage = RetrieveMsgText('1':'MSG0141':MsgDataFldDs);
      endif;

   endif;

end-proc initiateDeleteRepositoryProcess ;

//--------------------------------------------------------------------------------------//
//MoveLibraryLstToArray - Parse Comma separated library names and move to Array.
//--------------------------------------------------------------------------------------//
dcl-proc MoveLibraryLstToArray;

   clear arrayOfLibraries;
   uwCommaPos = 0;
   uwStartPos = 0;
   uwIndex    = 0;
   uwStrLength = %Len(%trim(upLibraryList));

   dou uwCommaPos = 0;

      if uwStrLength > uwCommaPos;

         uwStartPos = uwCommaPos + 1;
         uwCommaPos = %Scan(',': upLibraryList:uwCommaPos+1);

         if uwCommaPos > 0;

            if uwCommaPos > uwStartPos;
               uwIndex += 1;
               arrayOfLibraries(uwIndex) =
               %Subst(upLibraryList:uwStartPos:uwCommaPos-uwStartPos);
            endif;

         else;

            //It may be last record to fetch.
            if uwStrLength > uwStartPos;
               uwIndex += 1;
               arrayOfLibraries(uwIndex) =
               %Subst(upLibraryList:uwStartPos:uwStrLength+1-uwStartPos);
            endif;
            leave;

         endif;

      endif;

      //Leave the loop if index reaches to 100.
      if uwIndex = %elem(arrayOfLibraries);
         leave;
      endif;

   enddo;

end-proc MoveLibraryLstToArray;

//--------------------------------------------------------------------------------------//
//IsValidLibraryInList - Verify if the supplied application libraries are valid.
//--------------------------------------------------------------------------------------//
dcl-proc IsValidLibraryInList;

   dcl-pi *n Ind;
   end-pi;

 //dcl-s AppLibName  char(10) Inz;                                                       //0007
   dcl-s AppLibName  char(100) Inz;                                                      //0007

   uwIndex = 1;
   Dow arrayOfLibraries(uwIndex) <> *Blanks;

      AppLibName = arrayOfLibraries(uwIndex);
      //Call procedure to validate Application Library.
      if %scan('/':AppLibName) = *zeros;                                                 //0007
      isAppLibraryExists(AppLibName:upStatus:uwMessageID);
      else;                                                                              //0007
      isIFSDirectoryExists(AppLibName:upStatus:uwMessageID);                             //0007
      endif;                                                                             //0007

      //Send error for invalid library.
      if upStatus = 'E';
         Clear MsgDataFldDs;
         MsgFld1   = AppLibName;
         upMessage = RetrieveMsgText('1':uwMessageID:MsgDataFldDs);
         return *off;
      endif;
      uwIndex += 1;

   enddo;

   return *on;

end-proc IsValidLibraryInList;

//--------------------------------------------------------------------------------------//
//RetrieveMsgText - Retrieve message text for the provided message ID.
//--------------------------------------------------------------------------------------//
dcl-proc RetrieveMsgText;

   dcl-pi *n  char(200);
      upMsgType         char(1) const;
      upMsgId           char(7) const;
      upMsgDataFldDs    like(MsgDataFldDs);
   end-pi;

   dcl-s uwMsgData      char(1000);
   dcl-s uwMsgType         char(1);
   dcl-s uwMsgId           char(7);

   clear uwMsgData;
   uwMsgType = upMsgType;
   uwMsgId   = upMsgId;
   IAGETMSG(uwMsgType:uwMsgId:uwMsgData:upMsgDataFldDs);
   return uwMsgData;

end-proc RetrieveMsgText;
//--------------------------------------------------------------------------------------//0007
//isIFSDirectoryExists - Verify if the IFS directory is valid.                          //0007
//--------------------------------------------------------------------------------------//0007
dcl-proc IsIFSDirectoryExists;                                                           //0007
                                                                                         //0007
   dcl-pi IsIFSDirectoryExists;                                                          //0007
      upAppIfsDir   varchar(100) const options(*trim) ;                                  //0007
      upStatus      char(1) ;                                                            //0007
      upMessageId   char(7) ;                                                            //0007
   end-pi;                                                                               //0007
                                                                                         //0007
   dcl-s w_Count zoned(7:0) Inz;                                                         //0007
                                                                                         //0007
   Exec sql                                                                              //0007
        Select count(*)                                                                  //0007
        Into  :w_Count                                                                   //0007
        From   TABLE(QSYS2.IFS_OBJECT_STATISTICS                                         //0007
               (Trim(:upAppIfsDir),'YES','*ALLSTMF'));                                   //0007
                                                                                         //0007
   If w_count = *Zero;                                                                   //0007
                                                                                         //0007
      upStatus  = 'E' ;                                                                  //0007
      upMessageId = 'MSG0203';                                                           //0007
      return ;                                                                           //0007
                                                                                         //0007
   Endif;                                                                                //0007
                                                                                         //0007
end-proc IsIFSDirectoryExists;                                                           //0007
