**free
      //%METADATA                                                      *
      // %TEXT 01 Service Program Prototypes                           *
      //%EMETADATA                                                     *

dcl-pr IAVARRELLOG;
   *n  char(10);
   *n  char(10);
   *n  char(10);
   *n  packed(6:0);
   *n  packed(6:0);
   *n  char(80);
   *n  char(10);
   *n  char(10);
   *n  char(10);
   *n  char(50);
   *n  char(10);
   *n  char(80);
   *n  char(10);
   *n  char(80);
   *n  char(10);
   *n  char(06);
   *n  char(1);
   *n  char(1);
   *n  char(1);
   *n  char(1);
   *n  char(1);
   *n  char(1);
   *n  char(10);
   *n  packed(5:0);
   *n  packed(5:0);
   *n  packed(5:0);
   *n  packed(5:0);
   *n  packed(5:0);
   *n  packed(5:0);
   *n  packed(5:0);
   *n  packed(5:0);
   *n  packed(5:0);
   *n  char(1);
   *n  char(1);
end-pr;

dcl-pr iaupdatepgmref;
   *n char(10);
   *n char(10) const options(*trim);
   *n char(10) const options(*trim);
   *n char(10) const options(*trim);
   *n packed(6:0);
   *n packed(6:0);
   *n char(128) const options(*trim);
   *n char(10);
   *n char(10);
   *n char(10);
   *n char(10);
   *n packed(6:0);
   *n char(10);
end-pr;

dcl-pr iabreakword;
   *n  char(10) value options(*trim);
   *n  char(10) value options(*trim);
   *n  char(10) value options(*trim);
   *n  packed(6:0) value;
   *n  char(120) value;
   *n  char(1) value;
end-pr;

dcl-pr IREPHSTLOG;
   *n char(10) const options(*trim);
   *n char(20) const options(*trim);
   *n char(50) const options(*trim);
end-pr;

dcl-pr IPSRHSTLOG;
   *n char(10);
   *n char(10) const options(*trim);
   *n char(10) const options(*trim);
   *n char(10) const options(*trim);
   *n char(10) const options(*trim);
   *n char(80) const options(*trim);
   *n char(2)  const options(*trim);
end-pr;

dcl-pr ProcessScanR Packed(5:0);
   *n varchar(100)   const;
   *n varchar(10000) const;
   *n packed(5:0)    options(*nopass) const;
   *n packed(5:0)    options(*nopass) const;
end-pr;

dcl-pr ProcessScan4 Packed(5);
   *n varchar(50)    const;
   *n varchar(10000) const;
   *n packed(5)      const;
   *n packed(5)      const;
end-pr;

dcl-pr scanKeyword varchar(5000);
   keyword       char(12)   const;
   w_ClStatement char(5000) const;
end-pr;

dcl-pr isVariableOrConst varchar(80);
   inFactor char(80) const;
end-pr;

dcl-pr GetWordsInArray;
   w_ClStatement char(5000) const;
   w_WordsArray  char(120)  dim(100);
end-pr;

dcl-pr IAVARRELUPDLOG;
   in_RESRCLIB  char(10);
   in_RESRCFLN  char(10);
   in_REPGMNM   char(10);
   in_RESEQ     packed(6:0);
   in_RERRN     packed(6:0);
   in_REROUTINE char(80);
   in_RERELTYP  char(10);
   in_RERELNUM  char(10);
   in_REOPC     char(10);
   in_RERESULT  char(50);
   in_REBIF     char(10);
   in_REFACT1   char(80);
   in_RECOMP    char(10);
   in_REFACT2   char(80);
   in_RECONTIN  char(10);
   in_RERESIND  char(06);
   in_RECAT1    char(1);
   in_RECAT2    char(1);
   in_RECAT3    char(1);
   in_RECAT4    char(1);
   in_RECAT5    char(1);
   in_RECAT6    char(1);
   in_REUTIL    char(10);
   in_RENUM1    packed(5:0);
   in_RENUM2    packed(5:0);
   in_RENUM3    packed(5:0);
   in_RENUM4    packed(5:0);
   in_RENUM5    packed(5:0);
   in_RENUM6    packed(5:0);
   in_RENUM7    packed(5:0);
   in_RENUM8    packed(5:0);
   in_RENUM9    packed(5:0);
   in_REEXC     char(1);
   in_REINC     char(1);
end-pr;

