**free
      //%METADATA                                                      *
      // %TEXT Creating Index for the program                          *
      //%EMETADATA                                                     *
//--------------------------------------------------------------------------------------- //
//Created By    : Programmers.io @ 2022                                                   //
//Creation Date : 2022/12/01                                                              //
//Developer     : Gaurav Limba                                                            //
//Description   : To Create & Drop index for diffrent program                             //
//                                                                                        //
//PROCEDURE LOG:                                                                          //
//--------------------------------------------------------------------------------------- //
//Procedure Name           | Procedure Description                                        //
//-------------------------|------------------------------------------------------------- //
//No Procedure             |                                                              //
//--------------------------------------------------------------------------------------- //
//                                                                                        //
//MODIFICATION LOG:                                                                       //
//--------------------------------------------------------------------------------------- //
//Date    | Mod_ID | Developer  | Case and Description                                    //
//--------|--------|------------|-------------------------------------------------------- //
//22/12/07| SS02   | Sushant    | Created index on file IAFILEDTL for Alias name          //
//07/02/23| 001    |Ajeet Kumar | Index related changes.                                  //
//07/02/23| 002    |Pranav Joshi| Added new indexes and changed few existing.             //
//27/02/23| 003    |Sarvesh     | Added new Index and View for IAVARTRKR module execution.//
//22/02/23| 004    |Sribalaji   | Modify The Index Name And Add Some New Index.           //
//23/02/28| 005    |Kartik S    | Modify The PGM For Create Index On IASRV02SV used files.//
//23/03/29| 006    |Pranav Joshi| Added New Indexes for Stored Procedure Long Name query  //
//        |        |            | used in CPY2FNLREF.                                     //
//23/04/25| 007    |Yogesh J.   | Create IARPGIDX2, IARPGIDX3 Index On IAQRPGSRC Table.   //
//23/05/22| 008    |Pranav J.   | Create IAOBJMIDX1 on IAOBJMAP Table.                    //
//05/09/23| 009    |Thiyagu     | Create IAOBJREFIDX Index for IAOBJREFPF Table.          //
//04/10/23| 0010   |Sumer P     | Rename the file AILNGNMDTL from IALNGNMDTL (Task#246)   //
//        | 0011   |            | Rename AIERRLOGSV to IAERRLOGSV (Task#260)              //
//17/09/24| 0012   |Gopi Thorat | Rename IACPYBDTL file fields wherever used due to       //
//        |        |            | table changes. [Task#940]                               //
//22/01/25| 0013   |Vamsi       | IAPGMFILES is restructured.So,updated the columns       //
//        |        |Krishna2    | accordingly.(Task#63)                                   //
//--------------------------------------------------------------------------------------- //
//--------------------------------------------------------------------------------------- //
ctl-opt copyright('Programmers.io Â© 2022');
ctl-opt option(*NoDebugIO : *SrcStmt : *noUnRef);
ctl-opt DftActGrp(*No);
ctl-opt bndDir('IAERRBND');              //0011

/copy 'QCPYSRC/iaderrlog.rpgleinc'

dcl-pr IACRTINDXR extpgm('IACRTINDXR');
   In_IdxLib    char(10);
   In_Pgm       char(10);
end-pr;

dcl-pi IACRTINDXR;
   dcl-parm In_IdxLib char(10);
   dcl-parm In_Pgm    char(10);
end-pi;

