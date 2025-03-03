**free
      //%METADATA                                                      *
      // %TEXT IA - DDStoDDL Service Program                           *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------- //
//Created By  : Programmers.io @ 2024                                                   //
//Created Date: 19/11/2024                                                              //
//Developer   : Piyush Kumar                                                            //
//Description : This Service Program will use for DDS to DDL related procedure          //
//                                                                                      //
//------------------------------------------------------------------------------------- //
//Procedure Log:                                                                        //
//------------------------------------------------------------------------------------- //
//Procedure Name                | Procedure Description                                 //
//------------------------------|-------------------------------------------------------//
//iAGetSrcMbrInfo               |Get the Source Member Information from IAOBJMAP File   //
//------------------------------------------------------------------------------------- //
//
//Modification Log:                                                                     //
//------------------------------------------------------------------------------------- //
//Date-DMY| Mod_Id | Developer  | Case and Description                                  //
//--------|--------|------------|------------------------------------------------------ //
//
//------------------------------------------------------------------------------------- //
Ctl-Opt CopyRight('Copyright @ Programmers.io © 2024');
Ctl-Opt Option(*NoDebugIo : *SrcStmt : *NoUnRef);
Ctl-Opt NoMain;

//------------------------------------------------------------------------------------- //
//Prototype Definitions                                                                 //
//------------------------------------------------------------------------------------- //

//------------------------------------------------------------------------------------- //
//Copybook definitions                                                                  //
//------------------------------------------------------------------------------------- //
/copy 'QCPYSRC/iaddsddlpr.rpgleinc'

//------------------------------------------------------------------------------------- //
//Mainline Programming                                                                  //
//------------------------------------------------------------------------------------- //

Exec Sql
   Set Option Commit = *None,
              Naming = *Sys,
              UsrPrf = *User,
              DynUsrPrf = *User,
              CloSqlCsr = *Endmod,
              SrtSeq = *Langidshr;

//------------------------------------------------------------------------------------- //
//iAGetSrcMbrInfo : Get the Source Member Information from IAOBJMAP File                //
//          Input : 1. Object Library                                                   //
//                  2. Object Name                                                      //
//                  3. Object Type                                                      //
//                  4. Object Attribute                                                 //
//         Outout : 1. Member Library                                                   //
//                  2. Member File                                                      //
//                  3. Member Name                                                      //
//                  4. Member Type                                                      //
//------------------------------------------------------------------------------------- //
Dcl-Proc iAGetSrcMbrInfo Export;
   Dcl-Pi *N Char(40);
      upObjLib  Char(10);
      upObjName Char(10);
      upObjType Char(10);
      upObjAtr  Char(10);
   End-Pi;

   //Local Variables
   Dcl-S uwMbrLib  Char(10) Inz;
   Dcl-S uwMbrFile Char(10) Inz;
   Dcl-S uwMbrName Char(10) Inz;
   Dcl-S uwMbrType Char(10) Inz;
   Dcl-S uwRtnVal  Char(40) Inz;

   //To Fetch Member Library, Member File, Member Name, Member Type from IAOBJMAP File
   Exec Sql
      Select Member_Libr, Member_Srcf, Member_Name, Member_Type
        Into :uwMbrLib, :uwMbrFile, :uwMbrName, :uwMbrType
        From iAObjMap
       Where Object_Libr = :upObjLib
         And Object_Name = :upObjName
         And Object_Type = :upObjType
         And Object_Attr = :upObjAtr;

   If SqlCode <> 0;
      Return uwRtnVal;
   EndIf;

   uwRtnVal = uwMbrLib + uwMbrFile + uwMbrName + uwMbrType;

   Return uwRtnVal;

End-Proc;
