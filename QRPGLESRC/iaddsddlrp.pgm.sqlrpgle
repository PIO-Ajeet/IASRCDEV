**free
      //%METADATA                                                      *
      // %TEXT IA - DDStoDDL Dependent Files/Pgms Recompile List       *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------- //
//Created By  : Programmers.io @ 2024                                                   //
//Created Date: 2024/11/11                                                              //
//Developer   : S Karthick                                                              //
//Description : This program will Capture all dependent programs Details                //
//              into New file                                                           //
//                                                                                      //
//                       Input Parameters:                                              //
//              inReqId          -  Request Id                                          //
//              inReqUser        -  Request User Id                                     //
//------------------------------------------------------------------------------------- //
//Procedure Log:                                                                        //
//------------------------------------------------------------------------------------- //
//Procedure Name                    | Procedure Description                             //
//----------------------------------|---------------------------------------------------//
//RtvDdlObjLst                      | Retrieve DDL Object List                          //
//FetchCursorDdlObjLst              | Fetch list of DDL member into Cursor              //
//FetchObjRecompRqdFlg              | Fetch Object Recompilation Required Flag & Reason //
//FetchDdlRcdFmt                    | Fetch DDL file Record format                      //
//ChkDdsDateFmt                     | Check DDS Date Formats                            //
//ChkDdsDdlRcdFmt                   | Check DDS & DDL Record Format Mismatch            //
//ChkFfldKwds                       | Check DDS File Field Keywords (CONCAT, SST)       //
//FetchRcdFromFfldKwdCur            | Fetch DDS File Field Keywords From Cursor         //
//RetrieveDependentPgms             | Fetch Dependent Programs                          //
//FetchCursorDependentPrograms      | Fetch List of Dependent Programs From Cursor      //
//WriteiADdsDdlDO                   | Write Record into IADDSDDLDO                      //
//------------------------------------------------------------------------------------- //
//                                                                                      //
//------------------------------------------------------------------------------------- //
//Modification Log:                                                                     //
//------------------------------------------------------------------------------------- //
//Date-DMY| ModID  | Developer  | Case and Description                                  //
//--------|--------|------------|------------------------------------------------------ //
//        |        |            |                                                       //
//------------------------------------------------------------------------------------- //
Ctl-Opt CopyRight('Copyright @ Programmers.io © 2024');
Ctl-Opt Option(*NoDebugIo:*SrcStmt:*NoUnRef);
Ctl-Opt BndDir('IABNDDIR' : 'IAERRBND');
Ctl-Opt ActGrp(*Caller);

//------------------------------------------------------------------------------------- //
//Standalone Variables                                                                  //
//------------------------------------------------------------------------------------- //
Dcl-S uwDDSObjNam            Char(10)       Inz;
Dcl-S uwDDSObjLib            Char(10)       Inz;
Dcl-S uwDDSFlTyp             Char(3)        Inz;
Dcl-S uwDDLObjNam            Char(10)       Inz;
Dcl-S uwDDLObjLib            Char(10)       Inz;
Dcl-S uwDDLObjAttr           Char(10)       Inz;
Dcl-S uwDDLObjFmtId          Char(13)       Inz;
Dcl-S uwDDSObjFmtId          Char(13)       Inz;
Dcl-S uwDependentObjName     Char(10)       Inz;
Dcl-S uwDependentObjLib      Char(10)       Inz;
Dcl-S uwDependentObjType     Char(10)       Inz;
Dcl-S uwDependentObjAttr     Char(10)       Inz;
Dcl-S uwObjCmpFlg            Char(1)        Inz;
Dcl-S uwObjCmpRes            Char(80)       Inz;
Dcl-S uwAPIVariable          Char(32767)    Inz;
Dcl-S uwRtnFileName          Char(20)       Inz;
Dcl-S uwPgmNamLib            Char(20)       Inz;
Dcl-S uwMsgDesc              Char(1000)     Inz;
Dcl-S uwMsgVars              Char(80)       Inz;
Dcl-S uwDdsRcdfmt            Char(10)       Inz;

Dcl-S uwFileIndex            Packed(5:0)    Inz;

Dcl-S uwNoOfRows             Uns(5)         Inz;
Dcl-S uwDdlObjLstCount       Uns(3)         Inz;
Dcl-S uwDepPgmsRowsFetched   Uns(5)         Inz;
Dcl-S uwFfldKwdRowsFetched   Uns(5)         Inz;
Dcl-s uwFfldKwdMaxRows       Uns(5)         Inz;
Dcl-s uwRowNum               Uns(5)         Inz;
Dcl-S uiDdlLstIdx            Uns(3)         Inz;
Dcl-S uiDependentPgmsIdx     Uns(3)         Inz;

