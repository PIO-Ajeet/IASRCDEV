**free
      //%METADATA                                                      *
      // %TEXT copybook for IAPSRPH3                                   *
      //%EMETADATA                                                     *

        //* ---------------- CallBif (IASRVPH3 PGM) ------------------------ */


        //*----------------- I/O Operations (Free) ------------------------- */
         dcl-pr IAPSRIOFR;
           *n char(5000);
           *n char(10);
           *n char(10);
           *n char(10);
           *n char(10);
           *n char(10);
           *n char(10);
           *n packed(6:0);
           *n packed(6:0);
           *n char(1);
         end-pr;

        //*----------------- I/O Operations (Fix) -------------------------- */
         dcl-pr IAPSRIOFX;
           *n char(5000);
           *n char(10);
           *n char(10);
           *n char(10);
           *n char(10);
           *n char(10);
           *n char(10);
           *n packed(6:0);
           *n packed(6:0);
           *n char(1);
         end-pr;

        //* ---------------- I/O Operations (RPG3) ------------------------- */
         dcl-pr IAPSRIORPG3;
           *n char(5000);
           *n char(10);
           *n char(10);
           *n char(10);
           *n char(10);
           *n char(10);
           *n char(10);
           *n packed(6:0);
           *n packed(6:0);
           *n char(1);
         end-pr;

          dcl-pr IASUBSTFR ;
            *n char(5000);
            *n char(10);
            *n char(10);
            *n char(10);
            *n char(10);
            *n char(10);
            *n packed(6:0) ;
            *n char(50);
            *n char(50);
            *n packed(6:0);
          end-pr;

          dcl-pr IAPSRSCN  ;
            *n char(5000);
            *n char(10);
            *n char(10);
            *n char(10);
            *n char(10);
            *n char(10);
            *n packed(6:0);
            *n char(80);
            *n char(80);
            *n packed(6:0);
          end-pr;

          dcl-pr IAPSRLEN  ;
            *n char(5000);
            *n char(10);
            *n char(10);
            *n char(10);
            *n char(10);
            *n char(10);
            *n packed(6:0);
            *n char(80);
            *n char(80);
            *n packed(6:0);
          end-pr;

          dcl-pr IAPSRXFFX;
            *n         char(5000);
            *n         char(10);
            *n         char(10);
            *n         char(10);
            *n         char(10);
            *n         char(10);
            *n         char(10);
            *n         packed(6:0);
            *n         packed(6:0);
          End-Pr;

          dcl-pr IAPSRXFFR;
            *n         char(5000) ;
            *n         char(10)   ;
            *n         char(10)   ;
            *n         char(10)   ;
            *n         char(10)   ;
            *n         char(10)   ;
            *n         packed(6:0);
            *n         char(80);
            *n         char(80);
            *n         packed(6:0);
          End-Pr;

          dcl-pr IAPSRCEVFX;
            *n char(5000);
            *n char(10);
            *n char(10);
            *n char(10);
            *n char(10);
            *n char(10);
            *n char(10);
            *n packed(6:0);
            *n packed(6:0);
            *n char(1);
          end-pr;


          //dcl-pr Ialookupop;
          //  *n     char(5000);
          //  *n     char(10);
          //  *n     char(10);
          //  *n     char(10);
          //  *n     char(10);
          //  *n     char(10);
          //  *n     char(10);
          //  *n     packed(6:0);
          //  *n     packed(6:0);
          //end-pr;

          dcl-pr Ialookupbif;
            *n         char(5000) ;
            *n         char(10)   ;
            *n         char(10)   ;
            *n         char(10)   ;
            *n         char(10)   ;
            *n         char(10)   ;
            *n         packed(6:0);
            *n         char(80);
            *n         char(80);
            *n         packed(6:0);
          end-pr;

          dcl-pr Iasubsttbif;
            *n         char(5000) ;
            *n         char(10)   ;
            *n         char(10)   ;
            *n         char(10)   ;
            *n         char(10)   ;
            *n         char(10)   ;
            *n         packed(6:0);
            *n         char(80);
            *n         char(80);
            *n         packed(6:0);
          end-pr;

          dcl-pr Iareplace;
            *n         char(5000) ;
            *n         char(10)   ;
            *n         char(10)   ;
            *n         char(10)   ;
            *n         char(10)   ;
            *n         char(10)   ;
            *n         packed(6:0);
            *n         char(80);
            *n         char(80);
            *n         packed(6:0);
          end-pr;

          dcl-pr IATIMEOPCD;
            *n     char(5000);
            *n     char(10);
            *n     char(10);
            *n     char(10);
            *n     char(10);
            *n     char(10);
            *n     char(10);
            *n     packed(6:0);
            *n     packed(6:0);
          end-pr;

          Dcl-pr IATIMEBIF;
              *n         char(5000);
              *n         char(10);
              *n         char(10);
              *n         char(10);
              *n         char(10);
              *n         char(10);
              *n         packed(6:0);
              *n         char(80);
              *n         char(80);
              *n         packed(6:0);
          End-pr;

          Dcl-pr IADAYS;
              *n         char(5000);
              *n         char(10);
              *n         char(10);
              *n         char(10);
              *n         char(10);
              *n         char(10);
              *n         packed(6:0);
              *n         char(80);
              *n         char(80);
              *n         packed(6:0);
          End-pr;
          dcl-pr iaeditcbif;
            *n         char(5000) ;
            *n         char(10)   ;
            *n         char(10)   ;
            *n         char(10)   ;
            *n         char(10)   ;
            *n         char(10)   ;
            *n         packed(6:0);
            *n         char(80);
            *n         char(80);
            *n         packed(6:0);
          end-pr;

          dcl-pr Iaxltop;
            *n     char(5000);
            *n     char(10);
            *n     char(10);
            *n     char(10);
            *n     char(10);
            *n     char(10);
            *n     char(10);
            *n     packed(6:0);
            *n     packed(6:0);
          end-pr;

          dcl-pr Iaxltbif;
            *n         char(5000) ;
            *n         char(10)   ;
            *n         char(10)   ;
            *n         char(10)   ;
            *n         char(10)   ;
            *n         char(10)   ;
            *n         packed(6:0);
            *n         char(80);
            *n         char(80);
            *n         packed(6:0);
          end-pr;

          dcl-pr Iadecbif;
            *n         char(5000) ;
            *n         char(10)   ;
            *n         char(10)   ;
            *n         char(10)   ;
            *n         char(10)   ;
            *n         char(10)   ;
            *n         packed(6:0);
            *n         char(80);
            *n         char(80);
            *n         packed(6:0);
          end-pr;

          dcl-pr Iaintbif;
            *n         char(5000) ;
            *n         char(10)   ;
            *n         char(10)   ;
            *n         char(10)   ;
            *n         char(10)   ;
            *n         char(10)   ;
            *n         packed(6:0);
            *n         char(80);
            *n         char(80);
            *n         packed(6:0);
          end-pr;

          dcl-pr Iarembif;
            *n         char(5000) ;
            *n         char(10)   ;
            *n         char(10)   ;
            *n         char(10)   ;
            *n         char(10)   ;
            *n         char(10)   ;
            *n         packed(6:0);
            *n         char(80);
            *n         char(80);
            *n         packed(6:0);
          end-pr;