dcl-pr CalDataLengthRPGLE;
   in_Data_Typ char(10);
   in_IAV_DATF char(05);
   in_String   char(243);
   in_Decimal  char(10);
   in_Length   char(10);
   in_Pos      packed(5:0);
   in_Pos1     packed(5:0);
end-pr;

dcl-pr inquote;
   iq_string   char(5000);
   iq_position packed(6:0);
   iq_inquote  char(1);
end-pr;

dcl-pr GetCBpos packed(4:0);
   in_String char(5000);
   in_OBpos  packed(4:0);
end-pr;

dcl-pr GetOPpos packed(4:0);
   String char(5000);
   OBpos  packed(4:0);
end-pr;

dcl-pr GetSCpos packed(4:0);
   String char(5000);
   OBpos  packed(4:0);
end-pr;

dcl-pr GetDataType char(10);
   In_datatype char(1) const;
   In_decpos   char(2) const;
   In_length   char(7) const;
end-pr;

dcl-pr GetSeqNumber packed(5);
   LibraryName   char(10)  const;
   SourceFile    char(10)  const;
   MemberName    char(10)  const;
   PrPiFlag      char(2)   const;
   ProcedureName char(128) const;
   ParameterName char(128) options(*NoPass) const;
end-pr;

dcl-pr IAPQUOTE;
   in_string  char(5000);
   in_Postion packed(5:0);
   in_flag    char(1);
end-pr;

dcl-pr runcommand;
   *n char(1000) options(*varsize) const;
   *n char(1);
end-pr;

// 2nd PR
dcl-pr IAPRCRTOBJ;
   *n pointer;
end-pr;

dcl-pr findcbr;
   br_pos    packed(6:0);
   br_string char(5000);
end-pr;

dcl-pr RMVbrackets varchar(5000);
   rmv_string varchar(5000) value options(*trim);
end-pr;

dcl-pr IAPSRDEFFX;
   *n char(5000);
   *n char(10);
   *n char(10);
   *n char(10);
   *n char(10);
   *n char(10);
   *n char(10);
   *n packed(6:0);
   *n packed(6:0);
end-pr;

dcl-pr IAPSRDEFFX3;
   *n char(5000);
   *n char(10);
   *n char(10);
   *n char(10);
   *n char(10);
   *n char(10);
   *n char(10);
   *n packed(6:0);
   *n packed(6:0);
end-pr;

dcl-pr IAPSRISPCV;
   *n char(5000);
   *n char(10);
   *n char(10);
   *n char(10);
   *n char(10);
   *n char(10);
   *n char(10);
   *n packed(6:0);
   *n packed(6:0);
end-pr;

dcl-pr IAPSRISPCC;
   *n char(5000);
   *n char(10);
   *n char(10);
   *n char(10);
   *n char(10);
   *n char(10);
   *n char(10);
   *n packed(6:0);
   *n packed(6:0);
end-pr;

dcl-pr IAPSROPCFX;
   *n char(5000);
   *n char(10);
   *n char(10);
   *n char(10);
   *n char(10);
   *n char(10);
   *n char(10);
   *n packed(6:0);
   *n packed(6:0);
end-pr;

dcl-pr IAPSROPCFX3;
   *n char(5000);
   *n char(10);
   *n char(10);
   *n char(10);
   *n char(10);
   *n char(10);
   *n char(10);
   *n packed(6:0);
   *n packed(6:0);
end-pr;

dcl-pr IAPSRARRFR;
   *n char(5000);
   *n char(10);
   *n char(10);
   *n char(10);
   *n char(10);
   *n char(10);
   *n char(10);
   *n packed(6:0);
   *n packed(6:0);
end-pr;

dcl-pr IAPSRARRFX;
   *n char(5000);
   *n char(10);
   *n char(10);
   *n char(10);
   *n char(10);
   *n char(10);
   *n char(10);
   *n packed(6:0);
   *n packed(6:0);
   *n char(30);
   *n char(30);
end-pr;

dcl-pr IAPSRVARFR;
   *n char(5000) value ;                                                                 //PJ01
   *n char(10);
   *n char(10);
   *n char(10);
   *n char(10);
   *n char(10);
   *n char(10);
   *n packed(6:0);
   *n packed(6:0);
   *n ind;                                                                               //YK04
 end-pr;

dcl-pr IAPSRVARFX;
   *n char(5000);
   *n char(10);
   *n char(10);
   *n char(10);
   *n char(10);
   *n char(10);
   *n char(10);
   *n packed(6:0);
   *n packed(6:0);
   *n char(30);
   *n char(30);
   *n ind;                                                                               //YK04
