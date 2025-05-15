--Professor: Raymond    Harmon


-- Name:  HAMID ID AZZI 
-- Class: IT-112
-- Abstract:Final Project Part 2
-- --------------------------------------------------------------------------------
/* IT-112 Database Design and SQL #2
Project-Part 1
	
Scenario: You have been tasked to create a database for a company that specializes in experimental drug studies for pharmaceutical companies. These drug studies help to get the drugs FDA approved for going to market. The studies are double blind meaning the patient and the doctor both do not know whether the patient is on active or placebo drug.

The front-end information will be gathered by phone or web site and passed to your database. You only have to handle the data and record it in the proper tables.

Your database will handle 2 studies being conducted simultaneously for the same pharmaceutical company, Acme Pharmaceuticals. The study identifiers will be 12345 and 54321. Study 12345 will use a random pick list for assigning treatment to patients. Study 54321 will use a random generator to assign treatment but each treatment, active and placebo, cannot outnumber the other by more than 2 patients. IE if there are 6 patients on active and 4 on placebo the next patient must be put on placebo so the numbers are 6 and 5. If the random generator picks active in this case the numbers would go to 7 and 4 which is more than 2.

Each study will have 5 sites in which patients can be enrolled. The site data collected will be Site Number (3-digit pre-assigned code), Name (Doctor or Hospital name), Address, City, State, Zip, phone number

The following information must be stored for both studies. For patients, the Patient ID (this will be a 6-digit number in the site number-sequential format, IE first patient from site 251 will be 251001, 2nd will be 251002, etc.), DOB, Gender, Weight will be collected.

The visits for both studies will be as follows: The Doctor will perform testing on the patient(Screening). When the test results are returned, the patient can continue in the study (Randomization), or if test results are not as desired will be removed from the study (Withdrawal).

1.	Screening
a.	At Screening, the following data will be inserted into the DB. Patient ID (site number – sequential from above), DOB, Gender and Weight in lbs. will be collected along with a visit date-does not have to be current date.
2.	Randomization
a.	At Randomization, a Randomization number will be associated with the patient per the study guidelines above. The visit date will be recorded as the current date. A drug kit of the correct type (active or placebo) will also be assigned at this visit.
3.	Withdrawal
a.	At Withdrawal, a visit date and withdrawal reason will be collected for the patient. The visit date does not have to be the current date but must be after the prior visit whether it was screening or randomization.

 
Step 1: Using MS Word, create a document showing the tables needed and the PK for each table. Do not create the FK’s or anything else at this point. ONLY A WORD DOCUMENT WITH THE TABLES AND PK’S. This is due by Saturday of Week 11 and is worth 10% of the final project grade. NO LATE SUBMISSIONS WILL BE ACCEPTED as I will be providing the tables and columns I want you to use in Week 12.

IE TPatients
	*PatientID
	
*/
-- --------------------------------------------------------------------------------
-- Options
-- --------------------------------------------------------------------------------
USE Acme     -- Get out of the master database
SET NOCOUNT ON; -- Report only errors

-- --------------------------------------------------------------------------------
-- Drop Tables
-- --------------------------------------------------------------------------------
IF OBJECT_ID('TDrugKits')							IS NOT NULL DROP TABLE		TDrugKits
IF OBJECT_ID('TVisits' )     			        	IS NOT NULL DROP TABLE		TVisits
IF OBJECT_ID('TWithdrawReasons')					IS NOT NULL DROP TABLE		TWithdrawReasons
IF OBJECT_ID('TVisitTypes')						    IS NOT NULL DROP TABLE		TVisitTypes
IF OBJECT_ID('TPatients')							IS NOT NULL DROP TABLE		TPatients
IF OBJECT_ID('TGenders')							IS NOT NULL DROP TABLE		TGenders
IF OBJECT_ID('TSites')						    	IS NOT NULL DROP TABLE		TSites
IF OBJECT_ID('TRandomCodes')						IS NOT NULL DROP TABLE		TRandomCodes
IF OBJECT_ID('TStudies')			               	IS NOT NULL DROP TABLE		TStudies
-----------------------


---- --------------------------------------------------------------------------------
---- Drop fonction 
---- --------------------------------------------------------------------------------
--IF OBJECT_ID( 'fn_GetUserName' )							IS NOT NULL DROP FUNCTION 		fn_GetUserName
--IF OBJECT_ID( 'fn_GetSongs' )						    	IS NOT NULL DROP FUNCTION 		fn_GetSongs