Dcl-S uwRowFound             Ind            Inz;

//------------------------------------------------------------------------------------- //
//Constant Variables                                                                    //
//------------------------------------------------------------------------------------- //
Dcl-C TRUE            '1';
Dcl-C FALSE           '0';
Dcl-C SYSTEM          '*LCL';
Dcl-C FORMAT          '*EXT';
Dcl-C OVERRIDE        '0';

//------------------------------------------------------------------------------------- //
//Prototype Interface                                                                   //
//------------------------------------------------------------------------------------- //
Dcl-Pi iADdsDdlRp;
   inReqId           Char(18);
   inReqUser         Char(10);
End-Pi;

//------------------------------------------------------------------------------------- //
//Datastructure Definitions                                                             //
//------------------------------------------------------------------------------------- //
//Datastructure for all the data objects selected from IADDSDDLDP File                  //
Dcl-Ds udDdlObjLst Qualified Dim(50);
   usDdsFlTyp   Char(3) ;
   usDdsObjLib  Char(10);
   usDdsObjNme  Char(10);
   usDdsRcdFmt  Char(10);
   usDdsFmtId   Char(13);
   usDdlObjLib  Char(10);
   usDdlObjNme  Char(10);
   usDdlObjAttr Char(10);
   usDdlFmtId   Char(13);
End-ds;

//Datastructure for the Dependent Programs
Dcl-Ds udDependentPrograms Qualified Dim(50);
   usDependentObjName    Char(10);
   usDependentObjLib     Char(10);
   usDependentObjType    Char(10);
   usDependentObjAttr    Char(10);
End-Ds;

//Datastructure for capturing errors in API
Dcl-Ds udApiErrC Qualified Inz;
   usBytProv           Int(10:0) Inz(%size(udApiErrC));
   usBytAvail          Int(10:0);
   usMsgId             Char(7);
   usReserved          Char(1);
   usMsgData           Char(3000);
End-Ds;

Dcl-Ds udSrvPgmInfEr Likeds(udApiErrC)  Inz;

//Datastructure for File Field Keyword
Dcl-Ds udFldKeywrd Qualified Dim(9);
   usfldkeywrd    Char(10);
End-Ds;

//------------------------------------------------------------------------------------- //
//Prototype Definitions                                                                 //
//------------------------------------------------------------------------------------- //
Dcl-pr IBMAPIRtvFileDesc Extpgm('QDBRTVFD');
   *n Char(32767) Options(*Varsize);
   *n Int(10)      Const;
   *n Char(20);
   *n Char(8)      Const;
   *n Char(20)     Const;
   *n Char(10)     Const;
   *n Char(1)      Const;
   *n Char(10)     Const;
   *n Char(10)     Const;
   *n Likeds(udApiErrC) options(*varsize);
End-pr;

Dcl-Pr iAGetMsg Extpgm('IAGETMSG');
   *n Char(01)     Options(*NoPass) Const;
   *n Char(07)     Options(*NoPass) Const;
   *n Char(1000)   Options(*NoPass)      ;
   *n Char(80)     Options(*NoPass) Const;
End-Pr;
//------------------------------------------------------------------------------------- //
//Copybook definitions                                                                  //
//------------------------------------------------------------------------------------- //
/copy 'QCPYSRC/iaderrlog.rpgleinc'

//------------------------------------------------------------------------------------- //
//Main Program                                                                          //
//------------------------------------------------------------------------------------- //
Exec Sql
   Set Option Commit    = *None,
              Naming    = *Sys,
              UsrPrf    = *User,
              DynUsrPrf = *User,
              CloSqlCsr = *Endmod;

   Eval-corr udpsds = wkudpsds;
//------------------------------------------------------------------------------------- //
//Cursor Declarations                                                                   //
//------------------------------------------------------------------------------------- //
//Cursor for Converted DDL Sources and Objects List
Exec Sql
   Declare CursorDdlObjLst Cursor For
    Select IaDdsFlTyp, IaDdsobjLb, IaDdsObjNm,
           IaDdsRcdFm, IaDdsFmtID, IaDdlobjLb,
           IaDdlObjNm, IaDdlObjAt, IaDdlFmtID
      From iADdsDdlDp
     Where IaReqId   = :inReqId
       and IaConvSts = 'S';