end-pr;

dcl-pr ialookupop;
   in_string char(5000);
   in_type   char(10);
   in_error  char(10);
   in_xref   char(10);
   in_srclib char(10);
   in_srcspf char(10);
   in_srcmbr char(10);
   in_rrn    packed(6:0);
   in_seq    packed(6:0);
end-pr;

//3rd PR
dcl-pr IAPSRCPYB;
   in_string char(5000);
   in_ptype  char(10);
   in_perror char(10);
   in_xref   char(10);
   in_srclib char(10);
   in_srcpf  char(10);
   in_srcmbr char(10);
   in_rrns   packed(6:0);
   in_rrne   packed(6:0);
end-pr;

dcl-pr IAPSRSQL;
   in_string char(5000);
   in_ptype  char(10);
   in_perror char(10);
   in_xref   char(10);
   in_srclib char(10);
   in_srcpf  char(10);
   in_srcmbr char(10);
   in_rrns   packed(6:0);
   in_rrne   packed(6:0);
   in_srcmbrty char(10) options(*nopass);                                                //BA01
end-pr;

dcl-pr split_component_2;
   *n  char(80);
   *n  char(80) dim(15);
   *n packed(4:0);
end-pr;

dcl-pr split_component_3;
   sc_string char(80);
   sc_array  char(80) dim(15);
   sc_index  packed(4:0);
end-pr;

dcl-pr IAPSRCALLP;
   In_string char(5000);
   In_type   char(10);
   In_error  char(10);
   In_xref   char(10);
   In_srclib char(10);
   In_srcpf  char(10);
   In_srcmbr char(10);
   In_rrns   packed(6:0);
   In_rrne   packed(6:0);
end-pr;

dcl-pr getNumericValue packed(6);
   in_string_value varchar(6) const options(*trim);
end-pr;

//4th PR
dcl-pr IAPSRSUBR;
   in_string   char(5000);
   in_ptype    char(10);
   in_perror   char(10);
   in_xref     char(10);
   in_srclib   char(10);
   in_srcpf    char(10);
   in_srcmbr   char(10);
   in_rrns     packed(6:0);
   in_rrne     packed(6:0);
   in_sbrnam   char(20);
end-pr;

dcl-pr IAPSRCLSBR;
   in_ParmPointer pointer;
end-pr;

dcl-pr IAPSRCLCHG;
   in_ParmPointer pointer;
end-pr;

dcl-pr CallCLBIF;
   c_str_Name char(128);
   c_BIF      char(50);
   c_BIFstr   char(50);
   c_BIFf1    char(50);
   c_BIFf2    char(50);
end-pr;

dcl-pr  IAPSR3FAC  ;                                                                       //VM01
   in_string char(5000);
   in_type   char(10);
   in_error  char(10);
   in_xref   char(10);
   in_srclib char(10);
   in_srcspf char(10);
   in_srcmbr char(10);
   in_RRN    packed(6:0);
   in_RRN_e  packed(6:0);
end-pr;

dcl-pr  IAPSR3CON  ;
   in_string char(5000);
   in_type   char(10);
   in_error  char(10);
   in_xref   char(10);
   in_srclib char(10);
   in_srcspf char(10);
   in_srcmbr char(10);
   in_RRN    packed(6:0);
   in_RRN_e  packed(6:0);
end-pr;

dcl-pr  IAPSRFXFX  ;
   in_string char(5000);
   in_type   char(10);
   in_error  char(10);
   in_xref   char(10);
   in_srclib char(10);
   in_srcspf char(10);
   in_srcmbr char(10);
   in_RRN    packed(6:0);
   in_RRN_e  packed(6:0);
   in_ErrLogFlg char(1);
end-pr;

dcl-pr IaBreakSrcString;
   *n  char(9999);
   *n  char(120) dim(4999);
   *n  packed(4:0);
end-pr;

/if defined(getObjectSourceInfo)
// list down ILE program information
dcl-pr listILEPrograms extpgm('QBNLPGMI');
   user_space   char(20) const;
   format       char(8)  const;
   program_name char(20) const;
   errors       char(32766) options(*varsize);
end-pr;

// list down service program information
dcl-pr listServicePrograms extpgm('QBNLSPGM');
   user_space   char(20) const;
   format       char(8)  const;
   program_name char(20) const;
   errors       char(32766) options(*varsize);
end-pr;

