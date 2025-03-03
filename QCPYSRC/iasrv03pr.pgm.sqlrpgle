**free
      //%METADATA                                                      *
      // %TEXT 03 Service Program Prototypes                           *
      //%EMETADATA                                                     *


dcl-pr IAPSRCHARFR;
   in_string  char(5000);
   in_opcode  char(10);
   in_type    char(10);
   in_srclib  char(10);
   in_srcspf  char(10);
   in_srcmbr  char(10);
   in_RRN     packed(6:0);
   in_Factor1 char(80);
   in_Factor2 char(80);
   in_Seq     packed(6:0);
end-pr;


dcl-pr IAPSRTRM;
   in_String  char(5000);
   in_Opcode  char(10);
   in_Type    char(10);
   in_SrcLib  char(10);
   in_SrcSpf  char(10);
   in_SrcMbr  char(10);
   in_Rrn     packed(6:0);
   in_Factor1 char(80);
   in_Factor2 char(80);
   in_Seq     packed(6:0);
end-pr;

dcl-pr IAPSREDITC;
   in_string  char(5000);
   in_opcode  char(10);
   in_type    char(10);
   in_srclib  char(10);
   in_srcspf  char(10);
   in_srcmbr  char(10);
   in_RRN     packed(6:0);
   in_Factor1 char(80);
   in_Factor2 char(80);
   in_Seq     packed(6:0);
end-pr;

dcl-pr IAPSREDITW;
   in_string  char(5000);
   in_opcode  char(10);
   in_type    char(10);
   in_srclib  char(10);
   in_srcspf  char(10);
   in_srcmbr  char(10);
   in_RRN     packed(6:0);
   in_Factor1 char(80);
   in_Factor2 char(80);
   in_Seq     packed(6:0);
end-pr;

dcl-pr IAPSRDAT;
   in_string  char(5000);
   in_opcode  char(10);
   in_type    char(10);
   in_srclib  char(10);
   in_srcspf  char(10);
   in_srcmbr  char(10);
   in_RRN     packed(6:0);
   in_Factor1 char(80);
   in_Factor2 char(80);
   in_Seq     packed(6:0);
end-pr;

dcl-pr iadivbif;
   in_string  char(5000);
   in_opcode  char(10);
   in_type    char(10);
   in_srclib  char(10);
   in_srcspf  char(10);
   in_srcmbr  char(10);
   in_RRN     packed(6:0);
   dv_refact1 char(80);
   dv_refact2 char(80);
   in_Seq     packed(6:0);
end-pr;

dcl-pr IAPSRCFREE;
   in_string    char(5000);
   in_type      char(10);
   in_error     char(10);
   in_xRef      char(10);
   in_srclib    char(10);
   in_srcspf    char(10);
   in_srcmbr    char(10);
   in_RRN       packed(6:0);
   in_rrn_e     packed(6:0);
   in_ErrLogFlg char(1);
end-pr;

dcl-pr ialookupbif;
   in_string  char(5000);
   in_opcode  char(10);
   in_type    char(10);
   in_srclib  char(10);
   in_srcspf  char(10);
   in_srcmbr  char(10);
   in_RRN     packed(6:0);
   lk_refact1 char(80);
   lk_refact2 char(80);
   in_Seq     packed(6:0);
end-pr;

dcl-pr iareplace;
   in_string  char(5000);
   in_opcode  char(10);
   in_type    char(10);
   in_srclib  char(10);
   in_srcspf  char(10);
   in_srcmbr  char(10);
   in_RRN     packed(6:0);
   lk_refact1 char(80);
   lk_refact2 char(80);
   in_Seq     packed(6:0);
end-pr;

dcl-pr IAPSRXFFR;
   in_string  char(5000);
   in_opcode  char(10);
   in_type    char(10);
   in_srclib  char(10);
   in_srcspf  char(10);
   in_srcmbr  char(10);
   in_RRNs    packed(6:0);
   in_factor1 char(80);
   in_factor2 char(80);
   in_Seq     packed(6:0);
end-pr;

dcl-pr IAPSRCEVFX;
   in_string    char(5000);
   in_type      char(10);
   in_error     char(10);
   in_xref      char(10);
   in_srclib    char(10);
   in_srcspf    char(10);
   in_srcmbr    char(10);
   in_RRN       packed(6:0);
   in_rrn_e     packed(6:0);
   in_ErrLogFlg char(1);
end-pr;

dcl-pr IAPSRSCN;
   In_string  char(5000);
   In_opcode  char(10);
   In_type    char(10);
   In_srclib  char(10);
   In_srcspf  char(10);
   In_srcmbr  char(10);
   In_rrn     packed(6:0);
   In_Factor1 char(80);
   In_Factor2 char(80);
   In_seq     packed(6:0);
end-pr;

dcl-pr IAPSRLEN;
   in_string  char(5000);
   in_opcode  char(10);
   in_type    char(10);
   in_srclib  char(10);
   in_srcspf  char(10);
   in_srcmbr  char(10);
   in_rrn     packed(6:0);
   In_Factor1 char(80);
   In_Factor2 char(80);
   In_seq     packed(6:0);