//Fetch the Dependent Programs from IAALLREFPF file
Exec Sql
  Declare CursorDependentPrograms Cursor For
   Select Object_Name, Library_Name, Object_Type, Object_Attr
     From iAAllRefPf
    Where iArObjNam = :uwDDSObjNam
      And iArObjLib = :uwDDSObjLib
      And iArObjTyp = '*FILE'
      And iAoObjTyp In ('*PGM','*MODULE','*SRVPGM')
     With Ur;

//Fetch the File Field Keyword from IAFILEDTL file
Exec Sql
   Declare FfldKwdCur Cursor for
    Select DBKWDNAME
      From iAFileDtl
     Where DblibName = :uwDDSObjLib
       And Dbfilenm  = :uwDDSObjNam
       And DbKwdName <> ' ';
//------------------------------------------------------------------------------------- //
//Main Processing                                                                       //
//------------------------------------------------------------------------------------- //

RtvDdlObjLst();

*InLr = *On;
Return;

//------------------------------------------------------------------------------------- //
//RtvDdlObjLst: Retrieve DDL Object List                                                //
//------------------------------------------------------------------------------------- //
Dcl-Proc RtvDdlObjLst;

   //Open cursor
   Exec Sql Open CursorDdlObjLst;
   If sqlCode = CSR_OPN_COD;
      Exec Sql Close CursorDdlObjLst;
      Exec Sql Open  CursorDdlObjLst;
   EndIf;

   If sqlCode < successCode;
      udpsds.wkQuery_Name = 'Open_CursorDdlObjLst';
      IaSqlDiagnostic(udpsds);
   EndIf;

   //Get the number of elements
   uwNoOfRows = %Elem(udDdlObjLst);

   //Fetch records from CursorDdlObjLst
   uwRowFound = FetchCursorDdlObjLst();

   Dow uwRowFound;
      For uiDdlLstIdx = 1 To uwDdlObjLstCount;

         uwDDSObjNam  = udDdlObjLst(uiDdlLstIdx).usDdsObjNme;
         uwDDSObjLib  = udDdlObjLst(uiDdlLstIdx).usDdsObjLib;
         uwDDSRcdFmt  = udDdlObjLst(uiDdlLstIdx).usDdsRcdFmt;
         uwDDSFlTyp   = udDdlObjLst(uiDdlLstIdx).usDdsFlTyp;
         uwDDLObjNam  = udDdlObjLst(uiDdlLstIdx).usDdlObjNme;
         uwDDLObjLib  = udDdlObjLst(uiDdlLstIdx).usDdlObjLib;
         uwDDLObjAttr = udDdlObjLst(uiDdlLstIdx).usDdlObjAttr;
         uwDDLObjFmtId= udDdlObjLst(uiDdlLstIdx).usDdlFmtId;
         uwDDSObjFmtId= udDdlObjLst(uiDdlLstIdx).usDdsFmtId;

         //Fetch Object Recompilation Required Flag
         FetchObjRecompRqdFlg();

         //Retrieve dependent programs
         RetrieveDependentPgms();
      EndFor;

      //If fetched rows are less than the array elements then come out of the loop.
      If uwDdlObjLstCount < uwNoOfRows;
         Leave ;
      EndIf ;

      //Fetched next set of rows.
      uwRowFound = FetchCursorDdlObjLst();
   Enddo;

   //Close cursor
   Exec Sql Close CursorDdlObjLst;

End-Proc;
//------------------------------------------------------------------------------------- //
//FetchCursorDdlObjLst: Fetch DDL object List from cursor                               //
//------------------------------------------------------------------------------------- //
Dcl-Proc FetchCursorDdlObjLst;

   Dcl-Pi FetchCursorDdlObjLst Ind End-Pi ;

   Dcl-S rcdFound Ind Inz('0');
   Dcl-S uwRowNum Uns(5);

   uwDdlObjLstCount = *Zeros;
   Clear udDdlObjLst;

   //Load Cursor Data into udDdlObjLst DataStructure
   Exec Sql
     Fetch CursorDdlObjLst For :uwNoOfRows Rows Into :udDdlObjLst;

   If sqlCode < successCode;
      udpsds.wkQuery_Name = 'Fetch_CursorDdlObjLst';
      IaSqlDiagnostic(udpsds);
   EndIf;

   If sqlcode = successCode;
      Exec Sql Get Diagnostics
         :uwRowNum = ROW_COUNT;
      uwDdlObjLstCount = uwRowNum ;
   EndIf;

   If uwDdlObjLstCount > 0;
      rcdFound = TRUE;
   ElseIf sqlcode < successCode ;
      rcdFound = FALSE;
   EndIf;

   Return rcdFound;

