**free
      //%METADATA                                                      *
      // %TEXT Service Program to fetch the control data               *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------- //
//Created By   :  Programmers.io @ 2023                                                 //
//Created Date :  2023/09/12                                                            //
//Developer    :  Alok Kumar                                                            //
//Description  :  Service Program to fetch the control data                             //
//                                                                                      //
//Procedure Log:                                                                        //
//------------------------------------------------------------------------------------- //
//Procedure Name           | Procedure Description                                      //
//-------------------------|----------------------------------------------------------- //
//GetKeywords              | Procedure to send the Keywords from IAKEYWORDP file        //
//                         |                                                            //
//------------------------------------------------------------------------------------- //
//                                                                                      //
//Modification Log:                                                                     //
//------------------------------------------------------------------------------------- //
//Date    | Mod_ID | Developer  | Case and Description                                  //
//--------|--------|------------|------------------------------------------------------ //
//10/10/23| 0001   |Alok Kumar  | Written procedure ValidateOpcodeName task:163         //
//23/04/24| 0002   |Sumer Parmar| fixed the issue - length or start position is out of  //
//        |        |            | range for string operation in ValidateOpcodeName      //
//        |        |            | Sub-Proc.                                             //
//26/10/23| 0003   |Alok Kumar  | Written procedure GetExceptionFields task:269         //
//------------------------------------------------------------------------------------- //
ctl-opt copyright('Programmers.io Â© 2023 | Created Sep 2023');
ctl-opt option(*noDebugIo: *srcStmt: *noUnRef) expropts(*RESDECPOS) debug;
ctl-opt nomain;
ctl-opt bndDir('IABNDDIR');

//------------------------------------------------------------------------------------- //
//Copybook Definitions
//------------------------------------------------------------------------------------- //
/copy 'QMODSRC/iagetkwdpr.rpgleinc'
/copy 'QCPYSRC/rpgivds.rpgleinc'
/copy 'QCPYSRC/rpgiiids.rpgleinc'

//------------------------------------------------------------------------------------- //
//Data Structure Definitions
//------------------------------------------------------------------------------------- //
dcl-ds  PSDS extname('IAPSDSF') PSDS qualified;
end-ds;

//------------------------------------------------------------------------------------- //
//Prototype Definitions
//------------------------------------------------------------------------------------- //
dcl-pr qcmdexc extpgm('QCMDEXC');
   *n char(500)     options(*varsize) const;
   *n packed(15:5)  const;
   *n char(3)       options(*nopass) const;
end-pr;

//------------------------------------------------------------------------------------- //
//Main Logic
//------------------------------------------------------------------------------------- //
exec sql
  set option commit = *none,
             naming = *sys,
             usrprf = *user,
             dynusrprf = *user,
             closqlcsr = *endmod,
             srtseq = *langidshr;

//------------------------------------------------------------------------------------- //
//Procedure GetKeywords: Procedure to send the Keywords from IAKEYWORD file
//Input Fields  - Keyword_Member
//              - Keyword_Type
//Output Fields - Keyword_Array
//------------------------------------------------------------------------------------- //
dcl-proc GetKeywords Export;

   dcl-pi GetKeywords char(25) dim(500);
      Keyword_Member char(10);
      Keyword_Type char(10);
      Keyword_Array char(25) dim(500);
   end-pi;

   dcl-s KerwordCnt zoned(3:0) inz(0);
   dcl-s index      zoned(3:0) inz(0);

   dcl-c Csr_Opn_Cod   const(-502);

   dcl-ds KerwordDs qualified dim(500) ;
      Keyword char(25);
   end-ds ;

   clear KerwordDs;
   clear Keyword_Array;

   if Keyword_Member = *Blanks or Keyword_Type = *Blanks;
      Return Keyword_Array;
   endif;

   //Extract the number of Keywords
   exec sql
     select count(*) into :KerwordCnt
       from iAKeyWordP
         where iAKeyMbrTp = :Keyword_Member
           and iAKeyWrdTp = :Keyword_Type;

   //Fetch the keywords
   exec sql
     declare SqlFuncCur cursor for
             select iAKeyWord From iAKeyWordP
               Where iAKeyMbrTp = :Keyword_Member
                 and iAKeyWrdTp = :Keyword_Type;

   //Open cursor
   exec sql Open SqlFuncCur;
   if sqlCode = Csr_Opn_Cod;
      exec sql close SqlFuncCur;
      exec sql open  SqlFuncCur;
   endif;

   //Fetch data from cursor
   exec sql fetch SqlFuncCur for :KerwordCnt Rows into :KerwordDs;

   for index = 1 to KerwordCnt;
      Keyword_Array(index) = KerwordDs(index).Keyword;
   endfor;

   return Keyword_Array;

