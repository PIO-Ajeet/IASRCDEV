      --%METADATA                                                      *
      -- %TEXT IA Pseudocode generation Stored Procedure               *
      --%EMETADATA                                                     *
----------------------------------------------------------------------------------------- //
--Created By.......: Programmers.io @ 2024                                                //
--Created Date.....: 2024/02/27                                                           //
--Developer........: Programmers.io                                                       //
--Description......: IA Pseudocode Generation Stored Procedure                            //
----------------------------------------------------------------------------------------- //
--Modification Log:                                                                       //
----------------------------------------------------------------------------------------- //
--Date    | Mod_Id | Developer  | Case and Description                                    //
----------|--------|------------|-------------------------------------------------------- //
--25/07/24| 0001   | SASIKUMAR R| To add input parameter for user id                      //
--        |        |            | and environment library.                                //
--08/10/24| 0002   | HIMANSHUGA | Added parm to select if commented text will be included //
--        |        |            | in pseudo code document: TASK 689                       //
--06/01/25| 0003   | HIMANSHUGA | Task:1099-Optional printing of declaration specs,this   //
--        |        |            | flag will decide if the config present in IAPSEUDOKP    //
--        |        |            | will be used or not.                                    //
----------------------------------------------------------------------------------------- //
--Compilation Instruction                                                                 //
---------------------------------------------------------------------------------------   //
--RUNSQLSTM SRCFILE(IASRCDEV/QDDLSRC) SRCMBR(IAPSEUDOS) DFTRDBCOL(IAOBJDEV) COMMIT(*NONE) //
----------------------------------------------------------------------------------------- //

Create Or Replace Procedure Generate_PseudoCode (
 In  inRequestId      Char(18),
 In  inRepoName       Char(10),
 In  inMemberLibrary  Char(10),
 In  inMemberSrcFile  Char(10),
 In  inMemberName     Char(10),
 In  inMemberType     Char(10),
 In  inUserId         Char(10),                                                           --0001
 In  inEnvLib         Char(10),                                                           --0001
 In  inIncludeText    Char(1),                                                            --0002
 In  inIncludeDecl    Char(1),                                                            --0003
 Out outReturnStatus  Char(1),
 Out outReturnMessage Char(100)
 )

 Language CL
 Not Deterministic
 Modifies Sql Data
 Parameter Style General
 External Name IAPSEUDOWR