End-Proc;
//------------------------------------------------------------------------------------- //
//FetchObjRecompRqdFlg  : Fetch Object Recompilation Required Flag                      //
//------------------------------------------------------------------------------------- //
Dcl-Proc FetchObjRecompRqdFlg;

   uwObjCmpFlg = 'N';
   uwObjCmpRes = *Blanks;

   //Fetch Reason for Mismatch Format Identifier between DDS & DDL file
   If uwDDLObjFmtId <> uwDDSObjFmtId ;

      Select;
      //Check File Type is Multi member File
      When uwDDSFlTyp = 'MMF';
         uwObjCmpFlg = 'Y';
         iAGetMsg('1':'MSG0223':uwMsgDesc:' ');
         uwObjCmpRes = %trim(uwMsgDesc);

      //Check File type is Join Logical File.
      When uwDDSFlTyp = 'JLF';
         uwObjCmpFlg = 'Y';
         iAGetMsg('1':'MSG0224':uwMsgDesc:' ');
         uwObjCmpRes = %trim(uwMsgDesc);

      //Check File type is Multi Record Format File.
      When uwDDSFlTyp = 'MRF';
         uwObjCmpFlg = 'Y';
         iAGetMsg('1':'MSG0225':uwMsgDesc:' ');
         uwObjCmpRes = %trim(uwMsgDesc);

      //Check Date Format in DDS file.
      When ChkDdsDateFmt();
         uwObjCmpFlg = 'Y';
         iAGetMsg('1':'MSG0217':uwMsgDesc:' ');
         uwObjCmpRes = %trim(uwMsgDesc);

      //Check Record Format Name between DDS and DDL Objects
      When ChkDdsDdlRcdFmt();
         uwObjCmpFlg = 'Y';
         iAGetMsg('1':'MSG0218':uwMsgDesc:' ');
         uwObjCmpRes = %trim(uwMsgDesc);

      //Check Field Level Keyword in DDS file.
      When ChkFfldKwds();
         uwObjCmpFlg = 'Y';
         iAGetMsg('1':'MSG0219':uwMsgDesc:' ');
         uwObjCmpRes = %trim(uwMsgDesc);
      Endsl;

   EndIf;

End-Proc;
//------------------------------------------------------------------------------------- //
//RetrieveDependentPgms : Retrieve the Dependent Programs                               //
//------------------------------------------------------------------------------------- //
Dcl-Proc RetrieveDependentPgms;

   //Open cursor
   Exec Sql Open CursorDependentPrograms;
   If sqlCode = CSR_OPN_COD;
      Exec Sql Close CursorDependentPrograms;
      Exec Sql Open  CursorDependentPrograms;
   EndIf;

   If sqlCode < successCode;
      udpsds.wkQuery_Name = 'Open_CursorDependentPrograms';
      IaSqlDiagnostic(udpsds);
   EndIf;

   //Get the number of elements
   uwNoOfRows = %Elem(udDependentPrograms);

   //Fetch records from CursorDependentPrograms
   uwRowFound = FetchCursorDependentPrograms();

   Dow uwRowFound;
      For uiDependentPgmsIdx = 1 To uwDepPgmsRowsFetched;
         uwDependentObjName    = udDependentPrograms(uiDependentPgmsIdx).usDependentObjName;
         uwDependentObjLib     = udDependentPrograms(uiDependentPgmsIdx).usDependentObjLib;
         uwDependentObjType    = udDependentPrograms(uiDependentPgmsIdx).usDependentObjType;
         uwDependentObjAttr    = udDependentPrograms(uiDependentPgmsIdx).usDependentObjAttr;

         //Write Recrods into IADDSDDLDO file
         WriteiADdsDdlDO();
      EndFor;

      //If fetched rows are less than the array elements then come out of the loop.
      If uwDepPgmsRowsFetched < uwNoOfRows;
         Leave ;
      EndIf ;

      //Fetched next set of rows.
      uwRowFound = FetchCursorDependentPrograms();

   Enddo;

   //Close cursor
   Exec Sql Close CursorDependentPrograms;

