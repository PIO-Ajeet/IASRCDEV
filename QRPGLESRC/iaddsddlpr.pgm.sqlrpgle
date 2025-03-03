**free
      //%METADATA                                                      *
      // %TEXT IA - DDStoDDL Purge Program                             *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------ //
//Created By    : Programmers.io @ 2024                                                //
//Creation Date : 2024/25/10                                                           //
//Developer     : Shobhit Gupta                                                        //
//Description   : Program to Purge the data from history table                         //
//                                                                                     //
//PROCEDURE LOG:                                                                       //
//------------------------------------------------------------------------------------ //
//Procedure Name           | Procedure Description                                     //
//-------------------------|---------------------------------------------------------- //
//No Procedure             |                                                           //
//------------------------------------------------------------------------------------ //
//MODIFICATION LOG:                                                                    //
//------------------------------------------------------------------------------------ //
//Date    | Developer  | Case and Description                                          //
//--------|-------- ---|-------------------------------------------------------------- //
//XX/XX/XX| XXXX       | XXXXXX                                                        //
//------------------------------------------------------------------------------------ //
ctl-opt BndDir('IABNDDIR' : 'IAERRBND');

dcl-pi *n;
  FileName  char(10);
  FieldName char(10);
  PurgeDays char(3) options(*nopass);
end-pi;

dcl-s wkPurgeday char(3);
dcl-s wkSqlstmt  char(200);

/copy 'QCPYSRC/iaderrlog.rpgleinc'

//When the purge days are not send
if %parms() = 2 ;
  //Fetch the purge default days from the catalog table
  exec sql
    select trim(iakeyval1) into :wkPurgeday from iabckcnfg
      where iakeyname1 = 'DDS_TO_DDL'
        and iakeyname2 = 'PURGE';
else;
  wkPurgeday = PurgeDays;
endif;

//Form the sql statement for removing the data from the file as per purge days
wkSqlstmt = 'Delete from ' + %trim(FileName) + ' where ' +
             %Trim(FieldName) + ' <= (current_date - ' +
             %trim(wkPurgeday) + ' days )';

exec sql
  execute immediate :wkSqlstmt;

//SQL Diagnostic
if sqlCode < successCode;
   uDpsds.wkQuery_Name = 'DELETE_PURGE';
   IaSqlDiagnostic(uDpsds);
endif;

*inlr = *on;