end-pr;


dcl-pr IAPSRCHK;
   in_string  char(5000);
   in_opcode  char(10);
   in_type    char(10);
   in_srclib  char(10);
   in_srcspf  char(10);
   in_srcmbr  char(10);
   in_RRN     packed(6:0);
   in_Factor1 char(80);
   in_Factor2 char(80);
   in_Seq     packed(6:0);
end-pr;

dcl-pr IATIMEBIF;
   in_string  char(5000);
   in_opcode  char(10);
   in_type    char(10);
   in_srclib  char(10);
   in_srcspf  char(10);
   in_srcmbr  char(10);
   in_RRN     packed(6:0);
   lk_refact1 char(80);
   lk_refact2 char(80);
   in_Seq     packed(6:0);
end-pr;

dcl-pr iaxltbif;
   in_string  char(5000);
   in_opcode  char(10);
   in_type    char(10);
   in_srclib  char(10);
   in_srcspf  char(10);
   in_srcmbr  char(10);
   in_RRN     packed(6:0);
   xl_refact1 char(80);
   xl_refact2 char(80);
   in_Seq     packed(6:0);
end-pr;

dcl-pr IAPSRIOFR;
   in_string    char(5000);
   in_type      char(10);
   in_error     char(10);
   in_xref      char(10);
   in_srclib    char(10);
   in_srcspf    char(10);
   in_srcmbr    char(10);
   in_rrn       packed(6:0);
   in_rrn_e     packed(6:0);
   in_ErrLogFlg char(1);
end-pr;

dcl-pr iaintbif;
   in_string  char(5000);
   in_opcode  char(10);
   in_type    char(10);
   in_srclib  char(10);
   in_srcspf  char(10);
   in_srcmbr  char(10);
   in_RRN     packed(6:0);
   mt_refact1 char(80);
   mt_refact2 char(80);
   in_Seq     packed(6:0);
end-pr;

dcl-pr IADAYS;
   in_string  char(5000);
   in_opcode  char(10);
   in_type    char(10);
   in_srclib  char(10);
   in_srcspf  char(10);
   in_srcmbr  char(10);
   in_RRN     packed(6:0);
   in_Factor1 char(80);
   in_Factor2 char(80);
   in_Seq     packed(6:0);
end-pr;

dcl-pr iarembif;
   in_string  char(5000);
   in_opcode  char(10);
   in_type    char(10);
   in_srclib  char(10);
   in_srcspf  char(10);
   in_srcmbr  char(10);
   in_RRN     packed(6:0);
   lk_refact1 char(80);
   lk_refact2 char(80);
   in_Seq     packed(6:0);
end-pr;

dcl-pr iasubsttbif;
   in_string  char(5000);
   in_opcode  char(10);
   in_type    char(10);
   in_srclib  char(10);
   in_srcspf  char(10);
   in_srcmbr  char(10);
   in_RRN     packed(6:0);
   ss_refact1 char(80);
   ss_refact2 char(80);
   in_Seq     packed(6:0);
end-pr;

dcl-pr iadecbif;
   in_string  char(5000);
   in_opcode  char(10);
   in_type    char(10);
   in_srclib  char(10);
   in_srcspf  char(10);
   in_srcmbr  char(10);
   in_RRN     packed(6:0);
   mt_refact1 char(80);
   mt_refact2 char(80);
   in_Seq     packed(6:0);
end-pr;

dcl-pr callBIF;
   in_srclib  char(10);
   in_srcspf  char(10);
   in_srcmbr  char(10);
   in_rrn     packed(6:0);
   in_Seq     packed(6:0);
   in_bkseq   packed(6:0);
   in_opcode  char(10);
   In_factor1 char(80);
   In_factor2 char(80);
   in_type    char(10);
   in_CONT    char(10);
   in_bif     char(10);
   in_flag    char(10);
   in_field2  char(500);
   in_String  char(5000);
   in_field4  char(5000);
end-pr;

dcl-pr split_component_5;
   in_string    varchar(5000);
   out_Array    char(600) dim(600);
   out_Arrayopr char(1) dim(600);
   out_NoOfElm  packed(4:0);
end-pr;

dcl-pr split_component_6;
   in_string    varchar(5000);
   out_Array    char(600) dim(600);
   out_Arrayopr char(1) dim(600);
   out_NoOfElm  packed(4:0);
end-pr;

dcl-pr IAPSRCFIX;                                                                        //AP01
   in_string    char(5000);                                                              //AP01
   in_type      char(10);                                                                //AP01
   in_error     char(10);                                                                //AP01
   in_xRef      char(10);                                                                //AP01
   in_srclib    char(10);                                                                //AP01
   in_srcspf    char(10);                                                                //AP01
   in_srcmbr    char(10);                                                                //AP01
   in_RRN       packed(6:0);                                                             //AP01
   in_rrn_e     packed(6:0);                                                             //AP01
   in_ErrLogFlg char(1);                                                                 //AP01
end-pr;                                                                                  //AP01