End-Proc;
//------------------------------------------------------------------------------------- //
//FetchCursorDependentPrograms: fetch Dependent Programs From Cursor                    //
//------------------------------------------------------------------------------------- //
Dcl-Proc FetchCursorDependentPrograms;

   Dcl-Pi FetchCursorDependentPrograms Ind End-Pi ;

   Dcl-S  rcdFound Ind     Inz;
   Dcl-S  uwRowNum Uns(5)  Inz;

   uwDepPgmsRowsFetched = *zeros;
   Clear udDependentPrograms;

   //Load Cursor Data into udDependentPrograms DataStructure
   Exec Sql
      Fetch CursorDependentPrograms For :uwNoOfRows Rows Into :udDependentPrograms;

   If sqlCode < successCode;
      udpsds.wkQuery_Name = 'Fetch_CursorDependentPrograms';
      IaSqlDiagnostic(udpsds);
   EndIf;

   If sqlcode = successCode;
      Exec Sql Get Diagnostics
         :uwRowNum = ROW_COUNT;
         uwDepPgmsRowsFetched  = uwRowNum ;
   EndIf;

   If uwDepPgmsRowsFetched > 0;
      rcdFound = TRUE;
   ElseIf sqlcode < successCode ;
      rcdFound = FALSE;
   EndIf;

   Return rcdFound;

End-Proc;
//------------------------------------------------------------------------------------- //
//WriteiADdsDdlDO : Write Records into IADDSDDLDO file                                  //
//------------------------------------------------------------------------------------- //
Dcl-Proc WriteiADdsDdlDO;
   Exec Sql
      Insert into iADdsDdlDO( iAReqId      ,
                              iADdlLib     ,
                              iADdlNam     ,
                              iADdlTyp     ,
                              iADpObjLib   ,
                              iADpObjNme   ,
                              iADpObjTyp   ,
                              iADpObjAtt   ,
                              iACmpFlg     ,
                              iACmpRes     ,
                              iACrtPgm     ,
                              iACrtUser    )
                  Values    ( :inReqId            ,
                              :uwDDLObjLib        ,
                              :uwDDLObjNam        ,
                              :uwDDLObjAttr       ,
                              :uwDependentObjLib  ,
                              :uwDependentObjName ,
                              :uwDependentObjType ,
                              :uwDependentObjAttr ,
                              :uwObjCmpFlg        ,
                              :uwObjCmpRes        ,
                              'IADDSDDLRP'        ,
                              :inReqUser          );

      If SqlCode < successCode;
         udpsds.wkQuery_Name = 'Insert_IADDSDDLDO';
         IaSqlDiagnostic(udpsds);
      EndIf;

End-Proc;
//------------------------------------------------------------------------------------- //
//ChkDdsDateFmt : Check DDS Date Format, During DDL conversion Recrod format will       //
//                Changes other than *ISO or Timestamp maintained in DDS file.          //
//------------------------------------------------------------------------------------- //
Dcl-Proc ChkDdsDateFmt;

   Dcl-Pi ChkDdsDateFmt Ind End-Pi;

   Dcl-S uwVarDateFmt Ind         Inz;
   Dcl-S uwDateFmtCnt Packed(5:0) Inz;

   //Find DDS File Field with non *ISO date format
   Exec Sql
     Select count(*)
       into :uwDateFmtCnt
       From IdspFfd
      Where Whfldt in ('L','T','Z')
        and Whfmt <> '*ISO'
        and Whfile = :uwDDSObjNam
        and Whlib  = :uwDDSObjLib ;

   If uwDateFmtCnt > 0;
     uwVarDateFmt = TRUE;
   EndIf;

   Return uwVarDateFmt;
End-Proc;
//------------------------------------------------------------------------------------- //
//ChkDdsDdlRcdFmt: Check DDS and DDL Record format Mismatch                             //
//------------------------------------------------------------------------------------- //
Dcl-Proc ChkDdsDdlRcdFmt;

   Dcl-Pi ChkDdsDdlRcdFmt Ind End-Pi;

   Dcl-S uwDdlRcdFmt Char(10) Inz;
   Dcl-S uwRcdFmtFlg Ind         ;

   Clear uwDdlRcdFmt;
   //Fetch DDL File Record Format Name
   uwDdlRcdFmt = FetchDdlRcdFmt(uwDDLObjNam:uwDDLObjLib) ;

   //Return Flag with Mismatch Record Formats Between DDS & DDL file.
   If uwDdsRcdfmt <> uwDdlRcdFmt ;
      uwRcdFmtFlg = TRUE;
   EndIf;

   Return uwRcdFmtFlg;
