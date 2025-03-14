**free
      //%METADATA                                                      *
      // %TEXT copy book for IAMENUR program                           *
      //%EMETADATA                                                     *

     // --------------------------------------------------------------------- //
     dcl-pr runcommand extpgm('QCMDEXC');
       dcl-parm command char(1000) options(*varsize) const;
       dcl-parm commandlen packed(15:5) const;
     end-pr;

     // --------------------------------------------------------------------- //
     dcl-pr iaaddlibr ;
       *n Char(10);
     end-pr;

     // --------------------------------------------------------------------- //
     dcl-pr iamenur ;
     end-pr;

     // --------------------------------------------------------------------- //
     dcl-pr ibldpgmref ;
       *n Char(10);
       *n Char(74) const;
     end-pr;

     // --------------------------------------------------------------------- //
     dcl-pr iarpgdta ;
       *n Char(10);
       *n Char(74) const;
     end-pr;

     // --------------------------------------------------------------------- //
     dcl-pr iainit ;
       *n char(10);
       *n Char(74) const;
     end-pr;

     // --------------------------------------------------------------------- //
     dcl-pr iacldta ;
       *n Char(10);
       *n Char(74) const;
     end-pr;

     // --------------------------------------------------------------------- //
     dcl-pr iaddsdta ;
       *n Char(10);
       *n Char(74) const;
     end-pr;

     // --------------------------------------------------------------------- //
     dcl-pr IaRopt01 ;
       *n Char(10);
     end-pr;

     // --------------------------------------------------------------------- //
     dcl-pr IaRopt02;
       *n char(10);
     end-pr;

     // --------------------------------------------------------------------- //
     dcl-pr IaRopt03;
       *n char(10);
     end-pr;

     // --------------------------------------------------------------------- //
     dcl-pr IaRopt04;
       *n char(10);
     end-pr;

     // --------------------------------------------------------------------- //
     dcl-pr IaRopt05;
       *n char(10);
     end-pr;

     // --------------------------------------------------------------------- //
     dcl-pr IaRopt06;
       *n char(10);
     end-pr;

     // --------------------------------------------------------------------- //
     dcl-pr IaRopt07;
       *n char(10);
     end-pr;

     // --------------------------------------------------------------------- //
     dcl-pr IREPHSTLOG;
       *n char(10);
       *n char(20);
       *n char(50);
     end-pr;

     // --------------------------------------------------------------------- //
     dcl-pr IAPSRRPG EXTPGM;
       *n char(10);
       *n Char(74) const;
     end-pr;

     // --------------------------------------------------------------------- //
     dcl-pr IAPSRCL EXTPGM;
       *n char(10);
       *n Char(74) const;
     end-pr;

     // --------------------------------------------------------------------- //
     dcl-pr IAMENURVLD;
       *n char(10);
       *n char(1);
     end-pr;

     // --------------------------------------------------------------------- //
     dcl-pr IAPSRPH3 EXTPGM;
       *n char(10);
     end-pr;

     // --------------------------------------------------------------------- //
     dcl-pr IAVARIDR EXTPGM;
     end-pr;

     // --------------------------------------------------------------------- //
     dcl-pr IAVARTRKR EXTPGM;
     end-pr;

     dcl-pr IAVWUR EXTPGM;
       *n    char(30);
     end-pr;
     // --------------------------------------------------------------------- //
     dcl-pr IAFILEDTLR EXTPGM;
       *n    char(10);
     end-pr;
