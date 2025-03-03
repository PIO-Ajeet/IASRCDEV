     **free
      //%METADATA                                                      *
      // %TEXT copybook for iapsrrpg                                   *
      //%EMETADATA                                                     *
        //* ----------------- Arrays (Free) --------------------------------- */
         dcl-pr IAPSRARRFR;
           *n      char   (5000);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      packed(6:0);
           *n      packed(6:0);
         end-pr;

        //* ----------------- Arrays (Fix) ---------------------------------- */
         dcl-pr IAPSRARRFX;
           *n      char   (5000);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      packed(6:0);
           *n      packed(6:0);
           *n      char(30);
           *n      char(30);
         end-pr;

        //* ----------------- Files (Free) ---------------------------------- */
         dcl-pr IAPSRFLFR;
           *n      char   (5000);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      packed(6:0);
           *n      packed(6:0);
         end-pr;

        //* ----------------- Files (Fix) ----------------------------------- */
         dcl-pr IAPSRFLFX;
           *n      char   (5000);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      packed(6:0);
           *n      packed(6:0);
         end-pr;

        //* ----------------- Copybooks ------------------------------------- */
         dcl-pr IAPSRCPYB;
            *n char   (5000);
            *n char(10);
            *n char(10);
            *n char(10);
            *n char(10);
            *n char(10);
            *n char(10);
            *n packed(6:0);
            *n packed(6:0);
         end-pr;

        //* ----------------- Subroutines------------------------------------ */
         dcl-pr IAPSRSUBR;
            *n char   (5000);
            *n char(10);
            *n char(10);
            *n char(10);
            *n char(10);
            *n char(10);
            *n char(10);
            *n packed(6:0);
            *n packed(6:0);
            *n char(20);
         end-pr;
        //* ----------------- PR (Free) ------------------------------------- */
         dcl-pr IAPSRPRFR;
           *n      char   (5000);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      packed(6:0);
           *n      packed(6:0);
         end-pr;

        //* ----------------- PR (Fix) -------------------------------------- */
         dcl-pr IAPSRPRFX;
           *n      char   (5000);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      packed(6:0);
           *n      packed(6:0);
           *n      char(50);
         end-pr;

        //* ----------------- variable (Free) ------------------------------- */
         dcl-pr IAPSRVRFR;
           *n char   (5000);
           *n char(10);
           *n char(10);
           *n char(10);
           *n char(10);
           *n char(10);
           *n char(10);
           *n packed(6:0);
           *n packed(6:0);
         end-pr;

        //* ----------------- variable (Fix) -------------------------------- */
         dcl-pr IAPSRVRFX;
           *n char   (5000);
           *n char(10);
           *n char(10);
           *n char(10);
           *n char(10);
           *n char(10);
           *n char(10);
           *n packed(6:0);
           *n packed(6:0);
           *n char (3);
         end-pr;

        //* ----------------- SQL ------------------------------------------- */
         dcl-pr iapsrsql ;
           *n char   (5000);
           *n char(10);
           *n char(10);
           *n char(10);
           *n char(10);
           *n char(10);
           *n char(10);
           *n packed(6:0);
           *n packed(6:0);
         end-pr;

        //* ----------------- DS (Free) ------------------------------------- */
         dcl-pr IAPSRDSFR;
           *n char(5000);
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
           *n char(3);
           *n likeds(uwdsdtl);
         end-pr;

        //* ----------------- DS (Fix) -------------------------------------- */
         dcl-pr IAPSRDSFX;
           *n char(5000);
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
           *n char(3);
           *n likeds(uwdsdtl);
         end-pr;

        //* ----------------- DS (Fix) -------------------------------------- */
         dcl-pr IAPSRDSRPG3;
           *n char(5000);
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
           *n char(3);
           *n likeds(uwdsdtl);
         end-pr;
        //* ----------------- Variable(Free)--------------------------------- */
         dcl-pr IAPSRVARFR;
           *n      char   (5000);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      packed(6:0);
           *n      packed(6:0);
         end-pr;
        //* ----------------- Variable(Fix)--------------------------------- */
         dcl-pr IAPSRVARFX;
           *n      char   (5000);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      packed(6:0);
           *n      packed(6:0);
           *n      char(30);
           *n      char(30);
         end-pr;
        //* ----------------- Entry Parameter(fix)-------------------------- */
         dcl-pr IAPSRENTFX;
           *n      char   (5000);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      packed(6:0);
           *n      packed(6:0);
           *n      packed(5:0);
           *n      char(80);
         end-pr;

        //* ----------------- Call Parameter(fix)--------------------------- */
         dcl-pr IAPSRCALLP;
           *n      char   (5000);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      packed(6:0);
           *n      packed(6:0);
         end-pr;

        //* ----------------- Call Parameter(fix)--------------------------- */
         dcl-pr IAPSRVARCL;
           *n      char   (5000);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      packed(6:0);
           *n      packed(6:0);
           *n      char(128);
         end-pr;
        //* ----------------- Call Parameter(free) ------------------------- */
         dcl-pr IAPSRFCALL;
           *n      char   (5000);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      packed(6:0);
           *n      packed(6:0);
         end-pr;

        //* ----------------- Entry Parameter(fix)-------------------------- */
         dcl-pr IAPSRENTFX3;
           *n      char   (5000);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      packed(6:0);
           *n      packed(6:0);
           *n      packed(5:0);
           *n      char(80);
         end-pr;
        //* ----------------- Opcode (rpgle) ------------------------------- */
         dcl-pr IAPSROPCFX;
           *n      char   (5000);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      packed(6:0);
           *n      packed(6:0);
         end-pr;

        //* ----------------- Opcode (rpg) --------------------------------- */
         dcl-pr IAPSROPCFX3;
           *n      char   (5000);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      packed(6:0);
           *n      packed(6:0);
         end-pr;

        //* ----------------- Define (rpgle) ------------------------------- */
         dcl-pr IAPSRDEFFX;
           *n      char   (5000);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      packed(6:0);
           *n      packed(6:0);
         end-pr;

        //* ----------------- Defn(rpg)------------------------------------- */
         dcl-pr IAPSRDEFFX3;
           *n      char   (5000);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      packed(6:0);
           *n      packed(6:0);
         end-pr;
        //* ----------------- Constant(Rpg3) ------------------------------- */
         dcl-pr IAPSRISPCC;
           *n      char   (5000);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      packed(6:0);
           *n      packed(6:0);
         end-pr;

        //* ----------------- Variables(Rpg3) ------------------------------ */
         dcl-pr IAPSRISPCV;
           *n      char   (5000);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      char(10);
           *n      packed(6:0);
           *n      packed(6:0);
         end-pr;
        //* ----------------- Parser program log --------------------------- */
        dcl-pr IPSRHSTLOG;
          *n char(10);
          *n char(10);
          *n char(10);
          *n char(10);
          *n char(10);
          *n char(80);
          *n char(2);
        end-pr;

        //* ----------------- Repository level log ------------------------- */
         dcl-pr IREPHSTLOG;
           *n      char(10);
           *n      char(20);
           *n      char(50);
         end-pr;

         //*----------------- KLIST (Fix) ----------------------------------- */
          dcl-pr IAPSRKLFX;
            *n char(5000);
            *n char(10);
            *n char(10);
            *n char(10);
            *n char(10);
            *n char(10);
            *n char(10);
            *n packed(6:0);
            *n packed(6:0);
            *n char(10);
            *n likeds(uwkldtl);
          end-pr;

          //*----------------- KLIST (RPG3) ---------------------------------- */
           dcl-pr IAPSRKLRPG3;
             *n char(5000);
             *n char(10);
             *n char(10);
             *n char(10);
             *n char(10);
             *n char(10);
             *n char(10);
             *n packed(6:0);
             *n packed(6:0);
             *n char(10);
             *n likeds(uwkldtl);
           end-pr;

          dcl-pr ProcessScanR Packed(5:0);
            *n         VarChar(100)   const;
            *n         VarChar(10000) const;
            *n         Packed(5:0)    Options(*NoPass) Const;
            *n         Packed(5:0)    Options(*NoPass) Const;
          end-pr;

          dcl-pr ProcessScan4 Packed(5:0);
            *n         VarChar(100)   const;
            *n         VarChar(10000) const;
            *n         Packed(5:0)    const;
            *n         Packed(5:0)    const;
          end-pr;

          dcl-pr iabreakword;
             *n  char(10) value;
             *n  char(10) value;
             *n  char(10) value;
             *n  packed(6:0) value;
             *n  char(120) value;
             *n  char(1) value;
          end-pr;
        //* ----------------------------------------------------------------- */
