Select * from [dbo].[Clientes_Nova_Uniao]
---- Criando Tabela de Leads-------------
CREATE TABLE Clientes_Nova_Uniao (
    ID_Cliente VARCHAR(20) PRIMARY KEY,
    Nome NVARCHAR(100) NOT NULL,
    Idade INT NULL,
    Cidade NVARCHAR(100) NULL,
    EMail NVARCHAR(150) NULL,
    Telefone NVARCHAR(20) NULL,
    DataCadastro DATETIME DEFAULT GETDATE()
);

---------------Adicionado os CPFS/ NOme como ID_Cliente-------------------
INSERT INTO Clientes_Nova_Uniao (ID_Cliente, Nome)
SELECT 
    'CLI-' + RIGHT('0000' + CAST(ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS VARCHAR(10)), 4),
    Nome
FROM [dbo].[clientes_tratados];

-------------------Adicionando Cidade -------------------------------
UPDATE cnu
SET cnu.Cidade = ct.Cidade
FROM [dbo].[Clientes_Nova_Uniao] cnu
INNER JOIN [dbo].[clientes_tratados] ct ON cnu.ID_Cliente = ct.ID_Cliente_Novo;