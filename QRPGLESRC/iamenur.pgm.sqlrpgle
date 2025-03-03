**free
      //%METADATA                                                      *
      // %TEXT IA Main Menu Driver Program                             *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------ //
//CREATED BY : Programmers.io @ 2020                                                   //
//CREATE DATE: 2020/01/01                                                              //
//DEVELOPER  : Kaushal kumar                                                           //
//DESCRIPTION: This is main menu program that drives all the                           //
//             menu options.                                                           //
//PROCEDURE LOG:                                                                       //
//------------------------------------------------------------------------------------ //
//Procedure Name           | Procedure Description                                     //
//-------------------------|---------------------------------------------------------- //
//GetProcessType           |                                                           //
//SubmitBatch              |                                                           //
//RtvJobLogMessage         |                                                           //
//------------------------------------------------------------------------------------ //
//                                                                                     //
//MODIFICATION LOG:                                                                    //
//------------------------------------------------------------------------------------ //
//Date    | Mod_ID | Developer  | Case and Description                                 //
//--------|--------|------------|----------------------------------------------------- //
//21/12/19| RA01   | Rohini A   | Call to IAMODTMOD                                    //
//21/12/19| BA01   | Bhoomish A | Call to CPY2FNLREF                                   //
//22/01/13| BA03   | Bhoomish   | To pass repo name CPY2FNLREF                         //
//22/02/01| RK01   | Rahul K    | Update meta data built flag in IaInpLib              //
//22/02/15| MT01   | Mahima     | Call PROCSSPRFX                                      //
//22/04/07| OJ01   | Ojasva     | SQLError Handling using wkSqlstmtNbr                 //
//07/04/22| DB01   | Dada       | Looping Issue (Dow 1=1)                              //
//22/04/12| AK09   | Ashwani    | SQLError Handling - 2                                //
//22/04/13| HJ01   | Himanshu J | Handle Null Value in SQL query while                 //
//        |        |            | using Aggregate functions                            //
//22/04/18| HJ02   | Himanshu J | Commented the block of code for option 6 i.e. work   //
//        |        |            | with repository.                                     //
//22/04/19| BA02   | Bhoomish   | Parser Optimisation                                  //
// 22/05/02| SK03   | Santhosh   | Comment out the call to IAVARIDR(Obsolete)           //
//22/05/04| HJ03   | Himanshu J | Added the block of code for checking the License Key //
//22/05/17| HJ04   | Himanshu J | Added check execution time logic                     //
//22/05/27| HJ05   | Himanshu J | Added ADDLIB Logic for repository.                   //
//22/05/27| HJ06   | Himanshu J | Added Delete query for AIEXCTIME.                    //
//22/05/27| VS01   | VIVEK SHAR | Added Create libreray command for new Repository Lib //
//        |        |            | Added Create duplicate object for file Aiexctime     //
//22/05/27| VS01   | VIVEK SHAR | Remove Refresh part from Add New Repository window   //
//        |        |            | after when it will asking for add more lib.          //
//        |        |            | Hide Refresh F5 on the same sceanrio.                //
//22/05/27| PP01   | Prashant P | Invalid option in window and F12 previous window     //
//22/06/03| YG02   | Yogesh G   | Update change user and Change program in IAINPLIB    //
// 22/06/07| PP02   | Prashant P | Avoid special Characters for repository name         //
// 22/06/08| PP03   | Prashant P | Add Repository screen on F5 clear the option and     //
//         |        |            | message and prevent repository being created.        //
//22/05/27| HJ07   | Himanshu J | Modified Add Repository logic.                       //
//24/06/22| JM01   | Jagdish  M | Modified Add creation of tablle AIERRLOGP            //
//22/07/25| YG01   | Yogesh G   | Added AILONGNAM file updation logic for Stored Proc  //
//22/07/29| RS01   | Raman S    | Fix Object/Table lock issue while Re-Build Meta Data //
//22/08/18| PJ01   | Pranav J   | Copy configured object reference data to history file//
//22/09/08| MT01   | Manav T    | Create duplicate object in repository for IAXSRCPF   //
//22/09/07| SJ01   | Sunny Jha  | Adapting new field of file AIEXCTIME which captures //
//        |        |            | source file name.                                   //
//22/10/13|        | Bhoomish   | Calling to make view on AiProdDtlV for Object        //
//        |        |            | Context matrix                                       //
//22/10/14| SJ02   | Sunny Jha  | Keeping Batch info flag ON in case of F12 loop       //
//22/10/26| SJ03   | Sunny Jha  | Preventing AIPROD to delete an existing lib          //
//22/10/28| SS01   | Sushant S  | Added error message when Repository Lib Not Found    //
//22/10/28| KD01   | Koundinya  | Commented out the 07 and 09 function keys            //
//22/10/28| BS01   | Sudha B    | Bug fix                                              //
//22/10/28|        |            | 1. Deleted repo in 1 session cannot be processed in  //
//22/10/28|        |            |    other sessions                                    //
//22/10/28|        |            | 2. Repository is locked for option 2 and 4. After    //
//22/10/28|        |            |    operation completes lock is released.             //
//11/07/22| VS02   | Vivek Shar | Populating Error messesge for option 3 when Repository
//11/07/22|        |            | Building metadata.                                   //
//22/10/31| AJ01   | Anchal     | JOBQ field not clear.                                //
//22/12/01| ST01   | Stephen    | To Create & Drop Index, modified the logic to call   //
//        |        |            | "IACRTINDXR" instead of "IAINDEXR".                  //
//22/12/20|        | Kartik     | Added logic to submit job based on the parameters    //
//        |        |  Sehoria   | setup in IAJOBDAREA data area.                       //
//21/02/23| 0001   | Ruchika N  | Added text desciption in Repository                  //
//24/02/23| 0002   | Karan M    | Call IAUPDRFLIB program to update the refrenced      //
//24/02/23| 0002   |            | object library in IAALLREFPF file.                   //
//21/02/23| 0003   | Shubham J  | Excluding the interctive job submission and Progress //
//        |        |            | Bar removal from screen.                             //
//06/03/23| 0004   | Vipul P.   | Commented Declare Variables those are unnecessary    //
//        |        |            | use in Progress Bar.                                 //
//04/05/23| 0005   | Karan M.   | Duplicate records issue in IAINPLIB file fixed       //
//12/07/23| 0006   | Anjan      | Fixed F1 functionaly issue for the Re-Build Mata     //
//        |        | Ghosh      | confirmation window. TASK#:70                        //
//12/07/23| 0007   | Bhavit     | Fixed F1 functionaly issue for the Batch detail      //
//        |        | Jain       | window and Batch confirmation window.                //
//21/08/23| 0008   | Rishabh M. | Fixed issue of repo name still showing in repository //
//        |        |            | list even if its object is deleted.                  //
//14/09/23| 0009   | Abhijith   | Metadata build process changes to update status for  //
//        |        |            | 'S', 'P' along with 'L' & 'C'                        //
//04/10/23| 0010   | Abhijith   | Metadata build process changes to write job details  //
//        |        |            | when scheduled.                                      //
//12/10/23| 0011   | Abhijith   | Metadata refresh process changes Task#231            //
//        |        | Ravindran  |                                                      //
//06/11/23| 0012   | Manasa S   | IAMETAINFO data area update for refresh Task #338    //
//10/11/23| 0013   | Venkatesh  | Changed CheckLibraryList subroutine to use IaRefLibP //
//        |        |   Battula  |    from Repo library instead of #IADTA  [#357]       //
//21/12/23| 0014   | Akhil K.   | New parameter added while calling IAINIT (Task #463) //
//02/01/24| 0015   | Yogita K.  | INIT/REFRESH process is revised whenever a new IA    //
//        |        |            | version is published. [Task #502]                    //
//        |        |            | Added one error message(MSG0152) in IAMSGF file.     //
//15/01/24| 0016   | Venkatesh  | Removed the valiation that appears during refresh    //
//        |        |   Battula  |    as part of version changes.    [Task: #531]       //
//03/01/24| 0017   | Akhil K.   | Move validation in IAPRDVLDR program and comment     //
//        |        |            | the validation for the same program (Task #520)      //
//17/01/24| 0018   | Arshaa     | Pass Wk_processType as DELETE to IAPRDVLDR in opt 4. //
//        |        |            | Task# 533                                            //
//        |        |            | Note: Wk_processType is INIT/REFRESH only when opt   //
//        |        |            |       is 3/5 respectively. Other cases it is blank.  //
//        |        |            |       So used the same for opt 4 with value as       //
//        |        |            |       'DELETE'.                                      //
//22/12/23| 0019   | Saikiran   | Added a new option 6 on the screen for Exclusion     //
//        |        |            |   feature, using this we can add the member          //
//        |        |            |   exclusion details into IAXSRCPF file and object    //
//        |        |            |   exclusion details into AIEXCOBJS file (Task#500)   //
//04/02/24| 0020   | Mahima     | Resequencing of seq num after CRTDUPOBJ command for   //
//        |        |            | Exclusion file as sequence number is not auto increme //
//        |        |            | nted by 1 after CRTDUPOBJ. (Task#598)                 //
//08/02/24| 0021   | bpal       | Remove the below files and its usages from product    //
//        |        |            | IASRCOBJ                                              //
//        |        |            | IARESULT                                              //
//        |        |            | [Task#:444]                                           //
//10/04/24| 0022   | Pranav     | Adding new parameter for IAGETMSG.                    //
//21/11/23| 0023   | Roshan W.  | Remove repository library from library list after     //
//        |        |            | submit the job. Task # : 397                          //
//05/10/23| 0024   | Anubhavi   | To Rename program name from AIPURGREF to IAPURGREF    //
//        |        |            | [Task #268]                                           //
//13/10/23| 0025   | Rituraj    | Changed file name AIEXCTIME to IAEXCTIME [Task #248]  //
//05/10/23| 0026   | Satyabrat S| Rename AIPROCDTLV program and view to IAPROCDTLV.     //
//        |        |            | [Task #265]                                           //
//04/10/23| 0027   | Khushi W   | Rename AIEXCOBJS to IAEXCOBJS (Mod:0004) [Task #252]  //
//05/10/23| 0028   | Khushi W   | Rename program AIMBRPRSER to IAMBRPRSER. [Task #263]  //
//18/10/23| 0029   | Akshay S   | Rename AIPURGDTA to IAPURGDTA [Task #298]             //
//07/06/24| 0030   | Sribalaji  | Rename AILNGNMDTR to IALNGNMDTR [Task #256]           //
//03/07/24| 0031   | Yogesh Chan| Rename AILICKEYP  to IALICKEYP  [Task #245]           //
//03/07/24| 0032   | Sribalaji  | Remove the hardcoded #IADTA lib from all sources      //
//        |        |            |  [Task# 754]                                          //
//04/07/24| 0033   | Akhil K.   | Renamed AIERRBND, AICERRLOG, AIDERRLOG and AISQLDIAGNO//
//        |        |            | STIC with IA*                                         //
//29/07/24| 0034   | Karthick S | Library Set Based on the Environment [Task #824]      //
//13/09/24| 0035   | Manav T    | IAEXCOBJS : Not getting created in Repository         //
//        |        |            | due to incorrect object name specified in CRTDUPOBJ   //
//        |        |            | command [Task #933]                                   //
//22/11/24| 0036   | Sasikumar R| Check the iA jobs status from IAMENU [TASK #1073]     //
//13/01/25| 0037   | Bpal       | Remove the usage of IAHELPW          [TASK #790 ]     //
//        |        |            | Deleted call of IAHELPW                               //
//16/08/24| 0038   | Sabarish   | IFS Member Parsing Feature [Task #833]                //
//------------------------------------------------------------------------------------- //
ctl-opt CopyRight('Copyright @ Programmers.io © 2022 ');
ctl-opt Option(*NoDebugIo:*SrcStmt:*NoUnRef);
ctl-opt BndDir('IABNDDIR' : 'IAERRBND');                                                 //0033

//Display file declaration
dcl-f IAMENU WORKSTN Indds(Indds1) Infds(Infds1) Sfile(sfl01:Rrn1)
                                                 Sfile(sfl02:Rrn2);

//CopyBooks
/copy 'QCPYSRC/iamenur.rpgleinc'
/copy 'QCPYSRC/iamsgsflf.rpgleinc'
/copy 'QMODSRC/iasrv01pr.rpgleinc'
/copy 'QCPYSRC/iaderrlog.rpgleinc'

dcl-ds IAJOBDAREA dtaara('*LIBL/IAJOBDAREA') len(50) ;
  JOBLVL char(5) pos(1);
  JOBSVRTY char(5) pos(11);
  JOBTEXT char(7) pos(21);
end-ds ;

//Prototype declaration
dcl-pr IAAMPRMV extpgm('IAAMPRMV');
end-pr;

dcl-pr CPY2FNLREF extpgm('CPY2FNLREF');                                                   //BA01
  *n CHAR(10);                                                                            //ba03
end-pr;                                                                                   //BA01

dcl-pr  IAPURGREF Extpgm('IAPURGREF');                                                   //0024
  *n char(10);                                                                          //PJ01
end-pr;                                                                                 //PJ01

dcl-pr ModuleToModule extpgm('IAMODTMOD');                                                //RA01
end-pr;                                                                                   //RA01

dcl-pr PROCSSPRFX extpgm('PROCSSPRFX');                                                   //MT01
end-pr;                                                                                   //MT01

dcl-pr CHKLICKEY extpgm('CHKLICKEY');                                                     //HJ03
  *n CHAR(1);                                                                             //HJ03
end-pr;                                                                                   //HJ03

dcl-pr IAEXCTIMR extpgm('IAEXCTIMR');                                                    //0025
    *n Char(10) Const;                                                                   //HJ04
    *n Char(10);                                                                         //HJ04
    *n Char(10);                                                                         //HJ04
    *n Char(10) Const;                                                                   //HJ04
    *n Char(10);                                                                         //SJ01
    *n Char(10);                                                                         //HJ04
    *n Char(10);                                                                         //HJ04
    *n Char(100) Const;                                                                  //0038
    *n Char(10) Const;                                                                   //HJ04
    *n Timestamp;                                                                        //HJ04
    *n Char(6) Const;                                                                    //HJ04
end-pr;                                                                                  //HJ04

dcl-pr IALNGNMDTR extpgm('IALNGNMDTR');                                                  //0030
  uwxref      char(10) options(*noPass);                                                 // |
end-pr;                                                                                  //YG01

dcl-pr IaProdDtlV extpgm('IAPROCDTLV');                                                  //0026
end-pr;

Dcl-Pr IACRTINDXR  extpgm('IACRTINDXR');                                                 //ST01
  *n Char(10) Const;                                                                     //ST01
  *n Char(10) Const;                                                                     //ST01
end-pr;                                                                                  //ST01

dcl-pr IAUPDRFLIB extpgm('IAUPDRFLIB');                                                  //0002
  *n char(10);                                                                           //0002
end-pr;                                                                                  //0002

dcl-pr validateRepoDetails Extpgm('IAPRDVLDR');                                          //0017
  *n char(10);                                                                           //0017
  *n char(10);                                                                           //0017
  *n char(7);                                                                            //0017
end-pr;                                                                                  //0017

dcl-pr checkIAJobsStatus Extpgm('IAJOBDTLPR');                                           //0036
end-pr;                                                                                  //0036

//Data structure declaration
  dcl-ds IaMetaInfo dtaara len(62);                                                      //0011
     up_mode char(7) pos(1);                                                             //0011
  end-ds;                                                                                //0011
                                                                                         //0011
                                                                                         //0011
dcl-ds SflRecDtlDs qualified inz;
   W_Xref char(10);
   W_User char(10);
   W_Desc char(30);
end-ds;

dcl-ds VariableDs qualified inz;
   w_MbrName  char(10);
   w_LibName  char(10);
   w_Srcpf    char(10);
   w_SrcRrn   packed(6:0);
   w_TrkType  char(04);
   w_TrkLevel packed(1:0);
   w_SrcData  char(79);
end-ds;

dcl-ds DeleteReposDs qualified inz;
   W_Xref char(10);
   W_Built char(1);                                                                          //BS01
   W_User char(10);
   W_Desc char(30);
end-ds;

dcl-ds P_FldDs;
   I_S1Opt        ind pos(1);
   I_Xref         ind pos(2);
   I_Lib          ind pos(3);
   I_Desc         ind pos(4);
   I_DIRP         ind pos(5);                                                                //0038
 //Ind_ErrorArray char(1) dim(4) pos(1);                                                     //0038
   Ind_ErrorArray char(1) dim(5) pos(1);                                                     //0038
   ReverseImage   char(1) inz(X'21');
   White_RImage   char(1) inz(X'23');
end-ds;

dcl-ds SendEmailDs qualified inz;
   EMPGMNAME  char(10);
   EMRECIPINT char(04);
   EMMAILADD  char(256);
   EMFILEPATH char(256);
   EMSUBJECT  char(256);
   EMMSGBODY  char(1000);
end-ds;

//File information data structure
dcl-ds Infds1;
   KeyPressed  char(1) Pos(369);
end-ds;

