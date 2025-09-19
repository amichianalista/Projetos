use BDSTILLUS
-------------------
Pr
--------------------
SELECT 
    Nome_Produto,
    COUNT(*) AS Quantidade
FROM 
    [dbo].[bd_stillus]
GROUP BY 
    Nome_Produto
ORDER BY 
    Nome_Produto;
----------- Correção grafias incorretas
BEGIN TRANSACTION;

UPDATE [dbo].[bd_stillus]
SET Nome_Produto = CASE 
    WHEN Nome_Produto = 'ALL STAT' THEN 'ALL STAR'
    WHEN Nome_Produto = 'ALLSTAR' THEN 'ALL STAR'
    WHEN Nome_Produto = 'BLASER' THEN 'BLAZER'
    WHEN Nome_Produto = 'BLEUSA' THEN 'BLUSA'
    WHEN Nome_Produto = 'BLUSA PREGAS' THEN 'BLUSA PREGA'
    WHEN Nome_Produto = 'BORY' THEN 'BODY'
    WHEN Nome_Produto = 'CACHICOL' THEN 'CACHECOL'
    WHEN Nome_Produto = 'CALCA BOTT' THEN 'CALCA BOOT'
    WHEN Nome_Produto = 'CAMISERA' THEN 'CAMISA'
    WHEN Nome_Produto = 'CAMISETE' THEN 'CAMISA'
    WHEN Nome_Produto = 'CAMISTA' THEN 'CAMISA'
    WHEN Nome_Produto = 'CANECA GEL ATLETICIO' THEN 'CANECA GEL ATLETICO'
    WHEN Nome_Produto = 'CANECA URBANATLETICO' THEN 'CANECA URBAN ATLETICO'
    WHEN Nome_Produto = 'CANMISA' THEN 'CAMISA'
    WHEN Nome_Produto = 'CARDIGA' THEN 'CARDIGAN'
    WHEN Nome_Produto = 'CARTEIRAS' THEN 'CARTEIRA'
    WHEN Nome_Produto = 'CHEMISIER' THEN 'CHEMISE'
    WHEN Nome_Produto = 'CHAMISE' THEN 'CHEMISE'
    WHEN Nome_Produto = 'CIGARRET' THEN 'CIGARRETE'
    WHEN Nome_Produto = 'CIGARETE' THEN 'CIGARRETE'
    WHEN Nome_Produto = 'CROPD' THEN 'CROPPED'
    WHEN Nome_Produto = 'CROPED' THEN 'CROPPED'
    WHEN Nome_Produto = 'DISPAY' THEN 'DISPLAY'
    WHEN Nome_Produto = 'DISPLEY' THEN 'DISPLAY'
    WHEN Nome_Produto = 'DISLAY INCLINADO' THEN 'DISPLAY'
    WHEN Nome_Produto = 'GUARDA-CHUVA' THEN 'GUARDA CHUVA'
    WHEN Nome_Produto = 'HAIANAS' THEN 'HAVAIANAS'
    WHEN Nome_Produto = 'HAVAIANA' THEN 'HAVAIANAS'
    WHEN Nome_Produto = 'HAVAIANS' THEN 'HAVAIANAS'
    WHEN Nome_Produto = 'IMPRENSORA' THEN 'IMPRESSORA'
    WHEN Nome_Produto = 'SABDALIA' THEN 'SANDALIA'
    WHEN Nome_Produto = 'SACO DE METAL' THEN 'SACO METAL'
    WHEN Nome_Produto = 'SADALIA' THEN 'SANDALIA'
    WHEN Nome_Produto = 'SAPAILHA' THEN 'SAPATILHA'
    WHEN Nome_Produto = 'SAPATLHA' THEN 'SAPATILHA'
    WHEN Nome_Produto LIKE 'SAPATO%' THEN 'SAPATO' -- Para os casos com underscores e espaços
    WHEN Nome_Produto = 'SOBRE TUDO' THEN 'SOBRETUDO'
    WHEN Nome_Produto = 'SOBRINHA' THEN 'SOMBRINHA'
    WHEN Nome_Produto = 'SOMBRINHAA' THEN 'SOMBRINHA'
    WHEN Nome_Produto = 'TAMANCOP' THEN 'TAMANCO'
    WHEN Nome_Produto = 'T-SHIRT' THEN 'TSHIRT'
    WHEN Nome_Produto = 'T-SHIT' THEN 'TSHIRT'
    WHEN Nome_Produto = 'TSHORT' THEN 'TSHIRT'
    WHEN Nome_Produto = 'TSURT' THEN 'TSHIRT'
    WHEN Nome_Produto = 'VESIDO' THEN 'VESTIDO'
    WHEN Nome_Produto = 'VESTDO' THEN 'VESTIDO'
    WHEN Nome_Produto = 'VESTIDOP' THEN 'VESTIDO'
    WHEN Nome_Produto = 'VSTIDO' THEN 'VESTIDO'
    WHEN Nome_Produto = 'VESTIDOS' THEN 'VESTIDO'
    ELSE Nome_Produto
