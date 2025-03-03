**free
      //%METADATA                                                      *
      // %TEXT 01 IA Pseudocode generation service program             *
      //%EMETADATA                                                     *
//------------------------------------------------------------------------------------- //
//Created By   :  Programmers.io @ 2024                                                 //
//Created Date :  2024/01/01                                                            //
//Developer    :  Programmers.io                                                        //
//Description  :  Service Program to fetch the control data for Pseudocode              //
//                                                                                      //
//Procedure Log:                                                                        //
//------------------------------------------------------------------------------------- //
//Procedure Name           | Procedure Description                                      //
//-------------------------|----------------------------------------------------------- //
//xxx1                     | xxxx1234                                                   //
//                         |                                                            //
//------------------------------------------------------------------------------------- //
//                                                                                      //
//Modification Log:                                                                     //
//------------------------------------------------------------------------------------- //
//Date    | Mod_ID | Developer  | Case and Description                                  //
//--------|--------|------------|------------------------------------------------------ //
//29/04/24| 0003   | Khushi     | Increase in the length of variables to capture the    //
//        |        |            | keywords as long values were not fully captured.      //
//29/04/24| 0004   | Mahima     | DCL-PI Parsing for writing Pseudo code                //
//29/04/24| 0005   | Sarthak    | Long Name in Procedure in fixed format                //
//30/04/24| 0006   | Khushi     | Handling for invalid D spec sources(free format)      //
//03/05/24| 0007   | Prabhu S   | Add a blank line b/w   loop or condition statement    //
//07/05/24| 0008   | Khushi     | Task 621, change in the output for D spec &           //
//        |        |            | populating Glossary section                           //
//01/05/24| 0009   | Azhar      | TASK #619 - Handling for file operations with loop    //
//15/05/24| 0010   | Sarthak    | New Logic for Long Name in Procedure in fixed format  //
//15/05/24| 0011   | Sarthak    | New Output Structure for D spec in fixed format       //
//01/05/24| 0012   | Ruhi       | Task #642 Alignment issue for few lines of code.      //
//        |        |            | Indentation tag not applied                           //
//15/05/24| 0013   | Ruhi       | Task #627 Dow not %EOF not parsed properly            //
//28/05/24| 0014   | Khushi     | Task #650 Keyword details after the 109th position    //
//        |        |            | in the Pseudocode doc should come in the next line.   //
//02/06/24| 0015   | Ruhi       | Task #662 Pseudo code text for Eval/Assignment        //
//        |        |            | Task #662 Pseudo code for free format assignment      //
//        |        |            | without Eval opcode and to correctly map BIFs in      //
//        |        |            | assignment statements.
//28/05/24| 0016   | Sarthak    | Task #688 Eval statement to be simplified Fixed Format//
//        |        |            | Task #693 Eval(H) Handling Required in  Fixed Format  //
//16/05/24| 0017   | Manav T    | TASK #617 - Change IARequestStatusUpdate to update    //
//        |        |            |             IAFDWNDTLP instead of IAFDWNREQ           //
//31/05/24| 0018   | Khushi     | Task For 2 space indentation for variable/DS          //
//29/05/24| 0019   | Sarthak    | Task #687 and Task #674 Indentation Improvements      //
//31/05/24| 0020   | Ruhi       | Task #662 Eval statement to be simplified Free Format //
//        |        |            | Eval statement with arithmetic operators are handled  //
//        |        |            | Changed Var2 to EVar1 and Var3 to Evar2 for Eval      //
//        |        |            | statements across all fixed and free formats          //
//31/05/24| 0021   | Santosh    | Task #638 F and H spec changes                        //
//11/06/24| 0022   | Sarthak    | Task #717 Include the blank space after each start of //
//        |        |            | indentation in RPGLE and RPG4                         //
//        |        |            | Added some preventive check before SubString Operation//
//31/05/24| 0023   | Khushi     | Task #679 Const Dcl (Free format) should be printed.  //
//19/06/24| 0024   | Azhar Uddin| Task #728 1-Add comment after main logic ends, before //
//        |        |            |             a procedure starts & after a procedure end//
//        |        |            |           2-Give only one space between two tags.     //
//19/06/24| 0025   | Azhar Uddin| Task #733 - Included the handling to write only 109   //
//        |        |            |             characters at a time.                     //
//04/06/24| 0026   | Ruhi       | Task #696 Enhancement in procedure Calling Name       //
//        |        |            | and parameters in Free and Fixed format               //
//10/06/24| 0027   | Sarthak    | Task #697 While Calling Subroutine and Procedure the  //
//        |        |            | Name should populate in Capital Letters               //
//28/06/24| 0028   | Azhar Uddin| Task #677 - Included the handling to retrieve the     //
//        |        |            |             mapping data from DS instead of file.     //
//        |        |            | Task #743 - Fixed the issue by retrieving the data    //
//        |        |            |             from DS considering both key1 & key2.     //
//        |        |            | Task #751 - Included the handling to print the start  //
//        |        |            |             of main logic & allow only one blank line //
//        |        |            |             b/w two lines.                            //
//03/07/24| 0029   | Azhar Uddin| Task #756 (Point #1) - Included the handling to print //
//        |        |            |             multiple lines before start of main logic //
//        |        |            | Task #756 (Point #6) - Included the handling to give  //
//        |        |            |             blank line before/after indentation       //
//        |        |            |             starts/ends                               //
//        |        |            | Task #756 (Point #9) - Included the handling to remove//
//        |        |            |             brackets if object description not found  //
//        |        |            | Fixed issue of retaining correct data in variable     //
//        |        |            |             wkLastWrittenData                         //
//21/06/24| 0030   | Rishab K   | Task #736 Decimal data error during SQL error logging //
//        |        |            | as NbrParms parameter having junk value.              //
//03/07/24| 0031   | Ruhi       | Task #757  PseudoCode Enhancements - Indentation      //
//        |        |            | to be added for comment statements for fixed and      //
//        |        |            | free RPGLE sources                                    //
//26/06/24| 0032   | Yogendra   | Task #702 Process Nested Built in Function Parsing    //
//09/07/24| 0033   | Munumonika | BIF - handling required if ';' found in BIF #776      //
//12/07/24| 0034   | Santosh    | Pseudo code : Fix format F spec issue #786            //
//15/07/24| 0035   | Shefali    | Pseudo code : Fix program dump issue #784             //
//17/07/24| 0036   | Ruhi       | Task #781 : Indentation issue in Nested Built         //
//        |        |            | in function processing in pseudocode                  //
//17/07/24| 0037   | Ruhi       | Task #746 While declaring Procedure interface/        //
//        |        |            | prototype/Procedure definition, the procedure         //
//        |        |            | Name should populate in Capital Letters               //
//05/07/24| 0038   | Azhar Uddin| Task #756 (Point #1) - Fix - For null capable fields  //
//        |        |            |             use COALESCE to avoid warning.            //
//        |        |            | Task #756 (Point #6) - Fix - Handle the case of       //
//        |        |            |             multiline first/last statement for begin  //
//        |        |            |             & ending text of main logic.              //
//        |        |            | Task #756 (Point #9) - Fix - Don't consider SQLCODE>0 //
//        |        |            |             as an exception.                          //
//        |        |            | Task #752 & - Handling of printing branches with ind- //
//        |        |            | Task #753   entation for Select/When, If/Elseif/Else ///
//        |        |            |             and CASxx blocks.                         //
//        |        |            |             Handling of printing --Do Nothing -- in   //
//        |        |            |             a loop/condition if no executable code is //
//        |        |            |             found inside it.                          //
//12/07/24| 0039   | Gokul R    | Task #785 - Modified the program to increase the Mode //
//        |        |            | size from 6 to 8 to accommodate the Delete Mode in    //
//        |        |            | File declaration                                      //
//12/07/24| 0040   | Munumonika | BIF, New BIF Changes should escape the changes for    //
//        |        |            | Built-in functions related to file. #780              //
//23/07/24| 0041   | Shefali    | Task #714 Procedure name should be written when CALL  //
//        |        |            |             keyword is not present.                   //
//08/07/24| 0042   | Azhar Uddin| Task #756 (Point #5) - When clearing variable check   //
//        |        |            |             if it's a record format of file(table) or //
//        |        |            |             a display file, write correspoinding      //
//        |        |            |             pseudo code as per checking               //
//        |        |            | Task #767 - Update the handling in writepseudocode    //
//        |        |            |              following the review comments.           //
//        |        |            |              Use procedure instead of subroutine for  //
//        |        |            |              GetMapping                               //
//24/06/24| 0043   | Azhar Uddin| Task #734- Introduce handling to print different type //
//        |        |            |            of non-RPG names for logical files.        //
//22/07/24| 0044   | Gokul R    | Task #801 - Populate the new column "Font Code" of    //
//        |        |            | IAPSEUDOCP table with 'B' in 1st position to indicate //
//        |        |            | the Tag which needs to be printed with Bold Font      //
//31/07/24| 0045   | Gokul R    | Task #785 - Increased the FileMode Size to 8 and      //
//        |        |            | decreased the FileKey Size to 4 to align the File     //
//        |        |            | declaration Mode properly and blank out the FileKey   //
//        |        |            | when there is no key                                  //
//24/08/02| 0046   | Munumonika | Populating the glossary section for Rpg3 pseudo code  //
//        |        |            | Initialized DS:  Task-837                             //
//19/07/24| 0047   | Munumonika | Pseudo code : Nested BIF implementation for FIX       //
//        |        |            | format sources. #783                                  //
//19/07/24| 0048   | Munumonika | To handle the pseudo-code parsing for built-in        //
//        |        |            | functions without bracket like %error, %status #809   //
//30/07/24| 0049   | Munumonika | Pseudo Code BIF: Remove unwanted brackets from        //
//        |        |            | statement #820                                        //
//07/08/24| 0050   | Azhar Uddin| Task #756(Point #4)- Modified to show the file name,  //
//        |        |            | variable names and keywords in capital letters.       //
//        |        |            | Fix - Removed tag 0027 changes as those changes not   //
//        |        |            |       required anymore.                               //
//08/08/24| 0051   | Azhar Uddin| Task #756(Point #4)- Modified to use end position for //
//        |        |            | DCLTYPE in free format as semicolon position if no    //
//        |        |            | non blank characters are present after end position.  //
//13/08/24| 0052   | Shefali    | Task #798 : Enhance code to handle source mapping for //
//                 |            | arithmetic operations when factor 1 is not given      //
//01/08/24| 0053   | Azhar Uddin| Task #739 - Modify to write a comment in case there   //
//        |        |            |             is no executable code inside a loop or    //
//        |        |            |             condition or procedure or subroutine.     //
//21/08/24| 0054   | Gokul R    | Task #705 - Populate length for DS subfields.         //
//25/07/24| 0055   | Manju      | Task #803 Added logic to Print PipeSymbol line along  //
//        |        |            |           with the nested lines and indentation in    //
//        |        |            |           generated pseudo code.                      //
//        |        |            |           Added Logic to Remove Repeated line with    //
//        |        |            |           Only simliar PipeSymbol                     //
//        |        |            |           Added Logic to Handle Pipe in Comment line  //
//        |        |            |           and Start of Tag line                       //
//        |        | Azhar Uddin|           Added NewDS OutParmWriteSrcDocWDS and Logic //
//        |        |            |           to Handle Ouput Parm to Write               //
//        |        |            |           Free and Fixed format Output Data           //
//02/08/24| 0056   | Manju      | Task #827 Added logic to Print PipeSymbol line along  //
//        |        |            |           with the nested lines and indentation in    //
//        |        |            |           generated pseudo code for Compiler Directive//
//02/08/24| 0057   | Manju      | Task #839 Added logic to Insert Blank line if any     //
//        |        |            |           Other Spec called right before C-Spec       //
//07/08/24| 0058   | Manju      | Task #844 Handled D Spec - Constant to Apply Indent   //
//        |        |            |           Inside Procedure in Free format             //
//09/08/24| 0059   | Manju      | Task #845 Handled D spec Header display issue         //
//        |        |            |           Inside Procedure                            //
//09/08/24| 0060   | Manju      | Task #851 Added Logic to Increment Indent to display  //
//        |        |            |           PipeSymbol from second split line of Tag    //
//17/07/24| 0061   |Azhar Uddin | Task #771 : In case indicators are used with READ/CHAI//
//        |        |            | -N/SETLL operation, identify the next statements if   //
//        |        |            | executed based on these indicators, If so add         //
//        |        |            | statement "If record found"/"If record not found" in  //
//        |        |            | pseudo code                                           //
//05/08/02| 0062   |Azhar Uddin | Task #830 - For file record format operations like    //
//        |        |            |             write/update/delete etc. check the file   //
//        |        |            |             type and show appropriate pseudo code     //
//24/08/27| 0063   |Mahima T    | Task #888 - PREFIX keyword value was missing in Fix   //
//        |        |            | format F spec                                         //
//24/08/27| 0064   | Gokul R    | Task #887 Modified the existing logic to display the  //
//        |        |            |           data type for Data Structure Subfields and  //
//        |        |            |           Change "Lesser Than" to "Less Than"         //
//24/08/26| 0065   | Manju      | Task #879 Added Logic to append PipeSymbol Between    //
//        |        |            |           All Nested Tagged line in RPG3              //
//24/08/26| 0066   | Himanshu   | Increasing length of variables holding string function//
//        |        |            | result values or array indexes.                       //
//20/08/24| 0067   | SriniG     | Task #857 : For eval statment showing Procedure and   //
//        |        |            | Parameter when using parenthesis                      //
//24/09/06| 0068   | Manju      | Task #918 Created New Procedure WriteIaPseudowk       //
//        |        |            |           to Write Pseudo in Work File for RPG3.      //
//        |        |            |           Added Logic to Handle RPG3 Copybook         //
//        |        |            |           to Write Pseudo in Work File or IAPSEUDOCP  //
//        |        |            |           for both Header and Its Parser Pseudo.      //
//        |        |            |           Calculated and Appended- PipeIndent as well //
//17/07/24| 0069   | Manasa     |Following tasks are done on TASK# 789                  //
//        |        |            | 1. DS with no name should be printed with *NONAME in  //
//        |        |            |    pseudocode DS/Subfields section                    //
//        |        | SriniG     | 2. PSDS with no name must be printed with PSDS in     //
//        |        |            |    pseudocode DS/Subfields section                    //
//        |        | SriniG     | 3  When DS Declared with DCL-SUBF Variable Name,      //
//        |        |            |    Length and Position should be parsed correct values//
//20/09/24| 0070   | Azhar Uddin| Task #956-Added logic to parse and write the pseudo-  //
//        |        |            |           code for I spec source code.                //
//        |        |            | Task #854-Replaced %upper with %Xlate                 //
//03/09/24| 0071   | Azhar Uddin| Task #802 Added Logic to add one blank line after     //
//        |        |            |           printing pseudo-code for TAG opcode         //
//19/09/24| 0072   | Shefali    | Task:957 - Fix code to print blank lines appropriately//
//        |        |            |      before start of group and after end of group     //
//16/09/24| 0073   | Azhar Uddin| Task:938 - Initialize wkPrevDclType in K spec         //
//        |        |            | so that header can be printer correct for D spec.     //
//09/11/24| 0074   | Azhar Uddin| Task #689 : Added new procedure WriteCommentedText    //
//        |        |            |             to write the input commented text to o/p  //
//24/09/24| 0075   | Manju      | Task #959 : Added Logic to handle Conditional         //
//        |        |            | Indicator for any Opcode on RPG4 Fixed format Cspec   //
//24/09/16| 0076   | Manju      | Task #921 : Improved Text for SETON and SETOFF Opcode //
//24/09/17| 0077   | Gokul R    | Task #939: Modified Logic to skip Blank line inbetween//
//        |        |            |            the IF conditions for RPG-4 Fixed format   //
//18/09/24| 0078   | Shefali    | Task #877 Corrected logic to print header for file    //
//        |        |            |           declarations of all types                   //
//07/08/24| 0079   | Munumonika | Task #846: Pseudo Code BIF: Commented source line in  //
//        |        |            | BIF pseudocode for fixed format should come same      //
//        |        |            | as Free format                                        //
//21/10/24| 0080   | Mahima T   | Task #1019: Indentation issue in Comment and its      //
//        |        |            |             single BIF processing in pseudocode       //
//09/08/24| 0081   | Azhar Uddin| Task #850 - Consider printing header for every DS,PR  //
//        |        |            |             and PI declaration.                       //
//17/10/24| 0082   | Manju      | Task:1011- Fix Var1 value picking from source data    //
//        |        |            | in free format.Trim &OFFILE for fixed and free format //
//        |        |            |           PipeSymbol from second split line of Tag    //
//28/08/24| 0083   | Shefali    | Task #891 Enhanced Logic to print parameters in       //
//        |        |            |           single line for program calls for fixed     //
//        |        |            |           format RPG code                             //
//24/10/24| 0084   | Manju      | Task #1049 : 1.Fix made for check File Operation with //
//        |        |            | *IN in ExtFactor2 and Perform '1' instead all other.  //
//        |        |            | 2.Fixed SETLL FileOperationInd DS for correct         //
//        |        |            |   Value and Lookup                                    //
//        |        |            | 3.Fixed to determine CondIndicator Pseudo N01 only    //
//        |        |            |   when not a FileOperation ResultingIndicator         //
//11/08/24| 0085   | Gokul R    | Task #832 - Opcode is considered as Procedure or      //
//        |        |            | Program call                                          //
//30/09/24| 0086   | SriniG     | Following tasks are done on TASK# 968                 //
//        |        |            | 1. DIM value should be displayed in correct position  //
//        |        |            |    in Mixed format pseudocode generation.             //
//        |        |            | 2. Pseudocode not geenrated correctly when %EOF       //
//        |        |            |    assigned to Indicator in Mixed format              //
//08/10/24| 0087   | SriniG     | Task# 975 - Hndling Data Area operations in RPG       //
//08/10/24| 0088   | SriniG     | Task# 976 - Long string assignemnt not parsging       //
//        |        |            |             correctly in pseudocode                   //
//17/10/24| 0089   | SriniG     | Task #840 : In RPGLE fixed format Procedure Name and  //
//        |        |            | Parameters except Constant string should be in capital//
//24/09/24| 0090   | SriniG     | Task# 882 Pseudo code : ON-ERROR handling. When       //
//        |        |            | nothing specified on ON-ERROR it should not be printed//
//        |        |            | and print Monitor block only.                         //
//01/10/24| 0091   | Shefali    | Task #970 Enhanced logic to print new format of Fspec //
//        |        |            |           for logical files based on user input       //
//23/10/24| 0092   | Manju      | Task #1026 : Fix made for Callp with BIF parameter    //
//        |        |            |   to convert properly for Fixed format RPGLE          //
//22/10/24| 0093   | Shefali    | Task #1025 Corrected logic to retrieve BIF when BIF   //
//        |        |            |            parameters contain brackets                //
//03/09/24| 0094   | Mahima T   | Task #725: Enhancements in generated output for SQL   //
//        |        |            |     also fixed issue character was incorrectly coming //
//29/10/24| 0095   | Shefali    | Task #1051 Enhanced Logic to handle numeric fields    //
//        |        |            |            when they can have junk data and stop      //
//        |        |            |            adding decimal data error to joblog        //
//26/07/24| 0096   | Khushi     | Task #699 - Print the Pseudocode for the built-in     //
//        |        |            | functions specified in Constant declaration           //
//29/11/24| 0097   | Azhar Uddin|Task #815- Modified to add new field of pipe indent    //
//        |        |            |           & tag indicator in indentation data DS      //
//        |        |            |           and fix to correct write D spec data for    //
//        |        |            |           FX3 type sources.                           //
//13/08/24| 0098   | Shefali    | Task #829 : Enhance code to handle source mapping for //
//                 |            | date/time keywords when all 3 factors are present     //
//01/10/24| 0099   | Manju      | Task #1008-Resulting indicators based on file IOs.    //
//        |        |            |                                                       //
//05/08/24| 0100   | Shefali    | Task #831 Enhance code to generate pseudo code for    //
//        |        |            | code containing arithmetic operations with brackets   //
//        |        |            | in the expression                                     //
//15/01/25| 0101   | Khushi     | Task #706-Handle length defined using BIFs in D spec  //
//        |        |            | fully free format                                     //
//------------------------------------------------------------------------------------- //
Ctl-Opt Copyright('Programmers.io Â© 2024 | Created Nov 2024');
Ctl-Opt Option(*noDebugIo: *srcStmt: *noUnRef) expropts(*RESDECPOS) debug;
Ctl-Opt Nomain;
Ctl-Opt BndDir('IABNDDIR' : 'IAERRBND');

//------------------------------------------------------------------------------------- //
//Copybook Definitions
//------------------------------------------------------------------------------------- //
/copy 'QMODSRC/iapcod01pr.rpgleinc'
/copy 'QMODSRC/iasrv01pr.rpgleinc'
/copy 'QMODSRC/iasrv02pr.rpgleinc'
/copy 'QCPYSRC/rpgivds.rpgleinc'
/copy 'QCPYSRC/rpgiiids.rpgleinc'
/copy 'QCPYSRC/iaderrlog.rpgleinc'

//------------------------------------------------------------------------------------- //
//Constant Variables
//------------------------------------------------------------------------------------- //
Dcl-C SQL_ALL_OK         '00000';
Dcl-C True               '1';
Dcl-C False              '0';
Dcl-C cwUP               'ABCDEFGHIJKLMNOPQRSTUVWXYZ';                                   //0094
Dcl-C cwLO               'abcdefghijklmnopqrstuvwxyz';
Dcl-C cwSrcLength        4046;
Dcl-C cwAddCheck         Const('ADDCHK');
Dcl-C cwAdd              Const('ADD');
Dcl-C cwRemove           Const('REMOVE');
Dcl-C cwRemoveCheck      Const('REMOVECHK');
Dcl-C cwBranch           Const('BRANCH');                                                //0038
Dcl-C cwNewBranch        Const('NEWBRANCH');                                             //0038
Dcl-C cwCase             Const('CASE');                                                  //0038
Dcl-C cwSplitCharacter   Const('~&|.');                                                  //0038
Dcl-C cwDoNothing        Const('-- Do Nothing --');                                      //0038
Dcl-C cwPipeIndent       Const('|');                                                     //0055
Dcl-C cwFrDCLDS          Const('DCL-DS');
Dcl-C cwFrENDDS          Const('END-DS');
Dcl-C cwFrLKEDS          Const('LIKEDS');
Dcl-C cwFrLKRDS          Const('LIKEREC');
Dcl-C cwDSpecDSSub       Const('DCL-SUBF');
Dcl-C cwAto9
  Const('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789');
Dcl-C cw3               Const(3);                                                        //0019
Dcl-C cwBoldFont        Const('B');                                                      //0044
Dcl-C cwPsds            Const('PSDS');                                                   //0069
Dcl-C cwNoName          Const('*NONAME');                                                //0069
Dcl-C cwANDEQ           Const('ANDEQ');                                                  //0077
Dcl-C cwANDNE           Const('ANDNE');                                                  //0077
Dcl-C cwANDLT           Const('ANDLT');                                                  //0077
Dcl-C cwANDLE           Const('ANDLE');                                                  //0077
Dcl-C cwANDGT           Const('ANDGT');                                                  //0077
Dcl-C cwANDGE           Const('ANDGE');                                                  //0077
Dcl-C cwOREQ            Const('OREQ');                                                   //0077
Dcl-C cwORNE            Const('ORNE');                                                   //0077
Dcl-C cwORLT            Const('ORLT');                                                   //0077
Dcl-C cwORLE            Const('ORLE');                                                   //0077
Dcl-C cwORGT            Const('ORGT');                                                   //0077
Dcl-C cwORGE            Const('ORGE');                                                   //0077
Dcl-C cwQuote           Const('''');                                                     //0085
Dcl-C cwColon           Const(':');                                                      //0085
Dcl-C cwDIM             Const('DIM');                                                    //0086
Dcl-C cwCTDAT           Const('CTDATA');                                                 //0086
Dcl-C cwDigits          Const('0123456789');                                             //0095
                                                                                         //0091
Dcl-C cwNewFormat       Const('LFSPECFORMAT') ;                                          //0091
Dcl-C cwStoreData       Const('S') ;                                                     //0091
Dcl-C cwWriteData       Const('W') ;                                                     //0091

Dcl-S IOIndentParmPointer  Pointer            Inz;
Dcl-S wkPrevDclType        Char(10);
Dcl-S wkPrevIndentType     Char(10);                                                     //0024
Dcl-S wkDoNothingComment   Char(109);                                                    //0053
Dcl-S wkIfRecordFound      Char(16) Inz;                                                 //0061
Dcl-S wkIfRecordNotFound   Char(20) Inz;                                                 //0061
Dcl-S wkRecordFound        Char(12) Inz;                                                 //0061
Dcl-S wkRecordNotFound     Char(16) Inz;                                                 //0061
Dcl-S wkEndMainLogicCmnt   VarChar(200)       Inz;                                       //0024
Dcl-S constDclInd          Ind                Inz(*off);                                 //0023
Dcl-S wkLstRrnForMainLogic Packed(6:0)        Inz;                                       //0024
Dcl-S wkBgnRrnForMainLogic Packed(6:0)        Inz;                                       //0028
Dcl-S wkMapIdx             Packed(4:0)        Inz;                                       //0028
Dcl-S wkiAPseudoMpCount    Packed(4:0)        Inz;                                       //0028
Dcl-S wkPseudoNext         VarChar(cwSrcLength) Inz;                                     //0026
Dcl-S wkLastWrittenData    VarChar(cwSrcLength) Inz;                                     //0028
Dcl-S wKNoParm             Ind                     ;                                     //0026
Dcl-S wkMappingFoundInd    Ind                Inz;                                       //0028
Dcl-S wkCountOfLineProcessAfterIndentation Packed(6:0) Inz;                              //0038
Dcl-S wkPseudocodeFontBkp  VarChar(cwSrcLength) Inz;                                     //0044
Dcl-S wkFontCode           Char(4)              Inz;                                     //0044
Dcl-S wkPrvIndentLevel     Packed(5:0) ;                                                 //0047
Dcl-S wkDToLength          Packed(7:0)        Inz;                                       //0054
Dcl-S wkDFromLength        Packed(7:0)        Inz;                                       //0054
Dcl-S wkPipeIndentSave     Char(cwSrcLength)  Inz;                                       //0055
Dcl-S wkPipeTagInd         Ind                Inz(*off);                                 //0055
Dcl-S wkCspecBlankInd      Ind                Inz(*off);                                 //0057
Dcl-S wkFX3PipeIndentSave  Char(cwSrcLength)  Inz;                                       //0068
Dcl-S wkTempN01Mapping     Char(cwSrcLength) ;                                           //0075
Dcl-S wkCallwithMultParm   Ind                Inz(*off) ;                                //0083
Dcl-S wkSavPos             Packed(5:0)        Inz ;                                      //0083
Dcl-S wkCounter            Packed(4:0)        Inz ;                                      //0083
Dcl-S wkSaveBgnRrn         Packed(6:0)        Inz;                                       //0083
Dcl-S wkSaveLstRrn         Packed(6:0)        Inz;                                       //0083
Dcl-S wkEntryParm          Char(1)            Inz('N') ;                                 //0083
Dcl-S wkEntryCounter       Packed(3:0)        Inz ;                                      //0083
Dcl-S wkFileConfigFlag     Char(12)           Inz ;                                      //0091
Dcl-S wkFileDtlCntr        Packed(2:0)        Inz ;                                      //0091
Dcl-S bifSourcePointer     Pointer            Inz;                                       //0096

Dcl-S OrderSeqn            Packed(3:0)        Inz ;                                      //0100
Dcl-S MstOrdSeq            Packed(2:0)        Inz ;                                      //0100
Dcl-S PseudoCodeSeq        Packed(3:0)        Inz ;                                      //0100
//------------------------------------------------------------------------------------- //
//Data Structure Definitions                                                            //
//------------------------------------------------------------------------------------- //

Dcl-Ds wkIndentParmDS  Qualified inz;
   dsIndentType        Char(10);
   dsIndentLevel       Packed(5:0);
   dsPseudocode        Char(cwSrcLength);
   dsMaxLevel          Packed(5:0);
   dsIncrLevel         Packed(5:0);
   dsIndentArray       Packed(5:0) Dim(999);
End-Ds;

Dcl-Ds FSpecMappingDs Qualified Dim(100) ;
   dsKeywrdOpcodeName Char(10);
   dsActionType       Char(10);
   dsSrcMapping       Varchar(200);
End-Ds ;

Dcl-Ds DSpecMappingDs Qualified Dim(100) ;
   dsKeywrdOpcodeName Char(10);
   dsActionType       Char(10);
   dsSrcMapping       Varchar(200);
End-Ds ;
                                                                                         //0052
Dcl-Ds CSrcSpecMappingDs LikeDS(TSpecMappingDs) Dim(100) ;                               //0052
Dcl-Ds CSrcSpecMappingDswKey LikeDS(TSpecMappingDswKey) Dim(100) ;                       //0083

Dcl-Ds SpecHeaderDS Qualified ;
   dsReqId        Char(18);
   dsSrcLib       Char(10);
   dsSrcPf        Char(10);
   dsSrcMbr       Char(10);
   dsSrcType      Char(10);
   dsSrcSpec      Char(1);
   dsKeyfld       Char(10);
End-Ds;

//Datastructure to hold the F-Spec Pseudocode Data
Dcl-Ds dsFSpecPseudocode Qualified;
   dsFSpec     Char(200);
   dsName      Char(11)   Overlay(dsFSpec) ;
   dsDeLimit1  Char(2)    Overlay(dsFSpec:*Next);
   dsMode      Char(8)    Overlay(dsFSpec:*Next);                                        //0039
   dsDeLimit2  Char(2)    Overlay(dsFSpec:*Next);
   dsKeyed     Char(4)    Overlay(dsFSpec:*Next);                                        //0039
   dsDeLimit3  Char(2)    Overlay(dsFSpec:*Next);
   dsRcdFmt    Char(24)   Overlay(dsFSpec:*Next);
   dsDeLimit4  Char(2)    Overlay(dsFSpec:*Next);
   dsDevice    Char(11)   Overlay(dsFSpec:*Next);
   dsDeLimit5  Char(2)    Overlay(dsFSpec:*Next);
   dsKeyword   Char(100)  Overlay(dsFSpec:*Next);

End-Ds;

//Data Structure to Holds Data Types
Dcl-Ds wkFxDataTypeDs  Qualified Dim(20);
   dsDataType     Char(15);
   dsDataTypeDesc Char(30);
End-Ds;

Dcl-Ds outPseudoCodeDs Qualified;                                                        //0014
   outDclPseudoCode  Char(200);                                                          //0014
   outBlnkPseudoCode Char(200);                                                          //0014
   outKeywords       Char(200) Dim(15);                                                  //0014
End-Ds;                                                                                  //0014

Dcl-Ds wkBgnMainLogicCmnt Qualified Dim(5);                                              //0029
   wkiASrcMap      Char(200);                                                            //0029
End-Ds;                                                                                  //0029

Dcl-Ds RPGIndentParmDs LikeDS(RPGIndentParmDsTmp) Based(IOIndentParmPointer);            //0038
//DS to save file names which are declared in F spec to check later in C spec if a var   //0042
//which is getting cleared is a record format for one of the file declared in F spec.    //0042
Dcl-Ds DsDeclaredFileRecordFormats Qualified Inz;                                        //0042
   RecordFormatName Char(10) Dim(999);                                                   //0042
   FileType         Char(10) Dim(999);                                                   //0042
   FileName         Char(10) Dim(999);                                                   //0042
   PFName           Char(10) Dim(999);                                                   //0062
   Count            Packed(4:0);                                                         //0042
End-Ds;                                                                                  //0042
//Data structure to hold the indicators related to file i/o
Dcl-Ds dsFileOperationInd Qualified;                                                     //0061
   RcdNotFound     Char(3) Dim(999);                                                     //0061
   RcdFound        Char(3) Dim(999);                                                     //0061
   FileName        Char(10) Dim(999);                                                    //0061
   ResultInd       Char(2)  Dim(999);                                                    //0099
   RIOpcode        Char(10) Dim(999);                                                    //0099
   Count           Packed(4:0);                                                          //0061
End-Ds;                                                                                  //0061

//DS to save the keywords related to files I/O operations                                //0062
Dcl-Ds DsFileRelatedOpCodes Qualified Inz;                                               //0062
   OpCode           Char(10) Dim(99);                                                    //0062
   Count            Packed(2:0);                                                         //0062
End-Ds;                                                                                  //0062
                                                                                         //0083
Dcl-Ds wkCallPseudoCode    likeDS(TCallPseudoCode)    Dim(100)                           //0083
                           Inz(*likeDS) ;                                                //0083
Dcl-Ds wkEntryPseudoCode   likeDS(TCallPseudoCode)    Dim(30)                            //0083
                           Inz(*likeDS) ;                                                //0083

                                                                                         //0091
//Data Structures to hold file level information from DSPFD                              //0091
Dcl-Ds dsSelectOmit        likeDS(TdsSelectOmit)      Dim(99)                            //0091
                           Inz(*likeDS) ;                                                //0091
Dcl-Ds dsKeyField          likeDS(TdsKeyField)        Dim(99)                            //0091
                           Inz(*likeDS) ;                                                //0091
Dcl-Ds dsFileFormat        likeDS(TdsFileFormat)      Dim(99)                            //0091
                           Inz(*likeDS) ;                                                //0091
                                                                                         //0100
//DS array to hold pseudocode for sub expressions                                        //0100
Dcl-DS PseudoCodeArray Qualified Dim(100) Inz ;                                          //0100
   OrderSeq       Packed(3:0) ;                                                          //0100
   PseudoCode     Char(4046) ;                                                           //0100
End-DS ;                                                                                 //0100
//------------------------------------------------------------------------------------- //
//Prototype Definitions
//------------------------------------------------------------------------------------- //
Dcl-Pr QcmdExc Extpgm('QCMDEXC');
   *n Char(500)     Options(*Varsize) Const;
   *n Packed(15:5)  Const;
   *n Char(3)       Options(*Nopass) Const;
End-Pr;
Dcl-S  wkSrcMap VarChar(cwSrcLength);
Dcl-S  wkSrcMap1 VarChar(cwSrcLength);                                                   //0067
Dcl-S  wkDocSeq Packed(6:0)  Inz;
Dcl-S  wkBeginProc Char(1);                                                              //0004
Dcl-S  wkCntFlag Char(1)     Inz;

//------------------------------------------------------------------------------------- //
//Main Logic
//------------------------------------------------------------------------------------- //
Exec Sql
   Set Option Commit = *None,
              Naming = *Sys,
              UsrPrf = *User,
              DynUsrPrf = *User,
              CloSqlCsr = *Endmod,
              SrtSeq = *Langidshr;

//------------------------------------------------------------------------------------- //
//Procedure to Write Header for Source Documentation                                    //
//------------------------------------------------------------------------------------- //
Dcl-Proc WriteHeader Export;

   Dcl-Pi *N;
      inParmPointer Pointer;
   End-Pi;

   Dcl-Ds wkInPutParmDS Qualified Based(inParmPointer);
      inReqId            Char(18);
      inSrcLib           Char(10);
      inSrcPf            Char(10);
      inSrcMbr           Char(10);
      inSrcType          Char(10);
   End-Ds;

   Dcl-S wkSrcLinType    Char(50);
   Dcl-S oObjDesc        Char(50)    Inz;
   Dcl-S wkKeyFld1       Char(10)    Inz;
   Dcl-S outParmPointer  Pointer     Inz;
   Dcl-S wkFormatString  VarChar(50) Inz;

   Dcl-C cwSrcDocHdr     Const('HEADER');

   //Copybook declaration
/copy 'QCPYSRC/iaprderlog.rpgleinc'
   wkuDpsds.nbrparms = %parms;                                                           //0030
   EvaluatePSDS() ;                                                                      //0030

   wkDocSeq = 0;
   Clear wkPrevDclType;
   wkCallwithMultParm = *Off ;                                                           //0083
   Clear wkCallPseudoCode ;                                                              //0083
   Clear wkEntryPseudoCode ;                                                             //0083
   Clear wkCounter ;                                                                     //0083
   Clear wkSavPos ;                                                                      //0083
   wkEntryParm = 'N' ;                                                                   //0083
   wkEntryCounter = *Zeros ;                                                             //0083

   Clear OutParmWriteSrcDocDS ;
   OutParmWriteSrcDocDS.dsReqId   =  wkInPutParmDS.inReqId;
   OutParmWriteSrcDocDS.dsSrcLib  =  wkInPutParmDS.inSrcLib;
   OutParmWriteSrcDocDS.dsSrcPf   =  wkInPutParmDS.inSrcPf;
   OutParmWriteSrcDocDS.dsSrcMbr  =  wkInPutParmDS.inSrcMbr;
   OutParmWriteSrcDocDS.dssrcType =  wkInPutParmDS.inSrcType;

   Exec Sql
      Select Listagg(Distinct (Srclin_Type))
             Into :wkSrcLinType
             From IaQrpgSrc
             Where Member_Name = :OutParmWriteSrcDocDS.dsSrcMbr;

   Select;
     When %Scan('FFR':wkSrcLinType:1) <> *Zeros;
       wkFormatString = 'FREE FORMAT';

     When %Scan('FX3':wkSrcLinType:1) <> *Zeros  Or                                      //0021
          %Scan('FX3C':wkSrcLinType:1) <> *Zeros;                                        //0021
       wkFormatString = 'FIXED FORMAT';                                                  //0021
                                                                                         //0021
     When %Scan('FX4':wkSrcLinType:1) <> *Zeros  And
          %Scan('FFC':wkSrcLinType:1) = *Zeros;
       wkFormatString = 'FIXED FORMAT';

     When %Scan('FFC':wkSrcLinType:1) <> *Zeros  And
          %Scan('FX4':wkSrcLinType:1) <> *Zeros;
       wkFormatString = 'MIXED(FIXED/FREE) FORMAT';

     When %Scan('FFC':wkSrcLinType:1) <> *Zeros  And
          %Scan('FX4':wkSrcLinType:1) = *Zeros;
       wkFormatString = 'FREE FORMAT';
   EndSl;

   Exec Sql
      Declare HdrStmt Cursor For
         Select  Src_Mapping,
                 KeyField_1
            From IaPseudoMP
            Where SrcMbr_Type = :cwsrcDocHdr
            Order By Seq_No
            For Fetch Only;

   Exec Sql Open HdrStmt;
   If SqlCode = CSR_OPN_COD;
      Exec Sql Close HdrStmt;
      Exec Sql Open  HdrStmt;
   EndIf;

   If SqlCode < successCode;
      uDpsds.wkQuery_Name = 'Open_hdrStmt';
      IaSqlDiagnostic(uDpsds);
   EndIf;

   Dow SqlCode = SuccessCode;

      //Get the template from source mapping file
      Exec Sql Fetch HdrStmt Into :wkSrcMap, :wkKeyFld1;
      If SqlCode < successCode;
         uDpsds.wkQuery_Name = 'Fetch_hdrStmt';
         IaSqlDiagnostic(uDpsds);
         Leave;
      ElseIf SqlCode = No_Data_Found;
         Leave;
      EndIf;

      //Write the Header of PseudoCode Generation
      //Program, Library, Source File, Member Type, Description, Format, Date
      Select;
         When wkKeyFld1 = 'MBRNAME';
            wkSrcMap = %Trim(wkSrcMap) + ' ' + %Trim(OutParmWriteSrcDocDS.dsSrcMbr);

         When wkKeyFld1 = 'LIBSPF';
            wkSrcMap = %Trim(wkSrcMap) + ' ' + %Trim(OutParmWriteSrcDocDS.dsSrcLib) +
                       '/' + %Trim(OutParmWriteSrcDocDS .dsSrcPf) ;

         When wkKeyFld1 = 'MBRTYPE';
            wkSrcMap = %Trim(wkSrcMap) + ' ' + %Trim(OutParmWriteSrcDocDS.dssrcType) ;

         When wkKeyfld1 = 'MBRDESC';
            If GetObjectDesc(OutParmWriteSrcDocDS.dsSrcMbr
                            :oObjDesc
                            :OutParmWriteSrcDocDS.dsSrcLib
                            :OutParmWriteSrcDocDS.dsSrcPf
                            :OutParmWriteSrcDocDS.dssrcType  );
               wkSrcMap = %Trim(wkSrcMap) + ' ' + %Trim(oObjDesc);
            Else;
               wkSrcMap = %Trim(wkSrcMap);
            EndIf;

         When wkKeyfld1 = 'FORMAT';
            wkSrcMap = %Trim(wkSrcMap) + ' ' + wkFormatString ;

         When wkKeyfld1 = 'DATEGEN';
            wkSrcMap = %Trim(wkSrcMap) + ' ' +  %Char(%Date());
      EndSl;

      OutParmWriteSrcDocDS.dsPseudoCode = wkSrcMap;
      outParmPointer = %Addr(OutParmWriteSrcDocDS);
      WritePseudoCode(outParmPointer);

   EndDo;
                                                                                         //0091
   //Get Config flag from IABCKCNFG file                                                 //0091
   Exec SQL                                                                              //0091
      Select KEY_VALUE1                                                                  //0091
      Into :wkFileConfigFlag                                                             //0091
      From IABCKCNFG                                                                     //0091
      Where KEY_NAME1 = 'FSPECFORMAT' ;                                                  //0091

/copy 'QCPYSRC/iaprcerlog.rpgleinc'

End-Proc;

//------------------------------------------------------------------------------------- //
//Procedure to write input spec header in IAPSEUDOCP                                    //
//------------------------------------------------------------------------------------- //
Dcl-Proc IaWriteSpecHeader Export;

   Dcl-Pi IaWriteSpecHeader;
      inParmPointer Pointer;
      inFileType    Char(1) Options(*NoPass) Const;                                      //0068
   End-Pi;

   Dcl-Ds wkInPutParmDs Based(inParmPointer);
      inReqId        Char(18);
      inSrcLib       Char(10);
      inSrcPf        Char(10);
      inSrcMbr       Char(10);
      inSrcType      Char(10);
      inSrcSpec      Char(1);
      inKeyFld       Char(10);
   End-Ds;

   Dcl-S OutParmPointer  Pointer Inz;
   Dcl-s wkPseudoCode    Char(4046);                                                     //0004
   Dcl-s wkPseudoDocSeq  Packed(6:0) Inz;                                                //0068
   Dcl-S wkFX3Pipelength Zoned(4:0) Inz;                                                 //0068
   Dcl-S wkKeyField1     Char(10)   Inz ;                                                //0091

   Dcl-C cwHeader        Const('HEADER');

   //Copybook declaration
/copy 'QCPYSRC/iaprderlog.rpgleinc'
   wkuDpsds.nbrparms = %parms;                                                           //0030
   EvaluatePSDS() ;                                                                      //0030

   Clear writePseudoCodeDs;
   writePseudoCodeDs.reqId   = inReqId;
   writePseudoCodeDs.srcLib  = inSrcLib;
   writePseudoCodeDs.srcPf   = inSrcPf;
   writePseudoCodeDs.srcMbr  = inSrcMbr;
   writePseudoCodeDs.srcType = inSrcType;
   writePseudoCodeDs.srcSpec = inSrcSpec;

   //Set KeyField1 to get data from IAPSEUDOMP                                           //0091
   If writePseudoCodeDs.srcSpec = 'F' AND wkFileConfigFlag = cwNewFormat ;               //0091
      wkKeyField1 = 'HEADER1' ;                                                          //0091
   Else ;                                                                                //0091
      wkKeyField1 = cwHeader ;                                                           //0091
   Endif ;                                                                               //0091
                                                                                         //0091
   //Declare cursor to get header details from mapping file for input spec & key field
   Exec Sql
      Declare GetSpecHeaderCursor Cursor For
         Select Src_Mapping
            From IaPseudoMp
            Where Source_Spec = :writePseudoCodeDs.srcSpec and
                  KeyField_1 = :wkKeyField1                and                           //0091
                  KeyField_2 = :inKeyFld
            Order By Seq_No
            For Fetch Only;

   Exec Sql Open GetSpecHeaderCursor;
   If SqlCode = Csr_Opn_Cod;
      Exec Sql Close GetSpecHeaderCursor;
      Exec Sql Open  GetSpecHeaderCursor;
   EndIf;

   If SqlCode < SuccessCode;
      uDpsds.wkQuery_Name = 'Open_GetSpecHeaderCursor';
      IaSqlDiagnostic(uDpsds);
   EndIf;

   Dow SqlCode = SuccessCode;

      //Fetch header details from mapping file for input spec & key field
      Exec Sql Fetch GetSpecHeaderCursor Into :writePseudoCodeDs.PseudoCode;
      If SqlCode < SuccessCode;
         uDpsds.wkQuery_Name = 'Fetch_GetSpecHeaderCursor';
         IaSqlDiagnostic(uDpsds);
         Leave;
      ElseIf SqlCode = No_Data_Found;
         Leave;
      EndIf;

      //2 space indentation for D spec Declaration Header after DCL-PROC comes          //0004
      If wkBeginProc = 'Y' and writePseudoCodeDs.srcSpec = 'D';                          //0004
         wkPseudoCode = writePseudoCodeDs.PseudoCode ;                                   //0004
         clear writePseudoCodeDs.PseudoCode;                                             //0004
         %subst(writePseudoCodeDs.PseudoCode : 3) = wkPseudoCode;                        //0004
      Endif;                                                                             //0004

      //Write the Pseudo code
      //Write to IAPSEUDOCP if only one Parm is passed and not RPG3 Kspec               //0068
      If %Parms < 2;                                                                     //0068
         OutParmPointer = %Addr(WritePseudoCodeDs);                                      //0068
         WritePseudoCode(OutParmPointer);                                                //0068
      Else;                                                                              //0068
         //Write to IAPSEUDOWK if RPG3 Kspec and Kspec is Inbetween Cspec               //0068
         If inFileType = 'W' and                                                         //0068
            (writePseudoCodeDs.srcType = 'RPG' or                                        //0068
            writePseudoCodeDs.srcType  = 'SQLRPG') and                                   //0068
            writePseudoCodeDs.srcSpec  = 'K';                                            //0068
                                                                                         //0068
            //Append Pipe Indent from saved global variable to Pseudo                   //0068
            If %trim(wkFX3PipeIndentSave) <> *Blanks;                                    //0068
               wkFX3Pipelength = %len(%trim(wkFX3PipeIndentSave));                       //0068
               Clear wkPseudoCode;                                                       //0068
               wkPseudoCode = writePseudoCodeDs.PseudoCode ;                             //0068
               clear writePseudoCodeDs.PseudoCode;                                       //0068
                                                                                         //0068
               //Apply Indent and Append Pipe to Pseudo                                 //0068
               If wkFX3Pipelength = 1;                                                   //0068
                  %subst(writePseudoCodeDs.PseudoCode : wkFX3Pipelength + 2) =           //0068
                  wkPseudoCode;                                                          //0068
               Else;                                                                     //0068
                  %subst(writePseudoCodeDs.PseudoCode : wkFX3Pipelength + 3) =           //0068
                  wkPseudoCode;                                                          //0068
               EndIf;                                                                    //0068
                                                                                         //0068
               %subst(writePseudoCodeDs.PseudoCode : 1 : wkFX3Pipelength) =              //0068
               %trim(wkFX3PipeIndentSave);                                               //0068
            EndIf;                                                                       //0068
                                                                                         //0068
            //Get Last sequence number from IAPSEUDOWK File for ReqID                   //0068
            Exec Sql                                                                     //0068
               Select COALESCE(Max(wkDocSeq),0) into :wkPseudoDocSeq                     //0068
               from IaPseudowk Where wkReqId = :inReqId ;                                //0068
                                                                                         //0068
            //Write Pseudo in IAPSEUDOWK file                                           //0068
            OutParmPointer = %Addr(WritePseudoCodeDs);                                   //0068
            WriteIaPseudowk(OutParmPointer : wkPseudoDocSeq : ' ');                      //0068
                                                                                         //0068
         Else;                                                                           //0068
            //Write to IAPSEUDOCP if RPG3 Kspec is before start of Cspec                //0068
            OutParmPointer = %Addr(WritePseudoCodeDs);                                   //0068
            WritePseudoCode(OutParmPointer);                                             //0068
         EndIf;                                                                          //0068
      EndIf;                                                                             //0068

      Clear WritePseudoCodeDs.PseudoCode;

   EndDo;

/copy 'QCPYSRC/iaprcerlog.rpgleinc'

End-Proc IaWriteSpecHeader;

//------------------------------------------------------------------------------------- //
//Procedure to Write Pseudocode code in IAPSEUDOCP                                      //
//------------------------------------------------------------------------------------- //
Dcl-Proc WritePseudoCode Export;

   Dcl-Pi *n;
      inParmPointer  Pointer;
   End-Pi;

   Dcl-Ds wkParmDs Qualified based(inParmPointer );
      inReqID       Char(18);
      inSrcLib      Char(10);
      inSrcPf       Char(10);
      inSrcMbr      Char(10);
      inSrcType     Char(10);
      inRrn         Packed(6:0);
      inRrnSeq      Packed(6:2);
      inSrcLtyp     Char(5);
      inSrcSpec     Char(1);
      inSrcLnct     Char(1);
      inPseudocode  Char(cwSrcLength);
   End-Ds;

   Dcl-Ds wkMaxLengthDataWthExtraChar;                                                   //0025
      wkCharacters  Char(1) Dim(110);                                                    //0025
   End-Ds;                                                                               //0025
   Dcl-Ds DsPseudoCodeForBlankCheck;                                                     //0042
      wkPseudoCodeForBlankCheckArr  Char(1) Dim(110);                                    //0042
   End-Ds;                                                                               //0042

   Dcl-S SrcLib     Char(10)     Inz;
   Dcl-S SrcPf      Char(10)     Inz;
   Dcl-S SrcMbr     Char(10)     Inz;
   Dcl-S ReqId      Int(20)      Inz;
   Dcl-S wkMaxDataToWrite        Char(109) Inz;                                          //0025
   Dcl-S wkPseudoCode            Char(cwSrcLength) Inz;                                  //0025
   Dcl-S wkBackupPseudoCode      Char(cwSrcLength) Inz;                                  //0025
   Dcl-S wkFirstNonBlankCharPos  Zoned(4:0) Inz;                                         //0025
   Dcl-S wkIdx                   Zoned(4:0) Inz;                                         //0025
   Dcl-S wkWriteBlankInd         Ind Inz;                                                //0042
   Dcl-C cwMaxNoOfCharToPrint    109;                                                    //0042
   Dcl-S wkKPseudoCode           Char(cwSrcLength) Inz;                                  //0056
   Dcl-S wkPipeIndent            Char(cwSrcLength) Inz;                                  //0055
   Dcl-S wkPipelength            Zoned(4:0) Inz;                                         //0055

   //Copybook declaration
/copy 'QCPYSRC/iaprderlog.rpgleinc'
   wkuDpsds.nbrparms = %parms;                                                           //0030
   EvaluatePSDS() ;                                                                      //0030

   ReqId    =   %int(wkParmDs.inReqId) ;
   SrcLib   =   wkParmDs.inSrcLib  ;
   SrcPf    =   wkParmDs.inSrcPf   ;
   SrcMbr   =   wkParmDs.inSrcMbr  ;

   //If previously blank line is written and again going to write                       //0028
   //one more blank line,skip. In case blank line came to print, switch on indicator    //0042
   //If wkLastWrittenData = *Blanks and wkParmDs.inPseudocode= *Blanks;                  //0055
   //If previously blank line is written and again going to write (With Pipe) ,Skip     //0055
   If %check(' |' : wkLastWrittenData) = 0 and wkParmDs.inPseudocode= *Blanks;           //0055
      Return;                                                                            //0028
   ElseIf wkParmDs.inPseudocode= *Blanks;                                                //0042
      wkWriteBlankInd = *On;                                                             //0042
   EndIf;                                                                                //0028

   Clear wkFontCode;                                                                     //0044
   If wkParmDs.inPseudocode = wkPseudocodeFontBkp And                                    //0044
      wkPseudocodeFontBkp <> *Blanks;                                                    //0044
      wkFontCode = cwBoldFont;                                                           //0044
   EndIf;                                                                                //0044

   //Get the position of first non-blank characters to store the indentation level      //0025
   wkPseudoCode  = wkParmDs.inPseudocode;                                                //0025
   wkFirstNonBlankCharPos = %Check(' ' : wkPseudoCode);                                  //0025

   DoW wkPSeudoCode <> *Blanks Or wkWriteBlankInd = *On;                                 //0042

      Exsr BreakPseudoCode;                                                              //0042

      //Switch off blank line printing indicator so that it should print once            //0042
      Select;                                                                            //0042
         When wkMaxDataToWrite = *Blanks and wkWriteBlankInd = *On;                      //0042
            wkWriteBlankInd = *Off;                                                      //0042
         When wkMaxDataToWrite = *Blanks;                                                //0042
            Leave;                                                                       //0042
      EndSl;                                                                             //0042
      //Append Calculated PipeIndent for Tagged Nested Line                             //0055
      Exsr PipeIndendation;                                                              //0055

         //Increment the document Seq no
         wkdocseq += 1;

         //Write the Pseudo code
         exec sql
           insert into IAPSEUDOCP ( iAReqId,
                                    iAMbrLib,
                                    iASrcFile,
                                    iAMbrNam,
                                    iAMbrTyp,
                                    iASrcRrn,
                                    iASrcSeq,
                                    iASrcLTyp,
                                    iASrcSpec,
                                    iADocSeq,
                                    iAGenPsCde,                                          //0044
                                    iAFontCode)                                          //0044

                           values ( :ReqID,
                                    :wkParmDs.inSrcLib,
                                    :wkParmDs.inSrcPf,
                                    :wkParmDs.inSrcMbr,
                                    :wkParmDs.inSrcType,
                                    :wkParmDs.inRrn,
                                    :wkParmDs.inRrnSeq,
                                    :wkParmDs.inSrcLtyp,
                                    :wkParmDs.inSrcSpec,
                                    :wkDocSeq,
                                    :wkMaxDataToWrite,                                   //0044
                                    :wkFontCode);                                        //0044

         If SqlCode < SuccessCode;
            uDpsds.wkQuery_Name = 'Insert_2_IAPSEUDOCP';
            IaSqlDiagnostic(uDpsds);
         EndIf;

         Clear wkFontCode;                                                               //0044

   EndDo;                                                                                //0025

   wkLastWrittenData = %trim(wkParmDs.inPseudocode);                                     //0029
   //If wkLastWrittenData <> *Blanks and wkParmDs.inSrcSpec = 'C';                       //0055
   If %check(' |' : wkLastWrittenData) <> 0 and wkParmDs.inSrcSpec = 'C';                //0055
      wkCountOfLineProcessAfterIndentation +=1;                                          //0038
   EndIf;                                                                                //0038

   Clear wkFontCode;                                                                     //0044

   Return ;
  //------------------------------------------------------------------------------------//0042
  //Subroutine BreakPseudoCode - To break the pseudo code in 109 characters             //0042
  //------------------------------------------------------------------------------------//0042
   BegSr BreakPseudoCode;                                                                //0042

      //Break the pseudo-data if the total lenght of pseudo code is more than 109        //0042
      If %len(%trimr(wkPseudoCode)) > cwMaxNoOfCharToPrint;                              //0042

         //Move the Pseudo-code to DS to check from where it should be broken            //0042
         DsPseudoCodeForBlankCheck = %trimr(wkPseudoCode);                               //0042

         //Start checking from 110th position backwards to find blank, wherever         //0042
         //blank position will be found Pseudo-code will be broke from there            //0042
         For wkIdx = cwMaxNoOfCharToPrint + 1 DownTo 1;                                  //0042
             If wkPseudoCodeForBlankCheckArr(wkIdx)=' ';                                 //0042
                Leave;                                                                   //0042
             EndIf;                                                                      //0042
         EndFor;                                                                         //0042

         //Exception handling.                                                          //0042
         If wkIdx = 0 Or %subst(wkPseudoCode : 1 : wkIdx) = *Blanks;                     //0042
            wkIdx = cwMaxNoOfCharToPrint;                                                //0042
         EndIf;                                                                          //0042

         // Increment Indent to display PipeSymbol from second split line of Tag        //0060
         If wkPipeTagInd=*On and  %subst(%trim(wkPseudoCode) : 1 : 1)='L';               //0060
            wkFirstNonBlankCharPos = wkFirstNonBlankCharPos + 2;                         //0060
         EndIf;                                                                          //0060

         //Move the data which can be printed to wkMaxDataToWrite                        //0042
         wkMaxDataToWrite = %trimr(%subst(wkPseudoCode : 1 : wkIdx));                    //0042

         //Move remaining data to wkPseudoCode and add indentation                       //0042
         wkBackupPseudoCode = wkPseudoCode;                                              //0042
         Clear wkPseudoCode;
         %subst(wkPseudoCode : wkFirstNonBlankCharPos) =                                 //0042
                                      %trim(%subst(wkBackupPseudoCode : wkIdx+1));       //0042

      Else;                                                                              //0042
         //If total length of Pseudo code is less than 109, move full data for printing  //0042
         wkMaxDataToWrite = %trimr(wkPseudoCode);                                        //0042
         wkPseudoCode     = *Blanks;                                                     //0042
      EndIf;                                                                             //0042

   EndSr;                                                                                //0042
   //-----------------------------------------------------------------------------------//0055
   //Subroutine PipeIndendation - Append Calculated PipeIndent for Tagged Nested Line   //0055
   //-----------------------------------------------------------------------------------//0055
   Begsr PipeIndendation;                                                                //0055
      If %Trim(wkPipeIndentSave) <> *Blanks and wkParmDs.inSrcType<>'RPG'                //0097
         and wkParmDs.inSrcType<>'SQLRPG';                                               //0097
         wkPipeIndent = %trim(wkPipeIndentSave) ;                                        //0055
         wkPipelength = %len(%trim(wkPipeIndentSave));                                   //0055
         If wkPipelength > cwMaxNoOfCharToPrint;                                         //0055
            wkPipelength = cwMaxNoOfCharToPrint;                                         //0055
         EndIf;                                                                          //0055
         //Pipe Indendation for Compiler Directives for Nested Lines -/COPY             //0056
         If wkParmDs.inSrcSpec = 'K';                                                    //0056
            wkKPseudoCode = wkMaxDataToWrite ;                                           //0056
            clear wkMaxDataToWrite;                                                      //0056
            If wkPipelength = 1;                                                         //0056
               %subst(wkMaxDataToWrite :wkPipelength + 2) = wkKPseudoCode;               //0056
            Else;                                                                        //0056
               Monitor;                                                                  //0056
                  %subst(wkMaxDataToWrite :wkPipelength + 3) = wkKPseudoCode;            //0056
               On-Error;                                                                 //0056
                  wkPipelength = cwMaxNoOfCharToPrint - 3;                               //0056
                  %subst(wkMaxDataToWrite :wkPipelength + 3) = wkKPseudoCode;            //0056
               EndMon;                                                                   //0056
            EndIf;                                                                       //0056
         EndIf;                                                                          //0056
         //Removes Last Pipe for Every new Tag and Its comment line                     //0055
         If wkPipeTagInd = *on and  %subst(wkMaxDataToWrite : 1 : wkPipelength)          //0055
            <> *Blanks;                                                                  //0055
            wkPipelength = wkPipelength - 1;                                             //0055
         EndIf;                                                                          //0055
         //Append Calculated PipeIndent for Every Tagged Nested Line in Pseudocode      //0055
         %subst(wkMaxDataToWrite : 1 : wkPipelength)= wkPipeIndent;                      //0055
      EndIf;                                                                             //0055
   EndSr;                                                                                //0055
/copy 'QCPYSRC/iaprcerlog.rpgleinc'

End-Proc;
//------------------------------------------------------------------------------------- //
//Procedure to Get the source description                                               //
//------------------------------------------------------------------------------------- //
Dcl-Proc GetObjectDesc Export;

   Dcl-Pi GetObjectDesc Ind;
     iObjectName   Char(10);
     oObjDesc      Char(50);
     iSrcLib       Char(10)   Options(*NoPass);
     iSrcpf        Char(10)   Options(*NoPass);
     iSrcType      Char(10)   Options(*NoPass);
   End-Pi;

   //Declaration of work variables
   Dcl-S  RcdFound Ind Inz(*off);
   Dcl-S  wkRowNum Uns(5);

   //Copybook declaration
/copy 'QCPYSRC/iaprderlog.rpgleinc'
   wkuDpsds.nbrparms = %parms;                                                           //0030
   EvaluatePSDS() ;                                                                      //0030


   If %Parms > 2 ;
      //Get the Object Description from iAMember
      Exec Sql
         Select iAMbrDsc  Into :oObjDesc
          From iAMember
          Where iASrcPfNam =   :iSrcpf
              and iASrcLib   = :iSrcLib
              and iAMbrNam   = :iObjectName
              and iAMbrType  = :iSrcType   ;

      Select;
         When SqlCode < SuccessCode;                                                     //0038
            uDpsds.wkQuery_Name = 'Select_IatxtDes_IAMEMBER';                            //0038
            IaSqlDiagnostic(uDpsds);                                                     //0038
            RcdFound = *Off;                                                             //0038
         When SqlCode > SuccessCode or oObjDesc = *Blanks ;                              //0040
            RcdFound = *Off;                                                             //0038
         Other;                                                                          //0038
            RcdFound = *On;                                                              //0038
      EndSl;                                                                             //0038

      Else ;
      //Get the object description from IAOBJECT
      Exec Sql
         Select iATxtDes Into :oObjDesc
           From iAObject
          Where iAObjNam = :iObjectName
           Limit 1;

      Select;
         When SqlCode < SuccessCode;                                                     //0038
            uDpsds.wkQuery_Name = 'Select_IatxtDes_IAOBJECT';                            //0038
            IaSqlDiagnostic(uDpsds);                                                     //0038
            RcdFound = *Off;                                                             //0038
         When SqlCode > SuccessCode or oObjDesc = *Blanks ;                              //0040
            RcdFound = *Off;                                                             //0038
         Other;                                                                          //0038
            RcdFound = *On;                                                              //0038
      EndSl;                                                                             //0038

   EndIf;

   Return RcdFound;

/copy 'QCPYSRC/iaprcerlog.rpgleinc'
End-Proc;

//------------------------------------------------------------------------------------- //
//Procedure - Write Pseudo code for keyword 'DCL' (CL)                                  //
//------------------------------------------------------------------------------------- //
Dcl-Proc iAPrPsDcl Export;

   Dcl-Pi *n;
      inParmClptr    Pointer;
      inClKeywordPrv Char(10);
   End-Pi;

   Dcl-Ds wkparmClds Qualified Based(inParmClptr);
      inString      Char(5000);
      inReqId       Char(18);
      inSrcLib      Char(10);
      inSrcPf       Char(10);
      inSrcMbr      Char(10);
      inSrcType     Char(10);
      inRrnStr      Packed(6:0);
      inRrnSeq      Packed(6:2);
      inLblName     Char(25);
      inWriteFlg    Char(1);
      inIndentLevel Packed(5:0);
      inMaxLevel    Packed(5:0);
      inIncrLevel   Packed(5:0);
      inIndentArray Packed(5:0) Dim(999);
   End-Ds;

   Dcl-Ds wkParmDs Qualified Inz;
      wkReqId      Char(18);
      wkSrcLib     Char(10);
      wkSrcPf      Char(10);
      wkSrcMbr     Char(10);
      wkSrcType    Char(10);
      wkRrnStr     Packed(6:0);
      wkRrnseq     Packed(6:2);
      wkSrcLtyp    Char(5);
      wkSrcSpec    Char(1);
      wkSrcLnct    Char(1);
      wkPseudocode Char(cwSrcLength);
   End-Ds;

   Dcl-S wkParmPointer  Pointer            Inz;
   Dcl-S Inx            Zoned(4:0)         Inz(1);
   Dcl-S wkIndentType   Char(10)           Inz;
   Dcl-S wkClKeywordPrv Char(10)           Inz;
   Dcl-S wkClKeyword    Char(10)           Inz;
   Dcl-S wkDataType     Char(10)           Inz;
   Dcl-S SrcStmType     Char(10)           Inz;
   Dcl-S wkClStatement  Char(5000)         Inz;
   Dcl-S StrPseudoCode  Char(cwSrcLength)  Inz;
   Dcl-S wkCommentDesc  Char(100)          Inz;
   Dcl-S wkWordsArray   Char(120) Dim(100) Inz;
   Dcl-S PseudocodeArr  Char(120) Dim(100) Inz;

   //Copybook declaration
/copy 'QCPYSRC/iaprderlog.rpgleinc'
   wkuDpsds.nbrparms = %parms;                                                           //0030
   EvaluatePSDS() ;                                                                      //0030

   wkClStatement = wkparmClds.inString ;
   wkParmDs.wkReqID   = wkparmClds.inReqId  ;
   wkParmDs.wkSrcLib  = wkparmClds.inSrcLib ;
   wkParmDs.wkSrcPf   = wkparmClds.inSrcPf ;
   wkParmDs.wkSrcMbr  = wkparmClds.inSrcMbr ;
   wkParmDs.wksrcType = wkparmClds.inSrcType ;
   wkParmDs.wkRrnStr  = wkparmClds.inRrnStr ;
   wkParmDs.wkRrnseq  = wkparmClds.inRrnSeq ;
   wkClKeywordPrv     = inClKeywordPrv;
   wkParmDs.wkSrcLtyp = *Blanks;
   wkParmDs.wkSrcSpec = *Blanks;
   wkParmDs.wkSrcLnct = *Blanks;

   If wkClStatement = *Blanks;
      Return;
   EndIf;

   GetWordsInArray(wkClStatement : wkWordsArray);

   wkClKeyword = wkWordsArray(1);
   SrcStmType = 'CL';

   ClKeywordMapping(wkClKeyword:SrcStmType:wkClStatement:
                    PseudocodeArr:wkCommentDesc:wkIndentType);

   If %Lookup(' ': PseudocodeArr) > 1;
      Dow PseudocodeArr(Inx) <> ' ';
         If Inx = 1;
           StrPseudocode = %Trim(PseudocodeArr(Inx));
         ElseIf Inx = 3;
           Exsr GetDataType;
           StrPseudocode = %Trim(StrPseudocode) + ', ' +
                              wkDataType;
         Else;
           StrPseudocode = %Trim(StrPseudocode) + ' ' +
                              %Trim(PseudocodeArr(Inx));
         EndIf;
         Inx += 1;
      Enddo;
   EndIf;

   If wkClKeyword <> wkClKeywordPrv And wkCommentDesc <> *Blanks;
     //Write the Header of Variable Declaration
     wkParmDs.wkPseudoCode = *Blanks;
     wkParmPointer = %Addr(wkParmDs);
     WritePseudoCode(wkParmPointer);

     wkParmDs.wkPseudoCode = wkCommentDesc;
     wkParmPointer = %Addr(wkParmDs);
     WritePseudoCode(wkParmPointer);
   EndIf;

   //Write the Pseudocode - Variable name, Data type and its length
   wkParmDs.wkPseudoCode = StrPseudocode;
   wkParmPointer = %Addr(wkParmDs);
   WritePseudoCode(wkParmPointer);

   Return;

   //--------------------------------------------------------------------
   //GetDataType Subroutine - Get the Data Type of the Variable
   //--------------------------------------------------------------------
   BegSr GetDataType;

     Select;
       When PseudocodeArr(Inx) = '*Char';
         wkDataType = 'Character';
       When PseudocodeArr(Inx) = '*DEC';
         wkDataType = 'Decimal';
       When PseudocodeArr(Inx) = '*LGL';
         wkDataType = 'Logical';
       When PseudocodeArr(Inx) = '*INT';
         wkDataType = 'Signed Integer';
       When PseudocodeArr(Inx) = '*UINT';
         wkDataType = 'Unsigned Integer';
       When PseudocodeArr(Inx) = '*PTR';
         wkDataType = 'Pointer';
     Endsl;

   EndSr;

/copy 'QCPYSRC/iaprcerlog.rpgleinc'
End-Proc;
//------------------------------------------------------------------------------------- //
//Procedure - Write Pseudo code for keyword 'PGM' (CL)                                  //
//------------------------------------------------------------------------------------- //
Dcl-Proc iAPrPsPGM export;
   Dcl-Pi *n;
     inParmClds Pointer;
   End-Pi;

   Dcl-Ds wkparmClds Qualified Based(inParmCLds);
     inString      Char(5000);
     inReqId       Char(18);
     inSrcLib      Char(10);
     inSrcPf       Char(10);
     inSrcMbr      Char(10);
     inSrcType     Char(10);
     inRrnStr      Packed(6:0);
     inRrnSeq      Packed(6:2);
     inLblName     Char(25);
     inWriteFlg    Char(1);
     inIndentLevel Packed(5:0);
     inMaxLevel    Packed(5:0);
     inIncrLevel   Packed(5:0);
     inIndentArray Packed(5:0) Dim(999);
   End-Ds;

   Dcl-Ds wkParmDs Qualified inz;
      wkReqID      Char(18);
      wkSrcLib     Char(10);
      wkSrcPf      Char(10);
      wkSrcMbr     Char(10);
      wksrcType    Char(10);
      wkRrnStr     Packed(6:0);
      wkRrnseq     Packed(6:2);
      wkSrcLtyp    Char(5);
      wkSrcSpec    Char(1);
      wkSrcLnct    Char(1);
      wkPseudocode Char(cwSrcLength);
   End-Ds;

   Dcl-S wkParmPointer Pointer             Inz;
   Dcl-S wkClStatement Char(5000)          Inz;
   Dcl-S wkParmMbr     Char(10)            Inz;
   Dcl-S wkParmSrcPf   Char(10)            Inz;
   Dcl-S wkParmLib     Char(10)            Inz;
   Dcl-S wkKwd1        Char(10)            Inz;
   Dcl-S wkKwd2        Char(10)            Inz;
   Dcl-S wkParmList    Char(80)            Inz;
   Dcl-S AllClParms    Char(5000)          Inz;
   Dcl-S SrcStmType    Char(10)            Inz;
   Dcl-S Count         Zoned(4:0)          Inz(1);
   Dcl-S wkParamSeq    Zoned(5:0)          Inz;
   Dcl-S wkParmArray   Char(120)  Dim(100) Inz;
   Dcl-S wkWordsArray  Char(120)  Dim(100) Inz;

   //Copybook declaration
/copy 'QCPYSRC/iaprderlog.rpgleinc'
   wkuDpsds.nbrparms = %parms;                                                           //0030
   EvaluatePSDS() ;                                                                      //0030

   wkParmDs.wkReqID   = wkparmClds.inReqId  ;
   wkParmDs.wkSrcLib  = wkparmClds.inSrcLib ;
   wkParmDs.wkSrcPf   = wkparmClds.inSrcPf ;
   wkParmDs.wkSrcMbr  = wkparmClds.inSrcMbr ;
   wkParmDs.wkSrcType = wkparmClds.inSrcType ;
   wkParmDs.wkRrnStr  = wkparmClds.inRrnStr ;
   wkParmDs.wkRrnseq  = wkparmClds.inRrnSeq ;
   wkParmDs.wkSrcLtyp = *Blanks;
   wkParmDs.wkSrcSpec = *Blanks;
   wkParmDs.wkSrcLnct = *Blanks;

   wkClStatement = wkparmClds.inString ;

   if wkClStatement = *Blanks;
      Return;
   EndIf;
   SrcStmType = 'CL';

   GetWordsInArray(wkClStatement : wkWordsArray);

   Select;
   // If CL source line has Params with in PARM Keyword
   When %Scan(' PARM(' : %Trim(wkClStatement)) > 0;
      AllClParms = ScanKeywordCl(' PARM(' : wkClStatement);

   // If CL source line has paramaters only with in ()
   When %Scan(' (' : %Trim(wkClStatement)) > 0;
      AllClParms = ScanKeywordCl(' (' : wkClStatement);

   // If Source line doesnt have neither PARM nor ()
   Other;
      If %Check('PGM ' : %Trim(wkClStatement)) > 0;
         AllClParms = %Subst( %Trim(wkClStatement) :
                              %Check('PGM ' : %Trim(wkClStatement)));
      EndIf;
   Endsl;
   GetWordsInArray(AllClParms : wkParmArray);

   Dow wkparmArray(Count) <> ' ';
      wkParmList = %Trim(wkParmList) + ' ' +
                         %Trim(wkparmArray(Count));
      Count += 1;
   EndDo;

   wkKwd1 = wkWordsArray(1);
   Clear wkSrcMap;
   Exec sql
      Select  Src_Mapping
      Into  :wkSrcMap
      From IaPseudoMP
      Where SrcMbr_Type  = :SrcStmType
           And KeyField_1 = :wkKwd1;

   If wkSrcmap <> *Blanks;
      wkParmDs.wkPseudoCode = %ScanRpl('&Parm' : %Trim(wkParmList) : wkSrcMap);
      wkParmPointer = %Addr(wkParmDs);
      WritePseudoCode(wkParmPointer);
   EndIf;

   If SqlState <> Sql_All_Ok;
      //Log Error
   EndIf;

   Return;
/copy 'QCPYSRC/iaprcerlog.rpgleinc'
End-Proc;

//------------------------------------------------------------------------------------- //
//iAPsChgVar: Pseudo code for ChgVar keyword                                            //
//------------------------------------------------------------------------------------- //
Dcl-Proc iAPsChgVar Export;

   Dcl-Pi *n;
      inParmCLds Pointer;
   End-Pi;

   Dcl-Ds wkparmClds Qualified Based(inParmCLds);
      inString      Char(5000);
      inReqId       Char(18);
      inSrcLib      Char(10);
      inSrcPf       Char(10);
      inSrcMbr      Char(10);
      inSrcType     Char(10);
      inRrn         Packed(6:0);
      inRrnSeq      Packed(6:2);
      inLblName     Char(25);
      inWriteFlg    Char(1);
      inIndentLevel Packed(5:0);
      inMaxLevel    Packed(5:0);
      inIncrLevel   Packed(5:0);
      inIndentArray Packed(5:0) Dim(999);
   End-Ds;

   Dcl-Ds wkParmDs Qualified Inz;
      wkReqId      Char(18);
      wkSrcLib     Char(10);
      wkSrcPf      Char(10);
      wkSrcMbr     Char(10);
      wkSrcType    Char(10);
      wkRrn        Packed(6:0);
      wkRrnSeq     Packed(6:2);
      wkSrcLtyp    Char(5);
      wkSrcSpec    Char(1);
      wkSrcLnct    Char(1);
      wkPseudocode Char(cwSrcLength);
   End-Ds;

   Dcl-S wkClStatement         Char(5000)          Inz;
   Dcl-S ChWordVal             Char(5000)          Inz;
   Dcl-S ChWordRes             Char(5000)          Inz;
   Dcl-S wkBifSrcCode          Char(5000)          Inz;
   Dcl-S StrPseudoCode         Char(cwSrcLength)   Inz;
   Dcl-S wkLblName             Char(20)            Inz;
   Dcl-S wkSrcLabel            Char(20)            Inz;
   Dcl-S wkIndentType          Char(10)            Inz;
   Dcl-S SrcStmType            Char(10)            Inz;
   Dcl-S wkVarpos              Packed(6:0)         Inz;
   Dcl-S wkVarposSv            Packed(6:0)         Inz;
   Dcl-S wkBlnkPos             Packed(6:0)         Inz;
   Dcl-S wkValPos              Packed(6:0)         Inz;
   Dcl-S IOIndentParmPointer   Pointer             Inz;
   Dcl-S wkParmPointer         Pointer             Inz;

   //Copybook declaration
/copy 'QCPYSRC/iaprderlog.rpgleinc'
   wkuDpsds.nbrparms = %parms;                                                           //0030
   EvaluatePSDS() ;                                                                      //0030

   wkParmDs.wkReqID             = wkparmClds.inReqId  ;
   wkParmDs.wkSrcMbr            = wkparmClds.inSrcMbr;
   wkParmDs.wkSrcPf             = wkparmClds.inSrcPf;
   wkParmDs.wkSrcLib            = wkparmClds.inSrcLib;
   wkParmDs.wksrcType           = wkparmClds.inSrcType;
   wkParmDs.wkRrn               = wkparmClds.inRrn;
   wkParmDs.wkRrnseq            = wkparmClds.inRrnSeq ;
   wkIndentParmDs.dsIndentLevel = wkparmClds.inIndentLevel;
   wkIndentParmDs.dsMaxLevel    = wkparmClds.inMaxLevel;
   wkIndentParmDs.dsIncrLevel   = wkparmClds.inIncrLevel;
   wkIndentParmDs.dsIndentArray = wkparmClds.inIndentArray;
   wkClStatement                = wkparmClds.inString ;
   wkLblName                    = wkparmClds.inLblName;

   If wkClStatement = *Blanks;
      Return;
   EndIf;
   SrcStmType = 'CL';

   If wkLblName <> *Blanks;
     iAPsLabel(SrcStmType: wkLblName: wkSrcLabel);
   EndIf;

   Exec Sql
     Values Upper(:wkClStatement) Into :wkClStatement;

   Exec Sql
        Set :wkClStatement = Replace(:wkClStatement, 'CHGVAR', '');

   wkClStatement = %Trim(wkClStatement);

   Select;
   //When Var is present, then VALUE is mandatory
   When %Scan('VAR(' :wkClStatement:1) > 0;
      //Compute ChWordRes
      wkVarpos   = %Scan('VAR(' :wkClStatement:1) + 3;
      wkVarposSv = wkVarpos;
      FindCbr(wkVarpos:wkClStatement);
      If wkVarpos > wkVarposSv + 1;
         ChWordRes = %Subst(wkClStatement:wkVarposSv+1:wkVarpos-wkVarposSv-1);
      EndIf;
      ChWordRes = RmvBrackets(ChWordRes);

      //Compute ChWordVal
      wkVarpos   = %Scan('VALUE(' :wkClStatement:1) + 5;
      wkVarposSv = wkVarpos;
      FindCbr(wkVarpos:wkClStatement);
      If wkVarpos > wkVarposSv + 1;
         ChWordVal = %Subst(wkClStatement:wkVarposSv+1:wkVarpos-wkVarposSv-1);
      EndIf;
      ChWordVal = RmvBrackets(ChWordVal  );

   //VAR is not present and VALUE is present
   When %Scan('VAR(' :wkClStatement:1) = 0 and %Scan('VALUE(' :wkClStatement:1) > 0;
      Select;
      When %Scan('(' :wkClStatement:1) = 1;
         //Find its closing bracket
         //Compute ChWordRes
         wkVarpos = 1;
         FindCbr(wkVarpos:wkClStatement);
         If wkVarpos > 2;
            ChWordRes  = %Subst(wkClStatement: 2 : wkVARpos-2);
            ChWordRes  = RmvBrackets(ChWordRes);
         EndIf;
      When %Scan('%' :wkClStatement:1) = 1 Or
                %Scan('&' :wkClStatement:1) = 1;
         //Compute ChWordRes
         wkValpos = %Scan('VALUE(' :wkClStatement:1);
         if wkVALpos > 1;
            ChWordRes  = %Subst(wkClStatement: 1 :wkValpos-1);
         EndIf;

      EndSl;

      //Compute ChWordVal
      wkVarpos   = %Scan('VALUE(' :wkClStatement:1) + 5;
      wkVARposSv = wkVarpos;
      FindCbr(wkVARpos:wkClStatement);
      If wkVarpos > wkVarposSv + 1;
         ChWordVal   = %Subst(wkClStatement:wkVarposSv+1:wkVarpos-wkVarposSv-1);
         ChWordVal   = RmvBrackets(ChWordVal);
      EndIf;

   //Both VAR & VALUE are not there
   when %Scan('VAR(' :wkClStatement:1) = 0 and
                      %Scan('VALUE(' :wkClStatement:1) = 0;
      //Compute ChWordRes
      select;
      when %Scan('(' :wkClStatement:1) = 1;
         //Find its closing bracket
         //store the ending position
         //Compute ChWordRes
         wkVarpos = 1;
         FindCbr(wkVarpos:wkClStatement);
         If wkVARpos > 2;
            ChWordRes = %Subst(wkClStatement: 2 :wkVarpos -2);
            ChWordRes = RmvBrackets(ChWordRes);
         EndIf;

        //Compute ChWordVal
         ChWordVal = %Subst(wkClStatement:wkVarpos+1);
         ChWordVal = RmvBrackets(ChWordVal);
      when %Scan('%' :wkClStatement:1) = 1;
         //Call respective proc for BIF..
         //store the ending position.
         //Compute ChWordRes
         wkVARpos = %Scan('(' :wkClStatement:1) + 1;
         FindCbr(wkVarpos:wkClStatement);
         ChWordRes  = %Subst(wkClStatement: 1 :wkVarpos);

         //Compute ChWordVal
         ChWordVal  = %Subst(wkClStatement:wkVarpos+1);
         ChWordVal  = RmvBrackets(ChWordVal);
      when %Scan('&' :wkClStatement:1) = 1;
         //directly move the variable into result field.
         //store the ending position
         //Compute ChWordRes
         wkVarpos = 1;
         wkBlnkPos = %Scan(' ' :wkClStatement:2);
         if wkBlnkPos > 0;
           ChWordRes  = %Subst(wkClStatement: 1 :wkBlnkPos);
         EndIf;

         //Compute ChWordVal
         ChWordVal = %Subst(wkClStatement:wkBlnkPos +1 );
         ChWordVal = RmvBrackets(ChWordVal);
      EndSl;
   EndSl;

   Clear wkBifSrcCode;
   If %Scan('%' : ChWordVal) = 1 and %Scan('%' : ChWordVal :2) = *zeros;
     iAPsBif(SrcStmType : ChWordVal : wkBifSrcCode);
   Else;
     wkBifSrcCode = ChWordVal;
   EndIf;

   //StrPseudoCode = 'Assign: ' + %Trim(ChWordRes) +
   //                   ' Equals ' +  %Trim(wkBifSrcCode);
   StrPseudoCode = 'Assign ' +  %Trim(wkBifSrcCode) + ' To '+ %Trim(ChWordRes);


   //replace Cat operators
   If %Scan('*CAT' : StrPseudoCode : 7)  >  *Zeros;
      StrPseudoCode  = %Scanrpl('*CAT' : ' ' : StrPseudoCode);
   Endif;

   If %Scan('*BCAT' : StrPseudoCode : 7)  >  *Zeros;
      StrPseudoCode  = %Scanrpl('*BCAT' : ' ' : StrPseudoCode);
   Endif;

   If %Scan('*TCAT' : StrPseudoCode : 7)  >  *Zeros;
      StrPseudoCode  = %Scanrpl('*TCAT' : ' ' : StrPseudoCode);
   Endif;

   If wkSrcLabel <> *Blanks;
      wkIndentParmDs.dsPseudoCode = %Trim(wkSrcLabel) + ' ' +
                                           %Trim(StrPseudoCode);
   Else;
      wkIndentParmDs.dsPseudoCode = %Trim(StrPseudoCode);
   EndIf;

   If wkIndentParmDs.dsIndentLevel <> *Zeros or  wkIndentType <> *Blanks;
      wkIndentParmDs.dsIndentType = wkIndentType;
      IOIndentParmPointer = %Addr(wkIndentParmDs);
      IaAddPseudocodeIndentation(IOIndentParmPointer);
      wkparmClds.inIndentLevel = wkIndentParmDs.dsIndentLevel;
      wkparmClds.inMaxLevel    = wkIndentParmDs.dsMaxLevel;
      wkparmClds.inIncrLevel   = wkIndentParmDs.dsIncrLevel;
      wkparmClds.inIndentArray = wkIndentParmDs.dsIndentArray;
   EndIf;
   wkParmDs.wkPseudoCode = wkIndentParmDs.dsPseudoCode;

   wkParmPointer = %Addr(wkParmDs);
   WritePseudoCode(wkParmPointer);

   Return;
/copy 'QCPYSRC/iaprcerlog.rpgleinc'
End-Proc;
//------------------------------------------------------------------------------------- //
//IAPSMONMSG: Pseudo code for Monitor message statements                                //
//------------------------------------------------------------------------------------- //
Dcl-Proc iAPsMonMsg Export;

   Dcl-Pi *n;
      inParmCLds Pointer;
   End-Pi;

   Dcl-Ds wkparmClds Qualified based(inParmCLds);
     inString      Char(5000);
     inReqId       Char(18);
     inSrcLib      Char(10);
     inSrcPf       Char(10);
     inSrcMbr      Char(10);
     inSrcType     Char(10);
     inRrn         Packed(6:0);
     inRrnSeq      Packed(6:2);
     inLblName     Char(25);
     inWriteFlg    Char(1);
     inIndentLevel Packed(5:0);
     inMaxLevel    Packed(5:0);
     inIncrLevel   Packed(5:0);
     inIndentArray Packed(5:0) Dim(999);
   End-Ds;

   Dcl-Ds wkParmDs Qualified Inz;
      wkReqId      Char(18);
      wkSrcLib     Char(10);
      wkSrcPf      Char(10);
      wkSrcMbr     Char(10);
      wkSrcType    Char(10);
      wkRrn        Packed(6:0);
      wkRrnSeq     Packed(6:2);
      wkSrcLtyp    Char(5);
      wkSrcSpec    Char(1);
      wkSrcLnct    Char(1);
      wkPseudocode Char(cwSrcLength);
   End-Ds;

   Dcl-S wkClStatement        Char(5000)           Inz;
   Dcl-S wkClKeyword          Char(10)             Inz;
   Dcl-S StrPseudoCode        Char(cwSrcLength)    Inz;
   Dcl-S wkCommentDesc        Char(100)            Inz;
   Dcl-S WkMsgId              Char(100)            Inz;
   Dcl-S wkMonMsgD            Char(100)            Inz;
   Dcl-S WkExec               Char(100)            Inz;
   Dcl-S wkLblName            Char(20)             Inz;
   Dcl-S wkSrcLabel           Char(20)             Inz;
   Dcl-S wkWriteFlg           Char(1)              Inz;
   Dcl-S wkSrcMap1            Like(wkSrcMap)       Inz;
   Dcl-S StrPseudoCode1       Like(StrPseudoCode)  Inz;
   Dcl-S wkIndentType         Char(10)             Inz;
   Dcl-S SrcStmType           Char(10)             Inz;
   Dcl-S wkParmPointer        Pointer              Inz;
   Dcl-S IOIndentParmPointer Pointer              Inz;

   Dcl-S wkWordsArray         Char(120)  Dim(100)  Inz;

   //Copybook declaration
/copy 'QCPYSRC/iaprderlog.rpgleinc'
   wkuDpsds.nbrparms = %parms;                                                           //0030
   EvaluatePSDS() ;                                                                      //0030

   wkParmDs.wkReqId             = wkparmClds.inReqId  ;
   wkParmDs.wkSrcMbr            = wkparmClds.inSrcMbr ;
   wkParmDs.wkSrcPf             = wkparmClds.inSrcPf  ;
   wkParmDs.wkSrcLib            = wkparmClds.inSrcLib ;
   wkParmDs.wksrcType           = wkparmClds.inSrcType ;
   wkParmDs.wkRrn               = wkparmClds.inRrn ;
   wkParmDs.wkRrnseq            = wkparmClds.inRrnSeq ;
   wkIndentParmDs.dsIndentLevel = wkparmClds.inIndentLevel;
   wkIndentParmDs.dsMaxLevel    = wkparmClds.inMaxLevel;
   wkIndentParmDs.dsIncrLevel   = wkparmClds.inIncrLevel;
   wkIndentParmDs.dsIndentArray = wkparmClds.inIndentArray;
   wkClStatement                = wkparmClds.inString ;
   wkLblName                    = wkparmClds.inLblName;
   wkWriteFlg                   = wkparmClds.inWriteFlg;

   If wkClStatement = *Blanks;
      Return;
   EndIf;
   SrcStmType = 'CL';

   //Check for Label in CL statement
   If wkLblName <> *Blanks;
      iAPsLabel(SrcStmType: wkLblName: wkSrcLabel);
   EndIf;

   //Get the Keyword name
   GetWordsInArray(wkClStatement : wkWordsArray);
   wkClKeyword = wkWordsArray(1);

   WkMsgId = scanKeywordCL(' MSGID(':wkClStatement);
   If WkMsgId = *Blanks;
      WkMsgId = wkWordsArray(2);
   EndIf;

   WkExec = ScanKeywordCl(' EXEC(':wkClStatement);

   //If the Error ID is configured, get the source statement from mapping file
   Clear wkSrcMap1;
   Exec sql
        Select  Src_Mapping
          InTo  :wkSrcMap1
          From IaPseudoMP
         Where SrcMbr_Type = :SrcStmType
           And KeyField_1 = :wkClKeyword
           And KeyField_2 = :WkMsgId;

   If wkSrcMap1 <> *Blanks;

      If Wkexec <> *Blanks;
         wkSrcMap1 = 'If ' + %Trim(wkSrcMap1) + ' then';
      Else;
         wkSrcMap1 = 'Monitor the statement if ' + %Trim(wkSrcMap1);
      EndIf;

   EndIf;

   If SqlCode < successCode;
      uDpsds.wkQuery_Name = wkClKeyword;
      IaSqlDiagnostic(uDpsds);
   EndIf;

   //If the Error ID is not configured, get the generic source statement
   //from mapping file
   If wkSrcMap1 = *Blanks;
      Exec Sql
         Select  Src_Mapping,
                 Indent_Type
         InTo  :wkSrcMap1,
               :WkIndentType
         From IaPseudoMP
         Where SrcMbr_Type = :SrcStmType
             And KeyField_1 = :wkClKeyword
             And KeyField_2 = ' ';

      If wkSrcMap1 <> *Blanks;
         wkSrcMap1 =%ScanRpl('&Var1':%Trim(WkMsgId):wkSrcMap1);
      EndIf;

      If SqlCode < SuccessCode;
         uDpsds.wkQuery_Name = wkClKeyword;
         IaSqlDiagnostic(uDpsds);
      EndIf;
   EndIf;

   //Get the execute command from MONMSG statement and populate
   //the source statement for the same

   //If execute cmd has GOTO statement, then call procedure IAPSGOTO to
   //populate the source statement otherwise pass the execute command as it is
   If WkExec <> *Blanks;
      If %Subst(WkExec:1:5) = 'GOTO ';
         wkparmClds.inString = WkExec;
         wkparmClds.inWriteFlg = *Blanks;
         iAPsGoto(inParmClds);
         StrPseudoCode1 = wkparmClds.inString ;
      EndIf;
   EndIf;

   //Populate the pseudo code
   Select;
      When StrPseudoCode1 <> *Blanks;
         StrPseudoCode = %Trim(wkSrcMap1) + ' ' + %Trim(StrPseudoCode1);

      When StrPseudoCode1 = *Blanks and wkExec <> *Blanks;
         StrPseudoCode = %Trim(wksrcMap1) + ' execute command ' + wkExec;

      When wkExec = *Blanks;
         StrPseudoCode = %Trim(wksrcMap1);
   EndSl;

   If wkSrcLabel <> *Blanks;
      wkIndentParmDs.dsPseudoCode = %Trim(wkSrcLabel) + ' ' +
                                            %Trim(StrPseudoCode);
   Else;
      wkIndentParmDs.dsPseudoCode = %Trim(StrPseudoCode);
   EndIf;

   If wkIndentParmDs.dsIndentLevel <> *Zeros or
                      wkIndentType <> *Blanks;
      wkIndentParmDs.dsIndentType = wkIndentType;
      IOIndentParmPointer = %Addr(wkIndentParmDs);
      IaAddPseudocodeIndentation(IOIndentParmPointer);
      wkparmClds.inIndentLevel = wkIndentParmDs.dsIndentLevel;
      wkparmClds.inMaxLevel    = wkIndentParmDs.dsMaxLevel;
      wkparmClds.inIncrLevel   = wkIndentParmDs.dsIncrLevel;
      wkparmClds.inIndentArray = wkIndentParmDs.dsIndentArray;
   EndIf;
   wkParmDs.wkPseudoCode = wkIndentParmDs.dsPseudoCode;

   wkParmPointer = %Addr(wkParmDs);
   WritePseudoCode(wkParmPointer);

   Return;
/copy 'QCPYSRC/iaprcerlog.rpgleinc'
End-Proc;
//------------------------------------------------------------------------------------- //
//IAPSGOTO - Procedure to get pseudo code GOTO keyword                                  //
//------------------------------------------------------------------------------------- //
Dcl-Proc iAPsGoto Export;

   Dcl-Pi *n;
      inParmClds Pointer;
   End-Pi;

   Dcl-Ds wkparmClds Qualified based(inParmClds);
     inString      Char(5000);
     inReqId       Char(18);
     inSrcLib      Char(10);
     inSrcPf       Char(10);
     inSrcMbr      Char(10);
     inSrcType     Char(10);
     inRrn         Packed(6:0);
     inRrnSeq      Packed(6:2);
     inLblName     Char(25);
     inWriteFlg    Char(1);
     inIndentLevel Packed(5:0);
     inMaxLevel    Packed(5:0);
     inIncrLevel   Packed(5:0);
     inIndentArray Packed(5:0) Dim(999);
   End-Ds;

   Dcl-Ds wkParmDs Qualified Inz;
      wkReqId      Char(18);
      wkSrcLib     Char(10);
      wkSrcPf      Char(10);
      wkSrcMbr     Char(10);
      wksrcType    Char(10);
      wkRrn        Packed(6:0);
      wkRrnSeq     Packed(6:2);
      wkSrcLtyp    Char(5);
      wkSrcSpec    Char(1);
      wkSrcLnct    Char(1);
      wkPseudocode Char(cwSrcLength);
   End-Ds;

   Dcl-S wkClStatement         Char(5000)         Inz;
   Dcl-S StrPseudoCode         Char(cwSrcLength)  Inz;
   Dcl-S wkCmdLbl              Char(25)           Inz;
   Dcl-S wkLblName             Char(20)           Inz;
   Dcl-S wkSrcLabel            Char(20)           Inz;
   Dcl-S wkClKeyword           Char(10)           Inz;
   Dcl-S wkWriteFlg            Char(1)            Inz;
   Dcl-S wkIndentType          Char(10)           Inz;
   Dcl-S SrcStmType            Char(10)           Inz;
   Dcl-S wkParmPointer         Pointer            Inz;


   Dcl-S wkWordsArray          Char(120) Dim(100) Inz;

   //Copybook declaration
/copy 'QCPYSRC/iaprderlog.rpgleinc'
   wkuDpsds.nbrparms = %parms;                                                           //0030
   EvaluatePSDS() ;                                                                      //0030

   wkParmDs.wkReqID             = wkParmClds.inReqId  ;
   wkParmDs.wkSrcMbr            = wkParmClds.inSrcMbr;
   wkParmDs.wkSrcPf             = wkParmClds.inSrcPf;
   wkParmDs.wkSrcLib            = wkParmClds.inSrcLib;
   wkParmDs.wksrcType           = wkParmClds.inSrcType;
   wkParmDs.wkRrn               = wkParmClds.inRrn;
   wkParmDs.wkRrnseq            = wkParmClds.inRrnSeq;
   wkIndentParmDs.dsIndentLevel = wkParmClds.inIndentLevel;
   wkIndentParmDs.dsMaxLevel    = wkParmClds.inMaxLevel;
   wkIndentParmDs.dsIncrLevel   = wkParmClds.inIncrLevel;
   wkIndentParmDs.dsIndentArray = wkParmClds.inIndentArray;
   wkClStatement                = wkParmClds.inString;
   wkLblName                    = wkParmClds.inLblName;
   wkWriteFlg                   = wkParmClds.inWriteFlg;

   If wkClStatement = *Blanks;
      Return;
   EndIf;
   SrcStmType = 'CL';

   If wkLblName <> *Blanks;
      iAPsLabel(SrcStmType: wkLblName: wkSrcLabel);
   EndIf;

   GetWordsInArray(wkClStatement : wkWordsArray);
   wkClKeyword = wkWordsArray(1);

   wkCmdLbl = ScanKeywordCL(' CMDLBL(':wkClStatement);

   If wkCmdLbl = *Blanks;
      wkCmdLbl = wkWordsArray(2);
   EndIf;

   Clear wkSrcMap;
   Exec Sql
        Select  Src_Mapping ,
                Indent_Type
        InTo  :wkSrcMap ,
              :WkIndentType
        From IaPseudoMP
        Where SrcMbr_Type = :SrcStmType
           And KeyField_1 = :wkClKeyword;

   if SqlCode < successCode;
      uDpsds.wkQuery_Name = wkClKeyword;
      IaSqlDiagnostic(uDpsds);
   EndIf;

   If wkSrcMap <> *Blanks;
      StrPseudoCode = %ScanRpl('&Var1':%Trim(wkCmdLbl):wkSrcMap);
   EndIf;

   If wkWriteFlg = 'Y';

      If wkSrcLabel <> *Blanks;
         wkIndentParmDs.dsPseudoCode = %Trim(wkSrcLabel) + ' ' +
                                               %Trim(StrPseudoCode);
      Else;
         wkIndentParmDs.dsPseudoCode = %Trim(StrPseudoCode);
      EndIf;

      If wkIndentParmDs.dsIndentLevel <> *Zeros or
                         wkIndentType <> *Blanks;
         wkIndentParmDs.dsIndentType = wkIndentType;
         IOIndentParmPointer = %Addr(wkIndentParmDs);
         IaAddPseudocodeIndentation(IOIndentParmPointer);
         wkparmClds.inIndentLevel = wkIndentParmDs.dsIndentLevel;
         wkparmClds.inMaxLevel    = wkIndentParmDs.dsMaxLevel;
         wkparmClds.inIncrLevel   = wkIndentParmDs.dsIncrLevel;
         wkparmClds.inIndentArray = wkIndentParmDs.dsIndentArray;
      EndIf;
      wkParmDs.wkPseudoCode = wkIndentParmDs.dsPseudoCode;

      wkParmPointer = %Addr(wkParmDs);
      WritePseudoCode(wkParmPointer);

      //Write a blank record after Goto Statement
      wkParmDs.wkPseudoCode = *Blanks;
      wkParmPointer = %Addr(wkParmDs);
      WritePseudoCode(wkParmPointer);

   Else;
      wkparmClds.inString = %Trim(StrPseudoCode);
   EndIf;

   Return;

/copy 'QCPYSRC/iaprcerlog.rpgleinc'
End-Proc;
//------------------------------------------------------------------------------------- //
//IAPSCLMAP: Pseudo code for CL Commands with 2nd level mapping                         //
//------------------------------------------------------------------------------------- //
Dcl-Proc iAPsClMap Export;

   Dcl-Pi *n;
      inParmCLds Pointer;
      inClKeywordPrv Char(10);
   End-Pi;

   Dcl-Ds wkparmClds Qualified based(inParmClds);
      inString      Char(5000);
      inReqId       Char(18);
      inSrcLib      Char(10);
      inSrcPf       Char(10);
      inSrcMbr      Char(10);
      inSrcType     Char(10);
      inRrn         Packed(6:0);
      inRrnSeq      Packed(6:2);
      inLblName     Char(25);
      inWriteFlg    Char(1);
      inIndentLevel Packed(5:0);
      inMaxLevel    Packed(5:0);
      inIncrLevel   Packed(5:0);
      inIndentArray Packed(5:0) Dim(999);
   End-Ds;

   Dcl-Ds wkParmDs Qualified inz;
      wkReqId      Char(18);
      wkSrcLib     Char(10);
      wkSrcPf      Char(10);
      wkSrcMbr     Char(10);
      wksrcType    Char(10);
      wkRrn        Packed(6:0);
      wkRrnSeq     Packed(6:2);
      wkSrcLtyp    Char(5);
      wkSrcSpec    Char(1);
      wkSrcLnct    Char(1);
      wkPseudocode Char(cwSrcLength);
   End-Ds;

   Dcl-S wkClStatement         Char(5000)         inz;
   Dcl-S wkClKeyword           Char(10)           inz;
   Dcl-S StrPseudoCode         Char(cwSrcLength)  inz;
   Dcl-S wkCommentDesc         Char(100)          inz;
   Dcl-S wkLblName             Char(20)           inz;
   Dcl-S wkSrcLabel            Char(20)           inz;
   Dcl-S Inx                   Zoned(4:0)         inz(1);
   Dcl-S wkIndentType          Char(10)           inz;
   Dcl-S wkClKeywordPrv        Char(10)           inz;
   Dcl-S wkWriteFlg            Char(1)            inz;
   Dcl-S RcvFlg                Char(1)            inz;
   Dcl-S CpyFlg                Char(1)            inz;
   Dcl-S Flg3                  Char(1)            inz;
   Dcl-S SrcStmType            Char(10)           inz;
   Dcl-S wkParmPointer         Pointer            inz;
   Dcl-S wkWordsArray          Char(120) Dim(100) inz;
   Dcl-S PseudocodeArr         Char(120) Dim(100) inz;

   //Copybook declaration
/copy 'QCPYSRC/iaprderlog.rpgleinc'
   wkuDpsds.nbrparms = %parms;                                                           //0030
   EvaluatePSDS() ;                                                                      //0030

   wkParmDs.wkReqID             = wkparmClds.inReqId  ;
   wkParmDs.wkSrcMbr            = wkparmClds.inSrcMbr ;
   wkParmDs.wkSrcPf             = wkparmClds.inSrcPf  ;
   wkParmDs.wkSrcLib            = wkparmClds.inSrcLib ;
   wkParmDs.wksrcType           = wkparmClds.inSrcType ;
   wkParmDs.wkRrn               = wkparmClds.inRrn ;
   wkParmDs.wkRrnseq            = wkparmClds.inRrnSeq ;
   wkIndentParmDs.dsIndentLevel = wkparmClds.inIndentLevel;
   wkIndentParmDs.dsMaxLevel    = wkparmClds.inMaxLevel;
   wkIndentParmDs.dsIncrLevel   = wkparmClds.inIncrLevel;
   wkIndentParmDs.dsIndentArray = wkparmClds.inIndentArray;
   wkClStatement                = wkparmClds.inString ;
   wkLblName                    = wkparmClds.inLblName;
   wkWriteFlg                   = wkparmClds.inWriteFlg;
   wkClKeywordPrv               = inCLKeywordPrv;

   If wkClStatement = *Blanks;
      Return;
   EndIf;
   SrcStmType = 'CL';

   If wkLblName <> *Blanks;
      iAPsLabel(SrcStmType: wkLblName: wkSrcLabel);
   EndIf;

   GetWordsInArray(wkClStatement : wkWordsArray);
   wkClKeyword = wkWordsArray(1);

   RcvFlg = 'N';
   CpyFlg = 'N';
   Flg3 = 'N';

   If wkClKeyword = 'RCVF' or wkClKeyword = 'SNDF' or
      wkClKeyword = 'SNDRCVF' or wkClKeyword = 'RCLRSC';
     RcvFlg = 'Y';
   EndIf;

   If wkClKeyword = 'CPYF' or wkClKeyword = 'CPYTOIMPF' or
      wkClKeyword = 'CPYTOSTMF'or wkClKeyword = 'CPYFRMIMPF' or
      wkClKeyword = 'CPYFRMSTMF';
     CpyFlg = 'Y';
   EndIf;

   If wkClKeyword = 'ADDENVVAR' or wkClKeyword = 'CRTSRCPF'  or
      wkClKeyword = 'RUNSQL' or wkClKeyword = 'CHGLF' or
      wkClKeyword = 'CRTPGM' or wkClKeyword = 'CHGPF';
     Flg3 = 'Y';
   EndIf;

   CLKeywordMapping(wkClKeyword:SrcStmType:wkClStatement:
                    PseudocodeArr:wkCommentDesc:wkIndentType);

   Clear StrPseudocode;
   Inx = 1;
   Dow PseudocodeArr(Inx) <> ' ';
      If Inx = 1;
         StrPseudocode = %Trim(PseudocodeArr(Inx));
      ElseIf Inx = 2 and RcvFlg = 'Y';
         StrPseudocode = %Trim(StrPseudocode) + ' with ' +
                         %Trim(PseudocodeArr(Inx));
      ElseIf Inx = 4 and CpyFlg = 'Y';
         StrPseudocode = %Trim(StrPseudocode) + ' with parameters ' +
                         %Trim(PseudocodeArr(Inx));
      Else;
         StrPseudocode = %Trim(StrPseudocode) + ' ' +
                         %Trim(PseudocodeArr(Inx));
      EndIf;
      Inx += 1;
   Enddo;

   If StrPseudocode <> *Blanks;
     If wkSrcLabel <> *Blanks;
       wkIndentParmDs.dsPseudoCode = %Trim(wkSrcLabel) + ' ' +
                                       %Trim(StrPseudoCode);
     Else;
       wkIndentParmDs.dsPseudoCode = %Trim(StrPseudoCode);
     EndIf;
   Else;
     wkIndentParmDs.dsPseudoCode = wkClStatement;
   EndIf;

   If wkWriteFlg = 'Y';
      If wkIndentParmDs.dsIndentLevel <> *Zeros or
                         wkIndentType <> *Blanks;
         wkIndentParmDs.dsIndentType = wkIndentType;
         IOIndentParmPointer = %Addr(wkIndentParmDs);
         IaAddPseudocodeIndentation(IOIndentParmPointer);
         wkparmClds.inIndentLevel = wkIndentParmDs.dsIndentLevel;
         wkparmClds.inMaxLevel    = wkIndentParmDs.dsMaxLevel;
         wkparmClds.inIncrLevel   = wkIndentParmDs.dsIncrLevel;
         wkparmClds.inIndentArray = wkIndentParmDs.dsIndentArray;
      EndIf;

      If wkClKeyword <> wkClKeywordPrv And wkCommentDesc <> *Blanks;
         //Write the Header of Variable Declaration
         wkParmDs.wkPseudoCode = *Blanks;
         wkParmPointer = %Addr(wkParmDs);
         WritePseudoCode(wkParmPointer);

         wkParmDs.wkPseudoCode = wkCommentDesc;
         wkParmPointer = %Addr(wkParmDs);
         WritePseudoCode(wkParmPointer);
      EndIf;

      wkParmDs.wkPseudoCode = wkIndentParmDs.dsPseudoCode;
      wkParmPointer = %Addr(wkParmDs);
      WritePseudoCode(wkParmPointer);
   Else;
      wkparmClds.inString = %Trim(wkIndentParmDs.dsPseudoCode);
   EndIf;

   Return;
/copy 'QCPYSRC/iaprcerlog.rpgleinc'
End-Proc;
//------------------------------------------------------------------------------------- //
//IAPSDOLOOP: Pseudo code for Do Loop in CL                                             //
//------------------------------------------------------------------------------------- //
Dcl-Proc iAPsDoLoop export;

   Dcl-Pi *n;
      inParmCLds Pointer;
      inElseStmt Char(1);
      OutElseIndtFlg Char(1);
   End-Pi;

   Dcl-Ds wkparmClds Qualified Based(inParmCLds);
      inString      Char(5000);
      inReqId       Char(18);
      inSrcLib      Char(10);
      inSrcPf       Char(10);
      inSrcMbr      Char(10);
      inSrcType     Char(10);
      inRrn         Packed(6:0);
      inRrnSeq      Packed(6:2);
      inLblName     Char(25);
      inWriteFlg    Char(1);
      inIndentLevel Packed(5:0);
      inMaxLevel    Packed(5:0);
      inIncrLevel   Packed(5:0);
      inIndentArray Packed(5:0) Dim(999);
   End-Ds;

   Dcl-Ds wkParmDs Qualified Inz;
      wkReqId      Char(18);
      wkSrcLib     Char(10);
      wkSrcPf      Char(10);
      wkSrcMbr     Char(10);
      wksrcType    Char(10);
      wkRrn        Packed(6:0);
      wkRrnSeq     Packed(6:2);
      wkSrcLtyp    Char(5);
      wkSrcSpec    Char(1);
      wkSrcLnct    Char(1);
      wkPseudocode Char(cwSrcLength);
   End-Ds;

   Dcl-S wkClStatement  Char(5000)         Inz;
   Dcl-S wkClKeyword    Char(10)           Inz;
   Dcl-S wkClKeyword1   Char(10)           Inz;
   Dcl-S StrPseudoCode  Char(cwSrcLength)  Inz;
   Dcl-S PseudoCodeExp  Char(500)          Inz;
   Dcl-S wkCommentDesc  Char(100)          Inz;
   Dcl-S wkLblName      Char(20)           Inz;
   Dcl-S wkSrcLabel     Char(20)           Inz;
   Dcl-S CndInx         Zoned(4:0)         Inz;
   Dcl-S Inx            Zoned(4:0)         Inz;
   Dcl-S I              Zoned(4:0)         Inz;
   Dcl-S wkIndentType   Char(10)           Inz;
   Dcl-S IndentchkFlg   Char(1)            Inz;
   Dcl-S wkClKeywordPrv Char(10)           Inz;
   Dcl-S wkCond         Char(200)          Inz;
   Dcl-S wkcmdExec      Char(200)          Inz;
   Dcl-S wkCmdStr       Char(200)          Inz;
   Dcl-S ArrValue       Char(10)           Inz;
   Dcl-S OprChk         Char(1)            Inz;
   Dcl-S OpnBktFlg      Char(1)            Inz;
   Dcl-S ClsBktFlg      Char(1)            Inz;
   Dcl-S wkWriteFlg     Char(1)            Inz;
   Dcl-S WkElseStmt     Char(1)            Inz;
   Dcl-S wkElseIndtFlg  Char(1)            Inz;
   Dcl-S SrcStmType     Char(10)           Inz;
   Dcl-S wkParmPointer  Pointer            Inz;

   Dcl-C OpnBkt         '(';
   Dcl-C ClsBkt         ')';

   Dcl-S wkWordsArray  Char(120)  Dim(100) Inz;
   Dcl-S PseudocodeArr Char(120)  Dim(100) Inz;

   //Copybook declaration
/copy 'QCPYSRC/iaprderlog.rpgleinc'
   wkuDpsds.nbrparms = %parms;                                                           //0030
   EvaluatePSDS() ;                                                                      //0030

   wkParmDs.wkReqID             = wkparmClds.inReqId  ;
   wkParmDs.wkSrcMbr            = wkparmClds.inSrcMbr ;
   wkParmDs.wkSrcPf             = wkparmClds.inSrcPf  ;
   wkParmDs.wkSrcLib            = wkparmClds.inSrcLib ;
   wkParmDs.wksrcType           = wkparmClds.inSrcType ;
   wkParmDs.wkRrn               = wkparmClds.inRrn ;
   wkParmDs.wkRrnseq            = wkparmClds.inRrnSeq ;
   wkWriteFlg                   = wkparmClds.inWriteFlg;
   wkIndentParmDs.dsIndentLevel = wkparmClds.inIndentLevel;
   wkIndentParmDs.dsMaxLevel    = wkparmClds.inMaxLevel;
   wkIndentParmDs.dsIncrLevel   = wkparmClds.inIncrLevel;
   wkIndentParmDs.dsIndentArray = wkparmClds.inIndentArray;
   wkClStatement                = wkparmClds.inString ;
   wkLblName                    = wkparmClds.inLblName;
   wkWriteFlg                   = wkparmClds.inWriteFlg;
   wkElseStmt                   = inElseStmt;

   If wkClStatement = *Blanks;
      Return;
   EndIf;
   IndentChkFlg = 'Y';
   SrcStmType = 'CL';

   //Get Pseudo code for label if available
   If wkLblName <> *Blanks;
      iAPsLabel(SrcStmType: wkLblName: wkSrcLabel);
   EndIf;

   GetWordsInArray(wkClStatement : wkWordsArray);
   wkClKeyword = wkWordsArray(1);

   Clear wkSrcMap;
   Exec Sql
        Select  Src_Mapping ,
                Indent_Type
        Into  :wkSrcMap ,
              :WkIndentType
        From IaPseudoMP
        Where SrcMbr_Type = :SrcStmType
           And KeyField_1 = :wkClKeyword;

   if SqlCode < successCode;
      uDpsds.wkQuery_Name = wkClKeyword;
      IaSqlDiagnostic(uDpsds);
   EndIf;

   Clear wkCmdExec;
   If wkClKeyword = 'OTHERWISE';

     wkCmdExec = scanKeywordCL(' CMD(':wkClStatement);
     If wkCmdExec = *Blanks;
       wkCmdExec = scanKeywordCL(' (':wkClStatement);
     EndIf;
     wkIndentParmDs.dsPseudoCode = wkSrcMap;
     wkClKeyword1 = wkClKeyword;

   Else;
     wkCond = scanKeywordCL(' COND(':wkClStatement);

     //Condition start Index
     CndInx = 3;
     if wkCond = *Blanks;
        CndInx = 2;
        wkCond = scanKeywordCL(' (':wkClStatement);
     EndIf;


     Inx = CndInx;
     OprChk = 'Y';

     //Check If it is single expression with no operators
     If wkWordsArray(Inx+1) = ' ';
       StrPseudocode = %Trim(wkSrcMap) + ' ' +
                       %Trim(wkWordsArray(Inx)) + ' ' +
                       'is True';
       OprChk = 'N';
     EndIf;

     If wkWordsArray(Inx) = '*NOT' and wkWordsArray(Inx+2) = ' ';
       StrPseudocode = %Trim(wkSrcMap) + ' ' +
                       %Trim(wkWordsArray(Inx+1)) + ' ' +
                       'is False';
       OprChk = 'N';
     EndIf;

     //Get the command if it is IF statement
     IF wkClKeyword = 'IF' Or wkClKeyword = 'WHEN';
       WkCmdExec = scanKeywordCL(' THEN(':wkClStatement);
     EndIf;

     //Check for the operators If it is Long expression
     If OprChk = 'Y';

       Clear wkWordsArray;

       //Get the condition in Words array with Bracket
       GetWordsInArrayBkt(WkCond : wkWordsArray);
       Inx = 1;
       I = 1;

       Dow wkWordsArray(Inx) <> ' ';

         //Check for Brackets, Set the Flag 'Y' if available and replace it with blanks
         OpnBktFlg = 'N';
         ClsBktFlg = 'N';
         ArrValue = wkWordsArray(Inx);
         //Open Bracket check
         If %Scan('(':ArrValue) <> *Zeros;
           ArrValue =  %xlate('(' :' ':ArrValue);
           OpnBktFlg = 'Y';
         EndIf;

         //Close Bracket check
         If %Scan(')':ArrValue) <> *Zeros;
           ArrValue =  %xlate(')' :' ':ArrValue);
           ClsBktFlg = 'Y';
         EndIf;

         //Check the operator and assign value
         Select;
         When ArrValue = '=' or ArrValue = '*EQ';
           PseudocodeArr(i) = 'equals';
         When ArrValue = '>' or ArrValue = '*GT';
           PseudocodeArr(i) = 'greater than';
         When ArrValue = '<' or ArrValue = '*LT';
           PseudocodeArr(i) = 'less than';
         When ArrValue = '>=' or ArrValue = '*GE';
           PseudocodeArr(i) = 'greater than or equals';
         When ArrValue = '<=' or ArrValue = '*LE';
           PseudocodeArr(i) = 'less than or equals';
         When ArrValue = '¬=' or ArrValue = '*NE';
           PseudocodeArr(i) = 'not equals';
         When ArrValue = '¬>' or ArrValue = '*NG';
           PseudocodeArr(i) = 'not greater than';
         When ArrValue = '¬<' or ArrValue = '*NL';
           PseudocodeArr(i) = 'not less than';
         When ArrValue = '&' or ArrValue = '*AND';
           PseudocodeArr(i) = 'AND';
         When ArrValue = '*OR';
           PseudocodeArr(i) = 'OR';
         When ArrValue = '*NOT';
           PseudocodeArr(i) = 'NOT';
         Other;
           PseudocodeArr(i) = ArrValue;
         EndSl;

         //Check the Bracket Flag and add the same into the string
         If OpnBktFlg = 'Y';
           PseudocodeArr(i) = OpnBkt + %Trim(PseudocodeArr(i));
         EndIf;

         If ClsBktFlg = 'Y';
           PseudocodeArr(i) = %Trim(PseudocodeArr(i)) + ClsBkt;
         EndIf;

         //Populate the pseudo code for the condition
         If PseudoCodeExp = *Blanks;
           PseudoCodeExp = %Trim(PseudocodeArr(i));
         Else;
           PseudoCodeExp = %Trim(PseudoCodeExp) + ' ' +
                                    %Trim(PseudocodeArr(i));
         EndIf;
         I += 1;
         Inx += 1;

       Enddo;
       StrPseudocode = %Trim(wkSrcMap) + ' ' + %Trim(PseudoCodeExp);

     EndIf;

     //Add LABEL into the Source statement if available
     If wkSrcLabel <> *Blanks;
       wkIndentParmDs.dsPseudoCode = %Trim(wkSrcLabel) + ' ' +
                                           %Trim(StrPseudoCode);
     Else;
       wkIndentParmDs.dsPseudoCode = %Trim(StrPseudocode);
     EndIf;
   EndIf;

   wkElseIndtFlg = 'N';
   //Check if there is command to Execute for IF statements
   If wkCmdExec <> *Blanks;

      Select;
      //If execute cmd has GOTO statement, then call procedure IAPSGOTO to
      //populate the source statement
      When %Subst(wkCmdExec:1:5) = 'GOTO ';
         wkparmClds.inString = wkCmdExec;
         wkparmClds.inWriteFlg = *Blanks;
         IAPSGOTO(inParmCLds);
         wkIndentParmDs.dsPseudoCode = %Trim(wkIndentParmDs.dsPseudoCode)
                                       + ' ' + %Trim(wkparmClds.inString);

      //If execute cmd has DO statement,
      When %Subst(wkCmdExec:1:3) = 'DO ';

         wkIndentParmDs.dsPseudoCode = %Trim(wkIndentParmDs.dsPseudoCode)
                                        + ' ' +
                                       'then do execute the below statements';
         //Check IndentchkFlg and not add Indendation if it is called from
         //Else statements
         If wkElseStmt <> 'Y';
           wkIndentType = 'ADD';
           Exsr IndentCheck;
           //Set the IndentchkFlg to 'N'
           IndentchkFlg = 'N';
         Else;
           wkElseIndtFlg = 'Y';
         EndIf;

      //If execute cmd has DO statement,
      When %Subst(wkCmdExec:1:5) = 'CALL ';
         wkparmClds.inString = wkCmdExec;
         wkparmClds.inWriteFlg = *Blanks;
         Clear wkClKeywordPrv;
         IAPSCLMAP(inParmCLds:wkClKeywordPrv);
         If wkClKeyword1 = 'OTHERWISE';
           wkIndentParmDs.dsPseudoCode = %Trim(wkIndentParmDs.dsPseudoCode)
                                         + ' ' + %Trim(wkparmClds.inString);
         Else;
           wkIndentParmDs.dsPseudoCode = %Trim(wkIndentParmDs.dsPseudoCode)
                                         + ' then ' + %Trim(wkparmClds.inString);
         EndIf;

      Other;
         wkCmdStr = '"' + %Trim(wkCmdExec) + '"';
         wkIndentParmDs.dsPseudoCode = %Trim(wkIndentParmDs.dsPseudoCode)
                                       + ' then execute ' + %Trim(wkCmdStr);

      EndSl;

   EndIf;

   If IndentchkFlg = 'Y' and wkElseStmt = 'N';
     //Indentation Check
     Exsr IndentCheck;
   EndIf;

   If wkWriteFlg = 'Y';
      If wkClKeyword <> wkClKeywordPrv And wkCommentDesc <> *Blanks;
         //Write the Header of Variable Declaration
         wkParmDs.wkPseudoCode = *Blanks;
         wkParmPointer = %Addr(wkParmDs);
         WritePseudoCode(wkParmPointer);

         wkParmDs.wkPseudoCode = wkCommentDesc;
         wkParmPointer = %Addr(wkParmDs);
         WritePseudoCode(wkParmPointer);
      EndIf;

      wkParmDs.wkPseudoCode = wkIndentParmDs.dsPseudoCode;
      wkParmPointer = %Addr(wkParmDs);
      WritePseudoCode(wkParmPointer);
   Else;
      wkparmClds.inString = wkIndentParmDs.dsPseudoCode;
      OutElseIndtFlg = wkElseIndtFlg;
   EndIf;

   Return;

//------------------------------------------------------------------------------------- //
//IndentCheck - Subroutine to check the Indentation for the statement                   //
//------------------------------------------------------------------------------------- //
   Begsr IndentCheck;

      If wkIndentParmDs.dsIndentLevel <> *Zeros or
                         wkIndentType <> *Blanks;
        wkIndentParmDs.dsIndentType = wkIndentType;
        IOIndentParmPointer = %Addr(wkIndentParmDs);
        IaAddPseudocodeIndentation(IOIndentParmPointer);
        wkparmClds.inIndentLevel = wkIndentParmDs.dsIndentLevel;
        wkparmClds.inMaxLevel    = wkIndentParmDs.dsMaxLevel;
        wkparmClds.inIncrLevel   = wkIndentParmDs.dsIncrLevel;
        wkparmClds.inIndentArray = wkIndentParmDs.dsIndentArray;
      EndIf;

   EndSr;
/copy 'QCPYSRC/iaprcerlog.rpgleinc'
End-Proc;
//------------------------------------------------------------------------------------- //
//IAPSElse  : Else Statement                                                            //
//------------------------------------------------------------------------------------- //
Dcl-Proc IAPSElse export;

   Dcl-Pi *n;
      inParmCLds Pointer;
   End-Pi;

   Dcl-Ds wkparmClds Qualified based(inParmCLds);
     inString      Char(5000);
     inReqId       Char(18);
     inSrcLib      Char(10);
     inSrcPf       Char(10);
     inSrcMbr      Char(10);
     inSrcType     Char(10);
     inRrn         Packed(6:0);
     inRrnSeq      Packed(6:2);
     inLblName     Char(25);
     inWriteFlg    Char(1);
     inIndentLevel Packed(5:0);
     inMaxLevel    Packed(5:0);
     inIncrLevel   Packed(5:0);
     inIndentArray Packed(5:0) Dim(999);
   End-Ds;

   Dcl-Ds wkParmDs Qualified inz;
      wkReqId      Char(18);
      wkSrcLib     Char(10);
      wkSrcPf      Char(10);
      wkSrcMbr     Char(10);
      wksrcType    Char(10);
      wkRrn        Packed(6:0);
      wkRrnSeq     Packed(6:2);
      wkSrcLtyp    Char(5);
      wkSrcSpec    Char(1);
      wkSrcLnct    Char(1);
      wkPseudocode Char(cwSrcLength);
   End-Ds;

   Dcl-S wkParmPointer Pointer            inz;
   Dcl-S wkSrcMap1     Like(wkSrcMap)     inz;
   Dcl-S wkClStatement Char(5000)         inz;
   Dcl-S wkClKeyword   Char(10)           inz;
   Dcl-S StrPseudoCode Char(cwSrcLength)   inz;
   Dcl-S wkCommentDesc Char(100)          inz;
   Dcl-S Wkcmd         Char(100)          inz;
   Dcl-S wkCmdStr      Char(100)          inz;
   Dcl-S wkLblName     Char(20)           inz;
   Dcl-S wkSrcLabel    Char(20)           inz;
   Dcl-S wkWriteFlg    Char(1)            inz;
   Dcl-S StrPseudoCode1 Like(StrPseudoCode) inz;
   Dcl-S wkIndentType   Char(10)           inz;
   Dcl-S IndentchkFlg   Char(1)           inz;
   Dcl-S WkElseStmt     Char(1)           inz;
   Dcl-S ElsIndentFlg   Char(1)           inz;
   Dcl-S SrcStmType     Char(10)       inz;

   Dcl-S wkWordsArray  Char(120)  dim(100) inz;

   //Copybook declaration
/copy 'QCPYSRC/iaprderlog.rpgleinc'
   wkuDpsds.nbrparms = %parms;                                                           //0030
   EvaluatePSDS() ;                                                                      //0030

   wkParmDs.wkReqID   = wkparmClds.inReqId  ;
   wkParmDs.wkSrcMbr  = wkparmClds.inSrcMbr ;
   wkParmDs.wkSrcPf   = wkparmClds.inSrcPf  ;
   wkParmDs.wkSrcLib  = wkparmClds.inSrcLib ;
   wkParmDs.wksrcType = wkparmClds.inSrcType ;
   wkParmDs.wkRrn     = wkparmClds.inRrn ;
   wkParmDs.wkRrnseq  = wkparmClds.inRrnSeq ;
   wkIndentParmDs.dsIndentLevel = wkparmClds.inIndentLevel;
   wkIndentParmDs.dsMaxLevel    = wkparmClds.inMaxLevel;
   wkIndentParmDs.dsIncrLevel   = wkparmClds.inIncrLevel;
   wkIndentParmDs.dsIndentArray = wkparmClds.inIndentArray;
   wkClStatement      = wkparmClds.inString ;
   wkLblName          = wkparmClds.inLblName;

   if wkClStatement = *Blanks;
      Return;
   EndIf;
   IndentchkFlg = 'Y';
   SrcStmType = 'CL';

   //Get the Keyword name
   GetWordsInArray(wkClStatement : wkWordsArray);
   wkClKeyword = wkWordsArray(1);

   WkCmd   = scanKeywordCL(' CMD(':wkClStatement);
   If wkCmd = *Blanks;
     wkcmd = scanKeywordCL(' (':wkClStatement);
     If wkCmd = *Blanks;
       wkcmd  = wkWordsArray(2);
     EndIf;
   EndIf;

   Clear wkSrcMap1;
   Exec sql
        Select  Src_Mapping
          InTo  :wkSrcMap1
          From IaPseudoMP
         Where SrcMbr_Type = :SrcStmType
           And KeyField_1 = :wkClKeyword;

   If SqlCode < successCode;
      uDpsds.wkQuery_Name = wkClKeyword;
      IaSqlDiagnostic(uDpsds);
   EndIf;

   If wkcmd <> *Blanks;

      Select;
      //If execute cmd has GOTO statement, then call procedure IAPSGOTO to
      //populate the source statement
      when %Subst(wkCmd:1:5) = 'GOTO ';
         wkparmClds.inString = wkCmd;
         wkparmClds.inWriteFlg = *Blanks;
         iAPsGoto(inParmCLds);
         wkIndentParmDs.dsPseudoCode = %Trim(wkSrcMap1) + ' ' +
                                       %Trim(wkparmClds.inString);

      //If execute cmd has DO statement,
      when %Subst(wkCmd:1:3) = 'DO ';

         wkIndentParmDs.dsPseudoCode = %Trim(wkSrcMap1) + ' ' +
                                       'then do execute the below statements';
         wkIndentType = 'ADD';
         Exsr IndentCheck;
         //Set the IndentchkFlg to 'N'
         IndentchkFlg = 'N';

      when %Subst(wkCmd:1:3) = 'IF ';
         wkparmClds.inString = wkCmd;
         wkparmClds.inWriteFlg = *Blanks;
         wkElseStmt = 'Y';
         Clear ElsIndentFlg;
         iAPsDoLoop(inParmCLds:wkElseStmt:ElsIndentFlg);
         wkIndentParmDs.dsPseudoCode = %Trim(wkSrcMap1) + ' ' +
                                       %Trim(wkparmClds.inString);
         //Add Indentation after merging the statement with Else cmd
         If ElsIndentFlg = 'Y';
           wkIndentType = 'ADD';
           Exsr IndentCheck;
           //Set the IndentchkFlg to 'N'
           IndentchkFlg = 'N';
         EndIf;

      Other;
         wkCmdStr = '"' + %Trim(wkCmd) + '"';
         wkIndentParmDs.dsPseudoCode = %Trim(wkSrcMap1) + ' then execute ' +
                                       %Trim(wkCmdStr);

      EndSl;
   EndIf;

   If IndentchkFlg = 'Y';
     //Indentation Check
     Exsr IndentCheck;
   EndIf;

   wkParmDs.wkPseudoCode = wkIndentParmDs.dsPseudoCode;

   wkParmPointer = %Addr(wkParmDs);
   WritePseudoCode(wkParmPointer);

   Return;
//------------------------------------------------------------------------------------- //
//IndentCheck - Subroutine to check the Indentation for the statement                   //
//------------------------------------------------------------------------------------- //
   Begsr IndentCheck;

      If wkIndentParmDs.dsIndentLevel <> *Zeros or
                         wkIndentType <> *Blanks;
        wkIndentParmDs.dsIndentType = wkIndentType;
        IOIndentParmPointer = %Addr(wkIndentParmDs);
        IaAddPseudocodeIndentation(IOIndentParmPointer);
        wkparmClds.inIndentLevel = wkIndentParmDs.dsIndentLevel;
        wkparmClds.inMaxLevel    = wkIndentParmDs.dsMaxLevel;
        wkparmClds.inIncrLevel   = wkIndentParmDs.dsIncrLevel;
        wkparmClds.inIndentArray = wkIndentParmDs.dsIndentArray;
      EndIf;

   EndSr;
/copy 'QCPYSRC/iaprcerlog.rpgleinc'
End-Proc;
//------------------------------------------------------------------------------------- //
//IAPSEND   - Procedure for End statements                                              //
//------------------------------------------------------------------------------------- //
Dcl-Proc IAPSEND Export;

   Dcl-Pi *n;
      inParmCLds Pointer;
   End-Pi;

   Dcl-Ds wkparmClds Qualified based(inParmCLds);
      inString      Char(5000);
      inReqId       Char(18);
      inSrcLib      Char(10);
      inSrcPf       Char(10);
      inSrcMbr      Char(10);
      inSrcType     Char(10);
      inRrn         Packed(6:0);
      inRrnSeq      Packed(6:2);
      inLblName     Char(25);
      inWriteFlg    Char(1);
      inIndentLevel Packed(5:0);
      inMaxLevel    Packed(5:0);
      inIncrLevel   Packed(5:0);
      inIndentArray Packed(5:0) Dim(999);
   End-Ds;

   Dcl-Ds wkParmDs Qualified inz;
      wkReqId      Char(18);
      wkSrcLib     Char(10);
      wkSrcPf      Char(10);
      wkSrcMbr     Char(10);
      wksrcType    Char(10);
      wkRrn        Packed(6:0);
      wkRrnSeq     Packed(6:2);
      wkSrcLtyp    Char(5);
      wkSrcSpec    Char(1);
      wkSrcLnct    Char(1);
      wkPseudocode Char(cwSrcLength);
   End-Ds;

   Dcl-S wkParmPointer Pointer         inz;
   Dcl-S wkClStatement Char(5000)      inz;
   Dcl-S wkClKeyword   Char(10)        inz;
   Dcl-S wkLblName     Char(20)        inz;
   Dcl-S wkSrcLabel    Char(20)        inz;
   Dcl-S wkIndentType  Char(10)        inz;
   Dcl-S SrcStmType     Char(10)       inz;

   Dcl-S wkWordsArray  Char(120)  dim(100) inz;

   //Copybook declaration
/copy 'QCPYSRC/iaprderlog.rpgleinc'
   wkuDpsds.nbrparms = %parms;                                                           //0030
   EvaluatePSDS() ;                                                                      //0030

   wkParmDs.wkReqID   = wkparmClds.inReqId  ;
   wkParmDs.wkSrcMbr  = wkparmClds.inSrcMbr ;
   wkParmDs.wkSrcPf   = wkparmClds.inSrcPf  ;
   wkParmDs.wkSrcLib  = wkparmClds.inSrcLib ;
   wkParmDs.wksrcType = wkparmClds.inSrcType ;
   wkParmDs.wkRrn     = wkparmClds.inRrn ;
   wkParmDs.wkRrnseq  = wkparmClds.inRrnSeq ;
   wkIndentParmDs.dsIndentLevel = wkparmClds.inIndentLevel;
   wkIndentParmDs.dsMaxLevel    = wkparmClds.inMaxLevel;
   wkIndentParmDs.dsIncrLevel   = wkparmClds.inIncrLevel;
   wkIndentParmDs.dsIndentArray = wkparmClds.inIndentArray;
   wkClStatement      = wkparmClds.inString ;
   wkLblName          = wkparmClds.inLblName;

   if wkClStatement = *Blanks;
      Return;
   EndIf;
   SrcStmType = 'CL';

   If wkLblName <> *Blanks;
      IAPSLABEL(SrcStmType: wkLblName: wkSrcLabel);
   EndIf;

   GetWordsInArray(wkClStatement : wkWordsArray);
   wkClKeyword = wkWordsArray(1);

   Clear wksrcmap;
   Exec sql
     Select  Src_Mapping ,
             Indent_Type
       InTo  :wkSrcmap ,
             :WkIndentType
       From IaPseudoMP
      Where SrcMbr_Type = :SrcStmType
        And KeyField_1 = :wkClKeyword;

   If SqlCode < successCode;
     uDpsds.wkQuery_Name = wkClKeyword;
     IaSqlDiagnostic(uDpsds);
   EndIf;

   If wkSrcLabel <> *Blanks;
     wkIndentParmDs.dsPseudoCode = %Trim(wkSrcLabel) + ' ' +
                                            %Trim(wkSrcmap);
   Else;
     wkIndentParmDs.dsPseudoCode = %Trim(wkSrcmap);
   EndIf;

   If wkIndentParmDs.dsIndentLevel <> *Zeros or
                      wkIndentType <> *Blanks;
     wkIndentParmDs.dsIndentType = wkIndentType;
     IOIndentParmPointer = %Addr(wkIndentParmDs);
     IaAddPseudocodeIndentation(IOIndentParmPointer);
     wkparmClds.inIndentLevel = wkIndentParmDs.dsIndentLevel;
     wkparmClds.inMaxLevel    = wkIndentParmDs.dsMaxLevel;
     wkparmClds.inIncrLevel   = wkIndentParmDs.dsIncrLevel;
     wkparmClds.inIndentArray = wkIndentParmDs.dsIndentArray;
   EndIf;

   wkParmDs.wkPseudoCode = wkIndentParmDs.dsPseudoCode;

   wkParmPointer = %Addr(wkParmDs);
   WritePseudoCode(wkParmPointer);

   Return;
/copy 'QCPYSRC/iaprcerlog.rpgleinc'
End-Proc;
//------------------------------------------------------------------------------------- //
//IAPSLABEL - Procedure to get the Label for CL statement                               //
//------------------------------------------------------------------------------------- //
Dcl-Proc IAPSLABEL Export;

   Dcl-Pi IAPSLABEL;
     inSrcType       Char(10);
     inLblName       Char(20);
     OutSrcLabel     Char(20);
   End-Pi;

   //Declaration of work variables
   Dcl-S wkSrcType    Char(10) inz;
   Dcl-S wkLblName    Char(20) Inz;
   Dcl-S wkSrcLabel   Char(20) Inz;

   Dcl-C wkLabel      Const('LABEL');

   //Copybook declaration
/copy 'QCPYSRC/iaprderlog.rpgleinc'
   wkuDpsds.nbrparms = %parms;                                                           //0030
   EvaluatePSDS() ;                                                                      //0030

   wkSrcType  = inSrcType;
   wkLblName  = inLblName;

   Exec sql
     Select  Src_Mapping
       InTo  :wkSrcLabel
       From IaPseudoMP
      Where SrcMbr_Type = :wksrcType
        And KeyField_1 = :wkLabel;

   If SqlCode < successCode;
     uDpsds.wkQuery_Name = wkLabel;
     IaSqlDiagnostic(uDpsds);
   EndIf;

   If wkSrcLabel <> *Blanks;
     wkSrcLabel = %ScanRpl('&Var1':%Trim(wkLblName):wkSrcLabel);
   EndIf;
   OutSrcLabel = wkSrcLabel;

   Return;
/copy 'QCPYSRC/iaprcerlog.rpgleinc'
End-Proc;
//------------------------------------------------------------------------------------- //
//CLKeywordMapping - Procedure to get pseudo code for 2nd level keyword mapping         //
//------------------------------------------------------------------------------------- //
Dcl-Proc CLKeywordMapping Export;

   Dcl-Pi CLKeywordMapping;
      inCLkeyword       Char(10);
      inSrcType         Char(10);
      inClStatement     Char(5000);
      outPseudocodeArr  Char(120)  Dim(100);
      outCommentDesc    Char(100);
      outIndentType     Char(10);
   End-Pi;

   //Declaration of work variables
   Dcl-S wkClStatement     Char(5000)       inz;
   Dcl-S wkStatement       Char(5000)       inz;
   Dcl-S wkIndentType      Char(10)         inz;
   Dcl-S wkSearchFld1      Char(10)         inz;
   Dcl-S wkSearchFld2      Char(10)         inz;
   Dcl-S wkSearchFld3      Char(10)         inz;
   Dcl-S wkSearchFld4      Char(10)         inz;
   Dcl-S wkSrhIndex        Packed(3:0)      inz;
   Dcl-S wkMaxSrhCount     Packed(3:0)      inz;
   Dcl-S ArrSearchFld      Char(10) Dim(99) Inz;
   Dcl-S wkKeyList         Char(10)         Inz;
   Dcl-S wkClKeyword       Char(10)         Inz;
   Dcl-S wksrcType         Char(10)         Inz;
   Dcl-S wk2ndLevelMapping Char(200)        Inz;
   Dcl-S wkVar1            Char(200)        Inz;
   Dcl-S wkKWD1            Char(30)         Inz;
   Dcl-S wktempval         Char(200)        Inz;
   Dcl-S wkScanPos         Packed(3:0)      Inz;
   Dcl-S wkKeyword         Char(13)         Inz;
   Dcl-S KeywordUsed       Char(1)          Inz;
   Dcl-S SkipMap           Char(1)          Inz;
   Dcl-S wkCommentDesc     Char(100)        Inz;
   Dcl-S wkParmList        Char(80)         inz;
   Dcl-S count             Zoned(4:0)       inz(1);
   Dcl-S Inx               Zoned(4:0)       inz(1);
   Dcl-S WordInx           Zoned(4:0)       inz;
   Dcl-S wkSeqNo           Zoned(4:0)       inz;
   Dcl-S StrPos            Zoned(4:0)       inz;
   Dcl-S EndPos            Zoned(4:0)       inz;
   Dcl-S wkkeylen          Zoned(4:0)       inz;
   Dcl-S Totlen            Zoned(4:0)       inz;
   Dcl-S KeywrdPos         Zoned(4:0)       inz;
   Dcl-S wkParamSeq        Zoned(5:0)       inz;

   Dcl-S wkParmArray    Char(120)  dim(100) inz;
   Dcl-S PseudoCodeArr  Char(120)  dim(100) inz;
   Dcl-S wkWordsArray   Char(120)  dim(100) inz;

   //Copybook declaration
/copy 'QCPYSRC/iaprderlog.rpgleinc'
   wkuDpsds.nbrparms = %parms;                                                           //0030
   EvaluatePSDS() ;                                                                      //0030

   wkClKeyword = inCLkeyword;
   wkClStatement = inClStatement;
   wksrcType = inSrcType ;

   //Get Pseudo code for command with 2nd level keyword mapping
   exec sql
      Select  Src_Mapping ,
              Indent_Type ,
              Search_Fld1 ,
              Search_Fld2 ,
              Search_Fld3 ,
              Search_Fld4 ,
              Comment_Desc
      InTo    :wkSrcMap     ,
              :wkIndentType ,
              :wkSearchFld1 ,
              :wkSearchFld2 ,
              :wkSearchFld3 ,
              :wkSearchFld4 ,
              :wkCommentDesc
      From IaPseudoMP
      Where SrcMbr_Type = :wksrcType And
            KeyField_1 = :wkClKeyword;

   if SqlCode < successCode;
      uDpsds.wkQuery_Name = wkClKeyword;
      IaSqlDiagnostic(uDpsds);
   EndIf;

   Inx = 1;
   If wkSrcmap <> *Blanks;
      PseudoCodeArr(Inx) = wkSrcMap;
      Inx += 1;
   EndIf;

   // Check for any 2nd level mapping required for this keyword
   If wkSearchFld1 <> *Blanks Or wkSearchFld2 <> *Blanks Or
      wkSearchFld3 <> *Blanks Or wkSearchFld3 <> *Blanks;

      wkSrhIndex = *Zeros;
      If wkSearchFld1 <> *Blanks;
         wkSrhIndex += 1;
         ArrSearchFld(wkSrhIndex)  =  wkSearchFld1;
      EndIf;

      If wkSearchFld2 <> *Blanks;
         wkSrhIndex += 1;
         ArrSearchFld(wkSrhIndex)  =  wkSearchFld2;
      EndIf;

      If wkSearchFld3 <> *Blanks;
         wkSrhIndex += 1;
         ArrSearchFld(wkSrhIndex)  =  wkSearchFld3;
      EndIf;

      If wkSearchFld4 <> *Blanks;
         wkSrhIndex += 1;
         ArrSearchFld(wkSrhIndex)  =  wkSearchFld4;
      EndIf;

      // Get the max index for the loop
      wkMaxSrhCount = wkSrhIndex;

      For wkSrhIndex = 1 to wkMaxSrhCount;
         wkKeyList   =  ArrSearchFld(wkSrhIndex);
         //Declare the cursor to select the 2n level Pseudocode mapping
         Exec sql
              Declare IaPseudoMPC2 Scroll Cursor for
                 Select Seq_No   ,
                        KeyField_2 ,
                        Src_Mapping
                 From IaPseudoMP
                 Where SrcMbr_Type = :wksrcType And
                        KeyField_1 = :wkKeyList
                 Order by Seq_No
                 For Fetch Only;

         Exec sql
              Open IaPseudoMPC2;

         Exec sql
              Fetch First From IaPseudoMPC2 Into :wkSeqNo ,
                                                :wkKwd1 ,
                                                :wk2ndLevelMapping;

         KeywordUsed = 'N';
         wkClStatement = %Trim(wkClStatement);
         //Get the CL statement excluding CL command name
         If wkStatement = *Blanks;
           StrPos = %len(%Trim(wkClKeyword)) + 1;
           wkStatement = %Subst(wkClStatement:StrPos:
                           (%len(%Trim(wkClStatement)) - (StrPos-1)));
         EndIf;

         If wkStatement <> *Blanks;
           Dow SqlCode = successCode;
             If wkKwd1 <> *Blanks;

               SkipMap = 'N';
               wkKeyword = %Trim(wkKwd1) + '(  ';
               wkScanPos = %Scan(%Trim(wkKeyword):wkStatement:1);

               If wkScanPos = *zeros and KeywordUsed <> 'Y';

                 //Process below if 2nd level keyword is not mentioned but used
                 Clear wkKeyLen;
                 Clear StrPos;
                 Clear EndPos;
                 wkStatement = %Trim(wkStatement);
                 StrPos = %Check(' ':wkStatement);
                 //Get the value of 2nd level keyword
                 If %Subst(wkStatement:StrPos:1) = '(';
                   wkVar1 = scanKeywordCL('(':wkStatement);
                   wkKeyLen = %Len(%Trim(wkVar1)) + 2;
                 Else;
                   EndPos = %Scan(' ':wkStatement:StrPos);
                   wktempVal = %Subst(wkStatement:StrPos:EndPos);
                   KeywrdPos = %Scan('(':wktempVal);
                   If KeywrdPos = *zeros;
                     GetWordsInArray(wkStatement : wkwordsArray);
                     wkVar1 = wkwordsArray(1);
                     wkKeyLen = %Len(%Trim(wkVar1));
                   Else;
                     //Set the Flag if keyword mentioned is not configured in IaPseudoMP file
                     KeywordUsed = 'Y';
                     SkipMap = 'Y';
                   EndIf;
                 EndIf;

                 //Set the used portion of statement to blanks
                 TotLen = %len(%Trim(wkstatement)) - wkKeyLen;
                 If TotLen > *zeros;
                   wkstatement = %Subst(%Trim(wkstatement):wkKeyLen+1:
                                                           TotLen);
                 Else;
                   wkstatement = *Blanks;
                 EndIf;

               //Process below if 2nd level keyword is not mentioned
               ElseIf wkScanPos > *zeros;
                 wkVar1 = scanKeywordCL(wkKeyword:wkStatement);
                 KeywordUsed = 'Y';
               Else;
                 SkipMap = 'Y';
               EndIf;

               // Get the list of parameters
               If SkipMap <> 'Y';
                 If wkKwd1 = 'PARM';
                    Clear wkParmArray;
                    GetWordsInArray(wkVar1 : wkParmArray);
                    If %lookup(' ': wkParmArray ) > 2;
                       // Load the parameters into an array
                       Clear wkVar1;
                       dow wkparmArray(count) <> ' ';
                          If count = 1;
                             wkParmList = %Trim(wkparmArray(count));
                          Else;
                             wkParmList = %Trim(wkParmList) + ', ' +
                                                %Trim(wkparmArray(count));
                          EndIf;
                          count += 1;
                       enddo;
                       wkVar1 = wkParmList;
                    EndIf;
                 EndIf;

                 // Keyword found for the 2nd level Pseudocode mapping
                 If %Scan('&Var1' : wk2ndLevelMapping : 1) > *Zeros;

                   //Map the variable to the Pseudcode
                   If wkVar1  <> *Blanks;
                      wk2ndLevelMapping = %ScanRpl('&Var1':%Trim(wkVar1)
                                                   :wk2ndLevelMapping);
                      PseudoCodeArr(Inx) = %Trim(wk2ndLevelMapping);
                      Inx += 1;

                   EndIf;

                 Else;
                   PseudoCodeArr(Inx) = %Trim(wk2ndLevelMapping);
                   Inx += 1;
                 EndIf;
               EndIf;
             EndIf;

             If wkstatement = *Blanks;
               Leave;
             EndIf;

             Exec sql
                Fetch Next From IaPseudoMPC2 Into :wkSeqNo,
                                                  :wkKwd1,
                                                  :wk2ndLevelMapping;
           EndDo;
         EndIf;

         Exec sql
              Close IaPseudoMPC2;

      EndFor;

      outPseudoCodeArr = PseudoCodeArr;
      outCommentDesc   = wkCommentDesc;
      outIndentType    = wkIndentType;

   EndIf;

   Return;
/copy 'QCPYSRC/iaprcerlog.rpgleinc'
End-Proc;
//------------------------------------------------------------------------------------- //
//GetWordsInArrayBkt : Break the cl statement in words and Return the array with bkt    //
//------------------------------------------------------------------------------------- //
Dcl-Proc GetWordsInArrayBkt export;

   Dcl-Pi *n;
      wClStatement Char(5000) Const;
      wWordsArray  Char(120)  dim(100);
   End-Pi;

   Dcl-S wkClStm  Char(5000) Inz;
   Dcl-S wkstrPos Zoned(4:0) inz(1);
   Dcl-S wkEndPos Zoned(4:0) inz(1);
   Dcl-S wkindex  Zoned(3:0) inz;

   //Copybook declaration
/copy 'QCPYSRC/iaprderlog.rpgleinc'
   wkuDpsds.nbrparms = %parms;                                                           //0030
   EvaluatePSDS() ;                                                                      //0030

   If wClStatement = *Blanks;
      Return;
   EndIf;

   wkclstm = wClStatement;
   Dow wkEndPos > *zeros and wkStrPos > *zeros;
      wkStrPos = %Check(' ' :wkClstm :WkEndPos);
      If wkStrPos > *zeros;
         wkEndPos = %Scan(' ' :wkClStm :WkStrPos);
         If wkEndPos > *zeros and wkEndPos > wkStrPos;
            wkIndex += 1;
            If wkIndex <= %elem(wWordsArray);
               wWordsArray(wkIndex) = %Subst(wkClStm :wkStrPos:
                                                 wkEndPos - wkStrPos);
            EndIf;
         EndIf;
      EndIf;
   EndDo;

/copy 'QCPYSRC/iaprcerlog.rpgleinc'
End-Proc;

//------------------------------------------------------------------------------------- //
//ScankeyWordCL - Scan the Keyword and get the Value                                    //
//------------------------------------------------------------------------------------- //
Dcl-Proc ScanKeyWordCL Export;

   Dcl-Pi *n varChar(5000);
      Keyword Char(12) Const;
      wkClStatement Char(5000) Const;
   End-Pi;

   Dcl-S wkKeyword Char(12)   Inz;
   Dcl-S wkResult  Char(5000) Inz;
   Dcl-S wkStrPos  Zoned(4:0) Inz;
   Dcl-S wkEndPos  Zoned(4:0) Inz;
   Dcl-S wkStrpos1 Zoned(4:0) Inz;

   //Copybook declaration
/copy 'QCPYSRC/iaprderlog.rpgleinc'
   wkuDpsds.nbrparms = %parms;                                                           //0030
   EvaluatePSDS() ;                                                                      //0030

   If wkKeyword = *Blanks and wkClStatement = *Blanks;
      wkResult = *Blanks;
      Return wkResult;
   EndIf;

   wkKeyword = Keyword;
   wkStrPos  = %Scan(%Trimr(wkKeyword):wkClStatement:1);
   if wkStrPos > *zeros;
      wkStrPos  = wkStrPos + %len(%Trimr(wkkeyword));
      wkStrPos1 = wkStrPos;

      Dow wkStrpos1 > *Zeros;
         If wkEndpos > *Zeros;
            wkStrPos1 = wkEndPos + 1;
         EndIf;

         wkEndPos = %Scan(')' : wkClStatement : wkStrPos1);
         If wkEndPos > 0;
            wkStrPos1 = %Scan('(' : wkClStatement: wkStrPos1);
            if wkStrPos1 > wkEndPos;
               wkStrPos1 = 0;
            EndIf;
         Else;
            wkEndPos = %Len(wkClstatement);
            Leave;
         EndIf;
      EndDo;

      If wkEndPos - wkStrPos > *Zeros and wkStrPos > *Zeros;                             //0022
         wkResult = %Subst(wkClstatement:wkStrPos:wkEndPos-wkStrPos);
      EndIf;
   EndIf;

   Return wkResult;
/copy 'QCPYSRC/iaprcerlog.rpgleinc'
End-Proc;

//------------------------------------------------------------------------------------- //
//IAPSBIF - Procedure to get source statement for Builtin Function                      //
//------------------------------------------------------------------------------------- //
Dcl-Proc iAPsBif Export;

   Dcl-Pi *n;
      inSrcType Char(10);
      inValue   Char(5000);
      outSrcBif Char(5000);
   End-Pi;

   Dcl-S wkSrcVal  Char(5000) Inz;
   Dcl-S wkSrcVal1 Char(5000) Inz;
   Dcl-S wkSrcVal2 Char(5000) Inz;
   Dcl-S wkResult  Char(5000) Inz;
   Dcl-S wkSrcBif  Char(5000) Inz;
   Dcl-S wkValue   Char(5000) Inz;
   Dcl-S wkVar1    Char(5)    Inz;
   Dcl-S wkBif     Char(20)   Inz;
   Dcl-S wkBifKwd  Char(20)   Inz;
   Dcl-S wkSrcType Char(10)   Inz;
   Dcl-S BifEndPos Zoned(4:0) Inz;
   Dcl-S wkLen     Zoned(4:0) Inz;
   Dcl-S Inx       Zoned(4:0) Inz;
   Dcl-S wkElem    Zoned(4:0) Inz;
   Dcl-S StrPos    Zoned(4:0) Inz;
   Dcl-S EndPos    Zoned(4:0) Inz;

   Dcl-S wkWordsArray  Char(120)  Dim(100) Inz;

   //Copybook declaration
/copy 'QCPYSRC/iaprderlog.rpgleinc'
   wkuDpsds.nbrparms = %parms;                                                           //0030
   EvaluatePSDS() ;                                                                      //0030

   wkSrcVal = inValue;
   wkSrcType = inSrcType;

   If wkSrcVal <> *Blanks;

     BifEndPos = %Scan('(' : wkSrcVal);
     If BifEndPos > 1;                                                                   //0022
        wkBif = %Subst(wkSrcVal: 1 :BifEndPos-1);                                        //0022
     EndIf;                                                                              //0022
     wkBifKwd = %Trim(wkBif) + '(';

     wkSrcVal1 = ScanKeywordCL(wkBifkwd : wkSrcVal);

     wkBif = %Trim(wkBif);
     Clear wkValue;
     wkSrcVal2 = %Trim(wkBif) + '(' + %Trim(wkSrcVal1) + ')';
     StrPos = %Len(%Trim(wkSrcVal2));
     wkLen = %Len(%Trim(wkSrcVal)) - StrPos;
     If wkLen > *zeros;
       wkValue = %Subst(wkSrcVal: StrPos+1: wkLen);
     EndIf;

     Exec sql
       Select  Src_Mapping
         Into  :wkSrcBif
         From IaPseudoMP
        Where SrcMbr_Type = :wksrcType
          And (KeyField_1 = :wkBif
           Or  KeyField_2 = :wkBif);

     If SqlCode < SuccessCode;
       uDpsds.wkQuery_Name = wkBif;
       IaSqlDiagnostic(uDpsds);
     EndIf;

     If wkSrcBif <> *Blanks;
       wkSrcVal1 = %ScanRpl('" "' : 'BLNK' : wkSrcVal1);
       Clear wkWordsArray;
       GetWordsInArray(wkSrcVal1 : wkWordsArray);
       wkElem = %Lookup(' ':wkWordsArray);
       wkElem -= 1;

       Select;
       When wkelem = 1;
         EndPos = %Scan('&Var1': wkSrcBif);
         wkSrcBif = %Subst(wkSrcBif:1: EndPos+5);
       When wkelem = 2;
         EndPos = %Scan('&Var2': wkSrcBif);
         wkSrcBif = %Subst(wkSrcBif:1: EndPos+5);
       When wkelem = 3;
         EndPos = %Scan('&Var3': wkSrcBif);
         wkSrcBif = %Subst(wkSrcBif:1: EndPos+5);
       EndSl;

       Inx = 1;
       Dow wkWordsArray(Inx) <> ' ';
         If wkWordsArray(Inx) = 'BLNK';
           wkWordsArray(Inx) = '" "';
         EndIf;
         wkVar1 = '&Var' + %Trim(%Char(Inx));
         wkSrcBif = %ScanRpl(wkVar1:%Trim(wkWordsArray(Inx))
                                                  :wkSrcBif);
         Inx += 1;
       Enddo;
       If wkValue <> *Blanks;
         wkSrcBif = %Trim(wkSrcBif) + ' ' + %Trim(wkValue);
       EndIf;

     Else;
       wkSrcBif = inValue;
     EndIf;
     OutSrcBif = wkSrcBif;

   EndIf;
   Return;

/copy 'QCPYSRC/iaprcerlog.rpgleinc'
End-Proc;

//------------------------------------------------------------------------------------- //
//Procedure to Parse Fixed format RPGLE code to Write Pseudocode                        //
//------------------------------------------------------------------------------------- //
Dcl-Proc IaFixedFormatParser  Export ;

   Dcl-Pi *n Ind;
        inParmPointer Pointer;
   End-Pi;

   //Input Parameter Data Structure
   Dcl-Ds wkFX4ParmDs Qualified Based(inParmPointer);
      dsReqId        Char(18);
      dsSrcLib       Char(10);
      dsSrcPf        Char(10);
      dsSrcMbr       Char(10);
      dsSrcType      Char(10);
      dsSrcRrn       Packed(6:0);
      dsSrcSeq       Packed(6:2);
      dsSrcLtyp      Char(5);
      dsSrcSpec      Char(1);
      dsSrcLnct      Char(1);
      dsSrcDta       VarChar(cwSrcLength);
      dsIOIndentParmPointer Pointer;                                                     //0038
      dsDclType      Char(10);
      dsSubType      Char(10);
      dsHCmtReqd     Char(1);
      dsSkipNxtStm   ind;                                                                //0009
      dsFileNames    char(10) dim(99);                                                   //0009
      dsFileCount    zoned(2:0);                                                         //0009
      dsName         Char(50);                                                           //0010
   End-Ds;

   //Datastructure to hold nested Bif                                                   //0047
   Dcl-Ds DsNestedBif    Occurs(100) ;                                                   //0047
     wDsBifNumber      Packed(5:0);                                                      //0047
     wDsPercentPos     Packed(5:0);                                                      //0047
     wDsBifName        Char(10);                                                         //0047
     wDsOpenParPos     Packed(5:0);                                                      //0047
     wDsCloseParPos    Packed(5:0);                                                      //0047
     wDsBifFull        VarChar(200);                                                     //0047
     wDsBifMap         VarChar(200);                                                     //0047
     wDsBifPseudocode  VarChar(cwSrcLength) Inz;                                         //0066
   End-Ds;                                                                               //0047

   //Copy of C spec DS for checking the looping
   dcl-Ds ChkCSpecDsV4 likeds(CSpecDsV4);                                                //0009
   Dcl-Ds wkRPGIndentParmDS  LikeDs(RPGIndentParmDSTmp);                                 //0038
   //Data structures to hold file level information as per new format                   //0091
   Dcl-Ds dsFSpecLFNewFormat likeDS(TdsFSpecLFNewFormat)   Inz(*likeDS) ;                //0091
   Dcl-Ds dsFSpecKeywords    likeDS(TdsFSpecKeywords)   Dim(99)                          //0091
                             Inz(*likeDS) ;                                              //0091
   Dcl-Ds dsFSpecDsV4        likeDS(FSpecDsV4) Inz(*likeDS) ;                            //0091
                                                                                         //0091
   //Declaration of work variables
   Dcl-S  wkPseudoCode          Char(cwSrcLength)    Inz;
   Dcl-S  wkPrefixPseudoCode    Char(cwSrcLength)    Inz;                                //0061
   Dcl-S  wkSuffixPseudoCode    Char(cwSrcLength)    Inz;                                //0061
   Dcl-S  wkSuffixArg           Char(10)             Inz;                                //0061
   Dcl-S  wkKeywordOpcode       Char(10)             Inz;                                //0099
   Dcl-S  wkPrefixActionType    Char(10)             Inz;                                //0099
   Dcl-S  wkSuffixActionType    Char(10)             Inz;                                //0099
   Dcl-S  wkDclTypeBackup       Char(10)             Inz;
   Dcl-S  wkKeyword             Char(37)             Inz;
   Dcl-S  wkKeywordStr          Char(37)             Inz;                                //0063
   Dcl-S  wkKeywordVal          Char(37)             Inz;                                //0063
   Dcl-S  wkDsKeyword           Char(37)             Inz;
   Dcl-S  wkSrcMtyp             Char(10);
   Dcl-S  wkSrcLnct             Char(1);
   Dcl-S  wkIndentTypeBackup    Char(10);
   Dcl-S  wkKeyList             Char(10);
   Dcl-S  wkKeywordtoLookup     Char(10);
   Dcl-S  wk2ndLevelMapping     Char(200);
   Dcl-S  wkPrvDclType          Char(10)      Inz;
   Dcl-S  wkPrvSubType          Char(10)      Inz;
   Dcl-S  wkSrcMbr              Char(10)      Inz;
   Dcl-S  wkBuiltParm           Char(37)      Inz;
   Dcl-S  wkObjname             Char(20)      Inz;
   Dcl-S  wkObjDesc             Char(50)      Inz;
   Dcl-S  wkDspos               Char(7)       Inz;
   Dcl-S  wkDclerror            Char(7)       Inz;
   Dcl-S  wkFileKey             Char(4)       Inz;                                       //0045
   Dcl-S  wkFName               Char(11)      Inz;
   Dcl-S  wkFMode               Char(8)       Inz;                                       //0045
   Dcl-S  wkFRcdFormat          Char(24)      Inz;
   Dcl-S  wkFDevice             Char(11)      Inz;
   Dcl-s  wkDName               Char(50)      Inz;
   Dcl-S  wkDataType            Char(5)       Inz;                                       //0011
   Dcl-S  wkDSpecLength         Char(7)       Inz;                                       //0011
   Dcl-S  wkDSpecPosition       Char(4)       Inz;                                       //0011
   Dcl-S  wkDSpecDim            Char(4)       Inz;                                       //0011
   Dcl-S  wkSubDclType          Char(10)      Inz;
   Dcl-S  wkSubKeyword          Char(37)      Inz;
   Dcl-S  wkSubKeywordStr       Char(37)      Inz;
   Dcl-S  wkNonBlankDclType     Char(10)      Inz;
   Dcl-S  wkCLoopSrcDta         Char(132)     Inz;                                       //0009
   Dcl-S  wkIFOpcodeFlag        Char(1)       Inz;                                       //0077
   Dcl-S  wkIFOpSrcDta          Char(132)     Inz;                                       //0077

   Dcl-S  ArrSearchFld          Char(10)      Dim(99);
   Dcl-S  wkArray               Char(50)      Inz Dim(50);
   Dcl-S  wkFileAttribute       Char(10)      Inz;                                       //0043
   Dcl-S  wkIndexFlag           Char(1)       Inz;                                       //0043
   Dcl-S  wkTmpIndicatorNam     Char(3)       Inz;                                       //0061
   Dcl-S  wkN01SrcMap           Char(100)     Inz;                                       //0075
   Dcl-S  wkN01Mapping          Char(30)      Inz;                                       //0075
   Dcl-S  wkHLEValue            Char(20)      Inz;                                       //0076

   Dcl-S  wkSrcMap              VarChar(cwSrcLength);
   Dcl-S  wkSrcDta              VarChar(cwSrcLength) Inz;
   Dcl-S  wkPseudoCode1         VarChar(cwSrcLength) Inz;
   Dcl-S  wkPseudoCode2         VarChar(cwSrcLength) Inz;
   Dcl-S  wkN01PseudoCode       VarChar(cwSrcLength) Inz;                                //0075
   Dcl-S  wkSrcdtaUpper         VarChar(cwSrcLength);
   Dcl-S  wkAppendText          VarChar(10)          Inz;
   Dcl-S  wkBuiltin             VarChar(10)          Inz;

   Dcl-S  wkIndex               Packed(2:0)   Inz;
   Dcl-S  wkStrPos              Packed(5:0)   Inz;                                       //0001
   Dcl-S  wkEndPos              Packed(5:0)   Inz;                                       //0001
   Dcl-S  wkSrhIndex            Packed(3:0)   Inz;
   Dcl-S  wkMaxSrhCount         Packed(3:0)   Inz;
   Dcl-S  wkScanPos             Packed(5:0)   Inz;                                       //0001
   Dcl-S  wkIndentLevel         Packed(5:0)   Inz;
   Dcl-S  wkDocumentSeq         Packed(6:0)   Inz;
   Dcl-S  wkBltPos1             Packed(5:0)   Inz;                                       //0001
   Dcl-S  wkBltPos2             Packed(5:0)   Inz;                                       //0001
   Dcl-S  wkBltPos3             Packed(5:0)   Inz;                                       //0001
   Dcl-S  wkCheckpos            Packed(5:0)   Inz;                                       //0001
   Dcl-S  wkSpecHeaderPos       Packed(5:0)   Inz;                                       //0001
   Dcl-S  wkRowsFound           Packed(3:0)   Inz;
   Dcl-S  wkCloseBrPos          Packed(5:0)   Inz;                                       //0001
   Dcl-S  wkOpenBrPos           Packed(5:0)   Inz;                                       //0001
   Dcl-S  wkNonBlankPos         Packed(5:0)   Inz;                                       //0001
   Dcl-S  wkBlankPos            Packed(5:0)   Inz;                                       //0001
   Dcl-S  wkIdx                 Packed(5:0)   Inz;                                       //0038
   Dcl-S  wkIdx2                Packed(5:0)   Inz;                                       //0061
   Dcl-S  wkReqId               Packed(18:0)  Inz;
   Dcl-S  wkDataTypeElem        Zoned(4:0)    Inz;                                       //0052
   Dcl-S  wkResultIndElem       Zoned(4:0)    Inz;                                       //0099

   Dcl-S  RcdFound              Ind           Inz;
   Dcl-S  wkFlag                Ind           Inz;
   Dcl-S  wkAppendFlag          Ind           Inz;
   Dcl-S  wkLevel2FoundInd      Ind           Inz;                                       //0009
   Dcl-S  wkMappingFoundInd     Ind           Inz;                                       //0042
   Dcl-S  wkSkipBlankLineInd    Ind           Inz;                                       //0077
   Dcl-S  wkRIFact2Ind          Ind           Inz(*Off);                                 //0099

   Dcl-S  IOParmPointer         Pointer       Inz(*Null);
   Dcl-S  OutParmPointer        Pointer       Inz;
   Dcl-S  wkIOIndentParmPointer Pointer       Inz;                                       //0038

   Dcl-S  IOBIFParmPointer     Pointer inz(*Null);                                       //0047
   Dcl-s  OutMaxBif            Packed(3:0) Inz;                                          //0047
   Dcl-S  wkForIndex           Packed(3:0) Inz;                                          //0047
   Dcl-S  wkSrcDtaBIF          varChar(cwSrcLength) Inz;                                 //0047
   Dcl-S  wkSavIndentType      Char(10)    Inz;                                          //0047
   Dcl-S  wkBIFCommentDes      Char(cwSrcLength) Inz;                                    //0079
   Dcl-S  wkFXOpcode           Char(20)          Inz;                                    //0079
   Dcl-S  wkFXBif              VarChar(cwSrcLength);                                     //0079
   Dcl-S  wkSrcRrn             Packed(6:0) Inz ;                                         //0083
   Dcl-S  wkSavCategory        Char(10)    Inz ;                                         //0083
   Dcl-S  wkCallMode           Char(1)     Inz ;                                         //0091
   Dcl-S  wkKeyWrdPointer      Pointer     Inz ;                                         //0091
   Dcl-S  wkKeyWrdCntr         Packed(2:0) Inz ;                                         //0091
   Dcl-S  wkSrcStmt            Char(200)   Inz ;                                         //0091
   Dcl-s  WkConstValue         VarChar(cwSrcLength) Inz;                                 //0096

   //Declaration of Constant
   Dcl-C  cwAppendText       Const(', ');
   Dcl-C  cwErrorHandle      Const('P ');                                                //0016
   Dcl-C  cwDelimiter        Const('| ');
   Dcl-C  cwInd              Const('N');                                                 //0011
   Dcl-C  cwPrtCmntAftr      Const('CMNTAFTER');                                         //0024
   Dcl-C  cwConst            Const('CONST:');                                            //0011
   Dcl-C  cwDisk             Const('DISK');                                              //0043
   Dcl-C  cwPF               Const('PF');                                                //0043
   Dcl-C  cwLF               Const('LF');                                                //0043
   Dcl-C  cwINDEX            Const('IX');                                                //0043
   Dcl-C  cwVIEW             Const('VW');                                                //0043
   Dcl-C  cwIn               Const('*IN');                                               //0075
   Dcl-C  cwTrue             Const(' is TRUE');                                          //0075
   Dcl-C  cwFalse            Const(' is FALSE');                                         //0075
   Dcl-C  cwAnd              Const(' And ');                                             //0075
   Dcl-C  cwOr               Const(' Or ');                                              //0075
   Dcl-C  cwOpenParen        Const('(');                                                 //0075
   Dcl-C  cwCloseParen       Const(')');                                                 //0075
   Dcl-C  cwComma            Const(',');                                                 //0076
   Dcl-C  cwOnEr             Const('ON-ERROR');                                          //0090
   Dcl-C  cwEndM             Const('ENDMON');                                            //0090

   //Copybook declaration
/copy 'QCPYSRC/iaprderlog.rpgleinc'
   wkuDpsds.nbrparms = %parms;                                                           //0030
   EvaluatePSDS() ;                                                                      //0030

   //Initialization SubRoutine
   Exsr InitSr;

   Select;
      When wkSrcSpec = 'F';
         Exsr MapFSpecSr ;
      When wkSrcSpec = 'D';
         Exsr MapDSpecSr ;
      When wkSrcSpec = 'P';
         Exsr MapPSpecSr ;
      When wkSrcSpec = 'C';
         Exsr MapCSpecSr ;
   EndSl;

   If RcdFound;

      Select ;                                                                           //0083
      When wkAppendFlag = *On ;                                                          //0083
         //If the data need to be append                                                //0083
         Exsr AppendData;                                                                //0083
      When wkCallwithMultParm = *On AND                                                  //0083
            wkSrcRrn <> wkSaveBgnRrn  AND  wkSrcRrn <> wkSaveLstRrn ;                    //0083
      Other ;                                                                            //0083
         Exsr WriteFX4OutputData;                                                        //0083
      EndSl ;                                                                            //0083
   EndIf;

   //Pass the current indentation level and declaration type to keep a track in the next call
   Eval-Corr RPGIndentParmDS  =  wkRPGIndentParmDS;                                      //0038
   wkFX4ParmDs.dsIOIndentParmPointer = IOIndentParmPointer;                              //0038
   wkFX4ParmDs.dsDclType      =  wkDclTypeBackup;
   wkFX4ParmDs.dsSubType      =  wkSubDclType;

   Return RcdFound;

//------------------------------------------------------------------------------------- //
//Subroutine InitSr - Initialization SubRoutine                                         //
//------------------------------------------------------------------------------------- //
   BegSr InitSr;

      //Initialise the variables
      Clear wkPseudoCode;
      Clear wkIFOpcodeFlag;                                                              //0077
      wkDclType                     =   *Blanks;
      wkPrvSubType                  =   *Blanks;
      RcdFound                      =   *On;
      wkSrcMbr                      =   wkFX4ParmDs.dsSrcMbr ;
      wkSrcMtyp                     =   wkFX4ParmDs.dsSrcType;
      wkSrcLtyp                     =   wkFX4ParmDs.dsSrcLtyp;
      wkSrcSpec                     =   wkFX4ParmDs.dsSrcSpec;
      wkSrcLnct                     =   wkFX4ParmDs.dsSrcLnct;
      wkPrvDclType                  =   wkFX4ParmDs.dsDclType;
      wkPrvSubType                  =   wkFX4ParmDs.dsSubType;
      wkiAKeyFld2                   =   *Blanks;                                         //0009
      IOIndentParmPointer           =   wkFX4ParmDs.dsIOIndentParmPointer;               //0038
      Eval-Corr wkRPGIndentParmDS   =   RPGIndentParmDS;                                 //0038
      wkIndentLevel                 =   wkRPGIndentParmDS.dsCurrentIndents;              //0038
      wkSrcRrn                      =   wkFX4ParmDs.dsSrcRrn ;                           //0083
      //Initialize variables for every run                                              //0091
      wkFileDtlCntr = *Zeros ;                                                           //0091
      wkKeyWrdCntr = *Zeros ;                                                            //0091

      //Clear the output data structure                                                 //0046
      Clear DsMappingOutData;                                                            //0046
      //Clear file data structure for every run                                          //0091
      Clear dsFSpecKeywords ;                                                            //0091
      Clear dsFSpecLFNewFormat ;                                                         //0091
      wkKeyWrdPointer = %Addr(dsFSpecKeywords) ;                                         //0091
                                                                                         //0091
      //Convert everything (file name, variable names, keywords, record format names)    //0050
      //to capital letters while keeping the string values intact                        //0050
      ConvertVarAndKeywordNamesToCaps(wkFX4ParmDs.dsSrcDta);                             //0050
      if wkFX4ParmDs.dsName <> *Blanks ;                                                 //0050
         wkSrcDta = wkFX4ParmDs.dsName ;                                                 //0050
         ConvertVarAndKeywordNamesToCaps(wkSrcDta);                                      //0050
         wkFX4ParmDs.dsName   = %Trimr(wkSrcDta);                                        //0050
      EndIf;                                                                             //0050
      wkSrcDta =   wkFX4ParmDs.dsSrcDta;                                                 //0050

      //Collecting data on behalf of Specifications
      Select;
      When wkSrcSpec = 'F';
         Clear FSpecDsV4;
         FSpecDsV4 = wkSrcDta;
         //Initialize record length field for future use                                //0095
         If FSpecDsV4.recordlengthc <>  *Blanks   And                                    //0095
            %Check(cwdigits : FSpecDsV4.recordlengthc)  =  *Zeros;                       //0095
            FSpecDsV4.recordlength  =   %Uns(FSpecDsV4.recordlengthc) ;                  //0095
         Else ;                                                                          //0095
            FSpecDsV4.recordlength  =   *Zeros;                                          //0095
         Endif ;                                                                         //0095
         //Initialize length of key field for future use                                //0095
         If FSpecDsV4.lengthOfKeyFldc =   *Blanks  And                                   //0095
            %Check(cwdigits : FSpecDsV4.lengthOfKeyFldc)  =  *Zeros;                     //0095
            FSpecDsV4.lengthOfKeyFld  =   %Uns(FSpecDsV4.lengthOfKeyFldc) ;              //0095
         Else ;                                                                          //0095
            FSpecDsV4.lengthOfKeyFld  = *Zeros ;                                         //0095
         Endif ;                                                                         //0095
                                                                                         //0095
         wkDclType = FSpecDsV4.Specification ;                                           //0078
         wkDsKeyword = FSpecDsV4.Keyword ;                                               //0022

      When wkSrcSpec = 'D';

         Clear DspecV4;                                                                  //0010
         DspecV4 = wkSrcDta;                                                             //0010
         wkDclType =  %Xlate(cwLo:cwUp:DspecV4.DeclarationType);                         //0037
         //For fixed format parsing : In case of                                        //0037
         //PR and PI declaration type , convert procedure                               //0037
         //name to UpperCase                                                            //0037
         If wkDclType = 'PR'  OR  wkDclType = 'PI';                                      //0037
            wkFX4ParmDs.dsName=%Xlate(cwLo:cwUp:wkFX4ParmDs.dsName );                    //0037
         EndIf;                                                                          //0037
                                                                                         //0037
         wkDsKeyword = DspecV4.Keyword;                                                  //0010
                                                                                         //0010
         //Checking for blank datatype                                                  //0010
         Select;                                                                         //0010
            When DspecV4.InternalDataType = *Blanks      and                             //0010
                  DspecV4.toLength <> *Blanks            and                             //0010
                  DspecV4.DecimalPosition <> *Blanks;                                    //0064
               DspecV4.InternalDataType = 'P';                                           //0010
                                                                                         //0010
            When DspecV4.InternalDataType = *Blanks      and                             //0010
                  DspecV4.toLength <> *Blanks            and                             //0010
                  DspecV4.DecimalPosition = *Blanks;                                     //0064
               DspecV4.InternalDataType = 'A';                                           //0010
         EndSl;                                                                          //0010

      When wkSrcSpec = 'C';
         Clear CSpecDsV4;
         CSpecDsV4 = wkSrcDta;
         wkDclType = %xLate(cwLO:cwUP:CSpecDsV4.C_Opcode);                               //0041
                                                                                         //0016
         If %Scan('IF': %Trim(wkDclType)) = 1;                                           //0077
            wkIFOpcodeFlag = 'Y';                                                        //0077
         EndIf;                                                                          //0077

         If %Scan('EVAL' : %Xlate(cwLo:cwUp:wkDclType)) > *Zeros;                        //0016
            Select ;                                                                     //0016
               When %Scan('+=' : wkSrcDta : 1) > *Zeros;                                 //0016
                  wkDclType = %Trim(wkDclType) + '+=';                                   //0016
                  wkSrcDta = %ScanRpl('+='  : ' = '  : wkSrcDta);                        //0016
                                                                                         //0016
               When %Scan('-=' : wkSrcDta : 1) > *Zeros;                                 //0016
                  wkDclType = %Trim(wkDclType) + '-=';                                   //0016
                  wkSrcDta = %ScanRpl('-='  : ' = '  : wkSrcDta);                        //0016
                                                                                         //0016
               When %Scan('**=' : wkSrcDta : 1) > *Zeros;                                //0016
                  wkDclType = %Trim(wkDclType) + '**=';                                  //0016
                  wkSrcDta = %ScanRpl('**='  : ' = '  : wkSrcDta);                       //0016
                                                                                         //0016
               When %Scan('*=' : wkSrcDta : 1) > *Zeros;                                 //0016
                  wkDclType = %Trim(wkDclType) + '*=';                                   //0016
                  wkSrcDta = %ScanRpl('*='  : ' = '  : wkSrcDta);                        //0016
                                                                                         //0016
               When %Scan('/=' : wkSrcDta : 1) > *Zeros;                                 //0016
                  wkDclType = %Trim(wkDclType) + '/=';                                   //0016
                  wkSrcDta = %ScanRpl('/='  : ' = '  : wkSrcDta);                        //0016
            EndSl;                                                                       //0016
         EndIf;                                                                          //0016
         //Handling for READ with loop
         If   wkDclType<>*Blanks;                                                        //0009
              Exsr FixedReadBlock;                                                       //0009
         EndIf;                                                                          //0009
         //Check Monitor Group On-Error
         If wkDclType = cwOnEr;                                                          //0090
            Exsr CheckMonGrpOnErr;                                                       //0090
         EndIf;                                                                          //0090
         //Store the indicators used with I/O operations and prepare prefix/suffix      //0061
         Exsr ReadIndicatorHandling;                                                     //0061

         //Generate and Store ,Pseudo Parser for Conditional indicator on any Opcode    //0075
         Exsr ConditionalIndicatorHandling;                                              //0075
         //Check if a variable is getting CLEARED, if so check if the variable is a     //0042
         //record format OR not. (Pass source data and wkiAKeyFld2 which will be        //0042
         // returned as blank/non-blank as per checking)                                //0042
         wkDclType = %Xlate(cwLo:cwUp:wkDclType);                                        //0042
         CheckClearedRecordFormat(wkDclType : wkiAKeyFld2 : wkSrcDta );                  //0062
                                                                                         //0083
         //Set Keyfield2 when PLIST *ENTRY is present                                    //0083
         If %Trim(wkDclType) = 'PLIST'    AND                                            //0083
            CSpecDsV4.C_Factor1 = '*ENTRY' ;                                             //0083
            wkiAKeyFld2 = %trim(CSpecDsV4.C_Factor1) ;                                   //0083
            wkEntryParm = 'Y' ;                                                          //0083
         Endif ;                                                                         //0083

      When wkSrcSpec = 'P';
                                                                                         //0010
         Clear PspecDsV4;                                                                //0010
         //For Procedure Begin and End convert procedure                                //0037
         //Name to UpperCase in case of fixed P spec                                    //0037
         wkFX4ParmDs.dsName=%Xlate(cwLo:cwUp:wkFX4ParmDs.dsName );                       //0037
         PspecDsV4 = wkSrcDta;                                                           //0010
         wkDclType = PspecDsV4.P_BegEnd;                                                 //0010

         Select;                                                                         //0019
         when wkDclType = 'B';                                                           //0019
            wkBeginProc = 'Y';                                                           //0019
            //Initalized to handle Header display issue in D spec                       //0059
            Clear wkPrevDclType;                                                         //0059
         when wkDclType = 'E';                                                           //0019
            wkBeginProc = 'N';                                                           //0019
         Endsl;                                                                          //0019

      EndSl;

      wkDclType = %Xlate(cwLo:cwUp:wkDclType);

      wkMappingFoundInd = False ;                                                        //0098
      //Handling Opcode Error Handling
      wkStrPos = %Scan('(' : wkDclType);
      If wkStrPos <> *Zeros;
         wkEndPos = %Scan(')' : wkDclType);
         If wkEndPos - wkStrPos > 1 and wkStrPos > *Zeros;                               //0022
            wkDclerror = %Subst(wkDclType : wkStrpos + 1 : wkEndPos - wkStrpos - 1);     //0022
            wkCheckPos = %Check(cwErrorHandle : wkDclError);                             //0022
            wkScanPos = %Scan('E' : wkDclerror) ;                                        //0098
         EndIf;                                                                          //0022
         If wkCheckPos = *Zeros ;
            wkMappingFoundInd = GetMappingData() ;                                       //0098
            If wkMappingFoundInd = True ;                                                //0098
               wkSrcMap = wkSrcMapOut ;                                                  //0098
            Else ;                                                                       //0098
               wkDclType = %Subst(wkDcltype : 1 : wkStrpos - 1) ;                        //0098
            Endif ;                                                                      //0098
         EndIf;
         If wkScanPos > *Zeros ;                                                         //0098
            wkDclerror = %xlate('E' : ' '  : wkDclerror) ;                               //0098
            If wkDclerror = *Blanks ;                                                    //0098
               wkDclType = %Subst(wkDcltype : 1 : wkStrpos - 1) ;                        //0098
            Else ;                                                                       //0098
               wkDclType = %Subst(wkDcltype : 1 : wkStrpos) +                            //0098
                           %trim(wkDclerror) + ')' ;                                     //0098
            Endif ;                                                                      //0098
         Endif ;                                                                         //0098
      EndIf;

      If wkMappingFoundInd = False ;                                                     //0098
         //Get the mapping data from IaPseudoMP file                                    //0098
         If wkSrcSpec = 'C' or wkSrcSpec = 'P';                                          //0098
            wkMappingFoundInd = GetMappingData();                                        //0098
            wkSrcMap = wkSrcMapOut;                                                      //0098
         EndIf;                                                                          //0098
      Endif ;                                                                            //0098
                                                                                         //0052
      //Check opcode in IAPSEUDOKP                                                      //0052
      //If opcode is present in IAPSEUDOKP and all Factor1, Factor2 and Result          //0052
      //fields are present, no changes are needed in Source mapping                     //0052
      //If Factor 1 is not present, Replace Var1 with Var3 in source mapping            //0052
      If wkDclType <> *Blanks ;                                                          //0052
         If CSpecDsV4.C_Factor1 = *Blanks ;                                              //0052
            wkDataTypeElem = %Lookup(wkDclType :                                         //0052
                              CSrcSpecMappingDs(*).dsKeywrdOpcodeName : 1 :              //0052
                              %Elem(CSrcSpecMappingDs) );                                //0052
            If wkDataTypeElem > *Zeros And                                               //0052
                 wkSrcMap <> *Blanks ;                                                   //0052
               wkSrcMap = %ScanRpl('&Var1' : '&Var3' : wkSrcMap) ;                       //0052
            Endif ;                                                                      //0052
         Endif ;                                                                         //0052
         //If all 3 factors are present for date time opcodes, use new alternate         //0098
         //mapping with new verbiage                                                     //0098
         If CSpecDsV4.C_Factor1 <> *Blanks AND CSpecDsV4.C_Result <> *Blanks ;           //0098
            wkDataTypeElem = %Lookup(wkDclType :                                         //0098
                              CSrcSpecMappingDs(*).dsKeywrdOpcodeName : 1 :              //0098
                              %Elem(CSrcSpecMappingDs) );                                //0098
            If wkDataTypeElem > *Zeros And                                               //0098
                 CSrcSpecMappingDs(wkDataTypeElem).dsSrcMapping <> *Blanks ;             //0098
               wkSrcMap = CSrcSpecMappingDs(wkDataTypeElem).dsSrcMapping ;               //0098
            Endif ;                                                                      //0098
         Endif ;                                                                         //0098
      Endif ;                                                                            //0052

      //If opcode is SETON or SETOFF , Check and Update source Mapping &HLE             //0076
      If %subst(CspecDsV4.C_Opcode:1:4) = 'SETO' and wkSrcMap <> *Blanks ;               //0076

         //Evaluate When High Ind is found                                              //0076
         If CspecDsV4.C_HiInd <> *Blanks;                                                //0076
            wkHLEValue = cwIn + CspecDsV4.C_HiInd;                                       //0076
         EndIf;                                                                          //0076

         //Evaluate When Low Ind is found                                               //0076
         If CspecDsV4.C_LoInd <> *Blanks;                                                //0076
            If wkHLEValue <> *Blanks;                                                    //0076
               wkHLEValue = %trim(wkHLEValue) + cwComma + cwIn +                         //0076
                            CspecDsV4.C_LoInd;                                           //0076
            Else;                                                                        //0076
               wkHLEValue = cwIn + CspecDsV4.C_LoInd;                                    //0076
            EndIf;                                                                       //0076
         EndIf;                                                                          //0076

         //Evaluate When Equal Ind is found                                             //0076
         If CspecDsV4.C_EqInd <> *Blanks;                                                //0076
            If wkHLEValue <> *Blanks;                                                    //0076
               wkHLEValue = %trim(wkHLEValue) + cwComma + cwIn +                         //0076
                            CspecDsV4.C_EqInd;                                           //0076
            Else;                                                                        //0076
               wkHLEValue = cwIn + CspecDsV4.C_EqInd;                                    //0076
            EndIf;                                                                       //0076
         EndIf;                                                                          //0076

         //Replace &HLE with Evaluated wkHLEValue string value                          //0076
         wkSrcMap = %scanrpl('&HLE':%trim(wkHLEValue):wkSrcMap);                         //0076

      EndIf;                                                                             //0076

      wkNonBlankDclType = wkDclType;

      //If record not found for the Dcltype check if the previous dcltype has any subfields
      If wkDclType = *Blanks ;

         //Check if previous dcltype has the sub type defined ..eg DS, PR, PI
         If wkPrvSubType <> *Blanks;
             wkDclType = wkPrvSubType ;
         EndIf;

         //when line continuation occurs then update the last inserted record
         If wkPrvDclType <> *Blanks AND wkDclType = *Blanks;
            wkDclType = wkPrvDclType ;
            If wkSrcSpec = 'C';
               wkAppendFlag = *On;
            EndIf;
         EndIf;

         //Get the mapping data from IaPseudoMP file for the subfield
         If wkSrcSpec = 'C';
            wkMappingFoundInd=GetMappingData();                                          //0042
            wkSrcMap = wkSrcMapOut;                                                      //0042
         EndIf;
      EndIf;
                                                                                         //0083
      //If CALL is present with multiple parameters, store data                          //0083
      If wkCallwithMultParm = *On AND %subst(wkDclType : 1 : 4) <> 'PARM' ;              //0083
         If wkEntryParm = 'Y' ;                                                          //0083
            wkIndex = %lookup('RETURNE' : wkCallPseudoCode(*).Category :                 //0083
                                 1 : %Elem(wkCallPseudoCode)) ;                          //0083
            wkEntryCounter = 1 ;                                                         //0083
            Dow wkIndex > *Zeros ;                                                       //0083
               %Subarr(wkEntryPseudoCode : wkEntryCounter: 1) =                          //0083
                              %Subarr(wkCallPseudoCode : wkIndex : 1) ;                  //0083
               If wkIndex < wkCounter ;                                                  //0083
                  wkEntryCounter += 1 ;                                                  //0083
                  wkIndex = %lookup('RETURNE' : wkCallPseudoCode(*).Category :           //0083
                                       wkIndex+1 : %Elem(wkCallPseudoCode)) ;            //0083
               Else ;                                                                    //0083
                  Leave ;                                                                //0083
               Endif ;                                                                   //0083
            Enddo ;                                                                      //0083
            wkEntryParm = 'N' ;                                                          //0083
         Endif ;                                                                         //0083
         Exsr WriteFX4forCallParm ;                                                      //0083
      Endif ;                                                                            //0083
      If wkCallwithMultParm = *Off AND (%subst(wkDclType : 1 : 4) = 'CALL'               //0083
            OR %subst(wkDclType : 1 : 4) = 'PARM'  OR                                    //0083
               %subst(wkDclType : 1 : 5) = 'PLIST')  AND                                 //0083
            %Scan('&Proc1' : wkSrcMap) = *Zeros ;                                        //0083
         wkCallwithMultParm = *On ;                                                      //0083
         Clear wkCallPseudoCode ;                                                        //0083
         Clear wkCounter ;                                                               //0083
         Clear wkSavPos ;                                                                //0083
      Endif ;                                                                            //0083
                                                                                         //0083
      wkDclTypeBackup =  wkDclType;
      wkIndentTypeBackup = wkIndentType;

   EndSr;

//------------------------------------------------------------------------------------- //
//Subroutine AppendData - Append the data the Last inserted Record                      //
//------------------------------------------------------------------------------------- //
   Begsr AppendData;

      //Fetching Last inserted record
      Exec Sql
         Select iAGenPsCde into :wkPseudoCode1
            From iAPseudoCP
            Where iAReqId   = :wkFX4ParmDs.dsReqId                                       //0075
            and   iAMbrLib  = :wkFX4ParmDs.dsSrcLib                                      //0075
            and   iASrcFile = :wkFX4ParmDs.dsSrcPf                                       //0075
            and   iAMbrNam  = :wkSrcMbr                                                  //0075
            and   iAMbrTyp  = :wkSrcMtyp                                                 //0075
            and   iADocSeq  = :wkDocSeq;                                                 //0075

      If SqlCode < SuccessCode;
         uDpsds.wkQuery_Name = 'Select_IaPseudoMP';
         IaSqlDiagnostic(uDpsds);
      EndIf;

      //Extracting the data need to append
      wkStrPos = %Scan(':' : wkPseudoCode : 1);
      If wkStrPos > 0;
         wkPseudoCode = %Subst(wkPseudoCode : wkStrPos+1 );
      EndIf;

      wkPseudoCode1  = %Trimr(wkPseudoCode1) + wkAppendText + %Trim(wkPseudoCode)  ;

      //Appending data in the last inserted record
      Exec Sql
         Update iAPseudoCP
         Set iAGenPsCde = :wkPseudoCode1
            Where iAReqId   = :wkFX4ParmDs.dsReqId                                       //0075
            and   iAMbrLib  = :wkFX4ParmDs.dsSrcLib                                      //0075
            and   iASrcFile = :wkFX4ParmDs.dsSrcPf                                       //0075
            and   iAMbrNam  = :wkSrcMbr                                                  //0075
            and   iAMbrTyp  = :wkSrcMtyp                                                 //0075
            and   iADocSeq  = :wkDocSeq;                                                 //0075

      If SqlCode < SuccessCode;
         uDpsds.wkQuery_Name = 'Update_IaPseudoMP';
         IaSqlDiagnostic(uDpsds);
      EndIf;

   EndSr;

//------------------------------------------------------------------------------------- //
//Subroutine MapFSpecSr - Mapping F Spec data                                           //
//------------------------------------------------------------------------------------- //
   Begsr MapFSpecSr;

      RcdFound = True;

      //Fetching File Name
      wkFName = %Trim(FSpecDsV4.FileName);
      //Save file name and its all record format names in array for later usage          //0042
      //To check if a variable getting cleared) is a record format OR not.               //0042
      SaveFileRecordFormatsNames(wkFName : wkSrcDta);                                    //0042

      //Fetching File Mode
      wkFMode = '  ' + FSpecDsV4.FileType;

      if FSpecDsV4.FileAddition <> *blanks;                                              //0034
         wkFMode =  FSpecDsV4.FileType + '/O' ;                                          //0034
      endif;                                                                             //0034
      //Before fetching file device, check if its a PF/LF by retrieving the attributes  //0043
      If FSpecDsV4.Device <> *Blanks and FSpecDsV4.Device = cwDisk;                      //0043
         exec sql select iAObjAtr into :wkFileAttribute from IAOBJECT                    //0043
                   where iAObjNam = :wkFName and iAObjTyp = '*FILE' Limit 1;             //0043
         //If the file is a logical file, consider it as Index for priting if its a     //0043
         // keyed logical AND it must also not be a join logical.                       //0043
         If wkFileAttribute = cwLF;                                                      //0043
            wkIndexFlag = 'N';                                                           //0043
            exec sql select 'Y' into :wkIndexFlag from IDSPFDKEYS                        //0043
                      where APKeyF <> ' ' and APKeyF <> '*NONE'                          //0043
                      and   APFile = :wkFName and APJoin<>'Y';                           //0043
            If wkIndexFlag = 'Y';                                                        //0043
               FSpecDsV4.Device = %Trim(FSpecDsV4.Device) + '-'+ cwINDEX;                //0043
            Else;                                                                        //0043
               FSpecDsV4.Device = %Trim(FSpecDsV4.Device) + '-'+ cwVIEW;                 //0043
            EndIf;                                                                       //0043
         Else;                                                                           //0043
            FSpecDsV4.Device = %Trim(FSpecDsV4.Device) + '-' + cwPF;                     //0043
         EndIf;                                                                          //0043
      EndIf;                                                                             //0043

      //Fetching File Device
      wkScanPos = %Lookup(%Xlate(cwLo:cwUp:FSpecDsV4.Device)
                                          :FSpecMappingDs(*).dsKeywrdOpcodeName);
      If FSpecDsV4.Device <> *Blanks;                                                    //0001
         If wkScanPos <> *Zeros;
            wkFDevice = FSpecMappingDs(wkScanPos).dsSrcMapping;
         Else;
            wkFDevice = *Blanks;
         EndIf;
      Else;
         wkFDevice = *Blanks;
      EndIf;                                                                             //0001

      //Fetching File is keyed or not
      If FSpecDsV4.RecordAddressType= 'K' ;
         wkFileKey = 'Yes ';                                                             //0045
      Else;
         wkFileKey = *Blanks;                                                            //0045
      EndIf;

      //Fetching Keyword Value
      //Print only the parameters of keywords, ignore those keywords which have         //0001
      //doesn't have any parameters                                                     //0001
      wkStrPos =%scan('(' : wkDskeyword : 1);    //Look for a keyword with parameters    //0001
      wkEndPos = 1;                                                                      //0063

      Dow wkStrPos<> *zeros ;                                                            //0001
         If wkEndPos <> 0 and wkStrPos > wkEndPos;                                       //0063
            wkKeywordStr = %subst(wkDskeyword : wkEndPos  : wkStrPos - wkEndPos);        //0063
         Endif;                                                                          //0063

         wkEndPos = %scan(')' : wkDskeyword : wkStrPos);                                 //0001
      // if wkEndPos<>0 and wkEndPos>wkStrPos+2;                                 //0001  //0063
         if wkEndPos<>0 and wkEndPos>wkStrPos+1;                                         //0063
            wkKeywordVal = %subst(wkDskeyword :wkStrPos+1:wkEndPos-wkStrPos-1);  //0001  //0063
            wkSubKeywordStr = %trim(wkKeywordStr) + ':' + %trim(wkKeywordVal);           //0063

            If %trim(wkKeywordStr) = 'RENAME';                                           //0063
               wkSubKeywordStr = %trim(wkKeywordVal);                                    //0063
               wkFRcdFormat = %trim(wkSubKeywordStr);                                    //0063
            Else;                                                                        //0063
               if wkKeyword = *Blanks;                                                   //0001
                  wkKeyword =  %Trim(wkSubKeywordStr);                                   //0001
               else;                                                                     //0001
                  wkKeyword =  %Trim(wkKeyword) + ', ' +  %Trim(wkSubKeywordStr);        //0001
               endif;                                                                    //0001
            Endif;                                                                       //0063
         else;                                                                           //0001
            Leave;                                                                       //0001
         endif;                                                                          //0001
         wkStrPos=%scan('(' : wkDskeyword : wkEndPos);                                   //0001
         wkEndPos += 1;                                                                  //0063
      Enddo;                                                                             //0001

//Commented below logic of checking keyword- 0001
//    wkNonBlankPos  = %Check(' ' : wkDskeyword : 1);
//    Dow wkNonBlankPos <> *zeros ;
//       wkBlankPos = %Scan(' ' : wkDskeyword : wkNonBlankPos) ;

         //for Close Br present at last position                                         //SG01
//       If wkBlankpos = *Zeros and  %Scan(')' : wkDskeyword : wkNonBlankPos) <> *Zeros;  //SG01
//          wkBlankpos = %Scan(')' : wkDskeyword : wkNonBlankPos);                        //SG01
//       EndIf;                                                                           //SG01

//       If wkBlankpos <> 0 ;                                                             //SG01
//          wkSubKeywordStr = %Subst(wkDskeyword : wkNonBlankPos :wkBlankPos-wkNonBlankPos);

//          wkOpenBrPos   =  %Scan('(' : wkDskeyword : wkNonBlankPos);                    //SG01
//          If wkOpenBrpos <> 0;
//             wkSubKeyword = %Subst(wkSubKeywordStr : 1 : wkOpenBrPos - 1);

//             wkCloseBrPos = %Scan(')' : wkDskeyword : wkOpenBrPos+1);
//             If %Xlate(cwLO:cwUP:wkSubKeyword) = 'RENAME';
//                wkFRcdFormat = %Subst(wkDsKeyword : wkOpenBrPos+1 : wkCloseBrPos-wkOpenBrPos-1);
//             Else;
//                If wkKeyword = *blanks;
//                   wkKeyword = %Subst(wkDsKeyword : wkOpenBrPos+1 : wkCloseBrPos-wkOpenBrPos-1);
//                Else;
//                   wkKeyword =  %Trim(wkKeyword) + ', ' +
//                                 %Subst(wkDsKeyword : wkOpenBrPos+1 : wkCloseBrPos-wkOpenBrPos-1);
//                EndIf;
//             EndIf;
//          EndIf;
//       EndIf;
//
//       If wkCloseBrPos <> *Zeros;
//          wkNonBlankPos = %Check(' ' : wkDskeyword : wkCloseBrPos+1);
//       Else;
//          wkNonBlankPos = %Check(' ' : wkDskeyword : wkBlankPos+1);
//       EndIf;
//    EndDo;

      //Preparing the Pseudocode using Concatenation the Data
      //Populate pseudocode as per the configuration                                    //0091
      If wkFileConfigFlag = cwNewFormat ;                                                //0091
         //Prepare pseudo code in new format using DS defined                            //0091
         dsFSpecLFNewFormat.dsName       = wkFName ;                                     //0091
         dsFSpecLFNewFormat.dsMode       = wkFMode ;                                     //0091
         dsFSpecLFNewFormat.dsDevice     = wkFDevice ;                                   //0091
         //Call procedure to get file level details and store in array                   //0091
         If wkFName <> *Blanks ;                                                         //0091
            wkCallMode = cwStoreData ;                                                   //0091
            IaGetLogicalFileDetails(wkCallMode : dsFSpecLFNewFormat :                    //0091
                                    wkKeyWrdPointer : wkKeyWrdCntr) ;                    //0091
            Exsr RetrieveAllFileKeywords ;                                               //0091
         Endif ;                                                                         //0091
         wkPseudoCode = dsFSpecLFNewFormat ;                                             //0091
      Else ;                                                                             //0091
         //Preparing the Pseudocode using Concatenation the Data                        //0091
         wkPseudoCode = wkFName + cwDelimiter + wkFMode + cwDelimiter + wkFileKey +      //0091
                        cwDelimiter + wkFRcdFormat + cwDelimiter + wkFDevice +           //0091
                        cwDelimiter + wkKeyword ;                                        //0091
      Endif ;                                                                            //0091

   EndSr;

//------------------------------------------------------------------------------------- //
//Subroutine MapDSpecSr - Mapping D Spec data                                           //
//------------------------------------------------------------------------------------- //
   Begsr MapDSpecSr;

      RcdFound = True;

      //Fetching Name
      If wkDclType = 'SUBFIELD' or wkDclType = 'PARAMPI' or wkDclType = 'PARAMPR';       //0019
         %subst(wkDName : 2) = wkFX4ParmDs.dsName;                                       //0019
      Else;                                                                              //0019
         wkDName = wkFX4ParmDs.dsName;                                                   //0019
         If wkDName = *Blanks and wkDclType = 'DS';                                      //0069
            If DSPECV4.DSTYPE  = 'S' or DSPECV4.DSTYPE  = 's' ;                          //0069
               wKDName = cwPsds;                                                         //0069
            Else;                                                                        //0069
               wkDName = cwNoName;                                                       //0069
            EndIf;                                                                       //0069
         EndIf;                                                                          //0069
      EndIf;                                                                             //0019

      //Fetching DataType Description
                                                                                         //0011
      wkDataType = %Xlate(cwLo:cwUp:DspecV4.InternalDataType);                           //0011

      //Fetching Length
      If %Xlate(cwLo:cwUp:%Trim(wkDataType)) <> cwInd;                                   //0010
         Select;                                                                         //0010
            When DspecV4.decimalPosition = *Blanks ;                                     //0010
               wkDSpecLength = %Trim(DspecV4.toLength) ;                                 //0010

            When %Int(DspecV4.decimalPosition) <> *Zeros;                                //0010
               wkDSpecLength = %Trim(DspecV4.toLength + ':' +                            //0010
                               %Trim(DspecV4.decimalPosition));                          //0010

            Other;                                                                       //0010
               wkDSpecLength = %Trim(DspecV4.toLength) ;                                 //0010
         EndSl;                                                                          //0010
      EndIf;                                                                             //0010

      //Calculate length and dec pos                                                    //0054
      If wkDclType = 'SUBFIELD' and DspecV4.FromLength <> *Blanks;                       //0054
         If %Scan('*' : %Trim(DspecV4.FromLength)) > *Zeros ;                            //0054
            wkKeyword = %Trim(DspecV4.FromLength);                                       //0054
         Else;                                                                           //0054
            Monitor;                                                                     //0054
               wkDFromLength = %Int(DspecV4.FromLength);                                 //0054
               wkDToLength = %Int(DspecV4.ToLength);                                     //0054
               wkDSpecPosition = %Trim(DspecV4.fromLength);                              //0054
                                                                                         //0054
               If %Xlate(cwLo:cwUp:%Trim(wkDataType)) <> cwInd;                          //0054
                  wkDSpecLength  = %Char(wkDToLength - wkDFromLength + 1);               //0054
               EndIf;                                                                    //0054
                                                                                         //0054
            On-Error;                                                                    //0054
               wkDSpecPosition = %Trim(DspecV4.fromLength);                              //0054
            EndMon;                                                                      //0054
         EndIf;                                                                          //0054
      EndIf;                                                                             //0054
      //save orig const value in case of BIF is present                                 //0096
      If WkDclType    =  'C';                                                            //0096
         WkConstValue =  %Trim(wkDsKeyword);                                             //0096
      Endif;                                                                             //0096
      //Fetching Keyword Value
      wkDsKeyword  = %ScanRpl('(' : ':' : wkDsKeyword);
      wkDsKeyword  = %ScanRpl(')' : ' ' : wkDsKeyword);
                                                                                         //0011
      If wkKeyword = *Blanks;                                                            //0011
         wkKeyword = %Trim(wkDsKeyword);                                                 //0011
      Else;                                                                              //0011
         wkKeyword = %Trim(wkKeyword) + ' ' + %Trim(wkDsKeyword);                        //0011
      EndIf;                                                                             //0011
                                                                                         //0011
      If wkDclType = 'C' and %Scan(cwConst : %Xlate(cwLo:cwUp: wkKeyword)) > *Zeros;     //0011
         wkKeyword = %Subst(wkKeyword : 7);                                              //0011
      EndIf;                                                                             //0011

      If %Scan(cwDIM : wkKeyword:1) > 0;                                                 //0086
         wkStrPos = %Scan(':':wkKeyword:1) +1;                                           //0086
         wkEndPos = %Scan(' ':wkKeyword:1);                                              //0086
         If wkStrPos > 0 and wkEndPOs > 0 and wkEndPos > WkStrPos;                       //0086
            wkDSpecDim =                                                                 //0086
               %subst(wkKeyword: wkStrPos: wkEndPos - wkStrPos);                         //0086
            If %Scan(cwCTDAT:wkkeyword:1) > 0;                                           //0086
               wkKeyword = %trim(%Subst(wkKeyword : wkEndPos + 1));                      //0086
            Else;                                                                        //0086
               wkKeyword = *Blanks;                                                      //0086
            EndIf;                                                                       //0086
         EndIf;                                                                          //0086
      EndIf;                                                                             //0086
                                                                                         //0086
      //Preparing PseudoCode
      Select;
         //For Standalone Variables
         When wkDclType = 'S' ;
            wkPseudoCode =  wkDName + cwDelimiter + wkDataType + cwDelimiter +
                            wkDSpecLength + cwDelimiter + wkDSpecDim  +
                            cwDelimiter + wkKeyword ;

         //For Data Structure and DS SubFields
         When wkDclType = 'DS' or wkDclType = 'SUBFIELD' ;
            wkPseudoCode =  wkDName + cwDelimiter + wkDataType + cwDelimiter +
                            wkDSpecLength + cwDelimiter + wkDSpecDim  +
                            cwDelimiter + wkDSpecPosition + cwDelimiter + wkKeyword ;

         //For Prototype, Procedure Interface
         When wkDclType = 'PR' or wkDclType = 'PI' or
              wkDclType = 'PARAMPR' or wkDclType = 'PARAMPI'  ;
            wkPseudoCode =  wkDName + cwDelimiter + wkDataType + cwDelimiter +
                            wkDSpecLength + cwDelimiter + wkKeyword ;

         //For Constants
         When wkDclType = 'C';
            //Check if const value is defined using BIF,like-Const(%Len(Variable))      //0096
            If WkConstValue  <>  *Blanks                                And              //0096
               %Scan('%' : WkConstValue : 1)  >  *Zeros;                                 //0096
               bifSourcePointer   =  %Addr(WkConstValue);                                //0096
               WkConstValue = ProcessDspecBIF(bifSourcePointer);                         //0096
            Endif;                                                                       //0096
            wkPseudoCode =  wkDName + cwDelimiter + %Trim(wkConstValue);                 //0096
    //0096  wkPseudoCode =  wkDName + cwDelimiter + wkKeyWord;

      EndSl;

      Select;
         When wkDclType = 'DS' or wkDclType = 'SUBFIELD' ;
            wkSubDclType = 'SUBFIELD' ;
         When wkDclType = 'PR' or wkDclType = 'PARAMPR' ;
            wkSubDclType = 'PARAMPR'  ;
         When wkDclType = 'PI' or wkDclType = 'PARAMPI' ;
            wkSubDclType = 'PARAMPI'  ;
      EndSl;

   EndSr;

//------------------------------------------------------------------------------------- //
//Subroutine MapPSpecSr - Mapping P Spec data                                           //
//------------------------------------------------------------------------------------- //
   Begsr MapPSpecSr;

      RcdFound = True;
      //Mapping Name
      wkPseudoCode = %ScanRpl('&Var1' : %Trim(wkFX4ParmDs.dsName) : wkSrcMap);           //0010

      //Mapping Keyword
      wkPseudoCode = %ScanRpl('&Keywrd' : %Trim(PspecDsV4.P_KeyW) : wkPseudoCode);       //0010

   EndSr;

//------------------------------------------------------------------------------------- //
//Subroutine MapCSpecSr - Mapping C Spec data                                           //
//------------------------------------------------------------------------------------- //
   Begsr MapCSpecSr;

      If wkDclType <> *Blanks and %len(wkSrcMap)>0;                                      //0042
         IaParseCSpecPseudoCode(wkSrcDta : wkSrcMap : wkPseudoCode);
         RcdFound = True;

         //Handling Calling Objects Description
         If %Scan('&ObjDesc':wkCommentDesc)>0 ;

            wkobjname = %Trim(CSpecDsV4.C_Factor2);                                      //0001

            If GetObjectDesc(wkObjname:wkObjDesc);
               wkCommentDesc = %ScanRpl('&ObjDesc' : wkObjDesc : wkCommentDesc);
            Else;
               wkCommentDesc = %ScanRpl('&ObjDesc' : ' ' : wkCommentDesc);
            EndIf;
         EndIf;
      EndIf;

      //Check for any 2nd level mapping required for keywords
      If wkSearchFld1 <> *Blanks Or wkSearchFld2 <> *Blanks
         Or wkSearchFld3 <> *Blanks Or wkSearchFld3 <> *Blanks;

         wkSrhIndex = *Zeros;

         //Moving Keywords to Search Field Array (eg in f spec - Device, Mode...)
         If wkSearchFld1 <> *Blanks;
            wkSrhIndex += 1;
            ArrSearchFld(wkSrhIndex)  =  wkSearchFld1;
         EndIf;

         If wkSearchFld2 <> *Blanks;
            wkSrhIndex += 1;
            ArrSearchFld(wkSrhIndex)  =  wkSearchFld2;
         EndIf;

         If wkSearchFld3 <> *Blanks;
            wkSrhIndex += 1;
            ArrSearchFld(wkSrhIndex)  =  wkSearchFld3;
         EndIf;

         If wkSearchFld4 <> *Blanks;
            wkSrhIndex += 1;
            ArrSearchFld(wkSrhIndex)  =  wkSearchFld4;
         EndIf;

         //Get the max index for the loop
         wkMaxSrhCount = wkSrhIndex;

         For wkSrhIndex = 1 to wkMaxSrhCount;
            wkKeyList   =  ArrSearchFld(wkSrhIndex);
            //Declare the cursor to select the 2nd level Pseudocode mapping
            Exec Sql
               Declare IaPseudoMPFixC1 Scroll Cursor for
                  Select   KeyField_2
                          ,Src_Mapping
                  From IaPseudoMP
                  Where  SrcLin_Type  = :wkSrcLtyp
                     and Source_Spec  = :wkSrcSpec
                     and KeyField_1   = :wkKeyList
                  Order by IaSeqNo                                                       //0009
                  For Fetch Only;
            Exec Sql
               Open IaPseudoMPFixC1;

            Exec Sql
               Fetch First From IaPseudoMPFixC1 into :wkKeywordtoLookup,
                                                      :wk2ndLevelMapping;

            Dow SqlCode = SuccessCode;

               //Finding Match with specs keywords (eg. Datatype, Mode, Device....)
               Select ;
               When wkSrcSpec = 'C';
                  If %Trim(wkKeywordtoLookup) = CspecDsV4.c_factor1 or                   //0009
                     (%Trim(wkKeywordtoLookup) = 'DEFAULT' and                           //0009
                      wkMaxSrhCount = wkSrhIndex and wkLevel2FoundInd =*Off);            //0009
                     wkFlag = *On;
                     wkLevel2FoundInd = *On;                                             //0009
                  Else;
                     wkFlag = *Off;
                  EndIf;
               Endsl;

               If wkFlag = *On;
                  //Keyword found for the 2nd level Pseudocode mapping
                  If %Scan('&Var1' : wk2ndLevelMapping : 1) > *Zeros;                    //0009
                     wk2ndLevelMapping = %ScanRpl('&Var1':                               //0009
                                   %Trim(CspecDsV4.c_factor1):wk2ndLevelMapping);        //0009
                  EndIf;                                                                 //0009

                  If %Scan('&Var2' : wk2ndLevelMapping : 1) > *Zeros;
                     wk2ndLevelMapping = %ScanRpl('&Var2':%Trim(CspecDsV4.c_factor2)
                                                         :wk2ndLevelMapping);
                     wkPseudoCode = %Trim(wkPseudoCode) + ' ' + %Trim(wk2ndLevelMapping);
                  Else;
                     wkPseudoCode = %Trim(wkPseudoCode) + ' ' + %Trim(wk2ndLevelMapping);
                  EndIf;

                  If %Scan('&Var3' : wk2ndLevelMapping : 1) > *Zeros;
                     wkPseudoCode = %ScanRpl('&Var3':%Trim(CspecDsV4.C_Result) :wkPseudoCode);
                  EndIf;
               EndIf;
               Exec Sql
                  Fetch Next From IaPseudoMPFixC1 Into :wkKeywordtoLookup, :wk2ndLevelMapping;
            EndDo;

            Exec Sql
               Close IaPseudoMPFixC1;
         Endfor;
      EndIf;

      //Check if the built in function exist in source statement and                    //0047
      //process it to create the Pseudocide                                             //0047
                                                                                         //0047
      If %Scan('%' : wkPseudoCode : 1) > *Zeros;                                         //0047
          wkSrcDtaBIF = wkPseudoCode ;                                                   //0047
                                                                                         //0047
          IOBifParmPointer = %Addr(dsNestedBIF);                                         //0047
         //Process Nested/Simple Built in Function                                      //0047
          If ProcessNestedBIF(wkSrcDtaBIF : IOBifParmPointer : OutMaxBif);               //0047
             wkPseudoCode  = wkSrcDtaBIF;                                                //0047
             LeaveSr ;                                                                   //0047
          Else;                                                                          //0047
         //If processing unsuccessfull, write the original source statement             //0047
             wkPseudoCode  = %Trim(wkFX4ParmDs.dsSrcDta);                                //0047
             LeaveSr ;                                                                   //0047
         EndIf;                                                                          //0047
      EndIf;                                                                             //0047

      wkDclTypeBackup =  wkDclType;
      wkIndentTypeBackup = wkIndentType;

      //Handling Builtin Functions
      Dow %Scan('%' : wkPseudoCode) <> 0;
         wkScanpos = %Scan('%' : wkPseudoCode : 1);
         wkStrpos  = %Scan('(' : wkPseudoCode : wkscanpos);

         //Check Builtin Function Having Parameter or not
         If wkStrpos = 0  ;
            wkstrpos  = %Scan(' ' : wkPseudoCode : wkscanpos);
         Else;
            wkEndpos  = %ScanR(')' : wkPseudoCode : wkstrpos);
         EndIf;

         //Storing Builtin Function name and get the mapping data
         If wkStrpos-wkScanpos > *Zeros and wkScanPos > *Zeros;                          //0022
            wkDclType = %Subst(wkPseudoCode : wkScanpos : wkStrpos-wkScanpos);           //0022
         EndIf;                                                                          //0022

         wkMappingFoundInd = GetMappingData();                                           //0042
         wkSrcMap = wkSrcMapOut;                                                         //0042

         If wkMappingFoundInd = *Off;                                                    //0028
            Leave;

         Else;                                                                           //0028

            //If Builtin Function have Parameters
            If wkEndPos - wkStrPos > 1 and wkStrPos > *Zeros;                            //0022

               //Moving Builtin Parameters
               wkBuiltParm = %Subst(wkPseudoCode : wkStrpos+1 : wkEndpos-wkStrpos-1);
               wkBltpos1 = 1;
               wkBltpos3 = %Scan('%' : wkBuiltParm : 1);
               wkBltpos2 = %Scan(':' : wkBuiltParm : 1);

               //Spliting the paramters to array
               Dou wkBltpos2 = 0;
                  wkIndex += 1;

                  //Handling Nested Built-in Functions
                  If wkBltpos3 > wkBltpos2 and wkScanpos <> 0 OR
                                wkBltpos3 < wkBltpos2 and wkBltpos3 = 0 ;
                     If wkBltpos1 > 0 and wkBltpos2 > wkBltpos1;
                        wkarray(wkIndex) = %Subst(wkBuiltParm :wkBltpos1 :wkBltpos2-wkBltpos1);
                     EndIf;
                     wkBltpos1 = wkBltpos2 + 1;
                     wkBltpos2 = %Scan(':' :wkBuiltParm :wkBltpos2 + 1);
                  Else;
                     Leave;
                  EndIf;
               Enddo;
               If wkarray(wkIndex) <> *Blanks;
                  wkIndex += 1;
               EndIf;
               If wkBltpos1 > 0 and wkIndex < %elem(wkArray);
                  wkarray(wkindex) = %Subst(wkBuiltParm :wkBltpos1);
               EndIf;
               wkPseudoCode2 = wksrcMap ;

               //&BVar1 represents first element of Built in Parameter
               If %Scan('&BVar1' : wkPseudoCode2 : 1) > *zeros;
                  wkPseudoCode2 = %ScanRpl('&BVar1':%Trim(wkArray(1)): wkPseudoCode2);
               EndIf;

               //&BVar2 represents second element of Built in Parameter
               If %Scan('&BVar2' : wkPseudoCode2 : 1) > *zeros;
                  wkPseudoCode2 = %ScanRpl('&BVar2':%Trim(wkArray(2)): wkPseudoCode2);
               EndIf;

               //&BVar3 represents third element of Built in Parameter
               If %Scan('&BVar3' : wkPseudoCode2 : 1) > *zeros;
                  wkPseudoCode2 = %ScanRpl('&BVar3':%Trim(wkArray(3)): wkPseudoCode2);
               EndIf;

               //&BVar4 represents Fourth element of Built in Parameter
               If %Scan('&BVar4' : wkPseudoCode2 : 1) > *zeros;
                  wkPseudoCode2 = %ScanRpl('&BVar4':%Trim(wkArray(4)): wkPseudoCode2);
               EndIf;

               //Replacing the Builtin Function with Parameters with Mapped data
               wkPseudoCode = %ScanRpl(%Subst(wkPseudoCode : wkScanpos : wkEndpos-wkScanpos+1) :
                                 wkPseudoCode2 : wkPseudoCode);
            Else;
               //Replacing the Builtin Function without Parameters with Mapped data
               wkPseudoCode = %ScanRpl(%Subst(wkPseudoCode : wkScanpos : wkStrpos-wkScanpos+1) :
                                     wksrcMap  : wkPseudoCode);
            EndIf;
         EndIf;
         Clear wkBuiltParm;
         Clear wkIndex;
         Clear wkArray;
         Clear wkBltpos1;
         Clear wkBltpos2;
      Enddo;
   EndSr;

//------------------------------------------------------------------------------------- //
//Subroutine FixedReadBlock - Handling of read with do loop                             //
//------------------------------------------------------------------------------------- //
   Begsr FixedReadBlock;                                                                 //0009

     ChkCSpecDsV4 = %Xlate(cwLo:cwUp:CSpecDsV4);                                         //0009
     Select;                                                                             //0009
     //1 - Skip comment & Blank line
     When    ChkCspecDsV4.star='*' or ChkCspecDsV4.C_Opcode=*Blanks;                     //0009
             return RcdFound;                                                            //0009

     //2 - Skip the next executable statement which has already been identified as DOx
     When   wkFX4ParmDs.dsSkipNxtStm = *On;                                              //0009
            wkFX4ParmDs.dsSkipNxtStm = *Off;                                             //0009
            return RcdFound;                                                             //0009

     When   (%subst(ChkCspecDsV4.C_Opcode:1:4) ='READ' or                                //0009
            %subst(ChkCspecDsV4.C_Opcode:1:5) ='CHAIN') and                              //0009
            ChkCSpecDsV4.C_Factor2<>*Blanks;                                             //0009
            //3 - Check if its a READ statement within loop to be skipped
            If   %subst(ChkCspecDsV4.C_Opcode:1:4) ='READ' and                           //0009
                 %lookup(ChkCSpecDsV4.C_Factor2 : wkFX4ParmDs.dsFileNames : 1 :          //0009
                 wkFX4ParmDs.dsFileCount)<>0;                                            //0009
                 wkSrhIndex=%lookup(ChkCSpecDsV4.C_Factor2 :                             //0009
                            wkFX4ParmDs.dsFileNames:1:wkFX4ParmDs.dsFileCount);          //0009
                 wkFX4ParmDs.dsFileNames(wkSrhIndex)=*Blanks;                            //0009
                 wkFX4ParmDs.dsFileCount -= 1;                                           //0009
                 Return RcdFound;                                                        //0009
            EndIf;                                                                       //0009
            //4 - Check if its a READ/CHAIN operation for which looping is used
            //Read next source lines and if there is ending of loop in next lines
            //skip processing of this line if the READ loop was active
            exec sql declare CheckLooping cursor for                                     //0009
                 select XSrcDta from iAQRpgSrc where                                     //0009
                 XLibNam =:wkFX4ParmDs.dsSrcLib  and                                     //0009
                 XSrcNam =:wkFX4ParmDs.dsSrcPf   and                                     //0009
                 XMbrNam =:wkFX4ParmDs.dsSrcMbr  and                                     //0009
                 XMbrTyp =:wkFX4ParmDs.dsSrcType and                                     //0009
                 XSrcRrn >:wkFX4ParmDs.dsSrcRrn                                          //0009
                 for fetch only;                                                         //0009
            exec sql open CheckLooping;                                                  //0009
            DoW sqlcode = SuccessCode;                                                   //0009
                exec sql fetch from CheckLooping into :wkCLoopSrcDta;                    //0009
                If sqlcode = SuccessCode;                                                //0009
                   ChkCspecDsV4 = %Xlate(cwLo:cwUp:wkCLoopSrcDta);                       //0009
                   Select;                                                               //0009
                   //Skip commented and blank lines while searching for next loop
                   When   ChkCspecDsV4.specification= ' ' or                             //0009
                          ChkCspecDsV4.star='*' or ChkCspecDsV4.C_Opcode=*Blanks;        //0009
                          Iter;                                                          //0009
                   //Don't consider looping on file if next op code is not a 'DOx' loop
                   When   %subst(ChkCspecDsV4.C_Opcode:1:2) <> 'DO';                     //0009
                          Leave;                                                         //0009
                   Other;                                                                //0009
                   //If %EOF built in function OR and indicator which has been used
                   //with READx operation is present as Factor 2 with DOx loop, consider
                   //it as reading all record loop otherwise do not consider
                          If   %scan('%EOF':ChkCspecDsV4.C_ExtFact2:1)<>0 or             //0009
                               (%scan('*IN':ChkCspecDsV4.C_ExtFact2:1)<>0 and            //0009
                               %subst(ChkCspecDsV4.C_Factor2:                            //0009
                               %scan('*IN':ChkCspecDsV4.C_ExtFact2)+3:2)=                //0009
                               CspecDsV4.C_EqInd);                                       //0009
                               wkFX4ParmDs.dsSkipNxtStm = *On;                           //0009
                               wkFX4ParmDs.dsFileCount += 1;                             //0009
                               wkFX4ParmDs.dsFileNames(wkFX4ParmDs.dsFileCount)=         //0009
                               %Trim(CspecDsV4.C_Factor2);                               //0009
                               wkiAKeyFld2 = 'LOOP';                                     //0009
                               Leave;                                                    //0009
                          EndIf;                                                         //0009
                   EndSl;
                EndIf;                                                                   //0009
            EndDo;                                                                       //0009
            exec sql close CheckLooping;                                                 //0009
     EndSl;                                                                              //0009
   EndSr;                                                                                //0009
   //-----------------------------------------------------------------------------------//0061
   //Subroutine ReadIndicatorHandling - Handling of indicators used with READ/CHAIN     //0061
   //-----------------------------------------------------------------------------------//0061
   Begsr ReadIndicatorHandling;                                                          //0061

     ChkCSpecDsV4 = %Xlate(cwLo:cwUp:CSpecDsV4);                                         //0061
      //Store the indicator used in a DS array to identify later statements              //0061
      // If indicator is used than check if file name is already present in              //0061
      //DS, if not present OR if present but with different indicator,                   //0061
      //add/replace the indicator data and file name.                                    //0061
      Select;                                                                            //0061
        When %subst(ChkCspecDsV4.C_Opcode:1:4) ='READ' and                               //0061
             (ChkCspecDsV4.C_LoInd <> *Blanks or                                         //0099
              ChkCspecDsV4.C_EqInd <> *Blanks);                                          //0099
           wkIdx = %lookup(ChkCspecDsV4.C_Factor2:dsFileOperationInd.FileName);          //0061
           If wkIdx = 0 or (wkidx<>0 and                                                 //0061
              %Trim(dsFileOperationInd.RcdNotFound(wkIdx))<>ChkCspecDsV4.C_EqInd);       //0061
              //Check if indicator was getting used for some other file earlier          //0061
              wkTmpIndicatorNam = ' '+ChkCspecDsV4.C_EqInd;                              //0061
              wkIdx=%lookup(wkTmpIndicatorNam : dsFileOperationInd.RcdNotFound);         //0061
              If wkIdx = 0;                                                              //0061
                 dsFileOperationInd.Count +=1;                                           //0061
                 wkIdx = dsFileOperationInd.Count;                                       //0061
              EndIf;                                                                     //0061
              dsFileOperationInd.RcdNotFound(wkIdx) = ' ' + ChkCspecDsV4.C_EqInd;        //0061
              dsFileOperationInd.RcdFound(wkIdx) = 'N' + ChkCspecDsV4.C_EqInd;           //0061
              dsFileOperationInd.FileName(wkIdx) = ChkCspecDsV4.C_Factor2;               //0061
              dsFileOperationInd.ResultInd(wkIdx) = 'EQ';                                //0099
              dsFileOperationInd.RIOpcode(wkIdx)  = ChkCspecDsV4.C_Opcode;               //0099
           EndIf;                                                                        //0061

           If wkIdx = 0 or (wkidx<>0 and                                                 //0099
              %Trim(dsFileOperationInd.RcdNotFound(wkIdx))<>ChkCspecDsV4.C_LoInd);       //0099
              //Check if indicator was getting used for some other file earlier          //0099
              wkTmpIndicatorNam = ' '+ ChkCspecDsV4.C_LoInd;                             //0099
              wkIdx=%lookup(wkTmpIndicatorNam : dsFileOperationInd.RcdNotFound);         //0099
              If wkIdx = 0;                                                              //0099
                 dsFileOperationInd.Count +=1;                                           //0099
                 wkIdx = dsFileOperationInd.Count;                                       //0099
              EndIf;                                                                     //0099
              dsFileOperationInd.RcdNotFound(wkIdx) = ' ' + ChkCspecDsV4.C_LoInd;        //0099
              dsFileOperationInd.RcdFound(wkIdx) = 'N' + ChkCspecDsV4.C_LoInd;           //0099
              dsFileOperationInd.FileName(wkIdx) = ChkCspecDsV4.C_Factor2;               //0099
              dsFileOperationInd.ResultInd(wkIdx) = 'LO';                                //0099
              dsFileOperationInd.RIOpcode(wkIdx)  = ChkCspecDsV4.C_Opcode;               //0099
           EndIf;                                                                        //0099
        When %subst(ChkCspecDsV4.C_Opcode:1:5) ='CHAIN' and                              //0061
             (ChkCspecDsV4.C_LoInd <> *Blanks or                                         //0061
              ChkCspecDsV4.C_HiInd <> *Blanks);                                          //0061
           wkIdx = %lookup(ChkCspecDsV4.C_Factor2:dsFileOperationInd.FileName);          //0061
           If wkIdx = 0 or (wkidx<>0 and                                                 //0061
              %Trim(dsFileOperationInd.RcdNotFound(wkIdx))<>ChkCspecDsV4.C_LoInd);       //0061
              //Check if indicator was getting used for some other file earlier          //0061
              wkTmpIndicatorNam = ' '+ChkCspecDsV4.C_LoInd;                              //0061
              wkIdx=%lookup(wkTmpIndicatorNam : dsFileOperationInd.RcdNotFound);         //0061
              If wkIdx = 0;                                                              //0061
                 dsFileOperationInd.Count +=1;                                           //0061
                 wkIdx = dsFileOperationInd.Count;                                       //0061
              EndIf;                                                                     //0061
              dsFileOperationInd.RcdNotFound(wkIdx) = ' ' + ChkCspecDsV4.C_LoInd;        //0061
              dsFileOperationInd.RcdFound(wkIdx) = 'N' + ChkCspecDsV4.C_LoInd;           //0061
              dsFileOperationInd.FileName(wkIdx) = ChkCspecDsV4.C_Factor2;               //0061
              dsFileOperationInd.ResultInd(wkIdx) = 'LO';                                //0099
              dsFileOperationInd.RIOpcode(wkIdx)  = ChkCspecDsV4.C_Opcode;               //0099
           EndIf;                                                                        //0061

           If wkIdx = 0 or (wkidx<>0 and                                                 //0061
              %Trim(dsFileOperationInd.RcdNotFound(wkIdx))<>ChkCspecDsV4.C_HiInd);       //0061
              //Check if indicator was getting used for some other file earlier          //0061
              wkTmpIndicatorNam = ' '+ChkCspecDsV4.C_HiInd;                              //0061
              wkIdx=%lookup(wkTmpIndicatorNam : dsFileOperationInd.RcdNotFound);         //0061
              If wkIdx = 0;                                                              //0061
                 dsFileOperationInd.Count +=1;                                           //0061
                 wkIdx = dsFileOperationInd.Count;                                       //0061
              EndIf;                                                                     //0061
              dsFileOperationInd.RcdNotFound(wkIdx) = ' ' + ChkCspecDsV4.C_HiInd;        //0061
              dsFileOperationInd.RcdFound(wkIdx) = 'N' + ChkCspecDsV4.C_HiInd;           //0061
              dsFileOperationInd.FileName(wkIdx) = ChkCspecDsV4.C_Factor2;               //0061
              dsFileOperationInd.ResultInd(wkIdx) = 'HI';                                //0099
              dsFileOperationInd.RIOpcode(wkIdx)  = ChkCspecDsV4.C_Opcode;               //0099
           EndIf;                                                                        //0061

        When (%subst(ChkCspecDsV4.C_Opcode:1:5) ='SETLL' or                              //0061
             %subst(ChkCspecDsV4.C_Opcode:1:5) ='SETGT') and                             //0061
             (ChkCspecDsV4.C_LoInd <> *Blanks or ChkCspecDsV4.C_HiInd <> *Blanks);       //0061
           wkIdx = %lookup(ChkCspecDsV4.C_Factor2:dsFileOperationInd.FileName);          //0061
           If ChkCspecDsV4.C_HiInd<>*Blanks and (wkIdx = 0 or (wkidx<>0 and              //0061
               %Trim(dsFileOperationInd.RcdNotFound(wkIdx))<>ChkCspecDsV4.C_HiInd));     //0084
              wkTmpIndicatorNam = ' '+ChkCspecDsV4.C_HiInd;                              //0061
              wkIdx=%lookup(wkTmpIndicatorNam : dsFileOperationInd.RcdNotFound);         //0084
              If wkIdx = 0;                                                              //0061
                 dsFileOperationInd.Count +=1;                                           //0061
                 wkIdx = dsFileOperationInd.Count;                                       //0061
              EndIf;                                                                     //0061
              dsFileOperationInd.RcdNotFound(wkIdx) = ' ' + ChkCspecDsV4.C_HiInd;        //0084
              dsFileOperationInd.RcdFound(wkIdx) = 'N' + ChkCspecDsV4.C_HiInd;           //0084
              dsFileOperationInd.FileName(wkIdx) = ChkCspecDsV4.C_Factor2;               //0061
              dsFileOperationInd.ResultInd(wkIdx) = 'HI';                                //0099
              dsFileOperationInd.RIOpcode(wkIdx)  = ChkCspecDsV4.C_Opcode;               //0099
          EndIf;                                                                         //0061

          If ChkCspecDsV4.C_LoInd<>*Blanks and (wkIdx = 0 or (wkidx<>0 and               //0099
              %Trim(dsFileOperationInd.RcdNotFound(wkIdx))<>ChkCspecDsV4.C_LoInd));      //0099
             wkTmpIndicatorNam = ' '+ChkCspecDsV4.C_LoInd;                               //0099
             wkIdx=%lookup(wkTmpIndicatorNam : dsFileOperationInd.RcdNotFound);          //0099
             If wkIdx = 0;                                                               //0099
                dsFileOperationInd.Count +=1;                                            //0099
                wkIdx = dsFileOperationInd.Count;                                        //0099
             EndIf;                                                                      //0099
             dsFileOperationInd.RcdNotFound(wkIdx) = ' ' + ChkCspecDsV4.C_LoInd;         //0099
             dsFileOperationInd.RcdFound(wkIdx) = 'N' + ChkCspecDsV4.C_LoInd;            //0099
             dsFileOperationInd.FileName(wkIdx) = ChkCspecDsV4.C_Factor2;                //0099
             dsFileOperationInd.ResultInd(wkIdx) = 'LO';                                 //0099
             dsFileOperationInd.RIOpcode(wkIdx)  = ChkCspecDsV4.C_Opcode;                //0099
          EndIf;                                                                         //0099
                                                                                         //0099
          wkIdx = %lookup(ChkCspecDsV4.C_Factor2:dsFileOperationInd.FileName);           //0061
          If %subst(ChkCspecDsV4.C_Opcode:1:5) ='SETLL' and                              //0061
             ChkCspecDsV4.C_EqInd<>*Blanks and (wkIdx = 0 or (wkidx<>0 and               //0099
             %Trim(dsFileOperationInd.RcdNotFound(wkIdx))<>ChkCspecDsV4.C_EqInd));       //0099
             wkTmpIndicatorNam = ' '+ChkCspecDsV4.C_EqInd;                               //0099
             wkIdx=%lookup(wkTmpIndicatorNam : dsFileOperationInd.RcdNotFound);          //0084
             If wkIdx = 0;                                                               //0061
                dsFileOperationInd.Count +=1;                                            //0061
                wkIdx = dsFileOperationInd.Count;                                        //0061
             EndIf;                                                                      //0061
             dsFileOperationInd.RcdNotFound(wkIdx) = ' ' + ChkCspecDsV4.C_EqInd;         //0099
             dsFileOperationInd.RcdFound(wkIdx) = 'N' + ChkCspecDsV4.C_EqInd;            //0099
             dsFileOperationInd.FileName(wkIdx) = ChkCspecDsV4.C_Factor2;                //0061
             dsFileOperationInd.ResultInd(wkIdx) = 'EQ';                                 //0099
             dsFileOperationInd.RIOpcode(wkIdx)  = ChkCspecDsV4.C_Opcode;                //0099
          EndIf;                                                                         //0061

        //In case an indicator is switched on/off, check if it exists in DS.             //0061
        //In case it does, remove the data from DS.                                      //0061
        When ChkCspecDsV4.C_LoInd <> *Blanks or ChkCspecDsV4.C_EqInd <> *Blanks or       //0061
             ChkCspecDsV4.C_HiInd <> *Blanks or (ChkCspecDsV4.C_OpCode = 'EVAL'          //0061
             and %scan('*IN':%trim(ChkCspecDsV4.C_ExtFact2))= 1) or                      //0061
             ChkCspecDsV4.C_OpCode = 'EXSR';                                             //0061

           //For new subroutine, clear the indicator DS                                  //0061
           If ChkCSpecDsV4.C_OpCode='EXSR';                                              //0061
              Clear dsFileOperationInd;                                                  //0061
           EndIf;                                                                        //0061

           //Check Lo indicator position and remove from DS if found.                    //0061
           If ChkCspecDsV4.C_LoInd <> *Blanks and %lookup(ChkCspecDsV4.C_LoInd:          //0061
                                         dsFileOperationInd.RcdNotFound)<>0;             //0061
              wkTmpIndicatorNam = ' ' + ChkCspecDsV4.C_LoInd;
              wkIdx = %lookup(wkTmpIndicatorNam : dsFileOperationInd.RcdNotFound);       //0061
              Exsr RearrangedsFileOperationInd;                                          //0061
           EndIf;                                                                        //0061

           //Check Hi indicator position and remove from DS if found                     //0061
           If ChkCspecDsV4.C_HiInd <> *Blanks and %lookup(ChkCspecDsV4.C_HiInd:          //0061
                                         dsFileOperationInd.RcdNotFound)<>0;             //0061
              wkTmpIndicatorNam = ' ' + ChkCspecDsV4.C_HiInd;                            //0061
              wkIdx = %lookup( wkTmpIndicatorNam : dsFileOperationInd.RcdNotFound);      //0061
              Exsr RearrangedsFileOperationInd;                                          //0061
           EndIf;                                                                        //0061

           //Check Eq indicator position and remove from DS if found                     //0061
           If ChkCspecDsV4.C_EqInd <> *Blanks and %lookup(ChkCspecDsV4.C_EqInd:          //0061
                                     dsFileOperationInd.RcdNotFound)<>0;                 //0061
              wkTmpIndicatorNam = ' ' + ChkCspecDsV4.C_EqInd;                            //0061
              wkIdx = %lookup(wkTmpIndicatorNam : dsFileOperationInd.RcdNotFound);       //0061
              Exsr RearrangedsFileOperationInd;                                          //0061
           EndIf;                                                                        //0061

           //In case '*INxx' is found at left hand side of Eval, consider to remove      //0061
           //the indicator from DS.                                                      //0061
           If ChkCspecDsV4.C_OpCode = 'EVAL' and                                         //0061
              %scan('*IN':%trim(ChkCspecDsV4.C_ExtFact2)) = 1;                           //0061
              wkTmpIndicatorNam = ' '+%subst(%trim(ChkCSpecDsV4.C_ExtFact2):4:2);        //0061
              wkIdx = %lookup(wkTmpIndicatorNam : dsFileOperationInd.RcdNotFound);       //0061
              If wkIdx <> 0;                                                             //0061
                 Exsr RearrangedsFileOperationInd;                                       //0061
              EndIf;                                                                     //0061
            EndIf;                                                                       //0061

            //In case indicator is initialized using MOVE op-code detect and remove      //0061
            If ChkCspecDsV4.C_OpCode = 'MOVE' and                                        //0061
               %scan('*IN':%trim(ChkCspecDsV4.C_Result)) = 1;                            //0061
               wkTmpIndicatorNam = ' '+%subst(%trim(ChkCSpecDsV4.C_Result):4:2);         //0061
               wkIdx = %lookup(wkTmpIndicatorNam : dsFileOperationInd.RcdNotFound);      //0061
               If wkIdx <> 0;                                                            //0061
                 Exsr RearrangedsFileOperationInd;                                       //0061
              EndIf;                                                                     //0061
            EndIf;
        EndSl;                                                                           //0061

     ChkCSpecDsV4 = %Xlate(cwLo:cwUp:CSpecDsV4);                                         //0061
     wkPrefixPseudoCode = *Blanks;                                                       //0061
     wkSuffixPseudoCode = *Blanks;                                                       //0061
     Select;                                                                             //0061
      //Check further if the statement currently being processed has a conditional       //0061
      //indicator which was set on/off based on file operation, If so prepare data in    //0061
      //prefix pseudo code variable which will be added to pseudo code later.            //0061
      When ChkCSpecDsV4.C_N01<>*Blanks;                                                  //0061
         wkIdx = %lookup(ChkCSpecDsV4.C_N01 : dsFileOperationInd.RcdFound);              //0061

         If wkIdx = 0;                                                                   //0061
            wkIdx2 = %lookup(ChkCSpecDsV4.C_N01 : dsFileOperationInd.RcdNotFound);       //0061
            wkIdx = wkIdx2;                                                              //0099
         EndIf;                                                                          //0061

         If wkIdx <> 0;                                                                  //0099
            Exsr ResultingFileOperationInd;                                              //0099
         Endif;                                                                          //0099
                                                                                         //0099
      //Check if indicator has been used as factor 1 OR in factor 2 for comparision      //0061
      //in conditional statements. If so prepare suffix to be added in pseudo            //0061
      //code later.                                                                      //0061
       When (%scan('*IN':%trim(ChkCspecDsV4.C_Factor1)) = 1 or                           //0061
            %scan('*IN':%trim(ChkCspecDsV4.C_ExtFact2)) <> 0 ) and                       //0061
          (%subst(ChkCSpecDsV4.C_OpCode:1:2) = 'IF' or                                   //0061
          %subst(ChkCSpecDsV4.C_OpCode:1:6) = 'ELSEIF' or                                //0061
          %subst(ChkCSpecDsV4.C_OpCode:1:5) = 'CABEQ' or                                 //0061
          %subst(ChkCSpecDsV4.C_OpCode:1:5) = 'CASEQ' or                                 //0061
          %subst(ChkCSpecDsV4.C_OpCode:1:2) = 'DO' or                                    //0061
          %subst(ChkCSpecDsV4.C_OpCode:1:4) = 'WHEN');                                   //0061

          wkRIFact2Ind = *On;                                                            //0099
                                                                                         //0099
          Select;                                                                        //0061
            When %scan('*IN':%trim(ChkCspecDsV4.C_Factor1)) = 1;                         //0061
               wkTmpIndicatorNam = ' '+%subst(%trim(ChkCSpecDsV4.C_Factor1):4:2);        //0061
               wkIdx = %lookup(wkTmpIndicatorNam : dsFileOperationInd.RcdNotFound);      //0061
               If wkIdx <> 0;                                                            //0061
                 Select;                                                                 //0061
                 When %scan('*OFF' : ChkCspecDsV4.C_ExtFact2) <> 0;                      //0061
                    wkSuffixArg = '*OFF';                                                //0061
                 When %scan('*ON'  : ChkCspecDsV4.C_ExtFact2) <> 0;                      //0061
                    wkSuffixArg = '*ON' ;                                                //0061
                 When %scan('"0"' : ChkCspecDsV4.C_ExtFact2) <> 0;                       //0061
                    wkSuffixArg = '"0"' ;                                                //0061
                 When %scan('"1"' : ChkCspecDsV4.C_ExtFact2) <> 0;                       //0084
                    wkSuffixArg = '"1"' ;                                                //0061
                 EndSl;                                                                  //0061
                 Exsr ResultingFileOperationInd;                                         //0099
              EndIf;                                                                     //0061

            When %scan('*IN':%trim(ChkCspecDsV4.C_ExtFact2)) <> 0;                       //0061
               wkIdx= %scan('*IN':%trim(ChkCspecDsV4.C_ExtFact2));                       //0061
               //Check for indicator value found in File operations and if so , process //0084
               wkTmpIndicatorNam = ' '+                                                  //0084
                     %subst(%trim(ChkCSpecDsV4.C_ExtFact2): wkIdx+3 :2);                 //0084
               wkIdx = %lookup(wkTmpIndicatorNam : dsFileOperationInd.RcdNotFound);      //0084
               If wkIdx<>0;                                                              //0061
                  Select;                                                                //0084
                  When %scan('*OFF' : ChkCspecDsV4.C_ExtFact2) <> 0;                     //0084
                     wkSuffixArg = '*OFF';                                               //0084
                  When %scan('*ON'  : ChkCspecDsV4.C_ExtFact2) <> 0;                     //0084
                     wkSuffixArg = '*ON' ;                                               //0084
                  When %scan('"0"' : ChkCspecDsV4.C_ExtFact2) <> 0;                      //0084
                     wkSuffixArg = '"0"' ;                                               //0084
                  When %scan('"1"' : ChkCspecDsV4.C_ExtFact2) <> 0;                      //0084
                     wkSuffixArg = '"1"' ;                                               //0061
                  EndSl;                                                                 //0061
                  Exsr ResultingFileOperationInd;                                        //0099
               EndIf;                                                                    //0061
          EndSl;                                                                         //0061
      EndSl;                                                                             //0061

   EndSr;                                                                                //0061
   //-----------------------------------------------------------------------------------//0099
   //Subroutine ResultingFileOperationInd - Determine Prefix/Suffix Type for HI,LO,EQ   //0099
   //-----------------------------------------------------------------------------------//0099
   BegSr ResultingFileOperationInd;                                                      //0099
    	Select ;                                                                            //0099
    	When dsFileOperationInd.ResultInd(wkIdx) ='LO';                                     //0099
       wkKeywordOpcode = dsFileOperationInd.ResultInd(wkIdx);                            //0099
       Exsr FileOperationN01Fact2ActionType;   	                                         //0099

    	When dsFileOperationInd.ResultInd(wkIdx) ='HI' and                                  //0099
         %SUBST(dsFileOperationInd.RIOpcode(wkIdx):1:4) <> 'READ';                       //0099
      	wkKeywordOpcode = dsFileOperationInd.ResultInd(wkIdx);                            //0099
      	Exsr FileOperationN01Fact2ActionType;                                             //0099

    	When dsFileOperationInd.ResultInd(wkIdx) ='EQ' and                                  //0099
         %SUBST(dsFileOperationInd.RIOpcode(wkIdx):1:4) <> 'READ';                       //0099
       wkKeywordOpcode = dsFileOperationInd.ResultInd(wkIdx);                            //0099
       Exsr FileOperationN01Fact2ActionType;                                             //0099

    	When dsFileOperationInd.ResultInd(wkIdx) ='EQ' and                                  //0099
         %SUBST(dsFileOperationInd.RIOpcode(wkIdx):1:4) = 'READ';                        //0099
       wkKeywordOpcode = 'HI';                                                           //0099
       Exsr FileOperationN01Fact2ActionType;                                             //0099
    	EndSl;                                                                              //0099
                                                                                         //0099
      //Check the data in IAPSEUDOKP file and rtv wkPrefixPseudoCode                     //0099
      wkResultIndElem = %Lookup(wkKeywordOpcode+wkPrefixActionType :                     //0099
                        CSrcSpecMappingDswKey(*).Key : 1 :                               //0099
                        %Elem(CSrcSpecMappingDswKey) );                                  //0099
      If wkResultIndElem > *Zeros  and                                                   //0099
         CSrcSpecMappingDswKey(wkResultIndElem).dsSrcMapping <> *Blanks ;                //0099
         wkPrefixPseudoCode = CSrcSpecMappingDswKey(wkResultIndElem).dsSrcMapping;       //0099
      Endif ;                                                                            //0099
                                                                                         //0099
      clear wkResultIndElem;                                                             //0099
      //Check the data in IAPSEUDOKP file and rtv wkPrefixPseudoCode                     //0099
      wkResultIndElem = %Lookup(wkKeywordOpcode+wkSuffixActionType :                     //0099
                        CSrcSpecMappingDswKey(*).Key : 1 :                               //0099
                        %Elem(CSrcSpecMappingDswKey) );                                  //0099

      If wkResultIndElem > *Zeros  and                                                   //0099
         CSrcSpecMappingDswKey(wkResultIndElem).dsSrcMapping <> *Blanks ;                //0099
         wkSuffixPseudoCode = CSrcSpecMappingDswKey(wkResultIndElem).dsSrcMapping;       //0099
      Endif ;                                                                            //0099
   EndSr;                                                                                //0099

   //-----------------------------------------------------------------------------------//0099
   //Subroutine FileOperationN01Fact2ActionType - Determine Prefix Action Type          //0099
   //-----------------------------------------------------------------------------------//0099
   BegSr FileOperationN01Fact2ActionType;                                                //0099
 	                                                                                       //0099
      If wkRIFact2Ind = *Off;                                                            //0099
         Select ;                                                                        //0099
        When %scan(ChkCSpecDsV4.C_N01 : dsFileOperationInd.RcdNotFound(wkIdx)) <> 0 ;    //0099
         	wkPrefixActionType = 'PON'; 	                                                  //0099

        When %scan(ChkCSpecDsV4.C_N01 : dsFileOperationInd.RcdFound(wkIdx)) <> 0 ;       //0099
         	wkPrefixActionType = 'POFF';                                                   //0099
        EndSl;                                                                           //0099
      Else;                                                                              //0099
        Select;                                                                          //0099
        When %scan('*OFF': ChkCspecDsV4.C_ExtFact2) <> 0 or                              //0099
              %scan('"0"' : ChkCspecDsV4.C_ExtFact2) <> 0;                               //0099
            wkSuffixActionType = 'SOFF';                                                 //0099

        When %scan('*ON' : ChkCspecDsV4.C_ExtFact2) <> 0 or                              //0099
              %scan('"1"' : ChkCspecDsV4.C_ExtFact2) <> 0;                               //0099
            wkSuffixActionType = 'SON';                                                  //0099
        EndSl;                                                                           //0099
      EndIf;                                                                             //0099
                                                                                         //0099
   EndSr;                                                                                //0099 	

   //-----------------------------------------------------------------------------------//0075
   //Subroutine ConditionalIndicatorHandling - Handling of Conditional indicators       //0075
   //-----------------------------------------------------------------------------------//0075
   Begsr ConditionalIndicatorHandling;                                                   //0075
                                                                                         //0075
      //Calc Pseudo for N01 When its not a FileOperation ResultingIndicator             //0084
      If CSpecDsV4.C_N01 <> *Blanks and wkPrefixPseudoCode = *Blanks;                    //0084
                                                                                         //0075
         clear wkDataTypeElem ;                                                          //0075
         wkDataTypeElem  =  %Lookup('N01N02N03' :                                        //0075
                            CSrcSpecMappingDs(*).dsKeywrdOpcodeName : 1 :                //0075
                            %Elem(CSrcSpecMappingDs) );                                  //0075
         If wkDataTypeElem > *Zeros;                                                     //0075
            wkN01SrcMap = %Trim(CSrcSpecMappingDs(wkDataTypeElem).dsSrcMapping);         //0075
         Endif ;                                                                         //0075
                                                                                         //0075
         //Calculate conditional Indicator N01                                          //0075
         Select;                                                                         //0075
            When %subst(CSpecDsV4.C_N01:1:1) = 'N';                                      //0075
               wkN01Mapping = cwIn + %subst(CSpecDsV4.C_N01:2:2) + cwFalse;              //0075
            When CSpecDsV4.C_N01 <> *Blanks;                                             //0075
               wkN01Mapping = cwIn + %subst(CSpecDsV4.C_N01:2:2) + cwTrue;               //0075
         EndSl;                                                                          //0075
                                                                                         //0075
         //Logic For Conditional Indicator when mapping found                           //0075
         If wkN01Mapping <> *Blanks and wkN01SrcMap <> *Blanks;                          //0075
                                                                                         //0075
            Select;                                                                      //0075
               //Write Pseudo for Single line Conditional Indicator                     //0075
               When CSpecDsV4.C_Opcode <> *Blanks and                                    //0075
                    CSpecDsV4.C_Level  = *Blanks ;                                       //0075
                    wkN01PseudoCode    = %trim (wkN01SrcMap) +                           //0075
                                         %trim (wkN01Mapping) ;                          //0075
               //Calculate Pseudo for Multi line Conditional Indicator                  //0075
               When CSpecDsV4.C_Opcode = *Blanks and                                     //0075
                    CSpecDsV4.C_Level  = *Blanks ;                                       //0075
                    wkTempN01Mapping   = cwOpenParen          +                          //0075
                                         %trim (wkN01Mapping) +                          //0075
                                         cwCloseParen ;                                  //0075
               When CSpecDsV4.C_Opcode = *Blanks and                                     //0075
                    CSpecDsV4.C_Level  = 'AN';                                           //0075
                    wkTempN01Mapping   = %trim (wkTempN01Mapping) +                      //0075
                                         cwAnd + cwOpenParen      +                      //0075
                                         %trim (wkN01Mapping)     +                      //0075
                                         cwCloseParen ;                                  //0075
               When CSpecDsV4.C_Opcode = *Blanks and                                     //0075
                    CSpecDsV4.C_Level  = 'OR';                                           //0075
                      wkTempN01Mapping = %trim (wkTempN01Mapping) +                      //0075
                                          cwOr + cwOpenParen      +                      //0075
                                          %trim (wkN01Mapping)    +                      //0075
                                          cwCloseParen ;                                 //0075
               //Write Pseudo for Multi line Conditional Indicator                      //0075
               When CSpecDsV4.C_Opcode <> *Blanks and                                    //0075
                    CSpecDsV4.C_Level  = 'AN';                                           //0075
                       wkN01PseudoCode = %trim (wkN01SrcMap)      +                      //0075
                                         %trim(wkTempN01Mapping)  +                      //0075
                                         cwAnd + cwOpenParen      +                      //0075
                                         %trim (wkN01Mapping)     +                      //0075
                                         cwCloseParen ;                                  //0075
               When CSpecDsV4.C_Opcode <> *Blanks and                                    //0075
                    CSpecDsV4.C_Level  = 'OR';                                           //0075
                       wkN01PseudoCode = %trim (wkN01SrcMap)      +                      //0075
                                         %trim (wkTempN01Mapping) +                      //0075
                                         cwOr + cwOpenParen       +                      //0075
                                         %trim (wkN01Mapping)     +                      //0075
                                         cwCloseParen ;                                  //0075
            EndSl;                                                                       //0075
                                                                                         //0075
         EndIf;                                                                          //0075
      EndIf ;                                                                            //0075
   EndSr;                                                                                //0075

   //-----------------------------------------------------------------------------------//0061
   //Subroutine RearrangedsFileOperationInd - Rearrange DS dsFileOperationInd           //0061
   //-----------------------------------------------------------------------------------//0061
   Begsr RearrangedsFileOperationInd;                                                    //0061

      For wkIdx2 = wkIdx To dsFileOperationInd.Count;                                    //0061
         If wkIdx2 < dsFileOperationInd.Count;                                           //0061
            dsFileOperationInd.FileName(wkIdx2)= dsFileOperationInd.FileName(wkIdx2+1);  //0061
            dsFileOperationInd.RcdNotFound(wkIdx2)=                                      //0061
                                     dsFileOperationInd.RcdNotFound(wkIdx2+1);           //0061
            dsFileOperationInd.RcdFound(wkIdx2)=dsFileOperationInd.RcdFound(wkIdx2+1);   //0061
         Else;                                                                           //0061
            dsFileOperationInd.FileName(wkIdx2) = *Blanks;                               //0061
            dsFileOperationInd.RcdNotFound(wkIdx2)= *Blanks;                             //0061
            dsFileOperationInd.RcdFound(wkIdx2) = *Blanks;                               //0061
         EndIf;                                                                          //0061
      EndFor;                                                                            //0061
      dsFileOperationInd.Count=dsFileOperationInd.Count-1;                               //0061

   EndSr;                                                                                //0061
//------------------------------------------------------------------------------------- //0038
//Subroutine WriteFX4OutputData - Write pseudo code data to IAPSEUDOCP file for FX4     //0038
//------------------------------------------------------------------------------------- //0038
   Begsr WriteFX4OutputData;                                                             //0038

      Clear wkPseudocodeFontBkp;                                                         //0044
      //Write the Blank Line at Start of Cspec before writing the actual pseudo code    //0057
      //OR write a blank line in case "TAG" op-code is encountered.                     //0071
      If wkCspecBlankInd = *On and wkSrcSpec <>'C';                                      //0057
         wkCspecBlankInd = *Off;                                                         //0057
      EndIf;                                                                             //0057
      If (wkCspecBlankInd = *Off and wkSrcSpec='C') or wkDclType= 'TAG';                 //0071
         Clear OutParmWriteSrcDocDS.dsPseudocode ;                                       //0057
         OutParmWriteSrcDocDS.dsPseudocode = *Blanks;                                    //0057
         OutParmWriteSrcDocDS.dsSrcSpec = wkSrcSpec;                                     //0057
         IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                                   //0057
         WritePseudoCode(IOParmPointer);                                                 //0057
         If wkCspecBlankInd = *Off and wkSrcSpec='C';                                    //0071
            wkCspecBlankInd = *On;                                                       //0057
         EndIf;                                                                          //0071
      EndIf;                                                                             //0057
      Eval-Corr OutParmWriteSrcDocDS = wkFX4ParmDs;                                      //0055
      //Check if current line's rrn is same as the rrn of the main logic's start        //0038
      //line, If so write the main logic begin text.                                    //0038
      If wkFX4ParmDs.dsSrcRrn>= wkBgnRrnForMainLogic and wkBgnRrnForMainLogic <>0;       //0038
         For wkIndex = 1 to 5;                                                           //0038
            OutParmWriteSrcDocDS.dsPseudocode = wkBgnMainLogicCmnt(wkIndex);             //0038
            IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                                //0038
            WritePseudoCode(IOParmPointer);                                              //0038
         EndFor;                                                                         //0038
         wkSaveBgnRrn = wkBgnRrnForMainLogic ;                                           //0083
         wkBgnRrnForMainLogic = 0;                                                       //0038
      EndIf;                                                                             //0038

      //Write Pseudo code for Conditional Indicator with Pipe Indent                    //0075
      If wkN01PseudoCode <> *Blanks;                                                     //0075
         wkRPGIndentParmDs.dsIndentType = *Blanks ;                                      //0075
         wkRPGIndentParmDs.dsPseudocode = wkN01PseudoCode;                               //0075
         wkIOIndentParmPointer = %Addr(wkRPGIndentParmDs);                               //0075
         IndentRPGPseudoCode(wkIOIndentParmPointer);                                     //0075
         OutParmWriteSrcDocDS.dsPseudocode = wkRPGIndentParmDS.dsPseudocode;             //0075
         IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                                   //0075
         WritePseudoCode(IOParmPointer);                                                 //0075
         Clear wkN01PseudoCode ;                                                         //0075
         Clear wkTempN01Mapping ;                                                        //0075
      EndIf;                                                                             //0075

      //Add prefix to the pseudo code                                                   //0061
      If wkPrefixPseudoCode <> *Blanks;                                                  //0061
         wkPseudoCode = %Trim(wkPrefixPseudoCode) + ' ' + %Trim(wkPseudoCode);           //0061
      EndIf;                                                                             //0061
      //Add Suffix to the pseudo code                                                   //0061
      If wkSuffixPseudoCode <> *Blanks;                                                  //0061
         //Replace the words "*INxx equals *on/'1'/*off/'0'" with suffix                 //0061
         wkPseudoCode1 = %xlate(cwLO : cwUP : wkPseudoCode);                             //0061
         wkIdx = %scan('*IN' : wkPseudoCode1);                                           //0061
         If wkIdx <> 0 ;                                                                 //0061
            wkIdx2 = %check(' ' : wkPseudoCode1 : wkIdx+4);                              //0061
            If wkIdx2 <> 0;                                                              //0061
                  wkIdx2 = %scan(%trim(wkSuffixArg) : wkPseudoCode1);                    //0061
                  If wkIdx2 = 0;                                                         //0061
                     wkIdx2 = %check(' ' : wkPseudoCode1 : wkIdx2+1);                    //0061
                  Else;                                                                  //0061
                     wkIdx2 = wkIdx2 + %len(%trim(wkSuffixArg));                         //0061
                  EndIf;                                                                 //0061
                  If wkIdx2 <> 0;                                                        //0061
                      wkIdx2=%scan(' ' : wkPseudoCode1 : wkIdx2);                        //0061
                      wkPseudoCode2 = wkPseudoCode;                                      //0061
                      Clear wkPseudocode;                                                //0061
                      wkPseudoCode = %subst(wkPseudoCode2 : 1 : wkIdx-1) +' ' +          //0061
                                     %trim(wkSuffixPseudoCode) + ' ' +                   //0061
                                        %trimr(%subst(wkPseudoCode2 : wkIdx2+1));        //0061
                  EndIf;                                                                 //0061
            EndIf;                                                                       //0061
         EndIf;                                                                          //0061
      EndIf;                                                                             //0061

      //Add Indentation to the comment description to be printed before pseudo code     //0038
      If wkRPGIndentParmDs.dsCurrentIndents > *Zeros and                                 //0038
         wkActionType <> cwPrtCmntAftr and wkCommentDesc <> *Blanks ;                    //0038
         wkRPGIndentParmDs.dsIndentType = *Blanks ;                                      //0038
         wkRPGIndentParmDs.dsPseudocode = wkCommentDesc;                                 //0038
         wkIOIndentParmPointer = %Addr(wkRPGIndentParmDs);                               //0038
         IndentRPGPseudoCode(wkIOIndentParmPointer);                                     //0038
         wkCommentDesc = wkRPGIndentParmDs.dsPseudocode;                                 //0038
      EndIf;                                                                             //0038

      If OutMaxBif >= 1;                                                                 //0079
         wkStrPos = %Check(' ' : wkFX4ParmDs.dsSrcDta :7);                               //0079
         wkEndPos = %Scan(' '  : wkFX4ParmDs.dsSrcDta :wkStrPos);                        //0079

         If wkEndPos - wkStrPos > 0;                                                     //0079
            wkFXOpcode = %Subst(wkFX4ParmDs.dsSrcDta: wkStrPos:                          //0079
                                wkEndPos - wkStrPos);                                    //0079
            wkFXBif    = %Subst(wkFX4ParmDs.dsSrcDta: wkEndPos );                        //0079
         EndIf;                                                                          //0079

         wkFXOpcode = %Trim(%XLate(cwLo: cwUp: wkFXOpcode));                             //0079

         If wkFXOpcode = 'EVAL';                                                         //0079
            wkFXOpcode = *Blanks ;                                                       //0079
         EndIf;                                                                          //0079

         wkBIFCommentDes = '// ' + %TrimR(wkFXOpcode) + ' ' + %Trim(wkFXBif);            //0079

      EndIf;                                                                             //0079

      If wkRPGIndentParmDS.dsCurrentIndents > *Zeros Or wkIndentTypeBackup<>*Blanks;     //0038

         //In case no executable statement processed after indentation started,          //0038
         //Print do nothing.                                                             //0038
         If (wkIndentTypeBackup = cwRemove OR wkIndentTypeBackup = cwRemoveCheck         //0038
            or wkIndentTypeBackup = cwBranch)                                            //0038
            and                                                                          //0038
            wkRPGIndentParmDs.dsIndentIndex<>0 and                                       //0053
            (wkIndentTypeBackup <> cwBranch or (wkIndentTypeBackup = cwBranch and        //0038
             wkRPGIndentParmDs.dsIndentTypeArr(wkRPGIndentParmDs.dsIndentIndex)          //0038
             <>cwAdd))                                                                   //0038
            and                                                                          //0038
            (wkRPGIndentParmDs.dsIndentIndex<>0 and                                      //0038
            wkRPGIndentParmDs.dsIndentTypeArr(wkRPGIndentParmDs.dsIndentIndex)<>cwCASE)  //0038
            and                                                                          //0038
            wkCountOfLineProcessAfterIndentation = 0;                                    //0038

            //Write a blank line in case previous line was not blank.                    //0053
            //If wkLastWrittenData <> *Blanks;                                           //0055
            If %check(' |' : wkLastWrittenData) <> 0;                                    //0055
               OutParmWriteSrcDocDS.dsPseudocode = *Blanks;                              //0053
               IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                             //0053
               WritePseudoCode(IOParmPointer);                                           //0053
            EndIf;                                                                       //0053
            wkRPGIndentParmDS.dsIndentType = *Blanks ;                                   //0038
            wkRPGIndentParmDS.dsPseudocode = wkDoNothingComment;                         //0053
            wkIOIndentParmPointer = %Addr(wkRPGIndentParmDS);                            //0038
            IndentRPGPseudoCode(wkIOIndentParmPointer);                                  //0038
            OutParmWriteSrcDocDS.dsPseudocode = wkRPGIndentParmDS.dsPseudocode;          //0038
            IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                                //0038
            WritePseudoCode(IOParmPointer);                                              //0038
         EndIf;                                                                          //0038

         //Add indentation to BIF comment description (source data)                     //0080
         If OutMaxBif  >= 1 and wkIndentTypeBackup <> cwNewBranch;                       //0080
            wkRPGIndentParmDs.dsIndentType = *Blanks ;                                   //0080
            wkRPGIndentParmDs.dsPseudocode = wkBIFCommentDes;                            //0080
            wkIOIndentParmPointer = %Addr(wkRPGIndentParmDS);                            //0080
            IndentRPGPseudoCode(wkIOIndentParmPointer);                                  //0080
            If wkIndentTypeBackup = cwBranch and                                         //0080
               wkRPGIndentParmDS.dsIndentIndex > 0 and wkRPGIndentParmDS                 //0080
               .dsIndentTypeArr(wkRPGIndentParmDS.dsIndentIndex) = cwBranch              //0080
                and %len(%trimr(wkRPGIndentParmDS.dsPseudocode))>6;                      //0080
               wkBIFCommentDes = %subst(wkRPGIndentParmDS.dsPseudocode:6);               //0080
            Else;                                                                        //0080
               wkBIFCommentDes = wkRPGIndentParmDS.dsPseudocode;                         //0080
            EndIf;                                                                       //0080
         EndIf;                                                                          //0080

         //Add Indentation, Start/remove indentation for the pseudo-code                //0038
         wkRPGIndentParmDS.dsIndentType = wkIndentTypeBackup ;                           //0038
         wkRPGIndentParmDS.dsPseudocode = wkPseudoCode;                                  //0038
         wkIOIndentParmPointer = %Addr(wkRPGIndentParmDS);                               //0038
         IndentRPGPseudoCode(wkIOIndentParmPointer);                                     //0038
         wkPseudocode = wkRPGIndentParmDS.dsPseudocode;                                  //0038

         //For new brach start (IF Condition), split pseudo code and print two lines     //0038
         If wkIndentTypeBackup = cwNewBranch;                                            //0038
            Exsr NewBranchFX4PseudoCodeSplit;                                            //0038
         EndIf;                                                                          //0038

      EndIf;                                                                             //0038

      Clear OutParmWriteSrcDocDS  ;                                                      //0038
      OutParmWriteSrcDocDS = wkFX4ParmDS;                                                //0038

      //If Specification Header need to be added                                        //0038
      If wkDclType= 'DS' Or wkDclType = 'PR' Or wkDclType = 'PI' or                      //0081
         (wkDclType<>wkPrvDclType And wkNonBlankDclType<>*Blanks                         //0081
         And wkSrcSpec<>'C');                                                            //0081
         //Write the Specification Header                                               //0038
         Eval-Corr SpecHeaderDS =  wkFX4ParmDS;                                          //0038
         If wkSrcSpec = 'D' ;                                                            //0038
            SpecHeaderDS.dsKeyfld  = wkDclType  ;                                        //0038
         Else;                                                                           //0038
            SpecHeaderDS.dsKeyfld  = *Blanks    ;                                        //0038
         EndIf;                                                                          //0038

         outParmPointer = %Addr(SpecHeaderDS);                                           //0038
         iAWriteSpecHeader(outParmPointer);                                              //0038
         Clear OutParmWriteSrcDocDS  ;                                                   //0038
         OutParmWriteSrcDocDS = wkFX4ParmDS;                                             //0038
      EndIf;                                                                             //0038

      //Write the comment description before writing the actual pseudo code             //0038
      If wkDclType <> wkPrvDclType And wkCommentDesc <> *Blanks and                      //0038
         wkActionType <> cwPrtCmntAftr;                                                  //0038
         Clear OutParmWriteSrcDocDS.dsPseudocode ;                                       //0038
         OutParmWriteSrcDocDS.dsPseudocode = *Blanks;                                    //0038
         IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                                   //0038
         WritePseudoCode(IOParmPointer);                                                 //0038

         //Write the Commented line                                                     //0038
         OutParmWriteSrcDocDS.dsPseudocode = wkCommentDesc;                              //0038
         IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                                   //0038
         WritePseudoCode(IOParmPointer);                                                 //0038
      EndIf;                                                                             //0038

      //Add Indentation for the code to print for call statements when has parm         //0092
      If wkPseudoNext <> *Blanks and WKNoParm = *Off ;                                   //0092

         If wkRPGIndentParmDS.dsCurrentIndents > *Zeros ;                                //0092
            wkRPGIndentParmDS.dsIndentType = *Blanks ;                                   //0092
            wkRPGIndentParmDS.dsPseudocode = wkPseudoNext;                               //0092
            wkIOIndentParmPointer = %Addr(wkRPGIndentParmDS);                            //0092
            IndentRPGPseudoCode(wkIOIndentParmPointer);                                  //0092
            wkPseudoNext = wkRPGIndentParmDS.dsPseudocode;                               //0092
         EndIf;                                                                          //0092

         Clear OutParmWriteSrcDocDS.dsPseudocode ;                                       //0092

         //Write the Pseudocode to the IAPSEUDOCP file for Call statement               //0092
         OutParmWriteSrcDocDS.dsPseudocode = wkPseudoNext;                               //0092
         IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                                   //0092
         WritePseudoCode(IOParmPointer);                                                 //0092

      Endif;                                                                             //0092

      //Write the pseudocode for the nested built in function                           //0047
      If  OutMaxBif >= 1;                                                                //0047

        //Don't Write original source line as comment if its Call Statement             //0092
         If wkPseudoNext = *Blanks;                                                      //0092
            OutParmWriteSrcDocDS.dsPseudocode = wkBIFCommentDes;                         //0092
            IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                                //0092
            WritePseudoCode(IOParmPointer);                                              //0092
         EndIf;                                                                          //0092
         //Write BIF first line                                                         //0047
         OutParmWriteSrcDocDS.dsPseudocode = wkPseudoCode;                               //0047
         IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                                   //0047
         WritePseudoCode(IOParmPointer);                                                 //0047
         //Process each of the built in function extracted as individual BIF            //0047
         For wkForIndex  = OutMaxBif Downto 1;                                           //0047
            %Occur(DsNestedBif) = wkForIndex;                                            //0047
            //Add indentation before writing the BIF details:@rpglint-skip              //0080
            wkRPGIndentParmDS.dsIndentType = *Blanks ;                                   //0080
            wkRPGIndentParmDS.dsPseudocode = %trim(wDsBifPseudocode);                    //0080
            wkIOIndentParmPointer = %Addr(wkRPGIndentParmDS);                            //0080
            IndentRPGPseudoCode(wkIOIndentParmPointer);                                  //0080

            //Write the pseudocode                                                      //0047
            OutParmWriteSrcDocDS.dsPseudocode = wkRPGIndentParmDS.dsPseudocode;          //0080
            IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                                //0047
            WritePseudoCode(IOParmPointer);                                              //0047
         EndFor;                                                                         //0047
         //Write blank line at the end  of the nested bif                               //0047
         OutParmWriteSrcDocDS.dsPseudocode = *Blanks;                                    //0047
         IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                                   //0047
         WritePseudoCode(IOParmPointer);                                                 //0047
      Else;                                                                              //0047
      Clear OutParmWriteSrcDocDS.dsPseudocode ;                                          //0038

         Select ;                                                                        //0083
         When wkCallwithMultParm = *On AND wkSrcRrn = wkSaveBgnRrn ;                     //0083
         When wkCallwithMultParm = *On AND wkSrcRrn = wkSaveLstRrn ;                     //0083
            Exsr WriteFX4forCallParm ;                                                   //0083
         Other ;                                                                         //0083
            If wkSrcSpec = 'F' and wkFileConfigFlag = cwNewFormat ;                      //0091
               If wkFName <> *Blanks ;                                                   //0091
                  wkCallMode = cwWriteData ;                                             //0091
                  IaGetLogicalFileDetails(wkCallMode : dsFSpecLFNewFormat :              //0091
                                          wkKeyWrdPointer : wkKeyWrdCntr) ;              //0091
               Endif ;                                                                   //0091
            Else ;                                                                       //0091
               //Write the Pseudocode to the IAPSEUDOCP file                            //0091
               OutParmWriteSrcDocDS.dsPseudocode = wkPseudoCode;                         //0091
               IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                             //0091
               WritePseudoCode(IOParmPointer);                                           //0091
            Endif ;                                                                      //0091
         Endsl ;                                                                         //0083
                                                                                         //0083
      //Write a blank line after each condition or loop statment
      //or TAG op-code                                                                  //0071
        If wkSavIndentType = cwAdd or wkSavIndentType = cwAddCheck or                    //0047
         wkSavIndentType = cwRemove or wkSavIndentType = cwRemoveCheck                   //0071
         or wkDclType = 'TAG';                                                           //0071
         OutParmWriteSrcDocDS.dsPseudocode = *Blanks;                                    //0047
         IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                                   //0047
         WritePseudoCode(IOParmPointer);                                                 //0047
        EndIf;                                                                           //0047
      EndIf ;                                                                            //0047

      //Clear wkPseudoNext since we have printed and checked all necessary conditions   //0092
      wkPseudoNext = *Blanks ;                                                           //0092
      //Add Indentation for the code to print Next Line for call statements             //0038

      If wkIFOpcodeFlag = 'Y';                                                           //0077
         ExSr Check4IFOpcodeFX4;                                                         //0077
      EndIf;                                                                             //0077

      //Write a blank line after each condition or loop statment                        //0038
      If wkIndentTypeBackup <> *Blanks And wkSkipBlankLineInd = *Off;                    //0077
         OutParmWriteSrcDocDS.dsPseudocode = *Blanks;                                    //0038
         IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                                   //0038
         WritePseudoCode(IOParmPointer);                                                 //0038
         wkSkipBlankLineInd = *Off;                                                      //0077
      EndIf;                                                                             //0038

      //Check if current line's rrn is same as the rrn of the main logic's end line,    //0038
      //If so, write the main logic ending text.                                        //0038
      If  wkLstRrnForMainLogic<>0 and wkFX4ParmDs.dsSrcRrn>= wkLstRrnForMainLogic;       //0038
         If wkEntryCounter > *Zeros ;                                                    //0083
            wkPseudoNext = *Blanks ;                                                     //0083
            Exsr CallWritePseudoCode ;                                                   //0083
            wkPseudoNext = '//Assign values to returning parameters' ;                   //0083
            Exsr CallWritePseudoCode ;                                                   //0083
            For wkForIndex = 1 to wkEntryCounter ;                                       //0083
               wkPseudoNext = wkEntryPseudoCode(wkForIndex).PseudoCode ;                 //0083
               Exsr CallWritePseudoCode ;                                                //0083
            Endfor ;                                                                     //0083
         Endif ;                                                                         //0083
          OutParmWriteSrcDocDS.dsPseudocode = *Blanks;                                   //0038
          IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                                  //0038
          WritePseudoCode(IOParmPointer);                                                //0038
          OutParmWriteSrcDocDS.dsPseudocode = wkEndMainLogicCmnt;                        //0038
          IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                                  //0038
          WritePseudoCode(IOParmPointer);                                                //0038
          wkLstRrnForMainLogic = 0;                                                      //0038
      EndIf;                                                                             //0038

      //Write comment description after pseudo code based on action type                //0038
      If wkDclType <> wkPrvDclType And wkCommentDesc <> *Blanks and                      //0038
         wkActionType =  cwPrtCmntAftr;                                                  //0038
         //Comment                                                                      //0038
         OutParmWriteSrcDocDS.dsPseudocode = wkCommentDesc;                              //0038
         IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                                   //0038
         WritePseudoCode(IOParmPointer);                                                 //0038
      EndIf;                                                                             //0038

      //Initialize count of number of statements written after indentation started       //0038
      //or removed                                                                       //0038
      If wkIndentTypeBackup <> *Blanks  and wkIndentTypeBackup <> cwRemove;              //0038
         wkCountOfLineProcessAfterIndentation = 0;                                       //0038
      EndIf;                                                                             //0038
      wkPrevIndentType = wkIndentTypeBackup;                                             //0038

   EndSr;                                                                                //0038
//------------------------------------------------------------------------------------- //0077
//Subroutine Check4IFOpcodeFX4 - Check whether the IF Opcode has a continous AND/OR     //0077
//                               conditions. If so, Skip the Blank line in between the  //0077
//                               conditions.                                            //0077
//------------------------------------------------------------------------------------- //0077
   BegSr Check4IFOpcodeFX4;                                                              //0077

      Clear wkIFOpSrcDta;                                                                //0077
      Clear wkSkipBlankLineInd;                                                          //0077

      Exec Sql                                                                           //0077
      Declare NextConditionOfIfBlock Cursor For                                          //0077
      Select XSrcDta From iAQRpgSrc                                                      //0077
      Where XLibNam = :wkFX4ParmDs.dsSrcLib  And                                         //0077
            XSrcNam = :wkFX4ParmDs.dsSrcPf   And                                         //0077
            XMbrNam = :wkFX4ParmDs.dsSrcMbr  And                                         //0077
            XMbrTyp = :wkFX4ParmDs.dsSrcType And                                         //0077
            XSrcRrn > :wkFX4ParmDs.dsSrcRrn                                              //0077
      For Fetch Only;                                                                    //0077

      Exec Sql Open NextConditionOfIfBlock;                                              //0077

      Dow Sqlcode = SuccessCode;                                                         //0077

         Exec Sql Fetch From NextConditionOfIfBlock Into :wkIFOpSrcDta;                  //0077

         If Sqlcode = SuccessCode;                                                       //0077
            ChkCspecDsV4 = %Xlate(cwLo:cwUp:wkIFOpSrcDta);                               //0077
            ChkCspecDsV4.C_Opcode = %Trim(ChkCspecDsV4.C_Opcode);                        //0077

            Select;                                                                      //0077
            //Skip commented and blank lines while reading for Next condition           //0077
            When ChkCspecDsV4.specification = ' ' Or                                     //0077
                 ChkCspecDsV4.star = '*'          Or                                     //0077
                 ChkCspecDsV4.C_Opcode = *Blanks;                                        //0077
                 Iter;                                                                   //0077

            When ChkCspecDsV4.C_Opcode = cwANDEQ Or                                      //0077
                 ChkCspecDsV4.C_Opcode = cwANDNE Or                                      //0077
                 ChkCspecDsV4.C_Opcode = cwANDLT Or                                      //0077
                 ChkCspecDsV4.C_Opcode = cwANDLE Or                                      //0077
                 ChkCspecDsV4.C_Opcode = cwANDGT Or                                      //0077
                 ChkCspecDsV4.C_Opcode = cwANDGE Or                                      //0077
                 ChkCspecDsV4.C_Opcode = cwOREQ  Or                                      //0077
                 ChkCspecDsV4.C_Opcode = cwORNE  Or                                      //0077
                 ChkCspecDsV4.C_Opcode = cwORLT  Or                                      //0077
                 ChkCspecDsV4.C_Opcode = cwORLE  Or                                      //0077
                 ChkCspecDsV4.C_Opcode = cwORGT  Or                                      //0077
                 ChkCspecDsV4.C_Opcode = cwORGE;                                         //0077

                 wkSkipBlankLineInd = *On;                                               //0077
                 Leave;                                                                  //0077

            Other;                                                                       //0077
                 Leave;                                                                  //0077
            EndSl;                                                                       //0077

         EndIf;                                                                          //0077

      EndDo;                                                                             //0077

      Exec Sql Close NextConditionOfIfBlock;                                             //0077

   EndSr;                                                                                //0077
//------------------------------------------------------------------------------------- //0038
//Subroutine NewBranchFX4PseudoCodeSplit - Split NEW BRANCH (If condition) pseudo code  //0038
//------------------------------------------------------------------------------------- //0038
   Begsr NewBranchFX4PseudoCodeSplit;                                                    //0038

      //In case this is a new branch starting (i.e. IF condition), consider to split     //0038
      //and print part 1 of the pseudo code (split from characters ~|~|) and print it    //0038
      //first than treat the part 2 of pseudo code as a branch.                          //0038
      Clear wkPseudoCode1;                                                               //0038
      wkPseudoCode1 = wkPseudoCode;                                                      //0038
      wkIdx = %scan(cwSplitCharacter : wkPSeudoCode);                                    //0038
      If wkIdx <> 0;                                                                     //0038
         //Split                                                                         //0038
         Clear wkPSeudoCode;                                                             //0038
         wkPseudoCode = %Subst(wkPseudoCode1 : 1: wkIdx-1);                              //0038

         wkPseudocodeFontBkp = wkPseudoCode;                                             //0044

         //Write part1 of Pseudocode to the IAPSEUDOCP file                              //0038
         OutParmWriteSrcDocDS.dsPseudocode = wkPseudoCode;                               //0038
         IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                                   //0038
         WritePseudoCode(IOParmPointer);                                                 //0038
         //Write blank line after part 1                                                 //0038
         OutParmWriteSrcDocDS.dsPseudocode = *Blanks;                                    //0038
         IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                                   //0038
         WritePseudoCode(IOParmPointer);                                                 //0038

         //Add same indentation to source code data to be written for BIF               //0080
         If OutMaxBif>=1;                                                                //0080
            wkRPGIndentParmDs.dsIndentType = *Blanks ;                                   //0080
            wkRPGIndentParmDs.dsPseudocode = wkBIFCommentDes;                            //0080
            wkIOIndentParmPointer = %Addr(wkRPGIndentParmDS);                            //0080
            IndentRPGPseudoCode(wkIOIndentParmPointer);                                  //0080
            wkBIFCommentDes = wkRPGIndentParmDS.dsPseudocode;                            //0080
         EndIf;                                                                          //0080

         //Move remaining part2 to pseudocode                                            //0038
         Clear wkPSeudoCode;                                                             //0038
         wkPseudoCode = %Subst(wkPseudoCode1 : wkIdx+4);                                 //0038
         //Move indentation type as BRANCH for part 2 and add indentation                //0038
         wkIndentTypeBackup = cwBranch;                                                  //0038
         wkRPGIndentParmDS.dsIndentType = wkIndentTypeBackup ;                           //0038
         wkRPGIndentParmDS.dsPseudocode = wkPseudoCode;                                  //0038
         wkIOIndentParmPointer = %Addr(wkRPGIndentParmDS);                               //0038
         IndentRPGPseudoCode(wkIOIndentParmPointer);                                     //0038
         wkPseudocode = wkRPGIndentParmDS.dsPseudocode;                                  //0038
      EndIf;                                                                             //0038

   EndSr;                                                                                //0038
//------------------------------------------------------------------------------------- //0091
//Subroutine RetrieveAllFileKeywords - Retrieve all file related keywords               //0091
//------------------------------------------------------------------------------------- //0091
   Begsr RetrieveAllFileKeywords ;                                                       //0091
      Clear wkSrcStmt ;                                                                  //0091
      If wkDsKeyword <> *Blanks ;                                                        //0091
         Exsr RetrieveKeywordsperLine ;                                                  //0091
      Endif ;                                                                            //0091
                                                                                         //0091
      Exec Sql                                                                           //0091
         Declare SrcStmt cursor for                                                      //0091
         Select ucase(Source_Data)                                                       //0091
         From IAQRPGSRC                                                                  //0091
         Where upper(Library_Name)  = trim(:wkFX4ParmDs.dsSrcLib)                        //0091
            and upper(Sourcepf_Name) = trim(:wkFX4ParmDs.dsSrcPf)                        //0091
            and upper(Member_Name)   = trim(:wkFX4ParmDs.dsSrcMbr)                       //0091
            and upper(Member_Type)   = trim(:wkFX4ParmDs.dsSrcType)                      //0091
            and Source_Rrn           > :wkFX4ParmDs.dsSrcRrn                             //0091
            and upper(Source_Spec) = 'F' ;                                               //0091
                                                                                         //0091
      Exec Sql open SrcStmt ;                                                            //0091
      If SqlCode = CSR_OPN_COD ;                                                         //0091
         Exec Sql Close SrcStmt ;                                                        //0091
         Exec Sql Open  SrcStmt ;                                                        //0091
      Endif;                                                                             //0091
                                                                                         //0091
      If SqlCode < SuccessCode ;                                                         //0091
         uDpsds.wkQuery_Name = 'Open_srcStmt' ;                                          //0091
         IaSqlDiagnostic(uDpsds) ;                                                       //0091
      Endif ;                                                                            //0091
                                                                                         //0091
      If SqlCode = SuccessCode ;                                                         //0091
         Exec Sql Fetch SrcStmt into :wkSrcStmt ;                                        //0091
         If SqlCode < successCode ;                                                      //0091
            uDpsds.wkQuery_Name = 'Fetch_1_srcStmt' ;                                    //0091
            IaSqlDiagnostic(uDpsds) ;                                                    //0091
         Endif ;                                                                         //0091
                                                                                         //0091
         Dow SqlCode = SuccessCode ;                                                     //0091
            Clear dsFSpecDsV4 ;                                                          //0091
            dsFSpecDsV4 = wkSrcStmt ;                                                    //0091
            If dsFSpecDsV4.FileName <> *Blanks ;                                         //0091
               Leave ;                                                                   //0091
            Endif ;                                                                      //0091
            wkDsKeyword = dsFSpecDsV4.Keyword ;                                          //0091
            If wkDsKeyword <> *Blanks ;                                                  //0091
               Exsr RetrieveKeywordsperLine ;                                            //0091
            Endif ;                                                                      //0091
            Clear wkSrcStmt ;                                                            //0091
            Exec Sql Fetch SrcStmt into :wkSrcStmt ;                                     //0091
            If SqlCode < successCode ;                                                   //0091
               uDpsds.wkQuery_Name = 'Fetch_2_srcStmt' ;                                 //0091
               IaSqlDiagnostic(uDpsds) ;                                                 //0091
            Endif ;                                                                      //0091
         Enddo ;                                                                         //0091
         Exec Sql Close SrcStmt ;                                                        //0091
      Endif ;                                                                            //0091
   Endsr ;                                                                               //0091
                                                                                         //0091
//------------------------------------------------------------------------------------- //0091
//Subroutine RetrieveKeywordsperLine - Retrieve all file related keywords               //0091
//------------------------------------------------------------------------------------- //0091
   Begsr RetrieveKeywordsperLine ;                                                       //0091
      //Fetching Keyword Value                                                          //0091
      wkStrPos = %Check(' ' : wkDsKeyword : 1) ;                                         //0091
                                                                                         //0091
      Dow wkStrPos<> *Zeros ;                                                            //0091
         wkEndPos =%scan('(' : wkDskeyword : wkStrPos) ;                                 //0091
         If wkEndPos = *Zeros ;                                                          //0091
            wkEndPos =%scan(' ' : wkDskeyword : wkStrPos) ;                              //0091
         Endif ;                                                                         //0091
                                                                                         //0091
         If wkEndPos <> 0 and wkStrPos < wkEndPos ;                                      //0091
            wkKeywordStr = %subst(wkDskeyword : wkStrPos  : wkEndPos-wkStrPos) ;         //0091
         Endif ;                                                                         //0091
                                                                                         //0091
         //Get parameter values if any                                                   //0091
         wkStrPos =%scan('(' : wkDskeyword : wkStrPos) ;                                 //0091
         If wkStrPos > *Zeros ;                                                          //0091
            wkEndPos = %Scan(')' : wkDskeyword : wkStrPos) ;                             //0091
            If wkEndPos<>0 and wkEndPos>wkStrPos+1 ;                                     //0091
               wkKeywordVal = %subst(wkDskeyword :wkStrPos+1:wkEndPos-wkStrPos-1) ;      //0091
               //Store file keywords in array                                            //0091
               wkKeyWrdCntr += 1 ;                                                       //0091
               dsFSpecKeywords(wkKeyWrdCntr).dsKeyWrdDtls =                              //0091
                           %trim(wkKeywordStr) + ' - ' + %trim(wkKeywordVal) ;           //0091
            Endif ;                                                                      //0091
         Else ;                                                                          //0091
            //Store file keywords in array                                               //0091
            wkKeyWrdCntr += 1 ;                                                          //0091
            dsFSpecKeywords(wkKeyWrdCntr).dsKeyWrdDtls = %trim(wkKeywordStr) ;           //0091
         Endif ;                                                                         //0091
         wkEndPos += 1 ;                                                                 //0091
         wkStrPos = %Check(' ' : wkDsKeyword : wkEndPos) ;                               //0091
      Enddo ;                                                                            //0091
   Endsr ;                                                                               //0091
//------------------------------------------------------------------------------------- //0090
//Subroutine : CheckMonGrpOnErr - Do not generate pseudocode for On-Error when no       //0090
//             executable statement between On-Error and EndMon                         //0090
//------------------------------------------------------------------------------------- //0090
   Begsr CheckMonGrpOnErr ;                                                              //0090
                                                                                         //0090
     Exec sql declare ChkMonGrpOnErr cursor for                                          //0090
        select XSrcDta from iAQRpgSrc where                                              //0090
           XLibNam =:wkFX4ParmDs.dsSrcLib  and                                           //0090
           XSrcNam =:wkFX4ParmDs.dsSrcPf   and                                           //0090
           XMbrNam =:wkFX4ParmDs.dsSrcMbr  and                                           //0090
           XMbrTyp =:wkFX4ParmDs.dsSrcType and                                           //0090
           XSrcRrn >:wkFX4ParmDs.dsSrcRrn                                                //0090
           for fetch only;                                                               //0090
        exec sql open ChkMonGrpOnErr ;                                                   //0090
        DoW sqlcode = SuccessCode;                                                       //0090
           exec sql fetch from ChkMonGrpOnErr into :wkCLoopSrcDta;                       //0090
           If sqlcode = SuccessCode;                                                     //0090
              ChkCspecDsV4 = %Xlate(cwLo:cwUp:wkCLoopSrcDta);                            //0090
              Select;                                                                    //0090
                 //Skip commented and blank lines                                       //0090
                 When ChkCspecDsV4.specification = ' ' or                                //0090
                    ChkCspecDsV4.star = '*' or ChkCspecDsV4.C_Opcode = *Blanks;          //0090
                    Iter;                                                                //0090
                 //Leave when some thing code other than EndMon                         //0090
                 When %subst(ChkCspecDsV4.C_Opcode:1:6) <> cwEndM ;                      //0090
                    Leave;                                                               //0090
                   //Return when EndMon found immediat to On-Error                      //0090
                 Other;                                                                  //0090
                    Return RcdFound;                                                     //0090
              EndSl;                                                                     //0090
           EndIf;                                                                        //0090
        EndDo;                                                                           //0090
        Exec sql Close ChkMonGrpOnErr;                                                   //0090
   EndSr;                                                                                //0090
                                                                                         //0090
                                                                                         //0083
//------------------------------------------------------------------------------------- //0083
//Subroutine WriteFX4forCallParm - Write pseudo code for Call Statement and its         //0083
//                                  parameters                                           //0083
//------------------------------------------------------------------------------------- //0083
   Begsr WriteFX4forCallParm ;                                                           //0083
      wkSavCategory = *Blanks ;                                                          //0083
      //Sort array in order of category                                                  //0083
      If wkCallPseudoCode(1) <> *Blanks  And WkCounter >  *Zeros;                        //0083
      SortA                                                                              //0083
         %SubArr(wkCallPseudoCode : 1 : wkCounter)                                       //0083
         %fields(Category) ;                                                             //0083
      Else;                                                                              //0083
         Leavesr;                                                                        //0083
      Endif;                                                                             //0083
      //Print the Call statements with parameters                                        //0083
      //Print a blank line before the Call set                                           //0083
      wkPseudoNext = *Blanks ;                                                           //0083
      Exsr CallWritePseudoCode ;                                                         //0083
      For wkForIndex = 1 to wkCounter ;                                                  //0083
         //Before each set of Assign, Call, Return print a comment line                  //0083
         If wkSavCategory <> wkCallPseudoCode(wkForIndex).Category ;                     //0083
            Select ;                                                                     //0083
            When wkCallPseudoCode(wkForIndex).Category = 'ASSIGN' ;                      //0083
               wkPseudoNext = '//Assign values for call parameters' ;                    //0083
               Exsr CallWritePseudoCode ;                                                //0083
            When wkCallPseudoCode(wkForIndex).Category = 'CALL' ;                        //0083
               wkPseudoNext = '//Call function with listed parameters' ;                 //0083
               Exsr CallWritePseudoCode ;                                                //0083
            When wkCallPseudoCode(wkForIndex).Category = 'AENTRY' ;                      //0083
               wkPseudoNext = '//Set of parameters for the called function' ;            //0083
               Exsr CallWritePseudoCode ;                                                //0083
            When wkCallPseudoCode(wkForIndex).Category = 'CPLIST' ;                      //0083
               wkPseudoNext = '//Set of parameters for a function CALL' ;                //0083
               Exsr CallWritePseudoCode ;                                                //0083
            When wkCallPseudoCode(wkForIndex).Category = 'RETURN' ;                      //0083
               wkPseudoNext = '//Assign values from returned parameters' ;               //0083
               Exsr CallWritePseudoCode ;                                                //0083
            EndSl ;                                                                      //0083
         Endif ;                                                                         //0083
         If wkCallPseudoCode(wkForIndex).Category <> 'RETURNE' ;                         //0083
            wkPseudoNext = wkCallPseudoCode(wkForIndex).PseudoCode ;                     //0083
            Exsr CallWritePseudoCode ;                                                   //0083
            wkPseudoNext = *Blanks ;                                                     //0083
            wkSavCategory = wkCallPseudoCode(wkForIndex).Category ;                      //0083
         Endif ;                                                                         //0083
      Endfor ;                                                                           //0083
      wkCallwithMultParm = *Off ;                                                        //0083
   Endsr ;                                                                               //0083
                                                                                         //0083
//------------------------------------------------------------------------------------- //0083
//Subroutine CallWritePseudoCode - Call procedure to Write pseudo code for Statement    //0083
//                                  set to be indented and written                       //0083
//------------------------------------------------------------------------------------- //0083
   Begsr CallWritePseudoCode ;                                                           //0083
      If wkRPGIndentParmDS.dsCurrentIndents > *Zeros ;                                   //0083
         wkRPGIndentParmDS.dsIndentType = *Blanks ;                                      //0083
         wkRPGIndentParmDS.dsPseudocode = wkPseudoNext ;                                 //0083
         wkIOIndentParmPointer = %Addr(wkRPGIndentParmDS);                               //0083
         IndentRPGPseudoCode(wkIOIndentParmPointer);                                     //0083
         wkPseudoNext = wkRPGIndentParmDS.dsPseudocode;                                  //0083
      EndIf;                                                                             //0083
      Clear OutParmWriteSrcDocDS.dsPseudocode ;                                          //0083
      OutParmWriteSrcDocDS.dsPseudocode = wkPseudoNext;                                  //0083
      IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                                      //0083
      WritePseudoCode(IOParmPointer);                                                    //0083
   Endsr ;                                                                               //0083

/copy 'QCPYSRC/iaprcerlog.rpgleinc'

End-Proc IaFixedFormatParser;

//------------------------------------------------------------------------------------- //
//Procedure to Parse C spec Fixed format RPGLE code to Write Pseudocode                 //
//------------------------------------------------------------------------------------- //
Dcl-Proc IaParseCSpecPseudoCode export ;

   Dcl-Pi *n ;
      insrcData varChar(cwSrcLength);
      insrcMap  varChar(cwSrcLength);
      inPseudoCode  Char(cwSrcLength);
   End-Pi;

   Dcl-Ds lCspecDsV4 Qualified;
      specification Char(1)  pos(6);
      Star          Char(1)  pos(7);
      C_Level       Char(2)  pos(7)  ;
      C_N01         Char(3)  pos(9)  ;
      C_Factor1     Char(14) pos(12) ;
      C_Opcode      Char(10) pos(26) ;
      C_Factor2     Char(14) pos(36) ;
      C_Result      Char(14) pos(50) ;
      C_ExtFact2    Char(500) pos(36) ;
      C_Length      Char (5) pos(64) ;
      C_Decimal     Char (2) pos(69) ;
      C_HiInd       Char(2)  pos(71) ;
      C_LoInd       Char(2)  pos(73) ;
      C_EqInd       Char(2)  pos(75) ;
      C_Comment     Char(20) pos(81) ;
   End-Ds;

   //Declaration of work variables
   Dcl-S wkPseudoCode   Char(cwSrcLength)     inz;
   Dcl-S wkTmpVar       Char(10)              Inz;                                       //0062
   Dcl-S wkSrcDta       VarChar(cwSrcLength)  Inz;                                       //0016
   Dcl-S wkVar1         VarChar(cwSrcLength)  Inz;                                       //0016
   Dcl-S wkVar2         VarChar(cwSrcLength)  Inz;                                       //0016
   Dcl-S wkStrPos       Packed(5:0)           Inz;                                       //0016
   Dcl-S wkEndPos       Packed(5:0)           Inz;                                       //0016
   Dcl-S wkPos          Packed(5:0)           Inz;                                       //0026
   Dcl-S WkOpnBr        Packed(5:0)           Inz;                                       //0026
   Dcl-S WkClsBr        Packed(5:0)           Inz;                                       //0026
   Dcl-S WkIdx          Packed(4:0)           Inz;                                       //0042
   Dcl-S wkProcName     VarChar(cwSrcLength)  Inz;                                       //0026
   Dcl-S wkParm         VarChar(cwSrcLength)  Inz;                                       //0026
   Dcl-S wkString       VarChar(cwSrcLength)  Inz;                                       //0026
   Dcl-S wkWithPos      Packed(5:0)           Inz;                                       //0026
   Dcl-S wkDataTypeElem Zoned(4:0)            Inz;                                       //0083
   Dcl-S wkIndex        Packed(5:0)           Inz;                                       //0083
   Dcl-S wkMode         Char(1)               Inz;                                       //0083

   //Copybook declaration
/copy 'QCPYSRC/iaprderlog.rpgleinc'
   wkuDpsds.nbrparms = %parms;                                                           //0030
   EvaluatePSDS() ;                                                                      //0030

   Clear lCspecDsV4;
   Clear wkPseudoCode;
   wkPseudoCode = insrcMap;

   lCspecDsV4  = insrcData;                                                              //0050
                                                                                         //0083
   //Set Mode as G-Get PseudoCode                                                        //0083
   wkMode = 'G' ;                                                                        //0083
   Exsr ProcessParmStmt ;                                                                //0083
                                                                                         //0083
   //In IaPseudoMP for FX4 &  C spec, &Var1 represents Factor1, &ExtdVar2 represents
   //Extended Factor2 &Var2 represents Factor2 and &Var3 represents result entries
   //in fixed format
   If %Scan('&EVar1' : insrcMap : 1) > *Zeros;                                           //0016
      wkSrcDta = %Trim(lCspecDsV4.C_ExtFact2) ;                                          //0016
      wkEndPos =  %Scan('=' : wkSrcDta : 1);                                             //0016
                                                                                         //0016
      If wkEndPos > *Zeros ;                                                             //0016
         wkVar1  =  %Trim(%Subst(wkSrcDta : 1 : (wkEndPos-1)));                          //0016
         wkVar2  =  %Trim(%Subst(wkSrcDta : wkEndPos+1));                                //0016
                                                                                         //0016
         wkPseudoCode = %ScanRpl('&EVar1': wkVar1 :wkPseudoCode);                        //0016
         wkPseudoCode = %ScanRpl('&EVar2': wkVar2 :wkPseudoCode);                        //0016
      EndIf;                                                                             //0016
   EndIf;                                                                                //0016

   If %Scan('&Var1' : insrcMap : 1) > *zeros;
      wkPseudoCode = %ScanRpl('&Var1':%Trim(lCspecDsV4.c_factor1):
                           wkPseudoCode);
   EndIf;
   If %Scan('&ExtdVar2' : insrcMap : 1) > *zeros;
      wkPseudoCode = %ScanRpl('&ExtdVar2':%Trim(lCspecDsV4.C_ExtFact2):
                           wkPseudoCode);
   EndIf;
   //In IAPseudoMP for FX4 &  C spec, &Var1 represents Factor1,                         //0026
   //&Var2 represents Factor2,  &Proc1 represents Procedure Name                        //0026
   //&Parm1 represents Parameter Name in fixed format                                   //0026
   //                                                                                    //0026
   If %Scan('&Proc1' : insrcMap : 1) > *zeros;                                           //0026
                                                                                         //0026
      WkOpnBr  = %Scan( '(' : %Trim(lCspecDsV4.C_ExtFact2) :1) ;                         //0026
      WkClsBr  = %ScanR(')' : %Trim(lCspecDsV4.C_ExtFact2)) ;                            //0026
      If WkOpnBr  > 1 ;                                                                  //0026
                                                                                         //0026
      //Extract Procedure Name                                                          //0026
         wkProcName = %Subst(%Trim(lCspecDsV4.C_ExtFact2) : 1 : WkOpnBr-1);              //0026
                                                                                         //0026
         If WkClsBr - WkOpnBr  > 1 ;                                                     //0026
            //Extract Parameter Name                                                    //0026
            wkParm  = %Subst(%Trim(lCspecDsV4.C_ExtFact2) :WkOpnBr+1 :                   //0026
                                WkClsBr - WkOpnBr-1) ;                                   //0026
         EndIf;                                                                          //0026
                                                                                         //0026
         wkParm  = %ScanRpl(':' : ',': wkParm );                                         //0026
         wkString   = %ScanRpl('&Proc1':wkProcName : insrcmap);                          //0026
         wkString   = %ScanRpl('&Parm1':wkParm : wkString);                              //0026
                                                                                         //0089
      //Extract Procedure Name for CALLP without Brackets                               //0092
      ElseIf lCspecDsV4.C_ExtFact2 <> *Blanks and                                        //0092
             %subst(lCspecDsV4.C_Opcode : 1 : 5) = 'CALLP';                              //0092
                                                                                         //0092
         wkString = %ScanRpl('&Proc1':%Trim(lCspecDsV4.C_ExtFact2) :                     //0092
                               insrcmap);                                                //0092
      Endif ;                                                                            //0026
                                                                                         //0026
   Endif ;                                                                               //0026
                                                                                         //0026
   Exsr SetDateTimeParms;                                                                //0098
   If %Scan('&Var2' : insrcMap : 1) > *zeros;
      If %Scan(':' : lCspecDsV4.c_factor2) > *Zeros ;                                    //0098
         If %Scan('&Unit': wkPseudoCode) > *Zeros ;                                      //0098
            wkPseudoCode = %ScanRpl('&Unit' : %trim(%subst(lCspecDsV4.c_factor2          //0098
                                    : %Scan(':' : lCspecDsV4.c_factor2) + 1))            //0098
                                    : wkPseudoCode) ;                                    //0098
            wkPseudoCode = %ScanRpl('&Var2' : %subst(lCspecDsV4.c_factor2 : 1            //0098
                                     : %Scan(':' : lCspecDsV4.c_factor2) - 1)            //0098
                                     : wkPseudoCode) ;                                   //0098
         Else ;                                                                          //0098
            wkPseudoCode = %ScanRpl('&Var2':%Trim(lCspecDsV4.c_factor2):                 //0098
                                    wkPseudoCode);                                       //0098
         Endif ;                                                                         //0098
      Else ;                                                                             //0098
         wkPseudoCode = %ScanRpl('&Var2':%Trim(lCspecDsV4.c_factor2):                    //0098
                                 wkPseudoCode);                                          //0098
      Endif ;                                                                            //0098
      If (WkDcltype  =  'ADDDUR'  Or  WkDcltype  =  'SUBDUR' Or                          //0098
         WkDcltype   =  'EXTRCT');                                                       //0098
        wkPseudoCode =  %Scanrpl(':' : ' ' : wkPseudoCode);                              //0098
        wkPseudoCode =  %Scanrpl('*' : ' ' : wkPseudoCode);                              //0098
        wkPseudoCode =  %Scanrpl('  ' : ' ': wkPseudoCode);                              //0098
      EndIf;                                                                             //0098
      WkString = wkPseudoCode  ;                                                         //0026
   EndIf;

   If %Scan('&Var3' : insrcMap : 1) > *zeros;
      wkPseudoCode = %ScanRpl('&Var3':%Trim(lCspecDsV4.C_Result):
                           wkPseudoCode);
      WkString = wkPseudoCode  ;                                                         //0026
      WkParm   = %Trim(lCspecDsV4.C_Result);                                             //0026
   EndIf;

   If %Scan('&H' : insrcMap : 1) > *zeros;
      wkPseudoCode = %ScanRpl('&H':%Trim(lCspecDsV4.C_HiInd):
                           wkPseudoCode);
   EndIf;
   If %Scan('&L' : insrcMap : 1) > *zeros;
      wkPseudoCode = %ScanRpl('&L':%Trim(lCspecDsV4.C_LoInd):
                           wkPseudoCode);
   EndIf;
   If %Scan('&E' : insrcMap : 1) > *zeros;
      wkPseudoCode = %ScanRpl('&E':%Trim(lCspecDsV4.C_EqInd):
                           wkPseudoCode);
   EndIf;

   If %Scan('&OFFILE' : inSrcMap : 1) > *zeros;                                          //0062
         wkTmpVar = *Blanks;                                                             //0062
         Select;                                                                         //0062
         When lCspecDsV4.C_Factor2 <> *Blanks;                                           //0062
            wkTmpVar = %Trim(%xlate(cwLo : cwUp : lCspecDsV4.C_Factor2));                //0062
         When lCspecDsV4.C_Result <> *Blanks;                                            //0062
            wkTmpVar = %Trim(%xlate(cwLo : cwUp : lCspecDsV4.C_Result));                 //0062
         EndSl;                                                                          //0062

         If wkTmpVar <> *Blanks;                                                         //0062
            wkIdx = %lookup(%Trim(wkTmpVar) :                                            //0062
                 DsDeclaredFileRecordFormats.RecordFormatName :  1 :                     //0042
                 DsDeclaredFileRecordFormats.Count);                                     //0042
         EndIf;                                                                          //0062

         Select;                                                                         //0062
         When wkIdx <> 0;                                                                //0062
            wkPseudoCode = %ScanRpl('&OFFILE':                                           //0082
                           %Trim(DsDeclaredFileRecordFormats.FileName(wkIdx)):           //0082
                           wkPSeudoCode);                                                //0082
         Other;                                                                          //0062
            //Check if file name has been used instead of record format                  //0062
            wkIdx = %lookup(%Trim(wkTmpVar) : DsDeclaredFileRecordFormats.FileName :     //0062
                     1 : DsDeclaredFileRecordFormats.Count);                             //0062
            If wkIdx <> 0;                                                               //0062
               wkPseudoCode=%ScanRpl('&OFFILE' : %Trim(wkTmpVar) : wkPSeudoCode);        //0062
            EndIf;                                                                       //0062
                                                                                         //0062
         EndSl;                                                                          //0062
   EndIf;                                                                                //0042
   //Replace &PFNAME by name of the physical file of the dependent                       //0062
   If %Scan('&PFNAME' : inSrcMap : 1) > *zeros;                                          //0062
         wkTmpVar = *Blanks;                                                             //0062
         Select;                                                                         //0062
         When lCspecDsV4.C_Factor2 <> *Blanks;                                           //0062
            wkTmpVar = %Trim(%xlate(cwLo : cwUp : lCspecDsV4.C_Factor2));                //0062
         When lCspecDsV4.C_Result <> *Blanks;                                            //0062
            wkTmpVar = %Trim(%xlate(cwLo : cwUp : lCspecDsV4.C_Result));                 //0062
         EndSl;                                                                          //0062

         If wkTmpVar <> *Blanks;                                                         //0062
            wkIdx = %lookup(%Trim(wkTmpVar) :                                            //0062
                 DsDeclaredFileRecordFormats.RecordFormatName :  1 :                     //0062
                 DsDeclaredFileRecordFormats.Count);                                     //0062
            //Check if file name has been used                                           //0062
            If wkIdx = 0;
               wkIdx = %lookup(%Trim(wkTmpVar) : DsDeclaredFileRecordFormats.FileName :  //0062
                     1 : DsDeclaredFileRecordFormats.Count);                             //0062
            EndIf;                                                                       //0062
         EndIf;                                                                          //0062

         If wkIdx <> 0;                                                                  //0062
            wkPseudoCode=%ScanRpl('&PFNAME':                                             //0062
               %trim(DsDeclaredFileRecordFormats.PFName(wkIdx)) : wkPSeudoCode);         //0062
         EndIf;                                                                          //0062

   EndIf;                                                                                //0062

   wkPseudoCode = %ScanRpl('='  : ' Equals '       : wkPseudoCode);
   wkPseudoCode = %ScanRpl('<>' : ' Not Equal '    : wkPseudoCode);
   wkPseudoCode = %ScanRpl('<'  : ' Less Than '    : wkPseudoCode);                      //0064
   wkPseudoCode = %ScanRpl('>'  : ' Greater Than ' : wkPseudoCode);
                                                                                         //0083
   //Set Mode as S-Store PseudoCode                                                      //0083
   wkMode = 'S' ;                                                                        //0083
   Exsr ProcessParmStmt ;                                                                //0083
                                                                                         //0026
   //In IaPseudoMP file, scan |~ to separate the mapping in 2 lines as below            //0026
   //Call Procedure/Program MS80A2 with                                                 //0026
   //Parameters : IN_SUP                                                                //0026
   WkPos  = %Scan('|~': wkString:1);                                                     //0026
                                                                                         //0026
   If WkPos > 1 ;                                                                        //0026
      WKNoParm = *Off ;                                                                  //0026
      //Swap CALL Pseudo to PseudoNext and Its parm to Pseudocode                       //0092
      wkPseudoNext = %Subst(wkString : 1 : WkPos-1) ;                                    //0092
      wkPseudoCode = %Subst(wkString : WkPos+2) ;                                        //0092
      //Incase if parameters = *Blanks , then "with" should not be printed              //0026
      //It should be printed as below :                                                 //0026
      //Call Procedure/Program MS80A2                                                   //0026
      If WkParm = *Blanks  ;    // No Parameters case                                    //0026
         wkNoParm = *On;                                                                 //0026
         // If no Parm, swap CALL Pseudo value back to wkPseudoCode                     //0092
         wkWithPos    = %ScanR('with' : %Trim(wkPseudoNext) ) ;                          //0092
                                                                                         //0026
         If wkWithPos = %Len(%Trim(wkPseudoNext)) - 3;                                   //0092
            wkPseudoCode = %Subst(wkPseudoNext : 1: wkWithPos-1) ;                       //0092
            wkPseudoNext = *Blanks ;                                                     //0026
         EndIf;                                                                          //0026
      EndIf;                                                                             //0026
      //If Call statement with Parameter in Result field                                 //0083
      If wkPseudoNext <> *Blanks ;                                                       //0083
         wkCallwithMultParm = *Off ;                                                     //0083
      Endif ;                                                                            //0083
      //Store the Call statement to be printed                                           //0083
      If wkCallwithMultParm = *On ;                                                      //0083
         wkCounter += 1 ;                                                                //0083
         wkCallPseudoCode(wkCounter).Category = 'CALL' ;                                 //0083
         wkCallPseudoCode(wkCounter).PseudoCode = wkPseudoCode ;                         //0083
         wkCounter += 1 ;                                                                //0083
         wkCallPseudoCode(wkCounter).Category = 'PARM' ;                                 //0083
         wkCallPseudoCode(wkCounter).PseudoCode = wkPseudoNext ;                         //0083
         wkSavPos = wkPos ;                                                              //0083
      Endif ;                                                                            //0083
   EndIf;                                                                                //0026
   //If opcode is PLIST, set SavPos to process PARM keywords                             //0083
   If lCSpecDsV4.C_Opcode = 'PLIST' AND wkCallwithMultParm = *On ;                       //0083
      wkSavPos = 1 ;                                                                     //0083
      wkCounter += 1 ;                                                                   //0083
      If CSpecDsV4.C_Factor1 = '*ENTRY' ;                                                //0083
         wkCallPseudoCode(wkCounter).Category = 'AENTRY' ;                               //0083
         wkCallPseudoCode(wkCounter).PseudoCode = wkPseudoCode ;                         //0083
         wkCounter += 1 ;                                                                //0083
         wkCallPseudoCode(wkCounter).Category = 'APARM' ;                                //0083
         wkCallPseudoCode(wkCounter).PseudoCode = CSpecDsV4.C_Result ;                   //0083
      Else ;                                                                             //0083
         wkCallPseudoCode(wkCounter).Category = 'CPLIST' ;                               //0083
         wkCallPseudoCode(wkCounter).PseudoCode = wkPseudoCode ;                         //0083
         wkCounter += 1 ;                                                                //0083
         wkCallPseudoCode(wkCounter).Category = 'PARM' ;                                 //0083
         wkCallPseudoCode(wkCounter).PseudoCode = CSpecDsV4.C_Result ;                   //0083
      Endif ;                                                                            //0083
   Endif ;                                                                               //0083
                                                                                         //0083
   inPseudoCode = wkPseudoCode ;

   Return ;
                                                                                         //0083
//------------------------------------------------------------------------------------- //0098
//Subroutine SetDateTimeParms: Cleanup and setup date/time parms,expand abbreviations   //0098
//                             as applicable                                            //0098
//------------------------------------------------------------------------------------- //0098
   Begsr SetDateTimeParms;                                                               //0098
      If (WkDcltype  =  'ADDDUR'  Or  WkDcltype  =  'SUBDUR' Or                          //0098
         WkDcltype   =  'EXTRCT');                                                       //0098
                                                                                         //0098
         Select;                                                                         //0098
            When %Scan('*Y ' :  lCspecDsV4.c_factor2) > *Zeros;                          //0098
            lCspecDsV4.c_factor2  =  %Scanrpl('*Y ' : 'YEARS' : lCspecDsV4.c_factor2);   //0098
                                                                                         //0098
            When %Scan('*M ' :  lCspecDsV4.c_factor2) > *Zeros;                          //0098
            lCspecDsV4.c_factor2  =  %Scanrpl('*M ' : 'MONTHS ' : lCspecDsV4.c_factor2); //0098
                                                                                         //0098
            When %Scan('*D ' :  lCspecDsV4.c_factor2) > *Zeros;                          //0098
            lCspecDsV4.c_factor2  =  %Scanrpl('*D ' : 'DAYS ' : lCspecDsV4.c_factor2);   //0098
                                                                                         //0098
            When %Scan('*H ' :  lCspecDsV4.c_factor2) > *Zeros;                          //0098
            lCspecDsV4.c_factor2  =  %Scanrpl('*H ' : 'HOURS ' : lCspecDsV4.c_factor2);  //0098
                                                                                         //0098
            When %Scan('*MN ' :  lCspecDsV4.c_factor2) > *Zeros;                         //0098
            lCspecDsV4.c_factor2  =  %Scanrpl('*MN ' : 'MINUTES ' :                      //0098
                                     lCspecDsV4.c_factor2);                              //0098
                                                                                         //0098
            When %Scan('*S ' :  lCspecDsV4.c_factor2) > *Zeros;                          //0098
            lCspecDsV4.c_factor2  =  %Scanrpl('*S ' : 'SECONDS ' :                       //0098
                                     lCspecDsV4.c_factor2);                              //0098
                                                                                         //0098
            When %Scan('*MS ' :  lCspecDsV4.c_factor2) > *Zeros;                         //0098
            lCspecDsV4.c_factor2  =  %Scanrpl('*MS ' : 'MILI-SEC ' :                     //0098
                                     lCspecDsV4.c_factor2);                              //0098
         Endsl;                                                                          //0098
                                                                                         //0098
      Endif;                                                                             //0098
                                                                                         //0098
   Endsr;                                                                                //0098
//------------------------------------------------------------------------------------- //0083
//Subroutine ProcessParmStmt - Check for optional factors in PARM stmt and form sub     //0083
//                              statements                                               //0083
//------------------------------------------------------------------------------------- //0083
   Begsr ProcessParmStmt ;                                                               //0083
      Select ;                                                                           //0083
      When wkMode = 'G' ;                                                                //0083
         //When PARM keyword occurs, process factors and store parameters                //0083
         If wkCallwithMultParm = *On AND wkSavPos <> *Zeros ;                            //0083
            //Check for opcode in IAPSEUDOKP file if different factor combinations       //0083
            //are present - Factor1/Factor2/Both present                                 //0083
            wkActionType = *Blanks ;                                                     //0083
            If lCSpecDsV4.C_Factor1 <> *Blanks ;                                         //0083
               If wkEntryParm = 'Y' ;                                                    //0083
                  wkActionType = %Trim(wkActionType) + 'F1*' ;                           //0083
               Else ;                                                                    //0083
                  wkActionType = %Trim(wkActionType) + 'F1' ;                            //0083
               Endif ;                                                                   //0083
            Endif ;                                                                      //0083
            If lCSpecDsV4.C_Factor2 <> *Blanks ;                                         //0083
               If wkEntryParm = 'Y' ;                                                    //0083
                  wkActionType = %Trim(wkActionType) + 'F2*' ;                           //0083
               Else ;                                                                    //0083
                  wkActionType = %Trim(wkActionType) + 'F2' ;                            //0083
               Endif ;                                                                   //0083
            Endif ;                                                                      //0083
            //Check the data in IAPSEUDOKP file                                          //0083
            wkDataTypeElem = %Lookup(wkDclType+wkActionType :                            //0083
                              CSrcSpecMappingDswKey(*).Key : 1 :                         //0083
                              %Elem(CSrcSpecMappingDswKey) );                            //0083
            //Use alternate mapping from IAPSEUDOKP file if any optional paramter        //0083
            //is found in code else use mapping from IAPSEUDOMP file                     //0083
            If wkDataTypeElem > *Zeros  AND                                              //0083
               CSrcSpecMappingDswKey(wkDataTypeElem).dsSrcMapping <> *Blanks ;           //0083
               insrcMap = CSrcSpecMappingDswKey(wkDataTypeElem).dsSrcMapping ;           //0083
               wkPseudoCode = CSrcSpecMappingDswKey(wkDataTypeElem).dsSrcMapping ;       //0083
            Endif ;                                                                      //0083
         Endif ;                                                                         //0083
      When wkMode = 'S' ;                                                                //0083
         //Store pseudocode for PARM keywords                                            //0083
         If wkCallwithMultParm = *On AND wkSavPos <> *Zeros ;                            //0083
            Select ;                                                                     //0083
            When wkActionType = 'F1' ;                                                   //0083
               wkCounter += 1 ;                                                          //0083
               wkCallPseudoCode(wkCounter).Category = 'RETURN' ;                         //0083
               wkCallPseudoCode(wkCounter).PseudoCode = wkPseudoCode ;                   //0083
            When wkActionType = 'F2' ;                                                   //0083
               wkCounter += 1 ;                                                          //0083
               wkCallPseudoCode(wkCounter).Category = 'ASSIGN' ;                         //0083
               wkCallPseudoCode(wkCounter).PseudoCode = wkPseudoCode ;                   //0083
            When wkActionType = 'F1F2'  OR wkActionType = 'F1*F2*';                      //0083
               wkCounter += 1 ;                                                          //0083
               wkIndex = %Scan('\\' : wkPseudoCode) ;                                    //0083
               wkCallPseudoCode(wkCounter).Category = 'ASSIGN' ;                         //0083
               wkCallPseudoCode(wkCounter).PseudoCode =                                  //0083
                     %subst(wkPseudoCode : 1 : wkIndex-1) ;                              //0083
               wkCounter += 1 ;                                                          //0083
               If wkActionType = 'F1*F2*' ;                                              //0083
                  wkCallPseudoCode(wkCounter).Category = 'RETURNE' ;                     //0083
               Else ;                                                                    //0083
                  wkCallPseudoCode(wkCounter).Category = 'RETURN' ;                      //0083
               Endif ;                                                                   //0083
               wkCallPseudoCode(wkCounter).PseudoCode =                                  //0083
                     %subst(wkPseudoCode : wkIndex+2) ;                                  //0083
            When wkActionType = 'F1*' ;                                                  //0083
               wkCounter += 1 ;                                                          //0083
               wkCallPseudoCode(wkCounter).Category = 'ASSIGN' ;                         //0083
               wkCallPseudoCode(wkCounter).PseudoCode = wkPseudoCode ;                   //0083
            When wkActionType = 'F2*' ;                                                  //0083
               wkCounter += 1 ;                                                          //0083
               wkCallPseudoCode(wkCounter).Category = 'RETURNE' ;                        //0083
               wkCallPseudoCode(wkCounter).PseudoCode = wkPseudoCode ;                   //0083
            EndSl ;                                                                      //0083
            wkIndex = %lookup('PARM' : wkCallPseudoCode(*).Category :                    //0083
                                 1 : %Elem(wkCallPseudoCode)) ;                          //0083
            If wkIndex = *Zeros ;                                                        //0083
               wkIndex = %lookup('APARM' : wkCallPseudoCode(*).Category :                //0083
                                    1 : %Elem(wkCallPseudoCode)) ;                       //0083
            Endif ;                                                                      //0083
            If wkIndex > *Zeros ;                                                        //0083
               If wkCallPseudoCode(wkIndex).PseudoCode = *Blanks ;                       //0083
                  wkCallPseudoCode(wkIndex).PseudoCode =                                 //0083
                        'With Parameters: ' + lCSpecDsV4.C_Result ;                      //0083
               Else ;                                                                    //0083
                  wkCallPseudoCode(wkIndex).PseudoCode =                                 //0083
                           %trim(wkCallPseudoCode(wkIndex).PseudoCode) +                 //0083
                           ', ' + lCSpecDsV4.C_Result ;                                  //0083
               Endif ;                                                                   //0083
            Endif ;                                                                      //0083
         Endif ;                                                                         //0083
      EndSl ;                                                                            //0083
   Endsr ;                                                                               //0083

/copy 'QCPYSRC/iaprcerlog.rpgleinc'
End-Proc IaParseCSpecPseudoCode;

//------------------------------------------------------------------------------------- //
//Procedure to Fetch the Fixed Format Data Type Description                             //
//------------------------------------------------------------------------------------- //
Dcl-Proc LoadFixedDataTypeMap Export ;

   //Copybook declaration
/copy 'QCPYSRC/iaprderlog.rpgleinc'

   Dcl-S  wkArrElem          Packed(2:0)     Inz;
   Dcl-C  cwFxDataType       Const('FIXED_DATATYPE');

   wkuDpsds.nbrparms = %parms;                                                           //0030
   EvaluatePSDS() ;                                                                      //0030

   wkArrElem = %Elem(wkFxDataTypeDs);

   //Fetching the Data Type Description
   Exec Sql
      Declare iADataTypeCsr Cursor for
         Select Key_Name2, Key_Value1
            From iABckCnfg
          Where Key_Name1 = :cwFxDataType;

   Exec Sql
      Open iADataTypeCsr;

   If SqlCode = Csr_Opn_Cod;
      Exec Sql Close iADataTypeCsr;
      Exec Sql Open  iADataTypeCsr;
   EndIf;

   If SqlCode < SuccessCode;
      uDpsds.wkQuery_Name = 'Open_iADataTypeCsr';
      IaSqlDiagnostic(uDpsds);
   EndIf;

   Exec Sql
      Fetch iADataTypeCsr for :wkArrElem rows Into :wkFxDataTypeDs;

   Exec Sql
      Close iADataTypeCsr;

/copy 'QCPYSRC/iaprcerlog.rpgleinc'

End-Proc LoadFixedDataTypeMap;

//------------------------------------------------------------------------------------- //
//Procedure to Parse Fixed format RPGLE code to Write Pseudocode                        //
//------------------------------------------------------------------------------------- //
Dcl-Proc IaSqlPseudocodeParser  Export ;

   Dcl-Pi *n Ind;
        inParmPointer Pointer;
   End-Pi;

   Dcl-Ds wkFX4ParmDS Qualified based(inParmPointer);
      dsReqId        Char(18);
      dsSrcLib       Char(10);
      dsSrcPf        Char(10);
      dsSrcMbr       Char(10);
      dssrcType      Char(10);
      dsSrcRrn       Packed(6:0);
      dsSrcSeq       Packed(6:2);
      dsSrcLtyp      Char(5);
      dsSrcSpec      Char(1);
      dsSrcLnct      Char(1);
      dsSrcDta       VarChar(cwSrcLength);
      dsIOIndentParmPointer Pointer;                                                     //0038
      dsDclType      Char(10);
      dsSubType      Char(10);
   End-Ds;

   //Local DS to hold indentation data                                                  //0038
   Dcl-Ds wkRPGIndentParmDS LikeDS(RPGIndentParmDSTmp);                                  //0038
   //Declaration of work variables
   Dcl-S  wkSrcDta             VarChar(cwSrcLength)  Inz;
   Dcl-S  wkPseudoCode         Char(cwSrcLength)     Inz;
   Dcl-S  wkKeyField           VarChar(10);
   Dcl-S  wkKeyMapping         VarChar(200);
   Dcl-S  wkSrcMbr             Char(10)       Inz;
   Dcl-S  wkScanPos            Packed(4:0)    Inz;                                       //0001
   Dcl-S  wkIdx                Packed(5:0)    Inz;                                       //0029
   Dcl-S  wkKeyfieldPos        Packed(5:0)    Inz;                                       //0094
   Dcl-S  wkSrcMtyp            Char(10);
   Dcl-S  wkSrcLtyp            Char(5);
   Dcl-S  wkSrcSpec            Char(1);
   Dcl-S  wkIsExists           Char(1);                                                  //0094
   Dcl-S  wkDclType            Char(10)       Inz;
   Dcl-S  wkSqlOpcode          Char(20);                                                 //0094
   Dcl-S  RcdFound             Ind            inz('0');
   Dcl-S  wkPrvSubType         Char(10)       Inz;
   Dcl-S  wkPrvDclType         Char(10)       Inz;
   Dcl-S  wkIndentLevel        Packed(5:0)    Inz;
   Dcl-S  IOParmPointer        Pointer        Inz(*Null);
   Dcl-S  wkIOIndentParmPointer Pointer;                                                 //0038

   //Copybook declaration
/copy 'QCPYSRC/iaprderlog.rpgleinc'
   wkuDpsds.nbrparms = %parms;                                                           //0030
   EvaluatePSDS() ;                                                                      //0030

   //Initialise the variables
   Clear wkPseudoCode;
   IOIndentParmPointer = wkFX4ParmDs.dsIOIndentParmPointer;                              //0038
   Eval-Corr wkRPGIndentParmDs = RPGIndentParmDs;                                        //0038
   wkDclType      =   *Blanks;
   wkPrvSubType   =   *Blanks;
   RcdFound       =   False;
   wkSrcMbr       =   wkFX4ParmDs.dsSrcMbr ;
   wkSrcMtyp      =   wkFX4ParmDs.dssrcType;
   wkSrcLtyp      =   wkFX4ParmDs.dsSrcLtyp;
   wkSrcSpec      =   wkFX4ParmDs.dsSrcSpec;
   wkSrcDta       =   wkFX4ParmDs.dsSrcDta;
   wkIndentLevel  =   wkRPGIndentParmDs.dsCurrentIndents;                                //0038
   wkPrvDclType   =   wkFX4ParmDs.dsDclType;
   wkPrvSubType   =   wkFX4ParmDs.dsSubType;

   wkSrcdta  = %Xlate(cwLO:cwUP:wksrcdta);
   wkSrcdta  = squeezeString(wkSrcdta);                                                  //0094
   wkScanpos = %Scan('EXEC SQL' : wkSrcDta);

   If  wkScanpos > 0 ;  //Emg
     wkSrcDta  = %Subst(wkSrcdta : wkScanpos);
   Endif ;    //Emg

   If wkSrcLtyp = 'FFC' or wkSrcLtyp = 'FFR';
      wkScanpos = %Scan(';' : wkSrcDta);
   If  wkScanpos > 1 ;  //Emg
      wkSrcDta  = %Subst(wkSrcdta : 1 : wkScanpos-1);
   EndIf;        //Emg
   EndIf;        //Emg

   wkPseudoCode = wkSrcDta ;

   wkScanPos   =  %Scan('EXEC SQL' : wkPseudocode) + 8;                                  //0094
   wkIdx  =  %Check(' ': wkPseudoCode :  wkScanPos);                                     //0094
                                                                                         //0094
   If WkIdx >  *Zeros;                                                                   //0094
      wkScanpos  =  %Scan(' ' : wkPseudoCode :  WkIdx);                                  //0094
                                                                                         //0094
      If wkScanpos    >  WkIdx;                                                          //0094
         WkSqlOpcode  =  %Trim(%Subst(wkPseudoCode  : WkIdx : WkScanPos - WkIdx));       //0094
      Endif;                                                                             //0094
   Endif;                                                                                //0094

   wkPseudoCode = %ScanRpl('EXEC SQL' :
                           'Execute SQL Statement: ' : wkPseudoCode);                    //0094

   Exec Sql
      Declare IaPseudoMPSql1 Scroll Cursor for
         Select   iAKeyFld1
                  ,iASrcMap
         From IaPseudoMP
         Where  iASrcMTyp = :wkSrcMtyp
            and iASrcSpec = :wkSrcSpec
            and iASrcLTyp = ''
         For Fetch Only;
   Exec Sql
      Open IaPseudoMPSql1;

   Exec Sql
      Fetch First From IaPseudoMPSql1 Into :wkKeyField, :wkKeyMapping;

   Dow SqlCode = Successcode;

      wkKeyMapping =  ' ' + %Trim(wkKeyMapping) + ' ' ;
      wkKeyfield = ' ' + %Trim(wkKeyfield) + ' ' ;
                                                                                         //0094
      wkIsExists = 'N';                                                                  //0094
      Exec sql                                                                           //0094
        Select 'Y' into :wkIsExists                                                      //0094
          from IapseudoKp  where                                                         //0094
          IAKWDOPC  = Trim(:wkKeyfield) and                                              //0094
          IASRCMTYP = 'SQLRPGLE'  and                                                    //0094
          IASRCSPEC = 'S' limit 1;                                                       //0094
                                                                                         //0094
      If wkIsExists = 'Y'  And WkSqlOpcode  =  %Trim(wkKeyField);                        //0094
         wkKeyfieldPos = %Scan(%trim(wkKeyfield) : wkPseudoCode);                        //0094
                                                                                         //0094
         If wkKeyfieldPos > 1;                                                           //0094
            wkPseudoCode = %Subst(wkPseudoCode : wkKeyfieldPos - 1);                     //0094
            wkPseudoCode = %ScanRpl(wkKeyfield : wkKeyMapping : wkPseudoCode);           //0094
         Endif;                                                                          //0094
      Endif;                                                                             //0094

      RcdFound = True;
      Exec Sql
         Fetch Next From IaPseudoMPSql1 Into :wkKeyField, :wkKeyMapping;
   Enddo;

   Exec Sql
      Close IaPseudoMPSql1;

   If RcdFound ;

      //Check if current line's rrn is same as the rrn of the main logic's start        //0028
      //line, If so write the main logic begin text.                                    //0028
      If  wkFX4ParmDs.dsSrcRrn>= wkBgnRrnForMainLogic and wkBgnRrnForMainLogic <>0;      //0038
         For wkIdx = 1 to 5;                                                             //0029
          OutParmWriteSrcDocDS.dsPseudocode = wkBgnMainLogicCmnt(wkIdx);                 //0029
          IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                                  //0028
          WritePseudoCode(IOParmPointer);                                                //0028
         EndFor;                                                                         //0029
         wkBgnRrnForMainLogic =0 ;                                                       //0038
      EndIf;                                                                             //0028

      //Add Indentation for the code
      If wkIndentLevel <> *Zeros;                                                        //0038
         wkRPGIndentParmDS.dsIndentType = *Blanks ;                                      //0038
         wkRPGIndentParmDS.dsPseudocode = wkPseudoCode;                                  //0038
         wkIOIndentParmPointer = %Addr(wkRPGIndentParmDS);                               //0038
         IndentRPGPseudoCode(wkIOIndentParmPointer);                                     //0038
         wkPseudoCode = wkRPGIndentParmDS.dsPseudocode;                                  //0038
      EndIf;                                                                             //0038

      Clear OutParmWriteSrcDocDS  ;
      OutParmWriteSrcDocDS  = wkFX4ParmDS;
      OutParmWriteSrcDocDS.dsPseudocode = wkPseudoCode;
      IOParmPointer  = %Addr(OutParmWriteSrcDocDS);
      WritePseudoCode(IOParmPointer);
      //If so, write the main logic ending text.                                        //0024
       If  wkFX4ParmDs.dsSrcRrn >= wkLstRrnForMainLogic and wkLstRrnForMainLogic <>0;    //0038
          OutParmWriteSrcDocDS.dsPseudocode = *Blanks;                                   //0024
          IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                                  //0024
          WritePseudoCode(IOParmPointer);                                                //0024
          OutParmWriteSrcDocDS.dsPseudocode = wkEndMainLogicCmnt;                        //0024
          IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                                  //0024
          WritePseudoCode(IOParmPointer);                                                //0024
          wkLstRrnForMainLogic = 0;                                                      //0038
      EndIf;                                                                             //0024
   EndIf;

   //Pass the current indentation level and declaration type to keep a track in the next call
   Eval-Corr RPGIndentParmDs  =  wkRPGIndentParmDs;                                      //0038
   wkFX4ParmDs.dsIOIndentParmPointer = IOIndentParmPointer;                              //0038
   wkFX4ParmDs.dsDclType      =  wkDclType;

   Return RcdFound;

/copy 'QCPYSRC/iaprcerlog.rpgleinc'
End-Proc;

//------------------------------------------------------------------------------------- //
//Procedure to Parse Full Free format RPGLE code to Write Pseudocode                    //
//------------------------------------------------------------------------------------- //
Dcl-Proc iAFreeFormatPseudocodeParser Export;

   Dcl-Pi *n Ind;
        inwParmPointer Pointer;
   End-Pi;


//------------------------------------------------------------------------------------- //
//Data Structure Definitions
//------------------------------------------------------------------------------------- //
   Dcl-Ds wkFFCParmDS Qualified based(inwParmPointer);
      dwReqId        Char(18);
      dwSrcLib       Char(10);
      dwSrcPf        Char(10);
      dwSrcMbr       Char(10);
      dwsrcType      Char(10);
      dwSrcRrn       Packed(6:0);
      dwSrcSeq       Packed(6:2);
      dwSrcLtyp      Char(5);
      dwSrcSpec      Char(1);
      dwSrcLnct      Char(1);
      dwSrcDta       varChar(cwSrcLength);
      dwIOIndentParmPointer Pointer;                                                     //0038
      dwDclType      Char(10);
      dwSubType      Char(10);
      dwhCmtReqd     Char(1);
      dwSkipNxtStm   ind;                                                                //0009
      dwFileNames    char(10) dim(99);                                                   //0009
      dwFileCount    zoned(2:0);                                                         //0009
   End-Ds;

   Dcl-Ds OutParmWriteSrcDocWDS Qualified;                                               //0055
      dwReqId      Char(18);                                                             //0055
      dwSrcLib     Char(10);                                                             //0055
      dwSrcPf      Char(10);                                                             //0055
      dwSrcMbr     Char(10);                                                             //0055
      dwsrcType    Char(10);                                                             //0055
      dwSrcRrn     Packed(6:0);                                                          //0055
      dwSrcSeq     Packed(6:2);                                                          //0055
      dwSrcLtyp    Char(5);                                                              //0055
      dwSrcSpec    Char(1);                                                              //0055
      dwSrcLnct    Char(1);                                                              //0055
      dwPseudocode Char(cwSrcLength);                                                    //0055
   End-Ds;                                                                               //0055

   //Datastructure to hold nested Bif                                                     //0032
   Dcl-Ds DsNestedBif    Occurs(100) ;                                                     //0032
     wDsBifNumber      Packed(5:0);                                                        //0032
     wDsPercentPos     Packed(5:0);                                                        //0032
     wDsBifName        Char(10);                                                           //0032
     wDsOpenParPos     Packed(5:0);                                                        //0032
     wDsCloseParPos    Packed(5:0);                                                        //0032
     wDsBifFull        VarChar(200);                                                       //0032
     wDsBifMap         VarChar(200);                                                       //0032
     wDsBifPseudocode  VarChar(cwSrcLength);                                               //0032
   End-Ds;                                                                                 //0032
   //DS to hold indentation data                                                        //0038
   Dcl-Ds wkRPGIndentParmDS LikeDs(RPGIndentParmDSTmp);                                  //0038

   //Declaration of work variables
   Dcl-S  rcdFound             ind inz('0');
   Dcl-S  wkRowNum             uns(5);
   Dcl-S  wkPseudoCode         Char(cwSrcLength) Inz;
   Dcl-S  wkPseudoCodeE        Char(cwSrcLength) Inz;                                    //0067
   Dcl-S  wkPseudoCode1        Char(cwSrcLength) Inz;                                    //0038
   Dcl-S  wkBIFCommentDes      Char(cwSrcLength) Inz;                                    //0036
   Dcl-S  wkVar1               Char(200) Inz;
   Dcl-S  wkSrcLnct            Char(1);
   Dcl-S  ArrSearchFld         Char(10) Dim(99);
   Dcl-S  wkKeyList            Char(10);
   Dcl-S  wkKeywordtoLookup    Char(10);
   Dcl-S  wk2ndLevelMapping    Char(200);
   Dcl-S  wkPrvDclType         Char(10) Inz;
   Dcl-S  wkPrvSubType         Char(10) Inz;
   Dcl-S  wkStrPos             Packed(5:0) Inz;                                          //0001
   Dcl-S  wkEndPos             Packed(5:0) Inz;                                          //0001
   Dcl-S  wkCheckPos           Packed(5:0) Inz;                                          //0001
   Dcl-S  wkCheckChar          Char(1) Inz;
   Dcl-S  wkSrhIndex           Packed(3:0) ;
   Dcl-S  wkMaxSrhCount        Packed(3:0);
   Dcl-S  wkScanPos            Packed(5:0) Inz;                                          //0001
   Dcl-S  wkSrcDta             varChar(cwSrcLength) Inz;
   Dcl-S  wkSrcDta1            varChar(cwSrcLength) Inz;                                 //0067
   Dcl-S  wkSrcDtaBIF          varChar(cwSrcLength) Inz;
   Dcl-S  wkSrcMap             varChar(cwSrcLength);
   Dcl-S  wkSrcdtaUpper        varChar(cwSrcLength);
   Dcl-S  IOParmPointer        Pointer inz(*Null);
   Dcl-S  wkIOIndentParmPointer Pointer;                                                 //0038
   Dcl-S  wkSubPos             Packed(5:0) Inz;                                          //0001
   Dcl-S  wkPos1               Packed(5:0) Inz;                                          //0001
   Dcl-S  wkPos2               Packed(5:0) Inz;                                          //0001
   Dcl-S  wkIdx                Packed(4:0) Inz;                                          //0029
   Dcl-S  wkBIF                Char(100)   Inz;
   Dcl-S  wkArg1               Char(100)   Inz;
   Dcl-S  wkArg2               Char(100)   Inz;
   Dcl-S  wkArg3               Char(100)   Inz;
   Dcl-S  wkKeyField           Char(100)   Inz;
   Dcl-S  wkFileName           Char(100)    Inz;
   Dcl-S  wkSavPos             Packed(5:0) Inz;                                          //0001
   Dcl-S  wkObjNam             Char(10)    Inz;
   Dcl-S  wkObjDesc            Char(50)    Inz;
   Dcl-S  wkCount              Packed(3:0) Inz;
   Dcl-S  wkFullText           VarChar(cwSrcLength) Inz;
   Dcl-S  wkSavEndPos          Packed(3:0) Inz;
   Dcl-S  wkRemSrc             VarChar(cwSrcLength) Inz;
   Dcl-S  wkRemSrcDta          VarChar(cwSrcLength) Inz;
   Dcl-S  wkSubstrLen          Packed(5:0) Inz;                                          //0022
   Dcl-S  wkSavDclEndPos       Packed(5:0) Inz;                                          //0022
   Dcl-S  wkBegPos             Packed(5:0) Inz;                                          //0009
   Dcl-S  wkLstPos             Packed(5:0) Inz;                                          //0009
   Dcl-S  wkFileNam            Char(8)     Inz;                                          //0009
   Dcl-S  wkCLoopSrcDtaF       Char(132)   Inz;                                          //0009
   Dcl-S  wkSavIndentType      Char(10)    Inz;                                          //0012
   Dcl-S  wkMonGrpOnErr        Char(132)   Inz;                                          //0090
   Dcl-S  wkEqPos              Packed(5:0) Inz;                                          //0015
   Dcl-s  wkNonBlnkPos         Packed(5:0) Inz;                                          //0015
   Dcl-S  wkVar2               VarChar(cwSrcLength) Inz;                                 //0015
   Dcl-S  wkVar3               VarChar(cwSrcLength) Inz;                                 //0015
   Dcl-S  wkEndPos1            Packed(5:0) Inz;                                          //0022
   Dcl-S  wkPos                Packed(5:0)           Inz;                                //0026
   Dcl-S  WkOpnBr              Packed(5:0)           Inz;                                //0026
   Dcl-S  WkClsBr              Packed(5:0)           Inz;                                //0026
   Dcl-S  WkPos3               Packed(5:0)           Inz;                                //0026
   Dcl-S  wkProcName           VarChar(cwSrcLength)  Inz;                                //0026
   Dcl-S  wkParm               VarChar(cwSrcLength)  Inz;                                //0026
   Dcl-S  wkString             VarChar(cwSrcLength)  Inz;                                //0026
   Dcl-S  WKNoParm             Ind  ;                                                    //0026
   Dcl-S  wkWithPos            Packed(5:0)           Inz ;                               //0026
   Dcl-S  IOBIFParmPointer     Pointer inz(*Null);                                       //0032
   Dcl-s  OutMaxBif            Packed(3:0) Inz;                                          //0032
   Dcl-S  wkForIndex           Packed(3:0) Inz;                                          //0032
   Dcl-S  ProcCallFound        Char(1) Inz ;                                             //0041
   Dcl-S  ProcName             VarChar(100) Inz;                                         //0041
   Dcl-S  WriteExprsDtls       Char(1)               Inz('N') ;                          //0100
   Dcl-S  wkExpCommentDes      Char(cwSrcLength)     Inz ;                               //0100

   //Flags
   Dcl-S  fwAddIndent       Ind  Inz;
   Dcl-S  fwRemoveIndent    Ind  Inz;
   Dcl-S  fwProcessDcltype  Ind  Inz;
   Dcl-S  wk2ndLevelMappingFound  Ind  Inz;
   Dcl-S  wkMappingFoundInd     Ind           Inz;                                       //0042


   //Declaration of Constant
   Dcl-C  cwPrPseudoMapping  Const('Declare Procedure : ');
   Dcl-C  cwScanAndReplace   Const('SCNRPL');
   Dcl-C  cwAddSpaceCheck    Const('ADDSPACECK');
   Dcl-C  cwCSpecDcltype     Const('DCL-C');
   Dcl-C  cwDclf             Const('DCL-F');
   Dcl-C  cwFSpec            Const('F');
   Dcl-C  cwDSpec            Const('D');
   Dcl-C  cwCSpec            Const('C');
   Dcl-C  cwPrtCmntAftr      Const('CMNTAFTER');                                         //0024
   Dcl-C  cwOnEr             Const('ON-ERROR');                                          //0090
   Dcl-C  cwEndM             Const('ENDMON');                                            //0090

   //Copybook declaration
/copy 'QCPYSRC/iaprderlog.rpgleinc'

   //Initialise the variables
   wkuDpsds.nbrparms = %parms;                                                           //0030
   EvaluatePSDS() ;                                                                      //0030

   Clear wkPseudoCode;
   wkDclType                    = *Blanks;
   wkPrvSubType                 = *Blanks;
   fwAddIndent                  = False;
   fwRemoveIndent               = False;
   fwProcessDcltype             = False;
   rcdFound                     = False;
   wkSrcLtyp                    = wkFFCParmDS.dwSrcLtyp;
   wkSrcSpec                    = wkFFCParmDS.dwSrcSpec;
   wkSrcLnct                    = wkFFCParmDS.dwSrcLnct;
   wkSrcDta                     = wkFFCParmDS.dwSrcDta;
   wkPrvDclType                 = wkFFCParmDS.dwDclType;
   wkPrvSubType                 = wkFFCParmDS.dwSubType;
   IOIndentParmPointer = wkFFCParmDs.dwIOIndentParmPointer;                              //0038
   Eval-Corr wkRPGIndentParmDs  = RPGIndentParmDs;                                       //0038

   //Clear the output data structure                                                    //0046
   Clear DsMappingOutData;                                                               //0046
   //Convert variable names and keywords to capital letters while keeping the string     //0050
   //values intact                                                                       //0050
   ConvertVarAndKeywordNamesToCaps(wkSrcDta);                                            //0050
   wkFFCParmDS.dwSrcDta = wkSrcDta;                                                      //0050

   //Scan and check the type of declaration
   wkStrPos   =  %Check(' ' : wkSrcDta : 1);
   wkEndPos   =  %Scan(' ' : wkSrcDta : wkStrPos);
   //Check the positions
   If wkStrPos > *Zeros And (wkEndPos = *Zeros OR                                        //0051
      %check(' ' : wkSrcDta : wkEndPos) = 0);                                            //0051
    //wkEndPos = %Scan(';' : wkSrcDta : wkStrPos);                                       //0033
      wkEndPos = %ScanR(';' : wkSrcDta : wkStrPos);                                      //0033
   EndIf;
   //If start and End positions are not Zero, substring the keyword
   If wkStrPos > *Zeros And wkEndPos > *Zeros;
      wkDclType  =  %Subst(wkSrcDta : wkStrPos : (wkEndPos-wkStrPos));
      wkDclType  =  %xLate(cwLO:cwUP:wkDclType);
   EndIf;

   Select;                                                                               //0004
   when wkDclType = 'DCL-PROC';                                                          //0004
      wkBeginProc = 'Y';                                                                 //0004
      //Initalized to handle Header display issue in D spec                             //0059
      Clear wkPrevDclType;                                                               //0059
   when wkDclType = 'END-PROC';                                                          //0004
      wkBeginProc = 'N';                                                                 //0004
   Endsl;                                                                                //0004

   //Handling for READ with loop
   If   wkDclType<>*Blanks;                                                              //0009
        Exsr FreeReadBlock;                                                              //0009
   EndIf;                                                                                //0009

   //Check Monitor Group On-Error
   If wkDclType = cwOnEr;                                                                //0090
      Exsr CheckMonitorGroupOnErr ;                                                      //0090
   EndIf;                                                                                //0090
                                                                                         //0090
   //Check if a variable is getting CLEARED, if so check if the variable is a           //0042
   //record format OR not. (Pass source data, source line type and wkiAKeyFld2          //0042
   //which will be returned as blank/non-blank as per checking)                         //0042
   CheckClearedRecordFormat(wkDclType : wkiAKeyFld2 : wkSrcDta );                        //0062

   //Get the mapping data from IaPseudoMP file for the declaration type (wkDclType)
                                                                                         //0020
   If %Scan('EVAL' : %Xlate(cwLo:cwUp:wkDclType)) > *Zeros;                              //0020
      Exsr  CheckforArithExpr ;                                                          //0100
   Endif;                                                                                //0020
                                                                                         //0020
   wkMappingFoundInd = GetMappingData();                                                 //0042
   wkSrcMap = wkSrcMapOut;                                                               //0042

   //Check whether the Keyword is an Opcode or a Procedure Call                         //0085
   Exsr IsOpcodeOrProcCall;                                                              //0085
                                                                                         //0085
   //If record found for the Dcltype then process it
   If wkMappingFoundInd = *On;                                                           //0028
     fwProcessDclType = True;
     wkSavIndentType = wkIndentType;                                                     //0012
   //If record not found for the Dcltype check if the previous dcltype has any subfields in i
   Else;                                                                                 //0028
      //Check if previous dcltype has the sub type defined ..eg DS, PR, PI
      If (wkSrcSpec = cwDSpec And wkPrvSubType <> *Blanks)  Or
         (wkSrcSpec = cwFspec And wkPrvDclType = cwDclf);
         wkDclType = wkPrvSubType ;
      EndIf;                                                                             //0015
                                                                                         //0041
      If wkSrcSpec = 'C' ;                                                               //0041
         ProcCallFound = 'N' ;                                                           //0041
         ExSr CheckforProcCall ;                                                         //0041
      Endif ;                                                                            //0041
                                                                                         //0041
      If ProcCallFound = 'Y' ;                                                           //0041
      Else ;                                                                             //0041
         If wkSrcSpec = 'C' and %Scan('=' : wkSrcdta) > *Zeros  ;                        //0041
            wkDclType = 'EVAL'       ;                                                   //0041
            Exsr CheckforArithExpr ;                                                     //0100
            wkSrcDta   = 'EVAL ' + %Trim(wkSrcDta);                                      //0041
         EndIf;                                                                          //0041
      Endif ;                                                                            //0041

         //Get the mapping data from IaPseudoMP file for the subfield
         wkMappingFoundInd = GetMappingData();                                           //0042
         wkSrcMap = wkSrcMapOut;                                                         //0042
         wkEndPos = 1;
         //If record found for the Dcltype then process it
         If wkMappingFoundInd = *On;                                                     //0028
           fwProcessDclType = True;
         EndIf;


      //Equation statements
      //Check if mapping of equation required                                           //0015
      If wkActionType = cwScanAndReplace AND wkSrcSpec = 'C' ;                           //0041
         wkSrcDta   = %ScanRpl('='  : ' Equals '       : wkSrcDta);
         wkSrcDta   = %ScanRpl('<>' : ' Not Equal '    : wkSrcDta);
         wkSrcDta   = %ScanRpl('<'  : ' Less Than '    : wkSrcDta);                      //0064
         wkSrcDta   = %ScanRpl('>'  : ' Greater Than ' : wkSrcDta);
         wkPseudoCode  = wkSrcDta;
         rcdFound = True;

         //Check if any Built in function exist in this line and process it
         wkPos1  =   %Scan('%' : wkSrcDta  : 1);
         If wkPos1 > *Zeros;
            wkSrcDtaBIF = wkSrcDta ;
            IOBifParmPointer = %Addr(dsNestedBIF);                                       //0032
            // Process Nested/Simple Built in Function                                   //0032
            If ProcessNestedBIF(wkSrcDtaBIF : IOBifParmPointer : OutMaxBif);             //0032
            wkPseudoCode  = wkSrcDtaBIF;
            Else;                                                                        //0032
              // If processing unsuccessfull, write the original source statement        //0032
              wkPseudoCode  = %Trim(wkFFCParmDS.dwSrcDta);                               //0032
            EndIf;                                                                       //0032
         EndIf;

         //Remove the semicolon from the Pseudocode
         wkPos1  =   %Scan(';' : wkPseudoCode  : 1);
         If wkPos1 > *Zeros;
            wkPseudoCode = %Subst(wkPseudoCode : 1 : (wkPos1-1));
         EndIf;

      EndIf;
   EndIf;                                                                                //0016

   //For Free Format Parsing  : In case of                                              //0037
   //BEGSR, EXSR, DCL-PROC, END-PROC, change procedure/                                 //0037
   //Subroutine name to UpperCase                                                       //0037
   If fwProcessDcltype;
      rcdFound = True;
      //Check if the Variable exits in mapping
      If %Scan('&Var1' : wkSrcMap : 1) > *Zeros OR                                       //0042
         %Scan('&OFFILE' : wkSrcMap : 1) > *zeros OR %Scan('&PFNAME':wkSrcMap:1)> 0;     //0062
         //Get the variable for mapping
         wkStrPos   =  %Check(' ' : wkSrcDta : wkEndPos);

         //Get correct Data Area name when *Lock used                                   //0087
         If %Scan('*LOCK' : wkSrcDta: wkStrPos) > 0;                                     //0087
            wkStrPos = %Scan(' ':wkSrcDta:wkStrPos);                                     //0087
         EndIf;                                                                          //0087
         If wkSrcSpec = 'C' And wkSrcLnct = 'B';
            //If it is a begining of the bigger statement then get full length
               wkEndPos   =  %Checkr(' ' : wkSrcDta );
         Else;
            //If end position is specified for the keyword then look for it
            If wkSubsChr <> *Blanks;
               wkEndPos   =  %Scan(wkSubsChr : wkSrcDta : wkStrPos);
            Else;
               wkEndPos   =  %Scan(' ' : wkSrcDta : wkStrPos);
            EndIf;
         EndIf;

         //If end position not found then
         If wkStrPos > *Zeros And wkEndPos = *Zeros;
            wkEndPos = %Scan(';' : wkSrcDta : wkStrPos);
            If wkEndPos = *Zeros;
              wkEndPos = %Len(wkSrcDta);
              wkEndPos = wkEndPos+1 ;
            EndIf;
         EndIf;
         //If start and End positions are not Zero, substring the keyword
         If wkStrPos > *Zeros And wkEndPos > *Zeros;
            wkVar1  =  %Subst(wkSrcDta : wkStrPos : (wkEndPos-wkStrPos));
            //Remove ';' if found at end of wkVar1                                      //0082
            If %scan(';' : wkVar1) = %len(%trim(wkVar1));                                //0082
               %subst(wkVar1 : %len(%trim(wkVar1)) : 1) = *Blanks;                       //0082
            EndIf;                                                                       //0082
            //if date/time/timestamp and format specified                               //0082
            If (WkDclType  = 'TEST'     Or  WkDclType  =  'TEST(E)'   Or
               WkDclType  = 'TEST(DE)'  Or  WkDclType  =  'TEST(ED)'  Or
               WkDclType  = 'TEST(TE)'  Or  WkDclType  =  'TEST(ET)'  Or
               WkDclType  = 'TEST(ZE)'  Or  WkDclType  =  'TEST(EZ)') And
               %Scan('*' : Wkvar1)  >  *Zeros;

               Monitor;
                  wkStrPos  =  %Scan('*' : WkVar1 :  1);
                  wkEndPos  =  %Scan(' ': WkVar1 :  wkStrPos + 1);
                  If WkStrPos =  1;
                     WkVar1   =  '(' + %Subst(WkVar1 : 1 :  WkEndPos - 1) + ') ' +
                                 %Subst(WkVar1 : WkEndPos );
                  Else;
                     WkVar1   =  %Subst(Wkvar1 : 1 : WkStrPos - 1) + '( ' +
                                 %Subst(WkVar1 : WkStrPos :
                                 WkEndPos - WkStrPos - 1) + ') ' +
                                 %Subst(WkVar1 : WkEndPos );
                  Endif;
               On-Error;
               Endmon;
            Endif;
         EndIf;

         //Check if mapping of equation required
         If wkActionType = cwScanAndReplace;
            wkVar1 = %ScanRpl('='  : ' Equals '       : wkVar1);
            wkVar1 = %ScanRpl('<>' : ' Not Equal '    : wkVar1);
            wkVar1 = %ScanRpl('<'  : ' Less Than '    : wkVar1);                         //0064
            wkVar1 = %ScanRpl('>'  : ' Greater Than ' : wkVar1);
         EndIf;

         //Map the variable to the Pseudcode
            //If F - Spec, get the object description
            If wkSrcSpec = cwFSpec  And wkDclType = cwDclf;
              wkObjNam   = %Trim(wkVar1);
              wkObjDesc  =  *Blanks;
              If GetObjectDesc (wkObjNam : wkObjDesc);
                wkVar1   = *Blanks;
                wkVar1   =  %Trim(wkObjNam) + '(' + %Trim(wkObjDesc) + ')';
              EndIf;
            EndIf;
            wkPseudoCode = %ScanRpl('&Var1':%Trim(wkVar1):wkSrcMap);                     //0042
            rcdFound = True;
      Else;
         //If no variable to map then use the text for the keyword mapping
         If wkSrcMap  <> *Blanks;
            wkPseudoCode = wkSrcMap;
            rcdFound = True;
         EndIf;
      EndIf;

      If %Scan('&EVar1' : wkSrcMap : 1) > *Zeros;                                        //0020
         wkStrPos =  %Scan(' ' : %Trim(wkSrcDta) : 1);                                   //0015
         wkEndPos   =  %Scan('=' : wkSrcDta : wkStrPos);                                 //0015
                                                                                         //0015
         If wkEndPos - wkStrPos > 1 and wkStrPos > *Zeros;                               //0022
            wkVar2  =  %Subst(wkSrcDta : wkStrPos+1 : (wkEndPos-wkStrPos-1));            //0015
            wkStrPos = wkEndPos;                                                         //0015
            wkEndPos   =  %ScanR(';' : wkSrcDta : wkStrPos);                             //0033
                                                                                         //0015
            If wkEndPos - wkStrPos > 1 and wkStrPos > *Zeros;                            //0022
               wkVar3  =  %Subst(wkSrcDta : wkStrPos+1 : (wkEndPos-wkStrPos-1));         //0015
               wkPseudoCode = %ScanRpl('&EVar1':%Trim(wkVar2):wkPseudoCode);             //0020
               wkPseudoCode = %ScanRpl('&EVar2':%Trim(wkVar3):wkPseudoCode);             //0020
            EndIf;                                                                       //0015
                                                                                         //0015
         EndIf;                                                                          //0015
                                                                                         //0015
      EndIf;                                                                             //0015
                                                                                         //0100
      //Scan and replace output field in arithmetic expression                           //0100
      If %Scan('&AExp1' : wkSrcMap : 1) > *Zeros ;                                       //0100
         wkStrPos =  %Scan(' ' : %Trim(wkSrcDta) : 1) ;                                  //0100
         wkEndPos =  %Scan('=' : wkSrcDta : wkStrPos) ;                                  //0100
                                                                                         //0100
         If wkEndPos - wkStrPos > 1 and wkStrPos > *Zeros ;                              //0100
            wkVar2  =  %Subst(wkSrcDta : wkStrPos+1 : (wkEndPos-wkStrPos-1)) ;           //0100
            wkPseudoCode = %ScanRpl('&AExp1':%Trim(wkVar2):wkPseudoCode) ;               //0100
         Endif ;                                                                         //0100
      Endif ;                                                                            //0100

         //Save the dcl type end position
         wkSavDclEndPos  = wkEndPos;

      //Check if the File Variable exits in mapping
      If %Scan('&File1' : wkSrcMap : 1) > *Zeros;
         wkStrPos   =  wkEndPos;
         wkSavPos   =  wkEndPos;
         wkEndPos   =  %Scan(';' : wkSrcDta :wkStrPos );
         wkStrPos   =  %CheckR(cwAto9 : wkSrcDta : wkEndPos-1);
         If wkEndPos - wkStrPos > *Zeros and wkStrPos > *Zeros;                          //0022
           wkFileName =  %Subst(wkSrcDta : wkStrPos : (wkEndPos - wkStrPos));
         EndIf;
         wkObjNam   =  %Trim(wkFileName);
         wkObjDesc  =  *Blanks;
         //Get the file object description
         If GetObjectDesc (wkObjNam : wkObjDesc);
           wkFileName  = *Blanks;
           wkFileName  =  %Trim(wkObjNam) + '(' + %Trim(wkObjDesc) + ')';
         EndIf;

         If wkFileName <> *Blanks;
         wkSrcMap      =  %Scanrpl('&File1' : %Trim(wkFileName) : wkSrcMap) ;
         Else;
         wkSrcMap      =  %Scanrpl('&File1' : ' ' : wkSrcMap) ;
         EndIf;
         wkPseudoCode  = wkSrcMap;

      EndIf;

      //Check if the key fields Variable exits in mapping
      If %Scan('&KeyField1' : wkSrcMap : 1) > *Zeros;
         If wkSavPos > *Zeros And (wkStrPos - wkSavPos) > *Zeros;
           wkKeyField = %Subst(wkSrcDta : wkSavPos : (wkStrPos - wkSavPos));
         EndIf;

         //Remove %kds built-in function's wordings from keyfield name
         If %scan('%KDS(' : %Xlate(cwLo : cwUp : wkKeyField) :1)  <>  0;                 //0070
            wkKeyField = %subst(%Trim(wkKeyField):6:%len(%Trim(wkKeyField))-6);          //0009
         EndIf;                                                                          //0009

         If wkKeyField <> *Blanks;
           wkSrcMap =  %Scanrpl('&KeyField1' : %Trim(wkKeyField) : wkSrcMap);
         Else;
           wkSrcMap =  %Scanrpl('&KeyField1' : ' '  : wkSrcMap);
         EndIf;
         wkPseudoCode = wkSrcMap;

      EndIf;

      //Replace &OFFILE by name of the file corresponding to record format cleared       //0042
      If %Scan('&OFFILE' : wkSrcMap : 1) > *zeros and wkVar1 <>*Blanks;                  //0042
         wkIdx = %lookup(%Trim(%xlate(cwLo : cwUp : wkVar1)) :                           //0042
                 DsDeclaredFileRecordFormats.RecordFormatName :  1 :                     //0042
                 DsDeclaredFileRecordFormats.Count);                                     //0042
         If wkIdx <> 0;                                                                  //0042
            wkPseudoCode = %ScanRpl('&OFFILE':                                           //0082
                           %Trim(DsDeclaredFileRecordFormats.FileName(wkIdx)):           //0082
                           wkPSeudoCode);                                                //0082
         Else;                                                                           //0062
            //Check if the file name has been used with the op-code                      //0062
            wkIdx = %lookup(%Trim(%xlate(cwLo : cwUp : wkVar1)) :                        //0062
                 DsDeclaredFileRecordFormats.FileName :  1 :                             //0062
                 DsDeclaredFileRecordFormats.Count);                                     //0062
            If wkIdx <>0;                                                                //0062
               wkPseudoCode=%ScanRpl('&OFFILE': %Trim(%xlate(cwLo : cwUp : wkVar1)) :    //0062
                                 wkPSeudoCode);                                          //0062
            EndIf;                                                                       //0062
         EndIf;                                                                          //0042
      EndIf;                                                                             //0042

      //Replace &PFNAME by name of the file on which logical is based                    //0062
      If %Scan('&PFNAME' : wkSrcMap : 1) > *zeros and wkVar1 <>*Blanks;                  //0062
         wkIdx = %lookup(%Trim(%xlate(cwLo : cwUp : wkVar1)) :                           //0062
                 DsDeclaredFileRecordFormats.RecordFormatName :  1 :                     //0062
                 DsDeclaredFileRecordFormats.Count);                                     //0062
         If wkIdx <> 0;                                                                  //0062
            wkPseudoCode=%ScanRpl('&PFNAME':                                             //0062
                          %trim(DsDeclaredFileRecordFormats.PFName(wkIdx)) :             //0062
                                 wkPSeudoCode);                                          //0062
         Else;                                                                           //0062
            //Check if the file name has been used with the op-code                      //0062
            wkIdx = %lookup(%Trim(%xlate(cwLo : cwUp : wkVar1)) :                        //0062
                 DsDeclaredFileRecordFormats.FileName :  1 :                             //0062
                 DsDeclaredFileRecordFormats.Count);                                     //0062
            If wkIdx <>0;                                                                //0062
               wkPseudoCode=%ScanRpl('&PFNAME':                                          //0062
                           %trim(DsDeclaredFileRecordFormats.PFName(wkIdx)) :            //0062
                                 wkPSeudoCode);                                          //0062
            EndIf;                                                                       //0062
         EndIf;                                                                          //0062
      EndIf;                                                                             //0062
                                                                                         //0062
      //Comment the existing Callp logic                                                //0026
      //Check if the &GetFullVar1 variable exits in mapping to get full source text     //0026
      // If %Scan('&GetFullVar1': wkSrcMap : 1) > *Zeros;                                //0026
      // wkStrPos   = wkEndPos + 1;                                                      //0026
      // wkEndPos   = %Checkr( ' ' : wkSrcDta );                                         //0026
      // If wkEndPos - wkStrPos > 1 and wkStrPos > *Zeros;                               //0026
      //    wkFullText = %Subst(wkSrcDta : wkStrPos : (wkEndPos - wkStrPos));            //0026
      // EndIf;                                                                          //0026
      // wkSrcMap   =  %Scanrpl('&GetFullVar1' : %Trim(wkFullText) : wkSrcMap);          //0026
      // wkPseudoCode = wkSrcMap;                                                        //0026
      // EndIf;                                                                          //0026
                                                                                         //0026
      //In IapseudoMP for FFC &  C spec, &Proc1 represents Procedure Name               //0026
      //&Parm1 represents Parameter Name in free format                                 //0026
      //                                                                                 //0026
      If %Scan('&Proc1' : wksrcMap : 1) > *zeros;                                        //0026
                                                                                         //0026
         wkStrPos = %Scan(' ' : wkSrcDta  : 1);                                          //0026
         WkOpnBr  = %Scan( '(' : wkSrcDta :wkStrPos) ;                                   //0026
         If WkOpnBr > 0;                                                                 //0026
            WkClsBr    = %ScanR(')' : wkSrcDta  : WkOpnBr) ;                             //0026
         EndIf ;                                                                         //0026
                                                                                         //0026
         If WkOpnBr-wkStrPos > 1 ;                                                       //0026
            //Extract Procedure Name                                                    //0026
            wkProcName = %Subst(wkSrcDta  : wkStrPos+1 : WkOpnBr-wkStrPos-1);            //0026
            If WkClsBr - WkOpnBr > 1;                                                    //0026
               //Extract Parameter Name                                                 //0026
               wkParm     = %Subst(wkSrcDta :WkOpnBr+1: WkClsBr-WkOpnBr-1);              //0026
               wkParm     = %ScanRpl(':' : ',': wkParm );                                //0026
            Endif;                                                                       //0026
         Else ;                                                                          //0026
            wkProcName = %Subst(wkSrcDta  : wkStrPos+1 );                                //0026
            wkProcName = %ScanRpl(';' : ' ': wkProcName);                                //0026
         Endif;                                                                          //0026
         wkString   = %ScanRpl('&Proc1':%Trim(wkProcName) : wksrcmap);                   //0026
         wkString   = %ScanRpl('&Parm1':%Trim(wkParm) : wkString);                       //0026
         WkPos      = %Scan('|~': wkString:1);                                           //0026
         //In IaPseudoMP file, scan |~ to separate the mapping in 2 lines as below      //0026
         //Call Procedure/Program MS80A2 with                                           //0026
         //Parameters : IN_SUP                                                          //0026
         If WkPos > 1 ;                                                                  //0026
            WKNoParm = *Off ;                                                            //0026
            wkPseudoCode = %Subst(wkString : 1 : WkPos-1) ;                              //0026
            clear wkPseudoNext;                                                          //0026
            wkPseudoNext = %Subst(wkString : WkPos+2);                                   //0026
            //Incase if parameters = *Blanks , then "with" should not be printed        //0026
            //It should be printed as below :                                           //0026
            //Call Procedure/Program MS80A2                                             //0026
            If WkParm = *Blanks  ;    // No Parameters case                              //0026
               wkNoParm = *On;                                                           //0026
               wkWithPos    = %ScanR('with' : %Trim(wkPseudoCode) ) ;                    //0026
                                                                                         //0026
               If wkWithPos = %Len(%Trim(wkPseudoCode)) - 3;                             //0026
                  wkPseudoCode = %Subst(wkPseudoCode : 1: wkWithPos-1) ;                 //0026
                  wkPseudoNext = *Blanks ;                                               //0026
               EndIf;                                                                    //0026
            EndIf;                                                                       //0026
         Endif;                                                                          //0026
      EndIf;                                                                             //0026
                                                                                         //0026

      // Check for any 2nd level mapping required for this keyword
      wk2ndLevelMappingFound = False;
      If wkSearchFld1 <> *Blanks Or wkSearchFld2 <> *Blanks Or
         wkSearchFld3 <> *Blanks Or wkSearchFld3 <> *Blanks;

         wkSrhIndex = *Zeros;
         wkSrcDtaUpper  =  %xLate(cwLO:cwUP:wkSrcDta);
         If wkSearchFld1 <> *Blanks;
            wkSrhIndex += 1;
            ArrSearchFld(wkSrhIndex)  =  wkSearchFld1;
         EndIf;

         If wkSearchFld2 <> *Blanks;
            wkSrhIndex += 1;
            ArrSearchFld(wkSrhIndex)  =  wkSearchFld2;
         EndIf;

         If wkSearchFld3 <> *Blanks;
            wkSrhIndex += 1;
            ArrSearchFld(wkSrhIndex)  =  wkSearchFld3;
         EndIf;

         If wkSearchFld4 <> *Blanks;
            wkSrhIndex += 1;
            ArrSearchFld(wkSrhIndex)  =  wkSearchFld4;
         EndIf;

         // Get the max index for the loop
         wkMaxSrhCount = wkSrhIndex;

         For wkSrhIndex = 1 to wkMaxSrhCount;
             wkKeyList   =  ArrSearchFld(wkSrhIndex);
             // Declare the cursor to select the 2n level Pseudocode mapping
             Exec Sql
                declare IaPseudoMPC21 Scroll Cursor for
                     select   iAKeyFld2
                             ,iAActType
                             ,iASrcMap
                     from IaPseudoMP
                     where  iASrcLTyp = :wkSrcLtyp
                        and iASrcSpec = :wkSrcSpec
                        and iAKeyFld1 = :wkKeyList
                     order by iASeqNo                                                    //0009
                     for fetch only;
             Exec Sql
                  open IaPseudoMPC21;

             Exec Sql
                  fetch first from IaPseudoMPC21 Into :wkKeywordtoLookup,
                                                       :wkActionType,
                                                       :wk2ndLevelMapping;
             Dow SqlCode = successCode;

                // Get the position of the keyword
                wkScanPos   =  %Scan(%Trim(wkKeywordtoLookup):wkSrcdtaUpper:1);

                If wkActionType  = cwAddSpaceCheck;
                  // If the action type is added to check the space after the keyword
                  // Eg., TIME and TIMESTAMP are differnt, program please dont think it is same
                  wkScanPos   =  %Scan((%Trim(wkKeywordtoLookup)+ ' '):wkSrcdtaUpper:1);
                EndIf;

               // If the same keyword is repeated then get the pseudocode
               // eg., SFILE in DCL-F might be repeated
               // Also make sure it doesn't go on endless loop , keep a count Just in Case
               wkCount = 1;
               Dow (wkScanPos <> *Zeros And wkCount <= 10);
                If wkScanPos > 1;
                   // Get the Character before the keyword  and make sure it is
                   // blanks (this eliminate the keyword text in the variable)
                   wkCheckPos  = wkScanPos-1;
                   wkCheckChar = *Blanks;
                   wkCheckChar = %Subst( wkSrcdtaUpper  : wkCheckPos : 1);
                EndIf;

                If wkScanPos > *Zero And wkCheckChar = *Blanks;
                   wk2ndLevelMappingFound  = True;
                // Keyword found for the 2nd level Pseudocode mapping
                   If %Scan('&Var1' : wk2ndLevelMapping : 1) > *Zeros;
                      //Check if the Variable exits in mapping
                      wkStrPos    = *Zeros;
                      wkEndPos    = *Zeros;
                      wkVar1      = *Blanks;

                      wkStrPos   =  %Scan('(' : wkSrcDta : wkScanPos );
                      If wkStrPos = *Zeros;
                        //Get the position next to the keyword
                        wkStrPos =  wkScanPos + %Len(%Trim(wkKeywordtoLookup));
                      EndIf;

                      If wkStrPos > *Zeros;
                        wkEndPos   =  %Scan(')' : wkSrcDta : wkStrPos);
                      EndIf;

                      //If start and End positions are not Zero, substring the keyword
                      wkStrPos += 1;
                      If wkEndPos - wkStrPos > 1 and wkStrPos > *Zeros;                  //0022
                         wkVar1  =  %Subst(wkSrcDta : wkStrPos : (wkEndPos-wkStrPos));
                      EndIf;

                      //Map the variable to the Pseudcode
                         wk2ndLevelMapping = %ScanRpl('&Var1':wkVar1:wk2ndLevelMapping);
                         wkPseudoCode = %Trim(wkPseudoCode) + ' ' +
                                        %Trim(wk2ndLevelMapping);

                   Else;
                      wkPseudoCode = %Trim(wkPseudoCode) + ' ' +
                                    %Trim(wk2ndLevelMapping);
                   EndIf;
                   rcdFound = True;
                EndIf;

                //Check if the keyword is repeated in source
                wkScanPos  +=  1;
                wkScanPos   =  %Scan(%Trim(wkKeywordtoLookup):wkSrcdtaUpper:wkScanPos);
                wkCount    += 1;
               EndDo;

              //Handle the default setup
               If   wkMaxSrhCount = wkSrhIndex and                                       //0009
                    %Trim(wkKeywordtoLookup)='DEFAULT' and                               //0009
                    wk2ndLevelMappingFound = *Off;                                       //0009
                    wkPseudoCode = %Trim(wkPseudoCode) + ' ' +                           //0009
                                    %Trim(wk2ndLevelMapping);                            //0009
                    wk2ndLevelMappingFound = *On;                                        //0009
               EndIf;                                                                    //0009
              //Check if &KeyField1 is present in updated pseudocode
               If wk2ndLevelMappingFound = *On;                                          //0009
                  If %Scan('&KeyField1' : wkPseudoCode : 1) > *Zeros;                    //0009
                     wkKeyField = *Blanks;                                               //0009

                     If wkSavPos > *Zeros And (wkStrPos - wkSavPos) > *Zeros;            //0009
                       wkKeyField = %Subst(wkSrcDta : wkSavPos :                         //0009
                                    (wkStrPos - wkSavPos));                              //0009
                     EndIf;                                                              //0009

                     If %scan('%KDS(' : %Xlate(cwLo : cwUp : wkKeyField) :1) <> 0;       //0070
                        wkKeyField = %subst(%Trim(wkKeyField):6:                         //0009
                                     %len(%Trim(wkKeyField))-6);                         //0009
                     EndIf;                                                              //0009

                     If wkKeyField <> *Blanks;                                           //0009
                       wkPseudoCode =  %Scanrpl('&KeyField1' : %Trim(wkKeyField)         //0009
                                   : wkPseudoCode);                                      //0009
                     Else;                                                               //0009
                       wkPseudoCode =  %Scanrpl('&KeyField1' : ' '  : wkPseudoCode);     //0009
                     EndIf;                                                              //0009
                                                                                         //0009
                  EndIf;                                                                 //0009
               EndIf;                                                                    //0009

                Exec Sql
                   fetch next from IaPseudoMPC21 Into :wkKeywordtoLookup,
                                                       :wkActionType,
                                                       :wk2ndLevelMapping;
             EndDo;

             Exec Sql
                 close IaPseudoMPC21;
         Endfor;

      EndIf;

      //If dcl type found and 2nd level keyword not found, get the remaining source text
      If fwProcessDcltype And wkMaxSrhCount >= 1 And Not wk2ndLevelMappingFound And
         %Trim(wkDclType) = cwCspecDclType;
         //Get the remaining source text
         wkStrPos    = wkSavDclEndPos + 1 ;
         wkEndPos    = %Checkr( ' ' : wkSrcDta );
         wkSubstrLen =  wkEndPos - wkStrPos -1;
         If wkStrPos > 1 And  (wkStrPos  < wkEndPos) And wkSubstrLen > *Zeros;
           wkRemSrcDta = %Subst(wkSrcDta : wkStrPos : wkSubstrLen );
         EndIf;

         //Form the pseudocode
        wkPseudoCode = %Trim(wkPseudocode) + ' ' + %Trim(wkRemSrcDta);

      EndIf;

      //Check if the built in function exist in source statement and
      //process it to create the Pseudocide
      wkPos1  =   %Scan('%' : wkPseudoCode : 1);
      If wkPos1 > *Zeros;
        wkSrcDtaBIF = wkPseudoCode ;
        wkSrcDtaBIF = wkPseudoCode ;
        IOBifParmPointer = %Addr(dsNestedBIF);                                            //0032
        //Process Nested/Simple Built in Function                                        //0032
        If ProcessNestedBIF(wkSrcDtaBIF : IOBifParmPointer : OutMaxBif);                  //0032
        wkPseudoCode  = wkSrcDtaBIF;
        Else;                                                                             //0032
          //If processing unsuccessfull, write the original source statement             //0032
          wkPseudoCode  = %Trim(wkFFCParmDS.dwSrcDta);                                    //0032
        EndIf;                                                                            //0032
      EndIf;

   EndIf;

   If rcdFound;
     Exsr WriteFreeOutputData;                                                           //0038
   EndIf;

   // Pass the current indentation level and declaration type to keep a track in the next call
   wkFFCParmDS.dwDclType      =  wkDclType;
   wkFFCParmDS.dwSubType      =  wkkeyFld3;
   Eval-Corr RPGIndentParmDs  =  wkRPGIndentParmDs;                                      //0038
   wkFFCParmDS.dwIOIndentParmPointer = IOIndentParmPointer;                              //0038

   Return rcdFound;

//------------------------------------------------------------------------------------- //
//Subroutine ProcessBIF - Process the build in functions and create Pseudocode          //
//------------------------------------------------------------------------------------- //
   Begsr ProcessBIF;
            wkBIF  = *Blanks;
            wkArg1 = *Blanks;
            wkArg2 = *Blanks;
            wkArg3 = *Blanks;

            //Get the statement upto the Built In Function for pseudocode

            wkPos2  =   %Scan('(' : wkSrcDtaBIF : wkPos1);
            If wkPos2 - wkPos1 > 1 and wkPos1 > *Zeros;                                  //0022
              wkSubPos = wkPos1+1 ;
              wkBIF = %Trim(%Subst(wkSrcDtaBIF : wkSubPos : (wkPos2-wkPos1-1)));

              Monitor;
                wkBIF = %xLate(cwLO:cwUP:wkBIF);
                wkDclType = %Trim(wkBIF) ;
              On-Error;
              EndMon;

              //Get the mapping data from IaPseudoMP file for the Built in function
              wkMappingFoundInd = GetMappingData();                                      //0042
              wkSrcMap = wkSrcMapOut;                                                    //0042

            If wkMappingFoundInd = *On;                                                  //0028
               //Built In function found in mapping, check for the parameters in it
               //Back up the start posistion of BIF, to get the pseudocode before it
               wkSavPos = wkPos1;
               wkSavEndPos = *Zeros;
               If %Scan('&Var1' : wkSrcMap  : 1) > *Zeros;
                  //If Var1 exist in mapping get the BIF Argument value
                  wkPos1 = wkPos2+1;
                  wkPos2 = %Scan(':' : wkSrcDtaBIF : wkPos1);
                  If wkPos2 - wkPos1 > *Zeros and wkPos1 > *Zeros;                       //0022

                    wkArg1 = %Trim(%Subst(wkSrcDtaBIF : wkPos1
                                                    : (wkPos2-wkPos1)));
                //Upper statement was un commented and below one was generating dump
                //swap the logic to prevent dump.(Needs to be looked on urgent basis)
                     wkSrcMap  = %ScanRpl('&Var1':%Trim(wkArg1):wkSrcMap);
                  Else;
                     //If no more arguments then get the end position
                     wkPos2 = %Scan(')' : wkSrcDtaBIF : wkPos1);
                     If wkPos2 - wkPos1 > *Zeros and wkPos1 > *Zeros;                    //0022
                       wkArg1 = %Subst(wkSrcDtaBIF : wkPos1
                                                : (wkPos2-wkPos1));
                       wkSrcMap  = %ScanRpl('&Var1':%Trim(wkArg1):wkSrcMap);
                       wkSavEndPos = wkPos2;
                     Else;
                       //If no arguments but &Var1 exist in mapping then Clear it
                       wkSrcMap  = %ScanRpl('&Var1':' ' :wkSrcMap);
                     EndIf;
                  EndIf;
               EndIf;

               If %Scan('&Var2' : wkSrcMap : 1) > *Zeros;
                  //If Var2 exist in mapping get the BIF Argument value
                  wkPos1 = wkPos2+1;
                  wkPos2 = %Scan(':' : wkSrcDtaBIF : wkPos1);

                  If wkPos2 - wkPos1 > *Zeros and wkPos1 > *Zeros;                       //0022
                     wkArg2 = %Subst(wkSrcDtaBIF : wkPos1
                                               : (wkPos2-wkPos1));
                     wkSrcMap  = %ScanRpl('&Var2':%Trim(wkArg2):wkSrcMap);
                  Else;
                     //If no more arguments then get the end position
                     wkPos2 = %Scan(')' : wkSrcDtaBIF : wkPos1);
                     If wkPos2 - wkPos1 > *Zeros and wkPos1 > *Zeros;                    //0022
                       wkArg2 = %Subst(wkSrcDtaBIF : wkPos1
                                                : (wkPos2-wkPos1));
                       wkSrcMap  = %ScanRpl('&Var2':%Trim(wkArg2):wkSrcMap);
                       wkSavEndPos = wkPos2;
                     Else;
                       //If no arguments but &Var2 exist in mapping then Clear it
                       wkSrcMap  = %ScanRpl('&Var2':' ' :wkSrcMap);
                     EndIf;
                  EndIf;
               EndIf;

               If %Scan('&Var3' : wkSrcMap : 1) > *Zeros;
                  //If Var2 exist in mapping get the BIF Argument value
                  wkPos1 = wkPos2+1;
                  wkPos2 = %Scan(':' : wkSrcDtaBIF : wkPos1);

                  If wkPos2 - wkPos1 > *Zeros and wkPos1 > *Zeros;                       //0022
                     wkArg3 = %Subst(wkSrcDtaBIF : wkPos1
                                              : (wkPos2-wkPos1));
                     wkSrcMap  = %ScanRpl('&Var3':%Trim(wkArg3):wkSrcMap);
                  Else;
                     //If no more arguments then get the end position
                     wkPos2 = %Scan(')' : wkSrcDtaBIF : wkPos1);
                     If wkPos2 - wkPos1 > *Zeros and wkPos1 > *Zeros;                    //0022
                       wkArg3 = %Subst(wkSrcDtaBIF : wkPos1
                                                : (wkPos2-wkPos1));
                       wkSrcMap  = %ScanRpl('&Var3':%Trim(wkArg3):wkSrcMap);
                       wkSavEndPos = wkPos2;
                     Else;
                       //If no arguments then its by default
                       wkArg3 = '1';
                       wkSrcMap  = %ScanRpl('&Var3':%Trim(wkArg3):wkSrcMap);
                     EndIf;
                  EndIf;
               EndIf;

               wkPos1 = %Len(%Trim(wkSrcDtaBIF)) - wkSavEndPos  ;
               wkRemSrc = *Blanks;
               If wkPos1 > 1;
                 //Get the remaining statement ie., source after the built in function as well
                 wkRemSrc  =
                 %Subst(wkSrcDtaBIF : (wkSavEndPos + 1) : wkPos1);                       //0015
               EndIf;
               //Pseudocode with the built in function mapping
               wkSrcDtaBIF  = %Subst(wkSrcDtaBIF : 1 : (wkSavPos-1)) +
                              ' ' + %Trim(wkSrcMap) + ' ' + %Trim(wkRemSrc);

            EndIf;
            EndIf;                                                                       //0013

  Endsr;
//------------------------------------------------------------------------------------- //0067
//Subroutine  CheckEqulInProcCall                                                       //0067
//------------------------------------------------------------------------------------- //0067
   Begsr CheckEqulInProcCall;                                                            //0067
                                                                                         //0067
     If wkSrcDta1 <> *Blanks;                                                            //0067
        wkDclType = 'EVAL1 ';                                                            //0067
        //?Get the mapping data from IaPseudoMP file for the subfield                    //0067
        wkMappingFoundInd = GetMappingData();                                            //0067
        wkSrcMap  = wkSrcMapOut;                                                         //0067
        If wkSrcMap <> *Blanks;                                                          //0067
           wkPseudoCodeE =                                                               //0067
           %ScanRpl('&EVar1': %Subst(wkSrcDta:1: %Scan('=':wkSrcDta) -1):wksrcmap);      //0067
                                                                                         //0067
         EndIf;                                                                          //0067
      EndIf;                                                                             //0067
   EndSr;                                                                                //0067
                                                                                         //0067
//------------------------------------------------------------------------------------- //
//Subroutine FreeReadBlock - Handling of read with do loop                              //
//------------------------------------------------------------------------------------- //
   Begsr FreeReadBlock;                                                                  //0009

      wkiAKeyFld2 = *Blanks;                                                             //0009
      wkCLoopSrcDtaF = %Xlate(cwLo:cwUp:wkSrcDta);                                       //0009
      Select;                                                                            //0009
      //1 - Skip blank & commented lines
      When  %len(%trim(wkCLoopSrcDtaF))<=1                                               //0009
            or %subst(%trim(wkCLoopSrcDtaF):1:2)='//';                                   //0009
            return RcdFound;                                                             //0009
      //2 - Check if its a DOx statement which needs to be skipped
      When  wkFFCParmDS.dwSkipNxtStm = *On and %subst(wkDclType:1:2)='DO';               //0009
            wkFFCParmDS.dwSkipNxtStm = *Off;                                             //0009
            return RcdFound;                                                             //0009
      //3 - Check if its a READ statement which needs to be skipped
      When  %Subst(wkDclType:1:4)='READ' or %Subst(wkDclType:1:5)='CHAIN';               //0009
           //Retrieve file name
           wkFileNam  =  *Blanks;                                                        //0009
           wkLstPos=%scan(';':wkCLoopSrcDtaF:1); //Pick end position of the statement    //0009
           wkBegPos=%CheckR(cwAto9 : wkCLoopSrcDtaF: //Pick start pos for file name      //0009
                    wkLstPos-1);                                                         //0009
           If wkLstPos - wkBegPos > *Zeros and wkBegPos > *Zeros;                        //0022
           wkFileNam  = %Trim(%Subst(wkCLoopSrcDtaF: wkBegPos :                          //0009
                        (wkLstPos - wkBegPos)));                                         //0009
           EndIf;                                                                        //0009
           wkSrhIndex=%lookup(wkFileNam : wkFFCParmDS.dwFileNames:1:                     //0009
                       wkFFCParmDS.dwFileCount);                                         //0009
           //Check if loop was active for this file, if so don't process and return
           If  wkSrhIndex<> 0 and wkFileNam<>*Blanks                                     //0009
               and %Subst(wkDclType:1:4)='READ';                                         //0009
               wkFFCParmDS.dwFileCount -= 1;                                             //0009
               return RcdFound;                                                          //0009
           EndIf;                                                                        //0009
           //Read next source lines and if there is ending of loop in next lines
           //skip processing of this line if the READ loop was active
           exec sql declare CheckLoopingF cursor for                                     //0009
                    select XSrcDta from iAQRpgSrc where                                  //0009
                    XLibNam =:wkFFCParmDs.dwSrcLib  and                                  //0009
                    XSrcNam =:wkFFCParmDs.dwSrcPf   and                                  //0009
                    XMbrNam =:wkFFCParmDs.dwSrcMbr  and                                  //0009
                    XMbrTyp =:wkFFCParmDs.dwSrcType and                                  //0009
                    XSrcRrn >:wkFFCParmDs.dwSrcRrn                                       //0009
                    for fetch only;                                                      //0009
           exec sql open CheckLoopingF;
           DoW sqlcode = SuccessCode;                                                    //0009
            exec sql fetch from CheckLoopingF into :wkCLoopSrcDtaF;                      //0009
            If sqlcode=SuccessCode;                                                      //0009
               wkCLoopSrcDtaF = %Xlate(cwLo:cwUp:wkCLoopSrcDtaF);
               Select;                                                                   //0009
               //Skip commented and blank lines while searching for next loop starting
               When   wkCLoopSrcDtaF = *Blanks or %len(%trim(wkCLoopSrcDtaF))<=1;        //0009
                      Iter;                                                              //0009
               When   %Subst(%Trim(wkCLoopSrcDtaF):1:2)='//';                            //0009
                      Iter;                                                              //0009
               //Don't consider looping on file if next op code is not a 'DOx' loop
               When   %subst(%trim(wkCLoopSrcDtaF):1:2) <> 'DO';                         //0009
                      Leave;                                                             //0009
               //Check further if next row's opcode is a 'DOx' loop opcode
               When   %subst(%trim(wkCLoopSrcDtaF):1:2) = 'DO';                          //0009
               //If %EOF built in function has been used with READx operation
               //with DOx loop, consider it as reading all record loop
                      If   %scan('%EOF': wkCLoopSrcDtaF ) <> 0 ;                         //0009
                           //Retrieve file name
                           wkFileNam  =  *Blanks;                                        //0009
                           wkLstPos=%scan(';':wkCLoopSrcDtaF:1);                         //0009
                           wkBegPos=%CheckR(cwAto9 : wkCLoopSrcDtaF :                    //0009
                                    wkLstPos-1);                                         //0009
                           If wkLstPos - wkBegPos > *Zeros and wkBegPos > *Zeros;        //0022
                              wkFileNam  = %trim(%Subst(wkCLoopSrcDtaF : wkBegPos :      //0009
                                           (wkLstPos - wkBegPos))) ;                     //0009
                           wkFFCParmDs.dwSkipNxtStm = *On;                               //0009
                           wkFFCParmDs.dwFileCount += 1;                                 //0009
                           wkFFCParmDs.dwFileNames(wkFFCParmDs.dwFileCount)=wkFileNam;   //0009
                           wkiAKeyFld2 = 'LOOP';                                         //0009
                           EndIf;                                                        //0009
                           Leave;                                                        //0009
                      Else;                                                              //0009
                           Leave;                                                        //0009
                      EndIf;                                                             //0009
               Other;                                                                    //0009
                      Leave;                                                             //0009
               EndSl;                                                                    //0009
            EndIf;                                                                       //0009
           EndDo;                                                                        //0009
          exec sql close CheckLoopingF;                                                   //0009
      EndSl;                                                                             //0009

   EndSr;                                                                                //0009

//------------------------------------------------------------------------------------- //0020
// Subroutine  GetEvalOperator                                                           //0020
//------------------------------------------------------------------------------------- //0020
   Begsr GetEvalOperator;                                                                //0020
                                                                                         //0020
      Select ;                                                                           //0020
         When %Scan('+=' : wkSrcDta : 1) > *Zeros;                                       //0020
            wkDclType = %Trim(wkDclType) + '+=';                                         //0020
            wkSrcDta = %ScanRpl('+='  : ' = '  : wkSrcDta);                              //0020
                                                                                         //0020
         When %Scan('-=' : wkSrcDta : 1) > *Zeros;                                       //0020
            wkDclType = %Trim(wkDclType) + '-=';                                         //0020
            wkSrcDta = %ScanRpl('-='  : ' = '  : wkSrcDta);                              //0020
                                                                                         //0020
         When %Scan('**=' : wkSrcDta : 1) > *Zeros;                                      //0020
            wkDclType = %Trim(wkDclType) + '**=';                                        //0020
            wkSrcDta = %ScanRpl('**='  : ' = '  : wkSrcDta);                             //0020
                                                                                         //0020
         When %Scan('*=' : wkSrcDta : 1) > *Zeros;                                       //0020
            wkDclType = %Trim(wkDclType) + '*=';                                         //0020
            wkSrcDta = %ScanRpl('*='  : ' = '  : wkSrcDta);                              //0020
                                                                                         //0020
         When %Scan('/=' : wkSrcDta : 1) > *Zeros;                                       //0020
            wkDclType = %Trim(wkDclType) + '/=';                                         //0020
            wkSrcDta = %ScanRpl('/='  : ' = '  : wkSrcDta);                              //0020
                                                                                         //0020
      EndSl;                                                                             //0020
   Endsr ;                                                                               //0020

//------------------------------------------------------------------------------------- //0038
// Subroutine WriteFreeOutputData - Write pseudo code data to IAPSEUDOCP file for free   //0038
//------------------------------------------------------------------------------------- //0038
   BegSr WriteFreeOutputData;                                                            //0038

      Clear wkPseudocodeFontBkp;                                                         //0044
      //Write the Blank Line at Start of Cspec before writing the actual pseudo code    //0057
      If wkCspecBlankInd = *Off and wkSrcSpec='C';                                       //0057
         Clear OutParmWriteSrcDocDS.dsPseudocode ;                                       //0057
         OutParmWriteSrcDocDS.dsPseudocode = *Blanks;                                    //0057
         OutParmWriteSrcDocDS.dsSrcSpec = wkSrcSpec;                                     //0057
         IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                                   //0057
         WritePseudoCode(IOParmPointer);                                                 //0057
         wkCspecBlankInd = *On;                                                          //0057
      EndIf;                                                                             //0057
      Eval-Corr OutParmWriteSrcDocWDS= wkFFCParmDS;                                      //0055
      Eval OutParmWriteSrcDocDS = OutParmWriteSrcDocWDS;                                 //0055

     //Check if current line's rrn is same as the rrn of the main logic's start         //0038
     //line, If so write the main logic begin text.                                     //0038
     If wkFFCParmDS.dwSrcRrn >= wkBgnRrnForMainLogic and wkBgnRrnForMainLogic <>0;       //0038
        For wkIdx = 1 to 5;                                                              //0038
           OutParmWriteSrcDocDS.dsPseudocode = wkBgnMainLogicCmnt(wkIdx);                //0038
           IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                                 //0038
           WritePseudoCode(IOParmPointer);                                               //0038
        EndFor;                                                                          //0038
        wkBgnRrnForMainLogic =0;                                                         //0038
     EndIf;                                                                              //0038

     //Add indentation to comment description                                           //0038
     If wkRPGIndentParmDs.dsCurrentIndents > *Zeros And                                  //0038
        wkCommentDesc <> *Blanks And wkActionType <> cwPrtCmntAftr;                      //0038
        wkRPGIndentParmDs.dsIndentType = *Blanks ;                                       //0038
        wkRPGIndentParmDs.dsPseudocode = wkCommentDesc;                                  //0038
        wkIOIndentParmPointer = %Addr(wkRPGIndentParmDS);                                //0038
        IndentRPGPseudoCode(wkIOIndentParmPointer);                                      //0038
        wkCommentDesc = wkRPGIndentParmDS.dsPseudocode;                                  //0038
     EndIf;                                                                              //0038

     //Write the comment description before pseudo code                                 //0038
     OutParmWriteSrcDocDS = wkFFCParmDS;                                                 //0038
     If wkDclType <> wkPrvDclType And wkCommentDesc <> *Blanks and                       //0038
        wkActionType <> cwPrtCmntAftr;                                                   //0038
        //Change of the coding type, write a blanks line and a heading comment          //0038
        OutParmWriteSrcDocDS.dsPseudocode = *Blanks;                                     //0038
        IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                                    //0038
        WritePseudoCode(IOParmPointer);                                                  //0038
        OutParmWriteSrcDocDS.dsPseudocode = wkCommentDesc;                               //0038
        IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                                    //0038
        WritePseudoCode(IOParmPointer);                                                  //0038
     EndIf;                                                                              //0038

      //Prepare source code as comment for better understanding of user for nested BIF   //0036
     If OutMaxBif >= 1;                                                                  //0036
         wkBIFCommentDes = '// ' + %Trim(wkFFCParmDS.dwSrcDta);                          //0036
      EndIf;

     If wkRPGIndentParmDs.dsCurrentIndents > *Zeros Or wkSavIndentType <> *Blanks;       //0038
        //In case no executable statement processed after indentation started,           //0038
        //Print do nothing.                                                              //0038
        If (wkSavIndentType = cwRemove OR wkSavIndentType = cwRemoveCheck                //0038
           or wkSavIndentType = cwBranch)                                                //0038
           and wkRPGIndentParmDs.dsIndentIndex <> 0                                      //0053
           and                                                                           //0038
           (wkSavIndentType <> cwBranch or (wkSavIndentType = cwBranch and               //0038
           wkRPGIndentParmDs.dsIndentTypeArr(wkRPGIndentParmDs.dsIndentIndex)            //0038
           <>cwAdd))                                                                     //0038
           and                                                                           //0038
           wkCountOfLineProcessAfterIndentation = 0;                                     //0038

           //Write a blank line in case previous line was not blank.                     //0053
           //If wkLastWrittenData <> *Blanks;                                            //0055
           If %check(' |' : wkLastWrittenData) <> 0 ;                                    //0055
              OutParmWriteSrcDocDS.dsPseudocode = *Blanks;                               //0053
              IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                              //0053
              WritePseudoCode(IOParmPointer);                                            //0053
           EndIf;                                                                        //0053
           wkRPGIndentParmDS.dsIndentType = *Blanks ;                                    //0038
           wkRPGIndentParmDS.dsPseudocode = wkDoNothingComment;                          //0053
           wkIOIndentParmPointer = %Addr(wkRPGIndentParmDS);                             //0038
           IndentRPGPseudoCode(wkIOIndentParmPointer);                                   //0038
           OutParmWriteSrcDocDS.dsPseudocode = wkRPGIndentParmDS.dsPseudocode;           //0038
           IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                                 //0038
           WritePseudoCode(IOParmPointer);                                               //0038
        EndIf;                                                                           //0038
        //Add indentation to BIF comment description (source data)                       //0036
        If OutMaxBif>=1 and wkSavIndentType <> cwNewBranch;                              //0036
           wkRPGIndentParmDs.dsIndentType = *Blanks ;                                    //0036
           wkRPGIndentParmDs.dsPseudocode = wkBIFCommentDes;                             //0036
           wkIOIndentParmPointer = %Addr(wkRPGIndentParmDS);                             //0036
           IndentRPGPseudoCode(wkIOIndentParmPointer);                                   //0036
           If wkSavIndentType = cwBranch and wkRPGIndentParmDS.dsIndentIndex > 0 and     //0036
              wkRPGIndentParmDS.dsIndentTypeArr(wkRPGIndentParmDS.dsIndentIndex) =       //0036
              cwBranch and %len(%trimr(wkRPGIndentParmDS.dsPseudocode))>6;               //0036
              wkBIFCommentDes = %subst(wkRPGIndentParmDS.dsPseudocode:6);                //0036
           Else;                                                                         //0036
              wkBIFCommentDes = wkRPGIndentParmDS.dsPseudocode;                          //0036
           EndIf;                                                                        //0036
        EndIf;                                                                           //0036
        //Add Indentation to pseudocode                                                 //0038
        wkRPGIndentParmDS.dsIndentType = wkSavIndentType ;                               //0038
        wkRPGIndentParmDS.dsPseudocode = wkPseudoCode;                                   //0038
        wkIOIndentParmPointer = %Addr(wkRPGIndentParmDS);                                //0038
        IndentRPGPseudoCode(wkIOIndentParmPointer);                                      //0038
        wkPseudoCode = wkRPGIndentParmDS.dsPseudocode;                                   //0038

        //For new brach start (IF Condition), split pseudo code and print in two lines   //0038
        If wkSavIndentType = cwNewBranch;                                                //0038
           Exsr NewBranchFreePseudoCodeSplit;                                            //0038
        EndIf;                                                                           //0038

     EndIf;                                                                              //0038


      //Write the pseudocode for the nested built in function                           //0038
      If  OutMaxBif >= 1;                                                                //0038
         //Write BIF source code as comment for better understanding                     //0036
         OutParmWriteSrcDocDS.dsPseudocode = wkBIFCommentDes;                            //0036
         IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                                   //0036
         WritePseudoCode(IOParmPointer);                                                 //0036
         //Write BIF first line                                                         //0038
         OutParmWriteSrcDocDS.dsPseudocode = wkPseudoCode;                               //0038
         IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                                   //0038
         WritePseudoCode(IOParmPointer);                                                 //0038
         //Process each of the built in function extracted as individual BIF            //0038
         For wkForIndex  = OutMaxBif Downto 1;                                           //0038
            %Occur(DsNestedBif) = wkForIndex;                                            //0038
            //Add indentation before writing the BIF details:@rpglint-skip               //0036
            wkRPGIndentParmDS.dsIndentType = *Blanks ;                                   //0036
            wkRPGIndentParmDS.dsPseudocode = %trim(wDsBifPseudocode);                    //0036
            wkIOIndentParmPointer = %Addr(wkRPGIndentParmDS);                            //0036
            IndentRPGPseudoCode(wkIOIndentParmPointer);                                  //0036
            //Write the pseudocode                                                      //0038
            OutParmWriteSrcDocDS.dsPseudocode = wkRPGIndentParmDS.dsPseudocode;          //0036
            IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                                //0038
            WritePseudoCode(IOParmPointer);                                              //0038
         EndFor;                                                                         //0038
         //Write blank line at the end  of the nested bif                               //0038
         OutParmWriteSrcDocDS.dsPseudocode = *Blanks;                                    //0038
         IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                                   //0038
         WritePseudoCode(IOParmPointer);                                                 //0038
      Else;                                                                              //0038

         If WriteExprsDtls = 'Y' ;                                                       //0100
            //Write expression source code as comment for better understanding           //0100
            wkExpCommentDes = '// ' + %Trim(wkFFCParmDS.dwSrcDta);                       //0100
            OutParmWriteSrcDocDS.dsPseudocode = wkExpCommentDes;                         //0100
            IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                                //0100
            WritePseudoCode(IOParmPointer);                                              //0100
            WriteExprsDtls = 'N' ;                                                       //0100
            //Write expression output line                                              //0100
            OutParmWriteSrcDocDS.dsPseudocode = %trim(wkPseudoCode);                     //0100
            IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                                //0100
            WritePseudoCode(IOParmPointer);                                              //0100
            //Write sub lines of the expression                                          //0100
            ProcessExpression (wkSrcDta : 'W' :                                          //0100
                               wkRPGIndentParmDS) ;                                      //0100
         Else ;                                                                          //0100
            OutParmWriteSrcDocDS.dsPseudocode = wkPseudoCode;                            //0100
            IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                                //0100
            WritePseudoCode(IOParmPointer);                                              //0100
         Endif ;                                                                         //0100

      EndIf;                                                                             //0038

     //Add Indentation for the code to print next Line for call statements              //0038
     If WkPseudoNext <> *Blanks and WKNoParm = *Off ;                                    //0038
        If wkRPGIndentParmDs.dsCurrentIndents > *Zeros ;                                 //0038
           wkRPGIndentParmDS.dsIndentType = *Blanks ;                                    //0038
           wkRPGIndentParmDS.dsPseudocode = wkPseudoNext;                                //0038
           wkIOIndentParmPointer = %Addr(wkRPGIndentParmDS);                             //0038
           IndentRPGPseudoCode(wkIOIndentParmPointer);                                   //0038
           wkPseudoNext = wkRPGIndentParmDS.dsPseudocode;                                //0038
        EndIf;                                                                           //0038
        //Check BIF in next line                                                        //0067
        ExSr WriteBIFpseudoForNext;                                                      //0067
        wkPseudoNext = *Blanks ;                                                         //0038
     Endif;                                                                              //0038

     //Write a blank line after each condition or loop statment                         //0038
     If wkSavIndentType <> *Blanks;                                                      //0038
        OutParmWriteSrcDocDS.dsPseudocode = *Blanks;                                     //0038
        IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                                    //0038
        WritePseudoCode(IOParmPointer);                                                  //0038
     EndIf;                                                                              //0038

     //Check if current line's rrn is same as the rrn of the main logic's end line,     //0038
     //If so, write the main logic ending text.                                         //0038
     If wkFFCParmDS.dwSrcRrn >= wkLstRrnForMainLogic and wkLstRrnForMainLogic <>0;       //0038
        OutParmWriteSrcDocDS.dsPseudocode = *Blanks;                                     //0038
        IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                                    //0038
        WritePseudoCode(IOParmPointer);                                                  //0038
        OutParmWriteSrcDocDS.dsPseudocode = wkEndMainLogicCmnt;                          //0038
        IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                                    //0038
        WritePseudoCode(IOParmPointer);                                                  //0038
        wkLstRrnForMainLogic = 0;                                                        //0038
     EndIf;                                                                              //0038

     //Write comment description after pseudo code based on action type                 //0038
     If wkDclType <> wkPrvDclType And wkCommentDesc <> *Blanks and                       //0038
        wkActionType =  cwPrtCmntAftr;                                                   //0038
        //Comment                                                                       //0038
        OutParmWriteSrcDocDS.dsPseudocode = wkCommentDesc;                               //0038
        IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                                    //0038
        WritePseudoCode(IOParmPointer);                                                  //0038
     EndIf;                                                                              //0038

      //Initialize count of number of statements written after indentation started       //0038
      //or removed                                                                       //0038
      If wkSavIndentType <> *Blanks and wkSavIndentType <> cwRemove;                     //0038
         wkCountOfLineProcessAfterIndentation = 0;                                       //0038
      EndIf;                                                                             //0038
     wkPrevIndentType  = wkSavIndentType;                                                //0038

   EndSr;                                                                                //0038

//------------------------------------------------------------------------------------- //0067
//Subroutine writeBIFpseudoForNext                                                      //0067
//------------------------------------------------------------------------------------- //0067
   BegSr WriteBIFpseudoForNext;                                                          //0067
                                                                                         //0067
      //Check if the built in function exist in source statement and                    //0067
      //process it to create the Pseudocide                                             //0067
      wkPos1  =   %Scan('%' : wkPseudoNext : 1);                                         //0067
      If wkPos1 > *Zeros;                                                                //0067
        wkSrcDtaBIF = wkPseudoNext ;                                                     //0067
        IOBifParmPointer = %Addr(dsNestedBIF);                                           //0067
        //Process Nested/Simple Built in Function                                       //0067
        If ProcessNestedBIF(wkSrcDtaBIF : IOBifParmPointer : OutMaxBif);                 //0067
           wkPseudoCode  = wkSrcDtaBIF;                                                  //0067
        Else;                                                                            //0067
          //If processing unsuccessfull, write the original source statement            //0067
          wkPseudoCode  = %Trim(wkFFCParmDS.dwSrcDta);                                   //0067
        EndIf;                                                                           //0067
      EndIf;                                                                             //0067
                                                                                         //0067
      //Write the pseudocode for the nested built in function                           //0067
      If  OutMaxBif >= 1;                                                                //0067
         //Write BIF first line                                                         //0067
         OutParmWriteSrcDocDS.dsPseudocode = wkPseudoCode;                               //0067
         IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                                   //0067
         WritePseudoCode(IOParmPointer);                                                 //0067
         //Process each of the built in function extracted as individual BIF            //0067
         For wkForIndex  = OutMaxBif Downto 1;                                           //0067
            %Occur(DsNestedBif) = wkForIndex;                                            //0067
            //Add indentation before writing the BIF details:@rpglint-skip               //0067
            wkRPGIndentParmDS.dsIndentType = *Blanks ;                                   //0067
            wkRPGIndentParmDS.dsPseudocode = %trim(wDsBifPseudocode);                    //0067
            wkIOIndentParmPointer = %Addr(wkRPGIndentParmDS);                            //0067
            IndentRPGPseudoCode(wkIOIndentParmPointer);                                  //0067
            //Write the pseudocode                                                      //0067
            OutParmWriteSrcDocDS.dsPseudocode = wkRPGIndentParmDS.dsPseudocode;          //0067
            IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                                //0067
            WritePseudoCode(IOParmPointer);                                              //0067
         EndFor;                                                                         //0067

         //Write the Pseudocode for Proc Call having return value                       //0067
         If wkPseudoCodeE <> *Blanks;                                                    //0067
            OutParmWriteSrcDocDS.dsPseudocode = wkPseudoCodeE;                           //0067
            IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                                //0067
            WritePseudoCode(IOParmPointer);                                              //0067
            wkPseudoCodeE = *Blanks;                                                     //0067
         EndIf;                                                                          //0067

         //Write blank line at the end  of the nested bif                               //0067
         OutParmWriteSrcDocDS.dsPseudocode = *Blanks;                                    //0067
         IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                                   //0067
         WritePseudoCode(IOParmPointer);                                                 //0067
      Else;                                                                              //0067
         OutParmWriteSrcDocDS.dsPseudocode = wkPseudoNext;                               //0067
         IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                                   //0067
         WritePseudoCode(IOParmPointer);                                                 //0067
         //Write BIF source code as comment for better understanding                     //0067
         OutParmWriteSrcDocDS.dsPseudocode = wkBIFCommentDes;                            //0067
         IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                                   //0067
         WritePseudoCode(IOParmPointer);                                                 //0067
      EndIf;                                                                             //0067
   EndSr;                                                                                //0067
//------------------------------------------------------------------------------------- //0038
//Subroutine NewBranchFreePseudoCodeSplit - Split NEW BRANCH (If condition) pseudo code //0038
//------------------------------------------------------------------------------------- //0038
   Begsr NewBranchFreePseudoCodeSplit;                                                       //0038

      //In case this is a new branch starting (i.e. IF condition), consider to split     //0038
      //and print part 1 of the pseudo code (split from characters ~|~|) and print it    //0038
      //first than treat the part 2 of pseudo code as a branch.                          //0038
      Clear wkPseudoCode1;                                                               //0038
      wkPseudoCode1 = wkPseudoCode;                                                      //0038
      wkIdx = %scan(cwSplitCharacter : wkPSeudoCode);                                    //0038
      If wkIdx <> 0;                                                                     //0038
         //Split                                                                         //0038
         Clear wkPSeudoCode;                                                             //0038
         wkPseudoCode = %Subst(wkPseudoCode1 : 1: wkIdx-1);                              //0038

         wkPseudocodeFontBkp = wkPseudoCode;                                             //0044

         //Write part1 of Pseudocode to the IAPSEUDOCP file                              //0038
         OutParmWriteSrcDocDS.dsPseudocode = wkPseudoCode;                               //0038
         IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                                   //0038
         WritePseudoCode(IOParmPointer);                                                 //0038
         //Write blank line after part 1                                                 //0038
         OutParmWriteSrcDocDS.dsPseudocode = *Blanks;                                    //0038
         IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                                   //0038
         WritePseudoCode(IOParmPointer);                                                 //0038
         //Add same indentation to source code data to be written for BIF                //0036
         If OutMaxBif>=1;                                                                //0036
            wkRPGIndentParmDs.dsIndentType = *Blanks ;                                   //0036
            wkRPGIndentParmDs.dsPseudocode = wkBIFCommentDes;                            //0036
            wkIOIndentParmPointer = %Addr(wkRPGIndentParmDS);                            //0036
            IndentRPGPseudoCode(wkIOIndentParmPointer);                                  //0036
            wkBIFCommentDes = wkRPGIndentParmDS.dsPseudocode;                            //0036
         EndIf;                                                                          //0036
         //Move remaining part2 to pseudocode                                            //0038
         Clear wkPSeudoCode;                                                             //0038
         wkPseudoCode = %Subst(wkPseudoCode1 : wkIdx+4);                                 //0038
         //Move indentation type as BRANCH for part 2 and add indentation                //0038
         wkSavIndentType = cwBranch;                                                     //0038
         wkRPGIndentParmDS.dsIndentType = wkSavIndentType ;                              //0038
         wkRPGIndentParmDS.dsPseudocode = wkPseudoCode;                                  //0038
         wkIOIndentParmPointer = %Addr(wkRPGIndentParmDS);                               //0038
         IndentRPGPseudoCode(wkIOIndentParmPointer);                                     //0038
         wkPseudocode = wkRPGIndentParmDS.dsPseudocode;                                  //0038
      EndIf;                                                                             //0038

   EndSr;                                                                                //0038
                                                                                         //0041
//------------------------------------------------------------------------------------- //0041
// Subroutine  CheckforProcCall                                                          //0041
// Program or procedure call can be checked for presence of () but there can be scenario //0041
// when array data is being assigned to another variable which can as well qualify for a //0041
// program or procedure call. To differentiate the same, we extract the procedure or     //0041
// program name from source data and check the presence of the same in file IAPGMVARS &  //0041
// IAPGMDS for possibility of array name. If not dound, it is treated as procedure or    //0041
// program call.                                                                         //0041
//------------------------------------------------------------------------------------- //0041
   Begsr CheckforProcCall;                                                               //0041
      If %Scan('(' : wkSrcdta) > *Zeros AND %Scan(')' : wkSrcdta) > *Zeros               //0041
         AND %Scan('(' : wkSrcdta) < %Scan(')' : wkSrcdta) ;                             //0041
         If %Scan('=' : wkSrcdta) > *Zeros AND %Scan('%' : wkSrcdta : 1 :                //0067
            %Scan('(' : wkSrcdta)) > *Zeros                                              //0067
            OR %Scan('+' : wkSrcdta) > *Zeros  OR  %Scan('-' : wkSrcdta) > *Zeros        //0041
            OR %Scan('/' : wkSrcdta) > *Zeros  OR  %Scan('*' : wkSrcdta) > *Zeros        //0067
            OR %Scan('"' : wkSrcdta) > *Zeros  and                                       //0067
               %Scan('"' : wkSrcdta) <  %Scan('(' : wkSrcdta )                           //0067
            OR %Scan('"' : wkSrcdta) > *Zeros  and                                       //0067
               %Scan('"' : wkSrcdta) >  %ScanR(')' : wkSrcdta) ;                         //0067
                                                                                         //0067
               ProcCallFound = 'N' ;                                                     //0041
         Else ;                                                                          //0041
            If %Scan('=' : WkSrcdta) > *Zeros ;                                          //0041
               wkStrPos = %Check(' ' : wkSrcdta : %Scan('=' : wkSrcdta)+1) ;             //0041
            Else ;                                                                       //0041
               wkStrPos = %Check(' ' : wkSrcdta) ;                                       //0041
            Endif ;                                                                      //0041
            If wkStrPos > *Zeros ;                                                       //0041
               wkEndPos = %Scan('(' : wkSrcdta : wkStrPos) ;                             //0041
               If wkEndPos > *Zeros ;                                                    //0041
                  ProcName = %subst(wkSrcDta : wkStrPos : (wkEndPos-wkStrPos)) ;         //0041
               Endif ;                                                                   //0041
            Endif ;                                                                      //0041
            If ProcName <> *Blanks AND %Scan('=' : WkSrcdta) > *Zeros ;                  //0041
               Exec Sql                                                                  //0041
                  Select 1                                                               //0041
                     Into :ProcCallFound                                                 //0041
                     From IAPGMVARS                                                      //0041
                     Where IAV_MBR = :OutParmWriteSrcDocDS.dsSrcMbr AND                  //0041
                           IAV_VAR = :ProcName AND IAV_DIM <> 0                          //0041
                           Fetch First Row Only ;                                        //0041
               If SqlCode <> SuccessCode ;                                               //0041
                  Exec Sql                                                               //0041
                     Select 1                                                            //0041
                        Into :ProcCallFound                                              //0041
                        From IAPGMDS                                                     //0041
                        Where MEMBER_NAME = :OutParmWriteSrcDocDS.dsSrcMbr AND           //0041
                              DATASTR_NAME = :ProcName AND DATASTR_DIM <> 0              //0041
                              Fetch First Row Only ;                                     //0041
                  If SqlCode = SuccessCode ;                                             //0041
                     ProcCallFound = 'N' ;                                               //0041
                  Else ;                                                                 //0041
                     ProcCallFound = 'Y' ;                                               //0041
                  Endif ;                                                                //0041
               Else ;                                                                    //0041
                  ProcCallFound = 'N' ;                                                  //0041
               Endif ;                                                                   //0041
            Elseif ProcName <> *Blanks ;                                                 //0041
               ProcCallFound = 'Y' ;                                                     //0041
            Endif ;                                                                      //0041
            If ProcCallFound = 'Y' ;                                                     //0041
               If %Scan('=': wkSrcDta) > *Zeros;                                         //0067
                  wkSrcDta1 = wkSrcDta ;                                                 //0067
                  ExSr  CheckEqulInProcCall;                                             //0067
                  wkSrcDta  = wkSrcDta1;                                                 //0067
               EndIf;                                                                    //0067
               wkDclType = 'CALLP' ;                                                     //0041
               wkEndPos = %Scan(';' : wkSrcdta : wkStrPos) ;                             //0041
               wkSrcDta = 'CALLP ' + %subst(wkSrcDta : wkStrPos :                        //0041
                                            (wkEndPos-wkStrPos+1)) ;                     //0041
            Endif ;                                                                      //0041
         Endif ;                                                                         //0041
      Endif ;                                                                            //0041
   Endsr ;                                                                               //0041
//------------------------------------------------------------------------------------- //0100
//Subroutine CheckforArithExpr - Check if the expression is an arithmetic expression    //0100
//------------------------------------------------------------------------------------- //0100
   Begsr CheckforArithExpr ;                                                             //0100
      Select ;                                                                           //0100
      //Check for operators to execute existing code                                     //0100
      When                                                                               //0100
         %Scan('+=' : wkSrcDta : 1) > *Zeros   OR                                        //0100
         %Scan('-=' : wkSrcDta : 1) > *Zeros   OR                                        //0100
         %Scan('*=' : wkSrcDta : 1) > *Zeros   OR                                        //0100
         %Scan('/=' : wkSrcDta : 1) > *Zeros  ;                                          //0100
         Exsr  GetEvalOperator ;                                                         //0100
      //Scan for +,-,/,* to identify arithmetic operation                                //0100
      When                                                                               //0100
         (%Scan('+' : wkSrcDta : 1) > *Zeros   OR                                        //0100
         %Scan('-' : wkSrcDta : 1) > *Zeros    OR                                        //0100
         %Scan('*' : wkSrcDta : 1) > *Zeros    OR                                        //0100
         %Scan('/' : wkSrcDta : 1) > *Zeros)   AND                                       //0100
         %Scan('%' : wkSrcDta : 1) = *Zeros    AND                                       //0100
         %Scan('"' : wkSrcDta : 1) = *Zeros    AND                                       //0100
         %Scan('?' : wkSrcDta : 1) = *Zeros ;                                            //0100
         ProcessExpression (wkSrcDta : 'P' :                                             //0100
                            wkRPGIndentParmDS) ;                                         //0100
         WriteExprsDtls = 'Y' ;                                                          //0100
         wkDclType = 'EVALA' ;                                                           //0100
      EndSl ;                                                                            //0100
   Endsr ;                                                                               //0100
                                                                                         //0100
//------------------------------------------------------------------------------------- //0090
//Subroutine CheckMonitorGroupOnErr  -Do not generate pseudocode for On-Errorr Group    //0090
//           when no executable statement between On-Error and EndMon                   //0090
//------------------------------------------------------------------------------------- //0090
   BegSr  CheckMonitorGroupOnErr;                                                        //0090
                                                                                         //0090
      Exec Sql declare CheckMonGrpOnEr cursor for                                        //0090
         select XSrcDta from iAQRpgSrc where                                             //0090
         XLibNam =:wkFFCParmDs.dwSrcLib  and                                             //0090
         XSrcNam =:wkFFCParmDs.dwSrcPf   and                                             //0090
         XMbrNam =:wkFFCParmDs.dwSrcMbr  and                                             //0090
         XMbrTyp =:wkFFCParmDs.dwSrcType and                                             //0090
         XSrcRrn >:wkFFCParmDs.dwSrcRrn                                                  //0090
         for fetch only;                                                                 //0090
      Exec sql open CheckMonGrpOnEr;                                                     //0090
         DoW sqlcode = SuccessCode;                                                      //0090
            Exec sql fetch from CheckMonGrpOnEr into :wkMonGrpOnErr;                     //0090
            If sqlcode=SuccessCode;                                                      //0090
               wkMonGrpOnErr = %Xlate(cwLo:cwUp:wkMonGrpOnErr);                          //0090
               wkMonGrpOnErr = %Trim(%Scanrpl(';' : ' ' : wkMonGrpOnErr));               //0090
               wkMonGrpOnErr = %Subst(wkMonGrpOnErr:1:(%scan(' ':wkMonGrpOnErr) -1));    //0090
                                                                                         //0090
               Select;                                                                   //0090
               //Skip blank lines                                                       //0090
               When wkMonGrpOnErr = *Blanks or %len(%trim(wkMonGrpOnErr))<=1;            //0090
                  Iter;                                                                  //0090
               //Skip comment lines                                                     //0090
               When %Subst((wkMonGrpOnErr):1:2)='//';                                    //0090
                  Iter;                                                                  //0090
               //Leave when some thing code other than EndMon                           //0090
               When wkMonGrpOnErr  <>  cwEndM;                                           //0090
                  Leave;                                                                 //0090
              //Return when EndMon found immediat to On-Error                           //0090
               Other;                                                                    //0090
                  Return RcdFound;                                                       //0090
               EndSl;                                                                    //0090
            EndIf;                                                                       //0090
         EndDo;                                                                          //0090
         Exec sql Close CheckMonGrpOnEr;                                                 //0090
   EndSr;                                                                                //0090
//------------------------------------------------------------------------------------- //0085
//Subroutine IsOpcodeOrProcCall Check if the Keyword is an Opcode or a Procedure call   //0085
//------------------------------------------------------------------------------------- //0085
   Begsr IsOpcodeOrProcCall;                                                             //0085

      If wkMappingFoundInd = *Off            And                                         //0085
         %Scan(cwColon : wkDclType) = *Zeros And                                         //0085
         %Scan(cwQuote : wkDclType) = *Zeros And                                         //0085
         %Scan('(' : wkDclType) <> *Zeros    And                                         //0085
         %Scan(')' : wkDclType) <> *Zeros    And                                         //0085
         %Scan('(' : wkDclType) < %Scan(')' : wkDclType);                                //0085

         wkIdx = %Scan('(' : wkDclType : wkStrPos) ;                                     //0085
         wkDclType = %Subst(wkDclType : wkStrPos : wkIdx - wkStrPos);                    //0085

         wkMappingFoundInd = GetMappingData();                                           //0085
         wkSrcMap = wkSrcMapOut;                                                         //0085

      EndIf ;                                                                            //0085

   Endsr ;                                                                               //0085
                                                                                         //0041
/copy 'QCPYSRC/iaprcerlog.rpgleinc'
End-Proc;
//------------------------------------------------------------------------------------- //
//Procedure to add indentaton to the Pseudocode                                         //
//------------------------------------------------------------------------------------- //
Dcl-Proc IaAddPseudocodeIndentation Export;

   Dcl-Pi IaAddPseudocodeIndentation;
      inwIndentParmPointer Pointer;
   End-Pi;

   // Declaration of datastructure
   Dcl-Ds IndentParmDS  Qualified Based(inwIndentParmPointer);
      dsIndentType      Char(10);
      dsIndentLevel    Packed(5:0);
      dsPseudocode     Char(cwSrcLength);
      dsMaxLevel       Packed(5:0);
      dsIncrLevel      Packed(5:0);
      dsIndentArray    Packed(5:0) Dim(999);
   End-Ds;


   // Declare variable
   Dcl-S    wkIndentType      Char(10) Inz;
   Dcl-S    wkPseudocode      Char(cwSrcLength) Inz;
   Dcl-S    wkIndentLevel     Packed(5:0) Inz;
   Dcl-S    fwRemoveIndent    Ind         Inz;
   Dcl-S    fwAddIndent       Ind         Inz;
   Dcl-S    wkIndentCode      Packed(5:0) Inz;
   Dcl-S    wkMaxLevel        Packed(5:0) Inz;
   Dcl-S    wkLastLevel       Packed(5:0) Inz;
   Dcl-S    wkIncrLevel       Packed(5:0) Inz;
   Dcl-S    wkIndex           Packed(5:0) Inz;
   Dcl-S    awIndentLevel     Packed(5:0) Dim(999) Inz;
   Dcl-S    wkIndentValue     Packed(5:0) Inz;                                           //0019
   Dcl-S    wkPseudocode1     Char(cwSrcLength) Inz;                                     //0019
   Dcl-S    IOParmPointer     Pointer     Inz(*Null);                                    //0029
   Dcl-S    wkPipeIndex       Packed(5:0) Inz;                                           //0065
   Dcl-S    wkPipeIndentValue Packed(5:0) Inz;                                           //0065

   //Copybook declaration
/copy 'QCPYSRC/iaprderlog.rpgleinc'

   // Variable initialisation
   wkuDpsds.nbrparms = %parms;                                                           //0030
   EvaluatePSDS() ;                                                                      //0030
   wkIndentType   = IndentParmDS.dsIndentType;
   wkIndentLevel  = IndentParmDS.dsIndentLevel;
   wkPseudocode   = IndentParmDS.dsPseudocode;
   wkMaxLevel     = IndentParmDS.dsMaxLevel;
   wkIncrLevel    = IndentParmDS.dsIncrLevel;
   awIndentLevel  = IndentParmDS.dsIndentArray ;
   fwAddIndent    = False;
   fwRemoveIndent = False;

   //Check if the keyword requires indentation
   If wkIndentType = cwAdd Or
      wkIndentType = cwAddCheck;
      fwAddIndent = True;

      //Make sure the begsr is the start of indentation
      If wkIndentType = cwAddCheck And wkIndentLevel <> *Zeros;
         wkIndentLevel  = *Zeros;
         Clear awIndentLevel;
      EndIf;
   EndIf;

   //Check if the keyword requires Removal of Indentation
   If wkIndentType = cwRemove Or
      wkIndentType = cwRemoveCheck;
      fwRemoveIndent = True;
   EndIf;

   // Remove indentation - Remove should take effect from current Pseudocode statement
   If fwRemoveIndent;
      wkIndentLevel -= 1;
      // Clear the Incremented Indent level in an Array
      For wkIndex = 2  to  990   ;
         If awIndentLevel(wkIndex)  = *Zeros;
            // Get the last incremental indent value to reduce
            wkIncrLevel  = awIndentLevel(wkIndex-1);
            // Clear the value
            awIndentLevel(wkIndex-1) = *Zeros;
            Leave;
         EndIf;
      EndFor;

   EndIf;

   // Make sure the endsr is the end of indentation
   If wkIndentType = cwRemoveCheck And wkIndentLevel <> *Zeros;
      Clear awIndentLevel;
      wkIndentLevel  = *Zeros;
   EndIf;

   // Add the indent level code for the Pseudocode
   wkIndentCode = *Zeros;
   If fwAddIndent;
      wkIncrLevel    = wkMaxLevel + 1;
      wkIndentCode   = wkIncrLevel;
      wkPseudocode  =  'L' + %Editc(wkIndentCode:'X') +
                       ' ' +  %Trim(wkPseudocode);
   EndIf;
   If fwRemoveIndent;
      wkIndentCode   = wkIncrLevel ;
      wkPseudocode  =  'L' + %Editc(wkIndentCode:'X') +
                       ' ' +  %Trim(wkPseudocode);
   EndIf;


   // Add Indentation to the pseudocode as per the indent level calculated
                                                                                         //0019
   wkIndentValue = wkIndentLevel * cw3 ;                                                 //0019
                                                                                         //0019
   If wkIndentValue <= *Zeros;                                                           //0022
      wkIndentValue = 1;                                                                 //0019
   EndIf;                                                                                //0019
                                                                                         //0019
   wkPseudoCode1 = wkPseudoCode ;                                                        //0019
   clear wkPseudoCode;                                                                   //0019
   %subst(wkPseudoCode : wkIndentValue) = wkPseudoCode1;                                 //0019

   wkFX3PipeIndentSave = *Blanks;                                                        //0068
   // Pipe indentation - to Pseudocode statement for lines Between Every Tag(RPG3)      //0065
   If wkIndentLevel <> *Zeros;                                                           //0065
      wkPipeIndentValue = wkIndentValue;                                                 //0065
      For wkPipeIndex = wkIndentLevel  DownTo 1 ;                                        //0065
         wkPipeIndentValue -= cw3;                                                       //0065
         If awIndentLevel(wkPipeIndex) > *Zeros;                                         //0065
            If wkPipeIndentValue <= *Zeros;                                              //0065
               wkPipeIndentValue = 1;                                                    //0065
            EndIf;                                                                       //0065
            %subst(wkPseudoCode : wkPipeIndentValue : 1) = cwPipeIndent;                 //0065
            // Pipe indent is saved globally to access from Other Procedure             //0068
            %subst(wkFX3PipeIndentSave : wkPipeIndentValue : 1) = cwPipeIndent;          //0068
         EndIf;                                                                          //0065
      EndFor;                                                                            //0065
   EndIf;                                                                                //0065

   // Add indentation - add should take effect from the next Pseudocode statement
   If fwAddIndent;
      wkIndentLevel += 1;
      // Store the Incremented Indent level in an Array
      For  wkIndex = 1  to  990  ;
         If awIndentLevel(wkIndex) = *Zeros;
            awIndentLevel(wkIndex) = wkIncrLevel;
            Leave;
         EndIf;
      EndFor;
      // Retain the max indent level
      If wkIncrLevel > wkMaxLevel;
         wkMaxLevel =  wkIncrLevel;
      EndIf;
   EndIf;

   // Return the current indent level , this will be passed again in the next call for re-calcul
   IndentParmDS.dsIndentLevel =  wkIndentLevel;
   IndentParmDS.dsPseudocode  =  wkPseudocode;
   IndentParmDS.dsMaxLevel    =  wkMaxLevel;
   IndentParmDS.dsIncrLevel   =  wkIncrLevel;
   IndentParmDS.dsIndentArray =  awIndentLevel;
   Return;
/copy 'QCPYSRC/iaprcerlog.rpgleinc'
End-Proc;

//------------------------------------------------------------------------------------- //
//Procedure to process nested built in function                                         //
//------------------------------------------------------------------------------------- //
Dcl-Proc ProcessNestedBIF  Export;                                                    //0032 Start

   Dcl-Pi ProcessNestedBIF Ind;
        InSrcDtaBIF       VarChar(cwSrcLength);
        OutBifParmPointer Pointer;
        OutMaxBif         Packed(3:0);
   End-Pi;

   //Datastructure to hold nested Bif
   Dcl-Ds DsNestedBif    Occurs(100) based(OutBifParmPointer);
     wDsBifNumber      Packed(5:0);
     wDsPercentPos     Packed(5:0);
     wDsBifName        Char(10);
     wDsOpenParPos     Packed(5:0);
     wDsCloseParPos    Packed(5:0);
     wDsBifFull        VarChar(200);
     wDsBifMap         VarChar(200);
     wDsBifPseudocode  VarChar(cwSrcLength);
   End-Ds;

   //Declaration of work variables
   Dcl-S  wkSrcDtaBIF          varChar(cwSrcLength) Inz;
   Dcl-S  rcdFound             ind inz('0');
   Dcl-S  wkForIndex           Packed(5:0) ;                                             //0066
   Dcl-S  wkBifIndex           Packed(5:0) ;                                             //0066
   Dcl-S  wkMaxBif             Packed(3:0) ;
   Dcl-S  wkBifNumber          Packed(5:0);                                              //0066
   Dcl-S  wkPos1               Packed(5:0);                                              //0066
   Dcl-S  wkPos2               Packed(5:0);                                              //0066
   Dcl-S  wkSavPos             Packed(5:0);                                              //0066
   Dcl-S  wkSavEndPos          Packed(5:0);                                              //0066
   Dcl-S  wkSubPos             Packed(5:0);                                              //0066
   Dcl-S  wkScanPos            Packed(5:0);                                              //0066
   Dcl-S  wkSubstrLen          Packed(5:0);                                              //0066
   Dcl-S  wkPercentPos         Packed(5:0);                                              //0066
   Dcl-S  wkBifName            Char(10);
   Dcl-S  wkOpenParPos         Packed(5:0);                                              //0066
   Dcl-S  wkCloseParPos        Packed(5:0);                                              //0066
   Dcl-S  wkBif                Char(100)   Inz;
   Dcl-S  wkBifFull            VarChar(cwSrcLength);
   Dcl-S  wkBifMap             VarChar(cwSrcLength);
   Dcl-S  wkRemSrc             VarChar(cwSrcLength);
   Dcl-S  wkArg1               Char(100)   Inz;
   Dcl-S  wkArg2               Char(100)   Inz;
   Dcl-S  wkArg3               Char(100)   Inz;
   Dcl-S  wkBiFDummyName       Char(10);
   Dcl-S  wkDclType            Char(10);
   Dcl-S  wkSrcMap             VarChar(cwSrcLength);
   Dcl-S  wkActionType         Char(10);
   Dcl-S  wkSrcLtyp            Char(5);
   Dcl-S  wkSrcSpec            Char(1);
   Dcl-S  wkBifPseudocode      VarChar(cwSrcLength);
   Dcl-S  wkSimpleBifSrcDta    VarChar(cwSrcLength);
   Dcl-S  wkArg4               Char(100)   Inz;
   Dcl-S  wkArg5               Char(100)   Inz;
   Dcl-S  wk_Var               Char(5);
   Dcl-S  Wk_Pos1              Packed(5:0);                                              //0066
   Dcl-S  Wk_Ind               Packed(5:0);                                              //0066
   Dcl-S  Wk_Spos              Packed(5:0);                                              //0066
   Dcl-S  Wk_PosVar            Packed(5:0);                                              //0066
   Dcl-S  Wk_Pos               Packed(5:0);                                              //0066
   Dcl-S  Wk_Pos3              Packed(5:0);                                              //0066
   Dcl-S  Wk_Pos4              Packed(5:0);                                              //0066
   Dcl-S  Wk_NxtBif            Packed(5:0);                                              //0066
   Dcl-S  Wk_Bifpos            Packed(5:0);                                              //0066
   Dcl-S  Wk_Open              Packed(5:0);                                              //0066
   Dcl-S  Wk_Close             Packed(5:0);                                              //0066
   Dcl-S  Wk_Len               Packed(5:0);                                              //0066
   Dcl-S  wkCloseParFound      Char(1) Inz ;                                             //0093
   Dcl-S  wkChar               Char(1) Inz ;                                             //0093
   Dcl-S  wkPendingOpenPar     Packed(2:0) Inz ;                                         //0093
   Dcl-S  wkCounter            Packed(5:0) Inz ;                                         //0093
                                                                                         //0093
   Dcl-C  cwMaxIter            Const(10);

   //Flags
   Dcl-S  fwBadBIFSrcDta    Ind  Inz ;
   Dcl-S  fwReturnStatus    Ind  Inz ;

      //Nested built in function processing
      wkBIF           = *Blanks;
      fwBadBIFSrcDta  = *Off;
      fwReturnStatus  = *Off;
      wkBifIndex      = *Zeros;
      wkScanPos       = 1 ;
      wkMaxBif        = *Zeros;
      wkSrcLtyp       = 'FFC';
      wkSrcSpec       = 'C';
      wkSrcDtaBIF     = InSrcDtaBIF;
      Clear DsNestedBif;

        //Process for 10 level of nested Built in Functions
        For wkForIndex = 1 to cwMaxIter ;
            //Check if any Built in function exist in this line then process it
            //else leave the loop
            wkPos1  =   %Scan('%' : wkSrcDtaBIF  : wkScanPos);

            If wkPos1 > *Zeros;
              wkPercentPos = wkPos1;
            Else;
              Leave;
            EndIf;

            //Get the Built In Function name for pseudocode
            wkPos2  =   %Scan('(' : wkSrcDtaBIF : wkPos1);
            wkOpenParPos = wkPos2;                                                       //0048
            //Check for built-in functions without brackets                             //0048
            If wkPos2 = *Zeros;                                                          //0048
               wkPos2  =   %Scan(' ' : wkSrcDtaBIF : wkPos1);                            //0048
               wkOpenParPos = 0;                                                         //0048
            EndIf ;                                                                      //0048
            wkSubPos = wkPos1+1 ;
            wkSubstrLen = wkPos2-wkPos1-1 ;
            If wkSubstrLen > *Zeros;
              wkBIF = %Trim(%Subst(wkSrcDtaBIF : wkSubPos : wkSubstrLen));
            EndIf;

           //Convert the built in function name to upper case to fetch mapping
           Monitor;
             wkBIF = %xLate(cwLO:cwUP:wkBIF);
             wkDclType = %Trim(wkBIF) ;
           On-Error;
           EndMon;

           //Get the mapping data for the built in function
           Exsr  GetBIFMappingDataSr;

           If SqlCode = SuccessCode;
             //For below BiFs related to file IOs,skip the new way of BIF processing    //0040
             If wkBIF = 'FOUND'  Or  wkBIF = 'EQUAL' Or  wkBIF = 'EOF' Or                //0040
                wkBIF = 'STATUS' Or  wkBIF = 'ERROR' Or  wkBIF = 'OPEN';                 //0040
                                                                                         //0040
                Clear wkSimpleBIFSrcDta;                                                 //0040
                wkSimpleBIFSrcDta = wkSrcDtaBIF ;                                        //0040
                                                                                         //0040
                Exsr ProcessBifPSeudocodeSr;                                             //0040
                wDsBifPseudocode  = wkBifPseudocode;                                     //0040
                wkSrcDtaBIF  = wkBifPseudocode ;                                         //0040
                Leave ;                                                                  //0040
             EndIf ;                                                                     //0040
             //Store the Built In function detail in the datastructure
             wkBifIndex += 1;
             %Occur(DsNestedBif) = wkBifIndex;
             Clear DsNestedBif;
             wDsBifNumber   = wkBifIndex   ;
             wDsPercentPos  = wkPercentPos ;
             wDsOpenParPos  = wkOpenParPos ;
             wDsBifName     = wkDclType;
             wDsBifMap      = wkSrcMap ;
           Else;
             //If no close parenthesis found then it is a bad Built in Function
             fwBadBIFSrcDta = *On;
             Leave;
           EndIf;

           //Set the new scan position to get the next built in function
           wkScanPos = wkPos2 + 1;
           //Get the max number of Built in function in the source line
           wkMaxBif =  wkBifIndex;
         EndFor;

         //Split the Built in function and populate it in the DS
         For wkForIndex  = wkMaxBif DownTo 1;

            //If there is no bracket for the built-in function proceed with the         //0048
            //new subroutine to create BIF                                              //0048
            If wkOpenParPos = 0 ;                                                        //0048
               wDsBifFull =  %Subst(wkSrcDtaBIF  : wDsPercentPos : wkSubstrLen+1 );      //0048
               Exsr ProcessBIFString;                                                    //0048
               Leave ;                                                                   //0048
            EndIf ;                                                                      //0048

            %Occur(DsNestedBif) = wkForIndex;
            wkPos1  =   %Scan(')' : wkSrcDtaBIF : wDsOpenParPos);
                                                                                         //0093
            If wkPos1 > *Zeros AND %Scan('(' : wkSrcDtaBIF : wDsOpenParPos+1)            //0093
                                       < wkPos1 ;                                        //0093
               wkCloseParFound = 'N' ;                                                   //0093
               wkChar = *Blanks ;                                                        //0093
               wkPendingOpenPar = *Zeros ;                                               //0093
               wkCounter = wDsOpenParPos + 1 ;                                           //0093
               Dow wkCloseParFound = 'N' ;                                               //0093
                  wkChar = %Subst(wkSrcDtaBIF : wkCounter : 1) ;                         //0093
                  Select ;                                                               //0093
                  When wkChar = ')' AND wkPendingOpenPar = *Zeros ;                      //0093
                     wkCloseParFound = 'Y' ;                                             //0093
                     wkPos1 = wkCounter ;                                                //0093
                     Leave ;                                                             //0093
                  When wkChar = ')' AND wkPendingOpenPar > *Zeros ;                      //0093
                     wkPendingOpenPar -= 1 ;                                             //0093
                  When wkChar = '(' ;                                                    //0093
                     wkPendingOpenPar += 1 ;                                             //0093
                  When wkCounter >= %len(%trim(wkSrcDtaBIF)) ;                           //0093
                     wkPos1 = *Zeros ;                                                   //0093
                     Leave ;                                                             //0093
                  EndSl ;                                                                //0093
                  wkCounter += 1 ;                                                       //0093
               Enddo ;                                                                   //0093
            Endif ;                                                                      //0093

            //Get the close parenthesis position from the open parenthesis position
            If wkPos1 > *Zeros;
              wDsCloseParPos  = wkPos1;
            Else;
              //If no close parenthesis found then it is a bad Built in Function
              fwBadBIFSrcDta = *On;
              Leave;
            EndIf;

           //Substring the built in function
           wkSubstrLen  =  wDsCloseParPos - wDsPercentPos+1;
           If wkSubstrLen > *Zeros;
             wDsBifFull =  %Subst(wkSrcDtaBIF  : wDsPercentPos : wkSubstrLen );

             Exsr ProcessBIFString ;                                                     //0048

           EndIf;
         EndFor;

     //If not bad built in function then return success message
     If fwBadBIFSrcDta = *Off;
       Exsr RemoveBrackets ;                                                             //0049
       InSrcDtaBIF     = wkSrcDtaBIF;
       fwReturnStatus  = *On;
       OutMaxBif       = wkMaxBif;
     EndIf;

   Return fwReturnStatus;

//------------------------------------------------------------------------------------- //
//Subroutine To Remove Outer Brackets                                                   //
//------------------------------------------------------------------------------------- //
   Begsr RemoveBrackets ;                                                                //0049Start
     //logic to remove extra outer brackets from the BIF statement
     Wk_Pos3 = 1;
     Wk_Ind = 1 ;
     For Wk_Ind = 1 to cwMaxIter ;
        If Wk_Pos3 < %len(%trimR(wkSrcDtaBIF)) ;
           Wk_BifPos = %Scan('BIF' : wkSrcDtaBIF : Wk_Pos3) ;
           If Wk_BifPos > 0 ;
              Wk_Open = %ScanR( '(':wkSrcDtaBIF:Wk_Pos3:Wk_BifPos-Wk_Pos3 );
              Wk_Close = %Scan( ')' :wkSrcDtaBIF:Wk_BifPos) ;
           Else ;
              Leave ;
           EndIf ;
           Wk_Len = Wk_Close - Wk_Open ;
        Else ;
           Leave ;
        EndIf ;

        If Wk_Len > 0 ;
           Wk_NxtBif = %Scan('BIF' : wkSrcDtaBIF : Wk_BifPos + 3) ;
           If Wk_NxtBif > 0 ;
              Wk_Pos4 = Wk_NxtBif-(Wk_BifPos + 3) ;
           Else ;
              Wk_Pos4 = %len(%trimR(wkSrcDtaBIF)) - (Wk_BifPos + 3) ;
           EndIf ;
           If %Scan('+' :wkSrcDtaBIF : Wk_BifPos :Wk_Len) = 0 and
              %Scan('-' :wkSrcDtaBIF : Wk_BifPos :Wk_Len) = 0 and
              %Scan('*' :wkSrcDtaBIF : Wk_BifPos :Wk_Len) = 0 and
              %Scan('/' :wkSrcDtaBIF : Wk_BifPos :Wk_Len) = 0  ;

               wkSrcDtaBIF = %ScanRpl(')':'' :wkSrcDtaBIF: Wk_BifPos + 3 :Wk_Pos4);
               wkSrcDtaBIF = %ScanRpl('(':'':wkSrcDtaBIF :Wk_Pos3:Wk_BifPos);

           EndIf ;
           If Wk_NxtBif = 0 ;
              Leave ;
           EndIf ;
           Wk_Pos3 = Wk_BifPos + 3 ;
        Else ;
           Leave ;
        EndIf ;
     EndFor ;
  EndSr ;                                                                                //0049End

//------------------------------------------------------------------------------------- //
//Subroutine ProcessBIFString                                                           //
//------------------------------------------------------------------------------------- //
   Begsr ProcessBIFString ;                                                              //0048Start


     //Dummy name for the Built In Function
     wkBiFDummyName = 'BIF' + %Trim(%Char(wkForIndex));
     //Replace the extracted BIF with the dummy name
     wkSrcDtaBIF = %Scanrpl( %Trim(wDsBifFull) : %Trim(wkBiFDummyName)
                                      :  wkSrcDtaBIF : wDsPercentPos );

     //Use where to represent the  extracted BIF with the dummy name
     wDsBifFull =  'Where, ' + %Trim(wkBiFDummyName) + ' = ' +
                               wDsBifFull ;

     //Create pseudocode for the simple Bif that was splited
     Clear wkSimpleBIFSrcDta;
     wkSimpleBIFSrcDta = wDsBifFull;
     wkSrcMap          = wDsBifMap;
     Exsr ProcessBifPSeudocodeSr;
     wDsBifPseudocode  = wkBifPseudocode;
   EndSr ;                                                                               //0048-end
//------------------------------------------------------------------------------------- //
//Subroutine GetBIFMappingDataSr - Get the mapping data from IaPseudoMP                 //
//------------------------------------------------------------------------------------- //
   Begsr GetBIFMappingDataSr;

      //Check in mapping file if the declaration type exist with mapping

      Exec Sql
           Select
                   iAActType,
                   iASrcMap
           Into
                   :wkActionType,
                   :wkSrcMap
           From IaPseudoMP
           Where iASrcLTyp  = :wkSrcLtyp
              and iASrcSpec = :wkSrcSpec
              and iAKeyFld1 = :wkDclType;

           If SqlCode < SuccessCode;
              uDpsds.wkQuery_Name = 'Select_IaPseudoMP';
            //AiSqlDiagnostic(uDpsds);
              IaSqlDiagnostic(uDpsds);
           EndIf;
   Endsr;

//------------------------------------------------------------------------------------- //
//Subroutine ProcessBifPSeudocodeSr - Parse the Bif and form pseudocode for it          //
//------------------------------------------------------------------------------------- //
   Begsr ProcessBifPSeudocodeSr;
            wkBIF  = *Blanks;
            wkArg1 = *Blanks;
            wkArg2 = *Blanks;
            wkArg3 = *Blanks;
            wkArg4 = *Blanks;
            wkArg5 = *Blanks;
            wkBifPseudocode = *Blanks;

            //Back up the start posistion of BIF, to get the pseudocode before it
            wkPos1   = %Scan('%' : wkSimpleBIFSrcDta : 1);
          //Check if wkPos1 is >0 to perform next scan operation to handle 0 scenario
            If wkPos1 > *Zeros ;                                                         //0035
               wkSavPos = wkPos1;                                                        //0035
               wkPos1   = %Scan('(' : wkSimpleBIFSrcDta : wkPos1);                       //0035
              //if valid BIF -it may/may not have brackets.
              If WkPos1  =  *Zeros;
                 WkPos1  =  %Scan(' ' : wkSimpleBIFSrcDta : wkSavPos);
              Endif;
            Endif ;                                                                      //0035
            wkSavEndPos = *Zeros;

            //If % and Open Parenthesis found , proceed for parsing
            If wkSavPos > *Zeros And wkPos1 > *Zeros;

              //Subroutine to Check the built in function present in the string,
              //Replace the keyword '&Var' in mapping file with actual parameters

               Exsr WriteMapping_Sr ;

               wkPos1 = %Len(%TrimR(wkSimpleBIFSrcDta)) - wkSavEndPos  ;
               wkRemSrc = *Blanks;
               If wkPos1 > 1 And wkSavEndPos > *Zeros;
                 //Get the remaining statement ie., source after the built in function as well
                 wkRemSrc  =
                 %Subst(wkSimpleBIFSrcDta : (wkSavEndPos + 1) : wkPos1);
               EndIf;
               //Pseudocode with the built in function mapping
               wkBifPseudocode  = %Subst(wkSimpleBIFSrcDta : 1 : (wkSavPos-1)) +
                              ' ' + %Trim(wkSrcMap) + ' ' + %Trim(wkRemSrc);
            EndIf;

  Endsr;

//------------------------------------------------------------------------------------- //
//Subroutine to Check the built in function present in the string,                      //
//Replace the keyword '&Var' in mapping file with actual parameters                     //
//------------------------------------------------------------------------------------- //
  BegSr WriteMapping_Sr  ;

     Clear wkPos2 ;

     For Wk_Ind = 1 to cwMaxIter ;

        Wk_Var = '&Var' ;
        Wk_Var = %trim(Wk_Var) + %Char(Wk_Ind) ;

        //If &Var exist in mapping get the BIF Argument value

        If %Scan( Wk_Var : wkSrcMap  : 1) > *Zeros;

           If Wk_Ind = 1 ;
              wkPos1 += 1;
           Else ;
              wkPos1 = wkPos2+1;
           EndIf ;

           //Make sure scan is within the length of the source data

           If wkPos1 < %Len(%TrimR(wkSimpleBIFSrcDta));
              //Check for the Argument string, search for the ':' after                 //0047
              //argument                                                                //0047
              If %Scan('"' : wkSimpleBIFSrcDta : wkPos1) > 0 ;                           //0047
                 wk_Pos = %Scan('"' : wkSimpleBIFSrcDta : wkPos1) ;                      //0047
                 wk_Pos = %Scan('"' : wkSimpleBIFSrcDta : wkPos1+1 ) ;                   //0047
              Else ;                                                                     //0047
                 wk_Pos = wkPos1 ;                                                       //0047
              EndIf ;                                                                    //0047
              If wk_Pos > 0 ;                                                            //0047
                 wkPos2 = %Scan(':' : wkSimpleBIFSrcDta : wk_Pos);                       //0047
              EndIf ;                                                                    //0047
           Else;
              wkPos1 = %Len(%TrimR(wkSimpleBIFSrcDta)) ;
           EndIf;

           If wkPos2 - wkPos1 > *Zeros and wkPos1 > *Zeros;

              wkArg1 = %Trim(%Subst(wkSimpleBIFSrcDta  : wkPos1
                                             : (wkPos2-wkPos1)));
              //Expand abbreviations like *H>*HOURS if applicable                       //0098
              If (WkDclType =  'DIFF'  And  Wk_var = '&Var3') Or                         //0098
                 (WkDclType =  'SUBDT' And  Wk_var = '&Var2');                           //0098
                 Exsr ExpandAbbreviations;                                               //0098
              Endif;                                                                     //0098
              wkSrcMap  = %ScanRpl(Wk_Var:%Trim(wkArg1):wkSrcMap );
           Else;
              //If no more arguments then get the end position
              wkPos2 = %ScanR(')' : wkSimpleBIFSrcDta : wkPos1);                         //0047
              If wkPos2 - wkPos1 > *Zeros and wkPos1 > *Zeros;
                 wkArg1 = %Subst(wkSimpleBIFSrcDta  : wkPos1
                                         : (wkPos2-wkPos1));
                 //Expand abbreviations like *H>*HOURS if applicable                    //0098
                 If (WkDclType =  'DIFF'  And  Wk_var = '&Var3') Or                      //0098
                    (WkDclType =  'SUBDT' And  Wk_var = '&Var2');                        //0098
                    Exsr ExpandAbbreviations;                                            //0098
                 Endif;                                                                  //0098
                                                                                         //0098
                 Wk_PosVar = %Scan(Wk_Var : wkSrcMap) ;                                  //0047
                 wkSrcMap  = %ScanRpl(Wk_Var:%Trim(wkArg1):wkSrcMap);
                 wkSavEndPos = wkPos2;
              Else ;
                //If no more arguments present take the substring upto last argument
                 If wkArg1 <> *Blanks ;
                    If Wk_PosVar > 0 ;                                                   //0047
                       Wk_Pos1 = %Scan(%trim(wkArg1):wkSrcMap:Wk_PosVar) ;               //0047
                       Wk_Pos1 =  Wk_Pos1 + %len(%trim(wkArg1)) - 1 ;
                       wkSrcMap  = %Subst( wkSrcMap :1 :Wk_Pos1);                        //0047
                    EndIf ;
                    Leave ;
                 Else ;
                    Wk_Pos1 = %Scan( Wk_Var : wkSrcMap  : 1) ;
                    If Wk_Pos1 > 1 ;                                                     //0047
                       wkSrcMap  = %Subst( wkSrcMap :1 :Wk_Pos1-1);
                       wkSavEndPos = wkPos1;                                             //0086
                    EndIf ;                                                              //0047
                    Leave ;
                 EndIf ;
              EndIf ;
           EndIf ;
        Else ;
           Leave ;
        EndIf ;
     EndFor ;
  EndSr ;
  //----------------------------------------------------------------------------------- //0098
  //Expand the abbreviation used in date/time BIFS                                      //0098
  //----------------------------------------------------------------------------------- //0098
  Begsr ExpandAbbreviations;                                                             //0098
     wkArg1  =  %Trim(wkArg1);                                                           //0098
     Select;                                                                             //0098
        When WkArg1  =  '*Y';                                                            //0098
             WkArg1  =  'YEARS';                                                         //0098
        When WkArg1  =  '*M';                                                            //0098
             WkArg1  =  'MONTHS';                                                        //0098
        When WkArg1  =  '*D';                                                            //0098
             WkArg1  =  'DAYS';                                                          //0098
        When WkArg1  =  '*H';                                                            //0098
             WkArg1  =  'HOURS';                                                         //0098
        When WkArg1  =  '*MN';                                                           //0098
             WkArg1  =  'MINUTES';                                                       //0098
        When WkArg1  =  '*S';                                                            //0098
             WkArg1  =  'SECONDS';                                                       //0098
        When WkArg1  =  '*MS';                                                           //0098
             WkArg1  =  'MILI-SEC';                                                      //0098
     Endsl;                                                                              //0098
     WkArg1  =  %Scanrpl('*' : ' ' : WkArg1);                                            //0098
     WkArg1  =  %Scanrpl('  ' : ' ' : WkArg1);                                           //0098
                                                                                         //0098
  Endsr;                                                                                 //0098
End-Proc;                                                                                //0032 END




//------------------------------------------------------------------------------------- //
//Procedure to parser the H - Spec source to Pseudocode                                 //
//------------------------------------------------------------------------------------- //

Dcl-Proc IAHSpecPseudocodeParser Export;

   Dcl-Pi IAHSpecPseudocodeParser ;
      inHSpecParmPointer Pointer;
   End-Pi;

   // Declaration of datastructure
   // H Spec Parser Parameter datastructure
   Dcl-Ds inHSpecParmDS  Qualified Based(inHSpecParmPointer);
      inReqId        Char(18);
      inSrcLib       Char(10);
      inSrcPf        Char(10);
      inSrcMbr       Char(10);
      insrcType      Char(10);
      inSrcRrn       Packed(6:0);
      inSrcSeq       Packed(6:2);
      inSrcLtyp      Char(5);
      inSrcSpec      Char(1);
      inSrcLnct      Char(1);
      inSrcDta       VarChar(cwSrcLength);
      inIndentLevel  Packed(5:0);
      inMaxLevel     Packed(5:0);
      inIncrLevel    Packed(5:0);
      inIndentArray  Packed(5:0) Dim(999);
      inDclType      Char(10);
      inSubType      Char(10);
      inhCmtReqd     Char(1);
   End-Ds;

   //Declaration of work variables
   Dcl-S  wkPseudoCode                Char(cwSrcLength) Inz;
   Dcl-S  wkSrcType                   Char(10);
   Dcl-S  wkHSpecKeyword              Char(30);
   Dcl-S  wkSrcDta                    VarChar(cwSrcLength) Inz;
   Dcl-S  wkHSpecMapping              Char(200);
   Dcl-S  IOParmPointer               Pointer Inz(*Null);
   Dcl-S  wkExit                      Ind;
   Dcl-S  wkStrPos                    Packed(2:0) Inz;
   Dcl-S  wkEndPos                    Packed(2:0) Inz;
   Dcl-S  wkSubstrLen                 Packed(2:0) Inz;
   Dcl-S  wkStrMaxLen                 Packed(2:0) Inz;
   Dcl-S  wkSubChar                   Char(1) Inz;
   Dcl-S  wkSrcSpec                   Char(1) Inz;
   Dcl-S  wkKeywordParameter          VarChar(500) Inz;
   Dcl-S  wkHspecKeywordMapppingFound Ind;

   //Copybook declaration
/copy 'QCPYSRC/iaprderlog.rpgleinc'

   // Initialise the variables
   wkuDpsds.nbrparms = %parms;                                                           //0030
   EvaluatePSDS() ;                                                                      //0030
   Exsr Initialise;

   //Process in a loop , to parse the Hspec keywords and to generate Pseudocode
   Dow Not wkExit;
     //Get the End Postition
     If wkStrPos > *Zeros;                                                               //0002
        wkEndPos   = %Check(cwAto9 : wkSrcDta : wkStrPos);
     EndIf;                                                                              //0002
     If wkEndPos = *Zeros And wkStrPos < wkStrMaxLen;
      wkEndPos = wkStrMaxLen+1;
     EndIf;
     If wkEndPos > *Zeros;
       wkSubstrLen = wkEndPos - wkStrPos;
     EndIf;
     //Get the H Spec keyword
     If wkStrPos > *Zeros And wkSubstrLen > *Zeros;
        wkHSpecKeyword = %Trim(%Subst(wkSrcDta : wkStrPos : wkSubstrLen));
        wkHSpecKeyword = %xLate(cwLO:cwUP:wkHSpecKeyword);

        //Get the mapping for the keyword
        Exec Sql
          Select iASrcMap  Into  :wkHSpecMapping
          From IaPseudoMP
          Where iASrcMTyp   = :wkSrcType
          And iASrcSpec     = :inHSpecParmDS.inSrcSpec
          And iAKeyFld1     = :wkHSpecKeyword;

       If SqlCode < SuccessCode;
          uDpsds.wkQuery_Name = 'Select_IaPseudoMP';
          IaSqlDiagnostic(uDpsds);
       EndIf;

       If SqlCode = SuccessCode;
         wkHspecKeywordMapppingFound = True;
       EndIf;
     EndIf;

     If wkHspecKeywordMapppingFound;
       //If the mapping found for the H spec keyword, form the pseudocode
       wkPseudocode = %Trim(wkHSpecMapping);

       //Determine what next after the keyword- parameters, more keywords
       wkStrPos  = wkEndPos ;

       //If end of the source data then exit the loop
       If wkStrPos >= wkStrMaxLen;
         wkExit  = True;
       Else;
         wkSubstrLen = 1;
         wkSubChar = %Subst(wkSrcDta : wkStrPos : wkSubstrLen);

         //If blanks , then check if there are more H spec keyword in the source data
         If wkSubChar = ' ';
           wkStrPos  = %Check(' ' : wkSrcDta : wkStrPos);
           //After blanks check if there are any posibility of parameter eg keyword (..)
           wkSubstrLen = 1;
           If wkStrPos > *Zeros;                                                        //0002
              wkSubChar = %Subst(wkSrcDta : wkStrPos : wkSubstrLen);
           EndIf;                                                                       //0002
         EndIf;
         //Get the parameter for the keyword if (...) exist
         If wkSubChar = '(';
           //Look for the end of parameter
           wkEndPos  =  %Scan( ')' : wkSrcDta : wkStrPos);
          If wkEndPos > *Zeros;                                                          //0002
           //If the end of paranthesis found
           wkStrPos  =  wkStrPos+1;
           wkSubstrLen  = wkEndPos - wkStrPos ;
           //Get the keyword parameter
           If wkStrPos > *Zeros And wkSubstrLen > *Zeros And
             wkEndPos <= wkStrMaxLen;
             wkKeywordParameter = %Subst(wkSrcDta : wkStrPos : wkSubstrLen);
             wkKeywordParameter = %Scanrpl(':' : ', ' : wkKeywordParameter);
           EndIf;
           //Concat the Pseudocode mapping with the keyword parameters
           wkPseudocode = %Trim(wkPseudocode) + ' ' + %Trim(wkKeywordParameter);
          Else;                                                                          //0002
             //If the end of paranthesis Not found, its bad source,
             //skip this  and traverse to find the next valid keyword
             wkEndPos   = wkStrPos +1;                                                   //0002
          EndIf;                                                                         //0002

           wkStrPos     = wkEndPos + 1;
           //Check if the end of the srouce data Else check for more keywords
           If wkStrPos >= wkStrMaxLen;
             wkExit  = True;
           Else;
             wkSubstrLen = 1;
             wkSubChar = %Subst(wkSrcDta : wkStrPos : wkSubstrLen);
             //If blanks , then check if there are more H spec keyword in the source data
             If wkSubChar = ' ' And wkStrPos > *Zeros;                                   //0002
              wkStrPos  = %Check(' ' : wkSrcDta : wkStrPos);
             EndIf;
           EndIf;
         EndIf;

       EndIf;

       //Write the H Spec Pseudocode
       Exsr WriteHSpecPseudocode ;

     Else;

       //Mapping not found for the keyword, go on the next keyword
       wkStrPos  = wkEndPos + 1;
     EndIf;

     //If end of the source data then exit the loop
     If wkStrPos >= wkStrMaxLen;
       wkExit  = True;
     EndIf;

     wkHspecKeywordMapppingFound = False;
     wkKeywordParameter          = *Blanks;
     wkHSpecKeyword              = *Blanks;
   EndDo;

   Return;

//------------------------------------------------------------------------------------- //
//Initialise - Initialise the work variables                                            //
//------------------------------------------------------------------------------------- //
   Begsr Initialise;
     wkSrcDta                    =  %TrimL(inHSpecParmDS.inSrcDta);
     wkSrcSpec                   =  inHSpecParmDS.inSrcSpec;
     wkSrcType                   =  'RPGLE';
     OutParmWriteSrcDocDS        =  inHSpecParmDS;
     wkStrMaxLen                 =  %Len(%Trim(wkSrcDta));
     wkStrPos                    =  1;
     wkExit                      =  False;
     wkHspecKeywordMapppingFound =  False;
     wkKeywordParameter          = *Blanks;
     wkHSpecKeyword              = *Blanks;
   Endsr;

//------------------------------------------------------------------------------------- //
//WriteHSpecPseudocode - Subroutine to write H Spec Pseudocode                          //
//------------------------------------------------------------------------------------- //
   Begsr WriteHSpecPseudocode;
      OutParmWriteSrcDocDS.dsPseudocode = %Trim(wkPseudocode);
      ioParmPointer  = %Addr(OutParmWriteSrcDocDS);
      WritePseudoCode(ioParmPointer);
   Endsr;

/copy 'QCPYSRC/iaprcerlog.rpgleinc'
End-Proc;

//------------------------------------------------------------------------------------- //
//Procedure to write copy book declaration in IAPSEUDOCP                                //
//------------------------------------------------------------------------------------- //
Dcl-Proc IaCopyBookDclParser Export;

   Dcl-Pi IaCopyBookDclParser;
      inMbrDetails  Pointer;
      insrcData     VarChar(cwSrcLength);
      inFileType    Char(1) Options(*NoPass) Const;                                      //0068
   End-Pi;

   Dcl-Ds mbrDetailsDs Based(inMbrDetails);
      inReqId        Char(18);
      inSrcLib       Char(10);
      inSrcPf        Char(10);
      inSrcMbr       Char(10);
      inSrcType      Char(10);
      inSrcRrn       Packed(6:0);                                                        //0007
      inSrcSeq       Packed(6:2);                                                        //0007
      inSrcLtyp      Char(5);                                                            //0007
   End-Ds;

   Dcl-S outParmPointer  Pointer Inz;
   Dcl-S wkSrcDataUpper  Like(insrcData);
   Dcl-S wkDclPos        Zoned(4:0);
   Dcl-S wkPseudoDocSeq  Packed(6:0) Inz;                                                //0068
   Dcl-S wkFX3Pipelength Zoned(4:0) Inz;                                                 //0068
   Dcl-S wkKPseudoCode   Char(cwSrcLength) Inz;                                          //0068

   //Copybook declaration
/copy 'QCPYSRC/iaprderlog.rpgleinc'

   wkuDpsds.nbrparms = %parms;                                                           //0030
   EvaluatePSDS() ;                                                                      //0030
   wkCspecBlankInd = *off;                                                               //0057
   Clear writePseudoCodeDs.pseudoCode;
   wkSrcDataUpper = %Xlate(cwLo:cwUp:insrcData);

   //Check copy book is declared using /COPY or /INCLUDE and fetch its details
   Select;
      When %Scan('/COPY ':wkSrcDataUpper:1) > *Zeros;
         wkDclPos = %Scan('/COPY ':wkSrcDataUpper:1);
         writePseudoCodeDs.pseudoCode =  %Subst(inSrcData:wkDclPos + 6);
      When %Scan('/INCLUDE ':wkSrcDataUpper:1) > *Zeros;
         wkDclPos = %Scan('/INCLUDE ':wkSrcDataUpper:1);
         writePseudoCodeDs.pseudoCode =  %Subst(inSrcData:wkDclPos + 9);
   EndSl;

   //If the declaration is valid then write the pseudo code
   If writePseudoCodeDs.pseudoCode <> *Blanks;

      If %Scan(',':wkSrcDataUpper:1) > *Zeros;
         writePseudoCodeDs.pseudoCode = %ScanRpl(',': ', ': writePseudoCodeDs.pseudoCode);
      EndIf;

      writePseudoCodeDs.reqId   = inReqId;
      writePseudoCodeDs.srcLib  = inSrcLib;
      writePseudoCodeDs.srcPf   = inSrcPf;
      writePseudoCodeDs.srcMbr  = inSrcMbr;
      writePseudoCodeDs.srcType = inSrcType;
      writePseudoCodeDs.SrcRrn  = inSrcRrn;
      writePseudoCodeDs.SrcSeq  = inSrcSeq;
      writePseudoCodeDs.SrcLTyp = inSrcLtyp;
      writePseudoCodeDs.srcSpec = 'K';

      //Write the Pseudo code
      //Write to IAPSEUDOCP if Less than 2 Parm is passed and not RPG3 Kspec            //0068
      If %Parms < 3;                                                                     //0068
         outParmPointer = %Addr(writePseudoCodeDs);                                      //0068
         WritePseudoCode(outParmPointer);                                                //0068
      Else;                                                                              //0068
         //Write to IAPSEUDOWK if RPG3 Kspec and Kspec is Inbetween Cspec               //0068
         If inFileType ='W' and (insrcType = 'RPG' or insrcType = 'SQLRPG' );            //0068
                                                                                         //0068
            //Append Pipe Indent from saved global variable to Pseudo                   //0068
            If %trim(wkFX3PipeIndentSave) <> *Blanks;                                    //0068
               wkFX3Pipelength = %len(%trim(wkFX3PipeIndentSave));                       //0068
               wkKPseudoCode   = writePseudoCodeDs.PseudoCode ;                          //0068
               Clear writePseudoCodeDs.pseudoCode;                                       //0068
                                                                                         //0068
               //Apply Indent and Append Pipe to Pseudo                                 //0068
               If wkFX3Pipelength = 1;                                                   //0068
                  %subst(writePseudoCodeDs.PseudoCode : wkFX3Pipelength + 2) =           //0068
                  wkKPseudoCode;                                                         //0068
               Else;                                                                     //0068
                  %subst(writePseudoCodeDs.PseudoCode : wkFX3Pipelength + 3) =           //0068
                  wkKPseudoCode;                                                         //0068
               EndIf;                                                                    //0068
               %subst(writePseudoCodeDs.PseudoCode : 1 : wkFX3Pipelength) =              //0068
               %trim(wkFX3PipeIndentSave);                                               //0068
                                                                                         //0068
            EndIf;                                                                       //0068
                                                                                         //0068
            //Get Last sequence number from IAPSEUDOWK File for ReqID                   //0068
            Exec Sql                                                                     //0068
               Select COALESCE(Max(wkDocSeq),0) into :wkPseudoDocSeq                     //0068
               from IaPseudowk Where wkReqId = :inReqId ;                                //0068
                                                                                         //0068
            //Write Pseudo in IAPSEUDOWK file                                           //0068
            outParmPointer = %Addr(writePseudoCodeDs);                                   //0068
            WriteIaPseudowk(OutParmPointer : wkPseudoDocSeq : ' ');                      //0068
            //Write Blank line after copybook code                                      //0072
            wkDclPos = %Check(' |' : writePseudoCodeDs.PseudoCode) ;                     //0072
                                                                                         //0072
            If wkDclPos > *Zeros ;                                                       //0072
               writePseudoCodeDs.PseudoCode =                                            //0072
                     %subst(writePseudoCodeDs.PseudoCode : 1 : wkDclPos-1) ;             //0072
            Else ;                                                                       //0072
               writePseudoCodeDs.PseudoCode = *Blanks ;                                  //0072
            Endif ;                                                                      //0072
                                                                                         //0072
            outParmPointer = %Addr(writePseudoCodeDs);                                   //0072
            WriteIaPseudowk(OutParmPointer : wkPseudoDocSeq : ' ');                      //0072
         Else;                                                                           //0068
            //Write to IAPSEUDOCP if RPG3 Kspec is before start of Cspec                //0068
            outParmPointer = %Addr(writePseudoCodeDs);                                   //0068
            WritePseudoCode(OutParmPointer);                                             //0068
         EndIf;                                                                          //0068
      EndIf;                                                                             //0068
      //Clear previous dcl type to allow header printing for D spec                     //0073
      Clear wkPrevDclType;                                                               //0073
   EndIf;

/copy 'QCPYSRC/iaprcerlog.rpgleinc'
End-Proc IaCopyBookDclParser;

//------------------------------------------------------------------------------------- //
//Procedure to update Pseudocode generation request status in IAFDWNREQ - Export file   //
//------------------------------------------------------------------------------------- //
Dcl-Proc IARequestStatusUpdate  Export;

   Dcl-Pi IARequestStatusUpdate ;
      ioRequestID    Char(18) ;
      ioLibName      Char(10) ;                                                          //0017
      ioSrcFile      Char(10) ;                                                          //0017
      ioMemName      Char(10) ;                                                          //0017
      ioMemType      Char(10) ;                                                          //0017
   End-Pi;

   //Work Variable declaration
   Dcl-S  wkRequestID  Int(20);
   Dcl-S  wkCount      Packed(5:0);
   Dcl-S  wkRequestSts Char(1) ;

   //Copybook declaration
/copy 'QCPYSRC/iaprderlog.rpgleinc'

   wkuDpsds.nbrparms = %parms;                                                           //0030
   EvaluatePSDS() ;                                                                      //0030
   //Convert the request iD to decimal
    wkRequestID  = %Int(ioRequestID);

   //Check the count of the Pseudocode record populated for the request ID
   Exec Sql
     Select Count(*) Into :wkCount
       From IAPSEUDOCP
       Where IaREQID = :wkRequestID and
             IAMBRLIB  = :ioLibName and                                                  //0017
             IASRCFILE = :ioSrcFile and                                                  //0017
             IAMBRNAM  = :ioMemName ;                                                    //0017

   If SqlCode < SuccessCode;
      uDpsds.wkQuery_Name = 'Select_IAPSEUDOCP';
       IaSqlDiagnostic(uDpsds);
   EndIf;

   //First 8 line for the request would be header and if any data more that then
   If wkCount > 0;
      //Update the Request status in iAFDwnDtlP as Pseudocode Generated
      wkRequestSts  = 'G';
   Else;
      wkRequestSts  = 'F';
   EndIf;

   Exec Sql
     Update iAFDwnDtlP Set iAReqstS = :wkRequestSts
     Where IaReqID  = :wkRequestID and
           IaLibName = :ioLibName and                                                    //0017
           IaSrcFile = :ioSrcFile and                                                    //0017
           IaMemName = :ioMemName and                                                    //0017
           IaMemType = :ioMemType;                                                       //0017

   If SqlCode < SuccessCode;
      uDpsds.wkQuery_Name = 'Update_iAFDwnDtlP';
      IaSqlDiagnostic(uDpsds);
   EndIf;

   Return;
/copy 'QCPYSRC/iaprcerlog.rpgleinc'
End-Proc;

//------------------------------------------------------------------------------------- //
//Procedure to Load f spec and d spec Mapping DS                                        //
//------------------------------------------------------------------------------------- //

Dcl-Proc GetSpecSrcMapping Export ;

    Dcl-Pi GetSpecSrcMapping  ;
       inSrcLinType   Char(5);
       inSourceSpec   Char(1) ;
    End-Pi ;

    //Data Structure (Without key) to retrieve data from IAPSEUDOMP file                //0028
    Dcl-Ds iAPSeudoMPNoKeyDS Qualified Dim(9999);                                        //0028
       iASrcLtyp          Char(5)    ;                                                   //0028
       iASrcSpec          Char(1)    ;                                                   //0028
       iAKeyFld1          Char(10)   ;                                                   //0028
       iAKeyFld2          Char(10)   ;                                                   //0028
       iAKeyFld3          Char(10)   ;                                                   //0028
       iAKeyFld4          Char(10)   ;                                                   //0028
       iASeqNo            Zoned(2:0) ;                                                   //0028
       iAIndntTy          Char(10)   ;                                                   //0028
       iASubSChr          Char(10)   ;                                                   //0028
       iAActType          Char(10)   ;                                                   //0028
       iACmtDesc          Char(100)  ;                                                   //0028
       iASrhFld1          Char(10)   ;                                                   //0028
       iASrhFld2          Char(10)   ;                                                   //0028
       iASrhFld3          Char(10)   ;                                                   //0028
       iASrhFld4          Char(10)   ;                                                   //0028
       iASrcMap        Varchar(200)  ;                                                   //0028
    End-Ds ;                                                                             //0028
    Dcl-Ds DswkFileOpCodes Qualified Dim(99) Inz;                                        //0062
      OpCode   Char(10);                                                                 //0062
    End-Ds;                                                                              //0062

    Dcl-S wkArrElem  Uns(5)  Inz;
    Dcl-S RowNum Packed(4:0) ;

   //Copybook declaration
/copy 'QCPYSRC/iaprderlog.rpgleinc'
   wkuDpsds.nbrparms = %parms;                                                           //0030
   EvaluatePSDS() ;                                                                      //0030

   If inSourceSpec = 'A';                                                                //0028
      //For all specs, load mapping data from IAPSEUDOMP to iAPSeudopMPDs               //0028
      Clear iAPSeudoMpDs ;                                                               //0028
      Clear iAPSeudoMPNoKeyDS;                                                           //0028
      Clear wkiAPseudoMpCount;                                                           //0028
      Clear dsFileOperationInd;                                                          //0061
      Exec Sql                                                                           //0028
         Declare MappingDataCursorASpec Cursor for                                       //0028
            Select iASrcLtyp, iASrcSpec, iAKeyFld1, iAKeyFld2, iAKeyFld3,                //0028
                   iAKeyfld4, iASeqNo,   iAIndntTy, iASubSChr, iAActType,                //0028
                   iACmtDesc, iASrhFld1,iASrhFld2, iASrhFld3, iASrhFld4, iASrcMap        //0028
              From iAPseudoMp                                                            //0028
             Where (iASrcMtyp = 'RPGLE' or iASrcMtyp = 'SQLRPGLE') and                   //0028
                   iASrcLtyp <> ' ' and iAKeyFld1 <> 'HEADER'                            //0028
             Order by iASrcLtyp,iAKeyFld1,iAKeyFld2,iAKeyFld3,iASeqNo                    //0028
             For Fetch Only;                                                             //0028
      wkArrElem = %Elem(iAPSeudoMPNoKeyDS);                                              //0028

      Exec Sql Open MappingDataCursorASpec;                                              //0028

      If SqlCode = Csr_Opn_Cod;                                                          //0028
         Exec Sql Close MappingDataCursorASpec;                                          //0028
         Exec Sql Open MappingDataCursorASpec;                                           //0028
      EndIf;                                                                             //0028

      If SqlCode < SuccessCode;                                                          //0028
         uDpsds.wkQuery_Name = 'Open_MappingDataCursorASpec';                            //0028
         IaSqlDiagnostic(uDpsds);                                                        //0028
      EndIf;                                                                             //0028

      If Sqlcode = successCode;                                                          //0028
         Exec Sql                                                                        //0028
            Fetch MappingDataCursorASpec For :wKArrElem  Rows                            //0028
            Into :iAPSeudoMPNoKeyDS;                                                     //0028

            For Rownum=1 To SQLER3;                                                      //0028
                Eval-Corr iAPSeudoMpDs(RowNum)= iAPSeudoMPNoKeyDS(RowNum);               //0028
            EndFor;                                                                      //0028
        wkiAPseudoMpCount = SQLER3;                                                      //0062
      EndIf;                                                                             //0028

      Exec Sql Close MappingDataCursorASpec;                                             //0028
                                                                                         //0053
      //Retrieve and store comment to be printed for the case there is no executable    //0053
      //code found in a condition/loop/subroutine/procedure                             //0053
      Exec Sql Select TRIM(Src_Mapping) into :wkDoNothingComment from IaPseudoKp         //0053
            Where Srcmbr_Type    = 'RPGLE' and Keyword_Opcode = 'DONOTHING';             //0053
                                                                                         //0053
      // Retrieve and store comment to be printed for file operation indicator           //0061
      Exec Sql Select TRIM(Src_Mapping) into :wkIfRecordFound    from IaPseudoKp         //0061
            Where Srcmbr_Type    = 'RPGLE' and Keyword_Opcode = 'IFRCDFND' ;             //0061
                                                                                         //0061
      Exec Sql Select TRIM(Src_Mapping) into :wkIfRecordNotFound from IaPseudoKp         //0061
            Where Srcmbr_Type    = 'RPGLE' and Keyword_Opcode = 'IFRCDNTFND' ;           //0061
                                                                                         //0061
      Exec Sql Select TRIM(Src_Mapping) into :wkRecordFound      from IaPseudoKp         //0061
            Where Srcmbr_Type    = 'RPGLE' and Keyword_Opcode = 'RCDFND'   ;             //0061
                                                                                         //0061
      Exec Sql Select TRIM(Src_Mapping) into :wkRecordNotFound   from IaPseudoKp         //0061
            Where Srcmbr_Type    = 'RPGLE' and Keyword_Opcode = 'RCDNTFND'   ;           //0061
                                                                                         //0061
      //Load the opcodes to DS array which are related to file operations                //0062
      Clear DsFileRelatedOpCodes;                                                        //0062
      Clear DswkFileOpCodes;                                                             //0062
      Exec Sql                                                                           //0062
         Declare GetFileOpCodes Cursor for                                               //0062
            Select iAKwdOpc from iAPseudoKP                                              //0062
             Where iASrcMtyp = 'RPGLE' and iASrcsExtn = 'FILEOPCODE'                     //0062
             For Fetch Only;                                                             //0062
      wkArrElem = %Elem(DswkFileOpCodes);                                                //0062

      Exec Sql Open GetFileOpCodes;                                                      //0062

      If SqlCode = Csr_Opn_Cod;                                                          //0062
         Exec Sql Close GetFileOpCodes;                                                  //0062
         Exec Sql Open GetFileOpCodes;                                                   //0062
      EndIf;                                                                             //0062

      If SqlCode < SuccessCode;                                                          //0062
         uDpsds.wkQuery_Name = 'Open_GetFileOpCodes';                                    //0062
         IaSqlDiagnostic(uDpsds);                                                        //0062
      EndIf;                                                                             //0062

      If Sqlcode = successCode;                                                          //0062
         Exec Sql                                                                        //0062
            Fetch GetFileOpCodes For :wKArrElem  Rows                                    //0062
            Into :DswkFileOpCodes;                                                       //0062
         For Rownum=1 To SQLER3;                                                         //0062
            DsFileRelatedOpCodes.OpCode(RowNum)= DswkFileOpCodes(RowNum).OpCode;         //0062
         EndFor;                                                                         //0062
         DsFileRelatedOpCodes.Count = SQLER3;                                            //0062
      EndIf;                                                                             //0062
      Exec Sql Close GetFileOpCodes;                                                     //0062

   Else;                                                                                 //0028
      Exec Sql
         Declare MappingDataCursor Cursor For
            Select KEYWORD_OPCODE, ACTION_TYPE, SRC_MAPPING
            From IAPSEUDOKP
            Where  SrcLin_Type = :inSrcLinType
            And  Source_Spec = :inSourceSpec
            For Fetch Only;

      Exec Sql Open MappingDataCursor ;
      If SqlCode = Csr_Opn_Cod;
         Exec Sql Close MappingDataCursor;
         Exec Sql Open MappingDataCursor;
      EndIf;

      If SqlCode < SuccessCode;
         uDpsds.wkQuery_Name = 'Open_MappingDataCursor';
         IaSqlDiagnostic(uDpsds);
      EndIf;

      wkArrElem = %Elem(FSpecMappingDs);

      If Sqlcode = successCode;
          Select ;
             When inSourceSpec ='F'  ;
                Exec Sql
                   Fetch MappingDataCursor For :wKArrElem Rows
                   Into :FSpecMappingDs;
             When inSourceSpec ='D' ;
                Exec Sql
                   Fetch MappingDataCursor For :wKArrElem  Rows
                   Into :DSpecMappingDs;
             When inSourceSpec ='C' ;                                                    //0052
                Exec Sql                                                                 //0052
                   Fetch MappingDataCursor For :wKArrElem  Rows                          //0052
                   Into :CSrcSpecMappingDs;                                              //0052
               For Rownum=1 To SQLER3;                                                   //0083
                  Eval-Corr CSrcSpecMappingDswKey(RowNum)=                               //0083
                                       CSrcSpecMappingDs(RowNum);                        //0083
               EndFor;                                                                   //0083
          Endsl;
      EndIf;
    Exec Sql Close MappingDataCursor ;

   EndIf;                                                                                //0028

/copy 'QCPYSRC/iaprcerlog.rpgleinc'

End-Proc GetSpecSrcMapping ;

//------------------------------------------------------------------------------------- //
//Procedure to parser free format F - Spec source to Pseudocode                         //
//------------------------------------------------------------------------------------- //

Dcl-Proc freeFormatFSpecParser Export;

   Dcl-Pi freeFormatFSpecParser ;
      inFSpecParmPointer Pointer;
   End-Pi;

   // Declaration of datastructure
   // F Spec Parser Parameter datastructure
   Dcl-Ds inFSpecParmDS  Qualified Based(inFSpecParmPointer);
      inReqId        Char(18);
      inSrcLib       Char(10);
      inSrcPf        Char(10);
      inSrcMbr       Char(10);
      insrcType      Char(10);
      inSrcRrn       Packed(6:0);
      inSrcSeq       Packed(6:2);
      inSrcLtyp      Char(5);
      inSrcSpec      Char(1);
      inSrcLnct      Char(1);
      inSrcDta       VarChar(cwSrcLength);
      inIOIndentParmPointer Pointer;                                                     //0038
      inDclType      Char(10);
      inSubType      Char(10);
      inhCmtReqd     Char(1);
   End-Ds;
   //Data Structure Declarations                                                         //0091
   Dcl-Ds dsFSpecLFNewFormat likeDS(TdsFSpecLFNewFormat)   Inz(*likeDS) ;                //0091
   Dcl-Ds dsFSpecKeywords    likeDS(TdsFSpecKeywords)   Dim(99)                          //0091
                             Inz(*likeDS) ;                                              //0091

    //Declaration of work variables
   Dcl-S    wkSrcDta                    VarChar(cwSrcLength)   Inz;
   Dcl-S    wkSrcDtaUpper               VarChar(cwSrcLength)   Inz;
   Dcl-S    wkPseudoCode                Char(cwSrcLength)      Inz;
   Dcl-S    wkSrcType                   Char(10)               Inz;
   Dcl-S    wkFSpecKeyword              Char(30)               Inz;
   Dcl-S    wkSubChar                   Char(1)                Inz;
   Dcl-S    wkKeywordValue              Char(50)               Inz;
   Dcl-S    wkKeywordUpperCase          Char(10)               Inz;
   Dcl-S    wkSrcSpec                   Char(1)                Inz;
   Dcl-S    wkSrcLineType               Char(5)                Inz;
   Dcl-S    wkSaveDeviceType            Char(10)               Inz;
   Dcl-S    wkFileAttribute             Char(10)               Inz;                      //0043
   Dcl-S    wkFileType                  Char(10)               Inz;                      //0043
   Dcl-S    wkIndexFlag                 Char(1)                Inz;                      //0043
                                                                                         //0043
   Dcl-S    wkStrPos                    Packed(3:0)            Inz;
   Dcl-S    wkEndPos                    Packed(3:0)            Inz;
   Dcl-S    wkSubstrLen                 Packed(3:0)            Inz;
   Dcl-S    wkScanPos                   Packed(3:0)            Inz;
   Dcl-S    wkStrPosScan                Packed(3:0)            Inz;
   Dcl-S    wkDSArrayElemCount          Packed(3:0)            Inz;
   Dcl-S    wkFspecIndex                Packed(3:0)            Inz;
   Dcl-S    wkKeywordCount              Packed(3:0)            Inz;
   Dcl-S    wkSrcMaxLen                 Packed(3:0)            Inz;                      //0002
   Dcl-S    fw1stLinePscodeWritten      Ind                    Inz;                      //0002
   Dcl-S    fwGetFSpecData              Ind                    Inz;
   Dcl-S    ioParmPointer               Pointer                Inz(*Null);
   Dcl-S    wkCallMode                  Char(1)                Inz ;                     //0091
   Dcl-S    wkKeyWrdPointer             Pointer                Inz ;                     //0091
   Dcl-S    wkKeyWrdCntr                Packed(2:0)            Inz ;                     //0091


   //Declaration of Constant
   Dcl-C    cwWorkStn                  Const('WORKSTN');
   Dcl-C    cwDisk                     Const('DISK');
   Dcl-C    cwDiskPF                   Const('DISK-PF');                                 //0043
   Dcl-C    cwDiskIndex                Const('DISK-IX');                                 //0043
   Dcl-C    cwDiskView                 Const('DISK-VW');                                 //0043
   Dcl-C    cwPF                       Const('PF');                                      //0043
   Dcl-C    cwLF                       Const('LF');                                      //0043
   Dcl-C    cwINDEX                    Const('IX');                                      //0043
   Dcl-C    cwVIEW                     Const('VW');                                      //0043
                                                                                         //0043
   Dcl-C    cwPrinter                  Const('PRINTER');
   Dcl-C    cwInput                    Const('*INPUT');
   Dcl-C    cwOutput                   Const('*OUTPUT');
   Dcl-C    cwUpdate                   Const('*UPDATE');
   Dcl-C    cwDelete                   Const('*DELETE');
   Dcl-C    cwKeyed                    Const('KEYED');
   Dcl-C    cwRcdFmt                   Const('RENAME');
   Dcl-C    cwGetValue                 Const('GETVALUE');
   Dcl-C    cwFFC                      Const('FFC');
   Dcl-C    cwFFR                      Const('FFR');
   Dcl-C    cwPipe                     Const('| ');

   //Copybook declaration
/copy 'QCPYSRC/iaprderlog.rpgleinc'
   wkuDpsds.nbrparms = %parms;                                                           //0030
   EvaluatePSDS() ;                                                                      //0030
   wkCspecBlankInd = *off;                                                               //0057

   // Initialise the variables
   Exsr Initialise;

   // Process F Spec if we have source data                                             //0002
   If wkSrcMaxLen > *Zeros;                                                              //0002
     // Get the file name
     wkStrPos =  1;
     wkEndPos =  %Scan(' ' : wkSrcDta : wkStrPos);
     If  wkEndPos > *Zeros;                                                              //0002
       // File name found and further keyword exist in the source data
       wkSubstrLen =  wkEndPos - wkStrPos;
       // Set the new start poistion to get the remaining keyword
       wkStrPosScan   =  wkEndPos;
       fwGetFSpecData = *On;                                                             //0002
     Else;                                                                               //0002
       // Only File name exist in the source data
       fwGetFSpecData = *Off;                                                            //0002
       wkSubstrLen    = wkSrcMaxLen;                                                     //0002
     EndIf;                                                                              //0002

     // Get the F spec file name
     If wkStrPos > *Zeros And wkSubstrLen > *Zeros;
       dsFSpecPseudocode.dsName   =  %Subst(wkSrcDta : wkStrPos : wkSubstrLen);
      //Save file name and its record formats name in array for later usage              //0042
      //(To check if a variable getting cleared) is a record format OR not.              //0042
      SaveFileRecordFormatsNames(dsFSpecPseudocode.dsName : wkSrcDta);                   //0042
     EndIf;
   EndIf;                                                                                //0002

     // Process to get more keywords in the F spec source data
  If fwGetFSpecData;
   // Replace 'DISK' with special keywords before searching for mapping.                //0043
   Exsr UpdateFileType;                                                                  //0043
   wkKeyWrdCntr = *Zeros ;                                                               //0091
   // From the list of F Spec Keyword in the array, compare in the source data and fill pseudocode
   For wkFspecIndex = 1 to wkDSArrayElemCount;

      // Leave if there are no more data in the mapping
      If FSpecMappingDs(wkFspecIndex).dsKeywrdOpcodeName = *Blanks;
         Leave;
      EndIf;

      // Convert the keyword to upper case
      wkKeywordUpperCase  =  %Xlate(cwLo : cwUp : FSpecMappingDs(wkFspecIndex).dsKeywrdOpcodeName);
      // Look for the Keyword in the source data
      wkScanPos   =  %Scan(%Trim(wkKeywordUpperCase) : wkSrcDtaUpper : wkStrPosScan);

      // If the keyword and its mapping found, fill the pseudocode in the Formated DS for the F spe
      If wkScanPos > *Zeros;
         Select;
            // Check for the device type (WORKSTN, PRINTER, DISK)
            When  (FSpecMappingDs(wkFspecIndex).dsKeywrdOpcodeName    =  cwWorkstn   Or
                  FSpecMappingDs(wkFspecIndex).dsKeywrdOpcodeName     =  cwDisk      Or
                  FSpecMappingDs(wkFspecIndex).dsKeywrdOpcodeName     =  cwDiskPF    Or  //0043
                  FSpecMappingDs(wkFspecIndex).dsKeywrdOpcodeName     =  cwDiskIndex Or  //0043
                  FSpecMappingDs(wkFspecIndex).dsKeywrdOpcodeName     =  cwDiskView  Or  //0043
                  FSpecMappingDs(wkFspecIndex).dsKeywrdOpcodeName     =  cwPrinter );
                  dsFSpecPseudocode.dsDevice =  FSpecMappingDs(wkFspecIndex).dsSrcMapping;
                  wkSaveDeviceType = FSpecMappingDs(wkFspecIndex).dsKeywrdOpcodeName;

            // Check for the file mode  (*Input, *Output, *Update, *Delete)
            When  (FSpecMappingDs(wkFspecIndex).dsKeywrdOpcodeName    =  cwInput     Or
                  FSpecMappingDs(wkFspecIndex).dsKeywrdOpcodeName     =  cwOutput    Or
                  FSpecMappingDs(wkFspecIndex).dsKeywrdOpcodeName     =  cwUpdate    Or
                  FSpecMappingDs(wkFspecIndex).dsKeywrdOpcodeName     =  cwDelete);

                  // There can be possibility of multiple usage, get all the occurance of it
                  If dsFSpecPseudocode.dsMode   =  *Blanks;
                     dsFSpecPseudocode.dsMode   =  FSpecMappingDs(wkFspecIndex).dsSrcMapping;
                  Else;
                     dsFSpecPseudocode.dsMode   =  %Trim(dsFSpecPseudocode.dsMode)   +
                                                   '/'   +
                                                   FSpecMappingDs(wkFspecIndex).dsSrcMapping;
                  EndIf;

            // Check if the database is Keyed
            When  FSpecMappingDs(wkFspecIndex).dsKeywrdOpcodeName     =  cwKeyed ;
                  dsFSpecPseudocode.dsKeyed   =  FSpecMappingDs(wkFspecIndex).dsSrcMapping;

            // Map the record format (RENAME)
            When  FSpecMappingDs(wkFspecIndex).dsKeywrdOpcodeName     =  cwRcdFmt;
                     wkKeywordValue =  *Blanks;
                     Exsr  GetKeywordValue;
                  dsFSpecPseudocode.dsRcdFmt  =  %Trim(wkKeywordValue);
                  //Store file keywords in array                                         //0091
                  If wkFileConfigFlag = cwNewFormat ;                                    //0091
                     wkKeyWrdCntr += 1 ;                                                 //0091
                     dsFSpecKeywords(wkKeyWrdCntr).dsKeyWrdDtls =                        //0091
                           %trim(FSpecMappingDs(wkFspecIndex).dsKeywrdOpcodeName)        //0091
                           + ' - ' + %Trim(wkKeywordValue) ;                             //0091
                  Endif ;                                                                //0091

            // Map the keywords for the F spec
            Other;
                  wkKeywordCount = wkKeywordCount  + 1;
                  wkPseudoCode   = *Blanks;
                  wkPseudoCode   =  %Trim(FSpecMappingDs(wkFspecIndex).dsSrcMapping);
                  // If the keyword parameter needs to retrieved, get the value
                  If FSpecMappingDs(wkFspecIndex).dsActionType  =  cwGetValue;
                     wkKeywordValue =  *Blanks;
                     Exsr  GetKeywordValue;
                     //Store file keywords in array                                      //0091
                     If wkFileConfigFlag = cwNewFormat ;                                 //0091
                        wkKeyWrdCntr += 1 ;                                              //0091
                        Select ;                                                         //0091
                        When %Scan(':' : wkPseudoCode) > *Zeros ;                        //0091
                           dsFSpecKeywords(wkKeyWrdCntr).dsKeyWrdDtls =                  //0091
                                    %trim(%Xlate(':' : ' ' : wkPseudoCode))              //0091
                                    + ' - ' + %Trim(wkKeywordValue) ;                    //0091
                        When wkPseudoCode = *Blanks ;                                    //0091
                           dsFSpecKeywords(wkKeyWrdCntr).dsKeyWrdDtls =                  //0091
                              %trim(FSpecMappingDs(wkFspecIndex).dsKeywrdOpcodeName)     //0091
                              + ' - ' + %Trim(wkKeywordValue) ;                          //0091
                        Other ;                                                          //0091
                           dsFSpecKeywords(wkKeyWrdCntr).dsKeyWrdDtls =                  //0091
                                    %trim(wkPseudoCode)                                  //0091
                                    + ' - ' + %Trim(wkKeywordValue) ;                    //0091
                        EndSl ;                                                          //0091
                     Endif ;                                                             //0091
                     wkPseudoCode   =  %Trim(wkPseudoCode) + ' ' +                       //0091
                                       %Trim(wkKeywordValue);
                  Else ;                                                                 //0091
                     //Store file keywords in array                                      //0091
                     If wkFileConfigFlag = cwNewFormat ;                                 //0091
                        wkKeyWrdCntr += 1 ;                                              //0091
                        dsFSpecKeywords(wkKeyWrdCntr).dsKeyWrdDtls =                     //0091
                                    %trim(wkPseudoCode) ;                                //0091
                     Endif ;                                                             //0091
                  EndIf;

                  // There can be possibility of multiple keyword, get all the occurance of it
                  If dsFSpecPseudocode.dsKeyword   =  *Blanks;
                     dsFSpecPseudocode.dsKeyword   =  %Trim(wkPseudoCode);
                  Else;
                     dsFSpecPseudocode.dsKeyword   =  %Trim(dsFSpecPseudocode.dsKeyword)  +
                                                      ', '   +
                                                      %Trim(wkPseudoCode);
                  EndIf;
            Endsl;

            // If keyword count =2 , write the pseudocode
            If wkKeywordCount  =  2;
               // Write the pseudocode for F spec
               Exsr WriteFSpecPseudocodeSR;
               wkKeywordCount = *Zeros;
               If wkFileConfigFlag = cwNewFormat ;                                       //0091
                  //Prepare pseudo code in new format using DS defined                   //0091
                  dsFSpecLFNewFormat.dsName   = dsFSpecPseudocode.dsName ;               //0091
                  dsFSpecLFNewFormat.dsMode   = dsFSpecPseudocode.dsMode ;               //0091
                  dsFSpecLFNewFormat.dsDevice = dsFSpecPseudocode.dsDevice ;             //0091
               Endif ;                                                                   //0091
               // Reset the data structure to capture the new value
               Exsr InitPseudocodeDsSr;
               fw1stLinePscodeWritten  = *On;
            EndIf;
      EndIf;
   EndFor;
  EndIf;                                                                                 //0002

   //Populate pseudocode as per the configuration                                        //0091
   If wkFileConfigFlag = cwNewFormat ;                                                   //0091
      //Prepare pseudo code in new format using DS defined                               //0091
      If fw1stLinePscodeWritten  = *On ;                                                 //0091
      Else ;                                                                             //0091
         dsFSpecLFNewFormat.dsName       = dsFSpecPseudocode.dsName ;                    //0091
         dsFSpecLFNewFormat.dsMode       = dsFSpecPseudocode.dsMode ;                    //0091
         dsFSpecLFNewFormat.dsDevice     = dsFSpecPseudocode.dsDevice ;                  //0091
      Endif ;                                                                            //0091
      //Call procedure to get file level details and store in array                      //0091
      wkCallMode = cwStoreData ;                                                         //0091
      IaGetLogicalFileDetails(wkCallMode : dsFSpecLFNewFormat :                          //0091
                              wkKeyWrdPointer : wkKeyWrdCntr) ;                          //0091
      If fw1stLinePscodeWritten  = *On ;                                                 //0091
         //Call procedure to get file level details and store in array                   //0091
         wkCallMode = cwWriteData ;                                                      //0091
         IaGetLogicalFileDetails(wkCallMode : dsFSpecLFNewFormat :                       //0091
                                 wkKeyWrdPointer : wkKeyWrdCntr) ;                       //0091
      Endif ;                                                                            //0091
   Endif ;                                                                               //0091
   If fw1stLinePscodeWritten  = *Off Or wkKeywordCount = 1;
     // Write the pseudocode for F spec  if not written inside the loop
     Exsr WriteFSpecPseudocodeSR;
   EndIf;

//------------------------------------------------------------------------------------- //
//Initialise - Initialise the work variables                                            //
//------------------------------------------------------------------------------------- //
   Begsr Initialise;

      wkSrcSpec                   =  inFSpecParmDS.inSrcSpec;
      wkSrcDtaUpper               =  %Xlate(cwLO:cwUP:inFSpecParmDS.inSrcDta);
      wkSrcType                   =  'RPGLE';
      OutParmWriteSrcDocDS        =  inFSpecParmDS;
      wkDSArrayElemCount          =  100;
      wkKeywordCount              =  *Zeros;
      fw1stLinePscodeWritten      = *Off;
      fwGetFSpecData              = *Off;
      wkSrcLineType               =  inFSpecParmDS.inSrcLtyp;
      wkFileDtlCntr = *Zeros ;                                                           //0091
                                                                                         //0091
      //Clear file and Keywords data structure for every run                             //0091
      Clear dsFSpecKeywords ;                                                            //0091
      Clear dsFSpecLFNewFormat ;                                                         //0091
      wkKeyWrdPointer = %Addr(dsFSpecKeywords) ;                                         //0091
                                                                                         //0091
      Exsr  InitPseudocodeDsSr;

      //Get the source data with out the dcl-f text in it for further processing
      If wkSrcLineType   =  cwFFR;
         //In the fully free format(**free) there wouldn't be any mod tag
         //To convert file name, usage, format names, keywords etc. in captials          //0050
         //use upper cased source data                                                   //0050
         wkSrcDta                =  %TrimL(wkSrcDtaUpper);                               //0050
         wkStrPos                =  6;
         wkEndPos                =  %Scan(';' : wkSrcDta:1);
         wkSubstrLen             =  wkEndPos - wkStrPos;
         If wkStrPos > *Zeros and wkEndPos > *Zeros And wkSubstrLen > *Zeros;
            wkSrcDta             =  %Trim(%Subst(wkSrcDta : wkStrPos : wkSubstrLen));
         EndIf;
     EndIf;

      If wkSrcLineType   =  cwFFC;
         //In the coulmn limited free format(without **free) there could be mod tag before Dcl-F
         //To convert file name, usage, format names, keywords etc. in captials          //0050
         //use upper cased source data                                                   //0050
         wkSrcDta                =  wkSrcDtaUpper;                                       //0050
         wkStrPos                =  %Scan('DCL-F' : wkSrcDtaUpper:1);
         //Set new start position to the get the source data without dcl-f
         wkStrPos                =  wkStrPos +  5;
         wkEndPos                =  %Scan(';' : wkSrcDta:1);
         wkSubstrLen             =  wkEndPos - wkStrPos;
         If wkStrPos > *Zeros and wkEndPos > *Zeros And wkSubstrLen > *Zeros;
            wkSrcDta             =  %Trim(%Subst(wkSrcDta : wkStrPos : wkSubstrLen));
         EndIf;
     EndIf;
      //Set new start position for further processing of the source data
      wkStrPos                   =  1;
      wkSrcDtaUpper              =  %Xlate(cwLO:cwUP:wkSrcDta);
      wkSrcMaxLen                =  %Len(wkSrcDta);                                      //0002


   Endsr;

//------------------------------------------------------------------------------------- //
//InitPseudocodeDsSr -  Initialise the Pseudocode Data strucure                            //
//------------------------------------------------------------------------------------- //
   Begsr InitPseudocodeDsSr;
      Clear                           dsFSpecPseudocode;
      dsFSpecPseudocode.dsDeLimit1=  cwPipe;
      dsFSpecPseudocode.dsDeLimit2=  cwPipe;
      dsFSpecPseudocode.dsDeLimit3=  cwPipe;
      dsFSpecPseudocode.dsDeLimit4=  cwPipe;
      dsFSpecPseudocode.dsDeLimit5=  cwPipe;

   Endsr;

//------------------------------------------------------------------------------------- //
//WriteHSpecPseudocode - Subroutine to write H Spec Pseudocode                          //
//------------------------------------------------------------------------------------- //
   Begsr WriteFSpecPseudocodeSR;
      If fw1stLinePscodeWritten = *Off;
         //If it is 1st Line of F Spec not written yet and
         //if usage not available then map the default value for the mode
         If dsFSpecPseudocode.dsMode = *Blanks;
            //Based on the device type, map the default usage mode
            Select;
              When wkSaveDeviceType   =   cwWorkStn;
                   dsFSpecPseudocode.dsMode = 'C';
              When wkSaveDeviceType   =   cwDisk;
                   dsFSpecPseudocode.dsMode = 'I';
              When wkSaveDeviceType   =   cwPrinter;
                   dsFSpecPseudocode.dsMode = 'O';
            EndSl;
        EndIf;
      EndIf;

      //Write the pseudocode
      //Write F spec data for new format                                                //0091
      If wkFileConfigFlag = cwNewFormat ;                                                //0091
         If dsFSpecLFNewFormat <> *Blanks ;                                              //0091
            wkCallMode = cwWriteData ;                                                   //0091
            IaGetLogicalFileDetails(wkCallMode : dsFSpecLFNewFormat :                    //0091
                                    wkKeyWrdPointer : wkKeyWrdCntr) ;                    //0091
         Endif ;                                                                         //0091
      Else ;                                                                             //0091
         //Write the pseudocode                                                         //0091
         wkPseudocode =  dsFSpecPseudocode.dsFSpec;                                      //0091
         OutParmWriteSrcDocDS.dsPseudocode = wkPseudocode;                               //0091
         ioParmPointer  = %Addr(OutParmWriteSrcDocDS);                                   //0091
         WritePseudoCode(ioParmPointer);                                                 //0091
      Endif ;                                                                            //0091
   Endsr;

//------------------------------------------------------------------------------------- //
//GetKeywordValue - Subroutine to get the keyword value                                 //
//------------------------------------------------------------------------------------- //
   Begsr GetKeywordValue;
      // Get the keyword parameter value within the ()
      If wkScanPos   >  *Zeros;
         wkStrPos =  %Scan('(' : wkSrcDta : wkScanPos);
         wkEndPos =  %Scan(')' : wkSrcDta : wkStrPos);
         wkSubstrLen =  wkEndPos - wkStrPos - 1;
         wkStrPos += 1;
         If wkStrPos > *Zeros And wkSubstrLen > *Zeros;
            wkKeywordValue =  %Subst(wkSrcDta : wkStrPos : wkSubstrLen );
         EndIf;
      EndIf;
   Endsr;
//------------------------------------------------------------------------------------- //0043
//UpdateFileType - Check 'DISK' keyword with special names based on file type           //0043
//------------------------------------------------------------------------------------- //0043
   Begsr UpdateFileType;                                                                 //0043
      //Check if 'DISK' keyword exists, if so consider to check if its a PF or LF.      //0043
      If %scan(cwDisk : wkSrcDtaUpper : %len(%trim(dsFSpecPseudocode.dsName))+1) <> 0;   //0043
                                                                                         //0043
         exec sql select iAObjAtr into :wkFileAttribute from IAOBJECT                    //0043
                   where iAObjNam = :dsFSpecPseudocode.dsName  and                       //0043
                   iAObjTyp = '*FILE' Limit 1;                                           //0043
         //If the file is a logical file, consider it as Index for priting if its a     //0043
         // keyed logical AND it must also not be a join logical.                       //0043
         wkFileType = *Blanks;                                                           //0043
         If wkFileAttribute = cwLF;                                                      //0043
            wkIndexFlag = 'N';                                                           //0043
            exec sql select 'Y' into :wkIndexFlag from IDSPFDKEYS                        //0043
                      where APKeyF <> ' ' and APKeyF <> '*NONE'                          //0043
                      and APFile = :dsFSpecPseudocode.dsName and APJoin<>'Y';            //0043
            If wkIndexFlag = 'Y';                                                        //0043
               wkFileType  = cwDisk + '-'+ cwINDEX;                                      //0043
            Else;                                                                        //0043
               wkFileType  = cwDisk + '-'+ cwVIEW;                                       //0043
            EndIf;                                                                       //0043
         Else;                                                                           //0043
            wkFileType     = cwDisk + '-' + cwPF;                                        //0043
         EndIf;                                                                          //0043
         //  Replace the file type instead of device type for picking the mapping.       //0043
         If wkFileType <> *Blanks;                                                       //0043
            wkSrcDtaUpper=%ScanRpl(cwDisk :%trim(wkFileType): wkSrcDtaUpper :            //0043
                                   %len(%trim(dsFSpecPseudocode.dsName))+1 );            //0043
         EndIf;                                                                          //0043
                                                                                         //0043
      EndIf;                                                                             //0043
                                                                                         //0043
   Endsr;                                                                                //0043
//------------------------------------------------------------------------------------- //0043

/copy 'QCPYSRC/iaprcerlog.rpgleinc'
End-Proc;

//------------------------------------------------------------------------------------- //
//FreeFormatDSpecParser: Procedure to parse D spec source in free format                //
//------------------------------------------------------------------------------------- //
Dcl-Proc FreeFormatDSpecParser Export;
   Dcl-Pi FreeFormatDSpecParser;
      inDSpecDetailsPointer Pointer;
   End-Pi;

   // D Spec Details Parameter datastructure
   Dcl-Ds inDSpecDetailsDs  Based(inDSpecDetailsPointer);
      inReqId        Char(18);
      inSrcLib       Char(10);
      inSrcPf        Char(10);
      inSrcMbr       Char(10);
      insrcType      Char(10);
      inSrcRrn       Packed(6:0);
      inSrcSeq       Packed(6:2);
      inSrcLtyp      Char(5);
      inSrcSpec      Char(1);
      inSrcLnct      Char(1);
      inSrcData      VarChar(cwSrcLength);
   End-Ds;

   //Work Variables declaration
   Dcl-S wkDclType       Char(10)     Inz;
   Dcl-S wkSrcDataUpper  Like(inSrcData);
   Dcl-S wkBlankPos      Zoned(4:0);
   Dcl-S wkHeaderPointer Pointer      Inz;
   Dcl-S wkSrcDataPointer Pointer     Inz;                                               //0023
   Dcl-S outPsuedocodePointer Pointer Inz;                                               //0023
   Dcl-S strDs           Packed(4:0)  Inz;
   Dcl-S endDs           Packed(4:0)  Inz;
   Dcl-S lkEDs           Packed(4:0)  Inz;
   Dcl-S lkRDs           Packed(4:0)  Inz;
   Dcl-S strPRPI         Packed(4:0)  Inz;                                               //0004
   Dcl-S endPRPI         Packed(4:0)  Inz;                                               //0004

   Dcl-C cwFrDCLS        'DCL-S';
   Dcl-C cwFrDCLC        'DCL-C';                                                        //0023
   Dcl-C cwFrDCLPI       'DCL-PI';                                                       //0004
   Dcl-C cwFrDCLPR       'DCL-PR';                                                       //0004
   Dcl-C cwFrENDPI       'END-PI';                                                       //0004
   Dcl-C cwFrENDPR       'END-PR';                                                       //0004

   //Copybook declaration
/copy 'QCPYSRC/iaprderlog.rpgleinc'

   wkuDpsds.nbrparms = %parms;                                                           //0030
   EvaluatePSDS() ;                                                                      //0030
   //Convert the variable name and keywords to upper characters while keeping the        //0050
   //constants and initialized string values case intact                                 //0050
   ConvertVarAndKeywordNamesToCaps(inSrcData);                                           //0050
   wkCspecBlankInd = *off;                                                               //0057
   wksrcDataUpper = %Trim( %Xlate(cwLO : cwUP : insrcData) );

   Exsr GetDclType;

   Exsr WriteSpecHeaderDtl;

   // Write the pseudo code for respective declaration type
   Select;
      When wkDclType = cwFrDCLS;
         FreeFormatVarParser(inDSpecDetailsPointer);

      When wkDclType = cwFrDCLC;                                                         //0023
         Exsr ParseConst;                                                                //0023

      When wkDclType = cwFrDCLPI or wkDclType = cwFrDCLPR or wkCntFlag  = 'P';           //0004
         Exsr ParsePRPI;                                                                 //0004

      When wkDclType = cwFrDCLDS or wkCntFlag  = 'C';
         Exsr ParseDs;
   EndSl;

   wkPrevDclType = wkDclType;

   //Subroutine to get declaration type
   BegSr GetDclType;
      wkBlankPos = %Scan(' ' : wksrcDataUpper : 1);

      // Get the declaration type
      If wkBlankPos > *Zeros and
         %Scan('DCL-' : wksrcDataUpper : 1 : wkBlankPos - 1) > *Zeros;
         wkDclType  =  %Subst( wksrcDataUpper : 1 : (wkBlankPos - 1) );
      EndIf;

   EndSr;

   //Subroutine to write spec header
   BegSr WriteSpecHeaderDtl;

      // If declaration type has changed write the header for it
      //If wkDclType <> *Blanks And wkDclType <> wkPrevDclType;
      If wkDclType = cwFrDCLDS or wkDclType = cwFrDCLPR or wkDclType = cwFrDCLPI or      //0081
         (wkDclType <> *Blanks And wkDclType <> wkPrevDclType);                          //0081
         Clear SpecHeaderDs;
         SpecHeaderDs.dsReqId    =  inReqId;
         SpecHeaderDs.dsSrcLib   =  inSrcLib;
         SpecHeaderDs.dsSrcPf    =  inSrcPf;
         SpecHeaderDs.dsSrcMbr   =  inSrcMbr;
         SpecHeaderDs.dsSrcType  =  inSrcType;
         SpecHeaderDs.dsSrcSpec  = 'D';
     //  SpecHeaderDs.dsKeyfld   = %Subst(wkDclType : 5 : %Len( %Trim(wkDclType) ) );    //0001
         SpecHeaderDs.dsKeyfld   = %Subst(wkDclType:5:%Len(%Trim(wkDclType))-4);         //0001

         wkHeaderPointer = %Addr(SpecHeaderDs);
         iAWriteSpecHeader(wkHeaderPointer);
      EndIf;

   EndSr;

   //Subroutine to parse DS & write the pseudo code
   BegSr ParseDs;

      StrDs = %Scan(cwFrDCLDS : %Trim(wksrcDataUpper));
      EndDs = %Scan(cwFrENDDS : %Trim(wksrcDataUpper));
      LkeDs = %Scan(cwFrLKEDS : %Trim(wksrcDataUpper));
      LkRDs = %Scan(cwFrLKRDS : %Trim(wksrcDataUpper));
      If wkDclType = cwFrDCLDS;
         wkCntFlag  = 'C';
      Endif;
      If EndDs > *Zeros and StrDs = *Zeros;
         wkCntFlag  = ' ';
      Endif;
      If wkCntFlag  = 'C';
         If EndDs > *Zeros or LkeDs > *Zeros or LkRDs > *Zeros;
            wkCntFlag  = ' ';
         Endif;
         iAFreeFormatDSParser(inDSpecDetailsPointer);
      Endif;

   EndSr;

   BegSr ParsePRPI;                                                                      //0004
      select;                                                                            //0004
      when wkDclType = cwFrDCLPI ;                                                       //0004
         strPRPI = %Scan(cwFrDCLPI : %Trim(wksrcDataUpper));                             //0004
         endPRPI = %Scan(cwFrENDPI : %Trim(wksrcDataUpper));                             //0004
                                                                                         //0004
      when wkDclType = cwFrDCLPR ;                                                       //0004
         strPRPI = %Scan(cwFrDCLPR : %Trim(wksrcDataUpper));                             //0004
         endPRPI = %Scan(cwFrENDPR : %Trim(wksrcDataUpper));                             //0004
                                                                                         //0004
      when wkCntFlag  = 'P';                                                             //0004
         endPRPI = %Scan('END-P'  : %Trim(wksrcDataUpper));                              //0004
      endsl;                                                                             //0004
                                                                                         //0004
      select;                                                                            //0004
      when strPRPI > 0 and endPRPI = 0;                                                  //0004
         wkCntFlag  = 'P';                                                               //0004
      when strPRPI = 0 and endPRPI > 0;                                                  //0004
         wkCntFlag  = ' ';                                                               //0004
      endsl;                                                                             //0004
                                                                                         //0004
      if wkCntFlag  = 'P' or ( strPRPI > 0 and endPRPI > 0);                             //0004
         //For Free Format : In DCL-PR , DCL-PI                                         //0037
         //change procedure name to UpperCase                                           //0037
         inSrcData = %Xlate(cwLo:cwUp:inSrcData );                                       //0037
         inDSpecDetailsPointer  = %Addr(inDSpecDetailsDs) ;                              //0037
         FreeFormatPIPRParser(inDSpecDetailsPointer);                                    //0004
      endif;                                                                             //0004
   EndSr;                                                                                //0004

   BegSr ParseConst;                                                                     //0023
      wkSrcDataPointer = %Addr(inSrcData);                                               //0023
      outPseudoCodeDs = FreeFormatConstParser(wkSrcDataPointer);                         //0023
                                                                                         //0023
      outPsuedocodePointer = %Addr(outPseudoCodeDs);                                     //0023
      BreakAndWritePseudocode(inDSpecDetailsPointer : outPsuedocodePointer);             //0023
   EndSr;                                                                                //0023

   //Copy book Dcl for error handling
/copy 'QCPYSRC/iaprcerlog.rpgleinc'

End-Proc FreeFormatDSpecParser;

//------------------------------------------------------------------------------------- //
//FreeFormatVarParser:Procedure to write Pseudocode for variable Dcl in free format     //
//------------------------------------------------------------------------------------- //
Dcl-Proc FreeFormatVarParser;
   Dcl-Pi FreeFormatVarParser;
      inVarDclDetailsPointer Pointer;
   End-Pi;

   // D Spec variable Dcl Details Parameter datastructure
   Dcl-Ds inVarDclDetailsDs  Based(inVarDclDetailsPointer);
      inReqId        Char(18);
      inSrcLib       Char(10);
      inSrcPf        Char(10);
      inSrcMbr       Char(10);
      insrcType      Char(10);
      inSrcRrn       Packed(6:0);
      inSrcSeq       Packed(6:2);
      inSrcLtyp      Char(5);
      inSrcSpec      Char(1);
      inSrcLnct      Char(1);
      inSrcData      VarChar(cwSrcLength);
   End-Ds;

   // Datastructure to write pseudo code
   Dcl-Ds wkPseudoCodeDs Qualified;
      varName    Char(50) Pos(1);
      delimiter1 Char(2)  Pos(51) Inz('| ');
      dataType   Char(1)  Pos(53) Inz;                                                   //0014
      delimiter3 Char(6)  Pos(54) Inz('    | ');                                         //0008
      Length     Char(6)  Pos(60) Inz;                                                   //0014
      delimiter4 Char(3)  Pos(66) Inz(' | ');                                            //0008
      dimension  Char(4)  Pos(69) Inz;                                                   //0014
      delimiter5 Char(2)  Pos(73) Inz('| ');                                             //0008
   End-Ds;

   // Datastructure for source attributes
   Dcl-Ds wkDclAttributesDs Qualified;
      varName    Char(50);
      dataType   Char(20);
      length     Char(10);
      dimension  Char(10);
      position   Char(10);
      keywords   Char(200) Dim(15);                                                      //0014
   End-Ds;

   Dcl-S insrcDataPointer      Pointer;
   Dcl-S outPsuedocodePointer  Pointer      Inz;
   Dcl-S strDs                 Packed(4:0)  Inz;
   Dcl-S endDs                 Packed(4:0)  Inz;
   Dcl-S lkeDs                 Packed(4:0)  Inz;
   Dcl-S lkRDs                 Packed(4:0)  Inz;

   //Copybook declaration
/copy 'QCPYSRC/iaprderlog.rpgleinc'

   wkuDpsds.nbrparms = %parms;                                                           //0030
   EvaluatePSDS() ;                                                                      //0030
   // Main Processing

   //Get the attributes of the variable declared
   insrcDataPointer  = %Addr(insrcData);
   wkDclAttributesDs = GetDSpecSrcAttributes(insrcDataPointer);

   Clear outPseudoCodeDs;                                                                //0014
   outPseudoCodeDs.outBlnkPseudoCode = wkPseudoCodeDs;                                   //0014

   //Populate value in the DS to form pseudo code
   wkPseudoCodeDs.varName   = wkDclAttributesDs.varName;
   wkPseudoCodeDs.dataType  = wkDclAttributesDs.dataType;
   wkPseudoCodeDs.length    = wkDclAttributesDs.Length;
   wkPseudoCodeDs.dimension = wkDclAttributesDs.dimension;

   If wkBeginProc = 'Y';                                                                 //0018
      %subst(outPseudoCodeDs.outDclPseudoCode : 3) = wkPseudoCodeDs;                     //0018
   Else;                                                                                 //0018
      outPseudoCodeDs.outDclPseudoCode = wkPseudoCodeDs;                                 //0018
   Endif;                                                                                //0018

   outPseudoCodeDs.outKeywords = wkDclAttributesDs.keywords;                             //0014
                                                                                         //0014
   outPsuedocodePointer = %Addr(outPseudoCodeDs);                                        //0014
   BreakAndWritePseudocode(inVarDclDetailsPointer : outPsuedocodePointer);               //0014

   //Copy book Dcl for error handling
/copy 'QCPYSRC/iaprcerlog.rpgleinc'

End-Proc FreeFormatVarParser;

//------------------------------------------------------------------------------------- //
//GetDSpecSrcAttributes: Procedure to get attributes of D spec source in free format    //
//------------------------------------------------------------------------------------- //
Dcl-Proc GetDSpecSrcAttributes;
   Dcl-Pi GetDSpecSrcAttributes  LikeDs(wkDclAttributesDs);
      inSrcDataPointer Pointer;
   End-Pi;

   // Datastructure for source attributes
   Dcl-Ds wkDclAttributesDs Qualified;
      varName    Char(50);
      dataType   Char(20);
      length     Char(10);
      dimension  Char(10);
      position   Char(10);
      keywords   Char(200) Dim(15);                                                      //0014
   End-Ds;

   //Work Variables declaration
   Dcl-S insrcData       VarChar(cwSrcLength) Based(inSrcDataPointer);
   Dcl-S wkDataType      Varchar(20);
   Dcl-S wkKeywords      VarChar(200);
   Dcl-S wkKeywordVal    VarChar(100);                                                   //0003
   Dcl-S wkKwdOpcMap     Char(10);
   Dcl-S wkKwdSrcMap     VarChar(50);
   Dcl-S wkNonBlankPos   Zoned(4:0) Inz(1);
   Dcl-S wkBlankPos      Zoned(4:0) Inz;
   Dcl-S wkBrStrPos      Zoned(4:0) Inz;
   Dcl-S wkBrEndPos      Zoned(4:0) Inz;
   Dcl-S wkDataTypeElem  Zoned(4:0) Inz;
   Dcl-S wkKeywordElem   Zoned(4:0) Inz;
   Dcl-S wksrcDataUpper  Like(insrcData);
   Dcl-S wkKeywordsUpper Like(wkKeywords);
   Dcl-S wkKeywordIdx    Zoned(4:0) Inz;                                                 //0014
   //Work Constant declaration                                                          //0086
   Dcl-C cwCTDAT            Const('CTDATA');                                             //0086

   //Copybook declaration
/copy 'QCPYSRC/iaprderlog.rpgleinc'

   wkuDpsds.nbrparms = %parms;                                                           //0030
   EvaluatePSDS() ;                                                                      //0030
   //Main Processing

   Exsr Initialise;

   Exsr GetVarName;

   If %Scan('DCL-DS' : wksrcDataUpper : 1) = *Zeros
      And %Scan('LIKE'   : wksrcDataUpper : 1) = *Zeros                                  //0023
      And constDclInd = *off;                                                            //0023
      Exsr GetDataType;
      Exsr GetVarLength;
   EndIf;

   If %Scan('DCL-DS' : wksrcDataUpper : 1) > *Zeros and                                  //0087
      %Scan('LEN' : wksrcDataUpper : 1) > *Zeros ;                                       //0087
      Exsr GetVarLength;                                                                 //0087
   EndIf;                                                                                //0087
   Exsr GetKeywords;

   Return wkDclAttributesDs;

   //Initialisation Subroutine
   BegSr Initialise;

      Clear wkDclAttributesDs;

      wksrcDataUpper = %Trim( %Xlate( cwLO : cwUP : insrcData));

      If %Scan(';' : wksrcDataUpper : 1) > *Zeros;
         wksrcDataUpper = %Xlate(';': ' ': wksrcDataUpper);
      EndIf;

   EndSr;

   //Subroutine to get variable name
   BegSr GetVarName;

      wkBlankPos = %Scan(' ': wksrcDataUpper : 1);

      //If DCL is also mentioned, like DCL-S, DCL-PARM, DCL-SUBF then remove it
      If wkBlankPos > 0 And
         %Scan('DCL-':wksrcDataUpper : 1 : wkBlankPos-1) > *Zeros;
         wkNonBlankPos = %Check(' ': wksrcDataUpper : wkBlankPos);

         If wkNonBlankPos > 0;                                                           //0006
            wkBlankPos    = %Scan(' ' : wksrcDataUpper : wkNonBlankPos);
         EndIf;                                                                          //0006
      EndIf;

      //Fetch the Name in the D Spec source
      If wkNonBlankPos > *Zeros And                                                      //0006
         wkBlankPos > wkNonBlankPos;                                                     //0006
         wkDclAttributesDs.varName = %Subst(insrcData     :
                                            wkNonBlankPos :
                                            wkBlankPos - wkNonBlankPos);
         If (wkDclAttributesDs.varName = '*N' or                                         //0069
                     wkDclAttributesDs.varName = '*n');                                  //0069
            If  %Scan('PSDS':wksrcDataUpper:wkNonBlankPos) > 1;                          //0069
               wkDclAttributesDs.varName = cwPsds;                                       //0069
            Else;                                                                        //0069
               If  %Scan('DCL-DS':wksrcDataUpper:1) >= 1;                                //0069
                  wkDclAttributesDs.varName = cwNoName ;                                 //0069
               EndIf;                                                                    //0069
            EndIf;                                                                       //0069
         EndIf;                                                                          //0069
                                                                                         //0069
         wkNonBlankPos = %Check(' ': wksrcDataUpper : wkBlankPos);                       //0023
      Else;                                                                              //0006
         //If no non blank position found then return as nothing left to parse in source line
         Return wkDclAttributesDs;                                                       //0006
      EndIf;

   EndSr;

   //Subroutine to get data type
   BegSr GetDataType;

      //Find the start & end position based on Blank space

      If wkNonBlankPos > *Zeros;                                                         //0006
         Select;
            When %Scan(' ' : wksrcDataUpper : wkNonBlankPos) <
                 %Scan('(' : wksrcDataUpper : wkNonBlankPos)
              Or %Scan('(' : wksrcDataUpper : wkNonBlankPos) = 0;

               wkBlankPos = %Scan(' ': wksrcDataUpper : wkNonBlankPos);
            When %Scan('(' : wksrcDataUpper : wkNonBlankPos) <
                 %Scan(' ' : wksrcDataUpper : wkNonBlankPos);

               wkBlankPos    = %Scan('(': wksrcDataUpper : wkNonBlankPos);
         EndSl;
      Else;                                                                              //0006
         //If no non blank position found then return as nothing left to parse in source line
         Return wkDclAttributesDs;                                                       //0006
      EndIf;                                                                             //0006

      //Fetch the data type in the D Spec source
      If wkBlankPos > wkNonBlankPos;
         wkDataType = %Subst(wksrcDataUpper : wkNonBlankPos :
                             wkBlankPos - wkNonBlankPos);
      EndIf;

      //Get the source mapping for the data type
      wkDataTypeElem = %Lookup( wkDataType :
                                DSpecMappingDs(*).dsKeywrdOpcodeName : 1 :
                                %Elem(DSpecMappingDs) );

      If wkDataTypeElem > *Zeros And
         DSpecMappingDs(wkDataTypeElem) <> *Blanks;                                      //0006

         wkDclAttributesDs.dataType = DSpecMappingDs(wkDataTypeElem).dsSrcMapping;

      EndIf;

   EndSr;

   //Subroutine to get variable length
   BegSr GetVarLength;
      If wkBlankPos > *Zeros;                                                            //0006
         wkNonBlankPos = %Check(' ': wksrcDataUpper : wkBlankPos);
      EndIf;                                                                             //0006

      //Find the position of open and close brackets to get variable length
      If wkNonBlankPos > *Zeros And
         %Scan('(' : wksrcDataUpper : wkNonBlankPos) = wkNonBlankPos;

         wkBrEndPos = %Scan(')' : wksrcDataUpper : wkNonBlankPos);

         If wkBrEndPos - wkNonBlankPos > 1 and wkNonBlankPos > *Zeros;                   //0022
            wkDclAttributesDs.length = %Trim( %Subst(insrcData : wkNonBlankPos+1 :
                                                     wkBrEndPos-wkNonBlankPos-1) );

            If %check(cwDigits : %Trim(wkDclAttributesDs.length))  > *Zeros;             //0101
               wkDclAttributesDs.length  =  *Blanks;                                     //0101
            Endif;                                                                       //0101
         EndIf;

         wkNonBlankPos = %Check(' ': wksrcDataUpper : wkBrEndPos + 1);
      EndIf;

   EndSr;

   //Subroutine to get keywords details
   BegSr GetKeywords;

      If wkNonBlankPos > *Zeros;
         wkKeywords = %Subst( insrcData     :
                              wkNonBlankPos :
                              %len( %trim( insrcData )) - wkNonBlankPos);

         If constDclInd = *On;                                                           //0023
            wkDclAttributesDs.keywords(1) = %Trim(wkKeywords);                           //0023
            Return wkDclAttributesDs;                                                    //0023
         EndIf;                                                                          //0023

         wkKeywordsUpper = %Xlate( cwLO : cwUP : wkKeywords);

        //Read the array DS having D spec keywords details & fetch the value
        //from source if found
         For wkKeywordElem = 1 to %Elem(DSpecMappingDs);

            If DSpecMappingDs(wkKeywordElem) = *Blanks;
               Leave;
            EndIf;

            If %Scan( %Trim( DSpecMappingDs( wkKeywordElem ).dsKeywrdOpcodeName ) :
                      wkKeywordsUpper : 1) > *Zeros;

               wkKwdOpcMap = %Trim(
                             DSpecMappingDs( wkKeywordElem ).dsKeywrdOpcodeName );

               wkKwdSrcMap = %Trim(
                             DSpecMappingDs( wkKeywordElem ).dsSrcMapping );

               Exsr ParseValue;

            EndIf;

         EndFor;
      EndIf;

   EndSr;

   //Subroutine to parse the value mentioned for the keywords
   BegSr ParseValue;

      Clear wkKeywordVal;

      wkNonBlankPos = %Scan( %Trim(wkKwdOpcMap) : wkKeywordsUpper: 1);
      If wkNonBlankPos > *Zeros;                                                         //0006
         wkBrStrPos    = %Scan('(' : wkKeywordsUpper : wkNonBlankPos);
      EndIf;                                                                             //0006

      If wkBrStrPos > *Zeros And wkNonBlankPos > *Zeros And
         %Check(wkKwdOpcMap + ' ' :
                wkKeywordsUpper   : wkNonBlankPos) = wkBrStrPos;

         wkBrEndPos = %Scan(')' : wkKeywordsUpper : wkBrStrPos);

         //Fetch the keywords value and populate in respective columns of source document
         If wkBrEndPos - wkBrStrPos > 1 and wkBrStrPos > *Zeros;                         //0022
            wkKeywordVal = %Trim( %Subst(wkKeywords : wkBrStrPos+1 :
                                           wkBrEndPos - wkBrStrPos - 1)  );

            Select;
               When DSpecMappingDs(wkKeywordElem).dsActionType = 'GETKEYWORD';
                  Exsr GetKeywordsValue;

               When DSpecMappingDs(wkKeywordElem).dsActionType = 'GETDIM';
                  wkDclAttributesDs.dimension =  wkKeywordVal;
                                                                                         //0101
                  If %Check(cwDigits : %Trim(wkDclAttributesDs.dimension))  >  *Zeros;   //0101
                     wkDclAttributesDs.dimension  =  *Blanks;                            //0101
                  Endif;                                                                 //0101

               When DSpecMappingDs(wkKeywordElem).dsActionType  = 'GETPOS';
                  wkDclAttributesDs.position  =  wkKeywordVal;
                  If %Check(cwDigits : %Trim(wkDclAttributesDs.position))  >  *Zeros;
                     wkDclAttributesDs.position  =  *Blanks;
                  Endif;
            EndSl;

         EndIf;
      Else;                                                                              //0086
            If WkKwdopcmap  <>  *Blanks;                                                 //0101
            If wkKeywordIdx < %Elem(wkDclAttributesDs.keywords);                         //0086
               wkKeywordIdx += 1;                                                        //0086
               WkDclAttributesDs.keywords(wkKeywordIdx) =  WkKwdopcmap;                  //0101
            EndIf;                                                                       //0086
         EndIf;                                                                          //0086

      EndIf;
   EndSr;

   //Subroutine to include all keywords value in keyword column of source doc seperated by ','
   BegSr GetKeywordsValue;

      If wkKeywordIdx < %Elem(wkDclAttributesDs.keywords);                               //0014
         wkKeywordIdx += 1;                                                              //0014
         wkDclAttributesDs.keywords(wkKeywordIdx) =  wkKwdSrcMap + ' ' +                 //0014
                                                     %Trim(wkKeywordVal);                //0014
      EndIf;                                                                             //0014

   EndSr;

   //Copy book Dcl for error handling
/copy 'QCPYSRC/iaprcerlog.rpgleinc'

End-Proc GetDSpecSrcAttributes;
//------------------------------------------------------------------------------------- //
//iAFreeFormatDSParser:Procedure to write Pseudocode for DCL-DS in free format          //
//------------------------------------------------------------------------------------- //
Dcl-Proc iAFreeFormatDSParser;
   Dcl-Pi iAFreeFormatDSParser;
      inDSDclDetailsPointer Pointer;
   End-Pi;

   // D Spec variable Dcl Details Parameter datastructure
   Dcl-Ds inDSDclDetailsDs  Based(inDSDclDetailsPointer);
      inReqId        Char(18);
      inSrcLib       Char(10);
      inSrcPf        Char(10);
      inSrcMbr       Char(10);
      insrcType      Char(10);
      inSrcRrn       Packed(6:0);
      inSrcSeq       Packed(6:2);
      inSrcLtyp      Char(5);
      inSrcSpec      Char(1);
      inSrcLnct      Char(1);
      inSrcData      VarChar(cwSrcLength);
   End-Ds;

   // Datastructure to write pseudo code
   Dcl-Ds wkPseudoCodeDs Qualified;
      varName    Char(50) Pos(1);
      delimiter1 Char(2)  Pos(51) Inz('| ');
      dataType   Char(1)  Pos(53) Inz;                                                   //0014
      delimiter3 Char(6)  Pos(54) Inz('    | ');                                         //0008
      Length     Char(6)  Pos(60) Inz;                                                   //0014
      delimiter4 Char(3)  Pos(66) Inz(' | ');                                            //0008
      dimension  Char(4)  Pos(69) Inz;                                                   //0014
      delimiter5 Char(2)  Pos(73) Inz('| ');                                             //0008
      position   Char(4)  Pos(75) Inz;                                                   //0014
      delimiter6 Char(2)  Pos(79) Inz('| ');                                             //0008
   End-Ds;

   // Datastructure for source attributes
   Dcl-Ds wkDclAttributesDs Qualified;
      varName    Char(50);
      dataType   Char(20);
      length     Char(10);
      dimension  Char(10);
      position   Char(10);
      keywords   Char(200) Dim(15);                                                      //0014
   End-Ds;

   Dcl-S insrcDataPointer      Pointer;
   Dcl-S outPsuedocodePointer  Pointer      Inz;
   Dcl-S wkStrPos              packed(4:0)  Inz;
   Dcl-S wkEndPos              packed(4:0)  Inz;
   Dcl-S wkDclType             Char(10)     Inz;
   Dcl-S wkPseudoCode          Char(cwSrcLength) Inz;

   //Copybook declaration
/copy 'QCPYSRC/iaprderlog.rpgleinc'

   wkuDpsds.nbrparms = %parms;                                                           //0030
   EvaluatePSDS() ;                                                                      //0030
   // Main Processing

   If insrcData <> *Blanks;

      //Scan and check the type of declaration
      wkStrPos   =  %Check(' ' : inSrcData : 1);
      wkEndPos   =  %Scan(' ' : inSrcData : wkStrPos);
      //Check the positions
      If wkStrPos > *Zeros And wkEndPos = *Zeros;
         wkEndPos = %Scan(';' : inSrcData : wkStrPos);
      EndIf;
      //If start and End positions are not Zero, substring the keyword
      If wkEndPos - wkStrPos > *Zeros and wkStrPos > *Zeros;                             //0022
         wkDclType  =  %Subst(inSrcData : wkStrPos : (wkEndPos-wkStrPos));
         wkDclType  =  %xLate(cwLO:cwUP:wkDclType);
      EndIf;

      If wkDclType = cwDSpecDSSub;
         wkEndPos = %Check(' ':inSrcData : wkEndPos);                                    //0069
         inSrcData = %Subst(inSrcData : wkEndPos );                                      //0069
         wkEndPos  = wkEndPos - 1;                                                       //0069
      Endif;

      //Get the attributes of the variable declared
      insrcDataPointer  = %Addr(insrcData);
      wkDclAttributesDs = GetDSpecSrcAttributes(insrcDataPointer);

      //Populate value in the DS to write pseudo code
      If wkDclType <> cwFrDCLDS;
        wkDclAttributesDs.varName = ' ' + %Trim(wkDclAttributesDs.varName);
      Endif;

      Clear outPseudoCodeDs;                                                             //0014
      outPseudoCodeDs.outBlnkPseudoCode = wkPseudoCodeDs;                                //0014

      wkPseudoCodeDs.varName   =  wkDclAttributesDs.varName;
      wkPseudoCodeDs.dataType  =  wkDclAttributesDs.dataType;
      wkPseudoCodeDs.length    =  wkDclAttributesDs.length;
      wkPseudoCodeDs.dimension =  wkDclAttributesDs.dimension;
      wkPseudoCodeDs.position  =  wkDclAttributesDs.position;

      Clear wkPseudoCode;

      If wkBeginProc = 'Y';                                                              //0018
         %subst(outPseudoCodeDs.outDclPseudoCode : 3) = wkPseudoCodeDs;                  //0018
      Else;                                                                              //0018
         outPseudoCodeDs.outDclPseudoCode = wkPseudoCodeDs;                              //0018
      Endif;                                                                             //0018

      outPseudoCodeDs.outKeywords = wkDclAttributesDs.keywords;                          //0014

      outPsuedocodePointer = %Addr(outPseudoCodeDs);                                     //0014
      BreakAndWritePseudocode(inDSDclDetailsPointer : outPsuedocodePointer);             //0014

   EndIf;

/copy 'QCPYSRC/iaprcerlog.rpgleinc'
End-Proc iAFreeFormatDSParser;

//---------------------------------------------------------------------------------------- //0004
//FreeFormatPIPRParser : Procedure to parse Procedure Interface declaration in free format //0004
//---------------------------------------------------------------------------------------- //0004
Dcl-Proc FreeFormatPIPRParser;                                                           //0004
   Dcl-Pi FreeFormatPIPRParser;                                                          //0004
      inVarDclDetailsPointer Pointer;                                                    //0004
   End-Pi;                                                                               //0004
                                                                                         //0004
   // D Spec variable Dcl Details Parameter datastructure                               //0004
   Dcl-Ds inVarDclDetailsDs  Based(inVarDclDetailsPointer);                              //0004
      inReqId        Char(18);                                                           //0004
      inSrcLib       Char(10);                                                           //0004
      inSrcPf        Char(10);                                                           //0004
      inSrcMbr       Char(10);                                                           //0004
      insrcType      Char(10);                                                           //0004
      inSrcRrn       Packed(6:0);                                                        //0004
      inSrcSeq       Packed(6:2);                                                        //0004
      inSrcLtyp      Char(5);                                                            //0004
      inSrcSpec      Char(1);                                                            //0004
      inSrcLnct      Char(1);                                                            //0004
      inSrcData      VarChar(cwSrcLength);                                               //0004
   End-Ds;                                                                               //0004
                                                                                         //0004
   // Datastructure to write pseudo code                                                //0004
   Dcl-Ds wkPseudoCodeDs Qualified;                                                      //0004
      varName    Char(50) Pos(1);                                                        //0004
      delimiter1 Char(2)  Pos(51) Inz('| ');                                             //0004
      dataType   Char(1)  Pos(53) Inz;                                             //0008//0004
      delimiter3 Char(6)  Pos(54) Inz('    | ');                                   //0008//0004
      Length     Char(6)  Pos(60) Inz;                                             //0008//0004
      delimiter4 Char(3)  Pos(66) Inz(' | ');                                      //0008//0004
      keywords   Char(38) Pos(69) Inz;                                                   //0004
   End-Ds;                                                                               //0004
                                                                                         //0004
   // Datastructure for source attributes                                               //0004
   Dcl-Ds wkDclAttributesDs Qualified;                                                   //0004
      varName    Char(50);                                                               //0004
      dataType   Char(20);                                                               //0004
      length     Char(10);                                                               //0004
      keywords   Char(200) Dim(15);                                                      //0014
   End-Ds;                                                                               //0004
                                                                                         //0004
   Dcl-S insrcDataPointer      Pointer;                                                  //0004
   Dcl-S outPsuedocodePointer  Pointer      Inz;                                         //0004
                                                                                         //0004
   //Copy book Dcl for error handling                                                   //0004
/copy 'QCPYSRC/iaprderlog.rpgleinc'
                                                                                         //0004
   wkuDpsds.nbrparms = %parms;                                                           //0030
   EvaluatePSDS() ;                                                                      //0030
   // Main Processing                                                                   //0004
                                                                                         //0004
   //Get the attributes of the variable declared                                        //0004
   If inSrcData  <> *Blanks;                                                             //0004
      insrcDataPointer  = %Addr(insrcData);                                              //0004
      wkDclAttributesDs = GetDSpecPIPRSrcAttributes(insrcDataPointer);                   //0004
   EndIf;                                                                                //0004
                                                                                         //0004
   //Populate value in the DS to form pseudo code                                       //0004
   Clear outPseudoCodeDs;                                                                //0014
   outPseudoCodeDs.outBlnkPseudoCode = wkPseudoCodeDs;                                   //0014

   wkPseudoCodeDs.varName   = wkDclAttributesDs.varName;                                 //0004
   wkPseudoCodeDs.dataType  = wkDclAttributesDs.dataType;                                //0004
   wkPseudoCodeDs.length    = wkDclAttributesDs.Length;                                  //0004
                                                                                         //0004
   //Write the Pseudo code                                                              //0004
   If wkBeginProc = 'Y';                                                                 //0004
      %subst(outPseudoCodeDs.outDclPseudoCode : 3) = wkPseudoCodeDs;                     //0004
   Else;                                                                                 //0004
      outPseudoCodeDs.outDclPseudoCode = wkPseudoCodeDs;                                 //0004
   Endif;                                                                                //0004
                                                                                         //0004
                                                                                         //0004
   outPseudoCodeDs.outKeywords = wkDclAttributesDs.keywords;                             //0014
                                                                                         //0014
   outPsuedocodePointer = %Addr(outPseudoCodeDs);                                        //0014
   BreakAndWritePseudocode(inVarDclDetailsPointer : outPsuedocodePointer);               //0014
                                                                                         //0004
   //Copy book Dcl for error handling                                                   //0004
/copy 'QCPYSRC/iaprcerlog.rpgleinc'
end-proc;                                                                                //0004

//---------------------------------------------------------------------------------------//
//GetDSpecPIPRSrcAttributes: Procedure to get attributes of D spec source in free format //
//-------------------------------------------------------------------------------------- //
Dcl-Proc GetDSpecPIPRSrcAttributes;                                                      //0004
   Dcl-Pi GetDSpecPIPRSrcAttributes LikeDs(wkDclAttributesDs);                           //0004
      inSrcDataPointer Pointer;                                                          //0004
   End-Pi;                                                                               //0004
                                                                                         //0004
   // Datastructure for source attributes                                               //0004
   Dcl-Ds wkDclAttributesDs Qualified;                                                   //0004
      varName    Char(50);                                                               //0004
      dataType   Char(20);                                                               //0004
      length     Char(10);                                                               //0004
      keywords   Char(200) Dim(15);                                                      //0004
   End-Ds;                                                                               //0004
                                                                                         //0004
   //Work Variables declaration                                                         //0004
   Dcl-S insrcData        VarChar(cwSrcLength) Based(inSrcDataPointer);                  //0004
   Dcl-S wkDataType       Varchar(20);                                                   //0004
   Dcl-S wkKwdOpcMap      Char(10);                                                      //0004
   Dcl-S wkKeyword        VarChar(200);                                                  //0004
   Dcl-S wkString         VarChar(100);                                                  //0004
   Dcl-S wkKeywords       VarChar(200);                                                  //0004
   Dcl-S wkKeywordVal     VarChar(50);                                                   //0004
   Dcl-S wkNonBlankPos    Zoned(4:0) Inz(1);                                             //0004
   Dcl-S wkBlankPos       Zoned(4:0);                                                    //0004
   Dcl-S wkColonPos       Zoned(4:0);                                                    //0004
   Dcl-S wkOpenBrackPos   Zoned(4:0);                                                    //0004
   Dcl-S wkCloseBrackPos  Zoned(4:0);                                                    //0004
   Dcl-S wkKeywrdPos      Zoned(4:0);                                                    //0004
   Dcl-s wkDclTypeFlag    char(5);                                                       //0004
   Dcl-S wkDataTypeElem   Zoned(4:0) Inz;                                                //0004
   Dcl-S wkKeywordElem    Zoned(4:0) Inz;                                                //0004
   Dcl-S wksrcDataUpper   Like(insrcData);                                               //0004
   Dcl-S wkKeywordIdx    Zoned(4:0) Inz;                                                 //0014
                                                                                         //0004
   //Copy book Dcl for error handling                                                   //0004
/copy 'QCPYSRC/iaprderlog.rpgleinc'
                                                                                         //0004
   //Constant declaration                                                               //0004
   Dcl-C cwDCLPI         'DCL-PI';                                                       //0004
   Dcl-C cwENDPI         'END-PI';                                                       //0004
   Dcl-C cwDCLPR         'DCL-PR';                                                       //0004
   Dcl-C cwENDPR         'END-PR';                                                       //0004
   Dcl-C cwDCLPARM       'DCL-PARM';                                                     //0004
                                                                                         //0004
   wkuDpsds.nbrparms = %parms;                                                           //0030
   EvaluatePSDS() ;                                                                      //0030
   Exsr InitSr;                                                                          //0004
   Exsr MainSr;                                                                          //0004
                                                                                         //0004
   Return wkDclAttributesDs;                                                             //0004
                                                                                         //0004
   //-------------------------------------------------------------------------//        //0004
   //Subroutine to initialize                                                           //0004
   //-------------------------------------------------------------------------//        //0004
   Begsr InitSr;                                                                         //0004
      inSrcData = %trim(inSrcData);                                                      //0004
      wkSrcDataUpper = %Xlate(cwLO:cwUP:inSrcData);                                      //0004
                                                                                         //0004
      //Remove semicolon                                                                //0004
      If %scan(';' : wksrcDataUpper) > 0;                                                //0004
         inSrcData = %replace(' ' : inSrcData : %len(%trim(inSrcData)) : 1);             //0004
      Endif;                                                                             //0004
                                                                                         //0004
      //Remove END-PI/END-PR                                                            //0004
      If %scan(cwENDPI : wksrcDataUpper) > 0 or                                          //0004
         %scan(cwENDPR : wksrcDataUpper) > 0;                                            //0004
         inSrcData = %subst(inSrcData : 1 : %len(%trim(inSrcData)) - 6);                 //0004
      Endif;                                                                             //0004
                                                                                         //0004
      Select;                                                                            //0004
      //Remove DCL-PI                                                                   //0004
      when %scan(cwDCLPI  : wksrcDataUpper) > 0;                                         //0004
         inSrcData      = %triml(%subst(inSrcData : 7 ));                                //0004
         wkDclTypeFlag = 'DCLPI';                                                        //0004
                                                                                         //0004
      //Remove DCL-PR                                                                   //0004
      when %scan(cwDCLPR  : wksrcDataUpper) > 0;                                         //0004
         inSrcData      = %triml(%subst(inSrcData : 7 ));                                //0004
         wkDclTypeFlag = 'DCLPR';                                                        //0004
                                                                                         //0004
      //Remove DCL-PARM                                                                 //0004
      when %scan(cwDCLPARM : wksrcDataUpper) > 0 ;                                       //0004
         inSrcData  = %triml(%subst(inSrcData : 9 ));                                    //0004
      Endsl;                                                                             //0004
                                                                                         //0004
   Endsr;                                                                                //0004
                                                                                         //0004
   //-------------------------------------------------------------------------//        //0004
   //Subroutine for Main PGM Logic                                                      //0004
   //-------------------------------------------------------------------------//        //0004
   Begsr MainSr;                                                                         //0004
      Exsr getName;                                                                      //0004
                                                                                         //0004
      Exsr getDataType;                                                                  //0004
                                                                                         //0004
      If wkDclAttributesDs.dataType <> *blanks;                                          //0004
         Exsr getLength;                                                                 //0004
         wkKeywrdPos = wkBlankPos;                                                       //0004
      Endif;                                                                             //0004
                                                                                         //0004
      Exsr getKeywords;                                                                  //0004
   Endsr;                                                                                //0004
                                                                                         //0004
   //-------------------------------------------------------------------------//        //0004
   //Subroutine to get PI Name                                                          //0004
   //-------------------------------------------------------------------------//        //0004
   Begsr getName;                                                                        //0004
      //Fetch name of PI                                                                //0004
      wkBlankPos = %scan(' ' : inSrcData);                                               //0004
      If wkBlankPos > 0;                                                                 //0004
         wkDclAttributesDs.varName = %subst(inSrcData : 1 : wkBlankPos);                 //0004
      Endif;                                                                             //0004
                                                                                         //0004
      //2 Space Indentation for PI/PR Parameters                                        //0004
      If wkDclTypeFlag = ' ' and wkDclAttributesDs.varName <> *blanks;                   //0004
         wkDclAttributesDs.varName = '  ' + %trim(wkDclAttributesDs.varName);            //0004
      Endif;                                                                             //0004
                                                                                         //0004
      //If only PI name is there we will not check further for data type..              //0004
      If wkBlankPos <> 0;                                                                //0004
         wkNonBlankPos = %check(' ' : inSrcData : wkBlankPos);                           //0004
         If wkNonBlankPos = 0;                                                           //0004
            return wkDclAttributesDs;                                                    //0004
         Endif;                                                                          //0004
      Endif;                                                                             //0004
      wkSrcDataUpper = %xlate(cwLO:cwUP:inSrcData);                                      //0004
   Endsr;                                                                                //0004
                                                                                         //0004
   //-------------------------------------------------------------------------//        //0004
   //Subroutine to get the  Data type                                                   //0004
   //-------------------------------------------------------------------------//        //0004
   Begsr getDataType;                                                                    //0004
      wkKeywrdPos = wkNonBlankPos;                                                       //0004
      wkBlankPos = %scan(' ' : wkSrcDataUpper : wkNonBlankPos);                          //0004
      wkOpenBrackPos = %scan('(' : wkSrcDataUpper : wkNonBlankPos);                      //0004
      If wkOpenBrackPos > 0  and wkOpenBrackPos < wkBlankPos;                            //0004
         wkBlankPos = wkOpenBrackPos;                                                    //0004
      Endif;                                                                             //0004
                                                                                         //0004
      //Fetch the return data type for PI                                               //0004
      If wkBlankPos > wkNonBlankPos;                                                     //0004
         wkDataType = %Subst(wkSrcDataUpper : wkNonBlankPos                              //0004
                                            : wkBlankPos - wkNonBlankPos);               //0004
      EndIf;                                                                             //0004
                                                                                         //0004
      //Get the source mapping for the data type                                        //0004
      If wkDataType <> *blanks;                                                          //0004
         wkDataTypeElem = %Lookup( wkDataType       :                                    //0004
                                   DSpecMappingDs(*).dsKeywrdOpcodeName : 1 :            //0004
                                   %Elem(DSpecMappingDs) );                              //0004
      Endif;                                                                             //0004
                                                                                         //0004
      If wkDataTypeElem > *Zeros and                                                     //0004
         DSpecMappingDs(wkDataTypeElem).DsActionType = *Blanks ;                         //0004
         wkDclAttributesDs.dataType = DSpecMappingDs(wkDataTypeElem).dsSrcMapping;       //0004
      EndIf;                                                                             //0004
                                                                                         //0004
      //If only data type is present we will not check further for length/keywords      //0004
      wkNonBlankPos = %check(' ' : wkSrcDataUpper : wkBlankPos);                         //0004
      If wkNonBlankPos =  0;                                                             //0004
         return wkDclAttributesDs;                                                       //0004
      Endif;                                                                             //0004
   Endsr;                                                                                //0004
                                                                                         //0004
   //-------------------------------------------------------------------------//        //0004
   //Subroutine to get the Data type length                                             //0004
   //-------------------------------------------------------------------------//        //0004
   Begsr getLength;                                                                      //0004
      If wkOpenBrackPos = wkNonBlankPos;                                                 //0004
         wkCloseBrackPos = %scan(')' : wkSrcDataUpper : wkOpenBrackPos + 1);             //0004
         If wkCloseBrackPos - wkOpenBrackPos > 1;                                        //0004
            wkDclAttributesDs.length = %subst(wkSrcDataUpper : wkOpenBrackPos + 1        //0004
                                       : wkCloseBrackPos - wkOpenBrackPos - 1);          //0004
                                                                                         //0004
            //Truncate length to '3 :   0' to '3:0'                                     //0004
            wkColonPos = %scan(':' : wkDclAttributesDs.length);                          //0004
            If wkColonPos > 1 and wkDclAttributesDs.length <> *blanks;                   //0004
               wkDclAttributesDs.length =                                                //0004
                 %trim(%subst(wkDclAttributesDs.length : 1 : wkColonPos - 1))            //0004
                     + ':' +                                                             //0004
                 %trim(%subst(wkDclAttributesDs.length : wkColonPos + 1));               //0004
            Endif;                                                                       //0004
                                                                                         //0004
            wkBlankPos = wkCloseBrackPos + 1;                                            //0004
         Endif;                                                                          //0004
      Endif;                                                                             //0004
   Endsr;                                                                                //0004
                                                                                         //0004
   //-------------------------------------------------------------------------//        //0004
   //Subroutine to get the Keyword                                                      //0004
   //-------------------------------------------------------------------------//        //0004
   Begsr getKeywords;                                                                    //0004
      If wkKeywrdPos > 0;                                                                //0004
         wkKeywords = %triml(%subst(wksrcDataUpper : wkKeywrdPos));                      //0004
      Endif;                                                                             //0004
                                                                                         //0004
      //Only process if keywords are found                                              //0004
      If wkKeywords <> *blanks;                                                          //0004
         wkBlankPos = %scan(' ' : wkKeywords);                                           //0004
                                                                                         //0004
         Dow wkBlankPos <> 0;                                                            //0004
            Exsr calculateBlankPos;
            If wkBlankPos > 1;                                                           //0004
               wkString = %subst(wkKeywords : 1 : wkBlankPos - 1);                       //0004
            Endif;                                                                       //0004
            Exsr fetchKeywordValue;                                                      //0004

            If wkBlankPos > 1;                                                           //0022
               wkKeywords = %triml(%subst(wkKeywords : wkBlankPos));                     //0022
            Endif;                                                                       //0022
            If wkKeywords = *blanks;                                                     //0004
               leave;                                                                    //0004
            endif;                                                                       //0004
            wkBlankPos = %scan(' ' : %trim(wkKeywords));                                 //0004
            If wkBlankPos = 0;                                                           //0004
               wkString = wkKeywords;                                                    //0004
               Exsr fetchKeywordValue;                                                   //0004
            Endif;                                                                       //0004
         Enddo;                                                                          //0004
      EndIf;                                                                             //0004
                                                                                         //0004
   Endsr;                                                                                //0004
                                                                                         //0004
   //-------------------------------------------------------------------------//        //0004
   //Subroutine to calculate Blank Position if its in brackets                          //0004
   //-------------------------------------------------------------------------//        //0004
   Begsr calculateBlankPos;                                                              //0004
      wkNonBlankPos   = %check(' ' : wkKeywords : wkBlankPos);                           //0004
      wkOpenBrackPos  = %scan ('(' : wkKeywords);                                        //0004
      wkCloseBrackPos = %scan (')' : wkKeywords);                                        //0004
                                                                                         //0004
      //If Blank is between brackets or before open Bracket                             //0004
      //LIKEDS( VALUEDS ) / LIKEDS (VALUEDS)  then take Blank after ')'                 //0004
      If wkCloseBrackPos > 0 and                                                         //0004
        ( (wkNonBlankPos > 0 and                                                         //0004
           %subst(wkKeywords : wkNonBlankPos : 1) = '(' ) or                             //0004
        (wkBlankPos > wkOpenBrackPos and wkBlankPos < wkCloseBrackPos) );                //0004
                                                                                         //0004
         wkBlankPos  = wkCloseBrackPos + 1;                                              //0004
      Endif;                                                                             //0004
                                                                                         //0004
   Endsr;                                                                                //0004
   //-------------------------------------------------------------------------//        //0004
   //Subroutine to get the Keyword value                                                //0004
   //-------------------------------------------------------------------------//        //0004
   Begsr fetchKeywordValue;                                                              //0004
      clear wkKeyword;                                                                   //0004
      clear wkKeywordVal ;                                                               //0004
      clear wkKeywordElem;                                                               //0004
      wkString = %triml(wkString);                                                       //0004
      wkOpenBrackPos = %scan('(' : wkString );                                           //0004
      select;                                                                            //0004
      when wkOpenBrackPos = 0;                                                           //0004
         wkKeyword = wkString;                                                           //0004
      when wkOpenBrackPos > 1;                                                           //0004
         wkKeyword = %subst(wkString : 1 : wkOpenBrackPos - 1);                          //0004
         wkCloseBrackPos = %scan(')' : wkString : wkOpenBrackPos + 1 );                  //0004
         If wkCloseBrackPos - wkOpenBrackPos > 1;                                        //0004
            wkKeywordVal = %subst(wkString : wkOpenBrackPos + 1                          //0004
                                           : wkCloseBrackPos - wkOpenBrackPos - 1);      //0004

            //If multivalue keyword found enclose them in Brackets                      //0004
            //Options: (*OMIT : *NOPASS)                                                //0004
            wkColonPos = %scan(':' : wkKeywordVal);                                      //0004
            If wkColonPos > 0 and wkKeywordVal <> *blanks;                               //0004
               wkKeywordVal = '(' + %trim(wkKeywordVal) + ')';                           //0004
            Endif;                                                                       //0004
         Endif;                                                                          //0004
      Endsl;                                                                             //0004
                                                                                         //0004
      If wkKeyword <> *blanks;                                                           //0004
         wkKeywordElem = %Lookup( wkKeyword        :                                     //0004
                            DSpecMappingDs(*).dsKeywrdOpcodeName : 1 :                   //0004
                            %Elem(DSpecMappingDs) );                                     //0004
      Endif;                                                                             //0004
                                                                                         //0004
      If wkKeywordElem > 0;                                                              //0004
         wkKwdOpcMap = %trim(DSpecMappingDs(wkKeywordElem).dsSrcMapping);                //0004
                                                                                         //0004
         //For DIM keyword we don't have mapping                                        //0004
         If wkKwdOpcMap <> *blanks;                                                      //0004
            wkKeyword = wkKwdOpcMap;                                                     //0004
         Endif;                                                                          //0004
         If wkKeywordVal <> *blanks;                                                     //0004
            wkKeyword = %trim(wkKeyword) + ' ' + %trim(wkKeywordVal);                    //0004
         Endif;                                                                          //0004
                                                                                         //0004
         If wkKeywordIdx < %Elem(wkDclAttributesDs.keywords);                            //0014
            wkKeywordIdx += 1;                                                           //0014
            wkDclAttributesDs.keywords(wkKeywordIdx) =  wkKeyword;                       //0014
                                                                                         //0014
         EndIf;                                                                          //0014
      Endif;                                                                             //0004
                                                                                         //0004
   Endsr;                                                                                //0004
                                                                                         //0004
   //Copy book Dcl for error handling                                                   //0004
/copy 'QCPYSRC/iaprcerlog.rpgleinc'
                                                                                         //0004
end-proc;                                                                                //0004


//---------------------------------------------------------------------------------------//
//WriteGlossary: Procedure to write the Glossary, mentioning the meaning of the          //
//               abbreviations at the end of the Pseudocode document.                    //
//-------------------------------------------------------------------------------------- //
Dcl-Proc WriteGlossary Export;                                                           //0008
                                                                                         //0008
   Dcl-Pi WriteGlossary;                                                                 //0008
      inSrcDataPointer Pointer;                                                          //0008
   End-Pi;                                                                               //0008
                                                                                         //0008
   // Glossary Details Parameter datastructure                                          //0008
   Dcl-Ds inSrcDataDs  Based(inSrcDataPointer);                                          //0008
      inReqId        Char(18);                                                           //0008
      inSrcLib       Char(10);                                                           //0008
      inSrcPf        Char(10);                                                           //0008
      inSrcMbr       Char(10);                                                           //0008
      insrcType      Char(10);                                                           //0008
   End-Ds;                                                                               //0008
                                                                                         //0008
   // Datastructure  to store mapping details                                           //0008
   Dcl-Ds wkSrcMappingDs Qualified Dim(100);                                             //0008
      srcData Char(cwSrcLength);                                                         //0008
   End-Ds;                                                                               //0008
                                                                                         //0008
   // Datastructure to write the Pseudocode                                             //0008
   Dcl-Ds wkWritePseudoCodeDs Qualified Dim(100);                                        //0008
      reqId      Char(18);                                                               //0008
      srcLib     Char(10);                                                               //0008
      srcPf      Char(10);                                                               //0008
      srcMbr     Char(10);                                                               //0008
      srcType    Char(10);                                                               //0008
      docSeq     Like(wkdocSeq);                                                         //0008
      pseudoCode Char(cwSrcLength);                                                      //0008
   End-Ds;                                                                               //0008
                                                                                         //0008
   //Work Variables declaration                                                         //0008
   Dcl-S outParmPointer  Pointer           Inz;                                          //0008
   Dcl-S wkSrcType       Char(10)          Inz('RPGLE');                                 //0008
   Dcl-S wkRcdCount      Zoned(4:0)        Inz;                                          //0008
   Dcl-S rcdIndex        Like(wkRcdCount)  Inz;                                          //0008
                                                                                         //0008
   Dcl-C cwGLOSSARY      Const('GLOSSARY');                                              //0008
                                                                                         //0008
   //Copybook declaration for error handling                                            //0008
/copy 'QCPYSRC/iaprderlog.rpgleinc'
                                                                                         //0008
   //Intialize Global PipeIndent to remove any Junk values Holding                      //0055
   wkPipeIndentSave=*Blanks;                                                             //0055
   wkuDpsds.nbrparms = %parms;                                                           //0030
   EvaluatePSDS() ;                                                                      //0030
   Exsr WriteGlossaryHeader;                                                             //0008
                                                                                         //0008
   Exsr GetGlossaryDetails;                                                              //0008
                                                                                         //0008
   //Subroutine to write glossary header                                                //0008
   Begsr WriteGlossaryHeader;                                                            //0008
                                                                                         //0008
      Clear specHeaderDs;                                                                //0008

      If insrcType = 'RPG' or insrcType = 'SQLRPG' ;                                     //0046
         Exec Sql                                                                        //0046
            Select COALESCE(Max(iADocSeq),0) into :wkDocSeq                              //0046
            from IaPseudoCP Where iAReqId = :inReqId ;                                   //0046
      EndIf ;                                                                            //0046
                                                                                         //0008
      // Write the header for Glossary                                                  //0008
      specHeaderDs = inSrcDataDs;                                                        //0008
      outParmPointer = %Addr(specHeaderDs);                                              //0008
      iAWriteSpecHeader(outParmPointer);                                                 //0008
                                                                                         //0008
   EndSr;                                                                                //0008
                                                                                         //0008
   //Subroutine to get glossary details from mapping file & then write in pseudocode file
   Begsr GetGlossaryDetails;                                                             //0008
                                                                                         //0008
      //Declare cursor to get glossary details from mapping file                        //0008
      Exec Sql                                                                           //0008
         Declare GetGlossaryDtlCursor Cursor For                                         //0008
            Select Src_Mapping                                                           //0008
               From IaPseudoKp                                                           //0008
               Where Srcmbr_Type    = :wkSrcType And                                     //0008
                     Keyword_Opcode = :cwGLOSSARY                                        //0008
               Order By Seq_No                                                           //0008
               For Fetch Only;                                                           //0008
                                                                                         //0008
      Exec Sql Open GetGlossaryDtlCursor;                                                //0008
                                                                                         //0008
      If SqlCode = Csr_Opn_Cod;                                                          //0008
         Exec Sql Close GetGlossaryDtlCursor;                                            //0008
         Exec Sql Open  GetGlossaryDtlCursor;                                            //0008
      EndIf;                                                                             //0008
                                                                                         //0008
      If SqlCode < SuccessCode;                                                          //0008
         uDpsds.wkQuery_Name = 'Open_GetGlossaryDtlCursor';                              //0008
         IaSqlDiagnostic(uDpsds);                                                        //0008
      EndIf;                                                                             //0008
                                                                                         //0008
      If SqlCode = successCode;                                                          //0008
         wkRcdCount = %Elem(wkSrcMappingDs);                                             //0008
                                                                                         //0008
      //Fetch the glossary details from mapping file                                    //0008
         Exec Sql                                                                        //0008
            Fetch GetGlossaryDtlCursor                                                   //0008
               For  :wkRcdCount Rows                                                     //0008
               Into :wkSrcMappingDs;                                                     //0008
                                                                                         //0008
         If Sqlcode = successCode;                                                       //0008
                                                                                         //0008
            //Populate the number of records fetched in wkRcdCount                      //0008
            wkRcdCount = SqlEr3;                                                         //0008
            Exsr WriteGlossaryDetails;                                                   //0008
                                                                                         //0008
         EndIf;                                                                          //0008
                                                                                         //0008
      EndIf;                                                                             //0008
                                                                                         //0008
   EndSr;                                                                                //0008
                                                                                         //0008
   //Subroutine to write glossary details in pseudocode file                            //0008
   Begsr WriteGlossaryDetails;                                                           //0008
                                                                                         //0008
      For rcdIndex = 1 to wkRcdCount;                                                    //0008
         wkWritePseudoCodeDs(rcdIndex).reqId       = inReqId;                            //0008
         wkWritePseudoCodeDs(rcdIndex).srcLib      = inSrcLib;                           //0008
         wkWritePseudoCodeDs(rcdIndex).srcPf       = inSrcPf;                            //0008
         wkWritePseudoCodeDs(rcdIndex).srcMbr      = inSrcMbr;                           //0008
         wkWritePseudoCodeDs(rcdIndex).srcType     = insrcType;                          //0008
         wkDocSeq += 1;                                                                  //0008
         wkWritePseudoCodeDs(rcdIndex).docSeq      = wkDocSeq;                           //0008
         wkWritePseudoCodeDs(rcdIndex).pseudoCode  =                                     //0008
                         wkSrcMappingDs(rcdIndex).srcData;                               //0008
      EndFor;                                                                            //0008
                                                                                         //0008
      Exec Sql                                                                           //0008
         Insert Into IAPSEUDOCP ( iAReqId,                                               //0008
                                  iAMbrLib,                                              //0008
                                  iASrcFile,                                             //0008
                                  iAMbrNam,                                              //0008
                                  iAMbrTyp,                                              //0008
                                  iADocSeq,                                              //0008
                                  iAGenPsCde)                                            //0008
                  :wkRcdCount Rows                                                       //0008
                  Values (:wkWritePseudoCodeDs);                                         //0008
                                                                                         //0008
      If SqlCode < SuccessCode;                                                          //0008
         uDpsds.wkQuery_Name = 'Insert_IAPSEUDOCP';                                      //0008
         IaSqlDiagnostic(uDpsds);                                                        //0008
      EndIf;                                                                             //0008
                                                                                         //0008
   EndSr;                                                                                //0008
                                                                                         //0008
   //Copybook declaration for error handling                                            //0008
/copy 'QCPYSRC/iaprcerlog.rpgleinc'
End-Proc WriteGlossary;                                                                  //0008

//------------------------------------------------------------------------------------- //
//BreakAndWritePseudocode:Procedure to break Pseudocode according to max doc length     //
//                        and write it.                                                 //
//------------------------------------------------------------------------------------- //
Dcl-Proc BreakAndWritePseudocode;                                                        //0014

   Dcl-Pi BreakAndWritePseudocode;                                                       //0014
      inSrcDataPointer       Pointer;                                                    //0014
      inPseudoCodePointer    Pointer;                                                    //0014
   End-Pi;                                                                               //0014
                                                                                         //0014
   //Input datastructure for source details.                                            //0014
   Dcl-Ds inSrcDataDs Based(inSrcDataPointer);                                           //0014
      inReqId        Char(18);                                                           //0014
      inSrcLib       Char(10);                                                           //0014
      inSrcPf        Char(10);                                                           //0014
      inSrcMbr       Char(10);                                                           //0014
      insrcType      Char(10);                                                           //0014
      inSrcRrn       Packed(6:0);                                                        //0014
      inSrcSeq       Packed(6:2);                                                        //0014
      inSrcLtyp      Char(5);                                                            //0014
      inSrcSpec      Char(1);                                                            //0014
   End-Ds;                                                                               //0014
                                                                                         //0014
   //Input datastructure for source attributes.                                         //0014
   Dcl-Ds inPseudoCodeDs Based(inPseudoCodePointer);                                     //0014
      inDclPseudoCode  Char(200);                                                        //0014
      inBlnkPseudoCode Char(200);                                                        //0014
      inKeywords       Char(200) Dim(15);                                                //0014
   End-Ds;                                                                               //0014
                                                                                         //0014
   Dcl-C cwMAXDOCLEN           Const(109);                                               //0014
                                                                                         //0014
   Dcl-S wkKeywordIdx          Packed(4:0)       Inz(1);                                 //0014
   Dcl-S keywordsCount         Packed(4:0)       Inz;                                    //0014
   Dcl-S keywordLen            Packed(4:0)       Inz(1);                                 //0014
   Dcl-S keywordStrPos         Packed(4:0)       Inz(1);                                 //0014
   Dcl-S outPsuedocodePointer  Pointer           Inz;                                    //0014
   Dcl-S wkPseudoCode          Char(cwMAXDOCLEN) Inz;                                    //0014
   Dcl-S wkKeywords            Like(inKeywords);                                         //0014
   Dcl-S noIdxIncInd           Ind               Inz(*off);                              //0014
                                                                                         //0014
   //Copybook declaration                                                               //0014
/copy 'QCPYSRC/iaprderlog.rpgleinc'
                                                                                         //0014
   wkuDpsds.nbrparms = %parms;                                                           //0030
   EvaluatePSDS() ;                                                                      //0030
   Exsr Initialise;                                                                      //0014
                                                                                         //0014
   //If keywords are not present then write pseudocode,                                 //0014
   //else process keywords first then write.                                            //0014
   If inKeywords(wkKeywordIdx) = *Blanks;                                                //0014
      Exsr WritePseudoCodeSr;                                                            //0014
   Else;                                                                                 //0014
      Exsr WritePseudoCodeWithKeywords;                                                  //0014
   EndIf;                                                                                //0014
                                                                                         //0014
   //---------------------------------------------------------------------------------- //0014
   //Subroutine to initialise the required values.                                      //0014
   //---------------------------------------------------------------------------------- //0014
   BegSr Initialise;                                                                     //0014
                                                                                         //0014
      //Populate source details in DS to write pseudo code.                             //0014
      Clear writePseudoCodeDs;                                                           //0014
      writePseudoCodeDs.reqId   = inReqId;                                               //0014
      writePseudoCodeDs.srcLib  = inSrcLib;                                              //0014
      writePseudoCodeDs.srcPf   = inSrcPf;                                               //0014
      writePseudoCodeDs.srcMbr  = inSrcMbr;                                              //0014
      writePseudoCodeDs.srcType = inSrcType;                                             //0014
      writePseudoCodeDs.SrcRrn  = inSrcRrn;                                              //0014
      writePseudoCodeDs.SrcSeq  = inSrcSeq;                                              //0014
      writePseudoCodeDs.SrcLTyp = inSrcLtyp;                                             //0014
      writePseudoCodeDs.srcSpec = inSrcSpec;                                             //0014
                                                                                         //0014
      wkPseudoCode = %TrimR(inDclPseudoCode);                                            //0014
   EndSr;                                                                                //0014
                                                                                         //0014
   //---------------------------------------------------------------------------------- //0014
   //Subroutine to handle keywords parsing and then write the pseudocode.               //0014
   //---------------------------------------------------------------------------------- //0014
   BegSr WritePseudoCodeWithKeywords;                                                    //0014
                                                                                         //0014
      keywordLen    = cwMAXDOCLEN - %Len(%TrimR(wkPseudoCode));                          //0014
      keywordsCount = %LookUp('':inKeywords);                                            //0014
                                                                                         //0014
      //If all the elements of array inKeywords has data then keywordsCount             //0014
      //will be equal the total number of elements.                                     //0014
      If keywordsCount > *Zeros;                                                         //0014
         keywordsCount -= 1;                                                             //0014
      Else;                                                                              //0014
         keywordsCount = %Elem(inKeywords);                                              //0014
      EndIf;                                                                             //0014
                                                                                         //0014
      For wkKeywordIdx = 1 To keywordsCount;                                             //0014
                                                                                         //0014
         //keep adding keywords to keyword section until pseudocode is less             //0014
         //than doc max length.                                                         //0014
         If %Len(%TrimR(wkPseudoCode)) +                                                 //0014
            %Len(%Trim(wkKeywords)) +                                                    //0014
            %Len(%Trim(inKeywords(wkKeywordIdx))) < cwMAXDOCLEN - 1;                     //0014
                                                                                         //0014
            Exsr BuildPseudoCode;                                                        //0014
                                                                                         //0014
            //If current index value is < total keywords count in array, turn on        //0014
            //noIdxIncInd to handle increment of array index.                           //0014
            If wkKeywordIdx < keywordsCount;                                             //0014
               noIdxIncInd = *On;                                                        //0014
               Iter;                                                                     //0014
             Else;                                                                       //0014
               noIdxIncInd = *Off;                                                       //0014
            EndIf;                                                                       //0014
                                                                                         //0014
         EndIf;                                                                          //0014
                                                                                         //0014
         Exsr HandleWritePseudoCode;                                                     //0014
         Clear wkKeywords;                                                               //0014
                                                                                         //0014
         //If noIdxIncInd is On, it means current index keyword is yet to be processed. //0014
         If noIdxIncInd = *On;                                                           //0014
            noIdxIncInd = *Off;                                                          //0014
            wkKeywordIdx  -= 1;                                                          //0014
         EndIf;                                                                          //0014
                                                                                         //0014
      EndFor;                                                                            //0014
   EndSr;                                                                                //0014
                                                                                         //0014
   //---------------------------------------------------------------------------------- //0014
   //Subroutine to form the keyword section of the pseudocode.                          //0014
   //---------------------------------------------------------------------------------- //0014
   BegSr BuildPseudoCode;                                                                //0014
                                                                                         //0014
      If wkkeywords = *Blanks;                                                           //0014
         wkkeywords = inkeywords(wkKeywordIdx);                                          //0014
      Else;                                                                              //0014
         wkkeywords = %Trim(wkkeywords) + ', '  +                                        //0014
                      %Trim(inkeywords(wkKeywordIdx));                                   //0014
      EndIf;                                                                             //0014
   EndSr;                                                                                //0014
                                                                                         //0014
   //---------------------------------------------------------------------------------- //0014
   //Subroutine to handle overflow of values if any & write the pseudocode.             //0014
   //---------------------------------------------------------------------------------- //0014
   BegSr HandleWritePseudoCode;                                                          //0014
                                                                                         //0014
      If wkkeywords <> *Blanks;                                                          //0014
         Exsr WritePseudoCodeSr;                                                         //0014
      Else;                                                                              //0014
                                                                                         //0014
         Dow keywordStrPos > *Zeros And                                                  //0014
             keywordStrPos <= %Len(%Trim(inKeywords(wkKeywordIdx) ));                    //0014
            wkkeywords = %SubSt(inKeywords(wkKeywordIdx) : keywordStrPos);               //0014
                                                                                         //0014
            Exsr WritePseudoCodeSr;                                                      //0014
            keywordStrPos = keywordStrPos + keywordLen - 1;                              //0014
         EndDo;                                                                          //0014
                                                                                         //0014
      EndIf;                                                                             //0014
   EndSr;                                                                                //0014
                                                                                         //0014
   //---------------------------------------------------------------------------------- //0014
   //Subroutine to write pseudocode.                                                    //0014
   //---------------------------------------------------------------------------------- //0014
   BegSr WritePseudoCodeSr;                                                              //0014
                                                                                         //0014
      wkPseudoCode = %TrimR(wkPseudoCode) + ' ' + wkkeywords;                            //0014
      writePseudoCodeDs.pseudoCode = wkPseudoCode;                                       //0014
                                                                                         //0014
      outPsuedocodePointer = %Addr(WritePseudoCodeDs);                                   //0014
      WritePseudoCode(outPsuedocodePointer);                                             //0014
                                                                                         //0014
      wkPseudoCode = inBlnkPseudoCode;                                                   //0014
   EndSr;                                                                                //0014
                                                                                         //0014
   //Copy book Dcl for error handling                                                   //0014
/copy 'QCPYSRC/iaprcerlog.rpgleinc'
                                                                                         //0014
End-Proc BreakAndWritePseudocode;                                                        //0014

//------------------------------------------------------------------------------------- //0023
//FreeFormatConstParser:Procedure to write Pseudocode for const Dcl in free format      //0023
//------------------------------------------------------------------------------------- //0023
Dcl-Proc FreeFormatConstParser;                                                          //0023
                                                                                         //0023
   Dcl-Pi FreeFormatConstParser LikeDs(outPseudoCodeDs);                                 //0023
      inConstDetailsPointer Pointer;                                                     //0023
   End-Pi;                                                                               //0023
                                                                                         //0023
   // D Spec variable Dcl Details Parameter datastructure                               //0023
   Dcl-S inSrcData VarChar(cwSRCLENGTH) Based(inConstDetailsPointer);                    //0023
                                                                                         //0023
   // Datastructure to write pseudo code                                                //0023
   Dcl-Ds wkPseudoCodeDs Qualified;                                                      //0023
      constName  Char(50) Pos(1)  Inz;                                                   //0023
      delimiter1 Char(2)  Pos(51) Inz('| ');                                             //0023
   End-Ds;                                                                               //0023
                                                                                         //0023
   // Datastructure for source attributes                                               //0023
   Dcl-Ds wkDclAttributesDs Qualified;                                                   //0023
      varName    Char(50);                                                               //0023
      dataType   Char(20);                                                               //0023
      length     Char(10);                                                               //0023
      dimension  Char(10);                                                               //0023
      position   Char(10);                                                               //0023
      keywords   Char(200) Dim(15);                                                      //0023
   End-Ds;                                                                               //0023
                                                                                         //0023
   Dcl-S wkOpnBr               Zoned(4:0)   Inz;                                         //0023
   Dcl-S wkCloBr               Zoned(4:0)   Inz;                                         //0023
   Dcl-S wkValue               Like(wkDclAttributesDs.keywords);                         //0023
   Dcl-C cwCONST               'CONST';                                                  //0023
   Dcl-S wkBifCheckSrc         VarChar(cwSRCLENGTH) Inz;                                 //0096
                                                                                         //0023
   //Copybook declaration                                                               //0023
/copy 'QCPYSRC/iaprderlog.rpgleinc'
                                                                                         //0023
   wkuDpsds.nbrparms = %parms;                                                           //0030
   EvaluatePSDS() ;                                                                      //0030
   // Main Processing                                                                   //0023
                                                                                         //0023
   constDclInd = *On;                                                                    //0023
   //Get the attributes of the variable declared                                        //0023
   wkDclAttributesDs = GetDSpecSrcAttributes(inConstDetailsPointer);                     //0023
                                                                                         //0023
   Clear outPseudoCodeDs;                                                                //0023
   outPseudoCodeDs.outBlnkPseudoCode = wkPseudoCodeDs;                                   //0023
                                                                                         //0023
   //Populate value in the DS to form pseudo code                                       //0023
   wkPseudoCodeDs.constName = wkDclAttributesDs.varName;                                 //0023
   wkValue                  = wkDclAttributesDs.keywords(1);                             //0023
                                                                                         //0023
   //Check if CONST keyword is present, fetch the value inside it.                      //0023
   If %Scan(cwCONST : %Xlate(cwLo:cwUp:wkValue) : 1) = 1;                                //0023
      wkOpnBr = %Scan('(': wkValue : 1);                                                 //0023
      wkCloBr = %ScanR(')': wkValue : 1);                                                //0023
                                                                                         //0023
      If wkOpnBr > *Zeros and wkCloBr > wkOpnBr + 1;                                     //0023
         wkValue = %Trim(%Subst(wkValue                 :                                //0023
                                wkOpnBr + 1             :                                //0023
                                wkCloBr - wkOpnBr - 1) );                                //0023
      Else;                                                                              //0023
         wkValue = *Blanks;                                                              //0023
      EndIf;                                                                             //0023
                                                                                         //0023
   EndIf;                                                                                //0023
                                                                                         //0096
   //If const value is defined using BIF                                                //0096
   If %Scan('%' : wkValue  : 1) = 1     And                                              //0096
      %Scan('(' : wkValue  : %Scan('%' : %Trim(wkValue) : 1))  >                         //0096
      %Scan('%' : wkValue  : 1);                                                         //0096
                                                                                         //0096
      wkBifCheckSrc     =   wkValue;                                                     //0096
      bifSourcePointer  =   %Addr(wkBifCheckSrc);                                        //0096
                                                                                         //0096
      wkValue  =  ProcessDspecBIF(bifSourcePointer);                                     //0096
                                                                                         //0096
      Clear WritePseudoCodeDs;                                                           //0096
   EndIf;                                                                                //0096
                                                                                         //0096
                                                                                         //0023
   //Populate the const name, value in outPseudoCodeDs to break & write the pseudocode. //0023
   //outPseudoCodeDs.outDclPseudoCode = wkPseudoCodeDs;                                  //0058
   //Apply Indent, when Constant Declared inside Procedure                              //0058
   If wkBeginProc = 'Y';                                                                 //0058
      %subst(outPseudoCodeDs.outDclPseudoCode : 3) = wkPseudoCodeDs;                     //0058
   Else;                                                                                 //0058
      outPseudoCodeDs.outDclPseudoCode = wkPseudoCodeDs;                                 //0058
   Endif;                                                                                //0058
   //outPseudoCodeDs.outKeywords(1)   = wkValue;                        //0096           //0023
   outPseudoCodeDs.outKeywords(1)   =   %Trim(wkValue);                                  //0096
   constDclInd = *Off;                                                                   //0023
                                                                                         //0023
   Return outPseudoCodeDs;                                                               //0023
                                                                                         //0023
   //Copy book Dcl for error handling                                                   //0023
/copy 'QCPYSRC/iaprcerlog.rpgleinc'
                                                                                         //0023
End-Proc FreeFormatConstParser;                                                          //0023
//------------------------------------------------------------------------------------- //0024
//GetLastRrnOfMainLogic - Procedure get last executable code line's rrn from main logic //0024
//                        and begining rrn of main logic.                               //0028
//------------------------------------------------------------------------------------- //0024

Dcl-Proc GetLastRrnOfMainLogic Export;                                                   //0024

   // Input pointer parameter.                                                          //0024
   Dcl-Pi GetLastRrnOfMainLogic;                                                         //0024
      inSrcDataPointer Pointer;                                                          //0024
   End-Pi;                                                                               //0024

   // Source details data structure based on input pointer.                             //0024
   Dcl-Ds inSrcDataDs  Based(inSrcDataPointer);                                          //0024
      inReqId        Char(18);                                                           //0024
      inSrcLib       Char(10);                                                           //0024
      inSrcPf        Char(10);                                                           //0024
      inSrcMbr       Char(10);                                                           //0024
      insrcType      Char(10);                                                           //0024
   End-Ds;                                                                               //0024

   // Work variables.                                                                   //0024
   Dcl-S wkMinDclPrcRrn       Packed(6:0)        Inz;                                    //0024
   Dcl-S wkMinBegSrRrn        Packed(6:0)        Inz;                                    //0024
   Dcl-S wkTempRrn            Packed(6:0)        Inz;                                    //0024
   Dcl-S wkElementCount       Packed(6:0)        Inz;                                    //0029
   //Copybook declaration                                                               //0030
/copy 'QCPYSRC/iaprderlog.rpgleinc'

   wkuDpsds.nbrparms = %parms;                                                           //0030
   EvaluatePSDS() ;                                                                      //0030

   // Get the rrn of last executable source line of main logic following below steps:   //0024

   // 1 - Get minimum RRN from IAQRPGSRC having DCL-PROC keyword (Executable line).     //0024
   // 2 - Get minimum RRN from IAQRPGSRC having BEGSRC keyword (Executable line).       //0024
   // 3 - Get minimum executable source rrn from IAQRPGSRC (If point 1 & 2 values are   //0024
   //     zeros than retrieve maximum execuable line RRN).                              //0024

   // 1                                                                                 //0024
   Exec sql Select COALESCE(Min(XSrcRrn),0) Into :wkMinDclPrcRrn from IaqRpgSrc          //0038
             where XLibNam    = :inSrcDataDs.inSrcLib  and                               //0024
                   XSrcNam    = :inSrcDataDs.inSrcPf   and                               //0024
                   XMbrNam    = :inSrcDataDs.inSrcMbr  and                               //0024
                   XMbrTyp    = :inSrcDataDs.inSrcType and                               //0024
                   XSrcSpec   = 'P'                    and                               //0024
                   SubString(XSrcLTyp,4,1) = ' '          ;                              //0024

   // 2                                                                                 //0024
   Exec sql Select COALESCE(Min(XSrcRrn),0) Into :wkMinBegSrRrn from IaqRpgSrc           //0038
             where XLibNam    = :inSrcDataDs.inSrcLib  and                               //0024
                   XSrcNam    = :inSrcDataDs.inSrcPf   and                               //0024
                   XMbrNam    = :inSrcDataDs.inSrcMbr  and                               //0024
                   XMbrTyp    = :inSrcDataDs.inSrcType and                               //0024
                   XSrcSpec   = 'C'                    and                               //0024
                   SubString(XSrcLTyp,4,1) = ' '       and                               //0024
                   Upper(XSrcDta) Like '%BEGSR%'          ;                              //0024

   // 3                                                                                 //0024
   Select;                                                                               //0024
     When wkMinDclPrcRrn = 0 and wkMinBegSrRrn = 0;                                      //0024
        wkTempRrn = 0;                                                                   //0024
     When wkMinBegSrRrn  = 0 and wkMinDclPrcRrn > 0;                                     //0024
        wkTempRrn = wkMinDclPrcRrn;                                                      //0024
     When wkMinDclPrcRrn = 0 and wkMinBegSrRrn  > 0;                                     //0024
        wkTempRrn = wkMinBegSrRrn;                                                       //0024
     When wkMinDclPrcRrn <= wkMinBegSrRrn;                                               //0024
        wkTempRrn = wkMinDclPrcRrn;                                                      //0024
     Other;                                                                              //0024
        wkTempRrn = wkMinBegSrRrn;                                                       //0024
   EndSl;                                                                                //0024

   wkLstRrnForMainLogic = 0;                                                             //0024
   wkBgnRrnForMainLogic = 0;                                                             //0028
   If  wkTempRrn<> 0 ;                                                                   //0024
      Exec sql Select COALESCE(Max(XSrcRrn),0) Into :wkLstRrnForMainLogic                //0038
               from IaqRpgSrc                                                            //0038
                 where XLibNam    = :inSrcDataDs.inSrcLib  and                           //0024
                       XSrcNam    = :inSrcDataDs.inSrcPf   and                           //0024
                       XMbrNam    = :inSrcDataDs.inSrcMbr  and                           //0024
                       XMbrTyp    = :inSrcDataDs.inSrcType and                           //0024
                       XSrcSpec   = 'C'                    and                           //0024
                       SubString(XSrcLTyp,4,1) = ' '       and                           //0024
                       XSrcRrn    < :wkTempRrn                 ;                         //0024
   Else;                                                                                 //0024
      Exec sql Select COALESCE(Max(XSrcRrn),0) Into :wkLstRrnForMainLogic                //0038
               from IaqRpgSrc                                                            //0038
                 where XLibNam    = :inSrcDataDs.inSrcLib  and                           //0024
                       XSrcNam    = :inSrcDataDs.inSrcPf   and                           //0024
                       XMbrNam    = :inSrcDataDs.inSrcMbr  and                           //0024
                       XMbrTyp    = :inSrcDataDs.inSrcType and                           //0024
                       XSrcSpec   = 'C'                    and                           //0024
                       SubString(XSrcLTyp,4,1) = ' '          ;                          //0024
   EndIf;                                                                                //0024

   // Get beginning rrn of main logic based on logic that the minimum executable        //0028
   // C spec rrn for which rrn is less than the last rrn of main logic should be        //0028
   // considered as start of main logic.                                                //0028
   Exec sql Select COALESCE(Min(XSrcRrn),0) Into :wkBgnRrnForMainLogic                   //0038
            from IaqRpgSrc                                                               //0038
             where XLibNam    = :inSrcDataDs.inSrcLib  and                               //0028
                   XSrcNam    = :inSrcDataDs.inSrcPf   and                               //0028
                   XMbrNam    = :inSrcDataDs.inSrcMbr  and                               //0028
                   XMbrTyp    = :inSrcDataDs.inSrcType and                               //0028
                   XSrcSpec   = 'C'                    and                               //0028
                   XSrcRrn    < :wkLstRrnForMainLogic  and                               //0028
                   SubString(XSrcLTyp,4,1) = ' '          ;                              //0028
   wkSaveBgnRrn = wkBgnRrnForMainLogic ;                                                 //0083
   //If still could not fetch the Beg RRn of Main logic,to ensure                       //0028
   //Print main logic text for all members                                              //0028
   If wkBgnRrnForMainLogic  =  *Zeros;                                                   //0028
      Exec sql Select COALESCE(Max(XSrcRrn),0) Into :wkBgnRrnForMainLogic                //0028
               from IaqRpgSrc                                                            //0028
                where XLibNam    = :inSrcDataDs.inSrcLib  and                            //0028
                      XSrcNam    = :inSrcDataDs.inSrcPf   and                            //0028
                      XMbrNam    = :inSrcDataDs.inSrcMbr  and                            //0028
                      XMbrTyp    = :inSrcDataDs.inSrcType and                            //0028
                      XSrcSpec   in ('H', 'F' , 'D','K','R') and                         //0028
                      XSrcRrn    < :wkMinDclPrcRrn        and                            //0028
                      SubString(XSrcLTyp,4,1) = ' ';                                     //0028
   Endif;                                                                                //0028
   // Get last rrn of C spec logic                                                      //0083
   Exec sql Select COALESCE(Max(XSrcRrn),0) Into :wkSaveLstRrn                           //0083
            from IaqRpgSrc                                                               //0083
             where XLibNam    = :inSrcDataDs.inSrcLib  and                               //0083
                   XSrcNam    = :inSrcDataDs.inSrcPf   and                               //0083
                   XMbrNam    = :inSrcDataDs.inSrcMbr  and                               //0083
                   XMbrTyp    = :inSrcDataDs.inSrcType and                               //0083
                   XSrcSpec   = 'C'                    and                               //0083
                   XSrcRrn    > :wkBgnRrnForMainLogic  and                               //0083
                   SubString(XSrcLTyp,4,1) = ' '          ;                              //0083
                                                                                         //0083
   // Retrieve the text to be printed after main logic is completed.                    //0024
   Exec sql Select iASrcMap Into :wkEndMainLogicCmnt from IaPSeudoMp                     //0024
             where iAKeyFld1 = 'HEADER' and iAKeyFld2 = 'ENDMAINTXT' ;                   //0024
   // Retrieve the text to be printed before main logic is started.                     //0029
   Exec Sql                                                                              //0029
         Declare MainLogicStartTextCursor Cursor for                                     //0029
            Select iASrcMap from iAPSeudoMP                                              //0029
             Where iAKeyFld1 = 'HEADER' and iAKeyFld2 = 'BGNMAINTXT'                     //0029
             Order by iASeqNo                                                            //0029
             For Fetch Only;                                                             //0029
   wkElementCount = %Elem(wkBgnMainLogicCmnt);                                           //0029

   Exec Sql Open MainLogicStartTextCursor;                                               //0029

   If SqlCode = Csr_Opn_Cod;                                                             //0029
         Exec Sql Close MainLogicStartTextCursor;                                        //0029
         Exec Sql Open MainLogicStartTextCursor;                                         //0029
   EndIf;                                                                                //0029

   If SqlCode < SuccessCode;                                                             //0029
      uDpsds.wkQuery_Name = 'Open_MainLogicStartTextCursor';                             //0029
      IaSqlDiagnostic(uDpsds);                                                           //0029
   EndIf;                                                                                //0029

   If Sqlcode = successCode;                                                             //0029
      Exec Sql                                                                           //0029
         Fetch MainLogicStartTextCursor For :wkElementCount  Rows                        //0029
         Into :wkBgnMainLogicCmnt;                                                       //0029
   EndIf;                                                                                //0029
   Exec Sql Close MainLogicStartTextCursor;                                              //0029

   //Copy book Declaration for error handling                                           //0030
/copy 'QCPYSRC/iaprcerlog.rpgleinc'

End-Proc GetLastRrnOfMainLogic;                                                          //0024
//-------------------------------------------------------------------------------------
//EvaluatePSDS : Move PSDS parameters into Data structure.
//-------------------------------------------------------------------------------------
Dcl-Proc EvaluatePSDS ;                                                                  //0030
   monitor;                                                                              //0030
     Eval-corr uDpsds = wkuDpsds;                                                        //0030
   on-error;                                                                             //0030
      uDpsds.NbrParms = 0 ;                                                              //0030
   endmon;                                                                               //0030
End-Proc EvaluatePSDS ;                                                                  //0030
//------------------------------------------------------------------------------------- //0038
//IndentRPGPseudoCode - Procedure to add/remove indentation in RPG source's pseudo code //0038
//------------------------------------------------------------------------------------- //0038

Dcl-Proc IndentRPGPseudoCode Export;                                                     //0038

  // Input pointer parameter.                                                           //0038
  Dcl-Pi IndentRPGPseudoCode;                                                            //0038
    inParmPointer Pointer;                                                               //0038
  End-Pi;                                                                                //0038
  //Copybook declaration                                                                //0038
/copy 'QCPYSRC/iaprderlog.rpgleinc'

  Dcl-Ds inRPGIndentParmDs LikeDs(RPGIndentParmDSTmp) Based(inParmPointer);              //0038
  Dcl-Ds wkRPGIndentParmDS;                                                              //0038
    dsIndentType        Char(10);                                                        //0038
    dsPseudocode        Char(cwSrcLength);                                               //0038
    dsTagCountArr       Packed(5:0)        Dim(99);                                      //0038
    dsIndentsArr        Packed(5:0)        Dim(99);                                      //0038
    dsIndentTypeArr     Char(10)           Dim(99);                                      //0038
    dsIndentIndex       Packed(5:0);                                                     //0038
    dsCurrentIndents    Packed(5:0);                                                     //0038
    dsCurrentTagCount   Packed(5:0);                                                     //0038
    dsPipeIndentSave    Char(109);                                                       //0097
    dsPipeTagInd        Ind;                                                             //0097
    dsSrcDtlDSPointer   Pointer;                                                         //0097
  End-Ds;                                                                                //0038

  Dcl-Ds wkOutParmWriteSrcDocDS LikeDs(OutParmWriteSrcDocDS) Based(dsSrcDtlDSPointer);   //0097

  Dcl-Ds DsPseudoCodeForBlankCheck;                                                      //0097
     wkPseudoCodeForBlankCheckArr  Char(1) Dim(110);                                     //0097
  End-Ds;                                                                                //0097

  Dcl-C cwMaxNoOfCharToPrint    109;                                                     //0097
  Dcl-S  IOParmPointer   Pointer   Inz(*Null);                                           //0038
  Dcl-S  wkBlankPseudoCodeIndicator Ind    Inz;                                          //0097
  Dcl-S  wkAdditionalPipeIndicator  Ind    Inz;                                          //0097
  Dcl-S  wkIndentTag     Char(6)   Inz;                                                  //0038
  Dcl-S  wkPSeudoCode    Char(cwSrcLength);                                              //0038
  Dcl-S  wkPSeudoCode2   Char(cwSrcLength);                                              //0038
  Dcl-S  wkPSeudoCodeTmp Char(cwSrcLength);                                              //0097
  Dcl-S  wkBackupPseudoCode Char(cwSrcLength);                                           //0097
  Dcl-S  wkMaxDataToWrite Char(109) Inz;                                                 //0097
  Dcl-S  wkIdx           Packed(5:0) Inz;                                                //0038
  Dcl-S  wkIdx2          Packed(5:0) Inz;                                                //0038
  Dcl-S  wkIdx3          Packed(5:0) Inz;                                                //0055
  Dcl-S  wkIdx4          Packed(5:0) Inz;                                                //0097
  Dcl-S  wkPipelength    Zoned(4:0) Inz;                                                 //0097
  Dcl-S  wkFirstNonBlankCharPos Zoned(4:0) Inz;                                          //0097
  Dcl-S  wkTempTagCount  Packed(5:0) Inz;                                                //0038
  Dcl-S  wkCurrentIndents Packed(5:0) Inz;                                               //0055
  Dcl-S  wkIndentIndex    Packed(5:0) Inz;                                               //0055
  Dcl-S  wkRpg3DocSeq    Packed(6:0) Inz;                                                //0097

  // A- Handling before adding indentation in current line's pseudo-code                //0038
  // ---------------------------------------------------------------------              //0038
  Eval-Corr wkRPGIndentParmDs = inRPGIndentParmDs;                                       //0038
  wkPipeTagInd = *off;                                                                   //0055

  // Print a blank line if indent type is not blank.                                    //0038
  If dsIndentType <> *Blanks and OutParmWriteSrcDocDS.dssrctype<>'RPG'                   //0097
     and OutParmWriteSrcDocDS.dssrctype<>'SQLRPG';                                       //0097
     OutParmWriteSrcDocDS.dsPseudocode = *Blanks;                                        //0038
     IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                                       //0038
     WritePseudoCode(IOParmPointer);                                                     //0038
  EndIf;                                                                                 //0038

  Select;                                                                                //0038
     When dsIndentType = cwRemove or dsIndentType = cwRemoveCheck;                       //0038
        Exsr RemoveIndentHandling;

      When dsIndentType = cwAdd or dsIndentType = cwAddCheck or                          //0038
         dsIndentType = cwNewBranch;                                                     //0038
         Exsr StartIndentHandling;                                                       //0038
         // Indicator Handles extra PipeIndent for Every new Tag and Its comment line   //0055
         wkPipeTagInd = *on;                                                             //0055

      When dsIndentType = cwBranch;                                                      //0038
         Exsr BranchIndentHandling;                                                      //0038

      When dsIndentType = cwCASE;                                                        //0038
         Exsr CaseIndentHandling;                                                        //0038

   EndSl;                                                                                //0038

   // B- Handling to add indentation in current line's pseudo-code                      //0038
   // --------------------------------------------------------------                    //0038
   //Adding tag to pseudo-code                                                           //0038
   If wkIndentTag <> *Blanks AND dsPseudocode <> *Blanks;                                //0038
      dsPseudocode = wkIndentTag + ' ' + %Trim(dsPseudocode);                            //0038
   EndIf;                                                                                //0038
   //Adding indentation to pseudo code
   If dsCurrentIndents > 0;                                                              //0038
      wkPseudoCode = dsPseudoCode;                                                       //0038
      clear dsPseudoCode;                                                                //0038
      %subst(dsPseudoCode : dsCurrentIndents) = wkPseudoCode;                            //0038
   EndIf;                                                                                //0038

   // C- Handling after indentation of pseudo-code                                      //0038
   // ---------------------------------------------------                               //0038
   If dsIndentType <> *Blanks;                                                           //0038
      dsCurrentIndents = %xfoot(dsIndentsArr);                                           //0038
      //Identify and Calculate the Pipe Indent for the Pseudo Code                      //0055
      Exsr PipeIndentHandling;                                                           //0055
      dsPipeIndentSave = %Trim(wkPipeIndentSave);                                        //0097
   EndIf;                                                                                //0038

   If wkIndentTag <> *Blanks And dsPseudocode <> *Blanks;                                //0044
      wkPseudocodeFontBkp = dsPseudocode;                                                //0044
   EndIf;                                                                                //0044

   dsPipeTagInd  = wkPipeTagInd ;                                                        //0097
   Eval-Corr inRPGIndentParmDs = wkRPGIndentParmDs;                                      //0038

   Return;                                                                               //0038

   //---------------------------------------------------------------------------------- //0038
   // RemoveIndentHandling - Subroutine to remove the indentation                       //0038
   //---------------------------------------------------------------------------------- //0038
   BegSr RemoveIndentHandling;                                                           //0038
                                                                                         //0038
      // Prepare tag to be added in the closing indentation line                        //0038
      // and remove previous branches indentations.                                      //0038
      For wkIdx = dsIndentIndex DownTo 1;                                                //0038
         dsCurrentIndents -= dsIndentsArr(wkIdx);                                        //0038
         dsIndentsArr(wkIdx)  = 0;                                                       //0038
         dsIndentTypeArr(wkIdx) = *Blanks;                                               //0038
         dsIndentIndex -=1;                                                              //0038
         If dsTagCountArr(wkIdx) > 0;                                                    //0038
            wkIndentTag = 'L' + %Editc(dsTagCountArr(wkIdx):'X');                        //0038
            dsTagCountArr(wkIdx) = 0;                                                    //0038
            Leave;                                                                       //0038
         EndIf;                                                                          //0038
      EndFor;                                                                            //0038
      // For remove-check case, re-initialize                                           //0038
      If dsIndentType = cwRemoveCheck;                                                   //0038
         wkTempTagCount = dsCurrentTagCount;                                             //0038
         Clear wkRPGIndentParmDS;                                                        //0038
         dsCurrentTagCount = wkTempTagCount;                                             //0038
      EndIf;                                                                             //0038

   EndSr;                                                                                //0038

   //---------------------------------------------------------------------------------- //0038
   // StartIndentHandling - Subroutine to start a new indentation with tag              //0038
   //---------------------------------------------------------------------------------- //0038
   BegSr StartIndentHandling;                                                            //0038
                                                                                         //0038
      // Increment tag count and store in current index array                           //0038
      If dsIndentType = cwAddCheck;                                                      //0038
         wkTempTagCount = dsCurrentTagCount+1;                                           //0038
         Clear wkRPGIndentParmDS;                                                        //0038
         dsIndentIndex = 1;                                                              //0038
         dsTagCountArr(dsIndentIndex) = wkTempTagCount;                                  //0038
         dsCurrentTagCount = wkTempTagCount;                                             //0038
      Else;                                                                              //0038
         dsIndentIndex +=1;                                                              //0038
         dsCurrentTagCount += 1;                                                         //0038
         dsTagCountArr(dsIndentIndex) = dsCurrentTagCount;                               //0038
      EndIf;                                                                             //0038
      dsIndentTypeArr(dsIndentIndex) = dsIndentType;                                     //0038
      dsIndentsArr(dsIndentIndex)  = 3;                                                  //0038
      // Prepare tag to be added in the closing indentation line                        //0038
      // indentation will start from next statement so indents will increase after      //0038
      // current line is printed, only tag will be added in current line.               //0038
      wkIndentTag = 'L' + %Editc(dsTagCountArr(dsIndentIndex):'X');                      //0038

   EndSr;                                                                                //0038
   //---------------------------------------------------------------------------------- //0038
   // BranchIndentHandling - Subroutine to start indentation without tag for a branch   //0038
   //---------------------------------------------------------------------------------- //0038
   BegSr BranchIndentHandling;                                                           //0038
                                                                                         //0038
      If dsIndentIndex > 0;                                                              //0038
         Select;                                                                         //0038
            When dsIndentTypeArr(dsIndentIndex)=cwBranch;                                //0038
               //If a new branch is starting and previous indent was for a branch,       //0038
               //consider to remove indentation of previous branch first.                //0038
               dsCurrentIndents -= dsIndentsArr(dsIndentIndex);                          //0038
               //If there is already a branch previously, append only '> ' in pseudo     //0038
               //code and consider full pseudo code to retain 'OR,' in pseudo code       //0038
               dsPseudocode = '> ' + %Trimr(dsPseudoCode);                               //0038

            When dsIndentTypeArr(dsIndentIndex) = cwNewBranch;                           //0038
               dsIndentIndex +=1;                                                        //0038
               dsIndentsArr(dsIndentIndex)  = 5;                                         //0038
               dsTagCountArr(dsIndentIndex) = 0;                                         //0038
               dsIndentTypeArr(dsIndentIndex) = dsIndentType;                            //0038
               //If previously a NEW BRANCH was started, append only '> ' in pseudo      //0038
               //code and consider full pseudo code to retain 'OR,' in pseudo code       //0038
               dsPseudocode = '> ' + %Trimr(dsPseudoCode);                               //0038

            Other;                                                                       //0038
               //If previous indentation was not for branch, consider to put indent      //0038
               //value in array which will be summed up to total indents in the end      //0038
               dsIndentIndex +=1;                                                        //0038
               dsIndentsArr(dsIndentIndex)  = 5;                                         //0038
               dsTagCountArr(dsIndentIndex) = 0;                                         //0038
               dsIndentTypeArr(dsIndentIndex) = dsIndentType;                            //0038
               dsPseudocode = '> ' + %subst(dsPseudoCode : 5);                           //0038
         EndSl;                                                                          //0038
      Else;                                                                              //0038
         //If previous indentation was not for branch, consider to put indent            //0038
         //value in array which will be summed up to total indents in the end            //0038
         dsIndentIndex +=1;                                                              //0038
         dsIndentsArr(dsIndentIndex)  = 5;                                               //0038
         dsTagCountArr(dsIndentIndex) = 0;                                               //0038
         dsIndentTypeArr(dsIndentIndex) = dsIndentType;                                  //0038
         dsPseudocode = '> ' + %subst(dsPseudoCode : 5);                                 //0038
      EndIf;                                                                             //0038

   EndSr;                                                                                //0038
   //---------------------------------------------------------------------------------- //0038
   // CaseIndentHandling - Subroutine to add indentaiton for a CASE branch              //0038
   //---------------------------------------------------------------------------------- //0038
   BegSr CaseIndentHandling;                                                             //0038

      //Retrieve the last document sequence number written in IAPSEUDOWK for RPG3 case   //0097
      If OutParmWriteSrcDocDS.dssrctype ='RPG' or                                        //0097
         OutParmWriteSrcDocDS.dssrctype='SQLRPG';                                        //0097
         //Move source details which will be used while writing to iapseudowk            //0097
         OutParmWriteSrcDocDS = wkOutParmWriteSrcDocDS;                                  //0097
         wkRpg3DocSeq = OutParmWriteSrcDocDS.dsDocSeq;                                   //0097
      EndIf;                                                                             //0097

      //Check previous indent type, If it was a CASExx indent, consider printing only    //0038
      //Part 2 and 3 of the pseudo code, If previous indent type is not a CASE, print    //0038
      //Part 1, 2 and 3 of the pseudo code.                                              //0038
      If dsIndentIndex > 0 and dsIndentTypeArr(dsIndentIndex) = cwCASE;                  //0038
         //Print part 2                                                                  //0038
         wkIdx = %scan(cwSplitCharacter : dsPseudocode);                                 //0038
         If wkIdx <> 0;                                                                  //0038
            wkIdx2 = %scan(cwSplitCharacter : dsPseudocode : wkIdx+4);                   //0038
         EndIf;                                                                          //0038
         If wkIdx2 <> 0 and wkIdx <> 0 and wkIdx2 > wkidx;                               //0038
            //Pick part 2 and print after indenting it                                   //0038
            wkPSeudoCode = '> '+%subst(dsPseudocode : wkIdx+4 : wkIdx2-wkIdx-4);         //0038
            If dsCurrentIndents > 0;                                                     //0038
               wkPseudoCode2 = wkPseudoCode;                                             //0038
               clear wkPseudoCode;                                                       //0038
               %subst(wkPseudoCode : dsCurrentIndents) = wkPseudoCode2;                  //0038
            EndIf;                                                                       //0038
            OutParmWriteSrcDocDS.dsPseudocode = wkPseudoCode;                            //0038
            IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                                //0038

            //Write to IAPSEUDOWK for RPG3 case                                          //0097
            If OutParmWriteSrcDocDS.dssrctype ='RPG' or                                  //0097
               OutParmWriteSrcDocDS.dssrctype='SQLRPG';                                  //0097
               Exsr SrAddPipesAndWriteRPG3PseudoCode;                                    //0097
            Else;                                                                        //0097
               WritePseudoCode(IOParmPointer);                                           //0097
            EndIf;                                                                       //0097

            //Get part 3 and print the remaining pseudo code                             //0038
            wkPseudocode = %subst(dsPseudocode : wkIdx2+4);                              //0038
            //Print blank line first                                                     //0038
            OutParmWriteSrcDocDS.dsPseudocode = *Blanks;                                 //0038
            IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                                //0038
                                                                                         //0097
            If OutParmWriteSrcDocDS.dssrctype ='RPG' or                                  //0097
               OutParmWriteSrcDocDS.dssrctype='SQLRPG';                                  //0097
               Exsr SrAddPipesAndWriteRPG3PseudoCode;                                    //0097
            Else;                                                                        //0097
               WritePseudoCode(IOParmPointer);                                           //0097
            EndIf;                                                                       //0097
                                                                                         //0097
            //Indent                                                                     //0038
            wkPseudoCode2 = wkPseudoCode;                                                //0038
            clear wkPseudoCode;                                                          //0038
            %subst(wkPseudoCode : dsCurrentIndents+5) = wkPseudoCode2;                   //0038
            //Write                                                                      //0038
            OutParmWriteSrcDocDS.dsPseudocode = wkPseudocode;                            //0038
            IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                                //0038

            If OutParmWriteSrcDocDS.dssrctype ='RPG' or                                  //0097
               OutParmWriteSrcDocDS.dssrctype='SQLRPG';                                  //0097
               Exsr SrAddPipesAndWriteRPG3PseudoCode;                                    //0097
            Else;                                                                        //0097
               WritePseudoCode(IOParmPointer);                                           //0097
            EndIf;                                                                       //0097

            //Blank out dsPSeudocode to not print anything further from                  //0038
            //writeoutputdata                                                            //0038
            dsPseudoCode = *Blanks;                                                      //0038

         EndIf;                                                                          //0038

      Else;                                                                              //0038

         //Print all 3 parts of the pseudo-code and print the pseudo-code with tag.      //0038
         wkIdx = %scan(cwSplitCharacter : dsPseudocode);                                 //0038
         If wkIdx <> 0;                                                                  //0038

            //Get part 1 of the pseudo code in wkPseudocode variable, add tag,           //0038
            //indent it and print it.                                                    //0038
            wkPSeudoCode = %subst(dsPseudocode : 1 : wkIdx-1);                           //0038
            //Prepare the tag.                                                           //0038
            dsIndentIndex +=1;                                                           //0038
            dsCurrentTagCount += 1;                                                      //0038
            dsTagCountArr(dsIndentIndex) = dsCurrentTagCount;                            //0038
            dsIndentTypeArr(dsIndentIndex) = dsIndentType;                               //0038
            dsIndentsArr(dsIndentIndex)  = 3;                                            //0038
            wkIndentTag = 'L' + %Editc(dsTagCountArr(dsIndentIndex):'X');                //0038
            //Add the tag and indent (Indent the pseudo code for existing                //0038
            //indentations, the indent to be started for CAS statement will be           //0038
            //effective for part 2 onwards.                                              //0038
            wkPseudocode = wkIndentTag + ' ' + %Trim(wkPseudocode);                      //0038
            If dsCurrentIndents > 0;                                                     //0038
               wkPseudoCode2 = wkPseudoCode;                                             //0038
               clear wkPseudoCode;                                                       //0038
               %subst(wkPseudoCode : dsCurrentIndents) = wkPseudoCode2;                  //0038
            EndIf;                                                                       //0038

            wkPseudocodeFontBkp = wkPseudocode;                                          //0044

            OutParmWriteSrcDocDS.dsPseudocode = wkPseudoCode;                            //0038
            IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                                //0038

            If OutParmWriteSrcDocDS.dssrctype ='RPG' or                                  //0097
               OutParmWriteSrcDocDS.dssrctype='SQLRPG';                                  //0097
               dsPipeTagInd = *on;                                                       //0097
               Exsr SrAddPipesAndWriteRPG3PseudoCode;                                    //0097
            Else;                                                                        //0097
               WritePseudoCode(IOParmPointer);                                           //0097
            EndIf;                                                                       //0097

            dsCurrentIndents = %xfoot(dsIndentsArr);                                     //0038
            //Identify and Calculate the Pipe Indent for the Pseudo Code                //0055
            Exsr PipeIndentHandling;                                                     //0055
            //Get part 2 of the pseudo code in wkPseudocode variable, treat it a         //0038
            //branch and print it.                                                       //0038
            wkIdx2 = %scan(cwSplitCharacter : dsPseudocode : wkIdx+4);                   //0038
            If wkIdx2 <> 0;                                                              //0038
               //Indent dsPseudocode similar to First branch.                            //0038
               wkPSeudoCode = %subst(dsPseudocode : wkIdx+4 : wkIdx2-wkIdx-4);           //0038
               wkPseudocode = '> ' + %subst(wkPseudoCode : 5);                           //0038
               wkPseudoCode2 = wkPseudoCode;                                             //0038
               clear wkPseudoCode;                                                       //0038
               %subst(wkPseudoCode : dsCurrentIndents) = wkPseudoCode2;                  //0038
               //Print a blank line and part 2.                                          //0038
               OutParmWriteSrcDocDS.dsPseudocode = *Blanks;                              //0038
               IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                             //0038

               If OutParmWriteSrcDocDS.dssrctype ='RPG' or                               //0097
                  OutParmWriteSrcDocDS.dssrctype='SQLRPG';                               //0097
                  Exsr SrAddPipesAndWriteRPG3PseudoCode;                                 //0097
               Else;                                                                     //0097
                  WritePseudoCode(IOParmPointer);                                        //0097
               EndIf;                                                                    //0097

               OutParmWriteSrcDocDS.dsPseudocode = wkPseudocode;                         //0038
               IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                             //0038

               If OutParmWriteSrcDocDS.dssrctype ='RPG' or                               //0097
                  OutParmWriteSrcDocDS.dssrctype='SQLRPG';                               //0097
                  Exsr SrAddPipesAndWriteRPG3PseudoCode;                                 //0097
               Else;                                                                     //0097
                  WritePseudoCode(IOParmPointer);                                        //0097
               EndIf;                                                                    //0097

               //Get part 3 and print the remaining pseudo code                          //0038
               wkPseudocode = %subst(dsPseudocode : wkIdx2+4);                           //0038
               //Print blank line first                                                  //0038
               OutParmWriteSrcDocDS.dsPseudocode = *Blanks;                              //0038
               IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                             //0038

               If OutParmWriteSrcDocDS.dssrctype ='RPG' or                               //0097
                  OutParmWriteSrcDocDS.dssrctype='SQLRPG';                               //0097
                  Exsr SrAddPipesAndWriteRPG3PseudoCode;                                 //0097
               Else;                                                                     //0097
                  WritePseudoCode(IOParmPointer);                                        //0097
               EndIf;                                                                    //0097

               //Indent                                                                  //0038
               wkPseudoCode2 = wkPseudoCode;                                             //0038
               clear wkPseudoCode;                                                       //0038
               %subst(wkPseudoCode : dsCurrentIndents+5) = wkPseudoCode2;                //0038
               //Write                                                                   //0038
               OutParmWriteSrcDocDS.dsPseudocode = wkPseudocode;                         //0038
               IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                             //0038

               If OutParmWriteSrcDocDS.dssrctype ='RPG' or                               //0097
                  OutParmWriteSrcDocDS.dssrctype='SQLRPG';                               //0097
                  Exsr SrAddPipesAndWriteRPG3PseudoCode;                                 //0097
               Else;                                                                     //0097
                  WritePseudoCode(IOParmPointer);                                        //0097
               EndIf;                                                                    //0097

               //Blank out dsPSeudocode to not print anything further from               //0038
               //writeoutputdata                                                         //0038
               dsPseudoCode = *Blanks;                                                   //0038

            EndIf;                                                                       //0038
         EndIf;                                                                          //0038
      EndIf;                                                                             //0038
   EndSr;                                                                                //0038

   //---------------------------------------------------------------------------------- //0055
   // PipeIndentHandling - Calculate Pipe Symbol and store in Global Variable           //0055
   //---------------------------------------------------------------------------------- //0055
   Begsr PipeIndentHandling;                                                             //0055
      wkCurrentIndents = dsCurrentIndents;                                               //0055
      wkIndentIndex = dsIndentIndex;                                                     //0055
      wkPipeIndentSave = *Blanks;                                                        //0055
      For wkIdx3 = wkIndentIndex DownTo 1;                                               //0055
         wkCurrentIndents -= dsIndentsArr(wkIdx3);                                       //0055
         If dsTagCountArr(wkIdx3) > 0 ;                                                  //0055
            If wkCurrentIndents = *Zeros;                                                //0055
               wkCurrentIndents = 1;                                                     //0055
            EndIf;                                                                       //0055
            %subst(wkPipeIndentSave:wkCurrentIndents:1) = (cwPipeIndent);                //0055
         EndIf;                                                                          //0055
      EndFor;                                                                            //0055
   Endsr;                                                                                //0055
   //---------------------------------------------------------------------------------- //0097
   // PipeIndentHandling - Calculate Pipe Symbol and store in Global Variable           //0097
   //---------------------------------------------------------------------------------- //0097
   Begsr SrAddPipesAndWriteRPG3PseudoCode;                                               //0097

      wkPseudoCodeTmp = %trimr(OutParmWriteSrcDocDS.dsPseudocode);                       //0097
      wkAdditionalPipeIndicator = *Off;                                                  //0097
      If %check('| ' : wkPseudoCodeTmp) = 0;                                             //0097
         wkBlankPseudoCodeIndicator = *On;                                               //0097
         wkFirstNonBlankCharPos     = 1;                                                 //0097
      Else;                                                                              //0097
         wkFirstNonBlankCharPos = %check('| ' : wkPseudoCodeTmp);                        //0097
         wkBlankPseudoCodeIndicator = *Off;                                              //0097
      EndIf;                                                                             //0097

      DoW %check('| ' : wkPseudoCodeTmp) <> 0                                            //0097
          or wkBlankPseudoCodeIndicator = *On;                                           //0097

         wkBlankPseudoCodeIndicator = *Off;                                              //0097
         //Add pipes as prefix of pseudocode before writing.                             //0097
         If wkPipeIndentSave <> *Blanks ;                                                //0097

            //Calculate Pipe indent                                                      //0097
            wkPipelength = %len(%trim(wkPipeIndentSave));                                //0097
            // Removes Last Pipe for Every new Tag and Its comment line                  //0097
            Clear wkFontCode;                                                            //0097
            If dsPipeTagInd = *on;                                                       //0097
               If wkPipeLength >= wkFirstNonBlankCharPos;                                //0097
                  wkPipelength = wkPipelength - 1;                                       //0097
               EndIf;                                                                    //0097
               wkFontCode = cwBoldFont;                                                  //0097
               wkFirstNonBlankCharPos = wkFirstNonBlankCharPos + 2;                      //0097
               wkAdditionalPipeIndicator = *On;                                          //0097
            EndIf;                                                                       //0097

            // Append Calculated PipeIndent for Every nestedd Line in Pseudocode         //0097
            %subst(wkPseudoCodeTmp : 1 : wkPipelength)= %trimr(wkPipeIndentSave);        //0097
                                                                                         //0097
             dsPipeTagInd = *Off;                                                        //0097

         ElseIf dsPipeTagInd = *on;                                                      //0097

            Clear wkFontCode;                                                            //0097
            wkFontCode = cwBoldFont;                                                     //0097
            wkFirstNonBlankCharPos = wkFirstNonBlankCharPos + 2;                         //0097
            wkAdditionalPipeIndicator = *On;                                             //0097
            dsPipeTagInd = *Off;                                                         //0097

         EndIf;                                                                          //0097

         //Break pseudocode and write                                                    //0097
         If %len(%trimr(wkPseudoCodeTmp)) > cwMaxNoOfCharToPrint;                        //0097

            //Move the Pseudo-code to DS to check from where it should be broken         //0097
            DsPseudoCodeForBlankCheck = %trimr(wkPseudoCodeTmp);                         //0097

            //Start checking from 110th position backwards to find blank, wherever      //0097
            //blank position will be found Pseudo-code will be broke from there         //0097
            For wkIdx4 = cwMaxNoOfCharToPrint + 1 DownTo 1;                              //0097
               If wkPseudoCodeForBlankCheckArr(wkIdx4) = ' ';                            //0097
                  Leave;                                                                 //0097
               EndIf;                                                                    //0097
            EndFor;                                                                      //0097

            //Exception handling.                                                       //0097
            If wkIdx4 = 0                                                                //0097
               Or %check('| ' : %subst(wkPseudoCodeTmp : 1 : wkIdx4)) = 0;               //0097
               wkIdx4 = cwMaxNoOfCharToPrint;                                            //0097
            EndIf;                                                                       //0097

            //Move the data which can be printed to wkMaxDataToWrite                     //0097
            wkMaxDataToWrite = %trimr(%subst(wkPseudoCodeTmp : 1 : wkIdx4));             //0097

            //Move remaining data to wkPseudoCode and add indentation                    //0097
            wkBackupPseudoCode = wkPseudoCodeTmp;                                        //0097
            Clear wkPseudoCodeTmp;                                                       //0097
            %subst(wkPseudoCodeTmp : wkFirstNonBlankCharPos) =                           //0097
                               %trim(%subst(wkBackupPseudoCode : wkIdx4+1));             //0097
            If wkAdditionalPipeIndicator = *On;                                          //0097
               %subst(wkPseudoCodeTmp : wkFirstNonBlankCharPos-2 : 1) = '|';             //0097
            EndIf;                                                                       //0097
         Else;
            wkMaxDataToWrite = %trimr(wkPseudoCodeTmp);                                  //0097
            wkPseudoCodeTmp  = *Blanks;                                                  //0097
         EndIf;                                                                          //0097


         //Write pseudocode
         OutParmWriteSrcDocDS.dsPseudocode = wkMaxDataToWrite;                           //0097
         WriteIaPseudowk(IOParmPointer : wkRpg3DocSeq : wkFontCode);                     //0097
         wkOutParmWriteSrcDocDS.dsDocSeq = wkRpg3DocSeq;                                 //0097

      EndDo;                                                                             //0097
   EndSr;                                                                                //0097

End-Proc IndentRPGPseudoCode;                                                            //0038
//------------------------------------------------------------------------------------- //0042
//Subroutine SrAddPipesAndWriteRPG3PseudoCode - Append Pipes before the pseudocode      //0042
//               and write the pseudocode for RPG3 by breaking it for the case          //0042
//               that the length of pseudocode is more than 109 characters              //0042
//------------------------------------------------------------------------------------- //0042
Dcl-Proc SaveFileRecordFormatsNames ;                                                    //0042

  Dcl-Pi SaveFileRecordFormatsNames;                                                     //0042
    inFileName Char(10);                                                                 //0042
    inSrcDta   VarChar(cwSrcLength);                                                     //0042
  End-Pi;                                                                                //0042

  //Copybook declaration                                                                //0042
/copy 'QCPYSRC/iaprderlog.rpgleinc'

  Dcl-Ds wkRecordFormatDetails Qualified Dim(99);                                        //0042
     FileType  Char(1);                                                                  //0042
     FileAttribute Char(4);                                                              //0042
     RecordFormatName Char(10);                                                          //0042
  End-Ds;                                                                                //0042
  Dcl-S wkRowNum             Packed(4:0) Inz;                                            //0042
  Dcl-S wkElementCount       Packed(4:0) Inz;                                            //0042
  Dcl-S wkIdx                Packed(5:0) Inz;                                            //0042
  Dcl-S wkidx2               Packed(5:0) Inz;                                            //0042
  Dcl-S wkCount              Packed(4:0) Inz;                                            //0042
  Dcl-S wkIndexFlag          Char(1)     Inz;                                            //0042
  Dcl-S wkOriginalRcdFmtName Char(10)    Inz;                                            //0042
  Dcl-S wkRenamedRcdFmt      Char(10)    Inz;                                            //0042
  Dcl-S wkTmpPfName          Char(10)    Inz;                                            //0062
  Dcl-S wkSrcDta             VarChar(cwSrcLength) Inz;                                   //0042

 wkuDpsds.nbrparms = %parms;                                                             //0042
 EvaluatePSDS() ;                                                                        //0042

 wkSrcDta = %xlate(cwLo : cwUp : inSrcDta);                                              //0042
 //Retrieve the renamed record format name.                                             //0042
 wkIdx = 1;                                                                              //0042
 wkIdx = %scan('RENAME(' : wkSrcDta : wkIdx );                                           //0042
 If wkIdx <> 0;                                                                          //0042
    wkIdx = wkIdx + 7; //Move the index value after opening bracket.                     //0042
    wkIdx2 = %scan(':' : wkSrcDta : wkIdx );                                             //0042
    If wkIdx2 <> 0 and wkIdx2>wkIdx;                                                     //0042
       wkOriginalRcdFmtName = %subst(wkSrcDta : wkIdx : wkIdx2-wkIdx);                   //0042
       wkIdx = %scan(')' : wkSrcDta : wkIdx2 );                                          //0042
       If wkIdx <> 0 and wkIdx - wkidx2>0;                                               //0042
          wkRenamedRcdFmt   = %subst(wkSrcDta : wkIdx2+1 : wkIdx-wkIdx2-1);              //0042
       EndIf;                                                                            //0042
    EndIf;                                                                               //0042
  EndIf;                                                                                 //0042
   //Declare cursor to retrieve record format names of the file delared in F spec       //0042
   Exec Sql                                                                              //0042
         Declare RetrieveRecordFormatNameCursor Cursor for                               //0042
            Select RfFTyp, RfFilA, RFNAME from iDspfdRfmt                                //0042
             Where RfFile = :inFileName                                                  //0042
             For Fetch Only;                                                             //0042
   wkElementCount = %Elem(wkRecordFormatDetails);                                        //0042

   Exec Sql Open RetrieveRecordFormatNameCurSor;                                         //0042

   Select;
   When SqlCode = Csr_Opn_Cod;                                                           //0042
      Exec Sql Close RetrieveRecordFormatNameCursor;                                     //0042
      Exec Sql Open RetrieveRecordFormatNameCursor;                                      //0042

   When SqlCode < SuccessCode;                                                           //0042
      uDpsds.wkQuery_Name = 'Open_RetrieveRecordFormatNameCursor';                       //0042
      IaSqlDiagnostic(uDpsds);                                                           //0042

   When Sqlcode = successCode;                                                           //0042
      Exec Sql                                                                           //0042
         Fetch RetrieveRecordFormatNameCursor For :wkElementCount  Rows                  //0042
         Into :wkRecordFormatDetails;                                                    //0042

      For wkRowNum = 1 to SQLER3;                                                        //0042
          //For every record format, store the file type, file name & record format     //0042
          DsDeclaredFileRecordFormats.Count +=1;                                         //0042
          wkCount = DsDeclaredFileRecordFormats.Count;                                   //0042
          DsDeclaredFileRecordFormats.FileName(wkCount) =inFileName;                     //0042

          //Decide file type                                                            //0042
          Select;                                                                        //0042
          When wkRecordFormatDetails(wkRowNum).FileType='P';                             //0042
               DsDeclaredFileRecordFormats.FileType(wkCount) = 'TABLE';                  //0042

          When wkRecordFormatDetails(wkRowNum).FileType='L';                             //0042
               //Retrieve physical file name on which logical is based                   //0062
               wkTmpPfName = *Blanks;                                                    //0062
               exec sql select MBBOF into :wkTmpPFName from IDspfdMbr                    //0062
                          where MBFILE = :inFileName Limit 1;                            //0062
               If wkTmpPfName <> *Blanks;                                                //0062
                  DsDeclaredFileRecordFormats.PFName(wkCount) = wkTmpPfName;             //0062
               EndIf;                                                                    //0062
               wkIndexFlag = 'N';                                                        //0042
               exec sql select 'Y' into :wkIndexFlag from IDspFDKeys                     //0042
                          where APKeyF <> ' ' and APKeyF <> '*NONE'                      //0042
                          and APFile = :inFileName and APJoin <>'Y';                     //0042
                If wkIndexFlag = 'Y';                                                    //0042
                   DsDeclaredFileRecordFormats.FileType(wkCount) = 'INDEX';              //0042
                Else;                                                                    //0042
                   DsDeclaredFileRecordFormats.FileType(wkCount) = 'VIEW';               //0042
                EndIf;                                                                   //0042

          When wkRecordFormatDetails(wkRowNum).FileAttribute='*PRT';                     //0042
               DsDeclaredFileRecordFormats.FileType(wkCount) = 'REPORT';                 //0042

          When wkRecordFormatDetails(wkRowNum).FileAttribute='*DSP';                     //0042
               DsDeclaredFileRecordFormats.FileType(wkCount) = 'SCREEN';                 //0042
          EndSl;                                                                         //0042
          //Check if current record format is renamed, if so save the new name          //0042
          If   wkRenamedRcdFmt <> *Blanks and                                            //0042
               wkRenamedRcdFmt <>wkRecordFormatDetails(wkRowNum).RecordFormatName;       //0042
               DsDeclaredFileRecordFormats.RecordFormatName(wkCount)=wkRenamedRcdFmt;    //0042
          Else;                                                                          //0042
               DsDeclaredFileRecordFormats.RecordFormatName(wkCount)=                    //0042
                        wkRecordFormatDetails(wkRowNum).RecordFormatName;                //0042
          EndIf;                                                                         //0042
      EndFor;                                                                            //0042

   EndSl;                                                                                //0042
   Exec Sql Close RetrieveRecordFormatNameCursor;                                        //0042

   //Copy book Declaration for error handling                                           //0042
/copy 'QCPYSRC/iaprcerlog.rpgleinc'

End-Proc SaveFileRecordFormatsNames ;                                                    //0042
//------------------------------------------------------------------------------------- //0042
//CheckClearedRecordFormat : Check if the variable getting cleared is file record format//0042
//------------------------------------------------------------------------------------- //0042
Dcl-Proc CheckClearedRecordFormat ;                                                      //0042

  Dcl-Pi CheckClearedRecordFormat;                                                       //0042
    wkOpCode    Char(10);                                                                //0062
    wkiAKeyFld2 Char(10);                                                                //0042
    inSrcDta    VarChar(cwSrcLength);                                                    //0042
  End-Pi;                                                                                //0042

  //Copybook declaration                                                                //0042
/copy 'QCPYSRC/iaprderlog.rpgleinc'

  Dcl-S wkIdx           Packed(4:0)          Inz;                                        //0042
  Dcl-S wkVariableName  Char(50)             Inz;                                        //0042
  Dcl-S wkRcdFmtToCheck Char(10)             Inz;                                        //0042
  Dcl-S wkSrcDta        VarChar(cwSrcLength) Inz;                                        //0042
  Dcl-S wkSrcDta1       VarChar(cwSrcLength) Inz;                                        //0042

  //Get upper character data (Remove CLEAR keyword)                                     //0042
  wkSrcDta1=%xlate(cwLo : cwUp : inSrcDta);                                              //0042
  //Check if the OP-CODE exists OR not in the list of file related op-code               //0062
  If wkOpCode = *Blanks OR                                                               //0062
     %lookup(wkOpCode :DsFileRelatedOpCodes.OpCode :1 :DsFileRelatedOpCodes.Count)=0;    //0062
     Return;                                                                             //0062
  Else;                                                                                  //0062
     //In case op-code is found in the list of file related op-codes, remove it          //0062
     wkSrcDta=%subst(wkSrcDta1 :%Scan(wkOpCode :wkSrcDta1)+%len(%trimr(wkOpCode))+1);    //0062
  EndIf;                                                                                 //0062

  //Extract name of variable getting cleared                                            //0042
  wkIdx = %scan(';' : wkSrcDta);                                                         //0042
  If wkIdx = 0;                                                                          //0042
     wkVariableName = %Trim(wkSrcDta);                                                   //0042
  Else;                                                                                  //0042
     wkVariableName = %Trim(%Subst(wkSrcDta : 1 : wkIdx-1));                             //0042
  EndIf;                                                                                 //0042

  //If length of variable name is more than 10 characters, consider it's not            //0042
  // a record format, otherwise proceed                                                 //0042
  If %len(%trimr(wkVariableName)) <=10;                                                  //0042
     wkRcdFmtToCheck = %Trim(wkVariableName);                                            //0042
     wkIdx=%lookup(wkRcdFmtToCheck : DsDeclaredFileRecordFormats.RecordFormatName :      //0042
                                 1 : DsDeclaredFileRecordFormats.Count);                 //0042
     If wkIdx <> 0;                                                                      //0042
        wkiAKeyFld2 = DsDeclaredFileRecordFormats.FileType(wkIdx);                       //0042
     Else;                                                                               //0062
        //In case the variable name is not found in the list of record formats, search   //0062
        //it in the list of file names                                                   //0062
        wkIdx=%lookup(wkRcdFmtToCheck : DsDeclaredFileRecordFormats.FileName :           //0062
                                 1 : DsDeclaredFileRecordFormats.Count);                 //0062
        If wkIdx <> 0;                                                                   //0062
           wkiAKeyFld2 = DsDeclaredFileRecordFormats.FileType(wkIdx);                    //0062
        EndIf;                                                                           //0062
     EndIf;                                                                              //0042
  EndIf;                                                                                 //0042
  Return;                                                                                //0062

   //Copy book Declaration for error handling                                           //0042
/copy 'QCPYSRC/iaprcerlog.rpgleinc'


End-Proc CheckClearedRecordFormat ;                                                      //0042
//------------------------------------------------------------------------------------- //0042
//GetMappingData: Get the mapping data from the data structure storing IAPSEUDOMP data  //0042
//------------------------------------------------------------------------------------- //0042
Dcl-Proc GetMappingData ;                                                                //0042

  Dcl-Pi GetMappingData Ind;                                                             //0042
  End-Pi;                                                                                //0042

  //Copybook declaration                                                                //0042
/copy 'QCPYSRC/iaprderlog.rpgleinc'

  Dcl-S  wkMappingFoundInd     Ind             Inz;                                      //0042
  Dcl-S  wkiAKeyFld1           Like(wkDclType) Inz;                                      //0042

  wkMappingFoundInd = *Off;                                                              //0042
  Clear DsMappingOutData;                                                                //0042
  wkiAKeyFld1 = %Xlate(cwLo : cwUp : wkDclType);                                         //0042
  wkMapIdx= %lookup(wkSrcLtyp + wkSrcSpec + wkiAKeyFld1 + wkiAKeyFld2 :                  //0042
                    iAPSeudoMpDs(*).Key : 1 : wkiAPseudoMpCount);                        //0042
  If  wkMapIdx > 0;                                                                      //0042
      wkkeyFld2     =  iAPSeudoMpDs(wkMapIdx).iAKeyFld2   ;                              //0042
      wkkeyFld3     =  iAPSeudoMpDs(wkMapIdx).iAKeyFld3   ;                              //0042
      wkkeyFld4     =  iAPSeudoMpDs(wkMapIdx).iAKeyFld4   ;                              //0042
      wkIndentType  =  iAPSeudoMpDs(wkMapIdx).iAIndntTy   ;                              //0042
      wkSubsChr     =  iAPSeudoMpDs(wkMapIdx).iASubSChr   ;                              //0042
      wkActionType  =  iAPSeudoMpDs(wkMapIdx).iAActType   ;                              //0042
      wkSrcMapOut   =  iAPSeudoMpDs(wkMapIdx).iASrcMap    ;                              //0042
      wkSearchFld1  =  iAPSeudoMpDs(wkMapIdx).iASrhFld1   ;                              //0042
      wkSearchFld2  =  iAPSeudoMpDs(wkMapIdx).iASrhFld2   ;                              //0042
      wkSearchFld3  =  iAPSeudoMpDs(wkMapIdx).iASrhFld3   ;                              //0042
      wkSearchFld4  =  iAPSeudoMpDs(wkMapIdx).iASrhFld4   ;                              //0042
      wkCommentDesc =  iAPSeudoMpDs(wkMapIdx).iACmtDesc   ;                              //0042
      wkMappingFoundInd = *On;                                                           //0042
  EndIf;                                                                                 //0042

  Return wkMappingFoundInd;                                                              //0042

  //Copy book Declaration for error handling                                            //0042
/copy 'QCPYSRC/iaprcerlog.rpgleinc'
End-Proc GetMappingData ;                                                                //0042
//------------------------------------------------------------------------------------- //0050
//ConvertVarAndKeywordNamesToCaps: Convert variable names & keywords to caps             //0050
//------------------------------------------------------------------------------------- //0050
Dcl-Proc ConvertVarAndKeywordNamesToCaps ;                                               //0050

   Dcl-Pi ConvertVarAndKeywordNamesToCaps;                                               //0050
      inSrcData varchar(cwSrcLength);                                                    //0050
   End-Pi;                                                                               //0050

   Dcl-Ds DsStrings Qualified Inz;                                                       //0050
      StringName  Char(10)          Dim(99);                                             //0050
      StringValue Char(cwSrcLength) Dim(99);                                             //0050
      Factor1Ind  Ind;
      StringCount Packed(3:0);                                                           //0050
   End-Ds;                                                                               //0050
   Dcl-Ds CspecDsV4Chk LikeDs(CSpecDsV4);
   Dcl-S wkSrcData      Char(cwSrcLength) Inz;                                           //0050
   Dcl-S wkTempSrcData  Char(cwSrcLength) Inz;                                           //0050
   Dcl-S wkStrPos       Packed(4:0)       Inz;                                           //0050
   Dcl-S wkEndPos       Packed(4:0)       Inz;                                           //0050
   Dcl-S wkIdx          Packed(4:0)       Inz;                                           //0050
   Dcl-S wkIdx2         Packed(4:0)       Inz;                                           //0050
   Dcl-C cwDquote       '"';                                                             //0050

   //Copybook declaration                                                               //0050
/copy 'QCPYSRC/iaprderlog.rpgleinc'

   //Special handling has been done for Factor 1 as for factor 1 string, the position    //0050
   //of the op-code etc. is not expected to be moved while replacing back the strings    //0050
   //and the string will be ending without any operator symbol                           //0050

   wkSrcData = inSrcData;                                                                //0050
   CSpecDsV4Chk = %Trimr(inSrcData);                                                     //0050
   //In case the input string is blank, return                                           //0050
   If wkSrcData = *Blanks;                                                               //0050
      Return;                                                                            //0050
   ElseIf  %scan(';' : wkSrcData) = 0 and                                                //0050
           CSpecDsV4Chk.C_Factor1<>*Blanks and                                           //0050
           %subst(%Trim(CSpecDsV4Chk.C_Factor1) : 1 : 1) = cwDQuote;                     //0050
      DsStrings.Factor1Ind = *On;                                                        //0050
   EndIf;                                                                                //0050

   Monitor;                                                                              //0050
      Exsr SrIdentifyStrings;                                                            //0050
      Exsr SrConvertVarToUpper;                                                          //0050
      //Move the new value back to input source data                                     //0050
      inSrcData = wkSrcData;                                                             //0050
   On-Error;                                                                             //0050
   EndMon;                                                                               //0050

   Return;                                                                               //0050
   //---------------------------------------------------------------------------------- //0050
   // SrIdentifyStrings - Identify strings in source data                               //0050
   //---------------------------------------------------------------------------------- //0050
   BegSr SrIdentifyStrings;                                                              //0050

      //First check for strings Pickup from source data and replace with &TMP_STRxx      //0050
      //(where xx= number of string)                                                     //0050
      DoW  %scan(cwDquote : wkSrcData) <> 0;                                             //0050
        wkStrPos = %scan(cwDquote : wkSrcData);                                          //0050
        If wkStrPos < %len(%trimr(wkSrcData));                                           //0050
           wkEndPos = %scan(cwDquote : wkSrcData : wkStrPos+1);                          //0050
           //Ensure this ending quote is actually the ending quote of the string & not   //0050
           //the part of the string itself. For this check for next double quote, if     //0050
           //found and there is no '+',':','-' or '||' character before it, consider the //0050
           //next double quote as ending quote. In case one of these concatenating       //0050
           //character is found and immediate non-blank character before these concate-  //0050
           //nating character is at same position as of ending quote, consider that      //0050
           //as and operator otherwise consider it a part of string.                     //0050
           If  wkEndPos < %len(%trimr(wkSrcData));                                       //0050
               DoW %scan(cwDquote : wkSrcData : wkEndPos+1) <> 0;                        //0050
                   wkIdx = %scan(cwDquote : wkSrcData : wkEndPos+1);                     //0050
                   Select;                                                               //0050
                     When %scan(';' : wkSrcData) = 0 and                                 //0050
                        CSpecDsV4Chk.C_Factor1<>*Blanks and                              //0050
                        %subst(%Trim(CSpecDsV4Chk.C_Factor1) : 1 : 1) = cwDQuote;        //0050
                        wkEndPos = wkStrPos +                                            //0050
                                  %len(%trimr(CSpecDsV4Chk.C_Factor1))-1;                //0050
                        Leave;                                                           //0050

                     When %scan('+' : wkSrcData : wkEndPos+1 :                           //0050
                        wkIdx - wkEndPos-1) <> 0;                                        //0050
                        wkIdx2= %checkr(' +': wkSrcData : wkEndPos);                     //0050
                        If wkidx2 = wkEndPos;                                            //0050
                           Leave;                                                        //0050
                        Else;                                                            //0050
                           wkEndPos = wkIdx;                                             //0050
                        EndIf;                                                           //0050

                     When  %scan('-' : wkSrcData : wkEndPos+1 :                          //0050
                        wkIdx - wkEndPos-1) <> 0;                                        //0050
                        wkIdx2= %checkr(' -': wkSrcData : wkEndPos);                     //0050
                        If wkidx2 = wkEndPos;                                            //0050
                           Leave;                                                        //0050
                        Else;                                                            //0050
                           wkEndPos = wkIdx;                                             //0050
                        EndIf;                                                           //0050

                     When  %scan(':' : wkSrcData : wkEndPos+1 :                          //0050
                        wkIdx - wkEndPos-1) <> 0;                                        //0050
                        wkIdx2= %checkr(' :': wkSrcData : wkEndPos);                     //0050
                        If wkidx2 = wkEndPos;                                            //0050
                           Leave;                                                        //0050
                        Else;                                                            //0050
                           wkEndPos = wkIdx;                                             //0050
                        EndIf;                                                           //0050

                     When  %scan('||' : wkSrcData : wkEndPos+1 :                         //0050
                        wkIdx - wkEndPos-1) <> 0;                                        //0050
                        wkIdx2= %checkr(' |': wkSrcData : wkEndPos);                     //0050
                        If wkidx2 = wkEndPos;                                            //0050
                            Leave;                                                       //0050
                        Else;                                                            //0050
                           wkEndPos = wkIdx;                                             //0050
                        EndIf;                                                           //0050

                     When  %scan(' OR ' : %xlate(cwLo : cwUp : wkSrcData)  :             //0050
                        wkEndPos+1 : wkIdx - wkEndPos-1) <> 0;                           //0050
                        wkIdx2= %checkr(' OR ': wkSrcData : wkEndPos);                   //0050
                        If wkidx2 = wkEndPos;                                            //0050
                            Leave;                                                       //0050
                        Else;                                                            //0050
                           wkEndPos = wkIdx;                                             //0050
                        EndIf;                                                           //0050

                     When  %scan(' AND ' : %xlate(cwLo : cwUp : wkSrcData)  :            //0050
                        wkEndPos+1 : wkIdx - wkEndPos-1) <> 0;                           //0050
                        wkIdx2= %checkr(' AND ': wkSrcData : wkEndPos);                  //0050
                        If wkidx2 = wkEndPos;                                            //0050
                            Leave;                                                       //0050
                        Else;                                                            //0050
                           wkEndPos = wkIdx;                                             //0050
                        EndIf;                                                           //0050

                     Other;                                                              //0050
                        wkEndPos = wkIdx;                                                //0050

                   EndSl;                                                                //0050
                   If  wkEndPos = %len(%trimr(wkSrcData));                               //0050
                       Leave;                                                            //0050
                   EndIf;                                                                //0050
               EndDo;                                                                    //0050
           EndIf;                                                                        //0050

           //Retrieve the string and replace it with special string name.               //0050
           If  wkStrPos <> 0 and wkEndPos <> 0 and wkEndPos > wkStrPos;                  //0050
               DsStrings.StringCount +=1;                                                //0050
               wkIdx = DsStrings.StringCount;                                            //0050
               DsStrings.StringName(wkIdx) =                                             //0050
                           '&TMP_STR'+%subst(%Editc(DsStrings.StringCount:'X'):2:2);     //0088
               DsStrings.StringValue(wkIdx) =                                            //0050
               %subst(wkSrcData : wkStrPos : wkEndPos - wkStrPos+1);                     //0050
              //Replacing in main string with special name (moving all data in same     //0050
              //case to wkTempSrcData  variable temporarily for using it in substrng)   //0050
              wkTempSrcData   = wkSrcData;                                               //0050
              If wkStrPos>1 ;                                                            //0050
                 wkSrcData=%subst(wkTempSrcData : 1 : wkStrPos-1) +                      //0050
                 DsStrings.StringName(wkIdx) ;                                           //0050
              Else;                                                                      //0050
                 wkSrcData= DsStrings.StringName(wkIdx);                                 //0050
              EndIf;                                                                     //0050

              If wkEndPos < %len(%trimr(wkTempSrcData));                                 //0050
                 If DsStrings.Factor1Ind = *On and wkEndPos < 26;                        //0050
                    %subst(wkSrcData:26) = %trim(%subst(wkTempSrcData : wkEndPos+1));    //0050
                 Else;                                                                   //0050
                    wkSrcData = %Trimr(wkSrcData) +                                      //0050
                                %Trimr( %subst(wkTempSrcData : wkEndPos+1));             //0050
                 EndIf;                                                                  //0050
              EndIf;                                                                     //0050
           Else;                                                                         //0050
               Leave;                                                                    //0050
           EndIf;                                                                        //0050

        Else;                                                                            //0050
           Leave;                                                                        //0050
        EndIf;                                                                           //0050
      EndDo;                                                                             //0050

   EndSr;                                                                                //0050
   //---------------------------------------------------------------------------------- //0050
   // SrConvertVarToUpper - Convert variables to upper characters                       //0050
   //---------------------------------------------------------------------------------- //0050
   BegSr SrConvertVarToUpper;                                                            //0050
      //Convert the source data after removing strings to upper case                     //0050
      wkSrcData = %Xlate(cwLo : cwUp : wkSrcData);                                       //0050
      //Replace back the strings as it is in the actual source data                      //0050
      For wkIdx = 1 To DsStrings.StringCount;                                            //0050
         If DsStrings.Factor1Ind = *On;                                                  //0050
            CSpecDsV4Chk = %Trimr(wkSrcData);                                            //0050
            CSpecDsV4Chk.C_Factor1 = DsStrings.StringValue(wkIdx);                       //0050
            wkSrcData    = CSpecDsV4Chk;                                                 //0050
            DsStrings.Factor1Ind = *Off;                                                 //0050
         Else;                                                                           //0050
            wkSrcData = %scanrpl(%Trim(DsStrings.StringName(wkIdx))   :                  //0050
                                 %Trimr(DsStrings.StringValue(wkIdx)) :                  //0050
                                 wkSrcData);                                             //0050
         EndIf;                                                                          //0050
      EndFor;                                                                            //0050

   EndSr;                                                                                //0050

   //Copy book Declaration for error handling                                           //0050
/copy 'QCPYSRC/iaprcerlog.rpgleinc'
End-Proc ConvertVarAndKeywordNamesToCaps;                                                //0050
//------------------------------------------------------------------------------------- //0070
//Procedure to Parse I spec RPGLE code to Write Pseudocode                              //0070
//------------------------------------------------------------------------------------- //0070
Dcl-Proc IaFixedFormatISpecParser  Export ;                                              //0070

   Dcl-Pi *n;                                                                            //0070
      inParmPointer Pointer;                                                             //0070
   End-Pi;                                                                               //0070

   //Input Parameter Data Structure                                                     //0070
   Dcl-Ds wkFX4ParmDs LikeDs(DsInputParmDsTmp) Based(inParmPointer);                     //0070

   //DS for writing header                                                               //0070
   Dcl-Ds wkHdrParmDs LikeDs(SpecHeaderDS) Inz;                                          //0070

   //DS to store the values in output format                                             //0070
   Dcl-Ds wkDSForOutput Qualified;                                                       //0070
      RecFldName     char(17) pos(1)  Inz;                                               //0070
      Delimiter1     char(1)  pos(20) Inz('|');                                          //0070
      ReNamed        char(14) pos(22) Inz;                                               //0070
      Delimiter2     char(1)  pos(36) Inz('|');                                          //0070
      Position       char(6)  pos(37) Inz;                                               //0070
      Delimiter3     char(1)  pos(43) Inz('|');                                          //0070
      Length         char(7)  pos(45) Inz;                                               //0070
      Delimiter4     char(1)  pos(52) Inz('|');                                          //0070
      DataType       char(1)  pos(55) Inz;                                               //0070
      Delimiter5     char(1)  pos(58) Inz('|');                                          //0070
      DateTimeFormat char(4)  pos(60) Inz;                                               //0070
   End-Ds;                                                                               //0070

   Dcl-C cwHeaderKey2  Const('ISPECHDR');                                                //0070
 //Dcl-C cwDigits      Const('01234567890 ');                                      //0095//0070

   Dcl-S wkPromptType        Char(2)     Inz;                                            //0070
   Dcl-S IOPointer           Pointer     Inz;                                            //0070
   //Copybook declaration                                                               //0070
/copy 'QCPYSRC/iaprderlog.rpgleinc'

   //Initialization                                                                      //0070
   IspecDsV4 = %xlate(cwLo : cwUP : wkFX4ParmDs.dsPseudoCode);                           //0070
   Eval-Corr OutParmWriteSrcDocDS = wkFX4ParmDs;                                         //0070
   Eval-Corr wkHdrParmDs          = wkFX4ParmDs;                                         //0070
   wkHdrParmDs.dsKeyfld           = cwHeaderKey2;                                        //0070

   //Identify the prompt type                                                            //0070
   Select;                                                                               //0070
      When  ISpecDSV4.ChkFor_I_Prompt <> *Blanks;                                        //0070
         wkPromptType = 'I';                                                             //0070

      When  ISpecDSV4.ChkFor_JX_Prompt <> *Blanks;                                       //0070
         wkPromptType = 'JX';                                                            //0070

      Other;                                                                             //0070
         wkPromptType = 'J';                                                             //0070

   EndSl;                                                                                //0070

   //Move the values for printing into DS fields                                         //0070
   Exsr SrMoveISpecValuesToDS;                                                           //0070

   //Write the output to file                                                            //0070
   Exsr SrWriteISpecData;                                                                //0070

   //---------------------------------------------------------------------------------- //0070
   // SrMoveISpecValuesToDS - Move values to output DS                                  //0070
   //---------------------------------------------------------------------------------- //0070
   BegSr SrMoveISpecValuesToDS;                                                          //0070

      //Move values to output DS based on prompt type                                    //0070
      Select;                                                                            //0070

         When  wkPromptType = 'I';                                                       //0070
            wkDSForOutput.RecFldName  = ISpecDsV4.file_RecFmt_Ds_Name;                   //0070

         When  wkPromptType = 'JX';                                                      //0070
            %subst(wkDSForOutput.RecFldName:3) = ISpecDsV4.external_Field_Name;          //0070
            wkDSForOutput.ReNamed              = ISpecDsV4.field_name;                   //0070

         Other;                                                                          //0070
            %subst(wkDSForOutput.RecFldName:3) = ISpecDsV4.field_name;                   //0070
            wkDSForOutput.Position             = ISpecDsV4.from_length;                  //0070
            //Calculate length                                                           //0070
            If %check(cwDigits : ISpecDsV4.from_length) = 0 and                          //0070
               %check(cwDigits : ISpecDsV4.to_length)   = 0 and                          //0070
               ISpecDsV4.from_length <> *Blanks and                                      //0070
               ISpecDsV4.to_length   <> *Blanks and                                      //0070
               ISpecDsV4.To_Pos_Num >= ISpecDsV4.From_Pos_Num;                           //0070

               wkDSForOutput.Length=%char(ISpecDsV4.To_Pos_Num-                          //0070
                                          ISpecDsV4.From_Pos_Num+1);                     //0070
               If ISpecDsV4.decimal_position <> *Blanks;                                 //0070
                  wkDSForOutput.Length =%Trim(wkDSForOutput.Length)+':'+                 //0070
                                        %Trim(ISpecDsV4.decimal_position);               //0070
               EndIf;                                                                    //0070

            EndIf;                                                                       //0070
            //Decide data type                                                           //0070
            Select;                                                                      //0070
              When ISpecDsV4.data_formate <> *Blanks;                                    //0070
                 wkDSForOutput.DataType =%Trim(ISpecDsV4.data_formate);                  //0070
              When ISpecDsV4.decimal_position <> *Blanks;                                //0070
                 wkDSForOutput.DataType ='P';                                            //0070
              Other;                                                                     //0070
                 wkDSForOutput.DataType ='A';                                            //0070
            EndSl;                                                                       //0070
            wkDSForOutput.DateTimeFormat =ISpecDsV4.Date_Time_Format;                    //0070

      EndSl;                                                                             //0070

   EndSr;                                                                                //0070

   //---------------------------------------------------------------------------------- //0070
   // SrWriteISpecData - Write I spec data to output file                               //0070
   //---------------------------------------------------------------------------------- //0070
   BegSr SrWriteISpecData;                                                               //0070

      //Write header in case of I prompt                                                 //0070
      If wkPromptType = 'I';                                                             //0070
         //Blank line first                                                              //0070
         Clear OutParmWriteSrcDocDS.dsPseudocode ;                                       //0070
         OutParmWriteSrcDocDS.dsPseudocode = *Blanks;                                    //0070
         IOPointer  = %Addr(OutParmWriteSrcDocDS);                                       //0070
         WritePseudoCode(IOPointer);                                                     //0070
         //Write header                                                                  //0070
         IOPointer = %addr(wkHdrParmDs);                                                 //0070
         iAWriteSpecHeader(ioPointer);                                                   //0070
      EndIf;                                                                             //0070

      //Write output data                                                                //0070
      Clear OutParmWriteSrcDocDS.dsPseudocode ;                                          //0070
      OutParmWriteSrcDocDS.dsPseudocode = wkDSForOutput;                                 //0070
      IOPointer  = %Addr(OutParmWriteSrcDocDS);                                          //0070
      WritePseudoCode(IOPointer);                                                        //0070

   EndSr;                                                                                //0070

   //Copy book Declaration for error handling                                           //0070
/copy 'QCPYSRC/iaprcerlog.rpgleinc'
End-Proc IaFixedFormatISpecParser;                                                       //0070

//--------------------------------------------------------------------------------------//0068
//Procedure to Write Pseudocode code in IAPSEUDOWK                                      //0068
//--------------------------------------------------------------------------------------//0068
Dcl-Proc WriteIaPseudowk Export;                                                         //0068
                                                                                         //0068
   Dcl-Pi *n;                                                                            //0068
      inParmPointer  Pointer;                                                            //0068
      inDocSeq       Packed(6:0);                                                        //0068
      inFontCode     Char(4) Options(*NoPass) Const;                                     //0068
   End-Pi;                                                                               //0068
                                                                                         //0068
   //Declaration of datastructure                                                       //0068
   Dcl-Ds wkOutParmDs Likeds(WritePseudoCodeDs) Based(inParmPointer) ;                   //0068
                                                                                         //0068
   //Declaration of work variables                                                      //0068
   Dcl-S ReqId Int(20) Inz;                                                              //0068
                                                                                         //0068
   //Copybook declaration                                                               //0068
/copy 'QCPYSRC/iaprderlog.rpgleinc'
                                                                                         //0068
   //If last written record was blank and current line is blank again, skip             //0031
   If %Check(' |' : wkLastwrittenData)       =   *Zeros And                              //0072
      %Check(' |' : wkOutParmDs.Pseudocode)  =   *Zeros And                              //0072
      inDocSeq <> 0;                                                                     //0072
      Return ;                                                                           //0072
   Endif;                                                                                //0072
                                                                                         //0072
   ReqId = %int(wkOutParmDs.ReqId) ;                                                     //0068
                                                                                         //0068
   //Increment the document Seq no                                                      //0068
   inDocSeq += 1;                                                                        //0068
    //Write the Pseudo code                                                             //0068
   exec sql                                                                              //0068
      insert into IAPSEUDOWK ( wkReqId,                                                  //0068
                               wkMbrLib,                                                 //0068
                               wkSrcFile,                                                //0068
                               wkMbrNam,                                                 //0068
                               wkMbrTyp,                                                 //0068
                               wkSrcRrn,                                                 //0068
                               wkSrcSeq,                                                 //0068
                               wkSrcLTyp,                                                //0068
                               wkSrcSpec,                                                //0068
                               wkDocSeq,                                                 //0068
                               wkGenPsCde,                                               //0068
                               wkFontCode)                                               //0068
                values ( :ReqID,                                                         //0068
                         :wkOutParmDs.SrcLib,                                            //0068
                         :wkOutParmDs.SrcPf,                                             //0068
                         :wkOutParmDs.SrcMbr,                                            //0068
                         :wkOutParmDs.SrcType,                                           //0068
                         :wkOutParmDs.SrcRrn,                                            //0068
                         :wkOutParmDs.SrcSeq ,                                           //0068
                         :wkOutParmDs.SrcLTyp,                                           //0068
                         :wkOutParmDs.SrcSpec,                                           //0068
                         :inDocSeq,                                                      //0068
                         :wkOutParmDs.Pseudocode,                                        //0068
                         :inFontCode);                                                   //0068
                                                                                         //0068
    If SqlCode < SuccessCode;                                                            //0068
       uDpsds.wkQuery_Name = 'Insert_2_IAPSEUDOWK';                                      //0068
       IaSqlDiagnostic(uDpsds);                                                          //0068
    EndIf;                                                                               //0068

    wkLastwrittenData = %Trim(wkOutParmDs.Pseudocode) ;                                  //0072
                                                                                         //0068
    Return;                                                                              //0068
/copy 'QCPYSRC/iaprcerlog.rpgleinc'
                                                                                         //0068
End-Proc;                                                                                //0068
//------------------------------------------------------------------------------------- //0074
//Procedure to write commented text to output file                                      //0074
//------------------------------------------------------------------------------------- //0074
Dcl-Proc IaWriteCommentedText Export ;                                                   //0074

  Dcl-Pi *n;                                                                             //0074
     inParmPointer Pointer;                                                              //0074
  End-Pi;                                                                                //0074

  //Input Parameter Data Structure                                                      //0074
  Dcl-Ds InParmDs Qualified Based(inParmPointer);                                        //0074
     dsReqId        Char(18);                                                            //0074
     dsSrcLib       Char(10);                                                            //0074
     dsSrcPf        Char(10);                                                            //0074
     dsSrcMbr       Char(10);                                                            //0074
     dsSrcType      Char(10);                                                            //0074
     dsSrcRrn       Packed(6:0);                                                         //0074
     dsSrcSeq       Packed(6:2);                                                         //0074
     dsSrcLtyp      Char(5);                                                             //0074
     dsSrcSpec      Char(1);                                                             //0074
     dsSrcLnct      Char(1);                                                             //0074
     dsSrcDta       VarChar(cwSrcLength);                                                //0074
     dsIOIndentParmPointer Pointer;                                                      //0074
     dsDclType      Char(10);                                                            //0074
     dsSubType      Char(10);                                                            //0074
     dsHCmtReqd     Char(1);                                                             //0074
     dsSkipNxtStm   ind;                                                                 //0074
     dsFileNames    char(10) dim(99);                                                    //0074
     dsFileCount    zoned(2:0);                                                          //0074
     dsName         Char(50);                                                            //0074
  End-Ds;                                                                                //0074

  Dcl-Ds wkRPGIndentParmDS  LikeDs(RPGIndentParmDSTmp);                                  //0074
  Dcl-S  IOParmPointer      Pointer       Inz(*Null);                                    //0074

  Dcl-S  wkTmpCntOfLines    Like(wkCountOfLineProcessAfterIndentation) Inz;              //0074
  Dcl-S  wkIdx      Packed(6:0) Inz;                                                     //0074
  Dcl-S  wkSrcDta   VarChar(cwSrcLength) Inz;                                            //0074

  IOIndentParmPointer  =  inParmDs.dsIOIndentParmPointer;                                //0074
  Eval-Corr wkRPGIndentParmDS = RPGIndentParmDS;                                         //0074
  Eval-Corr OutParmWriteSrcDocDS = inParmDs;                                             //0074
  wkSrcDta = inParmDs.dsSrcDta;                                                          //0074

  //Take backup of count of lines processed after indentation                            //0074
  wkTmpCntOfLines = wkCountOfLineProcessAfterIndentation;                                //0074

  //Remove '//' & '*' from the commented text while writing.                            //0074
  If %scan('//' : %trim(wkSrcDta)) = 1;                                                  //0074
     wkIdx = %scan('//' : wkSrcDta)+2;                                                   //0074
  Else;                                                                                  //0074
      wkIdx = %scan('*' : wkSrcDta : 7);                                                 //0074
      If wkIdx <> 0;                                                                     //0074
         wkIdx +=1;                                                                      //0074
      EndIf;                                                                             //0074
  EndIf;                                                                                 //0074

  If wkIdx <> 0;                                                                         //0074
     wkSrcDta = '--' + %trim(%subst(wkSrcDta : wkIdx));                                  //0074
  Else;                                                                                  //0074
     wkSrcDta = '--' + %trim(wkSrcDta);                                                  //0074
  EndIf;                                                                                 //0074

  //Include Indentation                                                                 //0074
  RPGIndentParmDs.dsIndentType = *Blanks ;                                               //0074
  RPGIndentParmDs.dsPseudocode = wkSrcDta;                                               //0074
  ioParmPointer = %Addr(RPGIndentParmDs);                                                //0074
  IndentRPGPseudoCode(ioParmPointer);                                                    //0074
  wkSrcDta = RPGIndentParmDs.dsPseudocode;                                               //0074

  //Write to document                                                                   //0074
  OutParmWriteSrcDocDS.dsPseudocode = wkSrcDta ;                                         //0074
  ioParmPointer = %Addr(OutParmWriteSrcDocDS);                                           //0074
  WritePseudoCode(ioParmPointer);                                                        //0074

  //Store back the no. of lines processed after indentation                              //0074
  wkCountOfLineProcessAfterIndentation = wkTmpCntOfLines;                                //0074
  Eval-Corr RPGIndentParmDS            =  wkRPGIndentParmDS;                             //0074
  InParmDs.dsIOIndentParmPointer       = IOIndentParmPointer;                            //0074

End-Proc IaWriteCommentedText;                                                           //0074
//------------------------------------------------------------------------------------- //0091
//Procedure to get data for a logical file like key fields, Select/Omit, Constraints    //0091
//------------------------------------------------------------------------------------- //0091
Dcl-Proc IaGetLogicalFileDetails  Export ;                                               //0091
                                                                                         //0091
   Dcl-Pi *n ;                                                                           //0091
      inCallMode              Char(1)     Const ;                                        //0091
      indsFSpecLFNewFormat    likeDS(TdsFSpecLFNewFormat) ;                              //0091
      inKeyWrdPointer         Pointer ;                                                  //0091
      inKeyWrdCntr            Packed(2:0) ;                                              //0091
   End-Pi ;                                                                              //0091
                                                                                         //0091
   //Data structure declarations                                                         //0091
   Dcl-Ds dsFSpecLFNewFormat   likeDS(TdsFSpecLFNewFormat)  Inz(*likeDS) ;               //0091
   Dcl-Ds dsFSpecKeywords      likeDS(TdsFSpecKeywords)     Dim(99)                      //0091
                               Based(inKeyWrdPointer) ;                                  //0091
                                                                                         //0091
   //Variable declarations                                                               //0091
   Dcl-S  wkSQLFileType        Char(1)             Inz ;                                 //0091
   Dcl-S  wkForCounter         Packed(2:0)         Inz ;                                 //0091
   Dcl-S  IOParmPointer        Pointer             Inz(*Null) ;                          //0091
   Dcl-S  wkCstName            Varchar(258)        Inz ;                                 //0091
   Dcl-S  wkCstText            Varchar(2000)       Inz ;                                 //0091
   Dcl-S  wkArrayElemCnt       Packed(3:0)         Inz ;                                 //0091
   Dcl-S  wkPseudoFileCode     Char(cwSrcLength)   Inz ;                                 //0091
   Dcl-S  wkPseudoFileCodebkp  Like(wkPseudoFileCode) Inz ;                              //0091
                                                                                         //0091
   //Constant declarations                                                               //0091
   Dcl-C  cwDelimiter        Const('| ') ;                                               //0091
                                                                                         //0091
   //Copybook declaration                                                               //0091
/copy 'QCPYSRC/iaprderlog.rpgleinc'
                                                                                         //0091
   Eval-corr dsFSpecLFNewFormat = indsFSpecLFNewFormat ;                                 //0091
                                                                                         //0091
   Select ;                                                                              //0091
   When InCallMode = cwStoreData ;                                                       //0091
      Clear dsSelectOmit ;                                                               //0091
      Clear dsKeyField ;                                                                 //0091
      Clear dsFileFormat ;                                                               //0091
      wkFileDtlCntr = *Zeros ;                                                           //0091
                                                                                         //0091
      //Get the physical file name on which LF is based                                  //0091
      Exsr RetrieveFileFormats ;                                                         //0091
                                                                                         //0091
      //Get the keyfields for the logical file                                           //0091
      Exsr RetrieveKeyFields ;                                                           //0091
      //Get Select/Omit criterion for logical file                                       //0091
      Exsr RetrieveSelectOmit ;                                                          //0091
                                                                                         //0091
   When InCallMode = cwWriteData ;                                                       //0091
      Clear wkPseudoFileCode ;                                                           //0091
      If wkFileDtlCntr = *Zeros ;                                                        //0091
         wkFileDtlCntr = 1 ;                                                             //0091
      Endif ;                                                                            //0091
      Exsr WriteFileDataMultRows ;                                                       //0091
   EndSl ;                                                                               //0091
                                                                                         //0091
   Return ;                                                                              //0091
                                                                                         //0091
//------------------------------------------------------------------------------------- //0091
//Subroutine RetrieveFileFormats - Read the File formats for Logical file and save to   //0091
//                                  array for merge later                                //0091
//------------------------------------------------------------------------------------- //0091
   Begsr RetrieveFileFormats ;                                                           //0091
      Exec SQL                                                                           //0091
         Declare FileFormats Cursor For                                                  //0091
         Select distinct APBOF                                                           //0091
         From IDSPFDKEYS                                                                 //0091
         Where APFILE = :indsFSpecLFNewFormat.dsName                                     //0091
         For Fetch Only ;                                                                //0091
                                                                                         //0091
      wkArrayElemCnt = %Elem(dsFileFormat) ;                                             //0091
                                                                                         //0091
      Exec Sql Open FileFormats ;                                                        //0091
      If SqlCode = CSR_OPN_COD ;                                                         //0091
         Exec Sql Close FileFormats ;                                                    //0091
         Exec Sql Open  FileFormats ;                                                    //0091
      EndIf;                                                                             //0091
                                                                                         //0091
      If SqlCode < successCode ;                                                         //0091
         uDpsds.wkQuery_Name = 'Open_FileFormats' ;                                      //0091
         IaSqlDiagnostic(uDpsds) ;                                                       //0091
      EndIf ;                                                                            //0091
                                                                                         //0091
      If SqlCode = SuccessCode ;                                                         //0091
         //Get the file formats from DSPFD data for file                                //0091
         Exec Sql Fetch FileFormats                                                      //0091
            For :wkArrayElemCnt Rows                                                     //0091
            Into :dsFileFormat ;                                                         //0091
                                                                                         //0091
         If SqlCode < successCode ;                                                      //0091
            uDpsds.wkQuery_Name = 'Fetch_FileFormats' ;                                  //0091
            IaSqlDiagnostic(uDpsds) ;                                                    //0091
         Else ;                                                                          //0091
            wkFileDtlCntr = SQLER3 ;                                                     //0091
         EndIf ;                                                                         //0091
      EndIf ;                                                                            //0091
      Exec Sql Close FileFormats ;                                                       //0091
   Endsr ;                                                                               //0091
                                                                                         //0091
//------------------------------------------------------------------------------------- //0091
//Subroutine RetrieveKeyFields - Read the keyfields for Logical file and save to array  //0091
//------------------------------------------------------------------------------------- //0091
   Begsr RetrieveKeyFields ;                                                             //0091
      Exec Sql                                                                           //0091
         Declare KeyFields Cursor For                                                    //0091
            Select APKEYF                                                                //0091
            From IDSPFDKEYS                                                              //0091
            Where APFILE = :indsFSpecLFNewFormat.dsName                                  //0091
            For Fetch Only ;                                                             //0091
                                                                                         //0091
      wkArrayElemCnt = %Elem(dsKeyField) ;                                               //0091
                                                                                         //0091
      Exec Sql Open KeyFields ;                                                          //0091
      If SqlCode = CSR_OPN_COD ;                                                         //0091
         Exec Sql Close KeyFields ;                                                      //0091
         Exec Sql Open  KeyFields ;                                                      //0091
      EndIf;                                                                             //0091
                                                                                         //0091
      If SqlCode < successCode ;                                                         //0091
         uDpsds.wkQuery_Name = 'Open_KeyFields' ;                                        //0091
         IaSqlDiagnostic(uDpsds) ;                                                       //0091
      EndIf ;                                                                            //0091
                                                                                         //0091
      If SqlCode = SuccessCode ;                                                         //0091
         //Get the keyfields from DSPFD data for file                                   //0091
         Exec Sql Fetch KeyFields                                                        //0091
            For :wkArrayElemCnt Rows                                                     //0091
            Into :dsKeyField ;                                                           //0091
                                                                                         //0091
         If SqlCode < successCode ;                                                      //0091
            uDpsds.wkQuery_Name = 'Fetch_KeyFields' ;                                    //0091
            IaSqlDiagnostic(uDpsds) ;                                                    //0091
         Else ;                                                                          //0091
            If wkFileDtlCntr < SQLER3 ;                                                  //0091
               wkFileDtlCntr = SQLER3 ;                                                  //0091
            Endif ;                                                                      //0091
         EndIf ;                                                                         //0091
      EndIf ;                                                                            //0091
      Exec Sql Close KeyFields ;                                                         //0091
   Endsr ;                                                                               //0091
                                                                                         //0091
//------------------------------------------------------------------------------------- //0091
//Subroutine RetrieveSelectOmit - Read the Select/Omit criterion for Logical file       //0091
//                                 and save to array                                     //0091
//------------------------------------------------------------------------------------- //0091
   Begsr RetrieveSelectOmit ;                                                            //0091
      Exec Sql                                                                           //0091
         Declare SelectOmit Cursor For                                                   //0091
            Select SORULE, ': ', SOFLD, SOCOMP, SOVALU                                   //0091
            From IDSPFDSLOM                                                              //0091
            Where SOFILE = :indsFSpecLFNewFormat.dsName                                  //0091
            For Fetch Only ;                                                             //0091
                                                                                         //0091
      wkArrayElemCnt = %Elem(dsSelectOmit) ;                                             //0091
                                                                                         //0091
      Exec Sql Open SelectOmit ;                                                         //0091
      If SqlCode = CSR_OPN_COD ;                                                         //0091
         Exec Sql Close SelectOmit ;                                                     //0091
         Exec Sql Open  SelectOmit ;                                                     //0091
      EndIf;                                                                             //0091
                                                                                         //0091
      If SqlCode < successCode ;                                                         //0091
         uDpsds.wkQuery_Name = 'Open_SelectOmit' ;                                       //0091
         IaSqlDiagnostic(uDpsds) ;                                                       //0091
      EndIf ;                                                                            //0091
                                                                                         //0091
      If SqlCode = SuccessCode ;                                                         //0091
         //Get the Select Omit criterion from DSPFD data for file                       //0091
         Exec Sql Fetch SelectOmit                                                       //0091
            For :wkArrayElemCnt Rows                                                     //0091
            Into :dsSelectOmit ;                                                         //0091
                                                                                         //0091
         If SqlCode < successCode ;                                                      //0091
            uDpsds.wkQuery_Name = 'Fetch_SelectOmit' ;                                   //0091
            IaSqlDiagnostic(uDpsds) ;                                                    //0091
         Else ;                                                                          //0091
            If wkFileDtlCntr < SQLER3 ;                                                  //0091
               wkFileDtlCntr = SQLER3 ;                                                  //0091
            Endif ;                                                                      //0091
         EndIf ;                                                                         //0091
      EndIf ;                                                                            //0091
      Exec Sql Close SelectOmit ;                                                        //0091
   Endsr ;                                                                               //0091
                                                                                         //0091
//------------------------------------------------------------------------------------- //0091
//Subroutine WriteFileDataMultRows - Write the data for multiple rows of information    //0091
//                                    in F spec from the file array                      //0091
//------------------------------------------------------------------------------------- //0091
   Begsr WriteFileDataMultRows ;                                                         //0091
      For wkForCounter = 1 to wkFileDtlCntr ;                                            //0091
         If wkForCounter > 1 ;                                                           //0091
            Clear dsFSpecLFNewFormat ;                                                   //0091
         Endif ;                                                                         //0091
         //Prepare pseudo code in new format using DS defined                            //0091
         dsFSpecLFNewFormat.dsDeLimit1   = cwDelimiter ;                                 //0091
         dsFSpecLFNewFormat.dsDeLimit2   = cwDelimiter ;                                 //0091
         dsFSpecLFNewFormat.dsDeLimit3   = cwDelimiter ;                                 //0091
         dsFSpecLFNewFormat.dsDeLimit4   = cwDelimiter ;                                 //0091
         dsFSpecLFNewFormat.dsDeLimit5   = cwDelimiter ;                                 //0091
         dsFSpecLFNewFormat.dsKeyField   = dsKeyField(wkForCounter) ;                    //0091
         dsFSpecLFNewFormat.dsBasedon    = dsFileFormat(wkForCounter) ;                  //0091
         If dsSelectOmit(wkForCounter).dsSOLetter <> *Blanks ;                           //0091
            If dsSelectOmit(wkForCounter).dsOperator = 'AL' ;                            //0091
               dsSelectOmit(wkForCounter).dsOperator = 'ALL' ;                           //0091
            Endif ;                                                                      //0091
            dsFSpecLFNewFormat.dsSelOmitCst = dsSelectOmit(wkForCounter) ;               //0091
         Endif ;                                                                         //0091
         wkPseudoFileCode = dsFSpecLFNewFormat ;                                         //0091
                                                                                         //0091
         //Write pseudocode line                                                         //0091
         OutParmWriteSrcDocDS.dsPseudocode = wkPseudoFileCode ;                          //0091
         IOParmPointer  = %Addr(OutParmWriteSrcDocDS) ;                                  //0091
         WritePseudoCode(IOParmPointer) ;                                                //0091
      Endfor ;                                                                           //0091
                                                                                         //0091
      //Write the header line before printing keywords                                   //0091
      Clear wkPseudoFileCode ;                                                           //0091
      Clear wkPseudoFileCodebkp ;                                                        //0091
      Exec sql                                                                           //0091
         Select  Src_Mapping                                                             //0091
         InTo  :wkPseudoFileCode                                                         //0091
         From IaPseudoMP                                                                 //0091
         Where Source_Spec = :writePseudoCodeDs.srcSpec                                  //0091
               And KeyField_1 = 'FILEKWLINE' ;                                           //0091
      wkPseudoFileCodebkp = wkPseudoFileCode ;                                           //0091
                                                                                         //0091
      If wkPseudoFileCode <> *Blanks ;                                                   //0091
         OutParmWriteSrcDocDS.dsPseudocode = wkPseudoFileCode ;                          //0091
         IOParmPointer  = %Addr(OutParmWriteSrcDocDS) ;                                  //0091
         WritePseudoCode(IOParmPointer) ;                                                //0091
      EndIf ;                                                                            //0091
                                                                                         //0091
      If SqlCode < successCode ;                                                         //0091
         uDpsds.wkQuery_Name = 'Get_Footer' ;                                            //0091
         IaSqlDiagnostic(uDpsds) ;                                                       //0091
      EndIf ;                                                                            //0091
                                                                                         //0091
      If inKeyWrdCntr = *Zeros ;                                                         //0091
         inKeyWrdCntr = 1 ;                                                              //0091
      Endif ;                                                                            //0091
                                                                                         //0091
      //Write keywords for file                                                          //0091
      Clear wkPseudoFileCode ;                                                           //0091
      dsFSpecKeywords(1).dsKeyWrdHdr = 'Keywords' ;                                      //0091
      dsFSpecKeywords(1).dsDelimit1  = cwDelimiter ;                                     //0091
                                                                                         //0091
      //Print all keywords                                                               //0091
      For wkForCounter = 1 to inKeyWrdCntr ;                                             //0091
         dsFSpecKeywords(wkForCounter).dsDelimit1  = cwDelimiter ;                       //0091
         wkPseudoFileCode = dsFSpecKeywords(wkForCounter) ;                              //0091
         If wkPseudoFileCode <> *Blanks ;                                                //0091
            OutParmWriteSrcDocDS.dsPseudocode = wkPseudoFileCode ;                       //0091
            IOParmPointer  = %Addr(OutParmWriteSrcDocDS) ;                               //0091
            WritePseudoCode(IOParmPointer) ;                                             //0091
         EndIf ;                                                                         //0091
      Endfor ;                                                                           //0091
                                                                                         //0091
      //Write the footer line before printing keywords                                   //0091
      If wkPseudoFileCodebkp <> *Blanks ;                                                //0091
         OutParmWriteSrcDocDS.dsPseudocode = wkPseudoFileCodebkp ;                       //0091
         IOParmPointer  = %Addr(OutParmWriteSrcDocDS) ;                                  //0091
         WritePseudoCode(IOParmPointer) ;                                                //0091
      EndIf ;                                                                            //0091
   Endsr ;                                                                               //0091
                                                                                         //0091
   //Copy book Declaration for error handling                                           //0091
/copy 'QCPYSRC/iaprcerlog.rpgleinc'
                                                                                         //0091
End-Proc IaGetLogicalFileDetails ;                                                       //0091
//------------------------------------------------------------------------------------- //0096
//ProcessSingleBIF: Procedure to process the build in functions and create Pseudocode   //0096
//                  Includes logic of already developed subroutine (ProcessBIF)         //0096
//------------------------------------------------------------------------------------- //0096
Dcl-Proc ProcessDspecBIF;                                                                //0096
                                                                                         //0096
   Dcl-Pi ProcessDspecBIF Like(wkSrcDtaBIF);                                             //0096
      inSrcData Pointer;                                                                 //0096
   End-Pi;                                                                               //0096
                                                                                         //0096
   Dcl-S  wkBIF                Char(100)            Inz;                                 //0096
   Dcl-S  wkArg1               Char(100)            Inz;                                 //0096
   Dcl-S  wkArg2               Char(100)            Inz;                                 //0096
   Dcl-S  wkArg3               Char(100)            Inz;                                 //0096
   Dcl-S  wkiAKeyFld2          Char(10)             Inz;                                 //0096
   Dcl-S  wkKeyFld2            Char(10);                                                 //0096
   Dcl-S  wkKeyFld3            Char(10);                                                 //0096
   Dcl-S  wkKeyFld4            Char(10);                                                 //0096
   Dcl-S  wkIndentType         Char(10);                                                 //0096
   Dcl-S  wkSubsChr            Char(10);                                                 //0096
   Dcl-S  wkActionType         Char(10);                                                 //0096
   Dcl-S  wkSearchFld1         Char(10);                                                 //0096
   Dcl-S  wkSearchFld2         Char(10);                                                 //0096
   Dcl-S  wkSearchFld3         Char(10);                                                 //0096
   Dcl-S  wkSearchFld4         Char(10);                                                 //0096
   Dcl-S  wkCommentDesc        Char(100)            Inz;                                 //0096

   Dcl-S  wkSrcDtaBIF          VarChar(cwSrcLength) Based(inSrcData);                    //0096
   Dcl-S  outSrcDtaBIF         VarChar(cwSrcLength) Inz;                                 //0096
   Dcl-S  wkSrcMap             VarChar(cwSrcLength) Inz;                                 //0096
   Dcl-S  wkRemSrc             VarChar(cwSrcLength) Inz;                                 //0096

   Dcl-S  wkPos1               Packed(5:0)          Inz;                                 //0096
   Dcl-S  wkPos2               Packed(5:0)          Inz;                                 //0096
   Dcl-S  wkSubPos             Packed(5:0)          Inz;                                 //0096
   Dcl-S  wkSavPos             Packed(5:0)          Inz;                                 //0096
   Dcl-S  wkSavEndPos          Packed(3:0)          Inz;                                 //0096

   Dcl-C cwDSPEC               'D';                                                      //0096
   Dcl-C cwFFCLINTYPE          'FFC';                                                    //0096
                                                                                         //0096
   //Copybook declaration
/copy 'QCPYSRC/iaprderlog.rpgleinc'
                                                                                         //0096
   //Main Logic                                                                         //0096
   If %Scan('CONST' :   wkSrcDtaBIF : 1) =  1;                                           //0096
      Monitor;                                                                           //0096
         wkSrcDtaBIF   =  %Scanrpl('CONST' : ' ' : wkSrcDtaBIF : 1);                     //0096
         wkPos1        =  %Scan('(' : wkSrcDtaBIF : 1);                                  //0096
         wkSrcDtaBIF   =  %Replace(' ' : wkSrcDtaBIF : Wkpos1 : 1);                      //0096
         wkPos1        =  %Scanr(')' : wkSrcDtaBIF : 1);                                 //0096
         wkSrcDtaBIF   =  %Replace(' ' : wkSrcDtaBIF : Wkpos1 : 1);                      //0096
      On-Error;                                                                          //0096
      Endmon;                                                                            //0096
   Endif;                                                                                //0096
                                                                                         //0096
   outSrcDtaBIF  =  %Trimr(wkSrcDtaBIF);                                                 //0096
   wkPos1  =   %Scan('%' : wkSrcDtaBIF : 1);                                             //0096
                                                                                         //0096
   If wkPos1 = *Zeros;                                                                   //0096
      Return outSrcDtaBIF;                                                               //0096
   EndIf;                                                                                //0096
                                                                                         //0096
   wkBIF  = *Blanks;                                                                     //0096
   wkArg1 = *Blanks;                                                                     //0096
   wkArg2 = *Blanks;                                                                     //0096
   wkArg3 = *Blanks;                                                                     //0096
                                                                                         //0096
   //Get the statement upto the Built In Function for pseudocode                        //0096
                                                                                         //0096
   wkPos2  =   %Scan('(' : wkSrcDtaBIF : wkPos1);                                        //0096
                                                                                         //0096
   If wkPos2 > *Zeros;                                                                   //0096
      wkSubPos = wkPos1+1 ;                                                              //0096
      wkBIF = %Trim(%Subst(wkSrcDtaBIF : wkSubPos : (wkPos2-wkPos1-1)));                 //0096
                                                                                         //0096
      Monitor;                                                                           //0096
         wkBIF = %xLate(cwLO:cwUP:wkBIF);                                                //0096
         wkDclType = %Trim(wkBIF) ;                                                      //0096
      On-Error;                                                                          //0096
      EndMon;                                                                            //0096
                                                                                         //0096
      //Get the mapping data from IaPseudoMP file for the Built in function             //0096
      wkSrcLtyp  = cwFFCLINTYPE;                                                         //0096
      wkSrcSpec  = cwDSpec;                                                              //0096
      wkMappingFoundInd = GetMappingData();                                              //0096
      wkSrcMap = wkSrcMapOut;                                                            //0096
                                                                                         //0096
      //Built In function found in mapping, check for the parameters in it              //0096
      //Back up the start posistion of BIF, to get the pseudocode before it             //0096
      If wkMappingFoundInd = *On;                                                        //0096
      wkSavPos = wkPos1;                                                                 //0096
      wkSavEndPos = *Zeros;                                                              //0096
                                                                                         //0096
      If %Scan('&Var1' : wkSrcMap  : 1) > *Zeros;                                        //0096
         //If Var1 exist in mapping get the BIF Argument value                          //0096
         wkPos1 = wkPos2+1;                                                              //0096
         wkPos2 = %Scan(':' : wkSrcDtaBIF : wkPos1);                                     //0096
                                                                                         //0096
         If wkPos2 > *Zeros;                                                             //0096
            wkArg1 = %Trim(%Subst(wkSrcDtaBIF : wkPos1                                   //0096
                                              : (wkPos2-wkPos1)));                       //0096
            //Upper statement was un commented and below one was generating dump        //0096
            //swap the logic to prevent dump.(Needs to be looked on urgent basis)       //0096
            wkSrcMap  = %ScanRpl('&Var1':%Trim(wkArg1):wkSrcMap);                        //0096
         Else;                                                                           //0096
            //If no more arguments then get the end position                            //0096
            wkPos2 = %Scan(')' : wkSrcDtaBIF : wkPos1);                                  //0096
                                                                                         //0096
            If wkPos2 > *Zeros;                                                          //0096
               wkArg1 = %Subst(wkSrcDtaBIF : wkPos1                                      //0096
                                              : (wkPos2-wkPos1));                        //0096
                  wkSrcMap  = %ScanRpl('&Var1':%Trim(wkArg1):wkSrcMap);                  //0096
                  wkSavEndPos = wkPos2;                                                  //0096
               Else;                                                                     //0096
                  //If no arguments but &Var1 exist in mapping then Clear it            //0096
                  wkSrcMap  = %ScanRpl('&Var1':' ' :wkSrcMap);                           //0096
               EndIf;                                                                    //0096
                                                                                         //0096
            EndIf;                                                                       //0096
                                                                                         //0096
         EndIf;                                                                          //0096
                                                                                         //0096
         If %Scan('&Var2' : wkSrcMap : 1) > *Zeros;                                      //0096
            //If Var2 exist in mapping get the BIF Argument value                       //0096
            wkPos1 = wkPos2+1;                                                           //0096
            wkPos2 = %Scan(':' : wkSrcDtaBIF : wkPos1);                                  //0096
                                                                                         //0096
            If wkPos2 > *Zeros;                                                          //0096
               wkArg2 = %Subst(wkSrcDtaBIF : wkPos1                                      //0096
                                         : (wkPos2-wkPos1));                             //0096
               wkSrcMap  = %ScanRpl('&Var2':%Trim(wkArg2):wkSrcMap);                     //0096
            Else;                                                                        //0096
               //If no more arguments then get the end position                         //0096
               wkPos2 = %Scan(')' : wkSrcDtaBIF : wkPos1);                               //0096
                                                                                         //0096
               If wkPos2 > *Zeros;                                                       //0096
                  wkArg2 = %Subst(wkSrcDtaBIF : wkPos1                                   //0096
                                              : (wkPos2-wkPos1));                        //0096
                  wkSrcMap  = %ScanRpl('&Var2':%Trim(wkArg2):wkSrcMap);                  //0096
                  wkSavEndPos = wkPos2;                                                  //0096
               Else;                                                                     //0096
                  //If no arguments but &Var2 exist in mapping then Clear it            //0096
                  wkSrcMap  = %ScanRpl('&Var2':' ' :wkSrcMap);                           //0096
               EndIf;                                                                    //0096
                                                                                         //0096
            EndIf;                                                                       //0096
                                                                                         //0096
         EndIf;                                                                          //0096
                                                                                         //0096
         If %Scan('&Var3' : wkSrcMap : 1) > *Zeros;                                      //0096
            //If Var2 exist in mapping get the BIF Argument value                       //0096
            wkPos1 = wkPos2+1;                                                           //0096
            wkPos2 = %Scan(':' : wkSrcDtaBIF : wkPos1);                                  //0096
                                                                                         //0096
            If wkPos2 > *Zeros;                                                          //0096
               wkArg3 = %Subst(wkSrcDtaBIF : wkPos1                                      //0096
                                           : (wkPos2-wkPos1));                           //0096
               wkSrcMap  = %ScanRpl('&Var3':%Trim(wkArg3):wkSrcMap);                     //0096
            Else;                                                                        //0096
               //If no more arguments then get the end position                         //0096
               wkPos2 = %Scan(')' : wkSrcDtaBIF : wkPos1);                               //0096
               If wkPos2 > *Zeros;                                                       //0096
                  wkArg3 = %Subst(wkSrcDtaBIF : wkPos1                                   //0096
                                              : (wkPos2-wkPos1));                        //0096
                  wkSrcMap  = %ScanRpl('&Var3':%Trim(wkArg3):wkSrcMap);                  //0096
                  wkSavEndPos = wkPos2;                                                  //0096
               Else;                                                                     //0096
                  //If no arguments then its by default                                 //0096
                  wkArg3 = '1';                                                          //0096
                  wkSrcMap  = %ScanRpl('&Var3':%Trim(wkArg3):wkSrcMap);                  //0096
               EndIf;                                                                    //0096
                                                                                         //0096
            EndIf;                                                                       //0096
                                                                                         //0096
         EndIf;                                                                          //0096
                                                                                         //0096
         wkPos1 = %Len(%Trim(wkSrcDtaBIF)) - wkSavEndPos  ;                              //0096
         wkRemSrc = *Blanks;                                                             //0096
                                                                                         //0096
         If wkPos1 > 1;                                                                  //0096
            //Get the remaining statement ie.,                                          //0096
            //source after the built in function as well.                               //0096
            wkRemSrc  =                                                                  //0096
            %Subst(wkSrcDtaBIF : (wkSavEndPos + 1) : wkPos1);                            //0096
         EndIf;                                                                          //0096
                                                                                         //0096
         //Pseudocode with the built in function mapping                                //0096
         outSrcDtaBIF  = %Subst(wkSrcDtaBIF : 1 : (wkSavPos-1)) +                        //0096
                         ' ' + %Trim(wkSrcMap) + ' ' + %Trim(wkRemSrc);                  //0096
                                                                                         //0096
      EndIf;                                                                             //0096
                                                                                         //0096
   EndIf;                                                                                //0096
                                                                                         //0096
   Return outSrcDtaBIF;                                                                  //0096
                                                                                         //0096
   //Copy book Declaration for error handling                                           //0091
/copy 'QCPYSRC/iaprcerlog.rpgleinc'
End-Proc ProcessDspecBIF;                                                                //0096
                                                                                         //0100
//------------------------------------------------------------------------------------- //0100
//ProcessExpression: Process arithmetic expression into simplified text as pseudo code  //0100
//                    The array for sub expressions will be created, mapping will be     //0100
//                    fetched and pseudo code will be created and loaded in output array //0100
//------------------------------------------------------------------------------------- //0100
Dcl-Proc ProcessExpression ;                                                             //0100

   Dcl-Pi ProcessExpression ;                                                            //0100
      wkSrcDta            VarChar(cwSrcLength)  Const ;                                  //0100
      CallingMode         Char(1)               Const ;                                  //0100
      wkRPGIndentParmDS   likeDS(RPGIndentParmDSTmp) ;                                   //0100
   End-Pi;                                                                               //0100

   //Copybook declaration                                                               //0100
/copy 'QCPYSRC/iaprderlog.rpgleinc'

   //DS array to split the expression into individual segments                           //0100
   Dcl-DS ExpressionArrayParent Qualified Dim(100) Inz ;                                 //0100
      POrderSeq      Packed(2:0) ;                                                       //0100
      OrderSeq       Packed(3:0) ;                                                       //0100
      Factor1        Char(30) ;                                                          //0100
      Factor2        Char(30) ;                                                          //0100
      Operator       Char(1) ;                                                           //0100
      Opcode         Char(8) ;                                                           //0100
      Precedence     Packed(1:0) ;                                                       //0100
      ResultExp      Char(30) ;                                                          //0100
   End-DS ;                                                                              //0100
                                                                                         //0100
   Dcl-DS ExpressionMasterArray Qualified Dim(50) Inz ;                                  //0100
      ExpOrderSeq    Packed(2:0) ;                                                       //0100
      Expression     Char(200) ;                                                         //0100
      ResultField    Char(30) ;                                                          //0100
   End-DS ;                                                                              //0100

   Dcl-S  ArrayCounter           Packed(3:0)           Inz ;                             //0100
   Dcl-S  LoopCounter            Packed(3:0)           Inz ;                             //0100
   Dcl-S  ExpIndex               Zoned(4:0)            Inz ;                             //0100
   Dcl-S  LoopIndex              Zoned(4:0)            Inz ;                             //0100
   Dcl-S  wkstrPos               Zoned(4:0)            Inz(1) ;                          //0100
   Dcl-S  Keyword                Char(30)              Inz ;                             //0100
                                                                                         //0100
   Dcl-S  Letter                 Char(1)               Inz ;                             //0100
   Dcl-S  wkUpdExpr              like(wkSrcDta)        Inz ;                             //0100
   Dcl-S  wkSrcDtaNospace        like(wkSrcDta)        Inz ;                             //0100
   Dcl-S  wkMappingFoundInd      Ind                   Inz ;                             //0100
   Dcl-S  IOParmPointer          Pointer               Inz(*Null) ;                      //0100
                                                                                         //0100
   Dcl-S  wkIOIndentParmPointer  Pointer               Inz(*Null) ;                      //0100
   Dcl-S  Continue               Char(1)               Inz('Y') ;                        //0100
   Dcl-S  ParOrdSeq              Packed(2:0)           Inz ;                             //0100
   Dcl-S  MstArrProcess          Char(1)               Inz('N') ;                        //0100
   Dcl-S  PrevOpcode             Char(1)               Inz ;                             //0100
   Dcl-S  SingleOpcode           Char(1)               Inz('N') ;                        //0100

   Select ;                                                                              //0100
      When CallingMode = 'P' ;                                                           //0100
         //Clear the arrays for every iteration                                          //0100
         Clear ExpressionArrayParent ;                                                   //0100
         Clear PseudoCodeArray ;                                                         //0100
         Clear ExpressionMasterArray ;                                                   //0100

         Keyword = *Blanks ;                                                             //0100
         OrderSeqn = *Zeros ;                                                            //0100
         LoopCounter = 1 ;                                                               //0100
         MstOrdSeq = *Zeros ;                                                            //0100
         ParOrdSeq = *Zeros ;                                                            //0100
         PseudoCodeSeq = *Zeros ;                                                        //0100
         wkUpdExpr = wkSrcDta ;                                                          //0100
                                                                                         //0100
         If %Scan('(' : wkUpdExpr) > *Zeros ;                                            //0100
            Exsr ScanBracketLoadMasterArray ;                                            //0100
         Endif ;                                                                         //0100
                                                                                         //0100
         ParOrdSeq = 1 ;                                                                 //0100
         MstArrProcess = 'N' ;                                                           //0100
         Exsr SplitMstExptoSubExp ;                                                      //0100
                                                                                         //0100
         If MstOrdSeq > *Zeros ;                                                         //0100
            ParOrdSeq = 1 ;                                                              //0100
            For ParOrdSeq = 1 to MstOrdSeq ;                                             //0100
               OrderSeqn = *Zeros ;                                                      //0100
               wkUpdExpr =                                                               //0100
                  %trim(ExpressionMasterArray(ParOrdSeq).Expression) + ';' ;             //0100
               MstArrProcess = 'Y' ;                                                     //0100
               Exsr SplitMstExptoSubExp ;                                                //0100
            EndFor ;                                                                     //0100
         Endif ;                                                                         //0100

      //Process source data to extract sub expressions and load array                    //0100
      //Replace source string with result expression from the processed                  //0100
      //sub expression to create new source data                                         //0100
      When CallingMode = 'W' ;                                                           //0100
         For ExpIndex = 1 to PseudoCodeSeq ;                                             //0100
            //Add indentation before writing the sub expression details                  //0100
            If wkRPGIndentParmDS.dsCurrentIndents = *Zeros ;                             //0100
               wkRPGIndentParmDS.dsCurrentIndents = cw3 ;                                //0100
            Endif ;                                                                      //0100
                                                                                         //0100
            wkRPGIndentParmDS.dsIndentType = *Blanks ;                                   //0100
            wkRPGIndentParmDS.dsPseudocode =                                             //0100
                              %trim(PseudoCodeArray(ExpIndex).PseudoCode);               //0100
            wkIOIndentParmPointer = %Addr(wkRPGIndentParmDS);                            //0100
            IndentRPGPseudoCode(wkIOIndentParmPointer);                                  //0100
            //Write the Pseudocode                                                      //0100
            OutParmWriteSrcDocDS.dsPseudocode = wkRPGIndentParmDS.dsPseudocode ;         //0100
            IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                                //0100
            WritePseudoCode(IOParmPointer);                                              //0100
         EndFor ;                                                                        //0100

         //Write blank line at the end of the expression                                //0100
         OutParmWriteSrcDocDS.dsPseudocode = *Blanks;                                    //0100
         IOParmPointer  = %Addr(OutParmWriteSrcDocDS);                                   //0100
         WritePseudoCode(IOParmPointer);                                                 //0100
   EndSl ;                                                                               //0100

   //---------------------------------------------------------------------------------- //0100
   // SplitSourceCode - Subroutine to split source code into expressions                //0100
   //                    The source data string is scanned letter by letter to           //0100
   //                    segregate factors involved in sub expression                    //0100
   //                    The array will be loaded through this sub routine               //0100
   //---------------------------------------------------------------------------------- //0100
   BegSr SplitSourceCode ;                                                               //0100
      //Variables and array initialization                                               //0100
      ArrayCounter = 1 ;                                                                 //0100
      Clear ExpressionArrayParent ;                                                      //0100
      wkSrcDtaNospace = *Blanks ;                                                        //0100
      Letter = *Blanks ;                                                                 //0100
      Keyword = *Blanks ;                                                                //0100
      SingleOpcode = 'N' ;                                                               //0100
      //Get start position for Source Data                                              //0100
      If %Scan('EVAL' : %Xlate(cwLo:cwUp:wkDclType)) > *Zeros ;                          //0100
         wkStrPos = %Check(' ' : wkUpdExpr : 5) ;                                        //0100
      Else ;                                                                             //0100
         wkStrPos = %Check(' ' : wkUpdExpr : 1) ;                                        //0100
      Endif ;                                                                            //0100
      If wkStrPos > *Zeros ;                                                             //0100
         //Break string into sub expressions                                             //0100
         For ExpIndex = WkStrPos to %len(%trim(wkUpdExpr)) ;                             //0100
            ExpressionArrayParent(ArrayCounter).POrderSeq = ParOrdSeq ;                  //0100
            ExpressionArrayParent(ArrayCounter).OrderSeq = ArrayCounter ;                //0100
            Letter = %subst(wkUpdExpr : ExpIndex : 1) ;                                  //0100
                                                                                         //0100
            If Letter = '=' ;                                                            //0100
               Keyword = *Blanks ;                                                       //0100
            Elseif Letter = '+' OR Letter = '-' OR Letter = '*' OR                       //0100
                   Letter = '/' OR Letter = ';' ;                                        //0100
               //Fill in Factor 1 when both factors are empty                            //0100
               If ExpressionArrayParent(ArrayCounter).Factor1 = *Blanks  AND             //0100
                  ExpressionArrayParent(ArrayCounter).Factor2 = *Blanks ;                //0100
                  ExpressionArrayParent(ArrayCounter).Factor1 = Keyword ;                //0100
                  Keyword = *Blanks ;                                                    //0100
               //Fill in Factor 2 when it is blank                                       //0100
               Elseif ExpressionArrayParent(ArrayCounter).Factor2 = *Blanks ;            //0100
                  ExpressionArrayParent(ArrayCounter).Factor2 = Keyword ;                //0100
                  If Letter = ';' ;                                                      //0100
                  Else ;                                                                 //0100
                     //Add data to next row of array as variable will be part of         //0100
                     //2 sub expressions                                                 //0100
                     ArrayCounter += 1 ;                                                 //0100
                     ExpressionArrayParent(ArrayCounter).Factor1 = Keyword ;             //0100
                     Keyword = *Blanks ;                                                 //0100
                  Endif ;                                                                //0100
               Endif ;                                                                   //0100
                                                                                         //0100
               //If same operator only, generate operands in one line                    //0100
               If Letter <> ';' ;                                                        //0100
                  If PrevOpcode = Letter ;                                               //0100
                     SingleOpcode = 'Y' ;                                                //0100
                  Else ;                                                                 //0100
                     SingleOpcode = 'N' ;                                                //0100
                  Endif ;                                                                //0100
               Endif ;                                                                   //0100

               //Fill in operator, opcode and precedence as per operator                 //0100
               // * & / have precence 1 and + & - have precedence 2                      //0100
               Select ;                                                                  //0100
                  When Letter = '+' ;                                                    //0100
                     ExpressionArrayParent(ArrayCounter).Operator = '+' ;                //0100
                     ExpressionArrayParent(ArrayCounter).Opcode = 'ADD+' ;               //0100
                     ExpressionArrayParent(ArrayCounter).Precedence = 2 ;                //0100
                     PrevOpcode = '+' ;                                                  //0100
                  When Letter = '-' ;                                                    //0100
                     ExpressionArrayParent(ArrayCounter).Operator = '-' ;                //0100
                     ExpressionArrayParent(ArrayCounter).Opcode = 'SUB-' ;               //0100
                     ExpressionArrayParent(ArrayCounter).Precedence = 2 ;                //0100
                  When Letter = '*' ;                                                    //0100
                     ExpressionArrayParent(ArrayCounter).Operator = '*' ;                //0100
                     ExpressionArrayParent(ArrayCounter).Opcode = 'MULT*' ;              //0100
                     ExpressionArrayParent(ArrayCounter).Precedence = 1 ;                //0100
                  When Letter = '/' ;                                                    //0100
                     ExpressionArrayParent(ArrayCounter).Operator = '/' ;                //0100
                     ExpressionArrayParent(ArrayCounter).Opcode = 'DIV/' ;               //0100
                     ExpressionArrayParent(ArrayCounter).Precedence = 1 ;                //0100
               EndSl ;                                                                   //0100
            Elseif Letter <> *Blanks ;                                                   //0100
               Keyword = %trim(Keyword) + Letter ;                                       //0100
            Endif ;                                                                      //0100
            //Strip all the spaces from source string to easily replace                  //0100
            //expression results in place of sub expressions                             //0100
            If Letter <> *Blanks ;                                                       //0100
               wkSrcDtaNospace = %trim(wkSrcDtaNospace) + Letter ;                       //0100
            Endif ;                                                                      //0100
         EndFor ;                                                                        //0100
         wkUpdExpr = wkSrcDtaNospace ;                                                   //0100
      Endif ; //End of wkStrPos > *Zeros                                                 //0100
   EndSr ;                                                                               //0100

   //---------------------------------------------------------------------------------- //0100
   // MapandCreatePseudoCode - Subroutine to set order of execution for expressions,    //0100
   //                          get the mapping and generate pseudo code                 //0100
   //                           Output array will be loaded to be used to write          //0100
   //                           pseudo code to output file later                         //0100
   //---------------------------------------------------------------------------------- //0100
   BegSr MapandCreatePseudoCode ;                                                        //0100
      If MstArrProcess = 'Y' ;                                                           //0100
         If LoopCounter = 1 ;                                                            //0100
            //If final loop then use Result Field as output variable                     //0100
            ExpressionArrayParent(ExpIndex).ResultExp =                                  //0100
                        ExpressionMasterArray(ParOrdSeq).ResultField ;                   //0100
         Else ;                                                                          //0100
            //Set output variable as SubExpr* as per sub expression number               //0100
            ExpressionArrayParent(ExpIndex).ResultExp = 'SubExpr' +                      //0100
                                            %Char(OrderSeqn) ;                           //0100

         Endif ;                                                                         //0100
      Else ;                                                                             //0100
         //If final loop then use "Result Expression" as output variable                 //0100
         If LoopCounter = 1 ;                                                            //0100
            ExpressionArrayParent(ExpIndex).ResultExp = 'Result Expression' ;            //0100
         Else ;                                                                          //0100
            //Set output variable as Expression* as per sub expression number            //0100
            ExpressionArrayParent(ExpIndex).ResultExp = 'Expression' +                   //0100
                                            %Char(OrderSeqn) ;                           //0100
         Endif ;                                                                         //0100
      Endif ;                                                                            //0100
      //If final loop then use "Result Expression" as output variable                    //0100
      If SingleOpcode = 'Y' AND ArrayCounter > 1 ;                                       //0100
         LoopIndex = 1 ;                                                                 //0100
         wkSrcMapOut = %trim(ExpressionArrayParent(ExpIndex).ResultExp)                  //0100
                        + ' = Add ' +                                                    //0100
                        %trim(ExpressionArrayParent(LoopIndex).Factor1) ;                //0100
         For LoopIndex = 1 to ArrayCounter ;                                             //0100
            wkSrcMapOut = %trim(wkSrcMapOut) + ', ' +                                    //0100
                           %trim(ExpressionArrayParent(LoopIndex).Factor2) ;             //0100
         Endfor ;                                                                        //0100
      Else ;                                                                             //0100
         //Get the mapping data for the opcode                                           //0100
         wkDclType = ExpressionArrayParent(ExpIndex).Opcode ;                            //0100
         wkMappingFoundInd = GetMappingData() ;                                          //0100
         //Replace output variable for Variables in mapped code                          //0100
         LoopIndex = 1 ;                                                                 //0100
         Keyword = *Blanks ;                                                             //0100
                                                                                         //0100
         For LoopIndex = 1 to 3 ;                                                        //0100
            If %Scan('&Var'+%trim(%char(LoopIndex)) : wkSrcMapOut) > *Zeros ;            //0100
               Select ;                                                                  //0100
                  When LoopIndex = 1 ;                                                   //0100
                     Keyword =                                                           //0100
                         %Trim(ExpressionArrayParent(ExpIndex).Factor1) ;                //0100
                  When LoopIndex = 2 ;                                                   //0100
                     Keyword =                                                           //0100
                         %Trim(ExpressionArrayParent(ExpIndex).Factor2) ;                //0100
                  When LoopIndex = 3 ;                                                   //0100
                     Keyword =                                                           //0100
                         %Trim(ExpressionArrayParent(ExpIndex).ResultExp) ;              //0100
               EndSl ;                                                                   //0100
               wkSrcMapOut = %ScanRpl('&Var'+%trim(%char(LoopIndex)) :                   //0100
                                       %Trim(Keyword) : wkSrcMapOut) ;                   //0100
            Endif ;                                                                      //0100
         Endfor ;                                                                        //0100
      Endif ;                                                                            //0100
                                                                                         //0100
      //Add final pseudo code data to separate array                                     //0100
      PseudoCodeSeq += 1 ;                                                               //0100
      PseudoCodeArray(PseudoCodeSeq).OrderSeq = PseudoCodeSeq ;                          //0100
      PseudoCodeArray(PseudoCodeSeq).PseudoCode = wkSrcMapOut ;                          //0100
   EndSr ;                                                                               //0100
                                                                                         //0100
   //---------------------------------------------------------------------------------- //0100
   // ScanBracketLoadMasterArray - Subroutine to scan expression for brackets and load  //0100
   //                              master array for expressions and then load sub       //0100
   //                               expressions into parent array                        //0100
   //---------------------------------------------------------------------------------- //0100
   BegSr ScanBracketLoadMasterArray ;                                                    //0100
      ExpIndex = *Zeros ;                                                                //0100
      Letter = *Blanks ;                                                                 //0100
      Dow %Scan('(' : wkUpdExpr) > *Zeros ;                                              //0100
         MstOrdSeq += 1 ;                                                                //0100
         ExpressionMasterArray(MstOrdSeq).ExpOrderSeq = MstOrdSeq ;                      //0100
         ExpressionMasterArray(MstOrdSeq).ResultField =                                  //0100
                           'BracketExpr' + %trim(%char(MstOrdSeq)) ;                     //0100
         Continue = 'Y' ;                                                                //0100
         wkstrPos = %Scan('(' : wkUpdExpr) ;                                             //0100
         ExpIndex = %Scan('(' : wkUpdExpr) + 1 ;                                         //0100
                                                                                         //0100
         Dow Continue = 'Y' ;                                                            //0100
            Letter = %subst(wkUpdExpr : ExpIndex : 1) ;                                  //0100
            Select ;                                                                     //0100
            When Letter = '(' ;                                                          //0100
               ExpressionMasterArray(MstOrdSeq).Expression = *Blanks ;                   //0100
               wkstrPos = ExpIndex ;                                                     //0100
            When Letter = ')' ;                                                          //0100
               //Replace source string with result expression from the processed         //0100
               //sub expression to create new source data                                //0100
               wkUpdExpr = %ScanRpl                                                      //0100
                        (%subst(wkUpdExpr : wkstrPos : ExpIndex-wkStrPos+1) :            //0100
                         %trim(ExpressionMasterArray(MstOrdSeq).ResultField) :           //0100
                         wkUpdExpr) ;                                                    //0100
               Continue = 'N' ;                                                          //0100
               Leave ;                                                                   //0100
            When Letter <> *Blanks ;                                                     //0100
               ExpressionMasterArray(MstOrdSeq).Expression =                             //0100
                     %trim(ExpressionMasterArray(MstOrdSeq).Expression)                  //0100
                      + Letter ;                                                         //0100
            EndSl ;                                                                      //0100
            ExpIndex += 1 ;                                                              //0100
         Enddo ;                                                                         //0100
      Enddo ;                                                                            //0100
   EndSr ;                                                                               //0100
                                                                                         //0100
   //---------------------------------------------------------------------------------- //0100
   // SplitMstExptoSubExp - Subroutine to scan through text and split it to sub         //0100
   //                       expressions to load into parent array                       //0100
   //---------------------------------------------------------------------------------- //0100
   BegSr SplitMstExptoSubExp ;                                                           //0100
      //Process source data to extract sub expressions and load array                    //0100
      Exsr SplitSourceCode ;                                                             //0100
                                                                                         //0100
      //Sort array in order of precendence and entry seq                                 //0100
      SortA                                                                              //0100
         %SubArr(ExpressionArrayParent : 1 : ArrayCounter)                               //0100
         %fields(Precedence : POrderSeq : OrderSeq) ;                                    //0100
                                                                                         //0100
      //Read through array and process precedence records                                //0100
      ExpIndex = 1 ;                                                                     //0100
      If SingleOpcode = 'Y' ;                                                            //0100
         LoopCounter = 1 ;                                                               //0100
         //Get the mapping and scan replace variables to form pseudo code                //0100
         Exsr MapandCreatePseudoCode ;                                                   //0100
         Leavesr ;                                                                       //0100
      Endif ;                                                                            //0100
      //Loop through the array records in order of precedence for all sub                //0100
      //expressions and then reprocess updated source data                               //0100
      LoopCounter = ArrayCounter ;                                                       //0100
      Dow ExpIndex <= LoopCounter ;                                                      //0100
         OrderSeqn += 1 ;                                                                //0100
         //Get the mapping and scan replace variables to form pseudo code                //0100
         Exsr MapandCreatePseudoCode ;                                                   //0100
                                                                                         //0100
         //Replace source string with result expression from the processed               //0100
         //sub expression to create new source data                                      //0100
         wkUpdExpr = %ScanRpl(%trim(ExpressionArrayParent(ExpIndex).Factor1) +           //0100
                              %trim(ExpressionArrayParent(ExpIndex).Operator) +          //0100
                              %trim(ExpressionArrayParent(ExpIndex).Factor2) :           //0100
                              %trim(ExpressionArrayParent(ExpIndex).ResultExp) :         //0100
                              wkUpdExpr) ;                                               //0100
                                                                                         //0100
         If %Scan('+' : wkUpdExpr : 1) > *Zeros   OR                                     //0100
            %Scan('-' : wkUpdExpr : 1) > *Zeros   OR                                     //0100
            %Scan('*' : wkUpdExpr : 1) > *Zeros   OR                                     //0100
            %Scan('/' : wkUpdExpr : 1) > *Zeros ;                                        //0100
            //Process updated source code to create new sub expressions and              //0100
            //load the array again to reprocess next level of precedence                 //0100
            Exsr SplitSourceCode ;                                                       //0100
                                                                                         //0100
            //Sort array in order of precendence and entry seq                           //0100
            SortA                                                                        //0100
               %SubArr(ExpressionArrayParent : 1 : ArrayCounter)                         //0100
               %fields(Precedence : POrderSeq : OrderSeq) ;                              //0100
         Endif ;                                                                         //0100
                                                                                         //0100
         LoopCounter -= 1 ;                                                              //0100
         ExpIndex = 1 ;                                                                  //0100
      Enddo ;                                                                            //0100
   EndSr ;                                                                               //0100

   //Copy book Declaration for error handling                                           //0100
/copy 'QCPYSRC/iaprcerlog.rpgleinc'
End-Proc ProcessExpression ;                                                             //0100