---- --------------------------------------------------------------------------------
---------------------------------------------------------------------------------
--Drop procedure
----------------------------------------------------------------------------

IF OBJECT_ID( 'uspWithdrawlPatient' )						                    	   IS NOT NULL DROP procedure		uspWithdrawlPatient
IF OBJECT_ID( 'uspRandom' )						                    	               IS NOT NULL DROP procedure		uspRANDOM
IF OBJECT_ID( 'uspInsertIntoTrandomCode' )						                    	IS NOT NULL DROP procedure		uspInsertIntoTrandomCode
IF OBJECT_ID( 'uspRuspWithdrawlPatientandom' )				        	              IS NOT NULL DROP procedure		uspWithdrawlPatient
IF OBJECT_ID( 'uspInsertIntoTPatientsAndTVisits' )				        	          IS NOT NULL DROP procedure		uspInsertIntoTPatientsAndTVisits




----------------------------------------------------------------------------------------------------------------------------------
--Drop VIEWS
------------------------------------------------------------------------------------------------------------------------



IF OBJECT_ID( 'VRandomizedPatientsAndTreatmentStaduy' )						            	IS NOT NULL DROP VIEW		VRandomizedPatientsAndTreatmentStaduy
IF OBJECT_ID( 'vNextRandomCode' )						                    	            IS NOT NULL DROP VIEW		vNextRandomCode
IF OBJECT_ID( 'VpatientANDsitesANDstudies' )						                    	IS NOT NULL DROP VIEW		VpatientANDsitesANDstudies
IF OBJECT_ID( 'vDrugKitAndSite' )						                                	IS NOT NULL DROP VIEW		vDrugKitAndSite



-- --------------------------------------------------------------------------------
-- Step #1.1: Create Tables
-- --------------------------------------------------------------------------------

CREATE TABLE TStudies
(
	  intStudyID			INTEGER			NOT NULL
	,strStudyDesc 		  VARCHAR(50)		NOT NULL
	
	,CONSTRAINT TStudies_PK PRIMARY KEY ( intStudyID )
)



CREATE TABLE TSites
(
	 intSiteID 			 INTEGER			    NOT NULL
	,intSiteNumber 		 INTEGER     	    	NOT NULL IDENTITY (101,1)     --(101, 102, 103, etc.) WE USE IDENTITY COLUMN PROPRETY FOR GENERATING KEY VALUES BSED ON THE CURRENT seed & increment so seed = 101 increement = 1 
	,intStudyID  		 INTEGER		        NOT NULL
	,strName             VARCHAR(250)		    NOT NULL
	,strAddress          VARCHAR(250)		    NOT NULL
	,strCity             VARCHAR(250)		    NOT NULL
	,strState            VARCHAR(250)		    NOT NULL
	,strZip              VARCHAR(250)		    NOT NULL
	,strPhone            VARCHAR(250)		    NOT NULL
	,CONSTRAINT TSites_PK PRIMARY KEY ( intSiteID )
)


CREATE TABLE TPatients
(
  intPatientID            INTEGER			    NOT NULL 
  ,intPatientNumber	      INTEGER			    NOT NULL IDENTITY (101001,1)  --(101001, 102001, etc)
  ,intSiteID              INTEGER			    NOT NULL
  ,dtmDOB                 Datetime              NOT NULL
  ,intGenderID            INTEGER			    NOT NULL
  ,intWeight              INTEGER			    NOT NULL
  ,intRandomCodeID 	      INTEGER             
  ,CONSTRAINT TPatients_PK PRIMARY KEY ( intPatientID )

)


CREATE TABLE TVisitTypes
( 
      intVisitTypeID      INTEGER			    NOT NULL
	  ,strVisitDesc       VARCHAR(250)		    NOT NULL   --(Screening, Randomization, Withdrawal)
	  ,CONSTRAINT TVisitTypes_PK PRIMARY KEY ( intVisitTypeID )
)


CREATE TABLE TVisits
(
 
  intVisitID              INTEGER			    NOT NULL IDENTITY
 ,intPatientID            INTEGER			    NOT NULL
 ,dtmVisit                Datetime              NOT NULL
 ,intVisitTypeID          INTEGER			    NOT NULL
 ,intWithdrawReasonID 	  INTEGER

  ,CONSTRAINT TPatientVisits_PK PRIMARY KEY ( intVisitID )

)


