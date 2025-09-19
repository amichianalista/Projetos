-------- Processamento de Dados Visão Macro -------------------------
SELECT 
    date,
    first_user_default_channel_group as channel_group,  
    users,
    sessions,
    conversions,
    total_revenue,
    engagement_rate,
    average_engagement_time_per_session as avg_engagement_time,   
    CASE 
        WHEN first_user_default_channel_group IN ('Organic Search', 'Direct') THEN 'Organic'
        WHEN first_user_default_channel_group IN ('Paid Search', 'Display') THEN 'Paid'
        WHEN first_user_default_channel_group IN ('Social', 'Email', 'Referral') THEN 'Owned'
        ELSE 'Other'
    END as channel_category
    
FROM GA4_Acquisition_Report
WHERE date IS NOT NULL;
---------------- Criando tabela Precavida_organico------------------
CREATE TABLE Precavida_Organico (
    id INT IDENTITY(1,1) PRIMARY KEY,
    data DATE NOT NULL,
    canal_grupo NVARCHAR(100) NOT NULL,
    canal_categoria NVARCHAR(50) NOT NULL,
    usuarios INT DEFAULT 0,
    sessoes INT DEFAULT 0,
    conversoes INT DEFAULT 0,
    receita_total DECIMAL(15,2) DEFAULT 0,
    taxa_engajamento DECIMAL(10,4) DEFAULT 0,
    tempo_medio_engajamento INT DEFAULT 0,
    data_criacao DATETIME DEFAULT GETDATE(),
    data_atualizacao DATETIME DEFAULT GETDATE()
);

------------------ Inserindo dados--------------------------
INSERT INTO Precavida_Organico (
    data,
    canal_grupo, 
    canal_categoria,
    usuarios,
    sessoes, 
    conversoes,
    receita_total,
    taxa_engajamento,
    tempo_medio_engajamento
)
SELECT 
    date as data,
    first_user_default_channel_group as canal_grupo,
    CASE 
        WHEN first_user_default_channel_group IN ('Organic Search', 'Direct') THEN 'Organico'
        WHEN first_user_default_channel_group IN ('Paid Search', 'Display') THEN 'Pago'
        WHEN first_user_default_channel_group IN ('Social', 'Email', 'Referral') THEN 'Próprio'
        ELSE 'Outro'
    END as canal_categoria,
    users as usuarios,
    sessions as sessoes,
    conversions as conversoes,
    total_revenue as receita_total,
    engagement_rate as taxa_engajamento,
    average_engagement_time_per_session as tempo_medio_engajamento
FROM GA4_Acquisition_Report
WHERE date IS NOT NULL;

Select * from [dbo].[Precavida_Organico]
Select * from [dbo].[GA4_Acquisition_Report]

-------------- Transformações de dados em KPI's e Indicadores---------------
ALTER TABLE Precavida_Organico
ADD 
    taxa_conversao DECIMAL(10,4) DEFAULT 0,
    valor_medio_usuario DECIMAL(10,2) DEFAULT 0,
    frequencia_visita DECIMAL(10,2) DEFAULT 0;

UPDATE Precavida_Organico 
SET 
    taxa_conversao = CASE 
        WHEN sessoes > 0 THEN CAST(conversoes AS DECIMAL) / sessoes 
        ELSE 0 
    END,
    
    valor_medio_usuario = CASE 
        WHEN usuarios > 0 THEN receita_total / usuarios 
        ELSE 0 
    END,
    
    frequencia_visita = CASE 
        WHEN usuarios > 0 THEN CAST(sessoes AS DECIMAL) / usuarios 
        ELSE 0 
    END,
    
    data_atualizacao = GETDATE();

SELECT 
    AVG(taxa_conversao) * 100 as taxa_conversao_media_percentual,
    AVG(valor_medio_usuario) as valor_medio_usuario_medio,
    AVG(frequencia_visita) as frequencia_visita_media,
    MIN(data_atualizacao) as ultima_atualizacao
FROM Precavida_Organico;

EXEC sp_rename 'Precavida_Organico', 'Precavida_Trafego';