dcl-s Idx_stm       char(1000);
Dcl-c WQuote        Const('''');                                                         //003

//--------------------------------------------------------------------------------------- //
//Main Functions                                                                          //
//--------------------------------------------------------------------------------------- //
   exec sql
      set option commit    = *none,
                 naming    = *sys,
                 dynusrprf = *user,
                 usrprf    = *user,
                 closqlcsr = *endmod;

   Eval-corr uDpsds = wkuDpsds;

   Exsr Sr_IACRTINDX;

  *inlr = *on;
/copy 'QCPYSRC/iacerrlog.rpgleinc'

//--------------------------------------------------------------------------------------- //
//SubRoutines                                                                             //
//--------------------------------------------------------------------------------------- //
  Begsr Sr_IACRTINDX;
     Select;
        When In_Pgm = 'Iainit';
           Clear Idx_stm;
           Idx_stm = 'Create Index ' + %trim(In_IdxLib) + '/IASRCIDX1'  +                  //004
                     ' On ' + %trim(In_IdxLib) + '/IASRCPF' +
                     ' (LIBRARY_NAME)';

           uDpsds.wkQuery_Name = 'Create_Index_IASRCIDX1';                               //004
           exsr CrtIdxsr;

           Clear Idx_stm;
           Idx_stm = 'Create Index ' + %trim(In_IdxLib) + '/IAMBRIDX1'  +                  //004
                     ' On ' + %trim(In_IdxLib) + '/IDSPFDMBRL' +
                     ' (MLLIB, MLFILE, MLSEU)';

           uDpsds.wkQuery_Name = 'Create_Index_IAMBRIDX1';                               //004
           exsr CrtIdxsr;

           Clear Idx_stm;
           Idx_stm = 'Create Index ' + %trim(In_IdxLib) + '/IARPGIDX1'  +
                     ' On ' + %trim(In_IdxLib) + '/IAQRPGSRC' +
                     ' (XLIBNAM, XSRCNAM, XMBRNAM, XSRCRRN)';

           uDpsds.wkQuery_Name = 'Create_Index_IARPGIDX1';
           exsr CrtIdxsr;

//--------------------------------------------------------------------------------------//
//  Create IARPGIDX2 Index On IAQRPGSRC File To For Use In The IAPSRRPG PGM             //
//--------------------------------------------------------------------------------------//
           Clear Idx_stm;                                                                //007
           Idx_stm = 'Create Index ' + %trim(In_IdxLib) + '/IARPGIDX2'  +                //007
                     ' On ' + %trim(In_IdxLib) + '/IAQRPGSRC' +                          //007
                     ' (XLIBNAM, XSRCNAM, XMBRNAM, XSRCLTYP)';                           //007

           uDpsds.wkQuery_Name = 'Create_Index_IARPGIDX2';                               //007
           exsr CrtIdxsr;                                                                //007

//--------------------------------------------------------------------------------------//
//  Create IARPGIDX3 Index On IAQRPGSRC File To For Use In The IAPSRRPG PGM             //
//--------------------------------------------------------------------------------------//
           Clear Idx_stm;                                                                //007
           Idx_stm = 'Create Index ' + %trim(In_IdxLib) + '/IARPGIDX3'  +                //007
                     ' On ' + %trim(In_IdxLib) + '/IAQRPGSRC' +                          //007
                     ' ( XSRCLTYP )';                                                    //007

           uDpsds.wkQuery_Name = 'Create_Index_IARPGIDX3';                               //007
           exsr CrtIdxsr;                                                                //007
//--------------------------------------------------------------------------------------//

           Clear Idx_stm;
           Idx_stm = 'Create Index ' + %trim(In_IdxLib) + '/IACLIDX01'  +                  //004
                     ' On ' + %trim(In_IdxLib) + '/IAQCLSRC' +
                     ' (YLIBNAM, YSRCNAM, YMBRNAM, YSRCRRN)';

           uDpsds.wkQuery_Name = 'Create_Index_IACLIDX01';                               //004
           exsr CrtIdxsr;

           Clear Idx_stm;
           Idx_stm = 'Create Index ' + %trim(In_IdxLib) + '/IADDSIDX1'  +                  //004
                     ' On ' + %trim(In_IdxLib) + '/IAQDDSSRC' +
                     ' (WLIBNAM, WSRCNAM, WMBRNAM, WSRCRRN)';

           uDpsds.wkQuery_Name = 'Create_Index_IADDSIDX1';                               //004
           exsr CrtIdxsr;

           Clear Idx_stm;
           Idx_stm = 'Create Index ' + %trim(In_IdxLib) + '/IACPGMIDX'  +                  //004
                     ' On ' + %trim(In_IdxLib) + '/IACPGMREF' +
                     ' (PLIBNAM, PSRCPFNM, PMBRNAM, PSRCRRN)';

           uDpsds.wkQuery_Name = 'Create_Index_IACPGMIDX';                               //004
           exsr CrtIdxsr;

           Clear Idx_stm;
           Idx_stm = 'Create Index ' + %trim(In_IdxLib) + '/IAPGMIDX1'  +                  //004
                     ' On ' + %trim(In_IdxLib) + '/IAPGMREF' +
                     ' (PLIBNAM, PSRCPFNM, PMBRNAM, PSRCRRN, PSRCWRD)';                    //002

           uDpsds.wkQuery_Name = 'Create_Index_IAPGMIDX1';                                 //004
           exsr CrtIdxSr;

           Clear Idx_stm;                                                                  //002
           Idx_stm = 'Create Index ' + %trim(In_IdxLib) + '/IAPGMIDX2'  +                  //004
                     ' On ' + %trim(In_IdxLib) + '/IAPGMREF' +                             //002
                     ' (PLIBNAM, PSRCPFNM, PMBRNAM, PSRCWRD, PWRDOBJV)';                   //002
                                                                                           //002
           uDpsds.wkQuery_Name = 'Create_Index_IAPGMIDX2';                                 //004
           exsr CrtIdxSr;                                                                  //002
                                                                                           //002
           Clear Idx_stm;                                                                  //002
           Idx_stm = 'Create Index ' + %trim(In_IdxLib) + '/IAPGMIDX3'  +                  //004
                     ' On ' + %trim(In_IdxLib) + '/IAPGMREF' +                             //002
                     ' (PLIBNAM, PSRCPFNM, PMBRNAM, PSRCWRD, PWRDATTR)';                   //002
                                                                                           //002
           uDpsds.wkQuery_Name = 'Create_Index_IAPGMIDX3';                                 //004
           exsr CrtIdxSr;                                                                  //002
                                                                                           //002
           Clear Idx_stm;                                                                  //001
           Idx_stm = 'Create Index ' + %trim(In_IdxLib) + '/IAPGMVIDX'  +                  //004
                     ' On ' + %trim(In_IdxLib) + '/IAPGMVARS' +                            //001
                     ' (IAVLIB, IAVSFILE, IAVMBR, IAVVAR)';                                //001
                                                                                           //001
           uDpsds.wkQuery_Name = 'Create_Index_IAPGMVIDX';                                 //004
           exsr CrtIdxsr;                                                                  //001
                                                                                           //001
           Clear Idx_stm;                                                                  //001
           Idx_stm = 'Create Index ' + %trim(In_IdxLib) + '/IAPGMDIDX1' +                  //004
                     ' On ' + %trim(In_IdxLib) + '/IAPGMDS' +                              //001
                     ' (DSSRCLIB, DSSRCFLN, DSPGMNM, DSFLDNM)';                            //001
                                                                                           //001
           uDpsds.wkQuery_Name = 'Create_Index_IAPGMDIDX1';                                //004
           exsr CrtIdxsr;                                                                  //001
                                                                                           //001
           Clear Idx_stm;                                                                  //001
           Idx_stm = 'Create Index ' + %trim(In_IdxLib) + '/IAPGMDIDX2' +                  //004
                     ' On ' + %trim(In_IdxLib) + '/IAPGMDS' +                              //001
                     ' (DSSRCLIB, DSSRCFLN, DSPGMNM, DSNAME)';                             //001
                                                                                           //001
           uDpsds.wkQuery_Name = 'Create_Index_IAPGMDIDX2';                                //004
           exsr CrtIdxsr;                                                                  //001
                                                                                           //002
           Clear Idx_stm;                                                                  //002
           Idx_stm = 'Create Index ' + %trim(In_IdxLib) + '/IAPGMDIDX3' +                  //004
                     ' On ' + %trim(In_IdxLib) + '/IAPGMDS' +                              //002
                     ' (DSNAME)';                                                          //002
                                                                                           //002
           uDpsds.wkQuery_Name = 'Create_Index_IAPGMDIDX3';                                //004
           exsr CrtIdxsr;                                                                  //002

           Clear Idx_stm;                                                                  //001
           Idx_stm = 'Create Index ' + %trim(In_IdxLib) + '/IAENTPIDX'  +                  //004
                    ' On ' + %trim(In_IdxLib) + '/IAENTPRM' +                              //001
                    ' (ELIBNAME, ESRCPFNM, EMBRNAM, EPRMNAM)';                             //001

           uDpsds.wkQuery_Name = 'Create_Index_IAENTPIDX';                                 //004
           exsr CrtIdxsr;                                                                  //001

           Clear Idx_stm;                                                                  //004
           Idx_stm = 'Create Index ' + %trim(In_IdxLib) + '/IACPYBIDX'  +                  //004
                     ' On ' + %trim(In_IdxLib) + '/IACPYBDTL' +                            //004
                     ' (IAMBRNAME, IACPYMBR  )';                                          //004 0012
                                                                                           //004
           uDpsds.wkQuery_Name = 'Create_Index_IACPYBIDX';                                 //004
           exsr CrtIdxsr;                                                                  //004

           Clear Idx_stm;                                                                  //004
           Idx_stm = 'Create Index ' + %trim(In_IdxLib) + '/IASUBRIDX' +                   //004
                     ' On ' + %trim(In_IdxLib) + '/IASUBRDTL'  +                           //004
                     ' (MBR_SRC_PFNM, MBR_LIB, MBR_NAME, MBR_RRN)';                        //004

           uDpsds.wkQuery_Name = 'Create_Index_IASUBRIDX';                                 //004
           exsr CrtIdxsr;                                                                  //004

           Clear Idx_stm;                                                                  //004
           Idx_stm = 'Create Index ' + %trim(In_IdxLib) + '/IAPRCIDX1'  +                  //004
                     ' On ' + %trim(In_IdxLib) + '/IAPRCPARM' +                            //004
                     ' (PLIBNAM, PSRCPF, PMBRNAM, PPRMNAM)';                               //004
                                                                                           //004
           uDpsds.wkQuery_Name = 'Create_Index_IAPRCIDX1';                                 //004
           exsr CrtIdxsr;                                                                  //004
                                                                                           //004
           Clear Idx_stm;                                                                  //004
           Idx_stm = 'Create Index ' + %trim(In_IdxLib) + '/IAPGMFLIDX' +                  //004
                     ' On ' + %trim(In_IdxLib) + '/IAPGMFILES' +                           //004
                     ' (LIBRARY, SOURCE_FILE, MEMBER_NAME, ACTUAL_FILE)';                 //0013

           uDpsds.wkQuery_Name = 'Create_Index_IAPGMFLIDX';                                //004
           exsr CrtIdxsr;                                                                  //004

           Clear Idx_stm;                                                                  //004
           Idx_stm = 'Create Index ' + %trim(In_IdxLib) + '/IAPGMCALIDX'+                  //004
                     ' On ' + %trim(In_IdxLib) + '/IAPGMCALLS' +                           //004
                     ' (MBR_SRC_PFNM, MBR_LIB, MBR_NAME, MBR_RRN)';                        //004

           uDpsds.wkQuery_Name = 'Create_Index_IAPGMCALIDX';                               //004
           exsr CrtIdxsr;                                                                  //004

           Clear Idx_stm;                                                                  //004
           Idx_stm = 'Create Index ' + %trim(In_IdxLib) + '/IAESQLIDX'  +                  //004
                     ' On ' + %trim(In_IdxLib) + '/IAESQLFFD' +                            //004
                     ' (CSRCLIB, CSRCFLN, CPGMNM, CFLDSQLNM)';                             //004

           uDpsds.wkQuery_Name = 'Create_Index_IAESQLIDX';                                 //004
           exsr CrtIdxsr;                                                                  //004

           Clear Idx_stm;                                                                  //004
           Idx_stm = 'Create Index ' + %trim(In_IdxLib) + '/IAPSRLGIDX' +                  //004
                     ' On ' + %trim(In_IdxLib) + '/IAPSRLOG '  +                           //004
                     ' (FROM_PGM_NM, LIBRARY_NAME, SRC_PF_NAME,' +                         //004
                     ' MEMBER_NAME)';                                                      //004

           uDpsds.wkQuery_Name = 'Create_Index_IAPSRLGIDX';                                //004
           exsr CrtIdxsr;                                                                  //004

           Clear Idx_stm;                                                                  //004
           Idx_stm = 'Create Index ' + %trim(In_IdxLib) + '/IAREPOLGIDX'+                  //004
                     ' On ' + %trim(In_IdxLib) + '/IAREPOLOG'  +                           //004
                     ' (REPO_NAME, REPO_ACTION, ACTION_DETAILS)';                          //004

           uDpsds.wkQuery_Name = 'Create_Index_IAREPOLGIDX';                               //004
           exsr CrtIdxsr;                                                                  //004

           Clear Idx_stm;                                                                  //004
           Idx_stm = 'Create Index ' + %trim(In_IdxLib) + '/IACALLPRMIDX'+                 //004
                     ' On ' + %trim(In_IdxLib) + '/IACALLPARM' +                           //004
                     ' (MBR_SRC_PFNM, MBR_LIB, MBR_NAME, MBR_RRN)';                        //004

           uDpsds.wkQuery_Name = 'Create_Index_IACALLPRMIDX';                              //004
           exsr CrtIdxsr;                                                                  //004

           Clear Idx_stm;                                                                  //004
           Idx_stm = 'Create Index ' + %trim(In_IdxLib) + '/IASRCINTIDX'+                  //005
                     ' On ' + %trim(In_IdxLib) + '/IASRCINTPF' +                           //005
                     ' (IAMBRSRC ,IAMBRLIB, IAMBRNAM, IAMBRTYP)';                          //005

           uDpsds.wkQuery_Name = 'Create_Index_IASRCINTIDX';                               //005
           exsr CrtIdxsr;                                                                  //005

           Clear Idx_stm;                                                                  //004
           Idx_stm = 'Create Index ' + %trim(In_IdxLib) + '/PSQLRSVIDX'+                   //004
                     ' On ' + %trim(In_IdxLib) + '/PSQLRSVWRD' +                           //004
                     ' (PSQLRSVWRD_PK, RESERVE_WORD, CRT_TIMESTAM,'+                       //004
                     '  CHG_TIMESTAM)';                                                    //004

           uDpsds.wkQuery_Name = 'Create_Index_PSQLRSVIDX';                                //004
           exsr CrtIdxsr;                                                                  //004

           Clear Idx_stm;                                                                  //004
           Idx_stm = 'Create Index ' + %trim(In_IdxLib) + '/IDSPFFDIDX'+                   //004
                     ' On ' + %trim(In_IdxLib) + '/IDSPFFD' +                              //004
                     ' (WHFILE, WHLIB, WHFTYP, WHCNT, WHNAME)';                            //004

           uDpsds.wkQuery_Name = 'Create_Index_IDSPFFDIDX';                                //004
           exsr CrtIdxsr;                                                                  //004

           Clear Idx_stm;                                                                  //004
           Idx_stm = 'Create Index ' + %trim(In_IdxLib) + '/IAOVRPFIDX'+                   //005
                     ' On ' + %trim(In_IdxLib) + '/IAOVRPF' +                              //005
                     ' (IOVR_MBR, IOVR_FILE , IOVR_LIB, IOVR_RRN)';                        //005
                                                                                           //005
           uDpsds.wkQuery_Name = 'Create_Index_IAOVRPFIDX';                                //005
           exsr CrtIdxsr;                                                                  //005

           Clear Idx_stm;                                                                  //005
           Idx_stm = 'Create Index ' + %trim(In_IdxLib) + '/IALISTIDX'+                    //005
                     ' On ' + %trim(In_IdxLib) + '/IAPGMKLIST' +                           //005
                     ' (LIBRARY_NAME, SRC_PF_NAME, MEMBER_NAME)';                          //005
                                                                                           //005
           uDpsds.wkQuery_Name = 'Create_Index_IALISTIDX';                                 //005
           exsr CrtIdxsr;                                                                  //005

           Clear Idx_stm;                                                                  //005
           Idx_stm = 'Create Index ' + %trim(In_IdxLib) + '/IDSPPGMIDX'+                   //005
                     ' On ' + %trim(In_IdxLib) + '/IDSPPGMREF' +                           //005
                     ' (WHLIB, WHPNAM , WHSNAM)';                                          //005
                                                                                           //005
           uDpsds.wkQuery_Name = 'Create_Index_IDSPPGMIDX';                                //005
           exsr CrtIdxsr;                                                                  //005

           Clear Idx_stm;                                                                  //006
           Idx_stm = 'Create Index ' + %trim(In_IdxLib) + '/IAOBJMIDX1'+                   //006
                     ' On ' + %trim(In_IdxLib) + '/IAOBJMAP'   +                           //006
                     ' (IAMBRLIB, IAMBRSRCF, IAMBRNAM)' ;                                  //006
                                                                                           //006
           uDpsds.wkQuery_Name = 'Create_Index_IAOBJMIDX1';                                //006
           exsr CrtIdxsr;                                                                  //006
                                                                                           //006
           Clear Idx_stm;                                                                  //006
           Idx_stm = 'Create Index ' + %trim(In_IdxLib) + '/IASRCINTIDX1'+                 //006
                     ' On ' + %trim(In_IdxLib) + '/IASRCINTPF' +                           //006
                     ' (IAREFOLIB, IAREFOBJ)' ;                                            //006
                                                                                           //006
           uDpsds.wkQuery_Name = 'Create_Index_IASRCINTIDX1';                              //006
           exsr CrtIdxsr;                                                                  //006
                                                                                           //006
           Clear Idx_stm;                                                                  //009
           Idx_stm = 'Create Index ' + %trim(In_IdxLib) + '/IAOBJREFIDX'+                  //009
                     ' On ' + %trim(In_IdxLib) + '/IAOBJREFPF' +                           //009
                     ' (WHLIB, WHSPKG, WHOTYP, WHFNAM, WHPNAM, WHLNAM)' ;                  //009

           uDpsds.wkQuery_Name = 'Create_Index_IAOBJREFIDX' ;                              //009
           exsr CrtIdxsr;                                                                  //009

           Clear Idx_stm;                                                                  //006
           Idx_stm = 'Create Index ' + %trim(In_IdxLib) + '/IALNGNMIDX'+            //0010 //006
                     ' On ' + %trim(In_IdxLib) + '/IALNGNMDTL' +                     //006 //0010
                     ' (AIRTNLIB, AIRTNNAM)' ;                                             //006
                                                                                           //006
           uDpsds.wkQuery_Name = 'Create_Index_IALNGNMIDX' ;                        //0010 //006
           exsr CrtIdxsr;                                                                  //006

        When In_Pgm  = 'IAFILEDTLR';
           Clear Idx_stm;
           Idx_stm = 'Create Index ' + %trim(In_IdxLib) + '/IAFILIDX1'  +
                     ' On ' + %trim(In_IdxLib) + '/IAFILEDTL' +
                     ' (DBLIBNAME, DBSRCPFNM, DBMBRNAM, DBFLDNMI)';

           uDpsds.wkQuery_Name = 'Create_Index_IAFILIDX1';
           exsr CrtIdxsr;

           Clear Idx_stm;
           Idx_stm = 'Create Index ' + %trim(In_IdxLib) + '/IAFILIDX2' +
                     ' On ' + %trim(In_IdxLib) + '/IAFILEDTL' +
                     ' (DBFLDNMI)';

           uDpsds.wkQuery_Name = 'Create_Index_IAFILIDX2';
           exsr CrtIdxsr;

           Clear Idx_stm;
           Idx_stm = 'Create Index ' + %trim(In_IdxLib) + '/IAFILIDX3'  +
                     ' On ' + %trim(In_IdxLib) + '/IAFILEDTL' +
                     ' (DBREFFLD)';

           uDpsds.wkQuery_Name = 'Create_Index_IAFILIDX3';
           exsr CrtIdxsr;
                                                                                           //SS02
           Clear Idx_stm;                                                                  //SS02
           Idx_stm = 'Create Index ' + %trim(In_IdxLib) + '/IAFILIDX4'  +                  //SS02
                     ' On ' + %trim(In_IdxLib) + '/IAFILEDTL' +                            //SS02
                     ' (DBLIBNAME, DBSRCPFNM, DBMBRNAM, DBFLDNMI,'+                        //SS02
                     ' DBFLDNMA)';                                                         //SS02
                                                                                           //SS02
           uDpsds.wkQuery_Name = 'Create_Index_IAFILIDX4';                                 //SS02
           exsr CrtIdxsr;                                                                  //SS02

           Clear Idx_stm;
           Idx_stm = 'Create Index ' + %trim(In_IdxLib) + '/IAFILIDX5'  +
                     ' On ' + %trim(In_IdxLib) + '/IAFILEDTL' +
                     ' (DBFLDNMX)';

           uDpsds.wkQuery_Name = 'Create_Index_IAFILIDX5';
           exsr CrtIdxsr;

        When In_Pgm  = 'IAVARTRKR';

         //Clear Idx_stm;
         //Idx_stm = 'Create Index ' + %trim(In_IdxLib) + '/IAPRCP001'  +
         //          ' On ' + %trim(In_IdxLib) + '/IAPRCPARM' +
         //          ' (PLIBNAM, PSRCPF, PMBRNAM, PPRMNAM)';
         //
         //uDpsds.wkQuery_Name = 'Create_Index_IAPRCP001';
         //exsr CrtIdxsr;

         //Clear Idx_stm;
         //Idx_stm = 'Create Index ' + %trim(In_IdxLib) + '/IAESQL001'  +
         //          ' On ' + %trim(In_IdxLib) + '/IAESQLFFD' +
         //          ' (CSRCLIB, CSRCFLN, CPGMNM, CFLDSQLNM)';
         //
         //uDpsds.wkQuery_Name = 'Create_Index_IAESQL001';
         //exsr CrtIdxsr;

         //Clear Idx_stm;
         //Idx_stm = 'Create Index ' + %trim(In_IdxLib) + '/IACPYB001'  +
         //          ' On ' + %trim(In_IdxLib) + '/IACPYBDTL' +
         //          ' (CBMEMNAME, CBCPYMBRNM)';
         //
         //uDpsds.wkQuery_Name = 'Create_Index_IACPYB001';
         //exsr CrtIdxsr;

           Clear Idx_stm;
           Idx_stm = 'Create Index ' + %trim(In_IdxLib) + '/IAALLRIDX'  +
                     ' On ' + %trim(In_IdxLib) + '/IAALLREFPF' +
                     ' (IAROBJTYP, IAOOBJNAM, IAROBJNAM)';

           uDpsds.wkQuery_Name = 'Create_Index_IAALLRIDX';
           exsr CrtIdxsr;

           Clear Idx_stm;
           Idx_stm = 'Create Index ' + %trim(In_IdxLib) + '/IAPRFXIDX'  +
                     ' On ' + %trim(In_IdxLib) + '/IAPRFXDTL' +
                     ' (IAPFXLIB, IAPFXSPF, IAPFXMBR, IAPFXFLNM, IAPFXOLD)';

           uDpsds.wkQuery_Name = 'Create_Index_IAPRFXIDX';
           exsr CrtIdxsr;

           Clear Idx_stm;
           Idx_stm = 'Create Index ' + %trim(In_IdxLib) + '/IAOBJMIDX'  +
                     ' On ' + %trim(In_IdxLib) + '/IAOBJMAP' +
                     ' (IAOBJLIB, IAOBJATR, IAOBJNAM)';

           uDpsds.wkQuery_Name = 'Create_Index_IAOBJMIDX';
           exsr CrtIdxsr;
                                                                                           //003
           //This index is created for the query to fetch details of a file field
           //used in a program.
           Clear Idx_stm;                                                                  //008
           Idx_stm = 'Create Index ' + %trim(In_IdxLib) + '/IAOBJMIDX2'  +                 //008
                     ' On ' + %trim(In_IdxLib) + '/IAOBJMAP' +                             //008
                     ' (IAMBRLIB, IAMBRSRCF, IAMBRNAM, ' +                                 //008
                     ' IAOBJLIB, IAOBJATR, IAOBJNAM)';                                     //008
                                                                                           //008
           uDpsds.wkQuery_Name = 'Create_Index_IAOBJMIDX2';                                //008
           exsr CrtIdxsr;                                                                  //008
                                                                                           //003
           Clear Idx_stm;                                                                  //003
           Idx_stm = 'Create Index ' + %trim(In_IdxLib) + '/IAVARIDX'  +                   //003
                     ' On ' + %trim(In_IdxLib) + '/IAVARREL' +                             //003
                     ' (LIBRARY_NAME ASC, SRC_PF_NAME ASC,' +                              //003
                     ' MEMBER_NAME ASC, SOURCE_RRN ASC)';                                  //003
                                                                                           //003
           uDpsds.wkQuery_Name = 'Create_Index_IAVARIDX';                                  //003
           exsr CrtIdxsr;                                                                  //003

           Clear Idx_stm;                                                                  //004
           Idx_stm = 'Create Index ' + %trim(In_IdxLib) + '/IASRCMBIDX' +                  //004
                     ' On ' + %trim(In_IdxLib) + '/IASRCMBRID' +                           //004
                     ' (MEMBER_LIB, MEMBER_NAME, MBR_SRC_PF, MEMBER_TYPE)';                //004

           uDpsds.wkQuery_Name = 'Create_Index_IASRCMBIDX';                                //004
           exsr CrtIdxsr;                                                                  //004
                                                                                           //003
           Clear Idx_stm;                                                                  //003
           Idx_stm = 'Create View ' + %trim(In_IdxLib) + '/IAFILEVU1' + ' AS' +            //003
                     ' SELECT * FROM ' + %trim(In_IdxLib) + '/IAFILEDTL' +                 //003
                     '  WHERE REF_FIELD <> ' + WQuote + ' ' + WQuote ;                     //003
                                                                                           //003
           uDpsds.wkQuery_Name = 'Create_View_IAFILEVU1';                                  //003
           exsr CrtIdxsr;                                                                  //003

           Clear Idx_stm;                                                                  //004
           Idx_stm = 'Create Index ' + %trim(In_IdxLib) + '/IAFILEIDX'  +                  //004
                     ' On ' + %trim(In_IdxLib) + '/IAFILEDTL' +                            //004
                     ' (MEMBER_NAME, SRCPF_NAME, LIBRARY_NAME, FILE_NAME,'+                //004
                     '  FILE_TYPE)';                                                       //004

           uDpsds.wkQuery_Name = 'Create_Index_IAFILEIDX';                                 //004
           exsr CrtIdxsr;                                                                  //004

           Clear Idx_stm;                                                                  //008
           Idx_stm = 'Create Index ' + %trim(In_IdxLib) + '/IAFILEIDX1' +                  //008
                     ' On ' + %trim(In_IdxLib) + '/IAFILEDTL' +                            //008
                     ' (DBFLDNMA)';                                                        //008
                                                                                           //008
           uDpsds.wkQuery_Name = 'Create_Index_IAFILEIDX1';                                //008
           exsr CrtIdxsr;                                                                  //008
                                                                                           //008
           Clear Idx_stm;                                                                  //008
           Idx_stm = 'Create Index ' + %trim(In_IdxLib) + '/IAFILEIDX2' +                  //008
                     ' On ' + %trim(In_IdxLib) + '/IAFILEDTL' +                            //008
                     ' (DBLIBNAME , DBFILENM)';                                            //008
                                                                                           //008
           uDpsds.wkQuery_Name = 'Create_Index_IAFILEIDX2';                                //008
           exsr CrtIdxsr;                                                                  //008
                                                                                           //008
           Clear Idx_stm;                                                                  //004
           Idx_stm = 'Create Index ' + %trim(In_IdxLib) + '/IDSPOBJIDX' +                  //004
                     ' On ' + %trim(In_IdxLib) + '/IDSPOBJD' +                             //004
                     ' (ODLBNM, ODOBNM, ODOBTP, ODOBAT)';                                  //004

           uDpsds.wkQuery_Name = 'Create_Index_IDSPOBJIDX';                                //004
           exsr CrtIdxsr;                                                                  //004

           Clear Idx_stm;                                                                  //004
           Idx_stm = 'Create Index ' + %trim(In_IdxLib) + '/IASRCVRIDX' +                  //004
                     ' On ' + %trim(In_IdxLib) + '/IASRCVARID' +                           //004
                     ' (VARIABLE_NM, VARIABLE_TYP, VARIABLE_LEN)';                         //004

           uDpsds.wkQuery_Name = 'Create_Index_IASRCVRIDX';                                //004
           exsr CrtIdxsr;                                                                  //004

        When In_Pgm  = '  ';
           Clear Idx_stm;
           Idx_stm = 'Drop Index ' + %trim(In_IdxLib) + '/IASRCIDX1';
           exec sql prepare DrpIdx from :Idx_stm;
           exec sql execute DrpIdx;

           Clear Idx_stm;
           Idx_stm = 'Drop Index ' + %trim(In_IdxLib) + '/IAMBRIDX1';
           exec sql prepare DrpIdx from :Idx_stm;
           exec sql execute DrpIdx;

           Clear Idx_stm;
           Idx_stm = 'Drop Index ' + %trim(In_IdxLib) + '/IARPGIDX1';
           exec sql prepare DrpIdx from :Idx_stm;
           exec sql execute DrpIdx;

           Clear Idx_stm;
           Idx_stm = 'Drop Index ' + %trim(In_IdxLib) + '/IACLIDX01';
           exec sql prepare DrpIdx from :Idx_stm;
           exec sql execute DrpIdx;

           Clear Idx_stm;
           Idx_stm = 'Drop Index ' + %trim(In_IdxLib) + '/IADDSIDX1';
           exec sql prepare DrpIdx from :Idx_stm;
           exec sql execute DrpIdx;

           Clear Idx_stm;
           Idx_stm = 'Drop Index ' + %trim(In_IdxLib) + '/IAPGMIDX1';
           exec sql prepare DrpIdx from :Idx_stm;
           exec sql execute DrpIdx;
                                                                                           //002
           Clear Idx_stm;                                                                  //002
           Idx_stm = 'Drop Index ' + %trim(In_IdxLib) + '/IAPGMIDX2';                      //002
           exec sql prepare DrpIdx from :Idx_stm;                                          //002
           exec sql execute DrpIdx;                                                        //002
                                                                                           //002
           Clear Idx_stm;                                                                  //002
           Idx_stm = 'Drop Index ' + %trim(In_IdxLib) + '/IAPGMIDX3';                      //002
           exec sql prepare DrpIdx from :Idx_stm;                                          //002
           exec sql execute DrpIdx;                                                        //002

           Clear Idx_stm;
           Idx_stm = 'Drop Index ' + %trim(In_IdxLib) + '/IACPGMIDX';
           exec sql prepare DrpIdx from :Idx_stm;
           exec sql execute DrpIdx;

           Clear Idx_stm;                                                                  //004
           Idx_stm = 'Drop Index ' + %trim(In_IdxLib) + '/IAFILEIDX';                      //004
           exec sql prepare DrpIdx from :Idx_stm;                                          //004
           exec sql execute DrpIdx;                                                        //004

           Clear Idx_stm;                                                                  //004
           Idx_stm = 'Drop Index ' + %trim(In_IdxLib) + '/IAPRCIDX1';                      //004
           exec sql prepare DrpIdx from :Idx_stm;                                          //004
           exec sql execute DrpIdx;                                                        //004

           Clear Idx_stm;                                                                  //004
           Idx_stm = 'Drop Index ' + %trim(In_IdxLib) + '/IAVARIDX';                       //004
           exec sql prepare DrpIdx from :Idx_stm;                                          //004
           exec sql execute DrpIdx;                                                        //004

           Clear Idx_stm;                                                                  //004
           Idx_stm = 'Drop Index ' + %trim(In_IdxLib) + '/IASRCMBIDX';                     //004
           exec sql prepare DrpIdx from :Idx_stm;                                          //004
           exec sql execute DrpIdx;                                                        //004

           Clear Idx_stm;                                                                  //SS02
           Idx_stm = 'Drop Index ' + %trim(In_IdxLib) + '/IDSPOBJIDX';                     //SS02
           exec sql prepare DrpIdx from :Idx_stm;                                          //SS02
           exec sql execute DrpIdx;                                                        //SS02

           Clear Idx_stm;                                                                  //004
           Idx_stm = 'Drop Index ' + %trim(In_IdxLib) + '/IAPGMFLIDX';                     //004
           exec sql prepare DrpIdx from :Idx_stm;                                          //004
           exec sql execute DrpIdx;                                                        //004

           Clear Idx_stm;                                                                  //004
           Idx_stm = 'Drop Index ' + %trim(In_IdxLib) + '/IASRCVRIDX';                     //004
           exec sql prepare DrpIdx from :Idx_stm;                                          //004
           exec sql execute DrpIdx;                                                        //004

           Clear Idx_stm;                                                                  //004
           Idx_stm = 'Drop Index ' + %trim(In_IdxLib) + '/IAPGMVIDX';                      //004
           exec sql prepare DrpIdx from :Idx_stm;                                          //004
           exec sql execute DrpIdx;                                                        //004

           Clear Idx_stm;
           Idx_stm = 'Drop Index ' + %trim(In_IdxLib) + '/IAPGMDIDX1';
           exec sql prepare DrpIdx from :Idx_stm;
           exec sql execute DrpIdx;
                                                                                           //002
           Clear Idx_stm;                                                                  //002
           Idx_stm = 'Drop Index ' + %trim(In_IdxLib) + '/IAPGMDIDX2';                     //002
           exec sql prepare DrpIdx from :Idx_stm;                                          //002
           exec sql execute DrpIdx;                                                        //002

           Clear Idx_stm;
           Idx_stm = 'Drop Index ' + %trim(In_IdxLib) + '/IAPGMDIDX3';
           exec sql prepare DrpIdx from :Idx_stm;
           exec sql execute DrpIdx;

           Clear Idx_stm;
           Idx_stm = 'Drop Index ' + %trim(In_IdxLib) + '/IAENTPIDX';
           exec sql prepare DrpIdx from :Idx_stm;
           exec sql execute DrpIdx;

           Clear Idx_stm;
           Idx_stm = 'Drop Index ' + %trim(In_IdxLib) + '/IAESQLIDX';
           exec sql prepare DrpIdx from :Idx_stm;
           exec sql execute DrpIdx;

           Clear Idx_stm;
           Idx_stm = 'Drop Index ' + %trim(In_IdxLib) + '/IACPYBIDX';
           exec sql prepare DrpIdx from :Idx_stm;
           exec sql execute DrpIdx;

           Clear Idx_stm;
           Idx_stm = 'Drop Index ' + %trim(In_IdxLib) + '/IAALLRIDX';
           exec sql prepare DrpIdx from :Idx_stm;
           exec sql execute DrpIdx;

           Clear Idx_stm;
           Idx_stm = 'Drop Index ' + %trim(In_IdxLib) + '/IAPRFXIDX';
           exec sql prepare DrpIdx from :Idx_stm;
           exec sql execute DrpIdx;

           Clear Idx_stm;
           Idx_stm = 'Drop Index ' + %trim(In_IdxLib) + '/IAOBJMIDX';
           exec sql prepare DrpIdx from :Idx_stm;
           exec sql execute DrpIdx;
                                                                                           //003
           Clear Idx_stm;                                                                  //003
           Idx_stm = 'Drop Index ' + %trim(In_IdxLib) + '/IAFILIDX1';                      //003
           exec sql prepare DrpIdx from :Idx_stm;                                          //003
           exec sql execute DrpIdx;                                                        //003

           Clear Idx_stm;
           Idx_stm = 'Drop Index ' + %trim(In_IdxLib) + '/IAFILIDX2';
           exec sql prepare DrpIdx from :Idx_stm;
           exec sql execute DrpIdx;

           Clear Idx_stm;
           Idx_stm = 'Drop Index ' + %trim(In_IdxLib) + '/IAFILIDX3';
           exec sql prepare DrpIdx from :Idx_stm;
           exec sql execute DrpIdx;

           Clear Idx_stm;
           Idx_stm = 'Drop Index ' + %trim(In_IdxLib) + '/IAFILIDX4';
           exec sql prepare DrpIdx from :Idx_stm;
           exec sql execute DrpIdx;

           Clear Idx_stm;
           Idx_stm = 'Drop Index ' + %trim(In_IdxLib) + '/IAFILIDX5';
           exec sql prepare DrpIdx from :Idx_stm;
           exec sql execute DrpIdx;

           Clear Idx_stm;                                                                  //004
           Idx_stm = 'Drop Index ' + %trim(In_IdxLib) + '/IAPSRLGIDX';                     //004
           exec sql prepare DrpIdx from :Idx_stm;                                          //004
           exec sql execute DrpIdx;                                                        //004

           Clear Idx_stm;                                                                  //004
           Idx_stm = 'Drop Index ' + %trim(In_IdxLib) + '/IAREPOLGIDX';                    //004
           exec sql prepare DrpIdx from :Idx_stm;                                          //004
           exec sql execute DrpIdx;                                                        //004

           Clear Idx_stm;                                                                  //004
           Idx_stm = 'Drop Index ' + %trim(In_IdxLib) + '/IACALLPRMIDX';                   //004
           exec sql prepare DrpIdx from :Idx_stm;                                          //004
           exec sql execute DrpIdx;                                                        //004

           Clear Idx_stm;                                                                  //004
           Idx_stm = 'Drop Index ' + %trim(In_IdxLib) + '/IASRCINTIDX';                    //004
           exec sql prepare DrpIdx from :Idx_stm;                                          //004
           exec sql execute DrpIdx;                                                        //004

           Clear Idx_stm;                                                                  //004
           Idx_stm = 'Drop Index ' + %trim(In_IdxLib) + '/PSQLRSVIDX';                     //004
           exec sql prepare DrpIdx from :Idx_stm;                                          //004
           exec sql execute DrpIdx;                                                        //004

           Clear Idx_stm;                                                                  //004
           Idx_stm = 'Drop Index ' + %trim(In_IdxLib) + '/IDSPFFDIDX';                     //004
           exec sql prepare DrpIdx from :Idx_stm;                                          //004
           exec sql execute DrpIdx;                                                        //004

           Clear Idx_stm;                                                                  //004
           Idx_stm = 'Drop Index ' + %trim(In_IdxLib) + '/IASUBRIDX';                      //004
           exec sql prepare DrpIdx from :Idx_stm;                                          //004
           exec sql execute DrpIdx;                                                        //004

           Clear Idx_stm;                                                                  //004
           Idx_stm = 'Drop Index ' + %trim(In_IdxLib) + '/IAPGMCALIDX';                    //004
           exec sql prepare DrpIdx from :Idx_stm;                                          //004
           exec sql execute DrpIdx;                                                        //004
                                                                                           //003
           Clear Idx_stm;                                                                  //005
           Idx_stm = 'Drop Index ' + %trim(In_IdxLib) + '/IAOVRPFIDX';                     //005
           exec sql prepare DrpIdx from :Idx_stm;                                          //005
           exec sql execute DrpIdx;                                                        //005

           Clear Idx_stm;                                                                  //005
           Idx_stm = 'Drop Index ' + %trim(In_IdxLib) + '/IALISTIDX';                      //005
           exec sql prepare DrpIdx from :Idx_stm;                                          //005
           exec sql execute DrpIdx;                                                        //005


           Clear Idx_stm;                                                                  //005
           Idx_stm = 'Drop Index ' + %trim(In_IdxLib) + '/IDSPPGMIDX';                     //005
           exec sql prepare DrpIdx from :Idx_stm;                                          //005
           exec sql execute DrpIdx;                                                        //005

           Clear Idx_stm;                                                                  //003
           Idx_stm = 'Drop View ' + %trim(In_IdxLib) + '/IAFILEVU1';                       //003
           exec sql prepare DrpIdx from :Idx_stm;                                          //003
           exec sql execute DrpIdx;                                                        //003

           Clear Idx_stm;                                                                  //006
           Idx_stm = 'Drop Index ' + %trim(In_IdxLib) + '/IAOBJMIDX1';                     //006
           exec sql prepare DrpIdx from :Idx_stm;                                          //006
           exec sql execute DrpIdx;                                                        //006
                                                                                           //006
           Clear Idx_stm;                                                                  //006
           Idx_stm = 'Drop Index ' + %trim(In_IdxLib) + '/IASRCINTIDX1';                   //006
           exec sql prepare DrpIdx from :Idx_stm;                                          //006
           exec sql execute DrpIdx;                                                        //006
                                                                                           //006
           Clear Idx_stm;                                                                  //009
           Idx_stm = 'Drop Index ' + %trim(In_IdxLib) + '/IAOBJREFIDX';                    //009
           exec sql prepare DrpIdx from :Idx_stm;                                          //009
           exec sql execute DrpIdx;                                                        //009

           Clear Idx_stm;                                                                  //006
           Idx_stm = 'Drop Index ' + %trim(In_IdxLib) + '/IALNGNMIDX';              //0010 //006
           exec sql prepare DrpIdx from :Idx_stm;                                          //006
           exec sql execute DrpIdx;                                                        //006
                                                                                           //007
           Clear Idx_stm;                                                                  //007
           Idx_stm = 'Drop Index ' + %trim(In_IdxLib) + '/IARPGIDX2';                      //007
           exec sql prepare DrpIdx from :Idx_stm;                                          //007
           exec sql execute DrpIdx;                                                        //007

                                                                                           //007
           Clear Idx_stm;                                                                  //007
           Idx_stm = 'Drop Index ' + %trim(In_IdxLib) + '/IARPGIDX3';                      //007
           exec sql prepare DrpIdx from :Idx_stm;                                          //007
           exec sql execute DrpIdx;                                                        //007
                                                                                           //008
           Clear Idx_stm;                                                                  //008
           Idx_stm = 'Drop Index ' + %trim(In_IdxLib) + '/IAOBJMIDX2';                     //008
           exec sql prepare DrpIdx from :Idx_stm;                                          //008
           exec sql execute DrpIdx;                                                        //008
                                                                                           //008
           Clear Idx_stm;                                                                  //008
           Idx_stm = 'Drop Index ' + %trim(In_IdxLib) + '/IAFILEIDX1';                     //008
           exec sql prepare DrpIdx from :Idx_stm;                                          //008
           exec sql execute DrpIdx;                                                        //008
                                                                                           //008
           Clear Idx_stm;                                                                  //008
           Idx_stm = 'Drop Index ' + %trim(In_IdxLib) + '/IAFILEIDX2';                     //008
           exec sql prepare DrpIdx from :Idx_stm;                                          //008
           exec sql execute DrpIdx;                                                        //008

     EndSl;
  EndSr;
//--------------------------------------------------------------------------------------- //
//Create Indexes....                                                                     //
//--------------------------------------------------------------------------------------- //
  Begsr CrtIdxsr;

     exec sql prepare CrtIdx from :Idx_stm;
     exec sql execute CrtIdx;

     if sqlCode < successCode;
        iASqlDiagnostic(uDpsds);            //0011
     endif;

  Endsr;
