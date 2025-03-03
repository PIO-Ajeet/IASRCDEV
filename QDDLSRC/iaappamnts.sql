      --%METADATA                                                      *
      -- %TEXT IA - App Area Maintainence Stored Procedure             *
      --%EMETADATA                                                     *
--------------------------------------------------------------------------------------- //
--Created By.......: Programmers.io @ 2024                                              //
--Created Date.....: 2024/08/30                                                         //
--Developer........: Programmers.io                                                     //
--Description......: Stored Procedure for Application Area Maintainence                 //
--------------------------------------------------------------------------------------- //
--Modification Log                                                                      //
--------------------------------------------------------------------------------------- //
--Date    | Mod_ID | Developer  | Case and Description                                  //
--------------------------------------------------------------------------------------- //
--                                                                                      //
--------------------------------------------------------------------------------------- //
--Compilation Instruction                                                               //
--------------------------------------------------------------------------------------- //
--RUNSQLSTM SRCFILE(#IASRC/QDDLSRC) SRCMBR(IAAPPAMNTS) DFTRDBCOL(#IAOBJ) COMMIT(*NONE)  //
--------------------------------------------------------------------------------------- //

Create Or Replace Procedure App_Area_Maintenance
   (In  inRepo              Char(10),
    In  inAppAreaName       Char(20),
    In  inOperationMode     Char(3),
    In  inUserId            Char(10),
    In  inEnvLib            Char(10),
    Out outStatus           Char(1),
    Out outMessage          Char(80))

  Language Cl
  Specific iAAppAMnts
  Not Deterministic
  Modifies Sql Data
  Parameter Style General
  External Name iAAppAMnCl                                                                //CALLING
