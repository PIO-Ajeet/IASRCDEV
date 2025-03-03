**free
      //%METADATA                                                      *
      // %TEXT Execution time log of AI                                *
      //%EMETADATA                                                     *
//--------------------------------------------------------------------------------------- //
//Created By     : Programmers.io @ 2022                                                  //
//Creation Date  : 2022/05/12                                                             //
//Developer      : Himanshu Jain                                                          //
//Description    : Check Execution Time                                                   //
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
//Date    | Developer  | Case and Description                                             //
//--------|------------|----------------------------------------------------------------- //
//22/09/07| Sunny Jha  | Adapting new field AISRCF i.e. Source File Name                  //
//22/09/07| Sarvesh    | (Tag :0001)- To calculate the correct time stamp difference.     //
//23/11/29| Sabarish   | (Tag :0002)- Added Process Type.(INIT or REFRESH) #424           //
//23/10/13| Rituraj    | (Tag :0003)- Change name AIEXCTIME to IAEXCTIME [Task #248]      //
//24/08/12| Sabarish   | (Tag :0004)- IFS Member Parser Feature                           //
//--------------------------------------------------------------------------------------- //
ctl-opt option(*NoDebugIO : *SrcStmt : *noUnRef);
                                                                                         //0001
dcl-ds TS1;                                                                              //0001
  WSTART1   timestamp;                                                                   //0001
  wStrDate  Date  Pos(1);                                                                //0001
  wStrTime  Time  Pos(12);                                                               //0001
end-ds;                                                                                  //0001
                                                                                         //0001
dcl-ds TS2 ;                                                                             //0001
  WEnd      timestamp;                                                                   //0001
  wEndDate  Date  Pos(1);                                                                //0001
  wEndTime  Time  Pos(12);                                                               //0001
end-ds;                                                                                  //0001
                                                                                         //0001
dcl-ds WTimDiff  ;                                                                       //0001
   WDiffHours     Zoned(8:0);                                                            //0001
   WDiffMinutes   Zoned(2:0);                                                            //0001
   WDiffSeconds   Zoned(2:0);                                                            //0001
   WDiffMsecond   Zoned(6:0);                                                            //0001
end-ds;                                                                                  //0001
                                                                                         //0001
// Get Process Type (REFRESH or INIT) from IAMETAINFO Dataarea.                          //0002
dcl-ds iaMetaInfo dtaara len(62);                                                        //0002
   WProTyp char(7) pos(1);                                                               //0002
end-ds;                                                                                  //0002

Dcl-S WDuration Char(30) Inz(' ');
Dcl-S WStart Timestamp;
Dcl-S WDiff      Int(20) ;                                                               //0001
Dcl-S WYears     Packed(4:0);                                                            //0001
Dcl-S WMonths    Packed(6:0);                                                            //0001
Dcl-S WDays      Packed(8:0);                                                            //0001

Dcl-pi IAEXCTIMR extpgm('IAEXCTIMR');                                                    //0003
    WProNme    Char(10) Const;
    WPGM       Char(10);
    WLIB       Char(10);
    WType      Char(10) Const;
    WSrcf      Char(10);
    WMbr       Char(10);
    WMbrLib    Char(10);
    WIFSLoc    Char(100) Const;                                                          //0004
    WMbrType   Char(10) Const;
    WTimestamp Timestamp;
    WFlag      Char(6) Const;
End-pi;

Exec Sql Set Option commit = *None;
In iaMetaInfo;                                                                           //0002

if WFlag = 'INSERT';
 //Exec Sql Insert Into AIEXCTIME(AIPRONME, AIPGM, AILIB, AITYPE,                        //0002
  // 0004 Exec Sql Insert Into IAEXCTIME(AIPROCESS,AIPRONME, AIPGM, AILIB, AITYPE,              //00
  // 0004    AISRCF, AIMBR, AIMBRLIB, AIMBRTYPE, AISTARTTIM)
 //   Values(:WProNme, :WPGM, :WLib, :WType, :WSrcf, :WMbr, :WMbrLib,                    //0002
      // 0004Values(:WProTyp,:WProNme, :WPGM, :WLib, :WType, :WSrcf, :WMbr, :WMbrLib,           //00
      // 0004 :WMbrType, :WTimestamp);

   Exec Sql Insert Into IAEXCTIME (AIPROCESS, AIPRONME  , AIPGM  ,                       //0004
                                   AILIB    , AIIFSLOC  , AITYPE ,                       //0004
                                   AISRCF   , AIMBR     , AIMBRLIB,                      //0004
                                   AIMBRTYPE, AISTARTTIM         )                       //0004
                           Values(:WProTyp  ,:WProNme   ,:WPGM    ,                      //0004
                                  :WLib     ,:WIFSLoc   ,:WType   ,                      //0004
                                  :WSrcf    ,:WMbr      ,:WMbrLib ,                      //0004
                                  :WMbrType ,:WTimestamp);                               //0004
                                                                                         //0004
endif;