CREATE TABLE TRandomCodes
(
    intRandomCodeID          INTEGER			    NOT NULL
   ,intRandomCode           INTEGER			    NOT NULL IDENTITY (1000,1) --(1000, 1001, 1002, etc.)
   ,intStudyID              INTEGER			    NOT NULL
   ,strTreatment            VARCHAR(250)	    NOT NULL                        --(A-active or P-placebo) ***keeps input to A or P only
   ,blnAvailable            VARCHAR(250)	    NOT NULL                        -- (T or F) use a varchar data type                  

,CONSTRAINT TRandomCodes_PK PRIMARY KEY ( intRandomCodeID )
                                                                               --,CONSTRAINT CK_TRandomCodes CHECK (strTreatment = 'A' OR strTreatment = 'P' )                          --CHECK CONSTRAINT
)

CREATE TABLE TDrugKits 
(
  intDrugKitID              INTEGER			    NOT NULL
  ,intDrugKitNumber	        INTEGER             NOT NULL   IDENTITY (10000,1)         --(10000, 10001, 10002, etc.)
  ,intSiteID                INTEGER             NOT NULL 
  ,strTreatment             VARCHAR(250)	    NOT NULL            --  (A-active or P-placebo)
  ,intVisitID               INTEGER                                 -- (if a Visit ID entered it is already assigned and therefore not available) allow Nulls
  ,CONSTRAINT TDrugKits_PK PRIMARY KEY (intDrugKitID)
)

 CREATE TABLE TWithdrawReasons
(
 intWithdrawReasonID          INTEGER			    NOT NULL
,strWithdrawDesc              VARCHAR(250)	        NOT NULL 
,CONSTRAINT TWithdrawReasons_PK PRIMARY KEY (intWithdrawReasonID)

)

CREATE TABLE TGenders
(
 intGenderID    INTEGER			       NOT NULL
 ,strGender      VARCHAR(250)	        NOT NULL 
 ,CONSTRAINT TGenders_PK PRIMARY KEY (intGenderID)

)






-- --------------------------------------------------------------------------------
-- Step #1.2: Identify and Create Foreign Keys
-- --------------------------------------------------------------------------------
-- #	Child								Parent						Column(s)
--------------------------------------------------------------------------------------
-- 1  TSites                                TStudies                     intStudyID  
-- 2  TRandomCodes                          TStudies                     intStudyID
-- 3  TPatients                             TSites                       intSiteID
-- 4  TDrugKits                             TSites                       intSiteID
-- 5  TPatientVisits                        TPatients                    intPatientID
---6  TDrugKits                             TPatientVisits               intVisitID
-- 7  TPatients                             TRandomCodes                 intRandomCodeID
-- 8  TPatientVisits                        TVisitTypes                  intVisitTypeID
-- 9  TPatients                             TGenders                     intGenderID
-- 10 TPatientVisits                        TWithdrawReasons             intWithdrawReasonID
-- --ALTER TABLE <Child Table> ADD CONSTRAINT <Child Table>_<Parent Table>_FK1
--FOREIGN KEY ( <Child column> ) REFERENCES <Parent Table> ( <Parent column> )  

--1
ALTER TABLE TSites ADD CONSTRAINT TSites_TStudies_FK1
FOREIGN KEY ( intStudyID ) REFERENCES TStudies (intStudyID)
--2
ALTER TABLE TRandomCodes ADD CONSTRAINT TRandomCodes_TStudies_FK1
FOREIGN KEY (intStudyID) REFERENCES  TStudies (intStudyID)
--3
ALTER TABLE TPatients ADD CONSTRAINT TPatients_TSites_FK1
FOREIGN KEY (intSiteID) REFERENCES   TSites (intSiteID)
--4
ALTER TABLE TDrugKits ADD CONSTRAINT TDrugKits_TSites_FK1
FOREIGN KEY (intSiteID) REFERENCES TSites (intSiteID)
--5
ALTER TABLE TVisits ADD CONSTRAINT TVisits_TPatients_FK1
FOREIGN KEY (intPatientID) REFERENCES TPatients (intPatientID)
--6
ALTER TABLE TDrugKits ADD CONSTRAINT TDrugKits_TVisits_FK1
FOREIGN KEY (intVisitID) REFERENCES TVisits (intVisitID)
--7
ALTER TABLE TPatients ADD CONSTRAINT TPatients_TRandomCodes_FK1
FOREIGN KEY (intRandomCodeID) REFERENCES TRandomCodes (intRandomCodeID)
--8
ALTER TABLE TVisits ADD CONSTRAINT TVisits_TVisitTypes_FK1
FOREIGN KEY (intVisitTypeID) REFERENCES TVisitTypes (intVisitTypeID)
--9
ALTER TABLE TPatients ADD CONSTRAINT TPatients_TGenders_FK1
FOREIGN KEY (intGenderID) REFERENCES TGenders (intGenderID)
--10
ALTER TABLE TVisits ADD CONSTRAINT TVisits_TWithdrawReasons_FK1
FOREIGN KEY (intWithdrawReasonID) REFERENCES TWithdrawReasons (intWithdrawReasonID)

