--Create the clean data as a view
CREATE OR ALTER VIEW Clean_Adm_Data AS 
--Build 1
--This is a transformation to split the date
WITH date_transformation AS (
  SELECT *,CASE LEFT([MONTH_YEAR],3)
           WHEN 'Jan' THEN 1
           WHEN 'Feb' THEN 2
           WHEN 'Mar' THEN 3
           WHEN 'Apr' THEN 4
           WHEN 'May' THEN 5
           WHEN 'Jun' THEN 6
           WHEN 'Jul' THEN 7
           WHEN 'Aug' THEN 8
           WHEN 'Sep' THEN 9
           WHEN 'Oct' THEN 10
           WHEN 'Nov' THEN 11
           WHEN 'Dec' THEN 12
            ELSE NULL
            END MONTH_NUM,LEFT([D_O_A],CHARINDEX('/',[D_O_A])-1) [P1D_O_A],
            SUBSTRING( [D_O_A],
            CHARINDEX('/',[D_O_A])+1,
            2
            )[P2D_O_A],RIGHT([D_O_A],4) [P3D_O_A],LEFT([D_O_D],CHARINDEX('/',[D_O_D])-1) [P1D_O_D],
            SUBSTRING( [D_O_D],
            CHARINDEX('/',[D_O_D])+1,
            2
            )[P2D_O_D],RIGHT([D_O_D],4) [P3D_O_D]
FROM [dbo].[HDHI_Admission_data]
WHERE [D_O_D] !='2-1217'
)
 ,Date_clean AS(
SELECT *,
    IIF( P1D_O_A=MONTH_NUM,
        TRY_CAST(CONCAT(P1D_O_A,'/',P2D_O_A,'/',P3D_O_A) AS DATE),
        TRY_CAST(CONCAT(P2D_O_A,'/',P1D_O_A,'/',P3D_O_A) AS DATE)
    ) ND_O_A,
     IIF( P1D_O_A=MONTH_NUM AND [P1D_O_D]<=12,
        TRY_CAST(CONCAT([P1D_O_D],'/',[P2D_O_D],'/',[P3D_O_D]) AS DATE),
        TRY_CAST(CONCAT([P2D_O_D],'/',[P1D_O_D],'/',[P3D_O_D]) AS DATE)
    ) [ND_O_D]
FROM date_transformation
)
,Clean_Data AS(
SELECT * ,
ROW_NUMBER() OVER(PARTITION BY [MRD_No],[ND_O_A],[ND_O_D] ORDER BY [MRD_No]) AS Dup_No
FROM Date_clean
)
SELECT [MRD_No],[ND_O_A],[ND_O_D],[AGE],
CASE
 WHEN [AGE] BETWEEN 0 AND 12 THEN 'CHILDREN'
 WHEN [AGE] BETWEEN 13 AND 19 THEN 'TEENAGERS'
 WHEN [AGE] BETWEEN 20 AND 65 THEN 'ADULTS'
 WHEN [AGE] > 65 THEN 'SENIOR CITIZENS'
 ELSE 'NOT KNOWN'
 END AS [Age_Group],
[GENDER],[RURAL],[TYPE_OF_ADMISSION_EMERGENCY_OPD],[month_year],
[DURATION_OF_STAY],[duration_of_intensive_unit_stay],[OUTCOME],[Dup_No]
FROM Clean_Data
WHERE [Dup_No]=1 AND [MRD_No] IS NOT NULL


     




