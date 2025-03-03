**FREE
      //%METADATA                                                      *
      // %TEXT Copy all obj. ref. data to history file                 *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------- //
//Created By    : Programmers.io @ 2021                                                 //
//Created Date  : 2022/08/18                                                            //
//Developer     : Pranav Joshi                                                          //
//Description   : To remove excluded objects from reference file IAALLREFPF             //
//                                                                                      //
//Procedure Log :                                                                       //
//------------------------------------------------------------------------------------- //
//Procedure Name           | Procedure Description                                      //
//-------------------------|----------------------------------------------------------- //
//                         |                                                            //
//------------------------------------------------------------------------------------- //
//MODIFICATION LOG:                                                                     //
//------------------------------------------------------------------------------------- //
//Date(DMY)| Mod_Id | Developer  | Case and Description                                 //
//---------|--------|------------|----------------------------------------------------- //
//22/09/07 |        | Sunny Jha  | Adapting new field of file AIEXCTIME which captures  //
//         |        |            | source file name.                                    //
//23/01/27 |  0001  | Manesh k   | Replaced IAMENUR with BLDMTADTA (MOD:0001)           //
//04/10/23 |  0002  | Vipul P.   | Rename file AIALLREFHF to IAALLREFHF.[Task No.#244]  //
//13/10/23 |  0003  | Rituraj    | Rename file AIEXCTIME to IAEXCTIME. [Task #248]      //
//04/10/23 |  0004  | Khushi W   | Rename AIEXCOBJS to IAEXCOBJS [Task #252]            //
//05/10/23 |  0005  | Anubhavi   | Replaced program name AIPURGREF to IAPURGREF         //
//         |        |            | [Task #268]                                          //
//17/10/23 |  0006  | Akshay S   | Rename AIPURGDTA to IAPURGDTA [Task #298]            //
//05/07/24 |  0007  | Akhil K.   | Renamed AIERRBND, AICERRLOG and AIDERRLOG with IA*   //
//------------------------------------------------------------------------------------- //
 ctl-opt copyright('Programmers.io Â© 2021');
 ctl-opt option(*noDebugIo: *srcStmt: *noUnRef) expropts(*RESDECPOS);
 ctl-opt bndDir('IAERRBND');                                                             //0007

 //Reference file to capture the referenced objects
 dcl-f IAALLREFPF disk usage(*delete);

 dcl-ds IAPURGDTA dtaara len(10) ;                                                       //0006
    DsFlag Char(1) pos(1) ;
 end-ds ;

 dcl-s WkFlag Char(1) ;
 dcl-s uppgm_name  char(10)    inz;
 dcl-s uplib_name  char(10)    inz;
 dcl-s upsrc_name  char(10)    inz;
 dcl-s uptimestamp Timestamp;
 dcl-c w_lo                 'abcdefghijklmnopqrstuvwxyz';
 dcl-c w_Up                 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

 dcl-pi IAPURGREF  extpgm('IAPURGREF');                                                  //0005
    upxref char(10);
 end-pi;

 dcl-pr IAEXCTIMR extpgm('IAEXCTIMR');                                                   //0003
    *n Char(10) Const;
    *n Char(10);
    *n Char(10);
    *n Char(10) Const;
    *n Char(10);
    *n Char(10);
    *n Char(10);
    *n Char(10) Const;
    *n Timestamp;
    *n Char(6) Const;
 end-pr;

 dcl-pr checkExistenceOfReferencedObject Ind end-pr ;

/copy 'QCPYSRC/iaderrlog.rpgleinc'

 //------------------------------------------------------------------------------------//
 //Mainline
 //------------------------------------------------------------------------------------//
 exec sql
    set option Commit    = *None,
               Naming    = *Sys,
               UsrPrf    = *User,
               DynUsrPrf = *User,
               CloSqlCsr = *EndMod;

 Eval-corr uDpsds = wkuDpsds;

 //To capture the process start time
 uptimeStamp = %Timestamp();

 CallP IAEXCTIMR('BLDMTADTA' :udpsds.ProcNme : udpsds.Lib : '*PGM' :                         //0003
                 upsrc_name : uppgm_name : uplib_name : ' ' :
                 uptimeStamp : 'INSERT');

 In IAPURGDTA ;                                                                          //0006

 if %xlate(w_lo:w_Up:DsFlag) = 'Y' ;
    setll *start IAALLREFPF;
    read  IAALLREFPF;

    dow not %eof(IAALLREFPF);

       //If reference object excluded, create history and delete from AIALLREFPF.
       if checkExistenceOfReferencedObject() ;
          exsr sr_Crt_History ;
          delete iaallrefpr;
       endIf;
       read  iaallrefpf;
    enddo;

 endif;

 //To capture the process end time
 uptimeStamp = %Timestamp();
 CallP IAEXCTIMR('BLDMTADTA' :udpsds.ProcNme : udpsds.Lib : '*PGM' :                       //0003
                 upsrc_name : uppgm_name : uplib_name : ' ' :
                 uptimeStamp : 'UPDATE');

 *inlr = *on;
 return;

/copy 'QCPYSRC/iacerrlog.rpgleinc'

//------------------------------------------------------------------------------------//
//SR sr_Crt_History: Add History Record.
//------------------------------------------------------------------------------------//
 begsr sr_Crt_History ;

    exec sql
       insert into IAALLREFHF                                                            //0002
                      (Library_Name,
                       Object_Name,
                       Object_Type,
                       Object_Attr,
                       Object_Text,
                       Referenced_Obj,
                       Referenced_Objtyp,
                       Referenced_Objlib,
                       Referenced_Objusg,
                       File_Usages,
                       Maped_From,
                       Crt_pgm_Name,
                       Crt_usr_Name,
                       Crt_Timestamp,
                       Upd_Pgm_Name,
                       Upd_Usr_Name)
                      Values
                      (:Iaoobjlib,
                       :Iaoobjnam,
                       :Iaoobjtyp,
                       :Iaoobjatr,
                       :Iaoobjtxt,
                       :Iarobjnam,
                       :Iarobjtyp,
                       :Iarobjlib,
                       :Iarusages,
                       :Iafileusg,
                       :Iamapfrm ,
                       :Iacrtpgmn,
                       :Iacrtusrn,
                       :Iacrttims,
                       :Iaupdpgmn,
                       :Iaupdusrn) ;
 endsr ;

//------------------------------------------------------------------------------------ //
//Procedure checkExistenceOfReferencedObject:                                          //
//Check if object reference exists in Exclude object configuration file.               //
//------------------------------------------------------------------------------------ //
dcl-proc checkExistenceOfReferencedObject ;

   dcl-pi *n Ind;
   end-pi;

   dcl-s isRecExist Char(1) Inz ;

   isRecExist = 'N' ;

   exec sql
      Select 'Y' into :isRecExist
        from iaexcobjs                                                                   //0004
        where (iaexcobjs.object_name = :iarobjnam                                        //0004
          and iaexcobjs.object_type = :iarobjtyp                                         //0004
          and (iaexcobjs.library_name = :iarobjlib                                       //0004
          or  :iarobjlib = '*LIBL'
          or  iaexcobjs.library_name = ' '))                                             //0004
          or  (:iarobjlib = 'QSYS')  limit 1;                                               //AJ01

   if isRecExist = 'Y' ;
      return *On ;
   else ;
      return *Off ;
   endif ;

end-proc;
