**FREE
//------------------------------------------------------------------------------------ //
//Date    | Mod_ID | Developer  | Case and Description                                 //
//--------|--------|------------|----------------------------------------------------- //
//04/07/24| 0001   | Vamsi      | Rename Bnddir AIERRBND, copybooks AICERRLOG/AIDERRLOG//
//        |        |            | and procedures AISQLDIAGNOSTIC and AIPSSRERRORLOG    //
//        |        |            | with IA*  [Task#261]                                 //
//------------------------------------------------------------------------------------ //
 ctl-opt copyright('Programmers.io    2021 | ANKUSH | Changed Nov 2021');
 ctl-opt option(*NoDebugIo:*SrcStmt);
 ctl-opt bndDir('IABNDDIR' : 'IAERRBND');                                                //0001

 Dcl-pi IAGETSRC extpgm('IAGETSRC');
    in_mbr char(10);
    object_details likeds(object_info_t) dim(99);
 End-pi;

 /define GetObjectSourceInfo
/copy 'QMODSRC/iasrv01pr.rpgleinc'
/copy 'QCPYSRC/iaderrlog.rpgleinc'


 exec sql
      set option Naming = *Sys,
          commit = *None,
          UsrPrf = *User,
          DynUsrPrf = *User,
          CloSqlCsr = *EndMod;

 object_details = getObjectSourceInfo(in_mbr);
 *inlr = *on;
/copy 'QCPYSRC/iacerrlog.rpgleinc'
