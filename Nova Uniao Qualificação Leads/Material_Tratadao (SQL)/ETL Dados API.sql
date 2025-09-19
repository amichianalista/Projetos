---------------ETL dados via API/Python--------------
Select * from [dbo].[clientes_tratados]

----------- Verificando qualidade dos CPFs para ser o ID_Cliente---------------
SELECT 
    SUM(CASE WHEN CPF IS NULL THEN 1 ELSE 0 END) AS CPF_Nulos,
    SUM(CASE WHEN LTRIM(RTRIM(CPF)) = '' THEN 1 ELSE 0 END) AS CPF_Vazios,
    SUM(CASE WHEN CPF IS NOT NULL AND LTRIM(RTRIM(CPF)) != '' THEN 1 ELSE 0 END) AS CPF_Ok,
    COUNT(*) AS Total_Registros
FROM [dbo].[clientes_tratados];
----------------------- Criando Foreign Key ------------------------------
ALTER TABLE [dbo].[clientes_tratados]
ADD ID_Cliente_Novo VARCHAR(20) NULL;

UPDATE ct
SET ct.ID_Cliente_Novo = cnu.ID_Cliente
FROM [dbo].[clientes_tratados] ct
INNER JOIN [dbo].[Clientes_Nova_Uniao] cnu ON ct.Nome = cnu.Nome;