// create user space
dcl-pr createUserSpace extpgm('QUSCRTUS');
   user_space       char(20) const;
   attribute        char(10) const;
   initial_size     int(10)  const;
   initial_value    char(1)  const;
   public_authority char(10) const;
   data             char(50) const;
   replace          char(10) const;
   errors           char(32766) options(*varsize);
end-pr;

// retrive pointer to user space
dcl-pr retriveUserSpace extpgm('QUSPTRUS');
   user_space         char(20) const;
   user_space_pointer pointer;
end-pr;

dcl-ds object_info_t qualified template;
   program_name             char(10);
   program_library          char(10);
   program_module           char(10);
   program_module_library   char(10);
   program_source_file      char(10);
   program_source_library   char(10);
   program_source_member    char(10);
   program_source_attribute char(10);
end-ds;

dcl-pr getObjectSourceInfo likeds(object_info_t) dim(99);
   *n char(10) const;
end-pr;
/endif

/if defined(getFileObjSourceInfo)                                                        //YG1108
// Retrieve source location for file object                                              //YG1108
Dcl-Pr getFileObjSourceInfo char(480);          // retrieve object desc                  //YG1108
  *n char(20) const;                            // object and lib                        //YG1108
  *n char(10) const;                            // oblect type                           //YG1108
  *n char(8) const options(*nopass);            // api format                            //YG1108
End-Pr;                                                                                  //YG1108
                                                                                         //YG1108
Dcl-Ds QusrObjDS qualified inz;                                                          //YG1108
  ObjNam char(10) pos(9);                                                                //YG1108
  Lib char(10) pos(19);                                                                  //YG1108
  Type char(10) pos(29);                                                                 //YG1108
  ReturnLib char(10) pos(39);                                                            //YG1108
  ExtendedAttr char(10) pos(91);                                                         //YG1108
  CreateDateTime char(13) pos(65);                                                       //YG1108
  ChangeDateTime char(13) pos(78);                                                       //YG1108
  Text char(50) pos(101);                                                                //YG1108
  SrcFile char(10) pos(151);                                                             //YG1108
  SrcLib char(10) pos(161);                                                              //YG1108
  SrcMbr char(10) pos(171);                                                              //YG1108
  SaveDateTime char(13) pos(194);                                                        //YG1108
  RestoreDateTime char(13) pos(207);                                                     //YG1108
  CreatedByUser char(10) pos(220);                                                       //YG1108
  LastUsedDate char(7) pos(461);  // cyymmdd format                                      //YG1108
  NumDaysUsed int(10) pos(469);                                                          //YG1108
  ObjSize int(10) pos(473);                                                              //YG1108
  MultiplySize int(10) pos(477);                                                         //YG1108
End-Ds;                                                                                  //YG1108
                                                                                         //YG1108
//--global data structures --------------------------------                              //YG1108
Dcl-Ds ApiErrDS qualified export;                                                        //YG1108
 BytesProvided int(10) pos(1) inz(%size(ApiErrDS));                                      //YG1108
 BytesReturned int(10) pos(5) inz(0);                                                    //YG1108
 ErrMsgId char(7) pos(9);                                                                //YG1108
 MsgReplaceVal char(112) pos(17);                                                        //YG1108
End-Ds;                                                                                  //YG1108

/endif

/if defined(ProcessCreateSQLOpcode)                                                        //YG1108

dcl-pr ProcessCreateSql;                                                               //YK02
  *n char(5000) value options(*trim);
  *n char(10) value options(*trim);
  *n char(10)  options(*nopass);
  *n char(10)  options(*nopass);
  *n char(10)  options(*nopass);
end-pr;

/endif

dcl-pr @ParseOnClause;                                                                    //AK06
//OJ01 *n char(5000);                                                                     //AK06
  *n char(5000) const options(*trim);                                                     //OJ01
  *n char(10);                                                                            //AK06
  *n char(10)    options(*nopass);                                                        //AK06
  *n char(10)    options(*nopass);                                                        //AK06
  *n char(10)    options(*nopass);                                                        //AK06
  *n packed(6:0) options(*nopass);                                                        //AK06
  *n packed(6:0) options(*nopass);                                                        //AK06
end-pr;                                                                                   //AK06

dcl-pr commentsSqlRemoval;                                                                //MT01
  *n char(5000);                                                                          //MT01
end-pr;                                                                                   //MT01

dcl-pr iaParsePfLfSrc ;                                                                   //PJ01
  *n char(10) ;                                                                           //PJ01
  *n char(10) ;                                                                           //PJ01
  *n char(10) ;                                                                           //PJ01
end-pr ;                                                                                  //PJ01