---- --------------------------------------------------------------------------------
----  Add  Data - INSERTS
---- --------------------------------------------------------------------------------
  INSERT INTO TStudies (intStudyID,strStudyDesc)
  VALUES	           (12345,'Study 1')
                      ,(54321,'Study 2')
	    
	--------------------------------------


INSERT INTO  TRandomCodes (intRandomCodeID, intStudyID, strTreatment, blnAvailable  )
VALUES                        (1000,12345,'A','T')
                             ,(1001,12345,'P','T')
                             ,(1002,12345,'A','T')
                             ,(1003,12345,'P','T')
                             ,(1004,12345,'P','T')
                             ,(1005,12345,'A','T')
                             ,(1006,12345,'A','T')
                             ,(1007,12345,'P','T')
                             ,(1008,12345,'A','T')
						     ,(1009,12345,'P','T')
                             ,(1010,12345,'P','T')
                             ,(1011,12345,'A','T')
                             ,(1012,12345,'P','T')
                             ,(1013,12345,'A','T')
                             ,(1014,12345,'A','T')
                             ,(1015,12345,'A','T')
                             ,(1016,12345,'P','T')
                             ,(1017,12345,'P','T')
                             ,(1018,12345,'A','T')
                             ,(1019,12345,'P','T')
                             ,(5000,54321,'A','T')
                             ,(5001,54321,'A','T')
                             ,(5002,54321,'A','T')
                             ,(5003,54321,'A','T')
                             ,(5004,54321,'A','T')
                             ,(5005,54321,'A','T')
                             ,(5006,54321,'A','T')
                             ,(5007,54321,'A','T')
                             ,(5008,54321,'A','T')
                             ,(5009,54321,'A','T')
                             ,(5010,54321,'P','T')
                             ,(5011,54321,'P','T')
                             ,(5012,54321,'P','T')
                             ,(5013,54321,'P','T')
                             ,(5014,54321,'P','T')
                             ,(5015,54321,'P','T')
                             ,(5016,54321,'P','T')
                             ,(5017,54321,'P','T')
                             ,(5018,54321,'P','T')
                             ,(5019,54321,'P','T')
  





---------------------------------------------------------
INSERT INTO TSites  (intSiteID,  intStudyID, strName, strAddress, strCity, strState, strZip, strPhone)
VALUES  (101,	12345,	'Dr. Stan Heinrich' ,	'123 E. Main St'	,'Atlanta',	'GA',	25869,	1234567890)
        ,(111,	12345,	'Mercy Hospital',	'3456 Elmhurst Rd.',	'Secaucus',	'NJ'	,32659,	5013629564)
        ,(121,	12345,	'St. Elizabeth Hospital',	'976 Jackson Way	Ft.', 'Thomas'	,'KY'	,41258,	3026521478)
        ,(501,	54321,	'Dr. Robert Adler',	'9087 W. Maple Ave.',	'Cedar Rapids',	'IA',	42365,	6149652574)
        ,(511,	54321,	'Dr. Tim Schmitz'	,'4539 Helena Run'	,'Johnson City'	,'TN'	,34785,	5066987462)
        ,(521,	54321,	'Dr. Lawrence Snell',	'9201 NW. Washington Blvd.',	'Bristol',	'VA',	20163,	3876510249)



  
-----------------
INSERT INTO  TGenders (intGenderID, strGender )
VALUES                (1,'Female')
                      ,(2,'Male')




