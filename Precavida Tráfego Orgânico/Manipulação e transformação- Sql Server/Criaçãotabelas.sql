Select * from MKT_GOOGLE
Select * from MKT_SEMRUSH
Select * from MKT_PALAVRA_CHAVE

-------------------------- Criação das tabelas finais-------------------------

------- Diagnóstico (Google Analytics)-----------------------------------------

CREATE TABLE MKT_GOOGLE (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    DataRegistro DATETIME DEFAULT GETDATE(),
    Sessoes_Organicas INT,
    Usuarios_Organicos INT,
    Taxa_Rejeicao DECIMAL(5,2), 
    Duracao_Media_Sessao TIME,
    Pageviews_Por_Sessao DECIMAL(5,2),
    Taxa_Conversao DECIMAL(5,2),
    Taxa_Cliques_CTR_Organico DECIMAL(5,2), 
    Paginas_Destino NVARCHAR(500),
    Palavras_Chave_Queries NVARCHAR(500)
);

------------- Sem rush diagnóstico----------------------------------------

CREATE TABLE MKT_SEMRUSH (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    ID_Empresa INT NOT NULL,
    Nome_Empresa NVARCHAR(255) NOT NULL,
    Taxa_Clique_Volume_Acesso DECIMAL(10,2),
    Taxa_Acesso_Organico_Search_Console DECIMAL(5,2), 
    Posicao_Rank_Empresas INT,
    Data_Registro DATETIME DEFAULT GETDATE(),
    

    CONSTRAINT CHK_Taxa_Acesso_Organico CHECK (Taxa_Acesso_Organico_Search_Console >= 0 AND Taxa_Acesso_Organico_Search_Console <= 100),
    CONSTRAINT CHK_Posicao_Rank CHECK (Posicao_Rank_Empresas > 0)
);

---------------- Sem Rush Palavras Chave-------------------------------
CREATE TABLE MKT_Palavra_Chave (
    ID_PC INT IDENTITY(1,1) PRIMARY KEY,
    Palavra_Chave NVARCHAR(500) NOT NULL,
    Intencao_Busca NVARCHAR(100),
    Fase_Funil NVARCHAR(50),
    Visibilidade_Pagina DECIMAL(5,2),
    Numero_Palavras_Chave INT,
    CTR_Custo_Clique DECIMAL(10,2),
    SERP_Features NVARCHAR(500),
    Taxa_Rejeicao DECIMAL(5,2),
    Concorrentes_Atuais NVARCHAR(1000),
    URL NVARCHAR(500),
    Status NVARCHAR(50) DEFAULT 'Ativa',
    Posicao_Atual INT,
    Data_Verificacao DATE DEFAULT GETDATE(),
    FK_Site INT NOT NULL,
    Duracao_Media_Sessao_Segundos INT, -- Duração em segundos
    ROI DECIMAL(10,2),
    

    CONSTRAINT CHK_Visibilidade_Pagina CHECK (Visibilidade_Pagina >= 0 AND Visibilidade_Pagina <= 100),
    CONSTRAINT CHK_Taxa_Rejeicao CHECK (Taxa_Rejeicao >= 0 AND Taxa_Rejeicao <= 100),
    CONSTRAINT CHK_Posicao_Atual CHECK (Posicao_Atual >= 0),
    CONSTRAINT CHK_Status CHECK (Status IN ('Ativa', 'Inativa', 'Pausada', 'Monitorando'))
);
