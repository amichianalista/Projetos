Select * from [dbo].[Clientes_Nova_Uniao]
------------- Tratando cadastros---------------------------------
SELECT 
    COUNT(CASE WHEN [Telefone 1] IS NULL THEN 1 END) AS Quantidade_Nulos
FROM [dbo].[Clientes_Nova_Uniao];

SELECT 
    COUNT(CASE WHEN [Email] IS NULL THEN 1 END) AS Quantidade_Nulos
FROM [dbo].[Clientes_Nova_Uniao];


SELECT *
FROM [dbo].[Clientes_Nova_Uniao]
WHERE Email IS NULL OR [Telefone 1] IS NULL;

DELETE FROM [dbo].[Clientes_Nova_Uniao]
WHERE Email IS NULL OR [Telefone 1] IS NULL;
--------------------Coluna Idade Inconsistências corrigidas------------
SELECT AVG(CAST(Idade AS FLOAT)) AS Media_Idade
FROM [dbo].[Clientes_Nova_Uniao]
WHERE Idade IS NOT NULL;


UPDATE [dbo].[Clientes_Nova_Uniao]
SET Idade = (
    SELECT AVG(CAST(Idade AS FLOAT)) 
    FROM [dbo].[Clientes_Nova_Uniao] 
    WHERE Idade IS NOT NULL
)
WHERE Idade < 18;

-------------- Qualificando os clientes-----------------------
SELECT 
    MIN([Idade]) AS Valor_Minimo,
    MAX([Idade]) AS Valor_Maximo
FROM [dbo].[Clientes_Nova_Uniao];


SELECT TOP 30
    [Idade]
FROM [dbo].[Clientes_Nova_Uniao]
ORDER BY [Idade] DESC;
------------------------ Classificação Idade----------------------
ALTER TABLE [dbo].[Clientes_Nova_Uniao]
ADD [Faixa_Etaria] VARCHAR(20);

UPDATE [dbo].[Clientes_Nova_Uniao]
SET [Faixa_Etaria] = CASE 
    WHEN [Idade] < 18 THEN 'Menor de 18'
    WHEN [Idade] BETWEEN 18 AND 24 THEN '18-24'
    WHEN [Idade] BETWEEN 25 AND 34 THEN '25-34'
    WHEN [Idade] BETWEEN 35 AND 44 THEN '35-44'
    WHEN [Idade] BETWEEN 45 AND 59 THEN '45-59'
    WHEN [Idade] BETWEEN 60 AND 80 THEN '60-80'
    ELSE 'Acima de 80'
END;
------------------------ Classificação Localização----------------
SELECT 
    COUNT(DISTINCT [Cidade]) AS Quantidade_Cidades_Distintas
FROM [dbo].[Clientes_Nova_Uniao];

SELECT DISTINCT [Cidade], [UF]
FROM [dbo].[Clientes_Nova_Uniao]
ORDER BY [Cidade];

ALTER TABLE [dbo].[Clientes_Nova_Uniao]
ADD [UF] NVARCHAR(50) NULL;

UPDATE c
SET c.[UF] = e.[uf]
FROM [dbo].[Clientes_Nova_Uniao] c
INNER JOIN  [dbo].[clientes_tratados] e  ON c.[ID_Cliente] = e.[ID_Cliente_Novo];


ALTER TABLE [dbo].[Clientes_Nova_Uniao]
ADD [Regiao] VARCHAR(20) NULL;

UPDATE [dbo].[Clientes_Nova_Uniao]
SET [Regiao] = CASE 
    WHEN [UF] IN ('RS', 'SC', 'PR') THEN 'Sul'
    WHEN [UF] IN ('SP', 'RJ', 'MG', 'ES') THEN 'Sudeste'
    WHEN [UF] IN ('DF', 'GO', 'MT', 'MS') THEN 'Centro-Oeste'
    WHEN [UF] IN ('BA', 'SE', 'AL', 'PE', 'PB', 'RN', 'CE', 'PI', 'MA') THEN 'Nordeste'
    WHEN [UF] IN ('AM', 'PA', 'AC', 'RO', 'RR', 'AP', 'TO') THEN 'Norte'
    ELSE NULL
END;

---------------- Classificando por tempo como cliente-----------------
SELECT 
    [ID_Cliente],
    [Nome],
    [Primeira Compra],
    [Ultima Compra],
    DATEDIFF(MONTH, [Primeira Compra], [Ultima Compra]) AS Meses_Como_Cliente
FROM [dbo].[Clientes_Nova_Uniao]
ORDER BY Meses_Como_Cliente DESC;

ALTER TABLE [dbo].[Clientes_Nova_Uniao]
ADD [Tempo_Cliente] INT NULL;

UPDATE [dbo].[Clientes_Nova_Uniao]
SET [Tempo_Cliente] = DATEDIFF(MONTH, [Primeira Compra], [Ultima Compra]);

SELECT 
    [ID_Cliente],
    [Nome],
    [Primeira Compra],
    [Ultima Compra],
    DATEDIFF(MONTH, [Primeira Compra], [Ultima Compra]) AS Meses_Como_Cliente,
    CASE 
        WHEN DATEDIFF(MONTH, [Primeira Compra], [Ultima Compra]) >= 426 THEN 'Categoria 5'
        WHEN DATEDIFF(MONTH, [Primeira Compra], [Ultima Compra]) BETWEEN 319 AND 425 THEN 'Categoria 4'
        WHEN DATEDIFF(MONTH, [Primeira Compra], [Ultima Compra]) BETWEEN 213 AND 318 THEN 'Categoria 3'
        WHEN DATEDIFF(MONTH, [Primeira Compra], [Ultima Compra]) BETWEEN 107 AND 212 THEN 'Categoria 2'
        ELSE 'Categoria 1'
    END AS Categoria
FROM [dbo].[Clientes_Nova_Uniao]
ORDER BY Meses_Como_Cliente DESC;


------------------------------Classificando frequencia de compras-------------------
ALTER TABLE [dbo].[Clientes_Nova_Uniao]
ADD [Frequencia_Compras] DECIMAL(10,2) NULL;

UPDATE c
SET c.[Frequencia_Compras] = 
    CASE 
        WHEN o.[Nro_Compras] > 0 
            THEN CAST(DATEDIFF(MONTH, c.[Primeira Compra], c.[Ultima Compra]) AS DECIMAL(10,2)) / o.[Nro_Compras]
        ELSE NULL
    END
FROM [dbo].[Clientes_Nova_Uniao] c
INNER JOIN [dbo].[clientes_tratados] o ON c.[ID_Cliente] = o.[ID_Cliente_Novo];

------------------Classificação por Recência, Ultima Compra--------------

ALTER TABLE [dbo].[Clientes_Nova_Uniao]
ADD [Recencia] INT NULL;

UPDATE [dbo].[Clientes_Nova_Uniao]
SET [Recencia] = DATEDIFF(MONTH, [Ultima Compra], GETDATE());