--------------------------------------------------------------------------------------
--INSERT INTO TPatients  ( intPatientNumber, intSiteID, dtmDOB, intGenderID, intWeight, intRandomCodeID)
--VALUES   ()


----------------------------------------------------------------------
INSERT INTO TVisitTypes (intVisitTypeID, strVisitDesc)
VALUES     (1,'Screening')
           ,(2,'Randomization')
          ,(3,'Withdrawal')


-------------------------------------

INSERT INTO TWithdrawReasons (intWithdrawReasonID, strWithdrawDesc )
VALUES                      (1,	'Patient withdrew consent')
                           ,(2,	'Adverse event')
                           ,(3,	'Health issue-related to study')
                           ,(4,	'Health issue-unrelated to study')
                           ,(5,	'Personal reason')
                           ,(6,	'Completed the study')

------------------------------------
--INSERT INTO TVisits ( intPatientID,dtmVisit, intVisitTypeID, intWithdrawReasonID  )
--VALUES        ()


----------------------------------------


  
-- --------------------------------------------
 INSERT INTO TDrugKits (intDrugKitID, intSiteID, strTreatment, intVisitID  )
 VALUES                (10000,  101,	'A',null)
                      ,(10001,  101,	'A',null)
                      ,(10002,  101,	'A',null)
                      ,(10003,  101,	'P',null)
                      ,(10005,  101,	'P',null)
                      ,(10006,  111,	'A',null)
                      ,(10007,  111,	'A',null)
                      ,(10008,  111,	'A',null)
                      ,(10009,  111,	'P',null)
                      ,(10010,  111,	'P',null)
                      ,(10011,  111,	'P',null)
                      ,(10012,  121,	'A',null)
                      ,(10013,  121,	'A',null)
                      ,(10014,	121,	'A',null)
                      ,(10015,	121,	'P',null)
                     ,(10016,   121,	'P',null)
                     ,(10017,	121,	'P',null)
                     ,(10018,	501,	'A',null)
                     ,(10019,	501,	'A',null)
                     ,(10020,	501,	'A',null)
                     ,(10021,	501,	'P',null)
                     ,(10023,	501,	'P',null)
                     ,(10024,	511,	'A',null)
                     ,(10025,	511,	'A',null)
                    ,(10026,	511,	'A',null)
                    ,(10028,	511,	'P',null)
                    ,(10029,	511,	'P',null)
                    ,(10030,	521,	'A',null)
                    ,(10031,	521,	'A',null)
                    ,(10032,	521,	'A',null)
                    ,(10033,	521,	'P',null)
                    ,(10034,	521,    'P',null)
                   ,(10035,	    521,    'P',null)
---------------------------------------------------------------------------------------------------------------

SELECT * FROM TPatients
SELECT * FROM TSites
SELECT * FROM TStudies




--------------------------------------------------------------------------------------------------------
--3.	Create the view that will show all patients at all sites for both studies	
--------------------------------------------------------------------------------------------------------

select  TP.intPatientID,TP.intPatientNumber,TP.intSiteID,TS.strName,TST.intStudyID,TSt.strStudyDesc

FROM TPatients AS TP
    JOIN TSites AS TS
	ON TS.intSiteID = TP.intSiteID
	JOIN TStudies AS TST
	ON TST.intStudyID = TS.intStudyID
      
--GO
--CREATE VIEW  VpatientANDsitesANDstudies
--AS
--SELECT TP.intPatientID
--       ,TP.intPatientNumber
--       ,TP.intSiteID
--       ,TP.dtmDOB
--       ,TP.intGenderID
--       ,TP.intWeight
--       ,TP.intRandomCodeID
--       --,TS.intSiteID 
--       ,TS.intSiteNumber
--       ,TS.intStudyID
--       ,TS.strAddress
--       ,TS.strCity
--       ,TS.strName
--       ,TS.strPhone
--       ,TS.strState
--       ,TS.strZip
--	   ,TST.strStudyDesc
--FROM
--TPatients AS TP 
--JOIN 
--TSites AS TS 
--ON TS.intSiteID = TP.intSiteID
--JOIN TStudies AS TST
--ON TST.intStudyID =TS.intStudyID


--WHERE
--     TST.intStudyID IN (12345,54321)

--GO
--SELECT * FROM VpatientANDsitesANDstudies

--------------------------------------------------------------------------------------
----4.	Create the view that will show all randomized patients, their site and their treatment for both studies. You can do this together or 1 view for each study.
------------------------------------------------------------------------------------------------------------------------------------------------


