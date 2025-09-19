------ Venda media produtos
select * from [dbo].[sapatoestilo_tratados]
go

-----------Descobrindo Vendas/Data/Venda Média--------------------
------ Produtos/ Qntd Vendida /Data)-----------
SELECT 
    [ID_Produto]  AS Produto,
    [Produto] AS Produto,
    [Qtde Ven] AS Qtd_Vendida,
    [Ultima Venda] AS Data
FROM 
    [dbo].[sapatoestilo_tratados]
ORDER BY    
    [Ultima Venda] DESC;

----------Produtos Vendidos------------

CREATE TABLE Produtos_Vendidos (
    ID_Produto INT,
    Nome_Produto VARCHAR(100), 
    Grupo VARCHAR(100),
    SubGrupo VARCHAR(100),
    Quantidade_Vendida INT,
    Data_Venda DATE
);

INSERT INTO Produtos_Vendidos
SELECT 
    [ID_Produto],
    [Produto],
    [Grupo],
    [SubGrupo],
	[Qtde Ven],
    [Ultima Venda]   
    
FROM 
    [dbo].[sapatoestilo_tratados]
WHERE
   [Qtde Ven] > 0;

Select * from [dbo].[Produtos_Vendidos]

----------- Produtos do Estoque
SELECT 
    [ID_Produto],
    [Produto],
    MAX([Ultima Compra]) AS [Data_Ultima_Compra],
    SUM(CAST([Qtd Ent] AS INT)) AS [Quantidade_Comprada],
    MAX([Estoque Geral]) AS [Estoque_Atual],
    DATEDIFF(day, MAX([Ultima Compra]), GETDATE()) AS [Dias_Sem_Comprar]
FROM 
    [dbo].[sapatoestilo_tratados]
WHERE
    [Qtd Ent] IS NOT NULL
    
    AND [Ultima Compra] 
    
GROUP BY 
    [ID_Produto],
    [Produto]

ORDER BY 
    [Data_Ultima_Compra] ASC;


------------ tabela estoque
DROP TABLE Estoque
CREATE TABLE Estoque (
    ID_Produto INT,
    Nome_Produto VARCHAR(100), 
    Grupo VARCHAR(100),
    SubGrupo VARCHAR(100),
    Quantidade_Comprada INT,
    Estoque_Atual INT,  
    Data_Compra DATE
);
ALTER TABLE Estoque 
ALTER COLUMN [Estoque_Atual] VARCHAR(30)
 
INSERT INTO Estoque (
    ID_Produto, 
    Nome_Produto, 
    Grupo, 
    SubGrupo,
    Quantidade_Comprada,  
    Estoque_Atual,        
    Data_Compra           
)
SELECT 
    TRY_CAST([ID_Produto] AS INT),
    [Produto],
    [Grupo],
    [SubGrupo],
    TRY_CAST([Qtd Ent] AS INT),
    CAST([EstoqueGeral_Decimal] AS VARCHAR(30)),
    TRY_CAST([Ultima Compra] AS DATE)
FROM [dbo].[sapatoestilo_tratados]
WHERE TRY_CAST([ID_Produto] AS INT) IS NOT NULL
  AND TRY_CAST([EstoqueGeral_Decimal] AS DECIMAL(18,2)) > 0;  -- Filtra estoque > 0

DELETE FROM Estoque
WHERE TRY_CAST(Estoque_Atual AS DECIMAL(18,2)) <= 0;

--------------------