end-proc;

//------------------------------------------------------------------------------------- //
//Procedure GetValidChars-Procedure to Fetch Valid charactes before and after of opcode //
//Input Fields  - Keyword_Member                                                        //
//              - Keyword_Type                                                          //
//Output Fields - Char_Array                                                            //
//------------------------------------------------------------------------------------- //
dcl-proc GetValidChars Export;                                                           //0001

   dcl-pi GetValidChars char(1) dim(50);                                                 //0001
      Keyword_Member char(10);                                                           //0001
      Keyword_Type char(10);                                                             //0001
      Char_Array char(1) dim(50);                                                        //0001
   end-pi;                                                                               //0001

   dcl-s KerwordCnt zoned(3:0) inz(0);                                                   //0001
   dcl-s index      zoned(3:0) inz(0);                                                   //0001

   dcl-c Csr_Opn_Cod   const(-502);                                                      //0001

   dcl-ds ValidCharDs qualified dim(50) ;                                                //0001
      ValidChar char(1);                                                                 //0001
   end-ds ;                                                                              //0001

   clear ValidCharDs;                                                                    //0001
   clear Char_Array;                                                                     //0001

   if Keyword_Member = *Blanks or Keyword_Type = *Blanks;                                //0001
      Return Char_Array;                                                                 //0001
   endif;                                                                                //0001

   //Extract the number of Keywords
   exec sql                                                                              //0001
     select count(*) into :KerwordCnt                                                    //0001
       from iAKeyWordP                                                                   //0001
         where iAKeyMbrTp = :Keyword_Member                                              //0001
           and iAKeyWrdTp = :Keyword_Type;                                               //0001

   //Fetch the keywords
   exec sql                                                                              //0001
     declare ValidCharCur cursor for                                                     //0001
             select iaSplVal From iAKeyWordP                                             //0001
               Where iAKeyMbrTp = :Keyword_Member                                        //0001
                 and iAKeyWrdTp = :Keyword_Type;                                         //0001

   //Open cursor
   exec sql Open ValidCharCur;                                                           //0001
   if sqlCode = Csr_Opn_Cod;                                                             //0001
      exec sql close ValidCharCur;                                                       //0001
      exec sql open  ValidCharCur;                                                       //0001
   endif;                                                                                //0001
                                                                                         //0001
   //Fetch data from cursor
   exec sql fetch ValidCharCur for :KerwordCnt Rows into :ValidCharDs;                   //0001

   for index = 1 to KerwordCnt;                                                          //0001
      Char_Array(index) = ValidCharDs(index).ValidChar;                                  //0001
   endfor;                                                                               //0001

   return Char_Array;                                                                    //0001

end-proc;                                                                                //0001

