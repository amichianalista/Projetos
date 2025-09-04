# %%
from datetime import datetime
import pandas as pd
import numpy as np
# %%
caminho_pasta = r'D:\GitHub\Projetos (Em andamento)\ZyntrixStartup\Tratamento(Python)'
nome_arquivo = r'\ZyntrixBruta.csv'
# %%
caminho_arquivo = caminho_pasta + nome_arquivo
remover_caracter = '.-/,'
# %%
df = pd.read_csv('ZyntrixBruta.csv')
# %%
pd.set_option('display.max_columns', None)
# %%
df.columns = df.columns.str.strip()
print (df.columns)
# %%
df = df.rename({
    'Company': 'Empresa',
    'Valuation ($B)': 'Valor de Mercado'
    'Date Joined': 'Data de Entrada',
    'Country': 'País Sede', 
    'City': 'Cidade',        
    'Industry': 'Mercado de atuação',
    'Investors': 'Investidores'
}, axis=1)

# %%
df['Data de Entrada'] = pd.to_datetime(df['Data de Entrada']).dt.strftime('%d/%m/%Y')
# %%
print(df.columns.tolist())
# %%
df.rename(columns={'Valor de Mercado': 'Valor de Mercado_Bilhões'}, inplace=True)                                                                                                                  
# %%
print('Colunas disponíveis:', df.columns.tolist())
# %%
df['Valor de Mercado_Bilhões'] = df['Valor de Mercado_Bilhões'].str.replace('$', '').astype(float)
# %%
print(df['Mercado de atuação'].unique())
# %%
mapeamento_mercado = {
    # Categorias/Setores
    'Artificial intelligence': 'Inteligência Artificial',
    'Artificial Intelligence': 'Inteligência Artificial',
    'Other': 'Outro',
    'E-commerce & direct-to-consumer': 'E-commerce e venda direta',
    'Fintech': 'Fintech (Tecnologia Financeira)',
    'Internet software & services': 'Software e serviços de internet',
    'Supply chain, logistics, & delivery': 'Cadeia de suprimentos, logística e entrega',
    'Data management & analytics': 'Gestão e análise de dados',
    'Edtech': 'Edtech (Tecnologia Educacional)',
    'Hardware': 'Hardware',
    'Consumer & retail': 'Consumo e varejo',
    'Health': 'Saúde',
    'Auto & transportation': 'Automotivo e transporte',
    'Cybersecurity': 'Segurança cibernética',
    'Mobile & telecommunications': 'Telecomunicações e mobilidade',
    'Travel': 'Viagens',
    'Internet': 'Internet',
    
    # Investidores (nomes próprios mantidos)
    'Sequoia Capital, Thoma Bravo, Softbank': 'Sequoia Capital, Thoma Bravo, Softbank',
    'Kuang-Chi': 'Kuang-Chi',
    'Tiger Global Management, Tiger Brokers, DCM Ventures': 'Tiger Global Management, Tiger Brokers, DCM Ventures',
    'Jungle Ventures, Accel, Venture Highway': 'Jungle Ventures, Accel, Venture Highway',
    'GIC. Apis Partners, Insight Partners': 'GIC, Apis Partners, Insight Partners',
    'Vision Plus Capital, GSR Ventures, ZhenFund': 'Vision Plus Capital, GSR Ventures, ZhenFund',
    'Hopu Investment Management, Boyu Capital, DC Thomson Ventures': 'Hopu Investment Management, Boyu Capital, DC Thomson Ventures',
    '500 Global, Rakuten Ventures, Golden Gate Ventures': '500 Global, Rakuten Ventures, Golden Gate Ventures',
    'Sequoia Capital China, ING, Alibaba Entrepreneurs Fund': 'Sequoia Capital China, ING, Alibaba Entrepreneurs Fund',
    'Sequoia Capital China, Shunwei Capital Partners, Qualgro': 'Sequoia Capital China, Shunwei Capital Partners, Qualgro',
    'Dragonfly Captial, Qiming Venture Partners, DST Global': 'Dragonfly Captial, Qiming Venture Partners, DST Global',
    'SingTel Innov8, Alpha JWC Ventures, Golden Gate Ventures': 'SingTel Innov8, Alpha JWC Ventures, Golden Gate Ventures',
    'Mundi Ventures, Doqling Capital Partners, Activant Capital': 'Mundi Ventures, Doqling Capital Partners, Activant Capital',
    'Vertex Ventures SE Asia, Global Founders Capital, Visa Ventures': 'Vertex Ventures SE Asia, Global Founders Capital, Visa Ventures',
    'Andreessen Horowitz, DST Global, IDG Capital': 'Andreessen Horowitz, DST Global, IDG Capital',
    "B Capital Group, Monk's Hill Ventures, Dynamic Parcel Distribution": "B Capital Group, Monk's Hill Ventures, Dynamic Parcel Distribution",
    'Temasek, Guggenheim Investments, Qatar Investment Authority': 'Temasek, Guggenheim Investments, Qatar Investment Authority'
}
# %%
df['Mercado de atuação'] = df['Mercado de atuação'].map(mapeamento_mercado)
# %%
print("Valores traduzidos:", df['Mercado de atuação'].unique())
# %%
df.to_csv('ZyntrixTratada.csv', index=False, encoding='utf-8-sig')
# %%