SELECT * FROM TRandomCodes
GO
CREATE VIEW  VRandomizedPatientsAndTreatmentStaduy
AS
	   SELECT TP.intPatientID,TP.intRandomCodeID,TS.intSiteID,TR.strTreatment,TR.intStudyID,TST.strStudyDesc
	   FROM 
	          TPatients AS TP
			  JOIN TSites AS TS
			  ON TP.intSiteID =TS.intSiteID
			  JOIN TRandomCodes AS TR 
			  ON TP.intRandomCodeID = TR.intRandomCodeID
			  JOIN TStudies AS TST
			  ON TR.intStudyID=TST.intStudyID
			  WHERE
     
	            TR.intStudyID IN (12345,54321)
GO


SELECT * FROM VRandomizedPatientsAndTreatmentStaduy
   ----------------------------------------------------------------------------------------------------------------------------------------------
--5.	Create the view that will show the next available random codes (MIN) for both studies. You can do this together or 1 view for each study.
-------------------------------------------------------------------------------------------------------------------------------------------------
GO
 CREATE VIEW vNextRandomCode
 AS
SELECT   MAX(intRandomCode)AS [the next available random codes]-- ,TR.intRandomCode --,TS.intStudyID,
      FROM 
	         TRandomCodes AS TR
WHERE			 
intStudyID IN (12345,54321)

 
  
 GO	
 SELECT  * FROM vNextRandomCode	 

 --select * from TRandomCodes

 --------------------------------------------------------------------------------------------------------------------------------------------
 --6.	Create the view that will show all available drug at all sites for both studies. You can do this together or 1 view for each study.
 ----------------------------------------------------------------------------------------------------------------------------------------------
 ----SELECT TDrugKits.intDrugKitID,TDrugKits.intDrugKitNumber,TDrugKits.intSiteID
 -- SELECT TDK.INTDRUGKITNUMBER,TDK.STRTREATMENT,TS.intSiteNumber,TS.STRNAME,TSD.INTSTUDYID
 --    FROM TDrugKits AS TDK, TSites AS TS, TStudies AS TSD
 GO
 CREATE VIEW vDrugKitAndSite
 AS

	 SELECT TD.intDrugKitNumber,TD.strTreatment,TS.intSiteNumber,TS.strName,TST.intStudyID,TSt.strStudyDesc
	 FROM 
	     TDrugKits AS TD
		 JOIN TSites AS TS 
		 ON   TS.intSiteID = TD.intSiteID
		 JOIN
		        TStudies AS TST
				ON TST.intStudyID = TS.intStudyID

WHERE
     
	            TST.intStudyID IN (12345,54321)

GO
--SELECT * FROM vDrugKitAndSite

 ---------------------------------------------------------------------
 --PROCEDURE CALCULE available random codes uspRandom
 ------------------------------------------------------------------------
 GO 
 CREATE  PROCEDURE uspRandom -- assigning treatment to patients

                  @strTreatment       AS  VARCHAR OUTPUT 
				 ,@intStudyID     AS INTEGER

AS
SET XACT_ABORT ON   -- tERMINAT AND ROLLBACK IF ANY ERRORS 

BEGIN 
             DECLARE @ContActive  AS INT -- count active treatment 
             DECLARE @ContPlacebo AS INT  -- count placebo treatment 
			 DECLARE @Random    AS DECIMAL(6,2)

	IF @intStudyID = 12345
	    begin
		 
		  SELECT @Random = RAND( )  
		  IF @Random <= .5
		    SET @strTreatment = 'A'
		ELSE
		  SET @strTreatment = 'P' 
		end

 	IF  @intStudyID = 54321
	   BEGIN
	   
	     SELECT @ContActive  = COUNT(intStudyID) FROM TRandomCodes
		  WHERE intStudyID =  @intStudyID AND strTreatment = 'A'
		  		  	  	  
	      SELECT @ContPlacebo = COUNT(intStudyID) FROM TRandomCodes  
		  WHERE intStudyID =  @intStudyID AND strTreatment = 'P'
	   END 
	     IF (@ContActive - @ContPlacebo) = 1
		   BEGIN
			   SELECT @Random = RAND( )  
				IF @Random <= .5
				SET @strTreatment = 'A'
			  ELSE
				SET @strTreatment = 'P'  
	        END
		IF (@ContActive - @ContPlacebo) = 2
		  BEGIN
		    SET @strTreatment = 'P' 
			END
		IF (@ContActive - @ContPlacebo) < 1
		  BEGIN
		    SET @strTreatment = 'A' 
			END
 END
     		

