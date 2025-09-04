Select * from [dbo].[ZyntrixTratada]
-----------------------------------------------
ALTER TABLE [dbo].[ZyntrixTratada]
ADD 
    investidor_1 NVARCHAR(255),
    investidor_2 NVARCHAR(255),
    investidor_3 NVARCHAR(255);

------------------------------------------------------------
UPDATE [dbo].[ZyntrixTratada]
SET 
    investidor_1 = PARSENAME(REPLACE([Investidores], ',', '.'), 
                    CASE WHEN (LEN([Investidores]) - LEN(REPLACE([Investidores], ',', ''))) >= 2 THEN 3
                         WHEN (LEN([Investidores]) - LEN(REPLACE([Investidores], ',', ''))) = 1 THEN 2
                         ELSE 1 END),
    
    investidor_2 = CASE WHEN (LEN([Investidores]) - LEN(REPLACE([Investidores], ',', ''))) >= 1
                        THEN PARSENAME(REPLACE([Investidores], ',', '.'), 
                             CASE WHEN (LEN([Investidores]) - LEN(REPLACE([Investidores], ',', ''))) >= 2 THEN 2 ELSE 1 END)
                        ELSE NULL END,
    
    investidor_3 = CASE WHEN (LEN([Investidores]) - LEN(REPLACE([Investidores], ',', ''))) >= 2
                        THEN PARSENAME(REPLACE([Investidores], ',', '.'), 1)
                        ELSE NULL END;

--------------------------------------------------
ALTER TABLE [dbo].[ZyntrixTratada]
    DROP COLUMN [Investidores];
---------------------------------------------------


