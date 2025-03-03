**free
      //%METADATA                                                      *
      // %TEXT 02 Service Program Prototypes                           *
      //%EMETADATA                                                     *


dcl-pr IASNDUSRMSG;                                                            //SK01
   *n pointer;                                                                 //SK01
   *n char(10);                                                                //SK01
end-pr;                                                                        //SK01

dcl-pr IAPRSOVR;
   *n pointer;
   *n char(10) CONST;                                                           //AK11
end-pr;

dcl-pr IAPRSDOVR;
   *n pointer;
   *n char(10) CONST;
end-pr;

dcl-pr IAPRCSOVR;
   *n pointer;
end-pr;

dcl-pr IAPRDVVAR;
   *n pointer;
end-pr;

dcl-pr IAPRSSOVR;
   *n pointer;
   *n char(10) CONST;                                                           //AK12
end-pr;


dcl-pr IAPRDFOVR;
   *n pointer;
end-pr;

dcl-pr IAPRADDPFM;
   *n pointer;
   *n char(10) CONST;                                                           //AK11
end-pr;

dcl-pr IAPRCLRPFM;
   *n pointer;
   *n char(10) CONST;                                                           //AK11
end-pr;

dcl-pr IACPYFRMIMPF;
   *n pointer;
end-pr;

dcl-pr IACPYTOSTMF;
   *n pointer;
end-pr;

dcl-pr IAPRCHGPFM;
   *n pointer;
end-pr;

dcl-pr IAPRCHGLF;
   *n pointer;
end-pr;

dcl-pr IAPRCHGLFM;
   *n pointer;
end-pr;

dcl-pr IAPRCPYF;
   *n pointer;
   *n char(10) CONST;                                                           //AK12
end-pr;

dcl-pr IAPRCHGPF;
   *n pointer;
end-pr;

dcl-pr IAPREPOVR;
   *n pointer;
end-pr;

dcl-pr IAPRCRTPF;
   *n pointer;
   *n char(10) CONST;                                                           //AK12
end-pr;

dcl-pr IAPRCRTLF;
   *n pointer;
end-pr;

dcl-pr IAPRCHGPFCST;
   *n pointer;
end-pr;

dcl-pr IAPRCHGPFTRG;
   *n pointer;
end-pr;

dcl-pr IAPRCHGPRTF;
   *n pointer;
end-pr;

dcl-pr IAPRCRTDSPF;
   *n pointer;
end-pr;

dcl-pr IAPRSTRJRNPF;
   *n pointer;
end-pr;

dcl-pr IAPREPOVR2;
   *n char(10);
end-pr;

dcl-pr IAPSRENTFX;
   in_string    char(5000);
   in_type      char(10);
   in_error     char(10);
   in_xref      char(10);
   in_srclib    char(10);
   in_srcspf    char(10);
   in_srcmbr    char(10);
   in_rrns      packed(6:0);
   in_rrne      packed(6:0);
   in_seq       packed(5:0);
   in_procedure char(80);
end-pr;

dcl-pr IAPSRENTFX3;
   in_string   char(5000);
   in_type     char(10);
   in_error    char(10);
   in_xref     char(10);
   in_srclib   char(10);
   in_srcspf   char(10);
   in_srcmbr   char(10);
   in_rrns     packed(6:0);
   in_rrne     packed(6:0);
   in_seq      packed(5:0);
   in_procedure char(80);
end-pr;

dcl-pr IAPSRFLFR;
//*n char(5000);                                                                              //0002
  *n char(5000) const options(*trim);                                                         //0002
  *n char(10);
  *n char(10);
  *n char(10);
  *n char(10);
  *n char(10);
  *n char(10);
  *n packed(6:0);
  *n packed(6:0);
end-pr;

dcl-pr IAPSRFLFX;
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

// needed for IAPSRDSFR, IAPSRDSFX, IAPSRDSRPG3, writedsinfo
dcl-ds uwdsdtl_t extname('IAPGMDS') qualified template;
end-ds;

