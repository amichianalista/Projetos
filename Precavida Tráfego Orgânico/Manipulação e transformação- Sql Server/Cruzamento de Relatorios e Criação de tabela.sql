------------------ Relatórios importados Analytics/Search Console------------
select * from [dbo].[Search_Console_Report]
Select * from [dbo].[GA4_Engagement_Organic_Report]
-------------- Criando tabela engajamento site/e-commerce-----------------
CREATE TABLE Precavida_Engajamento (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Data DATE NOT NULL,
    pagina_entrada_usuario NVARCHAR(500) NOT NULL,
    impressao INT DEFAULT 0,
    sessao INT DEFAULT 0,
    sessao_engajada INT DEFAULT 0,
    taxa_engajamento DECIMAL(5,2) DEFAULT 0,
    page_views INT DEFAULT 0,
    clique INT DEFAULT 0,
    ctr DECIMAL(5,2) DEFAULT 0,
    conversao INT DEFAULT 0,
    data_criacao DATETIME DEFAULT GETDATE(),
    data_atualizacao DATETIME DEFAULT GETDATE()
);
------------------- Cruzando os dados dos relatórios--------------------------
SELECT COLUMN_NAME, DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Search_Console_Report' 
AND TABLE_SCHEMA = 'dbo'
ORDER BY ORDINAL_POSITION

SELECT COLUMN_NAME, DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'GA4_Engagement_Organic_Report' 
AND TABLE_SCHEMA = 'dbo'
ORDER BY ORDINAL_POSITION

SELECT 
    scr.*,
    ga.*
FROM [dbo].[Search_Console_Report] scr
INNER JOIN [GA4_Engagement_Organic_Report] ga 
    ON REPLACE(scr.[page], 'https://precavida.com.br', '') = ga.[page_path_and_screen_class]
WHERE scr.[page] LIKE 'https://precavida.com.br%'

SELECT 
    'Search_Console' as Fonte,
    [page] as URL
FROM [dbo].[Search_Console_Report]
GROUP BY [page]

UNION ALL

SELECT 
    'GA4_Engagement' as Fonte,
    [page_path_and_screen_class] as URL
FROM [GA4_Engagement_Organic_Report]
GROUP BY [page_path_and_screen_class]

ORDER BY Fonte, URL

------------ Inserindo dados Precavida_Engajamento--------------
INSERT INTO Precavida_Engajamento (
    Data,
    pagina_entrada_usuario,
    sessao,
    sessao_engajada,
    taxa_engajamento,
    conversao
)
SELECT 
    [date] as Data,
    [page_path_and_screen_class] as pagina_entrada_usuario,
    [sessions] as sessao,
    [engaged_sessions] as sessao_engajada,
    [engagement_rate] as taxa_engajamento,
    [conversions] as conversao
FROM [GA4_Engagement_Organic_Report]

Select * from [dbo].[Precavida_Engajamento]

-------------------- Cruzando dados Search Cnsole----------
SELECT DISTINCT [date]
FROM [GA4_Engagement_Organic_Report]
ORDER BY [date]

SELECT DISTINCT CAST([date] AS DATE) as Data
FROM [dbo].[Search_Console_Report]
ORDER BY Data

UPDATE pe
SET 
    pe.impressao = scr.impressions,
    pe.clique = scr.clicks,
    pe.ctr = scr.ctr,
    pe.data_atualizacao = GETDATE()
FROM Precavida_Engajamento pe
INNER JOIN (
    SELECT 
        CAST([date] AS DATE) as Data,
        REPLACE([page], 'https://precavida.com.br', '') as pagina,
        SUM(impressions) as impressions,
        SUM(clicks) as clicks,
        AVG(ctr) as ctr
    FROM [dbo].[Search_Console_Report]
    WHERE [page] LIKE 'https://precavida.com.br%'
    GROUP BY CAST([date] AS DATE), REPLACE([page], 'https://precavida.com.br', '')
) scr ON pe.Data = scr.Data AND pe.pagina_entrada_usuario = scr.pagina
WHERE pe.impressao = 0 OR pe.clique = 0 OR pe.ctr = 0


UPDATE pe
SET 
    pe.impressao = COALESCE(scr.impressions, 0),
    pe.clique = COALESCE(scr.clicks, 0),
    pe.ctr = COALESCE(scr.ctr, 0),
    pe.data_atualizacao = GETDATE()
FROM Precavida_Engajamento pe
OUTER APPLY (
    SELECT 
        SUM(impressions) as impressions,
        SUM(clicks) as clicks,
        AVG(ctr) as ctr
    FROM [dbo].[Search_Console_Report]
    WHERE CAST([date] AS DATE) = pe.Data
    AND (
        REPLACE([page], 'https://precavida.com.br', '') = pe.pagina_entrada_usuario
        OR REPLACE([page], 'https://precavida.com.br', '') LIKE '%' + pe.pagina_entrada_usuario + '%'
        OR pe.pagina_entrada_usuario LIKE '%' + REPLACE([page], 'https://precavida.com.br', '') + '%'
    )
) scr
WHERE pe.impressao = 0 AND pe.clique = 0 AND pe.ctr = 0


DELETE FROM Precavida_Engajamento
WHERE impressao = 0;

UPDATE pe
SET 
    pe.page_views = ga.[views],
    pe.data_atualizacao = GETDATE()
FROM Precavida_Engajamento pe
INNER JOIN [dbo].[GA4_Engagement_Organic_Report] ga 
    ON pe.Data = ga.[date] 
    AND pe.pagina_entrada_usuario = ga.[page_path_and_screen_class]
WHERE pe.page_views = 0 OR pe.page_views IS NULL


Select * from [dbo].[Precavida_Engajamento]
Select * from [dbo].[Precavida_Trafego]