if WFlag = 'UPDATE';
   Exec Sql Select AISTARTTIM Into :WStart From IAEXCTIME                                //0003
      Where AIPGM = :WPGM AND AILIB = :WLib AND AITYPE = :WType
      AND AIPRONME = :WProNme AND AIMBR = :WMbr                                          //0004
     AND (AIMBRLIB = :WMbrLib OR  AIIFSLOC = :WIFSLoc )                                  //0004
      AND AIMBRTYPE = :WMbrType
      AND AISRCF    = :WSRCF
      AND AIPROCESS = :WproTyp                                                           //0002
      AND AIIFSLOC = :WIFSLoc                                                            //0004
      Order By AISTARTTIM Desc
      Fetch First Row Only;

                                                                                         //0001
       WStart1 = WStart ;                                                                //0001
       WEnd    = WtimeStamp ;                                                            //0001
                                                                                         //0001
       WYears  = %Diff(WEnd:WStart1:*Years) ;                                            //0001
       WMonths = %Diff(WEnd:WStart1:*Months);                                            //0001
       WDays   = %Diff(WEnd:WStart1:*Days);                                              //0001
                                                                                         //0001
       WDiff = %diff(WEnd:WStart1:*seconds);                                             //0001
       WDiffHours   = WDiff/3600 ;                                                       //0001
       WDiffMinutes = (WDiff - WDiffHours * 3600) / 60 ;                                 //0001
       WDiffSeconds =  WDiff - WDiffHours * 3600 - WDiffMinutes * 60;                    //0001
       WDiffMSecond = (%ABS(%Subdt(WEnd: *MSeconds) -                                    //0001
              %Subdt(WStart1: *MSeconds))) ;                                             //0001
                                                                                         //0001
        If   WDiffHours > 24 ;                                                           //0001
          WDiffHours = %Rem(WDiffHours : 24);                                            //0001
        EndIf;                                                                           //0001
                                                                                         //0001
        If   WMonths > 12 ;                                                              //0001
          WMonths = %Rem(WMonths : 12) ;                                                 //0001
        EndIf;                                                                           //0001
                                                                                         //0001
        Dow  WDays > 30 ;                                                                //0001
          If WDays > 365 ;                                                               //0001
            WDays  = %Rem(Wdays : 365);                                                  //0001
          Else ;                                                                         //0001
            WDays  = %Rem(Wdays : 30);                                                   //0001
          EndIf;                                                                         //0001
        EndDo;                                                                           //0001
                                                                                         //0001
   WDuration = (%Char(WYears)       + 'Y-' +                                             //0001
                %Char(WMonths)      + 'M-' +                                             //0001
                %Char(WDays)        + 'D-' +                                             //0001
                %Char(WDiffHours)   + 'H-' +                                             //0001
                %Char(WDiffMinutes) + 'M-' +                                             //0001
                %Char(WDiffSeconds) + 'S-' +                                             //0001
                %Char(WDiffMSecond) + 'MS');                                             //0001
                                                                                         //0001
                                                                                         //0001
                                                                                         //0001
// WDuration = (%Char(%ABS(%Subdt(WTimestamp : *Years) -                                 //0001
//            %Subdt(WStart : *Years))) + 'Y-' +                                         //0001
//           %Char(%ABS(%Subdt(WTimestamp : *Months) -                                   //0001
//            %Subdt(WStart : *Months))) + 'M-' +                                        //0001
//           %Char(%ABS(%Subdt(WTimestamp : *Days) -                                     //0001
//            %Subdt(WStart : *Days))) + 'D-' +                                          //0001
//           %Char(%ABS(%Subdt(WTimestamp : *Hours) -                                    //0001
//            %Subdt(WStart : *Hours))) + 'H-' +                                         //0001
//           %Char(%ABS(%Subdt(WTimestamp : *Minutes) -                                  //0001
//            %Subdt(WStart : *Minutes))) + 'M-' +                                       //0001
//           %Char(%ABS(%Subdt(WTimestamp : *Seconds) -                                  //0001
//            %Subdt(WStart : *Seconds)))  + 'S-' +                                      //0001
//           %Char(%ABS(%Subdt(WTimestamp : *MSeconds) -                                 //0001
//            %Subdt(WStart : *MSeconds))) + 'MS');                                      //0001

   Exec Sql Update IAEXCTIME                                                             //0003
      Set AIDuration = :WDuration, AIENDTIM = :WTimestamp
      Where AIPGM = :WPGM AND AILIB = :WLib AND AITYPE = :WType
//    AND AIPRONME = :WProNme AND AIMBR = :WMbr AND AIMBRLIB = :WMbrLib                  //0004
      AND AIPRONME = :WProNme AND AIMBR = :WMbr                                          //0004
     AND (AIMBRLIB = :WMbrLib OR  AIIFSLOC = :WIFSLoc )                                  //0004
//    AND AISRCF = :WSrcf AND AIMBRTYPE = :WMbrType;                                     //0002
      AND AISRCF = :WSrcf AND AIMBRTYPE = :WMbrType AND AIPROCESS = :WProTyp;            //0002
endif;

*Inlr = *On;
