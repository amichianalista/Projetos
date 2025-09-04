select * from [dbo].[ZyntrixTratada]
------------------------------------------------
SELECT 
    [Empresa],
    COUNT(DISTINCT [Pa�s Sede]) AS QuantidadePaises,
    STRING_AGG([Pa�s Sede], ', ') AS PaisesPresentes
FROM 
    [dbo].[ZyntrixTratada]
GROUP BY 
    [Empresa]
HAVING 
    COUNT(DISTINCT [Pa�s Sede] ) > 1
ORDER BY 
    QuantidadePaises DESC;
------------------------------------------------------------
SELECT 
    COUNT(DISTINCT [Empresa]) AS TotalEmpresasDistintas
FROM 
    [dbo].[ZyntrixTratada];
-----------------------------------------------------------------
CREATE TABLE Startups_Pa�s (
    PaisSede NVARCHAR(100),
    QuantidadeEmpresas INT,
    ValorTotalMercado DECIMAL(18, 2)
);
-------------------------------------------------------------
INSERT INTO Startups_Pa�s (PaisSede, QuantidadeEmpresas, ValorTotalMercado)
SELECT 
    [Pa�s Sede] AS PaisSede,
    COUNT(DISTINCT [Empresa]) AS QuantidadeEmpresas,
    SUM(CAST([Valor de Mercado_Bilh�es] AS DECIMAL(18, 2))) AS ValorTotalMercado
FROM 
    [dbo].[ZyntrixTratada]
GROUP BY 
    [Pa�s Sede]
ORDER BY 
    ValorTotalMercado DESC;
-------------------------------------------------------
Select * from [dbo].[Startups_Pa�s]
---------------------------------------------------
ALTER TABLE [dbo].[Startups_Pa�s]
ADD ValorMedioMercado DECIMAL(18, 2);
-------------------------------------------------------
UPDATE e
SET e.ValorMedioMercado = subquery.ValorMedio
FROM [dbo].[Startups_Pa�s] e
INNER JOIN (
    SELECT 
       [Pa�s Sede]  AS PaisSede,
        AVG(CAST([Valor de Mercado_Bilh�es] AS DECIMAL(18, 2))) AS ValorMedio
    FROM 
        [dbo].[ZyntrixTratada]
    GROUP BY 
        [Pa�s Sede]
) subquery ON e.PaisSede = subquery.PaisSede;