dcl-pr IAPSRDSFR;
   *n char(5000) value ;                                                                 //PJ01
   *n char(10);
   *n char(10);
   *n char(10);
   *n char(10);
   *n char(10);
   *n char(10);
   *n packed(6:0);
   *n packed(6:0);
   *n char(3);
   *n char(10);
   *n char(128);
   *n char(10);
   *n likeds(uwdsdtl_t);
end-pr;

dcl-pr IAPSRDSFX;
   *n char(5000);
   *n char(10);
   *n char(10);
   *n char(10);
 //*n char(10);                                                                               //0002
 //*n char(10);                                                                               //0002
 //*n char(10);                                                                               //0002
   *n char(10) const options(*trim);                                                          //0002
   *n char(10) const options(*trim);                                                          //0002
   *n char(10) const options(*trim);                                                          //0002
   *n packed(6:0);
   *n packed(6:0);
   *n char(3);
   *n char(10);
   *n char(128);
   *n char(10);
   *n likeds(uwdsdtl_t);
end-pr;

dcl-pr IAPSRDSRPG3;
   *n char(5000);
   *n char(10);
   *n char(10);
   *n char(10);
 //*n char(10);                                                                               //0002
 //*n char(10);                                                                               //0002
 //*n char(10);                                                                               //0002
   *n char(10) const options(*trim);                                                          //0002
   *n char(10) const options(*trim);                                                          //0002
   *n char(10) const options(*trim);                                                          //0002
   *n packed(6:0);
   *n packed(6:0);
   *n char(3);
   *n char(10);
   *n char(128);
   *n char(10);
   *n likeds(uwdsdtl_t);
end-pr;

dcl-pr writedsinfo;
   *n char(5000);
   *n likeds(uwdsdtl_t);
   *n char(10);
end-pr;

dcl-pr updatedsinfo;
   *n char(5000);
   *n likeds(uwdsdtl_t);
   *n char(10);
end-pr;


//for IAPSRKLFX, IAPSRKLRPG3, writeklistinfo
dcl-ds uwkldtl_t extname('IAPGMKLIST') qualified template;
end-ds;

dcl-pr IAPSRKLFX;
   *n char(5000);
   *n char(10);
   *n char(10);
   *n char(10);
 //*n char(10);                                                                               //0002
 //*n char(10);                                                                               //0002
 //*n char(10);                                                                               //0002
   *n char(10) const options(*trim);                                                          //0002
   *n char(10) const options(*trim);                                                          //0002
   *n char(10) const options(*trim);                                                          //0002
   *n packed(6:0);
   *n packed(6:0);
   *n char(10);
   *n likeds(uwkldtl_t);
end-pr;

dcl-pr IAPSRKLRPG3;
   *n char(5000);
   *n char(10);
   *n char(10);
   *n char(10);
 //*n char(10);                                                                               //0002
 //*n char(10);                                                                               //0002
 //*n char(10);                                                                               //0002
   *n char(10) const options(*trim);                                                          //0002
   *n char(10) const options(*trim);                                                          //0002
   *n char(10) const options(*trim);                                                          //0002
   *n packed(6:0);
   *n packed(6:0);
   *n char(10);
   *n likeds(uwkldtl_t);
end-pr;

dcl-pr writeklistinfo;
   *n likeds(uwkldtl_t);
end-pr;

dcl-pr IAPSRPRFR;
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

dcl-pr IAPSRPRFX;
   *n char(5000);
   *n char(10);
   *n char(10);
   *n char(10);
   *n char(10);
   *n char(10);
   *n char(10);
   *n packed(6:0);
   *n packed(6:0);
   *n char(50);
end-pr;

dcl-pr Pr_LikeDetails char(10);
   Keywords char(128) const;
end-pr;


dcl-pr WriteLikeDSDtl;
end-pr;

dcl-pr IAPSRDTAARA;
   *n pointer;                                                                  //AK12
   *n char(10) Const;                                                           //AK12
end-pr;                                                                         //AK12
                                                                                //AK12
dcl-pr squeezeString VARCHAR(65535);                                            //vm001
//vm001 argInBytes VARCHAR(65535) const;                                                      //0002
   argInBytes VARCHAR(65535) const options(*trim);                                            //0002
end-pr;
