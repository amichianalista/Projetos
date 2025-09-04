Select * FROM [dbo].[ZyntrixTratada]
------------------------------------------------------------
SELECT DISTINCT [Mercado de atua��o]
FROM [dbo].[ZyntrixTratada]
ORDER BY [Mercado de atua��o]
----------------------------------------------
UPDATE [dbo].[ZyntrixTratada]
SET [Mercado de atua��o] = 'Investimentos'
WHERE [Mercado de atua��o] LIKE '%Tiger Global Management%'
   OR [Mercado de atua��o] LIKE '%Tiger Brokers%'
   OR [Mercado de atua��o] LIKE '%DCM Ventures%'
   OR [Mercado de atua��o] LIKE '%Temasek%'
   OR [Mercado de atua��o] LIKE '%Guggenheim Investments%'
   OR [Mercado de atua��o] LIKE '%Qatar Investment Authority%'
   OR [Mercado de atua��o] LIKE '%Accel%'
   OR [Mercado de atua��o] LIKE '%Venture Highway%'
   OR [Mercado de atua��o] LIKE '%Hopu Investment Management%'
   OR [Mercado de atua��o] LIKE '%Boyu Capital%'
   OR [Mercado de atua��o] LIKE '%DC Thomson Ventures%'
   OR [Mercado de atua��o] LIKE '%GIC%'
   OR [Mercado de atua��o] LIKE '%Apis Partners%'
   OR [Mercado de atua��o] LIKE '%Insight Partners%'
   OR [Mercado de atua��o] LIKE '%B Capital Group%'
   OR [Mercado de atua��o] LIKE '%Monk''s Hill Ventures%' 
   OR [Mercado de atua��o] LIKE '%Dynamic Parcel Distribution%'
   OR [Mercado de atua��o] LIKE '%500 Global%'
   OR [Mercado de atua��o] LIKE '%Rakuten Ventures%' 
   OR [Mercado de atua��o] LIKE '%Golden Gate Ventures%';

-- Atualizar para "Capital de Risco"
UPDATE [dbo].[ZyntrixTratada]
SET [Mercado de atua��o] = 'Capital de Risco'
WHERE [Mercado de atua��o] LIKE '%Vision Plus Capital%'
   OR [Mercado de atua��o] LIKE '%GSR Ventures%'
   OR [Mercado de atua��o] LIKE '%ZhenFund%'
   OR [Mercado de atua��o] LIKE '%Vertex Ventures%'
   OR [Mercado de atua��o] LIKE '%Global Founders Capital%'
   OR [Mercado de atua��o] LIKE '%Visa Ventures%'
   OR [Mercado de atua��o] LIKE '%SingTel Innov8%'
   OR [Mercado de atua��o] LIKE '%Alpha JWC Ventures%'
   OR [Mercado de atua��o] LIKE '%Sequoia Capital%'
   OR [Mercado de atua��o] LIKE '%Thoma Bravo%'
   OR [Mercado de atua��o] LIKE '%Softbank%'
   OR [Mercado de atua��o] LIKE '%Sequoia Capital China%'
   OR [Mercado de atua��o] LIKE '%Shunwei Capital Partners%'
   OR [Mercado de atua��o] LIKE '%Qualgro%'
   OR [Mercado de atua��o] LIKE '%ING%'
   OR [Mercado de atua��o] LIKE '%Alibaba Entrepreneurs Fund%'
   OR [Mercado de atua��o] LIKE '%Mundi Ventures%'
   OR [Mercado de atua��o] LIKE '%Doqling Capital Partners%'
   OR [Mercado de atua��o]LIKE '%Activant Capital%'
   OR [Mercado de atua��o] LIKE '%Andreessen Horowitz%'
   OR [Mercado de atua��o] LIKE '%IDG Capital%'
   OR [Mercado de atua��o] LIKE '%DST Global%';

-----------------------------------------
UPDATE [dbo].[ZyntrixTratada]
SET [Mercado de atua��o] = 'Telecomunica��es e Mobilidade'
WHERE[Mercado de atua��o] LIKE '%Telecomunicações e mobilidade%'

----------------------------------------------------