END
WHERE Nome_Produto IN (
    'ALL STAT', 'ALLSTAR', 'BLASER', 'BLEUSA', 'BLUSA PREGAS', 'BORY', 'CACHICOL', 
    'CALCA BOTT', 'CAMISERA', 'CAMISETE', 'CAMISTA', 'CANECA GEL ATLETICIO', 
    'CANECA URBANATLETICO', 'CANMISA', 'CARDIGA', 'CARTEIRAS', 'CHEMISIER', 
    'CHAMISE', 'CIGARRET', 'CIGARETE', 'CROPD', 'CROPED', 'DISPAY', 'DISPLEY', 
    'DISLAY INCLINADO', 'GUARDA-CHUVA', 'HAIANAS', 'HAVAIANA', 'HAVAIANS', 
    'IMPRENSORA', 'SABDALIA', 'SACO DE METAL', 'SADALIA', 'SAPAILHA', 'SAPATLHA', 
    'SOBRE TUDO', 'SOBRINHA', 'SOMBRINHAA', 'TAMANCOP', 'T-SHIRT', 'T-SHIT', 
    'TSHORT', 'TSURT', 'VESIDO', 'VESTDO', 'VESTIDOP', 'VSTIDO', 'VESTIDOS'
) OR Nome_Produto LIKE 'SAPATO%'

-------------Descobrindo Estoque inicial
ALTER TABLE [dbo].[bd_stillus]
ADD Pre_Estoque INT;

UPDATE [dbo].[bd_stillus]
SET Pre_Estoque = 
    (TRY_CONVERT(DECIMAL(18,2), [Estoque Geral]) + 
     TRY_CONVERT(DECIMAL(18,2), [Qtde Ven])) - 
    TRY_CONVERT(DECIMAL(18,2), [Qtd Ent]);
---------------------------------------------------
SELECT 
    Nome_Produto,
    [Estoque Geral],
    Pre_Estoque,
    [Qtde Ven],
    [Qtd Ent]
FROM 
    [dbo].[bd_stillus]
WHERE 
    [Estoque Geral] = 0
ORDER BY 
    Nome_Produto;
---------------------------------------------
ALTER TABLE [dbo].[bd_stillus]
DROP COLUMN Pre_Estoque;
-------------------------------------
SELECT 
    Nome_Produto,
    [Ultima Compra],  
    [Estoque Geral],
    [Qtde Ven],
    [Qtd Ent]
FROM 
    [dbo].[bd_stillus]
ORDER BY 
    [Ultima Compra] ASC;
-------------------------------------------
ALTER TABLE [dbo].[bd_stillus]
    ADD [Pre_Estoque] DECIMAL(18,2);
------------------------------------------
UPDATE [dbo].[bd_stillus]
    SET [Pre_Estoque] = 
        CASE 
            WHEN TRY_CONVERT(DECIMAL(18,2), [Estoque Geral]) IS NOT NULL 
                 AND TRY_CONVERT(DECIMAL(18,2), [Qtde Ven]) IS NOT NULL 
                 AND TRY_CONVERT(DECIMAL(18,2), [Qtd Ent]) IS NOT NULL
            THEN (TRY_CONVERT(DECIMAL(18,2), [Estoque Geral]) + 
                  TRY_CONVERT(DECIMAL(18,2), [Qtde Ven]) - 
                  TRY_CONVERT(DECIMAL(18,2), [Qtd Ent]))
            ELSE NULL
        END;
-----------------Criando Dim_Estoque------------
CREATE TABLE Dim_Estoque (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Referencia VARCHAR(50),
    Nome_Produto VARCHAR(100),
    ID_Grupo INT,
    Grupo VARCHAR(50),
    ID_SubGrupo INT,
    SubGrupo VARCHAR(50),
    ID_Cor INT,
    Cor VARCHAR(30),
    Ultima_Compra DATE,
    Ultima_Venda DATE,
    Entradas INT,
    Vendidos INT,
    Estoque_Final INT,
    Custo_Venda FLOAT,
    Valor_Venda FLOAT,
    Uni_Reposicao FLOAT,
    Uni_Venda FLOAT,
    ID_Unico INT

);
------------------------------------

ALTER TABLE Dim_Estoque ALTER COLUMN ID_Unico VARCHAR(50);
-------------------- Adicionando valores
INSERT INTO Dim_Estoque (
    Referencia,
    Nome_Produto,
    ID_Grupo,
    Grupo,
    ID_SubGrupo,
    SubGrupo,
    ID_Cor,
    Cor,
    Ultima_Compra,
    Ultima_Venda,
    Entradas,
    Vendidos,
    Estoque_Final,
    Custo_Venda,
    Valor_Venda,
    Uni_Reposicao,
    Uni_Venda,
    ID_Unico
)
SELECT 
    ID_Produto,
    Nome_Produto,
    ID_Grupo,
    Grupo,
    ID_SubGrupo,
    SubGrupo,
    ID_Cor,
    Cor,
    [Ultima Compra],
    [Ultima Venda],
    [Qtd Ent],
    [Qtde Ven],
    [Estoque geral],
    [Custo Venda],
    [Vr Venda],
    [Reposicao],
    [Pr Venda],
    ID_Unico
FROM 
    [dbo].[bd_stillus]
WHERE 
    [Estoque geral] > 0;
---------------------------------
SELECT * FROM [dbo].[Dim_Estoque]