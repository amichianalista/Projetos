use BDSTILLUS
go

select * from dbo.bd_stillus
go
-------- Criando db_Vendas-------------
CREATE TABLE MinhasVendas (
    ID_Unico VARCHAR (50),  
    Referencia VARCHAR(50),
    [Nome Produto] VARCHAR(100),
    id_grupo INT,
    grupo VARCHAR(50),
    id_subgrupo INT,
    subgrupo VARCHAR(50),
    id_cor INT,
    cor VARCHAR(50),
    [Ultima compra] DATE,
    [Ultima Venda] DATE,
    [Quantidade vendida] INT CHECK ([Quantidade vendida] > 0),
    [Valor vendido] VARCHAR (100)
);

--------------------iNSERINDO vALORES----------

INSERT INTO MinhasVendas (
    ID_Unico,
    Referencia,
    [Nome Produto],
    id_grupo,
    grupo,
    id_subgrupo,
    subgrupo,
    id_cor,
    cor,
    [Ultima compra],
    [Ultima Venda],
    [Quantidade vendida],
    [Valor vendido]
)
SELECT 
    p.ID_Unico,
    p.[ID_Produto],
    p.[Nome_Produto] AS [Nome Produto],
    p.id_grupo,
    p.grupo,  
    p.id_subgrupo,
    p.subgrupo,  
    p.id_cor,
    p.cor,  
    p.[Ultima Compra] AS [Ultima compra],
    p.[Ultima Venda] AS [Ultima Venda],
    p.[Qtde Ven] AS [Quantidade vendida],
    p.[Valor_Venda] AS [Valor vendido]
FROM 
    [dbo].[bd_stillus] p
WHERE 
    p.[Qtde Ven] > 0;

--------------------
select * from [dbo].[MinhasVendas]
go