GO
 --************************************
 --TEST uspRandom
 --*************************************
--declare @strTreatment as VARCHAR 
--EXECUTE uspRandom @strTreatment OUTPUT, 12345
--Print 'treatmant = ' + CAST(@strTreatment as VARCHAR(100))



--DROP PROCEDURE uspInsertIntoTrandomCode 
----------------*************--------------------------------------------------------------------------------------
--procedure insert data into TRandomCodes
----------------****************------------------------------------------------------------------------------------
GO 
 CREATE  PROCEDURE uspInsertIntoTrandomCode                           -----procedure insert data into TRandomCodes
                      @intRandomCodeID      AS INTEGER OUTPUT
                     ,@intStudyID           AS INTEGER


 AS
 SET NOCOUNT ON        -- REPORT ONLY ERRORS 
 SET XACT_ABORT ON      -- tERMINAT AND ROLLBACK IF ANY ERRORS 

 BEGIN TRANSACTION  
         SELECT @intRandomCodeID = MAX(intRandomCodeID) + 1
		 FROM TRandomCodes 
		 -- We use RANDOM function to help us get availability situation F or T automatiquly without passing it 
		 DECLARE @Availability AS     DECIMAL(6,2)
		 DECLARE @blnAvailable       AS VARCHAR(10) 
		 SELECT @Availability = RAND() -0.2
		 IF @Availability <= .7
		     SET @blnAvailable ='T'
		 ELSE
		     SET @blnAvailable = 'F'
	  	DECLARE  @strTreatment             AS VARCHAR
        EXECUTE uspRandom @strTreatment OUTPUT  ,@intStudyID


	    INSERT INTO TRandomCodes with (TABLOCKX) (intRandomCodeID,intStudyID,strTreatment,blnAvailable)
	    VALUES                                   (@intRandomCodeID,@intStudyID,@strTreatment,@blnAvailable)
	   

COMMIT TRANSACTION 
GO  

--**************************
--TEST

--DECLARE @intRandomCodeID AS INT 
--EXECUTE uspInsertIntoTrandomCode  @intRandomCodeID OUTPUT , 54321
--PRINT ('intRandomCodeID  = ' + CONVERT(VARCHAR, @intRandomCodeID))

--select * from TRandomCodes
---------------------------------------------------
--PROCEDURE ADD PATIENT 
--procedure insert data into TPatients
-------------------------------------------------------
--
 --DROP PROCEDURE uspInsertIntoTPatientsAndTVisits
GO
CREATE PROCEDURE uspInsertIntoTPatientsAndTVisits
                  @intPatientID       AS INTEGER OUTPUT
				
				 ,@intSiteID         AS INTEGER
				 ,@dtmDOB            AS DATETIME
				 ,@intGenderID       AS INTEGER
				 ,@intWeight         AS INTEGER
				 ,@intStudyID        AS INTEGER 
				 ---------------------------------
				 ,@dtmVisit                 AS DATETIME
				 ,@intVisitTypeID          AS INTEGER
				 ,@intWithdrawReasonID     AS INTEGER
AS
SET XACT_ABORT ON   -- tERMINAT AND ROLLBACK IF ANY ERRORS 

BEGIN TRANSACTION
  
        SELECT @intPatientID = MAX(intPatientID) + 1
		FROM TPatients (TABLOCKX)                         --LOCK THE TABLE UNTIL END  OF THE TRANSACTION 
		SELECT @intPatientID = COALESCE(@intPatientID, 1 ) --DEFAULT TO 1 IF THE TABLE IS EMPTY 

		DECLARE @blnAvailable AS VARCHAR
		
		DECLARE @intRandomCodeID AS INT 
		EXECUTE uspInsertIntoTrandomCode  @intRandomCodeID OUTPUT , @intStudyID  -- assigning treatment to patients
		--INSERT DATA INTO TABLE 
		INSERT INTO TPatients(intPatientID,intSiteID,dtmDOB,intGenderID,intWeight,intRandomCodeID)   --INSERT DATA INTO TABLE TPatients
		VALUES                ( @intPatientID,@intSiteID,@dtmDOB,@intGenderID,@intWeight,@intRandomCodeID)
       INSERT INTO TVisits ( intPatientID,dtmVisit, intVisitTypeID, intWithdrawReasonID  )         --INSERT DATA INTO TABLE TVisits
            VALUES         ( @intPatientID,@dtmVisit, @intVisitTypeID, @intWithdrawReasonID  )
		