//------------------------------------------------------------------------------------- //
//Procedure ValidateOpcodeName - To validate the opcode if this is valid or not         //
//Input Fields  - In_Str                                                                //
//              - Opcode                                                                //
//              - PosOpcode                                                             //
//Output Fields - ind                                                                   //
//------------------------------------------------------------------------------------- //
dcl-Proc ValidateOpcodeName Export;                                                      //0001

 dcl-pi ValidateOpcodeName ind ;                                                         //0001
    In_Str varchar(5000) const options(*trim);                                           //0001
    Opcode varchar(50) const options(*trim);                                             //0001
    PosOpcode zoned(4:0);                                                                //0001
 end-pi;                                                                                 //0001

 Dcl-s Keyword_Member char(25) ;                                                         //0001
 Dcl-s Keyword_Type char(25) ;                                                           //0001
 Dcl-s ValidCharAry char(25) dim(500);                                                   //0001
 Dcl-s BeforeChar char(1);                                                               //0001
 Dcl-s AfterChar char(1);                                                                //0001

 Keyword_Member = 'ALL';                                                                 //0001
 Keyword_Type = 'VALIDATION';                                                            //0001
 //Fetch Valid Charactes array
 ValidCharAry = GetValidChars(Keyword_Member:                                            //0001
                           Keyword_Type:ValidCharAry);                                   //0001

 //Populate ' '  to pass the validation as opcode found at first position
 //If opcode is not found at 1st place then perform subst to fetch the before char
 If PosOpcode = 1;                                                                       //0001
    BeforeChar = ' ';                                                                    //0001
 Elseif PosOpcode > 1 and %len(In_Str) >= PosOpcode;                                     //0002
    BeforeChar = %subst(In_Str : PosOpcode - 1 : 1);                                     //0001
 Endif;                                                                                  //0001

 //Populate ' '  to pass the validation as opcode foundt at last of string
 //If opcode is not found at last place then perform subst to fetch the after char
 If PosOpcode = %len(%trim(In_Str)) - %len(%trim(Opcode)) + 1;                           //0001
    AfterChar = ' ';                                                                     //0001
 Else;                                                                                   //0001
    AfterChar = %subst(In_Str : PosOpcode + %len(%trim(Opcode)) : 1);                    //0001
 Endif;                                                                                  //0001

//Pass  the validation of when only allowed character are there before and after opcode
 If %LOOKUP(BeforeChar:ValidCharAry) > 0 and                                             //0001
    %LOOKUP(AfterChar:ValidCharAry)  > 0 ;                                               //0001
    return *off;                                                                         //0001
 Else;                                                                                   //0001
    return *on;                                                                          //0001
 Endif;                                                                                  //0001

end-Proc;                                                                                //0001

//------------------------------------------------------------------------------------- //
//Procedure GetStrOcrCount - Gives the String occurence count in a string
//Input Fields  - Srch_Str  : Search String
//              - Opcode    : Base String
//              - PosFrom   : Starting Position
//              - PosTo     : Ending Position
//Output Fields - Count
//------------------------------------------------------------------------------------- //
dcl-Proc GetStrOcrCount Export;                                                          //0001

 dcl-pi GetStrOcrCount Zoned(4:0);                                                       //0001
    Srch_Str varchar(50) const options(*trim);                                           //0001
    String varchar(5000) const options(*trim);                                           //0001
    PosFrom zoned(4:0) Options(*NoPass);                                                 //0001
    PosTo   zoned(4:0) Options(*NoPass);                                                 //0001
 end-pi;                                                                                 //0001

 Dcl-s Pos zoned(4:0);                                                                   //0001
 Dcl-s Count zoned(4:0);                                                                 //0001

 //If Ending position is not passed then count till end of string
 //and if Starting position is not sent then count from start of string
 If %PARMS  = 3;                                                                         //0001
    PosTo = %LEN(%TRIM(String));                                                         //0001
 Endif;                                                                                  //0001

 If %PARMS  = 2;                                                                         //0001
    PosTo = %LEN(%TRIM(String));                                                         //0001
    PosFROM = 1;                                                                         //0001
 Endif;                                                                                  //0001

 //Parameter validations
 If Srch_Str = *Blanks or                                                                //0001
    String = *Blanks or                                                                  //0001
    PosFrom < 0 or                                                                       //0001
    PosTo   < 0;                                                                         //0001
    Return 0;                                                                            //0001
 Endif;                                                                                  //0001

 //Logic to calculate the count
 Clear Count;                                                                            //0001

 Pos = %Scan(%trim(Srch_str) : String : PosFrom : PosTo-PosFrom+1);                      //0001

 Dow Pos > 0;                                                                            //0001
    Count += 1;                                                                          //0001
    PosFrom = Pos + 1;                                                                   //0001
    If PosTo > PosFrom + %len(%trim(Srch_str));                                          //0001
       Pos = %Scan(%trim(Srch_str) : String : PosFrom : PosTo-PosFrom+1);                //0001
    Else;                                                                                //0001
       Pos = 0;                                                                          //0001
    endif;                                                                               //0001
 enddo;                                                                                  //0001

 Return Count;                                                                           //0001

