Select * FROM [dbo].[ZyntrixTratada]
------------------------------------------------------------
SELECT DISTINCT [Mercado de atuação]
FROM [dbo].[ZyntrixTratada]
ORDER BY [Mercado de atuação]
----------------------------------------------
UPDATE [dbo].[ZyntrixTratada]
SET [Mercado de atuação] = 'Investimentos'
WHERE [Mercado de atuação] LIKE '%Tiger Global Management%'
   OR [Mercado de atuação] LIKE '%Tiger Brokers%'
   OR [Mercado de atuação] LIKE '%DCM Ventures%'
   OR [Mercado de atuação] LIKE '%Temasek%'
   OR [Mercado de atuação] LIKE '%Guggenheim Investments%'
   OR [Mercado de atuação] LIKE '%Qatar Investment Authority%'
   OR [Mercado de atuação] LIKE '%Accel%'
   OR [Mercado de atuação] LIKE '%Venture Highway%'
   OR [Mercado de atuação] LIKE '%Hopu Investment Management%'
   OR [Mercado de atuação] LIKE '%Boyu Capital%'
   OR [Mercado de atuação] LIKE '%DC Thomson Ventures%'
   OR [Mercado de atuação] LIKE '%GIC%'
   OR [Mercado de atuação] LIKE '%Apis Partners%'
   OR [Mercado de atuação] LIKE '%Insight Partners%'
   OR [Mercado de atuação] LIKE '%B Capital Group%'
   OR [Mercado de atuação] LIKE '%Monk''s Hill Ventures%' 
   OR [Mercado de atuação] LIKE '%Dynamic Parcel Distribution%'
   OR [Mercado de atuação] LIKE '%500 Global%'
   OR [Mercado de atuação] LIKE '%Rakuten Ventures%' 
   OR [Mercado de atuação] LIKE '%Golden Gate Ventures%';

-- Atualizar para "Capital de Risco"
UPDATE [dbo].[ZyntrixTratada]
SET [Mercado de atuação] = 'Capital de Risco'
WHERE [Mercado de atuação] LIKE '%Vision Plus Capital%'
   OR [Mercado de atuação] LIKE '%GSR Ventures%'
   OR [Mercado de atuação] LIKE '%ZhenFund%'
   OR [Mercado de atuação] LIKE '%Vertex Ventures%'
   OR [Mercado de atuação] LIKE '%Global Founders Capital%'
   OR [Mercado de atuação] LIKE '%Visa Ventures%'
   OR [Mercado de atuação] LIKE '%SingTel Innov8%'
   OR [Mercado de atuação] LIKE '%Alpha JWC Ventures%'
   OR [Mercado de atuação] LIKE '%Sequoia Capital%'
   OR [Mercado de atuação] LIKE '%Thoma Bravo%'
   OR [Mercado de atuação] LIKE '%Softbank%'
   OR [Mercado de atuação] LIKE '%Sequoia Capital China%'
   OR [Mercado de atuação] LIKE '%Shunwei Capital Partners%'
   OR [Mercado de atuação] LIKE '%Qualgro%'
   OR [Mercado de atuação] LIKE '%ING%'
   OR [Mercado de atuação] LIKE '%Alibaba Entrepreneurs Fund%'
   OR [Mercado de atuação] LIKE '%Mundi Ventures%'
   OR [Mercado de atuação] LIKE '%Doqling Capital Partners%'
   OR [Mercado de atuação]LIKE '%Activant Capital%'
   OR [Mercado de atuação] LIKE '%Andreessen Horowitz%'
   OR [Mercado de atuação] LIKE '%IDG Capital%'
   OR [Mercado de atuação] LIKE '%DST Global%';

-----------------------------------------
UPDATE [dbo].[ZyntrixTratada]
SET [Mercado de atuação] = 'Telecomunicações e Mobilidade'
WHERE[Mercado de atuação] LIKE '%TelecomunicaÃ§Ãµes e mobilidade%'

----------------------------------------------------


