**free
      //%METADATA                                                      *
      // %TEXT To create view on iaprocinfo and iaobjmap               *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------- //
//Created By    : Programmers.io @ 2022                                                 //
//Creation Date : 2022/02/04                                                            //
//Developer     : Bhoomish Atha                                                         //
//Description   : To create view on iaprocinfo and iaobjmap                             //
//                                                                                      //
//PROCEDURE LOG:                                                                        //
//------------------------------------------------------------------------------------- //
//Procedure Name           | Procedure Description                                      //
//-------------------------|----------------------------------------------------------- //
//No Procedure             |                                                            //
//------------------------------------------------------------------------------------- //
//                                                                                      //
//MODIFICATION LOG:                                                                     //
//------------------------------------------------------------------------------------- //
//Date    | Mod_ID | Developer  | Case and Description                                  //
//--------|--------|------------|------------------------------------------------------ //
//09/09/23| 0001   | Akshay     | Changed the file AIPROCDTL to IAPROCINFO in SQL query.//
//        |        |  Sopori   |[Task #208]                                           //
//05/10/23| 0002   | Satyabrat  | Rename AIPROCDTLV program and view to IAPROCDTLV.     //
//        |        |  Sabat    |[Task #265]                                           //
//05/07/24| 0003   | Akhil K.   |Renamed AIERRBND, AICERRLOG, AIDERRLOG and AISQLDIAGNO//
//        |        |            | STIC with IA*                                         //
//------------------------------------------------------------------------------------- //
ctl-opt copyright('Programmers.io Â© 2022');
ctl-opt option(*NoDebugIO : *SrcStmt : *noUnRef);
ctl-opt bndDir('IABNDDIR' : 'IAERRBND');                                                 //0003

/copy 'QCPYSRC/iaderrlog.rpgleinc'

//------------------------------------------------------------------------------------- //
//Main Functions
//------------------------------------------------------------------------------------- //

  exec sql
     set option commit = *none,
                naming = *sys,
                usrprf = *user,
                dynusrprf = *user,
                closqlcsr = *endmod;
  exec sql
     create view IaProcdtlv as                                                           //0002
        select object_name,
               object_type,
               object_libr,
               procedure_name,
               procedure_type,
               export_or_import
        from iaobjmap obj
        join iaprocinfo proc on                                                          //0001
             obj.member_libr = proc.member_library and
             obj.member_srcf = proc.source_file and
     obj.member_name = proc.member_name and
     obj.member_type = proc.member_type;

  if sqlCode < successCode;
     uDpsds.wkQuery_Name = 'Create view';
     IaSqlDiagnostic(uDpsds);                                                            //0003
  endif;

  *inlr = *on;
/copy 'QCPYSRC/iacerrlog.rpgleinc'
