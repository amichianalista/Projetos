Use BDSTILLUS

sELECT * FROM [dbo].[estoque_produtos]



ALTER TABLE [dbo].[MinhasVendas]
ADD NovoEstoque INT NULL; 

UPDATE v
SET v.[NovoEstoque] = s.[Estoque Geral]
FROM dbo.MinhasVendas v
INNER JOIN dbo.bd_stillus s ON v.ID_Unico = CAST(s.[ID_Unico] AS VARCHAR(100));
---------------------------------------------