COMMIT TRANSACTION 
GO 
--*****************************************
----TEST
--*****************************************
--DECLARE @intPatientID AS INTEGER = 0

--EXECUTE uspInsertIntoTPatientsAndTVisits @intPatientID OUTPUT,101,'10/12/1999',1,175,54321,'01/05/2017',2,null

--PRINT 'Patient ID = ' + CONVERT(VARCHAR, @intPatientID)
-----


--EXECUTE uspInsertIntoTPatientsAndTVisits @intPatientID OUTPUT,121,'12/10/1950',1,110,12345,'02/22/2017',2,null

--PRINT 'Patient ID = ' + CONVERT(VARCHAR, @intPatientID)
-----


--EXECUTE uspInsertIntoTPatientsAndTVisits @intPatientID OUTPUT,511,'11/02/1977',1,150,12345,'03/02/2017',2,null

--PRINT 'Patient ID = ' + CONVERT(VARCHAR, @intPatientID)
--------


--EXECUTE uspInsertIntoTPatientsAndTVisits @intPatientID OUTPUT,501,'10/03/1955',1,155,12345,'04/12/2017',2,null

-----54321--------------------------------------------------------------------------------
--EXECUTE uspInsertIntoTPatientsAndTVisits @intPatientID OUTPUT,101,'12/12/1978',1,175,54321,'01/02/2017',2,null

--PRINT 'Patient ID = ' + CONVERT(VARCHAR, @intPatientID)
-----


--EXECUTE uspInsertIntoTPatientsAndTVisits @intPatientID OUTPUT,121,'12/10/1950',1,110,54321,'02/22/2017',2,null

--PRINT 'Patient ID = ' + CONVERT(VARCHAR, @intPatientID)
-----


--EXECUTE uspInsertIntoTPatientsAndTVisits @intPatientID OUTPUT,511,'11/02/1977',1,150,54321,'03/02/2017',2,null

--PRINT 'Patient ID = ' + CONVERT(VARCHAR, @intPatientID)
--------


--EXECUTE uspInsertIntoTPatientsAndTVisits @intPatientID OUTPUT,501,'10/03/1955',1,155,54321,'04/12/2017',2,null
--PRINT 'Patient ID = ' + CONVERT(VARCHAR, @intPatientID)
-----
--SELECT * FROM TPatients

--SELECT * FROM TVisits
--select * from TRandomCodes
-------------------------------------------------------------------------------------------------------------------------------------------------------
--11.	Create the stored procedure(s) that will withdraw a patient for both studies. You can do this together or 1 for each study. 
--Remember a patient can go from Screening Visit to Withdrawal without being randomized. This will be up to the Doctor. Your code just has to be able to do it.
------------------------------------------------------------------------------------------------------------------------------------------------------------

	  --DROP PROC uspWithdrawlPatient
GO
 CREATE PROCEDURE uspWithdrawlPatient
                  @intPatientID       AS INTEGER 
				 ---------------------------------
				 ,@dtmVisit                 AS DATETIME
				 --,@intVisitTypeID          AS INTEGER
				 ,@intWithdrawReasonID     AS INTEGER 
AS
SET XACT_ABORT ON   -- tERMINAT AND ROLLBACK IF ANY ERRORS 

BEGIN TRANSACTION
              DECLARE @intVisitTypeID AS INT
             
             SET @intVisitTypeID = 3
           INSERT INTO TVisits ( intPatientID,dtmVisit, intVisitTypeID, intWithdrawReasonID  )         --INSERT DATA INTO TABLE TVisits
           VALUES         ( @intPatientID,@dtmVisit, @intVisitTypeID, @intWithdrawReasonID  )
		
		COMMIT TRANSACTION 
GO
--TEST
--DECLARE @intPatientID AS INTEGER = 0

--EXECUTE uspWithdrawlPatient 3,'10/12/1999',1



select * from TWithdrawReasons	
select * from TVisitTypes	
SELECT * FROM TDRUGKITS
SELECT * FROM TVisits