//Indicator dataarea data structure
dcl-ds Indds1;
   Help                ind pos(01);
   Exit                ind pos(03);
   RefreshKey          ind pos(05);
   AddKey              ind pos(06);
   toggle_Mbr_Obj      ind pos(08);                                                      //0019
   toggle_Ifs_Mbr      ind pos(07);                                                      //0038
   SflFoldInd          ind pos(11) inz('1');
   Previous            ind pos(12);
   Chg_Desc            ind pos(17);
   IA_JobsList         ind pos(18);                                                      //0036
   MoreKeys            ind pos(24);
   Trq_Color           ind pos(25);
   Ylw_Color           ind pos(26);
   Ind_keyOff char(1) dim(8) pos(03);
   SflNxtChg           ind pos(30);
   SflDsp1             ind pos(31);
   SflDspCtl1          ind pos(32);
   SflClr1             ind pos(33);
   SflEnd1             ind pos(34) inz('1');
   Chg_mode            ind pos(35) inz('1');
   RID1_Xref           ind pos(36);
   RID1_Lib            ind pos(37);
   RID1_Desc           ind pos(38);
   HiddenOpt           ind pos(39);
   Protect             ind pos(40);
   SflDsp2             ind pos(41);
   SflDspCtl2          ind pos(42);
   SflClr2             ind pos(43);
   SflEnd2             ind pos(44) inz('1');
   Ind_s1opt           ind pos(45);
   Ind_Help            ind pos(46);                                                      //0006
   HiddenOpt2          ind pos(47);                                                      //0038
   RID1_Dir            ind pos(48);                                                      //0038
   IFS_Toggle          ind pos(50);                                                      //0038
   batch_error_1       ind pos(51);
   batch_error_2       ind pos(52);
   batch_error_3       ind pos(53);
   batch_error_4       ind pos(54);
   WDREBLDF_ER         ind pos(55);                            //dik
   WDREBLDF_RI         ind pos(56);                            //dik
   batch_error_5       ind pos(57);                            //PP01
   display_batch_info  ind pos(71);
   Refresh_Meta_Data   ind pos(77);                            //0011
   object_Details      ind pos(78);                                                      //0019
   mbr_Obj_SrcfName    ind pos(79);                                                      //0019
   mbr_Obj_Library     ind pos(80);                                                      //0019
   ind_MbrName         ind pos(81);                                                      //0019
end-ds;

dcl-ds wkInsertDS;                                             //0011
    Wkxref char(10);                                           //0011
    WkLib  char(10);                                           //0011
    WkLibSeq char(4);                                          //0011
end-ds;                                                        //0011