end-Proc;                                                                                //0001
                                                                                         //0003
//------------------------------------------------------------------------------------- //0003
//Procedure GetExceptionFields- Procedure to fetch the exception paramter which comes   //0003
//                            - along with SQL function                                 //0003
//Input Fields  - Keyword_Member                                                        //0003
//              - Keyword_Type                                                          //0003
//              - ExcptnFunct                                                           //0003
//Output Fields - Char_Array                                                            //0003
//------------------------------------------------------------------------------------- //0003
dcl-proc GetExceptionField Export;                                                       //0003
                                                                                         //0003
   dcl-pi GetExceptionField char(1) dim(50);                                             //0003
      Keyword_Member char(10);                                                           //0003
      Keyword_Type char(10);                                                             //0003
      ExcptnFunct char(25);                                                              //0003
      Char_Array char(1) dim(50);                                                        //0003
   end-pi;                                                                               //0003
                                                                                         //0003
   dcl-s KeywordCnt zoned(3:0) inz(0);                                                   //0003
   dcl-s index      zoned(3:0) inz(0);                                                   //0003
                                                                                         //0003
   dcl-c Csr_Opn_Cod   const(-502);                                                      //0003
                                                                                         //0003
   dcl-ds ValidCharDs qualified dim(50) ;                                                //0003
      ValidChar char(1);                                                                 //0003
   end-ds ;                                                                              //0003
                                                                                         //0003
   clear ValidCharDs;                                                                    //0003
   clear Char_Array;                                                                     //0003
                                                                                         //0003
   if Keyword_Member = *Blanks or                                                        //0003
      Keyword_Type = *Blanks or                                                          //0003
      ExcptnFunct = *Blanks ;                                                            //0003
      Return Char_Array;                                                                 //0003
   endif;                                                                                //0003
                                                                                         //0003
   //Extract the number of Keywords                                                     //0003
   exec sql                                                                              //0003
     select count(*) into :KeywordCnt                                                    //0003
       from iAKeyWordP                                                                   //0003
         where iAKeyMbrTp = :Keyword_Member                                              //0003
           and iAKeyWrdTp = :Keyword_Type                                                //0003
           and iAKeyWord = :ExcptnFunct;                                                 //0003
                                                                                         //0003
   //Fetch the keywords                                                                 //0003
   exec sql                                                                              //0003
     declare ExcFieldCur cursor for                                                      //0003
             select iaSplVal From iAKeyWordP                                             //0003
               Where iAKeyMbrTp = :Keyword_Member                                        //0003
                 and iAKeyWrdTp = :Keyword_Type                                          //0003
                 and iAKeyWord = :ExcptnFunct;                                           //0003
                                                                                         //0003
   //Open cursor                                                                        //0003
   exec sql Open ExcFieldCur;                                                            //0003
   if sqlCode = Csr_Opn_Cod;                                                             //0003
      exec sql close ExcFieldCur;                                                        //0003
      exec sql open  ExcFieldCur;                                                        //0003
   endif;                                                                                //0003
                                                                                         //0003
   //Fetch data from cursor                                                             //0003
   exec sql fetch ExcFieldCur for :KeywordCnt Rows into :ValidCharDs;                    //0003
                                                                                         //0003
   for index = 1 to KeywordCnt;                                                          //0003
      Char_Array(index) = ValidCharDs(index).ValidChar;                                  //0003
   endfor;                                                                               //0003
                                                                                         //0003
   return Char_Array;                                                                    //0003
                                                                                         //0003
end-proc;                                                                                //0003
