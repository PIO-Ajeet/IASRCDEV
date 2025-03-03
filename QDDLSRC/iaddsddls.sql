      --%METADATA                                                      *
      -- %TEXT IA - DDStoDDL Conversion Stored Procedure               *
      --%EMETADATA                                                     *
--------------------------------------------------------------------------------------- //
--Created By.......: Programmers.io @ 2024                                              //
--Created Date.....: 2024/03/15                                                         //
--Developer........: Programmers.io                                                     //
--Description......: Stored Procedure for DDS TO DDL Conversion.                        //
--------------------------------------------------------------------------------------- //
--Modification Log                                                                      //
--------------------------------------------------------------------------------------- //
--Date    | Mod_ID | Developer  | Case and Description                                  //
--------------------------------------------------------------------------------------- //
--24/10/24| 0001   |K ABHISHEK A| TASK#1038 - Copy PF file data to corresponding        //
--        |        |            | DDL file. Changes made to include Copy Data flag.     //
--------------------------------------------------------------------------------------- //
--Compilation Instruction                                                               //
--------------------------------------------------------------------------------------- //
--RUNSQLSTM SRCFILE(#IASRC/QDDLSRC) SRCMBR(IADDSDDLS) DFTRDBCOL(#IAOBJ) COMMIT(*NONE)   //
--------------------------------------------------------------------------------------- //

Create Or Replace Procedure DDSToDDLConversion
   (In  inReqId             Char(18),
    In  inRepo              Char(10),
    In  inDDSObjNam         Char(10),
    In  inDDSLibrary        Char(10),
    In  inDDSObjAttr        Char(10),
    In  inDDLMbrNam         Char(10),
    In  inDDLMbrLib         Char(10),
    In  inDDLObjNam         Char(10),
    In  inDDLObjLib         Char(10),
    In  inDDLLngNam         Char(128),
    In  inReplaceDDL        Char(1),
    In  inIncludeDepFile    Char(1),
    In  inIncludeDepPgms    Char(1),
    In  inIncludeAudCols    Char(1),
    In  inIncludeIdnCols    Char(1),
    In  inCopyData          Char(1),                                                     -0001
    In  inRequestedUser     Char(10),
    In  inEnvLibrary        Char(10),
    Out outStatus           Char(1),
    Out outMessage          Char(80))

  LANGUAGE CL
  SPECIFIC IADDSTODDL
  NOT DETERMINISTIC
  MODIFIES SQL DATA
  PARAMETER STYLE GENERAL
  EXTERNAL NAME IADDSDDLVL                                                                //CALLING