//Standalone variables
dcl-s Ind_Filter        ind          inz;
dcl-s previous_key      ind          inz;
dcl-s Ind_ToRcp         ind          inz;
dcl-s Ind_Morekeys      ind          inz;
dcl-s Ind_FirstTime     ind          inz;
dcl-s Ind_ErrorFlag     ind          inz;
dcl-s Ind_AddRecFlag    ind          inz;
dcl-s Ind_DeleteRepos   ind          inz;
dcl-s Ind_DeleteConfirm ind          inz;
dcl-s Ind_InsertRecFlag ind          inz;
dcl-s Ind_ForCsrRrn     ind          inz;
dcl-s riFlg             char(1);
dcl-s initErr           char(1);
dcl-s bldMdtaFlg        char(1);
dcl-s process_type      char(1)      inz;
dcl-s w_opt             char(04)     inz;
dcl-s uwerror           char(01)     inz;
dcl-s w_ScrnName        char(10)     inz;
dcl-s spf               char(10)     inz;
dcl-s w_Xref            char(10)     inz;
dcl-s w_Desc            char(30)     inz;
dcl-s w_dxref           char(10)     inz;
dcl-s w_MbrName         char(10)     inz;
dcl-s w_PosTo           char(10)     inz;
dcl-s w_SearchBy        char(10)     inz;
dcl-s uwaction          char(20)     inz;
dcl-s uwactdtl          char(50)     inz;
dcl-s ProgramQ          char(10)     inz('IAMENUR');
dcl-s w_Sqlstmt         char(1000)   inz;
dcl-s w_SqlWhere        char(1000)   inz;
dcl-s w_EmailAddrs      char(1000)   inz;
dcl-s command           char(1000)   inz;
dcl-s w_GetMsg          char(1000)   inz;
dcl-s w_objName         varchar(10) inz;                                                 //RS01
dcl-s w_SeqNo           packed(4:0)  inz;
dcl-s Rrn1              packed(5:0)  inz;
dcl-s Rrn2              packed(5:0)  inz;
dcl-s w_Count           packed(12:0) inz;
dcl-s w_Count_RS        packed(12:0) inz;                                                //RS01
dcl-s w_TotalRec        packed(5:0)  inz;
dcl-s wInput            char(1)      inz;                                                //HJ03
dcl-s uppgm_name      char(10)     inz;                                                  //HJ04
dcl-s uplib_name      char(10)     inz;                                                  //HJ04
dcl-s upsrc_name      char(10)     inz;                                                  //SJ01
dcl-s uptimestamp     Timestamp;                                                         //HJ04
dcl-s invalid_opt       char(1)      inz('N');                                           //PP01
dcl-s invalid_repo_name char(1)      inz('N');                                           //PP02
dcl-s w_refresh         char(1)      inz('N');                                           //PP03
dcl-s wbuilt            char(1)      inz(' ');                                           //BS01
dcl-s wbuiltq           char(1)      inz(' ');                                           //BS01
dcl-s wexist            char(1)      inz(' ');                                           //BS01
dcl-s wlock             ind          inz;                                                //BS01
dcl-s wrepo             char(12)     inz(' ');                                           //BS01
dcl-s InsertInpLib      char(1)      inz;                                                //0005
dcl-s wUnmatch          char(1)      inz(' ');                                           //0011
dcl-s w_XrefNam         char(10)     inz(' ');                                           //0011
dcl-s w_LibNam          char(10)     inz(' ');                                           //0011
dcl-s w_Count1          packed(12:0) inz;                                                //0011
dcl-s WkInsertStmt      char(1000)   inz;                                                //0011
dcl-s WkUser            char(10)     inz;                                                //0011
dcl-s Wk_XRef           char(12)     inz;                                                //0011
dcl-C WQuote            Const('''');                                                     //0011
dcl-s ValRepoObj        char(10)     inz;                                                //0008
dcl-s w_repositoryStatus char(1) inz;                                                    //0009
dcl-s w_jobNumber char(30) inz;                                                          //0009
dcl-s w_BldMode   char(7) inz(' ');                                                      //0012
dcl-s w_LibraryListStmt Char(500)    inz;                                                //0013
dcl-s wRefresh Char(1) inz(' ');                                                         //0014
dcl-s w_IAVersion Char(6) inz(' ');                                                      //0015
dcl-s w_repoVersion Char(6) inz(' ');                                                    //0015
dcl-s Wk_processType char(10) inz(' ');                                                  //0017
dcl-s wkPos             zoned(2)     inz;                                                //0019
dcl-s wkCount           zoned(2)     inz;                                                //0019
dcl-s wkError           ind          inz;                                                //0019
dcl-s w_maxSeq          packed(3:0)  inz;                                                //0020
dcl-s w_Reflib          char(10);                                                        //0034
//Constant declarations
dcl-c Quot               '''';
dcl-c EnterKey           x'F1';
dcl-c batch_process      'B';
dcl-c intractive_process 'I';
dcl-c date_format        '0 /  /  ';
dcl-c time_format        '0 :  :  ';
dcl-c no_of_process      '5';
dcl-c allow_repo_name    'ABCDEFGHIJKLMNOPQRSTUVWXYZ+
                          abcdefghijklmnopqrstuvwxyz+
                          0123456789@#$_';
dcl-c ucTrue             '1';                                                            //0019
dcl-c ucFalse            '0';                                                            //0019
dcl-c ucObjType          'OBJECT_TYPE';                                                  //0019

dcl-s PI_LIB             Char(3) Inz('LIB');                                             //0038
dcl-s PI_IFS             Char(3) Inz('IFS');                                             //0038

//-------------------------------------------------------------------------------------//
//Mainline Programming                                                                 //
//-------------------------------------------------------------------------------------//
exec sql
  set option commit    = *none,
             naming    = *sys,
             dynusrprf = *user,
             closqlcsr = *endmod;

Eval-corr uDpsds = wkuDpsds;                                                 //AK09    //HJ04

exec sql
  drop table Qtemp/wkDltRepos;

if sqlCode < successCode;
   uDpsds.wkQuery_Name = 'Drop_WKDLTREPOS';                                               //AK09
   IaSqlDiagnostic(uDpsds);                                                              //0033
endif;

exec sql
  create table Qtemp/wkDltRepos(wkXref char(10),
                                wkbuilt char(1),                                          //BS01
                                wkUser char(10),
                                wkDesc char(30));

if sqlCode < successCode;
   Eval-corr uDpsds = wkuDpsds;                                                           //AK09
   uDpsds.wkQuery_Name = 'Create_WKDLTREPOS';                                             //AK09
   IaSqlDiagnostic(uDpsds);                                                              //0033
endif;

dow Exit = *off or Previous = *off;                                                      //DB01
   exsr Clear_Sfl01;
   exsr Load_Sfl01;
   exsr Display_Sfl01;
enddo;

UPTimeStamp = %Timestamp();                                                           //HJ04
CallP IAEXCTIMR('IAMENUR' :udpsds.ProcNme : udpsds.Lib : '*PGM' :                        //0025
upsrc_name :                                                                            //SJ01
//uppgm_name : uplib_name : ' ' : uptimeStamp : 'UPDATE');                       //0038 //HJ04
uppgm_name : uplib_name : ' ' : ' ' : uptimeStamp : 'UPDATE');                          //0038

*inlr = *on;
/copy 'QCPYSRC/iacerrlog.rpgleinc'
//-------------------------------------------------------------------------------------//
//Clear_Sfl01:                                                                         //
//-------------------------------------------------------------------------------------//
begsr Clear_Sfl01;

   clear S1_Opt;
   Rrn1 = 0;
   SflClr1 = *on;
   write sflCtl01;
   SflClr1 = *off;

endsr;
//-------------------------------------------------------------------------------------//
//Load_Sfl01 :                                                                         //
//-------------------------------------------------------------------------------------//
begsr Load_Sfl01;

   if Ind_Filter = *off;
      w_PosTo    = C1PosTo;
      w_SearchBy = C1SearchBy;
      clear C1PosTo;
      clear C1SearchBy;
   endif;

   clear SflRecDtlDs;
 //w_sqlstmt = 'Select XREF_NAME, CRT_BYUSER, DESC' +                                   //0038
   w_sqlstmt = 'Select DISTINCT XREF_NAME, CRT_BYUSER, DESC' +                          //0038
               ' from IaInpLib';                                                        //0032
   select;
   when w_SearchBy <> *blanks;
      Ylw_Color  = *on;
      Trq_Color  = *off;
      C1RepoFltr = 'Search for your repository';
      Ind_Filter = *on;
      w_SqlWhere = ' Where ' + '(XREF_NAME) LIKE ' + Quot + '%' +
                    %trim(w_SearchBy)  + '%' + Quot +
                   ' And library_SeqNo = 10' +
                   ' Order by XREF_NAME';

   when w_PosTo <> *blanks;
      Trq_Color  = *on;
      Ylw_Color  = *off;
      C1RepoFltr = 'Repository filter on position to';
      Ind_Filter = *on;
      w_SqlWhere = ' Where ' + 'XREF_NAME >= ' + Quot + %trim(w_PosTo) +
                    Quot + ' And library_SeqNo = 10' +
                    ' Order by XREF_NAME';
   other;
      Trq_Color  = *off;
      Ylw_Color  = *off;
      Ind_Filter = *off;
      w_SqlWhere = ' where library_SeqNo = 10 Order by XREF_NAME';
      C1RepoFltr = 'Repository filter normally';
   endsl;

   if w_sqlwhere <> *blanks;
      w_sqlstmt  = %trim(w_sqlstmt) + ' ' + %trim(w_sqlwhere);
   endif;

   exec sql prepare IAMENUR_S1 from :w_sqlstmt;

   if sqlCode = successCode;
      exec sql declare IAMENUR_C1 cursor for IAMENUR_S1;
      exec sql open IAMENUR_C1;
      if sqlCode = CSR_OPN_COD;                                                         //OJ01
         exec sql close IAMENUR_C1;                                                     //OJ01
         exec sql open  IAMENUR_C1;                                                     //OJ01
      endif;                                                                            //OJ01
      if sqlCode < successCode;
         Eval-corr uDpsds = wkuDpsds;                                                     //AK09
         uDpsds.wkQuery_Name = 'Open_cursor_IAMENUR_C1';                                  //AK09
         IaSqlDiagnostic(uDpsds);                                                        //0033
      endif;
      if sqlCode = successCode;
         exec sql fetch next from IAMENUR_C1 into :SflRecDtlDs;
         if sqlCode < successCode;
            Eval-corr uDpsds = wkuDpsds;                                                  //AK09
            uDpsds.wkQuery_Name = 'Fetch1_cursor_IAMENUR_C1';                             //AK09
            IaSqlDiagnostic(uDpsds);                                                     //0033
         endif;
         dow sqlCode = successCode;
            ValRepoObj = SflRecDtlDs.w_Xref;                                              //0008
                                                                                          //0008
            clear command;                                                                //0008
                                                                                          //0008
            command = 'CHKOBJ OBJ(' + %Trim(ValRepoObj) + ') '+                           //0008
            'OBJTYPE(*LIB)';                                                              //0008
            RunCommand(Command:Uwerror);                                                  //0008
            If Uwerror <> '';                                                             //0008
               exec sql                                                                   //0008
                  delete from IaInpLib where Xref_Name=                                   //0032
                   :ValRepoObj;                                                           //0008
               exec sql fetch next from IAMENUR_C1 into :SflRecDtlDs;                     //0008
               clear Uwerror;                                                             //0008
               iter;                                                                      //0008
            EndIf;                                                                        //0008
                                                                                          //0008
            S1_Xref   = SflRecDtlDs.w_Xref;
            S1_User   = SflRecDtlDs.w_user;
            S1_desc   = SflRecDtlDs.w_desc;
            Rrn1     += 1;
            Ind_S1Opt = *off;
            if Rrn1   > 9999;
               leavesr;
            endif;
            if  rrn1  = csrRrn and riFlg = 'Y';
               Ind_S1Opt = *on;
               clear riFlg;
            endIf;
            write sfl01;

            exec sql fetch next from IAMENUR_C1 into :SflRecDtlDs;
            if sqlCode < successCode;
               Eval-corr uDpsds = wkuDpsds;                                                  //MT22
               uDpsds.wkQuery_Name = 'Fetch2_cursor_IAMENUR_C1';                             //MT322
               IaSqlDiagnostic(uDpsds);                                                  //0033
               Leave;
            endif;
         enddo;
         exec sql close IAMENUR_C1;
      endif;
   endif;

endsr;
//-------------------------------------------------------------------------------------//
//Display_Sfl01 :                                                                      //
//-------------------------------------------------------------------------------------//
begsr Display_Sfl01;

   Clear CsrRrn;
   Ind_Morekeys  = *off;
   dow Previous  = *off;
      sflDsp1    = *on;
      sflDspctl1 = *on;
      if  Rrn1   = 0;
         sfldsp1 = *off;
      endif;

      if CsrRrn  > 0;
         DspRec  = CsrRrn;
      else;
         DspRec  = 1;
      endif;

      if Ind_Morekeys = *off;
         //IaGetMsg('2':'MSG0073':w_GetMsg);                                            //0022
         IaGetMsg('2':'MSG0073':w_GetMsg:' ');                                           //0022
         FooterKey = %trim(w_GetMsg);
      else;
         //IaGetMsg('1':'MSG0085':w_GetMsg);                                            //0022
         IaGetMsg('1':'MSG0085':w_GetMsg:' ');                                           //0022
         FooterKey = %trim(w_GetMsg);
      endif;

      Clear C1PosTo;
      Clear C1SearchBy;
      write Header;
      write Footer;
      write MsgSflCtl;
      exfmt SflCtl01;
      Ind_ErrorFlag = *off;
      clear Ind_ErrorArray;
      clear Ind_DeleteRepos;

      exsr RemoveMessageFromProgramQ;
      select;
      when Exit = *on;
         exsr Endpgm;
      when Previous = *on;
         Previous = *off;
         if Ind_Filter = *on;
            clear Ind_Filter;
            clear w_sqlwhere;
            clear S1_Opt;
            exsr  Clear_Sfl01;
            exsr  Load_Sfl01;
         else;
            exsr Endpgm;
         endif;
      when MoreKeys = *on;
         MoreKeys = *off;
         if Ind_Morekeys = *off;
            Ind_Morekeys = *on;
            //IaGetMsg('1':'MSG0085':w_GetMsg);                                         //0022
            IaGetMsg('1':'MSG0085':w_GetMsg:' ');                                        //0022
            FooterKey = %trim(w_GetMsg);
         else;
            Ind_Morekeys = *off;
            //IaGetMsg('2':'MSG0073':w_GetMsg);                                         //0022
            IaGetMsg('2':'MSG0073':w_GetMsg:' ');                                        //0022
            FooterKey = %trim(w_GetMsg);
         endif;
      other;
         CallP CHKLICKEY(wInput);                                                        //HJ03
         if wInput <> 'Y';                                                               //HJ03
            WkMessageID = 'MSG0138';                                                     //HJ03
            exsr SendMessageToProgramQ;                                                  //HJ03
            Leave;                                                                       //HJ03
         endif;                                                                          //HJ03
         exsr Get_CheckPressKey;
         if Ind_deleteRepos = *on and Ind_ErrorFlag = *off;
            Ind_deleteRepos = *off;
            exsr Get_DeleteRepository;
         else;
            exsr FetchAndUnlockRepository;                                                    //BS01
            exec sql Delete from Qtemp/wkDltRepos;

            if sqlCode < successCode;
               Eval-corr uDpsds = wkuDpsds;                                                  //MT22
               uDpsds.wkQuery_Name = 'Delete1_QtempWkDltRepos';                              //MT22
               IaSqlDiagnostic(uDpsds);                                                  //0033
            endif;

         endif;
      endsl;
   enddo;

endsr;
//-------------------------------------------------------------------------------------//
//Get_CheckPressKey :                                                                  //
//-------------------------------------------------------------------------------------//
begsr Get_CheckPressKey;

   select;
   when AddKey;
      exsr AddRecord;
      if Ind_AddRecFlag = *on;
         Ind_AddRecFlag = *off;
         WkMessageID = 'MSG0007';
         MessageData = w_Xref;
         exsr SendMessageToProgramQ;
      endif;
      exsr Clear_Sfl01;
      exsr Load_Sfl01;
   when RefreshKey;
      Chg_Mode = *on;
      Chg_Desc = *off;
      IA_JobsList = *off;                                                                //0036
      SflNxtChg = *off;
      clear C1PosTo;
      clear C1SearchBy;
      clear w_SqlWhere;
      clear Ind_ErrorArray;
      clear S1_Opt;
      Ind_S1Opt =*off;
      exsr Clear_Sfl01;
      exsr Load_Sfl01;
      exsr Sr_DeallocateObj;
   when Chg_Desc = *on;
      Chg_Desc = *off;
      Chg_Mode = *off;
      exsr Clear_Sfl01;
      exsr Load_Sfl01;
   when IA_JobsList = *on;                                                               //0036
      checkIAJobsStatus();                                                               //0036
   other;
     exsr Sfl1_Options;

      if Chg_Mode = *off and KeyPressed = EnterKey;
         Chg_Mode = *on;
         Chg_Desc = *off;
      endif;

      if Ind_ErrorFlag = *off;
         if (C1PosTo <> *blank) or (C1SearchBy <> *blanks);
            Ind_Filter = *off;
         endif;
         clear S1_Opt;
         SflNxtChg = *off;
         clear Ind_ErrorArray;
         Exsr Sr_ChkTotalRec;
         If w_TotalRec > *Zero;
            exsr Clear_Sfl01;
            exsr Load_Sfl01;
         endif;
      endif;
   endsl;

endsr;
//-------------------------------------------------------------------------------------//
//Sfl1_Options :                                                                       //
//-------------------------------------------------------------------------------------//
begsr Sfl1_Options;

   Exsr Sr_CheckInvalidOptionSfl01;
   If Ind_ErrorFlag = *on;
      Leavesr;
   Endif;

   if Rrn1 > *zero;
      readc Sfl01;
   else;
      leavesr;
   endif;

   dow not %eof;
      SflNxtChg = *on;
      select;
      when Previous = *on;
         Previous = *off;
         leavesr;

      when Exit = *on;
         exsr EndPgm;

      when S1_Opt=2;
                                                                                              //BS01
         Exsr Reset_Variables ;                                                          //0017

         //Calling IAPRDVLDR for validation of repository
         validateRepoDetails(S1_Xref:Wk_processType:wkMessageId);                        //0017

         if wkMessageId <> *blanks;                                                      //0017
            Ind_ErrorFlag = *on;                                                         //0017
            Ind_s1opt = *on;                                                             //0017
            update Sfl01;                                                                //0017
            MessageData = S1_Xref;                                                       //0017
            exsr SendMessageToProgramQ;                                                  //0017
            leavesr;                                                                     //0017
         endif;                                                                          //0017

         Exsr Fetch_Repository_Status ;                                                  //0017
                                                                                              //BS01
         exsr LockRepository;                                                                 //BS01
                                                                                              //BS01
         CsrRrn = rrn1;
       //IAADDLIBR(S1_Xref);                                                             //0038
         IAADDLIBR(S1_Xref: PI_LIB);                                                     //0038
         clear S1_opt;
                                                                                              //BS01
         wrepo = S1_Xref;
         exsr UnlockRepository;                                                               //BS01
         exsr UpdatePreviousStatus;                                                           //0009

      when S1_Opt=3  Or S1_Opt=5;                                                             //0011

         Exsr Reset_Variables ;                                                          //0017
         Select;                                                                         //0017
         When S1_Opt=3;                                                                  //0017
            Wk_processType = 'INIT';                                                     //0017
         When S1_Opt=5;                                                                  //0017
            Wk_processType = 'REFRESH';                                                  //0017
         Endsl;                                                                          //0017

         //Calling IAPRDVLDR for validation of repository
         validateRepoDetails(S1_Xref:Wk_processType:wkMessageId);                        //0017

         if wkMessageId <> *blanks;                                                      //0017
            Ind_ErrorFlag = *on;                                                         //0017
            Ind_s1opt = *on;                                                             //0017
            update Sfl01;                                                                //0017
            MessageData = S1_Xref;                                                       //0017
            exsr SendMessageToProgramQ;                                                  //0017
            leavesr;                                                                     //0017
         endif;                                                                          //0017
         Exsr Fetch_Repository_Status ;                                                  //0017

         //Check if library List is not changed for Refresh
         If S1_Opt=5;                                                                         //0011
                                                                                              //0011

            //Check if there is difference between the repository built version and the      //0015
            //upgraded IA version.                                                           //0015
            //Retrieving repository built version for comparing with IA version         //0017
            exsr CheckRepositoryVersion;                                                 //0017
         endif;                                                                               //0011

         Exsr LockRepository;                                                                 //VS02

         CsrRrn = rrn1;
         w_Xref = S1_Xref;
         w_MbrName = 'IDSPFDMBRL';

         exsr CheckObject;

         if uwerror = *blanks;
            exsr ConfirmWndScreen;
         else;
            WdReBldflg = 'Y';
         endif;

         if WdReBldflg = 'Y';
            process_type = getProcessType();
            previous_key = previous;
            previous = *off;
            if not previous_key;

               // Repository Library Added On the List                              //YG02
               clear command;                                                        //YG02
                                                                                     //YG02
               command = 'ADDLIBLE LIB(' + %trim(S1_Xref) +                          //YG02
                         ') POSITION(*FIRST)';                                       //YG02
                                                                                     //YG02
               RunCommand(Command:Uwerror);                                          //YG02

               if process_type = batch_process;
                  submitBatch(S1_Xref);
                  WkMessageID = 'MSG0104';
                  MessageData = rtvJobLogMessage();
                  exsr updateJobDetails;                                                 //0009
                  exsr SendMessageToProgramQ;
              // Repository Library Remove from the List                                //0023
                  exsr Get_RmvLible;                                                     //0023
                  Update sfl01;
                  csrrrn = rrn1;
                  leavesr;
               elseif process_type = intractive_process;
                  write DUMMY;
                  exsr Get_Build_MetaData;
                  if Ind_ErrorFlag = *on;
                     Ind_ErrorFlag =*off;
                     Update sfl01;
                     csrrrn = rrn1;
                     Leavesr;
                  else;
                     Clear s1_opt;
                  endif;
               else;
                  Update sfl01;
                  csrrrn = rrn1;
                  leavesr;
               endif;
            endif;
         endif;

         wrepo = S1_Xref;                                                                     //VS02
         wbuiltq = wbuilt;                                                                    //VS02
         exsr UnlockRepository;                                                               //VS02

      when S1_Opt=4;
                                                                                              //BS01
         exsr Reset_Variables ;                                                          //0017
         Wk_processType = 'DELETE';                                                      //0018
         //Calling IAPRDVLDR for validation of repository
         validateRepoDetails(S1_Xref:Wk_processType:wkMessageId);                        //0017
         if wkMessageId <> *blanks;                                                      //0017
            Ind_ErrorFlag = *on;                                                         //0017
            Ind_s1opt = *on;                                                             //0017
            update Sfl01;                                                                //0017
            MessageData = S1_Xref;                                                       //0017
            exsr SendMessageToProgramQ;                                                  //0017
            leavesr;                                                                     //0017
         endif;                                                                          //0017
         Exsr Fetch_Repository_Status ;                                                  //0017
                                                                                              //BS01
         Clear CsrRrn;
         clear w_count;
         exsr Sr_DeallocateObj;
         exec sql
           select Count(*) into :w_count
             from OBJECT_LOCK_INFO
            where OSCHEMA = :S1_Xref
              and LOCK_TYPE = 'MEMBER';

         if sqlCode < successCode;
            Eval-corr uDpsds = wkuDpsds;                                                  //MT22
            uDpsds.wkQuery_Name = 'Select_OBJECT_LOCK_INFO';                              //MT22
            IaSqlDiagnostic(uDpsds);                                                     //0033
         endif;

         if w_count <> *zero;
            Ind_ErrorFlag = *on;
            Ind_s1opt =*on;
            WkMessageID = 'MSG0052';
            MessageData = S1_Xref;
            exsr SendMessageToProgramQ;
            update Sfl01;
            readc Sfl01;
            leavesr;
         else;
            exsr Get_storeRepos;
            Ind_DeleteRepos = *on;
         endif;
         clear S1_opt;


      when Chg_Mode = *off and KeyPressed = EnterKey;
         w_Desc = %trim(s1_Desc);
         exec sql
           //update #iadta/IaInpLib                                                       //0032
            update IaInpLib                                                               //0032
              set Desc = :w_Desc,                                                         //YG02
                  CHGPGM  = :ProgramQ,                                                    //YG02
                  CHGUSER = current_User                                                  //YG02
            where Xref_Name = :s1_Xref;

         if sqlCode < successCode;
            Eval-corr uDpsds = wkuDpsds;                                                  //MT22
            uDpsds.wkQuery_Name = 'Update_IaInpLib';                                      //MT22
            IaSqlDiagnostic(uDpsds);                                                     //0033
         endif;

      when S1_Opt=6;                                                                     //0019
         exsr processExclusionDetails;                                                   //0019
         if wkMessageId <> *blanks;                                                      //0019
            Ind_ErrorFlag = *on;                                                         //0019
            Ind_s1opt = *on;                                                             //0019
            update Sfl01;                                                                //0019
            MessageData = S1_Xref;                                                       //0019
            exsr SendMessageToProgramQ;                                                  //0019
            leavesr;                                                                     //0019
         endif;                                                                          //0019

      when S1_Opt = *zero;
         Ind_s1opt =*off;

      endsl;

      update Sfl01;
      readc Sfl01;
   enddo;
   SflNxtChg = *off;
endsr;

//--------------------------------------------------------------------------------------//0019
//SR processExclusionDetails Subroutine                                                 //0019
//--------------------------------------------------------------------------------------//0019
Begsr processExclusionDetails;                                                           //0019

   Wk_processType = *blanks;                                                             //0019
   //Calling IAPRDVLDR for validation of repository                                     //0019
   validateRepoDetails(S1_Xref:Wk_processType:wkMessageId);                              //0019

   if wkMessageId <> *blanks;                                                            //0019
      leavesr;                                                                           //0019
   endif;                                                                                //0019

   Exsr Fetch_Repository_Status ;                                                        //0019

   object_Details = *off;                                                                //0019

   dow previous = *off;                                                                  //0019

      write Footer;                                                                      //0019
      write MsgSflCtl;                                                                   //0019
      exfmt iAExcDetD3;                                                                  //0019

      exsr RemoveMessageFromProgramQ;                                                    //0019

      clear mbr_Obj_SrcfName;                                                            //0019
      clear mbr_Obj_Library;                                                             //0019
      clear ind_MbrName;                                                                 //0019
      clear wkPos;                                                                       //0019
      clear wkError;                                                                     //0019
      clear wkCount;                                                                     //0019

      select;                                                                            //0019
      //If F3 is pressed, Exit the program                                              //0019
      when exit = *on;                                                                   //0019
         exsr EndPgm;                                                                    //0019

      //If F12 is pressed, go to the previous screen                                    //0019
      when previous = *on;                                                               //0019
         previous = *off;                                                                //0019
         clear d3SrcfObjn;                                                               //0019
         clear d3SrcObjLb;                                                               //0019
         clear d3SrcMbr;                                                                 //0019
         leave;                                                                          //0019

      //If F5 is pressed, refresh the screen                                            //0019
      when refreshKey = *on;                                                             //0019
         refreshKey = *off;                                                              //0019
         clear d3SrcfObjn;                                                               //0019
         clear d3SrcObjLb;                                                               //0019
         clear d3SrcMbr;                                                                 //0019

      //If F8 is pressed, Toggle between Member and Object details                      //0019
      when toggle_Mbr_Obj = *on;                                                         //0019
         clear d3SrcfObjn;                                                               //0019
         clear d3SrcObjLb;                                                               //0019
         clear d3SrcMbr;                                                                 //0019
         if object_Details = *on;                                                        //0019
            object_Details = *off;                                                       //0019
         else;                                                                           //0019
            object_Details = *on;                                                        //0019
         endif;                                                                          //0019
         iter;                                                                           //0019

      other;                                                                             //0019
         if object_Details = *off;                                                       //0019
            //Validate the entered member details                                       //0019
            exsr validateMemberExclusionDetails;                                         //0019
            if wkError = *off;                                                           //0019
               //If no error, then populate IAXSRCPF file                               //0019
               exsr populateMemberExclusionDetails;                                      //0019
            endif;                                                                       //0019
         else;                                                                           //0019
            //Validate the entered object details                                       //0019
            exsr validateObjectExclusionDetails;                                         //0019
            if wkError = *off;                                                           //0019
               //If no error, then populate IAEXCOBJS file                              //0027
               exsr populateObjectExclusionDetails;                                      //0019
            endif;                                                                       //0019
         endif;                                                                          //0019

      endsl;                                                                             //0019

   enddo;                                                                                //0019

endsr;                                                                                   //0019

//-------------------------------------------------------------------------------------//
//Sr_CheckInvalidOptionSfl01 :                                                         //
//-------------------------------------------------------------------------------------//
BegSr Sr_CheckInvalidOptionSfl01;

   Ind_ForCsrRrn = *off;
   If Rrn1 > *zero;
      ReadC Sfl01;
   Else;
      Leavesr;
   Endif;
   Dow Not %Eof;
      SflNxtChg = *on;
      Refresh_Meta_Data = *Off;                                                   //0011
      Select;
      When S1_Opt  = 2;
         Ind_S1opt = *off;
      When S1_Opt  = 3;
         Ind_S1opt = *off;
      When S1_Opt  = 4;
         Ind_S1opt = *off;
      When S1_Opt  = 5;                                                           //0011
         Ind_S1opt = *off;                                                        //0011
         Refresh_Meta_Data = *On;                                                 //0011
      When S1_Opt  = 6;                                                                  //0019
         Ind_S1opt = *off;                                                               //0019
      When S1_Opt  = *zero;
         Ind_S1opt = *off;
      Other;
         If Ind_ForCsrRrn = *off;
            Ind_ForCsrRrn = *on;
            CsrRrn = rrn1;
         Endif;
         Ind_ErrorFlag = *on;
         Ind_S1opt =*on;
         w_opt = %char(s1_Opt);
         WkMessageID = 'MSG0006';
         MessageData = w_Opt;
         ExSr SendMessageToProgramQ;
      EndSl;
      Update Sfl01;
      Readc Sfl01;
   Enddo;
Endsr;
//-------------------------------------------------------------------------------------//
//Get_Build_MetaData :                                                                 //
//-------------------------------------------------------------------------------------//
begsr Get_Build_MetaData;

   clear w_count;
   exsr Sr_DeallocateObj;
   exec sql
     select Count(*)
       into :w_count
       from OBJECT_LOCK_INFO
      where OSCHEMA   = :S1_Xref
        and LOCK_TYPE = 'MEMBER';

   if sqlCode < successCode;
      Eval-corr uDpsds = wkuDpsds;                                                  //MT22
      uDpsds.wkQuery_Name = 'Select2_OBJECT_LOCK_INFO';                             //MT22
      IaSqlDiagnostic(uDpsds);                                                           //0033
   endif;

   if bldMdtaFlg = 'Y';
      clear bldMdtaFlg;
      clear w_count;
   endIf;
   if w_count <> *zero;
      Ind_ErrorFlag = *on;
      riFlg = 'Y';
      WkMessageID = 'MSG0051';
      MessageData = S1_Xref;
      exsr SendMessageToProgramQ;
      leavesr;
   else;
      exec sql                                                                            //RK01
        //update #iadta/IaInpLib                                                    //0032//RK01
        update IaInpLib                                                                   //0032
           set XMDBuilt = ' ',                                                            //YG02
               CHGPGM  = :ProgramQ,                                                       //YG02
               CHGUSER = current_User                                                     //YG02
         where Xref_Name = :s1_Xref;                                                      //RK01
                                                                                          //RK01
      if sqlCode < successCode;
         Eval-corr uDpsds = wkuDpsds;                                                     //MT22
         uDpsds.wkQuery_Name = 'Update2_IaInpLib';                                        //MT22
         IaSqlDiagnostic(uDpsds);                                                        //0033
      endif;

      //Iainit(S1_Xref     :'Step 1 of ' + no_of_process);                                 YC01
      initErr  = 'N';                                                                     //YC01

      Exec Sql Delete From IAEXCTIME;                                                    //0025

      if sqlCode < successCode;                                                          //HJ06
         uDpsds.wkQuery_Name = 'Delete_IAEXCTIME';                                       //0025
         IaSqlDiagnostic(uDpsds);                                                        //0033
      endif;                                                                             //HJ06

      uptimeStamp = %Timestamp();                                                        //HJ06
      CallP IAEXCTIMR('IAMENUR' :udpsds.ProcNme : udpsds.Lib : '*PGM' :                  //0025
      upsrc_name :                                                                      //SJ01
    //uppgm_name : uplib_name : ' ' : uptimeStamp : 'INSERT');                     //0038//HJ06
      uppgm_name : uplib_name : ' ' : ' ' : uptimeStamp : 'INSERT');                     //0038

      //Iainit(S1_Xref     :'Step 1 of ' + no_of_process:initErr);                       //YC01
      Iainit(S1_Xref     :'Step 1 of ' + no_of_process:initErr:wRefresh);                 //0014
      If initErr = 'Y';                                                                   //YC01
         Ind_ErrorFlag = *on;                                                             //YC01
         riFlg = 'Y';                                                                     //YC01
         WkMessageID = 'MSG0051';                                                           //YC01
         MessageData = S1_Xref;                                                           //YC01
         exsr SendMessageToProgramQ;                                                      //YC01
         leavesr;                                                                         //YC01
      EndIf;                                                                              //YC01

      IACRTINDXR(S1_Xref :'Iainit');                                                      //ST01
                                                                                          //ST01
      IaMbrPrser(S1_Xref     :'Step 2 of ' + no_of_process);                             //0028
      IALNGNMDTR( S1_Xref ) ;                                                            //0030
                                                                                          //ST01
      IACRTINDXR(S1_Xref :'IaMbrPrser');                                                 //0028

      //Get Delete Override file
      exsr Get_DeleteOverride;

      IACRTINDXR(S1_Xref :'DltOvrrFil');                                                  //ST01

      IAFILEDTLR(S1_Xref   :'Step 3 of ' + no_of_process);                                //pending

      PROCSSPRFX();                                                                       //MT01

      //Write all object references into Final references table                          //BA01
      CPY2FNLREF(S1_Xref);                                                                //BA03

      //Write Module to Module, Pgm to Module, Srvpgm to Module into Final table         //RA01
      ModuleToModule();                                                                   //RA01

      //Update referenced object library by selecting the correct library from iainplib  //0002
      IAUPDRFLIB(S1_Xref);                                                                //0002

      //Write all System object references into History table.                         //PJ01
      IAPURGREF(S1_Xref);                                                                //0024
                                                                                        //PJ01
      //----------------------------------------------------------------------------- //
      //Create View of Procedure Reference for object Context Matrix Java             //
      //----------------------------------------------------------------------------- //
      IaProdDtlV();                                                                      //0026

      IACRTINDXR(S1_Xref :'IAFILEDTLR');                                                  //ST01

      //To Remove this '&' Symbol from CL Variable this program can be called mannualy or//YG1103
      //remove comments for below program call while building meta data                  //YG1103
                                                                                          //YG1103
      //IAAMPRMV();                                         // can be called mannually   //YG1103

      IACRTINDXR(S1_Xref :'IAVARTRKR');                                                   //ST01
                                                                                          //ST01
      //IAVARIDR(S1_Xref   :'Step 4 of ' + no_of_process);                               //SK03
      IAVARTRKR(S1_Xref  :'Step 5 of ' + no_of_process);                                 //pending
                                                                                          //ST01
      IACRTINDXR(S1_Xref :' ');                                                           //ST01

      // Remove repository from library list
      w_Xref = S1_Xref;
      exec sql                                                                            //RK01
        //update #iadta/IaInpLib                                                    //0032//RK01
        update IaInpLib                                                                   //0032
           set XMDBuilt = 'C',                                                            //YG02
               CHGPGM  = :ProgramQ,                                                       //YG02
               CHGUSER = current_User                                                     //YG02
         where Xref_Name = :s1_Xref;                                                      //RK01
                                                                                          //RK01
      if sqlCode < successCode;
         Eval-corr uDpsds = wkuDpsds;                                                     //MT22
         uDpsds.wkQuery_Name = 'Update3_IaInpLib';                                        //MT22
         IaSqlDiagnostic(uDpsds);                                                        //0033
      endif;

      exsr Log_MetaLibList;                                                             //0011

      // Repository Library Remove from the List                                        //0023
      exsr Get_RmvLible;                                                                 //0023
                                                                                         //0023
      // Send message on main screen
      WkMessageID = 'MSG0010';
      MessageData = S1_Xref;
      exsr SendMessageToProgramQ;
      clear Sfl01;
      bldMdtaFlg = 'Y';
   endif;

endsr;
//-------------------------------------------------------------------------------------//
//Sr_DeallocateObj :                                                                   //
//-------------------------------------------------------------------------------------//
begsr Sr_DeallocateObj;

   exec sql                                                                             //RS01
     select count(*) into :w_count                                                      //RS01
     from  OBJECT_LOCK_INFO                                                             //RS01
     where OSCHEMA = :S1_Xref;                                                          //RS01
   exec sql
     declare DeallocateObj cursor for
   // select distinct Name                                                              //RS01
      select distinct SYS_ONAME                                                         //RS01
        from OBJECT_LOCK_INFO
       Where OSCHEMA = :S1_Xref;

   exec sql open DeallocateObj;
   if sqlCode = CSR_OPN_COD;                                                            //OJ01
      exec sql close DeallocateObj;                                                     //OJ01
      exec sql open  DeallocateObj;                                                     //OJ01
   endif;                                                                               //OJ01

   if sqlCode < successCode;
      Eval-corr uDpsds = wkuDpsds;                                                      //MT22
      uDpsds.wkQuery_Name = 'Open_DeallocateObj';                                       //MT22
      IaSqlDiagnostic(uDpsds);                                                           //0033
   endif;

   if sqlCode = successCode;
      exec sql fetch next from DeallocateObj into :w_objName;
      if sqlCode < successCode;
         Eval-corr uDpsds = wkuDpsds;                                                    //MT22
         uDpsds.wkQuery_Name = 'Fetch1_DeallocateObj';                                   //MT22
         IaSqlDiagnostic(uDpsds);                                                        //0033
      endif;

      w_Count_RS = 0;                                                                    //RS01
   // dow sqlCode = successCode;                                                         //RS01
      dow sqlCode = successCode and w_Count_RS < w_count;                                //RS01
         command = 'DLCOBJ OBJ(('+ %trim(S1_Xref) + '/' + %trim(w_objName) +
                   ' *FILE *SHRRD))';
         RunCommand(Command:Uwerror);
   //    exec sql fetch next from DeallocateObj into :w_objName;                         //RS01
         if sqlCode < successCode;
            Eval-corr uDpsds = wkuDpsds;                                                 //MT22
            uDpsds.wkQuery_Name = 'Fetch2_DeallocateObj';                                //MT22
            IaSqlDiagnostic(uDpsds);                                                     //0033
            Leave;
         endif;
         w_Count_RS = w_Count_RS + 1;                                                    //RS01
      enddo;
      exec sql close DeallocateObj;
   endif;

endsr;
//-------------------------------------------------------------------------------------//
//ConfirmWndScreen :                                                                   //
//-------------------------------------------------------------------------------------//
begsr ConfirmWndScreen;

       WdReBldflg = 'N' ;                                  //dik
   dow Previous = *off;
      ind_help = *on;                                                                    //0006
      exfmt WndReBuild;
         WDREBLDF_RI = *OFF;                                      //DIK
      select;
      when Previous = *on;
         ind_help = *off;                                                                //0006
         Previous = *off;
         WdReBldflg = *blanks;
         leavesr;
      when %lookup('1' :Ind_keyOff) <> *zero;
         clear Ind_keyOff;
      when WdReBldflg = 'Y' or WdReBldflg = 'N' ;
         ind_help = *off;                                                                //0006
         leavesr;
      when WdReBldflg <> 'Y' and WdReBldflg <> 'N' ;              ///DIK
         WDREBLDF_ER = *on;                                       //DIK
         WDREBLDF_RI = *on;                                       //DIK
         PARA2 = WdReBldflg;                                      //DIK
       //invalid = *on;                                           //DIK
      endsl;
   enddo;
   ind_help = *off;                                                                      //0006

endsr;
//-------------------------------------------------------------------------------------//
//Get_DeleteRepository :                                                               //
//-------------------------------------------------------------------------------------//
begsr Get_DeleteRepository;

   exsr Clear_Sfl02;
   exsr Load_Sfl02;
   exsr Display_Sfl02;
   if Ind_DeleteConfirm = *on;
      Ind_DeleteConfirm = *off;
      exsr Clear_Sfl01;
      exsr Load_Sfl01;
      exec sql delete from Qtemp/wkDltRepos;
      if sqlCode < successCode;
         Eval-corr uDpsds = wkuDpsds;                                                 //MT22
         uDpsds.wkQuery_Name = 'Delete2_QtempWkDltRepos';                             //MT22
         IaSqlDiagnostic(uDpsds);                                                        //0033
      endif;

   endif;

endsr;
//-------------------------------------------------------------------------------------//
//Clear_Sfl02 :                                                                        //
//-------------------------------------------------------------------------------------//
begsr Clear_Sfl02;

   Rrn2 = 0;
   SflClr2 = *on;
   write sflCtl02;
   Sflclr2 = *off;

endsr;
//-------------------------------------------------------------------------------------//
//Load_Sfl02 :                                                                         //
//-------------------------------------------------------------------------------------//
begsr Load_Sfl02;

   clear DeleteReposDs;
   exec sql
     declare DltRepos cursor For
      select *
        from Qtemp/wkDltRepos;

   exec sql open DltRepos;
   if sqlCode = CSR_OPN_COD;                                                         //OJ01
      exec sql close DltRepos;                                                       //OJ01
      exec sql open  DltRepos;                                                       //OJ01
   endif;                                                                            //OJ01

   if sqlCode < successCode;
      Eval-corr uDpsds = wkuDpsds;                                                   //MT22
      uDpsds.wkQuery_Name ='Open_DltRepos';                                          //MT22
      IaSqlDiagnostic(uDpsds);                                                           //0033
   endif;

   if sqlCode = successCode;
      exec sql fetch next from DltRepos Into :DeleteReposDs;
      if  sqlCode < successCode;
         Eval-corr uDpsds = wkuDpsds;                                                   //MT22
         uDpsds.wkQuery_Name ='Fetch1_DltRepos';                                        //MT22
         IaSqlDiagnostic(uDpsds);                                                        //0033
      endif;

      dow sqlCode = successCode;
         S2_Xref = DeleteReposDs.w_Xref;
         S2_User = DeleteReposDs.w_user;
         S2_desc = DeleteReposDs.w_desc;
         RRn2   += 1;
         if Rrn2 >= 9999;
            leavesr;
         endif;
         write sfl02;
         exec sql fetch next from DltRepos Into :DeleteReposDs;
         if  sqlCode < successCode;
            Eval-corr uDpsds = wkuDpsds;                                                   //MT22
            uDpsds.wkQuery_Name ='Fetch2_DltRepos';                                        //MT22
            IaSqlDiagnostic(uDpsds);                                                     //0033
            Leave;
         endif;
      enddo;
   exec sql close DltRepos;
   endif;

endsr;
//-------------------------------------------------------------------------------------//
//Display_Sfl02 :                                                                      //
//-------------------------------------------------------------------------------------//
begsr Display_Sfl02;

   dow Previous = *off;
      sflDsp2    = *on;
      sflDspCtl2 = *on;
      if RRn2 = 0;
         sflDsp2 = *off;
      endif;
      //IaGetMsg('1':'MSG0081':w_GetMsg);                                               //0022
      IaGetMsg('1':'MSG0081':w_GetMsg:' ');                                              //0022
      FooterKey = %trim(w_GetMsg);
      write Footer;
      write MsgSflCtl;
      exfmt SflCtl02;
      exsr RemoveMessageFromProgramQ;
      select;
      when Previous = *on;
         Previous = *off;
         exsr FetchAndUnlockRepository;                                                      //BS01
         exec sql delete from Qtemp/wkDltRepos;
         if sqlCode < successCode;
            Eval-corr uDpsds = wkuDpsds;                                                   //MT22
            uDpsds.wkQuery_Name ='Delete3_qtempWkDltRepos';                                //MT22
            IaSqlDiagnostic(uDpsds);                                                     //0033
         endif;
         leavesr;
      when KeyPressed = EnterKey;
         Ind_DeleteConfirm = *on;
         exsr DeleteRepository;
         leavesr;
      endsl;
   enddo;

endsr;
//--------------------------------------------------------------------------------------//
//DeleteRepository :                                                                    //
//--------------------------------------------------------------------------------------//
begsr DeleteRepository;

   exec sql
     declare IAMENUR_C3 Cursor For
      select *
        from Qtemp/wkDltRepos;

   exec sql open IAMENUR_C3;
   if sqlCode = CSR_OPN_COD;                                                         //OJ01
      exec sql close IAMENUR_C3;                                                     //OJ01
      exec sql open  IAMENUR_C3;                                                     //OJ01
   endif;                                                                            //OJ01

   if sqlCode < successCode;
      Eval-corr uDpsds = wkuDpsds;                                                   //MT22
      uDpsds.wkQuery_Name ='Open_IAMENUR_C3';                                        //MT22
      IaSqlDiagnostic(uDpsds);                                                           //0033
   endif;

   if sqlCode = successCode;
      exec sql fetch next from IAMENUR_C3 Into :DeleteReposDs;
      if sqlCode < successCode;
         Eval-corr uDpsds = wkuDpsds;                                                   //MT22
         uDpsds.wkQuery_Name ='Fetch1_IAMENUR_C3';                                      //MT22
         IaSqlDiagnostic(uDpsds);                                                        //0033
      endif;

      dow sqlCode = successCode;
         exec sql
          // delete from #iadta/IaInpLib                                                   //0032
           delete from IaInpLib                                                            //0032
            where XREF_NAME = :DeleteReposDs.w_xref;
         if sqlCode < successCode;
            Eval-corr uDpsds = wkuDpsds;                                                   //MT22
            uDpsds.wkQuery_Name ='Delete_IAINPLIB';                                        //MT22
            IaSqlDiagnostic(uDpsds);                                                     //0033
         endif;

         w_Xref = %trim(DeleteReposDs.w_xref);
         exsr Get_RmvLible;

         clear command;
         command = 'DLTLIB LIB(' + %trim(DeleteReposDs.w_xref) + ')';
         RunCommand(Command:Uwerror);

         WkMessageID = 'MSG0009';
         MessageData = DeleteReposDs.w_xref;
         exsr SendMessageToProgramQ;

         // To delete the existing entries from the IaRefLibP for the repository             //0011
         exec sql                                                                            //0011
             Select count(*) into :W_Count1 from IaRefLibP                                   //0011
                        where MRefNam = :DeleteReposDs.W_Xref;                               //0011
           if W_Count1 <> 0 ;                                                                //0011
             exec sql                                                                        //0011
               Delete from IaRefLibP where MRefNam = :DeleteReposDs.W_Xref;                  //0011
           endif;                                                                            //0011

         exec sql fetch next from IAMenuR_C3 into :DeleteReposDs;
         if sqlCode < successCode;
            Eval-corr uDpsds = wkuDpsds;                                                   //MT22
            uDpsds.wkQuery_Name ='Fetch2_IAMENUR_C3';                                      //MT22
            IaSqlDiagnostic(uDpsds);                                                     //0033
            Leave;
         endif;
      enddo;
      exec sql close IAMENUR_C3;
   endif;

endsr;
//-------------------------------------------------------------------------------------//
//AddRecord :                                                                          //
//-------------------------------------------------------------------------------------//
begsr AddRecord;

   HiddenOpt = *on;
   HiddenOpt2  = *On;                                                                    //0038
   IFS_Toggle  = *Off;                                                                   //0038
   Protect = *off;
   clear AddrepoD1;
   if KeyPressed = EnterKey;                                                   //VS01
      //IaGetMsg('1':'MSG0139':w_GetMsg);                                     //VS01    //0022
      IaGetMsg('1':'MSG0139':w_GetMsg:' ');                                              //0022
      FooterKey = %trim(w_GetMsg);                                             //VS01
   Else ;                                                                      //VS01
      //IaGetMsg('1':'MSG0080':w_GetMsg);                                     //VS01    //0022
      IaGetMsg('1':'MSG0080':w_GetMsg:' ');                                              //0022
      FooterKey = %trim(w_GetMsg);                                             //VS01
   Endif;                                                                      //VS01
   //IaGetMsg('1':'MSG0080':w_GetMsg);                                                  //0022
   IaGetMsg('1':'MSG0080':w_GetMsg:' ');                                                 //0022
   FooterKey = %trim(w_GetMsg);
   Ind_FirstTime = *off;
   dow Previous = *off;
      write Footer;
      write MsgSflCtl;
      exfmt AddrepoD1;
      RID1_Xref = *off;
      RID1_Lib  = *off;
      RID1_Desc = *off;
      RID1_Dir  = *off;                                                                  //0038
      Ind_ErrorFlag = *off;
      clear Ind_ErrorArray;
      exsr RemoveMessageFromProgramQ;
      select;
      when Exit = *on;
         exsr Endpgm;
      when Previous = *on;
         Previous = *off;
         leavesr;
      when RefreshKey = *on;                                                   //PP03
         if w_refresh = 'Y';                                                   //PP03
            exsr RemoveMessageFromProgramQ;                                    //PP03
            Ind_ErrorFlag = *off;                                              //PP03
            I_D1_OPT = *off;                                                   //PP03
            RefreshKey = *off;                                                 //PP03
         else;
     //  clear AddRepoD1;
     //  HiddenOpt = *on;                                                      //VS01
     //  Protect = *off;                                                       //VS01
            RefreshKey = *off;                                                 //VS01
            clear AddRepoD1;                                                   //PP03
         endif;                                                                //PP03
      When Toggle_Ifs_Mbr = *On;                                                         //0038
           Clear D1_DIRPATH;                                                             //0038
           If IFS_Toggle  = *On;                                                         //0038
              IFS_Toggle  = *Off;                                                        //0038
              IaGetMsg('1':'MSG0080':w_GetMsg:' ');                                      //0038
              FooterKey = %trim(w_GetMsg);                                               //0038
           Else;                                                                         //0038
              IFS_Toggle  = *On;                                                         //0038
              IaGetMsg('1':'MSG0207':w_GetMsg:' ');                                      //0038
              FooterKey = %trim(w_GetMsg);                                               //0038
           Endif;                                                                        //0038
           Iter;                                                                         //0038
      other;
         if Ind_FirstTime = *off;
            exsr Get_Validation;
         endif;
         if Ind_ErrorFlag = *off;
            select;
            when Ind_InsertRecFlag = *on and Ind_FirstTime = *off;
               Ind_FirstTime = *on;
               Ind_InsertRecFlag = *off;
               Ind_AddRecFlag = *on;
               w_xref = %trim(D1_xref);
               exsr InsertRecord;
               If KeyPressed = EnterKey;                                       //VS01
                  w_refresh = 'Y';                                             //PP03
                //HiddenOpt = *off;                                            //VS01    //0038
                  //IaGetMsg('1':'MSG0139':w_GetMsg);                         //VS01    //0022
                  IaGetMsg('1':'MSG0139':w_GetMsg:' ');                        //VS01    //0022
                  FooterKey = %trim(w_GetMsg);                                 //VS01
               Else ;                                                          //VS01
                  //IaGetMsg('1':'MSG0080':w_GetMsg);                         //VS01    //0022
                  IaGetMsg('1':'MSG0080':w_GetMsg:' ');                        //VS01    //0022
                  FooterKey = %trim(w_GetMsg);                                 //VS01
               Endif;                                                          //VS01
               If IFS_Toggle = *Off ;                                                    //0038
                  HiddenOpt = *off;                                                      //0038
               Else ;                                                                    //0038
                  HiddenOpt2 = *Off;                                                     //0038
               EndIf;                                                                    //0038
               protect = *on;
            when D1_opt = 'Y';
             //IAADDLIBR(D1_Xref);                                                       //0038
               IAADDLIBR(D1_Xref:PI_LIB);                                                //0038
               HiddenOpt = *on;
               protect = *off;
               leavesr;
            when D1_opt2   = 'Y'   ;                                                     //0038
               IAADDLIBR(D1_Xref:PI_IFS);                                                //0038
                 HiddenOpt2= *On   ;                                                     //0038
                 protect   = *Off  ;                                                     //0038
                 Leavesr           ;                                                     //0038
          //when D1_Opt='N';                                                             //0038
            when D1_Opt='N' or D1_opt2   = 'N';                                          //0038
               leavesr;
            other;
             If IFS_Toggle = *Off ;                                                      //0038
               I_D1_Opt = ReverseImage;
               Ind_ErrorFlag = *on;
               w_opt = %char(s1_Opt);
               WkMessageID = 'MSG0131';                   //DIK
               MessageData = w_Opt;
               exsr SendMessageToProgramQ;
             Else ;                                                                      //0038
               I_D1_Opt2     =  ReverseImage;                                            //0038
               Ind_ErrorFlag =  *On         ;                                            //0038
               WkMessageID   = 'MSG0131'    ;                                            //0038
               MessageData   =  w_Opt       ;                                            //0038
               exsr SendMessageToProgramQ   ;                                            //0038
             EndIf;                                                                      //0038
            endsl;
         endif;
      endsl;
   enddo;
   w_refresh = 'N';                                                            //PP03
endsr;
//-------------------------------------------------------------------------------------//
//Get_Validation :                                                                     //
//-------------------------------------------------------------------------------------//
begsr Get_Validation;

   select;
   when D1_xref = *blanks;
      RID1_Xref = *on;
      Ind_ErrorFlag = *on;
      I_Xref = ReverseImage;
      WkMessageID = 'MSG0001';
      MessageData = *blanks;
      exsr SendMessageToProgramQ;

   //when D1_lib = *blanks;                                                              //0038
   when D1_lib = *blanks And IFS_Toggle = *Off ;                                         //0038
      RID1_Lib = *on;
      Ind_ErrorFlag = *on;
      I_Lib = ReverseImage;
      WkMessageID = 'MSG0002';
      MessageData = *blanks;
      exsr SendMessageToProgramQ;

   when D1_DIRPATH    = *blanks And                                                      //0038
        IFS_Toggle    = *On;                                                             //0038
        RID1_Dir      = *On;                                                             //0038
        Ind_ErrorFlag = *On;                                                             //0038
        I_DIRP        =  ReverseImage;                                                   //0038
        WkMessageID   = 'MSG0202';                                                       //0038
        MessageData   = *blanks;                                                         //0038
        Exsr    SendMessageToProgramQ ;                                                  //0038

   other;
      if D1_xref <> *blanks;
         invalid_repo_name = 'N';                                                          //PP02
         if %check(allow_repo_name:%trim(D1_xref)) > 0;                                    //PP02
            invalid_repo_name ='Y';                                                        //PP02
            RID1_Xref = *on;                                                               //PP02
            Ind_ErrorFlag = *on;                                                           //PP02
            I_Xref = ReverseImage;                                                         //PP02
            WkMessageID = 'MSG0140';                                                       //PP02
            MessageData = *blanks;                                                         //PP02
            exsr SendMessageToProgramQ;                                                    //PP02
         endif;                                                                            //PP02
         if invalid_repo_name ='N';                                                        //PP02
            //exec sql                                                                     //HJ07
              //select count(*)                                                            //HJ07
                //into :w_Count                                                            //HJ07
                //from SysTables                                                           //HJ07
                //where System_Table_Schema = :D1_xref;                                    //HJ07

            //if sqlCode < successCode;                                                    //HJ07
               //Eval-corr uDpsds = wkuDpsds;                                         //HJ07 //MT22
               //uDpsds.wkQuery_Name ='Select_SysTables';                             //HJ07 //MT22
               //AiSqlDiagnostic(uDpsds);                                                  //HJ07
            //endif;                                                                       //HJ07

            if Ind_FirstTime = *off;                                                       //HJ07
               exec sql
                 select count(*)
                   into :w_Count
                  // from #iadta/IaInpLib                                                     //0032
                   from IaInpLib                                                              //0032
                  where XREF_NAME = :D1_xref;

               if sqlCode < successCode;
                  Eval-corr uDpsds = wkuDpsds;                                                //MT22
                  uDpsds.wkQuery_Name ='Select1_IAINPLIB';                                    //MT22
                  IaSqlDiagnostic(uDpsds);                                               //0033
               endif;

               clear command;                                                              //HJ07
               command = 'CHKOBJ OBJ(' + %Trim(D1_Xref) + ') OBJTYPE(*LIB)';               //HJ07
               RunCommand(Command:Uwerror);                                                //HJ07
                                                                                           //HJ07
               If w_count = 0 AND Uwerror = ' ';                                           //HJ07
                  clear command;                                                           //HJ07
                  //SJ03 command = 'DLTLIB LIB(' + %Trim(D1_Xref) + ')';                   //HJ07
                  //SJ03 RunCommand(Command:Uwerror);                                      //HJ07
                  RID1_Xref = *on;                                                         //SJ03
                  Ind_ErrorFlag = *on;                                                     //SJ03
                  I_Xref = ReverseImage;                                                   //SJ03
                  WkMessageID = 'MSG0004';                                                 //SJ03
                  MessageData = D1_xref;                                                   //SJ03
                  exsr SendMessageToProgramQ;                                              //SJ03
                  leavesr;                                                                 //SJ03
               EndIf;                                                                      //HJ07

               if w_count >= 1;
                  RID1_Xref = *on;
                  Ind_ErrorFlag = *on;
                  I_Xref = ReverseImage;
                  WkMessageID = 'MSG0003';
                  MessageData = D1_xref;
                  exsr SendMessageToProgramQ;
                  leavesr;
               else;
                  exec sql
                    select count(*)
                      into :w_Count
                     // from #iadta/IaInpLib                                               //0032
                      from IaInpLib                                                        //0032
                     where XREF_NAME = :D1_lib;

                  if sqlCode < successCode;
                     Eval-corr uDpsds = wkuDpsds;                                        //MT22
                     uDpsds.wkQuery_Name ='Select2_IAINPLIB';                            //MT22
                     IaSqlDiagnostic(uDpsds);                                            //0033
                  endif;

                  if w_count >= 1;
                     RID1_Lib = *on;
                     Ind_ErrorFlag = *on;
                     I_Lib = ReverseImage;
                     WkMessageID = 'MSG0111';
                     MessageData = D1_lib;
                     exsr SendMessageToProgramQ;
                     leavesr;
                  endif;
               endif;
            else;
               RID1_Xref = *on;
               Ind_ErrorFlag = *on;
               I_Xref = ReverseImage;
               WkMessageID = 'MSG0004';
               MessageData = D1_xref;
               exsr SendMessageToProgramQ;
               leavesr;
            endif;
         endif;                                                                            //PP02
      endif;

    //if D1_Lib <> *blanks;                                                              //0038
      if D1_Lib <> *blanks And IFS_Toggle = *Off;                                        //0038

         clear command;
         command = 'CHKOBJ OBJ(QSYS/'+%trim(D1_Lib)+') OBJTYPE(*LIB)';
         RunCommand(Command:Uwerror);

         if Uwerror <> 'Y';
            exec sql
              select count(*)
              into :w_Count
            //  from #iadta/IaInpLib                                                  //0032
               from IaInpLib                                                          //0032
              where Xref_Name  = :D1_Xref
                and Library_Name = :D1_Lib;

            if sqlCode < successCode;
               Eval-corr uDpsds = wkuDpsds;                                           //MT22
               uDpsds.wkQuery_Name ='Select3_IAINPLIB';                               //MT22
               IaSqlDiagnostic(uDpsds);                                                  //0033
            endif;

            if w_count = *zero;
               Ind_InsertRecFlag = *on;
            else;
               RID1_Lib = *on;
               Ind_ErrorFlag = *on;
               I_Lib = ReverseImage;
               WkMessageID = 'MSG0004';
               MessageData = D1_xref;
               exsr SendMessageToProgramQ;
            endif;
         else;
            RID1_Lib = *on;
            Ind_ErrorFlag = *on;
            I_Lib = ReverseImage;
            WkMessageID = 'MSG0005';
            MessageData = D1_Lib;
            exsr SendMessageToProgramQ;
         endif;
      endif;
      If D1_DIRPATH <> *blanks And                                                       //0038
         IFS_Toggle  = *On;                                                              //0038
                                                                                         //0038
         Exec sql                                                                        //0038
              Select count(*)                                                            //0038
              Into  :w_Count                                                             //0038
              From   TABLE(QSYS2.IFS_OBJECT_STATISTICS                                   //0038
                     (Trim(:D1_DIRPATH),'NO','*ALLSTMF'));                               //0038
                                                                                         //0038
         If w_count  <> *Zero;                                                           //0038
            Exec sql                                                                     //0038
                 Select count(*)                                                         //0038
                 Into  :w_Count                                                          //0038
                 From   IaInpLib                                                         //0038
                 Where  Xref_Name    = :D1_Xref                                          //0038
                 And    IFS_Location = :D1_DIRPATH;                                      //0038
                                                                                         //0038
            If sqlCode < successCode;                                                    //0038
               Eval-corr uDpsds    = wkuDpsds;                                           //0038
               uDpsds.wkQuery_Name ='Select4_IAINPLIB';                                  //0038
               IaSqlDiagnostic(uDpsds);                                                  //0038
            Endif;                                                                       //0038
                                                                                         //0038
            If w_count           = *Zero;                                                //0038
               Ind_InsertRecFlag = *On;                                                  //0038
            Else;                                                                        //0038
               RID1_Dir      = *On;                                                      //0038
               Ind_ErrorFlag = *On;                                                      //0038
               I_DIRP        =  ReverseImage;                                            //0038
               WkMessageID   = 'MSG0204';                                                //0038
               MessageData   =  D1_DIRPATH;                                              //0038
               exsr SendMessageToProgramQ;                                               //0038
            Endif;                                                                       //0038
         Else;                                                                           //0038
            RID1_Dir      = *On;                                                         //0038
            Ind_ErrorFlag = *On;                                                         //0038
            I_DIRP        =  ReverseImage;                                               //0038
            WkMessageID   = 'MSG0203';                                                   //0038
            MessageData   =  D1_DIRPATH;                                                 //0038
            exsr SendMessageToProgramQ;                                                  //0038
         EndIf;                                                                          //0038
      EndIf;                                                                             //0038
   endsl;

endsr;
//--------------------------------------------------------------------------------------//
//InsertRecord :                                                                        //
//--------------------------------------------------------------------------------------//
begsr InsertRecord;

   clear w_SeqNo;
   exec sql
     //select max(library_seqno)                                                         //HJ01
     select Coalesce(max(library_seqno),0)                                               //HJ01
     into :w_SeqNo
     //from #iadta/IaInpLib                                                              //0032
      from IaInpLib                                                                      //0032
     where Xref_Name = :D1_Xref;

   if sqlCode < successCode;
      Eval-corr uDpsds = wkuDpsds;                                           //MT22
      uDpsds.wkQuery_Name ='Select4_IAINPLIB';                               //MT22
      IaSqlDiagnostic(uDpsds);                                                           //0033
   endif;

   exec sql
     select count(*)
     into :w_count
    // from #iadta/IaInpLib                                                  //0032
      from IaInpLib                                                          //0032
     where XREF_NAME    = :D1_Xref
       and LIBRARY_NAME = :D1_Lib;

   if sqlCode < successCode;
      Eval-corr uDpsds = wkuDpsds;                                           //MT22
      uDpsds.wkQuery_Name ='Select5_IAINPLIB';                               //MT22
      IaSqlDiagnostic(uDpsds);                                                           //0033
   endif;

   If IFS_Toggle = *Off   ;                                                              //0038
      D1_DirPath = *Blanks ;                                                             //0038
   Else;                                                                                 //0038
     D1_Lib    = *Blanks;                                                                //0038
   EndIf;                                                                                //0038
   w_SeqNo += 10;
   if w_count = 0;
      w_Desc = %trim(D1_Desc);

      InsertInpLib = 'Y';                                                       //0005
      Dow InsertInpLib = 'Y';                                                   //0005
      exec sql
        //insert Into  #iadta/iainplib (Xref_Name,                                       //0032
              insert Into  iainplib (Xref_Name,                                          //0032
                                     Library_SeqNo,
                                     Library_Name,
                                     IFS_Location,                                       //0038
                                     Built_Version,                                      //0015
                                     Crt_ByUser,
                                     Crt_Bypgm,
                                     Desc)
          Values (trim(:D1_Xref),
                 trim(:w_SeqNo),
                 trim(:D1_Lib),
                 trim(:D1_DirPath),                                                      //0038
                 trim(:w_IAVersion),                                                     //0015
                 trim(:uDpsds.User),
                 trim(:uDpsds.SrcMbr),
                 trim(:w_Desc));

      if sqlCode < successCode;
         Eval-corr uDpsds = wkuDpsds;                                           //MT22
         uDpsds.wkQuery_Name ='Insert_IAINPLIB';                                //MT22
         IaSqlDiagnostic(uDpsds);                                                        //0033
         Clear Command;                                                        //0005
         command = 'DLYJOB DLY(1)';                                            //0005
         Runcommand(Command:Uwerror);                                          //0005
      Else;                                                                    //0005
         InsertInpLib = 'N';                                                   //0005
      endif;
      Enddo;                                                                   //0005

   clear w_Reflib;                                                                       //0034
   If uDpsds.LIB = '#IAOBJ';                                                             //0034
      w_Reflib = '#IADTA';                                                               //0034
   Else;                                                                                 //0034
      w_Reflib = 'IADTADEV';                                                             //0034
   Endif;                                                                                //0034

//CREATE REPOSITORY                                                            //VS01
   Clear Command;                                                              //VS01
   Command = 'CRTLIB LIB(' + %trim(D1_Xref) + ') +
                     TYPE(*PROD) +
                     TEXT(' + '''' + 'Repo: ' + %trim(w_Desc) + '''' + ')';    //0001
   RunCommand(Command:Uwerror);                                                //VS01

//Copy Object From IAEXCTIME                                                             //0025
   Clear command;                                                              //VS01
   command = 'CRTDUPOBJ OBJ(IAEXCTIME) +
                        FROMLIB(' + %Trim(w_Reflib) +') +
                        OBJTYPE(*FILE) +
                        TOLIB(' + %trim(D1_Xref) + ') +
                        DATA(*No)';                                            //VS01
   RunCommand(Command:Uwerror);                                                //VS01
   command = 'CRTDUPOBJ OBJ(IAREPOLOG) +
                        FROMLIB(' + %Trim(w_Reflib) +') +
                        OBJTYPE(*FILE) +
                        TOLIB(' + %trim(D1_Xref) + ') +
                        DATA(*No)';                                            //JM01
   RunCommand(Command:Uwerror);                                                //JM01

   command = 'CRTDUPOBJ OBJ(IAPURGDTA) +
                        FROMLIB(' + %Trim(w_Reflib) +') +
                        OBJTYPE(*DTAARA) +
                        TOLIB(' + %trim(D1_Xref) + ')' ;                                  //0029
   RunCommand(Command:Uwerror);                                                           //PJ01

   clear command;                                                                         //PJ01
   command = 'CRTDUPOBJ OBJ(IAJOBDAREA) +
                        FROMLIB(' + %Trim(w_Reflib) +') +
                        OBJTYPE(*DTAARA) +
                        TOLIB(' + %trim(D1_Xref) + ')' ;                                  //PJ01
   RunCommand(Command:Uwerror);                                                           //PJ01

   clear command;                                                                         //PJ01
   command = 'CRTDUPOBJ OBJ(IAMETAINFO) +
                        FROMLIB(' + %Trim(w_Reflib) +') +
                        OBJTYPE(*DTAARA) +
                        TOLIB(' + %trim(D1_Xref) + ')' ;                                  //PJ01
   RunCommand(Command:Uwerror);                                                           //PJ01
                                                                                          //PJ01
   clear command;                                                                         //PJ01
   command = 'CRTDUPOBJ OBJ(IAEXCOBJS) +
                        FROMLIB('+ %Trim(w_Reflib) + ') +
                        OBJTYPE(*FILE) +
                        TOLIB(' + %trim(D1_Xref) + ') ' +
                        'DATA(*YES)' ;                                                    //0027
   RunCommand(Command:Uwerror);                                                           //PJ01

   //Correct sequence number for IAEXCOBJS file after CRTDUPOBJ command                 //0027
   Command   = 'values( ' +                                                              //0020
               'select max(IASQNO) + 1 ' +                                               //0020
               'from ' + %trim(D1_Xref) + '/IAEXCOBJS) ' +                               //0027
               'into ?';                                                                 //0020
                                                                                         //0020
   exec sql prepare stmt from :Command ;                                                 //0020
                                                                                         //0020
   exec sql execute stmt using :w_maxSeq;                                                //0020
                                                                                         //0020
   Command = 'Alter table ' + %trim(D1_Xref) + '/IAEXCOBJS' +                            //0027
               ' alter column IASQNO restart with ' + %char(w_maxSeq);                   //0020
                                                                                         //0020
   exec sql execute Immediate :Command ;                                                 //0020
                                                                                         //0020
   //Command = 'CRTDUPOBJ OBJ(IAXSRCPF) +
   //                     FROMLIB(#IADTA) +
   command = 'CRTDUPOBJ OBJ(IAXSRCPF) +
                        FROMLIB(' + %Trim(w_Reflib) + ') +
                        OBJTYPE(*FILE) +
                        TOLIB(' + %trim(D1_Xref) + ') ' +
                        'DATA(*YES)' ;
   RunCommand(Command:Uwerror);
                                                                                         //0020
   //Correct sequence number for IAXSRCPF  file after CRTDUPOBJ command                 //0020
   clear w_maxSeq;                                                                       //0020
   Command   = 'values( ' +                                                              //0020
               'select max(IASQNO) + 1 ' +                                               //0020
               'from ' + %trim(D1_Xref) + '/IAXSRCPF) ' +                                //0020
               'into ?';                                                                 //0020
                                                                                         //0020
   exec sql prepare stmt from :Command ;                                                 //0020
                                                                                         //0020
   exec sql execute stmt using :w_maxSeq;                                                //0020
                                                                                         //0020
   Command = 'Alter table ' + %trim(D1_Xref) + '/IAXSRCPF' +                             //0020
               ' alter column IASQNO restart with ' + %char(w_maxSeq);                   //0020
                                                                                         //0020
   exec sql execute Immediate :Command ;                                                 //0020

      WkMessageID = 'MSG0007';
      MessageData = D1_xref;
      exsr SendMessageToProgramQ;
   endif;

endsr;
//-------------------------------------------------------------------------------------//
//Get_storeRepos :                                                                     //
//-------------------------------------------------------------------------------------//
begsr Get_storeRepos;

   exec sql
     insert into Qtemp/wkDltRepos (wkXref,
                                   wkbuilt,                                                   //BS01
                                   wkUser,
                                   wkDesc)
       Values (trim(:S1_Xref),
               trim(:wbuilt),                                                                 //BS01
               trim(:S1_User),
               trim(:S1_Desc));

   if sqlCode < successCode;
      Eval-corr uDpsds = wkuDpsds;                                           //MT22
      uDpsds.wkQuery_Name ='Insert_qtempWkDltRepos';                         //MT22
      IaSqlDiagnostic(uDpsds);                                                           //0033
   endif;
                                                                                             //BS01
   exsr LockRepository;                                                                      //BS01

endsr;
//------------------------------------------------------------------------------------- //
//CheckRepositoryVersion
//------------------------------------------------------------------------------------- //
//Earlier it was CheckRepositoryScheduled, changed the name as only version is fetched now 0017
begsr CheckRepositoryVersion;                                                     //0017 //0009

   //Retrieving repository built version for comparing with IA version                  //0015
   exec sql                                                                              //0009
      select Xversion                                                                    //0015
        into :w_repoVersion                                                              //0015
      //from #iadta/IaInpLib                                                       //0032//0009
        from IaInpLib                                                                    //0032
       where Xref_Name = :S1_Xref limit 1;                                               //0009


endsr;                                                                                   //0009

//------------------------------------------------------------------------------------- //
//CheckRepositoryScheduled;
//------------------------------------------------------------------------------------- //
begsr CheckRepositoryScheduled;                                                          //0009
   wlock = *off;                                                                         //0009
   wbuilt = *blanks;                                                                     //0009

   //Retrieving repository built version for comparing with IA version                  //0015
   exec sql                                                                              //0009
      select XMDBuilt, Xversion                                                          //0015
        into :wbuilt, :w_repoVersion                                                     //0015
      //from #iadta/IaInpLib                                                      //0032 //0009
        from IaInpLib                                                                    //0032
       where Xref_Name = :S1_Xref limit 1;                                               //0009

   if wbuilt = 'S';                                                                      //0009
      Ind_ErrorFlag = *on;                                                               //0009
      Ind_s1opt =*on;                                                                    //0009
      wlock = *on;                                                                       //0009
      WkMessageID = 'MSG0144';                                                           //0009
      MessageData = S1_Xref;                                                             //0009
      exsr SendMessageToProgramQ;                                                        //0009
      update Sfl01;                                                                      //0009
      leavesr;                                                                           //0009
   endif;                                                                                //0009

endsr;                                                                                   //0009

//-------------------------------------------------------------------------------------//
//LockRepository :                                                                     //
//-------------------------------------------------------------------------------------//
begsr LockRepository;                                                                        //BS01
   exec sql                                                                                  //BS01
    //update #iadta/IaInpLib                                                           //0032//BS01
     update IaInpLib                                                                         //0032
        set XMDBuilt = 'L',                                                                  //BS01
            CHGPGM  = :ProgramQ,                                                             //BS01
            CHGUSER = current_User                                                           //BS01
      where Xref_Name = :s1_Xref;                                                            //BS01
                                                                                             //BS01
   if sqlCode < successCode;                                                                 //BS01
      Eval-corr uDpsds = wkuDpsds;                                                           //BS01
      uDpsds.wkQuery_Name = 'Update2_IaInpLib';                                              //BS01
      IaSqlDiagnostic(uDpsds);                                                           //0033BS01
   endif;                                                                                    //BS01
                                                                                             //BS01
endsr;                                                                                       //BS01
//----------------------------------------------------------------------------- //          //0011
//Write Libraries entry in IaRefLibP.                                           //          //0011
//----------------------------------------------------------------------------- //          //0011
begsr Log_MetaLibList ;                                                                      //0011
                                                                                             //0011
  WkUser = uDpsds.User;                                                                      //0011
  Wk_Xref = WQuote + %Trim(S1_xRef) + WQuote ;                                               //0011
                                                                                             //0011
//To delete the existing entries for the Repository.                                        //0011
  exec sql                                                                                   //0011
    Select Count(*) into :W_Count from IaRefLibP where MRefNam = :S1_xRef ;                  //0011
    if W_Count <> 0 ;                                                                        //0011
      exec sql                                                                               //0011
        Delete from IaRefLibP where MRefNam = :S1_xRef ;                                     //0011
    endif;                                                                                   //0011
                                                                                             //0011
//To Add the fresh entries for the Repository as per IaInpLib table.                        //0011
  WkInsertStmt='Select XRefNam, XLibNam, XLibSeq from IaInpLib where XRefNam = '             //0011
                 + Wk_Xref ;                                                                 //0011
                                                                                             //0011
  exec sql prepare stmt1 from :WkInsertStmt ;                                                //0011
  exec sql declare ReferenceLib cursor for Stmt1 ;                                           //0011
                                                                                             //0011
  exec sql open ReferenceLib ;                                                               //0011
                                                                                             //0011
  exec sql fetch next from ReferenceLib into :wkInsertDS ;                                   //0011
                                                                                             //0011
     dow sqlcode = *zeros ;                                                                  //0011
       exec sql Insert Into IaRefLibP(MRefNam, MLibNam , MLibSeq ,                           //0011
         CrtUser , CrtOnTS )                                                                 //0011
         values(:WkXref, :WkLib, :WkLibSeq, :WkUser , :UpTimeStamp);                         //0011
                                                                                             //0011
       exec sql fetch next from ReferenceLib into :wkInsertDS ;                              //0011
                                                                                             //0011
     enddo ;                                                                                 //0011
     exec sql close ReferenceLib ;                                                           //0011
                                                                                             //0011
endsr;                                                                                       //0011
//-------------------------------------------------------------------------------------//
//FetchAndUnlockRepository;                                                            //
//-------------------------------------------------------------------------------------//
begsr FetchAndUnlockRepository;                                                              //BS01
   exec sql                                                                                  //BS01
     declare IAMENUR_C4 Cursor For                                                           //BS01
      select *                                                                               //BS01
        from Qtemp/wkDltRepos;                                                               //BS01
                                                                                             //BS01
   exec sql open IAMENUR_C4;                                                                 //BS01
   if sqlCode = CSR_OPN_COD;                                                                 //BS01
      exec sql close IAMENUR_C4;                                                             //BS01
      exec sql open  IAMENUR_C4;                                                             //BS01
   endif;                                                                                    //BS01
                                                                                             //BS01
   if sqlCode < successCode;                                                                 //BS01
      Eval-corr uDpsds = wkuDpsds;                                                           //BS01
      uDpsds.wkQuery_Name ='Open_IAMENUR_C4';                                                //BS01
      IaSqlDiagnostic(uDpsds);                                                           //0033BS01
   endif;                                                                                    //BS01
                                                                                             //BS01
   if sqlCode = successCode;                                                                 //BS01
      exec sql fetch next from IAMENUR_C4 Into :DeleteReposDs;                               //BS01
      if sqlCode < successCode;                                                              //BS01
         Eval-corr uDpsds = wkuDpsds;                                                        //BS01
         uDpsds.wkQuery_Name ='Fetch1_IAMENUR_C4';                                           //BS01
         IaSqlDiagnostic(uDpsds);                                                        //0033BS01
      endif;                                                                                 //BS01
                                                                                             //BS01
      dow sqlCode = successCode;                                                             //BS01
         wrepo = DeleteReposDs.w_xref;                                                       //BS01
         wbuiltq = DeleteReposDs.w_built;                                                    //BS01
         exsr UnlockRepository;                                                              //BS01
         exec sql fetch next from IAMENUR_C4 into :DeleteReposDs;                            //BS01
         if sqlCode < successCode;                                                           //BS01
            Eval-corr uDpsds = wkuDpsds;                                                     //BS01
            uDpsds.wkQuery_Name ='Fetch2_IAMENUR_C4';                                        //BS01
            IaSqlDiagnostic(uDpsds);                                                     //0033BS01
            Leave;                                                                           //BS01
         endif;                                                                              //BS01
      enddo;                                                                                 //BS01
      exec sql close IAMENUR_C4;                                                             //BS01
   endif;                                                                                    //BS01
                                                                                             //BS01
endsr;                                                                                       //BS01
//-------------------------------------------------------------------------------------//
//UnlockRepository;                                                                    //
//-------------------------------------------------------------------------------------//
begsr UnlockRepository;                                                                      //BS01
   wexist = 'N';                                                                             //BS01
   exec sql                                                                                  //BS01
    // select 'Y' into :wexist from #iadta/IaInpLib                                    //0032//BS01
    select 'Y' into :wexist from IaInpLib                                                    //0032
     where Xref_Name = :wrepo and XMDBuilt = 'L' limit 1;                                    //BS01
     if wexist = 'Y';                                                                        //BS01
         exec sql                                                                            //BS01
          // update #iadta/IaInpLib                                                    //0032//BS01
           update IaInpLib                                                                   //0032
              set XMDBuilt = :wbuiltq,                                                       //BS01
                  CHGPGM  = :ProgramQ,                                                       //BS01
                  CHGUSER =  current_User                                                    //BS01
            where Xref_Name = :wrepo;                                                        //BS01
                                                                                             //BS01
         if sqlCode < successCode;                                                           //BS01
            Eval-corr uDpsds = wkuDpsds;                                                     //BS01
            uDpsds.wkQuery_Name = 'Update2_IaInpLib';                                        //BS01
            IaSqlDiagnostic(uDpsds);                                                     //0033BS01
         endif;                                                                              //BS01
     endif;                                                                                  //BS01
endsr;                                                                                       //BS01
//------------------------------------------------------------------------------------- //
//UpdatePreviousStatus;
//------------------------------------------------------------------------------------- //
begsr UpdatePreviousStatus;                                                              //0009

   wexist = 'N';                                                                         //0009
   exec sql                                                                              //0009
     //select 'Y' into :wexist from #iadta/IaInpLib                                //0032//0009
     select 'Y' into :wexist from IaInpLib                                               //0032
     where Xref_Name = :wrepo limit 1;                                                   //0009
     if wexist = 'Y';                                                                    //0009
         exec sql                                                                        //0009
          // update #iadta/IaInpLib                                                //0032//0009
           update IaInpLib                                                               //0032
              set XMDBuilt = :wbuiltq,                                                   //0009
                  CHGPGM  = :ProgramQ,                                                   //0009
                  CHGUSER =  current_User                                                //0009
            where Xref_Name = :wrepo;                                                    //0009

         if sqlCode < successCode;                                                       //0009
            Eval-corr uDpsds = wkuDpsds;                                                 //0009
            uDpsds.wkQuery_Name = 'Update3_IaInpLib';                                    //0009
            IaSqlDiagnostic(uDpsds);                                                     //0033
         endif;                                                                          //0009
     endif;                                                                              //0009

endsr;                                                                                   //0009

//-------------------------------------------------------------------------------------//
//WorkWithRepository :                                                                 //
//-------------------------------------------------------------------------------------//
begsr WorkWithRepository;

   clear WrkRepoD2;
   dow Previous = *off;
       D2ReposNm = %trim(S1_Xref);
       write MsgSflCtl;
       exfmt WrkRepoD2;
       Ind_ErrorFlag = *off;
       clear I_D2REPOPT;
       exsr RemoveMessageFromProgramQ;
       select;
       when Exit = *on;
          exsr EndPgm;
       when Previous = *on;
          clear D2RepoOpt;
          Previous = *off;
          leavesr;
       when RefreshKey = *on;
          RefreshKey = *off;
          Ind_ErrorFlag = *off;
          clear WrkRepoD2;
          clear I_D2REPOPT;
          Ind_S1Opt =*off;
          clear S1_Opt;
          ExSr Clear_Sfl01;
          ExSr Load_Sfl01;
          Exsr RemoveMessageFromProgramQ;
       when D2RepoOpt = 1;
          clear D2RepoOpt;
          clear command;
          command ='CHKOBJ OBJ(' + %trim(S1_xref) + '/IDSPFDMBRL) '+
                   'OBJTYPE(*FILE)';
          RunCommand(Command:Uwerror);
          if uwerror <> 'Y';
             IaRopt01(S1_Xref);
             uwaction = 'SOURCE SCAN';
             uwactdtl = 'SOURCE SCANNED';
             IREPHSTLOG(s1_xref: uwaction: uwactdtl);
          else;
             WkMessageID = 'MSG0008';
             MessageData = S1_Xref;
             exsr SendMessageToProgramQ;
          endif;
       when D2RepoOpt = 2;
          clear D2RepoOpt;
          IaRopt02(S1_Xref);
       when D2RepoOpt = 3;
          clear D2RepoOpt;
          // Call the program IaRopt03 for file where used
          IaRopt03(S1_Xref);
       when D2RepoOpt = 4;
          clear D2RepoOpt;
          IaRopt04(S1_Xref);
       when D2RepoOpt = 5;
          clear D2RepoOpt;
          IaRopt05(S1_Xref);
       when D2RepoOpt = 6;
          clear D2RepoOpt;
          IaRopt06(S1_Xref);
       when D2RepoOpt = 7;
          clear D2RepoOpt;
          IaRopt07(S1_Xref);
       when D2RepoOpt = *zero;
          Ind_ErrorFlag = *off;
          clear I_D2REPOPT;
       other;
          Ind_ErrorFlag = *on;
          I_D2REPOPT = ReverseImage;
          w_opt = %char(D2RepoOpt);
          WkMessageID = 'MSG0006';
          MessageData = w_Opt;
          exsr SendMessageToProgramQ;
       endsl;
    enddo;

endsr;
//-------------------------------------------------------------------------------------//
//CheckObject  :                                                                       //
//-------------------------------------------------------------------------------------//
begsr CheckObject;

   clear command;
   command ='CHKOBJ OBJ('+ %trim(w_Xref) + '/' + %trim(w_MbrName) +') ' +
            'OBJTYPE(*FILE)';
   RunCommand(Command:Uwerror);

endsr;
//-------------------------------------------------------------------------------------//
//Get_AddLible :                                                                       //
//-------------------------------------------------------------------------------------//
begsr Get_AddLible;

   monitor;
      command = 'ADDLIBLE LIB('+ %trim(w_Xref) +') ' +
                'POSITION(*FIRST)';
      RunCommand(Command:Uwerror);
   on-error;
   endmon;

endsr;
//-------------------------------------------------------------------------------------//
//Get_RmvLible :                                                                       //
//-------------------------------------------------------------------------------------//
begsr Get_RmvLible;

   monitor;
      command = 'RMVLIBLE LIB('+ %trim(w_Xref) + ')';
      RunCommand(Command:Uwerror);
   on-error;
   endmon;

endsr;
//-------------------------------------------------------------------------------------//
//Get_DeleteOverride :                                                                 //
//-------------------------------------------------------------------------------------//
begsr Get_DeleteOverride;

   monitor;
      Command = 'DLTOVR FILE(*ALL) LVL(*JOB)';
      RunCommand(Command:Uwerror);
   on-error;
   endmon;

endsr;
//-------------------------------------------------------------------------------------//
//void :                                                                               //
//-------------------------------------------------------------------------------------//
begsr void;

   clear w_sqlstmt;
   exec sql
    declare dst_repo cursor for
     select distinct XREF_NAME
      // from #iadta/IaInpLib;                                                       //0032
       from IaInpLib ;                                                               //0032

   exec sql open dst_repo;
   if sqlCode = CSR_OPN_COD;                                                         //OJ01
      exec sql close dst_repo;                                                       //OJ01
      exec sql open  dst_repo;                                                       //OJ01
   endif;                                                                            //OJ01

   if sqlCode < successCode;
      Eval-corr uDpsds = wkuDpsds;                                                   //MT22
      uDpsds.wkQuery_Name ='Open_dst_repo';                                          //MT22
      IaSqlDiagnostic(uDpsds);                                                           //0033
   endif;

   if sqlCode = successCode;
      exec sql fetch dst_repo into :w_dxref;
      if sqlCode < successCode;
         Eval-corr uDpsds = wkuDpsds;                                                   //MT22
         uDpsds.wkQuery_Name ='Fetch1_dst_repo';                                        //MT22
         IaSqlDiagnostic(uDpsds);                                                        //0033
      endif;

      dow sqlCode = successCode;
         clear command;
         command = 'CLRPFM FILE(' + %trim(w_dxref) + '/IDSPFDMBRL)';
         RunCommand(Command:Uwerror);

         clear command;
         command = 'CLRPFM FILE(' + %trim(w_dxref) + '/IDSPFDMBR)';
         RunCommand(Command:Uwerror);

         clear command;
         command = 'CLRPFM FILE(' + %trim(w_dxref) + '/IAQRPGSRC)';
         RunCommand(Command:Uwerror);

         clear command;
         command = 'CLRPFM FILE(' + %trim(w_dxref) + '/IAQCLSRC)';
         RunCommand(Command:Uwerror);

         clear command;
         command = 'CLRPFM FILE(' + %trim(w_dxref) + '/IADDSSRC)';
         RunCommand(Command:Uwerror);

         clear command;
         command = 'CLRPFM FILE(' + %trim(w_dxref) + '/IAINPLIB)';
         RunCommand(Command:Uwerror);

         clear command;
         command = 'CLRPFM FILE(' + %trim(w_dxref) + '/IASRCPF)';
         RunCommand(Command:Uwerror);

         clear command;
         command = 'CLRPFM FILE(' + %trim(w_dxref) + '/IAPGMREF)';
         RunCommand(Command:Uwerror);

         clear command;
         command = 'CLRPFM FILE(' + %trim(w_dxref) + '/IACPGMREF)';
         RunCommand(Command:Uwerror);

         clear command;
         command = 'CLRPFM FILE(' + %trim(w_dxref) + '/IACPYBDTL)';
         RunCommand(Command:Uwerror);

         clear command;
         command = 'CLRPFM FILE(' + %trim(w_dxref) + '/IAOVRPF)';
         RunCommand(Command:Uwerror);

         clear command;
         command = 'CLRPFM FILE(' + %trim(w_dxref) + '/IAREFWRK)';
         RunCommand(Command:Uwerror);

         clear command;
         command = 'CLRPFM FILE(' + %trim(w_dxref) + '/IAENTPRM)';
         RunCommand(Command:Uwerror);

         clear command;
         command = 'CLRPFM FILE(' + %trim(w_dxref) + '/IASUBRDTL)';
         RunCommand(Command:Uwerror);

         clear command;
         command = 'CLRPFM FILE(' + %trim(w_dxref) + '/IAPGMFILES)';
         RunCommand(Command:Uwerror);

         clear command;
         command = 'CLRPFM FILE(' + %trim(w_dxref) + '/IAPGMVARS)';
         RunCommand(Command:Uwerror);

         clear command;
         command = 'CLRPFM FILE(' + %trim(w_dxref) + '/IAPGMDS)';
         RunCommand(Command:Uwerror);

         clear command;
         command = 'CLRPFM FILE(' + %trim(w_dxref) + '/IAPRCPARM)';
         RunCommand(Command:Uwerror);

         clear command;
         command = 'CLRPFM FILE(' + %trim(w_dxref) + '/IACPYBDTL)';
         RunCommand(Command:Uwerror);

         clear command;
         command = 'CLRPFM FILE(' + %trim(w_dxref) + '/IAVARCAL)';
         RunCommand(Command:Uwerror);

         exec sql fetch dst_repo into :w_dxref;
         if sqlCode < successCode;
            Eval-corr uDpsds = wkuDpsds;                                                   //MT22
            uDpsds.wkQuery_Name ='Fetch2_dst_repo';                                        //MT22
            IaSqlDiagnostic(uDpsds);                                                     //0033
            Leave;
         endif;
      enddo;
      exec sql close dst_repo;
   endif;

endsr;
//-------------------------------------------------------------------------------------//
//SetEmailParameter :                                                                  //
//-------------------------------------------------------------------------------------//
begsr SetEmailParameter;

   exec sql
     declare EmailCsr cursor for
      select *
      from IaEmailPf
      where EMPGMNAME = :uDpsds.SrcMbr;

   exec sql open EmailCsr;
   if sqlCode = CSR_OPN_COD;                                                         //OJ01
      exec sql close EmailCsr;                                                       //OJ01
      exec sql open  EmailCsr;                                                       //OJ01
   endif;                                                                            //OJ01
   if sqlCode < successCode;
      Eval-corr uDpsds = wkuDpsds;                                                   //MT22
      uDpsds.wkQuery_Name ='Open_EmailCsr';                                          //MT22
      IaSqlDiagnostic(uDpsds);                                                           //0033
   endif;

   if sqlCode = successCode;
      exec sql fetch EmailCsr into :SendEmailDs;
      if sqlCode < successCode;
         Eval-corr uDpsds = wkuDpsds;                                                   //MT22
         uDpsds.wkQuery_Name ='Fetch1_EmailCsr';                                        //MT22
         IaSqlDiagnostic(uDpsds);                                                        //0033
      endif;

      dow sqlCode = successCode;
         select;
         when SendEmailDs.EMRECIPINT = '*TO';
            Ind_ToRcp = *on;
            w_EmailAddrs = '(' + %trim(SendEmailDs.EmMailAdd) + ')';
         when SendEmailDs.EMRECIPINT = '*CC';
            w_EmailAddrs = %trim(w_EmailAddrs) +
                         '(' + %trim(SendEmailDs.EmMailAdd) + ' *CC)';
         when SendEmailDs.EMRECIPINT = '*BCC';
            w_EmailAddrs = %trim(w_EmailAddrs) +
                         '(' + %trim(SendEmailDs.EmMailAdd) + ' *BCC)';
         other;
            Ind_ErrorFlag = *on;
         endsl;
         exec sql fetch EmailCsr into :SendEmailDs;
         if sqlCode < successCode;
            Eval-corr uDpsds = wkuDpsds;                                                   //MT22
            uDpsds.wkQuery_Name ='Fetch2_EmailCsr';                                        //MT22
            IaSqlDiagnostic(uDpsds);                                                     //0033
            Leave;
         endif;
      enddo;
      exec sql close EmailCsr;
   endif;

endsr;
//-------------------------------------------------------------------------------------//
//SendEmailProcess :                                                                   //
//-------------------------------------------------------------------------------------//
begsr SendEmailProcess;

   clear Command;
   Command = 'SNDSMTPEMM RCP('+ %trim(w_EmailAddrs) +') '   +
             'SUBJECT('+ %trim(SendEmailDs.EMSUBJECT) +') ' +
             'NOTE('+ %trim(SendEmailDs.EMMSGBODY) +') '    +
             'ATTACH('+ %trim(SendEmailDs.EMFILEPATH) +')';

   RunCommand(Command:Uwerror);
   if uwerror = 'Y';
      WkMessageID = 'MSG0038';
      MessageData = *blanks;
      exsr SendMessageToProgramQ;
   endif;

endsr;
//-------------------------------------------------------------------------------------//
//SendMessageToProgramQ :                                                              //
//-------------------------------------------------------------------------------------//
begsr SendMessageToProgramQ;

   MessageLen = %len(%trim(MessageData));
   callp  SendMessage(WkMessageID:
                      MessageFile:
                      MessageData:
                      MessageLen:
                      MessageType:
                      CallStack:
                      CallStackC:
                      MessageKey:
                      MessageErr);
   WkMessageID   = '';
   MessageData = '';

endsr;
//------------------------------------------------------------------------------------- //
//updateJobDetails;
//------------------------------------------------------------------------------------- //
begsr updateJobDetails;                                                                  //0009
                                                                                         //0009
   If  Refresh_Meta_Data;                                                                //0012
       w_BldMode = 'REFRESH';                                                            //0012
   Else;                                                                                 //0012
       w_BldMode = 'INIT';                                                               //0012
   EndIf;                                                                                //0012

   w_jobNumber = %subst(MessageData : (%scan(' ':MessageData) + 1) :                     //0009
                   ((%scan(' ':MessageData:5)) - (%scan(' ':MessageData))));             //0009
   exec sql                                                                              //0009
     insert into iajobdtl (iAXrefNam,                                                    //0009
                           iAJobName,                                                    //0009
                           iAJobQueu,                                                    //0009
                           iAJobDate,                                                    //0009
                           iAJobTime,                                                    //0009
                           iAJobSts,                                                     //0009
                           iABldMode,                                                    //0012
                           iACaller,                                                     //0012
                           CrtUser,                                                      //0009
                           CrtPgm)                                                       //0009
                   Values (trim(:S1_Xref),                                               //0009
                           trim(:w_jobNumber),                                           //0009
                           trim(:jobQ),                                                  //0009
                           trim(:jobDate),                                               //0009
                           trim(:jobTime),                                               //0009
                           'S',                                                          //0009
                           trim(:w_Bldmode),                                             //0012
                           trim(:udpsds.ProcNme),                                        //0012
                           trim(:uDpsds.JobUser),                                        //0009
                           trim(:uDpsds.SrcMbr));                                        //0009
                                                                                         //0009
   if sqlCode < successCode;                                                             //0009
      uDpsds.wkQuery_Name = 'Insert_IAJOBDTL';                                           //0009
      IaSqlDiagnostic(uDpsds);                                                           //0033
   endif;                                                                                //0009
                                                                                         //0009
endsr;                                                                                   //0009
//-------------------------------------------------------------------------------------//
//RemoveMessageFromProgramQ :                                                          //
//-------------------------------------------------------------------------------------//
begsr RemoveMessageFromProgramQ;

   callp RemoveMessage(CallStack:
                       CallStackC:
                       RMessageKey:
                       RemoveCode:
                       MessageErr);

endsr;
//-------------------------------------------------------------------------------------//
//Sr_ChkTotalRec :                                                                     //
//-------------------------------------------------------------------------------------//
begsr Sr_ChkTotalRec;
   //w_sqlstmt = 'Select Count(*) from #iadta/IaInpLib';                                //0032
   w_sqlstmt = 'Select Count(*) from IaInpLib';                                         //0032
   Select;
   when C1SearchBy <> *blanks;
      w_SqlWhere = ' Where ' + '(XREF_NAME) LIKE ' + Quot + '%' +
                    %trim(C1SearchBy)  + '%' + Quot +
                   ' And library_SeqNo = 10';

   when C1PosTo <> *blanks;
      w_SqlWhere = ' Where ' + 'XREF_NAME >= ' + Quot + %trim(C1PosTo) +
                     Quot + ' And library_SeqNo = 10';
   other;
      w_SqlWhere = ' where library_SeqNo = 10';
   endsl;
   if w_sqlwhere <> *blanks;
      w_sqlstmt = %trim(w_sqlstmt) + ' ' + %trim(w_sqlwhere);
   endif;
   Exec sql prepare TotalStmt from :w_Sqlstmt ;
   Exec sql Declare TotalCsr Cursor for TotalStmt;
   Exec sql open TotalCsr;
   if sqlCode = CSR_OPN_COD;                                                         //OJ01
      exec sql close TotalCsr;                                                       //OJ01
      exec sql open  TotalCsr;                                                       //OJ01
   endif;                                                                            //OJ01
   if sqlCode < successCode;
      Eval-corr uDpsds = wkuDpsds;                                                   //MT22
      uDpsds.wkQuery_Name ='Open_TotalCsr';                                          //MT22
      IaSqlDiagnostic(uDpsds);                                                           //0033
   endif;

   Exec sql fetch Next from TotalCsr into :w_TotalRec;
   if  sqlCode < successCode;
      Eval-corr uDpsds = wkuDpsds;                                                   //MT22
      uDpsds.wkQuery_Name ='Fetch1_TotalCsr';                                        //MT22
      IaSqlDiagnostic(uDpsds);                                                           //0033
   endif;
   Exec sql Close TotalCsr;
endsr;

//------------------------------------------------------------------------------------- //0015
//*INZSR: Initialization Subroutine                                                     //0015
//------------------------------------------------------------------------------------- //0015
begsr *Inzsr;                                                                            //0015
                                                                                         //0015
   exec sql                                                                              //0015
     select Version_Number                                                               //0015
       into :w_IAVersion                                                                 //0015
   //  from ailickeyp;                                                            //0015 //0031
       from ialickeyp;                                                                   //0031
                                                                                         //0015
   if sqlCode < successCode;                                                             //0015
      Eval-corr uDpsds = wkuDpsds;                                                       //0015
   // uDpsds.wkQuery_Name ='Select_Ailickeyp';                                    //0015 //0031
      uDpsds.wkQuery_Name ='Select_iAlickeyp';                                           //0031
      IaSqlDiagnostic(uDpsds);                                                           //0033
   endif;                                                                                //0015
                                                                                         //0015
endsr;                                                                                   //0015

//-------------------------------------------------------------------------------------//
//Endpgm :                                                                             //
//-------------------------------------------------------------------------------------//
begsr Endpgm;

   UPTimeStamp = %Timestamp();                                                           //HJ04
   CallP IAEXCTIMR('IAMENUR' :udpsds.ProcNme : udpsds.Lib : '*PGM' :                     //0025
   upsrc_name :                                                                         //SJ01
 //uppgm_name : uplib_name : ' ' : uptimeStamp : 'UPDATE');                        //0038//HJ04
   uppgm_name : uplib_name : ' ' : ' ' : uptimeStamp : 'UPDATE');                        //0038

   exsr Get_Rmvlible;

   *Inlr = *on;
   return;

endsr;

//--------------------------------------------------------------------------------------//0019
//SR validateMemberExclusionDetails Subroutine                                          //0019
//--------------------------------------------------------------------------------------//0019
begsr validateMemberExclusionDetails;                                                    //0019

   select;                                                                               //0019
   //Check if the Source file is Entered                                                //0019
   when d3SrcfObjn =  *blanks                                                            //0019
        and ((d3SrcObjLb =  *blanks and d3SrcMbr =  *blanks)                             //0019
        or (d3SrcObjLb <> *blanks or  d3SrcMbr <> *blanks));                             //0019
      mbr_Obj_SrcfName = *on;                                                            //0019
      WkMessageID = 'MSG0150';                                                           //0019
      MessageData = *blanks;                                                             //0019
      wkError = *on;                                                                     //0019
      exsr SendMessageToProgramQ;                                                        //0019
      leavesr;                                                                           //0019

   //Check if the Library is Entered                                                    //0019
   when d3SrcMbr <> *blanks                                                              //0019
        and d3SrcfObjn <> *blanks                                                        //0019
        and d3SrcObjlb =  *blanks;                                                       //0019
      mbr_Obj_Library = *on;                                                             //0019
      wkError = *on;                                                                     //0019
      WkMessageID = 'MSG0002';                                                           //0019
      MessageData = *blanks;                                                             //0019
      exsr SendMessageToProgramQ;                                                        //0019
      leavesr;                                                                           //0019
   endsl;                                                                                //0019

   //Check for the library existence                                                    //0019
   if d3SrcObjLb <> *blanks;                                                             //0019
      wkError = *on;                                                                     //0019
      exec sql                                                                           //0019
        select :ucFalse into :wkError                                                    //0019
         // from #iadta/iainplib                                                   //0032//0019
          from IaInpLib                                                                  //0032
         where xrefnam = :s1_xref                                                        //0019
           and xlibnam = :d3SrcObjLb;                                                    //0019

      if wkError = *on;                                                                  //0019
         mbr_Obj_Library = *on;                                                          //0019
         WkMessageID = 'MSG0031';                                                        //0019
         MessageData = d3SrcObjLb;                                                       //0019
         exsr SendMessageToProgramQ;                                                     //0019
         leavesr;                                                                        //0019
      endif;                                                                             //0019
   endif;                                                                                //0019

   //Check if the details are already Excluded                                          //0019
   w_SqlStmt = 'values( ' +                                                              //0019
               'select count(*) ' +                                                      //0019
                 'from ' + %trim(s1_xref) + '/IAXSRCPF ' +                               //0019
                'where iasrcfile = ' + quot + %trim(d3SrcfObjn) + quot +                 //0019
                 ' and iasrclib  = ' + quot + %trim(d3SrcObjLb) + quot +                 //0019
                 ' and iasrcmbr  = ' + quot + %trim(d3SrcMbr)   + quot + ') ' +          //0019
                 'into ?';                                                               //0019

   exec sql prepare stmt from :w_SqlStmt;                                                //0019

   exec sql execute stmt using :wkCount;                                                 //0019

   if wkCount <> 0;                                                                      //0019
      wkError = *on;                                                                     //0019
      WkMessageID = 'MSG0153';                                                           //0019
      MessageData = *blanks;                                                             //0019
      exsr SendMessageToProgramQ;                                                        //0019
      leavesr;                                                                           //0019
   endif;                                                                                //0019

endsr;                                                                                   //0019

//--------------------------------------------------------------------------------------//0019
//SR validateObjectExclusionDetails Subroutine                                          //0019
//--------------------------------------------------------------------------------------//0019
begsr validateObjectExclusionDetails;                                                    //0019

   //Check if full object name is given or wild card is given                           //0019
   wkPos = %scan('*':d3SrcfObjN);                                                        //0019
   if wkPos = 1;                                                                         //0019
      mbr_Obj_SrcfName = *on;                                                            //0019
      WkMessageID = 'MSG0168';                                                           //0019
      MessageData = *blanks;                                                             //0019
      wkError = *on;                                                                     //0019
      exsr SendMessageToProgramQ;                                                        //0019
      leavesr;                                                                           //0019
   endif;                                                                                //0019

   //Check if the Object Name is entered                                                //0019
   if d3SrcfObjn = *blanks;                                                              //0019
      mbr_Obj_SrcfName = *on;                                                            //0019
      WkMessageID = 'MSG0161';                                                           //0019
      MessageData = *blanks;                                                             //0019
      wkError = *on;                                                                     //0019
      exsr SendMessageToProgramQ;                                                        //0019
      leavesr;                                                                           //0019
   endif;                                                                                //0019

   //Check for the library existence in the repository                                  //0019
   if d3SrcObjLb <> *blanks;                                                             //0019
      wkError = *on;                                                                     //0019
      exec sql                                                                           //0019
        select :ucFalse into :wkError                                                    //0019
        //from #iadta/iainplib                                                     //0032//0019
          from IaInpLib                                                                  //0032
         where xrefnam = :s1_xref                                                        //0019
           and xlibnam = :d3SrcObjLb;                                                    //0019

      if wkError = *on;                                                                  //0019
         mbr_Obj_Library = *on;                                                          //0019
         WkMessageID = 'MSG0031';                                                        //0019
         MessageData = d3SrcObjLb;                                                       //0019
         exsr SendMessageToProgramQ;                                                     //0019
         leavesr;                                                                        //0019
      endif;                                                                             //0019
   endif;                                                                                //0019

   //Check if the object type is valid                                                  //0019
   if d3SrcMbr <> *blanks;                                                               //0019
      wkError = *on;                                                                     //0019
      exec sql                                                                           //0019
        select :ucFalse into :wkError                                                    //0019
        //from #iadta/iabckcnfg                                                   //0032 //0019
          from iabckcnfg                                                                 //0032
         where key_name1 = :ucObjType                                                    //0019
           and key_name2 = :d3SrcMbr;                                                    //0019

      if wkError = *on;                                                                  //0019
         ind_MbrName = *on;                                                              //0019
         WkMessageID = 'MSG0156';                                                        //0019
         MessageData = *blanks;                                                          //0019
         exsr SendMessageToProgramQ;                                                     //0019
         leavesr;                                                                        //0019
      endif;                                                                             //0019
   endif;                                                                                //0019

   //Check if the details are already Excluded                                          //0019
   w_SqlStmt = 'values( ' +                                                              //0019
               'select count(*) ' +                                                      //0019
                 'from ' + %trim(s1_xref) + '/IAEXCOBJS ' +                              //0027
                'where iaoobjnam = ' + quot + %trim(d3SrcfObjn) + quot +                 //0019
                 ' and iaoobjlib = ' + quot + %trim(d3SrcObjLb) + quot +                 //0019
                 ' and iaoobjtyp = ' + quot + %trim(d3SrcMbr)   + quot + ') ' +          //0019
                 'into ?';                                                               //0019

   exec sql prepare stmt from :w_SqlStmt;                                                //0019

   exec sql execute stmt using :wkCount;                                                 //0019

   if wkCount <> 0;                                                                      //0019
      wkError = *on;                                                                     //0019
      wkMessageID = 'MSG0153';                                                           //0019
      MessageData = *blanks;                                                             //0019
      exsr SendMessageToProgramQ;                                                        //0019
      leavesr;                                                                           //0019
   endif;                                                                                //0019

endsr;                                                                                   //0019

//--------------------------------------------------------------------------------------//0019
//SR populateMemberExclusionDetails Subroutine                                          //0019
//--------------------------------------------------------------------------------------//0019
begsr populateMemberExclusionDetails;                                                    //0019

   //Write the Member exclusion details into IAXSRCPF file                              //0019
   w_SqlStmt = 'insert into ' + %trim(s1_xref) +  '/iaxsrcpf ' +                         //0019
                          '(iasrcfile, iasrclib, iasrcmbr) ' +                           //0019
               'values (' + quot + %trim(d3SrcfObjN) + quot + ', ' +                     //0019
                            quot +%trim(d3SrcObjLb) + quot + ', ' +                      //0019
                            quot +%trim(d3SrcMbr) + quot + ')';                          //0019

   exec sql execute Immediate :w_SqlStmt;                                                //0019

   if sqlCode < successCode;                                                             //0019
      Eval-corr uDpsds = wkuDpsds;                                                       //0019
      uDpsds.wkQuery_Name ='Insert_IAXSRCPF';                                            //0019
      IaSqlDiagnostic(uDpsds);                                                           //0033
   endif;                                                                                //0019

   if sqlCode = successCode;                                                             //0019
      clear d3SrcfObjn;                                                                  //0019
      clear d3SrcObjLb;                                                                  //0019
      clear d3SrcMbr;                                                                    //0019
      WkMessageID = 'MSG0148';                                                           //0019
      MessageData = *blanks;                                                             //0019
      exsr SendMessageToProgramQ;                                                        //0019
   endif;                                                                                //0019

endsr;                                                                                   //0019

//--------------------------------------------------------------------------------------//0019
//SR populateObjectExclusionDetails Subroutine                                          //0019
//--------------------------------------------------------------------------------------//0019
begsr populateObjectExclusionDetails;                                                    //0019

   //Write the Object exclusion details into IAEXCOBJS file                             //0027
   w_SqlStmt = 'insert into ' + %trim(s1_xref) +  '/iaexcobjs ' +                        //0027
                          '(iaoobjlib, iaoobjnam, iaoobjtyp) ' +                         //0019
               'values (' + quot + %trim(d3SrcObjLb) + quot + ', ' +                     //0019
                            quot +%trim(d3SrcfObjN) + quot + ', ' +                      //0019
                            quot +%trim(d3SrcMbr) + quot + ')';                          //0019

   exec sql execute Immediate :w_SqlStmt;                                                //0019

   if sqlCode < successCode;                                                             //0019
      Eval-corr uDpsds = wkuDpsds;                                                       //0019
      uDpsds.wkQuery_Name ='Insert_IAEXCOBJS';                                           //0027
      IaSqlDiagnostic(uDpsds);                                                           //0033
   endif;                                                                                //0019

   if sqlCode = successCode;                                                             //0019
      clear d3SrcfObjn;                                                                  //0019
      clear d3SrcObjLb;                                                                  //0019
      clear d3SrcMbr;                                                                    //0019
      WkMessageID = 'MSG0148';                                                           //0019
      MessageData = *blanks;                                                             //0019
      exsr SendMessageToProgramQ;                                                        //0019
   endif;                                                                                //0019

endsr;                                                                                   //0019

//--------------------------------------------------------------------------------------//
//Initializing Variable for IAPRDVLDR call                                              //
//--------------------------------------------------------------------------------------//
Begsr Reset_Variables ;                                                                  //0017
   Wk_processType = *Blanks;                                                             //0017
   wkMessageId    = *Blanks;                                                             //0017
   wbuiltq        = *blanks;                                                             //0017
   wbuilt         = *Blanks;                                                             //0017
   Ind_ErrorFlag  = *off;                                                                //0017
   Ind_s1opt      = *off;                                                                //0017
Endsr;                                                                                   //0017
//--------------------------------------------------------------------------------------//
//Keep the previous value for the repo build status                                     //
//--------------------------------------------------------------------------------------//
Begsr Fetch_Repository_Status ;                                                          //0017
   exec sql                                                                              //0017
      select XMDBuilt into :wbuilt                                                       //0017
    // from #iadta/IaInpLib                                                        //0032//0017
       from IaInpLib                                                                     //0032
      where Xref_Name = :S1_Xref limit 1;                                                //0017

     wbuiltq = wbuilt;                                                                   //0017

Endsr;                                                                                   //0017
//-------------------------------------------------------------------------------------//
//getProcessType :                                                                     //
//-------------------------------------------------------------------------------------//
dcl-proc getProcessType;
   dcl-pi getProcessType char(1) end-pi;

   dcl-s previous_batch_value char(1) inz;
   dcl-s test_date date inz;
   dcl-s test_time time inz;
   dcl-s current_date date inz;
   dcl-s current_time time inz;
   dcl-s invalid ind inz;
   dcl-s error_flag char(1) inz;

   Clear jobq;                                                                              //AJ01
   invalid_opt  = 'N';                                                                      //PP01
   BATCH = 'B';
   display_batch_info = *on;
   dow not previous;
      if invalid_opt  = 'N';                                                                //PP01
         current_date = %date();
         current_time = %time();
         jobdate = %dec(%char(current_date :*MDY0) :6 :0);
         jobtime = %dec(%char(current_time :*HMS0) :6 :0);
         previous_batch_value = BATCH;
         //SJ02 display_batch_info = (BATCH = 'B');

         ind_help = *on;                                                                 //0007
         exfmt WNBATCHPRC;
         reset invalid;
         //SJ02 display_batch_info = *off;
         batch_error_1 = *off;
         batch_error_2 = *off;
         batch_error_3 = *off;
         batch_error_4 = *off;

         if previous;
            Clear BATCH;
            leave;
         endif;

//       if BATCH <> 'B' and BATCH <> 'I';                                            //PP01  //0003
         if BATCH <> 'B' ;                                                                    //0003
            batch_error_3 = *on;                                                            //PP01
            PARA1 = BATCH;                                                                  //PP01
            invalid = *on;                                                                  //PP01
            iter;                                                                           //PP01
         endif;                                                                             //PP01

         if BATCH = 'B';
            display_batch_info = *on;
         endif;

         if BATCH = batch_process;
            command = 'CHKOBJ OBJ({JQ}) OBJTYPE(*JOBQ)';
            command = %scanrpl('{JQ}' :%trim(JOBQ) :command);
            RunCommand(Command:error_flag);
            if error_flag = 'Y';
               PARA1 = %trim(JOBQ);
               batch_error_4 = *on;
               iter;
            endif;

            test(de) *MDY jobdate;
            if %error;
               PARA1 = %editw(jobdate :date_format);
               batch_error_1 = *on;
               invalid = *on;
               iter;
            else;
               test_date = %date(jobdate :*MDY);
               if test_date < current_date;
                  PARA1 = %editw(jobdate :date_format);
                  batch_error_1 = *on;
                  invalid = *on;
                  iter;
               endif;
            endif;

            test(et) *HMS jobtime;
            if %error;
               PARA1 = %editw(jobtime :time_format);
               batch_error_2 = *on;
               invalid = *on;
               iter;
            endif;
            //MSGLINE01 = 'You have selected Batch process method to' +                    //0009
            If Refresh_Meta_Data;                                                          //0011
               MSGLINE01 = 'You have selected Batch process method to' +                   //0011
                        ' Refresh metadata.';                                              //0011
            Else;                                                                          //0011
               MSGLINE01 = 'You have selected Batch process method to' +                   //0011
                        ' build metadata.';                                                //0011
            Endif;                                                                         //0011
            MSGLINE02 = 'Job Queue is {JQ} and submit date-time is {D}-{T}';
            MSGLINE02 = %scanrpl('{JQ}' :%trim(JOBQ):MSGLINE02);
            MSGLINE02 = %scanrpl('{D}' :%trim(%editw(JOBDATE :date_format)) :MSGLINE02);
            MSGLINE02 = %scanrpl('{T}' :%trim(%editw(JOBTIME :time_format)) :MSGLINE02);
         endif;
      endif;                                                                                //PP01

      invalid_opt ='N';                                                                     //PP01
       If not invalid and invalid_opt ='N';                                                 //PP01
         ind_help = *on;                                                                 //0007

         clear MSGLINE03;                                                                //0010
         MSGLINE03 = jobScheduled();
         if MSGLINE03 <> *blanks;                                                        //0010
           exfmt WNSCHEDLD;                                                              //0010
         else;                                                                           //0010
           exfmt WNCONFIRM;                                                              //0010
         endIf;                                                                          //0010
                                                                                         //0010
         batch_error_5 = *off;                                                              //PP01
         *in12 = *off;
         if CONFIRM <> 'Y' and CONFIRM <> 'N' and previous = *off;                          //PP01
            batch_error_5 = *on;                                                            //PP01
            PARA3 = CONFIRM;                                                                //PP01
            invalid_opt = 'Y';                                                              //PP01
            iter;                                                                           //PP01
         endif;                                                                             //PP01

         if CONFIRM = 'Y' and previous = *off;                                              //PP01
            leave;
         endif;
       Endif;

      If previous = *On or CONFIRM = 'N';                                                   //SJ02
         ind_help = *off;                                                                //0007
         display_batch_info = *On;                                                          //SJ02
      EndIf;                                                                                //SJ02
      previous = *off;                                                                      //PP01
   enddo;
   ind_help = *off;                                                                      //0007
   return BATCH;

end-proc;
//-------------------------------------------------------------------------------------//
//Procedure to submit batch                                                            //
//-------------------------------------------------------------------------------------//
dcl-proc submitBatch;
   dcl-pi submitBatch;
      repository_name varchar(10) value;
   end-pi;

   dcl-s command varchar(1000) inz;
   dcl-s error_flag char(1) inz;
   dcl-s hold_time time inz;

   dcl-c quote '''';

   hold_time = %time(jobtime) + %minutes(1);
   jobtime = %dec(%char(hold_time :*HMS0) :6 :0);
                                                                                         //YG02
   If  Refresh_Meta_Data ;                                                               //0011
       Command = 'SBMJOB CMD(CALL PGM(BLDMTADTA) PARM('+Quote +                          //0011
                  %Trim(repository_name) + Quote + ' ' + Quote +                         //0011
                  'REFRESH' + Quote + ' ' + Quote + %Trim(udpsds.ProcNme) +              //0012
                   Quote + '))';                                                         //0012
         //0012   'REFRESH' + Quote + '))' ;                                             //0011
         in *lock iaMetaInfo;                                                            //0011
         up_Mode = 'REFRESH';                                                            //0011
         out iaMetaInfo;                                                                 //0011
                                                                                         //0011
   Else;                                                                                 //0011
       Command = 'SBMJOB CMD(CALL PGM(BLDMTADTA) PARM('+Quote +                          //0011
                  %Trim(repository_name) + Quote + ' ' + Quote +                         //0011
                  'INIT' + Quote + ' ' + Quote + %Trim(udpsds.ProcNme) +                 //0012
                   Quote + '))';                                                         //0012
         //0012   'INIT' + Quote + '))';                                                 //0011
         in *lock iaMetaInfo;
         up_Mode = 'INIT';
         out iaMetaInfo;
   Endif;                                                                                //0011
   //Read Data Area for the Job configuration.
   In IAJOBDAREA ;
   //command = 'SBMJOB CMD(CALL PGM(BLDMTADTA) PARM('+Quote +                              //YG02
   //           %Trim(repository_name) + Quote + '))'  +                                   //YG02
   Command   = %Trim(Command) +                                                          //0011
             ' JOB( ' + %Trim(repository_name) + ')' +                                   //YG02
             ' JOBQ( ' + %trim(JOBQ) + ')' +                                             //YG02
             ' LOG('+JOBLVL+' '+JOBSVRTY +' '+JOBTEXT+')'+
             ' SCDDATE(' + %editc(JOBDATE :'X') + ')' +                                  //YG02
             ' SCDTIME(' + %editc(JOBTIME :'X') + ')';                                   //YG02

   RunCommand(command :error_flag);

   if error_flag = *blanks;                                                              //0009
      w_repositoryStatus = 'S';                                                          //0009
      updateRepositoryStatus(repository_name:'S');                                       //0009
   endIf;                                                                                //0009
                                                                                         //0009
end-proc;                                                                                //0009
                                                                                         //0009
//------------------------------------------------------------------------------------- //
//Procedure to Update Repository Status
//------------------------------------------------------------------------------------- //
dcl-proc updateRepositoryStatus;                                                         //0009

   dcl-pi updateRepositoryStatus;                                                        //0009
      repository_name varchar(10) value;                                                 //0009
      repository_status varchar(1) value;                                                //0009
   end-pi;                                                                               //0009

   exec sql                                                                              //0009
    // update #iadta/IaInpLib                                                      //0032//0009
     update IaInpLib                                                                     //0032
        set XMDBuilt = :repository_status,                                               //0009
            CHGPGM  = :ProgramQ,                                                         //0009
            CHGUSER = current_User                                                       //0009
      where Xref_Name = :repository_name;                                                //0009
                                                                                         //0009
   if sqlCode < successCode;                                                             //0009
      Eval-corr uDpsds = wkuDpsds;                                                       //0009
      uDpsds.wkQuery_Name = 'Update4_IaInpLib';                                          //0009
      IaSqlDiagnostic(uDpsds);                                                           //0033
   endif;                                                                                //0009

end-proc;                                                                                //0009

//------------------------------------------------------------------------------------- //
//Procedure to retrieve job log message
//------------------------------------------------------------------------------------- //
dcl-proc rtvJobLogMessage;
   dcl-pi rtvJobLogMessage varchar(80) end-pi;

   //local variable declaration
   dcl-s sql_string varchar(1000) inz;
   dcl-s job_message char(80) inz;

   //local constant declaration
   dcl-c message_type 'COMPLETION';
   dcl-c message_id 'CPC1221';
   dcl-c quote '''';

   //Prepare sql string to retrieve last completion message from joblog
   sql_string = 'select cast(message_text as varchar(80)) log_message +
                from table(qsys2.joblog_info({q}{jobnumber}/{user}/{jobname}{q})) +
                where message_type = {q}{messagetype}{q} +
                and message_id = {q}{Wkmessageid}{q} +
                order by ordinal_position desc +
                fetch first rows only';

   sql_string = %scanrpl('{q}' :quote :sql_string);
   sql_string = %scanrpl('{jobnumber}' :%editc(uDpsds.jobnmbr :'X') :sql_string);
   sql_string = %scanrpl('{user}' :%trim(uDpsds.User) :sql_string);
   sql_string = %scanrpl('{jobname}' :%trim(uDpsds.JobNme) :sql_string);
   sql_string = %scanrpl('{messagetype}' :message_type :sql_string);
   sql_string = %scanrpl('{Wkmessageid}' :message_id :sql_string);

   exec sql
     declare c_job_log_info scroll cursor for joblog;

   exec sql
     prepare joblog from :sql_string;

   exec sql
     open c_job_log_info;
   if sqlCode = CSR_OPN_COD;                                                         //OJ01
      exec sql close c_job_log_info;                                                 //OJ01
      exec sql open  c_job_log_info;                                                 //OJ01
   endif;                                                                            //OJ01

   if sqlCode < successCode;
      Eval-corr uDpsds = wkuDpsds;                                                   //MT22
      uDpsds.wkQuery_Name ='Open_c_job_log_info';                                    //MT22
      IaSqlDiagnostic(uDpsds);                                                           //0033
   endif;

   exec sql
     fetch next from c_job_log_info into :job_message;
     if sqlCode < successCode;
        Eval-corr uDpsds = wkuDpsds;                                                   //MT22
        uDpsds.wkQuery_Name ='Fetch_c_job_log_info';                                   //MT22
        IaSqlDiagnostic(uDpsds);                                                         //0033
     endif;

   exec sql
     close c_job_log_info;

   return job_message;
end-proc;
//------------------------------------------------------------------------------------- //
//Procedure to check scheduler for repository jobs                                      //
//------------------------------------------------------------------------------------- //
dcl-proc jobScheduled;                                                                   //0010
   dcl-pi jobScheduled char(65) end-pi;                                                  //0010
                                                                                         //0010
   //local variable declaration
   dcl-s w_nxtRunDate char(10) inz;                                                      //0010
   dcl-s w_message char(65) inz;                                                         //0010
                                                                                         //0010
   //Check schedule
   exec sql                                                                              //0010
      select nxtSubDate                                                                  //0010
      into   :w_nxtRunDate                                                               //0010
      from   qsys2.Scheduled_Job_Info                                                    //0010
      where  status = 'SCHEDULED'                                                        //0010
      and    scdJobName = :S1_Xref limit 1;                                              //0010
                                                                                         //0010
   //Check schedule
   if sqlCode < successCode or sqlCode = NO_DATA_FOUND;                                  //0010
      return *blanks;                                                                    //0010
   endif;                                                                                //0010
                                                                                         //0010
   w_message = 'Job {JN} scheduled to run on {RD} in scheduler.';                        //0010
   w_message = %scanrpl('{JN}' :%trim(S1_Xref) :w_message);                              //0010
   w_message = %scanrpl('{RD}' :%trim(w_nxtRunDate) :w_message);                         //0010
   return w_message;                                                                     //0010
                                                                                         //0010
end-proc;                                                                                //0010
