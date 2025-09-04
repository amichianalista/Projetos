select * from [dbo].[ZyntrixTratada]
------------------------------------------------
SELECT 
    [Empresa],
    COUNT(DISTINCT [País Sede]) AS QuantidadePaises,
    STRING_AGG([País Sede], ', ') AS PaisesPresentes
FROM 
    [dbo].[ZyntrixTratada]
GROUP BY 
    [Empresa]
HAVING 
    COUNT(DISTINCT [País Sede] ) > 1
ORDER BY 
    QuantidadePaises DESC;
------------------------------------------------------------
SELECT 
    COUNT(DISTINCT [Empresa]) AS TotalEmpresasDistintas
FROM 
    [dbo].[ZyntrixTratada];
-----------------------------------------------------------------
CREATE TABLE Startups_País (
    PaisSede NVARCHAR(100),
    QuantidadeEmpresas INT,
    ValorTotalMercado DECIMAL(18, 2)
);
-------------------------------------------------------------
INSERT INTO Startups_País (PaisSede, QuantidadeEmpresas, ValorTotalMercado)
SELECT 
    [País Sede] AS PaisSede,
    COUNT(DISTINCT [Empresa]) AS QuantidadeEmpresas,
    SUM(CAST([Valor de Mercado_Bilhões] AS DECIMAL(18, 2))) AS ValorTotalMercado
FROM 
    [dbo].[ZyntrixTratada]
GROUP BY 
    [País Sede]
ORDER BY 
    ValorTotalMercado DESC;
-------------------------------------------------------
Select * from [dbo].[Startups_País]
---------------------------------------------------
ALTER TABLE [dbo].[Startups_País]
ADD ValorMedioMercado DECIMAL(18, 2);
-------------------------------------------------------
UPDATE e
SET e.ValorMedioMercado = subquery.ValorMedio
FROM [dbo].[Startups_País] e
INNER JOIN (
    SELECT 
       [País Sede]  AS PaisSede,
        AVG(CAST([Valor de Mercado_Bilhões] AS DECIMAL(18, 2))) AS ValorMedio
    FROM 
        [dbo].[ZyntrixTratada]
    GROUP BY 
        [País Sede]
) subquery ON e.PaisSede = subquery.PaisSede;