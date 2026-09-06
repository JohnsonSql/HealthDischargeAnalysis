SELECT *
  FROM [dbo].[Clean_Adm_Data];

  -- 1  Total Discharges
  SELECT COUNT([OUTCOME]) AS Total_discharges
  FROM [dbo].[Clean_Adm_Data]
  WHERE [OUTCOME]='DISCHARGE';

    -- 2 Total Length of Stay
   SELECT SUM([DURATION_OF_STAY]) AS Total_length_Stay
   FROM [dbo].[Clean_Adm_Data]
   WHERE [OUTCOME]='DISCHARGE';

   SELECT AVG([DURATION_OF_STAY]) AS Total_length_Stay
   FROM [dbo].[Clean_Adm_Data]
   WHERE [OUTCOME]='DISCHARGE';


  -- 3 Average daily discharge rate
  

  SELECT (SELECT COUNT([OUTCOME]) AS Total_discharges
  FROM [dbo].[Clean_Adm_Data]
  WHERE [OUTCOME]='DISCHARGE')/
(SELECT COUNT (*)
   FROM (SELECT DISTINCT [ND_O_D] AS Total_DischargesDate
        FROM [dbo].[Clean_Adm_Data]
        WHERE [OUTCOME]='DISCHARGE') AS Unique_dischargeDay) AS Average_DailyDischarge_rate

-- 4  Distribution of discharges by Age group and Gender Discharges by day of the week,

  SELECT [GENDER], COUNT([OUTCOME]) AS Total_discharges
  FROM [dbo].[Clean_Adm_Data]
  WHERE [OUTCOME]='DISCHARGE'
  GROUP BY [GENDER]

   -- 5 Total Discharges by Age Group

  SELECT [Age_Group],COUNT([OUTCOME]) AS Total_discharges
  FROM [dbo].[Clean_Adm_Data]
  WHERE [OUTCOME]='DISCHARGE'
  GROUP BY [Age_Group]
  ORDER BY [Total_discharges] DESC

   -- 6 Total Discharges by Age Group Based on Percentage_of_Discharges

  SELECT
       [Age_Group],COUNT(*) AS Total_Discharge,
    CAST(
    COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS DECIMAL(5,2)
    ) AS  Percentage_of_Discharges
  FROM Clean_Adm_Data
  GROUP BY AGE_GROUP
  ORDER BY 2 DESC

  -- 7 Distribution of Gender Discharges by day of the week

SELECT 
     DATENAME(WEEKDAY, [ND_O_D]) AS Day_of_Week,[GENDER],
              COUNT(*) AS Total_Discharges
  FROM Clean_Adm_Data
  WHERE [OUTCOME]='DISCHARGE' AND DATENAME(WEEKDAY, [ND_O_D]) IS NOT NULL
  GROUP BY 
DATENAME(WEEKDAY, [ND_O_D]),[GENDER]
  ORDER BY [GENDER],DATENAME(WEEKDAY, [ND_O_D])


  SELECT *
  FROM [Dbo].[Clean_Adm_Data]

