     **free
      //%METADATA                                                      *
      // %TEXT copybook for IAPSRCSPCR                                 *
      //%EMETADATA                                                     *

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
         end-pr;

        //*----------------- KLIST (Free) ---------------------------------- */
         dcl-pr IAPSRKLFR;
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

        //* ---------------- KLIST (RPG3) ---------------------------------- */
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