End-Proc;
//------------------------------------------------------------------------------------- //
//ChkFfldKwds: Check File Field Keywords                                                //
//------------------------------------------------------------------------------------- //
Dcl-Proc ChkFfldKwds;

   Dcl-Pi ChkFfldKwds Ind End-Pi;

   Dcl-S uwFfldFlg Ind;

   //Open cursor. If it is already opened then close and open again
   Exec sql open FfldKwdCur;
   If sqlCode = CSR_OPN_COD;
      Exec sql close FfldKwdCur;
      Exec sql open  FfldKwdCur;
   EndIf;

   If sqlCode < successCode;
      udpsds.wkQuery_Name = 'Open_CSR_FfldKwdCur';
      IaSqlDiagnostic(udpsds);
   EndIf;

   If SqlCode = successCode;
      //Get Number of Rows
      uwFfldKwdMaxRows  = %Elem(udFldKeywrd);

      //Fetch Records From FfldKwdCur
      uWrowFound = FetchRcdFromFfldKwdCur() ;

      Dow uWrowFound;

        //Check for CONCAT and SST Keywords in DDS File Fields.
        If %Lookup('CONCAT':udFldKeywrd(*).usfldkeywrd)<>0 or
           %Lookup('SST':udFldKeywrd(*).usfldkeywrd) <>0;
           uwFfldFlg = TRUE;
           Leave;
        EndIf;

        //if fetched rows are less than the array elements then come out of the loop
        If uwFfldKwdRowsFetched < uwFfldKwdMaxRows ;
           Leave;
        EndIf;

        //Fetched next set of rows.
        uWrowFound = FetchRcdFromFfldKwdCur() ;
      Enddo;

      //Close cursor
      Exec sql close FfldKwdCur;

   EndIf;

   Return uwFfldFlg;

End-Proc;
//---------------------------------------------------------------------------------- //
//FetchRcdFromFfldKwdCur: Fetch record from File Field Keyword cursor
//---------------------------------------------------------------------------------- //
Dcl-Proc FetchRcdFromFfldKwdCur;

   Dcl-Pi FetchRcdFromFfldKwdCur Ind End-Pi ;

   Dcl-S  rcdFound Ind Inz('0');
   Dcl-S  uwRowNum Uns(5);

   Clear udFldKeywrd;
   //Load FfldKwdCur cursor data into udFldKeywrd DataStructure
   Exec sql Fetch FfldKwdCur for :uwFfldKwdMaxRows rows into:udFldKeywrd;

   If sqlCode < successCode;
      udpsds.wkQuery_Name = 'Fetch_CursorFfldKwds';
      IaSqlDiagnostic(udpsds);
   EndIf;

   //Retreive number of fetched rows
   If Sqlcode = successCode;
      Exec Sql Get Diagnostics
           :uWRowNum = ROW_COUNT;
      uwFfldKwdRowsFetched = uWRowNum;
   EndIf;

   //If no of fetched rows greater than zero then rerun true, else false
   If uwFfldKwdRowsFetched > 0;
      uWrowFound = TRUE;
   ElseIf Sqlcode < successCode;
      uWrowFound = FALSE;
   EndIf;

   Return uWrowFound;
End-Proc;
//------------------------------------------------------------------------------------- //
//FetchDdlRcdFmt : Fetch DDL Record format                                              //
//------------------------------------------------------------------------------------- //
Dcl-Proc FetchDdlRcdFmt;

   Dcl-pi FetchDdlRcdFmt Char(10);
      upObjNam   Char(10);
      upObjLib   Char(10);
   End-pi;

   Dcl-S uwFRecFmt Char(10);
   Dcl-S uwPos     Packed(5);

   uwPgmNamLib = upObjNam + upObjLib ;

   IBMAPIRtvFileDesc(uwAPIVariable:
                     %Size(uwAPIVariable):
                     uwRtnFileName:
                     'FILD0100':
                     uwPgmNamLib:
                     '*FIRST':
                     OVERRIDE:
                     SYSTEM:
                     FORMAT:
                     udSrvPgmInfEr);

   uwPos     = %Scan('RCDFMT':uwAPIVariable:1);
   If uwPos >0 ;
      uwFRecFmt = %Subst(uwAPIVariable:uwPos+7:10);
   Else;
      uwFRecFmt = ' ';
   EndIf;

   Return uwFRecFmt;
End-Proc;
