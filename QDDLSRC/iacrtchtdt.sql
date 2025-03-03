      --%METADATA                                                      *
      -- %TEXT AI Stored Procedure to create chart data                *
      --%EMETADATA                                                     *
-- --------------------------------------------------------------------------//
-- Created By.......: Programmers.io @ 2022                                  //
-- Create Date......: 2022/06/24                                             //
-- Developer........: BHOOMISH                                               //
-- Description......: Stored Procedure to Create Chart Data                  //
--                    Rrturn Y - Success                                     //
--                           N - Fail                                        //
-------------------------------------------------------------------------------
--MODIFICATION LOG:
-------------------------------------------------------------------------------
--Date    | Mod_ID | Developer  | Case and Description
----------|--------|------------|----------------------------------------------
--21/04/23| --01   | Ankit B.   | Excel is not showing objects which are called above
--30/01/24| 0002   | Manav T.   | Fix issue in AICRTCHTDT to restrict duplicate record entry
--        |        |            | and use AIEXPRSQTX only for error logging. Task#:557
--28/06/24| 0003   | Pranav J   | Renamed object from AI to IA.
--03/07/24| 0004   | Sribalaji  | Remove the hardcoded #IADTA lib from all sources
--        |        |            | Task# 754
--25/07/24| 0005   | Sasikumar R| To add input parameters for user id  all sources
--        |        |            | and environment library.
-------------------------------------------------------------------------------
-- Compilation Instruction
-- -----------------------------------------------------------------------------
-- RUNSQLSTM SRCFILE(#IASRC/QDDLSRC) SRCMBR(IACRTCHTDT)                                  --0003
-- COMMIT(*NONE) DFTRDBCOL(#IAOBJ) DBGVIEW(*SOURCE)
-- -----------------------------------------------------------------------------
Create Or Replace Procedure Create_Chart_Data(
   In  Request_Id     Varchar(10),
   In  Repo_Name      Varchar(10),
   In  Max_Level      Integer,
   In  Object_Name    Varchar(10),
   In  Object_Type    Varchar(10),
   In  Object_Library Varchar(10),
   In  Direction      Char(1),
   In  UserId         Char(10),                                                          --0005
   In  EnvLib         Char(10),                                                          --0005
   Out Status         Char(1))

   Language Sql
   Begin

     Declare MyQuery Varchar(1000);
     Declare MyQuery2 Varchar(1000);                                             --01
     Declare Level Integer Default 1;
     Declare W_Id  Integer;
     Declare w_Node_count Integer;
     Declare W_Obj_Name Varchar(10);
     Declare W_Obj_Type Varchar(10);
     Declare W_Obj_Lib  Varchar(10);
     Declare Message_Start Varchar(1000) Default 'REQUEST FOR DATA PREPARATION
     START';

     Declare Message_End Varchar(1000) Default 'REQUEST FOR DATA PREPARATION
     END';

     Declare Message_Tbl Varchar(1000) Default 'TABLE CREATED';
     Declare Message_Tbl_Rm Varchar(1000) Default 'TABLE DATA REMOVED';
     Declare Message_LVL Varchar(1000) Default 'DATA GENERATED FOR LEVEL:';
     Declare Flag Integer Default 0;
     Declare W_SqlState Char(5) Default '00000';
     Declare Blank Char(5) Default ' ';
     Declare Message Varchar(1000);
     Declare SqlStmt Varchar(300);                                                       --0005

  --Declare SqlStmt Varchar(300) Default 'INSERT INTO #IADTA/AIEXPRSQTX                 --0003
  -- Declare SqlStmt Varchar(300) Default 'INSERT INTO #IADTA/IAEXPRSQTX           --0004--0003
  -- Declare SqlStmt Varchar(300) Default 'INSERT INTO IAEXPRSQTX                  --0005--0004

  --    (AIHSCRID, AIHSCTXERR,AIHSCTXMSG,AICRTUSR) VALUES(? , ? , ? ,                    --0005
  --     CURRENT_USER)';                                                                 --0005

     Declare Parent_Data Cursor For S1;
     Declare Node_Count Cursor For S2;
     Declare Continue Handler For SqlState '02000'
        Set Flag =1;

      Declare Exit Handler For SqlException
         Begin
            Get Current Diagnostics Condition 1 MyQuery  = Message_Text,
               W_SqlState = Returned_SqlState;
            Set Status = 'N';
            IF EnvLib  = '#IAOBJ' then                                                   --0005
            Set SqlStmt = 'INSERT INTO #IADTA/IAEXPRSQTX                                 --0005
              (AIHSCRID, AIHSCTXERR,AIHSCTXMSG,AICRTUSR) VALUES(? , ? , ? ,              --0005
               CURRENT_USER)';                                                           --0005
            else                                                                         --0005
            Set SqlStmt = 'INSERT INTO IADTADEV/IAEXPRSQTX                               --0005
              (AIHSCRID, AIHSCTXERR,AIHSCTXMSG,AICRTUSR) VALUES(? , ? , ? ,              --0005
               CURRENT_USER)';                                                           --0005
            end if;                                                                      --0005
            Prepare Stmt From SqlStmt;
            Execute Stmt Using Request_Id, W_SqlState, MyQuery;
         End;

      Set Status = 'N';
 --0002 Prepare Stmt From SqlStmt;
 --0002 Execute Stmt Using Request_Id, Blank, Message_Start;

      Set MyQuery = 'CREATE OR REPLACE TABLE '||REPO_NAME||'.C'||REQUEST_ID
       ||' (ID INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT'
       ||' BY 1),'
       ||'OBJECT_NAME CHAR(10),'
       ||' OBJECT_TYPE CHAR(10),'
       ||'OBJECT_LIBRARY CHAR(10),'
       ||'PARENT_NODE INTEGER,'
       ||'LEVEL INTEGER,'
       ||'HASCHILD INTEGER NOT NULL DEFAULT 0,'                                  --01
       ||'TRACKED_ON_LEVEL INTEGER)';                                            --01
 --01  ||'HASCHILD INTEGER NOT NULL DEFAULT 0)';                                 --01

      --CREATE TABLE
      EXECUTE IMMEDIATE(MYQUERY);
 --0002 EXECUTE STMT USING REQUEST_ID,BLANK,MESSAGE_TBL;

      SET MYQUERY2 = 'CREATE OR REPLACE TABLE QTEMP.T'||REQUEST_ID               --01
          ||'( OBJECT_LIBRARY CHAR(10),'                                         --01
          ||' OBJECT_NAME CHAR(10),'                                             --01
          ||' OBJECT_TYPE CHAR(10),'                                             --01
          ||' TRACKED_ON_LEVEL INTEGER)';                                        --01
      EXECUTE IMMEDIATE(MYQUERY2);                                               --01

      SET MYQUERY ='DELETE FROM '||REPO_NAME||'.C'||REQUEST_ID;
      EXECUTE IMMEDIATE(MYQUERY);
 --0002 EXECUTE STMT USING REQUEST_ID,BLANK,MESSAGE_TBL_RM;

      SET MYQUERY2 ='DELETE FROM QTEMP.T'||REQUEST_ID;                           --01
      EXECUTE IMMEDIATE(MYQUERY2);                                               --01

     -- CREATE TABLE END


     IF DIRECTION = 'D' THEN
       SET MYQUERY = 'INSERT INTO '
                           ||REPO_NAME
                                      ||'.C'
                                            ||REQUEST_ID

              ||' (OBJECT_NAME,'
                  ||'OBJECT_TYPE,'
                  ||'OBJECT_LIBRARY,'
                  ||'PARENT_NODE,'
                  ||'LEVEL) '

              ||'(SELECT'
                ||' REFERENCED_OBJ,'
                ||'REFERENCED_OBJTYP,'
                ||'REFERENCED_OBJLIB,'
                ||'0,'
                ||'1'
              ||' FROM '
                        ||REPO_NAME
                                    ||'.IAALLREFPF '
              ||'WHERE '
                ||'OBJECT_TYPE IN '
                        ||'(''*PGM'','
                        ||'''*MODULE'','
                        ||'''*SRVPGM'','
                        ||'''*CMD'') '
                ||'AND REFERENCED_OBJTYP IN '
                       ||'(''*PGM'','
                       ||'''*MODULE'','
                       ||'''*SRVPGM'','
                       ||'''*CMD'') '
                || 'AND LIBRARY_NAME='''||OBJECT_LIBRARY
                ||''' AND OBJECT_NAME = '''|| OBJECT_NAME
                ||''' AND OBJECT_TYPE =''' ||OBJECT_TYPE||''')';
   ELSE
       SET MYQUERY = 'INSERT INTO '
                           ||REPO_NAME
                                      ||'.C'
                                            ||REQUEST_ID

              ||' (OBJECT_NAME,'
                  ||'OBJECT_TYPE,'
                  ||'OBJECT_LIBRARY,'
                  ||'PARENT_NODE,'
                  ||'LEVEL) '

              ||'(SELECT'
                ||' OBJECT_NAME,'
                ||'OBJECT_TYPE,'
                ||'LIBRARY_NAME,'
                ||'0,'
                ||'1'
              ||' FROM '
                        ||REPO_NAME
                                    ||'.IAALLREFPF '
              ||'WHERE '
                ||'OBJECT_TYPE IN '
                        ||'(''*PGM'','
                        ||'''*MODULE'','
                        ||'''*SRVPGM'','
                        ||'''*CMD'') '
                ||'AND REFERENCED_OBJTYP IN '
                       ||'(''*PGM'','
                       ||'''*MODULE'','
                       ||'''*SRVPGM'','
                       ||'''*CMD'') '
                || 'AND REFERENCED_OBJLIB =''' ||OBJECT_LIBRARY
                ||''' AND REFERENCED_OBJ ='''  ||OBJECT_NAME
                ||''' AND REFERENCED_OBJTYP='''||OBJECT_TYPE||''')';
   END IF;

   EXECUTE IMMEDIATE(MYQUERY);

   SET MESSAGE  = MESSAGE_LVL||1;
 --0002 EXECUTE STMT USING REQUEST_ID, BLANK, MESSAGE;

   SET MYQUERY2 = 'INSERT INTO QTEMP.T'||REQUEST_ID || ' VALUES('''              --01
                  ||OBJECT_LIBRARY||''','''||OBJECT_NAME||''','''                --01
 --0002           ||OBJECT_TYPE||''',0)';                                        --01
                  ||OBJECT_TYPE||''',0) EXCEPT SELECT OBJECT_LIBRARY'            --0002
                  ||',OBJECT_NAME,OBJECT_TYPE,TRACKED_ON_LEVEL FROM '            --0002
                  ||'QTEMP.T'||REQUEST_ID || '';                                 --0002
   EXECUTE IMMEDIATE(MYQUERY2);                                                  --01

   FETCH_LOOP:

   LOOP

     IF LEVEL >= MAX_LEVEL THEN
       LEAVE FETCH_LOOP;
     END IF;

        SET MYQUERY = ' SELECT ID,'
                        ||'OBJECT_NAME,'
                        ||'OBJECT_TYPE,'
                        ||'OBJECT_LIBRARY'
                   ||' FROM '
                            ||REPO_NAME
                                       ||'.C'
                                             ||REQUEST_ID
                   ||' A WHERE'                                                  --01
                   ||' LEVEL='||LEVEL                                            --01
                   ||' AND (SELECT COUNT(*) FROM QTEMP.T'||REQUEST_ID            --01
                   ||' B WHERE '                                                 --01
                   ||'   A.OBJECT_LIBRARY = B.OBJECT_LIBRARY  '                  --01
                   ||'   AND A.OBJECT_NAME = B.OBJECT_NAME    '                  --01
                   ||'    AND A.OBJECT_TYPE = B.OBJECT_TYPE) = 0';               --01

     --01          ||' WHERE'
     --01              ||' LEVEL='||LEVEL;
     SET FLAG =0;

     PREPARE S1 FROM MYQUERY;

     OPEN PARENT_DATA;

     SET LEVEL = LEVEL + 1;

     INSERT_LOOP:
     LOOP

     SET FLAG =0;

       FETCH PARENT_DATA INTO
                     W_ID,
                     W_OBJ_NAME,
                     W_OBJ_TYPE,
                     W_OBJ_LIB;

       IF FLAG = 1 THEN
          LEAVE INSERT_LOOP;
       END IF;

     IF DIRECTION = 'D' THEN
       SET MYQUERY = 'INSERT INTO '
                           ||REPO_NAME
                                      ||'.C'
                                            ||REQUEST_ID

              ||' (OBJECT_NAME,'
                  ||'OBJECT_TYPE,'
                  ||'OBJECT_LIBRARY,'
                  ||'PARENT_NODE,'
                  ||'LEVEL) '

              ||'(SELECT '
                ||'REFERENCED_OBJ,'
                ||'REFERENCED_OBJTYP,'
                ||'REFERENCED_OBJLIB,'
                ||W_ID||','
                ||LEVEL
              ||' FROM '
                        ||REPO_NAME
                                    ||'.IAALLREFPF '
              ||'WHERE '
                ||'OBJECT_TYPE IN '
                        ||'(''*PGM'','
                        ||'''*MODULE'','
                        ||'''*SRVPGM'','
                        ||'''*CMD'') '
                ||'AND REFERENCED_OBJTYP IN '
                       ||'(''*PGM'','
                       ||'''*MODULE'','
                       ||'''*SRVPGM'','
                       ||'''*CMD'') '
                || 'AND LIBRARY_NAME='''||W_OBJ_LIB
                ||''' AND OBJECT_NAME = '''||W_OBJ_NAME
                ||''' AND OBJECT_TYPE =''' ||W_OBJ_TYPE||''''
                ||')';                                                           --01
     --01       ||' AND (SELECT COUNT(*) FROM '
     --01                               ||REPO_NAME
     --01                                          ||'.C'
     --01                                                ||REQUEST_ID
     --01          ||' WHERE '
     --01                   ||' OBJECT_LIBRARY= REFERENCED_OBJLIB'
     --01                   ||' AND OBJECT_NAME = REFERENCED_OBJ'
     --01                   ||' AND OBJECT_TYPE = REFERENCED_OBJTYP )=0)';
      ELSE
        SET MYQUERY = 'INSERT INTO '
                           ||REPO_NAME
                                      ||'.C'
                                            ||REQUEST_ID

              ||' (OBJECT_NAME,'
                  ||'OBJECT_TYPE,'
                  ||'OBJECT_LIBRARY,'
                  ||'PARENT_NODE,'
                  ||'LEVEL) '

              ||'(SELECT '
                ||' A.OBJECT_NAME,'
                ||'A.OBJECT_TYPE,'
                ||'A.LIBRARY_NAME,'
                ||W_ID||','
                ||LEVEL
              ||' FROM '
                        ||REPO_NAME
                                    ||'.IAALLREFPF A '
              ||'WHERE '
                ||'A.OBJECT_TYPE IN '
                        ||'(''*PGM'','
                        ||'''*MODULE'','
                        ||'''*SRVPGM'','
                        ||'''*CMD'') '
                ||'AND A.REFERENCED_OBJTYP IN '
                       ||'(''*PGM'','
                       ||'''*MODULE'','
                       ||'''*SRVPGM'','
                       ||'''*CMD'') '
                || 'AND A.REFERENCED_OBJLIB =''' ||W_OBJ_LIB
                ||''' AND A.REFERENCED_OBJ ='''  ||W_OBJ_NAME
                ||''' AND A.REFERENCED_OBJTYP='''||W_OBJ_TYPE||''''
                ||')';                                                           --01
     --01       ||' AND (SELECT COUNT(*) FROM '
     --01                               ||REPO_NAME
     --01                                          ||'.C'
     --01                                                ||REQUEST_ID
     --01          ||' B WHERE '
     --01                   ||' B.OBJECT_LIBRARY= A.LIBRARY_NAME'
     --01                   ||' AND B.OBJECT_NAME = A.OBJECT_NAME'
     --01                   ||' AND B.OBJECT_TYPE = A.OBJECT_TYPE)=0)';
     END IF;

     EXECUTE IMMEDIATE(MYQUERY);
     IF FLAG = 0 THEN
     SET MYQUERY  ='UPDATE '||REPO_NAME||'.C'||REQUEST_ID||' SET HASCHILD = 1'
                   ||' WHERE ID ='||W_ID;
     EXECUTE IMMEDIATE(MYQUERY);

     SET MYQUERY2 = 'INSERT INTO QTEMP.T'||REQUEST_ID || ' VALUES('''            --01
                    ||W_OBJ_LIB  ||''','''||W_OBJ_NAME ||''','''||W_OBJ_TYPE     --01
 --0002             ||''','||(LEVEL-1)||')';                                     --01
                    ||''','||(LEVEL-1)||') EXCEPT SELECT OBJECT_LIBRARY'         --0002
                  ||',OBJECT_NAME,OBJECT_TYPE,TRACKED_ON_LEVEL FROM '            --0002
                  ||'QTEMP.T'||REQUEST_ID || '';                                 --0002
     EXECUTE IMMEDIATE(MYQUERY2);                                                --01

     END IF;
     END LOOP INSERT_LOOP;

     CLOSE PARENT_DATA;
     SET MESSAGE = MESSAGE_LVL||LEVEL;
