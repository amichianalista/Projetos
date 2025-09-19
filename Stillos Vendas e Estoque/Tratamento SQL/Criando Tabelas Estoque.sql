use BDSTILLUS
go

select * from [dbo].[estoque_produtos]
go

EXEC sp_rename 'dim_estoque', 'estoque_produtos';

SELECT 
    [Referencia],
    [Nome_Produto],
    [Ultima_Compra],
    [Entradas],
    [Vendidos],
    [Estoque_Final],
    [status_consistencia]
FROM 
    [dbo].[Dim_Estoque]
ORDER BY 
   [Ultima_Compra] ASC;
----------------------
ALTER TABLE dim_estoque ADD status_consistencia CHAR(1)
go
-------------------------- Descobrindo inconsistencias 
UPDATE dim_estoque
SET status_consistencia = 
    CASE 
        WHEN (entradas - vendidos) = estoque_final THEN 'S'
        ELSE 'N'
    END
go
----------------------------------------
SELECT 
    COALESCE(status_consistencia, 'Sem status') AS status,
    COUNT(*) AS total
FROM 
    dim_estoque
GROUP BY 
    status_consistencia;
---------------------------------------
SELECT 
    [Referencia],
    [Nome_Produto],
    [Ultima_Compra],
    [Entradas],
    [Vendidos],
    [Estoque_Final],
    [status_consistencia]
FROM 
    [dbo].[Dim_Estoque]
WHERE 
    [status_consistencia] = 'N'
ORDER BY 
    [Ultima_Compra] ASC;
--------------------Criando coluna Rotatividade
ALTER TABLE [dbo].[Dim_Estoque]
ADD Rotatividade FLOAT
GO

UPDATE [dbo].[Dim_Estoque]
SET [Rotatividade] = 
    CASE 
        WHEN [Vendidos] = 0 THEN NULL 
        ELSE CAST(DATEDIFF(DAY,[Ultima_Compra],[Ultima_Venda] ) AS FLOAT) / [Vendidos]
    END;

ALTER TABLE [dbo].[Dim_Estoque]
ALTER COLUMN Rotatividade DECIMAL(10, 2);

-------------------------------------------
SELECT 
    ID_Unico,
    Ultima_Compra,
    Ultima_Venda,
    DATEDIFF(DAY, Ultima_Compra, Ultima_Venda) AS Dias_Entre_Compra_Venda,
    Entradas,
    Vendidos,
    Estoque_Final,
    [Rotatividade],
    Custo_Venda,
    Valor_Venda,
    Uni_Reposicao,
    Uni_Venda,
    [status_consistencia],
    CASE
        WHEN Rotatividade < 0 THEN 'DATA INCONSISTENTE (Compra após venda)'
        WHEN Rotatividade > 100 THEN 'OUTLIER EXTREMO (>100 dias/unidade)'
        WHEN Vendidos = 0 THEN 'PRODUTO NÃO VENDIDO'
        WHEN Ultima_Compra > Ultima_Venda THEN 'DATA COMPRA POSTERIOR À VENDA'
        ELSE 'OUTRO TIPO DE ANOMALIA'
    END AS Tipo_Problema
FROM [dbo].[Dim_Estoque]
WHERE 
    Rotatividade IS NULL OR
    Rotatividade > 100 OR 
    Rotatividade < 0 OR
    Vendidos = 0 OR
    Ultima_Compra > Ultima_Venda
ORDER BY
    CASE
        WHEN Rotatividade IS NULL THEN 1
        WHEN Rotatividade < 0 THEN 2
        WHEN Rotatividade > 100 THEN 3
        ELSE 4
    END,
    ABS(Rotatividade) DESC;

-------------------------------Margem de Lucro
 ALTER TABLE [dbo].[Dim_Estoque] 
 ADD Margem_Lucro DECIMAL(10, 2)
 GO
----------
UPDATE [dbo].[Dim_Estoque]
SET [Margem_Lucro] = CASE 
                    WHEN Custo_Venda = 0 THEN 0 
                    ELSE ((Valor_Venda - Custo_Venda) / Custo_Venda) * 100 
                   END;
--------------------------------------
CREATE TABLE estoque_grupo (
    ID_Grupo INT PRIMARY KEY,
    Grupo VARCHAR(50) NOT NULL,
    Quantidade_Produtos INT NOT NULL,
    Total_Entradas INT NOT NULL,
    Total_Vendidos INT NOT NULL,
    Estoque_Total INT NOT NULL,
    Custo_Venda_Total FLOAT NOT NULL,
    Valor_Venda_Total FLOAT NOT NULL,
    Media_Rotatividade FLOAT NOT NULL,
    Data_Ultima_Compra DATE NULL,
    Data_Ultima_Venda DATE NULL
);
-------------------------
INSERT INTO estoque_grupo
SELECT 
    ID_Grupo,
    Grupo,
    COUNT(*) AS Quantidade_Produtos,
    SUM(Entradas) AS Total_Entradas,
    SUM(Vendidos) AS Total_Vendidos,
    SUM(Estoque_Final) AS Estoque_Total,
    SUM(Custo_Venda) AS Custo_Venda_Total,
    SUM(Valor_Venda) AS Valor_Venda_Total,
    AVG(Rotatividade) AS Media_Rotatividade,
    MAX(Ultima_Compra) AS Data_Ultima_Compra,
    MAX(Ultima_Venda) AS Data_Ultima_Venda
FROM 
    [dbo].[estoque_produtos]
GROUP BY 
    ID_Grupo, Grupo;


select * from [dbo].[estoque_grupo]

ALTER TABLE estoque_grupo
DROP COLUMN Media_Rotatividade

------------------------------------------
ALTER TABLE estoque_grupo
ADD Rotatividade_Grupo FLOAT NULL;
----------------------------------------
UPDATE estoque_grupo
SET Rotatividade_Grupo = 
    CASE 
        WHEN Estoque_Total > 0 THEN Total_Vendidos / CAST(Estoque_Total AS FLOAT)
        ELSE 0 
    END;
---------------------
ALTER TABLE estoque_grupo
ALTER COLUMN Rotatividade_Grupo DECIMAL(10,2);