--0002 EXECUTE STMT USING REQUEST_ID, BLANK, MESSAGE;

   END LOOP FETCH_LOOP;
--0002 PREPARE STMT FROM SQLSTMT;
--0002 EXECUTE STMT USING REQUEST_ID, BLANK, MESSAGE_END;
   SET STATUS = 'Y';

   SET MYQUERY2 = 'UPDATE ' ||REPO_NAME||'.C'||REQUEST_ID                        --01
                  ||' A SET A.TRACKED_ON_LEVEL = (SELECT B.TRACKED_ON_LEVEL  '   --01
                                ||'FROM QTEMP.T'||REQUEST_ID || ' B          '   --01
                                ||'WHERE A.OBJECT_NAME   = B.OBJECT_NAME     '   --01
                                ||'  AND A.OBJECT_TYPE   = B.OBJECT_TYPE     '   --01
                                ||'  AND A.OBJECT_LIBRARY= B.OBJECT_LIBRARY) '   --01
                  ||' WHERE RRN(A) > (SELECT MIN(RRN(B))                     '   --01
                                ||'FROM ' ||REPO_NAME||'.C'||REQUEST_ID          --01
                                ||' B WHERE A.OBJECT_NAME   = B.OBJECT_NAME  '   --01
                                ||'  AND A.OBJECT_TYPE   = B.OBJECT_TYPE     '   --01
                                ||'  AND A.OBJECT_LIBRARY= B.OBJECT_LIBRARY) ';  --01
   EXECUTE IMMEDIATE(MYQUERY2);                                                  --01

   SET MYQUERY2 = 'DROP TABLE QTEMP.T'||REQUEST_ID;                              --01
   EXECUTE IMMEDIATE(MYQUERY2);                                                  --01

END;

